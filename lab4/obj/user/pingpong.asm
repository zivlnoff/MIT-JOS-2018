
obj/user/pingpong：     文件格式 elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 62 0d 00 00       	call   800da3 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 79 0d 00 00       	call   800dd1 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 54 0b 00 00       	call   800bb6 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 d6 10 80 00       	push   $0x8010d6
  80006a:	e8 2e 01 00 00       	call   80019d <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 61 0d 00 00       	call   800de8 <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 18 0b 00 00       	call   800bb6 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 c0 10 80 00       	push   $0x8010c0
  8000a8:	e8 f0 00 00 00       	call   80019d <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 2d 0d 00 00       	call   800de8 <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000cc:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8000d3:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d6:	85 c0                	test   %eax,%eax
  8000d8:	7e 08                	jle    8000e2 <libmain+0x22>
		binaryname = argv[0];
  8000da:	8b 0a                	mov    (%edx),%ecx
  8000dc:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	52                   	push   %edx
  8000e6:	50                   	push   %eax
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 05 00 00 00       	call   8000f6 <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000fc:	6a 00                	push   $0x0
  8000fe:	e8 72 0a 00 00       	call   800b75 <sys_env_destroy>
}
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	c9                   	leave  
  800107:	c3                   	ret    

00800108 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	53                   	push   %ebx
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800112:	8b 13                	mov    (%ebx),%edx
  800114:	8d 42 01             	lea    0x1(%edx),%eax
  800117:	89 03                	mov    %eax,(%ebx)
  800119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800120:	3d ff 00 00 00       	cmp    $0xff,%eax
  800125:	74 09                	je     800130 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800127:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	68 ff 00 00 00       	push   $0xff
  800138:	8d 43 08             	lea    0x8(%ebx),%eax
  80013b:	50                   	push   %eax
  80013c:	e8 f7 09 00 00       	call   800b38 <sys_cputs>
		b->idx = 0;
  800141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	eb db                	jmp    800127 <putch+0x1f>

0080014c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800155:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015c:	00 00 00 
	b.cnt = 0;
  80015f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800166:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800169:	ff 75 0c             	pushl  0xc(%ebp)
  80016c:	ff 75 08             	pushl  0x8(%ebp)
  80016f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800175:	50                   	push   %eax
  800176:	68 08 01 80 00       	push   $0x800108
  80017b:	e8 1a 01 00 00       	call   80029a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800180:	83 c4 08             	add    $0x8,%esp
  800183:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800189:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	e8 a3 09 00 00       	call   800b38 <sys_cputs>

	return b.cnt;
}
  800195:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a6:	50                   	push   %eax
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 9d ff ff ff       	call   80014c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	57                   	push   %edi
  8001b5:	56                   	push   %esi
  8001b6:	53                   	push   %ebx
  8001b7:	83 ec 1c             	sub    $0x1c,%esp
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	89 d6                	mov    %edx,%esi
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d8:	39 d3                	cmp    %edx,%ebx
  8001da:	72 05                	jb     8001e1 <printnum+0x30>
  8001dc:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001df:	77 7a                	ja     80025b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 18             	pushl  0x18(%ebp)
  8001e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8001ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ed:	53                   	push   %ebx
  8001ee:	ff 75 10             	pushl  0x10(%ebp)
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800200:	e8 7b 0c 00 00       	call   800e80 <__udivdi3>
  800205:	83 c4 18             	add    $0x18,%esp
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	89 f2                	mov    %esi,%edx
  80020c:	89 f8                	mov    %edi,%eax
  80020e:	e8 9e ff ff ff       	call   8001b1 <printnum>
  800213:	83 c4 20             	add    $0x20,%esp
  800216:	eb 13                	jmp    80022b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	56                   	push   %esi
  80021c:	ff 75 18             	pushl  0x18(%ebp)
  80021f:	ff d7                	call   *%edi
  800221:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	85 db                	test   %ebx,%ebx
  800229:	7f ed                	jg     800218 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	56                   	push   %esi
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	ff 75 e4             	pushl  -0x1c(%ebp)
  800235:	ff 75 e0             	pushl  -0x20(%ebp)
  800238:	ff 75 dc             	pushl  -0x24(%ebp)
  80023b:	ff 75 d8             	pushl  -0x28(%ebp)
  80023e:	e8 5d 0d 00 00       	call   800fa0 <__umoddi3>
  800243:	83 c4 14             	add    $0x14,%esp
  800246:	0f be 80 f3 10 80 00 	movsbl 0x8010f3(%eax),%eax
  80024d:	50                   	push   %eax
  80024e:	ff d7                	call   *%edi
}
  800250:	83 c4 10             	add    $0x10,%esp
  800253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800256:	5b                   	pop    %ebx
  800257:	5e                   	pop    %esi
  800258:	5f                   	pop    %edi
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    
  80025b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80025e:	eb c4                	jmp    800224 <printnum+0x73>

