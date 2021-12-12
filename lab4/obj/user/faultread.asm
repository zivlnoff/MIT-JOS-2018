
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
  80003f:	68 c0 0f 80 00       	push   $0x800fc0
  800044:	e8 e2 00 00 00       	call   80012b <cprintf>
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
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8b 45 08             	mov    0x8(%ebp),%eax
  800057:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80005a:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  800061:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 c0                	test   %eax,%eax
  800066:	7e 08                	jle    800070 <libmain+0x22>
		binaryname = argv[0];
  800068:	8b 0a                	mov    (%edx),%ecx
  80006a:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800070:	83 ec 08             	sub    $0x8,%esp
  800073:	52                   	push   %edx
  800074:	50                   	push   %eax
  800075:	e8 b9 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007a:	e8 05 00 00 00       	call   800084 <exit>
}
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	c9                   	leave  
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80008a:	6a 00                	push   $0x0
  80008c:	e8 72 0a 00 00       	call   800b03 <sys_env_destroy>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	53                   	push   %ebx
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000a0:	8b 13                	mov    (%ebx),%edx
  8000a2:	8d 42 01             	lea    0x1(%edx),%eax
  8000a5:	89 03                	mov    %eax,(%ebx)
  8000a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000b3:	74 09                	je     8000be <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	68 ff 00 00 00       	push   $0xff
  8000c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000c9:	50                   	push   %eax
  8000ca:	e8 f7 09 00 00       	call   800ac6 <sys_cputs>
		b->idx = 0;
  8000cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	eb db                	jmp    8000b5 <putch+0x1f>

008000da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000ea:	00 00 00 
	b.cnt = 0;
  8000ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000f7:	ff 75 0c             	pushl  0xc(%ebp)
  8000fa:	ff 75 08             	pushl  0x8(%ebp)
  8000fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800103:	50                   	push   %eax
  800104:	68 96 00 80 00       	push   $0x800096
  800109:	e8 1a 01 00 00       	call   800228 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800117:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80011d:	50                   	push   %eax
  80011e:	e8 a3 09 00 00       	call   800ac6 <sys_cputs>

	return b.cnt;
}
  800123:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800129:	c9                   	leave  
  80012a:	c3                   	ret    

0080012b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800131:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800134:	50                   	push   %eax
  800135:	ff 75 08             	pushl  0x8(%ebp)
  800138:	e8 9d ff ff ff       	call   8000da <vcprintf>
	va_end(ap);

	return cnt;
}
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

0080013f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
  800145:	83 ec 1c             	sub    $0x1c,%esp
  800148:	89 c7                	mov    %eax,%edi
  80014a:	89 d6                	mov    %edx,%esi
  80014c:	8b 45 08             	mov    0x8(%ebp),%eax
  80014f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800152:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800155:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800158:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80015b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800160:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800163:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800166:	39 d3                	cmp    %edx,%ebx
  800168:	72 05                	jb     80016f <printnum+0x30>
  80016a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80016d:	77 7a                	ja     8001e9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	ff 75 18             	pushl  0x18(%ebp)
  800175:	8b 45 14             	mov    0x14(%ebp),%eax
  800178:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80017b:	53                   	push   %ebx
  80017c:	ff 75 10             	pushl  0x10(%ebp)
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 e4             	pushl  -0x1c(%ebp)
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	ff 75 dc             	pushl  -0x24(%ebp)
  80018b:	ff 75 d8             	pushl  -0x28(%ebp)
  80018e:	e8 ed 0b 00 00       	call   800d80 <__udivdi3>
  800193:	83 c4 18             	add    $0x18,%esp
  800196:	52                   	push   %edx
  800197:	50                   	push   %eax
  800198:	89 f2                	mov    %esi,%edx
  80019a:	89 f8                	mov    %edi,%eax
  80019c:	e8 9e ff ff ff       	call   80013f <printnum>
  8001a1:	83 c4 20             	add    $0x20,%esp
  8001a4:	eb 13                	jmp    8001b9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	56                   	push   %esi
  8001aa:	ff 75 18             	pushl  0x18(%ebp)
  8001ad:	ff d7                	call   *%edi
  8001af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001b2:	83 eb 01             	sub    $0x1,%ebx
  8001b5:	85 db                	test   %ebx,%ebx
  8001b7:	7f ed                	jg     8001a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001b9:	83 ec 08             	sub    $0x8,%esp
  8001bc:	56                   	push   %esi
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cc:	e8 cf 0c 00 00       	call   800ea0 <__umoddi3>
  8001d1:	83 c4 14             	add    $0x14,%esp
  8001d4:	0f be 80 e8 0f 80 00 	movsbl 0x800fe8(%eax),%eax
  8001db:	50                   	push   %eax
  8001dc:	ff d7                	call   *%edi
}
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e4:	5b                   	pop    %ebx
  8001e5:	5e                   	pop    %esi
  8001e6:	5f                   	pop    %edi
  8001e7:	5d                   	pop    %ebp
  8001e8:	c3                   	ret    
  8001e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001ec:	eb c4                	jmp    8001b2 <printnum+0x73>

008001ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8001f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8001f8:	8b 10                	mov    (%eax),%edx
  8001fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8001fd:	73 0a                	jae    800209 <sprintputch+0x1b>
		*b->buf++ = ch;
  8001ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800202:	89 08                	mov    %ecx,(%eax)
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	88 02                	mov    %al,(%edx)
}
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    

