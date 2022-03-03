
obj/user/faultdie：     文件格式 elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 80 10 80 00       	push   $0x801080
  80004a:	e8 1e 01 00 00       	call   80016d <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 32 0b 00 00       	call   800b86 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 e9 0a 00 00       	call   800b45 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 02 0d 00 00       	call   800d73 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 f6 0a 00 00       	call   800b86 <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009d:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	85 db                	test   %ebx,%ebx
  8000a4:	7e 07                	jle    8000ad <libmain+0x2d>
		binaryname = argv[0];
  8000a6:	8b 06                	mov    (%esi),%eax
  8000a8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
  8000b2:	e8 aa ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0a 00 00 00       	call   8000c6 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000cc:	6a 00                	push   $0x0
  8000ce:	e8 72 0a 00 00       	call   800b45 <sys_env_destroy>
}
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	c9                   	leave  
  8000d7:	c3                   	ret    

008000d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 04             	sub    $0x4,%esp
  8000df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e2:	8b 13                	mov    (%ebx),%edx
  8000e4:	8d 42 01             	lea    0x1(%edx),%eax
  8000e7:	89 03                	mov    %eax,(%ebx)
  8000e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ec:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f5:	74 09                	je     800100 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000f7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000fe:	c9                   	leave  
  8000ff:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	68 ff 00 00 00       	push   $0xff
  800108:	8d 43 08             	lea    0x8(%ebx),%eax
  80010b:	50                   	push   %eax
  80010c:	e8 f7 09 00 00       	call   800b08 <sys_cputs>
		b->idx = 0;
  800111:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	eb db                	jmp    8000f7 <putch+0x1f>

0080011c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800125:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80012c:	00 00 00 
	b.cnt = 0;
  80012f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800136:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	68 d8 00 80 00       	push   $0x8000d8
  80014b:	e8 1a 01 00 00       	call   80026a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800150:	83 c4 08             	add    $0x8,%esp
  800153:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800159:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015f:	50                   	push   %eax
  800160:	e8 a3 09 00 00       	call   800b08 <sys_cputs>

	return b.cnt;
}
  800165:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800173:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800176:	50                   	push   %eax
  800177:	ff 75 08             	pushl  0x8(%ebp)
  80017a:	e8 9d ff ff ff       	call   80011c <vcprintf>
	va_end(ap);

	return cnt;
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 1c             	sub    $0x1c,%esp
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	89 d6                	mov    %edx,%esi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	8b 55 0c             	mov    0xc(%ebp),%edx
  800194:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800197:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80019a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80019d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001a5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001a8:	39 d3                	cmp    %edx,%ebx
  8001aa:	72 05                	jb     8001b1 <printnum+0x30>
  8001ac:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001af:	77 7a                	ja     80022b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 18             	pushl  0x18(%ebp)
  8001b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8001ba:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001bd:	53                   	push   %ebx
  8001be:	ff 75 10             	pushl  0x10(%ebp)
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8001cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d0:	e8 6b 0c 00 00       	call   800e40 <__udivdi3>
  8001d5:	83 c4 18             	add    $0x18,%esp
  8001d8:	52                   	push   %edx
  8001d9:	50                   	push   %eax
  8001da:	89 f2                	mov    %esi,%edx
  8001dc:	89 f8                	mov    %edi,%eax
  8001de:	e8 9e ff ff ff       	call   800181 <printnum>
  8001e3:	83 c4 20             	add    $0x20,%esp
  8001e6:	eb 13                	jmp    8001fb <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	56                   	push   %esi
  8001ec:	ff 75 18             	pushl  0x18(%ebp)
  8001ef:	ff d7                	call   *%edi
  8001f1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f4:	83 eb 01             	sub    $0x1,%ebx
  8001f7:	85 db                	test   %ebx,%ebx
  8001f9:	7f ed                	jg     8001e8 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	56                   	push   %esi
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	ff 75 e4             	pushl  -0x1c(%ebp)
  800205:	ff 75 e0             	pushl  -0x20(%ebp)
  800208:	ff 75 dc             	pushl  -0x24(%ebp)
  80020b:	ff 75 d8             	pushl  -0x28(%ebp)
  80020e:	e8 4d 0d 00 00       	call   800f60 <__umoddi3>
  800213:	83 c4 14             	add    $0x14,%esp
  800216:	0f be 80 a6 10 80 00 	movsbl 0x8010a6(%eax),%eax
  80021d:	50                   	push   %eax
  80021e:	ff d7                	call   *%edi
}
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800226:	5b                   	pop    %ebx
  800227:	5e                   	pop    %esi
  800228:	5f                   	pop    %edi
  800229:	5d                   	pop    %ebp
  80022a:	c3                   	ret    
  80022b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80022e:	eb c4                	jmp    8001f4 <printnum+0x73>

00800230 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800236:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80023a:	8b 10                	mov    (%eax),%edx
  80023c:	3b 50 04             	cmp    0x4(%eax),%edx
  80023f:	73 0a                	jae    80024b <sprintputch+0x1b>
		*b->buf++ = ch;
  800241:	8d 4a 01             	lea    0x1(%edx),%ecx
  800244:	89 08                	mov    %ecx,(%eax)
  800246:	8b 45 08             	mov    0x8(%ebp),%eax
  800249:	88 02                	mov    %al,(%edx)
}
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    

