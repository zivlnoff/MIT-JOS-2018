
obj/user/hello：     文件格式 elf32-i386


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
  80002c:	e8 47 00 00 00       	call   800078 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
  80003a:	e8 35 00 00 00       	call   800074 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	cprintf("hello, world\n");
  800045:	8d 83 bc ee ff ff    	lea    -0x1144(%ebx),%eax
  80004b:	50                   	push   %eax
  80004c:	e8 42 01 00 00       	call   800193 <cprintf>
	//page fault  below why??
	cprintf("i am environment %08x\n", thisenv->env_id);
  800051:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  800057:	8b 00                	mov    (%eax),%eax
  800059:	8b 40 48             	mov    0x48(%eax),%eax
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	50                   	push   %eax
  800060:	8d 83 ca ee ff ff    	lea    -0x1136(%ebx),%eax
  800066:	50                   	push   %eax
  800067:	e8 27 01 00 00       	call   800193 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <__x86.get_pc_thunk.bx>:
  800074:	8b 1c 24             	mov    (%esp),%ebx
  800077:	c3                   	ret    

00800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	56                   	push   %esi
  80007c:	53                   	push   %ebx
  80007d:	e8 f2 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800082:	81 c3 7e 1f 00 00    	add    $0x1f7e,%ebx
  800088:	8b 45 08             	mov    0x8(%ebp),%eax
  80008b:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80008e:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  800094:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  80009a:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	85 c0                	test   %eax,%eax
  80009e:	7e 08                	jle    8000a8 <libmain+0x30>
		binaryname = argv[0];
  8000a0:	8b 0a                	mov    (%edx),%ecx
  8000a2:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	52                   	push   %edx
  8000ac:	50                   	push   %eax
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	53                   	push   %ebx
  8000c5:	83 ec 10             	sub    $0x10,%esp
  8000c8:	e8 a7 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  8000cd:	81 c3 33 1f 00 00    	add    $0x1f33,%ebx
	sys_env_destroy(0);
  8000d3:	6a 00                	push   $0x0
  8000d5:	e8 ca 0a 00 00       	call   800ba4 <sys_env_destroy>
}
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e0:	c9                   	leave  
  8000e1:	c3                   	ret    

008000e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 88 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  8000ec:	81 c3 14 1f 00 00    	add    $0x1f14,%ebx
  8000f2:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8000f5:	8b 16                	mov    (%esi),%edx
  8000f7:	8d 42 01             	lea    0x1(%edx),%eax
  8000fa:	89 06                	mov    %eax,(%esi)
  8000fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ff:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800103:	3d ff 00 00 00       	cmp    $0xff,%eax
  800108:	74 0b                	je     800115 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80010a:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80010e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800111:	5b                   	pop    %ebx
  800112:	5e                   	pop    %esi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	68 ff 00 00 00       	push   $0xff
  80011d:	8d 46 08             	lea    0x8(%esi),%eax
  800120:	50                   	push   %eax
  800121:	e8 41 0a 00 00       	call   800b67 <sys_cputs>
		b->idx = 0;
  800126:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	eb d9                	jmp    80010a <putch+0x28>

00800131 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	53                   	push   %ebx
  800135:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80013b:	e8 34 ff ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800140:	81 c3 c0 1e 00 00    	add    $0x1ec0,%ebx
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
  800167:	8d 83 e2 e0 ff ff    	lea    -0x1f1e(%ebx),%eax
  80016d:	50                   	push   %eax
  80016e:	e8 38 01 00 00       	call   8002ab <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800173:	83 c4 08             	add    $0x8,%esp
  800176:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	e8 df 09 00 00       	call   800b67 <sys_cputs>

	return b.cnt;
}
  800188:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800199:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019c:	50                   	push   %eax
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	e8 8c ff ff ff       	call   800131 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	57                   	push   %edi
  8001ab:	56                   	push   %esi
  8001ac:	53                   	push   %ebx
  8001ad:	83 ec 2c             	sub    $0x2c,%esp
  8001b0:	e8 3a 06 00 00       	call   8007ef <__x86.get_pc_thunk.cx>
  8001b5:	81 c1 4b 1e 00 00    	add    $0x1e4b,%ecx
  8001bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 d6                	mov    %edx,%esi
  8001c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8001d9:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8001dc:	39 d3                	cmp    %edx,%ebx
  8001de:	72 09                	jb     8001e9 <printnum+0x42>
  8001e0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001e3:	0f 87 83 00 00 00    	ja     80026c <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	ff 75 18             	pushl  0x18(%ebp)
  8001ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001f5:	53                   	push   %ebx
  8001f6:	ff 75 10             	pushl  0x10(%ebp)
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	ff 75 d4             	pushl  -0x2c(%ebp)
  800205:	ff 75 d0             	pushl  -0x30(%ebp)
  800208:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80020b:	e8 70 0a 00 00       	call   800c80 <__udivdi3>
  800210:	83 c4 18             	add    $0x18,%esp
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	89 f2                	mov    %esi,%edx
  800217:	89 f8                	mov    %edi,%eax
  800219:	e8 89 ff ff ff       	call   8001a7 <printnum>
  80021e:	83 c4 20             	add    $0x20,%esp
  800221:	eb 13                	jmp    800236 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	56                   	push   %esi
  800227:	ff 75 18             	pushl  0x18(%ebp)
  80022a:	ff d7                	call   *%edi
  80022c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80022f:	83 eb 01             	sub    $0x1,%ebx
  800232:	85 db                	test   %ebx,%ebx
  800234:	7f ed                	jg     800223 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	56                   	push   %esi
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 dc             	pushl  -0x24(%ebp)
  800240:	ff 75 d8             	pushl  -0x28(%ebp)
  800243:	ff 75 d4             	pushl  -0x2c(%ebp)
  800246:	ff 75 d0             	pushl  -0x30(%ebp)
  800249:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80024c:	89 f3                	mov    %esi,%ebx
  80024e:	e8 4d 0b 00 00       	call   800da0 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 84 06 eb ee ff 	movsbl -0x1115(%esi,%eax,1),%eax
  80025d:	ff 
  80025e:	50                   	push   %eax
  80025f:	ff d7                	call   *%edi
}
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    
  80026c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026f:	eb be                	jmp    80022f <printnum+0x88>

