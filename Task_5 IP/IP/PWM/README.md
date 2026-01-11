# PWM MASTER IP – SINGLE CHANNEL

---

## 1. Introduction

This project implements a **single-channel Pulse Width Modulation (PWM) IP** that allows software to generate a programmable PWM output waveform.

The PWM IP is **memory-mapped** and integrated into a simple **RV32-based SoC**, alongside GPIO and UART peripherals. The design focuses on:

- Simplicity and correctness  
- Clean register-level control  
- Deterministic timing behavior  
- End-to-end validation from **software → RTL → simulation → FPGA hardware**

---

## 2. PWM Basics

**Pulse Width Modulation (PWM)** is a technique used to generate a digital signal whose **duty cycle** can be varied to control analog-like behavior.

A PWM signal is characterized by:
- **Period** – Total time of one PWM cycle  
- **Duty Cycle** – Portion of the period where the signal is HIGH  

PWM is widely used for:
- LED brightness control  
- Motor speed control  
- Power regulation  
- Timing and waveform generation  

---

## 3. PWM Operation

In this design:

- PWM output is generated using a **counter-based approach**
- The counter increments on every system clock cycle
- Output behavior depends on the comparison between:
  - Counter value  
  - Programmed duty cycle  

### PWM Output Logic

- PWM output is **HIGH** when:
  ```
  counter < DUTY
  ```
- PWM output is **LOW** when:
  ```
  counter ≥ DUTY
  ```
- Counter resets after reaching:
  ```
  PERIOD - 1
  ```

This produces a stable and deterministic PWM waveform.

---

## 4. Register Map

**PWM Base Address:** `0x4000_1000`

| Offset | Register | Description |
|------|--------|-------------|
| 0x00 | CTRL | Enable PWM |
| 0x04 | PERIOD | PWM period value |
| 0x08 | DUTY | PWM duty cycle value |

---

### CTRL Register (0x00)

| Bit | Name | Description |
|----|----|-------------|
| 0 | EN | Enable PWM output |
| 31:1 | Reserved | Not used |

- `EN = 1` → PWM enabled  
- `EN = 0` → PWM disabled  

---

### PERIOD Register (0x04)

- Defines the **total PWM period** in clock cycles  
- Must be greater than 0  
- Counter resets after `PERIOD - 1`

---

### DUTY Register (0x08)

- Defines the number of clock cycles the output stays HIGH  
- Valid range:
  ```
  0 ≤ DUTY ≤ PERIOD
  ```

---

## 5. Address Decoding

Each peripheral in the SoC is assigned a **dedicated 4 KB address window**.

- **PWM Address Range:**  
  ```
  0x4000_1000 – 0x4000_1FFF
  ```

Address decoding strategy:
- `address[31:12]` → peripheral selection  
- `address[3:2]` → internal register selection  

This ensures clean separation between peripherals.

---

## 6. RTL Architecture

### PWM IP Overview

The PWM IP consists of:

- A free-running counter  
- Register-controlled comparison logic  
- Output gating logic  

Key RTL components:
- PERIOD register  
- DUTY register  
- CTRL register  
- PWM output comparator  

---

### PWM Timing Logic

- Counter increments every clock cycle
- Counter resets at `PERIOD - 1`
- PWM output is driven based on counter comparison

This approach ensures:
- No glitches  
- Predictable duty cycle  
- Clock-synchronous behavior  

---

## 7. SoC Integration

The PWM IP is instantiated in the SoC top module and connected to:

- System clock  
- System reset  
- Memory-mapped bus interface  
- FPGA output pin / LED  

Integration steps include:
- Instantiating PWM IP  
- Adding address decode logic  
- Updating read-data multiplexer  

---

## 8. Software Control & Verification

### Software-Based Control

A C program running on the RV32 CPU configures the PWM IP by:

1. Writing PERIOD value  
2. Writing DUTY value  
3. Enabling PWM via CTRL register  

### Example Configuration

```c
PWM_PERIOD = 1000;
PWM_DUTY   = 500;
PWM_CTRL   = 1;
```

This generates a PWM waveform with **50% duty cycle**.

---

## 9. Testbench & Simulation Verification

A Verilog testbench is used to verify:

- Counter operation  
- PWM waveform generation  
- Duty cycle correctness  
- Register write behavior  

Simulation results confirm:
- Correct HIGH/LOW timing  
- Stable waveform generation  
- Proper response to register updates  

GTKWave is used to visualize:
- Counter value  
- PWM output signal  

---

## 10. Constraint File

FPGA pins are assigned for:

- PWM output signal  
- Clock  
- Reset  

Pin assignments are defined in the constraint file used during synthesis and place-and-route.

---

## 11. Hardware Implementation

### Bitstream Generation

```bash
make build
```

This command:
- Synthesizes RTL  
- Performs place and route  
- Generates the FPGA bitstream  

---

### FPGA Programming

Ensure FPGA is detected:

```bash
lsusb
```

Flash bitstream:

```bash
sudo iceprog SOC.bin
```

---

### Hardware Observation

- PWM output is connected to an LED  
- Brightness varies according to DUTY value  
- Stable output confirms correct hardware behavior  

---

## 12. Validation Summary

The PWM IP is validated through:

- RTL simulation  
- Waveform inspection  
- Software-driven control  
- FPGA hardware deployment  

All stages confirm correct PWM functionality.

---

## 13. Conclusion

This project successfully implements a **single-channel PWM IP** with:

- Clean register interface  
- Deterministic counter-based design  
- Software-controlled operation  
- Complete simulation and hardware validation  

The design demonstrates **production-style peripheral development**, suitable for integration into FPGA-based SoC systems.