0080020b <printfmt>:
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800211:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800214:	50                   	push   %eax
  800215:	ff 75 10             	pushl  0x10(%ebp)
  800218:	ff 75 0c             	pushl  0xc(%ebp)
  80021b:	ff 75 08             	pushl  0x8(%ebp)
  80021e:	e8 05 00 00 00       	call   800228 <vprintfmt>
}
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <vprintfmt>:
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 2c             	sub    $0x2c,%esp
  800231:	8b 75 08             	mov    0x8(%ebp),%esi
  800234:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800237:	8b 7d 10             	mov    0x10(%ebp),%edi
  80023a:	e9 00 04 00 00       	jmp    80063f <vprintfmt+0x417>
		padc = ' ';
  80023f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800243:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80024a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800251:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800258:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80025d:	8d 47 01             	lea    0x1(%edi),%eax
  800260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800263:	0f b6 17             	movzbl (%edi),%edx
  800266:	8d 42 dd             	lea    -0x23(%edx),%eax
  800269:	3c 55                	cmp    $0x55,%al
  80026b:	0f 87 51 04 00 00    	ja     8006c2 <vprintfmt+0x49a>
  800271:	0f b6 c0             	movzbl %al,%eax
  800274:	ff 24 85 a0 10 80 00 	jmp    *0x8010a0(,%eax,4)
  80027b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80027e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800282:	eb d9                	jmp    80025d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800284:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800287:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80028b:	eb d0                	jmp    80025d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80028d:	0f b6 d2             	movzbl %dl,%edx
  800290:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80029b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80029e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002a8:	83 f9 09             	cmp    $0x9,%ecx
  8002ab:	77 55                	ja     800302 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002b0:	eb e9                	jmp    80029b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bd:	8d 40 04             	lea    0x4(%eax),%eax
  8002c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002ca:	79 91                	jns    80025d <vprintfmt+0x35>
				width = precision, precision = -1;
  8002cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002d9:	eb 82                	jmp    80025d <vprintfmt+0x35>
  8002db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002de:	85 c0                	test   %eax,%eax
  8002e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e5:	0f 49 d0             	cmovns %eax,%edx
  8002e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002ee:	e9 6a ff ff ff       	jmp    80025d <vprintfmt+0x35>
  8002f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8002f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8002fd:	e9 5b ff ff ff       	jmp    80025d <vprintfmt+0x35>
  800302:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800305:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800308:	eb bc                	jmp    8002c6 <vprintfmt+0x9e>
			lflag++;
  80030a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800310:	e9 48 ff ff ff       	jmp    80025d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800315:	8b 45 14             	mov    0x14(%ebp),%eax
  800318:	8d 78 04             	lea    0x4(%eax),%edi
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	53                   	push   %ebx
  80031f:	ff 30                	pushl  (%eax)
  800321:	ff d6                	call   *%esi
			break;
  800323:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800326:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800329:	e9 0e 03 00 00       	jmp    80063c <vprintfmt+0x414>
			err = va_arg(ap, int);
  80032e:	8b 45 14             	mov    0x14(%ebp),%eax
  800331:	8d 78 04             	lea    0x4(%eax),%edi
  800334:	8b 00                	mov    (%eax),%eax
  800336:	99                   	cltd   
  800337:	31 d0                	xor    %edx,%eax
  800339:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80033b:	83 f8 08             	cmp    $0x8,%eax
  80033e:	7f 23                	jg     800363 <vprintfmt+0x13b>
  800340:	8b 14 85 00 12 80 00 	mov    0x801200(,%eax,4),%edx
  800347:	85 d2                	test   %edx,%edx
  800349:	74 18                	je     800363 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80034b:	52                   	push   %edx
  80034c:	68 09 10 80 00       	push   $0x801009
  800351:	53                   	push   %ebx
  800352:	56                   	push   %esi
  800353:	e8 b3 fe ff ff       	call   80020b <printfmt>
  800358:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80035b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80035e:	e9 d9 02 00 00       	jmp    80063c <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800363:	50                   	push   %eax
  800364:	68 00 10 80 00       	push   $0x801000
  800369:	53                   	push   %ebx
  80036a:	56                   	push   %esi
  80036b:	e8 9b fe ff ff       	call   80020b <printfmt>
  800370:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800373:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800376:	e9 c1 02 00 00       	jmp    80063c <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80037b:	8b 45 14             	mov    0x14(%ebp),%eax
  80037e:	83 c0 04             	add    $0x4,%eax
  800381:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800384:	8b 45 14             	mov    0x14(%ebp),%eax
  800387:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800389:	85 ff                	test   %edi,%edi
  80038b:	b8 f9 0f 80 00       	mov    $0x800ff9,%eax
  800390:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800397:	0f 8e bd 00 00 00    	jle    80045a <vprintfmt+0x232>
  80039d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003a1:	75 0e                	jne    8003b1 <vprintfmt+0x189>
  8003a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003af:	eb 6d                	jmp    80041e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b7:	57                   	push   %edi
  8003b8:	e8 ad 03 00 00       	call   80076a <strnlen>
  8003bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c0:	29 c1                	sub    %eax,%ecx
  8003c2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003d2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d4:	eb 0f                	jmp    8003e5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	53                   	push   %ebx
  8003da:	ff 75 e0             	pushl  -0x20(%ebp)
  8003dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003df:	83 ef 01             	sub    $0x1,%edi
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	85 ff                	test   %edi,%edi
  8003e7:	7f ed                	jg     8003d6 <vprintfmt+0x1ae>
  8003e9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8003ec:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003ef:	85 c9                	test   %ecx,%ecx
  8003f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f6:	0f 49 c1             	cmovns %ecx,%eax
  8003f9:	29 c1                	sub    %eax,%ecx
  8003fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800401:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800404:	89 cb                	mov    %ecx,%ebx
  800406:	eb 16                	jmp    80041e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800408:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80040c:	75 31                	jne    80043f <vprintfmt+0x217>
					putch(ch, putdat);
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	ff 75 0c             	pushl  0xc(%ebp)
  800414:	50                   	push   %eax
  800415:	ff 55 08             	call   *0x8(%ebp)
  800418:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80041b:	83 eb 01             	sub    $0x1,%ebx
  80041e:	83 c7 01             	add    $0x1,%edi
  800421:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800425:	0f be c2             	movsbl %dl,%eax
  800428:	85 c0                	test   %eax,%eax
  80042a:	74 59                	je     800485 <vprintfmt+0x25d>
  80042c:	85 f6                	test   %esi,%esi
  80042e:	78 d8                	js     800408 <vprintfmt+0x1e0>
  800430:	83 ee 01             	sub    $0x1,%esi
  800433:	79 d3                	jns    800408 <vprintfmt+0x1e0>
  800435:	89 df                	mov    %ebx,%edi
  800437:	8b 75 08             	mov    0x8(%ebp),%esi
  80043a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80043d:	eb 37                	jmp    800476 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80043f:	0f be d2             	movsbl %dl,%edx
  800442:	83 ea 20             	sub    $0x20,%edx
  800445:	83 fa 5e             	cmp    $0x5e,%edx
  800448:	76 c4                	jbe    80040e <vprintfmt+0x1e6>
					putch('?', putdat);
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	ff 75 0c             	pushl  0xc(%ebp)
  800450:	6a 3f                	push   $0x3f
  800452:	ff 55 08             	call   *0x8(%ebp)
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	eb c1                	jmp    80041b <vprintfmt+0x1f3>
  80045a:	89 75 08             	mov    %esi,0x8(%ebp)
  80045d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800460:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800463:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800466:	eb b6                	jmp    80041e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	53                   	push   %ebx
  80046c:	6a 20                	push   $0x20
  80046e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800470:	83 ef 01             	sub    $0x1,%edi
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	85 ff                	test   %edi,%edi
  800478:	7f ee                	jg     800468 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80047a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80047d:	89 45 14             	mov    %eax,0x14(%ebp)
  800480:	e9 b7 01 00 00       	jmp    80063c <vprintfmt+0x414>
  800485:	89 df                	mov    %ebx,%edi
  800487:	8b 75 08             	mov    0x8(%ebp),%esi
  80048a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80048d:	eb e7                	jmp    800476 <vprintfmt+0x24e>
	if (lflag >= 2)
  80048f:	83 f9 01             	cmp    $0x1,%ecx
  800492:	7e 3f                	jle    8004d3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8b 50 04             	mov    0x4(%eax),%edx
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 40 08             	lea    0x8(%eax),%eax
  8004a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004af:	79 5c                	jns    80050d <vprintfmt+0x2e5>
				putch('-', putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	53                   	push   %ebx
  8004b5:	6a 2d                	push   $0x2d
  8004b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8004b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004bf:	f7 da                	neg    %edx
  8004c1:	83 d1 00             	adc    $0x0,%ecx
  8004c4:	f7 d9                	neg    %ecx
  8004c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004ce:	e9 4f 01 00 00       	jmp    800622 <vprintfmt+0x3fa>
	else if (lflag)
  8004d3:	85 c9                	test   %ecx,%ecx
  8004d5:	75 1b                	jne    8004f2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004df:	89 c1                	mov    %eax,%ecx
  8004e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	8d 40 04             	lea    0x4(%eax),%eax
  8004ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f0:	eb b9                	jmp    8004ab <vprintfmt+0x283>
		return va_arg(*ap, long);
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	89 c1                	mov    %eax,%ecx
  8004fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8d 40 04             	lea    0x4(%eax),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	eb 9e                	jmp    8004ab <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80050d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800510:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800513:	b8 0a 00 00 00       	mov    $0xa,%eax
  800518:	e9 05 01 00 00       	jmp    800622 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80051d:	83 f9 01             	cmp    $0x1,%ecx
  800520:	7e 18                	jle    80053a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8b 10                	mov    (%eax),%edx
  800527:	8b 48 04             	mov    0x4(%eax),%ecx
  80052a:	8d 40 08             	lea    0x8(%eax),%eax
  80052d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800530:	b8 0a 00 00 00       	mov    $0xa,%eax
  800535:	e9 e8 00 00 00       	jmp    800622 <vprintfmt+0x3fa>
	else if (lflag)
  80053a:	85 c9                	test   %ecx,%ecx
  80053c:	75 1a                	jne    800558 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 10                	mov    (%eax),%edx
  800543:	b9 00 00 00 00       	mov    $0x0,%ecx
  800548:	8d 40 04             	lea    0x4(%eax),%eax
  80054b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800553:	e9 ca 00 00 00       	jmp    800622 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 10                	mov    (%eax),%edx
  80055d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800562:	8d 40 04             	lea    0x4(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800568:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056d:	e9 b0 00 00 00       	jmp    800622 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800572:	83 f9 01             	cmp    $0x1,%ecx
  800575:	7e 3c                	jle    8005b3 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 50 04             	mov    0x4(%eax),%edx
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 40 08             	lea    0x8(%eax),%eax
  80058b:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80058e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800592:	79 59                	jns    8005ed <vprintfmt+0x3c5>
                putch('-', putdat);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	53                   	push   %ebx
  800598:	6a 2d                	push   $0x2d
  80059a:	ff d6                	call   *%esi
                num = -(long long) num;
  80059c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a2:	f7 da                	neg    %edx
  8005a4:	83 d1 00             	adc    $0x0,%ecx
  8005a7:	f7 d9                	neg    %ecx
  8005a9:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b1:	eb 6f                	jmp    800622 <vprintfmt+0x3fa>
	else if (lflag)
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	75 1b                	jne    8005d2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb bc                	jmp    80058e <vprintfmt+0x366>
		return va_arg(*ap, long);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005da:	89 c1                	mov    %eax,%ecx
  8005dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb a1                	jmp    80058e <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8005ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8005f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f8:	eb 28                	jmp    800622 <vprintfmt+0x3fa>
			putch('0', putdat);
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	53                   	push   %ebx
  8005fe:	6a 30                	push   $0x30
  800600:	ff d6                	call   *%esi
			putch('x', putdat);
  800602:	83 c4 08             	add    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	6a 78                	push   $0x78
  800608:	ff d6                	call   *%esi
			num = (unsigned long long)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800614:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800617:	8d 40 04             	lea    0x4(%eax),%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80061d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800629:	57                   	push   %edi
  80062a:	ff 75 e0             	pushl  -0x20(%ebp)
  80062d:	50                   	push   %eax
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	89 da                	mov    %ebx,%edx
  800632:	89 f0                	mov    %esi,%eax
  800634:	e8 06 fb ff ff       	call   80013f <printnum>
			break;
  800639:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80063c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063f:	83 c7 01             	add    $0x1,%edi
  800642:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800646:	83 f8 25             	cmp    $0x25,%eax
  800649:	0f 84 f0 fb ff ff    	je     80023f <vprintfmt+0x17>
			if (ch == '\0')
  80064f:	85 c0                	test   %eax,%eax
  800651:	0f 84 8b 00 00 00    	je     8006e2 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	50                   	push   %eax
  80065c:	ff d6                	call   *%esi
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb dc                	jmp    80063f <vprintfmt+0x417>
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7e 15                	jle    80067d <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	8b 48 04             	mov    0x4(%eax),%ecx
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
  80067b:	eb a5                	jmp    800622 <vprintfmt+0x3fa>
	else if (lflag)
  80067d:	85 c9                	test   %ecx,%ecx
  80067f:	75 17                	jne    800698 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 10                	mov    (%eax),%edx
  800686:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800691:	b8 10 00 00 00       	mov    $0x10,%eax
  800696:	eb 8a                	jmp    800622 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ad:	e9 70 ff ff ff       	jmp    800622 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 25                	push   $0x25
  8006b8:	ff d6                	call   *%esi
			break;
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	e9 7a ff ff ff       	jmp    80063c <vprintfmt+0x414>
			putch('%', putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	6a 25                	push   $0x25
  8006c8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 f8                	mov    %edi,%eax
  8006cf:	eb 03                	jmp    8006d4 <vprintfmt+0x4ac>
  8006d1:	83 e8 01             	sub    $0x1,%eax
  8006d4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006d8:	75 f7                	jne    8006d1 <vprintfmt+0x4a9>
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006dd:	e9 5a ff ff ff       	jmp    80063c <vprintfmt+0x414>
}
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    

008006ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	83 ec 18             	sub    $0x18,%esp
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006fd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800707:	85 c0                	test   %eax,%eax
  800709:	74 26                	je     800731 <vsnprintf+0x47>
  80070b:	85 d2                	test   %edx,%edx
  80070d:	7e 22                	jle    800731 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80070f:	ff 75 14             	pushl  0x14(%ebp)
  800712:	ff 75 10             	pushl  0x10(%ebp)
  800715:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800718:	50                   	push   %eax
  800719:	68 ee 01 80 00       	push   $0x8001ee
  80071e:	e8 05 fb ff ff       	call   800228 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800726:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072c:	83 c4 10             	add    $0x10,%esp
}
  80072f:	c9                   	leave  
  800730:	c3                   	ret    
		return -E_INVAL;
  800731:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800736:	eb f7                	jmp    80072f <vsnprintf+0x45>

00800738 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80073e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800741:	50                   	push   %eax
  800742:	ff 75 10             	pushl  0x10(%ebp)
  800745:	ff 75 0c             	pushl  0xc(%ebp)
  800748:	ff 75 08             	pushl  0x8(%ebp)
  80074b:	e8 9a ff ff ff       	call   8006ea <vsnprintf>
	va_end(ap);

	return rc;
}
  800750:	c9                   	leave  
  800751:	c3                   	ret    

