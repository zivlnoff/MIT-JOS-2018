
obj/user/hello：     文件格式 elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 e0 0f 80 00       	push   $0x800fe0
  80003e:	e8 08 01 00 00       	call   80014b <cprintf>
	//page fault  below why??
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 20 80 00       	mov    0x802004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 ee 0f 80 00       	push   $0x800fee
  800054:	e8 f2 00 00 00       	call   80014b <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 f6 0a 00 00       	call   800b64 <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800076:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800080:	85 db                	test   %ebx,%ebx
  800082:	7e 07                	jle    80008b <libmain+0x2d>
		binaryname = argv[0];
  800084:	8b 06                	mov    (%esi),%eax
  800086:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 0a 00 00 00       	call   8000a4 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000aa:	6a 00                	push   $0x0
  8000ac:	e8 72 0a 00 00       	call   800b23 <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	53                   	push   %ebx
  8000ba:	83 ec 04             	sub    $0x4,%esp
  8000bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c0:	8b 13                	mov    (%ebx),%edx
  8000c2:	8d 42 01             	lea    0x1(%edx),%eax
  8000c5:	89 03                	mov    %eax,(%ebx)
  8000c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ca:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d3:	74 09                	je     8000de <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 ff 00 00 00       	push   $0xff
  8000e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e9:	50                   	push   %eax
  8000ea:	e8 f7 09 00 00       	call   800ae6 <sys_cputs>
		b->idx = 0;
  8000ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	eb db                	jmp    8000d5 <putch+0x1f>

008000fa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800103:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010a:	00 00 00 
	b.cnt = 0;
  80010d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800114:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800117:	ff 75 0c             	pushl  0xc(%ebp)
  80011a:	ff 75 08             	pushl  0x8(%ebp)
  80011d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800123:	50                   	push   %eax
  800124:	68 b6 00 80 00       	push   $0x8000b6
  800129:	e8 1a 01 00 00       	call   800248 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012e:	83 c4 08             	add    $0x8,%esp
  800131:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800137:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	e8 a3 09 00 00       	call   800ae6 <sys_cputs>

	return b.cnt;
}
  800143:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800151:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800154:	50                   	push   %eax
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	e8 9d ff ff ff       	call   8000fa <vcprintf>
	va_end(ap);

	return cnt;
}
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
  800165:	83 ec 1c             	sub    $0x1c,%esp
  800168:	89 c7                	mov    %eax,%edi
  80016a:	89 d6                	mov    %edx,%esi
  80016c:	8b 45 08             	mov    0x8(%ebp),%eax
  80016f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800172:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800175:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800178:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80017b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800180:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800183:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800186:	39 d3                	cmp    %edx,%ebx
  800188:	72 05                	jb     80018f <printnum+0x30>
  80018a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80018d:	77 7a                	ja     800209 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	ff 75 18             	pushl  0x18(%ebp)
  800195:	8b 45 14             	mov    0x14(%ebp),%eax
  800198:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80019b:	53                   	push   %ebx
  80019c:	ff 75 10             	pushl  0x10(%ebp)
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ae:	e8 ed 0b 00 00       	call   800da0 <__udivdi3>
  8001b3:	83 c4 18             	add    $0x18,%esp
  8001b6:	52                   	push   %edx
  8001b7:	50                   	push   %eax
  8001b8:	89 f2                	mov    %esi,%edx
  8001ba:	89 f8                	mov    %edi,%eax
  8001bc:	e8 9e ff ff ff       	call   80015f <printnum>
  8001c1:	83 c4 20             	add    $0x20,%esp
  8001c4:	eb 13                	jmp    8001d9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001c6:	83 ec 08             	sub    $0x8,%esp
  8001c9:	56                   	push   %esi
  8001ca:	ff 75 18             	pushl  0x18(%ebp)
  8001cd:	ff d7                	call   *%edi
  8001cf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001d2:	83 eb 01             	sub    $0x1,%ebx
  8001d5:	85 db                	test   %ebx,%ebx
  8001d7:	7f ed                	jg     8001c6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	56                   	push   %esi
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e6:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ec:	e8 cf 0c 00 00       	call   800ec0 <__umoddi3>
  8001f1:	83 c4 14             	add    $0x14,%esp
  8001f4:	0f be 80 0f 10 80 00 	movsbl 0x80100f(%eax),%eax
  8001fb:	50                   	push   %eax
  8001fc:	ff d7                	call   *%edi
}
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800204:	5b                   	pop    %ebx
  800205:	5e                   	pop    %esi
  800206:	5f                   	pop    %edi
  800207:	5d                   	pop    %ebp
  800208:	c3                   	ret    
  800209:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80020c:	eb c4                	jmp    8001d2 <printnum+0x73>

0080020e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800214:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800218:	8b 10                	mov    (%eax),%edx
  80021a:	3b 50 04             	cmp    0x4(%eax),%edx
  80021d:	73 0a                	jae    800229 <sprintputch+0x1b>
		*b->buf++ = ch;
  80021f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800222:	89 08                	mov    %ecx,(%eax)
  800224:	8b 45 08             	mov    0x8(%ebp),%eax
  800227:	88 02                	mov    %al,(%edx)
}
  800229:	5d                   	pop    %ebp
  80022a:	c3                   	ret    

