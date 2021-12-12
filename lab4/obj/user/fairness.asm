
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
  80003b:	e8 57 0b 00 00       	call   800b97 <sys_getenvid>
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
  800059:	e8 26 0d 00 00       	call   800d84 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80005e:	83 c4 0c             	add    $0xc,%esp
  800061:	ff 75 f4             	pushl  -0xc(%ebp)
  800064:	53                   	push   %ebx
  800065:	68 80 10 80 00       	push   $0x801080
  80006a:	e8 0f 01 00 00       	call   80017e <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	eb dd                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800074:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 91 10 80 00       	push   $0x801091
  800083:	e8 f6 00 00 00       	call   80017e <cprintf>
  800088:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80008b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	6a 00                	push   $0x0
  800096:	50                   	push   %eax
  800097:	e8 ff 0c 00 00       	call   800d9b <ipc_send>
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
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8000aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000ad:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8000b4:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	7e 08                	jle    8000c3 <libmain+0x22>
		binaryname = argv[0];
  8000bb:	8b 0a                	mov    (%edx),%ecx
  8000bd:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	e8 66 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cd:	e8 05 00 00 00       	call   8000d7 <exit>
}
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	c9                   	leave  
  8000d6:	c3                   	ret    

008000d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000dd:	6a 00                	push   $0x0
  8000df:	e8 72 0a 00 00       	call   800b56 <sys_env_destroy>
}
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	c9                   	leave  
  8000e8:	c3                   	ret    

008000e9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	53                   	push   %ebx
  8000ed:	83 ec 04             	sub    $0x4,%esp
  8000f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000f3:	8b 13                	mov    (%ebx),%edx
  8000f5:	8d 42 01             	lea    0x1(%edx),%eax
  8000f8:	89 03                	mov    %eax,(%ebx)
  8000fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000fd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800101:	3d ff 00 00 00       	cmp    $0xff,%eax
  800106:	74 09                	je     800111 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800108:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80010c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80010f:	c9                   	leave  
  800110:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	68 ff 00 00 00       	push   $0xff
  800119:	8d 43 08             	lea    0x8(%ebx),%eax
  80011c:	50                   	push   %eax
  80011d:	e8 f7 09 00 00       	call   800b19 <sys_cputs>
		b->idx = 0;
  800122:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb db                	jmp    800108 <putch+0x1f>

0080012d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800136:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80013d:	00 00 00 
	b.cnt = 0;
  800140:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800147:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80014a:	ff 75 0c             	pushl  0xc(%ebp)
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	68 e9 00 80 00       	push   $0x8000e9
  80015c:	e8 1a 01 00 00       	call   80027b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800161:	83 c4 08             	add    $0x8,%esp
  800164:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80016a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800170:	50                   	push   %eax
  800171:	e8 a3 09 00 00       	call   800b19 <sys_cputs>

	return b.cnt;
}
  800176:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800184:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800187:	50                   	push   %eax
  800188:	ff 75 08             	pushl  0x8(%ebp)
  80018b:	e8 9d ff ff ff       	call   80012d <vcprintf>
	va_end(ap);

	return cnt;
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	57                   	push   %edi
  800196:	56                   	push   %esi
  800197:	53                   	push   %ebx
  800198:	83 ec 1c             	sub    $0x1c,%esp
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	89 d6                	mov    %edx,%esi
  80019f:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001b3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001b6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b9:	39 d3                	cmp    %edx,%ebx
  8001bb:	72 05                	jb     8001c2 <printnum+0x30>
  8001bd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001c0:	77 7a                	ja     80023c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 18             	pushl  0x18(%ebp)
  8001c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8001cb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ce:	53                   	push   %ebx
  8001cf:	ff 75 10             	pushl  0x10(%ebp)
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001db:	ff 75 dc             	pushl  -0x24(%ebp)
  8001de:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e1:	e8 5a 0c 00 00       	call   800e40 <__udivdi3>
  8001e6:	83 c4 18             	add    $0x18,%esp
  8001e9:	52                   	push   %edx
  8001ea:	50                   	push   %eax
  8001eb:	89 f2                	mov    %esi,%edx
  8001ed:	89 f8                	mov    %edi,%eax
  8001ef:	e8 9e ff ff ff       	call   800192 <printnum>
  8001f4:	83 c4 20             	add    $0x20,%esp
  8001f7:	eb 13                	jmp    80020c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	ff d7                	call   *%edi
  800202:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800205:	83 eb 01             	sub    $0x1,%ebx
  800208:	85 db                	test   %ebx,%ebx
  80020a:	7f ed                	jg     8001f9 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	56                   	push   %esi
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	ff 75 e4             	pushl  -0x1c(%ebp)
  800216:	ff 75 e0             	pushl  -0x20(%ebp)
  800219:	ff 75 dc             	pushl  -0x24(%ebp)
  80021c:	ff 75 d8             	pushl  -0x28(%ebp)
  80021f:	e8 3c 0d 00 00       	call   800f60 <__umoddi3>
  800224:	83 c4 14             	add    $0x14,%esp
  800227:	0f be 80 b2 10 80 00 	movsbl 0x8010b2(%eax),%eax
  80022e:	50                   	push   %eax
  80022f:	ff d7                	call   *%edi
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800237:	5b                   	pop    %ebx
  800238:	5e                   	pop    %esi
  800239:	5f                   	pop    %edi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    
  80023c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80023f:	eb c4                	jmp    800205 <printnum+0x73>

