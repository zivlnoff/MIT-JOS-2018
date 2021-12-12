
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
  800056:	e8 e2 00 00 00       	call   80013d <cprintf>
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
  800063:	83 ec 08             	sub    $0x8,%esp
  800066:	8b 45 08             	mov    0x8(%ebp),%eax
  800069:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80006c:	c7 05 08 20 80 00 00 	movl   $0xeec00000,0x802008
  800073:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 c0                	test   %eax,%eax
  800078:	7e 08                	jle    800082 <libmain+0x22>
		binaryname = argv[0];
  80007a:	8b 0a                	mov    (%edx),%ecx
  80007c:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	52                   	push   %edx
  800086:	50                   	push   %eax
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 05 00 00 00       	call   800096 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80009c:	6a 00                	push   $0x0
  80009e:	e8 72 0a 00 00       	call   800b15 <sys_env_destroy>
}
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	c9                   	leave  
  8000a7:	c3                   	ret    

008000a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	53                   	push   %ebx
  8000ac:	83 ec 04             	sub    $0x4,%esp
  8000af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b2:	8b 13                	mov    (%ebx),%edx
  8000b4:	8d 42 01             	lea    0x1(%edx),%eax
  8000b7:	89 03                	mov    %eax,(%ebx)
  8000b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000c5:	74 09                	je     8000d0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ce:	c9                   	leave  
  8000cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	68 ff 00 00 00       	push   $0xff
  8000d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8000db:	50                   	push   %eax
  8000dc:	e8 f7 09 00 00       	call   800ad8 <sys_cputs>
		b->idx = 0;
  8000e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	eb db                	jmp    8000c7 <putch+0x1f>

008000ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000fc:	00 00 00 
	b.cnt = 0;
  8000ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800106:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800109:	ff 75 0c             	pushl  0xc(%ebp)
  80010c:	ff 75 08             	pushl  0x8(%ebp)
  80010f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800115:	50                   	push   %eax
  800116:	68 a8 00 80 00       	push   $0x8000a8
  80011b:	e8 1a 01 00 00       	call   80023a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800120:	83 c4 08             	add    $0x8,%esp
  800123:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800129:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80012f:	50                   	push   %eax
  800130:	e8 a3 09 00 00       	call   800ad8 <sys_cputs>

	return b.cnt;
}
  800135:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    

0080013d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800143:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800146:	50                   	push   %eax
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	e8 9d ff ff ff       	call   8000ec <vcprintf>
	va_end(ap);

	return cnt;
}
  80014f:	c9                   	leave  
  800150:	c3                   	ret    

00800151 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
  800157:	83 ec 1c             	sub    $0x1c,%esp
  80015a:	89 c7                	mov    %eax,%edi
  80015c:	89 d6                	mov    %edx,%esi
  80015e:	8b 45 08             	mov    0x8(%ebp),%eax
  800161:	8b 55 0c             	mov    0xc(%ebp),%edx
  800164:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800167:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80016a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80016d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800172:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800175:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800178:	39 d3                	cmp    %edx,%ebx
  80017a:	72 05                	jb     800181 <printnum+0x30>
  80017c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80017f:	77 7a                	ja     8001fb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 18             	pushl  0x18(%ebp)
  800187:	8b 45 14             	mov    0x14(%ebp),%eax
  80018a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80018d:	53                   	push   %ebx
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 e4             	pushl  -0x1c(%ebp)
  800197:	ff 75 e0             	pushl  -0x20(%ebp)
  80019a:	ff 75 dc             	pushl  -0x24(%ebp)
  80019d:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a0:	e8 eb 0b 00 00       	call   800d90 <__udivdi3>
  8001a5:	83 c4 18             	add    $0x18,%esp
  8001a8:	52                   	push   %edx
  8001a9:	50                   	push   %eax
  8001aa:	89 f2                	mov    %esi,%edx
  8001ac:	89 f8                	mov    %edi,%eax
  8001ae:	e8 9e ff ff ff       	call   800151 <printnum>
  8001b3:	83 c4 20             	add    $0x20,%esp
  8001b6:	eb 13                	jmp    8001cb <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	56                   	push   %esi
  8001bc:	ff 75 18             	pushl  0x18(%ebp)
  8001bf:	ff d7                	call   *%edi
  8001c1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001c4:	83 eb 01             	sub    $0x1,%ebx
  8001c7:	85 db                	test   %ebx,%ebx
  8001c9:	7f ed                	jg     8001b8 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	56                   	push   %esi
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001db:	ff 75 d8             	pushl  -0x28(%ebp)
  8001de:	e8 cd 0c 00 00       	call   800eb0 <__umoddi3>
  8001e3:	83 c4 14             	add    $0x14,%esp
  8001e6:	0f be 80 f8 0f 80 00 	movsbl 0x800ff8(%eax),%eax
  8001ed:	50                   	push   %eax
  8001ee:	ff d7                	call   *%edi
}
  8001f0:	83 c4 10             	add    $0x10,%esp
  8001f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f6:	5b                   	pop    %ebx
  8001f7:	5e                   	pop    %esi
  8001f8:	5f                   	pop    %edi
  8001f9:	5d                   	pop    %ebp
  8001fa:	c3                   	ret    
  8001fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001fe:	eb c4                	jmp    8001c4 <printnum+0x73>

