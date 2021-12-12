
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
  800045:	68 20 10 80 00       	push   $0x801020
  80004a:	e8 0e 01 00 00       	call   80015d <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 22 0b 00 00       	call   800b76 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 d9 0a 00 00       	call   800b35 <sys_env_destroy>
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
  80006c:	e8 f2 0c 00 00       	call   800d63 <set_pgfault_handler>
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
  800083:	83 ec 08             	sub    $0x8,%esp
  800086:	8b 45 08             	mov    0x8(%ebp),%eax
  800089:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80008c:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  800093:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800096:	85 c0                	test   %eax,%eax
  800098:	7e 08                	jle    8000a2 <libmain+0x22>
		binaryname = argv[0];
  80009a:	8b 0a                	mov    (%edx),%ecx
  80009c:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	52                   	push   %edx
  8000a6:	50                   	push   %eax
  8000a7:	e8 b5 ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000ac:	e8 05 00 00 00       	call   8000b6 <exit>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 72 0a 00 00       	call   800b35 <sys_env_destroy>
}
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	c9                   	leave  
  8000c7:	c3                   	ret    

008000c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	53                   	push   %ebx
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d2:	8b 13                	mov    (%ebx),%edx
  8000d4:	8d 42 01             	lea    0x1(%edx),%eax
  8000d7:	89 03                	mov    %eax,(%ebx)
  8000d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e5:	74 09                	je     8000f0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ee:	c9                   	leave  
  8000ef:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	68 ff 00 00 00       	push   $0xff
  8000f8:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 f7 09 00 00       	call   800af8 <sys_cputs>
		b->idx = 0;
  800101:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	eb db                	jmp    8000e7 <putch+0x1f>

0080010c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800115:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011c:	00 00 00 
	b.cnt = 0;
  80011f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800126:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800129:	ff 75 0c             	pushl  0xc(%ebp)
  80012c:	ff 75 08             	pushl  0x8(%ebp)
  80012f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800135:	50                   	push   %eax
  800136:	68 c8 00 80 00       	push   $0x8000c8
  80013b:	e8 1a 01 00 00       	call   80025a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800140:	83 c4 08             	add    $0x8,%esp
  800143:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800149:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014f:	50                   	push   %eax
  800150:	e8 a3 09 00 00       	call   800af8 <sys_cputs>

	return b.cnt;
}
  800155:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    

0080015d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800163:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800166:	50                   	push   %eax
  800167:	ff 75 08             	pushl  0x8(%ebp)
  80016a:	e8 9d ff ff ff       	call   80010c <vcprintf>
	va_end(ap);

	return cnt;
}
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	57                   	push   %edi
  800175:	56                   	push   %esi
  800176:	53                   	push   %ebx
  800177:	83 ec 1c             	sub    $0x1c,%esp
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 d6                	mov    %edx,%esi
  80017e:	8b 45 08             	mov    0x8(%ebp),%eax
  800181:	8b 55 0c             	mov    0xc(%ebp),%edx
  800184:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800187:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80018a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80018d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800192:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800195:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800198:	39 d3                	cmp    %edx,%ebx
  80019a:	72 05                	jb     8001a1 <printnum+0x30>
  80019c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80019f:	77 7a                	ja     80021b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 18             	pushl  0x18(%ebp)
  8001a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8001aa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ad:	53                   	push   %ebx
  8001ae:	ff 75 10             	pushl  0x10(%ebp)
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c0:	e8 1b 0c 00 00       	call   800de0 <__udivdi3>
  8001c5:	83 c4 18             	add    $0x18,%esp
  8001c8:	52                   	push   %edx
  8001c9:	50                   	push   %eax
  8001ca:	89 f2                	mov    %esi,%edx
  8001cc:	89 f8                	mov    %edi,%eax
  8001ce:	e8 9e ff ff ff       	call   800171 <printnum>
  8001d3:	83 c4 20             	add    $0x20,%esp
  8001d6:	eb 13                	jmp    8001eb <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	56                   	push   %esi
  8001dc:	ff 75 18             	pushl  0x18(%ebp)
  8001df:	ff d7                	call   *%edi
  8001e1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e4:	83 eb 01             	sub    $0x1,%ebx
  8001e7:	85 db                	test   %ebx,%ebx
  8001e9:	7f ed                	jg     8001d8 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	56                   	push   %esi
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fe:	e8 fd 0c 00 00       	call   800f00 <__umoddi3>
  800203:	83 c4 14             	add    $0x14,%esp
  800206:	0f be 80 46 10 80 00 	movsbl 0x801046(%eax),%eax
  80020d:	50                   	push   %eax
  80020e:	ff d7                	call   *%edi
}
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5f                   	pop    %edi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    
  80021b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80021e:	eb c4                	jmp    8001e4 <printnum+0x73>

00800220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800226:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	3b 50 04             	cmp    0x4(%eax),%edx
  80022f:	73 0a                	jae    80023b <sprintputch+0x1b>
		*b->buf++ = ch;
  800231:	8d 4a 01             	lea    0x1(%edx),%ecx
  800234:	89 08                	mov    %ecx,(%eax)
  800236:	8b 45 08             	mov    0x8(%ebp),%eax
  800239:	88 02                	mov    %al,(%edx)
}
  80023b:	5d                   	pop    %ebp
  80023c:	c3                   	ret    

