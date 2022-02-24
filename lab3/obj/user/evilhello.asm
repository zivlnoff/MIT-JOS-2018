
obj/user/evilhello：     文件格式 elf32-i386


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
  80002c:	e8 2c 00 00 00       	call   80005d <libmain>
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
  80003a:	e8 1a 00 00 00       	call   800059 <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800045:	6a 64                	push   $0x64
  800047:	68 0c 00 10 f0       	push   $0xf010000c
  80004c:	e8 76 00 00 00       	call   8000c7 <sys_cputs>
}
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <__x86.get_pc_thunk.bx>:
  800059:	8b 1c 24             	mov    (%esp),%ebx
  80005c:	c3                   	ret    

0080005d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	56                   	push   %esi
  800061:	53                   	push   %ebx
  800062:	e8 f2 ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800067:	81 c3 99 1f 00 00    	add    $0x1f99,%ebx
  80006d:	8b 45 08             	mov    0x8(%ebp),%eax
  800070:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800073:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  800079:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  80007f:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800081:	85 c0                	test   %eax,%eax
  800083:	7e 08                	jle    80008d <libmain+0x30>
		binaryname = argv[0];
  800085:	8b 0a                	mov    (%edx),%ecx
  800087:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	52                   	push   %edx
  800091:	50                   	push   %eax
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	53                   	push   %ebx
  8000aa:	83 ec 10             	sub    $0x10,%esp
  8000ad:	e8 a7 ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8000b2:	81 c3 4e 1f 00 00    	add    $0x1f4e,%ebx
	sys_env_destroy(0);
  8000b8:	6a 00                	push   $0x0
  8000ba:	e8 45 00 00 00       	call   800104 <sys_env_destroy>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c5:	c9                   	leave  
  8000c6:	c3                   	ret    

008000c7 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	57                   	push   %edi
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d8:	89 c3                	mov    %eax,%ebx
  8000da:	89 c7                	mov    %eax,%edi
  8000dc:	89 c6                	mov    %eax,%esi
  8000de:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000e0:	5b                   	pop    %ebx
  8000e1:	5e                   	pop    %esi
  8000e2:	5f                   	pop    %edi
  8000e3:	5d                   	pop    %ebp
  8000e4:	c3                   	ret    

008000e5 <sys_cgetc>:

int
sys_cgetc(void) {
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f5:	89 d1                	mov    %edx,%ecx
  8000f7:	89 d3                	mov    %edx,%ebx
  8000f9:	89 d7                	mov    %edx,%edi
  8000fb:	89 d6                	mov    %edx,%esi
  8000fd:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ff:	5b                   	pop    %ebx
  800100:	5e                   	pop    %esi
  800101:	5f                   	pop    %edi
  800102:	5d                   	pop    %ebp
  800103:	c3                   	ret    

00800104 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	57                   	push   %edi
  800108:	56                   	push   %esi
  800109:	53                   	push   %ebx
  80010a:	83 ec 1c             	sub    $0x1c,%esp
  80010d:	e8 66 00 00 00       	call   800178 <__x86.get_pc_thunk.ax>
  800112:	05 ee 1e 00 00       	add    $0x1eee,%eax
  800117:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  80011a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80011f:	8b 55 08             	mov    0x8(%ebp),%edx
  800122:	b8 03 00 00 00       	mov    $0x3,%eax
  800127:	89 cb                	mov    %ecx,%ebx
  800129:	89 cf                	mov    %ecx,%edi
  80012b:	89 ce                	mov    %ecx,%esi
  80012d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80012f:	85 c0                	test   %eax,%eax
  800131:	7f 08                	jg     80013b <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800133:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	6a 03                	push   $0x3
  800141:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800144:	8d 83 a6 ee ff ff    	lea    -0x115a(%ebx),%eax
  80014a:	50                   	push   %eax
  80014b:	6a 24                	push   $0x24
  80014d:	8d 83 c3 ee ff ff    	lea    -0x113d(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	e8 23 00 00 00       	call   80017c <_panic>

00800159 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	57                   	push   %edi
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
    asm volatile("int %1\n"
  80015f:	ba 00 00 00 00       	mov    $0x0,%edx
  800164:	b8 02 00 00 00       	mov    $0x2,%eax
  800169:	89 d1                	mov    %edx,%ecx
  80016b:	89 d3                	mov    %edx,%ebx
  80016d:	89 d7                	mov    %edx,%edi
  80016f:	89 d6                	mov    %edx,%esi
  800171:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5f                   	pop    %edi
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <__x86.get_pc_thunk.ax>:
  800178:	8b 04 24             	mov    (%esp),%eax
  80017b:	c3                   	ret    

0080017c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	57                   	push   %edi
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	e8 cf fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  80018a:	81 c3 76 1e 00 00    	add    $0x1e76,%ebx
	va_list ap;

	va_start(ap, fmt);
  800190:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800193:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800199:	8b 38                	mov    (%eax),%edi
  80019b:	e8 b9 ff ff ff       	call   800159 <sys_getenvid>
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	57                   	push   %edi
  8001aa:	50                   	push   %eax
  8001ab:	8d 83 d4 ee ff ff    	lea    -0x112c(%ebx),%eax
  8001b1:	50                   	push   %eax
  8001b2:	e8 d1 00 00 00       	call   800288 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b7:	83 c4 18             	add    $0x18,%esp
  8001ba:	56                   	push   %esi
  8001bb:	ff 75 10             	pushl  0x10(%ebp)
  8001be:	e8 63 00 00 00       	call   800226 <vcprintf>
	cprintf("\n");
  8001c3:	8d 83 f8 ee ff ff    	lea    -0x1108(%ebx),%eax
  8001c9:	89 04 24             	mov    %eax,(%esp)
  8001cc:	e8 b7 00 00 00       	call   800288 <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d4:	cc                   	int3   
  8001d5:	eb fd                	jmp    8001d4 <_panic+0x58>

008001d7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	e8 78 fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8001e1:	81 c3 1f 1e 00 00    	add    $0x1e1f,%ebx
  8001e7:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001ea:	8b 16                	mov    (%esi),%edx
  8001ec:	8d 42 01             	lea    0x1(%edx),%eax
  8001ef:	89 06                	mov    %eax,(%esi)
  8001f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f4:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fd:	74 0b                	je     80020a <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ff:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800203:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	68 ff 00 00 00       	push   $0xff
  800212:	8d 46 08             	lea    0x8(%esi),%eax
  800215:	50                   	push   %eax
  800216:	e8 ac fe ff ff       	call   8000c7 <sys_cputs>
		b->idx = 0;
  80021b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	eb d9                	jmp    8001ff <putch+0x28>

00800226 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	53                   	push   %ebx
  80022a:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800230:	e8 24 fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800235:	81 c3 cb 1d 00 00    	add    $0x1dcb,%ebx
	struct printbuf b;

	b.idx = 0;
  80023b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800242:	00 00 00 
	b.cnt = 0;
  800245:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80024c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80024f:	ff 75 0c             	pushl  0xc(%ebp)
  800252:	ff 75 08             	pushl  0x8(%ebp)
  800255:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	8d 83 d7 e1 ff ff    	lea    -0x1e29(%ebx),%eax
  800262:	50                   	push   %eax
  800263:	e8 38 01 00 00       	call   8003a0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800268:	83 c4 08             	add    $0x8,%esp
  80026b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800271:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800277:	50                   	push   %eax
  800278:	e8 4a fe ff ff       	call   8000c7 <sys_cputs>

	return b.cnt;
}
  80027d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800291:	50                   	push   %eax
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	e8 8c ff ff ff       	call   800226 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 2c             	sub    $0x2c,%esp
  8002a5:	e8 3a 06 00 00       	call   8008e4 <__x86.get_pc_thunk.cx>
  8002aa:	81 c1 56 1d 00 00    	add    $0x1d56,%ecx
  8002b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8002b3:	89 c7                	mov    %eax,%edi
  8002b5:	89 d6                	mov    %edx,%esi
  8002b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cb:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002ce:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002d1:	39 d3                	cmp    %edx,%ebx
  8002d3:	72 09                	jb     8002de <printnum+0x42>
  8002d5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002d8:	0f 87 83 00 00 00    	ja     800361 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	ff 75 18             	pushl  0x18(%ebp)
  8002e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ea:	53                   	push   %ebx
  8002eb:	ff 75 10             	pushl  0x10(%ebp)
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002fa:	ff 75 d0             	pushl  -0x30(%ebp)
  8002fd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800300:	e8 5b 09 00 00       	call   800c60 <__udivdi3>
  800305:	83 c4 18             	add    $0x18,%esp
  800308:	52                   	push   %edx
  800309:	50                   	push   %eax
  80030a:	89 f2                	mov    %esi,%edx
  80030c:	89 f8                	mov    %edi,%eax
  80030e:	e8 89 ff ff ff       	call   80029c <printnum>
  800313:	83 c4 20             	add    $0x20,%esp
  800316:	eb 13                	jmp    80032b <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	56                   	push   %esi
  80031c:	ff 75 18             	pushl  0x18(%ebp)
  80031f:	ff d7                	call   *%edi
  800321:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800324:	83 eb 01             	sub    $0x1,%ebx
  800327:	85 db                	test   %ebx,%ebx
  800329:	7f ed                	jg     800318 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	56                   	push   %esi
  80032f:	83 ec 04             	sub    $0x4,%esp
  800332:	ff 75 dc             	pushl  -0x24(%ebp)
  800335:	ff 75 d8             	pushl  -0x28(%ebp)
  800338:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033b:	ff 75 d0             	pushl  -0x30(%ebp)
  80033e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800341:	89 f3                	mov    %esi,%ebx
  800343:	e8 38 0a 00 00       	call   800d80 <__umoddi3>
  800348:	83 c4 14             	add    $0x14,%esp
  80034b:	0f be 84 06 fa ee ff 	movsbl -0x1106(%esi,%eax,1),%eax
  800352:	ff 
  800353:	50                   	push   %eax
  800354:	ff d7                	call   *%edi
}
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035c:	5b                   	pop    %ebx
  80035d:	5e                   	pop    %esi
  80035e:	5f                   	pop    %edi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    
  800361:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800364:	eb be                	jmp    800324 <printnum+0x88>

00800366 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80036c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800370:	8b 10                	mov    (%eax),%edx
  800372:	3b 50 04             	cmp    0x4(%eax),%edx
  800375:	73 0a                	jae    800381 <sprintputch+0x1b>
		*b->buf++ = ch;
  800377:	8d 4a 01             	lea    0x1(%edx),%ecx
  80037a:	89 08                	mov    %ecx,(%eax)
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	88 02                	mov    %al,(%edx)
}
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <printfmt>:
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800389:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80038c:	50                   	push   %eax
  80038d:	ff 75 10             	pushl  0x10(%ebp)
  800390:	ff 75 0c             	pushl  0xc(%ebp)
  800393:	ff 75 08             	pushl  0x8(%ebp)
  800396:	e8 05 00 00 00       	call   8003a0 <vprintfmt>
}
  80039b:	83 c4 10             	add    $0x10,%esp
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <vprintfmt>:
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 2c             	sub    $0x2c,%esp
  8003a9:	e8 ab fc ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8003ae:	81 c3 52 1c 00 00    	add    $0x1c52,%ebx
  8003b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003b7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003ba:	e9 fb 03 00 00       	jmp    8007ba <.L35+0x48>
		padc = ' ';
  8003bf:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003c3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003ca:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003d1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003dd:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8d 47 01             	lea    0x1(%edi),%eax
  8003e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003e6:	0f b6 17             	movzbl (%edi),%edx
  8003e9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ec:	3c 55                	cmp    $0x55,%al
  8003ee:	0f 87 4e 04 00 00    	ja     800842 <.L22>
  8003f4:	0f b6 c0             	movzbl %al,%eax
  8003f7:	89 d9                	mov    %ebx,%ecx
  8003f9:	03 8c 83 88 ef ff ff 	add    -0x1078(%ebx,%eax,4),%ecx
  800400:	ff e1                	jmp    *%ecx

00800402 <.L71>:
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800405:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800409:	eb d5                	jmp    8003e0 <vprintfmt+0x40>

0080040b <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80040e:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800412:	eb cc                	jmp    8003e0 <vprintfmt+0x40>

00800414 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  800414:	0f b6 d2             	movzbl %dl,%edx
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  80041f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800422:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800426:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800429:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80042c:	83 f9 09             	cmp    $0x9,%ecx
  80042f:	77 55                	ja     800486 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800431:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800434:	eb e9                	jmp    80041f <.L29+0xb>

