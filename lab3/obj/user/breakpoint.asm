
obj/user/breakpoint：     文件格式 elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	e8 3f 00 00 00       	call   800082 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80004f:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  800055:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  80005b:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005d:	85 c0                	test   %eax,%eax
  80005f:	7e 08                	jle    800069 <libmain+0x30>
		binaryname = argv[0];
  800061:	8b 0a                	mov    (%edx),%ecx
  800063:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800069:	83 ec 08             	sub    $0x8,%esp
  80006c:	52                   	push   %edx
  80006d:	50                   	push   %eax
  80006e:	e8 c0 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800073:	e8 0e 00 00 00       	call   800086 <exit>
}
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007e:	5b                   	pop    %ebx
  80007f:	5e                   	pop    %esi
  800080:	5d                   	pop    %ebp
  800081:	c3                   	ret    

00800082 <__x86.get_pc_thunk.bx>:
  800082:	8b 1c 24             	mov    (%esp),%ebx
  800085:	c3                   	ret    

00800086 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800086:	55                   	push   %ebp
  800087:	89 e5                	mov    %esp,%ebp
  800089:	53                   	push   %ebx
  80008a:	83 ec 10             	sub    $0x10,%esp
  80008d:	e8 f0 ff ff ff       	call   800082 <__x86.get_pc_thunk.bx>
  800092:	81 c3 6e 1f 00 00    	add    $0x1f6e,%ebx
	sys_env_destroy(0);
  800098:	6a 00                	push   $0x0
  80009a:	e8 45 00 00 00       	call   8000e4 <sys_env_destroy>
}
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b8:	89 c3                	mov    %eax,%ebx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 c6                	mov    %eax,%esi
  8000be:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5f                   	pop    %edi
  8000c3:	5d                   	pop    %ebp
  8000c4:	c3                   	ret    

008000c5 <sys_cgetc>:

int
sys_cgetc(void) {
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	89 d3                	mov    %edx,%ebx
  8000d9:	89 d7                	mov    %edx,%edi
  8000db:	89 d6                	mov    %edx,%esi
  8000dd:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 1c             	sub    $0x1c,%esp
  8000ed:	e8 66 00 00 00       	call   800158 <__x86.get_pc_thunk.ax>
  8000f2:	05 0e 1f 00 00       	add    $0x1f0e,%eax
  8000f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800102:	b8 03 00 00 00       	mov    $0x3,%eax
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7f 08                	jg     80011b <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	6a 03                	push   $0x3
  800121:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800124:	8d 83 86 ee ff ff    	lea    -0x117a(%ebx),%eax
  80012a:	50                   	push   %eax
  80012b:	6a 24                	push   $0x24
  80012d:	8d 83 a3 ee ff ff    	lea    -0x115d(%ebx),%eax
  800133:	50                   	push   %eax
  800134:	e8 23 00 00 00       	call   80015c <_panic>

00800139 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	57                   	push   %edi
  80013d:	56                   	push   %esi
  80013e:	53                   	push   %ebx
    asm volatile("int %1\n"
  80013f:	ba 00 00 00 00       	mov    $0x0,%edx
  800144:	b8 02 00 00 00       	mov    $0x2,%eax
  800149:	89 d1                	mov    %edx,%ecx
  80014b:	89 d3                	mov    %edx,%ebx
  80014d:	89 d7                	mov    %edx,%edi
  80014f:	89 d6                	mov    %edx,%esi
  800151:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <__x86.get_pc_thunk.ax>:
  800158:	8b 04 24             	mov    (%esp),%eax
  80015b:	c3                   	ret    

0080015c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	e8 18 ff ff ff       	call   800082 <__x86.get_pc_thunk.bx>
  80016a:	81 c3 96 1e 00 00    	add    $0x1e96,%ebx
	va_list ap;

	va_start(ap, fmt);
  800170:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800173:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800179:	8b 38                	mov    (%eax),%edi
  80017b:	e8 b9 ff ff ff       	call   800139 <sys_getenvid>
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	ff 75 0c             	pushl  0xc(%ebp)
  800186:	ff 75 08             	pushl  0x8(%ebp)
  800189:	57                   	push   %edi
  80018a:	50                   	push   %eax
  80018b:	8d 83 b4 ee ff ff    	lea    -0x114c(%ebx),%eax
  800191:	50                   	push   %eax
  800192:	e8 d1 00 00 00       	call   800268 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800197:	83 c4 18             	add    $0x18,%esp
  80019a:	56                   	push   %esi
  80019b:	ff 75 10             	pushl  0x10(%ebp)
  80019e:	e8 63 00 00 00       	call   800206 <vcprintf>
	cprintf("\n");
  8001a3:	8d 83 d8 ee ff ff    	lea    -0x1128(%ebx),%eax
  8001a9:	89 04 24             	mov    %eax,(%esp)
  8001ac:	e8 b7 00 00 00       	call   800268 <cprintf>
  8001b1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b4:	cc                   	int3   
  8001b5:	eb fd                	jmp    8001b4 <_panic+0x58>

008001b7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	e8 c1 fe ff ff       	call   800082 <__x86.get_pc_thunk.bx>
  8001c1:	81 c3 3f 1e 00 00    	add    $0x1e3f,%ebx
  8001c7:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001ca:	8b 16                	mov    (%esi),%edx
  8001cc:	8d 42 01             	lea    0x1(%edx),%eax
  8001cf:	89 06                	mov    %eax,(%esi)
  8001d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d4:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001dd:	74 0b                	je     8001ea <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001df:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	68 ff 00 00 00       	push   $0xff
  8001f2:	8d 46 08             	lea    0x8(%esi),%eax
  8001f5:	50                   	push   %eax
  8001f6:	e8 ac fe ff ff       	call   8000a7 <sys_cputs>
		b->idx = 0;
  8001fb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	eb d9                	jmp    8001df <putch+0x28>

00800206 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	53                   	push   %ebx
  80020a:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800210:	e8 6d fe ff ff       	call   800082 <__x86.get_pc_thunk.bx>
  800215:	81 c3 eb 1d 00 00    	add    $0x1deb,%ebx
	struct printbuf b;

	b.idx = 0;
  80021b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800222:	00 00 00 
	b.cnt = 0;
  800225:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022f:	ff 75 0c             	pushl  0xc(%ebp)
  800232:	ff 75 08             	pushl  0x8(%ebp)
  800235:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023b:	50                   	push   %eax
  80023c:	8d 83 b7 e1 ff ff    	lea    -0x1e49(%ebx),%eax
  800242:	50                   	push   %eax
  800243:	e8 38 01 00 00       	call   800380 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800248:	83 c4 08             	add    $0x8,%esp
  80024b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800251:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800257:	50                   	push   %eax
  800258:	e8 4a fe ff ff       	call   8000a7 <sys_cputs>

	return b.cnt;
}
  80025d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800266:	c9                   	leave  
  800267:	c3                   	ret    

00800268 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800271:	50                   	push   %eax
  800272:	ff 75 08             	pushl  0x8(%ebp)
  800275:	e8 8c ff ff ff       	call   800206 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	57                   	push   %edi
  800280:	56                   	push   %esi
  800281:	53                   	push   %ebx
  800282:	83 ec 2c             	sub    $0x2c,%esp
  800285:	e8 3a 06 00 00       	call   8008c4 <__x86.get_pc_thunk.cx>
  80028a:	81 c1 76 1d 00 00    	add    $0x1d76,%ecx
  800290:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800293:	89 c7                	mov    %eax,%edi
  800295:	89 d6                	mov    %edx,%esi
  800297:	8b 45 08             	mov    0x8(%ebp),%eax
  80029a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ab:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002ae:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002b1:	39 d3                	cmp    %edx,%ebx
  8002b3:	72 09                	jb     8002be <printnum+0x42>
  8002b5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b8:	0f 87 83 00 00 00    	ja     800341 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	ff 75 18             	pushl  0x18(%ebp)
  8002c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ca:	53                   	push   %ebx
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	83 ec 08             	sub    $0x8,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002da:	ff 75 d0             	pushl  -0x30(%ebp)
  8002dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002e0:	e8 5b 09 00 00       	call   800c40 <__udivdi3>
  8002e5:	83 c4 18             	add    $0x18,%esp
  8002e8:	52                   	push   %edx
  8002e9:	50                   	push   %eax
  8002ea:	89 f2                	mov    %esi,%edx
  8002ec:	89 f8                	mov    %edi,%eax
  8002ee:	e8 89 ff ff ff       	call   80027c <printnum>
  8002f3:	83 c4 20             	add    $0x20,%esp
  8002f6:	eb 13                	jmp    80030b <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	56                   	push   %esi
  8002fc:	ff 75 18             	pushl  0x18(%ebp)
  8002ff:	ff d7                	call   *%edi
  800301:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800304:	83 eb 01             	sub    $0x1,%ebx
  800307:	85 db                	test   %ebx,%ebx
  800309:	7f ed                	jg     8002f8 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	ff 75 dc             	pushl  -0x24(%ebp)
  800315:	ff 75 d8             	pushl  -0x28(%ebp)
  800318:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031b:	ff 75 d0             	pushl  -0x30(%ebp)
  80031e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800321:	89 f3                	mov    %esi,%ebx
  800323:	e8 38 0a 00 00       	call   800d60 <__umoddi3>
  800328:	83 c4 14             	add    $0x14,%esp
  80032b:	0f be 84 06 da ee ff 	movsbl -0x1126(%esi,%eax,1),%eax
  800332:	ff 
  800333:	50                   	push   %eax
  800334:	ff d7                	call   *%edi
}
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033c:	5b                   	pop    %ebx
  80033d:	5e                   	pop    %esi
  80033e:	5f                   	pop    %edi
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    
  800341:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800344:	eb be                	jmp    800304 <printnum+0x88>