0080023d <printfmt>:
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800243:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 10             	pushl  0x10(%ebp)
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 05 00 00 00       	call   80025a <vprintfmt>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <vprintfmt>:
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	83 ec 2c             	sub    $0x2c,%esp
  800263:	8b 75 08             	mov    0x8(%ebp),%esi
  800266:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800269:	8b 7d 10             	mov    0x10(%ebp),%edi
  80026c:	e9 00 04 00 00       	jmp    800671 <vprintfmt+0x417>
		padc = ' ';
  800271:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800275:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80027c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800283:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80028a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80028f:	8d 47 01             	lea    0x1(%edi),%eax
  800292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800295:	0f b6 17             	movzbl (%edi),%edx
  800298:	8d 42 dd             	lea    -0x23(%edx),%eax
  80029b:	3c 55                	cmp    $0x55,%al
  80029d:	0f 87 51 04 00 00    	ja     8006f4 <vprintfmt+0x49a>
  8002a3:	0f b6 c0             	movzbl %al,%eax
  8002a6:	ff 24 85 00 11 80 00 	jmp    *0x801100(,%eax,4)
  8002ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002b4:	eb d9                	jmp    80028f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002bd:	eb d0                	jmp    80028f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002bf:	0f b6 d2             	movzbl %dl,%edx
  8002c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ca:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002cd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002d4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002d7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002da:	83 f9 09             	cmp    $0x9,%ecx
  8002dd:	77 55                	ja     800334 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002df:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e2:	eb e9                	jmp    8002cd <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
  8002e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ef:	8d 40 04             	lea    0x4(%eax),%eax
  8002f2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002fc:	79 91                	jns    80028f <vprintfmt+0x35>
				width = precision, precision = -1;
  8002fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800301:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800304:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80030b:	eb 82                	jmp    80028f <vprintfmt+0x35>
  80030d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800310:	85 c0                	test   %eax,%eax
  800312:	ba 00 00 00 00       	mov    $0x0,%edx
  800317:	0f 49 d0             	cmovns %eax,%edx
  80031a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800320:	e9 6a ff ff ff       	jmp    80028f <vprintfmt+0x35>
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800328:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80032f:	e9 5b ff ff ff       	jmp    80028f <vprintfmt+0x35>
  800334:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800337:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80033a:	eb bc                	jmp    8002f8 <vprintfmt+0x9e>
			lflag++;
  80033c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800342:	e9 48 ff ff ff       	jmp    80028f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800347:	8b 45 14             	mov    0x14(%ebp),%eax
  80034a:	8d 78 04             	lea    0x4(%eax),%edi
  80034d:	83 ec 08             	sub    $0x8,%esp
  800350:	53                   	push   %ebx
  800351:	ff 30                	pushl  (%eax)
  800353:	ff d6                	call   *%esi
			break;
  800355:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800358:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80035b:	e9 0e 03 00 00       	jmp    80066e <vprintfmt+0x414>
			err = va_arg(ap, int);
  800360:	8b 45 14             	mov    0x14(%ebp),%eax
  800363:	8d 78 04             	lea    0x4(%eax),%edi
  800366:	8b 00                	mov    (%eax),%eax
  800368:	99                   	cltd   
  800369:	31 d0                	xor    %edx,%eax
  80036b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80036d:	83 f8 08             	cmp    $0x8,%eax
  800370:	7f 23                	jg     800395 <vprintfmt+0x13b>
  800372:	8b 14 85 60 12 80 00 	mov    0x801260(,%eax,4),%edx
  800379:	85 d2                	test   %edx,%edx
  80037b:	74 18                	je     800395 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80037d:	52                   	push   %edx
  80037e:	68 67 10 80 00       	push   $0x801067
  800383:	53                   	push   %ebx
  800384:	56                   	push   %esi
  800385:	e8 b3 fe ff ff       	call   80023d <printfmt>
  80038a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800390:	e9 d9 02 00 00       	jmp    80066e <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800395:	50                   	push   %eax
  800396:	68 5e 10 80 00       	push   $0x80105e
  80039b:	53                   	push   %ebx
  80039c:	56                   	push   %esi
  80039d:	e8 9b fe ff ff       	call   80023d <printfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a8:	e9 c1 02 00 00       	jmp    80066e <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	83 c0 04             	add    $0x4,%eax
  8003b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003bb:	85 ff                	test   %edi,%edi
  8003bd:	b8 57 10 80 00       	mov    $0x801057,%eax
  8003c2:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c9:	0f 8e bd 00 00 00    	jle    80048c <vprintfmt+0x232>
  8003cf:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003d3:	75 0e                	jne    8003e3 <vprintfmt+0x189>
  8003d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003db:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003de:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003e1:	eb 6d                	jmp    800450 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e9:	57                   	push   %edi
  8003ea:	e8 ad 03 00 00       	call   80079c <strnlen>
  8003ef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f2:	29 c1                	sub    %eax,%ecx
  8003f4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003f7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003fa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800401:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800404:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800406:	eb 0f                	jmp    800417 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	53                   	push   %ebx
  80040c:	ff 75 e0             	pushl  -0x20(%ebp)
  80040f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800411:	83 ef 01             	sub    $0x1,%edi
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	85 ff                	test   %edi,%edi
  800419:	7f ed                	jg     800408 <vprintfmt+0x1ae>
  80041b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80041e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800421:	85 c9                	test   %ecx,%ecx
  800423:	b8 00 00 00 00       	mov    $0x0,%eax
  800428:	0f 49 c1             	cmovns %ecx,%eax
  80042b:	29 c1                	sub    %eax,%ecx
  80042d:	89 75 08             	mov    %esi,0x8(%ebp)
  800430:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800433:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800436:	89 cb                	mov    %ecx,%ebx
  800438:	eb 16                	jmp    800450 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80043a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80043e:	75 31                	jne    800471 <vprintfmt+0x217>
					putch(ch, putdat);
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	ff 75 0c             	pushl  0xc(%ebp)
  800446:	50                   	push   %eax
  800447:	ff 55 08             	call   *0x8(%ebp)
  80044a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80044d:	83 eb 01             	sub    $0x1,%ebx
  800450:	83 c7 01             	add    $0x1,%edi
  800453:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800457:	0f be c2             	movsbl %dl,%eax
  80045a:	85 c0                	test   %eax,%eax
  80045c:	74 59                	je     8004b7 <vprintfmt+0x25d>
  80045e:	85 f6                	test   %esi,%esi
  800460:	78 d8                	js     80043a <vprintfmt+0x1e0>
  800462:	83 ee 01             	sub    $0x1,%esi
  800465:	79 d3                	jns    80043a <vprintfmt+0x1e0>
  800467:	89 df                	mov    %ebx,%edi
  800469:	8b 75 08             	mov    0x8(%ebp),%esi
  80046c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046f:	eb 37                	jmp    8004a8 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800471:	0f be d2             	movsbl %dl,%edx
  800474:	83 ea 20             	sub    $0x20,%edx
  800477:	83 fa 5e             	cmp    $0x5e,%edx
  80047a:	76 c4                	jbe    800440 <vprintfmt+0x1e6>
					putch('?', putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 0c             	pushl  0xc(%ebp)
  800482:	6a 3f                	push   $0x3f
  800484:	ff 55 08             	call   *0x8(%ebp)
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	eb c1                	jmp    80044d <vprintfmt+0x1f3>
  80048c:	89 75 08             	mov    %esi,0x8(%ebp)
  80048f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800492:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800495:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800498:	eb b6                	jmp    800450 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	53                   	push   %ebx
  80049e:	6a 20                	push   $0x20
  8004a0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a2:	83 ef 01             	sub    $0x1,%edi
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	85 ff                	test   %edi,%edi
  8004aa:	7f ee                	jg     80049a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004af:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b2:	e9 b7 01 00 00       	jmp    80066e <vprintfmt+0x414>
  8004b7:	89 df                	mov    %ebx,%edi
  8004b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bf:	eb e7                	jmp    8004a8 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004c1:	83 f9 01             	cmp    $0x1,%ecx
  8004c4:	7e 3f                	jle    800505 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	8b 50 04             	mov    0x4(%eax),%edx
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 40 08             	lea    0x8(%eax),%eax
  8004da:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e1:	79 5c                	jns    80053f <vprintfmt+0x2e5>
				putch('-', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 2d                	push   $0x2d
  8004e9:	ff d6                	call   *%esi
				num = -(long long) num;
  8004eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004ee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f1:	f7 da                	neg    %edx
  8004f3:	83 d1 00             	adc    $0x0,%ecx
  8004f6:	f7 d9                	neg    %ecx
  8004f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800500:	e9 4f 01 00 00       	jmp    800654 <vprintfmt+0x3fa>
	else if (lflag)
  800505:	85 c9                	test   %ecx,%ecx
  800507:	75 1b                	jne    800524 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	89 c1                	mov    %eax,%ecx
  800513:	c1 f9 1f             	sar    $0x1f,%ecx
  800516:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	eb b9                	jmp    8004dd <vprintfmt+0x283>
		return va_arg(*ap, long);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	c1 f9 1f             	sar    $0x1f,%ecx
  800531:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 40 04             	lea    0x4(%eax),%eax
  80053a:	89 45 14             	mov    %eax,0x14(%ebp)
  80053d:	eb 9e                	jmp    8004dd <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80053f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800542:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800545:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054a:	e9 05 01 00 00       	jmp    800654 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80054f:	83 f9 01             	cmp    $0x1,%ecx
  800552:	7e 18                	jle    80056c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8b 10                	mov    (%eax),%edx
  800559:	8b 48 04             	mov    0x4(%eax),%ecx
  80055c:	8d 40 08             	lea    0x8(%eax),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800562:	b8 0a 00 00 00       	mov    $0xa,%eax
  800567:	e9 e8 00 00 00       	jmp    800654 <vprintfmt+0x3fa>
	else if (lflag)
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	75 1a                	jne    80058a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 10                	mov    (%eax),%edx
  800575:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057a:	8d 40 04             	lea    0x4(%eax),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800580:	b8 0a 00 00 00       	mov    $0xa,%eax
  800585:	e9 ca 00 00 00       	jmp    800654 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 10                	mov    (%eax),%edx
  80058f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059f:	e9 b0 00 00 00       	jmp    800654 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005a4:	83 f9 01             	cmp    $0x1,%ecx
  8005a7:	7e 3c                	jle    8005e5 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 50 04             	mov    0x4(%eax),%edx
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 40 08             	lea    0x8(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005c4:	79 59                	jns    80061f <vprintfmt+0x3c5>
                putch('-', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 2d                	push   $0x2d
  8005cc:	ff d6                	call   *%esi
                num = -(long long) num;
  8005ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d4:	f7 da                	neg    %edx
  8005d6:	83 d1 00             	adc    $0x0,%ecx
  8005d9:	f7 d9                	neg    %ecx
  8005db:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005de:	b8 08 00 00 00       	mov    $0x8,%eax
  8005e3:	eb 6f                	jmp    800654 <vprintfmt+0x3fa>
	else if (lflag)
  8005e5:	85 c9                	test   %ecx,%ecx
  8005e7:	75 1b                	jne    800604 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f1:	89 c1                	mov    %eax,%ecx
  8005f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800602:	eb bc                	jmp    8005c0 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	c1 f9 1f             	sar    $0x1f,%ecx
  800611:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 40 04             	lea    0x4(%eax),%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
  80061d:	eb a1                	jmp    8005c0 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80061f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800622:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800625:	b8 08 00 00 00       	mov    $0x8,%eax
  80062a:	eb 28                	jmp    800654 <vprintfmt+0x3fa>
			putch('0', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	53                   	push   %ebx
  800630:	6a 30                	push   $0x30
  800632:	ff d6                	call   *%esi
			putch('x', putdat);
  800634:	83 c4 08             	add    $0x8,%esp
  800637:	53                   	push   %ebx
  800638:	6a 78                	push   $0x78
  80063a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 10                	mov    (%eax),%edx
  800641:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800646:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80065b:	57                   	push   %edi
  80065c:	ff 75 e0             	pushl  -0x20(%ebp)
  80065f:	50                   	push   %eax
  800660:	51                   	push   %ecx
  800661:	52                   	push   %edx
  800662:	89 da                	mov    %ebx,%edx
  800664:	89 f0                	mov    %esi,%eax
  800666:	e8 06 fb ff ff       	call   800171 <printnum>
			break;
  80066b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80066e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800671:	83 c7 01             	add    $0x1,%edi
  800674:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800678:	83 f8 25             	cmp    $0x25,%eax
  80067b:	0f 84 f0 fb ff ff    	je     800271 <vprintfmt+0x17>
			if (ch == '\0')
  800681:	85 c0                	test   %eax,%eax
  800683:	0f 84 8b 00 00 00    	je     800714 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	50                   	push   %eax
  80068e:	ff d6                	call   *%esi
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	eb dc                	jmp    800671 <vprintfmt+0x417>
	if (lflag >= 2)
  800695:	83 f9 01             	cmp    $0x1,%ecx
  800698:	7e 15                	jle    8006af <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a2:	8d 40 08             	lea    0x8(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ad:	eb a5                	jmp    800654 <vprintfmt+0x3fa>
	else if (lflag)
  8006af:	85 c9                	test   %ecx,%ecx
  8006b1:	75 17                	jne    8006ca <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 10                	mov    (%eax),%edx
  8006b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bd:	8d 40 04             	lea    0x4(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c8:	eb 8a                	jmp    800654 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 10                	mov    (%eax),%edx
  8006cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006da:	b8 10 00 00 00       	mov    $0x10,%eax
  8006df:	e9 70 ff ff ff       	jmp    800654 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	6a 25                	push   $0x25
  8006ea:	ff d6                	call   *%esi
			break;
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	e9 7a ff ff ff       	jmp    80066e <vprintfmt+0x414>
			putch('%', putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	6a 25                	push   $0x25
  8006fa:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	89 f8                	mov    %edi,%eax
  800701:	eb 03                	jmp    800706 <vprintfmt+0x4ac>
  800703:	83 e8 01             	sub    $0x1,%eax
  800706:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80070a:	75 f7                	jne    800703 <vprintfmt+0x4a9>
  80070c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80070f:	e9 5a ff ff ff       	jmp    80066e <vprintfmt+0x414>
}
  800714:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800717:	5b                   	pop    %ebx
  800718:	5e                   	pop    %esi
  800719:	5f                   	pop    %edi
  80071a:	5d                   	pop    %ebp
  80071b:	c3                   	ret    

0080071c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 18             	sub    $0x18,%esp
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800728:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80072b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80072f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800739:	85 c0                	test   %eax,%eax
  80073b:	74 26                	je     800763 <vsnprintf+0x47>
  80073d:	85 d2                	test   %edx,%edx
  80073f:	7e 22                	jle    800763 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800741:	ff 75 14             	pushl  0x14(%ebp)
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80074a:	50                   	push   %eax
  80074b:	68 20 02 80 00       	push   $0x800220
  800750:	e8 05 fb ff ff       	call   80025a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800758:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075e:	83 c4 10             	add    $0x10,%esp
}
  800761:	c9                   	leave  
  800762:	c3                   	ret    
		return -E_INVAL;
  800763:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800768:	eb f7                	jmp    800761 <vsnprintf+0x45>

0080076a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800770:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800773:	50                   	push   %eax
  800774:	ff 75 10             	pushl  0x10(%ebp)
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	ff 75 08             	pushl  0x8(%ebp)
  80077d:	e8 9a ff ff ff       	call   80071c <vsnprintf>
	va_end(ap);

	return rc;
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80078a:	b8 00 00 00 00       	mov    $0x0,%eax
  80078f:	eb 03                	jmp    800794 <strlen+0x10>
		n++;
  800791:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800794:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800798:	75 f7                	jne    800791 <strlen+0xd>
	return n;
}
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	eb 03                	jmp    8007af <strnlen+0x13>
		n++;
  8007ac:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007af:	39 d0                	cmp    %edx,%eax
  8007b1:	74 06                	je     8007b9 <strnlen+0x1d>
  8007b3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007b7:	75 f3                	jne    8007ac <strnlen+0x10>
	return n;
}
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	53                   	push   %ebx
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	83 c1 01             	add    $0x1,%ecx
  8007ca:	83 c2 01             	add    $0x1,%edx
  8007cd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007d1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007d4:	84 db                	test   %bl,%bl
  8007d6:	75 ef                	jne    8007c7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007d8:	5b                   	pop    %ebx
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	53                   	push   %ebx
  8007df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e2:	53                   	push   %ebx
  8007e3:	e8 9c ff ff ff       	call   800784 <strlen>
  8007e8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	01 d8                	add    %ebx,%eax
  8007f0:	50                   	push   %eax
  8007f1:	e8 c5 ff ff ff       	call   8007bb <strcpy>
	return dst;
}
  8007f6:	89 d8                	mov    %ebx,%eax
  8007f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	56                   	push   %esi
  800801:	53                   	push   %ebx
  800802:	8b 75 08             	mov    0x8(%ebp),%esi
  800805:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800808:	89 f3                	mov    %esi,%ebx
  80080a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80080d:	89 f2                	mov    %esi,%edx
  80080f:	eb 0f                	jmp    800820 <strncpy+0x23>
		*dst++ = *src;
  800811:	83 c2 01             	add    $0x1,%edx
  800814:	0f b6 01             	movzbl (%ecx),%eax
  800817:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80081a:	80 39 01             	cmpb   $0x1,(%ecx)
  80081d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800820:	39 da                	cmp    %ebx,%edx
  800822:	75 ed                	jne    800811 <strncpy+0x14>
	}
	return ret;
}
  800824:	89 f0                	mov    %esi,%eax
  800826:	5b                   	pop    %ebx
  800827:	5e                   	pop    %esi
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    

0080082a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	56                   	push   %esi
  80082e:	53                   	push   %ebx
  80082f:	8b 75 08             	mov    0x8(%ebp),%esi
  800832:	8b 55 0c             	mov    0xc(%ebp),%edx
  800835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800838:	89 f0                	mov    %esi,%eax
  80083a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80083e:	85 c9                	test   %ecx,%ecx
  800840:	75 0b                	jne    80084d <strlcpy+0x23>
  800842:	eb 17                	jmp    80085b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800844:	83 c2 01             	add    $0x1,%edx
  800847:	83 c0 01             	add    $0x1,%eax
  80084a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80084d:	39 d8                	cmp    %ebx,%eax
  80084f:	74 07                	je     800858 <strlcpy+0x2e>
  800851:	0f b6 0a             	movzbl (%edx),%ecx
  800854:	84 c9                	test   %cl,%cl
  800856:	75 ec                	jne    800844 <strlcpy+0x1a>
		*dst = '\0';
  800858:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80085b:	29 f0                	sub    %esi,%eax
}
  80085d:	5b                   	pop    %ebx
  80085e:	5e                   	pop    %esi
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80086a:	eb 06                	jmp    800872 <strcmp+0x11>
		p++, q++;
  80086c:	83 c1 01             	add    $0x1,%ecx
  80086f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800872:	0f b6 01             	movzbl (%ecx),%eax
  800875:	84 c0                	test   %al,%al
  800877:	74 04                	je     80087d <strcmp+0x1c>
  800879:	3a 02                	cmp    (%edx),%al
  80087b:	74 ef                	je     80086c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80087d:	0f b6 c0             	movzbl %al,%eax
  800880:	0f b6 12             	movzbl (%edx),%edx
  800883:	29 d0                	sub    %edx,%eax
}
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800891:	89 c3                	mov    %eax,%ebx
  800893:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800896:	eb 06                	jmp    80089e <strncmp+0x17>
		n--, p++, q++;
  800898:	83 c0 01             	add    $0x1,%eax
  80089b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80089e:	39 d8                	cmp    %ebx,%eax
  8008a0:	74 16                	je     8008b8 <strncmp+0x31>
  8008a2:	0f b6 08             	movzbl (%eax),%ecx
  8008a5:	84 c9                	test   %cl,%cl
  8008a7:	74 04                	je     8008ad <strncmp+0x26>
  8008a9:	3a 0a                	cmp    (%edx),%cl
  8008ab:	74 eb                	je     800898 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ad:	0f b6 00             	movzbl (%eax),%eax
  8008b0:	0f b6 12             	movzbl (%edx),%edx
  8008b3:	29 d0                	sub    %edx,%eax
}
  8008b5:	5b                   	pop    %ebx
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    
		return 0;
  8008b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bd:	eb f6                	jmp    8008b5 <strncmp+0x2e>

