
obj/user/divzero：     文件格式 elf32-i386


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
  80002c:	e8 46 00 00 00       	call   800077 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	e8 34 00 00 00       	call   800073 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	zero = 0;
  800045:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80004b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800051:	b8 01 00 00 00       	mov    $0x1,%eax
  800056:	b9 00 00 00 00       	mov    $0x0,%ecx
  80005b:	99                   	cltd   
  80005c:	f7 f9                	idiv   %ecx
  80005e:	50                   	push   %eax
  80005f:	8d 83 bc ee ff ff    	lea    -0x1144(%ebx),%eax
  800065:	50                   	push   %eax
  800066:	e8 27 01 00 00       	call   800192 <cprintf>
}
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800071:	c9                   	leave  
  800072:	c3                   	ret    

00800073 <__x86.get_pc_thunk.bx>:
  800073:	8b 1c 24             	mov    (%esp),%ebx
  800076:	c3                   	ret    

00800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 f2 ff ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  800081:	81 c3 7f 1f 00 00    	add    $0x1f7f,%ebx
  800087:	8b 45 08             	mov    0x8(%ebp),%eax
  80008a:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80008d:	c7 c1 30 20 80 00    	mov    $0x802030,%ecx
  800093:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  800099:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009b:	85 c0                	test   %eax,%eax
  80009d:	7e 08                	jle    8000a7 <libmain+0x30>
		binaryname = argv[0];
  80009f:	8b 0a                	mov    (%edx),%ecx
  8000a1:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	e8 82 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b1:	e8 0a 00 00 00       	call   8000c0 <exit>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 10             	sub    $0x10,%esp
  8000c7:	e8 a7 ff ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  8000cc:	81 c3 34 1f 00 00    	add    $0x1f34,%ebx
	sys_env_destroy(0);
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 ca 0a 00 00       	call   800ba3 <sys_env_destroy>
}
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	e8 88 ff ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  8000eb:	81 c3 15 1f 00 00    	add    $0x1f15,%ebx
  8000f1:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8000f4:	8b 16                	mov    (%esi),%edx
  8000f6:	8d 42 01             	lea    0x1(%edx),%eax
  8000f9:	89 06                	mov    %eax,(%esi)
  8000fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000fe:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800102:	3d ff 00 00 00       	cmp    $0xff,%eax
  800107:	74 0b                	je     800114 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800109:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80010d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	68 ff 00 00 00       	push   $0xff
  80011c:	8d 46 08             	lea    0x8(%esi),%eax
  80011f:	50                   	push   %eax
  800120:	e8 41 0a 00 00       	call   800b66 <sys_cputs>
		b->idx = 0;
  800125:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb d9                	jmp    800109 <putch+0x28>

00800130 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	53                   	push   %ebx
  800134:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80013a:	e8 34 ff ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  80013f:	81 c3 c1 1e 00 00    	add    $0x1ec1,%ebx
	struct printbuf b;

	b.idx = 0;
  800145:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014c:	00 00 00 
	b.cnt = 0;
  80014f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800156:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800165:	50                   	push   %eax
  800166:	8d 83 e1 e0 ff ff    	lea    -0x1f1f(%ebx),%eax
  80016c:	50                   	push   %eax
  80016d:	e8 38 01 00 00       	call   8002aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 df 09 00 00       	call   800b66 <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800198:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019b:	50                   	push   %eax
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	e8 8c ff ff ff       	call   800130 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 2c             	sub    $0x2c,%esp
  8001af:	e8 3a 06 00 00       	call   8007ee <__x86.get_pc_thunk.cx>
  8001b4:	81 c1 4c 1e 00 00    	add    $0x1e4c,%ecx
  8001ba:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8001bd:	89 c7                	mov    %eax,%edi
  8001bf:	89 d6                	mov    %edx,%esi
  8001c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001ca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8001cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8001d8:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8001db:	39 d3                	cmp    %edx,%ebx
  8001dd:	72 09                	jb     8001e8 <printnum+0x42>
  8001df:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001e2:	0f 87 83 00 00 00    	ja     80026b <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e8:	83 ec 0c             	sub    $0xc,%esp
  8001eb:	ff 75 18             	pushl  0x18(%ebp)
  8001ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001f4:	53                   	push   %ebx
  8001f5:	ff 75 10             	pushl  0x10(%ebp)
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fe:	ff 75 d8             	pushl  -0x28(%ebp)
  800201:	ff 75 d4             	pushl  -0x2c(%ebp)
  800204:	ff 75 d0             	pushl  -0x30(%ebp)
  800207:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80020a:	e8 71 0a 00 00       	call   800c80 <__udivdi3>
  80020f:	83 c4 18             	add    $0x18,%esp
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	89 f2                	mov    %esi,%edx
  800216:	89 f8                	mov    %edi,%eax
  800218:	e8 89 ff ff ff       	call   8001a6 <printnum>
  80021d:	83 c4 20             	add    $0x20,%esp
  800220:	eb 13                	jmp    800235 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	56                   	push   %esi
  800226:	ff 75 18             	pushl  0x18(%ebp)
  800229:	ff d7                	call   *%edi
  80022b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80022e:	83 eb 01             	sub    $0x1,%ebx
  800231:	85 db                	test   %ebx,%ebx
  800233:	7f ed                	jg     800222 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	56                   	push   %esi
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	ff 75 dc             	pushl  -0x24(%ebp)
  80023f:	ff 75 d8             	pushl  -0x28(%ebp)
  800242:	ff 75 d4             	pushl  -0x2c(%ebp)
  800245:	ff 75 d0             	pushl  -0x30(%ebp)
  800248:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80024b:	89 f3                	mov    %esi,%ebx
  80024d:	e8 4e 0b 00 00       	call   800da0 <__umoddi3>
  800252:	83 c4 14             	add    $0x14,%esp
  800255:	0f be 84 06 d4 ee ff 	movsbl -0x112c(%esi,%eax,1),%eax
  80025c:	ff 
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
  80026b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026e:	eb be                	jmp    80022e <printnum+0x88>

