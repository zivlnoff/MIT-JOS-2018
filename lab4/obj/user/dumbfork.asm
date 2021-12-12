
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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
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
  800045:	e8 04 0d 00 00       	call   800d4e <sys_page_alloc>
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
  80005f:	e8 2d 0d 00 00       	call   800d91 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 65 0a 00 00       	call   800ae3 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 46 0d 00 00       	call   800dd3 <sys_page_unmap>
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
  80009c:	68 40 11 80 00       	push   $0x801140
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 53 11 80 00       	push   $0x801153
  8000a8:	e8 6f 01 00 00       	call   80021c <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 63 11 80 00       	push   $0x801163
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 53 11 80 00       	push   $0x801153
  8000ba:	e8 5d 01 00 00       	call   80021c <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 74 11 80 00       	push   $0x801174
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 53 11 80 00       	push   $0x801153
  8000cc:	e8 4b 01 00 00       	call   80021c <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 0f                	js     8000f5 <dumbfork+0x24>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	74 1b                	je     800107 <dumbfork+0x36>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ec:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f3:	eb 3f                	jmp    800134 <dumbfork+0x63>
		panic("sys_exofork: %e", envid);
  8000f5:	50                   	push   %eax
  8000f6:	68 87 11 80 00       	push   $0x801187
  8000fb:	6a 37                	push   $0x37
  8000fd:	68 53 11 80 00       	push   $0x801153
  800102:	e8 15 01 00 00       	call   80021c <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800107:	e8 04 0c 00 00       	call   800d10 <sys_getenvid>
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800114:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800119:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80011e:	eb 43                	jmp    800163 <dumbfork+0x92>
		duppage(envid, addr);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	52                   	push   %edx
  800124:	56                   	push   %esi
  800125:	e8 09 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80012a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800137:	81 fa 08 20 80 00    	cmp    $0x802008,%edx
  80013d:	72 e1                	jb     800120 <dumbfork+0x4f>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800145:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014a:	50                   	push   %eax
  80014b:	53                   	push   %ebx
  80014c:	e8 e2 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800151:	83 c4 08             	add    $0x8,%esp
  800154:	6a 02                	push   $0x2
  800156:	53                   	push   %ebx
  800157:	e8 b9 0c 00 00       	call   800e15 <sys_env_set_status>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	85 c0                	test   %eax,%eax
  800161:	78 09                	js     80016c <dumbfork+0x9b>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800163:	89 d8                	mov    %ebx,%eax
  800165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016c:	50                   	push   %eax
  80016d:	68 97 11 80 00       	push   $0x801197
  800172:	6a 4c                	push   $0x4c
  800174:	68 53 11 80 00       	push   $0x801153
  800179:	e8 9e 00 00 00       	call   80021c <_panic>

0080017e <umain>:
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800187:	e8 45 ff ff ff       	call   8000d1 <dumbfork>
  80018c:	89 c7                	mov    %eax,%edi
  80018e:	85 c0                	test   %eax,%eax
  800190:	be ae 11 80 00       	mov    $0x8011ae,%esi
  800195:	b8 b5 11 80 00       	mov    $0x8011b5,%eax
  80019a:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a2:	eb 1f                	jmp    8001c3 <umain+0x45>
  8001a4:	83 fb 13             	cmp    $0x13,%ebx
  8001a7:	7f 23                	jg     8001cc <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	68 bb 11 80 00       	push   $0x8011bb
  8001b3:	e8 3f 01 00 00       	call   8002f7 <cprintf>
		sys_yield();
  8001b8:	e8 72 0b 00 00       	call   800d2f <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bd:	83 c3 01             	add    $0x1,%ebx
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 ff                	test   %edi,%edi
  8001c5:	74 dd                	je     8001a4 <umain+0x26>
  8001c7:	83 fb 09             	cmp    $0x9,%ebx
  8001ca:	7e dd                	jle    8001a9 <umain+0x2b>
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8001e0:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  8001e7:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	7e 08                	jle    8001f6 <libmain+0x22>
		binaryname = argv[0];
  8001ee:	8b 0a                	mov    (%edx),%ecx
  8001f0:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	52                   	push   %edx
  8001fa:	50                   	push   %eax
  8001fb:	e8 7e ff ff ff       	call   80017e <umain>

	// exit gracefully
	exit();
  800200:	e8 05 00 00 00       	call   80020a <exit>
}
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	c9                   	leave  
  800209:	c3                   	ret    

0080020a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800210:	6a 00                	push   $0x0
  800212:	e8 b8 0a 00 00       	call   800ccf <sys_env_destroy>
}
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800221:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800224:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80022a:	e8 e1 0a 00 00       	call   800d10 <sys_getenvid>
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	56                   	push   %esi
  800239:	50                   	push   %eax
  80023a:	68 d8 11 80 00       	push   $0x8011d8
  80023f:	e8 b3 00 00 00       	call   8002f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800244:	83 c4 18             	add    $0x18,%esp
  800247:	53                   	push   %ebx
  800248:	ff 75 10             	pushl  0x10(%ebp)
  80024b:	e8 56 00 00 00       	call   8002a6 <vcprintf>
	cprintf("\n");
  800250:	c7 04 24 cb 11 80 00 	movl   $0x8011cb,(%esp)
  800257:	e8 9b 00 00 00       	call   8002f7 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80025f:	cc                   	int3   
  800260:	eb fd                	jmp    80025f <_panic+0x43>

00800262 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	53                   	push   %ebx
  800266:	83 ec 04             	sub    $0x4,%esp
  800269:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80026c:	8b 13                	mov    (%ebx),%edx
  80026e:	8d 42 01             	lea    0x1(%edx),%eax
  800271:	89 03                	mov    %eax,(%ebx)
  800273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800276:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80027a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80027f:	74 09                	je     80028a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800281:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800288:	c9                   	leave  
  800289:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	68 ff 00 00 00       	push   $0xff
  800292:	8d 43 08             	lea    0x8(%ebx),%eax
  800295:	50                   	push   %eax
  800296:	e8 f7 09 00 00       	call   800c92 <sys_cputs>
		b->idx = 0;
  80029b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	eb db                	jmp    800281 <putch+0x1f>