00800260 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800266:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026a:	8b 10                	mov    (%eax),%edx
  80026c:	3b 50 04             	cmp    0x4(%eax),%edx
  80026f:	73 0a                	jae    80027b <sprintputch+0x1b>
		*b->buf++ = ch;
  800271:	8d 4a 01             	lea    0x1(%edx),%ecx
  800274:	89 08                	mov    %ecx,(%eax)
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	88 02                	mov    %al,(%edx)
}
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <printfmt>:
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800283:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800286:	50                   	push   %eax
  800287:	ff 75 10             	pushl  0x10(%ebp)
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 08             	pushl  0x8(%ebp)
  800290:	e8 05 00 00 00       	call   80029a <vprintfmt>
}
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <vprintfmt>:
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	57                   	push   %edi
  80029e:	56                   	push   %esi
  80029f:	53                   	push   %ebx
  8002a0:	83 ec 2c             	sub    $0x2c,%esp
  8002a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ac:	e9 00 04 00 00       	jmp    8006b1 <vprintfmt+0x417>
		padc = ' ';
  8002b1:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002b5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002bc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ca:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002cf:	8d 47 01             	lea    0x1(%edi),%eax
  8002d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002d5:	0f b6 17             	movzbl (%edi),%edx
  8002d8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002db:	3c 55                	cmp    $0x55,%al
  8002dd:	0f 87 51 04 00 00    	ja     800734 <vprintfmt+0x49a>
  8002e3:	0f b6 c0             	movzbl %al,%eax
  8002e6:	ff 24 85 c0 11 80 00 	jmp    *0x8011c0(,%eax,4)
  8002ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002f4:	eb d9                	jmp    8002cf <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002fd:	eb d0                	jmp    8002cf <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ff:	0f b6 d2             	movzbl %dl,%edx
  800302:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80030d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800310:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800314:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800317:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80031a:	83 f9 09             	cmp    $0x9,%ecx
  80031d:	77 55                	ja     800374 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80031f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800322:	eb e9                	jmp    80030d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800324:	8b 45 14             	mov    0x14(%ebp),%eax
  800327:	8b 00                	mov    (%eax),%eax
  800329:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80032c:	8b 45 14             	mov    0x14(%ebp),%eax
  80032f:	8d 40 04             	lea    0x4(%eax),%eax
  800332:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800338:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80033c:	79 91                	jns    8002cf <vprintfmt+0x35>
				width = precision, precision = -1;
  80033e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800344:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80034b:	eb 82                	jmp    8002cf <vprintfmt+0x35>
  80034d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800350:	85 c0                	test   %eax,%eax
  800352:	ba 00 00 00 00       	mov    $0x0,%edx
  800357:	0f 49 d0             	cmovns %eax,%edx
  80035a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800360:	e9 6a ff ff ff       	jmp    8002cf <vprintfmt+0x35>
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800368:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80036f:	e9 5b ff ff ff       	jmp    8002cf <vprintfmt+0x35>
  800374:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800377:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037a:	eb bc                	jmp    800338 <vprintfmt+0x9e>
			lflag++;
  80037c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800382:	e9 48 ff ff ff       	jmp    8002cf <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 78 04             	lea    0x4(%eax),%edi
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	53                   	push   %ebx
  800391:	ff 30                	pushl  (%eax)
  800393:	ff d6                	call   *%esi
			break;
  800395:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800398:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80039b:	e9 0e 03 00 00       	jmp    8006ae <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a3:	8d 78 04             	lea    0x4(%eax),%edi
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	99                   	cltd   
  8003a9:	31 d0                	xor    %edx,%eax
  8003ab:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ad:	83 f8 08             	cmp    $0x8,%eax
  8003b0:	7f 23                	jg     8003d5 <vprintfmt+0x13b>
  8003b2:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  8003b9:	85 d2                	test   %edx,%edx
  8003bb:	74 18                	je     8003d5 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003bd:	52                   	push   %edx
  8003be:	68 14 11 80 00       	push   $0x801114
  8003c3:	53                   	push   %ebx
  8003c4:	56                   	push   %esi
  8003c5:	e8 b3 fe ff ff       	call   80027d <printfmt>
  8003ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d0:	e9 d9 02 00 00       	jmp    8006ae <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003d5:	50                   	push   %eax
  8003d6:	68 0b 11 80 00       	push   $0x80110b
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 9b fe ff ff       	call   80027d <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e8:	e9 c1 02 00 00       	jmp    8006ae <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f0:	83 c0 04             	add    $0x4,%eax
  8003f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003fb:	85 ff                	test   %edi,%edi
  8003fd:	b8 04 11 80 00       	mov    $0x801104,%eax
  800402:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800409:	0f 8e bd 00 00 00    	jle    8004cc <vprintfmt+0x232>
  80040f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800413:	75 0e                	jne    800423 <vprintfmt+0x189>
  800415:	89 75 08             	mov    %esi,0x8(%ebp)
  800418:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80041b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80041e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800421:	eb 6d                	jmp    800490 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	ff 75 d0             	pushl  -0x30(%ebp)
  800429:	57                   	push   %edi
  80042a:	e8 ad 03 00 00       	call   8007dc <strnlen>
  80042f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800432:	29 c1                	sub    %eax,%ecx
  800434:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800437:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80043a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800441:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800444:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800446:	eb 0f                	jmp    800457 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	53                   	push   %ebx
  80044c:	ff 75 e0             	pushl  -0x20(%ebp)
  80044f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800451:	83 ef 01             	sub    $0x1,%edi
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	85 ff                	test   %edi,%edi
  800459:	7f ed                	jg     800448 <vprintfmt+0x1ae>
  80045b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80045e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800461:	85 c9                	test   %ecx,%ecx
  800463:	b8 00 00 00 00       	mov    $0x0,%eax
  800468:	0f 49 c1             	cmovns %ecx,%eax
  80046b:	29 c1                	sub    %eax,%ecx
  80046d:	89 75 08             	mov    %esi,0x8(%ebp)
  800470:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800473:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800476:	89 cb                	mov    %ecx,%ebx
  800478:	eb 16                	jmp    800490 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80047a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80047e:	75 31                	jne    8004b1 <vprintfmt+0x217>
					putch(ch, putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	ff 75 0c             	pushl  0xc(%ebp)
  800486:	50                   	push   %eax
  800487:	ff 55 08             	call   *0x8(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048d:	83 eb 01             	sub    $0x1,%ebx
  800490:	83 c7 01             	add    $0x1,%edi
  800493:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800497:	0f be c2             	movsbl %dl,%eax
  80049a:	85 c0                	test   %eax,%eax
  80049c:	74 59                	je     8004f7 <vprintfmt+0x25d>
  80049e:	85 f6                	test   %esi,%esi
  8004a0:	78 d8                	js     80047a <vprintfmt+0x1e0>
  8004a2:	83 ee 01             	sub    $0x1,%esi
  8004a5:	79 d3                	jns    80047a <vprintfmt+0x1e0>
  8004a7:	89 df                	mov    %ebx,%edi
  8004a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004af:	eb 37                	jmp    8004e8 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b1:	0f be d2             	movsbl %dl,%edx
  8004b4:	83 ea 20             	sub    $0x20,%edx
  8004b7:	83 fa 5e             	cmp    $0x5e,%edx
  8004ba:	76 c4                	jbe    800480 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 0c             	pushl  0xc(%ebp)
  8004c2:	6a 3f                	push   $0x3f
  8004c4:	ff 55 08             	call   *0x8(%ebp)
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	eb c1                	jmp    80048d <vprintfmt+0x1f3>
  8004cc:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cf:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004d8:	eb b6                	jmp    800490 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	53                   	push   %ebx
  8004de:	6a 20                	push   $0x20
  8004e0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e2:	83 ef 01             	sub    $0x1,%edi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	85 ff                	test   %edi,%edi
  8004ea:	7f ee                	jg     8004da <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f2:	e9 b7 01 00 00       	jmp    8006ae <vprintfmt+0x414>
  8004f7:	89 df                	mov    %ebx,%edi
  8004f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ff:	eb e7                	jmp    8004e8 <vprintfmt+0x24e>
	if (lflag >= 2)
  800501:	83 f9 01             	cmp    $0x1,%ecx
  800504:	7e 3f                	jle    800545 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8b 50 04             	mov    0x4(%eax),%edx
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 40 08             	lea    0x8(%eax),%eax
  80051a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80051d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800521:	79 5c                	jns    80057f <vprintfmt+0x2e5>
				putch('-', putdat);
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	53                   	push   %ebx
  800527:	6a 2d                	push   $0x2d
  800529:	ff d6                	call   *%esi
				num = -(long long) num;
  80052b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800531:	f7 da                	neg    %edx
  800533:	83 d1 00             	adc    $0x0,%ecx
  800536:	f7 d9                	neg    %ecx
  800538:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800540:	e9 4f 01 00 00       	jmp    800694 <vprintfmt+0x3fa>
	else if (lflag)
  800545:	85 c9                	test   %ecx,%ecx
  800547:	75 1b                	jne    800564 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800551:	89 c1                	mov    %eax,%ecx
  800553:	c1 f9 1f             	sar    $0x1f,%ecx
  800556:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 40 04             	lea    0x4(%eax),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
  800562:	eb b9                	jmp    80051d <vprintfmt+0x283>
		return va_arg(*ap, long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	89 c1                	mov    %eax,%ecx
  80056e:	c1 f9 1f             	sar    $0x1f,%ecx
  800571:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
  80057d:	eb 9e                	jmp    80051d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80057f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800582:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800585:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058a:	e9 05 01 00 00       	jmp    800694 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80058f:	83 f9 01             	cmp    $0x1,%ecx
  800592:	7e 18                	jle    8005ac <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 10                	mov    (%eax),%edx
  800599:	8b 48 04             	mov    0x4(%eax),%ecx
  80059c:	8d 40 08             	lea    0x8(%eax),%eax
  80059f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a7:	e9 e8 00 00 00       	jmp    800694 <vprintfmt+0x3fa>
	else if (lflag)
  8005ac:	85 c9                	test   %ecx,%ecx
  8005ae:	75 1a                	jne    8005ca <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8b 10                	mov    (%eax),%edx
  8005b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ba:	8d 40 04             	lea    0x4(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c5:	e9 ca 00 00 00       	jmp    800694 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 10                	mov    (%eax),%edx
  8005cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d4:	8d 40 04             	lea    0x4(%eax),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005df:	e9 b0 00 00 00       	jmp    800694 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005e4:	83 f9 01             	cmp    $0x1,%ecx
  8005e7:	7e 3c                	jle    800625 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 50 04             	mov    0x4(%eax),%edx
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 08             	lea    0x8(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800600:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800604:	79 59                	jns    80065f <vprintfmt+0x3c5>
                putch('-', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	53                   	push   %ebx
  80060a:	6a 2d                	push   $0x2d
  80060c:	ff d6                	call   *%esi
                num = -(long long) num;
  80060e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800611:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800614:	f7 da                	neg    %edx
  800616:	83 d1 00             	adc    $0x0,%ecx
  800619:	f7 d9                	neg    %ecx
  80061b:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80061e:	b8 08 00 00 00       	mov    $0x8,%eax
  800623:	eb 6f                	jmp    800694 <vprintfmt+0x3fa>
	else if (lflag)
  800625:	85 c9                	test   %ecx,%ecx
  800627:	75 1b                	jne    800644 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800631:	89 c1                	mov    %eax,%ecx
  800633:	c1 f9 1f             	sar    $0x1f,%ecx
  800636:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	eb bc                	jmp    800600 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	c1 f9 1f             	sar    $0x1f,%ecx
  800651:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
  80065d:	eb a1                	jmp    800600 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80065f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800662:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800665:	b8 08 00 00 00       	mov    $0x8,%eax
  80066a:	eb 28                	jmp    800694 <vprintfmt+0x3fa>
			putch('0', putdat);
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	53                   	push   %ebx
  800670:	6a 30                	push   $0x30
  800672:	ff d6                	call   *%esi
			putch('x', putdat);
  800674:	83 c4 08             	add    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	6a 78                	push   $0x78
  80067a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 10                	mov    (%eax),%edx
  800681:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800686:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800694:	83 ec 0c             	sub    $0xc,%esp
  800697:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80069b:	57                   	push   %edi
  80069c:	ff 75 e0             	pushl  -0x20(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	51                   	push   %ecx
  8006a1:	52                   	push   %edx
  8006a2:	89 da                	mov    %ebx,%edx
  8006a4:	89 f0                	mov    %esi,%eax
  8006a6:	e8 06 fb ff ff       	call   8001b1 <printnum>
			break;
  8006ab:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b1:	83 c7 01             	add    $0x1,%edi
  8006b4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b8:	83 f8 25             	cmp    $0x25,%eax
  8006bb:	0f 84 f0 fb ff ff    	je     8002b1 <vprintfmt+0x17>
			if (ch == '\0')
  8006c1:	85 c0                	test   %eax,%eax
  8006c3:	0f 84 8b 00 00 00    	je     800754 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	50                   	push   %eax
  8006ce:	ff d6                	call   *%esi
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb dc                	jmp    8006b1 <vprintfmt+0x417>
	if (lflag >= 2)
  8006d5:	83 f9 01             	cmp    $0x1,%ecx
  8006d8:	7e 15                	jle    8006ef <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 10                	mov    (%eax),%edx
  8006df:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e2:	8d 40 08             	lea    0x8(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ed:	eb a5                	jmp    800694 <vprintfmt+0x3fa>
	else if (lflag)
  8006ef:	85 c9                	test   %ecx,%ecx
  8006f1:	75 17                	jne    80070a <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 10                	mov    (%eax),%edx
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fd:	8d 40 04             	lea    0x4(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800703:	b8 10 00 00 00       	mov    $0x10,%eax
  800708:	eb 8a                	jmp    800694 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071a:	b8 10 00 00 00       	mov    $0x10,%eax
  80071f:	e9 70 ff ff ff       	jmp    800694 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	6a 25                	push   $0x25
  80072a:	ff d6                	call   *%esi
			break;
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	e9 7a ff ff ff       	jmp    8006ae <vprintfmt+0x414>
			putch('%', putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	6a 25                	push   $0x25
  80073a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	89 f8                	mov    %edi,%eax
  800741:	eb 03                	jmp    800746 <vprintfmt+0x4ac>
  800743:	83 e8 01             	sub    $0x1,%eax
  800746:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074a:	75 f7                	jne    800743 <vprintfmt+0x4a9>
  80074c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074f:	e9 5a ff ff ff       	jmp    8006ae <vprintfmt+0x414>
}
  800754:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800757:	5b                   	pop    %ebx
  800758:	5e                   	pop    %esi
  800759:	5f                   	pop    %edi
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800768:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80076b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80076f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800772:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800779:	85 c0                	test   %eax,%eax
  80077b:	74 26                	je     8007a3 <vsnprintf+0x47>
  80077d:	85 d2                	test   %edx,%edx
  80077f:	7e 22                	jle    8007a3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800781:	ff 75 14             	pushl  0x14(%ebp)
  800784:	ff 75 10             	pushl  0x10(%ebp)
  800787:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	68 60 02 80 00       	push   $0x800260
  800790:	e8 05 fb ff ff       	call   80029a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800798:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80079b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079e:	83 c4 10             	add    $0x10,%esp
}
  8007a1:	c9                   	leave  
  8007a2:	c3                   	ret    
		return -E_INVAL;
  8007a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a8:	eb f7                	jmp    8007a1 <vsnprintf+0x45>

008007aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b3:	50                   	push   %eax
  8007b4:	ff 75 10             	pushl  0x10(%ebp)
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	ff 75 08             	pushl  0x8(%ebp)
  8007bd:	e8 9a ff ff ff       	call   80075c <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cf:	eb 03                	jmp    8007d4 <strlen+0x10>
		n++;
  8007d1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007d4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d8:	75 f7                	jne    8007d1 <strlen+0xd>
	return n;
}
  8007da:	5d                   	pop    %ebp
  8007db:	c3                   	ret    

008007dc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	eb 03                	jmp    8007ef <strnlen+0x13>
		n++;
  8007ec:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ef:	39 d0                	cmp    %edx,%eax
  8007f1:	74 06                	je     8007f9 <strnlen+0x1d>
  8007f3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f7:	75 f3                	jne    8007ec <strnlen+0x10>
	return n;
}
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	53                   	push   %ebx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800805:	89 c2                	mov    %eax,%edx
  800807:	83 c1 01             	add    $0x1,%ecx
  80080a:	83 c2 01             	add    $0x1,%edx
  80080d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800811:	88 5a ff             	mov    %bl,-0x1(%edx)
  800814:	84 db                	test   %bl,%bl
  800816:	75 ef                	jne    800807 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800818:	5b                   	pop    %ebx
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	53                   	push   %ebx
  80081f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800822:	53                   	push   %ebx
  800823:	e8 9c ff ff ff       	call   8007c4 <strlen>
  800828:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	01 d8                	add    %ebx,%eax
  800830:	50                   	push   %eax
  800831:	e8 c5 ff ff ff       	call   8007fb <strcpy>
	return dst;
}
  800836:	89 d8                	mov    %ebx,%eax
  800838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    

0080083d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	56                   	push   %esi
  800841:	53                   	push   %ebx
  800842:	8b 75 08             	mov    0x8(%ebp),%esi
  800845:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800848:	89 f3                	mov    %esi,%ebx
  80084a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80084d:	89 f2                	mov    %esi,%edx
  80084f:	eb 0f                	jmp    800860 <strncpy+0x23>
		*dst++ = *src;
  800851:	83 c2 01             	add    $0x1,%edx
  800854:	0f b6 01             	movzbl (%ecx),%eax
  800857:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085a:	80 39 01             	cmpb   $0x1,(%ecx)
  80085d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800860:	39 da                	cmp    %ebx,%edx
  800862:	75 ed                	jne    800851 <strncpy+0x14>
	}
	return ret;
}
  800864:	89 f0                	mov    %esi,%eax
  800866:	5b                   	pop    %ebx
  800867:	5e                   	pop    %esi
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	8b 75 08             	mov    0x8(%ebp),%esi
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
  800875:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800878:	89 f0                	mov    %esi,%eax
  80087a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80087e:	85 c9                	test   %ecx,%ecx
  800880:	75 0b                	jne    80088d <strlcpy+0x23>
  800882:	eb 17                	jmp    80089b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800884:	83 c2 01             	add    $0x1,%edx
  800887:	83 c0 01             	add    $0x1,%eax
  80088a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80088d:	39 d8                	cmp    %ebx,%eax
  80088f:	74 07                	je     800898 <strlcpy+0x2e>
  800891:	0f b6 0a             	movzbl (%edx),%ecx
  800894:	84 c9                	test   %cl,%cl
  800896:	75 ec                	jne    800884 <strlcpy+0x1a>
		*dst = '\0';
  800898:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80089b:	29 f0                	sub    %esi,%eax
}
  80089d:	5b                   	pop    %ebx
  80089e:	5e                   	pop    %esi
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008aa:	eb 06                	jmp    8008b2 <strcmp+0x11>
		p++, q++;
  8008ac:	83 c1 01             	add    $0x1,%ecx
  8008af:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008b2:	0f b6 01             	movzbl (%ecx),%eax
  8008b5:	84 c0                	test   %al,%al
  8008b7:	74 04                	je     8008bd <strcmp+0x1c>
  8008b9:	3a 02                	cmp    (%edx),%al
  8008bb:	74 ef                	je     8008ac <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008bd:	0f b6 c0             	movzbl %al,%eax
  8008c0:	0f b6 12             	movzbl (%edx),%edx
  8008c3:	29 d0                	sub    %edx,%eax
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d1:	89 c3                	mov    %eax,%ebx
  8008d3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d6:	eb 06                	jmp    8008de <strncmp+0x17>
		n--, p++, q++;
  8008d8:	83 c0 01             	add    $0x1,%eax
  8008db:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008de:	39 d8                	cmp    %ebx,%eax
  8008e0:	74 16                	je     8008f8 <strncmp+0x31>
  8008e2:	0f b6 08             	movzbl (%eax),%ecx
  8008e5:	84 c9                	test   %cl,%cl
  8008e7:	74 04                	je     8008ed <strncmp+0x26>
  8008e9:	3a 0a                	cmp    (%edx),%cl
  8008eb:	74 eb                	je     8008d8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ed:	0f b6 00             	movzbl (%eax),%eax
  8008f0:	0f b6 12             	movzbl (%edx),%edx
  8008f3:	29 d0                	sub    %edx,%eax
}
  8008f5:	5b                   	pop    %ebx
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    
		return 0;
  8008f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fd:	eb f6                	jmp    8008f5 <strncmp+0x2e>

008008ff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800909:	0f b6 10             	movzbl (%eax),%edx
  80090c:	84 d2                	test   %dl,%dl
  80090e:	74 09                	je     800919 <strchr+0x1a>
		if (*s == c)
  800910:	38 ca                	cmp    %cl,%dl
  800912:	74 0a                	je     80091e <strchr+0x1f>
	for (; *s; s++)
  800914:	83 c0 01             	add    $0x1,%eax
  800917:	eb f0                	jmp    800909 <strchr+0xa>
			return (char *) s;
	return 0;
  800919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092a:	eb 03                	jmp    80092f <strfind+0xf>
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800932:	38 ca                	cmp    %cl,%dl
  800934:	74 04                	je     80093a <strfind+0x1a>
  800936:	84 d2                	test   %dl,%dl
  800938:	75 f2                	jne    80092c <strfind+0xc>
			break;
	return (char *) s;
}
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	57                   	push   %edi
  800940:	56                   	push   %esi
  800941:	53                   	push   %ebx
  800942:	8b 7d 08             	mov    0x8(%ebp),%edi
  800945:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800948:	85 c9                	test   %ecx,%ecx
  80094a:	74 13                	je     80095f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80094c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800952:	75 05                	jne    800959 <memset+0x1d>
  800954:	f6 c1 03             	test   $0x3,%cl
  800957:	74 0d                	je     800966 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095c:	fc                   	cld    
  80095d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095f:	89 f8                	mov    %edi,%eax
  800961:	5b                   	pop    %ebx
  800962:	5e                   	pop    %esi
  800963:	5f                   	pop    %edi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    
		c &= 0xFF;
  800966:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80096a:	89 d3                	mov    %edx,%ebx
  80096c:	c1 e3 08             	shl    $0x8,%ebx
  80096f:	89 d0                	mov    %edx,%eax
  800971:	c1 e0 18             	shl    $0x18,%eax
  800974:	89 d6                	mov    %edx,%esi
  800976:	c1 e6 10             	shl    $0x10,%esi
  800979:	09 f0                	or     %esi,%eax
  80097b:	09 c2                	or     %eax,%edx
  80097d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80097f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800982:	89 d0                	mov    %edx,%eax
  800984:	fc                   	cld    
  800985:	f3 ab                	rep stos %eax,%es:(%edi)
  800987:	eb d6                	jmp    80095f <memset+0x23>