00800200 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800206:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80020a:	8b 10                	mov    (%eax),%edx
  80020c:	3b 50 04             	cmp    0x4(%eax),%edx
  80020f:	73 0a                	jae    80021b <sprintputch+0x1b>
		*b->buf++ = ch;
  800211:	8d 4a 01             	lea    0x1(%edx),%ecx
  800214:	89 08                	mov    %ecx,(%eax)
  800216:	8b 45 08             	mov    0x8(%ebp),%eax
  800219:	88 02                	mov    %al,(%edx)
}
  80021b:	5d                   	pop    %ebp
  80021c:	c3                   	ret    

0080021d <printfmt>:
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800223:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800226:	50                   	push   %eax
  800227:	ff 75 10             	pushl  0x10(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 05 00 00 00       	call   80023a <vprintfmt>
}
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <vprintfmt>:
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	57                   	push   %edi
  80023e:	56                   	push   %esi
  80023f:	53                   	push   %ebx
  800240:	83 ec 2c             	sub    $0x2c,%esp
  800243:	8b 75 08             	mov    0x8(%ebp),%esi
  800246:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800249:	8b 7d 10             	mov    0x10(%ebp),%edi
  80024c:	e9 00 04 00 00       	jmp    800651 <vprintfmt+0x417>
		padc = ' ';
  800251:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800255:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80025c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800263:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80026a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80026f:	8d 47 01             	lea    0x1(%edi),%eax
  800272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800275:	0f b6 17             	movzbl (%edi),%edx
  800278:	8d 42 dd             	lea    -0x23(%edx),%eax
  80027b:	3c 55                	cmp    $0x55,%al
  80027d:	0f 87 51 04 00 00    	ja     8006d4 <vprintfmt+0x49a>
  800283:	0f b6 c0             	movzbl %al,%eax
  800286:	ff 24 85 c0 10 80 00 	jmp    *0x8010c0(,%eax,4)
  80028d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800290:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800294:	eb d9                	jmp    80026f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800296:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800299:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80029d:	eb d0                	jmp    80026f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80029f:	0f b6 d2             	movzbl %dl,%edx
  8002a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002b0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002b4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002b7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ba:	83 f9 09             	cmp    $0x9,%ecx
  8002bd:	77 55                	ja     800314 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002bf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002c2:	eb e9                	jmp    8002ad <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c7:	8b 00                	mov    (%eax),%eax
  8002c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cf:	8d 40 04             	lea    0x4(%eax),%eax
  8002d2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002dc:	79 91                	jns    80026f <vprintfmt+0x35>
				width = precision, precision = -1;
  8002de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002eb:	eb 82                	jmp    80026f <vprintfmt+0x35>
  8002ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f7:	0f 49 d0             	cmovns %eax,%edx
  8002fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800300:	e9 6a ff ff ff       	jmp    80026f <vprintfmt+0x35>
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800308:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80030f:	e9 5b ff ff ff       	jmp    80026f <vprintfmt+0x35>
  800314:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800317:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031a:	eb bc                	jmp    8002d8 <vprintfmt+0x9e>
			lflag++;
  80031c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800322:	e9 48 ff ff ff       	jmp    80026f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800327:	8b 45 14             	mov    0x14(%ebp),%eax
  80032a:	8d 78 04             	lea    0x4(%eax),%edi
  80032d:	83 ec 08             	sub    $0x8,%esp
  800330:	53                   	push   %ebx
  800331:	ff 30                	pushl  (%eax)
  800333:	ff d6                	call   *%esi
			break;
  800335:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800338:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80033b:	e9 0e 03 00 00       	jmp    80064e <vprintfmt+0x414>
			err = va_arg(ap, int);
  800340:	8b 45 14             	mov    0x14(%ebp),%eax
  800343:	8d 78 04             	lea    0x4(%eax),%edi
  800346:	8b 00                	mov    (%eax),%eax
  800348:	99                   	cltd   
  800349:	31 d0                	xor    %edx,%eax
  80034b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80034d:	83 f8 08             	cmp    $0x8,%eax
  800350:	7f 23                	jg     800375 <vprintfmt+0x13b>
  800352:	8b 14 85 20 12 80 00 	mov    0x801220(,%eax,4),%edx
  800359:	85 d2                	test   %edx,%edx
  80035b:	74 18                	je     800375 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80035d:	52                   	push   %edx
  80035e:	68 19 10 80 00       	push   $0x801019
  800363:	53                   	push   %ebx
  800364:	56                   	push   %esi
  800365:	e8 b3 fe ff ff       	call   80021d <printfmt>
  80036a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80036d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800370:	e9 d9 02 00 00       	jmp    80064e <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800375:	50                   	push   %eax
  800376:	68 10 10 80 00       	push   $0x801010
  80037b:	53                   	push   %ebx
  80037c:	56                   	push   %esi
  80037d:	e8 9b fe ff ff       	call   80021d <printfmt>
  800382:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800385:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800388:	e9 c1 02 00 00       	jmp    80064e <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	83 c0 04             	add    $0x4,%eax
  800393:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800396:	8b 45 14             	mov    0x14(%ebp),%eax
  800399:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80039b:	85 ff                	test   %edi,%edi
  80039d:	b8 09 10 80 00       	mov    $0x801009,%eax
  8003a2:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a9:	0f 8e bd 00 00 00    	jle    80046c <vprintfmt+0x232>
  8003af:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003b3:	75 0e                	jne    8003c3 <vprintfmt+0x189>
  8003b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003bb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003be:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003c1:	eb 6d                	jmp    800430 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	ff 75 d0             	pushl  -0x30(%ebp)
  8003c9:	57                   	push   %edi
  8003ca:	e8 ad 03 00 00       	call   80077c <strnlen>
  8003cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003d2:	29 c1                	sub    %eax,%ecx
  8003d4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003d7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003da:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003e4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e6:	eb 0f                	jmp    8003f7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ef:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f1:	83 ef 01             	sub    $0x1,%edi
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	85 ff                	test   %edi,%edi
  8003f9:	7f ed                	jg     8003e8 <vprintfmt+0x1ae>
  8003fb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8003fe:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800401:	85 c9                	test   %ecx,%ecx
  800403:	b8 00 00 00 00       	mov    $0x0,%eax
  800408:	0f 49 c1             	cmovns %ecx,%eax
  80040b:	29 c1                	sub    %eax,%ecx
  80040d:	89 75 08             	mov    %esi,0x8(%ebp)
  800410:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800413:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800416:	89 cb                	mov    %ecx,%ebx
  800418:	eb 16                	jmp    800430 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80041a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80041e:	75 31                	jne    800451 <vprintfmt+0x217>
					putch(ch, putdat);
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	ff 75 0c             	pushl  0xc(%ebp)
  800426:	50                   	push   %eax
  800427:	ff 55 08             	call   *0x8(%ebp)
  80042a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80042d:	83 eb 01             	sub    $0x1,%ebx
  800430:	83 c7 01             	add    $0x1,%edi
  800433:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800437:	0f be c2             	movsbl %dl,%eax
  80043a:	85 c0                	test   %eax,%eax
  80043c:	74 59                	je     800497 <vprintfmt+0x25d>
  80043e:	85 f6                	test   %esi,%esi
  800440:	78 d8                	js     80041a <vprintfmt+0x1e0>
  800442:	83 ee 01             	sub    $0x1,%esi
  800445:	79 d3                	jns    80041a <vprintfmt+0x1e0>
  800447:	89 df                	mov    %ebx,%edi
  800449:	8b 75 08             	mov    0x8(%ebp),%esi
  80044c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80044f:	eb 37                	jmp    800488 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800451:	0f be d2             	movsbl %dl,%edx
  800454:	83 ea 20             	sub    $0x20,%edx
  800457:	83 fa 5e             	cmp    $0x5e,%edx
  80045a:	76 c4                	jbe    800420 <vprintfmt+0x1e6>
					putch('?', putdat);
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	6a 3f                	push   $0x3f
  800464:	ff 55 08             	call   *0x8(%ebp)
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	eb c1                	jmp    80042d <vprintfmt+0x1f3>
  80046c:	89 75 08             	mov    %esi,0x8(%ebp)
  80046f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800472:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800475:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800478:	eb b6                	jmp    800430 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	53                   	push   %ebx
  80047e:	6a 20                	push   $0x20
  800480:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800482:	83 ef 01             	sub    $0x1,%edi
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	85 ff                	test   %edi,%edi
  80048a:	7f ee                	jg     80047a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80048c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80048f:	89 45 14             	mov    %eax,0x14(%ebp)
  800492:	e9 b7 01 00 00       	jmp    80064e <vprintfmt+0x414>
  800497:	89 df                	mov    %ebx,%edi
  800499:	8b 75 08             	mov    0x8(%ebp),%esi
  80049c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80049f:	eb e7                	jmp    800488 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004a1:	83 f9 01             	cmp    $0x1,%ecx
  8004a4:	7e 3f                	jle    8004e5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8b 50 04             	mov    0x4(%eax),%edx
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	8d 40 08             	lea    0x8(%eax),%eax
  8004ba:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c1:	79 5c                	jns    80051f <vprintfmt+0x2e5>
				putch('-', putdat);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	53                   	push   %ebx
  8004c7:	6a 2d                	push   $0x2d
  8004c9:	ff d6                	call   *%esi
				num = -(long long) num;
  8004cb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004ce:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004d1:	f7 da                	neg    %edx
  8004d3:	83 d1 00             	adc    $0x0,%ecx
  8004d6:	f7 d9                	neg    %ecx
  8004d8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004e0:	e9 4f 01 00 00       	jmp    800634 <vprintfmt+0x3fa>
	else if (lflag)
  8004e5:	85 c9                	test   %ecx,%ecx
  8004e7:	75 1b                	jne    800504 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f1:	89 c1                	mov    %eax,%ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 40 04             	lea    0x4(%eax),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	eb b9                	jmp    8004bd <vprintfmt+0x283>
		return va_arg(*ap, long);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050c:	89 c1                	mov    %eax,%ecx
  80050e:	c1 f9 1f             	sar    $0x1f,%ecx
  800511:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 40 04             	lea    0x4(%eax),%eax
  80051a:	89 45 14             	mov    %eax,0x14(%ebp)
  80051d:	eb 9e                	jmp    8004bd <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80051f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800522:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800525:	b8 0a 00 00 00       	mov    $0xa,%eax
  80052a:	e9 05 01 00 00       	jmp    800634 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80052f:	83 f9 01             	cmp    $0x1,%ecx
  800532:	7e 18                	jle    80054c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 10                	mov    (%eax),%edx
  800539:	8b 48 04             	mov    0x4(%eax),%ecx
  80053c:	8d 40 08             	lea    0x8(%eax),%eax
  80053f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800542:	b8 0a 00 00 00       	mov    $0xa,%eax
  800547:	e9 e8 00 00 00       	jmp    800634 <vprintfmt+0x3fa>
	else if (lflag)
  80054c:	85 c9                	test   %ecx,%ecx
  80054e:	75 1a                	jne    80056a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8b 10                	mov    (%eax),%edx
  800555:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055a:	8d 40 04             	lea    0x4(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800560:	b8 0a 00 00 00       	mov    $0xa,%eax
  800565:	e9 ca 00 00 00       	jmp    800634 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8b 10                	mov    (%eax),%edx
  80056f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	e9 b0 00 00 00       	jmp    800634 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7e 3c                	jle    8005c5 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800594:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 40 08             	lea    0x8(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a4:	79 59                	jns    8005ff <vprintfmt+0x3c5>
                putch('-', putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	53                   	push   %ebx
  8005aa:	6a 2d                	push   $0x2d
  8005ac:	ff d6                	call   *%esi
                num = -(long long) num;
  8005ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b4:	f7 da                	neg    %edx
  8005b6:	83 d1 00             	adc    $0x0,%ecx
  8005b9:	f7 d9                	neg    %ecx
  8005bb:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005be:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c3:	eb 6f                	jmp    800634 <vprintfmt+0x3fa>
	else if (lflag)
  8005c5:	85 c9                	test   %ecx,%ecx
  8005c7:	75 1b                	jne    8005e4 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	89 c1                	mov    %eax,%ecx
  8005d3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	eb bc                	jmp    8005a0 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ec:	89 c1                	mov    %eax,%ecx
  8005ee:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb a1                	jmp    8005a0 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8005ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800602:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800605:	b8 08 00 00 00       	mov    $0x8,%eax
  80060a:	eb 28                	jmp    800634 <vprintfmt+0x3fa>
			putch('0', putdat);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	53                   	push   %ebx
  800610:	6a 30                	push   $0x30
  800612:	ff d6                	call   *%esi
			putch('x', putdat);
  800614:	83 c4 08             	add    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	6a 78                	push   $0x78
  80061a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 10                	mov    (%eax),%edx
  800621:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800626:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800634:	83 ec 0c             	sub    $0xc,%esp
  800637:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80063b:	57                   	push   %edi
  80063c:	ff 75 e0             	pushl  -0x20(%ebp)
  80063f:	50                   	push   %eax
  800640:	51                   	push   %ecx
  800641:	52                   	push   %edx
  800642:	89 da                	mov    %ebx,%edx
  800644:	89 f0                	mov    %esi,%eax
  800646:	e8 06 fb ff ff       	call   800151 <printnum>
			break;
  80064b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80064e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800651:	83 c7 01             	add    $0x1,%edi
  800654:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800658:	83 f8 25             	cmp    $0x25,%eax
  80065b:	0f 84 f0 fb ff ff    	je     800251 <vprintfmt+0x17>
			if (ch == '\0')
  800661:	85 c0                	test   %eax,%eax
  800663:	0f 84 8b 00 00 00    	je     8006f4 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	53                   	push   %ebx
  80066d:	50                   	push   %eax
  80066e:	ff d6                	call   *%esi
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	eb dc                	jmp    800651 <vprintfmt+0x417>
	if (lflag >= 2)
  800675:	83 f9 01             	cmp    $0x1,%ecx
  800678:	7e 15                	jle    80068f <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	8b 48 04             	mov    0x4(%eax),%ecx
  800682:	8d 40 08             	lea    0x8(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800688:	b8 10 00 00 00       	mov    $0x10,%eax
  80068d:	eb a5                	jmp    800634 <vprintfmt+0x3fa>
	else if (lflag)
  80068f:	85 c9                	test   %ecx,%ecx
  800691:	75 17                	jne    8006aa <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 10                	mov    (%eax),%edx
  800698:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a8:	eb 8a                	jmp    800634 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 10                	mov    (%eax),%edx
  8006af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ba:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bf:	e9 70 ff ff ff       	jmp    800634 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 25                	push   $0x25
  8006ca:	ff d6                	call   *%esi
			break;
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	e9 7a ff ff ff       	jmp    80064e <vprintfmt+0x414>
			putch('%', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 25                	push   $0x25
  8006da:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	89 f8                	mov    %edi,%eax
  8006e1:	eb 03                	jmp    8006e6 <vprintfmt+0x4ac>
  8006e3:	83 e8 01             	sub    $0x1,%eax
  8006e6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ea:	75 f7                	jne    8006e3 <vprintfmt+0x4a9>
  8006ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ef:	e9 5a ff ff ff       	jmp    80064e <vprintfmt+0x414>
}
  8006f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f7:	5b                   	pop    %ebx
  8006f8:	5e                   	pop    %esi
  8006f9:	5f                   	pop    %edi
  8006fa:	5d                   	pop    %ebp
  8006fb:	c3                   	ret    

008006fc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	83 ec 18             	sub    $0x18,%esp
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800708:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80070b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80070f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800712:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800719:	85 c0                	test   %eax,%eax
  80071b:	74 26                	je     800743 <vsnprintf+0x47>
  80071d:	85 d2                	test   %edx,%edx
  80071f:	7e 22                	jle    800743 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800721:	ff 75 14             	pushl  0x14(%ebp)
  800724:	ff 75 10             	pushl  0x10(%ebp)
  800727:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072a:	50                   	push   %eax
  80072b:	68 00 02 80 00       	push   $0x800200
  800730:	e8 05 fb ff ff       	call   80023a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	c9                   	leave  
  800742:	c3                   	ret    
		return -E_INVAL;
  800743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800748:	eb f7                	jmp    800741 <vsnprintf+0x45>

0080074a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800750:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800753:	50                   	push   %eax
  800754:	ff 75 10             	pushl  0x10(%ebp)
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	ff 75 08             	pushl  0x8(%ebp)
  80075d:	e8 9a ff ff ff       	call   8006fc <vsnprintf>
	va_end(ap);

	return rc;
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076a:	b8 00 00 00 00       	mov    $0x0,%eax
  80076f:	eb 03                	jmp    800774 <strlen+0x10>
		n++;
  800771:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800774:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800778:	75 f7                	jne    800771 <strlen+0xd>
	return n;
}
  80077a:	5d                   	pop    %ebp
  80077b:	c3                   	ret    

0080077c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800782:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800785:	b8 00 00 00 00       	mov    $0x0,%eax
  80078a:	eb 03                	jmp    80078f <strnlen+0x13>
		n++;
  80078c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078f:	39 d0                	cmp    %edx,%eax
  800791:	74 06                	je     800799 <strnlen+0x1d>
  800793:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800797:	75 f3                	jne    80078c <strnlen+0x10>
	return n;
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	83 c1 01             	add    $0x1,%ecx
  8007aa:	83 c2 01             	add    $0x1,%edx
  8007ad:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007b1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b4:	84 db                	test   %bl,%bl
  8007b6:	75 ef                	jne    8007a7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b8:	5b                   	pop    %ebx
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	53                   	push   %ebx
  8007bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c2:	53                   	push   %ebx
  8007c3:	e8 9c ff ff ff       	call   800764 <strlen>
  8007c8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	01 d8                	add    %ebx,%eax
  8007d0:	50                   	push   %eax
  8007d1:	e8 c5 ff ff ff       	call   80079b <strcpy>
	return dst;
}
  8007d6:	89 d8                	mov    %ebx,%eax
  8007d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	56                   	push   %esi
  8007e1:	53                   	push   %ebx
  8007e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e8:	89 f3                	mov    %esi,%ebx
  8007ea:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007ed:	89 f2                	mov    %esi,%edx
  8007ef:	eb 0f                	jmp    800800 <strncpy+0x23>
		*dst++ = *src;
  8007f1:	83 c2 01             	add    $0x1,%edx
  8007f4:	0f b6 01             	movzbl (%ecx),%eax
  8007f7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007fa:	80 39 01             	cmpb   $0x1,(%ecx)
  8007fd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800800:	39 da                	cmp    %ebx,%edx
  800802:	75 ed                	jne    8007f1 <strncpy+0x14>
	}
	return ret;
}
  800804:	89 f0                	mov    %esi,%eax
  800806:	5b                   	pop    %ebx
  800807:	5e                   	pop    %esi
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	56                   	push   %esi
  80080e:	53                   	push   %ebx
  80080f:	8b 75 08             	mov    0x8(%ebp),%esi
  800812:	8b 55 0c             	mov    0xc(%ebp),%edx
  800815:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800818:	89 f0                	mov    %esi,%eax
  80081a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80081e:	85 c9                	test   %ecx,%ecx
  800820:	75 0b                	jne    80082d <strlcpy+0x23>
  800822:	eb 17                	jmp    80083b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800824:	83 c2 01             	add    $0x1,%edx
  800827:	83 c0 01             	add    $0x1,%eax
  80082a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80082d:	39 d8                	cmp    %ebx,%eax
  80082f:	74 07                	je     800838 <strlcpy+0x2e>
  800831:	0f b6 0a             	movzbl (%edx),%ecx
  800834:	84 c9                	test   %cl,%cl
  800836:	75 ec                	jne    800824 <strlcpy+0x1a>
		*dst = '\0';
  800838:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80083b:	29 f0                	sub    %esi,%eax
}
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5d                   	pop    %ebp
  800840:	c3                   	ret    

