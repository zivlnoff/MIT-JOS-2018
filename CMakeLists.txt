cmake_minimum_required(VERSION 3.19)
project(JOS_2018_Fall)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)
include_directories(lab4)
include_directories(lab4/boot)
include_directories(lab4/conf)
include_directories(lab4/fs)
include_directories(lab4/inc)
include_directories(lab4/kern)
include_directories(lab4/lib)
#include_directories(lab4/obj)
#include_directories(lab4/obj/boot)
#include_directories(lab4/obj/kern)
include_directories(lab4/user)

add_executable(JOS_4018_Fall
        lab4/boot/boot.S
        lab4/boot/main.c
        lab4/boot/Makefrag
        lab4/boot/sign.pl
        lab4/conf/env.mk
        lab4/conf/lab.mk
        lab4/fs/test.c
        lab4/fs/testshell.key
        lab4/inc/assert.h
        lab4/inc/COPYRIGHT
        lab4/inc/elf.h
        lab4/inc/env.h
        lab4/inc/error.h
        lab4/inc/kbdreg.h
        lab4/inc/lib.h
        lab4/inc/memlayout.h
        lab4/inc/mmu.h
        lab4/inc/stab.h
        lab4/inc/stdarg.h
        lab4/inc/stdio.h
        lab4/inc/string.h
        lab4/inc/syscall.h
        lab4/inc/trap.h
        lab4/inc/types.h
        lab4/inc/x86.h
        lab4/kern/console.c
        lab4/kern/console.h
        lab4/kern/COPYRIGHT
        lab4/kern/cpu.h
        lab4/kern/entry.S
        lab4/kern/entrypgdir.c
        lab4/kern/env.c
        lab4/kern/env.h
        lab4/kern/init.c
        lab4/kern/kclock.c
        lab4/kern/kclock.h
        lab4/kern/kdebug.c
        lab4/kern/kdebug.h
        lab4/kern/kernel.ld
        lab4/kern/Makefrag
        lab4/kern/monitor.c
        lab4/kern/monitor.h
        lab4/kern/mpconfig.c
        lab4/kern/mpentry.S
        lab4/kern/picirq.c
        lab4/kern/picirq.h
        lab4/kern/pmap.c
        lab4/kern/pmap.h
        lab4/kern/printf.c
        lab4/kern/sched.c
        lab4/kern/sched.h
        lab4/kern/spinlock.c
        lab4/kern/spinlock.h
        lab4/kern/syscall.c
        lab4/kern/syscall.h
        lab4/kern/trap.c
        lab4/kern/trap.h
        lab4/kern/trapentry.S
        lab4/lib/console.c
        lab4/lib/entry.S
        lab4/lib/exit.c
        lab4/lib/fork.c
        lab4/lib/ipc.c
        lab4/lib/libmain.c
        lab4/lib/Makefrag
        lab4/lib/panic.c
        lab4/lib/pfentry.S
        lab4/lib/pgfault.c
        lab4/lib/printf.c
        lab4/lib/printfmt.c
        lab4/lib/readline.c
        lab4/lib/string.c
        lab4/lib/syscall.c
        #        lab4/obj/boot/boot
        #        lab4/obj/boot/boot.asm
        #        lab4/obj/boot/boot.o
        #        lab4/obj/boot/boot.out
        #        lab4/obj/boot/main.o
        #        lab4/obj/kern/console.o
        #        lab4/obj/kern/entry.o
        #        lab4/obj/kern/entrypgdir.o
        #        lab4/obj/kern/init.o
        #        lab4/obj/kern/kdebug.o
        #        lab4/obj/kern/kernel
        #        lab4/obj/kern/kernel.asm
        #        lab4/obj/kern/kernel.img
        #        lab4/obj/kern/kernel.sym
        #        lab4/obj/kern/monitor.o
        #        lab4/obj/kern/printf.o
        #        lab4/obj/kern/printfmt.o
        #        lab4/obj/kern/readline.o
        #        lab4/obj/kern/string.o
        lab4/user/badsegment.c
        lab4/user/breakpoint.c
        lab4/user/buggyhello.c
        lab4/user/buggyhello2.c
        lab4/user/divzero.c
        lab4/user/dumbfork.c
        lab4/user/evilhello.c
        lab4/user/fairness.c
        lab4/user/faultalloc.c
        lab4/user/faultallocbad.c
        lab4/user/faultdie.c
        lab4/user/faultevilhandler.c
        lab4/user/faultnostack.c
        lab4/user/faultread.c
        lab4/user/faultreadkernel.c
        lab4/user/faultread.c
        lab4/user/faultwrite.c
        lab4/user/faultwritekernel.c
        lab4/user/forktree.c
        lab4/user/hello.c
        lab4/user/idle.c
        lab4/user/Makefrag
        lab4/user/pingpong.c
        lab4/user/pingpongs.c
        lab4/user/primes.c
        lab4/user/sendpage.c
        lab4/user/softint.c
        lab4/user/spin.c
        lab4/user/stresssched.c
        lab4/user/testbss.c
        lab4/user/user.ld
        lab4/user/yield.c
        lab4/CODING
        lab4/GNUmakefile
        lab4/grade-lab4
        lab4/gradelib.py
        lab4/mergedep.pl
        )


# 你他妈的缓存的原因，老子搞了2小时多 你妈必死哦