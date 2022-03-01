
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
  800048:	e8 3a 01 00 00       	call   800187 <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 65 0b 00 00       	call   800bbf <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 40 10 80 00       	push   $0x801040
  80006c:	e8 16 01 00 00       	call   800187 <cprintf>
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
  80008d:	e8 f5 00 00 00       	call   800187 <cprintf>
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
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 f6 0a 00 00       	call   800ba0 <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b7:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x2d>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
  8000cc:	e8 62 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d1:	e8 0a 00 00 00       	call   8000e0 <exit>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000e6:	6a 00                	push   $0x0
  8000e8:	e8 72 0a 00 00       	call   800b5f <sys_env_destroy>
}
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	53                   	push   %ebx
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fc:	8b 13                	mov    (%ebx),%edx
  8000fe:	8d 42 01             	lea    0x1(%edx),%eax
  800101:	89 03                	mov    %eax,(%ebx)
  800103:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800106:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80010f:	74 09                	je     80011a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800111:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800118:	c9                   	leave  
  800119:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011a:	83 ec 08             	sub    $0x8,%esp
  80011d:	68 ff 00 00 00       	push   $0xff
  800122:	8d 43 08             	lea    0x8(%ebx),%eax
  800125:	50                   	push   %eax
  800126:	e8 f7 09 00 00       	call   800b22 <sys_cputs>
		b->idx = 0;
  80012b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	eb db                	jmp    800111 <putch+0x1f>

00800136 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80013f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800146:	00 00 00 
	b.cnt = 0;
  800149:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800150:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80015f:	50                   	push   %eax
  800160:	68 f2 00 80 00       	push   $0x8000f2
  800165:	e8 1a 01 00 00       	call   800284 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016a:	83 c4 08             	add    $0x8,%esp
  80016d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800173:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	e8 a3 09 00 00       	call   800b22 <sys_cputs>

	return b.cnt;
}
  80017f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80018d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800190:	50                   	push   %eax
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9d ff ff ff       	call   800136 <vcprintf>
	va_end(ap);

	return cnt;
}
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	57                   	push   %edi
  80019f:	56                   	push   %esi
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 1c             	sub    $0x1c,%esp
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	89 d6                	mov    %edx,%esi
  8001a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001bc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001bf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001c2:	39 d3                	cmp    %edx,%ebx
  8001c4:	72 05                	jb     8001cb <printnum+0x30>
  8001c6:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001c9:	77 7a                	ja     800245 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 18             	pushl  0x18(%ebp)
  8001d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8001d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001d7:	53                   	push   %ebx
  8001d8:	ff 75 10             	pushl  0x10(%ebp)
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ea:	e8 f1 0b 00 00       	call   800de0 <__udivdi3>
  8001ef:	83 c4 18             	add    $0x18,%esp
  8001f2:	52                   	push   %edx
  8001f3:	50                   	push   %eax
  8001f4:	89 f2                	mov    %esi,%edx
  8001f6:	89 f8                	mov    %edi,%eax
  8001f8:	e8 9e ff ff ff       	call   80019b <printnum>
  8001fd:	83 c4 20             	add    $0x20,%esp
  800200:	eb 13                	jmp    800215 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	56                   	push   %esi
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	ff d7                	call   *%edi
  80020b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80020e:	83 eb 01             	sub    $0x1,%ebx
  800211:	85 db                	test   %ebx,%ebx
  800213:	7f ed                	jg     800202 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	56                   	push   %esi
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021f:	ff 75 e0             	pushl  -0x20(%ebp)
  800222:	ff 75 dc             	pushl  -0x24(%ebp)
  800225:	ff 75 d8             	pushl  -0x28(%ebp)
  800228:	e8 d3 0c 00 00       	call   800f00 <__umoddi3>
  80022d:	83 c4 14             	add    $0x14,%esp
  800230:	0f be 80 95 10 80 00 	movsbl 0x801095(%eax),%eax
  800237:	50                   	push   %eax
  800238:	ff d7                	call   *%edi
}
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800240:	5b                   	pop    %ebx
  800241:	5e                   	pop    %esi
  800242:	5f                   	pop    %edi
  800243:	5d                   	pop    %ebp
  800244:	c3                   	ret    
  800245:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800248:	eb c4                	jmp    80020e <printnum+0x73>

0080024a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800250:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800254:	8b 10                	mov    (%eax),%edx
  800256:	3b 50 04             	cmp    0x4(%eax),%edx
  800259:	73 0a                	jae    800265 <sprintputch+0x1b>
		*b->buf++ = ch;
  80025b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80025e:	89 08                	mov    %ecx,(%eax)
  800260:	8b 45 08             	mov    0x8(%ebp),%eax
  800263:	88 02                	mov    %al,(%edx)
}
  800265:	5d                   	pop    %ebp
  800266:	c3                   	ret    

