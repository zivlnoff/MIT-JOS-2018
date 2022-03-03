
obj/user/faultallocbad：     文件格式 elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800040:	68 c0 10 80 00       	push   $0x8010c0
  800045:	e8 9e 01 00 00       	call   8001e8 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 e1 0b 00 00       	call   800c3f <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 0c 11 80 00       	push   $0x80110c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 82 07 00 00       	call   8007f5 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 e0 10 80 00       	push   $0x8010e0
  800085:	6a 0f                	push   $0xf
  800087:	68 ca 10 80 00       	push   $0x8010ca
  80008c:	e8 7c 00 00 00       	call   80010d <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 4d 0d 00 00       	call   800dee <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 d3 0a 00 00       	call   800b83 <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 3c 0b 00 00       	call   800c01 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 a5 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800101:	6a 00                	push   $0x0
  800103:	e8 b8 0a 00 00       	call   800bc0 <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800112:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800115:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80011b:	e8 e1 0a 00 00       	call   800c01 <sys_getenvid>
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	ff 75 0c             	pushl  0xc(%ebp)
  800126:	ff 75 08             	pushl  0x8(%ebp)
  800129:	56                   	push   %esi
  80012a:	50                   	push   %eax
  80012b:	68 38 11 80 00       	push   $0x801138
  800130:	e8 b3 00 00 00       	call   8001e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800135:	83 c4 18             	add    $0x18,%esp
  800138:	53                   	push   %ebx
  800139:	ff 75 10             	pushl  0x10(%ebp)
  80013c:	e8 56 00 00 00       	call   800197 <vcprintf>
	cprintf("\n");
  800141:	c7 04 24 c8 10 80 00 	movl   $0x8010c8,(%esp)
  800148:	e8 9b 00 00 00       	call   8001e8 <cprintf>
  80014d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800150:	cc                   	int3   
  800151:	eb fd                	jmp    800150 <_panic+0x43>

00800153 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	53                   	push   %ebx
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015d:	8b 13                	mov    (%ebx),%edx
  80015f:	8d 42 01             	lea    0x1(%edx),%eax
  800162:	89 03                	mov    %eax,(%ebx)
  800164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800167:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800170:	74 09                	je     80017b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800172:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800179:	c9                   	leave  
  80017a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	68 ff 00 00 00       	push   $0xff
  800183:	8d 43 08             	lea    0x8(%ebx),%eax
  800186:	50                   	push   %eax
  800187:	e8 f7 09 00 00       	call   800b83 <sys_cputs>
		b->idx = 0;
  80018c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	eb db                	jmp    800172 <putch+0x1f>

00800197 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a7:	00 00 00 
	b.cnt = 0;
  8001aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b4:	ff 75 0c             	pushl  0xc(%ebp)
  8001b7:	ff 75 08             	pushl  0x8(%ebp)
  8001ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	68 53 01 80 00       	push   $0x800153
  8001c6:	e8 1a 01 00 00       	call   8002e5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cb:	83 c4 08             	add    $0x8,%esp
  8001ce:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001da:	50                   	push   %eax
  8001db:	e8 a3 09 00 00       	call   800b83 <sys_cputs>

	return b.cnt;
}
  8001e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ee:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f1:	50                   	push   %eax
  8001f2:	ff 75 08             	pushl  0x8(%ebp)
  8001f5:	e8 9d ff ff ff       	call   800197 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	57                   	push   %edi
  800200:	56                   	push   %esi
  800201:	53                   	push   %ebx
  800202:	83 ec 1c             	sub    $0x1c,%esp
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 d6                	mov    %edx,%esi
  800209:	8b 45 08             	mov    0x8(%ebp),%eax
  80020c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800212:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800215:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800218:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800220:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800223:	39 d3                	cmp    %edx,%ebx
  800225:	72 05                	jb     80022c <printnum+0x30>
  800227:	39 45 10             	cmp    %eax,0x10(%ebp)
  80022a:	77 7a                	ja     8002a6 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	ff 75 18             	pushl  0x18(%ebp)
  800232:	8b 45 14             	mov    0x14(%ebp),%eax
  800235:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800238:	53                   	push   %ebx
  800239:	ff 75 10             	pushl  0x10(%ebp)
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800242:	ff 75 e0             	pushl  -0x20(%ebp)
  800245:	ff 75 dc             	pushl  -0x24(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	e8 20 0c 00 00       	call   800e70 <__udivdi3>
  800250:	83 c4 18             	add    $0x18,%esp
  800253:	52                   	push   %edx
  800254:	50                   	push   %eax
  800255:	89 f2                	mov    %esi,%edx
  800257:	89 f8                	mov    %edi,%eax
  800259:	e8 9e ff ff ff       	call   8001fc <printnum>
  80025e:	83 c4 20             	add    $0x20,%esp
  800261:	eb 13                	jmp    800276 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	56                   	push   %esi
  800267:	ff 75 18             	pushl  0x18(%ebp)
  80026a:	ff d7                	call   *%edi
  80026c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80026f:	83 eb 01             	sub    $0x1,%ebx
  800272:	85 db                	test   %ebx,%ebx
  800274:	7f ed                	jg     800263 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	56                   	push   %esi
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800280:	ff 75 e0             	pushl  -0x20(%ebp)
  800283:	ff 75 dc             	pushl  -0x24(%ebp)
  800286:	ff 75 d8             	pushl  -0x28(%ebp)
  800289:	e8 02 0d 00 00       	call   800f90 <__umoddi3>
  80028e:	83 c4 14             	add    $0x14,%esp
  800291:	0f be 80 5c 11 80 00 	movsbl 0x80115c(%eax),%eax
  800298:	50                   	push   %eax
  800299:	ff d7                	call   *%edi
}
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a1:	5b                   	pop    %ebx
  8002a2:	5e                   	pop    %esi
  8002a3:	5f                   	pop    %edi
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    
  8002a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002a9:	eb c4                	jmp    80026f <printnum+0x73>

