
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
  80003e:	e8 bc 01 00 00       	call   8001ff <cprintf>
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
  800095:	e8 65 01 00 00       	call   8001ff <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 07 11 80 00       	push   $0x801107
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 f8 10 80 00       	push   $0x8010f8
  8000b3:	e8 6c 00 00 00       	call   800124 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 db 10 80 00       	push   $0x8010db
  8000be:	6a 11                	push   $0x11
  8000c0:	68 f8 10 80 00       	push   $0x8010f8
  8000c5:	e8 5a 00 00 00       	call   800124 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 80 10 80 00       	push   $0x801080
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 f8 10 80 00       	push   $0x8010f8
  8000d7:	e8 48 00 00 00       	call   800124 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 08             	sub    $0x8,%esp
  8000e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000e8:	c7 05 20 20 c0 00 00 	movl   $0xeec00000,0xc02020
  8000ef:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	7e 08                	jle    8000fe <libmain+0x22>
		binaryname = argv[0];
  8000f6:	8b 0a                	mov    (%edx),%ecx
  8000f8:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	52                   	push   %edx
  800102:	50                   	push   %eax
  800103:	e8 2b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800108:	e8 05 00 00 00       	call   800112 <exit>
}
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800118:	6a 00                	push   $0x0
  80011a:	e8 b8 0a 00 00       	call   800bd7 <sys_env_destroy>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	c9                   	leave  
  800123:	c3                   	ret    

00800124 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	56                   	push   %esi
  800128:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800129:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80012c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800132:	e8 e1 0a 00 00       	call   800c18 <sys_getenvid>
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	ff 75 0c             	pushl  0xc(%ebp)
  80013d:	ff 75 08             	pushl  0x8(%ebp)
  800140:	56                   	push   %esi
  800141:	50                   	push   %eax
  800142:	68 28 11 80 00       	push   $0x801128
  800147:	e8 b3 00 00 00       	call   8001ff <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80014c:	83 c4 18             	add    $0x18,%esp
  80014f:	53                   	push   %ebx
  800150:	ff 75 10             	pushl  0x10(%ebp)
  800153:	e8 56 00 00 00       	call   8001ae <vcprintf>
	cprintf("\n");
  800158:	c7 04 24 f6 10 80 00 	movl   $0x8010f6,(%esp)
  80015f:	e8 9b 00 00 00       	call   8001ff <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800167:	cc                   	int3   
  800168:	eb fd                	jmp    800167 <_panic+0x43>

0080016a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	53                   	push   %ebx
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800174:	8b 13                	mov    (%ebx),%edx
  800176:	8d 42 01             	lea    0x1(%edx),%eax
  800179:	89 03                	mov    %eax,(%ebx)
  80017b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800182:	3d ff 00 00 00       	cmp    $0xff,%eax
  800187:	74 09                	je     800192 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800189:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800190:	c9                   	leave  
  800191:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	68 ff 00 00 00       	push   $0xff
  80019a:	8d 43 08             	lea    0x8(%ebx),%eax
  80019d:	50                   	push   %eax
  80019e:	e8 f7 09 00 00       	call   800b9a <sys_cputs>
		b->idx = 0;
  8001a3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a9:	83 c4 10             	add    $0x10,%esp
  8001ac:	eb db                	jmp    800189 <putch+0x1f>

008001ae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001be:	00 00 00 
	b.cnt = 0;
  8001c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ce:	ff 75 08             	pushl  0x8(%ebp)
  8001d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d7:	50                   	push   %eax
  8001d8:	68 6a 01 80 00       	push   $0x80016a
  8001dd:	e8 1a 01 00 00       	call   8002fc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e2:	83 c4 08             	add    $0x8,%esp
  8001e5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f1:	50                   	push   %eax
  8001f2:	e8 a3 09 00 00       	call   800b9a <sys_cputs>

	return b.cnt;
}
  8001f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800205:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800208:	50                   	push   %eax
  800209:	ff 75 08             	pushl  0x8(%ebp)
  80020c:	e8 9d ff ff ff       	call   8001ae <vcprintf>
	va_end(ap);

	return cnt;
}
  800211:	c9                   	leave  
  800212:	c3                   	ret    

00800213 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	57                   	push   %edi
  800217:	56                   	push   %esi
  800218:	53                   	push   %ebx
  800219:	83 ec 1c             	sub    $0x1c,%esp
  80021c:	89 c7                	mov    %eax,%edi
  80021e:	89 d6                	mov    %edx,%esi
  800220:	8b 45 08             	mov    0x8(%ebp),%eax
  800223:	8b 55 0c             	mov    0xc(%ebp),%edx
  800226:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800229:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80022c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80022f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800234:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800237:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80023a:	39 d3                	cmp    %edx,%ebx
  80023c:	72 05                	jb     800243 <printnum+0x30>
  80023e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800241:	77 7a                	ja     8002bd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	ff 75 18             	pushl  0x18(%ebp)
  800249:	8b 45 14             	mov    0x14(%ebp),%eax
  80024c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80024f:	53                   	push   %ebx
  800250:	ff 75 10             	pushl  0x10(%ebp)
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	ff 75 d8             	pushl  -0x28(%ebp)
  800262:	e8 a9 0b 00 00       	call   800e10 <__udivdi3>
  800267:	83 c4 18             	add    $0x18,%esp
  80026a:	52                   	push   %edx
  80026b:	50                   	push   %eax
  80026c:	89 f2                	mov    %esi,%edx
  80026e:	89 f8                	mov    %edi,%eax
  800270:	e8 9e ff ff ff       	call   800213 <printnum>
  800275:	83 c4 20             	add    $0x20,%esp
  800278:	eb 13                	jmp    80028d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	56                   	push   %esi
  80027e:	ff 75 18             	pushl  0x18(%ebp)
  800281:	ff d7                	call   *%edi
  800283:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800286:	83 eb 01             	sub    $0x1,%ebx
  800289:	85 db                	test   %ebx,%ebx
  80028b:	7f ed                	jg     80027a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	56                   	push   %esi
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	ff 75 e0             	pushl  -0x20(%ebp)
  80029a:	ff 75 dc             	pushl  -0x24(%ebp)
  80029d:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a0:	e8 8b 0c 00 00       	call   800f30 <__umoddi3>
  8002a5:	83 c4 14             	add    $0x14,%esp
  8002a8:	0f be 80 4c 11 80 00 	movsbl 0x80114c(%eax),%eax
  8002af:	50                   	push   %eax
  8002b0:	ff d7                	call   *%edi
}
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b8:	5b                   	pop    %ebx
  8002b9:	5e                   	pop    %esi
  8002ba:	5f                   	pop    %edi
  8002bb:	5d                   	pop    %ebp
  8002bc:	c3                   	ret    
  8002bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c0:	eb c4                	jmp    800286 <printnum+0x73>

