
obj/user/badsegment：     文件格式 elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	e8 3f 00 00 00       	call   800087 <__x86.get_pc_thunk.bx>
  800048:	81 c3 b8 1f 00 00    	add    $0x1fb8,%ebx
  80004e:	8b 45 08             	mov    0x8(%ebp),%eax
  800051:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800054:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  80005a:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  800060:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800062:	85 c0                	test   %eax,%eax
  800064:	7e 08                	jle    80006e <libmain+0x30>
		binaryname = argv[0];
  800066:	8b 0a                	mov    (%edx),%ecx
  800068:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	52                   	push   %edx
  800072:	50                   	push   %eax
  800073:	e8 bb ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800078:	e8 0e 00 00 00       	call   80008b <exit>
}
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800083:	5b                   	pop    %ebx
  800084:	5e                   	pop    %esi
  800085:	5d                   	pop    %ebp
  800086:	c3                   	ret    

00800087 <__x86.get_pc_thunk.bx>:
  800087:	8b 1c 24             	mov    (%esp),%ebx
  80008a:	c3                   	ret    

0080008b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	53                   	push   %ebx
  80008f:	83 ec 10             	sub    $0x10,%esp
  800092:	e8 f0 ff ff ff       	call   800087 <__x86.get_pc_thunk.bx>
  800097:	81 c3 69 1f 00 00    	add    $0x1f69,%ebx
	sys_env_destroy(0);
  80009d:	6a 00                	push   $0x0
  80009f:	e8 45 00 00 00       	call   8000e9 <sys_env_destroy>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000aa:	c9                   	leave  
  8000ab:	c3                   	ret    

008000ac <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	57                   	push   %edi
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bd:	89 c3                	mov    %eax,%ebx
  8000bf:	89 c7                	mov    %eax,%edi
  8000c1:	89 c6                	mov    %eax,%esi
  8000c3:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <sys_cgetc>:

int
sys_cgetc(void) {
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000da:	89 d1                	mov    %edx,%ecx
  8000dc:	89 d3                	mov    %edx,%ebx
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	89 d6                	mov    %edx,%esi
  8000e2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
  8000f2:	e8 66 00 00 00       	call   80015d <__x86.get_pc_thunk.ax>
  8000f7:	05 09 1f 00 00       	add    $0x1f09,%eax
  8000fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	8b 55 08             	mov    0x8(%ebp),%edx
  800107:	b8 03 00 00 00       	mov    $0x3,%eax
  80010c:	89 cb                	mov    %ecx,%ebx
  80010e:	89 cf                	mov    %ecx,%edi
  800110:	89 ce                	mov    %ecx,%esi
  800112:	cd 30                	int    $0x30
    if (check && ret > 0)
  800114:	85 c0                	test   %eax,%eax
  800116:	7f 08                	jg     800120 <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011b:	5b                   	pop    %ebx
  80011c:	5e                   	pop    %esi
  80011d:	5f                   	pop    %edi
  80011e:	5d                   	pop    %ebp
  80011f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	6a 03                	push   $0x3
  800126:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800129:	8d 83 96 ee ff ff    	lea    -0x116a(%ebx),%eax
  80012f:	50                   	push   %eax
  800130:	6a 24                	push   $0x24
  800132:	8d 83 b3 ee ff ff    	lea    -0x114d(%ebx),%eax
  800138:	50                   	push   %eax
  800139:	e8 23 00 00 00       	call   800161 <_panic>

0080013e <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	57                   	push   %edi
  800142:	56                   	push   %esi
  800143:	53                   	push   %ebx
    asm volatile("int %1\n"
  800144:	ba 00 00 00 00       	mov    $0x0,%edx
  800149:	b8 02 00 00 00       	mov    $0x2,%eax
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	89 d3                	mov    %edx,%ebx
  800152:	89 d7                	mov    %edx,%edi
  800154:	89 d6                	mov    %edx,%esi
  800156:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800158:	5b                   	pop    %ebx
  800159:	5e                   	pop    %esi
  80015a:	5f                   	pop    %edi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    

0080015d <__x86.get_pc_thunk.ax>:
  80015d:	8b 04 24             	mov    (%esp),%eax
  800160:	c3                   	ret    

00800161 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	57                   	push   %edi
  800165:	56                   	push   %esi
  800166:	53                   	push   %ebx
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	e8 18 ff ff ff       	call   800087 <__x86.get_pc_thunk.bx>
  80016f:	81 c3 91 1e 00 00    	add    $0x1e91,%ebx
	va_list ap;

	va_start(ap, fmt);
  800175:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800178:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  80017e:	8b 38                	mov    (%eax),%edi
  800180:	e8 b9 ff ff ff       	call   80013e <sys_getenvid>
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	ff 75 0c             	pushl  0xc(%ebp)
  80018b:	ff 75 08             	pushl  0x8(%ebp)
  80018e:	57                   	push   %edi
  80018f:	50                   	push   %eax
  800190:	8d 83 c4 ee ff ff    	lea    -0x113c(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 d1 00 00 00       	call   80026d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80019c:	83 c4 18             	add    $0x18,%esp
  80019f:	56                   	push   %esi
  8001a0:	ff 75 10             	pushl  0x10(%ebp)
  8001a3:	e8 63 00 00 00       	call   80020b <vcprintf>
	cprintf("\n");
  8001a8:	8d 83 e8 ee ff ff    	lea    -0x1118(%ebx),%eax
  8001ae:	89 04 24             	mov    %eax,(%esp)
  8001b1:	e8 b7 00 00 00       	call   80026d <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b9:	cc                   	int3   
  8001ba:	eb fd                	jmp    8001b9 <_panic+0x58>

008001bc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	56                   	push   %esi
  8001c0:	53                   	push   %ebx
  8001c1:	e8 c1 fe ff ff       	call   800087 <__x86.get_pc_thunk.bx>
  8001c6:	81 c3 3a 1e 00 00    	add    $0x1e3a,%ebx
  8001cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001cf:	8b 16                	mov    (%esi),%edx
  8001d1:	8d 42 01             	lea    0x1(%edx),%eax
  8001d4:	89 06                	mov    %eax,(%esi)
  8001d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d9:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e2:	74 0b                	je     8001ef <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e4:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001eb:	5b                   	pop    %ebx
  8001ec:	5e                   	pop    %esi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	68 ff 00 00 00       	push   $0xff
  8001f7:	8d 46 08             	lea    0x8(%esi),%eax
  8001fa:	50                   	push   %eax
  8001fb:	e8 ac fe ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  800200:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	eb d9                	jmp    8001e4 <putch+0x28>

0080020b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	53                   	push   %ebx
  80020f:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800215:	e8 6d fe ff ff       	call   800087 <__x86.get_pc_thunk.bx>
  80021a:	81 c3 e6 1d 00 00    	add    $0x1de6,%ebx
	struct printbuf b;

	b.idx = 0;
  800220:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800227:	00 00 00 
	b.cnt = 0;
  80022a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800231:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800234:	ff 75 0c             	pushl  0xc(%ebp)
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800240:	50                   	push   %eax
  800241:	8d 83 bc e1 ff ff    	lea    -0x1e44(%ebx),%eax
  800247:	50                   	push   %eax
  800248:	e8 38 01 00 00       	call   800385 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	83 c4 08             	add    $0x8,%esp
  800250:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800256:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 4a fe ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800273:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800276:	50                   	push   %eax
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	e8 8c ff ff ff       	call   80020b <vcprintf>
	va_end(ap);

	return cnt;
}
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

00800281 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	57                   	push   %edi
  800285:	56                   	push   %esi
  800286:	53                   	push   %ebx
  800287:	83 ec 2c             	sub    $0x2c,%esp
  80028a:	e8 3a 06 00 00       	call   8008c9 <__x86.get_pc_thunk.cx>
  80028f:	81 c1 71 1d 00 00    	add    $0x1d71,%ecx
  800295:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800298:	89 c7                	mov    %eax,%edi
  80029a:	89 d6                	mov    %edx,%esi
  80029c:	8b 45 08             	mov    0x8(%ebp),%eax
  80029f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002b3:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002b6:	39 d3                	cmp    %edx,%ebx
  8002b8:	72 09                	jb     8002c3 <printnum+0x42>
  8002ba:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002bd:	0f 87 83 00 00 00    	ja     800346 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	ff 75 18             	pushl  0x18(%ebp)
  8002c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002cf:	53                   	push   %ebx
  8002d0:	ff 75 10             	pushl  0x10(%ebp)
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002dc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002df:	ff 75 d0             	pushl  -0x30(%ebp)
  8002e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002e5:	e8 66 09 00 00       	call   800c50 <__udivdi3>
  8002ea:	83 c4 18             	add    $0x18,%esp
  8002ed:	52                   	push   %edx
  8002ee:	50                   	push   %eax
  8002ef:	89 f2                	mov    %esi,%edx
  8002f1:	89 f8                	mov    %edi,%eax
  8002f3:	e8 89 ff ff ff       	call   800281 <printnum>
  8002f8:	83 c4 20             	add    $0x20,%esp
  8002fb:	eb 13                	jmp    800310 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	56                   	push   %esi
  800301:	ff 75 18             	pushl  0x18(%ebp)
  800304:	ff d7                	call   *%edi
  800306:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800309:	83 eb 01             	sub    $0x1,%ebx
  80030c:	85 db                	test   %ebx,%ebx
  80030e:	7f ed                	jg     8002fd <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	56                   	push   %esi
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	ff 75 dc             	pushl  -0x24(%ebp)
  80031a:	ff 75 d8             	pushl  -0x28(%ebp)
  80031d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800320:	ff 75 d0             	pushl  -0x30(%ebp)
  800323:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800326:	89 f3                	mov    %esi,%ebx
  800328:	e8 43 0a 00 00       	call   800d70 <__umoddi3>
  80032d:	83 c4 14             	add    $0x14,%esp
  800330:	0f be 84 06 ea ee ff 	movsbl -0x1116(%esi,%eax,1),%eax
  800337:	ff 
  800338:	50                   	push   %eax
  800339:	ff d7                	call   *%edi
}
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    
  800346:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800349:	eb be                	jmp    800309 <printnum+0x88>

0080034b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800351:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800355:	8b 10                	mov    (%eax),%edx
  800357:	3b 50 04             	cmp    0x4(%eax),%edx
  80035a:	73 0a                	jae    800366 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035f:	89 08                	mov    %ecx,(%eax)
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	88 02                	mov    %al,(%edx)
}
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <printfmt>:
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800371:	50                   	push   %eax
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	ff 75 0c             	pushl  0xc(%ebp)
  800378:	ff 75 08             	pushl  0x8(%ebp)
  80037b:	e8 05 00 00 00       	call   800385 <vprintfmt>
}
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <vprintfmt>:
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	57                   	push   %edi
  800389:	56                   	push   %esi
  80038a:	53                   	push   %ebx
  80038b:	83 ec 2c             	sub    $0x2c,%esp
  80038e:	e8 f4 fc ff ff       	call   800087 <__x86.get_pc_thunk.bx>
  800393:	81 c3 6d 1c 00 00    	add    $0x1c6d,%ebx
  800399:	8b 75 0c             	mov    0xc(%ebp),%esi
  80039c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039f:	e9 fb 03 00 00       	jmp    80079f <.L35+0x48>
		padc = ' ';
  8003a4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003a8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003af:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c2:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8d 47 01             	lea    0x1(%edi),%eax
  8003c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cb:	0f b6 17             	movzbl (%edi),%edx
  8003ce:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d1:	3c 55                	cmp    $0x55,%al
  8003d3:	0f 87 4e 04 00 00    	ja     800827 <.L22>
  8003d9:	0f b6 c0             	movzbl %al,%eax
  8003dc:	89 d9                	mov    %ebx,%ecx
  8003de:	03 8c 83 78 ef ff ff 	add    -0x1088(%ebx,%eax,4),%ecx
  8003e5:	ff e1                	jmp    *%ecx

008003e7 <.L71>:
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ea:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003ee:	eb d5                	jmp    8003c5 <vprintfmt+0x40>

008003f0 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f7:	eb cc                	jmp    8003c5 <vprintfmt+0x40>

008003f9 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	0f b6 d2             	movzbl %dl,%edx
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ff:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800404:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800407:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80040b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800411:	83 f9 09             	cmp    $0x9,%ecx
  800414:	77 55                	ja     80046b <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800416:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800419:	eb e9                	jmp    800404 <.L29+0xb>

0080041b <.L26>:
			precision = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 40 04             	lea    0x4(%eax),%eax
  800429:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800433:	79 90                	jns    8003c5 <vprintfmt+0x40>
				width = precision, precision = -1;
  800435:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043b:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800442:	eb 81                	jmp    8003c5 <vprintfmt+0x40>