008008bf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c9:	0f b6 10             	movzbl (%eax),%edx
  8008cc:	84 d2                	test   %dl,%dl
  8008ce:	74 09                	je     8008d9 <strchr+0x1a>
		if (*s == c)
  8008d0:	38 ca                	cmp    %cl,%dl
  8008d2:	74 0a                	je     8008de <strchr+0x1f>
	for (; *s; s++)
  8008d4:	83 c0 01             	add    $0x1,%eax
  8008d7:	eb f0                	jmp    8008c9 <strchr+0xa>
			return (char *) s;
	return 0;
  8008d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ea:	eb 03                	jmp    8008ef <strfind+0xf>
  8008ec:	83 c0 01             	add    $0x1,%eax
  8008ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008f2:	38 ca                	cmp    %cl,%dl
  8008f4:	74 04                	je     8008fa <strfind+0x1a>
  8008f6:	84 d2                	test   %dl,%dl
  8008f8:	75 f2                	jne    8008ec <strfind+0xc>
			break;
	return (char *) s;
}
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	57                   	push   %edi
  800900:	56                   	push   %esi
  800901:	53                   	push   %ebx
  800902:	8b 7d 08             	mov    0x8(%ebp),%edi
  800905:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800908:	85 c9                	test   %ecx,%ecx
  80090a:	74 13                	je     80091f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80090c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800912:	75 05                	jne    800919 <memset+0x1d>
  800914:	f6 c1 03             	test   $0x3,%cl
  800917:	74 0d                	je     800926 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	fc                   	cld    
  80091d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80091f:	89 f8                	mov    %edi,%eax
  800921:	5b                   	pop    %ebx
  800922:	5e                   	pop    %esi
  800923:	5f                   	pop    %edi
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    
		c &= 0xFF;
  800926:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092a:	89 d3                	mov    %edx,%ebx
  80092c:	c1 e3 08             	shl    $0x8,%ebx
  80092f:	89 d0                	mov    %edx,%eax
  800931:	c1 e0 18             	shl    $0x18,%eax
  800934:	89 d6                	mov    %edx,%esi
  800936:	c1 e6 10             	shl    $0x10,%esi
  800939:	09 f0                	or     %esi,%eax
  80093b:	09 c2                	or     %eax,%edx
  80093d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80093f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800942:	89 d0                	mov    %edx,%eax
  800944:	fc                   	cld    
  800945:	f3 ab                	rep stos %eax,%es:(%edi)
  800947:	eb d6                	jmp    80091f <memset+0x23>

