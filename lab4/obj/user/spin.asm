
obj/user/spin：     文件格式 elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 60 10 80 00       	push   $0x801060
  80003f:	e8 4e 01 00 00       	call   800192 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 4f 0d 00 00       	call   800d98 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 d8 10 80 00       	push   $0x8010d8
  800058:	e8 35 01 00 00       	call   800192 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 88 10 80 00       	push   $0x801088
  80006c:	e8 21 01 00 00       	call   800192 <cprintf>
	sys_yield();
  800071:	e8 54 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  800076:	e8 4f 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  80007b:	e8 4a 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  800080:	e8 45 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  800085:	e8 40 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  80008a:	e8 3b 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  80008f:	e8 36 0b 00 00       	call   800bca <sys_yield>
	sys_yield();
  800094:	e8 31 0b 00 00       	call   800bca <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 b0 10 80 00 	movl   $0x8010b0,(%esp)
  8000a0:	e8 ed 00 00 00       	call   800192 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 bd 0a 00 00       	call   800b6a <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 08             	sub    $0x8,%esp
  8000bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000be:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000c1:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8000c8:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	7e 08                	jle    8000d7 <libmain+0x22>
		binaryname = argv[0];
  8000cf:	8b 0a                	mov    (%edx),%ecx
  8000d1:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	52                   	push   %edx
  8000db:	50                   	push   %eax
  8000dc:	e8 52 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e1:	e8 05 00 00 00       	call   8000eb <exit>
}
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	c9                   	leave  
  8000ea:	c3                   	ret    

008000eb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	e8 72 0a 00 00       	call   800b6a <sys_env_destroy>
}
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	c9                   	leave  
  8000fc:	c3                   	ret    

008000fd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fd:	55                   	push   %ebp
  8000fe:	89 e5                	mov    %esp,%ebp
  800100:	53                   	push   %ebx
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800107:	8b 13                	mov    (%ebx),%edx
  800109:	8d 42 01             	lea    0x1(%edx),%eax
  80010c:	89 03                	mov    %eax,(%ebx)
  80010e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800111:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800115:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011a:	74 09                	je     800125 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800123:	c9                   	leave  
  800124:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	68 ff 00 00 00       	push   $0xff
  80012d:	8d 43 08             	lea    0x8(%ebx),%eax
  800130:	50                   	push   %eax
  800131:	e8 f7 09 00 00       	call   800b2d <sys_cputs>
		b->idx = 0;
  800136:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	eb db                	jmp    80011c <putch+0x1f>

00800141 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800151:	00 00 00 
	b.cnt = 0;
  800154:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	68 fd 00 80 00       	push   $0x8000fd
  800170:	e8 1a 01 00 00       	call   80028f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800175:	83 c4 08             	add    $0x8,%esp
  800178:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 a3 09 00 00       	call   800b2d <sys_cputs>

	return b.cnt;
}
  80018a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800198:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019b:	50                   	push   %eax
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	e8 9d ff ff ff       	call   800141 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 1c             	sub    $0x1c,%esp
  8001af:	89 c7                	mov    %eax,%edi
  8001b1:	89 d6                	mov    %edx,%esi
  8001b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ca:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001cd:	39 d3                	cmp    %edx,%ebx
  8001cf:	72 05                	jb     8001d6 <printnum+0x30>
  8001d1:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d4:	77 7a                	ja     800250 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 18             	pushl  0x18(%ebp)
  8001dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8001df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e2:	53                   	push   %ebx
  8001e3:	ff 75 10             	pushl  0x10(%ebp)
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f5:	e8 16 0c 00 00       	call   800e10 <__udivdi3>
  8001fa:	83 c4 18             	add    $0x18,%esp
  8001fd:	52                   	push   %edx
  8001fe:	50                   	push   %eax
  8001ff:	89 f2                	mov    %esi,%edx
  800201:	89 f8                	mov    %edi,%eax
  800203:	e8 9e ff ff ff       	call   8001a6 <printnum>
  800208:	83 c4 20             	add    $0x20,%esp
  80020b:	eb 13                	jmp    800220 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	56                   	push   %esi
  800211:	ff 75 18             	pushl  0x18(%ebp)
  800214:	ff d7                	call   *%edi
  800216:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800219:	83 eb 01             	sub    $0x1,%ebx
  80021c:	85 db                	test   %ebx,%ebx
  80021e:	7f ed                	jg     80020d <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	56                   	push   %esi
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022a:	ff 75 e0             	pushl  -0x20(%ebp)
  80022d:	ff 75 dc             	pushl  -0x24(%ebp)
  800230:	ff 75 d8             	pushl  -0x28(%ebp)
  800233:	e8 f8 0c 00 00       	call   800f30 <__umoddi3>
  800238:	83 c4 14             	add    $0x14,%esp
  80023b:	0f be 80 00 11 80 00 	movsbl 0x801100(%eax),%eax
  800242:	50                   	push   %eax
  800243:	ff d7                	call   *%edi
}
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
  800250:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800253:	eb c4                	jmp    800219 <printnum+0x73>

