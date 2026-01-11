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

## 9. Validation & Expected Output

### Expected Behavior
- PWM output toggles continuously  
- Duty cycle matches `DUTY / PERIOD`  
- LED brightness varies with duty cycle  

### Common Failure Symptoms
- LED always OFF → PWM not enabled  
- LED always ON → DUTY >= PERIOD  
- No output → pin not constrained correctly  

---

## 10. Known Limitations & Notes

- Single PWM channel only  
- No interrupt or status flag support  
- No clock prescaler  
- Assumes correct system clock frequency  

---

## Conclusion

This PWM IP provides a **simple, reusable, and software-friendly PWM solution** for the VSDSquadron RISC-V SoC.  
It satisfies commercial-style IP documentation requirements and is suitable for educational and prototyping use cases.
