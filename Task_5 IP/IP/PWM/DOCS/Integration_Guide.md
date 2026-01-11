# PWM IP – Integration Guide

## Purpose

This document explains how to integrate the PWM IP into a larger FPGA or SoC design.

---

## RTL File

Include the following RTL file in your project:

- rtl/pwm_ip.v

---

## Clock and Reset

- The PWM IP requires a system clock (`clk`)
- Reset (`rst_n`) must be asserted low during reset
- PWM output is disabled after reset

---

## Address Mapping

The PWM IP uses memory-mapped registers.
Base address decoding is handled outside the IP.

Example base address:
0x40001000

| Address Offset | Register |
|---------------|----------|
| 0x00 | PWM_CTRL |
| 0x04 | PWM_PERIOD |
| 0x08 | PWM_DUTY |

---

## Output Signal

- `pwm_out` is the PWM output signal
- It can be connected to an LED, GPIO pin, or external logic

