
obj/user/divzero：     文件格式 elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 e0 0f 80 00       	push   $0x800fe0
  800056:	e8 f2 00 00 00       	call   80014d <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 f6 0a 00 00       	call   800b66 <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x2d>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000ac:	6a 00                	push   $0x0
  8000ae:	e8 72 0a 00 00       	call   800b25 <sys_env_destroy>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 04             	sub    $0x4,%esp
  8000bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c2:	8b 13                	mov    (%ebx),%edx
  8000c4:	8d 42 01             	lea    0x1(%edx),%eax
  8000c7:	89 03                	mov    %eax,(%ebx)
  8000c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d5:	74 09                	je     8000e0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e0:	83 ec 08             	sub    $0x8,%esp
  8000e3:	68 ff 00 00 00       	push   $0xff
  8000e8:	8d 43 08             	lea    0x8(%ebx),%eax
  8000eb:	50                   	push   %eax
  8000ec:	e8 f7 09 00 00       	call   800ae8 <sys_cputs>
		b->idx = 0;
  8000f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	eb db                	jmp    8000d7 <putch+0x1f>

008000fc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800105:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010c:	00 00 00 
	b.cnt = 0;
  80010f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800116:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800119:	ff 75 0c             	pushl  0xc(%ebp)
  80011c:	ff 75 08             	pushl  0x8(%ebp)
  80011f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800125:	50                   	push   %eax
  800126:	68 b8 00 80 00       	push   $0x8000b8
  80012b:	e8 1a 01 00 00       	call   80024a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800130:	83 c4 08             	add    $0x8,%esp
  800133:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800139:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013f:	50                   	push   %eax
  800140:	e8 a3 09 00 00       	call   800ae8 <sys_cputs>

	return b.cnt;
}
  800145:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800153:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800156:	50                   	push   %eax
  800157:	ff 75 08             	pushl  0x8(%ebp)
  80015a:	e8 9d ff ff ff       	call   8000fc <vcprintf>
	va_end(ap);

	return cnt;
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    

00800161 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	57                   	push   %edi
  800165:	56                   	push   %esi
  800166:	53                   	push   %ebx
  800167:	83 ec 1c             	sub    $0x1c,%esp
  80016a:	89 c7                	mov    %eax,%edi
  80016c:	89 d6                	mov    %edx,%esi
  80016e:	8b 45 08             	mov    0x8(%ebp),%eax
  800171:	8b 55 0c             	mov    0xc(%ebp),%edx
  800174:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800177:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80017a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80017d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800182:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800185:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800188:	39 d3                	cmp    %edx,%ebx
  80018a:	72 05                	jb     800191 <printnum+0x30>
  80018c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80018f:	77 7a                	ja     80020b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	ff 75 18             	pushl  0x18(%ebp)
  800197:	8b 45 14             	mov    0x14(%ebp),%eax
  80019a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80019d:	53                   	push   %ebx
  80019e:	ff 75 10             	pushl  0x10(%ebp)
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b0:	e8 eb 0b 00 00       	call   800da0 <__udivdi3>
  8001b5:	83 c4 18             	add    $0x18,%esp
  8001b8:	52                   	push   %edx
  8001b9:	50                   	push   %eax
  8001ba:	89 f2                	mov    %esi,%edx
  8001bc:	89 f8                	mov    %edi,%eax
  8001be:	e8 9e ff ff ff       	call   800161 <printnum>
  8001c3:	83 c4 20             	add    $0x20,%esp
  8001c6:	eb 13                	jmp    8001db <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	56                   	push   %esi
  8001cc:	ff 75 18             	pushl  0x18(%ebp)
  8001cf:	ff d7                	call   *%edi
  8001d1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001d4:	83 eb 01             	sub    $0x1,%ebx
  8001d7:	85 db                	test   %ebx,%ebx
  8001d9:	7f ed                	jg     8001c8 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	56                   	push   %esi
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ee:	e8 cd 0c 00 00       	call   800ec0 <__umoddi3>
  8001f3:	83 c4 14             	add    $0x14,%esp
  8001f6:	0f be 80 f8 0f 80 00 	movsbl 0x800ff8(%eax),%eax
  8001fd:	50                   	push   %eax
  8001fe:	ff d7                	call   *%edi
}
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5f                   	pop    %edi
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    
  80020b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80020e:	eb c4                	jmp    8001d4 <printnum+0x73>

00800210 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800216:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80021a:	8b 10                	mov    (%eax),%edx
  80021c:	3b 50 04             	cmp    0x4(%eax),%edx
  80021f:	73 0a                	jae    80022b <sprintputch+0x1b>
		*b->buf++ = ch;
  800221:	8d 4a 01             	lea    0x1(%edx),%ecx
  800224:	89 08                	mov    %ecx,(%eax)
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	88 02                	mov    %al,(%edx)
}
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    

0080022d <printfmt>:
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800233:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800236:	50                   	push   %eax
  800237:	ff 75 10             	pushl  0x10(%ebp)
  80023a:	ff 75 0c             	pushl  0xc(%ebp)
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	e8 05 00 00 00       	call   80024a <vprintfmt>
}
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	c9                   	leave  
  800249:	c3                   	ret    

