	.file	"init.c"
	.stabs	"kern/init.c",100,0,2,.Ltext0
	.text
.Ltext0:
	.stabs	"gcc2_compiled.",60,0,0,0
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"entering test_backtrace %d\n"
.LC1:
	.string	"leaving test_backtrace %d\n"
	.text
	.align 4
	.stabs	"test_backtrace:F(0,1)=(0,1)",36,0,0,test_backtrace
	.stabs	"void:t(0,1)",128,0,0,0
	.stabs	"x:p(0,2)=r(0,2);-2147483648;2147483647;",160,0,0,8
	.stabs	"int:t(0,2)",128,0,0,0
	.globl	test_backtrace
	.type	test_backtrace, @function
test_backtrace:
	.stabn	68,0,12,.LM0-.LFBB1
.LM0:
.LFBB1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$36, %esp
	movl	8(%ebp), %ebx
	.stabn	68,0,13,.LM1-.LFBB1
.LM1:
	pushl	%ebx
	pushl	$.LC0
	call	cprintf
	.stabn	68,0,14,.LM2-.LFBB1
.LM2:
	addl	$16, %esp
	testl	%ebx, %ebx
	jle	.L2
	.stabn	68,0,15,.LM3-.LFBB1
.LM3:
	leal	-1(%ebx), %esi
.LBB10:
.LBB11:
	.stabn	68,0,13,.LM4-.LFBB1
.LM4:
	subl	$8, %esp
	pushl	%esi
	pushl	$.LC0
	call	cprintf
	.stabn	68,0,14,.LM5-.LFBB1
.LM5:
	addl	$16, %esp
	testl	%esi, %esi
	je	.L3
	.stabn	68,0,15,.LM6-.LFBB1
.LM6:
	leal	-2(%ebx), %edi
.LBB12:
.LBB13:
	.stabn	68,0,13,.LM7-.LFBB1
.LM7:
	subl	$8, %esp
	pushl	%edi
	pushl	$.LC0
	call	cprintf
	.stabn	68,0,14,.LM8-.LFBB1
.LM8:
	addl	$16, %esp
	testl	%edi, %edi
	je	.L4
	.stabn	68,0,15,.LM9-.LFBB1
.LM9:
	leal	-3(%ebx), %eax
.LBB14:
.LBB15:
	.stabn	68,0,13,.LM10-.LFBB1
.LM10:
	subl	$8, %esp
	movl	%eax, -28(%ebp)
	pushl	%eax
	pushl	$.LC0
	call	cprintf
	.stabn	68,0,14,.LM11-.LFBB1
.LM11:
	addl	$16, %esp
	movl	-28(%ebp), %eax
	testl	%eax, %eax
	je	.L5
	.stabn	68,0,15,.LM12-.LFBB1
.LM12:
	leal	-4(%ebx), %edx
.LBB16:
.LBB17:
	.stabn	68,0,13,.LM13-.LFBB1
.LM13:
	subl	$8, %esp
	pushl	%edx
	movl	%edx, -32(%ebp)
	pushl	$.LC0
	call	cprintf
	.stabn	68,0,14,.LM14-.LFBB1
.LM14:
	addl	$16, %esp
	movl	-32(%ebp), %edx
	testl	%edx, %edx
	je	.L6
	.stabn	68,0,15,.LM15-.LFBB1
.LM15:
	subl	$12, %esp
	leal	-5(%ebx), %eax
	pushl	%eax
	call	test_backtrace
	addl	$16, %esp
	movl	-32(%ebp), %edx
.L7:
	.stabn	68,0,18,.LM16-.LFBB1
.LM16:
	subl	$8, %esp
	pushl	%edx
	pushl	$.LC1
	call	cprintf
	.stabn	68,0,19,.LM17-.LFBB1
.LM17:
	addl	$16, %esp
.L8:
.LBE17:
.LBE16:
	.stabn	68,0,18,.LM18-.LFBB1
.LM18:
	subl	$8, %esp
	pushl	-28(%ebp)
	pushl	$.LC1
	call	cprintf
	.stabn	68,0,19,.LM19-.LFBB1
