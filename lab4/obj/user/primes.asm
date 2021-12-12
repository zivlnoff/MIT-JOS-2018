
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
  800047:	e8 03 0e 00 00       	call   800e4f <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 00 11 80 00       	push   $0x801100
  800060:	e8 b6 01 00 00       	call   80021b <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 b7 0d 00 00       	call   800e21 <fork>
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
  800082:	e8 c8 0d 00 00       	call   800e4f <ipc_recv>
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
  800099:	e8 c8 0d 00 00       	call   800e66 <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 0c 11 80 00       	push   $0x80110c
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 15 11 80 00       	push   $0x801115
  8000b0:	e8 8b 00 00 00       	call   800140 <_panic>

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
  8000ba:	e8 62 0d 00 00       	call   800e21 <fork>
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
  8000d4:	e8 8d 0d 00 00       	call   800e66 <ipc_send>
	for (i = 2; ; i++)
  8000d9:	83 c3 01             	add    $0x1,%ebx
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	eb ed                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000e1:	50                   	push   %eax
  8000e2:	68 0c 11 80 00       	push   $0x80110c
  8000e7:	6a 2d                	push   $0x2d
  8000e9:	68 15 11 80 00       	push   $0x801115
  8000ee:	e8 4d 00 00 00       	call   800140 <_panic>
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
  8000fb:	83 ec 08             	sub    $0x8,%esp
  8000fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800101:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800104:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  80010b:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	7e 08                	jle    80011a <libmain+0x22>
		binaryname = argv[0];
  800112:	8b 0a                	mov    (%edx),%ecx
  800114:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  80011a:	83 ec 08             	sub    $0x8,%esp
  80011d:	52                   	push   %edx
  80011e:	50                   	push   %eax
  80011f:	e8 91 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  800124:	e8 05 00 00 00       	call   80012e <exit>
}
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	c9                   	leave  
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800134:	6a 00                	push   $0x0
  800136:	e8 b8 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    

00800140 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800145:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800148:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80014e:	e8 e1 0a 00 00       	call   800c34 <sys_getenvid>
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	56                   	push   %esi
  80015d:	50                   	push   %eax
  80015e:	68 30 11 80 00       	push   $0x801130
  800163:	e8 b3 00 00 00       	call   80021b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800168:	83 c4 18             	add    $0x18,%esp
  80016b:	53                   	push   %ebx
  80016c:	ff 75 10             	pushl  0x10(%ebp)
  80016f:	e8 56 00 00 00       	call   8001ca <vcprintf>
	cprintf("\n");
  800174:	c7 04 24 54 11 80 00 	movl   $0x801154,(%esp)
  80017b:	e8 9b 00 00 00       	call   80021b <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800183:	cc                   	int3   
  800184:	eb fd                	jmp    800183 <_panic+0x43>

00800186 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	53                   	push   %ebx
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800190:	8b 13                	mov    (%ebx),%edx
  800192:	8d 42 01             	lea    0x1(%edx),%eax
  800195:	89 03                	mov    %eax,(%ebx)
  800197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a3:	74 09                	je     8001ae <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	68 ff 00 00 00       	push   $0xff
  8001b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 f7 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	eb db                	jmp    8001a5 <putch+0x1f>

008001ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001da:	00 00 00 
	b.cnt = 0;
  8001dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ea:	ff 75 08             	pushl  0x8(%ebp)
  8001ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f3:	50                   	push   %eax
  8001f4:	68 86 01 80 00       	push   $0x800186
  8001f9:	e8 1a 01 00 00       	call   800318 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fe:	83 c4 08             	add    $0x8,%esp
  800201:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800207:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 a3 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  800213:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800219:	c9                   	leave  
  80021a:	c3                   	ret    

0080021b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800221:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800224:	50                   	push   %eax
  800225:	ff 75 08             	pushl  0x8(%ebp)
  800228:	e8 9d ff ff ff       	call   8001ca <vcprintf>
	va_end(ap);

	return cnt;
}
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 1c             	sub    $0x1c,%esp
  800238:	89 c7                	mov    %eax,%edi
  80023a:	89 d6                	mov    %edx,%esi
  80023c:	8b 45 08             	mov    0x8(%ebp),%eax
  80023f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800242:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800245:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800248:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80024b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800250:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800253:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800256:	39 d3                	cmp    %edx,%ebx
  800258:	72 05                	jb     80025f <printnum+0x30>
  80025a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80025d:	77 7a                	ja     8002d9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	ff 75 18             	pushl  0x18(%ebp)
  800265:	8b 45 14             	mov    0x14(%ebp),%eax
  800268:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80026b:	53                   	push   %ebx
  80026c:	ff 75 10             	pushl  0x10(%ebp)
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	ff 75 e4             	pushl  -0x1c(%ebp)
  800275:	ff 75 e0             	pushl  -0x20(%ebp)
  800278:	ff 75 dc             	pushl  -0x24(%ebp)
  80027b:	ff 75 d8             	pushl  -0x28(%ebp)
  80027e:	e8 3d 0c 00 00       	call   800ec0 <__udivdi3>
  800283:	83 c4 18             	add    $0x18,%esp
  800286:	52                   	push   %edx
  800287:	50                   	push   %eax
  800288:	89 f2                	mov    %esi,%edx
  80028a:	89 f8                	mov    %edi,%eax
  80028c:	e8 9e ff ff ff       	call   80022f <printnum>
  800291:	83 c4 20             	add    $0x20,%esp
  800294:	eb 13                	jmp    8002a9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	56                   	push   %esi
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	ff d7                	call   *%edi
  80029f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002a2:	83 eb 01             	sub    $0x1,%ebx
  8002a5:	85 db                	test   %ebx,%ebx
  8002a7:	7f ed                	jg     800296 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	56                   	push   %esi
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bc:	e8 1f 0d 00 00       	call   800fe0 <__umoddi3>
  8002c1:	83 c4 14             	add    $0x14,%esp
  8002c4:	0f be 80 56 11 80 00 	movsbl 0x801156(%eax),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff d7                	call   *%edi
}
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    
  8002d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002dc:	eb c4                	jmp    8002a2 <printnum+0x73>

