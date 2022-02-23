
obj/user/faultreadkernel：     文件格式 elf32-i386


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
  80002c:	e8 32 00 00 00       	call   800063 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	e8 20 00 00 00       	call   80005f <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800045:	ff 35 00 00 10 f0    	pushl  0xf0100000
  80004b:	8d 83 ac ee ff ff    	lea    -0x1154(%ebx),%eax
  800051:	50                   	push   %eax
  800052:	e8 27 01 00 00       	call   80017e <cprintf>
}
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80005d:	c9                   	leave  
  80005e:	c3                   	ret    

0080005f <__x86.get_pc_thunk.bx>:
  80005f:	8b 1c 24             	mov    (%esp),%ebx
  800062:	c3                   	ret    

00800063 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	56                   	push   %esi
  800067:	53                   	push   %ebx
  800068:	e8 f2 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  80006d:	81 c3 93 1f 00 00    	add    $0x1f93,%ebx
  800073:	8b 45 08             	mov    0x8(%ebp),%eax
  800076:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800079:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  80007f:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  800085:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 c0                	test   %eax,%eax
  800089:	7e 08                	jle    800093 <libmain+0x30>
		binaryname = argv[0];
  80008b:	8b 0a                	mov    (%edx),%ecx
  80008d:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	52                   	push   %edx
  800097:	50                   	push   %eax
  800098:	e8 96 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009d:	e8 0a 00 00 00       	call   8000ac <exit>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a8:	5b                   	pop    %ebx
  8000a9:	5e                   	pop    %esi
  8000aa:	5d                   	pop    %ebp
  8000ab:	c3                   	ret    

008000ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	53                   	push   %ebx
  8000b0:	83 ec 10             	sub    $0x10,%esp
  8000b3:	e8 a7 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  8000b8:	81 c3 48 1f 00 00    	add    $0x1f48,%ebx
	sys_env_destroy(0);
  8000be:	6a 00                	push   $0x0
  8000c0:	e8 ca 0a 00 00       	call   800b8f <sys_env_destroy>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cb:	c9                   	leave  
  8000cc:	c3                   	ret    

008000cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
  8000d2:	e8 88 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  8000d7:	81 c3 29 1f 00 00    	add    $0x1f29,%ebx
  8000dd:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8000e0:	8b 16                	mov    (%esi),%edx
  8000e2:	8d 42 01             	lea    0x1(%edx),%eax
  8000e5:	89 06                	mov    %eax,(%esi)
  8000e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ea:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8000ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f3:	74 0b                	je     800100 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000f5:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8000f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	68 ff 00 00 00       	push   $0xff
  800108:	8d 46 08             	lea    0x8(%esi),%eax
  80010b:	50                   	push   %eax
  80010c:	e8 41 0a 00 00       	call   800b52 <sys_cputs>
		b->idx = 0;
  800111:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	eb d9                	jmp    8000f5 <putch+0x28>

0080011c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	53                   	push   %ebx
  800120:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800126:	e8 34 ff ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  80012b:	81 c3 d5 1e 00 00    	add    $0x1ed5,%ebx
	struct printbuf b;

	b.idx = 0;
  800131:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800138:	00 00 00 
	b.cnt = 0;
  80013b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800142:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800145:	ff 75 0c             	pushl  0xc(%ebp)
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800151:	50                   	push   %eax
  800152:	8d 83 cd e0 ff ff    	lea    -0x1f33(%ebx),%eax
  800158:	50                   	push   %eax
  800159:	e8 38 01 00 00       	call   800296 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015e:	83 c4 08             	add    $0x8,%esp
  800161:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800167:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80016d:	50                   	push   %eax
  80016e:	e8 df 09 00 00       	call   800b52 <sys_cputs>

	return b.cnt;
}
  800173:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800184:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800187:	50                   	push   %eax
  800188:	ff 75 08             	pushl  0x8(%ebp)
  80018b:	e8 8c ff ff ff       	call   80011c <vcprintf>
	va_end(ap);

	return cnt;
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	57                   	push   %edi
  800196:	56                   	push   %esi
  800197:	53                   	push   %ebx
  800198:	83 ec 2c             	sub    $0x2c,%esp
  80019b:	e8 3a 06 00 00       	call   8007da <__x86.get_pc_thunk.cx>
  8001a0:	81 c1 60 1e 00 00    	add    $0x1e60,%ecx
  8001a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8001a9:	89 c7                	mov    %eax,%edi
  8001ab:	89 d6                	mov    %edx,%esi
  8001ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001b6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8001c4:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8001c7:	39 d3                	cmp    %edx,%ebx
  8001c9:	72 09                	jb     8001d4 <printnum+0x42>
  8001cb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ce:	0f 87 83 00 00 00    	ja     800257 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	ff 75 18             	pushl  0x18(%ebp)
  8001da:	8b 45 14             	mov    0x14(%ebp),%eax
  8001dd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e0:	53                   	push   %ebx
  8001e1:	ff 75 10             	pushl  0x10(%ebp)
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001f0:	ff 75 d0             	pushl  -0x30(%ebp)
  8001f3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001f6:	e8 75 0a 00 00       	call   800c70 <__udivdi3>
  8001fb:	83 c4 18             	add    $0x18,%esp
  8001fe:	52                   	push   %edx
  8001ff:	50                   	push   %eax
  800200:	89 f2                	mov    %esi,%edx
  800202:	89 f8                	mov    %edi,%eax
  800204:	e8 89 ff ff ff       	call   800192 <printnum>
  800209:	83 c4 20             	add    $0x20,%esp
  80020c:	eb 13                	jmp    800221 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	56                   	push   %esi
  800212:	ff 75 18             	pushl  0x18(%ebp)
  800215:	ff d7                	call   *%edi
  800217:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80021a:	83 eb 01             	sub    $0x1,%ebx
  80021d:	85 db                	test   %ebx,%ebx
  80021f:	7f ed                	jg     80020e <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	56                   	push   %esi
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	ff 75 dc             	pushl  -0x24(%ebp)
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800231:	ff 75 d0             	pushl  -0x30(%ebp)
  800234:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800237:	89 f3                	mov    %esi,%ebx
  800239:	e8 52 0b 00 00       	call   800d90 <__umoddi3>
  80023e:	83 c4 14             	add    $0x14,%esp
  800241:	0f be 84 06 dd ee ff 	movsbl -0x1123(%esi,%eax,1),%eax
  800248:	ff 
  800249:	50                   	push   %eax
  80024a:	ff d7                	call   *%edi
}
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800252:	5b                   	pop    %ebx
  800253:	5e                   	pop    %esi
  800254:	5f                   	pop    %edi
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    
  800257:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80025a:	eb be                	jmp    80021a <printnum+0x88>

