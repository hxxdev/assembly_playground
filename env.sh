#!/bin/bash
source $PATH_DEV/env.sh
export PATH_NASM="$PATH_WIN/nasm-2.14.02/nasm.exe"
export PATH_VCVARS="$PATH_VS/VC/Auxiliary/Build/vcvarsall.bat"
alias nasm="$PATH_NASM"


usage() {
	echo "Usage: $0 [-d] <asm filename>"
    exit 1
}

parse_arg() {
	OPTIND=1
	DLL_MODE=0
	while getopts "hd" opt; do
		case $opt in
			d)
				DLL_MODE=1
				;;
			h)
				usage
				;;
			*)
				usage
				;;
		esac
	done
	shift $((OPTIND - 1))
	FILE_NAME="$1"
	if [ "$DLL_MODE" -eq 1 ]; then
    	LINK_OPTION_APPLICATION="/dll"
        OUTPUT_FORMAT="dll"
	else
		LINK_OPTION_APPLICATION=""
        OUTPUT_FORMAT="exe"
	fi

	if [ -z "$FILE_NAME" ]; then
        echo "Error: No file name provided."
        return 1
    fi
}


mylink() {
	echo "Generating "$FILE_NAME"."$OUTPUT_FORMAT""

	LINK_CMD="link ./"$FILE_NAME".obj "$LINK_OPTION_APPLICATION" \
					/subsystem:console /opt:ref \
					/defaultlib:ucrt.lib /defaultlib:msvcrt.lib \
					/defaultlib:legacy_stdio_definitions.lib \
					/defaultlib:kernel32.lib /defaultlib:shell32.lib \
					/nologo /incremental:no \
					/out:"$FILE_NAME"."$OUTPUT_FORMAT""

	cmd.exe /K "pushd $(wslpath -w $(pwd)) 		&&	\
			"$(wslpath -w "$PATH_VCVARS")" x64 	&& 	\
			echo $LINK_CMD						&&	\
			$LINK_CMD							&&	\
			popd 								&&	\
			exit"
	
	chmod u+x "$FILE_NAME"."$OUTPUT_FORMAT"

	if [ "$OUTPUT_FORMAT" == "exe" ]; then
    	./"$FILE_NAME"."$OUTPUT_FORMAT"
	fi
}

link() {
	parse_arg $@
	mylink
}

compile() {
	parse_arg $@
	nasm -f win64 -o "$FILE_NAME".obj "$FILE_NAME".asm
	mylink
}


echo "ASM ENV SETUP ********************************************"
echo "NASM              : $PATH_NASM	                        "
echo "LINKER            : $PATH_VCVARS                          "
echo "**********************************************************"
echo "HOTKEYS **************************************************"
echo "nasm              : run Netwide Assembler(asm -> obj)     "
echo "link              : run Linker(obj -> exe)                "
echo "link -d           : run Linker(obj -> dll)                "
echo "compile           : Assemble and Link(asm -> exe)         "
echo "compile -d        : Assemble and Link(asm -> dll)         "
echo "**********************************************************"