0080024a <vprintfmt>:
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	57                   	push   %edi
  80024e:	56                   	push   %esi
  80024f:	53                   	push   %ebx
  800250:	83 ec 2c             	sub    $0x2c,%esp
  800253:	8b 75 08             	mov    0x8(%ebp),%esi
  800256:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800259:	8b 7d 10             	mov    0x10(%ebp),%edi
  80025c:	e9 00 04 00 00       	jmp    800661 <vprintfmt+0x417>
		padc = ' ';
  800261:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800265:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80026c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800273:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80027a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80027f:	8d 47 01             	lea    0x1(%edi),%eax
  800282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800285:	0f b6 17             	movzbl (%edi),%edx
  800288:	8d 42 dd             	lea    -0x23(%edx),%eax
  80028b:	3c 55                	cmp    $0x55,%al
  80028d:	0f 87 51 04 00 00    	ja     8006e4 <vprintfmt+0x49a>
  800293:	0f b6 c0             	movzbl %al,%eax
  800296:	ff 24 85 c0 10 80 00 	jmp    *0x8010c0(,%eax,4)
  80029d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002a4:	eb d9                	jmp    80027f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002a9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ad:	eb d0                	jmp    80027f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002af:	0f b6 d2             	movzbl %dl,%edx
  8002b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002bd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002c4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002c7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ca:	83 f9 09             	cmp    $0x9,%ecx
  8002cd:	77 55                	ja     800324 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002cf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d2:	eb e9                	jmp    8002bd <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d7:	8b 00                	mov    (%eax),%eax
  8002d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002df:	8d 40 04             	lea    0x4(%eax),%eax
  8002e2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002ec:	79 91                	jns    80027f <vprintfmt+0x35>
				width = precision, precision = -1;
  8002ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002fb:	eb 82                	jmp    80027f <vprintfmt+0x35>
  8002fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	ba 00 00 00 00       	mov    $0x0,%edx
  800307:	0f 49 d0             	cmovns %eax,%edx
  80030a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800310:	e9 6a ff ff ff       	jmp    80027f <vprintfmt+0x35>
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800318:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80031f:	e9 5b ff ff ff       	jmp    80027f <vprintfmt+0x35>
  800324:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800327:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80032a:	eb bc                	jmp    8002e8 <vprintfmt+0x9e>
			lflag++;
  80032c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800332:	e9 48 ff ff ff       	jmp    80027f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800337:	8b 45 14             	mov    0x14(%ebp),%eax
  80033a:	8d 78 04             	lea    0x4(%eax),%edi
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	53                   	push   %ebx
  800341:	ff 30                	pushl  (%eax)
  800343:	ff d6                	call   *%esi
			break;
  800345:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800348:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80034b:	e9 0e 03 00 00       	jmp    80065e <vprintfmt+0x414>
			err = va_arg(ap, int);
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	8d 78 04             	lea    0x4(%eax),%edi
  800356:	8b 00                	mov    (%eax),%eax
  800358:	99                   	cltd   
  800359:	31 d0                	xor    %edx,%eax
  80035b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80035d:	83 f8 08             	cmp    $0x8,%eax
  800360:	7f 23                	jg     800385 <vprintfmt+0x13b>
  800362:	8b 14 85 20 12 80 00 	mov    0x801220(,%eax,4),%edx
  800369:	85 d2                	test   %edx,%edx
  80036b:	74 18                	je     800385 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80036d:	52                   	push   %edx
  80036e:	68 19 10 80 00       	push   $0x801019
  800373:	53                   	push   %ebx
  800374:	56                   	push   %esi
  800375:	e8 b3 fe ff ff       	call   80022d <printfmt>
  80037a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80037d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800380:	e9 d9 02 00 00       	jmp    80065e <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800385:	50                   	push   %eax
  800386:	68 10 10 80 00       	push   $0x801010
  80038b:	53                   	push   %ebx
  80038c:	56                   	push   %esi
  80038d:	e8 9b fe ff ff       	call   80022d <printfmt>
  800392:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800395:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800398:	e9 c1 02 00 00       	jmp    80065e <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80039d:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a0:	83 c0 04             	add    $0x4,%eax
  8003a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ab:	85 ff                	test   %edi,%edi
  8003ad:	b8 09 10 80 00       	mov    $0x801009,%eax
  8003b2:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b9:	0f 8e bd 00 00 00    	jle    80047c <vprintfmt+0x232>
  8003bf:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c3:	75 0e                	jne    8003d3 <vprintfmt+0x189>
  8003c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8003c8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003cb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003ce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d1:	eb 6d                	jmp    800440 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d9:	57                   	push   %edi
  8003da:	e8 ad 03 00 00       	call   80078c <strnlen>
  8003df:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e2:	29 c1                	sub    %eax,%ecx
  8003e4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003e7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003ea:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003f4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f6:	eb 0f                	jmp    800407 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	53                   	push   %ebx
  8003fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ff:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800401:	83 ef 01             	sub    $0x1,%edi
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	85 ff                	test   %edi,%edi
  800409:	7f ed                	jg     8003f8 <vprintfmt+0x1ae>
  80040b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80040e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800411:	85 c9                	test   %ecx,%ecx
  800413:	b8 00 00 00 00       	mov    $0x0,%eax
  800418:	0f 49 c1             	cmovns %ecx,%eax
  80041b:	29 c1                	sub    %eax,%ecx
  80041d:	89 75 08             	mov    %esi,0x8(%ebp)
  800420:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800423:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800426:	89 cb                	mov    %ecx,%ebx
  800428:	eb 16                	jmp    800440 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80042a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80042e:	75 31                	jne    800461 <vprintfmt+0x217>
					putch(ch, putdat);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 0c             	pushl  0xc(%ebp)
  800436:	50                   	push   %eax
  800437:	ff 55 08             	call   *0x8(%ebp)
  80043a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80043d:	83 eb 01             	sub    $0x1,%ebx
  800440:	83 c7 01             	add    $0x1,%edi
  800443:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800447:	0f be c2             	movsbl %dl,%eax
  80044a:	85 c0                	test   %eax,%eax
  80044c:	74 59                	je     8004a7 <vprintfmt+0x25d>
  80044e:	85 f6                	test   %esi,%esi
  800450:	78 d8                	js     80042a <vprintfmt+0x1e0>
  800452:	83 ee 01             	sub    $0x1,%esi
  800455:	79 d3                	jns    80042a <vprintfmt+0x1e0>
  800457:	89 df                	mov    %ebx,%edi
  800459:	8b 75 08             	mov    0x8(%ebp),%esi
  80045c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80045f:	eb 37                	jmp    800498 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800461:	0f be d2             	movsbl %dl,%edx
  800464:	83 ea 20             	sub    $0x20,%edx
  800467:	83 fa 5e             	cmp    $0x5e,%edx
  80046a:	76 c4                	jbe    800430 <vprintfmt+0x1e6>
					putch('?', putdat);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 0c             	pushl  0xc(%ebp)
  800472:	6a 3f                	push   $0x3f
  800474:	ff 55 08             	call   *0x8(%ebp)
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	eb c1                	jmp    80043d <vprintfmt+0x1f3>
  80047c:	89 75 08             	mov    %esi,0x8(%ebp)
  80047f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800482:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800485:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800488:	eb b6                	jmp    800440 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	53                   	push   %ebx
  80048e:	6a 20                	push   $0x20
  800490:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800492:	83 ef 01             	sub    $0x1,%edi
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 ff                	test   %edi,%edi
  80049a:	7f ee                	jg     80048a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80049c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049f:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a2:	e9 b7 01 00 00       	jmp    80065e <vprintfmt+0x414>
  8004a7:	89 df                	mov    %ebx,%edi
  8004a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004af:	eb e7                	jmp    800498 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b1:	83 f9 01             	cmp    $0x1,%ecx
  8004b4:	7e 3f                	jle    8004f5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8b 50 04             	mov    0x4(%eax),%edx
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 40 08             	lea    0x8(%eax),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d1:	79 5c                	jns    80052f <vprintfmt+0x2e5>
				putch('-', putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	6a 2d                	push   $0x2d
  8004d9:	ff d6                	call   *%esi
				num = -(long long) num;
  8004db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e1:	f7 da                	neg    %edx
  8004e3:	83 d1 00             	adc    $0x0,%ecx
  8004e6:	f7 d9                	neg    %ecx
  8004e8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f0:	e9 4f 01 00 00       	jmp    800644 <vprintfmt+0x3fa>
	else if (lflag)
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	75 1b                	jne    800514 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	89 c1                	mov    %eax,%ecx
  800503:	c1 f9 1f             	sar    $0x1f,%ecx
  800506:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8d 40 04             	lea    0x4(%eax),%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
  800512:	eb b9                	jmp    8004cd <vprintfmt+0x283>
		return va_arg(*ap, long);
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051c:	89 c1                	mov    %eax,%ecx
  80051e:	c1 f9 1f             	sar    $0x1f,%ecx
  800521:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 04             	lea    0x4(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	eb 9e                	jmp    8004cd <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80052f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800532:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800535:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053a:	e9 05 01 00 00       	jmp    800644 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80053f:	83 f9 01             	cmp    $0x1,%ecx
  800542:	7e 18                	jle    80055c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8b 10                	mov    (%eax),%edx
  800549:	8b 48 04             	mov    0x4(%eax),%ecx
  80054c:	8d 40 08             	lea    0x8(%eax),%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800552:	b8 0a 00 00 00       	mov    $0xa,%eax
  800557:	e9 e8 00 00 00       	jmp    800644 <vprintfmt+0x3fa>
	else if (lflag)
  80055c:	85 c9                	test   %ecx,%ecx
  80055e:	75 1a                	jne    80057a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8b 10                	mov    (%eax),%edx
  800565:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800570:	b8 0a 00 00 00       	mov    $0xa,%eax
  800575:	e9 ca 00 00 00       	jmp    800644 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 10                	mov    (%eax),%edx
  80057f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058f:	e9 b0 00 00 00       	jmp    800644 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800594:	83 f9 01             	cmp    $0x1,%ecx
  800597:	7e 3c                	jle    8005d5 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	8b 50 04             	mov    0x4(%eax),%edx
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 40 08             	lea    0x8(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b4:	79 59                	jns    80060f <vprintfmt+0x3c5>
                putch('-', putdat);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	53                   	push   %ebx
  8005ba:	6a 2d                	push   $0x2d
  8005bc:	ff d6                	call   *%esi
                num = -(long long) num;
  8005be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c4:	f7 da                	neg    %edx
  8005c6:	83 d1 00             	adc    $0x0,%ecx
  8005c9:	f7 d9                	neg    %ecx
  8005cb:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d3:	eb 6f                	jmp    800644 <vprintfmt+0x3fa>
	else if (lflag)
  8005d5:	85 c9                	test   %ecx,%ecx
  8005d7:	75 1b                	jne    8005f4 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e1:	89 c1                	mov    %eax,%ecx
  8005e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f2:	eb bc                	jmp    8005b0 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	89 c1                	mov    %eax,%ecx
  8005fe:	c1 f9 1f             	sar    $0x1f,%ecx
  800601:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
  80060d:	eb a1                	jmp    8005b0 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80060f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800612:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800615:	b8 08 00 00 00       	mov    $0x8,%eax
  80061a:	eb 28                	jmp    800644 <vprintfmt+0x3fa>
			putch('0', putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	6a 30                	push   $0x30
  800622:	ff d6                	call   *%esi
			putch('x', putdat);
  800624:	83 c4 08             	add    $0x8,%esp
  800627:	53                   	push   %ebx
  800628:	6a 78                	push   $0x78
  80062a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 10                	mov    (%eax),%edx
  800631:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800636:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80063f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800644:	83 ec 0c             	sub    $0xc,%esp
  800647:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80064b:	57                   	push   %edi
  80064c:	ff 75 e0             	pushl  -0x20(%ebp)
  80064f:	50                   	push   %eax
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	89 da                	mov    %ebx,%edx
  800654:	89 f0                	mov    %esi,%eax
  800656:	e8 06 fb ff ff       	call   800161 <printnum>
			break;
  80065b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80065e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800661:	83 c7 01             	add    $0x1,%edi
  800664:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800668:	83 f8 25             	cmp    $0x25,%eax
  80066b:	0f 84 f0 fb ff ff    	je     800261 <vprintfmt+0x17>
			if (ch == '\0')
  800671:	85 c0                	test   %eax,%eax
  800673:	0f 84 8b 00 00 00    	je     800704 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	53                   	push   %ebx
  80067d:	50                   	push   %eax
  80067e:	ff d6                	call   *%esi
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	eb dc                	jmp    800661 <vprintfmt+0x417>
	if (lflag >= 2)
  800685:	83 f9 01             	cmp    $0x1,%ecx
  800688:	7e 15                	jle    80069f <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 10                	mov    (%eax),%edx
  80068f:	8b 48 04             	mov    0x4(%eax),%ecx
  800692:	8d 40 08             	lea    0x8(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800698:	b8 10 00 00 00       	mov    $0x10,%eax
  80069d:	eb a5                	jmp    800644 <vprintfmt+0x3fa>
	else if (lflag)
  80069f:	85 c9                	test   %ecx,%ecx
  8006a1:	75 17                	jne    8006ba <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 10                	mov    (%eax),%edx
  8006a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b8:	eb 8a                	jmp    800644 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 10                	mov    (%eax),%edx
  8006bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ca:	b8 10 00 00 00       	mov    $0x10,%eax
  8006cf:	e9 70 ff ff ff       	jmp    800644 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 25                	push   $0x25
  8006da:	ff d6                	call   *%esi
			break;
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	e9 7a ff ff ff       	jmp    80065e <vprintfmt+0x414>
			putch('%', putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	6a 25                	push   $0x25
  8006ea:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	89 f8                	mov    %edi,%eax
  8006f1:	eb 03                	jmp    8006f6 <vprintfmt+0x4ac>
  8006f3:	83 e8 01             	sub    $0x1,%eax
  8006f6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006fa:	75 f7                	jne    8006f3 <vprintfmt+0x4a9>
  8006fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ff:	e9 5a ff ff ff       	jmp    80065e <vprintfmt+0x414>
}
  800704:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800707:	5b                   	pop    %ebx
  800708:	5e                   	pop    %esi
  800709:	5f                   	pop    %edi
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800718:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80071b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80071f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800722:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800729:	85 c0                	test   %eax,%eax
  80072b:	74 26                	je     800753 <vsnprintf+0x47>
  80072d:	85 d2                	test   %edx,%edx
  80072f:	7e 22                	jle    800753 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800731:	ff 75 14             	pushl  0x14(%ebp)
  800734:	ff 75 10             	pushl  0x10(%ebp)
  800737:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80073a:	50                   	push   %eax
  80073b:	68 10 02 80 00       	push   $0x800210
  800740:	e8 05 fb ff ff       	call   80024a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800748:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80074e:	83 c4 10             	add    $0x10,%esp
}
  800751:	c9                   	leave  
  800752:	c3                   	ret    
		return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800758:	eb f7                	jmp    800751 <vsnprintf+0x45>

0080075a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800760:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800763:	50                   	push   %eax
  800764:	ff 75 10             	pushl  0x10(%ebp)
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	ff 75 08             	pushl  0x8(%ebp)
  80076d:	e8 9a ff ff ff       	call   80070c <vsnprintf>
	va_end(ap);

	return rc;
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077a:	b8 00 00 00 00       	mov    $0x0,%eax
  80077f:	eb 03                	jmp    800784 <strlen+0x10>
		n++;
  800781:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800784:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800788:	75 f7                	jne    800781 <strlen+0xd>
	return n;
}
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800792:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800795:	b8 00 00 00 00       	mov    $0x0,%eax
  80079a:	eb 03                	jmp    80079f <strnlen+0x13>
		n++;
  80079c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079f:	39 d0                	cmp    %edx,%eax
  8007a1:	74 06                	je     8007a9 <strnlen+0x1d>
  8007a3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a7:	75 f3                	jne    80079c <strnlen+0x10>
	return n;
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b5:	89 c2                	mov    %eax,%edx
  8007b7:	83 c1 01             	add    $0x1,%ecx
  8007ba:	83 c2 01             	add    $0x1,%edx
  8007bd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007c1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007c4:	84 db                	test   %bl,%bl
  8007c6:	75 ef                	jne    8007b7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007c8:	5b                   	pop    %ebx
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	53                   	push   %ebx
  8007cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d2:	53                   	push   %ebx
  8007d3:	e8 9c ff ff ff       	call   800774 <strlen>
  8007d8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	01 d8                	add    %ebx,%eax
  8007e0:	50                   	push   %eax
  8007e1:	e8 c5 ff ff ff       	call   8007ab <strcpy>
	return dst;
}
  8007e6:	89 d8                	mov    %ebx,%eax
  8007e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	56                   	push   %esi
  8007f1:	53                   	push   %ebx
  8007f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f8:	89 f3                	mov    %esi,%ebx
  8007fa:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007fd:	89 f2                	mov    %esi,%edx
  8007ff:	eb 0f                	jmp    800810 <strncpy+0x23>
		*dst++ = *src;
  800801:	83 c2 01             	add    $0x1,%edx
  800804:	0f b6 01             	movzbl (%ecx),%eax
  800807:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80080a:	80 39 01             	cmpb   $0x1,(%ecx)
  80080d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800810:	39 da                	cmp    %ebx,%edx
  800812:	75 ed                	jne    800801 <strncpy+0x14>
	}
	return ret;
}
  800814:	89 f0                	mov    %esi,%eax
  800816:	5b                   	pop    %ebx
  800817:	5e                   	pop    %esi
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	56                   	push   %esi
  80081e:	53                   	push   %ebx
  80081f:	8b 75 08             	mov    0x8(%ebp),%esi
  800822:	8b 55 0c             	mov    0xc(%ebp),%edx
  800825:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800828:	89 f0                	mov    %esi,%eax
  80082a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082e:	85 c9                	test   %ecx,%ecx
  800830:	75 0b                	jne    80083d <strlcpy+0x23>
  800832:	eb 17                	jmp    80084b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800834:	83 c2 01             	add    $0x1,%edx
  800837:	83 c0 01             	add    $0x1,%eax
  80083a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80083d:	39 d8                	cmp    %ebx,%eax
  80083f:	74 07                	je     800848 <strlcpy+0x2e>
  800841:	0f b6 0a             	movzbl (%edx),%ecx
  800844:	84 c9                	test   %cl,%cl
  800846:	75 ec                	jne    800834 <strlcpy+0x1a>
		*dst = '\0';
  800848:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80084b:	29 f0                	sub    %esi,%eax
}
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800857:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80085a:	eb 06                	jmp    800862 <strcmp+0x11>
		p++, q++;
  80085c:	83 c1 01             	add    $0x1,%ecx
  80085f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800862:	0f b6 01             	movzbl (%ecx),%eax
  800865:	84 c0                	test   %al,%al
  800867:	74 04                	je     80086d <strcmp+0x1c>
  800869:	3a 02                	cmp    (%edx),%al
  80086b:	74 ef                	je     80085c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086d:	0f b6 c0             	movzbl %al,%eax
  800870:	0f b6 12             	movzbl (%edx),%edx
  800873:	29 d0                	sub    %edx,%eax
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800881:	89 c3                	mov    %eax,%ebx
  800883:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800886:	eb 06                	jmp    80088e <strncmp+0x17>
		n--, p++, q++;
  800888:	83 c0 01             	add    $0x1,%eax
  80088b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80088e:	39 d8                	cmp    %ebx,%eax
  800890:	74 16                	je     8008a8 <strncmp+0x31>
  800892:	0f b6 08             	movzbl (%eax),%ecx
  800895:	84 c9                	test   %cl,%cl
  800897:	74 04                	je     80089d <strncmp+0x26>
  800899:	3a 0a                	cmp    (%edx),%cl
  80089b:	74 eb                	je     800888 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80089d:	0f b6 00             	movzbl (%eax),%eax
  8008a0:	0f b6 12             	movzbl (%edx),%edx
  8008a3:	29 d0                	sub    %edx,%eax
}
  8008a5:	5b                   	pop    %ebx
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    
		return 0;
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	eb f6                	jmp    8008a5 <strncmp+0x2e>

