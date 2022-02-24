
obj/user/softint：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	e8 3f 00 00 00       	call   800083 <__x86.get_pc_thunk.bx>
  800044:	81 c3 bc 1f 00 00    	add    $0x1fbc,%ebx
  80004a:	8b 45 08             	mov    0x8(%ebp),%eax
  80004d:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800050:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  800056:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  80005c:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005e:	85 c0                	test   %eax,%eax
  800060:	7e 08                	jle    80006a <libmain+0x30>
		binaryname = argv[0];
  800062:	8b 0a                	mov    (%edx),%ecx
  800064:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	52                   	push   %edx
  80006e:	50                   	push   %eax
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0e 00 00 00       	call   800087 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <__x86.get_pc_thunk.bx>:
  800083:	8b 1c 24             	mov    (%esp),%ebx
  800086:	c3                   	ret    

00800087 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	53                   	push   %ebx
  80008b:	83 ec 10             	sub    $0x10,%esp
  80008e:	e8 f0 ff ff ff       	call   800083 <__x86.get_pc_thunk.bx>
  800093:	81 c3 6d 1f 00 00    	add    $0x1f6d,%ebx
	sys_env_destroy(0);
  800099:	6a 00                	push   $0x0
  80009b:	e8 45 00 00 00       	call   8000e5 <sys_env_destroy>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000a6:	c9                   	leave  
  8000a7:	c3                   	ret    

008000a8 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	57                   	push   %edi
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b9:	89 c3                	mov    %eax,%ebx
  8000bb:	89 c7                	mov    %eax,%edi
  8000bd:	89 c6                	mov    %eax,%esi
  8000bf:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000c1:	5b                   	pop    %ebx
  8000c2:	5e                   	pop    %esi
  8000c3:	5f                   	pop    %edi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <sys_cgetc>:

int
sys_cgetc(void) {
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	57                   	push   %edi
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	89 d3                	mov    %edx,%ebx
  8000da:	89 d7                	mov    %edx,%edi
  8000dc:	89 d6                	mov    %edx,%esi
  8000de:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e0:	5b                   	pop    %ebx
  8000e1:	5e                   	pop    %esi
  8000e2:	5f                   	pop    %edi
  8000e3:	5d                   	pop    %ebp
  8000e4:	c3                   	ret    

008000e5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 1c             	sub    $0x1c,%esp
  8000ee:	e8 66 00 00 00       	call   800159 <__x86.get_pc_thunk.ax>
  8000f3:	05 0d 1f 00 00       	add    $0x1f0d,%eax
  8000f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  8000fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800100:	8b 55 08             	mov    0x8(%ebp),%edx
  800103:	b8 03 00 00 00       	mov    $0x3,%eax
  800108:	89 cb                	mov    %ecx,%ebx
  80010a:	89 cf                	mov    %ecx,%edi
  80010c:	89 ce                	mov    %ecx,%esi
  80010e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800110:	85 c0                	test   %eax,%eax
  800112:	7f 08                	jg     80011c <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800117:	5b                   	pop    %ebx
  800118:	5e                   	pop    %esi
  800119:	5f                   	pop    %edi
  80011a:	5d                   	pop    %ebp
  80011b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	50                   	push   %eax
  800120:	6a 03                	push   $0x3
  800122:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800125:	8d 83 86 ee ff ff    	lea    -0x117a(%ebx),%eax
  80012b:	50                   	push   %eax
  80012c:	6a 24                	push   $0x24
  80012e:	8d 83 a3 ee ff ff    	lea    -0x115d(%ebx),%eax
  800134:	50                   	push   %eax
  800135:	e8 23 00 00 00       	call   80015d <_panic>

0080013a <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	57                   	push   %edi
  80013e:	56                   	push   %esi
  80013f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800140:	ba 00 00 00 00       	mov    $0x0,%edx
  800145:	b8 02 00 00 00       	mov    $0x2,%eax
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	89 d3                	mov    %edx,%ebx
  80014e:	89 d7                	mov    %edx,%edi
  800150:	89 d6                	mov    %edx,%esi
  800152:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5f                   	pop    %edi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    

00800159 <__x86.get_pc_thunk.ax>:
  800159:	8b 04 24             	mov    (%esp),%eax
  80015c:	c3                   	ret    

0080015d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	57                   	push   %edi
  800161:	56                   	push   %esi
  800162:	53                   	push   %ebx
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	e8 18 ff ff ff       	call   800083 <__x86.get_pc_thunk.bx>
  80016b:	81 c3 95 1e 00 00    	add    $0x1e95,%ebx
	va_list ap;

	va_start(ap, fmt);
  800171:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800174:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  80017a:	8b 38                	mov    (%eax),%edi
  80017c:	e8 b9 ff ff ff       	call   80013a <sys_getenvid>
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	ff 75 08             	pushl  0x8(%ebp)
  80018a:	57                   	push   %edi
  80018b:	50                   	push   %eax
  80018c:	8d 83 b4 ee ff ff    	lea    -0x114c(%ebx),%eax
  800192:	50                   	push   %eax
  800193:	e8 d1 00 00 00       	call   800269 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800198:	83 c4 18             	add    $0x18,%esp
  80019b:	56                   	push   %esi
  80019c:	ff 75 10             	pushl  0x10(%ebp)
  80019f:	e8 63 00 00 00       	call   800207 <vcprintf>
	cprintf("\n");
  8001a4:	8d 83 d8 ee ff ff    	lea    -0x1128(%ebx),%eax
  8001aa:	89 04 24             	mov    %eax,(%esp)
  8001ad:	e8 b7 00 00 00       	call   800269 <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b5:	cc                   	int3   
  8001b6:	eb fd                	jmp    8001b5 <_panic+0x58>

008001b8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	e8 c1 fe ff ff       	call   800083 <__x86.get_pc_thunk.bx>
  8001c2:	81 c3 3e 1e 00 00    	add    $0x1e3e,%ebx
  8001c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001cb:	8b 16                	mov    (%esi),%edx
  8001cd:	8d 42 01             	lea    0x1(%edx),%eax
  8001d0:	89 06                	mov    %eax,(%esi)
  8001d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d5:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001d9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001de:	74 0b                	je     8001eb <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e0:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5d                   	pop    %ebp
  8001ea:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	68 ff 00 00 00       	push   $0xff
  8001f3:	8d 46 08             	lea    0x8(%esi),%eax
  8001f6:	50                   	push   %eax
  8001f7:	e8 ac fe ff ff       	call   8000a8 <sys_cputs>
		b->idx = 0;
  8001fc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800202:	83 c4 10             	add    $0x10,%esp
  800205:	eb d9                	jmp    8001e0 <putch+0x28>

00800207 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	53                   	push   %ebx
  80020b:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800211:	e8 6d fe ff ff       	call   800083 <__x86.get_pc_thunk.bx>
  800216:	81 c3 ea 1d 00 00    	add    $0x1dea,%ebx
	struct printbuf b;

	b.idx = 0;
  80021c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800223:	00 00 00 
	b.cnt = 0;
  800226:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023c:	50                   	push   %eax
  80023d:	8d 83 b8 e1 ff ff    	lea    -0x1e48(%ebx),%eax
  800243:	50                   	push   %eax
  800244:	e8 38 01 00 00       	call   800381 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800249:	83 c4 08             	add    $0x8,%esp
  80024c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800252:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	e8 4a fe ff ff       	call   8000a8 <sys_cputs>

	return b.cnt;
}
  80025e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800272:	50                   	push   %eax
  800273:	ff 75 08             	pushl  0x8(%ebp)
  800276:	e8 8c ff ff ff       	call   800207 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	57                   	push   %edi
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
  800283:	83 ec 2c             	sub    $0x2c,%esp
  800286:	e8 3a 06 00 00       	call   8008c5 <__x86.get_pc_thunk.cx>
  80028b:	81 c1 75 1d 00 00    	add    $0x1d75,%ecx
  800291:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800294:	89 c7                	mov    %eax,%edi
  800296:	89 d6                	mov    %edx,%esi
  800298:	8b 45 08             	mov    0x8(%ebp),%eax
  80029b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002a1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ac:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002af:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002b2:	39 d3                	cmp    %edx,%ebx
  8002b4:	72 09                	jb     8002bf <printnum+0x42>
  8002b6:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b9:	0f 87 83 00 00 00    	ja     800342 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	ff 75 18             	pushl  0x18(%ebp)
  8002c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002cb:	53                   	push   %ebx
  8002cc:	ff 75 10             	pushl  0x10(%ebp)
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002db:	ff 75 d0             	pushl  -0x30(%ebp)
  8002de:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002e1:	e8 5a 09 00 00       	call   800c40 <__udivdi3>
  8002e6:	83 c4 18             	add    $0x18,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	89 f2                	mov    %esi,%edx
  8002ed:	89 f8                	mov    %edi,%eax
  8002ef:	e8 89 ff ff ff       	call   80027d <printnum>
  8002f4:	83 c4 20             	add    $0x20,%esp
  8002f7:	eb 13                	jmp    80030c <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f9:	83 ec 08             	sub    $0x8,%esp
  8002fc:	56                   	push   %esi
  8002fd:	ff 75 18             	pushl  0x18(%ebp)
  800300:	ff d7                	call   *%edi
  800302:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800305:	83 eb 01             	sub    $0x1,%ebx
  800308:	85 db                	test   %ebx,%ebx
  80030a:	7f ed                	jg     8002f9 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	56                   	push   %esi
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	ff 75 dc             	pushl  -0x24(%ebp)
  800316:	ff 75 d8             	pushl  -0x28(%ebp)
  800319:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031c:	ff 75 d0             	pushl  -0x30(%ebp)
  80031f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800322:	89 f3                	mov    %esi,%ebx
  800324:	e8 37 0a 00 00       	call   800d60 <__umoddi3>
  800329:	83 c4 14             	add    $0x14,%esp
  80032c:	0f be 84 06 da ee ff 	movsbl -0x1126(%esi,%eax,1),%eax
  800333:	ff 
  800334:	50                   	push   %eax
  800335:	ff d7                	call   *%edi
}
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    
  800342:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800345:	eb be                	jmp    800305 <printnum+0x88>

