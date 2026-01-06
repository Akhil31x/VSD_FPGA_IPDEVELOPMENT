# Task-4: Design and Validate a PWM Peripheral IP with Software Control

## Overview

In **Task-4**, I designed, implemented, and validated a **Pulse Width Modulation (PWM) peripheral IP**, comparable to PWM peripherals found in production-grade System-on-Chip (SoC) designs. PWM peripherals are widely used for applications such as LED dimming, motor control, power regulation, and waveform generation.

This task builds directly on my work from **Task-3 (Multi-Register GPIO IP)**. While Task-3 focused on static digital control, Task-4 introduces **time-dependent behavior**, requiring careful clock-driven design, deterministic counter logic, and precise software–hardware interaction.

The PWM IP is controlled entirely through **memory-mapped registers**, accessed by a RISC-V processor. The task demonstrates complete peripheral ownership, from initial planning through RTL implementation, simulation, software validation, and FPGA deployment.

---

## Repository Structure

The repository for Task-4 is organized as follows:

```
Task-4/
├── rtl/
│   ├── pwm_ip.v            # PWM peripheral IP RTL
│   ├── fpga_top.v          # FPGA top-level wrapper
│
├── test/
│   ├── pwm_tb.v            # PWM testbench
│   └── pwm.vcd             # GTKWave waveform dump
│
├── sw/
│   ├── pwm_test.c          # RISC-V C program to control PWM
│   └── pwm_test.elf        # Compiled ELF for software validation
│
├── doc/
│   └── README.md           # Task-4 documentation
│
└── screenshots/
    ├── rtl_compile.png
    ├── gtkwave_pwm.png
    ├── bitstream_gen.png
    └── iceprog_verify.png
```

---

## Task Breakdown and Navigation

The Task-4 work was completed in the following structured steps:

- **Step 1:** Study and Plan the PWM IP (Mandatory)
- **Step 2:** Implement PWM RTL with Register Control (Mandatory)
- **Step 3:** Integrate PWM IP into a SoC-Style Top Module (Mandatory)
- **Step 4:** Simulation Validation using GTKWave (Mandatory)
- **Step 5:** Software Validation using RISC-V C Program (Mandatory)
- **Step 6:** FPGA Hardware Programming and Validation (Optional but Completed)

---

## Step 1: Study and Plan (Mandatory)

### Purpose of This Step

I began Task-4 with a dedicated **analysis and planning phase**, without writing any RTL or software code. The objective was to fully understand the functional requirements of a PWM peripheral and to define a precise software–hardware contract before implementation.

This mirrors real-world SoC development workflows, where incomplete planning often leads to fragile or ambiguous peripheral behavior.

---

### Understanding PWM Requirements

A PWM peripheral must:

- Generate a periodic digital waveform
- Allow software to configure the waveform characteristics
- Operate continuously once enabled
- Behave deterministically with respect to the system clock

Unlike GPIO, PWM is inherently **time-dependent**, which requires careful design of counters, comparisons, and reset behavior.

---

### Defining the Register Map

I defined a fixed memory-mapped register interface for the PWM IP:

| Offset | Register | Access | Description |
|------|---------|--------|-------------|
| 0x00 | CTRL   | R/W | Enable and polarity control |
| 0x04 | PERIOD | R/W | Total PWM period in clock cycles |
| 0x08 | DUTY   | R/W | High-time duration in cycles |
| 0x0C | STATUS | R   | Current PWM counter value |

Key design decisions:

- All registers are 32-bit wide
- PERIOD must be ≥ 1
- DUTY must be ≤ PERIOD
- STATUS is read-only and intended for debug/visibility

This register map defines the **software–hardware contract** used throughout the task.

---

### Planned PWM Behavior

- A free-running counter increments from `0` to `PERIOD - 1`
- PWM output is HIGH when `counter < DUTY`
- PWM output is LOW otherwise
- When disabled, the output is forced to an inactive state
- Optional polarity inversion is supported

---

### Reset Behavior

On reset:

- PWM is disabled
- Counter resets to zero
- Output is driven to a safe inactive state

This ensures predictable behavior after power-up or reset.

---

### Outcome of Step 1

At the end of Step 1:

- The PWM register map was finalized
- Timing and counter behavior were clearly defined
- Software interaction was fully specified
- No RTL or software was written yet

---

## Step 2: Implement PWM RTL (Mandatory)

