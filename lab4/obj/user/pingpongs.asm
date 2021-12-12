
obj/user/pingpongs：     文件格式 elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 bc 0d 00 00       	call   800dfd <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 bc 0d 00 00       	call   800e14 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 20 80 00       	mov    0x802004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 88 0b 00 00       	call   800bf9 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 50 11 80 00       	push   $0x801150
  800080:	e8 5b 01 00 00       	call   8001e0 <cprintf>
		if (val == 10)
  800085:	a1 04 20 80 00       	mov    0x802004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 83 0d 00 00       	call   800e2b <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c2:	e8 32 0b 00 00       	call   800bf9 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 20 11 80 00       	push   $0x801120
  8000d1:	e8 0a 01 00 00       	call   8001e0 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 1b 0b 00 00       	call   800bf9 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 3a 11 80 00       	push   $0x80113a
  8000e8:	e8 f3 00 00 00       	call   8001e0 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 30 0d 00 00       	call   800e2b <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	83 ec 08             	sub    $0x8,%esp
  800109:	8b 45 08             	mov    0x8(%ebp),%eax
  80010c:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80010f:	c7 05 08 20 80 00 00 	movl   $0xeec00000,0x802008
  800116:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	85 c0                	test   %eax,%eax
  80011b:	7e 08                	jle    800125 <libmain+0x22>
		binaryname = argv[0];
  80011d:	8b 0a                	mov    (%edx),%ecx
  80011f:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	52                   	push   %edx
  800129:	50                   	push   %eax
  80012a:	e8 04 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80012f:	e8 05 00 00 00       	call   800139 <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	c9                   	leave  
  800138:	c3                   	ret    

00800139 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80013f:	6a 00                	push   $0x0
  800141:	e8 72 0a 00 00       	call   800bb8 <sys_env_destroy>
}
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	53                   	push   %ebx
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800155:	8b 13                	mov    (%ebx),%edx
  800157:	8d 42 01             	lea    0x1(%edx),%eax
  80015a:	89 03                	mov    %eax,(%ebx)
  80015c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800163:	3d ff 00 00 00       	cmp    $0xff,%eax
  800168:	74 09                	je     800173 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80016a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800171:	c9                   	leave  
  800172:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	68 ff 00 00 00       	push   $0xff
  80017b:	8d 43 08             	lea    0x8(%ebx),%eax
  80017e:	50                   	push   %eax
  80017f:	e8 f7 09 00 00       	call   800b7b <sys_cputs>
		b->idx = 0;
  800184:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb db                	jmp    80016a <putch+0x1f>

0080018f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800198:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019f:	00 00 00 
	b.cnt = 0;
  8001a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ac:	ff 75 0c             	pushl  0xc(%ebp)
  8001af:	ff 75 08             	pushl  0x8(%ebp)
  8001b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b8:	50                   	push   %eax
  8001b9:	68 4b 01 80 00       	push   $0x80014b
  8001be:	e8 1a 01 00 00       	call   8002dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c3:	83 c4 08             	add    $0x8,%esp
  8001c6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d2:	50                   	push   %eax
  8001d3:	e8 a3 09 00 00       	call   800b7b <sys_cputs>

	return b.cnt;
}
  8001d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e9:	50                   	push   %eax
  8001ea:	ff 75 08             	pushl  0x8(%ebp)
  8001ed:	e8 9d ff ff ff       	call   80018f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	57                   	push   %edi
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
  8001fa:	83 ec 1c             	sub    $0x1c,%esp
  8001fd:	89 c7                	mov    %eax,%edi
  8001ff:	89 d6                	mov    %edx,%esi
  800201:	8b 45 08             	mov    0x8(%ebp),%eax
  800204:	8b 55 0c             	mov    0xc(%ebp),%edx
  800207:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80020a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80020d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800210:	bb 00 00 00 00       	mov    $0x0,%ebx
  800215:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800218:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80021b:	39 d3                	cmp    %edx,%ebx
  80021d:	72 05                	jb     800224 <printnum+0x30>
  80021f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800222:	77 7a                	ja     80029e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	ff 75 18             	pushl  0x18(%ebp)
  80022a:	8b 45 14             	mov    0x14(%ebp),%eax
  80022d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800230:	53                   	push   %ebx
  800231:	ff 75 10             	pushl  0x10(%ebp)
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	ff 75 e0             	pushl  -0x20(%ebp)
  80023d:	ff 75 dc             	pushl  -0x24(%ebp)
  800240:	ff 75 d8             	pushl  -0x28(%ebp)
  800243:	e8 88 0c 00 00       	call   800ed0 <__udivdi3>
  800248:	83 c4 18             	add    $0x18,%esp
  80024b:	52                   	push   %edx
  80024c:	50                   	push   %eax
  80024d:	89 f2                	mov    %esi,%edx
  80024f:	89 f8                	mov    %edi,%eax
  800251:	e8 9e ff ff ff       	call   8001f4 <printnum>
  800256:	83 c4 20             	add    $0x20,%esp
  800259:	eb 13                	jmp    80026e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	56                   	push   %esi
  80025f:	ff 75 18             	pushl  0x18(%ebp)
  800262:	ff d7                	call   *%edi
  800264:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800267:	83 eb 01             	sub    $0x1,%ebx
  80026a:	85 db                	test   %ebx,%ebx
  80026c:	7f ed                	jg     80025b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026e:	83 ec 08             	sub    $0x8,%esp
  800271:	56                   	push   %esi
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	ff 75 e4             	pushl  -0x1c(%ebp)
  800278:	ff 75 e0             	pushl  -0x20(%ebp)
  80027b:	ff 75 dc             	pushl  -0x24(%ebp)
  80027e:	ff 75 d8             	pushl  -0x28(%ebp)
  800281:	e8 6a 0d 00 00       	call   800ff0 <__umoddi3>
  800286:	83 c4 14             	add    $0x14,%esp
  800289:	0f be 80 80 11 80 00 	movsbl 0x801180(%eax),%eax
  800290:	50                   	push   %eax
  800291:	ff d7                	call   *%edi
}
  800293:	83 c4 10             	add    $0x10,%esp
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    
  80029e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002a1:	eb c4                	jmp    800267 <printnum+0x73>

