
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
  800039:	e8 44 0e 00 00       	call   800e82 <fork>
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
  800057:	e8 54 0e 00 00       	call   800eb0 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	68 00 00 b0 00       	push   $0xb00000
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 a0 11 80 00       	push   $0x8011a0
  80006c:	e8 0b 02 00 00       	call   80027c <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800071:	83 c4 04             	add    $0x4,%esp
  800074:	ff 35 04 20 80 00    	pushl  0x802004
  80007a:	e8 24 08 00 00       	call   8008a3 <strlen>
  80007f:	83 c4 0c             	add    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	ff 35 04 20 80 00    	pushl  0x802004
  800089:	68 00 00 b0 00       	push   $0xb00000
  80008e:	e8 13 09 00 00       	call   8009a6 <strncmp>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	74 3b                	je     8000d5 <umain+0xa2>
			cprintf("child received correct message\n");

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 35 00 20 80 00    	pushl  0x802000
  8000a3:	e8 fb 07 00 00       	call   8008a3 <strlen>
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	83 c0 01             	add    $0x1,%eax
  8000ae:	50                   	push   %eax
  8000af:	ff 35 00 20 80 00    	pushl  0x802000
  8000b5:	68 00 00 b0 00       	push   $0xb00000
  8000ba:	e8 11 0a 00 00       	call   800ad0 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000bf:	6a 07                	push   $0x7
  8000c1:	68 00 00 b0 00       	push   $0xb00000
  8000c6:	6a 00                	push   $0x0
  8000c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8000cb:	e8 f7 0d 00 00       	call   800ec7 <ipc_send>
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
  8000d8:	68 b4 11 80 00       	push   $0x8011b4
  8000dd:	e8 9a 01 00 00       	call   80027c <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb b3                	jmp    80009a <umain+0x67>
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000e7:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8000ec:	8b 40 48             	mov    0x48(%eax),%eax
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	6a 07                	push   $0x7
  8000f4:	68 00 00 a0 00       	push   $0xa00000
  8000f9:	50                   	push   %eax
  8000fa:	e8 d4 0b 00 00       	call   800cd3 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8000ff:	83 c4 04             	add    $0x4,%esp
  800102:	ff 35 04 20 80 00    	pushl  0x802004
  800108:	e8 96 07 00 00       	call   8008a3 <strlen>
  80010d:	83 c4 0c             	add    $0xc,%esp
  800110:	83 c0 01             	add    $0x1,%eax
  800113:	50                   	push   %eax
  800114:	ff 35 04 20 80 00    	pushl  0x802004
  80011a:	68 00 00 a0 00       	push   $0xa00000
  80011f:	e8 ac 09 00 00       	call   800ad0 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800124:	6a 07                	push   $0x7
  800126:	68 00 00 a0 00       	push   $0xa00000
  80012b:	6a 00                	push   $0x0
  80012d:	ff 75 f4             	pushl  -0xc(%ebp)
  800130:	e8 92 0d 00 00       	call   800ec7 <ipc_send>
	ipc_recv(&who, TEMP_ADDR, 0);
  800135:	83 c4 1c             	add    $0x1c,%esp
  800138:	6a 00                	push   $0x0
  80013a:	68 00 00 a0 00       	push   $0xa00000
  80013f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 68 0d 00 00       	call   800eb0 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	68 00 00 a0 00       	push   $0xa00000
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	68 a0 11 80 00       	push   $0x8011a0
  800158:	e8 1f 01 00 00       	call   80027c <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  80015d:	83 c4 04             	add    $0x4,%esp
  800160:	ff 35 00 20 80 00    	pushl  0x802000
  800166:	e8 38 07 00 00       	call   8008a3 <strlen>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 35 00 20 80 00    	pushl  0x802000
  800175:	68 00 00 a0 00       	push   $0xa00000
  80017a:	e8 27 08 00 00       	call   8009a6 <strncmp>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	0f 85 49 ff ff ff    	jne    8000d3 <umain+0xa0>
		cprintf("parent received correct message\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 d4 11 80 00       	push   $0x8011d4
  800192:	e8 e5 00 00 00       	call   80027c <cprintf>
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
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8001ab:	c7 05 0c 20 80 00 00 	movl   $0xeec00000,0x80200c
  8001b2:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b5:	85 c0                	test   %eax,%eax
  8001b7:	7e 08                	jle    8001c1 <libmain+0x22>
		binaryname = argv[0];
  8001b9:	8b 0a                	mov    (%edx),%ecx
  8001bb:	89 0d 08 20 80 00    	mov    %ecx,0x802008

	// call user main routine
	umain(argc, argv);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	52                   	push   %edx
  8001c5:	50                   	push   %eax
  8001c6:	e8 68 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001cb:	e8 05 00 00 00       	call   8001d5 <exit>
}
  8001d0:	83 c4 10             	add    $0x10,%esp
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    

008001d5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8001db:	6a 00                	push   $0x0
  8001dd:	e8 72 0a 00 00       	call   800c54 <sys_env_destroy>
}
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	53                   	push   %ebx
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f1:	8b 13                	mov    (%ebx),%edx
  8001f3:	8d 42 01             	lea    0x1(%edx),%eax
  8001f6:	89 03                	mov    %eax,(%ebx)
  8001f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800204:	74 09                	je     80020f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800206:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	68 ff 00 00 00       	push   $0xff
  800217:	8d 43 08             	lea    0x8(%ebx),%eax
  80021a:	50                   	push   %eax
  80021b:	e8 f7 09 00 00       	call   800c17 <sys_cputs>
		b->idx = 0;
  800220:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	eb db                	jmp    800206 <putch+0x1f>