008008af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b9:	0f b6 10             	movzbl (%eax),%edx
  8008bc:	84 d2                	test   %dl,%dl
  8008be:	74 09                	je     8008c9 <strchr+0x1a>
		if (*s == c)
  8008c0:	38 ca                	cmp    %cl,%dl
  8008c2:	74 0a                	je     8008ce <strchr+0x1f>
	for (; *s; s++)
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	eb f0                	jmp    8008b9 <strchr+0xa>
			return (char *) s;
	return 0;
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008da:	eb 03                	jmp    8008df <strfind+0xf>
  8008dc:	83 c0 01             	add    $0x1,%eax
  8008df:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008e2:	38 ca                	cmp    %cl,%dl
  8008e4:	74 04                	je     8008ea <strfind+0x1a>
  8008e6:	84 d2                	test   %dl,%dl
  8008e8:	75 f2                	jne    8008dc <strfind+0xc>
			break;
	return (char *) s;
}
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	57                   	push   %edi
  8008f0:	56                   	push   %esi
  8008f1:	53                   	push   %ebx
  8008f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008f8:	85 c9                	test   %ecx,%ecx
  8008fa:	74 13                	je     80090f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008fc:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800902:	75 05                	jne    800909 <memset+0x1d>
  800904:	f6 c1 03             	test   $0x3,%cl
  800907:	74 0d                	je     800916 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090c:	fc                   	cld    
  80090d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80090f:	89 f8                	mov    %edi,%eax
  800911:	5b                   	pop    %ebx
  800912:	5e                   	pop    %esi
  800913:	5f                   	pop    %edi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    
		c &= 0xFF;
  800916:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80091a:	89 d3                	mov    %edx,%ebx
  80091c:	c1 e3 08             	shl    $0x8,%ebx
  80091f:	89 d0                	mov    %edx,%eax
  800921:	c1 e0 18             	shl    $0x18,%eax
  800924:	89 d6                	mov    %edx,%esi
  800926:	c1 e6 10             	shl    $0x10,%esi
  800929:	09 f0                	or     %esi,%eax
  80092b:	09 c2                	or     %eax,%edx
  80092d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80092f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800932:	89 d0                	mov    %edx,%eax
  800934:	fc                   	cld    
  800935:	f3 ab                	rep stos %eax,%es:(%edi)
  800937:	eb d6                	jmp    80090f <memset+0x23>

