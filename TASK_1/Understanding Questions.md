Answers to the four understanding questions

Q1: Where is the RISC-V program located in the vsd-riscv2 repository?
A: located in the Samples directory. 

Q2: How is the program compiled and loaded into memory?
A: compiled using the RISC-V GNU Toolchain (riscv64-unknown-elf-gcc), loaded into memory using the Spike via the Proxy Kernel (pk).

Q3: How does the RISC-V core access memory and memory-mapped IO?
A: RISC-V core accesses both memory and memory-mapped IO using standard load (lw) and store (sw) instructions.

Q4: Where would a new FPGA IP block logically integrate in this system?
A: It would logically integrate onto the system bus.