00800270 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800276:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027a:	8b 10                	mov    (%eax),%edx
  80027c:	3b 50 04             	cmp    0x4(%eax),%edx
  80027f:	73 0a                	jae    80028b <sprintputch+0x1b>
		*b->buf++ = ch;
  800281:	8d 4a 01             	lea    0x1(%edx),%ecx
  800284:	89 08                	mov    %ecx,(%eax)
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	88 02                	mov    %al,(%edx)
}
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <printfmt>:
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800293:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800296:	50                   	push   %eax
  800297:	ff 75 10             	pushl  0x10(%ebp)
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	e8 05 00 00 00       	call   8002aa <vprintfmt>
}
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <vprintfmt>:
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 2c             	sub    $0x2c,%esp
  8002b3:	e8 bb fd ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  8002b8:	81 c3 48 1d 00 00    	add    $0x1d48,%ebx
  8002be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c4:	e9 fb 03 00 00       	jmp    8006c4 <.L35+0x48>
		padc = ' ';
  8002c9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d4:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8002db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e7:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ea:	8d 47 01             	lea    0x1(%edi),%eax
  8002ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002f0:	0f b6 17             	movzbl (%edi),%edx
  8002f3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f6:	3c 55                	cmp    $0x55,%al
  8002f8:	0f 87 4e 04 00 00    	ja     80074c <.L22>
  8002fe:	0f b6 c0             	movzbl %al,%eax
  800301:	89 d9                	mov    %ebx,%ecx
  800303:	03 8c 83 64 ef ff ff 	add    -0x109c(%ebx,%eax,4),%ecx
  80030a:	ff e1                	jmp    *%ecx

0080030c <.L71>:
  80030c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80030f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800313:	eb d5                	jmp    8002ea <vprintfmt+0x40>

00800315 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800318:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80031c:	eb cc                	jmp    8002ea <vprintfmt+0x40>

0080031e <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  80031e:	0f b6 d2             	movzbl %dl,%edx
  800321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800324:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800329:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80032c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800330:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800333:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800336:	83 f9 09             	cmp    $0x9,%ecx
  800339:	77 55                	ja     800390 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  80033b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033e:	eb e9                	jmp    800329 <.L29+0xb>

00800340 <.L26>:
			precision = va_arg(ap, int);
  800340:	8b 45 14             	mov    0x14(%ebp),%eax
  800343:	8b 00                	mov    (%eax),%eax
  800345:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800348:	8b 45 14             	mov    0x14(%ebp),%eax
  80034b:	8d 40 04             	lea    0x4(%eax),%eax
  80034e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800354:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800358:	79 90                	jns    8002ea <vprintfmt+0x40>
				width = precision, precision = -1;
  80035a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80035d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800360:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800367:	eb 81                	jmp    8002ea <vprintfmt+0x40>

00800369 <.L27>:
  800369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	ba 00 00 00 00       	mov    $0x0,%edx
  800373:	0f 49 d0             	cmovns %eax,%edx
  800376:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80037c:	e9 69 ff ff ff       	jmp    8002ea <vprintfmt+0x40>

00800381 <.L23>:
  800381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800384:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80038b:	e9 5a ff ff ff       	jmp    8002ea <vprintfmt+0x40>
  800390:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800393:	eb bf                	jmp    800354 <.L26+0x14>

00800395 <.L33>:
			lflag++;
  800395:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039c:	e9 49 ff ff ff       	jmp    8002ea <vprintfmt+0x40>

008003a1 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a4:	8d 78 04             	lea    0x4(%eax),%edi
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	56                   	push   %esi
  8003ab:	ff 30                	pushl  (%eax)
  8003ad:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b6:	e9 06 03 00 00       	jmp    8006c1 <.L35+0x45>

008003bb <.L32>:
			err = va_arg(ap, int);
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8d 78 04             	lea    0x4(%eax),%edi
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	99                   	cltd   
  8003c4:	31 d0                	xor    %edx,%eax
  8003c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c8:	83 f8 06             	cmp    $0x6,%eax
  8003cb:	7f 27                	jg     8003f4 <.L32+0x39>
  8003cd:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8003d4:	85 d2                	test   %edx,%edx
  8003d6:	74 1c                	je     8003f4 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8003d8:	52                   	push   %edx
  8003d9:	8d 83 f5 ee ff ff    	lea    -0x110b(%ebx),%eax
  8003df:	50                   	push   %eax
  8003e0:	56                   	push   %esi
  8003e1:	ff 75 08             	pushl  0x8(%ebp)
  8003e4:	e8 a4 fe ff ff       	call   80028d <printfmt>
  8003e9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ec:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003ef:	e9 cd 02 00 00       	jmp    8006c1 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8003f4:	50                   	push   %eax
  8003f5:	8d 83 ec ee ff ff    	lea    -0x1114(%ebx),%eax
  8003fb:	50                   	push   %eax
  8003fc:	56                   	push   %esi
  8003fd:	ff 75 08             	pushl  0x8(%ebp)
  800400:	e8 88 fe ff ff       	call   80028d <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80040b:	e9 b1 02 00 00       	jmp    8006c1 <.L35+0x45>

