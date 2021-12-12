
obj/user/stresssched：     文件格式 elf32-i386


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
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 e7 0b 00 00       	call   800c24 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 c8 0d 00 00       	call   800e11 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 e9 0b 00 00       	call   800c43 <sys_yield>
		return;
  80005a:	eb 6e                	jmp    8000ca <umain+0x97>
	if (i == 20) {
  80005c:	83 fb 14             	cmp    $0x14,%ebx
  80005f:	74 f4                	je     800055 <umain+0x22>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800061:	89 f0                	mov    %esi,%eax
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	eb 02                	jmp    800074 <umain+0x41>
		asm volatile("pause");
  800072:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800074:	8b 50 54             	mov    0x54(%eax),%edx
  800077:	85 d2                	test   %edx,%edx
  800079:	75 f7                	jne    800072 <umain+0x3f>
  80007b:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800080:	e8 be 0b 00 00       	call   800c43 <sys_yield>
  800085:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008a:	a1 04 20 80 00       	mov    0x802004,%eax
  80008f:	83 c0 01             	add    $0x1,%eax
  800092:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800097:	83 ea 01             	sub    $0x1,%edx
  80009a:	75 ee                	jne    80008a <umain+0x57>
	for (i = 0; i < 10; i++) {
  80009c:	83 eb 01             	sub    $0x1,%ebx
  80009f:	75 df                	jne    800080 <umain+0x4d>
	}

	if (counter != 10*10000)
  8000a1:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a6:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000ab:	75 24                	jne    8000d1 <umain+0x9e>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ad:	a1 08 20 80 00       	mov    0x802008,%eax
  8000b2:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b5:	8b 40 48             	mov    0x48(%eax),%eax
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	52                   	push   %edx
  8000bc:	50                   	push   %eax
  8000bd:	68 bb 10 80 00       	push   $0x8010bb
  8000c2:	e8 44 01 00 00       	call   80020b <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp

}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d1:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d6:	50                   	push   %eax
  8000d7:	68 80 10 80 00       	push   $0x801080
  8000dc:	6a 21                	push   $0x21
  8000de:	68 a8 10 80 00       	push   $0x8010a8
  8000e3:	e8 48 00 00 00       	call   800130 <_panic>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	83 ec 08             	sub    $0x8,%esp
  8000ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8000f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000f4:	c7 05 08 20 80 00 00 	movl   $0xeec00000,0x802008
  8000fb:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 c0                	test   %eax,%eax
  800100:	7e 08                	jle    80010a <libmain+0x22>
		binaryname = argv[0];
  800102:	8b 0a                	mov    (%edx),%ecx
  800104:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	52                   	push   %edx
  80010e:	50                   	push   %eax
  80010f:	e8 1f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800114:	e8 05 00 00 00       	call   80011e <exit>
}
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    

0080011e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800124:	6a 00                	push   $0x0
  800126:	e8 b8 0a 00 00       	call   800be3 <sys_env_destroy>
}
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800135:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800138:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80013e:	e8 e1 0a 00 00       	call   800c24 <sys_getenvid>
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 75 0c             	pushl  0xc(%ebp)
  800149:	ff 75 08             	pushl  0x8(%ebp)
  80014c:	56                   	push   %esi
  80014d:	50                   	push   %eax
  80014e:	68 e4 10 80 00       	push   $0x8010e4
  800153:	e8 b3 00 00 00       	call   80020b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800158:	83 c4 18             	add    $0x18,%esp
  80015b:	53                   	push   %ebx
  80015c:	ff 75 10             	pushl  0x10(%ebp)
  80015f:	e8 56 00 00 00       	call   8001ba <vcprintf>
	cprintf("\n");
  800164:	c7 04 24 d7 10 80 00 	movl   $0x8010d7,(%esp)
  80016b:	e8 9b 00 00 00       	call   80020b <cprintf>
  800170:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800173:	cc                   	int3   
  800174:	eb fd                	jmp    800173 <_panic+0x43>

00800176 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	53                   	push   %ebx
  80017a:	83 ec 04             	sub    $0x4,%esp
  80017d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800180:	8b 13                	mov    (%ebx),%edx
  800182:	8d 42 01             	lea    0x1(%edx),%eax
  800185:	89 03                	mov    %eax,(%ebx)
  800187:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800193:	74 09                	je     80019e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800195:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	68 ff 00 00 00       	push   $0xff
  8001a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a9:	50                   	push   %eax
  8001aa:	e8 f7 09 00 00       	call   800ba6 <sys_cputs>
		b->idx = 0;
  8001af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b5:	83 c4 10             	add    $0x10,%esp
  8001b8:	eb db                	jmp    800195 <putch+0x1f>

008001ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ca:	00 00 00 
	b.cnt = 0;
  8001cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d7:	ff 75 0c             	pushl  0xc(%ebp)
  8001da:	ff 75 08             	pushl  0x8(%ebp)
  8001dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e3:	50                   	push   %eax
  8001e4:	68 76 01 80 00       	push   $0x800176
  8001e9:	e8 1a 01 00 00       	call   800308 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ee:	83 c4 08             	add    $0x8,%esp
  8001f1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fd:	50                   	push   %eax
  8001fe:	e8 a3 09 00 00       	call   800ba6 <sys_cputs>

	return b.cnt;
}
  800203:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800211:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800214:	50                   	push   %eax
  800215:	ff 75 08             	pushl  0x8(%ebp)
  800218:	e8 9d ff ff ff       	call   8001ba <vcprintf>
	va_end(ap);

	return cnt;
}
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    