008002de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e8:	8b 10                	mov    (%eax),%edx
  8002ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ed:	73 0a                	jae    8002f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	88 02                	mov    %al,(%edx)
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <printfmt>:
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800301:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800304:	50                   	push   %eax
  800305:	ff 75 10             	pushl  0x10(%ebp)
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	e8 05 00 00 00       	call   800318 <vprintfmt>
}
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <vprintfmt>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 2c             	sub    $0x2c,%esp
  800321:	8b 75 08             	mov    0x8(%ebp),%esi
  800324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800327:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032a:	e9 00 04 00 00       	jmp    80072f <vprintfmt+0x417>
		padc = ' ';
  80032f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800333:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80033a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800341:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800348:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8d 47 01             	lea    0x1(%edi),%eax
  800350:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800353:	0f b6 17             	movzbl (%edi),%edx
  800356:	8d 42 dd             	lea    -0x23(%edx),%eax
  800359:	3c 55                	cmp    $0x55,%al
  80035b:	0f 87 51 04 00 00    	ja     8007b2 <vprintfmt+0x49a>
  800361:	0f b6 c0             	movzbl %al,%eax
  800364:	ff 24 85 20 12 80 00 	jmp    *0x801220(,%eax,4)
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800372:	eb d9                	jmp    80034d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800377:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80037b:	eb d0                	jmp    80034d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	0f b6 d2             	movzbl %dl,%edx
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800383:	b8 00 00 00 00       	mov    $0x0,%eax
  800388:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80038b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800392:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800395:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800398:	83 f9 09             	cmp    $0x9,%ecx
  80039b:	77 55                	ja     8003f2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80039d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a0:	eb e9                	jmp    80038b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8d 40 04             	lea    0x4(%eax),%eax
  8003b0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ba:	79 91                	jns    80034d <vprintfmt+0x35>
				width = precision, precision = -1;
  8003bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c9:	eb 82                	jmp    80034d <vprintfmt+0x35>
  8003cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d5:	0f 49 d0             	cmovns %eax,%edx
  8003d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003de:	e9 6a ff ff ff       	jmp    80034d <vprintfmt+0x35>
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ed:	e9 5b ff ff ff       	jmp    80034d <vprintfmt+0x35>
  8003f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f8:	eb bc                	jmp    8003b6 <vprintfmt+0x9e>
			lflag++;
  8003fa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800400:	e9 48 ff ff ff       	jmp    80034d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8d 78 04             	lea    0x4(%eax),%edi
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	53                   	push   %ebx
  80040f:	ff 30                	pushl  (%eax)
  800411:	ff d6                	call   *%esi
			break;
  800413:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800416:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800419:	e9 0e 03 00 00       	jmp    80072c <vprintfmt+0x414>
			err = va_arg(ap, int);
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 78 04             	lea    0x4(%eax),%edi
  800424:	8b 00                	mov    (%eax),%eax
  800426:	99                   	cltd   
  800427:	31 d0                	xor    %edx,%eax
  800429:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042b:	83 f8 08             	cmp    $0x8,%eax
  80042e:	7f 23                	jg     800453 <vprintfmt+0x13b>
  800430:	8b 14 85 80 13 80 00 	mov    0x801380(,%eax,4),%edx
  800437:	85 d2                	test   %edx,%edx
  800439:	74 18                	je     800453 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80043b:	52                   	push   %edx
  80043c:	68 77 11 80 00       	push   $0x801177
  800441:	53                   	push   %ebx
  800442:	56                   	push   %esi
  800443:	e8 b3 fe ff ff       	call   8002fb <printfmt>
  800448:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044e:	e9 d9 02 00 00       	jmp    80072c <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800453:	50                   	push   %eax
  800454:	68 6e 11 80 00       	push   $0x80116e
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 9b fe ff ff       	call   8002fb <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800466:	e9 c1 02 00 00       	jmp    80072c <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	83 c0 04             	add    $0x4,%eax
  800471:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800479:	85 ff                	test   %edi,%edi
  80047b:	b8 67 11 80 00       	mov    $0x801167,%eax
  800480:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800483:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800487:	0f 8e bd 00 00 00    	jle    80054a <vprintfmt+0x232>
  80048d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800491:	75 0e                	jne    8004a1 <vprintfmt+0x189>
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800499:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80049c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049f:	eb 6d                	jmp    80050e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a7:	57                   	push   %edi
  8004a8:	e8 ad 03 00 00       	call   80085a <strnlen>
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 c1                	sub    %eax,%ecx
  8004b2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004c2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	eb 0f                	jmp    8004d5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	83 ef 01             	sub    $0x1,%edi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	85 ff                	test   %edi,%edi
  8004d7:	7f ed                	jg     8004c6 <vprintfmt+0x1ae>
  8004d9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004dc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004df:	85 c9                	test   %ecx,%ecx
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	0f 49 c1             	cmovns %ecx,%eax
  8004e9:	29 c1                	sub    %eax,%ecx
  8004eb:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ee:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f4:	89 cb                	mov    %ecx,%ebx
  8004f6:	eb 16                	jmp    80050e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fc:	75 31                	jne    80052f <vprintfmt+0x217>
					putch(ch, putdat);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 0c             	pushl  0xc(%ebp)
  800504:	50                   	push   %eax
  800505:	ff 55 08             	call   *0x8(%ebp)
  800508:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050b:	83 eb 01             	sub    $0x1,%ebx
  80050e:	83 c7 01             	add    $0x1,%edi
  800511:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800515:	0f be c2             	movsbl %dl,%eax
  800518:	85 c0                	test   %eax,%eax
  80051a:	74 59                	je     800575 <vprintfmt+0x25d>
  80051c:	85 f6                	test   %esi,%esi
  80051e:	78 d8                	js     8004f8 <vprintfmt+0x1e0>
  800520:	83 ee 01             	sub    $0x1,%esi
  800523:	79 d3                	jns    8004f8 <vprintfmt+0x1e0>
  800525:	89 df                	mov    %ebx,%edi
  800527:	8b 75 08             	mov    0x8(%ebp),%esi
  80052a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052d:	eb 37                	jmp    800566 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80052f:	0f be d2             	movsbl %dl,%edx
  800532:	83 ea 20             	sub    $0x20,%edx
  800535:	83 fa 5e             	cmp    $0x5e,%edx
  800538:	76 c4                	jbe    8004fe <vprintfmt+0x1e6>
					putch('?', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 0c             	pushl  0xc(%ebp)
  800540:	6a 3f                	push   $0x3f
  800542:	ff 55 08             	call   *0x8(%ebp)
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb c1                	jmp    80050b <vprintfmt+0x1f3>
  80054a:	89 75 08             	mov    %esi,0x8(%ebp)
  80054d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800550:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800553:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800556:	eb b6                	jmp    80050e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	6a 20                	push   $0x20
  80055e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800560:	83 ef 01             	sub    $0x1,%edi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	85 ff                	test   %edi,%edi
  800568:	7f ee                	jg     800558 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80056a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	e9 b7 01 00 00       	jmp    80072c <vprintfmt+0x414>
  800575:	89 df                	mov    %ebx,%edi
  800577:	8b 75 08             	mov    0x8(%ebp),%esi
  80057a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057d:	eb e7                	jmp    800566 <vprintfmt+0x24e>
	if (lflag >= 2)
  80057f:	83 f9 01             	cmp    $0x1,%ecx
  800582:	7e 3f                	jle    8005c3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 50 04             	mov    0x4(%eax),%edx
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059f:	79 5c                	jns    8005fd <vprintfmt+0x2e5>
				putch('-', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	6a 2d                	push   $0x2d
  8005a7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005af:	f7 da                	neg    %edx
  8005b1:	83 d1 00             	adc    $0x0,%ecx
  8005b4:	f7 d9                	neg    %ecx
  8005b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005be:	e9 4f 01 00 00       	jmp    800712 <vprintfmt+0x3fa>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	75 1b                	jne    8005e2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 c1                	mov    %eax,%ecx
  8005d1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	eb b9                	jmp    80059b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ea:	89 c1                	mov    %eax,%ecx
  8005ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fb:	eb 9e                	jmp    80059b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800600:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
  800608:	e9 05 01 00 00       	jmp    800712 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80060d:	83 f9 01             	cmp    $0x1,%ecx
  800610:	7e 18                	jle    80062a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 48 04             	mov    0x4(%eax),%ecx
  80061a:	8d 40 08             	lea    0x8(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	e9 e8 00 00 00       	jmp    800712 <vprintfmt+0x3fa>
	else if (lflag)
  80062a:	85 c9                	test   %ecx,%ecx
  80062c:	75 1a                	jne    800648 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 10                	mov    (%eax),%edx
  800633:	b9 00 00 00 00       	mov    $0x0,%ecx
  800638:	8d 40 04             	lea    0x4(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800643:	e9 ca 00 00 00       	jmp    800712 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 10                	mov    (%eax),%edx
  80064d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065d:	e9 b0 00 00 00       	jmp    800712 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800662:	83 f9 01             	cmp    $0x1,%ecx
  800665:	7e 3c                	jle    8006a3 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 50 04             	mov    0x4(%eax),%edx
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 08             	lea    0x8(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80067e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800682:	79 59                	jns    8006dd <vprintfmt+0x3c5>
                putch('-', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	53                   	push   %ebx
  800688:	6a 2d                	push   $0x2d
  80068a:	ff d6                	call   *%esi
                num = -(long long) num;
  80068c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80068f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800692:	f7 da                	neg    %edx
  800694:	83 d1 00             	adc    $0x0,%ecx
  800697:	f7 d9                	neg    %ecx
  800699:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80069c:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a1:	eb 6f                	jmp    800712 <vprintfmt+0x3fa>
	else if (lflag)
  8006a3:	85 c9                	test   %ecx,%ecx
  8006a5:	75 1b                	jne    8006c2 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006af:	89 c1                	mov    %eax,%ecx
  8006b1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c0:	eb bc                	jmp    80067e <vprintfmt+0x366>
		return va_arg(*ap, long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006cf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006db:	eb a1                	jmp    80067e <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8006dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006e0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8006e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e8:	eb 28                	jmp    800712 <vprintfmt+0x3fa>
			putch('0', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 30                	push   $0x30
  8006f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f2:	83 c4 08             	add    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 78                	push   $0x78
  8006f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 10                	mov    (%eax),%edx
  8006ff:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800704:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800712:	83 ec 0c             	sub    $0xc,%esp
  800715:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800719:	57                   	push   %edi
  80071a:	ff 75 e0             	pushl  -0x20(%ebp)
  80071d:	50                   	push   %eax
  80071e:	51                   	push   %ecx
  80071f:	52                   	push   %edx
  800720:	89 da                	mov    %ebx,%edx
  800722:	89 f0                	mov    %esi,%eax
  800724:	e8 06 fb ff ff       	call   80022f <printnum>
			break;
  800729:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80072c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072f:	83 c7 01             	add    $0x1,%edi
  800732:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800736:	83 f8 25             	cmp    $0x25,%eax
  800739:	0f 84 f0 fb ff ff    	je     80032f <vprintfmt+0x17>
			if (ch == '\0')
  80073f:	85 c0                	test   %eax,%eax
  800741:	0f 84 8b 00 00 00    	je     8007d2 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	53                   	push   %ebx
  80074b:	50                   	push   %eax
  80074c:	ff d6                	call   *%esi
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	eb dc                	jmp    80072f <vprintfmt+0x417>
	if (lflag >= 2)
  800753:	83 f9 01             	cmp    $0x1,%ecx
  800756:	7e 15                	jle    80076d <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	8b 48 04             	mov    0x4(%eax),%ecx
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800766:	b8 10 00 00 00       	mov    $0x10,%eax
  80076b:	eb a5                	jmp    800712 <vprintfmt+0x3fa>
	else if (lflag)
  80076d:	85 c9                	test   %ecx,%ecx
  80076f:	75 17                	jne    800788 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 10                	mov    (%eax),%edx
  800776:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077b:	8d 40 04             	lea    0x4(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800781:	b8 10 00 00 00       	mov    $0x10,%eax
  800786:	eb 8a                	jmp    800712 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 10                	mov    (%eax),%edx
  80078d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800798:	b8 10 00 00 00       	mov    $0x10,%eax
  80079d:	e9 70 ff ff ff       	jmp    800712 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	53                   	push   %ebx
  8007a6:	6a 25                	push   $0x25
  8007a8:	ff d6                	call   *%esi
			break;
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	e9 7a ff ff ff       	jmp    80072c <vprintfmt+0x414>
			putch('%', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 25                	push   $0x25
  8007b8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 f8                	mov    %edi,%eax
  8007bf:	eb 03                	jmp    8007c4 <vprintfmt+0x4ac>
  8007c1:	83 e8 01             	sub    $0x1,%eax
  8007c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c8:	75 f7                	jne    8007c1 <vprintfmt+0x4a9>
  8007ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007cd:	e9 5a ff ff ff       	jmp    80072c <vprintfmt+0x414>
}
  8007d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d5:	5b                   	pop    %ebx
  8007d6:	5e                   	pop    %esi
  8007d7:	5f                   	pop    %edi
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	83 ec 18             	sub    $0x18,%esp
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ed:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f7:	85 c0                	test   %eax,%eax
  8007f9:	74 26                	je     800821 <vsnprintf+0x47>
  8007fb:	85 d2                	test   %edx,%edx
  8007fd:	7e 22                	jle    800821 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ff:	ff 75 14             	pushl  0x14(%ebp)
  800802:	ff 75 10             	pushl  0x10(%ebp)
  800805:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800808:	50                   	push   %eax
  800809:	68 de 02 80 00       	push   $0x8002de
  80080e:	e8 05 fb ff ff       	call   800318 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800816:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80081c:	83 c4 10             	add    $0x10,%esp
}
  80081f:	c9                   	leave  
  800820:	c3                   	ret    
		return -E_INVAL;
  800821:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800826:	eb f7                	jmp    80081f <vsnprintf+0x45>

00800828 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80082e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800831:	50                   	push   %eax
  800832:	ff 75 10             	pushl  0x10(%ebp)
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 9a ff ff ff       	call   8007da <vsnprintf>
	va_end(ap);

	return rc;
}
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800848:	b8 00 00 00 00       	mov    $0x0,%eax
  80084d:	eb 03                	jmp    800852 <strlen+0x10>
		n++;
  80084f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800852:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800856:	75 f7                	jne    80084f <strlen+0xd>
	return n;
}
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	eb 03                	jmp    80086d <strnlen+0x13>
		n++;
  80086a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086d:	39 d0                	cmp    %edx,%eax
  80086f:	74 06                	je     800877 <strnlen+0x1d>
  800871:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800875:	75 f3                	jne    80086a <strnlen+0x10>
	return n;
}
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	53                   	push   %ebx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800883:	89 c2                	mov    %eax,%edx
  800885:	83 c1 01             	add    $0x1,%ecx
  800888:	83 c2 01             	add    $0x1,%edx
  80088b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800892:	84 db                	test   %bl,%bl
  800894:	75 ef                	jne    800885 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800896:	5b                   	pop    %ebx
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	53                   	push   %ebx
  80089d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a0:	53                   	push   %ebx
  8008a1:	e8 9c ff ff ff       	call   800842 <strlen>
  8008a6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	01 d8                	add    %ebx,%eax
  8008ae:	50                   	push   %eax
  8008af:	e8 c5 ff ff ff       	call   800879 <strcpy>
	return dst;
}
  8008b4:	89 d8                	mov    %ebx,%eax
  8008b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	56                   	push   %esi
  8008bf:	53                   	push   %ebx
  8008c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c6:	89 f3                	mov    %esi,%ebx
  8008c8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008cb:	89 f2                	mov    %esi,%edx
  8008cd:	eb 0f                	jmp    8008de <strncpy+0x23>
		*dst++ = *src;
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	0f b6 01             	movzbl (%ecx),%eax
  8008d5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d8:	80 39 01             	cmpb   $0x1,(%ecx)
  8008db:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008de:	39 da                	cmp    %ebx,%edx
  8008e0:	75 ed                	jne    8008cf <strncpy+0x14>
	}
	return ret;
}
  8008e2:	89 f0                	mov    %esi,%eax
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008f6:	89 f0                	mov    %esi,%eax
  8008f8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008fc:	85 c9                	test   %ecx,%ecx
  8008fe:	75 0b                	jne    80090b <strlcpy+0x23>
  800900:	eb 17                	jmp    800919 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800902:	83 c2 01             	add    $0x1,%edx
  800905:	83 c0 01             	add    $0x1,%eax
  800908:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80090b:	39 d8                	cmp    %ebx,%eax
  80090d:	74 07                	je     800916 <strlcpy+0x2e>
  80090f:	0f b6 0a             	movzbl (%edx),%ecx
  800912:	84 c9                	test   %cl,%cl
  800914:	75 ec                	jne    800902 <strlcpy+0x1a>
		*dst = '\0';
  800916:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800919:	29 f0                	sub    %esi,%eax
}
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800928:	eb 06                	jmp    800930 <strcmp+0x11>
		p++, q++;
  80092a:	83 c1 01             	add    $0x1,%ecx
  80092d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800930:	0f b6 01             	movzbl (%ecx),%eax
  800933:	84 c0                	test   %al,%al
  800935:	74 04                	je     80093b <strcmp+0x1c>
  800937:	3a 02                	cmp    (%edx),%al
  800939:	74 ef                	je     80092a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093b:	0f b6 c0             	movzbl %al,%eax
  80093e:	0f b6 12             	movzbl (%edx),%edx
  800941:	29 d0                	sub    %edx,%eax
}
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	53                   	push   %ebx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	89 c3                	mov    %eax,%ebx
  800951:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800954:	eb 06                	jmp    80095c <strncmp+0x17>
		n--, p++, q++;
  800956:	83 c0 01             	add    $0x1,%eax
  800959:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095c:	39 d8                	cmp    %ebx,%eax
  80095e:	74 16                	je     800976 <strncmp+0x31>
  800960:	0f b6 08             	movzbl (%eax),%ecx
  800963:	84 c9                	test   %cl,%cl
  800965:	74 04                	je     80096b <strncmp+0x26>
  800967:	3a 0a                	cmp    (%edx),%cl
  800969:	74 eb                	je     800956 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096b:	0f b6 00             	movzbl (%eax),%eax
  80096e:	0f b6 12             	movzbl (%edx),%edx
  800971:	29 d0                	sub    %edx,%eax
}
  800973:	5b                   	pop    %ebx
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    
		return 0;
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb f6                	jmp    800973 <strncmp+0x2e>

