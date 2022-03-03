
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
  80003a:	68 40 13 80 00       	push   $0x801340
  80003f:	e8 5e 01 00 00       	call   8001a2 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 1a 0e 00 00       	call   800e63 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 b8 13 80 00       	push   $0x8013b8
  800058:	e8 45 01 00 00       	call   8001a2 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 68 13 80 00       	push   $0x801368
  80006c:	e8 31 01 00 00       	call   8001a2 <cprintf>
	sys_yield();
  800071:	e8 64 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  800076:	e8 5f 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  80007b:	e8 5a 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  800080:	e8 55 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  800085:	e8 50 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  80008a:	e8 4b 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  80008f:	e8 46 0b 00 00       	call   800bda <sys_yield>
	sys_yield();
  800094:	e8 41 0b 00 00       	call   800bda <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 90 13 80 00 	movl   $0x801390,(%esp)
  8000a0:	e8 fd 00 00 00       	call   8001a2 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 cd 0a 00 00       	call   800b7a <sys_env_destroy>
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
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 f6 0a 00 00       	call   800bbb <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800101:	6a 00                	push   $0x0
  800103:	e8 72 0a 00 00       	call   800b7a <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	53                   	push   %ebx
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800117:	8b 13                	mov    (%ebx),%edx
  800119:	8d 42 01             	lea    0x1(%edx),%eax
  80011c:	89 03                	mov    %eax,(%ebx)
  80011e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800121:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800125:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012a:	74 09                	je     800135 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800133:	c9                   	leave  
  800134:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 ff 00 00 00       	push   $0xff
  80013d:	8d 43 08             	lea    0x8(%ebx),%eax
  800140:	50                   	push   %eax
  800141:	e8 f7 09 00 00       	call   800b3d <sys_cputs>
		b->idx = 0;
  800146:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	eb db                	jmp    80012c <putch+0x1f>

00800151 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800161:	00 00 00 
	b.cnt = 0;
  800164:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016e:	ff 75 0c             	pushl  0xc(%ebp)
  800171:	ff 75 08             	pushl  0x8(%ebp)
  800174:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	68 0d 01 80 00       	push   $0x80010d
  800180:	e8 1a 01 00 00       	call   80029f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800185:	83 c4 08             	add    $0x8,%esp
  800188:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80018e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 a3 09 00 00       	call   800b3d <sys_cputs>

	return b.cnt;
}
  80019a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ab:	50                   	push   %eax
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 9d ff ff ff       	call   800151 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	57                   	push   %edi
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 1c             	sub    $0x1c,%esp
  8001bf:	89 c7                	mov    %eax,%edi
  8001c1:	89 d6                	mov    %edx,%esi
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001da:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001dd:	39 d3                	cmp    %edx,%ebx
  8001df:	72 05                	jb     8001e6 <printnum+0x30>
  8001e1:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001e4:	77 7a                	ja     800260 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e6:	83 ec 0c             	sub    $0xc,%esp
  8001e9:	ff 75 18             	pushl  0x18(%ebp)
  8001ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8001ef:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001f2:	53                   	push   %ebx
  8001f3:	ff 75 10             	pushl  0x10(%ebp)
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800202:	ff 75 d8             	pushl  -0x28(%ebp)
  800205:	e8 f6 0e 00 00       	call   801100 <__udivdi3>
  80020a:	83 c4 18             	add    $0x18,%esp
  80020d:	52                   	push   %edx
  80020e:	50                   	push   %eax
  80020f:	89 f2                	mov    %esi,%edx
  800211:	89 f8                	mov    %edi,%eax
  800213:	e8 9e ff ff ff       	call   8001b6 <printnum>
  800218:	83 c4 20             	add    $0x20,%esp
  80021b:	eb 13                	jmp    800230 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	ff 75 18             	pushl  0x18(%ebp)
  800224:	ff d7                	call   *%edi
  800226:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800229:	83 eb 01             	sub    $0x1,%ebx
  80022c:	85 db                	test   %ebx,%ebx
  80022e:	7f ed                	jg     80021d <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	56                   	push   %esi
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	ff 75 e0             	pushl  -0x20(%ebp)
  80023d:	ff 75 dc             	pushl  -0x24(%ebp)
  800240:	ff 75 d8             	pushl  -0x28(%ebp)
  800243:	e8 d8 0f 00 00       	call   801220 <__umoddi3>
  800248:	83 c4 14             	add    $0x14,%esp
  80024b:	0f be 80 e0 13 80 00 	movsbl 0x8013e0(%eax),%eax
  800252:	50                   	push   %eax
  800253:	ff d7                	call   *%edi
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025b:	5b                   	pop    %ebx
  80025c:	5e                   	pop    %esi
  80025d:	5f                   	pop    %edi
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    
  800260:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800263:	eb c4                	jmp    800229 <printnum+0x73>