008002c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002cc:	8b 10                	mov    (%eax),%edx
  8002ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d1:	73 0a                	jae    8002dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d6:	89 08                	mov    %ecx,(%eax)
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	88 02                	mov    %al,(%edx)
}
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <printfmt>:
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 10             	pushl  0x10(%ebp)
  8002ec:	ff 75 0c             	pushl  0xc(%ebp)
  8002ef:	ff 75 08             	pushl  0x8(%ebp)
  8002f2:	e8 05 00 00 00       	call   8002fc <vprintfmt>
}
  8002f7:	83 c4 10             	add    $0x10,%esp
  8002fa:	c9                   	leave  
  8002fb:	c3                   	ret    

008002fc <vprintfmt>:
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	57                   	push   %edi
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
  800302:	83 ec 2c             	sub    $0x2c,%esp
  800305:	8b 75 08             	mov    0x8(%ebp),%esi
  800308:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030e:	e9 00 04 00 00       	jmp    800713 <vprintfmt+0x417>
		padc = ' ';
  800313:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800317:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80031e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800325:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8d 47 01             	lea    0x1(%edi),%eax
  800334:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800337:	0f b6 17             	movzbl (%edi),%edx
  80033a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033d:	3c 55                	cmp    $0x55,%al
  80033f:	0f 87 51 04 00 00    	ja     800796 <vprintfmt+0x49a>
  800345:	0f b6 c0             	movzbl %al,%eax
  800348:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800352:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800356:	eb d9                	jmp    800331 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80035b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80035f:	eb d0                	jmp    800331 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800361:	0f b6 d2             	movzbl %dl,%edx
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
  80036c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800372:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800376:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037c:	83 f9 09             	cmp    $0x9,%ecx
  80037f:	77 55                	ja     8003d6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800381:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800384:	eb e9                	jmp    80036f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 40 04             	lea    0x4(%eax),%eax
  800394:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80039a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039e:	79 91                	jns    800331 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003ad:	eb 82                	jmp    800331 <vprintfmt+0x35>
  8003af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b9:	0f 49 d0             	cmovns %eax,%edx
  8003bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c2:	e9 6a ff ff ff       	jmp    800331 <vprintfmt+0x35>
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ca:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d1:	e9 5b ff ff ff       	jmp    800331 <vprintfmt+0x35>
  8003d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003dc:	eb bc                	jmp    80039a <vprintfmt+0x9e>
			lflag++;
  8003de:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e4:	e9 48 ff ff ff       	jmp    800331 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8d 78 04             	lea    0x4(%eax),%edi
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	53                   	push   %ebx
  8003f3:	ff 30                	pushl  (%eax)
  8003f5:	ff d6                	call   *%esi
			break;
  8003f7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003fa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fd:	e9 0e 03 00 00       	jmp    800710 <vprintfmt+0x414>
			err = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 78 04             	lea    0x4(%eax),%edi
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	99                   	cltd   
  80040b:	31 d0                	xor    %edx,%eax
  80040d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040f:	83 f8 08             	cmp    $0x8,%eax
  800412:	7f 23                	jg     800437 <vprintfmt+0x13b>
  800414:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 18                	je     800437 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80041f:	52                   	push   %edx
  800420:	68 6d 11 80 00       	push   $0x80116d
  800425:	53                   	push   %ebx
  800426:	56                   	push   %esi
  800427:	e8 b3 fe ff ff       	call   8002df <printfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800432:	e9 d9 02 00 00       	jmp    800710 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800437:	50                   	push   %eax
  800438:	68 64 11 80 00       	push   $0x801164
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 9b fe ff ff       	call   8002df <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80044a:	e9 c1 02 00 00       	jmp    800710 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	83 c0 04             	add    $0x4,%eax
  800455:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80045d:	85 ff                	test   %edi,%edi
  80045f:	b8 5d 11 80 00       	mov    $0x80115d,%eax
  800464:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800467:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046b:	0f 8e bd 00 00 00    	jle    80052e <vprintfmt+0x232>
  800471:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800475:	75 0e                	jne    800485 <vprintfmt+0x189>
  800477:	89 75 08             	mov    %esi,0x8(%ebp)
  80047a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80047d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800480:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800483:	eb 6d                	jmp    8004f2 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	ff 75 d0             	pushl  -0x30(%ebp)
  80048b:	57                   	push   %edi
  80048c:	e8 ad 03 00 00       	call   80083e <strnlen>
  800491:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800494:	29 c1                	sub    %eax,%ecx
  800496:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800499:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80049c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004a6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a8:	eb 0f                	jmp    8004b9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	53                   	push   %ebx
  8004ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b3:	83 ef 01             	sub    $0x1,%edi
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	85 ff                	test   %edi,%edi
  8004bb:	7f ed                	jg     8004aa <vprintfmt+0x1ae>
  8004bd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c3:	85 c9                	test   %ecx,%ecx
  8004c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ca:	0f 49 c1             	cmovns %ecx,%eax
  8004cd:	29 c1                	sub    %eax,%ecx
  8004cf:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d8:	89 cb                	mov    %ecx,%ebx
  8004da:	eb 16                	jmp    8004f2 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e0:	75 31                	jne    800513 <vprintfmt+0x217>
					putch(ch, putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	50                   	push   %eax
  8004e9:	ff 55 08             	call   *0x8(%ebp)
  8004ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ef:	83 eb 01             	sub    $0x1,%ebx
  8004f2:	83 c7 01             	add    $0x1,%edi
  8004f5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004f9:	0f be c2             	movsbl %dl,%eax
  8004fc:	85 c0                	test   %eax,%eax
  8004fe:	74 59                	je     800559 <vprintfmt+0x25d>
  800500:	85 f6                	test   %esi,%esi
  800502:	78 d8                	js     8004dc <vprintfmt+0x1e0>
  800504:	83 ee 01             	sub    $0x1,%esi
  800507:	79 d3                	jns    8004dc <vprintfmt+0x1e0>
  800509:	89 df                	mov    %ebx,%edi
  80050b:	8b 75 08             	mov    0x8(%ebp),%esi
  80050e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800511:	eb 37                	jmp    80054a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800513:	0f be d2             	movsbl %dl,%edx
  800516:	83 ea 20             	sub    $0x20,%edx
  800519:	83 fa 5e             	cmp    $0x5e,%edx
  80051c:	76 c4                	jbe    8004e2 <vprintfmt+0x1e6>
					putch('?', putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	6a 3f                	push   $0x3f
  800526:	ff 55 08             	call   *0x8(%ebp)
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb c1                	jmp    8004ef <vprintfmt+0x1f3>
  80052e:	89 75 08             	mov    %esi,0x8(%ebp)
  800531:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800534:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800537:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80053a:	eb b6                	jmp    8004f2 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	6a 20                	push   $0x20
  800542:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800544:	83 ef 01             	sub    $0x1,%edi
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	85 ff                	test   %edi,%edi
  80054c:	7f ee                	jg     80053c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80054e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	e9 b7 01 00 00       	jmp    800710 <vprintfmt+0x414>
  800559:	89 df                	mov    %ebx,%edi
  80055b:	8b 75 08             	mov    0x8(%ebp),%esi
  80055e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800561:	eb e7                	jmp    80054a <vprintfmt+0x24e>
	if (lflag >= 2)
  800563:	83 f9 01             	cmp    $0x1,%ecx
  800566:	7e 3f                	jle    8005a7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 50 04             	mov    0x4(%eax),%edx
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800573:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800576:	8b 45 14             	mov    0x14(%ebp),%eax
  800579:	8d 40 08             	lea    0x8(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80057f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800583:	79 5c                	jns    8005e1 <vprintfmt+0x2e5>
				putch('-', putdat);
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	53                   	push   %ebx
  800589:	6a 2d                	push   $0x2d
  80058b:	ff d6                	call   *%esi
				num = -(long long) num;
  80058d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800590:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800593:	f7 da                	neg    %edx
  800595:	83 d1 00             	adc    $0x0,%ecx
  800598:	f7 d9                	neg    %ecx
  80059a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a2:	e9 4f 01 00 00       	jmp    8006f6 <vprintfmt+0x3fa>
	else if (lflag)
  8005a7:	85 c9                	test   %ecx,%ecx
  8005a9:	75 1b                	jne    8005c6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b3:	89 c1                	mov    %eax,%ecx
  8005b5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 40 04             	lea    0x4(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	eb b9                	jmp    80057f <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 c1                	mov    %eax,%ecx
  8005d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	eb 9e                	jmp    80057f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ec:	e9 05 01 00 00       	jmp    8006f6 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005f1:	83 f9 01             	cmp    $0x1,%ecx
  8005f4:	7e 18                	jle    80060e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 10                	mov    (%eax),%edx
  8005fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fe:	8d 40 08             	lea    0x8(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800604:	b8 0a 00 00 00       	mov    $0xa,%eax
  800609:	e9 e8 00 00 00       	jmp    8006f6 <vprintfmt+0x3fa>
	else if (lflag)
  80060e:	85 c9                	test   %ecx,%ecx
  800610:	75 1a                	jne    80062c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061c:	8d 40 04             	lea    0x4(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800622:	b8 0a 00 00 00       	mov    $0xa,%eax
  800627:	e9 ca 00 00 00       	jmp    8006f6 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 10                	mov    (%eax),%edx
  800631:	b9 00 00 00 00       	mov    $0x0,%ecx
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800641:	e9 b0 00 00 00       	jmp    8006f6 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800646:	83 f9 01             	cmp    $0x1,%ecx
  800649:	7e 3c                	jle    800687 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 50 04             	mov    0x4(%eax),%edx
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800656:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800662:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800666:	79 59                	jns    8006c1 <vprintfmt+0x3c5>
                putch('-', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 2d                	push   $0x2d
  80066e:	ff d6                	call   *%esi
                num = -(long long) num;
  800670:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800673:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800676:	f7 da                	neg    %edx
  800678:	83 d1 00             	adc    $0x0,%ecx
  80067b:	f7 d9                	neg    %ecx
  80067d:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800680:	b8 08 00 00 00       	mov    $0x8,%eax
  800685:	eb 6f                	jmp    8006f6 <vprintfmt+0x3fa>
	else if (lflag)
  800687:	85 c9                	test   %ecx,%ecx
  800689:	75 1b                	jne    8006a6 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	89 c1                	mov    %eax,%ecx
  800695:	c1 f9 1f             	sar    $0x1f,%ecx
  800698:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a4:	eb bc                	jmp    800662 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 c1                	mov    %eax,%ecx
  8006b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bf:	eb a1                	jmp    800662 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006cc:	eb 28                	jmp    8006f6 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	53                   	push   %ebx
  8006d2:	6a 30                	push   $0x30
  8006d4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d6:	83 c4 08             	add    $0x8,%esp
  8006d9:	53                   	push   %ebx
  8006da:	6a 78                	push   $0x78
  8006dc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 10                	mov    (%eax),%edx
  8006e3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006e8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006eb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006fd:	57                   	push   %edi
  8006fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800701:	50                   	push   %eax
  800702:	51                   	push   %ecx
  800703:	52                   	push   %edx
  800704:	89 da                	mov    %ebx,%edx
  800706:	89 f0                	mov    %esi,%eax
  800708:	e8 06 fb ff ff       	call   800213 <printnum>
			break;
  80070d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800710:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	83 c7 01             	add    $0x1,%edi
  800716:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071a:	83 f8 25             	cmp    $0x25,%eax
  80071d:	0f 84 f0 fb ff ff    	je     800313 <vprintfmt+0x17>
			if (ch == '\0')
  800723:	85 c0                	test   %eax,%eax
  800725:	0f 84 8b 00 00 00    	je     8007b6 <vprintfmt+0x4ba>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	50                   	push   %eax
  800730:	ff d6                	call   *%esi
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	eb dc                	jmp    800713 <vprintfmt+0x417>
	if (lflag >= 2)
  800737:	83 f9 01             	cmp    $0x1,%ecx
  80073a:	7e 15                	jle    800751 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 10                	mov    (%eax),%edx
  800741:	8b 48 04             	mov    0x4(%eax),%ecx
  800744:	8d 40 08             	lea    0x8(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074a:	b8 10 00 00 00       	mov    $0x10,%eax
  80074f:	eb a5                	jmp    8006f6 <vprintfmt+0x3fa>
	else if (lflag)
  800751:	85 c9                	test   %ecx,%ecx
  800753:	75 17                	jne    80076c <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 10                	mov    (%eax),%edx
  80075a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075f:	8d 40 04             	lea    0x4(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800765:	b8 10 00 00 00       	mov    $0x10,%eax
  80076a:	eb 8a                	jmp    8006f6 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 10                	mov    (%eax),%edx
  800771:	b9 00 00 00 00       	mov    $0x0,%ecx
  800776:	8d 40 04             	lea    0x4(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	b8 10 00 00 00       	mov    $0x10,%eax
  800781:	e9 70 ff ff ff       	jmp    8006f6 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 25                	push   $0x25
  80078c:	ff d6                	call   *%esi
			break;
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	e9 7a ff ff ff       	jmp    800710 <vprintfmt+0x414>
			putch('%', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	6a 25                	push   $0x25
  80079c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 f8                	mov    %edi,%eax
  8007a3:	eb 03                	jmp    8007a8 <vprintfmt+0x4ac>
  8007a5:	83 e8 01             	sub    $0x1,%eax
  8007a8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ac:	75 f7                	jne    8007a5 <vprintfmt+0x4a9>
  8007ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007b1:	e9 5a ff ff ff       	jmp    800710 <vprintfmt+0x414>
}
  8007b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b9:	5b                   	pop    %ebx
  8007ba:	5e                   	pop    %esi
  8007bb:	5f                   	pop    %edi
  8007bc:	5d                   	pop    %ebp
  8007bd:	c3                   	ret    

008007be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	83 ec 18             	sub    $0x18,%esp
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007cd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007db:	85 c0                	test   %eax,%eax
  8007dd:	74 26                	je     800805 <vsnprintf+0x47>
  8007df:	85 d2                	test   %edx,%edx
  8007e1:	7e 22                	jle    800805 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e3:	ff 75 14             	pushl  0x14(%ebp)
  8007e6:	ff 75 10             	pushl  0x10(%ebp)
  8007e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ec:	50                   	push   %eax
  8007ed:	68 c2 02 80 00       	push   $0x8002c2
  8007f2:	e8 05 fb ff ff       	call   8002fc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800800:	83 c4 10             	add    $0x10,%esp
}
  800803:	c9                   	leave  
  800804:	c3                   	ret    
		return -E_INVAL;
  800805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080a:	eb f7                	jmp    800803 <vsnprintf+0x45>

0080080c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800812:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800815:	50                   	push   %eax
  800816:	ff 75 10             	pushl  0x10(%ebp)
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	ff 75 08             	pushl  0x8(%ebp)
  80081f:	e8 9a ff ff ff       	call   8007be <vsnprintf>
	va_end(ap);

	return rc;
}
  800824:	c9                   	leave  
  800825:	c3                   	ret    

00800826 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	eb 03                	jmp    800836 <strlen+0x10>
		n++;
  800833:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800836:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80083a:	75 f7                	jne    800833 <strlen+0xd>
	return n;
}
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800844:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
  80084c:	eb 03                	jmp    800851 <strnlen+0x13>
		n++;
  80084e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800851:	39 d0                	cmp    %edx,%eax
  800853:	74 06                	je     80085b <strnlen+0x1d>
  800855:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800859:	75 f3                	jne    80084e <strnlen+0x10>
	return n;
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	53                   	push   %ebx
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800867:	89 c2                	mov    %eax,%edx
  800869:	83 c1 01             	add    $0x1,%ecx
  80086c:	83 c2 01             	add    $0x1,%edx
  80086f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800873:	88 5a ff             	mov    %bl,-0x1(%edx)
  800876:	84 db                	test   %bl,%bl
  800878:	75 ef                	jne    800869 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80087a:	5b                   	pop    %ebx
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	53                   	push   %ebx
  800881:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800884:	53                   	push   %ebx
  800885:	e8 9c ff ff ff       	call   800826 <strlen>
  80088a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	01 d8                	add    %ebx,%eax
  800892:	50                   	push   %eax
  800893:	e8 c5 ff ff ff       	call   80085d <strcpy>
	return dst;
}
  800898:	89 d8                	mov    %ebx,%eax
  80089a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    

0080089f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	56                   	push   %esi
  8008a3:	53                   	push   %ebx
  8008a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008aa:	89 f3                	mov    %esi,%ebx
  8008ac:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008af:	89 f2                	mov    %esi,%edx
  8008b1:	eb 0f                	jmp    8008c2 <strncpy+0x23>
		*dst++ = *src;
  8008b3:	83 c2 01             	add    $0x1,%edx
  8008b6:	0f b6 01             	movzbl (%ecx),%eax
  8008b9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008bc:	80 39 01             	cmpb   $0x1,(%ecx)
  8008bf:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008c2:	39 da                	cmp    %ebx,%edx
  8008c4:	75 ed                	jne    8008b3 <strncpy+0x14>
	}
	return ret;
}
  8008c6:	89 f0                	mov    %esi,%eax
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	56                   	push   %esi
  8008d0:	53                   	push   %ebx
  8008d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008da:	89 f0                	mov    %esi,%eax
  8008dc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e0:	85 c9                	test   %ecx,%ecx
  8008e2:	75 0b                	jne    8008ef <strlcpy+0x23>
  8008e4:	eb 17                	jmp    8008fd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008e6:	83 c2 01             	add    $0x1,%edx
  8008e9:	83 c0 01             	add    $0x1,%eax
  8008ec:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008ef:	39 d8                	cmp    %ebx,%eax
  8008f1:	74 07                	je     8008fa <strlcpy+0x2e>
  8008f3:	0f b6 0a             	movzbl (%edx),%ecx
  8008f6:	84 c9                	test   %cl,%cl
  8008f8:	75 ec                	jne    8008e6 <strlcpy+0x1a>
		*dst = '\0';
  8008fa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008fd:	29 f0                	sub    %esi,%eax
}
  8008ff:	5b                   	pop    %ebx
  800900:	5e                   	pop    %esi
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090c:	eb 06                	jmp    800914 <strcmp+0x11>
		p++, q++;
  80090e:	83 c1 01             	add    $0x1,%ecx
  800911:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800914:	0f b6 01             	movzbl (%ecx),%eax
  800917:	84 c0                	test   %al,%al
  800919:	74 04                	je     80091f <strcmp+0x1c>
  80091b:	3a 02                	cmp    (%edx),%al
  80091d:	74 ef                	je     80090e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	0f b6 12             	movzbl (%edx),%edx
  800925:	29 d0                	sub    %edx,%eax
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	53                   	push   %ebx
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 55 0c             	mov    0xc(%ebp),%edx
  800933:	89 c3                	mov    %eax,%ebx
  800935:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800938:	eb 06                	jmp    800940 <strncmp+0x17>
		n--, p++, q++;
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800940:	39 d8                	cmp    %ebx,%eax
  800942:	74 16                	je     80095a <strncmp+0x31>
  800944:	0f b6 08             	movzbl (%eax),%ecx
  800947:	84 c9                	test   %cl,%cl
  800949:	74 04                	je     80094f <strncmp+0x26>
  80094b:	3a 0a                	cmp    (%edx),%cl
  80094d:	74 eb                	je     80093a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094f:	0f b6 00             	movzbl (%eax),%eax
  800952:	0f b6 12             	movzbl (%edx),%edx
  800955:	29 d0                	sub    %edx,%eax
}
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    
		return 0;
  80095a:	b8 00 00 00 00       	mov    $0x0,%eax
  80095f:	eb f6                	jmp    800957 <strncmp+0x2e>

00800961 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096b:	0f b6 10             	movzbl (%eax),%edx
  80096e:	84 d2                	test   %dl,%dl
  800970:	74 09                	je     80097b <strchr+0x1a>
		if (*s == c)
  800972:	38 ca                	cmp    %cl,%dl
  800974:	74 0a                	je     800980 <strchr+0x1f>
	for (; *s; s++)
  800976:	83 c0 01             	add    $0x1,%eax
  800979:	eb f0                	jmp    80096b <strchr+0xa>
			return (char *) s;
	return 0;
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098c:	eb 03                	jmp    800991 <strfind+0xf>
  80098e:	83 c0 01             	add    $0x1,%eax
  800991:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800994:	38 ca                	cmp    %cl,%dl
  800996:	74 04                	je     80099c <strfind+0x1a>
  800998:	84 d2                	test   %dl,%dl
  80099a:	75 f2                	jne    80098e <strfind+0xc>
			break;
	return (char *) s;
}
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	57                   	push   %edi
  8009a2:	56                   	push   %esi
  8009a3:	53                   	push   %ebx
  8009a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009aa:	85 c9                	test   %ecx,%ecx
  8009ac:	74 13                	je     8009c1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ae:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b4:	75 05                	jne    8009bb <memset+0x1d>
  8009b6:	f6 c1 03             	test   $0x3,%cl
  8009b9:	74 0d                	je     8009c8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	fc                   	cld    
  8009bf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c1:	89 f8                	mov    %edi,%eax
  8009c3:	5b                   	pop    %ebx
  8009c4:	5e                   	pop    %esi
  8009c5:	5f                   	pop    %edi
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    
		c &= 0xFF;
  8009c8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009cc:	89 d3                	mov    %edx,%ebx
  8009ce:	c1 e3 08             	shl    $0x8,%ebx
  8009d1:	89 d0                	mov    %edx,%eax
  8009d3:	c1 e0 18             	shl    $0x18,%eax
  8009d6:	89 d6                	mov    %edx,%esi
  8009d8:	c1 e6 10             	shl    $0x10,%esi
  8009db:	09 f0                	or     %esi,%eax
  8009dd:	09 c2                	or     %eax,%edx
  8009df:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009e1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e4:	89 d0                	mov    %edx,%eax
  8009e6:	fc                   	cld    
  8009e7:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e9:	eb d6                	jmp    8009c1 <memset+0x23>

008009eb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	57                   	push   %edi
  8009ef:	56                   	push   %esi
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f9:	39 c6                	cmp    %eax,%esi
  8009fb:	73 35                	jae    800a32 <memmove+0x47>
  8009fd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a00:	39 c2                	cmp    %eax,%edx
  800a02:	76 2e                	jbe    800a32 <memmove+0x47>
		s += n;
		d += n;
  800a04:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a07:	89 d6                	mov    %edx,%esi
  800a09:	09 fe                	or     %edi,%esi
  800a0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a11:	74 0c                	je     800a1f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a13:	83 ef 01             	sub    $0x1,%edi
  800a16:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a19:	fd                   	std    
  800a1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1c:	fc                   	cld    
  800a1d:	eb 21                	jmp    800a40 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	f6 c1 03             	test   $0x3,%cl
  800a22:	75 ef                	jne    800a13 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a24:	83 ef 04             	sub    $0x4,%edi
  800a27:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2d:	fd                   	std    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb ea                	jmp    800a1c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a32:	89 f2                	mov    %esi,%edx
  800a34:	09 c2                	or     %eax,%edx
  800a36:	f6 c2 03             	test   $0x3,%dl
  800a39:	74 09                	je     800a44 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a3b:	89 c7                	mov    %eax,%edi
  800a3d:	fc                   	cld    
  800a3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a44:	f6 c1 03             	test   $0x3,%cl
  800a47:	75 f2                	jne    800a3b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb ed                	jmp    800a40 <memmove+0x55>

00800a53 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a56:	ff 75 10             	pushl  0x10(%ebp)
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 08             	pushl  0x8(%ebp)
  800a5f:	e8 87 ff ff ff       	call   8009eb <memmove>
}
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a71:	89 c6                	mov    %eax,%esi
  800a73:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a76:	39 f0                	cmp    %esi,%eax
  800a78:	74 1c                	je     800a96 <memcmp+0x30>
		if (*s1 != *s2)
  800a7a:	0f b6 08             	movzbl (%eax),%ecx
  800a7d:	0f b6 1a             	movzbl (%edx),%ebx
  800a80:	38 d9                	cmp    %bl,%cl
  800a82:	75 08                	jne    800a8c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	83 c2 01             	add    $0x1,%edx
  800a8a:	eb ea                	jmp    800a76 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a8c:	0f b6 c1             	movzbl %cl,%eax
  800a8f:	0f b6 db             	movzbl %bl,%ebx
  800a92:	29 d8                	sub    %ebx,%eax
  800a94:	eb 05                	jmp    800a9b <memcmp+0x35>
	}

	return 0;
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aad:	39 d0                	cmp    %edx,%eax
  800aaf:	73 09                	jae    800aba <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab1:	38 08                	cmp    %cl,(%eax)
  800ab3:	74 05                	je     800aba <memfind+0x1b>
	for (; s < ends; s++)
  800ab5:	83 c0 01             	add    $0x1,%eax
  800ab8:	eb f3                	jmp    800aad <memfind+0xe>
			break;
	return (void *) s;
}
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	57                   	push   %edi
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac8:	eb 03                	jmp    800acd <strtol+0x11>
		s++;
  800aca:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800acd:	0f b6 01             	movzbl (%ecx),%eax
  800ad0:	3c 20                	cmp    $0x20,%al
  800ad2:	74 f6                	je     800aca <strtol+0xe>
  800ad4:	3c 09                	cmp    $0x9,%al
  800ad6:	74 f2                	je     800aca <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ad8:	3c 2b                	cmp    $0x2b,%al
  800ada:	74 2e                	je     800b0a <strtol+0x4e>
	int neg = 0;
  800adc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae1:	3c 2d                	cmp    $0x2d,%al
  800ae3:	74 2f                	je     800b14 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aeb:	75 05                	jne    800af2 <strtol+0x36>
  800aed:	80 39 30             	cmpb   $0x30,(%ecx)
  800af0:	74 2c                	je     800b1e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800af2:	85 db                	test   %ebx,%ebx
  800af4:	75 0a                	jne    800b00 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800afb:	80 39 30             	cmpb   $0x30,(%ecx)
  800afe:	74 28                	je     800b28 <strtol+0x6c>
		base = 10;
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b08:	eb 50                	jmp    800b5a <strtol+0x9e>
		s++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b12:	eb d1                	jmp    800ae5 <strtol+0x29>
		s++, neg = 1;
  800b14:	83 c1 01             	add    $0x1,%ecx
  800b17:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1c:	eb c7                	jmp    800ae5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b22:	74 0e                	je     800b32 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b24:	85 db                	test   %ebx,%ebx
  800b26:	75 d8                	jne    800b00 <strtol+0x44>
		s++, base = 8;
  800b28:	83 c1 01             	add    $0x1,%ecx
  800b2b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b30:	eb ce                	jmp    800b00 <strtol+0x44>
		s += 2, base = 16;
  800b32:	83 c1 02             	add    $0x2,%ecx
  800b35:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3a:	eb c4                	jmp    800b00 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b3c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b3f:	89 f3                	mov    %esi,%ebx
  800b41:	80 fb 19             	cmp    $0x19,%bl
  800b44:	77 29                	ja     800b6f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b46:	0f be d2             	movsbl %dl,%edx
  800b49:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b4c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4f:	7d 30                	jge    800b81 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b51:	83 c1 01             	add    $0x1,%ecx
  800b54:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b5a:	0f b6 11             	movzbl (%ecx),%edx
  800b5d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 09             	cmp    $0x9,%bl
  800b65:	77 d5                	ja     800b3c <strtol+0x80>
			dig = *s - '0';
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 30             	sub    $0x30,%edx
  800b6d:	eb dd                	jmp    800b4c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b6f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b72:	89 f3                	mov    %esi,%ebx
  800b74:	80 fb 19             	cmp    $0x19,%bl
  800b77:	77 08                	ja     800b81 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b79:	0f be d2             	movsbl %dl,%edx
  800b7c:	83 ea 37             	sub    $0x37,%edx
  800b7f:	eb cb                	jmp    800b4c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b85:	74 05                	je     800b8c <strtol+0xd0>
		*endptr = (char *) s;
  800b87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	f7 da                	neg    %edx
  800b90:	85 ff                	test   %edi,%edi
  800b92:	0f 45 c2             	cmovne %edx,%eax
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5f                   	pop    %edi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	57                   	push   %edi
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bab:	89 c3                	mov    %eax,%ebx
  800bad:	89 c7                	mov    %eax,%edi
  800baf:	89 c6                	mov    %eax,%esi
  800bb1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <sys_cgetc>:

int
sys_cgetc(void) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc8:	89 d1                	mov    %edx,%ecx
  800bca:	89 d3                	mov    %edx,%ebx
  800bcc:	89 d7                	mov    %edx,%edi
  800bce:	89 d6                	mov    %edx,%esi
  800bd0:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5f                   	pop    %edi
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800be0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be5:	8b 55 08             	mov    0x8(%ebp),%edx
  800be8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bed:	89 cb                	mov    %ecx,%ebx
  800bef:	89 cf                	mov    %ecx,%edi
  800bf1:	89 ce                	mov    %ecx,%esi
  800bf3:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	7f 08                	jg     800c01 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5f                   	pop    %edi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c01:	83 ec 0c             	sub    $0xc,%esp
  800c04:	50                   	push   %eax
  800c05:	6a 03                	push   $0x3
  800c07:	68 a4 13 80 00       	push   $0x8013a4
  800c0c:	6a 24                	push   $0x24
  800c0e:	68 c1 13 80 00       	push   $0x8013c1
  800c13:	e8 0c f5 ff ff       	call   800124 <_panic>

00800c18 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c23:	b8 02 00 00 00       	mov    $0x2,%eax
  800c28:	89 d1                	mov    %edx,%ecx
  800c2a:	89 d3                	mov    %edx,%ebx
  800c2c:	89 d7                	mov    %edx,%edi
  800c2e:	89 d6                	mov    %edx,%esi
  800c30:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_yield>:

void
sys_yield(void)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c42:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c47:	89 d1                	mov    %edx,%ecx
  800c49:	89 d3                	mov    %edx,%ebx
  800c4b:	89 d7                	mov    %edx,%edi
  800c4d:	89 d6                	mov    %edx,%esi
  800c4f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
  800c5c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c5f:	be 00 00 00 00       	mov    $0x0,%esi
  800c64:	8b 55 08             	mov    0x8(%ebp),%edx
  800c67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c72:	89 f7                	mov    %esi,%edi
  800c74:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	7f 08                	jg     800c82 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	50                   	push   %eax
  800c86:	6a 04                	push   $0x4
  800c88:	68 a4 13 80 00       	push   $0x8013a4
  800c8d:	6a 24                	push   $0x24
  800c8f:	68 c1 13 80 00       	push   $0x8013c1
  800c94:	e8 8b f4 ff ff       	call   800124 <_panic>

00800c99 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb3:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb6:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	7f 08                	jg     800cc4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cc4:	83 ec 0c             	sub    $0xc,%esp
  800cc7:	50                   	push   %eax
  800cc8:	6a 05                	push   $0x5
  800cca:	68 a4 13 80 00       	push   $0x8013a4
  800ccf:	6a 24                	push   $0x24
  800cd1:	68 c1 13 80 00       	push   $0x8013c1
  800cd6:	e8 49 f4 ff ff       	call   800124 <_panic>

