# PWM IP – User Guide

## Overview

The PWM IP is a single-channel, software-controlled Pulse Width Modulation
peripheral designed for FPGA-based SoC systems.

---

## Features

- Single PWM output channel
- Software-configurable period and duty cycle
- Optional polarity control
- Deterministic clock-driven operation

---

## Typical Use Cases

- LED brightness control
- Simple motor control
- Timing-based output generation

---

## Clock and Reset

- Requires a free-running system clock
- Active-low reset initializes all registers
- PWM output is disabled after reset

---

## Limitations

- Single channel only
- No interrupt support
- No prescaler