008002a6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b6:	00 00 00 
	b.cnt = 0;
  8002b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cf:	50                   	push   %eax
  8002d0:	68 62 02 80 00       	push   $0x800262
  8002d5:	e8 1a 01 00 00       	call   8003f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002da:	83 c4 08             	add    $0x8,%esp
  8002dd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002e3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e9:	50                   	push   %eax
  8002ea:	e8 a3 09 00 00       	call   800c92 <sys_cputs>

	return b.cnt;
}
  8002ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800300:	50                   	push   %eax
  800301:	ff 75 08             	pushl  0x8(%ebp)
  800304:	e8 9d ff ff ff       	call   8002a6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	53                   	push   %ebx
  800311:	83 ec 1c             	sub    $0x1c,%esp
  800314:	89 c7                	mov    %eax,%edi
  800316:	89 d6                	mov    %edx,%esi
  800318:	8b 45 08             	mov    0x8(%ebp),%eax
  80031b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800321:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800324:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800327:	bb 00 00 00 00       	mov    $0x0,%ebx
  80032c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80032f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800332:	39 d3                	cmp    %edx,%ebx
  800334:	72 05                	jb     80033b <printnum+0x30>
  800336:	39 45 10             	cmp    %eax,0x10(%ebp)
  800339:	77 7a                	ja     8003b5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 18             	pushl  0x18(%ebp)
  800341:	8b 45 14             	mov    0x14(%ebp),%eax
  800344:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800347:	53                   	push   %ebx
  800348:	ff 75 10             	pushl  0x10(%ebp)
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	ff 75 e0             	pushl  -0x20(%ebp)
  800354:	ff 75 dc             	pushl  -0x24(%ebp)
  800357:	ff 75 d8             	pushl  -0x28(%ebp)
  80035a:	e8 a1 0b 00 00       	call   800f00 <__udivdi3>
  80035f:	83 c4 18             	add    $0x18,%esp
  800362:	52                   	push   %edx
  800363:	50                   	push   %eax
  800364:	89 f2                	mov    %esi,%edx
  800366:	89 f8                	mov    %edi,%eax
  800368:	e8 9e ff ff ff       	call   80030b <printnum>
  80036d:	83 c4 20             	add    $0x20,%esp
  800370:	eb 13                	jmp    800385 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	56                   	push   %esi
  800376:	ff 75 18             	pushl  0x18(%ebp)
  800379:	ff d7                	call   *%edi
  80037b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80037e:	83 eb 01             	sub    $0x1,%ebx
  800381:	85 db                	test   %ebx,%ebx
  800383:	7f ed                	jg     800372 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	56                   	push   %esi
  800389:	83 ec 04             	sub    $0x4,%esp
  80038c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038f:	ff 75 e0             	pushl  -0x20(%ebp)
  800392:	ff 75 dc             	pushl  -0x24(%ebp)
  800395:	ff 75 d8             	pushl  -0x28(%ebp)
  800398:	e8 83 0c 00 00       	call   801020 <__umoddi3>
  80039d:	83 c4 14             	add    $0x14,%esp
  8003a0:	0f be 80 fc 11 80 00 	movsbl 0x8011fc(%eax),%eax
  8003a7:	50                   	push   %eax
  8003a8:	ff d7                	call   *%edi
}
  8003aa:	83 c4 10             	add    $0x10,%esp
  8003ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b0:	5b                   	pop    %ebx
  8003b1:	5e                   	pop    %esi
  8003b2:	5f                   	pop    %edi
  8003b3:	5d                   	pop    %ebp
  8003b4:	c3                   	ret    
  8003b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003b8:	eb c4                	jmp    80037e <printnum+0x73>

008003ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c4:	8b 10                	mov    (%eax),%edx
  8003c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c9:	73 0a                	jae    8003d5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ce:	89 08                	mov    %ecx,(%eax)
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	88 02                	mov    %al,(%edx)
}
  8003d5:	5d                   	pop    %ebp
  8003d6:	c3                   	ret    