00800989 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	57                   	push   %edi
  80098d:	56                   	push   %esi
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 75 0c             	mov    0xc(%ebp),%esi
  800994:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800997:	39 c6                	cmp    %eax,%esi
  800999:	73 35                	jae    8009d0 <memmove+0x47>
  80099b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80099e:	39 c2                	cmp    %eax,%edx
  8009a0:	76 2e                	jbe    8009d0 <memmove+0x47>
		s += n;
		d += n;
  8009a2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a5:	89 d6                	mov    %edx,%esi
  8009a7:	09 fe                	or     %edi,%esi
  8009a9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009af:	74 0c                	je     8009bd <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b1:	83 ef 01             	sub    $0x1,%edi
  8009b4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009b7:	fd                   	std    
  8009b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ba:	fc                   	cld    
  8009bb:	eb 21                	jmp    8009de <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bd:	f6 c1 03             	test   $0x3,%cl
  8009c0:	75 ef                	jne    8009b1 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c2:	83 ef 04             	sub    $0x4,%edi
  8009c5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009cb:	fd                   	std    
  8009cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ce:	eb ea                	jmp    8009ba <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d0:	89 f2                	mov    %esi,%edx
  8009d2:	09 c2                	or     %eax,%edx
  8009d4:	f6 c2 03             	test   $0x3,%dl
  8009d7:	74 09                	je     8009e2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d9:	89 c7                	mov    %eax,%edi
  8009db:	fc                   	cld    
  8009dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009de:	5e                   	pop    %esi
  8009df:	5f                   	pop    %edi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e2:	f6 c1 03             	test   $0x3,%cl
  8009e5:	75 f2                	jne    8009d9 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ea:	89 c7                	mov    %eax,%edi
  8009ec:	fc                   	cld    
  8009ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ef:	eb ed                	jmp    8009de <memmove+0x55>

