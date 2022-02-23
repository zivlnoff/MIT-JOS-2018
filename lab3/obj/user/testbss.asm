
obj/user/testbss：     文件格式 elf32-i386


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
  80002c:	e8 d7 00 00 00       	call   800108 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
  80003a:	e8 c5 00 00 00       	call   800104 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	int i;

	cprintf("Making sure bss works right...\n");
  800045:	8d 83 4c ef ff ff    	lea    -0x10b4(%ebx),%eax
  80004b:	50                   	push   %eax
  80004c:	e8 2d 02 00 00       	call   80027e <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800054:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  800059:	c7 c2 40 20 80 00    	mov    $0x802040,%edx
  80005f:	83 3c 82 00          	cmpl   $0x0,(%edx,%eax,4)
  800063:	75 73                	jne    8000d8 <umain+0xa5>
	for (i = 0; i < ARRAYSIZE; i++)
  800065:	83 c0 01             	add    $0x1,%eax
  800068:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80006d:	75 f0                	jne    80005f <umain+0x2c>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80006f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800074:	c7 c2 40 20 80 00    	mov    $0x802040,%edx
  80007a:	89 04 82             	mov    %eax,(%edx,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80007d:	83 c0 01             	add    $0x1,%eax
  800080:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800085:	75 f3                	jne    80007a <umain+0x47>
	for (i = 0; i < ARRAYSIZE; i++)
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80008c:	c7 c2 40 20 80 00    	mov    $0x802040,%edx
  800092:	39 04 82             	cmp    %eax,(%edx,%eax,4)
  800095:	75 57                	jne    8000ee <umain+0xbb>
	for (i = 0; i < ARRAYSIZE; i++)
  800097:	83 c0 01             	add    $0x1,%eax
  80009a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80009f:	75 f1                	jne    800092 <umain+0x5f>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	8d 83 94 ef ff ff    	lea    -0x106c(%ebx),%eax
  8000aa:	50                   	push   %eax
  8000ab:	e8 ce 01 00 00       	call   80027e <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000b0:	c7 c0 40 20 80 00    	mov    $0x802040,%eax
  8000b6:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%eax)
  8000bd:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000c0:	83 c4 0c             	add    $0xc,%esp
  8000c3:	8d 83 f3 ef ff ff    	lea    -0x100d(%ebx),%eax
  8000c9:	50                   	push   %eax
  8000ca:	6a 1a                	push   $0x1a
  8000cc:	8d 83 e4 ef ff ff    	lea    -0x101c(%ebx),%eax
  8000d2:	50                   	push   %eax
  8000d3:	e8 9a 00 00 00       	call   800172 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000d8:	50                   	push   %eax
  8000d9:	8d 83 c7 ef ff ff    	lea    -0x1039(%ebx),%eax
  8000df:	50                   	push   %eax
  8000e0:	6a 11                	push   $0x11
  8000e2:	8d 83 e4 ef ff ff    	lea    -0x101c(%ebx),%eax
  8000e8:	50                   	push   %eax
  8000e9:	e8 84 00 00 00       	call   800172 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ee:	50                   	push   %eax
  8000ef:	8d 83 6c ef ff ff    	lea    -0x1094(%ebx),%eax
  8000f5:	50                   	push   %eax
  8000f6:	6a 16                	push   $0x16
  8000f8:	8d 83 e4 ef ff ff    	lea    -0x101c(%ebx),%eax
  8000fe:	50                   	push   %eax
  8000ff:	e8 6e 00 00 00       	call   800172 <_panic>

00800104 <__x86.get_pc_thunk.bx>:
  800104:	8b 1c 24             	mov    (%esp),%ebx
  800107:	c3                   	ret    

00800108 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	56                   	push   %esi
  80010c:	53                   	push   %ebx
  80010d:	e8 f2 ff ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  800112:	81 c3 ee 1e 00 00    	add    $0x1eee,%ebx
  800118:	8b 45 08             	mov    0x8(%ebp),%eax
  80011b:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80011e:	c7 c1 40 20 c0 00    	mov    $0xc02040,%ecx
  800124:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  80012a:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012c:	85 c0                	test   %eax,%eax
  80012e:	7e 08                	jle    800138 <libmain+0x30>
		binaryname = argv[0];
  800130:	8b 0a                	mov    (%edx),%ecx
  800132:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	52                   	push   %edx
  80013c:	50                   	push   %eax
  80013d:	e8 f1 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800142:	e8 0a 00 00 00       	call   800151 <exit>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	53                   	push   %ebx
  800155:	83 ec 10             	sub    $0x10,%esp
  800158:	e8 a7 ff ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  80015d:	81 c3 a3 1e 00 00    	add    $0x1ea3,%ebx
	sys_env_destroy(0);
  800163:	6a 00                	push   $0x0
  800165:	e8 25 0b 00 00       	call   800c8f <sys_env_destroy>
}
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	57                   	push   %edi
  800176:	56                   	push   %esi
  800177:	53                   	push   %ebx
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	e8 84 ff ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  800180:	81 c3 80 1e 00 00    	add    $0x1e80,%ebx
	va_list ap;

	va_start(ap, fmt);
  800186:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800189:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  80018f:	8b 38                	mov    (%eax),%edi
  800191:	e8 4e 0b 00 00       	call   800ce4 <sys_getenvid>
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 0c             	pushl  0xc(%ebp)
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	57                   	push   %edi
  8001a0:	50                   	push   %eax
  8001a1:	8d 83 14 f0 ff ff    	lea    -0xfec(%ebx),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 d1 00 00 00       	call   80027e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ad:	83 c4 18             	add    $0x18,%esp
  8001b0:	56                   	push   %esi
  8001b1:	ff 75 10             	pushl  0x10(%ebp)
  8001b4:	e8 63 00 00 00       	call   80021c <vcprintf>
	cprintf("\n");
  8001b9:	8d 83 e2 ef ff ff    	lea    -0x101e(%ebx),%eax
  8001bf:	89 04 24             	mov    %eax,(%esp)
  8001c2:	e8 b7 00 00 00       	call   80027e <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ca:	cc                   	int3   
  8001cb:	eb fd                	jmp    8001ca <_panic+0x58>

008001cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	56                   	push   %esi
  8001d1:	53                   	push   %ebx
  8001d2:	e8 2d ff ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  8001d7:	81 c3 29 1e 00 00    	add    $0x1e29,%ebx
  8001dd:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001e0:	8b 16                	mov    (%esi),%edx
  8001e2:	8d 42 01             	lea    0x1(%edx),%eax
  8001e5:	89 06                	mov    %eax,(%esi)
  8001e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ea:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f3:	74 0b                	je     800200 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f5:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5d                   	pop    %ebp
  8001ff:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	68 ff 00 00 00       	push   $0xff
  800208:	8d 46 08             	lea    0x8(%esi),%eax
  80020b:	50                   	push   %eax
  80020c:	e8 41 0a 00 00       	call   800c52 <sys_cputs>
		b->idx = 0;
  800211:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb d9                	jmp    8001f5 <putch+0x28>