00800752 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800758:	b8 00 00 00 00       	mov    $0x0,%eax
  80075d:	eb 03                	jmp    800762 <strlen+0x10>
		n++;
  80075f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800762:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800766:	75 f7                	jne    80075f <strlen+0xd>
	return n;
}
  800768:	5d                   	pop    %ebp
  800769:	c3                   	ret    

0080076a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800773:	b8 00 00 00 00       	mov    $0x0,%eax
  800778:	eb 03                	jmp    80077d <strnlen+0x13>
		n++;
  80077a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077d:	39 d0                	cmp    %edx,%eax
  80077f:	74 06                	je     800787 <strnlen+0x1d>
  800781:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800785:	75 f3                	jne    80077a <strnlen+0x10>
	return n;
}
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	53                   	push   %ebx
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800793:	89 c2                	mov    %eax,%edx
  800795:	83 c1 01             	add    $0x1,%ecx
  800798:	83 c2 01             	add    $0x1,%edx
  80079b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80079f:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007a2:	84 db                	test   %bl,%bl
  8007a4:	75 ef                	jne    800795 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007a6:	5b                   	pop    %ebx
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b0:	53                   	push   %ebx
  8007b1:	e8 9c ff ff ff       	call   800752 <strlen>
  8007b6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	01 d8                	add    %ebx,%eax
  8007be:	50                   	push   %eax
  8007bf:	e8 c5 ff ff ff       	call   800789 <strcpy>
	return dst;
}
  8007c4:	89 d8                	mov    %ebx,%eax
  8007c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	56                   	push   %esi
  8007cf:	53                   	push   %ebx
  8007d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d6:	89 f3                	mov    %esi,%ebx
  8007d8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007db:	89 f2                	mov    %esi,%edx
  8007dd:	eb 0f                	jmp    8007ee <strncpy+0x23>
		*dst++ = *src;
  8007df:	83 c2 01             	add    $0x1,%edx
  8007e2:	0f b6 01             	movzbl (%ecx),%eax
  8007e5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e8:	80 39 01             	cmpb   $0x1,(%ecx)
  8007eb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007ee:	39 da                	cmp    %ebx,%edx
  8007f0:	75 ed                	jne    8007df <strncpy+0x14>
	}
	return ret;
}
  8007f2:	89 f0                	mov    %esi,%eax
  8007f4:	5b                   	pop    %ebx
  8007f5:	5e                   	pop    %esi
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800806:	89 f0                	mov    %esi,%eax
  800808:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080c:	85 c9                	test   %ecx,%ecx
  80080e:	75 0b                	jne    80081b <strlcpy+0x23>
  800810:	eb 17                	jmp    800829 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800812:	83 c2 01             	add    $0x1,%edx
  800815:	83 c0 01             	add    $0x1,%eax
  800818:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80081b:	39 d8                	cmp    %ebx,%eax
  80081d:	74 07                	je     800826 <strlcpy+0x2e>
  80081f:	0f b6 0a             	movzbl (%edx),%ecx
  800822:	84 c9                	test   %cl,%cl
  800824:	75 ec                	jne    800812 <strlcpy+0x1a>
		*dst = '\0';
  800826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800829:	29 f0                	sub    %esi,%eax
}
  80082b:	5b                   	pop    %ebx
  80082c:	5e                   	pop    %esi
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800835:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800838:	eb 06                	jmp    800840 <strcmp+0x11>
		p++, q++;
  80083a:	83 c1 01             	add    $0x1,%ecx
  80083d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800840:	0f b6 01             	movzbl (%ecx),%eax
  800843:	84 c0                	test   %al,%al
  800845:	74 04                	je     80084b <strcmp+0x1c>
  800847:	3a 02                	cmp    (%edx),%al
  800849:	74 ef                	je     80083a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80084b:	0f b6 c0             	movzbl %al,%eax
  80084e:	0f b6 12             	movzbl (%edx),%edx
  800851:	29 d0                	sub    %edx,%eax
}
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085f:	89 c3                	mov    %eax,%ebx
  800861:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800864:	eb 06                	jmp    80086c <strncmp+0x17>
		n--, p++, q++;
  800866:	83 c0 01             	add    $0x1,%eax
  800869:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80086c:	39 d8                	cmp    %ebx,%eax
  80086e:	74 16                	je     800886 <strncmp+0x31>
  800870:	0f b6 08             	movzbl (%eax),%ecx
  800873:	84 c9                	test   %cl,%cl
  800875:	74 04                	je     80087b <strncmp+0x26>
  800877:	3a 0a                	cmp    (%edx),%cl
  800879:	74 eb                	je     800866 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80087b:	0f b6 00             	movzbl (%eax),%eax
  80087e:	0f b6 12             	movzbl (%edx),%edx
  800881:	29 d0                	sub    %edx,%eax
}
  800883:	5b                   	pop    %ebx
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    
		return 0;
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
  80088b:	eb f6                	jmp    800883 <strncmp+0x2e>

