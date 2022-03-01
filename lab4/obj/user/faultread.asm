
obj/user/faultread：     文件格式 elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 e0 0f 80 00       	push   $0x800fe0
  800044:	e8 f2 00 00 00       	call   80013b <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 f6 0a 00 00       	call   800b54 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80009a:	6a 00                	push   $0x0
  80009c:	e8 72 0a 00 00       	call   800b13 <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	53                   	push   %ebx
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b0:	8b 13                	mov    (%ebx),%edx
  8000b2:	8d 42 01             	lea    0x1(%edx),%eax
  8000b5:	89 03                	mov    %eax,(%ebx)
  8000b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000c3:	74 09                	je     8000ce <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000c5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cc:	c9                   	leave  
  8000cd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	68 ff 00 00 00       	push   $0xff
  8000d6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000d9:	50                   	push   %eax
  8000da:	e8 f7 09 00 00       	call   800ad6 <sys_cputs>
		b->idx = 0;
  8000df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	eb db                	jmp    8000c5 <putch+0x1f>

008000ea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000fa:	00 00 00 
	b.cnt = 0;
  8000fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800104:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800107:	ff 75 0c             	pushl  0xc(%ebp)
  80010a:	ff 75 08             	pushl  0x8(%ebp)
  80010d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800113:	50                   	push   %eax
  800114:	68 a6 00 80 00       	push   $0x8000a6
  800119:	e8 1a 01 00 00       	call   800238 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80011e:	83 c4 08             	add    $0x8,%esp
  800121:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800127:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 a3 09 00 00       	call   800ad6 <sys_cputs>

	return b.cnt;
}
  800133:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800141:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800144:	50                   	push   %eax
  800145:	ff 75 08             	pushl  0x8(%ebp)
  800148:	e8 9d ff ff ff       	call   8000ea <vcprintf>
	va_end(ap);

	return cnt;
}
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	57                   	push   %edi
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
  800155:	83 ec 1c             	sub    $0x1c,%esp
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800162:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800165:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800168:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80016b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800170:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800173:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800176:	39 d3                	cmp    %edx,%ebx
  800178:	72 05                	jb     80017f <printnum+0x30>
  80017a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80017d:	77 7a                	ja     8001f9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	ff 75 18             	pushl  0x18(%ebp)
  800185:	8b 45 14             	mov    0x14(%ebp),%eax
  800188:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80018b:	53                   	push   %ebx
  80018c:	ff 75 10             	pushl  0x10(%ebp)
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	ff 75 e4             	pushl  -0x1c(%ebp)
  800195:	ff 75 e0             	pushl  -0x20(%ebp)
  800198:	ff 75 dc             	pushl  -0x24(%ebp)
  80019b:	ff 75 d8             	pushl  -0x28(%ebp)
  80019e:	e8 ed 0b 00 00       	call   800d90 <__udivdi3>
  8001a3:	83 c4 18             	add    $0x18,%esp
  8001a6:	52                   	push   %edx
  8001a7:	50                   	push   %eax
  8001a8:	89 f2                	mov    %esi,%edx
  8001aa:	89 f8                	mov    %edi,%eax
  8001ac:	e8 9e ff ff ff       	call   80014f <printnum>
  8001b1:	83 c4 20             	add    $0x20,%esp
  8001b4:	eb 13                	jmp    8001c9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	56                   	push   %esi
  8001ba:	ff 75 18             	pushl  0x18(%ebp)
  8001bd:	ff d7                	call   *%edi
  8001bf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001c2:	83 eb 01             	sub    $0x1,%ebx
  8001c5:	85 db                	test   %ebx,%ebx
  8001c7:	7f ed                	jg     8001b6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	56                   	push   %esi
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8001dc:	e8 cf 0c 00 00       	call   800eb0 <__umoddi3>
  8001e1:	83 c4 14             	add    $0x14,%esp
  8001e4:	0f be 80 08 10 80 00 	movsbl 0x801008(%eax),%eax
  8001eb:	50                   	push   %eax
  8001ec:	ff d7                	call   *%edi
}
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5e                   	pop    %esi
  8001f6:	5f                   	pop    %edi
  8001f7:	5d                   	pop    %ebp
  8001f8:	c3                   	ret    
  8001f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001fc:	eb c4                	jmp    8001c2 <printnum+0x73>

008001fe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800204:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800208:	8b 10                	mov    (%eax),%edx
  80020a:	3b 50 04             	cmp    0x4(%eax),%edx
  80020d:	73 0a                	jae    800219 <sprintputch+0x1b>
		*b->buf++ = ch;
  80020f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800212:	89 08                	mov    %ecx,(%eax)
  800214:	8b 45 08             	mov    0x8(%ebp),%eax
  800217:	88 02                	mov    %al,(%edx)
}
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    

