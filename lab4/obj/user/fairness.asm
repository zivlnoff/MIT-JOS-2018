
obj/user/fairness：     文件格式 elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 67 0b 00 00       	call   800ba7 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 20 80 00 7c 	cmpl   $0xeec0007c,0x802004
  800049:	00 c0 ee 
  80004c:	75 26                	jne    800074 <umain+0x41>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 00                	push   $0x0
  800056:	6a 00                	push   $0x0
  800058:	56                   	push   %esi
  800059:	e8 36 0d 00 00       	call   800d94 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80005e:	83 c4 0c             	add    $0xc,%esp
  800061:	ff 75 f4             	pushl  -0xc(%ebp)
  800064:	53                   	push   %ebx
  800065:	68 a0 10 80 00       	push   $0x8010a0
  80006a:	e8 1f 01 00 00       	call   80018e <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	eb dd                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800074:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 b1 10 80 00       	push   $0x8010b1
  800083:	e8 06 01 00 00       	call   80018e <cprintf>
  800088:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80008b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	6a 00                	push   $0x0
  800096:	50                   	push   %eax
  800097:	e8 0f 0d 00 00       	call   800dab <ipc_send>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb ea                	jmp    80008b <umain+0x58>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 f6 0a 00 00       	call   800ba7 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x2d>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	e8 5b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 0a 00 00 00       	call   8000e7 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	e8 72 0a 00 00       	call   800b66 <sys_env_destroy>
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	c9                   	leave  
  8000f8:	c3                   	ret    

008000f9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f9:	55                   	push   %ebp
  8000fa:	89 e5                	mov    %esp,%ebp
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 04             	sub    $0x4,%esp
  800100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800103:	8b 13                	mov    (%ebx),%edx
  800105:	8d 42 01             	lea    0x1(%edx),%eax
  800108:	89 03                	mov    %eax,(%ebx)
  80010a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800111:	3d ff 00 00 00       	cmp    $0xff,%eax
  800116:	74 09                	je     800121 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800118:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011f:	c9                   	leave  
  800120:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	68 ff 00 00 00       	push   $0xff
  800129:	8d 43 08             	lea    0x8(%ebx),%eax
  80012c:	50                   	push   %eax
  80012d:	e8 f7 09 00 00       	call   800b29 <sys_cputs>
		b->idx = 0;
  800132:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	eb db                	jmp    800118 <putch+0x1f>

0080013d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800146:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014d:	00 00 00 
	b.cnt = 0;
  800150:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800157:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015a:	ff 75 0c             	pushl  0xc(%ebp)
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	50                   	push   %eax
  800167:	68 f9 00 80 00       	push   $0x8000f9
  80016c:	e8 1a 01 00 00       	call   80028b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800180:	50                   	push   %eax
  800181:	e8 a3 09 00 00       	call   800b29 <sys_cputs>

	return b.cnt;
}
  800186:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800194:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800197:	50                   	push   %eax
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	e8 9d ff ff ff       	call   80013d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	57                   	push   %edi
  8001a6:	56                   	push   %esi
  8001a7:	53                   	push   %ebx
  8001a8:	83 ec 1c             	sub    $0x1c,%esp
  8001ab:	89 c7                	mov    %eax,%edi
  8001ad:	89 d6                	mov    %edx,%esi
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001c6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001c9:	39 d3                	cmp    %edx,%ebx
  8001cb:	72 05                	jb     8001d2 <printnum+0x30>
  8001cd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d0:	77 7a                	ja     80024c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	ff 75 18             	pushl  0x18(%ebp)
  8001d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8001db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001de:	53                   	push   %ebx
  8001df:	ff 75 10             	pushl  0x10(%ebp)
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f1:	e8 5a 0c 00 00       	call   800e50 <__udivdi3>
  8001f6:	83 c4 18             	add    $0x18,%esp
  8001f9:	52                   	push   %edx
  8001fa:	50                   	push   %eax
  8001fb:	89 f2                	mov    %esi,%edx
  8001fd:	89 f8                	mov    %edi,%eax
  8001ff:	e8 9e ff ff ff       	call   8001a2 <printnum>
  800204:	83 c4 20             	add    $0x20,%esp
  800207:	eb 13                	jmp    80021c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	56                   	push   %esi
  80020d:	ff 75 18             	pushl  0x18(%ebp)
  800210:	ff d7                	call   *%edi
  800212:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800215:	83 eb 01             	sub    $0x1,%ebx
  800218:	85 db                	test   %ebx,%ebx
  80021a:	7f ed                	jg     800209 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	56                   	push   %esi
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	ff 75 e4             	pushl  -0x1c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	ff 75 d8             	pushl  -0x28(%ebp)
  80022f:	e8 3c 0d 00 00       	call   800f70 <__umoddi3>
  800234:	83 c4 14             	add    $0x14,%esp
  800237:	0f be 80 d2 10 80 00 	movsbl 0x8010d2(%eax),%eax
  80023e:	50                   	push   %eax
  80023f:	ff d7                	call   *%edi
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
  80024c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80024f:	eb c4                	jmp    800215 <printnum+0x73>

00800251 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800257:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025b:	8b 10                	mov    (%eax),%edx
  80025d:	3b 50 04             	cmp    0x4(%eax),%edx
  800260:	73 0a                	jae    80026c <sprintputch+0x1b>
		*b->buf++ = ch;
  800262:	8d 4a 01             	lea    0x1(%edx),%ecx
  800265:	89 08                	mov    %ecx,(%eax)
  800267:	8b 45 08             	mov    0x8(%ebp),%eax
  80026a:	88 02                	mov    %al,(%edx)
}
  80026c:	5d                   	pop    %ebp
  80026d:	c3                   	ret    

0080026e <printfmt>:
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800274:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800277:	50                   	push   %eax
  800278:	ff 75 10             	pushl  0x10(%ebp)
  80027b:	ff 75 0c             	pushl  0xc(%ebp)
  80027e:	ff 75 08             	pushl  0x8(%ebp)
  800281:	e8 05 00 00 00       	call   80028b <vprintfmt>
}
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