008009f1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009f4:	ff 75 10             	pushl  0x10(%ebp)
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	e8 87 ff ff ff       	call   800989 <memmove>
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	56                   	push   %esi
  800a08:	53                   	push   %ebx
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0f:	89 c6                	mov    %eax,%esi
  800a11:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a14:	39 f0                	cmp    %esi,%eax
  800a16:	74 1c                	je     800a34 <memcmp+0x30>
		if (*s1 != *s2)
  800a18:	0f b6 08             	movzbl (%eax),%ecx
  800a1b:	0f b6 1a             	movzbl (%edx),%ebx
  800a1e:	38 d9                	cmp    %bl,%cl
  800a20:	75 08                	jne    800a2a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a22:	83 c0 01             	add    $0x1,%eax
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb ea                	jmp    800a14 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a2a:	0f b6 c1             	movzbl %cl,%eax
  800a2d:	0f b6 db             	movzbl %bl,%ebx
  800a30:	29 d8                	sub    %ebx,%eax
  800a32:	eb 05                	jmp    800a39 <memcmp+0x35>
	}

	return 0;
  800a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a39:	5b                   	pop    %ebx
  800a3a:	5e                   	pop    %esi
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a46:	89 c2                	mov    %eax,%edx
  800a48:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a4b:	39 d0                	cmp    %edx,%eax
  800a4d:	73 09                	jae    800a58 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a4f:	38 08                	cmp    %cl,(%eax)
  800a51:	74 05                	je     800a58 <memfind+0x1b>
	for (; s < ends; s++)
  800a53:	83 c0 01             	add    $0x1,%eax
  800a56:	eb f3                	jmp    800a4b <memfind+0xe>
			break;
	return (void *) s;
}
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	57                   	push   %edi
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a66:	eb 03                	jmp    800a6b <strtol+0x11>
		s++;
  800a68:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a6b:	0f b6 01             	movzbl (%ecx),%eax
  800a6e:	3c 20                	cmp    $0x20,%al
  800a70:	74 f6                	je     800a68 <strtol+0xe>
  800a72:	3c 09                	cmp    $0x9,%al
  800a74:	74 f2                	je     800a68 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a76:	3c 2b                	cmp    $0x2b,%al
  800a78:	74 2e                	je     800aa8 <strtol+0x4e>
	int neg = 0;
  800a7a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a7f:	3c 2d                	cmp    $0x2d,%al
  800a81:	74 2f                	je     800ab2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a83:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a89:	75 05                	jne    800a90 <strtol+0x36>
  800a8b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a8e:	74 2c                	je     800abc <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a90:	85 db                	test   %ebx,%ebx
  800a92:	75 0a                	jne    800a9e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a94:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a99:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9c:	74 28                	je     800ac6 <strtol+0x6c>
		base = 10;
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa6:	eb 50                	jmp    800af8 <strtol+0x9e>
		s++;
  800aa8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aab:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab0:	eb d1                	jmp    800a83 <strtol+0x29>
		s++, neg = 1;
  800ab2:	83 c1 01             	add    $0x1,%ecx
  800ab5:	bf 01 00 00 00       	mov    $0x1,%edi
  800aba:	eb c7                	jmp    800a83 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac0:	74 0e                	je     800ad0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac2:	85 db                	test   %ebx,%ebx
  800ac4:	75 d8                	jne    800a9e <strtol+0x44>
		s++, base = 8;
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ace:	eb ce                	jmp    800a9e <strtol+0x44>
		s += 2, base = 16;
  800ad0:	83 c1 02             	add    $0x2,%ecx
  800ad3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ad8:	eb c4                	jmp    800a9e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ada:	8d 72 9f             	lea    -0x61(%edx),%esi
  800add:	89 f3                	mov    %esi,%ebx
  800adf:	80 fb 19             	cmp    $0x19,%bl
  800ae2:	77 29                	ja     800b0d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ae4:	0f be d2             	movsbl %dl,%edx
  800ae7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aea:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aed:	7d 30                	jge    800b1f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aef:	83 c1 01             	add    $0x1,%ecx
  800af2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800af6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af8:	0f b6 11             	movzbl (%ecx),%edx
  800afb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800afe:	89 f3                	mov    %esi,%ebx
  800b00:	80 fb 09             	cmp    $0x9,%bl
  800b03:	77 d5                	ja     800ada <strtol+0x80>
			dig = *s - '0';
  800b05:	0f be d2             	movsbl %dl,%edx
  800b08:	83 ea 30             	sub    $0x30,%edx
  800b0b:	eb dd                	jmp    800aea <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b0d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b10:	89 f3                	mov    %esi,%ebx
  800b12:	80 fb 19             	cmp    $0x19,%bl
  800b15:	77 08                	ja     800b1f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b17:	0f be d2             	movsbl %dl,%edx
  800b1a:	83 ea 37             	sub    $0x37,%edx
  800b1d:	eb cb                	jmp    800aea <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b23:	74 05                	je     800b2a <strtol+0xd0>
		*endptr = (char *) s;
  800b25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b28:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2a:	89 c2                	mov    %eax,%edx
  800b2c:	f7 da                	neg    %edx
  800b2e:	85 ff                	test   %edi,%edi
  800b30:	0f 45 c2             	cmovne %edx,%eax
}
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
  800b46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b49:	89 c3                	mov    %eax,%ebx
  800b4b:	89 c7                	mov    %eax,%edi
  800b4d:	89 c6                	mov    %eax,%esi
  800b4f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <sys_cgetc>:

int
sys_cgetc(void) {
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	b8 01 00 00 00       	mov    $0x1,%eax
  800b66:	89 d1                	mov    %edx,%ecx
  800b68:	89 d3                	mov    %edx,%ebx
  800b6a:	89 d7                	mov    %edx,%edi
  800b6c:	89 d6                	mov    %edx,%esi
  800b6e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b83:	8b 55 08             	mov    0x8(%ebp),%edx
  800b86:	b8 03 00 00 00       	mov    $0x3,%eax
  800b8b:	89 cb                	mov    %ecx,%ebx
  800b8d:	89 cf                	mov    %ecx,%edi
  800b8f:	89 ce                	mov    %ecx,%esi
  800b91:	cd 30                	int    $0x30
    if (check && ret > 0)
  800b93:	85 c0                	test   %eax,%eax
  800b95:	7f 08                	jg     800b9f <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5f                   	pop    %edi
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800b9f:	83 ec 0c             	sub    $0xc,%esp
  800ba2:	50                   	push   %eax
  800ba3:	6a 03                	push   $0x3
  800ba5:	68 44 13 80 00       	push   $0x801344
  800baa:	6a 24                	push   $0x24
  800bac:	68 61 13 80 00       	push   $0x801361
  800bb1:	e8 82 02 00 00       	call   800e38 <_panic>

00800bb6 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc1:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc6:	89 d1                	mov    %edx,%ecx
  800bc8:	89 d3                	mov    %edx,%ebx
  800bca:	89 d7                	mov    %edx,%edi
  800bcc:	89 d6                	mov    %edx,%esi
  800bce:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_yield>:

void
sys_yield(void)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be5:	89 d1                	mov    %edx,%ecx
  800be7:	89 d3                	mov    %edx,%ebx
  800be9:	89 d7                	mov    %edx,%edi
  800beb:	89 d6                	mov    %edx,%esi
  800bed:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
  800bfa:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bfd:	be 00 00 00 00       	mov    $0x0,%esi
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	b8 04 00 00 00       	mov    $0x4,%eax
  800c0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c10:	89 f7                	mov    %esi,%edi
  800c12:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c14:	85 c0                	test   %eax,%eax
  800c16:	7f 08                	jg     800c20 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c20:	83 ec 0c             	sub    $0xc,%esp
  800c23:	50                   	push   %eax
  800c24:	6a 04                	push   $0x4
  800c26:	68 44 13 80 00       	push   $0x801344
  800c2b:	6a 24                	push   $0x24
  800c2d:	68 61 13 80 00       	push   $0x801361
  800c32:	e8 01 02 00 00       	call   800e38 <_panic>

00800c37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c46:	b8 05 00 00 00       	mov    $0x5,%eax
  800c4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c51:	8b 75 18             	mov    0x18(%ebp),%esi
  800c54:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c56:	85 c0                	test   %eax,%eax
  800c58:	7f 08                	jg     800c62 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	50                   	push   %eax
  800c66:	6a 05                	push   $0x5
  800c68:	68 44 13 80 00       	push   $0x801344
  800c6d:	6a 24                	push   $0x24
  800c6f:	68 61 13 80 00       	push   $0x801361
  800c74:	e8 bf 01 00 00       	call   800e38 <_panic>

00800c79 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
  800c7f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c87:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c92:	89 df                	mov    %ebx,%edi
  800c94:	89 de                	mov    %ebx,%esi
  800c96:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c98:	85 c0                	test   %eax,%eax
  800c9a:	7f 08                	jg     800ca4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ca4:	83 ec 0c             	sub    $0xc,%esp
  800ca7:	50                   	push   %eax
  800ca8:	6a 06                	push   $0x6
  800caa:	68 44 13 80 00       	push   $0x801344
  800caf:	6a 24                	push   $0x24
  800cb1:	68 61 13 80 00       	push   $0x801361
  800cb6:	e8 7d 01 00 00       	call   800e38 <_panic>

00800cbb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
  800cc1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd4:	89 df                	mov    %ebx,%edi
  800cd6:	89 de                	mov    %ebx,%esi
  800cd8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	7f 08                	jg     800ce6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ce6:	83 ec 0c             	sub    $0xc,%esp
  800ce9:	50                   	push   %eax
  800cea:	6a 08                	push   $0x8
  800cec:	68 44 13 80 00       	push   $0x801344
  800cf1:	6a 24                	push   $0x24
  800cf3:	68 61 13 80 00       	push   $0x801361
  800cf8:	e8 3b 01 00 00       	call   800e38 <_panic>

00800cfd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 09 00 00 00       	mov    $0x9,%eax
  800d16:	89 df                	mov    %ebx,%edi
  800d18:	89 de                	mov    %ebx,%esi
  800d1a:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7f 08                	jg     800d28 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d28:	83 ec 0c             	sub    $0xc,%esp
  800d2b:	50                   	push   %eax
  800d2c:	6a 09                	push   $0x9
  800d2e:	68 44 13 80 00       	push   $0x801344
  800d33:	6a 24                	push   $0x24
  800d35:	68 61 13 80 00       	push   $0x801361
  800d3a:	e8 f9 00 00 00       	call   800e38 <_panic>

00800d3f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d50:	be 00 00 00 00       	mov    $0x0,%esi
  800d55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d78:	89 cb                	mov    %ecx,%ebx
  800d7a:	89 cf                	mov    %ecx,%edi
  800d7c:	89 ce                	mov    %ecx,%esi
  800d7e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 0c                	push   $0xc
  800d92:	68 44 13 80 00       	push   $0x801344
  800d97:	6a 24                	push   $0x24
  800d99:	68 61 13 80 00       	push   $0x801361
  800d9e:	e8 95 00 00 00       	call   800e38 <_panic>

00800da3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800da9:	68 7b 13 80 00       	push   $0x80137b
  800dae:	6a 51                	push   $0x51
  800db0:	68 6f 13 80 00       	push   $0x80136f
  800db5:	e8 7e 00 00 00       	call   800e38 <_panic>

00800dba <sfork>:
}