### Purpose of This Step

In Step 2, I implemented the **PWM peripheral IP RTL** based directly on the specifications defined in Step 1. This step focused exclusively on the IP itself and not on system integration or software.

---

### File Implemented

- `rtl/pwm_ip.v`

The PWM IP is fully self-contained and reusable.

---

### RTL Implementation Highlights

- Memory-mapped register write logic
- Address offset decoding
- Synchronous counter-based PWM generation
- Combinational PWM output logic
- Register readback support

---

### Write Logic Implementation

```verilog
always @(posedge clk) begin
    if (!rst_n) begin
        enable <= 1'b0;
        period_reg <= 32'd1;
        duty_reg <= 32'd0;
    end else if (bus_we) begin
        case (bus_addr)
            CTRL:   enable <= bus_wdata[0];
            PERIOD: period_reg <= bus_wdata;
            DUTY:   duty_reg <= bus_wdata;
        endcase
    end
end
```

---

### PWM Counter and Output Logic

```verilog
always @(posedge clk) begin
    if (!enable)
        cnt <= 0;
    else if (cnt == period_reg - 1)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

assign pwm_out = (cnt < duty_reg);
```

This logic ensures deterministic and synthesizable PWM behavior.

---

### Outcome of Step 2

- PWM IP RTL implemented
- Register behavior matches specification
- RTL compiles cleanly
- Ready for simulation validation

---

## Step 3: SoC-Style Integration (Mandatory)

### Purpose of This Step

In Step 3, I integrated the PWM IP into a **SoC-style top-level module**, making it accessible for simulation, software control, and FPGA synthesis.

---

### Integration Strategy

- PWM IP instantiated inside `fpga_top.v`
- Control signals wired in a memory-mapped style
- PWM output routed to a top-level signal

This step demonstrates system-level thinking beyond isolated IP design.

---

### Outcome of Step 3

- PWM IP successfully integrated
- Ready for simulation and software interaction
- Suitable for FPGA synthesis

---

## Step 4: Simulation Validation (Mandatory)

### Purpose of This Step

Simulation is used to validate functional correctness before hardware deployment.

---

### Testbench Used

- `test/pwm_tb.v`

The testbench:

- Programs PERIOD and DUTY
- Enables the PWM
- Runs for multiple PWM cycles
- Dumps waveforms to `pwm.vcd`

---

### GTKWave Verification

Using GTKWave, I verified:

- Correct PWM period
- Correct duty cycle
- Proper enable behavior
- Stable waveform transitions

The waveform clearly shows the PWM output HIGH for the programmed DUTY duration and LOW for the remainder of the period.

---

## Step 5: Software Validation (Mandatory)

### Purpose of This Step

This step validates **software-driven control** of the PWM IP, which is essential in real SoC designs.

---

### Firmware Used

- `sw/pwm_test.c`

The firmware configures PWM registers via memory-mapped I/O:

```c
PWM_PERIOD = 1000;
PWM_CTRL   = 1;
PWM_DUTY   = 500;
```

The successful compilation of the ELF file confirms correct register-level usage.

---

## Step 6: FPGA Hardware Validation (Optional but Completed)

### Purpose of This Step

Hardware validation demonstrates that the design:

- Synthesizes and routes correctly
- Can be programmed onto real FPGA hardware
- Represents a deployable peripheral IP

---

### FPGA Tool Flow

- **Yosys** – RTL synthesis
- **nextpnr-ice40** – Placement and routing
- **icepack** – Bitstream generation
- **iceprog** – SPI flash programming

---

### Hardware Programming Proof

The FPGA was programmed using:

```bash
sudo iceprog top.bit
```

Successful output included:

```
VERIFY OK
cdone: high
```

This confirms successful deployment of the PWM IP onto FPGA hardware.

---

## Conclusion

By completing Task-4, I demonstrated:

- Design of a real-time, clock-driven peripheral IP
- Clear register-level software–hardware contract
- Clean and reusable RTL implementation
- Simulation-based functional verification
- Software-controlled peripheral behavior
- FPGA synthesis and hardware deployment

Task-4 builds directly on Task-3 and demonstrates progression from static peripherals (GPIO) to **time-dependent peripherals (PWM)**.

---

## Final Note

This task represents full ownership of a production-style PWM peripheral IP, from initial planning through hardware deployment.

This concludes **Task-4: PWM Peripheral IP Development**.