0080021b <printfmt>:
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800221:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800224:	50                   	push   %eax
  800225:	ff 75 10             	pushl  0x10(%ebp)
  800228:	ff 75 0c             	pushl  0xc(%ebp)
  80022b:	ff 75 08             	pushl  0x8(%ebp)
  80022e:	e8 05 00 00 00       	call   800238 <vprintfmt>
}
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <vprintfmt>:
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	57                   	push   %edi
  80023c:	56                   	push   %esi
  80023d:	53                   	push   %ebx
  80023e:	83 ec 2c             	sub    $0x2c,%esp
  800241:	8b 75 08             	mov    0x8(%ebp),%esi
  800244:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800247:	8b 7d 10             	mov    0x10(%ebp),%edi
  80024a:	e9 00 04 00 00       	jmp    80064f <vprintfmt+0x417>
		padc = ' ';
  80024f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800253:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80025a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800261:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800268:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80026d:	8d 47 01             	lea    0x1(%edi),%eax
  800270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800273:	0f b6 17             	movzbl (%edi),%edx
  800276:	8d 42 dd             	lea    -0x23(%edx),%eax
  800279:	3c 55                	cmp    $0x55,%al
  80027b:	0f 87 51 04 00 00    	ja     8006d2 <vprintfmt+0x49a>
  800281:	0f b6 c0             	movzbl %al,%eax
  800284:	ff 24 85 c0 10 80 00 	jmp    *0x8010c0(,%eax,4)
  80028b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80028e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800292:	eb d9                	jmp    80026d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800294:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800297:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80029b:	eb d0                	jmp    80026d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80029d:	0f b6 d2             	movzbl %dl,%edx
  8002a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ab:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002ae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002b2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002b5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002b8:	83 f9 09             	cmp    $0x9,%ecx
  8002bb:	77 55                	ja     800312 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002bd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002c0:	eb e9                	jmp    8002ab <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cd:	8d 40 04             	lea    0x4(%eax),%eax
  8002d0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002da:	79 91                	jns    80026d <vprintfmt+0x35>
				width = precision, precision = -1;
  8002dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002e9:	eb 82                	jmp    80026d <vprintfmt+0x35>
  8002eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ee:	85 c0                	test   %eax,%eax
  8002f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f5:	0f 49 d0             	cmovns %eax,%edx
  8002f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002fe:	e9 6a ff ff ff       	jmp    80026d <vprintfmt+0x35>
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800306:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80030d:	e9 5b ff ff ff       	jmp    80026d <vprintfmt+0x35>
  800312:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800315:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800318:	eb bc                	jmp    8002d6 <vprintfmt+0x9e>
			lflag++;
  80031a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800320:	e9 48 ff ff ff       	jmp    80026d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800325:	8b 45 14             	mov    0x14(%ebp),%eax
  800328:	8d 78 04             	lea    0x4(%eax),%edi
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	53                   	push   %ebx
  80032f:	ff 30                	pushl  (%eax)
  800331:	ff d6                	call   *%esi
			break;
  800333:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800336:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800339:	e9 0e 03 00 00       	jmp    80064c <vprintfmt+0x414>
			err = va_arg(ap, int);
  80033e:	8b 45 14             	mov    0x14(%ebp),%eax
  800341:	8d 78 04             	lea    0x4(%eax),%edi
  800344:	8b 00                	mov    (%eax),%eax
  800346:	99                   	cltd   
  800347:	31 d0                	xor    %edx,%eax
  800349:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80034b:	83 f8 08             	cmp    $0x8,%eax
  80034e:	7f 23                	jg     800373 <vprintfmt+0x13b>
  800350:	8b 14 85 20 12 80 00 	mov    0x801220(,%eax,4),%edx
  800357:	85 d2                	test   %edx,%edx
  800359:	74 18                	je     800373 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80035b:	52                   	push   %edx
  80035c:	68 29 10 80 00       	push   $0x801029
  800361:	53                   	push   %ebx
  800362:	56                   	push   %esi
  800363:	e8 b3 fe ff ff       	call   80021b <printfmt>
  800368:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80036b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80036e:	e9 d9 02 00 00       	jmp    80064c <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800373:	50                   	push   %eax
  800374:	68 20 10 80 00       	push   $0x801020
  800379:	53                   	push   %ebx
  80037a:	56                   	push   %esi
  80037b:	e8 9b fe ff ff       	call   80021b <printfmt>
  800380:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800386:	e9 c1 02 00 00       	jmp    80064c <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80038b:	8b 45 14             	mov    0x14(%ebp),%eax
  80038e:	83 c0 04             	add    $0x4,%eax
  800391:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800399:	85 ff                	test   %edi,%edi
  80039b:	b8 19 10 80 00       	mov    $0x801019,%eax
  8003a0:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a7:	0f 8e bd 00 00 00    	jle    80046a <vprintfmt+0x232>
  8003ad:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003b1:	75 0e                	jne    8003c1 <vprintfmt+0x189>
  8003b3:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003b9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003bc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003bf:	eb 6d                	jmp    80042e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003c7:	57                   	push   %edi
  8003c8:	e8 ad 03 00 00       	call   80077a <strnlen>
  8003cd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003d0:	29 c1                	sub    %eax,%ecx
  8003d2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003d5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003d8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003df:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003e2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e4:	eb 0f                	jmp    8003f5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	53                   	push   %ebx
  8003ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ed:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ef:	83 ef 01             	sub    $0x1,%edi
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	85 ff                	test   %edi,%edi
  8003f7:	7f ed                	jg     8003e6 <vprintfmt+0x1ae>
  8003f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8003fc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003ff:	85 c9                	test   %ecx,%ecx
  800401:	b8 00 00 00 00       	mov    $0x0,%eax
  800406:	0f 49 c1             	cmovns %ecx,%eax
  800409:	29 c1                	sub    %eax,%ecx
  80040b:	89 75 08             	mov    %esi,0x8(%ebp)
  80040e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800411:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800414:	89 cb                	mov    %ecx,%ebx
  800416:	eb 16                	jmp    80042e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800418:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80041c:	75 31                	jne    80044f <vprintfmt+0x217>
					putch(ch, putdat);
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	ff 75 0c             	pushl  0xc(%ebp)
  800424:	50                   	push   %eax
  800425:	ff 55 08             	call   *0x8(%ebp)
  800428:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80042b:	83 eb 01             	sub    $0x1,%ebx
  80042e:	83 c7 01             	add    $0x1,%edi
  800431:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800435:	0f be c2             	movsbl %dl,%eax
  800438:	85 c0                	test   %eax,%eax
  80043a:	74 59                	je     800495 <vprintfmt+0x25d>
  80043c:	85 f6                	test   %esi,%esi
  80043e:	78 d8                	js     800418 <vprintfmt+0x1e0>
  800440:	83 ee 01             	sub    $0x1,%esi
  800443:	79 d3                	jns    800418 <vprintfmt+0x1e0>
  800445:	89 df                	mov    %ebx,%edi
  800447:	8b 75 08             	mov    0x8(%ebp),%esi
  80044a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80044d:	eb 37                	jmp    800486 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80044f:	0f be d2             	movsbl %dl,%edx
  800452:	83 ea 20             	sub    $0x20,%edx
  800455:	83 fa 5e             	cmp    $0x5e,%edx
  800458:	76 c4                	jbe    80041e <vprintfmt+0x1e6>
					putch('?', putdat);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	6a 3f                	push   $0x3f
  800462:	ff 55 08             	call   *0x8(%ebp)
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	eb c1                	jmp    80042b <vprintfmt+0x1f3>
  80046a:	89 75 08             	mov    %esi,0x8(%ebp)
  80046d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800470:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800473:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800476:	eb b6                	jmp    80042e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	53                   	push   %ebx
  80047c:	6a 20                	push   $0x20
  80047e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800480:	83 ef 01             	sub    $0x1,%edi
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	85 ff                	test   %edi,%edi
  800488:	7f ee                	jg     800478 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80048a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80048d:	89 45 14             	mov    %eax,0x14(%ebp)
  800490:	e9 b7 01 00 00       	jmp    80064c <vprintfmt+0x414>
  800495:	89 df                	mov    %ebx,%edi
  800497:	8b 75 08             	mov    0x8(%ebp),%esi
  80049a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80049d:	eb e7                	jmp    800486 <vprintfmt+0x24e>
	if (lflag >= 2)
  80049f:	83 f9 01             	cmp    $0x1,%ecx
  8004a2:	7e 3f                	jle    8004e3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8b 50 04             	mov    0x4(%eax),%edx
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8d 40 08             	lea    0x8(%eax),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004bf:	79 5c                	jns    80051d <vprintfmt+0x2e5>
				putch('-', putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	6a 2d                	push   $0x2d
  8004c7:	ff d6                	call   *%esi
				num = -(long long) num;
  8004c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004cc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004cf:	f7 da                	neg    %edx
  8004d1:	83 d1 00             	adc    $0x0,%ecx
  8004d4:	f7 d9                	neg    %ecx
  8004d6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004de:	e9 4f 01 00 00       	jmp    800632 <vprintfmt+0x3fa>
	else if (lflag)
  8004e3:	85 c9                	test   %ecx,%ecx
  8004e5:	75 1b                	jne    800502 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ef:	89 c1                	mov    %eax,%ecx
  8004f1:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 40 04             	lea    0x4(%eax),%eax
  8004fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800500:	eb b9                	jmp    8004bb <vprintfmt+0x283>
		return va_arg(*ap, long);
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050a:	89 c1                	mov    %eax,%ecx
  80050c:	c1 f9 1f             	sar    $0x1f,%ecx
  80050f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 40 04             	lea    0x4(%eax),%eax
  800518:	89 45 14             	mov    %eax,0x14(%ebp)
  80051b:	eb 9e                	jmp    8004bb <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80051d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800520:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800523:	b8 0a 00 00 00       	mov    $0xa,%eax
  800528:	e9 05 01 00 00       	jmp    800632 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80052d:	83 f9 01             	cmp    $0x1,%ecx
  800530:	7e 18                	jle    80054a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8b 10                	mov    (%eax),%edx
  800537:	8b 48 04             	mov    0x4(%eax),%ecx
  80053a:	8d 40 08             	lea    0x8(%eax),%eax
  80053d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800540:	b8 0a 00 00 00       	mov    $0xa,%eax
  800545:	e9 e8 00 00 00       	jmp    800632 <vprintfmt+0x3fa>
	else if (lflag)
  80054a:	85 c9                	test   %ecx,%ecx
  80054c:	75 1a                	jne    800568 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 10                	mov    (%eax),%edx
  800553:	b9 00 00 00 00       	mov    $0x0,%ecx
  800558:	8d 40 04             	lea    0x4(%eax),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80055e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800563:	e9 ca 00 00 00       	jmp    800632 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 10                	mov    (%eax),%edx
  80056d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800578:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057d:	e9 b0 00 00 00       	jmp    800632 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800582:	83 f9 01             	cmp    $0x1,%ecx
  800585:	7e 3c                	jle    8005c3 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 50 04             	mov    0x4(%eax),%edx
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 08             	lea    0x8(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80059e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a2:	79 59                	jns    8005fd <vprintfmt+0x3c5>
                putch('-', putdat);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	53                   	push   %ebx
  8005a8:	6a 2d                	push   $0x2d
  8005aa:	ff d6                	call   *%esi
                num = -(long long) num;
  8005ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b2:	f7 da                	neg    %edx
  8005b4:	83 d1 00             	adc    $0x0,%ecx
  8005b7:	f7 d9                	neg    %ecx
  8005b9:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c1:	eb 6f                	jmp    800632 <vprintfmt+0x3fa>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	75 1b                	jne    8005e2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 c1                	mov    %eax,%ecx
  8005d1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	eb bc                	jmp    80059e <vprintfmt+0x366>
		return va_arg(*ap, long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ea:	89 c1                	mov    %eax,%ecx
  8005ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fb:	eb a1                	jmp    80059e <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8005fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800600:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800603:	b8 08 00 00 00       	mov    $0x8,%eax
  800608:	eb 28                	jmp    800632 <vprintfmt+0x3fa>
			putch('0', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 30                	push   $0x30
  800610:	ff d6                	call   *%esi
			putch('x', putdat);
  800612:	83 c4 08             	add    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	6a 78                	push   $0x78
  800618:	ff d6                	call   *%esi
			num = (unsigned long long)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800624:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800639:	57                   	push   %edi
  80063a:	ff 75 e0             	pushl  -0x20(%ebp)
  80063d:	50                   	push   %eax
  80063e:	51                   	push   %ecx
  80063f:	52                   	push   %edx
  800640:	89 da                	mov    %ebx,%edx
  800642:	89 f0                	mov    %esi,%eax
  800644:	e8 06 fb ff ff       	call   80014f <printnum>
			break;
  800649:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80064c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	83 c7 01             	add    $0x1,%edi
  800652:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800656:	83 f8 25             	cmp    $0x25,%eax
  800659:	0f 84 f0 fb ff ff    	je     80024f <vprintfmt+0x17>
			if (ch == '\0')
  80065f:	85 c0                	test   %eax,%eax
  800661:	0f 84 8b 00 00 00    	je     8006f2 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	50                   	push   %eax
  80066c:	ff d6                	call   *%esi
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	eb dc                	jmp    80064f <vprintfmt+0x417>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7e 15                	jle    80068d <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 10                	mov    (%eax),%edx
  80067d:	8b 48 04             	mov    0x4(%eax),%ecx
  800680:	8d 40 08             	lea    0x8(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800686:	b8 10 00 00 00       	mov    $0x10,%eax
  80068b:	eb a5                	jmp    800632 <vprintfmt+0x3fa>
	else if (lflag)
  80068d:	85 c9                	test   %ecx,%ecx
  80068f:	75 17                	jne    8006a8 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a6:	eb 8a                	jmp    800632 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bd:	e9 70 ff ff ff       	jmp    800632 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	6a 25                	push   $0x25
  8006c8:	ff d6                	call   *%esi
			break;
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	e9 7a ff ff ff       	jmp    80064c <vprintfmt+0x414>
			putch('%', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 25                	push   $0x25
  8006d8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	89 f8                	mov    %edi,%eax
  8006df:	eb 03                	jmp    8006e4 <vprintfmt+0x4ac>
  8006e1:	83 e8 01             	sub    $0x1,%eax
  8006e4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e8:	75 f7                	jne    8006e1 <vprintfmt+0x4a9>
  8006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ed:	e9 5a ff ff ff       	jmp    80064c <vprintfmt+0x414>
}
  8006f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f5:	5b                   	pop    %ebx
  8006f6:	5e                   	pop    %esi
  8006f7:	5f                   	pop    %edi
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    

008006fa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 18             	sub    $0x18,%esp
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800706:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800709:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80070d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800710:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800717:	85 c0                	test   %eax,%eax
  800719:	74 26                	je     800741 <vsnprintf+0x47>
  80071b:	85 d2                	test   %edx,%edx
  80071d:	7e 22                	jle    800741 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071f:	ff 75 14             	pushl  0x14(%ebp)
  800722:	ff 75 10             	pushl  0x10(%ebp)
  800725:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	68 fe 01 80 00       	push   $0x8001fe
  80072e:	e8 05 fb ff ff       	call   800238 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800736:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073c:	83 c4 10             	add    $0x10,%esp
}
  80073f:	c9                   	leave  
  800740:	c3                   	ret    
		return -E_INVAL;
  800741:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800746:	eb f7                	jmp    80073f <vsnprintf+0x45>

00800748 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80074e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800751:	50                   	push   %eax
  800752:	ff 75 10             	pushl  0x10(%ebp)
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	ff 75 08             	pushl  0x8(%ebp)
  80075b:	e8 9a ff ff ff       	call   8006fa <vsnprintf>
	va_end(ap);

	return rc;
}
  800760:	c9                   	leave  
  800761:	c3                   	ret    

00800762 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
  80076d:	eb 03                	jmp    800772 <strlen+0x10>
		n++;
  80076f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800772:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800776:	75 f7                	jne    80076f <strlen+0xd>
	return n;
}
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800780:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800783:	b8 00 00 00 00       	mov    $0x0,%eax
  800788:	eb 03                	jmp    80078d <strnlen+0x13>
		n++;
  80078a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078d:	39 d0                	cmp    %edx,%eax
  80078f:	74 06                	je     800797 <strnlen+0x1d>
  800791:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800795:	75 f3                	jne    80078a <strnlen+0x10>
	return n;
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a3:	89 c2                	mov    %eax,%edx
  8007a5:	83 c1 01             	add    $0x1,%ecx
  8007a8:	83 c2 01             	add    $0x1,%edx
  8007ab:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007af:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b2:	84 db                	test   %bl,%bl
  8007b4:	75 ef                	jne    8007a5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b6:	5b                   	pop    %ebx
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	53                   	push   %ebx
  8007bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c0:	53                   	push   %ebx
  8007c1:	e8 9c ff ff ff       	call   800762 <strlen>
  8007c6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	01 d8                	add    %ebx,%eax
  8007ce:	50                   	push   %eax
  8007cf:	e8 c5 ff ff ff       	call   800799 <strcpy>
	return dst;
}
  8007d4:	89 d8                	mov    %ebx,%eax
  8007d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    

008007db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	56                   	push   %esi
  8007df:	53                   	push   %ebx
  8007e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e6:	89 f3                	mov    %esi,%ebx
  8007e8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007eb:	89 f2                	mov    %esi,%edx
  8007ed:	eb 0f                	jmp    8007fe <strncpy+0x23>
		*dst++ = *src;
  8007ef:	83 c2 01             	add    $0x1,%edx
  8007f2:	0f b6 01             	movzbl (%ecx),%eax
  8007f5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f8:	80 39 01             	cmpb   $0x1,(%ecx)
  8007fb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007fe:	39 da                	cmp    %ebx,%edx
  800800:	75 ed                	jne    8007ef <strncpy+0x14>
	}
	return ret;
}
  800802:	89 f0                	mov    %esi,%eax
  800804:	5b                   	pop    %ebx
  800805:	5e                   	pop    %esi
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	56                   	push   %esi
  80080c:	53                   	push   %ebx
  80080d:	8b 75 08             	mov    0x8(%ebp),%esi
  800810:	8b 55 0c             	mov    0xc(%ebp),%edx
  800813:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800816:	89 f0                	mov    %esi,%eax
  800818:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80081c:	85 c9                	test   %ecx,%ecx
  80081e:	75 0b                	jne    80082b <strlcpy+0x23>
  800820:	eb 17                	jmp    800839 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800822:	83 c2 01             	add    $0x1,%edx
  800825:	83 c0 01             	add    $0x1,%eax
  800828:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80082b:	39 d8                	cmp    %ebx,%eax
  80082d:	74 07                	je     800836 <strlcpy+0x2e>
  80082f:	0f b6 0a             	movzbl (%edx),%ecx
  800832:	84 c9                	test   %cl,%cl
  800834:	75 ec                	jne    800822 <strlcpy+0x1a>
		*dst = '\0';
  800836:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800839:	29 f0                	sub    %esi,%eax
}
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5d                   	pop    %ebp
  80083e:	c3                   	ret    