008002a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ad:	8b 10                	mov    (%eax),%edx
  8002af:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b2:	73 0a                	jae    8002be <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b7:	89 08                	mov    %ecx,(%eax)
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	88 02                	mov    %al,(%edx)
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <printfmt>:
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 10             	pushl  0x10(%ebp)
  8002cd:	ff 75 0c             	pushl  0xc(%ebp)
  8002d0:	ff 75 08             	pushl  0x8(%ebp)
  8002d3:	e8 05 00 00 00       	call   8002dd <vprintfmt>
}
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vprintfmt>:
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 2c             	sub    $0x2c,%esp
  8002e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ef:	e9 00 04 00 00       	jmp    8006f4 <vprintfmt+0x417>
		padc = ' ';
  8002f4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002f8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002ff:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800306:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80030d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800312:	8d 47 01             	lea    0x1(%edi),%eax
  800315:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800318:	0f b6 17             	movzbl (%edi),%edx
  80031b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80031e:	3c 55                	cmp    $0x55,%al
  800320:	0f 87 51 04 00 00    	ja     800777 <vprintfmt+0x49a>
  800326:	0f b6 c0             	movzbl %al,%eax
  800329:	ff 24 85 40 12 80 00 	jmp    *0x801240(,%eax,4)
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800333:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800337:	eb d9                	jmp    800312 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80033c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800340:	eb d0                	jmp    800312 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800342:	0f b6 d2             	movzbl %dl,%edx
  800345:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800348:	b8 00 00 00 00       	mov    $0x0,%eax
  80034d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800350:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800353:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800357:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80035a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80035d:	83 f9 09             	cmp    $0x9,%ecx
  800360:	77 55                	ja     8003b7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800362:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800365:	eb e9                	jmp    800350 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036f:	8b 45 14             	mov    0x14(%ebp),%eax
  800372:	8d 40 04             	lea    0x4(%eax),%eax
  800375:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80037b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80037f:	79 91                	jns    800312 <vprintfmt+0x35>
				width = precision, precision = -1;
  800381:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800384:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800387:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80038e:	eb 82                	jmp    800312 <vprintfmt+0x35>
  800390:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800393:	85 c0                	test   %eax,%eax
  800395:	ba 00 00 00 00       	mov    $0x0,%edx
  80039a:	0f 49 d0             	cmovns %eax,%edx
  80039d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a3:	e9 6a ff ff ff       	jmp    800312 <vprintfmt+0x35>
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ab:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003b2:	e9 5b ff ff ff       	jmp    800312 <vprintfmt+0x35>
  8003b7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003bd:	eb bc                	jmp    80037b <vprintfmt+0x9e>
			lflag++;
  8003bf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c5:	e9 48 ff ff ff       	jmp    800312 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cd:	8d 78 04             	lea    0x4(%eax),%edi
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	53                   	push   %ebx
  8003d4:	ff 30                	pushl  (%eax)
  8003d6:	ff d6                	call   *%esi
			break;
  8003d8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003db:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003de:	e9 0e 03 00 00       	jmp    8006f1 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e6:	8d 78 04             	lea    0x4(%eax),%edi
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	99                   	cltd   
  8003ec:	31 d0                	xor    %edx,%eax
  8003ee:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f0:	83 f8 08             	cmp    $0x8,%eax
  8003f3:	7f 23                	jg     800418 <vprintfmt+0x13b>
  8003f5:	8b 14 85 a0 13 80 00 	mov    0x8013a0(,%eax,4),%edx
  8003fc:	85 d2                	test   %edx,%edx
  8003fe:	74 18                	je     800418 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800400:	52                   	push   %edx
  800401:	68 a1 11 80 00       	push   $0x8011a1
  800406:	53                   	push   %ebx
  800407:	56                   	push   %esi
  800408:	e8 b3 fe ff ff       	call   8002c0 <printfmt>
  80040d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800410:	89 7d 14             	mov    %edi,0x14(%ebp)
  800413:	e9 d9 02 00 00       	jmp    8006f1 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800418:	50                   	push   %eax
  800419:	68 98 11 80 00       	push   $0x801198
  80041e:	53                   	push   %ebx
  80041f:	56                   	push   %esi
  800420:	e8 9b fe ff ff       	call   8002c0 <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80042b:	e9 c1 02 00 00       	jmp    8006f1 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	83 c0 04             	add    $0x4,%eax
  800436:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800439:	8b 45 14             	mov    0x14(%ebp),%eax
  80043c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80043e:	85 ff                	test   %edi,%edi
  800440:	b8 91 11 80 00       	mov    $0x801191,%eax
  800445:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800448:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044c:	0f 8e bd 00 00 00    	jle    80050f <vprintfmt+0x232>
  800452:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800456:	75 0e                	jne    800466 <vprintfmt+0x189>
  800458:	89 75 08             	mov    %esi,0x8(%ebp)
  80045b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80045e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800461:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800464:	eb 6d                	jmp    8004d3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	ff 75 d0             	pushl  -0x30(%ebp)
  80046c:	57                   	push   %edi
  80046d:	e8 ad 03 00 00       	call   80081f <strnlen>
  800472:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800475:	29 c1                	sub    %eax,%ecx
  800477:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80047a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80047d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800481:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800484:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800487:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800489:	eb 0f                	jmp    80049a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	53                   	push   %ebx
  80048f:	ff 75 e0             	pushl  -0x20(%ebp)
  800492:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800494:	83 ef 01             	sub    $0x1,%edi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 ff                	test   %edi,%edi
  80049c:	7f ed                	jg     80048b <vprintfmt+0x1ae>
  80049e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004a1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004a4:	85 c9                	test   %ecx,%ecx
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	0f 49 c1             	cmovns %ecx,%eax
  8004ae:	29 c1                	sub    %eax,%ecx
  8004b0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b9:	89 cb                	mov    %ecx,%ebx
  8004bb:	eb 16                	jmp    8004d3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c1:	75 31                	jne    8004f4 <vprintfmt+0x217>
					putch(ch, putdat);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	ff 75 0c             	pushl  0xc(%ebp)
  8004c9:	50                   	push   %eax
  8004ca:	ff 55 08             	call   *0x8(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d0:	83 eb 01             	sub    $0x1,%ebx
  8004d3:	83 c7 01             	add    $0x1,%edi
  8004d6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004da:	0f be c2             	movsbl %dl,%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	74 59                	je     80053a <vprintfmt+0x25d>
  8004e1:	85 f6                	test   %esi,%esi
  8004e3:	78 d8                	js     8004bd <vprintfmt+0x1e0>
  8004e5:	83 ee 01             	sub    $0x1,%esi
  8004e8:	79 d3                	jns    8004bd <vprintfmt+0x1e0>
  8004ea:	89 df                	mov    %ebx,%edi
  8004ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f2:	eb 37                	jmp    80052b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	0f be d2             	movsbl %dl,%edx
  8004f7:	83 ea 20             	sub    $0x20,%edx
  8004fa:	83 fa 5e             	cmp    $0x5e,%edx
  8004fd:	76 c4                	jbe    8004c3 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	ff 75 0c             	pushl  0xc(%ebp)
  800505:	6a 3f                	push   $0x3f
  800507:	ff 55 08             	call   *0x8(%ebp)
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	eb c1                	jmp    8004d0 <vprintfmt+0x1f3>
  80050f:	89 75 08             	mov    %esi,0x8(%ebp)
  800512:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800515:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800518:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80051b:	eb b6                	jmp    8004d3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	6a 20                	push   $0x20
  800523:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800525:	83 ef 01             	sub    $0x1,%edi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	85 ff                	test   %edi,%edi
  80052d:	7f ee                	jg     80051d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80052f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	e9 b7 01 00 00       	jmp    8006f1 <vprintfmt+0x414>
  80053a:	89 df                	mov    %ebx,%edi
  80053c:	8b 75 08             	mov    0x8(%ebp),%esi
  80053f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800542:	eb e7                	jmp    80052b <vprintfmt+0x24e>
	if (lflag >= 2)
  800544:	83 f9 01             	cmp    $0x1,%ecx
  800547:	7e 3f                	jle    800588 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8b 50 04             	mov    0x4(%eax),%edx
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800554:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 40 08             	lea    0x8(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800560:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800564:	79 5c                	jns    8005c2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	53                   	push   %ebx
  80056a:	6a 2d                	push   $0x2d
  80056c:	ff d6                	call   *%esi
				num = -(long long) num;
  80056e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800571:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800574:	f7 da                	neg    %edx
  800576:	83 d1 00             	adc    $0x0,%ecx
  800579:	f7 d9                	neg    %ecx
  80057b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800583:	e9 4f 01 00 00       	jmp    8006d7 <vprintfmt+0x3fa>
	else if (lflag)
  800588:	85 c9                	test   %ecx,%ecx
  80058a:	75 1b                	jne    8005a7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800594:	89 c1                	mov    %eax,%ecx
  800596:	c1 f9 1f             	sar    $0x1f,%ecx
  800599:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8d 40 04             	lea    0x4(%eax),%eax
  8005a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a5:	eb b9                	jmp    800560 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005af:	89 c1                	mov    %eax,%ecx
  8005b1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 40 04             	lea    0x4(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c0:	eb 9e                	jmp    800560 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cd:	e9 05 01 00 00       	jmp    8006d7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005d2:	83 f9 01             	cmp    $0x1,%ecx
  8005d5:	7e 18                	jle    8005ef <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 10                	mov    (%eax),%edx
  8005dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8005df:	8d 40 08             	lea    0x8(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ea:	e9 e8 00 00 00       	jmp    8006d7 <vprintfmt+0x3fa>
	else if (lflag)
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	75 1a                	jne    80060d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
  800608:	e9 ca 00 00 00       	jmp    8006d7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 10                	mov    (%eax),%edx
  800612:	b9 00 00 00 00       	mov    $0x0,%ecx
  800617:	8d 40 04             	lea    0x4(%eax),%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800622:	e9 b0 00 00 00       	jmp    8006d7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7e 3c                	jle    800668 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 50 04             	mov    0x4(%eax),%edx
  800632:	8b 00                	mov    (%eax),%eax
  800634:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800637:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 08             	lea    0x8(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800643:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800647:	79 59                	jns    8006a2 <vprintfmt+0x3c5>
                putch('-', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	6a 2d                	push   $0x2d
  80064f:	ff d6                	call   *%esi
                num = -(long long) num;
  800651:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800654:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800657:	f7 da                	neg    %edx
  800659:	83 d1 00             	adc    $0x0,%ecx
  80065c:	f7 d9                	neg    %ecx
  80065e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800661:	b8 08 00 00 00       	mov    $0x8,%eax
  800666:	eb 6f                	jmp    8006d7 <vprintfmt+0x3fa>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	75 1b                	jne    800687 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 c1                	mov    %eax,%ecx
  800676:	c1 f9 1f             	sar    $0x1f,%ecx
  800679:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 40 04             	lea    0x4(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
  800685:	eb bc                	jmp    800643 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068f:	89 c1                	mov    %eax,%ecx
  800691:	c1 f9 1f             	sar    $0x1f,%ecx
  800694:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a0:	eb a1                	jmp    800643 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ad:	eb 28                	jmp    8006d7 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	6a 30                	push   $0x30
  8006b5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b7:	83 c4 08             	add    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 78                	push   $0x78
  8006bd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 10                	mov    (%eax),%edx
  8006c4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006de:	57                   	push   %edi
  8006df:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e2:	50                   	push   %eax
  8006e3:	51                   	push   %ecx
  8006e4:	52                   	push   %edx
  8006e5:	89 da                	mov    %ebx,%edx
  8006e7:	89 f0                	mov    %esi,%eax
  8006e9:	e8 06 fb ff ff       	call   8001f4 <printnum>
			break;
  8006ee:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f4:	83 c7 01             	add    $0x1,%edi
  8006f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006fb:	83 f8 25             	cmp    $0x25,%eax
  8006fe:	0f 84 f0 fb ff ff    	je     8002f4 <vprintfmt+0x17>
			if (ch == '\0')
  800704:	85 c0                	test   %eax,%eax
  800706:	0f 84 8b 00 00 00    	je     800797 <vprintfmt+0x4ba>
			putch(ch, putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	50                   	push   %eax
  800711:	ff d6                	call   *%esi
  800713:	83 c4 10             	add    $0x10,%esp
  800716:	eb dc                	jmp    8006f4 <vprintfmt+0x417>
	if (lflag >= 2)
  800718:	83 f9 01             	cmp    $0x1,%ecx
  80071b:	7e 15                	jle    800732 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 10                	mov    (%eax),%edx
  800722:	8b 48 04             	mov    0x4(%eax),%ecx
  800725:	8d 40 08             	lea    0x8(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072b:	b8 10 00 00 00       	mov    $0x10,%eax
  800730:	eb a5                	jmp    8006d7 <vprintfmt+0x3fa>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	75 17                	jne    80074d <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 10                	mov    (%eax),%edx
  80073b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800746:	b8 10 00 00 00       	mov    $0x10,%eax
  80074b:	eb 8a                	jmp    8006d7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 10                	mov    (%eax),%edx
  800752:	b9 00 00 00 00       	mov    $0x0,%ecx
  800757:	8d 40 04             	lea    0x4(%eax),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075d:	b8 10 00 00 00       	mov    $0x10,%eax
  800762:	e9 70 ff ff ff       	jmp    8006d7 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	6a 25                	push   $0x25
  80076d:	ff d6                	call   *%esi
			break;
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	e9 7a ff ff ff       	jmp    8006f1 <vprintfmt+0x414>
			putch('%', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	53                   	push   %ebx
  80077b:	6a 25                	push   $0x25
  80077d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	89 f8                	mov    %edi,%eax
  800784:	eb 03                	jmp    800789 <vprintfmt+0x4ac>
  800786:	83 e8 01             	sub    $0x1,%eax
  800789:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80078d:	75 f7                	jne    800786 <vprintfmt+0x4a9>
  80078f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800792:	e9 5a ff ff ff       	jmp    8006f1 <vprintfmt+0x414>
}
  800797:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079a:	5b                   	pop    %ebx
  80079b:	5e                   	pop    %esi
  80079c:	5f                   	pop    %edi
  80079d:	5d                   	pop    %ebp
  80079e:	c3                   	ret    

0080079f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	83 ec 18             	sub    $0x18,%esp
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ae:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007bc:	85 c0                	test   %eax,%eax
  8007be:	74 26                	je     8007e6 <vsnprintf+0x47>
  8007c0:	85 d2                	test   %edx,%edx
  8007c2:	7e 22                	jle    8007e6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c4:	ff 75 14             	pushl  0x14(%ebp)
  8007c7:	ff 75 10             	pushl  0x10(%ebp)
  8007ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	68 a3 02 80 00       	push   $0x8002a3
  8007d3:	e8 05 fb ff ff       	call   8002dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    
		return -E_INVAL;
  8007e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007eb:	eb f7                	jmp    8007e4 <vsnprintf+0x45>

008007ed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f6:	50                   	push   %eax
  8007f7:	ff 75 10             	pushl  0x10(%ebp)
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	ff 75 08             	pushl  0x8(%ebp)
  800800:	e8 9a ff ff ff       	call   80079f <vsnprintf>
	va_end(ap);

	return rc;
}
  800805:	c9                   	leave  
  800806:	c3                   	ret    

00800807 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
  800812:	eb 03                	jmp    800817 <strlen+0x10>
		n++;
  800814:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800817:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80081b:	75 f7                	jne    800814 <strlen+0xd>
	return n;
}
  80081d:	5d                   	pop    %ebp
  80081e:	c3                   	ret    

0080081f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800828:	b8 00 00 00 00       	mov    $0x0,%eax
  80082d:	eb 03                	jmp    800832 <strnlen+0x13>
		n++;
  80082f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800832:	39 d0                	cmp    %edx,%eax
  800834:	74 06                	je     80083c <strnlen+0x1d>
  800836:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80083a:	75 f3                	jne    80082f <strnlen+0x10>
	return n;
}
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800848:	89 c2                	mov    %eax,%edx
  80084a:	83 c1 01             	add    $0x1,%ecx
  80084d:	83 c2 01             	add    $0x1,%edx
  800850:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800854:	88 5a ff             	mov    %bl,-0x1(%edx)
  800857:	84 db                	test   %bl,%bl
  800859:	75 ef                	jne    80084a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80085b:	5b                   	pop    %ebx
  80085c:	5d                   	pop    %ebp
  80085d:	c3                   	ret    

0080085e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	53                   	push   %ebx
  800862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800865:	53                   	push   %ebx
  800866:	e8 9c ff ff ff       	call   800807 <strlen>
  80086b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	01 d8                	add    %ebx,%eax
  800873:	50                   	push   %eax
  800874:	e8 c5 ff ff ff       	call   80083e <strcpy>
	return dst;
}
  800879:	89 d8                	mov    %ebx,%eax
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	56                   	push   %esi
  800884:	53                   	push   %ebx
  800885:	8b 75 08             	mov    0x8(%ebp),%esi
  800888:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088b:	89 f3                	mov    %esi,%ebx
  80088d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800890:	89 f2                	mov    %esi,%edx
  800892:	eb 0f                	jmp    8008a3 <strncpy+0x23>
		*dst++ = *src;
  800894:	83 c2 01             	add    $0x1,%edx
  800897:	0f b6 01             	movzbl (%ecx),%eax
  80089a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089d:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008a3:	39 da                	cmp    %ebx,%edx
  8008a5:	75 ed                	jne    800894 <strncpy+0x14>
	}
	return ret;
}
  8008a7:	89 f0                	mov    %esi,%eax
  8008a9:	5b                   	pop    %ebx
  8008aa:	5e                   	pop    %esi
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	56                   	push   %esi
  8008b1:	53                   	push   %ebx
  8008b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c1:	85 c9                	test   %ecx,%ecx
  8008c3:	75 0b                	jne    8008d0 <strlcpy+0x23>
  8008c5:	eb 17                	jmp    8008de <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008c7:	83 c2 01             	add    $0x1,%edx
  8008ca:	83 c0 01             	add    $0x1,%eax
  8008cd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008d0:	39 d8                	cmp    %ebx,%eax
  8008d2:	74 07                	je     8008db <strlcpy+0x2e>
  8008d4:	0f b6 0a             	movzbl (%edx),%ecx
  8008d7:	84 c9                	test   %cl,%cl
  8008d9:	75 ec                	jne    8008c7 <strlcpy+0x1a>
		*dst = '\0';
  8008db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008de:	29 f0                	sub    %esi,%eax
}
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ed:	eb 06                	jmp    8008f5 <strcmp+0x11>
		p++, q++;
  8008ef:	83 c1 01             	add    $0x1,%ecx
  8008f2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008f5:	0f b6 01             	movzbl (%ecx),%eax
  8008f8:	84 c0                	test   %al,%al
  8008fa:	74 04                	je     800900 <strcmp+0x1c>
  8008fc:	3a 02                	cmp    (%edx),%al
  8008fe:	74 ef                	je     8008ef <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800900:	0f b6 c0             	movzbl %al,%eax
  800903:	0f b6 12             	movzbl (%edx),%edx
  800906:	29 d0                	sub    %edx,%eax
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	53                   	push   %ebx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 55 0c             	mov    0xc(%ebp),%edx
  800914:	89 c3                	mov    %eax,%ebx
  800916:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800919:	eb 06                	jmp    800921 <strncmp+0x17>
		n--, p++, q++;
  80091b:	83 c0 01             	add    $0x1,%eax
  80091e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800921:	39 d8                	cmp    %ebx,%eax
  800923:	74 16                	je     80093b <strncmp+0x31>
  800925:	0f b6 08             	movzbl (%eax),%ecx
  800928:	84 c9                	test   %cl,%cl
  80092a:	74 04                	je     800930 <strncmp+0x26>
  80092c:	3a 0a                	cmp    (%edx),%cl
  80092e:	74 eb                	je     80091b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800930:	0f b6 00             	movzbl (%eax),%eax
  800933:	0f b6 12             	movzbl (%edx),%edx
  800936:	29 d0                	sub    %edx,%eax
}
  800938:	5b                   	pop    %ebx
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    
		return 0;
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
  800940:	eb f6                	jmp    800938 <strncmp+0x2e>

00800942 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094c:	0f b6 10             	movzbl (%eax),%edx
  80094f:	84 d2                	test   %dl,%dl
  800951:	74 09                	je     80095c <strchr+0x1a>
		if (*s == c)
  800953:	38 ca                	cmp    %cl,%dl
  800955:	74 0a                	je     800961 <strchr+0x1f>
	for (; *s; s++)
  800957:	83 c0 01             	add    $0x1,%eax
  80095a:	eb f0                	jmp    80094c <strchr+0xa>
			return (char *) s;
	return 0;
  80095c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096d:	eb 03                	jmp    800972 <strfind+0xf>
  80096f:	83 c0 01             	add    $0x1,%eax
  800972:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800975:	38 ca                	cmp    %cl,%dl
  800977:	74 04                	je     80097d <strfind+0x1a>
  800979:	84 d2                	test   %dl,%dl
  80097b:	75 f2                	jne    80096f <strfind+0xc>
			break;
	return (char *) s;
}
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	57                   	push   %edi
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 7d 08             	mov    0x8(%ebp),%edi
  800988:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80098b:	85 c9                	test   %ecx,%ecx
  80098d:	74 13                	je     8009a2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800995:	75 05                	jne    80099c <memset+0x1d>
  800997:	f6 c1 03             	test   $0x3,%cl
  80099a:	74 0d                	je     8009a9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099f:	fc                   	cld    
  8009a0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a2:	89 f8                	mov    %edi,%eax
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5f                   	pop    %edi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    
		c &= 0xFF;
  8009a9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ad:	89 d3                	mov    %edx,%ebx
  8009af:	c1 e3 08             	shl    $0x8,%ebx
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 18             	shl    $0x18,%eax
  8009b7:	89 d6                	mov    %edx,%esi
  8009b9:	c1 e6 10             	shl    $0x10,%esi
  8009bc:	09 f0                	or     %esi,%eax
  8009be:	09 c2                	or     %eax,%edx
  8009c0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	fc                   	cld    
  8009c8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ca:	eb d6                	jmp    8009a2 <memset+0x23>

