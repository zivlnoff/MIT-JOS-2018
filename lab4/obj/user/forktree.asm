
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
  80003d:	e8 97 0b 00 00       	call   800bd9 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 80 10 80 00       	push   $0x801080
  80004c:	e8 6f 01 00 00       	call   8001c0 <cprintf>

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
  80007e:	e8 64 07 00 00       	call   8007e7 <strlen>
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
  80009c:	68 91 10 80 00       	push   $0x801091
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 21 07 00 00       	call   8007cd <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 12 0d 00 00       	call   800dc6 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 50 00 00 00       	call   800119 <exit>
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
  8000d4:	68 90 10 80 00       	push   $0x801090
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
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000ef:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8000f6:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	7e 08                	jle    800105 <libmain+0x22>
		binaryname = argv[0];
  8000fd:	8b 0a                	mov    (%edx),%ecx
  8000ff:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800105:	83 ec 08             	sub    $0x8,%esp
  800108:	52                   	push   %edx
  800109:	50                   	push   %eax
  80010a:	e8 bf ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80010f:	e8 05 00 00 00       	call   800119 <exit>
}
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80011f:	6a 00                	push   $0x0
  800121:	e8 72 0a 00 00       	call   800b98 <sys_env_destroy>
}
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	c9                   	leave  
  80012a:	c3                   	ret    

0080012b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	53                   	push   %ebx
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800135:	8b 13                	mov    (%ebx),%edx
  800137:	8d 42 01             	lea    0x1(%edx),%eax
  80013a:	89 03                	mov    %eax,(%ebx)
  80013c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80013f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800143:	3d ff 00 00 00       	cmp    $0xff,%eax
  800148:	74 09                	je     800153 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80014a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80014e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800151:	c9                   	leave  
  800152:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 ff 00 00 00       	push   $0xff
  80015b:	8d 43 08             	lea    0x8(%ebx),%eax
  80015e:	50                   	push   %eax
  80015f:	e8 f7 09 00 00       	call   800b5b <sys_cputs>
		b->idx = 0;
  800164:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	eb db                	jmp    80014a <putch+0x1f>

0080016f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800178:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80017f:	00 00 00 
	b.cnt = 0;
  800182:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800189:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018c:	ff 75 0c             	pushl  0xc(%ebp)
  80018f:	ff 75 08             	pushl  0x8(%ebp)
  800192:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	68 2b 01 80 00       	push   $0x80012b
  80019e:	e8 1a 01 00 00       	call   8002bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a3:	83 c4 08             	add    $0x8,%esp
  8001a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	e8 a3 09 00 00       	call   800b5b <sys_cputs>

	return b.cnt;
}
  8001b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

008001c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001c9:	50                   	push   %eax
  8001ca:	ff 75 08             	pushl  0x8(%ebp)
  8001cd:	e8 9d ff ff ff       	call   80016f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    

008001d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	57                   	push   %edi
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	83 ec 1c             	sub    $0x1c,%esp
  8001dd:	89 c7                	mov    %eax,%edi
  8001df:	89 d6                	mov    %edx,%esi
  8001e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001fb:	39 d3                	cmp    %edx,%ebx
  8001fd:	72 05                	jb     800204 <printnum+0x30>
  8001ff:	39 45 10             	cmp    %eax,0x10(%ebp)
  800202:	77 7a                	ja     80027e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	ff 75 18             	pushl  0x18(%ebp)
  80020a:	8b 45 14             	mov    0x14(%ebp),%eax
  80020d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800210:	53                   	push   %ebx
  800211:	ff 75 10             	pushl  0x10(%ebp)
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	ff 75 dc             	pushl  -0x24(%ebp)
  800220:	ff 75 d8             	pushl  -0x28(%ebp)
  800223:	e8 18 0c 00 00       	call   800e40 <__udivdi3>
  800228:	83 c4 18             	add    $0x18,%esp
  80022b:	52                   	push   %edx
  80022c:	50                   	push   %eax
  80022d:	89 f2                	mov    %esi,%edx
  80022f:	89 f8                	mov    %edi,%eax
  800231:	e8 9e ff ff ff       	call   8001d4 <printnum>
  800236:	83 c4 20             	add    $0x20,%esp
  800239:	eb 13                	jmp    80024e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	ff 75 18             	pushl  0x18(%ebp)
  800242:	ff d7                	call   *%edi
  800244:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800247:	83 eb 01             	sub    $0x1,%ebx
  80024a:	85 db                	test   %ebx,%ebx
  80024c:	7f ed                	jg     80023b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	56                   	push   %esi
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 e4             	pushl  -0x1c(%ebp)
  800258:	ff 75 e0             	pushl  -0x20(%ebp)
  80025b:	ff 75 dc             	pushl  -0x24(%ebp)
  80025e:	ff 75 d8             	pushl  -0x28(%ebp)
  800261:	e8 fa 0c 00 00       	call   800f60 <__umoddi3>
  800266:	83 c4 14             	add    $0x14,%esp
  800269:	0f be 80 a0 10 80 00 	movsbl 0x8010a0(%eax),%eax
  800270:	50                   	push   %eax
  800271:	ff d7                	call   *%edi
}
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	5d                   	pop    %ebp
  80027d:	c3                   	ret    
  80027e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800281:	eb c4                	jmp    800247 <printnum+0x73>

