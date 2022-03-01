
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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 60 10 80 00       	push   $0x801060
  80003e:	e8 cc 01 00 00       	call   80020f <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 20 80 00 	cmpl   $0x0,0x802020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 20 80 00 	mov    %eax,0x802020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 20 80 00 	cmp    %eax,0x802020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 a8 10 80 00       	push   $0x8010a8
  800095:	e8 75 01 00 00       	call   80020f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 07 11 80 00       	push   $0x801107
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 f8 10 80 00       	push   $0x8010f8
  8000b3:	e8 7c 00 00 00       	call   800134 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 db 10 80 00       	push   $0x8010db
  8000be:	6a 11                	push   $0x11
  8000c0:	68 f8 10 80 00       	push   $0x8010f8
  8000c5:	e8 6a 00 00 00       	call   800134 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 80 10 80 00       	push   $0x801080
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 f8 10 80 00       	push   $0x8010f8
  8000d7:	e8 58 00 00 00       	call   800134 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 3c 0b 00 00       	call   800c28 <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f9:	a3 20 20 c0 00       	mov    %eax,0xc02020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x2d>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800128:	6a 00                	push   $0x0
  80012a:	e8 b8 0a 00 00       	call   800be7 <sys_env_destroy>
}
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	c9                   	leave  
  800133:	c3                   	ret    

00800134 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800139:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80013c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800142:	e8 e1 0a 00 00       	call   800c28 <sys_getenvid>
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	ff 75 0c             	pushl  0xc(%ebp)
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	56                   	push   %esi
  800151:	50                   	push   %eax
  800152:	68 28 11 80 00       	push   $0x801128
  800157:	e8 b3 00 00 00       	call   80020f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015c:	83 c4 18             	add    $0x18,%esp
  80015f:	53                   	push   %ebx
  800160:	ff 75 10             	pushl  0x10(%ebp)
  800163:	e8 56 00 00 00       	call   8001be <vcprintf>
	cprintf("\n");
  800168:	c7 04 24 f6 10 80 00 	movl   $0x8010f6,(%esp)
  80016f:	e8 9b 00 00 00       	call   80020f <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800177:	cc                   	int3   
  800178:	eb fd                	jmp    800177 <_panic+0x43>

0080017a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	53                   	push   %ebx
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800184:	8b 13                	mov    (%ebx),%edx
  800186:	8d 42 01             	lea    0x1(%edx),%eax
  800189:	89 03                	mov    %eax,(%ebx)
  80018b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800192:	3d ff 00 00 00       	cmp    $0xff,%eax
  800197:	74 09                	je     8001a2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800199:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 ff 00 00 00       	push   $0xff
  8001aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ad:	50                   	push   %eax
  8001ae:	e8 f7 09 00 00       	call   800baa <sys_cputs>
		b->idx = 0;
  8001b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b9:	83 c4 10             	add    $0x10,%esp
  8001bc:	eb db                	jmp    800199 <putch+0x1f>

008001be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ce:	00 00 00 
	b.cnt = 0;
  8001d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001db:	ff 75 0c             	pushl  0xc(%ebp)
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e7:	50                   	push   %eax
  8001e8:	68 7a 01 80 00       	push   $0x80017a
  8001ed:	e8 1a 01 00 00       	call   80030c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f2:	83 c4 08             	add    $0x8,%esp
  8001f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800201:	50                   	push   %eax
  800202:	e8 a3 09 00 00       	call   800baa <sys_cputs>

	return b.cnt;
}
  800207:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800215:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800218:	50                   	push   %eax
  800219:	ff 75 08             	pushl  0x8(%ebp)
  80021c:	e8 9d ff ff ff       	call   8001be <vcprintf>
	va_end(ap);

	return cnt;
}
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	57                   	push   %edi
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	83 ec 1c             	sub    $0x1c,%esp
  80022c:	89 c7                	mov    %eax,%edi
  80022e:	89 d6                	mov    %edx,%esi
  800230:	8b 45 08             	mov    0x8(%ebp),%eax
  800233:	8b 55 0c             	mov    0xc(%ebp),%edx
  800236:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800239:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80023c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80023f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800244:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800247:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80024a:	39 d3                	cmp    %edx,%ebx
  80024c:	72 05                	jb     800253 <printnum+0x30>
  80024e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800251:	77 7a                	ja     8002cd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	ff 75 18             	pushl  0x18(%ebp)
  800259:	8b 45 14             	mov    0x14(%ebp),%eax
  80025c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80025f:	53                   	push   %ebx
  800260:	ff 75 10             	pushl  0x10(%ebp)
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 a9 0b 00 00       	call   800e20 <__udivdi3>
  800277:	83 c4 18             	add    $0x18,%esp
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	89 f2                	mov    %esi,%edx
  80027e:	89 f8                	mov    %edi,%eax
  800280:	e8 9e ff ff ff       	call   800223 <printnum>
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	eb 13                	jmp    80029d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	ff 75 18             	pushl  0x18(%ebp)
  800291:	ff d7                	call   *%edi
  800293:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800296:	83 eb 01             	sub    $0x1,%ebx
  800299:	85 db                	test   %ebx,%ebx
  80029b:	7f ed                	jg     80028a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	56                   	push   %esi
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	e8 8b 0c 00 00       	call   800f40 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 4c 11 80 00 	movsbl 0x80114c(%eax),%eax
  8002bf:	50                   	push   %eax
  8002c0:	ff d7                	call   *%edi
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    
  8002cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002d0:	eb c4                	jmp    800296 <printnum+0x73>

008002d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002dc:	8b 10                	mov    (%eax),%edx
  8002de:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e1:	73 0a                	jae    8002ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e6:	89 08                	mov    %ecx,(%eax)
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	88 02                	mov    %al,(%edx)
}
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <printfmt>:
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f8:	50                   	push   %eax
  8002f9:	ff 75 10             	pushl  0x10(%ebp)
  8002fc:	ff 75 0c             	pushl  0xc(%ebp)
  8002ff:	ff 75 08             	pushl  0x8(%ebp)
  800302:	e8 05 00 00 00       	call   80030c <vprintfmt>
}
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	c9                   	leave  
  80030b:	c3                   	ret    