0080022b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800234:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023b:	00 00 00 
	b.cnt = 0;
  80023e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800245:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800254:	50                   	push   %eax
  800255:	68 e7 01 80 00       	push   $0x8001e7
  80025a:	e8 1a 01 00 00       	call   800379 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025f:	83 c4 08             	add    $0x8,%esp
  800262:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800268:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026e:	50                   	push   %eax
  80026f:	e8 a3 09 00 00       	call   800c17 <sys_cputs>

	return b.cnt;
}
  800274:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800282:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800285:	50                   	push   %eax
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 9d ff ff ff       	call   80022b <vcprintf>
	va_end(ap);

	return cnt;
}
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 1c             	sub    $0x1c,%esp
  800299:	89 c7                	mov    %eax,%edi
  80029b:	89 d6                	mov    %edx,%esi
  80029d:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002b4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002b7:	39 d3                	cmp    %edx,%ebx
  8002b9:	72 05                	jb     8002c0 <printnum+0x30>
  8002bb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002be:	77 7a                	ja     80033a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	ff 75 18             	pushl  0x18(%ebp)
  8002c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002cc:	53                   	push   %ebx
  8002cd:	ff 75 10             	pushl  0x10(%ebp)
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8002df:	e8 7c 0c 00 00       	call   800f60 <__udivdi3>
  8002e4:	83 c4 18             	add    $0x18,%esp
  8002e7:	52                   	push   %edx
  8002e8:	50                   	push   %eax
  8002e9:	89 f2                	mov    %esi,%edx
  8002eb:	89 f8                	mov    %edi,%eax
  8002ed:	e8 9e ff ff ff       	call   800290 <printnum>
  8002f2:	83 c4 20             	add    $0x20,%esp
  8002f5:	eb 13                	jmp    80030a <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f7:	83 ec 08             	sub    $0x8,%esp
  8002fa:	56                   	push   %esi
  8002fb:	ff 75 18             	pushl  0x18(%ebp)
  8002fe:	ff d7                	call   *%edi
  800300:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800303:	83 eb 01             	sub    $0x1,%ebx
  800306:	85 db                	test   %ebx,%ebx
  800308:	7f ed                	jg     8002f7 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	56                   	push   %esi
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	ff 75 e4             	pushl  -0x1c(%ebp)
  800314:	ff 75 e0             	pushl  -0x20(%ebp)
  800317:	ff 75 dc             	pushl  -0x24(%ebp)
  80031a:	ff 75 d8             	pushl  -0x28(%ebp)
  80031d:	e8 5e 0d 00 00       	call   801080 <__umoddi3>
  800322:	83 c4 14             	add    $0x14,%esp
  800325:	0f be 80 4c 12 80 00 	movsbl 0x80124c(%eax),%eax
  80032c:	50                   	push   %eax
  80032d:	ff d7                	call   *%edi
}
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800335:	5b                   	pop    %ebx
  800336:	5e                   	pop    %esi
  800337:	5f                   	pop    %edi
  800338:	5d                   	pop    %ebp
  800339:	c3                   	ret    
  80033a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80033d:	eb c4                	jmp    800303 <printnum+0x73>

