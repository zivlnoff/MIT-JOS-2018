
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
  800040:	68 60 10 80 00       	push   $0x801060
  800045:	e8 a3 01 00 00       	call   8001ed <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 e6 0b 00 00       	call   800c44 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 ac 10 80 00       	push   $0x8010ac
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 87 07 00 00       	call   8007fa <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 80 10 80 00       	push   $0x801080
  800085:	6a 0e                	push   $0xe
  800087:	68 6a 10 80 00       	push   $0x80106a
  80008c:	e8 81 00 00 00       	call   800112 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 52 0d 00 00       	call   800df3 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 7c 10 80 00       	push   $0x80107c
  8000ae:	e8 3a 01 00 00       	call   8001ed <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 7c 10 80 00       	push   $0x80107c
  8000c0:	e8 28 01 00 00       	call   8001ed <cprintf>
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
  8000cd:	83 ec 08             	sub    $0x8,%esp
  8000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8000d6:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8000dd:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	7e 08                	jle    8000ec <libmain+0x22>
		binaryname = argv[0];
  8000e4:	8b 0a                	mov    (%edx),%ecx
  8000e6:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8000ec:	83 ec 08             	sub    $0x8,%esp
  8000ef:	52                   	push   %edx
  8000f0:	50                   	push   %eax
  8000f1:	e8 9b ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000f6:	e8 05 00 00 00       	call   800100 <exit>
}
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	c9                   	leave  
  8000ff:	c3                   	ret    

00800100 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800106:	6a 00                	push   $0x0
  800108:	e8 b8 0a 00 00       	call   800bc5 <sys_env_destroy>
}
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800117:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80011a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800120:	e8 e1 0a 00 00       	call   800c06 <sys_getenvid>
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	ff 75 0c             	pushl  0xc(%ebp)
  80012b:	ff 75 08             	pushl  0x8(%ebp)
  80012e:	56                   	push   %esi
  80012f:	50                   	push   %eax
  800130:	68 d8 10 80 00       	push   $0x8010d8
  800135:	e8 b3 00 00 00       	call   8001ed <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80013a:	83 c4 18             	add    $0x18,%esp
  80013d:	53                   	push   %ebx
  80013e:	ff 75 10             	pushl  0x10(%ebp)
  800141:	e8 56 00 00 00       	call   80019c <vcprintf>
	cprintf("\n");
  800146:	c7 04 24 7e 10 80 00 	movl   $0x80107e,(%esp)
  80014d:	e8 9b 00 00 00       	call   8001ed <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800155:	cc                   	int3   
  800156:	eb fd                	jmp    800155 <_panic+0x43>

00800158 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	53                   	push   %ebx
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800162:	8b 13                	mov    (%ebx),%edx
  800164:	8d 42 01             	lea    0x1(%edx),%eax
  800167:	89 03                	mov    %eax,(%ebx)
  800169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800170:	3d ff 00 00 00       	cmp    $0xff,%eax
  800175:	74 09                	je     800180 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800177:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017e:	c9                   	leave  
  80017f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800180:	83 ec 08             	sub    $0x8,%esp
  800183:	68 ff 00 00 00       	push   $0xff
  800188:	8d 43 08             	lea    0x8(%ebx),%eax
  80018b:	50                   	push   %eax
  80018c:	e8 f7 09 00 00       	call   800b88 <sys_cputs>
		b->idx = 0;
  800191:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	eb db                	jmp    800177 <putch+0x1f>

0080019c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ac:	00 00 00 
	b.cnt = 0;
  8001af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b9:	ff 75 0c             	pushl  0xc(%ebp)
  8001bc:	ff 75 08             	pushl  0x8(%ebp)
  8001bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c5:	50                   	push   %eax
  8001c6:	68 58 01 80 00       	push   $0x800158
  8001cb:	e8 1a 01 00 00       	call   8002ea <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d0:	83 c4 08             	add    $0x8,%esp
  8001d3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001df:	50                   	push   %eax
  8001e0:	e8 a3 09 00 00       	call   800b88 <sys_cputs>

	return b.cnt;
}
  8001e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    

008001ed <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f6:	50                   	push   %eax
  8001f7:	ff 75 08             	pushl  0x8(%ebp)
  8001fa:	e8 9d ff ff ff       	call   80019c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	57                   	push   %edi
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	83 ec 1c             	sub    $0x1c,%esp
  80020a:	89 c7                	mov    %eax,%edi
  80020c:	89 d6                	mov    %edx,%esi
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	8b 55 0c             	mov    0xc(%ebp),%edx
  800214:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800217:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80021a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80021d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800222:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800225:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800228:	39 d3                	cmp    %edx,%ebx
  80022a:	72 05                	jb     800231 <printnum+0x30>
  80022c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80022f:	77 7a                	ja     8002ab <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	ff 75 18             	pushl  0x18(%ebp)
  800237:	8b 45 14             	mov    0x14(%ebp),%eax
  80023a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80023d:	53                   	push   %ebx
  80023e:	ff 75 10             	pushl  0x10(%ebp)
  800241:	83 ec 08             	sub    $0x8,%esp
  800244:	ff 75 e4             	pushl  -0x1c(%ebp)
  800247:	ff 75 e0             	pushl  -0x20(%ebp)
  80024a:	ff 75 dc             	pushl  -0x24(%ebp)
  80024d:	ff 75 d8             	pushl  -0x28(%ebp)
  800250:	e8 cb 0b 00 00       	call   800e20 <__udivdi3>
  800255:	83 c4 18             	add    $0x18,%esp
  800258:	52                   	push   %edx
  800259:	50                   	push   %eax
  80025a:	89 f2                	mov    %esi,%edx
  80025c:	89 f8                	mov    %edi,%eax
  80025e:	e8 9e ff ff ff       	call   800201 <printnum>
  800263:	83 c4 20             	add    $0x20,%esp
  800266:	eb 13                	jmp    80027b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	56                   	push   %esi
  80026c:	ff 75 18             	pushl  0x18(%ebp)
  80026f:	ff d7                	call   *%edi
  800271:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800274:	83 eb 01             	sub    $0x1,%ebx
  800277:	85 db                	test   %ebx,%ebx
  800279:	7f ed                	jg     800268 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	56                   	push   %esi
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	ff 75 e4             	pushl  -0x1c(%ebp)
  800285:	ff 75 e0             	pushl  -0x20(%ebp)
  800288:	ff 75 dc             	pushl  -0x24(%ebp)
  80028b:	ff 75 d8             	pushl  -0x28(%ebp)
  80028e:	e8 ad 0c 00 00       	call   800f40 <__umoddi3>
  800293:	83 c4 14             	add    $0x14,%esp
  800296:	0f be 80 fb 10 80 00 	movsbl 0x8010fb(%eax),%eax
  80029d:	50                   	push   %eax
  80029e:	ff d7                	call   *%edi
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5f                   	pop    %edi
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    
  8002ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ae:	eb c4                	jmp    800274 <printnum+0x73>

