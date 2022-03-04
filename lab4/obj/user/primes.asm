
obj/user/primes：     文件格式 elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 8f 10 00 00       	call   8010db <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 00 14 80 00       	push   $0x801400
  800060:	e8 c6 01 00 00       	call   80022b <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 65 0e 00 00       	call   800ecf <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 30                	js     8000a3 <primeproc+0x70>
		panic("fork: %e", id);
	if (id == 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	74 c8                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800077:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 00                	push   $0x0
  80007f:	6a 00                	push   $0x0
  800081:	56                   	push   %esi
  800082:	e8 54 10 00 00       	call   8010db <ipc_recv>
  800087:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800089:	99                   	cltd   
  80008a:	f7 fb                	idiv   %ebx
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	85 d2                	test   %edx,%edx
  800091:	74 e7                	je     80007a <primeproc+0x47>
			ipc_send(id, i, 0, 0);
  800093:	6a 00                	push   $0x0
  800095:	6a 00                	push   $0x0
  800097:	51                   	push   %ecx
  800098:	57                   	push   %edi
  800099:	e8 54 10 00 00       	call   8010f2 <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 0c 14 80 00       	push   $0x80140c
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 15 14 80 00       	push   $0x801415
  8000b0:	e8 9b 00 00 00       	call   800150 <_panic>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 10 0e 00 00       	call   800ecf <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1c                	js     8000e1 <umain+0x2c>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	74 25                	je     8000f3 <umain+0x3e>
		ipc_send(id, i, 0, 0);
  8000ce:	6a 00                	push   $0x0
  8000d0:	6a 00                	push   $0x0
  8000d2:	53                   	push   %ebx
  8000d3:	56                   	push   %esi
  8000d4:	e8 19 10 00 00       	call   8010f2 <ipc_send>
	for (i = 2; ; i++)
  8000d9:	83 c3 01             	add    $0x1,%ebx
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	eb ed                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000e1:	50                   	push   %eax
  8000e2:	68 0c 14 80 00       	push   $0x80140c
  8000e7:	6a 2d                	push   $0x2d
  8000e9:	68 15 14 80 00       	push   $0x801415
  8000ee:	e8 5d 00 00 00       	call   800150 <_panic>
		primeproc();
  8000f3:	e8 3b ff ff ff       	call   800033 <primeproc>

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800100:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800103:	e8 3c 0b 00 00       	call   800c44 <sys_getenvid>
  800108:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800110:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800115:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011a:	85 db                	test   %ebx,%ebx
  80011c:	7e 07                	jle    800125 <libmain+0x2d>
		binaryname = argv[0];
  80011e:	8b 06                	mov    (%esi),%eax
  800120:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 86 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  80012f:	e8 0a 00 00 00       	call   80013e <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800144:	6a 00                	push   $0x0
  800146:	e8 b8 0a 00 00       	call   800c03 <sys_env_destroy>
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800155:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800158:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80015e:	e8 e1 0a 00 00       	call   800c44 <sys_getenvid>
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 0c             	pushl  0xc(%ebp)
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	56                   	push   %esi
  80016d:	50                   	push   %eax
  80016e:	68 30 14 80 00       	push   $0x801430
  800173:	e8 b3 00 00 00       	call   80022b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800178:	83 c4 18             	add    $0x18,%esp
  80017b:	53                   	push   %ebx
  80017c:	ff 75 10             	pushl  0x10(%ebp)
  80017f:	e8 56 00 00 00       	call   8001da <vcprintf>
	cprintf("\n");
  800184:	c7 04 24 53 14 80 00 	movl   $0x801453,(%esp)
  80018b:	e8 9b 00 00 00       	call   80022b <cprintf>
  800190:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800193:	cc                   	int3   
  800194:	eb fd                	jmp    800193 <_panic+0x43>

00800196 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	53                   	push   %ebx
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a0:	8b 13                	mov    (%ebx),%edx
  8001a2:	8d 42 01             	lea    0x1(%edx),%eax
  8001a5:	89 03                	mov    %eax,(%ebx)
  8001a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b3:	74 09                	je     8001be <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	68 ff 00 00 00       	push   $0xff
  8001c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 f7 09 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  8001cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb db                	jmp    8001b5 <putch+0x1f>

008001da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ea:	00 00 00 
	b.cnt = 0;
  8001ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f7:	ff 75 0c             	pushl  0xc(%ebp)
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	68 96 01 80 00       	push   $0x800196
  800209:	e8 1a 01 00 00       	call   800328 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020e:	83 c4 08             	add    $0x8,%esp
  800211:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800217:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	e8 a3 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  800223:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800231:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800234:	50                   	push   %eax
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	e8 9d ff ff ff       	call   8001da <vcprintf>
	va_end(ap);

	return cnt;
}
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	83 ec 1c             	sub    $0x1c,%esp
  800248:	89 c7                	mov    %eax,%edi
  80024a:	89 d6                	mov    %edx,%esi
  80024c:	8b 45 08             	mov    0x8(%ebp),%eax
  80024f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800252:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800255:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800260:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800263:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800266:	39 d3                	cmp    %edx,%ebx
  800268:	72 05                	jb     80026f <printnum+0x30>
  80026a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80026d:	77 7a                	ja     8002e9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	ff 75 18             	pushl  0x18(%ebp)
  800275:	8b 45 14             	mov    0x14(%ebp),%eax
  800278:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027b:	53                   	push   %ebx
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	ff 75 e4             	pushl  -0x1c(%ebp)
  800285:	ff 75 e0             	pushl  -0x20(%ebp)
  800288:	ff 75 dc             	pushl  -0x24(%ebp)
  80028b:	ff 75 d8             	pushl  -0x28(%ebp)
  80028e:	e8 2d 0f 00 00       	call   8011c0 <__udivdi3>
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	52                   	push   %edx
  800297:	50                   	push   %eax
  800298:	89 f2                	mov    %esi,%edx
  80029a:	89 f8                	mov    %edi,%eax
  80029c:	e8 9e ff ff ff       	call   80023f <printnum>
  8002a1:	83 c4 20             	add    $0x20,%esp
  8002a4:	eb 13                	jmp    8002b9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	56                   	push   %esi
  8002aa:	ff 75 18             	pushl  0x18(%ebp)
  8002ad:	ff d7                	call   *%edi
  8002af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	85 db                	test   %ebx,%ebx
  8002b7:	7f ed                	jg     8002a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	56                   	push   %esi
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cc:	e8 0f 10 00 00       	call   8012e0 <__umoddi3>
  8002d1:	83 c4 14             	add    $0x14,%esp
  8002d4:	0f be 80 55 14 80 00 	movsbl 0x801455(%eax),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff d7                	call   *%edi
}
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
  8002e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ec:	eb c4                	jmp    8002b2 <printnum+0x73>