0080021c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	53                   	push   %ebx
  800220:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800226:	e8 d9 fe ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  80022b:	81 c3 d5 1d 00 00    	add    $0x1dd5,%ebx
	struct printbuf b;

	b.idx = 0;
  800231:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800238:	00 00 00 
	b.cnt = 0;
  80023b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800242:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800245:	ff 75 0c             	pushl  0xc(%ebp)
  800248:	ff 75 08             	pushl  0x8(%ebp)
  80024b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800251:	50                   	push   %eax
  800252:	8d 83 cd e1 ff ff    	lea    -0x1e33(%ebx),%eax
  800258:	50                   	push   %eax
  800259:	e8 38 01 00 00       	call   800396 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025e:	83 c4 08             	add    $0x8,%esp
  800261:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800267:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026d:	50                   	push   %eax
  80026e:	e8 df 09 00 00       	call   800c52 <sys_cputs>

	return b.cnt;
}
  800273:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800279:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800284:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800287:	50                   	push   %eax
  800288:	ff 75 08             	pushl  0x8(%ebp)
  80028b:	e8 8c ff ff ff       	call   80021c <vcprintf>
	va_end(ap);

	return cnt;
}
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	57                   	push   %edi
  800296:	56                   	push   %esi
  800297:	53                   	push   %ebx
  800298:	83 ec 2c             	sub    $0x2c,%esp
  80029b:	e8 3a 06 00 00       	call   8008da <__x86.get_pc_thunk.cx>
  8002a0:	81 c1 60 1d 00 00    	add    $0x1d60,%ecx
  8002a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	89 d6                	mov    %edx,%esi
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002b6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002c4:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002c7:	39 d3                	cmp    %edx,%ebx
  8002c9:	72 09                	jb     8002d4 <printnum+0x42>
  8002cb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002ce:	0f 87 83 00 00 00    	ja     800357 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	ff 75 18             	pushl  0x18(%ebp)
  8002da:	8b 45 14             	mov    0x14(%ebp),%eax
  8002dd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e0:	53                   	push   %ebx
  8002e1:	ff 75 10             	pushl  0x10(%ebp)
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	ff 75 d0             	pushl  -0x30(%ebp)
  8002f3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002f6:	e8 15 0a 00 00       	call   800d10 <__udivdi3>
  8002fb:	83 c4 18             	add    $0x18,%esp
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	89 f2                	mov    %esi,%edx
  800302:	89 f8                	mov    %edi,%eax
  800304:	e8 89 ff ff ff       	call   800292 <printnum>
  800309:	83 c4 20             	add    $0x20,%esp
  80030c:	eb 13                	jmp    800321 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	56                   	push   %esi
  800312:	ff 75 18             	pushl  0x18(%ebp)
  800315:	ff d7                	call   *%edi
  800317:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031a:	83 eb 01             	sub    $0x1,%ebx
  80031d:	85 db                	test   %ebx,%ebx
  80031f:	7f ed                	jg     80030e <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	56                   	push   %esi
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 dc             	pushl  -0x24(%ebp)
  80032b:	ff 75 d8             	pushl  -0x28(%ebp)
  80032e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800331:	ff 75 d0             	pushl  -0x30(%ebp)
  800334:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800337:	89 f3                	mov    %esi,%ebx
  800339:	e8 f2 0a 00 00       	call   800e30 <__umoddi3>
  80033e:	83 c4 14             	add    $0x14,%esp
  800341:	0f be 84 06 38 f0 ff 	movsbl -0xfc8(%esi,%eax,1),%eax
  800348:	ff 
  800349:	50                   	push   %eax
  80034a:	ff d7                	call   *%edi
}
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800352:	5b                   	pop    %ebx
  800353:	5e                   	pop    %esi
  800354:	5f                   	pop    %edi
  800355:	5d                   	pop    %ebp
  800356:	c3                   	ret    
  800357:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80035a:	eb be                	jmp    80031a <printnum+0x88>

0080035c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800362:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800366:	8b 10                	mov    (%eax),%edx
  800368:	3b 50 04             	cmp    0x4(%eax),%edx
  80036b:	73 0a                	jae    800377 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800370:	89 08                	mov    %ecx,(%eax)
  800372:	8b 45 08             	mov    0x8(%ebp),%eax
  800375:	88 02                	mov    %al,(%edx)
}
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    

00800379 <printfmt>:
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800382:	50                   	push   %eax
  800383:	ff 75 10             	pushl  0x10(%ebp)
  800386:	ff 75 0c             	pushl  0xc(%ebp)
  800389:	ff 75 08             	pushl  0x8(%ebp)
  80038c:	e8 05 00 00 00       	call   800396 <vprintfmt>
}
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <vprintfmt>:
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
  80039c:	83 ec 2c             	sub    $0x2c,%esp
  80039f:	e8 60 fd ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  8003a4:	81 c3 5c 1c 00 00    	add    $0x1c5c,%ebx
  8003aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003b0:	e9 fb 03 00 00       	jmp    8007b0 <.L35+0x48>
		padc = ' ';
  8003b5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003b9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003c0:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d3:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8d 47 01             	lea    0x1(%edi),%eax
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003dc:	0f b6 17             	movzbl (%edi),%edx
  8003df:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e2:	3c 55                	cmp    $0x55,%al
  8003e4:	0f 87 4e 04 00 00    	ja     800838 <.L22>
  8003ea:	0f b6 c0             	movzbl %al,%eax
  8003ed:	89 d9                	mov    %ebx,%ecx
  8003ef:	03 8c 83 c8 f0 ff ff 	add    -0xf38(%ebx,%eax,4),%ecx
  8003f6:	ff e1                	jmp    *%ecx

008003f8 <.L71>:
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003fb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003ff:	eb d5                	jmp    8003d6 <vprintfmt+0x40>

00800401 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800404:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800408:	eb cc                	jmp    8003d6 <vprintfmt+0x40>

0080040a <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	0f b6 d2             	movzbl %dl,%edx
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800410:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800415:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800418:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80041c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80041f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800422:	83 f9 09             	cmp    $0x9,%ecx
  800425:	77 55                	ja     80047c <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800427:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80042a:	eb e9                	jmp    800415 <.L29+0xb>

0080042c <.L26>:
			precision = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8d 40 04             	lea    0x4(%eax),%eax
  80043a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800444:	79 90                	jns    8003d6 <vprintfmt+0x40>
				width = precision, precision = -1;
  800446:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800449:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044c:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800453:	eb 81                	jmp    8003d6 <vprintfmt+0x40>

