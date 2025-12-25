# Task-2: GPIO IP Integration & Explanation

## Address used
- Base address chosen for GPIO IP: **0x2000_0000**
- Register offset: **0x00**
- So the GPIO output register is mapped at: **0x2000_0000**

## How CPU accesses the IP
- To **write**:
  1. CPU drives address bus with 0x2000_0000.
  2. CPU drives 32-bit data on write_data bus.
  3. CPU asserts write_enable along with chip_select=1.
  4. On rising edge of clk, internal gpio_register is updated.
  5. Output gpio_out changes to the same 32-bit value.

- To **read**:
  1. CPU drives address bus with 0x2000_0000.
  2. CPU asserts read_enable with chip_select=1.
  3. Combinational logic returns gpio_register on read_data bus (last written value).

## What was validated in simulation
Using the testbench `gpio_tb.v`:

- **TEST1**:
  - Wrote 0x12345678 to the GPIO register.
  - Observed `read_data=0x12345678` and `gpio_out=0x12345678`.
- **TEST2**:
  - Wrote 0xDEADBEEF to the GPIO register.
  - Observed `read_data=0xDEADBEEF` and `gpio_out=0xDEADBEEF`.

This confirms correct register storage, write behavior, readback behavior, and output update, as required by Task-2.