00800841 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084a:	eb 06                	jmp    800852 <strcmp+0x11>
		p++, q++;
  80084c:	83 c1 01             	add    $0x1,%ecx
  80084f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800852:	0f b6 01             	movzbl (%ecx),%eax
  800855:	84 c0                	test   %al,%al
  800857:	74 04                	je     80085d <strcmp+0x1c>
  800859:	3a 02                	cmp    (%edx),%al
  80085b:	74 ef                	je     80084c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80085d:	0f b6 c0             	movzbl %al,%eax
  800860:	0f b6 12             	movzbl (%edx),%edx
  800863:	29 d0                	sub    %edx,%eax
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800871:	89 c3                	mov    %eax,%ebx
  800873:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800876:	eb 06                	jmp    80087e <strncmp+0x17>
		n--, p++, q++;
  800878:	83 c0 01             	add    $0x1,%eax
  80087b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80087e:	39 d8                	cmp    %ebx,%eax
  800880:	74 16                	je     800898 <strncmp+0x31>
  800882:	0f b6 08             	movzbl (%eax),%ecx
  800885:	84 c9                	test   %cl,%cl
  800887:	74 04                	je     80088d <strncmp+0x26>
  800889:	3a 0a                	cmp    (%edx),%cl
  80088b:	74 eb                	je     800878 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80088d:	0f b6 00             	movzbl (%eax),%eax
  800890:	0f b6 12             	movzbl (%edx),%edx
  800893:	29 d0                	sub    %edx,%eax
}
  800895:	5b                   	pop    %ebx
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    
		return 0;
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
  80089d:	eb f6                	jmp    800895 <strncmp+0x2e>

