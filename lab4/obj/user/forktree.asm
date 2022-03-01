
obj/user/forktree：     文件格式 elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 a7 0b 00 00       	call   800be9 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 a0 10 80 00       	push   $0x8010a0
  80004c:	e8 7f 01 00 00       	call   8001d0 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 74 07 00 00       	call   8007f7 <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 b1 10 80 00       	push   $0x8010b1
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 31 07 00 00       	call   8007dd <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 22 0d 00 00       	call   800dd6 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 60 00 00 00       	call   800129 <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 b0 10 80 00       	push   $0x8010b0
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 f6 0a 00 00       	call   800be9 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 b4 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80012f:	6a 00                	push   $0x0
  800131:	e8 72 0a 00 00       	call   800ba8 <sys_env_destroy>
}
  800136:	83 c4 10             	add    $0x10,%esp
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	53                   	push   %ebx
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800145:	8b 13                	mov    (%ebx),%edx
  800147:	8d 42 01             	lea    0x1(%edx),%eax
  80014a:	89 03                	mov    %eax,(%ebx)
  80014c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80014f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800153:	3d ff 00 00 00       	cmp    $0xff,%eax
  800158:	74 09                	je     800163 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800161:	c9                   	leave  
  800162:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800163:	83 ec 08             	sub    $0x8,%esp
  800166:	68 ff 00 00 00       	push   $0xff
  80016b:	8d 43 08             	lea    0x8(%ebx),%eax
  80016e:	50                   	push   %eax
  80016f:	e8 f7 09 00 00       	call   800b6b <sys_cputs>
		b->idx = 0;
  800174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	eb db                	jmp    80015a <putch+0x1f>

0080017f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800188:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80018f:	00 00 00 
	b.cnt = 0;
  800192:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800199:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019c:	ff 75 0c             	pushl  0xc(%ebp)
  80019f:	ff 75 08             	pushl  0x8(%ebp)
  8001a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	68 3b 01 80 00       	push   $0x80013b
  8001ae:	e8 1a 01 00 00       	call   8002cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b3:	83 c4 08             	add    $0x8,%esp
  8001b6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001bc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 a3 09 00 00       	call   800b6b <sys_cputs>

	return b.cnt;
}
  8001c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d9:	50                   	push   %eax
  8001da:	ff 75 08             	pushl  0x8(%ebp)
  8001dd:	e8 9d ff ff ff       	call   80017f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e2:	c9                   	leave  
  8001e3:	c3                   	ret    

008001e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	57                   	push   %edi
  8001e8:	56                   	push   %esi
  8001e9:	53                   	push   %ebx
  8001ea:	83 ec 1c             	sub    $0x1c,%esp
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 d6                	mov    %edx,%esi
  8001f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800200:	bb 00 00 00 00       	mov    $0x0,%ebx
  800205:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800208:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80020b:	39 d3                	cmp    %edx,%ebx
  80020d:	72 05                	jb     800214 <printnum+0x30>
  80020f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800212:	77 7a                	ja     80028e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	ff 75 18             	pushl  0x18(%ebp)
  80021a:	8b 45 14             	mov    0x14(%ebp),%eax
  80021d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800220:	53                   	push   %ebx
  800221:	ff 75 10             	pushl  0x10(%ebp)
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022a:	ff 75 e0             	pushl  -0x20(%ebp)
  80022d:	ff 75 dc             	pushl  -0x24(%ebp)
  800230:	ff 75 d8             	pushl  -0x28(%ebp)
  800233:	e8 18 0c 00 00       	call   800e50 <__udivdi3>
  800238:	83 c4 18             	add    $0x18,%esp
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	89 f2                	mov    %esi,%edx
  80023f:	89 f8                	mov    %edi,%eax
  800241:	e8 9e ff ff ff       	call   8001e4 <printnum>
  800246:	83 c4 20             	add    $0x20,%esp
  800249:	eb 13                	jmp    80025e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	56                   	push   %esi
  80024f:	ff 75 18             	pushl  0x18(%ebp)
  800252:	ff d7                	call   *%edi
  800254:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800257:	83 eb 01             	sub    $0x1,%ebx
  80025a:	85 db                	test   %ebx,%ebx
  80025c:	7f ed                	jg     80024b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	56                   	push   %esi
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 e4             	pushl  -0x1c(%ebp)
  800268:	ff 75 e0             	pushl  -0x20(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	ff 75 d8             	pushl  -0x28(%ebp)
  800271:	e8 fa 0c 00 00       	call   800f70 <__umoddi3>
  800276:	83 c4 14             	add    $0x14,%esp
  800279:	0f be 80 c0 10 80 00 	movsbl 0x8010c0(%eax),%eax
  800280:	50                   	push   %eax
  800281:	ff d7                	call   *%edi
}
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    
  80028e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800291:	eb c4                	jmp    800257 <printnum+0x73>

00800293 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800299:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029d:	8b 10                	mov    (%eax),%edx
  80029f:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a2:	73 0a                	jae    8002ae <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a7:	89 08                	mov    %ecx,(%eax)
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	88 02                	mov    %al,(%edx)
}
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <printfmt>:
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b9:	50                   	push   %eax
  8002ba:	ff 75 10             	pushl  0x10(%ebp)
  8002bd:	ff 75 0c             	pushl  0xc(%ebp)
  8002c0:	ff 75 08             	pushl  0x8(%ebp)
  8002c3:	e8 05 00 00 00       	call   8002cd <vprintfmt>
}
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	c9                   	leave  
  8002cc:	c3                   	ret    