0080083f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800845:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800848:	eb 06                	jmp    800850 <strcmp+0x11>
		p++, q++;
  80084a:	83 c1 01             	add    $0x1,%ecx
  80084d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800850:	0f b6 01             	movzbl (%ecx),%eax
  800853:	84 c0                	test   %al,%al
  800855:	74 04                	je     80085b <strcmp+0x1c>
  800857:	3a 02                	cmp    (%edx),%al
  800859:	74 ef                	je     80084a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80085b:	0f b6 c0             	movzbl %al,%eax
  80085e:	0f b6 12             	movzbl (%edx),%edx
  800861:	29 d0                	sub    %edx,%eax
}
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	53                   	push   %ebx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086f:	89 c3                	mov    %eax,%ebx
  800871:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800874:	eb 06                	jmp    80087c <strncmp+0x17>
		n--, p++, q++;
  800876:	83 c0 01             	add    $0x1,%eax
  800879:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80087c:	39 d8                	cmp    %ebx,%eax
  80087e:	74 16                	je     800896 <strncmp+0x31>
  800880:	0f b6 08             	movzbl (%eax),%ecx
  800883:	84 c9                	test   %cl,%cl
  800885:	74 04                	je     80088b <strncmp+0x26>
  800887:	3a 0a                	cmp    (%edx),%cl
  800889:	74 eb                	je     800876 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80088b:	0f b6 00             	movzbl (%eax),%eax
  80088e:	0f b6 12             	movzbl (%edx),%edx
  800891:	29 d0                	sub    %edx,%eax
}
  800893:	5b                   	pop    %ebx
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    
		return 0;
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	eb f6                	jmp    800893 <strncmp+0x2e>

