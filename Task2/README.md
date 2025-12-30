# Task 2: Design & Integrate Your First Memory-Mapped IP


##  Overview
This task involves designing a **32-bit Memory-Mapped GPIO Output IP**, integrating it into the RISC-V SoC address map, and validating the design through proper simulation. The goal is to understand the fundamentals of **MMIO (Memory Mapped I/O)**, bus protocols, and IP validation.

---

##  IP Specifications

### Functionality
The `gpio_output_ip` is a synchronous peripheral that allows the CPU to drive external signals (like LEDs) by writing to a specific memory address.

- **Width:** 32-bit output.
- **Access:** Write-only (logically); Read returns the last written value.
- **Reset:** Asynchronous/Synchronous active high (configurable), clears output to `0x00000000`.

### Signal Interface
| Signal Name | Direction | Width | Description |
|:-----------:|:---------:|:-----:|:------------|
| `clk` | Input | 1 | System Clock |
| `rst` | Input | 1 | System Reset (Active High) |
| `chip_select` | Input | 1 | Address Decode Select Signal |
| `write_enable`| Input | 1 | Write Strobe |
| `read_enable` | Input | 1 | Read Strobe |
| `write_data` | Input | 32 | Data from CPU to IP |
| `read_data` | Output | 32 | Data from IP to CPU |
| `gpio_out` | Output | 32 | **External Output** (to LEDs/Pins) |

---

##  Register Map & Integration

The IP is mapped to the SoC's peripheral address space.

| Register Name | Offset | Base Address (Example) | Access | Description |
|:-------------:|:------:|:----------------------:|:------:|:------------|
| **GPIO_OUT** | `0x00` | `0x2000_0000` | R/W | Drive pins / Read last value |

> **Note:** See `docs/integration_guide.md` for Verilog integration snippets.

---

## Repository Structure

Task2/
├── docs/ #  Documentation
│ ├── gpio_ip_specification.md # Detailed IP Spec
│ ├── address_map.md # Memory Map & C Macros
│ └── integration_guide.md # SoC Integration Steps
├── sim_results/ #  Simulation Artifacts
│ ├── simulation.log # Text log of test results
│ ├── waveform.vcd # Waveform dump file
│ └── task2_waveform.png # Screenshot of waveform
├── gpio_output_ip.v # RTL Design Source
├── gpio_tb.v #  Testbench
├── Makefile #  Build Script
└── README.md #  This file


---

## How to Run Simulation

I have included a `Makefile` to automate the simulation process using **Icarus Verilog**.

### 1. Run the Testbench
<img width="923" height="187" alt="image" src="https://github.com/user-attachments/assets/5841f5cf-6ef2-4c20-9a7c-e49af17fb4ac" />


### 2. View Waveform
This command opens **GTKWave** with the generated `.vcd` file.
<img width="1917" height="1197" alt="task2_waveform" src="https://github.com/user-attachments/assets/76210be6-34b9-48b6-be32-e4d60e1b7402" />

---

## Verification Results

### Simulation Log
The testbench validates write and read-back functionality, ensuring the `gpio_out` port updates correctly.
> See full log: [`sim_results/simulation.log`](sim_results/simulation.log)

### Waveform Proof
The waveform below demonstrates the write transaction (`chip_select` + `write_enable`) updating the `gpio_out` signal.
![Waveform](sim_results/task2_waveform.png)

---

## Checklist
- [x] Designed `gpio_output_ip.v` (RTL)
- [x] Created `gpio_tb.v` (Testbench) with multiple test cases
- [x] Verified design with Icarus Verilog & GTKWave
- [x] Documented Register Map and Integration steps
- [x] Organized repository with modular structure

---
