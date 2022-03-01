
obj/user/faultalloc：     文件格式 elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 80 10 80 00       	push   $0x801080
  800045:	e8 b3 01 00 00       	call   8001fd <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 f6 0b 00 00       	call   800c54 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 cc 10 80 00       	push   $0x8010cc
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 97 07 00 00       	call   80080a <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 a0 10 80 00       	push   $0x8010a0
  800085:	6a 0e                	push   $0xe
  800087:	68 8a 10 80 00       	push   $0x80108a
  80008c:	e8 91 00 00 00       	call   800122 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 62 0d 00 00       	call   800e03 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 9c 10 80 00       	push   $0x80109c
  8000ae:	e8 4a 01 00 00       	call   8001fd <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 9c 10 80 00       	push   $0x80109c
  8000c0:	e8 38 01 00 00       	call   8001fd <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 3c 0b 00 00       	call   800c16 <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e7:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	85 db                	test   %ebx,%ebx
  8000ee:	7e 07                	jle    8000f7 <libmain+0x2d>
		binaryname = argv[0];
  8000f0:	8b 06                	mov    (%esi),%eax
  8000f2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	e8 90 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800101:	e8 0a 00 00 00       	call   800110 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800116:	6a 00                	push   $0x0
  800118:	e8 b8 0a 00 00       	call   800bd5 <sys_env_destroy>
}
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	c9                   	leave  
  800121:	c3                   	ret    

00800122 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	56                   	push   %esi
  800126:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800127:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80012a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800130:	e8 e1 0a 00 00       	call   800c16 <sys_getenvid>
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	ff 75 0c             	pushl  0xc(%ebp)
  80013b:	ff 75 08             	pushl  0x8(%ebp)
  80013e:	56                   	push   %esi
  80013f:	50                   	push   %eax
  800140:	68 f8 10 80 00       	push   $0x8010f8
  800145:	e8 b3 00 00 00       	call   8001fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80014a:	83 c4 18             	add    $0x18,%esp
  80014d:	53                   	push   %ebx
  80014e:	ff 75 10             	pushl  0x10(%ebp)
  800151:	e8 56 00 00 00       	call   8001ac <vcprintf>
	cprintf("\n");
  800156:	c7 04 24 9e 10 80 00 	movl   $0x80109e,(%esp)
  80015d:	e8 9b 00 00 00       	call   8001fd <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800165:	cc                   	int3   
  800166:	eb fd                	jmp    800165 <_panic+0x43>

00800168 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	53                   	push   %ebx
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800172:	8b 13                	mov    (%ebx),%edx
  800174:	8d 42 01             	lea    0x1(%edx),%eax
  800177:	89 03                	mov    %eax,(%ebx)
  800179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800180:	3d ff 00 00 00       	cmp    $0xff,%eax
  800185:	74 09                	je     800190 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800187:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	68 ff 00 00 00       	push   $0xff
  800198:	8d 43 08             	lea    0x8(%ebx),%eax
  80019b:	50                   	push   %eax
  80019c:	e8 f7 09 00 00       	call   800b98 <sys_cputs>
		b->idx = 0;
  8001a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a7:	83 c4 10             	add    $0x10,%esp
  8001aa:	eb db                	jmp    800187 <putch+0x1f>

008001ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bc:	00 00 00 
	b.cnt = 0;
  8001bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c9:	ff 75 0c             	pushl  0xc(%ebp)
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d5:	50                   	push   %eax
  8001d6:	68 68 01 80 00       	push   $0x800168
  8001db:	e8 1a 01 00 00       	call   8002fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e0:	83 c4 08             	add    $0x8,%esp
  8001e3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 a3 09 00 00       	call   800b98 <sys_cputs>

	return b.cnt;
}
  8001f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800203:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800206:	50                   	push   %eax
  800207:	ff 75 08             	pushl  0x8(%ebp)
  80020a:	e8 9d ff ff ff       	call   8001ac <vcprintf>
	va_end(ap);

	return cnt;
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	57                   	push   %edi
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
  800217:	83 ec 1c             	sub    $0x1c,%esp
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	89 d6                	mov    %edx,%esi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	8b 55 0c             	mov    0xc(%ebp),%edx
  800224:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800227:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80022a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80022d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800232:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800235:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800238:	39 d3                	cmp    %edx,%ebx
  80023a:	72 05                	jb     800241 <printnum+0x30>
  80023c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80023f:	77 7a                	ja     8002bb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	ff 75 18             	pushl  0x18(%ebp)
  800247:	8b 45 14             	mov    0x14(%ebp),%eax
  80024a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80024d:	53                   	push   %ebx
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	ff 75 e4             	pushl  -0x1c(%ebp)
  800257:	ff 75 e0             	pushl  -0x20(%ebp)
  80025a:	ff 75 dc             	pushl  -0x24(%ebp)
  80025d:	ff 75 d8             	pushl  -0x28(%ebp)
  800260:	e8 cb 0b 00 00       	call   800e30 <__udivdi3>
  800265:	83 c4 18             	add    $0x18,%esp
  800268:	52                   	push   %edx
  800269:	50                   	push   %eax
  80026a:	89 f2                	mov    %esi,%edx
  80026c:	89 f8                	mov    %edi,%eax
  80026e:	e8 9e ff ff ff       	call   800211 <printnum>
  800273:	83 c4 20             	add    $0x20,%esp
  800276:	eb 13                	jmp    80028b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	56                   	push   %esi
  80027c:	ff 75 18             	pushl  0x18(%ebp)
  80027f:	ff d7                	call   *%edi
  800281:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	85 db                	test   %ebx,%ebx
  800289:	7f ed                	jg     800278 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	56                   	push   %esi
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	ff 75 e4             	pushl  -0x1c(%ebp)
  800295:	ff 75 e0             	pushl  -0x20(%ebp)
  800298:	ff 75 dc             	pushl  -0x24(%ebp)
  80029b:	ff 75 d8             	pushl  -0x28(%ebp)
  80029e:	e8 ad 0c 00 00       	call   800f50 <__umoddi3>
  8002a3:	83 c4 14             	add    $0x14,%esp
  8002a6:	0f be 80 1b 11 80 00 	movsbl 0x80111b(%eax),%eax
  8002ad:	50                   	push   %eax
  8002ae:	ff d7                	call   *%edi
}
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b6:	5b                   	pop    %ebx
  8002b7:	5e                   	pop    %esi
  8002b8:	5f                   	pop    %edi
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    
  8002bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002be:	eb c4                	jmp    800284 <printnum+0x73>

