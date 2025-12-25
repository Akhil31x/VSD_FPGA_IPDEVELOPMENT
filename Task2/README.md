# Task-2: GPIO Output IP

## Address and CPU Access
- Example base address: 0x2000_0000
- Offset 0x00 → GPIO output register.
- CPU write:
  1. CPU drives addr = 0x2000_0000.
  2. CPU drives write_data with 32-bit value.
  3. CPU asserts write_enable with chip_select=1.
  4. On clk rising edge, gpio_register updates and gpio_out changes.
- CPU read:
  1. CPU drives addr = 0x2000_0000.
  2. CPU asserts read_enable with chip_select=1.
  3. Combinationally, read_data returns last written value.

## What simulation validated
- Test 1: After reset, write 0x12345678 → read_data and gpio_out both 0x12345678.
- Test 2: Then write 0xDEADBEEF → read_data and gpio_out both 0xDEADBEEF.
This confirms correct register storage, write logic, and readback logic.