0080024d <printfmt>:
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800253:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800256:	50                   	push   %eax
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	ff 75 0c             	pushl  0xc(%ebp)
  80025d:	ff 75 08             	pushl  0x8(%ebp)
  800260:	e8 05 00 00 00       	call   80026a <vprintfmt>
}
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <vprintfmt>:
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	57                   	push   %edi
  80026e:	56                   	push   %esi
  80026f:	53                   	push   %ebx
  800270:	83 ec 2c             	sub    $0x2c,%esp
  800273:	8b 75 08             	mov    0x8(%ebp),%esi
  800276:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800279:	8b 7d 10             	mov    0x10(%ebp),%edi
  80027c:	e9 00 04 00 00       	jmp    800681 <vprintfmt+0x417>
		padc = ' ';
  800281:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800285:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80028c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800293:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80029a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80029f:	8d 47 01             	lea    0x1(%edi),%eax
  8002a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002a5:	0f b6 17             	movzbl (%edi),%edx
  8002a8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ab:	3c 55                	cmp    $0x55,%al
  8002ad:	0f 87 51 04 00 00    	ja     800704 <vprintfmt+0x49a>
  8002b3:	0f b6 c0             	movzbl %al,%eax
  8002b6:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  8002bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002c4:	eb d9                	jmp    80029f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002c9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002cd:	eb d0                	jmp    80029f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002cf:	0f b6 d2             	movzbl %dl,%edx
  8002d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002dd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002e4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002e7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ea:	83 f9 09             	cmp    $0x9,%ecx
  8002ed:	77 55                	ja     800344 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002ef:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f2:	eb e9                	jmp    8002dd <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ff:	8d 40 04             	lea    0x4(%eax),%eax
  800302:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800308:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80030c:	79 91                	jns    80029f <vprintfmt+0x35>
				width = precision, precision = -1;
  80030e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800311:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800314:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80031b:	eb 82                	jmp    80029f <vprintfmt+0x35>
  80031d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800320:	85 c0                	test   %eax,%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
  800327:	0f 49 d0             	cmovns %eax,%edx
  80032a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800330:	e9 6a ff ff ff       	jmp    80029f <vprintfmt+0x35>
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800338:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80033f:	e9 5b ff ff ff       	jmp    80029f <vprintfmt+0x35>
  800344:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80034a:	eb bc                	jmp    800308 <vprintfmt+0x9e>
			lflag++;
  80034c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800352:	e9 48 ff ff ff       	jmp    80029f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8d 78 04             	lea    0x4(%eax),%edi
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	53                   	push   %ebx
  800361:	ff 30                	pushl  (%eax)
  800363:	ff d6                	call   *%esi
			break;
  800365:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800368:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80036b:	e9 0e 03 00 00       	jmp    80067e <vprintfmt+0x414>
			err = va_arg(ap, int);
  800370:	8b 45 14             	mov    0x14(%ebp),%eax
  800373:	8d 78 04             	lea    0x4(%eax),%edi
  800376:	8b 00                	mov    (%eax),%eax
  800378:	99                   	cltd   
  800379:	31 d0                	xor    %edx,%eax
  80037b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80037d:	83 f8 08             	cmp    $0x8,%eax
  800380:	7f 23                	jg     8003a5 <vprintfmt+0x13b>
  800382:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  800389:	85 d2                	test   %edx,%edx
  80038b:	74 18                	je     8003a5 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80038d:	52                   	push   %edx
  80038e:	68 c7 10 80 00       	push   $0x8010c7
  800393:	53                   	push   %ebx
  800394:	56                   	push   %esi
  800395:	e8 b3 fe ff ff       	call   80024d <printfmt>
  80039a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039d:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a0:	e9 d9 02 00 00       	jmp    80067e <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003a5:	50                   	push   %eax
  8003a6:	68 be 10 80 00       	push   $0x8010be
  8003ab:	53                   	push   %ebx
  8003ac:	56                   	push   %esi
  8003ad:	e8 9b fe ff ff       	call   80024d <printfmt>
  8003b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003b8:	e9 c1 02 00 00       	jmp    80067e <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	83 c0 04             	add    $0x4,%eax
  8003c3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003cb:	85 ff                	test   %edi,%edi
  8003cd:	b8 b7 10 80 00       	mov    $0x8010b7,%eax
  8003d2:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d9:	0f 8e bd 00 00 00    	jle    80049c <vprintfmt+0x232>
  8003df:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003e3:	75 0e                	jne    8003f3 <vprintfmt+0x189>
  8003e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8003e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003f1:	eb 6d                	jmp    800460 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 d0             	pushl  -0x30(%ebp)
  8003f9:	57                   	push   %edi
  8003fa:	e8 ad 03 00 00       	call   8007ac <strnlen>
  8003ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800402:	29 c1                	sub    %eax,%ecx
  800404:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800407:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80040a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80040e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800411:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800414:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800416:	eb 0f                	jmp    800427 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	53                   	push   %ebx
  80041c:	ff 75 e0             	pushl  -0x20(%ebp)
  80041f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800421:	83 ef 01             	sub    $0x1,%edi
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 ff                	test   %edi,%edi
  800429:	7f ed                	jg     800418 <vprintfmt+0x1ae>
  80042b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80042e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800431:	85 c9                	test   %ecx,%ecx
  800433:	b8 00 00 00 00       	mov    $0x0,%eax
  800438:	0f 49 c1             	cmovns %ecx,%eax
  80043b:	29 c1                	sub    %eax,%ecx
  80043d:	89 75 08             	mov    %esi,0x8(%ebp)
  800440:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800443:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800446:	89 cb                	mov    %ecx,%ebx
  800448:	eb 16                	jmp    800460 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80044a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80044e:	75 31                	jne    800481 <vprintfmt+0x217>
					putch(ch, putdat);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	ff 55 08             	call   *0x8(%ebp)
  80045a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80045d:	83 eb 01             	sub    $0x1,%ebx
  800460:	83 c7 01             	add    $0x1,%edi
  800463:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800467:	0f be c2             	movsbl %dl,%eax
  80046a:	85 c0                	test   %eax,%eax
  80046c:	74 59                	je     8004c7 <vprintfmt+0x25d>
  80046e:	85 f6                	test   %esi,%esi
  800470:	78 d8                	js     80044a <vprintfmt+0x1e0>
  800472:	83 ee 01             	sub    $0x1,%esi
  800475:	79 d3                	jns    80044a <vprintfmt+0x1e0>
  800477:	89 df                	mov    %ebx,%edi
  800479:	8b 75 08             	mov    0x8(%ebp),%esi
  80047c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80047f:	eb 37                	jmp    8004b8 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800481:	0f be d2             	movsbl %dl,%edx
  800484:	83 ea 20             	sub    $0x20,%edx
  800487:	83 fa 5e             	cmp    $0x5e,%edx
  80048a:	76 c4                	jbe    800450 <vprintfmt+0x1e6>
					putch('?', putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	6a 3f                	push   $0x3f
  800494:	ff 55 08             	call   *0x8(%ebp)
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	eb c1                	jmp    80045d <vprintfmt+0x1f3>
  80049c:	89 75 08             	mov    %esi,0x8(%ebp)
  80049f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a8:	eb b6                	jmp    800460 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	53                   	push   %ebx
  8004ae:	6a 20                	push   $0x20
  8004b0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004b2:	83 ef 01             	sub    $0x1,%edi
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	85 ff                	test   %edi,%edi
  8004ba:	7f ee                	jg     8004aa <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c2:	e9 b7 01 00 00       	jmp    80067e <vprintfmt+0x414>
  8004c7:	89 df                	mov    %ebx,%edi
  8004c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004cf:	eb e7                	jmp    8004b8 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004d1:	83 f9 01             	cmp    $0x1,%ecx
  8004d4:	7e 3f                	jle    800515 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d9:	8b 50 04             	mov    0x4(%eax),%edx
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	8d 40 08             	lea    0x8(%eax),%eax
  8004ea:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004f1:	79 5c                	jns    80054f <vprintfmt+0x2e5>
				putch('-', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 2d                	push   $0x2d
  8004f9:	ff d6                	call   *%esi
				num = -(long long) num;
  8004fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004fe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800501:	f7 da                	neg    %edx
  800503:	83 d1 00             	adc    $0x0,%ecx
  800506:	f7 d9                	neg    %ecx
  800508:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80050b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800510:	e9 4f 01 00 00       	jmp    800664 <vprintfmt+0x3fa>
	else if (lflag)
  800515:	85 c9                	test   %ecx,%ecx
  800517:	75 1b                	jne    800534 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	89 c1                	mov    %eax,%ecx
  800523:	c1 f9 1f             	sar    $0x1f,%ecx
  800526:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8d 40 04             	lea    0x4(%eax),%eax
  80052f:	89 45 14             	mov    %eax,0x14(%ebp)
  800532:	eb b9                	jmp    8004ed <vprintfmt+0x283>
		return va_arg(*ap, long);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	89 c1                	mov    %eax,%ecx
  80053e:	c1 f9 1f             	sar    $0x1f,%ecx
  800541:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 40 04             	lea    0x4(%eax),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	eb 9e                	jmp    8004ed <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80054f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800552:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800555:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055a:	e9 05 01 00 00       	jmp    800664 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80055f:	83 f9 01             	cmp    $0x1,%ecx
  800562:	7e 18                	jle    80057c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 10                	mov    (%eax),%edx
  800569:	8b 48 04             	mov    0x4(%eax),%ecx
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
  800577:	e9 e8 00 00 00       	jmp    800664 <vprintfmt+0x3fa>
	else if (lflag)
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	75 1a                	jne    80059a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 10                	mov    (%eax),%edx
  800585:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800590:	b8 0a 00 00 00       	mov    $0xa,%eax
  800595:	e9 ca 00 00 00       	jmp    800664 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 10                	mov    (%eax),%edx
  80059f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005af:	e9 b0 00 00 00       	jmp    800664 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005b4:	83 f9 01             	cmp    $0x1,%ecx
  8005b7:	7e 3c                	jle    8005f5 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 08             	lea    0x8(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005d4:	79 59                	jns    80062f <vprintfmt+0x3c5>
                putch('-', putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 2d                	push   $0x2d
  8005dc:	ff d6                	call   *%esi
                num = -(long long) num;
  8005de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e4:	f7 da                	neg    %edx
  8005e6:	83 d1 00             	adc    $0x0,%ecx
  8005e9:	f7 d9                	neg    %ecx
  8005eb:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f3:	eb 6f                	jmp    800664 <vprintfmt+0x3fa>
	else if (lflag)
  8005f5:	85 c9                	test   %ecx,%ecx
  8005f7:	75 1b                	jne    800614 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 c1                	mov    %eax,%ecx
  800603:	c1 f9 1f             	sar    $0x1f,%ecx
  800606:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 04             	lea    0x4(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
  800612:	eb bc                	jmp    8005d0 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	89 c1                	mov    %eax,%ecx
  80061e:	c1 f9 1f             	sar    $0x1f,%ecx
  800621:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
  80062d:	eb a1                	jmp    8005d0 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80062f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800632:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800635:	b8 08 00 00 00       	mov    $0x8,%eax
  80063a:	eb 28                	jmp    800664 <vprintfmt+0x3fa>
			putch('0', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	6a 30                	push   $0x30
  800642:	ff d6                	call   *%esi
			putch('x', putdat);
  800644:	83 c4 08             	add    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 78                	push   $0x78
  80064a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 10                	mov    (%eax),%edx
  800651:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800656:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800664:	83 ec 0c             	sub    $0xc,%esp
  800667:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80066b:	57                   	push   %edi
  80066c:	ff 75 e0             	pushl  -0x20(%ebp)
  80066f:	50                   	push   %eax
  800670:	51                   	push   %ecx
  800671:	52                   	push   %edx
  800672:	89 da                	mov    %ebx,%edx
  800674:	89 f0                	mov    %esi,%eax
  800676:	e8 06 fb ff ff       	call   800181 <printnum>
			break;
  80067b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800681:	83 c7 01             	add    $0x1,%edi
  800684:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800688:	83 f8 25             	cmp    $0x25,%eax
  80068b:	0f 84 f0 fb ff ff    	je     800281 <vprintfmt+0x17>
			if (ch == '\0')
  800691:	85 c0                	test   %eax,%eax
  800693:	0f 84 8b 00 00 00    	je     800724 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	50                   	push   %eax
  80069e:	ff d6                	call   *%esi
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	eb dc                	jmp    800681 <vprintfmt+0x417>
	if (lflag >= 2)
  8006a5:	83 f9 01             	cmp    $0x1,%ecx
  8006a8:	7e 15                	jle    8006bf <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 10                	mov    (%eax),%edx
  8006af:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b2:	8d 40 08             	lea    0x8(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bd:	eb a5                	jmp    800664 <vprintfmt+0x3fa>
	else if (lflag)
  8006bf:	85 c9                	test   %ecx,%ecx
  8006c1:	75 17                	jne    8006da <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d8:	eb 8a                	jmp    800664 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 10                	mov    (%eax),%edx
  8006df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ea:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ef:	e9 70 ff ff ff       	jmp    800664 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	6a 25                	push   $0x25
  8006fa:	ff d6                	call   *%esi
			break;
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	e9 7a ff ff ff       	jmp    80067e <vprintfmt+0x414>
			putch('%', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	6a 25                	push   $0x25
  80070a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80070c:	83 c4 10             	add    $0x10,%esp
  80070f:	89 f8                	mov    %edi,%eax
  800711:	eb 03                	jmp    800716 <vprintfmt+0x4ac>
  800713:	83 e8 01             	sub    $0x1,%eax
  800716:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80071a:	75 f7                	jne    800713 <vprintfmt+0x4a9>
  80071c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071f:	e9 5a ff ff ff       	jmp    80067e <vprintfmt+0x414>
}
  800724:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800727:	5b                   	pop    %ebx
  800728:	5e                   	pop    %esi
  800729:	5f                   	pop    %edi
  80072a:	5d                   	pop    %ebp
  80072b:	c3                   	ret    

0080072c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	83 ec 18             	sub    $0x18,%esp
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800738:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80073b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80073f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800742:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800749:	85 c0                	test   %eax,%eax
  80074b:	74 26                	je     800773 <vsnprintf+0x47>
  80074d:	85 d2                	test   %edx,%edx
  80074f:	7e 22                	jle    800773 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800751:	ff 75 14             	pushl  0x14(%ebp)
  800754:	ff 75 10             	pushl  0x10(%ebp)
  800757:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80075a:	50                   	push   %eax
  80075b:	68 30 02 80 00       	push   $0x800230
  800760:	e8 05 fb ff ff       	call   80026a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800768:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076e:	83 c4 10             	add    $0x10,%esp
}
  800771:	c9                   	leave  
  800772:	c3                   	ret    
		return -E_INVAL;
  800773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800778:	eb f7                	jmp    800771 <vsnprintf+0x45>

0080077a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800783:	50                   	push   %eax
  800784:	ff 75 10             	pushl  0x10(%ebp)
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	ff 75 08             	pushl  0x8(%ebp)
  80078d:	e8 9a ff ff ff       	call   80072c <vsnprintf>
	va_end(ap);

	return rc;
}
  800792:	c9                   	leave  
  800793:	c3                   	ret    

00800794 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	eb 03                	jmp    8007a4 <strlen+0x10>
		n++;
  8007a1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007a4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a8:	75 f7                	jne    8007a1 <strlen+0xd>
	return n;
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ba:	eb 03                	jmp    8007bf <strnlen+0x13>
		n++;
  8007bc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bf:	39 d0                	cmp    %edx,%eax
  8007c1:	74 06                	je     8007c9 <strnlen+0x1d>
  8007c3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c7:	75 f3                	jne    8007bc <strnlen+0x10>
	return n;
}
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	53                   	push   %ebx
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d5:	89 c2                	mov    %eax,%edx
  8007d7:	83 c1 01             	add    $0x1,%ecx
  8007da:	83 c2 01             	add    $0x1,%edx
  8007dd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007e1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e4:	84 db                	test   %bl,%bl
  8007e6:	75 ef                	jne    8007d7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e8:	5b                   	pop    %ebx
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	53                   	push   %ebx
  8007ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f2:	53                   	push   %ebx
  8007f3:	e8 9c ff ff ff       	call   800794 <strlen>
  8007f8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007fb:	ff 75 0c             	pushl  0xc(%ebp)
  8007fe:	01 d8                	add    %ebx,%eax
  800800:	50                   	push   %eax
  800801:	e8 c5 ff ff ff       	call   8007cb <strcpy>
	return dst;
}
  800806:	89 d8                	mov    %ebx,%eax
  800808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	56                   	push   %esi
  800811:	53                   	push   %ebx
  800812:	8b 75 08             	mov    0x8(%ebp),%esi
  800815:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800818:	89 f3                	mov    %esi,%ebx
  80081a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80081d:	89 f2                	mov    %esi,%edx
  80081f:	eb 0f                	jmp    800830 <strncpy+0x23>
		*dst++ = *src;
  800821:	83 c2 01             	add    $0x1,%edx
  800824:	0f b6 01             	movzbl (%ecx),%eax
  800827:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082a:	80 39 01             	cmpb   $0x1,(%ecx)
  80082d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800830:	39 da                	cmp    %ebx,%edx
  800832:	75 ed                	jne    800821 <strncpy+0x14>
	}
	return ret;
}
  800834:	89 f0                	mov    %esi,%eax
  800836:	5b                   	pop    %ebx
  800837:	5e                   	pop    %esi
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	56                   	push   %esi
  80083e:	53                   	push   %ebx
  80083f:	8b 75 08             	mov    0x8(%ebp),%esi
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
  800845:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800848:	89 f0                	mov    %esi,%eax
  80084a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80084e:	85 c9                	test   %ecx,%ecx
  800850:	75 0b                	jne    80085d <strlcpy+0x23>
  800852:	eb 17                	jmp    80086b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800854:	83 c2 01             	add    $0x1,%edx
  800857:	83 c0 01             	add    $0x1,%eax
  80085a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80085d:	39 d8                	cmp    %ebx,%eax
  80085f:	74 07                	je     800868 <strlcpy+0x2e>
  800861:	0f b6 0a             	movzbl (%edx),%ecx
  800864:	84 c9                	test   %cl,%cl
  800866:	75 ec                	jne    800854 <strlcpy+0x1a>
		*dst = '\0';
  800868:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80086b:	29 f0                	sub    %esi,%eax
}
  80086d:	5b                   	pop    %ebx
  80086e:	5e                   	pop    %esi
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800877:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80087a:	eb 06                	jmp    800882 <strcmp+0x11>
		p++, q++;
  80087c:	83 c1 01             	add    $0x1,%ecx
  80087f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800882:	0f b6 01             	movzbl (%ecx),%eax
  800885:	84 c0                	test   %al,%al
  800887:	74 04                	je     80088d <strcmp+0x1c>
  800889:	3a 02                	cmp    (%edx),%al
  80088b:	74 ef                	je     80087c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088d:	0f b6 c0             	movzbl %al,%eax
  800890:	0f b6 12             	movzbl (%edx),%edx
  800893:	29 d0                	sub    %edx,%eax
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	89 c3                	mov    %eax,%ebx
  8008a3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a6:	eb 06                	jmp    8008ae <strncmp+0x17>
		n--, p++, q++;
  8008a8:	83 c0 01             	add    $0x1,%eax
  8008ab:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008ae:	39 d8                	cmp    %ebx,%eax
  8008b0:	74 16                	je     8008c8 <strncmp+0x31>
  8008b2:	0f b6 08             	movzbl (%eax),%ecx
  8008b5:	84 c9                	test   %cl,%cl
  8008b7:	74 04                	je     8008bd <strncmp+0x26>
  8008b9:	3a 0a                	cmp    (%edx),%cl
  8008bb:	74 eb                	je     8008a8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008bd:	0f b6 00             	movzbl (%eax),%eax
  8008c0:	0f b6 12             	movzbl (%edx),%edx
  8008c3:	29 d0                	sub    %edx,%eax
}
  8008c5:	5b                   	pop    %ebx
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    
		return 0;
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	eb f6                	jmp    8008c5 <strncmp+0x2e>

