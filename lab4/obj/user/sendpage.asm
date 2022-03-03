
obj/user/sendpage：     文件格式 elf32-i386


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
  80002c:	e8 6e 01 00 00       	call   80019f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 0f 0f 00 00       	call   800f4d <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 9e 00 00 00    	jne    8000e7 <umain+0xb4>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	68 00 00 b0 00       	push   $0xb00000
  800053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 c4 10 00 00       	call   801120 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	68 00 00 b0 00       	push   $0xb00000
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 a0 14 80 00       	push   $0x8014a0
  80006c:	e8 1b 02 00 00       	call   80028c <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800071:	83 c4 04             	add    $0x4,%esp
  800074:	ff 35 04 20 80 00    	pushl  0x802004
  80007a:	e8 34 08 00 00       	call   8008b3 <strlen>
  80007f:	83 c4 0c             	add    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	ff 35 04 20 80 00    	pushl  0x802004
  800089:	68 00 00 b0 00       	push   $0xb00000
  80008e:	e8 23 09 00 00       	call   8009b6 <strncmp>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	74 3b                	je     8000d5 <umain+0xa2>
			cprintf("child received correct message\n");

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 35 00 20 80 00    	pushl  0x802000
  8000a3:	e8 0b 08 00 00       	call   8008b3 <strlen>
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	83 c0 01             	add    $0x1,%eax
  8000ae:	50                   	push   %eax
  8000af:	ff 35 00 20 80 00    	pushl  0x802000
  8000b5:	68 00 00 b0 00       	push   $0xb00000
  8000ba:	e8 21 0a 00 00       	call   800ae0 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000bf:	6a 07                	push   $0x7
  8000c1:	68 00 00 b0 00       	push   $0xb00000
  8000c6:	6a 00                	push   $0x0
  8000c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8000cb:	e8 67 10 00 00       	call   801137 <ipc_send>
		return;
  8000d0:	83 c4 20             	add    $0x20,%esp
	ipc_recv(&who, TEMP_ADDR, 0);
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
		cprintf("parent received correct message\n");
	return;
}
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    
			cprintf("child received correct message\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 b4 14 80 00       	push   $0x8014b4
  8000dd:	e8 aa 01 00 00       	call   80028c <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb b3                	jmp    80009a <umain+0x67>
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000e7:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8000ec:	8b 40 48             	mov    0x48(%eax),%eax
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	6a 07                	push   $0x7
  8000f4:	68 00 00 a0 00       	push   $0xa00000
  8000f9:	50                   	push   %eax
  8000fa:	e8 e4 0b 00 00       	call   800ce3 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8000ff:	83 c4 04             	add    $0x4,%esp
  800102:	ff 35 04 20 80 00    	pushl  0x802004
  800108:	e8 a6 07 00 00       	call   8008b3 <strlen>
  80010d:	83 c4 0c             	add    $0xc,%esp
  800110:	83 c0 01             	add    $0x1,%eax
  800113:	50                   	push   %eax
  800114:	ff 35 04 20 80 00    	pushl  0x802004
  80011a:	68 00 00 a0 00       	push   $0xa00000
  80011f:	e8 bc 09 00 00       	call   800ae0 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800124:	6a 07                	push   $0x7
  800126:	68 00 00 a0 00       	push   $0xa00000
  80012b:	6a 00                	push   $0x0
  80012d:	ff 75 f4             	pushl  -0xc(%ebp)
  800130:	e8 02 10 00 00       	call   801137 <ipc_send>
	ipc_recv(&who, TEMP_ADDR, 0);
  800135:	83 c4 1c             	add    $0x1c,%esp
  800138:	6a 00                	push   $0x0
  80013a:	68 00 00 a0 00       	push   $0xa00000
  80013f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 d8 0f 00 00       	call   801120 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	68 00 00 a0 00       	push   $0xa00000
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	68 a0 14 80 00       	push   $0x8014a0
  800158:	e8 2f 01 00 00       	call   80028c <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  80015d:	83 c4 04             	add    $0x4,%esp
  800160:	ff 35 00 20 80 00    	pushl  0x802000
  800166:	e8 48 07 00 00       	call   8008b3 <strlen>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 35 00 20 80 00    	pushl  0x802000
  800175:	68 00 00 a0 00       	push   $0xa00000
  80017a:	e8 37 08 00 00       	call   8009b6 <strncmp>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	0f 85 49 ff ff ff    	jne    8000d3 <umain+0xa0>
		cprintf("parent received correct message\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 d4 14 80 00       	push   $0x8014d4
  800192:	e8 f5 00 00 00       	call   80028c <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	e9 34 ff ff ff       	jmp    8000d3 <umain+0xa0>

0080019f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001aa:	e8 f6 0a 00 00       	call   800ca5 <sys_getenvid>
  8001af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bc:	a3 0c 20 80 00       	mov    %eax,0x80200c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c1:	85 db                	test   %ebx,%ebx
  8001c3:	7e 07                	jle    8001cc <libmain+0x2d>
		binaryname = argv[0];
  8001c5:	8b 06                	mov    (%esi),%eax
  8001c7:	a3 08 20 80 00       	mov    %eax,0x802008

	// call user main routine
	umain(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	e8 5d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001d6:	e8 0a 00 00 00       	call   8001e5 <exit>
}
  8001db:	83 c4 10             	add    $0x10,%esp
  8001de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e1:	5b                   	pop    %ebx
  8001e2:	5e                   	pop    %esi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8001eb:	6a 00                	push   $0x0
  8001ed:	e8 72 0a 00 00       	call   800c64 <sys_env_destroy>
}
  8001f2:	83 c4 10             	add    $0x10,%esp
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800201:	8b 13                	mov    (%ebx),%edx
  800203:	8d 42 01             	lea    0x1(%edx),%eax
  800206:	89 03                	mov    %eax,(%ebx)
  800208:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80020f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800214:	74 09                	je     80021f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800216:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	68 ff 00 00 00       	push   $0xff
  800227:	8d 43 08             	lea    0x8(%ebx),%eax
  80022a:	50                   	push   %eax
  80022b:	e8 f7 09 00 00       	call   800c27 <sys_cputs>
		b->idx = 0;
  800230:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	eb db                	jmp    800216 <putch+0x1f>

0080023b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800244:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80024b:	00 00 00 
	b.cnt = 0;
  80024e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800255:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800258:	ff 75 0c             	pushl  0xc(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800264:	50                   	push   %eax
  800265:	68 f7 01 80 00       	push   $0x8001f7
  80026a:	e8 1a 01 00 00       	call   800389 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026f:	83 c4 08             	add    $0x8,%esp
  800272:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800278:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027e:	50                   	push   %eax
  80027f:	e8 a3 09 00 00       	call   800c27 <sys_cputs>

	return b.cnt;
}
  800284:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800292:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800295:	50                   	push   %eax
  800296:	ff 75 08             	pushl  0x8(%ebp)
  800299:	e8 9d ff ff ff       	call   80023b <vcprintf>
	va_end(ap);

	return cnt;
}
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 1c             	sub    $0x1c,%esp
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	89 d6                	mov    %edx,%esi
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002c4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002c7:	39 d3                	cmp    %edx,%ebx
  8002c9:	72 05                	jb     8002d0 <printnum+0x30>
  8002cb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002ce:	77 7a                	ja     80034a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002dc:	53                   	push   %ebx
  8002dd:	ff 75 10             	pushl  0x10(%ebp)
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ef:	e8 5c 0f 00 00       	call   801250 <__udivdi3>
  8002f4:	83 c4 18             	add    $0x18,%esp
  8002f7:	52                   	push   %edx
  8002f8:	50                   	push   %eax
  8002f9:	89 f2                	mov    %esi,%edx
  8002fb:	89 f8                	mov    %edi,%eax
  8002fd:	e8 9e ff ff ff       	call   8002a0 <printnum>
  800302:	83 c4 20             	add    $0x20,%esp
  800305:	eb 13                	jmp    80031a <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	56                   	push   %esi
  80030b:	ff 75 18             	pushl  0x18(%ebp)
  80030e:	ff d7                	call   *%edi
  800310:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800313:	83 eb 01             	sub    $0x1,%ebx
  800316:	85 db                	test   %ebx,%ebx
  800318:	7f ed                	jg     800307 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	56                   	push   %esi
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	ff 75 e4             	pushl  -0x1c(%ebp)
  800324:	ff 75 e0             	pushl  -0x20(%ebp)
  800327:	ff 75 dc             	pushl  -0x24(%ebp)
  80032a:	ff 75 d8             	pushl  -0x28(%ebp)
  80032d:	e8 3e 10 00 00       	call   801370 <__umoddi3>
  800332:	83 c4 14             	add    $0x14,%esp
  800335:	0f be 80 4c 15 80 00 	movsbl 0x80154c(%eax),%eax
  80033c:	50                   	push   %eax
  80033d:	ff d7                	call   *%edi
}
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
  80034a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80034d:	eb c4                	jmp    800313 <printnum+0x73>