00800939 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	57                   	push   %edi
  80093d:	56                   	push   %esi
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 75 0c             	mov    0xc(%ebp),%esi
  800944:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800947:	39 c6                	cmp    %eax,%esi
  800949:	73 35                	jae    800980 <memmove+0x47>
  80094b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	76 2e                	jbe    800980 <memmove+0x47>
		s += n;
		d += n;
  800952:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800955:	89 d6                	mov    %edx,%esi
  800957:	09 fe                	or     %edi,%esi
  800959:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80095f:	74 0c                	je     80096d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800961:	83 ef 01             	sub    $0x1,%edi
  800964:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800967:	fd                   	std    
  800968:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096a:	fc                   	cld    
  80096b:	eb 21                	jmp    80098e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096d:	f6 c1 03             	test   $0x3,%cl
  800970:	75 ef                	jne    800961 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800972:	83 ef 04             	sub    $0x4,%edi
  800975:	8d 72 fc             	lea    -0x4(%edx),%esi
  800978:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80097b:	fd                   	std    
  80097c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097e:	eb ea                	jmp    80096a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800980:	89 f2                	mov    %esi,%edx
  800982:	09 c2                	or     %eax,%edx
  800984:	f6 c2 03             	test   $0x3,%dl
  800987:	74 09                	je     800992 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800989:	89 c7                	mov    %eax,%edi
  80098b:	fc                   	cld    
  80098c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80098e:	5e                   	pop    %esi
  80098f:	5f                   	pop    %edi
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800992:	f6 c1 03             	test   $0x3,%cl
  800995:	75 f2                	jne    800989 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800997:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80099a:	89 c7                	mov    %eax,%edi
  80099c:	fc                   	cld    
  80099d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099f:	eb ed                	jmp    80098e <memmove+0x55>