008009cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	57                   	push   %edi
  8009d0:	56                   	push   %esi
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009da:	39 c6                	cmp    %eax,%esi
  8009dc:	73 35                	jae    800a13 <memmove+0x47>
  8009de:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e1:	39 c2                	cmp    %eax,%edx
  8009e3:	76 2e                	jbe    800a13 <memmove+0x47>
		s += n;
		d += n;
  8009e5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e8:	89 d6                	mov    %edx,%esi
  8009ea:	09 fe                	or     %edi,%esi
  8009ec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f2:	74 0c                	je     800a00 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f4:	83 ef 01             	sub    $0x1,%edi
  8009f7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009fa:	fd                   	std    
  8009fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009fd:	fc                   	cld    
  8009fe:	eb 21                	jmp    800a21 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a00:	f6 c1 03             	test   $0x3,%cl
  800a03:	75 ef                	jne    8009f4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a05:	83 ef 04             	sub    $0x4,%edi
  800a08:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a11:	eb ea                	jmp    8009fd <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a13:	89 f2                	mov    %esi,%edx
  800a15:	09 c2                	or     %eax,%edx
  800a17:	f6 c2 03             	test   $0x3,%dl
  800a1a:	74 09                	je     800a25 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a1c:	89 c7                	mov    %eax,%edi
  800a1e:	fc                   	cld    
  800a1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a21:	5e                   	pop    %esi
  800a22:	5f                   	pop    %edi
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a25:	f6 c1 03             	test   $0x3,%cl
  800a28:	75 f2                	jne    800a1c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a2d:	89 c7                	mov    %eax,%edi
  800a2f:	fc                   	cld    
  800a30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a32:	eb ed                	jmp    800a21 <memmove+0x55>