0080025c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800262:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800266:	8b 10                	mov    (%eax),%edx
  800268:	3b 50 04             	cmp    0x4(%eax),%edx
  80026b:	73 0a                	jae    800277 <sprintputch+0x1b>
		*b->buf++ = ch;
  80026d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800270:	89 08                	mov    %ecx,(%eax)
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	88 02                	mov    %al,(%edx)
}
  800277:	5d                   	pop    %ebp
  800278:	c3                   	ret    

00800279 <printfmt>:
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800282:	50                   	push   %eax
  800283:	ff 75 10             	pushl  0x10(%ebp)
  800286:	ff 75 0c             	pushl  0xc(%ebp)
  800289:	ff 75 08             	pushl  0x8(%ebp)
  80028c:	e8 05 00 00 00       	call   800296 <vprintfmt>
}
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	c9                   	leave  
  800295:	c3                   	ret    

00800296 <vprintfmt>:
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	57                   	push   %edi
  80029a:	56                   	push   %esi
  80029b:	53                   	push   %ebx
  80029c:	83 ec 2c             	sub    $0x2c,%esp
  80029f:	e8 bb fd ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  8002a4:	81 c3 5c 1d 00 00    	add    $0x1d5c,%ebx
  8002aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b0:	e9 fb 03 00 00       	jmp    8006b0 <.L35+0x48>
		padc = ' ';
  8002b5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002b9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002c0:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8002c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d3:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002d6:	8d 47 01             	lea    0x1(%edi),%eax
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	0f b6 17             	movzbl (%edi),%edx
  8002df:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e2:	3c 55                	cmp    $0x55,%al
  8002e4:	0f 87 4e 04 00 00    	ja     800738 <.L22>
  8002ea:	0f b6 c0             	movzbl %al,%eax
  8002ed:	89 d9                	mov    %ebx,%ecx
  8002ef:	03 8c 83 6c ef ff ff 	add    -0x1094(%ebx,%eax,4),%ecx
  8002f6:	ff e1                	jmp    *%ecx

008002f8 <.L71>:
  8002f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002fb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ff:	eb d5                	jmp    8002d6 <vprintfmt+0x40>

00800301 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  800301:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800304:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800308:	eb cc                	jmp    8002d6 <vprintfmt+0x40>

0080030a <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	0f b6 d2             	movzbl %dl,%edx
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800315:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800318:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80031c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80031f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800322:	83 f9 09             	cmp    $0x9,%ecx
  800325:	77 55                	ja     80037c <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800327:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032a:	eb e9                	jmp    800315 <.L29+0xb>

0080032c <.L26>:
			precision = va_arg(ap, int);
  80032c:	8b 45 14             	mov    0x14(%ebp),%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800334:	8b 45 14             	mov    0x14(%ebp),%eax
  800337:	8d 40 04             	lea    0x4(%eax),%eax
  80033a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800340:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800344:	79 90                	jns    8002d6 <vprintfmt+0x40>
				width = precision, precision = -1;
  800346:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800349:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80034c:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800353:	eb 81                	jmp    8002d6 <vprintfmt+0x40>

00800355 <.L27>:
  800355:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800358:	85 c0                	test   %eax,%eax
  80035a:	ba 00 00 00 00       	mov    $0x0,%edx
  80035f:	0f 49 d0             	cmovns %eax,%edx
  800362:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800368:	e9 69 ff ff ff       	jmp    8002d6 <vprintfmt+0x40>

0080036d <.L23>:
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800370:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800377:	e9 5a ff ff ff       	jmp    8002d6 <vprintfmt+0x40>
  80037c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80037f:	eb bf                	jmp    800340 <.L26+0x14>

00800381 <.L33>:
			lflag++;
  800381:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800388:	e9 49 ff ff ff       	jmp    8002d6 <vprintfmt+0x40>

0080038d <.L30>:
			putch(va_arg(ap, int), putdat);
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8d 78 04             	lea    0x4(%eax),%edi
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	56                   	push   %esi
  800397:	ff 30                	pushl  (%eax)
  800399:	ff 55 08             	call   *0x8(%ebp)
			break;
  80039c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80039f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a2:	e9 06 03 00 00       	jmp    8006ad <.L35+0x45>

008003a7 <.L32>:
			err = va_arg(ap, int);
  8003a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003aa:	8d 78 04             	lea    0x4(%eax),%edi
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	99                   	cltd   
  8003b0:	31 d0                	xor    %edx,%eax
  8003b2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b4:	83 f8 06             	cmp    $0x6,%eax
  8003b7:	7f 27                	jg     8003e0 <.L32+0x39>
  8003b9:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8003c0:	85 d2                	test   %edx,%edx
  8003c2:	74 1c                	je     8003e0 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8003c4:	52                   	push   %edx
  8003c5:	8d 83 fe ee ff ff    	lea    -0x1102(%ebx),%eax
  8003cb:	50                   	push   %eax
  8003cc:	56                   	push   %esi
  8003cd:	ff 75 08             	pushl  0x8(%ebp)
  8003d0:	e8 a4 fe ff ff       	call   800279 <printfmt>
  8003d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003db:	e9 cd 02 00 00       	jmp    8006ad <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8003e0:	50                   	push   %eax
  8003e1:	8d 83 f5 ee ff ff    	lea    -0x110b(%ebx),%eax
  8003e7:	50                   	push   %eax
  8003e8:	56                   	push   %esi
  8003e9:	ff 75 08             	pushl  0x8(%ebp)
  8003ec:	e8 88 fe ff ff       	call   800279 <printfmt>
  8003f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f7:	e9 b1 02 00 00       	jmp    8006ad <.L35+0x45>