0080097d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800987:	0f b6 10             	movzbl (%eax),%edx
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 09                	je     800997 <strchr+0x1a>
		if (*s == c)
  80098e:	38 ca                	cmp    %cl,%dl
  800990:	74 0a                	je     80099c <strchr+0x1f>
	for (; *s; s++)
  800992:	83 c0 01             	add    $0x1,%eax
  800995:	eb f0                	jmp    800987 <strchr+0xa>
			return (char *) s;
	return 0;
  800997:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a8:	eb 03                	jmp    8009ad <strfind+0xf>
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b0:	38 ca                	cmp    %cl,%dl
  8009b2:	74 04                	je     8009b8 <strfind+0x1a>
  8009b4:	84 d2                	test   %dl,%dl
  8009b6:	75 f2                	jne    8009aa <strfind+0xc>
			break;
	return (char *) s;
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	57                   	push   %edi
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c6:	85 c9                	test   %ecx,%ecx
  8009c8:	74 13                	je     8009dd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ca:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d0:	75 05                	jne    8009d7 <memset+0x1d>
  8009d2:	f6 c1 03             	test   $0x3,%cl
  8009d5:	74 0d                	je     8009e4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009da:	fc                   	cld    
  8009db:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009dd:	89 f8                	mov    %edi,%eax
  8009df:	5b                   	pop    %ebx
  8009e0:	5e                   	pop    %esi
  8009e1:	5f                   	pop    %edi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    
		c &= 0xFF;
  8009e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 d3                	mov    %edx,%ebx
  8009ea:	c1 e3 08             	shl    $0x8,%ebx
  8009ed:	89 d0                	mov    %edx,%eax
  8009ef:	c1 e0 18             	shl    $0x18,%eax
  8009f2:	89 d6                	mov    %edx,%esi
  8009f4:	c1 e6 10             	shl    $0x10,%esi
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c2                	or     %eax,%edx
  8009fb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009fd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a00:	89 d0                	mov    %edx,%eax
  800a02:	fc                   	cld    
  800a03:	f3 ab                	rep stos %eax,%es:(%edi)
  800a05:	eb d6                	jmp    8009dd <memset+0x23>

