
obj/user/dumbfork：     文件格式 elf32-i386


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
  80002c:	e8 c6 01 00 00       	call   8001f7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 37 0d 00 00       	call   800d81 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 60 0d 00 00       	call   800dc4 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 98 0a 00 00       	call   800b16 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 79 0d 00 00       	call   800e06 <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 80 11 80 00       	push   $0x801180
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 93 11 80 00       	push   $0x801193
  8000a8:	e8 a2 01 00 00       	call   80024f <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 a3 11 80 00       	push   $0x8011a3
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 93 11 80 00       	push   $0x801193
  8000ba:	e8 90 01 00 00       	call   80024f <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 b4 11 80 00       	push   $0x8011b4
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 93 11 80 00       	push   $0x801193
  8000cc:	e8 7e 01 00 00       	call   80024f <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 18             	sub    $0x18,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
  8000e2:	89 c6                	mov    %eax,%esi
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
    cprintf("env index id:%d\n",  ENVX(envid));
  8000e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 c7 11 80 00       	push   $0x8011c7
  8000ef:	e8 36 02 00 00       	call   80032a <cprintf>
	if (envid < 0)
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	85 db                	test   %ebx,%ebx
  8000f9:	78 0d                	js     800108 <dumbfork+0x37>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000fb:	85 db                	test   %ebx,%ebx
  8000fd:	74 1b                	je     80011a <dumbfork+0x49>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ff:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800106:	eb 4f                	jmp    800157 <dumbfork+0x86>
		panic("sys_exofork: %e", envid);
  800108:	53                   	push   %ebx
  800109:	68 d8 11 80 00       	push   $0x8011d8
  80010e:	6a 38                	push   $0x38
  800110:	68 93 11 80 00       	push   $0x801193
  800115:	e8 35 01 00 00       	call   80024f <_panic>
        cprintf("child env goo\n");
  80011a:	83 ec 0c             	sub    $0xc,%esp
  80011d:	68 e8 11 80 00       	push   $0x8011e8
  800122:	e8 03 02 00 00       	call   80032a <cprintf>
		thisenv = &envs[ENVX(sys_getenvid())];
  800127:	e8 17 0c 00 00       	call   800d43 <sys_getenvid>
  80012c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800131:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800134:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800139:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	eb 43                	jmp    800186 <dumbfork+0xb5>
		duppage(envid, addr);
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	52                   	push   %edx
  800147:	56                   	push   %esi
  800148:	e8 e6 fe ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80014d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80015a:	81 fa 08 20 80 00    	cmp    $0x802008,%edx
  800160:	72 e1                	jb     800143 <dumbfork+0x72>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800168:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016d:	50                   	push   %eax
  80016e:	53                   	push   %ebx
  80016f:	e8 bf fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800174:	83 c4 08             	add    $0x8,%esp
  800177:	6a 02                	push   $0x2
  800179:	53                   	push   %ebx
  80017a:	e8 c9 0c 00 00       	call   800e48 <sys_env_set_status>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	78 09                	js     80018f <dumbfork+0xbe>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800186:	89 d8                	mov    %ebx,%eax
  800188:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80018f:	50                   	push   %eax
  800190:	68 f7 11 80 00       	push   $0x8011f7
  800195:	6a 4e                	push   $0x4e
  800197:	68 93 11 80 00       	push   $0x801193
  80019c:	e8 ae 00 00 00       	call   80024f <_panic>

008001a1 <umain>:
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  8001aa:	e8 22 ff ff ff       	call   8000d1 <dumbfork>
  8001af:	89 c7                	mov    %eax,%edi
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	be 0e 12 80 00       	mov    $0x80120e,%esi
  8001b8:	b8 15 12 80 00       	mov    $0x801215,%eax
  8001bd:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c5:	eb 1f                	jmp    8001e6 <umain+0x45>
  8001c7:	83 fb 13             	cmp    $0x13,%ebx
  8001ca:	7f 23                	jg     8001ef <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001cc:	83 ec 04             	sub    $0x4,%esp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	68 1b 12 80 00       	push   $0x80121b
  8001d6:	e8 4f 01 00 00       	call   80032a <cprintf>
		sys_yield();
  8001db:	e8 82 0b 00 00       	call   800d62 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001e0:	83 c3 01             	add    $0x1,%ebx
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	85 ff                	test   %edi,%edi
  8001e8:	74 dd                	je     8001c7 <umain+0x26>
  8001ea:	83 fb 09             	cmp    $0x9,%ebx
  8001ed:	7e dd                	jle    8001cc <umain+0x2b>
}
  8001ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f2:	5b                   	pop    %ebx
  8001f3:	5e                   	pop    %esi
  8001f4:	5f                   	pop    %edi
  8001f5:	5d                   	pop    %ebp
  8001f6:	c3                   	ret    

008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	56                   	push   %esi
  8001fb:	53                   	push   %ebx
  8001fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800202:	e8 3c 0b 00 00       	call   800d43 <sys_getenvid>
  800207:	25 ff 03 00 00       	and    $0x3ff,%eax
  80020c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800214:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800219:	85 db                	test   %ebx,%ebx
  80021b:	7e 07                	jle    800224 <libmain+0x2d>
		binaryname = argv[0];
  80021d:	8b 06                	mov    (%esi),%eax
  80021f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	e8 73 ff ff ff       	call   8001a1 <umain>

	// exit gracefully
	exit();
  80022e:	e8 0a 00 00 00       	call   80023d <exit>
}
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800239:	5b                   	pop    %ebx
  80023a:	5e                   	pop    %esi
  80023b:	5d                   	pop    %ebp
  80023c:	c3                   	ret    

0080023d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800243:	6a 00                	push   $0x0
  800245:	e8 b8 0a 00 00       	call   800d02 <sys_env_destroy>
}
  80024a:	83 c4 10             	add    $0x10,%esp
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800254:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800257:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80025d:	e8 e1 0a 00 00       	call   800d43 <sys_getenvid>
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	ff 75 0c             	pushl  0xc(%ebp)
  800268:	ff 75 08             	pushl  0x8(%ebp)
  80026b:	56                   	push   %esi
  80026c:	50                   	push   %eax
  80026d:	68 38 12 80 00       	push   $0x801238
  800272:	e8 b3 00 00 00       	call   80032a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800277:	83 c4 18             	add    $0x18,%esp
  80027a:	53                   	push   %ebx
  80027b:	ff 75 10             	pushl  0x10(%ebp)
  80027e:	e8 56 00 00 00       	call   8002d9 <vcprintf>
	cprintf("\n");
  800283:	c7 04 24 2b 12 80 00 	movl   $0x80122b,(%esp)
  80028a:	e8 9b 00 00 00       	call   80032a <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800292:	cc                   	int3   
  800293:	eb fd                	jmp    800292 <_panic+0x43>