00800cdb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ce4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	b8 06 00 00 00       	mov    $0x6,%eax
  800cf4:	89 df                	mov    %ebx,%edi
  800cf6:	89 de                	mov    %ebx,%esi
  800cf8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cfa:	85 c0                	test   %eax,%eax
  800cfc:	7f 08                	jg     800d06 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d06:	83 ec 0c             	sub    $0xc,%esp
  800d09:	50                   	push   %eax
  800d0a:	6a 06                	push   $0x6
  800d0c:	68 a4 13 80 00       	push   $0x8013a4
  800d11:	6a 24                	push   $0x24
  800d13:	68 c1 13 80 00       	push   $0x8013c1
  800d18:	e8 07 f4 ff ff       	call   800124 <_panic>

00800d1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	b8 08 00 00 00       	mov    $0x8,%eax
  800d36:	89 df                	mov    %ebx,%edi
  800d38:	89 de                	mov    %ebx,%esi
  800d3a:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	7f 08                	jg     800d48 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d48:	83 ec 0c             	sub    $0xc,%esp
  800d4b:	50                   	push   %eax
  800d4c:	6a 08                	push   $0x8
  800d4e:	68 a4 13 80 00       	push   $0x8013a4
  800d53:	6a 24                	push   $0x24
  800d55:	68 c1 13 80 00       	push   $0x8013c1
  800d5a:	e8 c5 f3 ff ff       	call   800124 <_panic>