00800a07 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	57                   	push   %edi
  800a0b:	56                   	push   %esi
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a12:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a15:	39 c6                	cmp    %eax,%esi
  800a17:	73 35                	jae    800a4e <memmove+0x47>
  800a19:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a1c:	39 c2                	cmp    %eax,%edx
  800a1e:	76 2e                	jbe    800a4e <memmove+0x47>
		s += n;
		d += n;
  800a20:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a23:	89 d6                	mov    %edx,%esi
  800a25:	09 fe                	or     %edi,%esi
  800a27:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2d:	74 0c                	je     800a3b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2f:	83 ef 01             	sub    $0x1,%edi
  800a32:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a35:	fd                   	std    
  800a36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a38:	fc                   	cld    
  800a39:	eb 21                	jmp    800a5c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3b:	f6 c1 03             	test   $0x3,%cl
  800a3e:	75 ef                	jne    800a2f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a40:	83 ef 04             	sub    $0x4,%edi
  800a43:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a49:	fd                   	std    
  800a4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4c:	eb ea                	jmp    800a38 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4e:	89 f2                	mov    %esi,%edx
  800a50:	09 c2                	or     %eax,%edx
  800a52:	f6 c2 03             	test   $0x3,%dl
  800a55:	74 09                	je     800a60 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a57:	89 c7                	mov    %eax,%edi
  800a59:	fc                   	cld    
  800a5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a5c:	5e                   	pop    %esi
  800a5d:	5f                   	pop    %edi
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a60:	f6 c1 03             	test   $0x3,%cl
  800a63:	75 f2                	jne    800a57 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a68:	89 c7                	mov    %eax,%edi
  800a6a:	fc                   	cld    
  800a6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6d:	eb ed                	jmp    800a5c <memmove+0x55>