0080021f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	57                   	push   %edi
  800223:	56                   	push   %esi
  800224:	53                   	push   %ebx
  800225:	83 ec 1c             	sub    $0x1c,%esp
  800228:	89 c7                	mov    %eax,%edi
  80022a:	89 d6                	mov    %edx,%esi
  80022c:	8b 45 08             	mov    0x8(%ebp),%eax
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800235:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800238:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800243:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800246:	39 d3                	cmp    %edx,%ebx
  800248:	72 05                	jb     80024f <printnum+0x30>
  80024a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80024d:	77 7a                	ja     8002c9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 18             	pushl  0x18(%ebp)
  800255:	8b 45 14             	mov    0x14(%ebp),%eax
  800258:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80025b:	53                   	push   %ebx
  80025c:	ff 75 10             	pushl  0x10(%ebp)
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 e4             	pushl  -0x1c(%ebp)
  800265:	ff 75 e0             	pushl  -0x20(%ebp)
  800268:	ff 75 dc             	pushl  -0x24(%ebp)
  80026b:	ff 75 d8             	pushl  -0x28(%ebp)
  80026e:	e8 cd 0b 00 00       	call   800e40 <__udivdi3>
  800273:	83 c4 18             	add    $0x18,%esp
  800276:	52                   	push   %edx
  800277:	50                   	push   %eax
  800278:	89 f2                	mov    %esi,%edx
  80027a:	89 f8                	mov    %edi,%eax
  80027c:	e8 9e ff ff ff       	call   80021f <printnum>
  800281:	83 c4 20             	add    $0x20,%esp
  800284:	eb 13                	jmp    800299 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	56                   	push   %esi
  80028a:	ff 75 18             	pushl  0x18(%ebp)
  80028d:	ff d7                	call   *%edi
  80028f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800292:	83 eb 01             	sub    $0x1,%ebx
  800295:	85 db                	test   %ebx,%ebx
  800297:	7f ed                	jg     800286 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	56                   	push   %esi
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ac:	e8 af 0c 00 00       	call   800f60 <__umoddi3>
  8002b1:	83 c4 14             	add    $0x14,%esp
  8002b4:	0f be 80 08 11 80 00 	movsbl 0x801108(%eax),%eax
  8002bb:	50                   	push   %eax
  8002bc:	ff d7                	call   *%edi
}
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5f                   	pop    %edi
  8002c7:	5d                   	pop    %ebp
  8002c8:	c3                   	ret    
  8002c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002cc:	eb c4                	jmp    800292 <printnum+0x73>

008002ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d8:	8b 10                	mov    (%eax),%edx
  8002da:	3b 50 04             	cmp    0x4(%eax),%edx
  8002dd:	73 0a                	jae    8002e9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e2:	89 08                	mov    %ecx,(%eax)
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	88 02                	mov    %al,(%edx)
}
  8002e9:	5d                   	pop    %ebp
  8002ea:	c3                   	ret    