00800a34 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a37:	ff 75 10             	pushl  0x10(%ebp)
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	ff 75 08             	pushl  0x8(%ebp)
  800a40:	e8 87 ff ff ff       	call   8009cc <memmove>
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	56                   	push   %esi
  800a4b:	53                   	push   %ebx
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a52:	89 c6                	mov    %eax,%esi
  800a54:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a57:	39 f0                	cmp    %esi,%eax
  800a59:	74 1c                	je     800a77 <memcmp+0x30>
		if (*s1 != *s2)
  800a5b:	0f b6 08             	movzbl (%eax),%ecx
  800a5e:	0f b6 1a             	movzbl (%edx),%ebx
  800a61:	38 d9                	cmp    %bl,%cl
  800a63:	75 08                	jne    800a6d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	83 c2 01             	add    $0x1,%edx
  800a6b:	eb ea                	jmp    800a57 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a6d:	0f b6 c1             	movzbl %cl,%eax
  800a70:	0f b6 db             	movzbl %bl,%ebx
  800a73:	29 d8                	sub    %ebx,%eax
  800a75:	eb 05                	jmp    800a7c <memcmp+0x35>
	}

	return 0;
  800a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7c:	5b                   	pop    %ebx
  800a7d:	5e                   	pop    %esi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a8e:	39 d0                	cmp    %edx,%eax
  800a90:	73 09                	jae    800a9b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a92:	38 08                	cmp    %cl,(%eax)
  800a94:	74 05                	je     800a9b <memfind+0x1b>
	for (; s < ends; s++)
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	eb f3                	jmp    800a8e <memfind+0xe>
			break;
	return (void *) s;
}
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	57                   	push   %edi
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa9:	eb 03                	jmp    800aae <strtol+0x11>
		s++;
  800aab:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aae:	0f b6 01             	movzbl (%ecx),%eax
  800ab1:	3c 20                	cmp    $0x20,%al
  800ab3:	74 f6                	je     800aab <strtol+0xe>
  800ab5:	3c 09                	cmp    $0x9,%al
  800ab7:	74 f2                	je     800aab <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ab9:	3c 2b                	cmp    $0x2b,%al
  800abb:	74 2e                	je     800aeb <strtol+0x4e>
	int neg = 0;
  800abd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ac2:	3c 2d                	cmp    $0x2d,%al
  800ac4:	74 2f                	je     800af5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800acc:	75 05                	jne    800ad3 <strtol+0x36>
  800ace:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad1:	74 2c                	je     800aff <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad3:	85 db                	test   %ebx,%ebx
  800ad5:	75 0a                	jne    800ae1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800adc:	80 39 30             	cmpb   $0x30,(%ecx)
  800adf:	74 28                	je     800b09 <strtol+0x6c>
		base = 10;
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ae9:	eb 50                	jmp    800b3b <strtol+0x9e>
		s++;
  800aeb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aee:	bf 00 00 00 00       	mov    $0x0,%edi
  800af3:	eb d1                	jmp    800ac6 <strtol+0x29>
		s++, neg = 1;
  800af5:	83 c1 01             	add    $0x1,%ecx
  800af8:	bf 01 00 00 00       	mov    $0x1,%edi
  800afd:	eb c7                	jmp    800ac6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aff:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b03:	74 0e                	je     800b13 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b05:	85 db                	test   %ebx,%ebx
  800b07:	75 d8                	jne    800ae1 <strtol+0x44>
		s++, base = 8;
  800b09:	83 c1 01             	add    $0x1,%ecx
  800b0c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b11:	eb ce                	jmp    800ae1 <strtol+0x44>
		s += 2, base = 16;
  800b13:	83 c1 02             	add    $0x2,%ecx
  800b16:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b1b:	eb c4                	jmp    800ae1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b1d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b20:	89 f3                	mov    %esi,%ebx
  800b22:	80 fb 19             	cmp    $0x19,%bl
  800b25:	77 29                	ja     800b50 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b27:	0f be d2             	movsbl %dl,%edx
  800b2a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b2d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b30:	7d 30                	jge    800b62 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b32:	83 c1 01             	add    $0x1,%ecx
  800b35:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b39:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3b:	0f b6 11             	movzbl (%ecx),%edx
  800b3e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b41:	89 f3                	mov    %esi,%ebx
  800b43:	80 fb 09             	cmp    $0x9,%bl
  800b46:	77 d5                	ja     800b1d <strtol+0x80>
			dig = *s - '0';
  800b48:	0f be d2             	movsbl %dl,%edx
  800b4b:	83 ea 30             	sub    $0x30,%edx
  800b4e:	eb dd                	jmp    800b2d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b50:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b53:	89 f3                	mov    %esi,%ebx
  800b55:	80 fb 19             	cmp    $0x19,%bl
  800b58:	77 08                	ja     800b62 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b5a:	0f be d2             	movsbl %dl,%edx
  800b5d:	83 ea 37             	sub    $0x37,%edx
  800b60:	eb cb                	jmp    800b2d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b66:	74 05                	je     800b6d <strtol+0xd0>
		*endptr = (char *) s;
  800b68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b6d:	89 c2                	mov    %eax,%edx
  800b6f:	f7 da                	neg    %edx
  800b71:	85 ff                	test   %edi,%edi
  800b73:	0f 45 c2             	cmovne %edx,%eax
}
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	8b 55 08             	mov    0x8(%ebp),%edx
  800b89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8c:	89 c3                	mov    %eax,%ebx
  800b8e:	89 c7                	mov    %eax,%edi
  800b90:	89 c6                	mov    %eax,%esi
  800b92:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <sys_cgetc>:

int
sys_cgetc(void) {
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	57                   	push   %edi
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba9:	89 d1                	mov    %edx,%ecx
  800bab:	89 d3                	mov    %edx,%ebx
  800bad:	89 d7                	mov    %edx,%edi
  800baf:	89 d6                	mov    %edx,%esi
  800bb1:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bce:	89 cb                	mov    %ecx,%ebx
  800bd0:	89 cf                	mov    %ecx,%edi
  800bd2:	89 ce                	mov    %ecx,%esi
  800bd4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bd6:	85 c0                	test   %eax,%eax
  800bd8:	7f 08                	jg     800be2 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	50                   	push   %eax
  800be6:	6a 03                	push   $0x3
  800be8:	68 c4 13 80 00       	push   $0x8013c4
  800bed:	6a 24                	push   $0x24
  800bef:	68 e1 13 80 00       	push   $0x8013e1
  800bf4:	e8 82 02 00 00       	call   800e7b <_panic>

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

00800c18 <sys_yield>:

void
sys_yield(void)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c23:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c28:	89 d1                	mov    %edx,%ecx
  800c2a:	89 d3                	mov    %edx,%ebx
  800c2c:	89 d7                	mov    %edx,%edi
  800c2e:	89 d6                	mov    %edx,%esi
  800c30:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c40:	be 00 00 00 00       	mov    $0x0,%esi
  800c45:	8b 55 08             	mov    0x8(%ebp),%edx
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c53:	89 f7                	mov    %esi,%edi
  800c55:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c57:	85 c0                	test   %eax,%eax
  800c59:	7f 08                	jg     800c63 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	50                   	push   %eax
  800c67:	6a 04                	push   $0x4
  800c69:	68 c4 13 80 00       	push   $0x8013c4
  800c6e:	6a 24                	push   $0x24
  800c70:	68 e1 13 80 00       	push   $0x8013e1
  800c75:	e8 01 02 00 00       	call   800e7b <_panic>

00800c7a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c89:	b8 05 00 00 00       	mov    $0x5,%eax
  800c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c94:	8b 75 18             	mov    0x18(%ebp),%esi
  800c97:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	7f 08                	jg     800ca5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	50                   	push   %eax
  800ca9:	6a 05                	push   $0x5
  800cab:	68 c4 13 80 00       	push   $0x8013c4
  800cb0:	6a 24                	push   $0x24
  800cb2:	68 e1 13 80 00       	push   $0x8013e1
  800cb7:	e8 bf 01 00 00       	call   800e7b <_panic>

00800cbc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd0:	b8 06 00 00 00       	mov    $0x6,%eax
  800cd5:	89 df                	mov    %ebx,%edi
  800cd7:	89 de                	mov    %ebx,%esi
  800cd9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cdb:	85 c0                	test   %eax,%eax
  800cdd:	7f 08                	jg     800ce7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	50                   	push   %eax
  800ceb:	6a 06                	push   $0x6
  800ced:	68 c4 13 80 00       	push   $0x8013c4
  800cf2:	6a 24                	push   $0x24
  800cf4:	68 e1 13 80 00       	push   $0x8013e1
  800cf9:	e8 7d 01 00 00       	call   800e7b <_panic>

00800cfe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	b8 08 00 00 00       	mov    $0x8,%eax
  800d17:	89 df                	mov    %ebx,%edi
  800d19:	89 de                	mov    %ebx,%esi
  800d1b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 08                	push   $0x8
  800d2f:	68 c4 13 80 00       	push   $0x8013c4
  800d34:	6a 24                	push   $0x24
  800d36:	68 e1 13 80 00       	push   $0x8013e1
  800d3b:	e8 3b 01 00 00       	call   800e7b <_panic>

00800d40 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d54:	b8 09 00 00 00       	mov    $0x9,%eax
  800d59:	89 df                	mov    %ebx,%edi
  800d5b:	89 de                	mov    %ebx,%esi
  800d5d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7f 08                	jg     800d6b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	50                   	push   %eax
  800d6f:	6a 09                	push   $0x9
  800d71:	68 c4 13 80 00       	push   $0x8013c4
  800d76:	6a 24                	push   $0x24
  800d78:	68 e1 13 80 00       	push   $0x8013e1
  800d7d:	e8 f9 00 00 00       	call   800e7b <_panic>

00800d82 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d93:	be 00 00 00 00       	mov    $0x0,%esi
  800d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbb:	89 cb                	mov    %ecx,%ebx
  800dbd:	89 cf                	mov    %ecx,%edi
  800dbf:	89 ce                	mov    %ecx,%esi
  800dc1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	7f 08                	jg     800dcf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	50                   	push   %eax
  800dd3:	6a 0c                	push   $0xc
  800dd5:	68 c4 13 80 00       	push   $0x8013c4
  800dda:	6a 24                	push   $0x24
  800ddc:	68 e1 13 80 00       	push   $0x8013e1
  800de1:	e8 95 00 00 00       	call   800e7b <_panic>

00800de6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800dec:	68 fb 13 80 00       	push   $0x8013fb
  800df1:	6a 51                	push   $0x51
  800df3:	68 ef 13 80 00       	push   $0x8013ef
  800df8:	e8 7e 00 00 00       	call   800e7b <_panic>

00800dfd <sfork>:
}