0080030c <vprintfmt>:
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 2c             	sub    $0x2c,%esp
  800315:	8b 75 08             	mov    0x8(%ebp),%esi
  800318:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80031b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031e:	e9 00 04 00 00       	jmp    800723 <vprintfmt+0x417>
		padc = ' ';
  800323:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800327:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80032e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800335:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800341:	8d 47 01             	lea    0x1(%edi),%eax
  800344:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800347:	0f b6 17             	movzbl (%edi),%edx
  80034a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80034d:	3c 55                	cmp    $0x55,%al
  80034f:	0f 87 51 04 00 00    	ja     8007a6 <vprintfmt+0x49a>
  800355:	0f b6 c0             	movzbl %al,%eax
  800358:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  80035f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800362:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800366:	eb d9                	jmp    800341 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80036b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80036f:	eb d0                	jmp    800341 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800371:	0f b6 d2             	movzbl %dl,%edx
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800377:	b8 00 00 00 00       	mov    $0x0,%eax
  80037c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80037f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800382:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800386:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800389:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80038c:	83 f9 09             	cmp    $0x9,%ecx
  80038f:	77 55                	ja     8003e6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800391:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800394:	eb e9                	jmp    80037f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800396:	8b 45 14             	mov    0x14(%ebp),%eax
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8d 40 04             	lea    0x4(%eax),%eax
  8003a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ae:	79 91                	jns    800341 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003bd:	eb 82                	jmp    800341 <vprintfmt+0x35>
  8003bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	0f 49 d0             	cmovns %eax,%edx
  8003cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d2:	e9 6a ff ff ff       	jmp    800341 <vprintfmt+0x35>
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003da:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e1:	e9 5b ff ff ff       	jmp    800341 <vprintfmt+0x35>
  8003e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ec:	eb bc                	jmp    8003aa <vprintfmt+0x9e>
			lflag++;
  8003ee:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f4:	e9 48 ff ff ff       	jmp    800341 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 78 04             	lea    0x4(%eax),%edi
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	53                   	push   %ebx
  800403:	ff 30                	pushl  (%eax)
  800405:	ff d6                	call   *%esi
			break;
  800407:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80040a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80040d:	e9 0e 03 00 00       	jmp    800720 <vprintfmt+0x414>
			err = va_arg(ap, int);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 78 04             	lea    0x4(%eax),%edi
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	99                   	cltd   
  80041b:	31 d0                	xor    %edx,%eax
  80041d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041f:	83 f8 08             	cmp    $0x8,%eax
  800422:	7f 23                	jg     800447 <vprintfmt+0x13b>
  800424:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  80042b:	85 d2                	test   %edx,%edx
  80042d:	74 18                	je     800447 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80042f:	52                   	push   %edx
  800430:	68 6d 11 80 00       	push   $0x80116d
  800435:	53                   	push   %ebx
  800436:	56                   	push   %esi
  800437:	e8 b3 fe ff ff       	call   8002ef <printfmt>
  80043c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800442:	e9 d9 02 00 00       	jmp    800720 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800447:	50                   	push   %eax
  800448:	68 64 11 80 00       	push   $0x801164
  80044d:	53                   	push   %ebx
  80044e:	56                   	push   %esi
  80044f:	e8 9b fe ff ff       	call   8002ef <printfmt>
  800454:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800457:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045a:	e9 c1 02 00 00       	jmp    800720 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80046d:	85 ff                	test   %edi,%edi
  80046f:	b8 5d 11 80 00       	mov    $0x80115d,%eax
  800474:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047b:	0f 8e bd 00 00 00    	jle    80053e <vprintfmt+0x232>
  800481:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800485:	75 0e                	jne    800495 <vprintfmt+0x189>
  800487:	89 75 08             	mov    %esi,0x8(%ebp)
  80048a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800490:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800493:	eb 6d                	jmp    800502 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 d0             	pushl  -0x30(%ebp)
  80049b:	57                   	push   %edi
  80049c:	e8 ad 03 00 00       	call   80084e <strnlen>
  8004a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a4:	29 c1                	sub    %eax,%ecx
  8004a6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004a9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004ac:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004b6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	eb 0f                	jmp    8004c9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	53                   	push   %ebx
  8004be:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	83 ef 01             	sub    $0x1,%edi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	85 ff                	test   %edi,%edi
  8004cb:	7f ed                	jg     8004ba <vprintfmt+0x1ae>
  8004cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004d3:	85 c9                	test   %ecx,%ecx
  8004d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004da:	0f 49 c1             	cmovns %ecx,%eax
  8004dd:	29 c1                	sub    %eax,%ecx
  8004df:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e8:	89 cb                	mov    %ecx,%ebx
  8004ea:	eb 16                	jmp    800502 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f0:	75 31                	jne    800523 <vprintfmt+0x217>
					putch(ch, putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	ff 75 0c             	pushl  0xc(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 55 08             	call   *0x8(%ebp)
  8004fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ff:	83 eb 01             	sub    $0x1,%ebx
  800502:	83 c7 01             	add    $0x1,%edi
  800505:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800509:	0f be c2             	movsbl %dl,%eax
  80050c:	85 c0                	test   %eax,%eax
  80050e:	74 59                	je     800569 <vprintfmt+0x25d>
  800510:	85 f6                	test   %esi,%esi
  800512:	78 d8                	js     8004ec <vprintfmt+0x1e0>
  800514:	83 ee 01             	sub    $0x1,%esi
  800517:	79 d3                	jns    8004ec <vprintfmt+0x1e0>
  800519:	89 df                	mov    %ebx,%edi
  80051b:	8b 75 08             	mov    0x8(%ebp),%esi
  80051e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800521:	eb 37                	jmp    80055a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800523:	0f be d2             	movsbl %dl,%edx
  800526:	83 ea 20             	sub    $0x20,%edx
  800529:	83 fa 5e             	cmp    $0x5e,%edx
  80052c:	76 c4                	jbe    8004f2 <vprintfmt+0x1e6>
					putch('?', putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	ff 75 0c             	pushl  0xc(%ebp)
  800534:	6a 3f                	push   $0x3f
  800536:	ff 55 08             	call   *0x8(%ebp)
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	eb c1                	jmp    8004ff <vprintfmt+0x1f3>
  80053e:	89 75 08             	mov    %esi,0x8(%ebp)
  800541:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800544:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800547:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80054a:	eb b6                	jmp    800502 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	53                   	push   %ebx
  800550:	6a 20                	push   $0x20
  800552:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800554:	83 ef 01             	sub    $0x1,%edi
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	85 ff                	test   %edi,%edi
  80055c:	7f ee                	jg     80054c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80055e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800561:	89 45 14             	mov    %eax,0x14(%ebp)
  800564:	e9 b7 01 00 00       	jmp    800720 <vprintfmt+0x414>
  800569:	89 df                	mov    %ebx,%edi
  80056b:	8b 75 08             	mov    0x8(%ebp),%esi
  80056e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800571:	eb e7                	jmp    80055a <vprintfmt+0x24e>
	if (lflag >= 2)
  800573:	83 f9 01             	cmp    $0x1,%ecx
  800576:	7e 3f                	jle    8005b7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8b 50 04             	mov    0x4(%eax),%edx
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800583:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8d 40 08             	lea    0x8(%eax),%eax
  80058c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80058f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800593:	79 5c                	jns    8005f1 <vprintfmt+0x2e5>
				putch('-', putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	53                   	push   %ebx
  800599:	6a 2d                	push   $0x2d
  80059b:	ff d6                	call   *%esi
				num = -(long long) num;
  80059d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a3:	f7 da                	neg    %edx
  8005a5:	83 d1 00             	adc    $0x0,%ecx
  8005a8:	f7 d9                	neg    %ecx
  8005aa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b2:	e9 4f 01 00 00       	jmp    800706 <vprintfmt+0x3fa>
	else if (lflag)
  8005b7:	85 c9                	test   %ecx,%ecx
  8005b9:	75 1b                	jne    8005d6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c3:	89 c1                	mov    %eax,%ecx
  8005c5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 40 04             	lea    0x4(%eax),%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d4:	eb b9                	jmp    80058f <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 c1                	mov    %eax,%ecx
  8005e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	eb 9e                	jmp    80058f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fc:	e9 05 01 00 00       	jmp    800706 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800601:	83 f9 01             	cmp    $0x1,%ecx
  800604:	7e 18                	jle    80061e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 48 04             	mov    0x4(%eax),%ecx
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 e8 00 00 00       	jmp    800706 <vprintfmt+0x3fa>
	else if (lflag)
  80061e:	85 c9                	test   %ecx,%ecx
  800620:	75 1a                	jne    80063c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062c:	8d 40 04             	lea    0x4(%eax),%eax
  80062f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
  800637:	e9 ca 00 00 00       	jmp    800706 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 10                	mov    (%eax),%edx
  800641:	b9 00 00 00 00       	mov    $0x0,%ecx
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800651:	e9 b0 00 00 00       	jmp    800706 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800656:	83 f9 01             	cmp    $0x1,%ecx
  800659:	7e 3c                	jle    800697 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 50 04             	mov    0x4(%eax),%edx
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800666:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 40 08             	lea    0x8(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800672:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800676:	79 59                	jns    8006d1 <vprintfmt+0x3c5>
                putch('-', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 2d                	push   $0x2d
  80067e:	ff d6                	call   *%esi
                num = -(long long) num;
  800680:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800683:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800686:	f7 da                	neg    %edx
  800688:	83 d1 00             	adc    $0x0,%ecx
  80068b:	f7 d9                	neg    %ecx
  80068d:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800690:	b8 08 00 00 00       	mov    $0x8,%eax
  800695:	eb 6f                	jmp    800706 <vprintfmt+0x3fa>
	else if (lflag)
  800697:	85 c9                	test   %ecx,%ecx
  800699:	75 1b                	jne    8006b6 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a3:	89 c1                	mov    %eax,%ecx
  8006a5:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8d 40 04             	lea    0x4(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b4:	eb bc                	jmp    800672 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 c1                	mov    %eax,%ecx
  8006c0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8d 40 04             	lea    0x4(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cf:	eb a1                	jmp    800672 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006dc:	eb 28                	jmp    800706 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	6a 30                	push   $0x30
  8006e4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e6:	83 c4 08             	add    $0x8,%esp
  8006e9:	53                   	push   %ebx
  8006ea:	6a 78                	push   $0x78
  8006ec:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 10                	mov    (%eax),%edx
  8006f3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006f8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800701:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80070d:	57                   	push   %edi
  80070e:	ff 75 e0             	pushl  -0x20(%ebp)
  800711:	50                   	push   %eax
  800712:	51                   	push   %ecx
  800713:	52                   	push   %edx
  800714:	89 da                	mov    %ebx,%edx
  800716:	89 f0                	mov    %esi,%eax
  800718:	e8 06 fb ff ff       	call   800223 <printnum>
			break;
  80071d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800720:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800723:	83 c7 01             	add    $0x1,%edi
  800726:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072a:	83 f8 25             	cmp    $0x25,%eax
  80072d:	0f 84 f0 fb ff ff    	je     800323 <vprintfmt+0x17>
			if (ch == '\0')
  800733:	85 c0                	test   %eax,%eax
  800735:	0f 84 8b 00 00 00    	je     8007c6 <vprintfmt+0x4ba>
			putch(ch, putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	50                   	push   %eax
  800740:	ff d6                	call   *%esi
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	eb dc                	jmp    800723 <vprintfmt+0x417>
	if (lflag >= 2)
  800747:	83 f9 01             	cmp    $0x1,%ecx
  80074a:	7e 15                	jle    800761 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 10                	mov    (%eax),%edx
  800751:	8b 48 04             	mov    0x4(%eax),%ecx
  800754:	8d 40 08             	lea    0x8(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075a:	b8 10 00 00 00       	mov    $0x10,%eax
  80075f:	eb a5                	jmp    800706 <vprintfmt+0x3fa>
	else if (lflag)
  800761:	85 c9                	test   %ecx,%ecx
  800763:	75 17                	jne    80077c <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
  80077a:	eb 8a                	jmp    800706 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 10                	mov    (%eax),%edx
  800781:	b9 00 00 00 00       	mov    $0x0,%ecx
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078c:	b8 10 00 00 00       	mov    $0x10,%eax
  800791:	e9 70 ff ff ff       	jmp    800706 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	6a 25                	push   $0x25
  80079c:	ff d6                	call   *%esi
			break;
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	e9 7a ff ff ff       	jmp    800720 <vprintfmt+0x414>
			putch('%', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	6a 25                	push   $0x25
  8007ac:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	89 f8                	mov    %edi,%eax
  8007b3:	eb 03                	jmp    8007b8 <vprintfmt+0x4ac>
  8007b5:	83 e8 01             	sub    $0x1,%eax
  8007b8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007bc:	75 f7                	jne    8007b5 <vprintfmt+0x4a9>
  8007be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c1:	e9 5a ff ff ff       	jmp    800720 <vprintfmt+0x414>
}
  8007c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c9:	5b                   	pop    %ebx
  8007ca:	5e                   	pop    %esi
  8007cb:	5f                   	pop    %edi
  8007cc:	5d                   	pop    %ebp
  8007cd:	c3                   	ret    

008007ce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	83 ec 18             	sub    $0x18,%esp
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007dd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	74 26                	je     800815 <vsnprintf+0x47>
  8007ef:	85 d2                	test   %edx,%edx
  8007f1:	7e 22                	jle    800815 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f3:	ff 75 14             	pushl  0x14(%ebp)
  8007f6:	ff 75 10             	pushl  0x10(%ebp)
  8007f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007fc:	50                   	push   %eax
  8007fd:	68 d2 02 80 00       	push   $0x8002d2
  800802:	e8 05 fb ff ff       	call   80030c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800810:	83 c4 10             	add    $0x10,%esp
}
  800813:	c9                   	leave  
  800814:	c3                   	ret    
		return -E_INVAL;
  800815:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081a:	eb f7                	jmp    800813 <vsnprintf+0x45>

0080081c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800822:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800825:	50                   	push   %eax
  800826:	ff 75 10             	pushl  0x10(%ebp)
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	ff 75 08             	pushl  0x8(%ebp)
  80082f:	e8 9a ff ff ff       	call   8007ce <vsnprintf>
	va_end(ap);

	return rc;
}
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	eb 03                	jmp    800846 <strlen+0x10>
		n++;
  800843:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800846:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084a:	75 f7                	jne    800843 <strlen+0xd>
	return n;
}
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800854:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	eb 03                	jmp    800861 <strnlen+0x13>
		n++;
  80085e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800861:	39 d0                	cmp    %edx,%eax
  800863:	74 06                	je     80086b <strnlen+0x1d>
  800865:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800869:	75 f3                	jne    80085e <strnlen+0x10>
	return n;
}
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	53                   	push   %ebx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800877:	89 c2                	mov    %eax,%edx
  800879:	83 c1 01             	add    $0x1,%ecx
  80087c:	83 c2 01             	add    $0x1,%edx
  80087f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800883:	88 5a ff             	mov    %bl,-0x1(%edx)
  800886:	84 db                	test   %bl,%bl
  800888:	75 ef                	jne    800879 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80088a:	5b                   	pop    %ebx
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	53                   	push   %ebx
  800891:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800894:	53                   	push   %ebx
  800895:	e8 9c ff ff ff       	call   800836 <strlen>
  80089a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 c5 ff ff ff       	call   80086d <strcpy>
	return dst;
}
  8008a8:	89 d8                	mov    %ebx,%eax
  8008aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ba:	89 f3                	mov    %esi,%ebx
  8008bc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008bf:	89 f2                	mov    %esi,%edx
  8008c1:	eb 0f                	jmp    8008d2 <strncpy+0x23>
		*dst++ = *src;
  8008c3:	83 c2 01             	add    $0x1,%edx
  8008c6:	0f b6 01             	movzbl (%ecx),%eax
  8008c9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cc:	80 39 01             	cmpb   $0x1,(%ecx)
  8008cf:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008d2:	39 da                	cmp    %ebx,%edx
  8008d4:	75 ed                	jne    8008c3 <strncpy+0x14>
	}
	return ret;
}
  8008d6:	89 f0                	mov    %esi,%eax
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	56                   	push   %esi
  8008e0:	53                   	push   %ebx
  8008e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ea:	89 f0                	mov    %esi,%eax
  8008ec:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f0:	85 c9                	test   %ecx,%ecx
  8008f2:	75 0b                	jne    8008ff <strlcpy+0x23>
  8008f4:	eb 17                	jmp    80090d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008ff:	39 d8                	cmp    %ebx,%eax
  800901:	74 07                	je     80090a <strlcpy+0x2e>
  800903:	0f b6 0a             	movzbl (%edx),%ecx
  800906:	84 c9                	test   %cl,%cl
  800908:	75 ec                	jne    8008f6 <strlcpy+0x1a>
		*dst = '\0';
  80090a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090d:	29 f0                	sub    %esi,%eax
}
  80090f:	5b                   	pop    %ebx
  800910:	5e                   	pop    %esi
  800911:	5d                   	pop    %ebp
  800912:	c3                   	ret    

00800913 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091c:	eb 06                	jmp    800924 <strcmp+0x11>
		p++, q++;
  80091e:	83 c1 01             	add    $0x1,%ecx
  800921:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800924:	0f b6 01             	movzbl (%ecx),%eax
  800927:	84 c0                	test   %al,%al
  800929:	74 04                	je     80092f <strcmp+0x1c>
  80092b:	3a 02                	cmp    (%edx),%al
  80092d:	74 ef                	je     80091e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80092f:	0f b6 c0             	movzbl %al,%eax
  800932:	0f b6 12             	movzbl (%edx),%edx
  800935:	29 d0                	sub    %edx,%eax
}
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	89 c3                	mov    %eax,%ebx
  800945:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800948:	eb 06                	jmp    800950 <strncmp+0x17>
		n--, p++, q++;
  80094a:	83 c0 01             	add    $0x1,%eax
  80094d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800950:	39 d8                	cmp    %ebx,%eax
  800952:	74 16                	je     80096a <strncmp+0x31>
  800954:	0f b6 08             	movzbl (%eax),%ecx
  800957:	84 c9                	test   %cl,%cl
  800959:	74 04                	je     80095f <strncmp+0x26>
  80095b:	3a 0a                	cmp    (%edx),%cl
  80095d:	74 eb                	je     80094a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80095f:	0f b6 00             	movzbl (%eax),%eax
  800962:	0f b6 12             	movzbl (%edx),%edx
  800965:	29 d0                	sub    %edx,%eax
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    
		return 0;
  80096a:	b8 00 00 00 00       	mov    $0x0,%eax
  80096f:	eb f6                	jmp    800967 <strncmp+0x2e>

00800971 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097b:	0f b6 10             	movzbl (%eax),%edx
  80097e:	84 d2                	test   %dl,%dl
  800980:	74 09                	je     80098b <strchr+0x1a>
		if (*s == c)
  800982:	38 ca                	cmp    %cl,%dl
  800984:	74 0a                	je     800990 <strchr+0x1f>
	for (; *s; s++)
  800986:	83 c0 01             	add    $0x1,%eax
  800989:	eb f0                	jmp    80097b <strchr+0xa>
			return (char *) s;
	return 0;
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099c:	eb 03                	jmp    8009a1 <strfind+0xf>
  80099e:	83 c0 01             	add    $0x1,%eax
  8009a1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009a4:	38 ca                	cmp    %cl,%dl
  8009a6:	74 04                	je     8009ac <strfind+0x1a>
  8009a8:	84 d2                	test   %dl,%dl
  8009aa:	75 f2                	jne    80099e <strfind+0xc>
			break;
	return (char *) s;
}
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	57                   	push   %edi
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ba:	85 c9                	test   %ecx,%ecx
  8009bc:	74 13                	je     8009d1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009be:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009c4:	75 05                	jne    8009cb <memset+0x1d>
  8009c6:	f6 c1 03             	test   $0x3,%cl
  8009c9:	74 0d                	je     8009d8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ce:	fc                   	cld    
  8009cf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d1:	89 f8                	mov    %edi,%eax
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5f                   	pop    %edi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    
		c &= 0xFF;
  8009d8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009dc:	89 d3                	mov    %edx,%ebx
  8009de:	c1 e3 08             	shl    $0x8,%ebx
  8009e1:	89 d0                	mov    %edx,%eax
  8009e3:	c1 e0 18             	shl    $0x18,%eax
  8009e6:	89 d6                	mov    %edx,%esi
  8009e8:	c1 e6 10             	shl    $0x10,%esi
  8009eb:	09 f0                	or     %esi,%eax
  8009ed:	09 c2                	or     %eax,%edx
  8009ef:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009f1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f4:	89 d0                	mov    %edx,%eax
  8009f6:	fc                   	cld    
  8009f7:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f9:	eb d6                	jmp    8009d1 <memset+0x23>