0080089f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a9:	0f b6 10             	movzbl (%eax),%edx
  8008ac:	84 d2                	test   %dl,%dl
  8008ae:	74 09                	je     8008b9 <strchr+0x1a>
		if (*s == c)
  8008b0:	38 ca                	cmp    %cl,%dl
  8008b2:	74 0a                	je     8008be <strchr+0x1f>
	for (; *s; s++)
  8008b4:	83 c0 01             	add    $0x1,%eax
  8008b7:	eb f0                	jmp    8008a9 <strchr+0xa>
			return (char *) s;
	return 0;
  8008b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ca:	eb 03                	jmp    8008cf <strfind+0xf>
  8008cc:	83 c0 01             	add    $0x1,%eax
  8008cf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d2:	38 ca                	cmp    %cl,%dl
  8008d4:	74 04                	je     8008da <strfind+0x1a>
  8008d6:	84 d2                	test   %dl,%dl
  8008d8:	75 f2                	jne    8008cc <strfind+0xc>
			break;
	return (char *) s;
}
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	57                   	push   %edi
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
  8008e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e8:	85 c9                	test   %ecx,%ecx
  8008ea:	74 13                	je     8008ff <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ec:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f2:	75 05                	jne    8008f9 <memset+0x1d>
  8008f4:	f6 c1 03             	test   $0x3,%cl
  8008f7:	74 0d                	je     800906 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	fc                   	cld    
  8008fd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008ff:	89 f8                	mov    %edi,%eax
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5f                   	pop    %edi
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    
		c &= 0xFF;
  800906:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090a:	89 d3                	mov    %edx,%ebx
  80090c:	c1 e3 08             	shl    $0x8,%ebx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 18             	shl    $0x18,%eax
  800914:	89 d6                	mov    %edx,%esi
  800916:	c1 e6 10             	shl    $0x10,%esi
  800919:	09 f0                	or     %esi,%eax
  80091b:	09 c2                	or     %eax,%edx
  80091d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80091f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800922:	89 d0                	mov    %edx,%eax
  800924:	fc                   	cld    
  800925:	f3 ab                	rep stos %eax,%es:(%edi)
  800927:	eb d6                	jmp    8008ff <memset+0x23>

