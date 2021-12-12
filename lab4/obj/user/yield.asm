
obj/user/yield：     文件格式 elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
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
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 20 80 00       	mov    0x802004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 20 10 80 00       	push   $0x801020
  800048:	e8 2a 01 00 00       	call   800177 <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 55 0b 00 00       	call   800baf <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 40 10 80 00       	push   $0x801040
  80006c:	e8 06 01 00 00       	call   800177 <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 04 20 80 00       	mov    0x802004,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 6c 10 80 00       	push   $0x80106c
  80008d:	e8 e5 00 00 00       	call   800177 <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000a6:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8000ad:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b0:	85 c0                	test   %eax,%eax
  8000b2:	7e 08                	jle    8000bc <libmain+0x22>
		binaryname = argv[0];
  8000b4:	8b 0a                	mov    (%edx),%ecx
  8000b6:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000bc:	83 ec 08             	sub    $0x8,%esp
  8000bf:	52                   	push   %edx
  8000c0:	50                   	push   %eax
  8000c1:	e8 6d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c6:	e8 05 00 00 00       	call   8000d0 <exit>
}
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	c9                   	leave  
  8000cf:	c3                   	ret    

008000d0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	e8 72 0a 00 00       	call   800b4f <sys_env_destroy>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	c9                   	leave  
  8000e1:	c3                   	ret    

008000e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ec:	8b 13                	mov    (%ebx),%edx
  8000ee:	8d 42 01             	lea    0x1(%edx),%eax
  8000f1:	89 03                	mov    %eax,(%ebx)
  8000f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ff:	74 09                	je     80010a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800101:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800108:	c9                   	leave  
  800109:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	68 ff 00 00 00       	push   $0xff
  800112:	8d 43 08             	lea    0x8(%ebx),%eax
  800115:	50                   	push   %eax
  800116:	e8 f7 09 00 00       	call   800b12 <sys_cputs>
		b->idx = 0;
  80011b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	eb db                	jmp    800101 <putch+0x1f>

00800126 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800126:	55                   	push   %ebp
  800127:	89 e5                	mov    %esp,%ebp
  800129:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800136:	00 00 00 
	b.cnt = 0;
  800139:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800140:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800143:	ff 75 0c             	pushl  0xc(%ebp)
  800146:	ff 75 08             	pushl  0x8(%ebp)
  800149:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014f:	50                   	push   %eax
  800150:	68 e2 00 80 00       	push   $0x8000e2
  800155:	e8 1a 01 00 00       	call   800274 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015a:	83 c4 08             	add    $0x8,%esp
  80015d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800163:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800169:	50                   	push   %eax
  80016a:	e8 a3 09 00 00       	call   800b12 <sys_cputs>

	return b.cnt;
}
  80016f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800180:	50                   	push   %eax
  800181:	ff 75 08             	pushl  0x8(%ebp)
  800184:	e8 9d ff ff ff       	call   800126 <vcprintf>
	va_end(ap);

	return cnt;
}
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	57                   	push   %edi
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
  800191:	83 ec 1c             	sub    $0x1c,%esp
  800194:	89 c7                	mov    %eax,%edi
  800196:	89 d6                	mov    %edx,%esi
  800198:	8b 45 08             	mov    0x8(%ebp),%eax
  80019b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ac:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001af:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b2:	39 d3                	cmp    %edx,%ebx
  8001b4:	72 05                	jb     8001bb <printnum+0x30>
  8001b6:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001b9:	77 7a                	ja     800235 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	ff 75 18             	pushl  0x18(%ebp)
  8001c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001c7:	53                   	push   %ebx
  8001c8:	ff 75 10             	pushl  0x10(%ebp)
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001da:	e8 f1 0b 00 00       	call   800dd0 <__udivdi3>
  8001df:	83 c4 18             	add    $0x18,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	89 f2                	mov    %esi,%edx
  8001e6:	89 f8                	mov    %edi,%eax
  8001e8:	e8 9e ff ff ff       	call   80018b <printnum>
  8001ed:	83 c4 20             	add    $0x20,%esp
  8001f0:	eb 13                	jmp    800205 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	56                   	push   %esi
  8001f6:	ff 75 18             	pushl  0x18(%ebp)
  8001f9:	ff d7                	call   *%edi
  8001fb:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001fe:	83 eb 01             	sub    $0x1,%ebx
  800201:	85 db                	test   %ebx,%ebx
  800203:	7f ed                	jg     8001f2 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020f:	ff 75 e0             	pushl  -0x20(%ebp)
  800212:	ff 75 dc             	pushl  -0x24(%ebp)
  800215:	ff 75 d8             	pushl  -0x28(%ebp)
  800218:	e8 d3 0c 00 00       	call   800ef0 <__umoddi3>
  80021d:	83 c4 14             	add    $0x14,%esp
  800220:	0f be 80 95 10 80 00 	movsbl 0x801095(%eax),%eax
  800227:	50                   	push   %eax
  800228:	ff d7                	call   *%edi
}
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800230:	5b                   	pop    %ebx
  800231:	5e                   	pop    %esi
  800232:	5f                   	pop    %edi
  800233:	5d                   	pop    %ebp
  800234:	c3                   	ret    
  800235:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800238:	eb c4                	jmp    8001fe <printnum+0x73>

0080023a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800240:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800244:	8b 10                	mov    (%eax),%edx
  800246:	3b 50 04             	cmp    0x4(%eax),%edx
  800249:	73 0a                	jae    800255 <sprintputch+0x1b>
		*b->buf++ = ch;
  80024b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024e:	89 08                	mov    %ecx,(%eax)
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	88 02                	mov    %al,(%edx)
}
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    

