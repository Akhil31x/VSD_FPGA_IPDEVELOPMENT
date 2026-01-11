# PWM Peripheral IP 

## 1. Introduction

This repository contains a **Pulse Width Modulation (PWM) Peripheral IP**
released as a **commercial-style, reusable IP block** as part of **Task-5**.

The objective of this release is to demonstrate how a previously developed and
validated hardware IP (from Task-4) can be packaged, documented, and delivered
in a form that allows **other engineers to integrate and use it without
requiring knowledge of its internal RTL implementation**.

This IP follows industry-style practices including:
- Clean RTL separation
- Memory-mapped software control
- Clear register documentation
- Integration guidelines
- Example software usage

---

## 2. What This IP Does

The PWM IP generates a **Pulse Width Modulated digital output signal** whose
frequency and duty cycle are fully controlled by software.

By writing to memory-mapped registers, software can:
- Enable or disable the PWM output
- Configure the PWM period
- Configure the PWM duty cycle

The IP is suitable for FPGA-based SoC systems where a processor controls
peripherals through a bus interface.

---

## 3. Key Features

- Single-channel PWM output
- Software-controlled period and duty cycle
- Memory-mapped register interface
- Deterministic, clock-driven behavior
- Simple and reusable RTL design
- Suitable for FPGA-based SoCs

---

## 4. Typical Use Cases

This PWM IP can be used in a variety of applications, including:

- LED brightness control
- Simple motor speed control
- Signal generation
- Timing-based digital output control

---

## 5. Directory Structure

The IP is released using a structured, commercial-style directory layout:

