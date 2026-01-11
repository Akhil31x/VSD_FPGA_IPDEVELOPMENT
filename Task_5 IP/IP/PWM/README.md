# PWM IP

This directory contains a simple Pulse Width Modulation (PWM) peripheral IP.

The IP allows software to control the PWM period and duty cycle using
memory-mapped registers.

## Contents

- rtl/pwm_ip.v : PWM hardware implementation
- software/pwm_example.c : Example software
- docs/ : Documentation files

## Usage

1. Include the RTL file in your SoC design
2. Map the IP at a base address
3. Use the example software to configure PWM