// Challenge!
int
sfork(void)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800dc0:	68 7a 13 80 00       	push   $0x80137a
  800dc5:	6a 58                	push   $0x58
  800dc7:	68 6f 13 80 00       	push   $0x80136f
  800dcc:	e8 67 00 00 00       	call   800e38 <_panic>

00800dd1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800dd7:	68 90 13 80 00       	push   $0x801390
  800ddc:	6a 1a                	push   $0x1a
  800dde:	68 a9 13 80 00       	push   $0x8013a9
  800de3:	e8 50 00 00 00       	call   800e38 <_panic>

00800de8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800dee:	68 b3 13 80 00       	push   $0x8013b3
  800df3:	6a 2a                	push   $0x2a
  800df5:	68 a9 13 80 00       	push   $0x8013a9
  800dfa:	e8 39 00 00 00       	call   800e38 <_panic>

00800dff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800e05:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800e0a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800e0d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800e13:	8b 52 50             	mov    0x50(%edx),%edx
  800e16:	39 ca                	cmp    %ecx,%edx
  800e18:	74 11                	je     800e2b <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800e1a:	83 c0 01             	add    $0x1,%eax
  800e1d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800e22:	75 e6                	jne    800e0a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
  800e29:	eb 0b                	jmp    800e36 <ipc_find_env+0x37>
			return envs[i].env_id;
  800e2b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e2e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e33:	8b 40 48             	mov    0x48(%eax),%eax
}
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    

