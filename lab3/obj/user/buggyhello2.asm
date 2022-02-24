
obj/user/buggyhello2：     文件格式 elf32-i386


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
  80002c:	e8 30 00 00 00       	call   800061 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	e8 1e 00 00 00       	call   80005d <__x86.get_pc_thunk.bx>
  80003f:	81 c3 c1 1f 00 00    	add    $0x1fc1,%ebx
	sys_cputs(hello, 1024*1024);
  800045:	68 00 00 10 00       	push   $0x100000
  80004a:	ff b3 0c 00 00 00    	pushl  0xc(%ebx)
  800050:	e8 76 00 00 00       	call   8000cb <sys_cputs>
}
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <__x86.get_pc_thunk.bx>:
  80005d:	8b 1c 24             	mov    (%esp),%ebx
  800060:	c3                   	ret    

00800061 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	56                   	push   %esi
  800065:	53                   	push   %ebx
  800066:	e8 f2 ff ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  80006b:	81 c3 95 1f 00 00    	add    $0x1f95,%ebx
  800071:	8b 45 08             	mov    0x8(%ebp),%eax
  800074:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800077:	c7 c1 30 20 80 00    	mov    $0x802030,%ecx
  80007d:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  800083:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800085:	85 c0                	test   %eax,%eax
  800087:	7e 08                	jle    800091 <libmain+0x30>
		binaryname = argv[0];
  800089:	8b 0a                	mov    (%edx),%ecx
  80008b:	89 8b 10 00 00 00    	mov    %ecx,0x10(%ebx)

	// call user main routine
	umain(argc, argv);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	52                   	push   %edx
  800095:	50                   	push   %eax
  800096:	e8 98 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009b:	e8 0a 00 00 00       	call   8000aa <exit>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a6:	5b                   	pop    %ebx
  8000a7:	5e                   	pop    %esi
  8000a8:	5d                   	pop    %ebp
  8000a9:	c3                   	ret    

008000aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	53                   	push   %ebx
  8000ae:	83 ec 10             	sub    $0x10,%esp
  8000b1:	e8 a7 ff ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  8000b6:	81 c3 4a 1f 00 00    	add    $0x1f4a,%ebx
	sys_env_destroy(0);
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 45 00 00 00       	call   800108 <sys_env_destroy>
}
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	57                   	push   %edi
  8000cf:	56                   	push   %esi
  8000d0:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000dc:	89 c3                	mov    %eax,%ebx
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	89 c6                	mov    %eax,%esi
  8000e2:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_cgetc>:

int
sys_cgetc(void) {
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	89 d3                	mov    %edx,%ebx
  8000fd:	89 d7                	mov    %edx,%edi
  8000ff:	89 d6                	mov    %edx,%esi
  800101:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5f                   	pop    %edi
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	57                   	push   %edi
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	83 ec 1c             	sub    $0x1c,%esp
  800111:	e8 66 00 00 00       	call   80017c <__x86.get_pc_thunk.ax>
  800116:	05 ea 1e 00 00       	add    $0x1eea,%eax
  80011b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  80011e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800123:	8b 55 08             	mov    0x8(%ebp),%edx
  800126:	b8 03 00 00 00       	mov    $0x3,%eax
  80012b:	89 cb                	mov    %ecx,%ebx
  80012d:	89 cf                	mov    %ecx,%edi
  80012f:	89 ce                	mov    %ecx,%esi
  800131:	cd 30                	int    $0x30
    if (check && ret > 0)
  800133:	85 c0                	test   %eax,%eax
  800135:	7f 08                	jg     80013f <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	6a 03                	push   $0x3
  800145:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800148:	8d 83 b4 ee ff ff    	lea    -0x114c(%ebx),%eax
  80014e:	50                   	push   %eax
  80014f:	6a 24                	push   $0x24
  800151:	8d 83 d1 ee ff ff    	lea    -0x112f(%ebx),%eax
  800157:	50                   	push   %eax
  800158:	e8 23 00 00 00       	call   800180 <_panic>

0080015d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	57                   	push   %edi
  800161:	56                   	push   %esi
  800162:	53                   	push   %ebx
    asm volatile("int %1\n"
  800163:	ba 00 00 00 00       	mov    $0x0,%edx
  800168:	b8 02 00 00 00       	mov    $0x2,%eax
  80016d:	89 d1                	mov    %edx,%ecx
  80016f:	89 d3                	mov    %edx,%ebx
  800171:	89 d7                	mov    %edx,%edi
  800173:	89 d6                	mov    %edx,%esi
  800175:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800177:	5b                   	pop    %ebx
  800178:	5e                   	pop    %esi
  800179:	5f                   	pop    %edi
  80017a:	5d                   	pop    %ebp
  80017b:	c3                   	ret    

0080017c <__x86.get_pc_thunk.ax>:
  80017c:	8b 04 24             	mov    (%esp),%eax
  80017f:	c3                   	ret    

00800180 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	e8 cf fe ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  80018e:	81 c3 72 1e 00 00    	add    $0x1e72,%ebx
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	c7 c0 10 20 80 00    	mov    $0x802010,%eax
  80019d:	8b 38                	mov    (%eax),%edi
  80019f:	e8 b9 ff ff ff       	call   80015d <sys_getenvid>
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 0c             	pushl  0xc(%ebp)
  8001aa:	ff 75 08             	pushl  0x8(%ebp)
  8001ad:	57                   	push   %edi
  8001ae:	50                   	push   %eax
  8001af:	8d 83 e0 ee ff ff    	lea    -0x1120(%ebx),%eax
  8001b5:	50                   	push   %eax
  8001b6:	e8 d1 00 00 00       	call   80028c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bb:	83 c4 18             	add    $0x18,%esp
  8001be:	56                   	push   %esi
  8001bf:	ff 75 10             	pushl  0x10(%ebp)
  8001c2:	e8 63 00 00 00       	call   80022a <vcprintf>
	cprintf("\n");
  8001c7:	8d 83 a8 ee ff ff    	lea    -0x1158(%ebx),%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 b7 00 00 00       	call   80028c <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d8:	cc                   	int3   
  8001d9:	eb fd                	jmp    8001d8 <_panic+0x58>

008001db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	e8 78 fe ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  8001e5:	81 c3 1b 1e 00 00    	add    $0x1e1b,%ebx
  8001eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001ee:	8b 16                	mov    (%esi),%edx
  8001f0:	8d 42 01             	lea    0x1(%edx),%eax
  8001f3:	89 06                	mov    %eax,(%esi)
  8001f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f8:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800201:	74 0b                	je     80020e <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800203:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800207:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020a:	5b                   	pop    %ebx
  80020b:	5e                   	pop    %esi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	68 ff 00 00 00       	push   $0xff
  800216:	8d 46 08             	lea    0x8(%esi),%eax
  800219:	50                   	push   %eax
  80021a:	e8 ac fe ff ff       	call   8000cb <sys_cputs>
		b->idx = 0;
  80021f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	eb d9                	jmp    800203 <putch+0x28>

0080022a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	53                   	push   %ebx
  80022e:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800234:	e8 24 fe ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  800239:	81 c3 c7 1d 00 00    	add    $0x1dc7,%ebx
	struct printbuf b;

	b.idx = 0;
  80023f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800246:	00 00 00 
	b.cnt = 0;
  800249:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800250:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	50                   	push   %eax
  800260:	8d 83 db e1 ff ff    	lea    -0x1e25(%ebx),%eax
  800266:	50                   	push   %eax
  800267:	e8 38 01 00 00       	call   8003a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026c:	83 c4 08             	add    $0x8,%esp
  80026f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800275:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	e8 4a fe ff ff       	call   8000cb <sys_cputs>

	return b.cnt;
}
  800281:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
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
  800299:	e8 8c ff ff ff       	call   80022a <vcprintf>
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
  8002a6:	83 ec 2c             	sub    $0x2c,%esp
  8002a9:	e8 3a 06 00 00       	call   8008e8 <__x86.get_pc_thunk.cx>
  8002ae:	81 c1 52 1d 00 00    	add    $0x1d52,%ecx
  8002b4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 d6                	mov    %edx,%esi
  8002bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002d2:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002d5:	39 d3                	cmp    %edx,%ebx
  8002d7:	72 09                	jb     8002e2 <printnum+0x42>
  8002d9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002dc:	0f 87 83 00 00 00    	ja     800365 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	ff 75 18             	pushl  0x18(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ee:	53                   	push   %ebx
  8002ef:	ff 75 10             	pushl  0x10(%ebp)
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002fe:	ff 75 d0             	pushl  -0x30(%ebp)
  800301:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800304:	e8 57 09 00 00       	call   800c60 <__udivdi3>
  800309:	83 c4 18             	add    $0x18,%esp
  80030c:	52                   	push   %edx
  80030d:	50                   	push   %eax
  80030e:	89 f2                	mov    %esi,%edx
  800310:	89 f8                	mov    %edi,%eax
  800312:	e8 89 ff ff ff       	call   8002a0 <printnum>
  800317:	83 c4 20             	add    $0x20,%esp
  80031a:	eb 13                	jmp    80032f <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	56                   	push   %esi
  800320:	ff 75 18             	pushl  0x18(%ebp)
  800323:	ff d7                	call   *%edi
  800325:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800328:	83 eb 01             	sub    $0x1,%ebx
  80032b:	85 db                	test   %ebx,%ebx
  80032d:	7f ed                	jg     80031c <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	56                   	push   %esi
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	ff 75 dc             	pushl  -0x24(%ebp)
  800339:	ff 75 d8             	pushl  -0x28(%ebp)
  80033c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033f:	ff 75 d0             	pushl  -0x30(%ebp)
  800342:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800345:	89 f3                	mov    %esi,%ebx
  800347:	e8 34 0a 00 00       	call   800d80 <__umoddi3>
  80034c:	83 c4 14             	add    $0x14,%esp
  80034f:	0f be 84 06 04 ef ff 	movsbl -0x10fc(%esi,%eax,1),%eax
  800356:	ff 
  800357:	50                   	push   %eax
  800358:	ff d7                	call   *%edi
}
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800360:	5b                   	pop    %ebx
  800361:	5e                   	pop    %esi
  800362:	5f                   	pop    %edi
  800363:	5d                   	pop    %ebp
  800364:	c3                   	ret    
  800365:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800368:	eb be                	jmp    800328 <printnum+0x88>

0080036a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800370:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800374:	8b 10                	mov    (%eax),%edx
  800376:	3b 50 04             	cmp    0x4(%eax),%edx
  800379:	73 0a                	jae    800385 <sprintputch+0x1b>
		*b->buf++ = ch;
  80037b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	88 02                	mov    %al,(%edx)
}
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    