00800949 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	57                   	push   %edi
  80094d:	56                   	push   %esi
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 75 0c             	mov    0xc(%ebp),%esi
  800954:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800957:	39 c6                	cmp    %eax,%esi
  800959:	73 35                	jae    800990 <memmove+0x47>
  80095b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	76 2e                	jbe    800990 <memmove+0x47>
		s += n;
		d += n;
  800962:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800965:	89 d6                	mov    %edx,%esi
  800967:	09 fe                	or     %edi,%esi
  800969:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80096f:	74 0c                	je     80097d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800971:	83 ef 01             	sub    $0x1,%edi
  800974:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800977:	fd                   	std    
  800978:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80097a:	fc                   	cld    
  80097b:	eb 21                	jmp    80099e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097d:	f6 c1 03             	test   $0x3,%cl
  800980:	75 ef                	jne    800971 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800982:	83 ef 04             	sub    $0x4,%edi
  800985:	8d 72 fc             	lea    -0x4(%edx),%esi
  800988:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80098b:	fd                   	std    
  80098c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098e:	eb ea                	jmp    80097a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800990:	89 f2                	mov    %esi,%edx
  800992:	09 c2                	or     %eax,%edx
  800994:	f6 c2 03             	test   $0x3,%dl
  800997:	74 09                	je     8009a2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800999:	89 c7                	mov    %eax,%edi
  80099b:	fc                   	cld    
  80099c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80099e:	5e                   	pop    %esi
  80099f:	5f                   	pop    %edi
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a2:	f6 c1 03             	test   $0x3,%cl
  8009a5:	75 f2                	jne    800999 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009aa:	89 c7                	mov    %eax,%edi
  8009ac:	fc                   	cld    
  8009ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009af:	eb ed                	jmp    80099e <memmove+0x55>