008008cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d9:	0f b6 10             	movzbl (%eax),%edx
  8008dc:	84 d2                	test   %dl,%dl
  8008de:	74 09                	je     8008e9 <strchr+0x1a>
		if (*s == c)
  8008e0:	38 ca                	cmp    %cl,%dl
  8008e2:	74 0a                	je     8008ee <strchr+0x1f>
	for (; *s; s++)
  8008e4:	83 c0 01             	add    $0x1,%eax
  8008e7:	eb f0                	jmp    8008d9 <strchr+0xa>
			return (char *) s;
	return 0;
  8008e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fa:	eb 03                	jmp    8008ff <strfind+0xf>
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800902:	38 ca                	cmp    %cl,%dl
  800904:	74 04                	je     80090a <strfind+0x1a>
  800906:	84 d2                	test   %dl,%dl
  800908:	75 f2                	jne    8008fc <strfind+0xc>
			break;
	return (char *) s;
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	57                   	push   %edi
  800910:	56                   	push   %esi
  800911:	53                   	push   %ebx
  800912:	8b 7d 08             	mov    0x8(%ebp),%edi
  800915:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800918:	85 c9                	test   %ecx,%ecx
  80091a:	74 13                	je     80092f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800922:	75 05                	jne    800929 <memset+0x1d>
  800924:	f6 c1 03             	test   $0x3,%cl
  800927:	74 0d                	je     800936 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	fc                   	cld    
  80092d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092f:	89 f8                	mov    %edi,%eax
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5f                   	pop    %edi
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    
		c &= 0xFF;
  800936:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093a:	89 d3                	mov    %edx,%ebx
  80093c:	c1 e3 08             	shl    $0x8,%ebx
  80093f:	89 d0                	mov    %edx,%eax
  800941:	c1 e0 18             	shl    $0x18,%eax
  800944:	89 d6                	mov    %edx,%esi
  800946:	c1 e6 10             	shl    $0x10,%esi
  800949:	09 f0                	or     %esi,%eax
  80094b:	09 c2                	or     %eax,%edx
  80094d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80094f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800952:	89 d0                	mov    %edx,%eax
  800954:	fc                   	cld    
  800955:	f3 ab                	rep stos %eax,%es:(%edi)
  800957:	eb d6                	jmp    80092f <memset+0x23>