008002cd <vprintfmt>:
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	57                   	push   %edi
  8002d1:	56                   	push   %esi
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 2c             	sub    $0x2c,%esp
  8002d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002df:	e9 00 04 00 00       	jmp    8006e4 <vprintfmt+0x417>
		padc = ' ';
  8002e4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002ef:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002fd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800302:	8d 47 01             	lea    0x1(%edi),%eax
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800308:	0f b6 17             	movzbl (%edi),%edx
  80030b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80030e:	3c 55                	cmp    $0x55,%al
  800310:	0f 87 51 04 00 00    	ja     800767 <vprintfmt+0x49a>
  800316:	0f b6 c0             	movzbl %al,%eax
  800319:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  800320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800323:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800327:	eb d9                	jmp    800302 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80032c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800330:	eb d0                	jmp    800302 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800332:	0f b6 d2             	movzbl %dl,%edx
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800340:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800343:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800347:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80034d:	83 f9 09             	cmp    $0x9,%ecx
  800350:	77 55                	ja     8003a7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800352:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800355:	eb e9                	jmp    800340 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8b 00                	mov    (%eax),%eax
  80035c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 40 04             	lea    0x4(%eax),%eax
  800365:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80036f:	79 91                	jns    800302 <vprintfmt+0x35>
				width = precision, precision = -1;
  800371:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800374:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800377:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80037e:	eb 82                	jmp    800302 <vprintfmt+0x35>
  800380:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800383:	85 c0                	test   %eax,%eax
  800385:	ba 00 00 00 00       	mov    $0x0,%edx
  80038a:	0f 49 d0             	cmovns %eax,%edx
  80038d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800393:	e9 6a ff ff ff       	jmp    800302 <vprintfmt+0x35>
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003a2:	e9 5b ff ff ff       	jmp    800302 <vprintfmt+0x35>
  8003a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ad:	eb bc                	jmp    80036b <vprintfmt+0x9e>
			lflag++;
  8003af:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b5:	e9 48 ff ff ff       	jmp    800302 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 78 04             	lea    0x4(%eax),%edi
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	53                   	push   %ebx
  8003c4:	ff 30                	pushl  (%eax)
  8003c6:	ff d6                	call   *%esi
			break;
  8003c8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ce:	e9 0e 03 00 00       	jmp    8006e1 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8d 78 04             	lea    0x4(%eax),%edi
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	99                   	cltd   
  8003dc:	31 d0                	xor    %edx,%eax
  8003de:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e0:	83 f8 08             	cmp    $0x8,%eax
  8003e3:	7f 23                	jg     800408 <vprintfmt+0x13b>
  8003e5:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  8003ec:	85 d2                	test   %edx,%edx
  8003ee:	74 18                	je     800408 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003f0:	52                   	push   %edx
  8003f1:	68 e1 10 80 00       	push   $0x8010e1
  8003f6:	53                   	push   %ebx
  8003f7:	56                   	push   %esi
  8003f8:	e8 b3 fe ff ff       	call   8002b0 <printfmt>
  8003fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800400:	89 7d 14             	mov    %edi,0x14(%ebp)
  800403:	e9 d9 02 00 00       	jmp    8006e1 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800408:	50                   	push   %eax
  800409:	68 d8 10 80 00       	push   $0x8010d8
  80040e:	53                   	push   %ebx
  80040f:	56                   	push   %esi
  800410:	e8 9b fe ff ff       	call   8002b0 <printfmt>
  800415:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800418:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041b:	e9 c1 02 00 00       	jmp    8006e1 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	83 c0 04             	add    $0x4,%eax
  800426:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800429:	8b 45 14             	mov    0x14(%ebp),%eax
  80042c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80042e:	85 ff                	test   %edi,%edi
  800430:	b8 d1 10 80 00       	mov    $0x8010d1,%eax
  800435:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800438:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043c:	0f 8e bd 00 00 00    	jle    8004ff <vprintfmt+0x232>
  800442:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800446:	75 0e                	jne    800456 <vprintfmt+0x189>
  800448:	89 75 08             	mov    %esi,0x8(%ebp)
  80044b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80044e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800451:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800454:	eb 6d                	jmp    8004c3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	ff 75 d0             	pushl  -0x30(%ebp)
  80045c:	57                   	push   %edi
  80045d:	e8 ad 03 00 00       	call   80080f <strnlen>
  800462:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800465:	29 c1                	sub    %eax,%ecx
  800467:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80046a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80046d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800471:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800474:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800477:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800479:	eb 0f                	jmp    80048a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	53                   	push   %ebx
  80047f:	ff 75 e0             	pushl  -0x20(%ebp)
  800482:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800484:	83 ef 01             	sub    $0x1,%edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 ff                	test   %edi,%edi
  80048c:	7f ed                	jg     80047b <vprintfmt+0x1ae>
  80048e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800491:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800494:	85 c9                	test   %ecx,%ecx
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	0f 49 c1             	cmovns %ecx,%eax
  80049e:	29 c1                	sub    %eax,%ecx
  8004a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a9:	89 cb                	mov    %ecx,%ebx
  8004ab:	eb 16                	jmp    8004c3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b1:	75 31                	jne    8004e4 <vprintfmt+0x217>
					putch(ch, putdat);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	ff 75 0c             	pushl  0xc(%ebp)
  8004b9:	50                   	push   %eax
  8004ba:	ff 55 08             	call   *0x8(%ebp)
  8004bd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c0:	83 eb 01             	sub    $0x1,%ebx
  8004c3:	83 c7 01             	add    $0x1,%edi
  8004c6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ca:	0f be c2             	movsbl %dl,%eax
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	74 59                	je     80052a <vprintfmt+0x25d>
  8004d1:	85 f6                	test   %esi,%esi
  8004d3:	78 d8                	js     8004ad <vprintfmt+0x1e0>
  8004d5:	83 ee 01             	sub    $0x1,%esi
  8004d8:	79 d3                	jns    8004ad <vprintfmt+0x1e0>
  8004da:	89 df                	mov    %ebx,%edi
  8004dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e2:	eb 37                	jmp    80051b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e4:	0f be d2             	movsbl %dl,%edx
  8004e7:	83 ea 20             	sub    $0x20,%edx
  8004ea:	83 fa 5e             	cmp    $0x5e,%edx
  8004ed:	76 c4                	jbe    8004b3 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 0c             	pushl  0xc(%ebp)
  8004f5:	6a 3f                	push   $0x3f
  8004f7:	ff 55 08             	call   *0x8(%ebp)
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	eb c1                	jmp    8004c0 <vprintfmt+0x1f3>
  8004ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800502:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800505:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800508:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80050b:	eb b6                	jmp    8004c3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	6a 20                	push   $0x20
  800513:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800515:	83 ef 01             	sub    $0x1,%edi
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	85 ff                	test   %edi,%edi
  80051d:	7f ee                	jg     80050d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80051f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800522:	89 45 14             	mov    %eax,0x14(%ebp)
  800525:	e9 b7 01 00 00       	jmp    8006e1 <vprintfmt+0x414>
  80052a:	89 df                	mov    %ebx,%edi
  80052c:	8b 75 08             	mov    0x8(%ebp),%esi
  80052f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800532:	eb e7                	jmp    80051b <vprintfmt+0x24e>
	if (lflag >= 2)
  800534:	83 f9 01             	cmp    $0x1,%ecx
  800537:	7e 3f                	jle    800578 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8b 50 04             	mov    0x4(%eax),%edx
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 08             	lea    0x8(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800550:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800554:	79 5c                	jns    8005b2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	53                   	push   %ebx
  80055a:	6a 2d                	push   $0x2d
  80055c:	ff d6                	call   *%esi
				num = -(long long) num;
  80055e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800561:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800564:	f7 da                	neg    %edx
  800566:	83 d1 00             	adc    $0x0,%ecx
  800569:	f7 d9                	neg    %ecx
  80056b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80056e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800573:	e9 4f 01 00 00       	jmp    8006c7 <vprintfmt+0x3fa>
	else if (lflag)
  800578:	85 c9                	test   %ecx,%ecx
  80057a:	75 1b                	jne    800597 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	89 c1                	mov    %eax,%ecx
  800586:	c1 f9 1f             	sar    $0x1f,%ecx
  800589:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb b9                	jmp    800550 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059f:	89 c1                	mov    %eax,%ecx
  8005a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 40 04             	lea    0x4(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	eb 9e                	jmp    800550 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bd:	e9 05 01 00 00       	jmp    8006c7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005c2:	83 f9 01             	cmp    $0x1,%ecx
  8005c5:	7e 18                	jle    8005df <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 10                	mov    (%eax),%edx
  8005cc:	8b 48 04             	mov    0x4(%eax),%ecx
  8005cf:	8d 40 08             	lea    0x8(%eax),%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005da:	e9 e8 00 00 00       	jmp    8006c7 <vprintfmt+0x3fa>
	else if (lflag)
  8005df:	85 c9                	test   %ecx,%ecx
  8005e1:	75 1a                	jne    8005fd <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 10                	mov    (%eax),%edx
  8005e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 ca 00 00 00       	jmp    8006c7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	b9 00 00 00 00       	mov    $0x0,%ecx
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800612:	e9 b0 00 00 00       	jmp    8006c7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800617:	83 f9 01             	cmp    $0x1,%ecx
  80061a:	7e 3c                	jle    800658 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 50 04             	mov    0x4(%eax),%edx
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800627:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 40 08             	lea    0x8(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800633:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800637:	79 59                	jns    800692 <vprintfmt+0x3c5>
                putch('-', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 2d                	push   $0x2d
  80063f:	ff d6                	call   *%esi
                num = -(long long) num;
  800641:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800644:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800647:	f7 da                	neg    %edx
  800649:	83 d1 00             	adc    $0x0,%ecx
  80064c:	f7 d9                	neg    %ecx
  80064e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800651:	b8 08 00 00 00       	mov    $0x8,%eax
  800656:	eb 6f                	jmp    8006c7 <vprintfmt+0x3fa>
	else if (lflag)
  800658:	85 c9                	test   %ecx,%ecx
  80065a:	75 1b                	jne    800677 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 c1                	mov    %eax,%ecx
  800666:	c1 f9 1f             	sar    $0x1f,%ecx
  800669:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 40 04             	lea    0x4(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	eb bc                	jmp    800633 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 c1                	mov    %eax,%ecx
  800681:	c1 f9 1f             	sar    $0x1f,%ecx
  800684:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
  800690:	eb a1                	jmp    800633 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800692:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800695:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800698:	b8 08 00 00 00       	mov    $0x8,%eax
  80069d:	eb 28                	jmp    8006c7 <vprintfmt+0x3fa>
			putch('0', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	53                   	push   %ebx
  8006a3:	6a 30                	push   $0x30
  8006a5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a7:	83 c4 08             	add    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 78                	push   $0x78
  8006ad:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 10                	mov    (%eax),%edx
  8006b4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ce:	57                   	push   %edi
  8006cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	89 da                	mov    %ebx,%edx
  8006d7:	89 f0                	mov    %esi,%eax
  8006d9:	e8 06 fb ff ff       	call   8001e4 <printnum>
			break;
  8006de:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e4:	83 c7 01             	add    $0x1,%edi
  8006e7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006eb:	83 f8 25             	cmp    $0x25,%eax
  8006ee:	0f 84 f0 fb ff ff    	je     8002e4 <vprintfmt+0x17>
			if (ch == '\0')
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	0f 84 8b 00 00 00    	je     800787 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	53                   	push   %ebx
  800700:	50                   	push   %eax
  800701:	ff d6                	call   *%esi
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	eb dc                	jmp    8006e4 <vprintfmt+0x417>
	if (lflag >= 2)
  800708:	83 f9 01             	cmp    $0x1,%ecx
  80070b:	7e 15                	jle    800722 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 10                	mov    (%eax),%edx
  800712:	8b 48 04             	mov    0x4(%eax),%ecx
  800715:	8d 40 08             	lea    0x8(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071b:	b8 10 00 00 00       	mov    $0x10,%eax
  800720:	eb a5                	jmp    8006c7 <vprintfmt+0x3fa>
	else if (lflag)
  800722:	85 c9                	test   %ecx,%ecx
  800724:	75 17                	jne    80073d <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
  80073b:	eb 8a                	jmp    8006c7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074d:	b8 10 00 00 00       	mov    $0x10,%eax
  800752:	e9 70 ff ff ff       	jmp    8006c7 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	6a 25                	push   $0x25
  80075d:	ff d6                	call   *%esi
			break;
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	e9 7a ff ff ff       	jmp    8006e1 <vprintfmt+0x414>
			putch('%', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	6a 25                	push   $0x25
  80076d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 f8                	mov    %edi,%eax
  800774:	eb 03                	jmp    800779 <vprintfmt+0x4ac>
  800776:	83 e8 01             	sub    $0x1,%eax
  800779:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80077d:	75 f7                	jne    800776 <vprintfmt+0x4a9>
  80077f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800782:	e9 5a ff ff ff       	jmp    8006e1 <vprintfmt+0x414>
}
  800787:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078a:	5b                   	pop    %ebx
  80078b:	5e                   	pop    %esi
  80078c:	5f                   	pop    %edi
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80079e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	74 26                	je     8007d6 <vsnprintf+0x47>
  8007b0:	85 d2                	test   %edx,%edx
  8007b2:	7e 22                	jle    8007d6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b4:	ff 75 14             	pushl  0x14(%ebp)
  8007b7:	ff 75 10             	pushl  0x10(%ebp)
  8007ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bd:	50                   	push   %eax
  8007be:	68 93 02 80 00       	push   $0x800293
  8007c3:	e8 05 fb ff ff       	call   8002cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    
		return -E_INVAL;
  8007d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007db:	eb f7                	jmp    8007d4 <vsnprintf+0x45>

008007dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 10             	pushl  0x10(%ebp)
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	ff 75 08             	pushl  0x8(%ebp)
  8007f0:	e8 9a ff ff ff       	call   80078f <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    

008007f7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800802:	eb 03                	jmp    800807 <strlen+0x10>
		n++;
  800804:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800807:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80080b:	75 f7                	jne    800804 <strlen+0xd>
	return n;
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800815:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800818:	b8 00 00 00 00       	mov    $0x0,%eax
  80081d:	eb 03                	jmp    800822 <strnlen+0x13>
		n++;
  80081f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800822:	39 d0                	cmp    %edx,%eax
  800824:	74 06                	je     80082c <strnlen+0x1d>
  800826:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082a:	75 f3                	jne    80081f <strnlen+0x10>
	return n;
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800838:	89 c2                	mov    %eax,%edx
  80083a:	83 c1 01             	add    $0x1,%ecx
  80083d:	83 c2 01             	add    $0x1,%edx
  800840:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800844:	88 5a ff             	mov    %bl,-0x1(%edx)
  800847:	84 db                	test   %bl,%bl
  800849:	75 ef                	jne    80083a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80084b:	5b                   	pop    %ebx
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800855:	53                   	push   %ebx
  800856:	e8 9c ff ff ff       	call   8007f7 <strlen>
  80085b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	01 d8                	add    %ebx,%eax
  800863:	50                   	push   %eax
  800864:	e8 c5 ff ff ff       	call   80082e <strcpy>
	return dst;
}
  800869:	89 d8                	mov    %ebx,%eax
  80086b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086e:	c9                   	leave  
  80086f:	c3                   	ret    

00800870 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	56                   	push   %esi
  800874:	53                   	push   %ebx
  800875:	8b 75 08             	mov    0x8(%ebp),%esi
  800878:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087b:	89 f3                	mov    %esi,%ebx
  80087d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800880:	89 f2                	mov    %esi,%edx
  800882:	eb 0f                	jmp    800893 <strncpy+0x23>
		*dst++ = *src;
  800884:	83 c2 01             	add    $0x1,%edx
  800887:	0f b6 01             	movzbl (%ecx),%eax
  80088a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088d:	80 39 01             	cmpb   $0x1,(%ecx)
  800890:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800893:	39 da                	cmp    %ebx,%edx
  800895:	75 ed                	jne    800884 <strncpy+0x14>
	}
	return ret;
}
  800897:	89 f0                	mov    %esi,%eax
  800899:	5b                   	pop    %ebx
  80089a:	5e                   	pop    %esi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ab:	89 f0                	mov    %esi,%eax
  8008ad:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b1:	85 c9                	test   %ecx,%ecx
  8008b3:	75 0b                	jne    8008c0 <strlcpy+0x23>
  8008b5:	eb 17                	jmp    8008ce <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b7:	83 c2 01             	add    $0x1,%edx
  8008ba:	83 c0 01             	add    $0x1,%eax
  8008bd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008c0:	39 d8                	cmp    %ebx,%eax
  8008c2:	74 07                	je     8008cb <strlcpy+0x2e>
  8008c4:	0f b6 0a             	movzbl (%edx),%ecx
  8008c7:	84 c9                	test   %cl,%cl
  8008c9:	75 ec                	jne    8008b7 <strlcpy+0x1a>
		*dst = '\0';
  8008cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ce:	29 f0                	sub    %esi,%eax
}
  8008d0:	5b                   	pop    %ebx
  8008d1:	5e                   	pop    %esi
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008dd:	eb 06                	jmp    8008e5 <strcmp+0x11>
		p++, q++;
  8008df:	83 c1 01             	add    $0x1,%ecx
  8008e2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008e5:	0f b6 01             	movzbl (%ecx),%eax
  8008e8:	84 c0                	test   %al,%al
  8008ea:	74 04                	je     8008f0 <strcmp+0x1c>
  8008ec:	3a 02                	cmp    (%edx),%al
  8008ee:	74 ef                	je     8008df <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f0:	0f b6 c0             	movzbl %al,%eax
  8008f3:	0f b6 12             	movzbl (%edx),%edx
  8008f6:	29 d0                	sub    %edx,%eax
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 55 0c             	mov    0xc(%ebp),%edx
  800904:	89 c3                	mov    %eax,%ebx
  800906:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800909:	eb 06                	jmp    800911 <strncmp+0x17>
		n--, p++, q++;
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800911:	39 d8                	cmp    %ebx,%eax
  800913:	74 16                	je     80092b <strncmp+0x31>
  800915:	0f b6 08             	movzbl (%eax),%ecx
  800918:	84 c9                	test   %cl,%cl
  80091a:	74 04                	je     800920 <strncmp+0x26>
  80091c:	3a 0a                	cmp    (%edx),%cl
  80091e:	74 eb                	je     80090b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800920:	0f b6 00             	movzbl (%eax),%eax
  800923:	0f b6 12             	movzbl (%edx),%edx
  800926:	29 d0                	sub    %edx,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    
		return 0;
  80092b:	b8 00 00 00 00       	mov    $0x0,%eax
  800930:	eb f6                	jmp    800928 <strncmp+0x2e>

00800932 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093c:	0f b6 10             	movzbl (%eax),%edx
  80093f:	84 d2                	test   %dl,%dl
  800941:	74 09                	je     80094c <strchr+0x1a>
		if (*s == c)
  800943:	38 ca                	cmp    %cl,%dl
  800945:	74 0a                	je     800951 <strchr+0x1f>
	for (; *s; s++)
  800947:	83 c0 01             	add    $0x1,%eax
  80094a:	eb f0                	jmp    80093c <strchr+0xa>
			return (char *) s;
	return 0;
  80094c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095d:	eb 03                	jmp    800962 <strfind+0xf>
  80095f:	83 c0 01             	add    $0x1,%eax
  800962:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800965:	38 ca                	cmp    %cl,%dl
  800967:	74 04                	je     80096d <strfind+0x1a>
  800969:	84 d2                	test   %dl,%dl
  80096b:	75 f2                	jne    80095f <strfind+0xc>
			break;
	return (char *) s;
}
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	57                   	push   %edi
  800973:	56                   	push   %esi
  800974:	53                   	push   %ebx
  800975:	8b 7d 08             	mov    0x8(%ebp),%edi
  800978:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80097b:	85 c9                	test   %ecx,%ecx
  80097d:	74 13                	je     800992 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800985:	75 05                	jne    80098c <memset+0x1d>
  800987:	f6 c1 03             	test   $0x3,%cl
  80098a:	74 0d                	je     800999 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	fc                   	cld    
  800990:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800992:	89 f8                	mov    %edi,%eax
  800994:	5b                   	pop    %ebx
  800995:	5e                   	pop    %esi
  800996:	5f                   	pop    %edi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    
		c &= 0xFF;
  800999:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80099d:	89 d3                	mov    %edx,%ebx
  80099f:	c1 e3 08             	shl    $0x8,%ebx
  8009a2:	89 d0                	mov    %edx,%eax
  8009a4:	c1 e0 18             	shl    $0x18,%eax
  8009a7:	89 d6                	mov    %edx,%esi
  8009a9:	c1 e6 10             	shl    $0x10,%esi
  8009ac:	09 f0                	or     %esi,%eax
  8009ae:	09 c2                	or     %eax,%edx
  8009b0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009b2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	fc                   	cld    
  8009b8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ba:	eb d6                	jmp    800992 <memset+0x23>

008009bc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	57                   	push   %edi
  8009c0:	56                   	push   %esi
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ca:	39 c6                	cmp    %eax,%esi
  8009cc:	73 35                	jae    800a03 <memmove+0x47>
  8009ce:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	76 2e                	jbe    800a03 <memmove+0x47>
		s += n;
		d += n;
  8009d5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d8:	89 d6                	mov    %edx,%esi
  8009da:	09 fe                	or     %edi,%esi
  8009dc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e2:	74 0c                	je     8009f0 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e4:	83 ef 01             	sub    $0x1,%edi
  8009e7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ea:	fd                   	std    
  8009eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ed:	fc                   	cld    
  8009ee:	eb 21                	jmp    800a11 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f0:	f6 c1 03             	test   $0x3,%cl
  8009f3:	75 ef                	jne    8009e4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f5:	83 ef 04             	sub    $0x4,%edi
  8009f8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009fb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009fe:	fd                   	std    
  8009ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a01:	eb ea                	jmp    8009ed <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a03:	89 f2                	mov    %esi,%edx
  800a05:	09 c2                	or     %eax,%edx
  800a07:	f6 c2 03             	test   $0x3,%dl
  800a0a:	74 09                	je     800a15 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	fc                   	cld    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a11:	5e                   	pop    %esi
  800a12:	5f                   	pop    %edi
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a15:	f6 c1 03             	test   $0x3,%cl
  800a18:	75 f2                	jne    800a0c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a1d:	89 c7                	mov    %eax,%edi
  800a1f:	fc                   	cld    
  800a20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a22:	eb ed                	jmp    800a11 <memmove+0x55>

00800a24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a27:	ff 75 10             	pushl  0x10(%ebp)
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 87 ff ff ff       	call   8009bc <memmove>
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	89 c6                	mov    %eax,%esi
  800a44:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a47:	39 f0                	cmp    %esi,%eax
  800a49:	74 1c                	je     800a67 <memcmp+0x30>
		if (*s1 != *s2)
  800a4b:	0f b6 08             	movzbl (%eax),%ecx
  800a4e:	0f b6 1a             	movzbl (%edx),%ebx
  800a51:	38 d9                	cmp    %bl,%cl
  800a53:	75 08                	jne    800a5d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	eb ea                	jmp    800a47 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a5d:	0f b6 c1             	movzbl %cl,%eax
  800a60:	0f b6 db             	movzbl %bl,%ebx
  800a63:	29 d8                	sub    %ebx,%eax
  800a65:	eb 05                	jmp    800a6c <memcmp+0x35>
	}

	return 0;
  800a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6c:	5b                   	pop    %ebx
  800a6d:	5e                   	pop    %esi
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a7e:	39 d0                	cmp    %edx,%eax
  800a80:	73 09                	jae    800a8b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a82:	38 08                	cmp    %cl,(%eax)
  800a84:	74 05                	je     800a8b <memfind+0x1b>
	for (; s < ends; s++)
  800a86:	83 c0 01             	add    $0x1,%eax
  800a89:	eb f3                	jmp    800a7e <memfind+0xe>
			break;
	return (void *) s;
}
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	57                   	push   %edi
  800a91:	56                   	push   %esi
  800a92:	53                   	push   %ebx
  800a93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a99:	eb 03                	jmp    800a9e <strtol+0x11>
		s++;
  800a9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a9e:	0f b6 01             	movzbl (%ecx),%eax
  800aa1:	3c 20                	cmp    $0x20,%al
  800aa3:	74 f6                	je     800a9b <strtol+0xe>
  800aa5:	3c 09                	cmp    $0x9,%al
  800aa7:	74 f2                	je     800a9b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aa9:	3c 2b                	cmp    $0x2b,%al
  800aab:	74 2e                	je     800adb <strtol+0x4e>
	int neg = 0;
  800aad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ab2:	3c 2d                	cmp    $0x2d,%al
  800ab4:	74 2f                	je     800ae5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800abc:	75 05                	jne    800ac3 <strtol+0x36>
  800abe:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac1:	74 2c                	je     800aef <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ac3:	85 db                	test   %ebx,%ebx
  800ac5:	75 0a                	jne    800ad1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800acc:	80 39 30             	cmpb   $0x30,(%ecx)
  800acf:	74 28                	je     800af9 <strtol+0x6c>
		base = 10;
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad9:	eb 50                	jmp    800b2b <strtol+0x9e>
		s++;
  800adb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ade:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae3:	eb d1                	jmp    800ab6 <strtol+0x29>
		s++, neg = 1;
  800ae5:	83 c1 01             	add    $0x1,%ecx
  800ae8:	bf 01 00 00 00       	mov    $0x1,%edi
  800aed:	eb c7                	jmp    800ab6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aef:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af3:	74 0e                	je     800b03 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800af5:	85 db                	test   %ebx,%ebx
  800af7:	75 d8                	jne    800ad1 <strtol+0x44>
		s++, base = 8;
  800af9:	83 c1 01             	add    $0x1,%ecx
  800afc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b01:	eb ce                	jmp    800ad1 <strtol+0x44>
		s += 2, base = 16;
  800b03:	83 c1 02             	add    $0x2,%ecx
  800b06:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b0b:	eb c4                	jmp    800ad1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b0d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b10:	89 f3                	mov    %esi,%ebx
  800b12:	80 fb 19             	cmp    $0x19,%bl
  800b15:	77 29                	ja     800b40 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b17:	0f be d2             	movsbl %dl,%edx
  800b1a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b1d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b20:	7d 30                	jge    800b52 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b22:	83 c1 01             	add    $0x1,%ecx
  800b25:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b2b:	0f b6 11             	movzbl (%ecx),%edx
  800b2e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b31:	89 f3                	mov    %esi,%ebx
  800b33:	80 fb 09             	cmp    $0x9,%bl
  800b36:	77 d5                	ja     800b0d <strtol+0x80>
			dig = *s - '0';
  800b38:	0f be d2             	movsbl %dl,%edx
  800b3b:	83 ea 30             	sub    $0x30,%edx
  800b3e:	eb dd                	jmp    800b1d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b40:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b43:	89 f3                	mov    %esi,%ebx
  800b45:	80 fb 19             	cmp    $0x19,%bl
  800b48:	77 08                	ja     800b52 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b4a:	0f be d2             	movsbl %dl,%edx
  800b4d:	83 ea 37             	sub    $0x37,%edx
  800b50:	eb cb                	jmp    800b1d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	74 05                	je     800b5d <strtol+0xd0>
		*endptr = (char *) s;
  800b58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b5d:	89 c2                	mov    %eax,%edx
  800b5f:	f7 da                	neg    %edx
  800b61:	85 ff                	test   %edi,%edi
  800b63:	0f 45 c2             	cmovne %edx,%eax
}
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	8b 55 08             	mov    0x8(%ebp),%edx
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7c:	89 c3                	mov    %eax,%ebx
  800b7e:	89 c7                	mov    %eax,%edi
  800b80:	89 c6                	mov    %eax,%esi
  800b82:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5f                   	pop    %edi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <sys_cgetc>:

int
sys_cgetc(void) {
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	57                   	push   %edi
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b94:	b8 01 00 00 00       	mov    $0x1,%eax
  800b99:	89 d1                	mov    %edx,%ecx
  800b9b:	89 d3                	mov    %edx,%ebx
  800b9d:	89 d7                	mov    %edx,%edi
  800b9f:	89 d6                	mov    %edx,%esi
  800ba1:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5f                   	pop    %edi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	57                   	push   %edi
  800bac:	56                   	push   %esi
  800bad:	53                   	push   %ebx
  800bae:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bbe:	89 cb                	mov    %ecx,%ebx
  800bc0:	89 cf                	mov    %ecx,%edi
  800bc2:	89 ce                	mov    %ecx,%esi
  800bc4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bc6:	85 c0                	test   %eax,%eax
  800bc8:	7f 08                	jg     800bd2 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	50                   	push   %eax
  800bd6:	6a 03                	push   $0x3
  800bd8:	68 04 13 80 00       	push   $0x801304
  800bdd:	6a 24                	push   $0x24
  800bdf:	68 21 13 80 00       	push   $0x801321
  800be4:	e8 1b 02 00 00       	call   800e04 <_panic>

00800be9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bef:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf4:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf9:	89 d1                	mov    %edx,%ecx
  800bfb:	89 d3                	mov    %edx,%ebx
  800bfd:	89 d7                	mov    %edx,%edi
  800bff:	89 d6                	mov    %edx,%esi
  800c01:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <sys_yield>:

void
sys_yield(void)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c18:	89 d1                	mov    %edx,%ecx
  800c1a:	89 d3                	mov    %edx,%ebx
  800c1c:	89 d7                	mov    %edx,%edi
  800c1e:	89 d6                	mov    %edx,%esi
  800c20:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c30:	be 00 00 00 00       	mov    $0x0,%esi
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c43:	89 f7                	mov    %esi,%edi
  800c45:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c47:	85 c0                	test   %eax,%eax
  800c49:	7f 08                	jg     800c53 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	50                   	push   %eax
  800c57:	6a 04                	push   $0x4
  800c59:	68 04 13 80 00       	push   $0x801304
  800c5e:	6a 24                	push   $0x24
  800c60:	68 21 13 80 00       	push   $0x801321
  800c65:	e8 9a 01 00 00       	call   800e04 <_panic>

00800c6a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c73:	8b 55 08             	mov    0x8(%ebp),%edx
  800c76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c79:	b8 05 00 00 00       	mov    $0x5,%eax
  800c7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c84:	8b 75 18             	mov    0x18(%ebp),%esi
  800c87:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 05                	push   $0x5
  800c9b:	68 04 13 80 00       	push   $0x801304
  800ca0:	6a 24                	push   $0x24
  800ca2:	68 21 13 80 00       	push   $0x801321
  800ca7:	e8 58 01 00 00       	call   800e04 <_panic>

00800cac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	b8 06 00 00 00       	mov    $0x6,%eax
  800cc5:	89 df                	mov    %ebx,%edi
  800cc7:	89 de                	mov    %ebx,%esi
  800cc9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	7f 08                	jg     800cd7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	83 ec 0c             	sub    $0xc,%esp
  800cda:	50                   	push   %eax
  800cdb:	6a 06                	push   $0x6
  800cdd:	68 04 13 80 00       	push   $0x801304
  800ce2:	6a 24                	push   $0x24
  800ce4:	68 21 13 80 00       	push   $0x801321
  800ce9:	e8 16 01 00 00       	call   800e04 <_panic>

00800cee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cf7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 08 00 00 00       	mov    $0x8,%eax
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	89 de                	mov    %ebx,%esi
  800d0b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 08                	push   $0x8
  800d1f:	68 04 13 80 00       	push   $0x801304
  800d24:	6a 24                	push   $0x24
  800d26:	68 21 13 80 00       	push   $0x801321
  800d2b:	e8 d4 00 00 00       	call   800e04 <_panic>

00800d30 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	b8 09 00 00 00       	mov    $0x9,%eax
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7f 08                	jg     800d5b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	50                   	push   %eax
  800d5f:	6a 09                	push   $0x9
  800d61:	68 04 13 80 00       	push   $0x801304
  800d66:	6a 24                	push   $0x24
  800d68:	68 21 13 80 00       	push   $0x801321
  800d6d:	e8 92 00 00 00       	call   800e04 <_panic>

00800d72 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d83:	be 00 00 00 00       	mov    $0x0,%esi
  800d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dab:	89 cb                	mov    %ecx,%ebx
  800dad:	89 cf                	mov    %ecx,%edi
  800daf:	89 ce                	mov    %ecx,%esi
  800db1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7f 08                	jg     800dbf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	50                   	push   %eax
  800dc3:	6a 0c                	push   $0xc
  800dc5:	68 04 13 80 00       	push   $0x801304
  800dca:	6a 24                	push   $0x24
  800dcc:	68 21 13 80 00       	push   $0x801321
  800dd1:	e8 2e 00 00 00       	call   800e04 <_panic>

00800dd6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800ddc:	68 3b 13 80 00       	push   $0x80133b
  800de1:	6a 51                	push   $0x51
  800de3:	68 2f 13 80 00       	push   $0x80132f
  800de8:	e8 17 00 00 00       	call   800e04 <_panic>

00800ded <sfork>:
}

