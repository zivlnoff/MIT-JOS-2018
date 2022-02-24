
obj/user/faultwrite：     文件格式 elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	e8 3f 00 00 00       	call   80008b <__x86.get_pc_thunk.bx>
  80004c:	81 c3 b4 1f 00 00    	add    $0x1fb4,%ebx
  800052:	8b 45 08             	mov    0x8(%ebp),%eax
  800055:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800058:	c7 c1 2c 20 80 00    	mov    $0x80202c,%ecx
  80005e:	c7 c6 00 00 c0 ee    	mov    $0xeec00000,%esi
  800064:	89 31                	mov    %esi,(%ecx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800066:	85 c0                	test   %eax,%eax
  800068:	7e 08                	jle    800072 <libmain+0x30>
		binaryname = argv[0];
  80006a:	8b 0a                	mov    (%edx),%ecx
  80006c:	89 8b 0c 00 00 00    	mov    %ecx,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	52                   	push   %edx
  800076:	50                   	push   %eax
  800077:	e8 b7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007c:	e8 0e 00 00 00       	call   80008f <exit>
}
  800081:	83 c4 10             	add    $0x10,%esp
  800084:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800087:	5b                   	pop    %ebx
  800088:	5e                   	pop    %esi
  800089:	5d                   	pop    %ebp
  80008a:	c3                   	ret    

0080008b <__x86.get_pc_thunk.bx>:
  80008b:	8b 1c 24             	mov    (%esp),%ebx
  80008e:	c3                   	ret    

0080008f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008f:	55                   	push   %ebp
  800090:	89 e5                	mov    %esp,%ebp
  800092:	53                   	push   %ebx
  800093:	83 ec 10             	sub    $0x10,%esp
  800096:	e8 f0 ff ff ff       	call   80008b <__x86.get_pc_thunk.bx>
  80009b:	81 c3 65 1f 00 00    	add    $0x1f65,%ebx
	sys_env_destroy(0);
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 45 00 00 00       	call   8000ed <sys_env_destroy>
}
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ae:	c9                   	leave  
  8000af:	c3                   	ret    

008000b0 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c1:	89 c3                	mov    %eax,%ebx
  8000c3:	89 c7                	mov    %eax,%edi
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    

008000ce <sys_cgetc>:

int
sys_cgetc(void) {
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000de:	89 d1                	mov    %edx,%ecx
  8000e0:	89 d3                	mov    %edx,%ebx
  8000e2:	89 d7                	mov    %edx,%edi
  8000e4:	89 d6                	mov    %edx,%esi
  8000e6:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e8:	5b                   	pop    %ebx
  8000e9:	5e                   	pop    %esi
  8000ea:	5f                   	pop    %edi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	57                   	push   %edi
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	83 ec 1c             	sub    $0x1c,%esp
  8000f6:	e8 66 00 00 00       	call   800161 <__x86.get_pc_thunk.ax>
  8000fb:	05 05 1f 00 00       	add    $0x1f05,%eax
  800100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile("int %1\n"
  800103:	b9 00 00 00 00       	mov    $0x0,%ecx
  800108:	8b 55 08             	mov    0x8(%ebp),%edx
  80010b:	b8 03 00 00 00       	mov    $0x3,%eax
  800110:	89 cb                	mov    %ecx,%ebx
  800112:	89 cf                	mov    %ecx,%edi
  800114:	89 ce                	mov    %ecx,%esi
  800116:	cd 30                	int    $0x30
    if (check && ret > 0)
  800118:	85 c0                	test   %eax,%eax
  80011a:	7f 08                	jg     800124 <sys_env_destroy+0x37>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5f                   	pop    %edi
  800122:	5d                   	pop    %ebp
  800123:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	6a 03                	push   $0x3
  80012a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80012d:	8d 83 96 ee ff ff    	lea    -0x116a(%ebx),%eax
  800133:	50                   	push   %eax
  800134:	6a 24                	push   $0x24
  800136:	8d 83 b3 ee ff ff    	lea    -0x114d(%ebx),%eax
  80013c:	50                   	push   %eax
  80013d:	e8 23 00 00 00       	call   800165 <_panic>

00800142 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
    asm volatile("int %1\n"
  800148:	ba 00 00 00 00       	mov    $0x0,%edx
  80014d:	b8 02 00 00 00       	mov    $0x2,%eax
  800152:	89 d1                	mov    %edx,%ecx
  800154:	89 d3                	mov    %edx,%ebx
  800156:	89 d7                	mov    %edx,%edi
  800158:	89 d6                	mov    %edx,%esi
  80015a:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015c:	5b                   	pop    %ebx
  80015d:	5e                   	pop    %esi
  80015e:	5f                   	pop    %edi
  80015f:	5d                   	pop    %ebp
  800160:	c3                   	ret    

00800161 <__x86.get_pc_thunk.ax>:
  800161:	8b 04 24             	mov    (%esp),%eax
  800164:	c3                   	ret    

00800165 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	57                   	push   %edi
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	e8 18 ff ff ff       	call   80008b <__x86.get_pc_thunk.bx>
  800173:	81 c3 8d 1e 00 00    	add    $0x1e8d,%ebx
	va_list ap;

	va_start(ap, fmt);
  800179:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80017c:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800182:	8b 38                	mov    (%eax),%edi
  800184:	e8 b9 ff ff ff       	call   800142 <sys_getenvid>
  800189:	83 ec 0c             	sub    $0xc,%esp
  80018c:	ff 75 0c             	pushl  0xc(%ebp)
  80018f:	ff 75 08             	pushl  0x8(%ebp)
  800192:	57                   	push   %edi
  800193:	50                   	push   %eax
  800194:	8d 83 c4 ee ff ff    	lea    -0x113c(%ebx),%eax
  80019a:	50                   	push   %eax
  80019b:	e8 d1 00 00 00       	call   800271 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a0:	83 c4 18             	add    $0x18,%esp
  8001a3:	56                   	push   %esi
  8001a4:	ff 75 10             	pushl  0x10(%ebp)
  8001a7:	e8 63 00 00 00       	call   80020f <vcprintf>
	cprintf("\n");
  8001ac:	8d 83 e8 ee ff ff    	lea    -0x1118(%ebx),%eax
  8001b2:	89 04 24             	mov    %eax,(%esp)
  8001b5:	e8 b7 00 00 00       	call   800271 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001bd:	cc                   	int3   
  8001be:	eb fd                	jmp    8001bd <_panic+0x58>

008001c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	e8 c1 fe ff ff       	call   80008b <__x86.get_pc_thunk.bx>
  8001ca:	81 c3 36 1e 00 00    	add    $0x1e36,%ebx
  8001d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001d3:	8b 16                	mov    (%esi),%edx
  8001d5:	8d 42 01             	lea    0x1(%edx),%eax
  8001d8:	89 06                	mov    %eax,(%esi)
  8001da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001dd:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  8001e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e6:	74 0b                	je     8001f3 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e8:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ef:	5b                   	pop    %ebx
  8001f0:	5e                   	pop    %esi
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	68 ff 00 00 00       	push   $0xff
  8001fb:	8d 46 08             	lea    0x8(%esi),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 ac fe ff ff       	call   8000b0 <sys_cputs>
		b->idx = 0;
  800204:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	eb d9                	jmp    8001e8 <putch+0x28>

0080020f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	53                   	push   %ebx
  800213:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800219:	e8 6d fe ff ff       	call   80008b <__x86.get_pc_thunk.bx>
  80021e:	81 c3 e2 1d 00 00    	add    $0x1de2,%ebx
	struct printbuf b;

	b.idx = 0;
  800224:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022b:	00 00 00 
	b.cnt = 0;
  80022e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800235:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800244:	50                   	push   %eax
  800245:	8d 83 c0 e1 ff ff    	lea    -0x1e40(%ebx),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 38 01 00 00       	call   800389 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800251:	83 c4 08             	add    $0x8,%esp
  800254:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800260:	50                   	push   %eax
  800261:	e8 4a fe ff ff       	call   8000b0 <sys_cputs>

	return b.cnt;
}
  800266:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800277:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027a:	50                   	push   %eax
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	e8 8c ff ff ff       	call   80020f <vcprintf>
	va_end(ap);

	return cnt;
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	57                   	push   %edi
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
  80028b:	83 ec 2c             	sub    $0x2c,%esp
  80028e:	e8 3a 06 00 00       	call   8008cd <__x86.get_pc_thunk.cx>
  800293:	81 c1 6d 1d 00 00    	add    $0x1d6d,%ecx
  800299:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80029c:	89 c7                	mov    %eax,%edi
  80029e:	89 d6                	mov    %edx,%esi
  8002a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8002ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8002b7:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8002ba:	39 d3                	cmp    %edx,%ebx
  8002bc:	72 09                	jb     8002c7 <printnum+0x42>
  8002be:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002c1:	0f 87 83 00 00 00    	ja     80034a <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	ff 75 18             	pushl  0x18(%ebp)
  8002cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002d3:	53                   	push   %ebx
  8002d4:	ff 75 10             	pushl  0x10(%ebp)
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002e3:	ff 75 d0             	pushl  -0x30(%ebp)
  8002e6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002e9:	e8 62 09 00 00       	call   800c50 <__udivdi3>
  8002ee:	83 c4 18             	add    $0x18,%esp
  8002f1:	52                   	push   %edx
  8002f2:	50                   	push   %eax
  8002f3:	89 f2                	mov    %esi,%edx
  8002f5:	89 f8                	mov    %edi,%eax
  8002f7:	e8 89 ff ff ff       	call   800285 <printnum>
  8002fc:	83 c4 20             	add    $0x20,%esp
  8002ff:	eb 13                	jmp    800314 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	56                   	push   %esi
  800305:	ff 75 18             	pushl  0x18(%ebp)
  800308:	ff d7                	call   *%edi
  80030a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80030d:	83 eb 01             	sub    $0x1,%ebx
  800310:	85 db                	test   %ebx,%ebx
  800312:	7f ed                	jg     800301 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	56                   	push   %esi
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	ff 75 dc             	pushl  -0x24(%ebp)
  80031e:	ff 75 d8             	pushl  -0x28(%ebp)
  800321:	ff 75 d4             	pushl  -0x2c(%ebp)
  800324:	ff 75 d0             	pushl  -0x30(%ebp)
  800327:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80032a:	89 f3                	mov    %esi,%ebx
  80032c:	e8 3f 0a 00 00       	call   800d70 <__umoddi3>
  800331:	83 c4 14             	add    $0x14,%esp
  800334:	0f be 84 06 ea ee ff 	movsbl -0x1116(%esi,%eax,1),%eax
  80033b:	ff 
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
  80034d:	eb be                	jmp    80030d <printnum+0x88>

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
  800392:	e8 f4 fc ff ff       	call   80008b <__x86.get_pc_thunk.bx>
  800397:	81 c3 69 1c 00 00    	add    $0x1c69,%ebx
  80039d:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a3:	e9 fb 03 00 00       	jmp    8007a3 <.L35+0x48>
		padc = ' ';
  8003a8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003b3:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
  8003ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c6:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8d 47 01             	lea    0x1(%edi),%eax
  8003cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cf:	0f b6 17             	movzbl (%edi),%edx
  8003d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d5:	3c 55                	cmp    $0x55,%al
  8003d7:	0f 87 4e 04 00 00    	ja     80082b <.L22>
  8003dd:	0f b6 c0             	movzbl %al,%eax
  8003e0:	89 d9                	mov    %ebx,%ecx
  8003e2:	03 8c 83 78 ef ff ff 	add    -0x1088(%ebx,%eax,4),%ecx
  8003e9:	ff e1                	jmp    *%ecx

008003eb <.L71>:
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ee:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003f2:	eb d5                	jmp    8003c9 <vprintfmt+0x40>

008003f4 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003fb:	eb cc                	jmp    8003c9 <vprintfmt+0x40>

008003fd <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	0f b6 d2             	movzbl %dl,%edx
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800403:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800408:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80040b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80040f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800412:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800415:	83 f9 09             	cmp    $0x9,%ecx
  800418:	77 55                	ja     80046f <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  80041a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80041d:	eb e9                	jmp    800408 <.L29+0xb>

0080041f <.L26>:
			precision = va_arg(ap, int);
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 40 04             	lea    0x4(%eax),%eax
  80042d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800430:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800433:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800437:	79 90                	jns    8003c9 <vprintfmt+0x40>
				width = precision, precision = -1;
  800439:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80043c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800446:	eb 81                	jmp    8003c9 <vprintfmt+0x40>

00800448 <.L27>:
  800448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044b:	85 c0                	test   %eax,%eax
  80044d:	ba 00 00 00 00       	mov    $0x0,%edx
  800452:	0f 49 d0             	cmovns %eax,%edx
  800455:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80045b:	e9 69 ff ff ff       	jmp    8003c9 <vprintfmt+0x40>

00800460 <.L23>:
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800463:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80046a:	e9 5a ff ff ff       	jmp    8003c9 <vprintfmt+0x40>
  80046f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800472:	eb bf                	jmp    800433 <.L26+0x14>

00800474 <.L33>:
			lflag++;
  800474:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047b:	e9 49 ff ff ff       	jmp    8003c9 <vprintfmt+0x40>

00800480 <.L30>:
			putch(va_arg(ap, int), putdat);
  800480:	8b 45 14             	mov    0x14(%ebp),%eax
  800483:	8d 78 04             	lea    0x4(%eax),%edi
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	56                   	push   %esi
  80048a:	ff 30                	pushl  (%eax)
  80048c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80048f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800492:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800495:	e9 06 03 00 00       	jmp    8007a0 <.L35+0x45>

0080049a <.L32>:
			err = va_arg(ap, int);
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8d 78 04             	lea    0x4(%eax),%edi
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	99                   	cltd   
  8004a3:	31 d0                	xor    %edx,%eax
  8004a5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a7:	83 f8 06             	cmp    $0x6,%eax
  8004aa:	7f 27                	jg     8004d3 <.L32+0x39>
  8004ac:	8b 94 83 10 00 00 00 	mov    0x10(%ebx,%eax,4),%edx
  8004b3:	85 d2                	test   %edx,%edx
  8004b5:	74 1c                	je     8004d3 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  8004b7:	52                   	push   %edx
  8004b8:	8d 83 0b ef ff ff    	lea    -0x10f5(%ebx),%eax
  8004be:	50                   	push   %eax
  8004bf:	56                   	push   %esi
  8004c0:	ff 75 08             	pushl  0x8(%ebp)
  8004c3:	e8 a4 fe ff ff       	call   80036c <printfmt>
  8004c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004cb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ce:	e9 cd 02 00 00       	jmp    8007a0 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  8004d3:	50                   	push   %eax
  8004d4:	8d 83 02 ef ff ff    	lea    -0x10fe(%ebx),%eax
  8004da:	50                   	push   %eax
  8004db:	56                   	push   %esi
  8004dc:	ff 75 08             	pushl  0x8(%ebp)
  8004df:	e8 88 fe ff ff       	call   80036c <printfmt>
  8004e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ea:	e9 b1 02 00 00       	jmp    8007a0 <.L35+0x45>

008004ef <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	83 c0 04             	add    $0x4,%eax
  8004f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004fd:	85 ff                	test   %edi,%edi
  8004ff:	8d 83 fb ee ff ff    	lea    -0x1105(%ebx),%eax
  800505:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800508:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050c:	0f 8e b5 00 00 00    	jle    8005c7 <.L36+0xd8>
  800512:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800516:	75 08                	jne    800520 <.L36+0x31>
  800518:	89 75 0c             	mov    %esi,0xc(%ebp)
  80051b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80051e:	eb 6d                	jmp    80058d <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 cc             	pushl  -0x34(%ebp)
  800526:	57                   	push   %edi
  800527:	e8 bd 03 00 00       	call   8008e9 <strnlen>
  80052c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052f:	29 c2                	sub    %eax,%edx
  800531:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800534:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800537:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80053b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800541:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800543:	eb 10                	jmp    800555 <.L36+0x66>
					putch(padc, putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	56                   	push   %esi
  800549:	ff 75 e0             	pushl  -0x20(%ebp)
  80054c:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80054f:	83 ef 01             	sub    $0x1,%edi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	85 ff                	test   %edi,%edi
  800557:	7f ec                	jg     800545 <.L36+0x56>
  800559:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80055c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	b8 00 00 00 00       	mov    $0x0,%eax
  800566:	0f 49 c2             	cmovns %edx,%eax
  800569:	29 c2                	sub    %eax,%edx
  80056b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80056e:	89 75 0c             	mov    %esi,0xc(%ebp)
  800571:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800574:	eb 17                	jmp    80058d <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800576:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80057a:	75 30                	jne    8005ac <.L36+0xbd>
					putch(ch, putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	ff 55 08             	call   *0x8(%ebp)
  800586:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800589:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80058d:	83 c7 01             	add    $0x1,%edi
  800590:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800594:	0f be c2             	movsbl %dl,%eax
  800597:	85 c0                	test   %eax,%eax
  800599:	74 52                	je     8005ed <.L36+0xfe>
  80059b:	85 f6                	test   %esi,%esi
  80059d:	78 d7                	js     800576 <.L36+0x87>
  80059f:	83 ee 01             	sub    $0x1,%esi
  8005a2:	79 d2                	jns    800576 <.L36+0x87>
  8005a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005aa:	eb 32                	jmp    8005de <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ac:	0f be d2             	movsbl %dl,%edx
  8005af:	83 ea 20             	sub    $0x20,%edx
  8005b2:	83 fa 5e             	cmp    $0x5e,%edx
  8005b5:	76 c5                	jbe    80057c <.L36+0x8d>
					putch('?', putdat);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	ff 75 0c             	pushl  0xc(%ebp)
  8005bd:	6a 3f                	push   $0x3f
  8005bf:	ff 55 08             	call   *0x8(%ebp)
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	eb c2                	jmp    800589 <.L36+0x9a>
  8005c7:	89 75 0c             	mov    %esi,0xc(%ebp)
  8005ca:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005cd:	eb be                	jmp    80058d <.L36+0x9e>
				putch(' ', putdat);
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	56                   	push   %esi
  8005d3:	6a 20                	push   $0x20
  8005d5:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  8005d8:	83 ef 01             	sub    $0x1,%edi
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	85 ff                	test   %edi,%edi
  8005e0:	7f ed                	jg     8005cf <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	e9 b3 01 00 00       	jmp    8007a0 <.L35+0x45>
  8005ed:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005f3:	eb e9                	jmp    8005de <.L36+0xef>

008005f5 <.L31>:
  8005f5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 40                	jle    80063d <.L31+0x48>
		return va_arg(*ap, long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 50 04             	mov    0x4(%eax),%edx
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800614:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800618:	79 55                	jns    80066f <.L31+0x7a>
				putch('-', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	56                   	push   %esi
  80061e:	6a 2d                	push   $0x2d
  800620:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800623:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800626:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800629:	f7 da                	neg    %edx
  80062b:	83 d1 00             	adc    $0x0,%ecx
  80062e:	f7 d9                	neg    %ecx
  800630:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800633:	b8 0a 00 00 00       	mov    $0xa,%eax
  800638:	e9 48 01 00 00       	jmp    800785 <.L35+0x2a>
	else if (lflag)
  80063d:	85 c9                	test   %ecx,%ecx
  80063f:	75 17                	jne    800658 <.L31+0x63>
		return va_arg(*ap, int);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800649:	99                   	cltd   
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
  800656:	eb bc                	jmp    800614 <.L31+0x1f>
		return va_arg(*ap, long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	99                   	cltd   
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	eb a5                	jmp    800614 <.L31+0x1f>
			num = getint(&ap, lflag);
  80066f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800672:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800675:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067a:	e9 06 01 00 00       	jmp    800785 <.L35+0x2a>

0080067f <.L37>:
  80067f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  800682:	83 f9 01             	cmp    $0x1,%ecx
  800685:	7e 18                	jle    80069f <.L37+0x20>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 10                	mov    (%eax),%edx
  80068c:	8b 48 04             	mov    0x4(%eax),%ecx
  80068f:	8d 40 08             	lea    0x8(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800695:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069a:	e9 e6 00 00 00       	jmp    800785 <.L35+0x2a>
	else if (lflag)
  80069f:	85 c9                	test   %ecx,%ecx
  8006a1:	75 1a                	jne    8006bd <.L37+0x3e>
		return va_arg(*ap, unsigned int);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 10                	mov    (%eax),%edx
  8006a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b8:	e9 c8 00 00 00       	jmp    800785 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d2:	e9 ae 00 00 00       	jmp    800785 <.L35+0x2a>

008006d7 <.L34>:
  8006d7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8006da:	83 f9 01             	cmp    $0x1,%ecx
  8006dd:	7e 3d                	jle    80071c <.L34+0x45>
		return va_arg(*ap, long long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 50 04             	mov    0x4(%eax),%edx
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 40 08             	lea    0x8(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  8006f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006fa:	79 52                	jns    80074e <.L34+0x77>
                putch('-', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	56                   	push   %esi
  800700:	6a 2d                	push   $0x2d
  800702:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
  800705:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800708:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80070b:	f7 da                	neg    %edx
  80070d:	83 d1 00             	adc    $0x0,%ecx
  800710:	f7 d9                	neg    %ecx
  800712:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800715:	b8 08 00 00 00       	mov    $0x8,%eax
  80071a:	eb 69                	jmp    800785 <.L35+0x2a>
	else if (lflag)
  80071c:	85 c9                	test   %ecx,%ecx
  80071e:	75 17                	jne    800737 <.L34+0x60>
		return va_arg(*ap, int);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800728:	99                   	cltd   
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	eb bf                	jmp    8006f6 <.L34+0x1f>
		return va_arg(*ap, long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	99                   	cltd   
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	eb a8                	jmp    8006f6 <.L34+0x1f>
            num = getint(&ap, lflag);
  80074e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800751:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800754:	b8 08 00 00 00       	mov    $0x8,%eax
  800759:	eb 2a                	jmp    800785 <.L35+0x2a>

0080075b <.L35>:
			putch('0', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	56                   	push   %esi
  80075f:	6a 30                	push   $0x30
  800761:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800764:	83 c4 08             	add    $0x8,%esp
  800767:	56                   	push   %esi
  800768:	6a 78                	push   $0x78
  80076a:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 10                	mov    (%eax),%edx
  800772:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800777:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800780:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800785:	83 ec 0c             	sub    $0xc,%esp
  800788:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80078c:	57                   	push   %edi
  80078d:	ff 75 e0             	pushl  -0x20(%ebp)
  800790:	50                   	push   %eax
  800791:	51                   	push   %ecx
  800792:	52                   	push   %edx
  800793:	89 f2                	mov    %esi,%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	e8 e8 fa ff ff       	call   800285 <printnum>
			break;
  80079d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a3:	83 c7 01             	add    $0x1,%edi
  8007a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007aa:	83 f8 25             	cmp    $0x25,%eax
  8007ad:	0f 84 f5 fb ff ff    	je     8003a8 <vprintfmt+0x1f>
			if (ch == '\0')
  8007b3:	85 c0                	test   %eax,%eax
  8007b5:	0f 84 91 00 00 00    	je     80084c <.L22+0x21>
			putch(ch, putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	56                   	push   %esi
  8007bf:	50                   	push   %eax
  8007c0:	ff 55 08             	call   *0x8(%ebp)
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	eb db                	jmp    8007a3 <.L35+0x48>

008007c8 <.L38>:
  8007c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
  8007cb:	83 f9 01             	cmp    $0x1,%ecx
  8007ce:	7e 15                	jle    8007e5 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 10                	mov    (%eax),%edx
  8007d5:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d8:	8d 40 08             	lea    0x8(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e3:	eb a0                	jmp    800785 <.L35+0x2a>
	else if (lflag)
  8007e5:	85 c9                	test   %ecx,%ecx
  8007e7:	75 17                	jne    800800 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 10                	mov    (%eax),%edx
  8007ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f3:	8d 40 04             	lea    0x4(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fe:	eb 85                	jmp    800785 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800810:	b8 10 00 00 00       	mov    $0x10,%eax
  800815:	e9 6b ff ff ff       	jmp    800785 <.L35+0x2a>

0080081a <.L25>:
			putch(ch, putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	56                   	push   %esi
  80081e:	6a 25                	push   $0x25
  800820:	ff 55 08             	call   *0x8(%ebp)
			break;
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	e9 75 ff ff ff       	jmp    8007a0 <.L35+0x45>

0080082b <.L22>:
			putch('%', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	56                   	push   %esi
  80082f:	6a 25                	push   $0x25
  800831:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	89 f8                	mov    %edi,%eax
  800839:	eb 03                	jmp    80083e <.L22+0x13>
  80083b:	83 e8 01             	sub    $0x1,%eax
  80083e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800842:	75 f7                	jne    80083b <.L22+0x10>
  800844:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800847:	e9 54 ff ff ff       	jmp    8007a0 <.L35+0x45>
}
  80084c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80084f:	5b                   	pop    %ebx
  800850:	5e                   	pop    %esi
  800851:	5f                   	pop    %edi
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	53                   	push   %ebx
  800858:	83 ec 14             	sub    $0x14,%esp
  80085b:	e8 2b f8 ff ff       	call   80008b <__x86.get_pc_thunk.bx>
  800860:	81 c3 a0 17 00 00    	add    $0x17a0,%ebx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800873:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800876:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80087d:	85 c0                	test   %eax,%eax
  80087f:	74 2b                	je     8008ac <vsnprintf+0x58>
  800881:	85 d2                	test   %edx,%edx
  800883:	7e 27                	jle    8008ac <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800885:	ff 75 14             	pushl  0x14(%ebp)
  800888:	ff 75 10             	pushl  0x10(%ebp)
  80088b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088e:	50                   	push   %eax
  80088f:	8d 83 4f e3 ff ff    	lea    -0x1cb1(%ebx),%eax
  800895:	50                   	push   %eax
  800896:	e8 ee fa ff ff       	call   800389 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80089b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a4:	83 c4 10             	add    $0x10,%esp
}
  8008a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    
		return -E_INVAL;
  8008ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b1:	eb f4                	jmp    8008a7 <vsnprintf+0x53>

008008b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 10             	pushl  0x10(%ebp)
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 89 ff ff ff       	call   800854 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <__x86.get_pc_thunk.cx>:
  8008cd:	8b 0c 24             	mov    (%esp),%ecx
  8008d0:	c3                   	ret    

008008d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	eb 03                	jmp    8008e1 <strlen+0x10>
		n++;
  8008de:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008e1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e5:	75 f7                	jne    8008de <strlen+0xd>
	return n;
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f7:	eb 03                	jmp    8008fc <strnlen+0x13>
		n++;
  8008f9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fc:	39 d0                	cmp    %edx,%eax
  8008fe:	74 06                	je     800906 <strnlen+0x1d>
  800900:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800904:	75 f3                	jne    8008f9 <strnlen+0x10>
	return n;
}
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	53                   	push   %ebx
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800912:	89 c2                	mov    %eax,%edx
  800914:	83 c1 01             	add    $0x1,%ecx
  800917:	83 c2 01             	add    $0x1,%edx
  80091a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80091e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800921:	84 db                	test   %bl,%bl
  800923:	75 ef                	jne    800914 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800925:	5b                   	pop    %ebx
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	53                   	push   %ebx
  80092c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092f:	53                   	push   %ebx
  800930:	e8 9c ff ff ff       	call   8008d1 <strlen>
  800935:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	01 d8                	add    %ebx,%eax
  80093d:	50                   	push   %eax
  80093e:	e8 c5 ff ff ff       	call   800908 <strcpy>
	return dst;
}
  800943:	89 d8                	mov    %ebx,%eax
  800945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	56                   	push   %esi
  80094e:	53                   	push   %ebx
  80094f:	8b 75 08             	mov    0x8(%ebp),%esi
  800952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800955:	89 f3                	mov    %esi,%ebx
  800957:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80095a:	89 f2                	mov    %esi,%edx
  80095c:	eb 0f                	jmp    80096d <strncpy+0x23>
		*dst++ = *src;
  80095e:	83 c2 01             	add    $0x1,%edx
  800961:	0f b6 01             	movzbl (%ecx),%eax
  800964:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800967:	80 39 01             	cmpb   $0x1,(%ecx)
  80096a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80096d:	39 da                	cmp    %ebx,%edx
  80096f:	75 ed                	jne    80095e <strncpy+0x14>
	}
	return ret;
}
  800971:	89 f0                	mov    %esi,%eax
  800973:	5b                   	pop    %ebx
  800974:	5e                   	pop    %esi
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	56                   	push   %esi
  80097b:	53                   	push   %ebx
  80097c:	8b 75 08             	mov    0x8(%ebp),%esi
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800985:	89 f0                	mov    %esi,%eax
  800987:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098b:	85 c9                	test   %ecx,%ecx
  80098d:	75 0b                	jne    80099a <strlcpy+0x23>
  80098f:	eb 17                	jmp    8009a8 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	83 c0 01             	add    $0x1,%eax
  800997:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80099a:	39 d8                	cmp    %ebx,%eax
  80099c:	74 07                	je     8009a5 <strlcpy+0x2e>
  80099e:	0f b6 0a             	movzbl (%edx),%ecx
  8009a1:	84 c9                	test   %cl,%cl
  8009a3:	75 ec                	jne    800991 <strlcpy+0x1a>
		*dst = '\0';
  8009a5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a8:	29 f0                	sub    %esi,%eax
}
  8009aa:	5b                   	pop    %ebx
  8009ab:	5e                   	pop    %esi
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b7:	eb 06                	jmp    8009bf <strcmp+0x11>
		p++, q++;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009bf:	0f b6 01             	movzbl (%ecx),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 04                	je     8009ca <strcmp+0x1c>
  8009c6:	3a 02                	cmp    (%edx),%al
  8009c8:	74 ef                	je     8009b9 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ca:	0f b6 c0             	movzbl %al,%eax
  8009cd:	0f b6 12             	movzbl (%edx),%edx
  8009d0:	29 d0                	sub    %edx,%eax
}
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	53                   	push   %ebx
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009de:	89 c3                	mov    %eax,%ebx
  8009e0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e3:	eb 06                	jmp    8009eb <strncmp+0x17>
		n--, p++, q++;
  8009e5:	83 c0 01             	add    $0x1,%eax
  8009e8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009eb:	39 d8                	cmp    %ebx,%eax
  8009ed:	74 16                	je     800a05 <strncmp+0x31>
  8009ef:	0f b6 08             	movzbl (%eax),%ecx
  8009f2:	84 c9                	test   %cl,%cl
  8009f4:	74 04                	je     8009fa <strncmp+0x26>
  8009f6:	3a 0a                	cmp    (%edx),%cl
  8009f8:	74 eb                	je     8009e5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fa:	0f b6 00             	movzbl (%eax),%eax
  8009fd:	0f b6 12             	movzbl (%edx),%edx
  800a00:	29 d0                	sub    %edx,%eax
}
  800a02:	5b                   	pop    %ebx
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    
		return 0;
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0a:	eb f6                	jmp    800a02 <strncmp+0x2e>

00800a0c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a16:	0f b6 10             	movzbl (%eax),%edx
  800a19:	84 d2                	test   %dl,%dl
  800a1b:	74 09                	je     800a26 <strchr+0x1a>
		if (*s == c)
  800a1d:	38 ca                	cmp    %cl,%dl
  800a1f:	74 0a                	je     800a2b <strchr+0x1f>
	for (; *s; s++)
  800a21:	83 c0 01             	add    $0x1,%eax
  800a24:	eb f0                	jmp    800a16 <strchr+0xa>
			return (char *) s;
	return 0;
  800a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a37:	eb 03                	jmp    800a3c <strfind+0xf>
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a3f:	38 ca                	cmp    %cl,%dl
  800a41:	74 04                	je     800a47 <strfind+0x1a>
  800a43:	84 d2                	test   %dl,%dl
  800a45:	75 f2                	jne    800a39 <strfind+0xc>
			break;
	return (char *) s;
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	57                   	push   %edi
  800a4d:	56                   	push   %esi
  800a4e:	53                   	push   %ebx
  800a4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a52:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a55:	85 c9                	test   %ecx,%ecx
  800a57:	74 13                	je     800a6c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a59:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5f:	75 05                	jne    800a66 <memset+0x1d>
  800a61:	f6 c1 03             	test   $0x3,%cl
  800a64:	74 0d                	je     800a73 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	fc                   	cld    
  800a6a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6c:	89 f8                	mov    %edi,%eax
  800a6e:	5b                   	pop    %ebx
  800a6f:	5e                   	pop    %esi
  800a70:	5f                   	pop    %edi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    
		c &= 0xFF;
  800a73:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a77:	89 d3                	mov    %edx,%ebx
  800a79:	c1 e3 08             	shl    $0x8,%ebx
  800a7c:	89 d0                	mov    %edx,%eax
  800a7e:	c1 e0 18             	shl    $0x18,%eax
  800a81:	89 d6                	mov    %edx,%esi
  800a83:	c1 e6 10             	shl    $0x10,%esi
  800a86:	09 f0                	or     %esi,%eax
  800a88:	09 c2                	or     %eax,%edx
  800a8a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a8c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8f:	89 d0                	mov    %edx,%eax
  800a91:	fc                   	cld    
  800a92:	f3 ab                	rep stos %eax,%es:(%edi)
  800a94:	eb d6                	jmp    800a6c <memset+0x23>

00800a96 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa4:	39 c6                	cmp    %eax,%esi
  800aa6:	73 35                	jae    800add <memmove+0x47>
  800aa8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aab:	39 c2                	cmp    %eax,%edx
  800aad:	76 2e                	jbe    800add <memmove+0x47>
		s += n;
		d += n;
  800aaf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab2:	89 d6                	mov    %edx,%esi
  800ab4:	09 fe                	or     %edi,%esi
  800ab6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800abc:	74 0c                	je     800aca <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abe:	83 ef 01             	sub    $0x1,%edi
  800ac1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac4:	fd                   	std    
  800ac5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac7:	fc                   	cld    
  800ac8:	eb 21                	jmp    800aeb <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aca:	f6 c1 03             	test   $0x3,%cl
  800acd:	75 ef                	jne    800abe <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800acf:	83 ef 04             	sub    $0x4,%edi
  800ad2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad8:	fd                   	std    
  800ad9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800adb:	eb ea                	jmp    800ac7 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800add:	89 f2                	mov    %esi,%edx
  800adf:	09 c2                	or     %eax,%edx
  800ae1:	f6 c2 03             	test   $0x3,%dl
  800ae4:	74 09                	je     800aef <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae6:	89 c7                	mov    %eax,%edi
  800ae8:	fc                   	cld    
  800ae9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aef:	f6 c1 03             	test   $0x3,%cl
  800af2:	75 f2                	jne    800ae6 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af7:	89 c7                	mov    %eax,%edi
  800af9:	fc                   	cld    
  800afa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afc:	eb ed                	jmp    800aeb <memmove+0x55>

00800afe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b01:	ff 75 10             	pushl  0x10(%ebp)
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	ff 75 08             	pushl  0x8(%ebp)
  800b0a:	e8 87 ff ff ff       	call   800a96 <memmove>
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 c6                	mov    %eax,%esi
  800b1e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b21:	39 f0                	cmp    %esi,%eax
  800b23:	74 1c                	je     800b41 <memcmp+0x30>
		if (*s1 != *s2)
  800b25:	0f b6 08             	movzbl (%eax),%ecx
  800b28:	0f b6 1a             	movzbl (%edx),%ebx
  800b2b:	38 d9                	cmp    %bl,%cl
  800b2d:	75 08                	jne    800b37 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b2f:	83 c0 01             	add    $0x1,%eax
  800b32:	83 c2 01             	add    $0x1,%edx
  800b35:	eb ea                	jmp    800b21 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b37:	0f b6 c1             	movzbl %cl,%eax
  800b3a:	0f b6 db             	movzbl %bl,%ebx
  800b3d:	29 d8                	sub    %ebx,%eax
  800b3f:	eb 05                	jmp    800b46 <memcmp+0x35>
	}

	return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b58:	39 d0                	cmp    %edx,%eax
  800b5a:	73 09                	jae    800b65 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5c:	38 08                	cmp    %cl,(%eax)
  800b5e:	74 05                	je     800b65 <memfind+0x1b>
	for (; s < ends; s++)
  800b60:	83 c0 01             	add    $0x1,%eax
  800b63:	eb f3                	jmp    800b58 <memfind+0xe>
			break;
	return (void *) s;
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b73:	eb 03                	jmp    800b78 <strtol+0x11>
		s++;
  800b75:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b78:	0f b6 01             	movzbl (%ecx),%eax
  800b7b:	3c 20                	cmp    $0x20,%al
  800b7d:	74 f6                	je     800b75 <strtol+0xe>
  800b7f:	3c 09                	cmp    $0x9,%al
  800b81:	74 f2                	je     800b75 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b83:	3c 2b                	cmp    $0x2b,%al
  800b85:	74 2e                	je     800bb5 <strtol+0x4e>
	int neg = 0;
  800b87:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8c:	3c 2d                	cmp    $0x2d,%al
  800b8e:	74 2f                	je     800bbf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b90:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b96:	75 05                	jne    800b9d <strtol+0x36>
  800b98:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9b:	74 2c                	je     800bc9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b9d:	85 db                	test   %ebx,%ebx
  800b9f:	75 0a                	jne    800bab <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba1:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ba6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba9:	74 28                	je     800bd3 <strtol+0x6c>
		base = 10;
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb3:	eb 50                	jmp    800c05 <strtol+0x9e>
		s++;
  800bb5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb8:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbd:	eb d1                	jmp    800b90 <strtol+0x29>
		s++, neg = 1;
  800bbf:	83 c1 01             	add    $0x1,%ecx
  800bc2:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc7:	eb c7                	jmp    800b90 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bcd:	74 0e                	je     800bdd <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bcf:	85 db                	test   %ebx,%ebx
  800bd1:	75 d8                	jne    800bab <strtol+0x44>
		s++, base = 8;
  800bd3:	83 c1 01             	add    $0x1,%ecx
  800bd6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bdb:	eb ce                	jmp    800bab <strtol+0x44>
		s += 2, base = 16;
  800bdd:	83 c1 02             	add    $0x2,%ecx
  800be0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be5:	eb c4                	jmp    800bab <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bea:	89 f3                	mov    %esi,%ebx
  800bec:	80 fb 19             	cmp    $0x19,%bl
  800bef:	77 29                	ja     800c1a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf1:	0f be d2             	movsbl %dl,%edx
  800bf4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bfa:	7d 30                	jge    800c2c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bfc:	83 c1 01             	add    $0x1,%ecx
  800bff:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c03:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c05:	0f b6 11             	movzbl (%ecx),%edx
  800c08:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0b:	89 f3                	mov    %esi,%ebx
  800c0d:	80 fb 09             	cmp    $0x9,%bl
  800c10:	77 d5                	ja     800be7 <strtol+0x80>
			dig = *s - '0';
  800c12:	0f be d2             	movsbl %dl,%edx
  800c15:	83 ea 30             	sub    $0x30,%edx
  800c18:	eb dd                	jmp    800bf7 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c1a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1d:	89 f3                	mov    %esi,%ebx
  800c1f:	80 fb 19             	cmp    $0x19,%bl
  800c22:	77 08                	ja     800c2c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c24:	0f be d2             	movsbl %dl,%edx
  800c27:	83 ea 37             	sub    $0x37,%edx
  800c2a:	eb cb                	jmp    800bf7 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c30:	74 05                	je     800c37 <strtol+0xd0>
		*endptr = (char *) s;
  800c32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c35:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c37:	89 c2                	mov    %eax,%edx
  800c39:	f7 da                	neg    %edx
  800c3b:	85 ff                	test   %edi,%edi
  800c3d:	0f 45 c2             	cmovne %edx,%eax
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    
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