00800267 <printfmt>:
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80026d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800270:	50                   	push   %eax
  800271:	ff 75 10             	pushl  0x10(%ebp)
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	e8 05 00 00 00       	call   800284 <vprintfmt>
}
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <vprintfmt>:
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	57                   	push   %edi
  800288:	56                   	push   %esi
  800289:	53                   	push   %ebx
  80028a:	83 ec 2c             	sub    $0x2c,%esp
  80028d:	8b 75 08             	mov    0x8(%ebp),%esi
  800290:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800293:	8b 7d 10             	mov    0x10(%ebp),%edi
  800296:	e9 00 04 00 00       	jmp    80069b <vprintfmt+0x417>
		padc = ' ';
  80029b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80029f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002a6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b9:	8d 47 01             	lea    0x1(%edi),%eax
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002bf:	0f b6 17             	movzbl (%edi),%edx
  8002c2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c5:	3c 55                	cmp    $0x55,%al
  8002c7:	0f 87 51 04 00 00    	ja     80071e <vprintfmt+0x49a>
  8002cd:	0f b6 c0             	movzbl %al,%eax
  8002d0:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  8002d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002da:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002de:	eb d9                	jmp    8002b9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002e3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002e7:	eb d0                	jmp    8002b9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e9:	0f b6 d2             	movzbl %dl,%edx
  8002ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002f7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fa:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002fe:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800301:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800304:	83 f9 09             	cmp    $0x9,%ecx
  800307:	77 55                	ja     80035e <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800309:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80030c:	eb e9                	jmp    8002f7 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80030e:	8b 45 14             	mov    0x14(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800316:	8b 45 14             	mov    0x14(%ebp),%eax
  800319:	8d 40 04             	lea    0x4(%eax),%eax
  80031c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800322:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800326:	79 91                	jns    8002b9 <vprintfmt+0x35>
				width = precision, precision = -1;
  800328:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80032b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80032e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800335:	eb 82                	jmp    8002b9 <vprintfmt+0x35>
  800337:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	ba 00 00 00 00       	mov    $0x0,%edx
  800341:	0f 49 d0             	cmovns %eax,%edx
  800344:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80034a:	e9 6a ff ff ff       	jmp    8002b9 <vprintfmt+0x35>
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800352:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800359:	e9 5b ff ff ff       	jmp    8002b9 <vprintfmt+0x35>
  80035e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800361:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800364:	eb bc                	jmp    800322 <vprintfmt+0x9e>
			lflag++;
  800366:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800369:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80036c:	e9 48 ff ff ff       	jmp    8002b9 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800371:	8b 45 14             	mov    0x14(%ebp),%eax
  800374:	8d 78 04             	lea    0x4(%eax),%edi
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	53                   	push   %ebx
  80037b:	ff 30                	pushl  (%eax)
  80037d:	ff d6                	call   *%esi
			break;
  80037f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800382:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800385:	e9 0e 03 00 00       	jmp    800698 <vprintfmt+0x414>
			err = va_arg(ap, int);
  80038a:	8b 45 14             	mov    0x14(%ebp),%eax
  80038d:	8d 78 04             	lea    0x4(%eax),%edi
  800390:	8b 00                	mov    (%eax),%eax
  800392:	99                   	cltd   
  800393:	31 d0                	xor    %edx,%eax
  800395:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800397:	83 f8 08             	cmp    $0x8,%eax
  80039a:	7f 23                	jg     8003bf <vprintfmt+0x13b>
  80039c:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  8003a3:	85 d2                	test   %edx,%edx
  8003a5:	74 18                	je     8003bf <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003a7:	52                   	push   %edx
  8003a8:	68 b6 10 80 00       	push   $0x8010b6
  8003ad:	53                   	push   %ebx
  8003ae:	56                   	push   %esi
  8003af:	e8 b3 fe ff ff       	call   800267 <printfmt>
  8003b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003ba:	e9 d9 02 00 00       	jmp    800698 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003bf:	50                   	push   %eax
  8003c0:	68 ad 10 80 00       	push   $0x8010ad
  8003c5:	53                   	push   %ebx
  8003c6:	56                   	push   %esi
  8003c7:	e8 9b fe ff ff       	call   800267 <printfmt>
  8003cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d2:	e9 c1 02 00 00       	jmp    800698 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	83 c0 04             	add    $0x4,%eax
  8003dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003e5:	85 ff                	test   %edi,%edi
  8003e7:	b8 a6 10 80 00       	mov    $0x8010a6,%eax
  8003ec:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f3:	0f 8e bd 00 00 00    	jle    8004b6 <vprintfmt+0x232>
  8003f9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003fd:	75 0e                	jne    80040d <vprintfmt+0x189>
  8003ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800402:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800405:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800408:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80040b:	eb 6d                	jmp    80047a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	ff 75 d0             	pushl  -0x30(%ebp)
  800413:	57                   	push   %edi
  800414:	e8 ad 03 00 00       	call   8007c6 <strnlen>
  800419:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041c:	29 c1                	sub    %eax,%ecx
  80041e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800421:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800424:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800428:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80042e:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800430:	eb 0f                	jmp    800441 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	53                   	push   %ebx
  800436:	ff 75 e0             	pushl  -0x20(%ebp)
  800439:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	83 ef 01             	sub    $0x1,%edi
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	85 ff                	test   %edi,%edi
  800443:	7f ed                	jg     800432 <vprintfmt+0x1ae>
  800445:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800448:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80044b:	85 c9                	test   %ecx,%ecx
  80044d:	b8 00 00 00 00       	mov    $0x0,%eax
  800452:	0f 49 c1             	cmovns %ecx,%eax
  800455:	29 c1                	sub    %eax,%ecx
  800457:	89 75 08             	mov    %esi,0x8(%ebp)
  80045a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80045d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800460:	89 cb                	mov    %ecx,%ebx
  800462:	eb 16                	jmp    80047a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800464:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800468:	75 31                	jne    80049b <vprintfmt+0x217>
					putch(ch, putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	50                   	push   %eax
  800471:	ff 55 08             	call   *0x8(%ebp)
  800474:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800477:	83 eb 01             	sub    $0x1,%ebx
  80047a:	83 c7 01             	add    $0x1,%edi
  80047d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800481:	0f be c2             	movsbl %dl,%eax
  800484:	85 c0                	test   %eax,%eax
  800486:	74 59                	je     8004e1 <vprintfmt+0x25d>
  800488:	85 f6                	test   %esi,%esi
  80048a:	78 d8                	js     800464 <vprintfmt+0x1e0>
  80048c:	83 ee 01             	sub    $0x1,%esi
  80048f:	79 d3                	jns    800464 <vprintfmt+0x1e0>
  800491:	89 df                	mov    %ebx,%edi
  800493:	8b 75 08             	mov    0x8(%ebp),%esi
  800496:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800499:	eb 37                	jmp    8004d2 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80049b:	0f be d2             	movsbl %dl,%edx
  80049e:	83 ea 20             	sub    $0x20,%edx
  8004a1:	83 fa 5e             	cmp    $0x5e,%edx
  8004a4:	76 c4                	jbe    80046a <vprintfmt+0x1e6>
					putch('?', putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ac:	6a 3f                	push   $0x3f
  8004ae:	ff 55 08             	call   *0x8(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	eb c1                	jmp    800477 <vprintfmt+0x1f3>
  8004b6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004bc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004bf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004c2:	eb b6                	jmp    80047a <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	53                   	push   %ebx
  8004c8:	6a 20                	push   $0x20
  8004ca:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004cc:	83 ef 01             	sub    $0x1,%edi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7f ee                	jg     8004c4 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	e9 b7 01 00 00       	jmp    800698 <vprintfmt+0x414>
  8004e1:	89 df                	mov    %ebx,%edi
  8004e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e9:	eb e7                	jmp    8004d2 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004eb:	83 f9 01             	cmp    $0x1,%ecx
  8004ee:	7e 3f                	jle    80052f <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	8b 50 04             	mov    0x4(%eax),%edx
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8d 40 08             	lea    0x8(%eax),%eax
  800504:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800507:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80050b:	79 5c                	jns    800569 <vprintfmt+0x2e5>
				putch('-', putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	6a 2d                	push   $0x2d
  800513:	ff d6                	call   *%esi
				num = -(long long) num;
  800515:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800518:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80051b:	f7 da                	neg    %edx
  80051d:	83 d1 00             	adc    $0x0,%ecx
  800520:	f7 d9                	neg    %ecx
  800522:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800525:	b8 0a 00 00 00       	mov    $0xa,%eax
  80052a:	e9 4f 01 00 00       	jmp    80067e <vprintfmt+0x3fa>
	else if (lflag)
  80052f:	85 c9                	test   %ecx,%ecx
  800531:	75 1b                	jne    80054e <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053b:	89 c1                	mov    %eax,%ecx
  80053d:	c1 f9 1f             	sar    $0x1f,%ecx
  800540:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8d 40 04             	lea    0x4(%eax),%eax
  800549:	89 45 14             	mov    %eax,0x14(%ebp)
  80054c:	eb b9                	jmp    800507 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800556:	89 c1                	mov    %eax,%ecx
  800558:	c1 f9 1f             	sar    $0x1f,%ecx
  80055b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 40 04             	lea    0x4(%eax),%eax
  800564:	89 45 14             	mov    %eax,0x14(%ebp)
  800567:	eb 9e                	jmp    800507 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800569:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800574:	e9 05 01 00 00       	jmp    80067e <vprintfmt+0x3fa>
	if (lflag >= 2)
  800579:	83 f9 01             	cmp    $0x1,%ecx
  80057c:	7e 18                	jle    800596 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8b 10                	mov    (%eax),%edx
  800583:	8b 48 04             	mov    0x4(%eax),%ecx
  800586:	8d 40 08             	lea    0x8(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800591:	e9 e8 00 00 00       	jmp    80067e <vprintfmt+0x3fa>
	else if (lflag)
  800596:	85 c9                	test   %ecx,%ecx
  800598:	75 1a                	jne    8005b4 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 10                	mov    (%eax),%edx
  80059f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005af:	e9 ca 00 00 00       	jmp    80067e <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 10                	mov    (%eax),%edx
  8005b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005be:	8d 40 04             	lea    0x4(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c9:	e9 b0 00 00 00       	jmp    80067e <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005ce:	83 f9 01             	cmp    $0x1,%ecx
  8005d1:	7e 3c                	jle    80060f <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 50 04             	mov    0x4(%eax),%edx
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ee:	79 59                	jns    800649 <vprintfmt+0x3c5>
                putch('-', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2d                	push   $0x2d
  8005f6:	ff d6                	call   *%esi
                num = -(long long) num;
  8005f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005fe:	f7 da                	neg    %edx
  800600:	83 d1 00             	adc    $0x0,%ecx
  800603:	f7 d9                	neg    %ecx
  800605:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800608:	b8 08 00 00 00       	mov    $0x8,%eax
  80060d:	eb 6f                	jmp    80067e <vprintfmt+0x3fa>
	else if (lflag)
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	75 1b                	jne    80062e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 c1                	mov    %eax,%ecx
  80061d:	c1 f9 1f             	sar    $0x1f,%ecx
  800620:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 40 04             	lea    0x4(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
  80062c:	eb bc                	jmp    8005ea <vprintfmt+0x366>
		return va_arg(*ap, long);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	89 c1                	mov    %eax,%ecx
  800638:	c1 f9 1f             	sar    $0x1f,%ecx
  80063b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb a1                	jmp    8005ea <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800649:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80064f:	b8 08 00 00 00       	mov    $0x8,%eax
  800654:	eb 28                	jmp    80067e <vprintfmt+0x3fa>
			putch('0', putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	53                   	push   %ebx
  80065a:	6a 30                	push   $0x30
  80065c:	ff d6                	call   *%esi
			putch('x', putdat);
  80065e:	83 c4 08             	add    $0x8,%esp
  800661:	53                   	push   %ebx
  800662:	6a 78                	push   $0x78
  800664:	ff d6                	call   *%esi
			num = (unsigned long long)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800670:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800679:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80067e:	83 ec 0c             	sub    $0xc,%esp
  800681:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800685:	57                   	push   %edi
  800686:	ff 75 e0             	pushl  -0x20(%ebp)
  800689:	50                   	push   %eax
  80068a:	51                   	push   %ecx
  80068b:	52                   	push   %edx
  80068c:	89 da                	mov    %ebx,%edx
  80068e:	89 f0                	mov    %esi,%eax
  800690:	e8 06 fb ff ff       	call   80019b <printnum>
			break;
  800695:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800698:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069b:	83 c7 01             	add    $0x1,%edi
  80069e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a2:	83 f8 25             	cmp    $0x25,%eax
  8006a5:	0f 84 f0 fb ff ff    	je     80029b <vprintfmt+0x17>
			if (ch == '\0')
  8006ab:	85 c0                	test   %eax,%eax
  8006ad:	0f 84 8b 00 00 00    	je     80073e <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	50                   	push   %eax
  8006b8:	ff d6                	call   *%esi
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	eb dc                	jmp    80069b <vprintfmt+0x417>
	if (lflag >= 2)
  8006bf:	83 f9 01             	cmp    $0x1,%ecx
  8006c2:	7e 15                	jle    8006d9 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006cc:	8d 40 08             	lea    0x8(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d7:	eb a5                	jmp    80067e <vprintfmt+0x3fa>
	else if (lflag)
  8006d9:	85 c9                	test   %ecx,%ecx
  8006db:	75 17                	jne    8006f4 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f2:	eb 8a                	jmp    80067e <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 10                	mov    (%eax),%edx
  8006f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800704:	b8 10 00 00 00       	mov    $0x10,%eax
  800709:	e9 70 ff ff ff       	jmp    80067e <vprintfmt+0x3fa>
			putch(ch, putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 25                	push   $0x25
  800714:	ff d6                	call   *%esi
			break;
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	e9 7a ff ff ff       	jmp    800698 <vprintfmt+0x414>
			putch('%', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 25                	push   $0x25
  800724:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	89 f8                	mov    %edi,%eax
  80072b:	eb 03                	jmp    800730 <vprintfmt+0x4ac>
  80072d:	83 e8 01             	sub    $0x1,%eax
  800730:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800734:	75 f7                	jne    80072d <vprintfmt+0x4a9>
  800736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800739:	e9 5a ff ff ff       	jmp    800698 <vprintfmt+0x414>
}
  80073e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800741:	5b                   	pop    %ebx
  800742:	5e                   	pop    %esi
  800743:	5f                   	pop    %edi
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    

00800746 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	83 ec 18             	sub    $0x18,%esp
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800752:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800755:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800759:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80075c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800763:	85 c0                	test   %eax,%eax
  800765:	74 26                	je     80078d <vsnprintf+0x47>
  800767:	85 d2                	test   %edx,%edx
  800769:	7e 22                	jle    80078d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80076b:	ff 75 14             	pushl  0x14(%ebp)
  80076e:	ff 75 10             	pushl  0x10(%ebp)
  800771:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800774:	50                   	push   %eax
  800775:	68 4a 02 80 00       	push   $0x80024a
  80077a:	e8 05 fb ff ff       	call   800284 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800782:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800788:	83 c4 10             	add    $0x10,%esp
}
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    
		return -E_INVAL;
  80078d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800792:	eb f7                	jmp    80078b <vsnprintf+0x45>

00800794 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80079a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80079d:	50                   	push   %eax
  80079e:	ff 75 10             	pushl  0x10(%ebp)
  8007a1:	ff 75 0c             	pushl  0xc(%ebp)
  8007a4:	ff 75 08             	pushl  0x8(%ebp)
  8007a7:	e8 9a ff ff ff       	call   800746 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b9:	eb 03                	jmp    8007be <strlen+0x10>
		n++;
  8007bb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007be:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c2:	75 f7                	jne    8007bb <strlen+0xd>
	return n;
}
  8007c4:	5d                   	pop    %ebp
  8007c5:	c3                   	ret    

008007c6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007cc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d4:	eb 03                	jmp    8007d9 <strnlen+0x13>
		n++;
  8007d6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d9:	39 d0                	cmp    %edx,%eax
  8007db:	74 06                	je     8007e3 <strnlen+0x1d>
  8007dd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007e1:	75 f3                	jne    8007d6 <strnlen+0x10>
	return n;
}
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ef:	89 c2                	mov    %eax,%edx
  8007f1:	83 c1 01             	add    $0x1,%ecx
  8007f4:	83 c2 01             	add    $0x1,%edx
  8007f7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007fb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007fe:	84 db                	test   %bl,%bl
  800800:	75 ef                	jne    8007f1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800802:	5b                   	pop    %ebx
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	53                   	push   %ebx
  800809:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80080c:	53                   	push   %ebx
  80080d:	e8 9c ff ff ff       	call   8007ae <strlen>
  800812:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	01 d8                	add    %ebx,%eax
  80081a:	50                   	push   %eax
  80081b:	e8 c5 ff ff ff       	call   8007e5 <strcpy>
	return dst;
}
  800820:	89 d8                	mov    %ebx,%eax
  800822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	56                   	push   %esi
  80082b:	53                   	push   %ebx
  80082c:	8b 75 08             	mov    0x8(%ebp),%esi
  80082f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800832:	89 f3                	mov    %esi,%ebx
  800834:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800837:	89 f2                	mov    %esi,%edx
  800839:	eb 0f                	jmp    80084a <strncpy+0x23>
		*dst++ = *src;
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	0f b6 01             	movzbl (%ecx),%eax
  800841:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800844:	80 39 01             	cmpb   $0x1,(%ecx)
  800847:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80084a:	39 da                	cmp    %ebx,%edx
  80084c:	75 ed                	jne    80083b <strncpy+0x14>
	}
	return ret;
}
  80084e:	89 f0                	mov    %esi,%eax
  800850:	5b                   	pop    %ebx
  800851:	5e                   	pop    %esi
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	56                   	push   %esi
  800858:	53                   	push   %ebx
  800859:	8b 75 08             	mov    0x8(%ebp),%esi
  80085c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800862:	89 f0                	mov    %esi,%eax
  800864:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800868:	85 c9                	test   %ecx,%ecx
  80086a:	75 0b                	jne    800877 <strlcpy+0x23>
  80086c:	eb 17                	jmp    800885 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80086e:	83 c2 01             	add    $0x1,%edx
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800877:	39 d8                	cmp    %ebx,%eax
  800879:	74 07                	je     800882 <strlcpy+0x2e>
  80087b:	0f b6 0a             	movzbl (%edx),%ecx
  80087e:	84 c9                	test   %cl,%cl
  800880:	75 ec                	jne    80086e <strlcpy+0x1a>
		*dst = '\0';
  800882:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800885:	29 f0                	sub    %esi,%eax
}
  800887:	5b                   	pop    %ebx
  800888:	5e                   	pop    %esi
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800894:	eb 06                	jmp    80089c <strcmp+0x11>
		p++, q++;
  800896:	83 c1 01             	add    $0x1,%ecx
  800899:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80089c:	0f b6 01             	movzbl (%ecx),%eax
  80089f:	84 c0                	test   %al,%al
  8008a1:	74 04                	je     8008a7 <strcmp+0x1c>
  8008a3:	3a 02                	cmp    (%edx),%al
  8008a5:	74 ef                	je     800896 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a7:	0f b6 c0             	movzbl %al,%eax
  8008aa:	0f b6 12             	movzbl (%edx),%edx
  8008ad:	29 d0                	sub    %edx,%eax
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	53                   	push   %ebx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bb:	89 c3                	mov    %eax,%ebx
  8008bd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c0:	eb 06                	jmp    8008c8 <strncmp+0x17>
		n--, p++, q++;
  8008c2:	83 c0 01             	add    $0x1,%eax
  8008c5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008c8:	39 d8                	cmp    %ebx,%eax
  8008ca:	74 16                	je     8008e2 <strncmp+0x31>
  8008cc:	0f b6 08             	movzbl (%eax),%ecx
  8008cf:	84 c9                	test   %cl,%cl
  8008d1:	74 04                	je     8008d7 <strncmp+0x26>
  8008d3:	3a 0a                	cmp    (%edx),%cl
  8008d5:	74 eb                	je     8008c2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d7:	0f b6 00             	movzbl (%eax),%eax
  8008da:	0f b6 12             	movzbl (%edx),%edx
  8008dd:	29 d0                	sub    %edx,%eax
}
  8008df:	5b                   	pop    %ebx
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    
		return 0;
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e7:	eb f6                	jmp    8008df <strncmp+0x2e>

008008e9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f3:	0f b6 10             	movzbl (%eax),%edx
  8008f6:	84 d2                	test   %dl,%dl
  8008f8:	74 09                	je     800903 <strchr+0x1a>
		if (*s == c)
  8008fa:	38 ca                	cmp    %cl,%dl
  8008fc:	74 0a                	je     800908 <strchr+0x1f>
	for (; *s; s++)
  8008fe:	83 c0 01             	add    $0x1,%eax
  800901:	eb f0                	jmp    8008f3 <strchr+0xa>
			return (char *) s;
	return 0;
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800914:	eb 03                	jmp    800919 <strfind+0xf>
  800916:	83 c0 01             	add    $0x1,%eax
  800919:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80091c:	38 ca                	cmp    %cl,%dl
  80091e:	74 04                	je     800924 <strfind+0x1a>
  800920:	84 d2                	test   %dl,%dl
  800922:	75 f2                	jne    800916 <strfind+0xc>
			break;
	return (char *) s;
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	57                   	push   %edi
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800932:	85 c9                	test   %ecx,%ecx
  800934:	74 13                	je     800949 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800936:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80093c:	75 05                	jne    800943 <memset+0x1d>
  80093e:	f6 c1 03             	test   $0x3,%cl
  800941:	74 0d                	je     800950 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	fc                   	cld    
  800947:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800949:	89 f8                	mov    %edi,%eax
  80094b:	5b                   	pop    %ebx
  80094c:	5e                   	pop    %esi
  80094d:	5f                   	pop    %edi
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    
		c &= 0xFF;
  800950:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800954:	89 d3                	mov    %edx,%ebx
  800956:	c1 e3 08             	shl    $0x8,%ebx
  800959:	89 d0                	mov    %edx,%eax
  80095b:	c1 e0 18             	shl    $0x18,%eax
  80095e:	89 d6                	mov    %edx,%esi
  800960:	c1 e6 10             	shl    $0x10,%esi
  800963:	09 f0                	or     %esi,%eax
  800965:	09 c2                	or     %eax,%edx
  800967:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800969:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096c:	89 d0                	mov    %edx,%eax
  80096e:	fc                   	cld    
  80096f:	f3 ab                	rep stos %eax,%es:(%edi)
  800971:	eb d6                	jmp    800949 <memset+0x23>

00800973 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	57                   	push   %edi
  800977:	56                   	push   %esi
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800981:	39 c6                	cmp    %eax,%esi
  800983:	73 35                	jae    8009ba <memmove+0x47>
  800985:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800988:	39 c2                	cmp    %eax,%edx
  80098a:	76 2e                	jbe    8009ba <memmove+0x47>
		s += n;
		d += n;
  80098c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098f:	89 d6                	mov    %edx,%esi
  800991:	09 fe                	or     %edi,%esi
  800993:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800999:	74 0c                	je     8009a7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099b:	83 ef 01             	sub    $0x1,%edi
  80099e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009a1:	fd                   	std    
  8009a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a4:	fc                   	cld    
  8009a5:	eb 21                	jmp    8009c8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a7:	f6 c1 03             	test   $0x3,%cl
  8009aa:	75 ef                	jne    80099b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009ac:	83 ef 04             	sub    $0x4,%edi
  8009af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b8:	eb ea                	jmp    8009a4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ba:	89 f2                	mov    %esi,%edx
  8009bc:	09 c2                	or     %eax,%edx
  8009be:	f6 c2 03             	test   $0x3,%dl
  8009c1:	74 09                	je     8009cc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c3:	89 c7                	mov    %eax,%edi
  8009c5:	fc                   	cld    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cc:	f6 c1 03             	test   $0x3,%cl
  8009cf:	75 f2                	jne    8009c3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d4:	89 c7                	mov    %eax,%edi
  8009d6:	fc                   	cld    
  8009d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d9:	eb ed                	jmp    8009c8 <memmove+0x55>

008009db <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009de:	ff 75 10             	pushl  0x10(%ebp)
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	ff 75 08             	pushl  0x8(%ebp)
  8009e7:	e8 87 ff ff ff       	call   800973 <memmove>
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f9:	89 c6                	mov    %eax,%esi
  8009fb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fe:	39 f0                	cmp    %esi,%eax
  800a00:	74 1c                	je     800a1e <memcmp+0x30>
		if (*s1 != *s2)
  800a02:	0f b6 08             	movzbl (%eax),%ecx
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	38 d9                	cmp    %bl,%cl
  800a0a:	75 08                	jne    800a14 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	eb ea                	jmp    8009fe <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a14:	0f b6 c1             	movzbl %cl,%eax
  800a17:	0f b6 db             	movzbl %bl,%ebx
  800a1a:	29 d8                	sub    %ebx,%eax
  800a1c:	eb 05                	jmp    800a23 <memcmp+0x35>
	}

	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5b                   	pop    %ebx
  800a24:	5e                   	pop    %esi
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a30:	89 c2                	mov    %eax,%edx
  800a32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a35:	39 d0                	cmp    %edx,%eax
  800a37:	73 09                	jae    800a42 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a39:	38 08                	cmp    %cl,(%eax)
  800a3b:	74 05                	je     800a42 <memfind+0x1b>
	for (; s < ends; s++)
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	eb f3                	jmp    800a35 <memfind+0xe>
			break;
	return (void *) s;
}
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	57                   	push   %edi
  800a48:	56                   	push   %esi
  800a49:	53                   	push   %ebx
  800a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a50:	eb 03                	jmp    800a55 <strtol+0x11>
		s++;
  800a52:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a55:	0f b6 01             	movzbl (%ecx),%eax
  800a58:	3c 20                	cmp    $0x20,%al
  800a5a:	74 f6                	je     800a52 <strtol+0xe>
  800a5c:	3c 09                	cmp    $0x9,%al
  800a5e:	74 f2                	je     800a52 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a60:	3c 2b                	cmp    $0x2b,%al
  800a62:	74 2e                	je     800a92 <strtol+0x4e>
	int neg = 0;
  800a64:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a69:	3c 2d                	cmp    $0x2d,%al
  800a6b:	74 2f                	je     800a9c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a73:	75 05                	jne    800a7a <strtol+0x36>
  800a75:	80 39 30             	cmpb   $0x30,(%ecx)
  800a78:	74 2c                	je     800aa6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a7a:	85 db                	test   %ebx,%ebx
  800a7c:	75 0a                	jne    800a88 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a7e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a83:	80 39 30             	cmpb   $0x30,(%ecx)
  800a86:	74 28                	je     800ab0 <strtol+0x6c>
		base = 10;
  800a88:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a90:	eb 50                	jmp    800ae2 <strtol+0x9e>
		s++;
  800a92:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a95:	bf 00 00 00 00       	mov    $0x0,%edi
  800a9a:	eb d1                	jmp    800a6d <strtol+0x29>
		s++, neg = 1;
  800a9c:	83 c1 01             	add    $0x1,%ecx
  800a9f:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa4:	eb c7                	jmp    800a6d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aaa:	74 0e                	je     800aba <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aac:	85 db                	test   %ebx,%ebx
  800aae:	75 d8                	jne    800a88 <strtol+0x44>
		s++, base = 8;
  800ab0:	83 c1 01             	add    $0x1,%ecx
  800ab3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ab8:	eb ce                	jmp    800a88 <strtol+0x44>
		s += 2, base = 16;
  800aba:	83 c1 02             	add    $0x2,%ecx
  800abd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ac2:	eb c4                	jmp    800a88 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ac4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ac7:	89 f3                	mov    %esi,%ebx
  800ac9:	80 fb 19             	cmp    $0x19,%bl
  800acc:	77 29                	ja     800af7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ace:	0f be d2             	movsbl %dl,%edx
  800ad1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ad4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ad7:	7d 30                	jge    800b09 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad9:	83 c1 01             	add    $0x1,%ecx
  800adc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ae0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ae2:	0f b6 11             	movzbl (%ecx),%edx
  800ae5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ae8:	89 f3                	mov    %esi,%ebx
  800aea:	80 fb 09             	cmp    $0x9,%bl
  800aed:	77 d5                	ja     800ac4 <strtol+0x80>
			dig = *s - '0';
  800aef:	0f be d2             	movsbl %dl,%edx
  800af2:	83 ea 30             	sub    $0x30,%edx
  800af5:	eb dd                	jmp    800ad4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800af7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800afa:	89 f3                	mov    %esi,%ebx
  800afc:	80 fb 19             	cmp    $0x19,%bl
  800aff:	77 08                	ja     800b09 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b01:	0f be d2             	movsbl %dl,%edx
  800b04:	83 ea 37             	sub    $0x37,%edx
  800b07:	eb cb                	jmp    800ad4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0d:	74 05                	je     800b14 <strtol+0xd0>
		*endptr = (char *) s;
  800b0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b12:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b14:	89 c2                	mov    %eax,%edx
  800b16:	f7 da                	neg    %edx
  800b18:	85 ff                	test   %edi,%edi
  800b1a:	0f 45 c2             	cmovne %edx,%eax
}
  800b1d:	5b                   	pop    %ebx
  800b1e:	5e                   	pop    %esi
  800b1f:	5f                   	pop    %edi
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	57                   	push   %edi
  800b26:	56                   	push   %esi
  800b27:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b28:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b33:	89 c3                	mov    %eax,%ebx
  800b35:	89 c7                	mov    %eax,%edi
  800b37:	89 c6                	mov    %eax,%esi
  800b39:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5f                   	pop    %edi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <sys_cgetc>:

int
sys_cgetc(void) {
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	57                   	push   %edi
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b50:	89 d1                	mov    %edx,%ecx
  800b52:	89 d3                	mov    %edx,%ebx
  800b54:	89 d7                	mov    %edx,%edi
  800b56:	89 d6                	mov    %edx,%esi
  800b58:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b5a:	5b                   	pop    %ebx
  800b5b:	5e                   	pop    %esi
  800b5c:	5f                   	pop    %edi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	57                   	push   %edi
  800b63:	56                   	push   %esi
  800b64:	53                   	push   %ebx
  800b65:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b68:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b70:	b8 03 00 00 00       	mov    $0x3,%eax
  800b75:	89 cb                	mov    %ecx,%ebx
  800b77:	89 cf                	mov    %ecx,%edi
  800b79:	89 ce                	mov    %ecx,%esi
  800b7b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	7f 08                	jg     800b89 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5f                   	pop    %edi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b89:	83 ec 0c             	sub    $0xc,%esp
  800b8c:	50                   	push   %eax
  800b8d:	6a 03                	push   $0x3
  800b8f:	68 e4 12 80 00       	push   $0x8012e4
  800b94:	6a 24                	push   $0x24
  800b96:	68 01 13 80 00       	push   $0x801301
  800b9b:	e8 ed 01 00 00       	call   800d8d <_panic>

00800ba0 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bab:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb0:	89 d1                	mov    %edx,%ecx
  800bb2:	89 d3                	mov    %edx,%ebx
  800bb4:	89 d7                	mov    %edx,%edi
  800bb6:	89 d6                	mov    %edx,%esi
  800bb8:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5f                   	pop    %edi
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <sys_yield>:

void
sys_yield(void)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bca:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcf:	89 d1                	mov    %edx,%ecx
  800bd1:	89 d3                	mov    %edx,%ebx
  800bd3:	89 d7                	mov    %edx,%edi
  800bd5:	89 d6                	mov    %edx,%esi
  800bd7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd9:	5b                   	pop    %ebx
  800bda:	5e                   	pop    %esi
  800bdb:	5f                   	pop    %edi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800be7:	be 00 00 00 00       	mov    $0x0,%esi
  800bec:	8b 55 08             	mov    0x8(%ebp),%edx
  800bef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf2:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bfa:	89 f7                	mov    %esi,%edi
  800bfc:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bfe:	85 c0                	test   %eax,%eax
  800c00:	7f 08                	jg     800c0a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	50                   	push   %eax
  800c0e:	6a 04                	push   $0x4
  800c10:	68 e4 12 80 00       	push   $0x8012e4
  800c15:	6a 24                	push   $0x24
  800c17:	68 01 13 80 00       	push   $0x801301
  800c1c:	e8 6c 01 00 00       	call   800d8d <_panic>

00800c21 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
  800c27:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c30:	b8 05 00 00 00       	mov    $0x5,%eax
  800c35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c38:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c3b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c3e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c40:	85 c0                	test   %eax,%eax
  800c42:	7f 08                	jg     800c4c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	50                   	push   %eax
  800c50:	6a 05                	push   $0x5
  800c52:	68 e4 12 80 00       	push   $0x8012e4
  800c57:	6a 24                	push   $0x24
  800c59:	68 01 13 80 00       	push   $0x801301
  800c5e:	e8 2a 01 00 00       	call   800d8d <_panic>

00800c63 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c71:	8b 55 08             	mov    0x8(%ebp),%edx
  800c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c77:	b8 06 00 00 00       	mov    $0x6,%eax
  800c7c:	89 df                	mov    %ebx,%edi
  800c7e:	89 de                	mov    %ebx,%esi
  800c80:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c82:	85 c0                	test   %eax,%eax
  800c84:	7f 08                	jg     800c8e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5f                   	pop    %edi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c8e:	83 ec 0c             	sub    $0xc,%esp
  800c91:	50                   	push   %eax
  800c92:	6a 06                	push   $0x6
  800c94:	68 e4 12 80 00       	push   $0x8012e4
  800c99:	6a 24                	push   $0x24
  800c9b:	68 01 13 80 00       	push   $0x801301
  800ca0:	e8 e8 00 00 00       	call   800d8d <_panic>

00800ca5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cbe:	89 df                	mov    %ebx,%edi
  800cc0:	89 de                	mov    %ebx,%esi
  800cc2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	7f 08                	jg     800cd0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	83 ec 0c             	sub    $0xc,%esp
  800cd3:	50                   	push   %eax
  800cd4:	6a 08                	push   $0x8
  800cd6:	68 e4 12 80 00       	push   $0x8012e4
  800cdb:	6a 24                	push   $0x24
  800cdd:	68 01 13 80 00       	push   $0x801301
  800ce2:	e8 a6 00 00 00       	call   800d8d <_panic>

00800ce7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cf0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	b8 09 00 00 00       	mov    $0x9,%eax
  800d00:	89 df                	mov    %ebx,%edi
  800d02:	89 de                	mov    %ebx,%esi
  800d04:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 09                	push   $0x9
  800d18:	68 e4 12 80 00       	push   $0x8012e4
  800d1d:	6a 24                	push   $0x24
  800d1f:	68 01 13 80 00       	push   $0x801301
  800d24:	e8 64 00 00 00       	call   800d8d <_panic>

00800d29 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d3a:	be 00 00 00 00       	mov    $0x0,%esi
  800d3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d45:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
  800d52:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d62:	89 cb                	mov    %ecx,%ebx
  800d64:	89 cf                	mov    %ecx,%edi
  800d66:	89 ce                	mov    %ecx,%esi
  800d68:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	7f 08                	jg     800d76 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d76:	83 ec 0c             	sub    $0xc,%esp
  800d79:	50                   	push   %eax
  800d7a:	6a 0c                	push   $0xc
  800d7c:	68 e4 12 80 00       	push   $0x8012e4
  800d81:	6a 24                	push   $0x24
  800d83:	68 01 13 80 00       	push   $0x801301
  800d88:	e8 00 00 00 00       	call   800d8d <_panic>

00800d8d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d92:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d95:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d9b:	e8 00 fe ff ff       	call   800ba0 <sys_getenvid>
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	ff 75 0c             	pushl  0xc(%ebp)
  800da6:	ff 75 08             	pushl  0x8(%ebp)
  800da9:	56                   	push   %esi
  800daa:	50                   	push   %eax
  800dab:	68 10 13 80 00       	push   $0x801310
  800db0:	e8 d2 f3 ff ff       	call   800187 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800db5:	83 c4 18             	add    $0x18,%esp
  800db8:	53                   	push   %ebx
  800db9:	ff 75 10             	pushl  0x10(%ebp)
  800dbc:	e8 75 f3 ff ff       	call   800136 <vcprintf>
	cprintf("\n");
  800dc1:	c7 04 24 34 13 80 00 	movl   $0x801334,(%esp)
  800dc8:	e8 ba f3 ff ff       	call   800187 <cprintf>
  800dcd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800dd0:	cc                   	int3   
  800dd1:	eb fd                	jmp    800dd0 <_panic+0x43>
  800dd3:	66 90                	xchg   %ax,%ax
  800dd5:	66 90                	xchg   %ax,%ax
  800dd7:	66 90                	xchg   %ax,%ax
  800dd9:	66 90                	xchg   %ax,%ax
  800ddb:	66 90                	xchg   %ax,%ax
  800ddd:	66 90                	xchg   %ax,%ax
  800ddf:	90                   	nop

00800de0 <__udivdi3>:
  800de0:	55                   	push   %ebp
  800de1:	57                   	push   %edi
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	83 ec 1c             	sub    $0x1c,%esp
  800de7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800deb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800def:	8b 74 24 34          	mov    0x34(%esp),%esi
  800df3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800df7:	85 d2                	test   %edx,%edx
  800df9:	75 35                	jne    800e30 <__udivdi3+0x50>
  800dfb:	39 f3                	cmp    %esi,%ebx
  800dfd:	0f 87 bd 00 00 00    	ja     800ec0 <__udivdi3+0xe0>
  800e03:	85 db                	test   %ebx,%ebx
  800e05:	89 d9                	mov    %ebx,%ecx
  800e07:	75 0b                	jne    800e14 <__udivdi3+0x34>
  800e09:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0e:	31 d2                	xor    %edx,%edx
  800e10:	f7 f3                	div    %ebx
  800e12:	89 c1                	mov    %eax,%ecx
  800e14:	31 d2                	xor    %edx,%edx
  800e16:	89 f0                	mov    %esi,%eax
  800e18:	f7 f1                	div    %ecx
  800e1a:	89 c6                	mov    %eax,%esi
  800e1c:	89 e8                	mov    %ebp,%eax
  800e1e:	89 f7                	mov    %esi,%edi
  800e20:	f7 f1                	div    %ecx
  800e22:	89 fa                	mov    %edi,%edx
  800e24:	83 c4 1c             	add    $0x1c,%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
  800e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e30:	39 f2                	cmp    %esi,%edx
  800e32:	77 7c                	ja     800eb0 <__udivdi3+0xd0>
  800e34:	0f bd fa             	bsr    %edx,%edi
  800e37:	83 f7 1f             	xor    $0x1f,%edi
  800e3a:	0f 84 98 00 00 00    	je     800ed8 <__udivdi3+0xf8>
  800e40:	89 f9                	mov    %edi,%ecx
  800e42:	b8 20 00 00 00       	mov    $0x20,%eax
  800e47:	29 f8                	sub    %edi,%eax
  800e49:	d3 e2                	shl    %cl,%edx
  800e4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e4f:	89 c1                	mov    %eax,%ecx
  800e51:	89 da                	mov    %ebx,%edx
  800e53:	d3 ea                	shr    %cl,%edx
  800e55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e59:	09 d1                	or     %edx,%ecx
  800e5b:	89 f2                	mov    %esi,%edx
  800e5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e61:	89 f9                	mov    %edi,%ecx
  800e63:	d3 e3                	shl    %cl,%ebx
  800e65:	89 c1                	mov    %eax,%ecx
  800e67:	d3 ea                	shr    %cl,%edx
  800e69:	89 f9                	mov    %edi,%ecx
  800e6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e6f:	d3 e6                	shl    %cl,%esi
  800e71:	89 eb                	mov    %ebp,%ebx
  800e73:	89 c1                	mov    %eax,%ecx
  800e75:	d3 eb                	shr    %cl,%ebx
  800e77:	09 de                	or     %ebx,%esi
  800e79:	89 f0                	mov    %esi,%eax
  800e7b:	f7 74 24 08          	divl   0x8(%esp)
  800e7f:	89 d6                	mov    %edx,%esi
  800e81:	89 c3                	mov    %eax,%ebx
  800e83:	f7 64 24 0c          	mull   0xc(%esp)
  800e87:	39 d6                	cmp    %edx,%esi
  800e89:	72 0c                	jb     800e97 <__udivdi3+0xb7>
  800e8b:	89 f9                	mov    %edi,%ecx
  800e8d:	d3 e5                	shl    %cl,%ebp
  800e8f:	39 c5                	cmp    %eax,%ebp
  800e91:	73 5d                	jae    800ef0 <__udivdi3+0x110>
  800e93:	39 d6                	cmp    %edx,%esi
  800e95:	75 59                	jne    800ef0 <__udivdi3+0x110>
  800e97:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e9a:	31 ff                	xor    %edi,%edi
  800e9c:	89 fa                	mov    %edi,%edx
  800e9e:	83 c4 1c             	add    $0x1c,%esp
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    
  800ea6:	8d 76 00             	lea    0x0(%esi),%esi
  800ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800eb0:	31 ff                	xor    %edi,%edi
  800eb2:	31 c0                	xor    %eax,%eax
  800eb4:	89 fa                	mov    %edi,%edx
  800eb6:	83 c4 1c             	add    $0x1c,%esp
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
  800ebe:	66 90                	xchg   %ax,%ax
  800ec0:	31 ff                	xor    %edi,%edi
  800ec2:	89 e8                	mov    %ebp,%eax
  800ec4:	89 f2                	mov    %esi,%edx
  800ec6:	f7 f3                	div    %ebx
  800ec8:	89 fa                	mov    %edi,%edx
  800eca:	83 c4 1c             	add    $0x1c,%esp
  800ecd:	5b                   	pop    %ebx
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    
  800ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ed8:	39 f2                	cmp    %esi,%edx
  800eda:	72 06                	jb     800ee2 <__udivdi3+0x102>
  800edc:	31 c0                	xor    %eax,%eax
  800ede:	39 eb                	cmp    %ebp,%ebx
  800ee0:	77 d2                	ja     800eb4 <__udivdi3+0xd4>
  800ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee7:	eb cb                	jmp    800eb4 <__udivdi3+0xd4>
  800ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef0:	89 d8                	mov    %ebx,%eax
  800ef2:	31 ff                	xor    %edi,%edi
  800ef4:	eb be                	jmp    800eb4 <__udivdi3+0xd4>
  800ef6:	66 90                	xchg   %ax,%ax
  800ef8:	66 90                	xchg   %ax,%ax
  800efa:	66 90                	xchg   %ax,%ax
  800efc:	66 90                	xchg   %ax,%ax
  800efe:	66 90                	xchg   %ax,%ax

00800f00 <__umoddi3>:
  800f00:	55                   	push   %ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 1c             	sub    $0x1c,%esp
  800f07:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f0b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f0f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f17:	85 ed                	test   %ebp,%ebp
  800f19:	89 f0                	mov    %esi,%eax
  800f1b:	89 da                	mov    %ebx,%edx
  800f1d:	75 19                	jne    800f38 <__umoddi3+0x38>
  800f1f:	39 df                	cmp    %ebx,%edi
  800f21:	0f 86 b1 00 00 00    	jbe    800fd8 <__umoddi3+0xd8>
  800f27:	f7 f7                	div    %edi
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	31 d2                	xor    %edx,%edx
  800f2d:	83 c4 1c             	add    $0x1c,%esp
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    
  800f35:	8d 76 00             	lea    0x0(%esi),%esi
  800f38:	39 dd                	cmp    %ebx,%ebp
  800f3a:	77 f1                	ja     800f2d <__umoddi3+0x2d>
  800f3c:	0f bd cd             	bsr    %ebp,%ecx
  800f3f:	83 f1 1f             	xor    $0x1f,%ecx
  800f42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f46:	0f 84 b4 00 00 00    	je     801000 <__umoddi3+0x100>
  800f4c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f51:	89 c2                	mov    %eax,%edx
  800f53:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f57:	29 c2                	sub    %eax,%edx
  800f59:	89 c1                	mov    %eax,%ecx
  800f5b:	89 f8                	mov    %edi,%eax
  800f5d:	d3 e5                	shl    %cl,%ebp
  800f5f:	89 d1                	mov    %edx,%ecx
  800f61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f65:	d3 e8                	shr    %cl,%eax
  800f67:	09 c5                	or     %eax,%ebp
  800f69:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f6d:	89 c1                	mov    %eax,%ecx
  800f6f:	d3 e7                	shl    %cl,%edi
  800f71:	89 d1                	mov    %edx,%ecx
  800f73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f77:	89 df                	mov    %ebx,%edi
  800f79:	d3 ef                	shr    %cl,%edi
  800f7b:	89 c1                	mov    %eax,%ecx
  800f7d:	89 f0                	mov    %esi,%eax
  800f7f:	d3 e3                	shl    %cl,%ebx
  800f81:	89 d1                	mov    %edx,%ecx
  800f83:	89 fa                	mov    %edi,%edx
  800f85:	d3 e8                	shr    %cl,%eax
  800f87:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f8c:	09 d8                	or     %ebx,%eax
  800f8e:	f7 f5                	div    %ebp
  800f90:	d3 e6                	shl    %cl,%esi
  800f92:	89 d1                	mov    %edx,%ecx
  800f94:	f7 64 24 08          	mull   0x8(%esp)
  800f98:	39 d1                	cmp    %edx,%ecx
  800f9a:	89 c3                	mov    %eax,%ebx
  800f9c:	89 d7                	mov    %edx,%edi
  800f9e:	72 06                	jb     800fa6 <__umoddi3+0xa6>
  800fa0:	75 0e                	jne    800fb0 <__umoddi3+0xb0>
  800fa2:	39 c6                	cmp    %eax,%esi
  800fa4:	73 0a                	jae    800fb0 <__umoddi3+0xb0>
  800fa6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800faa:	19 ea                	sbb    %ebp,%edx
  800fac:	89 d7                	mov    %edx,%edi
  800fae:	89 c3                	mov    %eax,%ebx
  800fb0:	89 ca                	mov    %ecx,%edx
  800fb2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800fb7:	29 de                	sub    %ebx,%esi
  800fb9:	19 fa                	sbb    %edi,%edx
  800fbb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800fbf:	89 d0                	mov    %edx,%eax
  800fc1:	d3 e0                	shl    %cl,%eax
  800fc3:	89 d9                	mov    %ebx,%ecx
  800fc5:	d3 ee                	shr    %cl,%esi
  800fc7:	d3 ea                	shr    %cl,%edx
  800fc9:	09 f0                	or     %esi,%eax
  800fcb:	83 c4 1c             	add    $0x1c,%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    
  800fd3:	90                   	nop
  800fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	85 ff                	test   %edi,%edi
  800fda:	89 f9                	mov    %edi,%ecx
  800fdc:	75 0b                	jne    800fe9 <__umoddi3+0xe9>
  800fde:	b8 01 00 00 00       	mov    $0x1,%eax
  800fe3:	31 d2                	xor    %edx,%edx
  800fe5:	f7 f7                	div    %edi
  800fe7:	89 c1                	mov    %eax,%ecx
  800fe9:	89 d8                	mov    %ebx,%eax
  800feb:	31 d2                	xor    %edx,%edx
  800fed:	f7 f1                	div    %ecx
  800fef:	89 f0                	mov    %esi,%eax
  800ff1:	f7 f1                	div    %ecx
  800ff3:	e9 31 ff ff ff       	jmp    800f29 <__umoddi3+0x29>
  800ff8:	90                   	nop
  800ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801000:	39 dd                	cmp    %ebx,%ebp
  801002:	72 08                	jb     80100c <__umoddi3+0x10c>
  801004:	39 f7                	cmp    %esi,%edi
  801006:	0f 87 21 ff ff ff    	ja     800f2d <__umoddi3+0x2d>
  80100c:	89 da                	mov    %ebx,%edx
  80100e:	89 f0                	mov    %esi,%eax
  801010:	29 f8                	sub    %edi,%eax
  801012:	19 ea                	sbb    %ebp,%edx
  801014:	e9 14 ff ff ff       	jmp    800f2d <__umoddi3+0x2d>