// Challenge!
int
sfork(void)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800df3:	68 3a 13 80 00       	push   $0x80133a
  800df8:	6a 58                	push   $0x58
  800dfa:	68 2f 13 80 00       	push   $0x80132f
  800dff:	e8 00 00 00 00       	call   800e04 <_panic>

00800e04 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800e09:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800e0c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e12:	e8 d2 fd ff ff       	call   800be9 <sys_getenvid>
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	56                   	push   %esi
  800e21:	50                   	push   %eax
  800e22:	68 50 13 80 00       	push   $0x801350
  800e27:	e8 a4 f3 ff ff       	call   8001d0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e2c:	83 c4 18             	add    $0x18,%esp
  800e2f:	53                   	push   %ebx
  800e30:	ff 75 10             	pushl  0x10(%ebp)
  800e33:	e8 47 f3 ff ff       	call   80017f <vcprintf>
	cprintf("\n");
  800e38:	c7 04 24 af 10 80 00 	movl   $0x8010af,(%esp)
  800e3f:	e8 8c f3 ff ff       	call   8001d0 <cprintf>
  800e44:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e47:	cc                   	int3   
  800e48:	eb fd                	jmp    800e47 <_panic+0x43>
  800e4a:	66 90                	xchg   %ax,%ax
  800e4c:	66 90                	xchg   %ax,%ax
  800e4e:	66 90                	xchg   %ax,%ax