00800257 <printfmt>:
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800260:	50                   	push   %eax
  800261:	ff 75 10             	pushl  0x10(%ebp)
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 05 00 00 00       	call   800274 <vprintfmt>
}
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <vprintfmt>:
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 2c             	sub    $0x2c,%esp
  80027d:	8b 75 08             	mov    0x8(%ebp),%esi
  800280:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800283:	8b 7d 10             	mov    0x10(%ebp),%edi
  800286:	e9 00 04 00 00       	jmp    80068b <vprintfmt+0x417>
		padc = ' ';
  80028b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80028f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800296:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80029d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a9:	8d 47 01             	lea    0x1(%edi),%eax
  8002ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002af:	0f b6 17             	movzbl (%edi),%edx
  8002b2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b5:	3c 55                	cmp    $0x55,%al
  8002b7:	0f 87 51 04 00 00    	ja     80070e <vprintfmt+0x49a>
  8002bd:	0f b6 c0             	movzbl %al,%eax
  8002c0:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  8002c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002ca:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ce:	eb d9                	jmp    8002a9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002d3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002d7:	eb d0                	jmp    8002a9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d9:	0f b6 d2             	movzbl %dl,%edx
  8002dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002df:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002ea:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ee:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002f1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f4:	83 f9 09             	cmp    $0x9,%ecx
  8002f7:	77 55                	ja     80034e <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002f9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fc:	eb e9                	jmp    8002e7 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800301:	8b 00                	mov    (%eax),%eax
  800303:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800306:	8b 45 14             	mov    0x14(%ebp),%eax
  800309:	8d 40 04             	lea    0x4(%eax),%eax
  80030c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800312:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800316:	79 91                	jns    8002a9 <vprintfmt+0x35>
				width = precision, precision = -1;
  800318:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80031b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800325:	eb 82                	jmp    8002a9 <vprintfmt+0x35>
  800327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032a:	85 c0                	test   %eax,%eax
  80032c:	ba 00 00 00 00       	mov    $0x0,%edx
  800331:	0f 49 d0             	cmovns %eax,%edx
  800334:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80033a:	e9 6a ff ff ff       	jmp    8002a9 <vprintfmt+0x35>
  80033f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800342:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800349:	e9 5b ff ff ff       	jmp    8002a9 <vprintfmt+0x35>
  80034e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800351:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800354:	eb bc                	jmp    800312 <vprintfmt+0x9e>
			lflag++;
  800356:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800359:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035c:	e9 48 ff ff ff       	jmp    8002a9 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800361:	8b 45 14             	mov    0x14(%ebp),%eax
  800364:	8d 78 04             	lea    0x4(%eax),%edi
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	53                   	push   %ebx
  80036b:	ff 30                	pushl  (%eax)
  80036d:	ff d6                	call   *%esi
			break;
  80036f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800372:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800375:	e9 0e 03 00 00       	jmp    800688 <vprintfmt+0x414>
			err = va_arg(ap, int);
  80037a:	8b 45 14             	mov    0x14(%ebp),%eax
  80037d:	8d 78 04             	lea    0x4(%eax),%edi
  800380:	8b 00                	mov    (%eax),%eax
  800382:	99                   	cltd   
  800383:	31 d0                	xor    %edx,%eax
  800385:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800387:	83 f8 08             	cmp    $0x8,%eax
  80038a:	7f 23                	jg     8003af <vprintfmt+0x13b>
  80038c:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  800393:	85 d2                	test   %edx,%edx
  800395:	74 18                	je     8003af <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800397:	52                   	push   %edx
  800398:	68 b6 10 80 00       	push   $0x8010b6
  80039d:	53                   	push   %ebx
  80039e:	56                   	push   %esi
  80039f:	e8 b3 fe ff ff       	call   800257 <printfmt>
  8003a4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003aa:	e9 d9 02 00 00       	jmp    800688 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003af:	50                   	push   %eax
  8003b0:	68 ad 10 80 00       	push   $0x8010ad
  8003b5:	53                   	push   %ebx
  8003b6:	56                   	push   %esi
  8003b7:	e8 9b fe ff ff       	call   800257 <printfmt>
  8003bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c2:	e9 c1 02 00 00       	jmp    800688 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	83 c0 04             	add    $0x4,%eax
  8003cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003d5:	85 ff                	test   %edi,%edi
  8003d7:	b8 a6 10 80 00       	mov    $0x8010a6,%eax
  8003dc:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e3:	0f 8e bd 00 00 00    	jle    8004a6 <vprintfmt+0x232>
  8003e9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003ed:	75 0e                	jne    8003fd <vprintfmt+0x189>
  8003ef:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003f5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003f8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fb:	eb 6d                	jmp    80046a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	ff 75 d0             	pushl  -0x30(%ebp)
  800403:	57                   	push   %edi
  800404:	e8 ad 03 00 00       	call   8007b6 <strnlen>
  800409:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040c:	29 c1                	sub    %eax,%ecx
  80040e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800411:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800414:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800418:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80041e:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800420:	eb 0f                	jmp    800431 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	53                   	push   %ebx
  800426:	ff 75 e0             	pushl  -0x20(%ebp)
  800429:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80042b:	83 ef 01             	sub    $0x1,%edi
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	85 ff                	test   %edi,%edi
  800433:	7f ed                	jg     800422 <vprintfmt+0x1ae>
  800435:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800438:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80043b:	85 c9                	test   %ecx,%ecx
  80043d:	b8 00 00 00 00       	mov    $0x0,%eax
  800442:	0f 49 c1             	cmovns %ecx,%eax
  800445:	29 c1                	sub    %eax,%ecx
  800447:	89 75 08             	mov    %esi,0x8(%ebp)
  80044a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80044d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800450:	89 cb                	mov    %ecx,%ebx
  800452:	eb 16                	jmp    80046a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800454:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800458:	75 31                	jne    80048b <vprintfmt+0x217>
					putch(ch, putdat);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	50                   	push   %eax
  800461:	ff 55 08             	call   *0x8(%ebp)
  800464:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800467:	83 eb 01             	sub    $0x1,%ebx
  80046a:	83 c7 01             	add    $0x1,%edi
  80046d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800471:	0f be c2             	movsbl %dl,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	74 59                	je     8004d1 <vprintfmt+0x25d>
  800478:	85 f6                	test   %esi,%esi
  80047a:	78 d8                	js     800454 <vprintfmt+0x1e0>
  80047c:	83 ee 01             	sub    $0x1,%esi
  80047f:	79 d3                	jns    800454 <vprintfmt+0x1e0>
  800481:	89 df                	mov    %ebx,%edi
  800483:	8b 75 08             	mov    0x8(%ebp),%esi
  800486:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800489:	eb 37                	jmp    8004c2 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80048b:	0f be d2             	movsbl %dl,%edx
  80048e:	83 ea 20             	sub    $0x20,%edx
  800491:	83 fa 5e             	cmp    $0x5e,%edx
  800494:	76 c4                	jbe    80045a <vprintfmt+0x1e6>
					putch('?', putdat);
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 0c             	pushl  0xc(%ebp)
  80049c:	6a 3f                	push   $0x3f
  80049e:	ff 55 08             	call   *0x8(%ebp)
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	eb c1                	jmp    800467 <vprintfmt+0x1f3>
  8004a6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ac:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b2:	eb b6                	jmp    80046a <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	53                   	push   %ebx
  8004b8:	6a 20                	push   $0x20
  8004ba:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004bc:	83 ef 01             	sub    $0x1,%edi
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	85 ff                	test   %edi,%edi
  8004c4:	7f ee                	jg     8004b4 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cc:	e9 b7 01 00 00       	jmp    800688 <vprintfmt+0x414>
  8004d1:	89 df                	mov    %ebx,%edi
  8004d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d9:	eb e7                	jmp    8004c2 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004db:	83 f9 01             	cmp    $0x1,%ecx
  8004de:	7e 3f                	jle    80051f <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8b 50 04             	mov    0x4(%eax),%edx
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	8d 40 08             	lea    0x8(%eax),%eax
  8004f4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004fb:	79 5c                	jns    800559 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	53                   	push   %ebx
  800501:	6a 2d                	push   $0x2d
  800503:	ff d6                	call   *%esi
				num = -(long long) num;
  800505:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800508:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050b:	f7 da                	neg    %edx
  80050d:	83 d1 00             	adc    $0x0,%ecx
  800510:	f7 d9                	neg    %ecx
  800512:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800515:	b8 0a 00 00 00       	mov    $0xa,%eax
  80051a:	e9 4f 01 00 00       	jmp    80066e <vprintfmt+0x3fa>
	else if (lflag)
  80051f:	85 c9                	test   %ecx,%ecx
  800521:	75 1b                	jne    80053e <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800523:	8b 45 14             	mov    0x14(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052b:	89 c1                	mov    %eax,%ecx
  80052d:	c1 f9 1f             	sar    $0x1f,%ecx
  800530:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	8d 40 04             	lea    0x4(%eax),%eax
  800539:	89 45 14             	mov    %eax,0x14(%ebp)
  80053c:	eb b9                	jmp    8004f7 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800546:	89 c1                	mov    %eax,%ecx
  800548:	c1 f9 1f             	sar    $0x1f,%ecx
  80054b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8d 40 04             	lea    0x4(%eax),%eax
  800554:	89 45 14             	mov    %eax,0x14(%ebp)
  800557:	eb 9e                	jmp    8004f7 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800559:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80055c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80055f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800564:	e9 05 01 00 00       	jmp    80066e <vprintfmt+0x3fa>
	if (lflag >= 2)
  800569:	83 f9 01             	cmp    $0x1,%ecx
  80056c:	7e 18                	jle    800586 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 10                	mov    (%eax),%edx
  800573:	8b 48 04             	mov    0x4(%eax),%ecx
  800576:	8d 40 08             	lea    0x8(%eax),%eax
  800579:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800581:	e9 e8 00 00 00       	jmp    80066e <vprintfmt+0x3fa>
	else if (lflag)
  800586:	85 c9                	test   %ecx,%ecx
  800588:	75 1a                	jne    8005a4 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 10                	mov    (%eax),%edx
  80058f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059f:	e9 ca 00 00 00       	jmp    80066e <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ae:	8d 40 04             	lea    0x4(%eax),%eax
  8005b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b9:	e9 b0 00 00 00       	jmp    80066e <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005be:	83 f9 01             	cmp    $0x1,%ecx
  8005c1:	7e 3c                	jle    8005ff <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 50 04             	mov    0x4(%eax),%edx
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 40 08             	lea    0x8(%eax),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005de:	79 59                	jns    800639 <vprintfmt+0x3c5>
                putch('-', putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	53                   	push   %ebx
  8005e4:	6a 2d                	push   $0x2d
  8005e6:	ff d6                	call   *%esi
                num = -(long long) num;
  8005e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005eb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005ee:	f7 da                	neg    %edx
  8005f0:	83 d1 00             	adc    $0x0,%ecx
  8005f3:	f7 d9                	neg    %ecx
  8005f5:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8005fd:	eb 6f                	jmp    80066e <vprintfmt+0x3fa>
	else if (lflag)
  8005ff:	85 c9                	test   %ecx,%ecx
  800601:	75 1b                	jne    80061e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	89 c1                	mov    %eax,%ecx
  80060d:	c1 f9 1f             	sar    $0x1f,%ecx
  800610:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8d 40 04             	lea    0x4(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
  80061c:	eb bc                	jmp    8005da <vprintfmt+0x366>
		return va_arg(*ap, long);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800626:	89 c1                	mov    %eax,%ecx
  800628:	c1 f9 1f             	sar    $0x1f,%ecx
  80062b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	eb a1                	jmp    8005da <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800639:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80063c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80063f:	b8 08 00 00 00       	mov    $0x8,%eax
  800644:	eb 28                	jmp    80066e <vprintfmt+0x3fa>
			putch('0', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 30                	push   $0x30
  80064c:	ff d6                	call   *%esi
			putch('x', putdat);
  80064e:	83 c4 08             	add    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	6a 78                	push   $0x78
  800654:	ff d6                	call   *%esi
			num = (unsigned long long)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 10                	mov    (%eax),%edx
  80065b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800660:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800669:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80066e:	83 ec 0c             	sub    $0xc,%esp
  800671:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800675:	57                   	push   %edi
  800676:	ff 75 e0             	pushl  -0x20(%ebp)
  800679:	50                   	push   %eax
  80067a:	51                   	push   %ecx
  80067b:	52                   	push   %edx
  80067c:	89 da                	mov    %ebx,%edx
  80067e:	89 f0                	mov    %esi,%eax
  800680:	e8 06 fb ff ff       	call   80018b <printnum>
			break;
  800685:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800688:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068b:	83 c7 01             	add    $0x1,%edi
  80068e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800692:	83 f8 25             	cmp    $0x25,%eax
  800695:	0f 84 f0 fb ff ff    	je     80028b <vprintfmt+0x17>
			if (ch == '\0')
  80069b:	85 c0                	test   %eax,%eax
  80069d:	0f 84 8b 00 00 00    	je     80072e <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	53                   	push   %ebx
  8006a7:	50                   	push   %eax
  8006a8:	ff d6                	call   *%esi
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	eb dc                	jmp    80068b <vprintfmt+0x417>
	if (lflag >= 2)
  8006af:	83 f9 01             	cmp    $0x1,%ecx
  8006b2:	7e 15                	jle    8006c9 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 10                	mov    (%eax),%edx
  8006b9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bc:	8d 40 08             	lea    0x8(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c7:	eb a5                	jmp    80066e <vprintfmt+0x3fa>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	75 17                	jne    8006e4 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e2:	eb 8a                	jmp    80066e <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f9:	e9 70 ff ff ff       	jmp    80066e <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	53                   	push   %ebx
  800702:	6a 25                	push   $0x25
  800704:	ff d6                	call   *%esi
			break;
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	e9 7a ff ff ff       	jmp    800688 <vprintfmt+0x414>
			putch('%', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 25                	push   $0x25
  800714:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	89 f8                	mov    %edi,%eax
  80071b:	eb 03                	jmp    800720 <vprintfmt+0x4ac>
  80071d:	83 e8 01             	sub    $0x1,%eax
  800720:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800724:	75 f7                	jne    80071d <vprintfmt+0x4a9>
  800726:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800729:	e9 5a ff ff ff       	jmp    800688 <vprintfmt+0x414>
}
  80072e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800731:	5b                   	pop    %ebx
  800732:	5e                   	pop    %esi
  800733:	5f                   	pop    %edi
  800734:	5d                   	pop    %ebp
  800735:	c3                   	ret    

00800736 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800745:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800749:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80074c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800753:	85 c0                	test   %eax,%eax
  800755:	74 26                	je     80077d <vsnprintf+0x47>
  800757:	85 d2                	test   %edx,%edx
  800759:	7e 22                	jle    80077d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80075b:	ff 75 14             	pushl  0x14(%ebp)
  80075e:	ff 75 10             	pushl  0x10(%ebp)
  800761:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 3a 02 80 00       	push   $0x80023a
  80076a:	e8 05 fb ff ff       	call   800274 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80076f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800772:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800778:	83 c4 10             	add    $0x10,%esp
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    
		return -E_INVAL;
  80077d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800782:	eb f7                	jmp    80077b <vsnprintf+0x45>

00800784 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80078a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80078d:	50                   	push   %eax
  80078e:	ff 75 10             	pushl  0x10(%ebp)
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	ff 75 08             	pushl  0x8(%ebp)
  800797:	e8 9a ff ff ff       	call   800736 <vsnprintf>
	va_end(ap);

	return rc;
}
  80079c:	c9                   	leave  
  80079d:	c3                   	ret    

0080079e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a9:	eb 03                	jmp    8007ae <strlen+0x10>
		n++;
  8007ab:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007ae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b2:	75 f7                	jne    8007ab <strlen+0xd>
	return n;
}
  8007b4:	5d                   	pop    %ebp
  8007b5:	c3                   	ret    

008007b6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	eb 03                	jmp    8007c9 <strnlen+0x13>
		n++;
  8007c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c9:	39 d0                	cmp    %edx,%eax
  8007cb:	74 06                	je     8007d3 <strnlen+0x1d>
  8007cd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d1:	75 f3                	jne    8007c6 <strnlen+0x10>
	return n;
}
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	53                   	push   %ebx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007df:	89 c2                	mov    %eax,%edx
  8007e1:	83 c1 01             	add    $0x1,%ecx
  8007e4:	83 c2 01             	add    $0x1,%edx
  8007e7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007eb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ee:	84 db                	test   %bl,%bl
  8007f0:	75 ef                	jne    8007e1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f2:	5b                   	pop    %ebx
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	53                   	push   %ebx
  8007f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fc:	53                   	push   %ebx
  8007fd:	e8 9c ff ff ff       	call   80079e <strlen>
  800802:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	01 d8                	add    %ebx,%eax
  80080a:	50                   	push   %eax
  80080b:	e8 c5 ff ff ff       	call   8007d5 <strcpy>
	return dst;
}
  800810:	89 d8                	mov    %ebx,%eax
  800812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	56                   	push   %esi
  80081b:	53                   	push   %ebx
  80081c:	8b 75 08             	mov    0x8(%ebp),%esi
  80081f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800822:	89 f3                	mov    %esi,%ebx
  800824:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800827:	89 f2                	mov    %esi,%edx
  800829:	eb 0f                	jmp    80083a <strncpy+0x23>
		*dst++ = *src;
  80082b:	83 c2 01             	add    $0x1,%edx
  80082e:	0f b6 01             	movzbl (%ecx),%eax
  800831:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800834:	80 39 01             	cmpb   $0x1,(%ecx)
  800837:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80083a:	39 da                	cmp    %ebx,%edx
  80083c:	75 ed                	jne    80082b <strncpy+0x14>
	}
	return ret;
}
  80083e:	89 f0                	mov    %esi,%eax
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	56                   	push   %esi
  800848:	53                   	push   %ebx
  800849:	8b 75 08             	mov    0x8(%ebp),%esi
  80084c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800852:	89 f0                	mov    %esi,%eax
  800854:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800858:	85 c9                	test   %ecx,%ecx
  80085a:	75 0b                	jne    800867 <strlcpy+0x23>
  80085c:	eb 17                	jmp    800875 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80085e:	83 c2 01             	add    $0x1,%edx
  800861:	83 c0 01             	add    $0x1,%eax
  800864:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800867:	39 d8                	cmp    %ebx,%eax
  800869:	74 07                	je     800872 <strlcpy+0x2e>
  80086b:	0f b6 0a             	movzbl (%edx),%ecx
  80086e:	84 c9                	test   %cl,%cl
  800870:	75 ec                	jne    80085e <strlcpy+0x1a>
		*dst = '\0';
  800872:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800875:	29 f0                	sub    %esi,%eax
}
  800877:	5b                   	pop    %ebx
  800878:	5e                   	pop    %esi
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800884:	eb 06                	jmp    80088c <strcmp+0x11>
		p++, q++;
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80088c:	0f b6 01             	movzbl (%ecx),%eax
  80088f:	84 c0                	test   %al,%al
  800891:	74 04                	je     800897 <strcmp+0x1c>
  800893:	3a 02                	cmp    (%edx),%al
  800895:	74 ef                	je     800886 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800897:	0f b6 c0             	movzbl %al,%eax
  80089a:	0f b6 12             	movzbl (%edx),%edx
  80089d:	29 d0                	sub    %edx,%eax
}
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ab:	89 c3                	mov    %eax,%ebx
  8008ad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strncmp+0x17>
		n--, p++, q++;
  8008b2:	83 c0 01             	add    $0x1,%eax
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b8:	39 d8                	cmp    %ebx,%eax
  8008ba:	74 16                	je     8008d2 <strncmp+0x31>
  8008bc:	0f b6 08             	movzbl (%eax),%ecx
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	74 04                	je     8008c7 <strncmp+0x26>
  8008c3:	3a 0a                	cmp    (%edx),%cl
  8008c5:	74 eb                	je     8008b2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c7:	0f b6 00             	movzbl (%eax),%eax
  8008ca:	0f b6 12             	movzbl (%edx),%edx
  8008cd:	29 d0                	sub    %edx,%eax
}
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb f6                	jmp    8008cf <strncmp+0x2e>