00800255 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80025b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025f:	8b 10                	mov    (%eax),%edx
  800261:	3b 50 04             	cmp    0x4(%eax),%edx
  800264:	73 0a                	jae    800270 <sprintputch+0x1b>
		*b->buf++ = ch;
  800266:	8d 4a 01             	lea    0x1(%edx),%ecx
  800269:	89 08                	mov    %ecx,(%eax)
  80026b:	8b 45 08             	mov    0x8(%ebp),%eax
  80026e:	88 02                	mov    %al,(%edx)
}
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <printfmt>:
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800278:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027b:	50                   	push   %eax
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	ff 75 0c             	pushl  0xc(%ebp)
  800282:	ff 75 08             	pushl  0x8(%ebp)
  800285:	e8 05 00 00 00       	call   80028f <vprintfmt>
}
  80028a:	83 c4 10             	add    $0x10,%esp
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <vprintfmt>:
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	57                   	push   %edi
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 2c             	sub    $0x2c,%esp
  800298:	8b 75 08             	mov    0x8(%ebp),%esi
  80029b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a1:	e9 00 04 00 00       	jmp    8006a6 <vprintfmt+0x417>
		padc = ' ';
  8002a6:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002b1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c4:	8d 47 01             	lea    0x1(%edi),%eax
  8002c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ca:	0f b6 17             	movzbl (%edi),%edx
  8002cd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d0:	3c 55                	cmp    $0x55,%al
  8002d2:	0f 87 51 04 00 00    	ja     800729 <vprintfmt+0x49a>
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	ff 24 85 c0 11 80 00 	jmp    *0x8011c0(,%eax,4)
  8002e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e5:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e9:	eb d9                	jmp    8002c4 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ee:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002f2:	eb d0                	jmp    8002c4 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f4:	0f b6 d2             	movzbl %dl,%edx
  8002f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800302:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800305:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800309:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80030c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030f:	83 f9 09             	cmp    $0x9,%ecx
  800312:	77 55                	ja     800369 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800314:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800317:	eb e9                	jmp    800302 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800319:	8b 45 14             	mov    0x14(%ebp),%eax
  80031c:	8b 00                	mov    (%eax),%eax
  80031e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800321:	8b 45 14             	mov    0x14(%ebp),%eax
  800324:	8d 40 04             	lea    0x4(%eax),%eax
  800327:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800331:	79 91                	jns    8002c4 <vprintfmt+0x35>
				width = precision, precision = -1;
  800333:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800336:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800339:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800340:	eb 82                	jmp    8002c4 <vprintfmt+0x35>
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	85 c0                	test   %eax,%eax
  800347:	ba 00 00 00 00       	mov    $0x0,%edx
  80034c:	0f 49 d0             	cmovns %eax,%edx
  80034f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800355:	e9 6a ff ff ff       	jmp    8002c4 <vprintfmt+0x35>
  80035a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800364:	e9 5b ff ff ff       	jmp    8002c4 <vprintfmt+0x35>
  800369:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80036c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036f:	eb bc                	jmp    80032d <vprintfmt+0x9e>
			lflag++;
  800371:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800377:	e9 48 ff ff ff       	jmp    8002c4 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80037c:	8b 45 14             	mov    0x14(%ebp),%eax
  80037f:	8d 78 04             	lea    0x4(%eax),%edi
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	53                   	push   %ebx
  800386:	ff 30                	pushl  (%eax)
  800388:	ff d6                	call   *%esi
			break;
  80038a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800390:	e9 0e 03 00 00       	jmp    8006a3 <vprintfmt+0x414>
			err = va_arg(ap, int);
  800395:	8b 45 14             	mov    0x14(%ebp),%eax
  800398:	8d 78 04             	lea    0x4(%eax),%edi
  80039b:	8b 00                	mov    (%eax),%eax
  80039d:	99                   	cltd   
  80039e:	31 d0                	xor    %edx,%eax
  8003a0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	7f 23                	jg     8003ca <vprintfmt+0x13b>
  8003a7:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  8003ae:	85 d2                	test   %edx,%edx
  8003b0:	74 18                	je     8003ca <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003b2:	52                   	push   %edx
  8003b3:	68 21 11 80 00       	push   $0x801121
  8003b8:	53                   	push   %ebx
  8003b9:	56                   	push   %esi
  8003ba:	e8 b3 fe ff ff       	call   800272 <printfmt>
  8003bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c5:	e9 d9 02 00 00       	jmp    8006a3 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003ca:	50                   	push   %eax
  8003cb:	68 18 11 80 00       	push   $0x801118
  8003d0:	53                   	push   %ebx
  8003d1:	56                   	push   %esi
  8003d2:	e8 9b fe ff ff       	call   800272 <printfmt>
  8003d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003da:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003dd:	e9 c1 02 00 00       	jmp    8006a3 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	83 c0 04             	add    $0x4,%eax
  8003e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003f0:	85 ff                	test   %edi,%edi
  8003f2:	b8 11 11 80 00       	mov    $0x801111,%eax
  8003f7:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fe:	0f 8e bd 00 00 00    	jle    8004c1 <vprintfmt+0x232>
  800404:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800408:	75 0e                	jne    800418 <vprintfmt+0x189>
  80040a:	89 75 08             	mov    %esi,0x8(%ebp)
  80040d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800410:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800413:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800416:	eb 6d                	jmp    800485 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	ff 75 d0             	pushl  -0x30(%ebp)
  80041e:	57                   	push   %edi
  80041f:	e8 ad 03 00 00       	call   8007d1 <strnlen>
  800424:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800427:	29 c1                	sub    %eax,%ecx
  800429:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80042c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80042f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800439:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	eb 0f                	jmp    80044c <vprintfmt+0x1bd>
					putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	53                   	push   %ebx
  800441:	ff 75 e0             	pushl  -0x20(%ebp)
  800444:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800446:	83 ef 01             	sub    $0x1,%edi
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	85 ff                	test   %edi,%edi
  80044e:	7f ed                	jg     80043d <vprintfmt+0x1ae>
  800450:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800453:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800456:	85 c9                	test   %ecx,%ecx
  800458:	b8 00 00 00 00       	mov    $0x0,%eax
  80045d:	0f 49 c1             	cmovns %ecx,%eax
  800460:	29 c1                	sub    %eax,%ecx
  800462:	89 75 08             	mov    %esi,0x8(%ebp)
  800465:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800468:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80046b:	89 cb                	mov    %ecx,%ebx
  80046d:	eb 16                	jmp    800485 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80046f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800473:	75 31                	jne    8004a6 <vprintfmt+0x217>
					putch(ch, putdat);
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	ff 75 0c             	pushl  0xc(%ebp)
  80047b:	50                   	push   %eax
  80047c:	ff 55 08             	call   *0x8(%ebp)
  80047f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800482:	83 eb 01             	sub    $0x1,%ebx
  800485:	83 c7 01             	add    $0x1,%edi
  800488:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80048c:	0f be c2             	movsbl %dl,%eax
  80048f:	85 c0                	test   %eax,%eax
  800491:	74 59                	je     8004ec <vprintfmt+0x25d>
  800493:	85 f6                	test   %esi,%esi
  800495:	78 d8                	js     80046f <vprintfmt+0x1e0>
  800497:	83 ee 01             	sub    $0x1,%esi
  80049a:	79 d3                	jns    80046f <vprintfmt+0x1e0>
  80049c:	89 df                	mov    %ebx,%edi
  80049e:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a4:	eb 37                	jmp    8004dd <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a6:	0f be d2             	movsbl %dl,%edx
  8004a9:	83 ea 20             	sub    $0x20,%edx
  8004ac:	83 fa 5e             	cmp    $0x5e,%edx
  8004af:	76 c4                	jbe    800475 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	6a 3f                	push   $0x3f
  8004b9:	ff 55 08             	call   *0x8(%ebp)
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	eb c1                	jmp    800482 <vprintfmt+0x1f3>
  8004c1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ca:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004cd:	eb b6                	jmp    800485 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	6a 20                	push   $0x20
  8004d5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ee                	jg     8004cf <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e7:	e9 b7 01 00 00       	jmp    8006a3 <vprintfmt+0x414>
  8004ec:	89 df                	mov    %ebx,%edi
  8004ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f4:	eb e7                	jmp    8004dd <vprintfmt+0x24e>
	if (lflag >= 2)
  8004f6:	83 f9 01             	cmp    $0x1,%ecx
  8004f9:	7e 3f                	jle    80053a <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8b 50 04             	mov    0x4(%eax),%edx
  800501:	8b 00                	mov    (%eax),%eax
  800503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800506:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8d 40 08             	lea    0x8(%eax),%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800512:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800516:	79 5c                	jns    800574 <vprintfmt+0x2e5>
				putch('-', putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	6a 2d                	push   $0x2d
  80051e:	ff d6                	call   *%esi
				num = -(long long) num;
  800520:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800523:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800526:	f7 da                	neg    %edx
  800528:	83 d1 00             	adc    $0x0,%ecx
  80052b:	f7 d9                	neg    %ecx
  80052d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800530:	b8 0a 00 00 00       	mov    $0xa,%eax
  800535:	e9 4f 01 00 00       	jmp    800689 <vprintfmt+0x3fa>
	else if (lflag)
  80053a:	85 c9                	test   %ecx,%ecx
  80053c:	75 1b                	jne    800559 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800546:	89 c1                	mov    %eax,%ecx
  800548:	c1 f9 1f             	sar    $0x1f,%ecx
  80054b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8d 40 04             	lea    0x4(%eax),%eax
  800554:	89 45 14             	mov    %eax,0x14(%ebp)
  800557:	eb b9                	jmp    800512 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	89 c1                	mov    %eax,%ecx
  800563:	c1 f9 1f             	sar    $0x1f,%ecx
  800566:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 04             	lea    0x4(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	eb 9e                	jmp    800512 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800574:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800577:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	e9 05 01 00 00       	jmp    800689 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7e 18                	jle    8005a1 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 10                	mov    (%eax),%edx
  80058e:	8b 48 04             	mov    0x4(%eax),%ecx
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800597:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059c:	e9 e8 00 00 00       	jmp    800689 <vprintfmt+0x3fa>
	else if (lflag)
  8005a1:	85 c9                	test   %ecx,%ecx
  8005a3:	75 1a                	jne    8005bf <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005af:	8d 40 04             	lea    0x4(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ba:	e9 ca 00 00 00       	jmp    800689 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 10                	mov    (%eax),%edx
  8005c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c9:	8d 40 04             	lea    0x4(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d4:	e9 b0 00 00 00       	jmp    800689 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005d9:	83 f9 01             	cmp    $0x1,%ecx
  8005dc:	7e 3c                	jle    80061a <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 50 04             	mov    0x4(%eax),%edx
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8d 40 08             	lea    0x8(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f9:	79 59                	jns    800654 <vprintfmt+0x3c5>
                putch('-', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 2d                	push   $0x2d
  800601:	ff d6                	call   *%esi
                num = -(long long) num;
  800603:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800606:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800609:	f7 da                	neg    %edx
  80060b:	83 d1 00             	adc    $0x0,%ecx
  80060e:	f7 d9                	neg    %ecx
  800610:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800613:	b8 08 00 00 00       	mov    $0x8,%eax
  800618:	eb 6f                	jmp    800689 <vprintfmt+0x3fa>
	else if (lflag)
  80061a:	85 c9                	test   %ecx,%ecx
  80061c:	75 1b                	jne    800639 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800626:	89 c1                	mov    %eax,%ecx
  800628:	c1 f9 1f             	sar    $0x1f,%ecx
  80062b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	eb bc                	jmp    8005f5 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 c1                	mov    %eax,%ecx
  800643:	c1 f9 1f             	sar    $0x1f,%ecx
  800646:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb a1                	jmp    8005f5 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800654:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800657:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80065a:	b8 08 00 00 00       	mov    $0x8,%eax
  80065f:	eb 28                	jmp    800689 <vprintfmt+0x3fa>
			putch('0', putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	6a 30                	push   $0x30
  800667:	ff d6                	call   *%esi
			putch('x', putdat);
  800669:	83 c4 08             	add    $0x8,%esp
  80066c:	53                   	push   %ebx
  80066d:	6a 78                	push   $0x78
  80066f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80067b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800684:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800690:	57                   	push   %edi
  800691:	ff 75 e0             	pushl  -0x20(%ebp)
  800694:	50                   	push   %eax
  800695:	51                   	push   %ecx
  800696:	52                   	push   %edx
  800697:	89 da                	mov    %ebx,%edx
  800699:	89 f0                	mov    %esi,%eax
  80069b:	e8 06 fb ff ff       	call   8001a6 <printnum>
			break;
  8006a0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a6:	83 c7 01             	add    $0x1,%edi
  8006a9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ad:	83 f8 25             	cmp    $0x25,%eax
  8006b0:	0f 84 f0 fb ff ff    	je     8002a6 <vprintfmt+0x17>
			if (ch == '\0')
  8006b6:	85 c0                	test   %eax,%eax
  8006b8:	0f 84 8b 00 00 00    	je     800749 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	53                   	push   %ebx
  8006c2:	50                   	push   %eax
  8006c3:	ff d6                	call   *%esi
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	eb dc                	jmp    8006a6 <vprintfmt+0x417>
	if (lflag >= 2)
  8006ca:	83 f9 01             	cmp    $0x1,%ecx
  8006cd:	7e 15                	jle    8006e4 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d7:	8d 40 08             	lea    0x8(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e2:	eb a5                	jmp    800689 <vprintfmt+0x3fa>
	else if (lflag)
  8006e4:	85 c9                	test   %ecx,%ecx
  8006e6:	75 17                	jne    8006ff <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fd:	eb 8a                	jmp    800689 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070f:	b8 10 00 00 00       	mov    $0x10,%eax
  800714:	e9 70 ff ff ff       	jmp    800689 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 25                	push   $0x25
  80071f:	ff d6                	call   *%esi
			break;
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	e9 7a ff ff ff       	jmp    8006a3 <vprintfmt+0x414>
			putch('%', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	6a 25                	push   $0x25
  80072f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 f8                	mov    %edi,%eax
  800736:	eb 03                	jmp    80073b <vprintfmt+0x4ac>
  800738:	83 e8 01             	sub    $0x1,%eax
  80073b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80073f:	75 f7                	jne    800738 <vprintfmt+0x4a9>
  800741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800744:	e9 5a ff ff ff       	jmp    8006a3 <vprintfmt+0x414>
}
  800749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074c:	5b                   	pop    %ebx
  80074d:	5e                   	pop    %esi
  80074e:	5f                   	pop    %edi
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 18             	sub    $0x18,%esp
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800760:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800764:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 26                	je     800798 <vsnprintf+0x47>
  800772:	85 d2                	test   %edx,%edx
  800774:	7e 22                	jle    800798 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800776:	ff 75 14             	pushl  0x14(%ebp)
  800779:	ff 75 10             	pushl  0x10(%ebp)
  80077c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	68 55 02 80 00       	push   $0x800255
  800785:	e8 05 fb ff ff       	call   80028f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800793:	83 c4 10             	add    $0x10,%esp
}
  800796:	c9                   	leave  
  800797:	c3                   	ret    
		return -E_INVAL;
  800798:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079d:	eb f7                	jmp    800796 <vsnprintf+0x45>

0080079f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a8:	50                   	push   %eax
  8007a9:	ff 75 10             	pushl  0x10(%ebp)
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	ff 75 08             	pushl  0x8(%ebp)
  8007b2:	e8 9a ff ff ff       	call   800751 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	eb 03                	jmp    8007c9 <strlen+0x10>
		n++;
  8007c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007cd:	75 f7                	jne    8007c6 <strlen+0xd>
	return n;
}
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	eb 03                	jmp    8007e4 <strnlen+0x13>
		n++;
  8007e1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e4:	39 d0                	cmp    %edx,%eax
  8007e6:	74 06                	je     8007ee <strnlen+0x1d>
  8007e8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007ec:	75 f3                	jne    8007e1 <strnlen+0x10>
	return n;
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	53                   	push   %ebx
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	83 c1 01             	add    $0x1,%ecx
  8007ff:	83 c2 01             	add    $0x1,%edx
  800802:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800806:	88 5a ff             	mov    %bl,-0x1(%edx)
  800809:	84 db                	test   %bl,%bl
  80080b:	75 ef                	jne    8007fc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80080d:	5b                   	pop    %ebx
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	53                   	push   %ebx
  800814:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800817:	53                   	push   %ebx
  800818:	e8 9c ff ff ff       	call   8007b9 <strlen>
  80081d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	01 d8                	add    %ebx,%eax
  800825:	50                   	push   %eax
  800826:	e8 c5 ff ff ff       	call   8007f0 <strcpy>
	return dst;
}
  80082b:	89 d8                	mov    %ebx,%eax
  80082d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083d:	89 f3                	mov    %esi,%ebx
  80083f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800842:	89 f2                	mov    %esi,%edx
  800844:	eb 0f                	jmp    800855 <strncpy+0x23>
		*dst++ = *src;
  800846:	83 c2 01             	add    $0x1,%edx
  800849:	0f b6 01             	movzbl (%ecx),%eax
  80084c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084f:	80 39 01             	cmpb   $0x1,(%ecx)
  800852:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800855:	39 da                	cmp    %ebx,%edx
  800857:	75 ed                	jne    800846 <strncpy+0x14>
	}
	return ret;
}
  800859:	89 f0                	mov    %esi,%eax
  80085b:	5b                   	pop    %ebx
  80085c:	5e                   	pop    %esi
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800873:	85 c9                	test   %ecx,%ecx
  800875:	75 0b                	jne    800882 <strlcpy+0x23>
  800877:	eb 17                	jmp    800890 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800879:	83 c2 01             	add    $0x1,%edx
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800882:	39 d8                	cmp    %ebx,%eax
  800884:	74 07                	je     80088d <strlcpy+0x2e>
  800886:	0f b6 0a             	movzbl (%edx),%ecx
  800889:	84 c9                	test   %cl,%cl
  80088b:	75 ec                	jne    800879 <strlcpy+0x1a>
		*dst = '\0';
  80088d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800890:	29 f0                	sub    %esi,%eax
}
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089f:	eb 06                	jmp    8008a7 <strcmp+0x11>
		p++, q++;
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	84 c0                	test   %al,%al
  8008ac:	74 04                	je     8008b2 <strcmp+0x1c>
  8008ae:	3a 02                	cmp    (%edx),%al
  8008b0:	74 ef                	je     8008a1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	0f b6 12             	movzbl (%edx),%edx
  8008b8:	29 d0                	sub    %edx,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	53                   	push   %ebx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	89 c3                	mov    %eax,%ebx
  8008c8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cb:	eb 06                	jmp    8008d3 <strncmp+0x17>
		n--, p++, q++;
  8008cd:	83 c0 01             	add    $0x1,%eax
  8008d0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d3:	39 d8                	cmp    %ebx,%eax
  8008d5:	74 16                	je     8008ed <strncmp+0x31>
  8008d7:	0f b6 08             	movzbl (%eax),%ecx
  8008da:	84 c9                	test   %cl,%cl
  8008dc:	74 04                	je     8008e2 <strncmp+0x26>
  8008de:	3a 0a                	cmp    (%edx),%cl
  8008e0:	74 eb                	je     8008cd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e2:	0f b6 00             	movzbl (%eax),%eax
  8008e5:	0f b6 12             	movzbl (%edx),%edx
  8008e8:	29 d0                	sub    %edx,%eax
}
  8008ea:	5b                   	pop    %ebx
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    
		return 0;
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f2:	eb f6                	jmp    8008ea <strncmp+0x2e>

008008f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fe:	0f b6 10             	movzbl (%eax),%edx
  800901:	84 d2                	test   %dl,%dl
  800903:	74 09                	je     80090e <strchr+0x1a>
		if (*s == c)
  800905:	38 ca                	cmp    %cl,%dl
  800907:	74 0a                	je     800913 <strchr+0x1f>
	for (; *s; s++)
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f0                	jmp    8008fe <strchr+0xa>
			return (char *) s;
	return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091f:	eb 03                	jmp    800924 <strfind+0xf>
  800921:	83 c0 01             	add    $0x1,%eax
  800924:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	74 04                	je     80092f <strfind+0x1a>
  80092b:	84 d2                	test   %dl,%dl
  80092d:	75 f2                	jne    800921 <strfind+0xc>
			break;
	return (char *) s;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	57                   	push   %edi
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	74 13                	je     800954 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800941:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800947:	75 05                	jne    80094e <memset+0x1d>
  800949:	f6 c1 03             	test   $0x3,%cl
  80094c:	74 0d                	je     80095b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	fc                   	cld    
  800952:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800954:	89 f8                	mov    %edi,%eax
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    
		c &= 0xFF;
  80095b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095f:	89 d3                	mov    %edx,%ebx
  800961:	c1 e3 08             	shl    $0x8,%ebx
  800964:	89 d0                	mov    %edx,%eax
  800966:	c1 e0 18             	shl    $0x18,%eax
  800969:	89 d6                	mov    %edx,%esi
  80096b:	c1 e6 10             	shl    $0x10,%esi
  80096e:	09 f0                	or     %esi,%eax
  800970:	09 c2                	or     %eax,%edx
  800972:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800974:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800977:	89 d0                	mov    %edx,%eax
  800979:	fc                   	cld    
  80097a:	f3 ab                	rep stos %eax,%es:(%edi)
  80097c:	eb d6                	jmp    800954 <memset+0x23>

0080097e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	57                   	push   %edi
  800982:	56                   	push   %esi
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 75 0c             	mov    0xc(%ebp),%esi
  800989:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098c:	39 c6                	cmp    %eax,%esi
  80098e:	73 35                	jae    8009c5 <memmove+0x47>
  800990:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800993:	39 c2                	cmp    %eax,%edx
  800995:	76 2e                	jbe    8009c5 <memmove+0x47>
		s += n;
		d += n;
  800997:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099a:	89 d6                	mov    %edx,%esi
  80099c:	09 fe                	or     %edi,%esi
  80099e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a4:	74 0c                	je     8009b2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a6:	83 ef 01             	sub    $0x1,%edi
  8009a9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009af:	fc                   	cld    
  8009b0:	eb 21                	jmp    8009d3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	f6 c1 03             	test   $0x3,%cl
  8009b5:	75 ef                	jne    8009a6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b7:	83 ef 04             	sub    $0x4,%edi
  8009ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c3:	eb ea                	jmp    8009af <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c5:	89 f2                	mov    %esi,%edx
  8009c7:	09 c2                	or     %eax,%edx
  8009c9:	f6 c2 03             	test   $0x3,%dl
  8009cc:	74 09                	je     8009d7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ce:	89 c7                	mov    %eax,%edi
  8009d0:	fc                   	cld    
  8009d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d3:	5e                   	pop    %esi
  8009d4:	5f                   	pop    %edi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	75 f2                	jne    8009ce <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb ed                	jmp    8009d3 <memmove+0x55>

008009e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e9:	ff 75 10             	pushl  0x10(%ebp)
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	e8 87 ff ff ff       	call   80097e <memmove>
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	56                   	push   %esi
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a04:	89 c6                	mov    %eax,%esi
  800a06:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a09:	39 f0                	cmp    %esi,%eax
  800a0b:	74 1c                	je     800a29 <memcmp+0x30>
		if (*s1 != *s2)
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	0f b6 1a             	movzbl (%edx),%ebx
  800a13:	38 d9                	cmp    %bl,%cl
  800a15:	75 08                	jne    800a1f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	eb ea                	jmp    800a09 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a1f:	0f b6 c1             	movzbl %cl,%eax
  800a22:	0f b6 db             	movzbl %bl,%ebx
  800a25:	29 d8                	sub    %ebx,%eax
  800a27:	eb 05                	jmp    800a2e <memcmp+0x35>
	}

	return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2e:	5b                   	pop    %ebx
  800a2f:	5e                   	pop    %esi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a40:	39 d0                	cmp    %edx,%eax
  800a42:	73 09                	jae    800a4d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a44:	38 08                	cmp    %cl,(%eax)
  800a46:	74 05                	je     800a4d <memfind+0x1b>
	for (; s < ends; s++)
  800a48:	83 c0 01             	add    $0x1,%eax
  800a4b:	eb f3                	jmp    800a40 <memfind+0xe>
			break;
	return (void *) s;
}
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	57                   	push   %edi
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5b:	eb 03                	jmp    800a60 <strtol+0x11>
		s++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a60:	0f b6 01             	movzbl (%ecx),%eax
  800a63:	3c 20                	cmp    $0x20,%al
  800a65:	74 f6                	je     800a5d <strtol+0xe>
  800a67:	3c 09                	cmp    $0x9,%al
  800a69:	74 f2                	je     800a5d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a6b:	3c 2b                	cmp    $0x2b,%al
  800a6d:	74 2e                	je     800a9d <strtol+0x4e>
	int neg = 0;
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a74:	3c 2d                	cmp    $0x2d,%al
  800a76:	74 2f                	je     800aa7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7e:	75 05                	jne    800a85 <strtol+0x36>
  800a80:	80 39 30             	cmpb   $0x30,(%ecx)
  800a83:	74 2c                	je     800ab1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	75 0a                	jne    800a93 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a89:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a8e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a91:	74 28                	je     800abb <strtol+0x6c>
		base = 10;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9b:	eb 50                	jmp    800aed <strtol+0x9e>
		s++;
  800a9d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa5:	eb d1                	jmp    800a78 <strtol+0x29>
		s++, neg = 1;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	bf 01 00 00 00       	mov    $0x1,%edi
  800aaf:	eb c7                	jmp    800a78 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab5:	74 0e                	je     800ac5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	75 d8                	jne    800a93 <strtol+0x44>
		s++, base = 8;
  800abb:	83 c1 01             	add    $0x1,%ecx
  800abe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac3:	eb ce                	jmp    800a93 <strtol+0x44>
		s += 2, base = 16;
  800ac5:	83 c1 02             	add    $0x2,%ecx
  800ac8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800acd:	eb c4                	jmp    800a93 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800acf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad2:	89 f3                	mov    %esi,%ebx
  800ad4:	80 fb 19             	cmp    $0x19,%bl
  800ad7:	77 29                	ja     800b02 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad9:	0f be d2             	movsbl %dl,%edx
  800adc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800adf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae2:	7d 30                	jge    800b14 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae4:	83 c1 01             	add    $0x1,%ecx
  800ae7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aeb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aed:	0f b6 11             	movzbl (%ecx),%edx
  800af0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af3:	89 f3                	mov    %esi,%ebx
  800af5:	80 fb 09             	cmp    $0x9,%bl
  800af8:	77 d5                	ja     800acf <strtol+0x80>
			dig = *s - '0';
  800afa:	0f be d2             	movsbl %dl,%edx
  800afd:	83 ea 30             	sub    $0x30,%edx
  800b00:	eb dd                	jmp    800adf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b02:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b05:	89 f3                	mov    %esi,%ebx
  800b07:	80 fb 19             	cmp    $0x19,%bl
  800b0a:	77 08                	ja     800b14 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b0c:	0f be d2             	movsbl %dl,%edx
  800b0f:	83 ea 37             	sub    $0x37,%edx
  800b12:	eb cb                	jmp    800adf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b18:	74 05                	je     800b1f <strtol+0xd0>
		*endptr = (char *) s;
  800b1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	f7 da                	neg    %edx
  800b23:	85 ff                	test   %edi,%edi
  800b25:	0f 45 c2             	cmovne %edx,%eax
}
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5f                   	pop    %edi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
  800b38:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3e:	89 c3                	mov    %eax,%ebx
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	89 c6                	mov    %eax,%esi
  800b44:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5f                   	pop    %edi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <sys_cgetc>:

int
sys_cgetc(void) {
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	57                   	push   %edi
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5b:	89 d1                	mov    %edx,%ecx
  800b5d:	89 d3                	mov    %edx,%ebx
  800b5f:	89 d7                	mov    %edx,%edi
  800b61:	89 d6                	mov    %edx,%esi
  800b63:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5f                   	pop    %edi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b80:	89 cb                	mov    %ecx,%ebx
  800b82:	89 cf                	mov    %ecx,%edi
  800b84:	89 ce                	mov    %ecx,%esi
  800b86:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b88:	85 c0                	test   %eax,%eax
  800b8a:	7f 08                	jg     800b94 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	50                   	push   %eax
  800b98:	6a 03                	push   $0x3
  800b9a:	68 44 13 80 00       	push   $0x801344
  800b9f:	6a 24                	push   $0x24
  800ba1:	68 61 13 80 00       	push   $0x801361
  800ba6:	e8 1b 02 00 00       	call   800dc6 <_panic>

00800bab <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb6:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbb:	89 d1                	mov    %edx,%ecx
  800bbd:	89 d3                	mov    %edx,%ebx
  800bbf:	89 d7                	mov    %edx,%edi
  800bc1:	89 d6                	mov    %edx,%esi
  800bc3:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <sys_yield>:

void
sys_yield(void)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bda:	89 d1                	mov    %edx,%ecx
  800bdc:	89 d3                	mov    %edx,%ebx
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bf2:	be 00 00 00 00       	mov    $0x0,%esi
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	b8 04 00 00 00       	mov    $0x4,%eax
  800c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c05:	89 f7                	mov    %esi,%edi
  800c07:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	7f 08                	jg     800c15 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	6a 04                	push   $0x4
  800c1b:	68 44 13 80 00       	push   $0x801344
  800c20:	6a 24                	push   $0x24
  800c22:	68 61 13 80 00       	push   $0x801361
  800c27:	e8 9a 01 00 00       	call   800dc6 <_panic>

00800c2c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c46:	8b 75 18             	mov    0x18(%ebp),%esi
  800c49:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 05                	push   $0x5
  800c5d:	68 44 13 80 00       	push   $0x801344
  800c62:	6a 24                	push   $0x24
  800c64:	68 61 13 80 00       	push   $0x801361
  800c69:	e8 58 01 00 00       	call   800dc6 <_panic>

00800c6e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 06 00 00 00       	mov    $0x6,%eax
  800c87:	89 df                	mov    %ebx,%edi
  800c89:	89 de                	mov    %ebx,%esi
  800c8b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 06                	push   $0x6
  800c9f:	68 44 13 80 00       	push   $0x801344
  800ca4:	6a 24                	push   $0x24
  800ca6:	68 61 13 80 00       	push   $0x801361
  800cab:	e8 16 01 00 00       	call   800dc6 <_panic>

00800cb0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 08                	push   $0x8
  800ce1:	68 44 13 80 00       	push   $0x801344
  800ce6:	6a 24                	push   $0x24
  800ce8:	68 61 13 80 00       	push   $0x801361
  800ced:	e8 d4 00 00 00       	call   800dc6 <_panic>

00800cf2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	89 de                	mov    %ebx,%esi
  800d0f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7f 08                	jg     800d1d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	50                   	push   %eax
  800d21:	6a 09                	push   $0x9
  800d23:	68 44 13 80 00       	push   $0x801344
  800d28:	6a 24                	push   $0x24
  800d2a:	68 61 13 80 00       	push   $0x801361
  800d2f:	e8 92 00 00 00       	call   800dc6 <_panic>

00800d34 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d45:	be 00 00 00 00       	mov    $0x0,%esi
  800d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d50:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d60:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6d:	89 cb                	mov    %ecx,%ebx
  800d6f:	89 cf                	mov    %ecx,%edi
  800d71:	89 ce                	mov    %ecx,%esi
  800d73:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 0c                	push   $0xc
  800d87:	68 44 13 80 00       	push   $0x801344
  800d8c:	6a 24                	push   $0x24
  800d8e:	68 61 13 80 00       	push   $0x801361
  800d93:	e8 2e 00 00 00       	call   800dc6 <_panic>

00800d98 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800d9e:	68 7b 13 80 00       	push   $0x80137b
  800da3:	6a 51                	push   $0x51
  800da5:	68 6f 13 80 00       	push   $0x80136f
  800daa:	e8 17 00 00 00       	call   800dc6 <_panic>

00800daf <sfork>:
}