00800a6f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a72:	ff 75 10             	pushl  0x10(%ebp)
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	e8 87 ff ff ff       	call   800a07 <memmove>
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	89 c6                	mov    %eax,%esi
  800a8f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a92:	39 f0                	cmp    %esi,%eax
  800a94:	74 1c                	je     800ab2 <memcmp+0x30>
		if (*s1 != *s2)
  800a96:	0f b6 08             	movzbl (%eax),%ecx
  800a99:	0f b6 1a             	movzbl (%edx),%ebx
  800a9c:	38 d9                	cmp    %bl,%cl
  800a9e:	75 08                	jne    800aa8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	eb ea                	jmp    800a92 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aa8:	0f b6 c1             	movzbl %cl,%eax
  800aab:	0f b6 db             	movzbl %bl,%ebx
  800aae:	29 d8                	sub    %ebx,%eax
  800ab0:	eb 05                	jmp    800ab7 <memcmp+0x35>
	}

	return 0;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5e                   	pop    %esi
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac4:	89 c2                	mov    %eax,%edx
  800ac6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac9:	39 d0                	cmp    %edx,%eax
  800acb:	73 09                	jae    800ad6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800acd:	38 08                	cmp    %cl,(%eax)
  800acf:	74 05                	je     800ad6 <memfind+0x1b>
	for (; s < ends; s++)
  800ad1:	83 c0 01             	add    $0x1,%eax
  800ad4:	eb f3                	jmp    800ac9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae4:	eb 03                	jmp    800ae9 <strtol+0x11>
		s++;
  800ae6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae9:	0f b6 01             	movzbl (%ecx),%eax
  800aec:	3c 20                	cmp    $0x20,%al
  800aee:	74 f6                	je     800ae6 <strtol+0xe>
  800af0:	3c 09                	cmp    $0x9,%al
  800af2:	74 f2                	je     800ae6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800af4:	3c 2b                	cmp    $0x2b,%al
  800af6:	74 2e                	je     800b26 <strtol+0x4e>
	int neg = 0;
  800af8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afd:	3c 2d                	cmp    $0x2d,%al
  800aff:	74 2f                	je     800b30 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b07:	75 05                	jne    800b0e <strtol+0x36>
  800b09:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0c:	74 2c                	je     800b3a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	75 0a                	jne    800b1c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b12:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b17:	80 39 30             	cmpb   $0x30,(%ecx)
  800b1a:	74 28                	je     800b44 <strtol+0x6c>
		base = 10;
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b24:	eb 50                	jmp    800b76 <strtol+0x9e>
		s++;
  800b26:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b29:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2e:	eb d1                	jmp    800b01 <strtol+0x29>
		s++, neg = 1;
  800b30:	83 c1 01             	add    $0x1,%ecx
  800b33:	bf 01 00 00 00       	mov    $0x1,%edi
  800b38:	eb c7                	jmp    800b01 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3e:	74 0e                	je     800b4e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b40:	85 db                	test   %ebx,%ebx
  800b42:	75 d8                	jne    800b1c <strtol+0x44>
		s++, base = 8;
  800b44:	83 c1 01             	add    $0x1,%ecx
  800b47:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b4c:	eb ce                	jmp    800b1c <strtol+0x44>
		s += 2, base = 16;
  800b4e:	83 c1 02             	add    $0x2,%ecx
  800b51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b56:	eb c4                	jmp    800b1c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b58:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b5b:	89 f3                	mov    %esi,%ebx
  800b5d:	80 fb 19             	cmp    $0x19,%bl
  800b60:	77 29                	ja     800b8b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b62:	0f be d2             	movsbl %dl,%edx
  800b65:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b68:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b6b:	7d 30                	jge    800b9d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b6d:	83 c1 01             	add    $0x1,%ecx
  800b70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b74:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b76:	0f b6 11             	movzbl (%ecx),%edx
  800b79:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b7c:	89 f3                	mov    %esi,%ebx
  800b7e:	80 fb 09             	cmp    $0x9,%bl
  800b81:	77 d5                	ja     800b58 <strtol+0x80>
			dig = *s - '0';
  800b83:	0f be d2             	movsbl %dl,%edx
  800b86:	83 ea 30             	sub    $0x30,%edx
  800b89:	eb dd                	jmp    800b68 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b8b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8e:	89 f3                	mov    %esi,%ebx
  800b90:	80 fb 19             	cmp    $0x19,%bl
  800b93:	77 08                	ja     800b9d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b95:	0f be d2             	movsbl %dl,%edx
  800b98:	83 ea 37             	sub    $0x37,%edx
  800b9b:	eb cb                	jmp    800b68 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba1:	74 05                	je     800ba8 <strtol+0xd0>
		*endptr = (char *) s;
  800ba3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba8:	89 c2                	mov    %eax,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	85 ff                	test   %edi,%edi
  800bae:	0f 45 c2             	cmovne %edx,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	8b 55 08             	mov    0x8(%ebp),%edx
  800c04:	b8 03 00 00 00       	mov    $0x3,%eax
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7f 08                	jg     800c1d <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c1d:	83 ec 0c             	sub    $0xc,%esp
  800c20:	50                   	push   %eax
  800c21:	6a 03                	push   $0x3
  800c23:	68 a4 13 80 00       	push   $0x8013a4
  800c28:	6a 24                	push   $0x24
  800c2a:	68 c1 13 80 00       	push   $0x8013c1
  800c2f:	e8 0c f5 ff ff       	call   800140 <_panic>