00800e50 <__udivdi3>:
  800e50:	55                   	push   %ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	83 ec 1c             	sub    $0x1c,%esp
  800e57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e67:	85 d2                	test   %edx,%edx
  800e69:	75 35                	jne    800ea0 <__udivdi3+0x50>
  800e6b:	39 f3                	cmp    %esi,%ebx
  800e6d:	0f 87 bd 00 00 00    	ja     800f30 <__udivdi3+0xe0>
  800e73:	85 db                	test   %ebx,%ebx
  800e75:	89 d9                	mov    %ebx,%ecx
  800e77:	75 0b                	jne    800e84 <__udivdi3+0x34>
  800e79:	b8 01 00 00 00       	mov    $0x1,%eax
  800e7e:	31 d2                	xor    %edx,%edx
  800e80:	f7 f3                	div    %ebx
  800e82:	89 c1                	mov    %eax,%ecx
  800e84:	31 d2                	xor    %edx,%edx
  800e86:	89 f0                	mov    %esi,%eax
  800e88:	f7 f1                	div    %ecx
  800e8a:	89 c6                	mov    %eax,%esi
  800e8c:	89 e8                	mov    %ebp,%eax
  800e8e:	89 f7                	mov    %esi,%edi
  800e90:	f7 f1                	div    %ecx
  800e92:	89 fa                	mov    %edi,%edx
  800e94:	83 c4 1c             	add    $0x1c,%esp
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    
  800e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	39 f2                	cmp    %esi,%edx
  800ea2:	77 7c                	ja     800f20 <__udivdi3+0xd0>
  800ea4:	0f bd fa             	bsr    %edx,%edi
  800ea7:	83 f7 1f             	xor    $0x1f,%edi
  800eaa:	0f 84 98 00 00 00    	je     800f48 <__udivdi3+0xf8>
  800eb0:	89 f9                	mov    %edi,%ecx
  800eb2:	b8 20 00 00 00       	mov    $0x20,%eax
  800eb7:	29 f8                	sub    %edi,%eax
  800eb9:	d3 e2                	shl    %cl,%edx
  800ebb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ebf:	89 c1                	mov    %eax,%ecx
  800ec1:	89 da                	mov    %ebx,%edx
  800ec3:	d3 ea                	shr    %cl,%edx
  800ec5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ec9:	09 d1                	or     %edx,%ecx
  800ecb:	89 f2                	mov    %esi,%edx
  800ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ed1:	89 f9                	mov    %edi,%ecx
  800ed3:	d3 e3                	shl    %cl,%ebx
  800ed5:	89 c1                	mov    %eax,%ecx
  800ed7:	d3 ea                	shr    %cl,%edx
  800ed9:	89 f9                	mov    %edi,%ecx
  800edb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800edf:	d3 e6                	shl    %cl,%esi
  800ee1:	89 eb                	mov    %ebp,%ebx
  800ee3:	89 c1                	mov    %eax,%ecx
  800ee5:	d3 eb                	shr    %cl,%ebx
  800ee7:	09 de                	or     %ebx,%esi
  800ee9:	89 f0                	mov    %esi,%eax
  800eeb:	f7 74 24 08          	divl   0x8(%esp)
  800eef:	89 d6                	mov    %edx,%esi
  800ef1:	89 c3                	mov    %eax,%ebx
  800ef3:	f7 64 24 0c          	mull   0xc(%esp)
  800ef7:	39 d6                	cmp    %edx,%esi
  800ef9:	72 0c                	jb     800f07 <__udivdi3+0xb7>
  800efb:	89 f9                	mov    %edi,%ecx
  800efd:	d3 e5                	shl    %cl,%ebp
  800eff:	39 c5                	cmp    %eax,%ebp
  800f01:	73 5d                	jae    800f60 <__udivdi3+0x110>
  800f03:	39 d6                	cmp    %edx,%esi
  800f05:	75 59                	jne    800f60 <__udivdi3+0x110>
  800f07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f0a:	31 ff                	xor    %edi,%edi
  800f0c:	89 fa                	mov    %edi,%edx
  800f0e:	83 c4 1c             	add    $0x1c,%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
  800f16:	8d 76 00             	lea    0x0(%esi),%esi
  800f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f20:	31 ff                	xor    %edi,%edi
  800f22:	31 c0                	xor    %eax,%eax
  800f24:	89 fa                	mov    %edi,%edx
  800f26:	83 c4 1c             	add    $0x1c,%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
  800f2e:	66 90                	xchg   %ax,%ax
  800f30:	31 ff                	xor    %edi,%edi
  800f32:	89 e8                	mov    %ebp,%eax
  800f34:	89 f2                	mov    %esi,%edx
  800f36:	f7 f3                	div    %ebx
  800f38:	89 fa                	mov    %edi,%edx
  800f3a:	83 c4 1c             	add    $0x1c,%esp
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    
  800f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f48:	39 f2                	cmp    %esi,%edx
  800f4a:	72 06                	jb     800f52 <__udivdi3+0x102>
  800f4c:	31 c0                	xor    %eax,%eax
  800f4e:	39 eb                	cmp    %ebp,%ebx
  800f50:	77 d2                	ja     800f24 <__udivdi3+0xd4>
  800f52:	b8 01 00 00 00       	mov    $0x1,%eax
  800f57:	eb cb                	jmp    800f24 <__udivdi3+0xd4>
  800f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f60:	89 d8                	mov    %ebx,%eax
  800f62:	31 ff                	xor    %edi,%edi
  800f64:	eb be                	jmp    800f24 <__udivdi3+0xd4>
  800f66:	66 90                	xchg   %ax,%ax
  800f68:	66 90                	xchg   %ax,%ax
  800f6a:	66 90                	xchg   %ax,%ax
  800f6c:	66 90                	xchg   %ax,%ax
  800f6e:	66 90                	xchg   %ax,%ax

