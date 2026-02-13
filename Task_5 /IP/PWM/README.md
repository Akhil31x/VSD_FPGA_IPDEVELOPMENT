# PWM IP – VSDSquadron FPGA

---

## 1. IP Overview (What is this IP?)

This IP implements a **single-channel Pulse Width Modulation (PWM) controller** for the **VSDSquadron RISC-V SoC**.  
It allows firmware running on the RISC-V processor to generate a programmable PWM output signal by configuring period and duty-cycle registers through a memory-mapped interface.

The PWM IP is intended for **simple, deterministic waveform generation** where precise timing control is required without complex hardware dependencies.

### Typical Use Cases
- LED brightness control  
- Basic motor speed control  
- Power regulation experiments  
- Timing-based digital signal generation  

### Why Use This IP
- Software-controlled waveform generation  
- Simple register interface  
- Easily reusable across SoC designs  
- No RTL modification required by end users  

---

## 2. Feature Summary

- Single-channel PWM output  
- Counter-based PWM generation  
- Programmable period and duty cycle  
- 32-bit wide registers  
- Memory-mapped control interface  
- Polling-based software control  
- Synchronous operation with system clock  

### Clock Assumptions
- Operates on the system clock provided by the SoC  
- Assumes a free-running, stable clock  

### Limitations
- Single PWM channel only  
- No interrupt support  
- No prescaler or clock divider  
- Duty cycle resolution limited by system clock  

---

## 3. Block Diagram (Logical View)

```
           +----------------------+
           |        CPU Bus       |
           +----------+-----------+
                      |
              Address / Data
                      |
              +-------v-------+
              | Register      |
              | Decode Logic  |
              +-------+-------+
                      |
              +-------v-------+
              | PWM Counter   |
              | & Comparator |
              +-------+-------+
                      |
                 +----v----+
                 | pwm_out |
                 +---------+
```

---

## 4. Register Map (Mandatory)

**PWM Base Address:** `0x4000_1000`  
All registers are **32-bit wide**.

| Offset | Register | R/W | Reset Value | Description |
|------|--------|----|------------|-------------|
| 0x00 | CTRL   | R/W | 0x00000000 | Enable control |
| 0x04 | PERIOD | R/W | 0x00000000 | PWM period |
| 0x08 | DUTY   | R/W | 0x00000000 | PWM duty cycle |

### CTRL Register (0x00)
- Bit 0 : EN  
  - 0 = PWM disabled  
  - 1 = PWM enabled  

### PERIOD Register (0x04)
- Defines total PWM period in clock cycles  
- Counter resets after `PERIOD - 1`  

### DUTY Register (0x08)
- Defines number of cycles pwm_out stays HIGH  
- Must satisfy: `DUTY <= PERIOD`  

---

## 5. Software Programming Model

The PWM IP is fully software-controlled using memory-mapped registers.

### Typical Initialization Sequence
1. Write desired value to `PERIOD`
2. Write desired value to `DUTY`
3. Set `CTRL.EN = 1` to start PWM
4. Update `DUTY` dynamically if required

### Polling Model
- PWM runs continuously once enabled  
- No status or interrupt flags  
- Software may update registers at runtime  

---

## 6. Integration Guide (Very Important)

### Required RTL File
- `rtl/pwm_ip.v`

### Integration Steps
1. Include `pwm_ip.v` in the SoC RTL project
2. Instantiate the PWM IP inside the `SOC` module (`riscv.v`)
3. Assign a dedicated IO address range (4 KB)
4. Decode PWM access using `mem_addr[31:12]`
5. Connect `pwm_out` to a top-level signal

### Exposed Signals
- `clk` : System clock  
- `rst_n` : Active-low reset  
- `pwm_out` : PWM output signal  

---

## 7. Board-Level Usage (VSDSquadron FPGA)

- `pwm_out` should be connected to:
  - An LED, or
  - A header pin for external devices  

### Constraint File Requirement
The PWM output pin must be defined in the FPGA constraint file to observe the signal on hardware.

---

## 8. Example Software (Mandatory)

```c
#define PWM_BASE   0x40001000
#define PWM_CTRL   (*(volatile unsigned int *)(PWM_BASE + 0x00))
#define PWM_PERIOD (*(volatile unsigned int *)(PWM_BASE + 0x04))
#define PWM_DUTY   (*(volatile unsigned int *)(PWM_BASE + 0x08))

int main() {
    PWM_PERIOD = 1000;
    PWM_DUTY   = 500;
    PWM_CTRL   = 1;

    while (1);
}
```

