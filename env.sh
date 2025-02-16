#!/bin/bash
source $PATH_DEV/env.sh
export PATH_NASM="$PATH_WIN/nasm-2.14.02/nasm.exe"
export PATH_VCVARS="$PATH_VS/VC/Auxiliary/Build/vcvarsall.bat"
alias nasm="$PATH_NASM"
alias link="mylink"
mylink() {
	cmd.exe /K "pushd $(wslpath -w $(pwd)) && "$(wslpath -w "$PATH_VCVARS")" x64 && link ./"$1".obj /subsystem:console /out:"$1".exe kernel32.lib legacy_stdio_definitions.lib msvcrt.lib && popd && exit"
	chmod u+x "$1".exe
	./"$1".exe
}

compile() {
	nasm -f win64 -o "$1".obj "$1".asm
	link "$1"
}

echo "ASM ENV SETUP ********************************************"
echo "NASM              : $PATH_NASM	                        "
echo "LINKER            : $PATH_VCVARS                          "
echo "**********************************************************"
echo "HOTKEYS **************************************************"
echo "nasm              : run Netwide Assembler(asm -> obj)     "
echo "link              : run Linker(obj -> exe)                "
echo "compile           : Assemble and Link(asm -> exe)         "
echo "**********************************************************"