00800c34 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	89 d3                	mov    %edx,%ebx
  800c48:	89 d7                	mov    %edx,%edi
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_yield>:

void
sys_yield(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c59:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c63:	89 d1                	mov    %edx,%ecx
  800c65:	89 d3                	mov    %edx,%ebx
  800c67:	89 d7                	mov    %edx,%edi
  800c69:	89 d6                	mov    %edx,%esi
  800c6b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c7b:	be 00 00 00 00       	mov    $0x0,%esi
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c86:	b8 04 00 00 00       	mov    $0x4,%eax
  800c8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8e:	89 f7                	mov    %esi,%edi
  800c90:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c92:	85 c0                	test   %eax,%eax
  800c94:	7f 08                	jg     800c9e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c9e:	83 ec 0c             	sub    $0xc,%esp
  800ca1:	50                   	push   %eax
  800ca2:	6a 04                	push   $0x4
  800ca4:	68 a4 13 80 00       	push   $0x8013a4
  800ca9:	6a 24                	push   $0x24
  800cab:	68 c1 13 80 00       	push   $0x8013c1
  800cb0:	e8 8b f4 ff ff       	call   800140 <_panic>

00800cb5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccf:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd2:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	7f 08                	jg     800ce0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	50                   	push   %eax
  800ce4:	6a 05                	push   $0x5
  800ce6:	68 a4 13 80 00       	push   $0x8013a4
  800ceb:	6a 24                	push   $0x24
  800ced:	68 c1 13 80 00       	push   $0x8013c1
  800cf2:	e8 49 f4 ff ff       	call   800140 <_panic>

00800cf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d10:	89 df                	mov    %ebx,%edi
  800d12:	89 de                	mov    %ebx,%esi
  800d14:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7f 08                	jg     800d22 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d22:	83 ec 0c             	sub    $0xc,%esp
  800d25:	50                   	push   %eax
  800d26:	6a 06                	push   $0x6
  800d28:	68 a4 13 80 00       	push   $0x8013a4
  800d2d:	6a 24                	push   $0x24
  800d2f:	68 c1 13 80 00       	push   $0x8013c1
  800d34:	e8 07 f4 ff ff       	call   800140 <_panic>

00800d39 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d52:	89 df                	mov    %ebx,%edi
  800d54:	89 de                	mov    %ebx,%esi
  800d56:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	7f 08                	jg     800d64 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	50                   	push   %eax
  800d68:	6a 08                	push   $0x8
  800d6a:	68 a4 13 80 00       	push   $0x8013a4
  800d6f:	6a 24                	push   $0x24
  800d71:	68 c1 13 80 00       	push   $0x8013c1
  800d76:	e8 c5 f3 ff ff       	call   800140 <_panic>

00800d7b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
  800d81:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 09 00 00 00       	mov    $0x9,%eax
  800d94:	89 df                	mov    %ebx,%edi
  800d96:	89 de                	mov    %ebx,%esi
  800d98:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7f 08                	jg     800da6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	50                   	push   %eax
  800daa:	6a 09                	push   $0x9
  800dac:	68 a4 13 80 00       	push   $0x8013a4
  800db1:	6a 24                	push   $0x24
  800db3:	68 c1 13 80 00       	push   $0x8013c1
  800db8:	e8 83 f3 ff ff       	call   800140 <_panic>

00800dbd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
    asm volatile("int %1\n"
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dce:	be 00 00 00 00       	mov    $0x0,%esi
  800dd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800de9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df6:	89 cb                	mov    %ecx,%ebx
  800df8:	89 cf                	mov    %ecx,%edi
  800dfa:	89 ce                	mov    %ecx,%esi
  800dfc:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7f 08                	jg     800e0a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	50                   	push   %eax
  800e0e:	6a 0c                	push   $0xc
  800e10:	68 a4 13 80 00       	push   $0x8013a4
  800e15:	6a 24                	push   $0x24
  800e17:	68 c1 13 80 00       	push   $0x8013c1
  800e1c:	e8 1f f3 ff ff       	call   800140 <_panic>

00800e21 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800e27:	68 db 13 80 00       	push   $0x8013db
  800e2c:	6a 51                	push   $0x51
  800e2e:	68 cf 13 80 00       	push   $0x8013cf
  800e33:	e8 08 f3 ff ff       	call   800140 <_panic>

00800e38 <sfork>:
}

// Challenge!
int
sfork(void)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800e3e:	68 da 13 80 00       	push   $0x8013da
  800e43:	6a 58                	push   $0x58
  800e45:	68 cf 13 80 00       	push   $0x8013cf
  800e4a:	e8 f1 f2 ff ff       	call   800140 <_panic>

00800e4f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800e55:	68 f0 13 80 00       	push   $0x8013f0
  800e5a:	6a 1a                	push   $0x1a
  800e5c:	68 09 14 80 00       	push   $0x801409
  800e61:	e8 da f2 ff ff       	call   800140 <_panic>

00800e66 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800e6c:	68 13 14 80 00       	push   $0x801413
  800e71:	6a 2a                	push   $0x2a
  800e73:	68 09 14 80 00       	push   $0x801409
  800e78:	e8 c3 f2 ff ff       	call   800140 <_panic>

00800e7d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800e88:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800e8b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800e91:	8b 52 50             	mov    0x50(%edx),%edx
  800e94:	39 ca                	cmp    %ecx,%edx
  800e96:	74 11                	je     800ea9 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800e98:	83 c0 01             	add    $0x1,%eax
  800e9b:	3d 00 04 00 00       	cmp    $0x400,%eax
  800ea0:	75 e6                	jne    800e88 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea7:	eb 0b                	jmp    800eb4 <ipc_find_env+0x37>
			return envs[i].env_id;
  800ea9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800eac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800eb1:	8b 40 48             	mov    0x48(%eax),%eax
}
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
  800eb6:	66 90                	xchg   %ax,%ax
  800eb8:	66 90                	xchg   %ax,%ax
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