00800436 <.L26>:
			precision = va_arg(ap, int);
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80043e:	8b 45 14             	mov    0x14(%ebp),%eax
  800441:	8d 40 04             	lea    0x4(%eax),%eax
  800444:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80044a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044e:	79 90                	jns    8003e0 <vprintfmt+0x40>
				width = precision, precision = -1;
  800450:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80045d:	eb 81                	jmp    8003e0 <vprintfmt+0x40>

0080045f <.L27>:
  80045f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	ba 00 00 00 00       	mov    $0x0,%edx
  800469:	0f 49 d0             	cmovns %eax,%edx
  80046c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800472:	e9 69 ff ff ff       	jmp    8003e0 <vprintfmt+0x40>

00800477 <.L23>:
  800477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80047a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800481:	e9 5a ff ff ff       	jmp    8003e0 <vprintfmt+0x40>
  800486:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800489:	eb bf                	jmp    80044a <.L26+0x14>

0080048b <.L33>:
			lflag++;
  80048b:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800492:	e9 49 ff ff ff       	jmp    8003e0 <vprintfmt+0x40>

00800497 <.L30>:
			putch(va_arg(ap, int), putdat);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 78 04             	lea    0x4(%eax),%edi
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	56                   	push   %esi
  8004a1:	ff 30                	pushl  (%eax)
  8004a3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004a6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004a9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ac:	e9 06 03 00 00       	jmp    8007b7 <.L35+0x45>

008004b1 <.L32>:
			err = va_arg(ap, int);
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8d 78 04             	lea    0x4(%eax),%edi
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	99                   	cltd   
  8004ba:	31 d0                	xor    %edx,%eax
  8004bc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004be:	83 f8 06             	cmp    $0x6,%eax
  8004c1:	7f 27                	jg     8004ea <.L32+0x39>
  8004c3:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8004ca:	85 d2                	test   %edx,%edx
  8004cc:	74 1c                	je     8004ea <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004ce:	52                   	push   %edx
  8004cf:	8d 83 1b ef ff ff    	lea    -0x10e5(%ebx),%eax
  8004d5:	50                   	push   %eax
  8004d6:	56                   	push   %esi
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	e8 a4 fe ff ff       	call   800383 <printfmt>
  8004df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e5:	e9 cd 02 00 00       	jmp    8007b7 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004ea:	50                   	push   %eax
  8004eb:	8d 83 12 ef ff ff    	lea    -0x10ee(%ebx),%eax
  8004f1:	50                   	push   %eax
  8004f2:	56                   	push   %esi
  8004f3:	ff 75 08             	pushl  0x8(%ebp)
  8004f6:	e8 88 fe ff ff       	call   800383 <printfmt>
  8004fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800501:	e9 b1 02 00 00       	jmp    8007b7 <.L35+0x45>

