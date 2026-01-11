# PWM IP – Register Map

This document describes the registers used to control the PWM IP.

All registers are 32-bit wide.

---

## Register List

| Offset | Register Name | Description |
|------|---------------|-------------|
| 0x00 | PWM_CTRL | Enable or disable PWM |
| 0x04 | PWM_PERIOD | Sets the PWM period |
| 0x08 | PWM_DUTY | Sets the PWM duty cycle |

---

## PWM_CTRL (0x00)

- Bit 0: Enable PWM  
  - 0 = PWM disabled  
  - 1 = PWM enabled  

---

## PWM_PERIOD (0x04)

- Defines the total PWM period in clock cycles

---

## PWM_DUTY (0x08)

- Defines how long the PWM output stays HIGH
- Value must be less than or equal to PWM_PERIOD