00800347 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800351:	8b 10                	mov    (%eax),%edx
  800353:	3b 50 04             	cmp    0x4(%eax),%edx
  800356:	73 0a                	jae    800362 <sprintputch+0x1b>
		*b->buf++ = ch;
  800358:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035b:	89 08                	mov    %ecx,(%eax)
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	88 02                	mov    %al,(%edx)
}
  800362:	5d                   	pop    %ebp
  800363:	c3                   	ret    

00800364 <printfmt>:
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036d:	50                   	push   %eax
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	ff 75 0c             	pushl  0xc(%ebp)
  800374:	ff 75 08             	pushl  0x8(%ebp)
  800377:	e8 05 00 00 00       	call   800381 <vprintfmt>
}
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	c9                   	leave  
  800380:	c3                   	ret    

00800381 <vprintfmt>:
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	57                   	push   %edi
  800385:	56                   	push   %esi
  800386:	53                   	push   %ebx
  800387:	83 ec 2c             	sub    $0x2c,%esp
  80038a:	e8 f4 fc ff ff       	call   800083 <__x86.get_pc_thunk.bx>
  80038f:	81 c3 71 1c 00 00    	add    $0x1c71,%ebx
  800395:	8b 75 0c             	mov    0xc(%ebp),%esi
  800398:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039b:	e9 fb 03 00 00       	jmp    80079b <.L35+0x48>
		padc = ' ';
  8003a0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003ab:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003be:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8d 47 01             	lea    0x1(%edi),%eax
  8003c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c7:	0f b6 17             	movzbl (%edi),%edx
  8003ca:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cd:	3c 55                	cmp    $0x55,%al
  8003cf:	0f 87 4e 04 00 00    	ja     800823 <.L22>
  8003d5:	0f b6 c0             	movzbl %al,%eax
  8003d8:	89 d9                	mov    %ebx,%ecx
  8003da:	03 8c 83 68 ef ff ff 	add    -0x1098(%ebx,%eax,4),%ecx
  8003e1:	ff e1                	jmp    *%ecx

008003e3 <.L71>:
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e6:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003ea:	eb d5                	jmp    8003c1 <vprintfmt+0x40>

008003ec <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ef:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f3:	eb cc                	jmp    8003c1 <vprintfmt+0x40>

008003f5 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	0f b6 d2             	movzbl %dl,%edx
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800400:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800403:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800407:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040d:	83 f9 09             	cmp    $0x9,%ecx
  800410:	77 55                	ja     800467 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800412:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800415:	eb e9                	jmp    800400 <.L29+0xb>

00800417 <.L26>:
			precision = va_arg(ap, int);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8d 40 04             	lea    0x4(%eax),%eax
  800425:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042f:	79 90                	jns    8003c1 <vprintfmt+0x40>
				width = precision, precision = -1;
  800431:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800437:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80043e:	eb 81                	jmp    8003c1 <vprintfmt+0x40>