0080022b <printfmt>:
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800231:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800234:	50                   	push   %eax
  800235:	ff 75 10             	pushl  0x10(%ebp)
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	e8 05 00 00 00       	call   800248 <vprintfmt>
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <vprintfmt>:
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 2c             	sub    $0x2c,%esp
  800251:	8b 75 08             	mov    0x8(%ebp),%esi
  800254:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800257:	8b 7d 10             	mov    0x10(%ebp),%edi
  80025a:	e9 00 04 00 00       	jmp    80065f <vprintfmt+0x417>
		padc = ' ';
  80025f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800263:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80026a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800271:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800278:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80027d:	8d 47 01             	lea    0x1(%edi),%eax
  800280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800283:	0f b6 17             	movzbl (%edi),%edx
  800286:	8d 42 dd             	lea    -0x23(%edx),%eax
  800289:	3c 55                	cmp    $0x55,%al
  80028b:	0f 87 51 04 00 00    	ja     8006e2 <vprintfmt+0x49a>
  800291:	0f b6 c0             	movzbl %al,%eax
  800294:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  80029b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80029e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002a2:	eb d9                	jmp    80027d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002a7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ab:	eb d0                	jmp    80027d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ad:	0f b6 d2             	movzbl %dl,%edx
  8002b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002c2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002c5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002c8:	83 f9 09             	cmp    $0x9,%ecx
  8002cb:	77 55                	ja     800322 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002cd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d0:	eb e9                	jmp    8002bb <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002da:	8b 45 14             	mov    0x14(%ebp),%eax
  8002dd:	8d 40 04             	lea    0x4(%eax),%eax
  8002e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002ea:	79 91                	jns    80027d <vprintfmt+0x35>
				width = precision, precision = -1;
  8002ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f9:	eb 82                	jmp    80027d <vprintfmt+0x35>
  8002fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fe:	85 c0                	test   %eax,%eax
  800300:	ba 00 00 00 00       	mov    $0x0,%edx
  800305:	0f 49 d0             	cmovns %eax,%edx
  800308:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80030e:	e9 6a ff ff ff       	jmp    80027d <vprintfmt+0x35>
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800316:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80031d:	e9 5b ff ff ff       	jmp    80027d <vprintfmt+0x35>
  800322:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800325:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800328:	eb bc                	jmp    8002e6 <vprintfmt+0x9e>
			lflag++;
  80032a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800330:	e9 48 ff ff ff       	jmp    80027d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	8d 78 04             	lea    0x4(%eax),%edi
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	53                   	push   %ebx
  80033f:	ff 30                	pushl  (%eax)
  800341:	ff d6                	call   *%esi
			break;
  800343:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800346:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800349:	e9 0e 03 00 00       	jmp    80065c <vprintfmt+0x414>
			err = va_arg(ap, int);
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	8d 78 04             	lea    0x4(%eax),%edi
  800354:	8b 00                	mov    (%eax),%eax
  800356:	99                   	cltd   
  800357:	31 d0                	xor    %edx,%eax
  800359:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80035b:	83 f8 08             	cmp    $0x8,%eax
  80035e:	7f 23                	jg     800383 <vprintfmt+0x13b>
  800360:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  800367:	85 d2                	test   %edx,%edx
  800369:	74 18                	je     800383 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80036b:	52                   	push   %edx
  80036c:	68 30 10 80 00       	push   $0x801030
  800371:	53                   	push   %ebx
  800372:	56                   	push   %esi
  800373:	e8 b3 fe ff ff       	call   80022b <printfmt>
  800378:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80037b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80037e:	e9 d9 02 00 00       	jmp    80065c <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800383:	50                   	push   %eax
  800384:	68 27 10 80 00       	push   $0x801027
  800389:	53                   	push   %ebx
  80038a:	56                   	push   %esi
  80038b:	e8 9b fe ff ff       	call   80022b <printfmt>
  800390:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800393:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800396:	e9 c1 02 00 00       	jmp    80065c <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80039b:	8b 45 14             	mov    0x14(%ebp),%eax
  80039e:	83 c0 04             	add    $0x4,%eax
  8003a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a7:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003a9:	85 ff                	test   %edi,%edi
  8003ab:	b8 20 10 80 00       	mov    $0x801020,%eax
  8003b0:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b7:	0f 8e bd 00 00 00    	jle    80047a <vprintfmt+0x232>
  8003bd:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c1:	75 0e                	jne    8003d1 <vprintfmt+0x189>
  8003c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8003c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003cf:	eb 6d                	jmp    80043e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	57                   	push   %edi
  8003d8:	e8 ad 03 00 00       	call   80078a <strnlen>
  8003dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e0:	29 c1                	sub    %eax,%ecx
  8003e2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003e5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ef:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003f2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f4:	eb 0f                	jmp    800405 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	53                   	push   %ebx
  8003fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8003fd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ff:	83 ef 01             	sub    $0x1,%edi
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	85 ff                	test   %edi,%edi
  800407:	7f ed                	jg     8003f6 <vprintfmt+0x1ae>
  800409:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80040c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80040f:	85 c9                	test   %ecx,%ecx
  800411:	b8 00 00 00 00       	mov    $0x0,%eax
  800416:	0f 49 c1             	cmovns %ecx,%eax
  800419:	29 c1                	sub    %eax,%ecx
  80041b:	89 75 08             	mov    %esi,0x8(%ebp)
  80041e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800421:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800424:	89 cb                	mov    %ecx,%ebx
  800426:	eb 16                	jmp    80043e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800428:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80042c:	75 31                	jne    80045f <vprintfmt+0x217>
					putch(ch, putdat);
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	ff 75 0c             	pushl  0xc(%ebp)
  800434:	50                   	push   %eax
  800435:	ff 55 08             	call   *0x8(%ebp)
  800438:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80043b:	83 eb 01             	sub    $0x1,%ebx
  80043e:	83 c7 01             	add    $0x1,%edi
  800441:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800445:	0f be c2             	movsbl %dl,%eax
  800448:	85 c0                	test   %eax,%eax
  80044a:	74 59                	je     8004a5 <vprintfmt+0x25d>
  80044c:	85 f6                	test   %esi,%esi
  80044e:	78 d8                	js     800428 <vprintfmt+0x1e0>
  800450:	83 ee 01             	sub    $0x1,%esi
  800453:	79 d3                	jns    800428 <vprintfmt+0x1e0>
  800455:	89 df                	mov    %ebx,%edi
  800457:	8b 75 08             	mov    0x8(%ebp),%esi
  80045a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80045d:	eb 37                	jmp    800496 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80045f:	0f be d2             	movsbl %dl,%edx
  800462:	83 ea 20             	sub    $0x20,%edx
  800465:	83 fa 5e             	cmp    $0x5e,%edx
  800468:	76 c4                	jbe    80042e <vprintfmt+0x1e6>
					putch('?', putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	6a 3f                	push   $0x3f
  800472:	ff 55 08             	call   *0x8(%ebp)
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	eb c1                	jmp    80043b <vprintfmt+0x1f3>
  80047a:	89 75 08             	mov    %esi,0x8(%ebp)
  80047d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800480:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800483:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800486:	eb b6                	jmp    80043e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	53                   	push   %ebx
  80048c:	6a 20                	push   $0x20
  80048e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800490:	83 ef 01             	sub    $0x1,%edi
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	85 ff                	test   %edi,%edi
  800498:	7f ee                	jg     800488 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80049a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049d:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a0:	e9 b7 01 00 00       	jmp    80065c <vprintfmt+0x414>
  8004a5:	89 df                	mov    %ebx,%edi
  8004a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ad:	eb e7                	jmp    800496 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004af:	83 f9 01             	cmp    $0x1,%ecx
  8004b2:	7e 3f                	jle    8004f3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	8b 50 04             	mov    0x4(%eax),%edx
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8d 40 08             	lea    0x8(%eax),%eax
  8004c8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004cf:	79 5c                	jns    80052d <vprintfmt+0x2e5>
				putch('-', putdat);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	6a 2d                	push   $0x2d
  8004d7:	ff d6                	call   *%esi
				num = -(long long) num;
  8004d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004df:	f7 da                	neg    %edx
  8004e1:	83 d1 00             	adc    $0x0,%ecx
  8004e4:	f7 d9                	neg    %ecx
  8004e6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004ee:	e9 4f 01 00 00       	jmp    800642 <vprintfmt+0x3fa>
	else if (lflag)
  8004f3:	85 c9                	test   %ecx,%ecx
  8004f5:	75 1b                	jne    800512 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ff:	89 c1                	mov    %eax,%ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 40 04             	lea    0x4(%eax),%eax
  80050d:	89 45 14             	mov    %eax,0x14(%ebp)
  800510:	eb b9                	jmp    8004cb <vprintfmt+0x283>
		return va_arg(*ap, long);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	c1 f9 1f             	sar    $0x1f,%ecx
  80051f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 40 04             	lea    0x4(%eax),%eax
  800528:	89 45 14             	mov    %eax,0x14(%ebp)
  80052b:	eb 9e                	jmp    8004cb <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80052d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800530:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800533:	b8 0a 00 00 00       	mov    $0xa,%eax
  800538:	e9 05 01 00 00       	jmp    800642 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80053d:	83 f9 01             	cmp    $0x1,%ecx
  800540:	7e 18                	jle    80055a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 10                	mov    (%eax),%edx
  800547:	8b 48 04             	mov    0x4(%eax),%ecx
  80054a:	8d 40 08             	lea    0x8(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800550:	b8 0a 00 00 00       	mov    $0xa,%eax
  800555:	e9 e8 00 00 00       	jmp    800642 <vprintfmt+0x3fa>
	else if (lflag)
  80055a:	85 c9                	test   %ecx,%ecx
  80055c:	75 1a                	jne    800578 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 10                	mov    (%eax),%edx
  800563:	b9 00 00 00 00       	mov    $0x0,%ecx
  800568:	8d 40 04             	lea    0x4(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800573:	e9 ca 00 00 00       	jmp    800642 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8b 10                	mov    (%eax),%edx
  80057d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800582:	8d 40 04             	lea    0x4(%eax),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800588:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058d:	e9 b0 00 00 00       	jmp    800642 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800592:	83 f9 01             	cmp    $0x1,%ecx
  800595:	7e 3c                	jle    8005d3 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8b 50 04             	mov    0x4(%eax),%edx
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 40 08             	lea    0x8(%eax),%eax
  8005ab:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b2:	79 59                	jns    80060d <vprintfmt+0x3c5>
                putch('-', putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	53                   	push   %ebx
  8005b8:	6a 2d                	push   $0x2d
  8005ba:	ff d6                	call   *%esi
                num = -(long long) num;
  8005bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c2:	f7 da                	neg    %edx
  8005c4:	83 d1 00             	adc    $0x0,%ecx
  8005c7:	f7 d9                	neg    %ecx
  8005c9:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d1:	eb 6f                	jmp    800642 <vprintfmt+0x3fa>
	else if (lflag)
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	75 1b                	jne    8005f2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f0:	eb bc                	jmp    8005ae <vprintfmt+0x366>
		return va_arg(*ap, long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	89 c1                	mov    %eax,%ecx
  8005fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 40 04             	lea    0x4(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	eb a1                	jmp    8005ae <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80060d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800610:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800613:	b8 08 00 00 00       	mov    $0x8,%eax
  800618:	eb 28                	jmp    800642 <vprintfmt+0x3fa>
			putch('0', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	6a 30                	push   $0x30
  800620:	ff d6                	call   *%esi
			putch('x', putdat);
  800622:	83 c4 08             	add    $0x8,%esp
  800625:	53                   	push   %ebx
  800626:	6a 78                	push   $0x78
  800628:	ff d6                	call   *%esi
			num = (unsigned long long)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 10                	mov    (%eax),%edx
  80062f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800634:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80063d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800649:	57                   	push   %edi
  80064a:	ff 75 e0             	pushl  -0x20(%ebp)
  80064d:	50                   	push   %eax
  80064e:	51                   	push   %ecx
  80064f:	52                   	push   %edx
  800650:	89 da                	mov    %ebx,%edx
  800652:	89 f0                	mov    %esi,%eax
  800654:	e8 06 fb ff ff       	call   80015f <printnum>
			break;
  800659:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80065c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065f:	83 c7 01             	add    $0x1,%edi
  800662:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800666:	83 f8 25             	cmp    $0x25,%eax
  800669:	0f 84 f0 fb ff ff    	je     80025f <vprintfmt+0x17>
			if (ch == '\0')
  80066f:	85 c0                	test   %eax,%eax
  800671:	0f 84 8b 00 00 00    	je     800702 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	50                   	push   %eax
  80067c:	ff d6                	call   *%esi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	eb dc                	jmp    80065f <vprintfmt+0x417>
	if (lflag >= 2)
  800683:	83 f9 01             	cmp    $0x1,%ecx
  800686:	7e 15                	jle    80069d <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	8b 48 04             	mov    0x4(%eax),%ecx
  800690:	8d 40 08             	lea    0x8(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800696:	b8 10 00 00 00       	mov    $0x10,%eax
  80069b:	eb a5                	jmp    800642 <vprintfmt+0x3fa>
	else if (lflag)
  80069d:	85 c9                	test   %ecx,%ecx
  80069f:	75 17                	jne    8006b8 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 10                	mov    (%eax),%edx
  8006a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b6:	eb 8a                	jmp    800642 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 10                	mov    (%eax),%edx
  8006bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006cd:	e9 70 ff ff ff       	jmp    800642 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 25                	push   $0x25
  8006d8:	ff d6                	call   *%esi
			break;
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	e9 7a ff ff ff       	jmp    80065c <vprintfmt+0x414>
			putch('%', putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	6a 25                	push   $0x25
  8006e8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	89 f8                	mov    %edi,%eax
  8006ef:	eb 03                	jmp    8006f4 <vprintfmt+0x4ac>
  8006f1:	83 e8 01             	sub    $0x1,%eax
  8006f4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006f8:	75 f7                	jne    8006f1 <vprintfmt+0x4a9>
  8006fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006fd:	e9 5a ff ff ff       	jmp    80065c <vprintfmt+0x414>
}
  800702:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800705:	5b                   	pop    %ebx
  800706:	5e                   	pop    %esi
  800707:	5f                   	pop    %edi
  800708:	5d                   	pop    %ebp
  800709:	c3                   	ret    

0080070a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
  80070d:	83 ec 18             	sub    $0x18,%esp
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800716:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800719:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80071d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800720:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800727:	85 c0                	test   %eax,%eax
  800729:	74 26                	je     800751 <vsnprintf+0x47>
  80072b:	85 d2                	test   %edx,%edx
  80072d:	7e 22                	jle    800751 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80072f:	ff 75 14             	pushl  0x14(%ebp)
  800732:	ff 75 10             	pushl  0x10(%ebp)
  800735:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	68 0e 02 80 00       	push   $0x80020e
  80073e:	e8 05 fb ff ff       	call   800248 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800746:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80074c:	83 c4 10             	add    $0x10,%esp
}
  80074f:	c9                   	leave  
  800750:	c3                   	ret    
		return -E_INVAL;
  800751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800756:	eb f7                	jmp    80074f <vsnprintf+0x45>

00800758 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80075e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800761:	50                   	push   %eax
  800762:	ff 75 10             	pushl  0x10(%ebp)
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	ff 75 08             	pushl  0x8(%ebp)
  80076b:	e8 9a ff ff ff       	call   80070a <vsnprintf>
	va_end(ap);

	return rc;
}
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800778:	b8 00 00 00 00       	mov    $0x0,%eax
  80077d:	eb 03                	jmp    800782 <strlen+0x10>
		n++;
  80077f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800782:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800786:	75 f7                	jne    80077f <strlen+0xd>
	return n;
}
  800788:	5d                   	pop    %ebp
  800789:	c3                   	ret    

0080078a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800790:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800793:	b8 00 00 00 00       	mov    $0x0,%eax
  800798:	eb 03                	jmp    80079d <strnlen+0x13>
		n++;
  80079a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079d:	39 d0                	cmp    %edx,%eax
  80079f:	74 06                	je     8007a7 <strnlen+0x1d>
  8007a1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a5:	75 f3                	jne    80079a <strnlen+0x10>
	return n;
}
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b3:	89 c2                	mov    %eax,%edx
  8007b5:	83 c1 01             	add    $0x1,%ecx
  8007b8:	83 c2 01             	add    $0x1,%edx
  8007bb:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007bf:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007c2:	84 db                	test   %bl,%bl
  8007c4:	75 ef                	jne    8007b5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007c6:	5b                   	pop    %ebx
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	53                   	push   %ebx
  8007cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d0:	53                   	push   %ebx
  8007d1:	e8 9c ff ff ff       	call   800772 <strlen>
  8007d6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	01 d8                	add    %ebx,%eax
  8007de:	50                   	push   %eax
  8007df:	e8 c5 ff ff ff       	call   8007a9 <strcpy>
	return dst;
}
  8007e4:	89 d8                	mov    %ebx,%eax
  8007e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e9:	c9                   	leave  
  8007ea:	c3                   	ret    

008007eb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	56                   	push   %esi
  8007ef:	53                   	push   %ebx
  8007f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f6:	89 f3                	mov    %esi,%ebx
  8007f8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007fb:	89 f2                	mov    %esi,%edx
  8007fd:	eb 0f                	jmp    80080e <strncpy+0x23>
		*dst++ = *src;
  8007ff:	83 c2 01             	add    $0x1,%edx
  800802:	0f b6 01             	movzbl (%ecx),%eax
  800805:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800808:	80 39 01             	cmpb   $0x1,(%ecx)
  80080b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80080e:	39 da                	cmp    %ebx,%edx
  800810:	75 ed                	jne    8007ff <strncpy+0x14>
	}
	return ret;
}
  800812:	89 f0                	mov    %esi,%eax
  800814:	5b                   	pop    %ebx
  800815:	5e                   	pop    %esi
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	56                   	push   %esi
  80081c:	53                   	push   %ebx
  80081d:	8b 75 08             	mov    0x8(%ebp),%esi
  800820:	8b 55 0c             	mov    0xc(%ebp),%edx
  800823:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800826:	89 f0                	mov    %esi,%eax
  800828:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082c:	85 c9                	test   %ecx,%ecx
  80082e:	75 0b                	jne    80083b <strlcpy+0x23>
  800830:	eb 17                	jmp    800849 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800832:	83 c2 01             	add    $0x1,%edx
  800835:	83 c0 01             	add    $0x1,%eax
  800838:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80083b:	39 d8                	cmp    %ebx,%eax
  80083d:	74 07                	je     800846 <strlcpy+0x2e>
  80083f:	0f b6 0a             	movzbl (%edx),%ecx
  800842:	84 c9                	test   %cl,%cl
  800844:	75 ec                	jne    800832 <strlcpy+0x1a>
		*dst = '\0';
  800846:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800849:	29 f0                	sub    %esi,%eax
}
  80084b:	5b                   	pop    %ebx
  80084c:	5e                   	pop    %esi
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800858:	eb 06                	jmp    800860 <strcmp+0x11>
		p++, q++;
  80085a:	83 c1 01             	add    $0x1,%ecx
  80085d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800860:	0f b6 01             	movzbl (%ecx),%eax
  800863:	84 c0                	test   %al,%al
  800865:	74 04                	je     80086b <strcmp+0x1c>
  800867:	3a 02                	cmp    (%edx),%al
  800869:	74 ef                	je     80085a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086b:	0f b6 c0             	movzbl %al,%eax
  80086e:	0f b6 12             	movzbl (%edx),%edx
  800871:	29 d0                	sub    %edx,%eax
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	53                   	push   %ebx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087f:	89 c3                	mov    %eax,%ebx
  800881:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800884:	eb 06                	jmp    80088c <strncmp+0x17>
		n--, p++, q++;
  800886:	83 c0 01             	add    $0x1,%eax
  800889:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80088c:	39 d8                	cmp    %ebx,%eax
  80088e:	74 16                	je     8008a6 <strncmp+0x31>
  800890:	0f b6 08             	movzbl (%eax),%ecx
  800893:	84 c9                	test   %cl,%cl
  800895:	74 04                	je     80089b <strncmp+0x26>
  800897:	3a 0a                	cmp    (%edx),%cl
  800899:	74 eb                	je     800886 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80089b:	0f b6 00             	movzbl (%eax),%eax
  80089e:	0f b6 12             	movzbl (%edx),%edx
  8008a1:	29 d0                	sub    %edx,%eax
}
  8008a3:	5b                   	pop    %ebx
  8008a4:	5d                   	pop    %ebp
  8008a5:	c3                   	ret    
		return 0;
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb f6                	jmp    8008a3 <strncmp+0x2e>