00800506 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	83 c0 04             	add    $0x4,%eax
  80050c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800514:	85 ff                	test   %edi,%edi
  800516:	8d 83 0b ef ff ff    	lea    -0x10f5(%ebx),%eax
  80051c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80051f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800523:	0f 8e b5 00 00 00    	jle    8005de <.L36+0xd8>
  800529:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80052d:	75 08                	jne    800537 <.L36+0x31>
  80052f:	89 75 0c             	mov    %esi,0xc(%ebp)
  800532:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800535:	eb 6d                	jmp    8005a4 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 cc             	pushl  -0x34(%ebp)
  80053d:	57                   	push   %edi
  80053e:	e8 bd 03 00 00       	call   800900 <strnlen>
  800543:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800546:	29 c2                	sub    %eax,%edx
  800548:	89 55 c8             	mov    %edx,-0x38(%ebp)
  80054b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80054e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800552:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800555:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800558:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80055a:	eb 10                	jmp    80056c <.L36+0x66>
					putch(padc, putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	56                   	push   %esi
  800560:	ff 75 e0             	pushl  -0x20(%ebp)
  800563:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800566:	83 ef 01             	sub    $0x1,%edi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	85 ff                	test   %edi,%edi
  80056e:	7f ec                	jg     80055c <.L36+0x56>
  800570:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800573:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800576:	85 d2                	test   %edx,%edx
  800578:	b8 00 00 00 00       	mov    $0x0,%eax
  80057d:	0f 49 c2             	cmovns %edx,%eax
  800580:	29 c2                	sub    %eax,%edx
  800582:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800585:	89 75 0c             	mov    %esi,0xc(%ebp)
  800588:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80058b:	eb 17                	jmp    8005a4 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  80058d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800591:	75 30                	jne    8005c3 <.L36+0xbd>
					putch(ch, putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	50                   	push   %eax
  80059a:	ff 55 08             	call   *0x8(%ebp)
  80059d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a0:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005a4:	83 c7 01             	add    $0x1,%edi
  8005a7:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005ab:	0f be c2             	movsbl %dl,%eax
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	74 52                	je     800604 <.L36+0xfe>
  8005b2:	85 f6                	test   %esi,%esi
  8005b4:	78 d7                	js     80058d <.L36+0x87>
  8005b6:	83 ee 01             	sub    $0x1,%esi
  8005b9:	79 d2                	jns    80058d <.L36+0x87>
  8005bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005be:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005c1:	eb 32                	jmp    8005f5 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005c3:	0f be d2             	movsbl %dl,%edx
  8005c6:	83 ea 20             	sub    $0x20,%edx
  8005c9:	83 fa 5e             	cmp    $0x5e,%edx
  8005cc:	76 c5                	jbe    800593 <.L36+0x8d>
					putch('?', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	6a 3f                	push   $0x3f
  8005d6:	ff 55 08             	call   *0x8(%ebp)
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	eb c2                	jmp    8005a0 <.L36+0x9a>
  8005de:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005e1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005e4:	eb be                	jmp    8005a4 <.L36+0x9e>
				putch(' ', putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	56                   	push   %esi
  8005ea:	6a 20                	push   $0x20
  8005ec:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005ef:	83 ef 01             	sub    $0x1,%edi
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	85 ff                	test   %edi,%edi
  8005f7:	7f ed                	jg     8005e6 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ff:	e9 b3 01 00 00       	jmp    8007b7 <.L35+0x45>
  800604:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800607:	8b 75 0c             	mov    0xc(%ebp),%esi
  80060a:	eb e9                	jmp    8005f5 <.L36+0xef>

0080060c <.L31>:
  80060c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80060f:	83 f9 01             	cmp    $0x1,%ecx
  800612:	7e 40                	jle    800654 <.L31+0x48>
		return va_arg(*ap, long long);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8b 50 04             	mov    0x4(%eax),%edx
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 40 08             	lea    0x8(%eax),%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062f:	79 55                	jns    800686 <.L31+0x7a>
				putch('-', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	56                   	push   %esi
  800635:	6a 2d                	push   $0x2d
  800637:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80063a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80063d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800640:	f7 da                	neg    %edx
  800642:	83 d1 00             	adc    $0x0,%ecx
  800645:	f7 d9                	neg    %ecx
  800647:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064f:	e9 48 01 00 00       	jmp    80079c <.L35+0x2a>
	else if (lflag)
  800654:	85 c9                	test   %ecx,%ecx
  800656:	75 17                	jne    80066f <.L31+0x63>
		return va_arg(*ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	99                   	cltd   
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	eb bc                	jmp    80062b <.L31+0x1f>
		return va_arg(*ap, long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	99                   	cltd   
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
  800684:	eb a5                	jmp    80062b <.L31+0x1f>
			num = getint(&ap, lflag);
  800686:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800689:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80068c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800691:	e9 06 01 00 00       	jmp    80079c <.L35+0x2a>

00800696 <.L37>:
  800696:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800699:	83 f9 01             	cmp    $0x1,%ecx
  80069c:	7e 18                	jle    8006b6 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 10                	mov    (%eax),%edx
  8006a3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a6:	8d 40 08             	lea    0x8(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b1:	e9 e6 00 00 00       	jmp    80079c <.L35+0x2a>
	else if (lflag)
  8006b6:	85 c9                	test   %ecx,%ecx
  8006b8:	75 1a                	jne    8006d4 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 10                	mov    (%eax),%edx
  8006bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cf:	e9 c8 00 00 00       	jmp    80079c <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e9:	e9 ae 00 00 00       	jmp    80079c <.L35+0x2a>

008006ee <.L34>:
  8006ee:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7e 3d                	jle    800733 <.L34+0x45>
		return va_arg(*ap, long long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 50 04             	mov    0x4(%eax),%edx
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800701:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 40 08             	lea    0x8(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80070d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800711:	79 52                	jns    800765 <.L34+0x77>
                putch('-', putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	56                   	push   %esi
  800717:	6a 2d                	push   $0x2d
  800719:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  80071c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80071f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800722:	f7 da                	neg    %edx
  800724:	83 d1 00             	adc    $0x0,%ecx
  800727:	f7 d9                	neg    %ecx
  800729:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80072c:	b8 08 00 00 00       	mov    $0x8,%eax
  800731:	eb 69                	jmp    80079c <.L35+0x2a>
	else if (lflag)
  800733:	85 c9                	test   %ecx,%ecx
  800735:	75 17                	jne    80074e <.L34+0x60>
		return va_arg(*ap, int);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	99                   	cltd   
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	eb bf                	jmp    80070d <.L34+0x1f>
		return va_arg(*ap, long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800756:	99                   	cltd   
  800757:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 04             	lea    0x4(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
  800763:	eb a8                	jmp    80070d <.L34+0x1f>
            num = getint(&ap, lflag);
  800765:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800768:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80076b:	b8 08 00 00 00       	mov    $0x8,%eax
  800770:	eb 2a                	jmp    80079c <.L35+0x2a>

00800772 <.L35>:
			putch('0', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	56                   	push   %esi
  800776:	6a 30                	push   $0x30
  800778:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80077b:	83 c4 08             	add    $0x8,%esp
  80077e:	56                   	push   %esi
  80077f:	6a 78                	push   $0x78
  800781:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 10                	mov    (%eax),%edx
  800789:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80078e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800791:	8d 40 04             	lea    0x4(%eax),%eax
  800794:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800797:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80079c:	83 ec 0c             	sub    $0xc,%esp
  80079f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007a3:	57                   	push   %edi
  8007a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007a7:	50                   	push   %eax
  8007a8:	51                   	push   %ecx
  8007a9:	52                   	push   %edx
  8007aa:	89 f2                	mov    %esi,%edx
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	e8 e8 fa ff ff       	call   80029c <printnum>
			break;
  8007b4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ba:	83 c7 01             	add    $0x1,%edi
  8007bd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c1:	83 f8 25             	cmp    $0x25,%eax
  8007c4:	0f 84 f5 fb ff ff    	je     8003bf <vprintfmt+0x1f>
			if (ch == '\0')
  8007ca:	85 c0                	test   %eax,%eax
  8007cc:	0f 84 91 00 00 00    	je     800863 <.L22+0x21>
			putch(ch, putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	56                   	push   %esi
  8007d6:	50                   	push   %eax
  8007d7:	ff 55 08             	call   *0x8(%ebp)
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	eb db                	jmp    8007ba <.L35+0x48>

008007df <.L38>:
  8007df:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007e2:	83 f9 01             	cmp    $0x1,%ecx
  8007e5:	7e 15                	jle    8007fc <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 10                	mov    (%eax),%edx
  8007ec:	8b 48 04             	mov    0x4(%eax),%ecx
  8007ef:	8d 40 08             	lea    0x8(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fa:	eb a0                	jmp    80079c <.L35+0x2a>
	else if (lflag)
  8007fc:	85 c9                	test   %ecx,%ecx
  8007fe:	75 17                	jne    800817 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800810:	b8 10 00 00 00       	mov    $0x10,%eax
  800815:	eb 85                	jmp    80079c <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8b 10                	mov    (%eax),%edx
  80081c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800827:	b8 10 00 00 00       	mov    $0x10,%eax
  80082c:	e9 6b ff ff ff       	jmp    80079c <.L35+0x2a>

00800831 <.L25>:
			putch(ch, putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	56                   	push   %esi
  800835:	6a 25                	push   $0x25
  800837:	ff 55 08             	call   *0x8(%ebp)
			break;
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	e9 75 ff ff ff       	jmp    8007b7 <.L35+0x45>

00800842 <.L22>:
			putch('%', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	56                   	push   %esi
  800846:	6a 25                	push   $0x25
  800848:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 f8                	mov    %edi,%eax
  800850:	eb 03                	jmp    800855 <.L22+0x13>
  800852:	83 e8 01             	sub    $0x1,%eax
  800855:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800859:	75 f7                	jne    800852 <.L22+0x10>
  80085b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80085e:	e9 54 ff ff ff       	jmp    8007b7 <.L35+0x45>
}
  800863:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800866:	5b                   	pop    %ebx
  800867:	5e                   	pop    %esi
  800868:	5f                   	pop    %edi
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	83 ec 14             	sub    $0x14,%esp
  800872:	e8 e2 f7 ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800877:	81 c3 89 17 00 00    	add    $0x1789,%ebx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800883:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800886:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800894:	85 c0                	test   %eax,%eax
  800896:	74 2b                	je     8008c3 <vsnprintf+0x58>
  800898:	85 d2                	test   %edx,%edx
  80089a:	7e 27                	jle    8008c3 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089c:	ff 75 14             	pushl  0x14(%ebp)
  80089f:	ff 75 10             	pushl  0x10(%ebp)
  8008a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a5:	50                   	push   %eax
  8008a6:	8d 83 66 e3 ff ff    	lea    -0x1c9a(%ebx),%eax
  8008ac:	50                   	push   %eax
  8008ad:	e8 ee fa ff ff       	call   8003a0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
}
  8008be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    
		return -E_INVAL;
  8008c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c8:	eb f4                	jmp    8008be <vsnprintf+0x53>

008008ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	50                   	push   %eax
  8008d4:	ff 75 10             	pushl  0x10(%ebp)
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 89 ff ff ff       	call   80086b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <__x86.get_pc_thunk.cx>:
  8008e4:	8b 0c 24             	mov    (%esp),%ecx
  8008e7:	c3                   	ret    

008008e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	eb 03                	jmp    8008f8 <strlen+0x10>
		n++;
  8008f5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008f8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fc:	75 f7                	jne    8008f5 <strlen+0xd>
	return n;
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800909:	b8 00 00 00 00       	mov    $0x0,%eax
  80090e:	eb 03                	jmp    800913 <strnlen+0x13>
		n++;
  800910:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800913:	39 d0                	cmp    %edx,%eax
  800915:	74 06                	je     80091d <strnlen+0x1d>
  800917:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091b:	75 f3                	jne    800910 <strnlen+0x10>
	return n;
}
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	53                   	push   %ebx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800929:	89 c2                	mov    %eax,%edx
  80092b:	83 c1 01             	add    $0x1,%ecx
  80092e:	83 c2 01             	add    $0x1,%edx
  800931:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800935:	88 5a ff             	mov    %bl,-0x1(%edx)
  800938:	84 db                	test   %bl,%bl
  80093a:	75 ef                	jne    80092b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80093c:	5b                   	pop    %ebx
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	53                   	push   %ebx
  800943:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800946:	53                   	push   %ebx
  800947:	e8 9c ff ff ff       	call   8008e8 <strlen>
  80094c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	01 d8                	add    %ebx,%eax
  800954:	50                   	push   %eax
  800955:	e8 c5 ff ff ff       	call   80091f <strcpy>
	return dst;
}
  80095a:	89 d8                	mov    %ebx,%eax
  80095c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095f:	c9                   	leave  
  800960:	c3                   	ret    

00800961 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	56                   	push   %esi
  800965:	53                   	push   %ebx
  800966:	8b 75 08             	mov    0x8(%ebp),%esi
  800969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096c:	89 f3                	mov    %esi,%ebx
  80096e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800971:	89 f2                	mov    %esi,%edx
  800973:	eb 0f                	jmp    800984 <strncpy+0x23>
		*dst++ = *src;
  800975:	83 c2 01             	add    $0x1,%edx
  800978:	0f b6 01             	movzbl (%ecx),%eax
  80097b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097e:	80 39 01             	cmpb   $0x1,(%ecx)
  800981:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800984:	39 da                	cmp    %ebx,%edx
  800986:	75 ed                	jne    800975 <strncpy+0x14>
	}
	return ret;
}
  800988:	89 f0                	mov    %esi,%eax
  80098a:	5b                   	pop    %ebx
  80098b:	5e                   	pop    %esi
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	8b 75 08             	mov    0x8(%ebp),%esi
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
  800999:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80099c:	89 f0                	mov    %esi,%eax
  80099e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a2:	85 c9                	test   %ecx,%ecx
  8009a4:	75 0b                	jne    8009b1 <strlcpy+0x23>
  8009a6:	eb 17                	jmp    8009bf <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009a8:	83 c2 01             	add    $0x1,%edx
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009b1:	39 d8                	cmp    %ebx,%eax
  8009b3:	74 07                	je     8009bc <strlcpy+0x2e>
  8009b5:	0f b6 0a             	movzbl (%edx),%ecx
  8009b8:	84 c9                	test   %cl,%cl
  8009ba:	75 ec                	jne    8009a8 <strlcpy+0x1a>
		*dst = '\0';
  8009bc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009bf:	29 f0                	sub    %esi,%eax
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ce:	eb 06                	jmp    8009d6 <strcmp+0x11>
		p++, q++;
  8009d0:	83 c1 01             	add    $0x1,%ecx
  8009d3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009d6:	0f b6 01             	movzbl (%ecx),%eax
  8009d9:	84 c0                	test   %al,%al
  8009db:	74 04                	je     8009e1 <strcmp+0x1c>
  8009dd:	3a 02                	cmp    (%edx),%al
  8009df:	74 ef                	je     8009d0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e1:	0f b6 c0             	movzbl %al,%eax
  8009e4:	0f b6 12             	movzbl (%edx),%edx
  8009e7:	29 d0                	sub    %edx,%eax
}
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f5:	89 c3                	mov    %eax,%ebx
  8009f7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009fa:	eb 06                	jmp    800a02 <strncmp+0x17>
		n--, p++, q++;
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a02:	39 d8                	cmp    %ebx,%eax
  800a04:	74 16                	je     800a1c <strncmp+0x31>
  800a06:	0f b6 08             	movzbl (%eax),%ecx
  800a09:	84 c9                	test   %cl,%cl
  800a0b:	74 04                	je     800a11 <strncmp+0x26>
  800a0d:	3a 0a                	cmp    (%edx),%cl
  800a0f:	74 eb                	je     8009fc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a11:	0f b6 00             	movzbl (%eax),%eax
  800a14:	0f b6 12             	movzbl (%edx),%edx
  800a17:	29 d0                	sub    %edx,%eax
}
  800a19:	5b                   	pop    %ebx
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    
		return 0;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a21:	eb f6                	jmp    800a19 <strncmp+0x2e>

00800a23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2d:	0f b6 10             	movzbl (%eax),%edx
  800a30:	84 d2                	test   %dl,%dl
  800a32:	74 09                	je     800a3d <strchr+0x1a>
		if (*s == c)
  800a34:	38 ca                	cmp    %cl,%dl
  800a36:	74 0a                	je     800a42 <strchr+0x1f>
	for (; *s; s++)
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	eb f0                	jmp    800a2d <strchr+0xa>
			return (char *) s;
	return 0;
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4e:	eb 03                	jmp    800a53 <strfind+0xf>
  800a50:	83 c0 01             	add    $0x1,%eax
  800a53:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a56:	38 ca                	cmp    %cl,%dl
  800a58:	74 04                	je     800a5e <strfind+0x1a>
  800a5a:	84 d2                	test   %dl,%dl
  800a5c:	75 f2                	jne    800a50 <strfind+0xc>
			break;
	return (char *) s;
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6c:	85 c9                	test   %ecx,%ecx
  800a6e:	74 13                	je     800a83 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a70:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a76:	75 05                	jne    800a7d <memset+0x1d>
  800a78:	f6 c1 03             	test   $0x3,%cl
  800a7b:	74 0d                	je     800a8a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	fc                   	cld    
  800a81:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a83:	89 f8                	mov    %edi,%eax
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5f                   	pop    %edi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    
		c &= 0xFF;
  800a8a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8e:	89 d3                	mov    %edx,%ebx
  800a90:	c1 e3 08             	shl    $0x8,%ebx
  800a93:	89 d0                	mov    %edx,%eax
  800a95:	c1 e0 18             	shl    $0x18,%eax
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	c1 e6 10             	shl    $0x10,%esi
  800a9d:	09 f0                	or     %esi,%eax
  800a9f:	09 c2                	or     %eax,%edx
  800aa1:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800aa3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	fc                   	cld    
  800aa9:	f3 ab                	rep stos %eax,%es:(%edi)
  800aab:	eb d6                	jmp    800a83 <memset+0x23>

00800aad <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	57                   	push   %edi
  800ab1:	56                   	push   %esi
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800abb:	39 c6                	cmp    %eax,%esi
  800abd:	73 35                	jae    800af4 <memmove+0x47>
  800abf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac2:	39 c2                	cmp    %eax,%edx
  800ac4:	76 2e                	jbe    800af4 <memmove+0x47>
		s += n;
		d += n;
  800ac6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac9:	89 d6                	mov    %edx,%esi
  800acb:	09 fe                	or     %edi,%esi
  800acd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad3:	74 0c                	je     800ae1 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad5:	83 ef 01             	sub    $0x1,%edi
  800ad8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800adb:	fd                   	std    
  800adc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ade:	fc                   	cld    
  800adf:	eb 21                	jmp    800b02 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae1:	f6 c1 03             	test   $0x3,%cl
  800ae4:	75 ef                	jne    800ad5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae6:	83 ef 04             	sub    $0x4,%edi
  800ae9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aef:	fd                   	std    
  800af0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af2:	eb ea                	jmp    800ade <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af4:	89 f2                	mov    %esi,%edx
  800af6:	09 c2                	or     %eax,%edx
  800af8:	f6 c2 03             	test   $0x3,%dl
  800afb:	74 09                	je     800b06 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800afd:	89 c7                	mov    %eax,%edi
  800aff:	fc                   	cld    
  800b00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b06:	f6 c1 03             	test   $0x3,%cl
  800b09:	75 f2                	jne    800afd <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b0e:	89 c7                	mov    %eax,%edi
  800b10:	fc                   	cld    
  800b11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b13:	eb ed                	jmp    800b02 <memmove+0x55>

00800b15 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b18:	ff 75 10             	pushl  0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 87 ff ff ff       	call   800aad <memmove>
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	89 c6                	mov    %eax,%esi
  800b35:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b38:	39 f0                	cmp    %esi,%eax
  800b3a:	74 1c                	je     800b58 <memcmp+0x30>
		if (*s1 != *s2)
  800b3c:	0f b6 08             	movzbl (%eax),%ecx
  800b3f:	0f b6 1a             	movzbl (%edx),%ebx
  800b42:	38 d9                	cmp    %bl,%cl
  800b44:	75 08                	jne    800b4e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b46:	83 c0 01             	add    $0x1,%eax
  800b49:	83 c2 01             	add    $0x1,%edx
  800b4c:	eb ea                	jmp    800b38 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b4e:	0f b6 c1             	movzbl %cl,%eax
  800b51:	0f b6 db             	movzbl %bl,%ebx
  800b54:	29 d8                	sub    %ebx,%eax
  800b56:	eb 05                	jmp    800b5d <memcmp+0x35>
	}

	return 0;
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5d:	5b                   	pop    %ebx
  800b5e:	5e                   	pop    %esi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6a:	89 c2                	mov    %eax,%edx
  800b6c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b6f:	39 d0                	cmp    %edx,%eax
  800b71:	73 09                	jae    800b7c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b73:	38 08                	cmp    %cl,(%eax)
  800b75:	74 05                	je     800b7c <memfind+0x1b>
	for (; s < ends; s++)
  800b77:	83 c0 01             	add    $0x1,%eax
  800b7a:	eb f3                	jmp    800b6f <memfind+0xe>
			break;
	return (void *) s;
}
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	57                   	push   %edi
  800b82:	56                   	push   %esi
  800b83:	53                   	push   %ebx
  800b84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8a:	eb 03                	jmp    800b8f <strtol+0x11>
		s++;
  800b8c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b8f:	0f b6 01             	movzbl (%ecx),%eax
  800b92:	3c 20                	cmp    $0x20,%al
  800b94:	74 f6                	je     800b8c <strtol+0xe>
  800b96:	3c 09                	cmp    $0x9,%al
  800b98:	74 f2                	je     800b8c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b9a:	3c 2b                	cmp    $0x2b,%al
  800b9c:	74 2e                	je     800bcc <strtol+0x4e>
	int neg = 0;
  800b9e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba3:	3c 2d                	cmp    $0x2d,%al
  800ba5:	74 2f                	je     800bd6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bad:	75 05                	jne    800bb4 <strtol+0x36>
  800baf:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb2:	74 2c                	je     800be0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb4:	85 db                	test   %ebx,%ebx
  800bb6:	75 0a                	jne    800bc2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bbd:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc0:	74 28                	je     800bea <strtol+0x6c>
		base = 10;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bca:	eb 50                	jmp    800c1c <strtol+0x9e>
		s++;
  800bcc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd4:	eb d1                	jmp    800ba7 <strtol+0x29>
		s++, neg = 1;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	bf 01 00 00 00       	mov    $0x1,%edi
  800bde:	eb c7                	jmp    800ba7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be4:	74 0e                	je     800bf4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800be6:	85 db                	test   %ebx,%ebx
  800be8:	75 d8                	jne    800bc2 <strtol+0x44>
		s++, base = 8;
  800bea:	83 c1 01             	add    $0x1,%ecx
  800bed:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf2:	eb ce                	jmp    800bc2 <strtol+0x44>
		s += 2, base = 16;
  800bf4:	83 c1 02             	add    $0x2,%ecx
  800bf7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bfc:	eb c4                	jmp    800bc2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bfe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 29                	ja     800c31 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c11:	7d 30                	jge    800c43 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1c:	0f b6 11             	movzbl (%ecx),%edx
  800c1f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c22:	89 f3                	mov    %esi,%ebx
  800c24:	80 fb 09             	cmp    $0x9,%bl
  800c27:	77 d5                	ja     800bfe <strtol+0x80>
			dig = *s - '0';
  800c29:	0f be d2             	movsbl %dl,%edx
  800c2c:	83 ea 30             	sub    $0x30,%edx
  800c2f:	eb dd                	jmp    800c0e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c31:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c34:	89 f3                	mov    %esi,%ebx
  800c36:	80 fb 19             	cmp    $0x19,%bl
  800c39:	77 08                	ja     800c43 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 37             	sub    $0x37,%edx
  800c41:	eb cb                	jmp    800c0e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c47:	74 05                	je     800c4e <strtol+0xd0>
		*endptr = (char *) s;
  800c49:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	f7 da                	neg    %edx
  800c52:	85 ff                	test   %edi,%edi
  800c54:	0f 45 c2             	cmovne %edx,%eax
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    
  800c5c:	66 90                	xchg   %ax,%ax
  800c5e:	66 90                	xchg   %ax,%ax

00800c60 <__udivdi3>:
  800c60:	55                   	push   %ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
  800c64:	83 ec 1c             	sub    $0x1c,%esp
  800c67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c77:	85 d2                	test   %edx,%edx
  800c79:	75 35                	jne    800cb0 <__udivdi3+0x50>
  800c7b:	39 f3                	cmp    %esi,%ebx
  800c7d:	0f 87 bd 00 00 00    	ja     800d40 <__udivdi3+0xe0>
  800c83:	85 db                	test   %ebx,%ebx
  800c85:	89 d9                	mov    %ebx,%ecx
  800c87:	75 0b                	jne    800c94 <__udivdi3+0x34>
  800c89:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8e:	31 d2                	xor    %edx,%edx
  800c90:	f7 f3                	div    %ebx
  800c92:	89 c1                	mov    %eax,%ecx
  800c94:	31 d2                	xor    %edx,%edx
  800c96:	89 f0                	mov    %esi,%eax
  800c98:	f7 f1                	div    %ecx
  800c9a:	89 c6                	mov    %eax,%esi
  800c9c:	89 e8                	mov    %ebp,%eax
  800c9e:	89 f7                	mov    %esi,%edi
  800ca0:	f7 f1                	div    %ecx
  800ca2:	89 fa                	mov    %edi,%edx
  800ca4:	83 c4 1c             	add    $0x1c,%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
  800cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cb0:	39 f2                	cmp    %esi,%edx
  800cb2:	77 7c                	ja     800d30 <__udivdi3+0xd0>
  800cb4:	0f bd fa             	bsr    %edx,%edi
  800cb7:	83 f7 1f             	xor    $0x1f,%edi
  800cba:	0f 84 98 00 00 00    	je     800d58 <__udivdi3+0xf8>
  800cc0:	89 f9                	mov    %edi,%ecx
  800cc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800cc7:	29 f8                	sub    %edi,%eax
  800cc9:	d3 e2                	shl    %cl,%edx
  800ccb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ccf:	89 c1                	mov    %eax,%ecx
  800cd1:	89 da                	mov    %ebx,%edx
  800cd3:	d3 ea                	shr    %cl,%edx
  800cd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cd9:	09 d1                	or     %edx,%ecx
  800cdb:	89 f2                	mov    %esi,%edx
  800cdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ce1:	89 f9                	mov    %edi,%ecx
  800ce3:	d3 e3                	shl    %cl,%ebx
  800ce5:	89 c1                	mov    %eax,%ecx
  800ce7:	d3 ea                	shr    %cl,%edx
  800ce9:	89 f9                	mov    %edi,%ecx
  800ceb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cef:	d3 e6                	shl    %cl,%esi
  800cf1:	89 eb                	mov    %ebp,%ebx
  800cf3:	89 c1                	mov    %eax,%ecx
  800cf5:	d3 eb                	shr    %cl,%ebx
  800cf7:	09 de                	or     %ebx,%esi
  800cf9:	89 f0                	mov    %esi,%eax
  800cfb:	f7 74 24 08          	divl   0x8(%esp)
  800cff:	89 d6                	mov    %edx,%esi
  800d01:	89 c3                	mov    %eax,%ebx
  800d03:	f7 64 24 0c          	mull   0xc(%esp)
  800d07:	39 d6                	cmp    %edx,%esi
  800d09:	72 0c                	jb     800d17 <__udivdi3+0xb7>
  800d0b:	89 f9                	mov    %edi,%ecx
  800d0d:	d3 e5                	shl    %cl,%ebp
  800d0f:	39 c5                	cmp    %eax,%ebp
  800d11:	73 5d                	jae    800d70 <__udivdi3+0x110>
  800d13:	39 d6                	cmp    %edx,%esi
  800d15:	75 59                	jne    800d70 <__udivdi3+0x110>
  800d17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d1a:	31 ff                	xor    %edi,%edi
  800d1c:	89 fa                	mov    %edi,%edx
  800d1e:	83 c4 1c             	add    $0x1c,%esp
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    
  800d26:	8d 76 00             	lea    0x0(%esi),%esi
  800d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d30:	31 ff                	xor    %edi,%edi
  800d32:	31 c0                	xor    %eax,%eax
  800d34:	89 fa                	mov    %edi,%edx
  800d36:	83 c4 1c             	add    $0x1c,%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
  800d3e:	66 90                	xchg   %ax,%ax
  800d40:	31 ff                	xor    %edi,%edi
  800d42:	89 e8                	mov    %ebp,%eax
  800d44:	89 f2                	mov    %esi,%edx
  800d46:	f7 f3                	div    %ebx
  800d48:	89 fa                	mov    %edi,%edx
  800d4a:	83 c4 1c             	add    $0x1c,%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
  800d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d58:	39 f2                	cmp    %esi,%edx
  800d5a:	72 06                	jb     800d62 <__udivdi3+0x102>
  800d5c:	31 c0                	xor    %eax,%eax
  800d5e:	39 eb                	cmp    %ebp,%ebx
  800d60:	77 d2                	ja     800d34 <__udivdi3+0xd4>
  800d62:	b8 01 00 00 00       	mov    $0x1,%eax
  800d67:	eb cb                	jmp    800d34 <__udivdi3+0xd4>
  800d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d70:	89 d8                	mov    %ebx,%eax
  800d72:	31 ff                	xor    %edi,%edi
  800d74:	eb be                	jmp    800d34 <__udivdi3+0xd4>
  800d76:	66 90                	xchg   %ax,%ax
  800d78:	66 90                	xchg   %ax,%ax
  800d7a:	66 90                	xchg   %ax,%ax
  800d7c:	66 90                	xchg   %ax,%ax
  800d7e:	66 90                	xchg   %ax,%ax

00800d80 <__umoddi3>:
  800d80:	55                   	push   %ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 1c             	sub    $0x1c,%esp
  800d87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800d8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800d97:	85 ed                	test   %ebp,%ebp
  800d99:	89 f0                	mov    %esi,%eax
  800d9b:	89 da                	mov    %ebx,%edx
  800d9d:	75 19                	jne    800db8 <__umoddi3+0x38>
  800d9f:	39 df                	cmp    %ebx,%edi
  800da1:	0f 86 b1 00 00 00    	jbe    800e58 <__umoddi3+0xd8>
  800da7:	f7 f7                	div    %edi
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	31 d2                	xor    %edx,%edx
  800dad:	83 c4 1c             	add    $0x1c,%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
  800db5:	8d 76 00             	lea    0x0(%esi),%esi
  800db8:	39 dd                	cmp    %ebx,%ebp
  800dba:	77 f1                	ja     800dad <__umoddi3+0x2d>
  800dbc:	0f bd cd             	bsr    %ebp,%ecx
  800dbf:	83 f1 1f             	xor    $0x1f,%ecx
  800dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800dc6:	0f 84 b4 00 00 00    	je     800e80 <__umoddi3+0x100>
  800dcc:	b8 20 00 00 00       	mov    $0x20,%eax
  800dd1:	89 c2                	mov    %eax,%edx
  800dd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 c1                	mov    %eax,%ecx
  800ddb:	89 f8                	mov    %edi,%eax
  800ddd:	d3 e5                	shl    %cl,%ebp
  800ddf:	89 d1                	mov    %edx,%ecx
  800de1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800de5:	d3 e8                	shr    %cl,%eax
  800de7:	09 c5                	or     %eax,%ebp
  800de9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ded:	89 c1                	mov    %eax,%ecx
  800def:	d3 e7                	shl    %cl,%edi
  800df1:	89 d1                	mov    %edx,%ecx
  800df3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800df7:	89 df                	mov    %ebx,%edi
  800df9:	d3 ef                	shr    %cl,%edi
  800dfb:	89 c1                	mov    %eax,%ecx
  800dfd:	89 f0                	mov    %esi,%eax
  800dff:	d3 e3                	shl    %cl,%ebx
  800e01:	89 d1                	mov    %edx,%ecx
  800e03:	89 fa                	mov    %edi,%edx
  800e05:	d3 e8                	shr    %cl,%eax
  800e07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800e0c:	09 d8                	or     %ebx,%eax
  800e0e:	f7 f5                	div    %ebp
  800e10:	d3 e6                	shl    %cl,%esi
  800e12:	89 d1                	mov    %edx,%ecx
  800e14:	f7 64 24 08          	mull   0x8(%esp)
  800e18:	39 d1                	cmp    %edx,%ecx
  800e1a:	89 c3                	mov    %eax,%ebx
  800e1c:	89 d7                	mov    %edx,%edi
  800e1e:	72 06                	jb     800e26 <__umoddi3+0xa6>
  800e20:	75 0e                	jne    800e30 <__umoddi3+0xb0>
  800e22:	39 c6                	cmp    %eax,%esi
  800e24:	73 0a                	jae    800e30 <__umoddi3+0xb0>
  800e26:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e2a:	19 ea                	sbb    %ebp,%edx
  800e2c:	89 d7                	mov    %edx,%edi
  800e2e:	89 c3                	mov    %eax,%ebx
  800e30:	89 ca                	mov    %ecx,%edx
  800e32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e37:	29 de                	sub    %ebx,%esi
  800e39:	19 fa                	sbb    %edi,%edx
  800e3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e3f:	89 d0                	mov    %edx,%eax
  800e41:	d3 e0                	shl    %cl,%eax
  800e43:	89 d9                	mov    %ebx,%ecx
  800e45:	d3 ee                	shr    %cl,%esi
  800e47:	d3 ea                	shr    %cl,%edx
  800e49:	09 f0                	or     %esi,%eax
  800e4b:	83 c4 1c             	add    $0x1c,%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    
  800e53:	90                   	nop
  800e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e58:	85 ff                	test   %edi,%edi
  800e5a:	89 f9                	mov    %edi,%ecx
  800e5c:	75 0b                	jne    800e69 <__umoddi3+0xe9>
  800e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e63:	31 d2                	xor    %edx,%edx
  800e65:	f7 f7                	div    %edi
  800e67:	89 c1                	mov    %eax,%ecx
  800e69:	89 d8                	mov    %ebx,%eax
  800e6b:	31 d2                	xor    %edx,%edx
  800e6d:	f7 f1                	div    %ecx
  800e6f:	89 f0                	mov    %esi,%eax
  800e71:	f7 f1                	div    %ecx
  800e73:	e9 31 ff ff ff       	jmp    800da9 <__umoddi3+0x29>
  800e78:	90                   	nop
  800e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e80:	39 dd                	cmp    %ebx,%ebp
  800e82:	72 08                	jb     800e8c <__umoddi3+0x10c>
  800e84:	39 f7                	cmp    %esi,%edi
  800e86:	0f 87 21 ff ff ff    	ja     800dad <__umoddi3+0x2d>
  800e8c:	89 da                	mov    %ebx,%edx
  800e8e:	89 f0                	mov    %esi,%eax
  800e90:	29 f8                	sub    %edi,%eax
  800e92:	19 ea                	sbb    %ebp,%edx
  800e94:	e9 14 ff ff ff       	jmp    800dad <__umoddi3+0x2d>