00800283 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800289:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028d:	8b 10                	mov    (%eax),%edx
  80028f:	3b 50 04             	cmp    0x4(%eax),%edx
  800292:	73 0a                	jae    80029e <sprintputch+0x1b>
		*b->buf++ = ch;
  800294:	8d 4a 01             	lea    0x1(%edx),%ecx
  800297:	89 08                	mov    %ecx,(%eax)
  800299:	8b 45 08             	mov    0x8(%ebp),%eax
  80029c:	88 02                	mov    %al,(%edx)
}
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <printfmt>:
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 10             	pushl  0x10(%ebp)
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 05 00 00 00       	call   8002bd <vprintfmt>
}
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <vprintfmt>:
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	57                   	push   %edi
  8002c1:	56                   	push   %esi
  8002c2:	53                   	push   %ebx
  8002c3:	83 ec 2c             	sub    $0x2c,%esp
  8002c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002cf:	e9 00 04 00 00       	jmp    8006d4 <vprintfmt+0x417>
		padc = ' ';
  8002d4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002df:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ed:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f2:	8d 47 01             	lea    0x1(%edi),%eax
  8002f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002f8:	0f b6 17             	movzbl (%edi),%edx
  8002fb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002fe:	3c 55                	cmp    $0x55,%al
  800300:	0f 87 51 04 00 00    	ja     800757 <vprintfmt+0x49a>
  800306:	0f b6 c0             	movzbl %al,%eax
  800309:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  800310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800313:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800317:	eb d9                	jmp    8002f2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80031c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800320:	eb d0                	jmp    8002f2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800322:	0f b6 d2             	movzbl %dl,%edx
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800330:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800333:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800337:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80033a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80033d:	83 f9 09             	cmp    $0x9,%ecx
  800340:	77 55                	ja     800397 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800342:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800345:	eb e9                	jmp    800330 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800347:	8b 45 14             	mov    0x14(%ebp),%eax
  80034a:	8b 00                	mov    (%eax),%eax
  80034c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80034f:	8b 45 14             	mov    0x14(%ebp),%eax
  800352:	8d 40 04             	lea    0x4(%eax),%eax
  800355:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80035b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80035f:	79 91                	jns    8002f2 <vprintfmt+0x35>
				width = precision, precision = -1;
  800361:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800364:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800367:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80036e:	eb 82                	jmp    8002f2 <vprintfmt+0x35>
  800370:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800373:	85 c0                	test   %eax,%eax
  800375:	ba 00 00 00 00       	mov    $0x0,%edx
  80037a:	0f 49 d0             	cmovns %eax,%edx
  80037d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800383:	e9 6a ff ff ff       	jmp    8002f2 <vprintfmt+0x35>
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80038b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800392:	e9 5b ff ff ff       	jmp    8002f2 <vprintfmt+0x35>
  800397:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80039a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80039d:	eb bc                	jmp    80035b <vprintfmt+0x9e>
			lflag++;
  80039f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003a5:	e9 48 ff ff ff       	jmp    8002f2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8d 78 04             	lea    0x4(%eax),%edi
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	53                   	push   %ebx
  8003b4:	ff 30                	pushl  (%eax)
  8003b6:	ff d6                	call   *%esi
			break;
  8003b8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003bb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003be:	e9 0e 03 00 00       	jmp    8006d1 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 78 04             	lea    0x4(%eax),%edi
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	99                   	cltd   
  8003cc:	31 d0                	xor    %edx,%eax
  8003ce:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d0:	83 f8 08             	cmp    $0x8,%eax
  8003d3:	7f 23                	jg     8003f8 <vprintfmt+0x13b>
  8003d5:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  8003dc:	85 d2                	test   %edx,%edx
  8003de:	74 18                	je     8003f8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003e0:	52                   	push   %edx
  8003e1:	68 c1 10 80 00       	push   $0x8010c1
  8003e6:	53                   	push   %ebx
  8003e7:	56                   	push   %esi
  8003e8:	e8 b3 fe ff ff       	call   8002a0 <printfmt>
  8003ed:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f3:	e9 d9 02 00 00       	jmp    8006d1 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8003f8:	50                   	push   %eax
  8003f9:	68 b8 10 80 00       	push   $0x8010b8
  8003fe:	53                   	push   %ebx
  8003ff:	56                   	push   %esi
  800400:	e8 9b fe ff ff       	call   8002a0 <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80040b:	e9 c1 02 00 00       	jmp    8006d1 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800410:	8b 45 14             	mov    0x14(%ebp),%eax
  800413:	83 c0 04             	add    $0x4,%eax
  800416:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80041e:	85 ff                	test   %edi,%edi
  800420:	b8 b1 10 80 00       	mov    $0x8010b1,%eax
  800425:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800428:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042c:	0f 8e bd 00 00 00    	jle    8004ef <vprintfmt+0x232>
  800432:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800436:	75 0e                	jne    800446 <vprintfmt+0x189>
  800438:	89 75 08             	mov    %esi,0x8(%ebp)
  80043b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80043e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	eb 6d                	jmp    8004b3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 d0             	pushl  -0x30(%ebp)
  80044c:	57                   	push   %edi
  80044d:	e8 ad 03 00 00       	call   8007ff <strnlen>
  800452:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800455:	29 c1                	sub    %eax,%ecx
  800457:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80045a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80045d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800461:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800464:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800467:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800469:	eb 0f                	jmp    80047a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	53                   	push   %ebx
  80046f:	ff 75 e0             	pushl  -0x20(%ebp)
  800472:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800474:	83 ef 01             	sub    $0x1,%edi
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	85 ff                	test   %edi,%edi
  80047c:	7f ed                	jg     80046b <vprintfmt+0x1ae>
  80047e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800481:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800484:	85 c9                	test   %ecx,%ecx
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	0f 49 c1             	cmovns %ecx,%eax
  80048e:	29 c1                	sub    %eax,%ecx
  800490:	89 75 08             	mov    %esi,0x8(%ebp)
  800493:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800496:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800499:	89 cb                	mov    %ecx,%ebx
  80049b:	eb 16                	jmp    8004b3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80049d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a1:	75 31                	jne    8004d4 <vprintfmt+0x217>
					putch(ch, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	ff 75 0c             	pushl  0xc(%ebp)
  8004a9:	50                   	push   %eax
  8004aa:	ff 55 08             	call   *0x8(%ebp)
  8004ad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b0:	83 eb 01             	sub    $0x1,%ebx
  8004b3:	83 c7 01             	add    $0x1,%edi
  8004b6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ba:	0f be c2             	movsbl %dl,%eax
  8004bd:	85 c0                	test   %eax,%eax
  8004bf:	74 59                	je     80051a <vprintfmt+0x25d>
  8004c1:	85 f6                	test   %esi,%esi
  8004c3:	78 d8                	js     80049d <vprintfmt+0x1e0>
  8004c5:	83 ee 01             	sub    $0x1,%esi
  8004c8:	79 d3                	jns    80049d <vprintfmt+0x1e0>
  8004ca:	89 df                	mov    %ebx,%edi
  8004cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d2:	eb 37                	jmp    80050b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d4:	0f be d2             	movsbl %dl,%edx
  8004d7:	83 ea 20             	sub    $0x20,%edx
  8004da:	83 fa 5e             	cmp    $0x5e,%edx
  8004dd:	76 c4                	jbe    8004a3 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	ff 75 0c             	pushl  0xc(%ebp)
  8004e5:	6a 3f                	push   $0x3f
  8004e7:	ff 55 08             	call   *0x8(%ebp)
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	eb c1                	jmp    8004b0 <vprintfmt+0x1f3>
  8004ef:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004fb:	eb b6                	jmp    8004b3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	53                   	push   %ebx
  800501:	6a 20                	push   $0x20
  800503:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800505:	83 ef 01             	sub    $0x1,%edi
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	85 ff                	test   %edi,%edi
  80050d:	7f ee                	jg     8004fd <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80050f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800512:	89 45 14             	mov    %eax,0x14(%ebp)
  800515:	e9 b7 01 00 00       	jmp    8006d1 <vprintfmt+0x414>
  80051a:	89 df                	mov    %ebx,%edi
  80051c:	8b 75 08             	mov    0x8(%ebp),%esi
  80051f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800522:	eb e7                	jmp    80050b <vprintfmt+0x24e>
	if (lflag >= 2)
  800524:	83 f9 01             	cmp    $0x1,%ecx
  800527:	7e 3f                	jle    800568 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 50 04             	mov    0x4(%eax),%edx
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800534:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8d 40 08             	lea    0x8(%eax),%eax
  80053d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800540:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800544:	79 5c                	jns    8005a2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 2d                	push   $0x2d
  80054c:	ff d6                	call   *%esi
				num = -(long long) num;
  80054e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800551:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800554:	f7 da                	neg    %edx
  800556:	83 d1 00             	adc    $0x0,%ecx
  800559:	f7 d9                	neg    %ecx
  80055b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800563:	e9 4f 01 00 00       	jmp    8006b7 <vprintfmt+0x3fa>
	else if (lflag)
  800568:	85 c9                	test   %ecx,%ecx
  80056a:	75 1b                	jne    800587 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800574:	89 c1                	mov    %eax,%ecx
  800576:	c1 f9 1f             	sar    $0x1f,%ecx
  800579:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb b9                	jmp    800540 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 c1                	mov    %eax,%ecx
  800591:	c1 f9 1f             	sar    $0x1f,%ecx
  800594:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 40 04             	lea    0x4(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a0:	eb 9e                	jmp    800540 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ad:	e9 05 01 00 00       	jmp    8006b7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005b2:	83 f9 01             	cmp    $0x1,%ecx
  8005b5:	7e 18                	jle    8005cf <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 10                	mov    (%eax),%edx
  8005bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bf:	8d 40 08             	lea    0x8(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ca:	e9 e8 00 00 00       	jmp    8006b7 <vprintfmt+0x3fa>
	else if (lflag)
  8005cf:	85 c9                	test   %ecx,%ecx
  8005d1:	75 1a                	jne    8005ed <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 10                	mov    (%eax),%edx
  8005d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005dd:	8d 40 04             	lea    0x4(%eax),%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e8:	e9 ca 00 00 00       	jmp    8006b7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 10                	mov    (%eax),%edx
  8005f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800602:	e9 b0 00 00 00       	jmp    8006b7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800607:	83 f9 01             	cmp    $0x1,%ecx
  80060a:	7e 3c                	jle    800648 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 50 04             	mov    0x4(%eax),%edx
  800612:	8b 00                	mov    (%eax),%eax
  800614:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800617:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 40 08             	lea    0x8(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800623:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800627:	79 59                	jns    800682 <vprintfmt+0x3c5>
                putch('-', putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	53                   	push   %ebx
  80062d:	6a 2d                	push   $0x2d
  80062f:	ff d6                	call   *%esi
                num = -(long long) num;
  800631:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800634:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800637:	f7 da                	neg    %edx
  800639:	83 d1 00             	adc    $0x0,%ecx
  80063c:	f7 d9                	neg    %ecx
  80063e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800641:	b8 08 00 00 00       	mov    $0x8,%eax
  800646:	eb 6f                	jmp    8006b7 <vprintfmt+0x3fa>
	else if (lflag)
  800648:	85 c9                	test   %ecx,%ecx
  80064a:	75 1b                	jne    800667 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 c1                	mov    %eax,%ecx
  800656:	c1 f9 1f             	sar    $0x1f,%ecx
  800659:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	eb bc                	jmp    800623 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 c1                	mov    %eax,%ecx
  800671:	c1 f9 1f             	sar    $0x1f,%ecx
  800674:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8d 40 04             	lea    0x4(%eax),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
  800680:	eb a1                	jmp    800623 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800682:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800685:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800688:	b8 08 00 00 00       	mov    $0x8,%eax
  80068d:	eb 28                	jmp    8006b7 <vprintfmt+0x3fa>
			putch('0', putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	53                   	push   %ebx
  800693:	6a 30                	push   $0x30
  800695:	ff d6                	call   *%esi
			putch('x', putdat);
  800697:	83 c4 08             	add    $0x8,%esp
  80069a:	53                   	push   %ebx
  80069b:	6a 78                	push   $0x78
  80069d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 10                	mov    (%eax),%edx
  8006a4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006be:	57                   	push   %edi
  8006bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c2:	50                   	push   %eax
  8006c3:	51                   	push   %ecx
  8006c4:	52                   	push   %edx
  8006c5:	89 da                	mov    %ebx,%edx
  8006c7:	89 f0                	mov    %esi,%eax
  8006c9:	e8 06 fb ff ff       	call   8001d4 <printnum>
			break;
  8006ce:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d4:	83 c7 01             	add    $0x1,%edi
  8006d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006db:	83 f8 25             	cmp    $0x25,%eax
  8006de:	0f 84 f0 fb ff ff    	je     8002d4 <vprintfmt+0x17>
			if (ch == '\0')
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	0f 84 8b 00 00 00    	je     800777 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	53                   	push   %ebx
  8006f0:	50                   	push   %eax
  8006f1:	ff d6                	call   *%esi
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	eb dc                	jmp    8006d4 <vprintfmt+0x417>
	if (lflag >= 2)
  8006f8:	83 f9 01             	cmp    $0x1,%ecx
  8006fb:	7e 15                	jle    800712 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	8b 48 04             	mov    0x4(%eax),%ecx
  800705:	8d 40 08             	lea    0x8(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070b:	b8 10 00 00 00       	mov    $0x10,%eax
  800710:	eb a5                	jmp    8006b7 <vprintfmt+0x3fa>
	else if (lflag)
  800712:	85 c9                	test   %ecx,%ecx
  800714:	75 17                	jne    80072d <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 10                	mov    (%eax),%edx
  80071b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800726:	b8 10 00 00 00       	mov    $0x10,%eax
  80072b:	eb 8a                	jmp    8006b7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	b8 10 00 00 00       	mov    $0x10,%eax
  800742:	e9 70 ff ff ff       	jmp    8006b7 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	53                   	push   %ebx
  80074b:	6a 25                	push   $0x25
  80074d:	ff d6                	call   *%esi
			break;
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	e9 7a ff ff ff       	jmp    8006d1 <vprintfmt+0x414>
			putch('%', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	6a 25                	push   $0x25
  80075d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 f8                	mov    %edi,%eax
  800764:	eb 03                	jmp    800769 <vprintfmt+0x4ac>
  800766:	83 e8 01             	sub    $0x1,%eax
  800769:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80076d:	75 f7                	jne    800766 <vprintfmt+0x4a9>
  80076f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800772:	e9 5a ff ff ff       	jmp    8006d1 <vprintfmt+0x414>
}
  800777:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80077a:	5b                   	pop    %ebx
  80077b:	5e                   	pop    %esi
  80077c:	5f                   	pop    %edi
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	83 ec 18             	sub    $0x18,%esp
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800792:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800795:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079c:	85 c0                	test   %eax,%eax
  80079e:	74 26                	je     8007c6 <vsnprintf+0x47>
  8007a0:	85 d2                	test   %edx,%edx
  8007a2:	7e 22                	jle    8007c6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a4:	ff 75 14             	pushl  0x14(%ebp)
  8007a7:	ff 75 10             	pushl  0x10(%ebp)
  8007aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ad:	50                   	push   %eax
  8007ae:	68 83 02 80 00       	push   $0x800283
  8007b3:	e8 05 fb ff ff       	call   8002bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    
		return -E_INVAL;
  8007c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007cb:	eb f7                	jmp    8007c4 <vsnprintf+0x45>

008007cd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d6:	50                   	push   %eax
  8007d7:	ff 75 10             	pushl  0x10(%ebp)
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	ff 75 08             	pushl  0x8(%ebp)
  8007e0:	e8 9a ff ff ff       	call   80077f <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f2:	eb 03                	jmp    8007f7 <strlen+0x10>
		n++;
  8007f4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007f7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fb:	75 f7                	jne    8007f4 <strlen+0xd>
	return n;
}
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800805:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800808:	b8 00 00 00 00       	mov    $0x0,%eax
  80080d:	eb 03                	jmp    800812 <strnlen+0x13>
		n++;
  80080f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800812:	39 d0                	cmp    %edx,%eax
  800814:	74 06                	je     80081c <strnlen+0x1d>
  800816:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081a:	75 f3                	jne    80080f <strnlen+0x10>
	return n;
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	53                   	push   %ebx
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800828:	89 c2                	mov    %eax,%edx
  80082a:	83 c1 01             	add    $0x1,%ecx
  80082d:	83 c2 01             	add    $0x1,%edx
  800830:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800834:	88 5a ff             	mov    %bl,-0x1(%edx)
  800837:	84 db                	test   %bl,%bl
  800839:	75 ef                	jne    80082a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80083b:	5b                   	pop    %ebx
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	53                   	push   %ebx
  800842:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800845:	53                   	push   %ebx
  800846:	e8 9c ff ff ff       	call   8007e7 <strlen>
  80084b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	01 d8                	add    %ebx,%eax
  800853:	50                   	push   %eax
  800854:	e8 c5 ff ff ff       	call   80081e <strcpy>
	return dst;
}
  800859:	89 d8                	mov    %ebx,%eax
  80085b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085e:	c9                   	leave  
  80085f:	c3                   	ret    

00800860 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	56                   	push   %esi
  800864:	53                   	push   %ebx
  800865:	8b 75 08             	mov    0x8(%ebp),%esi
  800868:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086b:	89 f3                	mov    %esi,%ebx
  80086d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800870:	89 f2                	mov    %esi,%edx
  800872:	eb 0f                	jmp    800883 <strncpy+0x23>
		*dst++ = *src;
  800874:	83 c2 01             	add    $0x1,%edx
  800877:	0f b6 01             	movzbl (%ecx),%eax
  80087a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087d:	80 39 01             	cmpb   $0x1,(%ecx)
  800880:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800883:	39 da                	cmp    %ebx,%edx
  800885:	75 ed                	jne    800874 <strncpy+0x14>
	}
	return ret;
}
  800887:	89 f0                	mov    %esi,%eax
  800889:	5b                   	pop    %ebx
  80088a:	5e                   	pop    %esi
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
  800892:	8b 75 08             	mov    0x8(%ebp),%esi
  800895:	8b 55 0c             	mov    0xc(%ebp),%edx
  800898:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80089b:	89 f0                	mov    %esi,%eax
  80089d:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a1:	85 c9                	test   %ecx,%ecx
  8008a3:	75 0b                	jne    8008b0 <strlcpy+0x23>
  8008a5:	eb 17                	jmp    8008be <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a7:	83 c2 01             	add    $0x1,%edx
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008b0:	39 d8                	cmp    %ebx,%eax
  8008b2:	74 07                	je     8008bb <strlcpy+0x2e>
  8008b4:	0f b6 0a             	movzbl (%edx),%ecx
  8008b7:	84 c9                	test   %cl,%cl
  8008b9:	75 ec                	jne    8008a7 <strlcpy+0x1a>
		*dst = '\0';
  8008bb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008be:	29 f0                	sub    %esi,%eax
}
  8008c0:	5b                   	pop    %ebx
  8008c1:	5e                   	pop    %esi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cd:	eb 06                	jmp    8008d5 <strcmp+0x11>
		p++, q++;
  8008cf:	83 c1 01             	add    $0x1,%ecx
  8008d2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d5:	0f b6 01             	movzbl (%ecx),%eax
  8008d8:	84 c0                	test   %al,%al
  8008da:	74 04                	je     8008e0 <strcmp+0x1c>
  8008dc:	3a 02                	cmp    (%edx),%al
  8008de:	74 ef                	je     8008cf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e0:	0f b6 c0             	movzbl %al,%eax
  8008e3:	0f b6 12             	movzbl (%edx),%edx
  8008e6:	29 d0                	sub    %edx,%eax
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f4:	89 c3                	mov    %eax,%ebx
  8008f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f9:	eb 06                	jmp    800901 <strncmp+0x17>
		n--, p++, q++;
  8008fb:	83 c0 01             	add    $0x1,%eax
  8008fe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800901:	39 d8                	cmp    %ebx,%eax
  800903:	74 16                	je     80091b <strncmp+0x31>
  800905:	0f b6 08             	movzbl (%eax),%ecx
  800908:	84 c9                	test   %cl,%cl
  80090a:	74 04                	je     800910 <strncmp+0x26>
  80090c:	3a 0a                	cmp    (%edx),%cl
  80090e:	74 eb                	je     8008fb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800910:	0f b6 00             	movzbl (%eax),%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    
		return 0;
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
  800920:	eb f6                	jmp    800918 <strncmp+0x2e>

00800922 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092c:	0f b6 10             	movzbl (%eax),%edx
  80092f:	84 d2                	test   %dl,%dl
  800931:	74 09                	je     80093c <strchr+0x1a>
		if (*s == c)
  800933:	38 ca                	cmp    %cl,%dl
  800935:	74 0a                	je     800941 <strchr+0x1f>
	for (; *s; s++)
  800937:	83 c0 01             	add    $0x1,%eax
  80093a:	eb f0                	jmp    80092c <strchr+0xa>
			return (char *) s;
	return 0;
  80093c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094d:	eb 03                	jmp    800952 <strfind+0xf>
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800955:	38 ca                	cmp    %cl,%dl
  800957:	74 04                	je     80095d <strfind+0x1a>
  800959:	84 d2                	test   %dl,%dl
  80095b:	75 f2                	jne    80094f <strfind+0xc>
			break;
	return (char *) s;
}
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	57                   	push   %edi
  800963:	56                   	push   %esi
  800964:	53                   	push   %ebx
  800965:	8b 7d 08             	mov    0x8(%ebp),%edi
  800968:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096b:	85 c9                	test   %ecx,%ecx
  80096d:	74 13                	je     800982 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80096f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800975:	75 05                	jne    80097c <memset+0x1d>
  800977:	f6 c1 03             	test   $0x3,%cl
  80097a:	74 0d                	je     800989 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	fc                   	cld    
  800980:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800982:	89 f8                	mov    %edi,%eax
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5f                   	pop    %edi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    
		c &= 0xFF;
  800989:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098d:	89 d3                	mov    %edx,%ebx
  80098f:	c1 e3 08             	shl    $0x8,%ebx
  800992:	89 d0                	mov    %edx,%eax
  800994:	c1 e0 18             	shl    $0x18,%eax
  800997:	89 d6                	mov    %edx,%esi
  800999:	c1 e6 10             	shl    $0x10,%esi
  80099c:	09 f0                	or     %esi,%eax
  80099e:	09 c2                	or     %eax,%edx
  8009a0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009a2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	fc                   	cld    
  8009a8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009aa:	eb d6                	jmp    800982 <memset+0x23>

008009ac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	57                   	push   %edi
  8009b0:	56                   	push   %esi
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ba:	39 c6                	cmp    %eax,%esi
  8009bc:	73 35                	jae    8009f3 <memmove+0x47>
  8009be:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c1:	39 c2                	cmp    %eax,%edx
  8009c3:	76 2e                	jbe    8009f3 <memmove+0x47>
		s += n;
		d += n;
  8009c5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c8:	89 d6                	mov    %edx,%esi
  8009ca:	09 fe                	or     %edi,%esi
  8009cc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d2:	74 0c                	je     8009e0 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009d4:	83 ef 01             	sub    $0x1,%edi
  8009d7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009da:	fd                   	std    
  8009db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009dd:	fc                   	cld    
  8009de:	eb 21                	jmp    800a01 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e0:	f6 c1 03             	test   $0x3,%cl
  8009e3:	75 ef                	jne    8009d4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e5:	83 ef 04             	sub    $0x4,%edi
  8009e8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009eb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ee:	fd                   	std    
  8009ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f1:	eb ea                	jmp    8009dd <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f3:	89 f2                	mov    %esi,%edx
  8009f5:	09 c2                	or     %eax,%edx
  8009f7:	f6 c2 03             	test   $0x3,%dl
  8009fa:	74 09                	je     800a05 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009fc:	89 c7                	mov    %eax,%edi
  8009fe:	fc                   	cld    
  8009ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a01:	5e                   	pop    %esi
  800a02:	5f                   	pop    %edi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a05:	f6 c1 03             	test   $0x3,%cl
  800a08:	75 f2                	jne    8009fc <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0d:	89 c7                	mov    %eax,%edi
  800a0f:	fc                   	cld    
  800a10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a12:	eb ed                	jmp    800a01 <memmove+0x55>

00800a14 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a17:	ff 75 10             	pushl  0x10(%ebp)
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	ff 75 08             	pushl  0x8(%ebp)
  800a20:	e8 87 ff ff ff       	call   8009ac <memmove>
}
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	56                   	push   %esi
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	89 c6                	mov    %eax,%esi
  800a34:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a37:	39 f0                	cmp    %esi,%eax
  800a39:	74 1c                	je     800a57 <memcmp+0x30>
		if (*s1 != *s2)
  800a3b:	0f b6 08             	movzbl (%eax),%ecx
  800a3e:	0f b6 1a             	movzbl (%edx),%ebx
  800a41:	38 d9                	cmp    %bl,%cl
  800a43:	75 08                	jne    800a4d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	83 c2 01             	add    $0x1,%edx
  800a4b:	eb ea                	jmp    800a37 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a4d:	0f b6 c1             	movzbl %cl,%eax
  800a50:	0f b6 db             	movzbl %bl,%ebx
  800a53:	29 d8                	sub    %ebx,%eax
  800a55:	eb 05                	jmp    800a5c <memcmp+0x35>
	}

	return 0;
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5c:	5b                   	pop    %ebx
  800a5d:	5e                   	pop    %esi
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a6e:	39 d0                	cmp    %edx,%eax
  800a70:	73 09                	jae    800a7b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a72:	38 08                	cmp    %cl,(%eax)
  800a74:	74 05                	je     800a7b <memfind+0x1b>
	for (; s < ends; s++)
  800a76:	83 c0 01             	add    $0x1,%eax
  800a79:	eb f3                	jmp    800a6e <memfind+0xe>
			break;
	return (void *) s;
}
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	57                   	push   %edi
  800a81:	56                   	push   %esi
  800a82:	53                   	push   %ebx
  800a83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a89:	eb 03                	jmp    800a8e <strtol+0x11>
		s++;
  800a8b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a8e:	0f b6 01             	movzbl (%ecx),%eax
  800a91:	3c 20                	cmp    $0x20,%al
  800a93:	74 f6                	je     800a8b <strtol+0xe>
  800a95:	3c 09                	cmp    $0x9,%al
  800a97:	74 f2                	je     800a8b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a99:	3c 2b                	cmp    $0x2b,%al
  800a9b:	74 2e                	je     800acb <strtol+0x4e>
	int neg = 0;
  800a9d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aa2:	3c 2d                	cmp    $0x2d,%al
  800aa4:	74 2f                	je     800ad5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aac:	75 05                	jne    800ab3 <strtol+0x36>
  800aae:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab1:	74 2c                	je     800adf <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab3:	85 db                	test   %ebx,%ebx
  800ab5:	75 0a                	jne    800ac1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ab7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800abc:	80 39 30             	cmpb   $0x30,(%ecx)
  800abf:	74 28                	je     800ae9 <strtol+0x6c>
		base = 10;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac9:	eb 50                	jmp    800b1b <strtol+0x9e>
		s++;
  800acb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ace:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad3:	eb d1                	jmp    800aa6 <strtol+0x29>
		s++, neg = 1;
  800ad5:	83 c1 01             	add    $0x1,%ecx
  800ad8:	bf 01 00 00 00       	mov    $0x1,%edi
  800add:	eb c7                	jmp    800aa6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800adf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ae3:	74 0e                	je     800af3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ae5:	85 db                	test   %ebx,%ebx
  800ae7:	75 d8                	jne    800ac1 <strtol+0x44>
		s++, base = 8;
  800ae9:	83 c1 01             	add    $0x1,%ecx
  800aec:	bb 08 00 00 00       	mov    $0x8,%ebx
  800af1:	eb ce                	jmp    800ac1 <strtol+0x44>
		s += 2, base = 16;
  800af3:	83 c1 02             	add    $0x2,%ecx
  800af6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800afb:	eb c4                	jmp    800ac1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800afd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b00:	89 f3                	mov    %esi,%ebx
  800b02:	80 fb 19             	cmp    $0x19,%bl
  800b05:	77 29                	ja     800b30 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b07:	0f be d2             	movsbl %dl,%edx
  800b0a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b0d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b10:	7d 30                	jge    800b42 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b12:	83 c1 01             	add    $0x1,%ecx
  800b15:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b19:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b1b:	0f b6 11             	movzbl (%ecx),%edx
  800b1e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b21:	89 f3                	mov    %esi,%ebx
  800b23:	80 fb 09             	cmp    $0x9,%bl
  800b26:	77 d5                	ja     800afd <strtol+0x80>
			dig = *s - '0';
  800b28:	0f be d2             	movsbl %dl,%edx
  800b2b:	83 ea 30             	sub    $0x30,%edx
  800b2e:	eb dd                	jmp    800b0d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b30:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b33:	89 f3                	mov    %esi,%ebx
  800b35:	80 fb 19             	cmp    $0x19,%bl
  800b38:	77 08                	ja     800b42 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b3a:	0f be d2             	movsbl %dl,%edx
  800b3d:	83 ea 37             	sub    $0x37,%edx
  800b40:	eb cb                	jmp    800b0d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b46:	74 05                	je     800b4d <strtol+0xd0>
		*endptr = (char *) s;
  800b48:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	f7 da                	neg    %edx
  800b51:	85 ff                	test   %edi,%edi
  800b53:	0f 45 c2             	cmovne %edx,%eax
}
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6c:	89 c3                	mov    %eax,%ebx
  800b6e:	89 c7                	mov    %eax,%edi
  800b70:	89 c6                	mov    %eax,%esi
  800b72:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <sys_cgetc>:

int
sys_cgetc(void) {
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b84:	b8 01 00 00 00       	mov    $0x1,%eax
  800b89:	89 d1                	mov    %edx,%ecx
  800b8b:	89 d3                	mov    %edx,%ebx
  800b8d:	89 d7                	mov    %edx,%edi
  800b8f:	89 d6                	mov    %edx,%esi
  800b91:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5f                   	pop    %edi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ba1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bae:	89 cb                	mov    %ecx,%ebx
  800bb0:	89 cf                	mov    %ecx,%edi
  800bb2:	89 ce                	mov    %ecx,%esi
  800bb4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bb6:	85 c0                	test   %eax,%eax
  800bb8:	7f 08                	jg     800bc2 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5f                   	pop    %edi
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bc2:	83 ec 0c             	sub    $0xc,%esp
  800bc5:	50                   	push   %eax
  800bc6:	6a 03                	push   $0x3
  800bc8:	68 e4 12 80 00       	push   $0x8012e4
  800bcd:	6a 24                	push   $0x24
  800bcf:	68 01 13 80 00       	push   $0x801301
  800bd4:	e8 1b 02 00 00       	call   800df4 <_panic>

00800bd9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	57                   	push   %edi
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800be4:	b8 02 00 00 00       	mov    $0x2,%eax
  800be9:	89 d1                	mov    %edx,%ecx
  800beb:	89 d3                	mov    %edx,%ebx
  800bed:	89 d7                	mov    %edx,%edi
  800bef:	89 d6                	mov    %edx,%esi
  800bf1:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5f                   	pop    %edi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <sys_yield>:

void
sys_yield(void)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c08:	89 d1                	mov    %edx,%ecx
  800c0a:	89 d3                	mov    %edx,%ebx
  800c0c:	89 d7                	mov    %edx,%edi
  800c0e:	89 d6                	mov    %edx,%esi
  800c10:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c20:	be 00 00 00 00       	mov    $0x0,%esi
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c33:	89 f7                	mov    %esi,%edi
  800c35:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c37:	85 c0                	test   %eax,%eax
  800c39:	7f 08                	jg     800c43 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800c47:	6a 04                	push   $0x4
  800c49:	68 e4 12 80 00       	push   $0x8012e4
  800c4e:	6a 24                	push   $0x24
  800c50:	68 01 13 80 00       	push   $0x801301
  800c55:	e8 9a 01 00 00       	call   800df4 <_panic>

00800c5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c71:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c74:	8b 75 18             	mov    0x18(%ebp),%esi
  800c77:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	7f 08                	jg     800c85 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800c89:	6a 05                	push   $0x5
  800c8b:	68 e4 12 80 00       	push   $0x8012e4
  800c90:	6a 24                	push   $0x24
  800c92:	68 01 13 80 00       	push   $0x801301
  800c97:	e8 58 01 00 00       	call   800df4 <_panic>

00800c9c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800cb0:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb5:	89 df                	mov    %ebx,%edi
  800cb7:	89 de                	mov    %ebx,%esi
  800cb9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800ccb:	6a 06                	push   $0x6
  800ccd:	68 e4 12 80 00       	push   $0x8012e4
  800cd2:	6a 24                	push   $0x24
  800cd4:	68 01 13 80 00       	push   $0x801301
  800cd9:	e8 16 01 00 00       	call   800df4 <_panic>

00800cde <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800cf2:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	89 de                	mov    %ebx,%esi
  800cfb:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	7f 08                	jg     800d09 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d0d:	6a 08                	push   $0x8
  800d0f:	68 e4 12 80 00       	push   $0x8012e4
  800d14:	6a 24                	push   $0x24
  800d16:	68 01 13 80 00       	push   $0x801301
  800d1b:	e8 d4 00 00 00       	call   800df4 <_panic>

00800d20 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
  800d26:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d34:	b8 09 00 00 00       	mov    $0x9,%eax
  800d39:	89 df                	mov    %ebx,%edi
  800d3b:	89 de                	mov    %ebx,%esi
  800d3d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7f 08                	jg     800d4b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	83 ec 0c             	sub    $0xc,%esp
  800d4e:	50                   	push   %eax
  800d4f:	6a 09                	push   $0x9
  800d51:	68 e4 12 80 00       	push   $0x8012e4
  800d56:	6a 24                	push   $0x24
  800d58:	68 01 13 80 00       	push   $0x801301
  800d5d:	e8 92 00 00 00       	call   800df4 <_panic>

00800d62 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d73:	be 00 00 00 00       	mov    $0x0,%esi
  800d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d9b:	89 cb                	mov    %ecx,%ebx
  800d9d:	89 cf                	mov    %ecx,%edi
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 0c                	push   $0xc
  800db5:	68 e4 12 80 00       	push   $0x8012e4
  800dba:	6a 24                	push   $0x24
  800dbc:	68 01 13 80 00       	push   $0x801301
  800dc1:	e8 2e 00 00 00       	call   800df4 <_panic>

00800dc6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800dcc:	68 1b 13 80 00       	push   $0x80131b
  800dd1:	6a 51                	push   $0x51
  800dd3:	68 0f 13 80 00       	push   $0x80130f
  800dd8:	e8 17 00 00 00       	call   800df4 <_panic>

00800ddd <sfork>:
}