008008ad <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b7:	0f b6 10             	movzbl (%eax),%edx
  8008ba:	84 d2                	test   %dl,%dl
  8008bc:	74 09                	je     8008c7 <strchr+0x1a>
		if (*s == c)
  8008be:	38 ca                	cmp    %cl,%dl
  8008c0:	74 0a                	je     8008cc <strchr+0x1f>
	for (; *s; s++)
  8008c2:	83 c0 01             	add    $0x1,%eax
  8008c5:	eb f0                	jmp    8008b7 <strchr+0xa>
			return (char *) s;
	return 0;
  8008c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d8:	eb 03                	jmp    8008dd <strfind+0xf>
  8008da:	83 c0 01             	add    $0x1,%eax
  8008dd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008e0:	38 ca                	cmp    %cl,%dl
  8008e2:	74 04                	je     8008e8 <strfind+0x1a>
  8008e4:	84 d2                	test   %dl,%dl
  8008e6:	75 f2                	jne    8008da <strfind+0xc>
			break;
	return (char *) s;
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	57                   	push   %edi
  8008ee:	56                   	push   %esi
  8008ef:	53                   	push   %ebx
  8008f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008f6:	85 c9                	test   %ecx,%ecx
  8008f8:	74 13                	je     80090d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008fa:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800900:	75 05                	jne    800907 <memset+0x1d>
  800902:	f6 c1 03             	test   $0x3,%cl
  800905:	74 0d                	je     800914 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	fc                   	cld    
  80090b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80090d:	89 f8                	mov    %edi,%eax
  80090f:	5b                   	pop    %ebx
  800910:	5e                   	pop    %esi
  800911:	5f                   	pop    %edi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    
		c &= 0xFF;
  800914:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800918:	89 d3                	mov    %edx,%ebx
  80091a:	c1 e3 08             	shl    $0x8,%ebx
  80091d:	89 d0                	mov    %edx,%eax
  80091f:	c1 e0 18             	shl    $0x18,%eax
  800922:	89 d6                	mov    %edx,%esi
  800924:	c1 e6 10             	shl    $0x10,%esi
  800927:	09 f0                	or     %esi,%eax
  800929:	09 c2                	or     %eax,%edx
  80092b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80092d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800930:	89 d0                	mov    %edx,%eax
  800932:	fc                   	cld    
  800933:	f3 ab                	rep stos %eax,%es:(%edi)
  800935:	eb d6                	jmp    80090d <memset+0x23>