00800271 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800277:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027b:	8b 10                	mov    (%eax),%edx
  80027d:	3b 50 04             	cmp    0x4(%eax),%edx
  800280:	73 0a                	jae    80028c <sprintputch+0x1b>
		*b->buf++ = ch;
  800282:	8d 4a 01             	lea    0x1(%edx),%ecx
  800285:	89 08                	mov    %ecx,(%eax)
  800287:	8b 45 08             	mov    0x8(%ebp),%eax
  80028a:	88 02                	mov    %al,(%edx)
}
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <printfmt>:
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800294:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800297:	50                   	push   %eax
  800298:	ff 75 10             	pushl  0x10(%ebp)
  80029b:	ff 75 0c             	pushl  0xc(%ebp)
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 05 00 00 00       	call   8002ab <vprintfmt>
}
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <vprintfmt>:
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	57                   	push   %edi
  8002af:	56                   	push   %esi
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 2c             	sub    $0x2c,%esp
  8002b4:	e8 bb fd ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  8002b9:	81 c3 47 1d 00 00    	add    $0x1d47,%ebx
  8002bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c5:	e9 fb 03 00 00       	jmp    8006c5 <.L35+0x48>
		padc = ' ';
  8002ca:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d5:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8002dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e8:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002eb:	8d 47 01             	lea    0x1(%edi),%eax
  8002ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002f1:	0f b6 17             	movzbl (%edi),%edx
  8002f4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f7:	3c 55                	cmp    $0x55,%al
  8002f9:	0f 87 4e 04 00 00    	ja     80074d <.L22>
  8002ff:	0f b6 c0             	movzbl %al,%eax
  800302:	89 d9                	mov    %ebx,%ecx
  800304:	03 8c 83 78 ef ff ff 	add    -0x1088(%ebx,%eax,4),%ecx
  80030b:	ff e1                	jmp    *%ecx

0080030d <.L71>:
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800310:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800314:	eb d5                	jmp    8002eb <vprintfmt+0x40>

00800316 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  800316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800319:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80031d:	eb cc                	jmp    8002eb <vprintfmt+0x40>

0080031f <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	0f b6 d2             	movzbl %dl,%edx
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800325:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  80032a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80032d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800331:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800334:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800337:	83 f9 09             	cmp    $0x9,%ecx
  80033a:	77 55                	ja     800391 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  80033c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033f:	eb e9                	jmp    80032a <.L29+0xb>

00800341 <.L26>:
			precision = va_arg(ap, int);
  800341:	8b 45 14             	mov    0x14(%ebp),%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800349:	8b 45 14             	mov    0x14(%ebp),%eax
  80034c:	8d 40 04             	lea    0x4(%eax),%eax
  80034f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800355:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800359:	79 90                	jns    8002eb <vprintfmt+0x40>
				width = precision, precision = -1;
  80035b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80035e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800361:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800368:	eb 81                	jmp    8002eb <vprintfmt+0x40>

0080036a <.L27>:
  80036a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036d:	85 c0                	test   %eax,%eax
  80036f:	ba 00 00 00 00       	mov    $0x0,%edx
  800374:	0f 49 d0             	cmovns %eax,%edx
  800377:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80037d:	e9 69 ff ff ff       	jmp    8002eb <vprintfmt+0x40>

00800382 <.L23>:
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800385:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80038c:	e9 5a ff ff ff       	jmp    8002eb <vprintfmt+0x40>
  800391:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800394:	eb bf                	jmp    800355 <.L26+0x14>

00800396 <.L33>:
			lflag++;
  800396:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039d:	e9 49 ff ff ff       	jmp    8002eb <vprintfmt+0x40>

008003a2 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a5:	8d 78 04             	lea    0x4(%eax),%edi
  8003a8:	83 ec 08             	sub    $0x8,%esp
  8003ab:	56                   	push   %esi
  8003ac:	ff 30                	pushl  (%eax)
  8003ae:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003b1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b7:	e9 06 03 00 00       	jmp    8006c2 <.L35+0x45>

008003bc <.L32>:
			err = va_arg(ap, int);
  8003bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bf:	8d 78 04             	lea    0x4(%eax),%edi
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	99                   	cltd   
  8003c5:	31 d0                	xor    %edx,%eax
  8003c7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c9:	83 f8 06             	cmp    $0x6,%eax
  8003cc:	7f 27                	jg     8003f5 <.L32+0x39>
  8003ce:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8003d5:	85 d2                	test   %edx,%edx
  8003d7:	74 1c                	je     8003f5 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8003d9:	52                   	push   %edx
  8003da:	8d 83 0c ef ff ff    	lea    -0x10f4(%ebx),%eax
  8003e0:	50                   	push   %eax
  8003e1:	56                   	push   %esi
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 a4 fe ff ff       	call   80028e <printfmt>
  8003ea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ed:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f0:	e9 cd 02 00 00       	jmp    8006c2 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8003f5:	50                   	push   %eax
  8003f6:	8d 83 03 ef ff ff    	lea    -0x10fd(%ebx),%eax
  8003fc:	50                   	push   %eax
  8003fd:	56                   	push   %esi
  8003fe:	ff 75 08             	pushl  0x8(%ebp)
  800401:	e8 88 fe ff ff       	call   80028e <printfmt>
  800406:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80040c:	e9 b1 02 00 00       	jmp    8006c2 <.L35+0x45>