// Challenge!
int
sfork(void)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800e03:	68 fa 13 80 00       	push   $0x8013fa
  800e08:	6a 58                	push   $0x58
  800e0a:	68 ef 13 80 00       	push   $0x8013ef
  800e0f:	e8 67 00 00 00       	call   800e7b <_panic>

00800e14 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800e1a:	68 10 14 80 00       	push   $0x801410
  800e1f:	6a 1a                	push   $0x1a
  800e21:	68 29 14 80 00       	push   $0x801429
  800e26:	e8 50 00 00 00       	call   800e7b <_panic>

00800e2b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800e31:	68 33 14 80 00       	push   $0x801433
  800e36:	6a 2a                	push   $0x2a
  800e38:	68 29 14 80 00       	push   $0x801429
  800e3d:	e8 39 00 00 00       	call   800e7b <_panic>

00800e42 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800e4d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800e50:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800e56:	8b 52 50             	mov    0x50(%edx),%edx
  800e59:	39 ca                	cmp    %ecx,%edx
  800e5b:	74 11                	je     800e6e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800e5d:	83 c0 01             	add    $0x1,%eax
  800e60:	3d 00 04 00 00       	cmp    $0x400,%eax
  800e65:	75 e6                	jne    800e4d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6c:	eb 0b                	jmp    800e79 <ipc_find_env+0x37>
			return envs[i].env_id;
  800e6e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e71:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e76:	8b 40 48             	mov    0x48(%eax),%eax
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e80:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e83:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e89:	e8 6b fd ff ff       	call   800bf9 <sys_getenvid>
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	ff 75 08             	pushl  0x8(%ebp)
  800e97:	56                   	push   %esi
  800e98:	50                   	push   %eax
  800e99:	68 4c 14 80 00       	push   $0x80144c
  800e9e:	e8 3d f3 ff ff       	call   8001e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ea3:	83 c4 18             	add    $0x18,%esp
  800ea6:	53                   	push   %ebx
  800ea7:	ff 75 10             	pushl  0x10(%ebp)
  800eaa:	e8 e0 f2 ff ff       	call   80018f <vcprintf>
	cprintf("\n");
  800eaf:	c7 04 24 38 11 80 00 	movl   $0x801138,(%esp)
  800eb6:	e8 25 f3 ff ff       	call   8001e0 <cprintf>
  800ebb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ebe:	cc                   	int3   
  800ebf:	eb fd                	jmp    800ebe <_panic+0x43>
  800ec1:	66 90                	xchg   %ax,%ax
  800ec3:	66 90                	xchg   %ax,%ax
  800ec5:	66 90                	xchg   %ax,%ax
  800ec7:	66 90                	xchg   %ax,%ax
  800ec9:	66 90                	xchg   %ax,%ax
  800ecb:	66 90                	xchg   %ax,%ax
  800ecd:	66 90                	xchg   %ax,%ax
  800ecf:	90                   	nop