0080088d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800897:	0f b6 10             	movzbl (%eax),%edx
  80089a:	84 d2                	test   %dl,%dl
  80089c:	74 09                	je     8008a7 <strchr+0x1a>
		if (*s == c)
  80089e:	38 ca                	cmp    %cl,%dl
  8008a0:	74 0a                	je     8008ac <strchr+0x1f>
	for (; *s; s++)
  8008a2:	83 c0 01             	add    $0x1,%eax
  8008a5:	eb f0                	jmp    800897 <strchr+0xa>
			return (char *) s;
	return 0;
  8008a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b8:	eb 03                	jmp    8008bd <strfind+0xf>
  8008ba:	83 c0 01             	add    $0x1,%eax
  8008bd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008c0:	38 ca                	cmp    %cl,%dl
  8008c2:	74 04                	je     8008c8 <strfind+0x1a>
  8008c4:	84 d2                	test   %dl,%dl
  8008c6:	75 f2                	jne    8008ba <strfind+0xc>
			break;
	return (char *) s;
}
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	57                   	push   %edi
  8008ce:	56                   	push   %esi
  8008cf:	53                   	push   %ebx
  8008d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008d6:	85 c9                	test   %ecx,%ecx
  8008d8:	74 13                	je     8008ed <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008da:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008e0:	75 05                	jne    8008e7 <memset+0x1d>
  8008e2:	f6 c1 03             	test   $0x3,%cl
  8008e5:	74 0d                	je     8008f4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	fc                   	cld    
  8008eb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008ed:	89 f8                	mov    %edi,%eax
  8008ef:	5b                   	pop    %ebx
  8008f0:	5e                   	pop    %esi
  8008f1:	5f                   	pop    %edi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    
		c &= 0xFF;
  8008f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f8:	89 d3                	mov    %edx,%ebx
  8008fa:	c1 e3 08             	shl    $0x8,%ebx
  8008fd:	89 d0                	mov    %edx,%eax
  8008ff:	c1 e0 18             	shl    $0x18,%eax
  800902:	89 d6                	mov    %edx,%esi
  800904:	c1 e6 10             	shl    $0x10,%esi
  800907:	09 f0                	or     %esi,%eax
  800909:	09 c2                	or     %eax,%edx
  80090b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80090d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800910:	89 d0                	mov    %edx,%eax
  800912:	fc                   	cld    
  800913:	f3 ab                	rep stos %eax,%es:(%edi)
  800915:	eb d6                	jmp    8008ed <memset+0x23>

