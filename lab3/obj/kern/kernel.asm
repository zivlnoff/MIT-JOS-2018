
obj/kern/kernel：     文件格式 elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 d0 18 00       	mov    $0x18d000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 a0 11 f0       	mov    $0xf011a000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 68 00 00 00       	call   f01000a6 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:
#include <kern/env.h>
#include <kern/trap.h>

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x) {
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	e8 f4 01 00 00       	call   f010023e <__x86.get_pc_thunk.bx>
f010004a:	81 c3 d6 bf 08 00    	add    $0x8bfd6,%ebx
f0100050:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("entering test_backtrace %d\n", x);
f0100053:	83 ec 08             	sub    $0x8,%esp
f0100056:	56                   	push   %esi
f0100057:	8d 83 c0 90 f7 ff    	lea    -0x86f40(%ebx),%eax
f010005d:	50                   	push   %eax
f010005e:	e8 1a 3b 00 00       	call   f0103b7d <cprintf>
    if (x <= 0)
f0100063:	83 c4 10             	add    $0x10,%esp
f0100066:	85 f6                	test   %esi,%esi
f0100068:	7f 2b                	jg     f0100095 <test_backtrace+0x55>
        mon_backtrace(0, 0, 0);
f010006a:	83 ec 04             	sub    $0x4,%esp
f010006d:	6a 00                	push   $0x0
f010006f:	6a 00                	push   $0x0
f0100071:	6a 00                	push   $0x0
f0100073:	e8 a4 08 00 00       	call   f010091c <mon_backtrace>
f0100078:	83 c4 10             	add    $0x10,%esp
    else {
        test_backtrace(x - 1);
    }
    cprintf("leaving test_backtrace %d\n", x);
f010007b:	83 ec 08             	sub    $0x8,%esp
f010007e:	56                   	push   %esi
f010007f:	8d 83 dc 90 f7 ff    	lea    -0x86f24(%ebx),%eax
f0100085:	50                   	push   %eax
f0100086:	e8 f2 3a 00 00       	call   f0103b7d <cprintf>
}
f010008b:	83 c4 10             	add    $0x10,%esp
f010008e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100091:	5b                   	pop    %ebx
f0100092:	5e                   	pop    %esi
f0100093:	5d                   	pop    %ebp
f0100094:	c3                   	ret    
        test_backtrace(x - 1);
f0100095:	83 ec 0c             	sub    $0xc,%esp
f0100098:	8d 46 ff             	lea    -0x1(%esi),%eax
f010009b:	50                   	push   %eax
f010009c:	e8 9f ff ff ff       	call   f0100040 <test_backtrace>
f01000a1:	83 c4 10             	add    $0x10,%esp
f01000a4:	eb d5                	jmp    f010007b <test_backtrace+0x3b>

f01000a6 <i386_init>:

//入口
void
i386_init(void) {
f01000a6:	55                   	push   %ebp
f01000a7:	89 e5                	mov    %esp,%ebp
f01000a9:	53                   	push   %ebx
f01000aa:	83 ec 18             	sub    $0x18,%esp
f01000ad:	e8 8c 01 00 00       	call   f010023e <__x86.get_pc_thunk.bx>
f01000b2:	81 c3 6e bf 08 00    	add    $0x8bf6e,%ebx
    // Before doing anything else, complete the ELF loading process.
    // Clear the uninitialized global data (BSS) section of our program.
    // This ensures that all static/global variables start out zero.

    //我目前觉得不应该这么做，可能我对.bss段不太了解，哦，我对调试用的符号表也没有很熟悉
    memset(edata, 0, end - edata);
f01000b8:	c7 c0 14 f0 18 f0    	mov    $0xf018f014,%eax
f01000be:	c7 c2 00 e1 18 f0    	mov    $0xf018e100,%edx
f01000c4:	29 d0                	sub    %edx,%eax
f01000c6:	50                   	push   %eax
f01000c7:	6a 00                	push   $0x0
f01000c9:	52                   	push   %edx
f01000ca:	e8 c9 4b 00 00       	call   f0104c98 <memset>

    // Initialize the console.
    // Can't call cprintf until after we do this!
    cons_init();
f01000cf:	e8 bf 05 00 00       	call   f0100693 <cons_init>

    cprintf("\nlab1 start------------------------------------------------------------------------------------------------\n");
f01000d4:	8d 83 50 91 f7 ff    	lea    -0x86eb0(%ebx),%eax
f01000da:	89 04 24             	mov    %eax,(%esp)
f01000dd:	e8 9b 3a 00 00       	call   f0103b7d <cprintf>

    cprintf("6828 decimal is %o octal!\n", 6828);
f01000e2:	83 c4 08             	add    $0x8,%esp
f01000e5:	68 ac 1a 00 00       	push   $0x1aac
f01000ea:	8d 83 f7 90 f7 ff    	lea    -0x86f09(%ebx),%eax
f01000f0:	50                   	push   %eax
f01000f1:	e8 87 3a 00 00       	call   f0103b7d <cprintf>
    //comparable little-and big-endian
    unsigned int i = 0x00646c72;//100-d 6c-l 72-r
f01000f6:	c7 45 f4 72 6c 64 00 	movl   $0x646c72,-0xc(%ebp)
    cprintf("H%x Wo%s!\n", 57616, &i);//57616-e110
f01000fd:	83 c4 0c             	add    $0xc,%esp
f0100100:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100103:	50                   	push   %eax
f0100104:	68 10 e1 00 00       	push   $0xe110
f0100109:	8d 83 12 91 f7 ff    	lea    -0x86eee(%ebx),%eax
f010010f:	50                   	push   %eax
f0100110:	e8 68 3a 00 00       	call   f0103b7d <cprintf>
    // Test the stack backtrace function (lab 1 only)
    test_backtrace(5);
f0100115:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f010011c:	e8 1f ff ff ff       	call   f0100040 <test_backtrace>

    cprintf("lab1 end--------------------------------------------------------------------------------------------------\n\n");
f0100121:	8d 83 c0 91 f7 ff    	lea    -0x86e40(%ebx),%eax
f0100127:	89 04 24             	mov    %eax,(%esp)
f010012a:	e8 4e 3a 00 00       	call   f0103b7d <cprintf>

    cprintf("lab2 start------------------------------------------------------------------------------------------------\n");
f010012f:	8d 83 30 92 f7 ff    	lea    -0x86dd0(%ebx),%eax
f0100135:	89 04 24             	mov    %eax,(%esp)
f0100138:	e8 40 3a 00 00       	call   f0103b7d <cprintf>
    // Lab 2 memory management initialization functions
    mem_init();
f010013d:	e8 b9 14 00 00       	call   f01015fb <mem_init>

    cprintf("lab2 end--------------------------------------------------------------------------------------------------\n\n");
f0100142:	8d 83 9c 92 f7 ff    	lea    -0x86d64(%ebx),%eax
f0100148:	89 04 24             	mov    %eax,(%esp)
f010014b:	e8 2d 3a 00 00       	call   f0103b7d <cprintf>

    cprintf("lab3 start--------------------------------------------------------------------------------------------------\n\n");
f0100150:	8d 83 0c 93 f7 ff    	lea    -0x86cf4(%ebx),%eax
f0100156:	89 04 24             	mov    %eax,(%esp)
f0100159:	e8 1f 3a 00 00       	call   f0103b7d <cprintf>

    // Lab 3 user environment initialization functions
    env_init();
f010015e:	e8 77 35 00 00       	call   f01036da <env_init>
    trap_init();
f0100163:	e8 f5 3a 00 00       	call   f0103c5d <trap_init>
#if defined(TEST)
    // Don't touch -- used by grading script!
    ENV_CREATE(TEST, ENV_TYPE_USER);
#else
    // Touch all you want.
    ENV_CREATE(user_hello, ENV_TYPE_USER);
f0100168:	83 c4 08             	add    $0x8,%esp
f010016b:	6a 00                	push   $0x0
f010016d:	ff b3 f4 ff ff ff    	pushl  -0xc(%ebx)
f0100173:	e8 da 36 00 00       	call   f0103852 <env_create>
#endif // TEST*

    // We only have one user environment for now, so just run it.
    env_run(&envs[0]);
f0100178:	83 c4 04             	add    $0x4,%esp
f010017b:	c7 c0 4c e3 18 f0    	mov    $0xf018e34c,%eax
f0100181:	ff 30                	pushl  (%eax)
f0100183:	e8 44 39 00 00       	call   f0103acc <env_run>

f0100188 <_panic>:
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...) {
f0100188:	55                   	push   %ebp
f0100189:	89 e5                	mov    %esp,%ebp
f010018b:	57                   	push   %edi
f010018c:	56                   	push   %esi
f010018d:	53                   	push   %ebx
f010018e:	83 ec 0c             	sub    $0xc,%esp
f0100191:	e8 a8 00 00 00       	call   f010023e <__x86.get_pc_thunk.bx>
f0100196:	81 c3 8a be 08 00    	add    $0x8be8a,%ebx
f010019c:	8b 7d 10             	mov    0x10(%ebp),%edi
    va_list ap;

    if (panicstr)
f010019f:	c7 c0 04 f0 18 f0    	mov    $0xf018f004,%eax
f01001a5:	83 38 00             	cmpl   $0x0,(%eax)
f01001a8:	74 0f                	je     f01001b9 <_panic+0x31>
    va_end(ap);

    dead:
    /* break into the kernel monitor */
    while (1)
        monitor(NULL);
f01001aa:	83 ec 0c             	sub    $0xc,%esp
f01001ad:	6a 00                	push   $0x0
f01001af:	e8 ec 07 00 00       	call   f01009a0 <monitor>
f01001b4:	83 c4 10             	add    $0x10,%esp
f01001b7:	eb f1                	jmp    f01001aa <_panic+0x22>
    panicstr = fmt;
f01001b9:	89 38                	mov    %edi,(%eax)
    asm volatile("cli; cld");
f01001bb:	fa                   	cli    
f01001bc:	fc                   	cld    
    va_start(ap, fmt);
f01001bd:	8d 75 14             	lea    0x14(%ebp),%esi
    cprintf("kernel panic at %s:%d: ", file, line);
f01001c0:	83 ec 04             	sub    $0x4,%esp
f01001c3:	ff 75 0c             	pushl  0xc(%ebp)
f01001c6:	ff 75 08             	pushl  0x8(%ebp)
f01001c9:	8d 83 1d 91 f7 ff    	lea    -0x86ee3(%ebx),%eax
f01001cf:	50                   	push   %eax
f01001d0:	e8 a8 39 00 00       	call   f0103b7d <cprintf>
    vcprintf(fmt, ap);
f01001d5:	83 c4 08             	add    $0x8,%esp
f01001d8:	56                   	push   %esi
f01001d9:	57                   	push   %edi
f01001da:	e8 67 39 00 00       	call   f0103b46 <vcprintf>
    cprintf("\n");
f01001df:	8d 83 d9 a8 f7 ff    	lea    -0x85727(%ebx),%eax
f01001e5:	89 04 24             	mov    %eax,(%esp)
f01001e8:	e8 90 39 00 00       	call   f0103b7d <cprintf>
f01001ed:	83 c4 10             	add    $0x10,%esp
f01001f0:	eb b8                	jmp    f01001aa <_panic+0x22>

f01001f2 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...) {
f01001f2:	55                   	push   %ebp
f01001f3:	89 e5                	mov    %esp,%ebp
f01001f5:	56                   	push   %esi
f01001f6:	53                   	push   %ebx
f01001f7:	e8 42 00 00 00       	call   f010023e <__x86.get_pc_thunk.bx>
f01001fc:	81 c3 24 be 08 00    	add    $0x8be24,%ebx
    va_list ap;

    va_start(ap, fmt);
f0100202:	8d 75 14             	lea    0x14(%ebp),%esi
    cprintf("kernel warning at %s:%d: ", file, line);
f0100205:	83 ec 04             	sub    $0x4,%esp
f0100208:	ff 75 0c             	pushl  0xc(%ebp)
f010020b:	ff 75 08             	pushl  0x8(%ebp)
f010020e:	8d 83 35 91 f7 ff    	lea    -0x86ecb(%ebx),%eax
f0100214:	50                   	push   %eax
f0100215:	e8 63 39 00 00       	call   f0103b7d <cprintf>
    vcprintf(fmt, ap);
f010021a:	83 c4 08             	add    $0x8,%esp
f010021d:	56                   	push   %esi
f010021e:	ff 75 10             	pushl  0x10(%ebp)
f0100221:	e8 20 39 00 00       	call   f0103b46 <vcprintf>
    cprintf("\n");
f0100226:	8d 83 d9 a8 f7 ff    	lea    -0x85727(%ebx),%eax
f010022c:	89 04 24             	mov    %eax,(%esp)
f010022f:	e8 49 39 00 00       	call   f0103b7d <cprintf>
    va_end(ap);
}
f0100234:	83 c4 10             	add    $0x10,%esp
f0100237:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010023a:	5b                   	pop    %ebx
f010023b:	5e                   	pop    %esi
f010023c:	5d                   	pop    %ebp
f010023d:	c3                   	ret    

f010023e <__x86.get_pc_thunk.bx>:
f010023e:	8b 1c 24             	mov    (%esp),%ebx
f0100241:	c3                   	ret    

f0100242 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100242:	55                   	push   %ebp
f0100243:	89 e5                	mov    %esp,%ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100245:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010024a:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010024b:	a8 01                	test   $0x1,%al
f010024d:	74 0b                	je     f010025a <serial_proc_data+0x18>
f010024f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100254:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100255:	0f b6 c0             	movzbl %al,%eax
}
f0100258:	5d                   	pop    %ebp
f0100259:	c3                   	ret    
		return -1;
f010025a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010025f:	eb f7                	jmp    f0100258 <serial_proc_data+0x16>

f0100261 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100261:	55                   	push   %ebp
f0100262:	89 e5                	mov    %esp,%ebp
f0100264:	56                   	push   %esi
f0100265:	53                   	push   %ebx
f0100266:	e8 d3 ff ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010026b:	81 c3 b5 bd 08 00    	add    $0x8bdb5,%ebx
f0100271:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
f0100273:	ff d6                	call   *%esi
f0100275:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100278:	74 2e                	je     f01002a8 <cons_intr+0x47>
		if (c == 0)
f010027a:	85 c0                	test   %eax,%eax
f010027c:	74 f5                	je     f0100273 <cons_intr+0x12>
			continue;
		cons.buf[cons.wpos++] = c;
f010027e:	8b 8b 04 23 00 00    	mov    0x2304(%ebx),%ecx
f0100284:	8d 51 01             	lea    0x1(%ecx),%edx
f0100287:	89 93 04 23 00 00    	mov    %edx,0x2304(%ebx)
f010028d:	88 84 0b 00 21 00 00 	mov    %al,0x2100(%ebx,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f0100294:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010029a:	75 d7                	jne    f0100273 <cons_intr+0x12>
			cons.wpos = 0;
f010029c:	c7 83 04 23 00 00 00 	movl   $0x0,0x2304(%ebx)
f01002a3:	00 00 00 
f01002a6:	eb cb                	jmp    f0100273 <cons_intr+0x12>
	}
}
f01002a8:	5b                   	pop    %ebx
f01002a9:	5e                   	pop    %esi
f01002aa:	5d                   	pop    %ebp
f01002ab:	c3                   	ret    

f01002ac <kbd_proc_data>:
{
f01002ac:	55                   	push   %ebp
f01002ad:	89 e5                	mov    %esp,%ebp
f01002af:	56                   	push   %esi
f01002b0:	53                   	push   %ebx
f01002b1:	e8 88 ff ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01002b6:	81 c3 6a bd 08 00    	add    $0x8bd6a,%ebx
f01002bc:	ba 64 00 00 00       	mov    $0x64,%edx
f01002c1:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002c2:	a8 01                	test   $0x1,%al
f01002c4:	0f 84 06 01 00 00    	je     f01003d0 <kbd_proc_data+0x124>
	if (stat & KBS_TERR)
f01002ca:	a8 20                	test   $0x20,%al
f01002cc:	0f 85 05 01 00 00    	jne    f01003d7 <kbd_proc_data+0x12b>
f01002d2:	ba 60 00 00 00       	mov    $0x60,%edx
f01002d7:	ec                   	in     (%dx),%al
f01002d8:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002da:	3c e0                	cmp    $0xe0,%al
f01002dc:	0f 84 93 00 00 00    	je     f0100375 <kbd_proc_data+0xc9>
	} else if (data & 0x80) {
f01002e2:	84 c0                	test   %al,%al
f01002e4:	0f 88 a0 00 00 00    	js     f010038a <kbd_proc_data+0xde>
	} else if (shift & E0ESC) {
f01002ea:	8b 8b e0 20 00 00    	mov    0x20e0(%ebx),%ecx
f01002f0:	f6 c1 40             	test   $0x40,%cl
f01002f3:	74 0e                	je     f0100303 <kbd_proc_data+0x57>
		data |= 0x80;
f01002f5:	83 c8 80             	or     $0xffffff80,%eax
f01002f8:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002fa:	83 e1 bf             	and    $0xffffffbf,%ecx
f01002fd:	89 8b e0 20 00 00    	mov    %ecx,0x20e0(%ebx)
	shift |= shiftcode[data];
f0100303:	0f b6 d2             	movzbl %dl,%edx
f0100306:	0f b6 84 13 c0 94 f7 	movzbl -0x86b40(%ebx,%edx,1),%eax
f010030d:	ff 
f010030e:	0b 83 e0 20 00 00    	or     0x20e0(%ebx),%eax
	shift ^= togglecode[data];
f0100314:	0f b6 8c 13 c0 93 f7 	movzbl -0x86c40(%ebx,%edx,1),%ecx
f010031b:	ff 
f010031c:	31 c8                	xor    %ecx,%eax
f010031e:	89 83 e0 20 00 00    	mov    %eax,0x20e0(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100324:	89 c1                	mov    %eax,%ecx
f0100326:	83 e1 03             	and    $0x3,%ecx
f0100329:	8b 8c 8b 00 20 00 00 	mov    0x2000(%ebx,%ecx,4),%ecx
f0100330:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100334:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f0100337:	a8 08                	test   $0x8,%al
f0100339:	74 0d                	je     f0100348 <kbd_proc_data+0x9c>
		if ('a' <= c && c <= 'z')
f010033b:	89 f2                	mov    %esi,%edx
f010033d:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f0100340:	83 f9 19             	cmp    $0x19,%ecx
f0100343:	77 7a                	ja     f01003bf <kbd_proc_data+0x113>
			c += 'A' - 'a';
f0100345:	83 ee 20             	sub    $0x20,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100348:	f7 d0                	not    %eax
f010034a:	a8 06                	test   $0x6,%al
f010034c:	75 33                	jne    f0100381 <kbd_proc_data+0xd5>
f010034e:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f0100354:	75 2b                	jne    f0100381 <kbd_proc_data+0xd5>
		cprintf("Rebooting!\n");
f0100356:	83 ec 0c             	sub    $0xc,%esp
f0100359:	8d 83 7b 93 f7 ff    	lea    -0x86c85(%ebx),%eax
f010035f:	50                   	push   %eax
f0100360:	e8 18 38 00 00       	call   f0103b7d <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100365:	b8 03 00 00 00       	mov    $0x3,%eax
f010036a:	ba 92 00 00 00       	mov    $0x92,%edx
f010036f:	ee                   	out    %al,(%dx)
f0100370:	83 c4 10             	add    $0x10,%esp
f0100373:	eb 0c                	jmp    f0100381 <kbd_proc_data+0xd5>
		shift |= E0ESC;
f0100375:	83 8b e0 20 00 00 40 	orl    $0x40,0x20e0(%ebx)
		return 0;
f010037c:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100381:	89 f0                	mov    %esi,%eax
f0100383:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100386:	5b                   	pop    %ebx
f0100387:	5e                   	pop    %esi
f0100388:	5d                   	pop    %ebp
f0100389:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010038a:	8b 8b e0 20 00 00    	mov    0x20e0(%ebx),%ecx
f0100390:	89 ce                	mov    %ecx,%esi
f0100392:	83 e6 40             	and    $0x40,%esi
f0100395:	83 e0 7f             	and    $0x7f,%eax
f0100398:	85 f6                	test   %esi,%esi
f010039a:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010039d:	0f b6 d2             	movzbl %dl,%edx
f01003a0:	0f b6 84 13 c0 94 f7 	movzbl -0x86b40(%ebx,%edx,1),%eax
f01003a7:	ff 
f01003a8:	83 c8 40             	or     $0x40,%eax
f01003ab:	0f b6 c0             	movzbl %al,%eax
f01003ae:	f7 d0                	not    %eax
f01003b0:	21 c8                	and    %ecx,%eax
f01003b2:	89 83 e0 20 00 00    	mov    %eax,0x20e0(%ebx)
		return 0;
f01003b8:	be 00 00 00 00       	mov    $0x0,%esi
f01003bd:	eb c2                	jmp    f0100381 <kbd_proc_data+0xd5>
		else if ('A' <= c && c <= 'Z')
f01003bf:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003c2:	8d 4e 20             	lea    0x20(%esi),%ecx
f01003c5:	83 fa 1a             	cmp    $0x1a,%edx
f01003c8:	0f 42 f1             	cmovb  %ecx,%esi
f01003cb:	e9 78 ff ff ff       	jmp    f0100348 <kbd_proc_data+0x9c>
		return -1;
f01003d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01003d5:	eb aa                	jmp    f0100381 <kbd_proc_data+0xd5>
		return -1;
f01003d7:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01003dc:	eb a3                	jmp    f0100381 <kbd_proc_data+0xd5>

f01003de <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003de:	55                   	push   %ebp
f01003df:	89 e5                	mov    %esp,%ebp
f01003e1:	57                   	push   %edi
f01003e2:	56                   	push   %esi
f01003e3:	53                   	push   %ebx
f01003e4:	83 ec 1c             	sub    $0x1c,%esp
f01003e7:	e8 52 fe ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01003ec:	81 c3 34 bc 08 00    	add    $0x8bc34,%ebx
f01003f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
f01003f5:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003fa:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01003ff:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100404:	eb 09                	jmp    f010040f <cons_putc+0x31>
f0100406:	89 ca                	mov    %ecx,%edx
f0100408:	ec                   	in     (%dx),%al
f0100409:	ec                   	in     (%dx),%al
f010040a:	ec                   	in     (%dx),%al
f010040b:	ec                   	in     (%dx),%al
	     i++)
f010040c:	83 c6 01             	add    $0x1,%esi
f010040f:	89 fa                	mov    %edi,%edx
f0100411:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100412:	a8 20                	test   $0x20,%al
f0100414:	75 08                	jne    f010041e <cons_putc+0x40>
f0100416:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010041c:	7e e8                	jle    f0100406 <cons_putc+0x28>
	outb(COM1 + COM_TX, c);
f010041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100421:	89 f8                	mov    %edi,%eax
f0100423:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100426:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010042b:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010042c:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100431:	bf 79 03 00 00       	mov    $0x379,%edi
f0100436:	b9 84 00 00 00       	mov    $0x84,%ecx
f010043b:	eb 09                	jmp    f0100446 <cons_putc+0x68>
f010043d:	89 ca                	mov    %ecx,%edx
f010043f:	ec                   	in     (%dx),%al
f0100440:	ec                   	in     (%dx),%al
f0100441:	ec                   	in     (%dx),%al
f0100442:	ec                   	in     (%dx),%al
f0100443:	83 c6 01             	add    $0x1,%esi
f0100446:	89 fa                	mov    %edi,%edx
f0100448:	ec                   	in     (%dx),%al
f0100449:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010044f:	7f 04                	jg     f0100455 <cons_putc+0x77>
f0100451:	84 c0                	test   %al,%al
f0100453:	79 e8                	jns    f010043d <cons_putc+0x5f>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100455:	ba 78 03 00 00       	mov    $0x378,%edx
f010045a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f010045e:	ee                   	out    %al,(%dx)
f010045f:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100464:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100469:	ee                   	out    %al,(%dx)
f010046a:	b8 08 00 00 00       	mov    $0x8,%eax
f010046f:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100473:	89 fa                	mov    %edi,%edx
f0100475:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010047b:	89 f8                	mov    %edi,%eax
f010047d:	80 cc 07             	or     $0x7,%ah
f0100480:	85 d2                	test   %edx,%edx
f0100482:	0f 45 c7             	cmovne %edi,%eax
f0100485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
f0100488:	0f b6 c0             	movzbl %al,%eax
f010048b:	83 f8 09             	cmp    $0x9,%eax
f010048e:	0f 84 b9 00 00 00    	je     f010054d <cons_putc+0x16f>
f0100494:	83 f8 09             	cmp    $0x9,%eax
f0100497:	7e 74                	jle    f010050d <cons_putc+0x12f>
f0100499:	83 f8 0a             	cmp    $0xa,%eax
f010049c:	0f 84 9e 00 00 00    	je     f0100540 <cons_putc+0x162>
f01004a2:	83 f8 0d             	cmp    $0xd,%eax
f01004a5:	0f 85 d9 00 00 00    	jne    f0100584 <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
f01004ab:	0f b7 83 08 23 00 00 	movzwl 0x2308(%ebx),%eax
f01004b2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004b8:	c1 e8 16             	shr    $0x16,%eax
f01004bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004be:	c1 e0 04             	shl    $0x4,%eax
f01004c1:	66 89 83 08 23 00 00 	mov    %ax,0x2308(%ebx)
	if (crt_pos >= CRT_SIZE) {
f01004c8:	66 81 bb 08 23 00 00 	cmpw   $0x7cf,0x2308(%ebx)
f01004cf:	cf 07 
f01004d1:	0f 87 d4 00 00 00    	ja     f01005ab <cons_putc+0x1cd>
	outb(addr_6845, 14);
f01004d7:	8b 8b 10 23 00 00    	mov    0x2310(%ebx),%ecx
f01004dd:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004e2:	89 ca                	mov    %ecx,%edx
f01004e4:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004e5:	0f b7 9b 08 23 00 00 	movzwl 0x2308(%ebx),%ebx
f01004ec:	8d 71 01             	lea    0x1(%ecx),%esi
f01004ef:	89 d8                	mov    %ebx,%eax
f01004f1:	66 c1 e8 08          	shr    $0x8,%ax
f01004f5:	89 f2                	mov    %esi,%edx
f01004f7:	ee                   	out    %al,(%dx)
f01004f8:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004fd:	89 ca                	mov    %ecx,%edx
f01004ff:	ee                   	out    %al,(%dx)
f0100500:	89 d8                	mov    %ebx,%eax
f0100502:	89 f2                	mov    %esi,%edx
f0100504:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100505:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100508:	5b                   	pop    %ebx
f0100509:	5e                   	pop    %esi
f010050a:	5f                   	pop    %edi
f010050b:	5d                   	pop    %ebp
f010050c:	c3                   	ret    
	switch (c & 0xff) {
f010050d:	83 f8 08             	cmp    $0x8,%eax
f0100510:	75 72                	jne    f0100584 <cons_putc+0x1a6>
		if (crt_pos > 0) {
f0100512:	0f b7 83 08 23 00 00 	movzwl 0x2308(%ebx),%eax
f0100519:	66 85 c0             	test   %ax,%ax
f010051c:	74 b9                	je     f01004d7 <cons_putc+0xf9>
			crt_pos--;
f010051e:	83 e8 01             	sub    $0x1,%eax
f0100521:	66 89 83 08 23 00 00 	mov    %ax,0x2308(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100528:	0f b7 c0             	movzwl %ax,%eax
f010052b:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f010052f:	b2 00                	mov    $0x0,%dl
f0100531:	83 ca 20             	or     $0x20,%edx
f0100534:	8b 8b 0c 23 00 00    	mov    0x230c(%ebx),%ecx
f010053a:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f010053e:	eb 88                	jmp    f01004c8 <cons_putc+0xea>
		crt_pos += CRT_COLS;
f0100540:	66 83 83 08 23 00 00 	addw   $0x50,0x2308(%ebx)
f0100547:	50 
f0100548:	e9 5e ff ff ff       	jmp    f01004ab <cons_putc+0xcd>
		cons_putc(' ');
f010054d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100552:	e8 87 fe ff ff       	call   f01003de <cons_putc>
		cons_putc(' ');
f0100557:	b8 20 00 00 00       	mov    $0x20,%eax
f010055c:	e8 7d fe ff ff       	call   f01003de <cons_putc>
		cons_putc(' ');
f0100561:	b8 20 00 00 00       	mov    $0x20,%eax
f0100566:	e8 73 fe ff ff       	call   f01003de <cons_putc>
		cons_putc(' ');
f010056b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100570:	e8 69 fe ff ff       	call   f01003de <cons_putc>
		cons_putc(' ');
f0100575:	b8 20 00 00 00       	mov    $0x20,%eax
f010057a:	e8 5f fe ff ff       	call   f01003de <cons_putc>
f010057f:	e9 44 ff ff ff       	jmp    f01004c8 <cons_putc+0xea>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100584:	0f b7 83 08 23 00 00 	movzwl 0x2308(%ebx),%eax
f010058b:	8d 50 01             	lea    0x1(%eax),%edx
f010058e:	66 89 93 08 23 00 00 	mov    %dx,0x2308(%ebx)
f0100595:	0f b7 c0             	movzwl %ax,%eax
f0100598:	8b 93 0c 23 00 00    	mov    0x230c(%ebx),%edx
f010059e:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f01005a2:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005a6:	e9 1d ff ff ff       	jmp    f01004c8 <cons_putc+0xea>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005ab:	8b 83 0c 23 00 00    	mov    0x230c(%ebx),%eax
f01005b1:	83 ec 04             	sub    $0x4,%esp
f01005b4:	68 00 0f 00 00       	push   $0xf00
f01005b9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005bf:	52                   	push   %edx
f01005c0:	50                   	push   %eax
f01005c1:	e8 1f 47 00 00       	call   f0104ce5 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005c6:	8b 93 0c 23 00 00    	mov    0x230c(%ebx),%edx
f01005cc:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005d2:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005d8:	83 c4 10             	add    $0x10,%esp
f01005db:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e0:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e3:	39 d0                	cmp    %edx,%eax
f01005e5:	75 f4                	jne    f01005db <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f01005e7:	66 83 ab 08 23 00 00 	subw   $0x50,0x2308(%ebx)
f01005ee:	50 
f01005ef:	e9 e3 fe ff ff       	jmp    f01004d7 <cons_putc+0xf9>

f01005f4 <serial_intr>:
{
f01005f4:	e8 e7 01 00 00       	call   f01007e0 <__x86.get_pc_thunk.ax>
f01005f9:	05 27 ba 08 00       	add    $0x8ba27,%eax
	if (serial_exists)
f01005fe:	80 b8 14 23 00 00 00 	cmpb   $0x0,0x2314(%eax)
f0100605:	75 02                	jne    f0100609 <serial_intr+0x15>
f0100607:	f3 c3                	repz ret 
{
f0100609:	55                   	push   %ebp
f010060a:	89 e5                	mov    %esp,%ebp
f010060c:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010060f:	8d 80 22 42 f7 ff    	lea    -0x8bdde(%eax),%eax
f0100615:	e8 47 fc ff ff       	call   f0100261 <cons_intr>
}
f010061a:	c9                   	leave  
f010061b:	c3                   	ret    

f010061c <kbd_intr>:
{
f010061c:	55                   	push   %ebp
f010061d:	89 e5                	mov    %esp,%ebp
f010061f:	83 ec 08             	sub    $0x8,%esp
f0100622:	e8 b9 01 00 00       	call   f01007e0 <__x86.get_pc_thunk.ax>
f0100627:	05 f9 b9 08 00       	add    $0x8b9f9,%eax
	cons_intr(kbd_proc_data);
f010062c:	8d 80 8c 42 f7 ff    	lea    -0x8bd74(%eax),%eax
f0100632:	e8 2a fc ff ff       	call   f0100261 <cons_intr>
}
f0100637:	c9                   	leave  
f0100638:	c3                   	ret    

f0100639 <cons_getc>:
{
f0100639:	55                   	push   %ebp
f010063a:	89 e5                	mov    %esp,%ebp
f010063c:	53                   	push   %ebx
f010063d:	83 ec 04             	sub    $0x4,%esp
f0100640:	e8 f9 fb ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0100645:	81 c3 db b9 08 00    	add    $0x8b9db,%ebx
	serial_intr();
f010064b:	e8 a4 ff ff ff       	call   f01005f4 <serial_intr>
	kbd_intr();
f0100650:	e8 c7 ff ff ff       	call   f010061c <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100655:	8b 93 00 23 00 00    	mov    0x2300(%ebx),%edx
	return 0;
f010065b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100660:	3b 93 04 23 00 00    	cmp    0x2304(%ebx),%edx
f0100666:	74 19                	je     f0100681 <cons_getc+0x48>
		c = cons.buf[cons.rpos++];
f0100668:	8d 4a 01             	lea    0x1(%edx),%ecx
f010066b:	89 8b 00 23 00 00    	mov    %ecx,0x2300(%ebx)
f0100671:	0f b6 84 13 00 21 00 	movzbl 0x2100(%ebx,%edx,1),%eax
f0100678:	00 
		if (cons.rpos == CONSBUFSIZE)
f0100679:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010067f:	74 06                	je     f0100687 <cons_getc+0x4e>
}
f0100681:	83 c4 04             	add    $0x4,%esp
f0100684:	5b                   	pop    %ebx
f0100685:	5d                   	pop    %ebp
f0100686:	c3                   	ret    
			cons.rpos = 0;
f0100687:	c7 83 00 23 00 00 00 	movl   $0x0,0x2300(%ebx)
f010068e:	00 00 00 
f0100691:	eb ee                	jmp    f0100681 <cons_getc+0x48>

f0100693 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100693:	55                   	push   %ebp
f0100694:	89 e5                	mov    %esp,%ebp
f0100696:	57                   	push   %edi
f0100697:	56                   	push   %esi
f0100698:	53                   	push   %ebx
f0100699:	83 ec 1c             	sub    $0x1c,%esp
f010069c:	e8 9d fb ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01006a1:	81 c3 7f b9 08 00    	add    $0x8b97f,%ebx
	was = *cp;
f01006a7:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006ae:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006b5:	5a a5 
	if (*cp != 0xA55A) {
f01006b7:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006be:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006c2:	0f 84 bc 00 00 00    	je     f0100784 <cons_init+0xf1>
		addr_6845 = MONO_BASE;
f01006c8:	c7 83 10 23 00 00 b4 	movl   $0x3b4,0x2310(%ebx)
f01006cf:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006d2:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
	outb(addr_6845, 14);
f01006d9:	8b bb 10 23 00 00    	mov    0x2310(%ebx),%edi
f01006df:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006e4:	89 fa                	mov    %edi,%edx
f01006e6:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006e7:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006ea:	89 ca                	mov    %ecx,%edx
f01006ec:	ec                   	in     (%dx),%al
f01006ed:	0f b6 f0             	movzbl %al,%esi
f01006f0:	c1 e6 08             	shl    $0x8,%esi
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006f3:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006f8:	89 fa                	mov    %edi,%edx
f01006fa:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006fb:	89 ca                	mov    %ecx,%edx
f01006fd:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100701:	89 bb 0c 23 00 00    	mov    %edi,0x230c(%ebx)
	pos |= inb(addr_6845 + 1);
f0100707:	0f b6 c0             	movzbl %al,%eax
f010070a:	09 c6                	or     %eax,%esi
	crt_pos = pos;
f010070c:	66 89 b3 08 23 00 00 	mov    %si,0x2308(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100713:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100718:	89 c8                	mov    %ecx,%eax
f010071a:	ba fa 03 00 00       	mov    $0x3fa,%edx
f010071f:	ee                   	out    %al,(%dx)
f0100720:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100725:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010072a:	89 fa                	mov    %edi,%edx
f010072c:	ee                   	out    %al,(%dx)
f010072d:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100732:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100737:	ee                   	out    %al,(%dx)
f0100738:	be f9 03 00 00       	mov    $0x3f9,%esi
f010073d:	89 c8                	mov    %ecx,%eax
f010073f:	89 f2                	mov    %esi,%edx
f0100741:	ee                   	out    %al,(%dx)
f0100742:	b8 03 00 00 00       	mov    $0x3,%eax
f0100747:	89 fa                	mov    %edi,%edx
f0100749:	ee                   	out    %al,(%dx)
f010074a:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010074f:	89 c8                	mov    %ecx,%eax
f0100751:	ee                   	out    %al,(%dx)
f0100752:	b8 01 00 00 00       	mov    $0x1,%eax
f0100757:	89 f2                	mov    %esi,%edx
f0100759:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010075a:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010075f:	ec                   	in     (%dx),%al
f0100760:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100762:	3c ff                	cmp    $0xff,%al
f0100764:	0f 95 83 14 23 00 00 	setne  0x2314(%ebx)
f010076b:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100770:	ec                   	in     (%dx),%al
f0100771:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100776:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f0100777:	80 f9 ff             	cmp    $0xff,%cl
f010077a:	74 25                	je     f01007a1 <cons_init+0x10e>
		cprintf("Serial port does not exist!\n");
}
f010077c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010077f:	5b                   	pop    %ebx
f0100780:	5e                   	pop    %esi
f0100781:	5f                   	pop    %edi
f0100782:	5d                   	pop    %ebp
f0100783:	c3                   	ret    
		*cp = was;
f0100784:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010078b:	c7 83 10 23 00 00 d4 	movl   $0x3d4,0x2310(%ebx)
f0100792:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100795:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f010079c:	e9 38 ff ff ff       	jmp    f01006d9 <cons_init+0x46>
		cprintf("Serial port does not exist!\n");
f01007a1:	83 ec 0c             	sub    $0xc,%esp
f01007a4:	8d 83 87 93 f7 ff    	lea    -0x86c79(%ebx),%eax
f01007aa:	50                   	push   %eax
f01007ab:	e8 cd 33 00 00       	call   f0103b7d <cprintf>
f01007b0:	83 c4 10             	add    $0x10,%esp
}
f01007b3:	eb c7                	jmp    f010077c <cons_init+0xe9>

f01007b5 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007b5:	55                   	push   %ebp
f01007b6:	89 e5                	mov    %esp,%ebp
f01007b8:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01007be:	e8 1b fc ff ff       	call   f01003de <cons_putc>
}
f01007c3:	c9                   	leave  
f01007c4:	c3                   	ret    

f01007c5 <getchar>:

int
getchar(void)
{
f01007c5:	55                   	push   %ebp
f01007c6:	89 e5                	mov    %esp,%ebp
f01007c8:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007cb:	e8 69 fe ff ff       	call   f0100639 <cons_getc>
f01007d0:	85 c0                	test   %eax,%eax
f01007d2:	74 f7                	je     f01007cb <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007d4:	c9                   	leave  
f01007d5:	c3                   	ret    

f01007d6 <iscons>:

int
iscons(int fdnum)
{
f01007d6:	55                   	push   %ebp
f01007d7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007d9:	b8 01 00 00 00       	mov    $0x1,%eax
f01007de:	5d                   	pop    %ebp
f01007df:	c3                   	ret    

f01007e0 <__x86.get_pc_thunk.ax>:
f01007e0:	8b 04 24             	mov    (%esp),%eax
f01007e3:	c3                   	ret    

f01007e4 <mon_help>:
};

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf) {
f01007e4:	55                   	push   %ebp
f01007e5:	89 e5                	mov    %esp,%ebp
f01007e7:	56                   	push   %esi
f01007e8:	53                   	push   %ebx
f01007e9:	e8 50 fa ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01007ee:	81 c3 32 b8 08 00    	add    $0x8b832,%ebx
    int i;

    for (i = 0; i < ARRAY_SIZE(commands); i++)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007f4:	83 ec 04             	sub    $0x4,%esp
f01007f7:	8d 83 c0 95 f7 ff    	lea    -0x86a40(%ebx),%eax
f01007fd:	50                   	push   %eax
f01007fe:	8d 83 de 95 f7 ff    	lea    -0x86a22(%ebx),%eax
f0100804:	50                   	push   %eax
f0100805:	8d b3 e3 95 f7 ff    	lea    -0x86a1d(%ebx),%esi
f010080b:	56                   	push   %esi
f010080c:	e8 6c 33 00 00       	call   f0103b7d <cprintf>
f0100811:	83 c4 0c             	add    $0xc,%esp
f0100814:	8d 83 88 96 f7 ff    	lea    -0x86978(%ebx),%eax
f010081a:	50                   	push   %eax
f010081b:	8d 83 ec 95 f7 ff    	lea    -0x86a14(%ebx),%eax
f0100821:	50                   	push   %eax
f0100822:	56                   	push   %esi
f0100823:	e8 55 33 00 00       	call   f0103b7d <cprintf>
f0100828:	83 c4 0c             	add    $0xc,%esp
f010082b:	8d 83 f5 95 f7 ff    	lea    -0x86a0b(%ebx),%eax
f0100831:	50                   	push   %eax
f0100832:	8d 83 13 96 f7 ff    	lea    -0x869ed(%ebx),%eax
f0100838:	50                   	push   %eax
f0100839:	56                   	push   %esi
f010083a:	e8 3e 33 00 00       	call   f0103b7d <cprintf>
    return 0;
}
f010083f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100844:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100847:	5b                   	pop    %ebx
f0100848:	5e                   	pop    %esi
f0100849:	5d                   	pop    %ebp
f010084a:	c3                   	ret    

f010084b <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf) {
f010084b:	55                   	push   %ebp
f010084c:	89 e5                	mov    %esp,%ebp
f010084e:	57                   	push   %edi
f010084f:	56                   	push   %esi
f0100850:	53                   	push   %ebx
f0100851:	83 ec 18             	sub    $0x18,%esp
f0100854:	e8 e5 f9 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0100859:	81 c3 c7 b7 08 00    	add    $0x8b7c7,%ebx
    extern char _start[], entry[], etext[], edata[], end[];

    cprintf("Special kernel symbols:\n");
f010085f:	8d 83 1d 96 f7 ff    	lea    -0x869e3(%ebx),%eax
f0100865:	50                   	push   %eax
f0100866:	e8 12 33 00 00       	call   f0103b7d <cprintf>
    cprintf("  _start                  %08x (phys)\n", _start);
f010086b:	83 c4 08             	add    $0x8,%esp
f010086e:	ff b3 f8 ff ff ff    	pushl  -0x8(%ebx)
f0100874:	8d 83 b0 96 f7 ff    	lea    -0x86950(%ebx),%eax
f010087a:	50                   	push   %eax
f010087b:	e8 fd 32 00 00       	call   f0103b7d <cprintf>
    cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100880:	83 c4 0c             	add    $0xc,%esp
f0100883:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f0100889:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f010088f:	50                   	push   %eax
f0100890:	57                   	push   %edi
f0100891:	8d 83 d8 96 f7 ff    	lea    -0x86928(%ebx),%eax
f0100897:	50                   	push   %eax
f0100898:	e8 e0 32 00 00       	call   f0103b7d <cprintf>
    cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010089d:	83 c4 0c             	add    $0xc,%esp
f01008a0:	c7 c0 d9 50 10 f0    	mov    $0xf01050d9,%eax
f01008a6:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01008ac:	52                   	push   %edx
f01008ad:	50                   	push   %eax
f01008ae:	8d 83 fc 96 f7 ff    	lea    -0x86904(%ebx),%eax
f01008b4:	50                   	push   %eax
f01008b5:	e8 c3 32 00 00       	call   f0103b7d <cprintf>
    cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008ba:	83 c4 0c             	add    $0xc,%esp
f01008bd:	c7 c0 00 e1 18 f0    	mov    $0xf018e100,%eax
f01008c3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01008c9:	52                   	push   %edx
f01008ca:	50                   	push   %eax
f01008cb:	8d 83 20 97 f7 ff    	lea    -0x868e0(%ebx),%eax
f01008d1:	50                   	push   %eax
f01008d2:	e8 a6 32 00 00       	call   f0103b7d <cprintf>
    cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008d7:	83 c4 0c             	add    $0xc,%esp
f01008da:	c7 c6 14 f0 18 f0    	mov    $0xf018f014,%esi
f01008e0:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01008e6:	50                   	push   %eax
f01008e7:	56                   	push   %esi
f01008e8:	8d 83 44 97 f7 ff    	lea    -0x868bc(%ebx),%eax
f01008ee:	50                   	push   %eax
f01008ef:	e8 89 32 00 00       	call   f0103b7d <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
f01008f4:	83 c4 08             	add    $0x8,%esp
            ROUNDUP(end - entry, 1024) / 1024);
f01008f7:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
f01008fd:	29 fe                	sub    %edi,%esi
    cprintf("Kernel executable memory footprint: %dKB\n",
f01008ff:	c1 fe 0a             	sar    $0xa,%esi
f0100902:	56                   	push   %esi
f0100903:	8d 83 68 97 f7 ff    	lea    -0x86898(%ebx),%eax
f0100909:	50                   	push   %eax
f010090a:	e8 6e 32 00 00       	call   f0103b7d <cprintf>
    return 0;
}
f010090f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100914:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100917:	5b                   	pop    %ebx
f0100918:	5e                   	pop    %esi
f0100919:	5f                   	pop    %edi
f010091a:	5d                   	pop    %ebp
f010091b:	c3                   	ret    

f010091c <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf) {
f010091c:	55                   	push   %ebp
f010091d:	89 e5                	mov    %esp,%ebp
f010091f:	57                   	push   %edi
f0100920:	56                   	push   %esi
f0100921:	53                   	push   %ebx
f0100922:	83 ec 3c             	sub    $0x3c,%esp
f0100925:	e8 14 f9 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010092a:	81 c3 f6 b6 08 00    	add    $0x8b6f6,%ebx

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100930:	89 ee                	mov    %ebp,%esi
    uintptr_t ebp = read_ebp();
    while (ebp) {
        uintptr_t eip = *(uintptr_t *) (ebp + 0x4);
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, *(uintptr_t *) (ebp + 0x8),
f0100932:	8d 83 94 97 f7 ff    	lea    -0x8686c(%ebx),%eax
f0100938:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                *(uintptr_t *) (ebp + 0xc),
                *(uintptr_t *) (ebp + 0x10), *(uintptr_t *) (ebp + 0x14));
        struct Eipdebuginfo eipDebugInfo;
        debuginfo_eip(eip, &eipDebugInfo);
f010093b:	8d 45 d0             	lea    -0x30(%ebp),%eax
f010093e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    while (ebp) {
f0100941:	eb 4c                	jmp    f010098f <mon_backtrace+0x73>
        uintptr_t eip = *(uintptr_t *) (ebp + 0x4);
f0100943:	8b 7e 04             	mov    0x4(%esi),%edi
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, *(uintptr_t *) (ebp + 0x8),
f0100946:	83 ec 04             	sub    $0x4,%esp
f0100949:	ff 76 14             	pushl  0x14(%esi)
f010094c:	ff 76 10             	pushl  0x10(%esi)
f010094f:	ff 76 0c             	pushl  0xc(%esi)
f0100952:	ff 76 08             	pushl  0x8(%esi)
f0100955:	57                   	push   %edi
f0100956:	56                   	push   %esi
f0100957:	ff 75 c4             	pushl  -0x3c(%ebp)
f010095a:	e8 1e 32 00 00       	call   f0103b7d <cprintf>
        debuginfo_eip(eip, &eipDebugInfo);
f010095f:	83 c4 18             	add    $0x18,%esp
f0100962:	ff 75 c0             	pushl  -0x40(%ebp)
f0100965:	57                   	push   %edi
f0100966:	e8 e5 37 00 00       	call   f0104150 <debuginfo_eip>
        cprintf("\t %s:%d:  %.*s+%d\n", eipDebugInfo.eip_file, eipDebugInfo.eip_line, eipDebugInfo.eip_fn_namelen, eipDebugInfo.eip_fn_name,
f010096b:	83 c4 08             	add    $0x8,%esp
f010096e:	2b 7d e0             	sub    -0x20(%ebp),%edi
f0100971:	57                   	push   %edi
f0100972:	ff 75 d8             	pushl  -0x28(%ebp)
f0100975:	ff 75 dc             	pushl  -0x24(%ebp)
f0100978:	ff 75 d4             	pushl  -0x2c(%ebp)
f010097b:	ff 75 d0             	pushl  -0x30(%ebp)
f010097e:	8d 83 36 96 f7 ff    	lea    -0x869ca(%ebx),%eax
f0100984:	50                   	push   %eax
f0100985:	e8 f3 31 00 00       	call   f0103b7d <cprintf>
                eip - eipDebugInfo.eip_fn_addr);
        ebp = *(uintptr_t *) ebp;
f010098a:	8b 36                	mov    (%esi),%esi
f010098c:	83 c4 20             	add    $0x20,%esp
    while (ebp) {
f010098f:	85 f6                	test   %esi,%esi
f0100991:	75 b0                	jne    f0100943 <mon_backtrace+0x27>
    }
    return 1;
}
f0100993:	b8 01 00 00 00       	mov    $0x1,%eax
f0100998:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010099b:	5b                   	pop    %ebx
f010099c:	5e                   	pop    %esi
f010099d:	5f                   	pop    %edi
f010099e:	5d                   	pop    %ebp
f010099f:	c3                   	ret    

f01009a0 <monitor>:
    cprintf("Unknown command '%s'\n", argv[0]);
    return 0;
}

void
monitor(struct Trapframe *tf) {
f01009a0:	55                   	push   %ebp
f01009a1:	89 e5                	mov    %esp,%ebp
f01009a3:	57                   	push   %edi
f01009a4:	56                   	push   %esi
f01009a5:	53                   	push   %ebx
f01009a6:	83 ec 68             	sub    $0x68,%esp
f01009a9:	e8 90 f8 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01009ae:	81 c3 72 b6 08 00    	add    $0x8b672,%ebx
    char *buf;

    cprintf("Welcome to the JOS kernel monitor!\n");
f01009b4:	8d 83 cc 97 f7 ff    	lea    -0x86834(%ebx),%eax
f01009ba:	50                   	push   %eax
f01009bb:	e8 bd 31 00 00       	call   f0103b7d <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
f01009c0:	8d 83 f0 97 f7 ff    	lea    -0x86810(%ebx),%eax
f01009c6:	89 04 24             	mov    %eax,(%esp)
f01009c9:	e8 af 31 00 00       	call   f0103b7d <cprintf>

	if (tf != NULL)
f01009ce:	83 c4 10             	add    $0x10,%esp
f01009d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009d5:	74 0e                	je     f01009e5 <monitor+0x45>
		print_trapframe(tf);
f01009d7:	83 ec 0c             	sub    $0xc,%esp
f01009da:	ff 75 08             	pushl  0x8(%ebp)
f01009dd:	e8 31 33 00 00       	call   f0103d13 <print_trapframe>
f01009e2:	83 c4 10             	add    $0x10,%esp
        while (*buf && strchr(WHITESPACE, *buf))
f01009e5:	8d bb 4d 96 f7 ff    	lea    -0x869b3(%ebx),%edi
f01009eb:	eb 4a                	jmp    f0100a37 <monitor+0x97>
f01009ed:	83 ec 08             	sub    $0x8,%esp
f01009f0:	0f be c0             	movsbl %al,%eax
f01009f3:	50                   	push   %eax
f01009f4:	57                   	push   %edi
f01009f5:	e8 61 42 00 00       	call   f0104c5b <strchr>
f01009fa:	83 c4 10             	add    $0x10,%esp
f01009fd:	85 c0                	test   %eax,%eax
f01009ff:	74 08                	je     f0100a09 <monitor+0x69>
            *buf++ = 0;
f0100a01:	c6 06 00             	movb   $0x0,(%esi)
f0100a04:	8d 76 01             	lea    0x1(%esi),%esi
f0100a07:	eb 76                	jmp    f0100a7f <monitor+0xdf>
        if (*buf == 0)
f0100a09:	80 3e 00             	cmpb   $0x0,(%esi)
f0100a0c:	74 7c                	je     f0100a8a <monitor+0xea>
        if (argc == MAXARGS - 1) {
f0100a0e:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
f0100a12:	74 0f                	je     f0100a23 <monitor+0x83>
        argv[argc++] = buf;
f0100a14:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100a17:	8d 48 01             	lea    0x1(%eax),%ecx
f0100a1a:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
f0100a1d:	89 74 85 a8          	mov    %esi,-0x58(%ebp,%eax,4)
f0100a21:	eb 41                	jmp    f0100a64 <monitor+0xc4>
            cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a23:	83 ec 08             	sub    $0x8,%esp
f0100a26:	6a 10                	push   $0x10
f0100a28:	8d 83 52 96 f7 ff    	lea    -0x869ae(%ebx),%eax
f0100a2e:	50                   	push   %eax
f0100a2f:	e8 49 31 00 00       	call   f0103b7d <cprintf>
f0100a34:	83 c4 10             	add    $0x10,%esp

    while (1) {
        buf = readline("K> ");
f0100a37:	8d 83 49 96 f7 ff    	lea    -0x869b7(%ebx),%eax
f0100a3d:	89 c6                	mov    %eax,%esi
f0100a3f:	83 ec 0c             	sub    $0xc,%esp
f0100a42:	56                   	push   %esi
f0100a43:	e8 db 3f 00 00       	call   f0104a23 <readline>
        if (buf != NULL)
f0100a48:	83 c4 10             	add    $0x10,%esp
f0100a4b:	85 c0                	test   %eax,%eax
f0100a4d:	74 f0                	je     f0100a3f <monitor+0x9f>
f0100a4f:	89 c6                	mov    %eax,%esi
    argv[argc] = 0;
f0100a51:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
    argc = 0;
f0100a58:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f0100a5f:	eb 1e                	jmp    f0100a7f <monitor+0xdf>
            buf++;
f0100a61:	83 c6 01             	add    $0x1,%esi
        while (*buf && !strchr(WHITESPACE, *buf))
f0100a64:	0f b6 06             	movzbl (%esi),%eax
f0100a67:	84 c0                	test   %al,%al
f0100a69:	74 14                	je     f0100a7f <monitor+0xdf>
f0100a6b:	83 ec 08             	sub    $0x8,%esp
f0100a6e:	0f be c0             	movsbl %al,%eax
f0100a71:	50                   	push   %eax
f0100a72:	57                   	push   %edi
f0100a73:	e8 e3 41 00 00       	call   f0104c5b <strchr>
f0100a78:	83 c4 10             	add    $0x10,%esp
f0100a7b:	85 c0                	test   %eax,%eax
f0100a7d:	74 e2                	je     f0100a61 <monitor+0xc1>
        while (*buf && strchr(WHITESPACE, *buf))
f0100a7f:	0f b6 06             	movzbl (%esi),%eax
f0100a82:	84 c0                	test   %al,%al
f0100a84:	0f 85 63 ff ff ff    	jne    f01009ed <monitor+0x4d>
    argv[argc] = 0;
f0100a8a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100a8d:	c7 44 85 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%eax,4)
f0100a94:	00 
    if (argc == 0)
f0100a95:	85 c0                	test   %eax,%eax
f0100a97:	74 9e                	je     f0100a37 <monitor+0x97>
f0100a99:	8d b3 20 20 00 00    	lea    0x2020(%ebx),%esi
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a9f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100aa4:	89 7d a0             	mov    %edi,-0x60(%ebp)
f0100aa7:	89 c7                	mov    %eax,%edi
        if (strcmp(argv[0], commands[i].name) == 0)
f0100aa9:	83 ec 08             	sub    $0x8,%esp
f0100aac:	ff 36                	pushl  (%esi)
f0100aae:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ab1:	e8 47 41 00 00       	call   f0104bfd <strcmp>
f0100ab6:	83 c4 10             	add    $0x10,%esp
f0100ab9:	85 c0                	test   %eax,%eax
f0100abb:	74 28                	je     f0100ae5 <monitor+0x145>
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100abd:	83 c7 01             	add    $0x1,%edi
f0100ac0:	83 c6 0c             	add    $0xc,%esi
f0100ac3:	83 ff 03             	cmp    $0x3,%edi
f0100ac6:	75 e1                	jne    f0100aa9 <monitor+0x109>
f0100ac8:	8b 7d a0             	mov    -0x60(%ebp),%edi
    cprintf("Unknown command '%s'\n", argv[0]);
f0100acb:	83 ec 08             	sub    $0x8,%esp
f0100ace:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ad1:	8d 83 6f 96 f7 ff    	lea    -0x86991(%ebx),%eax
f0100ad7:	50                   	push   %eax
f0100ad8:	e8 a0 30 00 00       	call   f0103b7d <cprintf>
f0100add:	83 c4 10             	add    $0x10,%esp
f0100ae0:	e9 52 ff ff ff       	jmp    f0100a37 <monitor+0x97>
f0100ae5:	89 f8                	mov    %edi,%eax
f0100ae7:	8b 7d a0             	mov    -0x60(%ebp),%edi
            return commands[i].func(argc, argv, tf);
f0100aea:	83 ec 04             	sub    $0x4,%esp
f0100aed:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100af0:	ff 75 08             	pushl  0x8(%ebp)
f0100af3:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100af6:	52                   	push   %edx
f0100af7:	ff 75 a4             	pushl  -0x5c(%ebp)
f0100afa:	ff 94 83 28 20 00 00 	call   *0x2028(%ebx,%eax,4)
            if (runcmd(buf, tf) < 0)
f0100b01:	83 c4 10             	add    $0x10,%esp
f0100b04:	85 c0                	test   %eax,%eax
f0100b06:	0f 89 2b ff ff ff    	jns    f0100a37 <monitor+0x97>
                break;
    }
f0100b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b0f:	5b                   	pop    %ebx
f0100b10:	5e                   	pop    %esi
f0100b11:	5f                   	pop    %edi
f0100b12:	5d                   	pop    %ebp
f0100b13:	c3                   	ret    

f0100b14 <nvram_read>:
// --------------------------------------------------------------
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r) {
f0100b14:	55                   	push   %ebp
f0100b15:	89 e5                	mov    %esp,%ebp
f0100b17:	57                   	push   %edi
f0100b18:	56                   	push   %esi
f0100b19:	53                   	push   %ebx
f0100b1a:	83 ec 18             	sub    $0x18,%esp
f0100b1d:	e8 1c f7 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0100b22:	81 c3 fe b4 08 00    	add    $0x8b4fe,%ebx
f0100b28:	89 c7                	mov    %eax,%edi
    return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b2a:	50                   	push   %eax
f0100b2b:	e8 c6 2f 00 00       	call   f0103af6 <mc146818_read>
f0100b30:	89 c6                	mov    %eax,%esi
f0100b32:	83 c7 01             	add    $0x1,%edi
f0100b35:	89 3c 24             	mov    %edi,(%esp)
f0100b38:	e8 b9 2f 00 00       	call   f0103af6 <mc146818_read>
f0100b3d:	c1 e0 08             	shl    $0x8,%eax
f0100b40:	09 f0                	or     %esi,%eax
}
f0100b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b45:	5b                   	pop    %ebx
f0100b46:	5e                   	pop    %esi
f0100b47:	5f                   	pop    %edi
f0100b48:	5d                   	pop    %ebp
f0100b49:	c3                   	ret    

f0100b4a <boot_alloc>:
//
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n) {
f0100b4a:	55                   	push   %ebp
f0100b4b:	89 e5                	mov    %esp,%ebp
f0100b4d:	56                   	push   %esi
f0100b4e:	53                   	push   %ebx
f0100b4f:	e8 b3 2a 00 00       	call   f0103607 <__x86.get_pc_thunk.dx>
f0100b54:	81 c2 cc b4 08 00    	add    $0x8b4cc,%edx
    // Initialize nextfree if this is the first time.
    // 'end' is a magic symbol automatically generated by the linker,
    // which points to the end of the kernel's bss segment:
    // the first virtual address that the linker did *not* assign
    // to any kernel code or global variables.
    if (!nextfree) {
f0100b5a:	83 ba 18 23 00 00 00 	cmpl   $0x0,0x2318(%edx)
f0100b61:	74 2c                	je     f0100b8f <boot_alloc+0x45>
    }

    // Allocate a chunk large enough to hold 'n' bytes, then update
    // nextfree.  Make sure nextfree is kept aligned
    // to a multiple of PGSIZE.
    result = nextfree;
f0100b63:	8b 8a 18 23 00 00    	mov    0x2318(%edx),%ecx
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100b69:	8d 71 ff             	lea    -0x1(%ecx),%esi
f0100b6c:	89 c3                	mov    %eax,%ebx
f0100b6e:	f7 d3                	not    %ebx
f0100b70:	39 de                	cmp    %ebx,%esi
f0100b72:	77 35                	ja     f0100ba9 <boot_alloc+0x5f>
    nextfree = ROUNDUP((result + n), PGSIZE);
f0100b74:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f0100b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b80:	89 82 18 23 00 00    	mov    %eax,0x2318(%edx)

    return result;
}
f0100b86:	89 c8                	mov    %ecx,%eax
f0100b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b8b:	5b                   	pop    %ebx
f0100b8c:	5e                   	pop    %esi
f0100b8d:	5d                   	pop    %ebp
f0100b8e:	c3                   	ret    
        nextfree = ROUNDUP((char *) end, PGSIZE);
f0100b8f:	c7 c1 14 f0 18 f0    	mov    $0xf018f014,%ecx
f0100b95:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0100b9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100ba1:	89 8a 18 23 00 00    	mov    %ecx,0x2318(%edx)
f0100ba7:	eb ba                	jmp    f0100b63 <boot_alloc+0x19>
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100ba9:	8d 82 18 98 f7 ff    	lea    -0x867e8(%edx),%eax
f0100baf:	50                   	push   %eax
f0100bb0:	8d 82 b1 a5 f7 ff    	lea    -0x85a4f(%edx),%eax
f0100bb6:	50                   	push   %eax
f0100bb7:	6a 71                	push   $0x71
f0100bb9:	8d 82 c6 a5 f7 ff    	lea    -0x85a3a(%edx),%eax
f0100bbf:	50                   	push   %eax
f0100bc0:	89 d3                	mov    %edx,%ebx
f0100bc2:	e8 c1 f5 ff ff       	call   f0100188 <_panic>

f0100bc7 <check_va2pa>:
// defined by the page directory 'pgdir'.  The hardware normally performs
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va) {
f0100bc7:	55                   	push   %ebp
f0100bc8:	89 e5                	mov    %esp,%ebp
f0100bca:	56                   	push   %esi
f0100bcb:	53                   	push   %ebx
f0100bcc:	e8 3a 2a 00 00       	call   f010360b <__x86.get_pc_thunk.cx>
f0100bd1:	81 c1 4f b4 08 00    	add    $0x8b44f,%ecx
    pte_t *p;

    pgdir = &pgdir[PDX(va)];
f0100bd7:	89 d3                	mov    %edx,%ebx
f0100bd9:	c1 eb 16             	shr    $0x16,%ebx
    if (!(*pgdir & PTE_P))
f0100bdc:	8b 04 98             	mov    (%eax,%ebx,4),%eax
f0100bdf:	a8 01                	test   $0x1,%al
f0100be1:	74 5a                	je     f0100c3d <check_va2pa+0x76>
        return ~0;
    p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
f0100be3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100be8:	89 c6                	mov    %eax,%esi
f0100bea:	c1 ee 0c             	shr    $0xc,%esi
f0100bed:	c7 c3 08 f0 18 f0    	mov    $0xf018f008,%ebx
f0100bf3:	3b 33                	cmp    (%ebx),%esi
f0100bf5:	73 2b                	jae    f0100c22 <check_va2pa+0x5b>
    if (!(p[PTX(va)] & PTE_P))
f0100bf7:	c1 ea 0c             	shr    $0xc,%edx
f0100bfa:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100c00:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100c07:	89 c2                	mov    %eax,%edx
f0100c09:	83 e2 01             	and    $0x1,%edx
        return ~0;
    return PTE_ADDR(p[PTX(va)]);
f0100c0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100c11:	85 d2                	test   %edx,%edx
f0100c13:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100c18:	0f 44 c2             	cmove  %edx,%eax
}
f0100c1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c1e:	5b                   	pop    %ebx
f0100c1f:	5e                   	pop    %esi
f0100c20:	5d                   	pop    %ebp
f0100c21:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c22:	50                   	push   %eax
f0100c23:	8d 81 40 98 f7 ff    	lea    -0x867c0(%ecx),%eax
f0100c29:	50                   	push   %eax
f0100c2a:	68 42 03 00 00       	push   $0x342
f0100c2f:	8d 81 c6 a5 f7 ff    	lea    -0x85a3a(%ecx),%eax
f0100c35:	50                   	push   %eax
f0100c36:	89 cb                	mov    %ecx,%ebx
f0100c38:	e8 4b f5 ff ff       	call   f0100188 <_panic>
        return ~0;
f0100c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c42:	eb d7                	jmp    f0100c1b <check_va2pa+0x54>

f0100c44 <check_page_free_list>:
check_page_free_list(bool only_low_memory) {
f0100c44:	55                   	push   %ebp
f0100c45:	89 e5                	mov    %esp,%ebp
f0100c47:	57                   	push   %edi
f0100c48:	56                   	push   %esi
f0100c49:	53                   	push   %ebx
f0100c4a:	83 ec 3c             	sub    $0x3c,%esp
f0100c4d:	e8 bd 29 00 00       	call   f010360f <__x86.get_pc_thunk.di>
f0100c52:	81 c7 ce b3 08 00    	add    $0x8b3ce,%edi
f0100c58:	89 7d c4             	mov    %edi,-0x3c(%ebp)
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c5b:	84 c0                	test   %al,%al
f0100c5d:	0f 85 25 03 00 00    	jne    f0100f88 <check_page_free_list+0x344>
    if (!page_free_list)
f0100c63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100c66:	83 b8 20 23 00 00 00 	cmpl   $0x0,0x2320(%eax)
f0100c6d:	74 0c                	je     f0100c7b <check_page_free_list+0x37>
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c6f:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
f0100c76:	e9 99 03 00 00       	jmp    f0101014 <check_page_free_list+0x3d0>
        panic("'page_free_list' is a null pointer!");
f0100c7b:	83 ec 04             	sub    $0x4,%esp
f0100c7e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c81:	8d 83 64 98 f7 ff    	lea    -0x8679c(%ebx),%eax
f0100c87:	50                   	push   %eax
f0100c88:	68 77 02 00 00       	push   $0x277
f0100c8d:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100c93:	50                   	push   %eax
f0100c94:	e8 ef f4 ff ff       	call   f0100188 <_panic>
f0100c99:	50                   	push   %eax
f0100c9a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c9d:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0100ca3:	50                   	push   %eax
f0100ca4:	6a 56                	push   $0x56
f0100ca6:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0100cac:	50                   	push   %eax
f0100cad:	e8 d6 f4 ff ff       	call   f0100188 <_panic>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0100cb2:	8b 36                	mov    (%esi),%esi
f0100cb4:	85 f6                	test   %esi,%esi
f0100cb6:	74 40                	je     f0100cf8 <check_page_free_list+0xb4>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100cb8:	89 f0                	mov    %esi,%eax
f0100cba:	2b 07                	sub    (%edi),%eax
f0100cbc:	c1 f8 03             	sar    $0x3,%eax
f0100cbf:	c1 e0 0c             	shl    $0xc,%eax
        if (PDX(page2pa(pp)) < pdx_limit) {
f0100cc2:	89 c2                	mov    %eax,%edx
f0100cc4:	c1 ea 16             	shr    $0x16,%edx
f0100cc7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100cca:	73 e6                	jae    f0100cb2 <check_page_free_list+0x6e>
	if (PGNUM(pa) >= npages)
f0100ccc:	89 c2                	mov    %eax,%edx
f0100cce:	c1 ea 0c             	shr    $0xc,%edx
f0100cd1:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0100cd4:	3b 13                	cmp    (%ebx),%edx
f0100cd6:	73 c1                	jae    f0100c99 <check_page_free_list+0x55>
            memset(page2kva(pp), 0x97, 128);
f0100cd8:	83 ec 04             	sub    $0x4,%esp
f0100cdb:	68 80 00 00 00       	push   $0x80
f0100ce0:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100ce5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100cea:	50                   	push   %eax
f0100ceb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100cee:	e8 a5 3f 00 00       	call   f0104c98 <memset>
f0100cf3:	83 c4 10             	add    $0x10,%esp
f0100cf6:	eb ba                	jmp    f0100cb2 <check_page_free_list+0x6e>
    first_free_page = (char *) boot_alloc(0);
f0100cf8:	b8 00 00 00 00       	mov    $0x0,%eax
f0100cfd:	e8 48 fe ff ff       	call   f0100b4a <boot_alloc>
f0100d02:	89 45 c8             	mov    %eax,-0x38(%ebp)
    cprintf("first_free_page:0x%x\n", first_free_page);
f0100d05:	83 ec 08             	sub    $0x8,%esp
f0100d08:	50                   	push   %eax
f0100d09:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100d0c:	8d 87 e0 a5 f7 ff    	lea    -0x85a20(%edi),%eax
f0100d12:	50                   	push   %eax
f0100d13:	89 fb                	mov    %edi,%ebx
f0100d15:	e8 63 2e 00 00       	call   f0103b7d <cprintf>
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d1a:	8b 97 20 23 00 00    	mov    0x2320(%edi),%edx
        assert(pp >= pages);
f0100d20:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0100d26:	8b 08                	mov    (%eax),%ecx
        assert(pp < pages + npages);
f0100d28:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f0100d2e:	8b 00                	mov    (%eax),%eax
f0100d30:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100d33:	8d 1c c1             	lea    (%ecx,%eax,8),%ebx
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d36:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d39:	83 c4 10             	add    $0x10,%esp
    int nfree_basemem = 0, nfree_extmem = 0;
f0100d3c:	bf 00 00 00 00       	mov    $0x0,%edi
f0100d41:	89 75 d0             	mov    %esi,-0x30(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d44:	e9 08 01 00 00       	jmp    f0100e51 <check_page_free_list+0x20d>
        assert(pp >= pages);
f0100d49:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d4c:	8d 83 f6 a5 f7 ff    	lea    -0x85a0a(%ebx),%eax
f0100d52:	50                   	push   %eax
f0100d53:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100d59:	50                   	push   %eax
f0100d5a:	68 98 02 00 00       	push   $0x298
f0100d5f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100d65:	50                   	push   %eax
f0100d66:	e8 1d f4 ff ff       	call   f0100188 <_panic>
        assert(pp < pages + npages);
f0100d6b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d6e:	8d 83 02 a6 f7 ff    	lea    -0x859fe(%ebx),%eax
f0100d74:	50                   	push   %eax
f0100d75:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100d7b:	50                   	push   %eax
f0100d7c:	68 99 02 00 00       	push   $0x299
f0100d81:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100d87:	50                   	push   %eax
f0100d88:	e8 fb f3 ff ff       	call   f0100188 <_panic>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d8d:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d90:	8d 83 d4 98 f7 ff    	lea    -0x8672c(%ebx),%eax
f0100d96:	50                   	push   %eax
f0100d97:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100d9d:	50                   	push   %eax
f0100d9e:	68 9a 02 00 00       	push   $0x29a
f0100da3:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100da9:	50                   	push   %eax
f0100daa:	e8 d9 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != 0);
f0100daf:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100db2:	8d 83 16 a6 f7 ff    	lea    -0x859ea(%ebx),%eax
f0100db8:	50                   	push   %eax
f0100db9:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100dbf:	50                   	push   %eax
f0100dc0:	68 9d 02 00 00       	push   $0x29d
f0100dc5:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100dcb:	50                   	push   %eax
f0100dcc:	e8 b7 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != IOPHYSMEM);
f0100dd1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100dd4:	8d 83 27 a6 f7 ff    	lea    -0x859d9(%ebx),%eax
f0100dda:	50                   	push   %eax
f0100ddb:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100de1:	50                   	push   %eax
f0100de2:	68 9e 02 00 00       	push   $0x29e
f0100de7:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100ded:	50                   	push   %eax
f0100dee:	e8 95 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100df3:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100df6:	8d 83 08 99 f7 ff    	lea    -0x866f8(%ebx),%eax
f0100dfc:	50                   	push   %eax
f0100dfd:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100e03:	50                   	push   %eax
f0100e04:	68 9f 02 00 00       	push   $0x29f
f0100e09:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100e0f:	50                   	push   %eax
f0100e10:	e8 73 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100e15:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100e18:	8d 83 40 a6 f7 ff    	lea    -0x859c0(%ebx),%eax
f0100e1e:	50                   	push   %eax
f0100e1f:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100e25:	50                   	push   %eax
f0100e26:	68 a0 02 00 00       	push   $0x2a0
f0100e2b:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100e31:	50                   	push   %eax
f0100e32:	e8 51 f3 ff ff       	call   f0100188 <_panic>
	if (PGNUM(pa) >= npages)
f0100e37:	89 c6                	mov    %eax,%esi
f0100e39:	c1 ee 0c             	shr    $0xc,%esi
f0100e3c:	39 75 cc             	cmp    %esi,-0x34(%ebp)
f0100e3f:	76 70                	jbe    f0100eb1 <check_page_free_list+0x26d>
	return (void *)(pa + KERNBASE);
f0100e41:	2d 00 00 00 10       	sub    $0x10000000,%eax
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100e46:	39 45 c8             	cmp    %eax,-0x38(%ebp)
f0100e49:	77 7f                	ja     f0100eca <check_page_free_list+0x286>
            ++nfree_extmem;
f0100e4b:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e4f:	8b 12                	mov    (%edx),%edx
f0100e51:	85 d2                	test   %edx,%edx
f0100e53:	0f 84 93 00 00 00    	je     f0100eec <check_page_free_list+0x2a8>
        assert(pp >= pages);
f0100e59:	39 d1                	cmp    %edx,%ecx
f0100e5b:	0f 87 e8 fe ff ff    	ja     f0100d49 <check_page_free_list+0x105>
        assert(pp < pages + npages);
f0100e61:	39 d3                	cmp    %edx,%ebx
f0100e63:	0f 86 02 ff ff ff    	jbe    f0100d6b <check_page_free_list+0x127>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100e69:	89 d0                	mov    %edx,%eax
f0100e6b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
f0100e6e:	a8 07                	test   $0x7,%al
f0100e70:	0f 85 17 ff ff ff    	jne    f0100d8d <check_page_free_list+0x149>
	return (pp - pages) << PGSHIFT;
f0100e76:	c1 f8 03             	sar    $0x3,%eax
f0100e79:	c1 e0 0c             	shl    $0xc,%eax
        assert(page2pa(pp) != 0);
f0100e7c:	85 c0                	test   %eax,%eax
f0100e7e:	0f 84 2b ff ff ff    	je     f0100daf <check_page_free_list+0x16b>
        assert(page2pa(pp) != IOPHYSMEM);
f0100e84:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100e89:	0f 84 42 ff ff ff    	je     f0100dd1 <check_page_free_list+0x18d>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100e8f:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100e94:	0f 84 59 ff ff ff    	je     f0100df3 <check_page_free_list+0x1af>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100e9a:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100e9f:	0f 84 70 ff ff ff    	je     f0100e15 <check_page_free_list+0x1d1>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ea5:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100eaa:	77 8b                	ja     f0100e37 <check_page_free_list+0x1f3>
            ++nfree_basemem;
f0100eac:	83 c7 01             	add    $0x1,%edi
f0100eaf:	eb 9e                	jmp    f0100e4f <check_page_free_list+0x20b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100eb1:	50                   	push   %eax
f0100eb2:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100eb5:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0100ebb:	50                   	push   %eax
f0100ebc:	6a 56                	push   $0x56
f0100ebe:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0100ec4:	50                   	push   %eax
f0100ec5:	e8 be f2 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100eca:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100ecd:	8d 83 2c 99 f7 ff    	lea    -0x866d4(%ebx),%eax
f0100ed3:	50                   	push   %eax
f0100ed4:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100eda:	50                   	push   %eax
f0100edb:	68 a1 02 00 00       	push   $0x2a1
f0100ee0:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100ee6:	50                   	push   %eax
f0100ee7:	e8 9c f2 ff ff       	call   f0100188 <_panic>
f0100eec:	8b 75 d0             	mov    -0x30(%ebp),%esi
    cprintf("nfree_basemem:0x%x\tnfree_extmem:0x%x\n", nfree_basemem, nfree_extmem);
f0100eef:	83 ec 04             	sub    $0x4,%esp
f0100ef2:	56                   	push   %esi
f0100ef3:	57                   	push   %edi
f0100ef4:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100ef7:	8d 83 74 99 f7 ff    	lea    -0x8668c(%ebx),%eax
f0100efd:	50                   	push   %eax
f0100efe:	e8 7a 2c 00 00       	call   f0103b7d <cprintf>
    cprintf("物理内存占用中页数:0x%x\n", 8 * PGSIZE - nfree_basemem - nfree_extmem);
f0100f03:	83 c4 08             	add    $0x8,%esp
f0100f06:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100f0b:	29 f8                	sub    %edi,%eax
f0100f0d:	29 f0                	sub    %esi,%eax
f0100f0f:	50                   	push   %eax
f0100f10:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f13:	8d 83 9c 99 f7 ff    	lea    -0x86664(%ebx),%eax
f0100f19:	50                   	push   %eax
f0100f1a:	e8 5e 2c 00 00       	call   f0103b7d <cprintf>
    assert(nfree_basemem > 0);
f0100f1f:	83 c4 10             	add    $0x10,%esp
f0100f22:	85 ff                	test   %edi,%edi
f0100f24:	7e 1e                	jle    f0100f44 <check_page_free_list+0x300>
    assert(nfree_extmem > 0);
f0100f26:	85 f6                	test   %esi,%esi
f0100f28:	7e 3c                	jle    f0100f66 <check_page_free_list+0x322>
    cprintf("check_page_free_list() succeeded!\n");
f0100f2a:	83 ec 0c             	sub    $0xc,%esp
f0100f2d:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f30:	8d 83 c0 99 f7 ff    	lea    -0x86640(%ebx),%eax
f0100f36:	50                   	push   %eax
f0100f37:	e8 41 2c 00 00       	call   f0103b7d <cprintf>
}
f0100f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f3f:	5b                   	pop    %ebx
f0100f40:	5e                   	pop    %esi
f0100f41:	5f                   	pop    %edi
f0100f42:	5d                   	pop    %ebp
f0100f43:	c3                   	ret    
    assert(nfree_basemem > 0);
f0100f44:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f47:	8d 83 5a a6 f7 ff    	lea    -0x859a6(%ebx),%eax
f0100f4d:	50                   	push   %eax
f0100f4e:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100f54:	50                   	push   %eax
f0100f55:	68 ad 02 00 00       	push   $0x2ad
f0100f5a:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100f60:	50                   	push   %eax
f0100f61:	e8 22 f2 ff ff       	call   f0100188 <_panic>
    assert(nfree_extmem > 0);
f0100f66:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f69:	8d 83 6c a6 f7 ff    	lea    -0x85994(%ebx),%eax
f0100f6f:	50                   	push   %eax
f0100f70:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0100f76:	50                   	push   %eax
f0100f77:	68 ae 02 00 00       	push   $0x2ae
f0100f7c:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0100f82:	50                   	push   %eax
f0100f83:	e8 00 f2 ff ff       	call   f0100188 <_panic>
    if (!page_free_list)
f0100f88:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100f8b:	8b 80 20 23 00 00    	mov    0x2320(%eax),%eax
f0100f91:	85 c0                	test   %eax,%eax
f0100f93:	0f 84 e2 fc ff ff    	je     f0100c7b <check_page_free_list+0x37>
        struct PageInfo **tp[2] = {&pp1, &pp2};
f0100f99:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100f9c:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100f9f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100fa2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100fa5:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100fa8:	c7 c3 10 f0 18 f0    	mov    $0xf018f010,%ebx
f0100fae:	89 c2                	mov    %eax,%edx
f0100fb0:	2b 13                	sub    (%ebx),%edx
            int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100fb2:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100fb8:	0f 95 c2             	setne  %dl
f0100fbb:	0f b6 d2             	movzbl %dl,%edx
            *tp[pagetype] = pp;
f0100fbe:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100fc2:	89 01                	mov    %eax,(%ecx)
            tp[pagetype] = &pp->pp_link;
f0100fc4:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
        for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fc8:	8b 00                	mov    (%eax),%eax
f0100fca:	85 c0                	test   %eax,%eax
f0100fcc:	75 e0                	jne    f0100fae <check_page_free_list+0x36a>
        cprintf("pp:0x%x\tpp1:0x%x\tpp2:0x%x\t*tp[1]:0x%x\t*tp[0]:0x%x\ttp[0]:0x%x\ttp[1]:0x%x\n", pp, pp1, pp2, *tp[1],
f0100fce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100fd1:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100fd4:	57                   	push   %edi
f0100fd5:	56                   	push   %esi
f0100fd6:	ff 36                	pushl  (%esi)
f0100fd8:	ff 37                	pushl  (%edi)
f0100fda:	ff 75 dc             	pushl  -0x24(%ebp)
f0100fdd:	ff 75 d8             	pushl  -0x28(%ebp)
f0100fe0:	6a 00                	push   $0x0
f0100fe2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0100fe5:	8d 81 88 98 f7 ff    	lea    -0x86778(%ecx),%eax
f0100feb:	50                   	push   %eax
f0100fec:	89 cb                	mov    %ecx,%ebx
f0100fee:	e8 8a 2b 00 00       	call   f0103b7d <cprintf>
        *tp[1] = 0;
f0100ff3:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
        *tp[0] = pp2;
f0100ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100ffc:	89 06                	mov    %eax,(%esi)
        page_free_list = pp1;
f0100ffe:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101001:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0101004:	89 81 20 23 00 00    	mov    %eax,0x2320(%ecx)
f010100a:	83 c4 20             	add    $0x20,%esp
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010100d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101014:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0101017:	8b b0 20 23 00 00    	mov    0x2320(%eax),%esi
f010101d:	c7 c7 10 f0 18 f0    	mov    $0xf018f010,%edi
	if (PGNUM(pa) >= npages)
f0101023:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f0101029:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010102c:	e9 83 fc ff ff       	jmp    f0100cb4 <check_page_free_list+0x70>

f0101031 <page_init>:
page_init(void) {
f0101031:	55                   	push   %ebp
f0101032:	89 e5                	mov    %esp,%ebp
f0101034:	57                   	push   %edi
f0101035:	56                   	push   %esi
f0101036:	53                   	push   %ebx
f0101037:	83 ec 1c             	sub    $0x1c,%esp
f010103a:	e8 ff f1 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010103f:	81 c3 e1 af 08 00    	add    $0x8afe1,%ebx
    physaddr_t baseMemFreeStart = PGSIZE, baseMemFreeEnd = npages_basemem * PGSIZE,
f0101045:	8b b3 24 23 00 00    	mov    0x2324(%ebx),%esi
f010104b:	89 f2                	mov    %esi,%edx
f010104d:	c1 e2 0c             	shl    $0xc,%edx
            extMemFreeStart = PADDR(pages) + ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) +
f0101050:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0101056:	8b 08                	mov    (%eax),%ecx
	if ((uint32_t)kva < KERNBASE)
f0101058:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f010105e:	76 7a                	jbe    f01010da <page_init+0xa9>
f0101060:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f0101066:	8b 00                	mov    (%eax),%eax
f0101068:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010106f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101074:	8d bc 01 00 80 01 10 	lea    0x10018000(%ecx,%eax,1),%edi
f010107b:	89 7d e0             	mov    %edi,-0x20(%ebp)
                              ROUNDUP(NENV * sizeof(struct Env), PGSIZE), extMemFreeEnd =
f010107e:	8b 83 1c 23 00 00    	mov    0x231c(%ebx),%eax
f0101084:	c1 e0 0a             	shl    $0xa,%eax
f0101087:	89 45 dc             	mov    %eax,-0x24(%ebp)
    cprintf("qemu空闲物理内存:[0x%x, 0x%x]\t[0x%x, 0x%x)\n", baseMemFreeStart, baseMemFreeEnd, extMemFreeStart,
f010108a:	83 ec 0c             	sub    $0xc,%esp
f010108d:	50                   	push   %eax
f010108e:	57                   	push   %edi
f010108f:	52                   	push   %edx
f0101090:	68 00 10 00 00       	push   $0x1000
f0101095:	8d 83 08 9a f7 ff    	lea    -0x865f8(%ebx),%eax
f010109b:	50                   	push   %eax
f010109c:	e8 dc 2a 00 00       	call   f0103b7d <cprintf>
    cprintf("初始page_free_list:0x%x\n", page_free_list);
f01010a1:	83 c4 18             	add    $0x18,%esp
f01010a4:	ff b3 20 23 00 00    	pushl  0x2320(%ebx)
f01010aa:	8d 83 7d a6 f7 ff    	lea    -0x85983(%ebx),%eax
f01010b0:	50                   	push   %eax
f01010b1:	e8 c7 2a 00 00       	call   f0103b7d <cprintf>
f01010b6:	8b bb 20 23 00 00    	mov    0x2320(%ebx),%edi
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f01010bc:	83 c4 10             	add    $0x10,%esp
f01010bf:	ba 00 00 00 00       	mov    $0x0,%edx
f01010c4:	b8 01 00 00 00       	mov    $0x1,%eax
f01010c9:	81 e6 ff ff 0f 00    	and    $0xfffff,%esi
f01010cf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        pages[i].pp_ref = 0;
f01010d2:	c7 c6 10 f0 18 f0    	mov    $0xf018f010,%esi
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f01010d8:	eb 38                	jmp    f0101112 <page_init+0xe1>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01010da:	51                   	push   %ecx
f01010db:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01010e1:	50                   	push   %eax
f01010e2:	68 2d 01 00 00       	push   $0x12d
f01010e7:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01010ed:	50                   	push   %eax
f01010ee:	e8 95 f0 ff ff       	call   f0100188 <_panic>
        pages[i].pp_ref = 0;
f01010f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f01010fa:	89 d1                	mov    %edx,%ecx
f01010fc:	03 0e                	add    (%esi),%ecx
f01010fe:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
        pages[i].pp_link = page_free_list;
f0101104:	89 39                	mov    %edi,(%ecx)
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0101106:	83 c0 01             	add    $0x1,%eax
        page_free_list = &pages[i];
f0101109:	89 d7                	mov    %edx,%edi
f010110b:	03 3e                	add    (%esi),%edi
f010110d:	ba 01 00 00 00       	mov    $0x1,%edx
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0101112:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0101115:	77 dc                	ja     f01010f3 <page_init+0xc2>
f0101117:	84 d2                	test   %dl,%dl
f0101119:	75 29                	jne    f0101144 <page_init+0x113>
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f010111b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010111e:	c1 ea 0c             	shr    $0xc,%edx
f0101121:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101124:	c1 e8 0c             	shr    $0xc,%eax
f0101127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010112a:	8b b3 20 23 00 00    	mov    0x2320(%ebx),%esi
f0101130:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
f0101137:	b9 00 00 00 00       	mov    $0x0,%ecx
        pages[i].pp_ref = 0;
f010113c:	c7 c7 10 f0 18 f0    	mov    $0xf018f010,%edi
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f0101142:	eb 23                	jmp    f0101167 <page_init+0x136>
f0101144:	89 bb 20 23 00 00    	mov    %edi,0x2320(%ebx)
f010114a:	eb cf                	jmp    f010111b <page_init+0xea>
        pages[i].pp_ref = 0;
f010114c:	89 c1                	mov    %eax,%ecx
f010114e:	03 0f                	add    (%edi),%ecx
f0101150:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
        pages[i].pp_link = page_free_list;
f0101156:	89 31                	mov    %esi,(%ecx)
        page_free_list = &pages[i];
f0101158:	89 c6                	mov    %eax,%esi
f010115a:	03 37                	add    (%edi),%esi
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f010115c:	83 c2 01             	add    $0x1,%edx
f010115f:	83 c0 08             	add    $0x8,%eax
f0101162:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101167:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
f010116a:	77 e0                	ja     f010114c <page_init+0x11b>
f010116c:	84 c9                	test   %cl,%cl
f010116e:	75 3b                	jne    f01011ab <page_init+0x17a>
               PADDR(page_free_list) >> 12);
f0101170:	8b 83 20 23 00 00    	mov    0x2320(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0101176:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010117b:	76 36                	jbe    f01011b3 <page_init+0x182>
	return (physaddr_t)kva - KERNBASE;
f010117d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("page_free_list", (uintptr_t) page_free_list, PDX(page_free_list), PADDR(page_free_list),
f0101183:	83 ec 0c             	sub    $0xc,%esp
f0101186:	89 d1                	mov    %edx,%ecx
f0101188:	c1 e9 0c             	shr    $0xc,%ecx
f010118b:	51                   	push   %ecx
f010118c:	52                   	push   %edx
f010118d:	89 c2                	mov    %eax,%edx
f010118f:	c1 ea 16             	shr    $0x16,%edx
f0101192:	52                   	push   %edx
f0101193:	50                   	push   %eax
f0101194:	8d 83 98 a6 f7 ff    	lea    -0x85968(%ebx),%eax
f010119a:	50                   	push   %eax
f010119b:	e8 f1 29 00 00       	call   f0103b91 <memCprintf>
}
f01011a0:	83 c4 20             	add    $0x20,%esp
f01011a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011a6:	5b                   	pop    %ebx
f01011a7:	5e                   	pop    %esi
f01011a8:	5f                   	pop    %edi
f01011a9:	5d                   	pop    %ebp
f01011aa:	c3                   	ret    
f01011ab:	89 b3 20 23 00 00    	mov    %esi,0x2320(%ebx)
f01011b1:	eb bd                	jmp    f0101170 <page_init+0x13f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01011b3:	50                   	push   %eax
f01011b4:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01011ba:	50                   	push   %eax
f01011bb:	68 44 01 00 00       	push   $0x144
f01011c0:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01011c6:	50                   	push   %eax
f01011c7:	e8 bc ef ff ff       	call   f0100188 <_panic>

f01011cc <page_alloc>:
page_alloc(int alloc_flags) {
f01011cc:	55                   	push   %ebp
f01011cd:	89 e5                	mov    %esp,%ebp
f01011cf:	56                   	push   %esi
f01011d0:	53                   	push   %ebx
f01011d1:	e8 68 f0 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01011d6:	81 c3 4a ae 08 00    	add    $0x8ae4a,%ebx
    if (!page_free_list) {
f01011dc:	8b b3 20 23 00 00    	mov    0x2320(%ebx),%esi
f01011e2:	85 f6                	test   %esi,%esi
f01011e4:	74 1a                	je     f0101200 <page_alloc+0x34>
    page_free_list = page_free_list->pp_link;
f01011e6:	8b 06                	mov    (%esi),%eax
f01011e8:	89 83 20 23 00 00    	mov    %eax,0x2320(%ebx)
    allocPage->pp_link = NULL;
f01011ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    allocPage->pp_ref = 0;
f01011f4:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
    if (alloc_flags & ALLOC_ZERO) {
f01011fa:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01011fe:	75 09                	jne    f0101209 <page_alloc+0x3d>
}
f0101200:	89 f0                	mov    %esi,%eax
f0101202:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101205:	5b                   	pop    %ebx
f0101206:	5e                   	pop    %esi
f0101207:	5d                   	pop    %ebp
f0101208:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101209:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f010120f:	89 f2                	mov    %esi,%edx
f0101211:	2b 10                	sub    (%eax),%edx
f0101213:	89 d0                	mov    %edx,%eax
f0101215:	c1 f8 03             	sar    $0x3,%eax
f0101218:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010121b:	89 c1                	mov    %eax,%ecx
f010121d:	c1 e9 0c             	shr    $0xc,%ecx
f0101220:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f0101226:	3b 0a                	cmp    (%edx),%ecx
f0101228:	73 1a                	jae    f0101244 <page_alloc+0x78>
        memset(page2kva(allocPage), 0, PGSIZE);
f010122a:	83 ec 04             	sub    $0x4,%esp
f010122d:	68 00 10 00 00       	push   $0x1000
f0101232:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101234:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101239:	50                   	push   %eax
f010123a:	e8 59 3a 00 00       	call   f0104c98 <memset>
f010123f:	83 c4 10             	add    $0x10,%esp
f0101242:	eb bc                	jmp    f0101200 <page_alloc+0x34>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101244:	50                   	push   %eax
f0101245:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f010124b:	50                   	push   %eax
f010124c:	6a 56                	push   $0x56
f010124e:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0101254:	50                   	push   %eax
f0101255:	e8 2e ef ff ff       	call   f0100188 <_panic>

f010125a <page_free>:
page_free(struct PageInfo *pp) {
f010125a:	55                   	push   %ebp
f010125b:	89 e5                	mov    %esp,%ebp
f010125d:	53                   	push   %ebx
f010125e:	83 ec 04             	sub    $0x4,%esp
f0101261:	e8 d8 ef ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0101266:	81 c3 ba ad 08 00    	add    $0x8adba,%ebx
f010126c:	8b 45 08             	mov    0x8(%ebp),%eax
    assert(!pp->pp_ref);
f010126f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101274:	75 18                	jne    f010128e <page_free+0x34>
    assert(!pp->pp_link);
f0101276:	83 38 00             	cmpl   $0x0,(%eax)
f0101279:	75 32                	jne    f01012ad <page_free+0x53>
    pp->pp_link = page_free_list;
f010127b:	8b 8b 20 23 00 00    	mov    0x2320(%ebx),%ecx
f0101281:	89 08                	mov    %ecx,(%eax)
    page_free_list = pp;
f0101283:	89 83 20 23 00 00    	mov    %eax,0x2320(%ebx)
}
f0101289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010128c:	c9                   	leave  
f010128d:	c3                   	ret    
    assert(!pp->pp_ref);
f010128e:	8d 83 a7 a6 f7 ff    	lea    -0x85959(%ebx),%eax
f0101294:	50                   	push   %eax
f0101295:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f010129b:	50                   	push   %eax
f010129c:	68 6b 01 00 00       	push   $0x16b
f01012a1:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01012a7:	50                   	push   %eax
f01012a8:	e8 db ee ff ff       	call   f0100188 <_panic>
    assert(!pp->pp_link);
f01012ad:	8d 83 b3 a6 f7 ff    	lea    -0x8594d(%ebx),%eax
f01012b3:	50                   	push   %eax
f01012b4:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01012ba:	50                   	push   %eax
f01012bb:	68 6c 01 00 00       	push   $0x16c
f01012c0:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01012c6:	50                   	push   %eax
f01012c7:	e8 bc ee ff ff       	call   f0100188 <_panic>

f01012cc <page_decref>:
page_decref(struct PageInfo *pp) {
f01012cc:	55                   	push   %ebp
f01012cd:	89 e5                	mov    %esp,%ebp
f01012cf:	83 ec 08             	sub    $0x8,%esp
f01012d2:	8b 55 08             	mov    0x8(%ebp),%edx
    if (--pp->pp_ref == 0)
f01012d5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01012d9:	83 e8 01             	sub    $0x1,%eax
f01012dc:	66 89 42 04          	mov    %ax,0x4(%edx)
f01012e0:	66 85 c0             	test   %ax,%ax
f01012e3:	74 02                	je     f01012e7 <page_decref+0x1b>
}
f01012e5:	c9                   	leave  
f01012e6:	c3                   	ret    
        page_free(pp);
f01012e7:	83 ec 0c             	sub    $0xc,%esp
f01012ea:	52                   	push   %edx
f01012eb:	e8 6a ff ff ff       	call   f010125a <page_free>
f01012f0:	83 c4 10             	add    $0x10,%esp
}
f01012f3:	eb f0                	jmp    f01012e5 <page_decref+0x19>

f01012f5 <pgdir_walk>:
pgdir_walk(pde_t *pgdir, const void *va, int create) {
f01012f5:	55                   	push   %ebp
f01012f6:	89 e5                	mov    %esp,%ebp
f01012f8:	57                   	push   %edi
f01012f9:	56                   	push   %esi
f01012fa:	53                   	push   %ebx
f01012fb:	83 ec 0c             	sub    $0xc,%esp
f01012fe:	e8 3b ef ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0101303:	81 c3 1d ad 08 00    	add    $0x8ad1d,%ebx
f0101309:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (!(pgTablePaAddr = PTE_ADDR(pgdir[PDX(va)]))) {
f010130c:	89 f7                	mov    %esi,%edi
f010130e:	c1 ef 16             	shr    $0x16,%edi
f0101311:	c1 e7 02             	shl    $0x2,%edi
f0101314:	03 7d 08             	add    0x8(%ebp),%edi
f0101317:	8b 07                	mov    (%edi),%eax
f0101319:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010131e:	75 31                	jne    f0101351 <pgdir_walk+0x5c>
        if (!create) {
f0101320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101324:	74 6b                	je     f0101391 <pgdir_walk+0x9c>
            struct PageInfo *pageInfo = page_alloc(ALLOC_ZERO);
f0101326:	83 ec 0c             	sub    $0xc,%esp
f0101329:	6a 01                	push   $0x1
f010132b:	e8 9c fe ff ff       	call   f01011cc <page_alloc>
            if (!pageInfo) {
f0101330:	83 c4 10             	add    $0x10,%esp
f0101333:	85 c0                	test   %eax,%eax
f0101335:	74 61                	je     f0101398 <pgdir_walk+0xa3>
            pageInfo->pp_ref++;
f0101337:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010133c:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f0101342:	2b 02                	sub    (%edx),%eax
f0101344:	c1 f8 03             	sar    $0x3,%eax
f0101347:	c1 e0 0c             	shl    $0xc,%eax
            pgdir[PDX(va)] = pgTablePaAddr | PTE_W | PTE_P;//消极权限
f010134a:	89 c2                	mov    %eax,%edx
f010134c:	83 ca 03             	or     $0x3,%edx
f010134f:	89 17                	mov    %edx,(%edi)
	if (PGNUM(pa) >= npages)
f0101351:	89 c1                	mov    %eax,%ecx
f0101353:	c1 e9 0c             	shr    $0xc,%ecx
f0101356:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f010135c:	3b 0a                	cmp    (%edx),%ecx
f010135e:	73 18                	jae    f0101378 <pgdir_walk+0x83>
    return &((pte_t *) KADDR(pgTablePaAddr))[PTX(va)];
f0101360:	c1 ee 0a             	shr    $0xa,%esi
f0101363:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101369:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f0101370:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101373:	5b                   	pop    %ebx
f0101374:	5e                   	pop    %esi
f0101375:	5f                   	pop    %edi
f0101376:	5d                   	pop    %ebp
f0101377:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101378:	50                   	push   %eax
f0101379:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f010137f:	50                   	push   %eax
f0101380:	68 ce 01 00 00       	push   $0x1ce
f0101385:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010138b:	50                   	push   %eax
f010138c:	e8 f7 ed ff ff       	call   f0100188 <_panic>
            return NULL;
f0101391:	b8 00 00 00 00       	mov    $0x0,%eax
f0101396:	eb d8                	jmp    f0101370 <pgdir_walk+0x7b>
                return NULL;
f0101398:	b8 00 00 00 00       	mov    $0x0,%eax
f010139d:	eb d1                	jmp    f0101370 <pgdir_walk+0x7b>

f010139f <boot_map_region>:
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm) {
f010139f:	55                   	push   %ebp
f01013a0:	89 e5                	mov    %esp,%ebp
f01013a2:	57                   	push   %edi
f01013a3:	56                   	push   %esi
f01013a4:	53                   	push   %ebx
f01013a5:	83 ec 1c             	sub    $0x1c,%esp
f01013a8:	89 c7                	mov    %eax,%edi
f01013aa:	89 d6                	mov    %edx,%esi
f01013ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE) {
f01013af:	bb 00 00 00 00       	mov    $0x0,%ebx
f01013b4:	eb 22                	jmp    f01013d8 <boot_map_region+0x39>
        pte_t *pte = pgdir_walk(pgdir, (void *) va + offset, 1);
f01013b6:	83 ec 04             	sub    $0x4,%esp
f01013b9:	6a 01                	push   $0x1
f01013bb:	8d 04 33             	lea    (%ebx,%esi,1),%eax
f01013be:	50                   	push   %eax
f01013bf:	57                   	push   %edi
f01013c0:	e8 30 ff ff ff       	call   f01012f5 <pgdir_walk>
        *pte = (pa + offset) | perm;
f01013c5:	89 da                	mov    %ebx,%edx
f01013c7:	03 55 08             	add    0x8(%ebp),%edx
f01013ca:	0b 55 0c             	or     0xc(%ebp),%edx
f01013cd:	89 10                	mov    %edx,(%eax)
    for (offset = 0; offset < size; offset += PGSIZE) {
f01013cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01013d5:	83 c4 10             	add    $0x10,%esp
f01013d8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01013db:	72 d9                	jb     f01013b6 <boot_map_region+0x17>
}
f01013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01013e0:	5b                   	pop    %ebx
f01013e1:	5e                   	pop    %esi
f01013e2:	5f                   	pop    %edi
f01013e3:	5d                   	pop    %ebp
f01013e4:	c3                   	ret    

f01013e5 <page_lookup>:
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store) {
f01013e5:	55                   	push   %ebp
f01013e6:	89 e5                	mov    %esp,%ebp
f01013e8:	56                   	push   %esi
f01013e9:	53                   	push   %ebx
f01013ea:	e8 4f ee ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01013ef:	81 c3 31 ac 08 00    	add    $0x8ac31,%ebx
f01013f5:	8b 75 10             	mov    0x10(%ebp),%esi
    pte_t *cur = pgdir_walk(pgdir, va, false);
f01013f8:	83 ec 04             	sub    $0x4,%esp
f01013fb:	6a 00                	push   $0x0
f01013fd:	ff 75 0c             	pushl  0xc(%ebp)
f0101400:	ff 75 08             	pushl  0x8(%ebp)
f0101403:	e8 ed fe ff ff       	call   f01012f5 <pgdir_walk>
    if (!cur) {
f0101408:	83 c4 10             	add    $0x10,%esp
f010140b:	85 c0                	test   %eax,%eax
f010140d:	74 3f                	je     f010144e <page_lookup+0x69>
    if (pte_store) {
f010140f:	85 f6                	test   %esi,%esi
f0101411:	74 02                	je     f0101415 <page_lookup+0x30>
        *pte_store = cur;
f0101413:	89 06                	mov    %eax,(%esi)
f0101415:	8b 00                	mov    (%eax),%eax
f0101417:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010141a:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f0101420:	39 02                	cmp    %eax,(%edx)
f0101422:	76 12                	jbe    f0101436 <page_lookup+0x51>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101424:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f010142a:	8b 12                	mov    (%edx),%edx
f010142c:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f010142f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101432:	5b                   	pop    %ebx
f0101433:	5e                   	pop    %esi
f0101434:	5d                   	pop    %ebp
f0101435:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101436:	83 ec 04             	sub    $0x4,%esp
f0101439:	8d 83 3c 9a f7 ff    	lea    -0x865c4(%ebx),%eax
f010143f:	50                   	push   %eax
f0101440:	6a 4f                	push   $0x4f
f0101442:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0101448:	50                   	push   %eax
f0101449:	e8 3a ed ff ff       	call   f0100188 <_panic>
        return NULL;
f010144e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101453:	eb da                	jmp    f010142f <page_lookup+0x4a>

f0101455 <page_remove>:
page_remove(pde_t *pgdir, void *va) {
f0101455:	55                   	push   %ebp
f0101456:	89 e5                	mov    %esp,%ebp
f0101458:	56                   	push   %esi
f0101459:	53                   	push   %ebx
f010145a:	83 ec 14             	sub    $0x14,%esp
f010145d:	e8 dc ed ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0101462:	81 c3 be ab 08 00    	add    $0x8abbe,%ebx
f0101468:	8b 75 0c             	mov    0xc(%ebp),%esi
    struct PageInfo *pageInfo = page_lookup(pgdir, va, &pte);
f010146b:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010146e:	50                   	push   %eax
f010146f:	56                   	push   %esi
f0101470:	ff 75 08             	pushl  0x8(%ebp)
f0101473:	e8 6d ff ff ff       	call   f01013e5 <page_lookup>
    if (!pageInfo) {
f0101478:	83 c4 10             	add    $0x10,%esp
f010147b:	85 c0                	test   %eax,%eax
f010147d:	75 07                	jne    f0101486 <page_remove+0x31>
}
f010147f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101482:	5b                   	pop    %ebx
f0101483:	5e                   	pop    %esi
f0101484:	5d                   	pop    %ebp
f0101485:	c3                   	ret    
    page_decref(pageInfo);
f0101486:	83 ec 0c             	sub    $0xc,%esp
f0101489:	50                   	push   %eax
f010148a:	e8 3d fe ff ff       	call   f01012cc <page_decref>
    memset(pte, 0, sizeof(pte_t));
f010148f:	83 c4 0c             	add    $0xc,%esp
f0101492:	6a 04                	push   $0x4
f0101494:	6a 00                	push   $0x0
f0101496:	ff 75 f4             	pushl  -0xc(%ebp)
f0101499:	e8 fa 37 00 00       	call   f0104c98 <memset>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010149e:	0f 01 3e             	invlpg (%esi)
f01014a1:	83 c4 10             	add    $0x10,%esp
f01014a4:	eb d9                	jmp    f010147f <page_remove+0x2a>

f01014a6 <page_insert>:
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm) {
f01014a6:	55                   	push   %ebp
f01014a7:	89 e5                	mov    %esp,%ebp
f01014a9:	57                   	push   %edi
f01014aa:	56                   	push   %esi
f01014ab:	53                   	push   %ebx
f01014ac:	83 ec 20             	sub    $0x20,%esp
f01014af:	e8 8a ed ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01014b4:	81 c3 6c ab 08 00    	add    $0x8ab6c,%ebx
f01014ba:	8b 75 08             	mov    0x8(%ebp),%esi
    pte_t *cur = pgdir_walk(pgdir, va, false);
f01014bd:	6a 00                	push   $0x0
f01014bf:	ff 75 10             	pushl  0x10(%ebp)
f01014c2:	56                   	push   %esi
f01014c3:	e8 2d fe ff ff       	call   f01012f5 <pgdir_walk>
f01014c8:	89 c7                	mov    %eax,%edi
    if (cur) {
f01014ca:	83 c4 10             	add    $0x10,%esp
f01014cd:	85 c0                	test   %eax,%eax
f01014cf:	74 4b                	je     f010151c <page_insert+0x76>
f01014d1:	8b 00                	mov    (%eax),%eax
f01014d3:	c1 e8 0c             	shr    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01014d6:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f01014dc:	39 02                	cmp    %eax,(%edx)
f01014de:	76 24                	jbe    f0101504 <page_insert+0x5e>
	return &pages[PGNUM(pa)];
f01014e0:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f01014e6:	8b 12                	mov    (%edx),%edx
f01014e8:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01014eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if (tmp != pp) {
f01014ee:	39 45 0c             	cmp    %eax,0xc(%ebp)
f01014f1:	74 30                	je     f0101523 <page_insert+0x7d>
            page_remove(pgdir, va);
f01014f3:	83 ec 08             	sub    $0x8,%esp
f01014f6:	ff 75 10             	pushl  0x10(%ebp)
f01014f9:	56                   	push   %esi
f01014fa:	e8 56 ff ff ff       	call   f0101455 <page_remove>
f01014ff:	83 c4 10             	add    $0x10,%esp
f0101502:	eb 1f                	jmp    f0101523 <page_insert+0x7d>
		panic("pa2page called with invalid pa");
f0101504:	83 ec 04             	sub    $0x4,%esp
f0101507:	8d 83 3c 9a f7 ff    	lea    -0x865c4(%ebx),%eax
f010150d:	50                   	push   %eax
f010150e:	6a 4f                	push   $0x4f
f0101510:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0101516:	50                   	push   %eax
f0101517:	e8 6c ec ff ff       	call   f0100188 <_panic>
    struct PageInfo *tmp = NULL;
f010151c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    physaddr_t pgTablePaAddr = PTE_ADDR(pgdir[PDX(va)]);
f0101523:	8b 45 10             	mov    0x10(%ebp),%eax
f0101526:	c1 e8 16             	shr    $0x16,%eax
f0101529:	8d 34 86             	lea    (%esi,%eax,4),%esi
    if (!pgTablePaAddr) {
f010152c:	8b 06                	mov    (%esi),%eax
f010152e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101533:	74 73                	je     f01015a8 <page_insert+0x102>
	return (pp - pages) << PGSHIFT;
f0101535:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f010153b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010153e:	2b 0a                	sub    (%edx),%ecx
f0101540:	89 ca                	mov    %ecx,%edx
f0101542:	c1 fa 03             	sar    $0x3,%edx
f0101545:	c1 e2 0c             	shl    $0xc,%edx
f0101548:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010154b:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010154e:	83 c9 01             	or     $0x1,%ecx
f0101551:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	if (PGNUM(pa) >= npages)
f0101554:	89 c2                	mov    %eax,%edx
f0101556:	c1 ea 0c             	shr    $0xc,%edx
f0101559:	c7 c1 08 f0 18 f0    	mov    $0xf018f008,%ecx
f010155f:	3b 11                	cmp    (%ecx),%edx
f0101561:	73 78                	jae    f01015db <page_insert+0x135>
    ((pte_t *) KADDR(pgTablePaAddr))[PTX(va)] = page2pa(pp) | perm | PTE_P;
f0101563:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101566:	c1 eb 0c             	shr    $0xc,%ebx
f0101569:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010156f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101572:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0101575:	09 ca                	or     %ecx,%edx
f0101577:	89 94 98 00 00 00 f0 	mov    %edx,-0x10000000(%eax,%ebx,4)
    pgdir[PDX(va)] = pgTablePaAddr | perm | PTE_P;
f010157e:	09 c8                	or     %ecx,%eax
f0101580:	89 06                	mov    %eax,(%esi)
    if (!cur || tmp != pp) {
f0101582:	85 ff                	test   %edi,%edi
f0101584:	74 0d                	je     f0101593 <page_insert+0xed>
    return 0;
f0101586:	b8 00 00 00 00       	mov    $0x0,%eax
    if (!cur || tmp != pp) {
f010158b:	8b 7d dc             	mov    -0x24(%ebp),%edi
f010158e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
f0101591:	74 0d                	je     f01015a0 <page_insert+0xfa>
        pp->pp_ref++;
f0101593:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101596:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    return 0;
f010159b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01015a3:	5b                   	pop    %ebx
f01015a4:	5e                   	pop    %esi
f01015a5:	5f                   	pop    %edi
f01015a6:	5d                   	pop    %ebp
f01015a7:	c3                   	ret    
        struct PageInfo *pageInfo = page_alloc(ALLOC_ZERO);
f01015a8:	83 ec 0c             	sub    $0xc,%esp
f01015ab:	6a 01                	push   $0x1
f01015ad:	e8 1a fc ff ff       	call   f01011cc <page_alloc>
        if (!pageInfo) {
f01015b2:	83 c4 10             	add    $0x10,%esp
f01015b5:	85 c0                	test   %eax,%eax
f01015b7:	74 3b                	je     f01015f4 <page_insert+0x14e>
        pageInfo->pp_ref++;
f01015b9:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01015be:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f01015c4:	2b 02                	sub    (%edx),%eax
f01015c6:	c1 f8 03             	sar    $0x3,%eax
f01015c9:	c1 e0 0c             	shl    $0xc,%eax
        pgdir[PDX(va)] = pgTablePaAddr | perm | PTE_P;
f01015cc:	8b 55 14             	mov    0x14(%ebp),%edx
f01015cf:	83 ca 01             	or     $0x1,%edx
f01015d2:	09 c2                	or     %eax,%edx
f01015d4:	89 16                	mov    %edx,(%esi)
f01015d6:	e9 5a ff ff ff       	jmp    f0101535 <page_insert+0x8f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01015db:	50                   	push   %eax
f01015dc:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f01015e2:	50                   	push   %eax
f01015e3:	68 1a 02 00 00       	push   $0x21a
f01015e8:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01015ee:	50                   	push   %eax
f01015ef:	e8 94 eb ff ff       	call   f0100188 <_panic>
            return -E_NO_MEM;
f01015f4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01015f9:	eb a5                	jmp    f01015a0 <page_insert+0xfa>

f01015fb <mem_init>:
mem_init(void) {
f01015fb:	55                   	push   %ebp
f01015fc:	89 e5                	mov    %esp,%ebp
f01015fe:	57                   	push   %edi
f01015ff:	56                   	push   %esi
f0101600:	53                   	push   %ebx
f0101601:	83 ec 3c             	sub    $0x3c,%esp
f0101604:	e8 35 ec ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0101609:	81 c3 17 aa 08 00    	add    $0x8aa17,%ebx
    basemem = nvram_read(NVRAM_BASELO);
f010160f:	b8 15 00 00 00       	mov    $0x15,%eax
f0101614:	e8 fb f4 ff ff       	call   f0100b14 <nvram_read>
f0101619:	89 c7                	mov    %eax,%edi
    extmem = nvram_read(NVRAM_EXTLO);
f010161b:	b8 17 00 00 00       	mov    $0x17,%eax
f0101620:	e8 ef f4 ff ff       	call   f0100b14 <nvram_read>
f0101625:	89 c6                	mov    %eax,%esi
    ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101627:	b8 34 00 00 00       	mov    $0x34,%eax
f010162c:	e8 e3 f4 ff ff       	call   f0100b14 <nvram_read>
f0101631:	c1 e0 06             	shl    $0x6,%eax
    if (ext16mem)
f0101634:	85 c0                	test   %eax,%eax
f0101636:	0f 85 5c 02 00 00    	jne    f0101898 <mem_init+0x29d>
        totalmem = 1 * 1024 + extmem;
f010163c:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101642:	85 f6                	test   %esi,%esi
f0101644:	0f 44 c7             	cmove  %edi,%eax
f0101647:	89 83 1c 23 00 00    	mov    %eax,0x231c(%ebx)
    npages = totalmem / (PGSIZE / 1024);
f010164d:	8b 83 1c 23 00 00    	mov    0x231c(%ebx),%eax
f0101653:	c7 c6 08 f0 18 f0    	mov    $0xf018f008,%esi
f0101659:	89 c2                	mov    %eax,%edx
f010165b:	c1 ea 02             	shr    $0x2,%edx
f010165e:	89 16                	mov    %edx,(%esi)
    npages_basemem = basemem / (PGSIZE / 1024);
f0101660:	89 fa                	mov    %edi,%edx
f0101662:	c1 ea 02             	shr    $0x2,%edx
f0101665:	89 93 24 23 00 00    	mov    %edx,0x2324(%ebx)
    cprintf("Physical memory: 0x%xK available\tbase = 0x%xK\textended = 0x%xK\n",
f010166b:	89 c2                	mov    %eax,%edx
f010166d:	29 fa                	sub    %edi,%edx
f010166f:	52                   	push   %edx
f0101670:	57                   	push   %edi
f0101671:	50                   	push   %eax
f0101672:	8d 83 5c 9a f7 ff    	lea    -0x865a4(%ebx),%eax
f0101678:	50                   	push   %eax
f0101679:	e8 ff 24 00 00       	call   f0103b7d <cprintf>
    cprintf("sizeof(uint16_t):0x%x\n", sizeof(unsigned short));
f010167e:	83 c4 08             	add    $0x8,%esp
f0101681:	6a 02                	push   $0x2
f0101683:	8d 83 c0 a6 f7 ff    	lea    -0x85940(%ebx),%eax
f0101689:	50                   	push   %eax
f010168a:	e8 ee 24 00 00       	call   f0103b7d <cprintf>
    cprintf("npages:0x%x\tsizeof(Struct PageInfo):0x%x\n", npages, sizeof(struct PageInfo));
f010168f:	83 c4 0c             	add    $0xc,%esp
f0101692:	6a 08                	push   $0x8
f0101694:	ff 36                	pushl  (%esi)
f0101696:	8d 83 9c 9a f7 ff    	lea    -0x86564(%ebx),%eax
f010169c:	50                   	push   %eax
f010169d:	e8 db 24 00 00       	call   f0103b7d <cprintf>
    kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01016a2:	b8 00 10 00 00       	mov    $0x1000,%eax
f01016a7:	e8 9e f4 ff ff       	call   f0100b4a <boot_alloc>
f01016ac:	c7 c2 0c f0 18 f0    	mov    $0xf018f00c,%edx
f01016b2:	89 02                	mov    %eax,(%edx)
	if ((uint32_t)kva < KERNBASE)
f01016b4:	83 c4 10             	add    $0x10,%esp
f01016b7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01016bc:	0f 86 e6 01 00 00    	jbe    f01018a8 <mem_init+0x2ad>
	return (physaddr_t)kva - KERNBASE;
f01016c2:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("kern_pgdir", (uintptr_t) kern_pgdir, PDX(kern_pgdir), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f01016c8:	83 ec 0c             	sub    $0xc,%esp
f01016cb:	89 d1                	mov    %edx,%ecx
f01016cd:	c1 e9 0c             	shr    $0xc,%ecx
f01016d0:	51                   	push   %ecx
f01016d1:	52                   	push   %edx
f01016d2:	89 c2                	mov    %eax,%edx
f01016d4:	c1 ea 16             	shr    $0x16,%edx
f01016d7:	52                   	push   %edx
f01016d8:	50                   	push   %eax
f01016d9:	8d 83 d7 a6 f7 ff    	lea    -0x85929(%ebx),%eax
f01016df:	50                   	push   %eax
f01016e0:	e8 ac 24 00 00       	call   f0103b91 <memCprintf>
    memset(kern_pgdir, 0, PGSIZE);
f01016e5:	83 c4 1c             	add    $0x1c,%esp
f01016e8:	68 00 10 00 00       	push   $0x1000
f01016ed:	6a 00                	push   $0x0
f01016ef:	c7 c6 0c f0 18 f0    	mov    $0xf018f00c,%esi
f01016f5:	ff 36                	pushl  (%esi)
f01016f7:	e8 9c 35 00 00       	call   f0104c98 <memset>
    kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01016fc:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f01016fe:	83 c4 10             	add    $0x10,%esp
f0101701:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101706:	0f 86 b5 01 00 00    	jbe    f01018c1 <mem_init+0x2c6>
	return (physaddr_t)kva - KERNBASE;
f010170c:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101712:	89 d1                	mov    %edx,%ecx
f0101714:	83 c9 05             	or     $0x5,%ecx
f0101717:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f010171d:	83 ec 0c             	sub    $0xc,%esp
f0101720:	89 d0                	mov    %edx,%eax
f0101722:	c1 e8 0c             	shr    $0xc,%eax
f0101725:	50                   	push   %eax
f0101726:	52                   	push   %edx
f0101727:	68 bd 03 00 00       	push   $0x3bd
f010172c:	68 00 00 40 ef       	push   $0xef400000
f0101731:	8d 83 e2 a6 f7 ff    	lea    -0x8591e(%ebx),%eax
f0101737:	50                   	push   %eax
f0101738:	e8 54 24 00 00       	call   f0103b91 <memCprintf>
    pages = boot_alloc(ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f010173d:	83 c4 20             	add    $0x20,%esp
f0101740:	c7 c6 08 f0 18 f0    	mov    $0xf018f008,%esi
f0101746:	8b 06                	mov    (%esi),%eax
f0101748:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010174f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101754:	e8 f1 f3 ff ff       	call   f0100b4a <boot_alloc>
f0101759:	c7 c7 10 f0 18 f0    	mov    $0xf018f010,%edi
f010175f:	89 07                	mov    %eax,(%edi)
    memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f0101761:	83 ec 04             	sub    $0x4,%esp
f0101764:	8b 16                	mov    (%esi),%edx
f0101766:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f010176d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101773:	52                   	push   %edx
f0101774:	6a 00                	push   $0x0
f0101776:	50                   	push   %eax
f0101777:	e8 1c 35 00 00       	call   f0104c98 <memset>
    cprintf("pages占用空间:%dK\n", ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) / 1024);
f010177c:	83 c4 08             	add    $0x8,%esp
f010177f:	8b 06                	mov    (%esi),%eax
f0101781:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0101788:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010178d:	c1 e8 0a             	shr    $0xa,%eax
f0101790:	50                   	push   %eax
f0101791:	8d 83 e7 a6 f7 ff    	lea    -0x85919(%ebx),%eax
f0101797:	50                   	push   %eax
f0101798:	e8 e0 23 00 00       	call   f0103b7d <cprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f010179d:	8b 07                	mov    (%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f010179f:	83 c4 10             	add    $0x10,%esp
f01017a2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017a7:	0f 86 2d 01 00 00    	jbe    f01018da <mem_init+0x2df>
	return (physaddr_t)kva - KERNBASE;
f01017ad:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017b3:	83 ec 0c             	sub    $0xc,%esp
f01017b6:	89 d1                	mov    %edx,%ecx
f01017b8:	c1 e9 0c             	shr    $0xc,%ecx
f01017bb:	51                   	push   %ecx
f01017bc:	52                   	push   %edx
f01017bd:	89 c2                	mov    %eax,%edx
f01017bf:	c1 ea 16             	shr    $0x16,%edx
f01017c2:	52                   	push   %edx
f01017c3:	50                   	push   %eax
f01017c4:	8d 83 fc a5 f7 ff    	lea    -0x85a04(%ebx),%eax
f01017ca:	50                   	push   %eax
f01017cb:	e8 c1 23 00 00       	call   f0103b91 <memCprintf>
    cprintf("sizeof(struct Env):0x%x\n", sizeof (struct Env));
f01017d0:	83 c4 18             	add    $0x18,%esp
f01017d3:	6a 60                	push   $0x60
f01017d5:	8d 83 fe a6 f7 ff    	lea    -0x85902(%ebx),%eax
f01017db:	50                   	push   %eax
f01017dc:	e8 9c 23 00 00       	call   f0103b7d <cprintf>
    envs = boot_alloc(ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f01017e1:	b8 00 80 01 00       	mov    $0x18000,%eax
f01017e6:	e8 5f f3 ff ff       	call   f0100b4a <boot_alloc>
f01017eb:	c7 c6 4c e3 18 f0    	mov    $0xf018e34c,%esi
f01017f1:	89 06                	mov    %eax,(%esi)
    memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f01017f3:	83 c4 0c             	add    $0xc,%esp
f01017f6:	68 00 80 01 00       	push   $0x18000
f01017fb:	6a 00                	push   $0x0
f01017fd:	50                   	push   %eax
f01017fe:	e8 95 34 00 00       	call   f0104c98 <memset>
    cprintf("envs take up memory:%dK\n", ROUNDUP(NENV * sizeof(struct Env), PGSIZE) / 1024);
f0101803:	83 c4 08             	add    $0x8,%esp
f0101806:	6a 60                	push   $0x60
f0101808:	8d 83 17 a7 f7 ff    	lea    -0x858e9(%ebx),%eax
f010180e:	50                   	push   %eax
f010180f:	e8 69 23 00 00       	call   f0103b7d <cprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f0101814:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0101816:	83 c4 10             	add    $0x10,%esp
f0101819:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010181e:	0f 86 cf 00 00 00    	jbe    f01018f3 <mem_init+0x2f8>
	return (physaddr_t)kva - KERNBASE;
f0101824:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010182a:	83 ec 0c             	sub    $0xc,%esp
f010182d:	89 d1                	mov    %edx,%ecx
f010182f:	c1 e9 0c             	shr    $0xc,%ecx
f0101832:	51                   	push   %ecx
f0101833:	52                   	push   %edx
f0101834:	89 c2                	mov    %eax,%edx
f0101836:	c1 ea 16             	shr    $0x16,%edx
f0101839:	52                   	push   %edx
f010183a:	50                   	push   %eax
f010183b:	8d 83 30 a7 f7 ff    	lea    -0x858d0(%ebx),%eax
f0101841:	50                   	push   %eax
f0101842:	e8 4a 23 00 00       	call   f0103b91 <memCprintf>
    page_init();
f0101847:	83 c4 20             	add    $0x20,%esp
f010184a:	e8 e2 f7 ff ff       	call   f0101031 <page_init>
    cprintf("\n************* Now Check that the pages on the page_free_list are reasonable ************\n");
f010184f:	83 ec 0c             	sub    $0xc,%esp
f0101852:	8d 83 c8 9a f7 ff    	lea    -0x86538(%ebx),%eax
f0101858:	50                   	push   %eax
f0101859:	e8 1f 23 00 00       	call   f0103b7d <cprintf>
    check_page_free_list(1);
f010185e:	b8 01 00 00 00       	mov    $0x1,%eax
f0101863:	e8 dc f3 ff ff       	call   f0100c44 <check_page_free_list>
    cprintf("\n************* Now check the real physical page allocator (page_alloc(), page_free(), and page_init())************\n");
f0101868:	8d 83 24 9b f7 ff    	lea    -0x864dc(%ebx),%eax
f010186e:	89 04 24             	mov    %eax,(%esp)
f0101871:	e8 07 23 00 00       	call   f0103b7d <cprintf>
    if (!pages)
f0101876:	83 c4 10             	add    $0x10,%esp
f0101879:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f010187f:	83 38 00             	cmpl   $0x0,(%eax)
f0101882:	0f 84 84 00 00 00    	je     f010190c <mem_init+0x311>
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101888:	8b 83 20 23 00 00    	mov    0x2320(%ebx),%eax
f010188e:	be 00 00 00 00       	mov    $0x0,%esi
f0101893:	e9 94 00 00 00       	jmp    f010192c <mem_init+0x331>
        totalmem = 16 * 1024 + ext16mem;
f0101898:	05 00 40 00 00       	add    $0x4000,%eax
f010189d:	89 83 1c 23 00 00    	mov    %eax,0x231c(%ebx)
f01018a3:	e9 a5 fd ff ff       	jmp    f010164d <mem_init+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01018a8:	50                   	push   %eax
f01018a9:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01018af:	50                   	push   %eax
f01018b0:	68 96 00 00 00       	push   $0x96
f01018b5:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01018bb:	50                   	push   %eax
f01018bc:	e8 c7 e8 ff ff       	call   f0100188 <_panic>
f01018c1:	50                   	push   %eax
f01018c2:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01018c8:	50                   	push   %eax
f01018c9:	68 a0 00 00 00       	push   $0xa0
f01018ce:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01018d4:	50                   	push   %eax
f01018d5:	e8 ae e8 ff ff       	call   f0100188 <_panic>
f01018da:	50                   	push   %eax
f01018db:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01018e1:	50                   	push   %eax
f01018e2:	68 ad 00 00 00       	push   $0xad
f01018e7:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01018ed:	50                   	push   %eax
f01018ee:	e8 95 e8 ff ff       	call   f0100188 <_panic>
f01018f3:	50                   	push   %eax
f01018f4:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01018fa:	50                   	push   %eax
f01018fb:	68 b4 00 00 00       	push   $0xb4
f0101900:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101906:	50                   	push   %eax
f0101907:	e8 7c e8 ff ff       	call   f0100188 <_panic>
        panic("'pages' is a null pointer!");
f010190c:	83 ec 04             	sub    $0x4,%esp
f010190f:	8d 83 35 a7 f7 ff    	lea    -0x858cb(%ebx),%eax
f0101915:	50                   	push   %eax
f0101916:	68 bf 02 00 00       	push   $0x2bf
f010191b:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101921:	50                   	push   %eax
f0101922:	e8 61 e8 ff ff       	call   f0100188 <_panic>
        ++nfree;
f0101927:	83 c6 01             	add    $0x1,%esi
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010192a:	8b 00                	mov    (%eax),%eax
f010192c:	85 c0                	test   %eax,%eax
f010192e:	75 f7                	jne    f0101927 <mem_init+0x32c>
    assert((pp0 = page_alloc(0)));
f0101930:	83 ec 0c             	sub    $0xc,%esp
f0101933:	6a 00                	push   $0x0
f0101935:	e8 92 f8 ff ff       	call   f01011cc <page_alloc>
f010193a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010193d:	83 c4 10             	add    $0x10,%esp
f0101940:	85 c0                	test   %eax,%eax
f0101942:	0f 84 2e 02 00 00    	je     f0101b76 <mem_init+0x57b>
    assert((pp1 = page_alloc(0)));
f0101948:	83 ec 0c             	sub    $0xc,%esp
f010194b:	6a 00                	push   $0x0
f010194d:	e8 7a f8 ff ff       	call   f01011cc <page_alloc>
f0101952:	89 c7                	mov    %eax,%edi
f0101954:	83 c4 10             	add    $0x10,%esp
f0101957:	85 c0                	test   %eax,%eax
f0101959:	0f 84 36 02 00 00    	je     f0101b95 <mem_init+0x59a>
    assert((pp2 = page_alloc(0)));
f010195f:	83 ec 0c             	sub    $0xc,%esp
f0101962:	6a 00                	push   $0x0
f0101964:	e8 63 f8 ff ff       	call   f01011cc <page_alloc>
f0101969:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010196c:	83 c4 10             	add    $0x10,%esp
f010196f:	85 c0                	test   %eax,%eax
f0101971:	0f 84 3d 02 00 00    	je     f0101bb4 <mem_init+0x5b9>
    assert(pp1 && pp1 != pp0);
f0101977:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f010197a:	0f 84 53 02 00 00    	je     f0101bd3 <mem_init+0x5d8>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101980:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101983:	39 c7                	cmp    %eax,%edi
f0101985:	0f 84 67 02 00 00    	je     f0101bf2 <mem_init+0x5f7>
f010198b:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f010198e:	0f 84 5e 02 00 00    	je     f0101bf2 <mem_init+0x5f7>
	return (pp - pages) << PGSHIFT;
f0101994:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f010199a:	8b 08                	mov    (%eax),%ecx
    assert(page2pa(pp0) < npages * PGSIZE);
f010199c:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f01019a2:	8b 10                	mov    (%eax),%edx
f01019a4:	c1 e2 0c             	shl    $0xc,%edx
f01019a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019aa:	29 c8                	sub    %ecx,%eax
f01019ac:	c1 f8 03             	sar    $0x3,%eax
f01019af:	c1 e0 0c             	shl    $0xc,%eax
f01019b2:	39 d0                	cmp    %edx,%eax
f01019b4:	0f 83 57 02 00 00    	jae    f0101c11 <mem_init+0x616>
f01019ba:	89 f8                	mov    %edi,%eax
f01019bc:	29 c8                	sub    %ecx,%eax
f01019be:	c1 f8 03             	sar    $0x3,%eax
f01019c1:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp1) < npages * PGSIZE);
f01019c4:	39 c2                	cmp    %eax,%edx
f01019c6:	0f 86 64 02 00 00    	jbe    f0101c30 <mem_init+0x635>
f01019cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01019cf:	29 c8                	sub    %ecx,%eax
f01019d1:	c1 f8 03             	sar    $0x3,%eax
f01019d4:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp2) < npages * PGSIZE);
f01019d7:	39 c2                	cmp    %eax,%edx
f01019d9:	0f 86 70 02 00 00    	jbe    f0101c4f <mem_init+0x654>
    fl = page_free_list;
f01019df:	8b 83 20 23 00 00    	mov    0x2320(%ebx),%eax
f01019e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    page_free_list = 0;
f01019e8:	c7 83 20 23 00 00 00 	movl   $0x0,0x2320(%ebx)
f01019ef:	00 00 00 
    assert(!page_alloc(0));
f01019f2:	83 ec 0c             	sub    $0xc,%esp
f01019f5:	6a 00                	push   $0x0
f01019f7:	e8 d0 f7 ff ff       	call   f01011cc <page_alloc>
f01019fc:	83 c4 10             	add    $0x10,%esp
f01019ff:	85 c0                	test   %eax,%eax
f0101a01:	0f 85 67 02 00 00    	jne    f0101c6e <mem_init+0x673>
    page_free(pp0);
f0101a07:	83 ec 0c             	sub    $0xc,%esp
f0101a0a:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a0d:	e8 48 f8 ff ff       	call   f010125a <page_free>
    page_free(pp1);
f0101a12:	89 3c 24             	mov    %edi,(%esp)
f0101a15:	e8 40 f8 ff ff       	call   f010125a <page_free>
    page_free(pp2);
f0101a1a:	83 c4 04             	add    $0x4,%esp
f0101a1d:	ff 75 d0             	pushl  -0x30(%ebp)
f0101a20:	e8 35 f8 ff ff       	call   f010125a <page_free>
    assert((pp0 = page_alloc(0)));
f0101a25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a2c:	e8 9b f7 ff ff       	call   f01011cc <page_alloc>
f0101a31:	89 c7                	mov    %eax,%edi
f0101a33:	83 c4 10             	add    $0x10,%esp
f0101a36:	85 c0                	test   %eax,%eax
f0101a38:	0f 84 4f 02 00 00    	je     f0101c8d <mem_init+0x692>
    assert((pp1 = page_alloc(0)));
f0101a3e:	83 ec 0c             	sub    $0xc,%esp
f0101a41:	6a 00                	push   $0x0
f0101a43:	e8 84 f7 ff ff       	call   f01011cc <page_alloc>
f0101a48:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101a4b:	83 c4 10             	add    $0x10,%esp
f0101a4e:	85 c0                	test   %eax,%eax
f0101a50:	0f 84 56 02 00 00    	je     f0101cac <mem_init+0x6b1>
    assert((pp2 = page_alloc(0)));
f0101a56:	83 ec 0c             	sub    $0xc,%esp
f0101a59:	6a 00                	push   $0x0
f0101a5b:	e8 6c f7 ff ff       	call   f01011cc <page_alloc>
f0101a60:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101a63:	83 c4 10             	add    $0x10,%esp
f0101a66:	85 c0                	test   %eax,%eax
f0101a68:	0f 84 5d 02 00 00    	je     f0101ccb <mem_init+0x6d0>
    assert(pp1 && pp1 != pp0);
f0101a6e:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
f0101a71:	0f 84 73 02 00 00    	je     f0101cea <mem_init+0x6ef>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a77:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101a7a:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101a7d:	0f 84 86 02 00 00    	je     f0101d09 <mem_init+0x70e>
f0101a83:	39 c7                	cmp    %eax,%edi
f0101a85:	0f 84 7e 02 00 00    	je     f0101d09 <mem_init+0x70e>
    assert(!page_alloc(0));
f0101a8b:	83 ec 0c             	sub    $0xc,%esp
f0101a8e:	6a 00                	push   $0x0
f0101a90:	e8 37 f7 ff ff       	call   f01011cc <page_alloc>
f0101a95:	83 c4 10             	add    $0x10,%esp
f0101a98:	85 c0                	test   %eax,%eax
f0101a9a:	0f 85 88 02 00 00    	jne    f0101d28 <mem_init+0x72d>
f0101aa0:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0101aa6:	89 f9                	mov    %edi,%ecx
f0101aa8:	2b 08                	sub    (%eax),%ecx
f0101aaa:	89 c8                	mov    %ecx,%eax
f0101aac:	c1 f8 03             	sar    $0x3,%eax
f0101aaf:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101ab2:	89 c1                	mov    %eax,%ecx
f0101ab4:	c1 e9 0c             	shr    $0xc,%ecx
f0101ab7:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f0101abd:	3b 0a                	cmp    (%edx),%ecx
f0101abf:	0f 83 82 02 00 00    	jae    f0101d47 <mem_init+0x74c>
    memset(page2kva(pp0), 1, PGSIZE);
f0101ac5:	83 ec 04             	sub    $0x4,%esp
f0101ac8:	68 00 10 00 00       	push   $0x1000
f0101acd:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101acf:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101ad4:	50                   	push   %eax
f0101ad5:	e8 be 31 00 00       	call   f0104c98 <memset>
    page_free(pp0);
f0101ada:	89 3c 24             	mov    %edi,(%esp)
f0101add:	e8 78 f7 ff ff       	call   f010125a <page_free>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101ae2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101ae9:	e8 de f6 ff ff       	call   f01011cc <page_alloc>
f0101aee:	83 c4 10             	add    $0x10,%esp
f0101af1:	85 c0                	test   %eax,%eax
f0101af3:	0f 84 64 02 00 00    	je     f0101d5d <mem_init+0x762>
    assert(pp && pp0 == pp);
f0101af9:	39 c7                	cmp    %eax,%edi
f0101afb:	0f 85 7b 02 00 00    	jne    f0101d7c <mem_init+0x781>
	return (pp - pages) << PGSHIFT;
f0101b01:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0101b07:	89 fa                	mov    %edi,%edx
f0101b09:	2b 10                	sub    (%eax),%edx
f0101b0b:	c1 fa 03             	sar    $0x3,%edx
f0101b0e:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101b11:	89 d1                	mov    %edx,%ecx
f0101b13:	c1 e9 0c             	shr    $0xc,%ecx
f0101b16:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f0101b1c:	3b 08                	cmp    (%eax),%ecx
f0101b1e:	0f 83 77 02 00 00    	jae    f0101d9b <mem_init+0x7a0>
	return (void *)(pa + KERNBASE);
f0101b24:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101b2a:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
        assert(c[i] == 0);
f0101b30:	80 38 00             	cmpb   $0x0,(%eax)
f0101b33:	0f 85 78 02 00 00    	jne    f0101db1 <mem_init+0x7b6>
f0101b39:	83 c0 01             	add    $0x1,%eax
    for (i = 0; i < PGSIZE; i++)
f0101b3c:	39 d0                	cmp    %edx,%eax
f0101b3e:	75 f0                	jne    f0101b30 <mem_init+0x535>
    page_free_list = fl;
f0101b40:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101b43:	89 83 20 23 00 00    	mov    %eax,0x2320(%ebx)
    page_free(pp0);
f0101b49:	83 ec 0c             	sub    $0xc,%esp
f0101b4c:	57                   	push   %edi
f0101b4d:	e8 08 f7 ff ff       	call   f010125a <page_free>
    page_free(pp1);
f0101b52:	83 c4 04             	add    $0x4,%esp
f0101b55:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b58:	e8 fd f6 ff ff       	call   f010125a <page_free>
    page_free(pp2);
f0101b5d:	83 c4 04             	add    $0x4,%esp
f0101b60:	ff 75 d0             	pushl  -0x30(%ebp)
f0101b63:	e8 f2 f6 ff ff       	call   f010125a <page_free>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101b68:	8b 83 20 23 00 00    	mov    0x2320(%ebx),%eax
f0101b6e:	83 c4 10             	add    $0x10,%esp
f0101b71:	e9 5f 02 00 00       	jmp    f0101dd5 <mem_init+0x7da>
    assert((pp0 = page_alloc(0)));
f0101b76:	8d 83 50 a7 f7 ff    	lea    -0x858b0(%ebx),%eax
f0101b7c:	50                   	push   %eax
f0101b7d:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101b83:	50                   	push   %eax
f0101b84:	68 c7 02 00 00       	push   $0x2c7
f0101b89:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101b8f:	50                   	push   %eax
f0101b90:	e8 f3 e5 ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0101b95:	8d 83 66 a7 f7 ff    	lea    -0x8589a(%ebx),%eax
f0101b9b:	50                   	push   %eax
f0101b9c:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101ba2:	50                   	push   %eax
f0101ba3:	68 c8 02 00 00       	push   $0x2c8
f0101ba8:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101bae:	50                   	push   %eax
f0101baf:	e8 d4 e5 ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0101bb4:	8d 83 7c a7 f7 ff    	lea    -0x85884(%ebx),%eax
f0101bba:	50                   	push   %eax
f0101bbb:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101bc1:	50                   	push   %eax
f0101bc2:	68 c9 02 00 00       	push   $0x2c9
f0101bc7:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101bcd:	50                   	push   %eax
f0101bce:	e8 b5 e5 ff ff       	call   f0100188 <_panic>
    assert(pp1 && pp1 != pp0);
f0101bd3:	8d 83 92 a7 f7 ff    	lea    -0x8586e(%ebx),%eax
f0101bd9:	50                   	push   %eax
f0101bda:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101be0:	50                   	push   %eax
f0101be1:	68 cc 02 00 00       	push   $0x2cc
f0101be6:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101bec:	50                   	push   %eax
f0101bed:	e8 96 e5 ff ff       	call   f0100188 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101bf2:	8d 83 98 9b f7 ff    	lea    -0x86468(%ebx),%eax
f0101bf8:	50                   	push   %eax
f0101bf9:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101bff:	50                   	push   %eax
f0101c00:	68 cd 02 00 00       	push   $0x2cd
f0101c05:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101c0b:	50                   	push   %eax
f0101c0c:	e8 77 e5 ff ff       	call   f0100188 <_panic>
    assert(page2pa(pp0) < npages * PGSIZE);
f0101c11:	8d 83 b8 9b f7 ff    	lea    -0x86448(%ebx),%eax
f0101c17:	50                   	push   %eax
f0101c18:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101c1e:	50                   	push   %eax
f0101c1f:	68 ce 02 00 00       	push   $0x2ce
f0101c24:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101c2a:	50                   	push   %eax
f0101c2b:	e8 58 e5 ff ff       	call   f0100188 <_panic>
    assert(page2pa(pp1) < npages * PGSIZE);
f0101c30:	8d 83 d8 9b f7 ff    	lea    -0x86428(%ebx),%eax
f0101c36:	50                   	push   %eax
f0101c37:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101c3d:	50                   	push   %eax
f0101c3e:	68 cf 02 00 00       	push   $0x2cf
f0101c43:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101c49:	50                   	push   %eax
f0101c4a:	e8 39 e5 ff ff       	call   f0100188 <_panic>
    assert(page2pa(pp2) < npages * PGSIZE);
f0101c4f:	8d 83 f8 9b f7 ff    	lea    -0x86408(%ebx),%eax
f0101c55:	50                   	push   %eax
f0101c56:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101c5c:	50                   	push   %eax
f0101c5d:	68 d0 02 00 00       	push   $0x2d0
f0101c62:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101c68:	50                   	push   %eax
f0101c69:	e8 1a e5 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0101c6e:	8d 83 a4 a7 f7 ff    	lea    -0x8585c(%ebx),%eax
f0101c74:	50                   	push   %eax
f0101c75:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101c7b:	50                   	push   %eax
f0101c7c:	68 d7 02 00 00       	push   $0x2d7
f0101c81:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101c87:	50                   	push   %eax
f0101c88:	e8 fb e4 ff ff       	call   f0100188 <_panic>
    assert((pp0 = page_alloc(0)));
f0101c8d:	8d 83 50 a7 f7 ff    	lea    -0x858b0(%ebx),%eax
f0101c93:	50                   	push   %eax
f0101c94:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101c9a:	50                   	push   %eax
f0101c9b:	68 de 02 00 00       	push   $0x2de
f0101ca0:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101ca6:	50                   	push   %eax
f0101ca7:	e8 dc e4 ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0101cac:	8d 83 66 a7 f7 ff    	lea    -0x8589a(%ebx),%eax
f0101cb2:	50                   	push   %eax
f0101cb3:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101cb9:	50                   	push   %eax
f0101cba:	68 df 02 00 00       	push   $0x2df
f0101cbf:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101cc5:	50                   	push   %eax
f0101cc6:	e8 bd e4 ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0101ccb:	8d 83 7c a7 f7 ff    	lea    -0x85884(%ebx),%eax
f0101cd1:	50                   	push   %eax
f0101cd2:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101cd8:	50                   	push   %eax
f0101cd9:	68 e0 02 00 00       	push   $0x2e0
f0101cde:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101ce4:	50                   	push   %eax
f0101ce5:	e8 9e e4 ff ff       	call   f0100188 <_panic>
    assert(pp1 && pp1 != pp0);
f0101cea:	8d 83 92 a7 f7 ff    	lea    -0x8586e(%ebx),%eax
f0101cf0:	50                   	push   %eax
f0101cf1:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101cf7:	50                   	push   %eax
f0101cf8:	68 e2 02 00 00       	push   $0x2e2
f0101cfd:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101d03:	50                   	push   %eax
f0101d04:	e8 7f e4 ff ff       	call   f0100188 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d09:	8d 83 98 9b f7 ff    	lea    -0x86468(%ebx),%eax
f0101d0f:	50                   	push   %eax
f0101d10:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101d16:	50                   	push   %eax
f0101d17:	68 e3 02 00 00       	push   $0x2e3
f0101d1c:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101d22:	50                   	push   %eax
f0101d23:	e8 60 e4 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0101d28:	8d 83 a4 a7 f7 ff    	lea    -0x8585c(%ebx),%eax
f0101d2e:	50                   	push   %eax
f0101d2f:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101d35:	50                   	push   %eax
f0101d36:	68 e4 02 00 00       	push   $0x2e4
f0101d3b:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101d41:	50                   	push   %eax
f0101d42:	e8 41 e4 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101d47:	50                   	push   %eax
f0101d48:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0101d4e:	50                   	push   %eax
f0101d4f:	6a 56                	push   $0x56
f0101d51:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0101d57:	50                   	push   %eax
f0101d58:	e8 2b e4 ff ff       	call   f0100188 <_panic>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101d5d:	8d 83 b3 a7 f7 ff    	lea    -0x8584d(%ebx),%eax
f0101d63:	50                   	push   %eax
f0101d64:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101d6a:	50                   	push   %eax
f0101d6b:	68 e9 02 00 00       	push   $0x2e9
f0101d70:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101d76:	50                   	push   %eax
f0101d77:	e8 0c e4 ff ff       	call   f0100188 <_panic>
    assert(pp && pp0 == pp);
f0101d7c:	8d 83 d1 a7 f7 ff    	lea    -0x8582f(%ebx),%eax
f0101d82:	50                   	push   %eax
f0101d83:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101d89:	50                   	push   %eax
f0101d8a:	68 ea 02 00 00       	push   $0x2ea
f0101d8f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101d95:	50                   	push   %eax
f0101d96:	e8 ed e3 ff ff       	call   f0100188 <_panic>
f0101d9b:	52                   	push   %edx
f0101d9c:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0101da2:	50                   	push   %eax
f0101da3:	6a 56                	push   $0x56
f0101da5:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0101dab:	50                   	push   %eax
f0101dac:	e8 d7 e3 ff ff       	call   f0100188 <_panic>
        assert(c[i] == 0);
f0101db1:	8d 83 e1 a7 f7 ff    	lea    -0x8581f(%ebx),%eax
f0101db7:	50                   	push   %eax
f0101db8:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0101dbe:	50                   	push   %eax
f0101dbf:	68 ed 02 00 00       	push   $0x2ed
f0101dc4:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0101dca:	50                   	push   %eax
f0101dcb:	e8 b8 e3 ff ff       	call   f0100188 <_panic>
        --nfree;
f0101dd0:	83 ee 01             	sub    $0x1,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101dd3:	8b 00                	mov    (%eax),%eax
f0101dd5:	85 c0                	test   %eax,%eax
f0101dd7:	75 f7                	jne    f0101dd0 <mem_init+0x7d5>
    assert(nfree == 0);
f0101dd9:	85 f6                	test   %esi,%esi
f0101ddb:	0f 85 f5 09 00 00    	jne    f01027d6 <mem_init+0x11db>
    cprintf("check_page_alloc() succeeded!\n");
f0101de1:	83 ec 0c             	sub    $0xc,%esp
f0101de4:	8d 83 18 9c f7 ff    	lea    -0x863e8(%ebx),%eax
f0101dea:	50                   	push   %eax
f0101deb:	e8 8d 1d 00 00       	call   f0103b7d <cprintf>
    cprintf("\n************* Now check page_insert, page_remove, &c **************\n");
f0101df0:	8d 83 38 9c f7 ff    	lea    -0x863c8(%ebx),%eax
f0101df6:	89 04 24             	mov    %eax,(%esp)
f0101df9:	e8 7f 1d 00 00       	call   f0103b7d <cprintf>
    int i;
    extern pde_t entry_pgdir[];

    // should be able to allocate three pages
    pp0 = pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0101dfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e05:	e8 c2 f3 ff ff       	call   f01011cc <page_alloc>
f0101e0a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e0d:	83 c4 10             	add    $0x10,%esp
f0101e10:	85 c0                	test   %eax,%eax
f0101e12:	0f 84 dd 09 00 00    	je     f01027f5 <mem_init+0x11fa>
    assert((pp1 = page_alloc(0)));
f0101e18:	83 ec 0c             	sub    $0xc,%esp
f0101e1b:	6a 00                	push   $0x0
f0101e1d:	e8 aa f3 ff ff       	call   f01011cc <page_alloc>
f0101e22:	89 c7                	mov    %eax,%edi
f0101e24:	83 c4 10             	add    $0x10,%esp
f0101e27:	85 c0                	test   %eax,%eax
f0101e29:	0f 84 e5 09 00 00    	je     f0102814 <mem_init+0x1219>
    assert((pp2 = page_alloc(0)));
f0101e2f:	83 ec 0c             	sub    $0xc,%esp
f0101e32:	6a 00                	push   $0x0
f0101e34:	e8 93 f3 ff ff       	call   f01011cc <page_alloc>
f0101e39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e3c:	83 c4 10             	add    $0x10,%esp
f0101e3f:	85 c0                	test   %eax,%eax
f0101e41:	0f 84 ec 09 00 00    	je     f0102833 <mem_init+0x1238>

    assert(pp0);
    assert(pp1 && pp1 != pp0);
f0101e47:	39 7d d0             	cmp    %edi,-0x30(%ebp)
f0101e4a:	0f 84 02 0a 00 00    	je     f0102852 <mem_init+0x1257>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101e50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e53:	39 c7                	cmp    %eax,%edi
f0101e55:	0f 84 16 0a 00 00    	je     f0102871 <mem_init+0x1276>
f0101e5b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101e5e:	0f 84 0d 0a 00 00    	je     f0102871 <mem_init+0x1276>

    // temporarily steal the rest of the free pages
    fl = page_free_list;
f0101e64:	8b 83 20 23 00 00    	mov    0x2320(%ebx),%eax
f0101e6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    page_free_list = 0;
f0101e6d:	c7 83 20 23 00 00 00 	movl   $0x0,0x2320(%ebx)
f0101e74:	00 00 00 

    // should be no free memory
    assert(!page_alloc(0));
f0101e77:	83 ec 0c             	sub    $0xc,%esp
f0101e7a:	6a 00                	push   $0x0
f0101e7c:	e8 4b f3 ff ff       	call   f01011cc <page_alloc>
f0101e81:	83 c4 10             	add    $0x10,%esp
f0101e84:	85 c0                	test   %eax,%eax
f0101e86:	0f 85 04 0a 00 00    	jne    f0102890 <mem_init+0x1295>

    // there is no page allocated at address 0
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101e8c:	83 ec 04             	sub    $0x4,%esp
f0101e8f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101e92:	50                   	push   %eax
f0101e93:	6a 00                	push   $0x0
f0101e95:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101e9b:	ff 30                	pushl  (%eax)
f0101e9d:	e8 43 f5 ff ff       	call   f01013e5 <page_lookup>
f0101ea2:	83 c4 10             	add    $0x10,%esp
f0101ea5:	85 c0                	test   %eax,%eax
f0101ea7:	0f 85 02 0a 00 00    	jne    f01028af <mem_init+0x12b4>

    // there is no free memory, so we can't allocate a page table
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101ead:	6a 02                	push   $0x2
f0101eaf:	6a 00                	push   $0x0
f0101eb1:	57                   	push   %edi
f0101eb2:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101eb8:	ff 30                	pushl  (%eax)
f0101eba:	e8 e7 f5 ff ff       	call   f01014a6 <page_insert>
f0101ebf:	83 c4 10             	add    $0x10,%esp
f0101ec2:	85 c0                	test   %eax,%eax
f0101ec4:	0f 89 04 0a 00 00    	jns    f01028ce <mem_init+0x12d3>

    // free pp0 and try again: pp0 should be used for page table
    page_free(pp0);
f0101eca:	83 ec 0c             	sub    $0xc,%esp
f0101ecd:	ff 75 d0             	pushl  -0x30(%ebp)
f0101ed0:	e8 85 f3 ff ff       	call   f010125a <page_free>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101ed5:	6a 02                	push   $0x2
f0101ed7:	6a 00                	push   $0x0
f0101ed9:	57                   	push   %edi
f0101eda:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101ee0:	ff 30                	pushl  (%eax)
f0101ee2:	e8 bf f5 ff ff       	call   f01014a6 <page_insert>
f0101ee7:	83 c4 20             	add    $0x20,%esp
f0101eea:	85 c0                	test   %eax,%eax
f0101eec:	0f 85 fb 09 00 00    	jne    f01028ed <mem_init+0x12f2>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101ef2:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101ef8:	8b 08                	mov    (%eax),%ecx
f0101efa:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	return (pp - pages) << PGSHIFT;
f0101efd:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0101f03:	8b 30                	mov    (%eax),%esi
f0101f05:	8b 01                	mov    (%ecx),%eax
f0101f07:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0101f0a:	89 c2                	mov    %eax,%edx
f0101f0c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f12:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f15:	29 f0                	sub    %esi,%eax
f0101f17:	c1 f8 03             	sar    $0x3,%eax
f0101f1a:	c1 e0 0c             	shl    $0xc,%eax
f0101f1d:	39 c2                	cmp    %eax,%edx
f0101f1f:	0f 85 e7 09 00 00    	jne    f010290c <mem_init+0x1311>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101f25:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101f2d:	e8 95 ec ff ff       	call   f0100bc7 <check_va2pa>
f0101f32:	89 fa                	mov    %edi,%edx
f0101f34:	29 f2                	sub    %esi,%edx
f0101f36:	c1 fa 03             	sar    $0x3,%edx
f0101f39:	c1 e2 0c             	shl    $0xc,%edx
f0101f3c:	39 d0                	cmp    %edx,%eax
f0101f3e:	0f 85 e7 09 00 00    	jne    f010292b <mem_init+0x1330>
    assert(pp1->pp_ref == 1);
f0101f44:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101f49:	0f 85 fb 09 00 00    	jne    f010294a <mem_init+0x134f>
    assert(pp0->pp_ref == 1);
f0101f4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f52:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f57:	0f 85 0c 0a 00 00    	jne    f0102969 <mem_init+0x136e>

    // should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101f5d:	6a 02                	push   $0x2
f0101f5f:	68 00 10 00 00       	push   $0x1000
f0101f64:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101f67:	ff 75 cc             	pushl  -0x34(%ebp)
f0101f6a:	e8 37 f5 ff ff       	call   f01014a6 <page_insert>
f0101f6f:	83 c4 10             	add    $0x10,%esp
f0101f72:	85 c0                	test   %eax,%eax
f0101f74:	0f 85 0e 0a 00 00    	jne    f0102988 <mem_init+0x138d>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f7a:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f7f:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101f85:	8b 00                	mov    (%eax),%eax
f0101f87:	e8 3b ec ff ff       	call   f0100bc7 <check_va2pa>
f0101f8c:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f0101f92:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101f95:	2b 0a                	sub    (%edx),%ecx
f0101f97:	89 ca                	mov    %ecx,%edx
f0101f99:	c1 fa 03             	sar    $0x3,%edx
f0101f9c:	c1 e2 0c             	shl    $0xc,%edx
f0101f9f:	39 d0                	cmp    %edx,%eax
f0101fa1:	0f 85 00 0a 00 00    	jne    f01029a7 <mem_init+0x13ac>
    assert(pp2->pp_ref == 1);
f0101fa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101faa:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101faf:	0f 85 11 0a 00 00    	jne    f01029c6 <mem_init+0x13cb>

    // should be no free memory
    assert(!page_alloc(0));
f0101fb5:	83 ec 0c             	sub    $0xc,%esp
f0101fb8:	6a 00                	push   $0x0
f0101fba:	e8 0d f2 ff ff       	call   f01011cc <page_alloc>
f0101fbf:	83 c4 10             	add    $0x10,%esp
f0101fc2:	85 c0                	test   %eax,%eax
f0101fc4:	0f 85 1b 0a 00 00    	jne    f01029e5 <mem_init+0x13ea>

    // should be able to map pp2 at PGSIZE because it's already there
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101fca:	6a 02                	push   $0x2
f0101fcc:	68 00 10 00 00       	push   $0x1000
f0101fd1:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fd4:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101fda:	ff 30                	pushl  (%eax)
f0101fdc:	e8 c5 f4 ff ff       	call   f01014a6 <page_insert>
f0101fe1:	83 c4 10             	add    $0x10,%esp
f0101fe4:	85 c0                	test   %eax,%eax
f0101fe6:	0f 85 18 0a 00 00    	jne    f0102a04 <mem_init+0x1409>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101fec:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ff1:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0101ff7:	8b 00                	mov    (%eax),%eax
f0101ff9:	e8 c9 eb ff ff       	call   f0100bc7 <check_va2pa>
f0101ffe:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f0102004:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102007:	2b 0a                	sub    (%edx),%ecx
f0102009:	89 ca                	mov    %ecx,%edx
f010200b:	c1 fa 03             	sar    $0x3,%edx
f010200e:	c1 e2 0c             	shl    $0xc,%edx
f0102011:	39 d0                	cmp    %edx,%eax
f0102013:	0f 85 0a 0a 00 00    	jne    f0102a23 <mem_init+0x1428>
    assert(pp2->pp_ref == 1);
f0102019:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010201c:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102021:	0f 85 1b 0a 00 00    	jne    f0102a42 <mem_init+0x1447>

    // pp2 should NOT be on the free list
    // could happen in ref counts are handled sloppily in page_insert
    assert(!page_alloc(0));
f0102027:	83 ec 0c             	sub    $0xc,%esp
f010202a:	6a 00                	push   $0x0
f010202c:	e8 9b f1 ff ff       	call   f01011cc <page_alloc>
f0102031:	83 c4 10             	add    $0x10,%esp
f0102034:	85 c0                	test   %eax,%eax
f0102036:	0f 85 25 0a 00 00    	jne    f0102a61 <mem_init+0x1466>

    // check that pgdir_walk returns a pointer to the pte
    ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f010203c:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102042:	8b 10                	mov    (%eax),%edx
f0102044:	8b 02                	mov    (%edx),%eax
f0102046:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010204b:	89 c1                	mov    %eax,%ecx
f010204d:	c1 e9 0c             	shr    $0xc,%ecx
f0102050:	89 ce                	mov    %ecx,%esi
f0102052:	c7 c1 08 f0 18 f0    	mov    $0xf018f008,%ecx
f0102058:	3b 31                	cmp    (%ecx),%esi
f010205a:	0f 83 20 0a 00 00    	jae    f0102a80 <mem_init+0x1485>
	return (void *)(pa + KERNBASE);
f0102060:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102065:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102068:	83 ec 04             	sub    $0x4,%esp
f010206b:	6a 00                	push   $0x0
f010206d:	68 00 10 00 00       	push   $0x1000
f0102072:	52                   	push   %edx
f0102073:	e8 7d f2 ff ff       	call   f01012f5 <pgdir_walk>
f0102078:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010207b:	8d 51 04             	lea    0x4(%ecx),%edx
f010207e:	83 c4 10             	add    $0x10,%esp
f0102081:	39 d0                	cmp    %edx,%eax
f0102083:	0f 85 10 0a 00 00    	jne    f0102a99 <mem_init+0x149e>

    // should be able to change permissions too.
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0102089:	6a 06                	push   $0x6
f010208b:	68 00 10 00 00       	push   $0x1000
f0102090:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102093:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102099:	ff 30                	pushl  (%eax)
f010209b:	e8 06 f4 ff ff       	call   f01014a6 <page_insert>
f01020a0:	83 c4 10             	add    $0x10,%esp
f01020a3:	85 c0                	test   %eax,%eax
f01020a5:	0f 85 0d 0a 00 00    	jne    f0102ab8 <mem_init+0x14bd>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01020ab:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01020b1:	8b 00                	mov    (%eax),%eax
f01020b3:	89 c6                	mov    %eax,%esi
f01020b5:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020ba:	e8 08 eb ff ff       	call   f0100bc7 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f01020bf:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f01020c5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01020c8:	2b 0a                	sub    (%edx),%ecx
f01020ca:	89 ca                	mov    %ecx,%edx
f01020cc:	c1 fa 03             	sar    $0x3,%edx
f01020cf:	c1 e2 0c             	shl    $0xc,%edx
f01020d2:	39 d0                	cmp    %edx,%eax
f01020d4:	0f 85 fd 09 00 00    	jne    f0102ad7 <mem_init+0x14dc>
    assert(pp2->pp_ref == 1);
f01020da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020dd:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01020e2:	0f 85 0e 0a 00 00    	jne    f0102af6 <mem_init+0x14fb>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f01020e8:	83 ec 04             	sub    $0x4,%esp
f01020eb:	6a 00                	push   $0x0
f01020ed:	68 00 10 00 00       	push   $0x1000
f01020f2:	56                   	push   %esi
f01020f3:	e8 fd f1 ff ff       	call   f01012f5 <pgdir_walk>
f01020f8:	83 c4 10             	add    $0x10,%esp
f01020fb:	f6 00 04             	testb  $0x4,(%eax)
f01020fe:	0f 84 11 0a 00 00    	je     f0102b15 <mem_init+0x151a>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f0102104:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f010210a:	8b 00                	mov    (%eax),%eax
f010210c:	f6 00 04             	testb  $0x4,(%eax)
f010210f:	0f 84 1f 0a 00 00    	je     f0102b34 <mem_init+0x1539>

    // should be able to remap with fewer permissions
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102115:	6a 02                	push   $0x2
f0102117:	68 00 10 00 00       	push   $0x1000
f010211c:	ff 75 d4             	pushl  -0x2c(%ebp)
f010211f:	50                   	push   %eax
f0102120:	e8 81 f3 ff ff       	call   f01014a6 <page_insert>
f0102125:	83 c4 10             	add    $0x10,%esp
f0102128:	85 c0                	test   %eax,%eax
f010212a:	0f 85 23 0a 00 00    	jne    f0102b53 <mem_init+0x1558>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102130:	83 ec 04             	sub    $0x4,%esp
f0102133:	6a 00                	push   $0x0
f0102135:	68 00 10 00 00       	push   $0x1000
f010213a:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102140:	ff 30                	pushl  (%eax)
f0102142:	e8 ae f1 ff ff       	call   f01012f5 <pgdir_walk>
f0102147:	83 c4 10             	add    $0x10,%esp
f010214a:	f6 00 02             	testb  $0x2,(%eax)
f010214d:	0f 84 1f 0a 00 00    	je     f0102b72 <mem_init+0x1577>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102153:	83 ec 04             	sub    $0x4,%esp
f0102156:	6a 00                	push   $0x0
f0102158:	68 00 10 00 00       	push   $0x1000
f010215d:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102163:	ff 30                	pushl  (%eax)
f0102165:	e8 8b f1 ff ff       	call   f01012f5 <pgdir_walk>
f010216a:	83 c4 10             	add    $0x10,%esp
f010216d:	f6 00 04             	testb  $0x4,(%eax)
f0102170:	0f 85 1b 0a 00 00    	jne    f0102b91 <mem_init+0x1596>

    // should not be able to map at PTSIZE because need free page for page table
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102176:	6a 02                	push   $0x2
f0102178:	68 00 00 40 00       	push   $0x400000
f010217d:	ff 75 d0             	pushl  -0x30(%ebp)
f0102180:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102186:	ff 30                	pushl  (%eax)
f0102188:	e8 19 f3 ff ff       	call   f01014a6 <page_insert>
f010218d:	83 c4 10             	add    $0x10,%esp
f0102190:	85 c0                	test   %eax,%eax
f0102192:	0f 89 18 0a 00 00    	jns    f0102bb0 <mem_init+0x15b5>

    // insert pp1 at PGSIZE (replacing pp2)
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0102198:	6a 02                	push   $0x2
f010219a:	68 00 10 00 00       	push   $0x1000
f010219f:	57                   	push   %edi
f01021a0:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01021a6:	ff 30                	pushl  (%eax)
f01021a8:	e8 f9 f2 ff ff       	call   f01014a6 <page_insert>
f01021ad:	83 c4 10             	add    $0x10,%esp
f01021b0:	85 c0                	test   %eax,%eax
f01021b2:	0f 85 17 0a 00 00    	jne    f0102bcf <mem_init+0x15d4>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f01021b8:	83 ec 04             	sub    $0x4,%esp
f01021bb:	6a 00                	push   $0x0
f01021bd:	68 00 10 00 00       	push   $0x1000
f01021c2:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01021c8:	ff 30                	pushl  (%eax)
f01021ca:	e8 26 f1 ff ff       	call   f01012f5 <pgdir_walk>
f01021cf:	83 c4 10             	add    $0x10,%esp
f01021d2:	f6 00 04             	testb  $0x4,(%eax)
f01021d5:	0f 85 13 0a 00 00    	jne    f0102bee <mem_init+0x15f3>

    // should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01021db:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01021e1:	8b 00                	mov    (%eax),%eax
f01021e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01021e6:	ba 00 00 00 00       	mov    $0x0,%edx
f01021eb:	e8 d7 e9 ff ff       	call   f0100bc7 <check_va2pa>
f01021f0:	89 c6                	mov    %eax,%esi
f01021f2:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f01021f8:	89 f9                	mov    %edi,%ecx
f01021fa:	2b 08                	sub    (%eax),%ecx
f01021fc:	89 c8                	mov    %ecx,%eax
f01021fe:	c1 f8 03             	sar    $0x3,%eax
f0102201:	c1 e0 0c             	shl    $0xc,%eax
f0102204:	39 c6                	cmp    %eax,%esi
f0102206:	0f 85 01 0a 00 00    	jne    f0102c0d <mem_init+0x1612>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010220c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102211:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102214:	e8 ae e9 ff ff       	call   f0100bc7 <check_va2pa>
f0102219:	39 c6                	cmp    %eax,%esi
f010221b:	0f 85 0b 0a 00 00    	jne    f0102c2c <mem_init+0x1631>
    // ... and ref counts should reflect this
    assert(pp1->pp_ref == 2);
f0102221:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0102226:	0f 85 1f 0a 00 00    	jne    f0102c4b <mem_init+0x1650>
    assert(pp2->pp_ref == 0);
f010222c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010222f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102234:	0f 85 30 0a 00 00    	jne    f0102c6a <mem_init+0x166f>

    // pp2 should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp2);
f010223a:	83 ec 0c             	sub    $0xc,%esp
f010223d:	6a 00                	push   $0x0
f010223f:	e8 88 ef ff ff       	call   f01011cc <page_alloc>
f0102244:	83 c4 10             	add    $0x10,%esp
f0102247:	85 c0                	test   %eax,%eax
f0102249:	0f 84 3a 0a 00 00    	je     f0102c89 <mem_init+0x168e>
f010224f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0102252:	0f 85 31 0a 00 00    	jne    f0102c89 <mem_init+0x168e>

    // unmapping pp1 at 0 should keep pp1 at PGSIZE
    page_remove(kern_pgdir, 0x0);
f0102258:	83 ec 08             	sub    $0x8,%esp
f010225b:	6a 00                	push   $0x0
f010225d:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102263:	89 c6                	mov    %eax,%esi
f0102265:	ff 30                	pushl  (%eax)
f0102267:	e8 e9 f1 ff ff       	call   f0101455 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010226c:	8b 06                	mov    (%esi),%eax
f010226e:	89 c6                	mov    %eax,%esi
f0102270:	ba 00 00 00 00       	mov    $0x0,%edx
f0102275:	e8 4d e9 ff ff       	call   f0100bc7 <check_va2pa>
f010227a:	83 c4 10             	add    $0x10,%esp
f010227d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102280:	0f 85 22 0a 00 00    	jne    f0102ca8 <mem_init+0x16ad>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102286:	ba 00 10 00 00       	mov    $0x1000,%edx
f010228b:	89 f0                	mov    %esi,%eax
f010228d:	e8 35 e9 ff ff       	call   f0100bc7 <check_va2pa>
f0102292:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f0102298:	89 f9                	mov    %edi,%ecx
f010229a:	2b 0a                	sub    (%edx),%ecx
f010229c:	89 ca                	mov    %ecx,%edx
f010229e:	c1 fa 03             	sar    $0x3,%edx
f01022a1:	c1 e2 0c             	shl    $0xc,%edx
f01022a4:	39 d0                	cmp    %edx,%eax
f01022a6:	0f 85 1b 0a 00 00    	jne    f0102cc7 <mem_init+0x16cc>
    assert(pp1->pp_ref == 1);
f01022ac:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01022b1:	0f 85 2f 0a 00 00    	jne    f0102ce6 <mem_init+0x16eb>
    assert(pp2->pp_ref == 0);
f01022b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01022ba:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01022bf:	0f 85 40 0a 00 00    	jne    f0102d05 <mem_init+0x170a>

    // test re-inserting pp1 at PGSIZE
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f01022c5:	6a 00                	push   $0x0
f01022c7:	68 00 10 00 00       	push   $0x1000
f01022cc:	57                   	push   %edi
f01022cd:	56                   	push   %esi
f01022ce:	e8 d3 f1 ff ff       	call   f01014a6 <page_insert>
f01022d3:	83 c4 10             	add    $0x10,%esp
f01022d6:	85 c0                	test   %eax,%eax
f01022d8:	0f 85 46 0a 00 00    	jne    f0102d24 <mem_init+0x1729>
    assert(pp1->pp_ref);
f01022de:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01022e3:	0f 84 5a 0a 00 00    	je     f0102d43 <mem_init+0x1748>
    assert(pp1->pp_link == NULL);
f01022e9:	83 3f 00             	cmpl   $0x0,(%edi)
f01022ec:	0f 85 70 0a 00 00    	jne    f0102d62 <mem_init+0x1767>

    // unmapping pp1 at PGSIZE should free it
    page_remove(kern_pgdir, (void *) PGSIZE);
f01022f2:	83 ec 08             	sub    $0x8,%esp
f01022f5:	68 00 10 00 00       	push   $0x1000
f01022fa:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102300:	89 c6                	mov    %eax,%esi
f0102302:	ff 30                	pushl  (%eax)
f0102304:	e8 4c f1 ff ff       	call   f0101455 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102309:	8b 06                	mov    (%esi),%eax
f010230b:	89 c6                	mov    %eax,%esi
f010230d:	ba 00 00 00 00       	mov    $0x0,%edx
f0102312:	e8 b0 e8 ff ff       	call   f0100bc7 <check_va2pa>
f0102317:	83 c4 10             	add    $0x10,%esp
f010231a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010231d:	0f 85 5e 0a 00 00    	jne    f0102d81 <mem_init+0x1786>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102323:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102328:	89 f0                	mov    %esi,%eax
f010232a:	e8 98 e8 ff ff       	call   f0100bc7 <check_va2pa>
f010232f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102332:	0f 85 68 0a 00 00    	jne    f0102da0 <mem_init+0x17a5>
    assert(pp1->pp_ref == 0);
f0102338:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010233d:	0f 85 7c 0a 00 00    	jne    f0102dbf <mem_init+0x17c4>
    assert(pp2->pp_ref == 0);
f0102343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102346:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010234b:	0f 85 8d 0a 00 00    	jne    f0102dde <mem_init+0x17e3>

    // so it should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp1);
f0102351:	83 ec 0c             	sub    $0xc,%esp
f0102354:	6a 00                	push   $0x0
f0102356:	e8 71 ee ff ff       	call   f01011cc <page_alloc>
f010235b:	83 c4 10             	add    $0x10,%esp
f010235e:	39 c7                	cmp    %eax,%edi
f0102360:	0f 85 97 0a 00 00    	jne    f0102dfd <mem_init+0x1802>
f0102366:	85 c0                	test   %eax,%eax
f0102368:	0f 84 8f 0a 00 00    	je     f0102dfd <mem_init+0x1802>

    // should be no free memory
    assert(!page_alloc(0));
f010236e:	83 ec 0c             	sub    $0xc,%esp
f0102371:	6a 00                	push   $0x0
f0102373:	e8 54 ee ff ff       	call   f01011cc <page_alloc>
f0102378:	83 c4 10             	add    $0x10,%esp
f010237b:	85 c0                	test   %eax,%eax
f010237d:	0f 85 99 0a 00 00    	jne    f0102e1c <mem_init+0x1821>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102383:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102389:	8b 08                	mov    (%eax),%ecx
f010238b:	8b 11                	mov    (%ecx),%edx
f010238d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102393:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0102399:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010239c:	2b 30                	sub    (%eax),%esi
f010239e:	89 f0                	mov    %esi,%eax
f01023a0:	c1 f8 03             	sar    $0x3,%eax
f01023a3:	c1 e0 0c             	shl    $0xc,%eax
f01023a6:	39 c2                	cmp    %eax,%edx
f01023a8:	0f 85 8d 0a 00 00    	jne    f0102e3b <mem_init+0x1840>
    kern_pgdir[0] = 0;
f01023ae:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f01023b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01023b7:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01023bc:	0f 85 98 0a 00 00    	jne    f0102e5a <mem_init+0x185f>
    pp0->pp_ref = 0;
f01023c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01023c5:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // check pointer arithmetic in pgdir_walk
    page_free(pp0);
f01023cb:	83 ec 0c             	sub    $0xc,%esp
f01023ce:	50                   	push   %eax
f01023cf:	e8 86 ee ff ff       	call   f010125a <page_free>
    va = (void *) (PGSIZE * NPDENTRIES + PGSIZE);
    ptep = pgdir_walk(kern_pgdir, va, 1);
f01023d4:	83 c4 0c             	add    $0xc,%esp
f01023d7:	6a 01                	push   $0x1
f01023d9:	68 00 10 40 00       	push   $0x401000
f01023de:	c7 c6 0c f0 18 f0    	mov    $0xf018f00c,%esi
f01023e4:	ff 36                	pushl  (%esi)
f01023e6:	e8 0a ef ff ff       	call   f01012f5 <pgdir_walk>
f01023eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01023ee:	8b 16                	mov    (%esi),%edx
f01023f0:	8b 52 04             	mov    0x4(%edx),%edx
f01023f3:	89 d1                	mov    %edx,%ecx
f01023f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01023fb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	if (PGNUM(pa) >= npages)
f01023fe:	c1 e9 0c             	shr    $0xc,%ecx
f0102401:	89 ce                	mov    %ecx,%esi
f0102403:	83 c4 10             	add    $0x10,%esp
f0102406:	c7 c1 08 f0 18 f0    	mov    $0xf018f008,%ecx
f010240c:	3b 31                	cmp    (%ecx),%esi
f010240e:	0f 83 65 0a 00 00    	jae    f0102e79 <mem_init+0x187e>
	return (void *)(pa + KERNBASE);
f0102414:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0102417:	8d 8e 00 00 00 f0    	lea    -0x10000000(%esi),%ecx

    cprintf("PTE_ADDR(kern_pgdir[PDX(va)]):0x%x\tkern_pgdir[PDX(va)]:0x%x\tptep:0x%x\tptep1:0x%x\tPTX(va):0x%x\n",
f010241d:	83 ec 08             	sub    $0x8,%esp
f0102420:	6a 01                	push   $0x1
f0102422:	51                   	push   %ecx
f0102423:	50                   	push   %eax
f0102424:	52                   	push   %edx
f0102425:	56                   	push   %esi
f0102426:	8d 83 a4 a0 f7 ff    	lea    -0x85f5c(%ebx),%eax
f010242c:	50                   	push   %eax
f010242d:	e8 4b 17 00 00       	call   f0103b7d <cprintf>
            PTE_ADDR(kern_pgdir[PDX(va)]), kern_pgdir[PDX(va)], ptep, ptep1,
            PTX(va));
    assert(ptep == ptep1 + PTX(va));
f0102432:	8d 86 04 00 00 f0    	lea    -0xffffffc(%esi),%eax
f0102438:	83 c4 20             	add    $0x20,%esp
f010243b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f010243e:	0f 85 50 0a 00 00    	jne    f0102e94 <mem_init+0x1899>
    kern_pgdir[PDX(va)] = 0;
f0102444:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f010244a:	8b 00                	mov    (%eax),%eax
f010244c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    pp0->pp_ref = 0;
f0102453:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102456:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
	return (pp - pages) << PGSHIFT;
f010245c:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0102462:	2b 08                	sub    (%eax),%ecx
f0102464:	89 c8                	mov    %ecx,%eax
f0102466:	c1 f8 03             	sar    $0x3,%eax
f0102469:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010246c:	89 c1                	mov    %eax,%ecx
f010246e:	c1 e9 0c             	shr    $0xc,%ecx
f0102471:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f0102477:	3b 0a                	cmp    (%edx),%ecx
f0102479:	0f 83 34 0a 00 00    	jae    f0102eb3 <mem_init+0x18b8>

    // check that new page tables get cleared
    memset(page2kva(pp0), 0xFF, PGSIZE);
f010247f:	83 ec 04             	sub    $0x4,%esp
f0102482:	68 00 10 00 00       	push   $0x1000
f0102487:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f010248c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102491:	50                   	push   %eax
f0102492:	e8 01 28 00 00       	call   f0104c98 <memset>
    page_free(pp0);
f0102497:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010249a:	89 34 24             	mov    %esi,(%esp)
f010249d:	e8 b8 ed ff ff       	call   f010125a <page_free>
    pgdir_walk(kern_pgdir, 0x0, 1);
f01024a2:	83 c4 0c             	add    $0xc,%esp
f01024a5:	6a 01                	push   $0x1
f01024a7:	6a 00                	push   $0x0
f01024a9:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01024af:	ff 30                	pushl  (%eax)
f01024b1:	e8 3f ee ff ff       	call   f01012f5 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01024b6:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f01024bc:	2b 30                	sub    (%eax),%esi
f01024be:	89 f2                	mov    %esi,%edx
f01024c0:	c1 fa 03             	sar    $0x3,%edx
f01024c3:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01024c6:	89 d1                	mov    %edx,%ecx
f01024c8:	c1 e9 0c             	shr    $0xc,%ecx
f01024cb:	83 c4 10             	add    $0x10,%esp
f01024ce:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f01024d4:	3b 08                	cmp    (%eax),%ecx
f01024d6:	0f 83 ed 09 00 00    	jae    f0102ec9 <mem_init+0x18ce>
	return (void *)(pa + KERNBASE);
f01024dc:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
    ptep = (pte_t *) page2kva(pp0);
f01024e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01024e5:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f01024eb:	8b 75 d4             	mov    -0x2c(%ebp),%esi
    for (i = 0; i < NPTENTRIES; i++)
        assert((ptep[i] & PTE_P) == 0);
f01024ee:	f6 00 01             	testb  $0x1,(%eax)
f01024f1:	0f 85 e8 09 00 00    	jne    f0102edf <mem_init+0x18e4>
f01024f7:	83 c0 04             	add    $0x4,%eax
    for (i = 0; i < NPTENTRIES; i++)
f01024fa:	39 d0                	cmp    %edx,%eax
f01024fc:	75 f0                	jne    f01024ee <mem_init+0xef3>
f01024fe:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    kern_pgdir[0] = 0;
f0102501:	c7 c6 0c f0 18 f0    	mov    $0xf018f00c,%esi
f0102507:	8b 06                	mov    (%esi),%eax
f0102509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    pp0->pp_ref = 0;
f010250f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102512:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // give free list back
    page_free_list = fl;
f0102518:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f010251b:	89 8b 20 23 00 00    	mov    %ecx,0x2320(%ebx)

    // free the pages we took
    page_free(pp0);
f0102521:	83 ec 0c             	sub    $0xc,%esp
f0102524:	50                   	push   %eax
f0102525:	e8 30 ed ff ff       	call   f010125a <page_free>
    page_free(pp1);
f010252a:	89 3c 24             	mov    %edi,(%esp)
f010252d:	e8 28 ed ff ff       	call   f010125a <page_free>
    page_free(pp2);
f0102532:	83 c4 04             	add    $0x4,%esp
f0102535:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102538:	e8 1d ed ff ff       	call   f010125a <page_free>

    cprintf("check_page() succeeded!\n");
f010253d:	8d 83 c2 a8 f7 ff    	lea    -0x8573e(%ebx),%eax
f0102543:	89 04 24             	mov    %eax,(%esp)
f0102546:	e8 32 16 00 00       	call   f0103b7d <cprintf>
    cprintf("\n************* Now we set up virtual memory **************\n");
f010254b:	8d 83 04 a1 f7 ff    	lea    -0x85efc(%ebx),%eax
f0102551:	89 04 24             	mov    %eax,(%esp)
f0102554:	e8 24 16 00 00       	call   f0103b7d <cprintf>
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f0102559:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f010255b:	83 c4 10             	add    $0x10,%esp
f010255e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102563:	0f 86 95 09 00 00    	jbe    f0102efe <mem_init+0x1903>
	return (physaddr_t)kva - KERNBASE;
f0102569:	05 00 00 00 10       	add    $0x10000000,%eax
f010256e:	83 ec 0c             	sub    $0xc,%esp
f0102571:	89 c2                	mov    %eax,%edx
f0102573:	c1 ea 0c             	shr    $0xc,%edx
f0102576:	52                   	push   %edx
f0102577:	50                   	push   %eax
f0102578:	68 bd 03 00 00       	push   $0x3bd
f010257d:	68 00 00 40 ef       	push   $0xef400000
f0102582:	8d 83 e2 a6 f7 ff    	lea    -0x8591e(%ebx),%eax
f0102588:	50                   	push   %eax
f0102589:	e8 03 16 00 00       	call   f0103b91 <memCprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f010258e:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0102594:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102596:	83 c4 20             	add    $0x20,%esp
f0102599:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010259e:	0f 86 73 09 00 00    	jbe    f0102f17 <mem_init+0x191c>
	return (physaddr_t)kva - KERNBASE;
f01025a4:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01025aa:	83 ec 0c             	sub    $0xc,%esp
f01025ad:	89 d1                	mov    %edx,%ecx
f01025af:	c1 e9 0c             	shr    $0xc,%ecx
f01025b2:	51                   	push   %ecx
f01025b3:	52                   	push   %edx
f01025b4:	89 c2                	mov    %eax,%edx
f01025b6:	c1 ea 16             	shr    $0x16,%edx
f01025b9:	52                   	push   %edx
f01025ba:	50                   	push   %eax
f01025bb:	8d 83 fc a5 f7 ff    	lea    -0x85a04(%ebx),%eax
f01025c1:	50                   	push   %eax
f01025c2:	e8 ca 15 00 00       	call   f0103b91 <memCprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f01025c7:	c7 c0 4c e3 18 f0    	mov    $0xf018e34c,%eax
f01025cd:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01025cf:	83 c4 20             	add    $0x20,%esp
f01025d2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01025d7:	0f 86 53 09 00 00    	jbe    f0102f30 <mem_init+0x1935>
	return (physaddr_t)kva - KERNBASE;
f01025dd:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01025e3:	83 ec 0c             	sub    $0xc,%esp
f01025e6:	89 d1                	mov    %edx,%ecx
f01025e8:	c1 e9 0c             	shr    $0xc,%ecx
f01025eb:	51                   	push   %ecx
f01025ec:	52                   	push   %edx
f01025ed:	89 c2                	mov    %eax,%edx
f01025ef:	c1 ea 16             	shr    $0x16,%edx
f01025f2:	52                   	push   %edx
f01025f3:	50                   	push   %eax
f01025f4:	8d 83 30 a7 f7 ff    	lea    -0x858d0(%ebx),%eax
f01025fa:	50                   	push   %eax
f01025fb:	e8 91 15 00 00       	call   f0103b91 <memCprintf>
    cprintf("\n************* Now we map 'pages' read-only by the user at linear address UPAGES **************\n");
f0102600:	83 c4 14             	add    $0x14,%esp
f0102603:	8d 83 40 a1 f7 ff    	lea    -0x85ec0(%ebx),%eax
f0102609:	50                   	push   %eax
f010260a:	e8 6e 15 00 00       	call   f0103b7d <cprintf>
    cprintf("page2pa(pages):0x%x\n", page2pa(pages));
f010260f:	83 c4 08             	add    $0x8,%esp
f0102612:	6a 00                	push   $0x0
f0102614:	8d 83 db a8 f7 ff    	lea    -0x85725(%ebx),%eax
f010261a:	50                   	push   %eax
f010261b:	e8 5d 15 00 00       	call   f0103b7d <cprintf>
    boot_map_region(kern_pgdir, UPAGES, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE), PADDR(pages), PTE_U | PTE_P);
f0102620:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0102626:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102628:	83 c4 10             	add    $0x10,%esp
f010262b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102630:	0f 86 13 09 00 00    	jbe    f0102f49 <mem_init+0x194e>
f0102636:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f010263c:	8b 12                	mov    (%edx),%edx
f010263e:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0102645:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010264b:	83 ec 08             	sub    $0x8,%esp
f010264e:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102650:	05 00 00 00 10       	add    $0x10000000,%eax
f0102655:	50                   	push   %eax
f0102656:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010265b:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0102661:	8b 00                	mov    (%eax),%eax
f0102663:	e8 37 ed ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now we map 'envs' read-only by the user at linear address UENVS **************\n");
f0102668:	8d 83 a4 a1 f7 ff    	lea    -0x85e5c(%ebx),%eax
f010266e:	89 04 24             	mov    %eax,(%esp)
f0102671:	e8 07 15 00 00       	call   f0103b7d <cprintf>
    boot_map_region(kern_pgdir, UENVS, ROUNDUP(NENV * sizeof(struct Env), PGSIZE), PADDR(envs), PTE_U | PTE_P);
f0102676:	c7 c0 4c e3 18 f0    	mov    $0xf018e34c,%eax
f010267c:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010267e:	83 c4 10             	add    $0x10,%esp
f0102681:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102686:	0f 86 d6 08 00 00    	jbe    f0102f62 <mem_init+0x1967>
f010268c:	83 ec 08             	sub    $0x8,%esp
f010268f:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102691:	05 00 00 00 10       	add    $0x10000000,%eax
f0102696:	50                   	push   %eax
f0102697:	b9 00 80 01 00       	mov    $0x18000,%ecx
f010269c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01026a1:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01026a7:	8b 00                	mov    (%eax),%eax
f01026a9:	e8 f1 ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now use the physical memory that 'bootstack' refers to as the kernel stack **************\n");
f01026ae:	8d 83 04 a2 f7 ff    	lea    -0x85dfc(%ebx),%eax
f01026b4:	89 04 24             	mov    %eax,(%esp)
f01026b7:	e8 c1 14 00 00       	call   f0103b7d <cprintf>
	if ((uint32_t)kva < KERNBASE)
f01026bc:	c7 c0 00 20 11 f0    	mov    $0xf0112000,%eax
f01026c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01026c5:	83 c4 10             	add    $0x10,%esp
f01026c8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01026cd:	0f 86 a8 08 00 00    	jbe    f0102f7b <mem_init+0x1980>
    boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_P);
f01026d3:	c7 c6 0c f0 18 f0    	mov    $0xf018f00c,%esi
f01026d9:	83 ec 08             	sub    $0x8,%esp
f01026dc:	6a 01                	push   $0x1
	return (physaddr_t)kva - KERNBASE;
f01026de:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01026e1:	05 00 00 00 10       	add    $0x10000000,%eax
f01026e6:	50                   	push   %eax
f01026e7:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01026ec:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01026f1:	8b 06                	mov    (%esi),%eax
f01026f3:	e8 a7 ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now map all of physical memory at KERNBASE. **************\n");
f01026f8:	8d 83 70 a2 f7 ff    	lea    -0x85d90(%ebx),%eax
f01026fe:	89 04 24             	mov    %eax,(%esp)
f0102701:	e8 77 14 00 00       	call   f0103b7d <cprintf>
    boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE + 1, 0, PTE_W | PTE_P);//这权限有必要？？
f0102706:	83 c4 08             	add    $0x8,%esp
f0102709:	6a 03                	push   $0x3
f010270b:	6a 00                	push   $0x0
f010270d:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102712:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102717:	8b 06                	mov    (%esi),%eax
f0102719:	e8 81 ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now check that the initial page directory has been set up correctly **************\n");
f010271e:	8d 83 bc a2 f7 ff    	lea    -0x85d44(%ebx),%eax
f0102724:	89 04 24             	mov    %eax,(%esp)
f0102727:	e8 51 14 00 00       	call   f0103b7d <cprintf>
    pgdir = kern_pgdir;
f010272c:	8b 36                	mov    (%esi),%esi
    n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f010272e:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f0102734:	8b 00                	mov    (%eax),%eax
f0102736:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010273d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102742:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cprintf("check_va2pa(pgdir, UPAGES + 0):0x%x\tPADDR(pages) + 0:0x%x\n", check_va2pa(pgdir, UPAGES + 0),
f0102745:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f010274b:	8b 38                	mov    (%eax),%edi
	if ((uint32_t)kva < KERNBASE)
f010274d:	83 c4 10             	add    $0x10,%esp
f0102750:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102756:	0f 86 38 08 00 00    	jbe    f0102f94 <mem_init+0x1999>
f010275c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102761:	89 f0                	mov    %esi,%eax
f0102763:	e8 5f e4 ff ff       	call   f0100bc7 <check_va2pa>
f0102768:	83 ec 04             	sub    $0x4,%esp
	return (physaddr_t)kva - KERNBASE;
f010276b:	8d 97 00 00 00 10    	lea    0x10000000(%edi),%edx
f0102771:	52                   	push   %edx
f0102772:	50                   	push   %eax
f0102773:	8d 83 20 a3 f7 ff    	lea    -0x85ce0(%ebx),%eax
f0102779:	50                   	push   %eax
f010277a:	e8 fe 13 00 00       	call   f0103b7d <cprintf>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010277f:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0102785:	8b 00                	mov    (%eax),%eax
f0102787:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if ((uint32_t)kva < KERNBASE)
f010278a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	return (physaddr_t)kva - KERNBASE;
f010278d:	05 00 00 00 10       	add    $0x10000000,%eax
f0102792:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < n; i += PGSIZE)
f0102795:	bf 00 00 00 00       	mov    $0x0,%edi
f010279a:	89 75 d0             	mov    %esi,-0x30(%ebp)
f010279d:	89 c6                	mov    %eax,%esi
f010279f:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f01027a2:	0f 86 3f 08 00 00    	jbe    f0102fe7 <mem_init+0x19ec>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01027a8:	8d 97 00 00 00 ef    	lea    -0x11000000(%edi),%edx
f01027ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01027b1:	e8 11 e4 ff ff       	call   f0100bc7 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01027b6:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f01027bd:	0f 86 ea 07 00 00    	jbe    f0102fad <mem_init+0x19b2>
f01027c3:	8d 14 37             	lea    (%edi,%esi,1),%edx
f01027c6:	39 c2                	cmp    %eax,%edx
f01027c8:	0f 85 fa 07 00 00    	jne    f0102fc8 <mem_init+0x19cd>
    for (i = 0; i < n; i += PGSIZE)
f01027ce:	81 c7 00 10 00 00    	add    $0x1000,%edi
f01027d4:	eb c9                	jmp    f010279f <mem_init+0x11a4>
    assert(nfree == 0);
f01027d6:	8d 83 eb a7 f7 ff    	lea    -0x85815(%ebx),%eax
f01027dc:	50                   	push   %eax
f01027dd:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01027e3:	50                   	push   %eax
f01027e4:	68 fa 02 00 00       	push   $0x2fa
f01027e9:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01027ef:	50                   	push   %eax
f01027f0:	e8 93 d9 ff ff       	call   f0100188 <_panic>
    assert((pp0 = page_alloc(0)));
f01027f5:	8d 83 50 a7 f7 ff    	lea    -0x858b0(%ebx),%eax
f01027fb:	50                   	push   %eax
f01027fc:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102802:	50                   	push   %eax
f0102803:	68 55 03 00 00       	push   $0x355
f0102808:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010280e:	50                   	push   %eax
f010280f:	e8 74 d9 ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0102814:	8d 83 66 a7 f7 ff    	lea    -0x8589a(%ebx),%eax
f010281a:	50                   	push   %eax
f010281b:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102821:	50                   	push   %eax
f0102822:	68 56 03 00 00       	push   $0x356
f0102827:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010282d:	50                   	push   %eax
f010282e:	e8 55 d9 ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0102833:	8d 83 7c a7 f7 ff    	lea    -0x85884(%ebx),%eax
f0102839:	50                   	push   %eax
f010283a:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102840:	50                   	push   %eax
f0102841:	68 57 03 00 00       	push   $0x357
f0102846:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010284c:	50                   	push   %eax
f010284d:	e8 36 d9 ff ff       	call   f0100188 <_panic>
    assert(pp1 && pp1 != pp0);
f0102852:	8d 83 92 a7 f7 ff    	lea    -0x8586e(%ebx),%eax
f0102858:	50                   	push   %eax
f0102859:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f010285f:	50                   	push   %eax
f0102860:	68 5a 03 00 00       	push   $0x35a
f0102865:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010286b:	50                   	push   %eax
f010286c:	e8 17 d9 ff ff       	call   f0100188 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102871:	8d 83 98 9b f7 ff    	lea    -0x86468(%ebx),%eax
f0102877:	50                   	push   %eax
f0102878:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f010287e:	50                   	push   %eax
f010287f:	68 5b 03 00 00       	push   $0x35b
f0102884:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010288a:	50                   	push   %eax
f010288b:	e8 f8 d8 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0102890:	8d 83 a4 a7 f7 ff    	lea    -0x8585c(%ebx),%eax
f0102896:	50                   	push   %eax
f0102897:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f010289d:	50                   	push   %eax
f010289e:	68 62 03 00 00       	push   $0x362
f01028a3:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01028a9:	50                   	push   %eax
f01028aa:	e8 d9 d8 ff ff       	call   f0100188 <_panic>
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01028af:	8d 83 80 9c f7 ff    	lea    -0x86380(%ebx),%eax
f01028b5:	50                   	push   %eax
f01028b6:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01028bc:	50                   	push   %eax
f01028bd:	68 65 03 00 00       	push   $0x365
f01028c2:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01028c8:	50                   	push   %eax
f01028c9:	e8 ba d8 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01028ce:	8d 83 b8 9c f7 ff    	lea    -0x86348(%ebx),%eax
f01028d4:	50                   	push   %eax
f01028d5:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01028db:	50                   	push   %eax
f01028dc:	68 68 03 00 00       	push   $0x368
f01028e1:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01028e7:	50                   	push   %eax
f01028e8:	e8 9b d8 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01028ed:	8d 83 e8 9c f7 ff    	lea    -0x86318(%ebx),%eax
f01028f3:	50                   	push   %eax
f01028f4:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01028fa:	50                   	push   %eax
f01028fb:	68 6c 03 00 00       	push   $0x36c
f0102900:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102906:	50                   	push   %eax
f0102907:	e8 7c d8 ff ff       	call   f0100188 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010290c:	8d 83 18 9d f7 ff    	lea    -0x862e8(%ebx),%eax
f0102912:	50                   	push   %eax
f0102913:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102919:	50                   	push   %eax
f010291a:	68 6d 03 00 00       	push   $0x36d
f010291f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102925:	50                   	push   %eax
f0102926:	e8 5d d8 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010292b:	8d 83 40 9d f7 ff    	lea    -0x862c0(%ebx),%eax
f0102931:	50                   	push   %eax
f0102932:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102938:	50                   	push   %eax
f0102939:	68 6e 03 00 00       	push   $0x36e
f010293e:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102944:	50                   	push   %eax
f0102945:	e8 3e d8 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 1);
f010294a:	8d 83 f6 a7 f7 ff    	lea    -0x8580a(%ebx),%eax
f0102950:	50                   	push   %eax
f0102951:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102957:	50                   	push   %eax
f0102958:	68 6f 03 00 00       	push   $0x36f
f010295d:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102963:	50                   	push   %eax
f0102964:	e8 1f d8 ff ff       	call   f0100188 <_panic>
    assert(pp0->pp_ref == 1);
f0102969:	8d 83 07 a8 f7 ff    	lea    -0x857f9(%ebx),%eax
f010296f:	50                   	push   %eax
f0102970:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102976:	50                   	push   %eax
f0102977:	68 70 03 00 00       	push   $0x370
f010297c:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102982:	50                   	push   %eax
f0102983:	e8 00 d8 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102988:	8d 83 70 9d f7 ff    	lea    -0x86290(%ebx),%eax
f010298e:	50                   	push   %eax
f010298f:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102995:	50                   	push   %eax
f0102996:	68 73 03 00 00       	push   $0x373
f010299b:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01029a1:	50                   	push   %eax
f01029a2:	e8 e1 d7 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01029a7:	8d 83 ac 9d f7 ff    	lea    -0x86254(%ebx),%eax
f01029ad:	50                   	push   %eax
f01029ae:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01029b4:	50                   	push   %eax
f01029b5:	68 74 03 00 00       	push   $0x374
f01029ba:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01029c0:	50                   	push   %eax
f01029c1:	e8 c2 d7 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f01029c6:	8d 83 18 a8 f7 ff    	lea    -0x857e8(%ebx),%eax
f01029cc:	50                   	push   %eax
f01029cd:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01029d3:	50                   	push   %eax
f01029d4:	68 75 03 00 00       	push   $0x375
f01029d9:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01029df:	50                   	push   %eax
f01029e0:	e8 a3 d7 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f01029e5:	8d 83 a4 a7 f7 ff    	lea    -0x8585c(%ebx),%eax
f01029eb:	50                   	push   %eax
f01029ec:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01029f2:	50                   	push   %eax
f01029f3:	68 78 03 00 00       	push   $0x378
f01029f8:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01029fe:	50                   	push   %eax
f01029ff:	e8 84 d7 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102a04:	8d 83 70 9d f7 ff    	lea    -0x86290(%ebx),%eax
f0102a0a:	50                   	push   %eax
f0102a0b:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102a11:	50                   	push   %eax
f0102a12:	68 7b 03 00 00       	push   $0x37b
f0102a17:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102a1d:	50                   	push   %eax
f0102a1e:	e8 65 d7 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102a23:	8d 83 ac 9d f7 ff    	lea    -0x86254(%ebx),%eax
f0102a29:	50                   	push   %eax
f0102a2a:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102a30:	50                   	push   %eax
f0102a31:	68 7c 03 00 00       	push   $0x37c
f0102a36:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102a3c:	50                   	push   %eax
f0102a3d:	e8 46 d7 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f0102a42:	8d 83 18 a8 f7 ff    	lea    -0x857e8(%ebx),%eax
f0102a48:	50                   	push   %eax
f0102a49:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102a4f:	50                   	push   %eax
f0102a50:	68 7d 03 00 00       	push   $0x37d
f0102a55:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102a5b:	50                   	push   %eax
f0102a5c:	e8 27 d7 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0102a61:	8d 83 a4 a7 f7 ff    	lea    -0x8585c(%ebx),%eax
f0102a67:	50                   	push   %eax
f0102a68:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102a6e:	50                   	push   %eax
f0102a6f:	68 81 03 00 00       	push   $0x381
f0102a74:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102a7a:	50                   	push   %eax
f0102a7b:	e8 08 d7 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102a80:	50                   	push   %eax
f0102a81:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0102a87:	50                   	push   %eax
f0102a88:	68 84 03 00 00       	push   $0x384
f0102a8d:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102a93:	50                   	push   %eax
f0102a94:	e8 ef d6 ff ff       	call   f0100188 <_panic>
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102a99:	8d 83 dc 9d f7 ff    	lea    -0x86224(%ebx),%eax
f0102a9f:	50                   	push   %eax
f0102aa0:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102aa6:	50                   	push   %eax
f0102aa7:	68 85 03 00 00       	push   $0x385
f0102aac:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102ab2:	50                   	push   %eax
f0102ab3:	e8 d0 d6 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0102ab8:	8d 83 20 9e f7 ff    	lea    -0x861e0(%ebx),%eax
f0102abe:	50                   	push   %eax
f0102abf:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102ac5:	50                   	push   %eax
f0102ac6:	68 88 03 00 00       	push   $0x388
f0102acb:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102ad1:	50                   	push   %eax
f0102ad2:	e8 b1 d6 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102ad7:	8d 83 ac 9d f7 ff    	lea    -0x86254(%ebx),%eax
f0102add:	50                   	push   %eax
f0102ade:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102ae4:	50                   	push   %eax
f0102ae5:	68 89 03 00 00       	push   $0x389
f0102aea:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102af0:	50                   	push   %eax
f0102af1:	e8 92 d6 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f0102af6:	8d 83 18 a8 f7 ff    	lea    -0x857e8(%ebx),%eax
f0102afc:	50                   	push   %eax
f0102afd:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102b03:	50                   	push   %eax
f0102b04:	68 8a 03 00 00       	push   $0x38a
f0102b09:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102b0f:	50                   	push   %eax
f0102b10:	e8 73 d6 ff ff       	call   f0100188 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f0102b15:	8d 83 64 9e f7 ff    	lea    -0x8619c(%ebx),%eax
f0102b1b:	50                   	push   %eax
f0102b1c:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102b22:	50                   	push   %eax
f0102b23:	68 8b 03 00 00       	push   $0x38b
f0102b28:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102b2e:	50                   	push   %eax
f0102b2f:	e8 54 d6 ff ff       	call   f0100188 <_panic>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f0102b34:	8d 83 29 a8 f7 ff    	lea    -0x857d7(%ebx),%eax
f0102b3a:	50                   	push   %eax
f0102b3b:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102b41:	50                   	push   %eax
f0102b42:	68 8c 03 00 00       	push   $0x38c
f0102b47:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102b4d:	50                   	push   %eax
f0102b4e:	e8 35 d6 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102b53:	8d 83 70 9d f7 ff    	lea    -0x86290(%ebx),%eax
f0102b59:	50                   	push   %eax
f0102b5a:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102b60:	50                   	push   %eax
f0102b61:	68 8f 03 00 00       	push   $0x38f
f0102b66:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102b6c:	50                   	push   %eax
f0102b6d:	e8 16 d6 ff ff       	call   f0100188 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102b72:	8d 83 98 9e f7 ff    	lea    -0x86168(%ebx),%eax
f0102b78:	50                   	push   %eax
f0102b79:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102b7f:	50                   	push   %eax
f0102b80:	68 90 03 00 00       	push   $0x390
f0102b85:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102b8b:	50                   	push   %eax
f0102b8c:	e8 f7 d5 ff ff       	call   f0100188 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102b91:	8d 83 cc 9e f7 ff    	lea    -0x86134(%ebx),%eax
f0102b97:	50                   	push   %eax
f0102b98:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102b9e:	50                   	push   %eax
f0102b9f:	68 91 03 00 00       	push   $0x391
f0102ba4:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102baa:	50                   	push   %eax
f0102bab:	e8 d8 d5 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102bb0:	8d 83 04 9f f7 ff    	lea    -0x860fc(%ebx),%eax
f0102bb6:	50                   	push   %eax
f0102bb7:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102bbd:	50                   	push   %eax
f0102bbe:	68 94 03 00 00       	push   $0x394
f0102bc3:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102bc9:	50                   	push   %eax
f0102bca:	e8 b9 d5 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0102bcf:	8d 83 40 9f f7 ff    	lea    -0x860c0(%ebx),%eax
f0102bd5:	50                   	push   %eax
f0102bd6:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102bdc:	50                   	push   %eax
f0102bdd:	68 97 03 00 00       	push   $0x397
f0102be2:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102be8:	50                   	push   %eax
f0102be9:	e8 9a d5 ff ff       	call   f0100188 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102bee:	8d 83 cc 9e f7 ff    	lea    -0x86134(%ebx),%eax
f0102bf4:	50                   	push   %eax
f0102bf5:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102bfb:	50                   	push   %eax
f0102bfc:	68 98 03 00 00       	push   $0x398
f0102c01:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102c07:	50                   	push   %eax
f0102c08:	e8 7b d5 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102c0d:	8d 83 7c 9f f7 ff    	lea    -0x86084(%ebx),%eax
f0102c13:	50                   	push   %eax
f0102c14:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102c1a:	50                   	push   %eax
f0102c1b:	68 9b 03 00 00       	push   $0x39b
f0102c20:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102c26:	50                   	push   %eax
f0102c27:	e8 5c d5 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102c2c:	8d 83 a8 9f f7 ff    	lea    -0x86058(%ebx),%eax
f0102c32:	50                   	push   %eax
f0102c33:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102c39:	50                   	push   %eax
f0102c3a:	68 9c 03 00 00       	push   $0x39c
f0102c3f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102c45:	50                   	push   %eax
f0102c46:	e8 3d d5 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 2);
f0102c4b:	8d 83 3f a8 f7 ff    	lea    -0x857c1(%ebx),%eax
f0102c51:	50                   	push   %eax
f0102c52:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102c58:	50                   	push   %eax
f0102c59:	68 9e 03 00 00       	push   $0x39e
f0102c5e:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102c64:	50                   	push   %eax
f0102c65:	e8 1e d5 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f0102c6a:	8d 83 50 a8 f7 ff    	lea    -0x857b0(%ebx),%eax
f0102c70:	50                   	push   %eax
f0102c71:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102c77:	50                   	push   %eax
f0102c78:	68 9f 03 00 00       	push   $0x39f
f0102c7d:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102c83:	50                   	push   %eax
f0102c84:	e8 ff d4 ff ff       	call   f0100188 <_panic>
    assert((pp = page_alloc(0)) && pp == pp2);
f0102c89:	8d 83 d8 9f f7 ff    	lea    -0x86028(%ebx),%eax
f0102c8f:	50                   	push   %eax
f0102c90:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102c96:	50                   	push   %eax
f0102c97:	68 a2 03 00 00       	push   $0x3a2
f0102c9c:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102ca2:	50                   	push   %eax
f0102ca3:	e8 e0 d4 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102ca8:	8d 83 fc 9f f7 ff    	lea    -0x86004(%ebx),%eax
f0102cae:	50                   	push   %eax
f0102caf:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102cb5:	50                   	push   %eax
f0102cb6:	68 a6 03 00 00       	push   $0x3a6
f0102cbb:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102cc1:	50                   	push   %eax
f0102cc2:	e8 c1 d4 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102cc7:	8d 83 a8 9f f7 ff    	lea    -0x86058(%ebx),%eax
f0102ccd:	50                   	push   %eax
f0102cce:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102cd4:	50                   	push   %eax
f0102cd5:	68 a7 03 00 00       	push   $0x3a7
f0102cda:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102ce0:	50                   	push   %eax
f0102ce1:	e8 a2 d4 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 1);
f0102ce6:	8d 83 f6 a7 f7 ff    	lea    -0x8580a(%ebx),%eax
f0102cec:	50                   	push   %eax
f0102ced:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102cf3:	50                   	push   %eax
f0102cf4:	68 a8 03 00 00       	push   $0x3a8
f0102cf9:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102cff:	50                   	push   %eax
f0102d00:	e8 83 d4 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f0102d05:	8d 83 50 a8 f7 ff    	lea    -0x857b0(%ebx),%eax
f0102d0b:	50                   	push   %eax
f0102d0c:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102d12:	50                   	push   %eax
f0102d13:	68 a9 03 00 00       	push   $0x3a9
f0102d18:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102d1e:	50                   	push   %eax
f0102d1f:	e8 64 d4 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102d24:	8d 83 20 a0 f7 ff    	lea    -0x85fe0(%ebx),%eax
f0102d2a:	50                   	push   %eax
f0102d2b:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102d31:	50                   	push   %eax
f0102d32:	68 ac 03 00 00       	push   $0x3ac
f0102d37:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102d3d:	50                   	push   %eax
f0102d3e:	e8 45 d4 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref);
f0102d43:	8d 83 61 a8 f7 ff    	lea    -0x8579f(%ebx),%eax
f0102d49:	50                   	push   %eax
f0102d4a:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102d50:	50                   	push   %eax
f0102d51:	68 ad 03 00 00       	push   $0x3ad
f0102d56:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102d5c:	50                   	push   %eax
f0102d5d:	e8 26 d4 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_link == NULL);
f0102d62:	8d 83 6d a8 f7 ff    	lea    -0x85793(%ebx),%eax
f0102d68:	50                   	push   %eax
f0102d69:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102d6f:	50                   	push   %eax
f0102d70:	68 ae 03 00 00       	push   $0x3ae
f0102d75:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102d7b:	50                   	push   %eax
f0102d7c:	e8 07 d4 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102d81:	8d 83 fc 9f f7 ff    	lea    -0x86004(%ebx),%eax
f0102d87:	50                   	push   %eax
f0102d88:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102d8e:	50                   	push   %eax
f0102d8f:	68 b2 03 00 00       	push   $0x3b2
f0102d94:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102d9a:	50                   	push   %eax
f0102d9b:	e8 e8 d3 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102da0:	8d 83 58 a0 f7 ff    	lea    -0x85fa8(%ebx),%eax
f0102da6:	50                   	push   %eax
f0102da7:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102dad:	50                   	push   %eax
f0102dae:	68 b3 03 00 00       	push   $0x3b3
f0102db3:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102db9:	50                   	push   %eax
f0102dba:	e8 c9 d3 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 0);
f0102dbf:	8d 83 82 a8 f7 ff    	lea    -0x8577e(%ebx),%eax
f0102dc5:	50                   	push   %eax
f0102dc6:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102dcc:	50                   	push   %eax
f0102dcd:	68 b4 03 00 00       	push   $0x3b4
f0102dd2:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102dd8:	50                   	push   %eax
f0102dd9:	e8 aa d3 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f0102dde:	8d 83 50 a8 f7 ff    	lea    -0x857b0(%ebx),%eax
f0102de4:	50                   	push   %eax
f0102de5:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102deb:	50                   	push   %eax
f0102dec:	68 b5 03 00 00       	push   $0x3b5
f0102df1:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102df7:	50                   	push   %eax
f0102df8:	e8 8b d3 ff ff       	call   f0100188 <_panic>
    assert((pp = page_alloc(0)) && pp == pp1);
f0102dfd:	8d 83 80 a0 f7 ff    	lea    -0x85f80(%ebx),%eax
f0102e03:	50                   	push   %eax
f0102e04:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102e0a:	50                   	push   %eax
f0102e0b:	68 b8 03 00 00       	push   $0x3b8
f0102e10:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102e16:	50                   	push   %eax
f0102e17:	e8 6c d3 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0102e1c:	8d 83 a4 a7 f7 ff    	lea    -0x8585c(%ebx),%eax
f0102e22:	50                   	push   %eax
f0102e23:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102e29:	50                   	push   %eax
f0102e2a:	68 bb 03 00 00       	push   $0x3bb
f0102e2f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102e35:	50                   	push   %eax
f0102e36:	e8 4d d3 ff ff       	call   f0100188 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e3b:	8d 83 18 9d f7 ff    	lea    -0x862e8(%ebx),%eax
f0102e41:	50                   	push   %eax
f0102e42:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102e48:	50                   	push   %eax
f0102e49:	68 be 03 00 00       	push   $0x3be
f0102e4e:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102e54:	50                   	push   %eax
f0102e55:	e8 2e d3 ff ff       	call   f0100188 <_panic>
    assert(pp0->pp_ref == 1);
f0102e5a:	8d 83 07 a8 f7 ff    	lea    -0x857f9(%ebx),%eax
f0102e60:	50                   	push   %eax
f0102e61:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102e67:	50                   	push   %eax
f0102e68:	68 c0 03 00 00       	push   $0x3c0
f0102e6d:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102e73:	50                   	push   %eax
f0102e74:	e8 0f d3 ff ff       	call   f0100188 <_panic>
f0102e79:	ff 75 cc             	pushl  -0x34(%ebp)
f0102e7c:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0102e82:	50                   	push   %eax
f0102e83:	68 c7 03 00 00       	push   $0x3c7
f0102e88:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102e8e:	50                   	push   %eax
f0102e8f:	e8 f4 d2 ff ff       	call   f0100188 <_panic>
    assert(ptep == ptep1 + PTX(va));
f0102e94:	8d 83 93 a8 f7 ff    	lea    -0x8576d(%ebx),%eax
f0102e9a:	50                   	push   %eax
f0102e9b:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102ea1:	50                   	push   %eax
f0102ea2:	68 cc 03 00 00       	push   $0x3cc
f0102ea7:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102ead:	50                   	push   %eax
f0102eae:	e8 d5 d2 ff ff       	call   f0100188 <_panic>
f0102eb3:	50                   	push   %eax
f0102eb4:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0102eba:	50                   	push   %eax
f0102ebb:	6a 56                	push   $0x56
f0102ebd:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0102ec3:	50                   	push   %eax
f0102ec4:	e8 bf d2 ff ff       	call   f0100188 <_panic>
f0102ec9:	52                   	push   %edx
f0102eca:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0102ed0:	50                   	push   %eax
f0102ed1:	6a 56                	push   $0x56
f0102ed3:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0102ed9:	50                   	push   %eax
f0102eda:	e8 a9 d2 ff ff       	call   f0100188 <_panic>
        assert((ptep[i] & PTE_P) == 0);
f0102edf:	8d 83 ab a8 f7 ff    	lea    -0x85755(%ebx),%eax
f0102ee5:	50                   	push   %eax
f0102ee6:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102eec:	50                   	push   %eax
f0102eed:	68 d6 03 00 00       	push   $0x3d6
f0102ef2:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102ef8:	50                   	push   %eax
f0102ef9:	e8 8a d2 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102efe:	50                   	push   %eax
f0102eff:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f05:	50                   	push   %eax
f0102f06:	68 ce 00 00 00       	push   $0xce
f0102f0b:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102f11:	50                   	push   %eax
f0102f12:	e8 71 d2 ff ff       	call   f0100188 <_panic>
f0102f17:	50                   	push   %eax
f0102f18:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f1e:	50                   	push   %eax
f0102f1f:	68 cf 00 00 00       	push   $0xcf
f0102f24:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102f2a:	50                   	push   %eax
f0102f2b:	e8 58 d2 ff ff       	call   f0100188 <_panic>
f0102f30:	50                   	push   %eax
f0102f31:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f37:	50                   	push   %eax
f0102f38:	68 d0 00 00 00       	push   $0xd0
f0102f3d:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102f43:	50                   	push   %eax
f0102f44:	e8 3f d2 ff ff       	call   f0100188 <_panic>
f0102f49:	50                   	push   %eax
f0102f4a:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f50:	50                   	push   %eax
f0102f51:	68 d4 00 00 00       	push   $0xd4
f0102f56:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102f5c:	50                   	push   %eax
f0102f5d:	e8 26 d2 ff ff       	call   f0100188 <_panic>
f0102f62:	50                   	push   %eax
f0102f63:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f69:	50                   	push   %eax
f0102f6a:	68 d7 00 00 00       	push   $0xd7
f0102f6f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102f75:	50                   	push   %eax
f0102f76:	e8 0d d2 ff ff       	call   f0100188 <_panic>
f0102f7b:	50                   	push   %eax
f0102f7c:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f82:	50                   	push   %eax
f0102f83:	68 e5 00 00 00       	push   $0xe5
f0102f88:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102f8e:	50                   	push   %eax
f0102f8f:	e8 f4 d1 ff ff       	call   f0100188 <_panic>
f0102f94:	57                   	push   %edi
f0102f95:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102f9b:	50                   	push   %eax
f0102f9c:	68 11 03 00 00       	push   $0x311
f0102fa1:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102fa7:	50                   	push   %eax
f0102fa8:	e8 db d1 ff ff       	call   f0100188 <_panic>
f0102fad:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102fb0:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0102fb6:	50                   	push   %eax
f0102fb7:	68 13 03 00 00       	push   $0x313
f0102fbc:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102fc2:	50                   	push   %eax
f0102fc3:	e8 c0 d1 ff ff       	call   f0100188 <_panic>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102fc8:	8d 83 5c a3 f7 ff    	lea    -0x85ca4(%ebx),%eax
f0102fce:	50                   	push   %eax
f0102fcf:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0102fd5:	50                   	push   %eax
f0102fd6:	68 13 03 00 00       	push   $0x313
f0102fdb:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0102fe1:	50                   	push   %eax
f0102fe2:	e8 a1 d1 ff ff       	call   f0100188 <_panic>
f0102fe7:	8b 75 d0             	mov    -0x30(%ebp),%esi
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102fea:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f0102ff0:	8b 00                	mov    (%eax),%eax
f0102ff2:	c1 e0 0c             	shl    $0xc,%eax
f0102ff5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102ff8:	bf 00 00 00 00       	mov    $0x0,%edi
f0102ffd:	eb 1b                	jmp    f010301a <mem_init+0x1a1f>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102fff:	8d 97 00 00 00 f0    	lea    -0x10000000(%edi),%edx
f0103005:	89 f0                	mov    %esi,%eax
f0103007:	e8 bb db ff ff       	call   f0100bc7 <check_va2pa>
f010300c:	39 c7                	cmp    %eax,%edi
f010300e:	0f 85 86 00 00 00    	jne    f010309a <mem_init+0x1a9f>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103014:	81 c7 00 10 00 00    	add    $0x1000,%edi
f010301a:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
f010301d:	72 e0                	jb     f0102fff <mem_init+0x1a04>
f010301f:	bf 00 80 ff ef       	mov    $0xefff8000,%edi
        assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0103024:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0103027:	05 00 80 00 20       	add    $0x20008000,%eax
f010302c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010302f:	89 fa                	mov    %edi,%edx
f0103031:	89 f0                	mov    %esi,%eax
f0103033:	e8 8f db ff ff       	call   f0100bc7 <check_va2pa>
f0103038:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010303b:	8d 14 39             	lea    (%ecx,%edi,1),%edx
f010303e:	39 c2                	cmp    %eax,%edx
f0103040:	75 77                	jne    f01030b9 <mem_init+0x1abe>
f0103042:	81 c7 00 10 00 00    	add    $0x1000,%edi
    for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103048:	81 ff 00 00 00 f0    	cmp    $0xf0000000,%edi
f010304e:	75 df                	jne    f010302f <mem_init+0x1a34>
    assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0103050:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0103055:	89 f0                	mov    %esi,%eax
f0103057:	e8 6b db ff ff       	call   f0100bc7 <check_va2pa>
f010305c:	83 f8 ff             	cmp    $0xffffffff,%eax
f010305f:	75 77                	jne    f01030d8 <mem_init+0x1add>
    for (i = 0; i < NPDENTRIES; i++) {
f0103061:	b8 00 00 00 00       	mov    $0x0,%eax
                if (i >= PDX(KERNBASE)) {
f0103066:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f010306b:	0f 87 05 01 00 00    	ja     f0103176 <mem_init+0x1b7b>
                    assert(pgdir[i] == 0);
f0103071:	83 3c 86 00          	cmpl   $0x0,(%esi,%eax,4)
f0103075:	0f 84 8d 00 00 00    	je     f0103108 <mem_init+0x1b0d>
f010307b:	8d 83 12 a9 f7 ff    	lea    -0x856ee(%ebx),%eax
f0103081:	50                   	push   %eax
f0103082:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103088:	50                   	push   %eax
f0103089:	68 2f 03 00 00       	push   $0x32f
f010308e:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103094:	50                   	push   %eax
f0103095:	e8 ee d0 ff ff       	call   f0100188 <_panic>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010309a:	8d 83 90 a3 f7 ff    	lea    -0x85c70(%ebx),%eax
f01030a0:	50                   	push   %eax
f01030a1:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01030a7:	50                   	push   %eax
f01030a8:	68 18 03 00 00       	push   $0x318
f01030ad:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01030b3:	50                   	push   %eax
f01030b4:	e8 cf d0 ff ff       	call   f0100188 <_panic>
        assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01030b9:	8d 83 b8 a3 f7 ff    	lea    -0x85c48(%ebx),%eax
f01030bf:	50                   	push   %eax
f01030c0:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01030c6:	50                   	push   %eax
f01030c7:	68 1c 03 00 00       	push   $0x31c
f01030cc:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01030d2:	50                   	push   %eax
f01030d3:	e8 b0 d0 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f01030d8:	8d 83 00 a4 f7 ff    	lea    -0x85c00(%ebx),%eax
f01030de:	50                   	push   %eax
f01030df:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01030e5:	50                   	push   %eax
f01030e6:	68 1d 03 00 00       	push   $0x31d
f01030eb:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01030f1:	50                   	push   %eax
f01030f2:	e8 91 d0 ff ff       	call   f0100188 <_panic>
        switch (i) {
f01030f7:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f01030fc:	0f 85 64 ff ff ff    	jne    f0103066 <mem_init+0x1a6b>
                assert(pgdir[i] & PTE_P);
f0103102:	f6 04 86 01          	testb  $0x1,(%esi,%eax,4)
f0103106:	74 4f                	je     f0103157 <mem_init+0x1b5c>
    for (i = 0; i < NPDENTRIES; i++) {
f0103108:	83 c0 01             	add    $0x1,%eax
f010310b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0103110:	0f 87 ab 00 00 00    	ja     f01031c1 <mem_init+0x1bc6>
        switch (i) {
f0103116:	3d bd 03 00 00       	cmp    $0x3bd,%eax
f010311b:	77 da                	ja     f01030f7 <mem_init+0x1afc>
f010311d:	3d bc 03 00 00       	cmp    $0x3bc,%eax
f0103122:	73 de                	jae    f0103102 <mem_init+0x1b07>
f0103124:	3d bb 03 00 00       	cmp    $0x3bb,%eax
f0103129:	0f 85 37 ff ff ff    	jne    f0103066 <mem_init+0x1a6b>
                assert(pgdir[i] & PTE_P);
f010312f:	f6 86 ec 0e 00 00 01 	testb  $0x1,0xeec(%esi)
f0103136:	75 d0                	jne    f0103108 <mem_init+0x1b0d>
f0103138:	8d 83 f0 a8 f7 ff    	lea    -0x85710(%ebx),%eax
f010313e:	50                   	push   %eax
f010313f:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103145:	50                   	push   %eax
f0103146:	68 28 03 00 00       	push   $0x328
f010314b:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103151:	50                   	push   %eax
f0103152:	e8 31 d0 ff ff       	call   f0100188 <_panic>
                assert(pgdir[i] & PTE_P);
f0103157:	8d 83 f0 a8 f7 ff    	lea    -0x85710(%ebx),%eax
f010315d:	50                   	push   %eax
f010315e:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103164:	50                   	push   %eax
f0103165:	68 25 03 00 00       	push   $0x325
f010316a:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103170:	50                   	push   %eax
f0103171:	e8 12 d0 ff ff       	call   f0100188 <_panic>
                    assert(pgdir[i] & PTE_P);
f0103176:	8b 14 86             	mov    (%esi,%eax,4),%edx
f0103179:	f6 c2 01             	test   $0x1,%dl
f010317c:	74 24                	je     f01031a2 <mem_init+0x1ba7>
                    assert(pgdir[i] & PTE_W);
f010317e:	f6 c2 02             	test   $0x2,%dl
f0103181:	75 85                	jne    f0103108 <mem_init+0x1b0d>
f0103183:	8d 83 01 a9 f7 ff    	lea    -0x856ff(%ebx),%eax
f0103189:	50                   	push   %eax
f010318a:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103190:	50                   	push   %eax
f0103191:	68 2d 03 00 00       	push   $0x32d
f0103196:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010319c:	50                   	push   %eax
f010319d:	e8 e6 cf ff ff       	call   f0100188 <_panic>
                    assert(pgdir[i] & PTE_P);
f01031a2:	8d 83 f0 a8 f7 ff    	lea    -0x85710(%ebx),%eax
f01031a8:	50                   	push   %eax
f01031a9:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01031af:	50                   	push   %eax
f01031b0:	68 2c 03 00 00       	push   $0x32c
f01031b5:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01031bb:	50                   	push   %eax
f01031bc:	e8 c7 cf ff ff       	call   f0100188 <_panic>
    cprintf("check_kern_pgdir() succeeded!\n");
f01031c1:	83 ec 0c             	sub    $0xc,%esp
f01031c4:	8d 83 30 a4 f7 ff    	lea    -0x85bd0(%ebx),%eax
f01031ca:	50                   	push   %eax
f01031cb:	e8 ad 09 00 00       	call   f0103b7d <cprintf>
    lcr3(PADDR(kern_pgdir));
f01031d0:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01031d6:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01031d8:	83 c4 10             	add    $0x10,%esp
f01031db:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01031e0:	0f 86 47 02 00 00    	jbe    f010342d <mem_init+0x1e32>
	return (physaddr_t)kva - KERNBASE;
f01031e6:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01031eb:	0f 22 d8             	mov    %eax,%cr3
    cprintf("\n************* Now check that the pages on the page_free_list are reasonable. **************\n");
f01031ee:	83 ec 0c             	sub    $0xc,%esp
f01031f1:	8d 83 50 a4 f7 ff    	lea    -0x85bb0(%ebx),%eax
f01031f7:	50                   	push   %eax
f01031f8:	e8 80 09 00 00       	call   f0103b7d <cprintf>
    check_page_free_list(0);
f01031fd:	b8 00 00 00 00       	mov    $0x0,%eax
f0103202:	e8 3d da ff ff       	call   f0100c44 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0103207:	0f 20 c0             	mov    %cr0,%eax
    cr0 &= ~(CR0_TS | CR0_EM);
f010320a:	83 e0 f3             	and    $0xfffffff3,%eax
f010320d:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0103212:	0f 22 c0             	mov    %eax,%cr0
    cprintf("\n************* Now check page_insert, page_remove, &c, with an installed kern_pgdir **************\n");
f0103215:	8d 83 b0 a4 f7 ff    	lea    -0x85b50(%ebx),%eax
f010321b:	89 04 24             	mov    %eax,(%esp)
f010321e:	e8 5a 09 00 00       	call   f0103b7d <cprintf>
    uintptr_t va;
    int i;

    // check that we can read and write installed pages
    pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0103223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010322a:	e8 9d df ff ff       	call   f01011cc <page_alloc>
f010322f:	89 c6                	mov    %eax,%esi
f0103231:	83 c4 10             	add    $0x10,%esp
f0103234:	85 c0                	test   %eax,%eax
f0103236:	0f 84 0a 02 00 00    	je     f0103446 <mem_init+0x1e4b>
    assert((pp1 = page_alloc(0)));
f010323c:	83 ec 0c             	sub    $0xc,%esp
f010323f:	6a 00                	push   $0x0
f0103241:	e8 86 df ff ff       	call   f01011cc <page_alloc>
f0103246:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103249:	83 c4 10             	add    $0x10,%esp
f010324c:	85 c0                	test   %eax,%eax
f010324e:	0f 84 11 02 00 00    	je     f0103465 <mem_init+0x1e6a>
    assert((pp2 = page_alloc(0)));
f0103254:	83 ec 0c             	sub    $0xc,%esp
f0103257:	6a 00                	push   $0x0
f0103259:	e8 6e df ff ff       	call   f01011cc <page_alloc>
f010325e:	89 c7                	mov    %eax,%edi
f0103260:	83 c4 10             	add    $0x10,%esp
f0103263:	85 c0                	test   %eax,%eax
f0103265:	0f 84 19 02 00 00    	je     f0103484 <mem_init+0x1e89>
    page_free(pp0);
f010326b:	83 ec 0c             	sub    $0xc,%esp
f010326e:	56                   	push   %esi
f010326f:	e8 e6 df ff ff       	call   f010125a <page_free>
	return (pp - pages) << PGSHIFT;
f0103274:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f010327a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010327d:	2b 08                	sub    (%eax),%ecx
f010327f:	89 c8                	mov    %ecx,%eax
f0103281:	c1 f8 03             	sar    $0x3,%eax
f0103284:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103287:	89 c1                	mov    %eax,%ecx
f0103289:	c1 e9 0c             	shr    $0xc,%ecx
f010328c:	83 c4 10             	add    $0x10,%esp
f010328f:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f0103295:	3b 0a                	cmp    (%edx),%ecx
f0103297:	0f 83 06 02 00 00    	jae    f01034a3 <mem_init+0x1ea8>
    memset(page2kva(pp1), 1, PGSIZE);
f010329d:	83 ec 04             	sub    $0x4,%esp
f01032a0:	68 00 10 00 00       	push   $0x1000
f01032a5:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01032a7:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01032ac:	50                   	push   %eax
f01032ad:	e8 e6 19 00 00       	call   f0104c98 <memset>
	return (pp - pages) << PGSHIFT;
f01032b2:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f01032b8:	89 f9                	mov    %edi,%ecx
f01032ba:	2b 08                	sub    (%eax),%ecx
f01032bc:	89 c8                	mov    %ecx,%eax
f01032be:	c1 f8 03             	sar    $0x3,%eax
f01032c1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01032c4:	89 c1                	mov    %eax,%ecx
f01032c6:	c1 e9 0c             	shr    $0xc,%ecx
f01032c9:	83 c4 10             	add    $0x10,%esp
f01032cc:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f01032d2:	3b 0a                	cmp    (%edx),%ecx
f01032d4:	0f 83 df 01 00 00    	jae    f01034b9 <mem_init+0x1ebe>
    memset(page2kva(pp2), 2, PGSIZE);
f01032da:	83 ec 04             	sub    $0x4,%esp
f01032dd:	68 00 10 00 00       	push   $0x1000
f01032e2:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f01032e4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01032e9:	50                   	push   %eax
f01032ea:	e8 a9 19 00 00       	call   f0104c98 <memset>
    page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f01032ef:	6a 02                	push   $0x2
f01032f1:	68 00 10 00 00       	push   $0x1000
f01032f6:	ff 75 d4             	pushl  -0x2c(%ebp)
f01032f9:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01032ff:	ff 30                	pushl  (%eax)
f0103301:	e8 a0 e1 ff ff       	call   f01014a6 <page_insert>
    assert(pp1->pp_ref == 1);
f0103306:	83 c4 20             	add    $0x20,%esp
f0103309:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010330c:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0103311:	0f 85 b8 01 00 00    	jne    f01034cf <mem_init+0x1ed4>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0103317:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f010331e:	01 01 01 
f0103321:	0f 85 c7 01 00 00    	jne    f01034ee <mem_init+0x1ef3>
    page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0103327:	6a 02                	push   $0x2
f0103329:	68 00 10 00 00       	push   $0x1000
f010332e:	57                   	push   %edi
f010332f:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f0103335:	ff 30                	pushl  (%eax)
f0103337:	e8 6a e1 ff ff       	call   f01014a6 <page_insert>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f010333c:	83 c4 10             	add    $0x10,%esp
f010333f:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103346:	02 02 02 
f0103349:	0f 85 be 01 00 00    	jne    f010350d <mem_init+0x1f12>
    assert(pp2->pp_ref == 1);
f010334f:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103354:	0f 85 d2 01 00 00    	jne    f010352c <mem_init+0x1f31>
    assert(pp1->pp_ref == 0);
f010335a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010335d:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0103362:	0f 85 e3 01 00 00    	jne    f010354b <mem_init+0x1f50>
    *(uint32_t *) PGSIZE = 0x03030303U;
f0103368:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f010336f:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0103372:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f0103378:	89 f9                	mov    %edi,%ecx
f010337a:	2b 08                	sub    (%eax),%ecx
f010337c:	89 c8                	mov    %ecx,%eax
f010337e:	c1 f8 03             	sar    $0x3,%eax
f0103381:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103384:	89 c1                	mov    %eax,%ecx
f0103386:	c1 e9 0c             	shr    $0xc,%ecx
f0103389:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f010338f:	3b 0a                	cmp    (%edx),%ecx
f0103391:	0f 83 d3 01 00 00    	jae    f010356a <mem_init+0x1f6f>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0103397:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f010339e:	03 03 03 
f01033a1:	0f 85 d9 01 00 00    	jne    f0103580 <mem_init+0x1f85>
    page_remove(kern_pgdir, (void *) PGSIZE);
f01033a7:	83 ec 08             	sub    $0x8,%esp
f01033aa:	68 00 10 00 00       	push   $0x1000
f01033af:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01033b5:	ff 30                	pushl  (%eax)
f01033b7:	e8 99 e0 ff ff       	call   f0101455 <page_remove>
    assert(pp2->pp_ref == 0);
f01033bc:	83 c4 10             	add    $0x10,%esp
f01033bf:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01033c4:	0f 85 d5 01 00 00    	jne    f010359f <mem_init+0x1fa4>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01033ca:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f01033d0:	8b 08                	mov    (%eax),%ecx
f01033d2:	8b 11                	mov    (%ecx),%edx
f01033d4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01033da:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f01033e0:	89 f7                	mov    %esi,%edi
f01033e2:	2b 38                	sub    (%eax),%edi
f01033e4:	89 f8                	mov    %edi,%eax
f01033e6:	c1 f8 03             	sar    $0x3,%eax
f01033e9:	c1 e0 0c             	shl    $0xc,%eax
f01033ec:	39 c2                	cmp    %eax,%edx
f01033ee:	0f 85 ca 01 00 00    	jne    f01035be <mem_init+0x1fc3>
    kern_pgdir[0] = 0;
f01033f4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f01033fa:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01033ff:	0f 85 d8 01 00 00    	jne    f01035dd <mem_init+0x1fe2>
    pp0->pp_ref = 0;
f0103405:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

    // free the pages we took
    page_free(pp0);
f010340b:	83 ec 0c             	sub    $0xc,%esp
f010340e:	56                   	push   %esi
f010340f:	e8 46 de ff ff       	call   f010125a <page_free>

    cprintf("check_page_installed_pgdir() succeeded!\n");
f0103414:	8d 83 88 a5 f7 ff    	lea    -0x85a78(%ebx),%eax
f010341a:	89 04 24             	mov    %eax,(%esp)
f010341d:	e8 5b 07 00 00       	call   f0103b7d <cprintf>
}
f0103422:	83 c4 10             	add    $0x10,%esp
f0103425:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103428:	5b                   	pop    %ebx
f0103429:	5e                   	pop    %esi
f010342a:	5f                   	pop    %edi
f010342b:	5d                   	pop    %ebp
f010342c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010342d:	50                   	push   %eax
f010342e:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0103434:	50                   	push   %eax
f0103435:	68 fc 00 00 00       	push   $0xfc
f010343a:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103440:	50                   	push   %eax
f0103441:	e8 42 cd ff ff       	call   f0100188 <_panic>
    assert((pp0 = page_alloc(0)));
f0103446:	8d 83 50 a7 f7 ff    	lea    -0x858b0(%ebx),%eax
f010344c:	50                   	push   %eax
f010344d:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103453:	50                   	push   %eax
f0103454:	68 f0 03 00 00       	push   $0x3f0
f0103459:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010345f:	50                   	push   %eax
f0103460:	e8 23 cd ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0103465:	8d 83 66 a7 f7 ff    	lea    -0x8589a(%ebx),%eax
f010346b:	50                   	push   %eax
f010346c:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103472:	50                   	push   %eax
f0103473:	68 f1 03 00 00       	push   $0x3f1
f0103478:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010347e:	50                   	push   %eax
f010347f:	e8 04 cd ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0103484:	8d 83 7c a7 f7 ff    	lea    -0x85884(%ebx),%eax
f010348a:	50                   	push   %eax
f010348b:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103491:	50                   	push   %eax
f0103492:	68 f2 03 00 00       	push   $0x3f2
f0103497:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f010349d:	50                   	push   %eax
f010349e:	e8 e5 cc ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01034a3:	50                   	push   %eax
f01034a4:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f01034aa:	50                   	push   %eax
f01034ab:	6a 56                	push   $0x56
f01034ad:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f01034b3:	50                   	push   %eax
f01034b4:	e8 cf cc ff ff       	call   f0100188 <_panic>
f01034b9:	50                   	push   %eax
f01034ba:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f01034c0:	50                   	push   %eax
f01034c1:	6a 56                	push   $0x56
f01034c3:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f01034c9:	50                   	push   %eax
f01034ca:	e8 b9 cc ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 1);
f01034cf:	8d 83 f6 a7 f7 ff    	lea    -0x8580a(%ebx),%eax
f01034d5:	50                   	push   %eax
f01034d6:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01034dc:	50                   	push   %eax
f01034dd:	68 f7 03 00 00       	push   $0x3f7
f01034e2:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01034e8:	50                   	push   %eax
f01034e9:	e8 9a cc ff ff       	call   f0100188 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f01034ee:	8d 83 14 a5 f7 ff    	lea    -0x85aec(%ebx),%eax
f01034f4:	50                   	push   %eax
f01034f5:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01034fb:	50                   	push   %eax
f01034fc:	68 f8 03 00 00       	push   $0x3f8
f0103501:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103507:	50                   	push   %eax
f0103508:	e8 7b cc ff ff       	call   f0100188 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f010350d:	8d 83 38 a5 f7 ff    	lea    -0x85ac8(%ebx),%eax
f0103513:	50                   	push   %eax
f0103514:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f010351a:	50                   	push   %eax
f010351b:	68 fa 03 00 00       	push   $0x3fa
f0103520:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103526:	50                   	push   %eax
f0103527:	e8 5c cc ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f010352c:	8d 83 18 a8 f7 ff    	lea    -0x857e8(%ebx),%eax
f0103532:	50                   	push   %eax
f0103533:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103539:	50                   	push   %eax
f010353a:	68 fb 03 00 00       	push   $0x3fb
f010353f:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103545:	50                   	push   %eax
f0103546:	e8 3d cc ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 0);
f010354b:	8d 83 82 a8 f7 ff    	lea    -0x8577e(%ebx),%eax
f0103551:	50                   	push   %eax
f0103552:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103558:	50                   	push   %eax
f0103559:	68 fc 03 00 00       	push   $0x3fc
f010355e:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103564:	50                   	push   %eax
f0103565:	e8 1e cc ff ff       	call   f0100188 <_panic>
f010356a:	50                   	push   %eax
f010356b:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f0103571:	50                   	push   %eax
f0103572:	6a 56                	push   $0x56
f0103574:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f010357a:	50                   	push   %eax
f010357b:	e8 08 cc ff ff       	call   f0100188 <_panic>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0103580:	8d 83 5c a5 f7 ff    	lea    -0x85aa4(%ebx),%eax
f0103586:	50                   	push   %eax
f0103587:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f010358d:	50                   	push   %eax
f010358e:	68 fe 03 00 00       	push   $0x3fe
f0103593:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f0103599:	50                   	push   %eax
f010359a:	e8 e9 cb ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f010359f:	8d 83 50 a8 f7 ff    	lea    -0x857b0(%ebx),%eax
f01035a5:	50                   	push   %eax
f01035a6:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01035ac:	50                   	push   %eax
f01035ad:	68 00 04 00 00       	push   $0x400
f01035b2:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01035b8:	50                   	push   %eax
f01035b9:	e8 ca cb ff ff       	call   f0100188 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01035be:	8d 83 18 9d f7 ff    	lea    -0x862e8(%ebx),%eax
f01035c4:	50                   	push   %eax
f01035c5:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01035cb:	50                   	push   %eax
f01035cc:	68 03 04 00 00       	push   $0x403
f01035d1:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01035d7:	50                   	push   %eax
f01035d8:	e8 ab cb ff ff       	call   f0100188 <_panic>
    assert(pp0->pp_ref == 1);
f01035dd:	8d 83 07 a8 f7 ff    	lea    -0x857f9(%ebx),%eax
f01035e3:	50                   	push   %eax
f01035e4:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f01035ea:	50                   	push   %eax
f01035eb:	68 05 04 00 00       	push   $0x405
f01035f0:	8d 83 c6 a5 f7 ff    	lea    -0x85a3a(%ebx),%eax
f01035f6:	50                   	push   %eax
f01035f7:	e8 8c cb ff ff       	call   f0100188 <_panic>

f01035fc <tlb_invalidate>:
tlb_invalidate(pde_t *pgdir, void *va) {
f01035fc:	55                   	push   %ebp
f01035fd:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01035ff:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103602:	0f 01 38             	invlpg (%eax)
}
f0103605:	5d                   	pop    %ebp
f0103606:	c3                   	ret    

f0103607 <__x86.get_pc_thunk.dx>:
f0103607:	8b 14 24             	mov    (%esp),%edx
f010360a:	c3                   	ret    

f010360b <__x86.get_pc_thunk.cx>:
f010360b:	8b 0c 24             	mov    (%esp),%ecx
f010360e:	c3                   	ret    

f010360f <__x86.get_pc_thunk.di>:
f010360f:	8b 3c 24             	mov    (%esp),%edi
f0103612:	c3                   	ret    

f0103613 <envid2env>:
//   0 on success, -E_BAD_ENV on error.
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
f0103613:	55                   	push   %ebp
f0103614:	89 e5                	mov    %esp,%ebp
f0103616:	53                   	push   %ebx
f0103617:	e8 ef ff ff ff       	call   f010360b <__x86.get_pc_thunk.cx>
f010361c:	81 c1 04 8a 08 00    	add    $0x88a04,%ecx
f0103622:	8b 55 08             	mov    0x8(%ebp),%edx
f0103625:	8b 5d 10             	mov    0x10(%ebp),%ebx
    struct Env *e;

    // If envid is zero, return the current environment.
    if (envid == 0) {
f0103628:	85 d2                	test   %edx,%edx
f010362a:	74 41                	je     f010366d <envid2env+0x5a>
    // Look up the Env structure via the index part of the envid,
    // then check the env_id field in that struct Env
    // to ensure that the envid is not stale
    // (i.e., does not refer to a _previous_ environment
    // that used the same slot in the envs[] array).
    e = &envs[ENVX(envid)];
f010362c:	89 d0                	mov    %edx,%eax
f010362e:	25 ff 03 00 00       	and    $0x3ff,%eax
f0103633:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0103636:	c1 e0 05             	shl    $0x5,%eax
f0103639:	03 81 2c 23 00 00    	add    0x232c(%ecx),%eax
    if (e->env_status == ENV_FREE || e->env_id != envid) {
f010363f:	83 78 54 00          	cmpl   $0x0,0x54(%eax)
f0103643:	74 3a                	je     f010367f <envid2env+0x6c>
f0103645:	39 50 48             	cmp    %edx,0x48(%eax)
f0103648:	75 35                	jne    f010367f <envid2env+0x6c>
    // Check that the calling environment has legitimate permission
    // to manipulate the specified environment.
    // If checkperm is set, the specified environment
    // must be either the current environment
    // or an immediate child of the current environment.
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010364a:	84 db                	test   %bl,%bl
f010364c:	74 12                	je     f0103660 <envid2env+0x4d>
f010364e:	8b 91 28 23 00 00    	mov    0x2328(%ecx),%edx
f0103654:	39 c2                	cmp    %eax,%edx
f0103656:	74 08                	je     f0103660 <envid2env+0x4d>
f0103658:	8b 5a 48             	mov    0x48(%edx),%ebx
f010365b:	39 58 4c             	cmp    %ebx,0x4c(%eax)
f010365e:	75 2f                	jne    f010368f <envid2env+0x7c>
        *env_store = 0;
        return -E_BAD_ENV;
    }

    *env_store = e;
f0103660:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103663:	89 03                	mov    %eax,(%ebx)
    return 0;
f0103665:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010366a:	5b                   	pop    %ebx
f010366b:	5d                   	pop    %ebp
f010366c:	c3                   	ret    
        *env_store = curenv;
f010366d:	8b 81 28 23 00 00    	mov    0x2328(%ecx),%eax
f0103673:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103676:	89 01                	mov    %eax,(%ecx)
        return 0;
f0103678:	b8 00 00 00 00       	mov    $0x0,%eax
f010367d:	eb eb                	jmp    f010366a <envid2env+0x57>
        *env_store = 0;
f010367f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f0103688:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010368d:	eb db                	jmp    f010366a <envid2env+0x57>
        *env_store = 0;
f010368f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f0103698:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010369d:	eb cb                	jmp    f010366a <envid2env+0x57>

f010369f <env_init_percpu>:
    env_init_percpu();
}

// Load GDT and segment descriptors.
void
env_init_percpu(void) {
f010369f:	55                   	push   %ebp
f01036a0:	89 e5                	mov    %esp,%ebp
f01036a2:	e8 39 d1 ff ff       	call   f01007e0 <__x86.get_pc_thunk.ax>
f01036a7:	05 79 89 08 00       	add    $0x88979,%eax
	asm volatile("lgdt (%0)" : : "r" (p));
f01036ac:	8d 80 e0 1f 00 00    	lea    0x1fe0(%eax),%eax
f01036b2:	0f 01 10             	lgdtl  (%eax)
    lgdt(&gdt_pd);
    // The kernel never uses GS or FS, so we leave those set to
    // the user data segment.
    asm volatile("movw %%ax,%%gs" : : "a" (GD_UD | 3));
f01036b5:	b8 23 00 00 00       	mov    $0x23,%eax
f01036ba:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax,%%fs" : : "a" (GD_UD | 3));
f01036bc:	8e e0                	mov    %eax,%fs
    // The kernel does use ES, DS, and SS.  We'll change between
    // the kernel and user data segments as needed.
    asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01036be:	b8 10 00 00 00       	mov    $0x10,%eax
f01036c3:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01036c5:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01036c7:	8e d0                	mov    %eax,%ss
    // Load the kernel text segment into CS.
    asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01036c9:	ea d0 36 10 f0 08 00 	ljmp   $0x8,$0xf01036d0
	asm volatile("lldt %0" : : "r" (sel));
f01036d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01036d5:	0f 00 d0             	lldt   %ax
    // For good measure, clear the local descriptor table (LDT),
    // since we don't use it.
    lldt(0);
}
f01036d8:	5d                   	pop    %ebp
f01036d9:	c3                   	ret    

f01036da <env_init>:
env_init(void) {
f01036da:	55                   	push   %ebp
f01036db:	89 e5                	mov    %esp,%ebp
f01036dd:	57                   	push   %edi
f01036de:	56                   	push   %esi
f01036df:	53                   	push   %ebx
f01036e0:	e8 2a ff ff ff       	call   f010360f <__x86.get_pc_thunk.di>
f01036e5:	81 c7 3b 89 08 00    	add    $0x8893b,%edi
        envs[i].env_link = env_free_list;
f01036eb:	8b b7 2c 23 00 00    	mov    0x232c(%edi),%esi
f01036f1:	8b 97 30 23 00 00    	mov    0x2330(%edi),%edx
f01036f7:	89 f0                	mov    %esi,%eax
f01036f9:	8d 9e 00 80 01 00    	lea    0x18000(%esi),%ebx
f01036ff:	89 c1                	mov    %eax,%ecx
f0103701:	89 50 44             	mov    %edx,0x44(%eax)
f0103704:	83 c0 60             	add    $0x60,%eax
        env_free_list = &envs[i];
f0103707:	89 ca                	mov    %ecx,%edx
    for (i = 0; i < NENV; i++) {
f0103709:	39 d8                	cmp    %ebx,%eax
f010370b:	75 f2                	jne    f01036ff <env_init+0x25>
f010370d:	81 c6 a0 7f 01 00    	add    $0x17fa0,%esi
f0103713:	89 b7 30 23 00 00    	mov    %esi,0x2330(%edi)
    env_init_percpu();
f0103719:	e8 81 ff ff ff       	call   f010369f <env_init_percpu>
}
f010371e:	5b                   	pop    %ebx
f010371f:	5e                   	pop    %esi
f0103720:	5f                   	pop    %edi
f0103721:	5d                   	pop    %ebp
f0103722:	c3                   	ret    

f0103723 <env_alloc>:
// Returns 0 on success, < 0 on failure.  Errors include:
//	-E_NO_FREE_ENV if all NENV environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id) {
f0103723:	55                   	push   %ebp
f0103724:	89 e5                	mov    %esp,%ebp
f0103726:	56                   	push   %esi
f0103727:	53                   	push   %ebx
f0103728:	e8 11 cb ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010372d:	81 c3 f3 88 08 00    	add    $0x888f3,%ebx
    int32_t generation;
    int r;
    struct Env *e;

    if (!(e = env_free_list))
f0103733:	8b b3 30 23 00 00    	mov    0x2330(%ebx),%esi
f0103739:	85 f6                	test   %esi,%esi
f010373b:	0f 84 03 01 00 00    	je     f0103844 <env_alloc+0x121>
    if (!(p = page_alloc(ALLOC_ZERO)))
f0103741:	83 ec 0c             	sub    $0xc,%esp
f0103744:	6a 01                	push   $0x1
f0103746:	e8 81 da ff ff       	call   f01011cc <page_alloc>
f010374b:	83 c4 10             	add    $0x10,%esp
f010374e:	85 c0                	test   %eax,%eax
f0103750:	0f 84 f5 00 00 00    	je     f010384b <env_alloc+0x128>
    e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103756:	8b 46 5c             	mov    0x5c(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103759:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010375e:	0f 86 c7 00 00 00    	jbe    f010382b <env_alloc+0x108>
	return (physaddr_t)kva - KERNBASE;
f0103764:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010376a:	83 ca 05             	or     $0x5,%edx
f010376d:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
    // Allocate and set up the page directory for this environment.
    if ((r = env_setup_vm(e)) < 0)
        return r;

    // Generate an env_id for this environment.
    generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103773:	8b 46 48             	mov    0x48(%esi),%eax
f0103776:	05 00 10 00 00       	add    $0x1000,%eax
    if (generation <= 0)    // Don't create a negative env_id.
f010377b:	25 00 fc ff ff       	and    $0xfffffc00,%eax
        generation = 1 << ENVGENSHIFT;
f0103780:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103785:	0f 4e c2             	cmovle %edx,%eax
    e->env_id = generation | (e - envs);
f0103788:	89 f2                	mov    %esi,%edx
f010378a:	2b 93 2c 23 00 00    	sub    0x232c(%ebx),%edx
f0103790:	c1 fa 05             	sar    $0x5,%edx
f0103793:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0103799:	09 d0                	or     %edx,%eax
f010379b:	89 46 48             	mov    %eax,0x48(%esi)

    // Set the basic status variables.
    e->env_parent_id = parent_id;
f010379e:	8b 45 0c             	mov    0xc(%ebp),%eax
f01037a1:	89 46 4c             	mov    %eax,0x4c(%esi)
    e->env_type = ENV_TYPE_USER;
f01037a4:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
    e->env_status = ENV_RUNNABLE;
f01037ab:	c7 46 54 02 00 00 00 	movl   $0x2,0x54(%esi)
    e->env_runs = 0;
f01037b2:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)

    // Clear out all the saved register state,
    // to prevent the register values
    // of a prior environment inhabiting this Env structure
    // from "leaking" into our new environment.
    memset(&e->env_tf, 0, sizeof(e->env_tf));
f01037b9:	83 ec 04             	sub    $0x4,%esp
f01037bc:	6a 44                	push   $0x44
f01037be:	6a 00                	push   $0x0
f01037c0:	56                   	push   %esi
f01037c1:	e8 d2 14 00 00       	call   f0104c98 <memset>
    // The low 2 bits of each segment register contains the
    // Requestor Privilege Level (RPL); 3 means user mode.  When
    // we switch privilege levels, the hardware does various
    // checks involving the RPL and the Descriptor Privilege Level
    // (DPL) stored in the descriptors themselves.
    e->env_tf.tf_ds = GD_UD | 3;
f01037c6:	66 c7 46 24 23 00    	movw   $0x23,0x24(%esi)
    e->env_tf.tf_es = GD_UD | 3;
f01037cc:	66 c7 46 20 23 00    	movw   $0x23,0x20(%esi)
    e->env_tf.tf_ss = GD_UD | 3;
f01037d2:	66 c7 46 40 23 00    	movw   $0x23,0x40(%esi)
    e->env_tf.tf_esp = USTACKTOP;
f01037d8:	c7 46 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%esi)
    e->env_tf.tf_cs = GD_UT | 3;
f01037df:	66 c7 46 34 1b 00    	movw   $0x1b,0x34(%esi)
    // You will set e->env_tf.tf_eip later.

    // commit the allocation
    env_free_list = e->env_link;
f01037e5:	8b 46 44             	mov    0x44(%esi),%eax
f01037e8:	89 83 30 23 00 00    	mov    %eax,0x2330(%ebx)
    *newenv_store = e;
f01037ee:	8b 45 08             	mov    0x8(%ebp),%eax
f01037f1:	89 30                	mov    %esi,(%eax)

    cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01037f3:	8b 4e 48             	mov    0x48(%esi),%ecx
f01037f6:	8b 83 28 23 00 00    	mov    0x2328(%ebx),%eax
f01037fc:	83 c4 10             	add    $0x10,%esp
f01037ff:	ba 00 00 00 00       	mov    $0x0,%edx
f0103804:	85 c0                	test   %eax,%eax
f0103806:	74 03                	je     f010380b <env_alloc+0xe8>
f0103808:	8b 50 48             	mov    0x48(%eax),%edx
f010380b:	83 ec 04             	sub    $0x4,%esp
f010380e:	51                   	push   %ecx
f010380f:	52                   	push   %edx
f0103810:	8d 83 61 a9 f7 ff    	lea    -0x8569f(%ebx),%eax
f0103816:	50                   	push   %eax
f0103817:	e8 61 03 00 00       	call   f0103b7d <cprintf>
    return 0;
f010381c:	83 c4 10             	add    $0x10,%esp
f010381f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103824:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103827:	5b                   	pop    %ebx
f0103828:	5e                   	pop    %esi
f0103829:	5d                   	pop    %ebp
f010382a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010382b:	50                   	push   %eax
f010382c:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0103832:	50                   	push   %eax
f0103833:	68 bd 00 00 00       	push   $0xbd
f0103838:	8d 83 56 a9 f7 ff    	lea    -0x856aa(%ebx),%eax
f010383e:	50                   	push   %eax
f010383f:	e8 44 c9 ff ff       	call   f0100188 <_panic>
        return -E_NO_FREE_ENV;
f0103844:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103849:	eb d9                	jmp    f0103824 <env_alloc+0x101>
        return -E_NO_MEM;
f010384b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103850:	eb d2                	jmp    f0103824 <env_alloc+0x101>

f0103852 <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type) {
f0103852:	55                   	push   %ebp
f0103853:	89 e5                	mov    %esp,%ebp
    // LAB 3: Your code here.
}
f0103855:	5d                   	pop    %ebp
f0103856:	c3                   	ret    

f0103857 <env_free>:

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
f0103857:	55                   	push   %ebp
f0103858:	89 e5                	mov    %esp,%ebp
f010385a:	57                   	push   %edi
f010385b:	56                   	push   %esi
f010385c:	53                   	push   %ebx
f010385d:	83 ec 2c             	sub    $0x2c,%esp
f0103860:	e8 d9 c9 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103865:	81 c3 bb 87 08 00    	add    $0x887bb,%ebx
    physaddr_t pa;

    // If freeing the current environment, switch to kern_pgdir
    // before freeing the page directory, just in case the page
    // gets reused.
    if (e == curenv)
f010386b:	8b 93 28 23 00 00    	mov    0x2328(%ebx),%edx
f0103871:	3b 55 08             	cmp    0x8(%ebp),%edx
f0103874:	75 17                	jne    f010388d <env_free+0x36>
        lcr3(PADDR(kern_pgdir));
f0103876:	c7 c0 0c f0 18 f0    	mov    $0xf018f00c,%eax
f010387c:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010387e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103883:	76 46                	jbe    f01038cb <env_free+0x74>
	return (physaddr_t)kva - KERNBASE;
f0103885:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010388a:	0f 22 d8             	mov    %eax,%cr3

    // Note the environment's demise.
    cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010388d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103890:	8b 48 48             	mov    0x48(%eax),%ecx
f0103893:	b8 00 00 00 00       	mov    $0x0,%eax
f0103898:	85 d2                	test   %edx,%edx
f010389a:	74 03                	je     f010389f <env_free+0x48>
f010389c:	8b 42 48             	mov    0x48(%edx),%eax
f010389f:	83 ec 04             	sub    $0x4,%esp
f01038a2:	51                   	push   %ecx
f01038a3:	50                   	push   %eax
f01038a4:	8d 83 76 a9 f7 ff    	lea    -0x8568a(%ebx),%eax
f01038aa:	50                   	push   %eax
f01038ab:	e8 cd 02 00 00       	call   f0103b7d <cprintf>
f01038b0:	83 c4 10             	add    $0x10,%esp
f01038b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	if (PGNUM(pa) >= npages)
f01038ba:	c7 c0 08 f0 18 f0    	mov    $0xf018f008,%eax
f01038c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (PGNUM(pa) >= npages)
f01038c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01038c6:	e9 9f 00 00 00       	jmp    f010396a <env_free+0x113>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038cb:	50                   	push   %eax
f01038cc:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f01038d2:	50                   	push   %eax
f01038d3:	68 67 01 00 00       	push   $0x167
f01038d8:	8d 83 56 a9 f7 ff    	lea    -0x856aa(%ebx),%eax
f01038de:	50                   	push   %eax
f01038df:	e8 a4 c8 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01038e4:	50                   	push   %eax
f01038e5:	8d 83 40 98 f7 ff    	lea    -0x867c0(%ebx),%eax
f01038eb:	50                   	push   %eax
f01038ec:	68 76 01 00 00       	push   $0x176
f01038f1:	8d 83 56 a9 f7 ff    	lea    -0x856aa(%ebx),%eax
f01038f7:	50                   	push   %eax
f01038f8:	e8 8b c8 ff ff       	call   f0100188 <_panic>
f01038fd:	83 c6 04             	add    $0x4,%esi
        // find the pa and va of the page table
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
        pt = (pte_t *) KADDR(pa);

        // unmap all PTEs in this page table
        for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103900:	39 fe                	cmp    %edi,%esi
f0103902:	74 24                	je     f0103928 <env_free+0xd1>
            if (pt[pteno] & PTE_P)
f0103904:	f6 06 01             	testb  $0x1,(%esi)
f0103907:	74 f4                	je     f01038fd <env_free+0xa6>
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103909:	83 ec 08             	sub    $0x8,%esp
f010390c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010390f:	01 f0                	add    %esi,%eax
f0103911:	c1 e0 0a             	shl    $0xa,%eax
f0103914:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103917:	50                   	push   %eax
f0103918:	8b 45 08             	mov    0x8(%ebp),%eax
f010391b:	ff 70 5c             	pushl  0x5c(%eax)
f010391e:	e8 32 db ff ff       	call   f0101455 <page_remove>
f0103923:	83 c4 10             	add    $0x10,%esp
f0103926:	eb d5                	jmp    f01038fd <env_free+0xa6>
        }

        // free the page table itself
        e->env_pgdir[pdeno] = 0;
f0103928:	8b 45 08             	mov    0x8(%ebp),%eax
f010392b:	8b 40 5c             	mov    0x5c(%eax),%eax
f010392e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103931:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103938:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010393b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010393e:	3b 10                	cmp    (%eax),%edx
f0103940:	73 6f                	jae    f01039b1 <env_free+0x15a>
        page_decref(pa2page(pa));
f0103942:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103945:	c7 c0 10 f0 18 f0    	mov    $0xf018f010,%eax
f010394b:	8b 00                	mov    (%eax),%eax
f010394d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103950:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103953:	50                   	push   %eax
f0103954:	e8 73 d9 ff ff       	call   f01012cc <page_decref>
f0103959:	83 c4 10             	add    $0x10,%esp
f010395c:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f0103960:	8b 45 dc             	mov    -0x24(%ebp),%eax
    for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103963:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103968:	74 5f                	je     f01039c9 <env_free+0x172>
        if (!(e->env_pgdir[pdeno] & PTE_P))
f010396a:	8b 45 08             	mov    0x8(%ebp),%eax
f010396d:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103970:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103973:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103976:	a8 01                	test   $0x1,%al
f0103978:	74 e2                	je     f010395c <env_free+0x105>
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010397a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010397f:	89 c2                	mov    %eax,%edx
f0103981:	c1 ea 0c             	shr    $0xc,%edx
f0103984:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0103987:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010398a:	39 11                	cmp    %edx,(%ecx)
f010398c:	0f 86 52 ff ff ff    	jbe    f01038e4 <env_free+0x8d>
	return (void *)(pa + KERNBASE);
f0103992:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103998:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010399b:	c1 e2 14             	shl    $0x14,%edx
f010399e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01039a1:	8d b8 00 10 00 f0    	lea    -0xffff000(%eax),%edi
f01039a7:	f7 d8                	neg    %eax
f01039a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01039ac:	e9 53 ff ff ff       	jmp    f0103904 <env_free+0xad>
		panic("pa2page called with invalid pa");
f01039b1:	83 ec 04             	sub    $0x4,%esp
f01039b4:	8d 83 3c 9a f7 ff    	lea    -0x865c4(%ebx),%eax
f01039ba:	50                   	push   %eax
f01039bb:	6a 4f                	push   $0x4f
f01039bd:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f01039c3:	50                   	push   %eax
f01039c4:	e8 bf c7 ff ff       	call   f0100188 <_panic>
    }

    // free the page directory
    pa = PADDR(e->env_pgdir);
f01039c9:	8b 45 08             	mov    0x8(%ebp),%eax
f01039cc:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01039cf:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039d4:	76 57                	jbe    f0103a2d <env_free+0x1d6>
    e->env_pgdir = 0;
f01039d6:	8b 55 08             	mov    0x8(%ebp),%edx
f01039d9:	c7 42 5c 00 00 00 00 	movl   $0x0,0x5c(%edx)
	return (physaddr_t)kva - KERNBASE;
f01039e0:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01039e5:	c1 e8 0c             	shr    $0xc,%eax
f01039e8:	c7 c2 08 f0 18 f0    	mov    $0xf018f008,%edx
f01039ee:	3b 02                	cmp    (%edx),%eax
f01039f0:	73 54                	jae    f0103a46 <env_free+0x1ef>
    page_decref(pa2page(pa));
f01039f2:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01039f5:	c7 c2 10 f0 18 f0    	mov    $0xf018f010,%edx
f01039fb:	8b 12                	mov    (%edx),%edx
f01039fd:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103a00:	50                   	push   %eax
f0103a01:	e8 c6 d8 ff ff       	call   f01012cc <page_decref>

    // return the environment to the free list
    e->env_status = ENV_FREE;
f0103a06:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a09:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
    e->env_link = env_free_list;
f0103a10:	8b 83 30 23 00 00    	mov    0x2330(%ebx),%eax
f0103a16:	8b 55 08             	mov    0x8(%ebp),%edx
f0103a19:	89 42 44             	mov    %eax,0x44(%edx)
    env_free_list = e;
f0103a1c:	89 93 30 23 00 00    	mov    %edx,0x2330(%ebx)
}
f0103a22:	83 c4 10             	add    $0x10,%esp
f0103a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a28:	5b                   	pop    %ebx
f0103a29:	5e                   	pop    %esi
f0103a2a:	5f                   	pop    %edi
f0103a2b:	5d                   	pop    %ebp
f0103a2c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a2d:	50                   	push   %eax
f0103a2e:	8d 83 e4 99 f7 ff    	lea    -0x8661c(%ebx),%eax
f0103a34:	50                   	push   %eax
f0103a35:	68 84 01 00 00       	push   $0x184
f0103a3a:	8d 83 56 a9 f7 ff    	lea    -0x856aa(%ebx),%eax
f0103a40:	50                   	push   %eax
f0103a41:	e8 42 c7 ff ff       	call   f0100188 <_panic>
		panic("pa2page called with invalid pa");
f0103a46:	83 ec 04             	sub    $0x4,%esp
f0103a49:	8d 83 3c 9a f7 ff    	lea    -0x865c4(%ebx),%eax
f0103a4f:	50                   	push   %eax
f0103a50:	6a 4f                	push   $0x4f
f0103a52:	8d 83 d2 a5 f7 ff    	lea    -0x85a2e(%ebx),%eax
f0103a58:	50                   	push   %eax
f0103a59:	e8 2a c7 ff ff       	call   f0100188 <_panic>

f0103a5e <env_destroy>:

//
// Frees environment e.
//
void
env_destroy(struct Env *e) {
f0103a5e:	55                   	push   %ebp
f0103a5f:	89 e5                	mov    %esp,%ebp
f0103a61:	53                   	push   %ebx
f0103a62:	83 ec 10             	sub    $0x10,%esp
f0103a65:	e8 d4 c7 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103a6a:	81 c3 b6 85 08 00    	add    $0x885b6,%ebx
    env_free(e);
f0103a70:	ff 75 08             	pushl  0x8(%ebp)
f0103a73:	e8 df fd ff ff       	call   f0103857 <env_free>

    cprintf("Destroyed the only environment - nothing more to do!\n");
f0103a78:	8d 83 20 a9 f7 ff    	lea    -0x856e0(%ebx),%eax
f0103a7e:	89 04 24             	mov    %eax,(%esp)
f0103a81:	e8 f7 00 00 00       	call   f0103b7d <cprintf>
f0103a86:	83 c4 10             	add    $0x10,%esp
    while (1)
        monitor(NULL);
f0103a89:	83 ec 0c             	sub    $0xc,%esp
f0103a8c:	6a 00                	push   $0x0
f0103a8e:	e8 0d cf ff ff       	call   f01009a0 <monitor>
f0103a93:	83 c4 10             	add    $0x10,%esp
f0103a96:	eb f1                	jmp    f0103a89 <env_destroy+0x2b>

f0103a98 <env_pop_tf>:
// this exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
f0103a98:	55                   	push   %ebp
f0103a99:	89 e5                	mov    %esp,%ebp
f0103a9b:	53                   	push   %ebx
f0103a9c:	83 ec 08             	sub    $0x8,%esp
f0103a9f:	e8 9a c7 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103aa4:	81 c3 7c 85 08 00    	add    $0x8857c,%ebx
    asm volatile(
f0103aaa:	8b 65 08             	mov    0x8(%ebp),%esp
f0103aad:	61                   	popa   
f0103aae:	07                   	pop    %es
f0103aaf:	1f                   	pop    %ds
f0103ab0:	83 c4 08             	add    $0x8,%esp
f0103ab3:	cf                   	iret   
    "\tpopl %%es\n"
    "\tpopl %%ds\n"
    "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
    "\tiret\n"
    : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
f0103ab4:	8d 83 8c a9 f7 ff    	lea    -0x85674(%ebx),%eax
f0103aba:	50                   	push   %eax
f0103abb:	68 ab 01 00 00       	push   $0x1ab
f0103ac0:	8d 83 56 a9 f7 ff    	lea    -0x856aa(%ebx),%eax
f0103ac6:	50                   	push   %eax
f0103ac7:	e8 bc c6 ff ff       	call   f0100188 <_panic>

f0103acc <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
f0103acc:	55                   	push   %ebp
f0103acd:	89 e5                	mov    %esp,%ebp
f0103acf:	53                   	push   %ebx
f0103ad0:	83 ec 08             	sub    $0x8,%esp
f0103ad3:	e8 66 c7 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103ad8:	81 c3 48 85 08 00    	add    $0x88548,%ebx
    //	and make sure you have set the relevant parts of
    //	e->env_tf to sensible values.

    // LAB 3: Your code here.

    panic("env_run not yet implemented");
f0103ade:	8d 83 98 a9 f7 ff    	lea    -0x85668(%ebx),%eax
f0103ae4:	50                   	push   %eax
f0103ae5:	68 c9 01 00 00       	push   $0x1c9
f0103aea:	8d 83 56 a9 f7 ff    	lea    -0x856aa(%ebx),%eax
f0103af0:	50                   	push   %eax
f0103af1:	e8 92 c6 ff ff       	call   f0100188 <_panic>

f0103af6 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103af6:	55                   	push   %ebp
f0103af7:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103af9:	8b 45 08             	mov    0x8(%ebp),%eax
f0103afc:	ba 70 00 00 00       	mov    $0x70,%edx
f0103b01:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103b02:	ba 71 00 00 00       	mov    $0x71,%edx
f0103b07:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103b08:	0f b6 c0             	movzbl %al,%eax
}
f0103b0b:	5d                   	pop    %ebp
f0103b0c:	c3                   	ret    

f0103b0d <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103b0d:	55                   	push   %ebp
f0103b0e:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103b10:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b13:	ba 70 00 00 00       	mov    $0x70,%edx
f0103b18:	ee                   	out    %al,(%dx)
f0103b19:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b1c:	ba 71 00 00 00       	mov    $0x71,%edx
f0103b21:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103b22:	5d                   	pop    %ebp
f0103b23:	c3                   	ret    

f0103b24 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103b24:	55                   	push   %ebp
f0103b25:	89 e5                	mov    %esp,%ebp
f0103b27:	53                   	push   %ebx
f0103b28:	83 ec 10             	sub    $0x10,%esp
f0103b2b:	e8 0e c7 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103b30:	81 c3 f0 84 08 00    	add    $0x884f0,%ebx
	cputchar(ch);
f0103b36:	ff 75 08             	pushl  0x8(%ebp)
f0103b39:	e8 77 cc ff ff       	call   f01007b5 <cputchar>
    //这里会有bug！
	*cnt++;
}
f0103b3e:	83 c4 10             	add    $0x10,%esp
f0103b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b44:	c9                   	leave  
f0103b45:	c3                   	ret    

f0103b46 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103b46:	55                   	push   %ebp
f0103b47:	89 e5                	mov    %esp,%ebp
f0103b49:	53                   	push   %ebx
f0103b4a:	83 ec 14             	sub    $0x14,%esp
f0103b4d:	e8 ec c6 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103b52:	81 c3 ce 84 08 00    	add    $0x884ce,%ebx
	int cnt = 0;
f0103b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103b5f:	ff 75 0c             	pushl  0xc(%ebp)
f0103b62:	ff 75 08             	pushl  0x8(%ebp)
f0103b65:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103b68:	50                   	push   %eax
f0103b69:	8d 83 04 7b f7 ff    	lea    -0x884fc(%ebx),%eax
f0103b6f:	50                   	push   %eax
f0103b70:	e8 6a 09 00 00       	call   f01044df <vprintfmt>
	return cnt;
}
f0103b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103b78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b7b:	c9                   	leave  
f0103b7c:	c3                   	ret    

f0103b7d <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103b7d:	55                   	push   %ebp
f0103b7e:	89 e5                	mov    %esp,%ebp
f0103b80:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103b83:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103b86:	50                   	push   %eax
f0103b87:	ff 75 08             	pushl  0x8(%ebp)
f0103b8a:	e8 b7 ff ff ff       	call   f0103b46 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103b8f:	c9                   	leave  
f0103b90:	c3                   	ret    

f0103b91 <memCprintf>:

//不能重载？？
int memCprintf(const char *name, uintptr_t va, uint32_t pd_item, physaddr_t pa, uint32_t map_page){
f0103b91:	55                   	push   %ebp
f0103b92:	89 e5                	mov    %esp,%ebp
f0103b94:	83 ec 10             	sub    $0x10,%esp
f0103b97:	e8 44 cc ff ff       	call   f01007e0 <__x86.get_pc_thunk.ax>
f0103b9c:	05 84 84 08 00       	add    $0x88484,%eax
    return cprintf("名称:%s\t虚拟地址:0x%x\t页目录项:0x%x\t物理地址:0x%x\t物理页:0x%x\n", name, va, pd_item, pa, map_page);
f0103ba1:	ff 75 18             	pushl  0x18(%ebp)
f0103ba4:	ff 75 14             	pushl  0x14(%ebp)
f0103ba7:	ff 75 10             	pushl  0x10(%ebp)
f0103baa:	ff 75 0c             	pushl  0xc(%ebp)
f0103bad:	ff 75 08             	pushl  0x8(%ebp)
f0103bb0:	8d 80 b4 a9 f7 ff    	lea    -0x8564c(%eax),%eax
f0103bb6:	50                   	push   %eax
f0103bb7:	e8 c1 ff ff ff       	call   f0103b7d <cprintf>
}
f0103bbc:	c9                   	leave  
f0103bbd:	c3                   	ret    

f0103bbe <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103bbe:	55                   	push   %ebp
f0103bbf:	89 e5                	mov    %esp,%ebp
f0103bc1:	57                   	push   %edi
f0103bc2:	56                   	push   %esi
f0103bc3:	53                   	push   %ebx
f0103bc4:	83 ec 04             	sub    $0x4,%esp
f0103bc7:	e8 72 c6 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103bcc:	81 c3 54 84 08 00    	add    $0x88454,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0103bd2:	c7 83 64 2b 00 00 00 	movl   $0xf0000000,0x2b64(%ebx)
f0103bd9:	00 00 f0 
	ts.ts_ss0 = GD_KD;
f0103bdc:	66 c7 83 68 2b 00 00 	movw   $0x10,0x2b68(%ebx)
f0103be3:	10 00 
	ts.ts_iomb = sizeof(struct Taskstate);
f0103be5:	66 c7 83 c6 2b 00 00 	movw   $0x68,0x2bc6(%ebx)
f0103bec:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103bee:	c7 c0 00 b3 11 f0    	mov    $0xf011b300,%eax
f0103bf4:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
f0103bfa:	8d b3 60 2b 00 00    	lea    0x2b60(%ebx),%esi
f0103c00:	66 89 70 2a          	mov    %si,0x2a(%eax)
f0103c04:	89 f2                	mov    %esi,%edx
f0103c06:	c1 ea 10             	shr    $0x10,%edx
f0103c09:	88 50 2c             	mov    %dl,0x2c(%eax)
f0103c0c:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f0103c10:	83 e2 f0             	and    $0xfffffff0,%edx
f0103c13:	83 ca 09             	or     $0x9,%edx
f0103c16:	83 e2 9f             	and    $0xffffff9f,%edx
f0103c19:	83 ca 80             	or     $0xffffff80,%edx
f0103c1c:	88 55 f3             	mov    %dl,-0xd(%ebp)
f0103c1f:	88 50 2d             	mov    %dl,0x2d(%eax)
f0103c22:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
f0103c26:	83 e1 c0             	and    $0xffffffc0,%ecx
f0103c29:	83 c9 40             	or     $0x40,%ecx
f0103c2c:	83 e1 7f             	and    $0x7f,%ecx
f0103c2f:	88 48 2e             	mov    %cl,0x2e(%eax)
f0103c32:	c1 ee 18             	shr    $0x18,%esi
f0103c35:	89 f1                	mov    %esi,%ecx
f0103c37:	88 48 2f             	mov    %cl,0x2f(%eax)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
f0103c3a:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
f0103c3e:	83 e2 ef             	and    $0xffffffef,%edx
f0103c41:	88 50 2d             	mov    %dl,0x2d(%eax)
	asm volatile("ltr %0" : : "r" (sel));
f0103c44:	b8 28 00 00 00       	mov    $0x28,%eax
f0103c49:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103c4c:	8d 83 e8 1f 00 00    	lea    0x1fe8(%ebx),%eax
f0103c52:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}
f0103c55:	83 c4 04             	add    $0x4,%esp
f0103c58:	5b                   	pop    %ebx
f0103c59:	5e                   	pop    %esi
f0103c5a:	5f                   	pop    %edi
f0103c5b:	5d                   	pop    %ebp
f0103c5c:	c3                   	ret    

f0103c5d <trap_init>:
{
f0103c5d:	55                   	push   %ebp
f0103c5e:	89 e5                	mov    %esp,%ebp
	trap_init_percpu();
f0103c60:	e8 59 ff ff ff       	call   f0103bbe <trap_init_percpu>
}
f0103c65:	5d                   	pop    %ebp
f0103c66:	c3                   	ret    

f0103c67 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103c67:	55                   	push   %ebp
f0103c68:	89 e5                	mov    %esp,%ebp
f0103c6a:	56                   	push   %esi
f0103c6b:	53                   	push   %ebx
f0103c6c:	e8 cd c5 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103c71:	81 c3 af 83 08 00    	add    $0x883af,%ebx
f0103c77:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103c7a:	83 ec 08             	sub    $0x8,%esp
f0103c7d:	ff 36                	pushl  (%esi)
f0103c7f:	8d 83 04 aa f7 ff    	lea    -0x855fc(%ebx),%eax
f0103c85:	50                   	push   %eax
f0103c86:	e8 f2 fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103c8b:	83 c4 08             	add    $0x8,%esp
f0103c8e:	ff 76 04             	pushl  0x4(%esi)
f0103c91:	8d 83 13 aa f7 ff    	lea    -0x855ed(%ebx),%eax
f0103c97:	50                   	push   %eax
f0103c98:	e8 e0 fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103c9d:	83 c4 08             	add    $0x8,%esp
f0103ca0:	ff 76 08             	pushl  0x8(%esi)
f0103ca3:	8d 83 22 aa f7 ff    	lea    -0x855de(%ebx),%eax
f0103ca9:	50                   	push   %eax
f0103caa:	e8 ce fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103caf:	83 c4 08             	add    $0x8,%esp
f0103cb2:	ff 76 0c             	pushl  0xc(%esi)
f0103cb5:	8d 83 31 aa f7 ff    	lea    -0x855cf(%ebx),%eax
f0103cbb:	50                   	push   %eax
f0103cbc:	e8 bc fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103cc1:	83 c4 08             	add    $0x8,%esp
f0103cc4:	ff 76 10             	pushl  0x10(%esi)
f0103cc7:	8d 83 40 aa f7 ff    	lea    -0x855c0(%ebx),%eax
f0103ccd:	50                   	push   %eax
f0103cce:	e8 aa fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103cd3:	83 c4 08             	add    $0x8,%esp
f0103cd6:	ff 76 14             	pushl  0x14(%esi)
f0103cd9:	8d 83 4f aa f7 ff    	lea    -0x855b1(%ebx),%eax
f0103cdf:	50                   	push   %eax
f0103ce0:	e8 98 fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103ce5:	83 c4 08             	add    $0x8,%esp
f0103ce8:	ff 76 18             	pushl  0x18(%esi)
f0103ceb:	8d 83 5e aa f7 ff    	lea    -0x855a2(%ebx),%eax
f0103cf1:	50                   	push   %eax
f0103cf2:	e8 86 fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103cf7:	83 c4 08             	add    $0x8,%esp
f0103cfa:	ff 76 1c             	pushl  0x1c(%esi)
f0103cfd:	8d 83 6d aa f7 ff    	lea    -0x85593(%ebx),%eax
f0103d03:	50                   	push   %eax
f0103d04:	e8 74 fe ff ff       	call   f0103b7d <cprintf>
}
f0103d09:	83 c4 10             	add    $0x10,%esp
f0103d0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d0f:	5b                   	pop    %ebx
f0103d10:	5e                   	pop    %esi
f0103d11:	5d                   	pop    %ebp
f0103d12:	c3                   	ret    

f0103d13 <print_trapframe>:
{
f0103d13:	55                   	push   %ebp
f0103d14:	89 e5                	mov    %esp,%ebp
f0103d16:	57                   	push   %edi
f0103d17:	56                   	push   %esi
f0103d18:	53                   	push   %ebx
f0103d19:	83 ec 14             	sub    $0x14,%esp
f0103d1c:	e8 1d c5 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103d21:	81 c3 ff 82 08 00    	add    $0x882ff,%ebx
f0103d27:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("TRAP frame at %p\n", tf);
f0103d2a:	56                   	push   %esi
f0103d2b:	8d 83 a3 ab f7 ff    	lea    -0x8545d(%ebx),%eax
f0103d31:	50                   	push   %eax
f0103d32:	e8 46 fe ff ff       	call   f0103b7d <cprintf>
	print_regs(&tf->tf_regs);
f0103d37:	89 34 24             	mov    %esi,(%esp)
f0103d3a:	e8 28 ff ff ff       	call   f0103c67 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103d3f:	83 c4 08             	add    $0x8,%esp
f0103d42:	0f b7 46 20          	movzwl 0x20(%esi),%eax
f0103d46:	50                   	push   %eax
f0103d47:	8d 83 be aa f7 ff    	lea    -0x85542(%ebx),%eax
f0103d4d:	50                   	push   %eax
f0103d4e:	e8 2a fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103d53:	83 c4 08             	add    $0x8,%esp
f0103d56:	0f b7 46 24          	movzwl 0x24(%esi),%eax
f0103d5a:	50                   	push   %eax
f0103d5b:	8d 83 d1 aa f7 ff    	lea    -0x8552f(%ebx),%eax
f0103d61:	50                   	push   %eax
f0103d62:	e8 16 fe ff ff       	call   f0103b7d <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103d67:	8b 56 28             	mov    0x28(%esi),%edx
	if (trapno < ARRAY_SIZE(excnames))
f0103d6a:	83 c4 10             	add    $0x10,%esp
f0103d6d:	83 fa 13             	cmp    $0x13,%edx
f0103d70:	0f 86 e9 00 00 00    	jbe    f0103e5f <print_trapframe+0x14c>
	return "(unknown trap)";
f0103d76:	83 fa 30             	cmp    $0x30,%edx
f0103d79:	8d 83 7c aa f7 ff    	lea    -0x85584(%ebx),%eax
f0103d7f:	8d 8b 88 aa f7 ff    	lea    -0x85578(%ebx),%ecx
f0103d85:	0f 45 c1             	cmovne %ecx,%eax
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103d88:	83 ec 04             	sub    $0x4,%esp
f0103d8b:	50                   	push   %eax
f0103d8c:	52                   	push   %edx
f0103d8d:	8d 83 e4 aa f7 ff    	lea    -0x8551c(%ebx),%eax
f0103d93:	50                   	push   %eax
f0103d94:	e8 e4 fd ff ff       	call   f0103b7d <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103d99:	83 c4 10             	add    $0x10,%esp
f0103d9c:	39 b3 40 2b 00 00    	cmp    %esi,0x2b40(%ebx)
f0103da2:	0f 84 c3 00 00 00    	je     f0103e6b <print_trapframe+0x158>
	cprintf("  err  0x%08x", tf->tf_err);
f0103da8:	83 ec 08             	sub    $0x8,%esp
f0103dab:	ff 76 2c             	pushl  0x2c(%esi)
f0103dae:	8d 83 05 ab f7 ff    	lea    -0x854fb(%ebx),%eax
f0103db4:	50                   	push   %eax
f0103db5:	e8 c3 fd ff ff       	call   f0103b7d <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103dba:	83 c4 10             	add    $0x10,%esp
f0103dbd:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f0103dc1:	0f 85 c9 00 00 00    	jne    f0103e90 <print_trapframe+0x17d>
			tf->tf_err & 1 ? "protection" : "not-present");
f0103dc7:	8b 46 2c             	mov    0x2c(%esi),%eax
		cprintf(" [%s, %s, %s]\n",
f0103dca:	89 c2                	mov    %eax,%edx
f0103dcc:	83 e2 01             	and    $0x1,%edx
f0103dcf:	8d 8b 97 aa f7 ff    	lea    -0x85569(%ebx),%ecx
f0103dd5:	8d 93 a2 aa f7 ff    	lea    -0x8555e(%ebx),%edx
f0103ddb:	0f 44 ca             	cmove  %edx,%ecx
f0103dde:	89 c2                	mov    %eax,%edx
f0103de0:	83 e2 02             	and    $0x2,%edx
f0103de3:	8d 93 ae aa f7 ff    	lea    -0x85552(%ebx),%edx
f0103de9:	8d bb b4 aa f7 ff    	lea    -0x8554c(%ebx),%edi
f0103def:	0f 44 d7             	cmove  %edi,%edx
f0103df2:	83 e0 04             	and    $0x4,%eax
f0103df5:	8d 83 b9 aa f7 ff    	lea    -0x85547(%ebx),%eax
f0103dfb:	8d bb ce ab f7 ff    	lea    -0x85432(%ebx),%edi
f0103e01:	0f 44 c7             	cmove  %edi,%eax
f0103e04:	51                   	push   %ecx
f0103e05:	52                   	push   %edx
f0103e06:	50                   	push   %eax
f0103e07:	8d 83 13 ab f7 ff    	lea    -0x854ed(%ebx),%eax
f0103e0d:	50                   	push   %eax
f0103e0e:	e8 6a fd ff ff       	call   f0103b7d <cprintf>
f0103e13:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103e16:	83 ec 08             	sub    $0x8,%esp
f0103e19:	ff 76 30             	pushl  0x30(%esi)
f0103e1c:	8d 83 22 ab f7 ff    	lea    -0x854de(%ebx),%eax
f0103e22:	50                   	push   %eax
f0103e23:	e8 55 fd ff ff       	call   f0103b7d <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103e28:	83 c4 08             	add    $0x8,%esp
f0103e2b:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103e2f:	50                   	push   %eax
f0103e30:	8d 83 31 ab f7 ff    	lea    -0x854cf(%ebx),%eax
f0103e36:	50                   	push   %eax
f0103e37:	e8 41 fd ff ff       	call   f0103b7d <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103e3c:	83 c4 08             	add    $0x8,%esp
f0103e3f:	ff 76 38             	pushl  0x38(%esi)
f0103e42:	8d 83 44 ab f7 ff    	lea    -0x854bc(%ebx),%eax
f0103e48:	50                   	push   %eax
f0103e49:	e8 2f fd ff ff       	call   f0103b7d <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103e4e:	83 c4 10             	add    $0x10,%esp
f0103e51:	f6 46 34 03          	testb  $0x3,0x34(%esi)
f0103e55:	75 50                	jne    f0103ea7 <print_trapframe+0x194>
}
f0103e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e5a:	5b                   	pop    %ebx
f0103e5b:	5e                   	pop    %esi
f0103e5c:	5f                   	pop    %edi
f0103e5d:	5d                   	pop    %ebp
f0103e5e:	c3                   	ret    
		return excnames[trapno];
f0103e5f:	8b 84 93 60 20 00 00 	mov    0x2060(%ebx,%edx,4),%eax
f0103e66:	e9 1d ff ff ff       	jmp    f0103d88 <print_trapframe+0x75>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103e6b:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f0103e6f:	0f 85 33 ff ff ff    	jne    f0103da8 <print_trapframe+0x95>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103e75:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0103e78:	83 ec 08             	sub    $0x8,%esp
f0103e7b:	50                   	push   %eax
f0103e7c:	8d 83 f6 aa f7 ff    	lea    -0x8550a(%ebx),%eax
f0103e82:	50                   	push   %eax
f0103e83:	e8 f5 fc ff ff       	call   f0103b7d <cprintf>
f0103e88:	83 c4 10             	add    $0x10,%esp
f0103e8b:	e9 18 ff ff ff       	jmp    f0103da8 <print_trapframe+0x95>
		cprintf("\n");
f0103e90:	83 ec 0c             	sub    $0xc,%esp
f0103e93:	8d 83 d9 a8 f7 ff    	lea    -0x85727(%ebx),%eax
f0103e99:	50                   	push   %eax
f0103e9a:	e8 de fc ff ff       	call   f0103b7d <cprintf>
f0103e9f:	83 c4 10             	add    $0x10,%esp
f0103ea2:	e9 6f ff ff ff       	jmp    f0103e16 <print_trapframe+0x103>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103ea7:	83 ec 08             	sub    $0x8,%esp
f0103eaa:	ff 76 3c             	pushl  0x3c(%esi)
f0103ead:	8d 83 53 ab f7 ff    	lea    -0x854ad(%ebx),%eax
f0103eb3:	50                   	push   %eax
f0103eb4:	e8 c4 fc ff ff       	call   f0103b7d <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103eb9:	83 c4 08             	add    $0x8,%esp
f0103ebc:	0f b7 46 40          	movzwl 0x40(%esi),%eax
f0103ec0:	50                   	push   %eax
f0103ec1:	8d 83 62 ab f7 ff    	lea    -0x8549e(%ebx),%eax
f0103ec7:	50                   	push   %eax
f0103ec8:	e8 b0 fc ff ff       	call   f0103b7d <cprintf>
f0103ecd:	83 c4 10             	add    $0x10,%esp
}
f0103ed0:	eb 85                	jmp    f0103e57 <print_trapframe+0x144>

f0103ed2 <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f0103ed2:	55                   	push   %ebp
f0103ed3:	89 e5                	mov    %esp,%ebp
f0103ed5:	57                   	push   %edi
f0103ed6:	56                   	push   %esi
f0103ed7:	53                   	push   %ebx
f0103ed8:	83 ec 0c             	sub    $0xc,%esp
f0103edb:	e8 5e c3 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103ee0:	81 c3 40 81 08 00    	add    $0x88140,%ebx
f0103ee6:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f0103ee9:	fc                   	cld    
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0103eea:	9c                   	pushf  
f0103eeb:	58                   	pop    %eax

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0103eec:	f6 c4 02             	test   $0x2,%ah
f0103eef:	74 1f                	je     f0103f10 <trap+0x3e>
f0103ef1:	8d 83 75 ab f7 ff    	lea    -0x8548b(%ebx),%eax
f0103ef7:	50                   	push   %eax
f0103ef8:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103efe:	50                   	push   %eax
f0103eff:	68 a8 00 00 00       	push   $0xa8
f0103f04:	8d 83 8e ab f7 ff    	lea    -0x85472(%ebx),%eax
f0103f0a:	50                   	push   %eax
f0103f0b:	e8 78 c2 ff ff       	call   f0100188 <_panic>

	cprintf("Incoming TRAP frame at %p\n", tf);
f0103f10:	83 ec 08             	sub    $0x8,%esp
f0103f13:	56                   	push   %esi
f0103f14:	8d 83 9a ab f7 ff    	lea    -0x85466(%ebx),%eax
f0103f1a:	50                   	push   %eax
f0103f1b:	e8 5d fc ff ff       	call   f0103b7d <cprintf>

	if ((tf->tf_cs & 3) == 3) {
f0103f20:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103f24:	83 e0 03             	and    $0x3,%eax
f0103f27:	83 c4 10             	add    $0x10,%esp
f0103f2a:	66 83 f8 03          	cmp    $0x3,%ax
f0103f2e:	75 1d                	jne    f0103f4d <trap+0x7b>
		// Trapped from user mode.
		assert(curenv);
f0103f30:	c7 c0 48 e3 18 f0    	mov    $0xf018e348,%eax
f0103f36:	8b 00                	mov    (%eax),%eax
f0103f38:	85 c0                	test   %eax,%eax
f0103f3a:	74 68                	je     f0103fa4 <trap+0xd2>

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f0103f3c:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103f41:	89 c7                	mov    %eax,%edi
f0103f43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0103f45:	c7 c0 48 e3 18 f0    	mov    $0xf018e348,%eax
f0103f4b:	8b 30                	mov    (%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0103f4d:	89 b3 40 2b 00 00    	mov    %esi,0x2b40(%ebx)
	print_trapframe(tf);
f0103f53:	83 ec 0c             	sub    $0xc,%esp
f0103f56:	56                   	push   %esi
f0103f57:	e8 b7 fd ff ff       	call   f0103d13 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0103f5c:	83 c4 10             	add    $0x10,%esp
f0103f5f:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0103f64:	74 5d                	je     f0103fc3 <trap+0xf1>
		env_destroy(curenv);
f0103f66:	83 ec 0c             	sub    $0xc,%esp
f0103f69:	c7 c6 48 e3 18 f0    	mov    $0xf018e348,%esi
f0103f6f:	ff 36                	pushl  (%esi)
f0103f71:	e8 e8 fa ff ff       	call   f0103a5e <env_destroy>

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// Return to the current environment, which should be running.
	assert(curenv && curenv->env_status == ENV_RUNNING);
f0103f76:	8b 06                	mov    (%esi),%eax
f0103f78:	83 c4 10             	add    $0x10,%esp
f0103f7b:	85 c0                	test   %eax,%eax
f0103f7d:	74 06                	je     f0103f85 <trap+0xb3>
f0103f7f:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103f83:	74 59                	je     f0103fde <trap+0x10c>
f0103f85:	8d 83 18 ad f7 ff    	lea    -0x852e8(%ebx),%eax
f0103f8b:	50                   	push   %eax
f0103f8c:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103f92:	50                   	push   %eax
f0103f93:	68 c0 00 00 00       	push   $0xc0
f0103f98:	8d 83 8e ab f7 ff    	lea    -0x85472(%ebx),%eax
f0103f9e:	50                   	push   %eax
f0103f9f:	e8 e4 c1 ff ff       	call   f0100188 <_panic>
		assert(curenv);
f0103fa4:	8d 83 b5 ab f7 ff    	lea    -0x8544b(%ebx),%eax
f0103faa:	50                   	push   %eax
f0103fab:	8d 83 b1 a5 f7 ff    	lea    -0x85a4f(%ebx),%eax
f0103fb1:	50                   	push   %eax
f0103fb2:	68 ae 00 00 00       	push   $0xae
f0103fb7:	8d 83 8e ab f7 ff    	lea    -0x85472(%ebx),%eax
f0103fbd:	50                   	push   %eax
f0103fbe:	e8 c5 c1 ff ff       	call   f0100188 <_panic>
		panic("unhandled trap in kernel");
f0103fc3:	83 ec 04             	sub    $0x4,%esp
f0103fc6:	8d 83 bc ab f7 ff    	lea    -0x85444(%ebx),%eax
f0103fcc:	50                   	push   %eax
f0103fcd:	68 97 00 00 00       	push   $0x97
f0103fd2:	8d 83 8e ab f7 ff    	lea    -0x85472(%ebx),%eax
f0103fd8:	50                   	push   %eax
f0103fd9:	e8 aa c1 ff ff       	call   f0100188 <_panic>
	env_run(curenv);
f0103fde:	83 ec 0c             	sub    $0xc,%esp
f0103fe1:	50                   	push   %eax
f0103fe2:	e8 e5 fa ff ff       	call   f0103acc <env_run>

f0103fe7 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103fe7:	55                   	push   %ebp
f0103fe8:	89 e5                	mov    %esp,%ebp
f0103fea:	57                   	push   %edi
f0103feb:	56                   	push   %esi
f0103fec:	53                   	push   %ebx
f0103fed:	83 ec 0c             	sub    $0xc,%esp
f0103ff0:	e8 49 c2 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103ff5:	81 c3 2b 80 08 00    	add    $0x8802b,%ebx
f0103ffb:	8b 7d 08             	mov    0x8(%ebp),%edi
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103ffe:	0f 20 d0             	mov    %cr2,%eax

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104001:	ff 77 30             	pushl  0x30(%edi)
f0104004:	50                   	push   %eax
f0104005:	c7 c6 48 e3 18 f0    	mov    $0xf018e348,%esi
f010400b:	8b 06                	mov    (%esi),%eax
f010400d:	ff 70 48             	pushl  0x48(%eax)
f0104010:	8d 83 44 ad f7 ff    	lea    -0x852bc(%ebx),%eax
f0104016:	50                   	push   %eax
f0104017:	e8 61 fb ff ff       	call   f0103b7d <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f010401c:	89 3c 24             	mov    %edi,(%esp)
f010401f:	e8 ef fc ff ff       	call   f0103d13 <print_trapframe>
	env_destroy(curenv);
f0104024:	83 c4 04             	add    $0x4,%esp
f0104027:	ff 36                	pushl  (%esi)
f0104029:	e8 30 fa ff ff       	call   f0103a5e <env_destroy>
}
f010402e:	83 c4 10             	add    $0x10,%esp
f0104031:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104034:	5b                   	pop    %ebx
f0104035:	5e                   	pop    %esi
f0104036:	5f                   	pop    %edi
f0104037:	5d                   	pop    %ebp
f0104038:	c3                   	ret    

f0104039 <syscall>:
f0104039:	55                   	push   %ebp
f010403a:	89 e5                	mov    %esp,%ebp
f010403c:	53                   	push   %ebx
f010403d:	83 ec 08             	sub    $0x8,%esp
f0104040:	e8 f9 c1 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104045:	81 c3 db 7f 08 00    	add    $0x87fdb,%ebx
f010404b:	8d 83 68 ad f7 ff    	lea    -0x85298(%ebx),%eax
f0104051:	50                   	push   %eax
f0104052:	6a 49                	push   $0x49
f0104054:	8d 83 80 ad f7 ff    	lea    -0x85280(%ebx),%eax
f010405a:	50                   	push   %eax
f010405b:	e8 28 c1 ff ff       	call   f0100188 <_panic>

f0104060 <stab_binsearch>:
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr) {
f0104060:	55                   	push   %ebp
f0104061:	89 e5                	mov    %esp,%ebp
f0104063:	57                   	push   %edi
f0104064:	56                   	push   %esi
f0104065:	53                   	push   %ebx
f0104066:	83 ec 14             	sub    $0x14,%esp
f0104069:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010406c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010406f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104072:	8b 7d 08             	mov    0x8(%ebp),%edi
    int l = *region_left, r = *region_right, any_matches = 0;
f0104075:	8b 32                	mov    (%edx),%esi
f0104077:	8b 01                	mov    (%ecx),%eax
f0104079:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010407c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    while (l <= r) {
f0104083:	eb 2f                	jmp    f01040b4 <stab_binsearch+0x54>
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
f0104085:	83 e8 01             	sub    $0x1,%eax
        while (m >= l && stabs[m].n_type != type)
f0104088:	39 c6                	cmp    %eax,%esi
f010408a:	7f 49                	jg     f01040d5 <stab_binsearch+0x75>
f010408c:	0f b6 0a             	movzbl (%edx),%ecx
f010408f:	83 ea 0c             	sub    $0xc,%edx
f0104092:	39 f9                	cmp    %edi,%ecx
f0104094:	75 ef                	jne    f0104085 <stab_binsearch+0x25>
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
f0104096:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104099:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010409c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01040a0:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01040a3:	73 35                	jae    f01040da <stab_binsearch+0x7a>
            *region_left = m;
f01040a5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01040a8:	89 06                	mov    %eax,(%esi)
            l = true_m + 1;
f01040aa:	8d 73 01             	lea    0x1(%ebx),%esi
        any_matches = 1;
f01040ad:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while (l <= r) {
f01040b4:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f01040b7:	7f 4e                	jg     f0104107 <stab_binsearch+0xa7>
        int true_m = (l + r) / 2, m = true_m;
f01040b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040bc:	01 f0                	add    %esi,%eax
f01040be:	89 c3                	mov    %eax,%ebx
f01040c0:	c1 eb 1f             	shr    $0x1f,%ebx
f01040c3:	01 c3                	add    %eax,%ebx
f01040c5:	d1 fb                	sar    %ebx
f01040c7:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01040ca:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01040cd:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01040d1:	89 d8                	mov    %ebx,%eax
        while (m >= l && stabs[m].n_type != type)
f01040d3:	eb b3                	jmp    f0104088 <stab_binsearch+0x28>
            l = true_m + 1;
f01040d5:	8d 73 01             	lea    0x1(%ebx),%esi
            continue;
f01040d8:	eb da                	jmp    f01040b4 <stab_binsearch+0x54>
        } else if (stabs[m].n_value > addr) {
f01040da:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01040dd:	76 14                	jbe    f01040f3 <stab_binsearch+0x93>
            *region_right = m - 1;
f01040df:	83 e8 01             	sub    $0x1,%eax
f01040e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01040e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01040e8:	89 03                	mov    %eax,(%ebx)
        any_matches = 1;
f01040ea:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01040f1:	eb c1                	jmp    f01040b4 <stab_binsearch+0x54>
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
f01040f3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01040f6:	89 06                	mov    %eax,(%esi)
            l = m;
            addr++;
f01040f8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01040fc:	89 c6                	mov    %eax,%esi
        any_matches = 1;
f01040fe:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104105:	eb ad                	jmp    f01040b4 <stab_binsearch+0x54>
        }
    }

    if (!any_matches)
f0104107:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f010410b:	74 16                	je     f0104123 <stab_binsearch+0xc3>
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
f010410d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104110:	8b 00                	mov    (%eax),%eax
             l > *region_left && stabs[l].n_type != type;
f0104112:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104115:	8b 0e                	mov    (%esi),%ecx
f0104117:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010411a:	8b 75 ec             	mov    -0x14(%ebp),%esi
f010411d:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
        for (l = *region_right;
f0104121:	eb 12                	jmp    f0104135 <stab_binsearch+0xd5>
        *region_right = *region_left - 1;
f0104123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104126:	8b 00                	mov    (%eax),%eax
f0104128:	83 e8 01             	sub    $0x1,%eax
f010412b:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010412e:	89 07                	mov    %eax,(%edi)
f0104130:	eb 16                	jmp    f0104148 <stab_binsearch+0xe8>
             l--)
f0104132:	83 e8 01             	sub    $0x1,%eax
        for (l = *region_right;
f0104135:	39 c1                	cmp    %eax,%ecx
f0104137:	7d 0a                	jge    f0104143 <stab_binsearch+0xe3>
             l > *region_left && stabs[l].n_type != type;
f0104139:	0f b6 1a             	movzbl (%edx),%ebx
f010413c:	83 ea 0c             	sub    $0xc,%edx
f010413f:	39 fb                	cmp    %edi,%ebx
f0104141:	75 ef                	jne    f0104132 <stab_binsearch+0xd2>
            /* do nothing */;
        *region_left = l;
f0104143:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104146:	89 07                	mov    %eax,(%edi)
    }
}
f0104148:	83 c4 14             	add    $0x14,%esp
f010414b:	5b                   	pop    %ebx
f010414c:	5e                   	pop    %esi
f010414d:	5f                   	pop    %edi
f010414e:	5d                   	pop    %ebp
f010414f:	c3                   	ret    

f0104150 <debuginfo_eip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info) {
f0104150:	55                   	push   %ebp
f0104151:	89 e5                	mov    %esp,%ebp
f0104153:	57                   	push   %edi
f0104154:	56                   	push   %esi
f0104155:	53                   	push   %ebx
f0104156:	83 ec 3c             	sub    $0x3c,%esp
f0104159:	e8 e0 c0 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010415e:	81 c3 c2 7e 08 00    	add    $0x87ec2,%ebx
f0104164:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104167:	8b 75 0c             	mov    0xc(%ebp),%esi
    const struct Stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->eip_file = "<unknown>";
f010416a:	8d 83 8f ad f7 ff    	lea    -0x85271(%ebx),%eax
f0104170:	89 06                	mov    %eax,(%esi)
    info->eip_line = 0;
f0104172:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    info->eip_fn_name = "<unknown>";
f0104179:	89 46 08             	mov    %eax,0x8(%esi)
    info->eip_fn_namelen = 9;
f010417c:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
    info->eip_fn_addr = addr;
f0104183:	89 7e 10             	mov    %edi,0x10(%esi)
    info->eip_fn_narg = 0;
f0104186:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

    // Find the relevant set of stabs
    if (addr >= ULIM) {
f010418d:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104193:	0f 86 41 01 00 00    	jbe    f01042da <debuginfo_eip+0x18a>
        // Can't search for user-level addresses yet!
        panic("User address");
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104199:	c7 c0 d1 f4 10 f0    	mov    $0xf010f4d1,%eax
f010419f:	39 83 fc ff ff ff    	cmp    %eax,-0x4(%ebx)
f01041a5:	0f 86 0e 02 00 00    	jbe    f01043b9 <debuginfo_eip+0x269>
f01041ab:	c7 c0 af 1e 11 f0    	mov    $0xf0111eaf,%eax
f01041b1:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01041b5:	0f 85 05 02 00 00    	jne    f01043c0 <debuginfo_eip+0x270>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
f01041bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    rfile = (stab_end - stabs) - 1;
f01041c2:	c7 c0 c8 6f 10 f0    	mov    $0xf0106fc8,%eax
f01041c8:	c7 c2 d0 f4 10 f0    	mov    $0xf010f4d0,%edx
f01041ce:	29 c2                	sub    %eax,%edx
f01041d0:	c1 fa 02             	sar    $0x2,%edx
f01041d3:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f01041d9:	83 ea 01             	sub    $0x1,%edx
f01041dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01041df:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01041e2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01041e5:	83 ec 08             	sub    $0x8,%esp
f01041e8:	57                   	push   %edi
f01041e9:	6a 64                	push   $0x64
f01041eb:	e8 70 fe ff ff       	call   f0104060 <stab_binsearch>
    if (lfile == 0)
f01041f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01041f3:	83 c4 10             	add    $0x10,%esp
f01041f6:	85 c0                	test   %eax,%eax
f01041f8:	0f 84 c9 01 00 00    	je     f01043c7 <debuginfo_eip+0x277>
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
f01041fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
    rfun = rfile;
f0104201:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104204:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104207:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010420a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010420d:	83 ec 08             	sub    $0x8,%esp
f0104210:	57                   	push   %edi
f0104211:	6a 24                	push   $0x24
f0104213:	c7 c0 c8 6f 10 f0    	mov    $0xf0106fc8,%eax
f0104219:	e8 42 fe ff ff       	call   f0104060 <stab_binsearch>

    if (lfun <= rfun) {
f010421e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104221:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104224:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0104227:	83 c4 10             	add    $0x10,%esp
f010422a:	39 c8                	cmp    %ecx,%eax
f010422c:	0f 8f c0 00 00 00    	jg     f01042f2 <debuginfo_eip+0x1a2>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104232:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104235:	c7 c1 c8 6f 10 f0    	mov    $0xf0106fc8,%ecx
f010423b:	8d 0c 91             	lea    (%ecx,%edx,4),%ecx
f010423e:	8b 11                	mov    (%ecx),%edx
f0104240:	89 55 c0             	mov    %edx,-0x40(%ebp)
f0104243:	c7 c2 af 1e 11 f0    	mov    $0xf0111eaf,%edx
f0104249:	81 ea d1 f4 10 f0    	sub    $0xf010f4d1,%edx
f010424f:	39 55 c0             	cmp    %edx,-0x40(%ebp)
f0104252:	73 0c                	jae    f0104260 <debuginfo_eip+0x110>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104254:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0104257:	81 c2 d1 f4 10 f0    	add    $0xf010f4d1,%edx
f010425d:	89 56 08             	mov    %edx,0x8(%esi)
        info->eip_fn_addr = stabs[lfun].n_value;
f0104260:	8b 51 08             	mov    0x8(%ecx),%edx
f0104263:	89 56 10             	mov    %edx,0x10(%esi)
        addr -= info->eip_fn_addr;
f0104266:	29 d7                	sub    %edx,%edi
        // Search within the function definition for the line number.
        lline = lfun;
f0104268:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
f010426b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f010426e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        info->eip_fn_addr = addr;
        lline = lfile;
        rline = rfile;
    }
    // Ignore stuff after the colon.
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104271:	83 ec 08             	sub    $0x8,%esp
f0104274:	6a 3a                	push   $0x3a
f0104276:	ff 76 08             	pushl  0x8(%esi)
f0104279:	e8 fe 09 00 00       	call   f0104c7c <strfind>
f010427e:	2b 46 08             	sub    0x8(%esi),%eax
f0104281:	89 46 0c             	mov    %eax,0xc(%esi)
    // Hint:
    //	There's a particular stabs type used for line numbers.
    //	Look at the STABS documentation and <inc/stab.h> to find
    //	which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, info->eip_fn_addr + addr);
f0104284:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104287:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f010428a:	83 c4 08             	add    $0x8,%esp
f010428d:	03 7e 10             	add    0x10(%esi),%edi
f0104290:	57                   	push   %edi
f0104291:	6a 44                	push   $0x44
f0104293:	c7 c0 c8 6f 10 f0    	mov    $0xf0106fc8,%eax
f0104299:	e8 c2 fd ff ff       	call   f0104060 <stab_binsearch>
    info->eip_line = lline > rline ? -1 : stabs[lline].n_desc;
f010429e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01042a1:	83 c4 10             	add    $0x10,%esp
f01042a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01042a9:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f01042ac:	7f 0e                	jg     f01042bc <debuginfo_eip+0x16c>
f01042ae:	8d 04 52             	lea    (%edx,%edx,2),%eax
f01042b1:	c7 c1 c8 6f 10 f0    	mov    $0xf0106fc8,%ecx
f01042b7:	0f b7 44 81 06       	movzwl 0x6(%ecx,%eax,4),%eax
f01042bc:	89 46 04             	mov    %eax,0x4(%esi)
    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
f01042bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01042c2:	89 d0                	mov    %edx,%eax
f01042c4:	8d 0c 52             	lea    (%edx,%edx,2),%ecx
f01042c7:	c7 c2 c8 6f 10 f0    	mov    $0xf0106fc8,%edx
f01042cd:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f01042d1:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01042d5:	89 75 0c             	mov    %esi,0xc(%ebp)
f01042d8:	eb 36                	jmp    f0104310 <debuginfo_eip+0x1c0>
        panic("User address");
f01042da:	83 ec 04             	sub    $0x4,%esp
f01042dd:	8d 83 99 ad f7 ff    	lea    -0x85267(%ebx),%eax
f01042e3:	50                   	push   %eax
f01042e4:	6a 7d                	push   $0x7d
f01042e6:	8d 83 a6 ad f7 ff    	lea    -0x8525a(%ebx),%eax
f01042ec:	50                   	push   %eax
f01042ed:	e8 96 be ff ff       	call   f0100188 <_panic>
        info->eip_fn_addr = addr;
f01042f2:	89 7e 10             	mov    %edi,0x10(%esi)
        lline = lfile;
f01042f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01042f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
f01042fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01042fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104301:	e9 6b ff ff ff       	jmp    f0104271 <debuginfo_eip+0x121>
f0104306:	83 e8 01             	sub    $0x1,%eax
f0104309:	83 ea 0c             	sub    $0xc,%edx
f010430c:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104310:	89 45 c0             	mov    %eax,-0x40(%ebp)
    while (lline >= lfile
f0104313:	39 c7                	cmp    %eax,%edi
f0104315:	7f 24                	jg     f010433b <debuginfo_eip+0x1eb>
           && stabs[lline].n_type != N_SOL
f0104317:	0f b6 0a             	movzbl (%edx),%ecx
f010431a:	80 f9 84             	cmp    $0x84,%cl
f010431d:	74 46                	je     f0104365 <debuginfo_eip+0x215>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f010431f:	80 f9 64             	cmp    $0x64,%cl
f0104322:	75 e2                	jne    f0104306 <debuginfo_eip+0x1b6>
f0104324:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104328:	74 dc                	je     f0104306 <debuginfo_eip+0x1b6>
f010432a:	8b 75 0c             	mov    0xc(%ebp),%esi
f010432d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104331:	74 3b                	je     f010436e <debuginfo_eip+0x21e>
f0104333:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104336:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104339:	eb 33                	jmp    f010436e <debuginfo_eip+0x21e>
f010433b:	8b 75 0c             	mov    0xc(%ebp),%esi
        info->eip_file = stabstr + stabs[lline].n_strx;


    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
f010433e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104341:	8b 7d d8             	mov    -0x28(%ebp),%edi
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
            info->eip_fn_narg++;

    return 0;
f0104344:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lfun < rfun)
f0104349:	39 fa                	cmp    %edi,%edx
f010434b:	0f 8d 82 00 00 00    	jge    f01043d3 <debuginfo_eip+0x283>
        for (lline = lfun + 1;
f0104351:	83 c2 01             	add    $0x1,%edx
f0104354:	89 d0                	mov    %edx,%eax
f0104356:	8d 0c 52             	lea    (%edx,%edx,2),%ecx
f0104359:	c7 c2 c8 6f 10 f0    	mov    $0xf0106fc8,%edx
f010435f:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f0104363:	eb 3b                	jmp    f01043a0 <debuginfo_eip+0x250>
f0104365:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104368:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f010436c:	75 26                	jne    f0104394 <debuginfo_eip+0x244>
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f010436e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104371:	c7 c0 c8 6f 10 f0    	mov    $0xf0106fc8,%eax
f0104377:	8b 14 90             	mov    (%eax,%edx,4),%edx
f010437a:	c7 c0 af 1e 11 f0    	mov    $0xf0111eaf,%eax
f0104380:	81 e8 d1 f4 10 f0    	sub    $0xf010f4d1,%eax
f0104386:	39 c2                	cmp    %eax,%edx
f0104388:	73 b4                	jae    f010433e <debuginfo_eip+0x1ee>
        info->eip_file = stabstr + stabs[lline].n_strx;
f010438a:	81 c2 d1 f4 10 f0    	add    $0xf010f4d1,%edx
f0104390:	89 16                	mov    %edx,(%esi)
f0104392:	eb aa                	jmp    f010433e <debuginfo_eip+0x1ee>
f0104394:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104397:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010439a:	eb d2                	jmp    f010436e <debuginfo_eip+0x21e>
            info->eip_fn_narg++;
f010439c:	83 46 14 01          	addl   $0x1,0x14(%esi)
        for (lline = lfun + 1;
f01043a0:	39 c7                	cmp    %eax,%edi
f01043a2:	7e 2a                	jle    f01043ce <debuginfo_eip+0x27e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
f01043a4:	0f b6 0a             	movzbl (%edx),%ecx
f01043a7:	83 c0 01             	add    $0x1,%eax
f01043aa:	83 c2 0c             	add    $0xc,%edx
f01043ad:	80 f9 a0             	cmp    $0xa0,%cl
f01043b0:	74 ea                	je     f010439c <debuginfo_eip+0x24c>
    return 0;
f01043b2:	b8 00 00 00 00       	mov    $0x0,%eax
f01043b7:	eb 1a                	jmp    f01043d3 <debuginfo_eip+0x283>
        return -1;
f01043b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01043be:	eb 13                	jmp    f01043d3 <debuginfo_eip+0x283>
f01043c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01043c5:	eb 0c                	jmp    f01043d3 <debuginfo_eip+0x283>
        return -1;
f01043c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01043cc:	eb 05                	jmp    f01043d3 <debuginfo_eip+0x283>
    return 0;
f01043ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01043d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01043d6:	5b                   	pop    %ebx
f01043d7:	5e                   	pop    %esi
f01043d8:	5f                   	pop    %edi
f01043d9:	5d                   	pop    %ebp
f01043da:	c3                   	ret    

f01043db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01043db:	55                   	push   %ebp
f01043dc:	89 e5                	mov    %esp,%ebp
f01043de:	57                   	push   %edi
f01043df:	56                   	push   %esi
f01043e0:	53                   	push   %ebx
f01043e1:	83 ec 2c             	sub    $0x2c,%esp
f01043e4:	e8 22 f2 ff ff       	call   f010360b <__x86.get_pc_thunk.cx>
f01043e9:	81 c1 37 7c 08 00    	add    $0x87c37,%ecx
f01043ef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01043f2:	89 c7                	mov    %eax,%edi
f01043f4:	89 d6                	mov    %edx,%esi
f01043f6:	8b 45 08             	mov    0x8(%ebp),%eax
f01043f9:	8b 55 0c             	mov    0xc(%ebp),%edx
f01043fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01043ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
f0104402:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104405:	bb 00 00 00 00       	mov    $0x0,%ebx
f010440a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
f010440d:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f0104410:	39 d3                	cmp    %edx,%ebx
f0104412:	72 09                	jb     f010441d <printnum+0x42>
f0104414:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104417:	0f 87 83 00 00 00    	ja     f01044a0 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010441d:	83 ec 0c             	sub    $0xc,%esp
f0104420:	ff 75 18             	pushl  0x18(%ebp)
f0104423:	8b 45 14             	mov    0x14(%ebp),%eax
f0104426:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104429:	53                   	push   %ebx
f010442a:	ff 75 10             	pushl  0x10(%ebp)
f010442d:	83 ec 08             	sub    $0x8,%esp
f0104430:	ff 75 dc             	pushl  -0x24(%ebp)
f0104433:	ff 75 d8             	pushl  -0x28(%ebp)
f0104436:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104439:	ff 75 d0             	pushl  -0x30(%ebp)
f010443c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010443f:	e8 5c 0a 00 00       	call   f0104ea0 <__udivdi3>
f0104444:	83 c4 18             	add    $0x18,%esp
f0104447:	52                   	push   %edx
f0104448:	50                   	push   %eax
f0104449:	89 f2                	mov    %esi,%edx
f010444b:	89 f8                	mov    %edi,%eax
f010444d:	e8 89 ff ff ff       	call   f01043db <printnum>
f0104452:	83 c4 20             	add    $0x20,%esp
f0104455:	eb 13                	jmp    f010446a <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104457:	83 ec 08             	sub    $0x8,%esp
f010445a:	56                   	push   %esi
f010445b:	ff 75 18             	pushl  0x18(%ebp)
f010445e:	ff d7                	call   *%edi
f0104460:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104463:	83 eb 01             	sub    $0x1,%ebx
f0104466:	85 db                	test   %ebx,%ebx
f0104468:	7f ed                	jg     f0104457 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010446a:	83 ec 08             	sub    $0x8,%esp
f010446d:	56                   	push   %esi
f010446e:	83 ec 04             	sub    $0x4,%esp
f0104471:	ff 75 dc             	pushl  -0x24(%ebp)
f0104474:	ff 75 d8             	pushl  -0x28(%ebp)
f0104477:	ff 75 d4             	pushl  -0x2c(%ebp)
f010447a:	ff 75 d0             	pushl  -0x30(%ebp)
f010447d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104480:	89 f3                	mov    %esi,%ebx
f0104482:	e8 39 0b 00 00       	call   f0104fc0 <__umoddi3>
f0104487:	83 c4 14             	add    $0x14,%esp
f010448a:	0f be 84 06 b4 ad f7 	movsbl -0x8524c(%esi,%eax,1),%eax
f0104491:	ff 
f0104492:	50                   	push   %eax
f0104493:	ff d7                	call   *%edi
}
f0104495:	83 c4 10             	add    $0x10,%esp
f0104498:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010449b:	5b                   	pop    %ebx
f010449c:	5e                   	pop    %esi
f010449d:	5f                   	pop    %edi
f010449e:	5d                   	pop    %ebp
f010449f:	c3                   	ret    
f01044a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01044a3:	eb be                	jmp    f0104463 <printnum+0x88>

f01044a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01044a5:	55                   	push   %ebp
f01044a6:	89 e5                	mov    %esp,%ebp
f01044a8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01044ab:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01044af:	8b 10                	mov    (%eax),%edx
f01044b1:	3b 50 04             	cmp    0x4(%eax),%edx
f01044b4:	73 0a                	jae    f01044c0 <sprintputch+0x1b>
		*b->buf++ = ch;
f01044b6:	8d 4a 01             	lea    0x1(%edx),%ecx
f01044b9:	89 08                	mov    %ecx,(%eax)
f01044bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01044be:	88 02                	mov    %al,(%edx)
}
f01044c0:	5d                   	pop    %ebp
f01044c1:	c3                   	ret    

f01044c2 <printfmt>:
{
f01044c2:	55                   	push   %ebp
f01044c3:	89 e5                	mov    %esp,%ebp
f01044c5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01044c8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01044cb:	50                   	push   %eax
f01044cc:	ff 75 10             	pushl  0x10(%ebp)
f01044cf:	ff 75 0c             	pushl  0xc(%ebp)
f01044d2:	ff 75 08             	pushl  0x8(%ebp)
f01044d5:	e8 05 00 00 00       	call   f01044df <vprintfmt>
}
f01044da:	83 c4 10             	add    $0x10,%esp
f01044dd:	c9                   	leave  
f01044de:	c3                   	ret    

f01044df <vprintfmt>:
{
f01044df:	55                   	push   %ebp
f01044e0:	89 e5                	mov    %esp,%ebp
f01044e2:	57                   	push   %edi
f01044e3:	56                   	push   %esi
f01044e4:	53                   	push   %ebx
f01044e5:	83 ec 2c             	sub    $0x2c,%esp
f01044e8:	e8 51 bd ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01044ed:	81 c3 33 7b 08 00    	add    $0x87b33,%ebx
f01044f3:	8b 75 0c             	mov    0xc(%ebp),%esi
f01044f6:	8b 7d 10             	mov    0x10(%ebp),%edi
f01044f9:	e9 fb 03 00 00       	jmp    f01048f9 <.L35+0x48>
		padc = ' ';
f01044fe:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0104502:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104509:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
f0104510:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0104517:	b9 00 00 00 00       	mov    $0x0,%ecx
f010451c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010451f:	8d 47 01             	lea    0x1(%edi),%eax
f0104522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104525:	0f b6 17             	movzbl (%edi),%edx
f0104528:	8d 42 dd             	lea    -0x23(%edx),%eax
f010452b:	3c 55                	cmp    $0x55,%al
f010452d:	0f 87 4e 04 00 00    	ja     f0104981 <.L22>
f0104533:	0f b6 c0             	movzbl %al,%eax
f0104536:	89 d9                	mov    %ebx,%ecx
f0104538:	03 8c 83 40 ae f7 ff 	add    -0x851c0(%ebx,%eax,4),%ecx
f010453f:	ff e1                	jmp    *%ecx

f0104541 <.L71>:
f0104541:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0104544:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0104548:	eb d5                	jmp    f010451f <vprintfmt+0x40>

f010454a <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
f010454a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f010454d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104551:	eb cc                	jmp    f010451f <vprintfmt+0x40>

f0104553 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
f0104553:	0f b6 d2             	movzbl %dl,%edx
f0104556:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104559:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
f010455e:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104561:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104565:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104568:	8d 4a d0             	lea    -0x30(%edx),%ecx
f010456b:	83 f9 09             	cmp    $0x9,%ecx
f010456e:	77 55                	ja     f01045c5 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
f0104570:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0104573:	eb e9                	jmp    f010455e <.L29+0xb>

f0104575 <.L26>:
			precision = va_arg(ap, int);
f0104575:	8b 45 14             	mov    0x14(%ebp),%eax
f0104578:	8b 00                	mov    (%eax),%eax
f010457a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010457d:	8b 45 14             	mov    0x14(%ebp),%eax
f0104580:	8d 40 04             	lea    0x4(%eax),%eax
f0104583:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104586:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0104589:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010458d:	79 90                	jns    f010451f <vprintfmt+0x40>
				width = precision, precision = -1;
f010458f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0104592:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104595:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
f010459c:	eb 81                	jmp    f010451f <vprintfmt+0x40>

f010459e <.L27>:
f010459e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01045a1:	85 c0                	test   %eax,%eax
f01045a3:	ba 00 00 00 00       	mov    $0x0,%edx
f01045a8:	0f 49 d0             	cmovns %eax,%edx
f01045ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01045ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01045b1:	e9 69 ff ff ff       	jmp    f010451f <vprintfmt+0x40>

f01045b6 <.L23>:
f01045b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f01045b9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f01045c0:	e9 5a ff ff ff       	jmp    f010451f <vprintfmt+0x40>
f01045c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01045c8:	eb bf                	jmp    f0104589 <.L26+0x14>

f01045ca <.L33>:
			lflag++;
f01045ca:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01045ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f01045d1:	e9 49 ff ff ff       	jmp    f010451f <vprintfmt+0x40>

f01045d6 <.L30>:
			putch(va_arg(ap, int), putdat);
f01045d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01045d9:	8d 78 04             	lea    0x4(%eax),%edi
f01045dc:	83 ec 08             	sub    $0x8,%esp
f01045df:	56                   	push   %esi
f01045e0:	ff 30                	pushl  (%eax)
f01045e2:	ff 55 08             	call   *0x8(%ebp)
			break;
f01045e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f01045e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f01045eb:	e9 06 03 00 00       	jmp    f01048f6 <.L35+0x45>

f01045f0 <.L32>:
			err = va_arg(ap, int);
f01045f0:	8b 45 14             	mov    0x14(%ebp),%eax
f01045f3:	8d 78 04             	lea    0x4(%eax),%edi
f01045f6:	8b 00                	mov    (%eax),%eax
f01045f8:	99                   	cltd   
f01045f9:	31 d0                	xor    %edx,%eax
f01045fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01045fd:	83 f8 06             	cmp    $0x6,%eax
f0104600:	7f 27                	jg     f0104629 <.L32+0x39>
f0104602:	8b 94 83 b0 20 00 00 	mov    0x20b0(%ebx,%eax,4),%edx
f0104609:	85 d2                	test   %edx,%edx
f010460b:	74 1c                	je     f0104629 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
f010460d:	52                   	push   %edx
f010460e:	8d 83 c3 a5 f7 ff    	lea    -0x85a3d(%ebx),%eax
f0104614:	50                   	push   %eax
f0104615:	56                   	push   %esi
f0104616:	ff 75 08             	pushl  0x8(%ebp)
f0104619:	e8 a4 fe ff ff       	call   f01044c2 <printfmt>
f010461e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104621:	89 7d 14             	mov    %edi,0x14(%ebp)
f0104624:	e9 cd 02 00 00       	jmp    f01048f6 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
f0104629:	50                   	push   %eax
f010462a:	8d 83 cc ad f7 ff    	lea    -0x85234(%ebx),%eax
f0104630:	50                   	push   %eax
f0104631:	56                   	push   %esi
f0104632:	ff 75 08             	pushl  0x8(%ebp)
f0104635:	e8 88 fe ff ff       	call   f01044c2 <printfmt>
f010463a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010463d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104640:	e9 b1 02 00 00       	jmp    f01048f6 <.L35+0x45>

f0104645 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
f0104645:	8b 45 14             	mov    0x14(%ebp),%eax
f0104648:	83 c0 04             	add    $0x4,%eax
f010464b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010464e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104651:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0104653:	85 ff                	test   %edi,%edi
f0104655:	8d 83 c5 ad f7 ff    	lea    -0x8523b(%ebx),%eax
f010465b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f010465e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104662:	0f 8e b5 00 00 00    	jle    f010471d <.L36+0xd8>
f0104668:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f010466c:	75 08                	jne    f0104676 <.L36+0x31>
f010466e:	89 75 0c             	mov    %esi,0xc(%ebp)
f0104671:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0104674:	eb 6d                	jmp    f01046e3 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104676:	83 ec 08             	sub    $0x8,%esp
f0104679:	ff 75 cc             	pushl  -0x34(%ebp)
f010467c:	57                   	push   %edi
f010467d:	e8 b6 04 00 00       	call   f0104b38 <strnlen>
f0104682:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104685:	29 c2                	sub    %eax,%edx
f0104687:	89 55 c8             	mov    %edx,-0x38(%ebp)
f010468a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f010468d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0104691:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104694:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104697:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104699:	eb 10                	jmp    f01046ab <.L36+0x66>
					putch(padc, putdat);
f010469b:	83 ec 08             	sub    $0x8,%esp
f010469e:	56                   	push   %esi
f010469f:	ff 75 e0             	pushl  -0x20(%ebp)
f01046a2:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01046a5:	83 ef 01             	sub    $0x1,%edi
f01046a8:	83 c4 10             	add    $0x10,%esp
f01046ab:	85 ff                	test   %edi,%edi
f01046ad:	7f ec                	jg     f010469b <.L36+0x56>
f01046af:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01046b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
f01046b5:	85 d2                	test   %edx,%edx
f01046b7:	b8 00 00 00 00       	mov    $0x0,%eax
f01046bc:	0f 49 c2             	cmovns %edx,%eax
f01046bf:	29 c2                	sub    %eax,%edx
f01046c1:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01046c4:	89 75 0c             	mov    %esi,0xc(%ebp)
f01046c7:	8b 75 cc             	mov    -0x34(%ebp),%esi
f01046ca:	eb 17                	jmp    f01046e3 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
f01046cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01046d0:	75 30                	jne    f0104702 <.L36+0xbd>
					putch(ch, putdat);
f01046d2:	83 ec 08             	sub    $0x8,%esp
f01046d5:	ff 75 0c             	pushl  0xc(%ebp)
f01046d8:	50                   	push   %eax
f01046d9:	ff 55 08             	call   *0x8(%ebp)
f01046dc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01046df:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f01046e3:	83 c7 01             	add    $0x1,%edi
f01046e6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f01046ea:	0f be c2             	movsbl %dl,%eax
f01046ed:	85 c0                	test   %eax,%eax
f01046ef:	74 52                	je     f0104743 <.L36+0xfe>
f01046f1:	85 f6                	test   %esi,%esi
f01046f3:	78 d7                	js     f01046cc <.L36+0x87>
f01046f5:	83 ee 01             	sub    $0x1,%esi
f01046f8:	79 d2                	jns    f01046cc <.L36+0x87>
f01046fa:	8b 75 0c             	mov    0xc(%ebp),%esi
f01046fd:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104700:	eb 32                	jmp    f0104734 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
f0104702:	0f be d2             	movsbl %dl,%edx
f0104705:	83 ea 20             	sub    $0x20,%edx
f0104708:	83 fa 5e             	cmp    $0x5e,%edx
f010470b:	76 c5                	jbe    f01046d2 <.L36+0x8d>
					putch('?', putdat);
f010470d:	83 ec 08             	sub    $0x8,%esp
f0104710:	ff 75 0c             	pushl  0xc(%ebp)
f0104713:	6a 3f                	push   $0x3f
f0104715:	ff 55 08             	call   *0x8(%ebp)
f0104718:	83 c4 10             	add    $0x10,%esp
f010471b:	eb c2                	jmp    f01046df <.L36+0x9a>
f010471d:	89 75 0c             	mov    %esi,0xc(%ebp)
f0104720:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0104723:	eb be                	jmp    f01046e3 <.L36+0x9e>
				putch(' ', putdat);
f0104725:	83 ec 08             	sub    $0x8,%esp
f0104728:	56                   	push   %esi
f0104729:	6a 20                	push   $0x20
f010472b:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
f010472e:	83 ef 01             	sub    $0x1,%edi
f0104731:	83 c4 10             	add    $0x10,%esp
f0104734:	85 ff                	test   %edi,%edi
f0104736:	7f ed                	jg     f0104725 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
f0104738:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010473b:	89 45 14             	mov    %eax,0x14(%ebp)
f010473e:	e9 b3 01 00 00       	jmp    f01048f6 <.L35+0x45>
f0104743:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104746:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104749:	eb e9                	jmp    f0104734 <.L36+0xef>

f010474b <.L31>:
f010474b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f010474e:	83 f9 01             	cmp    $0x1,%ecx
f0104751:	7e 40                	jle    f0104793 <.L31+0x48>
		return va_arg(*ap, long long);
f0104753:	8b 45 14             	mov    0x14(%ebp),%eax
f0104756:	8b 50 04             	mov    0x4(%eax),%edx
f0104759:	8b 00                	mov    (%eax),%eax
f010475b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010475e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104761:	8b 45 14             	mov    0x14(%ebp),%eax
f0104764:	8d 40 08             	lea    0x8(%eax),%eax
f0104767:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f010476a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010476e:	79 55                	jns    f01047c5 <.L31+0x7a>
				putch('-', putdat);
f0104770:	83 ec 08             	sub    $0x8,%esp
f0104773:	56                   	push   %esi
f0104774:	6a 2d                	push   $0x2d
f0104776:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0104779:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010477c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010477f:	f7 da                	neg    %edx
f0104781:	83 d1 00             	adc    $0x0,%ecx
f0104784:	f7 d9                	neg    %ecx
f0104786:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0104789:	b8 0a 00 00 00       	mov    $0xa,%eax
f010478e:	e9 48 01 00 00       	jmp    f01048db <.L35+0x2a>
	else if (lflag)
f0104793:	85 c9                	test   %ecx,%ecx
f0104795:	75 17                	jne    f01047ae <.L31+0x63>
		return va_arg(*ap, int);
f0104797:	8b 45 14             	mov    0x14(%ebp),%eax
f010479a:	8b 00                	mov    (%eax),%eax
f010479c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010479f:	99                   	cltd   
f01047a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01047a3:	8b 45 14             	mov    0x14(%ebp),%eax
f01047a6:	8d 40 04             	lea    0x4(%eax),%eax
f01047a9:	89 45 14             	mov    %eax,0x14(%ebp)
f01047ac:	eb bc                	jmp    f010476a <.L31+0x1f>
		return va_arg(*ap, long);
f01047ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01047b1:	8b 00                	mov    (%eax),%eax
f01047b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01047b6:	99                   	cltd   
f01047b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01047ba:	8b 45 14             	mov    0x14(%ebp),%eax
f01047bd:	8d 40 04             	lea    0x4(%eax),%eax
f01047c0:	89 45 14             	mov    %eax,0x14(%ebp)
f01047c3:	eb a5                	jmp    f010476a <.L31+0x1f>
			num = getint(&ap, lflag);
f01047c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01047c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01047cb:	b8 0a 00 00 00       	mov    $0xa,%eax
f01047d0:	e9 06 01 00 00       	jmp    f01048db <.L35+0x2a>

f01047d5 <.L37>:
f01047d5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f01047d8:	83 f9 01             	cmp    $0x1,%ecx
f01047db:	7e 18                	jle    f01047f5 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
f01047dd:	8b 45 14             	mov    0x14(%ebp),%eax
f01047e0:	8b 10                	mov    (%eax),%edx
f01047e2:	8b 48 04             	mov    0x4(%eax),%ecx
f01047e5:	8d 40 08             	lea    0x8(%eax),%eax
f01047e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01047eb:	b8 0a 00 00 00       	mov    $0xa,%eax
f01047f0:	e9 e6 00 00 00       	jmp    f01048db <.L35+0x2a>
	else if (lflag)
f01047f5:	85 c9                	test   %ecx,%ecx
f01047f7:	75 1a                	jne    f0104813 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
f01047f9:	8b 45 14             	mov    0x14(%ebp),%eax
f01047fc:	8b 10                	mov    (%eax),%edx
f01047fe:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104803:	8d 40 04             	lea    0x4(%eax),%eax
f0104806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104809:	b8 0a 00 00 00       	mov    $0xa,%eax
f010480e:	e9 c8 00 00 00       	jmp    f01048db <.L35+0x2a>
		return va_arg(*ap, unsigned long);
f0104813:	8b 45 14             	mov    0x14(%ebp),%eax
f0104816:	8b 10                	mov    (%eax),%edx
f0104818:	b9 00 00 00 00       	mov    $0x0,%ecx
f010481d:	8d 40 04             	lea    0x4(%eax),%eax
f0104820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104823:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104828:	e9 ae 00 00 00       	jmp    f01048db <.L35+0x2a>

f010482d <.L34>:
f010482d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f0104830:	83 f9 01             	cmp    $0x1,%ecx
f0104833:	7e 3d                	jle    f0104872 <.L34+0x45>
		return va_arg(*ap, long long);
f0104835:	8b 45 14             	mov    0x14(%ebp),%eax
f0104838:	8b 50 04             	mov    0x4(%eax),%edx
f010483b:	8b 00                	mov    (%eax),%eax
f010483d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104840:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104843:	8b 45 14             	mov    0x14(%ebp),%eax
f0104846:	8d 40 08             	lea    0x8(%eax),%eax
f0104849:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
f010484c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0104850:	79 52                	jns    f01048a4 <.L34+0x77>
                putch('-', putdat);
f0104852:	83 ec 08             	sub    $0x8,%esp
f0104855:	56                   	push   %esi
f0104856:	6a 2d                	push   $0x2d
f0104858:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
f010485b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010485e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0104861:	f7 da                	neg    %edx
f0104863:	83 d1 00             	adc    $0x0,%ecx
f0104866:	f7 d9                	neg    %ecx
f0104868:	83 c4 10             	add    $0x10,%esp
            base = 8;
f010486b:	b8 08 00 00 00       	mov    $0x8,%eax
f0104870:	eb 69                	jmp    f01048db <.L35+0x2a>
	else if (lflag)
f0104872:	85 c9                	test   %ecx,%ecx
f0104874:	75 17                	jne    f010488d <.L34+0x60>
		return va_arg(*ap, int);
f0104876:	8b 45 14             	mov    0x14(%ebp),%eax
f0104879:	8b 00                	mov    (%eax),%eax
f010487b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010487e:	99                   	cltd   
f010487f:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104882:	8b 45 14             	mov    0x14(%ebp),%eax
f0104885:	8d 40 04             	lea    0x4(%eax),%eax
f0104888:	89 45 14             	mov    %eax,0x14(%ebp)
f010488b:	eb bf                	jmp    f010484c <.L34+0x1f>
		return va_arg(*ap, long);
f010488d:	8b 45 14             	mov    0x14(%ebp),%eax
f0104890:	8b 00                	mov    (%eax),%eax
f0104892:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104895:	99                   	cltd   
f0104896:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104899:	8b 45 14             	mov    0x14(%ebp),%eax
f010489c:	8d 40 04             	lea    0x4(%eax),%eax
f010489f:	89 45 14             	mov    %eax,0x14(%ebp)
f01048a2:	eb a8                	jmp    f010484c <.L34+0x1f>
            num = getint(&ap, lflag);
f01048a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01048a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
f01048aa:	b8 08 00 00 00       	mov    $0x8,%eax
f01048af:	eb 2a                	jmp    f01048db <.L35+0x2a>

f01048b1 <.L35>:
			putch('0', putdat);
f01048b1:	83 ec 08             	sub    $0x8,%esp
f01048b4:	56                   	push   %esi
f01048b5:	6a 30                	push   $0x30
f01048b7:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f01048ba:	83 c4 08             	add    $0x8,%esp
f01048bd:	56                   	push   %esi
f01048be:	6a 78                	push   $0x78
f01048c0:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f01048c3:	8b 45 14             	mov    0x14(%ebp),%eax
f01048c6:	8b 10                	mov    (%eax),%edx
f01048c8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01048cd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01048d0:	8d 40 04             	lea    0x4(%eax),%eax
f01048d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01048d6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01048db:	83 ec 0c             	sub    $0xc,%esp
f01048de:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f01048e2:	57                   	push   %edi
f01048e3:	ff 75 e0             	pushl  -0x20(%ebp)
f01048e6:	50                   	push   %eax
f01048e7:	51                   	push   %ecx
f01048e8:	52                   	push   %edx
f01048e9:	89 f2                	mov    %esi,%edx
f01048eb:	8b 45 08             	mov    0x8(%ebp),%eax
f01048ee:	e8 e8 fa ff ff       	call   f01043db <printnum>
			break;
f01048f3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f01048f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01048f9:	83 c7 01             	add    $0x1,%edi
f01048fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0104900:	83 f8 25             	cmp    $0x25,%eax
f0104903:	0f 84 f5 fb ff ff    	je     f01044fe <vprintfmt+0x1f>
			if (ch == '\0')
f0104909:	85 c0                	test   %eax,%eax
f010490b:	0f 84 91 00 00 00    	je     f01049a2 <.L22+0x21>
			putch(ch, putdat);
f0104911:	83 ec 08             	sub    $0x8,%esp
f0104914:	56                   	push   %esi
f0104915:	50                   	push   %eax
f0104916:	ff 55 08             	call   *0x8(%ebp)
f0104919:	83 c4 10             	add    $0x10,%esp
f010491c:	eb db                	jmp    f01048f9 <.L35+0x48>

f010491e <.L38>:
f010491e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f0104921:	83 f9 01             	cmp    $0x1,%ecx
f0104924:	7e 15                	jle    f010493b <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
f0104926:	8b 45 14             	mov    0x14(%ebp),%eax
f0104929:	8b 10                	mov    (%eax),%edx
f010492b:	8b 48 04             	mov    0x4(%eax),%ecx
f010492e:	8d 40 08             	lea    0x8(%eax),%eax
f0104931:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104934:	b8 10 00 00 00       	mov    $0x10,%eax
f0104939:	eb a0                	jmp    f01048db <.L35+0x2a>
	else if (lflag)
f010493b:	85 c9                	test   %ecx,%ecx
f010493d:	75 17                	jne    f0104956 <.L38+0x38>
		return va_arg(*ap, unsigned int);
f010493f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104942:	8b 10                	mov    (%eax),%edx
f0104944:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104949:	8d 40 04             	lea    0x4(%eax),%eax
f010494c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010494f:	b8 10 00 00 00       	mov    $0x10,%eax
f0104954:	eb 85                	jmp    f01048db <.L35+0x2a>
		return va_arg(*ap, unsigned long);
f0104956:	8b 45 14             	mov    0x14(%ebp),%eax
f0104959:	8b 10                	mov    (%eax),%edx
f010495b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104960:	8d 40 04             	lea    0x4(%eax),%eax
f0104963:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104966:	b8 10 00 00 00       	mov    $0x10,%eax
f010496b:	e9 6b ff ff ff       	jmp    f01048db <.L35+0x2a>

f0104970 <.L25>:
			putch(ch, putdat);
f0104970:	83 ec 08             	sub    $0x8,%esp
f0104973:	56                   	push   %esi
f0104974:	6a 25                	push   $0x25
f0104976:	ff 55 08             	call   *0x8(%ebp)
			break;
f0104979:	83 c4 10             	add    $0x10,%esp
f010497c:	e9 75 ff ff ff       	jmp    f01048f6 <.L35+0x45>

f0104981 <.L22>:
			putch('%', putdat);
f0104981:	83 ec 08             	sub    $0x8,%esp
f0104984:	56                   	push   %esi
f0104985:	6a 25                	push   $0x25
f0104987:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f010498a:	83 c4 10             	add    $0x10,%esp
f010498d:	89 f8                	mov    %edi,%eax
f010498f:	eb 03                	jmp    f0104994 <.L22+0x13>
f0104991:	83 e8 01             	sub    $0x1,%eax
f0104994:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0104998:	75 f7                	jne    f0104991 <.L22+0x10>
f010499a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010499d:	e9 54 ff ff ff       	jmp    f01048f6 <.L35+0x45>
}
f01049a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01049a5:	5b                   	pop    %ebx
f01049a6:	5e                   	pop    %esi
f01049a7:	5f                   	pop    %edi
f01049a8:	5d                   	pop    %ebp
f01049a9:	c3                   	ret    

f01049aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01049aa:	55                   	push   %ebp
f01049ab:	89 e5                	mov    %esp,%ebp
f01049ad:	53                   	push   %ebx
f01049ae:	83 ec 14             	sub    $0x14,%esp
f01049b1:	e8 88 b8 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01049b6:	81 c3 6a 76 08 00    	add    $0x8766a,%ebx
f01049bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01049bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01049c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01049c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01049c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01049cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01049d3:	85 c0                	test   %eax,%eax
f01049d5:	74 2b                	je     f0104a02 <vsnprintf+0x58>
f01049d7:	85 d2                	test   %edx,%edx
f01049d9:	7e 27                	jle    f0104a02 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01049db:	ff 75 14             	pushl  0x14(%ebp)
f01049de:	ff 75 10             	pushl  0x10(%ebp)
f01049e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01049e4:	50                   	push   %eax
f01049e5:	8d 83 85 84 f7 ff    	lea    -0x87b7b(%ebx),%eax
f01049eb:	50                   	push   %eax
f01049ec:	e8 ee fa ff ff       	call   f01044df <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01049f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01049f4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01049f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01049fa:	83 c4 10             	add    $0x10,%esp
}
f01049fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104a00:	c9                   	leave  
f0104a01:	c3                   	ret    
		return -E_INVAL;
f0104a02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104a07:	eb f4                	jmp    f01049fd <vsnprintf+0x53>

f0104a09 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0104a09:	55                   	push   %ebp
f0104a0a:	89 e5                	mov    %esp,%ebp
f0104a0c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0104a0f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0104a12:	50                   	push   %eax
f0104a13:	ff 75 10             	pushl  0x10(%ebp)
f0104a16:	ff 75 0c             	pushl  0xc(%ebp)
f0104a19:	ff 75 08             	pushl  0x8(%ebp)
f0104a1c:	e8 89 ff ff ff       	call   f01049aa <vsnprintf>
	va_end(ap);

	return rc;
}
f0104a21:	c9                   	leave  
f0104a22:	c3                   	ret    

f0104a23 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104a23:	55                   	push   %ebp
f0104a24:	89 e5                	mov    %esp,%ebp
f0104a26:	57                   	push   %edi
f0104a27:	56                   	push   %esi
f0104a28:	53                   	push   %ebx
f0104a29:	83 ec 1c             	sub    $0x1c,%esp
f0104a2c:	e8 0d b8 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104a31:	81 c3 ef 75 08 00    	add    $0x875ef,%ebx
f0104a37:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0104a3a:	85 c0                	test   %eax,%eax
f0104a3c:	74 13                	je     f0104a51 <readline+0x2e>
		cprintf("%s", prompt);
f0104a3e:	83 ec 08             	sub    $0x8,%esp
f0104a41:	50                   	push   %eax
f0104a42:	8d 83 c3 a5 f7 ff    	lea    -0x85a3d(%ebx),%eax
f0104a48:	50                   	push   %eax
f0104a49:	e8 2f f1 ff ff       	call   f0103b7d <cprintf>
f0104a4e:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0104a51:	83 ec 0c             	sub    $0xc,%esp
f0104a54:	6a 00                	push   $0x0
f0104a56:	e8 7b bd ff ff       	call   f01007d6 <iscons>
f0104a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104a5e:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0104a61:	bf 00 00 00 00       	mov    $0x0,%edi
f0104a66:	eb 46                	jmp    f0104aae <readline+0x8b>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f0104a68:	83 ec 08             	sub    $0x8,%esp
f0104a6b:	50                   	push   %eax
f0104a6c:	8d 83 98 af f7 ff    	lea    -0x85068(%ebx),%eax
f0104a72:	50                   	push   %eax
f0104a73:	e8 05 f1 ff ff       	call   f0103b7d <cprintf>
			return NULL;
f0104a78:	83 c4 10             	add    $0x10,%esp
f0104a7b:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0104a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104a83:	5b                   	pop    %ebx
f0104a84:	5e                   	pop    %esi
f0104a85:	5f                   	pop    %edi
f0104a86:	5d                   	pop    %ebp
f0104a87:	c3                   	ret    
			if (echoing)
f0104a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104a8c:	75 05                	jne    f0104a93 <readline+0x70>
			i--;
f0104a8e:	83 ef 01             	sub    $0x1,%edi
f0104a91:	eb 1b                	jmp    f0104aae <readline+0x8b>
				cputchar('\b');
f0104a93:	83 ec 0c             	sub    $0xc,%esp
f0104a96:	6a 08                	push   $0x8
f0104a98:	e8 18 bd ff ff       	call   f01007b5 <cputchar>
f0104a9d:	83 c4 10             	add    $0x10,%esp
f0104aa0:	eb ec                	jmp    f0104a8e <readline+0x6b>
			buf[i++] = c;
f0104aa2:	89 f0                	mov    %esi,%eax
f0104aa4:	88 84 3b e0 2b 00 00 	mov    %al,0x2be0(%ebx,%edi,1)
f0104aab:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f0104aae:	e8 12 bd ff ff       	call   f01007c5 <getchar>
f0104ab3:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0104ab5:	85 c0                	test   %eax,%eax
f0104ab7:	78 af                	js     f0104a68 <readline+0x45>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104ab9:	83 f8 08             	cmp    $0x8,%eax
f0104abc:	0f 94 c2             	sete   %dl
f0104abf:	83 f8 7f             	cmp    $0x7f,%eax
f0104ac2:	0f 94 c0             	sete   %al
f0104ac5:	08 c2                	or     %al,%dl
f0104ac7:	74 04                	je     f0104acd <readline+0xaa>
f0104ac9:	85 ff                	test   %edi,%edi
f0104acb:	7f bb                	jg     f0104a88 <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0104acd:	83 fe 1f             	cmp    $0x1f,%esi
f0104ad0:	7e 1c                	jle    f0104aee <readline+0xcb>
f0104ad2:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0104ad8:	7f 14                	jg     f0104aee <readline+0xcb>
			if (echoing)
f0104ada:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104ade:	74 c2                	je     f0104aa2 <readline+0x7f>
				cputchar(c);
f0104ae0:	83 ec 0c             	sub    $0xc,%esp
f0104ae3:	56                   	push   %esi
f0104ae4:	e8 cc bc ff ff       	call   f01007b5 <cputchar>
f0104ae9:	83 c4 10             	add    $0x10,%esp
f0104aec:	eb b4                	jmp    f0104aa2 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
f0104aee:	83 fe 0a             	cmp    $0xa,%esi
f0104af1:	74 05                	je     f0104af8 <readline+0xd5>
f0104af3:	83 fe 0d             	cmp    $0xd,%esi
f0104af6:	75 b6                	jne    f0104aae <readline+0x8b>
			if (echoing)
f0104af8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104afc:	75 13                	jne    f0104b11 <readline+0xee>
			buf[i] = 0;
f0104afe:	c6 84 3b e0 2b 00 00 	movb   $0x0,0x2be0(%ebx,%edi,1)
f0104b05:	00 
			return buf;
f0104b06:	8d 83 e0 2b 00 00    	lea    0x2be0(%ebx),%eax
f0104b0c:	e9 6f ff ff ff       	jmp    f0104a80 <readline+0x5d>
				cputchar('\n');
f0104b11:	83 ec 0c             	sub    $0xc,%esp
f0104b14:	6a 0a                	push   $0xa
f0104b16:	e8 9a bc ff ff       	call   f01007b5 <cputchar>
f0104b1b:	83 c4 10             	add    $0x10,%esp
f0104b1e:	eb de                	jmp    f0104afe <readline+0xdb>

f0104b20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0104b20:	55                   	push   %ebp
f0104b21:	89 e5                	mov    %esp,%ebp
f0104b23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104b26:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b2b:	eb 03                	jmp    f0104b30 <strlen+0x10>
		n++;
f0104b2d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0104b30:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0104b34:	75 f7                	jne    f0104b2d <strlen+0xd>
	return n;
}
f0104b36:	5d                   	pop    %ebp
f0104b37:	c3                   	ret    

f0104b38 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104b38:	55                   	push   %ebp
f0104b39:	89 e5                	mov    %esp,%ebp
f0104b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104b41:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b46:	eb 03                	jmp    f0104b4b <strnlen+0x13>
		n++;
f0104b48:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104b4b:	39 d0                	cmp    %edx,%eax
f0104b4d:	74 06                	je     f0104b55 <strnlen+0x1d>
f0104b4f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0104b53:	75 f3                	jne    f0104b48 <strnlen+0x10>
	return n;
}
f0104b55:	5d                   	pop    %ebp
f0104b56:	c3                   	ret    

f0104b57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0104b57:	55                   	push   %ebp
f0104b58:	89 e5                	mov    %esp,%ebp
f0104b5a:	53                   	push   %ebx
f0104b5b:	8b 45 08             	mov    0x8(%ebp),%eax
f0104b5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0104b61:	89 c2                	mov    %eax,%edx
f0104b63:	83 c1 01             	add    $0x1,%ecx
f0104b66:	83 c2 01             	add    $0x1,%edx
f0104b69:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0104b6d:	88 5a ff             	mov    %bl,-0x1(%edx)
f0104b70:	84 db                	test   %bl,%bl
f0104b72:	75 ef                	jne    f0104b63 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0104b74:	5b                   	pop    %ebx
f0104b75:	5d                   	pop    %ebp
f0104b76:	c3                   	ret    

f0104b77 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0104b77:	55                   	push   %ebp
f0104b78:	89 e5                	mov    %esp,%ebp
f0104b7a:	53                   	push   %ebx
f0104b7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0104b7e:	53                   	push   %ebx
f0104b7f:	e8 9c ff ff ff       	call   f0104b20 <strlen>
f0104b84:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0104b87:	ff 75 0c             	pushl  0xc(%ebp)
f0104b8a:	01 d8                	add    %ebx,%eax
f0104b8c:	50                   	push   %eax
f0104b8d:	e8 c5 ff ff ff       	call   f0104b57 <strcpy>
	return dst;
}
f0104b92:	89 d8                	mov    %ebx,%eax
f0104b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104b97:	c9                   	leave  
f0104b98:	c3                   	ret    

f0104b99 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0104b99:	55                   	push   %ebp
f0104b9a:	89 e5                	mov    %esp,%ebp
f0104b9c:	56                   	push   %esi
f0104b9d:	53                   	push   %ebx
f0104b9e:	8b 75 08             	mov    0x8(%ebp),%esi
f0104ba1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104ba4:	89 f3                	mov    %esi,%ebx
f0104ba6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0104ba9:	89 f2                	mov    %esi,%edx
f0104bab:	eb 0f                	jmp    f0104bbc <strncpy+0x23>
		*dst++ = *src;
f0104bad:	83 c2 01             	add    $0x1,%edx
f0104bb0:	0f b6 01             	movzbl (%ecx),%eax
f0104bb3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0104bb6:	80 39 01             	cmpb   $0x1,(%ecx)
f0104bb9:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f0104bbc:	39 da                	cmp    %ebx,%edx
f0104bbe:	75 ed                	jne    f0104bad <strncpy+0x14>
	}
	return ret;
}
f0104bc0:	89 f0                	mov    %esi,%eax
f0104bc2:	5b                   	pop    %ebx
f0104bc3:	5e                   	pop    %esi
f0104bc4:	5d                   	pop    %ebp
f0104bc5:	c3                   	ret    

f0104bc6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0104bc6:	55                   	push   %ebp
f0104bc7:	89 e5                	mov    %esp,%ebp
f0104bc9:	56                   	push   %esi
f0104bca:	53                   	push   %ebx
f0104bcb:	8b 75 08             	mov    0x8(%ebp),%esi
f0104bce:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104bd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104bd4:	89 f0                	mov    %esi,%eax
f0104bd6:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0104bda:	85 c9                	test   %ecx,%ecx
f0104bdc:	75 0b                	jne    f0104be9 <strlcpy+0x23>
f0104bde:	eb 17                	jmp    f0104bf7 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0104be0:	83 c2 01             	add    $0x1,%edx
f0104be3:	83 c0 01             	add    $0x1,%eax
f0104be6:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0104be9:	39 d8                	cmp    %ebx,%eax
f0104beb:	74 07                	je     f0104bf4 <strlcpy+0x2e>
f0104bed:	0f b6 0a             	movzbl (%edx),%ecx
f0104bf0:	84 c9                	test   %cl,%cl
f0104bf2:	75 ec                	jne    f0104be0 <strlcpy+0x1a>
		*dst = '\0';
f0104bf4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0104bf7:	29 f0                	sub    %esi,%eax
}
f0104bf9:	5b                   	pop    %ebx
f0104bfa:	5e                   	pop    %esi
f0104bfb:	5d                   	pop    %ebp
f0104bfc:	c3                   	ret    

f0104bfd <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0104bfd:	55                   	push   %ebp
f0104bfe:	89 e5                	mov    %esp,%ebp
f0104c00:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104c03:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0104c06:	eb 06                	jmp    f0104c0e <strcmp+0x11>
		p++, q++;
f0104c08:	83 c1 01             	add    $0x1,%ecx
f0104c0b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0104c0e:	0f b6 01             	movzbl (%ecx),%eax
f0104c11:	84 c0                	test   %al,%al
f0104c13:	74 04                	je     f0104c19 <strcmp+0x1c>
f0104c15:	3a 02                	cmp    (%edx),%al
f0104c17:	74 ef                	je     f0104c08 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0104c19:	0f b6 c0             	movzbl %al,%eax
f0104c1c:	0f b6 12             	movzbl (%edx),%edx
f0104c1f:	29 d0                	sub    %edx,%eax
}
f0104c21:	5d                   	pop    %ebp
f0104c22:	c3                   	ret    

f0104c23 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0104c23:	55                   	push   %ebp
f0104c24:	89 e5                	mov    %esp,%ebp
f0104c26:	53                   	push   %ebx
f0104c27:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104c2d:	89 c3                	mov    %eax,%ebx
f0104c2f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0104c32:	eb 06                	jmp    f0104c3a <strncmp+0x17>
		n--, p++, q++;
f0104c34:	83 c0 01             	add    $0x1,%eax
f0104c37:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0104c3a:	39 d8                	cmp    %ebx,%eax
f0104c3c:	74 16                	je     f0104c54 <strncmp+0x31>
f0104c3e:	0f b6 08             	movzbl (%eax),%ecx
f0104c41:	84 c9                	test   %cl,%cl
f0104c43:	74 04                	je     f0104c49 <strncmp+0x26>
f0104c45:	3a 0a                	cmp    (%edx),%cl
f0104c47:	74 eb                	je     f0104c34 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0104c49:	0f b6 00             	movzbl (%eax),%eax
f0104c4c:	0f b6 12             	movzbl (%edx),%edx
f0104c4f:	29 d0                	sub    %edx,%eax
}
f0104c51:	5b                   	pop    %ebx
f0104c52:	5d                   	pop    %ebp
f0104c53:	c3                   	ret    
		return 0;
f0104c54:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c59:	eb f6                	jmp    f0104c51 <strncmp+0x2e>

f0104c5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0104c5b:	55                   	push   %ebp
f0104c5c:	89 e5                	mov    %esp,%ebp
f0104c5e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0104c65:	0f b6 10             	movzbl (%eax),%edx
f0104c68:	84 d2                	test   %dl,%dl
f0104c6a:	74 09                	je     f0104c75 <strchr+0x1a>
		if (*s == c)
f0104c6c:	38 ca                	cmp    %cl,%dl
f0104c6e:	74 0a                	je     f0104c7a <strchr+0x1f>
	for (; *s; s++)
f0104c70:	83 c0 01             	add    $0x1,%eax
f0104c73:	eb f0                	jmp    f0104c65 <strchr+0xa>
			return (char *) s;
	return 0;
f0104c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104c7a:	5d                   	pop    %ebp
f0104c7b:	c3                   	ret    

f0104c7c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0104c7c:	55                   	push   %ebp
f0104c7d:	89 e5                	mov    %esp,%ebp
f0104c7f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c82:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0104c86:	eb 03                	jmp    f0104c8b <strfind+0xf>
f0104c88:	83 c0 01             	add    $0x1,%eax
f0104c8b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0104c8e:	38 ca                	cmp    %cl,%dl
f0104c90:	74 04                	je     f0104c96 <strfind+0x1a>
f0104c92:	84 d2                	test   %dl,%dl
f0104c94:	75 f2                	jne    f0104c88 <strfind+0xc>
			break;
	return (char *) s;
}
f0104c96:	5d                   	pop    %ebp
f0104c97:	c3                   	ret    

f0104c98 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0104c98:	55                   	push   %ebp
f0104c99:	89 e5                	mov    %esp,%ebp
f0104c9b:	57                   	push   %edi
f0104c9c:	56                   	push   %esi
f0104c9d:	53                   	push   %ebx
f0104c9e:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104ca1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0104ca4:	85 c9                	test   %ecx,%ecx
f0104ca6:	74 13                	je     f0104cbb <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0104ca8:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104cae:	75 05                	jne    f0104cb5 <memset+0x1d>
f0104cb0:	f6 c1 03             	test   $0x3,%cl
f0104cb3:	74 0d                	je     f0104cc2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0104cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cb8:	fc                   	cld    
f0104cb9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0104cbb:	89 f8                	mov    %edi,%eax
f0104cbd:	5b                   	pop    %ebx
f0104cbe:	5e                   	pop    %esi
f0104cbf:	5f                   	pop    %edi
f0104cc0:	5d                   	pop    %ebp
f0104cc1:	c3                   	ret    
		c &= 0xFF;
f0104cc2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0104cc6:	89 d3                	mov    %edx,%ebx
f0104cc8:	c1 e3 08             	shl    $0x8,%ebx
f0104ccb:	89 d0                	mov    %edx,%eax
f0104ccd:	c1 e0 18             	shl    $0x18,%eax
f0104cd0:	89 d6                	mov    %edx,%esi
f0104cd2:	c1 e6 10             	shl    $0x10,%esi
f0104cd5:	09 f0                	or     %esi,%eax
f0104cd7:	09 c2                	or     %eax,%edx
f0104cd9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0104cdb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0104cde:	89 d0                	mov    %edx,%eax
f0104ce0:	fc                   	cld    
f0104ce1:	f3 ab                	rep stos %eax,%es:(%edi)
f0104ce3:	eb d6                	jmp    f0104cbb <memset+0x23>

f0104ce5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0104ce5:	55                   	push   %ebp
f0104ce6:	89 e5                	mov    %esp,%ebp
f0104ce8:	57                   	push   %edi
f0104ce9:	56                   	push   %esi
f0104cea:	8b 45 08             	mov    0x8(%ebp),%eax
f0104ced:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104cf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0104cf3:	39 c6                	cmp    %eax,%esi
f0104cf5:	73 35                	jae    f0104d2c <memmove+0x47>
f0104cf7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0104cfa:	39 c2                	cmp    %eax,%edx
f0104cfc:	76 2e                	jbe    f0104d2c <memmove+0x47>
		s += n;
		d += n;
f0104cfe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d01:	89 d6                	mov    %edx,%esi
f0104d03:	09 fe                	or     %edi,%esi
f0104d05:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0104d0b:	74 0c                	je     f0104d19 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0104d0d:	83 ef 01             	sub    $0x1,%edi
f0104d10:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0104d13:	fd                   	std    
f0104d14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0104d16:	fc                   	cld    
f0104d17:	eb 21                	jmp    f0104d3a <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d19:	f6 c1 03             	test   $0x3,%cl
f0104d1c:	75 ef                	jne    f0104d0d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0104d1e:	83 ef 04             	sub    $0x4,%edi
f0104d21:	8d 72 fc             	lea    -0x4(%edx),%esi
f0104d24:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0104d27:	fd                   	std    
f0104d28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104d2a:	eb ea                	jmp    f0104d16 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d2c:	89 f2                	mov    %esi,%edx
f0104d2e:	09 c2                	or     %eax,%edx
f0104d30:	f6 c2 03             	test   $0x3,%dl
f0104d33:	74 09                	je     f0104d3e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0104d35:	89 c7                	mov    %eax,%edi
f0104d37:	fc                   	cld    
f0104d38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0104d3a:	5e                   	pop    %esi
f0104d3b:	5f                   	pop    %edi
f0104d3c:	5d                   	pop    %ebp
f0104d3d:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d3e:	f6 c1 03             	test   $0x3,%cl
f0104d41:	75 f2                	jne    f0104d35 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0104d43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0104d46:	89 c7                	mov    %eax,%edi
f0104d48:	fc                   	cld    
f0104d49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104d4b:	eb ed                	jmp    f0104d3a <memmove+0x55>

f0104d4d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0104d4d:	55                   	push   %ebp
f0104d4e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0104d50:	ff 75 10             	pushl  0x10(%ebp)
f0104d53:	ff 75 0c             	pushl  0xc(%ebp)
f0104d56:	ff 75 08             	pushl  0x8(%ebp)
f0104d59:	e8 87 ff ff ff       	call   f0104ce5 <memmove>
}
f0104d5e:	c9                   	leave  
f0104d5f:	c3                   	ret    

f0104d60 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0104d60:	55                   	push   %ebp
f0104d61:	89 e5                	mov    %esp,%ebp
f0104d63:	56                   	push   %esi
f0104d64:	53                   	push   %ebx
f0104d65:	8b 45 08             	mov    0x8(%ebp),%eax
f0104d68:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104d6b:	89 c6                	mov    %eax,%esi
f0104d6d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0104d70:	39 f0                	cmp    %esi,%eax
f0104d72:	74 1c                	je     f0104d90 <memcmp+0x30>
		if (*s1 != *s2)
f0104d74:	0f b6 08             	movzbl (%eax),%ecx
f0104d77:	0f b6 1a             	movzbl (%edx),%ebx
f0104d7a:	38 d9                	cmp    %bl,%cl
f0104d7c:	75 08                	jne    f0104d86 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0104d7e:	83 c0 01             	add    $0x1,%eax
f0104d81:	83 c2 01             	add    $0x1,%edx
f0104d84:	eb ea                	jmp    f0104d70 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0104d86:	0f b6 c1             	movzbl %cl,%eax
f0104d89:	0f b6 db             	movzbl %bl,%ebx
f0104d8c:	29 d8                	sub    %ebx,%eax
f0104d8e:	eb 05                	jmp    f0104d95 <memcmp+0x35>
	}

	return 0;
f0104d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104d95:	5b                   	pop    %ebx
f0104d96:	5e                   	pop    %esi
f0104d97:	5d                   	pop    %ebp
f0104d98:	c3                   	ret    

f0104d99 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0104d99:	55                   	push   %ebp
f0104d9a:	89 e5                	mov    %esp,%ebp
f0104d9c:	8b 45 08             	mov    0x8(%ebp),%eax
f0104d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0104da2:	89 c2                	mov    %eax,%edx
f0104da4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0104da7:	39 d0                	cmp    %edx,%eax
f0104da9:	73 09                	jae    f0104db4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0104dab:	38 08                	cmp    %cl,(%eax)
f0104dad:	74 05                	je     f0104db4 <memfind+0x1b>
	for (; s < ends; s++)
f0104daf:	83 c0 01             	add    $0x1,%eax
f0104db2:	eb f3                	jmp    f0104da7 <memfind+0xe>
			break;
	return (void *) s;
}
f0104db4:	5d                   	pop    %ebp
f0104db5:	c3                   	ret    

f0104db6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0104db6:	55                   	push   %ebp
f0104db7:	89 e5                	mov    %esp,%ebp
f0104db9:	57                   	push   %edi
f0104dba:	56                   	push   %esi
f0104dbb:	53                   	push   %ebx
f0104dbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104dbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0104dc2:	eb 03                	jmp    f0104dc7 <strtol+0x11>
		s++;
f0104dc4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0104dc7:	0f b6 01             	movzbl (%ecx),%eax
f0104dca:	3c 20                	cmp    $0x20,%al
f0104dcc:	74 f6                	je     f0104dc4 <strtol+0xe>
f0104dce:	3c 09                	cmp    $0x9,%al
f0104dd0:	74 f2                	je     f0104dc4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0104dd2:	3c 2b                	cmp    $0x2b,%al
f0104dd4:	74 2e                	je     f0104e04 <strtol+0x4e>
	int neg = 0;
f0104dd6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0104ddb:	3c 2d                	cmp    $0x2d,%al
f0104ddd:	74 2f                	je     f0104e0e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0104ddf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0104de5:	75 05                	jne    f0104dec <strtol+0x36>
f0104de7:	80 39 30             	cmpb   $0x30,(%ecx)
f0104dea:	74 2c                	je     f0104e18 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0104dec:	85 db                	test   %ebx,%ebx
f0104dee:	75 0a                	jne    f0104dfa <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0104df0:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f0104df5:	80 39 30             	cmpb   $0x30,(%ecx)
f0104df8:	74 28                	je     f0104e22 <strtol+0x6c>
		base = 10;
f0104dfa:	b8 00 00 00 00       	mov    $0x0,%eax
f0104dff:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0104e02:	eb 50                	jmp    f0104e54 <strtol+0x9e>
		s++;
f0104e04:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0104e07:	bf 00 00 00 00       	mov    $0x0,%edi
f0104e0c:	eb d1                	jmp    f0104ddf <strtol+0x29>
		s++, neg = 1;
f0104e0e:	83 c1 01             	add    $0x1,%ecx
f0104e11:	bf 01 00 00 00       	mov    $0x1,%edi
f0104e16:	eb c7                	jmp    f0104ddf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0104e18:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0104e1c:	74 0e                	je     f0104e2c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0104e1e:	85 db                	test   %ebx,%ebx
f0104e20:	75 d8                	jne    f0104dfa <strtol+0x44>
		s++, base = 8;
f0104e22:	83 c1 01             	add    $0x1,%ecx
f0104e25:	bb 08 00 00 00       	mov    $0x8,%ebx
f0104e2a:	eb ce                	jmp    f0104dfa <strtol+0x44>
		s += 2, base = 16;
f0104e2c:	83 c1 02             	add    $0x2,%ecx
f0104e2f:	bb 10 00 00 00       	mov    $0x10,%ebx
f0104e34:	eb c4                	jmp    f0104dfa <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0104e36:	8d 72 9f             	lea    -0x61(%edx),%esi
f0104e39:	89 f3                	mov    %esi,%ebx
f0104e3b:	80 fb 19             	cmp    $0x19,%bl
f0104e3e:	77 29                	ja     f0104e69 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0104e40:	0f be d2             	movsbl %dl,%edx
f0104e43:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0104e46:	3b 55 10             	cmp    0x10(%ebp),%edx
f0104e49:	7d 30                	jge    f0104e7b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0104e4b:	83 c1 01             	add    $0x1,%ecx
f0104e4e:	0f af 45 10          	imul   0x10(%ebp),%eax
f0104e52:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0104e54:	0f b6 11             	movzbl (%ecx),%edx
f0104e57:	8d 72 d0             	lea    -0x30(%edx),%esi
f0104e5a:	89 f3                	mov    %esi,%ebx
f0104e5c:	80 fb 09             	cmp    $0x9,%bl
f0104e5f:	77 d5                	ja     f0104e36 <strtol+0x80>
			dig = *s - '0';
f0104e61:	0f be d2             	movsbl %dl,%edx
f0104e64:	83 ea 30             	sub    $0x30,%edx
f0104e67:	eb dd                	jmp    f0104e46 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0104e69:	8d 72 bf             	lea    -0x41(%edx),%esi
f0104e6c:	89 f3                	mov    %esi,%ebx
f0104e6e:	80 fb 19             	cmp    $0x19,%bl
f0104e71:	77 08                	ja     f0104e7b <strtol+0xc5>
			dig = *s - 'A' + 10;
f0104e73:	0f be d2             	movsbl %dl,%edx
f0104e76:	83 ea 37             	sub    $0x37,%edx
f0104e79:	eb cb                	jmp    f0104e46 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0104e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0104e7f:	74 05                	je     f0104e86 <strtol+0xd0>
		*endptr = (char *) s;
f0104e81:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104e84:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0104e86:	89 c2                	mov    %eax,%edx
f0104e88:	f7 da                	neg    %edx
f0104e8a:	85 ff                	test   %edi,%edi
f0104e8c:	0f 45 c2             	cmovne %edx,%eax
}
f0104e8f:	5b                   	pop    %ebx
f0104e90:	5e                   	pop    %esi
f0104e91:	5f                   	pop    %edi
f0104e92:	5d                   	pop    %ebp
f0104e93:	c3                   	ret    
f0104e94:	66 90                	xchg   %ax,%ax
f0104e96:	66 90                	xchg   %ax,%ax
f0104e98:	66 90                	xchg   %ax,%ax
f0104e9a:	66 90                	xchg   %ax,%ax
f0104e9c:	66 90                	xchg   %ax,%ax
f0104e9e:	66 90                	xchg   %ax,%ax

f0104ea0 <__udivdi3>:
f0104ea0:	55                   	push   %ebp
f0104ea1:	57                   	push   %edi
f0104ea2:	56                   	push   %esi
f0104ea3:	53                   	push   %ebx
f0104ea4:	83 ec 1c             	sub    $0x1c,%esp
f0104ea7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0104eab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0104eaf:	8b 74 24 34          	mov    0x34(%esp),%esi
f0104eb3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0104eb7:	85 d2                	test   %edx,%edx
f0104eb9:	75 35                	jne    f0104ef0 <__udivdi3+0x50>
f0104ebb:	39 f3                	cmp    %esi,%ebx
f0104ebd:	0f 87 bd 00 00 00    	ja     f0104f80 <__udivdi3+0xe0>
f0104ec3:	85 db                	test   %ebx,%ebx
f0104ec5:	89 d9                	mov    %ebx,%ecx
f0104ec7:	75 0b                	jne    f0104ed4 <__udivdi3+0x34>
f0104ec9:	b8 01 00 00 00       	mov    $0x1,%eax
f0104ece:	31 d2                	xor    %edx,%edx
f0104ed0:	f7 f3                	div    %ebx
f0104ed2:	89 c1                	mov    %eax,%ecx
f0104ed4:	31 d2                	xor    %edx,%edx
f0104ed6:	89 f0                	mov    %esi,%eax
f0104ed8:	f7 f1                	div    %ecx
f0104eda:	89 c6                	mov    %eax,%esi
f0104edc:	89 e8                	mov    %ebp,%eax
f0104ede:	89 f7                	mov    %esi,%edi
f0104ee0:	f7 f1                	div    %ecx
f0104ee2:	89 fa                	mov    %edi,%edx
f0104ee4:	83 c4 1c             	add    $0x1c,%esp
f0104ee7:	5b                   	pop    %ebx
f0104ee8:	5e                   	pop    %esi
f0104ee9:	5f                   	pop    %edi
f0104eea:	5d                   	pop    %ebp
f0104eeb:	c3                   	ret    
f0104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104ef0:	39 f2                	cmp    %esi,%edx
f0104ef2:	77 7c                	ja     f0104f70 <__udivdi3+0xd0>
f0104ef4:	0f bd fa             	bsr    %edx,%edi
f0104ef7:	83 f7 1f             	xor    $0x1f,%edi
f0104efa:	0f 84 98 00 00 00    	je     f0104f98 <__udivdi3+0xf8>
f0104f00:	89 f9                	mov    %edi,%ecx
f0104f02:	b8 20 00 00 00       	mov    $0x20,%eax
f0104f07:	29 f8                	sub    %edi,%eax
f0104f09:	d3 e2                	shl    %cl,%edx
f0104f0b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104f0f:	89 c1                	mov    %eax,%ecx
f0104f11:	89 da                	mov    %ebx,%edx
f0104f13:	d3 ea                	shr    %cl,%edx
f0104f15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0104f19:	09 d1                	or     %edx,%ecx
f0104f1b:	89 f2                	mov    %esi,%edx
f0104f1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0104f21:	89 f9                	mov    %edi,%ecx
f0104f23:	d3 e3                	shl    %cl,%ebx
f0104f25:	89 c1                	mov    %eax,%ecx
f0104f27:	d3 ea                	shr    %cl,%edx
f0104f29:	89 f9                	mov    %edi,%ecx
f0104f2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0104f2f:	d3 e6                	shl    %cl,%esi
f0104f31:	89 eb                	mov    %ebp,%ebx
f0104f33:	89 c1                	mov    %eax,%ecx
f0104f35:	d3 eb                	shr    %cl,%ebx
f0104f37:	09 de                	or     %ebx,%esi
f0104f39:	89 f0                	mov    %esi,%eax
f0104f3b:	f7 74 24 08          	divl   0x8(%esp)
f0104f3f:	89 d6                	mov    %edx,%esi
f0104f41:	89 c3                	mov    %eax,%ebx
f0104f43:	f7 64 24 0c          	mull   0xc(%esp)
f0104f47:	39 d6                	cmp    %edx,%esi
f0104f49:	72 0c                	jb     f0104f57 <__udivdi3+0xb7>
f0104f4b:	89 f9                	mov    %edi,%ecx
f0104f4d:	d3 e5                	shl    %cl,%ebp
f0104f4f:	39 c5                	cmp    %eax,%ebp
f0104f51:	73 5d                	jae    f0104fb0 <__udivdi3+0x110>
f0104f53:	39 d6                	cmp    %edx,%esi
f0104f55:	75 59                	jne    f0104fb0 <__udivdi3+0x110>
f0104f57:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0104f5a:	31 ff                	xor    %edi,%edi
f0104f5c:	89 fa                	mov    %edi,%edx
f0104f5e:	83 c4 1c             	add    $0x1c,%esp
f0104f61:	5b                   	pop    %ebx
f0104f62:	5e                   	pop    %esi
f0104f63:	5f                   	pop    %edi
f0104f64:	5d                   	pop    %ebp
f0104f65:	c3                   	ret    
f0104f66:	8d 76 00             	lea    0x0(%esi),%esi
f0104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0104f70:	31 ff                	xor    %edi,%edi
f0104f72:	31 c0                	xor    %eax,%eax
f0104f74:	89 fa                	mov    %edi,%edx
f0104f76:	83 c4 1c             	add    $0x1c,%esp
f0104f79:	5b                   	pop    %ebx
f0104f7a:	5e                   	pop    %esi
f0104f7b:	5f                   	pop    %edi
f0104f7c:	5d                   	pop    %ebp
f0104f7d:	c3                   	ret    
f0104f7e:	66 90                	xchg   %ax,%ax
f0104f80:	31 ff                	xor    %edi,%edi
f0104f82:	89 e8                	mov    %ebp,%eax
f0104f84:	89 f2                	mov    %esi,%edx
f0104f86:	f7 f3                	div    %ebx
f0104f88:	89 fa                	mov    %edi,%edx
f0104f8a:	83 c4 1c             	add    $0x1c,%esp
f0104f8d:	5b                   	pop    %ebx
f0104f8e:	5e                   	pop    %esi
f0104f8f:	5f                   	pop    %edi
f0104f90:	5d                   	pop    %ebp
f0104f91:	c3                   	ret    
f0104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0104f98:	39 f2                	cmp    %esi,%edx
f0104f9a:	72 06                	jb     f0104fa2 <__udivdi3+0x102>
f0104f9c:	31 c0                	xor    %eax,%eax
f0104f9e:	39 eb                	cmp    %ebp,%ebx
f0104fa0:	77 d2                	ja     f0104f74 <__udivdi3+0xd4>
f0104fa2:	b8 01 00 00 00       	mov    $0x1,%eax
f0104fa7:	eb cb                	jmp    f0104f74 <__udivdi3+0xd4>
f0104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0104fb0:	89 d8                	mov    %ebx,%eax
f0104fb2:	31 ff                	xor    %edi,%edi
f0104fb4:	eb be                	jmp    f0104f74 <__udivdi3+0xd4>
f0104fb6:	66 90                	xchg   %ax,%ax
f0104fb8:	66 90                	xchg   %ax,%ax
f0104fba:	66 90                	xchg   %ax,%ax
f0104fbc:	66 90                	xchg   %ax,%ax
f0104fbe:	66 90                	xchg   %ax,%ax

f0104fc0 <__umoddi3>:
f0104fc0:	55                   	push   %ebp
f0104fc1:	57                   	push   %edi
f0104fc2:	56                   	push   %esi
f0104fc3:	53                   	push   %ebx
f0104fc4:	83 ec 1c             	sub    $0x1c,%esp
f0104fc7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f0104fcb:	8b 74 24 30          	mov    0x30(%esp),%esi
f0104fcf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0104fd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0104fd7:	85 ed                	test   %ebp,%ebp
f0104fd9:	89 f0                	mov    %esi,%eax
f0104fdb:	89 da                	mov    %ebx,%edx
f0104fdd:	75 19                	jne    f0104ff8 <__umoddi3+0x38>
f0104fdf:	39 df                	cmp    %ebx,%edi
f0104fe1:	0f 86 b1 00 00 00    	jbe    f0105098 <__umoddi3+0xd8>
f0104fe7:	f7 f7                	div    %edi
f0104fe9:	89 d0                	mov    %edx,%eax
f0104feb:	31 d2                	xor    %edx,%edx
f0104fed:	83 c4 1c             	add    $0x1c,%esp
f0104ff0:	5b                   	pop    %ebx
f0104ff1:	5e                   	pop    %esi
f0104ff2:	5f                   	pop    %edi
f0104ff3:	5d                   	pop    %ebp
f0104ff4:	c3                   	ret    
f0104ff5:	8d 76 00             	lea    0x0(%esi),%esi
f0104ff8:	39 dd                	cmp    %ebx,%ebp
f0104ffa:	77 f1                	ja     f0104fed <__umoddi3+0x2d>
f0104ffc:	0f bd cd             	bsr    %ebp,%ecx
f0104fff:	83 f1 1f             	xor    $0x1f,%ecx
f0105002:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105006:	0f 84 b4 00 00 00    	je     f01050c0 <__umoddi3+0x100>
f010500c:	b8 20 00 00 00       	mov    $0x20,%eax
f0105011:	89 c2                	mov    %eax,%edx
f0105013:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105017:	29 c2                	sub    %eax,%edx
f0105019:	89 c1                	mov    %eax,%ecx
f010501b:	89 f8                	mov    %edi,%eax
f010501d:	d3 e5                	shl    %cl,%ebp
f010501f:	89 d1                	mov    %edx,%ecx
f0105021:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105025:	d3 e8                	shr    %cl,%eax
f0105027:	09 c5                	or     %eax,%ebp
f0105029:	8b 44 24 04          	mov    0x4(%esp),%eax
f010502d:	89 c1                	mov    %eax,%ecx
f010502f:	d3 e7                	shl    %cl,%edi
f0105031:	89 d1                	mov    %edx,%ecx
f0105033:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105037:	89 df                	mov    %ebx,%edi
f0105039:	d3 ef                	shr    %cl,%edi
f010503b:	89 c1                	mov    %eax,%ecx
f010503d:	89 f0                	mov    %esi,%eax
f010503f:	d3 e3                	shl    %cl,%ebx
f0105041:	89 d1                	mov    %edx,%ecx
f0105043:	89 fa                	mov    %edi,%edx
f0105045:	d3 e8                	shr    %cl,%eax
f0105047:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010504c:	09 d8                	or     %ebx,%eax
f010504e:	f7 f5                	div    %ebp
f0105050:	d3 e6                	shl    %cl,%esi
f0105052:	89 d1                	mov    %edx,%ecx
f0105054:	f7 64 24 08          	mull   0x8(%esp)
f0105058:	39 d1                	cmp    %edx,%ecx
f010505a:	89 c3                	mov    %eax,%ebx
f010505c:	89 d7                	mov    %edx,%edi
f010505e:	72 06                	jb     f0105066 <__umoddi3+0xa6>
f0105060:	75 0e                	jne    f0105070 <__umoddi3+0xb0>
f0105062:	39 c6                	cmp    %eax,%esi
f0105064:	73 0a                	jae    f0105070 <__umoddi3+0xb0>
f0105066:	2b 44 24 08          	sub    0x8(%esp),%eax
f010506a:	19 ea                	sbb    %ebp,%edx
f010506c:	89 d7                	mov    %edx,%edi
f010506e:	89 c3                	mov    %eax,%ebx
f0105070:	89 ca                	mov    %ecx,%edx
f0105072:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0105077:	29 de                	sub    %ebx,%esi
f0105079:	19 fa                	sbb    %edi,%edx
f010507b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f010507f:	89 d0                	mov    %edx,%eax
f0105081:	d3 e0                	shl    %cl,%eax
f0105083:	89 d9                	mov    %ebx,%ecx
f0105085:	d3 ee                	shr    %cl,%esi
f0105087:	d3 ea                	shr    %cl,%edx
f0105089:	09 f0                	or     %esi,%eax
f010508b:	83 c4 1c             	add    $0x1c,%esp
f010508e:	5b                   	pop    %ebx
f010508f:	5e                   	pop    %esi
f0105090:	5f                   	pop    %edi
f0105091:	5d                   	pop    %ebp
f0105092:	c3                   	ret    
f0105093:	90                   	nop
f0105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105098:	85 ff                	test   %edi,%edi
f010509a:	89 f9                	mov    %edi,%ecx
f010509c:	75 0b                	jne    f01050a9 <__umoddi3+0xe9>
f010509e:	b8 01 00 00 00       	mov    $0x1,%eax
f01050a3:	31 d2                	xor    %edx,%edx
f01050a5:	f7 f7                	div    %edi
f01050a7:	89 c1                	mov    %eax,%ecx
f01050a9:	89 d8                	mov    %ebx,%eax
f01050ab:	31 d2                	xor    %edx,%edx
f01050ad:	f7 f1                	div    %ecx
f01050af:	89 f0                	mov    %esi,%eax
f01050b1:	f7 f1                	div    %ecx
f01050b3:	e9 31 ff ff ff       	jmp    f0104fe9 <__umoddi3+0x29>
f01050b8:	90                   	nop
f01050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01050c0:	39 dd                	cmp    %ebx,%ebp
f01050c2:	72 08                	jb     f01050cc <__umoddi3+0x10c>
f01050c4:	39 f7                	cmp    %esi,%edi
f01050c6:	0f 87 21 ff ff ff    	ja     f0104fed <__umoddi3+0x2d>
f01050cc:	89 da                	mov    %ebx,%edx
f01050ce:	89 f0                	mov    %esi,%eax
f01050d0:	29 f8                	sub    %edi,%eax
f01050d2:	19 ea                	sbb    %ebp,%edx
f01050d4:	e9 14 ff ff ff       	jmp    f0104fed <__umoddi3+0x2d>
