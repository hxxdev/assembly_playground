# assembly_playground
This document is rewritten based on [sonictk's artice](https://sonictk.github.io/asm_tutorial/)
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
-----------------------------------
### Microsoft x64 Calling Convention

What is calling convention?
- Strict guidelines that our assembly code must adhere to in order for the OS to be able to run our code.  

For x64 calling convention document, refer to [Microsoft Guide](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention).

#### Alignment requirements
Most data structures must be aligned to a specific boundary.
For example, stack pointer `rsp` must be aligend to a 16-byte boundary.
#### Function parameters and return values
There are some rules that dictates how functions should be called and how they sould return their results.
#### Integer arugments
The first four integer arguments are passed in registers. Integer values are passed in left-to-right order in `rcx`, `rdx`, `r8` and `r9`. Arugments five or higher are passed on the stack.

For example, let's assume we are calling the function `foo` defined below.
```C
void foo(int a, int b, int c, int d, int e)
{
    /// Some stuff happens here with the inputs passed in...
    return;
}
```
Before calling `foo()`, we must pass `a`, `b`, `c`, and `d` to registers `rcx`, `rdx`, `r8`, and `r9` and `e` to stack.
| argument | register |
| :-: | :-: |
| a | rcx | 
| b | rdx | 
| c | r8 | 
| d | r9 | 
| e | stack |

#### Floating-point arguments
Floating-point arguments are passed to `xmm0`, `xmm1`, `xmm2` and `xmm3`.
```C
void foo_fp(float a, float b, float c, float d, float e)
{
    // Do something
    return;
}
```
| argument | register |
| :-: | :-: |
| a | xmm0 | 
| b | xmm1 | 
| c | xmm2 | 
| d | xmm3 | 
| e | stack |

#### Mixing arugment types

```C
void foo_fp(float a, float b, float c, float d, float e)
{
    // Do something
    return;
}
```
| argument | register |
| :-: | :-: |
| a | rcx | 
| b | rdx | 
| c | xmm2 | 
| d | r9 | 
| e | stack |

#### Other argument types
- Intrinsic types, arrays, and strings are never passed into a register. A point to their memory locations is passed to a register.
- Structs/unions 8/16/32/64 bits in size may be passed as if they were integers of the same size. Those of other sizes are passed as a pointer as well.
- For variadic arguments (i.e. `foo_var(int a, ...)`), the aforementioned conventions apply depending on the type of the arguments that are passed in. However, for floating-point values, both the integer and floating-point registers must have the same argument's value, in case the callee expects the value in the integer registers.
- For unprototyped functions (e.g. forward-declarations), the caller passes integer values as integers and floating-point values as double-precision. The same rule about floating-point values needing to be in both the integer and floating-point registers applies as well.

#### Return values
- Any scalar return value less than 64-bit is passed to `rax`.
- Any floating return value is passed to `xmm0`.
- Any user-defined type return value with a size of 1/2/4/8/16/32/64-bit is passed to `rax`. Otherwise, a pointer to its memory shall be passed to `rcx` before function call.
```C
struct Foo
{
    int a, b, c; // Total of 96 bits. Too big to fit in one of the GPRs.
}

Foo foo_struct(int a, float b, int c)
{
    // Stuff happens...
    return result; // This is a `Foo` struct.
}

Foo myStruct = foo_struct(1, 2.0f, 3);
```
| argument | register |
| :-: | :-: |
| *myStruct | rcx|
| 1 | rdx | 
| 2.0f |  xmm2 | 
| 3 | r9 | 

#### Volatile and non-volatile
Registers are either volatile or non-volatile.  

###### Volatile  
- Volatile registers are subject to change and are not guaranteed to be preserved between function calls and scope changes.
- `rax`, `rcx`, `rdx`, `r8`, `r9`, `r10`, and `r11` registers are considered volatile.
###### Non-volatile
- Non-volatile registers shall be guaranteed to *preserve* valid values. Therefore, we are responsible for *preserving* the state of the registers.
- `rbx`, `rbp`, `rdi`, `rsi`, `rsp`, and `r12~15` registers are considered non-volatile.

#### The shadow space(home space)
Under the Microsoft x64 calling convention, there is a unique concept of what's known as a shadow space, also referred to as a home space. This is a space that is reserved every time you enter a function and is equal to at least 32 bytes (which is enough space to hold 4 arguments). This space must be reserved whenever you're making use of the stack, since it's what is reserved for things leaving the register values on the stack for debuggers to inspect later on. While the calling convention does not explicitly require the callee to use the shadow space, you should allocate it regardless when you are utilizing the stack, especially in a non-leaf function.

Also, as a reminder, no matter how much space you allocate for the shadow space and your own function's variables, you still need to ensure that the stack pointer is aligned on a 16-byte boundary after all is said and done.


-----------------------------------


## Hello, World

```C
bits 64
default rel

segment .data
    msg db "Hello world!", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess
extern _CRT_INIT

extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    call    _CRT_INIT

    lea     rcx, [msg]
    call    printf

    xor     rax, rax
    call    ExitProcess
```

## Addressing mode
- immediate addressing
mov rax, 0
- register addressing
mov rax, rbx
- indirect register addressing
```
mov rax, [rbx]
```
- rip-relative addressing