00800444 <.L27>:
  800444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800447:	85 c0                	test   %eax,%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	0f 49 d0             	cmovns %eax,%edx
  800451:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800457:	e9 69 ff ff ff       	jmp    8003c5 <vprintfmt+0x40>

0080045c <.L23>:
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800466:	e9 5a ff ff ff       	jmp    8003c5 <vprintfmt+0x40>
  80046b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80046e:	eb bf                	jmp    80042f <.L26+0x14>

00800470 <.L33>:
			lflag++;
  800470:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800477:	e9 49 ff ff ff       	jmp    8003c5 <vprintfmt+0x40>

0080047c <.L30>:
			putch(va_arg(ap, int), putdat);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	56                   	push   %esi
  800486:	ff 30                	pushl  (%eax)
  800488:	ff 55 08             	call   *0x8(%ebp)
			break;
  80048b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800491:	e9 06 03 00 00       	jmp    80079c <.L35+0x45>

00800496 <.L32>:
			err = va_arg(ap, int);
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8d 78 04             	lea    0x4(%eax),%edi
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	99                   	cltd   
  80049f:	31 d0                	xor    %edx,%eax
  8004a1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a3:	83 f8 06             	cmp    $0x6,%eax
  8004a6:	7f 27                	jg     8004cf <.L32+0x39>
  8004a8:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8004af:	85 d2                	test   %edx,%edx
  8004b1:	74 1c                	je     8004cf <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004b3:	52                   	push   %edx
  8004b4:	8d 83 0b ef ff ff    	lea    -0x10f5(%ebx),%eax
  8004ba:	50                   	push   %eax
  8004bb:	56                   	push   %esi
  8004bc:	ff 75 08             	pushl  0x8(%ebp)
  8004bf:	e8 a4 fe ff ff       	call   800368 <printfmt>
  8004c4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ca:	e9 cd 02 00 00       	jmp    80079c <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004cf:	50                   	push   %eax
  8004d0:	8d 83 02 ef ff ff    	lea    -0x10fe(%ebx),%eax
  8004d6:	50                   	push   %eax
  8004d7:	56                   	push   %esi
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	e8 88 fe ff ff       	call   800368 <printfmt>
  8004e0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004e6:	e9 b1 02 00 00       	jmp    80079c <.L35+0x45>