00800241 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800247:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024b:	8b 10                	mov    (%eax),%edx
  80024d:	3b 50 04             	cmp    0x4(%eax),%edx
  800250:	73 0a                	jae    80025c <sprintputch+0x1b>
		*b->buf++ = ch;
  800252:	8d 4a 01             	lea    0x1(%edx),%ecx
  800255:	89 08                	mov    %ecx,(%eax)
  800257:	8b 45 08             	mov    0x8(%ebp),%eax
  80025a:	88 02                	mov    %al,(%edx)
}
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <printfmt>:
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800264:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800267:	50                   	push   %eax
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	e8 05 00 00 00       	call   80027b <vprintfmt>
}
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vprintfmt>:
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 2c             	sub    $0x2c,%esp
  800284:	8b 75 08             	mov    0x8(%ebp),%esi
  800287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028d:	e9 00 04 00 00       	jmp    800692 <vprintfmt+0x417>
		padc = ' ';
  800292:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800296:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80029d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ab:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b0:	8d 47 01             	lea    0x1(%edi),%eax
  8002b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002b6:	0f b6 17             	movzbl (%edi),%edx
  8002b9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002bc:	3c 55                	cmp    $0x55,%al
  8002be:	0f 87 51 04 00 00    	ja     800715 <vprintfmt+0x49a>
  8002c4:	0f b6 c0             	movzbl %al,%eax
  8002c7:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  8002ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d1:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002d5:	eb d9                	jmp    8002b0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002da:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002de:	eb d0                	jmp    8002b0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e0:	0f b6 d2             	movzbl %dl,%edx
  8002e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002eb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ee:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002f1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002f5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002f8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002fb:	83 f9 09             	cmp    $0x9,%ecx
  8002fe:	77 55                	ja     800355 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800300:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800303:	eb e9                	jmp    8002ee <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800305:	8b 45 14             	mov    0x14(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80030d:	8b 45 14             	mov    0x14(%ebp),%eax
  800310:	8d 40 04             	lea    0x4(%eax),%eax
  800313:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800319:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80031d:	79 91                	jns    8002b0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80031f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800322:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800325:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80032c:	eb 82                	jmp    8002b0 <vprintfmt+0x35>
  80032e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800331:	85 c0                	test   %eax,%eax
  800333:	ba 00 00 00 00       	mov    $0x0,%edx
  800338:	0f 49 d0             	cmovns %eax,%edx
  80033b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800341:	e9 6a ff ff ff       	jmp    8002b0 <vprintfmt+0x35>
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800349:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800350:	e9 5b ff ff ff       	jmp    8002b0 <vprintfmt+0x35>
  800355:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800358:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80035b:	eb bc                	jmp    800319 <vprintfmt+0x9e>
			lflag++;
  80035d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800363:	e9 48 ff ff ff       	jmp    8002b0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	8d 78 04             	lea    0x4(%eax),%edi
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	53                   	push   %ebx
  800372:	ff 30                	pushl  (%eax)
  800374:	ff d6                	call   *%esi
			break;
  800376:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800379:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80037c:	e9 0e 03 00 00       	jmp    80068f <vprintfmt+0x414>
			err = va_arg(ap, int);
  800381:	8b 45 14             	mov    0x14(%ebp),%eax
  800384:	8d 78 04             	lea    0x4(%eax),%edi
  800387:	8b 00                	mov    (%eax),%eax
  800389:	99                   	cltd   
  80038a:	31 d0                	xor    %edx,%eax
  80038c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80038e:	83 f8 08             	cmp    $0x8,%eax
  800391:	7f 23                	jg     8003b6 <vprintfmt+0x13b>
  800393:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  80039a:	85 d2                	test   %edx,%edx
  80039c:	74 18                	je     8003b6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80039e:	52                   	push   %edx
  80039f:	68 d3 10 80 00       	push   $0x8010d3
  8003a4:	53                   	push   %ebx
  8003a5:	56                   	push   %esi
  8003a6:	e8 b3 fe ff ff       	call   80025e <printfmt>
  8003ab:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ae:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b1:	e9 d9 02 00 00       	jmp    80068f <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003b6:	50                   	push   %eax
  8003b7:	68 ca 10 80 00       	push   $0x8010ca
  8003bc:	53                   	push   %ebx
  8003bd:	56                   	push   %esi
  8003be:	e8 9b fe ff ff       	call   80025e <printfmt>
  8003c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c9:	e9 c1 02 00 00       	jmp    80068f <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d1:	83 c0 04             	add    $0x4,%eax
  8003d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003dc:	85 ff                	test   %edi,%edi
  8003de:	b8 c3 10 80 00       	mov    $0x8010c3,%eax
  8003e3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ea:	0f 8e bd 00 00 00    	jle    8004ad <vprintfmt+0x232>
  8003f0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003f4:	75 0e                	jne    800404 <vprintfmt+0x189>
  8003f6:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003fc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800402:	eb 6d                	jmp    800471 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	ff 75 d0             	pushl  -0x30(%ebp)
  80040a:	57                   	push   %edi
  80040b:	e8 ad 03 00 00       	call   8007bd <strnlen>
  800410:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800413:	29 c1                	sub    %eax,%ecx
  800415:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800418:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80041b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80041f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800422:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800425:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800427:	eb 0f                	jmp    800438 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	53                   	push   %ebx
  80042d:	ff 75 e0             	pushl  -0x20(%ebp)
  800430:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800432:	83 ef 01             	sub    $0x1,%edi
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	85 ff                	test   %edi,%edi
  80043a:	7f ed                	jg     800429 <vprintfmt+0x1ae>
  80043c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80043f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800442:	85 c9                	test   %ecx,%ecx
  800444:	b8 00 00 00 00       	mov    $0x0,%eax
  800449:	0f 49 c1             	cmovns %ecx,%eax
  80044c:	29 c1                	sub    %eax,%ecx
  80044e:	89 75 08             	mov    %esi,0x8(%ebp)
  800451:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800454:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800457:	89 cb                	mov    %ecx,%ebx
  800459:	eb 16                	jmp    800471 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80045b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80045f:	75 31                	jne    800492 <vprintfmt+0x217>
					putch(ch, putdat);
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	ff 75 0c             	pushl  0xc(%ebp)
  800467:	50                   	push   %eax
  800468:	ff 55 08             	call   *0x8(%ebp)
  80046b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80046e:	83 eb 01             	sub    $0x1,%ebx
  800471:	83 c7 01             	add    $0x1,%edi
  800474:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800478:	0f be c2             	movsbl %dl,%eax
  80047b:	85 c0                	test   %eax,%eax
  80047d:	74 59                	je     8004d8 <vprintfmt+0x25d>
  80047f:	85 f6                	test   %esi,%esi
  800481:	78 d8                	js     80045b <vprintfmt+0x1e0>
  800483:	83 ee 01             	sub    $0x1,%esi
  800486:	79 d3                	jns    80045b <vprintfmt+0x1e0>
  800488:	89 df                	mov    %ebx,%edi
  80048a:	8b 75 08             	mov    0x8(%ebp),%esi
  80048d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800490:	eb 37                	jmp    8004c9 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800492:	0f be d2             	movsbl %dl,%edx
  800495:	83 ea 20             	sub    $0x20,%edx
  800498:	83 fa 5e             	cmp    $0x5e,%edx
  80049b:	76 c4                	jbe    800461 <vprintfmt+0x1e6>
					putch('?', putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 0c             	pushl  0xc(%ebp)
  8004a3:	6a 3f                	push   $0x3f
  8004a5:	ff 55 08             	call   *0x8(%ebp)
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	eb c1                	jmp    80046e <vprintfmt+0x1f3>
  8004ad:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b9:	eb b6                	jmp    800471 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	6a 20                	push   $0x20
  8004c1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c3:	83 ef 01             	sub    $0x1,%edi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	85 ff                	test   %edi,%edi
  8004cb:	7f ee                	jg     8004bb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d3:	e9 b7 01 00 00       	jmp    80068f <vprintfmt+0x414>
  8004d8:	89 df                	mov    %ebx,%edi
  8004da:	8b 75 08             	mov    0x8(%ebp),%esi
  8004dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e0:	eb e7                	jmp    8004c9 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004e2:	83 f9 01             	cmp    $0x1,%ecx
  8004e5:	7e 3f                	jle    800526 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f8:	8d 40 08             	lea    0x8(%eax),%eax
  8004fb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800502:	79 5c                	jns    800560 <vprintfmt+0x2e5>
				putch('-', putdat);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	53                   	push   %ebx
  800508:	6a 2d                	push   $0x2d
  80050a:	ff d6                	call   *%esi
				num = -(long long) num;
  80050c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80050f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800512:	f7 da                	neg    %edx
  800514:	83 d1 00             	adc    $0x0,%ecx
  800517:	f7 d9                	neg    %ecx
  800519:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80051c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800521:	e9 4f 01 00 00       	jmp    800675 <vprintfmt+0x3fa>
	else if (lflag)
  800526:	85 c9                	test   %ecx,%ecx
  800528:	75 1b                	jne    800545 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800532:	89 c1                	mov    %eax,%ecx
  800534:	c1 f9 1f             	sar    $0x1f,%ecx
  800537:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8d 40 04             	lea    0x4(%eax),%eax
  800540:	89 45 14             	mov    %eax,0x14(%ebp)
  800543:	eb b9                	jmp    8004fe <vprintfmt+0x283>
		return va_arg(*ap, long);
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054d:	89 c1                	mov    %eax,%ecx
  80054f:	c1 f9 1f             	sar    $0x1f,%ecx
  800552:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8d 40 04             	lea    0x4(%eax),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	eb 9e                	jmp    8004fe <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800560:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800563:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 05 01 00 00       	jmp    800675 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800570:	83 f9 01             	cmp    $0x1,%ecx
  800573:	7e 18                	jle    80058d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
  80057a:	8b 48 04             	mov    0x4(%eax),%ecx
  80057d:	8d 40 08             	lea    0x8(%eax),%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800583:	b8 0a 00 00 00       	mov    $0xa,%eax
  800588:	e9 e8 00 00 00       	jmp    800675 <vprintfmt+0x3fa>
	else if (lflag)
  80058d:	85 c9                	test   %ecx,%ecx
  80058f:	75 1a                	jne    8005ab <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a6:	e9 ca 00 00 00       	jmp    800675 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c0:	e9 b0 00 00 00       	jmp    800675 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005c5:	83 f9 01             	cmp    $0x1,%ecx
  8005c8:	7e 3c                	jle    800606 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 50 04             	mov    0x4(%eax),%edx
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 40 08             	lea    0x8(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8005e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e5:	79 59                	jns    800640 <vprintfmt+0x3c5>
                putch('-', putdat);
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 2d                	push   $0x2d
  8005ed:	ff d6                	call   *%esi
                num = -(long long) num;
  8005ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005f5:	f7 da                	neg    %edx
  8005f7:	83 d1 00             	adc    $0x0,%ecx
  8005fa:	f7 d9                	neg    %ecx
  8005fc:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8005ff:	b8 08 00 00 00       	mov    $0x8,%eax
  800604:	eb 6f                	jmp    800675 <vprintfmt+0x3fa>
	else if (lflag)
  800606:	85 c9                	test   %ecx,%ecx
  800608:	75 1b                	jne    800625 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800612:	89 c1                	mov    %eax,%ecx
  800614:	c1 f9 1f             	sar    $0x1f,%ecx
  800617:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 40 04             	lea    0x4(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	eb bc                	jmp    8005e1 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	c1 f9 1f             	sar    $0x1f,%ecx
  800632:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 40 04             	lea    0x4(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
  80063e:	eb a1                	jmp    8005e1 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800640:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800643:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800646:	b8 08 00 00 00       	mov    $0x8,%eax
  80064b:	eb 28                	jmp    800675 <vprintfmt+0x3fa>
			putch('0', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	53                   	push   %ebx
  800651:	6a 30                	push   $0x30
  800653:	ff d6                	call   *%esi
			putch('x', putdat);
  800655:	83 c4 08             	add    $0x8,%esp
  800658:	53                   	push   %ebx
  800659:	6a 78                	push   $0x78
  80065b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 10                	mov    (%eax),%edx
  800662:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800667:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800670:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800675:	83 ec 0c             	sub    $0xc,%esp
  800678:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80067c:	57                   	push   %edi
  80067d:	ff 75 e0             	pushl  -0x20(%ebp)
  800680:	50                   	push   %eax
  800681:	51                   	push   %ecx
  800682:	52                   	push   %edx
  800683:	89 da                	mov    %ebx,%edx
  800685:	89 f0                	mov    %esi,%eax
  800687:	e8 06 fb ff ff       	call   800192 <printnum>
			break;
  80068c:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80068f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800692:	83 c7 01             	add    $0x1,%edi
  800695:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800699:	83 f8 25             	cmp    $0x25,%eax
  80069c:	0f 84 f0 fb ff ff    	je     800292 <vprintfmt+0x17>
			if (ch == '\0')
  8006a2:	85 c0                	test   %eax,%eax
  8006a4:	0f 84 8b 00 00 00    	je     800735 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	50                   	push   %eax
  8006af:	ff d6                	call   *%esi
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	eb dc                	jmp    800692 <vprintfmt+0x417>
	if (lflag >= 2)
  8006b6:	83 f9 01             	cmp    $0x1,%ecx
  8006b9:	7e 15                	jle    8006d0 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 10                	mov    (%eax),%edx
  8006c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c3:	8d 40 08             	lea    0x8(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ce:	eb a5                	jmp    800675 <vprintfmt+0x3fa>
	else if (lflag)
  8006d0:	85 c9                	test   %ecx,%ecx
  8006d2:	75 17                	jne    8006eb <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e9:	eb 8a                	jmp    800675 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fb:	b8 10 00 00 00       	mov    $0x10,%eax
  800700:	e9 70 ff ff ff       	jmp    800675 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 25                	push   $0x25
  80070b:	ff d6                	call   *%esi
			break;
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	e9 7a ff ff ff       	jmp    80068f <vprintfmt+0x414>
			putch('%', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 25                	push   $0x25
  80071b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	89 f8                	mov    %edi,%eax
  800722:	eb 03                	jmp    800727 <vprintfmt+0x4ac>
  800724:	83 e8 01             	sub    $0x1,%eax
  800727:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80072b:	75 f7                	jne    800724 <vprintfmt+0x4a9>
  80072d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800730:	e9 5a ff ff ff       	jmp    80068f <vprintfmt+0x414>
}
  800735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800738:	5b                   	pop    %ebx
  800739:	5e                   	pop    %esi
  80073a:	5f                   	pop    %edi
  80073b:	5d                   	pop    %ebp
  80073c:	c3                   	ret    

0080073d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800749:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80074c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800750:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80075a:	85 c0                	test   %eax,%eax
  80075c:	74 26                	je     800784 <vsnprintf+0x47>
  80075e:	85 d2                	test   %edx,%edx
  800760:	7e 22                	jle    800784 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800762:	ff 75 14             	pushl  0x14(%ebp)
  800765:	ff 75 10             	pushl  0x10(%ebp)
  800768:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80076b:	50                   	push   %eax
  80076c:	68 41 02 80 00       	push   $0x800241
  800771:	e8 05 fb ff ff       	call   80027b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800779:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80077f:	83 c4 10             	add    $0x10,%esp
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    
		return -E_INVAL;
  800784:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800789:	eb f7                	jmp    800782 <vsnprintf+0x45>

0080078b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800791:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800794:	50                   	push   %eax
  800795:	ff 75 10             	pushl  0x10(%ebp)
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	ff 75 08             	pushl  0x8(%ebp)
  80079e:	e8 9a ff ff ff       	call   80073d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a3:	c9                   	leave  
  8007a4:	c3                   	ret    

008007a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b0:	eb 03                	jmp    8007b5 <strlen+0x10>
		n++;
  8007b2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007b5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b9:	75 f7                	jne    8007b2 <strlen+0xd>
	return n;
}
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cb:	eb 03                	jmp    8007d0 <strnlen+0x13>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d0:	39 d0                	cmp    %edx,%eax
  8007d2:	74 06                	je     8007da <strnlen+0x1d>
  8007d4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d8:	75 f3                	jne    8007cd <strnlen+0x10>
	return n;
}
  8007da:	5d                   	pop    %ebp
  8007db:	c3                   	ret    

008007dc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	53                   	push   %ebx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e6:	89 c2                	mov    %eax,%edx
  8007e8:	83 c1 01             	add    $0x1,%ecx
  8007eb:	83 c2 01             	add    $0x1,%edx
  8007ee:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f5:	84 db                	test   %bl,%bl
  8007f7:	75 ef                	jne    8007e8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f9:	5b                   	pop    %ebx
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	53                   	push   %ebx
  800800:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800803:	53                   	push   %ebx
  800804:	e8 9c ff ff ff       	call   8007a5 <strlen>
  800809:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	01 d8                	add    %ebx,%eax
  800811:	50                   	push   %eax
  800812:	e8 c5 ff ff ff       	call   8007dc <strcpy>
	return dst;
}
  800817:	89 d8                	mov    %ebx,%eax
  800819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	8b 75 08             	mov    0x8(%ebp),%esi
  800826:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800829:	89 f3                	mov    %esi,%ebx
  80082b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082e:	89 f2                	mov    %esi,%edx
  800830:	eb 0f                	jmp    800841 <strncpy+0x23>
		*dst++ = *src;
  800832:	83 c2 01             	add    $0x1,%edx
  800835:	0f b6 01             	movzbl (%ecx),%eax
  800838:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083b:	80 39 01             	cmpb   $0x1,(%ecx)
  80083e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800841:	39 da                	cmp    %ebx,%edx
  800843:	75 ed                	jne    800832 <strncpy+0x14>
	}
	return ret;
}
  800845:	89 f0                	mov    %esi,%eax
  800847:	5b                   	pop    %ebx
  800848:	5e                   	pop    %esi
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	56                   	push   %esi
  80084f:	53                   	push   %ebx
  800850:	8b 75 08             	mov    0x8(%ebp),%esi
  800853:	8b 55 0c             	mov    0xc(%ebp),%edx
  800856:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800859:	89 f0                	mov    %esi,%eax
  80085b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085f:	85 c9                	test   %ecx,%ecx
  800861:	75 0b                	jne    80086e <strlcpy+0x23>
  800863:	eb 17                	jmp    80087c <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800865:	83 c2 01             	add    $0x1,%edx
  800868:	83 c0 01             	add    $0x1,%eax
  80086b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80086e:	39 d8                	cmp    %ebx,%eax
  800870:	74 07                	je     800879 <strlcpy+0x2e>
  800872:	0f b6 0a             	movzbl (%edx),%ecx
  800875:	84 c9                	test   %cl,%cl
  800877:	75 ec                	jne    800865 <strlcpy+0x1a>
		*dst = '\0';
  800879:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80087c:	29 f0                	sub    %esi,%eax
}
  80087e:	5b                   	pop    %ebx
  80087f:	5e                   	pop    %esi
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80088b:	eb 06                	jmp    800893 <strcmp+0x11>
		p++, q++;
  80088d:	83 c1 01             	add    $0x1,%ecx
  800890:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800893:	0f b6 01             	movzbl (%ecx),%eax
  800896:	84 c0                	test   %al,%al
  800898:	74 04                	je     80089e <strcmp+0x1c>
  80089a:	3a 02                	cmp    (%edx),%al
  80089c:	74 ef                	je     80088d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80089e:	0f b6 c0             	movzbl %al,%eax
  8008a1:	0f b6 12             	movzbl (%edx),%edx
  8008a4:	29 d0                	sub    %edx,%eax
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	53                   	push   %ebx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b2:	89 c3                	mov    %eax,%ebx
  8008b4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b7:	eb 06                	jmp    8008bf <strncmp+0x17>
		n--, p++, q++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008bf:	39 d8                	cmp    %ebx,%eax
  8008c1:	74 16                	je     8008d9 <strncmp+0x31>
  8008c3:	0f b6 08             	movzbl (%eax),%ecx
  8008c6:	84 c9                	test   %cl,%cl
  8008c8:	74 04                	je     8008ce <strncmp+0x26>
  8008ca:	3a 0a                	cmp    (%edx),%cl
  8008cc:	74 eb                	je     8008b9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ce:	0f b6 00             	movzbl (%eax),%eax
  8008d1:	0f b6 12             	movzbl (%edx),%edx
  8008d4:	29 d0                	sub    %edx,%eax
}
  8008d6:	5b                   	pop    %ebx
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    
		return 0;
  8008d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008de:	eb f6                	jmp    8008d6 <strncmp+0x2e>