008002c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ca:	8b 10                	mov    (%eax),%edx
  8002cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002cf:	73 0a                	jae    8002db <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	88 02                	mov    %al,(%edx)
}
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <printfmt>:
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 10             	pushl  0x10(%ebp)
  8002ea:	ff 75 0c             	pushl  0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 05 00 00 00       	call   8002fa <vprintfmt>
}
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <vprintfmt>:
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 2c             	sub    $0x2c,%esp
  800303:	8b 75 08             	mov    0x8(%ebp),%esi
  800306:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800309:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030c:	e9 00 04 00 00       	jmp    800711 <vprintfmt+0x417>
		padc = ' ';
  800311:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800315:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80031c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800323:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032f:	8d 47 01             	lea    0x1(%edi),%eax
  800332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800335:	0f b6 17             	movzbl (%edi),%edx
  800338:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033b:	3c 55                	cmp    $0x55,%al
  80033d:	0f 87 51 04 00 00    	ja     800794 <vprintfmt+0x49a>
  800343:	0f b6 c0             	movzbl %al,%eax
  800346:	ff 24 85 e0 11 80 00 	jmp    *0x8011e0(,%eax,4)
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800350:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800354:	eb d9                	jmp    80032f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800359:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80035d:	eb d0                	jmp    80032f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035f:	0f b6 d2             	movzbl %dl,%edx
  800362:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800365:	b8 00 00 00 00       	mov    $0x0,%eax
  80036a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800370:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800374:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800377:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037a:	83 f9 09             	cmp    $0x9,%ecx
  80037d:	77 55                	ja     8003d4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80037f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800382:	eb e9                	jmp    80036d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800384:	8b 45 14             	mov    0x14(%ebp),%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8d 40 04             	lea    0x4(%eax),%eax
  800392:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800398:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039c:	79 91                	jns    80032f <vprintfmt+0x35>
				width = precision, precision = -1;
  80039e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003ab:	eb 82                	jmp    80032f <vprintfmt+0x35>
  8003ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b7:	0f 49 d0             	cmovns %eax,%edx
  8003ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c0:	e9 6a ff ff ff       	jmp    80032f <vprintfmt+0x35>
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003cf:	e9 5b ff ff ff       	jmp    80032f <vprintfmt+0x35>
  8003d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003da:	eb bc                	jmp    800398 <vprintfmt+0x9e>
			lflag++;
  8003dc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e2:	e9 48 ff ff ff       	jmp    80032f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8d 78 04             	lea    0x4(%eax),%edi
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	53                   	push   %ebx
  8003f1:	ff 30                	pushl  (%eax)
  8003f3:	ff d6                	call   *%esi
			break;
  8003f5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fb:	e9 0e 03 00 00       	jmp    80070e <vprintfmt+0x414>
			err = va_arg(ap, int);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8d 78 04             	lea    0x4(%eax),%edi
  800406:	8b 00                	mov    (%eax),%eax
  800408:	99                   	cltd   
  800409:	31 d0                	xor    %edx,%eax
  80040b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040d:	83 f8 08             	cmp    $0x8,%eax
  800410:	7f 23                	jg     800435 <vprintfmt+0x13b>
  800412:	8b 14 85 40 13 80 00 	mov    0x801340(,%eax,4),%edx
  800419:	85 d2                	test   %edx,%edx
  80041b:	74 18                	je     800435 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80041d:	52                   	push   %edx
  80041e:	68 3c 11 80 00       	push   $0x80113c
  800423:	53                   	push   %ebx
  800424:	56                   	push   %esi
  800425:	e8 b3 fe ff ff       	call   8002dd <printfmt>
  80042a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800430:	e9 d9 02 00 00       	jmp    80070e <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800435:	50                   	push   %eax
  800436:	68 33 11 80 00       	push   $0x801133
  80043b:	53                   	push   %ebx
  80043c:	56                   	push   %esi
  80043d:	e8 9b fe ff ff       	call   8002dd <printfmt>
  800442:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800445:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800448:	e9 c1 02 00 00       	jmp    80070e <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	83 c0 04             	add    $0x4,%eax
  800453:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80045b:	85 ff                	test   %edi,%edi
  80045d:	b8 2c 11 80 00       	mov    $0x80112c,%eax
  800462:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800465:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800469:	0f 8e bd 00 00 00    	jle    80052c <vprintfmt+0x232>
  80046f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800473:	75 0e                	jne    800483 <vprintfmt+0x189>
  800475:	89 75 08             	mov    %esi,0x8(%ebp)
  800478:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80047b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80047e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800481:	eb 6d                	jmp    8004f0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 d0             	pushl  -0x30(%ebp)
  800489:	57                   	push   %edi
  80048a:	e8 ad 03 00 00       	call   80083c <strnlen>
  80048f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800492:	29 c1                	sub    %eax,%ecx
  800494:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800497:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80049a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80049e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004a4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a6:	eb 0f                	jmp    8004b7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8004af:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	83 ef 01             	sub    $0x1,%edi
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	85 ff                	test   %edi,%edi
  8004b9:	7f ed                	jg     8004a8 <vprintfmt+0x1ae>
  8004bb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004be:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c1:	85 c9                	test   %ecx,%ecx
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c8:	0f 49 c1             	cmovns %ecx,%eax
  8004cb:	29 c1                	sub    %eax,%ecx
  8004cd:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d6:	89 cb                	mov    %ecx,%ebx
  8004d8:	eb 16                	jmp    8004f0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004de:	75 31                	jne    800511 <vprintfmt+0x217>
					putch(ch, putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 55 08             	call   *0x8(%ebp)
  8004ea:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ed:	83 eb 01             	sub    $0x1,%ebx
  8004f0:	83 c7 01             	add    $0x1,%edi
  8004f3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004f7:	0f be c2             	movsbl %dl,%eax
  8004fa:	85 c0                	test   %eax,%eax
  8004fc:	74 59                	je     800557 <vprintfmt+0x25d>
  8004fe:	85 f6                	test   %esi,%esi
  800500:	78 d8                	js     8004da <vprintfmt+0x1e0>
  800502:	83 ee 01             	sub    $0x1,%esi
  800505:	79 d3                	jns    8004da <vprintfmt+0x1e0>
  800507:	89 df                	mov    %ebx,%edi
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	eb 37                	jmp    800548 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800511:	0f be d2             	movsbl %dl,%edx
  800514:	83 ea 20             	sub    $0x20,%edx
  800517:	83 fa 5e             	cmp    $0x5e,%edx
  80051a:	76 c4                	jbe    8004e0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	ff 75 0c             	pushl  0xc(%ebp)
  800522:	6a 3f                	push   $0x3f
  800524:	ff 55 08             	call   *0x8(%ebp)
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	eb c1                	jmp    8004ed <vprintfmt+0x1f3>
  80052c:	89 75 08             	mov    %esi,0x8(%ebp)
  80052f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800532:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800535:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800538:	eb b6                	jmp    8004f0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 20                	push   $0x20
  800540:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800542:	83 ef 01             	sub    $0x1,%edi
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	85 ff                	test   %edi,%edi
  80054a:	7f ee                	jg     80053a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80054c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
  800552:	e9 b7 01 00 00       	jmp    80070e <vprintfmt+0x414>
  800557:	89 df                	mov    %ebx,%edi
  800559:	8b 75 08             	mov    0x8(%ebp),%esi
  80055c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055f:	eb e7                	jmp    800548 <vprintfmt+0x24e>
	if (lflag >= 2)
  800561:	83 f9 01             	cmp    $0x1,%ecx
  800564:	7e 3f                	jle    8005a5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 50 04             	mov    0x4(%eax),%edx
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 08             	lea    0x8(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80057d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800581:	79 5c                	jns    8005df <vprintfmt+0x2e5>
				putch('-', putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	6a 2d                	push   $0x2d
  800589:	ff d6                	call   *%esi
				num = -(long long) num;
  80058b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800591:	f7 da                	neg    %edx
  800593:	83 d1 00             	adc    $0x0,%ecx
  800596:	f7 d9                	neg    %ecx
  800598:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a0:	e9 4f 01 00 00       	jmp    8006f4 <vprintfmt+0x3fa>
	else if (lflag)
  8005a5:	85 c9                	test   %ecx,%ecx
  8005a7:	75 1b                	jne    8005c4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b1:	89 c1                	mov    %eax,%ecx
  8005b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 40 04             	lea    0x4(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c2:	eb b9                	jmp    80057d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cc:	89 c1                	mov    %eax,%ecx
  8005ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dd:	eb 9e                	jmp    80057d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ea:	e9 05 01 00 00       	jmp    8006f4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005ef:	83 f9 01             	cmp    $0x1,%ecx
  8005f2:	7e 18                	jle    80060c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 10                	mov    (%eax),%edx
  8005f9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fc:	8d 40 08             	lea    0x8(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800602:	b8 0a 00 00 00       	mov    $0xa,%eax
  800607:	e9 e8 00 00 00       	jmp    8006f4 <vprintfmt+0x3fa>
	else if (lflag)
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	75 1a                	jne    80062a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	e9 ca 00 00 00       	jmp    8006f4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 10                	mov    (%eax),%edx
  80062f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063f:	e9 b0 00 00 00       	jmp    8006f4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800644:	83 f9 01             	cmp    $0x1,%ecx
  800647:	7e 3c                	jle    800685 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 08             	lea    0x8(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800660:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800664:	79 59                	jns    8006bf <vprintfmt+0x3c5>
                putch('-', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 2d                	push   $0x2d
  80066c:	ff d6                	call   *%esi
                num = -(long long) num;
  80066e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800671:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800674:	f7 da                	neg    %edx
  800676:	83 d1 00             	adc    $0x0,%ecx
  800679:	f7 d9                	neg    %ecx
  80067b:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80067e:	b8 08 00 00 00       	mov    $0x8,%eax
  800683:	eb 6f                	jmp    8006f4 <vprintfmt+0x3fa>
	else if (lflag)
  800685:	85 c9                	test   %ecx,%ecx
  800687:	75 1b                	jne    8006a4 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 c1                	mov    %eax,%ecx
  800693:	c1 f9 1f             	sar    $0x1f,%ecx
  800696:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a2:	eb bc                	jmp    800660 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 c1                	mov    %eax,%ecx
  8006ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bd:	eb a1                	jmp    800660 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ca:	eb 28                	jmp    8006f4 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	6a 30                	push   $0x30
  8006d2:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d4:	83 c4 08             	add    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 78                	push   $0x78
  8006da:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006e6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ef:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f4:	83 ec 0c             	sub    $0xc,%esp
  8006f7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006fb:	57                   	push   %edi
  8006fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ff:	50                   	push   %eax
  800700:	51                   	push   %ecx
  800701:	52                   	push   %edx
  800702:	89 da                	mov    %ebx,%edx
  800704:	89 f0                	mov    %esi,%eax
  800706:	e8 06 fb ff ff       	call   800211 <printnum>
			break;
  80070b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80070e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800711:	83 c7 01             	add    $0x1,%edi
  800714:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800718:	83 f8 25             	cmp    $0x25,%eax
  80071b:	0f 84 f0 fb ff ff    	je     800311 <vprintfmt+0x17>
			if (ch == '\0')
  800721:	85 c0                	test   %eax,%eax
  800723:	0f 84 8b 00 00 00    	je     8007b4 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	50                   	push   %eax
  80072e:	ff d6                	call   *%esi
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	eb dc                	jmp    800711 <vprintfmt+0x417>
	if (lflag >= 2)
  800735:	83 f9 01             	cmp    $0x1,%ecx
  800738:	7e 15                	jle    80074f <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 10                	mov    (%eax),%edx
  80073f:	8b 48 04             	mov    0x4(%eax),%ecx
  800742:	8d 40 08             	lea    0x8(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800748:	b8 10 00 00 00       	mov    $0x10,%eax
  80074d:	eb a5                	jmp    8006f4 <vprintfmt+0x3fa>
	else if (lflag)
  80074f:	85 c9                	test   %ecx,%ecx
  800751:	75 17                	jne    80076a <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 10                	mov    (%eax),%edx
  800758:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075d:	8d 40 04             	lea    0x4(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800763:	b8 10 00 00 00       	mov    $0x10,%eax
  800768:	eb 8a                	jmp    8006f4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8b 10                	mov    (%eax),%edx
  80076f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800774:	8d 40 04             	lea    0x4(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077a:	b8 10 00 00 00       	mov    $0x10,%eax
  80077f:	e9 70 ff ff ff       	jmp    8006f4 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	6a 25                	push   $0x25
  80078a:	ff d6                	call   *%esi
			break;
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	e9 7a ff ff ff       	jmp    80070e <vprintfmt+0x414>
			putch('%', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	6a 25                	push   $0x25
  80079a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	89 f8                	mov    %edi,%eax
  8007a1:	eb 03                	jmp    8007a6 <vprintfmt+0x4ac>
  8007a3:	83 e8 01             	sub    $0x1,%eax
  8007a6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007aa:	75 f7                	jne    8007a3 <vprintfmt+0x4a9>
  8007ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007af:	e9 5a ff ff ff       	jmp    80070e <vprintfmt+0x414>
}
  8007b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b7:	5b                   	pop    %ebx
  8007b8:	5e                   	pop    %esi
  8007b9:	5f                   	pop    %edi
  8007ba:	5d                   	pop    %ebp
  8007bb:	c3                   	ret    

008007bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007cb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007cf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d9:	85 c0                	test   %eax,%eax
  8007db:	74 26                	je     800803 <vsnprintf+0x47>
  8007dd:	85 d2                	test   %edx,%edx
  8007df:	7e 22                	jle    800803 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e1:	ff 75 14             	pushl  0x14(%ebp)
  8007e4:	ff 75 10             	pushl  0x10(%ebp)
  8007e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ea:	50                   	push   %eax
  8007eb:	68 c0 02 80 00       	push   $0x8002c0
  8007f0:	e8 05 fb ff ff       	call   8002fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    
		return -E_INVAL;
  800803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800808:	eb f7                	jmp    800801 <vsnprintf+0x45>

0080080a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800813:	50                   	push   %eax
  800814:	ff 75 10             	pushl  0x10(%ebp)
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	ff 75 08             	pushl  0x8(%ebp)
  80081d:	e8 9a ff ff ff       	call   8007bc <vsnprintf>
	va_end(ap);

	return rc;
}
  800822:	c9                   	leave  
  800823:	c3                   	ret    

00800824 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
  80082f:	eb 03                	jmp    800834 <strlen+0x10>
		n++;
  800831:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800834:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800838:	75 f7                	jne    800831 <strlen+0xd>
	return n;
}
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	eb 03                	jmp    80084f <strnlen+0x13>
		n++;
  80084c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084f:	39 d0                	cmp    %edx,%eax
  800851:	74 06                	je     800859 <strnlen+0x1d>
  800853:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800857:	75 f3                	jne    80084c <strnlen+0x10>
	return n;
}
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800865:	89 c2                	mov    %eax,%edx
  800867:	83 c1 01             	add    $0x1,%ecx
  80086a:	83 c2 01             	add    $0x1,%edx
  80086d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800871:	88 5a ff             	mov    %bl,-0x1(%edx)
  800874:	84 db                	test   %bl,%bl
  800876:	75 ef                	jne    800867 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800882:	53                   	push   %ebx
  800883:	e8 9c ff ff ff       	call   800824 <strlen>
  800888:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	01 d8                	add    %ebx,%eax
  800890:	50                   	push   %eax
  800891:	e8 c5 ff ff ff       	call   80085b <strcpy>
	return dst;
}
  800896:	89 d8                	mov    %ebx,%eax
  800898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a8:	89 f3                	mov    %esi,%ebx
  8008aa:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ad:	89 f2                	mov    %esi,%edx
  8008af:	eb 0f                	jmp    8008c0 <strncpy+0x23>
		*dst++ = *src;
  8008b1:	83 c2 01             	add    $0x1,%edx
  8008b4:	0f b6 01             	movzbl (%ecx),%eax
  8008b7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ba:	80 39 01             	cmpb   $0x1,(%ecx)
  8008bd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008c0:	39 da                	cmp    %ebx,%edx
  8008c2:	75 ed                	jne    8008b1 <strncpy+0x14>
	}
	return ret;
}
  8008c4:	89 f0                	mov    %esi,%eax
  8008c6:	5b                   	pop    %ebx
  8008c7:	5e                   	pop    %esi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	56                   	push   %esi
  8008ce:	53                   	push   %ebx
  8008cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008d8:	89 f0                	mov    %esi,%eax
  8008da:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008de:	85 c9                	test   %ecx,%ecx
  8008e0:	75 0b                	jne    8008ed <strlcpy+0x23>
  8008e2:	eb 17                	jmp    8008fb <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008e4:	83 c2 01             	add    $0x1,%edx
  8008e7:	83 c0 01             	add    $0x1,%eax
  8008ea:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008ed:	39 d8                	cmp    %ebx,%eax
  8008ef:	74 07                	je     8008f8 <strlcpy+0x2e>
  8008f1:	0f b6 0a             	movzbl (%edx),%ecx
  8008f4:	84 c9                	test   %cl,%cl
  8008f6:	75 ec                	jne    8008e4 <strlcpy+0x1a>
		*dst = '\0';
  8008f8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008fb:	29 f0                	sub    %esi,%eax
}
  8008fd:	5b                   	pop    %ebx
  8008fe:	5e                   	pop    %esi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800907:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090a:	eb 06                	jmp    800912 <strcmp+0x11>
		p++, q++;
  80090c:	83 c1 01             	add    $0x1,%ecx
  80090f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800912:	0f b6 01             	movzbl (%ecx),%eax
  800915:	84 c0                	test   %al,%al
  800917:	74 04                	je     80091d <strcmp+0x1c>
  800919:	3a 02                	cmp    (%edx),%al
  80091b:	74 ef                	je     80090c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091d:	0f b6 c0             	movzbl %al,%eax
  800920:	0f b6 12             	movzbl (%edx),%edx
  800923:	29 d0                	sub    %edx,%eax
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800931:	89 c3                	mov    %eax,%ebx
  800933:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800936:	eb 06                	jmp    80093e <strncmp+0x17>
		n--, p++, q++;
  800938:	83 c0 01             	add    $0x1,%eax
  80093b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80093e:	39 d8                	cmp    %ebx,%eax
  800940:	74 16                	je     800958 <strncmp+0x31>
  800942:	0f b6 08             	movzbl (%eax),%ecx
  800945:	84 c9                	test   %cl,%cl
  800947:	74 04                	je     80094d <strncmp+0x26>
  800949:	3a 0a                	cmp    (%edx),%cl
  80094b:	74 eb                	je     800938 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094d:	0f b6 00             	movzbl (%eax),%eax
  800950:	0f b6 12             	movzbl (%edx),%edx
  800953:	29 d0                	sub    %edx,%eax
}
  800955:	5b                   	pop    %ebx
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    
		return 0;
  800958:	b8 00 00 00 00       	mov    $0x0,%eax
  80095d:	eb f6                	jmp    800955 <strncmp+0x2e>

0080095f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800969:	0f b6 10             	movzbl (%eax),%edx
  80096c:	84 d2                	test   %dl,%dl
  80096e:	74 09                	je     800979 <strchr+0x1a>
		if (*s == c)
  800970:	38 ca                	cmp    %cl,%dl
  800972:	74 0a                	je     80097e <strchr+0x1f>
	for (; *s; s++)
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	eb f0                	jmp    800969 <strchr+0xa>
			return (char *) s;
	return 0;
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098a:	eb 03                	jmp    80098f <strfind+0xf>
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800992:	38 ca                	cmp    %cl,%dl
  800994:	74 04                	je     80099a <strfind+0x1a>
  800996:	84 d2                	test   %dl,%dl
  800998:	75 f2                	jne    80098c <strfind+0xc>
			break;
	return (char *) s;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	57                   	push   %edi
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a8:	85 c9                	test   %ecx,%ecx
  8009aa:	74 13                	je     8009bf <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ac:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b2:	75 05                	jne    8009b9 <memset+0x1d>
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	74 0d                	je     8009c6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bc:	fc                   	cld    
  8009bd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009bf:	89 f8                	mov    %edi,%eax
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5f                   	pop    %edi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    
		c &= 0xFF;
  8009c6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ca:	89 d3                	mov    %edx,%ebx
  8009cc:	c1 e3 08             	shl    $0x8,%ebx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	c1 e0 18             	shl    $0x18,%eax
  8009d4:	89 d6                	mov    %edx,%esi
  8009d6:	c1 e6 10             	shl    $0x10,%esi
  8009d9:	09 f0                	or     %esi,%eax
  8009db:	09 c2                	or     %eax,%edx
  8009dd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009df:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e7:	eb d6                	jmp    8009bf <memset+0x23>

008009e9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	57                   	push   %edi
  8009ed:	56                   	push   %esi
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f7:	39 c6                	cmp    %eax,%esi
  8009f9:	73 35                	jae    800a30 <memmove+0x47>
  8009fb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fe:	39 c2                	cmp    %eax,%edx
  800a00:	76 2e                	jbe    800a30 <memmove+0x47>
		s += n;
		d += n;
  800a02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a05:	89 d6                	mov    %edx,%esi
  800a07:	09 fe                	or     %edi,%esi
  800a09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0f:	74 0c                	je     800a1d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a11:	83 ef 01             	sub    $0x1,%edi
  800a14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a17:	fd                   	std    
  800a18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1a:	fc                   	cld    
  800a1b:	eb 21                	jmp    800a3e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1d:	f6 c1 03             	test   $0x3,%cl
  800a20:	75 ef                	jne    800a11 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a22:	83 ef 04             	sub    $0x4,%edi
  800a25:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2b:	fd                   	std    
  800a2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2e:	eb ea                	jmp    800a1a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a30:	89 f2                	mov    %esi,%edx
  800a32:	09 c2                	or     %eax,%edx
  800a34:	f6 c2 03             	test   $0x3,%dl
  800a37:	74 09                	je     800a42 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a39:	89 c7                	mov    %eax,%edi
  800a3b:	fc                   	cld    
  800a3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a3e:	5e                   	pop    %esi
  800a3f:	5f                   	pop    %edi
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a42:	f6 c1 03             	test   $0x3,%cl
  800a45:	75 f2                	jne    800a39 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a47:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4a:	89 c7                	mov    %eax,%edi
  800a4c:	fc                   	cld    
  800a4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4f:	eb ed                	jmp    800a3e <memmove+0x55>

00800a51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a54:	ff 75 10             	pushl  0x10(%ebp)
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	ff 75 08             	pushl  0x8(%ebp)
  800a5d:	e8 87 ff ff ff       	call   8009e9 <memmove>
}
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6f:	89 c6                	mov    %eax,%esi
  800a71:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a74:	39 f0                	cmp    %esi,%eax
  800a76:	74 1c                	je     800a94 <memcmp+0x30>
		if (*s1 != *s2)
  800a78:	0f b6 08             	movzbl (%eax),%ecx
  800a7b:	0f b6 1a             	movzbl (%edx),%ebx
  800a7e:	38 d9                	cmp    %bl,%cl
  800a80:	75 08                	jne    800a8a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a82:	83 c0 01             	add    $0x1,%eax
  800a85:	83 c2 01             	add    $0x1,%edx
  800a88:	eb ea                	jmp    800a74 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a8a:	0f b6 c1             	movzbl %cl,%eax
  800a8d:	0f b6 db             	movzbl %bl,%ebx
  800a90:	29 d8                	sub    %ebx,%eax
  800a92:	eb 05                	jmp    800a99 <memcmp+0x35>
	}

	return 0;
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa6:	89 c2                	mov    %eax,%edx
  800aa8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aab:	39 d0                	cmp    %edx,%eax
  800aad:	73 09                	jae    800ab8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aaf:	38 08                	cmp    %cl,(%eax)
  800ab1:	74 05                	je     800ab8 <memfind+0x1b>
	for (; s < ends; s++)
  800ab3:	83 c0 01             	add    $0x1,%eax
  800ab6:	eb f3                	jmp    800aab <memfind+0xe>
			break;
	return (void *) s;
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	57                   	push   %edi
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
  800ac0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac6:	eb 03                	jmp    800acb <strtol+0x11>
		s++;
  800ac8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800acb:	0f b6 01             	movzbl (%ecx),%eax
  800ace:	3c 20                	cmp    $0x20,%al
  800ad0:	74 f6                	je     800ac8 <strtol+0xe>
  800ad2:	3c 09                	cmp    $0x9,%al
  800ad4:	74 f2                	je     800ac8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ad6:	3c 2b                	cmp    $0x2b,%al
  800ad8:	74 2e                	je     800b08 <strtol+0x4e>
	int neg = 0;
  800ada:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800adf:	3c 2d                	cmp    $0x2d,%al
  800ae1:	74 2f                	je     800b12 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae9:	75 05                	jne    800af0 <strtol+0x36>
  800aeb:	80 39 30             	cmpb   $0x30,(%ecx)
  800aee:	74 2c                	je     800b1c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800af0:	85 db                	test   %ebx,%ebx
  800af2:	75 0a                	jne    800afe <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800af9:	80 39 30             	cmpb   $0x30,(%ecx)
  800afc:	74 28                	je     800b26 <strtol+0x6c>
		base = 10;
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
  800b03:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b06:	eb 50                	jmp    800b58 <strtol+0x9e>
		s++;
  800b08:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800b10:	eb d1                	jmp    800ae3 <strtol+0x29>
		s++, neg = 1;
  800b12:	83 c1 01             	add    $0x1,%ecx
  800b15:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1a:	eb c7                	jmp    800ae3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b20:	74 0e                	je     800b30 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b22:	85 db                	test   %ebx,%ebx
  800b24:	75 d8                	jne    800afe <strtol+0x44>
		s++, base = 8;
  800b26:	83 c1 01             	add    $0x1,%ecx
  800b29:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b2e:	eb ce                	jmp    800afe <strtol+0x44>
		s += 2, base = 16;
  800b30:	83 c1 02             	add    $0x2,%ecx
  800b33:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b38:	eb c4                	jmp    800afe <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b3a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b3d:	89 f3                	mov    %esi,%ebx
  800b3f:	80 fb 19             	cmp    $0x19,%bl
  800b42:	77 29                	ja     800b6d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b44:	0f be d2             	movsbl %dl,%edx
  800b47:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b4a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4d:	7d 30                	jge    800b7f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b4f:	83 c1 01             	add    $0x1,%ecx
  800b52:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b56:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b58:	0f b6 11             	movzbl (%ecx),%edx
  800b5b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b5e:	89 f3                	mov    %esi,%ebx
  800b60:	80 fb 09             	cmp    $0x9,%bl
  800b63:	77 d5                	ja     800b3a <strtol+0x80>
			dig = *s - '0';
  800b65:	0f be d2             	movsbl %dl,%edx
  800b68:	83 ea 30             	sub    $0x30,%edx
  800b6b:	eb dd                	jmp    800b4a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b6d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b70:	89 f3                	mov    %esi,%ebx
  800b72:	80 fb 19             	cmp    $0x19,%bl
  800b75:	77 08                	ja     800b7f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b77:	0f be d2             	movsbl %dl,%edx
  800b7a:	83 ea 37             	sub    $0x37,%edx
  800b7d:	eb cb                	jmp    800b4a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b83:	74 05                	je     800b8a <strtol+0xd0>
		*endptr = (char *) s;
  800b85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b88:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8a:	89 c2                	mov    %eax,%edx
  800b8c:	f7 da                	neg    %edx
  800b8e:	85 ff                	test   %edi,%edi
  800b90:	0f 45 c2             	cmovne %edx,%eax
}
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5f                   	pop    %edi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba9:	89 c3                	mov    %eax,%ebx
  800bab:	89 c7                	mov    %eax,%edi
  800bad:	89 c6                	mov    %eax,%esi
  800baf:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cgetc>:

int
sys_cgetc(void) {
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc6:	89 d1                	mov    %edx,%ecx
  800bc8:	89 d3                	mov    %edx,%ebx
  800bca:	89 d7                	mov    %edx,%edi
  800bcc:	89 d6                	mov    %edx,%esi
  800bce:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	b8 03 00 00 00       	mov    $0x3,%eax
  800beb:	89 cb                	mov    %ecx,%ebx
  800bed:	89 cf                	mov    %ecx,%edi
  800bef:	89 ce                	mov    %ecx,%esi
  800bf1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	7f 08                	jg     800bff <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bff:	83 ec 0c             	sub    $0xc,%esp
  800c02:	50                   	push   %eax
  800c03:	6a 03                	push   $0x3
  800c05:	68 64 13 80 00       	push   $0x801364
  800c0a:	6a 24                	push   $0x24
  800c0c:	68 81 13 80 00       	push   $0x801381
  800c11:	e8 0c f5 ff ff       	call   800122 <_panic>

00800c16 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 02 00 00 00       	mov    $0x2,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_yield>:

void
sys_yield(void)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c45:	89 d1                	mov    %edx,%ecx
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	89 d7                	mov    %edx,%edi
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c5d:	be 00 00 00 00       	mov    $0x0,%esi
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	b8 04 00 00 00       	mov    $0x4,%eax
  800c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c70:	89 f7                	mov    %esi,%edi
  800c72:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 04                	push   $0x4
  800c86:	68 64 13 80 00       	push   $0x801364
  800c8b:	6a 24                	push   $0x24
  800c8d:	68 81 13 80 00       	push   $0x801381
  800c92:	e8 8b f4 ff ff       	call   800122 <_panic>

00800c97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca6:	b8 05 00 00 00       	mov    $0x5,%eax
  800cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7f 08                	jg     800cc2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cc2:	83 ec 0c             	sub    $0xc,%esp
  800cc5:	50                   	push   %eax
  800cc6:	6a 05                	push   $0x5
  800cc8:	68 64 13 80 00       	push   $0x801364
  800ccd:	6a 24                	push   $0x24
  800ccf:	68 81 13 80 00       	push   $0x801381
  800cd4:	e8 49 f4 ff ff       	call   800122 <_panic>

00800cd9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ce2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	b8 06 00 00 00       	mov    $0x6,%eax
  800cf2:	89 df                	mov    %ebx,%edi
  800cf4:	89 de                	mov    %ebx,%esi
  800cf6:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	7f 08                	jg     800d04 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d04:	83 ec 0c             	sub    $0xc,%esp
  800d07:	50                   	push   %eax
  800d08:	6a 06                	push   $0x6
  800d0a:	68 64 13 80 00       	push   $0x801364
  800d0f:	6a 24                	push   $0x24
  800d11:	68 81 13 80 00       	push   $0x801381
  800d16:	e8 07 f4 ff ff       	call   800122 <_panic>

00800d1b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2f:	b8 08 00 00 00       	mov    $0x8,%eax
  800d34:	89 df                	mov    %ebx,%edi
  800d36:	89 de                	mov    %ebx,%esi
  800d38:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7f 08                	jg     800d46 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d46:	83 ec 0c             	sub    $0xc,%esp
  800d49:	50                   	push   %eax
  800d4a:	6a 08                	push   $0x8
  800d4c:	68 64 13 80 00       	push   $0x801364
  800d51:	6a 24                	push   $0x24
  800d53:	68 81 13 80 00       	push   $0x801381
  800d58:	e8 c5 f3 ff ff       	call   800122 <_panic>

00800d5d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 09 00 00 00       	mov    $0x9,%eax
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	89 de                	mov    %ebx,%esi
  800d7a:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7f 08                	jg     800d88 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 09                	push   $0x9
  800d8e:	68 64 13 80 00       	push   $0x801364
  800d93:	6a 24                	push   $0x24
  800d95:	68 81 13 80 00       	push   $0x801381
  800d9a:	e8 83 f3 ff ff       	call   800122 <_panic>

00800d9f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
    asm volatile("int %1\n"
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db0:	be 00 00 00 00       	mov    $0x0,%esi
  800db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd8:	89 cb                	mov    %ecx,%ebx
  800dda:	89 cf                	mov    %ecx,%edi
  800ddc:	89 ce                	mov    %ecx,%esi
  800dde:	cd 30                	int    $0x30
    if (check && ret > 0)
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7f 08                	jg     800dec <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	50                   	push   %eax
  800df0:	6a 0c                	push   $0xc
  800df2:	68 64 13 80 00       	push   $0x801364
  800df7:	6a 24                	push   $0x24
  800df9:	68 81 13 80 00       	push   $0x801381
  800dfe:	e8 1f f3 ff ff       	call   800122 <_panic>

00800e03 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e09:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800e10:	74 0a                	je     800e1c <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    
		panic("set_pgfault_handler not implemented");
  800e1c:	83 ec 04             	sub    $0x4,%esp
  800e1f:	68 90 13 80 00       	push   $0x801390
  800e24:	6a 20                	push   $0x20
  800e26:	68 b4 13 80 00       	push   $0x8013b4
  800e2b:	e8 f2 f2 ff ff       	call   800122 <_panic>

00800e30 <__udivdi3>:
  800e30:	55                   	push   %ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 1c             	sub    $0x1c,%esp
  800e37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e47:	85 d2                	test   %edx,%edx
  800e49:	75 35                	jne    800e80 <__udivdi3+0x50>
  800e4b:	39 f3                	cmp    %esi,%ebx
  800e4d:	0f 87 bd 00 00 00    	ja     800f10 <__udivdi3+0xe0>
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	89 d9                	mov    %ebx,%ecx
  800e57:	75 0b                	jne    800e64 <__udivdi3+0x34>
  800e59:	b8 01 00 00 00       	mov    $0x1,%eax
  800e5e:	31 d2                	xor    %edx,%edx
  800e60:	f7 f3                	div    %ebx
  800e62:	89 c1                	mov    %eax,%ecx
  800e64:	31 d2                	xor    %edx,%edx
  800e66:	89 f0                	mov    %esi,%eax
  800e68:	f7 f1                	div    %ecx
  800e6a:	89 c6                	mov    %eax,%esi
  800e6c:	89 e8                	mov    %ebp,%eax
  800e6e:	89 f7                	mov    %esi,%edi
  800e70:	f7 f1                	div    %ecx
  800e72:	89 fa                	mov    %edi,%edx
  800e74:	83 c4 1c             	add    $0x1c,%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
  800e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e80:	39 f2                	cmp    %esi,%edx
  800e82:	77 7c                	ja     800f00 <__udivdi3+0xd0>
  800e84:	0f bd fa             	bsr    %edx,%edi
  800e87:	83 f7 1f             	xor    $0x1f,%edi
  800e8a:	0f 84 98 00 00 00    	je     800f28 <__udivdi3+0xf8>
  800e90:	89 f9                	mov    %edi,%ecx
  800e92:	b8 20 00 00 00       	mov    $0x20,%eax
  800e97:	29 f8                	sub    %edi,%eax
  800e99:	d3 e2                	shl    %cl,%edx
  800e9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e9f:	89 c1                	mov    %eax,%ecx
  800ea1:	89 da                	mov    %ebx,%edx
  800ea3:	d3 ea                	shr    %cl,%edx
  800ea5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ea9:	09 d1                	or     %edx,%ecx
  800eab:	89 f2                	mov    %esi,%edx
  800ead:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800eb1:	89 f9                	mov    %edi,%ecx
  800eb3:	d3 e3                	shl    %cl,%ebx
  800eb5:	89 c1                	mov    %eax,%ecx
  800eb7:	d3 ea                	shr    %cl,%edx
  800eb9:	89 f9                	mov    %edi,%ecx
  800ebb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ebf:	d3 e6                	shl    %cl,%esi
  800ec1:	89 eb                	mov    %ebp,%ebx
  800ec3:	89 c1                	mov    %eax,%ecx
  800ec5:	d3 eb                	shr    %cl,%ebx
  800ec7:	09 de                	or     %ebx,%esi
  800ec9:	89 f0                	mov    %esi,%eax
  800ecb:	f7 74 24 08          	divl   0x8(%esp)
  800ecf:	89 d6                	mov    %edx,%esi
  800ed1:	89 c3                	mov    %eax,%ebx
  800ed3:	f7 64 24 0c          	mull   0xc(%esp)
  800ed7:	39 d6                	cmp    %edx,%esi
  800ed9:	72 0c                	jb     800ee7 <__udivdi3+0xb7>
  800edb:	89 f9                	mov    %edi,%ecx
  800edd:	d3 e5                	shl    %cl,%ebp
  800edf:	39 c5                	cmp    %eax,%ebp
  800ee1:	73 5d                	jae    800f40 <__udivdi3+0x110>
  800ee3:	39 d6                	cmp    %edx,%esi
  800ee5:	75 59                	jne    800f40 <__udivdi3+0x110>
  800ee7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eea:	31 ff                	xor    %edi,%edi
  800eec:	89 fa                	mov    %edi,%edx
  800eee:	83 c4 1c             	add    $0x1c,%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
  800ef6:	8d 76 00             	lea    0x0(%esi),%esi
  800ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f00:	31 ff                	xor    %edi,%edi
  800f02:	31 c0                	xor    %eax,%eax
  800f04:	89 fa                	mov    %edi,%edx
  800f06:	83 c4 1c             	add    $0x1c,%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
  800f0e:	66 90                	xchg   %ax,%ax
  800f10:	31 ff                	xor    %edi,%edi
  800f12:	89 e8                	mov    %ebp,%eax
  800f14:	89 f2                	mov    %esi,%edx
  800f16:	f7 f3                	div    %ebx
  800f18:	89 fa                	mov    %edi,%edx
  800f1a:	83 c4 1c             	add    $0x1c,%esp
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
  800f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f28:	39 f2                	cmp    %esi,%edx
  800f2a:	72 06                	jb     800f32 <__udivdi3+0x102>
  800f2c:	31 c0                	xor    %eax,%eax
  800f2e:	39 eb                	cmp    %ebp,%ebx
  800f30:	77 d2                	ja     800f04 <__udivdi3+0xd4>
  800f32:	b8 01 00 00 00       	mov    $0x1,%eax
  800f37:	eb cb                	jmp    800f04 <__udivdi3+0xd4>
  800f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f40:	89 d8                	mov    %ebx,%eax
  800f42:	31 ff                	xor    %edi,%edi
  800f44:	eb be                	jmp    800f04 <__udivdi3+0xd4>
  800f46:	66 90                	xchg   %ax,%ax
  800f48:	66 90                	xchg   %ax,%ax
  800f4a:	66 90                	xchg   %ax,%ax
  800f4c:	66 90                	xchg   %ax,%ax
  800f4e:	66 90                	xchg   %ax,%ax

00800f50 <__umoddi3>:
  800f50:	55                   	push   %ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
  800f54:	83 ec 1c             	sub    $0x1c,%esp
  800f57:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f5b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f5f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f67:	85 ed                	test   %ebp,%ebp
  800f69:	89 f0                	mov    %esi,%eax
  800f6b:	89 da                	mov    %ebx,%edx
  800f6d:	75 19                	jne    800f88 <__umoddi3+0x38>
  800f6f:	39 df                	cmp    %ebx,%edi
  800f71:	0f 86 b1 00 00 00    	jbe    801028 <__umoddi3+0xd8>
  800f77:	f7 f7                	div    %edi
  800f79:	89 d0                	mov    %edx,%eax
  800f7b:	31 d2                	xor    %edx,%edx
  800f7d:	83 c4 1c             	add    $0x1c,%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
  800f85:	8d 76 00             	lea    0x0(%esi),%esi
  800f88:	39 dd                	cmp    %ebx,%ebp
  800f8a:	77 f1                	ja     800f7d <__umoddi3+0x2d>
  800f8c:	0f bd cd             	bsr    %ebp,%ecx
  800f8f:	83 f1 1f             	xor    $0x1f,%ecx
  800f92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f96:	0f 84 b4 00 00 00    	je     801050 <__umoddi3+0x100>
  800f9c:	b8 20 00 00 00       	mov    $0x20,%eax
  800fa1:	89 c2                	mov    %eax,%edx
  800fa3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fa7:	29 c2                	sub    %eax,%edx
  800fa9:	89 c1                	mov    %eax,%ecx
  800fab:	89 f8                	mov    %edi,%eax
  800fad:	d3 e5                	shl    %cl,%ebp
  800faf:	89 d1                	mov    %edx,%ecx
  800fb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fb5:	d3 e8                	shr    %cl,%eax
  800fb7:	09 c5                	or     %eax,%ebp
  800fb9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fbd:	89 c1                	mov    %eax,%ecx
  800fbf:	d3 e7                	shl    %cl,%edi
  800fc1:	89 d1                	mov    %edx,%ecx
  800fc3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fc7:	89 df                	mov    %ebx,%edi
  800fc9:	d3 ef                	shr    %cl,%edi
  800fcb:	89 c1                	mov    %eax,%ecx
  800fcd:	89 f0                	mov    %esi,%eax
  800fcf:	d3 e3                	shl    %cl,%ebx
  800fd1:	89 d1                	mov    %edx,%ecx
  800fd3:	89 fa                	mov    %edi,%edx
  800fd5:	d3 e8                	shr    %cl,%eax
  800fd7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fdc:	09 d8                	or     %ebx,%eax
  800fde:	f7 f5                	div    %ebp
  800fe0:	d3 e6                	shl    %cl,%esi
  800fe2:	89 d1                	mov    %edx,%ecx
  800fe4:	f7 64 24 08          	mull   0x8(%esp)
  800fe8:	39 d1                	cmp    %edx,%ecx
  800fea:	89 c3                	mov    %eax,%ebx
  800fec:	89 d7                	mov    %edx,%edi
  800fee:	72 06                	jb     800ff6 <__umoddi3+0xa6>
  800ff0:	75 0e                	jne    801000 <__umoddi3+0xb0>
  800ff2:	39 c6                	cmp    %eax,%esi
  800ff4:	73 0a                	jae    801000 <__umoddi3+0xb0>
  800ff6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800ffa:	19 ea                	sbb    %ebp,%edx
  800ffc:	89 d7                	mov    %edx,%edi
  800ffe:	89 c3                	mov    %eax,%ebx
  801000:	89 ca                	mov    %ecx,%edx
  801002:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801007:	29 de                	sub    %ebx,%esi
  801009:	19 fa                	sbb    %edi,%edx
  80100b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	d3 e0                	shl    %cl,%eax
  801013:	89 d9                	mov    %ebx,%ecx
  801015:	d3 ee                	shr    %cl,%esi
  801017:	d3 ea                	shr    %cl,%edx
  801019:	09 f0                	or     %esi,%eax
  80101b:	83 c4 1c             	add    $0x1c,%esp
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    
  801023:	90                   	nop
  801024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801028:	85 ff                	test   %edi,%edi
  80102a:	89 f9                	mov    %edi,%ecx
  80102c:	75 0b                	jne    801039 <__umoddi3+0xe9>
  80102e:	b8 01 00 00 00       	mov    $0x1,%eax
  801033:	31 d2                	xor    %edx,%edx
  801035:	f7 f7                	div    %edi
  801037:	89 c1                	mov    %eax,%ecx
  801039:	89 d8                	mov    %ebx,%eax
  80103b:	31 d2                	xor    %edx,%edx
  80103d:	f7 f1                	div    %ecx
  80103f:	89 f0                	mov    %esi,%eax
  801041:	f7 f1                	div    %ecx
  801043:	e9 31 ff ff ff       	jmp    800f79 <__umoddi3+0x29>
  801048:	90                   	nop
  801049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801050:	39 dd                	cmp    %ebx,%ebp
  801052:	72 08                	jb     80105c <__umoddi3+0x10c>
  801054:	39 f7                	cmp    %esi,%edi
  801056:	0f 87 21 ff ff ff    	ja     800f7d <__umoddi3+0x2d>
  80105c:	89 da                	mov    %ebx,%edx
  80105e:	89 f0                	mov    %esi,%eax
  801060:	29 f8                	sub    %edi,%eax
  801062:	19 ea                	sbb    %ebp,%edx
  801064:	e9 14 ff ff ff       	jmp    800f7d <__umoddi3+0x2d>