00800295 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	53                   	push   %ebx
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029f:	8b 13                	mov    (%ebx),%edx
  8002a1:	8d 42 01             	lea    0x1(%edx),%eax
  8002a4:	89 03                	mov    %eax,(%ebx)
  8002a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b2:	74 09                	je     8002bd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	68 ff 00 00 00       	push   $0xff
  8002c5:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c8:	50                   	push   %eax
  8002c9:	e8 f7 09 00 00       	call   800cc5 <sys_cputs>
		b->idx = 0;
  8002ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	eb db                	jmp    8002b4 <putch+0x1f>

008002d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e9:	00 00 00 
	b.cnt = 0;
  8002ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	68 95 02 80 00       	push   $0x800295
  800308:	e8 1a 01 00 00       	call   800427 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030d:	83 c4 08             	add    $0x8,%esp
  800310:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800316:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031c:	50                   	push   %eax
  80031d:	e8 a3 09 00 00       	call   800cc5 <sys_cputs>

	return b.cnt;
}
  800322:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800330:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800333:	50                   	push   %eax
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 9d ff ff ff       	call   8002d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
  800344:	83 ec 1c             	sub    $0x1c,%esp
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 d6                	mov    %edx,%esi
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800351:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800354:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800357:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80035a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800362:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800365:	39 d3                	cmp    %edx,%ebx
  800367:	72 05                	jb     80036e <printnum+0x30>
  800369:	39 45 10             	cmp    %eax,0x10(%ebp)
  80036c:	77 7a                	ja     8003e8 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	ff 75 18             	pushl  0x18(%ebp)
  800374:	8b 45 14             	mov    0x14(%ebp),%eax
  800377:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037a:	53                   	push   %ebx
  80037b:	ff 75 10             	pushl  0x10(%ebp)
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	ff 75 e4             	pushl  -0x1c(%ebp)
  800384:	ff 75 e0             	pushl  -0x20(%ebp)
  800387:	ff 75 dc             	pushl  -0x24(%ebp)
  80038a:	ff 75 d8             	pushl  -0x28(%ebp)
  80038d:	e8 9e 0b 00 00       	call   800f30 <__udivdi3>
  800392:	83 c4 18             	add    $0x18,%esp
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	89 f2                	mov    %esi,%edx
  800399:	89 f8                	mov    %edi,%eax
  80039b:	e8 9e ff ff ff       	call   80033e <printnum>
  8003a0:	83 c4 20             	add    $0x20,%esp
  8003a3:	eb 13                	jmp    8003b8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	56                   	push   %esi
  8003a9:	ff 75 18             	pushl  0x18(%ebp)
  8003ac:	ff d7                	call   *%edi
  8003ae:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b1:	83 eb 01             	sub    $0x1,%ebx
  8003b4:	85 db                	test   %ebx,%ebx
  8003b6:	7f ed                	jg     8003a5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	56                   	push   %esi
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cb:	e8 80 0c 00 00       	call   801050 <__umoddi3>
  8003d0:	83 c4 14             	add    $0x14,%esp
  8003d3:	0f be 80 5c 12 80 00 	movsbl 0x80125c(%eax),%eax
  8003da:	50                   	push   %eax
  8003db:	ff d7                	call   *%edi
}
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5e                   	pop    %esi
  8003e5:	5f                   	pop    %edi
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    
  8003e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003eb:	eb c4                	jmp    8003b1 <printnum+0x73>

008003ed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f7:	8b 10                	mov    (%eax),%edx
  8003f9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fc:	73 0a                	jae    800408 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800401:	89 08                	mov    %ecx,(%eax)
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	88 02                	mov    %al,(%edx)
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <printfmt>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800410:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800413:	50                   	push   %eax
  800414:	ff 75 10             	pushl  0x10(%ebp)
  800417:	ff 75 0c             	pushl  0xc(%ebp)
  80041a:	ff 75 08             	pushl  0x8(%ebp)
  80041d:	e8 05 00 00 00       	call   800427 <vprintfmt>
}
  800422:	83 c4 10             	add    $0x10,%esp
  800425:	c9                   	leave  
  800426:	c3                   	ret    