00800929 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	57                   	push   %edi
  80092d:	56                   	push   %esi
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 75 0c             	mov    0xc(%ebp),%esi
  800934:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800937:	39 c6                	cmp    %eax,%esi
  800939:	73 35                	jae    800970 <memmove+0x47>
  80093b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80093e:	39 c2                	cmp    %eax,%edx
  800940:	76 2e                	jbe    800970 <memmove+0x47>
		s += n;
		d += n;
  800942:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800945:	89 d6                	mov    %edx,%esi
  800947:	09 fe                	or     %edi,%esi
  800949:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80094f:	74 0c                	je     80095d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800951:	83 ef 01             	sub    $0x1,%edi
  800954:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800957:	fd                   	std    
  800958:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80095a:	fc                   	cld    
  80095b:	eb 21                	jmp    80097e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095d:	f6 c1 03             	test   $0x3,%cl
  800960:	75 ef                	jne    800951 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800962:	83 ef 04             	sub    $0x4,%edi
  800965:	8d 72 fc             	lea    -0x4(%edx),%esi
  800968:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80096b:	fd                   	std    
  80096c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096e:	eb ea                	jmp    80095a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800970:	89 f2                	mov    %esi,%edx
  800972:	09 c2                	or     %eax,%edx
  800974:	f6 c2 03             	test   $0x3,%dl
  800977:	74 09                	je     800982 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800979:	89 c7                	mov    %eax,%edi
  80097b:	fc                   	cld    
  80097c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80097e:	5e                   	pop    %esi
  80097f:	5f                   	pop    %edi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800982:	f6 c1 03             	test   $0x3,%cl
  800985:	75 f2                	jne    800979 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800987:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80098a:	89 c7                	mov    %eax,%edi
  80098c:	fc                   	cld    
  80098d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098f:	eb ed                	jmp    80097e <memmove+0x55>