008003fc <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	83 c0 04             	add    $0x4,%eax
  800402:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80040a:	85 ff                	test   %edi,%edi
  80040c:	8d 83 ee ee ff ff    	lea    -0x1112(%ebx),%eax
  800412:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800419:	0f 8e b5 00 00 00    	jle    8004d4 <.L36+0xd8>
  80041f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800423:	75 08                	jne    80042d <.L36+0x31>
  800425:	89 75 0c             	mov    %esi,0xc(%ebp)
  800428:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80042b:	eb 6d                	jmp    80049a <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	ff 75 cc             	pushl  -0x34(%ebp)
  800433:	57                   	push   %edi
  800434:	e8 bd 03 00 00       	call   8007f6 <strnlen>
  800439:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80043c:	29 c2                	sub    %eax,%edx
  80043e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800441:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800444:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800448:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80044e:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800450:	eb 10                	jmp    800462 <.L36+0x66>
					putch(padc, putdat);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	56                   	push   %esi
  800456:	ff 75 e0             	pushl  -0x20(%ebp)
  800459:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80045c:	83 ef 01             	sub    $0x1,%edi
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	85 ff                	test   %edi,%edi
  800464:	7f ec                	jg     800452 <.L36+0x56>
  800466:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800469:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80046c:	85 d2                	test   %edx,%edx
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
  800473:	0f 49 c2             	cmovns %edx,%eax
  800476:	29 c2                	sub    %eax,%edx
  800478:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047b:	89 75 0c             	mov    %esi,0xc(%ebp)
  80047e:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800481:	eb 17                	jmp    80049a <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800483:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800487:	75 30                	jne    8004b9 <.L36+0xbd>
					putch(ch, putdat);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	50                   	push   %eax
  800490:	ff 55 08             	call   *0x8(%ebp)
  800493:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800496:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80049a:	83 c7 01             	add    $0x1,%edi
  80049d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a1:	0f be c2             	movsbl %dl,%eax
  8004a4:	85 c0                	test   %eax,%eax
  8004a6:	74 52                	je     8004fa <.L36+0xfe>
  8004a8:	85 f6                	test   %esi,%esi
  8004aa:	78 d7                	js     800483 <.L36+0x87>
  8004ac:	83 ee 01             	sub    $0x1,%esi
  8004af:	79 d2                	jns    800483 <.L36+0x87>
  8004b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004b7:	eb 32                	jmp    8004eb <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b9:	0f be d2             	movsbl %dl,%edx
  8004bc:	83 ea 20             	sub    $0x20,%edx
  8004bf:	83 fa 5e             	cmp    $0x5e,%edx
  8004c2:	76 c5                	jbe    800489 <.L36+0x8d>
					putch('?', putdat);
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ca:	6a 3f                	push   $0x3f
  8004cc:	ff 55 08             	call   *0x8(%ebp)
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	eb c2                	jmp    800496 <.L36+0x9a>
  8004d4:	89 75 0c             	mov    %esi,0xc(%ebp)
  8004d7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004da:	eb be                	jmp    80049a <.L36+0x9e>
				putch(' ', putdat);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	56                   	push   %esi
  8004e0:	6a 20                	push   $0x20
  8004e2:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8004e5:	83 ef 01             	sub    $0x1,%edi
  8004e8:	83 c4 10             	add    $0x10,%esp
  8004eb:	85 ff                	test   %edi,%edi
  8004ed:	7f ed                	jg     8004dc <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f5:	e9 b3 01 00 00       	jmp    8006ad <.L35+0x45>
  8004fa:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800500:	eb e9                	jmp    8004eb <.L36+0xef>