008002ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f8:	8b 10                	mov    (%eax),%edx
  8002fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fd:	73 0a                	jae    800309 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800302:	89 08                	mov    %ecx,(%eax)
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	88 02                	mov    %al,(%edx)
}
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <printfmt>:
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800311:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800314:	50                   	push   %eax
  800315:	ff 75 10             	pushl  0x10(%ebp)
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 05 00 00 00       	call   800328 <vprintfmt>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <vprintfmt>:
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 2c             	sub    $0x2c,%esp
  800331:	8b 75 08             	mov    0x8(%ebp),%esi
  800334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800337:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033a:	e9 00 04 00 00       	jmp    80073f <vprintfmt+0x417>
		padc = ' ';
  80033f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800343:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80034a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800351:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8d 47 01             	lea    0x1(%edi),%eax
  800360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800363:	0f b6 17             	movzbl (%edi),%edx
  800366:	8d 42 dd             	lea    -0x23(%edx),%eax
  800369:	3c 55                	cmp    $0x55,%al
  80036b:	0f 87 51 04 00 00    	ja     8007c2 <vprintfmt+0x49a>
  800371:	0f b6 c0             	movzbl %al,%eax
  800374:	ff 24 85 20 15 80 00 	jmp    *0x801520(,%eax,4)
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800382:	eb d9                	jmp    80035d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800387:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80038b:	eb d0                	jmp    80035d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80038d:	0f b6 d2             	movzbl %dl,%edx
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800393:	b8 00 00 00 00       	mov    $0x0,%eax
  800398:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a8:	83 f9 09             	cmp    $0x9,%ecx
  8003ab:	77 55                	ja     800402 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b0:	eb e9                	jmp    80039b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 40 04             	lea    0x4(%eax),%eax
  8003c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ca:	79 91                	jns    80035d <vprintfmt+0x35>
				width = precision, precision = -1;
  8003cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d9:	eb 82                	jmp    80035d <vprintfmt+0x35>
  8003db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e5:	0f 49 d0             	cmovns %eax,%edx
  8003e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ee:	e9 6a ff ff ff       	jmp    80035d <vprintfmt+0x35>
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003fd:	e9 5b ff ff ff       	jmp    80035d <vprintfmt+0x35>
  800402:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800405:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800408:	eb bc                	jmp    8003c6 <vprintfmt+0x9e>
			lflag++;
  80040a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800410:	e9 48 ff ff ff       	jmp    80035d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800415:	8b 45 14             	mov    0x14(%ebp),%eax
  800418:	8d 78 04             	lea    0x4(%eax),%edi
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	53                   	push   %ebx
  80041f:	ff 30                	pushl  (%eax)
  800421:	ff d6                	call   *%esi
			break;
  800423:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800426:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800429:	e9 0e 03 00 00       	jmp    80073c <vprintfmt+0x414>
			err = va_arg(ap, int);
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 78 04             	lea    0x4(%eax),%edi
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
  800437:	31 d0                	xor    %edx,%eax
  800439:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043b:	83 f8 08             	cmp    $0x8,%eax
  80043e:	7f 23                	jg     800463 <vprintfmt+0x13b>
  800440:	8b 14 85 80 16 80 00 	mov    0x801680(,%eax,4),%edx
  800447:	85 d2                	test   %edx,%edx
  800449:	74 18                	je     800463 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80044b:	52                   	push   %edx
  80044c:	68 76 14 80 00       	push   $0x801476
  800451:	53                   	push   %ebx
  800452:	56                   	push   %esi
  800453:	e8 b3 fe ff ff       	call   80030b <printfmt>
  800458:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045e:	e9 d9 02 00 00       	jmp    80073c <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800463:	50                   	push   %eax
  800464:	68 6d 14 80 00       	push   $0x80146d
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 9b fe ff ff       	call   80030b <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800473:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800476:	e9 c1 02 00 00       	jmp    80073c <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	83 c0 04             	add    $0x4,%eax
  800481:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800489:	85 ff                	test   %edi,%edi
  80048b:	b8 66 14 80 00       	mov    $0x801466,%eax
  800490:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800493:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800497:	0f 8e bd 00 00 00    	jle    80055a <vprintfmt+0x232>
  80049d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a1:	75 0e                	jne    8004b1 <vprintfmt+0x189>
  8004a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004af:	eb 6d                	jmp    80051e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8004b7:	57                   	push   %edi
  8004b8:	e8 ad 03 00 00       	call   80086a <strnlen>
  8004bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c0:	29 c1                	sub    %eax,%ecx
  8004c2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d4:	eb 0f                	jmp    8004e5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	53                   	push   %ebx
  8004da:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	83 ef 01             	sub    $0x1,%edi
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	85 ff                	test   %edi,%edi
  8004e7:	7f ed                	jg     8004d6 <vprintfmt+0x1ae>
  8004e9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004ec:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ef:	85 c9                	test   %ecx,%ecx
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	0f 49 c1             	cmovns %ecx,%eax
  8004f9:	29 c1                	sub    %eax,%ecx
  8004fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8004fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800501:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800504:	89 cb                	mov    %ecx,%ebx
  800506:	eb 16                	jmp    80051e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800508:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050c:	75 31                	jne    80053f <vprintfmt+0x217>
					putch(ch, putdat);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	ff 75 0c             	pushl  0xc(%ebp)
  800514:	50                   	push   %eax
  800515:	ff 55 08             	call   *0x8(%ebp)
  800518:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051b:	83 eb 01             	sub    $0x1,%ebx
  80051e:	83 c7 01             	add    $0x1,%edi
  800521:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800525:	0f be c2             	movsbl %dl,%eax
  800528:	85 c0                	test   %eax,%eax
  80052a:	74 59                	je     800585 <vprintfmt+0x25d>
  80052c:	85 f6                	test   %esi,%esi
  80052e:	78 d8                	js     800508 <vprintfmt+0x1e0>
  800530:	83 ee 01             	sub    $0x1,%esi
  800533:	79 d3                	jns    800508 <vprintfmt+0x1e0>
  800535:	89 df                	mov    %ebx,%edi
  800537:	8b 75 08             	mov    0x8(%ebp),%esi
  80053a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053d:	eb 37                	jmp    800576 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80053f:	0f be d2             	movsbl %dl,%edx
  800542:	83 ea 20             	sub    $0x20,%edx
  800545:	83 fa 5e             	cmp    $0x5e,%edx
  800548:	76 c4                	jbe    80050e <vprintfmt+0x1e6>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 0c             	pushl  0xc(%ebp)
  800550:	6a 3f                	push   $0x3f
  800552:	ff 55 08             	call   *0x8(%ebp)
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	eb c1                	jmp    80051b <vprintfmt+0x1f3>
  80055a:	89 75 08             	mov    %esi,0x8(%ebp)
  80055d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800560:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800563:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800566:	eb b6                	jmp    80051e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	53                   	push   %ebx
  80056c:	6a 20                	push   $0x20
  80056e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800570:	83 ef 01             	sub    $0x1,%edi
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	85 ff                	test   %edi,%edi
  800578:	7f ee                	jg     800568 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80057a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
  800580:	e9 b7 01 00 00       	jmp    80073c <vprintfmt+0x414>
  800585:	89 df                	mov    %ebx,%edi
  800587:	8b 75 08             	mov    0x8(%ebp),%esi
  80058a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80058d:	eb e7                	jmp    800576 <vprintfmt+0x24e>
	if (lflag >= 2)
  80058f:	83 f9 01             	cmp    $0x1,%ecx
  800592:	7e 3f                	jle    8005d3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 50 04             	mov    0x4(%eax),%edx
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 08             	lea    0x8(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005af:	79 5c                	jns    80060d <vprintfmt+0x2e5>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2d                	push   $0x2d
  8005b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bf:	f7 da                	neg    %edx
  8005c1:	83 d1 00             	adc    $0x0,%ecx
  8005c4:	f7 d9                	neg    %ecx
  8005c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 4f 01 00 00       	jmp    800722 <vprintfmt+0x3fa>
	else if (lflag)
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	75 1b                	jne    8005f2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f0:	eb b9                	jmp    8005ab <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	89 c1                	mov    %eax,%ecx
  8005fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 40 04             	lea    0x4(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	eb 9e                	jmp    8005ab <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80060d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800610:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 05 01 00 00       	jmp    800722 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80061d:	83 f9 01             	cmp    $0x1,%ecx
  800620:	7e 18                	jle    80063a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	8b 48 04             	mov    0x4(%eax),%ecx
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
  800635:	e9 e8 00 00 00       	jmp    800722 <vprintfmt+0x3fa>
	else if (lflag)
  80063a:	85 c9                	test   %ecx,%ecx
  80063c:	75 1a                	jne    800658 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 10                	mov    (%eax),%edx
  800643:	b9 00 00 00 00       	mov    $0x0,%ecx
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800653:	e9 ca 00 00 00       	jmp    800722 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 10                	mov    (%eax),%edx
  80065d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800668:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066d:	e9 b0 00 00 00       	jmp    800722 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800672:	83 f9 01             	cmp    $0x1,%ecx
  800675:	7e 3c                	jle    8006b3 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 50 04             	mov    0x4(%eax),%edx
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 08             	lea    0x8(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80068e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800692:	79 59                	jns    8006ed <vprintfmt+0x3c5>
                putch('-', putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	53                   	push   %ebx
  800698:	6a 2d                	push   $0x2d
  80069a:	ff d6                	call   *%esi
                num = -(long long) num;
  80069c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a2:	f7 da                	neg    %edx
  8006a4:	83 d1 00             	adc    $0x0,%ecx
  8006a7:	f7 d9                	neg    %ecx
  8006a9:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b1:	eb 6f                	jmp    800722 <vprintfmt+0x3fa>
	else if (lflag)
  8006b3:	85 c9                	test   %ecx,%ecx
  8006b5:	75 1b                	jne    8006d2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 c1                	mov    %eax,%ecx
  8006c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d0:	eb bc                	jmp    80068e <vprintfmt+0x366>
		return va_arg(*ap, long);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 c1                	mov    %eax,%ecx
  8006dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	eb a1                	jmp    80068e <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f8:	eb 28                	jmp    800722 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 30                	push   $0x30
  800700:	ff d6                	call   *%esi
			putch('x', putdat);
  800702:	83 c4 08             	add    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 78                	push   $0x78
  800708:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800714:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800722:	83 ec 0c             	sub    $0xc,%esp
  800725:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800729:	57                   	push   %edi
  80072a:	ff 75 e0             	pushl  -0x20(%ebp)
  80072d:	50                   	push   %eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	89 da                	mov    %ebx,%edx
  800732:	89 f0                	mov    %esi,%eax
  800734:	e8 06 fb ff ff       	call   80023f <printnum>
			break;
  800739:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80073c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	83 c7 01             	add    $0x1,%edi
  800742:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800746:	83 f8 25             	cmp    $0x25,%eax
  800749:	0f 84 f0 fb ff ff    	je     80033f <vprintfmt+0x17>
			if (ch == '\0')
  80074f:	85 c0                	test   %eax,%eax
  800751:	0f 84 8b 00 00 00    	je     8007e2 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	50                   	push   %eax
  80075c:	ff d6                	call   *%esi
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	eb dc                	jmp    80073f <vprintfmt+0x417>
	if (lflag >= 2)
  800763:	83 f9 01             	cmp    $0x1,%ecx
  800766:	7e 15                	jle    80077d <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 10                	mov    (%eax),%edx
  80076d:	8b 48 04             	mov    0x4(%eax),%ecx
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800776:	b8 10 00 00 00       	mov    $0x10,%eax
  80077b:	eb a5                	jmp    800722 <vprintfmt+0x3fa>
	else if (lflag)
  80077d:	85 c9                	test   %ecx,%ecx
  80077f:	75 17                	jne    800798 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 10                	mov    (%eax),%edx
  800786:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800791:	b8 10 00 00 00       	mov    $0x10,%eax
  800796:	eb 8a                	jmp    800722 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 10                	mov    (%eax),%edx
  80079d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a2:	8d 40 04             	lea    0x4(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ad:	e9 70 ff ff ff       	jmp    800722 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 25                	push   $0x25
  8007b8:	ff d6                	call   *%esi
			break;
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	e9 7a ff ff ff       	jmp    80073c <vprintfmt+0x414>
			putch('%', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	6a 25                	push   $0x25
  8007c8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 f8                	mov    %edi,%eax
  8007cf:	eb 03                	jmp    8007d4 <vprintfmt+0x4ac>
  8007d1:	83 e8 01             	sub    $0x1,%eax
  8007d4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007d8:	75 f7                	jne    8007d1 <vprintfmt+0x4a9>
  8007da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007dd:	e9 5a ff ff ff       	jmp    80073c <vprintfmt+0x414>
}
  8007e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e5:	5b                   	pop    %ebx
  8007e6:	5e                   	pop    %esi
  8007e7:	5f                   	pop    %edi
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 18             	sub    $0x18,%esp
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007fd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800807:	85 c0                	test   %eax,%eax
  800809:	74 26                	je     800831 <vsnprintf+0x47>
  80080b:	85 d2                	test   %edx,%edx
  80080d:	7e 22                	jle    800831 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80080f:	ff 75 14             	pushl  0x14(%ebp)
  800812:	ff 75 10             	pushl  0x10(%ebp)
  800815:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800818:	50                   	push   %eax
  800819:	68 ee 02 80 00       	push   $0x8002ee
  80081e:	e8 05 fb ff ff       	call   800328 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800826:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80082c:	83 c4 10             	add    $0x10,%esp
}
  80082f:	c9                   	leave  
  800830:	c3                   	ret    
		return -E_INVAL;
  800831:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800836:	eb f7                	jmp    80082f <vsnprintf+0x45>

00800838 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800841:	50                   	push   %eax
  800842:	ff 75 10             	pushl  0x10(%ebp)
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 9a ff ff ff       	call   8007ea <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	eb 03                	jmp    800862 <strlen+0x10>
		n++;
  80085f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800862:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800866:	75 f7                	jne    80085f <strlen+0xd>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800870:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	eb 03                	jmp    80087d <strnlen+0x13>
		n++;
  80087a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087d:	39 d0                	cmp    %edx,%eax
  80087f:	74 06                	je     800887 <strnlen+0x1d>
  800881:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800885:	75 f3                	jne    80087a <strnlen+0x10>
	return n;
}
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800893:	89 c2                	mov    %eax,%edx
  800895:	83 c1 01             	add    $0x1,%ecx
  800898:	83 c2 01             	add    $0x1,%edx
  80089b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80089f:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a2:	84 db                	test   %bl,%bl
  8008a4:	75 ef                	jne    800895 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a6:	5b                   	pop    %ebx
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	53                   	push   %ebx
  8008ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b0:	53                   	push   %ebx
  8008b1:	e8 9c ff ff ff       	call   800852 <strlen>
  8008b6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	01 d8                	add    %ebx,%eax
  8008be:	50                   	push   %eax
  8008bf:	e8 c5 ff ff ff       	call   800889 <strcpy>
	return dst;
}
  8008c4:	89 d8                	mov    %ebx,%eax
  8008c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	56                   	push   %esi
  8008cf:	53                   	push   %ebx
  8008d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d6:	89 f3                	mov    %esi,%ebx
  8008d8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008db:	89 f2                	mov    %esi,%edx
  8008dd:	eb 0f                	jmp    8008ee <strncpy+0x23>
		*dst++ = *src;
  8008df:	83 c2 01             	add    $0x1,%edx
  8008e2:	0f b6 01             	movzbl (%ecx),%eax
  8008e5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e8:	80 39 01             	cmpb   $0x1,(%ecx)
  8008eb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008ee:	39 da                	cmp    %ebx,%edx
  8008f0:	75 ed                	jne    8008df <strncpy+0x14>
	}
	return ret;
}
  8008f2:	89 f0                	mov    %esi,%eax
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800900:	8b 55 0c             	mov    0xc(%ebp),%edx
  800903:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800906:	89 f0                	mov    %esi,%eax
  800908:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80090c:	85 c9                	test   %ecx,%ecx
  80090e:	75 0b                	jne    80091b <strlcpy+0x23>
  800910:	eb 17                	jmp    800929 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800912:	83 c2 01             	add    $0x1,%edx
  800915:	83 c0 01             	add    $0x1,%eax
  800918:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80091b:	39 d8                	cmp    %ebx,%eax
  80091d:	74 07                	je     800926 <strlcpy+0x2e>
  80091f:	0f b6 0a             	movzbl (%edx),%ecx
  800922:	84 c9                	test   %cl,%cl
  800924:	75 ec                	jne    800912 <strlcpy+0x1a>
		*dst = '\0';
  800926:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800929:	29 f0                	sub    %esi,%eax
}
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800935:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800938:	eb 06                	jmp    800940 <strcmp+0x11>
		p++, q++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800940:	0f b6 01             	movzbl (%ecx),%eax
  800943:	84 c0                	test   %al,%al
  800945:	74 04                	je     80094b <strcmp+0x1c>
  800947:	3a 02                	cmp    (%edx),%al
  800949:	74 ef                	je     80093a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80094b:	0f b6 c0             	movzbl %al,%eax
  80094e:	0f b6 12             	movzbl (%edx),%edx
  800951:	29 d0                	sub    %edx,%eax
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095f:	89 c3                	mov    %eax,%ebx
  800961:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800964:	eb 06                	jmp    80096c <strncmp+0x17>
		n--, p++, q++;
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80096c:	39 d8                	cmp    %ebx,%eax
  80096e:	74 16                	je     800986 <strncmp+0x31>
  800970:	0f b6 08             	movzbl (%eax),%ecx
  800973:	84 c9                	test   %cl,%cl
  800975:	74 04                	je     80097b <strncmp+0x26>
  800977:	3a 0a                	cmp    (%edx),%cl
  800979:	74 eb                	je     800966 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80097b:	0f b6 00             	movzbl (%eax),%eax
  80097e:	0f b6 12             	movzbl (%edx),%edx
  800981:	29 d0                	sub    %edx,%eax
}
  800983:	5b                   	pop    %ebx
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    
		return 0;
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	eb f6                	jmp    800983 <strncmp+0x2e>