00800346 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800350:	8b 10                	mov    (%eax),%edx
  800352:	3b 50 04             	cmp    0x4(%eax),%edx
  800355:	73 0a                	jae    800361 <sprintputch+0x1b>
		*b->buf++ = ch;
  800357:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035a:	89 08                	mov    %ecx,(%eax)
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	88 02                	mov    %al,(%edx)
}
  800361:	5d                   	pop    %ebp
  800362:	c3                   	ret    

00800363 <printfmt>:
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800369:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036c:	50                   	push   %eax
  80036d:	ff 75 10             	pushl  0x10(%ebp)
  800370:	ff 75 0c             	pushl  0xc(%ebp)
  800373:	ff 75 08             	pushl  0x8(%ebp)
  800376:	e8 05 00 00 00       	call   800380 <vprintfmt>
}
  80037b:	83 c4 10             	add    $0x10,%esp
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <vprintfmt>:
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	57                   	push   %edi
  800384:	56                   	push   %esi
  800385:	53                   	push   %ebx
  800386:	83 ec 2c             	sub    $0x2c,%esp
  800389:	e8 f4 fc ff ff       	call   800082 <__x86.get_pc_thunk.bx>
  80038e:	81 c3 72 1c 00 00    	add    $0x1c72,%ebx
  800394:	8b 75 0c             	mov    0xc(%ebp),%esi
  800397:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039a:	e9 fb 03 00 00       	jmp    80079a <.L35+0x48>
		padc = ' ';
  80039f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003aa:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003bd:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8d 47 01             	lea    0x1(%edi),%eax
  8003c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c6:	0f b6 17             	movzbl (%edi),%edx
  8003c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cc:	3c 55                	cmp    $0x55,%al
  8003ce:	0f 87 4e 04 00 00    	ja     800822 <.L22>
  8003d4:	0f b6 c0             	movzbl %al,%eax
  8003d7:	89 d9                	mov    %ebx,%ecx
  8003d9:	03 8c 83 68 ef ff ff 	add    -0x1098(%ebx,%eax,4),%ecx
  8003e0:	ff e1                	jmp    *%ecx

008003e2 <.L71>:
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e5:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003e9:	eb d5                	jmp    8003c0 <vprintfmt+0x40>

008003eb <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ee:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f2:	eb cc                	jmp    8003c0 <vprintfmt+0x40>

008003f4 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	0f b6 d2             	movzbl %dl,%edx
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  8003ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800402:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800406:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800409:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040c:	83 f9 09             	cmp    $0x9,%ecx
  80040f:	77 55                	ja     800466 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800411:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800414:	eb e9                	jmp    8003ff <.L29+0xb>

00800416 <.L26>:
			precision = va_arg(ap, int);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 40 04             	lea    0x4(%eax),%eax
  800424:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042e:	79 90                	jns    8003c0 <vprintfmt+0x40>
				width = precision, precision = -1;
  800430:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80043d:	eb 81                	jmp    8003c0 <vprintfmt+0x40>