008009a1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009a4:	ff 75 10             	pushl  0x10(%ebp)
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	ff 75 08             	pushl  0x8(%ebp)
  8009ad:	e8 87 ff ff ff       	call   800939 <memmove>
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	56                   	push   %esi
  8009b8:	53                   	push   %ebx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bf:	89 c6                	mov    %eax,%esi
  8009c1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c4:	39 f0                	cmp    %esi,%eax
  8009c6:	74 1c                	je     8009e4 <memcmp+0x30>
		if (*s1 != *s2)
  8009c8:	0f b6 08             	movzbl (%eax),%ecx
  8009cb:	0f b6 1a             	movzbl (%edx),%ebx
  8009ce:	38 d9                	cmp    %bl,%cl
  8009d0:	75 08                	jne    8009da <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d2:	83 c0 01             	add    $0x1,%eax
  8009d5:	83 c2 01             	add    $0x1,%edx
  8009d8:	eb ea                	jmp    8009c4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009da:	0f b6 c1             	movzbl %cl,%eax
  8009dd:	0f b6 db             	movzbl %bl,%ebx
  8009e0:	29 d8                	sub    %ebx,%eax
  8009e2:	eb 05                	jmp    8009e9 <memcmp+0x35>
	}

	return 0;
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e9:	5b                   	pop    %ebx
  8009ea:	5e                   	pop    %esi
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f6:	89 c2                	mov    %eax,%edx
  8009f8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009fb:	39 d0                	cmp    %edx,%eax
  8009fd:	73 09                	jae    800a08 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ff:	38 08                	cmp    %cl,(%eax)
  800a01:	74 05                	je     800a08 <memfind+0x1b>
	for (; s < ends; s++)
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	eb f3                	jmp    8009fb <memfind+0xe>
			break;
	return (void *) s;
}
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	57                   	push   %edi
  800a0e:	56                   	push   %esi
  800a0f:	53                   	push   %ebx
  800a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a16:	eb 03                	jmp    800a1b <strtol+0x11>
		s++;
  800a18:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a1b:	0f b6 01             	movzbl (%ecx),%eax
  800a1e:	3c 20                	cmp    $0x20,%al
  800a20:	74 f6                	je     800a18 <strtol+0xe>
  800a22:	3c 09                	cmp    $0x9,%al
  800a24:	74 f2                	je     800a18 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a26:	3c 2b                	cmp    $0x2b,%al
  800a28:	74 2e                	je     800a58 <strtol+0x4e>
	int neg = 0;
  800a2a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a2f:	3c 2d                	cmp    $0x2d,%al
  800a31:	74 2f                	je     800a62 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a33:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a39:	75 05                	jne    800a40 <strtol+0x36>
  800a3b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3e:	74 2c                	je     800a6c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a40:	85 db                	test   %ebx,%ebx
  800a42:	75 0a                	jne    800a4e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a44:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a49:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4c:	74 28                	je     800a76 <strtol+0x6c>
		base = 10;
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a53:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a56:	eb 50                	jmp    800aa8 <strtol+0x9e>
		s++;
  800a58:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a60:	eb d1                	jmp    800a33 <strtol+0x29>
		s++, neg = 1;
  800a62:	83 c1 01             	add    $0x1,%ecx
  800a65:	bf 01 00 00 00       	mov    $0x1,%edi
  800a6a:	eb c7                	jmp    800a33 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a70:	74 0e                	je     800a80 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a72:	85 db                	test   %ebx,%ebx
  800a74:	75 d8                	jne    800a4e <strtol+0x44>
		s++, base = 8;
  800a76:	83 c1 01             	add    $0x1,%ecx
  800a79:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a7e:	eb ce                	jmp    800a4e <strtol+0x44>
		s += 2, base = 16;
  800a80:	83 c1 02             	add    $0x2,%ecx
  800a83:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a88:	eb c4                	jmp    800a4e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a8a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a8d:	89 f3                	mov    %esi,%ebx
  800a8f:	80 fb 19             	cmp    $0x19,%bl
  800a92:	77 29                	ja     800abd <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a94:	0f be d2             	movsbl %dl,%edx
  800a97:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a9a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a9d:	7d 30                	jge    800acf <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a9f:	83 c1 01             	add    $0x1,%ecx
  800aa2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aa8:	0f b6 11             	movzbl (%ecx),%edx
  800aab:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aae:	89 f3                	mov    %esi,%ebx
  800ab0:	80 fb 09             	cmp    $0x9,%bl
  800ab3:	77 d5                	ja     800a8a <strtol+0x80>
			dig = *s - '0';
  800ab5:	0f be d2             	movsbl %dl,%edx
  800ab8:	83 ea 30             	sub    $0x30,%edx
  800abb:	eb dd                	jmp    800a9a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800abd:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac0:	89 f3                	mov    %esi,%ebx
  800ac2:	80 fb 19             	cmp    $0x19,%bl
  800ac5:	77 08                	ja     800acf <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ac7:	0f be d2             	movsbl %dl,%edx
  800aca:	83 ea 37             	sub    $0x37,%edx
  800acd:	eb cb                	jmp    800a9a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad3:	74 05                	je     800ada <strtol+0xd0>
		*endptr = (char *) s;
  800ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ada:	89 c2                	mov    %eax,%edx
  800adc:	f7 da                	neg    %edx
  800ade:	85 ff                	test   %edi,%edi
  800ae0:	0f 45 c2             	cmovne %edx,%eax
}
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5f                   	pop    %edi
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
    asm volatile("int %1\n"
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	8b 55 08             	mov    0x8(%ebp),%edx
  800af6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af9:	89 c3                	mov    %eax,%ebx
  800afb:	89 c7                	mov    %eax,%edi
  800afd:	89 c6                	mov    %eax,%esi
  800aff:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <sys_cgetc>:

int
sys_cgetc(void) {
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b11:	b8 01 00 00 00       	mov    $0x1,%eax
  800b16:	89 d1                	mov    %edx,%ecx
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	89 d7                	mov    %edx,%edi
  800b1c:	89 d6                	mov    %edx,%esi
  800b1e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5f                   	pop    %edi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	57                   	push   %edi
  800b29:	56                   	push   %esi
  800b2a:	53                   	push   %ebx
  800b2b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b33:	8b 55 08             	mov    0x8(%ebp),%edx
  800b36:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3b:	89 cb                	mov    %ecx,%ebx
  800b3d:	89 cf                	mov    %ecx,%edi
  800b3f:	89 ce                	mov    %ecx,%esi
  800b41:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b43:	85 c0                	test   %eax,%eax
  800b45:	7f 08                	jg     800b4f <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b4f:	83 ec 0c             	sub    $0xc,%esp
  800b52:	50                   	push   %eax
  800b53:	6a 03                	push   $0x3
  800b55:	68 44 12 80 00       	push   $0x801244
  800b5a:	6a 24                	push   $0x24
  800b5c:	68 61 12 80 00       	push   $0x801261
  800b61:	e8 ed 01 00 00       	call   800d53 <_panic>

00800b66 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b71:	b8 02 00 00 00       	mov    $0x2,%eax
  800b76:	89 d1                	mov    %edx,%ecx
  800b78:	89 d3                	mov    %edx,%ebx
  800b7a:	89 d7                	mov    %edx,%edi
  800b7c:	89 d6                	mov    %edx,%esi
  800b7e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5f                   	pop    %edi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <sys_yield>:

void
sys_yield(void)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	57                   	push   %edi
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b95:	89 d1                	mov    %edx,%ecx
  800b97:	89 d3                	mov    %edx,%ebx
  800b99:	89 d7                	mov    %edx,%edi
  800b9b:	89 d6                	mov    %edx,%esi
  800b9d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
  800baa:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bad:	be 00 00 00 00       	mov    $0x0,%esi
  800bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc0:	89 f7                	mov    %esi,%edi
  800bc2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bc4:	85 c0                	test   %eax,%eax
  800bc6:	7f 08                	jg     800bd0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	50                   	push   %eax
  800bd4:	6a 04                	push   $0x4
  800bd6:	68 44 12 80 00       	push   $0x801244
  800bdb:	6a 24                	push   $0x24
  800bdd:	68 61 12 80 00       	push   $0x801261
  800be2:	e8 6c 01 00 00       	call   800d53 <_panic>

00800be7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf6:	b8 05 00 00 00       	mov    $0x5,%eax
  800bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c01:	8b 75 18             	mov    0x18(%ebp),%esi
  800c04:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c06:	85 c0                	test   %eax,%eax
  800c08:	7f 08                	jg     800c12 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c12:	83 ec 0c             	sub    $0xc,%esp
  800c15:	50                   	push   %eax
  800c16:	6a 05                	push   $0x5
  800c18:	68 44 12 80 00       	push   $0x801244
  800c1d:	6a 24                	push   $0x24
  800c1f:	68 61 12 80 00       	push   $0x801261
  800c24:	e8 2a 01 00 00       	call   800d53 <_panic>

00800c29 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
  800c2f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c37:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c42:	89 df                	mov    %ebx,%edi
  800c44:	89 de                	mov    %ebx,%esi
  800c46:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	7f 08                	jg     800c54 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c54:	83 ec 0c             	sub    $0xc,%esp
  800c57:	50                   	push   %eax
  800c58:	6a 06                	push   $0x6
  800c5a:	68 44 12 80 00       	push   $0x801244
  800c5f:	6a 24                	push   $0x24
  800c61:	68 61 12 80 00       	push   $0x801261
  800c66:	e8 e8 00 00 00       	call   800d53 <_panic>

00800c6b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
  800c71:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c84:	89 df                	mov    %ebx,%edi
  800c86:	89 de                	mov    %ebx,%esi
  800c88:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7f 08                	jg     800c96 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	50                   	push   %eax
  800c9a:	6a 08                	push   $0x8
  800c9c:	68 44 12 80 00       	push   $0x801244
  800ca1:	6a 24                	push   $0x24
  800ca3:	68 61 12 80 00       	push   $0x801261
  800ca8:	e8 a6 00 00 00       	call   800d53 <_panic>

00800cad <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc6:	89 df                	mov    %ebx,%edi
  800cc8:	89 de                	mov    %ebx,%esi
  800cca:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7f 08                	jg     800cd8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd8:	83 ec 0c             	sub    $0xc,%esp
  800cdb:	50                   	push   %eax
  800cdc:	6a 09                	push   $0x9
  800cde:	68 44 12 80 00       	push   $0x801244
  800ce3:	6a 24                	push   $0x24
  800ce5:	68 61 12 80 00       	push   $0x801261
  800cea:	e8 64 00 00 00       	call   800d53 <_panic>

00800cef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d00:	be 00 00 00 00       	mov    $0x0,%esi
  800d05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d08:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d28:	89 cb                	mov    %ecx,%ebx
  800d2a:	89 cf                	mov    %ecx,%edi
  800d2c:	89 ce                	mov    %ecx,%esi
  800d2e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d3c:	83 ec 0c             	sub    $0xc,%esp
  800d3f:	50                   	push   %eax
  800d40:	6a 0c                	push   $0xc
  800d42:	68 44 12 80 00       	push   $0x801244
  800d47:	6a 24                	push   $0x24
  800d49:	68 61 12 80 00       	push   $0x801261
  800d4e:	e8 00 00 00 00       	call   800d53 <_panic>

00800d53 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d58:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d5b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d61:	e8 00 fe ff ff       	call   800b66 <sys_getenvid>
  800d66:	83 ec 0c             	sub    $0xc,%esp
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	56                   	push   %esi
  800d70:	50                   	push   %eax
  800d71:	68 70 12 80 00       	push   $0x801270
  800d76:	e8 d2 f3 ff ff       	call   80014d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d7b:	83 c4 18             	add    $0x18,%esp
  800d7e:	53                   	push   %ebx
  800d7f:	ff 75 10             	pushl  0x10(%ebp)
  800d82:	e8 75 f3 ff ff       	call   8000fc <vcprintf>
	cprintf("\n");
  800d87:	c7 04 24 ec 0f 80 00 	movl   $0x800fec,(%esp)
  800d8e:	e8 ba f3 ff ff       	call   80014d <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d96:	cc                   	int3   
  800d97:	eb fd                	jmp    800d96 <_panic+0x43>
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