008008e0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ea:	0f b6 10             	movzbl (%eax),%edx
  8008ed:	84 d2                	test   %dl,%dl
  8008ef:	74 09                	je     8008fa <strchr+0x1a>
		if (*s == c)
  8008f1:	38 ca                	cmp    %cl,%dl
  8008f3:	74 0a                	je     8008ff <strchr+0x1f>
	for (; *s; s++)
  8008f5:	83 c0 01             	add    $0x1,%eax
  8008f8:	eb f0                	jmp    8008ea <strchr+0xa>
			return (char *) s;
	return 0;
  8008fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090b:	eb 03                	jmp    800910 <strfind+0xf>
  80090d:	83 c0 01             	add    $0x1,%eax
  800910:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800913:	38 ca                	cmp    %cl,%dl
  800915:	74 04                	je     80091b <strfind+0x1a>
  800917:	84 d2                	test   %dl,%dl
  800919:	75 f2                	jne    80090d <strfind+0xc>
			break;
	return (char *) s;
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	57                   	push   %edi
  800921:	56                   	push   %esi
  800922:	53                   	push   %ebx
  800923:	8b 7d 08             	mov    0x8(%ebp),%edi
  800926:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800929:	85 c9                	test   %ecx,%ecx
  80092b:	74 13                	je     800940 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800933:	75 05                	jne    80093a <memset+0x1d>
  800935:	f6 c1 03             	test   $0x3,%cl
  800938:	74 0d                	je     800947 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	fc                   	cld    
  80093e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800940:	89 f8                	mov    %edi,%eax
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5f                   	pop    %edi
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    
		c &= 0xFF;
  800947:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80094b:	89 d3                	mov    %edx,%ebx
  80094d:	c1 e3 08             	shl    $0x8,%ebx
  800950:	89 d0                	mov    %edx,%eax
  800952:	c1 e0 18             	shl    $0x18,%eax
  800955:	89 d6                	mov    %edx,%esi
  800957:	c1 e6 10             	shl    $0x10,%esi
  80095a:	09 f0                	or     %esi,%eax
  80095c:	09 c2                	or     %eax,%edx
  80095e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800960:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800963:	89 d0                	mov    %edx,%eax
  800965:	fc                   	cld    
  800966:	f3 ab                	rep stos %eax,%es:(%edi)
  800968:	eb d6                	jmp    800940 <memset+0x23>