0080043f <.L27>:
  80043f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800442:	85 c0                	test   %eax,%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
  800449:	0f 49 d0             	cmovns %eax,%edx
  80044c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800452:	e9 69 ff ff ff       	jmp    8003c0 <vprintfmt+0x40>

00800457 <.L23>:
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800461:	e9 5a ff ff ff       	jmp    8003c0 <vprintfmt+0x40>
  800466:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800469:	eb bf                	jmp    80042a <.L26+0x14>

0080046b <.L33>:
			lflag++;
  80046b:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800472:	e9 49 ff ff ff       	jmp    8003c0 <vprintfmt+0x40>

00800477 <.L30>:
			putch(va_arg(ap, int), putdat);
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	8d 78 04             	lea    0x4(%eax),%edi
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	56                   	push   %esi
  800481:	ff 30                	pushl  (%eax)
  800483:	ff 55 08             	call   *0x8(%ebp)
			break;
  800486:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048c:	e9 06 03 00 00       	jmp    800797 <.L35+0x45>

00800491 <.L32>:
			err = va_arg(ap, int);
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8d 78 04             	lea    0x4(%eax),%edi
  800497:	8b 00                	mov    (%eax),%eax
  800499:	99                   	cltd   
  80049a:	31 d0                	xor    %edx,%eax
  80049c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049e:	83 f8 06             	cmp    $0x6,%eax
  8004a1:	7f 27                	jg     8004ca <.L32+0x39>
  8004a3:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8004aa:	85 d2                	test   %edx,%edx
  8004ac:	74 1c                	je     8004ca <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004ae:	52                   	push   %edx
  8004af:	8d 83 fb ee ff ff    	lea    -0x1105(%ebx),%eax
  8004b5:	50                   	push   %eax
  8004b6:	56                   	push   %esi
  8004b7:	ff 75 08             	pushl  0x8(%ebp)
  8004ba:	e8 a4 fe ff ff       	call   800363 <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c5:	e9 cd 02 00 00       	jmp    800797 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004ca:	50                   	push   %eax
  8004cb:	8d 83 f2 ee ff ff    	lea    -0x110e(%ebx),%eax
  8004d1:	50                   	push   %eax
  8004d2:	56                   	push   %esi
  8004d3:	ff 75 08             	pushl  0x8(%ebp)
  8004d6:	e8 88 fe ff ff       	call   800363 <printfmt>
  8004db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004de:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004e1:	e9 b1 02 00 00       	jmp    800797 <.L35+0x45>

