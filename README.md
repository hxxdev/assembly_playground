# assembly_playground
## General-purpose registers  
There are 16 GPRs on the x64 instruction set; they are referred to as
`rax, rbx, rcx, rdx, rbp, rsi, rdi, rsp, r8, r9, r10, r11 r12, r13, r14 and r15`.  
The prefix “general-purpose” is a little misleading; while they are technically general-purpose in the sense that the CPU itself doesn't govern how they should be used, some of these registers have specific purposes and need to treated in specific ways according to what is known as the OS calling conventions.
## Application Binarty Interface(ABI)
Microsoft X64 and System V ABI are both Application Binary Interfaces (ABIs) that define how low-level binary details are expressed. They differ in how they organize registers, calling conventions, and other details. 
|| Microsoft X64 | System V ABI |
|-|:-------------|:--------|
|Registers| 16 general-purpose registers and 16 XMM/YMM registers | Registers RDI, RSI, RDX, RCX, R8, R9, and XMM0–XMM7 |
|Calling convention|Four-register fast-call|Follows the AMD64 ABI calling convention|
|Use|Used in Windows|Used in Linux, FreeBSD, macOS, and Solaris|
|Features|Includes a shadow store for callees|Includes the Executable and Linkable Format (ELF)|