00800410 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  800410:	8b 45 14             	mov    0x14(%ebp),%eax
  800413:	83 c0 04             	add    $0x4,%eax
  800416:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80041e:	85 ff                	test   %edi,%edi
  800420:	8d 83 e5 ee ff ff    	lea    -0x111b(%ebx),%eax
  800426:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800429:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042d:	0f 8e b5 00 00 00    	jle    8004e8 <.L36+0xd8>
  800433:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800437:	75 08                	jne    800441 <.L36+0x31>
  800439:	89 75 0c             	mov    %esi,0xc(%ebp)
  80043c:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80043f:	eb 6d                	jmp    8004ae <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 cc             	pushl  -0x34(%ebp)
  800447:	57                   	push   %edi
  800448:	e8 bd 03 00 00       	call   80080a <strnlen>
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	29 c2                	sub    %eax,%edx
  800452:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800455:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800458:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80045c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800462:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800464:	eb 10                	jmp    800476 <.L36+0x66>
					putch(padc, putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	56                   	push   %esi
  80046a:	ff 75 e0             	pushl  -0x20(%ebp)
  80046d:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800470:	83 ef 01             	sub    $0x1,%edi
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	85 ff                	test   %edi,%edi
  800478:	7f ec                	jg     800466 <.L36+0x56>
  80047a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80047d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	b8 00 00 00 00       	mov    $0x0,%eax
  800487:	0f 49 c2             	cmovns %edx,%eax
  80048a:	29 c2                	sub    %eax,%edx
  80048c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80048f:	89 75 0c             	mov    %esi,0xc(%ebp)
  800492:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800495:	eb 17                	jmp    8004ae <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800497:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049b:	75 30                	jne    8004cd <.L36+0xbd>
					putch(ch, putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 0c             	pushl  0xc(%ebp)
  8004a3:	50                   	push   %eax
  8004a4:	ff 55 08             	call   *0x8(%ebp)
  8004a7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004aa:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004ae:	83 c7 01             	add    $0x1,%edi
  8004b1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004b5:	0f be c2             	movsbl %dl,%eax
  8004b8:	85 c0                	test   %eax,%eax
  8004ba:	74 52                	je     80050e <.L36+0xfe>
  8004bc:	85 f6                	test   %esi,%esi
  8004be:	78 d7                	js     800497 <.L36+0x87>
  8004c0:	83 ee 01             	sub    $0x1,%esi
  8004c3:	79 d2                	jns    800497 <.L36+0x87>
  8004c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004cb:	eb 32                	jmp    8004ff <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	0f be d2             	movsbl %dl,%edx
  8004d0:	83 ea 20             	sub    $0x20,%edx
  8004d3:	83 fa 5e             	cmp    $0x5e,%edx
  8004d6:	76 c5                	jbe    80049d <.L36+0x8d>
					putch('?', putdat);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	6a 3f                	push   $0x3f
  8004e0:	ff 55 08             	call   *0x8(%ebp)
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	eb c2                	jmp    8004aa <.L36+0x9a>
  8004e8:	89 75 0c             	mov    %esi,0xc(%ebp)
  8004eb:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004ee:	eb be                	jmp    8004ae <.L36+0x9e>
				putch(' ', putdat);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	56                   	push   %esi
  8004f4:	6a 20                	push   $0x20
  8004f6:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8004f9:	83 ef 01             	sub    $0x1,%edi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	85 ff                	test   %edi,%edi
  800501:	7f ed                	jg     8004f0 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  800503:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800506:	89 45 14             	mov    %eax,0x14(%ebp)
  800509:	e9 b3 01 00 00       	jmp    8006c1 <.L35+0x45>
  80050e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800511:	8b 75 0c             	mov    0xc(%ebp),%esi
  800514:	eb e9                	jmp    8004ff <.L36+0xef>

00800516 <.L31>:
  800516:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800519:	83 f9 01             	cmp    $0x1,%ecx
  80051c:	7e 40                	jle    80055e <.L31+0x48>
		return va_arg(*ap, long long);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 50 04             	mov    0x4(%eax),%edx
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 08             	lea    0x8(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800539:	79 55                	jns    800590 <.L31+0x7a>
				putch('-', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	56                   	push   %esi
  80053f:	6a 2d                	push   $0x2d
  800541:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800544:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800547:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80054a:	f7 da                	neg    %edx
  80054c:	83 d1 00             	adc    $0x0,%ecx
  80054f:	f7 d9                	neg    %ecx
  800551:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800554:	b8 0a 00 00 00       	mov    $0xa,%eax
  800559:	e9 48 01 00 00       	jmp    8006a6 <.L35+0x2a>
	else if (lflag)
  80055e:	85 c9                	test   %ecx,%ecx
  800560:	75 17                	jne    800579 <.L31+0x63>
		return va_arg(*ap, int);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056a:	99                   	cltd   
  80056b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 40 04             	lea    0x4(%eax),%eax
  800574:	89 45 14             	mov    %eax,0x14(%ebp)
  800577:	eb bc                	jmp    800535 <.L31+0x1f>
		return va_arg(*ap, long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800581:	99                   	cltd   
  800582:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 40 04             	lea    0x4(%eax),%eax
  80058b:	89 45 14             	mov    %eax,0x14(%ebp)
  80058e:	eb a5                	jmp    800535 <.L31+0x1f>
			num = getint(&ap, lflag);
  800590:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800593:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800596:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059b:	e9 06 01 00 00       	jmp    8006a6 <.L35+0x2a>

008005a0 <.L37>:
  8005a0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005a3:	83 f9 01             	cmp    $0x1,%ecx
  8005a6:	7e 18                	jle    8005c0 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 10                	mov    (%eax),%edx
  8005ad:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b0:	8d 40 08             	lea    0x8(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bb:	e9 e6 00 00 00       	jmp    8006a6 <.L35+0x2a>
	else if (lflag)
  8005c0:	85 c9                	test   %ecx,%ecx
  8005c2:	75 1a                	jne    8005de <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 10                	mov    (%eax),%edx
  8005c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ce:	8d 40 04             	lea    0x4(%eax),%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d9:	e9 c8 00 00 00       	jmp    8006a6 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f3:	e9 ae 00 00 00       	jmp    8006a6 <.L35+0x2a>

008005f8 <.L34>:
  8005f8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005fb:	83 f9 01             	cmp    $0x1,%ecx
  8005fe:	7e 3d                	jle    80063d <.L34+0x45>
		return va_arg(*ap, long long);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 50 04             	mov    0x4(%eax),%edx
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 40 08             	lea    0x8(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800617:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061b:	79 52                	jns    80066f <.L34+0x77>
                putch('-', putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	56                   	push   %esi
  800621:	6a 2d                	push   $0x2d
  800623:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800626:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800629:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80062c:	f7 da                	neg    %edx
  80062e:	83 d1 00             	adc    $0x0,%ecx
  800631:	f7 d9                	neg    %ecx
  800633:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800636:	b8 08 00 00 00       	mov    $0x8,%eax
  80063b:	eb 69                	jmp    8006a6 <.L35+0x2a>
	else if (lflag)
  80063d:	85 c9                	test   %ecx,%ecx
  80063f:	75 17                	jne    800658 <.L34+0x60>
		return va_arg(*ap, int);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800649:	99                   	cltd   
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
  800656:	eb bf                	jmp    800617 <.L34+0x1f>
		return va_arg(*ap, long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	99                   	cltd   
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	eb a8                	jmp    800617 <.L34+0x1f>
            num = getint(&ap, lflag);
  80066f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800672:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800675:	b8 08 00 00 00       	mov    $0x8,%eax
  80067a:	eb 2a                	jmp    8006a6 <.L35+0x2a>

0080067c <.L35>:
			putch('0', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	56                   	push   %esi
  800680:	6a 30                	push   $0x30
  800682:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800685:	83 c4 08             	add    $0x8,%esp
  800688:	56                   	push   %esi
  800689:	6a 78                	push   $0x78
  80068b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 10                	mov    (%eax),%edx
  800693:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800698:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ad:	57                   	push   %edi
  8006ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b1:	50                   	push   %eax
  8006b2:	51                   	push   %ecx
  8006b3:	52                   	push   %edx
  8006b4:	89 f2                	mov    %esi,%edx
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	e8 e8 fa ff ff       	call   8001a6 <printnum>
			break;
  8006be:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c4:	83 c7 01             	add    $0x1,%edi
  8006c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cb:	83 f8 25             	cmp    $0x25,%eax
  8006ce:	0f 84 f5 fb ff ff    	je     8002c9 <vprintfmt+0x1f>
			if (ch == '\0')
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	0f 84 91 00 00 00    	je     80076d <.L22+0x21>
			putch(ch, putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	56                   	push   %esi
  8006e0:	50                   	push   %eax
  8006e1:	ff 55 08             	call   *0x8(%ebp)
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	eb db                	jmp    8006c4 <.L35+0x48>

008006e9 <.L38>:
  8006e9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006ec:	83 f9 01             	cmp    $0x1,%ecx
  8006ef:	7e 15                	jle    800706 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 10                	mov    (%eax),%edx
  8006f6:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f9:	8d 40 08             	lea    0x8(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ff:	b8 10 00 00 00       	mov    $0x10,%eax
  800704:	eb a0                	jmp    8006a6 <.L35+0x2a>
	else if (lflag)
  800706:	85 c9                	test   %ecx,%ecx
  800708:	75 17                	jne    800721 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071a:	b8 10 00 00 00       	mov    $0x10,%eax
  80071f:	eb 85                	jmp    8006a6 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 10                	mov    (%eax),%edx
  800726:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800731:	b8 10 00 00 00       	mov    $0x10,%eax
  800736:	e9 6b ff ff ff       	jmp    8006a6 <.L35+0x2a>

0080073b <.L25>:
			putch(ch, putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	56                   	push   %esi
  80073f:	6a 25                	push   $0x25
  800741:	ff 55 08             	call   *0x8(%ebp)
			break;
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	e9 75 ff ff ff       	jmp    8006c1 <.L35+0x45>

0080074c <.L22>:
			putch('%', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	56                   	push   %esi
  800750:	6a 25                	push   $0x25
  800752:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	89 f8                	mov    %edi,%eax
  80075a:	eb 03                	jmp    80075f <.L22+0x13>
  80075c:	83 e8 01             	sub    $0x1,%eax
  80075f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800763:	75 f7                	jne    80075c <.L22+0x10>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800768:	e9 54 ff ff ff       	jmp    8006c1 <.L35+0x45>
}
  80076d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800770:	5b                   	pop    %ebx
  800771:	5e                   	pop    %esi
  800772:	5f                   	pop    %edi
  800773:	5d                   	pop    %ebp
  800774:	c3                   	ret    

00800775 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	53                   	push   %ebx
  800779:	83 ec 14             	sub    $0x14,%esp
  80077c:	e8 f2 f8 ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  800781:	81 c3 7f 18 00 00    	add    $0x187f,%ebx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800790:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800794:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	74 2b                	je     8007cd <vsnprintf+0x58>
  8007a2:	85 d2                	test   %edx,%edx
  8007a4:	7e 27                	jle    8007cd <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a6:	ff 75 14             	pushl  0x14(%ebp)
  8007a9:	ff 75 10             	pushl  0x10(%ebp)
  8007ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007af:	50                   	push   %eax
  8007b0:	8d 83 70 e2 ff ff    	lea    -0x1d90(%ebx),%eax
  8007b6:	50                   	push   %eax
  8007b7:	e8 ee fa ff ff       	call   8002aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007bf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c5:	83 c4 10             	add    $0x10,%esp
}
  8007c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    
		return -E_INVAL;
  8007cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d2:	eb f4                	jmp    8007c8 <vsnprintf+0x53>

008007d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007da:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007dd:	50                   	push   %eax
  8007de:	ff 75 10             	pushl  0x10(%ebp)
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	ff 75 08             	pushl  0x8(%ebp)
  8007e7:	e8 89 ff ff ff       	call   800775 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <__x86.get_pc_thunk.cx>:
  8007ee:	8b 0c 24             	mov    (%esp),%ecx
  8007f1:	c3                   	ret    

008007f2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	eb 03                	jmp    800802 <strlen+0x10>
		n++;
  8007ff:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800802:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800806:	75 f7                	jne    8007ff <strlen+0xd>
	return n;
}
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800810:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800813:	b8 00 00 00 00       	mov    $0x0,%eax
  800818:	eb 03                	jmp    80081d <strnlen+0x13>
		n++;
  80081a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081d:	39 d0                	cmp    %edx,%eax
  80081f:	74 06                	je     800827 <strnlen+0x1d>
  800821:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800825:	75 f3                	jne    80081a <strnlen+0x10>
	return n;
}
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	53                   	push   %ebx
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800833:	89 c2                	mov    %eax,%edx
  800835:	83 c1 01             	add    $0x1,%ecx
  800838:	83 c2 01             	add    $0x1,%edx
  80083b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80083f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800842:	84 db                	test   %bl,%bl
  800844:	75 ef                	jne    800835 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800846:	5b                   	pop    %ebx
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800850:	53                   	push   %ebx
  800851:	e8 9c ff ff ff       	call   8007f2 <strlen>
  800856:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	01 d8                	add    %ebx,%eax
  80085e:	50                   	push   %eax
  80085f:	e8 c5 ff ff ff       	call   800829 <strcpy>
	return dst;
}
  800864:	89 d8                	mov    %ebx,%eax
  800866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	56                   	push   %esi
  80086f:	53                   	push   %ebx
  800870:	8b 75 08             	mov    0x8(%ebp),%esi
  800873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800876:	89 f3                	mov    %esi,%ebx
  800878:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80087b:	89 f2                	mov    %esi,%edx
  80087d:	eb 0f                	jmp    80088e <strncpy+0x23>
		*dst++ = *src;
  80087f:	83 c2 01             	add    $0x1,%edx
  800882:	0f b6 01             	movzbl (%ecx),%eax
  800885:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800888:	80 39 01             	cmpb   $0x1,(%ecx)
  80088b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80088e:	39 da                	cmp    %ebx,%edx
  800890:	75 ed                	jne    80087f <strncpy+0x14>
	}
	return ret;
}
  800892:	89 f0                	mov    %esi,%eax
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	56                   	push   %esi
  80089c:	53                   	push   %ebx
  80089d:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a6:	89 f0                	mov    %esi,%eax
  8008a8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ac:	85 c9                	test   %ecx,%ecx
  8008ae:	75 0b                	jne    8008bb <strlcpy+0x23>
  8008b0:	eb 17                	jmp    8008c9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b2:	83 c2 01             	add    $0x1,%edx
  8008b5:	83 c0 01             	add    $0x1,%eax
  8008b8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008bb:	39 d8                	cmp    %ebx,%eax
  8008bd:	74 07                	je     8008c6 <strlcpy+0x2e>
  8008bf:	0f b6 0a             	movzbl (%edx),%ecx
  8008c2:	84 c9                	test   %cl,%cl
  8008c4:	75 ec                	jne    8008b2 <strlcpy+0x1a>
		*dst = '\0';
  8008c6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008c9:	29 f0                	sub    %esi,%eax
}
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d8:	eb 06                	jmp    8008e0 <strcmp+0x11>
		p++, q++;
  8008da:	83 c1 01             	add    $0x1,%ecx
  8008dd:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008e0:	0f b6 01             	movzbl (%ecx),%eax
  8008e3:	84 c0                	test   %al,%al
  8008e5:	74 04                	je     8008eb <strcmp+0x1c>
  8008e7:	3a 02                	cmp    (%edx),%al
  8008e9:	74 ef                	je     8008da <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008eb:	0f b6 c0             	movzbl %al,%eax
  8008ee:	0f b6 12             	movzbl (%edx),%edx
  8008f1:	29 d0                	sub    %edx,%eax
}
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	53                   	push   %ebx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ff:	89 c3                	mov    %eax,%ebx
  800901:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800904:	eb 06                	jmp    80090c <strncmp+0x17>
		n--, p++, q++;
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80090c:	39 d8                	cmp    %ebx,%eax
  80090e:	74 16                	je     800926 <strncmp+0x31>
  800910:	0f b6 08             	movzbl (%eax),%ecx
  800913:	84 c9                	test   %cl,%cl
  800915:	74 04                	je     80091b <strncmp+0x26>
  800917:	3a 0a                	cmp    (%edx),%cl
  800919:	74 eb                	je     800906 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80091b:	0f b6 00             	movzbl (%eax),%eax
  80091e:	0f b6 12             	movzbl (%edx),%edx
  800921:	29 d0                	sub    %edx,%eax
}
  800923:	5b                   	pop    %ebx
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    
		return 0;
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	eb f6                	jmp    800923 <strncmp+0x2e>

0080092d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800937:	0f b6 10             	movzbl (%eax),%edx
  80093a:	84 d2                	test   %dl,%dl
  80093c:	74 09                	je     800947 <strchr+0x1a>
		if (*s == c)
  80093e:	38 ca                	cmp    %cl,%dl
  800940:	74 0a                	je     80094c <strchr+0x1f>
	for (; *s; s++)
  800942:	83 c0 01             	add    $0x1,%eax
  800945:	eb f0                	jmp    800937 <strchr+0xa>
			return (char *) s;
	return 0;
  800947:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800958:	eb 03                	jmp    80095d <strfind+0xf>
  80095a:	83 c0 01             	add    $0x1,%eax
  80095d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800960:	38 ca                	cmp    %cl,%dl
  800962:	74 04                	je     800968 <strfind+0x1a>
  800964:	84 d2                	test   %dl,%dl
  800966:	75 f2                	jne    80095a <strfind+0xc>
			break;
	return (char *) s;
}
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	57                   	push   %edi
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	8b 7d 08             	mov    0x8(%ebp),%edi
  800973:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800976:	85 c9                	test   %ecx,%ecx
  800978:	74 13                	je     80098d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800980:	75 05                	jne    800987 <memset+0x1d>
  800982:	f6 c1 03             	test   $0x3,%cl
  800985:	74 0d                	je     800994 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	fc                   	cld    
  80098b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098d:	89 f8                	mov    %edi,%eax
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5f                   	pop    %edi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    
		c &= 0xFF;
  800994:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800998:	89 d3                	mov    %edx,%ebx
  80099a:	c1 e3 08             	shl    $0x8,%ebx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	c1 e0 18             	shl    $0x18,%eax
  8009a2:	89 d6                	mov    %edx,%esi
  8009a4:	c1 e6 10             	shl    $0x10,%esi
  8009a7:	09 f0                	or     %esi,%eax
  8009a9:	09 c2                	or     %eax,%edx
  8009ab:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009ad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b0:	89 d0                	mov    %edx,%eax
  8009b2:	fc                   	cld    
  8009b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b5:	eb d6                	jmp    80098d <memset+0x23>

008009b7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c5:	39 c6                	cmp    %eax,%esi
  8009c7:	73 35                	jae    8009fe <memmove+0x47>
  8009c9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	76 2e                	jbe    8009fe <memmove+0x47>
		s += n;
		d += n;
  8009d0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d3:	89 d6                	mov    %edx,%esi
  8009d5:	09 fe                	or     %edi,%esi
  8009d7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009dd:	74 0c                	je     8009eb <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009df:	83 ef 01             	sub    $0x1,%edi
  8009e2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e5:	fd                   	std    
  8009e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e8:	fc                   	cld    
  8009e9:	eb 21                	jmp    800a0c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009eb:	f6 c1 03             	test   $0x3,%cl
  8009ee:	75 ef                	jne    8009df <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f0:	83 ef 04             	sub    $0x4,%edi
  8009f3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009f9:	fd                   	std    
  8009fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fc:	eb ea                	jmp    8009e8 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fe:	89 f2                	mov    %esi,%edx
  800a00:	09 c2                	or     %eax,%edx
  800a02:	f6 c2 03             	test   $0x3,%dl
  800a05:	74 09                	je     800a10 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a07:	89 c7                	mov    %eax,%edi
  800a09:	fc                   	cld    
  800a0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a0c:	5e                   	pop    %esi
  800a0d:	5f                   	pop    %edi
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a10:	f6 c1 03             	test   $0x3,%cl
  800a13:	75 f2                	jne    800a07 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a18:	89 c7                	mov    %eax,%edi
  800a1a:	fc                   	cld    
  800a1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1d:	eb ed                	jmp    800a0c <memmove+0x55>

00800a1f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a22:	ff 75 10             	pushl  0x10(%ebp)
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	ff 75 08             	pushl  0x8(%ebp)
  800a2b:	e8 87 ff ff ff       	call   8009b7 <memmove>
}
  800a30:	c9                   	leave  
  800a31:	c3                   	ret    

00800a32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3d:	89 c6                	mov    %eax,%esi
  800a3f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a42:	39 f0                	cmp    %esi,%eax
  800a44:	74 1c                	je     800a62 <memcmp+0x30>
		if (*s1 != *s2)
  800a46:	0f b6 08             	movzbl (%eax),%ecx
  800a49:	0f b6 1a             	movzbl (%edx),%ebx
  800a4c:	38 d9                	cmp    %bl,%cl
  800a4e:	75 08                	jne    800a58 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a50:	83 c0 01             	add    $0x1,%eax
  800a53:	83 c2 01             	add    $0x1,%edx
  800a56:	eb ea                	jmp    800a42 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a58:	0f b6 c1             	movzbl %cl,%eax
  800a5b:	0f b6 db             	movzbl %bl,%ebx
  800a5e:	29 d8                	sub    %ebx,%eax
  800a60:	eb 05                	jmp    800a67 <memcmp+0x35>
	}

	return 0;
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a67:	5b                   	pop    %ebx
  800a68:	5e                   	pop    %esi
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a74:	89 c2                	mov    %eax,%edx
  800a76:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a79:	39 d0                	cmp    %edx,%eax
  800a7b:	73 09                	jae    800a86 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a7d:	38 08                	cmp    %cl,(%eax)
  800a7f:	74 05                	je     800a86 <memfind+0x1b>
	for (; s < ends; s++)
  800a81:	83 c0 01             	add    $0x1,%eax
  800a84:	eb f3                	jmp    800a79 <memfind+0xe>
			break;
	return (void *) s;
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	57                   	push   %edi
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
  800a8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a94:	eb 03                	jmp    800a99 <strtol+0x11>
		s++;
  800a96:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a99:	0f b6 01             	movzbl (%ecx),%eax
  800a9c:	3c 20                	cmp    $0x20,%al
  800a9e:	74 f6                	je     800a96 <strtol+0xe>
  800aa0:	3c 09                	cmp    $0x9,%al
  800aa2:	74 f2                	je     800a96 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aa4:	3c 2b                	cmp    $0x2b,%al
  800aa6:	74 2e                	je     800ad6 <strtol+0x4e>
	int neg = 0;
  800aa8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aad:	3c 2d                	cmp    $0x2d,%al
  800aaf:	74 2f                	je     800ae0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ab7:	75 05                	jne    800abe <strtol+0x36>
  800ab9:	80 39 30             	cmpb   $0x30,(%ecx)
  800abc:	74 2c                	je     800aea <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800abe:	85 db                	test   %ebx,%ebx
  800ac0:	75 0a                	jne    800acc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ac7:	80 39 30             	cmpb   $0x30,(%ecx)
  800aca:	74 28                	je     800af4 <strtol+0x6c>
		base = 10;
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad4:	eb 50                	jmp    800b26 <strtol+0x9e>
		s++;
  800ad6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ade:	eb d1                	jmp    800ab1 <strtol+0x29>
		s++, neg = 1;
  800ae0:	83 c1 01             	add    $0x1,%ecx
  800ae3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae8:	eb c7                	jmp    800ab1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aea:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aee:	74 0e                	je     800afe <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800af0:	85 db                	test   %ebx,%ebx
  800af2:	75 d8                	jne    800acc <strtol+0x44>
		s++, base = 8;
  800af4:	83 c1 01             	add    $0x1,%ecx
  800af7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800afc:	eb ce                	jmp    800acc <strtol+0x44>
		s += 2, base = 16;
  800afe:	83 c1 02             	add    $0x2,%ecx
  800b01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b06:	eb c4                	jmp    800acc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0b:	89 f3                	mov    %esi,%ebx
  800b0d:	80 fb 19             	cmp    $0x19,%bl
  800b10:	77 29                	ja     800b3b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1b:	7d 30                	jge    800b4d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b26:	0f b6 11             	movzbl (%ecx),%edx
  800b29:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 09             	cmp    $0x9,%bl
  800b31:	77 d5                	ja     800b08 <strtol+0x80>
			dig = *s - '0';
  800b33:	0f be d2             	movsbl %dl,%edx
  800b36:	83 ea 30             	sub    $0x30,%edx
  800b39:	eb dd                	jmp    800b18 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b3b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b3e:	89 f3                	mov    %esi,%ebx
  800b40:	80 fb 19             	cmp    $0x19,%bl
  800b43:	77 08                	ja     800b4d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b45:	0f be d2             	movsbl %dl,%edx
  800b48:	83 ea 37             	sub    $0x37,%edx
  800b4b:	eb cb                	jmp    800b18 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b51:	74 05                	je     800b58 <strtol+0xd0>
		*endptr = (char *) s;
  800b53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b56:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b58:	89 c2                	mov    %eax,%edx
  800b5a:	f7 da                	neg    %edx
  800b5c:	85 ff                	test   %edi,%edi
  800b5e:	0f 45 c2             	cmovne %edx,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b71:	8b 55 08             	mov    0x8(%ebp),%edx
  800b74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	89 c7                	mov    %eax,%edi
  800b7b:	89 c6                	mov    %eax,%esi
  800b7d:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_cgetc>:

int
sys_cgetc(void) {
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
    asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 1c             	sub    $0x1c,%esp
  800bac:	e8 66 00 00 00       	call   800c17 <__x86.get_pc_thunk.ax>
  800bb1:	05 4f 14 00 00       	add    $0x144f,%eax
  800bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  800bb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc6:	89 cb                	mov    %ecx,%ebx
  800bc8:	89 cf                	mov    %ecx,%edi
  800bca:	89 ce                	mov    %ecx,%esi
  800bcc:	cd 30                	int    $0x30
    if (check && ret > 0)
  800bce:	85 c0                	test   %eax,%eax
  800bd0:	7f 08                	jg     800bda <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5f                   	pop    %edi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800bda:	83 ec 0c             	sub    $0xc,%esp
  800bdd:	50                   	push   %eax
  800bde:	6a 03                	push   $0x3
  800be0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800be3:	8d 83 bc f0 ff ff    	lea    -0xf44(%ebx),%eax
  800be9:	50                   	push   %eax
  800bea:	6a 24                	push   $0x24
  800bec:	8d 83 d9 f0 ff ff    	lea    -0xf27(%ebx),%eax
  800bf2:	50                   	push   %eax
  800bf3:	e8 23 00 00 00       	call   800c1b <_panic>

00800bf8 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
    asm volatile("int %1\n"
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	b8 02 00 00 00       	mov    $0x2,%eax
  800c08:	89 d1                	mov    %edx,%ecx
  800c0a:	89 d3                	mov    %edx,%ebx
  800c0c:	89 d7                	mov    %edx,%edi
  800c0e:	89 d6                	mov    %edx,%esi
  800c10:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <__x86.get_pc_thunk.ax>:
  800c17:	8b 04 24             	mov    (%esp),%eax
  800c1a:	c3                   	ret    

00800c1b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	83 ec 0c             	sub    $0xc,%esp
  800c24:	e8 4a f4 ff ff       	call   800073 <__x86.get_pc_thunk.bx>
  800c29:	81 c3 d7 13 00 00    	add    $0x13d7,%ebx
	va_list ap;

	va_start(ap, fmt);
  800c2f:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c32:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800c38:	8b 38                	mov    (%eax),%edi
  800c3a:	e8 b9 ff ff ff       	call   800bf8 <sys_getenvid>
  800c3f:	83 ec 0c             	sub    $0xc,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	ff 75 08             	pushl  0x8(%ebp)
  800c48:	57                   	push   %edi
  800c49:	50                   	push   %eax
  800c4a:	8d 83 e8 f0 ff ff    	lea    -0xf18(%ebx),%eax
  800c50:	50                   	push   %eax
  800c51:	e8 3c f5 ff ff       	call   800192 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c56:	83 c4 18             	add    $0x18,%esp
  800c59:	56                   	push   %esi
  800c5a:	ff 75 10             	pushl  0x10(%ebp)
  800c5d:	e8 ce f4 ff ff       	call   800130 <vcprintf>
	cprintf("\n");
  800c62:	8d 83 c8 ee ff ff    	lea    -0x1138(%ebx),%eax
  800c68:	89 04 24             	mov    %eax,(%esp)
  800c6b:	e8 22 f5 ff ff       	call   800192 <cprintf>
  800c70:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c73:	cc                   	int3   
  800c74:	eb fd                	jmp    800c73 <_panic+0x58>
  800c76:	66 90                	xchg   %ax,%ax
  800c78:	66 90                	xchg   %ax,%ax
  800c7a:	66 90                	xchg   %ax,%ax
  800c7c:	66 90                	xchg   %ax,%ax
  800c7e:	66 90                	xchg   %ax,%ax

00800c80 <__udivdi3>:
  800c80:	55                   	push   %ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 1c             	sub    $0x1c,%esp
  800c87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c97:	85 d2                	test   %edx,%edx
  800c99:	75 35                	jne    800cd0 <__udivdi3+0x50>
  800c9b:	39 f3                	cmp    %esi,%ebx
  800c9d:	0f 87 bd 00 00 00    	ja     800d60 <__udivdi3+0xe0>
  800ca3:	85 db                	test   %ebx,%ebx
  800ca5:	89 d9                	mov    %ebx,%ecx
  800ca7:	75 0b                	jne    800cb4 <__udivdi3+0x34>
  800ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  800cae:	31 d2                	xor    %edx,%edx
  800cb0:	f7 f3                	div    %ebx
  800cb2:	89 c1                	mov    %eax,%ecx
  800cb4:	31 d2                	xor    %edx,%edx
  800cb6:	89 f0                	mov    %esi,%eax
  800cb8:	f7 f1                	div    %ecx
  800cba:	89 c6                	mov    %eax,%esi
  800cbc:	89 e8                	mov    %ebp,%eax
  800cbe:	89 f7                	mov    %esi,%edi
  800cc0:	f7 f1                	div    %ecx
  800cc2:	89 fa                	mov    %edi,%edx
  800cc4:	83 c4 1c             	add    $0x1c,%esp
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
  800ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cd0:	39 f2                	cmp    %esi,%edx
  800cd2:	77 7c                	ja     800d50 <__udivdi3+0xd0>
  800cd4:	0f bd fa             	bsr    %edx,%edi
  800cd7:	83 f7 1f             	xor    $0x1f,%edi
  800cda:	0f 84 98 00 00 00    	je     800d78 <__udivdi3+0xf8>
  800ce0:	89 f9                	mov    %edi,%ecx
  800ce2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ce7:	29 f8                	sub    %edi,%eax
  800ce9:	d3 e2                	shl    %cl,%edx
  800ceb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800cef:	89 c1                	mov    %eax,%ecx
  800cf1:	89 da                	mov    %ebx,%edx
  800cf3:	d3 ea                	shr    %cl,%edx
  800cf5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cf9:	09 d1                	or     %edx,%ecx
  800cfb:	89 f2                	mov    %esi,%edx
  800cfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d01:	89 f9                	mov    %edi,%ecx
  800d03:	d3 e3                	shl    %cl,%ebx
  800d05:	89 c1                	mov    %eax,%ecx
  800d07:	d3 ea                	shr    %cl,%edx
  800d09:	89 f9                	mov    %edi,%ecx
  800d0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d0f:	d3 e6                	shl    %cl,%esi
  800d11:	89 eb                	mov    %ebp,%ebx
  800d13:	89 c1                	mov    %eax,%ecx
  800d15:	d3 eb                	shr    %cl,%ebx
  800d17:	09 de                	or     %ebx,%esi
  800d19:	89 f0                	mov    %esi,%eax
  800d1b:	f7 74 24 08          	divl   0x8(%esp)
  800d1f:	89 d6                	mov    %edx,%esi
  800d21:	89 c3                	mov    %eax,%ebx
  800d23:	f7 64 24 0c          	mull   0xc(%esp)
  800d27:	39 d6                	cmp    %edx,%esi
  800d29:	72 0c                	jb     800d37 <__udivdi3+0xb7>
  800d2b:	89 f9                	mov    %edi,%ecx
  800d2d:	d3 e5                	shl    %cl,%ebp
  800d2f:	39 c5                	cmp    %eax,%ebp
  800d31:	73 5d                	jae    800d90 <__udivdi3+0x110>
  800d33:	39 d6                	cmp    %edx,%esi
  800d35:	75 59                	jne    800d90 <__udivdi3+0x110>
  800d37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d3a:	31 ff                	xor    %edi,%edi
  800d3c:	89 fa                	mov    %edi,%edx
  800d3e:	83 c4 1c             	add    $0x1c,%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
  800d46:	8d 76 00             	lea    0x0(%esi),%esi
  800d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d50:	31 ff                	xor    %edi,%edi
  800d52:	31 c0                	xor    %eax,%eax
  800d54:	89 fa                	mov    %edi,%edx
  800d56:	83 c4 1c             	add    $0x1c,%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
  800d5e:	66 90                	xchg   %ax,%ax
  800d60:	31 ff                	xor    %edi,%edi
  800d62:	89 e8                	mov    %ebp,%eax
  800d64:	89 f2                	mov    %esi,%edx
  800d66:	f7 f3                	div    %ebx
  800d68:	89 fa                	mov    %edi,%edx
  800d6a:	83 c4 1c             	add    $0x1c,%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
  800d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d78:	39 f2                	cmp    %esi,%edx
  800d7a:	72 06                	jb     800d82 <__udivdi3+0x102>
  800d7c:	31 c0                	xor    %eax,%eax
  800d7e:	39 eb                	cmp    %ebp,%ebx
  800d80:	77 d2                	ja     800d54 <__udivdi3+0xd4>
  800d82:	b8 01 00 00 00       	mov    $0x1,%eax
  800d87:	eb cb                	jmp    800d54 <__udivdi3+0xd4>
  800d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d90:	89 d8                	mov    %ebx,%eax
  800d92:	31 ff                	xor    %edi,%edi
  800d94:	eb be                	jmp    800d54 <__udivdi3+0xd4>
  800d96:	66 90                	xchg   %ax,%ax
  800d98:	66 90                	xchg   %ax,%ax
  800d9a:	66 90                	xchg   %ax,%ax
  800d9c:	66 90                	xchg   %ax,%ax
  800d9e:	66 90                	xchg   %ax,%ax

00800da0 <__umoddi3>:
  800da0:	55                   	push   %ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 1c             	sub    $0x1c,%esp
  800da7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800dab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800daf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800db3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800db7:	85 ed                	test   %ebp,%ebp
  800db9:	89 f0                	mov    %esi,%eax
  800dbb:	89 da                	mov    %ebx,%edx
  800dbd:	75 19                	jne    800dd8 <__umoddi3+0x38>
  800dbf:	39 df                	cmp    %ebx,%edi
  800dc1:	0f 86 b1 00 00 00    	jbe    800e78 <__umoddi3+0xd8>
  800dc7:	f7 f7                	div    %edi
  800dc9:	89 d0                	mov    %edx,%eax
  800dcb:	31 d2                	xor    %edx,%edx
  800dcd:	83 c4 1c             	add    $0x1c,%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
  800dd5:	8d 76 00             	lea    0x0(%esi),%esi
  800dd8:	39 dd                	cmp    %ebx,%ebp
  800dda:	77 f1                	ja     800dcd <__umoddi3+0x2d>
  800ddc:	0f bd cd             	bsr    %ebp,%ecx
  800ddf:	83 f1 1f             	xor    $0x1f,%ecx
  800de2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800de6:	0f 84 b4 00 00 00    	je     800ea0 <__umoddi3+0x100>
  800dec:	b8 20 00 00 00       	mov    $0x20,%eax
  800df1:	89 c2                	mov    %eax,%edx
  800df3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 c1                	mov    %eax,%ecx
  800dfb:	89 f8                	mov    %edi,%eax
  800dfd:	d3 e5                	shl    %cl,%ebp
  800dff:	89 d1                	mov    %edx,%ecx
  800e01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e05:	d3 e8                	shr    %cl,%eax
  800e07:	09 c5                	or     %eax,%ebp
  800e09:	8b 44 24 04          	mov    0x4(%esp),%eax
  800e0d:	89 c1                	mov    %eax,%ecx
  800e0f:	d3 e7                	shl    %cl,%edi
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	d3 ef                	shr    %cl,%edi
  800e1b:	89 c1                	mov    %eax,%ecx
  800e1d:	89 f0                	mov    %esi,%eax
  800e1f:	d3 e3                	shl    %cl,%ebx
  800e21:	89 d1                	mov    %edx,%ecx
  800e23:	89 fa                	mov    %edi,%edx
  800e25:	d3 e8                	shr    %cl,%eax
  800e27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e2c:	09 d8                	or     %ebx,%eax
  800e2e:	f7 f5                	div    %ebp
  800e30:	d3 e6                	shl    %cl,%esi
  800e32:	89 d1                	mov    %edx,%ecx
  800e34:	f7 64 24 08          	mull   0x8(%esp)
  800e38:	39 d1                	cmp    %edx,%ecx
  800e3a:	89 c3                	mov    %eax,%ebx
  800e3c:	89 d7                	mov    %edx,%edi
  800e3e:	72 06                	jb     800e46 <__umoddi3+0xa6>
  800e40:	75 0e                	jne    800e50 <__umoddi3+0xb0>
  800e42:	39 c6                	cmp    %eax,%esi
  800e44:	73 0a                	jae    800e50 <__umoddi3+0xb0>
  800e46:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e4a:	19 ea                	sbb    %ebp,%edx
  800e4c:	89 d7                	mov    %edx,%edi
  800e4e:	89 c3                	mov    %eax,%ebx
  800e50:	89 ca                	mov    %ecx,%edx
  800e52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e57:	29 de                	sub    %ebx,%esi
  800e59:	19 fa                	sbb    %edi,%edx
  800e5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e5f:	89 d0                	mov    %edx,%eax
  800e61:	d3 e0                	shl    %cl,%eax
  800e63:	89 d9                	mov    %ebx,%ecx
  800e65:	d3 ee                	shr    %cl,%esi
  800e67:	d3 ea                	shr    %cl,%edx
  800e69:	09 f0                	or     %esi,%eax
  800e6b:	83 c4 1c             	add    $0x1c,%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    
  800e73:	90                   	nop
  800e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e78:	85 ff                	test   %edi,%edi
  800e7a:	89 f9                	mov    %edi,%ecx
  800e7c:	75 0b                	jne    800e89 <__umoddi3+0xe9>
  800e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e83:	31 d2                	xor    %edx,%edx
  800e85:	f7 f7                	div    %edi
  800e87:	89 c1                	mov    %eax,%ecx
  800e89:	89 d8                	mov    %ebx,%eax
  800e8b:	31 d2                	xor    %edx,%edx
  800e8d:	f7 f1                	div    %ecx
  800e8f:	89 f0                	mov    %esi,%eax
  800e91:	f7 f1                	div    %ecx
  800e93:	e9 31 ff ff ff       	jmp    800dc9 <__umoddi3+0x29>
  800e98:	90                   	nop
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	39 dd                	cmp    %ebx,%ebp
  800ea2:	72 08                	jb     800eac <__umoddi3+0x10c>
  800ea4:	39 f7                	cmp    %esi,%edi
  800ea6:	0f 87 21 ff ff ff    	ja     800dcd <__umoddi3+0x2d>
  800eac:	89 da                	mov    %ebx,%edx
  800eae:	89 f0                	mov    %esi,%eax
  800eb0:	29 f8                	sub    %edi,%eax
  800eb2:	19 ea                	sbb    %ebp,%edx
  800eb4:	e9 14 ff ff ff       	jmp    800dcd <__umoddi3+0x2d>