008009fb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	57                   	push   %edi
  8009ff:	56                   	push   %esi
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a06:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a09:	39 c6                	cmp    %eax,%esi
  800a0b:	73 35                	jae    800a42 <memmove+0x47>
  800a0d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a10:	39 c2                	cmp    %eax,%edx
  800a12:	76 2e                	jbe    800a42 <memmove+0x47>
		s += n;
		d += n;
  800a14:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a17:	89 d6                	mov    %edx,%esi
  800a19:	09 fe                	or     %edi,%esi
  800a1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a21:	74 0c                	je     800a2f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a23:	83 ef 01             	sub    $0x1,%edi
  800a26:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a29:	fd                   	std    
  800a2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2c:	fc                   	cld    
  800a2d:	eb 21                	jmp    800a50 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2f:	f6 c1 03             	test   $0x3,%cl
  800a32:	75 ef                	jne    800a23 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a34:	83 ef 04             	sub    $0x4,%edi
  800a37:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a3a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a3d:	fd                   	std    
  800a3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a40:	eb ea                	jmp    800a2c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a42:	89 f2                	mov    %esi,%edx
  800a44:	09 c2                	or     %eax,%edx
  800a46:	f6 c2 03             	test   $0x3,%dl
  800a49:	74 09                	je     800a54 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a4b:	89 c7                	mov    %eax,%edi
  800a4d:	fc                   	cld    
  800a4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a50:	5e                   	pop    %esi
  800a51:	5f                   	pop    %edi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 f2                	jne    800a4b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a59:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb ed                	jmp    800a50 <memmove+0x55>

