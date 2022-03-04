
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
  80003c:	e8 10 0e 00 00       	call   800e51 <fork>
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
  800053:	e8 05 10 00 00       	call   80105d <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 64 0b 00 00       	call   800bc6 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 f6 13 80 00       	push   $0x8013f6
  80006a:	e8 3e 01 00 00       	call   8001ad <cprintf>
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
  800082:	e8 ed 0f 00 00       	call   801074 <ipc_send>
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
  800099:	e8 28 0b 00 00       	call   800bc6 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 e0 13 80 00       	push   $0x8013e0
  8000a8:	e8 00 01 00 00       	call   8001ad <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 b9 0f 00 00       	call   801074 <ipc_send>
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
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 f6 0a 00 00       	call   800bc6 <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80010c:	6a 00                	push   $0x0
  80010e:	e8 72 0a 00 00       	call   800b85 <sys_env_destroy>
}
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	53                   	push   %ebx
  80011c:	83 ec 04             	sub    $0x4,%esp
  80011f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800122:	8b 13                	mov    (%ebx),%edx
  800124:	8d 42 01             	lea    0x1(%edx),%eax
  800127:	89 03                	mov    %eax,(%ebx)
  800129:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800130:	3d ff 00 00 00       	cmp    $0xff,%eax
  800135:	74 09                	je     800140 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800137:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	68 ff 00 00 00       	push   $0xff
  800148:	8d 43 08             	lea    0x8(%ebx),%eax
  80014b:	50                   	push   %eax
  80014c:	e8 f7 09 00 00       	call   800b48 <sys_cputs>
		b->idx = 0;
  800151:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb db                	jmp    800137 <putch+0x1f>

0080015c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800165:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016c:	00 00 00 
	b.cnt = 0;
  80016f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800176:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800179:	ff 75 0c             	pushl  0xc(%ebp)
  80017c:	ff 75 08             	pushl  0x8(%ebp)
  80017f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	68 18 01 80 00       	push   $0x800118
  80018b:	e8 1a 01 00 00       	call   8002aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800190:	83 c4 08             	add    $0x8,%esp
  800193:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800199:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 a3 09 00 00       	call   800b48 <sys_cputs>

	return b.cnt;
}
  8001a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b6:	50                   	push   %eax
  8001b7:	ff 75 08             	pushl  0x8(%ebp)
  8001ba:	e8 9d ff ff ff       	call   80015c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    