008002b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ba:	8b 10                	mov    (%eax),%edx
  8002bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002bf:	73 0a                	jae    8002cb <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c4:	89 08                	mov    %ecx,(%eax)
  8002c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c9:	88 02                	mov    %al,(%edx)
}
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <printfmt>:
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d6:	50                   	push   %eax
  8002d7:	ff 75 10             	pushl  0x10(%ebp)
  8002da:	ff 75 0c             	pushl  0xc(%ebp)
  8002dd:	ff 75 08             	pushl  0x8(%ebp)
  8002e0:	e8 05 00 00 00       	call   8002ea <vprintfmt>
}
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <vprintfmt>:
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	57                   	push   %edi
  8002ee:	56                   	push   %esi
  8002ef:	53                   	push   %ebx
  8002f0:	83 ec 2c             	sub    $0x2c,%esp
  8002f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002fc:	e9 00 04 00 00       	jmp    800701 <vprintfmt+0x417>
		padc = ' ';
  800301:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800305:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80030c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800313:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	8d 47 01             	lea    0x1(%edi),%eax
  800322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800325:	0f b6 17             	movzbl (%edi),%edx
  800328:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032b:	3c 55                	cmp    $0x55,%al
  80032d:	0f 87 51 04 00 00    	ja     800784 <vprintfmt+0x49a>
  800333:	0f b6 c0             	movzbl %al,%eax
  800336:	ff 24 85 c0 11 80 00 	jmp    *0x8011c0(,%eax,4)
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800340:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800344:	eb d9                	jmp    80031f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800349:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80034d:	eb d0                	jmp    80031f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	0f b6 d2             	movzbl %dl,%edx
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80035d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800360:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800364:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800367:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036a:	83 f9 09             	cmp    $0x9,%ecx
  80036d:	77 55                	ja     8003c4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80036f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800372:	eb e9                	jmp    80035d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800374:	8b 45 14             	mov    0x14(%ebp),%eax
  800377:	8b 00                	mov    (%eax),%eax
  800379:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037c:	8b 45 14             	mov    0x14(%ebp),%eax
  80037f:	8d 40 04             	lea    0x4(%eax),%eax
  800382:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800388:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038c:	79 91                	jns    80031f <vprintfmt+0x35>
				width = precision, precision = -1;
  80038e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800391:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800394:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039b:	eb 82                	jmp    80031f <vprintfmt+0x35>
  80039d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a0:	85 c0                	test   %eax,%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	0f 49 d0             	cmovns %eax,%edx
  8003aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b0:	e9 6a ff ff ff       	jmp    80031f <vprintfmt+0x35>
  8003b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003b8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003bf:	e9 5b ff ff ff       	jmp    80031f <vprintfmt+0x35>
  8003c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ca:	eb bc                	jmp    800388 <vprintfmt+0x9e>
			lflag++;
  8003cc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d2:	e9 48 ff ff ff       	jmp    80031f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	53                   	push   %ebx
  8003e1:	ff 30                	pushl  (%eax)
  8003e3:	ff d6                	call   *%esi
			break;
  8003e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003eb:	e9 0e 03 00 00       	jmp    8006fe <vprintfmt+0x414>
			err = va_arg(ap, int);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 78 04             	lea    0x4(%eax),%edi
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	99                   	cltd   
  8003f9:	31 d0                	xor    %edx,%eax
  8003fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fd:	83 f8 08             	cmp    $0x8,%eax
  800400:	7f 23                	jg     800425 <vprintfmt+0x13b>
  800402:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  800409:	85 d2                	test   %edx,%edx
  80040b:	74 18                	je     800425 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80040d:	52                   	push   %edx
  80040e:	68 1c 11 80 00       	push   $0x80111c
  800413:	53                   	push   %ebx
  800414:	56                   	push   %esi
  800415:	e8 b3 fe ff ff       	call   8002cd <printfmt>
  80041a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800420:	e9 d9 02 00 00       	jmp    8006fe <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800425:	50                   	push   %eax
  800426:	68 13 11 80 00       	push   $0x801113
  80042b:	53                   	push   %ebx
  80042c:	56                   	push   %esi
  80042d:	e8 9b fe ff ff       	call   8002cd <printfmt>
  800432:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800435:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800438:	e9 c1 02 00 00       	jmp    8006fe <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	83 c0 04             	add    $0x4,%eax
  800443:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80044b:	85 ff                	test   %edi,%edi
  80044d:	b8 0c 11 80 00       	mov    $0x80110c,%eax
  800452:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800455:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800459:	0f 8e bd 00 00 00    	jle    80051c <vprintfmt+0x232>
  80045f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800463:	75 0e                	jne    800473 <vprintfmt+0x189>
  800465:	89 75 08             	mov    %esi,0x8(%ebp)
  800468:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80046e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800471:	eb 6d                	jmp    8004e0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 d0             	pushl  -0x30(%ebp)
  800479:	57                   	push   %edi
  80047a:	e8 ad 03 00 00       	call   80082c <strnlen>
  80047f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800482:	29 c1                	sub    %eax,%ecx
  800484:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800487:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800491:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800494:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800496:	eb 0f                	jmp    8004a7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	ff 75 e0             	pushl  -0x20(%ebp)
  80049f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	83 ef 01             	sub    $0x1,%edi
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	85 ff                	test   %edi,%edi
  8004a9:	7f ed                	jg     800498 <vprintfmt+0x1ae>
  8004ab:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004ae:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b1:	85 c9                	test   %ecx,%ecx
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	0f 49 c1             	cmovns %ecx,%eax
  8004bb:	29 c1                	sub    %eax,%ecx
  8004bd:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c6:	89 cb                	mov    %ecx,%ebx
  8004c8:	eb 16                	jmp    8004e0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ce:	75 31                	jne    800501 <vprintfmt+0x217>
					putch(ch, putdat);
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	ff 55 08             	call   *0x8(%ebp)
  8004da:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004dd:	83 eb 01             	sub    $0x1,%ebx
  8004e0:	83 c7 01             	add    $0x1,%edi
  8004e3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004e7:	0f be c2             	movsbl %dl,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 59                	je     800547 <vprintfmt+0x25d>
  8004ee:	85 f6                	test   %esi,%esi
  8004f0:	78 d8                	js     8004ca <vprintfmt+0x1e0>
  8004f2:	83 ee 01             	sub    $0x1,%esi
  8004f5:	79 d3                	jns    8004ca <vprintfmt+0x1e0>
  8004f7:	89 df                	mov    %ebx,%edi
  8004f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ff:	eb 37                	jmp    800538 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800501:	0f be d2             	movsbl %dl,%edx
  800504:	83 ea 20             	sub    $0x20,%edx
  800507:	83 fa 5e             	cmp    $0x5e,%edx
  80050a:	76 c4                	jbe    8004d0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	6a 3f                	push   $0x3f
  800514:	ff 55 08             	call   *0x8(%ebp)
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	eb c1                	jmp    8004dd <vprintfmt+0x1f3>
  80051c:	89 75 08             	mov    %esi,0x8(%ebp)
  80051f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800522:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800525:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800528:	eb b6                	jmp    8004e0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	53                   	push   %ebx
  80052e:	6a 20                	push   $0x20
  800530:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800532:	83 ef 01             	sub    $0x1,%edi
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	85 ff                	test   %edi,%edi
  80053a:	7f ee                	jg     80052a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80053c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80053f:	89 45 14             	mov    %eax,0x14(%ebp)
  800542:	e9 b7 01 00 00       	jmp    8006fe <vprintfmt+0x414>
  800547:	89 df                	mov    %ebx,%edi
  800549:	8b 75 08             	mov    0x8(%ebp),%esi
  80054c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80054f:	eb e7                	jmp    800538 <vprintfmt+0x24e>
	if (lflag >= 2)
  800551:	83 f9 01             	cmp    $0x1,%ecx
  800554:	7e 3f                	jle    800595 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8b 50 04             	mov    0x4(%eax),%edx
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 40 08             	lea    0x8(%eax),%eax
  80056a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80056d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800571:	79 5c                	jns    8005cf <vprintfmt+0x2e5>
				putch('-', putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	6a 2d                	push   $0x2d
  800579:	ff d6                	call   *%esi
				num = -(long long) num;
  80057b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800581:	f7 da                	neg    %edx
  800583:	83 d1 00             	adc    $0x0,%ecx
  800586:	f7 d9                	neg    %ecx
  800588:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800590:	e9 4f 01 00 00       	jmp    8006e4 <vprintfmt+0x3fa>
	else if (lflag)
  800595:	85 c9                	test   %ecx,%ecx
  800597:	75 1b                	jne    8005b4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a1:	89 c1                	mov    %eax,%ecx
  8005a3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8d 40 04             	lea    0x4(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b2:	eb b9                	jmp    80056d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bc:	89 c1                	mov    %eax,%ecx
  8005be:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cd:	eb 9e                	jmp    80056d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005da:	e9 05 01 00 00       	jmp    8006e4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8005df:	83 f9 01             	cmp    $0x1,%ecx
  8005e2:	7e 18                	jle    8005fc <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 10                	mov    (%eax),%edx
  8005e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ec:	8d 40 08             	lea    0x8(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f7:	e9 e8 00 00 00       	jmp    8006e4 <vprintfmt+0x3fa>
	else if (lflag)
  8005fc:	85 c9                	test   %ecx,%ecx
  8005fe:	75 1a                	jne    80061a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 10                	mov    (%eax),%edx
  800605:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060a:	8d 40 04             	lea    0x4(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800610:	b8 0a 00 00 00       	mov    $0xa,%eax
  800615:	e9 ca 00 00 00       	jmp    8006e4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062f:	e9 b0 00 00 00       	jmp    8006e4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800634:	83 f9 01             	cmp    $0x1,%ecx
  800637:	7e 3c                	jle    800675 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 50 04             	mov    0x4(%eax),%edx
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 08             	lea    0x8(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800650:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800654:	79 59                	jns    8006af <vprintfmt+0x3c5>
                putch('-', putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	53                   	push   %ebx
  80065a:	6a 2d                	push   $0x2d
  80065c:	ff d6                	call   *%esi
                num = -(long long) num;
  80065e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800661:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800664:	f7 da                	neg    %edx
  800666:	83 d1 00             	adc    $0x0,%ecx
  800669:	f7 d9                	neg    %ecx
  80066b:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80066e:	b8 08 00 00 00       	mov    $0x8,%eax
  800673:	eb 6f                	jmp    8006e4 <vprintfmt+0x3fa>
	else if (lflag)
  800675:	85 c9                	test   %ecx,%ecx
  800677:	75 1b                	jne    800694 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 c1                	mov    %eax,%ecx
  800683:	c1 f9 1f             	sar    $0x1f,%ecx
  800686:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	eb bc                	jmp    800650 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	89 c1                	mov    %eax,%ecx
  80069e:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ad:	eb a1                	jmp    800650 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ba:	eb 28                	jmp    8006e4 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 30                	push   $0x30
  8006c2:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c4:	83 c4 08             	add    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 78                	push   $0x78
  8006ca:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
  8006d1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006df:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e4:	83 ec 0c             	sub    $0xc,%esp
  8006e7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006eb:	57                   	push   %edi
  8006ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	51                   	push   %ecx
  8006f1:	52                   	push   %edx
  8006f2:	89 da                	mov    %ebx,%edx
  8006f4:	89 f0                	mov    %esi,%eax
  8006f6:	e8 06 fb ff ff       	call   800201 <printnum>
			break;
  8006fb:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800701:	83 c7 01             	add    $0x1,%edi
  800704:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800708:	83 f8 25             	cmp    $0x25,%eax
  80070b:	0f 84 f0 fb ff ff    	je     800301 <vprintfmt+0x17>
			if (ch == '\0')
  800711:	85 c0                	test   %eax,%eax
  800713:	0f 84 8b 00 00 00    	je     8007a4 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	50                   	push   %eax
  80071e:	ff d6                	call   *%esi
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	eb dc                	jmp    800701 <vprintfmt+0x417>
	if (lflag >= 2)
  800725:	83 f9 01             	cmp    $0x1,%ecx
  800728:	7e 15                	jle    80073f <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 10                	mov    (%eax),%edx
  80072f:	8b 48 04             	mov    0x4(%eax),%ecx
  800732:	8d 40 08             	lea    0x8(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800738:	b8 10 00 00 00       	mov    $0x10,%eax
  80073d:	eb a5                	jmp    8006e4 <vprintfmt+0x3fa>
	else if (lflag)
  80073f:	85 c9                	test   %ecx,%ecx
  800741:	75 17                	jne    80075a <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 10                	mov    (%eax),%edx
  800748:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074d:	8d 40 04             	lea    0x4(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800753:	b8 10 00 00 00       	mov    $0x10,%eax
  800758:	eb 8a                	jmp    8006e4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076a:	b8 10 00 00 00       	mov    $0x10,%eax
  80076f:	e9 70 ff ff ff       	jmp    8006e4 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	53                   	push   %ebx
  800778:	6a 25                	push   $0x25
  80077a:	ff d6                	call   *%esi
			break;
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	e9 7a ff ff ff       	jmp    8006fe <vprintfmt+0x414>
			putch('%', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	6a 25                	push   $0x25
  80078a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 f8                	mov    %edi,%eax
  800791:	eb 03                	jmp    800796 <vprintfmt+0x4ac>
  800793:	83 e8 01             	sub    $0x1,%eax
  800796:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80079a:	75 f7                	jne    800793 <vprintfmt+0x4a9>
  80079c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079f:	e9 5a ff ff ff       	jmp    8006fe <vprintfmt+0x414>
}
  8007a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a7:	5b                   	pop    %ebx
  8007a8:	5e                   	pop    %esi
  8007a9:	5f                   	pop    %edi
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	83 ec 18             	sub    $0x18,%esp
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007bb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c9:	85 c0                	test   %eax,%eax
  8007cb:	74 26                	je     8007f3 <vsnprintf+0x47>
  8007cd:	85 d2                	test   %edx,%edx
  8007cf:	7e 22                	jle    8007f3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d1:	ff 75 14             	pushl  0x14(%ebp)
  8007d4:	ff 75 10             	pushl  0x10(%ebp)
  8007d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007da:	50                   	push   %eax
  8007db:	68 b0 02 80 00       	push   $0x8002b0
  8007e0:	e8 05 fb ff ff       	call   8002ea <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
}
  8007f1:	c9                   	leave  
  8007f2:	c3                   	ret    
		return -E_INVAL;
  8007f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f8:	eb f7                	jmp    8007f1 <vsnprintf+0x45>

008007fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 9a ff ff ff       	call   8007ac <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081a:	b8 00 00 00 00       	mov    $0x0,%eax
  80081f:	eb 03                	jmp    800824 <strlen+0x10>
		n++;
  800821:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800824:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800828:	75 f7                	jne    800821 <strlen+0xd>
	return n;
}
  80082a:	5d                   	pop    %ebp
  80082b:	c3                   	ret    

0080082c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800832:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	eb 03                	jmp    80083f <strnlen+0x13>
		n++;
  80083c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083f:	39 d0                	cmp    %edx,%eax
  800841:	74 06                	je     800849 <strnlen+0x1d>
  800843:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800847:	75 f3                	jne    80083c <strnlen+0x10>
	return n;
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800855:	89 c2                	mov    %eax,%edx
  800857:	83 c1 01             	add    $0x1,%ecx
  80085a:	83 c2 01             	add    $0x1,%edx
  80085d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800861:	88 5a ff             	mov    %bl,-0x1(%edx)
  800864:	84 db                	test   %bl,%bl
  800866:	75 ef                	jne    800857 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800868:	5b                   	pop    %ebx
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800872:	53                   	push   %ebx
  800873:	e8 9c ff ff ff       	call   800814 <strlen>
  800878:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80087b:	ff 75 0c             	pushl  0xc(%ebp)
  80087e:	01 d8                	add    %ebx,%eax
  800880:	50                   	push   %eax
  800881:	e8 c5 ff ff ff       	call   80084b <strcpy>
	return dst;
}
  800886:	89 d8                	mov    %ebx,%eax
  800888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    

0080088d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
  800892:	8b 75 08             	mov    0x8(%ebp),%esi
  800895:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800898:	89 f3                	mov    %esi,%ebx
  80089a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089d:	89 f2                	mov    %esi,%edx
  80089f:	eb 0f                	jmp    8008b0 <strncpy+0x23>
		*dst++ = *src;
  8008a1:	83 c2 01             	add    $0x1,%edx
  8008a4:	0f b6 01             	movzbl (%ecx),%eax
  8008a7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008aa:	80 39 01             	cmpb   $0x1,(%ecx)
  8008ad:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b0:	39 da                	cmp    %ebx,%edx
  8008b2:	75 ed                	jne    8008a1 <strncpy+0x14>
	}
	return ret;
}
  8008b4:	89 f0                	mov    %esi,%eax
  8008b6:	5b                   	pop    %ebx
  8008b7:	5e                   	pop    %esi
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	56                   	push   %esi
  8008be:	53                   	push   %ebx
  8008bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008c8:	89 f0                	mov    %esi,%eax
  8008ca:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ce:	85 c9                	test   %ecx,%ecx
  8008d0:	75 0b                	jne    8008dd <strlcpy+0x23>
  8008d2:	eb 17                	jmp    8008eb <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d4:	83 c2 01             	add    $0x1,%edx
  8008d7:	83 c0 01             	add    $0x1,%eax
  8008da:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008dd:	39 d8                	cmp    %ebx,%eax
  8008df:	74 07                	je     8008e8 <strlcpy+0x2e>
  8008e1:	0f b6 0a             	movzbl (%edx),%ecx
  8008e4:	84 c9                	test   %cl,%cl
  8008e6:	75 ec                	jne    8008d4 <strlcpy+0x1a>
		*dst = '\0';
  8008e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008eb:	29 f0                	sub    %esi,%eax
}
  8008ed:	5b                   	pop    %ebx
  8008ee:	5e                   	pop    %esi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fa:	eb 06                	jmp    800902 <strcmp+0x11>
		p++, q++;
  8008fc:	83 c1 01             	add    $0x1,%ecx
  8008ff:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800902:	0f b6 01             	movzbl (%ecx),%eax
  800905:	84 c0                	test   %al,%al
  800907:	74 04                	je     80090d <strcmp+0x1c>
  800909:	3a 02                	cmp    (%edx),%al
  80090b:	74 ef                	je     8008fc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090d:	0f b6 c0             	movzbl %al,%eax
  800910:	0f b6 12             	movzbl (%edx),%edx
  800913:	29 d0                	sub    %edx,%eax
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	89 c3                	mov    %eax,%ebx
  800923:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800926:	eb 06                	jmp    80092e <strncmp+0x17>
		n--, p++, q++;
  800928:	83 c0 01             	add    $0x1,%eax
  80092b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092e:	39 d8                	cmp    %ebx,%eax
  800930:	74 16                	je     800948 <strncmp+0x31>
  800932:	0f b6 08             	movzbl (%eax),%ecx
  800935:	84 c9                	test   %cl,%cl
  800937:	74 04                	je     80093d <strncmp+0x26>
  800939:	3a 0a                	cmp    (%edx),%cl
  80093b:	74 eb                	je     800928 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093d:	0f b6 00             	movzbl (%eax),%eax
  800940:	0f b6 12             	movzbl (%edx),%edx
  800943:	29 d0                	sub    %edx,%eax
}
  800945:	5b                   	pop    %ebx
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    
		return 0;
  800948:	b8 00 00 00 00       	mov    $0x0,%eax
  80094d:	eb f6                	jmp    800945 <strncmp+0x2e>

0080094f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800959:	0f b6 10             	movzbl (%eax),%edx
  80095c:	84 d2                	test   %dl,%dl
  80095e:	74 09                	je     800969 <strchr+0x1a>
		if (*s == c)
  800960:	38 ca                	cmp    %cl,%dl
  800962:	74 0a                	je     80096e <strchr+0x1f>
	for (; *s; s++)
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	eb f0                	jmp    800959 <strchr+0xa>
			return (char *) s;
	return 0;
  800969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097a:	eb 03                	jmp    80097f <strfind+0xf>
  80097c:	83 c0 01             	add    $0x1,%eax
  80097f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800982:	38 ca                	cmp    %cl,%dl
  800984:	74 04                	je     80098a <strfind+0x1a>
  800986:	84 d2                	test   %dl,%dl
  800988:	75 f2                	jne    80097c <strfind+0xc>
			break;
	return (char *) s;
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	57                   	push   %edi
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	8b 7d 08             	mov    0x8(%ebp),%edi
  800995:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800998:	85 c9                	test   %ecx,%ecx
  80099a:	74 13                	je     8009af <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a2:	75 05                	jne    8009a9 <memset+0x1d>
  8009a4:	f6 c1 03             	test   $0x3,%cl
  8009a7:	74 0d                	je     8009b6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	fc                   	cld    
  8009ad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009af:	89 f8                	mov    %edi,%eax
  8009b1:	5b                   	pop    %ebx
  8009b2:	5e                   	pop    %esi
  8009b3:	5f                   	pop    %edi
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    
		c &= 0xFF;
  8009b6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ba:	89 d3                	mov    %edx,%ebx
  8009bc:	c1 e3 08             	shl    $0x8,%ebx
  8009bf:	89 d0                	mov    %edx,%eax
  8009c1:	c1 e0 18             	shl    $0x18,%eax
  8009c4:	89 d6                	mov    %edx,%esi
  8009c6:	c1 e6 10             	shl    $0x10,%esi
  8009c9:	09 f0                	or     %esi,%eax
  8009cb:	09 c2                	or     %eax,%edx
  8009cd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009cf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d2:	89 d0                	mov    %edx,%eax
  8009d4:	fc                   	cld    
  8009d5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d7:	eb d6                	jmp    8009af <memset+0x23>

008009d9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	57                   	push   %edi
  8009dd:	56                   	push   %esi
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e7:	39 c6                	cmp    %eax,%esi
  8009e9:	73 35                	jae    800a20 <memmove+0x47>
  8009eb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ee:	39 c2                	cmp    %eax,%edx
  8009f0:	76 2e                	jbe    800a20 <memmove+0x47>
		s += n;
		d += n;
  8009f2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f5:	89 d6                	mov    %edx,%esi
  8009f7:	09 fe                	or     %edi,%esi
  8009f9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ff:	74 0c                	je     800a0d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a01:	83 ef 01             	sub    $0x1,%edi
  800a04:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a07:	fd                   	std    
  800a08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0a:	fc                   	cld    
  800a0b:	eb 21                	jmp    800a2e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0d:	f6 c1 03             	test   $0x3,%cl
  800a10:	75 ef                	jne    800a01 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a12:	83 ef 04             	sub    $0x4,%edi
  800a15:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1b:	fd                   	std    
  800a1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1e:	eb ea                	jmp    800a0a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a20:	89 f2                	mov    %esi,%edx
  800a22:	09 c2                	or     %eax,%edx
  800a24:	f6 c2 03             	test   $0x3,%dl
  800a27:	74 09                	je     800a32 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a32:	f6 c1 03             	test   $0x3,%cl
  800a35:	75 f2                	jne    800a29 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a37:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3a:	89 c7                	mov    %eax,%edi
  800a3c:	fc                   	cld    
  800a3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3f:	eb ed                	jmp    800a2e <memmove+0x55>

00800a41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a44:	ff 75 10             	pushl  0x10(%ebp)
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 08             	pushl  0x8(%ebp)
  800a4d:	e8 87 ff ff ff       	call   8009d9 <memmove>
}
  800a52:	c9                   	leave  
  800a53:	c3                   	ret    