.LM19:
	addl	$16, %esp
.L9:
.LBE15:
.LBE14:
	.stabn	68,0,18,.LM20-.LFBB1
.LM20:
	subl	$8, %esp
	pushl	%edi
	pushl	$.LC1
	call	cprintf
	.stabn	68,0,19,.LM21-.LFBB1
.LM21:
	addl	$16, %esp
	jmp	.L10
	.align 4
.L3:
.LBE13:
.LBE12:
	.stabn	68,0,17,.LM22-.LFBB1
.LM22:
	pushl	%edx
	pushl	$0
	pushl	$0
	pushl	$0
	call	mon_backtrace
	addl	$16, %esp
.L10:
	.stabn	68,0,18,.LM23-.LFBB1
.LM23:
	subl	$8, %esp
	pushl	%esi
	pushl	$.LC1
	call	cprintf
	.stabn	68,0,19,.LM24-.LFBB1
.LM24:
	addl	$16, %esp
.L11:
.LBE11:
.LBE10:
	.stabn	68,0,18,.LM25-.LFBB1
.LM25:
	subl	$8, %esp
	pushl	%ebx
	pushl	$.LC1
	call	cprintf
	.stabn	68,0,19,.LM26-.LFBB1
.LM26:
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 4
.L2:
	.stabn	68,0,17,.LM27-.LFBB1
.LM27:
	pushl	%eax
	pushl	$0
	pushl	$0
	pushl	$0
	call	mon_backtrace
	addl	$16, %esp
	jmp	.L11
	.align 4
.L5:
.LBB27:
.LBB26:
.LBB25:
.LBB24:
.LBB22:
.LBB20:
	pushl	%eax
	pushl	$0
	pushl	$0
	pushl	$0
	call	mon_backtrace
	addl	$16, %esp
	jmp	.L8
	.align 4
.L4:
.LBE20:
.LBE22:
	pushl	%ecx
	pushl	$0
	pushl	$0
	pushl	$0
	call	mon_backtrace
	addl	$16, %esp
	jmp	.L9
	.align 4
.L6:
	movl	%edx, -32(%ebp)
.LBB23:
.LBB21:
.LBB19:
.LBB18:
	pushl	%eax
	pushl	$0
	pushl	$0
	pushl	$0
	call	mon_backtrace
	addl	$16, %esp
	movl	-32(%ebp), %edx
	jmp	.L7
.LBE18:
.LBE19:
.LBE21:
.LBE23:
.LBE24:
.LBE25:
.LBE26:
.LBE27:
	.size	test_backtrace, .-test_backtrace
	.stabs	"x:r(0,2)",64,0,0,3
.Lscope1:
	.section	.rodata.str1.1
.LC2:
	.string	"6828 decimal is %o octal!\n"
.LC3:
	.string	"H%x Wo%s!\n"
	.text
	.align 4
	.stabs	"i386_init:F(0,1)",36,0,0,i386_init
	.globl	i386_init
	.type	i386_init, @function
i386_init:
	.stabn	68,0,23,.LM28-.LFBB2
.LM28:
.LFBB2:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	.stabn	68,0,35,.LM29-.LFBB2
.LM29:
	call	cons_init
	.stabn	68,0,37,.LM30-.LFBB2
.LM30:
	subl	$8, %esp
	pushl	$6828
	pushl	$.LC2
	call	cprintf
	.stabn	68,0,40,.LM31-.LFBB2
.LM31:
	movl	$6581362, -12(%ebp)
	.stabn	68,0,41,.LM32-.LFBB2
.LM32:
	addl	$12, %esp
	leal	-12(%ebp), %eax
	pushl	%eax
	pushl	$57616
	pushl	$.LC3
	call	cprintf
	.stabn	68,0,44,.LM33-.LFBB2
.LM33:
	movl	$5, (%esp)
	call	test_backtrace
	addl	$16, %esp
	.align 4
.L15:
	.stabn	68,0,48,.LM34-.LFBB2