00800e38 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e3d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e40:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e46:	e8 6b fd ff ff       	call   800bb6 <sys_getenvid>
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	ff 75 0c             	pushl  0xc(%ebp)
  800e51:	ff 75 08             	pushl  0x8(%ebp)
  800e54:	56                   	push   %esi
  800e55:	50                   	push   %eax
  800e56:	68 cc 13 80 00       	push   $0x8013cc
  800e5b:	e8 3d f3 ff ff       	call   80019d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e60:	83 c4 18             	add    $0x18,%esp
  800e63:	53                   	push   %ebx
  800e64:	ff 75 10             	pushl  0x10(%ebp)
  800e67:	e8 e0 f2 ff ff       	call   80014c <vcprintf>
	cprintf("\n");
  800e6c:	c7 04 24 e7 10 80 00 	movl   $0x8010e7,(%esp)
  800e73:	e8 25 f3 ff ff       	call   80019d <cprintf>
  800e78:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e7b:	cc                   	int3   
  800e7c:	eb fd                	jmp    800e7b <_panic+0x43>
  800e7e:	66 90                	xchg   %ax,%ax

00800e80 <__udivdi3>:
  800e80:	55                   	push   %ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 1c             	sub    $0x1c,%esp
  800e87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e97:	85 d2                	test   %edx,%edx
  800e99:	75 35                	jne    800ed0 <__udivdi3+0x50>
  800e9b:	39 f3                	cmp    %esi,%ebx
  800e9d:	0f 87 bd 00 00 00    	ja     800f60 <__udivdi3+0xe0>
  800ea3:	85 db                	test   %ebx,%ebx
  800ea5:	89 d9                	mov    %ebx,%ecx
  800ea7:	75 0b                	jne    800eb4 <__udivdi3+0x34>
  800ea9:	b8 01 00 00 00       	mov    $0x1,%eax
  800eae:	31 d2                	xor    %edx,%edx
  800eb0:	f7 f3                	div    %ebx
  800eb2:	89 c1                	mov    %eax,%ecx
  800eb4:	31 d2                	xor    %edx,%edx
  800eb6:	89 f0                	mov    %esi,%eax
  800eb8:	f7 f1                	div    %ecx
  800eba:	89 c6                	mov    %eax,%esi
  800ebc:	89 e8                	mov    %ebp,%eax
  800ebe:	89 f7                	mov    %esi,%edi
  800ec0:	f7 f1                	div    %ecx
  800ec2:	89 fa                	mov    %edi,%edx
  800ec4:	83 c4 1c             	add    $0x1c,%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    
  800ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ed0:	39 f2                	cmp    %esi,%edx
  800ed2:	77 7c                	ja     800f50 <__udivdi3+0xd0>
  800ed4:	0f bd fa             	bsr    %edx,%edi
  800ed7:	83 f7 1f             	xor    $0x1f,%edi
  800eda:	0f 84 98 00 00 00    	je     800f78 <__udivdi3+0xf8>
  800ee0:	89 f9                	mov    %edi,%ecx
  800ee2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ee7:	29 f8                	sub    %edi,%eax
  800ee9:	d3 e2                	shl    %cl,%edx
  800eeb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800eef:	89 c1                	mov    %eax,%ecx
  800ef1:	89 da                	mov    %ebx,%edx
  800ef3:	d3 ea                	shr    %cl,%edx
  800ef5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ef9:	09 d1                	or     %edx,%ecx
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f01:	89 f9                	mov    %edi,%ecx
  800f03:	d3 e3                	shl    %cl,%ebx
  800f05:	89 c1                	mov    %eax,%ecx
  800f07:	d3 ea                	shr    %cl,%edx
  800f09:	89 f9                	mov    %edi,%ecx
  800f0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f0f:	d3 e6                	shl    %cl,%esi
  800f11:	89 eb                	mov    %ebp,%ebx
  800f13:	89 c1                	mov    %eax,%ecx
  800f15:	d3 eb                	shr    %cl,%ebx
  800f17:	09 de                	or     %ebx,%esi
  800f19:	89 f0                	mov    %esi,%eax
  800f1b:	f7 74 24 08          	divl   0x8(%esp)
  800f1f:	89 d6                	mov    %edx,%esi
  800f21:	89 c3                	mov    %eax,%ebx
  800f23:	f7 64 24 0c          	mull   0xc(%esp)
  800f27:	39 d6                	cmp    %edx,%esi
  800f29:	72 0c                	jb     800f37 <__udivdi3+0xb7>
  800f2b:	89 f9                	mov    %edi,%ecx
  800f2d:	d3 e5                	shl    %cl,%ebp
  800f2f:	39 c5                	cmp    %eax,%ebp
  800f31:	73 5d                	jae    800f90 <__udivdi3+0x110>
  800f33:	39 d6                	cmp    %edx,%esi
  800f35:	75 59                	jne    800f90 <__udivdi3+0x110>
  800f37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f3a:	31 ff                	xor    %edi,%edi
  800f3c:	89 fa                	mov    %edi,%edx
  800f3e:	83 c4 1c             	add    $0x1c,%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    
  800f46:	8d 76 00             	lea    0x0(%esi),%esi
  800f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f50:	31 ff                	xor    %edi,%edi
  800f52:	31 c0                	xor    %eax,%eax
  800f54:	89 fa                	mov    %edi,%edx
  800f56:	83 c4 1c             	add    $0x1c,%esp
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    
  800f5e:	66 90                	xchg   %ax,%ax
  800f60:	31 ff                	xor    %edi,%edi
  800f62:	89 e8                	mov    %ebp,%eax
  800f64:	89 f2                	mov    %esi,%edx
  800f66:	f7 f3                	div    %ebx
  800f68:	89 fa                	mov    %edi,%edx
  800f6a:	83 c4 1c             	add    $0x1c,%esp
  800f6d:	5b                   	pop    %ebx
  800f6e:	5e                   	pop    %esi
  800f6f:	5f                   	pop    %edi
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    
  800f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f78:	39 f2                	cmp    %esi,%edx
  800f7a:	72 06                	jb     800f82 <__udivdi3+0x102>
  800f7c:	31 c0                	xor    %eax,%eax
  800f7e:	39 eb                	cmp    %ebp,%ebx
  800f80:	77 d2                	ja     800f54 <__udivdi3+0xd4>
  800f82:	b8 01 00 00 00       	mov    $0x1,%eax
  800f87:	eb cb                	jmp    800f54 <__udivdi3+0xd4>
  800f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f90:	89 d8                	mov    %ebx,%eax
  800f92:	31 ff                	xor    %edi,%edi
  800f94:	eb be                	jmp    800f54 <__udivdi3+0xd4>
  800f96:	66 90                	xchg   %ax,%ax
  800f98:	66 90                	xchg   %ax,%ax
  800f9a:	66 90                	xchg   %ax,%ax
  800f9c:	66 90                	xchg   %ax,%ax
  800f9e:	66 90                	xchg   %ax,%ax