00800959 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	57                   	push   %edi
  80095d:	56                   	push   %esi
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 75 0c             	mov    0xc(%ebp),%esi
  800964:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800967:	39 c6                	cmp    %eax,%esi
  800969:	73 35                	jae    8009a0 <memmove+0x47>
  80096b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096e:	39 c2                	cmp    %eax,%edx
  800970:	76 2e                	jbe    8009a0 <memmove+0x47>
		s += n;
		d += n;
  800972:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800975:	89 d6                	mov    %edx,%esi
  800977:	09 fe                	or     %edi,%esi
  800979:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80097f:	74 0c                	je     80098d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800981:	83 ef 01             	sub    $0x1,%edi
  800984:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800987:	fd                   	std    
  800988:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80098a:	fc                   	cld    
  80098b:	eb 21                	jmp    8009ae <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098d:	f6 c1 03             	test   $0x3,%cl
  800990:	75 ef                	jne    800981 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800992:	83 ef 04             	sub    $0x4,%edi
  800995:	8d 72 fc             	lea    -0x4(%edx),%esi
  800998:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80099b:	fd                   	std    
  80099c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099e:	eb ea                	jmp    80098a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a0:	89 f2                	mov    %esi,%edx
  8009a2:	09 c2                	or     %eax,%edx
  8009a4:	f6 c2 03             	test   $0x3,%dl
  8009a7:	74 09                	je     8009b2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009a9:	89 c7                	mov    %eax,%edi
  8009ab:	fc                   	cld    
  8009ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009ae:	5e                   	pop    %esi
  8009af:	5f                   	pop    %edi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	f6 c1 03             	test   $0x3,%cl
  8009b5:	75 f2                	jne    8009a9 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ba:	89 c7                	mov    %eax,%edi
  8009bc:	fc                   	cld    
  8009bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bf:	eb ed                	jmp    8009ae <memmove+0x55>