00800440 <.L27>:
  800440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	ba 00 00 00 00       	mov    $0x0,%edx
  80044a:	0f 49 d0             	cmovns %eax,%edx
  80044d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800453:	e9 69 ff ff ff       	jmp    8003c1 <vprintfmt+0x40>

00800458 <.L23>:
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800462:	e9 5a ff ff ff       	jmp    8003c1 <vprintfmt+0x40>
  800467:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80046a:	eb bf                	jmp    80042b <.L26+0x14>

0080046c <.L33>:
			lflag++;
  80046c:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800473:	e9 49 ff ff ff       	jmp    8003c1 <vprintfmt+0x40>

00800478 <.L30>:
			putch(va_arg(ap, int), putdat);
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 78 04             	lea    0x4(%eax),%edi
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	56                   	push   %esi
  800482:	ff 30                	pushl  (%eax)
  800484:	ff 55 08             	call   *0x8(%ebp)
			break;
  800487:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048d:	e9 06 03 00 00       	jmp    800798 <.L35+0x45>

00800492 <.L32>:
			err = va_arg(ap, int);
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	8d 78 04             	lea    0x4(%eax),%edi
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	99                   	cltd   
  80049b:	31 d0                	xor    %edx,%eax
  80049d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049f:	83 f8 06             	cmp    $0x6,%eax
  8004a2:	7f 27                	jg     8004cb <.L32+0x39>
  8004a4:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8004ab:	85 d2                	test   %edx,%edx
  8004ad:	74 1c                	je     8004cb <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004af:	52                   	push   %edx
  8004b0:	8d 83 fb ee ff ff    	lea    -0x1105(%ebx),%eax
  8004b6:	50                   	push   %eax
  8004b7:	56                   	push   %esi
  8004b8:	ff 75 08             	pushl  0x8(%ebp)
  8004bb:	e8 a4 fe ff ff       	call   800364 <printfmt>
  8004c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c6:	e9 cd 02 00 00       	jmp    800798 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004cb:	50                   	push   %eax
  8004cc:	8d 83 f2 ee ff ff    	lea    -0x110e(%ebx),%eax
  8004d2:	50                   	push   %eax
  8004d3:	56                   	push   %esi
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	e8 88 fe ff ff       	call   800364 <printfmt>
  8004dc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004df:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004e2:	e9 b1 02 00 00       	jmp    800798 <.L35+0x45>