00800502 <.L31>:
  800502:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800505:	83 f9 01             	cmp    $0x1,%ecx
  800508:	7e 40                	jle    80054a <.L31+0x48>
		return va_arg(*ap, long long);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8b 50 04             	mov    0x4(%eax),%edx
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 40 08             	lea    0x8(%eax),%eax
  80051e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800521:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800525:	79 55                	jns    80057c <.L31+0x7a>
				putch('-', putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	56                   	push   %esi
  80052b:	6a 2d                	push   $0x2d
  80052d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800530:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800533:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800536:	f7 da                	neg    %edx
  800538:	83 d1 00             	adc    $0x0,%ecx
  80053b:	f7 d9                	neg    %ecx
  80053d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800540:	b8 0a 00 00 00       	mov    $0xa,%eax
  800545:	e9 48 01 00 00       	jmp    800692 <.L35+0x2a>
	else if (lflag)
  80054a:	85 c9                	test   %ecx,%ecx
  80054c:	75 17                	jne    800565 <.L31+0x63>
		return va_arg(*ap, int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800556:	99                   	cltd   
  800557:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 40 04             	lea    0x4(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
  800563:	eb bc                	jmp    800521 <.L31+0x1f>
		return va_arg(*ap, long);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056d:	99                   	cltd   
  80056e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	eb a5                	jmp    800521 <.L31+0x1f>
			num = getint(&ap, lflag);
  80057c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800582:	b8 0a 00 00 00       	mov    $0xa,%eax
  800587:	e9 06 01 00 00       	jmp    800692 <.L35+0x2a>

0080058c <.L37>:
  80058c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80058f:	83 f9 01             	cmp    $0x1,%ecx
  800592:	7e 18                	jle    8005ac <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 10                	mov    (%eax),%edx
  800599:	8b 48 04             	mov    0x4(%eax),%ecx
  80059c:	8d 40 08             	lea    0x8(%eax),%eax
  80059f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a7:	e9 e6 00 00 00       	jmp    800692 <.L35+0x2a>
	else if (lflag)
  8005ac:	85 c9                	test   %ecx,%ecx
  8005ae:	75 1a                	jne    8005ca <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8b 10                	mov    (%eax),%edx
  8005b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ba:	8d 40 04             	lea    0x4(%eax),%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c5:	e9 c8 00 00 00       	jmp    800692 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 10                	mov    (%eax),%edx
  8005cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d4:	8d 40 04             	lea    0x4(%eax),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005df:	e9 ae 00 00 00       	jmp    800692 <.L35+0x2a>

008005e4 <.L34>:
  8005e4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005e7:	83 f9 01             	cmp    $0x1,%ecx
  8005ea:	7e 3d                	jle    800629 <.L34+0x45>
		return va_arg(*ap, long long);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 50 04             	mov    0x4(%eax),%edx
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 40 08             	lea    0x8(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800603:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800607:	79 52                	jns    80065b <.L34+0x77>
                putch('-', putdat);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	56                   	push   %esi
  80060d:	6a 2d                	push   $0x2d
  80060f:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800612:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800615:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800618:	f7 da                	neg    %edx
  80061a:	83 d1 00             	adc    $0x0,%ecx
  80061d:	f7 d9                	neg    %ecx
  80061f:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800622:	b8 08 00 00 00       	mov    $0x8,%eax
  800627:	eb 69                	jmp    800692 <.L35+0x2a>
	else if (lflag)
  800629:	85 c9                	test   %ecx,%ecx
  80062b:	75 17                	jne    800644 <.L34+0x60>
		return va_arg(*ap, int);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	99                   	cltd   
  800636:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	eb bf                	jmp    800603 <.L34+0x1f>
		return va_arg(*ap, long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	99                   	cltd   
  80064d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 40 04             	lea    0x4(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
  800659:	eb a8                	jmp    800603 <.L34+0x1f>
            num = getint(&ap, lflag);
  80065b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80065e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800661:	b8 08 00 00 00       	mov    $0x8,%eax
  800666:	eb 2a                	jmp    800692 <.L35+0x2a>

00800668 <.L35>:
			putch('0', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	56                   	push   %esi
  80066c:	6a 30                	push   $0x30
  80066e:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800671:	83 c4 08             	add    $0x8,%esp
  800674:	56                   	push   %esi
  800675:	6a 78                	push   $0x78
  800677:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800684:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800692:	83 ec 0c             	sub    $0xc,%esp
  800695:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800699:	57                   	push   %edi
  80069a:	ff 75 e0             	pushl  -0x20(%ebp)
  80069d:	50                   	push   %eax
  80069e:	51                   	push   %ecx
  80069f:	52                   	push   %edx
  8006a0:	89 f2                	mov    %esi,%edx
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	e8 e8 fa ff ff       	call   800192 <printnum>
			break;
  8006aa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b0:	83 c7 01             	add    $0x1,%edi
  8006b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b7:	83 f8 25             	cmp    $0x25,%eax
  8006ba:	0f 84 f5 fb ff ff    	je     8002b5 <vprintfmt+0x1f>
			if (ch == '\0')
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	0f 84 91 00 00 00    	je     800759 <.L22+0x21>
			putch(ch, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	56                   	push   %esi
  8006cc:	50                   	push   %eax
  8006cd:	ff 55 08             	call   *0x8(%ebp)
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb db                	jmp    8006b0 <.L35+0x48>

008006d5 <.L38>:
  8006d5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006d8:	83 f9 01             	cmp    $0x1,%ecx
  8006db:	7e 15                	jle    8006f2 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f0:	eb a0                	jmp    800692 <.L35+0x2a>
	else if (lflag)
  8006f2:	85 c9                	test   %ecx,%ecx
  8006f4:	75 17                	jne    80070d <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800706:	b8 10 00 00 00       	mov    $0x10,%eax
  80070b:	eb 85                	jmp    800692 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 10                	mov    (%eax),%edx
  800712:	b9 00 00 00 00       	mov    $0x0,%ecx
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071d:	b8 10 00 00 00       	mov    $0x10,%eax
  800722:	e9 6b ff ff ff       	jmp    800692 <.L35+0x2a>

00800727 <.L25>:
			putch(ch, putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	56                   	push   %esi
  80072b:	6a 25                	push   $0x25
  80072d:	ff 55 08             	call   *0x8(%ebp)
			break;
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	e9 75 ff ff ff       	jmp    8006ad <.L35+0x45>

00800738 <.L22>:
			putch('%', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	56                   	push   %esi
  80073c:	6a 25                	push   $0x25
  80073e:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	89 f8                	mov    %edi,%eax
  800746:	eb 03                	jmp    80074b <.L22+0x13>
  800748:	83 e8 01             	sub    $0x1,%eax
  80074b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074f:	75 f7                	jne    800748 <.L22+0x10>
  800751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800754:	e9 54 ff ff ff       	jmp    8006ad <.L35+0x45>
}
  800759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075c:	5b                   	pop    %ebx
  80075d:	5e                   	pop    %esi
  80075e:	5f                   	pop    %edi
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	53                   	push   %ebx
  800765:	83 ec 14             	sub    $0x14,%esp
  800768:	e8 f2 f8 ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  80076d:	81 c3 93 18 00 00    	add    $0x1893,%ebx
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800779:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800780:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800783:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078a:	85 c0                	test   %eax,%eax
  80078c:	74 2b                	je     8007b9 <vsnprintf+0x58>
  80078e:	85 d2                	test   %edx,%edx
  800790:	7e 27                	jle    8007b9 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800792:	ff 75 14             	pushl  0x14(%ebp)
  800795:	ff 75 10             	pushl  0x10(%ebp)
  800798:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079b:	50                   	push   %eax
  80079c:	8d 83 5c e2 ff ff    	lea    -0x1da4(%ebx),%eax
  8007a2:	50                   	push   %eax
  8007a3:	e8 ee fa ff ff       	call   800296 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
}
  8007b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    
		return -E_INVAL;
  8007b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007be:	eb f4                	jmp    8007b4 <vsnprintf+0x53>

008007c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c9:	50                   	push   %eax
  8007ca:	ff 75 10             	pushl  0x10(%ebp)
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	ff 75 08             	pushl  0x8(%ebp)
  8007d3:	e8 89 ff ff ff       	call   800761 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <__x86.get_pc_thunk.cx>:
  8007da:	8b 0c 24             	mov    (%esp),%ecx
  8007dd:	c3                   	ret    

008007de <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e9:	eb 03                	jmp    8007ee <strlen+0x10>
		n++;
  8007eb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007ee:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f2:	75 f7                	jne    8007eb <strlen+0xd>
	return n;
}
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800804:	eb 03                	jmp    800809 <strnlen+0x13>
		n++;
  800806:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800809:	39 d0                	cmp    %edx,%eax
  80080b:	74 06                	je     800813 <strnlen+0x1d>
  80080d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800811:	75 f3                	jne    800806 <strnlen+0x10>
	return n;
}
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	53                   	push   %ebx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081f:	89 c2                	mov    %eax,%edx
  800821:	83 c1 01             	add    $0x1,%ecx
  800824:	83 c2 01             	add    $0x1,%edx
  800827:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80082b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80082e:	84 db                	test   %bl,%bl
  800830:	75 ef                	jne    800821 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800832:	5b                   	pop    %ebx
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	53                   	push   %ebx
  800839:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80083c:	53                   	push   %ebx
  80083d:	e8 9c ff ff ff       	call   8007de <strlen>
  800842:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	01 d8                	add    %ebx,%eax
  80084a:	50                   	push   %eax
  80084b:	e8 c5 ff ff ff       	call   800815 <strcpy>
	return dst;
}
  800850:	89 d8                	mov    %ebx,%eax
  800852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800855:	c9                   	leave  
  800856:	c3                   	ret    

00800857 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	56                   	push   %esi
  80085b:	53                   	push   %ebx
  80085c:	8b 75 08             	mov    0x8(%ebp),%esi
  80085f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800862:	89 f3                	mov    %esi,%ebx
  800864:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800867:	89 f2                	mov    %esi,%edx
  800869:	eb 0f                	jmp    80087a <strncpy+0x23>
		*dst++ = *src;
  80086b:	83 c2 01             	add    $0x1,%edx
  80086e:	0f b6 01             	movzbl (%ecx),%eax
  800871:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800874:	80 39 01             	cmpb   $0x1,(%ecx)
  800877:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80087a:	39 da                	cmp    %ebx,%edx
  80087c:	75 ed                	jne    80086b <strncpy+0x14>
	}
	return ret;
}
  80087e:	89 f0                	mov    %esi,%eax
  800880:	5b                   	pop    %ebx
  800881:	5e                   	pop    %esi
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	56                   	push   %esi
  800888:	53                   	push   %ebx
  800889:	8b 75 08             	mov    0x8(%ebp),%esi
  80088c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800892:	89 f0                	mov    %esi,%eax
  800894:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800898:	85 c9                	test   %ecx,%ecx
  80089a:	75 0b                	jne    8008a7 <strlcpy+0x23>
  80089c:	eb 17                	jmp    8008b5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80089e:	83 c2 01             	add    $0x1,%edx
  8008a1:	83 c0 01             	add    $0x1,%eax
  8008a4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008a7:	39 d8                	cmp    %ebx,%eax
  8008a9:	74 07                	je     8008b2 <strlcpy+0x2e>
  8008ab:	0f b6 0a             	movzbl (%edx),%ecx
  8008ae:	84 c9                	test   %cl,%cl
  8008b0:	75 ec                	jne    80089e <strlcpy+0x1a>
		*dst = '\0';
  8008b2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b5:	29 f0                	sub    %esi,%eax
}
  8008b7:	5b                   	pop    %ebx
  8008b8:	5e                   	pop    %esi
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c4:	eb 06                	jmp    8008cc <strcmp+0x11>
		p++, q++;
  8008c6:	83 c1 01             	add    $0x1,%ecx
  8008c9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008cc:	0f b6 01             	movzbl (%ecx),%eax
  8008cf:	84 c0                	test   %al,%al
  8008d1:	74 04                	je     8008d7 <strcmp+0x1c>
  8008d3:	3a 02                	cmp    (%edx),%al
  8008d5:	74 ef                	je     8008c6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d7:	0f b6 c0             	movzbl %al,%eax
  8008da:	0f b6 12             	movzbl (%edx),%edx
  8008dd:	29 d0                	sub    %edx,%eax
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008eb:	89 c3                	mov    %eax,%ebx
  8008ed:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f0:	eb 06                	jmp    8008f8 <strncmp+0x17>
		n--, p++, q++;
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f8:	39 d8                	cmp    %ebx,%eax
  8008fa:	74 16                	je     800912 <strncmp+0x31>
  8008fc:	0f b6 08             	movzbl (%eax),%ecx
  8008ff:	84 c9                	test   %cl,%cl
  800901:	74 04                	je     800907 <strncmp+0x26>
  800903:	3a 0a                	cmp    (%edx),%cl
  800905:	74 eb                	je     8008f2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800907:	0f b6 00             	movzbl (%eax),%eax
  80090a:	0f b6 12             	movzbl (%edx),%edx
  80090d:	29 d0                	sub    %edx,%eax
}
  80090f:	5b                   	pop    %ebx
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    
		return 0;
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	eb f6                	jmp    80090f <strncmp+0x2e>

00800919 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800923:	0f b6 10             	movzbl (%eax),%edx
  800926:	84 d2                	test   %dl,%dl
  800928:	74 09                	je     800933 <strchr+0x1a>
		if (*s == c)
  80092a:	38 ca                	cmp    %cl,%dl
  80092c:	74 0a                	je     800938 <strchr+0x1f>
	for (; *s; s++)
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	eb f0                	jmp    800923 <strchr+0xa>
			return (char *) s;
	return 0;
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800944:	eb 03                	jmp    800949 <strfind+0xf>
  800946:	83 c0 01             	add    $0x1,%eax
  800949:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80094c:	38 ca                	cmp    %cl,%dl
  80094e:	74 04                	je     800954 <strfind+0x1a>
  800950:	84 d2                	test   %dl,%dl
  800952:	75 f2                	jne    800946 <strfind+0xc>
			break;
	return (char *) s;
}
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	57                   	push   %edi
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800962:	85 c9                	test   %ecx,%ecx
  800964:	74 13                	je     800979 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800966:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80096c:	75 05                	jne    800973 <memset+0x1d>
  80096e:	f6 c1 03             	test   $0x3,%cl
  800971:	74 0d                	je     800980 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	fc                   	cld    
  800977:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800979:	89 f8                	mov    %edi,%eax
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5f                   	pop    %edi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    
		c &= 0xFF;
  800980:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800984:	89 d3                	mov    %edx,%ebx
  800986:	c1 e3 08             	shl    $0x8,%ebx
  800989:	89 d0                	mov    %edx,%eax
  80098b:	c1 e0 18             	shl    $0x18,%eax
  80098e:	89 d6                	mov    %edx,%esi
  800990:	c1 e6 10             	shl    $0x10,%esi
  800993:	09 f0                	or     %esi,%eax
  800995:	09 c2                	or     %eax,%edx
  800997:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800999:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	fc                   	cld    
  80099f:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a1:	eb d6                	jmp    800979 <memset+0x23>