0080096a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	57                   	push   %edi
  80096e:	56                   	push   %esi
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 75 0c             	mov    0xc(%ebp),%esi
  800975:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800978:	39 c6                	cmp    %eax,%esi
  80097a:	73 35                	jae    8009b1 <memmove+0x47>
  80097c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80097f:	39 c2                	cmp    %eax,%edx
  800981:	76 2e                	jbe    8009b1 <memmove+0x47>
		s += n;
		d += n;
  800983:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800986:	89 d6                	mov    %edx,%esi
  800988:	09 fe                	or     %edi,%esi
  80098a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800990:	74 0c                	je     80099e <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800992:	83 ef 01             	sub    $0x1,%edi
  800995:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800998:	fd                   	std    
  800999:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80099b:	fc                   	cld    
  80099c:	eb 21                	jmp    8009bf <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	f6 c1 03             	test   $0x3,%cl
  8009a1:	75 ef                	jne    800992 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a3:	83 ef 04             	sub    $0x4,%edi
  8009a6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009af:	eb ea                	jmp    80099b <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b1:	89 f2                	mov    %esi,%edx
  8009b3:	09 c2                	or     %eax,%edx
  8009b5:	f6 c2 03             	test   $0x3,%dl
  8009b8:	74 09                	je     8009c3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ba:	89 c7                	mov    %eax,%edi
  8009bc:	fc                   	cld    
  8009bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009bf:	5e                   	pop    %esi
  8009c0:	5f                   	pop    %edi
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c3:	f6 c1 03             	test   $0x3,%cl
  8009c6:	75 f2                	jne    8009ba <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009cb:	89 c7                	mov    %eax,%edi
  8009cd:	fc                   	cld    
  8009ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d0:	eb ed                	jmp    8009bf <memmove+0x55>