00800265 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80026b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026f:	8b 10                	mov    (%eax),%edx
  800271:	3b 50 04             	cmp    0x4(%eax),%edx
  800274:	73 0a                	jae    800280 <sprintputch+0x1b>
		*b->buf++ = ch;
  800276:	8d 4a 01             	lea    0x1(%edx),%ecx
  800279:	89 08                	mov    %ecx,(%eax)
  80027b:	8b 45 08             	mov    0x8(%ebp),%eax
  80027e:	88 02                	mov    %al,(%edx)
}
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <printfmt>:
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800288:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80028b:	50                   	push   %eax
  80028c:	ff 75 10             	pushl  0x10(%ebp)
  80028f:	ff 75 0c             	pushl  0xc(%ebp)
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	e8 05 00 00 00       	call   80029f <vprintfmt>
}
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <vprintfmt>:
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 2c             	sub    $0x2c,%esp
  8002a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b1:	e9 00 04 00 00       	jmp    8006b6 <vprintfmt+0x417>
		padc = ' ';
  8002b6:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ba:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002c1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002cf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d4:	8d 47 01             	lea    0x1(%edi),%eax
  8002d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002da:	0f b6 17             	movzbl (%edi),%edx
  8002dd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e0:	3c 55                	cmp    $0x55,%al
  8002e2:	0f 87 51 04 00 00    	ja     800739 <vprintfmt+0x49a>
  8002e8:	0f b6 c0             	movzbl %al,%eax
  8002eb:	ff 24 85 a0 14 80 00 	jmp    *0x8014a0(,%eax,4)
  8002f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f5:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002f9:	eb d9                	jmp    8002d4 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002fe:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800302:	eb d0                	jmp    8002d4 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800304:	0f b6 d2             	movzbl %dl,%edx
  800307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800312:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800315:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800319:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80031c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80031f:	83 f9 09             	cmp    $0x9,%ecx
  800322:	77 55                	ja     800379 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800324:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800327:	eb e9                	jmp    800312 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800329:	8b 45 14             	mov    0x14(%ebp),%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8d 40 04             	lea    0x4(%eax),%eax
  800337:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80033d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800341:	79 91                	jns    8002d4 <vprintfmt+0x35>
				width = precision, precision = -1;
  800343:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800346:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800349:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800350:	eb 82                	jmp    8002d4 <vprintfmt+0x35>
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	85 c0                	test   %eax,%eax
  800357:	ba 00 00 00 00       	mov    $0x0,%edx
  80035c:	0f 49 d0             	cmovns %eax,%edx
  80035f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800362:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800365:	e9 6a ff ff ff       	jmp    8002d4 <vprintfmt+0x35>
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800374:	e9 5b ff ff ff       	jmp    8002d4 <vprintfmt+0x35>
  800379:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	eb bc                	jmp    80033d <vprintfmt+0x9e>
			lflag++;
  800381:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800387:	e9 48 ff ff ff       	jmp    8002d4 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8d 78 04             	lea    0x4(%eax),%edi
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	53                   	push   %ebx
  800396:	ff 30                	pushl  (%eax)
  800398:	ff d6                	call   *%esi
			break;
  80039a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80039d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a0:	e9 0e 03 00 00       	jmp    8006b3 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	8d 78 04             	lea    0x4(%eax),%edi
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	99                   	cltd   
  8003ae:	31 d0                	xor    %edx,%eax
  8003b0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b2:	83 f8 08             	cmp    $0x8,%eax
  8003b5:	7f 23                	jg     8003da <vprintfmt+0x13b>
  8003b7:	8b 14 85 00 16 80 00 	mov    0x801600(,%eax,4),%edx
  8003be:	85 d2                	test   %edx,%edx
  8003c0:	74 18                	je     8003da <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003c2:	52                   	push   %edx
  8003c3:	68 01 14 80 00       	push   $0x801401
  8003c8:	53                   	push   %ebx
  8003c9:	56                   	push   %esi
  8003ca:	e8 b3 fe ff ff       	call   800282 <printfmt>
  8003cf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d5:	e9 d9 02 00 00       	jmp    8006b3 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003da:	50                   	push   %eax
  8003db:	68 f8 13 80 00       	push   $0x8013f8
  8003e0:	53                   	push   %ebx
  8003e1:	56                   	push   %esi
  8003e2:	e8 9b fe ff ff       	call   800282 <printfmt>
  8003e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ea:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ed:	e9 c1 02 00 00       	jmp    8006b3 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	83 c0 04             	add    $0x4,%eax
  8003f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800400:	85 ff                	test   %edi,%edi
  800402:	b8 f1 13 80 00       	mov    $0x8013f1,%eax
  800407:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80040a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040e:	0f 8e bd 00 00 00    	jle    8004d1 <vprintfmt+0x232>
  800414:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800418:	75 0e                	jne    800428 <vprintfmt+0x189>
  80041a:	89 75 08             	mov    %esi,0x8(%ebp)
  80041d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800420:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800423:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800426:	eb 6d                	jmp    800495 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	ff 75 d0             	pushl  -0x30(%ebp)
  80042e:	57                   	push   %edi
  80042f:	e8 ad 03 00 00       	call   8007e1 <strnlen>
  800434:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800437:	29 c1                	sub    %eax,%ecx
  800439:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80043c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80043f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800443:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800446:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800449:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	eb 0f                	jmp    80045c <vprintfmt+0x1bd>
					putch(padc, putdat);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	53                   	push   %ebx
  800451:	ff 75 e0             	pushl  -0x20(%ebp)
  800454:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800456:	83 ef 01             	sub    $0x1,%edi
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	85 ff                	test   %edi,%edi
  80045e:	7f ed                	jg     80044d <vprintfmt+0x1ae>
  800460:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800463:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800466:	85 c9                	test   %ecx,%ecx
  800468:	b8 00 00 00 00       	mov    $0x0,%eax
  80046d:	0f 49 c1             	cmovns %ecx,%eax
  800470:	29 c1                	sub    %eax,%ecx
  800472:	89 75 08             	mov    %esi,0x8(%ebp)
  800475:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800478:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80047b:	89 cb                	mov    %ecx,%ebx
  80047d:	eb 16                	jmp    800495 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80047f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800483:	75 31                	jne    8004b6 <vprintfmt+0x217>
					putch(ch, putdat);
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	ff 75 0c             	pushl  0xc(%ebp)
  80048b:	50                   	push   %eax
  80048c:	ff 55 08             	call   *0x8(%ebp)
  80048f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800492:	83 eb 01             	sub    $0x1,%ebx
  800495:	83 c7 01             	add    $0x1,%edi
  800498:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80049c:	0f be c2             	movsbl %dl,%eax
  80049f:	85 c0                	test   %eax,%eax
  8004a1:	74 59                	je     8004fc <vprintfmt+0x25d>
  8004a3:	85 f6                	test   %esi,%esi
  8004a5:	78 d8                	js     80047f <vprintfmt+0x1e0>
  8004a7:	83 ee 01             	sub    $0x1,%esi
  8004aa:	79 d3                	jns    80047f <vprintfmt+0x1e0>
  8004ac:	89 df                	mov    %ebx,%edi
  8004ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b4:	eb 37                	jmp    8004ed <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b6:	0f be d2             	movsbl %dl,%edx
  8004b9:	83 ea 20             	sub    $0x20,%edx
  8004bc:	83 fa 5e             	cmp    $0x5e,%edx
  8004bf:	76 c4                	jbe    800485 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	ff 75 0c             	pushl  0xc(%ebp)
  8004c7:	6a 3f                	push   $0x3f
  8004c9:	ff 55 08             	call   *0x8(%ebp)
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	eb c1                	jmp    800492 <vprintfmt+0x1f3>
  8004d1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004da:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004dd:	eb b6                	jmp    800495 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	53                   	push   %ebx
  8004e3:	6a 20                	push   $0x20
  8004e5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ee                	jg     8004df <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f7:	e9 b7 01 00 00       	jmp    8006b3 <vprintfmt+0x414>
  8004fc:	89 df                	mov    %ebx,%edi
  8004fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800501:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800504:	eb e7                	jmp    8004ed <vprintfmt+0x24e>
	if (lflag >= 2)
  800506:	83 f9 01             	cmp    $0x1,%ecx
  800509:	7e 3f                	jle    80054a <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8b 50 04             	mov    0x4(%eax),%edx
  800511:	8b 00                	mov    (%eax),%eax
  800513:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800516:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 08             	lea    0x8(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800522:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800526:	79 5c                	jns    800584 <vprintfmt+0x2e5>
				putch('-', putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	53                   	push   %ebx
  80052c:	6a 2d                	push   $0x2d
  80052e:	ff d6                	call   *%esi
				num = -(long long) num;
  800530:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800533:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800536:	f7 da                	neg    %edx
  800538:	83 d1 00             	adc    $0x0,%ecx
  80053b:	f7 d9                	neg    %ecx
  80053d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800540:	b8 0a 00 00 00       	mov    $0xa,%eax
  800545:	e9 4f 01 00 00       	jmp    800699 <vprintfmt+0x3fa>
	else if (lflag)
  80054a:	85 c9                	test   %ecx,%ecx
  80054c:	75 1b                	jne    800569 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800556:	89 c1                	mov    %eax,%ecx
  800558:	c1 f9 1f             	sar    $0x1f,%ecx
  80055b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 40 04             	lea    0x4(%eax),%eax
  800564:	89 45 14             	mov    %eax,0x14(%ebp)
  800567:	eb b9                	jmp    800522 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	89 c1                	mov    %eax,%ecx
  800573:	c1 f9 1f             	sar    $0x1f,%ecx
  800576:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	eb 9e                	jmp    800522 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800584:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800587:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80058a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058f:	e9 05 01 00 00       	jmp    800699 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800594:	83 f9 01             	cmp    $0x1,%ecx
  800597:	7e 18                	jle    8005b1 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	8b 10                	mov    (%eax),%edx
  80059e:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a1:	8d 40 08             	lea    0x8(%eax),%eax
  8005a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ac:	e9 e8 00 00 00       	jmp    800699 <vprintfmt+0x3fa>
	else if (lflag)
  8005b1:	85 c9                	test   %ecx,%ecx
  8005b3:	75 1a                	jne    8005cf <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 10                	mov    (%eax),%edx
  8005ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bf:	8d 40 04             	lea    0x4(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ca:	e9 ca 00 00 00       	jmp    800699 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e4:	e9 b0 00 00 00       	jmp    800699 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005e9:	83 f9 01             	cmp    $0x1,%ecx
  8005ec:	7e 3c                	jle    80062a <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 50 04             	mov    0x4(%eax),%edx
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 40 08             	lea    0x8(%eax),%eax
  800602:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800605:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800609:	79 59                	jns    800664 <vprintfmt+0x3c5>
                putch('-', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 2d                	push   $0x2d
  800611:	ff d6                	call   *%esi
                num = -(long long) num;
  800613:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800616:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800619:	f7 da                	neg    %edx
  80061b:	83 d1 00             	adc    $0x0,%ecx
  80061e:	f7 d9                	neg    %ecx
  800620:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800623:	b8 08 00 00 00       	mov    $0x8,%eax
  800628:	eb 6f                	jmp    800699 <vprintfmt+0x3fa>
	else if (lflag)
  80062a:	85 c9                	test   %ecx,%ecx
  80062c:	75 1b                	jne    800649 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	89 c1                	mov    %eax,%ecx
  800638:	c1 f9 1f             	sar    $0x1f,%ecx
  80063b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb bc                	jmp    800605 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 c1                	mov    %eax,%ecx
  800653:	c1 f9 1f             	sar    $0x1f,%ecx
  800656:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	eb a1                	jmp    800605 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800664:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800667:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
  80066f:	eb 28                	jmp    800699 <vprintfmt+0x3fa>
			putch('0', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	6a 30                	push   $0x30
  800677:	ff d6                	call   *%esi
			putch('x', putdat);
  800679:	83 c4 08             	add    $0x8,%esp
  80067c:	53                   	push   %ebx
  80067d:	6a 78                	push   $0x78
  80067f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 10                	mov    (%eax),%edx
  800686:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80068e:	8d 40 04             	lea    0x4(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800694:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800699:	83 ec 0c             	sub    $0xc,%esp
  80069c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006a0:	57                   	push   %edi
  8006a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a4:	50                   	push   %eax
  8006a5:	51                   	push   %ecx
  8006a6:	52                   	push   %edx
  8006a7:	89 da                	mov    %ebx,%edx
  8006a9:	89 f0                	mov    %esi,%eax
  8006ab:	e8 06 fb ff ff       	call   8001b6 <printnum>
			break;
  8006b0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b6:	83 c7 01             	add    $0x1,%edi
  8006b9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bd:	83 f8 25             	cmp    $0x25,%eax
  8006c0:	0f 84 f0 fb ff ff    	je     8002b6 <vprintfmt+0x17>
			if (ch == '\0')
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	0f 84 8b 00 00 00    	je     800759 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	53                   	push   %ebx
  8006d2:	50                   	push   %eax
  8006d3:	ff d6                	call   *%esi
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	eb dc                	jmp    8006b6 <vprintfmt+0x417>
	if (lflag >= 2)
  8006da:	83 f9 01             	cmp    $0x1,%ecx
  8006dd:	7e 15                	jle    8006f4 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 10                	mov    (%eax),%edx
  8006e4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f2:	eb a5                	jmp    800699 <vprintfmt+0x3fa>
	else if (lflag)
  8006f4:	85 c9                	test   %ecx,%ecx
  8006f6:	75 17                	jne    80070f <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 10                	mov    (%eax),%edx
  8006fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800708:	b8 10 00 00 00       	mov    $0x10,%eax
  80070d:	eb 8a                	jmp    800699 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
  800724:	e9 70 ff ff ff       	jmp    800699 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	6a 25                	push   $0x25
  80072f:	ff d6                	call   *%esi
			break;
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	e9 7a ff ff ff       	jmp    8006b3 <vprintfmt+0x414>
			putch('%', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	6a 25                	push   $0x25
  80073f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	89 f8                	mov    %edi,%eax
  800746:	eb 03                	jmp    80074b <vprintfmt+0x4ac>
  800748:	83 e8 01             	sub    $0x1,%eax
  80074b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074f:	75 f7                	jne    800748 <vprintfmt+0x4a9>
  800751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800754:	e9 5a ff ff ff       	jmp    8006b3 <vprintfmt+0x414>
}
  800759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075c:	5b                   	pop    %ebx
  80075d:	5e                   	pop    %esi
  80075e:	5f                   	pop    %edi
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800770:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800774:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077e:	85 c0                	test   %eax,%eax
  800780:	74 26                	je     8007a8 <vsnprintf+0x47>
  800782:	85 d2                	test   %edx,%edx
  800784:	7e 22                	jle    8007a8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800786:	ff 75 14             	pushl  0x14(%ebp)
  800789:	ff 75 10             	pushl  0x10(%ebp)
  80078c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078f:	50                   	push   %eax
  800790:	68 65 02 80 00       	push   $0x800265
  800795:	e8 05 fb ff ff       	call   80029f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
}
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    
		return -E_INVAL;
  8007a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ad:	eb f7                	jmp    8007a6 <vsnprintf+0x45>

008007af <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b8:	50                   	push   %eax
  8007b9:	ff 75 10             	pushl  0x10(%ebp)
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 9a ff ff ff       	call   800761 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d4:	eb 03                	jmp    8007d9 <strlen+0x10>
		n++;
  8007d6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007d9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007dd:	75 f7                	jne    8007d6 <strlen+0xd>
	return n;
}
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ef:	eb 03                	jmp    8007f4 <strnlen+0x13>
		n++;
  8007f1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f4:	39 d0                	cmp    %edx,%eax
  8007f6:	74 06                	je     8007fe <strnlen+0x1d>
  8007f8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007fc:	75 f3                	jne    8007f1 <strnlen+0x10>
	return n;
}
  8007fe:	5d                   	pop    %ebp
  8007ff:	c3                   	ret    

00800800 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080a:	89 c2                	mov    %eax,%edx
  80080c:	83 c1 01             	add    $0x1,%ecx
  80080f:	83 c2 01             	add    $0x1,%edx
  800812:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800816:	88 5a ff             	mov    %bl,-0x1(%edx)
  800819:	84 db                	test   %bl,%bl
  80081b:	75 ef                	jne    80080c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80081d:	5b                   	pop    %ebx
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800827:	53                   	push   %ebx
  800828:	e8 9c ff ff ff       	call   8007c9 <strlen>
  80082d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	01 d8                	add    %ebx,%eax
  800835:	50                   	push   %eax
  800836:	e8 c5 ff ff ff       	call   800800 <strcpy>
	return dst;
}
  80083b:	89 d8                	mov    %ebx,%eax
  80083d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	56                   	push   %esi
  800846:	53                   	push   %ebx
  800847:	8b 75 08             	mov    0x8(%ebp),%esi
  80084a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084d:	89 f3                	mov    %esi,%ebx
  80084f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800852:	89 f2                	mov    %esi,%edx
  800854:	eb 0f                	jmp    800865 <strncpy+0x23>
		*dst++ = *src;
  800856:	83 c2 01             	add    $0x1,%edx
  800859:	0f b6 01             	movzbl (%ecx),%eax
  80085c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085f:	80 39 01             	cmpb   $0x1,(%ecx)
  800862:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800865:	39 da                	cmp    %ebx,%edx
  800867:	75 ed                	jne    800856 <strncpy+0x14>
	}
	return ret;
}
  800869:	89 f0                	mov    %esi,%eax
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
  800874:	8b 75 08             	mov    0x8(%ebp),%esi
  800877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 0b                	jne    800892 <strlcpy+0x23>
  800887:	eb 17                	jmp    8008a0 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800889:	83 c2 01             	add    $0x1,%edx
  80088c:	83 c0 01             	add    $0x1,%eax
  80088f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800892:	39 d8                	cmp    %ebx,%eax
  800894:	74 07                	je     80089d <strlcpy+0x2e>
  800896:	0f b6 0a             	movzbl (%edx),%ecx
  800899:	84 c9                	test   %cl,%cl
  80089b:	75 ec                	jne    800889 <strlcpy+0x1a>
		*dst = '\0';
  80089d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008a0:	29 f0                	sub    %esi,%eax
}
  8008a2:	5b                   	pop    %ebx
  8008a3:	5e                   	pop    %esi
  8008a4:	5d                   	pop    %ebp
  8008a5:	c3                   	ret    