00800a54 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5f:	89 c6                	mov    %eax,%esi
  800a61:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a64:	39 f0                	cmp    %esi,%eax
  800a66:	74 1c                	je     800a84 <memcmp+0x30>
		if (*s1 != *s2)
  800a68:	0f b6 08             	movzbl (%eax),%ecx
  800a6b:	0f b6 1a             	movzbl (%edx),%ebx
  800a6e:	38 d9                	cmp    %bl,%cl
  800a70:	75 08                	jne    800a7a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a72:	83 c0 01             	add    $0x1,%eax
  800a75:	83 c2 01             	add    $0x1,%edx
  800a78:	eb ea                	jmp    800a64 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a7a:	0f b6 c1             	movzbl %cl,%eax
  800a7d:	0f b6 db             	movzbl %bl,%ebx
  800a80:	29 d8                	sub    %ebx,%eax
  800a82:	eb 05                	jmp    800a89 <memcmp+0x35>
	}

	return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a89:	5b                   	pop    %ebx
  800a8a:	5e                   	pop    %esi
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a96:	89 c2                	mov    %eax,%edx
  800a98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 09                	jae    800aa8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9f:	38 08                	cmp    %cl,(%eax)
  800aa1:	74 05                	je     800aa8 <memfind+0x1b>
	for (; s < ends; s++)
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	eb f3                	jmp    800a9b <memfind+0xe>
			break;
	return (void *) s;
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	57                   	push   %edi
  800aae:	56                   	push   %esi
  800aaf:	53                   	push   %ebx
  800ab0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab6:	eb 03                	jmp    800abb <strtol+0x11>
		s++;
  800ab8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abb:	0f b6 01             	movzbl (%ecx),%eax
  800abe:	3c 20                	cmp    $0x20,%al
  800ac0:	74 f6                	je     800ab8 <strtol+0xe>
  800ac2:	3c 09                	cmp    $0x9,%al
  800ac4:	74 f2                	je     800ab8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac6:	3c 2b                	cmp    $0x2b,%al
  800ac8:	74 2e                	je     800af8 <strtol+0x4e>
	int neg = 0;
  800aca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800acf:	3c 2d                	cmp    $0x2d,%al
  800ad1:	74 2f                	je     800b02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad9:	75 05                	jne    800ae0 <strtol+0x36>
  800adb:	80 39 30             	cmpb   $0x30,(%ecx)
  800ade:	74 2c                	je     800b0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae0:	85 db                	test   %ebx,%ebx
  800ae2:	75 0a                	jne    800aee <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ae9:	80 39 30             	cmpb   $0x30,(%ecx)
  800aec:	74 28                	je     800b16 <strtol+0x6c>
		base = 10;
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af6:	eb 50                	jmp    800b48 <strtol+0x9e>
		s++;
  800af8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afb:	bf 00 00 00 00       	mov    $0x0,%edi
  800b00:	eb d1                	jmp    800ad3 <strtol+0x29>
		s++, neg = 1;
  800b02:	83 c1 01             	add    $0x1,%ecx
  800b05:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0a:	eb c7                	jmp    800ad3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b10:	74 0e                	je     800b20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b12:	85 db                	test   %ebx,%ebx
  800b14:	75 d8                	jne    800aee <strtol+0x44>
		s++, base = 8;
  800b16:	83 c1 01             	add    $0x1,%ecx
  800b19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1e:	eb ce                	jmp    800aee <strtol+0x44>
		s += 2, base = 16;
  800b20:	83 c1 02             	add    $0x2,%ecx
  800b23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b28:	eb c4                	jmp    800aee <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b2d:	89 f3                	mov    %esi,%ebx
  800b2f:	80 fb 19             	cmp    $0x19,%bl
  800b32:	77 29                	ja     800b5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b34:	0f be d2             	movsbl %dl,%edx
  800b37:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b3a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b3d:	7d 30                	jge    800b6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b3f:	83 c1 01             	add    $0x1,%ecx
  800b42:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b46:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b48:	0f b6 11             	movzbl (%ecx),%edx
  800b4b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b4e:	89 f3                	mov    %esi,%ebx
  800b50:	80 fb 09             	cmp    $0x9,%bl
  800b53:	77 d5                	ja     800b2a <strtol+0x80>
			dig = *s - '0';
  800b55:	0f be d2             	movsbl %dl,%edx
  800b58:	83 ea 30             	sub    $0x30,%edx
  800b5b:	eb dd                	jmp    800b3a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 37             	sub    $0x37,%edx
  800b6d:	eb cb                	jmp    800b3a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xd0>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	f7 da                	neg    %edx
  800b7e:	85 ff                	test   %edi,%edi
  800b80:	0f 45 c2             	cmovne %edx,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b93:	8b 55 08             	mov    0x8(%ebp),%edx
  800b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b99:	89 c3                	mov    %eax,%ebx
  800b9b:	89 c7                	mov    %eax,%edi
  800b9d:	89 c6                	mov    %eax,%esi
  800b9f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <sys_cgetc>:

int
sys_cgetc(void) {
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb6:	89 d1                	mov    %edx,%ecx
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	89 d7                	mov    %edx,%edi
  800bbc:	89 d6                	mov    %edx,%esi
  800bbe:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
  800bcb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bdb:	89 cb                	mov    %ecx,%ebx
  800bdd:	89 cf                	mov    %ecx,%edi
  800bdf:	89 ce                	mov    %ecx,%esi
  800be1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800be3:	85 c0                	test   %eax,%eax
  800be5:	7f 08                	jg     800bef <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bef:	83 ec 0c             	sub    $0xc,%esp
  800bf2:	50                   	push   %eax
  800bf3:	6a 03                	push   $0x3
  800bf5:	68 44 13 80 00       	push   $0x801344
  800bfa:	6a 24                	push   $0x24
  800bfc:	68 61 13 80 00       	push   $0x801361
  800c01:	e8 0c f5 ff ff       	call   800112 <_panic>

00800c06 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c11:	b8 02 00 00 00       	mov    $0x2,%eax
  800c16:	89 d1                	mov    %edx,%ecx
  800c18:	89 d3                	mov    %edx,%ebx
  800c1a:	89 d7                	mov    %edx,%edi
  800c1c:	89 d6                	mov    %edx,%esi
  800c1e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_yield>:

void
sys_yield(void)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c35:	89 d1                	mov    %edx,%ecx
  800c37:	89 d3                	mov    %edx,%ebx
  800c39:	89 d7                	mov    %edx,%edi
  800c3b:	89 d6                	mov    %edx,%esi
  800c3d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c4d:	be 00 00 00 00       	mov    $0x0,%esi
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 04 00 00 00       	mov    $0x4,%eax
  800c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c60:	89 f7                	mov    %esi,%edi
  800c62:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	7f 08                	jg     800c70 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	6a 04                	push   $0x4
  800c76:	68 44 13 80 00       	push   $0x801344
  800c7b:	6a 24                	push   $0x24
  800c7d:	68 61 13 80 00       	push   $0x801361
  800c82:	e8 8b f4 ff ff       	call   800112 <_panic>

00800c87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca4:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 05                	push   $0x5
  800cb8:	68 44 13 80 00       	push   $0x801344
  800cbd:	6a 24                	push   $0x24
  800cbf:	68 61 13 80 00       	push   $0x801361
  800cc4:	e8 49 f4 ff ff       	call   800112 <_panic>

00800cc9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce2:	89 df                	mov    %ebx,%edi
  800ce4:	89 de                	mov    %ebx,%esi
  800ce6:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7f 08                	jg     800cf4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 06                	push   $0x6
  800cfa:	68 44 13 80 00       	push   $0x801344
  800cff:	6a 24                	push   $0x24
  800d01:	68 61 13 80 00       	push   $0x801361
  800d06:	e8 07 f4 ff ff       	call   800112 <_panic>

00800d0b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	b8 08 00 00 00       	mov    $0x8,%eax
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	89 de                	mov    %ebx,%esi
  800d28:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 08                	push   $0x8
  800d3c:	68 44 13 80 00       	push   $0x801344
  800d41:	6a 24                	push   $0x24
  800d43:	68 61 13 80 00       	push   $0x801361
  800d48:	e8 c5 f3 ff ff       	call   800112 <_panic>

00800d4d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	b8 09 00 00 00       	mov    $0x9,%eax
  800d66:	89 df                	mov    %ebx,%edi
  800d68:	89 de                	mov    %ebx,%esi
  800d6a:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7f 08                	jg     800d78 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	50                   	push   %eax
  800d7c:	6a 09                	push   $0x9
  800d7e:	68 44 13 80 00       	push   $0x801344
  800d83:	6a 24                	push   $0x24
  800d85:	68 61 13 80 00       	push   $0x801361
  800d8a:	e8 83 f3 ff ff       	call   800112 <_panic>

00800d8f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da0:	be 00 00 00 00       	mov    $0x0,%esi
  800da5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dab:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc8:	89 cb                	mov    %ecx,%ebx
  800dca:	89 cf                	mov    %ecx,%edi
  800dcc:	89 ce                	mov    %ecx,%esi
  800dce:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 0c                	push   $0xc
  800de2:	68 44 13 80 00       	push   $0x801344
  800de7:	6a 24                	push   $0x24
  800de9:	68 61 13 80 00       	push   $0x801361
  800dee:	e8 1f f3 ff ff       	call   800112 <_panic>

00800df3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800df9:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800e00:	74 0a                	je     800e0c <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    
		panic("set_pgfault_handler not implemented");
  800e0c:	83 ec 04             	sub    $0x4,%esp
  800e0f:	68 70 13 80 00       	push   $0x801370
  800e14:	6a 20                	push   $0x20
  800e16:	68 94 13 80 00       	push   $0x801394
  800e1b:	e8 f2 f2 ff ff       	call   800112 <_panic>

00800e20 <__udivdi3>:
  800e20:	55                   	push   %ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 1c             	sub    $0x1c,%esp
  800e27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e37:	85 d2                	test   %edx,%edx
  800e39:	75 35                	jne    800e70 <__udivdi3+0x50>
  800e3b:	39 f3                	cmp    %esi,%ebx
  800e3d:	0f 87 bd 00 00 00    	ja     800f00 <__udivdi3+0xe0>
  800e43:	85 db                	test   %ebx,%ebx
  800e45:	89 d9                	mov    %ebx,%ecx
  800e47:	75 0b                	jne    800e54 <__udivdi3+0x34>
  800e49:	b8 01 00 00 00       	mov    $0x1,%eax
  800e4e:	31 d2                	xor    %edx,%edx
  800e50:	f7 f3                	div    %ebx
  800e52:	89 c1                	mov    %eax,%ecx
  800e54:	31 d2                	xor    %edx,%edx
  800e56:	89 f0                	mov    %esi,%eax
  800e58:	f7 f1                	div    %ecx
  800e5a:	89 c6                	mov    %eax,%esi
  800e5c:	89 e8                	mov    %ebp,%eax
  800e5e:	89 f7                	mov    %esi,%edi
  800e60:	f7 f1                	div    %ecx
  800e62:	89 fa                	mov    %edi,%edx
  800e64:	83 c4 1c             	add    $0x1c,%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
  800e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e70:	39 f2                	cmp    %esi,%edx
  800e72:	77 7c                	ja     800ef0 <__udivdi3+0xd0>
  800e74:	0f bd fa             	bsr    %edx,%edi
  800e77:	83 f7 1f             	xor    $0x1f,%edi
  800e7a:	0f 84 98 00 00 00    	je     800f18 <__udivdi3+0xf8>
  800e80:	89 f9                	mov    %edi,%ecx
  800e82:	b8 20 00 00 00       	mov    $0x20,%eax
  800e87:	29 f8                	sub    %edi,%eax
  800e89:	d3 e2                	shl    %cl,%edx
  800e8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e8f:	89 c1                	mov    %eax,%ecx
  800e91:	89 da                	mov    %ebx,%edx
  800e93:	d3 ea                	shr    %cl,%edx
  800e95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e99:	09 d1                	or     %edx,%ecx
  800e9b:	89 f2                	mov    %esi,%edx
  800e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ea1:	89 f9                	mov    %edi,%ecx
  800ea3:	d3 e3                	shl    %cl,%ebx
  800ea5:	89 c1                	mov    %eax,%ecx
  800ea7:	d3 ea                	shr    %cl,%edx
  800ea9:	89 f9                	mov    %edi,%ecx
  800eab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800eaf:	d3 e6                	shl    %cl,%esi
  800eb1:	89 eb                	mov    %ebp,%ebx
  800eb3:	89 c1                	mov    %eax,%ecx
  800eb5:	d3 eb                	shr    %cl,%ebx
  800eb7:	09 de                	or     %ebx,%esi
  800eb9:	89 f0                	mov    %esi,%eax
  800ebb:	f7 74 24 08          	divl   0x8(%esp)
  800ebf:	89 d6                	mov    %edx,%esi
  800ec1:	89 c3                	mov    %eax,%ebx
  800ec3:	f7 64 24 0c          	mull   0xc(%esp)
  800ec7:	39 d6                	cmp    %edx,%esi
  800ec9:	72 0c                	jb     800ed7 <__udivdi3+0xb7>
  800ecb:	89 f9                	mov    %edi,%ecx
  800ecd:	d3 e5                	shl    %cl,%ebp
  800ecf:	39 c5                	cmp    %eax,%ebp
  800ed1:	73 5d                	jae    800f30 <__udivdi3+0x110>
  800ed3:	39 d6                	cmp    %edx,%esi
  800ed5:	75 59                	jne    800f30 <__udivdi3+0x110>
  800ed7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eda:	31 ff                	xor    %edi,%edi
  800edc:	89 fa                	mov    %edi,%edx
  800ede:	83 c4 1c             	add    $0x1c,%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    
  800ee6:	8d 76 00             	lea    0x0(%esi),%esi
  800ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ef0:	31 ff                	xor    %edi,%edi
  800ef2:	31 c0                	xor    %eax,%eax
  800ef4:	89 fa                	mov    %edi,%edx
  800ef6:	83 c4 1c             	add    $0x1c,%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
  800efe:	66 90                	xchg   %ax,%ax
  800f00:	31 ff                	xor    %edi,%edi
  800f02:	89 e8                	mov    %ebp,%eax
  800f04:	89 f2                	mov    %esi,%edx
  800f06:	f7 f3                	div    %ebx
  800f08:	89 fa                	mov    %edi,%edx
  800f0a:	83 c4 1c             	add    $0x1c,%esp
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    
  800f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f18:	39 f2                	cmp    %esi,%edx
  800f1a:	72 06                	jb     800f22 <__udivdi3+0x102>
  800f1c:	31 c0                	xor    %eax,%eax
  800f1e:	39 eb                	cmp    %ebp,%ebx
  800f20:	77 d2                	ja     800ef4 <__udivdi3+0xd4>
  800f22:	b8 01 00 00 00       	mov    $0x1,%eax
  800f27:	eb cb                	jmp    800ef4 <__udivdi3+0xd4>
  800f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f30:	89 d8                	mov    %ebx,%eax
  800f32:	31 ff                	xor    %edi,%edi
  800f34:	eb be                	jmp    800ef4 <__udivdi3+0xd4>
  800f36:	66 90                	xchg   %ax,%ax
  800f38:	66 90                	xchg   %ax,%ax
  800f3a:	66 90                	xchg   %ax,%ax
  800f3c:	66 90                	xchg   %ax,%ax
  800f3e:	66 90                	xchg   %ax,%ax

00800f40 <__umoddi3>:
  800f40:	55                   	push   %ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 1c             	sub    $0x1c,%esp
  800f47:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f57:	85 ed                	test   %ebp,%ebp
  800f59:	89 f0                	mov    %esi,%eax
  800f5b:	89 da                	mov    %ebx,%edx
  800f5d:	75 19                	jne    800f78 <__umoddi3+0x38>
  800f5f:	39 df                	cmp    %ebx,%edi
  800f61:	0f 86 b1 00 00 00    	jbe    801018 <__umoddi3+0xd8>
  800f67:	f7 f7                	div    %edi
  800f69:	89 d0                	mov    %edx,%eax
  800f6b:	31 d2                	xor    %edx,%edx
  800f6d:	83 c4 1c             	add    $0x1c,%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
  800f75:	8d 76 00             	lea    0x0(%esi),%esi
  800f78:	39 dd                	cmp    %ebx,%ebp
  800f7a:	77 f1                	ja     800f6d <__umoddi3+0x2d>
  800f7c:	0f bd cd             	bsr    %ebp,%ecx
  800f7f:	83 f1 1f             	xor    $0x1f,%ecx
  800f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f86:	0f 84 b4 00 00 00    	je     801040 <__umoddi3+0x100>
  800f8c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f91:	89 c2                	mov    %eax,%edx
  800f93:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f97:	29 c2                	sub    %eax,%edx
  800f99:	89 c1                	mov    %eax,%ecx
  800f9b:	89 f8                	mov    %edi,%eax
  800f9d:	d3 e5                	shl    %cl,%ebp
  800f9f:	89 d1                	mov    %edx,%ecx
  800fa1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fa5:	d3 e8                	shr    %cl,%eax
  800fa7:	09 c5                	or     %eax,%ebp
  800fa9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fad:	89 c1                	mov    %eax,%ecx
  800faf:	d3 e7                	shl    %cl,%edi
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	d3 ef                	shr    %cl,%edi
  800fbb:	89 c1                	mov    %eax,%ecx
  800fbd:	89 f0                	mov    %esi,%eax
  800fbf:	d3 e3                	shl    %cl,%ebx
  800fc1:	89 d1                	mov    %edx,%ecx
  800fc3:	89 fa                	mov    %edi,%edx
  800fc5:	d3 e8                	shr    %cl,%eax
  800fc7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fcc:	09 d8                	or     %ebx,%eax
  800fce:	f7 f5                	div    %ebp
  800fd0:	d3 e6                	shl    %cl,%esi
  800fd2:	89 d1                	mov    %edx,%ecx
  800fd4:	f7 64 24 08          	mull   0x8(%esp)
  800fd8:	39 d1                	cmp    %edx,%ecx
  800fda:	89 c3                	mov    %eax,%ebx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	72 06                	jb     800fe6 <__umoddi3+0xa6>
  800fe0:	75 0e                	jne    800ff0 <__umoddi3+0xb0>
  800fe2:	39 c6                	cmp    %eax,%esi
  800fe4:	73 0a                	jae    800ff0 <__umoddi3+0xb0>
  800fe6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800fea:	19 ea                	sbb    %ebp,%edx
  800fec:	89 d7                	mov    %edx,%edi
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	89 ca                	mov    %ecx,%edx
  800ff2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800ff7:	29 de                	sub    %ebx,%esi
  800ff9:	19 fa                	sbb    %edi,%edx
  800ffb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	d3 e0                	shl    %cl,%eax
  801003:	89 d9                	mov    %ebx,%ecx
  801005:	d3 ee                	shr    %cl,%esi
  801007:	d3 ea                	shr    %cl,%edx
  801009:	09 f0                	or     %esi,%eax
  80100b:	83 c4 1c             	add    $0x1c,%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
  801013:	90                   	nop
  801014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801018:	85 ff                	test   %edi,%edi
  80101a:	89 f9                	mov    %edi,%ecx
  80101c:	75 0b                	jne    801029 <__umoddi3+0xe9>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f7                	div    %edi
  801027:	89 c1                	mov    %eax,%ecx
  801029:	89 d8                	mov    %ebx,%eax
  80102b:	31 d2                	xor    %edx,%edx
  80102d:	f7 f1                	div    %ecx
  80102f:	89 f0                	mov    %esi,%eax
  801031:	f7 f1                	div    %ecx
  801033:	e9 31 ff ff ff       	jmp    800f69 <__umoddi3+0x29>
  801038:	90                   	nop
  801039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801040:	39 dd                	cmp    %ebx,%ebp
  801042:	72 08                	jb     80104c <__umoddi3+0x10c>
  801044:	39 f7                	cmp    %esi,%edi
  801046:	0f 87 21 ff ff ff    	ja     800f6d <__umoddi3+0x2d>
  80104c:	89 da                	mov    %ebx,%edx
  80104e:	89 f0                	mov    %esi,%eax
  801050:	29 f8                	sub    %edi,%eax
  801052:	19 ea                	sbb    %ebp,%edx
  801054:	e9 14 ff ff ff       	jmp    800f6d <__umoddi3+0x2d>