00800455 <.L27>:
  800455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800458:	85 c0                	test   %eax,%eax
  80045a:	ba 00 00 00 00       	mov    $0x0,%edx
  80045f:	0f 49 d0             	cmovns %eax,%edx
  800462:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800468:	e9 69 ff ff ff       	jmp    8003d6 <vprintfmt+0x40>

0080046d <.L23>:
  80046d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800470:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800477:	e9 5a ff ff ff       	jmp    8003d6 <vprintfmt+0x40>
  80047c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80047f:	eb bf                	jmp    800440 <.L26+0x14>

00800481 <.L33>:
			lflag++;
  800481:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800485:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800488:	e9 49 ff ff ff       	jmp    8003d6 <vprintfmt+0x40>

0080048d <.L30>:
			putch(va_arg(ap, int), putdat);
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	8d 78 04             	lea    0x4(%eax),%edi
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	56                   	push   %esi
  800497:	ff 30                	pushl  (%eax)
  800499:	ff 55 08             	call   *0x8(%ebp)
			break;
  80049c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80049f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004a2:	e9 06 03 00 00       	jmp    8007ad <.L35+0x45>

008004a7 <.L32>:
			err = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 78 04             	lea    0x4(%eax),%edi
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	99                   	cltd   
  8004b0:	31 d0                	xor    %edx,%eax
  8004b2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b4:	83 f8 06             	cmp    $0x6,%eax
  8004b7:	7f 27                	jg     8004e0 <.L32+0x39>
  8004b9:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8004c0:	85 d2                	test   %edx,%edx
  8004c2:	74 1c                	je     8004e0 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004c4:	52                   	push   %edx
  8004c5:	8d 83 59 f0 ff ff    	lea    -0xfa7(%ebx),%eax
  8004cb:	50                   	push   %eax
  8004cc:	56                   	push   %esi
  8004cd:	ff 75 08             	pushl  0x8(%ebp)
  8004d0:	e8 a4 fe ff ff       	call   800379 <printfmt>
  8004d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004db:	e9 cd 02 00 00       	jmp    8007ad <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004e0:	50                   	push   %eax
  8004e1:	8d 83 50 f0 ff ff    	lea    -0xfb0(%ebx),%eax
  8004e7:	50                   	push   %eax
  8004e8:	56                   	push   %esi
  8004e9:	ff 75 08             	pushl  0x8(%ebp)
  8004ec:	e8 88 fe ff ff       	call   800379 <printfmt>
  8004f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004f7:	e9 b1 02 00 00       	jmp    8007ad <.L35+0x45>