008003d7 <printfmt>:
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e0:	50                   	push   %eax
  8003e1:	ff 75 10             	pushl  0x10(%ebp)
  8003e4:	ff 75 0c             	pushl  0xc(%ebp)
  8003e7:	ff 75 08             	pushl  0x8(%ebp)
  8003ea:	e8 05 00 00 00       	call   8003f4 <vprintfmt>
}
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <vprintfmt>:
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	57                   	push   %edi
  8003f8:	56                   	push   %esi
  8003f9:	53                   	push   %ebx
  8003fa:	83 ec 2c             	sub    $0x2c,%esp
  8003fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800400:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800403:	8b 7d 10             	mov    0x10(%ebp),%edi
  800406:	e9 00 04 00 00       	jmp    80080b <vprintfmt+0x417>
		padc = ' ';
  80040b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80040f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800416:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80041d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800424:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800429:	8d 47 01             	lea    0x1(%edi),%eax
  80042c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042f:	0f b6 17             	movzbl (%edi),%edx
  800432:	8d 42 dd             	lea    -0x23(%edx),%eax
  800435:	3c 55                	cmp    $0x55,%al
  800437:	0f 87 51 04 00 00    	ja     80088e <vprintfmt+0x49a>
  80043d:	0f b6 c0             	movzbl %al,%eax
  800440:	ff 24 85 c0 12 80 00 	jmp    *0x8012c0(,%eax,4)
  800447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80044a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80044e:	eb d9                	jmp    800429 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800453:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800457:	eb d0                	jmp    800429 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800459:	0f b6 d2             	movzbl %dl,%edx
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045f:	b8 00 00 00 00       	mov    $0x0,%eax
  800464:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800467:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80046a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800471:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800474:	83 f9 09             	cmp    $0x9,%ecx
  800477:	77 55                	ja     8004ce <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800479:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80047c:	eb e9                	jmp    800467 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800486:	8b 45 14             	mov    0x14(%ebp),%eax
  800489:	8d 40 04             	lea    0x4(%eax),%eax
  80048c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800492:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800496:	79 91                	jns    800429 <vprintfmt+0x35>
				width = precision, precision = -1;
  800498:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80049b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004a5:	eb 82                	jmp    800429 <vprintfmt+0x35>
  8004a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004aa:	85 c0                	test   %eax,%eax
  8004ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b1:	0f 49 d0             	cmovns %eax,%edx
  8004b4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ba:	e9 6a ff ff ff       	jmp    800429 <vprintfmt+0x35>
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004c9:	e9 5b ff ff ff       	jmp    800429 <vprintfmt+0x35>
  8004ce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004d4:	eb bc                	jmp    800492 <vprintfmt+0x9e>
			lflag++;
  8004d6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004dc:	e9 48 ff ff ff       	jmp    800429 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 78 04             	lea    0x4(%eax),%edi
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	ff 30                	pushl  (%eax)
  8004ed:	ff d6                	call   *%esi
			break;
  8004ef:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004f2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f5:	e9 0e 03 00 00       	jmp    800808 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8d 78 04             	lea    0x4(%eax),%edi
  800500:	8b 00                	mov    (%eax),%eax
  800502:	99                   	cltd   
  800503:	31 d0                	xor    %edx,%eax
  800505:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800507:	83 f8 08             	cmp    $0x8,%eax
  80050a:	7f 23                	jg     80052f <vprintfmt+0x13b>
  80050c:	8b 14 85 20 14 80 00 	mov    0x801420(,%eax,4),%edx
  800513:	85 d2                	test   %edx,%edx
  800515:	74 18                	je     80052f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800517:	52                   	push   %edx
  800518:	68 1d 12 80 00       	push   $0x80121d
  80051d:	53                   	push   %ebx
  80051e:	56                   	push   %esi
  80051f:	e8 b3 fe ff ff       	call   8003d7 <printfmt>
  800524:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800527:	89 7d 14             	mov    %edi,0x14(%ebp)
  80052a:	e9 d9 02 00 00       	jmp    800808 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80052f:	50                   	push   %eax
  800530:	68 14 12 80 00       	push   $0x801214
  800535:	53                   	push   %ebx
  800536:	56                   	push   %esi
  800537:	e8 9b fe ff ff       	call   8003d7 <printfmt>
  80053c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800542:	e9 c1 02 00 00       	jmp    800808 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	83 c0 04             	add    $0x4,%eax
  80054d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800555:	85 ff                	test   %edi,%edi
  800557:	b8 0d 12 80 00       	mov    $0x80120d,%eax
  80055c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80055f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800563:	0f 8e bd 00 00 00    	jle    800626 <vprintfmt+0x232>
  800569:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80056d:	75 0e                	jne    80057d <vprintfmt+0x189>
  80056f:	89 75 08             	mov    %esi,0x8(%ebp)
  800572:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800575:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800578:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80057b:	eb 6d                	jmp    8005ea <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	ff 75 d0             	pushl  -0x30(%ebp)
  800583:	57                   	push   %edi
  800584:	e8 ad 03 00 00       	call   800936 <strnlen>
  800589:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80058c:	29 c1                	sub    %eax,%ecx
  80058e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800591:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800594:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80059e:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a0:	eb 0f                	jmp    8005b1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	53                   	push   %ebx
  8005a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ab:	83 ef 01             	sub    $0x1,%edi
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	85 ff                	test   %edi,%edi
  8005b3:	7f ed                	jg     8005a2 <vprintfmt+0x1ae>
  8005b5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005b8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005bb:	85 c9                	test   %ecx,%ecx
  8005bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c2:	0f 49 c1             	cmovns %ecx,%eax
  8005c5:	29 c1                	sub    %eax,%ecx
  8005c7:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ca:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005cd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005d0:	89 cb                	mov    %ecx,%ebx
  8005d2:	eb 16                	jmp    8005ea <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d8:	75 31                	jne    80060b <vprintfmt+0x217>
					putch(ch, putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	ff 75 0c             	pushl  0xc(%ebp)
  8005e0:	50                   	push   %eax
  8005e1:	ff 55 08             	call   *0x8(%ebp)
  8005e4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e7:	83 eb 01             	sub    $0x1,%ebx
  8005ea:	83 c7 01             	add    $0x1,%edi
  8005ed:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005f1:	0f be c2             	movsbl %dl,%eax
  8005f4:	85 c0                	test   %eax,%eax
  8005f6:	74 59                	je     800651 <vprintfmt+0x25d>
  8005f8:	85 f6                	test   %esi,%esi
  8005fa:	78 d8                	js     8005d4 <vprintfmt+0x1e0>
  8005fc:	83 ee 01             	sub    $0x1,%esi
  8005ff:	79 d3                	jns    8005d4 <vprintfmt+0x1e0>
  800601:	89 df                	mov    %ebx,%edi
  800603:	8b 75 08             	mov    0x8(%ebp),%esi
  800606:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800609:	eb 37                	jmp    800642 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80060b:	0f be d2             	movsbl %dl,%edx
  80060e:	83 ea 20             	sub    $0x20,%edx
  800611:	83 fa 5e             	cmp    $0x5e,%edx
  800614:	76 c4                	jbe    8005da <vprintfmt+0x1e6>
					putch('?', putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	6a 3f                	push   $0x3f
  80061e:	ff 55 08             	call   *0x8(%ebp)
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	eb c1                	jmp    8005e7 <vprintfmt+0x1f3>
  800626:	89 75 08             	mov    %esi,0x8(%ebp)
  800629:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80062c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80062f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800632:	eb b6                	jmp    8005ea <vprintfmt+0x1f6>
				putch(' ', putdat);
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	53                   	push   %ebx
  800638:	6a 20                	push   $0x20
  80063a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063c:	83 ef 01             	sub    $0x1,%edi
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	85 ff                	test   %edi,%edi
  800644:	7f ee                	jg     800634 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800646:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
  80064c:	e9 b7 01 00 00       	jmp    800808 <vprintfmt+0x414>
  800651:	89 df                	mov    %ebx,%edi
  800653:	8b 75 08             	mov    0x8(%ebp),%esi
  800656:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800659:	eb e7                	jmp    800642 <vprintfmt+0x24e>
	if (lflag >= 2)
  80065b:	83 f9 01             	cmp    $0x1,%ecx
  80065e:	7e 3f                	jle    80069f <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 50 04             	mov    0x4(%eax),%edx
  800666:	8b 00                	mov    (%eax),%eax
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 40 08             	lea    0x8(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800677:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067b:	79 5c                	jns    8006d9 <vprintfmt+0x2e5>
				putch('-', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 2d                	push   $0x2d
  800683:	ff d6                	call   *%esi
				num = -(long long) num;
  800685:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800688:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80068b:	f7 da                	neg    %edx
  80068d:	83 d1 00             	adc    $0x0,%ecx
  800690:	f7 d9                	neg    %ecx
  800692:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800695:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069a:	e9 4f 01 00 00       	jmp    8007ee <vprintfmt+0x3fa>
	else if (lflag)
  80069f:	85 c9                	test   %ecx,%ecx
  8006a1:	75 1b                	jne    8006be <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 c1                	mov    %eax,%ecx
  8006ad:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bc:	eb b9                	jmp    800677 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c6:	89 c1                	mov    %eax,%ecx
  8006c8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006cb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d7:	eb 9e                	jmp    800677 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e4:	e9 05 01 00 00       	jmp    8007ee <vprintfmt+0x3fa>
	if (lflag >= 2)
  8006e9:	83 f9 01             	cmp    $0x1,%ecx
  8006ec:	7e 18                	jle    800706 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 10                	mov    (%eax),%edx
  8006f3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f6:	8d 40 08             	lea    0x8(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800701:	e9 e8 00 00 00       	jmp    8007ee <vprintfmt+0x3fa>
	else if (lflag)
  800706:	85 c9                	test   %ecx,%ecx
  800708:	75 1a                	jne    800724 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071f:	e9 ca 00 00 00       	jmp    8007ee <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072e:	8d 40 04             	lea    0x4(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800734:	b8 0a 00 00 00       	mov    $0xa,%eax
  800739:	e9 b0 00 00 00       	jmp    8007ee <vprintfmt+0x3fa>
	if (lflag >= 2)
  80073e:	83 f9 01             	cmp    $0x1,%ecx
  800741:	7e 3c                	jle    80077f <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 50 04             	mov    0x4(%eax),%edx
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 08             	lea    0x8(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80075a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80075e:	79 59                	jns    8007b9 <vprintfmt+0x3c5>
                putch('-', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	6a 2d                	push   $0x2d
  800766:	ff d6                	call   *%esi
                num = -(long long) num;
  800768:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80076b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076e:	f7 da                	neg    %edx
  800770:	83 d1 00             	adc    $0x0,%ecx
  800773:	f7 d9                	neg    %ecx
  800775:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800778:	b8 08 00 00 00       	mov    $0x8,%eax
  80077d:	eb 6f                	jmp    8007ee <vprintfmt+0x3fa>
	else if (lflag)
  80077f:	85 c9                	test   %ecx,%ecx
  800781:	75 1b                	jne    80079e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078b:	89 c1                	mov    %eax,%ecx
  80078d:	c1 f9 1f             	sar    $0x1f,%ecx
  800790:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
  80079c:	eb bc                	jmp    80075a <vprintfmt+0x366>
		return va_arg(*ap, long);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 c1                	mov    %eax,%ecx
  8007a8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ab:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 04             	lea    0x4(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b7:	eb a1                	jmp    80075a <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8007b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8007bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c4:	eb 28                	jmp    8007ee <vprintfmt+0x3fa>
			putch('0', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	6a 30                	push   $0x30
  8007cc:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ce:	83 c4 08             	add    $0x8,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	6a 78                	push   $0x78
  8007d4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 10                	mov    (%eax),%edx
  8007db:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007e0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007e3:	8d 40 04             	lea    0x4(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ee:	83 ec 0c             	sub    $0xc,%esp
  8007f1:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007f5:	57                   	push   %edi
  8007f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f9:	50                   	push   %eax
  8007fa:	51                   	push   %ecx
  8007fb:	52                   	push   %edx
  8007fc:	89 da                	mov    %ebx,%edx
  8007fe:	89 f0                	mov    %esi,%eax
  800800:	e8 06 fb ff ff       	call   80030b <printnum>
			break;
  800805:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800808:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080b:	83 c7 01             	add    $0x1,%edi
  80080e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800812:	83 f8 25             	cmp    $0x25,%eax
  800815:	0f 84 f0 fb ff ff    	je     80040b <vprintfmt+0x17>
			if (ch == '\0')
  80081b:	85 c0                	test   %eax,%eax
  80081d:	0f 84 8b 00 00 00    	je     8008ae <vprintfmt+0x4ba>
			putch(ch, putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	50                   	push   %eax
  800828:	ff d6                	call   *%esi
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	eb dc                	jmp    80080b <vprintfmt+0x417>
	if (lflag >= 2)
  80082f:	83 f9 01             	cmp    $0x1,%ecx
  800832:	7e 15                	jle    800849 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 10                	mov    (%eax),%edx
  800839:	8b 48 04             	mov    0x4(%eax),%ecx
  80083c:	8d 40 08             	lea    0x8(%eax),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800842:	b8 10 00 00 00       	mov    $0x10,%eax
  800847:	eb a5                	jmp    8007ee <vprintfmt+0x3fa>
	else if (lflag)
  800849:	85 c9                	test   %ecx,%ecx
  80084b:	75 17                	jne    800864 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 10                	mov    (%eax),%edx
  800852:	b9 00 00 00 00       	mov    $0x0,%ecx
  800857:	8d 40 04             	lea    0x4(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085d:	b8 10 00 00 00       	mov    $0x10,%eax
  800862:	eb 8a                	jmp    8007ee <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 10                	mov    (%eax),%edx
  800869:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800874:	b8 10 00 00 00       	mov    $0x10,%eax
  800879:	e9 70 ff ff ff       	jmp    8007ee <vprintfmt+0x3fa>
			putch(ch, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	53                   	push   %ebx
  800882:	6a 25                	push   $0x25
  800884:	ff d6                	call   *%esi
			break;
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	e9 7a ff ff ff       	jmp    800808 <vprintfmt+0x414>
			putch('%', putdat);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	53                   	push   %ebx
  800892:	6a 25                	push   $0x25
  800894:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	89 f8                	mov    %edi,%eax
  80089b:	eb 03                	jmp    8008a0 <vprintfmt+0x4ac>
  80089d:	83 e8 01             	sub    $0x1,%eax
  8008a0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a4:	75 f7                	jne    80089d <vprintfmt+0x4a9>
  8008a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a9:	e9 5a ff ff ff       	jmp    800808 <vprintfmt+0x414>
}
  8008ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5f                   	pop    %edi
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 18             	sub    $0x18,%esp
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d3:	85 c0                	test   %eax,%eax
  8008d5:	74 26                	je     8008fd <vsnprintf+0x47>
  8008d7:	85 d2                	test   %edx,%edx
  8008d9:	7e 22                	jle    8008fd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008db:	ff 75 14             	pushl  0x14(%ebp)
  8008de:	ff 75 10             	pushl  0x10(%ebp)
  8008e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	68 ba 03 80 00       	push   $0x8003ba
  8008ea:	e8 05 fb ff ff       	call   8003f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    
		return -E_INVAL;
  8008fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800902:	eb f7                	jmp    8008fb <vsnprintf+0x45>

00800904 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80090d:	50                   	push   %eax
  80090e:	ff 75 10             	pushl  0x10(%ebp)
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	ff 75 08             	pushl  0x8(%ebp)
  800917:	e8 9a ff ff ff       	call   8008b6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
  800929:	eb 03                	jmp    80092e <strlen+0x10>
		n++;
  80092b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80092e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800932:	75 f7                	jne    80092b <strlen+0xd>
	return n;
}
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
  800944:	eb 03                	jmp    800949 <strnlen+0x13>
		n++;
  800946:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800949:	39 d0                	cmp    %edx,%eax
  80094b:	74 06                	je     800953 <strnlen+0x1d>
  80094d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800951:	75 f3                	jne    800946 <strnlen+0x10>
	return n;
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095f:	89 c2                	mov    %eax,%edx
  800961:	83 c1 01             	add    $0x1,%ecx
  800964:	83 c2 01             	add    $0x1,%edx
  800967:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80096b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80096e:	84 db                	test   %bl,%bl
  800970:	75 ef                	jne    800961 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800972:	5b                   	pop    %ebx
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	53                   	push   %ebx
  800979:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097c:	53                   	push   %ebx
  80097d:	e8 9c ff ff ff       	call   80091e <strlen>
  800982:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	01 d8                	add    %ebx,%eax
  80098a:	50                   	push   %eax
  80098b:	e8 c5 ff ff ff       	call   800955 <strcpy>
	return dst;
}
  800990:	89 d8                	mov    %ebx,%eax
  800992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 75 08             	mov    0x8(%ebp),%esi
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	89 f3                	mov    %esi,%ebx
  8009a4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a7:	89 f2                	mov    %esi,%edx
  8009a9:	eb 0f                	jmp    8009ba <strncpy+0x23>
		*dst++ = *src;
  8009ab:	83 c2 01             	add    $0x1,%edx
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b4:	80 39 01             	cmpb   $0x1,(%ecx)
  8009b7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009ba:	39 da                	cmp    %ebx,%edx
  8009bc:	75 ed                	jne    8009ab <strncpy+0x14>
	}
	return ret;
}
  8009be:	89 f0                	mov    %esi,%eax
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009d2:	89 f0                	mov    %esi,%eax
  8009d4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d8:	85 c9                	test   %ecx,%ecx
  8009da:	75 0b                	jne    8009e7 <strlcpy+0x23>
  8009dc:	eb 17                	jmp    8009f5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009de:	83 c2 01             	add    $0x1,%edx
  8009e1:	83 c0 01             	add    $0x1,%eax
  8009e4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009e7:	39 d8                	cmp    %ebx,%eax
  8009e9:	74 07                	je     8009f2 <strlcpy+0x2e>
  8009eb:	0f b6 0a             	movzbl (%edx),%ecx
  8009ee:	84 c9                	test   %cl,%cl
  8009f0:	75 ec                	jne    8009de <strlcpy+0x1a>
		*dst = '\0';
  8009f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f5:	29 f0                	sub    %esi,%eax
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5e                   	pop    %esi
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a04:	eb 06                	jmp    800a0c <strcmp+0x11>
		p++, q++;
  800a06:	83 c1 01             	add    $0x1,%ecx
  800a09:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a0c:	0f b6 01             	movzbl (%ecx),%eax
  800a0f:	84 c0                	test   %al,%al
  800a11:	74 04                	je     800a17 <strcmp+0x1c>
  800a13:	3a 02                	cmp    (%edx),%al
  800a15:	74 ef                	je     800a06 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a17:	0f b6 c0             	movzbl %al,%eax
  800a1a:	0f b6 12             	movzbl (%edx),%edx
  800a1d:	29 d0                	sub    %edx,%eax
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	89 c3                	mov    %eax,%ebx
  800a2d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a30:	eb 06                	jmp    800a38 <strncmp+0x17>
		n--, p++, q++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a38:	39 d8                	cmp    %ebx,%eax
  800a3a:	74 16                	je     800a52 <strncmp+0x31>
  800a3c:	0f b6 08             	movzbl (%eax),%ecx
  800a3f:	84 c9                	test   %cl,%cl
  800a41:	74 04                	je     800a47 <strncmp+0x26>
  800a43:	3a 0a                	cmp    (%edx),%cl
  800a45:	74 eb                	je     800a32 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a47:	0f b6 00             	movzbl (%eax),%eax
  800a4a:	0f b6 12             	movzbl (%edx),%edx
  800a4d:	29 d0                	sub    %edx,%eax
}
  800a4f:	5b                   	pop    %ebx
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    
		return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
  800a57:	eb f6                	jmp    800a4f <strncmp+0x2e>

00800a59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a63:	0f b6 10             	movzbl (%eax),%edx
  800a66:	84 d2                	test   %dl,%dl
  800a68:	74 09                	je     800a73 <strchr+0x1a>
		if (*s == c)
  800a6a:	38 ca                	cmp    %cl,%dl
  800a6c:	74 0a                	je     800a78 <strchr+0x1f>
	for (; *s; s++)
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	eb f0                	jmp    800a63 <strchr+0xa>
			return (char *) s;
	return 0;
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a84:	eb 03                	jmp    800a89 <strfind+0xf>
  800a86:	83 c0 01             	add    $0x1,%eax
  800a89:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a8c:	38 ca                	cmp    %cl,%dl
  800a8e:	74 04                	je     800a94 <strfind+0x1a>
  800a90:	84 d2                	test   %dl,%dl
  800a92:	75 f2                	jne    800a86 <strfind+0xc>
			break;
	return (char *) s;
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa2:	85 c9                	test   %ecx,%ecx
  800aa4:	74 13                	je     800ab9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aac:	75 05                	jne    800ab3 <memset+0x1d>
  800aae:	f6 c1 03             	test   $0x3,%cl
  800ab1:	74 0d                	je     800ac0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab6:	fc                   	cld    
  800ab7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ab9:	89 f8                	mov    %edi,%eax
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5f                   	pop    %edi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    
		c &= 0xFF;
  800ac0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac4:	89 d3                	mov    %edx,%ebx
  800ac6:	c1 e3 08             	shl    $0x8,%ebx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	c1 e0 18             	shl    $0x18,%eax
  800ace:	89 d6                	mov    %edx,%esi
  800ad0:	c1 e6 10             	shl    $0x10,%esi
  800ad3:	09 f0                	or     %esi,%eax
  800ad5:	09 c2                	or     %eax,%edx
  800ad7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800adc:	89 d0                	mov    %edx,%eax
  800ade:	fc                   	cld    
  800adf:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae1:	eb d6                	jmp    800ab9 <memset+0x23>

00800ae3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af1:	39 c6                	cmp    %eax,%esi
  800af3:	73 35                	jae    800b2a <memmove+0x47>
  800af5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af8:	39 c2                	cmp    %eax,%edx
  800afa:	76 2e                	jbe    800b2a <memmove+0x47>
		s += n;
		d += n;
  800afc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aff:	89 d6                	mov    %edx,%esi
  800b01:	09 fe                	or     %edi,%esi
  800b03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b09:	74 0c                	je     800b17 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0b:	83 ef 01             	sub    $0x1,%edi
  800b0e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b11:	fd                   	std    
  800b12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b14:	fc                   	cld    
  800b15:	eb 21                	jmp    800b38 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b17:	f6 c1 03             	test   $0x3,%cl
  800b1a:	75 ef                	jne    800b0b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1c:	83 ef 04             	sub    $0x4,%edi
  800b1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b25:	fd                   	std    
  800b26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b28:	eb ea                	jmp    800b14 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2a:	89 f2                	mov    %esi,%edx
  800b2c:	09 c2                	or     %eax,%edx
  800b2e:	f6 c2 03             	test   $0x3,%dl
  800b31:	74 09                	je     800b3c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3c:	f6 c1 03             	test   $0x3,%cl
  800b3f:	75 f2                	jne    800b33 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b44:	89 c7                	mov    %eax,%edi
  800b46:	fc                   	cld    
  800b47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b49:	eb ed                	jmp    800b38 <memmove+0x55>

00800b4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b4e:	ff 75 10             	pushl  0x10(%ebp)
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 87 ff ff ff       	call   800ae3 <memmove>
}
  800b5c:	c9                   	leave  
  800b5d:	c3                   	ret    

00800b5e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	56                   	push   %esi
  800b62:	53                   	push   %ebx
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b69:	89 c6                	mov    %eax,%esi
  800b6b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6e:	39 f0                	cmp    %esi,%eax
  800b70:	74 1c                	je     800b8e <memcmp+0x30>
		if (*s1 != *s2)
  800b72:	0f b6 08             	movzbl (%eax),%ecx
  800b75:	0f b6 1a             	movzbl (%edx),%ebx
  800b78:	38 d9                	cmp    %bl,%cl
  800b7a:	75 08                	jne    800b84 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	83 c2 01             	add    $0x1,%edx
  800b82:	eb ea                	jmp    800b6e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b84:	0f b6 c1             	movzbl %cl,%eax
  800b87:	0f b6 db             	movzbl %bl,%ebx
  800b8a:	29 d8                	sub    %ebx,%eax
  800b8c:	eb 05                	jmp    800b93 <memcmp+0x35>
	}

	return 0;
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba0:	89 c2                	mov    %eax,%edx
  800ba2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba5:	39 d0                	cmp    %edx,%eax
  800ba7:	73 09                	jae    800bb2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba9:	38 08                	cmp    %cl,(%eax)
  800bab:	74 05                	je     800bb2 <memfind+0x1b>
	for (; s < ends; s++)
  800bad:	83 c0 01             	add    $0x1,%eax
  800bb0:	eb f3                	jmp    800ba5 <memfind+0xe>
			break;
	return (void *) s;
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc0:	eb 03                	jmp    800bc5 <strtol+0x11>
		s++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bc5:	0f b6 01             	movzbl (%ecx),%eax
  800bc8:	3c 20                	cmp    $0x20,%al
  800bca:	74 f6                	je     800bc2 <strtol+0xe>
  800bcc:	3c 09                	cmp    $0x9,%al
  800bce:	74 f2                	je     800bc2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bd0:	3c 2b                	cmp    $0x2b,%al
  800bd2:	74 2e                	je     800c02 <strtol+0x4e>
	int neg = 0;
  800bd4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd9:	3c 2d                	cmp    $0x2d,%al
  800bdb:	74 2f                	je     800c0c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be3:	75 05                	jne    800bea <strtol+0x36>
  800be5:	80 39 30             	cmpb   $0x30,(%ecx)
  800be8:	74 2c                	je     800c16 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bea:	85 db                	test   %ebx,%ebx
  800bec:	75 0a                	jne    800bf8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bee:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bf3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf6:	74 28                	je     800c20 <strtol+0x6c>
		base = 10;
  800bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c00:	eb 50                	jmp    800c52 <strtol+0x9e>
		s++;
  800c02:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c05:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0a:	eb d1                	jmp    800bdd <strtol+0x29>
		s++, neg = 1;
  800c0c:	83 c1 01             	add    $0x1,%ecx
  800c0f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c14:	eb c7                	jmp    800bdd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c16:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c1a:	74 0e                	je     800c2a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c1c:	85 db                	test   %ebx,%ebx
  800c1e:	75 d8                	jne    800bf8 <strtol+0x44>
		s++, base = 8;
  800c20:	83 c1 01             	add    $0x1,%ecx
  800c23:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c28:	eb ce                	jmp    800bf8 <strtol+0x44>
		s += 2, base = 16;
  800c2a:	83 c1 02             	add    $0x2,%ecx
  800c2d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c32:	eb c4                	jmp    800bf8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c34:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c37:	89 f3                	mov    %esi,%ebx
  800c39:	80 fb 19             	cmp    $0x19,%bl
  800c3c:	77 29                	ja     800c67 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c3e:	0f be d2             	movsbl %dl,%edx
  800c41:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c44:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c47:	7d 30                	jge    800c79 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c49:	83 c1 01             	add    $0x1,%ecx
  800c4c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c50:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c52:	0f b6 11             	movzbl (%ecx),%edx
  800c55:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c58:	89 f3                	mov    %esi,%ebx
  800c5a:	80 fb 09             	cmp    $0x9,%bl
  800c5d:	77 d5                	ja     800c34 <strtol+0x80>
			dig = *s - '0';
  800c5f:	0f be d2             	movsbl %dl,%edx
  800c62:	83 ea 30             	sub    $0x30,%edx
  800c65:	eb dd                	jmp    800c44 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c67:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c6a:	89 f3                	mov    %esi,%ebx
  800c6c:	80 fb 19             	cmp    $0x19,%bl
  800c6f:	77 08                	ja     800c79 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c71:	0f be d2             	movsbl %dl,%edx
  800c74:	83 ea 37             	sub    $0x37,%edx
  800c77:	eb cb                	jmp    800c44 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7d:	74 05                	je     800c84 <strtol+0xd0>
		*endptr = (char *) s;
  800c7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c82:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c84:	89 c2                	mov    %eax,%edx
  800c86:	f7 da                	neg    %edx
  800c88:	85 ff                	test   %edi,%edi
  800c8a:	0f 45 c2             	cmovne %edx,%eax
}
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5f                   	pop    %edi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
    asm volatile("int %1\n"
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca3:	89 c3                	mov    %eax,%ebx
  800ca5:	89 c7                	mov    %eax,%edi
  800ca7:	89 c6                	mov    %eax,%esi
  800ca9:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_cgetc>:

int
sys_cgetc(void) {
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
    asm volatile("int %1\n"
  800cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbb:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc0:	89 d1                	mov    %edx,%ecx
  800cc2:	89 d3                	mov    %edx,%ebx
  800cc4:	89 d7                	mov    %edx,%edi
  800cc6:	89 d6                	mov    %edx,%esi
  800cc8:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800cd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce5:	89 cb                	mov    %ecx,%ebx
  800ce7:	89 cf                	mov    %ecx,%edi
  800ce9:	89 ce                	mov    %ecx,%esi
  800ceb:	cd 30                	int    $0x30
    if (check && ret > 0)
  800ced:	85 c0                	test   %eax,%eax
  800cef:	7f 08                	jg     800cf9 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800cf9:	83 ec 0c             	sub    $0xc,%esp
  800cfc:	50                   	push   %eax
  800cfd:	6a 03                	push   $0x3
  800cff:	68 44 14 80 00       	push   $0x801444
  800d04:	6a 24                	push   $0x24
  800d06:	68 61 14 80 00       	push   $0x801461
  800d0b:	e8 0c f5 ff ff       	call   80021c <_panic>

00800d10 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d20:	89 d1                	mov    %edx,%ecx
  800d22:	89 d3                	mov    %edx,%ebx
  800d24:	89 d7                	mov    %edx,%edi
  800d26:	89 d6                	mov    %edx,%esi
  800d28:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <sys_yield>:

void
sys_yield(void)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
    asm volatile("int %1\n"
  800d35:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3f:	89 d1                	mov    %edx,%ecx
  800d41:	89 d3                	mov    %edx,%ebx
  800d43:	89 d7                	mov    %edx,%edi
  800d45:	89 d6                	mov    %edx,%esi
  800d47:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d57:	be 00 00 00 00       	mov    $0x0,%esi
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	b8 04 00 00 00       	mov    $0x4,%eax
  800d67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6a:	89 f7                	mov    %esi,%edi
  800d6c:	cd 30                	int    $0x30
    if (check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7f 08                	jg     800d7a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	83 ec 0c             	sub    $0xc,%esp
  800d7d:	50                   	push   %eax
  800d7e:	6a 04                	push   $0x4
  800d80:	68 44 14 80 00       	push   $0x801444
  800d85:	6a 24                	push   $0x24
  800d87:	68 61 14 80 00       	push   $0x801461
  800d8c:	e8 8b f4 ff ff       	call   80021c <_panic>

00800d91 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da0:	b8 05 00 00 00       	mov    $0x5,%eax
  800da5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dab:	8b 75 18             	mov    0x18(%ebp),%esi
  800dae:	cd 30                	int    $0x30
    if (check && ret > 0)
  800db0:	85 c0                	test   %eax,%eax
  800db2:	7f 08                	jg     800dbc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	50                   	push   %eax
  800dc0:	6a 05                	push   $0x5
  800dc2:	68 44 14 80 00       	push   $0x801444
  800dc7:	6a 24                	push   $0x24
  800dc9:	68 61 14 80 00       	push   $0x801461
  800dce:	e8 49 f4 ff ff       	call   80021c <_panic>

00800dd3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	b8 06 00 00 00       	mov    $0x6,%eax
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	89 de                	mov    %ebx,%esi
  800df0:	cd 30                	int    $0x30
    if (check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7f 08                	jg     800dfe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	50                   	push   %eax
  800e02:	6a 06                	push   $0x6
  800e04:	68 44 14 80 00       	push   $0x801444
  800e09:	6a 24                	push   $0x24
  800e0b:	68 61 14 80 00       	push   $0x801461
  800e10:	e8 07 f4 ff ff       	call   80021c <_panic>

00800e15 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
  800e1b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e29:	b8 08 00 00 00       	mov    $0x8,%eax
  800e2e:	89 df                	mov    %ebx,%edi
  800e30:	89 de                	mov    %ebx,%esi
  800e32:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	7f 08                	jg     800e40 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e40:	83 ec 0c             	sub    $0xc,%esp
  800e43:	50                   	push   %eax
  800e44:	6a 08                	push   $0x8
  800e46:	68 44 14 80 00       	push   $0x801444
  800e4b:	6a 24                	push   $0x24
  800e4d:	68 61 14 80 00       	push   $0x801461
  800e52:	e8 c5 f3 ff ff       	call   80021c <_panic>

00800e57 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800e60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e70:	89 df                	mov    %ebx,%edi
  800e72:	89 de                	mov    %ebx,%esi
  800e74:	cd 30                	int    $0x30
    if (check && ret > 0)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	7f 08                	jg     800e82 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	50                   	push   %eax
  800e86:	6a 09                	push   $0x9
  800e88:	68 44 14 80 00       	push   $0x801444
  800e8d:	6a 24                	push   $0x24
  800e8f:	68 61 14 80 00       	push   $0x801461
  800e94:	e8 83 f3 ff ff       	call   80021c <_panic>

00800e99 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
    asm volatile("int %1\n"
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eaa:	be 00 00 00 00       	mov    $0x0,%esi
  800eaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed2:	89 cb                	mov    %ecx,%ebx
  800ed4:	89 cf                	mov    %ecx,%edi
  800ed6:	89 ce                	mov    %ecx,%esi
  800ed8:	cd 30                	int    $0x30
    if (check && ret > 0)
  800eda:	85 c0                	test   %eax,%eax
  800edc:	7f 08                	jg     800ee6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	6a 0c                	push   $0xc
  800eec:	68 44 14 80 00       	push   $0x801444
  800ef1:	6a 24                	push   $0x24
  800ef3:	68 61 14 80 00       	push   $0x801461
  800ef8:	e8 1f f3 ff ff       	call   80021c <_panic>
  800efd:	66 90                	xchg   %ax,%ax
  800eff:	90                   	nop

00800f00 <__udivdi3>:
  800f00:	55                   	push   %ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 1c             	sub    $0x1c,%esp
  800f07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f17:	85 d2                	test   %edx,%edx
  800f19:	75 35                	jne    800f50 <__udivdi3+0x50>
  800f1b:	39 f3                	cmp    %esi,%ebx
  800f1d:	0f 87 bd 00 00 00    	ja     800fe0 <__udivdi3+0xe0>
  800f23:	85 db                	test   %ebx,%ebx
  800f25:	89 d9                	mov    %ebx,%ecx
  800f27:	75 0b                	jne    800f34 <__udivdi3+0x34>
  800f29:	b8 01 00 00 00       	mov    $0x1,%eax
  800f2e:	31 d2                	xor    %edx,%edx
  800f30:	f7 f3                	div    %ebx
  800f32:	89 c1                	mov    %eax,%ecx
  800f34:	31 d2                	xor    %edx,%edx
  800f36:	89 f0                	mov    %esi,%eax
  800f38:	f7 f1                	div    %ecx
  800f3a:	89 c6                	mov    %eax,%esi
  800f3c:	89 e8                	mov    %ebp,%eax
  800f3e:	89 f7                	mov    %esi,%edi
  800f40:	f7 f1                	div    %ecx
  800f42:	89 fa                	mov    %edi,%edx
  800f44:	83 c4 1c             	add    $0x1c,%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
  800f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f50:	39 f2                	cmp    %esi,%edx
  800f52:	77 7c                	ja     800fd0 <__udivdi3+0xd0>
  800f54:	0f bd fa             	bsr    %edx,%edi
  800f57:	83 f7 1f             	xor    $0x1f,%edi
  800f5a:	0f 84 98 00 00 00    	je     800ff8 <__udivdi3+0xf8>
  800f60:	89 f9                	mov    %edi,%ecx
  800f62:	b8 20 00 00 00       	mov    $0x20,%eax
  800f67:	29 f8                	sub    %edi,%eax
  800f69:	d3 e2                	shl    %cl,%edx
  800f6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f6f:	89 c1                	mov    %eax,%ecx
  800f71:	89 da                	mov    %ebx,%edx
  800f73:	d3 ea                	shr    %cl,%edx
  800f75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f79:	09 d1                	or     %edx,%ecx
  800f7b:	89 f2                	mov    %esi,%edx
  800f7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f81:	89 f9                	mov    %edi,%ecx
  800f83:	d3 e3                	shl    %cl,%ebx
  800f85:	89 c1                	mov    %eax,%ecx
  800f87:	d3 ea                	shr    %cl,%edx
  800f89:	89 f9                	mov    %edi,%ecx
  800f8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f8f:	d3 e6                	shl    %cl,%esi
  800f91:	89 eb                	mov    %ebp,%ebx
  800f93:	89 c1                	mov    %eax,%ecx
  800f95:	d3 eb                	shr    %cl,%ebx
  800f97:	09 de                	or     %ebx,%esi
  800f99:	89 f0                	mov    %esi,%eax
  800f9b:	f7 74 24 08          	divl   0x8(%esp)
  800f9f:	89 d6                	mov    %edx,%esi
  800fa1:	89 c3                	mov    %eax,%ebx
  800fa3:	f7 64 24 0c          	mull   0xc(%esp)
  800fa7:	39 d6                	cmp    %edx,%esi
  800fa9:	72 0c                	jb     800fb7 <__udivdi3+0xb7>
  800fab:	89 f9                	mov    %edi,%ecx
  800fad:	d3 e5                	shl    %cl,%ebp
  800faf:	39 c5                	cmp    %eax,%ebp
  800fb1:	73 5d                	jae    801010 <__udivdi3+0x110>
  800fb3:	39 d6                	cmp    %edx,%esi
  800fb5:	75 59                	jne    801010 <__udivdi3+0x110>
  800fb7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fba:	31 ff                	xor    %edi,%edi
  800fbc:	89 fa                	mov    %edi,%edx
  800fbe:	83 c4 1c             	add    $0x1c,%esp
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    
  800fc6:	8d 76 00             	lea    0x0(%esi),%esi
  800fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800fd0:	31 ff                	xor    %edi,%edi
  800fd2:	31 c0                	xor    %eax,%eax
  800fd4:	89 fa                	mov    %edi,%edx
  800fd6:	83 c4 1c             	add    $0x1c,%esp
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    
  800fde:	66 90                	xchg   %ax,%ax
  800fe0:	31 ff                	xor    %edi,%edi
  800fe2:	89 e8                	mov    %ebp,%eax
  800fe4:	89 f2                	mov    %esi,%edx
  800fe6:	f7 f3                	div    %ebx
  800fe8:	89 fa                	mov    %edi,%edx
  800fea:	83 c4 1c             	add    $0x1c,%esp
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    
  800ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ff8:	39 f2                	cmp    %esi,%edx
  800ffa:	72 06                	jb     801002 <__udivdi3+0x102>
  800ffc:	31 c0                	xor    %eax,%eax
  800ffe:	39 eb                	cmp    %ebp,%ebx
  801000:	77 d2                	ja     800fd4 <__udivdi3+0xd4>
  801002:	b8 01 00 00 00       	mov    $0x1,%eax
  801007:	eb cb                	jmp    800fd4 <__udivdi3+0xd4>
  801009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801010:	89 d8                	mov    %ebx,%eax
  801012:	31 ff                	xor    %edi,%edi
  801014:	eb be                	jmp    800fd4 <__udivdi3+0xd4>
  801016:	66 90                	xchg   %ax,%ax
  801018:	66 90                	xchg   %ax,%ax
  80101a:	66 90                	xchg   %ax,%ax
  80101c:	66 90                	xchg   %ax,%ax
  80101e:	66 90                	xchg   %ax,%ax

00801020 <__umoddi3>:
  801020:	55                   	push   %ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 1c             	sub    $0x1c,%esp
  801027:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80102b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80102f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801033:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801037:	85 ed                	test   %ebp,%ebp
  801039:	89 f0                	mov    %esi,%eax
  80103b:	89 da                	mov    %ebx,%edx
  80103d:	75 19                	jne    801058 <__umoddi3+0x38>
  80103f:	39 df                	cmp    %ebx,%edi
  801041:	0f 86 b1 00 00 00    	jbe    8010f8 <__umoddi3+0xd8>
  801047:	f7 f7                	div    %edi
  801049:	89 d0                	mov    %edx,%eax
  80104b:	31 d2                	xor    %edx,%edx
  80104d:	83 c4 1c             	add    $0x1c,%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    
  801055:	8d 76 00             	lea    0x0(%esi),%esi
  801058:	39 dd                	cmp    %ebx,%ebp
  80105a:	77 f1                	ja     80104d <__umoddi3+0x2d>
  80105c:	0f bd cd             	bsr    %ebp,%ecx
  80105f:	83 f1 1f             	xor    $0x1f,%ecx
  801062:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801066:	0f 84 b4 00 00 00    	je     801120 <__umoddi3+0x100>
  80106c:	b8 20 00 00 00       	mov    $0x20,%eax
  801071:	89 c2                	mov    %eax,%edx
  801073:	8b 44 24 04          	mov    0x4(%esp),%eax
  801077:	29 c2                	sub    %eax,%edx
  801079:	89 c1                	mov    %eax,%ecx
  80107b:	89 f8                	mov    %edi,%eax
  80107d:	d3 e5                	shl    %cl,%ebp
  80107f:	89 d1                	mov    %edx,%ecx
  801081:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801085:	d3 e8                	shr    %cl,%eax
  801087:	09 c5                	or     %eax,%ebp
  801089:	8b 44 24 04          	mov    0x4(%esp),%eax
  80108d:	89 c1                	mov    %eax,%ecx
  80108f:	d3 e7                	shl    %cl,%edi
  801091:	89 d1                	mov    %edx,%ecx
  801093:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801097:	89 df                	mov    %ebx,%edi
  801099:	d3 ef                	shr    %cl,%edi
  80109b:	89 c1                	mov    %eax,%ecx
  80109d:	89 f0                	mov    %esi,%eax
  80109f:	d3 e3                	shl    %cl,%ebx
  8010a1:	89 d1                	mov    %edx,%ecx
  8010a3:	89 fa                	mov    %edi,%edx
  8010a5:	d3 e8                	shr    %cl,%eax
  8010a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010ac:	09 d8                	or     %ebx,%eax
  8010ae:	f7 f5                	div    %ebp
  8010b0:	d3 e6                	shl    %cl,%esi
  8010b2:	89 d1                	mov    %edx,%ecx
  8010b4:	f7 64 24 08          	mull   0x8(%esp)
  8010b8:	39 d1                	cmp    %edx,%ecx
  8010ba:	89 c3                	mov    %eax,%ebx
  8010bc:	89 d7                	mov    %edx,%edi
  8010be:	72 06                	jb     8010c6 <__umoddi3+0xa6>
  8010c0:	75 0e                	jne    8010d0 <__umoddi3+0xb0>
  8010c2:	39 c6                	cmp    %eax,%esi
  8010c4:	73 0a                	jae    8010d0 <__umoddi3+0xb0>
  8010c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8010ca:	19 ea                	sbb    %ebp,%edx
  8010cc:	89 d7                	mov    %edx,%edi
  8010ce:	89 c3                	mov    %eax,%ebx
  8010d0:	89 ca                	mov    %ecx,%edx
  8010d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8010d7:	29 de                	sub    %ebx,%esi
  8010d9:	19 fa                	sbb    %edi,%edx
  8010db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8010df:	89 d0                	mov    %edx,%eax
  8010e1:	d3 e0                	shl    %cl,%eax
  8010e3:	89 d9                	mov    %ebx,%ecx
  8010e5:	d3 ee                	shr    %cl,%esi
  8010e7:	d3 ea                	shr    %cl,%edx
  8010e9:	09 f0                	or     %esi,%eax
  8010eb:	83 c4 1c             	add    $0x1c,%esp
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    
  8010f3:	90                   	nop
  8010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8010f8:	85 ff                	test   %edi,%edi
  8010fa:	89 f9                	mov    %edi,%ecx
  8010fc:	75 0b                	jne    801109 <__umoddi3+0xe9>
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801103:	31 d2                	xor    %edx,%edx
  801105:	f7 f7                	div    %edi
  801107:	89 c1                	mov    %eax,%ecx
  801109:	89 d8                	mov    %ebx,%eax
  80110b:	31 d2                	xor    %edx,%edx
  80110d:	f7 f1                	div    %ecx
  80110f:	89 f0                	mov    %esi,%eax
  801111:	f7 f1                	div    %ecx
  801113:	e9 31 ff ff ff       	jmp    801049 <__umoddi3+0x29>
  801118:	90                   	nop
  801119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801120:	39 dd                	cmp    %ebx,%ebp
  801122:	72 08                	jb     80112c <__umoddi3+0x10c>
  801124:	39 f7                	cmp    %esi,%edi
  801126:	0f 87 21 ff ff ff    	ja     80104d <__umoddi3+0x2d>
  80112c:	89 da                	mov    %ebx,%edx
  80112e:	89 f0                	mov    %esi,%eax
  801130:	29 f8                	sub    %edi,%eax
  801132:	19 ea                	sbb    %ebp,%edx
  801134:	e9 14 ff ff ff       	jmp    80104d <__umoddi3+0x2d>