0080098d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800997:	0f b6 10             	movzbl (%eax),%edx
  80099a:	84 d2                	test   %dl,%dl
  80099c:	74 09                	je     8009a7 <strchr+0x1a>
		if (*s == c)
  80099e:	38 ca                	cmp    %cl,%dl
  8009a0:	74 0a                	je     8009ac <strchr+0x1f>
	for (; *s; s++)
  8009a2:	83 c0 01             	add    $0x1,%eax
  8009a5:	eb f0                	jmp    800997 <strchr+0xa>
			return (char *) s;
	return 0;
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b8:	eb 03                	jmp    8009bd <strfind+0xf>
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 04                	je     8009c8 <strfind+0x1a>
  8009c4:	84 d2                	test   %dl,%dl
  8009c6:	75 f2                	jne    8009ba <strfind+0xc>
			break;
	return (char *) s;
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	57                   	push   %edi
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d6:	85 c9                	test   %ecx,%ecx
  8009d8:	74 13                	je     8009ed <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009da:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e0:	75 05                	jne    8009e7 <memset+0x1d>
  8009e2:	f6 c1 03             	test   $0x3,%cl
  8009e5:	74 0d                	je     8009f4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	fc                   	cld    
  8009eb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ed:	89 f8                	mov    %edi,%eax
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5f                   	pop    %edi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    
		c &= 0xFF;
  8009f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f8:	89 d3                	mov    %edx,%ebx
  8009fa:	c1 e3 08             	shl    $0x8,%ebx
  8009fd:	89 d0                	mov    %edx,%eax
  8009ff:	c1 e0 18             	shl    $0x18,%eax
  800a02:	89 d6                	mov    %edx,%esi
  800a04:	c1 e6 10             	shl    $0x10,%esi
  800a07:	09 f0                	or     %esi,%eax
  800a09:	09 c2                	or     %eax,%edx
  800a0b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a0d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a10:	89 d0                	mov    %edx,%eax
  800a12:	fc                   	cld    
  800a13:	f3 ab                	rep stos %eax,%es:(%edi)
  800a15:	eb d6                	jmp    8009ed <memset+0x23>