008009c1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009c4:	ff 75 10             	pushl  0x10(%ebp)
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	ff 75 08             	pushl  0x8(%ebp)
  8009cd:	e8 87 ff ff ff       	call   800959 <memmove>
}
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    

008009d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	56                   	push   %esi
  8009d8:	53                   	push   %ebx
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	89 c6                	mov    %eax,%esi
  8009e1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e4:	39 f0                	cmp    %esi,%eax
  8009e6:	74 1c                	je     800a04 <memcmp+0x30>
		if (*s1 != *s2)
  8009e8:	0f b6 08             	movzbl (%eax),%ecx
  8009eb:	0f b6 1a             	movzbl (%edx),%ebx
  8009ee:	38 d9                	cmp    %bl,%cl
  8009f0:	75 08                	jne    8009fa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f2:	83 c0 01             	add    $0x1,%eax
  8009f5:	83 c2 01             	add    $0x1,%edx
  8009f8:	eb ea                	jmp    8009e4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009fa:	0f b6 c1             	movzbl %cl,%eax
  8009fd:	0f b6 db             	movzbl %bl,%ebx
  800a00:	29 d8                	sub    %ebx,%eax
  800a02:	eb 05                	jmp    800a09 <memcmp+0x35>
	}

	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5b                   	pop    %ebx
  800a0a:	5e                   	pop    %esi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1b:	39 d0                	cmp    %edx,%eax
  800a1d:	73 09                	jae    800a28 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a1f:	38 08                	cmp    %cl,(%eax)
  800a21:	74 05                	je     800a28 <memfind+0x1b>
	for (; s < ends; s++)
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	eb f3                	jmp    800a1b <memfind+0xe>
			break;
	return (void *) s;
}
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	57                   	push   %edi
  800a2e:	56                   	push   %esi
  800a2f:	53                   	push   %ebx
  800a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a36:	eb 03                	jmp    800a3b <strtol+0x11>
		s++;
  800a38:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a3b:	0f b6 01             	movzbl (%ecx),%eax
  800a3e:	3c 20                	cmp    $0x20,%al
  800a40:	74 f6                	je     800a38 <strtol+0xe>
  800a42:	3c 09                	cmp    $0x9,%al
  800a44:	74 f2                	je     800a38 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a46:	3c 2b                	cmp    $0x2b,%al
  800a48:	74 2e                	je     800a78 <strtol+0x4e>
	int neg = 0;
  800a4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a4f:	3c 2d                	cmp    $0x2d,%al
  800a51:	74 2f                	je     800a82 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a53:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a59:	75 05                	jne    800a60 <strtol+0x36>
  800a5b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5e:	74 2c                	je     800a8c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a60:	85 db                	test   %ebx,%ebx
  800a62:	75 0a                	jne    800a6e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a64:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a69:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6c:	74 28                	je     800a96 <strtol+0x6c>
		base = 10;
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a76:	eb 50                	jmp    800ac8 <strtol+0x9e>
		s++;
  800a78:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a80:	eb d1                	jmp    800a53 <strtol+0x29>
		s++, neg = 1;
  800a82:	83 c1 01             	add    $0x1,%ecx
  800a85:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8a:	eb c7                	jmp    800a53 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a90:	74 0e                	je     800aa0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a92:	85 db                	test   %ebx,%ebx
  800a94:	75 d8                	jne    800a6e <strtol+0x44>
		s++, base = 8;
  800a96:	83 c1 01             	add    $0x1,%ecx
  800a99:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a9e:	eb ce                	jmp    800a6e <strtol+0x44>
		s += 2, base = 16;
  800aa0:	83 c1 02             	add    $0x2,%ecx
  800aa3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa8:	eb c4                	jmp    800a6e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aaa:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aad:	89 f3                	mov    %esi,%ebx
  800aaf:	80 fb 19             	cmp    $0x19,%bl
  800ab2:	77 29                	ja     800add <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab4:	0f be d2             	movsbl %dl,%edx
  800ab7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aba:	3b 55 10             	cmp    0x10(%ebp),%edx
  800abd:	7d 30                	jge    800aef <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800abf:	83 c1 01             	add    $0x1,%ecx
  800ac2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ac8:	0f b6 11             	movzbl (%ecx),%edx
  800acb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ace:	89 f3                	mov    %esi,%ebx
  800ad0:	80 fb 09             	cmp    $0x9,%bl
  800ad3:	77 d5                	ja     800aaa <strtol+0x80>
			dig = *s - '0';
  800ad5:	0f be d2             	movsbl %dl,%edx
  800ad8:	83 ea 30             	sub    $0x30,%edx
  800adb:	eb dd                	jmp    800aba <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800add:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae0:	89 f3                	mov    %esi,%ebx
  800ae2:	80 fb 19             	cmp    $0x19,%bl
  800ae5:	77 08                	ja     800aef <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae7:	0f be d2             	movsbl %dl,%edx
  800aea:	83 ea 37             	sub    $0x37,%edx
  800aed:	eb cb                	jmp    800aba <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af3:	74 05                	je     800afa <strtol+0xd0>
		*endptr = (char *) s;
  800af5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	f7 da                	neg    %edx
  800afe:	85 ff                	test   %edi,%edi
  800b00:	0f 45 c2             	cmovne %edx,%eax
}
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	57                   	push   %edi
  800b0c:	56                   	push   %esi
  800b0d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b13:	8b 55 08             	mov    0x8(%ebp),%edx
  800b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b19:	89 c3                	mov    %eax,%ebx
  800b1b:	89 c7                	mov    %eax,%edi
  800b1d:	89 c6                	mov    %eax,%esi
  800b1f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_cgetc>:

int
sys_cgetc(void) {
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b31:	b8 01 00 00 00       	mov    $0x1,%eax
  800b36:	89 d1                	mov    %edx,%ecx
  800b38:	89 d3                	mov    %edx,%ebx
  800b3a:	89 d7                	mov    %edx,%edi
  800b3c:	89 d6                	mov    %edx,%esi
  800b3e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b40:	5b                   	pop    %ebx
  800b41:	5e                   	pop    %esi
  800b42:	5f                   	pop    %edi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
  800b4b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
  800b56:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5b:	89 cb                	mov    %ecx,%ebx
  800b5d:	89 cf                	mov    %ecx,%edi
  800b5f:	89 ce                	mov    %ecx,%esi
  800b61:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b63:	85 c0                	test   %eax,%eax
  800b65:	7f 08                	jg     800b6f <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6a:	5b                   	pop    %ebx
  800b6b:	5e                   	pop    %esi
  800b6c:	5f                   	pop    %edi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b6f:	83 ec 0c             	sub    $0xc,%esp
  800b72:	50                   	push   %eax
  800b73:	6a 03                	push   $0x3
  800b75:	68 e4 12 80 00       	push   $0x8012e4
  800b7a:	6a 24                	push   $0x24
  800b7c:	68 01 13 80 00       	push   $0x801301
  800b81:	e8 69 02 00 00       	call   800def <_panic>

00800b86 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b91:	b8 02 00 00 00       	mov    $0x2,%eax
  800b96:	89 d1                	mov    %edx,%ecx
  800b98:	89 d3                	mov    %edx,%ebx
  800b9a:	89 d7                	mov    %edx,%edi
  800b9c:	89 d6                	mov    %edx,%esi
  800b9e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <sys_yield>:

void
sys_yield(void)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bcd:	be 00 00 00 00       	mov    $0x0,%esi
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be0:	89 f7                	mov    %esi,%edi
  800be2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800be4:	85 c0                	test   %eax,%eax
  800be6:	7f 08                	jg     800bf0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800bf4:	6a 04                	push   $0x4
  800bf6:	68 e4 12 80 00       	push   $0x8012e4
  800bfb:	6a 24                	push   $0x24
  800bfd:	68 01 13 80 00       	push   $0x801301
  800c02:	e8 e8 01 00 00       	call   800def <_panic>

00800c07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c10:	8b 55 08             	mov    0x8(%ebp),%edx
  800c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c16:	b8 05 00 00 00       	mov    $0x5,%eax
  800c1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c21:	8b 75 18             	mov    0x18(%ebp),%esi
  800c24:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7f 08                	jg     800c32 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800c36:	6a 05                	push   $0x5
  800c38:	68 e4 12 80 00       	push   $0x8012e4
  800c3d:	6a 24                	push   $0x24
  800c3f:	68 01 13 80 00       	push   $0x801301
  800c44:	e8 a6 01 00 00       	call   800def <_panic>

00800c49 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800c5d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c62:	89 df                	mov    %ebx,%edi
  800c64:	89 de                	mov    %ebx,%esi
  800c66:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	7f 08                	jg     800c74 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800c78:	6a 06                	push   $0x6
  800c7a:	68 e4 12 80 00       	push   $0x8012e4
  800c7f:	6a 24                	push   $0x24
  800c81:	68 01 13 80 00       	push   $0x801301
  800c86:	e8 64 01 00 00       	call   800def <_panic>

00800c8b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800c9f:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca4:	89 df                	mov    %ebx,%edi
  800ca6:	89 de                	mov    %ebx,%esi
  800ca8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800cba:	6a 08                	push   $0x8
  800cbc:	68 e4 12 80 00       	push   $0x8012e4
  800cc1:	6a 24                	push   $0x24
  800cc3:	68 01 13 80 00       	push   $0x801301
  800cc8:	e8 22 01 00 00       	call   800def <_panic>

00800ccd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 09                	push   $0x9
  800cfe:	68 e4 12 80 00       	push   $0x8012e4
  800d03:	6a 24                	push   $0x24
  800d05:	68 01 13 80 00       	push   $0x801301
  800d0a:	e8 e0 00 00 00       	call   800def <_panic>

00800d0f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d20:	be 00 00 00 00       	mov    $0x0,%esi
  800d25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d48:	89 cb                	mov    %ecx,%ebx
  800d4a:	89 cf                	mov    %ecx,%edi
  800d4c:	89 ce                	mov    %ecx,%esi
  800d4e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	7f 08                	jg     800d5c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d5c:	83 ec 0c             	sub    $0xc,%esp
  800d5f:	50                   	push   %eax
  800d60:	6a 0c                	push   $0xc
  800d62:	68 e4 12 80 00       	push   $0x8012e4
  800d67:	6a 24                	push   $0x24
  800d69:	68 01 13 80 00       	push   $0x801301
  800d6e:	e8 7c 00 00 00       	call   800def <_panic>

00800d73 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d79:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800d80:	74 0a                	je     800d8c <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  800d8c:	a1 04 20 80 00       	mov    0x802004,%eax
  800d91:	8b 40 48             	mov    0x48(%eax),%eax
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	6a 07                	push   $0x7
  800d99:	68 00 f0 bf ee       	push   $0xeebff000
  800d9e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800da3:	50                   	push   %eax
  800da4:	e8 1b fe ff ff       	call   800bc4 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  800da9:	a1 04 20 80 00       	mov    0x802004,%eax
  800dae:	8b 40 48             	mov    0x48(%eax),%eax
  800db1:	83 c4 08             	add    $0x8,%esp
  800db4:	68 c9 0d 80 00       	push   $0x800dc9
  800db9:	25 ff 03 00 00       	and    $0x3ff,%eax
  800dbe:	50                   	push   %eax
  800dbf:	e8 09 ff ff ff       	call   800ccd <sys_env_set_pgfault_upcall>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	eb b9                	jmp    800d82 <set_pgfault_handler+0xf>

00800dc9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800dc9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800dca:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800dcf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800dd1:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  800dd4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  800dd8:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  800ddc:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  800ddf:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  800de1:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  800de5:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  800de8:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  800de9:	83 c4 04             	add    $0x4,%esp
    popfl
  800dec:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  800ded:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800dee:	c3                   	ret    

00800def <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800df4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800df7:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800dfd:	e8 84 fd ff ff       	call   800b86 <sys_getenvid>
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	ff 75 08             	pushl  0x8(%ebp)
  800e0b:	56                   	push   %esi
  800e0c:	50                   	push   %eax
  800e0d:	68 10 13 80 00       	push   $0x801310
  800e12:	e8 56 f3 ff ff       	call   80016d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e17:	83 c4 18             	add    $0x18,%esp
  800e1a:	53                   	push   %ebx
  800e1b:	ff 75 10             	pushl  0x10(%ebp)
  800e1e:	e8 f9 f2 ff ff       	call   80011c <vcprintf>
	cprintf("\n");
  800e23:	c7 04 24 9a 10 80 00 	movl   $0x80109a,(%esp)
  800e2a:	e8 3e f3 ff ff       	call   80016d <cprintf>
  800e2f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e32:	cc                   	int3   
  800e33:	eb fd                	jmp    800e32 <_panic+0x43>
  800e35:	66 90                	xchg   %ax,%ax
  800e37:	66 90                	xchg   %ax,%ax
  800e39:	66 90                	xchg   %ax,%ax
  800e3b:	66 90                	xchg   %ax,%ax
  800e3d:	66 90                	xchg   %ax,%ax
  800e3f:	90                   	nop

00800e40 <__udivdi3>:
  800e40:	55                   	push   %ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
  800e44:	83 ec 1c             	sub    $0x1c,%esp
  800e47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e57:	85 d2                	test   %edx,%edx
  800e59:	75 35                	jne    800e90 <__udivdi3+0x50>
  800e5b:	39 f3                	cmp    %esi,%ebx
  800e5d:	0f 87 bd 00 00 00    	ja     800f20 <__udivdi3+0xe0>
  800e63:	85 db                	test   %ebx,%ebx
  800e65:	89 d9                	mov    %ebx,%ecx
  800e67:	75 0b                	jne    800e74 <__udivdi3+0x34>
  800e69:	b8 01 00 00 00       	mov    $0x1,%eax
  800e6e:	31 d2                	xor    %edx,%edx
  800e70:	f7 f3                	div    %ebx
  800e72:	89 c1                	mov    %eax,%ecx
  800e74:	31 d2                	xor    %edx,%edx
  800e76:	89 f0                	mov    %esi,%eax
  800e78:	f7 f1                	div    %ecx
  800e7a:	89 c6                	mov    %eax,%esi
  800e7c:	89 e8                	mov    %ebp,%eax
  800e7e:	89 f7                	mov    %esi,%edi
  800e80:	f7 f1                	div    %ecx
  800e82:	89 fa                	mov    %edi,%edx
  800e84:	83 c4 1c             	add    $0x1c,%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    
  800e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e90:	39 f2                	cmp    %esi,%edx
  800e92:	77 7c                	ja     800f10 <__udivdi3+0xd0>
  800e94:	0f bd fa             	bsr    %edx,%edi
  800e97:	83 f7 1f             	xor    $0x1f,%edi
  800e9a:	0f 84 98 00 00 00    	je     800f38 <__udivdi3+0xf8>
  800ea0:	89 f9                	mov    %edi,%ecx
  800ea2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ea7:	29 f8                	sub    %edi,%eax
  800ea9:	d3 e2                	shl    %cl,%edx
  800eab:	89 54 24 08          	mov    %edx,0x8(%esp)
  800eaf:	89 c1                	mov    %eax,%ecx
  800eb1:	89 da                	mov    %ebx,%edx
  800eb3:	d3 ea                	shr    %cl,%edx
  800eb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800eb9:	09 d1                	or     %edx,%ecx
  800ebb:	89 f2                	mov    %esi,%edx
  800ebd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ec1:	89 f9                	mov    %edi,%ecx
  800ec3:	d3 e3                	shl    %cl,%ebx
  800ec5:	89 c1                	mov    %eax,%ecx
  800ec7:	d3 ea                	shr    %cl,%edx
  800ec9:	89 f9                	mov    %edi,%ecx
  800ecb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ecf:	d3 e6                	shl    %cl,%esi
  800ed1:	89 eb                	mov    %ebp,%ebx
  800ed3:	89 c1                	mov    %eax,%ecx
  800ed5:	d3 eb                	shr    %cl,%ebx
  800ed7:	09 de                	or     %ebx,%esi
  800ed9:	89 f0                	mov    %esi,%eax
  800edb:	f7 74 24 08          	divl   0x8(%esp)
  800edf:	89 d6                	mov    %edx,%esi
  800ee1:	89 c3                	mov    %eax,%ebx
  800ee3:	f7 64 24 0c          	mull   0xc(%esp)
  800ee7:	39 d6                	cmp    %edx,%esi
  800ee9:	72 0c                	jb     800ef7 <__udivdi3+0xb7>
  800eeb:	89 f9                	mov    %edi,%ecx
  800eed:	d3 e5                	shl    %cl,%ebp
  800eef:	39 c5                	cmp    %eax,%ebp
  800ef1:	73 5d                	jae    800f50 <__udivdi3+0x110>
  800ef3:	39 d6                	cmp    %edx,%esi
  800ef5:	75 59                	jne    800f50 <__udivdi3+0x110>
  800ef7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800efa:	31 ff                	xor    %edi,%edi
  800efc:	89 fa                	mov    %edi,%edx
  800efe:	83 c4 1c             	add    $0x1c,%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    
  800f06:	8d 76 00             	lea    0x0(%esi),%esi
  800f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f10:	31 ff                	xor    %edi,%edi
  800f12:	31 c0                	xor    %eax,%eax
  800f14:	89 fa                	mov    %edi,%edx
  800f16:	83 c4 1c             	add    $0x1c,%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
  800f1e:	66 90                	xchg   %ax,%ax
  800f20:	31 ff                	xor    %edi,%edi
  800f22:	89 e8                	mov    %ebp,%eax
  800f24:	89 f2                	mov    %esi,%edx
  800f26:	f7 f3                	div    %ebx
  800f28:	89 fa                	mov    %edi,%edx
  800f2a:	83 c4 1c             	add    $0x1c,%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
  800f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f38:	39 f2                	cmp    %esi,%edx
  800f3a:	72 06                	jb     800f42 <__udivdi3+0x102>
  800f3c:	31 c0                	xor    %eax,%eax
  800f3e:	39 eb                	cmp    %ebp,%ebx
  800f40:	77 d2                	ja     800f14 <__udivdi3+0xd4>
  800f42:	b8 01 00 00 00       	mov    $0x1,%eax
  800f47:	eb cb                	jmp    800f14 <__udivdi3+0xd4>
  800f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f50:	89 d8                	mov    %ebx,%eax
  800f52:	31 ff                	xor    %edi,%edi
  800f54:	eb be                	jmp    800f14 <__udivdi3+0xd4>
  800f56:	66 90                	xchg   %ax,%ax
  800f58:	66 90                	xchg   %ax,%ax
  800f5a:	66 90                	xchg   %ax,%ax
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__umoddi3>:
  800f60:	55                   	push   %ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 1c             	sub    $0x1c,%esp
  800f67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f77:	85 ed                	test   %ebp,%ebp
  800f79:	89 f0                	mov    %esi,%eax
  800f7b:	89 da                	mov    %ebx,%edx
  800f7d:	75 19                	jne    800f98 <__umoddi3+0x38>
  800f7f:	39 df                	cmp    %ebx,%edi
  800f81:	0f 86 b1 00 00 00    	jbe    801038 <__umoddi3+0xd8>
  800f87:	f7 f7                	div    %edi
  800f89:	89 d0                	mov    %edx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	83 c4 1c             	add    $0x1c,%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	39 dd                	cmp    %ebx,%ebp
  800f9a:	77 f1                	ja     800f8d <__umoddi3+0x2d>
  800f9c:	0f bd cd             	bsr    %ebp,%ecx
  800f9f:	83 f1 1f             	xor    $0x1f,%ecx
  800fa2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fa6:	0f 84 b4 00 00 00    	je     801060 <__umoddi3+0x100>
  800fac:	b8 20 00 00 00       	mov    $0x20,%eax
  800fb1:	89 c2                	mov    %eax,%edx
  800fb3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fb7:	29 c2                	sub    %eax,%edx
  800fb9:	89 c1                	mov    %eax,%ecx
  800fbb:	89 f8                	mov    %edi,%eax
  800fbd:	d3 e5                	shl    %cl,%ebp
  800fbf:	89 d1                	mov    %edx,%ecx
  800fc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fc5:	d3 e8                	shr    %cl,%eax
  800fc7:	09 c5                	or     %eax,%ebp
  800fc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fcd:	89 c1                	mov    %eax,%ecx
  800fcf:	d3 e7                	shl    %cl,%edi
  800fd1:	89 d1                	mov    %edx,%ecx
  800fd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fd7:	89 df                	mov    %ebx,%edi
  800fd9:	d3 ef                	shr    %cl,%edi
  800fdb:	89 c1                	mov    %eax,%ecx
  800fdd:	89 f0                	mov    %esi,%eax
  800fdf:	d3 e3                	shl    %cl,%ebx
  800fe1:	89 d1                	mov    %edx,%ecx
  800fe3:	89 fa                	mov    %edi,%edx
  800fe5:	d3 e8                	shr    %cl,%eax
  800fe7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fec:	09 d8                	or     %ebx,%eax
  800fee:	f7 f5                	div    %ebp
  800ff0:	d3 e6                	shl    %cl,%esi
  800ff2:	89 d1                	mov    %edx,%ecx
  800ff4:	f7 64 24 08          	mull   0x8(%esp)
  800ff8:	39 d1                	cmp    %edx,%ecx
  800ffa:	89 c3                	mov    %eax,%ebx
  800ffc:	89 d7                	mov    %edx,%edi
  800ffe:	72 06                	jb     801006 <__umoddi3+0xa6>
  801000:	75 0e                	jne    801010 <__umoddi3+0xb0>
  801002:	39 c6                	cmp    %eax,%esi
  801004:	73 0a                	jae    801010 <__umoddi3+0xb0>
  801006:	2b 44 24 08          	sub    0x8(%esp),%eax
  80100a:	19 ea                	sbb    %ebp,%edx
  80100c:	89 d7                	mov    %edx,%edi
  80100e:	89 c3                	mov    %eax,%ebx
  801010:	89 ca                	mov    %ecx,%edx
  801012:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801017:	29 de                	sub    %ebx,%esi
  801019:	19 fa                	sbb    %edi,%edx
  80101b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80101f:	89 d0                	mov    %edx,%eax
  801021:	d3 e0                	shl    %cl,%eax
  801023:	89 d9                	mov    %ebx,%ecx
  801025:	d3 ee                	shr    %cl,%esi
  801027:	d3 ea                	shr    %cl,%edx
  801029:	09 f0                	or     %esi,%eax
  80102b:	83 c4 1c             	add    $0x1c,%esp
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    
  801033:	90                   	nop
  801034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801038:	85 ff                	test   %edi,%edi
  80103a:	89 f9                	mov    %edi,%ecx
  80103c:	75 0b                	jne    801049 <__umoddi3+0xe9>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	31 d2                	xor    %edx,%edx
  801045:	f7 f7                	div    %edi
  801047:	89 c1                	mov    %eax,%ecx
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	31 d2                	xor    %edx,%edx
  80104d:	f7 f1                	div    %ecx
  80104f:	89 f0                	mov    %esi,%eax
  801051:	f7 f1                	div    %ecx
  801053:	e9 31 ff ff ff       	jmp    800f89 <__umoddi3+0x29>
  801058:	90                   	nop
  801059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801060:	39 dd                	cmp    %ebx,%ebp
  801062:	72 08                	jb     80106c <__umoddi3+0x10c>
  801064:	39 f7                	cmp    %esi,%edi
  801066:	0f 87 21 ff ff ff    	ja     800f8d <__umoddi3+0x2d>
  80106c:	89 da                	mov    %ebx,%edx
  80106e:	89 f0                	mov    %esi,%eax
  801070:	29 f8                	sub    %edi,%eax
  801072:	19 ea                	sbb    %ebp,%edx
  801074:	e9 14 ff ff ff       	jmp    800f8d <__umoddi3+0x2d>