00800411 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	83 c0 04             	add    $0x4,%eax
  800417:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80041f:	85 ff                	test   %edi,%edi
  800421:	8d 83 fc ee ff ff    	lea    -0x1104(%ebx),%eax
  800427:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80042a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042e:	0f 8e b5 00 00 00    	jle    8004e9 <.L36+0xd8>
  800434:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800438:	75 08                	jne    800442 <.L36+0x31>
  80043a:	89 75 0c             	mov    %esi,0xc(%ebp)
  80043d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800440:	eb 6d                	jmp    8004af <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 cc             	pushl  -0x34(%ebp)
  800448:	57                   	push   %edi
  800449:	e8 bd 03 00 00       	call   80080b <strnlen>
  80044e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800451:	29 c2                	sub    %eax,%edx
  800453:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800456:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800459:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80045d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800460:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800463:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800465:	eb 10                	jmp    800477 <.L36+0x66>
					putch(padc, putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	56                   	push   %esi
  80046b:	ff 75 e0             	pushl  -0x20(%ebp)
  80046e:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800471:	83 ef 01             	sub    $0x1,%edi
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	85 ff                	test   %edi,%edi
  800479:	7f ec                	jg     800467 <.L36+0x56>
  80047b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80047e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800481:	85 d2                	test   %edx,%edx
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	0f 49 c2             	cmovns %edx,%eax
  80048b:	29 c2                	sub    %eax,%edx
  80048d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800490:	89 75 0c             	mov    %esi,0xc(%ebp)
  800493:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800496:	eb 17                	jmp    8004af <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800498:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049c:	75 30                	jne    8004ce <.L36+0xbd>
					putch(ch, putdat);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	50                   	push   %eax
  8004a5:	ff 55 08             	call   *0x8(%ebp)
  8004a8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ab:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004af:	83 c7 01             	add    $0x1,%edi
  8004b2:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004b6:	0f be c2             	movsbl %dl,%eax
  8004b9:	85 c0                	test   %eax,%eax
  8004bb:	74 52                	je     80050f <.L36+0xfe>
  8004bd:	85 f6                	test   %esi,%esi
  8004bf:	78 d7                	js     800498 <.L36+0x87>
  8004c1:	83 ee 01             	sub    $0x1,%esi
  8004c4:	79 d2                	jns    800498 <.L36+0x87>
  8004c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004c9:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004cc:	eb 32                	jmp    800500 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ce:	0f be d2             	movsbl %dl,%edx
  8004d1:	83 ea 20             	sub    $0x20,%edx
  8004d4:	83 fa 5e             	cmp    $0x5e,%edx
  8004d7:	76 c5                	jbe    80049e <.L36+0x8d>
					putch('?', putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	6a 3f                	push   $0x3f
  8004e1:	ff 55 08             	call   *0x8(%ebp)
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	eb c2                	jmp    8004ab <.L36+0x9a>
  8004e9:	89 75 0c             	mov    %esi,0xc(%ebp)
  8004ec:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004ef:	eb be                	jmp    8004af <.L36+0x9e>
				putch(' ', putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	56                   	push   %esi
  8004f5:	6a 20                	push   $0x20
  8004f7:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8004fa:	83 ef 01             	sub    $0x1,%edi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	85 ff                	test   %edi,%edi
  800502:	7f ed                	jg     8004f1 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	e9 b3 01 00 00       	jmp    8006c2 <.L35+0x45>
  80050f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800512:	8b 75 0c             	mov    0xc(%ebp),%esi
  800515:	eb e9                	jmp    800500 <.L36+0xef>

00800517 <.L31>:
  800517:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80051a:	83 f9 01             	cmp    $0x1,%ecx
  80051d:	7e 40                	jle    80055f <.L31+0x48>
		return va_arg(*ap, long long);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8b 50 04             	mov    0x4(%eax),%edx
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 40 08             	lea    0x8(%eax),%eax
  800533:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800536:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80053a:	79 55                	jns    800591 <.L31+0x7a>
				putch('-', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	56                   	push   %esi
  800540:	6a 2d                	push   $0x2d
  800542:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800545:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800548:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80054b:	f7 da                	neg    %edx
  80054d:	83 d1 00             	adc    $0x0,%ecx
  800550:	f7 d9                	neg    %ecx
  800552:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800555:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055a:	e9 48 01 00 00       	jmp    8006a7 <.L35+0x2a>
	else if (lflag)
  80055f:	85 c9                	test   %ecx,%ecx
  800561:	75 17                	jne    80057a <.L31+0x63>
		return va_arg(*ap, int);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056b:	99                   	cltd   
  80056c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
  800578:	eb bc                	jmp    800536 <.L31+0x1f>
		return va_arg(*ap, long);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	99                   	cltd   
  800583:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8d 40 04             	lea    0x4(%eax),%eax
  80058c:	89 45 14             	mov    %eax,0x14(%ebp)
  80058f:	eb a5                	jmp    800536 <.L31+0x1f>
			num = getint(&ap, lflag);
  800591:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800594:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800597:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059c:	e9 06 01 00 00       	jmp    8006a7 <.L35+0x2a>

008005a1 <.L37>:
  8005a1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005a4:	83 f9 01             	cmp    $0x1,%ecx
  8005a7:	7e 18                	jle    8005c1 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 10                	mov    (%eax),%edx
  8005ae:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b1:	8d 40 08             	lea    0x8(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bc:	e9 e6 00 00 00       	jmp    8006a7 <.L35+0x2a>
	else if (lflag)
  8005c1:	85 c9                	test   %ecx,%ecx
  8005c3:	75 1a                	jne    8005df <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8b 10                	mov    (%eax),%edx
  8005ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cf:	8d 40 04             	lea    0x4(%eax),%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005da:	e9 c8 00 00 00       	jmp    8006a7 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 10                	mov    (%eax),%edx
  8005e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f4:	e9 ae 00 00 00       	jmp    8006a7 <.L35+0x2a>

008005f9 <.L34>:
  8005f9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005fc:	83 f9 01             	cmp    $0x1,%ecx
  8005ff:	7e 3d                	jle    80063e <.L34+0x45>
		return va_arg(*ap, long long);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 50 04             	mov    0x4(%eax),%edx
  800607:	8b 00                	mov    (%eax),%eax
  800609:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 40 08             	lea    0x8(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800618:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061c:	79 52                	jns    800670 <.L34+0x77>
                putch('-', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	56                   	push   %esi
  800622:	6a 2d                	push   $0x2d
  800624:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800627:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80062a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80062d:	f7 da                	neg    %edx
  80062f:	83 d1 00             	adc    $0x0,%ecx
  800632:	f7 d9                	neg    %ecx
  800634:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800637:	b8 08 00 00 00       	mov    $0x8,%eax
  80063c:	eb 69                	jmp    8006a7 <.L35+0x2a>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	75 17                	jne    800659 <.L34+0x60>
		return va_arg(*ap, int);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	99                   	cltd   
  80064b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 40 04             	lea    0x4(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
  800657:	eb bf                	jmp    800618 <.L34+0x1f>
		return va_arg(*ap, long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	99                   	cltd   
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	eb a8                	jmp    800618 <.L34+0x1f>
            num = getint(&ap, lflag);
  800670:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800673:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800676:	b8 08 00 00 00       	mov    $0x8,%eax
  80067b:	eb 2a                	jmp    8006a7 <.L35+0x2a>

0080067d <.L35>:
			putch('0', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	56                   	push   %esi
  800681:	6a 30                	push   $0x30
  800683:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800686:	83 c4 08             	add    $0x8,%esp
  800689:	56                   	push   %esi
  80068a:	6a 78                	push   $0x78
  80068c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 10                	mov    (%eax),%edx
  800694:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800699:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a7:	83 ec 0c             	sub    $0xc,%esp
  8006aa:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ae:	57                   	push   %edi
  8006af:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b2:	50                   	push   %eax
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	89 f2                	mov    %esi,%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	e8 e8 fa ff ff       	call   8001a7 <printnum>
			break;
  8006bf:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c5:	83 c7 01             	add    $0x1,%edi
  8006c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cc:	83 f8 25             	cmp    $0x25,%eax
  8006cf:	0f 84 f5 fb ff ff    	je     8002ca <vprintfmt+0x1f>
			if (ch == '\0')
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 84 91 00 00 00    	je     80076e <.L22+0x21>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	56                   	push   %esi
  8006e1:	50                   	push   %eax
  8006e2:	ff 55 08             	call   *0x8(%ebp)
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	eb db                	jmp    8006c5 <.L35+0x48>

008006ea <.L38>:
  8006ea:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006ed:	83 f9 01             	cmp    $0x1,%ecx
  8006f0:	7e 15                	jle    800707 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 10                	mov    (%eax),%edx
  8006f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fa:	8d 40 08             	lea    0x8(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800700:	b8 10 00 00 00       	mov    $0x10,%eax
  800705:	eb a0                	jmp    8006a7 <.L35+0x2a>
	else if (lflag)
  800707:	85 c9                	test   %ecx,%ecx
  800709:	75 17                	jne    800722 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 10                	mov    (%eax),%edx
  800710:	b9 00 00 00 00       	mov    $0x0,%ecx
  800715:	8d 40 04             	lea    0x4(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071b:	b8 10 00 00 00       	mov    $0x10,%eax
  800720:	eb 85                	jmp    8006a7 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 10                	mov    (%eax),%edx
  800727:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800732:	b8 10 00 00 00       	mov    $0x10,%eax
  800737:	e9 6b ff ff ff       	jmp    8006a7 <.L35+0x2a>

0080073c <.L25>:
			putch(ch, putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	56                   	push   %esi
  800740:	6a 25                	push   $0x25
  800742:	ff 55 08             	call   *0x8(%ebp)
			break;
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	e9 75 ff ff ff       	jmp    8006c2 <.L35+0x45>

0080074d <.L22>:
			putch('%', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	56                   	push   %esi
  800751:	6a 25                	push   $0x25
  800753:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	89 f8                	mov    %edi,%eax
  80075b:	eb 03                	jmp    800760 <.L22+0x13>
  80075d:	83 e8 01             	sub    $0x1,%eax
  800760:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800764:	75 f7                	jne    80075d <.L22+0x10>
  800766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800769:	e9 54 ff ff ff       	jmp    8006c2 <.L35+0x45>
}
  80076e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800771:	5b                   	pop    %ebx
  800772:	5e                   	pop    %esi
  800773:	5f                   	pop    %edi
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	53                   	push   %ebx
  80077a:	83 ec 14             	sub    $0x14,%esp
  80077d:	e8 f2 f8 ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800782:	81 c3 7e 18 00 00    	add    $0x187e,%ebx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800791:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800795:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079f:	85 c0                	test   %eax,%eax
  8007a1:	74 2b                	je     8007ce <vsnprintf+0x58>
  8007a3:	85 d2                	test   %edx,%edx
  8007a5:	7e 27                	jle    8007ce <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a7:	ff 75 14             	pushl  0x14(%ebp)
  8007aa:	ff 75 10             	pushl  0x10(%ebp)
  8007ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	8d 83 71 e2 ff ff    	lea    -0x1d8f(%ebx),%eax
  8007b7:	50                   	push   %eax
  8007b8:	e8 ee fa ff ff       	call   8002ab <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
}
  8007c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    
		return -E_INVAL;
  8007ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d3:	eb f4                	jmp    8007c9 <vsnprintf+0x53>

008007d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007de:	50                   	push   %eax
  8007df:	ff 75 10             	pushl  0x10(%ebp)
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	ff 75 08             	pushl  0x8(%ebp)
  8007e8:	e8 89 ff ff ff       	call   800776 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    

008007ef <__x86.get_pc_thunk.cx>:
  8007ef:	8b 0c 24             	mov    (%esp),%ecx
  8007f2:	c3                   	ret    

008007f3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fe:	eb 03                	jmp    800803 <strlen+0x10>
		n++;
  800800:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800807:	75 f7                	jne    800800 <strlen+0xd>
	return n;
}
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800811:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800814:	b8 00 00 00 00       	mov    $0x0,%eax
  800819:	eb 03                	jmp    80081e <strnlen+0x13>
		n++;
  80081b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081e:	39 d0                	cmp    %edx,%eax
  800820:	74 06                	je     800828 <strnlen+0x1d>
  800822:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800826:	75 f3                	jne    80081b <strnlen+0x10>
	return n;
}
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    

0080082a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	53                   	push   %ebx
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800834:	89 c2                	mov    %eax,%edx
  800836:	83 c1 01             	add    $0x1,%ecx
  800839:	83 c2 01             	add    $0x1,%edx
  80083c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800840:	88 5a ff             	mov    %bl,-0x1(%edx)
  800843:	84 db                	test   %bl,%bl
  800845:	75 ef                	jne    800836 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800847:	5b                   	pop    %ebx
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	53                   	push   %ebx
  80084e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800851:	53                   	push   %ebx
  800852:	e8 9c ff ff ff       	call   8007f3 <strlen>
  800857:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	01 d8                	add    %ebx,%eax
  80085f:	50                   	push   %eax
  800860:	e8 c5 ff ff ff       	call   80082a <strcpy>
	return dst;
}
  800865:	89 d8                	mov    %ebx,%eax
  800867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	56                   	push   %esi
  800870:	53                   	push   %ebx
  800871:	8b 75 08             	mov    0x8(%ebp),%esi
  800874:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800877:	89 f3                	mov    %esi,%ebx
  800879:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80087c:	89 f2                	mov    %esi,%edx
  80087e:	eb 0f                	jmp    80088f <strncpy+0x23>
		*dst++ = *src;
  800880:	83 c2 01             	add    $0x1,%edx
  800883:	0f b6 01             	movzbl (%ecx),%eax
  800886:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800889:	80 39 01             	cmpb   $0x1,(%ecx)
  80088c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80088f:	39 da                	cmp    %ebx,%edx
  800891:	75 ed                	jne    800880 <strncpy+0x14>
	}
	return ret;
}
  800893:	89 f0                	mov    %esi,%eax
  800895:	5b                   	pop    %ebx
  800896:	5e                   	pop    %esi
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	56                   	push   %esi
  80089d:	53                   	push   %ebx
  80089e:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a7:	89 f0                	mov    %esi,%eax
  8008a9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ad:	85 c9                	test   %ecx,%ecx
  8008af:	75 0b                	jne    8008bc <strlcpy+0x23>
  8008b1:	eb 17                	jmp    8008ca <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b3:	83 c2 01             	add    $0x1,%edx
  8008b6:	83 c0 01             	add    $0x1,%eax
  8008b9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008bc:	39 d8                	cmp    %ebx,%eax
  8008be:	74 07                	je     8008c7 <strlcpy+0x2e>
  8008c0:	0f b6 0a             	movzbl (%edx),%ecx
  8008c3:	84 c9                	test   %cl,%cl
  8008c5:	75 ec                	jne    8008b3 <strlcpy+0x1a>
		*dst = '\0';
  8008c7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ca:	29 f0                	sub    %esi,%eax
}
  8008cc:	5b                   	pop    %ebx
  8008cd:	5e                   	pop    %esi
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d9:	eb 06                	jmp    8008e1 <strcmp+0x11>
		p++, q++;
  8008db:	83 c1 01             	add    $0x1,%ecx
  8008de:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008e1:	0f b6 01             	movzbl (%ecx),%eax
  8008e4:	84 c0                	test   %al,%al
  8008e6:	74 04                	je     8008ec <strcmp+0x1c>
  8008e8:	3a 02                	cmp    (%edx),%al
  8008ea:	74 ef                	je     8008db <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ec:	0f b6 c0             	movzbl %al,%eax
  8008ef:	0f b6 12             	movzbl (%edx),%edx
  8008f2:	29 d0                	sub    %edx,%eax
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	53                   	push   %ebx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800900:	89 c3                	mov    %eax,%ebx
  800902:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800905:	eb 06                	jmp    80090d <strncmp+0x17>
		n--, p++, q++;
  800907:	83 c0 01             	add    $0x1,%eax
  80090a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80090d:	39 d8                	cmp    %ebx,%eax
  80090f:	74 16                	je     800927 <strncmp+0x31>
  800911:	0f b6 08             	movzbl (%eax),%ecx
  800914:	84 c9                	test   %cl,%cl
  800916:	74 04                	je     80091c <strncmp+0x26>
  800918:	3a 0a                	cmp    (%edx),%cl
  80091a:	74 eb                	je     800907 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80091c:	0f b6 00             	movzbl (%eax),%eax
  80091f:	0f b6 12             	movzbl (%edx),%edx
  800922:	29 d0                	sub    %edx,%eax
}
  800924:	5b                   	pop    %ebx
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    
		return 0;
  800927:	b8 00 00 00 00       	mov    $0x0,%eax
  80092c:	eb f6                	jmp    800924 <strncmp+0x2e>

0080092e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800938:	0f b6 10             	movzbl (%eax),%edx
  80093b:	84 d2                	test   %dl,%dl
  80093d:	74 09                	je     800948 <strchr+0x1a>
		if (*s == c)
  80093f:	38 ca                	cmp    %cl,%dl
  800941:	74 0a                	je     80094d <strchr+0x1f>
	for (; *s; s++)
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	eb f0                	jmp    800938 <strchr+0xa>
			return (char *) s;
	return 0;
  800948:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800959:	eb 03                	jmp    80095e <strfind+0xf>
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800961:	38 ca                	cmp    %cl,%dl
  800963:	74 04                	je     800969 <strfind+0x1a>
  800965:	84 d2                	test   %dl,%dl
  800967:	75 f2                	jne    80095b <strfind+0xc>
			break;
	return (char *) s;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	57                   	push   %edi
  80096f:	56                   	push   %esi
  800970:	53                   	push   %ebx
  800971:	8b 7d 08             	mov    0x8(%ebp),%edi
  800974:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800977:	85 c9                	test   %ecx,%ecx
  800979:	74 13                	je     80098e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800981:	75 05                	jne    800988 <memset+0x1d>
  800983:	f6 c1 03             	test   $0x3,%cl
  800986:	74 0d                	je     800995 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	fc                   	cld    
  80098c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098e:	89 f8                	mov    %edi,%eax
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5f                   	pop    %edi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    
		c &= 0xFF;
  800995:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800999:	89 d3                	mov    %edx,%ebx
  80099b:	c1 e3 08             	shl    $0x8,%ebx
  80099e:	89 d0                	mov    %edx,%eax
  8009a0:	c1 e0 18             	shl    $0x18,%eax
  8009a3:	89 d6                	mov    %edx,%esi
  8009a5:	c1 e6 10             	shl    $0x10,%esi
  8009a8:	09 f0                	or     %esi,%eax
  8009aa:	09 c2                	or     %eax,%edx
  8009ac:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009ae:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b1:	89 d0                	mov    %edx,%eax
  8009b3:	fc                   	cld    
  8009b4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b6:	eb d6                	jmp    80098e <memset+0x23>

008009b8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	57                   	push   %edi
  8009bc:	56                   	push   %esi
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c6:	39 c6                	cmp    %eax,%esi
  8009c8:	73 35                	jae    8009ff <memmove+0x47>
  8009ca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cd:	39 c2                	cmp    %eax,%edx
  8009cf:	76 2e                	jbe    8009ff <memmove+0x47>
		s += n;
		d += n;
  8009d1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	89 d6                	mov    %edx,%esi
  8009d6:	09 fe                	or     %edi,%esi
  8009d8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009de:	74 0c                	je     8009ec <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e0:	83 ef 01             	sub    $0x1,%edi
  8009e3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e6:	fd                   	std    
  8009e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e9:	fc                   	cld    
  8009ea:	eb 21                	jmp    800a0d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	f6 c1 03             	test   $0x3,%cl
  8009ef:	75 ef                	jne    8009e0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f1:	83 ef 04             	sub    $0x4,%edi
  8009f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009fa:	fd                   	std    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb ea                	jmp    8009e9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ff:	89 f2                	mov    %esi,%edx
  800a01:	09 c2                	or     %eax,%edx
  800a03:	f6 c2 03             	test   $0x3,%dl
  800a06:	74 09                	je     800a11 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a08:	89 c7                	mov    %eax,%edi
  800a0a:	fc                   	cld    
  800a0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a0d:	5e                   	pop    %esi
  800a0e:	5f                   	pop    %edi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a11:	f6 c1 03             	test   $0x3,%cl
  800a14:	75 f2                	jne    800a08 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a19:	89 c7                	mov    %eax,%edi
  800a1b:	fc                   	cld    
  800a1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1e:	eb ed                	jmp    800a0d <memmove+0x55>

00800a20 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a23:	ff 75 10             	pushl  0x10(%ebp)
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	ff 75 08             	pushl  0x8(%ebp)
  800a2c:	e8 87 ff ff ff       	call   8009b8 <memmove>
}
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    

00800a33 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	56                   	push   %esi
  800a37:	53                   	push   %ebx
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3e:	89 c6                	mov    %eax,%esi
  800a40:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a43:	39 f0                	cmp    %esi,%eax
  800a45:	74 1c                	je     800a63 <memcmp+0x30>
		if (*s1 != *s2)
  800a47:	0f b6 08             	movzbl (%eax),%ecx
  800a4a:	0f b6 1a             	movzbl (%edx),%ebx
  800a4d:	38 d9                	cmp    %bl,%cl
  800a4f:	75 08                	jne    800a59 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a51:	83 c0 01             	add    $0x1,%eax
  800a54:	83 c2 01             	add    $0x1,%edx
  800a57:	eb ea                	jmp    800a43 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a59:	0f b6 c1             	movzbl %cl,%eax
  800a5c:	0f b6 db             	movzbl %bl,%ebx
  800a5f:	29 d8                	sub    %ebx,%eax
  800a61:	eb 05                	jmp    800a68 <memcmp+0x35>
	}

	return 0;
  800a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a7a:	39 d0                	cmp    %edx,%eax
  800a7c:	73 09                	jae    800a87 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a7e:	38 08                	cmp    %cl,(%eax)
  800a80:	74 05                	je     800a87 <memfind+0x1b>
	for (; s < ends; s++)
  800a82:	83 c0 01             	add    $0x1,%eax
  800a85:	eb f3                	jmp    800a7a <memfind+0xe>
			break;
	return (void *) s;
}
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	57                   	push   %edi
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a95:	eb 03                	jmp    800a9a <strtol+0x11>
		s++;
  800a97:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a9a:	0f b6 01             	movzbl (%ecx),%eax
  800a9d:	3c 20                	cmp    $0x20,%al
  800a9f:	74 f6                	je     800a97 <strtol+0xe>
  800aa1:	3c 09                	cmp    $0x9,%al
  800aa3:	74 f2                	je     800a97 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aa5:	3c 2b                	cmp    $0x2b,%al
  800aa7:	74 2e                	je     800ad7 <strtol+0x4e>
	int neg = 0;
  800aa9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aae:	3c 2d                	cmp    $0x2d,%al
  800ab0:	74 2f                	je     800ae1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ab8:	75 05                	jne    800abf <strtol+0x36>
  800aba:	80 39 30             	cmpb   $0x30,(%ecx)
  800abd:	74 2c                	je     800aeb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800abf:	85 db                	test   %ebx,%ebx
  800ac1:	75 0a                	jne    800acd <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ac8:	80 39 30             	cmpb   $0x30,(%ecx)
  800acb:	74 28                	je     800af5 <strtol+0x6c>
		base = 10;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad5:	eb 50                	jmp    800b27 <strtol+0x9e>
		s++;
  800ad7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ada:	bf 00 00 00 00       	mov    $0x0,%edi
  800adf:	eb d1                	jmp    800ab2 <strtol+0x29>
		s++, neg = 1;
  800ae1:	83 c1 01             	add    $0x1,%ecx
  800ae4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae9:	eb c7                	jmp    800ab2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aeb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aef:	74 0e                	je     800aff <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800af1:	85 db                	test   %ebx,%ebx
  800af3:	75 d8                	jne    800acd <strtol+0x44>
		s++, base = 8;
  800af5:	83 c1 01             	add    $0x1,%ecx
  800af8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800afd:	eb ce                	jmp    800acd <strtol+0x44>
		s += 2, base = 16;
  800aff:	83 c1 02             	add    $0x2,%ecx
  800b02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b07:	eb c4                	jmp    800acd <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b09:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0c:	89 f3                	mov    %esi,%ebx
  800b0e:	80 fb 19             	cmp    $0x19,%bl
  800b11:	77 29                	ja     800b3c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b13:	0f be d2             	movsbl %dl,%edx
  800b16:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b19:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1c:	7d 30                	jge    800b4e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b1e:	83 c1 01             	add    $0x1,%ecx
  800b21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b27:	0f b6 11             	movzbl (%ecx),%edx
  800b2a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2d:	89 f3                	mov    %esi,%ebx
  800b2f:	80 fb 09             	cmp    $0x9,%bl
  800b32:	77 d5                	ja     800b09 <strtol+0x80>
			dig = *s - '0';
  800b34:	0f be d2             	movsbl %dl,%edx
  800b37:	83 ea 30             	sub    $0x30,%edx
  800b3a:	eb dd                	jmp    800b19 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b3f:	89 f3                	mov    %esi,%ebx
  800b41:	80 fb 19             	cmp    $0x19,%bl
  800b44:	77 08                	ja     800b4e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b46:	0f be d2             	movsbl %dl,%edx
  800b49:	83 ea 37             	sub    $0x37,%edx
  800b4c:	eb cb                	jmp    800b19 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b52:	74 05                	je     800b59 <strtol+0xd0>
		*endptr = (char *) s;
  800b54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b59:	89 c2                	mov    %eax,%edx
  800b5b:	f7 da                	neg    %edx
  800b5d:	85 ff                	test   %edi,%edi
  800b5f:	0f 45 c2             	cmovne %edx,%eax
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b78:	89 c3                	mov    %eax,%ebx
  800b7a:	89 c7                	mov    %eax,%edi
  800b7c:	89 c6                	mov    %eax,%esi
  800b7e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5f                   	pop    %edi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <sys_cgetc>:

int
sys_cgetc(void) {
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	57                   	push   %edi
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b90:	b8 01 00 00 00       	mov    $0x1,%eax
  800b95:	89 d1                	mov    %edx,%ecx
  800b97:	89 d3                	mov    %edx,%ebx
  800b99:	89 d7                	mov    %edx,%edi
  800b9b:	89 d6                	mov    %edx,%esi
  800b9d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
  800baa:	83 ec 1c             	sub    $0x1c,%esp
  800bad:	e8 66 00 00 00       	call   800c18 <__x86.get_pc_thunk.ax>
  800bb2:	05 4e 14 00 00       	add    $0x144e,%eax
  800bb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  800bba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc7:	89 cb                	mov    %ecx,%ebx
  800bc9:	89 cf                	mov    %ecx,%edi
  800bcb:	89 ce                	mov    %ecx,%esi
  800bcd:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	7f 08                	jg     800bdb <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bdb:	83 ec 0c             	sub    $0xc,%esp
  800bde:	50                   	push   %eax
  800bdf:	6a 03                	push   $0x3
  800be1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800be4:	8d 83 d0 f0 ff ff    	lea    -0xf30(%ebx),%eax
  800bea:	50                   	push   %eax
  800beb:	6a 24                	push   $0x24
  800bed:	8d 83 ed f0 ff ff    	lea    -0xf13(%ebx),%eax
  800bf3:	50                   	push   %eax
  800bf4:	e8 23 00 00 00       	call   800c1c <_panic>

00800bf9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bff:	ba 00 00 00 00       	mov    $0x0,%edx
  800c04:	b8 02 00 00 00       	mov    $0x2,%eax
  800c09:	89 d1                	mov    %edx,%ecx
  800c0b:	89 d3                	mov    %edx,%ebx
  800c0d:	89 d7                	mov    %edx,%edi
  800c0f:	89 d6                	mov    %edx,%esi
  800c11:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5f                   	pop    %edi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <__x86.get_pc_thunk.ax>:
  800c18:	8b 04 24             	mov    (%esp),%eax
  800c1b:	c3                   	ret    

00800c1c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	e8 4a f4 ff ff       	call   800074 <__x86.get_pc_thunk.bx>
  800c2a:	81 c3 d6 13 00 00    	add    $0x13d6,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c30:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c33:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c39:	8b 38                	mov    (%eax),%edi
  800c3b:	e8 b9 ff ff ff       	call   800bf9 <sys_getenvid>
  800c40:	83 ec 0c             	sub    $0xc,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	ff 75 08             	pushl  0x8(%ebp)
  800c49:	57                   	push   %edi
  800c4a:	50                   	push   %eax
  800c4b:	8d 83 fc f0 ff ff    	lea    -0xf04(%ebx),%eax
  800c51:	50                   	push   %eax
  800c52:	e8 3c f5 ff ff       	call   800193 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c57:	83 c4 18             	add    $0x18,%esp
  800c5a:	56                   	push   %esi
  800c5b:	ff 75 10             	pushl  0x10(%ebp)
  800c5e:	e8 ce f4 ff ff       	call   800131 <vcprintf>
	cprintf("\n");
  800c63:	8d 83 c8 ee ff ff    	lea    -0x1138(%ebx),%eax
  800c69:	89 04 24             	mov    %eax,(%esp)
  800c6c:	e8 22 f5 ff ff       	call   800193 <cprintf>
  800c71:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c74:	cc                   	int3   
  800c75:	eb fd                	jmp    800c74 <_panic+0x58>
  800c77:	66 90                	xchg   %ax,%ax
  800c79:	66 90                	xchg   %ax,%ax
  800c7b:	66 90                	xchg   %ax,%ax
  800c7d:	66 90                	xchg   %ax,%ax
  800c7f:	90                   	nop

00800c80 <__udivdi3>:
  800c80:	55                   	push   %ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 1c             	sub    $0x1c,%esp
  800c87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c97:	85 d2                	test   %edx,%edx
  800c99:	75 35                	jne    800cd0 <__udivdi3+0x50>
  800c9b:	39 f3                	cmp    %esi,%ebx
  800c9d:	0f 87 bd 00 00 00    	ja     800d60 <__udivdi3+0xe0>
  800ca3:	85 db                	test   %ebx,%ebx
  800ca5:	89 d9                	mov    %ebx,%ecx
  800ca7:	75 0b                	jne    800cb4 <__udivdi3+0x34>
  800ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  800cae:	31 d2                	xor    %edx,%edx
  800cb0:	f7 f3                	div    %ebx
  800cb2:	89 c1                	mov    %eax,%ecx
  800cb4:	31 d2                	xor    %edx,%edx
  800cb6:	89 f0                	mov    %esi,%eax
  800cb8:	f7 f1                	div    %ecx
  800cba:	89 c6                	mov    %eax,%esi
  800cbc:	89 e8                	mov    %ebp,%eax
  800cbe:	89 f7                	mov    %esi,%edi
  800cc0:	f7 f1                	div    %ecx
  800cc2:	89 fa                	mov    %edi,%edx
  800cc4:	83 c4 1c             	add    $0x1c,%esp
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
  800ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cd0:	39 f2                	cmp    %esi,%edx
  800cd2:	77 7c                	ja     800d50 <__udivdi3+0xd0>
  800cd4:	0f bd fa             	bsr    %edx,%edi
  800cd7:	83 f7 1f             	xor    $0x1f,%edi
  800cda:	0f 84 98 00 00 00    	je     800d78 <__udivdi3+0xf8>
  800ce0:	89 f9                	mov    %edi,%ecx
  800ce2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ce7:	29 f8                	sub    %edi,%eax
  800ce9:	d3 e2                	shl    %cl,%edx
  800ceb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800cef:	89 c1                	mov    %eax,%ecx
  800cf1:	89 da                	mov    %ebx,%edx
  800cf3:	d3 ea                	shr    %cl,%edx
  800cf5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cf9:	09 d1                	or     %edx,%ecx
  800cfb:	89 f2                	mov    %esi,%edx
  800cfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d01:	89 f9                	mov    %edi,%ecx
  800d03:	d3 e3                	shl    %cl,%ebx
  800d05:	89 c1                	mov    %eax,%ecx
  800d07:	d3 ea                	shr    %cl,%edx
  800d09:	89 f9                	mov    %edi,%ecx
  800d0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d0f:	d3 e6                	shl    %cl,%esi
  800d11:	89 eb                	mov    %ebp,%ebx
  800d13:	89 c1                	mov    %eax,%ecx
  800d15:	d3 eb                	shr    %cl,%ebx
  800d17:	09 de                	or     %ebx,%esi
  800d19:	89 f0                	mov    %esi,%eax
  800d1b:	f7 74 24 08          	divl   0x8(%esp)
  800d1f:	89 d6                	mov    %edx,%esi
  800d21:	89 c3                	mov    %eax,%ebx
  800d23:	f7 64 24 0c          	mull   0xc(%esp)
  800d27:	39 d6                	cmp    %edx,%esi
  800d29:	72 0c                	jb     800d37 <__udivdi3+0xb7>
  800d2b:	89 f9                	mov    %edi,%ecx
  800d2d:	d3 e5                	shl    %cl,%ebp
  800d2f:	39 c5                	cmp    %eax,%ebp
  800d31:	73 5d                	jae    800d90 <__udivdi3+0x110>
  800d33:	39 d6                	cmp    %edx,%esi
  800d35:	75 59                	jne    800d90 <__udivdi3+0x110>
  800d37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d3a:	31 ff                	xor    %edi,%edi
  800d3c:	89 fa                	mov    %edi,%edx
  800d3e:	83 c4 1c             	add    $0x1c,%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
  800d46:	8d 76 00             	lea    0x0(%esi),%esi
  800d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d50:	31 ff                	xor    %edi,%edi
  800d52:	31 c0                	xor    %eax,%eax
  800d54:	89 fa                	mov    %edi,%edx
  800d56:	83 c4 1c             	add    $0x1c,%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
  800d5e:	66 90                	xchg   %ax,%ax
  800d60:	31 ff                	xor    %edi,%edi
  800d62:	89 e8                	mov    %ebp,%eax
  800d64:	89 f2                	mov    %esi,%edx
  800d66:	f7 f3                	div    %ebx
  800d68:	89 fa                	mov    %edi,%edx
  800d6a:	83 c4 1c             	add    $0x1c,%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
  800d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d78:	39 f2                	cmp    %esi,%edx
  800d7a:	72 06                	jb     800d82 <__udivdi3+0x102>
  800d7c:	31 c0                	xor    %eax,%eax
  800d7e:	39 eb                	cmp    %ebp,%ebx
  800d80:	77 d2                	ja     800d54 <__udivdi3+0xd4>
  800d82:	b8 01 00 00 00       	mov    $0x1,%eax
  800d87:	eb cb                	jmp    800d54 <__udivdi3+0xd4>
  800d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d90:	89 d8                	mov    %ebx,%eax
  800d92:	31 ff                	xor    %edi,%edi
  800d94:	eb be                	jmp    800d54 <__udivdi3+0xd4>
  800d96:	66 90                	xchg   %ax,%ax
  800d98:	66 90                	xchg   %ax,%ax
  800d9a:	66 90                	xchg   %ax,%ax
  800d9c:	66 90                	xchg   %ax,%ax
  800d9e:	66 90                	xchg   %ax,%ax

00800da0 <__umoddi3>:
  800da0:	55                   	push   %ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 1c             	sub    $0x1c,%esp
  800da7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800dab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800daf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800db3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800db7:	85 ed                	test   %ebp,%ebp
  800db9:	89 f0                	mov    %esi,%eax
  800dbb:	89 da                	mov    %ebx,%edx
  800dbd:	75 19                	jne    800dd8 <__umoddi3+0x38>
  800dbf:	39 df                	cmp    %ebx,%edi
  800dc1:	0f 86 b1 00 00 00    	jbe    800e78 <__umoddi3+0xd8>
  800dc7:	f7 f7                	div    %edi
  800dc9:	89 d0                	mov    %edx,%eax
  800dcb:	31 d2                	xor    %edx,%edx
  800dcd:	83 c4 1c             	add    $0x1c,%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
  800dd5:	8d 76 00             	lea    0x0(%esi),%esi
  800dd8:	39 dd                	cmp    %ebx,%ebp
  800dda:	77 f1                	ja     800dcd <__umoddi3+0x2d>
  800ddc:	0f bd cd             	bsr    %ebp,%ecx
  800ddf:	83 f1 1f             	xor    $0x1f,%ecx
  800de2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800de6:	0f 84 b4 00 00 00    	je     800ea0 <__umoddi3+0x100>
  800dec:	b8 20 00 00 00       	mov    $0x20,%eax
  800df1:	89 c2                	mov    %eax,%edx
  800df3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 c1                	mov    %eax,%ecx
  800dfb:	89 f8                	mov    %edi,%eax
  800dfd:	d3 e5                	shl    %cl,%ebp
  800dff:	89 d1                	mov    %edx,%ecx
  800e01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e05:	d3 e8                	shr    %cl,%eax
  800e07:	09 c5                	or     %eax,%ebp
  800e09:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e0d:	89 c1                	mov    %eax,%ecx
  800e0f:	d3 e7                	shl    %cl,%edi
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	d3 ef                	shr    %cl,%edi
  800e1b:	89 c1                	mov    %eax,%ecx
  800e1d:	89 f0                	mov    %esi,%eax
  800e1f:	d3 e3                	shl    %cl,%ebx
  800e21:	89 d1                	mov    %edx,%ecx
  800e23:	89 fa                	mov    %edi,%edx
  800e25:	d3 e8                	shr    %cl,%eax
  800e27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e2c:	09 d8                	or     %ebx,%eax
  800e2e:	f7 f5                	div    %ebp
  800e30:	d3 e6                	shl    %cl,%esi
  800e32:	89 d1                	mov    %edx,%ecx
  800e34:	f7 64 24 08          	mull   0x8(%esp)
  800e38:	39 d1                	cmp    %edx,%ecx
  800e3a:	89 c3                	mov    %eax,%ebx
  800e3c:	89 d7                	mov    %edx,%edi
  800e3e:	72 06                	jb     800e46 <__umoddi3+0xa6>
  800e40:	75 0e                	jne    800e50 <__umoddi3+0xb0>
  800e42:	39 c6                	cmp    %eax,%esi
  800e44:	73 0a                	jae    800e50 <__umoddi3+0xb0>
  800e46:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e4a:	19 ea                	sbb    %ebp,%edx
  800e4c:	89 d7                	mov    %edx,%edi
  800e4e:	89 c3                	mov    %eax,%ebx
  800e50:	89 ca                	mov    %ecx,%edx
  800e52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e57:	29 de                	sub    %ebx,%esi
  800e59:	19 fa                	sbb    %edi,%edx
  800e5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e5f:	89 d0                	mov    %edx,%eax
  800e61:	d3 e0                	shl    %cl,%eax
  800e63:	89 d9                	mov    %ebx,%ecx
  800e65:	d3 ee                	shr    %cl,%esi
  800e67:	d3 ea                	shr    %cl,%edx
  800e69:	09 f0                	or     %esi,%eax
  800e6b:	83 c4 1c             	add    $0x1c,%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    
  800e73:	90                   	nop
  800e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e78:	85 ff                	test   %edi,%edi
  800e7a:	89 f9                	mov    %edi,%ecx
  800e7c:	75 0b                	jne    800e89 <__umoddi3+0xe9>
  800e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e83:	31 d2                	xor    %edx,%edx
  800e85:	f7 f7                	div    %edi
  800e87:	89 c1                	mov    %eax,%ecx
  800e89:	89 d8                	mov    %ebx,%eax
  800e8b:	31 d2                	xor    %edx,%edx
  800e8d:	f7 f1                	div    %ecx
  800e8f:	89 f0                	mov    %esi,%eax
  800e91:	f7 f1                	div    %ecx
  800e93:	e9 31 ff ff ff       	jmp    800dc9 <__umoddi3+0x29>
  800e98:	90                   	nop
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	39 dd                	cmp    %ebx,%ebp
  800ea2:	72 08                	jb     800eac <__umoddi3+0x10c>
  800ea4:	39 f7                	cmp    %esi,%edi
  800ea6:	0f 87 21 ff ff ff    	ja     800dcd <__umoddi3+0x2d>
  800eac:	89 da                	mov    %ebx,%edx
  800eae:	89 f0                	mov    %esi,%eax
  800eb0:	29 f8                	sub    %edi,%eax
  800eb2:	19 ea                	sbb    %ebp,%edx
  800eb4:	e9 14 ff ff ff       	jmp    800dcd <__umoddi3+0x2d>