00800a17 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a22:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a25:	39 c6                	cmp    %eax,%esi
  800a27:	73 35                	jae    800a5e <memmove+0x47>
  800a29:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a2c:	39 c2                	cmp    %eax,%edx
  800a2e:	76 2e                	jbe    800a5e <memmove+0x47>
		s += n;
		d += n;
  800a30:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a33:	89 d6                	mov    %edx,%esi
  800a35:	09 fe                	or     %edi,%esi
  800a37:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3d:	74 0c                	je     800a4b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 21                	jmp    800a6c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4b:	f6 c1 03             	test   $0x3,%cl
  800a4e:	75 ef                	jne    800a3f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a50:	83 ef 04             	sub    $0x4,%edi
  800a53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a59:	fd                   	std    
  800a5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5c:	eb ea                	jmp    800a48 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5e:	89 f2                	mov    %esi,%edx
  800a60:	09 c2                	or     %eax,%edx
  800a62:	f6 c2 03             	test   $0x3,%dl
  800a65:	74 09                	je     800a70 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a67:	89 c7                	mov    %eax,%edi
  800a69:	fc                   	cld    
  800a6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6c:	5e                   	pop    %esi
  800a6d:	5f                   	pop    %edi
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a70:	f6 c1 03             	test   $0x3,%cl
  800a73:	75 f2                	jne    800a67 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a78:	89 c7                	mov    %eax,%edi
  800a7a:	fc                   	cld    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb ed                	jmp    800a6c <memmove+0x55>