008001c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 1c             	sub    $0x1c,%esp
  8001ca:	89 c7                	mov    %eax,%edi
  8001cc:	89 d6                	mov    %edx,%esi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e8:	39 d3                	cmp    %edx,%ebx
  8001ea:	72 05                	jb     8001f1 <printnum+0x30>
  8001ec:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ef:	77 7a                	ja     80026b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8001fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fd:	53                   	push   %ebx
  8001fe:	ff 75 10             	pushl  0x10(%ebp)
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	ff 75 e4             	pushl  -0x1c(%ebp)
  800207:	ff 75 e0             	pushl  -0x20(%ebp)
  80020a:	ff 75 dc             	pushl  -0x24(%ebp)
  80020d:	ff 75 d8             	pushl  -0x28(%ebp)
  800210:	e8 7b 0f 00 00       	call   801190 <__udivdi3>
  800215:	83 c4 18             	add    $0x18,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	89 f2                	mov    %esi,%edx
  80021c:	89 f8                	mov    %edi,%eax
  80021e:	e8 9e ff ff ff       	call   8001c1 <printnum>
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	eb 13                	jmp    80023b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	ff 75 18             	pushl  0x18(%ebp)
  80022f:	ff d7                	call   *%edi
  800231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ed                	jg     800228 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	ff 75 dc             	pushl  -0x24(%ebp)
  80024b:	ff 75 d8             	pushl  -0x28(%ebp)
  80024e:	e8 5d 10 00 00       	call   8012b0 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 13 14 80 00 	movsbl 0x801413(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
  80026b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026e:	eb c4                	jmp    800234 <printnum+0x73>

00800270 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800276:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027a:	8b 10                	mov    (%eax),%edx
  80027c:	3b 50 04             	cmp    0x4(%eax),%edx
  80027f:	73 0a                	jae    80028b <sprintputch+0x1b>
		*b->buf++ = ch;
  800281:	8d 4a 01             	lea    0x1(%edx),%ecx
  800284:	89 08                	mov    %ecx,(%eax)
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	88 02                	mov    %al,(%edx)
}
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <printfmt>:
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800293:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800296:	50                   	push   %eax
  800297:	ff 75 10             	pushl  0x10(%ebp)
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	e8 05 00 00 00       	call   8002aa <vprintfmt>
}
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <vprintfmt>:
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 2c             	sub    $0x2c,%esp
  8002b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bc:	e9 00 04 00 00       	jmp    8006c1 <vprintfmt+0x417>
		padc = ' ';
  8002c1:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002cc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8d 47 01             	lea    0x1(%edi),%eax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e5:	0f b6 17             	movzbl (%edi),%edx
  8002e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002eb:	3c 55                	cmp    $0x55,%al
  8002ed:	0f 87 51 04 00 00    	ja     800744 <vprintfmt+0x49a>
  8002f3:	0f b6 c0             	movzbl %al,%eax
  8002f6:	ff 24 85 e0 14 80 00 	jmp    *0x8014e0(,%eax,4)
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800300:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800304:	eb d9                	jmp    8002df <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800309:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030d:	eb d0                	jmp    8002df <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	0f b6 d2             	movzbl %dl,%edx
  800312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800315:	b8 00 00 00 00       	mov    $0x0,%eax
  80031a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800320:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800324:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800327:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032a:	83 f9 09             	cmp    $0x9,%ecx
  80032d:	77 55                	ja     800384 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80032f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800332:	eb e9                	jmp    80031d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800334:	8b 45 14             	mov    0x14(%ebp),%eax
  800337:	8b 00                	mov    (%eax),%eax
  800339:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8d 40 04             	lea    0x4(%eax),%eax
  800342:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800345:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800348:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034c:	79 91                	jns    8002df <vprintfmt+0x35>
				width = precision, precision = -1;
  80034e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80035b:	eb 82                	jmp    8002df <vprintfmt+0x35>
  80035d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800360:	85 c0                	test   %eax,%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
  800367:	0f 49 d0             	cmovns %eax,%edx
  80036a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800370:	e9 6a ff ff ff       	jmp    8002df <vprintfmt+0x35>
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800378:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80037f:	e9 5b ff ff ff       	jmp    8002df <vprintfmt+0x35>
  800384:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800387:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038a:	eb bc                	jmp    800348 <vprintfmt+0x9e>
			lflag++;
  80038c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800392:	e9 48 ff ff ff       	jmp    8002df <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8d 78 04             	lea    0x4(%eax),%edi
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	53                   	push   %ebx
  8003a1:	ff 30                	pushl  (%eax)
  8003a3:	ff d6                	call   *%esi
			break;
  8003a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ab:	e9 0e 03 00 00       	jmp    8006be <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 78 04             	lea    0x4(%eax),%edi
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	99                   	cltd   
  8003b9:	31 d0                	xor    %edx,%eax
  8003bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bd:	83 f8 08             	cmp    $0x8,%eax
  8003c0:	7f 23                	jg     8003e5 <vprintfmt+0x13b>
  8003c2:	8b 14 85 40 16 80 00 	mov    0x801640(,%eax,4),%edx
  8003c9:	85 d2                	test   %edx,%edx
  8003cb:	74 18                	je     8003e5 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003cd:	52                   	push   %edx
  8003ce:	68 34 14 80 00       	push   $0x801434
  8003d3:	53                   	push   %ebx
  8003d4:	56                   	push   %esi
  8003d5:	e8 b3 fe ff ff       	call   80028d <printfmt>
  8003da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e0:	e9 d9 02 00 00       	jmp    8006be <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003e5:	50                   	push   %eax
  8003e6:	68 2b 14 80 00       	push   $0x80142b
  8003eb:	53                   	push   %ebx
  8003ec:	56                   	push   %esi
  8003ed:	e8 9b fe ff ff       	call   80028d <printfmt>
  8003f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f8:	e9 c1 02 00 00       	jmp    8006be <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80040b:	85 ff                	test   %edi,%edi
  80040d:	b8 24 14 80 00       	mov    $0x801424,%eax
  800412:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800419:	0f 8e bd 00 00 00    	jle    8004dc <vprintfmt+0x232>
  80041f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800423:	75 0e                	jne    800433 <vprintfmt+0x189>
  800425:	89 75 08             	mov    %esi,0x8(%ebp)
  800428:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800431:	eb 6d                	jmp    8004a0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	ff 75 d0             	pushl  -0x30(%ebp)
  800439:	57                   	push   %edi
  80043a:	e8 ad 03 00 00       	call   8007ec <strnlen>
  80043f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800442:	29 c1                	sub    %eax,%ecx
  800444:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800447:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80044a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800451:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800454:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800456:	eb 0f                	jmp    800467 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	ff 75 e0             	pushl  -0x20(%ebp)
  80045f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	83 ef 01             	sub    $0x1,%edi
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	85 ff                	test   %edi,%edi
  800469:	7f ed                	jg     800458 <vprintfmt+0x1ae>
  80046b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800471:	85 c9                	test   %ecx,%ecx
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	0f 49 c1             	cmovns %ecx,%eax
  80047b:	29 c1                	sub    %eax,%ecx
  80047d:	89 75 08             	mov    %esi,0x8(%ebp)
  800480:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800483:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800486:	89 cb                	mov    %ecx,%ebx
  800488:	eb 16                	jmp    8004a0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80048a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048e:	75 31                	jne    8004c1 <vprintfmt+0x217>
					putch(ch, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	ff 75 0c             	pushl  0xc(%ebp)
  800496:	50                   	push   %eax
  800497:	ff 55 08             	call   *0x8(%ebp)
  80049a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049d:	83 eb 01             	sub    $0x1,%ebx
  8004a0:	83 c7 01             	add    $0x1,%edi
  8004a3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a7:	0f be c2             	movsbl %dl,%eax
  8004aa:	85 c0                	test   %eax,%eax
  8004ac:	74 59                	je     800507 <vprintfmt+0x25d>
  8004ae:	85 f6                	test   %esi,%esi
  8004b0:	78 d8                	js     80048a <vprintfmt+0x1e0>
  8004b2:	83 ee 01             	sub    $0x1,%esi
  8004b5:	79 d3                	jns    80048a <vprintfmt+0x1e0>
  8004b7:	89 df                	mov    %ebx,%edi
  8004b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bf:	eb 37                	jmp    8004f8 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c1:	0f be d2             	movsbl %dl,%edx
  8004c4:	83 ea 20             	sub    $0x20,%edx
  8004c7:	83 fa 5e             	cmp    $0x5e,%edx
  8004ca:	76 c4                	jbe    800490 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	ff 75 0c             	pushl  0xc(%ebp)
  8004d2:	6a 3f                	push   $0x3f
  8004d4:	ff 55 08             	call   *0x8(%ebp)
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	eb c1                	jmp    80049d <vprintfmt+0x1f3>
  8004dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8004df:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e8:	eb b6                	jmp    8004a0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	6a 20                	push   $0x20
  8004f0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f2:	83 ef 01             	sub    $0x1,%edi
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	85 ff                	test   %edi,%edi
  8004fa:	7f ee                	jg     8004ea <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	e9 b7 01 00 00       	jmp    8006be <vprintfmt+0x414>
  800507:	89 df                	mov    %ebx,%edi
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	eb e7                	jmp    8004f8 <vprintfmt+0x24e>
	if (lflag >= 2)
  800511:	83 f9 01             	cmp    $0x1,%ecx
  800514:	7e 3f                	jle    800555 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8b 50 04             	mov    0x4(%eax),%edx
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 08             	lea    0x8(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800531:	79 5c                	jns    80058f <vprintfmt+0x2e5>
				putch('-', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 2d                	push   $0x2d
  800539:	ff d6                	call   *%esi
				num = -(long long) num;
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800541:	f7 da                	neg    %edx
  800543:	83 d1 00             	adc    $0x0,%ecx
  800546:	f7 d9                	neg    %ecx
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 4f 01 00 00       	jmp    8006a4 <vprintfmt+0x3fa>
	else if (lflag)
  800555:	85 c9                	test   %ecx,%ecx
  800557:	75 1b                	jne    800574 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	89 c1                	mov    %eax,%ecx
  800563:	c1 f9 1f             	sar    $0x1f,%ecx
  800566:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 04             	lea    0x4(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	eb b9                	jmp    80052d <vprintfmt+0x283>
		return va_arg(*ap, long);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057c:	89 c1                	mov    %eax,%ecx
  80057e:	c1 f9 1f             	sar    $0x1f,%ecx
  800581:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8d 40 04             	lea    0x4(%eax),%eax
  80058a:	89 45 14             	mov    %eax,0x14(%ebp)
  80058d:	eb 9e                	jmp    80052d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80058f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800592:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800595:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059a:	e9 05 01 00 00       	jmp    8006a4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80059f:	83 f9 01             	cmp    $0x1,%ecx
  8005a2:	7e 18                	jle    8005bc <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ac:	8d 40 08             	lea    0x8(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b7:	e9 e8 00 00 00       	jmp    8006a4 <vprintfmt+0x3fa>
	else if (lflag)
  8005bc:	85 c9                	test   %ecx,%ecx
  8005be:	75 1a                	jne    8005da <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d5:	e9 ca 00 00 00       	jmp    8006a4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ef:	e9 b0 00 00 00       	jmp    8006a4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005f4:	83 f9 01             	cmp    $0x1,%ecx
  8005f7:	7e 3c                	jle    800635 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 50 04             	mov    0x4(%eax),%edx
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 40 08             	lea    0x8(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800610:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800614:	79 59                	jns    80066f <vprintfmt+0x3c5>
                putch('-', putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	6a 2d                	push   $0x2d
  80061c:	ff d6                	call   *%esi
                num = -(long long) num;
  80061e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800621:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800624:	f7 da                	neg    %edx
  800626:	83 d1 00             	adc    $0x0,%ecx
  800629:	f7 d9                	neg    %ecx
  80062b:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80062e:	b8 08 00 00 00       	mov    $0x8,%eax
  800633:	eb 6f                	jmp    8006a4 <vprintfmt+0x3fa>
	else if (lflag)
  800635:	85 c9                	test   %ecx,%ecx
  800637:	75 1b                	jne    800654 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 c1                	mov    %eax,%ecx
  800643:	c1 f9 1f             	sar    $0x1f,%ecx
  800646:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb bc                	jmp    800610 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 c1                	mov    %eax,%ecx
  80065e:	c1 f9 1f             	sar    $0x1f,%ecx
  800661:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	eb a1                	jmp    800610 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80066f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800672:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800675:	b8 08 00 00 00       	mov    $0x8,%eax
  80067a:	eb 28                	jmp    8006a4 <vprintfmt+0x3fa>
			putch('0', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	53                   	push   %ebx
  800680:	6a 30                	push   $0x30
  800682:	ff d6                	call   *%esi
			putch('x', putdat);
  800684:	83 c4 08             	add    $0x8,%esp
  800687:	53                   	push   %ebx
  800688:	6a 78                	push   $0x78
  80068a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 10                	mov    (%eax),%edx
  800691:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800696:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a4:	83 ec 0c             	sub    $0xc,%esp
  8006a7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ab:	57                   	push   %edi
  8006ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	51                   	push   %ecx
  8006b1:	52                   	push   %edx
  8006b2:	89 da                	mov    %ebx,%edx
  8006b4:	89 f0                	mov    %esi,%eax
  8006b6:	e8 06 fb ff ff       	call   8001c1 <printnum>
			break;
  8006bb:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c1:	83 c7 01             	add    $0x1,%edi
  8006c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c8:	83 f8 25             	cmp    $0x25,%eax
  8006cb:	0f 84 f0 fb ff ff    	je     8002c1 <vprintfmt+0x17>
			if (ch == '\0')
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	0f 84 8b 00 00 00    	je     800764 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	50                   	push   %eax
  8006de:	ff d6                	call   *%esi
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb dc                	jmp    8006c1 <vprintfmt+0x417>
	if (lflag >= 2)
  8006e5:	83 f9 01             	cmp    $0x1,%ecx
  8006e8:	7e 15                	jle    8006ff <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 10                	mov    (%eax),%edx
  8006ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f2:	8d 40 08             	lea    0x8(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fd:	eb a5                	jmp    8006a4 <vprintfmt+0x3fa>
	else if (lflag)
  8006ff:	85 c9                	test   %ecx,%ecx
  800701:	75 17                	jne    80071a <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 10                	mov    (%eax),%edx
  800708:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070d:	8d 40 04             	lea    0x4(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800713:	b8 10 00 00 00       	mov    $0x10,%eax
  800718:	eb 8a                	jmp    8006a4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 10                	mov    (%eax),%edx
  80071f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800724:	8d 40 04             	lea    0x4(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072a:	b8 10 00 00 00       	mov    $0x10,%eax
  80072f:	e9 70 ff ff ff       	jmp    8006a4 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	6a 25                	push   $0x25
  80073a:	ff d6                	call   *%esi
			break;
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	e9 7a ff ff ff       	jmp    8006be <vprintfmt+0x414>
			putch('%', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	6a 25                	push   $0x25
  80074a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	89 f8                	mov    %edi,%eax
  800751:	eb 03                	jmp    800756 <vprintfmt+0x4ac>
  800753:	83 e8 01             	sub    $0x1,%eax
  800756:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075a:	75 f7                	jne    800753 <vprintfmt+0x4a9>
  80075c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075f:	e9 5a ff ff ff       	jmp    8006be <vprintfmt+0x414>
}
  800764:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800767:	5b                   	pop    %ebx
  800768:	5e                   	pop    %esi
  800769:	5f                   	pop    %edi
  80076a:	5d                   	pop    %ebp
  80076b:	c3                   	ret    

0080076c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800778:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800782:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800789:	85 c0                	test   %eax,%eax
  80078b:	74 26                	je     8007b3 <vsnprintf+0x47>
  80078d:	85 d2                	test   %edx,%edx
  80078f:	7e 22                	jle    8007b3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800791:	ff 75 14             	pushl  0x14(%ebp)
  800794:	ff 75 10             	pushl  0x10(%ebp)
  800797:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079a:	50                   	push   %eax
  80079b:	68 70 02 80 00       	push   $0x800270
  8007a0:	e8 05 fb ff ff       	call   8002aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    
		return -E_INVAL;
  8007b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b8:	eb f7                	jmp    8007b1 <vsnprintf+0x45>

008007ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c3:	50                   	push   %eax
  8007c4:	ff 75 10             	pushl  0x10(%ebp)
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 9a ff ff ff       	call   80076c <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	eb 03                	jmp    8007e4 <strlen+0x10>
		n++;
  8007e1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e8:	75 f7                	jne    8007e1 <strlen+0xd>
	return n;
}
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fa:	eb 03                	jmp    8007ff <strnlen+0x13>
		n++;
  8007fc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ff:	39 d0                	cmp    %edx,%eax
  800801:	74 06                	je     800809 <strnlen+0x1d>
  800803:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800807:	75 f3                	jne    8007fc <strnlen+0x10>
	return n;
}
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	53                   	push   %ebx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800815:	89 c2                	mov    %eax,%edx
  800817:	83 c1 01             	add    $0x1,%ecx
  80081a:	83 c2 01             	add    $0x1,%edx
  80081d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800821:	88 5a ff             	mov    %bl,-0x1(%edx)
  800824:	84 db                	test   %bl,%bl
  800826:	75 ef                	jne    800817 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800828:	5b                   	pop    %ebx
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800832:	53                   	push   %ebx
  800833:	e8 9c ff ff ff       	call   8007d4 <strlen>
  800838:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	01 d8                	add    %ebx,%eax
  800840:	50                   	push   %eax
  800841:	e8 c5 ff ff ff       	call   80080b <strcpy>
	return dst;
}
  800846:	89 d8                	mov    %ebx,%eax
  800848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	56                   	push   %esi
  800851:	53                   	push   %ebx
  800852:	8b 75 08             	mov    0x8(%ebp),%esi
  800855:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800858:	89 f3                	mov    %esi,%ebx
  80085a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80085d:	89 f2                	mov    %esi,%edx
  80085f:	eb 0f                	jmp    800870 <strncpy+0x23>
		*dst++ = *src;
  800861:	83 c2 01             	add    $0x1,%edx
  800864:	0f b6 01             	movzbl (%ecx),%eax
  800867:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086a:	80 39 01             	cmpb   $0x1,(%ecx)
  80086d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800870:	39 da                	cmp    %ebx,%edx
  800872:	75 ed                	jne    800861 <strncpy+0x14>
	}
	return ret;
}
  800874:	89 f0                	mov    %esi,%eax
  800876:	5b                   	pop    %ebx
  800877:	5e                   	pop    %esi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	8b 75 08             	mov    0x8(%ebp),%esi
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
  800885:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800888:	89 f0                	mov    %esi,%eax
  80088a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80088e:	85 c9                	test   %ecx,%ecx
  800890:	75 0b                	jne    80089d <strlcpy+0x23>
  800892:	eb 17                	jmp    8008ab <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800894:	83 c2 01             	add    $0x1,%edx
  800897:	83 c0 01             	add    $0x1,%eax
  80089a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80089d:	39 d8                	cmp    %ebx,%eax
  80089f:	74 07                	je     8008a8 <strlcpy+0x2e>
  8008a1:	0f b6 0a             	movzbl (%edx),%ecx
  8008a4:	84 c9                	test   %cl,%cl
  8008a6:	75 ec                	jne    800894 <strlcpy+0x1a>
		*dst = '\0';
  8008a8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ab:	29 f0                	sub    %esi,%eax
}
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ba:	eb 06                	jmp    8008c2 <strcmp+0x11>
		p++, q++;
  8008bc:	83 c1 01             	add    $0x1,%ecx
  8008bf:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c2:	0f b6 01             	movzbl (%ecx),%eax
  8008c5:	84 c0                	test   %al,%al
  8008c7:	74 04                	je     8008cd <strcmp+0x1c>
  8008c9:	3a 02                	cmp    (%edx),%al
  8008cb:	74 ef                	je     8008bc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008cd:	0f b6 c0             	movzbl %al,%eax
  8008d0:	0f b6 12             	movzbl (%edx),%edx
  8008d3:	29 d0                	sub    %edx,%eax
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e1:	89 c3                	mov    %eax,%ebx
  8008e3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e6:	eb 06                	jmp    8008ee <strncmp+0x17>
		n--, p++, q++;
  8008e8:	83 c0 01             	add    $0x1,%eax
  8008eb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008ee:	39 d8                	cmp    %ebx,%eax
  8008f0:	74 16                	je     800908 <strncmp+0x31>
  8008f2:	0f b6 08             	movzbl (%eax),%ecx
  8008f5:	84 c9                	test   %cl,%cl
  8008f7:	74 04                	je     8008fd <strncmp+0x26>
  8008f9:	3a 0a                	cmp    (%edx),%cl
  8008fb:	74 eb                	je     8008e8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fd:	0f b6 00             	movzbl (%eax),%eax
  800900:	0f b6 12             	movzbl (%edx),%edx
  800903:	29 d0                	sub    %edx,%eax
}
  800905:	5b                   	pop    %ebx
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    
		return 0;
  800908:	b8 00 00 00 00       	mov    $0x0,%eax
  80090d:	eb f6                	jmp    800905 <strncmp+0x2e>

0080090f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800919:	0f b6 10             	movzbl (%eax),%edx
  80091c:	84 d2                	test   %dl,%dl
  80091e:	74 09                	je     800929 <strchr+0x1a>
		if (*s == c)
  800920:	38 ca                	cmp    %cl,%dl
  800922:	74 0a                	je     80092e <strchr+0x1f>
	for (; *s; s++)
  800924:	83 c0 01             	add    $0x1,%eax
  800927:	eb f0                	jmp    800919 <strchr+0xa>
			return (char *) s;
	return 0;
  800929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093a:	eb 03                	jmp    80093f <strfind+0xf>
  80093c:	83 c0 01             	add    $0x1,%eax
  80093f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800942:	38 ca                	cmp    %cl,%dl
  800944:	74 04                	je     80094a <strfind+0x1a>
  800946:	84 d2                	test   %dl,%dl
  800948:	75 f2                	jne    80093c <strfind+0xc>
			break;
	return (char *) s;
}
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	57                   	push   %edi
  800950:	56                   	push   %esi
  800951:	53                   	push   %ebx
  800952:	8b 7d 08             	mov    0x8(%ebp),%edi
  800955:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800958:	85 c9                	test   %ecx,%ecx
  80095a:	74 13                	je     80096f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80095c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800962:	75 05                	jne    800969 <memset+0x1d>
  800964:	f6 c1 03             	test   $0x3,%cl
  800967:	74 0d                	je     800976 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	fc                   	cld    
  80096d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80096f:	89 f8                	mov    %edi,%eax
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5f                   	pop    %edi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    
		c &= 0xFF;
  800976:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097a:	89 d3                	mov    %edx,%ebx
  80097c:	c1 e3 08             	shl    $0x8,%ebx
  80097f:	89 d0                	mov    %edx,%eax
  800981:	c1 e0 18             	shl    $0x18,%eax
  800984:	89 d6                	mov    %edx,%esi
  800986:	c1 e6 10             	shl    $0x10,%esi
  800989:	09 f0                	or     %esi,%eax
  80098b:	09 c2                	or     %eax,%edx
  80098d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80098f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800992:	89 d0                	mov    %edx,%eax
  800994:	fc                   	cld    
  800995:	f3 ab                	rep stos %eax,%es:(%edi)
  800997:	eb d6                	jmp    80096f <memset+0x23>

00800999 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	57                   	push   %edi
  80099d:	56                   	push   %esi
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a7:	39 c6                	cmp    %eax,%esi
  8009a9:	73 35                	jae    8009e0 <memmove+0x47>
  8009ab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ae:	39 c2                	cmp    %eax,%edx
  8009b0:	76 2e                	jbe    8009e0 <memmove+0x47>
		s += n;
		d += n;
  8009b2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b5:	89 d6                	mov    %edx,%esi
  8009b7:	09 fe                	or     %edi,%esi
  8009b9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009bf:	74 0c                	je     8009cd <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c1:	83 ef 01             	sub    $0x1,%edi
  8009c4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c7:	fd                   	std    
  8009c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ca:	fc                   	cld    
  8009cb:	eb 21                	jmp    8009ee <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cd:	f6 c1 03             	test   $0x3,%cl
  8009d0:	75 ef                	jne    8009c1 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d2:	83 ef 04             	sub    $0x4,%edi
  8009d5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009db:	fd                   	std    
  8009dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009de:	eb ea                	jmp    8009ca <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e0:	89 f2                	mov    %esi,%edx
  8009e2:	09 c2                	or     %eax,%edx
  8009e4:	f6 c2 03             	test   $0x3,%dl
  8009e7:	74 09                	je     8009f2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009e9:	89 c7                	mov    %eax,%edi
  8009eb:	fc                   	cld    
  8009ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009ee:	5e                   	pop    %esi
  8009ef:	5f                   	pop    %edi
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f2:	f6 c1 03             	test   $0x3,%cl
  8009f5:	75 f2                	jne    8009e9 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fa:	89 c7                	mov    %eax,%edi
  8009fc:	fc                   	cld    
  8009fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ff:	eb ed                	jmp    8009ee <memmove+0x55>

00800a01 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a04:	ff 75 10             	pushl  0x10(%ebp)
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 87 ff ff ff       	call   800999 <memmove>
}
  800a12:	c9                   	leave  
  800a13:	c3                   	ret    

00800a14 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	56                   	push   %esi
  800a18:	53                   	push   %ebx
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1f:	89 c6                	mov    %eax,%esi
  800a21:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a24:	39 f0                	cmp    %esi,%eax
  800a26:	74 1c                	je     800a44 <memcmp+0x30>
		if (*s1 != *s2)
  800a28:	0f b6 08             	movzbl (%eax),%ecx
  800a2b:	0f b6 1a             	movzbl (%edx),%ebx
  800a2e:	38 d9                	cmp    %bl,%cl
  800a30:	75 08                	jne    800a3a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	83 c2 01             	add    $0x1,%edx
  800a38:	eb ea                	jmp    800a24 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a3a:	0f b6 c1             	movzbl %cl,%eax
  800a3d:	0f b6 db             	movzbl %bl,%ebx
  800a40:	29 d8                	sub    %ebx,%eax
  800a42:	eb 05                	jmp    800a49 <memcmp+0x35>
	}

	return 0;
  800a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5e                   	pop    %esi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a56:	89 c2                	mov    %eax,%edx
  800a58:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5b:	39 d0                	cmp    %edx,%eax
  800a5d:	73 09                	jae    800a68 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5f:	38 08                	cmp    %cl,(%eax)
  800a61:	74 05                	je     800a68 <memfind+0x1b>
	for (; s < ends; s++)
  800a63:	83 c0 01             	add    $0x1,%eax
  800a66:	eb f3                	jmp    800a5b <memfind+0xe>
			break;
	return (void *) s;
}
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	57                   	push   %edi
  800a6e:	56                   	push   %esi
  800a6f:	53                   	push   %ebx
  800a70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a76:	eb 03                	jmp    800a7b <strtol+0x11>
		s++;
  800a78:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7b:	0f b6 01             	movzbl (%ecx),%eax
  800a7e:	3c 20                	cmp    $0x20,%al
  800a80:	74 f6                	je     800a78 <strtol+0xe>
  800a82:	3c 09                	cmp    $0x9,%al
  800a84:	74 f2                	je     800a78 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a86:	3c 2b                	cmp    $0x2b,%al
  800a88:	74 2e                	je     800ab8 <strtol+0x4e>
	int neg = 0;
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a8f:	3c 2d                	cmp    $0x2d,%al
  800a91:	74 2f                	je     800ac2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a93:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a99:	75 05                	jne    800aa0 <strtol+0x36>
  800a9b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9e:	74 2c                	je     800acc <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa0:	85 db                	test   %ebx,%ebx
  800aa2:	75 0a                	jne    800aae <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aa9:	80 39 30             	cmpb   $0x30,(%ecx)
  800aac:	74 28                	je     800ad6 <strtol+0x6c>
		base = 10;
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab6:	eb 50                	jmp    800b08 <strtol+0x9e>
		s++;
  800ab8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac0:	eb d1                	jmp    800a93 <strtol+0x29>
		s++, neg = 1;
  800ac2:	83 c1 01             	add    $0x1,%ecx
  800ac5:	bf 01 00 00 00       	mov    $0x1,%edi
  800aca:	eb c7                	jmp    800a93 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad0:	74 0e                	je     800ae0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad2:	85 db                	test   %ebx,%ebx
  800ad4:	75 d8                	jne    800aae <strtol+0x44>
		s++, base = 8;
  800ad6:	83 c1 01             	add    $0x1,%ecx
  800ad9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ade:	eb ce                	jmp    800aae <strtol+0x44>
		s += 2, base = 16;
  800ae0:	83 c1 02             	add    $0x2,%ecx
  800ae3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae8:	eb c4                	jmp    800aae <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aea:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aed:	89 f3                	mov    %esi,%ebx
  800aef:	80 fb 19             	cmp    $0x19,%bl
  800af2:	77 29                	ja     800b1d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af4:	0f be d2             	movsbl %dl,%edx
  800af7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800afa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800afd:	7d 30                	jge    800b2f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aff:	83 c1 01             	add    $0x1,%ecx
  800b02:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b06:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b08:	0f b6 11             	movzbl (%ecx),%edx
  800b0b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b0e:	89 f3                	mov    %esi,%ebx
  800b10:	80 fb 09             	cmp    $0x9,%bl
  800b13:	77 d5                	ja     800aea <strtol+0x80>
			dig = *s - '0';
  800b15:	0f be d2             	movsbl %dl,%edx
  800b18:	83 ea 30             	sub    $0x30,%edx
  800b1b:	eb dd                	jmp    800afa <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b1d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b20:	89 f3                	mov    %esi,%ebx
  800b22:	80 fb 19             	cmp    $0x19,%bl
  800b25:	77 08                	ja     800b2f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b27:	0f be d2             	movsbl %dl,%edx
  800b2a:	83 ea 37             	sub    $0x37,%edx
  800b2d:	eb cb                	jmp    800afa <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b33:	74 05                	je     800b3a <strtol+0xd0>
		*endptr = (char *) s;
  800b35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b38:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3a:	89 c2                	mov    %eax,%edx
  800b3c:	f7 da                	neg    %edx
  800b3e:	85 ff                	test   %edi,%edi
  800b40:	0f 45 c2             	cmovne %edx,%eax
}
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	89 c3                	mov    %eax,%ebx
  800b5b:	89 c7                	mov    %eax,%edi
  800b5d:	89 c6                	mov    %eax,%esi
  800b5f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_cgetc>:

int
sys_cgetc(void) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b71:	b8 01 00 00 00       	mov    $0x1,%eax
  800b76:	89 d1                	mov    %edx,%ecx
  800b78:	89 d3                	mov    %edx,%ebx
  800b7a:	89 d7                	mov    %edx,%edi
  800b7c:	89 d6                	mov    %edx,%esi
  800b7e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5f                   	pop    %edi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	57                   	push   %edi
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
  800b8b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800b8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b93:	8b 55 08             	mov    0x8(%ebp),%edx
  800b96:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9b:	89 cb                	mov    %ecx,%ebx
  800b9d:	89 cf                	mov    %ecx,%edi
  800b9f:	89 ce                	mov    %ecx,%esi
  800ba1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ba3:	85 c0                	test   %eax,%eax
  800ba5:	7f 08                	jg     800baf <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800baf:	83 ec 0c             	sub    $0xc,%esp
  800bb2:	50                   	push   %eax
  800bb3:	6a 03                	push   $0x3
  800bb5:	68 64 16 80 00       	push   $0x801664
  800bba:	6a 24                	push   $0x24
  800bbc:	68 81 16 80 00       	push   $0x801681
  800bc1:	e8 fe 04 00 00       	call   8010c4 <_panic>

00800bc6 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd6:	89 d1                	mov    %edx,%ecx
  800bd8:	89 d3                	mov    %edx,%ebx
  800bda:	89 d7                	mov    %edx,%edi
  800bdc:	89 d6                	mov    %edx,%esi
  800bde:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <sys_yield>:

void
sys_yield(void)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
    asm volatile("int %1\n"
  800beb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf5:	89 d1                	mov    %edx,%ecx
  800bf7:	89 d3                	mov    %edx,%ebx
  800bf9:	89 d7                	mov    %edx,%edi
  800bfb:	89 d6                	mov    %edx,%esi
  800bfd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
  800c0a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c0d:	be 00 00 00 00       	mov    $0x0,%esi
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	b8 04 00 00 00       	mov    $0x4,%eax
  800c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c20:	89 f7                	mov    %esi,%edi
  800c22:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c24:	85 c0                	test   %eax,%eax
  800c26:	7f 08                	jg     800c30 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c30:	83 ec 0c             	sub    $0xc,%esp
  800c33:	50                   	push   %eax
  800c34:	6a 04                	push   $0x4
  800c36:	68 64 16 80 00       	push   $0x801664
  800c3b:	6a 24                	push   $0x24
  800c3d:	68 81 16 80 00       	push   $0x801681
  800c42:	e8 7d 04 00 00       	call   8010c4 <_panic>

00800c47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c50:	8b 55 08             	mov    0x8(%ebp),%edx
  800c53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c56:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c61:	8b 75 18             	mov    0x18(%ebp),%esi
  800c64:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c66:	85 c0                	test   %eax,%eax
  800c68:	7f 08                	jg     800c72 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c72:	83 ec 0c             	sub    $0xc,%esp
  800c75:	50                   	push   %eax
  800c76:	6a 05                	push   $0x5
  800c78:	68 64 16 80 00       	push   $0x801664
  800c7d:	6a 24                	push   $0x24
  800c7f:	68 81 16 80 00       	push   $0x801681
  800c84:	e8 3b 04 00 00       	call   8010c4 <_panic>

00800c89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c97:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9d:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca2:	89 df                	mov    %ebx,%edi
  800ca4:	89 de                	mov    %ebx,%esi
  800ca6:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	7f 08                	jg     800cb4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cb4:	83 ec 0c             	sub    $0xc,%esp
  800cb7:	50                   	push   %eax
  800cb8:	6a 06                	push   $0x6
  800cba:	68 64 16 80 00       	push   $0x801664
  800cbf:	6a 24                	push   $0x24
  800cc1:	68 81 16 80 00       	push   $0x801681
  800cc6:	e8 f9 03 00 00       	call   8010c4 <_panic>

00800ccb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce4:	89 df                	mov    %ebx,%edi
  800ce6:	89 de                	mov    %ebx,%esi
  800ce8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cea:	85 c0                	test   %eax,%eax
  800cec:	7f 08                	jg     800cf6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cf6:	83 ec 0c             	sub    $0xc,%esp
  800cf9:	50                   	push   %eax
  800cfa:	6a 08                	push   $0x8
  800cfc:	68 64 16 80 00       	push   $0x801664
  800d01:	6a 24                	push   $0x24
  800d03:	68 81 16 80 00       	push   $0x801681
  800d08:	e8 b7 03 00 00       	call   8010c4 <_panic>

00800d0d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d21:	b8 09 00 00 00       	mov    $0x9,%eax
  800d26:	89 df                	mov    %ebx,%edi
  800d28:	89 de                	mov    %ebx,%esi
  800d2a:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7f 08                	jg     800d38 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d38:	83 ec 0c             	sub    $0xc,%esp
  800d3b:	50                   	push   %eax
  800d3c:	6a 09                	push   $0x9
  800d3e:	68 64 16 80 00       	push   $0x801664
  800d43:	6a 24                	push   $0x24
  800d45:	68 81 16 80 00       	push   $0x801681
  800d4a:	e8 75 03 00 00       	call   8010c4 <_panic>

00800d4f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d60:	be 00 00 00 00       	mov    $0x0,%esi
  800d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d68:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d88:	89 cb                	mov    %ecx,%ebx
  800d8a:	89 cf                	mov    %ecx,%edi
  800d8c:	89 ce                	mov    %ecx,%esi
  800d8e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 0c                	push   $0xc
  800da2:	68 64 16 80 00       	push   $0x801664
  800da7:	6a 24                	push   $0x24
  800da9:	68 81 16 80 00       	push   $0x801681
  800dae:	e8 11 03 00 00       	call   8010c4 <_panic>

00800db3 <pgfault>:
//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf) {
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	53                   	push   %ebx
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
//    cprintf("in pgfault,,, utf->utf_fault_va:0x%x\n", *((uintptr_t *)(utf)));

    void *addr = (void *) (utf->utf_fault_va);
  800dbd:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800dbf:	8b 40 04             	mov    0x4(%eax),%eax
    int r;

//    cprintf("addr:0x%x\terr:%d\n", addr, err);

    extern volatile pte_t uvpt[];
    if ((err & FEC_WR) != FEC_WR || ((uvpt[(uintptr_t) addr / PGSIZE] & PTE_COW) != PTE_COW)) {
  800dc2:	a8 02                	test   $0x2,%al
  800dc4:	74 68                	je     800e2e <pgfault+0x7b>
  800dc6:	89 da                	mov    %ebx,%edx
  800dc8:	c1 ea 0c             	shr    $0xc,%edx
  800dcb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dd2:	f6 c6 08             	test   $0x8,%dh
  800dd5:	74 57                	je     800e2e <pgfault+0x7b>
    // Hint:
    //   Use the read-only page table mappings at uvpt
    //   (see <inc/memlayout.h>).

    // LAB 4: Your code here.
    sys_page_alloc(0, (void *) PFTEMP, PTE_W | PTE_U | PTE_P);
  800dd7:	83 ec 04             	sub    $0x4,%esp
  800dda:	6a 07                	push   $0x7
  800ddc:	68 00 f0 7f 00       	push   $0x7ff000
  800de1:	6a 00                	push   $0x0
  800de3:	e8 1c fe ff ff       	call   800c04 <sys_page_alloc>
    memmove((void *) PFTEMP, (void *) (ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  800de8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800dee:	83 c4 0c             	add    $0xc,%esp
  800df1:	68 00 10 00 00       	push   $0x1000
  800df6:	53                   	push   %ebx
  800df7:	68 00 f0 7f 00       	push   $0x7ff000
  800dfc:	e8 98 fb ff ff       	call   800999 <memmove>

    //restore another
//    sys_page_map(0, (void *) (ROUNDDOWN(addr, PGSIZE)), 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);

    sys_page_map(0, (void *) PFTEMP, 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800e01:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e08:	53                   	push   %ebx
  800e09:	6a 00                	push   $0x0
  800e0b:	68 00 f0 7f 00       	push   $0x7ff000
  800e10:	6a 00                	push   $0x0
  800e12:	e8 30 fe ff ff       	call   800c47 <sys_page_map>
    sys_page_unmap(0, (void *) PFTEMP);
  800e17:	83 c4 18             	add    $0x18,%esp
  800e1a:	68 00 f0 7f 00       	push   $0x7ff000
  800e1f:	6a 00                	push   $0x0
  800e21:	e8 63 fe ff ff       	call   800c89 <sys_page_unmap>

    return;
  800e26:	83 c4 10             	add    $0x10,%esp
    //   You should make three system calls.

    // LAB 4: Your code here.

    panic("pgfault not implemented");
}
  800e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    
        cprintf("utf->utf_fault_va:0x%x\tutf->utf_err:%d\n", addr, err);
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	50                   	push   %eax
  800e32:	53                   	push   %ebx
  800e33:	68 90 16 80 00       	push   $0x801690
  800e38:	e8 70 f3 ff ff       	call   8001ad <cprintf>
        panic("pgfault is not a FEC_WR or is not to a COW page");
  800e3d:	83 c4 0c             	add    $0xc,%esp
  800e40:	68 b8 16 80 00       	push   $0x8016b8
  800e45:	6a 1b                	push   $0x1b
  800e47:	68 e8 16 80 00       	push   $0x8016e8
  800e4c:	e8 73 02 00 00       	call   8010c4 <_panic>

00800e51 <fork>:
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void) {
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
  800e57:	83 ec 28             	sub    $0x28,%esp
    extern void* _pgfault_upcall(void);
    //1. The parent installs pgfault() as the C-level page fault handler, using the set_pgfault_handler() function you implemented above.
    set_pgfault_handler(pgfault);
  800e5a:	68 b3 0d 80 00       	push   $0x800db3
  800e5f:	e8 a6 02 00 00       	call   80110a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e64:	b8 07 00 00 00       	mov    $0x7,%eax
  800e69:	cd 30                	int    $0x30
  800e6b:	89 c6                	mov    %eax,%esi
  800e6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    //2. The parent calls sys_exofork() to create a child environment.
    envid_t envid = sys_exofork();

//    cprintf("envid:0x%x\n", envid);
    if (envid == 0) {
  800e70:	83 c4 10             	add    $0x10,%esp
  800e73:	85 c0                	test   %eax,%eax
  800e75:	74 5e                	je     800ed5 <fork+0x84>

    extern volatile pde_t uvpd[];
    extern volatile pte_t uvpt[];

    //allocate and copy a normal stack
    sys_page_alloc(envid, (void *) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	6a 07                	push   $0x7
  800e7c:	68 00 d0 bf ee       	push   $0xeebfd000
  800e81:	50                   	push   %eax
  800e82:	e8 7d fd ff ff       	call   800c04 <sys_page_alloc>
    sys_page_map(envid, (void *) (USTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  800e87:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e8e:	68 00 00 40 00       	push   $0x400000
  800e93:	6a 00                	push   $0x0
  800e95:	68 00 d0 bf ee       	push   $0xeebfd000
  800e9a:	56                   	push   %esi
  800e9b:	e8 a7 fd ff ff       	call   800c47 <sys_page_map>
    memmove(UTEMP, (void *) (USTACKTOP - PGSIZE), PGSIZE);
  800ea0:	83 c4 1c             	add    $0x1c,%esp
  800ea3:	68 00 10 00 00       	push   $0x1000
  800ea8:	68 00 d0 bf ee       	push   $0xeebfd000
  800ead:	68 00 00 40 00       	push   $0x400000
  800eb2:	e8 e2 fa ff ff       	call   800999 <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  800eb7:	83 c4 08             	add    $0x8,%esp
  800eba:	68 00 00 40 00       	push   $0x400000
  800ebf:	6a 00                	push   $0x0
  800ec1:	e8 c3 fd ff ff       	call   800c89 <sys_page_unmap>
  800ec6:	83 c4 10             	add    $0x10,%esp

    int i;

//    cprintf("COW page resolve ....\n");
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
  800ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ece:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed3:	eb 2e                	jmp    800f03 <fork+0xb2>
        thisenv = &envs[sys_getenvid()];
  800ed5:	e8 ec fc ff ff       	call   800bc6 <sys_getenvid>
  800eda:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800edd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ee2:	a3 04 20 80 00       	mov    %eax,0x802004
        return 0;
  800ee7:	e9 4d 01 00 00       	jmp    801039 <fork+0x1e8>
        if (uvpd[i / NPTENTRIES] == 0) {
            i += 1023;
  800eec:	81 c3 ff 03 00 00    	add    $0x3ff,%ebx
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
  800ef2:	83 c3 01             	add    $0x1,%ebx
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	81 fb fc eb 0e 00    	cmp    $0xeebfc,%ebx
  800efd:	0f 87 cb 00 00 00    	ja     800fce <fork+0x17d>
        if (uvpd[i / NPTENTRIES] == 0) {
  800f03:	8d 83 ff 03 00 00    	lea    0x3ff(%ebx),%eax
  800f09:	85 db                	test   %ebx,%ebx
  800f0b:	0f 49 c3             	cmovns %ebx,%eax
  800f0e:	c1 f8 0a             	sar    $0xa,%eax
  800f11:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	74 d0                	je     800eec <fork+0x9b>
            continue;
        }

        if ((uvpt[i] & PTE_P) == PTE_P) {
  800f1c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f23:	a8 01                	test   $0x1,%al
  800f25:	74 cb                	je     800ef2 <fork+0xa1>
            if (((uvpt[i] & PTE_W) == PTE_W) || ((uvpt[i] & PTE_COW) == PTE_COW)) {
  800f27:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f2e:	a8 02                	test   $0x2,%al
  800f30:	75 0c                	jne    800f3e <fork+0xed>
  800f32:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f39:	f6 c4 08             	test   $0x8,%ah
  800f3c:	74 64                	je     800fa2 <fork+0x151>
    if (sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800f3e:	c1 e7 0c             	shl    $0xc,%edi
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 05 08 00 00       	push   $0x805
  800f49:	57                   	push   %edi
  800f4a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f4d:	57                   	push   %edi
  800f4e:	6a 00                	push   $0x0
  800f50:	e8 f2 fc ff ff       	call   800c47 <sys_page_map>
  800f55:	83 c4 20             	add    $0x20,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 32                	js     800f8e <fork+0x13d>
    if (sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	68 05 08 00 00       	push   $0x805
  800f64:	57                   	push   %edi
  800f65:	6a 00                	push   $0x0
  800f67:	57                   	push   %edi
  800f68:	6a 00                	push   $0x0
  800f6a:	e8 d8 fc ff ff       	call   800c47 <sys_page_map>
  800f6f:	83 c4 20             	add    $0x20,%esp
  800f72:	85 c0                	test   %eax,%eax
  800f74:	0f 89 78 ff ff ff    	jns    800ef2 <fork+0xa1>
        panic("dupppage target map error");
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	68 0e 17 80 00       	push   $0x80170e
  800f82:	6a 55                	push   $0x55
  800f84:	68 e8 16 80 00       	push   $0x8016e8
  800f89:	e8 36 01 00 00       	call   8010c4 <_panic>
        panic("dupppage our own map error");
  800f8e:	83 ec 04             	sub    $0x4,%esp
  800f91:	68 f3 16 80 00       	push   $0x8016f3
  800f96:	6a 4b                	push   $0x4b
  800f98:	68 e8 16 80 00       	push   $0x8016e8
  800f9d:	e8 22 01 00 00       	call   8010c4 <_panic>
                duppage(envid, i);
            } else {
                sys_page_map(0, (void *) (i * PGSIZE), envid, (void *) (i * PGSIZE), PTE_SHARE | (uvpt[i] & 0x3ff));
  800fa2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fa9:	89 da                	mov    %ebx,%edx
  800fab:	c1 e2 0c             	shl    $0xc,%edx
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fb6:	80 cc 04             	or     $0x4,%ah
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbe:	52                   	push   %edx
  800fbf:	6a 00                	push   $0x0
  800fc1:	e8 81 fc ff ff       	call   800c47 <sys_page_map>
  800fc6:	83 c4 20             	add    $0x20,%esp
  800fc9:	e9 24 ff ff ff       	jmp    800ef2 <fork+0xa1>
            }
        }
    }

//    cprintf("allocate child ExceptionStack ....\n");
    sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	6a 07                	push   $0x7
  800fd3:	68 00 f0 bf ee       	push   $0xeebff000
  800fd8:	56                   	push   %esi
  800fd9:	e8 26 fc ff ff       	call   800c04 <sys_page_alloc>
    sys_page_map(envid, (void *) (UXSTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  800fde:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fe5:	68 00 00 40 00       	push   $0x400000
  800fea:	6a 00                	push   $0x0
  800fec:	68 00 f0 bf ee       	push   $0xeebff000
  800ff1:	56                   	push   %esi
  800ff2:	e8 50 fc ff ff       	call   800c47 <sys_page_map>
    memmove(UTEMP, (void *) (UXSTACKTOP - PGSIZE), PGSIZE);
  800ff7:	83 c4 1c             	add    $0x1c,%esp
  800ffa:	68 00 10 00 00       	push   $0x1000
  800fff:	68 00 f0 bf ee       	push   $0xeebff000
  801004:	68 00 00 40 00       	push   $0x400000
  801009:	e8 8b f9 ff ff       	call   800999 <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  80100e:	83 c4 08             	add    $0x8,%esp
  801011:	68 00 00 40 00       	push   $0x400000
  801016:	6a 00                	push   $0x0
  801018:	e8 6c fc ff ff       	call   800c89 <sys_page_unmap>

    //4. The parent sets the user page fault entrypoint for the child to look like its own.
//    set_pgfault_handler(pgfault);
//    cprintf("sys_env_set_pgfault_upcall(envid, pgfault) ....\n");
//    sys_env_set_pgfault_upcall(envid, pgfault);
    sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80101d:	83 c4 08             	add    $0x8,%esp
  801020:	68 60 11 80 00       	push   $0x801160
  801025:	56                   	push   %esi
  801026:	e8 e2 fc ff ff       	call   800d0d <sys_env_set_pgfault_upcall>

    //5. The child is now ready to run, so the parent marks it runnable.
//    cprintf("sys_env_set_status(envid, ENV_RUNNABLE) ....\n");
    sys_env_set_status(envid, ENV_RUNNABLE);
  80102b:	83 c4 08             	add    $0x8,%esp
  80102e:	6a 02                	push   $0x2
  801030:	56                   	push   %esi
  801031:	e8 95 fc ff ff       	call   800ccb <sys_env_set_status>


    return envid;
  801036:	83 c4 10             	add    $0x10,%esp
    panic("fork not implemented");
}
  801039:	89 f0                	mov    %esi,%eax
  80103b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <sfork>:

// Challenge!
int
sfork(void) {
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 0c             	sub    $0xc,%esp
    panic("sfork not implemented");
  801049:	68 28 17 80 00       	push   $0x801728
  80104e:	68 bf 00 00 00       	push   $0xbf
  801053:	68 e8 16 80 00       	push   $0x8016e8
  801058:	e8 67 00 00 00       	call   8010c4 <_panic>

0080105d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801063:	68 3e 17 80 00       	push   $0x80173e
  801068:	6a 1a                	push   $0x1a
  80106a:	68 57 17 80 00       	push   $0x801757
  80106f:	e8 50 00 00 00       	call   8010c4 <_panic>

00801074 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80107a:	68 61 17 80 00       	push   $0x801761
  80107f:	6a 2a                	push   $0x2a
  801081:	68 57 17 80 00       	push   $0x801757
  801086:	e8 39 00 00 00       	call   8010c4 <_panic>

0080108b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801096:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801099:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80109f:	8b 52 50             	mov    0x50(%edx),%edx
  8010a2:	39 ca                	cmp    %ecx,%edx
  8010a4:	74 11                	je     8010b7 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8010a6:	83 c0 01             	add    $0x1,%eax
  8010a9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010ae:	75 e6                	jne    801096 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8010b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b5:	eb 0b                	jmp    8010c2 <ipc_find_env+0x37>
			return envs[i].env_id;
  8010b7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010bf:	8b 40 48             	mov    0x48(%eax),%eax
}
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	56                   	push   %esi
  8010c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010cc:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8010d2:	e8 ef fa ff ff       	call   800bc6 <sys_getenvid>
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	ff 75 08             	pushl  0x8(%ebp)
  8010e0:	56                   	push   %esi
  8010e1:	50                   	push   %eax
  8010e2:	68 7c 17 80 00       	push   $0x80177c
  8010e7:	e8 c1 f0 ff ff       	call   8001ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010ec:	83 c4 18             	add    $0x18,%esp
  8010ef:	53                   	push   %ebx
  8010f0:	ff 75 10             	pushl  0x10(%ebp)
  8010f3:	e8 64 f0 ff ff       	call   80015c <vcprintf>
	cprintf("\n");
  8010f8:	c7 04 24 07 14 80 00 	movl   $0x801407,(%esp)
  8010ff:	e8 a9 f0 ff ff       	call   8001ad <cprintf>
  801104:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801107:	cc                   	int3   
  801108:	eb fd                	jmp    801107 <_panic+0x43>

0080110a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801110:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801117:	74 0a                	je     801123 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  801123:	a1 04 20 80 00       	mov    0x802004,%eax
  801128:	8b 40 48             	mov    0x48(%eax),%eax
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	6a 07                	push   $0x7
  801130:	68 00 f0 bf ee       	push   $0xeebff000
  801135:	25 ff 03 00 00       	and    $0x3ff,%eax
  80113a:	50                   	push   %eax
  80113b:	e8 c4 fa ff ff       	call   800c04 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  801140:	a1 04 20 80 00       	mov    0x802004,%eax
  801145:	8b 40 48             	mov    0x48(%eax),%eax
  801148:	83 c4 08             	add    $0x8,%esp
  80114b:	68 60 11 80 00       	push   $0x801160
  801150:	25 ff 03 00 00       	and    $0x3ff,%eax
  801155:	50                   	push   %eax
  801156:	e8 b2 fb ff ff       	call   800d0d <sys_env_set_pgfault_upcall>
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	eb b9                	jmp    801119 <set_pgfault_handler+0xf>

00801160 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801160:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801161:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801166:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801168:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  80116b:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  80116f:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  801173:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  801176:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  801178:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  80117c:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  80117f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  801180:	83 c4 04             	add    $0x4,%esp
    popfl
  801183:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  801184:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801185:	c3                   	ret    
  801186:	66 90                	xchg   %ax,%ax
  801188:	66 90                	xchg   %ax,%ax
  80118a:	66 90                	xchg   %ax,%ax
  80118c:	66 90                	xchg   %ax,%ax
  80118e:	66 90                	xchg   %ax,%ax

00801190 <__udivdi3>:
  801190:	55                   	push   %ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 1c             	sub    $0x1c,%esp
  801197:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80119b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80119f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8011a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8011a7:	85 d2                	test   %edx,%edx
  8011a9:	75 35                	jne    8011e0 <__udivdi3+0x50>
  8011ab:	39 f3                	cmp    %esi,%ebx
  8011ad:	0f 87 bd 00 00 00    	ja     801270 <__udivdi3+0xe0>
  8011b3:	85 db                	test   %ebx,%ebx
  8011b5:	89 d9                	mov    %ebx,%ecx
  8011b7:	75 0b                	jne    8011c4 <__udivdi3+0x34>
  8011b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011be:	31 d2                	xor    %edx,%edx
  8011c0:	f7 f3                	div    %ebx
  8011c2:	89 c1                	mov    %eax,%ecx
  8011c4:	31 d2                	xor    %edx,%edx
  8011c6:	89 f0                	mov    %esi,%eax
  8011c8:	f7 f1                	div    %ecx
  8011ca:	89 c6                	mov    %eax,%esi
  8011cc:	89 e8                	mov    %ebp,%eax
  8011ce:	89 f7                	mov    %esi,%edi
  8011d0:	f7 f1                	div    %ecx
  8011d2:	89 fa                	mov    %edi,%edx
  8011d4:	83 c4 1c             	add    $0x1c,%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
  8011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011e0:	39 f2                	cmp    %esi,%edx
  8011e2:	77 7c                	ja     801260 <__udivdi3+0xd0>
  8011e4:	0f bd fa             	bsr    %edx,%edi
  8011e7:	83 f7 1f             	xor    $0x1f,%edi
  8011ea:	0f 84 98 00 00 00    	je     801288 <__udivdi3+0xf8>
  8011f0:	89 f9                	mov    %edi,%ecx
  8011f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8011f7:	29 f8                	sub    %edi,%eax
  8011f9:	d3 e2                	shl    %cl,%edx
  8011fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8011ff:	89 c1                	mov    %eax,%ecx
  801201:	89 da                	mov    %ebx,%edx
  801203:	d3 ea                	shr    %cl,%edx
  801205:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801209:	09 d1                	or     %edx,%ecx
  80120b:	89 f2                	mov    %esi,%edx
  80120d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801211:	89 f9                	mov    %edi,%ecx
  801213:	d3 e3                	shl    %cl,%ebx
  801215:	89 c1                	mov    %eax,%ecx
  801217:	d3 ea                	shr    %cl,%edx
  801219:	89 f9                	mov    %edi,%ecx
  80121b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80121f:	d3 e6                	shl    %cl,%esi
  801221:	89 eb                	mov    %ebp,%ebx
  801223:	89 c1                	mov    %eax,%ecx
  801225:	d3 eb                	shr    %cl,%ebx
  801227:	09 de                	or     %ebx,%esi
  801229:	89 f0                	mov    %esi,%eax
  80122b:	f7 74 24 08          	divl   0x8(%esp)
  80122f:	89 d6                	mov    %edx,%esi
  801231:	89 c3                	mov    %eax,%ebx
  801233:	f7 64 24 0c          	mull   0xc(%esp)
  801237:	39 d6                	cmp    %edx,%esi
  801239:	72 0c                	jb     801247 <__udivdi3+0xb7>
  80123b:	89 f9                	mov    %edi,%ecx
  80123d:	d3 e5                	shl    %cl,%ebp
  80123f:	39 c5                	cmp    %eax,%ebp
  801241:	73 5d                	jae    8012a0 <__udivdi3+0x110>
  801243:	39 d6                	cmp    %edx,%esi
  801245:	75 59                	jne    8012a0 <__udivdi3+0x110>
  801247:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80124a:	31 ff                	xor    %edi,%edi
  80124c:	89 fa                	mov    %edi,%edx
  80124e:	83 c4 1c             	add    $0x1c,%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    
  801256:	8d 76 00             	lea    0x0(%esi),%esi
  801259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801260:	31 ff                	xor    %edi,%edi
  801262:	31 c0                	xor    %eax,%eax
  801264:	89 fa                	mov    %edi,%edx
  801266:	83 c4 1c             	add    $0x1c,%esp
  801269:	5b                   	pop    %ebx
  80126a:	5e                   	pop    %esi
  80126b:	5f                   	pop    %edi
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    
  80126e:	66 90                	xchg   %ax,%ax
  801270:	31 ff                	xor    %edi,%edi
  801272:	89 e8                	mov    %ebp,%eax
  801274:	89 f2                	mov    %esi,%edx
  801276:	f7 f3                	div    %ebx
  801278:	89 fa                	mov    %edi,%edx
  80127a:	83 c4 1c             	add    $0x1c,%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
  801282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801288:	39 f2                	cmp    %esi,%edx
  80128a:	72 06                	jb     801292 <__udivdi3+0x102>
  80128c:	31 c0                	xor    %eax,%eax
  80128e:	39 eb                	cmp    %ebp,%ebx
  801290:	77 d2                	ja     801264 <__udivdi3+0xd4>
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
  801297:	eb cb                	jmp    801264 <__udivdi3+0xd4>
  801299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012a0:	89 d8                	mov    %ebx,%eax
  8012a2:	31 ff                	xor    %edi,%edi
  8012a4:	eb be                	jmp    801264 <__udivdi3+0xd4>
  8012a6:	66 90                	xchg   %ax,%ax
  8012a8:	66 90                	xchg   %ax,%ax
  8012aa:	66 90                	xchg   %ax,%ax
  8012ac:	66 90                	xchg   %ax,%ax
  8012ae:	66 90                	xchg   %ax,%ax

008012b0 <__umoddi3>:
  8012b0:	55                   	push   %ebp
  8012b1:	57                   	push   %edi
  8012b2:	56                   	push   %esi
  8012b3:	53                   	push   %ebx
  8012b4:	83 ec 1c             	sub    $0x1c,%esp
  8012b7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8012bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8012c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8012c7:	85 ed                	test   %ebp,%ebp
  8012c9:	89 f0                	mov    %esi,%eax
  8012cb:	89 da                	mov    %ebx,%edx
  8012cd:	75 19                	jne    8012e8 <__umoddi3+0x38>
  8012cf:	39 df                	cmp    %ebx,%edi
  8012d1:	0f 86 b1 00 00 00    	jbe    801388 <__umoddi3+0xd8>
  8012d7:	f7 f7                	div    %edi
  8012d9:	89 d0                	mov    %edx,%eax
  8012db:	31 d2                	xor    %edx,%edx
  8012dd:	83 c4 1c             	add    $0x1c,%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5f                   	pop    %edi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    
  8012e5:	8d 76 00             	lea    0x0(%esi),%esi
  8012e8:	39 dd                	cmp    %ebx,%ebp
  8012ea:	77 f1                	ja     8012dd <__umoddi3+0x2d>
  8012ec:	0f bd cd             	bsr    %ebp,%ecx
  8012ef:	83 f1 1f             	xor    $0x1f,%ecx
  8012f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012f6:	0f 84 b4 00 00 00    	je     8013b0 <__umoddi3+0x100>
  8012fc:	b8 20 00 00 00       	mov    $0x20,%eax
  801301:	89 c2                	mov    %eax,%edx
  801303:	8b 44 24 04          	mov    0x4(%esp),%eax
  801307:	29 c2                	sub    %eax,%edx
  801309:	89 c1                	mov    %eax,%ecx
  80130b:	89 f8                	mov    %edi,%eax
  80130d:	d3 e5                	shl    %cl,%ebp
  80130f:	89 d1                	mov    %edx,%ecx
  801311:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801315:	d3 e8                	shr    %cl,%eax
  801317:	09 c5                	or     %eax,%ebp
  801319:	8b 44 24 04          	mov    0x4(%esp),%eax
  80131d:	89 c1                	mov    %eax,%ecx
  80131f:	d3 e7                	shl    %cl,%edi
  801321:	89 d1                	mov    %edx,%ecx
  801323:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801327:	89 df                	mov    %ebx,%edi
  801329:	d3 ef                	shr    %cl,%edi
  80132b:	89 c1                	mov    %eax,%ecx
  80132d:	89 f0                	mov    %esi,%eax
  80132f:	d3 e3                	shl    %cl,%ebx
  801331:	89 d1                	mov    %edx,%ecx
  801333:	89 fa                	mov    %edi,%edx
  801335:	d3 e8                	shr    %cl,%eax
  801337:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80133c:	09 d8                	or     %ebx,%eax
  80133e:	f7 f5                	div    %ebp
  801340:	d3 e6                	shl    %cl,%esi
  801342:	89 d1                	mov    %edx,%ecx
  801344:	f7 64 24 08          	mull   0x8(%esp)
  801348:	39 d1                	cmp    %edx,%ecx
  80134a:	89 c3                	mov    %eax,%ebx
  80134c:	89 d7                	mov    %edx,%edi
  80134e:	72 06                	jb     801356 <__umoddi3+0xa6>
  801350:	75 0e                	jne    801360 <__umoddi3+0xb0>
  801352:	39 c6                	cmp    %eax,%esi
  801354:	73 0a                	jae    801360 <__umoddi3+0xb0>
  801356:	2b 44 24 08          	sub    0x8(%esp),%eax
  80135a:	19 ea                	sbb    %ebp,%edx
  80135c:	89 d7                	mov    %edx,%edi
  80135e:	89 c3                	mov    %eax,%ebx
  801360:	89 ca                	mov    %ecx,%edx
  801362:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801367:	29 de                	sub    %ebx,%esi
  801369:	19 fa                	sbb    %edi,%edx
  80136b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80136f:	89 d0                	mov    %edx,%eax
  801371:	d3 e0                	shl    %cl,%eax
  801373:	89 d9                	mov    %ebx,%ecx
  801375:	d3 ee                	shr    %cl,%esi
  801377:	d3 ea                	shr    %cl,%edx
  801379:	09 f0                	or     %esi,%eax
  80137b:	83 c4 1c             	add    $0x1c,%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5f                   	pop    %edi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    
  801383:	90                   	nop
  801384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801388:	85 ff                	test   %edi,%edi
  80138a:	89 f9                	mov    %edi,%ecx
  80138c:	75 0b                	jne    801399 <__umoddi3+0xe9>
  80138e:	b8 01 00 00 00       	mov    $0x1,%eax
  801393:	31 d2                	xor    %edx,%edx
  801395:	f7 f7                	div    %edi
  801397:	89 c1                	mov    %eax,%ecx
  801399:	89 d8                	mov    %ebx,%eax
  80139b:	31 d2                	xor    %edx,%edx
  80139d:	f7 f1                	div    %ecx
  80139f:	89 f0                	mov    %esi,%eax
  8013a1:	f7 f1                	div    %ecx
  8013a3:	e9 31 ff ff ff       	jmp    8012d9 <__umoddi3+0x29>
  8013a8:	90                   	nop
  8013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013b0:	39 dd                	cmp    %ebx,%ebp
  8013b2:	72 08                	jb     8013bc <__umoddi3+0x10c>
  8013b4:	39 f7                	cmp    %esi,%edi
  8013b6:	0f 87 21 ff ff ff    	ja     8012dd <__umoddi3+0x2d>
  8013bc:	89 da                	mov    %ebx,%edx
  8013be:	89 f0                	mov    %esi,%eax
  8013c0:	29 f8                	sub    %edi,%eax
  8013c2:	19 ea                	sbb    %ebp,%edx
  8013c4:	e9 14 ff ff ff       	jmp    8012dd <__umoddi3+0x2d>