008008d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e3:	0f b6 10             	movzbl (%eax),%edx
  8008e6:	84 d2                	test   %dl,%dl
  8008e8:	74 09                	je     8008f3 <strchr+0x1a>
		if (*s == c)
  8008ea:	38 ca                	cmp    %cl,%dl
  8008ec:	74 0a                	je     8008f8 <strchr+0x1f>
	for (; *s; s++)
  8008ee:	83 c0 01             	add    $0x1,%eax
  8008f1:	eb f0                	jmp    8008e3 <strchr+0xa>
			return (char *) s;
	return 0;
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800904:	eb 03                	jmp    800909 <strfind+0xf>
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090c:	38 ca                	cmp    %cl,%dl
  80090e:	74 04                	je     800914 <strfind+0x1a>
  800910:	84 d2                	test   %dl,%dl
  800912:	75 f2                	jne    800906 <strfind+0xc>
			break;
	return (char *) s;
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	57                   	push   %edi
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80091f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800922:	85 c9                	test   %ecx,%ecx
  800924:	74 13                	je     800939 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800926:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092c:	75 05                	jne    800933 <memset+0x1d>
  80092e:	f6 c1 03             	test   $0x3,%cl
  800931:	74 0d                	je     800940 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	fc                   	cld    
  800937:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800939:	89 f8                	mov    %edi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5f                   	pop    %edi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    
		c &= 0xFF;
  800940:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800944:	89 d3                	mov    %edx,%ebx
  800946:	c1 e3 08             	shl    $0x8,%ebx
  800949:	89 d0                	mov    %edx,%eax
  80094b:	c1 e0 18             	shl    $0x18,%eax
  80094e:	89 d6                	mov    %edx,%esi
  800950:	c1 e6 10             	shl    $0x10,%esi
  800953:	09 f0                	or     %esi,%eax
  800955:	09 c2                	or     %eax,%edx
  800957:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800959:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	fc                   	cld    
  80095f:	f3 ab                	rep stos %eax,%es:(%edi)
  800961:	eb d6                	jmp    800939 <memset+0x23>

