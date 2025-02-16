# assembly_playground
## 1. CPU
### Application Binarty Interface(ABI)
Microsoft X64 and System V ABI are both Application Binary Interfaces (ABIs) that define how low-level binary details are expressed. They differ in how they organize registers, calling conventions, and other details. 
|| Microsoft X64 | System V ABI |
|-|:-------------|:--------|
|Registers| 16 general-purpose registers and 16 XMM/YMM registers | Registers RDI, RSI, RDX, RCX, R8, R9, and XMM0–XMM7 |
|Calling convention|Four-register fast-call|Follows the AMD64 ABI calling convention|
|Use|Used in Windows|Used in Linux, FreeBSD, macOS, and Solaris|
Features|Includes a shadow store for callees|Includes the Executable and Linkable Format (ELF)|
-----------------------------------
### General-purpose registers  
There are 16 GPRs on the x64 instruction set; they are 64-bit wide; they are referred to as
`rax, rbx, rcx, rdx, rbp, rsi, rdi, rsp, r8, r9, r10, r11 r12, r13, r14 and r15`.  
The prefix “general-purpose” is a little misleading; while they are technically general-purpose in the sense that the CPU itself doesn't govern how they should be used, some of these registers have specific purposes and need to treated in specific ways according to what is known as the OS calling conventions.
```
General-purpose register Field
--------------------------------------------------------------------
<-------><-------><----------------><------------------------------>  
|   al   |   ah   |                                                |
|        ax       |                                                |
|                eax                |                              |
|                                  rax                             |
```
```
--------------------------------------------------------------------
<-------><-------><----------------><------------------------------>  
|   r8b  |                                                         |
|        r8w      |                                                |
|                r8d                |                              |
|                                  r8                              |
```
-----------------------------------
### SIMD registers
There are 16 FPRs on the x64 instruction set; they are 128-bit wide; they are referred to as `xmm0 .. xmm15`.

- 128-bit `xmm` registers were introduced by Intel in 1999 as SSE(Streaming SIMD Extensions). 
- When you execute an AVX instruction, it uses the lower 256 bits of the register (YMM).  

- 256-bit `ymm` registers were introduced as AVX(Advanced Vector Extensions).  
`AVX2` was later introduced in 2013, expanding usage of `ymm` into integer operations while `AVX` focused only on floating-point operations.  
- When you execute an SSE instruction, it operates on the lower 128 bits of the register (XMM).
- 512-bit `zmm` registers were introduced as AVX-512.  
- When you execute an AVX-512 instruction, it operates on the full 512-bit register (ZMM).

|Register Name|Size|Introduced In|
|:-:|:-:|:-:|
|XMM|128-bit|SSE|
|YMM|256-bit|AVX|
|ZMM|512-bit|AVX-512|   
```
SIMD Register Field
--------------------------------------------------------------------
<-------><-------><----------------><------------------------------>  
|       xmm       |                                                |
|               ymm                 |                              |
|                                 zmm                              |
```
-----------------------------------

### Special purpose registers
|Register Name|Size|Description|
|:-:|:-:|:-|
|`rip`| 64-bit | Points where the next instruction to be executed is at in the assembly code. |
|`rsp`| 64-bit | Points to the bottom of the stack. Calling convention shall be met.| 
|`rbp`| 64-bit | Points to the original value of `rsp`. Allows us to unwind the stack when we leaven the current scope.|
|`rfl`| 16-bit | Status register. Set after certain instructions have been executed.|
```
about rfl(flag register)

| CF | PF | AF | ZF | SF | TF | IF | DF | OF | IOPL | NT | N/A |

- CF : Carry flag     | PF : Parity flag  | AF : Adjust flag      | ZF : Zero flag
- SF : Sign flag      | TF : Trp flag     | IF : Interrupt flag   | DF : Direction flag
- OF : Overflow flag  
- IOPL : I/O privilege lvel flag(legacy)
- NT : Nested task flag(legacy)
- N/A : reserved for future use
```
| Flag | Description |
|:-:|:-|
|`DF(Description flag)`|Determines left/right direction for moving when comparing string.|
|`SF(Sign flag)`|Shows the sign of the result of an arithmetic operation. `1` means positive.|
|`ZF(Zero flag)`|Shows whether the result of operation is zero or not. `1` means zero.|
|`OF(Overflow flag)`|Set to `1` when the result did not fit in the number of bits used for the operation by the Arithmetic Logic Unit (ALU).|
|`PF(Parity flag)`|Indicates the total number of bits that are set in the result. `1` means even number of bits have been set.|
-----------------------------------