0080028b <vprintfmt>:
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	57                   	push   %edi
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
  800291:	83 ec 2c             	sub    $0x2c,%esp
  800294:	8b 75 08             	mov    0x8(%ebp),%esi
  800297:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029d:	e9 00 04 00 00       	jmp    8006a2 <vprintfmt+0x417>
		padc = ' ';
  8002a2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002a6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002ad:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c0:	8d 47 01             	lea    0x1(%edi),%eax
  8002c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c6:	0f b6 17             	movzbl (%edi),%edx
  8002c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cc:	3c 55                	cmp    $0x55,%al
  8002ce:	0f 87 51 04 00 00    	ja     800725 <vprintfmt+0x49a>
  8002d4:	0f b6 c0             	movzbl %al,%eax
  8002d7:	ff 24 85 a0 11 80 00 	jmp    *0x8011a0(,%eax,4)
  8002de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e1:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e5:	eb d9                	jmp    8002c0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ea:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ee:	eb d0                	jmp    8002c0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f0:	0f b6 d2             	movzbl %dl,%edx
  8002f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800301:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800305:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800308:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030b:	83 f9 09             	cmp    $0x9,%ecx
  80030e:	77 55                	ja     800365 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800310:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800313:	eb e9                	jmp    8002fe <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800315:	8b 45 14             	mov    0x14(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8d 40 04             	lea    0x4(%eax),%eax
  800323:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800329:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032d:	79 91                	jns    8002c0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80032f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800332:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800335:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80033c:	eb 82                	jmp    8002c0 <vprintfmt+0x35>
  80033e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	ba 00 00 00 00       	mov    $0x0,%edx
  800348:	0f 49 d0             	cmovns %eax,%edx
  80034b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800351:	e9 6a ff ff ff       	jmp    8002c0 <vprintfmt+0x35>
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800359:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800360:	e9 5b ff ff ff       	jmp    8002c0 <vprintfmt+0x35>
  800365:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800368:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036b:	eb bc                	jmp    800329 <vprintfmt+0x9e>
			lflag++;
  80036d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800373:	e9 48 ff ff ff       	jmp    8002c0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8d 78 04             	lea    0x4(%eax),%edi
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	53                   	push   %ebx
  800382:	ff 30                	pushl  (%eax)
  800384:	ff d6                	call   *%esi
			break;
  800386:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800389:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80038c:	e9 0e 03 00 00       	jmp    80069f <vprintfmt+0x414>
			err = va_arg(ap, int);
  800391:	8b 45 14             	mov    0x14(%ebp),%eax
  800394:	8d 78 04             	lea    0x4(%eax),%edi
  800397:	8b 00                	mov    (%eax),%eax
  800399:	99                   	cltd   
  80039a:	31 d0                	xor    %edx,%eax
  80039c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039e:	83 f8 08             	cmp    $0x8,%eax
  8003a1:	7f 23                	jg     8003c6 <vprintfmt+0x13b>
  8003a3:	8b 14 85 00 13 80 00 	mov    0x801300(,%eax,4),%edx
  8003aa:	85 d2                	test   %edx,%edx
  8003ac:	74 18                	je     8003c6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003ae:	52                   	push   %edx
  8003af:	68 f3 10 80 00       	push   $0x8010f3
  8003b4:	53                   	push   %ebx
  8003b5:	56                   	push   %esi
  8003b6:	e8 b3 fe ff ff       	call   80026e <printfmt>
  8003bb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003be:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c1:	e9 d9 02 00 00       	jmp    80069f <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003c6:	50                   	push   %eax
  8003c7:	68 ea 10 80 00       	push   $0x8010ea
  8003cc:	53                   	push   %ebx
  8003cd:	56                   	push   %esi
  8003ce:	e8 9b fe ff ff       	call   80026e <printfmt>
  8003d3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d9:	e9 c1 02 00 00       	jmp    80069f <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	83 c0 04             	add    $0x4,%eax
  8003e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ec:	85 ff                	test   %edi,%edi
  8003ee:	b8 e3 10 80 00       	mov    $0x8010e3,%eax
  8003f3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fa:	0f 8e bd 00 00 00    	jle    8004bd <vprintfmt+0x232>
  800400:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800404:	75 0e                	jne    800414 <vprintfmt+0x189>
  800406:	89 75 08             	mov    %esi,0x8(%ebp)
  800409:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80040c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80040f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800412:	eb 6d                	jmp    800481 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	ff 75 d0             	pushl  -0x30(%ebp)
  80041a:	57                   	push   %edi
  80041b:	e8 ad 03 00 00       	call   8007cd <strnlen>
  800420:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800423:	29 c1                	sub    %eax,%ecx
  800425:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800428:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80042b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80042f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800432:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800435:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800437:	eb 0f                	jmp    800448 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	53                   	push   %ebx
  80043d:	ff 75 e0             	pushl  -0x20(%ebp)
  800440:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800442:	83 ef 01             	sub    $0x1,%edi
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	85 ff                	test   %edi,%edi
  80044a:	7f ed                	jg     800439 <vprintfmt+0x1ae>
  80044c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80044f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800452:	85 c9                	test   %ecx,%ecx
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
  800459:	0f 49 c1             	cmovns %ecx,%eax
  80045c:	29 c1                	sub    %eax,%ecx
  80045e:	89 75 08             	mov    %esi,0x8(%ebp)
  800461:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800464:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800467:	89 cb                	mov    %ecx,%ebx
  800469:	eb 16                	jmp    800481 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80046b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80046f:	75 31                	jne    8004a2 <vprintfmt+0x217>
					putch(ch, putdat);
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	50                   	push   %eax
  800478:	ff 55 08             	call   *0x8(%ebp)
  80047b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047e:	83 eb 01             	sub    $0x1,%ebx
  800481:	83 c7 01             	add    $0x1,%edi
  800484:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800488:	0f be c2             	movsbl %dl,%eax
  80048b:	85 c0                	test   %eax,%eax
  80048d:	74 59                	je     8004e8 <vprintfmt+0x25d>
  80048f:	85 f6                	test   %esi,%esi
  800491:	78 d8                	js     80046b <vprintfmt+0x1e0>
  800493:	83 ee 01             	sub    $0x1,%esi
  800496:	79 d3                	jns    80046b <vprintfmt+0x1e0>
  800498:	89 df                	mov    %ebx,%edi
  80049a:	8b 75 08             	mov    0x8(%ebp),%esi
  80049d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a0:	eb 37                	jmp    8004d9 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a2:	0f be d2             	movsbl %dl,%edx
  8004a5:	83 ea 20             	sub    $0x20,%edx
  8004a8:	83 fa 5e             	cmp    $0x5e,%edx
  8004ab:	76 c4                	jbe    800471 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	ff 75 0c             	pushl  0xc(%ebp)
  8004b3:	6a 3f                	push   $0x3f
  8004b5:	ff 55 08             	call   *0x8(%ebp)
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	eb c1                	jmp    80047e <vprintfmt+0x1f3>
  8004bd:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004c9:	eb b6                	jmp    800481 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	53                   	push   %ebx
  8004cf:	6a 20                	push   $0x20
  8004d1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d3:	83 ef 01             	sub    $0x1,%edi
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	85 ff                	test   %edi,%edi
  8004db:	7f ee                	jg     8004cb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e3:	e9 b7 01 00 00       	jmp    80069f <vprintfmt+0x414>
  8004e8:	89 df                	mov    %ebx,%edi
  8004ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f0:	eb e7                	jmp    8004d9 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004f2:	83 f9 01             	cmp    $0x1,%ecx
  8004f5:	7e 3f                	jle    800536 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 50 04             	mov    0x4(%eax),%edx
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 08             	lea    0x8(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800512:	79 5c                	jns    800570 <vprintfmt+0x2e5>
				putch('-', putdat);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	53                   	push   %ebx
  800518:	6a 2d                	push   $0x2d
  80051a:	ff d6                	call   *%esi
				num = -(long long) num;
  80051c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80051f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800522:	f7 da                	neg    %edx
  800524:	83 d1 00             	adc    $0x0,%ecx
  800527:	f7 d9                	neg    %ecx
  800529:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800531:	e9 4f 01 00 00       	jmp    800685 <vprintfmt+0x3fa>
	else if (lflag)
  800536:	85 c9                	test   %ecx,%ecx
  800538:	75 1b                	jne    800555 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800542:	89 c1                	mov    %eax,%ecx
  800544:	c1 f9 1f             	sar    $0x1f,%ecx
  800547:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8d 40 04             	lea    0x4(%eax),%eax
  800550:	89 45 14             	mov    %eax,0x14(%ebp)
  800553:	eb b9                	jmp    80050e <vprintfmt+0x283>
		return va_arg(*ap, long);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	89 c1                	mov    %eax,%ecx
  80055f:	c1 f9 1f             	sar    $0x1f,%ecx
  800562:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8d 40 04             	lea    0x4(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
  80056e:	eb 9e                	jmp    80050e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800570:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800573:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 05 01 00 00       	jmp    800685 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800580:	83 f9 01             	cmp    $0x1,%ecx
  800583:	7e 18                	jle    80059d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 10                	mov    (%eax),%edx
  80058a:	8b 48 04             	mov    0x4(%eax),%ecx
  80058d:	8d 40 08             	lea    0x8(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800593:	b8 0a 00 00 00       	mov    $0xa,%eax
  800598:	e9 e8 00 00 00       	jmp    800685 <vprintfmt+0x3fa>
	else if (lflag)
  80059d:	85 c9                	test   %ecx,%ecx
  80059f:	75 1a                	jne    8005bb <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 10                	mov    (%eax),%edx
  8005a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b6:	e9 ca 00 00 00       	jmp    800685 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 10                	mov    (%eax),%edx
  8005c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d0:	e9 b0 00 00 00       	jmp    800685 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005d5:	83 f9 01             	cmp    $0x1,%ecx
  8005d8:	7e 3c                	jle    800616 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8b 50 04             	mov    0x4(%eax),%edx
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8d 40 08             	lea    0x8(%eax),%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f5:	79 59                	jns    800650 <vprintfmt+0x3c5>
                putch('-', putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	6a 2d                	push   $0x2d
  8005fd:	ff d6                	call   *%esi
                num = -(long long) num;
  8005ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800602:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800605:	f7 da                	neg    %edx
  800607:	83 d1 00             	adc    $0x0,%ecx
  80060a:	f7 d9                	neg    %ecx
  80060c:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80060f:	b8 08 00 00 00       	mov    $0x8,%eax
  800614:	eb 6f                	jmp    800685 <vprintfmt+0x3fa>
	else if (lflag)
  800616:	85 c9                	test   %ecx,%ecx
  800618:	75 1b                	jne    800635 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 c1                	mov    %eax,%ecx
  800624:	c1 f9 1f             	sar    $0x1f,%ecx
  800627:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 40 04             	lea    0x4(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
  800633:	eb bc                	jmp    8005f1 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063d:	89 c1                	mov    %eax,%ecx
  80063f:	c1 f9 1f             	sar    $0x1f,%ecx
  800642:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb a1                	jmp    8005f1 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800650:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800653:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800656:	b8 08 00 00 00       	mov    $0x8,%eax
  80065b:	eb 28                	jmp    800685 <vprintfmt+0x3fa>
			putch('0', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 30                	push   $0x30
  800663:	ff d6                	call   *%esi
			putch('x', putdat);
  800665:	83 c4 08             	add    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	6a 78                	push   $0x78
  80066b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 10                	mov    (%eax),%edx
  800672:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800677:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80067a:	8d 40 04             	lea    0x4(%eax),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800680:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80068c:	57                   	push   %edi
  80068d:	ff 75 e0             	pushl  -0x20(%ebp)
  800690:	50                   	push   %eax
  800691:	51                   	push   %ecx
  800692:	52                   	push   %edx
  800693:	89 da                	mov    %ebx,%edx
  800695:	89 f0                	mov    %esi,%eax
  800697:	e8 06 fb ff ff       	call   8001a2 <printnum>
			break;
  80069c:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80069f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a2:	83 c7 01             	add    $0x1,%edi
  8006a5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a9:	83 f8 25             	cmp    $0x25,%eax
  8006ac:	0f 84 f0 fb ff ff    	je     8002a2 <vprintfmt+0x17>
			if (ch == '\0')
  8006b2:	85 c0                	test   %eax,%eax
  8006b4:	0f 84 8b 00 00 00    	je     800745 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	53                   	push   %ebx
  8006be:	50                   	push   %eax
  8006bf:	ff d6                	call   *%esi
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	eb dc                	jmp    8006a2 <vprintfmt+0x417>
	if (lflag >= 2)
  8006c6:	83 f9 01             	cmp    $0x1,%ecx
  8006c9:	7e 15                	jle    8006e0 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 10                	mov    (%eax),%edx
  8006d0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d3:	8d 40 08             	lea    0x8(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006de:	eb a5                	jmp    800685 <vprintfmt+0x3fa>
	else if (lflag)
  8006e0:	85 c9                	test   %ecx,%ecx
  8006e2:	75 17                	jne    8006fb <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f9:	eb 8a                	jmp    800685 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 10                	mov    (%eax),%edx
  800700:	b9 00 00 00 00       	mov    $0x0,%ecx
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070b:	b8 10 00 00 00       	mov    $0x10,%eax
  800710:	e9 70 ff ff ff       	jmp    800685 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 25                	push   $0x25
  80071b:	ff d6                	call   *%esi
			break;
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	e9 7a ff ff ff       	jmp    80069f <vprintfmt+0x414>
			putch('%', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	6a 25                	push   $0x25
  80072b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	89 f8                	mov    %edi,%eax
  800732:	eb 03                	jmp    800737 <vprintfmt+0x4ac>
  800734:	83 e8 01             	sub    $0x1,%eax
  800737:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80073b:	75 f7                	jne    800734 <vprintfmt+0x4a9>
  80073d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800740:	e9 5a ff ff ff       	jmp    80069f <vprintfmt+0x414>
}
  800745:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800748:	5b                   	pop    %ebx
  800749:	5e                   	pop    %esi
  80074a:	5f                   	pop    %edi
  80074b:	5d                   	pop    %ebp
  80074c:	c3                   	ret    

0080074d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800759:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800760:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800763:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076a:	85 c0                	test   %eax,%eax
  80076c:	74 26                	je     800794 <vsnprintf+0x47>
  80076e:	85 d2                	test   %edx,%edx
  800770:	7e 22                	jle    800794 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800772:	ff 75 14             	pushl  0x14(%ebp)
  800775:	ff 75 10             	pushl  0x10(%ebp)
  800778:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077b:	50                   	push   %eax
  80077c:	68 51 02 80 00       	push   $0x800251
  800781:	e8 05 fb ff ff       	call   80028b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078f:	83 c4 10             	add    $0x10,%esp
}
  800792:	c9                   	leave  
  800793:	c3                   	ret    
		return -E_INVAL;
  800794:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800799:	eb f7                	jmp    800792 <vsnprintf+0x45>

0080079b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a4:	50                   	push   %eax
  8007a5:	ff 75 10             	pushl  0x10(%ebp)
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 9a ff ff ff       	call   80074d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c0:	eb 03                	jmp    8007c5 <strlen+0x10>
		n++;
  8007c2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007c5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c9:	75 f7                	jne    8007c2 <strlen+0xd>
	return n;
}
  8007cb:	5d                   	pop    %ebp
  8007cc:	c3                   	ret    

008007cd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	eb 03                	jmp    8007e0 <strnlen+0x13>
		n++;
  8007dd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e0:	39 d0                	cmp    %edx,%eax
  8007e2:	74 06                	je     8007ea <strnlen+0x1d>
  8007e4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007e8:	75 f3                	jne    8007dd <strnlen+0x10>
	return n;
}
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	53                   	push   %ebx
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	83 c1 01             	add    $0x1,%ecx
  8007fb:	83 c2 01             	add    $0x1,%edx
  8007fe:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800802:	88 5a ff             	mov    %bl,-0x1(%edx)
  800805:	84 db                	test   %bl,%bl
  800807:	75 ef                	jne    8007f8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800809:	5b                   	pop    %ebx
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	53                   	push   %ebx
  800810:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800813:	53                   	push   %ebx
  800814:	e8 9c ff ff ff       	call   8007b5 <strlen>
  800819:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	01 d8                	add    %ebx,%eax
  800821:	50                   	push   %eax
  800822:	e8 c5 ff ff ff       	call   8007ec <strcpy>
	return dst;
}
  800827:	89 d8                	mov    %ebx,%eax
  800829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	56                   	push   %esi
  800832:	53                   	push   %ebx
  800833:	8b 75 08             	mov    0x8(%ebp),%esi
  800836:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800839:	89 f3                	mov    %esi,%ebx
  80083b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80083e:	89 f2                	mov    %esi,%edx
  800840:	eb 0f                	jmp    800851 <strncpy+0x23>
		*dst++ = *src;
  800842:	83 c2 01             	add    $0x1,%edx
  800845:	0f b6 01             	movzbl (%ecx),%eax
  800848:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084b:	80 39 01             	cmpb   $0x1,(%ecx)
  80084e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800851:	39 da                	cmp    %ebx,%edx
  800853:	75 ed                	jne    800842 <strncpy+0x14>
	}
	return ret;
}
  800855:	89 f0                	mov    %esi,%eax
  800857:	5b                   	pop    %ebx
  800858:	5e                   	pop    %esi
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	56                   	push   %esi
  80085f:	53                   	push   %ebx
  800860:	8b 75 08             	mov    0x8(%ebp),%esi
  800863:	8b 55 0c             	mov    0xc(%ebp),%edx
  800866:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800869:	89 f0                	mov    %esi,%eax
  80086b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80086f:	85 c9                	test   %ecx,%ecx
  800871:	75 0b                	jne    80087e <strlcpy+0x23>
  800873:	eb 17                	jmp    80088c <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800875:	83 c2 01             	add    $0x1,%edx
  800878:	83 c0 01             	add    $0x1,%eax
  80087b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80087e:	39 d8                	cmp    %ebx,%eax
  800880:	74 07                	je     800889 <strlcpy+0x2e>
  800882:	0f b6 0a             	movzbl (%edx),%ecx
  800885:	84 c9                	test   %cl,%cl
  800887:	75 ec                	jne    800875 <strlcpy+0x1a>
		*dst = '\0';
  800889:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80088c:	29 f0                	sub    %esi,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5e                   	pop    %esi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800898:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089b:	eb 06                	jmp    8008a3 <strcmp+0x11>
		p++, q++;
  80089d:	83 c1 01             	add    $0x1,%ecx
  8008a0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008a3:	0f b6 01             	movzbl (%ecx),%eax
  8008a6:	84 c0                	test   %al,%al
  8008a8:	74 04                	je     8008ae <strcmp+0x1c>
  8008aa:	3a 02                	cmp    (%edx),%al
  8008ac:	74 ef                	je     80089d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ae:	0f b6 c0             	movzbl %al,%eax
  8008b1:	0f b6 12             	movzbl (%edx),%edx
  8008b4:	29 d0                	sub    %edx,%eax
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c2:	89 c3                	mov    %eax,%ebx
  8008c4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c7:	eb 06                	jmp    8008cf <strncmp+0x17>
		n--, p++, q++;
  8008c9:	83 c0 01             	add    $0x1,%eax
  8008cc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008cf:	39 d8                	cmp    %ebx,%eax
  8008d1:	74 16                	je     8008e9 <strncmp+0x31>
  8008d3:	0f b6 08             	movzbl (%eax),%ecx
  8008d6:	84 c9                	test   %cl,%cl
  8008d8:	74 04                	je     8008de <strncmp+0x26>
  8008da:	3a 0a                	cmp    (%edx),%cl
  8008dc:	74 eb                	je     8008c9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008de:	0f b6 00             	movzbl (%eax),%eax
  8008e1:	0f b6 12             	movzbl (%edx),%edx
  8008e4:	29 d0                	sub    %edx,%eax
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    
		return 0;
  8008e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ee:	eb f6                	jmp    8008e6 <strncmp+0x2e>

008008f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fa:	0f b6 10             	movzbl (%eax),%edx
  8008fd:	84 d2                	test   %dl,%dl
  8008ff:	74 09                	je     80090a <strchr+0x1a>
		if (*s == c)
  800901:	38 ca                	cmp    %cl,%dl
  800903:	74 0a                	je     80090f <strchr+0x1f>
	for (; *s; s++)
  800905:	83 c0 01             	add    $0x1,%eax
  800908:	eb f0                	jmp    8008fa <strchr+0xa>
			return (char *) s;
	return 0;
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091b:	eb 03                	jmp    800920 <strfind+0xf>
  80091d:	83 c0 01             	add    $0x1,%eax
  800920:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800923:	38 ca                	cmp    %cl,%dl
  800925:	74 04                	je     80092b <strfind+0x1a>
  800927:	84 d2                	test   %dl,%dl
  800929:	75 f2                	jne    80091d <strfind+0xc>
			break;
	return (char *) s;
}
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	57                   	push   %edi
  800931:	56                   	push   %esi
  800932:	53                   	push   %ebx
  800933:	8b 7d 08             	mov    0x8(%ebp),%edi
  800936:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800939:	85 c9                	test   %ecx,%ecx
  80093b:	74 13                	je     800950 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80093d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800943:	75 05                	jne    80094a <memset+0x1d>
  800945:	f6 c1 03             	test   $0x3,%cl
  800948:	74 0d                	je     800957 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094d:	fc                   	cld    
  80094e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800950:	89 f8                	mov    %edi,%eax
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5f                   	pop    %edi
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    
		c &= 0xFF;
  800957:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095b:	89 d3                	mov    %edx,%ebx
  80095d:	c1 e3 08             	shl    $0x8,%ebx
  800960:	89 d0                	mov    %edx,%eax
  800962:	c1 e0 18             	shl    $0x18,%eax
  800965:	89 d6                	mov    %edx,%esi
  800967:	c1 e6 10             	shl    $0x10,%esi
  80096a:	09 f0                	or     %esi,%eax
  80096c:	09 c2                	or     %eax,%edx
  80096e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800970:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800973:	89 d0                	mov    %edx,%eax
  800975:	fc                   	cld    
  800976:	f3 ab                	rep stos %eax,%es:(%edi)
  800978:	eb d6                	jmp    800950 <memset+0x23>

0080097a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	57                   	push   %edi
  80097e:	56                   	push   %esi
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 75 0c             	mov    0xc(%ebp),%esi
  800985:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800988:	39 c6                	cmp    %eax,%esi
  80098a:	73 35                	jae    8009c1 <memmove+0x47>
  80098c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	76 2e                	jbe    8009c1 <memmove+0x47>
		s += n;
		d += n;
  800993:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800996:	89 d6                	mov    %edx,%esi
  800998:	09 fe                	or     %edi,%esi
  80099a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a0:	74 0c                	je     8009ae <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a2:	83 ef 01             	sub    $0x1,%edi
  8009a5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009a8:	fd                   	std    
  8009a9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ab:	fc                   	cld    
  8009ac:	eb 21                	jmp    8009cf <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ae:	f6 c1 03             	test   $0x3,%cl
  8009b1:	75 ef                	jne    8009a2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b3:	83 ef 04             	sub    $0x4,%edi
  8009b6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009bc:	fd                   	std    
  8009bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bf:	eb ea                	jmp    8009ab <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c1:	89 f2                	mov    %esi,%edx
  8009c3:	09 c2                	or     %eax,%edx
  8009c5:	f6 c2 03             	test   $0x3,%dl
  8009c8:	74 09                	je     8009d3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ca:	89 c7                	mov    %eax,%edi
  8009cc:	fc                   	cld    
  8009cd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009cf:	5e                   	pop    %esi
  8009d0:	5f                   	pop    %edi
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d3:	f6 c1 03             	test   $0x3,%cl
  8009d6:	75 f2                	jne    8009ca <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009db:	89 c7                	mov    %eax,%edi
  8009dd:	fc                   	cld    
  8009de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e0:	eb ed                	jmp    8009cf <memmove+0x55>

008009e2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e5:	ff 75 10             	pushl  0x10(%ebp)
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 87 ff ff ff       	call   80097a <memmove>
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	56                   	push   %esi
  8009f9:	53                   	push   %ebx
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a00:	89 c6                	mov    %eax,%esi
  800a02:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a05:	39 f0                	cmp    %esi,%eax
  800a07:	74 1c                	je     800a25 <memcmp+0x30>
		if (*s1 != *s2)
  800a09:	0f b6 08             	movzbl (%eax),%ecx
  800a0c:	0f b6 1a             	movzbl (%edx),%ebx
  800a0f:	38 d9                	cmp    %bl,%cl
  800a11:	75 08                	jne    800a1b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a13:	83 c0 01             	add    $0x1,%eax
  800a16:	83 c2 01             	add    $0x1,%edx
  800a19:	eb ea                	jmp    800a05 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a1b:	0f b6 c1             	movzbl %cl,%eax
  800a1e:	0f b6 db             	movzbl %bl,%ebx
  800a21:	29 d8                	sub    %ebx,%eax
  800a23:	eb 05                	jmp    800a2a <memcmp+0x35>
	}

	return 0;
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2a:	5b                   	pop    %ebx
  800a2b:	5e                   	pop    %esi
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a37:	89 c2                	mov    %eax,%edx
  800a39:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a3c:	39 d0                	cmp    %edx,%eax
  800a3e:	73 09                	jae    800a49 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a40:	38 08                	cmp    %cl,(%eax)
  800a42:	74 05                	je     800a49 <memfind+0x1b>
	for (; s < ends; s++)
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	eb f3                	jmp    800a3c <memfind+0xe>
			break;
	return (void *) s;
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	57                   	push   %edi
  800a4f:	56                   	push   %esi
  800a50:	53                   	push   %ebx
  800a51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a54:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a57:	eb 03                	jmp    800a5c <strtol+0x11>
		s++;
  800a59:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a5c:	0f b6 01             	movzbl (%ecx),%eax
  800a5f:	3c 20                	cmp    $0x20,%al
  800a61:	74 f6                	je     800a59 <strtol+0xe>
  800a63:	3c 09                	cmp    $0x9,%al
  800a65:	74 f2                	je     800a59 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a67:	3c 2b                	cmp    $0x2b,%al
  800a69:	74 2e                	je     800a99 <strtol+0x4e>
	int neg = 0;
  800a6b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a70:	3c 2d                	cmp    $0x2d,%al
  800a72:	74 2f                	je     800aa3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a74:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7a:	75 05                	jne    800a81 <strtol+0x36>
  800a7c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a7f:	74 2c                	je     800aad <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a81:	85 db                	test   %ebx,%ebx
  800a83:	75 0a                	jne    800a8f <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a85:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a8a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a8d:	74 28                	je     800ab7 <strtol+0x6c>
		base = 10;
  800a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a94:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a97:	eb 50                	jmp    800ae9 <strtol+0x9e>
		s++;
  800a99:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa1:	eb d1                	jmp    800a74 <strtol+0x29>
		s++, neg = 1;
  800aa3:	83 c1 01             	add    $0x1,%ecx
  800aa6:	bf 01 00 00 00       	mov    $0x1,%edi
  800aab:	eb c7                	jmp    800a74 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aad:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab1:	74 0e                	je     800ac1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab3:	85 db                	test   %ebx,%ebx
  800ab5:	75 d8                	jne    800a8f <strtol+0x44>
		s++, base = 8;
  800ab7:	83 c1 01             	add    $0x1,%ecx
  800aba:	bb 08 00 00 00       	mov    $0x8,%ebx
  800abf:	eb ce                	jmp    800a8f <strtol+0x44>
		s += 2, base = 16;
  800ac1:	83 c1 02             	add    $0x2,%ecx
  800ac4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ac9:	eb c4                	jmp    800a8f <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800acb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ace:	89 f3                	mov    %esi,%ebx
  800ad0:	80 fb 19             	cmp    $0x19,%bl
  800ad3:	77 29                	ja     800afe <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad5:	0f be d2             	movsbl %dl,%edx
  800ad8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800adb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ade:	7d 30                	jge    800b10 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae0:	83 c1 01             	add    $0x1,%ecx
  800ae3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ae7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ae9:	0f b6 11             	movzbl (%ecx),%edx
  800aec:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aef:	89 f3                	mov    %esi,%ebx
  800af1:	80 fb 09             	cmp    $0x9,%bl
  800af4:	77 d5                	ja     800acb <strtol+0x80>
			dig = *s - '0';
  800af6:	0f be d2             	movsbl %dl,%edx
  800af9:	83 ea 30             	sub    $0x30,%edx
  800afc:	eb dd                	jmp    800adb <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800afe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b01:	89 f3                	mov    %esi,%ebx
  800b03:	80 fb 19             	cmp    $0x19,%bl
  800b06:	77 08                	ja     800b10 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b08:	0f be d2             	movsbl %dl,%edx
  800b0b:	83 ea 37             	sub    $0x37,%edx
  800b0e:	eb cb                	jmp    800adb <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b14:	74 05                	je     800b1b <strtol+0xd0>
		*endptr = (char *) s;
  800b16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b19:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b1b:	89 c2                	mov    %eax,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	85 ff                	test   %edi,%edi
  800b21:	0f 45 c2             	cmovne %edx,%eax
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5f                   	pop    %edi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3a:	89 c3                	mov    %eax,%ebx
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	89 c6                	mov    %eax,%esi
  800b40:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5f                   	pop    %edi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <sys_cgetc>:

int
sys_cgetc(void) {
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	b8 01 00 00 00       	mov    $0x1,%eax
  800b57:	89 d1                	mov    %edx,%ecx
  800b59:	89 d3                	mov    %edx,%ebx
  800b5b:	89 d7                	mov    %edx,%edi
  800b5d:	89 d6                	mov    %edx,%esi
  800b5f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7c:	89 cb                	mov    %ecx,%ebx
  800b7e:	89 cf                	mov    %ecx,%edi
  800b80:	89 ce                	mov    %ecx,%esi
  800b82:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b84:	85 c0                	test   %eax,%eax
  800b86:	7f 08                	jg     800b90 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	50                   	push   %eax
  800b94:	6a 03                	push   $0x3
  800b96:	68 24 13 80 00       	push   $0x801324
  800b9b:	6a 24                	push   $0x24
  800b9d:	68 41 13 80 00       	push   $0x801341
  800ba2:	e8 54 02 00 00       	call   800dfb <_panic>

00800ba7 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	89 d7                	mov    %edx,%edi
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_yield>:

void
sys_yield(void)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd6:	89 d1                	mov    %edx,%ecx
  800bd8:	89 d3                	mov    %edx,%ebx
  800bda:	89 d7                	mov    %edx,%edi
  800bdc:	89 d6                	mov    %edx,%esi
  800bde:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bee:	be 00 00 00 00       	mov    $0x0,%esi
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c01:	89 f7                	mov    %esi,%edi
  800c03:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	7f 08                	jg     800c11 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800c15:	6a 04                	push   $0x4
  800c17:	68 24 13 80 00       	push   $0x801324
  800c1c:	6a 24                	push   $0x24
  800c1e:	68 41 13 80 00       	push   $0x801341
  800c23:	e8 d3 01 00 00       	call   800dfb <_panic>

00800c28 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c31:	8b 55 08             	mov    0x8(%ebp),%edx
  800c34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c37:	b8 05 00 00 00       	mov    $0x5,%eax
  800c3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c42:	8b 75 18             	mov    0x18(%ebp),%esi
  800c45:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c47:	85 c0                	test   %eax,%eax
  800c49:	7f 08                	jg     800c53 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	50                   	push   %eax
  800c57:	6a 05                	push   $0x5
  800c59:	68 24 13 80 00       	push   $0x801324
  800c5e:	6a 24                	push   $0x24
  800c60:	68 41 13 80 00       	push   $0x801341
  800c65:	e8 91 01 00 00       	call   800dfb <_panic>

00800c6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c83:	89 df                	mov    %ebx,%edi
  800c85:	89 de                	mov    %ebx,%esi
  800c87:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 06                	push   $0x6
  800c9b:	68 24 13 80 00       	push   $0x801324
  800ca0:	6a 24                	push   $0x24
  800ca2:	68 41 13 80 00       	push   $0x801341
  800ca7:	e8 4f 01 00 00       	call   800dfb <_panic>

00800cac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc5:	89 df                	mov    %ebx,%edi
  800cc7:	89 de                	mov    %ebx,%esi
  800cc9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	7f 08                	jg     800cd7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	83 ec 0c             	sub    $0xc,%esp
  800cda:	50                   	push   %eax
  800cdb:	6a 08                	push   $0x8
  800cdd:	68 24 13 80 00       	push   $0x801324
  800ce2:	6a 24                	push   $0x24
  800ce4:	68 41 13 80 00       	push   $0x801341
  800ce9:	e8 0d 01 00 00       	call   800dfb <_panic>

00800cee <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cf7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 09 00 00 00       	mov    $0x9,%eax
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	89 de                	mov    %ebx,%esi
  800d0b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 09                	push   $0x9
  800d1f:	68 24 13 80 00       	push   $0x801324
  800d24:	6a 24                	push   $0x24
  800d26:	68 41 13 80 00       	push   $0x801341
  800d2b:	e8 cb 00 00 00       	call   800dfb <_panic>

00800d30 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d41:	be 00 00 00 00       	mov    $0x0,%esi
  800d46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d49:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d69:	89 cb                	mov    %ecx,%ebx
  800d6b:	89 cf                	mov    %ecx,%edi
  800d6d:	89 ce                	mov    %ecx,%esi
  800d6f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d71:	85 c0                	test   %eax,%eax
  800d73:	7f 08                	jg     800d7d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	50                   	push   %eax
  800d81:	6a 0c                	push   $0xc
  800d83:	68 24 13 80 00       	push   $0x801324
  800d88:	6a 24                	push   $0x24
  800d8a:	68 41 13 80 00       	push   $0x801341
  800d8f:	e8 67 00 00 00       	call   800dfb <_panic>

00800d94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800d9a:	68 4f 13 80 00       	push   $0x80134f
  800d9f:	6a 1a                	push   $0x1a
  800da1:	68 68 13 80 00       	push   $0x801368
  800da6:	e8 50 00 00 00       	call   800dfb <_panic>

00800dab <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800db1:	68 72 13 80 00       	push   $0x801372
  800db6:	6a 2a                	push   $0x2a
  800db8:	68 68 13 80 00       	push   $0x801368
  800dbd:	e8 39 00 00 00       	call   800dfb <_panic>

00800dc2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800dcd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800dd0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800dd6:	8b 52 50             	mov    0x50(%edx),%edx
  800dd9:	39 ca                	cmp    %ecx,%edx
  800ddb:	74 11                	je     800dee <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800ddd:	83 c0 01             	add    $0x1,%eax
  800de0:	3d 00 04 00 00       	cmp    $0x400,%eax
  800de5:	75 e6                	jne    800dcd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dec:	eb 0b                	jmp    800df9 <ipc_find_env+0x37>
			return envs[i].env_id;
  800dee:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800df1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800df6:	8b 40 48             	mov    0x48(%eax),%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e00:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e03:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e09:	e8 99 fd ff ff       	call   800ba7 <sys_getenvid>
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	ff 75 0c             	pushl  0xc(%ebp)
  800e14:	ff 75 08             	pushl  0x8(%ebp)
  800e17:	56                   	push   %esi
  800e18:	50                   	push   %eax
  800e19:	68 8c 13 80 00       	push   $0x80138c
  800e1e:	e8 6b f3 ff ff       	call   80018e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e23:	83 c4 18             	add    $0x18,%esp
  800e26:	53                   	push   %ebx
  800e27:	ff 75 10             	pushl  0x10(%ebp)
  800e2a:	e8 0e f3 ff ff       	call   80013d <vcprintf>
	cprintf("\n");
  800e2f:	c7 04 24 af 10 80 00 	movl   $0x8010af,(%esp)
  800e36:	e8 53 f3 ff ff       	call   80018e <cprintf>
  800e3b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e3e:	cc                   	int3   
  800e3f:	eb fd                	jmp    800e3e <_panic+0x43>
  800e41:	66 90                	xchg   %ax,%ax
  800e43:	66 90                	xchg   %ax,%ax
  800e45:	66 90                	xchg   %ax,%ax
  800e47:	66 90                	xchg   %ax,%ax
  800e49:	66 90                	xchg   %ax,%ax
  800e4b:	66 90                	xchg   %ax,%ax
  800e4d:	66 90                	xchg   %ax,%ax
  800e4f:	90                   	nop

00800e50 <__udivdi3>:
  800e50:	55                   	push   %ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	83 ec 1c             	sub    $0x1c,%esp
  800e57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e67:	85 d2                	test   %edx,%edx
  800e69:	75 35                	jne    800ea0 <__udivdi3+0x50>
  800e6b:	39 f3                	cmp    %esi,%ebx
  800e6d:	0f 87 bd 00 00 00    	ja     800f30 <__udivdi3+0xe0>
  800e73:	85 db                	test   %ebx,%ebx
  800e75:	89 d9                	mov    %ebx,%ecx
  800e77:	75 0b                	jne    800e84 <__udivdi3+0x34>
  800e79:	b8 01 00 00 00       	mov    $0x1,%eax
  800e7e:	31 d2                	xor    %edx,%edx
  800e80:	f7 f3                	div    %ebx
  800e82:	89 c1                	mov    %eax,%ecx
  800e84:	31 d2                	xor    %edx,%edx
  800e86:	89 f0                	mov    %esi,%eax
  800e88:	f7 f1                	div    %ecx
  800e8a:	89 c6                	mov    %eax,%esi
  800e8c:	89 e8                	mov    %ebp,%eax
  800e8e:	89 f7                	mov    %esi,%edi
  800e90:	f7 f1                	div    %ecx
  800e92:	89 fa                	mov    %edi,%edx
  800e94:	83 c4 1c             	add    $0x1c,%esp
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    
  800e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	39 f2                	cmp    %esi,%edx
  800ea2:	77 7c                	ja     800f20 <__udivdi3+0xd0>
  800ea4:	0f bd fa             	bsr    %edx,%edi
  800ea7:	83 f7 1f             	xor    $0x1f,%edi
  800eaa:	0f 84 98 00 00 00    	je     800f48 <__udivdi3+0xf8>
  800eb0:	89 f9                	mov    %edi,%ecx
  800eb2:	b8 20 00 00 00       	mov    $0x20,%eax
  800eb7:	29 f8                	sub    %edi,%eax
  800eb9:	d3 e2                	shl    %cl,%edx
  800ebb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ebf:	89 c1                	mov    %eax,%ecx
  800ec1:	89 da                	mov    %ebx,%edx
  800ec3:	d3 ea                	shr    %cl,%edx
  800ec5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ec9:	09 d1                	or     %edx,%ecx
  800ecb:	89 f2                	mov    %esi,%edx
  800ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ed1:	89 f9                	mov    %edi,%ecx
  800ed3:	d3 e3                	shl    %cl,%ebx
  800ed5:	89 c1                	mov    %eax,%ecx
  800ed7:	d3 ea                	shr    %cl,%edx
  800ed9:	89 f9                	mov    %edi,%ecx
  800edb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800edf:	d3 e6                	shl    %cl,%esi
  800ee1:	89 eb                	mov    %ebp,%ebx
  800ee3:	89 c1                	mov    %eax,%ecx
  800ee5:	d3 eb                	shr    %cl,%ebx
  800ee7:	09 de                	or     %ebx,%esi
  800ee9:	89 f0                	mov    %esi,%eax
  800eeb:	f7 74 24 08          	divl   0x8(%esp)
  800eef:	89 d6                	mov    %edx,%esi
  800ef1:	89 c3                	mov    %eax,%ebx
  800ef3:	f7 64 24 0c          	mull   0xc(%esp)
  800ef7:	39 d6                	cmp    %edx,%esi
  800ef9:	72 0c                	jb     800f07 <__udivdi3+0xb7>
  800efb:	89 f9                	mov    %edi,%ecx
  800efd:	d3 e5                	shl    %cl,%ebp
  800eff:	39 c5                	cmp    %eax,%ebp
  800f01:	73 5d                	jae    800f60 <__udivdi3+0x110>
  800f03:	39 d6                	cmp    %edx,%esi
  800f05:	75 59                	jne    800f60 <__udivdi3+0x110>
  800f07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f0a:	31 ff                	xor    %edi,%edi
  800f0c:	89 fa                	mov    %edi,%edx
  800f0e:	83 c4 1c             	add    $0x1c,%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
  800f16:	8d 76 00             	lea    0x0(%esi),%esi
  800f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f20:	31 ff                	xor    %edi,%edi
  800f22:	31 c0                	xor    %eax,%eax
  800f24:	89 fa                	mov    %edi,%edx
  800f26:	83 c4 1c             	add    $0x1c,%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
  800f2e:	66 90                	xchg   %ax,%ax
  800f30:	31 ff                	xor    %edi,%edi
  800f32:	89 e8                	mov    %ebp,%eax
  800f34:	89 f2                	mov    %esi,%edx
  800f36:	f7 f3                	div    %ebx
  800f38:	89 fa                	mov    %edi,%edx
  800f3a:	83 c4 1c             	add    $0x1c,%esp
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    
  800f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f48:	39 f2                	cmp    %esi,%edx
  800f4a:	72 06                	jb     800f52 <__udivdi3+0x102>
  800f4c:	31 c0                	xor    %eax,%eax
  800f4e:	39 eb                	cmp    %ebp,%ebx
  800f50:	77 d2                	ja     800f24 <__udivdi3+0xd4>
  800f52:	b8 01 00 00 00       	mov    $0x1,%eax
  800f57:	eb cb                	jmp    800f24 <__udivdi3+0xd4>
  800f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f60:	89 d8                	mov    %ebx,%eax
  800f62:	31 ff                	xor    %edi,%edi
  800f64:	eb be                	jmp    800f24 <__udivdi3+0xd4>
  800f66:	66 90                	xchg   %ax,%ax
  800f68:	66 90                	xchg   %ax,%ax
  800f6a:	66 90                	xchg   %ax,%ax
  800f6c:	66 90                	xchg   %ax,%ax
  800f6e:	66 90                	xchg   %ax,%ax

00800f70 <__umoddi3>:
  800f70:	55                   	push   %ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 1c             	sub    $0x1c,%esp
  800f77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f87:	85 ed                	test   %ebp,%ebp
  800f89:	89 f0                	mov    %esi,%eax
  800f8b:	89 da                	mov    %ebx,%edx
  800f8d:	75 19                	jne    800fa8 <__umoddi3+0x38>
  800f8f:	39 df                	cmp    %ebx,%edi
  800f91:	0f 86 b1 00 00 00    	jbe    801048 <__umoddi3+0xd8>
  800f97:	f7 f7                	div    %edi
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	83 c4 1c             	add    $0x1c,%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
  800fa5:	8d 76 00             	lea    0x0(%esi),%esi
  800fa8:	39 dd                	cmp    %ebx,%ebp
  800faa:	77 f1                	ja     800f9d <__umoddi3+0x2d>
  800fac:	0f bd cd             	bsr    %ebp,%ecx
  800faf:	83 f1 1f             	xor    $0x1f,%ecx
  800fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fb6:	0f 84 b4 00 00 00    	je     801070 <__umoddi3+0x100>
  800fbc:	b8 20 00 00 00       	mov    $0x20,%eax
  800fc1:	89 c2                	mov    %eax,%edx
  800fc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fc7:	29 c2                	sub    %eax,%edx
  800fc9:	89 c1                	mov    %eax,%ecx
  800fcb:	89 f8                	mov    %edi,%eax
  800fcd:	d3 e5                	shl    %cl,%ebp
  800fcf:	89 d1                	mov    %edx,%ecx
  800fd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fd5:	d3 e8                	shr    %cl,%eax
  800fd7:	09 c5                	or     %eax,%ebp
  800fd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fdd:	89 c1                	mov    %eax,%ecx
  800fdf:	d3 e7                	shl    %cl,%edi
  800fe1:	89 d1                	mov    %edx,%ecx
  800fe3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fe7:	89 df                	mov    %ebx,%edi
  800fe9:	d3 ef                	shr    %cl,%edi
  800feb:	89 c1                	mov    %eax,%ecx
  800fed:	89 f0                	mov    %esi,%eax
  800fef:	d3 e3                	shl    %cl,%ebx
  800ff1:	89 d1                	mov    %edx,%ecx
  800ff3:	89 fa                	mov    %edi,%edx
  800ff5:	d3 e8                	shr    %cl,%eax
  800ff7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800ffc:	09 d8                	or     %ebx,%eax
  800ffe:	f7 f5                	div    %ebp
  801000:	d3 e6                	shl    %cl,%esi
  801002:	89 d1                	mov    %edx,%ecx
  801004:	f7 64 24 08          	mull   0x8(%esp)
  801008:	39 d1                	cmp    %edx,%ecx
  80100a:	89 c3                	mov    %eax,%ebx
  80100c:	89 d7                	mov    %edx,%edi
  80100e:	72 06                	jb     801016 <__umoddi3+0xa6>
  801010:	75 0e                	jne    801020 <__umoddi3+0xb0>
  801012:	39 c6                	cmp    %eax,%esi
  801014:	73 0a                	jae    801020 <__umoddi3+0xb0>
  801016:	2b 44 24 08          	sub    0x8(%esp),%eax
  80101a:	19 ea                	sbb    %ebp,%edx
  80101c:	89 d7                	mov    %edx,%edi
  80101e:	89 c3                	mov    %eax,%ebx
  801020:	89 ca                	mov    %ecx,%edx
  801022:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801027:	29 de                	sub    %ebx,%esi
  801029:	19 fa                	sbb    %edi,%edx
  80102b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80102f:	89 d0                	mov    %edx,%eax
  801031:	d3 e0                	shl    %cl,%eax
  801033:	89 d9                	mov    %ebx,%ecx
  801035:	d3 ee                	shr    %cl,%esi
  801037:	d3 ea                	shr    %cl,%edx
  801039:	09 f0                	or     %esi,%eax
  80103b:	83 c4 1c             	add    $0x1c,%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    
  801043:	90                   	nop
  801044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801048:	85 ff                	test   %edi,%edi
  80104a:	89 f9                	mov    %edi,%ecx
  80104c:	75 0b                	jne    801059 <__umoddi3+0xe9>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	31 d2                	xor    %edx,%edx
  801055:	f7 f7                	div    %edi
  801057:	89 c1                	mov    %eax,%ecx
  801059:	89 d8                	mov    %ebx,%eax
  80105b:	31 d2                	xor    %edx,%edx
  80105d:	f7 f1                	div    %ecx
  80105f:	89 f0                	mov    %esi,%eax
  801061:	f7 f1                	div    %ecx
  801063:	e9 31 ff ff ff       	jmp    800f99 <__umoddi3+0x29>
  801068:	90                   	nop
  801069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801070:	39 dd                	cmp    %ebx,%ebp
  801072:	72 08                	jb     80107c <__umoddi3+0x10c>
  801074:	39 f7                	cmp    %esi,%edi
  801076:	0f 87 21 ff ff ff    	ja     800f9d <__umoddi3+0x2d>
  80107c:	89 da                	mov    %ebx,%edx
  80107e:	89 f0                	mov    %esi,%eax
  801080:	29 f8                	sub    %edi,%eax
  801082:	19 ea                	sbb    %ebp,%edx
  801084:	e9 14 ff ff ff       	jmp    800f9d <__umoddi3+0x2d>