00800963 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	57                   	push   %edi
  800967:	56                   	push   %esi
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800971:	39 c6                	cmp    %eax,%esi
  800973:	73 35                	jae    8009aa <memmove+0x47>
  800975:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800978:	39 c2                	cmp    %eax,%edx
  80097a:	76 2e                	jbe    8009aa <memmove+0x47>
		s += n;
		d += n;
  80097c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097f:	89 d6                	mov    %edx,%esi
  800981:	09 fe                	or     %edi,%esi
  800983:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800989:	74 0c                	je     800997 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80098b:	83 ef 01             	sub    $0x1,%edi
  80098e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800991:	fd                   	std    
  800992:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800994:	fc                   	cld    
  800995:	eb 21                	jmp    8009b8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800997:	f6 c1 03             	test   $0x3,%cl
  80099a:	75 ef                	jne    80098b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80099c:	83 ef 04             	sub    $0x4,%edi
  80099f:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a8:	eb ea                	jmp    800994 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009aa:	89 f2                	mov    %esi,%edx
  8009ac:	09 c2                	or     %eax,%edx
  8009ae:	f6 c2 03             	test   $0x3,%dl
  8009b1:	74 09                	je     8009bc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009b3:	89 c7                	mov    %eax,%edi
  8009b5:	fc                   	cld    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b8:	5e                   	pop    %esi
  8009b9:	5f                   	pop    %edi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bc:	f6 c1 03             	test   $0x3,%cl
  8009bf:	75 f2                	jne    8009b3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c4:	89 c7                	mov    %eax,%edi
  8009c6:	fc                   	cld    
  8009c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c9:	eb ed                	jmp    8009b8 <memmove+0x55>