0080089d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a7:	0f b6 10             	movzbl (%eax),%edx
  8008aa:	84 d2                	test   %dl,%dl
  8008ac:	74 09                	je     8008b7 <strchr+0x1a>
		if (*s == c)
  8008ae:	38 ca                	cmp    %cl,%dl
  8008b0:	74 0a                	je     8008bc <strchr+0x1f>
	for (; *s; s++)
  8008b2:	83 c0 01             	add    $0x1,%eax
  8008b5:	eb f0                	jmp    8008a7 <strchr+0xa>
			return (char *) s;
	return 0;
  8008b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c8:	eb 03                	jmp    8008cd <strfind+0xf>
  8008ca:	83 c0 01             	add    $0x1,%eax
  8008cd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d0:	38 ca                	cmp    %cl,%dl
  8008d2:	74 04                	je     8008d8 <strfind+0x1a>
  8008d4:	84 d2                	test   %dl,%dl
  8008d6:	75 f2                	jne    8008ca <strfind+0xc>
			break;
	return (char *) s;
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	57                   	push   %edi
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
  8008e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e6:	85 c9                	test   %ecx,%ecx
  8008e8:	74 13                	je     8008fd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ea:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f0:	75 05                	jne    8008f7 <memset+0x1d>
  8008f2:	f6 c1 03             	test   $0x3,%cl
  8008f5:	74 0d                	je     800904 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	fc                   	cld    
  8008fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008fd:	89 f8                	mov    %edi,%eax
  8008ff:	5b                   	pop    %ebx
  800900:	5e                   	pop    %esi
  800901:	5f                   	pop    %edi
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    
		c &= 0xFF;
  800904:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800908:	89 d3                	mov    %edx,%ebx
  80090a:	c1 e3 08             	shl    $0x8,%ebx
  80090d:	89 d0                	mov    %edx,%eax
  80090f:	c1 e0 18             	shl    $0x18,%eax
  800912:	89 d6                	mov    %edx,%esi
  800914:	c1 e6 10             	shl    $0x10,%esi
  800917:	09 f0                	or     %esi,%eax
  800919:	09 c2                	or     %eax,%edx
  80091b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80091d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800920:	89 d0                	mov    %edx,%eax
  800922:	fc                   	cld    
  800923:	f3 ab                	rep stos %eax,%es:(%edi)
  800925:	eb d6                	jmp    8008fd <memset+0x23>