008008a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008af:	eb 06                	jmp    8008b7 <strcmp+0x11>
		p++, q++;
  8008b1:	83 c1 01             	add    $0x1,%ecx
  8008b4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008b7:	0f b6 01             	movzbl (%ecx),%eax
  8008ba:	84 c0                	test   %al,%al
  8008bc:	74 04                	je     8008c2 <strcmp+0x1c>
  8008be:	3a 02                	cmp    (%edx),%al
  8008c0:	74 ef                	je     8008b1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c2:	0f b6 c0             	movzbl %al,%eax
  8008c5:	0f b6 12             	movzbl (%edx),%edx
  8008c8:	29 d0                	sub    %edx,%eax
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	53                   	push   %ebx
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	89 c3                	mov    %eax,%ebx
  8008d8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008db:	eb 06                	jmp    8008e3 <strncmp+0x17>
		n--, p++, q++;
  8008dd:	83 c0 01             	add    $0x1,%eax
  8008e0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008e3:	39 d8                	cmp    %ebx,%eax
  8008e5:	74 16                	je     8008fd <strncmp+0x31>
  8008e7:	0f b6 08             	movzbl (%eax),%ecx
  8008ea:	84 c9                	test   %cl,%cl
  8008ec:	74 04                	je     8008f2 <strncmp+0x26>
  8008ee:	3a 0a                	cmp    (%edx),%cl
  8008f0:	74 eb                	je     8008dd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f2:	0f b6 00             	movzbl (%eax),%eax
  8008f5:	0f b6 12             	movzbl (%edx),%edx
  8008f8:	29 d0                	sub    %edx,%eax
}
  8008fa:	5b                   	pop    %ebx
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    
		return 0;
  8008fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800902:	eb f6                	jmp    8008fa <strncmp+0x2e>