00800a63 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a66:	ff 75 10             	pushl  0x10(%ebp)
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	e8 87 ff ff ff       	call   8009fb <memmove>
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	56                   	push   %esi
  800a7a:	53                   	push   %ebx
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a81:	89 c6                	mov    %eax,%esi
  800a83:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a86:	39 f0                	cmp    %esi,%eax
  800a88:	74 1c                	je     800aa6 <memcmp+0x30>
		if (*s1 != *s2)
  800a8a:	0f b6 08             	movzbl (%eax),%ecx
  800a8d:	0f b6 1a             	movzbl (%edx),%ebx
  800a90:	38 d9                	cmp    %bl,%cl
  800a92:	75 08                	jne    800a9c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a94:	83 c0 01             	add    $0x1,%eax
  800a97:	83 c2 01             	add    $0x1,%edx
  800a9a:	eb ea                	jmp    800a86 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a9c:	0f b6 c1             	movzbl %cl,%eax
  800a9f:	0f b6 db             	movzbl %bl,%ebx
  800aa2:	29 d8                	sub    %ebx,%eax
  800aa4:	eb 05                	jmp    800aab <memcmp+0x35>
	}

	return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab8:	89 c2                	mov    %eax,%edx
  800aba:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800abd:	39 d0                	cmp    %edx,%eax
  800abf:	73 09                	jae    800aca <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac1:	38 08                	cmp    %cl,(%eax)
  800ac3:	74 05                	je     800aca <memfind+0x1b>
	for (; s < ends; s++)
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	eb f3                	jmp    800abd <memfind+0xe>
			break;
	return (void *) s;
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	57                   	push   %edi
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad8:	eb 03                	jmp    800add <strtol+0x11>
		s++;
  800ada:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800add:	0f b6 01             	movzbl (%ecx),%eax
  800ae0:	3c 20                	cmp    $0x20,%al
  800ae2:	74 f6                	je     800ada <strtol+0xe>
  800ae4:	3c 09                	cmp    $0x9,%al
  800ae6:	74 f2                	je     800ada <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ae8:	3c 2b                	cmp    $0x2b,%al
  800aea:	74 2e                	je     800b1a <strtol+0x4e>
	int neg = 0;
  800aec:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af1:	3c 2d                	cmp    $0x2d,%al
  800af3:	74 2f                	je     800b24 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800afb:	75 05                	jne    800b02 <strtol+0x36>
  800afd:	80 39 30             	cmpb   $0x30,(%ecx)
  800b00:	74 2c                	je     800b2e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b02:	85 db                	test   %ebx,%ebx
  800b04:	75 0a                	jne    800b10 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b06:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b0b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0e:	74 28                	je     800b38 <strtol+0x6c>
		base = 10;
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b18:	eb 50                	jmp    800b6a <strtol+0x9e>
		s++;
  800b1a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b22:	eb d1                	jmp    800af5 <strtol+0x29>
		s++, neg = 1;
  800b24:	83 c1 01             	add    $0x1,%ecx
  800b27:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2c:	eb c7                	jmp    800af5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b32:	74 0e                	je     800b42 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b34:	85 db                	test   %ebx,%ebx
  800b36:	75 d8                	jne    800b10 <strtol+0x44>
		s++, base = 8;
  800b38:	83 c1 01             	add    $0x1,%ecx
  800b3b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b40:	eb ce                	jmp    800b10 <strtol+0x44>
		s += 2, base = 16;
  800b42:	83 c1 02             	add    $0x2,%ecx
  800b45:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4a:	eb c4                	jmp    800b10 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b4c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4f:	89 f3                	mov    %esi,%ebx
  800b51:	80 fb 19             	cmp    $0x19,%bl
  800b54:	77 29                	ja     800b7f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b56:	0f be d2             	movsbl %dl,%edx
  800b59:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5f:	7d 30                	jge    800b91 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b61:	83 c1 01             	add    $0x1,%ecx
  800b64:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b68:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b6a:	0f b6 11             	movzbl (%ecx),%edx
  800b6d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b70:	89 f3                	mov    %esi,%ebx
  800b72:	80 fb 09             	cmp    $0x9,%bl
  800b75:	77 d5                	ja     800b4c <strtol+0x80>
			dig = *s - '0';
  800b77:	0f be d2             	movsbl %dl,%edx
  800b7a:	83 ea 30             	sub    $0x30,%edx
  800b7d:	eb dd                	jmp    800b5c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b7f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b82:	89 f3                	mov    %esi,%ebx
  800b84:	80 fb 19             	cmp    $0x19,%bl
  800b87:	77 08                	ja     800b91 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b89:	0f be d2             	movsbl %dl,%edx
  800b8c:	83 ea 37             	sub    $0x37,%edx
  800b8f:	eb cb                	jmp    800b5c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	74 05                	je     800b9c <strtol+0xd0>
		*endptr = (char *) s;
  800b97:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9c:	89 c2                	mov    %eax,%edx
  800b9e:	f7 da                	neg    %edx
  800ba0:	85 ff                	test   %edi,%edi
  800ba2:	0f 45 c2             	cmovne %edx,%eax
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	57                   	push   %edi
  800bae:	56                   	push   %esi
  800baf:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbb:	89 c3                	mov    %eax,%ebx
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	89 c6                	mov    %eax,%esi
  800bc1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <sys_cgetc>:

int
sys_cgetc(void) {
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfd:	89 cb                	mov    %ecx,%ebx
  800bff:	89 cf                	mov    %ecx,%edi
  800c01:	89 ce                	mov    %ecx,%esi
  800c03:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	7f 08                	jg     800c11 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c11:	83 ec 0c             	sub    $0xc,%esp
  800c14:	50                   	push   %eax
  800c15:	6a 03                	push   $0x3
  800c17:	68 a4 13 80 00       	push   $0x8013a4
  800c1c:	6a 24                	push   $0x24
  800c1e:	68 c1 13 80 00       	push   $0x8013c1
  800c23:	e8 0c f5 ff ff       	call   800134 <_panic>

00800c28 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 02 00 00 00       	mov    $0x2,%eax
  800c38:	89 d1                	mov    %edx,%ecx
  800c3a:	89 d3                	mov    %edx,%ebx
  800c3c:	89 d7                	mov    %edx,%edi
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_yield>:

void
sys_yield(void)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c57:	89 d1                	mov    %edx,%ecx
  800c59:	89 d3                	mov    %edx,%ebx
  800c5b:	89 d7                	mov    %edx,%edi
  800c5d:	89 d6                	mov    %edx,%esi
  800c5f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c6f:	be 00 00 00 00       	mov    $0x0,%esi
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c82:	89 f7                	mov    %esi,%edi
  800c84:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c86:	85 c0                	test   %eax,%eax
  800c88:	7f 08                	jg     800c92 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5f                   	pop    %edi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	50                   	push   %eax
  800c96:	6a 04                	push   $0x4
  800c98:	68 a4 13 80 00       	push   $0x8013a4
  800c9d:	6a 24                	push   $0x24
  800c9f:	68 c1 13 80 00       	push   $0x8013c1
  800ca4:	e8 8b f4 ff ff       	call   800134 <_panic>

00800ca9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc3:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc6:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	7f 08                	jg     800cd4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	50                   	push   %eax
  800cd8:	6a 05                	push   $0x5
  800cda:	68 a4 13 80 00       	push   $0x8013a4
  800cdf:	6a 24                	push   $0x24
  800ce1:	68 c1 13 80 00       	push   $0x8013c1
  800ce6:	e8 49 f4 ff ff       	call   800134 <_panic>

00800ceb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 06 00 00 00       	mov    $0x6,%eax
  800d04:	89 df                	mov    %ebx,%edi
  800d06:	89 de                	mov    %ebx,%esi
  800d08:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d0a:	85 c0                	test   %eax,%eax
  800d0c:	7f 08                	jg     800d16 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d16:	83 ec 0c             	sub    $0xc,%esp
  800d19:	50                   	push   %eax
  800d1a:	6a 06                	push   $0x6
  800d1c:	68 a4 13 80 00       	push   $0x8013a4
  800d21:	6a 24                	push   $0x24
  800d23:	68 c1 13 80 00       	push   $0x8013c1
  800d28:	e8 07 f4 ff ff       	call   800134 <_panic>

00800d2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d41:	b8 08 00 00 00       	mov    $0x8,%eax
  800d46:	89 df                	mov    %ebx,%edi
  800d48:	89 de                	mov    %ebx,%esi
  800d4a:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7f 08                	jg     800d58 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5f                   	pop    %edi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	50                   	push   %eax
  800d5c:	6a 08                	push   $0x8
  800d5e:	68 a4 13 80 00       	push   $0x8013a4
  800d63:	6a 24                	push   $0x24
  800d65:	68 c1 13 80 00       	push   $0x8013c1
  800d6a:	e8 c5 f3 ff ff       	call   800134 <_panic>

00800d6f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d83:	b8 09 00 00 00       	mov    $0x9,%eax
  800d88:	89 df                	mov    %ebx,%edi
  800d8a:	89 de                	mov    %ebx,%esi
  800d8c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 09                	push   $0x9
  800da0:	68 a4 13 80 00       	push   $0x8013a4
  800da5:	6a 24                	push   $0x24
  800da7:	68 c1 13 80 00       	push   $0x8013c1
  800dac:	e8 83 f3 ff ff       	call   800134 <_panic>

00800db1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
    asm volatile("int %1\n"
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc2:	be 00 00 00 00       	mov    $0x0,%esi
  800dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dca:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
  800dda:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ddd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dea:	89 cb                	mov    %ecx,%ebx
  800dec:	89 cf                	mov    %ecx,%edi
  800dee:	89 ce                	mov    %ecx,%esi
  800df0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7f 08                	jg     800dfe <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	50                   	push   %eax
  800e02:	6a 0c                	push   $0xc
  800e04:	68 a4 13 80 00       	push   $0x8013a4
  800e09:	6a 24                	push   $0x24
  800e0b:	68 c1 13 80 00       	push   $0x8013c1
  800e10:	e8 1f f3 ff ff       	call   800134 <_panic>
  800e15:	66 90                	xchg   %ax,%ax
  800e17:	66 90                	xchg   %ax,%ax
  800e19:	66 90                	xchg   %ax,%ax
  800e1b:	66 90                	xchg   %ax,%ax
  800e1d:	66 90                	xchg   %ax,%ax
  800e1f:	90                   	nop

00800e20 <__udivdi3>:
  800e20:	55                   	push   %ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 1c             	sub    $0x1c,%esp
  800e27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e37:	85 d2                	test   %edx,%edx
  800e39:	75 35                	jne    800e70 <__udivdi3+0x50>
  800e3b:	39 f3                	cmp    %esi,%ebx
  800e3d:	0f 87 bd 00 00 00    	ja     800f00 <__udivdi3+0xe0>
  800e43:	85 db                	test   %ebx,%ebx
  800e45:	89 d9                	mov    %ebx,%ecx
  800e47:	75 0b                	jne    800e54 <__udivdi3+0x34>
  800e49:	b8 01 00 00 00       	mov    $0x1,%eax
  800e4e:	31 d2                	xor    %edx,%edx
  800e50:	f7 f3                	div    %ebx
  800e52:	89 c1                	mov    %eax,%ecx
  800e54:	31 d2                	xor    %edx,%edx
  800e56:	89 f0                	mov    %esi,%eax
  800e58:	f7 f1                	div    %ecx
  800e5a:	89 c6                	mov    %eax,%esi
  800e5c:	89 e8                	mov    %ebp,%eax
  800e5e:	89 f7                	mov    %esi,%edi
  800e60:	f7 f1                	div    %ecx
  800e62:	89 fa                	mov    %edi,%edx
  800e64:	83 c4 1c             	add    $0x1c,%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
  800e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e70:	39 f2                	cmp    %esi,%edx
  800e72:	77 7c                	ja     800ef0 <__udivdi3+0xd0>
  800e74:	0f bd fa             	bsr    %edx,%edi
  800e77:	83 f7 1f             	xor    $0x1f,%edi
  800e7a:	0f 84 98 00 00 00    	je     800f18 <__udivdi3+0xf8>
  800e80:	89 f9                	mov    %edi,%ecx
  800e82:	b8 20 00 00 00       	mov    $0x20,%eax
  800e87:	29 f8                	sub    %edi,%eax
  800e89:	d3 e2                	shl    %cl,%edx
  800e8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e8f:	89 c1                	mov    %eax,%ecx
  800e91:	89 da                	mov    %ebx,%edx
  800e93:	d3 ea                	shr    %cl,%edx
  800e95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e99:	09 d1                	or     %edx,%ecx
  800e9b:	89 f2                	mov    %esi,%edx
  800e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ea1:	89 f9                	mov    %edi,%ecx
  800ea3:	d3 e3                	shl    %cl,%ebx
  800ea5:	89 c1                	mov    %eax,%ecx
  800ea7:	d3 ea                	shr    %cl,%edx
  800ea9:	89 f9                	mov    %edi,%ecx
  800eab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800eaf:	d3 e6                	shl    %cl,%esi
  800eb1:	89 eb                	mov    %ebp,%ebx
  800eb3:	89 c1                	mov    %eax,%ecx
  800eb5:	d3 eb                	shr    %cl,%ebx
  800eb7:	09 de                	or     %ebx,%esi
  800eb9:	89 f0                	mov    %esi,%eax
  800ebb:	f7 74 24 08          	divl   0x8(%esp)
  800ebf:	89 d6                	mov    %edx,%esi
  800ec1:	89 c3                	mov    %eax,%ebx
  800ec3:	f7 64 24 0c          	mull   0xc(%esp)
  800ec7:	39 d6                	cmp    %edx,%esi
  800ec9:	72 0c                	jb     800ed7 <__udivdi3+0xb7>
  800ecb:	89 f9                	mov    %edi,%ecx
  800ecd:	d3 e5                	shl    %cl,%ebp
  800ecf:	39 c5                	cmp    %eax,%ebp
  800ed1:	73 5d                	jae    800f30 <__udivdi3+0x110>
  800ed3:	39 d6                	cmp    %edx,%esi
  800ed5:	75 59                	jne    800f30 <__udivdi3+0x110>
  800ed7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eda:	31 ff                	xor    %edi,%edi
  800edc:	89 fa                	mov    %edi,%edx
  800ede:	83 c4 1c             	add    $0x1c,%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    
  800ee6:	8d 76 00             	lea    0x0(%esi),%esi
  800ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ef0:	31 ff                	xor    %edi,%edi
  800ef2:	31 c0                	xor    %eax,%eax
  800ef4:	89 fa                	mov    %edi,%edx
  800ef6:	83 c4 1c             	add    $0x1c,%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
  800efe:	66 90                	xchg   %ax,%ax
  800f00:	31 ff                	xor    %edi,%edi
  800f02:	89 e8                	mov    %ebp,%eax
  800f04:	89 f2                	mov    %esi,%edx
  800f06:	f7 f3                	div    %ebx
  800f08:	89 fa                	mov    %edi,%edx
  800f0a:	83 c4 1c             	add    $0x1c,%esp
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    
  800f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f18:	39 f2                	cmp    %esi,%edx
  800f1a:	72 06                	jb     800f22 <__udivdi3+0x102>
  800f1c:	31 c0                	xor    %eax,%eax
  800f1e:	39 eb                	cmp    %ebp,%ebx
  800f20:	77 d2                	ja     800ef4 <__udivdi3+0xd4>
  800f22:	b8 01 00 00 00       	mov    $0x1,%eax
  800f27:	eb cb                	jmp    800ef4 <__udivdi3+0xd4>
  800f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f30:	89 d8                	mov    %ebx,%eax
  800f32:	31 ff                	xor    %edi,%edi
  800f34:	eb be                	jmp    800ef4 <__udivdi3+0xd4>
  800f36:	66 90                	xchg   %ax,%ax
  800f38:	66 90                	xchg   %ax,%ax
  800f3a:	66 90                	xchg   %ax,%ax
  800f3c:	66 90                	xchg   %ax,%ax
  800f3e:	66 90                	xchg   %ax,%ax

00800f40 <__umoddi3>:
  800f40:	55                   	push   %ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 1c             	sub    $0x1c,%esp
  800f47:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f57:	85 ed                	test   %ebp,%ebp
  800f59:	89 f0                	mov    %esi,%eax
  800f5b:	89 da                	mov    %ebx,%edx
  800f5d:	75 19                	jne    800f78 <__umoddi3+0x38>
  800f5f:	39 df                	cmp    %ebx,%edi
  800f61:	0f 86 b1 00 00 00    	jbe    801018 <__umoddi3+0xd8>
  800f67:	f7 f7                	div    %edi
  800f69:	89 d0                	mov    %edx,%eax
  800f6b:	31 d2                	xor    %edx,%edx
  800f6d:	83 c4 1c             	add    $0x1c,%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
  800f75:	8d 76 00             	lea    0x0(%esi),%esi
  800f78:	39 dd                	cmp    %ebx,%ebp
  800f7a:	77 f1                	ja     800f6d <__umoddi3+0x2d>
  800f7c:	0f bd cd             	bsr    %ebp,%ecx
  800f7f:	83 f1 1f             	xor    $0x1f,%ecx
  800f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f86:	0f 84 b4 00 00 00    	je     801040 <__umoddi3+0x100>
  800f8c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f91:	89 c2                	mov    %eax,%edx
  800f93:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f97:	29 c2                	sub    %eax,%edx
  800f99:	89 c1                	mov    %eax,%ecx
  800f9b:	89 f8                	mov    %edi,%eax
  800f9d:	d3 e5                	shl    %cl,%ebp
  800f9f:	89 d1                	mov    %edx,%ecx
  800fa1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fa5:	d3 e8                	shr    %cl,%eax
  800fa7:	09 c5                	or     %eax,%ebp
  800fa9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fad:	89 c1                	mov    %eax,%ecx
  800faf:	d3 e7                	shl    %cl,%edi
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	d3 ef                	shr    %cl,%edi
  800fbb:	89 c1                	mov    %eax,%ecx
  800fbd:	89 f0                	mov    %esi,%eax
  800fbf:	d3 e3                	shl    %cl,%ebx
  800fc1:	89 d1                	mov    %edx,%ecx
  800fc3:	89 fa                	mov    %edi,%edx
  800fc5:	d3 e8                	shr    %cl,%eax
  800fc7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fcc:	09 d8                	or     %ebx,%eax
  800fce:	f7 f5                	div    %ebp
  800fd0:	d3 e6                	shl    %cl,%esi
  800fd2:	89 d1                	mov    %edx,%ecx
  800fd4:	f7 64 24 08          	mull   0x8(%esp)
  800fd8:	39 d1                	cmp    %edx,%ecx
  800fda:	89 c3                	mov    %eax,%ebx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	72 06                	jb     800fe6 <__umoddi3+0xa6>
  800fe0:	75 0e                	jne    800ff0 <__umoddi3+0xb0>
  800fe2:	39 c6                	cmp    %eax,%esi
  800fe4:	73 0a                	jae    800ff0 <__umoddi3+0xb0>
  800fe6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800fea:	19 ea                	sbb    %ebp,%edx
  800fec:	89 d7                	mov    %edx,%edi
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	89 ca                	mov    %ecx,%edx
  800ff2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800ff7:	29 de                	sub    %ebx,%esi
  800ff9:	19 fa                	sbb    %edi,%edx
  800ffb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	d3 e0                	shl    %cl,%eax
  801003:	89 d9                	mov    %ebx,%ecx
  801005:	d3 ee                	shr    %cl,%esi
  801007:	d3 ea                	shr    %cl,%edx
  801009:	09 f0                	or     %esi,%eax
  80100b:	83 c4 1c             	add    $0x1c,%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
  801013:	90                   	nop
  801014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801018:	85 ff                	test   %edi,%edi
  80101a:	89 f9                	mov    %edi,%ecx
  80101c:	75 0b                	jne    801029 <__umoddi3+0xe9>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f7                	div    %edi
  801027:	89 c1                	mov    %eax,%ecx
  801029:	89 d8                	mov    %ebx,%eax
  80102b:	31 d2                	xor    %edx,%edx
  80102d:	f7 f1                	div    %ecx
  80102f:	89 f0                	mov    %esi,%eax
  801031:	f7 f1                	div    %ecx
  801033:	e9 31 ff ff ff       	jmp    800f69 <__umoddi3+0x29>
  801038:	90                   	nop
  801039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801040:	39 dd                	cmp    %ebx,%ebp
  801042:	72 08                	jb     80104c <__umoddi3+0x10c>
  801044:	39 f7                	cmp    %esi,%edi
  801046:	0f 87 21 ff ff ff    	ja     800f6d <__umoddi3+0x2d>
  80104c:	89 da                	mov    %ebx,%edx
  80104e:	89 f0                	mov    %esi,%eax
  801050:	29 f8                	sub    %edi,%eax
  801052:	19 ea                	sbb    %ebp,%edx
  801054:	e9 14 ff ff ff       	jmp    800f6d <__umoddi3+0x2d>
