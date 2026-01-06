# Task-4: Design and Validate a PWM Peripheral IP with Software Control

## Overview

In **Task-4**, I designed, implemented, and validated a **Pulse Width Modulation (PWM) peripheral IP**, similar to those used in real-world System-on-Chip (SoC) designs for applications such as LED dimming, motor control, and signal generation.

This task builds directly on my work from **Task-3 (Multi-Register GPIO IP)** and focuses on developing a **time-dependent peripheral**, moving beyond static digital control. The PWM IP is fully **register-controlled**, **software-configurable**, and suitable for integration into a RISC-V–based SoC.

The primary objectives of Task-4 were to demonstrate:

- Register-level peripheral design
- Clean and synthesizable RTL implementation
- Deterministic, clock-driven behavior
- Software-driven configuration using memory-mapped registers
- Simulation-based functional verification
- FPGA synthesis and hardware deployment

## Repository Structure

```
Task-4/
├── rtl/
│   ├── pwm_ip.v
│   ├── fpga_top.v
├── test/
│   ├── pwm_tb.v
│   └── pwm.vcd
├── sw/
│   ├── pwm_test.c
│   └── pwm_test.elf
├── doc/
│   └── README.md
└── screenshots/
```

## Conclusion

This task demonstrates complete ownership of a real, production-style PWM peripheral IP, from initial planning and RTL design to simulation, software control, and FPGA deployment.