00800904 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090e:	0f b6 10             	movzbl (%eax),%edx
  800911:	84 d2                	test   %dl,%dl
  800913:	74 09                	je     80091e <strchr+0x1a>
		if (*s == c)
  800915:	38 ca                	cmp    %cl,%dl
  800917:	74 0a                	je     800923 <strchr+0x1f>
	for (; *s; s++)
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	eb f0                	jmp    80090e <strchr+0xa>
			return (char *) s;
	return 0;
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092f:	eb 03                	jmp    800934 <strfind+0xf>
  800931:	83 c0 01             	add    $0x1,%eax
  800934:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800937:	38 ca                	cmp    %cl,%dl
  800939:	74 04                	je     80093f <strfind+0x1a>
  80093b:	84 d2                	test   %dl,%dl
  80093d:	75 f2                	jne    800931 <strfind+0xc>
			break;
	return (char *) s;
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	57                   	push   %edi
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
  800947:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094d:	85 c9                	test   %ecx,%ecx
  80094f:	74 13                	je     800964 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800951:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800957:	75 05                	jne    80095e <memset+0x1d>
  800959:	f6 c1 03             	test   $0x3,%cl
  80095c:	74 0d                	je     80096b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	fc                   	cld    
  800962:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800964:	89 f8                	mov    %edi,%eax
  800966:	5b                   	pop    %ebx
  800967:	5e                   	pop    %esi
  800968:	5f                   	pop    %edi
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    
		c &= 0xFF;
  80096b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80096f:	89 d3                	mov    %edx,%ebx
  800971:	c1 e3 08             	shl    $0x8,%ebx
  800974:	89 d0                	mov    %edx,%eax
  800976:	c1 e0 18             	shl    $0x18,%eax
  800979:	89 d6                	mov    %edx,%esi
  80097b:	c1 e6 10             	shl    $0x10,%esi
  80097e:	09 f0                	or     %esi,%eax
  800980:	09 c2                	or     %eax,%edx
  800982:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800984:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800987:	89 d0                	mov    %edx,%eax
  800989:	fc                   	cld    
  80098a:	f3 ab                	rep stos %eax,%es:(%edi)
  80098c:	eb d6                	jmp    800964 <memset+0x23>

0080098e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	57                   	push   %edi
  800992:	56                   	push   %esi
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 75 0c             	mov    0xc(%ebp),%esi
  800999:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80099c:	39 c6                	cmp    %eax,%esi
  80099e:	73 35                	jae    8009d5 <memmove+0x47>
  8009a0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a3:	39 c2                	cmp    %eax,%edx
  8009a5:	76 2e                	jbe    8009d5 <memmove+0x47>
		s += n;
		d += n;
  8009a7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009aa:	89 d6                	mov    %edx,%esi
  8009ac:	09 fe                	or     %edi,%esi
  8009ae:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b4:	74 0c                	je     8009c2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b6:	83 ef 01             	sub    $0x1,%edi
  8009b9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009bc:	fd                   	std    
  8009bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009bf:	fc                   	cld    
  8009c0:	eb 21                	jmp    8009e3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c2:	f6 c1 03             	test   $0x3,%cl
  8009c5:	75 ef                	jne    8009b6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c7:	83 ef 04             	sub    $0x4,%edi
  8009ca:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009cd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009d0:	fd                   	std    
  8009d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d3:	eb ea                	jmp    8009bf <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d5:	89 f2                	mov    %esi,%edx
  8009d7:	09 c2                	or     %eax,%edx
  8009d9:	f6 c2 03             	test   $0x3,%dl
  8009dc:	74 09                	je     8009e7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009de:	89 c7                	mov    %eax,%edi
  8009e0:	fc                   	cld    
  8009e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e3:	5e                   	pop    %esi
  8009e4:	5f                   	pop    %edi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e7:	f6 c1 03             	test   $0x3,%cl
  8009ea:	75 f2                	jne    8009de <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ef:	89 c7                	mov    %eax,%edi
  8009f1:	fc                   	cld    
  8009f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f4:	eb ed                	jmp    8009e3 <memmove+0x55>