008004fc <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 c0 04             	add    $0x4,%eax
  800502:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80050a:	85 ff                	test   %edi,%edi
  80050c:	8d 83 49 f0 ff ff    	lea    -0xfb7(%ebx),%eax
  800512:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800515:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800519:	0f 8e b5 00 00 00    	jle    8005d4 <.L36+0xd8>
  80051f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800523:	75 08                	jne    80052d <.L36+0x31>
  800525:	89 75 0c             	mov    %esi,0xc(%ebp)
  800528:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80052b:	eb 6d                	jmp    80059a <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	ff 75 cc             	pushl  -0x34(%ebp)
  800533:	57                   	push   %edi
  800534:	e8 bd 03 00 00       	call   8008f6 <strnlen>
  800539:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800541:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800544:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800548:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80054b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80054e:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800550:	eb 10                	jmp    800562 <.L36+0x66>
					putch(padc, putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	56                   	push   %esi
  800556:	ff 75 e0             	pushl  -0x20(%ebp)
  800559:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ec                	jg     800552 <.L36+0x56>
  800566:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800569:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80056c:	85 d2                	test   %edx,%edx
  80056e:	b8 00 00 00 00       	mov    $0x0,%eax
  800573:	0f 49 c2             	cmovns %edx,%eax
  800576:	29 c2                	sub    %eax,%edx
  800578:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80057b:	89 75 0c             	mov    %esi,0xc(%ebp)
  80057e:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800581:	eb 17                	jmp    80059a <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800583:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800587:	75 30                	jne    8005b9 <.L36+0xbd>
					putch(ch, putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	ff 55 08             	call   *0x8(%ebp)
  800593:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800596:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80059a:	83 c7 01             	add    $0x1,%edi
  80059d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005a1:	0f be c2             	movsbl %dl,%eax
  8005a4:	85 c0                	test   %eax,%eax
  8005a6:	74 52                	je     8005fa <.L36+0xfe>
  8005a8:	85 f6                	test   %esi,%esi
  8005aa:	78 d7                	js     800583 <.L36+0x87>
  8005ac:	83 ee 01             	sub    $0x1,%esi
  8005af:	79 d2                	jns    800583 <.L36+0x87>
  8005b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005b7:	eb 32                	jmp    8005eb <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b9:	0f be d2             	movsbl %dl,%edx
  8005bc:	83 ea 20             	sub    $0x20,%edx
  8005bf:	83 fa 5e             	cmp    $0x5e,%edx
  8005c2:	76 c5                	jbe    800589 <.L36+0x8d>
					putch('?', putdat);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ca:	6a 3f                	push   $0x3f
  8005cc:	ff 55 08             	call   *0x8(%ebp)
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	eb c2                	jmp    800596 <.L36+0x9a>
  8005d4:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005d7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005da:	eb be                	jmp    80059a <.L36+0x9e>
				putch(' ', putdat);
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	56                   	push   %esi
  8005e0:	6a 20                	push   $0x20
  8005e2:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005e5:	83 ef 01             	sub    $0x1,%edi
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	85 ff                	test   %edi,%edi
  8005ed:	7f ed                	jg     8005dc <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f5:	e9 b3 01 00 00       	jmp    8007ad <.L35+0x45>
  8005fa:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800600:	eb e9                	jmp    8005eb <.L36+0xef>

00800602 <.L31>:
  800602:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800605:	83 f9 01             	cmp    $0x1,%ecx
  800608:	7e 40                	jle    80064a <.L31+0x48>
		return va_arg(*ap, long long);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 50 04             	mov    0x4(%eax),%edx
  800610:	8b 00                	mov    (%eax),%eax
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 40 08             	lea    0x8(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800621:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800625:	79 55                	jns    80067c <.L31+0x7a>
				putch('-', putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	56                   	push   %esi
  80062b:	6a 2d                	push   $0x2d
  80062d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800630:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800633:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800636:	f7 da                	neg    %edx
  800638:	83 d1 00             	adc    $0x0,%ecx
  80063b:	f7 d9                	neg    %ecx
  80063d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800640:	b8 0a 00 00 00       	mov    $0xa,%eax
  800645:	e9 48 01 00 00       	jmp    800792 <.L35+0x2a>
	else if (lflag)
  80064a:	85 c9                	test   %ecx,%ecx
  80064c:	75 17                	jne    800665 <.L31+0x63>
		return va_arg(*ap, int);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800656:	99                   	cltd   
  800657:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 40 04             	lea    0x4(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
  800663:	eb bc                	jmp    800621 <.L31+0x1f>
		return va_arg(*ap, long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	99                   	cltd   
  80066e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
  80067a:	eb a5                	jmp    800621 <.L31+0x1f>
			num = getint(&ap, lflag);
  80067c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80067f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800682:	b8 0a 00 00 00       	mov    $0xa,%eax
  800687:	e9 06 01 00 00       	jmp    800792 <.L35+0x2a>

0080068c <.L37>:
  80068c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 18                	jle    8006ac <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
  800699:	8b 48 04             	mov    0x4(%eax),%ecx
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a7:	e9 e6 00 00 00       	jmp    800792 <.L35+0x2a>
	else if (lflag)
  8006ac:	85 c9                	test   %ecx,%ecx
  8006ae:	75 1a                	jne    8006ca <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 10                	mov    (%eax),%edx
  8006b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c5:	e9 c8 00 00 00       	jmp    800792 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 10                	mov    (%eax),%edx
  8006cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	e9 ae 00 00 00       	jmp    800792 <.L35+0x2a>

008006e4 <.L34>:
  8006e4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006e7:	83 f9 01             	cmp    $0x1,%ecx
  8006ea:	7e 3d                	jle    800729 <.L34+0x45>
		return va_arg(*ap, long long);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 50 04             	mov    0x4(%eax),%edx
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8d 40 08             	lea    0x8(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800703:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800707:	79 52                	jns    80075b <.L34+0x77>
                putch('-', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	56                   	push   %esi
  80070d:	6a 2d                	push   $0x2d
  80070f:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800712:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800715:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800718:	f7 da                	neg    %edx
  80071a:	83 d1 00             	adc    $0x0,%ecx
  80071d:	f7 d9                	neg    %ecx
  80071f:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800722:	b8 08 00 00 00       	mov    $0x8,%eax
  800727:	eb 69                	jmp    800792 <.L35+0x2a>
	else if (lflag)
  800729:	85 c9                	test   %ecx,%ecx
  80072b:	75 17                	jne    800744 <.L34+0x60>
		return va_arg(*ap, int);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800735:	99                   	cltd   
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	eb bf                	jmp    800703 <.L34+0x1f>
		return va_arg(*ap, long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	99                   	cltd   
  80074d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	eb a8                	jmp    800703 <.L34+0x1f>
            num = getint(&ap, lflag);
  80075b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80075e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800761:	b8 08 00 00 00       	mov    $0x8,%eax
  800766:	eb 2a                	jmp    800792 <.L35+0x2a>

00800768 <.L35>:
			putch('0', putdat);
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	56                   	push   %esi
  80076c:	6a 30                	push   $0x30
  80076e:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800771:	83 c4 08             	add    $0x8,%esp
  800774:	56                   	push   %esi
  800775:	6a 78                	push   $0x78
  800777:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 10                	mov    (%eax),%edx
  80077f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800784:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800799:	57                   	push   %edi
  80079a:	ff 75 e0             	pushl  -0x20(%ebp)
  80079d:	50                   	push   %eax
  80079e:	51                   	push   %ecx
  80079f:	52                   	push   %edx
  8007a0:	89 f2                	mov    %esi,%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	e8 e8 fa ff ff       	call   800292 <printnum>
			break;
  8007aa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b0:	83 c7 01             	add    $0x1,%edi
  8007b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b7:	83 f8 25             	cmp    $0x25,%eax
  8007ba:	0f 84 f5 fb ff ff    	je     8003b5 <vprintfmt+0x1f>
			if (ch == '\0')
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	0f 84 91 00 00 00    	je     800859 <.L22+0x21>
			putch(ch, putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	56                   	push   %esi
  8007cc:	50                   	push   %eax
  8007cd:	ff 55 08             	call   *0x8(%ebp)
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb db                	jmp    8007b0 <.L35+0x48>

008007d5 <.L38>:
  8007d5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007d8:	83 f9 01             	cmp    $0x1,%ecx
  8007db:	7e 15                	jle    8007f2 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 10                	mov    (%eax),%edx
  8007e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e5:	8d 40 08             	lea    0x8(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f0:	eb a0                	jmp    800792 <.L35+0x2a>
	else if (lflag)
  8007f2:	85 c9                	test   %ecx,%ecx
  8007f4:	75 17                	jne    80080d <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 10                	mov    (%eax),%edx
  8007fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800800:	8d 40 04             	lea    0x4(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800806:	b8 10 00 00 00       	mov    $0x10,%eax
  80080b:	eb 85                	jmp    800792 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	b9 00 00 00 00       	mov    $0x0,%ecx
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081d:	b8 10 00 00 00       	mov    $0x10,%eax
  800822:	e9 6b ff ff ff       	jmp    800792 <.L35+0x2a>

00800827 <.L25>:
			putch(ch, putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	56                   	push   %esi
  80082b:	6a 25                	push   $0x25
  80082d:	ff 55 08             	call   *0x8(%ebp)
			break;
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	e9 75 ff ff ff       	jmp    8007ad <.L35+0x45>

00800838 <.L22>:
			putch('%', putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	56                   	push   %esi
  80083c:	6a 25                	push   $0x25
  80083e:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	89 f8                	mov    %edi,%eax
  800846:	eb 03                	jmp    80084b <.L22+0x13>
  800848:	83 e8 01             	sub    $0x1,%eax
  80084b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80084f:	75 f7                	jne    800848 <.L22+0x10>
  800851:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800854:	e9 54 ff ff ff       	jmp    8007ad <.L35+0x45>
}
  800859:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80085c:	5b                   	pop    %ebx
  80085d:	5e                   	pop    %esi
  80085e:	5f                   	pop    %edi
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	53                   	push   %ebx
  800865:	83 ec 14             	sub    $0x14,%esp
  800868:	e8 97 f8 ff ff       	call   800104 <__x86.get_pc_thunk.bx>
  80086d:	81 c3 93 17 00 00    	add    $0x1793,%ebx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800880:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 2b                	je     8008b9 <vsnprintf+0x58>
  80088e:	85 d2                	test   %edx,%edx
  800890:	7e 27                	jle    8008b9 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800892:	ff 75 14             	pushl  0x14(%ebp)
  800895:	ff 75 10             	pushl  0x10(%ebp)
  800898:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	8d 83 5c e3 ff ff    	lea    -0x1ca4(%ebx),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 ee fa ff ff       	call   800396 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    
		return -E_INVAL;
  8008b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008be:	eb f4                	jmp    8008b4 <vsnprintf+0x53>

008008c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c9:	50                   	push   %eax
  8008ca:	ff 75 10             	pushl  0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 89 ff ff ff       	call   800861 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <__x86.get_pc_thunk.cx>:
  8008da:	8b 0c 24             	mov    (%esp),%ecx
  8008dd:	c3                   	ret    

008008de <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	eb 03                	jmp    8008ee <strlen+0x10>
		n++;
  8008eb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008ee:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f2:	75 f7                	jne    8008eb <strlen+0xd>
	return n;
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800904:	eb 03                	jmp    800909 <strnlen+0x13>
		n++;
  800906:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800909:	39 d0                	cmp    %edx,%eax
  80090b:	74 06                	je     800913 <strnlen+0x1d>
  80090d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800911:	75 f3                	jne    800906 <strnlen+0x10>
	return n;
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80091f:	89 c2                	mov    %eax,%edx
  800921:	83 c1 01             	add    $0x1,%ecx
  800924:	83 c2 01             	add    $0x1,%edx
  800927:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80092b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80092e:	84 db                	test   %bl,%bl
  800930:	75 ef                	jne    800921 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800932:	5b                   	pop    %ebx
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80093c:	53                   	push   %ebx
  80093d:	e8 9c ff ff ff       	call   8008de <strlen>
  800942:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	01 d8                	add    %ebx,%eax
  80094a:	50                   	push   %eax
  80094b:	e8 c5 ff ff ff       	call   800915 <strcpy>
	return dst;
}
  800950:	89 d8                	mov    %ebx,%eax
  800952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 75 08             	mov    0x8(%ebp),%esi
  80095f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800962:	89 f3                	mov    %esi,%ebx
  800964:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800967:	89 f2                	mov    %esi,%edx
  800969:	eb 0f                	jmp    80097a <strncpy+0x23>
		*dst++ = *src;
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	0f b6 01             	movzbl (%ecx),%eax
  800971:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800974:	80 39 01             	cmpb   $0x1,(%ecx)
  800977:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80097a:	39 da                	cmp    %ebx,%edx
  80097c:	75 ed                	jne    80096b <strncpy+0x14>
	}
	return ret;
}
  80097e:	89 f0                	mov    %esi,%eax
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 75 08             	mov    0x8(%ebp),%esi
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800992:	89 f0                	mov    %esi,%eax
  800994:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800998:	85 c9                	test   %ecx,%ecx
  80099a:	75 0b                	jne    8009a7 <strlcpy+0x23>
  80099c:	eb 17                	jmp    8009b5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80099e:	83 c2 01             	add    $0x1,%edx
  8009a1:	83 c0 01             	add    $0x1,%eax
  8009a4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009a7:	39 d8                	cmp    %ebx,%eax
  8009a9:	74 07                	je     8009b2 <strlcpy+0x2e>
  8009ab:	0f b6 0a             	movzbl (%edx),%ecx
  8009ae:	84 c9                	test   %cl,%cl
  8009b0:	75 ec                	jne    80099e <strlcpy+0x1a>
		*dst = '\0';
  8009b2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b5:	29 f0                	sub    %esi,%eax
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c4:	eb 06                	jmp    8009cc <strcmp+0x11>
		p++, q++;
  8009c6:	83 c1 01             	add    $0x1,%ecx
  8009c9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009cc:	0f b6 01             	movzbl (%ecx),%eax
  8009cf:	84 c0                	test   %al,%al
  8009d1:	74 04                	je     8009d7 <strcmp+0x1c>
  8009d3:	3a 02                	cmp    (%edx),%al
  8009d5:	74 ef                	je     8009c6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d7:	0f b6 c0             	movzbl %al,%eax
  8009da:	0f b6 12             	movzbl (%edx),%edx
  8009dd:	29 d0                	sub    %edx,%eax
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	89 c3                	mov    %eax,%ebx
  8009ed:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f0:	eb 06                	jmp    8009f8 <strncmp+0x17>
		n--, p++, q++;
  8009f2:	83 c0 01             	add    $0x1,%eax
  8009f5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f8:	39 d8                	cmp    %ebx,%eax
  8009fa:	74 16                	je     800a12 <strncmp+0x31>
  8009fc:	0f b6 08             	movzbl (%eax),%ecx
  8009ff:	84 c9                	test   %cl,%cl
  800a01:	74 04                	je     800a07 <strncmp+0x26>
  800a03:	3a 0a                	cmp    (%edx),%cl
  800a05:	74 eb                	je     8009f2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a07:	0f b6 00             	movzbl (%eax),%eax
  800a0a:	0f b6 12             	movzbl (%edx),%edx
  800a0d:	29 d0                	sub    %edx,%eax
}
  800a0f:	5b                   	pop    %ebx
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    
		return 0;
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb f6                	jmp    800a0f <strncmp+0x2e>

00800a19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a23:	0f b6 10             	movzbl (%eax),%edx
  800a26:	84 d2                	test   %dl,%dl
  800a28:	74 09                	je     800a33 <strchr+0x1a>
		if (*s == c)
  800a2a:	38 ca                	cmp    %cl,%dl
  800a2c:	74 0a                	je     800a38 <strchr+0x1f>
	for (; *s; s++)
  800a2e:	83 c0 01             	add    $0x1,%eax
  800a31:	eb f0                	jmp    800a23 <strchr+0xa>
			return (char *) s;
	return 0;
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	eb 03                	jmp    800a49 <strfind+0xf>
  800a46:	83 c0 01             	add    $0x1,%eax
  800a49:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a4c:	38 ca                	cmp    %cl,%dl
  800a4e:	74 04                	je     800a54 <strfind+0x1a>
  800a50:	84 d2                	test   %dl,%dl
  800a52:	75 f2                	jne    800a46 <strfind+0xc>
			break;
	return (char *) s;
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a62:	85 c9                	test   %ecx,%ecx
  800a64:	74 13                	je     800a79 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a66:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6c:	75 05                	jne    800a73 <memset+0x1d>
  800a6e:	f6 c1 03             	test   $0x3,%cl
  800a71:	74 0d                	je     800a80 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	fc                   	cld    
  800a77:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a79:	89 f8                	mov    %edi,%eax
  800a7b:	5b                   	pop    %ebx
  800a7c:	5e                   	pop    %esi
  800a7d:	5f                   	pop    %edi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    
		c &= 0xFF;
  800a80:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a84:	89 d3                	mov    %edx,%ebx
  800a86:	c1 e3 08             	shl    $0x8,%ebx
  800a89:	89 d0                	mov    %edx,%eax
  800a8b:	c1 e0 18             	shl    $0x18,%eax
  800a8e:	89 d6                	mov    %edx,%esi
  800a90:	c1 e6 10             	shl    $0x10,%esi
  800a93:	09 f0                	or     %esi,%eax
  800a95:	09 c2                	or     %eax,%edx
  800a97:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a99:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a9c:	89 d0                	mov    %edx,%eax
  800a9e:	fc                   	cld    
  800a9f:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa1:	eb d6                	jmp    800a79 <memset+0x23>

00800aa3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	57                   	push   %edi
  800aa7:	56                   	push   %esi
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab1:	39 c6                	cmp    %eax,%esi
  800ab3:	73 35                	jae    800aea <memmove+0x47>
  800ab5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab8:	39 c2                	cmp    %eax,%edx
  800aba:	76 2e                	jbe    800aea <memmove+0x47>
		s += n;
		d += n;
  800abc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	89 d6                	mov    %edx,%esi
  800ac1:	09 fe                	or     %edi,%esi
  800ac3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac9:	74 0c                	je     800ad7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800acb:	83 ef 01             	sub    $0x1,%edi
  800ace:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad1:	fd                   	std    
  800ad2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad4:	fc                   	cld    
  800ad5:	eb 21                	jmp    800af8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad7:	f6 c1 03             	test   $0x3,%cl
  800ada:	75 ef                	jne    800acb <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800adc:	83 ef 04             	sub    $0x4,%edi
  800adf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae5:	fd                   	std    
  800ae6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae8:	eb ea                	jmp    800ad4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aea:	89 f2                	mov    %esi,%edx
  800aec:	09 c2                	or     %eax,%edx
  800aee:	f6 c2 03             	test   $0x3,%dl
  800af1:	74 09                	je     800afc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800af3:	89 c7                	mov    %eax,%edi
  800af5:	fc                   	cld    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af8:	5e                   	pop    %esi
  800af9:	5f                   	pop    %edi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afc:	f6 c1 03             	test   $0x3,%cl
  800aff:	75 f2                	jne    800af3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b01:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b04:	89 c7                	mov    %eax,%edi
  800b06:	fc                   	cld    
  800b07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b09:	eb ed                	jmp    800af8 <memmove+0x55>

00800b0b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b0e:	ff 75 10             	pushl  0x10(%ebp)
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	ff 75 08             	pushl  0x8(%ebp)
  800b17:	e8 87 ff ff ff       	call   800aa3 <memmove>
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 c6                	mov    %eax,%esi
  800b2b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2e:	39 f0                	cmp    %esi,%eax
  800b30:	74 1c                	je     800b4e <memcmp+0x30>
		if (*s1 != *s2)
  800b32:	0f b6 08             	movzbl (%eax),%ecx
  800b35:	0f b6 1a             	movzbl (%edx),%ebx
  800b38:	38 d9                	cmp    %bl,%cl
  800b3a:	75 08                	jne    800b44 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	eb ea                	jmp    800b2e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b44:	0f b6 c1             	movzbl %cl,%eax
  800b47:	0f b6 db             	movzbl %bl,%ebx
  800b4a:	29 d8                	sub    %ebx,%eax
  800b4c:	eb 05                	jmp    800b53 <memcmp+0x35>
	}

	return 0;
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b60:	89 c2                	mov    %eax,%edx
  800b62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b65:	39 d0                	cmp    %edx,%eax
  800b67:	73 09                	jae    800b72 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b69:	38 08                	cmp    %cl,(%eax)
  800b6b:	74 05                	je     800b72 <memfind+0x1b>
	for (; s < ends; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f3                	jmp    800b65 <memfind+0xe>
			break;
	return (void *) s;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b80:	eb 03                	jmp    800b85 <strtol+0x11>
		s++;
  800b82:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b85:	0f b6 01             	movzbl (%ecx),%eax
  800b88:	3c 20                	cmp    $0x20,%al
  800b8a:	74 f6                	je     800b82 <strtol+0xe>
  800b8c:	3c 09                	cmp    $0x9,%al
  800b8e:	74 f2                	je     800b82 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b90:	3c 2b                	cmp    $0x2b,%al
  800b92:	74 2e                	je     800bc2 <strtol+0x4e>
	int neg = 0;
  800b94:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b99:	3c 2d                	cmp    $0x2d,%al
  800b9b:	74 2f                	je     800bcc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ba3:	75 05                	jne    800baa <strtol+0x36>
  800ba5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba8:	74 2c                	je     800bd6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	75 0a                	jne    800bb8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bae:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb6:	74 28                	je     800be0 <strtol+0x6c>
		base = 10;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bc0:	eb 50                	jmp    800c12 <strtol+0x9e>
		s++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bca:	eb d1                	jmp    800b9d <strtol+0x29>
		s++, neg = 1;
  800bcc:	83 c1 01             	add    $0x1,%ecx
  800bcf:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd4:	eb c7                	jmp    800b9d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bda:	74 0e                	je     800bea <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bdc:	85 db                	test   %ebx,%ebx
  800bde:	75 d8                	jne    800bb8 <strtol+0x44>
		s++, base = 8;
  800be0:	83 c1 01             	add    $0x1,%ecx
  800be3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800be8:	eb ce                	jmp    800bb8 <strtol+0x44>
		s += 2, base = 16;
  800bea:	83 c1 02             	add    $0x2,%ecx
  800bed:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bf2:	eb c4                	jmp    800bb8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bf4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bf7:	89 f3                	mov    %esi,%ebx
  800bf9:	80 fb 19             	cmp    $0x19,%bl
  800bfc:	77 29                	ja     800c27 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bfe:	0f be d2             	movsbl %dl,%edx
  800c01:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c04:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c07:	7d 30                	jge    800c39 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c09:	83 c1 01             	add    $0x1,%ecx
  800c0c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c10:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c12:	0f b6 11             	movzbl (%ecx),%edx
  800c15:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c18:	89 f3                	mov    %esi,%ebx
  800c1a:	80 fb 09             	cmp    $0x9,%bl
  800c1d:	77 d5                	ja     800bf4 <strtol+0x80>
			dig = *s - '0';
  800c1f:	0f be d2             	movsbl %dl,%edx
  800c22:	83 ea 30             	sub    $0x30,%edx
  800c25:	eb dd                	jmp    800c04 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c27:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2a:	89 f3                	mov    %esi,%ebx
  800c2c:	80 fb 19             	cmp    $0x19,%bl
  800c2f:	77 08                	ja     800c39 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c31:	0f be d2             	movsbl %dl,%edx
  800c34:	83 ea 37             	sub    $0x37,%edx
  800c37:	eb cb                	jmp    800c04 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3d:	74 05                	je     800c44 <strtol+0xd0>
		*endptr = (char *) s;
  800c3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c42:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c44:	89 c2                	mov    %eax,%edx
  800c46:	f7 da                	neg    %edx
  800c48:	85 ff                	test   %edi,%edi
  800c4a:	0f 45 c2             	cmovne %edx,%eax
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c63:	89 c3                	mov    %eax,%ebx
  800c65:	89 c7                	mov    %eax,%edi
  800c67:	89 c6                	mov    %eax,%esi
  800c69:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <sys_cgetc>:

int
sys_cgetc(void) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c80:	89 d1                	mov    %edx,%ecx
  800c82:	89 d3                	mov    %edx,%ebx
  800c84:	89 d7                	mov    %edx,%edi
  800c86:	89 d6                	mov    %edx,%esi
  800c88:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 1c             	sub    $0x1c,%esp
  800c98:	e8 66 00 00 00       	call   800d03 <__x86.get_pc_thunk.ax>
  800c9d:	05 63 13 00 00       	add    $0x1363,%eax
  800ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  800ca5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb2:	89 cb                	mov    %ecx,%ebx
  800cb4:	89 cf                	mov    %ecx,%edi
  800cb6:	89 ce                	mov    %ecx,%esi
  800cb8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 03                	push   $0x3
  800ccc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800ccf:	8d 83 20 f2 ff ff    	lea    -0xde0(%ebx),%eax
  800cd5:	50                   	push   %eax
  800cd6:	6a 24                	push   $0x24
  800cd8:	8d 83 3d f2 ff ff    	lea    -0xdc3(%ebx),%eax
  800cde:	50                   	push   %eax
  800cdf:	e8 8e f4 ff ff       	call   800172 <_panic>

00800ce4 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <__x86.get_pc_thunk.ax>:
  800d03:	8b 04 24             	mov    (%esp),%eax
  800d06:	c3                   	ret    
  800d07:	66 90                	xchg   %ax,%ax
  800d09:	66 90                	xchg   %ax,%ax
  800d0b:	66 90                	xchg   %ax,%ax
  800d0d:	66 90                	xchg   %ax,%ax
  800d0f:	90                   	nop

00800d10 <__udivdi3>:
  800d10:	55                   	push   %ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 1c             	sub    $0x1c,%esp
  800d17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d27:	85 d2                	test   %edx,%edx
  800d29:	75 35                	jne    800d60 <__udivdi3+0x50>
  800d2b:	39 f3                	cmp    %esi,%ebx
  800d2d:	0f 87 bd 00 00 00    	ja     800df0 <__udivdi3+0xe0>
  800d33:	85 db                	test   %ebx,%ebx
  800d35:	89 d9                	mov    %ebx,%ecx
  800d37:	75 0b                	jne    800d44 <__udivdi3+0x34>
  800d39:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3e:	31 d2                	xor    %edx,%edx
  800d40:	f7 f3                	div    %ebx
  800d42:	89 c1                	mov    %eax,%ecx
  800d44:	31 d2                	xor    %edx,%edx
  800d46:	89 f0                	mov    %esi,%eax
  800d48:	f7 f1                	div    %ecx
  800d4a:	89 c6                	mov    %eax,%esi
  800d4c:	89 e8                	mov    %ebp,%eax
  800d4e:	89 f7                	mov    %esi,%edi
  800d50:	f7 f1                	div    %ecx
  800d52:	89 fa                	mov    %edi,%edx
  800d54:	83 c4 1c             	add    $0x1c,%esp
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    
  800d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d60:	39 f2                	cmp    %esi,%edx
  800d62:	77 7c                	ja     800de0 <__udivdi3+0xd0>
  800d64:	0f bd fa             	bsr    %edx,%edi
  800d67:	83 f7 1f             	xor    $0x1f,%edi
  800d6a:	0f 84 98 00 00 00    	je     800e08 <__udivdi3+0xf8>
  800d70:	89 f9                	mov    %edi,%ecx
  800d72:	b8 20 00 00 00       	mov    $0x20,%eax
  800d77:	29 f8                	sub    %edi,%eax
  800d79:	d3 e2                	shl    %cl,%edx
  800d7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d7f:	89 c1                	mov    %eax,%ecx
  800d81:	89 da                	mov    %ebx,%edx
  800d83:	d3 ea                	shr    %cl,%edx
  800d85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d89:	09 d1                	or     %edx,%ecx
  800d8b:	89 f2                	mov    %esi,%edx
  800d8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d91:	89 f9                	mov    %edi,%ecx
  800d93:	d3 e3                	shl    %cl,%ebx
  800d95:	89 c1                	mov    %eax,%ecx
  800d97:	d3 ea                	shr    %cl,%edx
  800d99:	89 f9                	mov    %edi,%ecx
  800d9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d9f:	d3 e6                	shl    %cl,%esi
  800da1:	89 eb                	mov    %ebp,%ebx
  800da3:	89 c1                	mov    %eax,%ecx
  800da5:	d3 eb                	shr    %cl,%ebx
  800da7:	09 de                	or     %ebx,%esi
  800da9:	89 f0                	mov    %esi,%eax
  800dab:	f7 74 24 08          	divl   0x8(%esp)
  800daf:	89 d6                	mov    %edx,%esi
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	f7 64 24 0c          	mull   0xc(%esp)
  800db7:	39 d6                	cmp    %edx,%esi
  800db9:	72 0c                	jb     800dc7 <__udivdi3+0xb7>
  800dbb:	89 f9                	mov    %edi,%ecx
  800dbd:	d3 e5                	shl    %cl,%ebp
  800dbf:	39 c5                	cmp    %eax,%ebp
  800dc1:	73 5d                	jae    800e20 <__udivdi3+0x110>
  800dc3:	39 d6                	cmp    %edx,%esi
  800dc5:	75 59                	jne    800e20 <__udivdi3+0x110>
  800dc7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800dca:	31 ff                	xor    %edi,%edi
  800dcc:	89 fa                	mov    %edi,%edx
  800dce:	83 c4 1c             	add    $0x1c,%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    
  800dd6:	8d 76 00             	lea    0x0(%esi),%esi
  800dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800de0:	31 ff                	xor    %edi,%edi
  800de2:	31 c0                	xor    %eax,%eax
  800de4:	89 fa                	mov    %edi,%edx
  800de6:	83 c4 1c             	add    $0x1c,%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
  800dee:	66 90                	xchg   %ax,%ax
  800df0:	31 ff                	xor    %edi,%edi
  800df2:	89 e8                	mov    %ebp,%eax
  800df4:	89 f2                	mov    %esi,%edx
  800df6:	f7 f3                	div    %ebx
  800df8:	89 fa                	mov    %edi,%edx
  800dfa:	83 c4 1c             	add    $0x1c,%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
  800e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e08:	39 f2                	cmp    %esi,%edx
  800e0a:	72 06                	jb     800e12 <__udivdi3+0x102>
  800e0c:	31 c0                	xor    %eax,%eax
  800e0e:	39 eb                	cmp    %ebp,%ebx
  800e10:	77 d2                	ja     800de4 <__udivdi3+0xd4>
  800e12:	b8 01 00 00 00       	mov    $0x1,%eax
  800e17:	eb cb                	jmp    800de4 <__udivdi3+0xd4>
  800e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e20:	89 d8                	mov    %ebx,%eax
  800e22:	31 ff                	xor    %edi,%edi
  800e24:	eb be                	jmp    800de4 <__udivdi3+0xd4>
  800e26:	66 90                	xchg   %ax,%ax
  800e28:	66 90                	xchg   %ax,%ax
  800e2a:	66 90                	xchg   %ax,%ax
  800e2c:	66 90                	xchg   %ax,%ax
  800e2e:	66 90                	xchg   %ax,%ax

00800e30 <__umoddi3>:
  800e30:	55                   	push   %ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 1c             	sub    $0x1c,%esp
  800e37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800e3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800e3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800e47:	85 ed                	test   %ebp,%ebp
  800e49:	89 f0                	mov    %esi,%eax
  800e4b:	89 da                	mov    %ebx,%edx
  800e4d:	75 19                	jne    800e68 <__umoddi3+0x38>
  800e4f:	39 df                	cmp    %ebx,%edi
  800e51:	0f 86 b1 00 00 00    	jbe    800f08 <__umoddi3+0xd8>
  800e57:	f7 f7                	div    %edi
  800e59:	89 d0                	mov    %edx,%eax
  800e5b:	31 d2                	xor    %edx,%edx
  800e5d:	83 c4 1c             	add    $0x1c,%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
  800e65:	8d 76 00             	lea    0x0(%esi),%esi
  800e68:	39 dd                	cmp    %ebx,%ebp
  800e6a:	77 f1                	ja     800e5d <__umoddi3+0x2d>
  800e6c:	0f bd cd             	bsr    %ebp,%ecx
  800e6f:	83 f1 1f             	xor    $0x1f,%ecx
  800e72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e76:	0f 84 b4 00 00 00    	je     800f30 <__umoddi3+0x100>
  800e7c:	b8 20 00 00 00       	mov    $0x20,%eax
  800e81:	89 c2                	mov    %eax,%edx
  800e83:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e87:	29 c2                	sub    %eax,%edx
  800e89:	89 c1                	mov    %eax,%ecx
  800e8b:	89 f8                	mov    %edi,%eax
  800e8d:	d3 e5                	shl    %cl,%ebp
  800e8f:	89 d1                	mov    %edx,%ecx
  800e91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e95:	d3 e8                	shr    %cl,%eax
  800e97:	09 c5                	or     %eax,%ebp
  800e99:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e9d:	89 c1                	mov    %eax,%ecx
  800e9f:	d3 e7                	shl    %cl,%edi
  800ea1:	89 d1                	mov    %edx,%ecx
  800ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	d3 ef                	shr    %cl,%edi
  800eab:	89 c1                	mov    %eax,%ecx
  800ead:	89 f0                	mov    %esi,%eax
  800eaf:	d3 e3                	shl    %cl,%ebx
  800eb1:	89 d1                	mov    %edx,%ecx
  800eb3:	89 fa                	mov    %edi,%edx
  800eb5:	d3 e8                	shr    %cl,%eax
  800eb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800ebc:	09 d8                	or     %ebx,%eax
  800ebe:	f7 f5                	div    %ebp
  800ec0:	d3 e6                	shl    %cl,%esi
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	f7 64 24 08          	mull   0x8(%esp)
  800ec8:	39 d1                	cmp    %edx,%ecx
  800eca:	89 c3                	mov    %eax,%ebx
  800ecc:	89 d7                	mov    %edx,%edi
  800ece:	72 06                	jb     800ed6 <__umoddi3+0xa6>
  800ed0:	75 0e                	jne    800ee0 <__umoddi3+0xb0>
  800ed2:	39 c6                	cmp    %eax,%esi
  800ed4:	73 0a                	jae    800ee0 <__umoddi3+0xb0>
  800ed6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800eda:	19 ea                	sbb    %ebp,%edx
  800edc:	89 d7                	mov    %edx,%edi
  800ede:	89 c3                	mov    %eax,%ebx
  800ee0:	89 ca                	mov    %ecx,%edx
  800ee2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800ee7:	29 de                	sub    %ebx,%esi
  800ee9:	19 fa                	sbb    %edi,%edx
  800eeb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800eef:	89 d0                	mov    %edx,%eax
  800ef1:	d3 e0                	shl    %cl,%eax
  800ef3:	89 d9                	mov    %ebx,%ecx
  800ef5:	d3 ee                	shr    %cl,%esi
  800ef7:	d3 ea                	shr    %cl,%edx
  800ef9:	09 f0                	or     %esi,%eax
  800efb:	83 c4 1c             	add    $0x1c,%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
  800f03:	90                   	nop
  800f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f08:	85 ff                	test   %edi,%edi
  800f0a:	89 f9                	mov    %edi,%ecx
  800f0c:	75 0b                	jne    800f19 <__umoddi3+0xe9>
  800f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f13:	31 d2                	xor    %edx,%edx
  800f15:	f7 f7                	div    %edi
  800f17:	89 c1                	mov    %eax,%ecx
  800f19:	89 d8                	mov    %ebx,%eax
  800f1b:	31 d2                	xor    %edx,%edx
  800f1d:	f7 f1                	div    %ecx
  800f1f:	89 f0                	mov    %esi,%eax
  800f21:	f7 f1                	div    %ecx
  800f23:	e9 31 ff ff ff       	jmp    800e59 <__umoddi3+0x29>
  800f28:	90                   	nop
  800f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f30:	39 dd                	cmp    %ebx,%ebp
  800f32:	72 08                	jb     800f3c <__umoddi3+0x10c>
  800f34:	39 f7                	cmp    %esi,%edi
  800f36:	0f 87 21 ff ff ff    	ja     800e5d <__umoddi3+0x2d>
  800f3c:	89 da                	mov    %ebx,%edx
  800f3e:	89 f0                	mov    %esi,%eax
  800f40:	29 f8                	sub    %edi,%eax
  800f42:	19 ea                	sbb    %ebp,%edx
  800f44:	e9 14 ff ff ff       	jmp    800e5d <__umoddi3+0x2d>