008004e6 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	83 c0 04             	add    $0x4,%eax
  8004ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004f4:	85 ff                	test   %edi,%edi
  8004f6:	8d 83 eb ee ff ff    	lea    -0x1115(%ebx),%eax
  8004fc:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800503:	0f 8e b5 00 00 00    	jle    8005be <.L36+0xd8>
  800509:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80050d:	75 08                	jne    800517 <.L36+0x31>
  80050f:	89 75 0c             	mov    %esi,0xc(%ebp)
  800512:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800515:	eb 6d                	jmp    800584 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	ff 75 cc             	pushl  -0x34(%ebp)
  80051d:	57                   	push   %edi
  80051e:	e8 bd 03 00 00       	call   8008e0 <strnlen>
  800523:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800526:	29 c2                	sub    %eax,%edx
  800528:	89 55 c8             	mov    %edx,-0x38(%ebp)
  80052b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80052e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800535:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800538:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053a:	eb 10                	jmp    80054c <.L36+0x66>
					putch(padc, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	56                   	push   %esi
  800540:	ff 75 e0             	pushl  -0x20(%ebp)
  800543:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800546:	83 ef 01             	sub    $0x1,%edi
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	85 ff                	test   %edi,%edi
  80054e:	7f ec                	jg     80053c <.L36+0x56>
  800550:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800553:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800556:	85 d2                	test   %edx,%edx
  800558:	b8 00 00 00 00       	mov    $0x0,%eax
  80055d:	0f 49 c2             	cmovns %edx,%eax
  800560:	29 c2                	sub    %eax,%edx
  800562:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800565:	89 75 0c             	mov    %esi,0xc(%ebp)
  800568:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80056b:	eb 17                	jmp    800584 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  80056d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800571:	75 30                	jne    8005a3 <.L36+0xbd>
					putch(ch, putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	ff 55 08             	call   *0x8(%ebp)
  80057d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800580:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800584:	83 c7 01             	add    $0x1,%edi
  800587:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80058b:	0f be c2             	movsbl %dl,%eax
  80058e:	85 c0                	test   %eax,%eax
  800590:	74 52                	je     8005e4 <.L36+0xfe>
  800592:	85 f6                	test   %esi,%esi
  800594:	78 d7                	js     80056d <.L36+0x87>
  800596:	83 ee 01             	sub    $0x1,%esi
  800599:	79 d2                	jns    80056d <.L36+0x87>
  80059b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80059e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005a1:	eb 32                	jmp    8005d5 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a3:	0f be d2             	movsbl %dl,%edx
  8005a6:	83 ea 20             	sub    $0x20,%edx
  8005a9:	83 fa 5e             	cmp    $0x5e,%edx
  8005ac:	76 c5                	jbe    800573 <.L36+0x8d>
					putch('?', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	6a 3f                	push   $0x3f
  8005b6:	ff 55 08             	call   *0x8(%ebp)
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	eb c2                	jmp    800580 <.L36+0x9a>
  8005be:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005c1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005c4:	eb be                	jmp    800584 <.L36+0x9e>
				putch(' ', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	56                   	push   %esi
  8005ca:	6a 20                	push   $0x20
  8005cc:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005cf:	83 ef 01             	sub    $0x1,%edi
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	85 ff                	test   %edi,%edi
  8005d7:	7f ed                	jg     8005c6 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	e9 b3 01 00 00       	jmp    800797 <.L35+0x45>
  8005e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005ea:	eb e9                	jmp    8005d5 <.L36+0xef>

008005ec <.L31>:
  8005ec:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005ef:	83 f9 01             	cmp    $0x1,%ecx
  8005f2:	7e 40                	jle    800634 <.L31+0x48>
		return va_arg(*ap, long long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 50 04             	mov    0x4(%eax),%edx
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 40 08             	lea    0x8(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80060b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80060f:	79 55                	jns    800666 <.L31+0x7a>
				putch('-', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	56                   	push   %esi
  800615:	6a 2d                	push   $0x2d
  800617:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80061a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80061d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800620:	f7 da                	neg    %edx
  800622:	83 d1 00             	adc    $0x0,%ecx
  800625:	f7 d9                	neg    %ecx
  800627:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062f:	e9 48 01 00 00       	jmp    80077c <.L35+0x2a>
	else if (lflag)
  800634:	85 c9                	test   %ecx,%ecx
  800636:	75 17                	jne    80064f <.L31+0x63>
		return va_arg(*ap, int);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	99                   	cltd   
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
  80064d:	eb bc                	jmp    80060b <.L31+0x1f>
		return va_arg(*ap, long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800657:	99                   	cltd   
  800658:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
  800664:	eb a5                	jmp    80060b <.L31+0x1f>
			num = getint(&ap, lflag);
  800666:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800669:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80066c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800671:	e9 06 01 00 00       	jmp    80077c <.L35+0x2a>

00800676 <.L37>:
  800676:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800679:	83 f9 01             	cmp    $0x1,%ecx
  80067c:	7e 18                	jle    800696 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 10                	mov    (%eax),%edx
  800683:	8b 48 04             	mov    0x4(%eax),%ecx
  800686:	8d 40 08             	lea    0x8(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800691:	e9 e6 00 00 00       	jmp    80077c <.L35+0x2a>
	else if (lflag)
  800696:	85 c9                	test   %ecx,%ecx
  800698:	75 1a                	jne    8006b4 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006af:	e9 c8 00 00 00       	jmp    80077c <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 10                	mov    (%eax),%edx
  8006b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006be:	8d 40 04             	lea    0x4(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c9:	e9 ae 00 00 00       	jmp    80077c <.L35+0x2a>

008006ce <.L34>:
  8006ce:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006d1:	83 f9 01             	cmp    $0x1,%ecx
  8006d4:	7e 3d                	jle    800713 <.L34+0x45>
		return va_arg(*ap, long long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 50 04             	mov    0x4(%eax),%edx
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8006ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f1:	79 52                	jns    800745 <.L34+0x77>
                putch('-', putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	56                   	push   %esi
  8006f7:	6a 2d                	push   $0x2d
  8006f9:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  8006fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ff:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800702:	f7 da                	neg    %edx
  800704:	83 d1 00             	adc    $0x0,%ecx
  800707:	f7 d9                	neg    %ecx
  800709:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80070c:	b8 08 00 00 00       	mov    $0x8,%eax
  800711:	eb 69                	jmp    80077c <.L35+0x2a>
	else if (lflag)
  800713:	85 c9                	test   %ecx,%ecx
  800715:	75 17                	jne    80072e <.L34+0x60>
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	99                   	cltd   
  800720:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
  80072c:	eb bf                	jmp    8006ed <.L34+0x1f>
		return va_arg(*ap, long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	99                   	cltd   
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	eb a8                	jmp    8006ed <.L34+0x1f>
            num = getint(&ap, lflag);
  800745:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800748:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80074b:	b8 08 00 00 00       	mov    $0x8,%eax
  800750:	eb 2a                	jmp    80077c <.L35+0x2a>

00800752 <.L35>:
			putch('0', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	56                   	push   %esi
  800756:	6a 30                	push   $0x30
  800758:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80075b:	83 c4 08             	add    $0x8,%esp
  80075e:	56                   	push   %esi
  80075f:	6a 78                	push   $0x78
  800761:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 10                	mov    (%eax),%edx
  800769:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80076e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800783:	57                   	push   %edi
  800784:	ff 75 e0             	pushl  -0x20(%ebp)
  800787:	50                   	push   %eax
  800788:	51                   	push   %ecx
  800789:	52                   	push   %edx
  80078a:	89 f2                	mov    %esi,%edx
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	e8 e8 fa ff ff       	call   80027c <printnum>
			break;
  800794:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079a:	83 c7 01             	add    $0x1,%edi
  80079d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a1:	83 f8 25             	cmp    $0x25,%eax
  8007a4:	0f 84 f5 fb ff ff    	je     80039f <vprintfmt+0x1f>
			if (ch == '\0')
  8007aa:	85 c0                	test   %eax,%eax
  8007ac:	0f 84 91 00 00 00    	je     800843 <.L22+0x21>
			putch(ch, putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	56                   	push   %esi
  8007b6:	50                   	push   %eax
  8007b7:	ff 55 08             	call   *0x8(%ebp)
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb db                	jmp    80079a <.L35+0x48>

008007bf <.L38>:
  8007bf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007c2:	83 f9 01             	cmp    $0x1,%ecx
  8007c5:	7e 15                	jle    8007dc <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 10                	mov    (%eax),%edx
  8007cc:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cf:	8d 40 08             	lea    0x8(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007da:	eb a0                	jmp    80077c <.L35+0x2a>
	else if (lflag)
  8007dc:	85 c9                	test   %ecx,%ecx
  8007de:	75 17                	jne    8007f7 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8b 10                	mov    (%eax),%edx
  8007e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f5:	eb 85                	jmp    80077c <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800807:	b8 10 00 00 00       	mov    $0x10,%eax
  80080c:	e9 6b ff ff ff       	jmp    80077c <.L35+0x2a>

00800811 <.L25>:
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	56                   	push   %esi
  800815:	6a 25                	push   $0x25
  800817:	ff 55 08             	call   *0x8(%ebp)
			break;
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	e9 75 ff ff ff       	jmp    800797 <.L35+0x45>

00800822 <.L22>:
			putch('%', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	56                   	push   %esi
  800826:	6a 25                	push   $0x25
  800828:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 f8                	mov    %edi,%eax
  800830:	eb 03                	jmp    800835 <.L22+0x13>
  800832:	83 e8 01             	sub    $0x1,%eax
  800835:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800839:	75 f7                	jne    800832 <.L22+0x10>
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	e9 54 ff ff ff       	jmp    800797 <.L35+0x45>
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
  80084e:	53                   	push   %ebx
  80084f:	83 ec 14             	sub    $0x14,%esp
  800852:	e8 2b f8 ff ff       	call   800082 <__x86.get_pc_thunk.bx>
  800857:	81 c3 a9 17 00 00    	add    $0x17a9,%ebx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800866:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800874:	85 c0                	test   %eax,%eax
  800876:	74 2b                	je     8008a3 <vsnprintf+0x58>
  800878:	85 d2                	test   %edx,%edx
  80087a:	7e 27                	jle    8008a3 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087c:	ff 75 14             	pushl  0x14(%ebp)
  80087f:	ff 75 10             	pushl  0x10(%ebp)
  800882:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	8d 83 46 e3 ff ff    	lea    -0x1cba(%ebx),%eax
  80088c:	50                   	push   %eax
  80088d:	e8 ee fa ff ff       	call   800380 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089b:	83 c4 10             	add    $0x10,%esp
}
  80089e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a1:	c9                   	leave  
  8008a2:	c3                   	ret    
		return -E_INVAL;
  8008a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a8:	eb f4                	jmp    80089e <vsnprintf+0x53>

008008aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b3:	50                   	push   %eax
  8008b4:	ff 75 10             	pushl  0x10(%ebp)
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	e8 89 ff ff ff       	call   80084b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <__x86.get_pc_thunk.cx>:
  8008c4:	8b 0c 24             	mov    (%esp),%ecx
  8008c7:	c3                   	ret    

008008c8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d3:	eb 03                	jmp    8008d8 <strlen+0x10>
		n++;
  8008d5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008d8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008dc:	75 f7                	jne    8008d5 <strlen+0xd>
	return n;
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ee:	eb 03                	jmp    8008f3 <strnlen+0x13>
		n++;
  8008f0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f3:	39 d0                	cmp    %edx,%eax
  8008f5:	74 06                	je     8008fd <strnlen+0x1d>
  8008f7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008fb:	75 f3                	jne    8008f0 <strnlen+0x10>
	return n;
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	53                   	push   %ebx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800909:	89 c2                	mov    %eax,%edx
  80090b:	83 c1 01             	add    $0x1,%ecx
  80090e:	83 c2 01             	add    $0x1,%edx
  800911:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800915:	88 5a ff             	mov    %bl,-0x1(%edx)
  800918:	84 db                	test   %bl,%bl
  80091a:	75 ef                	jne    80090b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80091c:	5b                   	pop    %ebx
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	53                   	push   %ebx
  800923:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800926:	53                   	push   %ebx
  800927:	e8 9c ff ff ff       	call   8008c8 <strlen>
  80092c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	01 d8                	add    %ebx,%eax
  800934:	50                   	push   %eax
  800935:	e8 c5 ff ff ff       	call   8008ff <strcpy>
	return dst;
}
  80093a:	89 d8                	mov    %ebx,%eax
  80093c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
  800946:	8b 75 08             	mov    0x8(%ebp),%esi
  800949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094c:	89 f3                	mov    %esi,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800951:	89 f2                	mov    %esi,%edx
  800953:	eb 0f                	jmp    800964 <strncpy+0x23>
		*dst++ = *src;
  800955:	83 c2 01             	add    $0x1,%edx
  800958:	0f b6 01             	movzbl (%ecx),%eax
  80095b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095e:	80 39 01             	cmpb   $0x1,(%ecx)
  800961:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800964:	39 da                	cmp    %ebx,%edx
  800966:	75 ed                	jne    800955 <strncpy+0x14>
	}
	return ret;
}
  800968:	89 f0                	mov    %esi,%eax
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	8b 75 08             	mov    0x8(%ebp),%esi
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
  800979:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80097c:	89 f0                	mov    %esi,%eax
  80097e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800982:	85 c9                	test   %ecx,%ecx
  800984:	75 0b                	jne    800991 <strlcpy+0x23>
  800986:	eb 17                	jmp    80099f <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800988:	83 c2 01             	add    $0x1,%edx
  80098b:	83 c0 01             	add    $0x1,%eax
  80098e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800991:	39 d8                	cmp    %ebx,%eax
  800993:	74 07                	je     80099c <strlcpy+0x2e>
  800995:	0f b6 0a             	movzbl (%edx),%ecx
  800998:	84 c9                	test   %cl,%cl
  80099a:	75 ec                	jne    800988 <strlcpy+0x1a>
		*dst = '\0';
  80099c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099f:	29 f0                	sub    %esi,%eax
}
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ae:	eb 06                	jmp    8009b6 <strcmp+0x11>
		p++, q++;
  8009b0:	83 c1 01             	add    $0x1,%ecx
  8009b3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009b6:	0f b6 01             	movzbl (%ecx),%eax
  8009b9:	84 c0                	test   %al,%al
  8009bb:	74 04                	je     8009c1 <strcmp+0x1c>
  8009bd:	3a 02                	cmp    (%edx),%al
  8009bf:	74 ef                	je     8009b0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	0f b6 12             	movzbl (%edx),%edx
  8009c7:	29 d0                	sub    %edx,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	89 c3                	mov    %eax,%ebx
  8009d7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009da:	eb 06                	jmp    8009e2 <strncmp+0x17>
		n--, p++, q++;
  8009dc:	83 c0 01             	add    $0x1,%eax
  8009df:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e2:	39 d8                	cmp    %ebx,%eax
  8009e4:	74 16                	je     8009fc <strncmp+0x31>
  8009e6:	0f b6 08             	movzbl (%eax),%ecx
  8009e9:	84 c9                	test   %cl,%cl
  8009eb:	74 04                	je     8009f1 <strncmp+0x26>
  8009ed:	3a 0a                	cmp    (%edx),%cl
  8009ef:	74 eb                	je     8009dc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f1:	0f b6 00             	movzbl (%eax),%eax
  8009f4:	0f b6 12             	movzbl (%edx),%edx
  8009f7:	29 d0                	sub    %edx,%eax
}
  8009f9:	5b                   	pop    %ebx
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    
		return 0;
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800a01:	eb f6                	jmp    8009f9 <strncmp+0x2e>

00800a03 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	74 09                	je     800a1d <strchr+0x1a>
		if (*s == c)
  800a14:	38 ca                	cmp    %cl,%dl
  800a16:	74 0a                	je     800a22 <strchr+0x1f>
	for (; *s; s++)
  800a18:	83 c0 01             	add    $0x1,%eax
  800a1b:	eb f0                	jmp    800a0d <strchr+0xa>
			return (char *) s;
	return 0;
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2e:	eb 03                	jmp    800a33 <strfind+0xf>
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a36:	38 ca                	cmp    %cl,%dl
  800a38:	74 04                	je     800a3e <strfind+0x1a>
  800a3a:	84 d2                	test   %dl,%dl
  800a3c:	75 f2                	jne    800a30 <strfind+0xc>
			break;
	return (char *) s;
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	57                   	push   %edi
  800a44:	56                   	push   %esi
  800a45:	53                   	push   %ebx
  800a46:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4c:	85 c9                	test   %ecx,%ecx
  800a4e:	74 13                	je     800a63 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a50:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a56:	75 05                	jne    800a5d <memset+0x1d>
  800a58:	f6 c1 03             	test   $0x3,%cl
  800a5b:	74 0d                	je     800a6a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	fc                   	cld    
  800a61:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a63:	89 f8                	mov    %edi,%eax
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5f                   	pop    %edi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    
		c &= 0xFF;
  800a6a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6e:	89 d3                	mov    %edx,%ebx
  800a70:	c1 e3 08             	shl    $0x8,%ebx
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	c1 e0 18             	shl    $0x18,%eax
  800a78:	89 d6                	mov    %edx,%esi
  800a7a:	c1 e6 10             	shl    $0x10,%esi
  800a7d:	09 f0                	or     %esi,%eax
  800a7f:	09 c2                	or     %eax,%edx
  800a81:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a83:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a86:	89 d0                	mov    %edx,%eax
  800a88:	fc                   	cld    
  800a89:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8b:	eb d6                	jmp    800a63 <memset+0x23>

00800a8d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	57                   	push   %edi
  800a91:	56                   	push   %esi
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a9b:	39 c6                	cmp    %eax,%esi
  800a9d:	73 35                	jae    800ad4 <memmove+0x47>
  800a9f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa2:	39 c2                	cmp    %eax,%edx
  800aa4:	76 2e                	jbe    800ad4 <memmove+0x47>
		s += n;
		d += n;
  800aa6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa9:	89 d6                	mov    %edx,%esi
  800aab:	09 fe                	or     %edi,%esi
  800aad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab3:	74 0c                	je     800ac1 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab5:	83 ef 01             	sub    $0x1,%edi
  800ab8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800abb:	fd                   	std    
  800abc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800abe:	fc                   	cld    
  800abf:	eb 21                	jmp    800ae2 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac1:	f6 c1 03             	test   $0x3,%cl
  800ac4:	75 ef                	jne    800ab5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac6:	83 ef 04             	sub    $0x4,%edi
  800ac9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acf:	fd                   	std    
  800ad0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad2:	eb ea                	jmp    800abe <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad4:	89 f2                	mov    %esi,%edx
  800ad6:	09 c2                	or     %eax,%edx
  800ad8:	f6 c2 03             	test   $0x3,%dl
  800adb:	74 09                	je     800ae6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800add:	89 c7                	mov    %eax,%edi
  800adf:	fc                   	cld    
  800ae0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae2:	5e                   	pop    %esi
  800ae3:	5f                   	pop    %edi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae6:	f6 c1 03             	test   $0x3,%cl
  800ae9:	75 f2                	jne    800add <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aee:	89 c7                	mov    %eax,%edi
  800af0:	fc                   	cld    
  800af1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af3:	eb ed                	jmp    800ae2 <memmove+0x55>

00800af5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800af8:	ff 75 10             	pushl  0x10(%ebp)
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	ff 75 08             	pushl  0x8(%ebp)
  800b01:	e8 87 ff ff ff       	call   800a8d <memmove>
}
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b13:	89 c6                	mov    %eax,%esi
  800b15:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b18:	39 f0                	cmp    %esi,%eax
  800b1a:	74 1c                	je     800b38 <memcmp+0x30>
		if (*s1 != *s2)
  800b1c:	0f b6 08             	movzbl (%eax),%ecx
  800b1f:	0f b6 1a             	movzbl (%edx),%ebx
  800b22:	38 d9                	cmp    %bl,%cl
  800b24:	75 08                	jne    800b2e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	83 c2 01             	add    $0x1,%edx
  800b2c:	eb ea                	jmp    800b18 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b2e:	0f b6 c1             	movzbl %cl,%eax
  800b31:	0f b6 db             	movzbl %bl,%ebx
  800b34:	29 d8                	sub    %ebx,%eax
  800b36:	eb 05                	jmp    800b3d <memcmp+0x35>
	}

	return 0;
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3d:	5b                   	pop    %ebx
  800b3e:	5e                   	pop    %esi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4a:	89 c2                	mov    %eax,%edx
  800b4c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b4f:	39 d0                	cmp    %edx,%eax
  800b51:	73 09                	jae    800b5c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b53:	38 08                	cmp    %cl,(%eax)
  800b55:	74 05                	je     800b5c <memfind+0x1b>
	for (; s < ends; s++)
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	eb f3                	jmp    800b4f <memfind+0xe>
			break;
	return (void *) s;
}
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	57                   	push   %edi
  800b62:	56                   	push   %esi
  800b63:	53                   	push   %ebx
  800b64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6a:	eb 03                	jmp    800b6f <strtol+0x11>
		s++;
  800b6c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b6f:	0f b6 01             	movzbl (%ecx),%eax
  800b72:	3c 20                	cmp    $0x20,%al
  800b74:	74 f6                	je     800b6c <strtol+0xe>
  800b76:	3c 09                	cmp    $0x9,%al
  800b78:	74 f2                	je     800b6c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b7a:	3c 2b                	cmp    $0x2b,%al
  800b7c:	74 2e                	je     800bac <strtol+0x4e>
	int neg = 0;
  800b7e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b83:	3c 2d                	cmp    $0x2d,%al
  800b85:	74 2f                	je     800bb6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b87:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b8d:	75 05                	jne    800b94 <strtol+0x36>
  800b8f:	80 39 30             	cmpb   $0x30,(%ecx)
  800b92:	74 2c                	je     800bc0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b94:	85 db                	test   %ebx,%ebx
  800b96:	75 0a                	jne    800ba2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b98:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b9d:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba0:	74 28                	je     800bca <strtol+0x6c>
		base = 10;
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800baa:	eb 50                	jmp    800bfc <strtol+0x9e>
		s++;
  800bac:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800baf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb4:	eb d1                	jmp    800b87 <strtol+0x29>
		s++, neg = 1;
  800bb6:	83 c1 01             	add    $0x1,%ecx
  800bb9:	bf 01 00 00 00       	mov    $0x1,%edi
  800bbe:	eb c7                	jmp    800b87 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc4:	74 0e                	je     800bd4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	75 d8                	jne    800ba2 <strtol+0x44>
		s++, base = 8;
  800bca:	83 c1 01             	add    $0x1,%ecx
  800bcd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd2:	eb ce                	jmp    800ba2 <strtol+0x44>
		s += 2, base = 16;
  800bd4:	83 c1 02             	add    $0x2,%ecx
  800bd7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bdc:	eb c4                	jmp    800ba2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bde:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be1:	89 f3                	mov    %esi,%ebx
  800be3:	80 fb 19             	cmp    $0x19,%bl
  800be6:	77 29                	ja     800c11 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800be8:	0f be d2             	movsbl %dl,%edx
  800beb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bee:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf1:	7d 30                	jge    800c23 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bf3:	83 c1 01             	add    $0x1,%ecx
  800bf6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bfa:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bfc:	0f b6 11             	movzbl (%ecx),%edx
  800bff:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c02:	89 f3                	mov    %esi,%ebx
  800c04:	80 fb 09             	cmp    $0x9,%bl
  800c07:	77 d5                	ja     800bde <strtol+0x80>
			dig = *s - '0';
  800c09:	0f be d2             	movsbl %dl,%edx
  800c0c:	83 ea 30             	sub    $0x30,%edx
  800c0f:	eb dd                	jmp    800bee <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c11:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c14:	89 f3                	mov    %esi,%ebx
  800c16:	80 fb 19             	cmp    $0x19,%bl
  800c19:	77 08                	ja     800c23 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c1b:	0f be d2             	movsbl %dl,%edx
  800c1e:	83 ea 37             	sub    $0x37,%edx
  800c21:	eb cb                	jmp    800bee <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 05                	je     800c2e <strtol+0xd0>
		*endptr = (char *) s;
  800c29:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c2e:	89 c2                	mov    %eax,%edx
  800c30:	f7 da                	neg    %edx
  800c32:	85 ff                	test   %edi,%edi
  800c34:	0f 45 c2             	cmovne %edx,%eax
}
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
  800c3c:	66 90                	xchg   %ax,%ax
  800c3e:	66 90                	xchg   %ax,%ax

00800c40 <__udivdi3>:
  800c40:	55                   	push   %ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	83 ec 1c             	sub    $0x1c,%esp
  800c47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c57:	85 d2                	test   %edx,%edx
  800c59:	75 35                	jne    800c90 <__udivdi3+0x50>
  800c5b:	39 f3                	cmp    %esi,%ebx
  800c5d:	0f 87 bd 00 00 00    	ja     800d20 <__udivdi3+0xe0>
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	89 d9                	mov    %ebx,%ecx
  800c67:	75 0b                	jne    800c74 <__udivdi3+0x34>
  800c69:	b8 01 00 00 00       	mov    $0x1,%eax
  800c6e:	31 d2                	xor    %edx,%edx
  800c70:	f7 f3                	div    %ebx
  800c72:	89 c1                	mov    %eax,%ecx
  800c74:	31 d2                	xor    %edx,%edx
  800c76:	89 f0                	mov    %esi,%eax
  800c78:	f7 f1                	div    %ecx
  800c7a:	89 c6                	mov    %eax,%esi
  800c7c:	89 e8                	mov    %ebp,%eax
  800c7e:	89 f7                	mov    %esi,%edi
  800c80:	f7 f1                	div    %ecx
  800c82:	89 fa                	mov    %edi,%edx
  800c84:	83 c4 1c             	add    $0x1c,%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
  800c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c90:	39 f2                	cmp    %esi,%edx
  800c92:	77 7c                	ja     800d10 <__udivdi3+0xd0>
  800c94:	0f bd fa             	bsr    %edx,%edi
  800c97:	83 f7 1f             	xor    $0x1f,%edi
  800c9a:	0f 84 98 00 00 00    	je     800d38 <__udivdi3+0xf8>
  800ca0:	89 f9                	mov    %edi,%ecx
  800ca2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ca7:	29 f8                	sub    %edi,%eax
  800ca9:	d3 e2                	shl    %cl,%edx
  800cab:	89 54 24 08          	mov    %edx,0x8(%esp)
  800caf:	89 c1                	mov    %eax,%ecx
  800cb1:	89 da                	mov    %ebx,%edx
  800cb3:	d3 ea                	shr    %cl,%edx
  800cb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cb9:	09 d1                	or     %edx,%ecx
  800cbb:	89 f2                	mov    %esi,%edx
  800cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cc1:	89 f9                	mov    %edi,%ecx
  800cc3:	d3 e3                	shl    %cl,%ebx
  800cc5:	89 c1                	mov    %eax,%ecx
  800cc7:	d3 ea                	shr    %cl,%edx
  800cc9:	89 f9                	mov    %edi,%ecx
  800ccb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ccf:	d3 e6                	shl    %cl,%esi
  800cd1:	89 eb                	mov    %ebp,%ebx
  800cd3:	89 c1                	mov    %eax,%ecx
  800cd5:	d3 eb                	shr    %cl,%ebx
  800cd7:	09 de                	or     %ebx,%esi
  800cd9:	89 f0                	mov    %esi,%eax
  800cdb:	f7 74 24 08          	divl   0x8(%esp)
  800cdf:	89 d6                	mov    %edx,%esi
  800ce1:	89 c3                	mov    %eax,%ebx
  800ce3:	f7 64 24 0c          	mull   0xc(%esp)
  800ce7:	39 d6                	cmp    %edx,%esi
  800ce9:	72 0c                	jb     800cf7 <__udivdi3+0xb7>
  800ceb:	89 f9                	mov    %edi,%ecx
  800ced:	d3 e5                	shl    %cl,%ebp
  800cef:	39 c5                	cmp    %eax,%ebp
  800cf1:	73 5d                	jae    800d50 <__udivdi3+0x110>
  800cf3:	39 d6                	cmp    %edx,%esi
  800cf5:	75 59                	jne    800d50 <__udivdi3+0x110>
  800cf7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800cfa:	31 ff                	xor    %edi,%edi
  800cfc:	89 fa                	mov    %edi,%edx
  800cfe:	83 c4 1c             	add    $0x1c,%esp
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    
  800d06:	8d 76 00             	lea    0x0(%esi),%esi
  800d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d10:	31 ff                	xor    %edi,%edi
  800d12:	31 c0                	xor    %eax,%eax
  800d14:	89 fa                	mov    %edi,%edx
  800d16:	83 c4 1c             	add    $0x1c,%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
  800d1e:	66 90                	xchg   %ax,%ax
  800d20:	31 ff                	xor    %edi,%edi
  800d22:	89 e8                	mov    %ebp,%eax
  800d24:	89 f2                	mov    %esi,%edx
  800d26:	f7 f3                	div    %ebx
  800d28:	89 fa                	mov    %edi,%edx
  800d2a:	83 c4 1c             	add    $0x1c,%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
  800d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d38:	39 f2                	cmp    %esi,%edx
  800d3a:	72 06                	jb     800d42 <__udivdi3+0x102>
  800d3c:	31 c0                	xor    %eax,%eax
  800d3e:	39 eb                	cmp    %ebp,%ebx
  800d40:	77 d2                	ja     800d14 <__udivdi3+0xd4>
  800d42:	b8 01 00 00 00       	mov    $0x1,%eax
  800d47:	eb cb                	jmp    800d14 <__udivdi3+0xd4>
  800d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d50:	89 d8                	mov    %ebx,%eax
  800d52:	31 ff                	xor    %edi,%edi
  800d54:	eb be                	jmp    800d14 <__udivdi3+0xd4>
  800d56:	66 90                	xchg   %ax,%ax
  800d58:	66 90                	xchg   %ax,%ax
  800d5a:	66 90                	xchg   %ax,%ax
  800d5c:	66 90                	xchg   %ax,%ax
  800d5e:	66 90                	xchg   %ax,%ax

00800d60 <__umoddi3>:
  800d60:	55                   	push   %ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	83 ec 1c             	sub    $0x1c,%esp
  800d67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800d6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800d77:	85 ed                	test   %ebp,%ebp
  800d79:	89 f0                	mov    %esi,%eax
  800d7b:	89 da                	mov    %ebx,%edx
  800d7d:	75 19                	jne    800d98 <__umoddi3+0x38>
  800d7f:	39 df                	cmp    %ebx,%edi
  800d81:	0f 86 b1 00 00 00    	jbe    800e38 <__umoddi3+0xd8>
  800d87:	f7 f7                	div    %edi
  800d89:	89 d0                	mov    %edx,%eax
  800d8b:	31 d2                	xor    %edx,%edx
  800d8d:	83 c4 1c             	add    $0x1c,%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
  800d95:	8d 76 00             	lea    0x0(%esi),%esi
  800d98:	39 dd                	cmp    %ebx,%ebp
  800d9a:	77 f1                	ja     800d8d <__umoddi3+0x2d>
  800d9c:	0f bd cd             	bsr    %ebp,%ecx
  800d9f:	83 f1 1f             	xor    $0x1f,%ecx
  800da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800da6:	0f 84 b4 00 00 00    	je     800e60 <__umoddi3+0x100>
  800dac:	b8 20 00 00 00       	mov    $0x20,%eax
  800db1:	89 c2                	mov    %eax,%edx
  800db3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800db7:	29 c2                	sub    %eax,%edx
  800db9:	89 c1                	mov    %eax,%ecx
  800dbb:	89 f8                	mov    %edi,%eax
  800dbd:	d3 e5                	shl    %cl,%ebp
  800dbf:	89 d1                	mov    %edx,%ecx
  800dc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dc5:	d3 e8                	shr    %cl,%eax
  800dc7:	09 c5                	or     %eax,%ebp
  800dc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dcd:	89 c1                	mov    %eax,%ecx
  800dcf:	d3 e7                	shl    %cl,%edi
  800dd1:	89 d1                	mov    %edx,%ecx
  800dd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800dd7:	89 df                	mov    %ebx,%edi
  800dd9:	d3 ef                	shr    %cl,%edi
  800ddb:	89 c1                	mov    %eax,%ecx
  800ddd:	89 f0                	mov    %esi,%eax
  800ddf:	d3 e3                	shl    %cl,%ebx
  800de1:	89 d1                	mov    %edx,%ecx
  800de3:	89 fa                	mov    %edi,%edx
  800de5:	d3 e8                	shr    %cl,%eax
  800de7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800dec:	09 d8                	or     %ebx,%eax
  800dee:	f7 f5                	div    %ebp
  800df0:	d3 e6                	shl    %cl,%esi
  800df2:	89 d1                	mov    %edx,%ecx
  800df4:	f7 64 24 08          	mull   0x8(%esp)
  800df8:	39 d1                	cmp    %edx,%ecx
  800dfa:	89 c3                	mov    %eax,%ebx
  800dfc:	89 d7                	mov    %edx,%edi
  800dfe:	72 06                	jb     800e06 <__umoddi3+0xa6>
  800e00:	75 0e                	jne    800e10 <__umoddi3+0xb0>
  800e02:	39 c6                	cmp    %eax,%esi
  800e04:	73 0a                	jae    800e10 <__umoddi3+0xb0>
  800e06:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e0a:	19 ea                	sbb    %ebp,%edx
  800e0c:	89 d7                	mov    %edx,%edi
  800e0e:	89 c3                	mov    %eax,%ebx
  800e10:	89 ca                	mov    %ecx,%edx
  800e12:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e17:	29 de                	sub    %ebx,%esi
  800e19:	19 fa                	sbb    %edi,%edx
  800e1b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e1f:	89 d0                	mov    %edx,%eax
  800e21:	d3 e0                	shl    %cl,%eax
  800e23:	89 d9                	mov    %ebx,%ecx
  800e25:	d3 ee                	shr    %cl,%esi
  800e27:	d3 ea                	shr    %cl,%edx
  800e29:	09 f0                	or     %esi,%eax
  800e2b:	83 c4 1c             	add    $0x1c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
  800e33:	90                   	nop
  800e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e38:	85 ff                	test   %edi,%edi
  800e3a:	89 f9                	mov    %edi,%ecx
  800e3c:	75 0b                	jne    800e49 <__umoddi3+0xe9>
  800e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e43:	31 d2                	xor    %edx,%edx
  800e45:	f7 f7                	div    %edi
  800e47:	89 c1                	mov    %eax,%ecx
  800e49:	89 d8                	mov    %ebx,%eax
  800e4b:	31 d2                	xor    %edx,%edx
  800e4d:	f7 f1                	div    %ecx
  800e4f:	89 f0                	mov    %esi,%eax
  800e51:	f7 f1                	div    %ecx
  800e53:	e9 31 ff ff ff       	jmp    800d89 <__umoddi3+0x29>
  800e58:	90                   	nop
  800e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e60:	39 dd                	cmp    %ebx,%ebp
  800e62:	72 08                	jb     800e6c <__umoddi3+0x10c>
  800e64:	39 f7                	cmp    %esi,%edi
  800e66:	0f 87 21 ff ff ff    	ja     800d8d <__umoddi3+0x2d>
  800e6c:	89 da                	mov    %ebx,%edx
  800e6e:	89 f0                	mov    %esi,%eax
  800e70:	29 f8                	sub    %edi,%eax
  800e72:	19 ea                	sbb    %ebp,%edx
  800e74:	e9 14 ff ff ff       	jmp    800d8d <__umoddi3+0x2d>