00800ec0 <__udivdi3>:
  800ec0:	55                   	push   %ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 1c             	sub    $0x1c,%esp
  800ec7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800ecb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ecf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ed3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ed7:	85 d2                	test   %edx,%edx
  800ed9:	75 35                	jne    800f10 <__udivdi3+0x50>
  800edb:	39 f3                	cmp    %esi,%ebx
  800edd:	0f 87 bd 00 00 00    	ja     800fa0 <__udivdi3+0xe0>
  800ee3:	85 db                	test   %ebx,%ebx
  800ee5:	89 d9                	mov    %ebx,%ecx
  800ee7:	75 0b                	jne    800ef4 <__udivdi3+0x34>
  800ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  800eee:	31 d2                	xor    %edx,%edx
  800ef0:	f7 f3                	div    %ebx
  800ef2:	89 c1                	mov    %eax,%ecx
  800ef4:	31 d2                	xor    %edx,%edx
  800ef6:	89 f0                	mov    %esi,%eax
  800ef8:	f7 f1                	div    %ecx
  800efa:	89 c6                	mov    %eax,%esi
  800efc:	89 e8                	mov    %ebp,%eax
  800efe:	89 f7                	mov    %esi,%edi
  800f00:	f7 f1                	div    %ecx
  800f02:	89 fa                	mov    %edi,%edx
  800f04:	83 c4 1c             	add    $0x1c,%esp
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    
  800f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f10:	39 f2                	cmp    %esi,%edx
  800f12:	77 7c                	ja     800f90 <__udivdi3+0xd0>
  800f14:	0f bd fa             	bsr    %edx,%edi
  800f17:	83 f7 1f             	xor    $0x1f,%edi
  800f1a:	0f 84 98 00 00 00    	je     800fb8 <__udivdi3+0xf8>
  800f20:	89 f9                	mov    %edi,%ecx
  800f22:	b8 20 00 00 00       	mov    $0x20,%eax
  800f27:	29 f8                	sub    %edi,%eax
  800f29:	d3 e2                	shl    %cl,%edx
  800f2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f2f:	89 c1                	mov    %eax,%ecx
  800f31:	89 da                	mov    %ebx,%edx
  800f33:	d3 ea                	shr    %cl,%edx
  800f35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f39:	09 d1                	or     %edx,%ecx
  800f3b:	89 f2                	mov    %esi,%edx
  800f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f41:	89 f9                	mov    %edi,%ecx
  800f43:	d3 e3                	shl    %cl,%ebx
  800f45:	89 c1                	mov    %eax,%ecx
  800f47:	d3 ea                	shr    %cl,%edx
  800f49:	89 f9                	mov    %edi,%ecx
  800f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f4f:	d3 e6                	shl    %cl,%esi
  800f51:	89 eb                	mov    %ebp,%ebx
  800f53:	89 c1                	mov    %eax,%ecx
  800f55:	d3 eb                	shr    %cl,%ebx
  800f57:	09 de                	or     %ebx,%esi
  800f59:	89 f0                	mov    %esi,%eax
  800f5b:	f7 74 24 08          	divl   0x8(%esp)
  800f5f:	89 d6                	mov    %edx,%esi
  800f61:	89 c3                	mov    %eax,%ebx
  800f63:	f7 64 24 0c          	mull   0xc(%esp)
  800f67:	39 d6                	cmp    %edx,%esi
  800f69:	72 0c                	jb     800f77 <__udivdi3+0xb7>
  800f6b:	89 f9                	mov    %edi,%ecx
  800f6d:	d3 e5                	shl    %cl,%ebp
  800f6f:	39 c5                	cmp    %eax,%ebp
  800f71:	73 5d                	jae    800fd0 <__udivdi3+0x110>
  800f73:	39 d6                	cmp    %edx,%esi
  800f75:	75 59                	jne    800fd0 <__udivdi3+0x110>
  800f77:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f7a:	31 ff                	xor    %edi,%edi
  800f7c:	89 fa                	mov    %edi,%edx
  800f7e:	83 c4 1c             	add    $0x1c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
  800f86:	8d 76 00             	lea    0x0(%esi),%esi
  800f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800f90:	31 ff                	xor    %edi,%edi
  800f92:	31 c0                	xor    %eax,%eax
  800f94:	89 fa                	mov    %edi,%edx
  800f96:	83 c4 1c             	add    $0x1c,%esp
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    
  800f9e:	66 90                	xchg   %ax,%ax
  800fa0:	31 ff                	xor    %edi,%edi
  800fa2:	89 e8                	mov    %ebp,%eax
  800fa4:	89 f2                	mov    %esi,%edx
  800fa6:	f7 f3                	div    %ebx
  800fa8:	89 fa                	mov    %edi,%edx
  800faa:	83 c4 1c             	add    $0x1c,%esp
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    
  800fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fb8:	39 f2                	cmp    %esi,%edx
  800fba:	72 06                	jb     800fc2 <__udivdi3+0x102>
  800fbc:	31 c0                	xor    %eax,%eax
  800fbe:	39 eb                	cmp    %ebp,%ebx
  800fc0:	77 d2                	ja     800f94 <__udivdi3+0xd4>
  800fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc7:	eb cb                	jmp    800f94 <__udivdi3+0xd4>
  800fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd0:	89 d8                	mov    %ebx,%eax
  800fd2:	31 ff                	xor    %edi,%edi
  800fd4:	eb be                	jmp    800f94 <__udivdi3+0xd4>
  800fd6:	66 90                	xchg   %ax,%ax
  800fd8:	66 90                	xchg   %ax,%ax
  800fda:	66 90                	xchg   %ax,%ax
  800fdc:	66 90                	xchg   %ax,%ax
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <__umoddi3>:
  800fe0:	55                   	push   %ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
  800fe7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800feb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800fef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ff7:	85 ed                	test   %ebp,%ebp
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	89 da                	mov    %ebx,%edx
  800ffd:	75 19                	jne    801018 <__umoddi3+0x38>
  800fff:	39 df                	cmp    %ebx,%edi
  801001:	0f 86 b1 00 00 00    	jbe    8010b8 <__umoddi3+0xd8>
  801007:	f7 f7                	div    %edi
  801009:	89 d0                	mov    %edx,%eax
  80100b:	31 d2                	xor    %edx,%edx
  80100d:	83 c4 1c             	add    $0x1c,%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    
  801015:	8d 76 00             	lea    0x0(%esi),%esi
  801018:	39 dd                	cmp    %ebx,%ebp
  80101a:	77 f1                	ja     80100d <__umoddi3+0x2d>
  80101c:	0f bd cd             	bsr    %ebp,%ecx
  80101f:	83 f1 1f             	xor    $0x1f,%ecx
  801022:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801026:	0f 84 b4 00 00 00    	je     8010e0 <__umoddi3+0x100>
  80102c:	b8 20 00 00 00       	mov    $0x20,%eax
  801031:	89 c2                	mov    %eax,%edx
  801033:	8b 44 24 04          	mov    0x4(%esp),%eax
  801037:	29 c2                	sub    %eax,%edx
  801039:	89 c1                	mov    %eax,%ecx
  80103b:	89 f8                	mov    %edi,%eax
  80103d:	d3 e5                	shl    %cl,%ebp
  80103f:	89 d1                	mov    %edx,%ecx
  801041:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801045:	d3 e8                	shr    %cl,%eax
  801047:	09 c5                	or     %eax,%ebp
  801049:	8b 44 24 04          	mov    0x4(%esp),%eax
  80104d:	89 c1                	mov    %eax,%ecx
  80104f:	d3 e7                	shl    %cl,%edi
  801051:	89 d1                	mov    %edx,%ecx
  801053:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801057:	89 df                	mov    %ebx,%edi
  801059:	d3 ef                	shr    %cl,%edi
  80105b:	89 c1                	mov    %eax,%ecx
  80105d:	89 f0                	mov    %esi,%eax
  80105f:	d3 e3                	shl    %cl,%ebx
  801061:	89 d1                	mov    %edx,%ecx
  801063:	89 fa                	mov    %edi,%edx
  801065:	d3 e8                	shr    %cl,%eax
  801067:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80106c:	09 d8                	or     %ebx,%eax
  80106e:	f7 f5                	div    %ebp
  801070:	d3 e6                	shl    %cl,%esi
  801072:	89 d1                	mov    %edx,%ecx
  801074:	f7 64 24 08          	mull   0x8(%esp)
  801078:	39 d1                	cmp    %edx,%ecx
  80107a:	89 c3                	mov    %eax,%ebx
  80107c:	89 d7                	mov    %edx,%edi
  80107e:	72 06                	jb     801086 <__umoddi3+0xa6>
  801080:	75 0e                	jne    801090 <__umoddi3+0xb0>
  801082:	39 c6                	cmp    %eax,%esi
  801084:	73 0a                	jae    801090 <__umoddi3+0xb0>
  801086:	2b 44 24 08          	sub    0x8(%esp),%eax
  80108a:	19 ea                	sbb    %ebp,%edx
  80108c:	89 d7                	mov    %edx,%edi
  80108e:	89 c3                	mov    %eax,%ebx
  801090:	89 ca                	mov    %ecx,%edx
  801092:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801097:	29 de                	sub    %ebx,%esi
  801099:	19 fa                	sbb    %edi,%edx
  80109b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80109f:	89 d0                	mov    %edx,%eax
  8010a1:	d3 e0                	shl    %cl,%eax
  8010a3:	89 d9                	mov    %ebx,%ecx
  8010a5:	d3 ee                	shr    %cl,%esi
  8010a7:	d3 ea                	shr    %cl,%edx
  8010a9:	09 f0                	or     %esi,%eax
  8010ab:	83 c4 1c             	add    $0x1c,%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    
  8010b3:	90                   	nop
  8010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	85 ff                	test   %edi,%edi
  8010ba:	89 f9                	mov    %edi,%ecx
  8010bc:	75 0b                	jne    8010c9 <__umoddi3+0xe9>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f7                	div    %edi
  8010c7:	89 c1                	mov    %eax,%ecx
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	31 d2                	xor    %edx,%edx
  8010cd:	f7 f1                	div    %ecx
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	f7 f1                	div    %ecx
  8010d3:	e9 31 ff ff ff       	jmp    801009 <__umoddi3+0x29>
  8010d8:	90                   	nop
  8010d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010e0:	39 dd                	cmp    %ebx,%ebp
  8010e2:	72 08                	jb     8010ec <__umoddi3+0x10c>
  8010e4:	39 f7                	cmp    %esi,%edi
  8010e6:	0f 87 21 ff ff ff    	ja     80100d <__umoddi3+0x2d>
  8010ec:	89 da                	mov    %ebx,%edx
  8010ee:	89 f0                	mov    %esi,%eax
  8010f0:	29 f8                	sub    %edi,%eax
  8010f2:	19 ea                	sbb    %ebp,%edx
  8010f4:	e9 14 ff ff ff       	jmp    80100d <__umoddi3+0x2d>