008002ab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b5:	8b 10                	mov    (%eax),%edx
  8002b7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ba:	73 0a                	jae    8002c6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002bf:	89 08                	mov    %ecx,(%eax)
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c4:	88 02                	mov    %al,(%edx)
}
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <printfmt>:
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ce:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 10             	pushl  0x10(%ebp)
  8002d5:	ff 75 0c             	pushl  0xc(%ebp)
  8002d8:	ff 75 08             	pushl  0x8(%ebp)
  8002db:	e8 05 00 00 00       	call   8002e5 <vprintfmt>
}
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <vprintfmt>:
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 2c             	sub    $0x2c,%esp
  8002ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002f4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f7:	e9 00 04 00 00       	jmp    8006fc <vprintfmt+0x417>
		padc = ' ';
  8002fc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800300:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800307:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80030e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800315:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031a:	8d 47 01             	lea    0x1(%edi),%eax
  80031d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800320:	0f b6 17             	movzbl (%edi),%edx
  800323:	8d 42 dd             	lea    -0x23(%edx),%eax
  800326:	3c 55                	cmp    $0x55,%al
  800328:	0f 87 51 04 00 00    	ja     80077f <vprintfmt+0x49a>
  80032e:	0f b6 c0             	movzbl %al,%eax
  800331:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  800338:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80033b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80033f:	eb d9                	jmp    80031a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800341:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800344:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800348:	eb d0                	jmp    80031a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80034a:	0f b6 d2             	movzbl %dl,%edx
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800358:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80035b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80035f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800362:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800365:	83 f9 09             	cmp    $0x9,%ecx
  800368:	77 55                	ja     8003bf <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80036a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80036d:	eb e9                	jmp    800358 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80036f:	8b 45 14             	mov    0x14(%ebp),%eax
  800372:	8b 00                	mov    (%eax),%eax
  800374:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8d 40 04             	lea    0x4(%eax),%eax
  80037d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800383:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800387:	79 91                	jns    80031a <vprintfmt+0x35>
				width = precision, precision = -1;
  800389:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80038c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80038f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800396:	eb 82                	jmp    80031a <vprintfmt+0x35>
  800398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a2:	0f 49 d0             	cmovns %eax,%edx
  8003a5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ab:	e9 6a ff ff ff       	jmp    80031a <vprintfmt+0x35>
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003b3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ba:	e9 5b ff ff ff       	jmp    80031a <vprintfmt+0x35>
  8003bf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003c5:	eb bc                	jmp    800383 <vprintfmt+0x9e>
			lflag++;
  8003c7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003cd:	e9 48 ff ff ff       	jmp    80031a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d5:	8d 78 04             	lea    0x4(%eax),%edi
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	53                   	push   %ebx
  8003dc:	ff 30                	pushl  (%eax)
  8003de:	ff d6                	call   *%esi
			break;
  8003e0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003e6:	e9 0e 03 00 00       	jmp    8006f9 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	8d 78 04             	lea    0x4(%eax),%edi
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	99                   	cltd   
  8003f4:	31 d0                	xor    %edx,%eax
  8003f6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f8:	83 f8 08             	cmp    $0x8,%eax
  8003fb:	7f 23                	jg     800420 <vprintfmt+0x13b>
  8003fd:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800404:	85 d2                	test   %edx,%edx
  800406:	74 18                	je     800420 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800408:	52                   	push   %edx
  800409:	68 7d 11 80 00       	push   $0x80117d
  80040e:	53                   	push   %ebx
  80040f:	56                   	push   %esi
  800410:	e8 b3 fe ff ff       	call   8002c8 <printfmt>
  800415:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800418:	89 7d 14             	mov    %edi,0x14(%ebp)
  80041b:	e9 d9 02 00 00       	jmp    8006f9 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800420:	50                   	push   %eax
  800421:	68 74 11 80 00       	push   $0x801174
  800426:	53                   	push   %ebx
  800427:	56                   	push   %esi
  800428:	e8 9b fe ff ff       	call   8002c8 <printfmt>
  80042d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800430:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800433:	e9 c1 02 00 00       	jmp    8006f9 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	83 c0 04             	add    $0x4,%eax
  80043e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800441:	8b 45 14             	mov    0x14(%ebp),%eax
  800444:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800446:	85 ff                	test   %edi,%edi
  800448:	b8 6d 11 80 00       	mov    $0x80116d,%eax
  80044d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800450:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800454:	0f 8e bd 00 00 00    	jle    800517 <vprintfmt+0x232>
  80045a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80045e:	75 0e                	jne    80046e <vprintfmt+0x189>
  800460:	89 75 08             	mov    %esi,0x8(%ebp)
  800463:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800466:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800469:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80046c:	eb 6d                	jmp    8004db <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 d0             	pushl  -0x30(%ebp)
  800474:	57                   	push   %edi
  800475:	e8 ad 03 00 00       	call   800827 <strnlen>
  80047a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047d:	29 c1                	sub    %eax,%ecx
  80047f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800482:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800485:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800489:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80048f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	eb 0f                	jmp    8004a2 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	53                   	push   %ebx
  800497:	ff 75 e0             	pushl  -0x20(%ebp)
  80049a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049c:	83 ef 01             	sub    $0x1,%edi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	85 ff                	test   %edi,%edi
  8004a4:	7f ed                	jg     800493 <vprintfmt+0x1ae>
  8004a6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004a9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ac:	85 c9                	test   %ecx,%ecx
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	0f 49 c1             	cmovns %ecx,%eax
  8004b6:	29 c1                	sub    %eax,%ecx
  8004b8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004bb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c1:	89 cb                	mov    %ecx,%ebx
  8004c3:	eb 16                	jmp    8004db <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c9:	75 31                	jne    8004fc <vprintfmt+0x217>
					putch(ch, putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	50                   	push   %eax
  8004d2:	ff 55 08             	call   *0x8(%ebp)
  8004d5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d8:	83 eb 01             	sub    $0x1,%ebx
  8004db:	83 c7 01             	add    $0x1,%edi
  8004de:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004e2:	0f be c2             	movsbl %dl,%eax
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	74 59                	je     800542 <vprintfmt+0x25d>
  8004e9:	85 f6                	test   %esi,%esi
  8004eb:	78 d8                	js     8004c5 <vprintfmt+0x1e0>
  8004ed:	83 ee 01             	sub    $0x1,%esi
  8004f0:	79 d3                	jns    8004c5 <vprintfmt+0x1e0>
  8004f2:	89 df                	mov    %ebx,%edi
  8004f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004fa:	eb 37                	jmp    800533 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004fc:	0f be d2             	movsbl %dl,%edx
  8004ff:	83 ea 20             	sub    $0x20,%edx
  800502:	83 fa 5e             	cmp    $0x5e,%edx
  800505:	76 c4                	jbe    8004cb <vprintfmt+0x1e6>
					putch('?', putdat);
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	6a 3f                	push   $0x3f
  80050f:	ff 55 08             	call   *0x8(%ebp)
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	eb c1                	jmp    8004d8 <vprintfmt+0x1f3>
  800517:	89 75 08             	mov    %esi,0x8(%ebp)
  80051a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80051d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800520:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800523:	eb b6                	jmp    8004db <vprintfmt+0x1f6>
				putch(' ', putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	6a 20                	push   $0x20
  80052b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80052d:	83 ef 01             	sub    $0x1,%edi
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	85 ff                	test   %edi,%edi
  800535:	7f ee                	jg     800525 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800537:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80053a:	89 45 14             	mov    %eax,0x14(%ebp)
  80053d:	e9 b7 01 00 00       	jmp    8006f9 <vprintfmt+0x414>
  800542:	89 df                	mov    %ebx,%edi
  800544:	8b 75 08             	mov    0x8(%ebp),%esi
  800547:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80054a:	eb e7                	jmp    800533 <vprintfmt+0x24e>
	if (lflag >= 2)
  80054c:	83 f9 01             	cmp    $0x1,%ecx
  80054f:	7e 3f                	jle    800590 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8b 50 04             	mov    0x4(%eax),%edx
  800557:	8b 00                	mov    (%eax),%eax
  800559:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8d 40 08             	lea    0x8(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800568:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80056c:	79 5c                	jns    8005ca <vprintfmt+0x2e5>
				putch('-', putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	53                   	push   %ebx
  800572:	6a 2d                	push   $0x2d
  800574:	ff d6                	call   *%esi
				num = -(long long) num;
  800576:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800579:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80057c:	f7 da                	neg    %edx
  80057e:	83 d1 00             	adc    $0x0,%ecx
  800581:	f7 d9                	neg    %ecx
  800583:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800586:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058b:	e9 4f 01 00 00       	jmp    8006df <vprintfmt+0x3fa>
	else if (lflag)
  800590:	85 c9                	test   %ecx,%ecx
  800592:	75 1b                	jne    8005af <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	89 c1                	mov    %eax,%ecx
  80059e:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ad:	eb b9                	jmp    800568 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b7:	89 c1                	mov    %eax,%ecx
  8005b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 04             	lea    0x4(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c8:	eb 9e                	jmp    800568 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d5:	e9 05 01 00 00       	jmp    8006df <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005da:	83 f9 01             	cmp    $0x1,%ecx
  8005dd:	7e 18                	jle    8005f7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 10                	mov    (%eax),%edx
  8005e4:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e7:	8d 40 08             	lea    0x8(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	e9 e8 00 00 00       	jmp    8006df <vprintfmt+0x3fa>
	else if (lflag)
  8005f7:	85 c9                	test   %ecx,%ecx
  8005f9:	75 1a                	jne    800615 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8b 10                	mov    (%eax),%edx
  800600:	b9 00 00 00 00       	mov    $0x0,%ecx
  800605:	8d 40 04             	lea    0x4(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 ca 00 00 00       	jmp    8006df <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062a:	e9 b0 00 00 00       	jmp    8006df <vprintfmt+0x3fa>
	if (lflag >= 2)
  80062f:	83 f9 01             	cmp    $0x1,%ecx
  800632:	7e 3c                	jle    800670 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 50 04             	mov    0x4(%eax),%edx
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 40 08             	lea    0x8(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80064b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80064f:	79 59                	jns    8006aa <vprintfmt+0x3c5>
                putch('-', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	6a 2d                	push   $0x2d
  800657:	ff d6                	call   *%esi
                num = -(long long) num;
  800659:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80065c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80065f:	f7 da                	neg    %edx
  800661:	83 d1 00             	adc    $0x0,%ecx
  800664:	f7 d9                	neg    %ecx
  800666:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800669:	b8 08 00 00 00       	mov    $0x8,%eax
  80066e:	eb 6f                	jmp    8006df <vprintfmt+0x3fa>
	else if (lflag)
  800670:	85 c9                	test   %ecx,%ecx
  800672:	75 1b                	jne    80068f <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 c1                	mov    %eax,%ecx
  80067e:	c1 f9 1f             	sar    $0x1f,%ecx
  800681:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
  80068d:	eb bc                	jmp    80064b <vprintfmt+0x366>
		return va_arg(*ap, long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800697:	89 c1                	mov    %eax,%ecx
  800699:	c1 f9 1f             	sar    $0x1f,%ecx
  80069c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a8:	eb a1                	jmp    80064b <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b5:	eb 28                	jmp    8006df <vprintfmt+0x3fa>
			putch('0', putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 30                	push   $0x30
  8006bd:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bf:	83 c4 08             	add    $0x8,%esp
  8006c2:	53                   	push   %ebx
  8006c3:	6a 78                	push   $0x78
  8006c5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8b 10                	mov    (%eax),%edx
  8006cc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006da:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006e6:	57                   	push   %edi
  8006e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ea:	50                   	push   %eax
  8006eb:	51                   	push   %ecx
  8006ec:	52                   	push   %edx
  8006ed:	89 da                	mov    %ebx,%edx
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	e8 06 fb ff ff       	call   8001fc <printnum>
			break;
  8006f6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fc:	83 c7 01             	add    $0x1,%edi
  8006ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800703:	83 f8 25             	cmp    $0x25,%eax
  800706:	0f 84 f0 fb ff ff    	je     8002fc <vprintfmt+0x17>
			if (ch == '\0')
  80070c:	85 c0                	test   %eax,%eax
  80070e:	0f 84 8b 00 00 00    	je     80079f <vprintfmt+0x4ba>
			putch(ch, putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	50                   	push   %eax
  800719:	ff d6                	call   *%esi
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	eb dc                	jmp    8006fc <vprintfmt+0x417>
	if (lflag >= 2)
  800720:	83 f9 01             	cmp    $0x1,%ecx
  800723:	7e 15                	jle    80073a <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 10                	mov    (%eax),%edx
  80072a:	8b 48 04             	mov    0x4(%eax),%ecx
  80072d:	8d 40 08             	lea    0x8(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800733:	b8 10 00 00 00       	mov    $0x10,%eax
  800738:	eb a5                	jmp    8006df <vprintfmt+0x3fa>
	else if (lflag)
  80073a:	85 c9                	test   %ecx,%ecx
  80073c:	75 17                	jne    800755 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 10                	mov    (%eax),%edx
  800743:	b9 00 00 00 00       	mov    $0x0,%ecx
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074e:	b8 10 00 00 00       	mov    $0x10,%eax
  800753:	eb 8a                	jmp    8006df <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 10                	mov    (%eax),%edx
  80075a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075f:	8d 40 04             	lea    0x4(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800765:	b8 10 00 00 00       	mov    $0x10,%eax
  80076a:	e9 70 ff ff ff       	jmp    8006df <vprintfmt+0x3fa>
			putch(ch, putdat);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	53                   	push   %ebx
  800773:	6a 25                	push   $0x25
  800775:	ff d6                	call   *%esi
			break;
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	e9 7a ff ff ff       	jmp    8006f9 <vprintfmt+0x414>
			putch('%', putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	53                   	push   %ebx
  800783:	6a 25                	push   $0x25
  800785:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 f8                	mov    %edi,%eax
  80078c:	eb 03                	jmp    800791 <vprintfmt+0x4ac>
  80078e:	83 e8 01             	sub    $0x1,%eax
  800791:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800795:	75 f7                	jne    80078e <vprintfmt+0x4a9>
  800797:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079a:	e9 5a ff ff ff       	jmp    8006f9 <vprintfmt+0x414>
}
  80079f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a2:	5b                   	pop    %ebx
  8007a3:	5e                   	pop    %esi
  8007a4:	5f                   	pop    %edi
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	83 ec 18             	sub    $0x18,%esp
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	74 26                	je     8007ee <vsnprintf+0x47>
  8007c8:	85 d2                	test   %edx,%edx
  8007ca:	7e 22                	jle    8007ee <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cc:	ff 75 14             	pushl  0x14(%ebp)
  8007cf:	ff 75 10             	pushl  0x10(%ebp)
  8007d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d5:	50                   	push   %eax
  8007d6:	68 ab 02 80 00       	push   $0x8002ab
  8007db:	e8 05 fb ff ff       	call   8002e5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
}
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    
		return -E_INVAL;
  8007ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f3:	eb f7                	jmp    8007ec <vsnprintf+0x45>

008007f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007fe:	50                   	push   %eax
  8007ff:	ff 75 10             	pushl  0x10(%ebp)
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	ff 75 08             	pushl  0x8(%ebp)
  800808:	e8 9a ff ff ff       	call   8007a7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800815:	b8 00 00 00 00       	mov    $0x0,%eax
  80081a:	eb 03                	jmp    80081f <strlen+0x10>
		n++;
  80081c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80081f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800823:	75 f7                	jne    80081c <strlen+0xd>
	return n;
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800830:	b8 00 00 00 00       	mov    $0x0,%eax
  800835:	eb 03                	jmp    80083a <strnlen+0x13>
		n++;
  800837:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083a:	39 d0                	cmp    %edx,%eax
  80083c:	74 06                	je     800844 <strnlen+0x1d>
  80083e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800842:	75 f3                	jne    800837 <strnlen+0x10>
	return n;
}
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	53                   	push   %ebx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800850:	89 c2                	mov    %eax,%edx
  800852:	83 c1 01             	add    $0x1,%ecx
  800855:	83 c2 01             	add    $0x1,%edx
  800858:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80085c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80085f:	84 db                	test   %bl,%bl
  800861:	75 ef                	jne    800852 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	53                   	push   %ebx
  80086a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086d:	53                   	push   %ebx
  80086e:	e8 9c ff ff ff       	call   80080f <strlen>
  800873:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	01 d8                	add    %ebx,%eax
  80087b:	50                   	push   %eax
  80087c:	e8 c5 ff ff ff       	call   800846 <strcpy>
	return dst;
}
  800881:	89 d8                	mov    %ebx,%eax
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	8b 75 08             	mov    0x8(%ebp),%esi
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800893:	89 f3                	mov    %esi,%ebx
  800895:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800898:	89 f2                	mov    %esi,%edx
  80089a:	eb 0f                	jmp    8008ab <strncpy+0x23>
		*dst++ = *src;
  80089c:	83 c2 01             	add    $0x1,%edx
  80089f:	0f b6 01             	movzbl (%ecx),%eax
  8008a2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a5:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a8:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008ab:	39 da                	cmp    %ebx,%edx
  8008ad:	75 ed                	jne    80089c <strncpy+0x14>
	}
	return ret;
}
  8008af:	89 f0                	mov    %esi,%eax
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	56                   	push   %esi
  8008b9:	53                   	push   %ebx
  8008ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008c3:	89 f0                	mov    %esi,%eax
  8008c5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c9:	85 c9                	test   %ecx,%ecx
  8008cb:	75 0b                	jne    8008d8 <strlcpy+0x23>
  8008cd:	eb 17                	jmp    8008e6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	83 c0 01             	add    $0x1,%eax
  8008d5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008d8:	39 d8                	cmp    %ebx,%eax
  8008da:	74 07                	je     8008e3 <strlcpy+0x2e>
  8008dc:	0f b6 0a             	movzbl (%edx),%ecx
  8008df:	84 c9                	test   %cl,%cl
  8008e1:	75 ec                	jne    8008cf <strlcpy+0x1a>
		*dst = '\0';
  8008e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e6:	29 f0                	sub    %esi,%eax
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5e                   	pop    %esi
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f5:	eb 06                	jmp    8008fd <strcmp+0x11>
		p++, q++;
  8008f7:	83 c1 01             	add    $0x1,%ecx
  8008fa:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008fd:	0f b6 01             	movzbl (%ecx),%eax
  800900:	84 c0                	test   %al,%al
  800902:	74 04                	je     800908 <strcmp+0x1c>
  800904:	3a 02                	cmp    (%edx),%al
  800906:	74 ef                	je     8008f7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800908:	0f b6 c0             	movzbl %al,%eax
  80090b:	0f b6 12             	movzbl (%edx),%edx
  80090e:	29 d0                	sub    %edx,%eax
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	53                   	push   %ebx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 c3                	mov    %eax,%ebx
  80091e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800921:	eb 06                	jmp    800929 <strncmp+0x17>
		n--, p++, q++;
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800929:	39 d8                	cmp    %ebx,%eax
  80092b:	74 16                	je     800943 <strncmp+0x31>
  80092d:	0f b6 08             	movzbl (%eax),%ecx
  800930:	84 c9                	test   %cl,%cl
  800932:	74 04                	je     800938 <strncmp+0x26>
  800934:	3a 0a                	cmp    (%edx),%cl
  800936:	74 eb                	je     800923 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 00             	movzbl (%eax),%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5b                   	pop    %ebx
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    
		return 0;
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
  800948:	eb f6                	jmp    800940 <strncmp+0x2e>

0080094a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800954:	0f b6 10             	movzbl (%eax),%edx
  800957:	84 d2                	test   %dl,%dl
  800959:	74 09                	je     800964 <strchr+0x1a>
		if (*s == c)
  80095b:	38 ca                	cmp    %cl,%dl
  80095d:	74 0a                	je     800969 <strchr+0x1f>
	for (; *s; s++)
  80095f:	83 c0 01             	add    $0x1,%eax
  800962:	eb f0                	jmp    800954 <strchr+0xa>
			return (char *) s;
	return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800975:	eb 03                	jmp    80097a <strfind+0xf>
  800977:	83 c0 01             	add    $0x1,%eax
  80097a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80097d:	38 ca                	cmp    %cl,%dl
  80097f:	74 04                	je     800985 <strfind+0x1a>
  800981:	84 d2                	test   %dl,%dl
  800983:	75 f2                	jne    800977 <strfind+0xc>
			break;
	return (char *) s;
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	57                   	push   %edi
  80098b:	56                   	push   %esi
  80098c:	53                   	push   %ebx
  80098d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800990:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800993:	85 c9                	test   %ecx,%ecx
  800995:	74 13                	je     8009aa <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800997:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099d:	75 05                	jne    8009a4 <memset+0x1d>
  80099f:	f6 c1 03             	test   $0x3,%cl
  8009a2:	74 0d                	je     8009b1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a7:	fc                   	cld    
  8009a8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009aa:	89 f8                	mov    %edi,%eax
  8009ac:	5b                   	pop    %ebx
  8009ad:	5e                   	pop    %esi
  8009ae:	5f                   	pop    %edi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    
		c &= 0xFF;
  8009b1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b5:	89 d3                	mov    %edx,%ebx
  8009b7:	c1 e3 08             	shl    $0x8,%ebx
  8009ba:	89 d0                	mov    %edx,%eax
  8009bc:	c1 e0 18             	shl    $0x18,%eax
  8009bf:	89 d6                	mov    %edx,%esi
  8009c1:	c1 e6 10             	shl    $0x10,%esi
  8009c4:	09 f0                	or     %esi,%eax
  8009c6:	09 c2                	or     %eax,%edx
  8009c8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009ca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	fc                   	cld    
  8009d0:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d2:	eb d6                	jmp    8009aa <memset+0x23>

008009d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	57                   	push   %edi
  8009d8:	56                   	push   %esi
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009df:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e2:	39 c6                	cmp    %eax,%esi
  8009e4:	73 35                	jae    800a1b <memmove+0x47>
  8009e6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	76 2e                	jbe    800a1b <memmove+0x47>
		s += n;
		d += n;
  8009ed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f0:	89 d6                	mov    %edx,%esi
  8009f2:	09 fe                	or     %edi,%esi
  8009f4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fa:	74 0c                	je     800a08 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009fc:	83 ef 01             	sub    $0x1,%edi
  8009ff:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a02:	fd                   	std    
  800a03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a05:	fc                   	cld    
  800a06:	eb 21                	jmp    800a29 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a08:	f6 c1 03             	test   $0x3,%cl
  800a0b:	75 ef                	jne    8009fc <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0d:	83 ef 04             	sub    $0x4,%edi
  800a10:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a16:	fd                   	std    
  800a17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a19:	eb ea                	jmp    800a05 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1b:	89 f2                	mov    %esi,%edx
  800a1d:	09 c2                	or     %eax,%edx
  800a1f:	f6 c2 03             	test   $0x3,%dl
  800a22:	74 09                	je     800a2d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a24:	89 c7                	mov    %eax,%edi
  800a26:	fc                   	cld    
  800a27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a29:	5e                   	pop    %esi
  800a2a:	5f                   	pop    %edi
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2d:	f6 c1 03             	test   $0x3,%cl
  800a30:	75 f2                	jne    800a24 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a35:	89 c7                	mov    %eax,%edi
  800a37:	fc                   	cld    
  800a38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3a:	eb ed                	jmp    800a29 <memmove+0x55>

00800a3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a3f:	ff 75 10             	pushl  0x10(%ebp)
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	ff 75 08             	pushl  0x8(%ebp)
  800a48:	e8 87 ff ff ff       	call   8009d4 <memmove>
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	89 c6                	mov    %eax,%esi
  800a5c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5f:	39 f0                	cmp    %esi,%eax
  800a61:	74 1c                	je     800a7f <memcmp+0x30>
		if (*s1 != *s2)
  800a63:	0f b6 08             	movzbl (%eax),%ecx
  800a66:	0f b6 1a             	movzbl (%edx),%ebx
  800a69:	38 d9                	cmp    %bl,%cl
  800a6b:	75 08                	jne    800a75 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6d:	83 c0 01             	add    $0x1,%eax
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	eb ea                	jmp    800a5f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a75:	0f b6 c1             	movzbl %cl,%eax
  800a78:	0f b6 db             	movzbl %bl,%ebx
  800a7b:	29 d8                	sub    %ebx,%eax
  800a7d:	eb 05                	jmp    800a84 <memcmp+0x35>
	}

	return 0;
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a91:	89 c2                	mov    %eax,%edx
  800a93:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a96:	39 d0                	cmp    %edx,%eax
  800a98:	73 09                	jae    800aa3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9a:	38 08                	cmp    %cl,(%eax)
  800a9c:	74 05                	je     800aa3 <memfind+0x1b>
	for (; s < ends; s++)
  800a9e:	83 c0 01             	add    $0x1,%eax
  800aa1:	eb f3                	jmp    800a96 <memfind+0xe>
			break;
	return (void *) s;
}
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	57                   	push   %edi
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab1:	eb 03                	jmp    800ab6 <strtol+0x11>
		s++;
  800ab3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab6:	0f b6 01             	movzbl (%ecx),%eax
  800ab9:	3c 20                	cmp    $0x20,%al
  800abb:	74 f6                	je     800ab3 <strtol+0xe>
  800abd:	3c 09                	cmp    $0x9,%al
  800abf:	74 f2                	je     800ab3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac1:	3c 2b                	cmp    $0x2b,%al
  800ac3:	74 2e                	je     800af3 <strtol+0x4e>
	int neg = 0;
  800ac5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aca:	3c 2d                	cmp    $0x2d,%al
  800acc:	74 2f                	je     800afd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ace:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad4:	75 05                	jne    800adb <strtol+0x36>
  800ad6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad9:	74 2c                	je     800b07 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800adb:	85 db                	test   %ebx,%ebx
  800add:	75 0a                	jne    800ae9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800adf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ae4:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae7:	74 28                	je     800b11 <strtol+0x6c>
		base = 10;
  800ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af1:	eb 50                	jmp    800b43 <strtol+0x9e>
		s++;
  800af3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800af6:	bf 00 00 00 00       	mov    $0x0,%edi
  800afb:	eb d1                	jmp    800ace <strtol+0x29>
		s++, neg = 1;
  800afd:	83 c1 01             	add    $0x1,%ecx
  800b00:	bf 01 00 00 00       	mov    $0x1,%edi
  800b05:	eb c7                	jmp    800ace <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b07:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b0b:	74 0e                	je     800b1b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b0d:	85 db                	test   %ebx,%ebx
  800b0f:	75 d8                	jne    800ae9 <strtol+0x44>
		s++, base = 8;
  800b11:	83 c1 01             	add    $0x1,%ecx
  800b14:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b19:	eb ce                	jmp    800ae9 <strtol+0x44>
		s += 2, base = 16;
  800b1b:	83 c1 02             	add    $0x2,%ecx
  800b1e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b23:	eb c4                	jmp    800ae9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b25:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b28:	89 f3                	mov    %esi,%ebx
  800b2a:	80 fb 19             	cmp    $0x19,%bl
  800b2d:	77 29                	ja     800b58 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b2f:	0f be d2             	movsbl %dl,%edx
  800b32:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b38:	7d 30                	jge    800b6a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b3a:	83 c1 01             	add    $0x1,%ecx
  800b3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b41:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b43:	0f b6 11             	movzbl (%ecx),%edx
  800b46:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b49:	89 f3                	mov    %esi,%ebx
  800b4b:	80 fb 09             	cmp    $0x9,%bl
  800b4e:	77 d5                	ja     800b25 <strtol+0x80>
			dig = *s - '0';
  800b50:	0f be d2             	movsbl %dl,%edx
  800b53:	83 ea 30             	sub    $0x30,%edx
  800b56:	eb dd                	jmp    800b35 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b58:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b5b:	89 f3                	mov    %esi,%ebx
  800b5d:	80 fb 19             	cmp    $0x19,%bl
  800b60:	77 08                	ja     800b6a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b62:	0f be d2             	movsbl %dl,%edx
  800b65:	83 ea 37             	sub    $0x37,%edx
  800b68:	eb cb                	jmp    800b35 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6e:	74 05                	je     800b75 <strtol+0xd0>
		*endptr = (char *) s;
  800b70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b73:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	f7 da                	neg    %edx
  800b79:	85 ff                	test   %edi,%edi
  800b7b:	0f 45 c2             	cmovne %edx,%eax
}
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b89:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b94:	89 c3                	mov    %eax,%ebx
  800b96:	89 c7                	mov    %eax,%edi
  800b98:	89 c6                	mov    %eax,%esi
  800b9a:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5f                   	pop    %edi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <sys_cgetc>:

int
sys_cgetc(void) {
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bac:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb1:	89 d1                	mov    %edx,%ecx
  800bb3:	89 d3                	mov    %edx,%ebx
  800bb5:	89 d7                	mov    %edx,%edi
  800bb7:	89 d6                	mov    %edx,%esi
  800bb9:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bbb:	5b                   	pop    %ebx
  800bbc:	5e                   	pop    %esi
  800bbd:	5f                   	pop    %edi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	57                   	push   %edi
  800bc4:	56                   	push   %esi
  800bc5:	53                   	push   %ebx
  800bc6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bce:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd6:	89 cb                	mov    %ecx,%ebx
  800bd8:	89 cf                	mov    %ecx,%edi
  800bda:	89 ce                	mov    %ecx,%esi
  800bdc:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bde:	85 c0                	test   %eax,%eax
  800be0:	7f 08                	jg     800bea <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	50                   	push   %eax
  800bee:	6a 03                	push   $0x3
  800bf0:	68 a4 13 80 00       	push   $0x8013a4
  800bf5:	6a 24                	push   $0x24
  800bf7:	68 c1 13 80 00       	push   $0x8013c1
  800bfc:	e8 0c f5 ff ff       	call   80010d <_panic>

00800c01 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	57                   	push   %edi
  800c05:	56                   	push   %esi
  800c06:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c07:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c11:	89 d1                	mov    %edx,%ecx
  800c13:	89 d3                	mov    %edx,%ebx
  800c15:	89 d7                	mov    %edx,%edi
  800c17:	89 d6                	mov    %edx,%esi
  800c19:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <sys_yield>:

void
sys_yield(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c26:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c30:	89 d1                	mov    %edx,%ecx
  800c32:	89 d3                	mov    %edx,%ebx
  800c34:	89 d7                	mov    %edx,%edi
  800c36:	89 d6                	mov    %edx,%esi
  800c38:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3a:	5b                   	pop    %ebx
  800c3b:	5e                   	pop    %esi
  800c3c:	5f                   	pop    %edi
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c48:	be 00 00 00 00       	mov    $0x0,%esi
  800c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	b8 04 00 00 00       	mov    $0x4,%eax
  800c58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5b:	89 f7                	mov    %esi,%edi
  800c5d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	7f 08                	jg     800c6b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	50                   	push   %eax
  800c6f:	6a 04                	push   $0x4
  800c71:	68 a4 13 80 00       	push   $0x8013a4
  800c76:	6a 24                	push   $0x24
  800c78:	68 c1 13 80 00       	push   $0x8013c1
  800c7d:	e8 8b f4 ff ff       	call   80010d <_panic>

00800c82 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c91:	b8 05 00 00 00       	mov    $0x5,%eax
  800c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800c9f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	7f 08                	jg     800cad <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	83 ec 0c             	sub    $0xc,%esp
  800cb0:	50                   	push   %eax
  800cb1:	6a 05                	push   $0x5
  800cb3:	68 a4 13 80 00       	push   $0x8013a4
  800cb8:	6a 24                	push   $0x24
  800cba:	68 c1 13 80 00       	push   $0x8013c1
  800cbf:	e8 49 f4 ff ff       	call   80010d <_panic>

00800cc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cdd:	89 df                	mov    %ebx,%edi
  800cdf:	89 de                	mov    %ebx,%esi
  800ce1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7f 08                	jg     800cef <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	6a 06                	push   $0x6
  800cf5:	68 a4 13 80 00       	push   $0x8013a4
  800cfa:	6a 24                	push   $0x24
  800cfc:	68 c1 13 80 00       	push   $0x8013c1
  800d01:	e8 07 f4 ff ff       	call   80010d <_panic>

00800d06 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d1f:	89 df                	mov    %ebx,%edi
  800d21:	89 de                	mov    %ebx,%esi
  800d23:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 08                	push   $0x8
  800d37:	68 a4 13 80 00       	push   $0x8013a4
  800d3c:	6a 24                	push   $0x24
  800d3e:	68 c1 13 80 00       	push   $0x8013c1
  800d43:	e8 c5 f3 ff ff       	call   80010d <_panic>

00800d48 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5c:	b8 09 00 00 00       	mov    $0x9,%eax
  800d61:	89 df                	mov    %ebx,%edi
  800d63:	89 de                	mov    %ebx,%esi
  800d65:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7f 08                	jg     800d73 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	50                   	push   %eax
  800d77:	6a 09                	push   $0x9
  800d79:	68 a4 13 80 00       	push   $0x8013a4
  800d7e:	6a 24                	push   $0x24
  800d80:	68 c1 13 80 00       	push   $0x8013c1
  800d85:	e8 83 f3 ff ff       	call   80010d <_panic>

00800d8a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d9b:	be 00 00 00 00       	mov    $0x0,%esi
  800da0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800db6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc3:	89 cb                	mov    %ecx,%ebx
  800dc5:	89 cf                	mov    %ecx,%edi
  800dc7:	89 ce                	mov    %ecx,%esi
  800dc9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	7f 08                	jg     800dd7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dd7:	83 ec 0c             	sub    $0xc,%esp
  800dda:	50                   	push   %eax
  800ddb:	6a 0c                	push   $0xc
  800ddd:	68 a4 13 80 00       	push   $0x8013a4
  800de2:	6a 24                	push   $0x24
  800de4:	68 c1 13 80 00       	push   $0x8013c1
  800de9:	e8 1f f3 ff ff       	call   80010d <_panic>

00800dee <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800df4:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800dfb:	74 0a                	je     800e07 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  800e07:	a1 04 20 80 00       	mov    0x802004,%eax
  800e0c:	8b 40 48             	mov    0x48(%eax),%eax
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	6a 07                	push   $0x7
  800e14:	68 00 f0 bf ee       	push   $0xeebff000
  800e19:	25 ff 03 00 00       	and    $0x3ff,%eax
  800e1e:	50                   	push   %eax
  800e1f:	e8 1b fe ff ff       	call   800c3f <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  800e24:	a1 04 20 80 00       	mov    0x802004,%eax
  800e29:	8b 40 48             	mov    0x48(%eax),%eax
  800e2c:	83 c4 08             	add    $0x8,%esp
  800e2f:	68 44 0e 80 00       	push   $0x800e44
  800e34:	25 ff 03 00 00       	and    $0x3ff,%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 09 ff ff ff       	call   800d48 <sys_env_set_pgfault_upcall>
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	eb b9                	jmp    800dfd <set_pgfault_handler+0xf>

00800e44 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e44:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e45:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800e4a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e4c:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  800e4f:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  800e53:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  800e57:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  800e5a:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  800e5c:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  800e60:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  800e63:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  800e64:	83 c4 04             	add    $0x4,%esp
    popfl
  800e67:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  800e68:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800e69:	c3                   	ret    
  800e6a:	66 90                	xchg   %ax,%ax
  800e6c:	66 90                	xchg   %ax,%ax
  800e6e:	66 90                	xchg   %ax,%ax

00800e70 <__udivdi3>:
  800e70:	55                   	push   %ebp
  800e71:	57                   	push   %edi
  800e72:	56                   	push   %esi
  800e73:	53                   	push   %ebx
  800e74:	83 ec 1c             	sub    $0x1c,%esp
  800e77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e87:	85 d2                	test   %edx,%edx
  800e89:	75 35                	jne    800ec0 <__udivdi3+0x50>
  800e8b:	39 f3                	cmp    %esi,%ebx
  800e8d:	0f 87 bd 00 00 00    	ja     800f50 <__udivdi3+0xe0>
  800e93:	85 db                	test   %ebx,%ebx
  800e95:	89 d9                	mov    %ebx,%ecx
  800e97:	75 0b                	jne    800ea4 <__udivdi3+0x34>
  800e99:	b8 01 00 00 00       	mov    $0x1,%eax
  800e9e:	31 d2                	xor    %edx,%edx
  800ea0:	f7 f3                	div    %ebx
  800ea2:	89 c1                	mov    %eax,%ecx
  800ea4:	31 d2                	xor    %edx,%edx
  800ea6:	89 f0                	mov    %esi,%eax
  800ea8:	f7 f1                	div    %ecx
  800eaa:	89 c6                	mov    %eax,%esi
  800eac:	89 e8                	mov    %ebp,%eax
  800eae:	89 f7                	mov    %esi,%edi
  800eb0:	f7 f1                	div    %ecx
  800eb2:	89 fa                	mov    %edi,%edx
  800eb4:	83 c4 1c             	add    $0x1c,%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
  800ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	39 f2                	cmp    %esi,%edx
  800ec2:	77 7c                	ja     800f40 <__udivdi3+0xd0>
  800ec4:	0f bd fa             	bsr    %edx,%edi
  800ec7:	83 f7 1f             	xor    $0x1f,%edi
  800eca:	0f 84 98 00 00 00    	je     800f68 <__udivdi3+0xf8>
  800ed0:	89 f9                	mov    %edi,%ecx
  800ed2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ed7:	29 f8                	sub    %edi,%eax
  800ed9:	d3 e2                	shl    %cl,%edx
  800edb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800edf:	89 c1                	mov    %eax,%ecx
  800ee1:	89 da                	mov    %ebx,%edx
  800ee3:	d3 ea                	shr    %cl,%edx
  800ee5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ee9:	09 d1                	or     %edx,%ecx
  800eeb:	89 f2                	mov    %esi,%edx
  800eed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ef1:	89 f9                	mov    %edi,%ecx
  800ef3:	d3 e3                	shl    %cl,%ebx
  800ef5:	89 c1                	mov    %eax,%ecx
  800ef7:	d3 ea                	shr    %cl,%edx
  800ef9:	89 f9                	mov    %edi,%ecx
  800efb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800eff:	d3 e6                	shl    %cl,%esi
  800f01:	89 eb                	mov    %ebp,%ebx
  800f03:	89 c1                	mov    %eax,%ecx
  800f05:	d3 eb                	shr    %cl,%ebx
  800f07:	09 de                	or     %ebx,%esi
  800f09:	89 f0                	mov    %esi,%eax
  800f0b:	f7 74 24 08          	divl   0x8(%esp)
  800f0f:	89 d6                	mov    %edx,%esi
  800f11:	89 c3                	mov    %eax,%ebx
  800f13:	f7 64 24 0c          	mull   0xc(%esp)
  800f17:	39 d6                	cmp    %edx,%esi
  800f19:	72 0c                	jb     800f27 <__udivdi3+0xb7>
  800f1b:	89 f9                	mov    %edi,%ecx
  800f1d:	d3 e5                	shl    %cl,%ebp
  800f1f:	39 c5                	cmp    %eax,%ebp
  800f21:	73 5d                	jae    800f80 <__udivdi3+0x110>
  800f23:	39 d6                	cmp    %edx,%esi
  800f25:	75 59                	jne    800f80 <__udivdi3+0x110>
  800f27:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f2a:	31 ff                	xor    %edi,%edi
  800f2c:	89 fa                	mov    %edi,%edx
  800f2e:	83 c4 1c             	add    $0x1c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    
  800f36:	8d 76 00             	lea    0x0(%esi),%esi
  800f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f40:	31 ff                	xor    %edi,%edi
  800f42:	31 c0                	xor    %eax,%eax
  800f44:	89 fa                	mov    %edi,%edx
  800f46:	83 c4 1c             	add    $0x1c,%esp
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
  800f4e:	66 90                	xchg   %ax,%ax
  800f50:	31 ff                	xor    %edi,%edi
  800f52:	89 e8                	mov    %ebp,%eax
  800f54:	89 f2                	mov    %esi,%edx
  800f56:	f7 f3                	div    %ebx
  800f58:	89 fa                	mov    %edi,%edx
  800f5a:	83 c4 1c             	add    $0x1c,%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
  800f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f68:	39 f2                	cmp    %esi,%edx
  800f6a:	72 06                	jb     800f72 <__udivdi3+0x102>
  800f6c:	31 c0                	xor    %eax,%eax
  800f6e:	39 eb                	cmp    %ebp,%ebx
  800f70:	77 d2                	ja     800f44 <__udivdi3+0xd4>
  800f72:	b8 01 00 00 00       	mov    $0x1,%eax
  800f77:	eb cb                	jmp    800f44 <__udivdi3+0xd4>
  800f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f80:	89 d8                	mov    %ebx,%eax
  800f82:	31 ff                	xor    %edi,%edi
  800f84:	eb be                	jmp    800f44 <__udivdi3+0xd4>
  800f86:	66 90                	xchg   %ax,%ax
  800f88:	66 90                	xchg   %ax,%ax
  800f8a:	66 90                	xchg   %ax,%ax
  800f8c:	66 90                	xchg   %ax,%ax
  800f8e:	66 90                	xchg   %ax,%ax

00800f90 <__umoddi3>:
  800f90:	55                   	push   %ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 1c             	sub    $0x1c,%esp
  800f97:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f9b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f9f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800fa7:	85 ed                	test   %ebp,%ebp
  800fa9:	89 f0                	mov    %esi,%eax
  800fab:	89 da                	mov    %ebx,%edx
  800fad:	75 19                	jne    800fc8 <__umoddi3+0x38>
  800faf:	39 df                	cmp    %ebx,%edi
  800fb1:	0f 86 b1 00 00 00    	jbe    801068 <__umoddi3+0xd8>
  800fb7:	f7 f7                	div    %edi
  800fb9:	89 d0                	mov    %edx,%eax
  800fbb:	31 d2                	xor    %edx,%edx
  800fbd:	83 c4 1c             	add    $0x1c,%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
  800fc5:	8d 76 00             	lea    0x0(%esi),%esi
  800fc8:	39 dd                	cmp    %ebx,%ebp
  800fca:	77 f1                	ja     800fbd <__umoddi3+0x2d>
  800fcc:	0f bd cd             	bsr    %ebp,%ecx
  800fcf:	83 f1 1f             	xor    $0x1f,%ecx
  800fd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800fd6:	0f 84 b4 00 00 00    	je     801090 <__umoddi3+0x100>
  800fdc:	b8 20 00 00 00       	mov    $0x20,%eax
  800fe1:	89 c2                	mov    %eax,%edx
  800fe3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 c1                	mov    %eax,%ecx
  800feb:	89 f8                	mov    %edi,%eax
  800fed:	d3 e5                	shl    %cl,%ebp
  800fef:	89 d1                	mov    %edx,%ecx
  800ff1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ff5:	d3 e8                	shr    %cl,%eax
  800ff7:	09 c5                	or     %eax,%ebp
  800ff9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ffd:	89 c1                	mov    %eax,%ecx
  800fff:	d3 e7                	shl    %cl,%edi
  801001:	89 d1                	mov    %edx,%ecx
  801003:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801007:	89 df                	mov    %ebx,%edi
  801009:	d3 ef                	shr    %cl,%edi
  80100b:	89 c1                	mov    %eax,%ecx
  80100d:	89 f0                	mov    %esi,%eax
  80100f:	d3 e3                	shl    %cl,%ebx
  801011:	89 d1                	mov    %edx,%ecx
  801013:	89 fa                	mov    %edi,%edx
  801015:	d3 e8                	shr    %cl,%eax
  801017:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80101c:	09 d8                	or     %ebx,%eax
  80101e:	f7 f5                	div    %ebp
  801020:	d3 e6                	shl    %cl,%esi
  801022:	89 d1                	mov    %edx,%ecx
  801024:	f7 64 24 08          	mull   0x8(%esp)
  801028:	39 d1                	cmp    %edx,%ecx
  80102a:	89 c3                	mov    %eax,%ebx
  80102c:	89 d7                	mov    %edx,%edi
  80102e:	72 06                	jb     801036 <__umoddi3+0xa6>
  801030:	75 0e                	jne    801040 <__umoddi3+0xb0>
  801032:	39 c6                	cmp    %eax,%esi
  801034:	73 0a                	jae    801040 <__umoddi3+0xb0>
  801036:	2b 44 24 08          	sub    0x8(%esp),%eax
  80103a:	19 ea                	sbb    %ebp,%edx
  80103c:	89 d7                	mov    %edx,%edi
  80103e:	89 c3                	mov    %eax,%ebx
  801040:	89 ca                	mov    %ecx,%edx
  801042:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801047:	29 de                	sub    %ebx,%esi
  801049:	19 fa                	sbb    %edi,%edx
  80104b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80104f:	89 d0                	mov    %edx,%eax
  801051:	d3 e0                	shl    %cl,%eax
  801053:	89 d9                	mov    %ebx,%ecx
  801055:	d3 ee                	shr    %cl,%esi
  801057:	d3 ea                	shr    %cl,%edx
  801059:	09 f0                	or     %esi,%eax
  80105b:	83 c4 1c             	add    $0x1c,%esp
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    
  801063:	90                   	nop
  801064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801068:	85 ff                	test   %edi,%edi
  80106a:	89 f9                	mov    %edi,%ecx
  80106c:	75 0b                	jne    801079 <__umoddi3+0xe9>
  80106e:	b8 01 00 00 00       	mov    $0x1,%eax
  801073:	31 d2                	xor    %edx,%edx
  801075:	f7 f7                	div    %edi
  801077:	89 c1                	mov    %eax,%ecx
  801079:	89 d8                	mov    %ebx,%eax
  80107b:	31 d2                	xor    %edx,%edx
  80107d:	f7 f1                	div    %ecx
  80107f:	89 f0                	mov    %esi,%eax
  801081:	f7 f1                	div    %ecx
  801083:	e9 31 ff ff ff       	jmp    800fb9 <__umoddi3+0x29>
  801088:	90                   	nop
  801089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801090:	39 dd                	cmp    %ebx,%ebp
  801092:	72 08                	jb     80109c <__umoddi3+0x10c>
  801094:	39 f7                	cmp    %esi,%edi
  801096:	0f 87 21 ff ff ff    	ja     800fbd <__umoddi3+0x2d>
  80109c:	89 da                	mov    %ebx,%edx
  80109e:	89 f0                	mov    %esi,%eax
  8010a0:	29 f8                	sub    %edi,%eax
  8010a2:	19 ea                	sbb    %ebp,%edx
  8010a4:	e9 14 ff ff ff       	jmp    800fbd <__umoddi3+0x2d>