// Challenge!
int
sfork(void)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800db5:	68 7a 13 80 00       	push   $0x80137a
  800dba:	6a 58                	push   $0x58
  800dbc:	68 6f 13 80 00       	push   $0x80136f
  800dc1:	e8 00 00 00 00       	call   800dc6 <_panic>

00800dc6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800dcb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800dce:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800dd4:	e8 d2 fd ff ff       	call   800bab <sys_getenvid>
  800dd9:	83 ec 0c             	sub    $0xc,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	ff 75 08             	pushl  0x8(%ebp)
  800de2:	56                   	push   %esi
  800de3:	50                   	push   %eax
  800de4:	68 90 13 80 00       	push   $0x801390
  800de9:	e8 a4 f3 ff ff       	call   800192 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800dee:	83 c4 18             	add    $0x18,%esp
  800df1:	53                   	push   %ebx
  800df2:	ff 75 10             	pushl  0x10(%ebp)
  800df5:	e8 47 f3 ff ff       	call   800141 <vcprintf>
	cprintf("\n");
  800dfa:	c7 04 24 f4 10 80 00 	movl   $0x8010f4,(%esp)
  800e01:	e8 8c f3 ff ff       	call   800192 <cprintf>
  800e06:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e09:	cc                   	int3   
  800e0a:	eb fd                	jmp    800e09 <_panic+0x43>
  800e0c:	66 90                	xchg   %ax,%ax
  800e0e:	66 90                	xchg   %ax,%ax

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