008009a3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	57                   	push   %edi
  8009a7:	56                   	push   %esi
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b1:	39 c6                	cmp    %eax,%esi
  8009b3:	73 35                	jae    8009ea <memmove+0x47>
  8009b5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b8:	39 c2                	cmp    %eax,%edx
  8009ba:	76 2e                	jbe    8009ea <memmove+0x47>
		s += n;
		d += n;
  8009bc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bf:	89 d6                	mov    %edx,%esi
  8009c1:	09 fe                	or     %edi,%esi
  8009c3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c9:	74 0c                	je     8009d7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009cb:	83 ef 01             	sub    $0x1,%edi
  8009ce:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d1:	fd                   	std    
  8009d2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d4:	fc                   	cld    
  8009d5:	eb 21                	jmp    8009f8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	75 ef                	jne    8009cb <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009dc:	83 ef 04             	sub    $0x4,%edi
  8009df:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009e5:	fd                   	std    
  8009e6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e8:	eb ea                	jmp    8009d4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ea:	89 f2                	mov    %esi,%edx
  8009ec:	09 c2                	or     %eax,%edx
  8009ee:	f6 c2 03             	test   $0x3,%dl
  8009f1:	74 09                	je     8009fc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f3:	89 c7                	mov    %eax,%edi
  8009f5:	fc                   	cld    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f8:	5e                   	pop    %esi
  8009f9:	5f                   	pop    %edi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	f6 c1 03             	test   $0x3,%cl
  8009ff:	75 f2                	jne    8009f3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a01:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a04:	89 c7                	mov    %eax,%edi
  800a06:	fc                   	cld    
  800a07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a09:	eb ed                	jmp    8009f8 <memmove+0x55>