008009cb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009ce:	ff 75 10             	pushl  0x10(%ebp)
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	ff 75 08             	pushl  0x8(%ebp)
  8009d7:	e8 87 ff ff ff       	call   800963 <memmove>
}
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    

008009de <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	56                   	push   %esi
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e9:	89 c6                	mov    %eax,%esi
  8009eb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ee:	39 f0                	cmp    %esi,%eax
  8009f0:	74 1c                	je     800a0e <memcmp+0x30>
		if (*s1 != *s2)
  8009f2:	0f b6 08             	movzbl (%eax),%ecx
  8009f5:	0f b6 1a             	movzbl (%edx),%ebx
  8009f8:	38 d9                	cmp    %bl,%cl
  8009fa:	75 08                	jne    800a04 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	83 c2 01             	add    $0x1,%edx
  800a02:	eb ea                	jmp    8009ee <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a04:	0f b6 c1             	movzbl %cl,%eax
  800a07:	0f b6 db             	movzbl %bl,%ebx
  800a0a:	29 d8                	sub    %ebx,%eax
  800a0c:	eb 05                	jmp    800a13 <memcmp+0x35>
	}

	return 0;
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a20:	89 c2                	mov    %eax,%edx
  800a22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a25:	39 d0                	cmp    %edx,%eax
  800a27:	73 09                	jae    800a32 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a29:	38 08                	cmp    %cl,(%eax)
  800a2b:	74 05                	je     800a32 <memfind+0x1b>
	for (; s < ends; s++)
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	eb f3                	jmp    800a25 <memfind+0xe>
			break;
	return (void *) s;
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a40:	eb 03                	jmp    800a45 <strtol+0x11>
		s++;
  800a42:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a45:	0f b6 01             	movzbl (%ecx),%eax
  800a48:	3c 20                	cmp    $0x20,%al
  800a4a:	74 f6                	je     800a42 <strtol+0xe>
  800a4c:	3c 09                	cmp    $0x9,%al
  800a4e:	74 f2                	je     800a42 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a50:	3c 2b                	cmp    $0x2b,%al
  800a52:	74 2e                	je     800a82 <strtol+0x4e>
	int neg = 0;
  800a54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a59:	3c 2d                	cmp    $0x2d,%al
  800a5b:	74 2f                	je     800a8c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a63:	75 05                	jne    800a6a <strtol+0x36>
  800a65:	80 39 30             	cmpb   $0x30,(%ecx)
  800a68:	74 2c                	je     800a96 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a6a:	85 db                	test   %ebx,%ebx
  800a6c:	75 0a                	jne    800a78 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a6e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a73:	80 39 30             	cmpb   $0x30,(%ecx)
  800a76:	74 28                	je     800aa0 <strtol+0x6c>
		base = 10;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a80:	eb 50                	jmp    800ad2 <strtol+0x9e>
		s++;
  800a82:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a85:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8a:	eb d1                	jmp    800a5d <strtol+0x29>
		s++, neg = 1;
  800a8c:	83 c1 01             	add    $0x1,%ecx
  800a8f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a94:	eb c7                	jmp    800a5d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a96:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a9a:	74 0e                	je     800aaa <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a9c:	85 db                	test   %ebx,%ebx
  800a9e:	75 d8                	jne    800a78 <strtol+0x44>
		s++, base = 8;
  800aa0:	83 c1 01             	add    $0x1,%ecx
  800aa3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aa8:	eb ce                	jmp    800a78 <strtol+0x44>
		s += 2, base = 16;
  800aaa:	83 c1 02             	add    $0x2,%ecx
  800aad:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab2:	eb c4                	jmp    800a78 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab7:	89 f3                	mov    %esi,%ebx
  800ab9:	80 fb 19             	cmp    $0x19,%bl
  800abc:	77 29                	ja     800ae7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800abe:	0f be d2             	movsbl %dl,%edx
  800ac1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac7:	7d 30                	jge    800af9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac9:	83 c1 01             	add    $0x1,%ecx
  800acc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad2:	0f b6 11             	movzbl (%ecx),%edx
  800ad5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad8:	89 f3                	mov    %esi,%ebx
  800ada:	80 fb 09             	cmp    $0x9,%bl
  800add:	77 d5                	ja     800ab4 <strtol+0x80>
			dig = *s - '0';
  800adf:	0f be d2             	movsbl %dl,%edx
  800ae2:	83 ea 30             	sub    $0x30,%edx
  800ae5:	eb dd                	jmp    800ac4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ae7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aea:	89 f3                	mov    %esi,%ebx
  800aec:	80 fb 19             	cmp    $0x19,%bl
  800aef:	77 08                	ja     800af9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af1:	0f be d2             	movsbl %dl,%edx
  800af4:	83 ea 37             	sub    $0x37,%edx
  800af7:	eb cb                	jmp    800ac4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afd:	74 05                	je     800b04 <strtol+0xd0>
		*endptr = (char *) s;
  800aff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b02:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	f7 da                	neg    %edx
  800b08:	85 ff                	test   %edi,%edi
  800b0a:	0f 45 c2             	cmovne %edx,%eax
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5f                   	pop    %edi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	57                   	push   %edi
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b23:	89 c3                	mov    %eax,%ebx
  800b25:	89 c7                	mov    %eax,%edi
  800b27:	89 c6                	mov    %eax,%esi
  800b29:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5f                   	pop    %edi
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <sys_cgetc>:

int
sys_cgetc(void) {
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	57                   	push   %edi
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b36:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b40:	89 d1                	mov    %edx,%ecx
  800b42:	89 d3                	mov    %edx,%ebx
  800b44:	89 d7                	mov    %edx,%edi
  800b46:	89 d6                	mov    %edx,%esi
  800b48:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	89 cb                	mov    %ecx,%ebx
  800b67:	89 cf                	mov    %ecx,%edi
  800b69:	89 ce                	mov    %ecx,%esi
  800b6b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	7f 08                	jg     800b79 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b79:	83 ec 0c             	sub    $0xc,%esp
  800b7c:	50                   	push   %eax
  800b7d:	6a 03                	push   $0x3
  800b7f:	68 e4 12 80 00       	push   $0x8012e4
  800b84:	6a 24                	push   $0x24
  800b86:	68 01 13 80 00       	push   $0x801301
  800b8b:	e8 ed 01 00 00       	call   800d7d <_panic>

00800b90 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b96:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9b:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba0:	89 d1                	mov    %edx,%ecx
  800ba2:	89 d3                	mov    %edx,%ebx
  800ba4:	89 d7                	mov    %edx,%edi
  800ba6:	89 d6                	mov    %edx,%esi
  800ba8:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <sys_yield>:

void
sys_yield(void)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bbf:	89 d1                	mov    %edx,%ecx
  800bc1:	89 d3                	mov    %edx,%ebx
  800bc3:	89 d7                	mov    %edx,%edi
  800bc5:	89 d6                	mov    %edx,%esi
  800bc7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bd7:	be 00 00 00 00       	mov    $0x0,%esi
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be2:	b8 04 00 00 00       	mov    $0x4,%eax
  800be7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bea:	89 f7                	mov    %esi,%edi
  800bec:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bee:	85 c0                	test   %eax,%eax
  800bf0:	7f 08                	jg     800bfa <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bfa:	83 ec 0c             	sub    $0xc,%esp
  800bfd:	50                   	push   %eax
  800bfe:	6a 04                	push   $0x4
  800c00:	68 e4 12 80 00       	push   $0x8012e4
  800c05:	6a 24                	push   $0x24
  800c07:	68 01 13 80 00       	push   $0x801301
  800c0c:	e8 6c 01 00 00       	call   800d7d <_panic>

00800c11 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	57                   	push   %edi
  800c15:	56                   	push   %esi
  800c16:	53                   	push   %ebx
  800c17:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c20:	b8 05 00 00 00       	mov    $0x5,%eax
  800c25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c2b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c2e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 05                	push   $0x5
  800c42:	68 e4 12 80 00       	push   $0x8012e4
  800c47:	6a 24                	push   $0x24
  800c49:	68 01 13 80 00       	push   $0x801301
  800c4e:	e8 2a 01 00 00       	call   800d7d <_panic>

00800c53 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c61:	8b 55 08             	mov    0x8(%ebp),%edx
  800c64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c67:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6c:	89 df                	mov    %ebx,%edi
  800c6e:	89 de                	mov    %ebx,%esi
  800c70:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 06                	push   $0x6
  800c84:	68 e4 12 80 00       	push   $0x8012e4
  800c89:	6a 24                	push   $0x24
  800c8b:	68 01 13 80 00       	push   $0x801301
  800c90:	e8 e8 00 00 00       	call   800d7d <_panic>

00800c95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cae:	89 df                	mov    %ebx,%edi
  800cb0:	89 de                	mov    %ebx,%esi
  800cb2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	7f 08                	jg     800cc0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	83 ec 0c             	sub    $0xc,%esp
  800cc3:	50                   	push   %eax
  800cc4:	6a 08                	push   $0x8
  800cc6:	68 e4 12 80 00       	push   $0x8012e4
  800ccb:	6a 24                	push   $0x24
  800ccd:	68 01 13 80 00       	push   $0x801301
  800cd2:	e8 a6 00 00 00       	call   800d7d <_panic>

00800cd7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ce0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	89 de                	mov    %ebx,%esi
  800cf4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	50                   	push   %eax
  800d06:	6a 09                	push   $0x9
  800d08:	68 e4 12 80 00       	push   $0x8012e4
  800d0d:	6a 24                	push   $0x24
  800d0f:	68 01 13 80 00       	push   $0x801301
  800d14:	e8 64 00 00 00       	call   800d7d <_panic>

00800d19 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2a:	be 00 00 00 00       	mov    $0x0,%esi
  800d2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d35:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d52:	89 cb                	mov    %ecx,%ebx
  800d54:	89 cf                	mov    %ecx,%edi
  800d56:	89 ce                	mov    %ecx,%esi
  800d58:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d5a:	85 c0                	test   %eax,%eax
  800d5c:	7f 08                	jg     800d66 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d66:	83 ec 0c             	sub    $0xc,%esp
  800d69:	50                   	push   %eax
  800d6a:	6a 0c                	push   $0xc
  800d6c:	68 e4 12 80 00       	push   $0x8012e4
  800d71:	6a 24                	push   $0x24
  800d73:	68 01 13 80 00       	push   $0x801301
  800d78:	e8 00 00 00 00       	call   800d7d <_panic>

00800d7d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d82:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d85:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d8b:	e8 00 fe ff ff       	call   800b90 <sys_getenvid>
  800d90:	83 ec 0c             	sub    $0xc,%esp
  800d93:	ff 75 0c             	pushl  0xc(%ebp)
  800d96:	ff 75 08             	pushl  0x8(%ebp)
  800d99:	56                   	push   %esi
  800d9a:	50                   	push   %eax
  800d9b:	68 10 13 80 00       	push   $0x801310
  800da0:	e8 d2 f3 ff ff       	call   800177 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800da5:	83 c4 18             	add    $0x18,%esp
  800da8:	53                   	push   %ebx
  800da9:	ff 75 10             	pushl  0x10(%ebp)
  800dac:	e8 75 f3 ff ff       	call   800126 <vcprintf>
	cprintf("\n");
  800db1:	c7 04 24 34 13 80 00 	movl   $0x801334,(%esp)
  800db8:	e8 ba f3 ff ff       	call   800177 <cprintf>
  800dbd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800dc0:	cc                   	int3   
  800dc1:	eb fd                	jmp    800dc0 <_panic+0x43>
  800dc3:	66 90                	xchg   %ax,%ax
  800dc5:	66 90                	xchg   %ax,%ax
  800dc7:	66 90                	xchg   %ax,%ax
  800dc9:	66 90                	xchg   %ax,%ax
  800dcb:	66 90                	xchg   %ax,%ax
  800dcd:	66 90                	xchg   %ax,%ax
  800dcf:	90                   	nop

00800dd0 <__udivdi3>:
  800dd0:	55                   	push   %ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 1c             	sub    $0x1c,%esp
  800dd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800ddb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ddf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800de3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800de7:	85 d2                	test   %edx,%edx
  800de9:	75 35                	jne    800e20 <__udivdi3+0x50>
  800deb:	39 f3                	cmp    %esi,%ebx
  800ded:	0f 87 bd 00 00 00    	ja     800eb0 <__udivdi3+0xe0>
  800df3:	85 db                	test   %ebx,%ebx
  800df5:	89 d9                	mov    %ebx,%ecx
  800df7:	75 0b                	jne    800e04 <__udivdi3+0x34>
  800df9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dfe:	31 d2                	xor    %edx,%edx
  800e00:	f7 f3                	div    %ebx
  800e02:	89 c1                	mov    %eax,%ecx
  800e04:	31 d2                	xor    %edx,%edx
  800e06:	89 f0                	mov    %esi,%eax
  800e08:	f7 f1                	div    %ecx
  800e0a:	89 c6                	mov    %eax,%esi
  800e0c:	89 e8                	mov    %ebp,%eax
  800e0e:	89 f7                	mov    %esi,%edi
  800e10:	f7 f1                	div    %ecx
  800e12:	89 fa                	mov    %edi,%edx
  800e14:	83 c4 1c             	add    $0x1c,%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    
  800e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e20:	39 f2                	cmp    %esi,%edx
  800e22:	77 7c                	ja     800ea0 <__udivdi3+0xd0>
  800e24:	0f bd fa             	bsr    %edx,%edi
  800e27:	83 f7 1f             	xor    $0x1f,%edi
  800e2a:	0f 84 98 00 00 00    	je     800ec8 <__udivdi3+0xf8>
  800e30:	89 f9                	mov    %edi,%ecx
  800e32:	b8 20 00 00 00       	mov    $0x20,%eax
  800e37:	29 f8                	sub    %edi,%eax
  800e39:	d3 e2                	shl    %cl,%edx
  800e3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e3f:	89 c1                	mov    %eax,%ecx
  800e41:	89 da                	mov    %ebx,%edx
  800e43:	d3 ea                	shr    %cl,%edx
  800e45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e49:	09 d1                	or     %edx,%ecx
  800e4b:	89 f2                	mov    %esi,%edx
  800e4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e51:	89 f9                	mov    %edi,%ecx
  800e53:	d3 e3                	shl    %cl,%ebx
  800e55:	89 c1                	mov    %eax,%ecx
  800e57:	d3 ea                	shr    %cl,%edx
  800e59:	89 f9                	mov    %edi,%ecx
  800e5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e5f:	d3 e6                	shl    %cl,%esi
  800e61:	89 eb                	mov    %ebp,%ebx
  800e63:	89 c1                	mov    %eax,%ecx
  800e65:	d3 eb                	shr    %cl,%ebx
  800e67:	09 de                	or     %ebx,%esi
  800e69:	89 f0                	mov    %esi,%eax
  800e6b:	f7 74 24 08          	divl   0x8(%esp)
  800e6f:	89 d6                	mov    %edx,%esi
  800e71:	89 c3                	mov    %eax,%ebx
  800e73:	f7 64 24 0c          	mull   0xc(%esp)
  800e77:	39 d6                	cmp    %edx,%esi
  800e79:	72 0c                	jb     800e87 <__udivdi3+0xb7>
  800e7b:	89 f9                	mov    %edi,%ecx
  800e7d:	d3 e5                	shl    %cl,%ebp
  800e7f:	39 c5                	cmp    %eax,%ebp
  800e81:	73 5d                	jae    800ee0 <__udivdi3+0x110>
  800e83:	39 d6                	cmp    %edx,%esi
  800e85:	75 59                	jne    800ee0 <__udivdi3+0x110>
  800e87:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e8a:	31 ff                	xor    %edi,%edi
  800e8c:	89 fa                	mov    %edi,%edx
  800e8e:	83 c4 1c             	add    $0x1c,%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
  800e96:	8d 76 00             	lea    0x0(%esi),%esi
  800e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ea0:	31 ff                	xor    %edi,%edi
  800ea2:	31 c0                	xor    %eax,%eax
  800ea4:	89 fa                	mov    %edi,%edx
  800ea6:	83 c4 1c             	add    $0x1c,%esp
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    
  800eae:	66 90                	xchg   %ax,%ax
  800eb0:	31 ff                	xor    %edi,%edi
  800eb2:	89 e8                	mov    %ebp,%eax
  800eb4:	89 f2                	mov    %esi,%edx
  800eb6:	f7 f3                	div    %ebx
  800eb8:	89 fa                	mov    %edi,%edx
  800eba:	83 c4 1c             	add    $0x1c,%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    
  800ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ec8:	39 f2                	cmp    %esi,%edx
  800eca:	72 06                	jb     800ed2 <__udivdi3+0x102>
  800ecc:	31 c0                	xor    %eax,%eax
  800ece:	39 eb                	cmp    %ebp,%ebx
  800ed0:	77 d2                	ja     800ea4 <__udivdi3+0xd4>
  800ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ed7:	eb cb                	jmp    800ea4 <__udivdi3+0xd4>
  800ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ee0:	89 d8                	mov    %ebx,%eax
  800ee2:	31 ff                	xor    %edi,%edi
  800ee4:	eb be                	jmp    800ea4 <__udivdi3+0xd4>
  800ee6:	66 90                	xchg   %ax,%ax
  800ee8:	66 90                	xchg   %ax,%ax
  800eea:	66 90                	xchg   %ax,%ax
  800eec:	66 90                	xchg   %ax,%ax
  800eee:	66 90                	xchg   %ax,%ax

00800ef0 <__umoddi3>:
  800ef0:	55                   	push   %ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 1c             	sub    $0x1c,%esp
  800ef7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800efb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800eff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f07:	85 ed                	test   %ebp,%ebp
  800f09:	89 f0                	mov    %esi,%eax
  800f0b:	89 da                	mov    %ebx,%edx
  800f0d:	75 19                	jne    800f28 <__umoddi3+0x38>
  800f0f:	39 df                	cmp    %ebx,%edi
  800f11:	0f 86 b1 00 00 00    	jbe    800fc8 <__umoddi3+0xd8>
  800f17:	f7 f7                	div    %edi
  800f19:	89 d0                	mov    %edx,%eax
  800f1b:	31 d2                	xor    %edx,%edx
  800f1d:	83 c4 1c             	add    $0x1c,%esp
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    
  800f25:	8d 76 00             	lea    0x0(%esi),%esi
  800f28:	39 dd                	cmp    %ebx,%ebp
  800f2a:	77 f1                	ja     800f1d <__umoddi3+0x2d>
  800f2c:	0f bd cd             	bsr    %ebp,%ecx
  800f2f:	83 f1 1f             	xor    $0x1f,%ecx
  800f32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f36:	0f 84 b4 00 00 00    	je     800ff0 <__umoddi3+0x100>
  800f3c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f41:	89 c2                	mov    %eax,%edx
  800f43:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f47:	29 c2                	sub    %eax,%edx
  800f49:	89 c1                	mov    %eax,%ecx
  800f4b:	89 f8                	mov    %edi,%eax
  800f4d:	d3 e5                	shl    %cl,%ebp
  800f4f:	89 d1                	mov    %edx,%ecx
  800f51:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f55:	d3 e8                	shr    %cl,%eax
  800f57:	09 c5                	or     %eax,%ebp
  800f59:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f5d:	89 c1                	mov    %eax,%ecx
  800f5f:	d3 e7                	shl    %cl,%edi
  800f61:	89 d1                	mov    %edx,%ecx
  800f63:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f67:	89 df                	mov    %ebx,%edi
  800f69:	d3 ef                	shr    %cl,%edi
  800f6b:	89 c1                	mov    %eax,%ecx
  800f6d:	89 f0                	mov    %esi,%eax
  800f6f:	d3 e3                	shl    %cl,%ebx
  800f71:	89 d1                	mov    %edx,%ecx
  800f73:	89 fa                	mov    %edi,%edx
  800f75:	d3 e8                	shr    %cl,%eax
  800f77:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f7c:	09 d8                	or     %ebx,%eax
  800f7e:	f7 f5                	div    %ebp
  800f80:	d3 e6                	shl    %cl,%esi
  800f82:	89 d1                	mov    %edx,%ecx
  800f84:	f7 64 24 08          	mull   0x8(%esp)
  800f88:	39 d1                	cmp    %edx,%ecx
  800f8a:	89 c3                	mov    %eax,%ebx
  800f8c:	89 d7                	mov    %edx,%edi
  800f8e:	72 06                	jb     800f96 <__umoddi3+0xa6>
  800f90:	75 0e                	jne    800fa0 <__umoddi3+0xb0>
  800f92:	39 c6                	cmp    %eax,%esi
  800f94:	73 0a                	jae    800fa0 <__umoddi3+0xb0>
  800f96:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f9a:	19 ea                	sbb    %ebp,%edx
  800f9c:	89 d7                	mov    %edx,%edi
  800f9e:	89 c3                	mov    %eax,%ebx
  800fa0:	89 ca                	mov    %ecx,%edx
  800fa2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800fa7:	29 de                	sub    %ebx,%esi
  800fa9:	19 fa                	sbb    %edi,%edx
  800fab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800faf:	89 d0                	mov    %edx,%eax
  800fb1:	d3 e0                	shl    %cl,%eax
  800fb3:	89 d9                	mov    %ebx,%ecx
  800fb5:	d3 ee                	shr    %cl,%esi
  800fb7:	d3 ea                	shr    %cl,%edx
  800fb9:	09 f0                	or     %esi,%eax
  800fbb:	83 c4 1c             	add    $0x1c,%esp
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    
  800fc3:	90                   	nop
  800fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	85 ff                	test   %edi,%edi
  800fca:	89 f9                	mov    %edi,%ecx
  800fcc:	75 0b                	jne    800fd9 <__umoddi3+0xe9>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f7                	div    %edi
  800fd7:	89 c1                	mov    %eax,%ecx
  800fd9:	89 d8                	mov    %ebx,%eax
  800fdb:	31 d2                	xor    %edx,%edx
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 f0                	mov    %esi,%eax
  800fe1:	f7 f1                	div    %ecx
  800fe3:	e9 31 ff ff ff       	jmp    800f19 <__umoddi3+0x29>
  800fe8:	90                   	nop
  800fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff0:	39 dd                	cmp    %ebx,%ebp
  800ff2:	72 08                	jb     800ffc <__umoddi3+0x10c>
  800ff4:	39 f7                	cmp    %esi,%edi
  800ff6:	0f 87 21 ff ff ff    	ja     800f1d <__umoddi3+0x2d>
  800ffc:	89 da                	mov    %ebx,%edx
  800ffe:	89 f0                	mov    %esi,%eax
  801000:	29 f8                	sub    %edi,%eax
  801002:	19 ea                	sbb    %ebp,%edx
  801004:	e9 14 ff ff ff       	jmp    800f1d <__umoddi3+0x2d>