00800427 <vprintfmt>:
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	57                   	push   %edi
  80042b:	56                   	push   %esi
  80042c:	53                   	push   %ebx
  80042d:	83 ec 2c             	sub    $0x2c,%esp
  800430:	8b 75 08             	mov    0x8(%ebp),%esi
  800433:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800436:	8b 7d 10             	mov    0x10(%ebp),%edi
  800439:	e9 00 04 00 00       	jmp    80083e <vprintfmt+0x417>
		padc = ' ';
  80043e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800442:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800449:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800450:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800457:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045c:	8d 47 01             	lea    0x1(%edi),%eax
  80045f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800462:	0f b6 17             	movzbl (%edi),%edx
  800465:	8d 42 dd             	lea    -0x23(%edx),%eax
  800468:	3c 55                	cmp    $0x55,%al
  80046a:	0f 87 51 04 00 00    	ja     8008c1 <vprintfmt+0x49a>
  800470:	0f b6 c0             	movzbl %al,%eax
  800473:	ff 24 85 20 13 80 00 	jmp    *0x801320(,%eax,4)
  80047a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800481:	eb d9                	jmp    80045c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800483:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800486:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80048a:	eb d0                	jmp    80045c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80048c:	0f b6 d2             	movzbl %dl,%edx
  80048f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
  800497:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a7:	83 f9 09             	cmp    $0x9,%ecx
  8004aa:	77 55                	ja     800501 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004ac:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004af:	eb e9                	jmp    80049a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	8d 40 04             	lea    0x4(%eax),%eax
  8004bf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c9:	79 91                	jns    80045c <vprintfmt+0x35>
				width = precision, precision = -1;
  8004cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d8:	eb 82                	jmp    80045c <vprintfmt+0x35>
  8004da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e4:	0f 49 d0             	cmovns %eax,%edx
  8004e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ed:	e9 6a ff ff ff       	jmp    80045c <vprintfmt+0x35>
  8004f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004fc:	e9 5b ff ff ff       	jmp    80045c <vprintfmt+0x35>
  800501:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800504:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800507:	eb bc                	jmp    8004c5 <vprintfmt+0x9e>
			lflag++;
  800509:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050f:	e9 48 ff ff ff       	jmp    80045c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 78 04             	lea    0x4(%eax),%edi
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	53                   	push   %ebx
  80051e:	ff 30                	pushl  (%eax)
  800520:	ff d6                	call   *%esi
			break;
  800522:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800525:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800528:	e9 0e 03 00 00       	jmp    80083b <vprintfmt+0x414>
			err = va_arg(ap, int);
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 78 04             	lea    0x4(%eax),%edi
  800533:	8b 00                	mov    (%eax),%eax
  800535:	99                   	cltd   
  800536:	31 d0                	xor    %edx,%eax
  800538:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053a:	83 f8 08             	cmp    $0x8,%eax
  80053d:	7f 23                	jg     800562 <vprintfmt+0x13b>
  80053f:	8b 14 85 80 14 80 00 	mov    0x801480(,%eax,4),%edx
  800546:	85 d2                	test   %edx,%edx
  800548:	74 18                	je     800562 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80054a:	52                   	push   %edx
  80054b:	68 7d 12 80 00       	push   $0x80127d
  800550:	53                   	push   %ebx
  800551:	56                   	push   %esi
  800552:	e8 b3 fe ff ff       	call   80040a <printfmt>
  800557:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055d:	e9 d9 02 00 00       	jmp    80083b <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800562:	50                   	push   %eax
  800563:	68 74 12 80 00       	push   $0x801274
  800568:	53                   	push   %ebx
  800569:	56                   	push   %esi
  80056a:	e8 9b fe ff ff       	call   80040a <printfmt>
  80056f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800572:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800575:	e9 c1 02 00 00       	jmp    80083b <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 c0 04             	add    $0x4,%eax
  800580:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800588:	85 ff                	test   %edi,%edi
  80058a:	b8 6d 12 80 00       	mov    $0x80126d,%eax
  80058f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800592:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800596:	0f 8e bd 00 00 00    	jle    800659 <vprintfmt+0x232>
  80059c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005a0:	75 0e                	jne    8005b0 <vprintfmt+0x189>
  8005a2:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005ab:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ae:	eb 6d                	jmp    80061d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	ff 75 d0             	pushl  -0x30(%ebp)
  8005b6:	57                   	push   %edi
  8005b7:	e8 ad 03 00 00       	call   800969 <strnlen>
  8005bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bf:	29 c1                	sub    %eax,%ecx
  8005c1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005c4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005c7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d1:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d3:	eb 0f                	jmp    8005e4 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8005dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005de:	83 ef 01             	sub    $0x1,%edi
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	85 ff                	test   %edi,%edi
  8005e6:	7f ed                	jg     8005d5 <vprintfmt+0x1ae>
  8005e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005eb:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005ee:	85 c9                	test   %ecx,%ecx
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	0f 49 c1             	cmovns %ecx,%eax
  8005f8:	29 c1                	sub    %eax,%ecx
  8005fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8005fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800600:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800603:	89 cb                	mov    %ecx,%ebx
  800605:	eb 16                	jmp    80061d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800607:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060b:	75 31                	jne    80063e <vprintfmt+0x217>
					putch(ch, putdat);
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	ff 75 0c             	pushl  0xc(%ebp)
  800613:	50                   	push   %eax
  800614:	ff 55 08             	call   *0x8(%ebp)
  800617:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061a:	83 eb 01             	sub    $0x1,%ebx
  80061d:	83 c7 01             	add    $0x1,%edi
  800620:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800624:	0f be c2             	movsbl %dl,%eax
  800627:	85 c0                	test   %eax,%eax
  800629:	74 59                	je     800684 <vprintfmt+0x25d>
  80062b:	85 f6                	test   %esi,%esi
  80062d:	78 d8                	js     800607 <vprintfmt+0x1e0>
  80062f:	83 ee 01             	sub    $0x1,%esi
  800632:	79 d3                	jns    800607 <vprintfmt+0x1e0>
  800634:	89 df                	mov    %ebx,%edi
  800636:	8b 75 08             	mov    0x8(%ebp),%esi
  800639:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80063c:	eb 37                	jmp    800675 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80063e:	0f be d2             	movsbl %dl,%edx
  800641:	83 ea 20             	sub    $0x20,%edx
  800644:	83 fa 5e             	cmp    $0x5e,%edx
  800647:	76 c4                	jbe    80060d <vprintfmt+0x1e6>
					putch('?', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	6a 3f                	push   $0x3f
  800651:	ff 55 08             	call   *0x8(%ebp)
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	eb c1                	jmp    80061a <vprintfmt+0x1f3>
  800659:	89 75 08             	mov    %esi,0x8(%ebp)
  80065c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80065f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800662:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800665:	eb b6                	jmp    80061d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	6a 20                	push   $0x20
  80066d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066f:	83 ef 01             	sub    $0x1,%edi
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	85 ff                	test   %edi,%edi
  800677:	7f ee                	jg     800667 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800679:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
  80067f:	e9 b7 01 00 00       	jmp    80083b <vprintfmt+0x414>
  800684:	89 df                	mov    %ebx,%edi
  800686:	8b 75 08             	mov    0x8(%ebp),%esi
  800689:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80068c:	eb e7                	jmp    800675 <vprintfmt+0x24e>
	if (lflag >= 2)
  80068e:	83 f9 01             	cmp    $0x1,%ecx
  800691:	7e 3f                	jle    8006d2 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 50 04             	mov    0x4(%eax),%edx
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 08             	lea    0x8(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ae:	79 5c                	jns    80070c <vprintfmt+0x2e5>
				putch('-', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	6a 2d                	push   $0x2d
  8006b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006be:	f7 da                	neg    %edx
  8006c0:	83 d1 00             	adc    $0x0,%ecx
  8006c3:	f7 d9                	neg    %ecx
  8006c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cd:	e9 4f 01 00 00       	jmp    800821 <vprintfmt+0x3fa>
	else if (lflag)
  8006d2:	85 c9                	test   %ecx,%ecx
  8006d4:	75 1b                	jne    8006f1 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 c1                	mov    %eax,%ecx
  8006e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ef:	eb b9                	jmp    8006aa <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 c1                	mov    %eax,%ecx
  8006fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8006fe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
  80070a:	eb 9e                	jmp    8006aa <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80070c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80070f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
  800717:	e9 05 01 00 00       	jmp    800821 <vprintfmt+0x3fa>
	if (lflag >= 2)
  80071c:	83 f9 01             	cmp    $0x1,%ecx
  80071f:	7e 18                	jle    800739 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 10                	mov    (%eax),%edx
  800726:	8b 48 04             	mov    0x4(%eax),%ecx
  800729:	8d 40 08             	lea    0x8(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800734:	e9 e8 00 00 00       	jmp    800821 <vprintfmt+0x3fa>
	else if (lflag)
  800739:	85 c9                	test   %ecx,%ecx
  80073b:	75 1a                	jne    800757 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800752:	e9 ca 00 00 00       	jmp    800821 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 10                	mov    (%eax),%edx
  80075c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800767:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076c:	e9 b0 00 00 00       	jmp    800821 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800771:	83 f9 01             	cmp    $0x1,%ecx
  800774:	7e 3c                	jle    8007b2 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 50 04             	mov    0x4(%eax),%edx
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800781:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 08             	lea    0x8(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80078d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800791:	79 59                	jns    8007ec <vprintfmt+0x3c5>
                putch('-', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	6a 2d                	push   $0x2d
  800799:	ff d6                	call   *%esi
                num = -(long long) num;
  80079b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80079e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007a1:	f7 da                	neg    %edx
  8007a3:	83 d1 00             	adc    $0x0,%ecx
  8007a6:	f7 d9                	neg    %ecx
  8007a8:	83 c4 10             	add    $0x10,%esp
            base = 8;
  8007ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b0:	eb 6f                	jmp    800821 <vprintfmt+0x3fa>
	else if (lflag)
  8007b2:	85 c9                	test   %ecx,%ecx
  8007b4:	75 1b                	jne    8007d1 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	89 c1                	mov    %eax,%ecx
  8007c0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007c3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8d 40 04             	lea    0x4(%eax),%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cf:	eb bc                	jmp    80078d <vprintfmt+0x366>
		return va_arg(*ap, long);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d9:	89 c1                	mov    %eax,%ecx
  8007db:	c1 f9 1f             	sar    $0x1f,%ecx
  8007de:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8d 40 04             	lea    0x4(%eax),%eax
  8007e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ea:	eb a1                	jmp    80078d <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8007ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ef:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8007f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f7:	eb 28                	jmp    800821 <vprintfmt+0x3fa>
			putch('0', putdat);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	53                   	push   %ebx
  8007fd:	6a 30                	push   $0x30
  8007ff:	ff d6                	call   *%esi
			putch('x', putdat);
  800801:	83 c4 08             	add    $0x8,%esp
  800804:	53                   	push   %ebx
  800805:	6a 78                	push   $0x78
  800807:	ff d6                	call   *%esi
			num = (unsigned long long)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 10                	mov    (%eax),%edx
  80080e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800813:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800816:	8d 40 04             	lea    0x4(%eax),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800821:	83 ec 0c             	sub    $0xc,%esp
  800824:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800828:	57                   	push   %edi
  800829:	ff 75 e0             	pushl  -0x20(%ebp)
  80082c:	50                   	push   %eax
  80082d:	51                   	push   %ecx
  80082e:	52                   	push   %edx
  80082f:	89 da                	mov    %ebx,%edx
  800831:	89 f0                	mov    %esi,%eax
  800833:	e8 06 fb ff ff       	call   80033e <printnum>
			break;
  800838:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80083b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083e:	83 c7 01             	add    $0x1,%edi
  800841:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800845:	83 f8 25             	cmp    $0x25,%eax
  800848:	0f 84 f0 fb ff ff    	je     80043e <vprintfmt+0x17>
			if (ch == '\0')
  80084e:	85 c0                	test   %eax,%eax
  800850:	0f 84 8b 00 00 00    	je     8008e1 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	53                   	push   %ebx
  80085a:	50                   	push   %eax
  80085b:	ff d6                	call   *%esi
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	eb dc                	jmp    80083e <vprintfmt+0x417>
	if (lflag >= 2)
  800862:	83 f9 01             	cmp    $0x1,%ecx
  800865:	7e 15                	jle    80087c <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8b 10                	mov    (%eax),%edx
  80086c:	8b 48 04             	mov    0x4(%eax),%ecx
  80086f:	8d 40 08             	lea    0x8(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800875:	b8 10 00 00 00       	mov    $0x10,%eax
  80087a:	eb a5                	jmp    800821 <vprintfmt+0x3fa>
	else if (lflag)
  80087c:	85 c9                	test   %ecx,%ecx
  80087e:	75 17                	jne    800897 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8b 10                	mov    (%eax),%edx
  800885:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088a:	8d 40 04             	lea    0x4(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800890:	b8 10 00 00 00       	mov    $0x10,%eax
  800895:	eb 8a                	jmp    800821 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 10                	mov    (%eax),%edx
  80089c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a1:	8d 40 04             	lea    0x4(%eax),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a7:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ac:	e9 70 ff ff ff       	jmp    800821 <vprintfmt+0x3fa>
			putch(ch, putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	53                   	push   %ebx
  8008b5:	6a 25                	push   $0x25
  8008b7:	ff d6                	call   *%esi
			break;
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	e9 7a ff ff ff       	jmp    80083b <vprintfmt+0x414>
			putch('%', putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	53                   	push   %ebx
  8008c5:	6a 25                	push   $0x25
  8008c7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	89 f8                	mov    %edi,%eax
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x4ac>
  8008d0:	83 e8 01             	sub    $0x1,%eax
  8008d3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d7:	75 f7                	jne    8008d0 <vprintfmt+0x4a9>
  8008d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008dc:	e9 5a ff ff ff       	jmp    80083b <vprintfmt+0x414>
}
  8008e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5f                   	pop    %edi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 18             	sub    $0x18,%esp
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800906:	85 c0                	test   %eax,%eax
  800908:	74 26                	je     800930 <vsnprintf+0x47>
  80090a:	85 d2                	test   %edx,%edx
  80090c:	7e 22                	jle    800930 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090e:	ff 75 14             	pushl  0x14(%ebp)
  800911:	ff 75 10             	pushl  0x10(%ebp)
  800914:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800917:	50                   	push   %eax
  800918:	68 ed 03 80 00       	push   $0x8003ed
  80091d:	e8 05 fb ff ff       	call   800427 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800925:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092b:	83 c4 10             	add    $0x10,%esp
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    
		return -E_INVAL;
  800930:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800935:	eb f7                	jmp    80092e <vsnprintf+0x45>

00800937 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800940:	50                   	push   %eax
  800941:	ff 75 10             	pushl  0x10(%ebp)
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	ff 75 08             	pushl  0x8(%ebp)
  80094a:	e8 9a ff ff ff       	call   8008e9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094f:	c9                   	leave  
  800950:	c3                   	ret    

00800951 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800957:	b8 00 00 00 00       	mov    $0x0,%eax
  80095c:	eb 03                	jmp    800961 <strlen+0x10>
		n++;
  80095e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800961:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800965:	75 f7                	jne    80095e <strlen+0xd>
	return n;
}
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
  800977:	eb 03                	jmp    80097c <strnlen+0x13>
		n++;
  800979:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097c:	39 d0                	cmp    %edx,%eax
  80097e:	74 06                	je     800986 <strnlen+0x1d>
  800980:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800984:	75 f3                	jne    800979 <strnlen+0x10>
	return n;
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	53                   	push   %ebx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800992:	89 c2                	mov    %eax,%edx
  800994:	83 c1 01             	add    $0x1,%ecx
  800997:	83 c2 01             	add    $0x1,%edx
  80099a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80099e:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a1:	84 db                	test   %bl,%bl
  8009a3:	75 ef                	jne    800994 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009a5:	5b                   	pop    %ebx
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	53                   	push   %ebx
  8009ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009af:	53                   	push   %ebx
  8009b0:	e8 9c ff ff ff       	call   800951 <strlen>
  8009b5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	01 d8                	add    %ebx,%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 c5 ff ff ff       	call   800988 <strcpy>
	return dst;
}
  8009c3:	89 d8                	mov    %ebx,%eax
  8009c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	56                   	push   %esi
  8009ce:	53                   	push   %ebx
  8009cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d5:	89 f3                	mov    %esi,%ebx
  8009d7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009da:	89 f2                	mov    %esi,%edx
  8009dc:	eb 0f                	jmp    8009ed <strncpy+0x23>
		*dst++ = *src;
  8009de:	83 c2 01             	add    $0x1,%edx
  8009e1:	0f b6 01             	movzbl (%ecx),%eax
  8009e4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e7:	80 39 01             	cmpb   $0x1,(%ecx)
  8009ea:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009ed:	39 da                	cmp    %ebx,%edx
  8009ef:	75 ed                	jne    8009de <strncpy+0x14>
	}
	return ret;
}
  8009f1:	89 f0                	mov    %esi,%eax
  8009f3:	5b                   	pop    %ebx
  8009f4:	5e                   	pop    %esi
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	56                   	push   %esi
  8009fb:	53                   	push   %ebx
  8009fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a05:	89 f0                	mov    %esi,%eax
  800a07:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a0b:	85 c9                	test   %ecx,%ecx
  800a0d:	75 0b                	jne    800a1a <strlcpy+0x23>
  800a0f:	eb 17                	jmp    800a28 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a11:	83 c2 01             	add    $0x1,%edx
  800a14:	83 c0 01             	add    $0x1,%eax
  800a17:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a1a:	39 d8                	cmp    %ebx,%eax
  800a1c:	74 07                	je     800a25 <strlcpy+0x2e>
  800a1e:	0f b6 0a             	movzbl (%edx),%ecx
  800a21:	84 c9                	test   %cl,%cl
  800a23:	75 ec                	jne    800a11 <strlcpy+0x1a>
		*dst = '\0';
  800a25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a28:	29 f0                	sub    %esi,%eax
}
  800a2a:	5b                   	pop    %ebx
  800a2b:	5e                   	pop    %esi
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a37:	eb 06                	jmp    800a3f <strcmp+0x11>
		p++, q++;
  800a39:	83 c1 01             	add    $0x1,%ecx
  800a3c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a3f:	0f b6 01             	movzbl (%ecx),%eax
  800a42:	84 c0                	test   %al,%al
  800a44:	74 04                	je     800a4a <strcmp+0x1c>
  800a46:	3a 02                	cmp    (%edx),%al
  800a48:	74 ef                	je     800a39 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4a:	0f b6 c0             	movzbl %al,%eax
  800a4d:	0f b6 12             	movzbl (%edx),%edx
  800a50:	29 d0                	sub    %edx,%eax
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	53                   	push   %ebx
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5e:	89 c3                	mov    %eax,%ebx
  800a60:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a63:	eb 06                	jmp    800a6b <strncmp+0x17>
		n--, p++, q++;
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a6b:	39 d8                	cmp    %ebx,%eax
  800a6d:	74 16                	je     800a85 <strncmp+0x31>
  800a6f:	0f b6 08             	movzbl (%eax),%ecx
  800a72:	84 c9                	test   %cl,%cl
  800a74:	74 04                	je     800a7a <strncmp+0x26>
  800a76:	3a 0a                	cmp    (%edx),%cl
  800a78:	74 eb                	je     800a65 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7a:	0f b6 00             	movzbl (%eax),%eax
  800a7d:	0f b6 12             	movzbl (%edx),%edx
  800a80:	29 d0                	sub    %edx,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    
		return 0;
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8a:	eb f6                	jmp    800a82 <strncmp+0x2e>

00800a8c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a96:	0f b6 10             	movzbl (%eax),%edx
  800a99:	84 d2                	test   %dl,%dl
  800a9b:	74 09                	je     800aa6 <strchr+0x1a>
		if (*s == c)
  800a9d:	38 ca                	cmp    %cl,%dl
  800a9f:	74 0a                	je     800aab <strchr+0x1f>
	for (; *s; s++)
  800aa1:	83 c0 01             	add    $0x1,%eax
  800aa4:	eb f0                	jmp    800a96 <strchr+0xa>
			return (char *) s;
	return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab7:	eb 03                	jmp    800abc <strfind+0xf>
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800abf:	38 ca                	cmp    %cl,%dl
  800ac1:	74 04                	je     800ac7 <strfind+0x1a>
  800ac3:	84 d2                	test   %dl,%dl
  800ac5:	75 f2                	jne    800ab9 <strfind+0xc>
			break;
	return (char *) s;
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad5:	85 c9                	test   %ecx,%ecx
  800ad7:	74 13                	je     800aec <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800adf:	75 05                	jne    800ae6 <memset+0x1d>
  800ae1:	f6 c1 03             	test   $0x3,%cl
  800ae4:	74 0d                	je     800af3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	fc                   	cld    
  800aea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aec:	89 f8                	mov    %edi,%eax
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5f                   	pop    %edi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    
		c &= 0xFF;
  800af3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af7:	89 d3                	mov    %edx,%ebx
  800af9:	c1 e3 08             	shl    $0x8,%ebx
  800afc:	89 d0                	mov    %edx,%eax
  800afe:	c1 e0 18             	shl    $0x18,%eax
  800b01:	89 d6                	mov    %edx,%esi
  800b03:	c1 e6 10             	shl    $0x10,%esi
  800b06:	09 f0                	or     %esi,%eax
  800b08:	09 c2                	or     %eax,%edx
  800b0a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b0c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b0f:	89 d0                	mov    %edx,%eax
  800b11:	fc                   	cld    
  800b12:	f3 ab                	rep stos %eax,%es:(%edi)
  800b14:	eb d6                	jmp    800aec <memset+0x23>

00800b16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b24:	39 c6                	cmp    %eax,%esi
  800b26:	73 35                	jae    800b5d <memmove+0x47>
  800b28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	76 2e                	jbe    800b5d <memmove+0x47>
		s += n;
		d += n;
  800b2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	09 fe                	or     %edi,%esi
  800b36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3c:	74 0c                	je     800b4a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3e:	83 ef 01             	sub    $0x1,%edi
  800b41:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b44:	fd                   	std    
  800b45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b47:	fc                   	cld    
  800b48:	eb 21                	jmp    800b6b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4a:	f6 c1 03             	test   $0x3,%cl
  800b4d:	75 ef                	jne    800b3e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b4f:	83 ef 04             	sub    $0x4,%edi
  800b52:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b55:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b58:	fd                   	std    
  800b59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5b:	eb ea                	jmp    800b47 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5d:	89 f2                	mov    %esi,%edx
  800b5f:	09 c2                	or     %eax,%edx
  800b61:	f6 c2 03             	test   $0x3,%dl
  800b64:	74 09                	je     800b6f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b66:	89 c7                	mov    %eax,%edi
  800b68:	fc                   	cld    
  800b69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6b:	5e                   	pop    %esi
  800b6c:	5f                   	pop    %edi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6f:	f6 c1 03             	test   $0x3,%cl
  800b72:	75 f2                	jne    800b66 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b74:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b77:	89 c7                	mov    %eax,%edi
  800b79:	fc                   	cld    
  800b7a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7c:	eb ed                	jmp    800b6b <memmove+0x55>

00800b7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b81:	ff 75 10             	pushl  0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 87 ff ff ff       	call   800b16 <memmove>
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba1:	39 f0                	cmp    %esi,%eax
  800ba3:	74 1c                	je     800bc1 <memcmp+0x30>
		if (*s1 != *s2)
  800ba5:	0f b6 08             	movzbl (%eax),%ecx
  800ba8:	0f b6 1a             	movzbl (%edx),%ebx
  800bab:	38 d9                	cmp    %bl,%cl
  800bad:	75 08                	jne    800bb7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800baf:	83 c0 01             	add    $0x1,%eax
  800bb2:	83 c2 01             	add    $0x1,%edx
  800bb5:	eb ea                	jmp    800ba1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb7:	0f b6 c1             	movzbl %cl,%eax
  800bba:	0f b6 db             	movzbl %bl,%ebx
  800bbd:	29 d8                	sub    %ebx,%eax
  800bbf:	eb 05                	jmp    800bc6 <memcmp+0x35>
	}

	return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd3:	89 c2                	mov    %eax,%edx
  800bd5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd8:	39 d0                	cmp    %edx,%eax
  800bda:	73 09                	jae    800be5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bdc:	38 08                	cmp    %cl,(%eax)
  800bde:	74 05                	je     800be5 <memfind+0x1b>
	for (; s < ends; s++)
  800be0:	83 c0 01             	add    $0x1,%eax
  800be3:	eb f3                	jmp    800bd8 <memfind+0xe>
			break;
	return (void *) s;
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf3:	eb 03                	jmp    800bf8 <strtol+0x11>
		s++;
  800bf5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf8:	0f b6 01             	movzbl (%ecx),%eax
  800bfb:	3c 20                	cmp    $0x20,%al
  800bfd:	74 f6                	je     800bf5 <strtol+0xe>
  800bff:	3c 09                	cmp    $0x9,%al
  800c01:	74 f2                	je     800bf5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c03:	3c 2b                	cmp    $0x2b,%al
  800c05:	74 2e                	je     800c35 <strtol+0x4e>
	int neg = 0;
  800c07:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c0c:	3c 2d                	cmp    $0x2d,%al
  800c0e:	74 2f                	je     800c3f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c10:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c16:	75 05                	jne    800c1d <strtol+0x36>
  800c18:	80 39 30             	cmpb   $0x30,(%ecx)
  800c1b:	74 2c                	je     800c49 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c1d:	85 db                	test   %ebx,%ebx
  800c1f:	75 0a                	jne    800c2b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c21:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c26:	80 39 30             	cmpb   $0x30,(%ecx)
  800c29:	74 28                	je     800c53 <strtol+0x6c>
		base = 10;
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c33:	eb 50                	jmp    800c85 <strtol+0x9e>
		s++;
  800c35:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c38:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3d:	eb d1                	jmp    800c10 <strtol+0x29>
		s++, neg = 1;
  800c3f:	83 c1 01             	add    $0x1,%ecx
  800c42:	bf 01 00 00 00       	mov    $0x1,%edi
  800c47:	eb c7                	jmp    800c10 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c49:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4d:	74 0e                	je     800c5d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c4f:	85 db                	test   %ebx,%ebx
  800c51:	75 d8                	jne    800c2b <strtol+0x44>
		s++, base = 8;
  800c53:	83 c1 01             	add    $0x1,%ecx
  800c56:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c5b:	eb ce                	jmp    800c2b <strtol+0x44>
		s += 2, base = 16;
  800c5d:	83 c1 02             	add    $0x2,%ecx
  800c60:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c65:	eb c4                	jmp    800c2b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c67:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6a:	89 f3                	mov    %esi,%ebx
  800c6c:	80 fb 19             	cmp    $0x19,%bl
  800c6f:	77 29                	ja     800c9a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c71:	0f be d2             	movsbl %dl,%edx
  800c74:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c77:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7a:	7d 30                	jge    800cac <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c7c:	83 c1 01             	add    $0x1,%ecx
  800c7f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c83:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c85:	0f b6 11             	movzbl (%ecx),%edx
  800c88:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c8b:	89 f3                	mov    %esi,%ebx
  800c8d:	80 fb 09             	cmp    $0x9,%bl
  800c90:	77 d5                	ja     800c67 <strtol+0x80>
			dig = *s - '0';
  800c92:	0f be d2             	movsbl %dl,%edx
  800c95:	83 ea 30             	sub    $0x30,%edx
  800c98:	eb dd                	jmp    800c77 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c9a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9d:	89 f3                	mov    %esi,%ebx
  800c9f:	80 fb 19             	cmp    $0x19,%bl
  800ca2:	77 08                	ja     800cac <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ca4:	0f be d2             	movsbl %dl,%edx
  800ca7:	83 ea 37             	sub    $0x37,%edx
  800caa:	eb cb                	jmp    800c77 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb0:	74 05                	je     800cb7 <strtol+0xd0>
		*endptr = (char *) s;
  800cb2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb7:	89 c2                	mov    %eax,%edx
  800cb9:	f7 da                	neg    %edx
  800cbb:	85 ff                	test   %edi,%edi
  800cbd:	0f 45 c2             	cmovne %edx,%eax
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd6:	89 c3                	mov    %eax,%ebx
  800cd8:	89 c7                	mov    %eax,%edi
  800cda:	89 c6                	mov    %eax,%esi
  800cdc:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_cgetc>:

int
sys_cgetc(void) {
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	b8 03 00 00 00       	mov    $0x3,%eax
  800d18:	89 cb                	mov    %ecx,%ebx
  800d1a:	89 cf                	mov    %ecx,%edi
  800d1c:	89 ce                	mov    %ecx,%esi
  800d1e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7f 08                	jg     800d2c <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	50                   	push   %eax
  800d30:	6a 03                	push   $0x3
  800d32:	68 a4 14 80 00       	push   $0x8014a4
  800d37:	6a 24                	push   $0x24
  800d39:	68 c1 14 80 00       	push   $0x8014c1
  800d3e:	e8 0c f5 ff ff       	call   80024f <_panic>

00800d43 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d49:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d53:	89 d1                	mov    %edx,%ecx
  800d55:	89 d3                	mov    %edx,%ebx
  800d57:	89 d7                	mov    %edx,%edi
  800d59:	89 d6                	mov    %edx,%esi
  800d5b:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <sys_yield>:

void
sys_yield(void)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d68:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d72:	89 d1                	mov    %edx,%ecx
  800d74:	89 d3                	mov    %edx,%ebx
  800d76:	89 d7                	mov    %edx,%edi
  800d78:	89 d6                	mov    %edx,%esi
  800d7a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
  800d87:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d8a:	be 00 00 00 00       	mov    $0x0,%esi
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9d:	89 f7                	mov    %esi,%edi
  800d9f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 04                	push   $0x4
  800db3:	68 a4 14 80 00       	push   $0x8014a4
  800db8:	6a 24                	push   $0x24
  800dba:	68 c1 14 80 00       	push   $0x8014c1
  800dbf:	e8 8b f4 ff ff       	call   80024f <_panic>

00800dc4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dde:	8b 75 18             	mov    0x18(%ebp),%esi
  800de1:	cd 30                	int    $0x30
    if (check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7f 08                	jg     800def <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	50                   	push   %eax
  800df3:	6a 05                	push   $0x5
  800df5:	68 a4 14 80 00       	push   $0x8014a4
  800dfa:	6a 24                	push   $0x24
  800dfc:	68 c1 14 80 00       	push   $0x8014c1
  800e01:	e8 49 f4 ff ff       	call   80024f <_panic>

00800e06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1f:	89 df                	mov    %ebx,%edi
  800e21:	89 de                	mov    %ebx,%esi
  800e23:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e25:	85 c0                	test   %eax,%eax
  800e27:	7f 08                	jg     800e31 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2c:	5b                   	pop    %ebx
  800e2d:	5e                   	pop    %esi
  800e2e:	5f                   	pop    %edi
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e31:	83 ec 0c             	sub    $0xc,%esp
  800e34:	50                   	push   %eax
  800e35:	6a 06                	push   $0x6
  800e37:	68 a4 14 80 00       	push   $0x8014a4
  800e3c:	6a 24                	push   $0x24
  800e3e:	68 c1 14 80 00       	push   $0x8014c1
  800e43:	e8 07 f4 ff ff       	call   80024f <_panic>

00800e48 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
  800e4e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	b8 08 00 00 00       	mov    $0x8,%eax
  800e61:	89 df                	mov    %ebx,%edi
  800e63:	89 de                	mov    %ebx,%esi
  800e65:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7f 08                	jg     800e73 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	50                   	push   %eax
  800e77:	6a 08                	push   $0x8
  800e79:	68 a4 14 80 00       	push   $0x8014a4
  800e7e:	6a 24                	push   $0x24
  800e80:	68 c1 14 80 00       	push   $0x8014c1
  800e85:	e8 c5 f3 ff ff       	call   80024f <_panic>

00800e8a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea3:	89 df                	mov    %ebx,%edi
  800ea5:	89 de                	mov    %ebx,%esi
  800ea7:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	7f 08                	jg     800eb5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	50                   	push   %eax
  800eb9:	6a 09                	push   $0x9
  800ebb:	68 a4 14 80 00       	push   $0x8014a4
  800ec0:	6a 24                	push   $0x24
  800ec2:	68 c1 14 80 00       	push   $0x8014c1
  800ec7:	e8 83 f3 ff ff       	call   80024f <_panic>

00800ecc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
    asm volatile("int %1\n"
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800edd:	be 00 00 00 00       	mov    $0x0,%esi
  800ee2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f05:	89 cb                	mov    %ecx,%ebx
  800f07:	89 cf                	mov    %ecx,%edi
  800f09:	89 ce                	mov    %ecx,%esi
  800f0b:	cd 30                	int    $0x30
    if (check && ret > 0)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	7f 08                	jg     800f19 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800f19:	83 ec 0c             	sub    $0xc,%esp
  800f1c:	50                   	push   %eax
  800f1d:	6a 0c                	push   $0xc
  800f1f:	68 a4 14 80 00       	push   $0x8014a4
  800f24:	6a 24                	push   $0x24
  800f26:	68 c1 14 80 00       	push   $0x8014c1
  800f2b:	e8 1f f3 ff ff       	call   80024f <_panic>

00800f30 <__udivdi3>:
  800f30:	55                   	push   %ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 1c             	sub    $0x1c,%esp
  800f37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f47:	85 d2                	test   %edx,%edx
  800f49:	75 35                	jne    800f80 <__udivdi3+0x50>
  800f4b:	39 f3                	cmp    %esi,%ebx
  800f4d:	0f 87 bd 00 00 00    	ja     801010 <__udivdi3+0xe0>
  800f53:	85 db                	test   %ebx,%ebx
  800f55:	89 d9                	mov    %ebx,%ecx
  800f57:	75 0b                	jne    800f64 <__udivdi3+0x34>
  800f59:	b8 01 00 00 00       	mov    $0x1,%eax
  800f5e:	31 d2                	xor    %edx,%edx
  800f60:	f7 f3                	div    %ebx
  800f62:	89 c1                	mov    %eax,%ecx
  800f64:	31 d2                	xor    %edx,%edx
  800f66:	89 f0                	mov    %esi,%eax
  800f68:	f7 f1                	div    %ecx
  800f6a:	89 c6                	mov    %eax,%esi
  800f6c:	89 e8                	mov    %ebp,%eax
  800f6e:	89 f7                	mov    %esi,%edi
  800f70:	f7 f1                	div    %ecx
  800f72:	89 fa                	mov    %edi,%edx
  800f74:	83 c4 1c             	add    $0x1c,%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    
  800f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f80:	39 f2                	cmp    %esi,%edx
  800f82:	77 7c                	ja     801000 <__udivdi3+0xd0>
  800f84:	0f bd fa             	bsr    %edx,%edi
  800f87:	83 f7 1f             	xor    $0x1f,%edi
  800f8a:	0f 84 98 00 00 00    	je     801028 <__udivdi3+0xf8>
  800f90:	89 f9                	mov    %edi,%ecx
  800f92:	b8 20 00 00 00       	mov    $0x20,%eax
  800f97:	29 f8                	sub    %edi,%eax
  800f99:	d3 e2                	shl    %cl,%edx
  800f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f9f:	89 c1                	mov    %eax,%ecx
  800fa1:	89 da                	mov    %ebx,%edx
  800fa3:	d3 ea                	shr    %cl,%edx
  800fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800fa9:	09 d1                	or     %edx,%ecx
  800fab:	89 f2                	mov    %esi,%edx
  800fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fb1:	89 f9                	mov    %edi,%ecx
  800fb3:	d3 e3                	shl    %cl,%ebx
  800fb5:	89 c1                	mov    %eax,%ecx
  800fb7:	d3 ea                	shr    %cl,%edx
  800fb9:	89 f9                	mov    %edi,%ecx
  800fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fbf:	d3 e6                	shl    %cl,%esi
  800fc1:	89 eb                	mov    %ebp,%ebx
  800fc3:	89 c1                	mov    %eax,%ecx
  800fc5:	d3 eb                	shr    %cl,%ebx
  800fc7:	09 de                	or     %ebx,%esi
  800fc9:	89 f0                	mov    %esi,%eax
  800fcb:	f7 74 24 08          	divl   0x8(%esp)
  800fcf:	89 d6                	mov    %edx,%esi
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	f7 64 24 0c          	mull   0xc(%esp)
  800fd7:	39 d6                	cmp    %edx,%esi
  800fd9:	72 0c                	jb     800fe7 <__udivdi3+0xb7>
  800fdb:	89 f9                	mov    %edi,%ecx
  800fdd:	d3 e5                	shl    %cl,%ebp
  800fdf:	39 c5                	cmp    %eax,%ebp
  800fe1:	73 5d                	jae    801040 <__udivdi3+0x110>
  800fe3:	39 d6                	cmp    %edx,%esi
  800fe5:	75 59                	jne    801040 <__udivdi3+0x110>
  800fe7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fea:	31 ff                	xor    %edi,%edi
  800fec:	89 fa                	mov    %edi,%edx
  800fee:	83 c4 1c             	add    $0x1c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
  800ff6:	8d 76 00             	lea    0x0(%esi),%esi
  800ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801000:	31 ff                	xor    %edi,%edi
  801002:	31 c0                	xor    %eax,%eax
  801004:	89 fa                	mov    %edi,%edx
  801006:	83 c4 1c             	add    $0x1c,%esp
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5f                   	pop    %edi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    
  80100e:	66 90                	xchg   %ax,%ax
  801010:	31 ff                	xor    %edi,%edi
  801012:	89 e8                	mov    %ebp,%eax
  801014:	89 f2                	mov    %esi,%edx
  801016:	f7 f3                	div    %ebx
  801018:	89 fa                	mov    %edi,%edx
  80101a:	83 c4 1c             	add    $0x1c,%esp
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    
  801022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801028:	39 f2                	cmp    %esi,%edx
  80102a:	72 06                	jb     801032 <__udivdi3+0x102>
  80102c:	31 c0                	xor    %eax,%eax
  80102e:	39 eb                	cmp    %ebp,%ebx
  801030:	77 d2                	ja     801004 <__udivdi3+0xd4>
  801032:	b8 01 00 00 00       	mov    $0x1,%eax
  801037:	eb cb                	jmp    801004 <__udivdi3+0xd4>
  801039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801040:	89 d8                	mov    %ebx,%eax
  801042:	31 ff                	xor    %edi,%edi
  801044:	eb be                	jmp    801004 <__udivdi3+0xd4>
  801046:	66 90                	xchg   %ax,%ax
  801048:	66 90                	xchg   %ax,%ax
  80104a:	66 90                	xchg   %ax,%ax
  80104c:	66 90                	xchg   %ax,%ax
  80104e:	66 90                	xchg   %ax,%ax

00801050 <__umoddi3>:
  801050:	55                   	push   %ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
  801054:	83 ec 1c             	sub    $0x1c,%esp
  801057:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80105b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80105f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801067:	85 ed                	test   %ebp,%ebp
  801069:	89 f0                	mov    %esi,%eax
  80106b:	89 da                	mov    %ebx,%edx
  80106d:	75 19                	jne    801088 <__umoddi3+0x38>
  80106f:	39 df                	cmp    %ebx,%edi
  801071:	0f 86 b1 00 00 00    	jbe    801128 <__umoddi3+0xd8>
  801077:	f7 f7                	div    %edi
  801079:	89 d0                	mov    %edx,%eax
  80107b:	31 d2                	xor    %edx,%edx
  80107d:	83 c4 1c             	add    $0x1c,%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    
  801085:	8d 76 00             	lea    0x0(%esi),%esi
  801088:	39 dd                	cmp    %ebx,%ebp
  80108a:	77 f1                	ja     80107d <__umoddi3+0x2d>
  80108c:	0f bd cd             	bsr    %ebp,%ecx
  80108f:	83 f1 1f             	xor    $0x1f,%ecx
  801092:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801096:	0f 84 b4 00 00 00    	je     801150 <__umoddi3+0x100>
  80109c:	b8 20 00 00 00       	mov    $0x20,%eax
  8010a1:	89 c2                	mov    %eax,%edx
  8010a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010a7:	29 c2                	sub    %eax,%edx
  8010a9:	89 c1                	mov    %eax,%ecx
  8010ab:	89 f8                	mov    %edi,%eax
  8010ad:	d3 e5                	shl    %cl,%ebp
  8010af:	89 d1                	mov    %edx,%ecx
  8010b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8010b5:	d3 e8                	shr    %cl,%eax
  8010b7:	09 c5                	or     %eax,%ebp
  8010b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8010bd:	89 c1                	mov    %eax,%ecx
  8010bf:	d3 e7                	shl    %cl,%edi
  8010c1:	89 d1                	mov    %edx,%ecx
  8010c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8010c7:	89 df                	mov    %ebx,%edi
  8010c9:	d3 ef                	shr    %cl,%edi
  8010cb:	89 c1                	mov    %eax,%ecx
  8010cd:	89 f0                	mov    %esi,%eax
  8010cf:	d3 e3                	shl    %cl,%ebx
  8010d1:	89 d1                	mov    %edx,%ecx
  8010d3:	89 fa                	mov    %edi,%edx
  8010d5:	d3 e8                	shr    %cl,%eax
  8010d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010dc:	09 d8                	or     %ebx,%eax
  8010de:	f7 f5                	div    %ebp
  8010e0:	d3 e6                	shl    %cl,%esi
  8010e2:	89 d1                	mov    %edx,%ecx
  8010e4:	f7 64 24 08          	mull   0x8(%esp)
  8010e8:	39 d1                	cmp    %edx,%ecx
  8010ea:	89 c3                	mov    %eax,%ebx
  8010ec:	89 d7                	mov    %edx,%edi
  8010ee:	72 06                	jb     8010f6 <__umoddi3+0xa6>
  8010f0:	75 0e                	jne    801100 <__umoddi3+0xb0>
  8010f2:	39 c6                	cmp    %eax,%esi
  8010f4:	73 0a                	jae    801100 <__umoddi3+0xb0>
  8010f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8010fa:	19 ea                	sbb    %ebp,%edx
  8010fc:	89 d7                	mov    %edx,%edi
  8010fe:	89 c3                	mov    %eax,%ebx
  801100:	89 ca                	mov    %ecx,%edx
  801102:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801107:	29 de                	sub    %ebx,%esi
  801109:	19 fa                	sbb    %edi,%edx
  80110b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80110f:	89 d0                	mov    %edx,%eax
  801111:	d3 e0                	shl    %cl,%eax
  801113:	89 d9                	mov    %ebx,%ecx
  801115:	d3 ee                	shr    %cl,%esi
  801117:	d3 ea                	shr    %cl,%edx
  801119:	09 f0                	or     %esi,%eax
  80111b:	83 c4 1c             	add    $0x1c,%esp
  80111e:	5b                   	pop    %ebx
  80111f:	5e                   	pop    %esi
  801120:	5f                   	pop    %edi
  801121:	5d                   	pop    %ebp
  801122:	c3                   	ret    
  801123:	90                   	nop
  801124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801128:	85 ff                	test   %edi,%edi
  80112a:	89 f9                	mov    %edi,%ecx
  80112c:	75 0b                	jne    801139 <__umoddi3+0xe9>
  80112e:	b8 01 00 00 00       	mov    $0x1,%eax
  801133:	31 d2                	xor    %edx,%edx
  801135:	f7 f7                	div    %edi
  801137:	89 c1                	mov    %eax,%ecx
  801139:	89 d8                	mov    %ebx,%eax
  80113b:	31 d2                	xor    %edx,%edx
  80113d:	f7 f1                	div    %ecx
  80113f:	89 f0                	mov    %esi,%eax
  801141:	f7 f1                	div    %ecx
  801143:	e9 31 ff ff ff       	jmp    801079 <__umoddi3+0x29>
  801148:	90                   	nop
  801149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801150:	39 dd                	cmp    %ebx,%ebp
  801152:	72 08                	jb     80115c <__umoddi3+0x10c>
  801154:	39 f7                	cmp    %esi,%edi
  801156:	0f 87 21 ff ff ff    	ja     80107d <__umoddi3+0x2d>
  80115c:	89 da                	mov    %ebx,%edx
  80115e:	89 f0                	mov    %esi,%eax
  801160:	29 f8                	sub    %edi,%eax
  801162:	19 ea                	sbb    %ebp,%edx
  801164:	e9 14 ff ff ff       	jmp    80107d <__umoddi3+0x2d>