00800937 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	57                   	push   %edi
  80093b:	56                   	push   %esi
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800942:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800945:	39 c6                	cmp    %eax,%esi
  800947:	73 35                	jae    80097e <memmove+0x47>
  800949:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80094c:	39 c2                	cmp    %eax,%edx
  80094e:	76 2e                	jbe    80097e <memmove+0x47>
		s += n;
		d += n;
  800950:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800953:	89 d6                	mov    %edx,%esi
  800955:	09 fe                	or     %edi,%esi
  800957:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80095d:	74 0c                	je     80096b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80095f:	83 ef 01             	sub    $0x1,%edi
  800962:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800965:	fd                   	std    
  800966:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800968:	fc                   	cld    
  800969:	eb 21                	jmp    80098c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096b:	f6 c1 03             	test   $0x3,%cl
  80096e:	75 ef                	jne    80095f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800970:	83 ef 04             	sub    $0x4,%edi
  800973:	8d 72 fc             	lea    -0x4(%edx),%esi
  800976:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800979:	fd                   	std    
  80097a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097c:	eb ea                	jmp    800968 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097e:	89 f2                	mov    %esi,%edx
  800980:	09 c2                	or     %eax,%edx
  800982:	f6 c2 03             	test   $0x3,%dl
  800985:	74 09                	je     800990 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800987:	89 c7                	mov    %eax,%edi
  800989:	fc                   	cld    
  80098a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80098c:	5e                   	pop    %esi
  80098d:	5f                   	pop    %edi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800990:	f6 c1 03             	test   $0x3,%cl
  800993:	75 f2                	jne    800987 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800995:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800998:	89 c7                	mov    %eax,%edi
  80099a:	fc                   	cld    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb ed                	jmp    80098c <memmove+0x55>