00800927 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	57                   	push   %edi
  80092b:	56                   	push   %esi
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800932:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800935:	39 c6                	cmp    %eax,%esi
  800937:	73 35                	jae    80096e <memmove+0x47>
  800939:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80093c:	39 c2                	cmp    %eax,%edx
  80093e:	76 2e                	jbe    80096e <memmove+0x47>
		s += n;
		d += n;
  800940:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800943:	89 d6                	mov    %edx,%esi
  800945:	09 fe                	or     %edi,%esi
  800947:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80094d:	74 0c                	je     80095b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80094f:	83 ef 01             	sub    $0x1,%edi
  800952:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800955:	fd                   	std    
  800956:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800958:	fc                   	cld    
  800959:	eb 21                	jmp    80097c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095b:	f6 c1 03             	test   $0x3,%cl
  80095e:	75 ef                	jne    80094f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800960:	83 ef 04             	sub    $0x4,%edi
  800963:	8d 72 fc             	lea    -0x4(%edx),%esi
  800966:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800969:	fd                   	std    
  80096a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096c:	eb ea                	jmp    800958 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096e:	89 f2                	mov    %esi,%edx
  800970:	09 c2                	or     %eax,%edx
  800972:	f6 c2 03             	test   $0x3,%dl
  800975:	74 09                	je     800980 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800977:	89 c7                	mov    %eax,%edi
  800979:	fc                   	cld    
  80097a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80097c:	5e                   	pop    %esi
  80097d:	5f                   	pop    %edi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800980:	f6 c1 03             	test   $0x3,%cl
  800983:	75 f2                	jne    800977 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800985:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800988:	89 c7                	mov    %eax,%edi
  80098a:	fc                   	cld    
  80098b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098d:	eb ed                	jmp    80097c <memmove+0x55>

0080098f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800992:	ff 75 10             	pushl  0x10(%ebp)
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	ff 75 08             	pushl  0x8(%ebp)
  80099b:	e8 87 ff ff ff       	call   800927 <memmove>
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	56                   	push   %esi
  8009a6:	53                   	push   %ebx
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 c6                	mov    %eax,%esi
  8009af:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b2:	39 f0                	cmp    %esi,%eax
  8009b4:	74 1c                	je     8009d2 <memcmp+0x30>
		if (*s1 != *s2)
  8009b6:	0f b6 08             	movzbl (%eax),%ecx
  8009b9:	0f b6 1a             	movzbl (%edx),%ebx
  8009bc:	38 d9                	cmp    %bl,%cl
  8009be:	75 08                	jne    8009c8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c0:	83 c0 01             	add    $0x1,%eax
  8009c3:	83 c2 01             	add    $0x1,%edx
  8009c6:	eb ea                	jmp    8009b2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009c8:	0f b6 c1             	movzbl %cl,%eax
  8009cb:	0f b6 db             	movzbl %bl,%ebx
  8009ce:	29 d8                	sub    %ebx,%eax
  8009d0:	eb 05                	jmp    8009d7 <memcmp+0x35>
	}

	return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5e                   	pop    %esi
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e9:	39 d0                	cmp    %edx,%eax
  8009eb:	73 09                	jae    8009f6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ed:	38 08                	cmp    %cl,(%eax)
  8009ef:	74 05                	je     8009f6 <memfind+0x1b>
	for (; s < ends; s++)
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	eb f3                	jmp    8009e9 <memfind+0xe>
			break;
	return (void *) s;
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	57                   	push   %edi
  8009fc:	56                   	push   %esi
  8009fd:	53                   	push   %ebx
  8009fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a04:	eb 03                	jmp    800a09 <strtol+0x11>
		s++;
  800a06:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a09:	0f b6 01             	movzbl (%ecx),%eax
  800a0c:	3c 20                	cmp    $0x20,%al
  800a0e:	74 f6                	je     800a06 <strtol+0xe>
  800a10:	3c 09                	cmp    $0x9,%al
  800a12:	74 f2                	je     800a06 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a14:	3c 2b                	cmp    $0x2b,%al
  800a16:	74 2e                	je     800a46 <strtol+0x4e>
	int neg = 0;
  800a18:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a1d:	3c 2d                	cmp    $0x2d,%al
  800a1f:	74 2f                	je     800a50 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a21:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a27:	75 05                	jne    800a2e <strtol+0x36>
  800a29:	80 39 30             	cmpb   $0x30,(%ecx)
  800a2c:	74 2c                	je     800a5a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a2e:	85 db                	test   %ebx,%ebx
  800a30:	75 0a                	jne    800a3c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a32:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a37:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3a:	74 28                	je     800a64 <strtol+0x6c>
		base = 10;
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a41:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a44:	eb 50                	jmp    800a96 <strtol+0x9e>
		s++;
  800a46:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a49:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4e:	eb d1                	jmp    800a21 <strtol+0x29>
		s++, neg = 1;
  800a50:	83 c1 01             	add    $0x1,%ecx
  800a53:	bf 01 00 00 00       	mov    $0x1,%edi
  800a58:	eb c7                	jmp    800a21 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a5e:	74 0e                	je     800a6e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a60:	85 db                	test   %ebx,%ebx
  800a62:	75 d8                	jne    800a3c <strtol+0x44>
		s++, base = 8;
  800a64:	83 c1 01             	add    $0x1,%ecx
  800a67:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a6c:	eb ce                	jmp    800a3c <strtol+0x44>
		s += 2, base = 16;
  800a6e:	83 c1 02             	add    $0x2,%ecx
  800a71:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a76:	eb c4                	jmp    800a3c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a78:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a7b:	89 f3                	mov    %esi,%ebx
  800a7d:	80 fb 19             	cmp    $0x19,%bl
  800a80:	77 29                	ja     800aab <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a82:	0f be d2             	movsbl %dl,%edx
  800a85:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a88:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a8b:	7d 30                	jge    800abd <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a8d:	83 c1 01             	add    $0x1,%ecx
  800a90:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a94:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a96:	0f b6 11             	movzbl (%ecx),%edx
  800a99:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a9c:	89 f3                	mov    %esi,%ebx
  800a9e:	80 fb 09             	cmp    $0x9,%bl
  800aa1:	77 d5                	ja     800a78 <strtol+0x80>
			dig = *s - '0';
  800aa3:	0f be d2             	movsbl %dl,%edx
  800aa6:	83 ea 30             	sub    $0x30,%edx
  800aa9:	eb dd                	jmp    800a88 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800aab:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aae:	89 f3                	mov    %esi,%ebx
  800ab0:	80 fb 19             	cmp    $0x19,%bl
  800ab3:	77 08                	ja     800abd <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab5:	0f be d2             	movsbl %dl,%edx
  800ab8:	83 ea 37             	sub    $0x37,%edx
  800abb:	eb cb                	jmp    800a88 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800abd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac1:	74 05                	je     800ac8 <strtol+0xd0>
		*endptr = (char *) s;
  800ac3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	f7 da                	neg    %edx
  800acc:	85 ff                	test   %edi,%edi
  800ace:	0f 45 c2             	cmovne %edx,%eax
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae7:	89 c3                	mov    %eax,%ebx
  800ae9:	89 c7                	mov    %eax,%edi
  800aeb:	89 c6                	mov    %eax,%esi
  800aed:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <sys_cgetc>:

int
sys_cgetc(void) {
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800afa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aff:	b8 01 00 00 00       	mov    $0x1,%eax
  800b04:	89 d1                	mov    %edx,%ecx
  800b06:	89 d3                	mov    %edx,%ebx
  800b08:	89 d7                	mov    %edx,%edi
  800b0a:	89 d6                	mov    %edx,%esi
  800b0c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5f                   	pop    %edi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b21:	8b 55 08             	mov    0x8(%ebp),%edx
  800b24:	b8 03 00 00 00       	mov    $0x3,%eax
  800b29:	89 cb                	mov    %ecx,%ebx
  800b2b:	89 cf                	mov    %ecx,%edi
  800b2d:	89 ce                	mov    %ecx,%esi
  800b2f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b31:	85 c0                	test   %eax,%eax
  800b33:	7f 08                	jg     800b3d <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b3d:	83 ec 0c             	sub    $0xc,%esp
  800b40:	50                   	push   %eax
  800b41:	6a 03                	push   $0x3
  800b43:	68 44 12 80 00       	push   $0x801244
  800b48:	6a 24                	push   $0x24
  800b4a:	68 61 12 80 00       	push   $0x801261
  800b4f:	e8 ed 01 00 00       	call   800d41 <_panic>

00800b54 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5f:	b8 02 00 00 00       	mov    $0x2,%eax
  800b64:	89 d1                	mov    %edx,%ecx
  800b66:	89 d3                	mov    %edx,%ebx
  800b68:	89 d7                	mov    %edx,%edi
  800b6a:	89 d6                	mov    %edx,%esi
  800b6c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <sys_yield>:

void
sys_yield(void)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b79:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b83:	89 d1                	mov    %edx,%ecx
  800b85:	89 d3                	mov    %edx,%ebx
  800b87:	89 d7                	mov    %edx,%edi
  800b89:	89 d6                	mov    %edx,%esi
  800b8b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b9b:	be 00 00 00 00       	mov    $0x0,%esi
  800ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba6:	b8 04 00 00 00       	mov    $0x4,%eax
  800bab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bae:	89 f7                	mov    %esi,%edi
  800bb0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bb2:	85 c0                	test   %eax,%eax
  800bb4:	7f 08                	jg     800bbe <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5f                   	pop    %edi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bbe:	83 ec 0c             	sub    $0xc,%esp
  800bc1:	50                   	push   %eax
  800bc2:	6a 04                	push   $0x4
  800bc4:	68 44 12 80 00       	push   $0x801244
  800bc9:	6a 24                	push   $0x24
  800bcb:	68 61 12 80 00       	push   $0x801261
  800bd0:	e8 6c 01 00 00       	call   800d41 <_panic>

00800bd5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bde:	8b 55 08             	mov    0x8(%ebp),%edx
  800be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be4:	b8 05 00 00 00       	mov    $0x5,%eax
  800be9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bec:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bef:	8b 75 18             	mov    0x18(%ebp),%esi
  800bf2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	7f 08                	jg     800c00 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c00:	83 ec 0c             	sub    $0xc,%esp
  800c03:	50                   	push   %eax
  800c04:	6a 05                	push   $0x5
  800c06:	68 44 12 80 00       	push   $0x801244
  800c0b:	6a 24                	push   $0x24
  800c0d:	68 61 12 80 00       	push   $0x801261
  800c12:	e8 2a 01 00 00       	call   800d41 <_panic>

00800c17 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c30:	89 df                	mov    %ebx,%edi
  800c32:	89 de                	mov    %ebx,%esi
  800c34:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c36:	85 c0                	test   %eax,%eax
  800c38:	7f 08                	jg     800c42 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c42:	83 ec 0c             	sub    $0xc,%esp
  800c45:	50                   	push   %eax
  800c46:	6a 06                	push   $0x6
  800c48:	68 44 12 80 00       	push   $0x801244
  800c4d:	6a 24                	push   $0x24
  800c4f:	68 61 12 80 00       	push   $0x801261
  800c54:	e8 e8 00 00 00       	call   800d41 <_panic>

00800c59 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c72:	89 df                	mov    %ebx,%edi
  800c74:	89 de                	mov    %ebx,%esi
  800c76:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	7f 08                	jg     800c84 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c84:	83 ec 0c             	sub    $0xc,%esp
  800c87:	50                   	push   %eax
  800c88:	6a 08                	push   $0x8
  800c8a:	68 44 12 80 00       	push   $0x801244
  800c8f:	6a 24                	push   $0x24
  800c91:	68 61 12 80 00       	push   $0x801261
  800c96:	e8 a6 00 00 00       	call   800d41 <_panic>

00800c9b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 09 00 00 00       	mov    $0x9,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800cca:	6a 09                	push   $0x9
  800ccc:	68 44 12 80 00       	push   $0x801244
  800cd1:	6a 24                	push   $0x24
  800cd3:	68 61 12 80 00       	push   $0x801261
  800cd8:	e8 64 00 00 00       	call   800d41 <_panic>

00800cdd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cee:	be 00 00 00 00       	mov    $0x0,%esi
  800cf3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d09:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d16:	89 cb                	mov    %ecx,%ebx
  800d18:	89 cf                	mov    %ecx,%edi
  800d1a:	89 ce                	mov    %ecx,%esi
  800d1c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	7f 08                	jg     800d2a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	83 ec 0c             	sub    $0xc,%esp
  800d2d:	50                   	push   %eax
  800d2e:	6a 0c                	push   $0xc
  800d30:	68 44 12 80 00       	push   $0x801244
  800d35:	6a 24                	push   $0x24
  800d37:	68 61 12 80 00       	push   $0x801261
  800d3c:	e8 00 00 00 00       	call   800d41 <_panic>

00800d41 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d46:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d49:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d4f:	e8 00 fe ff ff       	call   800b54 <sys_getenvid>
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	ff 75 08             	pushl  0x8(%ebp)
  800d5d:	56                   	push   %esi
  800d5e:	50                   	push   %eax
  800d5f:	68 70 12 80 00       	push   $0x801270
  800d64:	e8 d2 f3 ff ff       	call   80013b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d69:	83 c4 18             	add    $0x18,%esp
  800d6c:	53                   	push   %ebx
  800d6d:	ff 75 10             	pushl  0x10(%ebp)
  800d70:	e8 75 f3 ff ff       	call   8000ea <vcprintf>
	cprintf("\n");
  800d75:	c7 04 24 fc 0f 80 00 	movl   $0x800ffc,(%esp)
  800d7c:	e8 ba f3 ff ff       	call   80013b <cprintf>
  800d81:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d84:	cc                   	int3   
  800d85:	eb fd                	jmp    800d84 <_panic+0x43>
  800d87:	66 90                	xchg   %ax,%ax
  800d89:	66 90                	xchg   %ax,%ax
  800d8b:	66 90                	xchg   %ax,%ax
  800d8d:	66 90                	xchg   %ax,%ax
  800d8f:	90                   	nop

00800d90 <__udivdi3>:
  800d90:	55                   	push   %ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 1c             	sub    $0x1c,%esp
  800d97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800da3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800da7:	85 d2                	test   %edx,%edx
  800da9:	75 35                	jne    800de0 <__udivdi3+0x50>
  800dab:	39 f3                	cmp    %esi,%ebx
  800dad:	0f 87 bd 00 00 00    	ja     800e70 <__udivdi3+0xe0>
  800db3:	85 db                	test   %ebx,%ebx
  800db5:	89 d9                	mov    %ebx,%ecx
  800db7:	75 0b                	jne    800dc4 <__udivdi3+0x34>
  800db9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dbe:	31 d2                	xor    %edx,%edx
  800dc0:	f7 f3                	div    %ebx
  800dc2:	89 c1                	mov    %eax,%ecx
  800dc4:	31 d2                	xor    %edx,%edx
  800dc6:	89 f0                	mov    %esi,%eax
  800dc8:	f7 f1                	div    %ecx
  800dca:	89 c6                	mov    %eax,%esi
  800dcc:	89 e8                	mov    %ebp,%eax
  800dce:	89 f7                	mov    %esi,%edi
  800dd0:	f7 f1                	div    %ecx
  800dd2:	89 fa                	mov    %edi,%edx
  800dd4:	83 c4 1c             	add    $0x1c,%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
  800ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800de0:	39 f2                	cmp    %esi,%edx
  800de2:	77 7c                	ja     800e60 <__udivdi3+0xd0>
  800de4:	0f bd fa             	bsr    %edx,%edi
  800de7:	83 f7 1f             	xor    $0x1f,%edi
  800dea:	0f 84 98 00 00 00    	je     800e88 <__udivdi3+0xf8>
  800df0:	89 f9                	mov    %edi,%ecx
  800df2:	b8 20 00 00 00       	mov    $0x20,%eax
  800df7:	29 f8                	sub    %edi,%eax
  800df9:	d3 e2                	shl    %cl,%edx
  800dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dff:	89 c1                	mov    %eax,%ecx
  800e01:	89 da                	mov    %ebx,%edx
  800e03:	d3 ea                	shr    %cl,%edx
  800e05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e09:	09 d1                	or     %edx,%ecx
  800e0b:	89 f2                	mov    %esi,%edx
  800e0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e11:	89 f9                	mov    %edi,%ecx
  800e13:	d3 e3                	shl    %cl,%ebx
  800e15:	89 c1                	mov    %eax,%ecx
  800e17:	d3 ea                	shr    %cl,%edx
  800e19:	89 f9                	mov    %edi,%ecx
  800e1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e1f:	d3 e6                	shl    %cl,%esi
  800e21:	89 eb                	mov    %ebp,%ebx
  800e23:	89 c1                	mov    %eax,%ecx
  800e25:	d3 eb                	shr    %cl,%ebx
  800e27:	09 de                	or     %ebx,%esi
  800e29:	89 f0                	mov    %esi,%eax
  800e2b:	f7 74 24 08          	divl   0x8(%esp)
  800e2f:	89 d6                	mov    %edx,%esi
  800e31:	89 c3                	mov    %eax,%ebx
  800e33:	f7 64 24 0c          	mull   0xc(%esp)
  800e37:	39 d6                	cmp    %edx,%esi
  800e39:	72 0c                	jb     800e47 <__udivdi3+0xb7>
  800e3b:	89 f9                	mov    %edi,%ecx
  800e3d:	d3 e5                	shl    %cl,%ebp
  800e3f:	39 c5                	cmp    %eax,%ebp
  800e41:	73 5d                	jae    800ea0 <__udivdi3+0x110>
  800e43:	39 d6                	cmp    %edx,%esi
  800e45:	75 59                	jne    800ea0 <__udivdi3+0x110>
  800e47:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e4a:	31 ff                	xor    %edi,%edi
  800e4c:	89 fa                	mov    %edi,%edx
  800e4e:	83 c4 1c             	add    $0x1c,%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
  800e56:	8d 76 00             	lea    0x0(%esi),%esi
  800e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e60:	31 ff                	xor    %edi,%edi
  800e62:	31 c0                	xor    %eax,%eax
  800e64:	89 fa                	mov    %edi,%edx
  800e66:	83 c4 1c             	add    $0x1c,%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
  800e6e:	66 90                	xchg   %ax,%ax
  800e70:	31 ff                	xor    %edi,%edi
  800e72:	89 e8                	mov    %ebp,%eax
  800e74:	89 f2                	mov    %esi,%edx
  800e76:	f7 f3                	div    %ebx
  800e78:	89 fa                	mov    %edi,%edx
  800e7a:	83 c4 1c             	add    $0x1c,%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
  800e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e88:	39 f2                	cmp    %esi,%edx
  800e8a:	72 06                	jb     800e92 <__udivdi3+0x102>
  800e8c:	31 c0                	xor    %eax,%eax
  800e8e:	39 eb                	cmp    %ebp,%ebx
  800e90:	77 d2                	ja     800e64 <__udivdi3+0xd4>
  800e92:	b8 01 00 00 00       	mov    $0x1,%eax
  800e97:	eb cb                	jmp    800e64 <__udivdi3+0xd4>
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	89 d8                	mov    %ebx,%eax
  800ea2:	31 ff                	xor    %edi,%edi
  800ea4:	eb be                	jmp    800e64 <__udivdi3+0xd4>
  800ea6:	66 90                	xchg   %ax,%ax
  800ea8:	66 90                	xchg   %ax,%ax
  800eaa:	66 90                	xchg   %ax,%ax
  800eac:	66 90                	xchg   %ax,%ax
  800eae:	66 90                	xchg   %ax,%ax

00800eb0 <__umoddi3>:
  800eb0:	55                   	push   %ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 1c             	sub    $0x1c,%esp
  800eb7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800ebb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ebf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ec3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ec7:	85 ed                	test   %ebp,%ebp
  800ec9:	89 f0                	mov    %esi,%eax
  800ecb:	89 da                	mov    %ebx,%edx
  800ecd:	75 19                	jne    800ee8 <__umoddi3+0x38>
  800ecf:	39 df                	cmp    %ebx,%edi
  800ed1:	0f 86 b1 00 00 00    	jbe    800f88 <__umoddi3+0xd8>
  800ed7:	f7 f7                	div    %edi
  800ed9:	89 d0                	mov    %edx,%eax
  800edb:	31 d2                	xor    %edx,%edx
  800edd:	83 c4 1c             	add    $0x1c,%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
  800ee5:	8d 76 00             	lea    0x0(%esi),%esi
  800ee8:	39 dd                	cmp    %ebx,%ebp
  800eea:	77 f1                	ja     800edd <__umoddi3+0x2d>
  800eec:	0f bd cd             	bsr    %ebp,%ecx
  800eef:	83 f1 1f             	xor    $0x1f,%ecx
  800ef2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ef6:	0f 84 b4 00 00 00    	je     800fb0 <__umoddi3+0x100>
  800efc:	b8 20 00 00 00       	mov    $0x20,%eax
  800f01:	89 c2                	mov    %eax,%edx
  800f03:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f07:	29 c2                	sub    %eax,%edx
  800f09:	89 c1                	mov    %eax,%ecx
  800f0b:	89 f8                	mov    %edi,%eax
  800f0d:	d3 e5                	shl    %cl,%ebp
  800f0f:	89 d1                	mov    %edx,%ecx
  800f11:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f15:	d3 e8                	shr    %cl,%eax
  800f17:	09 c5                	or     %eax,%ebp
  800f19:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f1d:	89 c1                	mov    %eax,%ecx
  800f1f:	d3 e7                	shl    %cl,%edi
  800f21:	89 d1                	mov    %edx,%ecx
  800f23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f27:	89 df                	mov    %ebx,%edi
  800f29:	d3 ef                	shr    %cl,%edi
  800f2b:	89 c1                	mov    %eax,%ecx
  800f2d:	89 f0                	mov    %esi,%eax
  800f2f:	d3 e3                	shl    %cl,%ebx
  800f31:	89 d1                	mov    %edx,%ecx
  800f33:	89 fa                	mov    %edi,%edx
  800f35:	d3 e8                	shr    %cl,%eax
  800f37:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f3c:	09 d8                	or     %ebx,%eax
  800f3e:	f7 f5                	div    %ebp
  800f40:	d3 e6                	shl    %cl,%esi
  800f42:	89 d1                	mov    %edx,%ecx
  800f44:	f7 64 24 08          	mull   0x8(%esp)
  800f48:	39 d1                	cmp    %edx,%ecx
  800f4a:	89 c3                	mov    %eax,%ebx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	72 06                	jb     800f56 <__umoddi3+0xa6>
  800f50:	75 0e                	jne    800f60 <__umoddi3+0xb0>
  800f52:	39 c6                	cmp    %eax,%esi
  800f54:	73 0a                	jae    800f60 <__umoddi3+0xb0>
  800f56:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f5a:	19 ea                	sbb    %ebp,%edx
  800f5c:	89 d7                	mov    %edx,%edi
  800f5e:	89 c3                	mov    %eax,%ebx
  800f60:	89 ca                	mov    %ecx,%edx
  800f62:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f67:	29 de                	sub    %ebx,%esi
  800f69:	19 fa                	sbb    %edi,%edx
  800f6b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f6f:	89 d0                	mov    %edx,%eax
  800f71:	d3 e0                	shl    %cl,%eax
  800f73:	89 d9                	mov    %ebx,%ecx
  800f75:	d3 ee                	shr    %cl,%esi
  800f77:	d3 ea                	shr    %cl,%edx
  800f79:	09 f0                	or     %esi,%eax
  800f7b:	83 c4 1c             	add    $0x1c,%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
  800f83:	90                   	nop
  800f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f88:	85 ff                	test   %edi,%edi
  800f8a:	89 f9                	mov    %edi,%ecx
  800f8c:	75 0b                	jne    800f99 <__umoddi3+0xe9>
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f93:	31 d2                	xor    %edx,%edx
  800f95:	f7 f7                	div    %edi
  800f97:	89 c1                	mov    %eax,%ecx
  800f99:	89 d8                	mov    %ebx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	f7 f1                	div    %ecx
  800f9f:	89 f0                	mov    %esi,%eax
  800fa1:	f7 f1                	div    %ecx
  800fa3:	e9 31 ff ff ff       	jmp    800ed9 <__umoddi3+0x29>
  800fa8:	90                   	nop
  800fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fb0:	39 dd                	cmp    %ebx,%ebp
  800fb2:	72 08                	jb     800fbc <__umoddi3+0x10c>
  800fb4:	39 f7                	cmp    %esi,%edi
  800fb6:	0f 87 21 ff ff ff    	ja     800edd <__umoddi3+0x2d>
  800fbc:	89 da                	mov    %ebx,%edx
  800fbe:	89 f0                	mov    %esi,%eax
  800fc0:	29 f8                	sub    %edi,%eax
  800fc2:	19 ea                	sbb    %ebp,%edx
  800fc4:	e9 14 ff ff ff       	jmp    800edd <__umoddi3+0x2d>
