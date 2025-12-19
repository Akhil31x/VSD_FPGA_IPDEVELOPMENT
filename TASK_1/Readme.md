# VSD_-TASK_1

RISC-V reference program

![Screenshot Image](https://github.com/user-attachments/assets/5e2d204f-836b-4767-88da-c82a09be205d)

VSDFPGA lab

![Screenshot Image](https://github.com/user-attachments/assets/30257db8-4956-4023-903b-4e7308b8d51a)


Answers to the four understanding questions

Q1: Where is the RISC-V program located in the vsd-riscv2 repository?
A: located in the Samples directory. 

Q2: How is the program compiled and loaded into memory?
A: compiled using the RISC-V GNU Toolchain (riscv64-unknown-elf-gcc), loaded into memory using the Spike via the Proxy Kernel (pk).

Q3: How does the RISC-V core access memory and memory-mapped IO?
A: RISC-V core accesses both memory and memory-mapped IO using standard load (lw) and store (sw) instructions.

Q4: Where would a new FPGA IP block logically integrate in this system?
A: It would logically integrate onto the system bus.

Confirmation of environment used:
GitHub Codespace only

Optional Confidence Task
Objective: Modify the C code and observe the change.
Changes Made: Modified the print message/calculation limit in sum1ton.c.

![Screenshotoptional](https://github.com/user-attachments/assets/ce11f9c8-d9e9-489e-90b4-e12fb42a1f01)



