# Instruction Cheat Table
## References
- [Assembly Tutorial](https://sonictk.github.io/asm_tutorial/)
- [x86 and amd64 instruction](https://www.felixcloutier.com/x86/)
- [Assemble and Diassemble](https://defuse.ca/online-x86-assembler.htm#disassembly)
- [MASM](https://learn.microsoft.com/en-us/cpp/assembler/masm/microsoft-macro-assembler-reference)
- [NASM](https://nasm.us/doc/nasmdoc3.html#section-3.2.1)
- [Compiler Explorer](https://godbolt.org/)


### Terminology?
| Directive | Description                               |
|:-:        |:-:                                        |
|`ib`       | immediate byte(8-bit)                     |
|`iw`       | immediate word(16-bit)                    |
|`id`       | immediate double word(32-bit)             |
|`REX`      | Use extended registers(r8-r15) and        |
|`W`        | Treat operands as 64-bit                  |
|`/r`       | register-to-register or memory-to-register|
-----------------------------------
### `lea`(Load Effective Address) 
- computes the effective memory address of the source operand and stores it in the destination register.
- It does *not* access memory; only performs address calculation.
- The source operand *must* be enclosed in square brackets(`[]`).
- Square brackets(`[]`) is to treat the value inside as a *memory address*.
- Example
```
lea rax, [rbx+4] ; Compute the address (rbx + 4) and store it in rax
```
-----------------------------------
### `mov`(Move)
- copies the value from a source operand to destination operand.
- It accesses memory unlike `lea`.
- Source operand shall not inclue an arithmetic operation without square brackets(`[]`).
- Example
```
mov rax, [rbx+4] ; Load the value stored at the memory address [rbx+4] into rax
```
-----------------------------------
### `test`
- 