0080033f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800345:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800349:	8b 10                	mov    (%eax),%edx
  80034b:	3b 50 04             	cmp    0x4(%eax),%edx
  80034e:	73 0a                	jae    80035a <sprintputch+0x1b>
		*b->buf++ = ch;
  800350:	8d 4a 01             	lea    0x1(%edx),%ecx
  800353:	89 08                	mov    %ecx,(%eax)
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	88 02                	mov    %al,(%edx)
}
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <printfmt>:
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800362:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 05 00 00 00       	call   800379 <vprintfmt>
}
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <vprintfmt>:
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	57                   	push   %edi
  80037d:	56                   	push   %esi
  80037e:	53                   	push   %ebx
  80037f:	83 ec 2c             	sub    $0x2c,%esp
  800382:	8b 75 08             	mov    0x8(%ebp),%esi
  800385:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800388:	8b 7d 10             	mov    0x10(%ebp),%edi
  80038b:	e9 00 04 00 00       	jmp    800790 <vprintfmt+0x417>
		padc = ' ';
  800390:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800394:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80039b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	8d 47 01             	lea    0x1(%edi),%eax
  8003b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b4:	0f b6 17             	movzbl (%edi),%edx
  8003b7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ba:	3c 55                	cmp    $0x55,%al
  8003bc:	0f 87 51 04 00 00    	ja     800813 <vprintfmt+0x49a>
  8003c2:	0f b6 c0             	movzbl %al,%eax
  8003c5:	ff 24 85 20 13 80 00 	jmp    *0x801320(,%eax,4)
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003cf:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003d3:	eb d9                	jmp    8003ae <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003dc:	eb d0                	jmp    8003ae <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	0f b6 d2             	movzbl %dl,%edx
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003ec:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ef:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003f9:	83 f9 09             	cmp    $0x9,%ecx
  8003fc:	77 55                	ja     800453 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003fe:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800401:	eb e9                	jmp    8003ec <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 40 04             	lea    0x4(%eax),%eax
  800411:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041b:	79 91                	jns    8003ae <vprintfmt+0x35>
				width = precision, precision = -1;
  80041d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800420:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800423:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80042a:	eb 82                	jmp    8003ae <vprintfmt+0x35>
  80042c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042f:	85 c0                	test   %eax,%eax
  800431:	ba 00 00 00 00       	mov    $0x0,%edx
  800436:	0f 49 d0             	cmovns %eax,%edx
  800439:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80043f:	e9 6a ff ff ff       	jmp    8003ae <vprintfmt+0x35>
  800444:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800447:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80044e:	e9 5b ff ff ff       	jmp    8003ae <vprintfmt+0x35>
  800453:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800456:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800459:	eb bc                	jmp    800417 <vprintfmt+0x9e>
			lflag++;
  80045b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800461:	e9 48 ff ff ff       	jmp    8003ae <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800466:	8b 45 14             	mov    0x14(%ebp),%eax
  800469:	8d 78 04             	lea    0x4(%eax),%edi
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	53                   	push   %ebx
  800470:	ff 30                	pushl  (%eax)
  800472:	ff d6                	call   *%esi
			break;
  800474:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800477:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80047a:	e9 0e 03 00 00       	jmp    80078d <vprintfmt+0x414>
			err = va_arg(ap, int);
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	8d 78 04             	lea    0x4(%eax),%edi
  800485:	8b 00                	mov    (%eax),%eax
  800487:	99                   	cltd   
  800488:	31 d0                	xor    %edx,%eax
  80048a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048c:	83 f8 08             	cmp    $0x8,%eax
  80048f:	7f 23                	jg     8004b4 <vprintfmt+0x13b>
  800491:	8b 14 85 80 14 80 00 	mov    0x801480(,%eax,4),%edx
  800498:	85 d2                	test   %edx,%edx
  80049a:	74 18                	je     8004b4 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80049c:	52                   	push   %edx
  80049d:	68 6d 12 80 00       	push   $0x80126d
  8004a2:	53                   	push   %ebx
  8004a3:	56                   	push   %esi
  8004a4:	e8 b3 fe ff ff       	call   80035c <printfmt>
  8004a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ac:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004af:	e9 d9 02 00 00       	jmp    80078d <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8004b4:	50                   	push   %eax
  8004b5:	68 64 12 80 00       	push   $0x801264
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 9b fe ff ff       	call   80035c <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c7:	e9 c1 02 00 00       	jmp    80078d <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	83 c0 04             	add    $0x4,%eax
  8004d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004da:	85 ff                	test   %edi,%edi
  8004dc:	b8 5d 12 80 00       	mov    $0x80125d,%eax
  8004e1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e8:	0f 8e bd 00 00 00    	jle    8005ab <vprintfmt+0x232>
  8004ee:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004f2:	75 0e                	jne    800502 <vprintfmt+0x189>
  8004f4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004fa:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004fd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800500:	eb 6d                	jmp    80056f <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	ff 75 d0             	pushl  -0x30(%ebp)
  800508:	57                   	push   %edi
  800509:	e8 ad 03 00 00       	call   8008bb <strnlen>
  80050e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800511:	29 c1                	sub    %eax,%ecx
  800513:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800516:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800519:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80051d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800520:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800523:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800525:	eb 0f                	jmp    800536 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	53                   	push   %ebx
  80052b:	ff 75 e0             	pushl  -0x20(%ebp)
  80052e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800530:	83 ef 01             	sub    $0x1,%edi
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	85 ff                	test   %edi,%edi
  800538:	7f ed                	jg     800527 <vprintfmt+0x1ae>
  80053a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80053d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800540:	85 c9                	test   %ecx,%ecx
  800542:	b8 00 00 00 00       	mov    $0x0,%eax
  800547:	0f 49 c1             	cmovns %ecx,%eax
  80054a:	29 c1                	sub    %eax,%ecx
  80054c:	89 75 08             	mov    %esi,0x8(%ebp)
  80054f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800552:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800555:	89 cb                	mov    %ecx,%ebx
  800557:	eb 16                	jmp    80056f <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800559:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80055d:	75 31                	jne    800590 <vprintfmt+0x217>
					putch(ch, putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 0c             	pushl  0xc(%ebp)
  800565:	50                   	push   %eax
  800566:	ff 55 08             	call   *0x8(%ebp)
  800569:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80056c:	83 eb 01             	sub    $0x1,%ebx
  80056f:	83 c7 01             	add    $0x1,%edi
  800572:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800576:	0f be c2             	movsbl %dl,%eax
  800579:	85 c0                	test   %eax,%eax
  80057b:	74 59                	je     8005d6 <vprintfmt+0x25d>
  80057d:	85 f6                	test   %esi,%esi
  80057f:	78 d8                	js     800559 <vprintfmt+0x1e0>
  800581:	83 ee 01             	sub    $0x1,%esi
  800584:	79 d3                	jns    800559 <vprintfmt+0x1e0>
  800586:	89 df                	mov    %ebx,%edi
  800588:	8b 75 08             	mov    0x8(%ebp),%esi
  80058b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80058e:	eb 37                	jmp    8005c7 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800590:	0f be d2             	movsbl %dl,%edx
  800593:	83 ea 20             	sub    $0x20,%edx
  800596:	83 fa 5e             	cmp    $0x5e,%edx
  800599:	76 c4                	jbe    80055f <vprintfmt+0x1e6>
					putch('?', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 0c             	pushl  0xc(%ebp)
  8005a1:	6a 3f                	push   $0x3f
  8005a3:	ff 55 08             	call   *0x8(%ebp)
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	eb c1                	jmp    80056c <vprintfmt+0x1f3>
  8005ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005b7:	eb b6                	jmp    80056f <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 20                	push   $0x20
  8005bf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005c1:	83 ef 01             	sub    $0x1,%edi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	85 ff                	test   %edi,%edi
  8005c9:	7f ee                	jg     8005b9 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d1:	e9 b7 01 00 00       	jmp    80078d <vprintfmt+0x414>
  8005d6:	89 df                	mov    %ebx,%edi
  8005d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005de:	eb e7                	jmp    8005c7 <vprintfmt+0x24e>
	if (lflag >= 2)
  8005e0:	83 f9 01             	cmp    $0x1,%ecx
  8005e3:	7e 3f                	jle    800624 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 50 04             	mov    0x4(%eax),%edx
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8d 40 08             	lea    0x8(%eax),%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800600:	79 5c                	jns    80065e <vprintfmt+0x2e5>
				putch('-', putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	6a 2d                	push   $0x2d
  800608:	ff d6                	call   *%esi
				num = -(long long) num;
  80060a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80060d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800610:	f7 da                	neg    %edx
  800612:	83 d1 00             	adc    $0x0,%ecx
  800615:	f7 d9                	neg    %ecx
  800617:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061f:	e9 4f 01 00 00       	jmp    800773 <vprintfmt+0x3fa>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	75 1b                	jne    800643 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800630:	89 c1                	mov    %eax,%ecx
  800632:	c1 f9 1f             	sar    $0x1f,%ecx
  800635:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
  800641:	eb b9                	jmp    8005fc <vprintfmt+0x283>
		return va_arg(*ap, long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064b:	89 c1                	mov    %eax,%ecx
  80064d:	c1 f9 1f             	sar    $0x1f,%ecx
  800650:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	eb 9e                	jmp    8005fc <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80065e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800661:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800664:	b8 0a 00 00 00       	mov    $0xa,%eax
  800669:	e9 05 01 00 00       	jmp    800773 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80066e:	83 f9 01             	cmp    $0x1,%ecx
  800671:	7e 18                	jle    80068b <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	8b 48 04             	mov    0x4(%eax),%ecx
  80067b:	8d 40 08             	lea    0x8(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800681:	b8 0a 00 00 00       	mov    $0xa,%eax
  800686:	e9 e8 00 00 00       	jmp    800773 <vprintfmt+0x3fa>
	else if (lflag)
  80068b:	85 c9                	test   %ecx,%ecx
  80068d:	75 1a                	jne    8006a9 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 10                	mov    (%eax),%edx
  800694:	b9 00 00 00 00       	mov    $0x0,%ecx
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a4:	e9 ca 00 00 00       	jmp    800773 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 10                	mov    (%eax),%edx
  8006ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006be:	e9 b0 00 00 00       	jmp    800773 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8006c3:	83 f9 01             	cmp    $0x1,%ecx
  8006c6:	7e 3c                	jle    800704 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 08             	lea    0x8(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8006df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e3:	79 59                	jns    80073e <vprintfmt+0x3c5>
                putch('-', putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	6a 2d                	push   $0x2d
  8006eb:	ff d6                	call   *%esi
                num = -(long long) num;
  8006ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006f3:	f7 da                	neg    %edx
  8006f5:	83 d1 00             	adc    $0x0,%ecx
  8006f8:	f7 d9                	neg    %ecx
  8006fa:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8006fd:	b8 08 00 00 00       	mov    $0x8,%eax
  800702:	eb 6f                	jmp    800773 <vprintfmt+0x3fa>
	else if (lflag)
  800704:	85 c9                	test   %ecx,%ecx
  800706:	75 1b                	jne    800723 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 c1                	mov    %eax,%ecx
  800712:	c1 f9 1f             	sar    $0x1f,%ecx
  800715:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
  800721:	eb bc                	jmp    8006df <vprintfmt+0x366>
		return va_arg(*ap, long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072b:	89 c1                	mov    %eax,%ecx
  80072d:	c1 f9 1f             	sar    $0x1f,%ecx
  800730:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
  80073c:	eb a1                	jmp    8006df <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80073e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800741:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800744:	b8 08 00 00 00       	mov    $0x8,%eax
  800749:	eb 28                	jmp    800773 <vprintfmt+0x3fa>
			putch('0', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 30                	push   $0x30
  800751:	ff d6                	call   *%esi
			putch('x', putdat);
  800753:	83 c4 08             	add    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	6a 78                	push   $0x78
  800759:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 10                	mov    (%eax),%edx
  800760:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800765:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800768:	8d 40 04             	lea    0x4(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80077a:	57                   	push   %edi
  80077b:	ff 75 e0             	pushl  -0x20(%ebp)
  80077e:	50                   	push   %eax
  80077f:	51                   	push   %ecx
  800780:	52                   	push   %edx
  800781:	89 da                	mov    %ebx,%edx
  800783:	89 f0                	mov    %esi,%eax
  800785:	e8 06 fb ff ff       	call   800290 <printnum>
			break;
  80078a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80078d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800790:	83 c7 01             	add    $0x1,%edi
  800793:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800797:	83 f8 25             	cmp    $0x25,%eax
  80079a:	0f 84 f0 fb ff ff    	je     800390 <vprintfmt+0x17>
			if (ch == '\0')
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	0f 84 8b 00 00 00    	je     800833 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	50                   	push   %eax
  8007ad:	ff d6                	call   *%esi
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	eb dc                	jmp    800790 <vprintfmt+0x417>
	if (lflag >= 2)
  8007b4:	83 f9 01             	cmp    $0x1,%ecx
  8007b7:	7e 15                	jle    8007ce <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 10                	mov    (%eax),%edx
  8007be:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c1:	8d 40 08             	lea    0x8(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cc:	eb a5                	jmp    800773 <vprintfmt+0x3fa>
	else if (lflag)
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	75 17                	jne    8007e9 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 10                	mov    (%eax),%edx
  8007d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e7:	eb 8a                	jmp    800773 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 10                	mov    (%eax),%edx
  8007ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f3:	8d 40 04             	lea    0x4(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fe:	e9 70 ff ff ff       	jmp    800773 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	53                   	push   %ebx
  800807:	6a 25                	push   $0x25
  800809:	ff d6                	call   *%esi
			break;
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	e9 7a ff ff ff       	jmp    80078d <vprintfmt+0x414>
			putch('%', putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	6a 25                	push   $0x25
  800819:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	89 f8                	mov    %edi,%eax
  800820:	eb 03                	jmp    800825 <vprintfmt+0x4ac>
  800822:	83 e8 01             	sub    $0x1,%eax
  800825:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800829:	75 f7                	jne    800822 <vprintfmt+0x4a9>
  80082b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80082e:	e9 5a ff ff ff       	jmp    80078d <vprintfmt+0x414>
}
  800833:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800836:	5b                   	pop    %ebx
  800837:	5e                   	pop    %esi
  800838:	5f                   	pop    %edi
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	83 ec 18             	sub    $0x18,%esp
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800847:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80084e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800858:	85 c0                	test   %eax,%eax
  80085a:	74 26                	je     800882 <vsnprintf+0x47>
  80085c:	85 d2                	test   %edx,%edx
  80085e:	7e 22                	jle    800882 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800860:	ff 75 14             	pushl  0x14(%ebp)
  800863:	ff 75 10             	pushl  0x10(%ebp)
  800866:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800869:	50                   	push   %eax
  80086a:	68 3f 03 80 00       	push   $0x80033f
  80086f:	e8 05 fb ff ff       	call   800379 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800877:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087d:	83 c4 10             	add    $0x10,%esp
}
  800880:	c9                   	leave  
  800881:	c3                   	ret    
		return -E_INVAL;
  800882:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800887:	eb f7                	jmp    800880 <vsnprintf+0x45>

00800889 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800892:	50                   	push   %eax
  800893:	ff 75 10             	pushl  0x10(%ebp)
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 9a ff ff ff       	call   80083b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a1:	c9                   	leave  
  8008a2:	c3                   	ret    

008008a3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ae:	eb 03                	jmp    8008b3 <strlen+0x10>
		n++;
  8008b0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b7:	75 f7                	jne    8008b0 <strlen+0xd>
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c9:	eb 03                	jmp    8008ce <strnlen+0x13>
		n++;
  8008cb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ce:	39 d0                	cmp    %edx,%eax
  8008d0:	74 06                	je     8008d8 <strnlen+0x1d>
  8008d2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d6:	75 f3                	jne    8008cb <strnlen+0x10>
	return n;
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	83 c1 01             	add    $0x1,%ecx
  8008e9:	83 c2 01             	add    $0x1,%edx
  8008ec:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008f0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f3:	84 db                	test   %bl,%bl
  8008f5:	75 ef                	jne    8008e6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800901:	53                   	push   %ebx
  800902:	e8 9c ff ff ff       	call   8008a3 <strlen>
  800907:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	01 d8                	add    %ebx,%eax
  80090f:	50                   	push   %eax
  800910:	e8 c5 ff ff ff       	call   8008da <strcpy>
	return dst;
}
  800915:	89 d8                	mov    %ebx,%eax
  800917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 75 08             	mov    0x8(%ebp),%esi
  800924:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800927:	89 f3                	mov    %esi,%ebx
  800929:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092c:	89 f2                	mov    %esi,%edx
  80092e:	eb 0f                	jmp    80093f <strncpy+0x23>
		*dst++ = *src;
  800930:	83 c2 01             	add    $0x1,%edx
  800933:	0f b6 01             	movzbl (%ecx),%eax
  800936:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800939:	80 39 01             	cmpb   $0x1,(%ecx)
  80093c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80093f:	39 da                	cmp    %ebx,%edx
  800941:	75 ed                	jne    800930 <strncpy+0x14>
	}
	return ret;
}
  800943:	89 f0                	mov    %esi,%eax
  800945:	5b                   	pop    %ebx
  800946:	5e                   	pop    %esi
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	8b 75 08             	mov    0x8(%ebp),%esi
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800957:	89 f0                	mov    %esi,%eax
  800959:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80095d:	85 c9                	test   %ecx,%ecx
  80095f:	75 0b                	jne    80096c <strlcpy+0x23>
  800961:	eb 17                	jmp    80097a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80096c:	39 d8                	cmp    %ebx,%eax
  80096e:	74 07                	je     800977 <strlcpy+0x2e>
  800970:	0f b6 0a             	movzbl (%edx),%ecx
  800973:	84 c9                	test   %cl,%cl
  800975:	75 ec                	jne    800963 <strlcpy+0x1a>
		*dst = '\0';
  800977:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097a:	29 f0                	sub    %esi,%eax
}
  80097c:	5b                   	pop    %ebx
  80097d:	5e                   	pop    %esi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800989:	eb 06                	jmp    800991 <strcmp+0x11>
		p++, q++;
  80098b:	83 c1 01             	add    $0x1,%ecx
  80098e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800991:	0f b6 01             	movzbl (%ecx),%eax
  800994:	84 c0                	test   %al,%al
  800996:	74 04                	je     80099c <strcmp+0x1c>
  800998:	3a 02                	cmp    (%edx),%al
  80099a:	74 ef                	je     80098b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80099c:	0f b6 c0             	movzbl %al,%eax
  80099f:	0f b6 12             	movzbl (%edx),%edx
  8009a2:	29 d0                	sub    %edx,%eax
}
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	53                   	push   %ebx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b0:	89 c3                	mov    %eax,%ebx
  8009b2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b5:	eb 06                	jmp    8009bd <strncmp+0x17>
		n--, p++, q++;
  8009b7:	83 c0 01             	add    $0x1,%eax
  8009ba:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009bd:	39 d8                	cmp    %ebx,%eax
  8009bf:	74 16                	je     8009d7 <strncmp+0x31>
  8009c1:	0f b6 08             	movzbl (%eax),%ecx
  8009c4:	84 c9                	test   %cl,%cl
  8009c6:	74 04                	je     8009cc <strncmp+0x26>
  8009c8:	3a 0a                	cmp    (%edx),%cl
  8009ca:	74 eb                	je     8009b7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cc:	0f b6 00             	movzbl (%eax),%eax
  8009cf:	0f b6 12             	movzbl (%edx),%edx
  8009d2:	29 d0                	sub    %edx,%eax
}
  8009d4:	5b                   	pop    %ebx
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    
		return 0;
  8009d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dc:	eb f6                	jmp    8009d4 <strncmp+0x2e>

008009de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e8:	0f b6 10             	movzbl (%eax),%edx
  8009eb:	84 d2                	test   %dl,%dl
  8009ed:	74 09                	je     8009f8 <strchr+0x1a>
		if (*s == c)
  8009ef:	38 ca                	cmp    %cl,%dl
  8009f1:	74 0a                	je     8009fd <strchr+0x1f>
	for (; *s; s++)
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	eb f0                	jmp    8009e8 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a09:	eb 03                	jmp    800a0e <strfind+0xf>
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a11:	38 ca                	cmp    %cl,%dl
  800a13:	74 04                	je     800a19 <strfind+0x1a>
  800a15:	84 d2                	test   %dl,%dl
  800a17:	75 f2                	jne    800a0b <strfind+0xc>
			break;
	return (char *) s;
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	57                   	push   %edi
  800a1f:	56                   	push   %esi
  800a20:	53                   	push   %ebx
  800a21:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a27:	85 c9                	test   %ecx,%ecx
  800a29:	74 13                	je     800a3e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a31:	75 05                	jne    800a38 <memset+0x1d>
  800a33:	f6 c1 03             	test   $0x3,%cl
  800a36:	74 0d                	je     800a45 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	fc                   	cld    
  800a3c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3e:	89 f8                	mov    %edi,%eax
  800a40:	5b                   	pop    %ebx
  800a41:	5e                   	pop    %esi
  800a42:	5f                   	pop    %edi
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    
		c &= 0xFF;
  800a45:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a49:	89 d3                	mov    %edx,%ebx
  800a4b:	c1 e3 08             	shl    $0x8,%ebx
  800a4e:	89 d0                	mov    %edx,%eax
  800a50:	c1 e0 18             	shl    $0x18,%eax
  800a53:	89 d6                	mov    %edx,%esi
  800a55:	c1 e6 10             	shl    $0x10,%esi
  800a58:	09 f0                	or     %esi,%eax
  800a5a:	09 c2                	or     %eax,%edx
  800a5c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a5e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a61:	89 d0                	mov    %edx,%eax
  800a63:	fc                   	cld    
  800a64:	f3 ab                	rep stos %eax,%es:(%edi)
  800a66:	eb d6                	jmp    800a3e <memset+0x23>

00800a68 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	57                   	push   %edi
  800a6c:	56                   	push   %esi
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a73:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a76:	39 c6                	cmp    %eax,%esi
  800a78:	73 35                	jae    800aaf <memmove+0x47>
  800a7a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a7d:	39 c2                	cmp    %eax,%edx
  800a7f:	76 2e                	jbe    800aaf <memmove+0x47>
		s += n;
		d += n;
  800a81:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a84:	89 d6                	mov    %edx,%esi
  800a86:	09 fe                	or     %edi,%esi
  800a88:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8e:	74 0c                	je     800a9c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a90:	83 ef 01             	sub    $0x1,%edi
  800a93:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a96:	fd                   	std    
  800a97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a99:	fc                   	cld    
  800a9a:	eb 21                	jmp    800abd <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 ef                	jne    800a90 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb ea                	jmp    800a99 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaf:	89 f2                	mov    %esi,%edx
  800ab1:	09 c2                	or     %eax,%edx
  800ab3:	f6 c2 03             	test   $0x3,%dl
  800ab6:	74 09                	je     800ac1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ab8:	89 c7                	mov    %eax,%edi
  800aba:	fc                   	cld    
  800abb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800abd:	5e                   	pop    %esi
  800abe:	5f                   	pop    %edi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac1:	f6 c1 03             	test   $0x3,%cl
  800ac4:	75 f2                	jne    800ab8 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac9:	89 c7                	mov    %eax,%edi
  800acb:	fc                   	cld    
  800acc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ace:	eb ed                	jmp    800abd <memmove+0x55>

00800ad0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ad3:	ff 75 10             	pushl  0x10(%ebp)
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	ff 75 08             	pushl  0x8(%ebp)
  800adc:	e8 87 ff ff ff       	call   800a68 <memmove>
}
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

00800ae3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	56                   	push   %esi
  800ae7:	53                   	push   %ebx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	89 c6                	mov    %eax,%esi
  800af0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af3:	39 f0                	cmp    %esi,%eax
  800af5:	74 1c                	je     800b13 <memcmp+0x30>
		if (*s1 != *s2)
  800af7:	0f b6 08             	movzbl (%eax),%ecx
  800afa:	0f b6 1a             	movzbl (%edx),%ebx
  800afd:	38 d9                	cmp    %bl,%cl
  800aff:	75 08                	jne    800b09 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b01:	83 c0 01             	add    $0x1,%eax
  800b04:	83 c2 01             	add    $0x1,%edx
  800b07:	eb ea                	jmp    800af3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b09:	0f b6 c1             	movzbl %cl,%eax
  800b0c:	0f b6 db             	movzbl %bl,%ebx
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	eb 05                	jmp    800b18 <memcmp+0x35>
	}

	return 0;
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b2a:	39 d0                	cmp    %edx,%eax
  800b2c:	73 09                	jae    800b37 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b2e:	38 08                	cmp    %cl,(%eax)
  800b30:	74 05                	je     800b37 <memfind+0x1b>
	for (; s < ends; s++)
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	eb f3                	jmp    800b2a <memfind+0xe>
			break;
	return (void *) s;
}
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	57                   	push   %edi
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
  800b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b45:	eb 03                	jmp    800b4a <strtol+0x11>
		s++;
  800b47:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b4a:	0f b6 01             	movzbl (%ecx),%eax
  800b4d:	3c 20                	cmp    $0x20,%al
  800b4f:	74 f6                	je     800b47 <strtol+0xe>
  800b51:	3c 09                	cmp    $0x9,%al
  800b53:	74 f2                	je     800b47 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b55:	3c 2b                	cmp    $0x2b,%al
  800b57:	74 2e                	je     800b87 <strtol+0x4e>
	int neg = 0;
  800b59:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b5e:	3c 2d                	cmp    $0x2d,%al
  800b60:	74 2f                	je     800b91 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b62:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b68:	75 05                	jne    800b6f <strtol+0x36>
  800b6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b6d:	74 2c                	je     800b9b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b6f:	85 db                	test   %ebx,%ebx
  800b71:	75 0a                	jne    800b7d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b73:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b78:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7b:	74 28                	je     800ba5 <strtol+0x6c>
		base = 10;
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b85:	eb 50                	jmp    800bd7 <strtol+0x9e>
		s++;
  800b87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8f:	eb d1                	jmp    800b62 <strtol+0x29>
		s++, neg = 1;
  800b91:	83 c1 01             	add    $0x1,%ecx
  800b94:	bf 01 00 00 00       	mov    $0x1,%edi
  800b99:	eb c7                	jmp    800b62 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b9f:	74 0e                	je     800baf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	75 d8                	jne    800b7d <strtol+0x44>
		s++, base = 8;
  800ba5:	83 c1 01             	add    $0x1,%ecx
  800ba8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bad:	eb ce                	jmp    800b7d <strtol+0x44>
		s += 2, base = 16;
  800baf:	83 c1 02             	add    $0x2,%ecx
  800bb2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb7:	eb c4                	jmp    800b7d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bb9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bbc:	89 f3                	mov    %esi,%ebx
  800bbe:	80 fb 19             	cmp    $0x19,%bl
  800bc1:	77 29                	ja     800bec <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bc3:	0f be d2             	movsbl %dl,%edx
  800bc6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bcc:	7d 30                	jge    800bfe <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd7:	0f b6 11             	movzbl (%ecx),%edx
  800bda:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	80 fb 09             	cmp    $0x9,%bl
  800be2:	77 d5                	ja     800bb9 <strtol+0x80>
			dig = *s - '0';
  800be4:	0f be d2             	movsbl %dl,%edx
  800be7:	83 ea 30             	sub    $0x30,%edx
  800bea:	eb dd                	jmp    800bc9 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bef:	89 f3                	mov    %esi,%ebx
  800bf1:	80 fb 19             	cmp    $0x19,%bl
  800bf4:	77 08                	ja     800bfe <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 37             	sub    $0x37,%edx
  800bfc:	eb cb                	jmp    800bc9 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c02:	74 05                	je     800c09 <strtol+0xd0>
		*endptr = (char *) s;
  800c04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c09:	89 c2                	mov    %eax,%edx
  800c0b:	f7 da                	neg    %edx
  800c0d:	85 ff                	test   %edi,%edi
  800c0f:	0f 45 c2             	cmovne %edx,%eax
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c28:	89 c3                	mov    %eax,%ebx
  800c2a:	89 c7                	mov    %eax,%edi
  800c2c:	89 c6                	mov    %eax,%esi
  800c2e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_cgetc>:

int
sys_cgetc(void) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 01 00 00 00       	mov    $0x1,%eax
  800c45:	89 d1                	mov    %edx,%ecx
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	89 d7                	mov    %edx,%edi
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800c5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6a:	89 cb                	mov    %ecx,%ebx
  800c6c:	89 cf                	mov    %ecx,%edi
  800c6e:	89 ce                	mov    %ecx,%esi
  800c70:	cd 30                	int    $0x30
    if (check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 03                	push   $0x3
  800c84:	68 a4 14 80 00       	push   $0x8014a4
  800c89:	6a 24                	push   $0x24
  800c8b:	68 c1 14 80 00       	push   $0x8014c1
  800c90:	e8 82 02 00 00       	call   800f17 <_panic>

00800c95 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_yield>:

void
sys_yield(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cdc:	be 00 00 00 00       	mov    $0x0,%esi
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cef:	89 f7                	mov    %esi,%edi
  800cf1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 04                	push   $0x4
  800d05:	68 a4 14 80 00       	push   $0x8014a4
  800d0a:	6a 24                	push   $0x24
  800d0c:	68 c1 14 80 00       	push   $0x8014c1
  800d11:	e8 01 02 00 00       	call   800f17 <_panic>

00800d16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d30:	8b 75 18             	mov    0x18(%ebp),%esi
  800d33:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 05                	push   $0x5
  800d47:	68 a4 14 80 00       	push   $0x8014a4
  800d4c:	6a 24                	push   $0x24
  800d4e:	68 c1 14 80 00       	push   $0x8014c1
  800d53:	e8 bf 01 00 00       	call   800f17 <_panic>

00800d58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	89 de                	mov    %ebx,%esi
  800d75:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 06                	push   $0x6
  800d89:	68 a4 14 80 00       	push   $0x8014a4
  800d8e:	6a 24                	push   $0x24
  800d90:	68 c1 14 80 00       	push   $0x8014c1
  800d95:	e8 7d 01 00 00       	call   800f17 <_panic>

00800d9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	b8 08 00 00 00       	mov    $0x8,%eax
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
    if (check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 08                	push   $0x8
  800dcb:	68 a4 14 80 00       	push   $0x8014a4
  800dd0:	6a 24                	push   $0x24
  800dd2:	68 c1 14 80 00       	push   $0x8014c1
  800dd7:	e8 3b 01 00 00       	call   800f17 <_panic>

00800ddc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 09 00 00 00       	mov    $0x9,%eax
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
    if (check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7f 08                	jg     800e07 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	50                   	push   %eax
  800e0b:	6a 09                	push   $0x9
  800e0d:	68 a4 14 80 00       	push   $0x8014a4
  800e12:	6a 24                	push   $0x24
  800e14:	68 c1 14 80 00       	push   $0x8014c1
  800e19:	e8 f9 00 00 00       	call   800f17 <_panic>

00800e1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
    asm volatile("int %1\n"
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e2f:	be 00 00 00 00       	mov    $0x0,%esi
  800e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e37:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e57:	89 cb                	mov    %ecx,%ebx
  800e59:	89 cf                	mov    %ecx,%edi
  800e5b:	89 ce                	mov    %ecx,%esi
  800e5d:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 0c                	push   $0xc
  800e71:	68 a4 14 80 00       	push   $0x8014a4
  800e76:	6a 24                	push   $0x24
  800e78:	68 c1 14 80 00       	push   $0x8014c1
  800e7d:	e8 95 00 00 00       	call   800f17 <_panic>

00800e82 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("fork not implemented");
  800e88:	68 db 14 80 00       	push   $0x8014db
  800e8d:	6a 51                	push   $0x51
  800e8f:	68 cf 14 80 00       	push   $0x8014cf
  800e94:	e8 7e 00 00 00       	call   800f17 <_panic>

00800e99 <sfork>:
}

// Challenge!
int
sfork(void)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800e9f:	68 da 14 80 00       	push   $0x8014da
  800ea4:	6a 58                	push   $0x58
  800ea6:	68 cf 14 80 00       	push   $0x8014cf
  800eab:	e8 67 00 00 00       	call   800f17 <_panic>

00800eb0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800eb6:	68 f0 14 80 00       	push   $0x8014f0
  800ebb:	6a 1a                	push   $0x1a
  800ebd:	68 09 15 80 00       	push   $0x801509
  800ec2:	e8 50 00 00 00       	call   800f17 <_panic>

00800ec7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800ecd:	68 13 15 80 00       	push   $0x801513
  800ed2:	6a 2a                	push   $0x2a
  800ed4:	68 09 15 80 00       	push   $0x801509
  800ed9:	e8 39 00 00 00       	call   800f17 <_panic>

00800ede <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800ee4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800ee9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800eec:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800ef2:	8b 52 50             	mov    0x50(%edx),%edx
  800ef5:	39 ca                	cmp    %ecx,%edx
  800ef7:	74 11                	je     800f0a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800ef9:	83 c0 01             	add    $0x1,%eax
  800efc:	3d 00 04 00 00       	cmp    $0x400,%eax
  800f01:	75 e6                	jne    800ee9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
  800f08:	eb 0b                	jmp    800f15 <ipc_find_env+0x37>
			return envs[i].env_id;
  800f0a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f0d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f12:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800f1c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f1f:	8b 35 08 20 80 00    	mov    0x802008,%esi
  800f25:	e8 6b fd ff ff       	call   800c95 <sys_getenvid>
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	ff 75 08             	pushl  0x8(%ebp)
  800f33:	56                   	push   %esi
  800f34:	50                   	push   %eax
  800f35:	68 2c 15 80 00       	push   $0x80152c
  800f3a:	e8 3d f3 ff ff       	call   80027c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f3f:	83 c4 18             	add    $0x18,%esp
  800f42:	53                   	push   %ebx
  800f43:	ff 75 10             	pushl  0x10(%ebp)
  800f46:	e8 e0 f2 ff ff       	call   80022b <vcprintf>
	cprintf("\n");
  800f4b:	c7 04 24 b2 11 80 00 	movl   $0x8011b2,(%esp)
  800f52:	e8 25 f3 ff ff       	call   80027c <cprintf>
  800f57:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f5a:	cc                   	int3   
  800f5b:	eb fd                	jmp    800f5a <_panic+0x43>
  800f5d:	66 90                	xchg   %ax,%ax
  800f5f:	90                   	nop

00800f60 <__udivdi3>:
  800f60:	55                   	push   %ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 1c             	sub    $0x1c,%esp
  800f67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f77:	85 d2                	test   %edx,%edx
  800f79:	75 35                	jne    800fb0 <__udivdi3+0x50>
  800f7b:	39 f3                	cmp    %esi,%ebx
  800f7d:	0f 87 bd 00 00 00    	ja     801040 <__udivdi3+0xe0>
  800f83:	85 db                	test   %ebx,%ebx
  800f85:	89 d9                	mov    %ebx,%ecx
  800f87:	75 0b                	jne    800f94 <__udivdi3+0x34>
  800f89:	b8 01 00 00 00       	mov    $0x1,%eax
  800f8e:	31 d2                	xor    %edx,%edx
  800f90:	f7 f3                	div    %ebx
  800f92:	89 c1                	mov    %eax,%ecx
  800f94:	31 d2                	xor    %edx,%edx
  800f96:	89 f0                	mov    %esi,%eax
  800f98:	f7 f1                	div    %ecx
  800f9a:	89 c6                	mov    %eax,%esi
  800f9c:	89 e8                	mov    %ebp,%eax
  800f9e:	89 f7                	mov    %esi,%edi
  800fa0:	f7 f1                	div    %ecx
  800fa2:	89 fa                	mov    %edi,%edx
  800fa4:	83 c4 1c             	add    $0x1c,%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    
  800fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fb0:	39 f2                	cmp    %esi,%edx
  800fb2:	77 7c                	ja     801030 <__udivdi3+0xd0>
  800fb4:	0f bd fa             	bsr    %edx,%edi
  800fb7:	83 f7 1f             	xor    $0x1f,%edi
  800fba:	0f 84 98 00 00 00    	je     801058 <__udivdi3+0xf8>
  800fc0:	89 f9                	mov    %edi,%ecx
  800fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800fc7:	29 f8                	sub    %edi,%eax
  800fc9:	d3 e2                	shl    %cl,%edx
  800fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fcf:	89 c1                	mov    %eax,%ecx
  800fd1:	89 da                	mov    %ebx,%edx
  800fd3:	d3 ea                	shr    %cl,%edx
  800fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fd9:	09 d1                	or     %edx,%ecx
  800fdb:	89 f2                	mov    %esi,%edx
  800fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fe1:	89 f9                	mov    %edi,%ecx
  800fe3:	d3 e3                	shl    %cl,%ebx
  800fe5:	89 c1                	mov    %eax,%ecx
  800fe7:	d3 ea                	shr    %cl,%edx
  800fe9:	89 f9                	mov    %edi,%ecx
  800feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fef:	d3 e6                	shl    %cl,%esi
  800ff1:	89 eb                	mov    %ebp,%ebx
  800ff3:	89 c1                	mov    %eax,%ecx
  800ff5:	d3 eb                	shr    %cl,%ebx
  800ff7:	09 de                	or     %ebx,%esi
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	f7 74 24 08          	divl   0x8(%esp)
  800fff:	89 d6                	mov    %edx,%esi
  801001:	89 c3                	mov    %eax,%ebx
  801003:	f7 64 24 0c          	mull   0xc(%esp)
  801007:	39 d6                	cmp    %edx,%esi
  801009:	72 0c                	jb     801017 <__udivdi3+0xb7>
  80100b:	89 f9                	mov    %edi,%ecx
  80100d:	d3 e5                	shl    %cl,%ebp
  80100f:	39 c5                	cmp    %eax,%ebp
  801011:	73 5d                	jae    801070 <__udivdi3+0x110>
  801013:	39 d6                	cmp    %edx,%esi
  801015:	75 59                	jne    801070 <__udivdi3+0x110>
  801017:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80101a:	31 ff                	xor    %edi,%edi
  80101c:	89 fa                	mov    %edi,%edx
  80101e:	83 c4 1c             	add    $0x1c,%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
  801026:	8d 76 00             	lea    0x0(%esi),%esi
  801029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801030:	31 ff                	xor    %edi,%edi
  801032:	31 c0                	xor    %eax,%eax
  801034:	89 fa                	mov    %edi,%edx
  801036:	83 c4 1c             	add    $0x1c,%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    
  80103e:	66 90                	xchg   %ax,%ax
  801040:	31 ff                	xor    %edi,%edi
  801042:	89 e8                	mov    %ebp,%eax
  801044:	89 f2                	mov    %esi,%edx
  801046:	f7 f3                	div    %ebx
  801048:	89 fa                	mov    %edi,%edx
  80104a:	83 c4 1c             	add    $0x1c,%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    
  801052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801058:	39 f2                	cmp    %esi,%edx
  80105a:	72 06                	jb     801062 <__udivdi3+0x102>
  80105c:	31 c0                	xor    %eax,%eax
  80105e:	39 eb                	cmp    %ebp,%ebx
  801060:	77 d2                	ja     801034 <__udivdi3+0xd4>
  801062:	b8 01 00 00 00       	mov    $0x1,%eax
  801067:	eb cb                	jmp    801034 <__udivdi3+0xd4>
  801069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801070:	89 d8                	mov    %ebx,%eax
  801072:	31 ff                	xor    %edi,%edi
  801074:	eb be                	jmp    801034 <__udivdi3+0xd4>
  801076:	66 90                	xchg   %ax,%ax
  801078:	66 90                	xchg   %ax,%ax
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__umoddi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80108b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80108f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801097:	85 ed                	test   %ebp,%ebp
  801099:	89 f0                	mov    %esi,%eax
  80109b:	89 da                	mov    %ebx,%edx
  80109d:	75 19                	jne    8010b8 <__umoddi3+0x38>
  80109f:	39 df                	cmp    %ebx,%edi
  8010a1:	0f 86 b1 00 00 00    	jbe    801158 <__umoddi3+0xd8>
  8010a7:	f7 f7                	div    %edi
  8010a9:	89 d0                	mov    %edx,%eax
  8010ab:	31 d2                	xor    %edx,%edx
  8010ad:	83 c4 1c             	add    $0x1c,%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
  8010b5:	8d 76 00             	lea    0x0(%esi),%esi
  8010b8:	39 dd                	cmp    %ebx,%ebp
  8010ba:	77 f1                	ja     8010ad <__umoddi3+0x2d>
  8010bc:	0f bd cd             	bsr    %ebp,%ecx
  8010bf:	83 f1 1f             	xor    $0x1f,%ecx
  8010c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8010c6:	0f 84 b4 00 00 00    	je     801180 <__umoddi3+0x100>
  8010cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8010d1:	89 c2                	mov    %eax,%edx
  8010d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 c1                	mov    %eax,%ecx
  8010db:	89 f8                	mov    %edi,%eax
  8010dd:	d3 e5                	shl    %cl,%ebp
  8010df:	89 d1                	mov    %edx,%ecx
  8010e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8010e5:	d3 e8                	shr    %cl,%eax
  8010e7:	09 c5                	or     %eax,%ebp
  8010e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010ed:	89 c1                	mov    %eax,%ecx
  8010ef:	d3 e7                	shl    %cl,%edi
  8010f1:	89 d1                	mov    %edx,%ecx
  8010f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8010f7:	89 df                	mov    %ebx,%edi
  8010f9:	d3 ef                	shr    %cl,%edi
  8010fb:	89 c1                	mov    %eax,%ecx
  8010fd:	89 f0                	mov    %esi,%eax
  8010ff:	d3 e3                	shl    %cl,%ebx
  801101:	89 d1                	mov    %edx,%ecx
  801103:	89 fa                	mov    %edi,%edx
  801105:	d3 e8                	shr    %cl,%eax
  801107:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80110c:	09 d8                	or     %ebx,%eax
  80110e:	f7 f5                	div    %ebp
  801110:	d3 e6                	shl    %cl,%esi
  801112:	89 d1                	mov    %edx,%ecx
  801114:	f7 64 24 08          	mull   0x8(%esp)
  801118:	39 d1                	cmp    %edx,%ecx
  80111a:	89 c3                	mov    %eax,%ebx
  80111c:	89 d7                	mov    %edx,%edi
  80111e:	72 06                	jb     801126 <__umoddi3+0xa6>
  801120:	75 0e                	jne    801130 <__umoddi3+0xb0>
  801122:	39 c6                	cmp    %eax,%esi
  801124:	73 0a                	jae    801130 <__umoddi3+0xb0>
  801126:	2b 44 24 08          	sub    0x8(%esp),%eax
  80112a:	19 ea                	sbb    %ebp,%edx
  80112c:	89 d7                	mov    %edx,%edi
  80112e:	89 c3                	mov    %eax,%ebx
  801130:	89 ca                	mov    %ecx,%edx
  801132:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801137:	29 de                	sub    %ebx,%esi
  801139:	19 fa                	sbb    %edi,%edx
  80113b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80113f:	89 d0                	mov    %edx,%eax
  801141:	d3 e0                	shl    %cl,%eax
  801143:	89 d9                	mov    %ebx,%ecx
  801145:	d3 ee                	shr    %cl,%esi
  801147:	d3 ea                	shr    %cl,%edx
  801149:	09 f0                	or     %esi,%eax
  80114b:	83 c4 1c             	add    $0x1c,%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    
  801153:	90                   	nop
  801154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801158:	85 ff                	test   %edi,%edi
  80115a:	89 f9                	mov    %edi,%ecx
  80115c:	75 0b                	jne    801169 <__umoddi3+0xe9>
  80115e:	b8 01 00 00 00       	mov    $0x1,%eax
  801163:	31 d2                	xor    %edx,%edx
  801165:	f7 f7                	div    %edi
  801167:	89 c1                	mov    %eax,%ecx
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	31 d2                	xor    %edx,%edx
  80116d:	f7 f1                	div    %ecx
  80116f:	89 f0                	mov    %esi,%eax
  801171:	f7 f1                	div    %ecx
  801173:	e9 31 ff ff ff       	jmp    8010a9 <__umoddi3+0x29>
  801178:	90                   	nop
  801179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801180:	39 dd                	cmp    %ebx,%ebp
  801182:	72 08                	jb     80118c <__umoddi3+0x10c>
  801184:	39 f7                	cmp    %esi,%edi
  801186:	0f 87 21 ff ff ff    	ja     8010ad <__umoddi3+0x2d>
  80118c:	89 da                	mov    %ebx,%edx
  80118e:	89 f0                	mov    %esi,%eax
  801190:	29 f8                	sub    %edi,%eax
  801192:	19 ea                	sbb    %ebp,%edx
  801194:	e9 14 ff ff ff       	jmp    8010ad <__umoddi3+0x2d>