0080099f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009a2:	ff 75 10             	pushl  0x10(%ebp)
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	ff 75 08             	pushl  0x8(%ebp)
  8009ab:	e8 87 ff ff ff       	call   800937 <memmove>
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	56                   	push   %esi
  8009b6:	53                   	push   %ebx
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bd:	89 c6                	mov    %eax,%esi
  8009bf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c2:	39 f0                	cmp    %esi,%eax
  8009c4:	74 1c                	je     8009e2 <memcmp+0x30>
		if (*s1 != *s2)
  8009c6:	0f b6 08             	movzbl (%eax),%ecx
  8009c9:	0f b6 1a             	movzbl (%edx),%ebx
  8009cc:	38 d9                	cmp    %bl,%cl
  8009ce:	75 08                	jne    8009d8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d0:	83 c0 01             	add    $0x1,%eax
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	eb ea                	jmp    8009c2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009d8:	0f b6 c1             	movzbl %cl,%eax
  8009db:	0f b6 db             	movzbl %bl,%ebx
  8009de:	29 d8                	sub    %ebx,%eax
  8009e0:	eb 05                	jmp    8009e7 <memcmp+0x35>
	}

	return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e7:	5b                   	pop    %ebx
  8009e8:	5e                   	pop    %esi
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f4:	89 c2                	mov    %eax,%edx
  8009f6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f9:	39 d0                	cmp    %edx,%eax
  8009fb:	73 09                	jae    800a06 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009fd:	38 08                	cmp    %cl,(%eax)
  8009ff:	74 05                	je     800a06 <memfind+0x1b>
	for (; s < ends; s++)
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	eb f3                	jmp    8009f9 <memfind+0xe>
			break;
	return (void *) s;
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	57                   	push   %edi
  800a0c:	56                   	push   %esi
  800a0d:	53                   	push   %ebx
  800a0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a14:	eb 03                	jmp    800a19 <strtol+0x11>
		s++;
  800a16:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a19:	0f b6 01             	movzbl (%ecx),%eax
  800a1c:	3c 20                	cmp    $0x20,%al
  800a1e:	74 f6                	je     800a16 <strtol+0xe>
  800a20:	3c 09                	cmp    $0x9,%al
  800a22:	74 f2                	je     800a16 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a24:	3c 2b                	cmp    $0x2b,%al
  800a26:	74 2e                	je     800a56 <strtol+0x4e>
	int neg = 0;
  800a28:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a2d:	3c 2d                	cmp    $0x2d,%al
  800a2f:	74 2f                	je     800a60 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a31:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a37:	75 05                	jne    800a3e <strtol+0x36>
  800a39:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3c:	74 2c                	je     800a6a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a3e:	85 db                	test   %ebx,%ebx
  800a40:	75 0a                	jne    800a4c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a42:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a47:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4a:	74 28                	je     800a74 <strtol+0x6c>
		base = 10;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a51:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a54:	eb 50                	jmp    800aa6 <strtol+0x9e>
		s++;
  800a56:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a59:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5e:	eb d1                	jmp    800a31 <strtol+0x29>
		s++, neg = 1;
  800a60:	83 c1 01             	add    $0x1,%ecx
  800a63:	bf 01 00 00 00       	mov    $0x1,%edi
  800a68:	eb c7                	jmp    800a31 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a6e:	74 0e                	je     800a7e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a70:	85 db                	test   %ebx,%ebx
  800a72:	75 d8                	jne    800a4c <strtol+0x44>
		s++, base = 8;
  800a74:	83 c1 01             	add    $0x1,%ecx
  800a77:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a7c:	eb ce                	jmp    800a4c <strtol+0x44>
		s += 2, base = 16;
  800a7e:	83 c1 02             	add    $0x2,%ecx
  800a81:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a86:	eb c4                	jmp    800a4c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a88:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a8b:	89 f3                	mov    %esi,%ebx
  800a8d:	80 fb 19             	cmp    $0x19,%bl
  800a90:	77 29                	ja     800abb <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a92:	0f be d2             	movsbl %dl,%edx
  800a95:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a98:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a9b:	7d 30                	jge    800acd <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a9d:	83 c1 01             	add    $0x1,%ecx
  800aa0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aa6:	0f b6 11             	movzbl (%ecx),%edx
  800aa9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aac:	89 f3                	mov    %esi,%ebx
  800aae:	80 fb 09             	cmp    $0x9,%bl
  800ab1:	77 d5                	ja     800a88 <strtol+0x80>
			dig = *s - '0';
  800ab3:	0f be d2             	movsbl %dl,%edx
  800ab6:	83 ea 30             	sub    $0x30,%edx
  800ab9:	eb dd                	jmp    800a98 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800abb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800abe:	89 f3                	mov    %esi,%ebx
  800ac0:	80 fb 19             	cmp    $0x19,%bl
  800ac3:	77 08                	ja     800acd <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ac5:	0f be d2             	movsbl %dl,%edx
  800ac8:	83 ea 37             	sub    $0x37,%edx
  800acb:	eb cb                	jmp    800a98 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800acd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad1:	74 05                	je     800ad8 <strtol+0xd0>
		*endptr = (char *) s;
  800ad3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ad8:	89 c2                	mov    %eax,%edx
  800ada:	f7 da                	neg    %edx
  800adc:	85 ff                	test   %edi,%edi
  800ade:	0f 45 c2             	cmovne %edx,%eax
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5f                   	pop    %edi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	57                   	push   %edi
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
  800af1:	8b 55 08             	mov    0x8(%ebp),%edx
  800af4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af7:	89 c3                	mov    %eax,%ebx
  800af9:	89 c7                	mov    %eax,%edi
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <sys_cgetc>:

int
sys_cgetc(void) {
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b14:	89 d1                	mov    %edx,%ecx
  800b16:	89 d3                	mov    %edx,%ebx
  800b18:	89 d7                	mov    %edx,%edi
  800b1a:	89 d6                	mov    %edx,%esi
  800b1c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b31:	8b 55 08             	mov    0x8(%ebp),%edx
  800b34:	b8 03 00 00 00       	mov    $0x3,%eax
  800b39:	89 cb                	mov    %ecx,%ebx
  800b3b:	89 cf                	mov    %ecx,%edi
  800b3d:	89 ce                	mov    %ecx,%esi
  800b3f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b41:	85 c0                	test   %eax,%eax
  800b43:	7f 08                	jg     800b4d <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5f                   	pop    %edi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b4d:	83 ec 0c             	sub    $0xc,%esp
  800b50:	50                   	push   %eax
  800b51:	6a 03                	push   $0x3
  800b53:	68 64 12 80 00       	push   $0x801264
  800b58:	6a 24                	push   $0x24
  800b5a:	68 81 12 80 00       	push   $0x801281
  800b5f:	e8 ed 01 00 00       	call   800d51 <_panic>

00800b64 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 02 00 00 00       	mov    $0x2,%eax
  800b74:	89 d1                	mov    %edx,%ecx
  800b76:	89 d3                	mov    %edx,%ebx
  800b78:	89 d7                	mov    %edx,%edi
  800b7a:	89 d6                	mov    %edx,%esi
  800b7c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <sys_yield>:

void
sys_yield(void)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b93:	89 d1                	mov    %edx,%ecx
  800b95:	89 d3                	mov    %edx,%ebx
  800b97:	89 d7                	mov    %edx,%edi
  800b99:	89 d6                	mov    %edx,%esi
  800b9b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bab:	be 00 00 00 00       	mov    $0x0,%esi
  800bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb6:	b8 04 00 00 00       	mov    $0x4,%eax
  800bbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bbe:	89 f7                	mov    %esi,%edi
  800bc0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bc2:	85 c0                	test   %eax,%eax
  800bc4:	7f 08                	jg     800bce <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bce:	83 ec 0c             	sub    $0xc,%esp
  800bd1:	50                   	push   %eax
  800bd2:	6a 04                	push   $0x4
  800bd4:	68 64 12 80 00       	push   $0x801264
  800bd9:	6a 24                	push   $0x24
  800bdb:	68 81 12 80 00       	push   $0x801281
  800be0:	e8 6c 01 00 00       	call   800d51 <_panic>

00800be5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	b8 05 00 00 00       	mov    $0x5,%eax
  800bf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bfc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bff:	8b 75 18             	mov    0x18(%ebp),%esi
  800c02:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c04:	85 c0                	test   %eax,%eax
  800c06:	7f 08                	jg     800c10 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	6a 05                	push   $0x5
  800c16:	68 64 12 80 00       	push   $0x801264
  800c1b:	6a 24                	push   $0x24
  800c1d:	68 81 12 80 00       	push   $0x801281
  800c22:	e8 2a 01 00 00       	call   800d51 <_panic>

00800c27 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c40:	89 df                	mov    %ebx,%edi
  800c42:	89 de                	mov    %ebx,%esi
  800c44:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c46:	85 c0                	test   %eax,%eax
  800c48:	7f 08                	jg     800c52 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c52:	83 ec 0c             	sub    $0xc,%esp
  800c55:	50                   	push   %eax
  800c56:	6a 06                	push   $0x6
  800c58:	68 64 12 80 00       	push   $0x801264
  800c5d:	6a 24                	push   $0x24
  800c5f:	68 81 12 80 00       	push   $0x801281
  800c64:	e8 e8 00 00 00       	call   800d51 <_panic>

00800c69 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c82:	89 df                	mov    %ebx,%edi
  800c84:	89 de                	mov    %ebx,%esi
  800c86:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7f 08                	jg     800c94 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	6a 08                	push   $0x8
  800c9a:	68 64 12 80 00       	push   $0x801264
  800c9f:	6a 24                	push   $0x24
  800ca1:	68 81 12 80 00       	push   $0x801281
  800ca6:	e8 a6 00 00 00       	call   800d51 <_panic>

00800cab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc4:	89 df                	mov    %ebx,%edi
  800cc6:	89 de                	mov    %ebx,%esi
  800cc8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7f 08                	jg     800cd6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	50                   	push   %eax
  800cda:	6a 09                	push   $0x9
  800cdc:	68 64 12 80 00       	push   $0x801264
  800ce1:	6a 24                	push   $0x24
  800ce3:	68 81 12 80 00       	push   $0x801281
  800ce8:	e8 64 00 00 00       	call   800d51 <_panic>

00800ced <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cfe:	be 00 00 00 00       	mov    $0x0,%esi
  800d03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d06:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d09:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    

00800d10 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d26:	89 cb                	mov    %ecx,%ebx
  800d28:	89 cf                	mov    %ecx,%edi
  800d2a:	89 ce                	mov    %ecx,%esi
  800d2c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 0c                	push   $0xc
  800d40:	68 64 12 80 00       	push   $0x801264
  800d45:	6a 24                	push   $0x24
  800d47:	68 81 12 80 00       	push   $0x801281
  800d4c:	e8 00 00 00 00       	call   800d51 <_panic>

00800d51 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d56:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d59:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d5f:	e8 00 fe ff ff       	call   800b64 <sys_getenvid>
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	ff 75 08             	pushl  0x8(%ebp)
  800d6d:	56                   	push   %esi
  800d6e:	50                   	push   %eax
  800d6f:	68 90 12 80 00       	push   $0x801290
  800d74:	e8 d2 f3 ff ff       	call   80014b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d79:	83 c4 18             	add    $0x18,%esp
  800d7c:	53                   	push   %ebx
  800d7d:	ff 75 10             	pushl  0x10(%ebp)
  800d80:	e8 75 f3 ff ff       	call   8000fa <vcprintf>
	cprintf("\n");
  800d85:	c7 04 24 ec 0f 80 00 	movl   $0x800fec,(%esp)
  800d8c:	e8 ba f3 ff ff       	call   80014b <cprintf>
  800d91:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d94:	cc                   	int3   
  800d95:	eb fd                	jmp    800d94 <_panic+0x43>
  800d97:	66 90                	xchg   %ax,%ax
  800d99:	66 90                	xchg   %ax,%ax
  800d9b:	66 90                	xchg   %ax,%ax
  800d9d:	66 90                	xchg   %ax,%ax
  800d9f:	90                   	nop

00800da0 <__udivdi3>:
  800da0:	55                   	push   %ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 1c             	sub    $0x1c,%esp
  800da7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800daf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800db3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800db7:	85 d2                	test   %edx,%edx
  800db9:	75 35                	jne    800df0 <__udivdi3+0x50>
  800dbb:	39 f3                	cmp    %esi,%ebx
  800dbd:	0f 87 bd 00 00 00    	ja     800e80 <__udivdi3+0xe0>
  800dc3:	85 db                	test   %ebx,%ebx
  800dc5:	89 d9                	mov    %ebx,%ecx
  800dc7:	75 0b                	jne    800dd4 <__udivdi3+0x34>
  800dc9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dce:	31 d2                	xor    %edx,%edx
  800dd0:	f7 f3                	div    %ebx
  800dd2:	89 c1                	mov    %eax,%ecx
  800dd4:	31 d2                	xor    %edx,%edx
  800dd6:	89 f0                	mov    %esi,%eax
  800dd8:	f7 f1                	div    %ecx
  800dda:	89 c6                	mov    %eax,%esi
  800ddc:	89 e8                	mov    %ebp,%eax
  800dde:	89 f7                	mov    %esi,%edi
  800de0:	f7 f1                	div    %ecx
  800de2:	89 fa                	mov    %edi,%edx
  800de4:	83 c4 1c             	add    $0x1c,%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
  800dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800df0:	39 f2                	cmp    %esi,%edx
  800df2:	77 7c                	ja     800e70 <__udivdi3+0xd0>
  800df4:	0f bd fa             	bsr    %edx,%edi
  800df7:	83 f7 1f             	xor    $0x1f,%edi
  800dfa:	0f 84 98 00 00 00    	je     800e98 <__udivdi3+0xf8>
  800e00:	89 f9                	mov    %edi,%ecx
  800e02:	b8 20 00 00 00       	mov    $0x20,%eax
  800e07:	29 f8                	sub    %edi,%eax
  800e09:	d3 e2                	shl    %cl,%edx
  800e0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e0f:	89 c1                	mov    %eax,%ecx
  800e11:	89 da                	mov    %ebx,%edx
  800e13:	d3 ea                	shr    %cl,%edx
  800e15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e19:	09 d1                	or     %edx,%ecx
  800e1b:	89 f2                	mov    %esi,%edx
  800e1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e21:	89 f9                	mov    %edi,%ecx
  800e23:	d3 e3                	shl    %cl,%ebx
  800e25:	89 c1                	mov    %eax,%ecx
  800e27:	d3 ea                	shr    %cl,%edx
  800e29:	89 f9                	mov    %edi,%ecx
  800e2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e2f:	d3 e6                	shl    %cl,%esi
  800e31:	89 eb                	mov    %ebp,%ebx
  800e33:	89 c1                	mov    %eax,%ecx
  800e35:	d3 eb                	shr    %cl,%ebx
  800e37:	09 de                	or     %ebx,%esi
  800e39:	89 f0                	mov    %esi,%eax
  800e3b:	f7 74 24 08          	divl   0x8(%esp)
  800e3f:	89 d6                	mov    %edx,%esi
  800e41:	89 c3                	mov    %eax,%ebx
  800e43:	f7 64 24 0c          	mull   0xc(%esp)
  800e47:	39 d6                	cmp    %edx,%esi
  800e49:	72 0c                	jb     800e57 <__udivdi3+0xb7>
  800e4b:	89 f9                	mov    %edi,%ecx
  800e4d:	d3 e5                	shl    %cl,%ebp
  800e4f:	39 c5                	cmp    %eax,%ebp
  800e51:	73 5d                	jae    800eb0 <__udivdi3+0x110>
  800e53:	39 d6                	cmp    %edx,%esi
  800e55:	75 59                	jne    800eb0 <__udivdi3+0x110>
  800e57:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e5a:	31 ff                	xor    %edi,%edi
  800e5c:	89 fa                	mov    %edi,%edx
  800e5e:	83 c4 1c             	add    $0x1c,%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
  800e66:	8d 76 00             	lea    0x0(%esi),%esi
  800e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e70:	31 ff                	xor    %edi,%edi
  800e72:	31 c0                	xor    %eax,%eax
  800e74:	89 fa                	mov    %edi,%edx
  800e76:	83 c4 1c             	add    $0x1c,%esp
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    
  800e7e:	66 90                	xchg   %ax,%ax
  800e80:	31 ff                	xor    %edi,%edi
  800e82:	89 e8                	mov    %ebp,%eax
  800e84:	89 f2                	mov    %esi,%edx
  800e86:	f7 f3                	div    %ebx
  800e88:	89 fa                	mov    %edi,%edx
  800e8a:	83 c4 1c             	add    $0x1c,%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    
  800e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e98:	39 f2                	cmp    %esi,%edx
  800e9a:	72 06                	jb     800ea2 <__udivdi3+0x102>
  800e9c:	31 c0                	xor    %eax,%eax
  800e9e:	39 eb                	cmp    %ebp,%ebx
  800ea0:	77 d2                	ja     800e74 <__udivdi3+0xd4>
  800ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea7:	eb cb                	jmp    800e74 <__udivdi3+0xd4>
  800ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800eb0:	89 d8                	mov    %ebx,%eax
  800eb2:	31 ff                	xor    %edi,%edi
  800eb4:	eb be                	jmp    800e74 <__udivdi3+0xd4>
  800eb6:	66 90                	xchg   %ax,%ax
  800eb8:	66 90                	xchg   %ax,%ax
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

00800ec0 <__umoddi3>:
  800ec0:	55                   	push   %ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 1c             	sub    $0x1c,%esp
  800ec7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800ecb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ecf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ed3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ed7:	85 ed                	test   %ebp,%ebp
  800ed9:	89 f0                	mov    %esi,%eax
  800edb:	89 da                	mov    %ebx,%edx
  800edd:	75 19                	jne    800ef8 <__umoddi3+0x38>
  800edf:	39 df                	cmp    %ebx,%edi
  800ee1:	0f 86 b1 00 00 00    	jbe    800f98 <__umoddi3+0xd8>
  800ee7:	f7 f7                	div    %edi
  800ee9:	89 d0                	mov    %edx,%eax
  800eeb:	31 d2                	xor    %edx,%edx
  800eed:	83 c4 1c             	add    $0x1c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
  800ef5:	8d 76 00             	lea    0x0(%esi),%esi
  800ef8:	39 dd                	cmp    %ebx,%ebp
  800efa:	77 f1                	ja     800eed <__umoddi3+0x2d>
  800efc:	0f bd cd             	bsr    %ebp,%ecx
  800eff:	83 f1 1f             	xor    $0x1f,%ecx
  800f02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f06:	0f 84 b4 00 00 00    	je     800fc0 <__umoddi3+0x100>
  800f0c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f11:	89 c2                	mov    %eax,%edx
  800f13:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f17:	29 c2                	sub    %eax,%edx
  800f19:	89 c1                	mov    %eax,%ecx
  800f1b:	89 f8                	mov    %edi,%eax
  800f1d:	d3 e5                	shl    %cl,%ebp
  800f1f:	89 d1                	mov    %edx,%ecx
  800f21:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f25:	d3 e8                	shr    %cl,%eax
  800f27:	09 c5                	or     %eax,%ebp
  800f29:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f2d:	89 c1                	mov    %eax,%ecx
  800f2f:	d3 e7                	shl    %cl,%edi
  800f31:	89 d1                	mov    %edx,%ecx
  800f33:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	d3 ef                	shr    %cl,%edi
  800f3b:	89 c1                	mov    %eax,%ecx
  800f3d:	89 f0                	mov    %esi,%eax
  800f3f:	d3 e3                	shl    %cl,%ebx
  800f41:	89 d1                	mov    %edx,%ecx
  800f43:	89 fa                	mov    %edi,%edx
  800f45:	d3 e8                	shr    %cl,%eax
  800f47:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f4c:	09 d8                	or     %ebx,%eax
  800f4e:	f7 f5                	div    %ebp
  800f50:	d3 e6                	shl    %cl,%esi
  800f52:	89 d1                	mov    %edx,%ecx
  800f54:	f7 64 24 08          	mull   0x8(%esp)
  800f58:	39 d1                	cmp    %edx,%ecx
  800f5a:	89 c3                	mov    %eax,%ebx
  800f5c:	89 d7                	mov    %edx,%edi
  800f5e:	72 06                	jb     800f66 <__umoddi3+0xa6>
  800f60:	75 0e                	jne    800f70 <__umoddi3+0xb0>
  800f62:	39 c6                	cmp    %eax,%esi
  800f64:	73 0a                	jae    800f70 <__umoddi3+0xb0>
  800f66:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f6a:	19 ea                	sbb    %ebp,%edx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	89 c3                	mov    %eax,%ebx
  800f70:	89 ca                	mov    %ecx,%edx
  800f72:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f77:	29 de                	sub    %ebx,%esi
  800f79:	19 fa                	sbb    %edi,%edx
  800f7b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f7f:	89 d0                	mov    %edx,%eax
  800f81:	d3 e0                	shl    %cl,%eax
  800f83:	89 d9                	mov    %ebx,%ecx
  800f85:	d3 ee                	shr    %cl,%esi
  800f87:	d3 ea                	shr    %cl,%edx
  800f89:	09 f0                	or     %esi,%eax
  800f8b:	83 c4 1c             	add    $0x1c,%esp
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    
  800f93:	90                   	nop
  800f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f98:	85 ff                	test   %edi,%edi
  800f9a:	89 f9                	mov    %edi,%ecx
  800f9c:	75 0b                	jne    800fa9 <__umoddi3+0xe9>
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa3:	31 d2                	xor    %edx,%edx
  800fa5:	f7 f7                	div    %edi
  800fa7:	89 c1                	mov    %eax,%ecx
  800fa9:	89 d8                	mov    %ebx,%eax
  800fab:	31 d2                	xor    %edx,%edx
  800fad:	f7 f1                	div    %ecx
  800faf:	89 f0                	mov    %esi,%eax
  800fb1:	f7 f1                	div    %ecx
  800fb3:	e9 31 ff ff ff       	jmp    800ee9 <__umoddi3+0x29>
  800fb8:	90                   	nop
  800fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc0:	39 dd                	cmp    %ebx,%ebp
  800fc2:	72 08                	jb     800fcc <__umoddi3+0x10c>
  800fc4:	39 f7                	cmp    %esi,%edi
  800fc6:	0f 87 21 ff ff ff    	ja     800eed <__umoddi3+0x2d>
  800fcc:	89 da                	mov    %ebx,%edx
  800fce:	89 f0                	mov    %esi,%eax
  800fd0:	29 f8                	sub    %edi,%eax
  800fd2:	19 ea                	sbb    %ebp,%edx
  800fd4:	e9 14 ff ff ff       	jmp    800eed <__umoddi3+0x2d>
