
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
  80003c:	e8 45 10 00 00       	call   801086 <sfork>
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
  800053:	e8 48 10 00 00       	call   8010a0 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 20 80 00       	mov    0x802004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 98 0b 00 00       	call   800c09 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 50 14 80 00       	push   $0x801450
  800080:	e8 6b 01 00 00       	call   8001f0 <cprintf>
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
  8000a3:	e8 0f 10 00 00       	call   8010b7 <ipc_send>
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
  8000c2:	e8 42 0b 00 00       	call   800c09 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 20 14 80 00       	push   $0x801420
  8000d1:	e8 1a 01 00 00       	call   8001f0 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 2b 0b 00 00       	call   800c09 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 3a 14 80 00       	push   $0x80143a
  8000e8:	e8 03 01 00 00       	call   8001f0 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 bc 0f 00 00       	call   8010b7 <ipc_send>
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
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 f6 0a 00 00       	call   800c09 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80014f:	6a 00                	push   $0x0
  800151:	e8 72 0a 00 00       	call   800bc8 <sys_env_destroy>
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 f7 09 00 00       	call   800b8b <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 1a 01 00 00       	call   8002ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 a3 09 00 00       	call   800b8b <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800228:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022b:	39 d3                	cmp    %edx,%ebx
  80022d:	72 05                	jb     800234 <printnum+0x30>
  80022f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800232:	77 7a                	ja     8002ae <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	8b 45 14             	mov    0x14(%ebp),%eax
  80023d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800240:	53                   	push   %ebx
  800241:	ff 75 10             	pushl  0x10(%ebp)
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	ff 75 d8             	pushl  -0x28(%ebp)
  800253:	e8 78 0f 00 00       	call   8011d0 <__udivdi3>
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	52                   	push   %edx
  80025c:	50                   	push   %eax
  80025d:	89 f2                	mov    %esi,%edx
  80025f:	89 f8                	mov    %edi,%eax
  800261:	e8 9e ff ff ff       	call   800204 <printnum>
  800266:	83 c4 20             	add    $0x20,%esp
  800269:	eb 13                	jmp    80027e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	ff 75 18             	pushl  0x18(%ebp)
  800272:	ff d7                	call   *%edi
  800274:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7f ed                	jg     80026b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	56                   	push   %esi
  800282:	83 ec 04             	sub    $0x4,%esp
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	ff 75 dc             	pushl  -0x24(%ebp)
  80028e:	ff 75 d8             	pushl  -0x28(%ebp)
  800291:	e8 5a 10 00 00       	call   8012f0 <__umoddi3>
  800296:	83 c4 14             	add    $0x14,%esp
  800299:	0f be 80 80 14 80 00 	movsbl 0x801480(%eax),%eax
  8002a0:	50                   	push   %eax
  8002a1:	ff d7                	call   *%edi
}
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    
  8002ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b1:	eb c4                	jmp    800277 <printnum+0x73>