00800ed0 <__udivdi3>:
  800ed0:	55                   	push   %ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 1c             	sub    $0x1c,%esp
  800ed7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800edb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ee7:	85 d2                	test   %edx,%edx
  800ee9:	75 35                	jne    800f20 <__udivdi3+0x50>
  800eeb:	39 f3                	cmp    %esi,%ebx
  800eed:	0f 87 bd 00 00 00    	ja     800fb0 <__udivdi3+0xe0>
  800ef3:	85 db                	test   %ebx,%ebx
  800ef5:	89 d9                	mov    %ebx,%ecx
  800ef7:	75 0b                	jne    800f04 <__udivdi3+0x34>
  800ef9:	b8 01 00 00 00       	mov    $0x1,%eax
  800efe:	31 d2                	xor    %edx,%edx
  800f00:	f7 f3                	div    %ebx
  800f02:	89 c1                	mov    %eax,%ecx
  800f04:	31 d2                	xor    %edx,%edx
  800f06:	89 f0                	mov    %esi,%eax
  800f08:	f7 f1                	div    %ecx
  800f0a:	89 c6                	mov    %eax,%esi
  800f0c:	89 e8                	mov    %ebp,%eax
  800f0e:	89 f7                	mov    %esi,%edi
  800f10:	f7 f1                	div    %ecx
  800f12:	89 fa                	mov    %edi,%edx
  800f14:	83 c4 1c             	add    $0x1c,%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
  800f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f20:	39 f2                	cmp    %esi,%edx
  800f22:	77 7c                	ja     800fa0 <__udivdi3+0xd0>
  800f24:	0f bd fa             	bsr    %edx,%edi
  800f27:	83 f7 1f             	xor    $0x1f,%edi
  800f2a:	0f 84 98 00 00 00    	je     800fc8 <__udivdi3+0xf8>
  800f30:	89 f9                	mov    %edi,%ecx
  800f32:	b8 20 00 00 00       	mov    $0x20,%eax
  800f37:	29 f8                	sub    %edi,%eax
  800f39:	d3 e2                	shl    %cl,%edx
  800f3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f3f:	89 c1                	mov    %eax,%ecx
  800f41:	89 da                	mov    %ebx,%edx
  800f43:	d3 ea                	shr    %cl,%edx
  800f45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f49:	09 d1                	or     %edx,%ecx
  800f4b:	89 f2                	mov    %esi,%edx
  800f4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f51:	89 f9                	mov    %edi,%ecx
  800f53:	d3 e3                	shl    %cl,%ebx
  800f55:	89 c1                	mov    %eax,%ecx
  800f57:	d3 ea                	shr    %cl,%edx
  800f59:	89 f9                	mov    %edi,%ecx
  800f5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f5f:	d3 e6                	shl    %cl,%esi
  800f61:	89 eb                	mov    %ebp,%ebx
  800f63:	89 c1                	mov    %eax,%ecx
  800f65:	d3 eb                	shr    %cl,%ebx
  800f67:	09 de                	or     %ebx,%esi
  800f69:	89 f0                	mov    %esi,%eax
  800f6b:	f7 74 24 08          	divl   0x8(%esp)
  800f6f:	89 d6                	mov    %edx,%esi
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	f7 64 24 0c          	mull   0xc(%esp)
  800f77:	39 d6                	cmp    %edx,%esi
  800f79:	72 0c                	jb     800f87 <__udivdi3+0xb7>
  800f7b:	89 f9                	mov    %edi,%ecx
  800f7d:	d3 e5                	shl    %cl,%ebp
  800f7f:	39 c5                	cmp    %eax,%ebp
  800f81:	73 5d                	jae    800fe0 <__udivdi3+0x110>
  800f83:	39 d6                	cmp    %edx,%esi
  800f85:	75 59                	jne    800fe0 <__udivdi3+0x110>
  800f87:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f8a:	31 ff                	xor    %edi,%edi
  800f8c:	89 fa                	mov    %edi,%edx
  800f8e:	83 c4 1c             	add    $0x1c,%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    
  800f96:	8d 76 00             	lea    0x0(%esi),%esi
  800f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800fa0:	31 ff                	xor    %edi,%edi
  800fa2:	31 c0                	xor    %eax,%eax
  800fa4:	89 fa                	mov    %edi,%edx
  800fa6:	83 c4 1c             	add    $0x1c,%esp
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    
  800fae:	66 90                	xchg   %ax,%ax
  800fb0:	31 ff                	xor    %edi,%edi
  800fb2:	89 e8                	mov    %ebp,%eax
  800fb4:	89 f2                	mov    %esi,%edx
  800fb6:	f7 f3                	div    %ebx
  800fb8:	89 fa                	mov    %edi,%edx
  800fba:	83 c4 1c             	add    $0x1c,%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
  800fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fc8:	39 f2                	cmp    %esi,%edx
  800fca:	72 06                	jb     800fd2 <__udivdi3+0x102>
  800fcc:	31 c0                	xor    %eax,%eax
  800fce:	39 eb                	cmp    %ebp,%ebx
  800fd0:	77 d2                	ja     800fa4 <__udivdi3+0xd4>
  800fd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd7:	eb cb                	jmp    800fa4 <__udivdi3+0xd4>
  800fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fe0:	89 d8                	mov    %ebx,%eax
  800fe2:	31 ff                	xor    %edi,%edi
  800fe4:	eb be                	jmp    800fa4 <__udivdi3+0xd4>
  800fe6:	66 90                	xchg   %ax,%ax
  800fe8:	66 90                	xchg   %ax,%ax
  800fea:	66 90                	xchg   %ax,%ax
  800fec:	66 90                	xchg   %ax,%ax
  800fee:	66 90                	xchg   %ax,%ax