---

## 9. Validation & Verification

### 9.1 Simulation Validation (GTKWave)

The PWM IP was verified using a dedicated Verilog testbench and GTKWave waveform analysis. The simulation validates correct **memory-mapped register access**, **counter operation**, and **PWM waveform generation**.

---

### 9.1.1 Register Write Verification

The waveform confirms correct write transactions from the bus interface to the PWM registers.

**Observed signals**
- `bus_addr`
- `bus_wdata`
- `bus_we`

**Observed behavior**
- `bus_addr` selects valid PWM register offsets
- `bus_we` asserts only during valid write cycles
- `bus_wdata` carries the programmed values

This confirms proper bus decoding and register write handling.

---

### 9.1.2 Internal Register Update Verification

Internal PWM registers update correctly after bus writes.

**Observed signals**
- `period_reg`
- `duty_reg`

**Observed behavior**
- `period_reg` loads the programmed period value
- `duty_reg` updates to the programmed duty-cycle value
- No unintended register modifications occur

This validates correct offset handling and stable register storage.

---

### 9.1.3 PWM Signal Generation Verification

PWM output generation is verified using waveform inspection.

**Observed signals**
- `cnt`
- `pwm_out`

**Observed behavior**
- `cnt` increments from `0` to `PERIOD-1`
- `cnt` resets cleanly at the period boundary
- `pwm_out` is HIGH when `cnt < duty_reg`
- `pwm_out` is LOW when `cnt ≥ duty_reg`

The duty-cycle variation is clearly visible in the waveform, confirming correct PWM logic.

---

## 9.2 Hardware Validation 

The SoC with the integrated PWM IP was synthesized and programmed on the **FPGA**.

**Build and programming flow**
- Yosys synthesis completed successfully
- nextpnr placement and routing completed without errors
- icetime timing analysis passed
- icepack generated the FPGA bitstream
- iceprog successfully flashed the FPGA

The PWM output was routed to an on-board LED, demonstrating real hardware operation.

---

## 9.3 End-to-End System Integration Proof

The complete software-to-hardware flow was validated:

1. RISC-V firmware writes to `PWM_BASE + register_offset`
2. SoC address decoder asserts `is_pwm`
3. `pwm_we` is generated from the bus write mask
4. PWM internal registers update correctly
5. PWM counter runs based on programmed PERIOD
6. PWM output reflects programmed DUTY cycle
7. FPGA LED responds to PWM output

This confirms full **end-to-end integration** from software to physical hardware.

---

## 9.4 Task-4 and Task-5 Compliance Summary

This implementation fully satisfies the Task-4 and Task-5 requirements:

- ✔ Enforced **4 KB memory-mapped address window**
- ✔ Proper base address decoding using `mem_addr[31:12]`
- ✔ Clean offset-based register access inside PWM IP
- ✔ Verified RISC-V software-driven register writes
- ✔ Correct PWM waveform generation
- ✔ Simulation waveform evidence provided
- ✔ FPGA hardware validation completed

<img width="1914" height="1193" alt="Screenshot from 2026-02-14 00-22-46" src="https://github.com/user-attachments/assets/66c6a9b5-02b8-48df-a7fb-c48f2e34792b" />
Waveform confirms the PWM 

## 10. Known Limitations & Notes

- Single PWM channel only  
- No interrupt or status flag support  
- No clock prescaler  
- Assumes correct system clock frequency  

---

## 11. Validation Summary

The PWM IP is validated through:

- RTL simulation  
- Waveform inspection  
- Software-driven control  
- FPGA hardware deployment  

All stages confirm correct PWM functionality.

---
### Hardware Demonstration Video

A short demonstration video showing FPGA programming and execution of the
PWM IP on the VSDSquadron FPGA board 



https://github.com/user-attachments/assets/bfea59a3-5196-4b5e-add2-7e9528530610



https://github.com/user-attachments/assets/6a88522b-5ed8-45c9-a2d6-284a5d4bfdc9


## Conclusion

This project successfully implements a **PWM IP** with:

- Clean register interface  
- Deterministic counter-based design  
- Software-controlled operation  
- Complete simulation and hardware validation  

The design demonstrates **production-style peripheral development**, suitable for integration into FPGA-based SoC systems.