008002b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c2:	73 0a                	jae    8002ce <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	88 02                	mov    %al,(%edx)
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <printfmt>:
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d9:	50                   	push   %eax
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 05 00 00 00       	call   8002ed <vprintfmt>
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vprintfmt>:
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 2c             	sub    $0x2c,%esp
  8002f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ff:	e9 00 04 00 00       	jmp    800704 <vprintfmt+0x417>
		padc = ' ';
  800304:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800308:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80030f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800316:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8d 47 01             	lea    0x1(%edi),%eax
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800328:	0f b6 17             	movzbl (%edi),%edx
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 51 04 00 00    	ja     800787 <vprintfmt+0x49a>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	ff 24 85 40 15 80 00 	jmp    *0x801540(,%eax,4)
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800343:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800347:	eb d9                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d0                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800367:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036d:	83 f9 09             	cmp    $0x9,%ecx
  800370:	77 55                	ja     8003c7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800372:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800375:	eb e9                	jmp    800360 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	79 91                	jns    800322 <vprintfmt+0x35>
				width = precision, precision = -1;
  800391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039e:	eb 82                	jmp    800322 <vprintfmt+0x35>
  8003a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a3:	85 c0                	test   %eax,%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	0f 49 d0             	cmovns %eax,%edx
  8003ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 6a ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c2:	e9 5b ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003cd:	eb bc                	jmp    80038b <vprintfmt+0x9e>
			lflag++;
  8003cf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d5:	e9 48 ff ff ff       	jmp    800322 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	53                   	push   %ebx
  8003e4:	ff 30                	pushl  (%eax)
  8003e6:	ff d6                	call   *%esi
			break;
  8003e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ee:	e9 0e 03 00 00       	jmp    800701 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
  8003fc:	31 d0                	xor    %edx,%eax
  8003fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	83 f8 08             	cmp    $0x8,%eax
  800403:	7f 23                	jg     800428 <vprintfmt+0x13b>
  800405:	8b 14 85 a0 16 80 00 	mov    0x8016a0(,%eax,4),%edx
  80040c:	85 d2                	test   %edx,%edx
  80040e:	74 18                	je     800428 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800410:	52                   	push   %edx
  800411:	68 a1 14 80 00       	push   $0x8014a1
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 b3 fe ff ff       	call   8002d0 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
  800423:	e9 d9 02 00 00       	jmp    800701 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800428:	50                   	push   %eax
  800429:	68 98 14 80 00       	push   $0x801498
  80042e:	53                   	push   %ebx
  80042f:	56                   	push   %esi
  800430:	e8 9b fe ff ff       	call   8002d0 <printfmt>
  800435:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043b:	e9 c1 02 00 00       	jmp    800701 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	83 c0 04             	add    $0x4,%eax
  800446:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80044e:	85 ff                	test   %edi,%edi
  800450:	b8 91 14 80 00       	mov    $0x801491,%eax
  800455:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045c:	0f 8e bd 00 00 00    	jle    80051f <vprintfmt+0x232>
  800462:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800466:	75 0e                	jne    800476 <vprintfmt+0x189>
  800468:	89 75 08             	mov    %esi,0x8(%ebp)
  80046b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800471:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800474:	eb 6d                	jmp    8004e3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 d0             	pushl  -0x30(%ebp)
  80047c:	57                   	push   %edi
  80047d:	e8 ad 03 00 00       	call   80082f <strnlen>
  800482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800485:	29 c1                	sub    %eax,%ecx
  800487:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800497:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	eb 0f                	jmp    8004aa <vprintfmt+0x1bd>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ed                	jg     80049b <vprintfmt+0x1ae>
  8004ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	0f 49 c1             	cmovns %ecx,%eax
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c9:	89 cb                	mov    %ecx,%ebx
  8004cb:	eb 16                	jmp    8004e3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d1:	75 31                	jne    800504 <vprintfmt+0x217>
					putch(ch, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	ff 55 08             	call   *0x8(%ebp)
  8004dd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 eb 01             	sub    $0x1,%ebx
  8004e3:	83 c7 01             	add    $0x1,%edi
  8004e6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ea:	0f be c2             	movsbl %dl,%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 59                	je     80054a <vprintfmt+0x25d>
  8004f1:	85 f6                	test   %esi,%esi
  8004f3:	78 d8                	js     8004cd <vprintfmt+0x1e0>
  8004f5:	83 ee 01             	sub    $0x1,%esi
  8004f8:	79 d3                	jns    8004cd <vprintfmt+0x1e0>
  8004fa:	89 df                	mov    %ebx,%edi
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800502:	eb 37                	jmp    80053b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800504:	0f be d2             	movsbl %dl,%edx
  800507:	83 ea 20             	sub    $0x20,%edx
  80050a:	83 fa 5e             	cmp    $0x5e,%edx
  80050d:	76 c4                	jbe    8004d3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	6a 3f                	push   $0x3f
  800517:	ff 55 08             	call   *0x8(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	eb c1                	jmp    8004e0 <vprintfmt+0x1f3>
  80051f:	89 75 08             	mov    %esi,0x8(%ebp)
  800522:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800525:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800528:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052b:	eb b6                	jmp    8004e3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 ef 01             	sub    $0x1,%edi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 ff                	test   %edi,%edi
  80053d:	7f ee                	jg     80052d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 b7 01 00 00       	jmp    800701 <vprintfmt+0x414>
  80054a:	89 df                	mov    %ebx,%edi
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
  80054f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800552:	eb e7                	jmp    80053b <vprintfmt+0x24e>
	if (lflag >= 2)
  800554:	83 f9 01             	cmp    $0x1,%ecx
  800557:	7e 3f                	jle    800598 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 50 04             	mov    0x4(%eax),%edx
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 08             	lea    0x8(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800570:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800574:	79 5c                	jns    8005d2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	53                   	push   %ebx
  80057a:	6a 2d                	push   $0x2d
  80057c:	ff d6                	call   *%esi
				num = -(long long) num;
  80057e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800581:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800584:	f7 da                	neg    %edx
  800586:	83 d1 00             	adc    $0x0,%ecx
  800589:	f7 d9                	neg    %ecx
  80058b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800593:	e9 4f 01 00 00       	jmp    8006e7 <vprintfmt+0x3fa>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	75 1b                	jne    8005b7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 c1                	mov    %eax,%ecx
  8005a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 40 04             	lea    0x4(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b5:	eb b9                	jmp    800570 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb 9e                	jmp    800570 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 05 01 00 00       	jmp    8006e7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7e 18                	jle    8005ff <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 10                	mov    (%eax),%edx
  8005ec:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ef:	8d 40 08             	lea    0x8(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 e8 00 00 00       	jmp    8006e7 <vprintfmt+0x3fa>
	else if (lflag)
  8005ff:	85 c9                	test   %ecx,%ecx
  800601:	75 1a                	jne    80061d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 10                	mov    (%eax),%edx
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 ca 00 00 00       	jmp    8006e7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800632:	e9 b0 00 00 00       	jmp    8006e7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800637:	83 f9 01             	cmp    $0x1,%ecx
  80063a:	7e 3c                	jle    800678 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 50 04             	mov    0x4(%eax),%edx
  800642:	8b 00                	mov    (%eax),%eax
  800644:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800647:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 40 08             	lea    0x8(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800653:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800657:	79 59                	jns    8006b2 <vprintfmt+0x3c5>
                putch('-', putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	53                   	push   %ebx
  80065d:	6a 2d                	push   $0x2d
  80065f:	ff d6                	call   *%esi
                num = -(long long) num;
  800661:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800664:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800667:	f7 da                	neg    %edx
  800669:	83 d1 00             	adc    $0x0,%ecx
  80066c:	f7 d9                	neg    %ecx
  80066e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800671:	b8 08 00 00 00       	mov    $0x8,%eax
  800676:	eb 6f                	jmp    8006e7 <vprintfmt+0x3fa>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	75 1b                	jne    800697 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 c1                	mov    %eax,%ecx
  800686:	c1 f9 1f             	sar    $0x1f,%ecx
  800689:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
  800695:	eb bc                	jmp    800653 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b0:	eb a1                	jmp    800653 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bd:	eb 28                	jmp    8006e7 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	53                   	push   %ebx
  8006c3:	6a 30                	push   $0x30
  8006c5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c7:	83 c4 08             	add    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 78                	push   $0x78
  8006cd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ee:	57                   	push   %edi
  8006ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f2:	50                   	push   %eax
  8006f3:	51                   	push   %ecx
  8006f4:	52                   	push   %edx
  8006f5:	89 da                	mov    %ebx,%edx
  8006f7:	89 f0                	mov    %esi,%eax
  8006f9:	e8 06 fb ff ff       	call   800204 <printnum>
			break;
  8006fe:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800701:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800704:	83 c7 01             	add    $0x1,%edi
  800707:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070b:	83 f8 25             	cmp    $0x25,%eax
  80070e:	0f 84 f0 fb ff ff    	je     800304 <vprintfmt+0x17>
			if (ch == '\0')
  800714:	85 c0                	test   %eax,%eax
  800716:	0f 84 8b 00 00 00    	je     8007a7 <vprintfmt+0x4ba>
			putch(ch, putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	50                   	push   %eax
  800721:	ff d6                	call   *%esi
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	eb dc                	jmp    800704 <vprintfmt+0x417>
	if (lflag >= 2)
  800728:	83 f9 01             	cmp    $0x1,%ecx
  80072b:	7e 15                	jle    800742 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	8b 48 04             	mov    0x4(%eax),%ecx
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073b:	b8 10 00 00 00       	mov    $0x10,%eax
  800740:	eb a5                	jmp    8006e7 <vprintfmt+0x3fa>
	else if (lflag)
  800742:	85 c9                	test   %ecx,%ecx
  800744:	75 17                	jne    80075d <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800756:	b8 10 00 00 00       	mov    $0x10,%eax
  80075b:	eb 8a                	jmp    8006e7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	b9 00 00 00 00       	mov    $0x0,%ecx
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	b8 10 00 00 00       	mov    $0x10,%eax
  800772:	e9 70 ff ff ff       	jmp    8006e7 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	53                   	push   %ebx
  80077b:	6a 25                	push   $0x25
  80077d:	ff d6                	call   *%esi
			break;
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	e9 7a ff ff ff       	jmp    800701 <vprintfmt+0x414>
			putch('%', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	53                   	push   %ebx
  80078b:	6a 25                	push   $0x25
  80078d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	89 f8                	mov    %edi,%eax
  800794:	eb 03                	jmp    800799 <vprintfmt+0x4ac>
  800796:	83 e8 01             	sub    $0x1,%eax
  800799:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80079d:	75 f7                	jne    800796 <vprintfmt+0x4a9>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a2:	e9 5a ff ff ff       	jmp    800701 <vprintfmt+0x414>
}
  8007a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5f                   	pop    %edi
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 18             	sub    $0x18,%esp
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007be:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	74 26                	je     8007f6 <vsnprintf+0x47>
  8007d0:	85 d2                	test   %edx,%edx
  8007d2:	7e 22                	jle    8007f6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d4:	ff 75 14             	pushl  0x14(%ebp)
  8007d7:	ff 75 10             	pushl  0x10(%ebp)
  8007da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007dd:	50                   	push   %eax
  8007de:	68 b3 02 80 00       	push   $0x8002b3
  8007e3:	e8 05 fb ff ff       	call   8002ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
}
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    
		return -E_INVAL;
  8007f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fb:	eb f7                	jmp    8007f4 <vsnprintf+0x45>

008007fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800806:	50                   	push   %eax
  800807:	ff 75 10             	pushl  0x10(%ebp)
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 08             	pushl  0x8(%ebp)
  800810:	e8 9a ff ff ff       	call   8007af <vsnprintf>
	va_end(ap);

	return rc;
}
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081d:	b8 00 00 00 00       	mov    $0x0,%eax
  800822:	eb 03                	jmp    800827 <strlen+0x10>
		n++;
  800824:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800827:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082b:	75 f7                	jne    800824 <strlen+0xd>
	return n;
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800835:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800838:	b8 00 00 00 00       	mov    $0x0,%eax
  80083d:	eb 03                	jmp    800842 <strnlen+0x13>
		n++;
  80083f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800842:	39 d0                	cmp    %edx,%eax
  800844:	74 06                	je     80084c <strnlen+0x1d>
  800846:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084a:	75 f3                	jne    80083f <strnlen+0x10>
	return n;
}
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800858:	89 c2                	mov    %eax,%edx
  80085a:	83 c1 01             	add    $0x1,%ecx
  80085d:	83 c2 01             	add    $0x1,%edx
  800860:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800864:	88 5a ff             	mov    %bl,-0x1(%edx)
  800867:	84 db                	test   %bl,%bl
  800869:	75 ef                	jne    80085a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80086b:	5b                   	pop    %ebx
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	53                   	push   %ebx
  800872:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800875:	53                   	push   %ebx
  800876:	e8 9c ff ff ff       	call   800817 <strlen>
  80087b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	01 d8                	add    %ebx,%eax
  800883:	50                   	push   %eax
  800884:	e8 c5 ff ff ff       	call   80084e <strcpy>
	return dst;
}
  800889:	89 d8                	mov    %ebx,%eax
  80088b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	56                   	push   %esi
  800894:	53                   	push   %ebx
  800895:	8b 75 08             	mov    0x8(%ebp),%esi
  800898:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089b:	89 f3                	mov    %esi,%ebx
  80089d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a0:	89 f2                	mov    %esi,%edx
  8008a2:	eb 0f                	jmp    8008b3 <strncpy+0x23>
		*dst++ = *src;
  8008a4:	83 c2 01             	add    $0x1,%edx
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ad:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b3:	39 da                	cmp    %ebx,%edx
  8008b5:	75 ed                	jne    8008a4 <strncpy+0x14>
	}
	return ret;
}
  8008b7:	89 f0                	mov    %esi,%eax
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
  8008c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008cb:	89 f0                	mov    %esi,%eax
  8008cd:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d1:	85 c9                	test   %ecx,%ecx
  8008d3:	75 0b                	jne    8008e0 <strlcpy+0x23>
  8008d5:	eb 17                	jmp    8008ee <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	83 c0 01             	add    $0x1,%eax
  8008dd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008e0:	39 d8                	cmp    %ebx,%eax
  8008e2:	74 07                	je     8008eb <strlcpy+0x2e>
  8008e4:	0f b6 0a             	movzbl (%edx),%ecx
  8008e7:	84 c9                	test   %cl,%cl
  8008e9:	75 ec                	jne    8008d7 <strlcpy+0x1a>
		*dst = '\0';
  8008eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ee:	29 f0                	sub    %esi,%eax
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fd:	eb 06                	jmp    800905 <strcmp+0x11>
		p++, q++;
  8008ff:	83 c1 01             	add    $0x1,%ecx
  800902:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800905:	0f b6 01             	movzbl (%ecx),%eax
  800908:	84 c0                	test   %al,%al
  80090a:	74 04                	je     800910 <strcmp+0x1c>
  80090c:	3a 02                	cmp    (%edx),%al
  80090e:	74 ef                	je     8008ff <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800910:	0f b6 c0             	movzbl %al,%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
  800924:	89 c3                	mov    %eax,%ebx
  800926:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800929:	eb 06                	jmp    800931 <strncmp+0x17>
		n--, p++, q++;
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800931:	39 d8                	cmp    %ebx,%eax
  800933:	74 16                	je     80094b <strncmp+0x31>
  800935:	0f b6 08             	movzbl (%eax),%ecx
  800938:	84 c9                	test   %cl,%cl
  80093a:	74 04                	je     800940 <strncmp+0x26>
  80093c:	3a 0a                	cmp    (%edx),%cl
  80093e:	74 eb                	je     80092b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800940:	0f b6 00             	movzbl (%eax),%eax
  800943:	0f b6 12             	movzbl (%edx),%edx
  800946:	29 d0                	sub    %edx,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    
		return 0;
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	eb f6                	jmp    800948 <strncmp+0x2e>

00800952 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095c:	0f b6 10             	movzbl (%eax),%edx
  80095f:	84 d2                	test   %dl,%dl
  800961:	74 09                	je     80096c <strchr+0x1a>
		if (*s == c)
  800963:	38 ca                	cmp    %cl,%dl
  800965:	74 0a                	je     800971 <strchr+0x1f>
	for (; *s; s++)
  800967:	83 c0 01             	add    $0x1,%eax
  80096a:	eb f0                	jmp    80095c <strchr+0xa>
			return (char *) s;
	return 0;
  80096c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097d:	eb 03                	jmp    800982 <strfind+0xf>
  80097f:	83 c0 01             	add    $0x1,%eax
  800982:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800985:	38 ca                	cmp    %cl,%dl
  800987:	74 04                	je     80098d <strfind+0x1a>
  800989:	84 d2                	test   %dl,%dl
  80098b:	75 f2                	jne    80097f <strfind+0xc>
			break;
	return (char *) s;
}
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	57                   	push   %edi
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 7d 08             	mov    0x8(%ebp),%edi
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099b:	85 c9                	test   %ecx,%ecx
  80099d:	74 13                	je     8009b2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a5:	75 05                	jne    8009ac <memset+0x1d>
  8009a7:	f6 c1 03             	test   $0x3,%cl
  8009aa:	74 0d                	je     8009b9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009af:	fc                   	cld    
  8009b0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b2:	89 f8                	mov    %edi,%eax
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5f                   	pop    %edi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
		c &= 0xFF;
  8009b9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009bd:	89 d3                	mov    %edx,%ebx
  8009bf:	c1 e3 08             	shl    $0x8,%ebx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 18             	shl    $0x18,%eax
  8009c7:	89 d6                	mov    %edx,%esi
  8009c9:	c1 e6 10             	shl    $0x10,%esi
  8009cc:	09 f0                	or     %esi,%eax
  8009ce:	09 c2                	or     %eax,%edx
  8009d0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d5:	89 d0                	mov    %edx,%eax
  8009d7:	fc                   	cld    
  8009d8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009da:	eb d6                	jmp    8009b2 <memset+0x23>

008009dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	57                   	push   %edi
  8009e0:	56                   	push   %esi
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ea:	39 c6                	cmp    %eax,%esi
  8009ec:	73 35                	jae    800a23 <memmove+0x47>
  8009ee:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f1:	39 c2                	cmp    %eax,%edx
  8009f3:	76 2e                	jbe    800a23 <memmove+0x47>
		s += n;
		d += n;
  8009f5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f8:	89 d6                	mov    %edx,%esi
  8009fa:	09 fe                	or     %edi,%esi
  8009fc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a02:	74 0c                	je     800a10 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a04:	83 ef 01             	sub    $0x1,%edi
  800a07:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0a:	fd                   	std    
  800a0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0d:	fc                   	cld    
  800a0e:	eb 21                	jmp    800a31 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a10:	f6 c1 03             	test   $0x3,%cl
  800a13:	75 ef                	jne    800a04 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a15:	83 ef 04             	sub    $0x4,%edi
  800a18:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1e:	fd                   	std    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb ea                	jmp    800a0d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a23:	89 f2                	mov    %esi,%edx
  800a25:	09 c2                	or     %eax,%edx
  800a27:	f6 c2 03             	test   $0x3,%dl
  800a2a:	74 09                	je     800a35 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a2c:	89 c7                	mov    %eax,%edi
  800a2e:	fc                   	cld    
  800a2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a31:	5e                   	pop    %esi
  800a32:	5f                   	pop    %edi
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a35:	f6 c1 03             	test   $0x3,%cl
  800a38:	75 f2                	jne    800a2c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3d:	89 c7                	mov    %eax,%edi
  800a3f:	fc                   	cld    
  800a40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a42:	eb ed                	jmp    800a31 <memmove+0x55>

00800a44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a47:	ff 75 10             	pushl  0x10(%ebp)
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	ff 75 08             	pushl  0x8(%ebp)
  800a50:	e8 87 ff ff ff       	call   8009dc <memmove>
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a62:	89 c6                	mov    %eax,%esi
  800a64:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a67:	39 f0                	cmp    %esi,%eax
  800a69:	74 1c                	je     800a87 <memcmp+0x30>
		if (*s1 != *s2)
  800a6b:	0f b6 08             	movzbl (%eax),%ecx
  800a6e:	0f b6 1a             	movzbl (%edx),%ebx
  800a71:	38 d9                	cmp    %bl,%cl
  800a73:	75 08                	jne    800a7d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	eb ea                	jmp    800a67 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a7d:	0f b6 c1             	movzbl %cl,%eax
  800a80:	0f b6 db             	movzbl %bl,%ebx
  800a83:	29 d8                	sub    %ebx,%eax
  800a85:	eb 05                	jmp    800a8c <memcmp+0x35>
	}

	return 0;
  800a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8c:	5b                   	pop    %ebx
  800a8d:	5e                   	pop    %esi
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9e:	39 d0                	cmp    %edx,%eax
  800aa0:	73 09                	jae    800aab <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa2:	38 08                	cmp    %cl,(%eax)
  800aa4:	74 05                	je     800aab <memfind+0x1b>
	for (; s < ends; s++)
  800aa6:	83 c0 01             	add    $0x1,%eax
  800aa9:	eb f3                	jmp    800a9e <memfind+0xe>
			break;
	return (void *) s;
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	57                   	push   %edi
  800ab1:	56                   	push   %esi
  800ab2:	53                   	push   %ebx
  800ab3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab9:	eb 03                	jmp    800abe <strtol+0x11>
		s++;
  800abb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abe:	0f b6 01             	movzbl (%ecx),%eax
  800ac1:	3c 20                	cmp    $0x20,%al
  800ac3:	74 f6                	je     800abb <strtol+0xe>
  800ac5:	3c 09                	cmp    $0x9,%al
  800ac7:	74 f2                	je     800abb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac9:	3c 2b                	cmp    $0x2b,%al
  800acb:	74 2e                	je     800afb <strtol+0x4e>
	int neg = 0;
  800acd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad2:	3c 2d                	cmp    $0x2d,%al
  800ad4:	74 2f                	je     800b05 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800adc:	75 05                	jne    800ae3 <strtol+0x36>
  800ade:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae1:	74 2c                	je     800b0f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae3:	85 db                	test   %ebx,%ebx
  800ae5:	75 0a                	jne    800af1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aec:	80 39 30             	cmpb   $0x30,(%ecx)
  800aef:	74 28                	je     800b19 <strtol+0x6c>
		base = 10;
  800af1:	b8 00 00 00 00       	mov    $0x0,%eax
  800af6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af9:	eb 50                	jmp    800b4b <strtol+0x9e>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afe:	bf 00 00 00 00       	mov    $0x0,%edi
  800b03:	eb d1                	jmp    800ad6 <strtol+0x29>
		s++, neg = 1;
  800b05:	83 c1 01             	add    $0x1,%ecx
  800b08:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0d:	eb c7                	jmp    800ad6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b13:	74 0e                	je     800b23 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b15:	85 db                	test   %ebx,%ebx
  800b17:	75 d8                	jne    800af1 <strtol+0x44>
		s++, base = 8;
  800b19:	83 c1 01             	add    $0x1,%ecx
  800b1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b21:	eb ce                	jmp    800af1 <strtol+0x44>
		s += 2, base = 16;
  800b23:	83 c1 02             	add    $0x2,%ecx
  800b26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b2b:	eb c4                	jmp    800af1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b2d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b30:	89 f3                	mov    %esi,%ebx
  800b32:	80 fb 19             	cmp    $0x19,%bl
  800b35:	77 29                	ja     800b60 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b37:	0f be d2             	movsbl %dl,%edx
  800b3a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b3d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b40:	7d 30                	jge    800b72 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b42:	83 c1 01             	add    $0x1,%ecx
  800b45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b49:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b4b:	0f b6 11             	movzbl (%ecx),%edx
  800b4e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b51:	89 f3                	mov    %esi,%ebx
  800b53:	80 fb 09             	cmp    $0x9,%bl
  800b56:	77 d5                	ja     800b2d <strtol+0x80>
			dig = *s - '0';
  800b58:	0f be d2             	movsbl %dl,%edx
  800b5b:	83 ea 30             	sub    $0x30,%edx
  800b5e:	eb dd                	jmp    800b3d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b63:	89 f3                	mov    %esi,%ebx
  800b65:	80 fb 19             	cmp    $0x19,%bl
  800b68:	77 08                	ja     800b72 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b6a:	0f be d2             	movsbl %dl,%edx
  800b6d:	83 ea 37             	sub    $0x37,%edx
  800b70:	eb cb                	jmp    800b3d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 05                	je     800b7d <strtol+0xd0>
		*endptr = (char *) s;
  800b78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7d:	89 c2                	mov    %eax,%edx
  800b7f:	f7 da                	neg    %edx
  800b81:	85 ff                	test   %edi,%edi
  800b83:	0f 45 c2             	cmovne %edx,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5f                   	pop    %edi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	57                   	push   %edi
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	89 c6                	mov    %eax,%esi
  800ba2:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5f                   	pop    %edi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <sys_cgetc>:

int
sys_cgetc(void) {
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
    asm volatile("int %1\n"
  800baf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb9:	89 d1                	mov    %edx,%ecx
  800bbb:	89 d3                	mov    %edx,%ebx
  800bbd:	89 d7                	mov    %edx,%edi
  800bbf:	89 d6                	mov    %edx,%esi
  800bc1:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bde:	89 cb                	mov    %ecx,%ebx
  800be0:	89 cf                	mov    %ecx,%edi
  800be2:	89 ce                	mov    %ecx,%esi
  800be4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800be6:	85 c0                	test   %eax,%eax
  800be8:	7f 08                	jg     800bf2 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bf2:	83 ec 0c             	sub    $0xc,%esp
  800bf5:	50                   	push   %eax
  800bf6:	6a 03                	push   $0x3
  800bf8:	68 c4 16 80 00       	push   $0x8016c4
  800bfd:	6a 24                	push   $0x24
  800bff:	68 e1 16 80 00       	push   $0x8016e1
  800c04:	e8 fe 04 00 00       	call   801107 <_panic>

00800c09 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c14:	b8 02 00 00 00       	mov    $0x2,%eax
  800c19:	89 d1                	mov    %edx,%ecx
  800c1b:	89 d3                	mov    %edx,%ebx
  800c1d:	89 d7                	mov    %edx,%edi
  800c1f:	89 d6                	mov    %edx,%esi
  800c21:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <sys_yield>:

void
sys_yield(void)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c38:	89 d1                	mov    %edx,%ecx
  800c3a:	89 d3                	mov    %edx,%ebx
  800c3c:	89 d7                	mov    %edx,%edi
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c50:	be 00 00 00 00       	mov    $0x0,%esi
  800c55:	8b 55 08             	mov    0x8(%ebp),%edx
  800c58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c63:	89 f7                	mov    %esi,%edi
  800c65:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7f 08                	jg     800c73 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	50                   	push   %eax
  800c77:	6a 04                	push   $0x4
  800c79:	68 c4 16 80 00       	push   $0x8016c4
  800c7e:	6a 24                	push   $0x24
  800c80:	68 e1 16 80 00       	push   $0x8016e1
  800c85:	e8 7d 04 00 00       	call   801107 <_panic>

00800c8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca7:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7f 08                	jg     800cb5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cb5:	83 ec 0c             	sub    $0xc,%esp
  800cb8:	50                   	push   %eax
  800cb9:	6a 05                	push   $0x5
  800cbb:	68 c4 16 80 00       	push   $0x8016c4
  800cc0:	6a 24                	push   $0x24
  800cc2:	68 e1 16 80 00       	push   $0x8016e1
  800cc7:	e8 3b 04 00 00       	call   801107 <_panic>

00800ccc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce5:	89 df                	mov    %ebx,%edi
  800ce7:	89 de                	mov    %ebx,%esi
  800ce9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ceb:	85 c0                	test   %eax,%eax
  800ced:	7f 08                	jg     800cf7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cf7:	83 ec 0c             	sub    $0xc,%esp
  800cfa:	50                   	push   %eax
  800cfb:	6a 06                	push   $0x6
  800cfd:	68 c4 16 80 00       	push   $0x8016c4
  800d02:	6a 24                	push   $0x24
  800d04:	68 e1 16 80 00       	push   $0x8016e1
  800d09:	e8 f9 03 00 00       	call   801107 <_panic>

00800d0e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d22:	b8 08 00 00 00       	mov    $0x8,%eax
  800d27:	89 df                	mov    %ebx,%edi
  800d29:	89 de                	mov    %ebx,%esi
  800d2b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	7f 08                	jg     800d39 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	50                   	push   %eax
  800d3d:	6a 08                	push   $0x8
  800d3f:	68 c4 16 80 00       	push   $0x8016c4
  800d44:	6a 24                	push   $0x24
  800d46:	68 e1 16 80 00       	push   $0x8016e1
  800d4b:	e8 b7 03 00 00       	call   801107 <_panic>

00800d50 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d64:	b8 09 00 00 00       	mov    $0x9,%eax
  800d69:	89 df                	mov    %ebx,%edi
  800d6b:	89 de                	mov    %ebx,%esi
  800d6d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d6f:	85 c0                	test   %eax,%eax
  800d71:	7f 08                	jg     800d7b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d7b:	83 ec 0c             	sub    $0xc,%esp
  800d7e:	50                   	push   %eax
  800d7f:	6a 09                	push   $0x9
  800d81:	68 c4 16 80 00       	push   $0x8016c4
  800d86:	6a 24                	push   $0x24
  800d88:	68 e1 16 80 00       	push   $0x8016e1
  800d8d:	e8 75 03 00 00       	call   801107 <_panic>

00800d92 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da3:	be 00 00 00 00       	mov    $0x0,%esi
  800da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dab:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dae:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcb:	89 cb                	mov    %ecx,%ebx
  800dcd:	89 cf                	mov    %ecx,%edi
  800dcf:	89 ce                	mov    %ecx,%esi
  800dd1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 0c                	push   $0xc
  800de5:	68 c4 16 80 00       	push   $0x8016c4
  800dea:	6a 24                	push   $0x24
  800dec:	68 e1 16 80 00       	push   $0x8016e1
  800df1:	e8 11 03 00 00       	call   801107 <_panic>

00800df6 <pgfault>:
//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf) {
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 04             	sub    $0x4,%esp
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
//    cprintf("in pgfault,,, utf->utf_fault_va:0x%x\n", *((uintptr_t *)(utf)));

    void *addr = (void *) (utf->utf_fault_va);
  800e00:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800e02:	8b 40 04             	mov    0x4(%eax),%eax
    int r;

//    cprintf("addr:0x%x\terr:%d\n", addr, err);

    extern volatile pte_t uvpt[];
    if ((err & FEC_WR) != FEC_WR || ((uvpt[(uintptr_t) addr / PGSIZE] & PTE_COW) != PTE_COW)) {
  800e05:	a8 02                	test   $0x2,%al
  800e07:	74 68                	je     800e71 <pgfault+0x7b>
  800e09:	89 da                	mov    %ebx,%edx
  800e0b:	c1 ea 0c             	shr    $0xc,%edx
  800e0e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e15:	f6 c6 08             	test   $0x8,%dh
  800e18:	74 57                	je     800e71 <pgfault+0x7b>
    // Hint:
    //   Use the read-only page table mappings at uvpt
    //   (see <inc/memlayout.h>).

    // LAB 4: Your code here.
    sys_page_alloc(0, (void *) PFTEMP, PTE_W | PTE_U | PTE_P);
  800e1a:	83 ec 04             	sub    $0x4,%esp
  800e1d:	6a 07                	push   $0x7
  800e1f:	68 00 f0 7f 00       	push   $0x7ff000
  800e24:	6a 00                	push   $0x0
  800e26:	e8 1c fe ff ff       	call   800c47 <sys_page_alloc>
    memmove((void *) PFTEMP, (void *) (ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  800e2b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800e31:	83 c4 0c             	add    $0xc,%esp
  800e34:	68 00 10 00 00       	push   $0x1000
  800e39:	53                   	push   %ebx
  800e3a:	68 00 f0 7f 00       	push   $0x7ff000
  800e3f:	e8 98 fb ff ff       	call   8009dc <memmove>

    //restore another
//    sys_page_map(0, (void *) (ROUNDDOWN(addr, PGSIZE)), 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);

    sys_page_map(0, (void *) PFTEMP, 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800e44:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e4b:	53                   	push   %ebx
  800e4c:	6a 00                	push   $0x0
  800e4e:	68 00 f0 7f 00       	push   $0x7ff000
  800e53:	6a 00                	push   $0x0
  800e55:	e8 30 fe ff ff       	call   800c8a <sys_page_map>
    sys_page_unmap(0, (void *) PFTEMP);
  800e5a:	83 c4 18             	add    $0x18,%esp
  800e5d:	68 00 f0 7f 00       	push   $0x7ff000
  800e62:	6a 00                	push   $0x0
  800e64:	e8 63 fe ff ff       	call   800ccc <sys_page_unmap>

    return;
  800e69:	83 c4 10             	add    $0x10,%esp
    //   You should make three system calls.

    // LAB 4: Your code here.

    panic("pgfault not implemented");
}
  800e6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    
        cprintf("utf->utf_fault_va:0x%x\tutf->utf_err:%d\n", addr, err);
  800e71:	83 ec 04             	sub    $0x4,%esp
  800e74:	50                   	push   %eax
  800e75:	53                   	push   %ebx
  800e76:	68 f0 16 80 00       	push   $0x8016f0
  800e7b:	e8 70 f3 ff ff       	call   8001f0 <cprintf>
        panic("pgfault is not a FEC_WR or is not to a COW page");
  800e80:	83 c4 0c             	add    $0xc,%esp
  800e83:	68 18 17 80 00       	push   $0x801718
  800e88:	6a 1b                	push   $0x1b
  800e8a:	68 48 17 80 00       	push   $0x801748
  800e8f:	e8 73 02 00 00       	call   801107 <_panic>

00800e94 <fork>:
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void) {
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
  800e9a:	83 ec 28             	sub    $0x28,%esp
    extern void* _pgfault_upcall(void);
    //1. The parent installs pgfault() as the C-level page fault handler, using the set_pgfault_handler() function you implemented above.
    set_pgfault_handler(pgfault);
  800e9d:	68 f6 0d 80 00       	push   $0x800df6
  800ea2:	e8 a6 02 00 00       	call   80114d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ea7:	b8 07 00 00 00       	mov    $0x7,%eax
  800eac:	cd 30                	int    $0x30
  800eae:	89 c6                	mov    %eax,%esi
  800eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    //2. The parent calls sys_exofork() to create a child environment.
    envid_t envid = sys_exofork();

//    cprintf("envid:0x%x\n", envid);
    if (envid == 0) {
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	74 5e                	je     800f18 <fork+0x84>

    extern volatile pde_t uvpd[];
    extern volatile pte_t uvpt[];

    //allocate and copy a normal stack
    sys_page_alloc(envid, (void *) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	6a 07                	push   $0x7
  800ebf:	68 00 d0 bf ee       	push   $0xeebfd000
  800ec4:	50                   	push   %eax
  800ec5:	e8 7d fd ff ff       	call   800c47 <sys_page_alloc>
    sys_page_map(envid, (void *) (USTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  800eca:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ed1:	68 00 00 40 00       	push   $0x400000
  800ed6:	6a 00                	push   $0x0
  800ed8:	68 00 d0 bf ee       	push   $0xeebfd000
  800edd:	56                   	push   %esi
  800ede:	e8 a7 fd ff ff       	call   800c8a <sys_page_map>
    memmove(UTEMP, (void *) (USTACKTOP - PGSIZE), PGSIZE);
  800ee3:	83 c4 1c             	add    $0x1c,%esp
  800ee6:	68 00 10 00 00       	push   $0x1000
  800eeb:	68 00 d0 bf ee       	push   $0xeebfd000
  800ef0:	68 00 00 40 00       	push   $0x400000
  800ef5:	e8 e2 fa ff ff       	call   8009dc <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  800efa:	83 c4 08             	add    $0x8,%esp
  800efd:	68 00 00 40 00       	push   $0x400000
  800f02:	6a 00                	push   $0x0
  800f04:	e8 c3 fd ff ff       	call   800ccc <sys_page_unmap>
  800f09:	83 c4 10             	add    $0x10,%esp

    int i;

//    cprintf("COW page resolve ....\n");
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
  800f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f11:	bf 00 00 00 00       	mov    $0x0,%edi
  800f16:	eb 2e                	jmp    800f46 <fork+0xb2>
        thisenv = &envs[sys_getenvid()];
  800f18:	e8 ec fc ff ff       	call   800c09 <sys_getenvid>
  800f1d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f20:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f25:	a3 08 20 80 00       	mov    %eax,0x802008
        return 0;
  800f2a:	e9 4d 01 00 00       	jmp    80107c <fork+0x1e8>
        if (uvpd[i / NPTENTRIES] == 0) {
            i += 1023;
  800f2f:	81 c3 ff 03 00 00    	add    $0x3ff,%ebx
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
  800f35:	83 c3 01             	add    $0x1,%ebx
  800f38:	89 df                	mov    %ebx,%edi
  800f3a:	81 fb fc eb 0e 00    	cmp    $0xeebfc,%ebx
  800f40:	0f 87 cb 00 00 00    	ja     801011 <fork+0x17d>
        if (uvpd[i / NPTENTRIES] == 0) {
  800f46:	8d 83 ff 03 00 00    	lea    0x3ff(%ebx),%eax
  800f4c:	85 db                	test   %ebx,%ebx
  800f4e:	0f 49 c3             	cmovns %ebx,%eax
  800f51:	c1 f8 0a             	sar    $0xa,%eax
  800f54:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	74 d0                	je     800f2f <fork+0x9b>
            continue;
        }

        if ((uvpt[i] & PTE_P) == PTE_P) {
  800f5f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f66:	a8 01                	test   $0x1,%al
  800f68:	74 cb                	je     800f35 <fork+0xa1>
            if (((uvpt[i] & PTE_W) == PTE_W) || ((uvpt[i] & PTE_COW) == PTE_COW)) {
  800f6a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f71:	a8 02                	test   $0x2,%al
  800f73:	75 0c                	jne    800f81 <fork+0xed>
  800f75:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f7c:	f6 c4 08             	test   $0x8,%ah
  800f7f:	74 64                	je     800fe5 <fork+0x151>
    if (sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800f81:	c1 e7 0c             	shl    $0xc,%edi
  800f84:	83 ec 0c             	sub    $0xc,%esp
  800f87:	68 05 08 00 00       	push   $0x805
  800f8c:	57                   	push   %edi
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	57                   	push   %edi
  800f91:	6a 00                	push   $0x0
  800f93:	e8 f2 fc ff ff       	call   800c8a <sys_page_map>
  800f98:	83 c4 20             	add    $0x20,%esp
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	78 32                	js     800fd1 <fork+0x13d>
    if (sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	68 05 08 00 00       	push   $0x805
  800fa7:	57                   	push   %edi
  800fa8:	6a 00                	push   $0x0
  800faa:	57                   	push   %edi
  800fab:	6a 00                	push   $0x0
  800fad:	e8 d8 fc ff ff       	call   800c8a <sys_page_map>
  800fb2:	83 c4 20             	add    $0x20,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	0f 89 78 ff ff ff    	jns    800f35 <fork+0xa1>
        panic("dupppage target map error");
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	68 6e 17 80 00       	push   $0x80176e
  800fc5:	6a 55                	push   $0x55
  800fc7:	68 48 17 80 00       	push   $0x801748
  800fcc:	e8 36 01 00 00       	call   801107 <_panic>
        panic("dupppage our own map error");
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	68 53 17 80 00       	push   $0x801753
  800fd9:	6a 4b                	push   $0x4b
  800fdb:	68 48 17 80 00       	push   $0x801748
  800fe0:	e8 22 01 00 00       	call   801107 <_panic>
                duppage(envid, i);
            } else {
                sys_page_map(0, (void *) (i * PGSIZE), envid, (void *) (i * PGSIZE), PTE_SHARE | (uvpt[i] & 0x3ff));
  800fe5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fec:	89 da                	mov    %ebx,%edx
  800fee:	c1 e2 0c             	shl    $0xc,%edx
  800ff1:	83 ec 0c             	sub    $0xc,%esp
  800ff4:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ff9:	80 cc 04             	or     $0x4,%ah
  800ffc:	50                   	push   %eax
  800ffd:	52                   	push   %edx
  800ffe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801001:	52                   	push   %edx
  801002:	6a 00                	push   $0x0
  801004:	e8 81 fc ff ff       	call   800c8a <sys_page_map>
  801009:	83 c4 20             	add    $0x20,%esp
  80100c:	e9 24 ff ff ff       	jmp    800f35 <fork+0xa1>
            }
        }
    }

//    cprintf("allocate child ExceptionStack ....\n");
    sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	6a 07                	push   $0x7
  801016:	68 00 f0 bf ee       	push   $0xeebff000
  80101b:	56                   	push   %esi
  80101c:	e8 26 fc ff ff       	call   800c47 <sys_page_alloc>
    sys_page_map(envid, (void *) (UXSTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  801021:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801028:	68 00 00 40 00       	push   $0x400000
  80102d:	6a 00                	push   $0x0
  80102f:	68 00 f0 bf ee       	push   $0xeebff000
  801034:	56                   	push   %esi
  801035:	e8 50 fc ff ff       	call   800c8a <sys_page_map>
    memmove(UTEMP, (void *) (UXSTACKTOP - PGSIZE), PGSIZE);
  80103a:	83 c4 1c             	add    $0x1c,%esp
  80103d:	68 00 10 00 00       	push   $0x1000
  801042:	68 00 f0 bf ee       	push   $0xeebff000
  801047:	68 00 00 40 00       	push   $0x400000
  80104c:	e8 8b f9 ff ff       	call   8009dc <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  801051:	83 c4 08             	add    $0x8,%esp
  801054:	68 00 00 40 00       	push   $0x400000
  801059:	6a 00                	push   $0x0
  80105b:	e8 6c fc ff ff       	call   800ccc <sys_page_unmap>

    //4. The parent sets the user page fault entrypoint for the child to look like its own.
//    set_pgfault_handler(pgfault);
//    cprintf("sys_env_set_pgfault_upcall(envid, pgfault) ....\n");
//    sys_env_set_pgfault_upcall(envid, pgfault);
    sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801060:	83 c4 08             	add    $0x8,%esp
  801063:	68 a3 11 80 00       	push   $0x8011a3
  801068:	56                   	push   %esi
  801069:	e8 e2 fc ff ff       	call   800d50 <sys_env_set_pgfault_upcall>

    //5. The child is now ready to run, so the parent marks it runnable.
//    cprintf("sys_env_set_status(envid, ENV_RUNNABLE) ....\n");
    sys_env_set_status(envid, ENV_RUNNABLE);
  80106e:	83 c4 08             	add    $0x8,%esp
  801071:	6a 02                	push   $0x2
  801073:	56                   	push   %esi
  801074:	e8 95 fc ff ff       	call   800d0e <sys_env_set_status>


    return envid;
  801079:	83 c4 10             	add    $0x10,%esp
    panic("fork not implemented");
}
  80107c:	89 f0                	mov    %esi,%eax
  80107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <sfork>:

// Challenge!
int
sfork(void) {
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 0c             	sub    $0xc,%esp
    panic("sfork not implemented");
  80108c:	68 88 17 80 00       	push   $0x801788
  801091:	68 bf 00 00 00       	push   $0xbf
  801096:	68 48 17 80 00       	push   $0x801748
  80109b:	e8 67 00 00 00       	call   801107 <_panic>

008010a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  8010a6:	68 9e 17 80 00       	push   $0x80179e
  8010ab:	6a 1a                	push   $0x1a
  8010ad:	68 b7 17 80 00       	push   $0x8017b7
  8010b2:	e8 50 00 00 00       	call   801107 <_panic>

008010b7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8010bd:	68 c1 17 80 00       	push   $0x8017c1
  8010c2:	6a 2a                	push   $0x2a
  8010c4:	68 b7 17 80 00       	push   $0x8017b7
  8010c9:	e8 39 00 00 00       	call   801107 <_panic>

008010ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8010d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8010d9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8010dc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8010e2:	8b 52 50             	mov    0x50(%edx),%edx
  8010e5:	39 ca                	cmp    %ecx,%edx
  8010e7:	74 11                	je     8010fa <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8010e9:	83 c0 01             	add    $0x1,%eax
  8010ec:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010f1:	75 e6                	jne    8010d9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	eb 0b                	jmp    801105 <ipc_find_env+0x37>
			return envs[i].env_id;
  8010fa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010fd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801102:	8b 40 48             	mov    0x48(%eax),%eax
}
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	56                   	push   %esi
  80110b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80110c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80110f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801115:	e8 ef fa ff ff       	call   800c09 <sys_getenvid>
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	ff 75 08             	pushl  0x8(%ebp)
  801123:	56                   	push   %esi
  801124:	50                   	push   %eax
  801125:	68 dc 17 80 00       	push   $0x8017dc
  80112a:	e8 c1 f0 ff ff       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80112f:	83 c4 18             	add    $0x18,%esp
  801132:	53                   	push   %ebx
  801133:	ff 75 10             	pushl  0x10(%ebp)
  801136:	e8 64 f0 ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  80113b:	c7 04 24 38 14 80 00 	movl   $0x801438,(%esp)
  801142:	e8 a9 f0 ff ff       	call   8001f0 <cprintf>
  801147:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80114a:	cc                   	int3   
  80114b:	eb fd                	jmp    80114a <_panic+0x43>

0080114d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801153:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  80115a:	74 0a                	je     801166 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  801166:	a1 08 20 80 00       	mov    0x802008,%eax
  80116b:	8b 40 48             	mov    0x48(%eax),%eax
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	6a 07                	push   $0x7
  801173:	68 00 f0 bf ee       	push   $0xeebff000
  801178:	25 ff 03 00 00       	and    $0x3ff,%eax
  80117d:	50                   	push   %eax
  80117e:	e8 c4 fa ff ff       	call   800c47 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  801183:	a1 08 20 80 00       	mov    0x802008,%eax
  801188:	8b 40 48             	mov    0x48(%eax),%eax
  80118b:	83 c4 08             	add    $0x8,%esp
  80118e:	68 a3 11 80 00       	push   $0x8011a3
  801193:	25 ff 03 00 00       	and    $0x3ff,%eax
  801198:	50                   	push   %eax
  801199:	e8 b2 fb ff ff       	call   800d50 <sys_env_set_pgfault_upcall>
  80119e:	83 c4 10             	add    $0x10,%esp
  8011a1:	eb b9                	jmp    80115c <set_pgfault_handler+0xf>

008011a3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011a3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011a4:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  8011a9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011ab:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  8011ae:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  8011b2:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  8011b6:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  8011b9:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  8011bb:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  8011bf:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  8011c2:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  8011c3:	83 c4 04             	add    $0x4,%esp
    popfl
  8011c6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  8011c7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8011c8:	c3                   	ret    
  8011c9:	66 90                	xchg   %ax,%ax
  8011cb:	66 90                	xchg   %ax,%ax
  8011cd:	66 90                	xchg   %ax,%ax
  8011cf:	90                   	nop

008011d0 <__udivdi3>:
  8011d0:	55                   	push   %ebp
  8011d1:	57                   	push   %edi
  8011d2:	56                   	push   %esi
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 1c             	sub    $0x1c,%esp
  8011d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8011db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8011df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8011e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 35                	jne    801220 <__udivdi3+0x50>
  8011eb:	39 f3                	cmp    %esi,%ebx
  8011ed:	0f 87 bd 00 00 00    	ja     8012b0 <__udivdi3+0xe0>
  8011f3:	85 db                	test   %ebx,%ebx
  8011f5:	89 d9                	mov    %ebx,%ecx
  8011f7:	75 0b                	jne    801204 <__udivdi3+0x34>
  8011f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011fe:	31 d2                	xor    %edx,%edx
  801200:	f7 f3                	div    %ebx
  801202:	89 c1                	mov    %eax,%ecx
  801204:	31 d2                	xor    %edx,%edx
  801206:	89 f0                	mov    %esi,%eax
  801208:	f7 f1                	div    %ecx
  80120a:	89 c6                	mov    %eax,%esi
  80120c:	89 e8                	mov    %ebp,%eax
  80120e:	89 f7                	mov    %esi,%edi
  801210:	f7 f1                	div    %ecx
  801212:	89 fa                	mov    %edi,%edx
  801214:	83 c4 1c             	add    $0x1c,%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    
  80121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801220:	39 f2                	cmp    %esi,%edx
  801222:	77 7c                	ja     8012a0 <__udivdi3+0xd0>
  801224:	0f bd fa             	bsr    %edx,%edi
  801227:	83 f7 1f             	xor    $0x1f,%edi
  80122a:	0f 84 98 00 00 00    	je     8012c8 <__udivdi3+0xf8>
  801230:	89 f9                	mov    %edi,%ecx
  801232:	b8 20 00 00 00       	mov    $0x20,%eax
  801237:	29 f8                	sub    %edi,%eax
  801239:	d3 e2                	shl    %cl,%edx
  80123b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80123f:	89 c1                	mov    %eax,%ecx
  801241:	89 da                	mov    %ebx,%edx
  801243:	d3 ea                	shr    %cl,%edx
  801245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801249:	09 d1                	or     %edx,%ecx
  80124b:	89 f2                	mov    %esi,%edx
  80124d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801251:	89 f9                	mov    %edi,%ecx
  801253:	d3 e3                	shl    %cl,%ebx
  801255:	89 c1                	mov    %eax,%ecx
  801257:	d3 ea                	shr    %cl,%edx
  801259:	89 f9                	mov    %edi,%ecx
  80125b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80125f:	d3 e6                	shl    %cl,%esi
  801261:	89 eb                	mov    %ebp,%ebx
  801263:	89 c1                	mov    %eax,%ecx
  801265:	d3 eb                	shr    %cl,%ebx
  801267:	09 de                	or     %ebx,%esi
  801269:	89 f0                	mov    %esi,%eax
  80126b:	f7 74 24 08          	divl   0x8(%esp)
  80126f:	89 d6                	mov    %edx,%esi
  801271:	89 c3                	mov    %eax,%ebx
  801273:	f7 64 24 0c          	mull   0xc(%esp)
  801277:	39 d6                	cmp    %edx,%esi
  801279:	72 0c                	jb     801287 <__udivdi3+0xb7>
  80127b:	89 f9                	mov    %edi,%ecx
  80127d:	d3 e5                	shl    %cl,%ebp
  80127f:	39 c5                	cmp    %eax,%ebp
  801281:	73 5d                	jae    8012e0 <__udivdi3+0x110>
  801283:	39 d6                	cmp    %edx,%esi
  801285:	75 59                	jne    8012e0 <__udivdi3+0x110>
  801287:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80128a:	31 ff                	xor    %edi,%edi
  80128c:	89 fa                	mov    %edi,%edx
  80128e:	83 c4 1c             	add    $0x1c,%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    
  801296:	8d 76 00             	lea    0x0(%esi),%esi
  801299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8012a0:	31 ff                	xor    %edi,%edi
  8012a2:	31 c0                	xor    %eax,%eax
  8012a4:	89 fa                	mov    %edi,%edx
  8012a6:	83 c4 1c             	add    $0x1c,%esp
  8012a9:	5b                   	pop    %ebx
  8012aa:	5e                   	pop    %esi
  8012ab:	5f                   	pop    %edi
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    
  8012ae:	66 90                	xchg   %ax,%ax
  8012b0:	31 ff                	xor    %edi,%edi
  8012b2:	89 e8                	mov    %ebp,%eax
  8012b4:	89 f2                	mov    %esi,%edx
  8012b6:	f7 f3                	div    %ebx
  8012b8:	89 fa                	mov    %edi,%edx
  8012ba:	83 c4 1c             	add    $0x1c,%esp
  8012bd:	5b                   	pop    %ebx
  8012be:	5e                   	pop    %esi
  8012bf:	5f                   	pop    %edi
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    
  8012c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012c8:	39 f2                	cmp    %esi,%edx
  8012ca:	72 06                	jb     8012d2 <__udivdi3+0x102>
  8012cc:	31 c0                	xor    %eax,%eax
  8012ce:	39 eb                	cmp    %ebp,%ebx
  8012d0:	77 d2                	ja     8012a4 <__udivdi3+0xd4>
  8012d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8012d7:	eb cb                	jmp    8012a4 <__udivdi3+0xd4>
  8012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012e0:	89 d8                	mov    %ebx,%eax
  8012e2:	31 ff                	xor    %edi,%edi
  8012e4:	eb be                	jmp    8012a4 <__udivdi3+0xd4>
  8012e6:	66 90                	xchg   %ax,%ax
  8012e8:	66 90                	xchg   %ax,%ax
  8012ea:	66 90                	xchg   %ax,%ax
  8012ec:	66 90                	xchg   %ax,%ax
  8012ee:	66 90                	xchg   %ax,%ax

008012f0 <__umoddi3>:
  8012f0:	55                   	push   %ebp
  8012f1:	57                   	push   %edi
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 1c             	sub    $0x1c,%esp
  8012f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8012fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801307:	85 ed                	test   %ebp,%ebp
  801309:	89 f0                	mov    %esi,%eax
  80130b:	89 da                	mov    %ebx,%edx
  80130d:	75 19                	jne    801328 <__umoddi3+0x38>
  80130f:	39 df                	cmp    %ebx,%edi
  801311:	0f 86 b1 00 00 00    	jbe    8013c8 <__umoddi3+0xd8>
  801317:	f7 f7                	div    %edi
  801319:	89 d0                	mov    %edx,%eax
  80131b:	31 d2                	xor    %edx,%edx
  80131d:	83 c4 1c             	add    $0x1c,%esp
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    
  801325:	8d 76 00             	lea    0x0(%esi),%esi
  801328:	39 dd                	cmp    %ebx,%ebp
  80132a:	77 f1                	ja     80131d <__umoddi3+0x2d>
  80132c:	0f bd cd             	bsr    %ebp,%ecx
  80132f:	83 f1 1f             	xor    $0x1f,%ecx
  801332:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801336:	0f 84 b4 00 00 00    	je     8013f0 <__umoddi3+0x100>
  80133c:	b8 20 00 00 00       	mov    $0x20,%eax
  801341:	89 c2                	mov    %eax,%edx
  801343:	8b 44 24 04          	mov    0x4(%esp),%eax
  801347:	29 c2                	sub    %eax,%edx
  801349:	89 c1                	mov    %eax,%ecx
  80134b:	89 f8                	mov    %edi,%eax
  80134d:	d3 e5                	shl    %cl,%ebp
  80134f:	89 d1                	mov    %edx,%ecx
  801351:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801355:	d3 e8                	shr    %cl,%eax
  801357:	09 c5                	or     %eax,%ebp
  801359:	8b 44 24 04          	mov    0x4(%esp),%eax
  80135d:	89 c1                	mov    %eax,%ecx
  80135f:	d3 e7                	shl    %cl,%edi
  801361:	89 d1                	mov    %edx,%ecx
  801363:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801367:	89 df                	mov    %ebx,%edi
  801369:	d3 ef                	shr    %cl,%edi
  80136b:	89 c1                	mov    %eax,%ecx
  80136d:	89 f0                	mov    %esi,%eax
  80136f:	d3 e3                	shl    %cl,%ebx
  801371:	89 d1                	mov    %edx,%ecx
  801373:	89 fa                	mov    %edi,%edx
  801375:	d3 e8                	shr    %cl,%eax
  801377:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80137c:	09 d8                	or     %ebx,%eax
  80137e:	f7 f5                	div    %ebp
  801380:	d3 e6                	shl    %cl,%esi
  801382:	89 d1                	mov    %edx,%ecx
  801384:	f7 64 24 08          	mull   0x8(%esp)
  801388:	39 d1                	cmp    %edx,%ecx
  80138a:	89 c3                	mov    %eax,%ebx
  80138c:	89 d7                	mov    %edx,%edi
  80138e:	72 06                	jb     801396 <__umoddi3+0xa6>
  801390:	75 0e                	jne    8013a0 <__umoddi3+0xb0>
  801392:	39 c6                	cmp    %eax,%esi
  801394:	73 0a                	jae    8013a0 <__umoddi3+0xb0>
  801396:	2b 44 24 08          	sub    0x8(%esp),%eax
  80139a:	19 ea                	sbb    %ebp,%edx
  80139c:	89 d7                	mov    %edx,%edi
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	89 ca                	mov    %ecx,%edx
  8013a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8013a7:	29 de                	sub    %ebx,%esi
  8013a9:	19 fa                	sbb    %edi,%edx
  8013ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8013af:	89 d0                	mov    %edx,%eax
  8013b1:	d3 e0                	shl    %cl,%eax
  8013b3:	89 d9                	mov    %ebx,%ecx
  8013b5:	d3 ee                	shr    %cl,%esi
  8013b7:	d3 ea                	shr    %cl,%edx
  8013b9:	09 f0                	or     %esi,%eax
  8013bb:	83 c4 1c             	add    $0x1c,%esp
  8013be:	5b                   	pop    %ebx
  8013bf:	5e                   	pop    %esi
  8013c0:	5f                   	pop    %edi
  8013c1:	5d                   	pop    %ebp
  8013c2:	c3                   	ret    
  8013c3:	90                   	nop
  8013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013c8:	85 ff                	test   %edi,%edi
  8013ca:	89 f9                	mov    %edi,%ecx
  8013cc:	75 0b                	jne    8013d9 <__umoddi3+0xe9>
  8013ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8013d3:	31 d2                	xor    %edx,%edx
  8013d5:	f7 f7                	div    %edi
  8013d7:	89 c1                	mov    %eax,%ecx
  8013d9:	89 d8                	mov    %ebx,%eax
  8013db:	31 d2                	xor    %edx,%edx
  8013dd:	f7 f1                	div    %ecx
  8013df:	89 f0                	mov    %esi,%eax
  8013e1:	f7 f1                	div    %ecx
  8013e3:	e9 31 ff ff ff       	jmp    801319 <__umoddi3+0x29>
  8013e8:	90                   	nop
  8013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013f0:	39 dd                	cmp    %ebx,%ebp
  8013f2:	72 08                	jb     8013fc <__umoddi3+0x10c>
  8013f4:	39 f7                	cmp    %esi,%edi
  8013f6:	0f 87 21 ff ff ff    	ja     80131d <__umoddi3+0x2d>
  8013fc:	89 da                	mov    %ebx,%edx
  8013fe:	89 f0                	mov    %esi,%eax
  801400:	29 f8                	sub    %edi,%eax
  801402:	19 ea                	sbb    %ebp,%edx
  801404:	e9 14 ff ff ff       	jmp    80131d <__umoddi3+0x2d>