00800d5f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	b8 09 00 00 00       	mov    $0x9,%eax
  800d78:	89 df                	mov    %ebx,%edi
  800d7a:	89 de                	mov    %ebx,%esi
  800d7c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	7f 08                	jg     800d8a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	50                   	push   %eax
  800d8e:	6a 09                	push   $0x9
  800d90:	68 a4 13 80 00       	push   $0x8013a4
  800d95:	6a 24                	push   $0x24
  800d97:	68 c1 13 80 00       	push   $0x8013c1
  800d9c:	e8 83 f3 ff ff       	call   800124 <_panic>

00800da1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
    asm volatile("int %1\n"
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dad:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db2:	be 00 00 00 00       	mov    $0x0,%esi
  800db7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbf:	5b                   	pop    %ebx
  800dc0:	5e                   	pop    %esi
  800dc1:	5f                   	pop    %edi
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dda:	89 cb                	mov    %ecx,%ebx
  800ddc:	89 cf                	mov    %ecx,%edi
  800dde:	89 ce                	mov    %ecx,%esi
  800de0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	7f 08                	jg     800dee <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	50                   	push   %eax
  800df2:	6a 0c                	push   $0xc
  800df4:	68 a4 13 80 00       	push   $0x8013a4
  800df9:	6a 24                	push   $0x24
  800dfb:	68 c1 13 80 00       	push   $0x8013c1
  800e00:	e8 1f f3 ff ff       	call   800124 <_panic>
  800e05:	66 90                	xchg   %ax,%ax
  800e07:	66 90                	xchg   %ax,%ax
  800e09:	66 90                	xchg   %ax,%ax
  800e0b:	66 90                	xchg   %ax,%ax
  800e0d:	66 90                	xchg   %ax,%ax
  800e0f:	90                   	nop

00800e10 <__udivdi3>:
  800e10:	55                   	push   %ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 1c             	sub    $0x1c,%esp
  800e17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e27:	85 d2                	test   %edx,%edx
  800e29:	75 35                	jne    800e60 <__udivdi3+0x50>
  800e2b:	39 f3                	cmp    %esi,%ebx
  800e2d:	0f 87 bd 00 00 00    	ja     800ef0 <__udivdi3+0xe0>
  800e33:	85 db                	test   %ebx,%ebx
  800e35:	89 d9                	mov    %ebx,%ecx
  800e37:	75 0b                	jne    800e44 <__udivdi3+0x34>
  800e39:	b8 01 00 00 00       	mov    $0x1,%eax
  800e3e:	31 d2                	xor    %edx,%edx
  800e40:	f7 f3                	div    %ebx
  800e42:	89 c1                	mov    %eax,%ecx
  800e44:	31 d2                	xor    %edx,%edx
  800e46:	89 f0                	mov    %esi,%eax
  800e48:	f7 f1                	div    %ecx
  800e4a:	89 c6                	mov    %eax,%esi
  800e4c:	89 e8                	mov    %ebp,%eax
  800e4e:	89 f7                	mov    %esi,%edi
  800e50:	f7 f1                	div    %ecx
  800e52:	89 fa                	mov    %edi,%edx
  800e54:	83 c4 1c             	add    $0x1c,%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
  800e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e60:	39 f2                	cmp    %esi,%edx
  800e62:	77 7c                	ja     800ee0 <__udivdi3+0xd0>
  800e64:	0f bd fa             	bsr    %edx,%edi
  800e67:	83 f7 1f             	xor    $0x1f,%edi
  800e6a:	0f 84 98 00 00 00    	je     800f08 <__udivdi3+0xf8>
  800e70:	89 f9                	mov    %edi,%ecx
  800e72:	b8 20 00 00 00       	mov    $0x20,%eax
  800e77:	29 f8                	sub    %edi,%eax
  800e79:	d3 e2                	shl    %cl,%edx
  800e7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e7f:	89 c1                	mov    %eax,%ecx
  800e81:	89 da                	mov    %ebx,%edx
  800e83:	d3 ea                	shr    %cl,%edx
  800e85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e89:	09 d1                	or     %edx,%ecx
  800e8b:	89 f2                	mov    %esi,%edx
  800e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e91:	89 f9                	mov    %edi,%ecx
  800e93:	d3 e3                	shl    %cl,%ebx
  800e95:	89 c1                	mov    %eax,%ecx
  800e97:	d3 ea                	shr    %cl,%edx
  800e99:	89 f9                	mov    %edi,%ecx
  800e9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e9f:	d3 e6                	shl    %cl,%esi
  800ea1:	89 eb                	mov    %ebp,%ebx
  800ea3:	89 c1                	mov    %eax,%ecx
  800ea5:	d3 eb                	shr    %cl,%ebx
  800ea7:	09 de                	or     %ebx,%esi
  800ea9:	89 f0                	mov    %esi,%eax
  800eab:	f7 74 24 08          	divl   0x8(%esp)
  800eaf:	89 d6                	mov    %edx,%esi
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	f7 64 24 0c          	mull   0xc(%esp)
  800eb7:	39 d6                	cmp    %edx,%esi
  800eb9:	72 0c                	jb     800ec7 <__udivdi3+0xb7>
  800ebb:	89 f9                	mov    %edi,%ecx
  800ebd:	d3 e5                	shl    %cl,%ebp
  800ebf:	39 c5                	cmp    %eax,%ebp
  800ec1:	73 5d                	jae    800f20 <__udivdi3+0x110>
  800ec3:	39 d6                	cmp    %edx,%esi
  800ec5:	75 59                	jne    800f20 <__udivdi3+0x110>
  800ec7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eca:	31 ff                	xor    %edi,%edi
  800ecc:	89 fa                	mov    %edi,%edx
  800ece:	83 c4 1c             	add    $0x1c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
  800ed6:	8d 76 00             	lea    0x0(%esi),%esi
  800ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ee0:	31 ff                	xor    %edi,%edi
  800ee2:	31 c0                	xor    %eax,%eax
  800ee4:	89 fa                	mov    %edi,%edx
  800ee6:	83 c4 1c             	add    $0x1c,%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
  800eee:	66 90                	xchg   %ax,%ax
  800ef0:	31 ff                	xor    %edi,%edi
  800ef2:	89 e8                	mov    %ebp,%eax
  800ef4:	89 f2                	mov    %esi,%edx
  800ef6:	f7 f3                	div    %ebx
  800ef8:	89 fa                	mov    %edi,%edx
  800efa:	83 c4 1c             	add    $0x1c,%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
  800f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f08:	39 f2                	cmp    %esi,%edx
  800f0a:	72 06                	jb     800f12 <__udivdi3+0x102>
  800f0c:	31 c0                	xor    %eax,%eax
  800f0e:	39 eb                	cmp    %ebp,%ebx
  800f10:	77 d2                	ja     800ee4 <__udivdi3+0xd4>
  800f12:	b8 01 00 00 00       	mov    $0x1,%eax
  800f17:	eb cb                	jmp    800ee4 <__udivdi3+0xd4>
  800f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f20:	89 d8                	mov    %ebx,%eax
  800f22:	31 ff                	xor    %edi,%edi
  800f24:	eb be                	jmp    800ee4 <__udivdi3+0xd4>
  800f26:	66 90                	xchg   %ax,%ax
  800f28:	66 90                	xchg   %ax,%ax
  800f2a:	66 90                	xchg   %ax,%ax
  800f2c:	66 90                	xchg   %ax,%ax
  800f2e:	66 90                	xchg   %ax,%ax

00800f30 <__umoddi3>:
  800f30:	55                   	push   %ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 1c             	sub    $0x1c,%esp
  800f37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f47:	85 ed                	test   %ebp,%ebp
  800f49:	89 f0                	mov    %esi,%eax
  800f4b:	89 da                	mov    %ebx,%edx
  800f4d:	75 19                	jne    800f68 <__umoddi3+0x38>
  800f4f:	39 df                	cmp    %ebx,%edi
  800f51:	0f 86 b1 00 00 00    	jbe    801008 <__umoddi3+0xd8>
  800f57:	f7 f7                	div    %edi
  800f59:	89 d0                	mov    %edx,%eax
  800f5b:	31 d2                	xor    %edx,%edx
  800f5d:	83 c4 1c             	add    $0x1c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    
  800f65:	8d 76 00             	lea    0x0(%esi),%esi
  800f68:	39 dd                	cmp    %ebx,%ebp
  800f6a:	77 f1                	ja     800f5d <__umoddi3+0x2d>
  800f6c:	0f bd cd             	bsr    %ebp,%ecx
  800f6f:	83 f1 1f             	xor    $0x1f,%ecx
  800f72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f76:	0f 84 b4 00 00 00    	je     801030 <__umoddi3+0x100>
  800f7c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f87:	29 c2                	sub    %eax,%edx
  800f89:	89 c1                	mov    %eax,%ecx
  800f8b:	89 f8                	mov    %edi,%eax
  800f8d:	d3 e5                	shl    %cl,%ebp
  800f8f:	89 d1                	mov    %edx,%ecx
  800f91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f95:	d3 e8                	shr    %cl,%eax
  800f97:	09 c5                	or     %eax,%ebp
  800f99:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f9d:	89 c1                	mov    %eax,%ecx
  800f9f:	d3 e7                	shl    %cl,%edi
  800fa1:	89 d1                	mov    %edx,%ecx
  800fa3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	d3 ef                	shr    %cl,%edi
  800fab:	89 c1                	mov    %eax,%ecx
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	d3 e3                	shl    %cl,%ebx
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 fa                	mov    %edi,%edx
  800fb5:	d3 e8                	shr    %cl,%eax
  800fb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fbc:	09 d8                	or     %ebx,%eax
  800fbe:	f7 f5                	div    %ebp
  800fc0:	d3 e6                	shl    %cl,%esi
  800fc2:	89 d1                	mov    %edx,%ecx
  800fc4:	f7 64 24 08          	mull   0x8(%esp)
  800fc8:	39 d1                	cmp    %edx,%ecx
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	89 d7                	mov    %edx,%edi
  800fce:	72 06                	jb     800fd6 <__umoddi3+0xa6>
  800fd0:	75 0e                	jne    800fe0 <__umoddi3+0xb0>
  800fd2:	39 c6                	cmp    %eax,%esi
  800fd4:	73 0a                	jae    800fe0 <__umoddi3+0xb0>
  800fd6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800fda:	19 ea                	sbb    %ebp,%edx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	89 c3                	mov    %eax,%ebx
  800fe0:	89 ca                	mov    %ecx,%edx
  800fe2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800fe7:	29 de                	sub    %ebx,%esi
  800fe9:	19 fa                	sbb    %edi,%edx
  800feb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800fef:	89 d0                	mov    %edx,%eax
  800ff1:	d3 e0                	shl    %cl,%eax
  800ff3:	89 d9                	mov    %ebx,%ecx
  800ff5:	d3 ee                	shr    %cl,%esi
  800ff7:	d3 ea                	shr    %cl,%edx
  800ff9:	09 f0                	or     %esi,%eax
  800ffb:	83 c4 1c             	add    $0x1c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    
  801003:	90                   	nop
  801004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801008:	85 ff                	test   %edi,%edi
  80100a:	89 f9                	mov    %edi,%ecx
  80100c:	75 0b                	jne    801019 <__umoddi3+0xe9>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f7                	div    %edi
  801017:	89 c1                	mov    %eax,%ecx
  801019:	89 d8                	mov    %ebx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	f7 f1                	div    %ecx
  80101f:	89 f0                	mov    %esi,%eax
  801021:	f7 f1                	div    %ecx
  801023:	e9 31 ff ff ff       	jmp    800f59 <__umoddi3+0x29>
  801028:	90                   	nop
  801029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801030:	39 dd                	cmp    %ebx,%ebp
  801032:	72 08                	jb     80103c <__umoddi3+0x10c>
  801034:	39 f7                	cmp    %esi,%edi
  801036:	0f 87 21 ff ff ff    	ja     800f5d <__umoddi3+0x2d>
  80103c:	89 da                	mov    %ebx,%edx
  80103e:	89 f0                	mov    %esi,%eax
  801040:	29 f8                	sub    %edi,%eax
  801042:	19 ea                	sbb    %ebp,%edx
  801044:	e9 14 ff ff ff       	jmp    800f5d <__umoddi3+0x2d>