00800f70 <__umoddi3>:
  800f70:	55                   	push   %ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 1c             	sub    $0x1c,%esp
  800f77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f87:	85 ed                	test   %ebp,%ebp
  800f89:	89 f0                	mov    %esi,%eax
  800f8b:	89 da                	mov    %ebx,%edx
  800f8d:	75 19                	jne    800fa8 <__umoddi3+0x38>
  800f8f:	39 df                	cmp    %ebx,%edi
  800f91:	0f 86 b1 00 00 00    	jbe    801048 <__umoddi3+0xd8>
  800f97:	f7 f7                	div    %edi
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	83 c4 1c             	add    $0x1c,%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
  800fa5:	8d 76 00             	lea    0x0(%esi),%esi
  800fa8:	39 dd                	cmp    %ebx,%ebp
  800faa:	77 f1                	ja     800f9d <__umoddi3+0x2d>
  800fac:	0f bd cd             	bsr    %ebp,%ecx
  800faf:	83 f1 1f             	xor    $0x1f,%ecx
  800fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fb6:	0f 84 b4 00 00 00    	je     801070 <__umoddi3+0x100>
  800fbc:	b8 20 00 00 00       	mov    $0x20,%eax
  800fc1:	89 c2                	mov    %eax,%edx
  800fc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fc7:	29 c2                	sub    %eax,%edx
  800fc9:	89 c1                	mov    %eax,%ecx
  800fcb:	89 f8                	mov    %edi,%eax
  800fcd:	d3 e5                	shl    %cl,%ebp
  800fcf:	89 d1                	mov    %edx,%ecx
  800fd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fd5:	d3 e8                	shr    %cl,%eax
  800fd7:	09 c5                	or     %eax,%ebp
  800fd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fdd:	89 c1                	mov    %eax,%ecx
  800fdf:	d3 e7                	shl    %cl,%edi
  800fe1:	89 d1                	mov    %edx,%ecx
  800fe3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fe7:	89 df                	mov    %ebx,%edi
  800fe9:	d3 ef                	shr    %cl,%edi
  800feb:	89 c1                	mov    %eax,%ecx
  800fed:	89 f0                	mov    %esi,%eax
  800fef:	d3 e3                	shl    %cl,%ebx
  800ff1:	89 d1                	mov    %edx,%ecx
  800ff3:	89 fa                	mov    %edi,%edx
  800ff5:	d3 e8                	shr    %cl,%eax
  800ff7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800ffc:	09 d8                	or     %ebx,%eax
  800ffe:	f7 f5                	div    %ebp
  801000:	d3 e6                	shl    %cl,%esi
  801002:	89 d1                	mov    %edx,%ecx
  801004:	f7 64 24 08          	mull   0x8(%esp)
  801008:	39 d1                	cmp    %edx,%ecx
  80100a:	89 c3                	mov    %eax,%ebx
  80100c:	89 d7                	mov    %edx,%edi
  80100e:	72 06                	jb     801016 <__umoddi3+0xa6>
  801010:	75 0e                	jne    801020 <__umoddi3+0xb0>
  801012:	39 c6                	cmp    %eax,%esi
  801014:	73 0a                	jae    801020 <__umoddi3+0xb0>
  801016:	2b 44 24 08          	sub    0x8(%esp),%eax
  80101a:	19 ea                	sbb    %ebp,%edx
  80101c:	89 d7                	mov    %edx,%edi
  80101e:	89 c3                	mov    %eax,%ebx
  801020:	89 ca                	mov    %ecx,%edx
  801022:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801027:	29 de                	sub    %ebx,%esi
  801029:	19 fa                	sbb    %edi,%edx
  80102b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80102f:	89 d0                	mov    %edx,%eax
  801031:	d3 e0                	shl    %cl,%eax
  801033:	89 d9                	mov    %ebx,%ecx
  801035:	d3 ee                	shr    %cl,%esi
  801037:	d3 ea                	shr    %cl,%edx
  801039:	09 f0                	or     %esi,%eax
  80103b:	83 c4 1c             	add    $0x1c,%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    
  801043:	90                   	nop
  801044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801048:	85 ff                	test   %edi,%edi
  80104a:	89 f9                	mov    %edi,%ecx
  80104c:	75 0b                	jne    801059 <__umoddi3+0xe9>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	31 d2                	xor    %edx,%edx
  801055:	f7 f7                	div    %edi
  801057:	89 c1                	mov    %eax,%ecx
  801059:	89 d8                	mov    %ebx,%eax
  80105b:	31 d2                	xor    %edx,%edx
  80105d:	f7 f1                	div    %ecx
  80105f:	89 f0                	mov    %esi,%eax
  801061:	f7 f1                	div    %ecx
  801063:	e9 31 ff ff ff       	jmp    800f99 <__umoddi3+0x29>
  801068:	90                   	nop
  801069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801070:	39 dd                	cmp    %ebx,%ebp
  801072:	72 08                	jb     80107c <__umoddi3+0x10c>
  801074:	39 f7                	cmp    %esi,%edi
  801076:	0f 87 21 ff ff ff    	ja     800f9d <__umoddi3+0x2d>
  80107c:	89 da                	mov    %ebx,%edx
  80107e:	89 f0                	mov    %esi,%eax
  801080:	29 f8                	sub    %edi,%eax
  801082:	19 ea                	sbb    %ebp,%edx
  801084:	e9 14 ff ff ff       	jmp    800f9d <__umoddi3+0x2d>