008004e7 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	83 c0 04             	add    $0x4,%eax
  8004ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004f5:	85 ff                	test   %edi,%edi
  8004f7:	8d 83 eb ee ff ff    	lea    -0x1115(%ebx),%eax
  8004fd:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800500:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800504:	0f 8e b5 00 00 00    	jle    8005bf <.L36+0xd8>
  80050a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80050e:	75 08                	jne    800518 <.L36+0x31>
  800510:	89 75 0c             	mov    %esi,0xc(%ebp)
  800513:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800516:	eb 6d                	jmp    800585 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 cc             	pushl  -0x34(%ebp)
  80051e:	57                   	push   %edi
  80051f:	e8 bd 03 00 00       	call   8008e1 <strnlen>
  800524:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800527:	29 c2                	sub    %eax,%edx
  800529:	89 55 c8             	mov    %edx,-0x38(%ebp)
  80052c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80052f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800536:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800539:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053b:	eb 10                	jmp    80054d <.L36+0x66>
					putch(padc, putdat);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	56                   	push   %esi
  800541:	ff 75 e0             	pushl  -0x20(%ebp)
  800544:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800547:	83 ef 01             	sub    $0x1,%edi
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	85 ff                	test   %edi,%edi
  80054f:	7f ec                	jg     80053d <.L36+0x56>
  800551:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800554:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800557:	85 d2                	test   %edx,%edx
  800559:	b8 00 00 00 00       	mov    $0x0,%eax
  80055e:	0f 49 c2             	cmovns %edx,%eax
  800561:	29 c2                	sub    %eax,%edx
  800563:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800566:	89 75 0c             	mov    %esi,0xc(%ebp)
  800569:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80056c:	eb 17                	jmp    800585 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  80056e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800572:	75 30                	jne    8005a4 <.L36+0xbd>
					putch(ch, putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 0c             	pushl  0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	ff 55 08             	call   *0x8(%ebp)
  80057e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800581:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800585:	83 c7 01             	add    $0x1,%edi
  800588:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80058c:	0f be c2             	movsbl %dl,%eax
  80058f:	85 c0                	test   %eax,%eax
  800591:	74 52                	je     8005e5 <.L36+0xfe>
  800593:	85 f6                	test   %esi,%esi
  800595:	78 d7                	js     80056e <.L36+0x87>
  800597:	83 ee 01             	sub    $0x1,%esi
  80059a:	79 d2                	jns    80056e <.L36+0x87>
  80059c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80059f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005a2:	eb 32                	jmp    8005d6 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a4:	0f be d2             	movsbl %dl,%edx
  8005a7:	83 ea 20             	sub    $0x20,%edx
  8005aa:	83 fa 5e             	cmp    $0x5e,%edx
  8005ad:	76 c5                	jbe    800574 <.L36+0x8d>
					putch('?', putdat);
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	ff 75 0c             	pushl  0xc(%ebp)
  8005b5:	6a 3f                	push   $0x3f
  8005b7:	ff 55 08             	call   *0x8(%ebp)
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	eb c2                	jmp    800581 <.L36+0x9a>
  8005bf:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005c2:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005c5:	eb be                	jmp    800585 <.L36+0x9e>
				putch(' ', putdat);
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	56                   	push   %esi
  8005cb:	6a 20                	push   $0x20
  8005cd:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005d0:	83 ef 01             	sub    $0x1,%edi
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	85 ff                	test   %edi,%edi
  8005d8:	7f ed                	jg     8005c7 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	e9 b3 01 00 00       	jmp    800798 <.L35+0x45>
  8005e5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005eb:	eb e9                	jmp    8005d6 <.L36+0xef>

008005ed <.L31>:
  8005ed:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005f0:	83 f9 01             	cmp    $0x1,%ecx
  8005f3:	7e 40                	jle    800635 <.L31+0x48>
		return va_arg(*ap, long long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 50 04             	mov    0x4(%eax),%edx
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 08             	lea    0x8(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80060c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800610:	79 55                	jns    800667 <.L31+0x7a>
				putch('-', putdat);
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	56                   	push   %esi
  800616:	6a 2d                	push   $0x2d
  800618:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80061b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80061e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800621:	f7 da                	neg    %edx
  800623:	83 d1 00             	adc    $0x0,%ecx
  800626:	f7 d9                	neg    %ecx
  800628:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800630:	e9 48 01 00 00       	jmp    80077d <.L35+0x2a>
	else if (lflag)
  800635:	85 c9                	test   %ecx,%ecx
  800637:	75 17                	jne    800650 <.L31+0x63>
		return va_arg(*ap, int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	99                   	cltd   
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb bc                	jmp    80060c <.L31+0x1f>
		return va_arg(*ap, long);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	99                   	cltd   
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	eb a5                	jmp    80060c <.L31+0x1f>
			num = getint(&ap, lflag);
  800667:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80066d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800672:	e9 06 01 00 00       	jmp    80077d <.L35+0x2a>

00800677 <.L37>:
  800677:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80067a:	83 f9 01             	cmp    $0x1,%ecx
  80067d:	7e 18                	jle    800697 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	8b 48 04             	mov    0x4(%eax),%ecx
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800692:	e9 e6 00 00 00       	jmp    80077d <.L35+0x2a>
	else if (lflag)
  800697:	85 c9                	test   %ecx,%ecx
  800699:	75 1a                	jne    8006b5 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 10                	mov    (%eax),%edx
  8006a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b0:	e9 c8 00 00 00       	jmp    80077d <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 ae 00 00 00       	jmp    80077d <.L35+0x2a>

008006cf <.L34>:
  8006cf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006d2:	83 f9 01             	cmp    $0x1,%ecx
  8006d5:	7e 3d                	jle    800714 <.L34+0x45>
		return va_arg(*ap, long long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 50 04             	mov    0x4(%eax),%edx
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 40 08             	lea    0x8(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8006ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f2:	79 52                	jns    800746 <.L34+0x77>
                putch('-', putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	56                   	push   %esi
  8006f8:	6a 2d                	push   $0x2d
  8006fa:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  8006fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800700:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800703:	f7 da                	neg    %edx
  800705:	83 d1 00             	adc    $0x0,%ecx
  800708:	f7 d9                	neg    %ecx
  80070a:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
  800712:	eb 69                	jmp    80077d <.L35+0x2a>
	else if (lflag)
  800714:	85 c9                	test   %ecx,%ecx
  800716:	75 17                	jne    80072f <.L34+0x60>
		return va_arg(*ap, int);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800720:	99                   	cltd   
  800721:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
  80072d:	eb bf                	jmp    8006ee <.L34+0x1f>
		return va_arg(*ap, long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	99                   	cltd   
  800738:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
  800744:	eb a8                	jmp    8006ee <.L34+0x1f>
            num = getint(&ap, lflag);
  800746:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800749:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80074c:	b8 08 00 00 00       	mov    $0x8,%eax
  800751:	eb 2a                	jmp    80077d <.L35+0x2a>

00800753 <.L35>:
			putch('0', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	56                   	push   %esi
  800757:	6a 30                	push   $0x30
  800759:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80075c:	83 c4 08             	add    $0x8,%esp
  80075f:	56                   	push   %esi
  800760:	6a 78                	push   $0x78
  800762:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80076f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800778:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800784:	57                   	push   %edi
  800785:	ff 75 e0             	pushl  -0x20(%ebp)
  800788:	50                   	push   %eax
  800789:	51                   	push   %ecx
  80078a:	52                   	push   %edx
  80078b:	89 f2                	mov    %esi,%edx
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	e8 e8 fa ff ff       	call   80027d <printnum>
			break;
  800795:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800798:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079b:	83 c7 01             	add    $0x1,%edi
  80079e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a2:	83 f8 25             	cmp    $0x25,%eax
  8007a5:	0f 84 f5 fb ff ff    	je     8003a0 <vprintfmt+0x1f>
			if (ch == '\0')
  8007ab:	85 c0                	test   %eax,%eax
  8007ad:	0f 84 91 00 00 00    	je     800844 <.L22+0x21>
			putch(ch, putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	56                   	push   %esi
  8007b7:	50                   	push   %eax
  8007b8:	ff 55 08             	call   *0x8(%ebp)
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	eb db                	jmp    80079b <.L35+0x48>

008007c0 <.L38>:
  8007c0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007c3:	83 f9 01             	cmp    $0x1,%ecx
  8007c6:	7e 15                	jle    8007dd <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 10                	mov    (%eax),%edx
  8007cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d0:	8d 40 08             	lea    0x8(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007db:	eb a0                	jmp    80077d <.L35+0x2a>
	else if (lflag)
  8007dd:	85 c9                	test   %ecx,%ecx
  8007df:	75 17                	jne    8007f8 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8b 10                	mov    (%eax),%edx
  8007e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f6:	eb 85                	jmp    80077d <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 10                	mov    (%eax),%edx
  8007fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800802:	8d 40 04             	lea    0x4(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800808:	b8 10 00 00 00       	mov    $0x10,%eax
  80080d:	e9 6b ff ff ff       	jmp    80077d <.L35+0x2a>

00800812 <.L25>:
			putch(ch, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	56                   	push   %esi
  800816:	6a 25                	push   $0x25
  800818:	ff 55 08             	call   *0x8(%ebp)
			break;
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	e9 75 ff ff ff       	jmp    800798 <.L35+0x45>

00800823 <.L22>:
			putch('%', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	56                   	push   %esi
  800827:	6a 25                	push   $0x25
  800829:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	89 f8                	mov    %edi,%eax
  800831:	eb 03                	jmp    800836 <.L22+0x13>
  800833:	83 e8 01             	sub    $0x1,%eax
  800836:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083a:	75 f7                	jne    800833 <.L22+0x10>
  80083c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083f:	e9 54 ff ff ff       	jmp    800798 <.L35+0x45>
}
  800844:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800847:	5b                   	pop    %ebx
  800848:	5e                   	pop    %esi
  800849:	5f                   	pop    %edi
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	53                   	push   %ebx
  800850:	83 ec 14             	sub    $0x14,%esp
  800853:	e8 2b f8 ff ff       	call   800083 <__x86.get_pc_thunk.bx>
  800858:	81 c3 a8 17 00 00    	add    $0x17a8,%ebx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800875:	85 c0                	test   %eax,%eax
  800877:	74 2b                	je     8008a4 <vsnprintf+0x58>
  800879:	85 d2                	test   %edx,%edx
  80087b:	7e 27                	jle    8008a4 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087d:	ff 75 14             	pushl  0x14(%ebp)
  800880:	ff 75 10             	pushl  0x10(%ebp)
  800883:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	8d 83 47 e3 ff ff    	lea    -0x1cb9(%ebx),%eax
  80088d:	50                   	push   %eax
  80088e:	e8 ee fa ff ff       	call   800381 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800896:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089c:	83 c4 10             	add    $0x10,%esp
}
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    
		return -E_INVAL;
  8008a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a9:	eb f4                	jmp    80089f <vsnprintf+0x53>

008008ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b4:	50                   	push   %eax
  8008b5:	ff 75 10             	pushl  0x10(%ebp)
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	ff 75 08             	pushl  0x8(%ebp)
  8008be:	e8 89 ff ff ff       	call   80084c <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <__x86.get_pc_thunk.cx>:
  8008c5:	8b 0c 24             	mov    (%esp),%ecx
  8008c8:	c3                   	ret    

008008c9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d4:	eb 03                	jmp    8008d9 <strlen+0x10>
		n++;
  8008d6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008d9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008dd:	75 f7                	jne    8008d6 <strlen+0xd>
	return n;
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ef:	eb 03                	jmp    8008f4 <strnlen+0x13>
		n++;
  8008f1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f4:	39 d0                	cmp    %edx,%eax
  8008f6:	74 06                	je     8008fe <strnlen+0x1d>
  8008f8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008fc:	75 f3                	jne    8008f1 <strnlen+0x10>
	return n;
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	53                   	push   %ebx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80090a:	89 c2                	mov    %eax,%edx
  80090c:	83 c1 01             	add    $0x1,%ecx
  80090f:	83 c2 01             	add    $0x1,%edx
  800912:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800916:	88 5a ff             	mov    %bl,-0x1(%edx)
  800919:	84 db                	test   %bl,%bl
  80091b:	75 ef                	jne    80090c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80091d:	5b                   	pop    %ebx
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	53                   	push   %ebx
  800924:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800927:	53                   	push   %ebx
  800928:	e8 9c ff ff ff       	call   8008c9 <strlen>
  80092d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	01 d8                	add    %ebx,%eax
  800935:	50                   	push   %eax
  800936:	e8 c5 ff ff ff       	call   800900 <strcpy>
	return dst;
}
  80093b:	89 d8                	mov    %ebx,%eax
  80093d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800940:	c9                   	leave  
  800941:	c3                   	ret    

00800942 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
  800947:	8b 75 08             	mov    0x8(%ebp),%esi
  80094a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094d:	89 f3                	mov    %esi,%ebx
  80094f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800952:	89 f2                	mov    %esi,%edx
  800954:	eb 0f                	jmp    800965 <strncpy+0x23>
		*dst++ = *src;
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	0f b6 01             	movzbl (%ecx),%eax
  80095c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095f:	80 39 01             	cmpb   $0x1,(%ecx)
  800962:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800965:	39 da                	cmp    %ebx,%edx
  800967:	75 ed                	jne    800956 <strncpy+0x14>
	}
	return ret;
}
  800969:	89 f0                	mov    %esi,%eax
  80096b:	5b                   	pop    %ebx
  80096c:	5e                   	pop    %esi
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	56                   	push   %esi
  800973:	53                   	push   %ebx
  800974:	8b 75 08             	mov    0x8(%ebp),%esi
  800977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80097d:	89 f0                	mov    %esi,%eax
  80097f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800983:	85 c9                	test   %ecx,%ecx
  800985:	75 0b                	jne    800992 <strlcpy+0x23>
  800987:	eb 17                	jmp    8009a0 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 07                	je     80099d <strlcpy+0x2e>
  800996:	0f b6 0a             	movzbl (%edx),%ecx
  800999:	84 c9                	test   %cl,%cl
  80099b:	75 ec                	jne    800989 <strlcpy+0x1a>
		*dst = '\0';
  80099d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a0:	29 f0                	sub    %esi,%eax
}
  8009a2:	5b                   	pop    %ebx
  8009a3:	5e                   	pop    %esi
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009af:	eb 06                	jmp    8009b7 <strcmp+0x11>
		p++, q++;
  8009b1:	83 c1 01             	add    $0x1,%ecx
  8009b4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009b7:	0f b6 01             	movzbl (%ecx),%eax
  8009ba:	84 c0                	test   %al,%al
  8009bc:	74 04                	je     8009c2 <strcmp+0x1c>
  8009be:	3a 02                	cmp    (%edx),%al
  8009c0:	74 ef                	je     8009b1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c2:	0f b6 c0             	movzbl %al,%eax
  8009c5:	0f b6 12             	movzbl (%edx),%edx
  8009c8:	29 d0                	sub    %edx,%eax
}
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	53                   	push   %ebx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	89 c3                	mov    %eax,%ebx
  8009d8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009db:	eb 06                	jmp    8009e3 <strncmp+0x17>
		n--, p++, q++;
  8009dd:	83 c0 01             	add    $0x1,%eax
  8009e0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e3:	39 d8                	cmp    %ebx,%eax
  8009e5:	74 16                	je     8009fd <strncmp+0x31>
  8009e7:	0f b6 08             	movzbl (%eax),%ecx
  8009ea:	84 c9                	test   %cl,%cl
  8009ec:	74 04                	je     8009f2 <strncmp+0x26>
  8009ee:	3a 0a                	cmp    (%edx),%cl
  8009f0:	74 eb                	je     8009dd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f2:	0f b6 00             	movzbl (%eax),%eax
  8009f5:	0f b6 12             	movzbl (%edx),%edx
  8009f8:	29 d0                	sub    %edx,%eax
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    
		return 0;
  8009fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800a02:	eb f6                	jmp    8009fa <strncmp+0x2e>

00800a04 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0e:	0f b6 10             	movzbl (%eax),%edx
  800a11:	84 d2                	test   %dl,%dl
  800a13:	74 09                	je     800a1e <strchr+0x1a>
		if (*s == c)
  800a15:	38 ca                	cmp    %cl,%dl
  800a17:	74 0a                	je     800a23 <strchr+0x1f>
	for (; *s; s++)
  800a19:	83 c0 01             	add    $0x1,%eax
  800a1c:	eb f0                	jmp    800a0e <strchr+0xa>
			return (char *) s;
	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2f:	eb 03                	jmp    800a34 <strfind+0xf>
  800a31:	83 c0 01             	add    $0x1,%eax
  800a34:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a37:	38 ca                	cmp    %cl,%dl
  800a39:	74 04                	je     800a3f <strfind+0x1a>
  800a3b:	84 d2                	test   %dl,%dl
  800a3d:	75 f2                	jne    800a31 <strfind+0xc>
			break;
	return (char *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	57                   	push   %edi
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4d:	85 c9                	test   %ecx,%ecx
  800a4f:	74 13                	je     800a64 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a51:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a57:	75 05                	jne    800a5e <memset+0x1d>
  800a59:	f6 c1 03             	test   $0x3,%cl
  800a5c:	74 0d                	je     800a6b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	fc                   	cld    
  800a62:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a64:	89 f8                	mov    %edi,%eax
  800a66:	5b                   	pop    %ebx
  800a67:	5e                   	pop    %esi
  800a68:	5f                   	pop    %edi
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    
		c &= 0xFF;
  800a6b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6f:	89 d3                	mov    %edx,%ebx
  800a71:	c1 e3 08             	shl    $0x8,%ebx
  800a74:	89 d0                	mov    %edx,%eax
  800a76:	c1 e0 18             	shl    $0x18,%eax
  800a79:	89 d6                	mov    %edx,%esi
  800a7b:	c1 e6 10             	shl    $0x10,%esi
  800a7e:	09 f0                	or     %esi,%eax
  800a80:	09 c2                	or     %eax,%edx
  800a82:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a84:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a87:	89 d0                	mov    %edx,%eax
  800a89:	fc                   	cld    
  800a8a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8c:	eb d6                	jmp    800a64 <memset+0x23>

00800a8e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	57                   	push   %edi
  800a92:	56                   	push   %esi
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a99:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a9c:	39 c6                	cmp    %eax,%esi
  800a9e:	73 35                	jae    800ad5 <memmove+0x47>
  800aa0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa3:	39 c2                	cmp    %eax,%edx
  800aa5:	76 2e                	jbe    800ad5 <memmove+0x47>
		s += n;
		d += n;
  800aa7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaa:	89 d6                	mov    %edx,%esi
  800aac:	09 fe                	or     %edi,%esi
  800aae:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab4:	74 0c                	je     800ac2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab6:	83 ef 01             	sub    $0x1,%edi
  800ab9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800abc:	fd                   	std    
  800abd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800abf:	fc                   	cld    
  800ac0:	eb 21                	jmp    800ae3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac2:	f6 c1 03             	test   $0x3,%cl
  800ac5:	75 ef                	jne    800ab6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac7:	83 ef 04             	sub    $0x4,%edi
  800aca:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad0:	fd                   	std    
  800ad1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad3:	eb ea                	jmp    800abf <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad5:	89 f2                	mov    %esi,%edx
  800ad7:	09 c2                	or     %eax,%edx
  800ad9:	f6 c2 03             	test   $0x3,%dl
  800adc:	74 09                	je     800ae7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae3:	5e                   	pop    %esi
  800ae4:	5f                   	pop    %edi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae7:	f6 c1 03             	test   $0x3,%cl
  800aea:	75 f2                	jne    800ade <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aef:	89 c7                	mov    %eax,%edi
  800af1:	fc                   	cld    
  800af2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af4:	eb ed                	jmp    800ae3 <memmove+0x55>

00800af6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800af9:	ff 75 10             	pushl  0x10(%ebp)
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 87 ff ff ff       	call   800a8e <memmove>
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	56                   	push   %esi
  800b0d:	53                   	push   %ebx
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b14:	89 c6                	mov    %eax,%esi
  800b16:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b19:	39 f0                	cmp    %esi,%eax
  800b1b:	74 1c                	je     800b39 <memcmp+0x30>
		if (*s1 != *s2)
  800b1d:	0f b6 08             	movzbl (%eax),%ecx
  800b20:	0f b6 1a             	movzbl (%edx),%ebx
  800b23:	38 d9                	cmp    %bl,%cl
  800b25:	75 08                	jne    800b2f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b27:	83 c0 01             	add    $0x1,%eax
  800b2a:	83 c2 01             	add    $0x1,%edx
  800b2d:	eb ea                	jmp    800b19 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b2f:	0f b6 c1             	movzbl %cl,%eax
  800b32:	0f b6 db             	movzbl %bl,%ebx
  800b35:	29 d8                	sub    %ebx,%eax
  800b37:	eb 05                	jmp    800b3e <memcmp+0x35>
	}

	return 0;
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4b:	89 c2                	mov    %eax,%edx
  800b4d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b50:	39 d0                	cmp    %edx,%eax
  800b52:	73 09                	jae    800b5d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b54:	38 08                	cmp    %cl,(%eax)
  800b56:	74 05                	je     800b5d <memfind+0x1b>
	for (; s < ends; s++)
  800b58:	83 c0 01             	add    $0x1,%eax
  800b5b:	eb f3                	jmp    800b50 <memfind+0xe>
			break;
	return (void *) s;
}
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	57                   	push   %edi
  800b63:	56                   	push   %esi
  800b64:	53                   	push   %ebx
  800b65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6b:	eb 03                	jmp    800b70 <strtol+0x11>
		s++;
  800b6d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b70:	0f b6 01             	movzbl (%ecx),%eax
  800b73:	3c 20                	cmp    $0x20,%al
  800b75:	74 f6                	je     800b6d <strtol+0xe>
  800b77:	3c 09                	cmp    $0x9,%al
  800b79:	74 f2                	je     800b6d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b7b:	3c 2b                	cmp    $0x2b,%al
  800b7d:	74 2e                	je     800bad <strtol+0x4e>
	int neg = 0;
  800b7f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b84:	3c 2d                	cmp    $0x2d,%al
  800b86:	74 2f                	je     800bb7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b88:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b8e:	75 05                	jne    800b95 <strtol+0x36>
  800b90:	80 39 30             	cmpb   $0x30,(%ecx)
  800b93:	74 2c                	je     800bc1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b95:	85 db                	test   %ebx,%ebx
  800b97:	75 0a                	jne    800ba3 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b99:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b9e:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba1:	74 28                	je     800bcb <strtol+0x6c>
		base = 10;
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bab:	eb 50                	jmp    800bfd <strtol+0x9e>
		s++;
  800bad:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb5:	eb d1                	jmp    800b88 <strtol+0x29>
		s++, neg = 1;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	bf 01 00 00 00       	mov    $0x1,%edi
  800bbf:	eb c7                	jmp    800b88 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc5:	74 0e                	je     800bd5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bc7:	85 db                	test   %ebx,%ebx
  800bc9:	75 d8                	jne    800ba3 <strtol+0x44>
		s++, base = 8;
  800bcb:	83 c1 01             	add    $0x1,%ecx
  800bce:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd3:	eb ce                	jmp    800ba3 <strtol+0x44>
		s += 2, base = 16;
  800bd5:	83 c1 02             	add    $0x2,%ecx
  800bd8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bdd:	eb c4                	jmp    800ba3 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bdf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be2:	89 f3                	mov    %esi,%ebx
  800be4:	80 fb 19             	cmp    $0x19,%bl
  800be7:	77 29                	ja     800c12 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800be9:	0f be d2             	movsbl %dl,%edx
  800bec:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bef:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf2:	7d 30                	jge    800c24 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bf4:	83 c1 01             	add    $0x1,%ecx
  800bf7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bfb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bfd:	0f b6 11             	movzbl (%ecx),%edx
  800c00:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c03:	89 f3                	mov    %esi,%ebx
  800c05:	80 fb 09             	cmp    $0x9,%bl
  800c08:	77 d5                	ja     800bdf <strtol+0x80>
			dig = *s - '0';
  800c0a:	0f be d2             	movsbl %dl,%edx
  800c0d:	83 ea 30             	sub    $0x30,%edx
  800c10:	eb dd                	jmp    800bef <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c15:	89 f3                	mov    %esi,%ebx
  800c17:	80 fb 19             	cmp    $0x19,%bl
  800c1a:	77 08                	ja     800c24 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c1c:	0f be d2             	movsbl %dl,%edx
  800c1f:	83 ea 37             	sub    $0x37,%edx
  800c22:	eb cb                	jmp    800bef <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c28:	74 05                	je     800c2f <strtol+0xd0>
		*endptr = (char *) s;
  800c2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c2f:	89 c2                	mov    %eax,%edx
  800c31:	f7 da                	neg    %edx
  800c33:	85 ff                	test   %edi,%edi
  800c35:	0f 45 c2             	cmovne %edx,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    
  800c3d:	66 90                	xchg   %ax,%ax
  800c3f:	90                   	nop

00800c40 <__udivdi3>:
  800c40:	55                   	push   %ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	83 ec 1c             	sub    $0x1c,%esp
  800c47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c57:	85 d2                	test   %edx,%edx
  800c59:	75 35                	jne    800c90 <__udivdi3+0x50>
  800c5b:	39 f3                	cmp    %esi,%ebx
  800c5d:	0f 87 bd 00 00 00    	ja     800d20 <__udivdi3+0xe0>
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	89 d9                	mov    %ebx,%ecx
  800c67:	75 0b                	jne    800c74 <__udivdi3+0x34>
  800c69:	b8 01 00 00 00       	mov    $0x1,%eax
  800c6e:	31 d2                	xor    %edx,%edx
  800c70:	f7 f3                	div    %ebx
  800c72:	89 c1                	mov    %eax,%ecx
  800c74:	31 d2                	xor    %edx,%edx
  800c76:	89 f0                	mov    %esi,%eax
  800c78:	f7 f1                	div    %ecx
  800c7a:	89 c6                	mov    %eax,%esi
  800c7c:	89 e8                	mov    %ebp,%eax
  800c7e:	89 f7                	mov    %esi,%edi
  800c80:	f7 f1                	div    %ecx
  800c82:	89 fa                	mov    %edi,%edx
  800c84:	83 c4 1c             	add    $0x1c,%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
  800c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c90:	39 f2                	cmp    %esi,%edx
  800c92:	77 7c                	ja     800d10 <__udivdi3+0xd0>
  800c94:	0f bd fa             	bsr    %edx,%edi
  800c97:	83 f7 1f             	xor    $0x1f,%edi
  800c9a:	0f 84 98 00 00 00    	je     800d38 <__udivdi3+0xf8>
  800ca0:	89 f9                	mov    %edi,%ecx
  800ca2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ca7:	29 f8                	sub    %edi,%eax
  800ca9:	d3 e2                	shl    %cl,%edx
  800cab:	89 54 24 08          	mov    %edx,0x8(%esp)
  800caf:	89 c1                	mov    %eax,%ecx
  800cb1:	89 da                	mov    %ebx,%edx
  800cb3:	d3 ea                	shr    %cl,%edx
  800cb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cb9:	09 d1                	or     %edx,%ecx
  800cbb:	89 f2                	mov    %esi,%edx
  800cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cc1:	89 f9                	mov    %edi,%ecx
  800cc3:	d3 e3                	shl    %cl,%ebx
  800cc5:	89 c1                	mov    %eax,%ecx
  800cc7:	d3 ea                	shr    %cl,%edx
  800cc9:	89 f9                	mov    %edi,%ecx
  800ccb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ccf:	d3 e6                	shl    %cl,%esi
  800cd1:	89 eb                	mov    %ebp,%ebx
  800cd3:	89 c1                	mov    %eax,%ecx
  800cd5:	d3 eb                	shr    %cl,%ebx
  800cd7:	09 de                	or     %ebx,%esi
  800cd9:	89 f0                	mov    %esi,%eax
  800cdb:	f7 74 24 08          	divl   0x8(%esp)
  800cdf:	89 d6                	mov    %edx,%esi
  800ce1:	89 c3                	mov    %eax,%ebx
  800ce3:	f7 64 24 0c          	mull   0xc(%esp)
  800ce7:	39 d6                	cmp    %edx,%esi
  800ce9:	72 0c                	jb     800cf7 <__udivdi3+0xb7>
  800ceb:	89 f9                	mov    %edi,%ecx
  800ced:	d3 e5                	shl    %cl,%ebp
  800cef:	39 c5                	cmp    %eax,%ebp
  800cf1:	73 5d                	jae    800d50 <__udivdi3+0x110>
  800cf3:	39 d6                	cmp    %edx,%esi
  800cf5:	75 59                	jne    800d50 <__udivdi3+0x110>
  800cf7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800cfa:	31 ff                	xor    %edi,%edi
  800cfc:	89 fa                	mov    %edi,%edx
  800cfe:	83 c4 1c             	add    $0x1c,%esp
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    
  800d06:	8d 76 00             	lea    0x0(%esi),%esi
  800d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d10:	31 ff                	xor    %edi,%edi
  800d12:	31 c0                	xor    %eax,%eax
  800d14:	89 fa                	mov    %edi,%edx
  800d16:	83 c4 1c             	add    $0x1c,%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
  800d1e:	66 90                	xchg   %ax,%ax
  800d20:	31 ff                	xor    %edi,%edi
  800d22:	89 e8                	mov    %ebp,%eax
  800d24:	89 f2                	mov    %esi,%edx
  800d26:	f7 f3                	div    %ebx
  800d28:	89 fa                	mov    %edi,%edx
  800d2a:	83 c4 1c             	add    $0x1c,%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
  800d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d38:	39 f2                	cmp    %esi,%edx
  800d3a:	72 06                	jb     800d42 <__udivdi3+0x102>
  800d3c:	31 c0                	xor    %eax,%eax
  800d3e:	39 eb                	cmp    %ebp,%ebx
  800d40:	77 d2                	ja     800d14 <__udivdi3+0xd4>
  800d42:	b8 01 00 00 00       	mov    $0x1,%eax
  800d47:	eb cb                	jmp    800d14 <__udivdi3+0xd4>
  800d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d50:	89 d8                	mov    %ebx,%eax
  800d52:	31 ff                	xor    %edi,%edi
  800d54:	eb be                	jmp    800d14 <__udivdi3+0xd4>
  800d56:	66 90                	xchg   %ax,%ax
  800d58:	66 90                	xchg   %ax,%ax
  800d5a:	66 90                	xchg   %ax,%ax
  800d5c:	66 90                	xchg   %ax,%ax
  800d5e:	66 90                	xchg   %ax,%ax

00800d60 <__umoddi3>:
  800d60:	55                   	push   %ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	83 ec 1c             	sub    $0x1c,%esp
  800d67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800d6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800d77:	85 ed                	test   %ebp,%ebp
  800d79:	89 f0                	mov    %esi,%eax
  800d7b:	89 da                	mov    %ebx,%edx
  800d7d:	75 19                	jne    800d98 <__umoddi3+0x38>
  800d7f:	39 df                	cmp    %ebx,%edi
  800d81:	0f 86 b1 00 00 00    	jbe    800e38 <__umoddi3+0xd8>
  800d87:	f7 f7                	div    %edi
  800d89:	89 d0                	mov    %edx,%eax
  800d8b:	31 d2                	xor    %edx,%edx
  800d8d:	83 c4 1c             	add    $0x1c,%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
  800d95:	8d 76 00             	lea    0x0(%esi),%esi
  800d98:	39 dd                	cmp    %ebx,%ebp
  800d9a:	77 f1                	ja     800d8d <__umoddi3+0x2d>
  800d9c:	0f bd cd             	bsr    %ebp,%ecx
  800d9f:	83 f1 1f             	xor    $0x1f,%ecx
  800da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800da6:	0f 84 b4 00 00 00    	je     800e60 <__umoddi3+0x100>
  800dac:	b8 20 00 00 00       	mov    $0x20,%eax
  800db1:	89 c2                	mov    %eax,%edx
  800db3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800db7:	29 c2                	sub    %eax,%edx
  800db9:	89 c1                	mov    %eax,%ecx
  800dbb:	89 f8                	mov    %edi,%eax
  800dbd:	d3 e5                	shl    %cl,%ebp
  800dbf:	89 d1                	mov    %edx,%ecx
  800dc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dc5:	d3 e8                	shr    %cl,%eax
  800dc7:	09 c5                	or     %eax,%ebp
  800dc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dcd:	89 c1                	mov    %eax,%ecx
  800dcf:	d3 e7                	shl    %cl,%edi
  800dd1:	89 d1                	mov    %edx,%ecx
  800dd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800dd7:	89 df                	mov    %ebx,%edi
  800dd9:	d3 ef                	shr    %cl,%edi
  800ddb:	89 c1                	mov    %eax,%ecx
  800ddd:	89 f0                	mov    %esi,%eax
  800ddf:	d3 e3                	shl    %cl,%ebx
  800de1:	89 d1                	mov    %edx,%ecx
  800de3:	89 fa                	mov    %edi,%edx
  800de5:	d3 e8                	shr    %cl,%eax
  800de7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800dec:	09 d8                	or     %ebx,%eax
  800dee:	f7 f5                	div    %ebp
  800df0:	d3 e6                	shl    %cl,%esi
  800df2:	89 d1                	mov    %edx,%ecx
  800df4:	f7 64 24 08          	mull   0x8(%esp)
  800df8:	39 d1                	cmp    %edx,%ecx
  800dfa:	89 c3                	mov    %eax,%ebx
  800dfc:	89 d7                	mov    %edx,%edi
  800dfe:	72 06                	jb     800e06 <__umoddi3+0xa6>
  800e00:	75 0e                	jne    800e10 <__umoddi3+0xb0>
  800e02:	39 c6                	cmp    %eax,%esi
  800e04:	73 0a                	jae    800e10 <__umoddi3+0xb0>
  800e06:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e0a:	19 ea                	sbb    %ebp,%edx
  800e0c:	89 d7                	mov    %edx,%edi
  800e0e:	89 c3                	mov    %eax,%ebx
  800e10:	89 ca                	mov    %ecx,%edx
  800e12:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e17:	29 de                	sub    %ebx,%esi
  800e19:	19 fa                	sbb    %edi,%edx
  800e1b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e1f:	89 d0                	mov    %edx,%eax
  800e21:	d3 e0                	shl    %cl,%eax
  800e23:	89 d9                	mov    %ebx,%ecx
  800e25:	d3 ee                	shr    %cl,%esi
  800e27:	d3 ea                	shr    %cl,%edx
  800e29:	09 f0                	or     %esi,%eax
  800e2b:	83 c4 1c             	add    $0x1c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
  800e33:	90                   	nop
  800e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e38:	85 ff                	test   %edi,%edi
  800e3a:	89 f9                	mov    %edi,%ecx
  800e3c:	75 0b                	jne    800e49 <__umoddi3+0xe9>
  800e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e43:	31 d2                	xor    %edx,%edx
  800e45:	f7 f7                	div    %edi
  800e47:	89 c1                	mov    %eax,%ecx
  800e49:	89 d8                	mov    %ebx,%eax
  800e4b:	31 d2                	xor    %edx,%edx
  800e4d:	f7 f1                	div    %ecx
  800e4f:	89 f0                	mov    %esi,%eax
  800e51:	f7 f1                	div    %ecx
  800e53:	e9 31 ff ff ff       	jmp    800d89 <__umoddi3+0x29>
  800e58:	90                   	nop
  800e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e60:	39 dd                	cmp    %ebx,%ebp
  800e62:	72 08                	jb     800e6c <__umoddi3+0x10c>
  800e64:	39 f7                	cmp    %esi,%edi
  800e66:	0f 87 21 ff ff ff    	ja     800d8d <__umoddi3+0x2d>
  800e6c:	89 da                	mov    %ebx,%edx
  800e6e:	89 f0                	mov    %esi,%eax
  800e70:	29 f8                	sub    %edi,%eax
  800e72:	19 ea                	sbb    %ebp,%edx
  800e74:	e9 14 ff ff ff       	jmp    800d8d <__umoddi3+0x2d>