008004eb <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	83 c0 04             	add    $0x4,%eax
  8004f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004f9:	85 ff                	test   %edi,%edi
  8004fb:	8d 83 fb ee ff ff    	lea    -0x1105(%ebx),%eax
  800501:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800504:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800508:	0f 8e b5 00 00 00    	jle    8005c3 <.L36+0xd8>
  80050e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800512:	75 08                	jne    80051c <.L36+0x31>
  800514:	89 75 0c             	mov    %esi,0xc(%ebp)
  800517:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80051a:	eb 6d                	jmp    800589 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	ff 75 cc             	pushl  -0x34(%ebp)
  800522:	57                   	push   %edi
  800523:	e8 bd 03 00 00       	call   8008e5 <strnlen>
  800528:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052b:	29 c2                	sub    %eax,%edx
  80052d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800530:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800533:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80053d:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053f:	eb 10                	jmp    800551 <.L36+0x66>
					putch(padc, putdat);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	56                   	push   %esi
  800545:	ff 75 e0             	pushl  -0x20(%ebp)
  800548:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ec                	jg     800541 <.L36+0x56>
  800555:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800558:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80055b:	85 d2                	test   %edx,%edx
  80055d:	b8 00 00 00 00       	mov    $0x0,%eax
  800562:	0f 49 c2             	cmovns %edx,%eax
  800565:	29 c2                	sub    %eax,%edx
  800567:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80056a:	89 75 0c             	mov    %esi,0xc(%ebp)
  80056d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800570:	eb 17                	jmp    800589 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800572:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800576:	75 30                	jne    8005a8 <.L36+0xbd>
					putch(ch, putdat);
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	50                   	push   %eax
  80057f:	ff 55 08             	call   *0x8(%ebp)
  800582:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800585:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800589:	83 c7 01             	add    $0x1,%edi
  80058c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800590:	0f be c2             	movsbl %dl,%eax
  800593:	85 c0                	test   %eax,%eax
  800595:	74 52                	je     8005e9 <.L36+0xfe>
  800597:	85 f6                	test   %esi,%esi
  800599:	78 d7                	js     800572 <.L36+0x87>
  80059b:	83 ee 01             	sub    $0x1,%esi
  80059e:	79 d2                	jns    800572 <.L36+0x87>
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005a6:	eb 32                	jmp    8005da <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a8:	0f be d2             	movsbl %dl,%edx
  8005ab:	83 ea 20             	sub    $0x20,%edx
  8005ae:	83 fa 5e             	cmp    $0x5e,%edx
  8005b1:	76 c5                	jbe    800578 <.L36+0x8d>
					putch('?', putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	6a 3f                	push   $0x3f
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	eb c2                	jmp    800585 <.L36+0x9a>
  8005c3:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005c6:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005c9:	eb be                	jmp    800589 <.L36+0x9e>
				putch(' ', putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	56                   	push   %esi
  8005cf:	6a 20                	push   $0x20
  8005d1:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005d4:	83 ef 01             	sub    $0x1,%edi
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	85 ff                	test   %edi,%edi
  8005dc:	7f ed                	jg     8005cb <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e4:	e9 b3 01 00 00       	jmp    80079c <.L35+0x45>
  8005e9:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005ef:	eb e9                	jmp    8005da <.L36+0xef>

008005f1 <.L31>:
  8005f1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005f4:	83 f9 01             	cmp    $0x1,%ecx
  8005f7:	7e 40                	jle    800639 <.L31+0x48>
		return va_arg(*ap, long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 50 04             	mov    0x4(%eax),%edx
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 40 08             	lea    0x8(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800610:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800614:	79 55                	jns    80066b <.L31+0x7a>
				putch('-', putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	56                   	push   %esi
  80061a:	6a 2d                	push   $0x2d
  80061c:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80061f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800622:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800625:	f7 da                	neg    %edx
  800627:	83 d1 00             	adc    $0x0,%ecx
  80062a:	f7 d9                	neg    %ecx
  80062c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	e9 48 01 00 00       	jmp    800781 <.L35+0x2a>
	else if (lflag)
  800639:	85 c9                	test   %ecx,%ecx
  80063b:	75 17                	jne    800654 <.L31+0x63>
		return va_arg(*ap, int);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	99                   	cltd   
  800646:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb bc                	jmp    800610 <.L31+0x1f>
		return va_arg(*ap, long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	99                   	cltd   
  80065d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
  800669:	eb a5                	jmp    800610 <.L31+0x1f>
			num = getint(&ap, lflag);
  80066b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800671:	b8 0a 00 00 00       	mov    $0xa,%eax
  800676:	e9 06 01 00 00       	jmp    800781 <.L35+0x2a>

0080067b <.L37>:
  80067b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80067e:	83 f9 01             	cmp    $0x1,%ecx
  800681:	7e 18                	jle    80069b <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	8b 48 04             	mov    0x4(%eax),%ecx
  80068b:	8d 40 08             	lea    0x8(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800691:	b8 0a 00 00 00       	mov    $0xa,%eax
  800696:	e9 e6 00 00 00       	jmp    800781 <.L35+0x2a>
	else if (lflag)
  80069b:	85 c9                	test   %ecx,%ecx
  80069d:	75 1a                	jne    8006b9 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 10                	mov    (%eax),%edx
  8006a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b4:	e9 c8 00 00 00       	jmp    800781 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c3:	8d 40 04             	lea    0x4(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	e9 ae 00 00 00       	jmp    800781 <.L35+0x2a>

008006d3 <.L34>:
  8006d3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006d6:	83 f9 01             	cmp    $0x1,%ecx
  8006d9:	7e 3d                	jle    800718 <.L34+0x45>
		return va_arg(*ap, long long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 50 04             	mov    0x4(%eax),%edx
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8006f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f6:	79 52                	jns    80074a <.L34+0x77>
                putch('-', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	56                   	push   %esi
  8006fc:	6a 2d                	push   $0x2d
  8006fe:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800701:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800704:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800707:	f7 da                	neg    %edx
  800709:	83 d1 00             	adc    $0x0,%ecx
  80070c:	f7 d9                	neg    %ecx
  80070e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800711:	b8 08 00 00 00       	mov    $0x8,%eax
  800716:	eb 69                	jmp    800781 <.L35+0x2a>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	75 17                	jne    800733 <.L34+0x60>
		return va_arg(*ap, int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	99                   	cltd   
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	eb bf                	jmp    8006f2 <.L34+0x1f>
		return va_arg(*ap, long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	99                   	cltd   
  80073c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 40 04             	lea    0x4(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
  800748:	eb a8                	jmp    8006f2 <.L34+0x1f>
            num = getint(&ap, lflag);
  80074a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80074d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800750:	b8 08 00 00 00       	mov    $0x8,%eax
  800755:	eb 2a                	jmp    800781 <.L35+0x2a>

00800757 <.L35>:
			putch('0', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	56                   	push   %esi
  80075b:	6a 30                	push   $0x30
  80075d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800760:	83 c4 08             	add    $0x8,%esp
  800763:	56                   	push   %esi
  800764:	6a 78                	push   $0x78
  800766:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 10                	mov    (%eax),%edx
  80076e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800773:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800776:	8d 40 04             	lea    0x4(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800781:	83 ec 0c             	sub    $0xc,%esp
  800784:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800788:	57                   	push   %edi
  800789:	ff 75 e0             	pushl  -0x20(%ebp)
  80078c:	50                   	push   %eax
  80078d:	51                   	push   %ecx
  80078e:	52                   	push   %edx
  80078f:	89 f2                	mov    %esi,%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	e8 e8 fa ff ff       	call   800281 <printnum>
			break;
  800799:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079f:	83 c7 01             	add    $0x1,%edi
  8007a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a6:	83 f8 25             	cmp    $0x25,%eax
  8007a9:	0f 84 f5 fb ff ff    	je     8003a4 <vprintfmt+0x1f>
			if (ch == '\0')
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	0f 84 91 00 00 00    	je     800848 <.L22+0x21>
			putch(ch, putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	56                   	push   %esi
  8007bb:	50                   	push   %eax
  8007bc:	ff 55 08             	call   *0x8(%ebp)
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	eb db                	jmp    80079f <.L35+0x48>

008007c4 <.L38>:
  8007c4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007c7:	83 f9 01             	cmp    $0x1,%ecx
  8007ca:	7e 15                	jle    8007e1 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 10                	mov    (%eax),%edx
  8007d1:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d4:	8d 40 08             	lea    0x8(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007da:	b8 10 00 00 00       	mov    $0x10,%eax
  8007df:	eb a0                	jmp    800781 <.L35+0x2a>
	else if (lflag)
  8007e1:	85 c9                	test   %ecx,%ecx
  8007e3:	75 17                	jne    8007fc <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 10                	mov    (%eax),%edx
  8007ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ef:	8d 40 04             	lea    0x4(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fa:	eb 85                	jmp    800781 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	b9 00 00 00 00       	mov    $0x0,%ecx
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
  800811:	e9 6b ff ff ff       	jmp    800781 <.L35+0x2a>

00800816 <.L25>:
			putch(ch, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	56                   	push   %esi
  80081a:	6a 25                	push   $0x25
  80081c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	e9 75 ff ff ff       	jmp    80079c <.L35+0x45>

00800827 <.L22>:
			putch('%', putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	56                   	push   %esi
  80082b:	6a 25                	push   $0x25
  80082d:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	89 f8                	mov    %edi,%eax
  800835:	eb 03                	jmp    80083a <.L22+0x13>
  800837:	83 e8 01             	sub    $0x1,%eax
  80083a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083e:	75 f7                	jne    800837 <.L22+0x10>
  800840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800843:	e9 54 ff ff ff       	jmp    80079c <.L35+0x45>
}
  800848:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80084b:	5b                   	pop    %ebx
  80084c:	5e                   	pop    %esi
  80084d:	5f                   	pop    %edi
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    

00800850 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	53                   	push   %ebx
  800854:	83 ec 14             	sub    $0x14,%esp
  800857:	e8 2b f8 ff ff       	call   800087 <__x86.get_pc_thunk.bx>
  80085c:	81 c3 a4 17 00 00    	add    $0x17a4,%ebx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800872:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800879:	85 c0                	test   %eax,%eax
  80087b:	74 2b                	je     8008a8 <vsnprintf+0x58>
  80087d:	85 d2                	test   %edx,%edx
  80087f:	7e 27                	jle    8008a8 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800881:	ff 75 14             	pushl  0x14(%ebp)
  800884:	ff 75 10             	pushl  0x10(%ebp)
  800887:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088a:	50                   	push   %eax
  80088b:	8d 83 4b e3 ff ff    	lea    -0x1cb5(%ebx),%eax
  800891:	50                   	push   %eax
  800892:	e8 ee fa ff ff       	call   800385 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80089d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
}
  8008a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    
		return -E_INVAL;
  8008a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ad:	eb f4                	jmp    8008a3 <vsnprintf+0x53>

008008af <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b8:	50                   	push   %eax
  8008b9:	ff 75 10             	pushl  0x10(%ebp)
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 89 ff ff ff       	call   800850 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <__x86.get_pc_thunk.cx>:
  8008c9:	8b 0c 24             	mov    (%esp),%ecx
  8008cc:	c3                   	ret    

008008cd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d8:	eb 03                	jmp    8008dd <strlen+0x10>
		n++;
  8008da:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008dd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e1:	75 f7                	jne    8008da <strlen+0xd>
	return n;
}
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	eb 03                	jmp    8008f8 <strnlen+0x13>
		n++;
  8008f5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f8:	39 d0                	cmp    %edx,%eax
  8008fa:	74 06                	je     800902 <strnlen+0x1d>
  8008fc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800900:	75 f3                	jne    8008f5 <strnlen+0x10>
	return n;
}
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	53                   	push   %ebx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80090e:	89 c2                	mov    %eax,%edx
  800910:	83 c1 01             	add    $0x1,%ecx
  800913:	83 c2 01             	add    $0x1,%edx
  800916:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80091a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80091d:	84 db                	test   %bl,%bl
  80091f:	75 ef                	jne    800910 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800921:	5b                   	pop    %ebx
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	53                   	push   %ebx
  800928:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092b:	53                   	push   %ebx
  80092c:	e8 9c ff ff ff       	call   8008cd <strlen>
  800931:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	01 d8                	add    %ebx,%eax
  800939:	50                   	push   %eax
  80093a:	e8 c5 ff ff ff       	call   800904 <strcpy>
	return dst;
}
  80093f:	89 d8                	mov    %ebx,%eax
  800941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 75 08             	mov    0x8(%ebp),%esi
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800951:	89 f3                	mov    %esi,%ebx
  800953:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800956:	89 f2                	mov    %esi,%edx
  800958:	eb 0f                	jmp    800969 <strncpy+0x23>
		*dst++ = *src;
  80095a:	83 c2 01             	add    $0x1,%edx
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800963:	80 39 01             	cmpb   $0x1,(%ecx)
  800966:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800969:	39 da                	cmp    %ebx,%edx
  80096b:	75 ed                	jne    80095a <strncpy+0x14>
	}
	return ret;
}
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	5b                   	pop    %ebx
  800970:	5e                   	pop    %esi
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	56                   	push   %esi
  800977:	53                   	push   %ebx
  800978:	8b 75 08             	mov    0x8(%ebp),%esi
  80097b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800981:	89 f0                	mov    %esi,%eax
  800983:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800987:	85 c9                	test   %ecx,%ecx
  800989:	75 0b                	jne    800996 <strlcpy+0x23>
  80098b:	eb 17                	jmp    8009a4 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80098d:	83 c2 01             	add    $0x1,%edx
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800996:	39 d8                	cmp    %ebx,%eax
  800998:	74 07                	je     8009a1 <strlcpy+0x2e>
  80099a:	0f b6 0a             	movzbl (%edx),%ecx
  80099d:	84 c9                	test   %cl,%cl
  80099f:	75 ec                	jne    80098d <strlcpy+0x1a>
		*dst = '\0';
  8009a1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a4:	29 f0                	sub    %esi,%eax
}
  8009a6:	5b                   	pop    %ebx
  8009a7:	5e                   	pop    %esi
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b3:	eb 06                	jmp    8009bb <strcmp+0x11>
		p++, q++;
  8009b5:	83 c1 01             	add    $0x1,%ecx
  8009b8:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009bb:	0f b6 01             	movzbl (%ecx),%eax
  8009be:	84 c0                	test   %al,%al
  8009c0:	74 04                	je     8009c6 <strcmp+0x1c>
  8009c2:	3a 02                	cmp    (%edx),%al
  8009c4:	74 ef                	je     8009b5 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c6:	0f b6 c0             	movzbl %al,%eax
  8009c9:	0f b6 12             	movzbl (%edx),%edx
  8009cc:	29 d0                	sub    %edx,%eax
}
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	53                   	push   %ebx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009da:	89 c3                	mov    %eax,%ebx
  8009dc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009df:	eb 06                	jmp    8009e7 <strncmp+0x17>
		n--, p++, q++;
  8009e1:	83 c0 01             	add    $0x1,%eax
  8009e4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e7:	39 d8                	cmp    %ebx,%eax
  8009e9:	74 16                	je     800a01 <strncmp+0x31>
  8009eb:	0f b6 08             	movzbl (%eax),%ecx
  8009ee:	84 c9                	test   %cl,%cl
  8009f0:	74 04                	je     8009f6 <strncmp+0x26>
  8009f2:	3a 0a                	cmp    (%edx),%cl
  8009f4:	74 eb                	je     8009e1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f6:	0f b6 00             	movzbl (%eax),%eax
  8009f9:	0f b6 12             	movzbl (%edx),%edx
  8009fc:	29 d0                	sub    %edx,%eax
}
  8009fe:	5b                   	pop    %ebx
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    
		return 0;
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
  800a06:	eb f6                	jmp    8009fe <strncmp+0x2e>

00800a08 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a12:	0f b6 10             	movzbl (%eax),%edx
  800a15:	84 d2                	test   %dl,%dl
  800a17:	74 09                	je     800a22 <strchr+0x1a>
		if (*s == c)
  800a19:	38 ca                	cmp    %cl,%dl
  800a1b:	74 0a                	je     800a27 <strchr+0x1f>
	for (; *s; s++)
  800a1d:	83 c0 01             	add    $0x1,%eax
  800a20:	eb f0                	jmp    800a12 <strchr+0xa>
			return (char *) s;
	return 0;
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a33:	eb 03                	jmp    800a38 <strfind+0xf>
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a3b:	38 ca                	cmp    %cl,%dl
  800a3d:	74 04                	je     800a43 <strfind+0x1a>
  800a3f:	84 d2                	test   %dl,%dl
  800a41:	75 f2                	jne    800a35 <strfind+0xc>
			break;
	return (char *) s;
}
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	57                   	push   %edi
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a51:	85 c9                	test   %ecx,%ecx
  800a53:	74 13                	je     800a68 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a55:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5b:	75 05                	jne    800a62 <memset+0x1d>
  800a5d:	f6 c1 03             	test   $0x3,%cl
  800a60:	74 0d                	je     800a6f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	fc                   	cld    
  800a66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a68:	89 f8                	mov    %edi,%eax
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5f                   	pop    %edi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    
		c &= 0xFF;
  800a6f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a73:	89 d3                	mov    %edx,%ebx
  800a75:	c1 e3 08             	shl    $0x8,%ebx
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	c1 e0 18             	shl    $0x18,%eax
  800a7d:	89 d6                	mov    %edx,%esi
  800a7f:	c1 e6 10             	shl    $0x10,%esi
  800a82:	09 f0                	or     %esi,%eax
  800a84:	09 c2                	or     %eax,%edx
  800a86:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a88:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	fc                   	cld    
  800a8e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a90:	eb d6                	jmp    800a68 <memset+0x23>

00800a92 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	57                   	push   %edi
  800a96:	56                   	push   %esi
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa0:	39 c6                	cmp    %eax,%esi
  800aa2:	73 35                	jae    800ad9 <memmove+0x47>
  800aa4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa7:	39 c2                	cmp    %eax,%edx
  800aa9:	76 2e                	jbe    800ad9 <memmove+0x47>
		s += n;
		d += n;
  800aab:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aae:	89 d6                	mov    %edx,%esi
  800ab0:	09 fe                	or     %edi,%esi
  800ab2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab8:	74 0c                	je     800ac6 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aba:	83 ef 01             	sub    $0x1,%edi
  800abd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac0:	fd                   	std    
  800ac1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac3:	fc                   	cld    
  800ac4:	eb 21                	jmp    800ae7 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac6:	f6 c1 03             	test   $0x3,%cl
  800ac9:	75 ef                	jne    800aba <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800acb:	83 ef 04             	sub    $0x4,%edi
  800ace:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad4:	fd                   	std    
  800ad5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad7:	eb ea                	jmp    800ac3 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad9:	89 f2                	mov    %esi,%edx
  800adb:	09 c2                	or     %eax,%edx
  800add:	f6 c2 03             	test   $0x3,%dl
  800ae0:	74 09                	je     800aeb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae2:	89 c7                	mov    %eax,%edi
  800ae4:	fc                   	cld    
  800ae5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae7:	5e                   	pop    %esi
  800ae8:	5f                   	pop    %edi
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aeb:	f6 c1 03             	test   $0x3,%cl
  800aee:	75 f2                	jne    800ae2 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af3:	89 c7                	mov    %eax,%edi
  800af5:	fc                   	cld    
  800af6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af8:	eb ed                	jmp    800ae7 <memmove+0x55>

00800afa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800afd:	ff 75 10             	pushl  0x10(%ebp)
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 87 ff ff ff       	call   800a92 <memmove>
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b18:	89 c6                	mov    %eax,%esi
  800b1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1d:	39 f0                	cmp    %esi,%eax
  800b1f:	74 1c                	je     800b3d <memcmp+0x30>
		if (*s1 != *s2)
  800b21:	0f b6 08             	movzbl (%eax),%ecx
  800b24:	0f b6 1a             	movzbl (%edx),%ebx
  800b27:	38 d9                	cmp    %bl,%cl
  800b29:	75 08                	jne    800b33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	eb ea                	jmp    800b1d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b33:	0f b6 c1             	movzbl %cl,%eax
  800b36:	0f b6 db             	movzbl %bl,%ebx
  800b39:	29 d8                	sub    %ebx,%eax
  800b3b:	eb 05                	jmp    800b42 <memcmp+0x35>
	}

	return 0;
  800b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4f:	89 c2                	mov    %eax,%edx
  800b51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b54:	39 d0                	cmp    %edx,%eax
  800b56:	73 09                	jae    800b61 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b58:	38 08                	cmp    %cl,(%eax)
  800b5a:	74 05                	je     800b61 <memfind+0x1b>
	for (; s < ends; s++)
  800b5c:	83 c0 01             	add    $0x1,%eax
  800b5f:	eb f3                	jmp    800b54 <memfind+0xe>
			break;
	return (void *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6f:	eb 03                	jmp    800b74 <strtol+0x11>
		s++;
  800b71:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b74:	0f b6 01             	movzbl (%ecx),%eax
  800b77:	3c 20                	cmp    $0x20,%al
  800b79:	74 f6                	je     800b71 <strtol+0xe>
  800b7b:	3c 09                	cmp    $0x9,%al
  800b7d:	74 f2                	je     800b71 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b7f:	3c 2b                	cmp    $0x2b,%al
  800b81:	74 2e                	je     800bb1 <strtol+0x4e>
	int neg = 0;
  800b83:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b88:	3c 2d                	cmp    $0x2d,%al
  800b8a:	74 2f                	je     800bbb <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b92:	75 05                	jne    800b99 <strtol+0x36>
  800b94:	80 39 30             	cmpb   $0x30,(%ecx)
  800b97:	74 2c                	je     800bc5 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b99:	85 db                	test   %ebx,%ebx
  800b9b:	75 0a                	jne    800ba7 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ba2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba5:	74 28                	je     800bcf <strtol+0x6c>
		base = 10;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800baf:	eb 50                	jmp    800c01 <strtol+0x9e>
		s++;
  800bb1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb9:	eb d1                	jmp    800b8c <strtol+0x29>
		s++, neg = 1;
  800bbb:	83 c1 01             	add    $0x1,%ecx
  800bbe:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc3:	eb c7                	jmp    800b8c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc9:	74 0e                	je     800bd9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bcb:	85 db                	test   %ebx,%ebx
  800bcd:	75 d8                	jne    800ba7 <strtol+0x44>
		s++, base = 8;
  800bcf:	83 c1 01             	add    $0x1,%ecx
  800bd2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd7:	eb ce                	jmp    800ba7 <strtol+0x44>
		s += 2, base = 16;
  800bd9:	83 c1 02             	add    $0x2,%ecx
  800bdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be1:	eb c4                	jmp    800ba7 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be6:	89 f3                	mov    %esi,%ebx
  800be8:	80 fb 19             	cmp    $0x19,%bl
  800beb:	77 29                	ja     800c16 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bed:	0f be d2             	movsbl %dl,%edx
  800bf0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf6:	7d 30                	jge    800c28 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bff:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c01:	0f b6 11             	movzbl (%ecx),%edx
  800c04:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 09             	cmp    $0x9,%bl
  800c0c:	77 d5                	ja     800be3 <strtol+0x80>
			dig = *s - '0';
  800c0e:	0f be d2             	movsbl %dl,%edx
  800c11:	83 ea 30             	sub    $0x30,%edx
  800c14:	eb dd                	jmp    800bf3 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c16:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c19:	89 f3                	mov    %esi,%ebx
  800c1b:	80 fb 19             	cmp    $0x19,%bl
  800c1e:	77 08                	ja     800c28 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c20:	0f be d2             	movsbl %dl,%edx
  800c23:	83 ea 37             	sub    $0x37,%edx
  800c26:	eb cb                	jmp    800bf3 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2c:	74 05                	je     800c33 <strtol+0xd0>
		*endptr = (char *) s;
  800c2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c31:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c33:	89 c2                	mov    %eax,%edx
  800c35:	f7 da                	neg    %edx
  800c37:	85 ff                	test   %edi,%edi
  800c39:	0f 45 c2             	cmovne %edx,%eax
}
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5f                   	pop    %edi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    
  800c41:	66 90                	xchg   %ax,%ax
  800c43:	66 90                	xchg   %ax,%ax
  800c45:	66 90                	xchg   %ax,%ax
  800c47:	66 90                	xchg   %ax,%ax
  800c49:	66 90                	xchg   %ax,%ax
  800c4b:	66 90                	xchg   %ax,%ax
  800c4d:	66 90                	xchg   %ax,%ax
  800c4f:	90                   	nop

00800c50 <__udivdi3>:
  800c50:	55                   	push   %ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 1c             	sub    $0x1c,%esp
  800c57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800c5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800c5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800c63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800c67:	85 d2                	test   %edx,%edx
  800c69:	75 35                	jne    800ca0 <__udivdi3+0x50>
  800c6b:	39 f3                	cmp    %esi,%ebx
  800c6d:	0f 87 bd 00 00 00    	ja     800d30 <__udivdi3+0xe0>
  800c73:	85 db                	test   %ebx,%ebx
  800c75:	89 d9                	mov    %ebx,%ecx
  800c77:	75 0b                	jne    800c84 <__udivdi3+0x34>
  800c79:	b8 01 00 00 00       	mov    $0x1,%eax
  800c7e:	31 d2                	xor    %edx,%edx
  800c80:	f7 f3                	div    %ebx
  800c82:	89 c1                	mov    %eax,%ecx
  800c84:	31 d2                	xor    %edx,%edx
  800c86:	89 f0                	mov    %esi,%eax
  800c88:	f7 f1                	div    %ecx
  800c8a:	89 c6                	mov    %eax,%esi
  800c8c:	89 e8                	mov    %ebp,%eax
  800c8e:	89 f7                	mov    %esi,%edi
  800c90:	f7 f1                	div    %ecx
  800c92:	89 fa                	mov    %edi,%edx
  800c94:	83 c4 1c             	add    $0x1c,%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
  800c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ca0:	39 f2                	cmp    %esi,%edx
  800ca2:	77 7c                	ja     800d20 <__udivdi3+0xd0>
  800ca4:	0f bd fa             	bsr    %edx,%edi
  800ca7:	83 f7 1f             	xor    $0x1f,%edi
  800caa:	0f 84 98 00 00 00    	je     800d48 <__udivdi3+0xf8>
  800cb0:	89 f9                	mov    %edi,%ecx
  800cb2:	b8 20 00 00 00       	mov    $0x20,%eax
  800cb7:	29 f8                	sub    %edi,%eax
  800cb9:	d3 e2                	shl    %cl,%edx
  800cbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800cbf:	89 c1                	mov    %eax,%ecx
  800cc1:	89 da                	mov    %ebx,%edx
  800cc3:	d3 ea                	shr    %cl,%edx
  800cc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800cc9:	09 d1                	or     %edx,%ecx
  800ccb:	89 f2                	mov    %esi,%edx
  800ccd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cd1:	89 f9                	mov    %edi,%ecx
  800cd3:	d3 e3                	shl    %cl,%ebx
  800cd5:	89 c1                	mov    %eax,%ecx
  800cd7:	d3 ea                	shr    %cl,%edx
  800cd9:	89 f9                	mov    %edi,%ecx
  800cdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cdf:	d3 e6                	shl    %cl,%esi
  800ce1:	89 eb                	mov    %ebp,%ebx
  800ce3:	89 c1                	mov    %eax,%ecx
  800ce5:	d3 eb                	shr    %cl,%ebx
  800ce7:	09 de                	or     %ebx,%esi
  800ce9:	89 f0                	mov    %esi,%eax
  800ceb:	f7 74 24 08          	divl   0x8(%esp)
  800cef:	89 d6                	mov    %edx,%esi
  800cf1:	89 c3                	mov    %eax,%ebx
  800cf3:	f7 64 24 0c          	mull   0xc(%esp)
  800cf7:	39 d6                	cmp    %edx,%esi
  800cf9:	72 0c                	jb     800d07 <__udivdi3+0xb7>
  800cfb:	89 f9                	mov    %edi,%ecx
  800cfd:	d3 e5                	shl    %cl,%ebp
  800cff:	39 c5                	cmp    %eax,%ebp
  800d01:	73 5d                	jae    800d60 <__udivdi3+0x110>
  800d03:	39 d6                	cmp    %edx,%esi
  800d05:	75 59                	jne    800d60 <__udivdi3+0x110>
  800d07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d0a:	31 ff                	xor    %edi,%edi
  800d0c:	89 fa                	mov    %edi,%edx
  800d0e:	83 c4 1c             	add    $0x1c,%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    
  800d16:	8d 76 00             	lea    0x0(%esi),%esi
  800d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800d20:	31 ff                	xor    %edi,%edi
  800d22:	31 c0                	xor    %eax,%eax
  800d24:	89 fa                	mov    %edi,%edx
  800d26:	83 c4 1c             	add    $0x1c,%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
  800d2e:	66 90                	xchg   %ax,%ax
  800d30:	31 ff                	xor    %edi,%edi
  800d32:	89 e8                	mov    %ebp,%eax
  800d34:	89 f2                	mov    %esi,%edx
  800d36:	f7 f3                	div    %ebx
  800d38:	89 fa                	mov    %edi,%edx
  800d3a:	83 c4 1c             	add    $0x1c,%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
  800d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d48:	39 f2                	cmp    %esi,%edx
  800d4a:	72 06                	jb     800d52 <__udivdi3+0x102>
  800d4c:	31 c0                	xor    %eax,%eax
  800d4e:	39 eb                	cmp    %ebp,%ebx
  800d50:	77 d2                	ja     800d24 <__udivdi3+0xd4>
  800d52:	b8 01 00 00 00       	mov    $0x1,%eax
  800d57:	eb cb                	jmp    800d24 <__udivdi3+0xd4>
  800d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d60:	89 d8                	mov    %ebx,%eax
  800d62:	31 ff                	xor    %edi,%edi
  800d64:	eb be                	jmp    800d24 <__udivdi3+0xd4>
  800d66:	66 90                	xchg   %ax,%ax
  800d68:	66 90                	xchg   %ax,%ax
  800d6a:	66 90                	xchg   %ax,%ax
  800d6c:	66 90                	xchg   %ax,%ax
  800d6e:	66 90                	xchg   %ax,%ax

00800d70 <__umoddi3>:
  800d70:	55                   	push   %ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 1c             	sub    $0x1c,%esp
  800d77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800d7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800d7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800d83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800d87:	85 ed                	test   %ebp,%ebp
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	89 da                	mov    %ebx,%edx
  800d8d:	75 19                	jne    800da8 <__umoddi3+0x38>
  800d8f:	39 df                	cmp    %ebx,%edi
  800d91:	0f 86 b1 00 00 00    	jbe    800e48 <__umoddi3+0xd8>
  800d97:	f7 f7                	div    %edi
  800d99:	89 d0                	mov    %edx,%eax
  800d9b:	31 d2                	xor    %edx,%edx
  800d9d:	83 c4 1c             	add    $0x1c,%esp
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    
  800da5:	8d 76 00             	lea    0x0(%esi),%esi
  800da8:	39 dd                	cmp    %ebx,%ebp
  800daa:	77 f1                	ja     800d9d <__umoddi3+0x2d>
  800dac:	0f bd cd             	bsr    %ebp,%ecx
  800daf:	83 f1 1f             	xor    $0x1f,%ecx
  800db2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800db6:	0f 84 b4 00 00 00    	je     800e70 <__umoddi3+0x100>
  800dbc:	b8 20 00 00 00       	mov    $0x20,%eax
  800dc1:	89 c2                	mov    %eax,%edx
  800dc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800dc7:	29 c2                	sub    %eax,%edx
  800dc9:	89 c1                	mov    %eax,%ecx
  800dcb:	89 f8                	mov    %edi,%eax
  800dcd:	d3 e5                	shl    %cl,%ebp
  800dcf:	89 d1                	mov    %edx,%ecx
  800dd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dd5:	d3 e8                	shr    %cl,%eax
  800dd7:	09 c5                	or     %eax,%ebp
  800dd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ddd:	89 c1                	mov    %eax,%ecx
  800ddf:	d3 e7                	shl    %cl,%edi
  800de1:	89 d1                	mov    %edx,%ecx
  800de3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800de7:	89 df                	mov    %ebx,%edi
  800de9:	d3 ef                	shr    %cl,%edi
  800deb:	89 c1                	mov    %eax,%ecx
  800ded:	89 f0                	mov    %esi,%eax
  800def:	d3 e3                	shl    %cl,%ebx
  800df1:	89 d1                	mov    %edx,%ecx
  800df3:	89 fa                	mov    %edi,%edx
  800df5:	d3 e8                	shr    %cl,%eax
  800df7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800dfc:	09 d8                	or     %ebx,%eax
  800dfe:	f7 f5                	div    %ebp
  800e00:	d3 e6                	shl    %cl,%esi
  800e02:	89 d1                	mov    %edx,%ecx
  800e04:	f7 64 24 08          	mull   0x8(%esp)
  800e08:	39 d1                	cmp    %edx,%ecx
  800e0a:	89 c3                	mov    %eax,%ebx
  800e0c:	89 d7                	mov    %edx,%edi
  800e0e:	72 06                	jb     800e16 <__umoddi3+0xa6>
  800e10:	75 0e                	jne    800e20 <__umoddi3+0xb0>
  800e12:	39 c6                	cmp    %eax,%esi
  800e14:	73 0a                	jae    800e20 <__umoddi3+0xb0>
  800e16:	2b 44 24 08          	sub    0x8(%esp),%eax
  800e1a:	19 ea                	sbb    %ebp,%edx
  800e1c:	89 d7                	mov    %edx,%edi
  800e1e:	89 c3                	mov    %eax,%ebx
  800e20:	89 ca                	mov    %ecx,%edx
  800e22:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800e27:	29 de                	sub    %ebx,%esi
  800e29:	19 fa                	sbb    %edi,%edx
  800e2b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800e2f:	89 d0                	mov    %edx,%eax
  800e31:	d3 e0                	shl    %cl,%eax
  800e33:	89 d9                	mov    %ebx,%ecx
  800e35:	d3 ee                	shr    %cl,%esi
  800e37:	d3 ea                	shr    %cl,%edx
  800e39:	09 f0                	or     %esi,%eax
  800e3b:	83 c4 1c             	add    $0x1c,%esp
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5f                   	pop    %edi
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    
  800e43:	90                   	nop
  800e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e48:	85 ff                	test   %edi,%edi
  800e4a:	89 f9                	mov    %edi,%ecx
  800e4c:	75 0b                	jne    800e59 <__umoddi3+0xe9>
  800e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e53:	31 d2                	xor    %edx,%edx
  800e55:	f7 f7                	div    %edi
  800e57:	89 c1                	mov    %eax,%ecx
  800e59:	89 d8                	mov    %ebx,%eax
  800e5b:	31 d2                	xor    %edx,%edx
  800e5d:	f7 f1                	div    %ecx
  800e5f:	89 f0                	mov    %esi,%eax
  800e61:	f7 f1                	div    %ecx
  800e63:	e9 31 ff ff ff       	jmp    800d99 <__umoddi3+0x29>
  800e68:	90                   	nop
  800e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e70:	39 dd                	cmp    %ebx,%ebp
  800e72:	72 08                	jb     800e7c <__umoddi3+0x10c>
  800e74:	39 f7                	cmp    %esi,%edi
  800e76:	0f 87 21 ff ff ff    	ja     800d9d <__umoddi3+0x2d>
  800e7c:	89 da                	mov    %ebx,%edx
  800e7e:	89 f0                	mov    %esi,%eax
  800e80:	29 f8                	sub    %edi,%eax
  800e82:	19 ea                	sbb    %ebp,%edx
  800e84:	e9 14 ff ff ff       	jmp    800d9d <__umoddi3+0x2d>