00800387 <printfmt>:
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80038d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800390:	50                   	push   %eax
  800391:	ff 75 10             	pushl  0x10(%ebp)
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 08             	pushl  0x8(%ebp)
  80039a:	e8 05 00 00 00       	call   8003a4 <vprintfmt>
}
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <vprintfmt>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 2c             	sub    $0x2c,%esp
  8003ad:	e8 ab fc ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  8003b2:	81 c3 4e 1c 00 00    	add    $0x1c4e,%ebx
  8003b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003be:	e9 fb 03 00 00       	jmp    8007be <.L35+0x48>
		padc = ' ';
  8003c3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003c7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003ce:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8d 47 01             	lea    0x1(%edi),%eax
  8003e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ea:	0f b6 17             	movzbl (%edi),%edx
  8003ed:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f0:	3c 55                	cmp    $0x55,%al
  8003f2:	0f 87 4e 04 00 00    	ja     800846 <.L22>
  8003f8:	0f b6 c0             	movzbl %al,%eax
  8003fb:	89 d9                	mov    %ebx,%ecx
  8003fd:	03 8c 83 94 ef ff ff 	add    -0x106c(%ebx,%eax,4),%ecx
  800404:	ff e1                	jmp    *%ecx

00800406 <.L71>:
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800409:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80040d:	eb d5                	jmp    8003e4 <vprintfmt+0x40>

0080040f <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800412:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800416:	eb cc                	jmp    8003e4 <vprintfmt+0x40>

00800418 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	0f b6 d2             	movzbl %dl,%edx
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80041e:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800423:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800426:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80042a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80042d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800430:	83 f9 09             	cmp    $0x9,%ecx
  800433:	77 55                	ja     80048a <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800435:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800438:	eb e9                	jmp    800423 <.L29+0xb>