00800991 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800994:	ff 75 10             	pushl  0x10(%ebp)
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 87 ff ff ff       	call   800929 <memmove>
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	56                   	push   %esi
  8009a8:	53                   	push   %ebx
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009af:	89 c6                	mov    %eax,%esi
  8009b1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b4:	39 f0                	cmp    %esi,%eax
  8009b6:	74 1c                	je     8009d4 <memcmp+0x30>
		if (*s1 != *s2)
  8009b8:	0f b6 08             	movzbl (%eax),%ecx
  8009bb:	0f b6 1a             	movzbl (%edx),%ebx
  8009be:	38 d9                	cmp    %bl,%cl
  8009c0:	75 08                	jne    8009ca <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c2:	83 c0 01             	add    $0x1,%eax
  8009c5:	83 c2 01             	add    $0x1,%edx
  8009c8:	eb ea                	jmp    8009b4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009ca:	0f b6 c1             	movzbl %cl,%eax
  8009cd:	0f b6 db             	movzbl %bl,%ebx
  8009d0:	29 d8                	sub    %ebx,%eax
  8009d2:	eb 05                	jmp    8009d9 <memcmp+0x35>
	}

	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5b                   	pop    %ebx
  8009da:	5e                   	pop    %esi
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e6:	89 c2                	mov    %eax,%edx
  8009e8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009eb:	39 d0                	cmp    %edx,%eax
  8009ed:	73 09                	jae    8009f8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ef:	38 08                	cmp    %cl,(%eax)
  8009f1:	74 05                	je     8009f8 <memfind+0x1b>
	for (; s < ends; s++)
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	eb f3                	jmp    8009eb <memfind+0xe>
			break;
	return (void *) s;
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	57                   	push   %edi
  8009fe:	56                   	push   %esi
  8009ff:	53                   	push   %ebx
  800a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a06:	eb 03                	jmp    800a0b <strtol+0x11>
		s++;
  800a08:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a0b:	0f b6 01             	movzbl (%ecx),%eax
  800a0e:	3c 20                	cmp    $0x20,%al
  800a10:	74 f6                	je     800a08 <strtol+0xe>
  800a12:	3c 09                	cmp    $0x9,%al
  800a14:	74 f2                	je     800a08 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a16:	3c 2b                	cmp    $0x2b,%al
  800a18:	74 2e                	je     800a48 <strtol+0x4e>
	int neg = 0;
  800a1a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a1f:	3c 2d                	cmp    $0x2d,%al
  800a21:	74 2f                	je     800a52 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a23:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a29:	75 05                	jne    800a30 <strtol+0x36>
  800a2b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a2e:	74 2c                	je     800a5c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a30:	85 db                	test   %ebx,%ebx
  800a32:	75 0a                	jne    800a3e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a34:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a39:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3c:	74 28                	je     800a66 <strtol+0x6c>
		base = 10;
  800a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a43:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a46:	eb 50                	jmp    800a98 <strtol+0x9e>
		s++;
  800a48:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a50:	eb d1                	jmp    800a23 <strtol+0x29>
		s++, neg = 1;
  800a52:	83 c1 01             	add    $0x1,%ecx
  800a55:	bf 01 00 00 00       	mov    $0x1,%edi
  800a5a:	eb c7                	jmp    800a23 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a60:	74 0e                	je     800a70 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a62:	85 db                	test   %ebx,%ebx
  800a64:	75 d8                	jne    800a3e <strtol+0x44>
		s++, base = 8;
  800a66:	83 c1 01             	add    $0x1,%ecx
  800a69:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a6e:	eb ce                	jmp    800a3e <strtol+0x44>
		s += 2, base = 16;
  800a70:	83 c1 02             	add    $0x2,%ecx
  800a73:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a78:	eb c4                	jmp    800a3e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a7a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a7d:	89 f3                	mov    %esi,%ebx
  800a7f:	80 fb 19             	cmp    $0x19,%bl
  800a82:	77 29                	ja     800aad <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a84:	0f be d2             	movsbl %dl,%edx
  800a87:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a8d:	7d 30                	jge    800abf <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a8f:	83 c1 01             	add    $0x1,%ecx
  800a92:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a96:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a98:	0f b6 11             	movzbl (%ecx),%edx
  800a9b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a9e:	89 f3                	mov    %esi,%ebx
  800aa0:	80 fb 09             	cmp    $0x9,%bl
  800aa3:	77 d5                	ja     800a7a <strtol+0x80>
			dig = *s - '0';
  800aa5:	0f be d2             	movsbl %dl,%edx
  800aa8:	83 ea 30             	sub    $0x30,%edx
  800aab:	eb dd                	jmp    800a8a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800aad:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ab0:	89 f3                	mov    %esi,%ebx
  800ab2:	80 fb 19             	cmp    $0x19,%bl
  800ab5:	77 08                	ja     800abf <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab7:	0f be d2             	movsbl %dl,%edx
  800aba:	83 ea 37             	sub    $0x37,%edx
  800abd:	eb cb                	jmp    800a8a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac3:	74 05                	je     800aca <strtol+0xd0>
		*endptr = (char *) s;
  800ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aca:	89 c2                	mov    %eax,%edx
  800acc:	f7 da                	neg    %edx
  800ace:	85 ff                	test   %edi,%edi
  800ad0:	0f 45 c2             	cmovne %edx,%eax
}
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5f                   	pop    %edi
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ade:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae9:	89 c3                	mov    %eax,%ebx
  800aeb:	89 c7                	mov    %eax,%edi
  800aed:	89 c6                	mov    %eax,%esi
  800aef:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	5f                   	pop    %edi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <sys_cgetc>:

int
sys_cgetc(void) {
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	57                   	push   %edi
  800afa:	56                   	push   %esi
  800afb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800afc:	ba 00 00 00 00       	mov    $0x0,%edx
  800b01:	b8 01 00 00 00       	mov    $0x1,%eax
  800b06:	89 d1                	mov    %edx,%ecx
  800b08:	89 d3                	mov    %edx,%ebx
  800b0a:	89 d7                	mov    %edx,%edi
  800b0c:	89 d6                	mov    %edx,%esi
  800b0e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5f                   	pop    %edi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	57                   	push   %edi
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	b8 03 00 00 00       	mov    $0x3,%eax
  800b2b:	89 cb                	mov    %ecx,%ebx
  800b2d:	89 cf                	mov    %ecx,%edi
  800b2f:	89 ce                	mov    %ecx,%esi
  800b31:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b33:	85 c0                	test   %eax,%eax
  800b35:	7f 08                	jg     800b3f <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	50                   	push   %eax
  800b43:	6a 03                	push   $0x3
  800b45:	68 44 12 80 00       	push   $0x801244
  800b4a:	6a 24                	push   $0x24
  800b4c:	68 61 12 80 00       	push   $0x801261
  800b51:	e8 ed 01 00 00       	call   800d43 <_panic>

00800b56 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	b8 02 00 00 00       	mov    $0x2,%eax
  800b66:	89 d1                	mov    %edx,%ecx
  800b68:	89 d3                	mov    %edx,%ebx
  800b6a:	89 d7                	mov    %edx,%edi
  800b6c:	89 d6                	mov    %edx,%esi
  800b6e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <sys_yield>:

void
sys_yield(void)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b85:	89 d1                	mov    %edx,%ecx
  800b87:	89 d3                	mov    %edx,%ebx
  800b89:	89 d7                	mov    %edx,%edi
  800b8b:	89 d6                	mov    %edx,%esi
  800b8d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b9d:	be 00 00 00 00       	mov    $0x0,%esi
  800ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb0:	89 f7                	mov    %esi,%edi
  800bb2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bb4:	85 c0                	test   %eax,%eax
  800bb6:	7f 08                	jg     800bc0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbb:	5b                   	pop    %ebx
  800bbc:	5e                   	pop    %esi
  800bbd:	5f                   	pop    %edi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bc0:	83 ec 0c             	sub    $0xc,%esp
  800bc3:	50                   	push   %eax
  800bc4:	6a 04                	push   $0x4
  800bc6:	68 44 12 80 00       	push   $0x801244
  800bcb:	6a 24                	push   $0x24
  800bcd:	68 61 12 80 00       	push   $0x801261
  800bd2:	e8 6c 01 00 00       	call   800d43 <_panic>

00800bd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800be0:	8b 55 08             	mov    0x8(%ebp),%edx
  800be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be6:	b8 05 00 00 00       	mov    $0x5,%eax
  800beb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bf1:	8b 75 18             	mov    0x18(%ebp),%esi
  800bf4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bf6:	85 c0                	test   %eax,%eax
  800bf8:	7f 08                	jg     800c02 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c02:	83 ec 0c             	sub    $0xc,%esp
  800c05:	50                   	push   %eax
  800c06:	6a 05                	push   $0x5
  800c08:	68 44 12 80 00       	push   $0x801244
  800c0d:	6a 24                	push   $0x24
  800c0f:	68 61 12 80 00       	push   $0x801261
  800c14:	e8 2a 01 00 00       	call   800d43 <_panic>

00800c19 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c32:	89 df                	mov    %ebx,%edi
  800c34:	89 de                	mov    %ebx,%esi
  800c36:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c38:	85 c0                	test   %eax,%eax
  800c3a:	7f 08                	jg     800c44 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c44:	83 ec 0c             	sub    $0xc,%esp
  800c47:	50                   	push   %eax
  800c48:	6a 06                	push   $0x6
  800c4a:	68 44 12 80 00       	push   $0x801244
  800c4f:	6a 24                	push   $0x24
  800c51:	68 61 12 80 00       	push   $0x801261
  800c56:	e8 e8 00 00 00       	call   800d43 <_panic>

00800c5b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c74:	89 df                	mov    %ebx,%edi
  800c76:	89 de                	mov    %ebx,%esi
  800c78:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	7f 08                	jg     800c86 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	50                   	push   %eax
  800c8a:	6a 08                	push   $0x8
  800c8c:	68 44 12 80 00       	push   $0x801244
  800c91:	6a 24                	push   $0x24
  800c93:	68 61 12 80 00       	push   $0x801261
  800c98:	e8 a6 00 00 00       	call   800d43 <_panic>

00800c9d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ca6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 09 00 00 00       	mov    $0x9,%eax
  800cb6:	89 df                	mov    %ebx,%edi
  800cb8:	89 de                	mov    %ebx,%esi
  800cba:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7f 08                	jg     800cc8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cc8:	83 ec 0c             	sub    $0xc,%esp
  800ccb:	50                   	push   %eax
  800ccc:	6a 09                	push   $0x9
  800cce:	68 44 12 80 00       	push   $0x801244
  800cd3:	6a 24                	push   $0x24
  800cd5:	68 61 12 80 00       	push   $0x801261
  800cda:	e8 64 00 00 00       	call   800d43 <_panic>

00800cdf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf0:	be 00 00 00 00       	mov    $0x0,%esi
  800cf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d18:	89 cb                	mov    %ecx,%ebx
  800d1a:	89 cf                	mov    %ecx,%edi
  800d1c:	89 ce                	mov    %ecx,%esi
  800d1e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7f 08                	jg     800d2c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	50                   	push   %eax
  800d30:	6a 0c                	push   $0xc
  800d32:	68 44 12 80 00       	push   $0x801244
  800d37:	6a 24                	push   $0x24
  800d39:	68 61 12 80 00       	push   $0x801261
  800d3e:	e8 00 00 00 00       	call   800d43 <_panic>

00800d43 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d48:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d4b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d51:	e8 00 fe ff ff       	call   800b56 <sys_getenvid>
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	ff 75 0c             	pushl  0xc(%ebp)
  800d5c:	ff 75 08             	pushl  0x8(%ebp)
  800d5f:	56                   	push   %esi
  800d60:	50                   	push   %eax
  800d61:	68 70 12 80 00       	push   $0x801270
  800d66:	e8 d2 f3 ff ff       	call   80013d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d6b:	83 c4 18             	add    $0x18,%esp
  800d6e:	53                   	push   %ebx
  800d6f:	ff 75 10             	pushl  0x10(%ebp)
  800d72:	e8 75 f3 ff ff       	call   8000ec <vcprintf>
	cprintf("\n");
  800d77:	c7 04 24 ec 0f 80 00 	movl   $0x800fec,(%esp)
  800d7e:	e8 ba f3 ff ff       	call   80013d <cprintf>
  800d83:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d86:	cc                   	int3   
  800d87:	eb fd                	jmp    800d86 <_panic+0x43>
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