// Challenge!
int
sfork(void)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800de3:	68 1a 13 80 00       	push   $0x80131a
  800de8:	6a 58                	push   $0x58
  800dea:	68 0f 13 80 00       	push   $0x80130f
  800def:	e8 00 00 00 00       	call   800df4 <_panic>

00800df4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800df9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800dfc:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800e02:	e8 d2 fd ff ff       	call   800bd9 <sys_getenvid>
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	ff 75 08             	pushl  0x8(%ebp)
  800e10:	56                   	push   %esi
  800e11:	50                   	push   %eax
  800e12:	68 30 13 80 00       	push   $0x801330
  800e17:	e8 a4 f3 ff ff       	call   8001c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e1c:	83 c4 18             	add    $0x18,%esp
  800e1f:	53                   	push   %ebx
  800e20:	ff 75 10             	pushl  0x10(%ebp)
  800e23:	e8 47 f3 ff ff       	call   80016f <vcprintf>
	cprintf("\n");
  800e28:	c7 04 24 8f 10 80 00 	movl   $0x80108f,(%esp)
  800e2f:	e8 8c f3 ff ff       	call   8001c0 <cprintf>
  800e34:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e37:	cc                   	int3   
  800e38:	eb fd                	jmp    800e37 <_panic+0x43>
  800e3a:	66 90                	xchg   %ax,%ax
  800e3c:	66 90                	xchg   %ax,%ax
  800e3e:	66 90                	xchg   %ax,%ax

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