008009b1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009b4:	ff 75 10             	pushl  0x10(%ebp)
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 87 ff ff ff       	call   800949 <memmove>
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	89 c6                	mov    %eax,%esi
  8009d1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d4:	39 f0                	cmp    %esi,%eax
  8009d6:	74 1c                	je     8009f4 <memcmp+0x30>
		if (*s1 != *s2)
  8009d8:	0f b6 08             	movzbl (%eax),%ecx
  8009db:	0f b6 1a             	movzbl (%edx),%ebx
  8009de:	38 d9                	cmp    %bl,%cl
  8009e0:	75 08                	jne    8009ea <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009e2:	83 c0 01             	add    $0x1,%eax
  8009e5:	83 c2 01             	add    $0x1,%edx
  8009e8:	eb ea                	jmp    8009d4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009ea:	0f b6 c1             	movzbl %cl,%eax
  8009ed:	0f b6 db             	movzbl %bl,%ebx
  8009f0:	29 d8                	sub    %ebx,%eax
  8009f2:	eb 05                	jmp    8009f9 <memcmp+0x35>
	}

	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a06:	89 c2                	mov    %eax,%edx
  800a08:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a0b:	39 d0                	cmp    %edx,%eax
  800a0d:	73 09                	jae    800a18 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a0f:	38 08                	cmp    %cl,(%eax)
  800a11:	74 05                	je     800a18 <memfind+0x1b>
	for (; s < ends; s++)
  800a13:	83 c0 01             	add    $0x1,%eax
  800a16:	eb f3                	jmp    800a0b <memfind+0xe>
			break;
	return (void *) s;
}
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	57                   	push   %edi
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a26:	eb 03                	jmp    800a2b <strtol+0x11>
		s++;
  800a28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a2b:	0f b6 01             	movzbl (%ecx),%eax
  800a2e:	3c 20                	cmp    $0x20,%al
  800a30:	74 f6                	je     800a28 <strtol+0xe>
  800a32:	3c 09                	cmp    $0x9,%al
  800a34:	74 f2                	je     800a28 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a36:	3c 2b                	cmp    $0x2b,%al
  800a38:	74 2e                	je     800a68 <strtol+0x4e>
	int neg = 0;
  800a3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a3f:	3c 2d                	cmp    $0x2d,%al
  800a41:	74 2f                	je     800a72 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a49:	75 05                	jne    800a50 <strtol+0x36>
  800a4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4e:	74 2c                	je     800a7c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	75 0a                	jne    800a5e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a54:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a59:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5c:	74 28                	je     800a86 <strtol+0x6c>
		base = 10;
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a63:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a66:	eb 50                	jmp    800ab8 <strtol+0x9e>
		s++;
  800a68:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a70:	eb d1                	jmp    800a43 <strtol+0x29>
		s++, neg = 1;
  800a72:	83 c1 01             	add    $0x1,%ecx
  800a75:	bf 01 00 00 00       	mov    $0x1,%edi
  800a7a:	eb c7                	jmp    800a43 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a80:	74 0e                	je     800a90 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	75 d8                	jne    800a5e <strtol+0x44>
		s++, base = 8;
  800a86:	83 c1 01             	add    $0x1,%ecx
  800a89:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a8e:	eb ce                	jmp    800a5e <strtol+0x44>
		s += 2, base = 16;
  800a90:	83 c1 02             	add    $0x2,%ecx
  800a93:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a98:	eb c4                	jmp    800a5e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a9a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a9d:	89 f3                	mov    %esi,%ebx
  800a9f:	80 fb 19             	cmp    $0x19,%bl
  800aa2:	77 29                	ja     800acd <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aa4:	0f be d2             	movsbl %dl,%edx
  800aa7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aaa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aad:	7d 30                	jge    800adf <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aaf:	83 c1 01             	add    $0x1,%ecx
  800ab2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab8:	0f b6 11             	movzbl (%ecx),%edx
  800abb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800abe:	89 f3                	mov    %esi,%ebx
  800ac0:	80 fb 09             	cmp    $0x9,%bl
  800ac3:	77 d5                	ja     800a9a <strtol+0x80>
			dig = *s - '0';
  800ac5:	0f be d2             	movsbl %dl,%edx
  800ac8:	83 ea 30             	sub    $0x30,%edx
  800acb:	eb dd                	jmp    800aaa <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800acd:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ad0:	89 f3                	mov    %esi,%ebx
  800ad2:	80 fb 19             	cmp    $0x19,%bl
  800ad5:	77 08                	ja     800adf <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ad7:	0f be d2             	movsbl %dl,%edx
  800ada:	83 ea 37             	sub    $0x37,%edx
  800add:	eb cb                	jmp    800aaa <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800adf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae3:	74 05                	je     800aea <strtol+0xd0>
		*endptr = (char *) s;
  800ae5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aea:	89 c2                	mov    %eax,%edx
  800aec:	f7 da                	neg    %edx
  800aee:	85 ff                	test   %edi,%edi
  800af0:	0f 45 c2             	cmovne %edx,%eax
}
  800af3:	5b                   	pop    %ebx
  800af4:	5e                   	pop    %esi
  800af5:	5f                   	pop    %edi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
    asm volatile("int %1\n"
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
  800b06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b09:	89 c3                	mov    %eax,%ebx
  800b0b:	89 c7                	mov    %eax,%edi
  800b0d:	89 c6                	mov    %eax,%esi
  800b0f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cgetc>:

int
sys_cgetc(void) {
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b21:	b8 01 00 00 00       	mov    $0x1,%eax
  800b26:	89 d1                	mov    %edx,%ecx
  800b28:	89 d3                	mov    %edx,%ebx
  800b2a:	89 d7                	mov    %edx,%edi
  800b2c:	89 d6                	mov    %edx,%esi
  800b2e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5f                   	pop    %edi
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	57                   	push   %edi
  800b39:	56                   	push   %esi
  800b3a:	53                   	push   %ebx
  800b3b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
  800b46:	b8 03 00 00 00       	mov    $0x3,%eax
  800b4b:	89 cb                	mov    %ecx,%ebx
  800b4d:	89 cf                	mov    %ecx,%edi
  800b4f:	89 ce                	mov    %ecx,%esi
  800b51:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b53:	85 c0                	test   %eax,%eax
  800b55:	7f 08                	jg     800b5f <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5a:	5b                   	pop    %ebx
  800b5b:	5e                   	pop    %esi
  800b5c:	5f                   	pop    %edi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b5f:	83 ec 0c             	sub    $0xc,%esp
  800b62:	50                   	push   %eax
  800b63:	6a 03                	push   $0x3
  800b65:	68 84 12 80 00       	push   $0x801284
  800b6a:	6a 24                	push   $0x24
  800b6c:	68 a1 12 80 00       	push   $0x8012a1
  800b71:	e8 1a 02 00 00       	call   800d90 <_panic>

00800b76 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b81:	b8 02 00 00 00       	mov    $0x2,%eax
  800b86:	89 d1                	mov    %edx,%ecx
  800b88:	89 d3                	mov    %edx,%ebx
  800b8a:	89 d7                	mov    %edx,%edi
  800b8c:	89 d6                	mov    %edx,%esi
  800b8e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <sys_yield>:

void
sys_yield(void)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba5:	89 d1                	mov    %edx,%ecx
  800ba7:	89 d3                	mov    %edx,%ebx
  800ba9:	89 d7                	mov    %edx,%edi
  800bab:	89 d6                	mov    %edx,%esi
  800bad:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bbd:	be 00 00 00 00       	mov    $0x0,%esi
  800bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd0:	89 f7                	mov    %esi,%edi
  800bd2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bd4:	85 c0                	test   %eax,%eax
  800bd6:	7f 08                	jg     800be0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800be0:	83 ec 0c             	sub    $0xc,%esp
  800be3:	50                   	push   %eax
  800be4:	6a 04                	push   $0x4
  800be6:	68 84 12 80 00       	push   $0x801284
  800beb:	6a 24                	push   $0x24
  800bed:	68 a1 12 80 00       	push   $0x8012a1
  800bf2:	e8 99 01 00 00       	call   800d90 <_panic>

00800bf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c06:	b8 05 00 00 00       	mov    $0x5,%eax
  800c0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c11:	8b 75 18             	mov    0x18(%ebp),%esi
  800c14:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	7f 08                	jg     800c22 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	50                   	push   %eax
  800c26:	6a 05                	push   $0x5
  800c28:	68 84 12 80 00       	push   $0x801284
  800c2d:	6a 24                	push   $0x24
  800c2f:	68 a1 12 80 00       	push   $0x8012a1
  800c34:	e8 57 01 00 00       	call   800d90 <_panic>

00800c39 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c47:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c52:	89 df                	mov    %ebx,%edi
  800c54:	89 de                	mov    %ebx,%esi
  800c56:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	7f 08                	jg     800c64 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c64:	83 ec 0c             	sub    $0xc,%esp
  800c67:	50                   	push   %eax
  800c68:	6a 06                	push   $0x6
  800c6a:	68 84 12 80 00       	push   $0x801284
  800c6f:	6a 24                	push   $0x24
  800c71:	68 a1 12 80 00       	push   $0x8012a1
  800c76:	e8 15 01 00 00       	call   800d90 <_panic>

00800c7b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
  800c81:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c94:	89 df                	mov    %ebx,%edi
  800c96:	89 de                	mov    %ebx,%esi
  800c98:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c9a:	85 c0                	test   %eax,%eax
  800c9c:	7f 08                	jg     800ca6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	50                   	push   %eax
  800caa:	6a 08                	push   $0x8
  800cac:	68 84 12 80 00       	push   $0x801284
  800cb1:	6a 24                	push   $0x24
  800cb3:	68 a1 12 80 00       	push   $0x8012a1
  800cb8:	e8 d3 00 00 00       	call   800d90 <_panic>

00800cbd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd1:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd6:	89 df                	mov    %ebx,%edi
  800cd8:	89 de                	mov    %ebx,%esi
  800cda:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7f 08                	jg     800ce8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	50                   	push   %eax
  800cec:	6a 09                	push   $0x9
  800cee:	68 84 12 80 00       	push   $0x801284
  800cf3:	6a 24                	push   $0x24
  800cf5:	68 a1 12 80 00       	push   $0x8012a1
  800cfa:	e8 91 00 00 00       	call   800d90 <_panic>

00800cff <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d10:	be 00 00 00 00       	mov    $0x0,%esi
  800d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d38:	89 cb                	mov    %ecx,%ebx
  800d3a:	89 cf                	mov    %ecx,%edi
  800d3c:	89 ce                	mov    %ecx,%esi
  800d3e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	7f 08                	jg     800d4c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	50                   	push   %eax
  800d50:	6a 0c                	push   $0xc
  800d52:	68 84 12 80 00       	push   $0x801284
  800d57:	6a 24                	push   $0x24
  800d59:	68 a1 12 80 00       	push   $0x8012a1
  800d5e:	e8 2d 00 00 00       	call   800d90 <_panic>

00800d63 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d69:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800d70:	74 0a                	je     800d7c <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    
		panic("set_pgfault_handler not implemented");
  800d7c:	83 ec 04             	sub    $0x4,%esp
  800d7f:	68 b0 12 80 00       	push   $0x8012b0
  800d84:	6a 20                	push   $0x20
  800d86:	68 d4 12 80 00       	push   $0x8012d4
  800d8b:	e8 00 00 00 00       	call   800d90 <_panic>

00800d90 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d95:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d98:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d9e:	e8 d3 fd ff ff       	call   800b76 <sys_getenvid>
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	ff 75 08             	pushl  0x8(%ebp)
  800dac:	56                   	push   %esi
  800dad:	50                   	push   %eax
  800dae:	68 e4 12 80 00       	push   $0x8012e4
  800db3:	e8 a5 f3 ff ff       	call   80015d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800db8:	83 c4 18             	add    $0x18,%esp
  800dbb:	53                   	push   %ebx
  800dbc:	ff 75 10             	pushl  0x10(%ebp)
  800dbf:	e8 48 f3 ff ff       	call   80010c <vcprintf>
	cprintf("\n");
  800dc4:	c7 04 24 3a 10 80 00 	movl   $0x80103a,(%esp)
  800dcb:	e8 8d f3 ff ff       	call   80015d <cprintf>
  800dd0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800dd3:	cc                   	int3   
  800dd4:	eb fd                	jmp    800dd3 <_panic+0x43>
  800dd6:	66 90                	xchg   %ax,%ax
  800dd8:	66 90                	xchg   %ax,%ax
  800dda:	66 90                	xchg   %ax,%ax
  800ddc:	66 90                	xchg   %ax,%ax
  800dde:	66 90                	xchg   %ax,%ax

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