00800917 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800922:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800925:	39 c6                	cmp    %eax,%esi
  800927:	73 35                	jae    80095e <memmove+0x47>
  800929:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80092c:	39 c2                	cmp    %eax,%edx
  80092e:	76 2e                	jbe    80095e <memmove+0x47>
		s += n;
		d += n;
  800930:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800933:	89 d6                	mov    %edx,%esi
  800935:	09 fe                	or     %edi,%esi
  800937:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80093d:	74 0c                	je     80094b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80093f:	83 ef 01             	sub    $0x1,%edi
  800942:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800945:	fd                   	std    
  800946:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800948:	fc                   	cld    
  800949:	eb 21                	jmp    80096c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80094b:	f6 c1 03             	test   $0x3,%cl
  80094e:	75 ef                	jne    80093f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800950:	83 ef 04             	sub    $0x4,%edi
  800953:	8d 72 fc             	lea    -0x4(%edx),%esi
  800956:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800959:	fd                   	std    
  80095a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80095c:	eb ea                	jmp    800948 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095e:	89 f2                	mov    %esi,%edx
  800960:	09 c2                	or     %eax,%edx
  800962:	f6 c2 03             	test   $0x3,%dl
  800965:	74 09                	je     800970 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800967:	89 c7                	mov    %eax,%edi
  800969:	fc                   	cld    
  80096a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80096c:	5e                   	pop    %esi
  80096d:	5f                   	pop    %edi
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800970:	f6 c1 03             	test   $0x3,%cl
  800973:	75 f2                	jne    800967 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800975:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800978:	89 c7                	mov    %eax,%edi
  80097a:	fc                   	cld    
  80097b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097d:	eb ed                	jmp    80096c <memmove+0x55>

0080097f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800982:	ff 75 10             	pushl  0x10(%ebp)
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 87 ff ff ff       	call   800917 <memmove>
}
  800990:	c9                   	leave  
  800991:	c3                   	ret    

00800992 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	89 c6                	mov    %eax,%esi
  80099f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009a2:	39 f0                	cmp    %esi,%eax
  8009a4:	74 1c                	je     8009c2 <memcmp+0x30>
		if (*s1 != *s2)
  8009a6:	0f b6 08             	movzbl (%eax),%ecx
  8009a9:	0f b6 1a             	movzbl (%edx),%ebx
  8009ac:	38 d9                	cmp    %bl,%cl
  8009ae:	75 08                	jne    8009b8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b0:	83 c0 01             	add    $0x1,%eax
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	eb ea                	jmp    8009a2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009b8:	0f b6 c1             	movzbl %cl,%eax
  8009bb:	0f b6 db             	movzbl %bl,%ebx
  8009be:	29 d8                	sub    %ebx,%eax
  8009c0:	eb 05                	jmp    8009c7 <memcmp+0x35>
	}

	return 0;
  8009c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009d4:	89 c2                	mov    %eax,%edx
  8009d6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009d9:	39 d0                	cmp    %edx,%eax
  8009db:	73 09                	jae    8009e6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009dd:	38 08                	cmp    %cl,(%eax)
  8009df:	74 05                	je     8009e6 <memfind+0x1b>
	for (; s < ends; s++)
  8009e1:	83 c0 01             	add    $0x1,%eax
  8009e4:	eb f3                	jmp    8009d9 <memfind+0xe>
			break;
	return (void *) s;
}
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	57                   	push   %edi
  8009ec:	56                   	push   %esi
  8009ed:	53                   	push   %ebx
  8009ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009f4:	eb 03                	jmp    8009f9 <strtol+0x11>
		s++;
  8009f6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	3c 20                	cmp    $0x20,%al
  8009fe:	74 f6                	je     8009f6 <strtol+0xe>
  800a00:	3c 09                	cmp    $0x9,%al
  800a02:	74 f2                	je     8009f6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a04:	3c 2b                	cmp    $0x2b,%al
  800a06:	74 2e                	je     800a36 <strtol+0x4e>
	int neg = 0;
  800a08:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a0d:	3c 2d                	cmp    $0x2d,%al
  800a0f:	74 2f                	je     800a40 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a11:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a17:	75 05                	jne    800a1e <strtol+0x36>
  800a19:	80 39 30             	cmpb   $0x30,(%ecx)
  800a1c:	74 2c                	je     800a4a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a1e:	85 db                	test   %ebx,%ebx
  800a20:	75 0a                	jne    800a2c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a22:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a27:	80 39 30             	cmpb   $0x30,(%ecx)
  800a2a:	74 28                	je     800a54 <strtol+0x6c>
		base = 10;
  800a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a34:	eb 50                	jmp    800a86 <strtol+0x9e>
		s++;
  800a36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a39:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3e:	eb d1                	jmp    800a11 <strtol+0x29>
		s++, neg = 1;
  800a40:	83 c1 01             	add    $0x1,%ecx
  800a43:	bf 01 00 00 00       	mov    $0x1,%edi
  800a48:	eb c7                	jmp    800a11 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a4e:	74 0e                	je     800a5e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	75 d8                	jne    800a2c <strtol+0x44>
		s++, base = 8;
  800a54:	83 c1 01             	add    $0x1,%ecx
  800a57:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a5c:	eb ce                	jmp    800a2c <strtol+0x44>
		s += 2, base = 16;
  800a5e:	83 c1 02             	add    $0x2,%ecx
  800a61:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a66:	eb c4                	jmp    800a2c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a6b:	89 f3                	mov    %esi,%ebx
  800a6d:	80 fb 19             	cmp    $0x19,%bl
  800a70:	77 29                	ja     800a9b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a72:	0f be d2             	movsbl %dl,%edx
  800a75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7b:	7d 30                	jge    800aad <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a86:	0f b6 11             	movzbl (%ecx),%edx
  800a89:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a8c:	89 f3                	mov    %esi,%ebx
  800a8e:	80 fb 09             	cmp    $0x9,%bl
  800a91:	77 d5                	ja     800a68 <strtol+0x80>
			dig = *s - '0';
  800a93:	0f be d2             	movsbl %dl,%edx
  800a96:	83 ea 30             	sub    $0x30,%edx
  800a99:	eb dd                	jmp    800a78 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a9e:	89 f3                	mov    %esi,%ebx
  800aa0:	80 fb 19             	cmp    $0x19,%bl
  800aa3:	77 08                	ja     800aad <strtol+0xc5>
			dig = *s - 'A' + 10;
  800aa5:	0f be d2             	movsbl %dl,%edx
  800aa8:	83 ea 37             	sub    $0x37,%edx
  800aab:	eb cb                	jmp    800a78 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab1:	74 05                	je     800ab8 <strtol+0xd0>
		*endptr = (char *) s;
  800ab3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ab8:	89 c2                	mov    %eax,%edx
  800aba:	f7 da                	neg    %edx
  800abc:	85 ff                	test   %edi,%edi
  800abe:	0f 45 c2             	cmovne %edx,%eax
}
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad7:	89 c3                	mov    %eax,%ebx
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	89 c6                	mov    %eax,%esi
  800add:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <sys_cgetc>:

int
sys_cgetc(void) {
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800aea:	ba 00 00 00 00       	mov    $0x0,%edx
  800aef:	b8 01 00 00 00       	mov    $0x1,%eax
  800af4:	89 d1                	mov    %edx,%ecx
  800af6:	89 d3                	mov    %edx,%ebx
  800af8:	89 d7                	mov    %edx,%edi
  800afa:	89 d6                	mov    %edx,%esi
  800afc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5f                   	pop    %edi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	57                   	push   %edi
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b11:	8b 55 08             	mov    0x8(%ebp),%edx
  800b14:	b8 03 00 00 00       	mov    $0x3,%eax
  800b19:	89 cb                	mov    %ecx,%ebx
  800b1b:	89 cf                	mov    %ecx,%edi
  800b1d:	89 ce                	mov    %ecx,%esi
  800b1f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b21:	85 c0                	test   %eax,%eax
  800b23:	7f 08                	jg     800b2d <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5f                   	pop    %edi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b2d:	83 ec 0c             	sub    $0xc,%esp
  800b30:	50                   	push   %eax
  800b31:	6a 03                	push   $0x3
  800b33:	68 24 12 80 00       	push   $0x801224
  800b38:	6a 24                	push   $0x24
  800b3a:	68 41 12 80 00       	push   $0x801241
  800b3f:	e8 ed 01 00 00       	call   800d31 <_panic>

00800b44 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4f:	b8 02 00 00 00       	mov    $0x2,%eax
  800b54:	89 d1                	mov    %edx,%ecx
  800b56:	89 d3                	mov    %edx,%ebx
  800b58:	89 d7                	mov    %edx,%edi
  800b5a:	89 d6                	mov    %edx,%esi
  800b5c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <sys_yield>:

void
sys_yield(void)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b69:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b73:	89 d1                	mov    %edx,%ecx
  800b75:	89 d3                	mov    %edx,%ebx
  800b77:	89 d7                	mov    %edx,%edi
  800b79:	89 d6                	mov    %edx,%esi
  800b7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5f                   	pop    %edi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b8b:	be 00 00 00 00       	mov    $0x0,%esi
  800b90:	8b 55 08             	mov    0x8(%ebp),%edx
  800b93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b96:	b8 04 00 00 00       	mov    $0x4,%eax
  800b9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b9e:	89 f7                	mov    %esi,%edi
  800ba0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ba2:	85 c0                	test   %eax,%eax
  800ba4:	7f 08                	jg     800bae <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bae:	83 ec 0c             	sub    $0xc,%esp
  800bb1:	50                   	push   %eax
  800bb2:	6a 04                	push   $0x4
  800bb4:	68 24 12 80 00       	push   $0x801224
  800bb9:	6a 24                	push   $0x24
  800bbb:	68 41 12 80 00       	push   $0x801241
  800bc0:	e8 6c 01 00 00       	call   800d31 <_panic>

00800bc5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
  800bcb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bce:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	b8 05 00 00 00       	mov    $0x5,%eax
  800bd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bdf:	8b 75 18             	mov    0x18(%ebp),%esi
  800be2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800be4:	85 c0                	test   %eax,%eax
  800be6:	7f 08                	jg     800bf0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	50                   	push   %eax
  800bf4:	6a 05                	push   $0x5
  800bf6:	68 24 12 80 00       	push   $0x801224
  800bfb:	6a 24                	push   $0x24
  800bfd:	68 41 12 80 00       	push   $0x801241
  800c02:	e8 2a 01 00 00       	call   800d31 <_panic>

00800c07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c15:	8b 55 08             	mov    0x8(%ebp),%edx
  800c18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c20:	89 df                	mov    %ebx,%edi
  800c22:	89 de                	mov    %ebx,%esi
  800c24:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7f 08                	jg     800c32 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	50                   	push   %eax
  800c36:	6a 06                	push   $0x6
  800c38:	68 24 12 80 00       	push   $0x801224
  800c3d:	6a 24                	push   $0x24
  800c3f:	68 41 12 80 00       	push   $0x801241
  800c44:	e8 e8 00 00 00       	call   800d31 <_panic>

00800c49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c62:	89 df                	mov    %ebx,%edi
  800c64:	89 de                	mov    %ebx,%esi
  800c66:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	7f 08                	jg     800c74 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	50                   	push   %eax
  800c78:	6a 08                	push   $0x8
  800c7a:	68 24 12 80 00       	push   $0x801224
  800c7f:	6a 24                	push   $0x24
  800c81:	68 41 12 80 00       	push   $0x801241
  800c86:	e8 a6 00 00 00       	call   800d31 <_panic>

00800c8b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	b8 09 00 00 00       	mov    $0x9,%eax
  800ca4:	89 df                	mov    %ebx,%edi
  800ca6:	89 de                	mov    %ebx,%esi
  800ca8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 09                	push   $0x9
  800cbc:	68 24 12 80 00       	push   $0x801224
  800cc1:	6a 24                	push   $0x24
  800cc3:	68 41 12 80 00       	push   $0x801241
  800cc8:	e8 64 00 00 00       	call   800d31 <_panic>

00800ccd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cde:	be 00 00 00 00       	mov    $0x0,%esi
  800ce3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d06:	89 cb                	mov    %ecx,%ebx
  800d08:	89 cf                	mov    %ecx,%edi
  800d0a:	89 ce                	mov    %ecx,%esi
  800d0c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d0e:	85 c0                	test   %eax,%eax
  800d10:	7f 08                	jg     800d1a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d1a:	83 ec 0c             	sub    $0xc,%esp
  800d1d:	50                   	push   %eax
  800d1e:	6a 0c                	push   $0xc
  800d20:	68 24 12 80 00       	push   $0x801224
  800d25:	6a 24                	push   $0x24
  800d27:	68 41 12 80 00       	push   $0x801241
  800d2c:	e8 00 00 00 00       	call   800d31 <_panic>

00800d31 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d36:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d39:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d3f:	e8 00 fe ff ff       	call   800b44 <sys_getenvid>
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	56                   	push   %esi
  800d4e:	50                   	push   %eax
  800d4f:	68 50 12 80 00       	push   $0x801250
  800d54:	e8 d2 f3 ff ff       	call   80012b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d59:	83 c4 18             	add    $0x18,%esp
  800d5c:	53                   	push   %ebx
  800d5d:	ff 75 10             	pushl  0x10(%ebp)
  800d60:	e8 75 f3 ff ff       	call   8000da <vcprintf>
	cprintf("\n");
  800d65:	c7 04 24 dc 0f 80 00 	movl   $0x800fdc,(%esp)
  800d6c:	e8 ba f3 ff ff       	call   80012b <cprintf>
  800d71:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d74:	cc                   	int3   
  800d75:	eb fd                	jmp    800d74 <_panic+0x43>
  800d77:	66 90                	xchg   %ax,%ax
  800d79:	66 90                	xchg   %ax,%ax
  800d7b:	66 90                	xchg   %ax,%ax
  800d7d:	66 90                	xchg   %ax,%ax
  800d7f:	90                   	nop

00800d80 <__udivdi3>:
  800d80:	55                   	push   %ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 1c             	sub    $0x1c,%esp
  800d87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d97:	85 d2                	test   %edx,%edx
  800d99:	75 35                	jne    800dd0 <__udivdi3+0x50>
  800d9b:	39 f3                	cmp    %esi,%ebx
  800d9d:	0f 87 bd 00 00 00    	ja     800e60 <__udivdi3+0xe0>
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	89 d9                	mov    %ebx,%ecx
  800da7:	75 0b                	jne    800db4 <__udivdi3+0x34>
  800da9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dae:	31 d2                	xor    %edx,%edx
  800db0:	f7 f3                	div    %ebx
  800db2:	89 c1                	mov    %eax,%ecx
  800db4:	31 d2                	xor    %edx,%edx
  800db6:	89 f0                	mov    %esi,%eax
  800db8:	f7 f1                	div    %ecx
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	89 e8                	mov    %ebp,%eax
  800dbe:	89 f7                	mov    %esi,%edi
  800dc0:	f7 f1                	div    %ecx
  800dc2:	89 fa                	mov    %edi,%edx
  800dc4:	83 c4 1c             	add    $0x1c,%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
  800dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800dd0:	39 f2                	cmp    %esi,%edx
  800dd2:	77 7c                	ja     800e50 <__udivdi3+0xd0>
  800dd4:	0f bd fa             	bsr    %edx,%edi
  800dd7:	83 f7 1f             	xor    $0x1f,%edi
  800dda:	0f 84 98 00 00 00    	je     800e78 <__udivdi3+0xf8>
  800de0:	89 f9                	mov    %edi,%ecx
  800de2:	b8 20 00 00 00       	mov    $0x20,%eax
  800de7:	29 f8                	sub    %edi,%eax
  800de9:	d3 e2                	shl    %cl,%edx
  800deb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800def:	89 c1                	mov    %eax,%ecx
  800df1:	89 da                	mov    %ebx,%edx
  800df3:	d3 ea                	shr    %cl,%edx
  800df5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800df9:	09 d1                	or     %edx,%ecx
  800dfb:	89 f2                	mov    %esi,%edx
  800dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e01:	89 f9                	mov    %edi,%ecx
  800e03:	d3 e3                	shl    %cl,%ebx
  800e05:	89 c1                	mov    %eax,%ecx
  800e07:	d3 ea                	shr    %cl,%edx
  800e09:	89 f9                	mov    %edi,%ecx
  800e0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e0f:	d3 e6                	shl    %cl,%esi
  800e11:	89 eb                	mov    %ebp,%ebx
  800e13:	89 c1                	mov    %eax,%ecx
  800e15:	d3 eb                	shr    %cl,%ebx
  800e17:	09 de                	or     %ebx,%esi
  800e19:	89 f0                	mov    %esi,%eax
  800e1b:	f7 74 24 08          	divl   0x8(%esp)
  800e1f:	89 d6                	mov    %edx,%esi
  800e21:	89 c3                	mov    %eax,%ebx
  800e23:	f7 64 24 0c          	mull   0xc(%esp)
  800e27:	39 d6                	cmp    %edx,%esi
  800e29:	72 0c                	jb     800e37 <__udivdi3+0xb7>
  800e2b:	89 f9                	mov    %edi,%ecx
  800e2d:	d3 e5                	shl    %cl,%ebp
  800e2f:	39 c5                	cmp    %eax,%ebp
  800e31:	73 5d                	jae    800e90 <__udivdi3+0x110>
  800e33:	39 d6                	cmp    %edx,%esi
  800e35:	75 59                	jne    800e90 <__udivdi3+0x110>
  800e37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e3a:	31 ff                	xor    %edi,%edi
  800e3c:	89 fa                	mov    %edi,%edx
  800e3e:	83 c4 1c             	add    $0x1c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
  800e46:	8d 76 00             	lea    0x0(%esi),%esi
  800e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e50:	31 ff                	xor    %edi,%edi
  800e52:	31 c0                	xor    %eax,%eax
  800e54:	89 fa                	mov    %edi,%edx
  800e56:	83 c4 1c             	add    $0x1c,%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
  800e5e:	66 90                	xchg   %ax,%ax
  800e60:	31 ff                	xor    %edi,%edi
  800e62:	89 e8                	mov    %ebp,%eax
  800e64:	89 f2                	mov    %esi,%edx
  800e66:	f7 f3                	div    %ebx
  800e68:	89 fa                	mov    %edi,%edx
  800e6a:	83 c4 1c             	add    $0x1c,%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
  800e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e78:	39 f2                	cmp    %esi,%edx
  800e7a:	72 06                	jb     800e82 <__udivdi3+0x102>
  800e7c:	31 c0                	xor    %eax,%eax
  800e7e:	39 eb                	cmp    %ebp,%ebx
  800e80:	77 d2                	ja     800e54 <__udivdi3+0xd4>
  800e82:	b8 01 00 00 00       	mov    $0x1,%eax
  800e87:	eb cb                	jmp    800e54 <__udivdi3+0xd4>
  800e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e90:	89 d8                	mov    %ebx,%eax
  800e92:	31 ff                	xor    %edi,%edi
  800e94:	eb be                	jmp    800e54 <__udivdi3+0xd4>
  800e96:	66 90                	xchg   %ax,%ax
  800e98:	66 90                	xchg   %ax,%ax
  800e9a:	66 90                	xchg   %ax,%ax
  800e9c:	66 90                	xchg   %ax,%ax
  800e9e:	66 90                	xchg   %ax,%ax

00800ea0 <__umoddi3>:
  800ea0:	55                   	push   %ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 1c             	sub    $0x1c,%esp
  800ea7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800eab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800eaf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800eb7:	85 ed                	test   %ebp,%ebp
  800eb9:	89 f0                	mov    %esi,%eax
  800ebb:	89 da                	mov    %ebx,%edx
  800ebd:	75 19                	jne    800ed8 <__umoddi3+0x38>
  800ebf:	39 df                	cmp    %ebx,%edi
  800ec1:	0f 86 b1 00 00 00    	jbe    800f78 <__umoddi3+0xd8>
  800ec7:	f7 f7                	div    %edi
  800ec9:	89 d0                	mov    %edx,%eax
  800ecb:	31 d2                	xor    %edx,%edx
  800ecd:	83 c4 1c             	add    $0x1c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
  800ed5:	8d 76 00             	lea    0x0(%esi),%esi
  800ed8:	39 dd                	cmp    %ebx,%ebp
  800eda:	77 f1                	ja     800ecd <__umoddi3+0x2d>
  800edc:	0f bd cd             	bsr    %ebp,%ecx
  800edf:	83 f1 1f             	xor    $0x1f,%ecx
  800ee2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ee6:	0f 84 b4 00 00 00    	je     800fa0 <__umoddi3+0x100>
  800eec:	b8 20 00 00 00       	mov    $0x20,%eax
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 c1                	mov    %eax,%ecx
  800efb:	89 f8                	mov    %edi,%eax
  800efd:	d3 e5                	shl    %cl,%ebp
  800eff:	89 d1                	mov    %edx,%ecx
  800f01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f05:	d3 e8                	shr    %cl,%eax
  800f07:	09 c5                	or     %eax,%ebp
  800f09:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f0d:	89 c1                	mov    %eax,%ecx
  800f0f:	d3 e7                	shl    %cl,%edi
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f17:	89 df                	mov    %ebx,%edi
  800f19:	d3 ef                	shr    %cl,%edi
  800f1b:	89 c1                	mov    %eax,%ecx
  800f1d:	89 f0                	mov    %esi,%eax
  800f1f:	d3 e3                	shl    %cl,%ebx
  800f21:	89 d1                	mov    %edx,%ecx
  800f23:	89 fa                	mov    %edi,%edx
  800f25:	d3 e8                	shr    %cl,%eax
  800f27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f2c:	09 d8                	or     %ebx,%eax
  800f2e:	f7 f5                	div    %ebp
  800f30:	d3 e6                	shl    %cl,%esi
  800f32:	89 d1                	mov    %edx,%ecx
  800f34:	f7 64 24 08          	mull   0x8(%esp)
  800f38:	39 d1                	cmp    %edx,%ecx
  800f3a:	89 c3                	mov    %eax,%ebx
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	72 06                	jb     800f46 <__umoddi3+0xa6>
  800f40:	75 0e                	jne    800f50 <__umoddi3+0xb0>
  800f42:	39 c6                	cmp    %eax,%esi
  800f44:	73 0a                	jae    800f50 <__umoddi3+0xb0>
  800f46:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f4a:	19 ea                	sbb    %ebp,%edx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	89 c3                	mov    %eax,%ebx
  800f50:	89 ca                	mov    %ecx,%edx
  800f52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f57:	29 de                	sub    %ebx,%esi
  800f59:	19 fa                	sbb    %edi,%edx
  800f5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f5f:	89 d0                	mov    %edx,%eax
  800f61:	d3 e0                	shl    %cl,%eax
  800f63:	89 d9                	mov    %ebx,%ecx
  800f65:	d3 ee                	shr    %cl,%esi
  800f67:	d3 ea                	shr    %cl,%edx
  800f69:	09 f0                	or     %esi,%eax
  800f6b:	83 c4 1c             	add    $0x1c,%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
  800f73:	90                   	nop
  800f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f78:	85 ff                	test   %edi,%edi
  800f7a:	89 f9                	mov    %edi,%ecx
  800f7c:	75 0b                	jne    800f89 <__umoddi3+0xe9>
  800f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f83:	31 d2                	xor    %edx,%edx
  800f85:	f7 f7                	div    %edi
  800f87:	89 c1                	mov    %eax,%ecx
  800f89:	89 d8                	mov    %ebx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	f7 f1                	div    %ecx
  800f8f:	89 f0                	mov    %esi,%eax
  800f91:	f7 f1                	div    %ecx
  800f93:	e9 31 ff ff ff       	jmp    800ec9 <__umoddi3+0x29>
  800f98:	90                   	nop
  800f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa0:	39 dd                	cmp    %ebx,%ebp
  800fa2:	72 08                	jb     800fac <__umoddi3+0x10c>
  800fa4:	39 f7                	cmp    %esi,%edi
  800fa6:	0f 87 21 ff ff ff    	ja     800ecd <__umoddi3+0x2d>
  800fac:	89 da                	mov    %ebx,%edx
  800fae:	89 f0                	mov    %esi,%eax
  800fb0:	29 f8                	sub    %edi,%eax
  800fb2:	19 ea                	sbb    %ebp,%edx
  800fb4:	e9 14 ff ff ff       	jmp    800ecd <__umoddi3+0x2d>