00800ff0 <__umoddi3>:
  800ff0:	55                   	push   %ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 1c             	sub    $0x1c,%esp
  800ff7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800ffb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800fff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801003:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801007:	85 ed                	test   %ebp,%ebp
  801009:	89 f0                	mov    %esi,%eax
  80100b:	89 da                	mov    %ebx,%edx
  80100d:	75 19                	jne    801028 <__umoddi3+0x38>
  80100f:	39 df                	cmp    %ebx,%edi
  801011:	0f 86 b1 00 00 00    	jbe    8010c8 <__umoddi3+0xd8>
  801017:	f7 f7                	div    %edi
  801019:	89 d0                	mov    %edx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	83 c4 1c             	add    $0x1c,%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    
  801025:	8d 76 00             	lea    0x0(%esi),%esi
  801028:	39 dd                	cmp    %ebx,%ebp
  80102a:	77 f1                	ja     80101d <__umoddi3+0x2d>
  80102c:	0f bd cd             	bsr    %ebp,%ecx
  80102f:	83 f1 1f             	xor    $0x1f,%ecx
  801032:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801036:	0f 84 b4 00 00 00    	je     8010f0 <__umoddi3+0x100>
  80103c:	b8 20 00 00 00       	mov    $0x20,%eax
  801041:	89 c2                	mov    %eax,%edx
  801043:	8b 44 24 04          	mov    0x4(%esp),%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 c1                	mov    %eax,%ecx
  80104b:	89 f8                	mov    %edi,%eax
  80104d:	d3 e5                	shl    %cl,%ebp
  80104f:	89 d1                	mov    %edx,%ecx
  801051:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801055:	d3 e8                	shr    %cl,%eax
  801057:	09 c5                	or     %eax,%ebp
  801059:	8b 44 24 04          	mov    0x4(%esp),%eax
  80105d:	89 c1                	mov    %eax,%ecx
  80105f:	d3 e7                	shl    %cl,%edi
  801061:	89 d1                	mov    %edx,%ecx
  801063:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801067:	89 df                	mov    %ebx,%edi
  801069:	d3 ef                	shr    %cl,%edi
  80106b:	89 c1                	mov    %eax,%ecx
  80106d:	89 f0                	mov    %esi,%eax
  80106f:	d3 e3                	shl    %cl,%ebx
  801071:	89 d1                	mov    %edx,%ecx
  801073:	89 fa                	mov    %edi,%edx
  801075:	d3 e8                	shr    %cl,%eax
  801077:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80107c:	09 d8                	or     %ebx,%eax
  80107e:	f7 f5                	div    %ebp
  801080:	d3 e6                	shl    %cl,%esi
  801082:	89 d1                	mov    %edx,%ecx
  801084:	f7 64 24 08          	mull   0x8(%esp)
  801088:	39 d1                	cmp    %edx,%ecx
  80108a:	89 c3                	mov    %eax,%ebx
  80108c:	89 d7                	mov    %edx,%edi
  80108e:	72 06                	jb     801096 <__umoddi3+0xa6>
  801090:	75 0e                	jne    8010a0 <__umoddi3+0xb0>
  801092:	39 c6                	cmp    %eax,%esi
  801094:	73 0a                	jae    8010a0 <__umoddi3+0xb0>
  801096:	2b 44 24 08          	sub    0x8(%esp),%eax
  80109a:	19 ea                	sbb    %ebp,%edx
  80109c:	89 d7                	mov    %edx,%edi
  80109e:	89 c3                	mov    %eax,%ebx
  8010a0:	89 ca                	mov    %ecx,%edx
  8010a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8010a7:	29 de                	sub    %ebx,%esi
  8010a9:	19 fa                	sbb    %edi,%edx
  8010ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8010af:	89 d0                	mov    %edx,%eax
  8010b1:	d3 e0                	shl    %cl,%eax
  8010b3:	89 d9                	mov    %ebx,%ecx
  8010b5:	d3 ee                	shr    %cl,%esi
  8010b7:	d3 ea                	shr    %cl,%edx
  8010b9:	09 f0                	or     %esi,%eax
  8010bb:	83 c4 1c             	add    $0x1c,%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5f                   	pop    %edi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    
  8010c3:	90                   	nop
  8010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8010c8:	85 ff                	test   %edi,%edi
  8010ca:	89 f9                	mov    %edi,%ecx
  8010cc:	75 0b                	jne    8010d9 <__umoddi3+0xe9>
  8010ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8010d3:	31 d2                	xor    %edx,%edx
  8010d5:	f7 f7                	div    %edi
  8010d7:	89 c1                	mov    %eax,%ecx
  8010d9:	89 d8                	mov    %ebx,%eax
  8010db:	31 d2                	xor    %edx,%edx
  8010dd:	f7 f1                	div    %ecx
  8010df:	89 f0                	mov    %esi,%eax
  8010e1:	f7 f1                	div    %ecx
  8010e3:	e9 31 ff ff ff       	jmp    801019 <__umoddi3+0x29>
  8010e8:	90                   	nop
  8010e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010f0:	39 dd                	cmp    %ebx,%ebp
  8010f2:	72 08                	jb     8010fc <__umoddi3+0x10c>
  8010f4:	39 f7                	cmp    %esi,%edi
  8010f6:	0f 87 21 ff ff ff    	ja     80101d <__umoddi3+0x2d>
  8010fc:	89 da                	mov    %ebx,%edx
  8010fe:	89 f0                	mov    %esi,%eax
  801100:	29 f8                	sub    %edi,%eax
  801102:	19 ea                	sbb    %ebp,%edx
  801104:	e9 14 ff ff ff       	jmp    80101d <__umoddi3+0x2d>