00800a0b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a0e:	ff 75 10             	pushl  0x10(%ebp)
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	ff 75 08             	pushl  0x8(%ebp)
  800a17:	e8 87 ff ff ff       	call   8009a3 <memmove>
}
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a29:	89 c6                	mov    %eax,%esi
  800a2b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2e:	39 f0                	cmp    %esi,%eax
  800a30:	74 1c                	je     800a4e <memcmp+0x30>
		if (*s1 != *s2)
  800a32:	0f b6 08             	movzbl (%eax),%ecx
  800a35:	0f b6 1a             	movzbl (%edx),%ebx
  800a38:	38 d9                	cmp    %bl,%cl
  800a3a:	75 08                	jne    800a44 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a3c:	83 c0 01             	add    $0x1,%eax
  800a3f:	83 c2 01             	add    $0x1,%edx
  800a42:	eb ea                	jmp    800a2e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a44:	0f b6 c1             	movzbl %cl,%eax
  800a47:	0f b6 db             	movzbl %bl,%ebx
  800a4a:	29 d8                	sub    %ebx,%eax
  800a4c:	eb 05                	jmp    800a53 <memcmp+0x35>
	}

	return 0;
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a60:	89 c2                	mov    %eax,%edx
  800a62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a65:	39 d0                	cmp    %edx,%eax
  800a67:	73 09                	jae    800a72 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a69:	38 08                	cmp    %cl,(%eax)
  800a6b:	74 05                	je     800a72 <memfind+0x1b>
	for (; s < ends; s++)
  800a6d:	83 c0 01             	add    $0x1,%eax
  800a70:	eb f3                	jmp    800a65 <memfind+0xe>
			break;
	return (void *) s;
}
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
  800a7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a80:	eb 03                	jmp    800a85 <strtol+0x11>
		s++;
  800a82:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a85:	0f b6 01             	movzbl (%ecx),%eax
  800a88:	3c 20                	cmp    $0x20,%al
  800a8a:	74 f6                	je     800a82 <strtol+0xe>
  800a8c:	3c 09                	cmp    $0x9,%al
  800a8e:	74 f2                	je     800a82 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a90:	3c 2b                	cmp    $0x2b,%al
  800a92:	74 2e                	je     800ac2 <strtol+0x4e>
	int neg = 0;
  800a94:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a99:	3c 2d                	cmp    $0x2d,%al
  800a9b:	74 2f                	je     800acc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa3:	75 05                	jne    800aaa <strtol+0x36>
  800aa5:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa8:	74 2c                	je     800ad6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aaa:	85 db                	test   %ebx,%ebx
  800aac:	75 0a                	jne    800ab8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aae:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ab3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab6:	74 28                	je     800ae0 <strtol+0x6c>
		base = 10;
  800ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  800abd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac0:	eb 50                	jmp    800b12 <strtol+0x9e>
		s++;
  800ac2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  800aca:	eb d1                	jmp    800a9d <strtol+0x29>
		s++, neg = 1;
  800acc:	83 c1 01             	add    $0x1,%ecx
  800acf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad4:	eb c7                	jmp    800a9d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ada:	74 0e                	je     800aea <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800adc:	85 db                	test   %ebx,%ebx
  800ade:	75 d8                	jne    800ab8 <strtol+0x44>
		s++, base = 8;
  800ae0:	83 c1 01             	add    $0x1,%ecx
  800ae3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae8:	eb ce                	jmp    800ab8 <strtol+0x44>
		s += 2, base = 16;
  800aea:	83 c1 02             	add    $0x2,%ecx
  800aed:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af2:	eb c4                	jmp    800ab8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800af4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af7:	89 f3                	mov    %esi,%ebx
  800af9:	80 fb 19             	cmp    $0x19,%bl
  800afc:	77 29                	ja     800b27 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800afe:	0f be d2             	movsbl %dl,%edx
  800b01:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b04:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b07:	7d 30                	jge    800b39 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b09:	83 c1 01             	add    $0x1,%ecx
  800b0c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b10:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b12:	0f b6 11             	movzbl (%ecx),%edx
  800b15:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b18:	89 f3                	mov    %esi,%ebx
  800b1a:	80 fb 09             	cmp    $0x9,%bl
  800b1d:	77 d5                	ja     800af4 <strtol+0x80>
			dig = *s - '0';
  800b1f:	0f be d2             	movsbl %dl,%edx
  800b22:	83 ea 30             	sub    $0x30,%edx
  800b25:	eb dd                	jmp    800b04 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b27:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b2a:	89 f3                	mov    %esi,%ebx
  800b2c:	80 fb 19             	cmp    $0x19,%bl
  800b2f:	77 08                	ja     800b39 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b31:	0f be d2             	movsbl %dl,%edx
  800b34:	83 ea 37             	sub    $0x37,%edx
  800b37:	eb cb                	jmp    800b04 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3d:	74 05                	je     800b44 <strtol+0xd0>
		*endptr = (char *) s;
  800b3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b42:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	f7 da                	neg    %edx
  800b48:	85 ff                	test   %edi,%edi
  800b4a:	0f 45 c2             	cmovne %edx,%eax
}
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b63:	89 c3                	mov    %eax,%ebx
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	89 c6                	mov    %eax,%esi
  800b69:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cgetc>:

int
sys_cgetc(void) {
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	89 d7                	mov    %edx,%edi
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 1c             	sub    $0x1c,%esp
  800b98:	e8 66 00 00 00       	call   800c03 <__x86.get_pc_thunk.ax>
  800b9d:	05 63 14 00 00       	add    $0x1463,%eax
  800ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  800ba5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800baa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bad:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb2:	89 cb                	mov    %ecx,%ebx
  800bb4:	89 cf                	mov    %ecx,%edi
  800bb6:	89 ce                	mov    %ecx,%esi
  800bb8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	7f 08                	jg     800bc6 <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 03                	push   $0x3
  800bcc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800bcf:	8d 83 c4 f0 ff ff    	lea    -0xf3c(%ebx),%eax
  800bd5:	50                   	push   %eax
  800bd6:	6a 24                	push   $0x24
  800bd8:	8d 83 e1 f0 ff ff    	lea    -0xf1f(%ebx),%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 23 00 00 00       	call   800c07 <_panic>

00800be4 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <__x86.get_pc_thunk.ax>:
  800c03:	8b 04 24             	mov    (%esp),%eax
  800c06:	c3                   	ret    

00800c07 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 0c             	sub    $0xc,%esp
  800c10:	e8 4a f4 ff ff       	call   80005f <__x86.get_pc_thunk.bx>
  800c15:	81 c3 eb 13 00 00    	add    $0x13eb,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c1b:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c1e:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c24:	8b 38                	mov    (%eax),%edi
  800c26:	e8 b9 ff ff ff       	call   800be4 <sys_getenvid>
  800c2b:	83 ec 0c             	sub    $0xc,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	ff 75 08             	pushl  0x8(%ebp)
  800c34:	57                   	push   %edi
  800c35:	50                   	push   %eax
  800c36:	8d 83 f0 f0 ff ff    	lea    -0xf10(%ebx),%eax
  800c3c:	50                   	push   %eax
  800c3d:	e8 3c f5 ff ff       	call   80017e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c42:	83 c4 18             	add    $0x18,%esp
  800c45:	56                   	push   %esi
  800c46:	ff 75 10             	pushl  0x10(%ebp)
  800c49:	e8 ce f4 ff ff       	call   80011c <vcprintf>
	cprintf("\n");
  800c4e:	8d 83 14 f1 ff ff    	lea    -0xeec(%ebx),%eax
  800c54:	89 04 24             	mov    %eax,(%esp)
  800c57:	e8 22 f5 ff ff       	call   80017e <cprintf>
  800c5c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c5f:	cc                   	int3   
  800c60:	eb fd                	jmp    800c5f <_panic+0x58>
  800c62:	66 90                	xchg   %ax,%ax
  800c64:	66 90                	xchg   %ax,%ax
  800c66:	66 90                	xchg   %ax,%ax
  800c68:	66 90                	xchg   %ax,%ax
  800c6a:	66 90                	xchg   %ax,%ax
  800c6c:	66 90                	xchg   %ax,%ax
  800c6e:	66 90                	xchg   %ax,%ax

00800c70 <__udivdi3>:
  800c70:	55                   	push   %ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 1c             	sub    $0x1c,%esp
  800c77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c87:	85 d2                	test   %edx,%edx
  800c89:	75 35                	jne    800cc0 <__udivdi3+0x50>
  800c8b:	39 f3                	cmp    %esi,%ebx
  800c8d:	0f 87 bd 00 00 00    	ja     800d50 <__udivdi3+0xe0>
  800c93:	85 db                	test   %ebx,%ebx
  800c95:	89 d9                	mov    %ebx,%ecx
  800c97:	75 0b                	jne    800ca4 <__udivdi3+0x34>
  800c99:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9e:	31 d2                	xor    %edx,%edx
  800ca0:	f7 f3                	div    %ebx
  800ca2:	89 c1                	mov    %eax,%ecx
  800ca4:	31 d2                	xor    %edx,%edx
  800ca6:	89 f0                	mov    %esi,%eax
  800ca8:	f7 f1                	div    %ecx
  800caa:	89 c6                	mov    %eax,%esi
  800cac:	89 e8                	mov    %ebp,%eax
  800cae:	89 f7                	mov    %esi,%edi
  800cb0:	f7 f1                	div    %ecx
  800cb2:	89 fa                	mov    %edi,%edx
  800cb4:	83 c4 1c             	add    $0x1c,%esp
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    
  800cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cc0:	39 f2                	cmp    %esi,%edx
  800cc2:	77 7c                	ja     800d40 <__udivdi3+0xd0>
  800cc4:	0f bd fa             	bsr    %edx,%edi
  800cc7:	83 f7 1f             	xor    $0x1f,%edi
  800cca:	0f 84 98 00 00 00    	je     800d68 <__udivdi3+0xf8>
  800cd0:	89 f9                	mov    %edi,%ecx
  800cd2:	b8 20 00 00 00       	mov    $0x20,%eax
  800cd7:	29 f8                	sub    %edi,%eax
  800cd9:	d3 e2                	shl    %cl,%edx
  800cdb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800cdf:	89 c1                	mov    %eax,%ecx
  800ce1:	89 da                	mov    %ebx,%edx
  800ce3:	d3 ea                	shr    %cl,%edx
  800ce5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ce9:	09 d1                	or     %edx,%ecx
  800ceb:	89 f2                	mov    %esi,%edx
  800ced:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cf1:	89 f9                	mov    %edi,%ecx
  800cf3:	d3 e3                	shl    %cl,%ebx
  800cf5:	89 c1                	mov    %eax,%ecx
  800cf7:	d3 ea                	shr    %cl,%edx
  800cf9:	89 f9                	mov    %edi,%ecx
  800cfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cff:	d3 e6                	shl    %cl,%esi
  800d01:	89 eb                	mov    %ebp,%ebx
  800d03:	89 c1                	mov    %eax,%ecx
  800d05:	d3 eb                	shr    %cl,%ebx
  800d07:	09 de                	or     %ebx,%esi
  800d09:	89 f0                	mov    %esi,%eax
  800d0b:	f7 74 24 08          	divl   0x8(%esp)
  800d0f:	89 d6                	mov    %edx,%esi
  800d11:	89 c3                	mov    %eax,%ebx
  800d13:	f7 64 24 0c          	mull   0xc(%esp)
  800d17:	39 d6                	cmp    %edx,%esi
  800d19:	72 0c                	jb     800d27 <__udivdi3+0xb7>
  800d1b:	89 f9                	mov    %edi,%ecx
  800d1d:	d3 e5                	shl    %cl,%ebp
  800d1f:	39 c5                	cmp    %eax,%ebp
  800d21:	73 5d                	jae    800d80 <__udivdi3+0x110>
  800d23:	39 d6                	cmp    %edx,%esi
  800d25:	75 59                	jne    800d80 <__udivdi3+0x110>
  800d27:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d2a:	31 ff                	xor    %edi,%edi
  800d2c:	89 fa                	mov    %edi,%edx
  800d2e:	83 c4 1c             	add    $0x1c,%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
  800d36:	8d 76 00             	lea    0x0(%esi),%esi
  800d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d40:	31 ff                	xor    %edi,%edi
  800d42:	31 c0                	xor    %eax,%eax
  800d44:	89 fa                	mov    %edi,%edx
  800d46:	83 c4 1c             	add    $0x1c,%esp
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    
  800d4e:	66 90                	xchg   %ax,%ax
  800d50:	31 ff                	xor    %edi,%edi
  800d52:	89 e8                	mov    %ebp,%eax
  800d54:	89 f2                	mov    %esi,%edx
  800d56:	f7 f3                	div    %ebx
  800d58:	89 fa                	mov    %edi,%edx
  800d5a:	83 c4 1c             	add    $0x1c,%esp
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
  800d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d68:	39 f2                	cmp    %esi,%edx
  800d6a:	72 06                	jb     800d72 <__udivdi3+0x102>
  800d6c:	31 c0                	xor    %eax,%eax
  800d6e:	39 eb                	cmp    %ebp,%ebx
  800d70:	77 d2                	ja     800d44 <__udivdi3+0xd4>
  800d72:	b8 01 00 00 00       	mov    $0x1,%eax
  800d77:	eb cb                	jmp    800d44 <__udivdi3+0xd4>
  800d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d80:	89 d8                	mov    %ebx,%eax
  800d82:	31 ff                	xor    %edi,%edi
  800d84:	eb be                	jmp    800d44 <__udivdi3+0xd4>
  800d86:	66 90                	xchg   %ax,%ax
  800d88:	66 90                	xchg   %ax,%ax
  800d8a:	66 90                	xchg   %ax,%ax
  800d8c:	66 90                	xchg   %ax,%ax
  800d8e:	66 90                	xchg   %ax,%ax

00800d90 <__umoddi3>:
  800d90:	55                   	push   %ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 1c             	sub    $0x1c,%esp
  800d97:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800d9b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d9f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800da3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800da7:	85 ed                	test   %ebp,%ebp
  800da9:	89 f0                	mov    %esi,%eax
  800dab:	89 da                	mov    %ebx,%edx
  800dad:	75 19                	jne    800dc8 <__umoddi3+0x38>
  800daf:	39 df                	cmp    %ebx,%edi
  800db1:	0f 86 b1 00 00 00    	jbe    800e68 <__umoddi3+0xd8>
  800db7:	f7 f7                	div    %edi
  800db9:	89 d0                	mov    %edx,%eax
  800dbb:	31 d2                	xor    %edx,%edx
  800dbd:	83 c4 1c             	add    $0x1c,%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
  800dc5:	8d 76 00             	lea    0x0(%esi),%esi
  800dc8:	39 dd                	cmp    %ebx,%ebp
  800dca:	77 f1                	ja     800dbd <__umoddi3+0x2d>
  800dcc:	0f bd cd             	bsr    %ebp,%ecx
  800dcf:	83 f1 1f             	xor    $0x1f,%ecx
  800dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800dd6:	0f 84 b4 00 00 00    	je     800e90 <__umoddi3+0x100>
  800ddc:	b8 20 00 00 00       	mov    $0x20,%eax
  800de1:	89 c2                	mov    %eax,%edx
  800de3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800de7:	29 c2                	sub    %eax,%edx
  800de9:	89 c1                	mov    %eax,%ecx
  800deb:	89 f8                	mov    %edi,%eax
  800ded:	d3 e5                	shl    %cl,%ebp
  800def:	89 d1                	mov    %edx,%ecx
  800df1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800df5:	d3 e8                	shr    %cl,%eax
  800df7:	09 c5                	or     %eax,%ebp
  800df9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dfd:	89 c1                	mov    %eax,%ecx
  800dff:	d3 e7                	shl    %cl,%edi
  800e01:	89 d1                	mov    %edx,%ecx
  800e03:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e07:	89 df                	mov    %ebx,%edi
  800e09:	d3 ef                	shr    %cl,%edi
  800e0b:	89 c1                	mov    %eax,%ecx
  800e0d:	89 f0                	mov    %esi,%eax
  800e0f:	d3 e3                	shl    %cl,%ebx
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 fa                	mov    %edi,%edx
  800e15:	d3 e8                	shr    %cl,%eax
  800e17:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e1c:	09 d8                	or     %ebx,%eax
  800e1e:	f7 f5                	div    %ebp
  800e20:	d3 e6                	shl    %cl,%esi
  800e22:	89 d1                	mov    %edx,%ecx
  800e24:	f7 64 24 08          	mull   0x8(%esp)
  800e28:	39 d1                	cmp    %edx,%ecx
  800e2a:	89 c3                	mov    %eax,%ebx
  800e2c:	89 d7                	mov    %edx,%edi
  800e2e:	72 06                	jb     800e36 <__umoddi3+0xa6>
  800e30:	75 0e                	jne    800e40 <__umoddi3+0xb0>
  800e32:	39 c6                	cmp    %eax,%esi
  800e34:	73 0a                	jae    800e40 <__umoddi3+0xb0>
  800e36:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e3a:	19 ea                	sbb    %ebp,%edx
  800e3c:	89 d7                	mov    %edx,%edi
  800e3e:	89 c3                	mov    %eax,%ebx
  800e40:	89 ca                	mov    %ecx,%edx
  800e42:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e47:	29 de                	sub    %ebx,%esi
  800e49:	19 fa                	sbb    %edi,%edx
  800e4b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e4f:	89 d0                	mov    %edx,%eax
  800e51:	d3 e0                	shl    %cl,%eax
  800e53:	89 d9                	mov    %ebx,%ecx
  800e55:	d3 ee                	shr    %cl,%esi
  800e57:	d3 ea                	shr    %cl,%edx
  800e59:	09 f0                	or     %esi,%eax
  800e5b:	83 c4 1c             	add    $0x1c,%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
  800e63:	90                   	nop
  800e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e68:	85 ff                	test   %edi,%edi
  800e6a:	89 f9                	mov    %edi,%ecx
  800e6c:	75 0b                	jne    800e79 <__umoddi3+0xe9>
  800e6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e73:	31 d2                	xor    %edx,%edx
  800e75:	f7 f7                	div    %edi
  800e77:	89 c1                	mov    %eax,%ecx
  800e79:	89 d8                	mov    %ebx,%eax
  800e7b:	31 d2                	xor    %edx,%edx
  800e7d:	f7 f1                	div    %ecx
  800e7f:	89 f0                	mov    %esi,%eax
  800e81:	f7 f1                	div    %ecx
  800e83:	e9 31 ff ff ff       	jmp    800db9 <__umoddi3+0x29>
  800e88:	90                   	nop
  800e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e90:	39 dd                	cmp    %ebx,%ebp
  800e92:	72 08                	jb     800e9c <__umoddi3+0x10c>
  800e94:	39 f7                	cmp    %esi,%edi
  800e96:	0f 87 21 ff ff ff    	ja     800dbd <__umoddi3+0x2d>
  800e9c:	89 da                	mov    %ebx,%edx
  800e9e:	89 f0                	mov    %esi,%eax
  800ea0:	29 f8                	sub    %edi,%eax
  800ea2:	19 ea                	sbb    %ebp,%edx
  800ea4:	e9 14 ff ff ff       	jmp    800dbd <__umoddi3+0x2d>