008009f6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009f9:	ff 75 10             	pushl  0x10(%ebp)
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	ff 75 08             	pushl  0x8(%ebp)
  800a02:	e8 87 ff ff ff       	call   80098e <memmove>
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	56                   	push   %esi
  800a0d:	53                   	push   %ebx
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a14:	89 c6                	mov    %eax,%esi
  800a16:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a19:	39 f0                	cmp    %esi,%eax
  800a1b:	74 1c                	je     800a39 <memcmp+0x30>
		if (*s1 != *s2)
  800a1d:	0f b6 08             	movzbl (%eax),%ecx
  800a20:	0f b6 1a             	movzbl (%edx),%ebx
  800a23:	38 d9                	cmp    %bl,%cl
  800a25:	75 08                	jne    800a2f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a27:	83 c0 01             	add    $0x1,%eax
  800a2a:	83 c2 01             	add    $0x1,%edx
  800a2d:	eb ea                	jmp    800a19 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a2f:	0f b6 c1             	movzbl %cl,%eax
  800a32:	0f b6 db             	movzbl %bl,%ebx
  800a35:	29 d8                	sub    %ebx,%eax
  800a37:	eb 05                	jmp    800a3e <memcmp+0x35>
	}

	return 0;
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3e:	5b                   	pop    %ebx
  800a3f:	5e                   	pop    %esi
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a4b:	89 c2                	mov    %eax,%edx
  800a4d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a50:	39 d0                	cmp    %edx,%eax
  800a52:	73 09                	jae    800a5d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a54:	38 08                	cmp    %cl,(%eax)
  800a56:	74 05                	je     800a5d <memfind+0x1b>
	for (; s < ends; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f3                	jmp    800a50 <memfind+0xe>
			break;
	return (void *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	57                   	push   %edi
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6b:	eb 03                	jmp    800a70 <strtol+0x11>
		s++;
  800a6d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a70:	0f b6 01             	movzbl (%ecx),%eax
  800a73:	3c 20                	cmp    $0x20,%al
  800a75:	74 f6                	je     800a6d <strtol+0xe>
  800a77:	3c 09                	cmp    $0x9,%al
  800a79:	74 f2                	je     800a6d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a7b:	3c 2b                	cmp    $0x2b,%al
  800a7d:	74 2e                	je     800aad <strtol+0x4e>
	int neg = 0;
  800a7f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a84:	3c 2d                	cmp    $0x2d,%al
  800a86:	74 2f                	je     800ab7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a88:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8e:	75 05                	jne    800a95 <strtol+0x36>
  800a90:	80 39 30             	cmpb   $0x30,(%ecx)
  800a93:	74 2c                	je     800ac1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a95:	85 db                	test   %ebx,%ebx
  800a97:	75 0a                	jne    800aa3 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a99:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a9e:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa1:	74 28                	je     800acb <strtol+0x6c>
		base = 10;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aab:	eb 50                	jmp    800afd <strtol+0x9e>
		s++;
  800aad:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab5:	eb d1                	jmp    800a88 <strtol+0x29>
		s++, neg = 1;
  800ab7:	83 c1 01             	add    $0x1,%ecx
  800aba:	bf 01 00 00 00       	mov    $0x1,%edi
  800abf:	eb c7                	jmp    800a88 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac5:	74 0e                	je     800ad5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac7:	85 db                	test   %ebx,%ebx
  800ac9:	75 d8                	jne    800aa3 <strtol+0x44>
		s++, base = 8;
  800acb:	83 c1 01             	add    $0x1,%ecx
  800ace:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad3:	eb ce                	jmp    800aa3 <strtol+0x44>
		s += 2, base = 16;
  800ad5:	83 c1 02             	add    $0x2,%ecx
  800ad8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800add:	eb c4                	jmp    800aa3 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800adf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae2:	89 f3                	mov    %esi,%ebx
  800ae4:	80 fb 19             	cmp    $0x19,%bl
  800ae7:	77 29                	ja     800b12 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ae9:	0f be d2             	movsbl %dl,%edx
  800aec:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aef:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af2:	7d 30                	jge    800b24 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af4:	83 c1 01             	add    $0x1,%ecx
  800af7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800afb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800afd:	0f b6 11             	movzbl (%ecx),%edx
  800b00:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b03:	89 f3                	mov    %esi,%ebx
  800b05:	80 fb 09             	cmp    $0x9,%bl
  800b08:	77 d5                	ja     800adf <strtol+0x80>
			dig = *s - '0';
  800b0a:	0f be d2             	movsbl %dl,%edx
  800b0d:	83 ea 30             	sub    $0x30,%edx
  800b10:	eb dd                	jmp    800aef <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b15:	89 f3                	mov    %esi,%ebx
  800b17:	80 fb 19             	cmp    $0x19,%bl
  800b1a:	77 08                	ja     800b24 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b1c:	0f be d2             	movsbl %dl,%edx
  800b1f:	83 ea 37             	sub    $0x37,%edx
  800b22:	eb cb                	jmp    800aef <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b28:	74 05                	je     800b2f <strtol+0xd0>
		*endptr = (char *) s;
  800b2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	f7 da                	neg    %edx
  800b33:	85 ff                	test   %edi,%edi
  800b35:	0f 45 c2             	cmovne %edx,%eax
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4e:	89 c3                	mov    %eax,%ebx
  800b50:	89 c7                	mov    %eax,%edi
  800b52:	89 c6                	mov    %eax,%esi
  800b54:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <sys_cgetc>:

int
sys_cgetc(void) {
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b61:	ba 00 00 00 00       	mov    $0x0,%edx
  800b66:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6b:	89 d1                	mov    %edx,%ecx
  800b6d:	89 d3                	mov    %edx,%ebx
  800b6f:	89 d7                	mov    %edx,%edi
  800b71:	89 d6                	mov    %edx,%esi
  800b73:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5f                   	pop    %edi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b88:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b90:	89 cb                	mov    %ecx,%ebx
  800b92:	89 cf                	mov    %ecx,%edi
  800b94:	89 ce                	mov    %ecx,%esi
  800b96:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b98:	85 c0                	test   %eax,%eax
  800b9a:	7f 08                	jg     800ba4 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ba4:	83 ec 0c             	sub    $0xc,%esp
  800ba7:	50                   	push   %eax
  800ba8:	6a 03                	push   $0x3
  800baa:	68 24 16 80 00       	push   $0x801624
  800baf:	6a 24                	push   $0x24
  800bb1:	68 41 16 80 00       	push   $0x801641
  800bb6:	e8 7b 04 00 00       	call   801036 <_panic>

00800bbb <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc6:	b8 02 00 00 00       	mov    $0x2,%eax
  800bcb:	89 d1                	mov    %edx,%ecx
  800bcd:	89 d3                	mov    %edx,%ebx
  800bcf:	89 d7                	mov    %edx,%edi
  800bd1:	89 d6                	mov    %edx,%esi
  800bd3:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5f                   	pop    %edi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <sys_yield>:

void
sys_yield(void)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	57                   	push   %edi
  800bde:	56                   	push   %esi
  800bdf:	53                   	push   %ebx
    asm volatile("int %1\n"
  800be0:	ba 00 00 00 00       	mov    $0x0,%edx
  800be5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bea:	89 d1                	mov    %edx,%ecx
  800bec:	89 d3                	mov    %edx,%ebx
  800bee:	89 d7                	mov    %edx,%edi
  800bf0:	89 d6                	mov    %edx,%esi
  800bf2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c02:	be 00 00 00 00       	mov    $0x0,%esi
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	b8 04 00 00 00       	mov    $0x4,%eax
  800c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c15:	89 f7                	mov    %esi,%edi
  800c17:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c19:	85 c0                	test   %eax,%eax
  800c1b:	7f 08                	jg     800c25 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	50                   	push   %eax
  800c29:	6a 04                	push   $0x4
  800c2b:	68 24 16 80 00       	push   $0x801624
  800c30:	6a 24                	push   $0x24
  800c32:	68 41 16 80 00       	push   $0x801641
  800c37:	e8 fa 03 00 00       	call   801036 <_panic>

00800c3c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
  800c42:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c45:	8b 55 08             	mov    0x8(%ebp),%edx
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c53:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c56:	8b 75 18             	mov    0x18(%ebp),%esi
  800c59:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c5b:	85 c0                	test   %eax,%eax
  800c5d:	7f 08                	jg     800c67 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	83 ec 0c             	sub    $0xc,%esp
  800c6a:	50                   	push   %eax
  800c6b:	6a 05                	push   $0x5
  800c6d:	68 24 16 80 00       	push   $0x801624
  800c72:	6a 24                	push   $0x24
  800c74:	68 41 16 80 00       	push   $0x801641
  800c79:	e8 b8 03 00 00       	call   801036 <_panic>

00800c7e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	b8 06 00 00 00       	mov    $0x6,%eax
  800c97:	89 df                	mov    %ebx,%edi
  800c99:	89 de                	mov    %ebx,%esi
  800c9b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	7f 08                	jg     800ca9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	50                   	push   %eax
  800cad:	6a 06                	push   $0x6
  800caf:	68 24 16 80 00       	push   $0x801624
  800cb4:	6a 24                	push   $0x24
  800cb6:	68 41 16 80 00       	push   $0x801641
  800cbb:	e8 76 03 00 00       	call   801036 <_panic>

00800cc0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd9:	89 df                	mov    %ebx,%edi
  800cdb:	89 de                	mov    %ebx,%esi
  800cdd:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 08                	push   $0x8
  800cf1:	68 24 16 80 00       	push   $0x801624
  800cf6:	6a 24                	push   $0x24
  800cf8:	68 41 16 80 00       	push   $0x801641
  800cfd:	e8 34 03 00 00       	call   801036 <_panic>

00800d02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	b8 09 00 00 00       	mov    $0x9,%eax
  800d1b:	89 df                	mov    %ebx,%edi
  800d1d:	89 de                	mov    %ebx,%esi
  800d1f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7f 08                	jg     800d2d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	50                   	push   %eax
  800d31:	6a 09                	push   $0x9
  800d33:	68 24 16 80 00       	push   $0x801624
  800d38:	6a 24                	push   $0x24
  800d3a:	68 41 16 80 00       	push   $0x801641
  800d3f:	e8 f2 02 00 00       	call   801036 <_panic>

00800d44 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d55:	be 00 00 00 00       	mov    $0x0,%esi
  800d5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d60:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d7d:	89 cb                	mov    %ecx,%ebx
  800d7f:	89 cf                	mov    %ecx,%edi
  800d81:	89 ce                	mov    %ecx,%esi
  800d83:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d85:	85 c0                	test   %eax,%eax
  800d87:	7f 08                	jg     800d91 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8c:	5b                   	pop    %ebx
  800d8d:	5e                   	pop    %esi
  800d8e:	5f                   	pop    %edi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d91:	83 ec 0c             	sub    $0xc,%esp
  800d94:	50                   	push   %eax
  800d95:	6a 0c                	push   $0xc
  800d97:	68 24 16 80 00       	push   $0x801624
  800d9c:	6a 24                	push   $0x24
  800d9e:	68 41 16 80 00       	push   $0x801641
  800da3:	e8 8e 02 00 00       	call   801036 <_panic>

00800da8 <pgfault>:
//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf) {
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	53                   	push   %ebx
  800dac:	83 ec 04             	sub    $0x4,%esp
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800db2:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800db4:	8b 40 04             	mov    0x4(%eax),%eax
    int r;

    extern volatile pte_t uvpt[];
    if (err != FEC_WR || ((uvpt[(uintptr_t) addr / PGSIZE] & PTE_COW) != PTE_COW)) {
  800db7:	83 f8 02             	cmp    $0x2,%eax
  800dba:	75 11                	jne    800dcd <pgfault+0x25>
  800dbc:	89 da                	mov    %ebx,%edx
  800dbe:	c1 ea 0c             	shr    $0xc,%edx
  800dc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dc8:	f6 c6 08             	test   $0x8,%dh
  800dcb:	75 23                	jne    800df0 <pgfault+0x48>
        cprintf("utf->utf_fault_va:0x%x\tutf->utf_err:%d\n", addr, err);
  800dcd:	83 ec 04             	sub    $0x4,%esp
  800dd0:	50                   	push   %eax
  800dd1:	53                   	push   %ebx
  800dd2:	68 50 16 80 00       	push   $0x801650
  800dd7:	e8 c6 f3 ff ff       	call   8001a2 <cprintf>
        panic("pgfault is not a FEC_WR or is not to a COW page");
  800ddc:	83 c4 0c             	add    $0xc,%esp
  800ddf:	68 78 16 80 00       	push   $0x801678
  800de4:	6a 17                	push   $0x17
  800de6:	68 cc 16 80 00       	push   $0x8016cc
  800deb:	e8 46 02 00 00       	call   801036 <_panic>
    //   Use the read-only page table mappings at uvpt
    //   (see <inc/memlayout.h>).

    // LAB 4: Your code here.

    sys_page_alloc(0, (void *) PFTEMP, PTE_W | PTE_U | PTE_P);
  800df0:	83 ec 04             	sub    $0x4,%esp
  800df3:	6a 07                	push   $0x7
  800df5:	68 00 f0 7f 00       	push   $0x7ff000
  800dfa:	6a 00                	push   $0x0
  800dfc:	e8 f8 fd ff ff       	call   800bf9 <sys_page_alloc>
    memmove((void *) PFTEMP, (void *) (ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  800e01:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800e07:	83 c4 0c             	add    $0xc,%esp
  800e0a:	68 00 10 00 00       	push   $0x1000
  800e0f:	53                   	push   %ebx
  800e10:	68 00 f0 7f 00       	push   $0x7ff000
  800e15:	e8 74 fb ff ff       	call   80098e <memmove>

    //restore another
    sys_page_map(0, (void *) (ROUNDDOWN(addr, PGSIZE)), 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800e1a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e21:	53                   	push   %ebx
  800e22:	6a 00                	push   $0x0
  800e24:	53                   	push   %ebx
  800e25:	6a 00                	push   $0x0
  800e27:	e8 10 fe ff ff       	call   800c3c <sys_page_map>

    sys_page_map(0, (void *) PFTEMP, 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800e2c:	83 c4 14             	add    $0x14,%esp
  800e2f:	6a 07                	push   $0x7
  800e31:	53                   	push   %ebx
  800e32:	6a 00                	push   $0x0
  800e34:	68 00 f0 7f 00       	push   $0x7ff000
  800e39:	6a 00                	push   $0x0
  800e3b:	e8 fc fd ff ff       	call   800c3c <sys_page_map>
    sys_page_unmap(0, (void *) PFTEMP);
  800e40:	83 c4 18             	add    $0x18,%esp
  800e43:	68 00 f0 7f 00       	push   $0x7ff000
  800e48:	6a 00                	push   $0x0
  800e4a:	e8 2f fe ff ff       	call   800c7e <sys_page_unmap>
    // Hint:
    //   You should make three system calls.

    // LAB 4: Your code here.

    panic("pgfault not implemented");
  800e4f:	83 c4 0c             	add    $0xc,%esp
  800e52:	68 d7 16 80 00       	push   $0x8016d7
  800e57:	6a 31                	push   $0x31
  800e59:	68 cc 16 80 00       	push   $0x8016cc
  800e5e:	e8 d3 01 00 00       	call   801036 <_panic>

00800e63 <fork>:
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void) {
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 28             	sub    $0x28,%esp
    //1. The parent installs pgfault() as the C-level page fault handler, using the set_pgfault_handler() function you implemented above.
    set_pgfault_handler(pgfault);
  800e6c:	68 a8 0d 80 00       	push   $0x800da8
  800e71:	e8 06 02 00 00       	call   80107c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e76:	b8 07 00 00 00       	mov    $0x7,%eax
  800e7b:	cd 30                	int    $0x30
  800e7d:	89 c7                	mov    %eax,%edi
  800e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    //2. The parent calls sys_exofork() to create a child environment.
    envid_t envid = sys_exofork();

    if (envid == 0) {
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	85 c0                	test   %eax,%eax
  800e87:	74 1c                	je     800ea5 <fork+0x42>
    //   LAB 4: Your code here.

    int i;
    extern volatile pde_t uvpd[];
    extern volatile pte_t uvpt[];
    cprintf("COW page resolve ....\n");
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	68 ef 16 80 00       	push   $0x8016ef
  800e91:	e8 0c f3 ff ff       	call   8001a2 <cprintf>
  800e96:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < UTOP / PGSIZE; i++) {
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	be 00 00 00 00       	mov    $0x0,%esi
  800ea3:	eb 2e                	jmp    800ed3 <fork+0x70>
        thisenv = &envs[sys_getenvid()];
  800ea5:	e8 11 fd ff ff       	call   800bbb <sys_getenvid>
  800eaa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ead:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800eb2:	a3 04 20 80 00       	mov    %eax,0x802004
        return 0;
  800eb7:	e9 56 01 00 00       	jmp    801012 <fork+0x1af>
//        cprintf("0x%x\n", i);

//        cprintf("enter %d\n", i);
        if (uvpd[i / NPTENTRIES] == 0) {
//            cprintf("blank uvpd: 0x%x\n", i);
            i += 1023;
  800ebc:	81 c3 ff 03 00 00    	add    $0x3ff,%ebx
    for (i = 0; i < UTOP / PGSIZE; i++) {
  800ec2:	83 c3 01             	add    $0x1,%ebx
  800ec5:	89 de                	mov    %ebx,%esi
  800ec7:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  800ecd:	0f 87 c7 00 00 00    	ja     800f9a <fork+0x137>
        if (uvpd[i / NPTENTRIES] == 0) {
  800ed3:	8d 83 ff 03 00 00    	lea    0x3ff(%ebx),%eax
  800ed9:	85 db                	test   %ebx,%ebx
  800edb:	0f 49 c3             	cmovns %ebx,%eax
  800ede:	c1 f8 0a             	sar    $0xa,%eax
  800ee1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	74 d0                	je     800ebc <fork+0x59>
            continue;
        }

        if ((uvpt[i] & PTE_P) == PTE_P) {
  800eec:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800ef3:	a8 01                	test   $0x1,%al
  800ef5:	74 cb                	je     800ec2 <fork+0x5f>
//            if (i % NPTENTRIES == 0) {
//                cprintf("present uvpd: 0x%x\n", i);
//            }

            if (((uvpt[i] & PTE_W) == PTE_W) || ((uvpt[i] & PTE_COW) == PTE_COW)) {
  800ef7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800efe:	a8 02                	test   $0x2,%al
  800f00:	75 0c                	jne    800f0e <fork+0xab>
  800f02:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f09:	f6 c4 08             	test   $0x8,%ah
  800f0c:	74 65                	je     800f73 <fork+0x110>
    if (sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800f0e:	c1 e6 0c             	shl    $0xc,%esi
  800f11:	83 ec 0c             	sub    $0xc,%esp
  800f14:	68 05 08 00 00       	push   $0x805
  800f19:	56                   	push   %esi
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	56                   	push   %esi
  800f1e:	6a 00                	push   $0x0
  800f20:	e8 17 fd ff ff       	call   800c3c <sys_page_map>
  800f25:	83 c4 20             	add    $0x20,%esp
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	78 33                	js     800f5f <fork+0xfc>
    if (sys_page_map(envid, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	68 05 08 00 00       	push   $0x805
  800f34:	56                   	push   %esi
  800f35:	6a 00                	push   $0x0
  800f37:	56                   	push   %esi
  800f38:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3b:	e8 fc fc ff ff       	call   800c3c <sys_page_map>
  800f40:	83 c4 20             	add    $0x20,%esp
  800f43:	85 c0                	test   %eax,%eax
  800f45:	0f 89 77 ff ff ff    	jns    800ec2 <fork+0x5f>
        panic("dupppage target map error");
  800f4b:	83 ec 04             	sub    $0x4,%esp
  800f4e:	68 21 17 80 00       	push   $0x801721
  800f53:	6a 4b                	push   $0x4b
  800f55:	68 cc 16 80 00       	push   $0x8016cc
  800f5a:	e8 d7 00 00 00       	call   801036 <_panic>
        panic("dupppage our own map error");
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	68 06 17 80 00       	push   $0x801706
  800f67:	6a 45                	push   $0x45
  800f69:	68 cc 16 80 00       	push   $0x8016cc
  800f6e:	e8 c3 00 00 00       	call   801036 <_panic>
                duppage(envid, i);
            } else {
                //lead to kernel panic because uvpt can't write....
                sys_page_map(0, (void *) (i * PGSIZE), envid, (void *) (i * PGSIZE), PTE_SHARE | uvpt[i]);
  800f73:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f7a:	89 da                	mov    %ebx,%edx
  800f7c:	c1 e2 0c             	shl    $0xc,%edx
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	80 cc 04             	or     $0x4,%ah
  800f85:	50                   	push   %eax
  800f86:	52                   	push   %edx
  800f87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f8a:	52                   	push   %edx
  800f8b:	6a 00                	push   $0x0
  800f8d:	e8 aa fc ff ff       	call   800c3c <sys_page_map>
  800f92:	83 c4 20             	add    $0x20,%esp
  800f95:	e9 28 ff ff ff       	jmp    800ec2 <fork+0x5f>
//                pages[PGNUM(uvpt[i])].pp_ref += 1;
            }
        }
    }

    cprintf("allocate child ExceptionStack ....\n");
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	68 a8 16 80 00       	push   $0x8016a8
  800fa2:	e8 fb f1 ff ff       	call   8001a2 <cprintf>
    sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  800fa7:	83 c4 0c             	add    $0xc,%esp
  800faa:	6a 07                	push   $0x7
  800fac:	68 00 f0 bf ee       	push   $0xeebff000
  800fb1:	57                   	push   %edi
  800fb2:	e8 42 fc ff ff       	call   800bf9 <sys_page_alloc>
    sys_page_map(envid, (void *) (UXSTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  800fb7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fbe:	68 00 00 40 00       	push   $0x400000
  800fc3:	6a 00                	push   $0x0
  800fc5:	68 00 f0 bf ee       	push   $0xeebff000
  800fca:	57                   	push   %edi
  800fcb:	e8 6c fc ff ff       	call   800c3c <sys_page_map>
    memmove(UTEMP, (void *) (UXSTACKTOP - PGSIZE), PGSIZE);
  800fd0:	83 c4 1c             	add    $0x1c,%esp
  800fd3:	68 00 10 00 00       	push   $0x1000
  800fd8:	68 00 f0 bf ee       	push   $0xeebff000
  800fdd:	68 00 00 40 00       	push   $0x400000
  800fe2:	e8 a7 f9 ff ff       	call   80098e <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  800fe7:	83 c4 08             	add    $0x8,%esp
  800fea:	68 00 00 40 00       	push   $0x400000
  800fef:	6a 00                	push   $0x0
  800ff1:	e8 88 fc ff ff       	call   800c7e <sys_page_unmap>

    //4. The parent sets the user page fault entrypoint for the child to look like its own.
//    set_pgfault_handler(pgfault);
    sys_env_set_pgfault_upcall(envid, pgfault);
  800ff6:	83 c4 08             	add    $0x8,%esp
  800ff9:	68 a8 0d 80 00       	push   $0x800da8
  800ffe:	57                   	push   %edi
  800fff:	e8 fe fc ff ff       	call   800d02 <sys_env_set_pgfault_upcall>

    //5. The child is now ready to run, so the parent marks it runnable.
    sys_env_set_status(envid, ENV_RUNNABLE);
  801004:	83 c4 08             	add    $0x8,%esp
  801007:	6a 02                	push   $0x2
  801009:	57                   	push   %edi
  80100a:	e8 b1 fc ff ff       	call   800cc0 <sys_env_set_status>

    return envid;
  80100f:	83 c4 10             	add    $0x10,%esp
    panic("fork not implemented");
}
  801012:	89 f8                	mov    %edi,%eax
  801014:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sfork>:

// Challenge!
int
sfork(void) {
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 0c             	sub    $0xc,%esp
    panic("sfork not implemented");
  801022:	68 3b 17 80 00       	push   $0x80173b
  801027:	68 b2 00 00 00       	push   $0xb2
  80102c:	68 cc 16 80 00       	push   $0x8016cc
  801031:	e8 00 00 00 00       	call   801036 <_panic>

00801036 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	56                   	push   %esi
  80103a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80103b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80103e:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801044:	e8 72 fb ff ff       	call   800bbb <sys_getenvid>
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	ff 75 0c             	pushl  0xc(%ebp)
  80104f:	ff 75 08             	pushl  0x8(%ebp)
  801052:	56                   	push   %esi
  801053:	50                   	push   %eax
  801054:	68 54 17 80 00       	push   $0x801754
  801059:	e8 44 f1 ff ff       	call   8001a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80105e:	83 c4 18             	add    $0x18,%esp
  801061:	53                   	push   %ebx
  801062:	ff 75 10             	pushl  0x10(%ebp)
  801065:	e8 e7 f0 ff ff       	call   800151 <vcprintf>
	cprintf("\n");
  80106a:	c7 04 24 04 17 80 00 	movl   $0x801704,(%esp)
  801071:	e8 2c f1 ff ff       	call   8001a2 <cprintf>
  801076:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801079:	cc                   	int3   
  80107a:	eb fd                	jmp    801079 <_panic+0x43>

0080107c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801082:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801089:	74 0a                	je     801095 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  801095:	a1 04 20 80 00       	mov    0x802004,%eax
  80109a:	8b 40 48             	mov    0x48(%eax),%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	6a 07                	push   $0x7
  8010a2:	68 00 f0 bf ee       	push   $0xeebff000
  8010a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010ac:	50                   	push   %eax
  8010ad:	e8 47 fb ff ff       	call   800bf9 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  8010b2:	a1 04 20 80 00       	mov    0x802004,%eax
  8010b7:	8b 40 48             	mov    0x48(%eax),%eax
  8010ba:	83 c4 08             	add    $0x8,%esp
  8010bd:	68 d2 10 80 00       	push   $0x8010d2
  8010c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010c7:	50                   	push   %eax
  8010c8:	e8 35 fc ff ff       	call   800d02 <sys_env_set_pgfault_upcall>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	eb b9                	jmp    80108b <set_pgfault_handler+0xf>

008010d2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010d2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010d3:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8010d8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010da:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  8010dd:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  8010e1:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  8010e5:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  8010e8:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  8010ea:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  8010ee:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  8010f1:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  8010f2:	83 c4 04             	add    $0x4,%esp
    popfl
  8010f5:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  8010f6:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8010f7:	c3                   	ret    
  8010f8:	66 90                	xchg   %ax,%ax
  8010fa:	66 90                	xchg   %ax,%ax
  8010fc:	66 90                	xchg   %ax,%ax
  8010fe:	66 90                	xchg   %ax,%ax

00801100 <__udivdi3>:
  801100:	55                   	push   %ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 1c             	sub    $0x1c,%esp
  801107:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80110b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80110f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801113:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801117:	85 d2                	test   %edx,%edx
  801119:	75 35                	jne    801150 <__udivdi3+0x50>
  80111b:	39 f3                	cmp    %esi,%ebx
  80111d:	0f 87 bd 00 00 00    	ja     8011e0 <__udivdi3+0xe0>
  801123:	85 db                	test   %ebx,%ebx
  801125:	89 d9                	mov    %ebx,%ecx
  801127:	75 0b                	jne    801134 <__udivdi3+0x34>
  801129:	b8 01 00 00 00       	mov    $0x1,%eax
  80112e:	31 d2                	xor    %edx,%edx
  801130:	f7 f3                	div    %ebx
  801132:	89 c1                	mov    %eax,%ecx
  801134:	31 d2                	xor    %edx,%edx
  801136:	89 f0                	mov    %esi,%eax
  801138:	f7 f1                	div    %ecx
  80113a:	89 c6                	mov    %eax,%esi
  80113c:	89 e8                	mov    %ebp,%eax
  80113e:	89 f7                	mov    %esi,%edi
  801140:	f7 f1                	div    %ecx
  801142:	89 fa                	mov    %edi,%edx
  801144:	83 c4 1c             	add    $0x1c,%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    
  80114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801150:	39 f2                	cmp    %esi,%edx
  801152:	77 7c                	ja     8011d0 <__udivdi3+0xd0>
  801154:	0f bd fa             	bsr    %edx,%edi
  801157:	83 f7 1f             	xor    $0x1f,%edi
  80115a:	0f 84 98 00 00 00    	je     8011f8 <__udivdi3+0xf8>
  801160:	89 f9                	mov    %edi,%ecx
  801162:	b8 20 00 00 00       	mov    $0x20,%eax
  801167:	29 f8                	sub    %edi,%eax
  801169:	d3 e2                	shl    %cl,%edx
  80116b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80116f:	89 c1                	mov    %eax,%ecx
  801171:	89 da                	mov    %ebx,%edx
  801173:	d3 ea                	shr    %cl,%edx
  801175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801179:	09 d1                	or     %edx,%ecx
  80117b:	89 f2                	mov    %esi,%edx
  80117d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801181:	89 f9                	mov    %edi,%ecx
  801183:	d3 e3                	shl    %cl,%ebx
  801185:	89 c1                	mov    %eax,%ecx
  801187:	d3 ea                	shr    %cl,%edx
  801189:	89 f9                	mov    %edi,%ecx
  80118b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80118f:	d3 e6                	shl    %cl,%esi
  801191:	89 eb                	mov    %ebp,%ebx
  801193:	89 c1                	mov    %eax,%ecx
  801195:	d3 eb                	shr    %cl,%ebx
  801197:	09 de                	or     %ebx,%esi
  801199:	89 f0                	mov    %esi,%eax
  80119b:	f7 74 24 08          	divl   0x8(%esp)
  80119f:	89 d6                	mov    %edx,%esi
  8011a1:	89 c3                	mov    %eax,%ebx
  8011a3:	f7 64 24 0c          	mull   0xc(%esp)
  8011a7:	39 d6                	cmp    %edx,%esi
  8011a9:	72 0c                	jb     8011b7 <__udivdi3+0xb7>
  8011ab:	89 f9                	mov    %edi,%ecx
  8011ad:	d3 e5                	shl    %cl,%ebp
  8011af:	39 c5                	cmp    %eax,%ebp
  8011b1:	73 5d                	jae    801210 <__udivdi3+0x110>
  8011b3:	39 d6                	cmp    %edx,%esi
  8011b5:	75 59                	jne    801210 <__udivdi3+0x110>
  8011b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8011ba:	31 ff                	xor    %edi,%edi
  8011bc:	89 fa                	mov    %edi,%edx
  8011be:	83 c4 1c             	add    $0x1c,%esp
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
  8011c6:	8d 76 00             	lea    0x0(%esi),%esi
  8011c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8011d0:	31 ff                	xor    %edi,%edi
  8011d2:	31 c0                	xor    %eax,%eax
  8011d4:	89 fa                	mov    %edi,%edx
  8011d6:	83 c4 1c             	add    $0x1c,%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    
  8011de:	66 90                	xchg   %ax,%ax
  8011e0:	31 ff                	xor    %edi,%edi
  8011e2:	89 e8                	mov    %ebp,%eax
  8011e4:	89 f2                	mov    %esi,%edx
  8011e6:	f7 f3                	div    %ebx
  8011e8:	89 fa                	mov    %edi,%edx
  8011ea:	83 c4 1c             	add    $0x1c,%esp
  8011ed:	5b                   	pop    %ebx
  8011ee:	5e                   	pop    %esi
  8011ef:	5f                   	pop    %edi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    
  8011f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011f8:	39 f2                	cmp    %esi,%edx
  8011fa:	72 06                	jb     801202 <__udivdi3+0x102>
  8011fc:	31 c0                	xor    %eax,%eax
  8011fe:	39 eb                	cmp    %ebp,%ebx
  801200:	77 d2                	ja     8011d4 <__udivdi3+0xd4>
  801202:	b8 01 00 00 00       	mov    $0x1,%eax
  801207:	eb cb                	jmp    8011d4 <__udivdi3+0xd4>
  801209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801210:	89 d8                	mov    %ebx,%eax
  801212:	31 ff                	xor    %edi,%edi
  801214:	eb be                	jmp    8011d4 <__udivdi3+0xd4>
  801216:	66 90                	xchg   %ax,%ax
  801218:	66 90                	xchg   %ax,%ax
  80121a:	66 90                	xchg   %ax,%ax
  80121c:	66 90                	xchg   %ax,%ax
  80121e:	66 90                	xchg   %ax,%ax

00801220 <__umoddi3>:
  801220:	55                   	push   %ebp
  801221:	57                   	push   %edi
  801222:	56                   	push   %esi
  801223:	53                   	push   %ebx
  801224:	83 ec 1c             	sub    $0x1c,%esp
  801227:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80122b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80122f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801233:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801237:	85 ed                	test   %ebp,%ebp
  801239:	89 f0                	mov    %esi,%eax
  80123b:	89 da                	mov    %ebx,%edx
  80123d:	75 19                	jne    801258 <__umoddi3+0x38>
  80123f:	39 df                	cmp    %ebx,%edi
  801241:	0f 86 b1 00 00 00    	jbe    8012f8 <__umoddi3+0xd8>
  801247:	f7 f7                	div    %edi
  801249:	89 d0                	mov    %edx,%eax
  80124b:	31 d2                	xor    %edx,%edx
  80124d:	83 c4 1c             	add    $0x1c,%esp
  801250:	5b                   	pop    %ebx
  801251:	5e                   	pop    %esi
  801252:	5f                   	pop    %edi
  801253:	5d                   	pop    %ebp
  801254:	c3                   	ret    
  801255:	8d 76 00             	lea    0x0(%esi),%esi
  801258:	39 dd                	cmp    %ebx,%ebp
  80125a:	77 f1                	ja     80124d <__umoddi3+0x2d>
  80125c:	0f bd cd             	bsr    %ebp,%ecx
  80125f:	83 f1 1f             	xor    $0x1f,%ecx
  801262:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801266:	0f 84 b4 00 00 00    	je     801320 <__umoddi3+0x100>
  80126c:	b8 20 00 00 00       	mov    $0x20,%eax
  801271:	89 c2                	mov    %eax,%edx
  801273:	8b 44 24 04          	mov    0x4(%esp),%eax
  801277:	29 c2                	sub    %eax,%edx
  801279:	89 c1                	mov    %eax,%ecx
  80127b:	89 f8                	mov    %edi,%eax
  80127d:	d3 e5                	shl    %cl,%ebp
  80127f:	89 d1                	mov    %edx,%ecx
  801281:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801285:	d3 e8                	shr    %cl,%eax
  801287:	09 c5                	or     %eax,%ebp
  801289:	8b 44 24 04          	mov    0x4(%esp),%eax
  80128d:	89 c1                	mov    %eax,%ecx
  80128f:	d3 e7                	shl    %cl,%edi
  801291:	89 d1                	mov    %edx,%ecx
  801293:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801297:	89 df                	mov    %ebx,%edi
  801299:	d3 ef                	shr    %cl,%edi
  80129b:	89 c1                	mov    %eax,%ecx
  80129d:	89 f0                	mov    %esi,%eax
  80129f:	d3 e3                	shl    %cl,%ebx
  8012a1:	89 d1                	mov    %edx,%ecx
  8012a3:	89 fa                	mov    %edi,%edx
  8012a5:	d3 e8                	shr    %cl,%eax
  8012a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8012ac:	09 d8                	or     %ebx,%eax
  8012ae:	f7 f5                	div    %ebp
  8012b0:	d3 e6                	shl    %cl,%esi
  8012b2:	89 d1                	mov    %edx,%ecx
  8012b4:	f7 64 24 08          	mull   0x8(%esp)
  8012b8:	39 d1                	cmp    %edx,%ecx
  8012ba:	89 c3                	mov    %eax,%ebx
  8012bc:	89 d7                	mov    %edx,%edi
  8012be:	72 06                	jb     8012c6 <__umoddi3+0xa6>
  8012c0:	75 0e                	jne    8012d0 <__umoddi3+0xb0>
  8012c2:	39 c6                	cmp    %eax,%esi
  8012c4:	73 0a                	jae    8012d0 <__umoddi3+0xb0>
  8012c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8012ca:	19 ea                	sbb    %ebp,%edx
  8012cc:	89 d7                	mov    %edx,%edi
  8012ce:	89 c3                	mov    %eax,%ebx
  8012d0:	89 ca                	mov    %ecx,%edx
  8012d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8012d7:	29 de                	sub    %ebx,%esi
  8012d9:	19 fa                	sbb    %edi,%edx
  8012db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8012df:	89 d0                	mov    %edx,%eax
  8012e1:	d3 e0                	shl    %cl,%eax
  8012e3:	89 d9                	mov    %ebx,%ecx
  8012e5:	d3 ee                	shr    %cl,%esi
  8012e7:	d3 ea                	shr    %cl,%edx
  8012e9:	09 f0                	or     %esi,%eax
  8012eb:	83 c4 1c             	add    $0x1c,%esp
  8012ee:	5b                   	pop    %ebx
  8012ef:	5e                   	pop    %esi
  8012f0:	5f                   	pop    %edi
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    
  8012f3:	90                   	nop
  8012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012f8:	85 ff                	test   %edi,%edi
  8012fa:	89 f9                	mov    %edi,%ecx
  8012fc:	75 0b                	jne    801309 <__umoddi3+0xe9>
  8012fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801303:	31 d2                	xor    %edx,%edx
  801305:	f7 f7                	div    %edi
  801307:	89 c1                	mov    %eax,%ecx
  801309:	89 d8                	mov    %ebx,%eax
  80130b:	31 d2                	xor    %edx,%edx
  80130d:	f7 f1                	div    %ecx
  80130f:	89 f0                	mov    %esi,%eax
  801311:	f7 f1                	div    %ecx
  801313:	e9 31 ff ff ff       	jmp    801249 <__umoddi3+0x29>
  801318:	90                   	nop
  801319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801320:	39 dd                	cmp    %ebx,%ebp
  801322:	72 08                	jb     80132c <__umoddi3+0x10c>
  801324:	39 f7                	cmp    %esi,%edi
  801326:	0f 87 21 ff ff ff    	ja     80124d <__umoddi3+0x2d>
  80132c:	89 da                	mov    %ebx,%edx
  80132e:	89 f0                	mov    %esi,%eax
  801330:	29 f8                	sub    %edi,%eax
  801332:	19 ea                	sbb    %ebp,%edx
  801334:	e9 14 ff ff ff       	jmp    80124d <__umoddi3+0x2d>
