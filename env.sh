#!/bin/bash
source $PATH_DEV/env.sh
export PATH_NASM="$PATH_WIN/nasm-2.14.02"

alias nasm="$PATH_NASM/nasm.exe"

echo "ASM ENV SETUP ********************************************"
echo "NASM              : $PATH_NASM	"
echo "**********************************************************"
echo "HOTKEYS **************************************************"
echo "nasm              : run Netwide Assembler"
echo "**********************************************************"