0080043a <.L26>:
			precision = va_arg(ap, int);
  80043a:	8b 45 14             	mov    0x14(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8d 40 04             	lea    0x4(%eax),%eax
  800448:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80044e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800452:	79 90                	jns    8003e4 <vprintfmt+0x40>
				width = precision, precision = -1;
  800454:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800457:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045a:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800461:	eb 81                	jmp    8003e4 <vprintfmt+0x40>

00800463 <.L27>:
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	85 c0                	test   %eax,%eax
  800468:	ba 00 00 00 00       	mov    $0x0,%edx
  80046d:	0f 49 d0             	cmovns %eax,%edx
  800470:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800473:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800476:	e9 69 ff ff ff       	jmp    8003e4 <vprintfmt+0x40>

0080047b <.L23>:
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80047e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800485:	e9 5a ff ff ff       	jmp    8003e4 <vprintfmt+0x40>
  80048a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80048d:	eb bf                	jmp    80044e <.L26+0x14>

0080048f <.L33>:
			lflag++;
  80048f:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800496:	e9 49 ff ff ff       	jmp    8003e4 <vprintfmt+0x40>

0080049b <.L30>:
			putch(va_arg(ap, int), putdat);
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8d 78 04             	lea    0x4(%eax),%edi
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	56                   	push   %esi
  8004a5:	ff 30                	pushl  (%eax)
  8004a7:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004aa:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ad:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b0:	e9 06 03 00 00       	jmp    8007bb <.L35+0x45>

008004b5 <.L32>:
			err = va_arg(ap, int);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8d 78 04             	lea    0x4(%eax),%edi
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	99                   	cltd   
  8004be:	31 d0                	xor    %edx,%eax
  8004c0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c2:	83 f8 06             	cmp    $0x6,%eax
  8004c5:	7f 27                	jg     8004ee <.L32+0x39>
  8004c7:	8b 94 83 14 00 00 00 	mov    0x14(%ebx,%eax,4),%edx
  8004ce:	85 d2                	test   %edx,%edx
  8004d0:	74 1c                	je     8004ee <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004d2:	52                   	push   %edx
  8004d3:	8d 83 25 ef ff ff    	lea    -0x10db(%ebx),%eax
  8004d9:	50                   	push   %eax
  8004da:	56                   	push   %esi
  8004db:	ff 75 08             	pushl  0x8(%ebp)
  8004de:	e8 a4 fe ff ff       	call   800387 <printfmt>
  8004e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e9:	e9 cd 02 00 00       	jmp    8007bb <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004ee:	50                   	push   %eax
  8004ef:	8d 83 1c ef ff ff    	lea    -0x10e4(%ebx),%eax
  8004f5:	50                   	push   %eax
  8004f6:	56                   	push   %esi
  8004f7:	ff 75 08             	pushl  0x8(%ebp)
  8004fa:	e8 88 fe ff ff       	call   800387 <printfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800502:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800505:	e9 b1 02 00 00       	jmp    8007bb <.L35+0x45>

0080050a <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	83 c0 04             	add    $0x4,%eax
  800510:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800518:	85 ff                	test   %edi,%edi
  80051a:	8d 83 15 ef ff ff    	lea    -0x10eb(%ebx),%eax
  800520:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800523:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800527:	0f 8e b5 00 00 00    	jle    8005e2 <.L36+0xd8>
  80052d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800531:	75 08                	jne    80053b <.L36+0x31>
  800533:	89 75 0c             	mov    %esi,0xc(%ebp)
  800536:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800539:	eb 6d                	jmp    8005a8 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 cc             	pushl  -0x34(%ebp)
  800541:	57                   	push   %edi
  800542:	e8 bd 03 00 00       	call   800904 <strnlen>
  800547:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054a:	29 c2                	sub    %eax,%edx
  80054c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  80054f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800552:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800556:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800559:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80055c:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80055e:	eb 10                	jmp    800570 <.L36+0x66>
					putch(padc, putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	56                   	push   %esi
  800564:	ff 75 e0             	pushl  -0x20(%ebp)
  800567:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80056a:	83 ef 01             	sub    $0x1,%edi
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	85 ff                	test   %edi,%edi
  800572:	7f ec                	jg     800560 <.L36+0x56>
  800574:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800577:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80057a:	85 d2                	test   %edx,%edx
  80057c:	b8 00 00 00 00       	mov    $0x0,%eax
  800581:	0f 49 c2             	cmovns %edx,%eax
  800584:	29 c2                	sub    %eax,%edx
  800586:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800589:	89 75 0c             	mov    %esi,0xc(%ebp)
  80058c:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80058f:	eb 17                	jmp    8005a8 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800591:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800595:	75 30                	jne    8005c7 <.L36+0xbd>
					putch(ch, putdat);
  800597:	83 ec 08             	sub    $0x8,%esp
  80059a:	ff 75 0c             	pushl  0xc(%ebp)
  80059d:	50                   	push   %eax
  80059e:	ff 55 08             	call   *0x8(%ebp)
  8005a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a4:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8005a8:	83 c7 01             	add    $0x1,%edi
  8005ab:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005af:	0f be c2             	movsbl %dl,%eax
  8005b2:	85 c0                	test   %eax,%eax
  8005b4:	74 52                	je     800608 <.L36+0xfe>
  8005b6:	85 f6                	test   %esi,%esi
  8005b8:	78 d7                	js     800591 <.L36+0x87>
  8005ba:	83 ee 01             	sub    $0x1,%esi
  8005bd:	79 d2                	jns    800591 <.L36+0x87>
  8005bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005c2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005c5:	eb 32                	jmp    8005f9 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005c7:	0f be d2             	movsbl %dl,%edx
  8005ca:	83 ea 20             	sub    $0x20,%edx
  8005cd:	83 fa 5e             	cmp    $0x5e,%edx
  8005d0:	76 c5                	jbe    800597 <.L36+0x8d>
					putch('?', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	ff 75 0c             	pushl  0xc(%ebp)
  8005d8:	6a 3f                	push   $0x3f
  8005da:	ff 55 08             	call   *0x8(%ebp)
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	eb c2                	jmp    8005a4 <.L36+0x9a>
  8005e2:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005e5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005e8:	eb be                	jmp    8005a8 <.L36+0x9e>
				putch(' ', putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	56                   	push   %esi
  8005ee:	6a 20                	push   $0x20
  8005f0:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005f3:	83 ef 01             	sub    $0x1,%edi
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	85 ff                	test   %edi,%edi
  8005fb:	7f ed                	jg     8005ea <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
  800603:	e9 b3 01 00 00       	jmp    8007bb <.L35+0x45>
  800608:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80060b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80060e:	eb e9                	jmp    8005f9 <.L36+0xef>

00800610 <.L31>:
  800610:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800613:	83 f9 01             	cmp    $0x1,%ecx
  800616:	7e 40                	jle    800658 <.L31+0x48>
		return va_arg(*ap, long long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 50 04             	mov    0x4(%eax),%edx
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 08             	lea    0x8(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800633:	79 55                	jns    80068a <.L31+0x7a>
				putch('-', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	56                   	push   %esi
  800639:	6a 2d                	push   $0x2d
  80063b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80063e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800641:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800644:	f7 da                	neg    %edx
  800646:	83 d1 00             	adc    $0x0,%ecx
  800649:	f7 d9                	neg    %ecx
  80064b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800653:	e9 48 01 00 00       	jmp    8007a0 <.L35+0x2a>
	else if (lflag)
  800658:	85 c9                	test   %ecx,%ecx
  80065a:	75 17                	jne    800673 <.L31+0x63>
		return va_arg(*ap, int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	99                   	cltd   
  800665:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8d 40 04             	lea    0x4(%eax),%eax
  80066e:	89 45 14             	mov    %eax,0x14(%ebp)
  800671:	eb bc                	jmp    80062f <.L31+0x1f>
		return va_arg(*ap, long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	99                   	cltd   
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
  800688:	eb a5                	jmp    80062f <.L31+0x1f>
			num = getint(&ap, lflag);
  80068a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80068d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800690:	b8 0a 00 00 00       	mov    $0xa,%eax
  800695:	e9 06 01 00 00       	jmp    8007a0 <.L35+0x2a>

0080069a <.L37>:
  80069a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  80069d:	83 f9 01             	cmp    $0x1,%ecx
  8006a0:	7e 18                	jle    8006ba <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	8b 48 04             	mov    0x4(%eax),%ecx
  8006aa:	8d 40 08             	lea    0x8(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b5:	e9 e6 00 00 00       	jmp    8007a0 <.L35+0x2a>
	else if (lflag)
  8006ba:	85 c9                	test   %ecx,%ecx
  8006bc:	75 1a                	jne    8006d8 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 10                	mov    (%eax),%edx
  8006c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c8:	8d 40 04             	lea    0x4(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d3:	e9 c8 00 00 00       	jmp    8007a0 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 10                	mov    (%eax),%edx
  8006dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ed:	e9 ae 00 00 00       	jmp    8007a0 <.L35+0x2a>

008006f2 <.L34>:
  8006f2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006f5:	83 f9 01             	cmp    $0x1,%ecx
  8006f8:	7e 3d                	jle    800737 <.L34+0x45>
		return va_arg(*ap, long long);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 50 04             	mov    0x4(%eax),%edx
  800700:	8b 00                	mov    (%eax),%eax
  800702:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800705:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 40 08             	lea    0x8(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800711:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800715:	79 52                	jns    800769 <.L34+0x77>
                putch('-', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	56                   	push   %esi
  80071b:	6a 2d                	push   $0x2d
  80071d:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800720:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800723:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800726:	f7 da                	neg    %edx
  800728:	83 d1 00             	adc    $0x0,%ecx
  80072b:	f7 d9                	neg    %ecx
  80072d:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800730:	b8 08 00 00 00       	mov    $0x8,%eax
  800735:	eb 69                	jmp    8007a0 <.L35+0x2a>
	else if (lflag)
  800737:	85 c9                	test   %ecx,%ecx
  800739:	75 17                	jne    800752 <.L34+0x60>
		return va_arg(*ap, int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800743:	99                   	cltd   
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	eb bf                	jmp    800711 <.L34+0x1f>
		return va_arg(*ap, long);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	99                   	cltd   
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	eb a8                	jmp    800711 <.L34+0x1f>
            num = getint(&ap, lflag);
  800769:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80076c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80076f:	b8 08 00 00 00       	mov    $0x8,%eax
  800774:	eb 2a                	jmp    8007a0 <.L35+0x2a>

00800776 <.L35>:
			putch('0', putdat);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	56                   	push   %esi
  80077a:	6a 30                	push   $0x30
  80077c:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80077f:	83 c4 08             	add    $0x8,%esp
  800782:	56                   	push   %esi
  800783:	6a 78                	push   $0x78
  800785:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 10                	mov    (%eax),%edx
  80078d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800792:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800795:	8d 40 04             	lea    0x4(%eax),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a0:	83 ec 0c             	sub    $0xc,%esp
  8007a3:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007a7:	57                   	push   %edi
  8007a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	51                   	push   %ecx
  8007ad:	52                   	push   %edx
  8007ae:	89 f2                	mov    %esi,%edx
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	e8 e8 fa ff ff       	call   8002a0 <printnum>
			break;
  8007b8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007be:	83 c7 01             	add    $0x1,%edi
  8007c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c5:	83 f8 25             	cmp    $0x25,%eax
  8007c8:	0f 84 f5 fb ff ff    	je     8003c3 <vprintfmt+0x1f>
			if (ch == '\0')
  8007ce:	85 c0                	test   %eax,%eax
  8007d0:	0f 84 91 00 00 00    	je     800867 <.L22+0x21>
			putch(ch, putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	56                   	push   %esi
  8007da:	50                   	push   %eax
  8007db:	ff 55 08             	call   *0x8(%ebp)
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	eb db                	jmp    8007be <.L35+0x48>

008007e3 <.L38>:
  8007e3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007e6:	83 f9 01             	cmp    $0x1,%ecx
  8007e9:	7e 15                	jle    800800 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 10                	mov    (%eax),%edx
  8007f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f3:	8d 40 08             	lea    0x8(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fe:	eb a0                	jmp    8007a0 <.L35+0x2a>
	else if (lflag)
  800800:	85 c9                	test   %ecx,%ecx
  800802:	75 17                	jne    80081b <.L38+0x38>
		return va_arg(*ap, unsigned int);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 10                	mov    (%eax),%edx
  800809:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080e:	8d 40 04             	lea    0x4(%eax),%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800814:	b8 10 00 00 00       	mov    $0x10,%eax
  800819:	eb 85                	jmp    8007a0 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 10                	mov    (%eax),%edx
  800820:	b9 00 00 00 00       	mov    $0x0,%ecx
  800825:	8d 40 04             	lea    0x4(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082b:	b8 10 00 00 00       	mov    $0x10,%eax
  800830:	e9 6b ff ff ff       	jmp    8007a0 <.L35+0x2a>

00800835 <.L25>:
			putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	56                   	push   %esi
  800839:	6a 25                	push   $0x25
  80083b:	ff 55 08             	call   *0x8(%ebp)
			break;
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	e9 75 ff ff ff       	jmp    8007bb <.L35+0x45>

00800846 <.L22>:
			putch('%', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	56                   	push   %esi
  80084a:	6a 25                	push   $0x25
  80084c:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	89 f8                	mov    %edi,%eax
  800854:	eb 03                	jmp    800859 <.L22+0x13>
  800856:	83 e8 01             	sub    $0x1,%eax
  800859:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085d:	75 f7                	jne    800856 <.L22+0x10>
  80085f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800862:	e9 54 ff ff ff       	jmp    8007bb <.L35+0x45>
}
  800867:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086a:	5b                   	pop    %ebx
  80086b:	5e                   	pop    %esi
  80086c:	5f                   	pop    %edi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	53                   	push   %ebx
  800873:	83 ec 14             	sub    $0x14,%esp
  800876:	e8 e2 f7 ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  80087b:	81 c3 85 17 00 00    	add    $0x1785,%ebx
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800887:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800891:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800898:	85 c0                	test   %eax,%eax
  80089a:	74 2b                	je     8008c7 <vsnprintf+0x58>
  80089c:	85 d2                	test   %edx,%edx
  80089e:	7e 27                	jle    8008c7 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a0:	ff 75 14             	pushl  0x14(%ebp)
  8008a3:	ff 75 10             	pushl  0x10(%ebp)
  8008a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a9:	50                   	push   %eax
  8008aa:	8d 83 6a e3 ff ff    	lea    -0x1c96(%ebx),%eax
  8008b0:	50                   	push   %eax
  8008b1:	e8 ee fa ff ff       	call   8003a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
}
  8008c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c5:	c9                   	leave  
  8008c6:	c3                   	ret    
		return -E_INVAL;
  8008c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cc:	eb f4                	jmp    8008c2 <vsnprintf+0x53>

008008ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d7:	50                   	push   %eax
  8008d8:	ff 75 10             	pushl  0x10(%ebp)
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	ff 75 08             	pushl  0x8(%ebp)
  8008e1:	e8 89 ff ff ff       	call   80086f <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <__x86.get_pc_thunk.cx>:
  8008e8:	8b 0c 24             	mov    (%esp),%ecx
  8008eb:	c3                   	ret    

008008ec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f7:	eb 03                	jmp    8008fc <strlen+0x10>
		n++;
  8008f9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008fc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800900:	75 f7                	jne    8008f9 <strlen+0xd>
	return n;
}
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	eb 03                	jmp    800917 <strnlen+0x13>
		n++;
  800914:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800917:	39 d0                	cmp    %edx,%eax
  800919:	74 06                	je     800921 <strnlen+0x1d>
  80091b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091f:	75 f3                	jne    800914 <strnlen+0x10>
	return n;
}
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	53                   	push   %ebx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80092d:	89 c2                	mov    %eax,%edx
  80092f:	83 c1 01             	add    $0x1,%ecx
  800932:	83 c2 01             	add    $0x1,%edx
  800935:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800939:	88 5a ff             	mov    %bl,-0x1(%edx)
  80093c:	84 db                	test   %bl,%bl
  80093e:	75 ef                	jne    80092f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800940:	5b                   	pop    %ebx
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	53                   	push   %ebx
  800947:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80094a:	53                   	push   %ebx
  80094b:	e8 9c ff ff ff       	call   8008ec <strlen>
  800950:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	01 d8                	add    %ebx,%eax
  800958:	50                   	push   %eax
  800959:	e8 c5 ff ff ff       	call   800923 <strcpy>
	return dst;
}
  80095e:	89 d8                	mov    %ebx,%eax
  800960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800963:	c9                   	leave  
  800964:	c3                   	ret    

00800965 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	56                   	push   %esi
  800969:	53                   	push   %ebx
  80096a:	8b 75 08             	mov    0x8(%ebp),%esi
  80096d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800970:	89 f3                	mov    %esi,%ebx
  800972:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800975:	89 f2                	mov    %esi,%edx
  800977:	eb 0f                	jmp    800988 <strncpy+0x23>
		*dst++ = *src;
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	0f b6 01             	movzbl (%ecx),%eax
  80097f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800982:	80 39 01             	cmpb   $0x1,(%ecx)
  800985:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800988:	39 da                	cmp    %ebx,%edx
  80098a:	75 ed                	jne    800979 <strncpy+0x14>
	}
	return ret;
}
  80098c:	89 f0                	mov    %esi,%eax
  80098e:	5b                   	pop    %ebx
  80098f:	5e                   	pop    %esi
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 75 08             	mov    0x8(%ebp),%esi
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009a0:	89 f0                	mov    %esi,%eax
  8009a2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a6:	85 c9                	test   %ecx,%ecx
  8009a8:	75 0b                	jne    8009b5 <strlcpy+0x23>
  8009aa:	eb 17                	jmp    8009c3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ac:	83 c2 01             	add    $0x1,%edx
  8009af:	83 c0 01             	add    $0x1,%eax
  8009b2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009b5:	39 d8                	cmp    %ebx,%eax
  8009b7:	74 07                	je     8009c0 <strlcpy+0x2e>
  8009b9:	0f b6 0a             	movzbl (%edx),%ecx
  8009bc:	84 c9                	test   %cl,%cl
  8009be:	75 ec                	jne    8009ac <strlcpy+0x1a>
		*dst = '\0';
  8009c0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009c3:	29 f0                	sub    %esi,%eax
}
  8009c5:	5b                   	pop    %ebx
  8009c6:	5e                   	pop    %esi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d2:	eb 06                	jmp    8009da <strcmp+0x11>
		p++, q++;
  8009d4:	83 c1 01             	add    $0x1,%ecx
  8009d7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009da:	0f b6 01             	movzbl (%ecx),%eax
  8009dd:	84 c0                	test   %al,%al
  8009df:	74 04                	je     8009e5 <strcmp+0x1c>
  8009e1:	3a 02                	cmp    (%edx),%al
  8009e3:	74 ef                	je     8009d4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e5:	0f b6 c0             	movzbl %al,%eax
  8009e8:	0f b6 12             	movzbl (%edx),%edx
  8009eb:	29 d0                	sub    %edx,%eax
}
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f9:	89 c3                	mov    %eax,%ebx
  8009fb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009fe:	eb 06                	jmp    800a06 <strncmp+0x17>
		n--, p++, q++;
  800a00:	83 c0 01             	add    $0x1,%eax
  800a03:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a06:	39 d8                	cmp    %ebx,%eax
  800a08:	74 16                	je     800a20 <strncmp+0x31>
  800a0a:	0f b6 08             	movzbl (%eax),%ecx
  800a0d:	84 c9                	test   %cl,%cl
  800a0f:	74 04                	je     800a15 <strncmp+0x26>
  800a11:	3a 0a                	cmp    (%edx),%cl
  800a13:	74 eb                	je     800a00 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a15:	0f b6 00             	movzbl (%eax),%eax
  800a18:	0f b6 12             	movzbl (%edx),%edx
  800a1b:	29 d0                	sub    %edx,%eax
}
  800a1d:	5b                   	pop    %ebx
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    
		return 0;
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	eb f6                	jmp    800a1d <strncmp+0x2e>

00800a27 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a31:	0f b6 10             	movzbl (%eax),%edx
  800a34:	84 d2                	test   %dl,%dl
  800a36:	74 09                	je     800a41 <strchr+0x1a>
		if (*s == c)
  800a38:	38 ca                	cmp    %cl,%dl
  800a3a:	74 0a                	je     800a46 <strchr+0x1f>
	for (; *s; s++)
  800a3c:	83 c0 01             	add    $0x1,%eax
  800a3f:	eb f0                	jmp    800a31 <strchr+0xa>
			return (char *) s;
	return 0;
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a52:	eb 03                	jmp    800a57 <strfind+0xf>
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a5a:	38 ca                	cmp    %cl,%dl
  800a5c:	74 04                	je     800a62 <strfind+0x1a>
  800a5e:	84 d2                	test   %dl,%dl
  800a60:	75 f2                	jne    800a54 <strfind+0xc>
			break;
	return (char *) s;
}
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
  800a6a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a70:	85 c9                	test   %ecx,%ecx
  800a72:	74 13                	je     800a87 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a74:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7a:	75 05                	jne    800a81 <memset+0x1d>
  800a7c:	f6 c1 03             	test   $0x3,%cl
  800a7f:	74 0d                	je     800a8e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	fc                   	cld    
  800a85:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a87:	89 f8                	mov    %edi,%eax
  800a89:	5b                   	pop    %ebx
  800a8a:	5e                   	pop    %esi
  800a8b:	5f                   	pop    %edi
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    
		c &= 0xFF;
  800a8e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a92:	89 d3                	mov    %edx,%ebx
  800a94:	c1 e3 08             	shl    $0x8,%ebx
  800a97:	89 d0                	mov    %edx,%eax
  800a99:	c1 e0 18             	shl    $0x18,%eax
  800a9c:	89 d6                	mov    %edx,%esi
  800a9e:	c1 e6 10             	shl    $0x10,%esi
  800aa1:	09 f0                	or     %esi,%eax
  800aa3:	09 c2                	or     %eax,%edx
  800aa5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aaa:	89 d0                	mov    %edx,%eax
  800aac:	fc                   	cld    
  800aad:	f3 ab                	rep stos %eax,%es:(%edi)
  800aaf:	eb d6                	jmp    800a87 <memset+0x23>

00800ab1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	57                   	push   %edi
  800ab5:	56                   	push   %esi
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800abf:	39 c6                	cmp    %eax,%esi
  800ac1:	73 35                	jae    800af8 <memmove+0x47>
  800ac3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac6:	39 c2                	cmp    %eax,%edx
  800ac8:	76 2e                	jbe    800af8 <memmove+0x47>
		s += n;
		d += n;
  800aca:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acd:	89 d6                	mov    %edx,%esi
  800acf:	09 fe                	or     %edi,%esi
  800ad1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad7:	74 0c                	je     800ae5 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad9:	83 ef 01             	sub    $0x1,%edi
  800adc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800adf:	fd                   	std    
  800ae0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae2:	fc                   	cld    
  800ae3:	eb 21                	jmp    800b06 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae5:	f6 c1 03             	test   $0x3,%cl
  800ae8:	75 ef                	jne    800ad9 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aea:	83 ef 04             	sub    $0x4,%edi
  800aed:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af3:	fd                   	std    
  800af4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af6:	eb ea                	jmp    800ae2 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af8:	89 f2                	mov    %esi,%edx
  800afa:	09 c2                	or     %eax,%edx
  800afc:	f6 c2 03             	test   $0x3,%dl
  800aff:	74 09                	je     800b0a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b01:	89 c7                	mov    %eax,%edi
  800b03:	fc                   	cld    
  800b04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b06:	5e                   	pop    %esi
  800b07:	5f                   	pop    %edi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0a:	f6 c1 03             	test   $0x3,%cl
  800b0d:	75 f2                	jne    800b01 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b12:	89 c7                	mov    %eax,%edi
  800b14:	fc                   	cld    
  800b15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b17:	eb ed                	jmp    800b06 <memmove+0x55>

00800b19 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b1c:	ff 75 10             	pushl  0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 87 ff ff ff       	call   800ab1 <memmove>
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 c6                	mov    %eax,%esi
  800b39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3c:	39 f0                	cmp    %esi,%eax
  800b3e:	74 1c                	je     800b5c <memcmp+0x30>
		if (*s1 != *s2)
  800b40:	0f b6 08             	movzbl (%eax),%ecx
  800b43:	0f b6 1a             	movzbl (%edx),%ebx
  800b46:	38 d9                	cmp    %bl,%cl
  800b48:	75 08                	jne    800b52 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	83 c2 01             	add    $0x1,%edx
  800b50:	eb ea                	jmp    800b3c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b52:	0f b6 c1             	movzbl %cl,%eax
  800b55:	0f b6 db             	movzbl %bl,%ebx
  800b58:	29 d8                	sub    %ebx,%eax
  800b5a:	eb 05                	jmp    800b61 <memcmp+0x35>
	}

	return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b73:	39 d0                	cmp    %edx,%eax
  800b75:	73 09                	jae    800b80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b77:	38 08                	cmp    %cl,(%eax)
  800b79:	74 05                	je     800b80 <memfind+0x1b>
	for (; s < ends; s++)
  800b7b:	83 c0 01             	add    $0x1,%eax
  800b7e:	eb f3                	jmp    800b73 <memfind+0xe>
			break;
	return (void *) s;
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8e:	eb 03                	jmp    800b93 <strtol+0x11>
		s++;
  800b90:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b93:	0f b6 01             	movzbl (%ecx),%eax
  800b96:	3c 20                	cmp    $0x20,%al
  800b98:	74 f6                	je     800b90 <strtol+0xe>
  800b9a:	3c 09                	cmp    $0x9,%al
  800b9c:	74 f2                	je     800b90 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b9e:	3c 2b                	cmp    $0x2b,%al
  800ba0:	74 2e                	je     800bd0 <strtol+0x4e>
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba7:	3c 2d                	cmp    $0x2d,%al
  800ba9:	74 2f                	je     800bda <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bab:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb1:	75 05                	jne    800bb8 <strtol+0x36>
  800bb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb6:	74 2c                	je     800be4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb8:	85 db                	test   %ebx,%ebx
  800bba:	75 0a                	jne    800bc6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bc1:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc4:	74 28                	je     800bee <strtol+0x6c>
		base = 10;
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bce:	eb 50                	jmp    800c20 <strtol+0x9e>
		s++;
  800bd0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bd3:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd8:	eb d1                	jmp    800bab <strtol+0x29>
		s++, neg = 1;
  800bda:	83 c1 01             	add    $0x1,%ecx
  800bdd:	bf 01 00 00 00       	mov    $0x1,%edi
  800be2:	eb c7                	jmp    800bab <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be8:	74 0e                	je     800bf8 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bea:	85 db                	test   %ebx,%ebx
  800bec:	75 d8                	jne    800bc6 <strtol+0x44>
		s++, base = 8;
  800bee:	83 c1 01             	add    $0x1,%ecx
  800bf1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf6:	eb ce                	jmp    800bc6 <strtol+0x44>
		s += 2, base = 16;
  800bf8:	83 c1 02             	add    $0x2,%ecx
  800bfb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c00:	eb c4                	jmp    800bc6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c02:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c05:	89 f3                	mov    %esi,%ebx
  800c07:	80 fb 19             	cmp    $0x19,%bl
  800c0a:	77 29                	ja     800c35 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c0c:	0f be d2             	movsbl %dl,%edx
  800c0f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c12:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c15:	7d 30                	jge    800c47 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c17:	83 c1 01             	add    $0x1,%ecx
  800c1a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c20:	0f b6 11             	movzbl (%ecx),%edx
  800c23:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c26:	89 f3                	mov    %esi,%ebx
  800c28:	80 fb 09             	cmp    $0x9,%bl
  800c2b:	77 d5                	ja     800c02 <strtol+0x80>
			dig = *s - '0';
  800c2d:	0f be d2             	movsbl %dl,%edx
  800c30:	83 ea 30             	sub    $0x30,%edx
  800c33:	eb dd                	jmp    800c12 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c35:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c38:	89 f3                	mov    %esi,%ebx
  800c3a:	80 fb 19             	cmp    $0x19,%bl
  800c3d:	77 08                	ja     800c47 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c3f:	0f be d2             	movsbl %dl,%edx
  800c42:	83 ea 37             	sub    $0x37,%edx
  800c45:	eb cb                	jmp    800c12 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4b:	74 05                	je     800c52 <strtol+0xd0>
		*endptr = (char *) s;
  800c4d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c50:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c52:	89 c2                	mov    %eax,%edx
  800c54:	f7 da                	neg    %edx
  800c56:	85 ff                	test   %edi,%edi
  800c58:	0f 45 c2             	cmovne %edx,%eax
}
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

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
