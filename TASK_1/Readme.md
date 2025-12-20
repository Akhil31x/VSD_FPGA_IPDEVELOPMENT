# **VSD FPGA IP DEVELOPMENT Program – Task 1 Submission.**  

## Task Title - Environment Setup & RISC-V Reference Bring-Up.  

### AIM: To set up a clean development environment, validate a working RISC-V reference flow, and execute simulation-based FPGA labs as a preparation step for upcoming RTL and FPGA integration tasks.

## STEP 1 CODESPACE SETUP

+ Forked and launched the official vsd-riscv2 repository using GitHub Codespaces.  
+ Verified successful environment initialization.
![CODESPACE - SETUP](https://github.com/user-attachments/assets/d4ee880f-9f1b-4131-814a-5aba57c15c4f)

## STEP 2 RISCV REFERENCE EXECUTION
+ Compiled and executed the sample RISC-V program using: `riscv64-unknown-elf-gcc`, `spike` (ISA simulator)
+ Verified correct program output.

Sum 1 to 9 output  

![SUM 1 TO 9 ](https://github.com/user-attachments/assets/efa8345a-22a4-4069-ab51-32278ab30be0)  

Now Using GCC  

![Using GCC](https://github.com/user-attachments/assets/db2913de-1400-47ae-8ac0-45a9afb04c41)  

Output Using GCC

![Output using gcc](https://github.com/user-attachments/assets/3efc595f-204f-4449-b721-2484ae3877c1)  

## STEP 3 VSDFPGA LABS EXECUTION  

+ Cloned `vsdfpga_labs` repository inside the same Codespace.
+ Executed the `basicRISCV` lab:
     * Generated BRAM hex from firmware
     * Integrated firmware with RTL
     * Completed simulation-based build successfully
+ No FPGA hardware tools were used.


THE HEX CODE IN OUTPUT  

![The HEX code has been seen in the output](https://github.com/user-attachments/assets/825b9f3d-b13e-4a73-8fc1-3570b99374c2)  

THE BANNER PATTERN WAS ADDED TO THE RISC-V FIRMWARE SOURCE USING NANO & EXECUTED USING THE SPIKE ISA SIMULATOR, WITH THE OUTPUT DISPLAYED ON THE TERMINAL AS REQUIRED.

![The banner pattern was added to the RISC-V firmware source using nano and excuted using the spike ISA simulator, with the output displayed on the terminal](https://github.com/user-attachments/assets/a5ab90a8-ebe9-4d08-9de1-08c0a78de6b9)

THE OUTPUT BANNER PATTERN

![The VSD banner edited Pattern](https://github.com/user-attachments/assets/92d728f8-b2d3-4ee8-89d9-6d5f731daae9)  

## STEP 4 LOCAL ENVIRONMENT PREPARATION  

+ Cloned both repositories locally using Git Bash.
+ Reviewed the devcontainer Dockerfile to understand required toolchains and dependencies.
+ FPGA synthesis and programming tools were intentionally not installed at this stage.

THE REPOS HAVE BEEN CLONED TO LOCAL MACHINE USING GIT BASH

![Local system prep](https://github.com/user-attachments/assets/6b903fb5-d811-4400-b635-ffcbf2ae784d)  


## Notes
This task was completed following an industry-style workflow emphasizing environment stability, reference validation, and understanding before modification.

## Environment Used
+ GitHub Codespace (primary)
+ Git Bash on Windows (local preparation)