008009d2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009d5:	ff 75 10             	pushl  0x10(%ebp)
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 87 ff ff ff       	call   80096a <memmove>
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f0:	89 c6                	mov    %eax,%esi
  8009f2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f5:	39 f0                	cmp    %esi,%eax
  8009f7:	74 1c                	je     800a15 <memcmp+0x30>
		if (*s1 != *s2)
  8009f9:	0f b6 08             	movzbl (%eax),%ecx
  8009fc:	0f b6 1a             	movzbl (%edx),%ebx
  8009ff:	38 d9                	cmp    %bl,%cl
  800a01:	75 08                	jne    800a0b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	eb ea                	jmp    8009f5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a0b:	0f b6 c1             	movzbl %cl,%eax
  800a0e:	0f b6 db             	movzbl %bl,%ebx
  800a11:	29 d8                	sub    %ebx,%eax
  800a13:	eb 05                	jmp    800a1a <memcmp+0x35>
	}

	return 0;
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1a:	5b                   	pop    %ebx
  800a1b:	5e                   	pop    %esi
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a27:	89 c2                	mov    %eax,%edx
  800a29:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2c:	39 d0                	cmp    %edx,%eax
  800a2e:	73 09                	jae    800a39 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a30:	38 08                	cmp    %cl,(%eax)
  800a32:	74 05                	je     800a39 <memfind+0x1b>
	for (; s < ends; s++)
  800a34:	83 c0 01             	add    $0x1,%eax
  800a37:	eb f3                	jmp    800a2c <memfind+0xe>
			break;
	return (void *) s;
}
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	57                   	push   %edi
  800a3f:	56                   	push   %esi
  800a40:	53                   	push   %ebx
  800a41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a44:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a47:	eb 03                	jmp    800a4c <strtol+0x11>
		s++;
  800a49:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a4c:	0f b6 01             	movzbl (%ecx),%eax
  800a4f:	3c 20                	cmp    $0x20,%al
  800a51:	74 f6                	je     800a49 <strtol+0xe>
  800a53:	3c 09                	cmp    $0x9,%al
  800a55:	74 f2                	je     800a49 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a57:	3c 2b                	cmp    $0x2b,%al
  800a59:	74 2e                	je     800a89 <strtol+0x4e>
	int neg = 0;
  800a5b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a60:	3c 2d                	cmp    $0x2d,%al
  800a62:	74 2f                	je     800a93 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a64:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a6a:	75 05                	jne    800a71 <strtol+0x36>
  800a6c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6f:	74 2c                	je     800a9d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a71:	85 db                	test   %ebx,%ebx
  800a73:	75 0a                	jne    800a7f <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a75:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a7a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a7d:	74 28                	je     800aa7 <strtol+0x6c>
		base = 10;
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a84:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a87:	eb 50                	jmp    800ad9 <strtol+0x9e>
		s++;
  800a89:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a91:	eb d1                	jmp    800a64 <strtol+0x29>
		s++, neg = 1;
  800a93:	83 c1 01             	add    $0x1,%ecx
  800a96:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9b:	eb c7                	jmp    800a64 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa1:	74 0e                	je     800ab1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa3:	85 db                	test   %ebx,%ebx
  800aa5:	75 d8                	jne    800a7f <strtol+0x44>
		s++, base = 8;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aaf:	eb ce                	jmp    800a7f <strtol+0x44>
		s += 2, base = 16;
  800ab1:	83 c1 02             	add    $0x2,%ecx
  800ab4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab9:	eb c4                	jmp    800a7f <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800abb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800abe:	89 f3                	mov    %esi,%ebx
  800ac0:	80 fb 19             	cmp    $0x19,%bl
  800ac3:	77 29                	ja     800aee <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ac5:	0f be d2             	movsbl %dl,%edx
  800ac8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800acb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ace:	7d 30                	jge    800b00 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad0:	83 c1 01             	add    $0x1,%ecx
  800ad3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad9:	0f b6 11             	movzbl (%ecx),%edx
  800adc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800adf:	89 f3                	mov    %esi,%ebx
  800ae1:	80 fb 09             	cmp    $0x9,%bl
  800ae4:	77 d5                	ja     800abb <strtol+0x80>
			dig = *s - '0';
  800ae6:	0f be d2             	movsbl %dl,%edx
  800ae9:	83 ea 30             	sub    $0x30,%edx
  800aec:	eb dd                	jmp    800acb <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800aee:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af1:	89 f3                	mov    %esi,%ebx
  800af3:	80 fb 19             	cmp    $0x19,%bl
  800af6:	77 08                	ja     800b00 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af8:	0f be d2             	movsbl %dl,%edx
  800afb:	83 ea 37             	sub    $0x37,%edx
  800afe:	eb cb                	jmp    800acb <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b04:	74 05                	je     800b0b <strtol+0xd0>
		*endptr = (char *) s;
  800b06:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b09:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b0b:	89 c2                	mov    %eax,%edx
  800b0d:	f7 da                	neg    %edx
  800b0f:	85 ff                	test   %edi,%edi
  800b11:	0f 45 c2             	cmovne %edx,%eax
}
  800b14:	5b                   	pop    %ebx
  800b15:	5e                   	pop    %esi
  800b16:	5f                   	pop    %edi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	57                   	push   %edi
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2a:	89 c3                	mov    %eax,%ebx
  800b2c:	89 c7                	mov    %eax,%edi
  800b2e:	89 c6                	mov    %eax,%esi
  800b30:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5f                   	pop    %edi
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <sys_cgetc>:

int
sys_cgetc(void) {
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	57                   	push   %edi
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b42:	b8 01 00 00 00       	mov    $0x1,%eax
  800b47:	89 d1                	mov    %edx,%ecx
  800b49:	89 d3                	mov    %edx,%ebx
  800b4b:	89 d7                	mov    %edx,%edi
  800b4d:	89 d6                	mov    %edx,%esi
  800b4f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
  800b5c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b64:	8b 55 08             	mov    0x8(%ebp),%edx
  800b67:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6c:	89 cb                	mov    %ecx,%ebx
  800b6e:	89 cf                	mov    %ecx,%edi
  800b70:	89 ce                	mov    %ecx,%esi
  800b72:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b74:	85 c0                	test   %eax,%eax
  800b76:	7f 08                	jg     800b80 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b80:	83 ec 0c             	sub    $0xc,%esp
  800b83:	50                   	push   %eax
  800b84:	6a 03                	push   $0x3
  800b86:	68 04 13 80 00       	push   $0x801304
  800b8b:	6a 24                	push   $0x24
  800b8d:	68 21 13 80 00       	push   $0x801321
  800b92:	e8 54 02 00 00       	call   800deb <_panic>

00800b97 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba7:	89 d1                	mov    %edx,%ecx
  800ba9:	89 d3                	mov    %edx,%ebx
  800bab:	89 d7                	mov    %edx,%edi
  800bad:	89 d6                	mov    %edx,%esi
  800baf:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_yield>:

void
sys_yield(void)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc6:	89 d1                	mov    %edx,%ecx
  800bc8:	89 d3                	mov    %edx,%ebx
  800bca:	89 d7                	mov    %edx,%edi
  800bcc:	89 d6                	mov    %edx,%esi
  800bce:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bde:	be 00 00 00 00       	mov    $0x0,%esi
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf1:	89 f7                	mov    %esi,%edi
  800bf3:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	7f 08                	jg     800c01 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5f                   	pop    %edi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c01:	83 ec 0c             	sub    $0xc,%esp
  800c04:	50                   	push   %eax
  800c05:	6a 04                	push   $0x4
  800c07:	68 04 13 80 00       	push   $0x801304
  800c0c:	6a 24                	push   $0x24
  800c0e:	68 21 13 80 00       	push   $0x801321
  800c13:	e8 d3 01 00 00       	call   800deb <_panic>

00800c18 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
  800c1e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c21:	8b 55 08             	mov    0x8(%ebp),%edx
  800c24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c27:	b8 05 00 00 00       	mov    $0x5,%eax
  800c2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c32:	8b 75 18             	mov    0x18(%ebp),%esi
  800c35:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c37:	85 c0                	test   %eax,%eax
  800c39:	7f 08                	jg     800c43 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c43:	83 ec 0c             	sub    $0xc,%esp
  800c46:	50                   	push   %eax
  800c47:	6a 05                	push   $0x5
  800c49:	68 04 13 80 00       	push   $0x801304
  800c4e:	6a 24                	push   $0x24
  800c50:	68 21 13 80 00       	push   $0x801321
  800c55:	e8 91 01 00 00       	call   800deb <_panic>

00800c5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c73:	89 df                	mov    %ebx,%edi
  800c75:	89 de                	mov    %ebx,%esi
  800c77:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	7f 08                	jg     800c85 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c85:	83 ec 0c             	sub    $0xc,%esp
  800c88:	50                   	push   %eax
  800c89:	6a 06                	push   $0x6
  800c8b:	68 04 13 80 00       	push   $0x801304
  800c90:	6a 24                	push   $0x24
  800c92:	68 21 13 80 00       	push   $0x801321
  800c97:	e8 4f 01 00 00       	call   800deb <_panic>

00800c9c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ca5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb0:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb5:	89 df                	mov    %ebx,%edi
  800cb7:	89 de                	mov    %ebx,%esi
  800cb9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 08                	push   $0x8
  800ccd:	68 04 13 80 00       	push   $0x801304
  800cd2:	6a 24                	push   $0x24
  800cd4:	68 21 13 80 00       	push   $0x801321
  800cd9:	e8 0d 01 00 00       	call   800deb <_panic>

00800cde <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ce7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf2:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	89 de                	mov    %ebx,%esi
  800cfb:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	7f 08                	jg     800d09 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d09:	83 ec 0c             	sub    $0xc,%esp
  800d0c:	50                   	push   %eax
  800d0d:	6a 09                	push   $0x9
  800d0f:	68 04 13 80 00       	push   $0x801304
  800d14:	6a 24                	push   $0x24
  800d16:	68 21 13 80 00       	push   $0x801321
  800d1b:	e8 cb 00 00 00       	call   800deb <_panic>

00800d20 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d39:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d3c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d59:	89 cb                	mov    %ecx,%ebx
  800d5b:	89 cf                	mov    %ecx,%edi
  800d5d:	89 ce                	mov    %ecx,%esi
  800d5f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d61:	85 c0                	test   %eax,%eax
  800d63:	7f 08                	jg     800d6d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d6d:	83 ec 0c             	sub    $0xc,%esp
  800d70:	50                   	push   %eax
  800d71:	6a 0c                	push   $0xc
  800d73:	68 04 13 80 00       	push   $0x801304
  800d78:	6a 24                	push   $0x24
  800d7a:	68 21 13 80 00       	push   $0x801321
  800d7f:	e8 67 00 00 00       	call   800deb <_panic>

00800d84 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800d8a:	68 2f 13 80 00       	push   $0x80132f
  800d8f:	6a 1a                	push   $0x1a
  800d91:	68 48 13 80 00       	push   $0x801348
  800d96:	e8 50 00 00 00       	call   800deb <_panic>

00800d9b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800da1:	68 52 13 80 00       	push   $0x801352
  800da6:	6a 2a                	push   $0x2a
  800da8:	68 48 13 80 00       	push   $0x801348
  800dad:	e8 39 00 00 00       	call   800deb <_panic>

00800db2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800dbd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800dc0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800dc6:	8b 52 50             	mov    0x50(%edx),%edx
  800dc9:	39 ca                	cmp    %ecx,%edx
  800dcb:	74 11                	je     800dde <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800dcd:	83 c0 01             	add    $0x1,%eax
  800dd0:	3d 00 04 00 00       	cmp    $0x400,%eax
  800dd5:	75 e6                	jne    800dbd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddc:	eb 0b                	jmp    800de9 <ipc_find_env+0x37>
			return envs[i].env_id;
  800dde:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800de1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800de6:	8b 40 48             	mov    0x48(%eax),%eax
}
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800df0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800df3:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800df9:	e8 99 fd ff ff       	call   800b97 <sys_getenvid>
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	ff 75 08             	pushl  0x8(%ebp)
  800e07:	56                   	push   %esi
  800e08:	50                   	push   %eax
  800e09:	68 6c 13 80 00       	push   $0x80136c
  800e0e:	e8 6b f3 ff ff       	call   80017e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e13:	83 c4 18             	add    $0x18,%esp
  800e16:	53                   	push   %ebx
  800e17:	ff 75 10             	pushl  0x10(%ebp)
  800e1a:	e8 0e f3 ff ff       	call   80012d <vcprintf>
	cprintf("\n");
  800e1f:	c7 04 24 8f 10 80 00 	movl   $0x80108f,(%esp)
  800e26:	e8 53 f3 ff ff       	call   80017e <cprintf>
  800e2b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e2e:	cc                   	int3   
  800e2f:	eb fd                	jmp    800e2e <_panic+0x43>
  800e31:	66 90                	xchg   %ax,%ax
  800e33:	66 90                	xchg   %ax,%ax
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