## 2. OS
### Memory Segement
<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">
  <!-- Draw the outer rectangle -->
  <rect x="30" y="50" width="500" height="540" stroke="black" fill="none" stroke-width="6"/>
    <!-- Horizontal dividers -->
    <line x1="30" y1="85" x2="530" y2="85" stroke="black" stroke-width="6"/>
    <line x1="30" y1="150" x2="530" y2="150" stroke="black" stroke-width="6"/>
    <line x1="30" y1="205" x2="530" y2="205" stroke="black" stroke-width="6"/>
    <line x1="30" y1="300" x2="530" y2="300" stroke="black" stroke-width="6" stroke-dasharray="10,10"/>
    <line x1="30" y1="435" x2="530" y2="435" stroke="black" stroke-width="6"stroke-dasharray="10,10"/>
    <!-- Texts -->
    <text x="50" y="75" font-size="25" fill="black">text(.code)</text>
    <text x="50" y="125" font-size="25" fill="black">data(.data)</text>
    <text x="50" y="185" font-size="25" fill="black">bss(uninitialized data)</text>
    <text x="50" y="260" font-size="25" fill="black">heap</text>
    <text x="50" y="510" font-size="25" fill="black">stack</text>
    <text x="0" y="20" font-size="25" fill="black">Address</text>
    <text x="0" y="50" font-size="25" fill="black">0</text>
    <text x="80" y="350" font-size="25" fill="black">call() malloc()</text>
    <text x="350" y="400" font-size="25" fill="black">rsp--</text>
    <!-- Upward Arrow -->
    <line x1="320" y1="435" x2="320" y2="380" stroke="black" stroke-width="6" marker-end="url(#arrowhead)"/> 
    <line x1="260" y1="300" x2="260" y2="355" stroke="black" stroke-width="6" marker-end="url(#arrowhead)"/> 
    <!-- Arrowhead Definition -->
    <defs>
        <marker id="arrowhead" markerWidth="3" markerHeight="3" refX="1.5" refY="1.5" orient="auto">
            <polygon points="0,3  3,1.5 0,0" fill="black"/>
        </marker>
    </defs>
</svg>
<div class="imagecaption"><b style="font-style:normal;">Figure.</b> PE, ELF executable file format</div>

| Memory Segment | Description |
|:-|-|
| Text Segment | Contains the actual assembly instructions |
| Data Segment | constants or initialized data (e.g. int a = 5; or const int a = 5;) |
| BSS Segment | variables that are uninitialzed (e.g. int a;) |
-----------------------------------
### Virtual Memory Address System
- The program asks the OS for memory, and the OS provides virtual addresses.
- The MMU translates these virtual addresses to physical addresses in RAM.
- If the data isn’t in RAM, the OS will fetch it from storage (paging).
- The TLB helps speed up the address translation process by caching recent translations.
- This process makes the program think it has access to a large amount of memory (virtual memory).
-----------------------------------
### Datatypes
|DataType|Description|C/C++|
|:-: | - | :-: |
|Bit| 0 or 1. The smallest addressable form of memory.| - |
|Nibble| 4 bits.| - |
|Byte| 8 bits.|`char`|
|WORD| On the x64 architecture, the word size is 16 bits.| `short`|
|DWORD| Short for “double word”, this means 2 × 16 bit words, which means 32 bits. | `int`, `float`|
|QWORD| Short for “quadra word”, this means 2 × 16 bit words, which means 32 bits. | `long`, `double`|
|OWORD| Short for “octa-word” this means 8 × 16 bit words, which totals 128 bits. This term is used in NASM syntax.| - |
|YWORD| Also used only in NASM syntax, this refers to 256 bits in terms of size (i.e. the size of ymm register.)| - |
| Pointers| On the x64 ISA, pointers are all 64-bit addresses.|
### Microsoft x64 Calling Convention