.LM34:
	subl	$12, %esp
	pushl	$0
	call	monitor
	addl	$16, %esp
	jmp	.L15
	.size	i386_init, .-i386_init
	.stabs	"i:(0,3)=r(0,3);0;4294967295;",128,0,0,-12
	.stabs	"unsigned int:t(0,3)",128,0,0,0
	.stabn	192,0,0,.LFBB2-.LFBB2
	.stabn	224,0,0,.Lscope2-.LFBB2
.Lscope2:
	.section	.rodata.str1.1
.LC4:
	.string	"kernel panic at %s:%d: "
.LC5:
	.string	"\n"
	.text
	.align 4
	.stabs	"_panic:F(0,1)",36,0,0,_panic
	.stabs	"file:p(0,4)=*(0,5)=r(0,5);0;127;",160,0,0,8
	.stabs	"line:p(0,2)",160,0,0,12
	.stabs	"fmt:p(0,4)",160,0,0,16
	.stabs	"char:t(0,5)",128,0,0,0
	.globl	_panic
	.type	_panic, @function
_panic:
	.stabn	68,0,63,.LM35-.LFBB3
.LM35:
.LFBB3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ebx
	.stabn	68,0,66,.LM36-.LFBB3
.LM36:
	movl	panicstr, %eax
	testl	%eax, %eax
	je	.L21
	.align 4
.L19:
	.stabn	68,0,82,.LM37-.LFBB3
.LM37:
	subl	$12, %esp
	pushl	$0
	call	monitor
	addl	$16, %esp
	jmp	.L19
.L21:
	.stabn	68,0,68,.LM38-.LFBB3
.LM38:
	movl	16(%ebp), %eax
	movl	%eax, panicstr
	.stabn	68,0,71,.LM39-.LFBB3
.LM39:
/APP
/  71 "kern/init.c" 1
	cli; cld
/  0 "" 2
	.stabn	68,0,73,.LM40-.LFBB3
.LM40:
/NO_APP
	leal	20(%ebp), %ebx
	.stabn	68,0,74,.LM41-.LFBB3
.LM41:
	pushl	%eax
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC4
	call	cprintf
	.stabn	68,0,75,.LM42-.LFBB3
.LM42:
	popl	%edx
	popl	%ecx
	pushl	%ebx
	pushl	16(%ebp)
	call	vcprintf
	.stabn	68,0,76,.LM43-.LFBB3
.LM43:
	movl	$.LC5, (%esp)
	call	cprintf
	addl	$16, %esp
	jmp	.L19
	.size	_panic, .-_panic
.Lscope3:
	.section	.rodata.str1.1
.LC6:
	.string	"kernel warning at %s:%d: "
	.text
	.align 4
	.stabs	"_warn:F(0,1)",36,0,0,_warn
	.stabs	"file:p(0,4)",160,0,0,8
	.stabs	"line:p(0,2)",160,0,0,12
	.stabs	"fmt:p(0,4)",160,0,0,16
	.globl	_warn
	.type	_warn, @function
_warn:
	.stabn	68,0,87,.LM44-.LFBB4
.LM44:
.LFBB4:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$8, %esp
	.stabn	68,0,90,.LM45-.LFBB4
.LM45:
	leal	20(%ebp), %ebx
	.stabn	68,0,91,.LM46-.LFBB4
.LM46:
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC6
	call	cprintf
	.stabn	68,0,92,.LM47-.LFBB4
.LM47:
	popl	%eax
	popl	%edx
	pushl	%ebx
	pushl	16(%ebp)
	call	vcprintf
	.stabn	68,0,93,.LM48-.LFBB4
.LM48:
	movl	$.LC5, (%esp)
	call	cprintf
	.stabn	68,0,95,.LM49-.LFBB4
.LM49:
	addl	$16, %esp
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	_warn, .-_warn
.Lscope4:
	.globl	panicstr
	.section	.bss
	.align 4
	.type	panicstr, @object
	.size	panicstr, 4
panicstr:
	.zero	4
	.stabs	"panicstr:G(0,4)",32,0,0,0
	.text
	.stabs	"",100,0,0,.Letext0
.Letext0:
	.ident	"GCC: (GNU) 11.1.0"