00800a7f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a82:	ff 75 10             	pushl  0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 87 ff ff ff       	call   800a17 <memmove>
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9d:	89 c6                	mov    %eax,%esi
  800a9f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa2:	39 f0                	cmp    %esi,%eax
  800aa4:	74 1c                	je     800ac2 <memcmp+0x30>
		if (*s1 != *s2)
  800aa6:	0f b6 08             	movzbl (%eax),%ecx
  800aa9:	0f b6 1a             	movzbl (%edx),%ebx
  800aac:	38 d9                	cmp    %bl,%cl
  800aae:	75 08                	jne    800ab8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	eb ea                	jmp    800aa2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ab8:	0f b6 c1             	movzbl %cl,%eax
  800abb:	0f b6 db             	movzbl %bl,%ebx
  800abe:	29 d8                	sub    %ebx,%eax
  800ac0:	eb 05                	jmp    800ac7 <memcmp+0x35>
	}

	return 0;
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac7:	5b                   	pop    %ebx
  800ac8:	5e                   	pop    %esi
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad4:	89 c2                	mov    %eax,%edx
  800ad6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad9:	39 d0                	cmp    %edx,%eax
  800adb:	73 09                	jae    800ae6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800add:	38 08                	cmp    %cl,(%eax)
  800adf:	74 05                	je     800ae6 <memfind+0x1b>
	for (; s < ends; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f3                	jmp    800ad9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af4:	eb 03                	jmp    800af9 <strtol+0x11>
		s++;
  800af6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	3c 20                	cmp    $0x20,%al
  800afe:	74 f6                	je     800af6 <strtol+0xe>
  800b00:	3c 09                	cmp    $0x9,%al
  800b02:	74 f2                	je     800af6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b04:	3c 2b                	cmp    $0x2b,%al
  800b06:	74 2e                	je     800b36 <strtol+0x4e>
	int neg = 0;
  800b08:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b0d:	3c 2d                	cmp    $0x2d,%al
  800b0f:	74 2f                	je     800b40 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b11:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b17:	75 05                	jne    800b1e <strtol+0x36>
  800b19:	80 39 30             	cmpb   $0x30,(%ecx)
  800b1c:	74 2c                	je     800b4a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b1e:	85 db                	test   %ebx,%ebx
  800b20:	75 0a                	jne    800b2c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b22:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b27:	80 39 30             	cmpb   $0x30,(%ecx)
  800b2a:	74 28                	je     800b54 <strtol+0x6c>
		base = 10;
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b34:	eb 50                	jmp    800b86 <strtol+0x9e>
		s++;
  800b36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb d1                	jmp    800b11 <strtol+0x29>
		s++, neg = 1;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bf 01 00 00 00       	mov    $0x1,%edi
  800b48:	eb c7                	jmp    800b11 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4e:	74 0e                	je     800b5e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	75 d8                	jne    800b2c <strtol+0x44>
		s++, base = 8;
  800b54:	83 c1 01             	add    $0x1,%ecx
  800b57:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5c:	eb ce                	jmp    800b2c <strtol+0x44>
		s += 2, base = 16;
  800b5e:	83 c1 02             	add    $0x2,%ecx
  800b61:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b66:	eb c4                	jmp    800b2c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b6b:	89 f3                	mov    %esi,%ebx
  800b6d:	80 fb 19             	cmp    $0x19,%bl
  800b70:	77 29                	ja     800b9b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b72:	0f be d2             	movsbl %dl,%edx
  800b75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b7b:	7d 30                	jge    800bad <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b86:	0f b6 11             	movzbl (%ecx),%edx
  800b89:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b8c:	89 f3                	mov    %esi,%ebx
  800b8e:	80 fb 09             	cmp    $0x9,%bl
  800b91:	77 d5                	ja     800b68 <strtol+0x80>
			dig = *s - '0';
  800b93:	0f be d2             	movsbl %dl,%edx
  800b96:	83 ea 30             	sub    $0x30,%edx
  800b99:	eb dd                	jmp    800b78 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9e:	89 f3                	mov    %esi,%ebx
  800ba0:	80 fb 19             	cmp    $0x19,%bl
  800ba3:	77 08                	ja     800bad <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba5:	0f be d2             	movsbl %dl,%edx
  800ba8:	83 ea 37             	sub    $0x37,%edx
  800bab:	eb cb                	jmp    800b78 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 05                	je     800bb8 <strtol+0xd0>
		*endptr = (char *) s;
  800bb3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb8:	89 c2                	mov    %eax,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 45 c2             	cmovne %edx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void) {
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	b8 03 00 00 00       	mov    $0x3,%eax
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7f 08                	jg     800c2d <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c2d:	83 ec 0c             	sub    $0xc,%esp
  800c30:	50                   	push   %eax
  800c31:	6a 03                	push   $0x3
  800c33:	68 a4 16 80 00       	push   $0x8016a4
  800c38:	6a 24                	push   $0x24
  800c3a:	68 c1 16 80 00       	push   $0x8016c1
  800c3f:	e8 0c f5 ff ff       	call   800150 <_panic>

00800c44 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_yield>:

void
sys_yield(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c8b:	be 00 00 00 00       	mov    $0x0,%esi
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9e:	89 f7                	mov    %esi,%edi
  800ca0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7f 08                	jg     800cae <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	83 ec 0c             	sub    $0xc,%esp
  800cb1:	50                   	push   %eax
  800cb2:	6a 04                	push   $0x4
  800cb4:	68 a4 16 80 00       	push   $0x8016a4
  800cb9:	6a 24                	push   $0x24
  800cbb:	68 c1 16 80 00       	push   $0x8016c1
  800cc0:	e8 8b f4 ff ff       	call   800150 <_panic>

00800cc5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cdf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	7f 08                	jg     800cf0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cf0:	83 ec 0c             	sub    $0xc,%esp
  800cf3:	50                   	push   %eax
  800cf4:	6a 05                	push   $0x5
  800cf6:	68 a4 16 80 00       	push   $0x8016a4
  800cfb:	6a 24                	push   $0x24
  800cfd:	68 c1 16 80 00       	push   $0x8016c1
  800d02:	e8 49 f4 ff ff       	call   800150 <_panic>

00800d07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d20:	89 df                	mov    %ebx,%edi
  800d22:	89 de                	mov    %ebx,%esi
  800d24:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7f 08                	jg     800d32 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d32:	83 ec 0c             	sub    $0xc,%esp
  800d35:	50                   	push   %eax
  800d36:	6a 06                	push   $0x6
  800d38:	68 a4 16 80 00       	push   $0x8016a4
  800d3d:	6a 24                	push   $0x24
  800d3f:	68 c1 16 80 00       	push   $0x8016c1
  800d44:	e8 07 f4 ff ff       	call   800150 <_panic>

00800d49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d62:	89 df                	mov    %ebx,%edi
  800d64:	89 de                	mov    %ebx,%esi
  800d66:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d68:	85 c0                	test   %eax,%eax
  800d6a:	7f 08                	jg     800d74 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 08                	push   $0x8
  800d7a:	68 a4 16 80 00       	push   $0x8016a4
  800d7f:	6a 24                	push   $0x24
  800d81:	68 c1 16 80 00       	push   $0x8016c1
  800d86:	e8 c5 f3 ff ff       	call   800150 <_panic>

00800d8b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	b8 09 00 00 00       	mov    $0x9,%eax
  800da4:	89 df                	mov    %ebx,%edi
  800da6:	89 de                	mov    %ebx,%esi
  800da8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 09                	push   $0x9
  800dbc:	68 a4 16 80 00       	push   $0x8016a4
  800dc1:	6a 24                	push   $0x24
  800dc3:	68 c1 16 80 00       	push   $0x8016c1
  800dc8:	e8 83 f3 ff ff       	call   800150 <_panic>

00800dcd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
    asm volatile("int %1\n"
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dde:	be 00 00 00 00       	mov    $0x0,%esi
  800de3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800df9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e06:	89 cb                	mov    %ecx,%ebx
  800e08:	89 cf                	mov    %ecx,%edi
  800e0a:	89 ce                	mov    %ecx,%esi
  800e0c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 0c                	push   $0xc
  800e20:	68 a4 16 80 00       	push   $0x8016a4
  800e25:	6a 24                	push   $0x24
  800e27:	68 c1 16 80 00       	push   $0x8016c1
  800e2c:	e8 1f f3 ff ff       	call   800150 <_panic>

00800e31 <pgfault>:
//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf) {
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	53                   	push   %ebx
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
//    cprintf("in pgfault,,, utf->utf_fault_va:0x%x\n", *((uintptr_t *)(utf)));

    void *addr = (void *) (utf->utf_fault_va);
  800e3b:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800e3d:	8b 40 04             	mov    0x4(%eax),%eax
    int r;

//    cprintf("addr:0x%x\terr:%d\n", addr, err);

    extern volatile pte_t uvpt[];
    if ((err & FEC_WR) != FEC_WR || ((uvpt[(uintptr_t) addr / PGSIZE] & PTE_COW) != PTE_COW)) {
  800e40:	a8 02                	test   $0x2,%al
  800e42:	74 68                	je     800eac <pgfault+0x7b>
  800e44:	89 da                	mov    %ebx,%edx
  800e46:	c1 ea 0c             	shr    $0xc,%edx
  800e49:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e50:	f6 c6 08             	test   $0x8,%dh
  800e53:	74 57                	je     800eac <pgfault+0x7b>
    // Hint:
    //   Use the read-only page table mappings at uvpt
    //   (see <inc/memlayout.h>).

    // LAB 4: Your code here.
    sys_page_alloc(0, (void *) PFTEMP, PTE_W | PTE_U | PTE_P);
  800e55:	83 ec 04             	sub    $0x4,%esp
  800e58:	6a 07                	push   $0x7
  800e5a:	68 00 f0 7f 00       	push   $0x7ff000
  800e5f:	6a 00                	push   $0x0
  800e61:	e8 1c fe ff ff       	call   800c82 <sys_page_alloc>
    memmove((void *) PFTEMP, (void *) (ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  800e66:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800e6c:	83 c4 0c             	add    $0xc,%esp
  800e6f:	68 00 10 00 00       	push   $0x1000
  800e74:	53                   	push   %ebx
  800e75:	68 00 f0 7f 00       	push   $0x7ff000
  800e7a:	e8 98 fb ff ff       	call   800a17 <memmove>

    //restore another
//    sys_page_map(0, (void *) (ROUNDDOWN(addr, PGSIZE)), 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);

    sys_page_map(0, (void *) PFTEMP, 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800e7f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e86:	53                   	push   %ebx
  800e87:	6a 00                	push   $0x0
  800e89:	68 00 f0 7f 00       	push   $0x7ff000
  800e8e:	6a 00                	push   $0x0
  800e90:	e8 30 fe ff ff       	call   800cc5 <sys_page_map>
    sys_page_unmap(0, (void *) PFTEMP);
  800e95:	83 c4 18             	add    $0x18,%esp
  800e98:	68 00 f0 7f 00       	push   $0x7ff000
  800e9d:	6a 00                	push   $0x0
  800e9f:	e8 63 fe ff ff       	call   800d07 <sys_page_unmap>

    return;
  800ea4:	83 c4 10             	add    $0x10,%esp
    //   You should make three system calls.

    // LAB 4: Your code here.

    panic("pgfault not implemented");
}
  800ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    
        cprintf("utf->utf_fault_va:0x%x\tutf->utf_err:%d\n", addr, err);
  800eac:	83 ec 04             	sub    $0x4,%esp
  800eaf:	50                   	push   %eax
  800eb0:	53                   	push   %ebx
  800eb1:	68 d0 16 80 00       	push   $0x8016d0
  800eb6:	e8 70 f3 ff ff       	call   80022b <cprintf>
        panic("pgfault is not a FEC_WR or is not to a COW page");
  800ebb:	83 c4 0c             	add    $0xc,%esp
  800ebe:	68 f8 16 80 00       	push   $0x8016f8
  800ec3:	6a 1b                	push   $0x1b
  800ec5:	68 28 17 80 00       	push   $0x801728
  800eca:	e8 81 f2 ff ff       	call   800150 <_panic>

00800ecf <fork>:
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void) {
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	83 ec 28             	sub    $0x28,%esp
    extern void* _pgfault_upcall(void);
    //1. The parent installs pgfault() as the C-level page fault handler, using the set_pgfault_handler() function you implemented above.
    set_pgfault_handler(pgfault);
  800ed8:	68 31 0e 80 00       	push   $0x800e31
  800edd:	e8 60 02 00 00       	call   801142 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ee2:	b8 07 00 00 00       	mov    $0x7,%eax
  800ee7:	cd 30                	int    $0x30
  800ee9:	89 c6                	mov    %eax,%esi
  800eeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    //2. The parent calls sys_exofork() to create a child environment.
    envid_t envid = sys_exofork();

//    cprintf("envid:0x%x\n", envid);
    if (envid == 0) {
  800eee:	83 c4 10             	add    $0x10,%esp
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	74 5e                	je     800f53 <fork+0x84>

    extern volatile pde_t uvpd[];
    extern volatile pte_t uvpt[];

    //allocate and copy a normal stack
    sys_page_alloc(envid, (void *) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  800ef5:	83 ec 04             	sub    $0x4,%esp
  800ef8:	6a 07                	push   $0x7
  800efa:	68 00 d0 bf ee       	push   $0xeebfd000
  800eff:	50                   	push   %eax
  800f00:	e8 7d fd ff ff       	call   800c82 <sys_page_alloc>
    sys_page_map(envid, (void *) (USTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  800f05:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f0c:	68 00 00 40 00       	push   $0x400000
  800f11:	6a 00                	push   $0x0
  800f13:	68 00 d0 bf ee       	push   $0xeebfd000
  800f18:	56                   	push   %esi
  800f19:	e8 a7 fd ff ff       	call   800cc5 <sys_page_map>
    memmove(UTEMP, (void *) (USTACKTOP - PGSIZE), PGSIZE);
  800f1e:	83 c4 1c             	add    $0x1c,%esp
  800f21:	68 00 10 00 00       	push   $0x1000
  800f26:	68 00 d0 bf ee       	push   $0xeebfd000
  800f2b:	68 00 00 40 00       	push   $0x400000
  800f30:	e8 e2 fa ff ff       	call   800a17 <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  800f35:	83 c4 08             	add    $0x8,%esp
  800f38:	68 00 00 40 00       	push   $0x400000
  800f3d:	6a 00                	push   $0x0
  800f3f:	e8 c3 fd ff ff       	call   800d07 <sys_page_unmap>
  800f44:	83 c4 10             	add    $0x10,%esp

    int i;

//    cprintf("COW page resolve ....\n");
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
  800f47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f51:	eb 2e                	jmp    800f81 <fork+0xb2>
        thisenv = &envs[sys_getenvid()];
  800f53:	e8 ec fc ff ff       	call   800c44 <sys_getenvid>
  800f58:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f5b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f60:	a3 04 20 80 00       	mov    %eax,0x802004
        return 0;
  800f65:	e9 4d 01 00 00       	jmp    8010b7 <fork+0x1e8>
        if (uvpd[i / NPTENTRIES] == 0) {
            i += 1023;
  800f6a:	81 c3 ff 03 00 00    	add    $0x3ff,%ebx
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
  800f70:	83 c3 01             	add    $0x1,%ebx
  800f73:	89 df                	mov    %ebx,%edi
  800f75:	81 fb fc eb 0e 00    	cmp    $0xeebfc,%ebx
  800f7b:	0f 87 cb 00 00 00    	ja     80104c <fork+0x17d>
        if (uvpd[i / NPTENTRIES] == 0) {
  800f81:	8d 83 ff 03 00 00    	lea    0x3ff(%ebx),%eax
  800f87:	85 db                	test   %ebx,%ebx
  800f89:	0f 49 c3             	cmovns %ebx,%eax
  800f8c:	c1 f8 0a             	sar    $0xa,%eax
  800f8f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f96:	85 c0                	test   %eax,%eax
  800f98:	74 d0                	je     800f6a <fork+0x9b>
            continue;
        }

        if ((uvpt[i] & PTE_P) == PTE_P) {
  800f9a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fa1:	a8 01                	test   $0x1,%al
  800fa3:	74 cb                	je     800f70 <fork+0xa1>
            if (((uvpt[i] & PTE_W) == PTE_W) || ((uvpt[i] & PTE_COW) == PTE_COW)) {
  800fa5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fac:	a8 02                	test   $0x2,%al
  800fae:	75 0c                	jne    800fbc <fork+0xed>
  800fb0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fb7:	f6 c4 08             	test   $0x8,%ah
  800fba:	74 64                	je     801020 <fork+0x151>
    if (sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800fbc:	c1 e7 0c             	shl    $0xc,%edi
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	68 05 08 00 00       	push   $0x805
  800fc7:	57                   	push   %edi
  800fc8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fcb:	57                   	push   %edi
  800fcc:	6a 00                	push   $0x0
  800fce:	e8 f2 fc ff ff       	call   800cc5 <sys_page_map>
  800fd3:	83 c4 20             	add    $0x20,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 32                	js     80100c <fork+0x13d>
    if (sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800fda:	83 ec 0c             	sub    $0xc,%esp
  800fdd:	68 05 08 00 00       	push   $0x805
  800fe2:	57                   	push   %edi
  800fe3:	6a 00                	push   $0x0
  800fe5:	57                   	push   %edi
  800fe6:	6a 00                	push   $0x0
  800fe8:	e8 d8 fc ff ff       	call   800cc5 <sys_page_map>
  800fed:	83 c4 20             	add    $0x20,%esp
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	0f 89 78 ff ff ff    	jns    800f70 <fork+0xa1>
        panic("dupppage target map error");
  800ff8:	83 ec 04             	sub    $0x4,%esp
  800ffb:	68 4e 17 80 00       	push   $0x80174e
  801000:	6a 55                	push   $0x55
  801002:	68 28 17 80 00       	push   $0x801728
  801007:	e8 44 f1 ff ff       	call   800150 <_panic>
        panic("dupppage our own map error");
  80100c:	83 ec 04             	sub    $0x4,%esp
  80100f:	68 33 17 80 00       	push   $0x801733
  801014:	6a 4b                	push   $0x4b
  801016:	68 28 17 80 00       	push   $0x801728
  80101b:	e8 30 f1 ff ff       	call   800150 <_panic>
                duppage(envid, i);
            } else {
                sys_page_map(0, (void *) (i * PGSIZE), envid, (void *) (i * PGSIZE), PTE_SHARE | (uvpt[i] & 0x3ff));
  801020:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801027:	89 da                	mov    %ebx,%edx
  801029:	c1 e2 0c             	shl    $0xc,%edx
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801034:	80 cc 04             	or     $0x4,%ah
  801037:	50                   	push   %eax
  801038:	52                   	push   %edx
  801039:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103c:	52                   	push   %edx
  80103d:	6a 00                	push   $0x0
  80103f:	e8 81 fc ff ff       	call   800cc5 <sys_page_map>
  801044:	83 c4 20             	add    $0x20,%esp
  801047:	e9 24 ff ff ff       	jmp    800f70 <fork+0xa1>
            }
        }
    }

//    cprintf("allocate child ExceptionStack ....\n");
    sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80104c:	83 ec 04             	sub    $0x4,%esp
  80104f:	6a 07                	push   $0x7
  801051:	68 00 f0 bf ee       	push   $0xeebff000
  801056:	56                   	push   %esi
  801057:	e8 26 fc ff ff       	call   800c82 <sys_page_alloc>
    sys_page_map(envid, (void *) (UXSTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  80105c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801063:	68 00 00 40 00       	push   $0x400000
  801068:	6a 00                	push   $0x0
  80106a:	68 00 f0 bf ee       	push   $0xeebff000
  80106f:	56                   	push   %esi
  801070:	e8 50 fc ff ff       	call   800cc5 <sys_page_map>
    memmove(UTEMP, (void *) (UXSTACKTOP - PGSIZE), PGSIZE);
  801075:	83 c4 1c             	add    $0x1c,%esp
  801078:	68 00 10 00 00       	push   $0x1000
  80107d:	68 00 f0 bf ee       	push   $0xeebff000
  801082:	68 00 00 40 00       	push   $0x400000
  801087:	e8 8b f9 ff ff       	call   800a17 <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  80108c:	83 c4 08             	add    $0x8,%esp
  80108f:	68 00 00 40 00       	push   $0x400000
  801094:	6a 00                	push   $0x0
  801096:	e8 6c fc ff ff       	call   800d07 <sys_page_unmap>

    //4. The parent sets the user page fault entrypoint for the child to look like its own.
//    set_pgfault_handler(pgfault);
//    cprintf("sys_env_set_pgfault_upcall(envid, pgfault) ....\n");
//    sys_env_set_pgfault_upcall(envid, pgfault);
    sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80109b:	83 c4 08             	add    $0x8,%esp
  80109e:	68 98 11 80 00       	push   $0x801198
  8010a3:	56                   	push   %esi
  8010a4:	e8 e2 fc ff ff       	call   800d8b <sys_env_set_pgfault_upcall>

    //5. The child is now ready to run, so the parent marks it runnable.
//    cprintf("sys_env_set_status(envid, ENV_RUNNABLE) ....\n");
    sys_env_set_status(envid, ENV_RUNNABLE);
  8010a9:	83 c4 08             	add    $0x8,%esp
  8010ac:	6a 02                	push   $0x2
  8010ae:	56                   	push   %esi
  8010af:	e8 95 fc ff ff       	call   800d49 <sys_env_set_status>


    return envid;
  8010b4:	83 c4 10             	add    $0x10,%esp
    panic("fork not implemented");
}
  8010b7:	89 f0                	mov    %esi,%eax
  8010b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <sfork>:

// Challenge!
int
sfork(void) {
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 0c             	sub    $0xc,%esp
    panic("sfork not implemented");
  8010c7:	68 68 17 80 00       	push   $0x801768
  8010cc:	68 bf 00 00 00       	push   $0xbf
  8010d1:	68 28 17 80 00       	push   $0x801728
  8010d6:	e8 75 f0 ff ff       	call   800150 <_panic>

008010db <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  8010e1:	68 7e 17 80 00       	push   $0x80177e
  8010e6:	6a 1a                	push   $0x1a
  8010e8:	68 97 17 80 00       	push   $0x801797
  8010ed:	e8 5e f0 ff ff       	call   800150 <_panic>

008010f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8010f8:	68 a1 17 80 00       	push   $0x8017a1
  8010fd:	6a 2a                	push   $0x2a
  8010ff:	68 97 17 80 00       	push   $0x801797
  801104:	e8 47 f0 ff ff       	call   800150 <_panic>

00801109 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801114:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801117:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80111d:	8b 52 50             	mov    0x50(%edx),%edx
  801120:	39 ca                	cmp    %ecx,%edx
  801122:	74 11                	je     801135 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801124:	83 c0 01             	add    $0x1,%eax
  801127:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112c:	75 e6                	jne    801114 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80112e:	b8 00 00 00 00       	mov    $0x0,%eax
  801133:	eb 0b                	jmp    801140 <ipc_find_env+0x37>
			return envs[i].env_id;
  801135:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801138:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80113d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    

00801142 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801148:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80114f:	74 0a                	je     80115b <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  80115b:	a1 04 20 80 00       	mov    0x802004,%eax
  801160:	8b 40 48             	mov    0x48(%eax),%eax
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	6a 07                	push   $0x7
  801168:	68 00 f0 bf ee       	push   $0xeebff000
  80116d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801172:	50                   	push   %eax
  801173:	e8 0a fb ff ff       	call   800c82 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  801178:	a1 04 20 80 00       	mov    0x802004,%eax
  80117d:	8b 40 48             	mov    0x48(%eax),%eax
  801180:	83 c4 08             	add    $0x8,%esp
  801183:	68 98 11 80 00       	push   $0x801198
  801188:	25 ff 03 00 00       	and    $0x3ff,%eax
  80118d:	50                   	push   %eax
  80118e:	e8 f8 fb ff ff       	call   800d8b <sys_env_set_pgfault_upcall>
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	eb b9                	jmp    801151 <set_pgfault_handler+0xf>

00801198 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801198:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801199:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80119e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011a0:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  8011a3:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  8011a7:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  8011ab:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  8011ae:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  8011b0:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  8011b4:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  8011b7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  8011b8:	83 c4 04             	add    $0x4,%esp
    popfl
  8011bb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  8011bc:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8011bd:	c3                   	ret    
  8011be:	66 90                	xchg   %ax,%ax

008011c0 <__udivdi3>:
  8011c0:	55                   	push   %ebp
  8011c1:	57                   	push   %edi
  8011c2:	56                   	push   %esi
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 1c             	sub    $0x1c,%esp
  8011c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8011cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8011cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8011d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 35                	jne    801210 <__udivdi3+0x50>
  8011db:	39 f3                	cmp    %esi,%ebx
  8011dd:	0f 87 bd 00 00 00    	ja     8012a0 <__udivdi3+0xe0>
  8011e3:	85 db                	test   %ebx,%ebx
  8011e5:	89 d9                	mov    %ebx,%ecx
  8011e7:	75 0b                	jne    8011f4 <__udivdi3+0x34>
  8011e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011ee:	31 d2                	xor    %edx,%edx
  8011f0:	f7 f3                	div    %ebx
  8011f2:	89 c1                	mov    %eax,%ecx
  8011f4:	31 d2                	xor    %edx,%edx
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	f7 f1                	div    %ecx
  8011fa:	89 c6                	mov    %eax,%esi
  8011fc:	89 e8                	mov    %ebp,%eax
  8011fe:	89 f7                	mov    %esi,%edi
  801200:	f7 f1                	div    %ecx
  801202:	89 fa                	mov    %edi,%edx
  801204:	83 c4 1c             	add    $0x1c,%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    
  80120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801210:	39 f2                	cmp    %esi,%edx
  801212:	77 7c                	ja     801290 <__udivdi3+0xd0>
  801214:	0f bd fa             	bsr    %edx,%edi
  801217:	83 f7 1f             	xor    $0x1f,%edi
  80121a:	0f 84 98 00 00 00    	je     8012b8 <__udivdi3+0xf8>
  801220:	89 f9                	mov    %edi,%ecx
  801222:	b8 20 00 00 00       	mov    $0x20,%eax
  801227:	29 f8                	sub    %edi,%eax
  801229:	d3 e2                	shl    %cl,%edx
  80122b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80122f:	89 c1                	mov    %eax,%ecx
  801231:	89 da                	mov    %ebx,%edx
  801233:	d3 ea                	shr    %cl,%edx
  801235:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801239:	09 d1                	or     %edx,%ecx
  80123b:	89 f2                	mov    %esi,%edx
  80123d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801241:	89 f9                	mov    %edi,%ecx
  801243:	d3 e3                	shl    %cl,%ebx
  801245:	89 c1                	mov    %eax,%ecx
  801247:	d3 ea                	shr    %cl,%edx
  801249:	89 f9                	mov    %edi,%ecx
  80124b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80124f:	d3 e6                	shl    %cl,%esi
  801251:	89 eb                	mov    %ebp,%ebx
  801253:	89 c1                	mov    %eax,%ecx
  801255:	d3 eb                	shr    %cl,%ebx
  801257:	09 de                	or     %ebx,%esi
  801259:	89 f0                	mov    %esi,%eax
  80125b:	f7 74 24 08          	divl   0x8(%esp)
  80125f:	89 d6                	mov    %edx,%esi
  801261:	89 c3                	mov    %eax,%ebx
  801263:	f7 64 24 0c          	mull   0xc(%esp)
  801267:	39 d6                	cmp    %edx,%esi
  801269:	72 0c                	jb     801277 <__udivdi3+0xb7>
  80126b:	89 f9                	mov    %edi,%ecx
  80126d:	d3 e5                	shl    %cl,%ebp
  80126f:	39 c5                	cmp    %eax,%ebp
  801271:	73 5d                	jae    8012d0 <__udivdi3+0x110>
  801273:	39 d6                	cmp    %edx,%esi
  801275:	75 59                	jne    8012d0 <__udivdi3+0x110>
  801277:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80127a:	31 ff                	xor    %edi,%edi
  80127c:	89 fa                	mov    %edi,%edx
  80127e:	83 c4 1c             	add    $0x1c,%esp
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    
  801286:	8d 76 00             	lea    0x0(%esi),%esi
  801289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801290:	31 ff                	xor    %edi,%edi
  801292:	31 c0                	xor    %eax,%eax
  801294:	89 fa                	mov    %edi,%edx
  801296:	83 c4 1c             	add    $0x1c,%esp
  801299:	5b                   	pop    %ebx
  80129a:	5e                   	pop    %esi
  80129b:	5f                   	pop    %edi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    
  80129e:	66 90                	xchg   %ax,%ax
  8012a0:	31 ff                	xor    %edi,%edi
  8012a2:	89 e8                	mov    %ebp,%eax
  8012a4:	89 f2                	mov    %esi,%edx
  8012a6:	f7 f3                	div    %ebx
  8012a8:	89 fa                	mov    %edi,%edx
  8012aa:	83 c4 1c             	add    $0x1c,%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
  8012b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012b8:	39 f2                	cmp    %esi,%edx
  8012ba:	72 06                	jb     8012c2 <__udivdi3+0x102>
  8012bc:	31 c0                	xor    %eax,%eax
  8012be:	39 eb                	cmp    %ebp,%ebx
  8012c0:	77 d2                	ja     801294 <__udivdi3+0xd4>
  8012c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8012c7:	eb cb                	jmp    801294 <__udivdi3+0xd4>
  8012c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012d0:	89 d8                	mov    %ebx,%eax
  8012d2:	31 ff                	xor    %edi,%edi
  8012d4:	eb be                	jmp    801294 <__udivdi3+0xd4>
  8012d6:	66 90                	xchg   %ax,%ax
  8012d8:	66 90                	xchg   %ax,%ax
  8012da:	66 90                	xchg   %ax,%ax
  8012dc:	66 90                	xchg   %ax,%ax
  8012de:	66 90                	xchg   %ax,%ax

008012e0 <__umoddi3>:
  8012e0:	55                   	push   %ebp
  8012e1:	57                   	push   %edi
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 1c             	sub    $0x1c,%esp
  8012e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8012eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8012ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8012f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8012f7:	85 ed                	test   %ebp,%ebp
  8012f9:	89 f0                	mov    %esi,%eax
  8012fb:	89 da                	mov    %ebx,%edx
  8012fd:	75 19                	jne    801318 <__umoddi3+0x38>
  8012ff:	39 df                	cmp    %ebx,%edi
  801301:	0f 86 b1 00 00 00    	jbe    8013b8 <__umoddi3+0xd8>
  801307:	f7 f7                	div    %edi
  801309:	89 d0                	mov    %edx,%eax
  80130b:	31 d2                	xor    %edx,%edx
  80130d:	83 c4 1c             	add    $0x1c,%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5f                   	pop    %edi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
  801315:	8d 76 00             	lea    0x0(%esi),%esi
  801318:	39 dd                	cmp    %ebx,%ebp
  80131a:	77 f1                	ja     80130d <__umoddi3+0x2d>
  80131c:	0f bd cd             	bsr    %ebp,%ecx
  80131f:	83 f1 1f             	xor    $0x1f,%ecx
  801322:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801326:	0f 84 b4 00 00 00    	je     8013e0 <__umoddi3+0x100>
  80132c:	b8 20 00 00 00       	mov    $0x20,%eax
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 44 24 04          	mov    0x4(%esp),%eax
  801337:	29 c2                	sub    %eax,%edx
  801339:	89 c1                	mov    %eax,%ecx
  80133b:	89 f8                	mov    %edi,%eax
  80133d:	d3 e5                	shl    %cl,%ebp
  80133f:	89 d1                	mov    %edx,%ecx
  801341:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801345:	d3 e8                	shr    %cl,%eax
  801347:	09 c5                	or     %eax,%ebp
  801349:	8b 44 24 04          	mov    0x4(%esp),%eax
  80134d:	89 c1                	mov    %eax,%ecx
  80134f:	d3 e7                	shl    %cl,%edi
  801351:	89 d1                	mov    %edx,%ecx
  801353:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801357:	89 df                	mov    %ebx,%edi
  801359:	d3 ef                	shr    %cl,%edi
  80135b:	89 c1                	mov    %eax,%ecx
  80135d:	89 f0                	mov    %esi,%eax
  80135f:	d3 e3                	shl    %cl,%ebx
  801361:	89 d1                	mov    %edx,%ecx
  801363:	89 fa                	mov    %edi,%edx
  801365:	d3 e8                	shr    %cl,%eax
  801367:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80136c:	09 d8                	or     %ebx,%eax
  80136e:	f7 f5                	div    %ebp
  801370:	d3 e6                	shl    %cl,%esi
  801372:	89 d1                	mov    %edx,%ecx
  801374:	f7 64 24 08          	mull   0x8(%esp)
  801378:	39 d1                	cmp    %edx,%ecx
  80137a:	89 c3                	mov    %eax,%ebx
  80137c:	89 d7                	mov    %edx,%edi
  80137e:	72 06                	jb     801386 <__umoddi3+0xa6>
  801380:	75 0e                	jne    801390 <__umoddi3+0xb0>
  801382:	39 c6                	cmp    %eax,%esi
  801384:	73 0a                	jae    801390 <__umoddi3+0xb0>
  801386:	2b 44 24 08          	sub    0x8(%esp),%eax
  80138a:	19 ea                	sbb    %ebp,%edx
  80138c:	89 d7                	mov    %edx,%edi
  80138e:	89 c3                	mov    %eax,%ebx
  801390:	89 ca                	mov    %ecx,%edx
  801392:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801397:	29 de                	sub    %ebx,%esi
  801399:	19 fa                	sbb    %edi,%edx
  80139b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80139f:	89 d0                	mov    %edx,%eax
  8013a1:	d3 e0                	shl    %cl,%eax
  8013a3:	89 d9                	mov    %ebx,%ecx
  8013a5:	d3 ee                	shr    %cl,%esi
  8013a7:	d3 ea                	shr    %cl,%edx
  8013a9:	09 f0                	or     %esi,%eax
  8013ab:	83 c4 1c             	add    $0x1c,%esp
  8013ae:	5b                   	pop    %ebx
  8013af:	5e                   	pop    %esi
  8013b0:	5f                   	pop    %edi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    
  8013b3:	90                   	nop
  8013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013b8:	85 ff                	test   %edi,%edi
  8013ba:	89 f9                	mov    %edi,%ecx
  8013bc:	75 0b                	jne    8013c9 <__umoddi3+0xe9>
  8013be:	b8 01 00 00 00       	mov    $0x1,%eax
  8013c3:	31 d2                	xor    %edx,%edx
  8013c5:	f7 f7                	div    %edi
  8013c7:	89 c1                	mov    %eax,%ecx
  8013c9:	89 d8                	mov    %ebx,%eax
  8013cb:	31 d2                	xor    %edx,%edx
  8013cd:	f7 f1                	div    %ecx
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	f7 f1                	div    %ecx
  8013d3:	e9 31 ff ff ff       	jmp    801309 <__umoddi3+0x29>
  8013d8:	90                   	nop
  8013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8013e0:	39 dd                	cmp    %ebx,%ebp
  8013e2:	72 08                	jb     8013ec <__umoddi3+0x10c>
  8013e4:	39 f7                	cmp    %esi,%edi
  8013e6:	0f 87 21 ff ff ff    	ja     80130d <__umoddi3+0x2d>
  8013ec:	89 da                	mov    %ebx,%edx
  8013ee:	89 f0                	mov    %esi,%eax
  8013f0:	29 f8                	sub    %edi,%eax
  8013f2:	19 ea                	sbb    %ebp,%edx
  8013f4:	e9 14 ff ff ff       	jmp    80130d <__umoddi3+0x2d>