00800fa0 <__umoddi3>:
  800fa0:	55                   	push   %ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 1c             	sub    $0x1c,%esp
  800fa7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800fab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800faf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800fb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800fb7:	85 ed                	test   %ebp,%ebp
  800fb9:	89 f0                	mov    %esi,%eax
  800fbb:	89 da                	mov    %ebx,%edx
  800fbd:	75 19                	jne    800fd8 <__umoddi3+0x38>
  800fbf:	39 df                	cmp    %ebx,%edi
  800fc1:	0f 86 b1 00 00 00    	jbe    801078 <__umoddi3+0xd8>
  800fc7:	f7 f7                	div    %edi
  800fc9:	89 d0                	mov    %edx,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	83 c4 1c             	add    $0x1c,%esp
  800fd0:	5b                   	pop    %ebx
  800fd1:	5e                   	pop    %esi
  800fd2:	5f                   	pop    %edi
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    
  800fd5:	8d 76 00             	lea    0x0(%esi),%esi
  800fd8:	39 dd                	cmp    %ebx,%ebp
  800fda:	77 f1                	ja     800fcd <__umoddi3+0x2d>
  800fdc:	0f bd cd             	bsr    %ebp,%ecx
  800fdf:	83 f1 1f             	xor    $0x1f,%ecx
  800fe2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fe6:	0f 84 b4 00 00 00    	je     8010a0 <__umoddi3+0x100>
  800fec:	b8 20 00 00 00       	mov    $0x20,%eax
  800ff1:	89 c2                	mov    %eax,%edx
  800ff3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ff7:	29 c2                	sub    %eax,%edx
  800ff9:	89 c1                	mov    %eax,%ecx
  800ffb:	89 f8                	mov    %edi,%eax
  800ffd:	d3 e5                	shl    %cl,%ebp
  800fff:	89 d1                	mov    %edx,%ecx
  801001:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801005:	d3 e8                	shr    %cl,%eax
  801007:	09 c5                	or     %eax,%ebp
  801009:	8b 44 24 04          	mov    0x4(%esp),%eax
  80100d:	89 c1                	mov    %eax,%ecx
  80100f:	d3 e7                	shl    %cl,%edi
  801011:	89 d1                	mov    %edx,%ecx
  801013:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801017:	89 df                	mov    %ebx,%edi
  801019:	d3 ef                	shr    %cl,%edi
  80101b:	89 c1                	mov    %eax,%ecx
  80101d:	89 f0                	mov    %esi,%eax
  80101f:	d3 e3                	shl    %cl,%ebx
  801021:	89 d1                	mov    %edx,%ecx
  801023:	89 fa                	mov    %edi,%edx
  801025:	d3 e8                	shr    %cl,%eax
  801027:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80102c:	09 d8                	or     %ebx,%eax
  80102e:	f7 f5                	div    %ebp
  801030:	d3 e6                	shl    %cl,%esi
  801032:	89 d1                	mov    %edx,%ecx
  801034:	f7 64 24 08          	mull   0x8(%esp)
  801038:	39 d1                	cmp    %edx,%ecx
  80103a:	89 c3                	mov    %eax,%ebx
  80103c:	89 d7                	mov    %edx,%edi
  80103e:	72 06                	jb     801046 <__umoddi3+0xa6>
  801040:	75 0e                	jne    801050 <__umoddi3+0xb0>
  801042:	39 c6                	cmp    %eax,%esi
  801044:	73 0a                	jae    801050 <__umoddi3+0xb0>
  801046:	2b 44 24 08          	sub    0x8(%esp),%eax
  80104a:	19 ea                	sbb    %ebp,%edx
  80104c:	89 d7                	mov    %edx,%edi
  80104e:	89 c3                	mov    %eax,%ebx
  801050:	89 ca                	mov    %ecx,%edx
  801052:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801057:	29 de                	sub    %ebx,%esi
  801059:	19 fa                	sbb    %edi,%edx
  80105b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80105f:	89 d0                	mov    %edx,%eax
  801061:	d3 e0                	shl    %cl,%eax
  801063:	89 d9                	mov    %ebx,%ecx
  801065:	d3 ee                	shr    %cl,%esi
  801067:	d3 ea                	shr    %cl,%edx
  801069:	09 f0                	or     %esi,%eax
  80106b:	83 c4 1c             	add    $0x1c,%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    
  801073:	90                   	nop
  801074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801078:	85 ff                	test   %edi,%edi
  80107a:	89 f9                	mov    %edi,%ecx
  80107c:	75 0b                	jne    801089 <__umoddi3+0xe9>
  80107e:	b8 01 00 00 00       	mov    $0x1,%eax
  801083:	31 d2                	xor    %edx,%edx
  801085:	f7 f7                	div    %edi
  801087:	89 c1                	mov    %eax,%ecx
  801089:	89 d8                	mov    %ebx,%eax
  80108b:	31 d2                	xor    %edx,%edx
  80108d:	f7 f1                	div    %ecx
  80108f:	89 f0                	mov    %esi,%eax
  801091:	f7 f1                	div    %ecx
  801093:	e9 31 ff ff ff       	jmp    800fc9 <__umoddi3+0x29>
  801098:	90                   	nop
  801099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a0:	39 dd                	cmp    %ebx,%ebp
  8010a2:	72 08                	jb     8010ac <__umoddi3+0x10c>
  8010a4:	39 f7                	cmp    %esi,%edi
  8010a6:	0f 87 21 ff ff ff    	ja     800fcd <__umoddi3+0x2d>
  8010ac:	89 da                	mov    %ebx,%edx
  8010ae:	89 f0                	mov    %esi,%eax
  8010b0:	29 f8                	sub    %edi,%eax
  8010b2:	19 ea                	sbb    %ebp,%edx
  8010b4:	e9 14 ff ff ff       	jmp    800fcd <__umoddi3+0x2d>