0080034f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800355:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800359:	8b 10                	mov    (%eax),%edx
  80035b:	3b 50 04             	cmp    0x4(%eax),%edx
  80035e:	73 0a                	jae    80036a <sprintputch+0x1b>
		*b->buf++ = ch;
  800360:	8d 4a 01             	lea    0x1(%edx),%ecx
  800363:	89 08                	mov    %ecx,(%eax)
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	88 02                	mov    %al,(%edx)
}
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    

0080036c <printfmt>:
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800372:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800375:	50                   	push   %eax
  800376:	ff 75 10             	pushl  0x10(%ebp)
  800379:	ff 75 0c             	pushl  0xc(%ebp)
  80037c:	ff 75 08             	pushl  0x8(%ebp)
  80037f:	e8 05 00 00 00       	call   800389 <vprintfmt>
}
  800384:	83 c4 10             	add    $0x10,%esp
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <vprintfmt>:
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	57                   	push   %edi
  80038d:	56                   	push   %esi
  80038e:	53                   	push   %ebx
  80038f:	83 ec 2c             	sub    $0x2c,%esp
  800392:	8b 75 08             	mov    0x8(%ebp),%esi
  800395:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800398:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039b:	e9 00 04 00 00       	jmp    8007a0 <vprintfmt+0x417>
		padc = ' ';
  8003a0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003ab:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8d 47 01             	lea    0x1(%edi),%eax
  8003c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c4:	0f b6 17             	movzbl (%edi),%edx
  8003c7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ca:	3c 55                	cmp    $0x55,%al
  8003cc:	0f 87 51 04 00 00    	ja     800823 <vprintfmt+0x49a>
  8003d2:	0f b6 c0             	movzbl %al,%eax
  8003d5:	ff 24 85 20 16 80 00 	jmp    *0x801620(,%eax,4)
  8003dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003df:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003e3:	eb d9                	jmp    8003be <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003e8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ec:	eb d0                	jmp    8003be <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	0f b6 d2             	movzbl %dl,%edx
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003fc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ff:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800403:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800406:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800409:	83 f9 09             	cmp    $0x9,%ecx
  80040c:	77 55                	ja     800463 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80040e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800411:	eb e9                	jmp    8003fc <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8d 40 04             	lea    0x4(%eax),%eax
  800421:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800424:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800427:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042b:	79 91                	jns    8003be <vprintfmt+0x35>
				width = precision, precision = -1;
  80042d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80043a:	eb 82                	jmp    8003be <vprintfmt+0x35>
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	0f 49 d0             	cmovns %eax,%edx
  800449:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80044f:	e9 6a ff ff ff       	jmp    8003be <vprintfmt+0x35>
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800457:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80045e:	e9 5b ff ff ff       	jmp    8003be <vprintfmt+0x35>
  800463:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800466:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800469:	eb bc                	jmp    800427 <vprintfmt+0x9e>
			lflag++;
  80046b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800471:	e9 48 ff ff ff       	jmp    8003be <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8d 78 04             	lea    0x4(%eax),%edi
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	ff 30                	pushl  (%eax)
  800482:	ff d6                	call   *%esi
			break;
  800484:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800487:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048a:	e9 0e 03 00 00       	jmp    80079d <vprintfmt+0x414>
			err = va_arg(ap, int);
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	8d 78 04             	lea    0x4(%eax),%edi
  800495:	8b 00                	mov    (%eax),%eax
  800497:	99                   	cltd   
  800498:	31 d0                	xor    %edx,%eax
  80049a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049c:	83 f8 08             	cmp    $0x8,%eax
  80049f:	7f 23                	jg     8004c4 <vprintfmt+0x13b>
  8004a1:	8b 14 85 80 17 80 00 	mov    0x801780(,%eax,4),%edx
  8004a8:	85 d2                	test   %edx,%edx
  8004aa:	74 18                	je     8004c4 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004ac:	52                   	push   %edx
  8004ad:	68 6d 15 80 00       	push   $0x80156d
  8004b2:	53                   	push   %ebx
  8004b3:	56                   	push   %esi
  8004b4:	e8 b3 fe ff ff       	call   80036c <printfmt>
  8004b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004bf:	e9 d9 02 00 00       	jmp    80079d <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8004c4:	50                   	push   %eax
  8004c5:	68 64 15 80 00       	push   $0x801564
  8004ca:	53                   	push   %ebx
  8004cb:	56                   	push   %esi
  8004cc:	e8 9b fe ff ff       	call   80036c <printfmt>
  8004d1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d7:	e9 c1 02 00 00       	jmp    80079d <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004ea:	85 ff                	test   %edi,%edi
  8004ec:	b8 5d 15 80 00       	mov    $0x80155d,%eax
  8004f1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f8:	0f 8e bd 00 00 00    	jle    8005bb <vprintfmt+0x232>
  8004fe:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800502:	75 0e                	jne    800512 <vprintfmt+0x189>
  800504:	89 75 08             	mov    %esi,0x8(%ebp)
  800507:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800510:	eb 6d                	jmp    80057f <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 d0             	pushl  -0x30(%ebp)
  800518:	57                   	push   %edi
  800519:	e8 ad 03 00 00       	call   8008cb <strnlen>
  80051e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800521:	29 c1                	sub    %eax,%ecx
  800523:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800526:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800529:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80052d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800530:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800533:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800535:	eb 0f                	jmp    800546 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	53                   	push   %ebx
  80053b:	ff 75 e0             	pushl  -0x20(%ebp)
  80053e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800540:	83 ef 01             	sub    $0x1,%edi
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	85 ff                	test   %edi,%edi
  800548:	7f ed                	jg     800537 <vprintfmt+0x1ae>
  80054a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80054d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800550:	85 c9                	test   %ecx,%ecx
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
  800557:	0f 49 c1             	cmovns %ecx,%eax
  80055a:	29 c1                	sub    %eax,%ecx
  80055c:	89 75 08             	mov    %esi,0x8(%ebp)
  80055f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800562:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800565:	89 cb                	mov    %ecx,%ebx
  800567:	eb 16                	jmp    80057f <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800569:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80056d:	75 31                	jne    8005a0 <vprintfmt+0x217>
					putch(ch, putdat);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	ff 75 0c             	pushl  0xc(%ebp)
  800575:	50                   	push   %eax
  800576:	ff 55 08             	call   *0x8(%ebp)
  800579:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057c:	83 eb 01             	sub    $0x1,%ebx
  80057f:	83 c7 01             	add    $0x1,%edi
  800582:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800586:	0f be c2             	movsbl %dl,%eax
  800589:	85 c0                	test   %eax,%eax
  80058b:	74 59                	je     8005e6 <vprintfmt+0x25d>
  80058d:	85 f6                	test   %esi,%esi
  80058f:	78 d8                	js     800569 <vprintfmt+0x1e0>
  800591:	83 ee 01             	sub    $0x1,%esi
  800594:	79 d3                	jns    800569 <vprintfmt+0x1e0>
  800596:	89 df                	mov    %ebx,%edi
  800598:	8b 75 08             	mov    0x8(%ebp),%esi
  80059b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80059e:	eb 37                	jmp    8005d7 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a0:	0f be d2             	movsbl %dl,%edx
  8005a3:	83 ea 20             	sub    $0x20,%edx
  8005a6:	83 fa 5e             	cmp    $0x5e,%edx
  8005a9:	76 c4                	jbe    80056f <vprintfmt+0x1e6>
					putch('?', putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 0c             	pushl  0xc(%ebp)
  8005b1:	6a 3f                	push   $0x3f
  8005b3:	ff 55 08             	call   *0x8(%ebp)
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	eb c1                	jmp    80057c <vprintfmt+0x1f3>
  8005bb:	89 75 08             	mov    %esi,0x8(%ebp)
  8005be:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005c7:	eb b6                	jmp    80057f <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	53                   	push   %ebx
  8005cd:	6a 20                	push   $0x20
  8005cf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d1:	83 ef 01             	sub    $0x1,%edi
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	85 ff                	test   %edi,%edi
  8005d9:	7f ee                	jg     8005c9 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e1:	e9 b7 01 00 00       	jmp    80079d <vprintfmt+0x414>
  8005e6:	89 df                	mov    %ebx,%edi
  8005e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005ee:	eb e7                	jmp    8005d7 <vprintfmt+0x24e>
	if (lflag >= 2)
  8005f0:	83 f9 01             	cmp    $0x1,%ecx
  8005f3:	7e 3f                	jle    800634 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 50 04             	mov    0x4(%eax),%edx
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 08             	lea    0x8(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80060c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800610:	79 5c                	jns    80066e <vprintfmt+0x2e5>
				putch('-', putdat);
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	6a 2d                	push   $0x2d
  800618:	ff d6                	call   *%esi
				num = -(long long) num;
  80061a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80061d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800620:	f7 da                	neg    %edx
  800622:	83 d1 00             	adc    $0x0,%ecx
  800625:	f7 d9                	neg    %ecx
  800627:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062f:	e9 4f 01 00 00       	jmp    800783 <vprintfmt+0x3fa>
	else if (lflag)
  800634:	85 c9                	test   %ecx,%ecx
  800636:	75 1b                	jne    800653 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	89 c1                	mov    %eax,%ecx
  800642:	c1 f9 1f             	sar    $0x1f,%ecx
  800645:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
  800651:	eb b9                	jmp    80060c <vprintfmt+0x283>
		return va_arg(*ap, long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065b:	89 c1                	mov    %eax,%ecx
  80065d:	c1 f9 1f             	sar    $0x1f,%ecx
  800660:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	eb 9e                	jmp    80060c <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80066e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800671:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800674:	b8 0a 00 00 00       	mov    $0xa,%eax
  800679:	e9 05 01 00 00       	jmp    800783 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80067e:	83 f9 01             	cmp    $0x1,%ecx
  800681:	7e 18                	jle    80069b <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	8b 48 04             	mov    0x4(%eax),%ecx
  80068b:	8d 40 08             	lea    0x8(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800691:	b8 0a 00 00 00       	mov    $0xa,%eax
  800696:	e9 e8 00 00 00       	jmp    800783 <vprintfmt+0x3fa>
	else if (lflag)
  80069b:	85 c9                	test   %ecx,%ecx
  80069d:	75 1a                	jne    8006b9 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 10                	mov    (%eax),%edx
  8006a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b4:	e9 ca 00 00 00       	jmp    800783 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c3:	8d 40 04             	lea    0x4(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	e9 b0 00 00 00       	jmp    800783 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8006d3:	83 f9 01             	cmp    $0x1,%ecx
  8006d6:	7e 3c                	jle    800714 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 50 04             	mov    0x4(%eax),%edx
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 08             	lea    0x8(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8006ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f3:	79 59                	jns    80074e <vprintfmt+0x3c5>
                putch('-', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	53                   	push   %ebx
  8006f9:	6a 2d                	push   $0x2d
  8006fb:	ff d6                	call   *%esi
                num = -(long long) num;
  8006fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800700:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800703:	f7 da                	neg    %edx
  800705:	83 d1 00             	adc    $0x0,%ecx
  800708:	f7 d9                	neg    %ecx
  80070a:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
  800712:	eb 6f                	jmp    800783 <vprintfmt+0x3fa>
	else if (lflag)
  800714:	85 c9                	test   %ecx,%ecx
  800716:	75 1b                	jne    800733 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800720:	89 c1                	mov    %eax,%ecx
  800722:	c1 f9 1f             	sar    $0x1f,%ecx
  800725:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	eb bc                	jmp    8006ef <vprintfmt+0x366>
		return va_arg(*ap, long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 c1                	mov    %eax,%ecx
  80073d:	c1 f9 1f             	sar    $0x1f,%ecx
  800740:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	eb a1                	jmp    8006ef <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80074e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800751:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800754:	b8 08 00 00 00       	mov    $0x8,%eax
  800759:	eb 28                	jmp    800783 <vprintfmt+0x3fa>
			putch('0', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 30                	push   $0x30
  800761:	ff d6                	call   *%esi
			putch('x', putdat);
  800763:	83 c4 08             	add    $0x8,%esp
  800766:	53                   	push   %ebx
  800767:	6a 78                	push   $0x78
  800769:	ff d6                	call   *%esi
			num = (unsigned long long)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 10                	mov    (%eax),%edx
  800770:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800775:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800778:	8d 40 04             	lea    0x4(%eax),%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800783:	83 ec 0c             	sub    $0xc,%esp
  800786:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80078a:	57                   	push   %edi
  80078b:	ff 75 e0             	pushl  -0x20(%ebp)
  80078e:	50                   	push   %eax
  80078f:	51                   	push   %ecx
  800790:	52                   	push   %edx
  800791:	89 da                	mov    %ebx,%edx
  800793:	89 f0                	mov    %esi,%eax
  800795:	e8 06 fb ff ff       	call   8002a0 <printnum>
			break;
  80079a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a0:	83 c7 01             	add    $0x1,%edi
  8007a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a7:	83 f8 25             	cmp    $0x25,%eax
  8007aa:	0f 84 f0 fb ff ff    	je     8003a0 <vprintfmt+0x17>
			if (ch == '\0')
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	0f 84 8b 00 00 00    	je     800843 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	50                   	push   %eax
  8007bd:	ff d6                	call   *%esi
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	eb dc                	jmp    8007a0 <vprintfmt+0x417>
	if (lflag >= 2)
  8007c4:	83 f9 01             	cmp    $0x1,%ecx
  8007c7:	7e 15                	jle    8007de <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 10                	mov    (%eax),%edx
  8007ce:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d1:	8d 40 08             	lea    0x8(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007dc:	eb a5                	jmp    800783 <vprintfmt+0x3fa>
	else if (lflag)
  8007de:	85 c9                	test   %ecx,%ecx
  8007e0:	75 17                	jne    8007f9 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 10                	mov    (%eax),%edx
  8007e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ec:	8d 40 04             	lea    0x4(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f7:	eb 8a                	jmp    800783 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 10                	mov    (%eax),%edx
  8007fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800809:	b8 10 00 00 00       	mov    $0x10,%eax
  80080e:	e9 70 ff ff ff       	jmp    800783 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	6a 25                	push   $0x25
  800819:	ff d6                	call   *%esi
			break;
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	e9 7a ff ff ff       	jmp    80079d <vprintfmt+0x414>
			putch('%', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 25                	push   $0x25
  800829:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 f8                	mov    %edi,%eax
  800830:	eb 03                	jmp    800835 <vprintfmt+0x4ac>
  800832:	83 e8 01             	sub    $0x1,%eax
  800835:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800839:	75 f7                	jne    800832 <vprintfmt+0x4a9>
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	e9 5a ff ff ff       	jmp    80079d <vprintfmt+0x414>
}
  800843:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800846:	5b                   	pop    %ebx
  800847:	5e                   	pop    %esi
  800848:	5f                   	pop    %edi
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	83 ec 18             	sub    $0x18,%esp
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800857:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80085a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800861:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800868:	85 c0                	test   %eax,%eax
  80086a:	74 26                	je     800892 <vsnprintf+0x47>
  80086c:	85 d2                	test   %edx,%edx
  80086e:	7e 22                	jle    800892 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800870:	ff 75 14             	pushl  0x14(%ebp)
  800873:	ff 75 10             	pushl  0x10(%ebp)
  800876:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800879:	50                   	push   %eax
  80087a:	68 4f 03 80 00       	push   $0x80034f
  80087f:	e8 05 fb ff ff       	call   800389 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800887:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088d:	83 c4 10             	add    $0x10,%esp
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    
		return -E_INVAL;
  800892:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800897:	eb f7                	jmp    800890 <vsnprintf+0x45>

00800899 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a2:	50                   	push   %eax
  8008a3:	ff 75 10             	pushl  0x10(%ebp)
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	ff 75 08             	pushl  0x8(%ebp)
  8008ac:	e8 9a ff ff ff       	call   80084b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008be:	eb 03                	jmp    8008c3 <strlen+0x10>
		n++;
  8008c0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c7:	75 f7                	jne    8008c0 <strlen+0xd>
	return n;
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d9:	eb 03                	jmp    8008de <strnlen+0x13>
		n++;
  8008db:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008de:	39 d0                	cmp    %edx,%eax
  8008e0:	74 06                	je     8008e8 <strnlen+0x1d>
  8008e2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e6:	75 f3                	jne    8008db <strnlen+0x10>
	return n;
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f4:	89 c2                	mov    %eax,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	83 c2 01             	add    $0x1,%edx
  8008fc:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800900:	88 5a ff             	mov    %bl,-0x1(%edx)
  800903:	84 db                	test   %bl,%bl
  800905:	75 ef                	jne    8008f6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800907:	5b                   	pop    %ebx
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	53                   	push   %ebx
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	53                   	push   %ebx
  800912:	e8 9c ff ff ff       	call   8008b3 <strlen>
  800917:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	01 d8                	add    %ebx,%eax
  80091f:	50                   	push   %eax
  800920:	e8 c5 ff ff ff       	call   8008ea <strcpy>
	return dst;
}
  800925:	89 d8                	mov    %ebx,%eax
  800927:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	56                   	push   %esi
  800930:	53                   	push   %ebx
  800931:	8b 75 08             	mov    0x8(%ebp),%esi
  800934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800937:	89 f3                	mov    %esi,%ebx
  800939:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093c:	89 f2                	mov    %esi,%edx
  80093e:	eb 0f                	jmp    80094f <strncpy+0x23>
		*dst++ = *src;
  800940:	83 c2 01             	add    $0x1,%edx
  800943:	0f b6 01             	movzbl (%ecx),%eax
  800946:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800949:	80 39 01             	cmpb   $0x1,(%ecx)
  80094c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80094f:	39 da                	cmp    %ebx,%edx
  800951:	75 ed                	jne    800940 <strncpy+0x14>
	}
	return ret;
}
  800953:	89 f0                	mov    %esi,%eax
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
  80095e:	8b 75 08             	mov    0x8(%ebp),%esi
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
  800964:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800967:	89 f0                	mov    %esi,%eax
  800969:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096d:	85 c9                	test   %ecx,%ecx
  80096f:	75 0b                	jne    80097c <strlcpy+0x23>
  800971:	eb 17                	jmp    80098a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800973:	83 c2 01             	add    $0x1,%edx
  800976:	83 c0 01             	add    $0x1,%eax
  800979:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80097c:	39 d8                	cmp    %ebx,%eax
  80097e:	74 07                	je     800987 <strlcpy+0x2e>
  800980:	0f b6 0a             	movzbl (%edx),%ecx
  800983:	84 c9                	test   %cl,%cl
  800985:	75 ec                	jne    800973 <strlcpy+0x1a>
		*dst = '\0';
  800987:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098a:	29 f0                	sub    %esi,%eax
}
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800999:	eb 06                	jmp    8009a1 <strcmp+0x11>
		p++, q++;
  80099b:	83 c1 01             	add    $0x1,%ecx
  80099e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009a1:	0f b6 01             	movzbl (%ecx),%eax
  8009a4:	84 c0                	test   %al,%al
  8009a6:	74 04                	je     8009ac <strcmp+0x1c>
  8009a8:	3a 02                	cmp    (%edx),%al
  8009aa:	74 ef                	je     80099b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ac:	0f b6 c0             	movzbl %al,%eax
  8009af:	0f b6 12             	movzbl (%edx),%edx
  8009b2:	29 d0                	sub    %edx,%eax
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c0:	89 c3                	mov    %eax,%ebx
  8009c2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c5:	eb 06                	jmp    8009cd <strncmp+0x17>
		n--, p++, q++;
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009cd:	39 d8                	cmp    %ebx,%eax
  8009cf:	74 16                	je     8009e7 <strncmp+0x31>
  8009d1:	0f b6 08             	movzbl (%eax),%ecx
  8009d4:	84 c9                	test   %cl,%cl
  8009d6:	74 04                	je     8009dc <strncmp+0x26>
  8009d8:	3a 0a                	cmp    (%edx),%cl
  8009da:	74 eb                	je     8009c7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dc:	0f b6 00             	movzbl (%eax),%eax
  8009df:	0f b6 12             	movzbl (%edx),%edx
  8009e2:	29 d0                	sub    %edx,%eax
}
  8009e4:	5b                   	pop    %ebx
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    
		return 0;
  8009e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ec:	eb f6                	jmp    8009e4 <strncmp+0x2e>

008009ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f8:	0f b6 10             	movzbl (%eax),%edx
  8009fb:	84 d2                	test   %dl,%dl
  8009fd:	74 09                	je     800a08 <strchr+0x1a>
		if (*s == c)
  8009ff:	38 ca                	cmp    %cl,%dl
  800a01:	74 0a                	je     800a0d <strchr+0x1f>
	for (; *s; s++)
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	eb f0                	jmp    8009f8 <strchr+0xa>
			return (char *) s;
	return 0;
  800a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a19:	eb 03                	jmp    800a1e <strfind+0xf>
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a21:	38 ca                	cmp    %cl,%dl
  800a23:	74 04                	je     800a29 <strfind+0x1a>
  800a25:	84 d2                	test   %dl,%dl
  800a27:	75 f2                	jne    800a1b <strfind+0xc>
			break;
	return (char *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	57                   	push   %edi
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a37:	85 c9                	test   %ecx,%ecx
  800a39:	74 13                	je     800a4e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a41:	75 05                	jne    800a48 <memset+0x1d>
  800a43:	f6 c1 03             	test   $0x3,%cl
  800a46:	74 0d                	je     800a55 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	fc                   	cld    
  800a4c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a4e:	89 f8                	mov    %edi,%eax
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5f                   	pop    %edi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    
		c &= 0xFF;
  800a55:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a59:	89 d3                	mov    %edx,%ebx
  800a5b:	c1 e3 08             	shl    $0x8,%ebx
  800a5e:	89 d0                	mov    %edx,%eax
  800a60:	c1 e0 18             	shl    $0x18,%eax
  800a63:	89 d6                	mov    %edx,%esi
  800a65:	c1 e6 10             	shl    $0x10,%esi
  800a68:	09 f0                	or     %esi,%eax
  800a6a:	09 c2                	or     %eax,%edx
  800a6c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a6e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	fc                   	cld    
  800a74:	f3 ab                	rep stos %eax,%es:(%edi)
  800a76:	eb d6                	jmp    800a4e <memset+0x23>

00800a78 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	57                   	push   %edi
  800a7c:	56                   	push   %esi
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a86:	39 c6                	cmp    %eax,%esi
  800a88:	73 35                	jae    800abf <memmove+0x47>
  800a8a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	76 2e                	jbe    800abf <memmove+0x47>
		s += n;
		d += n;
  800a91:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a94:	89 d6                	mov    %edx,%esi
  800a96:	09 fe                	or     %edi,%esi
  800a98:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9e:	74 0c                	je     800aac <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa0:	83 ef 01             	sub    $0x1,%edi
  800aa3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa6:	fd                   	std    
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa9:	fc                   	cld    
  800aaa:	eb 21                	jmp    800acd <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aac:	f6 c1 03             	test   $0x3,%cl
  800aaf:	75 ef                	jne    800aa0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb ea                	jmp    800aa9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	89 f2                	mov    %esi,%edx
  800ac1:	09 c2                	or     %eax,%edx
  800ac3:	f6 c2 03             	test   $0x3,%dl
  800ac6:	74 09                	je     800ad1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac8:	89 c7                	mov    %eax,%edi
  800aca:	fc                   	cld    
  800acb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad1:	f6 c1 03             	test   $0x3,%cl
  800ad4:	75 f2                	jne    800ac8 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	fc                   	cld    
  800adc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ade:	eb ed                	jmp    800acd <memmove+0x55>

00800ae0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ae3:	ff 75 10             	pushl  0x10(%ebp)
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	ff 75 08             	pushl  0x8(%ebp)
  800aec:	e8 87 ff ff ff       	call   800a78 <memmove>
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afe:	89 c6                	mov    %eax,%esi
  800b00:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b03:	39 f0                	cmp    %esi,%eax
  800b05:	74 1c                	je     800b23 <memcmp+0x30>
		if (*s1 != *s2)
  800b07:	0f b6 08             	movzbl (%eax),%ecx
  800b0a:	0f b6 1a             	movzbl (%edx),%ebx
  800b0d:	38 d9                	cmp    %bl,%cl
  800b0f:	75 08                	jne    800b19 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b11:	83 c0 01             	add    $0x1,%eax
  800b14:	83 c2 01             	add    $0x1,%edx
  800b17:	eb ea                	jmp    800b03 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b19:	0f b6 c1             	movzbl %cl,%eax
  800b1c:	0f b6 db             	movzbl %bl,%ebx
  800b1f:	29 d8                	sub    %ebx,%eax
  800b21:	eb 05                	jmp    800b28 <memcmp+0x35>
	}

	return 0;
  800b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3a:	39 d0                	cmp    %edx,%eax
  800b3c:	73 09                	jae    800b47 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3e:	38 08                	cmp    %cl,(%eax)
  800b40:	74 05                	je     800b47 <memfind+0x1b>
	for (; s < ends; s++)
  800b42:	83 c0 01             	add    $0x1,%eax
  800b45:	eb f3                	jmp    800b3a <memfind+0xe>
			break;
	return (void *) s;
}
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
  800b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b55:	eb 03                	jmp    800b5a <strtol+0x11>
		s++;
  800b57:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b5a:	0f b6 01             	movzbl (%ecx),%eax
  800b5d:	3c 20                	cmp    $0x20,%al
  800b5f:	74 f6                	je     800b57 <strtol+0xe>
  800b61:	3c 09                	cmp    $0x9,%al
  800b63:	74 f2                	je     800b57 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b65:	3c 2b                	cmp    $0x2b,%al
  800b67:	74 2e                	je     800b97 <strtol+0x4e>
	int neg = 0;
  800b69:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6e:	3c 2d                	cmp    $0x2d,%al
  800b70:	74 2f                	je     800ba1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b72:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b78:	75 05                	jne    800b7f <strtol+0x36>
  800b7a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7d:	74 2c                	je     800bab <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b7f:	85 db                	test   %ebx,%ebx
  800b81:	75 0a                	jne    800b8d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b83:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b88:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8b:	74 28                	je     800bb5 <strtol+0x6c>
		base = 10;
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b92:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b95:	eb 50                	jmp    800be7 <strtol+0x9e>
		s++;
  800b97:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b9a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9f:	eb d1                	jmp    800b72 <strtol+0x29>
		s++, neg = 1;
  800ba1:	83 c1 01             	add    $0x1,%ecx
  800ba4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba9:	eb c7                	jmp    800b72 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bab:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800baf:	74 0e                	je     800bbf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bb1:	85 db                	test   %ebx,%ebx
  800bb3:	75 d8                	jne    800b8d <strtol+0x44>
		s++, base = 8;
  800bb5:	83 c1 01             	add    $0x1,%ecx
  800bb8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bbd:	eb ce                	jmp    800b8d <strtol+0x44>
		s += 2, base = 16;
  800bbf:	83 c1 02             	add    $0x2,%ecx
  800bc2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc7:	eb c4                	jmp    800b8d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bc9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bcc:	89 f3                	mov    %esi,%ebx
  800bce:	80 fb 19             	cmp    $0x19,%bl
  800bd1:	77 29                	ja     800bfc <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd3:	0f be d2             	movsbl %dl,%edx
  800bd6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bdc:	7d 30                	jge    800c0e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bde:	83 c1 01             	add    $0x1,%ecx
  800be1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800be5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800be7:	0f b6 11             	movzbl (%ecx),%edx
  800bea:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bed:	89 f3                	mov    %esi,%ebx
  800bef:	80 fb 09             	cmp    $0x9,%bl
  800bf2:	77 d5                	ja     800bc9 <strtol+0x80>
			dig = *s - '0';
  800bf4:	0f be d2             	movsbl %dl,%edx
  800bf7:	83 ea 30             	sub    $0x30,%edx
  800bfa:	eb dd                	jmp    800bd9 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bfc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bff:	89 f3                	mov    %esi,%ebx
  800c01:	80 fb 19             	cmp    $0x19,%bl
  800c04:	77 08                	ja     800c0e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c06:	0f be d2             	movsbl %dl,%edx
  800c09:	83 ea 37             	sub    $0x37,%edx
  800c0c:	eb cb                	jmp    800bd9 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	74 05                	je     800c19 <strtol+0xd0>
		*endptr = (char *) s;
  800c14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c17:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c19:	89 c2                	mov    %eax,%edx
  800c1b:	f7 da                	neg    %edx
  800c1d:	85 ff                	test   %edi,%edi
  800c1f:	0f 45 c2             	cmovne %edx,%eax
}
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c32:	8b 55 08             	mov    0x8(%ebp),%edx
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c38:	89 c3                	mov    %eax,%ebx
  800c3a:	89 c7                	mov    %eax,%edi
  800c3c:	89 c6                	mov    %eax,%esi
  800c3e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_cgetc>:

int
sys_cgetc(void) {
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 01 00 00 00       	mov    $0x1,%eax
  800c55:	89 d1                	mov    %edx,%ecx
  800c57:	89 d3                	mov    %edx,%ebx
  800c59:	89 d7                	mov    %edx,%edi
  800c5b:	89 d6                	mov    %edx,%esi
  800c5d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
  800c6a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7a:	89 cb                	mov    %ecx,%ebx
  800c7c:	89 cf                	mov    %ecx,%edi
  800c7e:	89 ce                	mov    %ecx,%esi
  800c80:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c82:	85 c0                	test   %eax,%eax
  800c84:	7f 08                	jg     800c8e <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c92:	6a 03                	push   $0x3
  800c94:	68 a4 17 80 00       	push   $0x8017a4
  800c99:	6a 24                	push   $0x24
  800c9b:	68 c1 17 80 00       	push   $0x8017c1
  800ca0:	e8 e2 04 00 00       	call   801187 <_panic>

00800ca5 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_yield>:

void
sys_yield(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cec:	be 00 00 00 00       	mov    $0x0,%esi
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cff:	89 f7                	mov    %esi,%edi
  800d01:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 04                	push   $0x4
  800d15:	68 a4 17 80 00       	push   $0x8017a4
  800d1a:	6a 24                	push   $0x24
  800d1c:	68 c1 17 80 00       	push   $0x8017c1
  800d21:	e8 61 04 00 00       	call   801187 <_panic>

00800d26 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	b8 05 00 00 00       	mov    $0x5,%eax
  800d3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d40:	8b 75 18             	mov    0x18(%ebp),%esi
  800d43:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 05                	push   $0x5
  800d57:	68 a4 17 80 00       	push   $0x8017a4
  800d5c:	6a 24                	push   $0x24
  800d5e:	68 c1 17 80 00       	push   $0x8017c1
  800d63:	e8 1f 04 00 00       	call   801187 <_panic>

00800d68 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d81:	89 df                	mov    %ebx,%edi
  800d83:	89 de                	mov    %ebx,%esi
  800d85:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 06                	push   $0x6
  800d99:	68 a4 17 80 00       	push   $0x8017a4
  800d9e:	6a 24                	push   $0x24
  800da0:	68 c1 17 80 00       	push   $0x8017c1
  800da5:	e8 dd 03 00 00       	call   801187 <_panic>

00800daa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 08                	push   $0x8
  800ddb:	68 a4 17 80 00       	push   $0x8017a4
  800de0:	6a 24                	push   $0x24
  800de2:	68 c1 17 80 00       	push   $0x8017c1
  800de7:	e8 9b 03 00 00       	call   801187 <_panic>

00800dec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 09 00 00 00       	mov    $0x9,%eax
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 09                	push   $0x9
  800e1d:	68 a4 17 80 00       	push   $0x8017a4
  800e22:	6a 24                	push   $0x24
  800e24:	68 c1 17 80 00       	push   $0x8017c1
  800e29:	e8 59 03 00 00       	call   801187 <_panic>

00800e2e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
    asm volatile("int %1\n"
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e3f:	be 00 00 00 00       	mov    $0x0,%esi
  800e44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e47:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
  800e57:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e67:	89 cb                	mov    %ecx,%ebx
  800e69:	89 cf                	mov    %ecx,%edi
  800e6b:	89 ce                	mov    %ecx,%esi
  800e6d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 0c                	push   $0xc
  800e81:	68 a4 17 80 00       	push   $0x8017a4
  800e86:	6a 24                	push   $0x24
  800e88:	68 c1 17 80 00       	push   $0x8017c1
  800e8d:	e8 f5 02 00 00       	call   801187 <_panic>

00800e92 <pgfault>:
//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf) {
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	53                   	push   %ebx
  800e96:	83 ec 04             	sub    $0x4,%esp
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800e9c:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800e9e:	8b 40 04             	mov    0x4(%eax),%eax
    int r;

    extern volatile pte_t uvpt[];
    if (err != FEC_WR || ((uvpt[(uintptr_t) addr / PGSIZE] & PTE_COW) != PTE_COW)) {
  800ea1:	83 f8 02             	cmp    $0x2,%eax
  800ea4:	75 11                	jne    800eb7 <pgfault+0x25>
  800ea6:	89 da                	mov    %ebx,%edx
  800ea8:	c1 ea 0c             	shr    $0xc,%edx
  800eab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb2:	f6 c6 08             	test   $0x8,%dh
  800eb5:	75 23                	jne    800eda <pgfault+0x48>
        cprintf("utf->utf_fault_va:0x%x\tutf->utf_err:%d\n", addr, err);
  800eb7:	83 ec 04             	sub    $0x4,%esp
  800eba:	50                   	push   %eax
  800ebb:	53                   	push   %ebx
  800ebc:	68 d0 17 80 00       	push   $0x8017d0
  800ec1:	e8 c6 f3 ff ff       	call   80028c <cprintf>
        panic("pgfault is not a FEC_WR or is not to a COW page");
  800ec6:	83 c4 0c             	add    $0xc,%esp
  800ec9:	68 f8 17 80 00       	push   $0x8017f8
  800ece:	6a 17                	push   $0x17
  800ed0:	68 4c 18 80 00       	push   $0x80184c
  800ed5:	e8 ad 02 00 00       	call   801187 <_panic>
    //   Use the read-only page table mappings at uvpt
    //   (see <inc/memlayout.h>).

    // LAB 4: Your code here.

    sys_page_alloc(0, (void *) PFTEMP, PTE_W | PTE_U | PTE_P);
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	6a 07                	push   $0x7
  800edf:	68 00 f0 7f 00       	push   $0x7ff000
  800ee4:	6a 00                	push   $0x0
  800ee6:	e8 f8 fd ff ff       	call   800ce3 <sys_page_alloc>
    memmove((void *) PFTEMP, (void *) (ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  800eeb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ef1:	83 c4 0c             	add    $0xc,%esp
  800ef4:	68 00 10 00 00       	push   $0x1000
  800ef9:	53                   	push   %ebx
  800efa:	68 00 f0 7f 00       	push   $0x7ff000
  800eff:	e8 74 fb ff ff       	call   800a78 <memmove>

    //restore another
    sys_page_map(0, (void *) (ROUNDDOWN(addr, PGSIZE)), 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800f04:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f0b:	53                   	push   %ebx
  800f0c:	6a 00                	push   $0x0
  800f0e:	53                   	push   %ebx
  800f0f:	6a 00                	push   $0x0
  800f11:	e8 10 fe ff ff       	call   800d26 <sys_page_map>

    sys_page_map(0, (void *) PFTEMP, 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
  800f16:	83 c4 14             	add    $0x14,%esp
  800f19:	6a 07                	push   $0x7
  800f1b:	53                   	push   %ebx
  800f1c:	6a 00                	push   $0x0
  800f1e:	68 00 f0 7f 00       	push   $0x7ff000
  800f23:	6a 00                	push   $0x0
  800f25:	e8 fc fd ff ff       	call   800d26 <sys_page_map>
    sys_page_unmap(0, (void *) PFTEMP);
  800f2a:	83 c4 18             	add    $0x18,%esp
  800f2d:	68 00 f0 7f 00       	push   $0x7ff000
  800f32:	6a 00                	push   $0x0
  800f34:	e8 2f fe ff ff       	call   800d68 <sys_page_unmap>
    // Hint:
    //   You should make three system calls.

    // LAB 4: Your code here.

    panic("pgfault not implemented");
  800f39:	83 c4 0c             	add    $0xc,%esp
  800f3c:	68 57 18 80 00       	push   $0x801857
  800f41:	6a 31                	push   $0x31
  800f43:	68 4c 18 80 00       	push   $0x80184c
  800f48:	e8 3a 02 00 00       	call   801187 <_panic>

00800f4d <fork>:
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void) {
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	83 ec 28             	sub    $0x28,%esp
    //1. The parent installs pgfault() as the C-level page fault handler, using the set_pgfault_handler() function you implemented above.
    set_pgfault_handler(pgfault);
  800f56:	68 92 0e 80 00       	push   $0x800e92
  800f5b:	e8 6d 02 00 00       	call   8011cd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f60:	b8 07 00 00 00       	mov    $0x7,%eax
  800f65:	cd 30                	int    $0x30
  800f67:	89 c7                	mov    %eax,%edi
  800f69:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    //2. The parent calls sys_exofork() to create a child environment.
    envid_t envid = sys_exofork();

    if (envid == 0) {
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	74 1c                	je     800f8f <fork+0x42>
    //   LAB 4: Your code here.

    int i;
    extern volatile pde_t uvpd[];
    extern volatile pte_t uvpt[];
    cprintf("COW page resolve ....\n");
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	68 6f 18 80 00       	push   $0x80186f
  800f7b:	e8 0c f3 ff ff       	call   80028c <cprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < UTOP / PGSIZE; i++) {
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	be 00 00 00 00       	mov    $0x0,%esi
  800f8d:	eb 2e                	jmp    800fbd <fork+0x70>
        thisenv = &envs[sys_getenvid()];
  800f8f:	e8 11 fd ff ff       	call   800ca5 <sys_getenvid>
  800f94:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f97:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f9c:	a3 0c 20 80 00       	mov    %eax,0x80200c
        return 0;
  800fa1:	e9 56 01 00 00       	jmp    8010fc <fork+0x1af>
//        cprintf("0x%x\n", i);

//        cprintf("enter %d\n", i);
        if (uvpd[i / NPTENTRIES] == 0) {
//            cprintf("blank uvpd: 0x%x\n", i);
            i += 1023;
  800fa6:	81 c3 ff 03 00 00    	add    $0x3ff,%ebx
    for (i = 0; i < UTOP / PGSIZE; i++) {
  800fac:	83 c3 01             	add    $0x1,%ebx
  800faf:	89 de                	mov    %ebx,%esi
  800fb1:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  800fb7:	0f 87 c7 00 00 00    	ja     801084 <fork+0x137>
        if (uvpd[i / NPTENTRIES] == 0) {
  800fbd:	8d 83 ff 03 00 00    	lea    0x3ff(%ebx),%eax
  800fc3:	85 db                	test   %ebx,%ebx
  800fc5:	0f 49 c3             	cmovns %ebx,%eax
  800fc8:	c1 f8 0a             	sar    $0xa,%eax
  800fcb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	74 d0                	je     800fa6 <fork+0x59>
            continue;
        }

        if ((uvpt[i] & PTE_P) == PTE_P) {
  800fd6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fdd:	a8 01                	test   $0x1,%al
  800fdf:	74 cb                	je     800fac <fork+0x5f>
//            if (i % NPTENTRIES == 0) {
//                cprintf("present uvpd: 0x%x\n", i);
//            }

            if (((uvpt[i] & PTE_W) == PTE_W) || ((uvpt[i] & PTE_COW) == PTE_COW)) {
  800fe1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fe8:	a8 02                	test   $0x2,%al
  800fea:	75 0c                	jne    800ff8 <fork+0xab>
  800fec:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800ff3:	f6 c4 08             	test   $0x8,%ah
  800ff6:	74 65                	je     80105d <fork+0x110>
    if (sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  800ff8:	c1 e6 0c             	shl    $0xc,%esi
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	68 05 08 00 00       	push   $0x805
  801003:	56                   	push   %esi
  801004:	ff 75 e4             	pushl  -0x1c(%ebp)
  801007:	56                   	push   %esi
  801008:	6a 00                	push   $0x0
  80100a:	e8 17 fd ff ff       	call   800d26 <sys_page_map>
  80100f:	83 c4 20             	add    $0x20,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 33                	js     801049 <fork+0xfc>
    if (sys_page_map(envid, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	68 05 08 00 00       	push   $0x805
  80101e:	56                   	push   %esi
  80101f:	6a 00                	push   $0x0
  801021:	56                   	push   %esi
  801022:	ff 75 e4             	pushl  -0x1c(%ebp)
  801025:	e8 fc fc ff ff       	call   800d26 <sys_page_map>
  80102a:	83 c4 20             	add    $0x20,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	0f 89 77 ff ff ff    	jns    800fac <fork+0x5f>
        panic("dupppage target map error");
  801035:	83 ec 04             	sub    $0x4,%esp
  801038:	68 a1 18 80 00       	push   $0x8018a1
  80103d:	6a 4b                	push   $0x4b
  80103f:	68 4c 18 80 00       	push   $0x80184c
  801044:	e8 3e 01 00 00       	call   801187 <_panic>
        panic("dupppage our own map error");
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	68 86 18 80 00       	push   $0x801886
  801051:	6a 45                	push   $0x45
  801053:	68 4c 18 80 00       	push   $0x80184c
  801058:	e8 2a 01 00 00       	call   801187 <_panic>
                duppage(envid, i);
            } else {
                //lead to kernel panic because uvpt can't write....
                sys_page_map(0, (void *) (i * PGSIZE), envid, (void *) (i * PGSIZE), PTE_SHARE | uvpt[i]);
  80105d:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801064:	89 da                	mov    %ebx,%edx
  801066:	c1 e2 0c             	shl    $0xc,%edx
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	80 cc 04             	or     $0x4,%ah
  80106f:	50                   	push   %eax
  801070:	52                   	push   %edx
  801071:	ff 75 e4             	pushl  -0x1c(%ebp)
  801074:	52                   	push   %edx
  801075:	6a 00                	push   $0x0
  801077:	e8 aa fc ff ff       	call   800d26 <sys_page_map>
  80107c:	83 c4 20             	add    $0x20,%esp
  80107f:	e9 28 ff ff ff       	jmp    800fac <fork+0x5f>
//                pages[PGNUM(uvpt[i])].pp_ref += 1;
            }
        }
    }

    cprintf("allocate child ExceptionStack ....\n");
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	68 28 18 80 00       	push   $0x801828
  80108c:	e8 fb f1 ff ff       	call   80028c <cprintf>
    sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801091:	83 c4 0c             	add    $0xc,%esp
  801094:	6a 07                	push   $0x7
  801096:	68 00 f0 bf ee       	push   $0xeebff000
  80109b:	57                   	push   %edi
  80109c:	e8 42 fc ff ff       	call   800ce3 <sys_page_alloc>
    sys_page_map(envid, (void *) (UXSTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
  8010a1:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010a8:	68 00 00 40 00       	push   $0x400000
  8010ad:	6a 00                	push   $0x0
  8010af:	68 00 f0 bf ee       	push   $0xeebff000
  8010b4:	57                   	push   %edi
  8010b5:	e8 6c fc ff ff       	call   800d26 <sys_page_map>
    memmove(UTEMP, (void *) (UXSTACKTOP - PGSIZE), PGSIZE);
  8010ba:	83 c4 1c             	add    $0x1c,%esp
  8010bd:	68 00 10 00 00       	push   $0x1000
  8010c2:	68 00 f0 bf ee       	push   $0xeebff000
  8010c7:	68 00 00 40 00       	push   $0x400000
  8010cc:	e8 a7 f9 ff ff       	call   800a78 <memmove>
    sys_page_unmap(0, (void *) UTEMP);
  8010d1:	83 c4 08             	add    $0x8,%esp
  8010d4:	68 00 00 40 00       	push   $0x400000
  8010d9:	6a 00                	push   $0x0
  8010db:	e8 88 fc ff ff       	call   800d68 <sys_page_unmap>

    //4. The parent sets the user page fault entrypoint for the child to look like its own.
//    set_pgfault_handler(pgfault);
    sys_env_set_pgfault_upcall(envid, pgfault);
  8010e0:	83 c4 08             	add    $0x8,%esp
  8010e3:	68 92 0e 80 00       	push   $0x800e92
  8010e8:	57                   	push   %edi
  8010e9:	e8 fe fc ff ff       	call   800dec <sys_env_set_pgfault_upcall>

    //5. The child is now ready to run, so the parent marks it runnable.
    sys_env_set_status(envid, ENV_RUNNABLE);
  8010ee:	83 c4 08             	add    $0x8,%esp
  8010f1:	6a 02                	push   $0x2
  8010f3:	57                   	push   %edi
  8010f4:	e8 b1 fc ff ff       	call   800daa <sys_env_set_status>

    return envid;
  8010f9:	83 c4 10             	add    $0x10,%esp
    panic("fork not implemented");
}
  8010fc:	89 f8                	mov    %edi,%eax
  8010fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <sfork>:

// Challenge!
int
sfork(void) {
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 0c             	sub    $0xc,%esp
    panic("sfork not implemented");
  80110c:	68 bb 18 80 00       	push   $0x8018bb
  801111:	68 b2 00 00 00       	push   $0xb2
  801116:	68 4c 18 80 00       	push   $0x80184c
  80111b:	e8 67 00 00 00       	call   801187 <_panic>

00801120 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801126:	68 d1 18 80 00       	push   $0x8018d1
  80112b:	6a 1a                	push   $0x1a
  80112d:	68 ea 18 80 00       	push   $0x8018ea
  801132:	e8 50 00 00 00       	call   801187 <_panic>

00801137 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80113d:	68 f4 18 80 00       	push   $0x8018f4
  801142:	6a 2a                	push   $0x2a
  801144:	68 ea 18 80 00       	push   $0x8018ea
  801149:	e8 39 00 00 00       	call   801187 <_panic>

0080114e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801159:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80115c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801162:	8b 52 50             	mov    0x50(%edx),%edx
  801165:	39 ca                	cmp    %ecx,%edx
  801167:	74 11                	je     80117a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801169:	83 c0 01             	add    $0x1,%eax
  80116c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801171:	75 e6                	jne    801159 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801173:	b8 00 00 00 00       	mov    $0x0,%eax
  801178:	eb 0b                	jmp    801185 <ipc_find_env+0x37>
			return envs[i].env_id;
  80117a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80117d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801182:	8b 40 48             	mov    0x48(%eax),%eax
}
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80118c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80118f:	8b 35 08 20 80 00    	mov    0x802008,%esi
  801195:	e8 0b fb ff ff       	call   800ca5 <sys_getenvid>
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	ff 75 0c             	pushl  0xc(%ebp)
  8011a0:	ff 75 08             	pushl  0x8(%ebp)
  8011a3:	56                   	push   %esi
  8011a4:	50                   	push   %eax
  8011a5:	68 10 19 80 00       	push   $0x801910
  8011aa:	e8 dd f0 ff ff       	call   80028c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011af:	83 c4 18             	add    $0x18,%esp
  8011b2:	53                   	push   %ebx
  8011b3:	ff 75 10             	pushl  0x10(%ebp)
  8011b6:	e8 80 f0 ff ff       	call   80023b <vcprintf>
	cprintf("\n");
  8011bb:	c7 04 24 84 18 80 00 	movl   $0x801884,(%esp)
  8011c2:	e8 c5 f0 ff ff       	call   80028c <cprintf>
  8011c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011ca:	cc                   	int3   
  8011cb:	eb fd                	jmp    8011ca <_panic+0x43>

008011cd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011d3:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  8011da:	74 0a                	je     8011e6 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	a3 10 20 80 00       	mov    %eax,0x802010
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  8011e6:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8011eb:	8b 40 48             	mov    0x48(%eax),%eax
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	6a 07                	push   $0x7
  8011f3:	68 00 f0 bf ee       	push   $0xeebff000
  8011f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011fd:	50                   	push   %eax
  8011fe:	e8 e0 fa ff ff       	call   800ce3 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  801203:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801208:	8b 40 48             	mov    0x48(%eax),%eax
  80120b:	83 c4 08             	add    $0x8,%esp
  80120e:	68 23 12 80 00       	push   $0x801223
  801213:	25 ff 03 00 00       	and    $0x3ff,%eax
  801218:	50                   	push   %eax
  801219:	e8 ce fb ff ff       	call   800dec <sys_env_set_pgfault_upcall>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	eb b9                	jmp    8011dc <set_pgfault_handler+0xf>

00801223 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801223:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801224:	a1 10 20 80 00       	mov    0x802010,%eax
	call *%eax
  801229:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80122b:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  80122e:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  801232:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  801236:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  801239:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  80123b:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  80123f:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  801242:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  801243:	83 c4 04             	add    $0x4,%esp
    popfl
  801246:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  801247:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801248:	c3                   	ret    
  801249:	66 90                	xchg   %ax,%ax
  80124b:	66 90                	xchg   %ax,%ax
  80124d:	66 90                	xchg   %ax,%ax
  80124f:	90                   	nop

00801250 <__udivdi3>:
  801250:	55                   	push   %ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	83 ec 1c             	sub    $0x1c,%esp
  801257:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80125b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80125f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801263:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801267:	85 d2                	test   %edx,%edx
  801269:	75 35                	jne    8012a0 <__udivdi3+0x50>
  80126b:	39 f3                	cmp    %esi,%ebx
  80126d:	0f 87 bd 00 00 00    	ja     801330 <__udivdi3+0xe0>
  801273:	85 db                	test   %ebx,%ebx
  801275:	89 d9                	mov    %ebx,%ecx
  801277:	75 0b                	jne    801284 <__udivdi3+0x34>
  801279:	b8 01 00 00 00       	mov    $0x1,%eax
  80127e:	31 d2                	xor    %edx,%edx
  801280:	f7 f3                	div    %ebx
  801282:	89 c1                	mov    %eax,%ecx
  801284:	31 d2                	xor    %edx,%edx
  801286:	89 f0                	mov    %esi,%eax
  801288:	f7 f1                	div    %ecx
  80128a:	89 c6                	mov    %eax,%esi
  80128c:	89 e8                	mov    %ebp,%eax
  80128e:	89 f7                	mov    %esi,%edi
  801290:	f7 f1                	div    %ecx
  801292:	89 fa                	mov    %edi,%edx
  801294:	83 c4 1c             	add    $0x1c,%esp
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5f                   	pop    %edi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    
  80129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012a0:	39 f2                	cmp    %esi,%edx
  8012a2:	77 7c                	ja     801320 <__udivdi3+0xd0>
  8012a4:	0f bd fa             	bsr    %edx,%edi
  8012a7:	83 f7 1f             	xor    $0x1f,%edi
  8012aa:	0f 84 98 00 00 00    	je     801348 <__udivdi3+0xf8>
  8012b0:	89 f9                	mov    %edi,%ecx
  8012b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8012b7:	29 f8                	sub    %edi,%eax
  8012b9:	d3 e2                	shl    %cl,%edx
  8012bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012bf:	89 c1                	mov    %eax,%ecx
  8012c1:	89 da                	mov    %ebx,%edx
  8012c3:	d3 ea                	shr    %cl,%edx
  8012c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8012c9:	09 d1                	or     %edx,%ecx
  8012cb:	89 f2                	mov    %esi,%edx
  8012cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012d1:	89 f9                	mov    %edi,%ecx
  8012d3:	d3 e3                	shl    %cl,%ebx
  8012d5:	89 c1                	mov    %eax,%ecx
  8012d7:	d3 ea                	shr    %cl,%edx
  8012d9:	89 f9                	mov    %edi,%ecx
  8012db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012df:	d3 e6                	shl    %cl,%esi
  8012e1:	89 eb                	mov    %ebp,%ebx
  8012e3:	89 c1                	mov    %eax,%ecx
  8012e5:	d3 eb                	shr    %cl,%ebx
  8012e7:	09 de                	or     %ebx,%esi
  8012e9:	89 f0                	mov    %esi,%eax
  8012eb:	f7 74 24 08          	divl   0x8(%esp)
  8012ef:	89 d6                	mov    %edx,%esi
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	f7 64 24 0c          	mull   0xc(%esp)
  8012f7:	39 d6                	cmp    %edx,%esi
  8012f9:	72 0c                	jb     801307 <__udivdi3+0xb7>
  8012fb:	89 f9                	mov    %edi,%ecx
  8012fd:	d3 e5                	shl    %cl,%ebp
  8012ff:	39 c5                	cmp    %eax,%ebp
  801301:	73 5d                	jae    801360 <__udivdi3+0x110>
  801303:	39 d6                	cmp    %edx,%esi
  801305:	75 59                	jne    801360 <__udivdi3+0x110>
  801307:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80130a:	31 ff                	xor    %edi,%edi
  80130c:	89 fa                	mov    %edi,%edx
  80130e:	83 c4 1c             	add    $0x1c,%esp
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5f                   	pop    %edi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    
  801316:	8d 76 00             	lea    0x0(%esi),%esi
  801319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801320:	31 ff                	xor    %edi,%edi
  801322:	31 c0                	xor    %eax,%eax
  801324:	89 fa                	mov    %edi,%edx
  801326:	83 c4 1c             	add    $0x1c,%esp
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5f                   	pop    %edi
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    
  80132e:	66 90                	xchg   %ax,%ax
  801330:	31 ff                	xor    %edi,%edi
  801332:	89 e8                	mov    %ebp,%eax
  801334:	89 f2                	mov    %esi,%edx
  801336:	f7 f3                	div    %ebx
  801338:	89 fa                	mov    %edi,%edx
  80133a:	83 c4 1c             	add    $0x1c,%esp
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5f                   	pop    %edi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    
  801342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801348:	39 f2                	cmp    %esi,%edx
  80134a:	72 06                	jb     801352 <__udivdi3+0x102>
  80134c:	31 c0                	xor    %eax,%eax
  80134e:	39 eb                	cmp    %ebp,%ebx
  801350:	77 d2                	ja     801324 <__udivdi3+0xd4>
  801352:	b8 01 00 00 00       	mov    $0x1,%eax
  801357:	eb cb                	jmp    801324 <__udivdi3+0xd4>
  801359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801360:	89 d8                	mov    %ebx,%eax
  801362:	31 ff                	xor    %edi,%edi
  801364:	eb be                	jmp    801324 <__udivdi3+0xd4>
  801366:	66 90                	xchg   %ax,%ax
  801368:	66 90                	xchg   %ax,%ax
  80136a:	66 90                	xchg   %ax,%ax
  80136c:	66 90                	xchg   %ax,%ax
  80136e:	66 90                	xchg   %ax,%ax

00801370 <__umoddi3>:
  801370:	55                   	push   %ebp
  801371:	57                   	push   %edi
  801372:	56                   	push   %esi
  801373:	53                   	push   %ebx
  801374:	83 ec 1c             	sub    $0x1c,%esp
  801377:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80137b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80137f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801387:	85 ed                	test   %ebp,%ebp
  801389:	89 f0                	mov    %esi,%eax
  80138b:	89 da                	mov    %ebx,%edx
  80138d:	75 19                	jne    8013a8 <__umoddi3+0x38>
  80138f:	39 df                	cmp    %ebx,%edi
  801391:	0f 86 b1 00 00 00    	jbe    801448 <__umoddi3+0xd8>
  801397:	f7 f7                	div    %edi
  801399:	89 d0                	mov    %edx,%eax
  80139b:	31 d2                	xor    %edx,%edx
  80139d:	83 c4 1c             	add    $0x1c,%esp
  8013a0:	5b                   	pop    %ebx
  8013a1:	5e                   	pop    %esi
  8013a2:	5f                   	pop    %edi
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    
  8013a5:	8d 76 00             	lea    0x0(%esi),%esi
  8013a8:	39 dd                	cmp    %ebx,%ebp
  8013aa:	77 f1                	ja     80139d <__umoddi3+0x2d>
  8013ac:	0f bd cd             	bsr    %ebp,%ecx
  8013af:	83 f1 1f             	xor    $0x1f,%ecx
  8013b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013b6:	0f 84 b4 00 00 00    	je     801470 <__umoddi3+0x100>
  8013bc:	b8 20 00 00 00       	mov    $0x20,%eax
  8013c1:	89 c2                	mov    %eax,%edx
  8013c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013c7:	29 c2                	sub    %eax,%edx
  8013c9:	89 c1                	mov    %eax,%ecx
  8013cb:	89 f8                	mov    %edi,%eax
  8013cd:	d3 e5                	shl    %cl,%ebp
  8013cf:	89 d1                	mov    %edx,%ecx
  8013d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013d5:	d3 e8                	shr    %cl,%eax
  8013d7:	09 c5                	or     %eax,%ebp
  8013d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013dd:	89 c1                	mov    %eax,%ecx
  8013df:	d3 e7                	shl    %cl,%edi
  8013e1:	89 d1                	mov    %edx,%ecx
  8013e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013e7:	89 df                	mov    %ebx,%edi
  8013e9:	d3 ef                	shr    %cl,%edi
  8013eb:	89 c1                	mov    %eax,%ecx
  8013ed:	89 f0                	mov    %esi,%eax
  8013ef:	d3 e3                	shl    %cl,%ebx
  8013f1:	89 d1                	mov    %edx,%ecx
  8013f3:	89 fa                	mov    %edi,%edx
  8013f5:	d3 e8                	shr    %cl,%eax
  8013f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013fc:	09 d8                	or     %ebx,%eax
  8013fe:	f7 f5                	div    %ebp
  801400:	d3 e6                	shl    %cl,%esi
  801402:	89 d1                	mov    %edx,%ecx
  801404:	f7 64 24 08          	mull   0x8(%esp)
  801408:	39 d1                	cmp    %edx,%ecx
  80140a:	89 c3                	mov    %eax,%ebx
  80140c:	89 d7                	mov    %edx,%edi
  80140e:	72 06                	jb     801416 <__umoddi3+0xa6>
  801410:	75 0e                	jne    801420 <__umoddi3+0xb0>
  801412:	39 c6                	cmp    %eax,%esi
  801414:	73 0a                	jae    801420 <__umoddi3+0xb0>
  801416:	2b 44 24 08          	sub    0x8(%esp),%eax
  80141a:	19 ea                	sbb    %ebp,%edx
  80141c:	89 d7                	mov    %edx,%edi
  80141e:	89 c3                	mov    %eax,%ebx
  801420:	89 ca                	mov    %ecx,%edx
  801422:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801427:	29 de                	sub    %ebx,%esi
  801429:	19 fa                	sbb    %edi,%edx
  80142b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80142f:	89 d0                	mov    %edx,%eax
  801431:	d3 e0                	shl    %cl,%eax
  801433:	89 d9                	mov    %ebx,%ecx
  801435:	d3 ee                	shr    %cl,%esi
  801437:	d3 ea                	shr    %cl,%edx
  801439:	09 f0                	or     %esi,%eax
  80143b:	83 c4 1c             	add    $0x1c,%esp
  80143e:	5b                   	pop    %ebx
  80143f:	5e                   	pop    %esi
  801440:	5f                   	pop    %edi
  801441:	5d                   	pop    %ebp
  801442:	c3                   	ret    
  801443:	90                   	nop
  801444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801448:	85 ff                	test   %edi,%edi
  80144a:	89 f9                	mov    %edi,%ecx
  80144c:	75 0b                	jne    801459 <__umoddi3+0xe9>
  80144e:	b8 01 00 00 00       	mov    $0x1,%eax
  801453:	31 d2                	xor    %edx,%edx
  801455:	f7 f7                	div    %edi
  801457:	89 c1                	mov    %eax,%ecx
  801459:	89 d8                	mov    %ebx,%eax
  80145b:	31 d2                	xor    %edx,%edx
  80145d:	f7 f1                	div    %ecx
  80145f:	89 f0                	mov    %esi,%eax
  801461:	f7 f1                	div    %ecx
  801463:	e9 31 ff ff ff       	jmp    801399 <__umoddi3+0x29>
  801468:	90                   	nop
  801469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801470:	39 dd                	cmp    %ebx,%ebp
  801472:	72 08                	jb     80147c <__umoddi3+0x10c>
  801474:	39 f7                	cmp    %esi,%edi
  801476:	0f 87 21 ff ff ff    	ja     80139d <__umoddi3+0x2d>
  80147c:	89 da                	mov    %ebx,%edx
  80147e:	89 f0                	mov    %esi,%eax
  801480:	29 f8                	sub    %edi,%eax
  801482:	19 ea                	sbb    %ebp,%edx
  801484:	e9 14 ff ff ff       	jmp    80139d <__umoddi3+0x2d>
