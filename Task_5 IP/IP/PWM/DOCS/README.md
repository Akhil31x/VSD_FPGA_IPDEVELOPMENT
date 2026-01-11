
# PWM IP – VSDSquadron FPGA

## 1. PWM IP Information

This IP is a memory-mapped Pulse Width Modulation (PWM) controller for the VSDSquadron RISC-V SoC.
It enables software running on the RISC-V core to generate a programmable PWM output signal by configuring period and duty cycle registers.
The PWM IP is a single-channel, software-controlled hardware block designed for simple and deterministic waveform generation.
The IP is fully controlled through memory-mapped registers and does not require any RTL modification by the user.

***

## 2. Key Capabilities

- Single-channel PWM generation
- Software-programmable period and duty cycle
- Memory-mapped control interface
- Deterministic counter-based PWM logic
- Continuous PWM output once enabled
- Polling-based software control model
- Suitable for LED brightness and basic motor control

***

## 3. Integration Steps

To integrate the PWM IP into the VSDSquadron SoC:

1. Copy the RTL file from `rtl/pwm_ip.v` into your SoC RTL tree.
2. Instantiate the PWM module inside the `SOC` module in `riscv.v`.
3. Assign a dedicated IO address range for PWM in the SoC address map.
4. Decode PWM accesses using address bits `[31:12]`.
5. Connect the `pwm_out` signal to an FPGA pin or LED through the constraint file.

***

## 4. Documentation Location

All PWM IP documentation is provided in the `docs/` folder.

- **IP_User_Guide**
    - Describes the functionality of the PWM IP, supported features, clock/reset assumptions, and operational limitations.
- **Register_Map**
    - Provides the complete register map including offsets, bit fields, reset values, and read/write behavior.
    - This document is the primary reference for firmware development.
- **Integration_Guide**
    - Contains step-by-step instructions to integrate the PWM IP into the VSDSquadron SoC, including address decoding rules and pin-level connections.
- **Example_Usage**
    - Explains the software programming model.
    - Provides example C code to configure PWM period, duty cycle, and enable the output.

***

## 5. Test \& Validation

- Program the FPGA with the SoC integrated with the PWM IP.
- Build and run the PWM firmware example from the `software` folder.
- Observe PWM behavior:
    - `pwm_out` toggles according to configured period.
    - Duty cycle changes when the `DUTY` register is updated.
    - PWM output remains stable while enabled.

Successful observation of these behaviors confirms correct PWM IP operation.