008002eb <printfmt>:
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f4:	50                   	push   %eax
  8002f5:	ff 75 10             	pushl  0x10(%ebp)
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	e8 05 00 00 00       	call   800308 <vprintfmt>
}
  800303:	83 c4 10             	add    $0x10,%esp
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <vprintfmt>:
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	57                   	push   %edi
  80030c:	56                   	push   %esi
  80030d:	53                   	push   %ebx
  80030e:	83 ec 2c             	sub    $0x2c,%esp
  800311:	8b 75 08             	mov    0x8(%ebp),%esi
  800314:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800317:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031a:	e9 00 04 00 00       	jmp    80071f <vprintfmt+0x417>
		padc = ' ';
  80031f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800323:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80032a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800331:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800338:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	8d 47 01             	lea    0x1(%edi),%eax
  800340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800343:	0f b6 17             	movzbl (%edi),%edx
  800346:	8d 42 dd             	lea    -0x23(%edx),%eax
  800349:	3c 55                	cmp    $0x55,%al
  80034b:	0f 87 51 04 00 00    	ja     8007a2 <vprintfmt+0x49a>
  800351:	0f b6 c0             	movzbl %al,%eax
  800354:	ff 24 85 c0 11 80 00 	jmp    *0x8011c0(,%eax,4)
  80035b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80035e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800362:	eb d9                	jmp    80033d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800367:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80036b:	eb d0                	jmp    80033d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	0f b6 d2             	movzbl %dl,%edx
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800373:	b8 00 00 00 00       	mov    $0x0,%eax
  800378:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80037b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80037e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800382:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800385:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800388:	83 f9 09             	cmp    $0x9,%ecx
  80038b:	77 55                	ja     8003e2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80038d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800390:	eb e9                	jmp    80037b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80039a:	8b 45 14             	mov    0x14(%ebp),%eax
  80039d:	8d 40 04             	lea    0x4(%eax),%eax
  8003a0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003aa:	79 91                	jns    80033d <vprintfmt+0x35>
				width = precision, precision = -1;
  8003ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b9:	eb 82                	jmp    80033d <vprintfmt+0x35>
  8003bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c5:	0f 49 d0             	cmovns %eax,%edx
  8003c8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ce:	e9 6a ff ff ff       	jmp    80033d <vprintfmt+0x35>
  8003d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003dd:	e9 5b ff ff ff       	jmp    80033d <vprintfmt+0x35>
  8003e2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e8:	eb bc                	jmp    8003a6 <vprintfmt+0x9e>
			lflag++;
  8003ea:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f0:	e9 48 ff ff ff       	jmp    80033d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f8:	8d 78 04             	lea    0x4(%eax),%edi
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	53                   	push   %ebx
  8003ff:	ff 30                	pushl  (%eax)
  800401:	ff d6                	call   *%esi
			break;
  800403:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800406:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800409:	e9 0e 03 00 00       	jmp    80071c <vprintfmt+0x414>
			err = va_arg(ap, int);
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8d 78 04             	lea    0x4(%eax),%edi
  800414:	8b 00                	mov    (%eax),%eax
  800416:	99                   	cltd   
  800417:	31 d0                	xor    %edx,%eax
  800419:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041b:	83 f8 08             	cmp    $0x8,%eax
  80041e:	7f 23                	jg     800443 <vprintfmt+0x13b>
  800420:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  800427:	85 d2                	test   %edx,%edx
  800429:	74 18                	je     800443 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80042b:	52                   	push   %edx
  80042c:	68 29 11 80 00       	push   $0x801129
  800431:	53                   	push   %ebx
  800432:	56                   	push   %esi
  800433:	e8 b3 fe ff ff       	call   8002eb <printfmt>
  800438:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80043e:	e9 d9 02 00 00       	jmp    80071c <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800443:	50                   	push   %eax
  800444:	68 20 11 80 00       	push   $0x801120
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 9b fe ff ff       	call   8002eb <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800456:	e9 c1 02 00 00       	jmp    80071c <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	83 c0 04             	add    $0x4,%eax
  800461:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800469:	85 ff                	test   %edi,%edi
  80046b:	b8 19 11 80 00       	mov    $0x801119,%eax
  800470:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800473:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800477:	0f 8e bd 00 00 00    	jle    80053a <vprintfmt+0x232>
  80047d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800481:	75 0e                	jne    800491 <vprintfmt+0x189>
  800483:	89 75 08             	mov    %esi,0x8(%ebp)
  800486:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800489:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048f:	eb 6d                	jmp    8004fe <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	ff 75 d0             	pushl  -0x30(%ebp)
  800497:	57                   	push   %edi
  800498:	e8 ad 03 00 00       	call   80084a <strnlen>
  80049d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a0:	29 c1                	sub    %eax,%ecx
  8004a2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004a5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004af:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004b2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b4:	eb 0f                	jmp    8004c5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	53                   	push   %ebx
  8004ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bf:	83 ef 01             	sub    $0x1,%edi
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	85 ff                	test   %edi,%edi
  8004c7:	7f ed                	jg     8004b6 <vprintfmt+0x1ae>
  8004c9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004cc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004cf:	85 c9                	test   %ecx,%ecx
  8004d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d6:	0f 49 c1             	cmovns %ecx,%eax
  8004d9:	29 c1                	sub    %eax,%ecx
  8004db:	89 75 08             	mov    %esi,0x8(%ebp)
  8004de:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e4:	89 cb                	mov    %ecx,%ebx
  8004e6:	eb 16                	jmp    8004fe <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ec:	75 31                	jne    80051f <vprintfmt+0x217>
					putch(ch, putdat);
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	ff 75 0c             	pushl  0xc(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 55 08             	call   *0x8(%ebp)
  8004f8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004fb:	83 eb 01             	sub    $0x1,%ebx
  8004fe:	83 c7 01             	add    $0x1,%edi
  800501:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800505:	0f be c2             	movsbl %dl,%eax
  800508:	85 c0                	test   %eax,%eax
  80050a:	74 59                	je     800565 <vprintfmt+0x25d>
  80050c:	85 f6                	test   %esi,%esi
  80050e:	78 d8                	js     8004e8 <vprintfmt+0x1e0>
  800510:	83 ee 01             	sub    $0x1,%esi
  800513:	79 d3                	jns    8004e8 <vprintfmt+0x1e0>
  800515:	89 df                	mov    %ebx,%edi
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
  80051a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051d:	eb 37                	jmp    800556 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80051f:	0f be d2             	movsbl %dl,%edx
  800522:	83 ea 20             	sub    $0x20,%edx
  800525:	83 fa 5e             	cmp    $0x5e,%edx
  800528:	76 c4                	jbe    8004ee <vprintfmt+0x1e6>
					putch('?', putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	6a 3f                	push   $0x3f
  800532:	ff 55 08             	call   *0x8(%ebp)
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	eb c1                	jmp    8004fb <vprintfmt+0x1f3>
  80053a:	89 75 08             	mov    %esi,0x8(%ebp)
  80053d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800540:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800543:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800546:	eb b6                	jmp    8004fe <vprintfmt+0x1f6>
				putch(' ', putdat);
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	53                   	push   %ebx
  80054c:	6a 20                	push   $0x20
  80054e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800550:	83 ef 01             	sub    $0x1,%edi
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	85 ff                	test   %edi,%edi
  800558:	7f ee                	jg     800548 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80055a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
  800560:	e9 b7 01 00 00       	jmp    80071c <vprintfmt+0x414>
  800565:	89 df                	mov    %ebx,%edi
  800567:	8b 75 08             	mov    0x8(%ebp),%esi
  80056a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80056d:	eb e7                	jmp    800556 <vprintfmt+0x24e>
	if (lflag >= 2)
  80056f:	83 f9 01             	cmp    $0x1,%ecx
  800572:	7e 3f                	jle    8005b3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 50 04             	mov    0x4(%eax),%edx
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8d 40 08             	lea    0x8(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80058b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058f:	79 5c                	jns    8005ed <vprintfmt+0x2e5>
				putch('-', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 2d                	push   $0x2d
  800597:	ff d6                	call   *%esi
				num = -(long long) num;
  800599:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059f:	f7 da                	neg    %edx
  8005a1:	83 d1 00             	adc    $0x0,%ecx
  8005a4:	f7 d9                	neg    %ecx
  8005a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ae:	e9 4f 01 00 00       	jmp    800702 <vprintfmt+0x3fa>
	else if (lflag)
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	75 1b                	jne    8005d2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb b9                	jmp    80058b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005da:	89 c1                	mov    %eax,%ecx
  8005dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb 9e                	jmp    80058b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 05 01 00 00       	jmp    800702 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005fd:	83 f9 01             	cmp    $0x1,%ecx
  800600:	7e 18                	jle    80061a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8b 10                	mov    (%eax),%edx
  800607:	8b 48 04             	mov    0x4(%eax),%ecx
  80060a:	8d 40 08             	lea    0x8(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800610:	b8 0a 00 00 00       	mov    $0xa,%eax
  800615:	e9 e8 00 00 00       	jmp    800702 <vprintfmt+0x3fa>
	else if (lflag)
  80061a:	85 c9                	test   %ecx,%ecx
  80061c:	75 1a                	jne    800638 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 10                	mov    (%eax),%edx
  800623:	b9 00 00 00 00       	mov    $0x0,%ecx
  800628:	8d 40 04             	lea    0x4(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800633:	e9 ca 00 00 00       	jmp    800702 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 10                	mov    (%eax),%edx
  80063d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800648:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064d:	e9 b0 00 00 00       	jmp    800702 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800652:	83 f9 01             	cmp    $0x1,%ecx
  800655:	7e 3c                	jle    800693 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 50 04             	mov    0x4(%eax),%edx
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 08             	lea    0x8(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80066e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800672:	79 59                	jns    8006cd <vprintfmt+0x3c5>
                putch('-', putdat);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	6a 2d                	push   $0x2d
  80067a:	ff d6                	call   *%esi
                num = -(long long) num;
  80067c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80067f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800682:	f7 da                	neg    %edx
  800684:	83 d1 00             	adc    $0x0,%ecx
  800687:	f7 d9                	neg    %ecx
  800689:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80068c:	b8 08 00 00 00       	mov    $0x8,%eax
  800691:	eb 6f                	jmp    800702 <vprintfmt+0x3fa>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	75 1b                	jne    8006b2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b0:	eb bc                	jmp    80066e <vprintfmt+0x366>
		return va_arg(*ap, long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ba:	89 c1                	mov    %eax,%ecx
  8006bc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cb:	eb a1                	jmp    80066e <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d8:	eb 28                	jmp    800702 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	6a 30                	push   $0x30
  8006e0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e2:	83 c4 08             	add    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	6a 78                	push   $0x78
  8006e8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 10                	mov    (%eax),%edx
  8006ef:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006f4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800702:	83 ec 0c             	sub    $0xc,%esp
  800705:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800709:	57                   	push   %edi
  80070a:	ff 75 e0             	pushl  -0x20(%ebp)
  80070d:	50                   	push   %eax
  80070e:	51                   	push   %ecx
  80070f:	52                   	push   %edx
  800710:	89 da                	mov    %ebx,%edx
  800712:	89 f0                	mov    %esi,%eax
  800714:	e8 06 fb ff ff       	call   80021f <printnum>
			break;
  800719:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80071c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071f:	83 c7 01             	add    $0x1,%edi
  800722:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800726:	83 f8 25             	cmp    $0x25,%eax
  800729:	0f 84 f0 fb ff ff    	je     80031f <vprintfmt+0x17>
			if (ch == '\0')
  80072f:	85 c0                	test   %eax,%eax
  800731:	0f 84 8b 00 00 00    	je     8007c2 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	53                   	push   %ebx
  80073b:	50                   	push   %eax
  80073c:	ff d6                	call   *%esi
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	eb dc                	jmp    80071f <vprintfmt+0x417>
	if (lflag >= 2)
  800743:	83 f9 01             	cmp    $0x1,%ecx
  800746:	7e 15                	jle    80075d <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 10                	mov    (%eax),%edx
  80074d:	8b 48 04             	mov    0x4(%eax),%ecx
  800750:	8d 40 08             	lea    0x8(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800756:	b8 10 00 00 00       	mov    $0x10,%eax
  80075b:	eb a5                	jmp    800702 <vprintfmt+0x3fa>
	else if (lflag)
  80075d:	85 c9                	test   %ecx,%ecx
  80075f:	75 17                	jne    800778 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 10                	mov    (%eax),%edx
  800766:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800771:	b8 10 00 00 00       	mov    $0x10,%eax
  800776:	eb 8a                	jmp    800702 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 10                	mov    (%eax),%edx
  80077d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800782:	8d 40 04             	lea    0x4(%eax),%eax
  800785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800788:	b8 10 00 00 00       	mov    $0x10,%eax
  80078d:	e9 70 ff ff ff       	jmp    800702 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	53                   	push   %ebx
  800796:	6a 25                	push   $0x25
  800798:	ff d6                	call   *%esi
			break;
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	e9 7a ff ff ff       	jmp    80071c <vprintfmt+0x414>
			putch('%', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	53                   	push   %ebx
  8007a6:	6a 25                	push   $0x25
  8007a8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	89 f8                	mov    %edi,%eax
  8007af:	eb 03                	jmp    8007b4 <vprintfmt+0x4ac>
  8007b1:	83 e8 01             	sub    $0x1,%eax
  8007b4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007b8:	75 f7                	jne    8007b1 <vprintfmt+0x4a9>
  8007ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007bd:	e9 5a ff ff ff       	jmp    80071c <vprintfmt+0x414>
}
  8007c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c5:	5b                   	pop    %ebx
  8007c6:	5e                   	pop    %esi
  8007c7:	5f                   	pop    %edi
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 18             	sub    $0x18,%esp
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007dd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	74 26                	je     800811 <vsnprintf+0x47>
  8007eb:	85 d2                	test   %edx,%edx
  8007ed:	7e 22                	jle    800811 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ef:	ff 75 14             	pushl  0x14(%ebp)
  8007f2:	ff 75 10             	pushl  0x10(%ebp)
  8007f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f8:	50                   	push   %eax
  8007f9:	68 ce 02 80 00       	push   $0x8002ce
  8007fe:	e8 05 fb ff ff       	call   800308 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800806:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080c:	83 c4 10             	add    $0x10,%esp
}
  80080f:	c9                   	leave  
  800810:	c3                   	ret    
		return -E_INVAL;
  800811:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800816:	eb f7                	jmp    80080f <vsnprintf+0x45>

00800818 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80081e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800821:	50                   	push   %eax
  800822:	ff 75 10             	pushl  0x10(%ebp)
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	ff 75 08             	pushl  0x8(%ebp)
  80082b:	e8 9a ff ff ff       	call   8007ca <vsnprintf>
	va_end(ap);

	return rc;
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800838:	b8 00 00 00 00       	mov    $0x0,%eax
  80083d:	eb 03                	jmp    800842 <strlen+0x10>
		n++;
  80083f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800842:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800846:	75 f7                	jne    80083f <strlen+0xd>
	return n;
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800850:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800853:	b8 00 00 00 00       	mov    $0x0,%eax
  800858:	eb 03                	jmp    80085d <strnlen+0x13>
		n++;
  80085a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085d:	39 d0                	cmp    %edx,%eax
  80085f:	74 06                	je     800867 <strnlen+0x1d>
  800861:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800865:	75 f3                	jne    80085a <strnlen+0x10>
	return n;
}
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	53                   	push   %ebx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800873:	89 c2                	mov    %eax,%edx
  800875:	83 c1 01             	add    $0x1,%ecx
  800878:	83 c2 01             	add    $0x1,%edx
  80087b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80087f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800882:	84 db                	test   %bl,%bl
  800884:	75 ef                	jne    800875 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800886:	5b                   	pop    %ebx
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800890:	53                   	push   %ebx
  800891:	e8 9c ff ff ff       	call   800832 <strlen>
  800896:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	01 d8                	add    %ebx,%eax
  80089e:	50                   	push   %eax
  80089f:	e8 c5 ff ff ff       	call   800869 <strcpy>
	return dst;
}
  8008a4:	89 d8                	mov    %ebx,%eax
  8008a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a9:	c9                   	leave  
  8008aa:	c3                   	ret    

008008ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	56                   	push   %esi
  8008af:	53                   	push   %ebx
  8008b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b6:	89 f3                	mov    %esi,%ebx
  8008b8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008bb:	89 f2                	mov    %esi,%edx
  8008bd:	eb 0f                	jmp    8008ce <strncpy+0x23>
		*dst++ = *src;
  8008bf:	83 c2 01             	add    $0x1,%edx
  8008c2:	0f b6 01             	movzbl (%ecx),%eax
  8008c5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c8:	80 39 01             	cmpb   $0x1,(%ecx)
  8008cb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008ce:	39 da                	cmp    %ebx,%edx
  8008d0:	75 ed                	jne    8008bf <strncpy+0x14>
	}
	return ret;
}
  8008d2:	89 f0                	mov    %esi,%eax
  8008d4:	5b                   	pop    %ebx
  8008d5:	5e                   	pop    %esi
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008e6:	89 f0                	mov    %esi,%eax
  8008e8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ec:	85 c9                	test   %ecx,%ecx
  8008ee:	75 0b                	jne    8008fb <strlcpy+0x23>
  8008f0:	eb 17                	jmp    800909 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f2:	83 c2 01             	add    $0x1,%edx
  8008f5:	83 c0 01             	add    $0x1,%eax
  8008f8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008fb:	39 d8                	cmp    %ebx,%eax
  8008fd:	74 07                	je     800906 <strlcpy+0x2e>
  8008ff:	0f b6 0a             	movzbl (%edx),%ecx
  800902:	84 c9                	test   %cl,%cl
  800904:	75 ec                	jne    8008f2 <strlcpy+0x1a>
		*dst = '\0';
  800906:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800909:	29 f0                	sub    %esi,%eax
}
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800918:	eb 06                	jmp    800920 <strcmp+0x11>
		p++, q++;
  80091a:	83 c1 01             	add    $0x1,%ecx
  80091d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800920:	0f b6 01             	movzbl (%ecx),%eax
  800923:	84 c0                	test   %al,%al
  800925:	74 04                	je     80092b <strcmp+0x1c>
  800927:	3a 02                	cmp    (%edx),%al
  800929:	74 ef                	je     80091a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80092b:	0f b6 c0             	movzbl %al,%eax
  80092e:	0f b6 12             	movzbl (%edx),%edx
  800931:	29 d0                	sub    %edx,%eax
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093f:	89 c3                	mov    %eax,%ebx
  800941:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800944:	eb 06                	jmp    80094c <strncmp+0x17>
		n--, p++, q++;
  800946:	83 c0 01             	add    $0x1,%eax
  800949:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80094c:	39 d8                	cmp    %ebx,%eax
  80094e:	74 16                	je     800966 <strncmp+0x31>
  800950:	0f b6 08             	movzbl (%eax),%ecx
  800953:	84 c9                	test   %cl,%cl
  800955:	74 04                	je     80095b <strncmp+0x26>
  800957:	3a 0a                	cmp    (%edx),%cl
  800959:	74 eb                	je     800946 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80095b:	0f b6 00             	movzbl (%eax),%eax
  80095e:	0f b6 12             	movzbl (%edx),%edx
  800961:	29 d0                	sub    %edx,%eax
}
  800963:	5b                   	pop    %ebx
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    
		return 0;
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb f6                	jmp    800963 <strncmp+0x2e>

0080096d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800977:	0f b6 10             	movzbl (%eax),%edx
  80097a:	84 d2                	test   %dl,%dl
  80097c:	74 09                	je     800987 <strchr+0x1a>
		if (*s == c)
  80097e:	38 ca                	cmp    %cl,%dl
  800980:	74 0a                	je     80098c <strchr+0x1f>
	for (; *s; s++)
  800982:	83 c0 01             	add    $0x1,%eax
  800985:	eb f0                	jmp    800977 <strchr+0xa>
			return (char *) s;
	return 0;
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	eb 03                	jmp    80099d <strfind+0xf>
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009a0:	38 ca                	cmp    %cl,%dl
  8009a2:	74 04                	je     8009a8 <strfind+0x1a>
  8009a4:	84 d2                	test   %dl,%dl
  8009a6:	75 f2                	jne    80099a <strfind+0xc>
			break;
	return (char *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	57                   	push   %edi
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b6:	85 c9                	test   %ecx,%ecx
  8009b8:	74 13                	je     8009cd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ba:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009c0:	75 05                	jne    8009c7 <memset+0x1d>
  8009c2:	f6 c1 03             	test   $0x3,%cl
  8009c5:	74 0d                	je     8009d4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ca:	fc                   	cld    
  8009cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009cd:	89 f8                	mov    %edi,%eax
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5f                   	pop    %edi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	c1 e0 18             	shl    $0x18,%eax
  8009e2:	89 d6                	mov    %edx,%esi
  8009e4:	c1 e6 10             	shl    $0x10,%esi
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009ed:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f0:	89 d0                	mov    %edx,%eax
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb d6                	jmp    8009cd <memset+0x23>

008009f7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	57                   	push   %edi
  8009fb:	56                   	push   %esi
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a05:	39 c6                	cmp    %eax,%esi
  800a07:	73 35                	jae    800a3e <memmove+0x47>
  800a09:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0c:	39 c2                	cmp    %eax,%edx
  800a0e:	76 2e                	jbe    800a3e <memmove+0x47>
		s += n;
		d += n;
  800a10:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a13:	89 d6                	mov    %edx,%esi
  800a15:	09 fe                	or     %edi,%esi
  800a17:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a1d:	74 0c                	je     800a2b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1f:	83 ef 01             	sub    $0x1,%edi
  800a22:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a25:	fd                   	std    
  800a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a28:	fc                   	cld    
  800a29:	eb 21                	jmp    800a4c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	f6 c1 03             	test   $0x3,%cl
  800a2e:	75 ef                	jne    800a1f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a30:	83 ef 04             	sub    $0x4,%edi
  800a33:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a39:	fd                   	std    
  800a3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3c:	eb ea                	jmp    800a28 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3e:	89 f2                	mov    %esi,%edx
  800a40:	09 c2                	or     %eax,%edx
  800a42:	f6 c2 03             	test   $0x3,%dl
  800a45:	74 09                	je     800a50 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a47:	89 c7                	mov    %eax,%edi
  800a49:	fc                   	cld    
  800a4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a4c:	5e                   	pop    %esi
  800a4d:	5f                   	pop    %edi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a50:	f6 c1 03             	test   $0x3,%cl
  800a53:	75 f2                	jne    800a47 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a55:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a58:	89 c7                	mov    %eax,%edi
  800a5a:	fc                   	cld    
  800a5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5d:	eb ed                	jmp    800a4c <memmove+0x55>

00800a5f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a62:	ff 75 10             	pushl  0x10(%ebp)
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	ff 75 08             	pushl  0x8(%ebp)
  800a6b:	e8 87 ff ff ff       	call   8009f7 <memmove>
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7d:	89 c6                	mov    %eax,%esi
  800a7f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a82:	39 f0                	cmp    %esi,%eax
  800a84:	74 1c                	je     800aa2 <memcmp+0x30>
		if (*s1 != *s2)
  800a86:	0f b6 08             	movzbl (%eax),%ecx
  800a89:	0f b6 1a             	movzbl (%edx),%ebx
  800a8c:	38 d9                	cmp    %bl,%cl
  800a8e:	75 08                	jne    800a98 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	83 c2 01             	add    $0x1,%edx
  800a96:	eb ea                	jmp    800a82 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a98:	0f b6 c1             	movzbl %cl,%eax
  800a9b:	0f b6 db             	movzbl %bl,%ebx
  800a9e:	29 d8                	sub    %ebx,%eax
  800aa0:	eb 05                	jmp    800aa7 <memcmp+0x35>
	}

	return 0;
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab4:	89 c2                	mov    %eax,%edx
  800ab6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab9:	39 d0                	cmp    %edx,%eax
  800abb:	73 09                	jae    800ac6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800abd:	38 08                	cmp    %cl,(%eax)
  800abf:	74 05                	je     800ac6 <memfind+0x1b>
	for (; s < ends; s++)
  800ac1:	83 c0 01             	add    $0x1,%eax
  800ac4:	eb f3                	jmp    800ab9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad4:	eb 03                	jmp    800ad9 <strtol+0x11>
		s++;
  800ad6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad9:	0f b6 01             	movzbl (%ecx),%eax
  800adc:	3c 20                	cmp    $0x20,%al
  800ade:	74 f6                	je     800ad6 <strtol+0xe>
  800ae0:	3c 09                	cmp    $0x9,%al
  800ae2:	74 f2                	je     800ad6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ae4:	3c 2b                	cmp    $0x2b,%al
  800ae6:	74 2e                	je     800b16 <strtol+0x4e>
	int neg = 0;
  800ae8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aed:	3c 2d                	cmp    $0x2d,%al
  800aef:	74 2f                	je     800b20 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af7:	75 05                	jne    800afe <strtol+0x36>
  800af9:	80 39 30             	cmpb   $0x30,(%ecx)
  800afc:	74 2c                	je     800b2a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800afe:	85 db                	test   %ebx,%ebx
  800b00:	75 0a                	jne    800b0c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b02:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b07:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0a:	74 28                	je     800b34 <strtol+0x6c>
		base = 10;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b14:	eb 50                	jmp    800b66 <strtol+0x9e>
		s++;
  800b16:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1e:	eb d1                	jmp    800af1 <strtol+0x29>
		s++, neg = 1;
  800b20:	83 c1 01             	add    $0x1,%ecx
  800b23:	bf 01 00 00 00       	mov    $0x1,%edi
  800b28:	eb c7                	jmp    800af1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b2e:	74 0e                	je     800b3e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b30:	85 db                	test   %ebx,%ebx
  800b32:	75 d8                	jne    800b0c <strtol+0x44>
		s++, base = 8;
  800b34:	83 c1 01             	add    $0x1,%ecx
  800b37:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b3c:	eb ce                	jmp    800b0c <strtol+0x44>
		s += 2, base = 16;
  800b3e:	83 c1 02             	add    $0x2,%ecx
  800b41:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b46:	eb c4                	jmp    800b0c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b48:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4b:	89 f3                	mov    %esi,%ebx
  800b4d:	80 fb 19             	cmp    $0x19,%bl
  800b50:	77 29                	ja     800b7b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b52:	0f be d2             	movsbl %dl,%edx
  800b55:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b58:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5b:	7d 30                	jge    800b8d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b5d:	83 c1 01             	add    $0x1,%ecx
  800b60:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b64:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b66:	0f b6 11             	movzbl (%ecx),%edx
  800b69:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b6c:	89 f3                	mov    %esi,%ebx
  800b6e:	80 fb 09             	cmp    $0x9,%bl
  800b71:	77 d5                	ja     800b48 <strtol+0x80>
			dig = *s - '0';
  800b73:	0f be d2             	movsbl %dl,%edx
  800b76:	83 ea 30             	sub    $0x30,%edx
  800b79:	eb dd                	jmp    800b58 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b7b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b7e:	89 f3                	mov    %esi,%ebx
  800b80:	80 fb 19             	cmp    $0x19,%bl
  800b83:	77 08                	ja     800b8d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b85:	0f be d2             	movsbl %dl,%edx
  800b88:	83 ea 37             	sub    $0x37,%edx
  800b8b:	eb cb                	jmp    800b58 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	74 05                	je     800b98 <strtol+0xd0>
		*endptr = (char *) s;
  800b93:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b96:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b98:	89 c2                	mov    %eax,%edx
  800b9a:	f7 da                	neg    %edx
  800b9c:	85 ff                	test   %edi,%edi
  800b9e:	0f 45 c2             	cmovne %edx,%eax
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb7:	89 c3                	mov    %eax,%ebx
  800bb9:	89 c7                	mov    %eax,%edi
  800bbb:	89 c6                	mov    %eax,%esi
  800bbd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_cgetc>:

int
sys_cgetc(void) {
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bca:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd4:	89 d1                	mov    %edx,%ecx
  800bd6:	89 d3                	mov    %edx,%ebx
  800bd8:	89 d7                	mov    %edx,%edi
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf9:	89 cb                	mov    %ecx,%ebx
  800bfb:	89 cf                	mov    %ecx,%edi
  800bfd:	89 ce                	mov    %ecx,%esi
  800bff:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c01:	85 c0                	test   %eax,%eax
  800c03:	7f 08                	jg     800c0d <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c0d:	83 ec 0c             	sub    $0xc,%esp
  800c10:	50                   	push   %eax
  800c11:	6a 03                	push   $0x3
  800c13:	68 44 13 80 00       	push   $0x801344
  800c18:	6a 24                	push   $0x24
  800c1a:	68 61 13 80 00       	push   $0x801361
  800c1f:	e8 0c f5 ff ff       	call   800130 <_panic>

00800c24 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c34:	89 d1                	mov    %edx,%ecx
  800c36:	89 d3                	mov    %edx,%ebx
  800c38:	89 d7                	mov    %edx,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_yield>:

void
sys_yield(void)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c53:	89 d1                	mov    %edx,%ecx
  800c55:	89 d3                	mov    %edx,%ebx
  800c57:	89 d7                	mov    %edx,%edi
  800c59:	89 d6                	mov    %edx,%esi
  800c5b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c6b:	be 00 00 00 00       	mov    $0x0,%esi
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c76:	b8 04 00 00 00       	mov    $0x4,%eax
  800c7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7e:	89 f7                	mov    %esi,%edi
  800c80:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c82:	85 c0                	test   %eax,%eax
  800c84:	7f 08                	jg     800c8e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5f                   	pop    %edi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c8e:	83 ec 0c             	sub    $0xc,%esp
  800c91:	50                   	push   %eax
  800c92:	6a 04                	push   $0x4
  800c94:	68 44 13 80 00       	push   $0x801344
  800c99:	6a 24                	push   $0x24
  800c9b:	68 61 13 80 00       	push   $0x801361
  800ca0:	e8 8b f4 ff ff       	call   800130 <_panic>

00800ca5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbf:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	7f 08                	jg     800cd0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	83 ec 0c             	sub    $0xc,%esp
  800cd3:	50                   	push   %eax
  800cd4:	6a 05                	push   $0x5
  800cd6:	68 44 13 80 00       	push   $0x801344
  800cdb:	6a 24                	push   $0x24
  800cdd:	68 61 13 80 00       	push   $0x801361
  800ce2:	e8 49 f4 ff ff       	call   800130 <_panic>

00800ce7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cf0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	b8 06 00 00 00       	mov    $0x6,%eax
  800d00:	89 df                	mov    %ebx,%edi
  800d02:	89 de                	mov    %ebx,%esi
  800d04:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 06                	push   $0x6
  800d18:	68 44 13 80 00       	push   $0x801344
  800d1d:	6a 24                	push   $0x24
  800d1f:	68 61 13 80 00       	push   $0x801361
  800d24:	e8 07 f4 ff ff       	call   800130 <_panic>

00800d29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d42:	89 df                	mov    %ebx,%edi
  800d44:	89 de                	mov    %ebx,%esi
  800d46:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 08                	push   $0x8
  800d5a:	68 44 13 80 00       	push   $0x801344
  800d5f:	6a 24                	push   $0x24
  800d61:	68 61 13 80 00       	push   $0x801361
  800d66:	e8 c5 f3 ff ff       	call   800130 <_panic>

00800d6b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7f:	b8 09 00 00 00       	mov    $0x9,%eax
  800d84:	89 df                	mov    %ebx,%edi
  800d86:	89 de                	mov    %ebx,%esi
  800d88:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 09                	push   $0x9
  800d9c:	68 44 13 80 00       	push   $0x801344
  800da1:	6a 24                	push   $0x24
  800da3:	68 61 13 80 00       	push   $0x801361
  800da8:	e8 83 f3 ff ff       	call   800130 <_panic>

00800dad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
    asm volatile("int %1\n"
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dbe:	be 00 00 00 00       	mov    $0x0,%esi
  800dc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de6:	89 cb                	mov    %ecx,%ebx
  800de8:	89 cf                	mov    %ecx,%edi
  800dea:	89 ce                	mov    %ecx,%esi
  800dec:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dee:	85 c0                	test   %eax,%eax
  800df0:	7f 08                	jg     800dfa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dfa:	83 ec 0c             	sub    $0xc,%esp
  800dfd:	50                   	push   %eax
  800dfe:	6a 0c                	push   $0xc
  800e00:	68 44 13 80 00       	push   $0x801344
  800e05:	6a 24                	push   $0x24
  800e07:	68 61 13 80 00       	push   $0x801361
  800e0c:	e8 1f f3 ff ff       	call   800130 <_panic>

00800e11 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800e17:	68 7b 13 80 00       	push   $0x80137b
  800e1c:	6a 51                	push   $0x51
  800e1e:	68 6f 13 80 00       	push   $0x80136f
  800e23:	e8 08 f3 ff ff       	call   800130 <_panic>

00800e28 <sfork>:
}

// Challenge!
int
sfork(void)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800e2e:	68 7a 13 80 00       	push   $0x80137a
  800e33:	6a 58                	push   $0x58
  800e35:	68 6f 13 80 00       	push   $0x80136f
  800e3a:	e8 f1 f2 ff ff       	call   800130 <_panic>
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
