# env.mk - configuration variables for the JOS lab

# '$(V)' controls whether the lab makefiles print verbose commands (the
# actual shell commands run by Make), as well as the "overview" commands
# (such as '+ cc lib/readline.c').
#
# For overview commands only, the line should read 'V = @'.
# For overview and verbose commands, the line should read 'V ='.
V = @

# If your system-standard GNU toolchain is ELF-compatible, then comment
# out the following line to use those tools (as opposed to the i386-jos-elf
# tools that the 6.828 make system looks for by default).
#

# option1 	xv6
#GCCPREFIX='/usr/local/opt/riscv-gnu-toolchain/bin/riscv64-unknown-elf-'


# option2	brew install gcc
#GCCPREFIX='/usr/bin/'

# option3	new version of i386-elf-gcc(deprecated)	error: target system not support stabs
#GCCPREFIX='/usr/local/bin/x86_64-elf-'

# option4	i386-elf-gcc
GCCPREFIX='/usr/local/bin/i386-elf-'

# If the makefile cannot find your QEMU binary, uncomment the
# following line and set it to the full path to QEMU.
#
QEMU=/Users/alsc/Desktop/6.828/qemu/bin/qemu-system-i386

