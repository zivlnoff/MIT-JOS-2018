
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
f0100015:	b8 00 f0 18 00       	mov    $0x18f000,%eax
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
f0100034:	bc 00 c0 11 f0       	mov    $0xf011c000,%esp

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
f010004a:	81 c3 36 e0 08 00    	add    $0x8e036,%ebx
f0100050:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("entering test_backtrace %d\n", x);
f0100053:	83 ec 08             	sub    $0x8,%esp
f0100056:	56                   	push   %esi
f0100057:	8d 83 e0 79 f7 ff    	lea    -0x88620(%ebx),%eax
f010005d:	50                   	push   %eax
f010005e:	e8 03 41 00 00       	call   f0104166 <cprintf>
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
f010007f:	8d 83 fc 79 f7 ff    	lea    -0x88604(%ebx),%eax
f0100085:	50                   	push   %eax
f0100086:	e8 db 40 00 00       	call   f0104166 <cprintf>
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
f01000b2:	81 c3 ce df 08 00    	add    $0x8dfce,%ebx
    // Before doing anything else, complete the ELF loading process.
    // Clear the uninitialized global data (BSS) section of our program.
    // This ensures that all static/global variables start out zero.

    //我目前觉得不应该这么做，可能我对.bss段不太了解，哦，我对调试用的符号表也没有很熟悉
    memset(edata, 0, end - edata);
f01000b8:	c7 c0 14 10 19 f0    	mov    $0xf0191014,%eax
f01000be:	c7 c2 00 01 19 f0    	mov    $0xf0190100,%edx
f01000c4:	29 d0                	sub    %edx,%eax
f01000c6:	50                   	push   %eax
f01000c7:	6a 00                	push   $0x0
f01000c9:	52                   	push   %edx
f01000ca:	e8 49 55 00 00       	call   f0105618 <memset>

    // Initialize the console.
    // Can't call cprintf until after we do this!
    cons_init();
f01000cf:	e8 bf 05 00 00       	call   f0100693 <cons_init>

    cprintf("\nlab1 start------------------------------------------------------------------------------------------------\n");
f01000d4:	8d 83 70 7a f7 ff    	lea    -0x88590(%ebx),%eax
f01000da:	89 04 24             	mov    %eax,(%esp)
f01000dd:	e8 84 40 00 00       	call   f0104166 <cprintf>

    cprintf("6828 decimal is %o octal!\n", 6828);
f01000e2:	83 c4 08             	add    $0x8,%esp
f01000e5:	68 ac 1a 00 00       	push   $0x1aac
f01000ea:	8d 83 17 7a f7 ff    	lea    -0x885e9(%ebx),%eax
f01000f0:	50                   	push   %eax
f01000f1:	e8 70 40 00 00       	call   f0104166 <cprintf>
    //comparable little-and big-endian
    unsigned int i = 0x00646c72;//100-d 6c-l 72-r
f01000f6:	c7 45 f4 72 6c 64 00 	movl   $0x646c72,-0xc(%ebp)
    cprintf("H%x Wo%s!\n", 57616, &i);//57616-e110
f01000fd:	83 c4 0c             	add    $0xc,%esp
f0100100:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100103:	50                   	push   %eax
f0100104:	68 10 e1 00 00       	push   $0xe110
f0100109:	8d 83 32 7a f7 ff    	lea    -0x885ce(%ebx),%eax
f010010f:	50                   	push   %eax
f0100110:	e8 51 40 00 00       	call   f0104166 <cprintf>
    // Test the stack backtrace function (lab 1 only)
    test_backtrace(5);
f0100115:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f010011c:	e8 1f ff ff ff       	call   f0100040 <test_backtrace>

    cprintf("lab1 end--------------------------------------------------------------------------------------------------\n\n");
f0100121:	8d 83 e0 7a f7 ff    	lea    -0x88520(%ebx),%eax
f0100127:	89 04 24             	mov    %eax,(%esp)
f010012a:	e8 37 40 00 00       	call   f0104166 <cprintf>

    cprintf("lab2 start------------------------------------------------------------------------------------------------\n");
f010012f:	8d 83 50 7b f7 ff    	lea    -0x884b0(%ebx),%eax
f0100135:	89 04 24             	mov    %eax,(%esp)
f0100138:	e8 29 40 00 00       	call   f0104166 <cprintf>
    // Lab 2 memory management initialization functions
    mem_init();
f010013d:	e8 b9 14 00 00       	call   f01015fb <mem_init>

    cprintf("lab2 end--------------------------------------------------------------------------------------------------\n\n");
f0100142:	8d 83 bc 7b f7 ff    	lea    -0x88444(%ebx),%eax
f0100148:	89 04 24             	mov    %eax,(%esp)
f010014b:	e8 16 40 00 00       	call   f0104166 <cprintf>

    cprintf("lab3 start--------------------------------------------------------------------------------------------------\n");
f0100150:	8d 83 2c 7c f7 ff    	lea    -0x883d4(%ebx),%eax
f0100156:	89 04 24             	mov    %eax,(%esp)
f0100159:	e8 08 40 00 00       	call   f0104166 <cprintf>

    // Lab 3 user environment initialization functions

    env_init();
f010015e:	e8 21 38 00 00       	call   f0103984 <env_init>
    trap_init();
f0100163:	e8 ee 40 00 00       	call   f0104256 <trap_init>

#if defined(TEST)
    // Don't touch -- used by grading script!
    ENV_CREATE(TEST, ENV_TYPE_USER);
f0100168:	83 c4 08             	add    $0x8,%esp
f010016b:	6a 00                	push   $0x0
f010016d:	ff b3 f4 ff ff ff    	pushl  -0xc(%ebx)
f0100173:	e8 68 3a 00 00       	call   f0103be0 <env_create>
    // Touch all you want.
    ENV_CREATE(user_hello, ENV_TYPE_USER);
#endif // TEST*

    // We only have one user environment for now, so just run it.
    env_run(&envs[0]);
f0100178:	83 c4 04             	add    $0x4,%esp
f010017b:	c7 c0 50 03 19 f0    	mov    $0xf0190350,%eax
f0100181:	ff 30                	pushl  (%eax)
f0100183:	e8 bd 3e 00 00       	call   f0104045 <env_run>

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
f0100196:	81 c3 ea de 08 00    	add    $0x8deea,%ebx
f010019c:	8b 7d 10             	mov    0x10(%ebp),%edi
    va_list ap;

    if (panicstr)
f010019f:	c7 c0 04 10 19 f0    	mov    $0xf0191004,%eax
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
f01001c9:	8d 83 3d 7a f7 ff    	lea    -0x885c3(%ebx),%eax
f01001cf:	50                   	push   %eax
f01001d0:	e8 91 3f 00 00       	call   f0104166 <cprintf>
    vcprintf(fmt, ap);
f01001d5:	83 c4 08             	add    $0x8,%esp
f01001d8:	56                   	push   %esi
f01001d9:	57                   	push   %edi
f01001da:	e8 50 3f 00 00       	call   f010412f <vcprintf>
    cprintf("\n");
f01001df:	8d 83 65 92 f7 ff    	lea    -0x86d9b(%ebx),%eax
f01001e5:	89 04 24             	mov    %eax,(%esp)
f01001e8:	e8 79 3f 00 00       	call   f0104166 <cprintf>
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
f01001fc:	81 c3 84 de 08 00    	add    $0x8de84,%ebx
    va_list ap;

    va_start(ap, fmt);
f0100202:	8d 75 14             	lea    0x14(%ebp),%esi
    cprintf("kernel warning at %s:%d: ", file, line);
f0100205:	83 ec 04             	sub    $0x4,%esp
f0100208:	ff 75 0c             	pushl  0xc(%ebp)
f010020b:	ff 75 08             	pushl  0x8(%ebp)
f010020e:	8d 83 55 7a f7 ff    	lea    -0x885ab(%ebx),%eax
f0100214:	50                   	push   %eax
f0100215:	e8 4c 3f 00 00       	call   f0104166 <cprintf>
    vcprintf(fmt, ap);
f010021a:	83 c4 08             	add    $0x8,%esp
f010021d:	56                   	push   %esi
f010021e:	ff 75 10             	pushl  0x10(%ebp)
f0100221:	e8 09 3f 00 00       	call   f010412f <vcprintf>
    cprintf("\n");
f0100226:	8d 83 65 92 f7 ff    	lea    -0x86d9b(%ebx),%eax
f010022c:	89 04 24             	mov    %eax,(%esp)
f010022f:	e8 32 3f 00 00       	call   f0104166 <cprintf>
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
f010026b:	81 c3 15 de 08 00    	add    $0x8de15,%ebx
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
f010027e:	8b 8b a4 22 00 00    	mov    0x22a4(%ebx),%ecx
f0100284:	8d 51 01             	lea    0x1(%ecx),%edx
f0100287:	89 93 a4 22 00 00    	mov    %edx,0x22a4(%ebx)
f010028d:	88 84 0b a0 20 00 00 	mov    %al,0x20a0(%ebx,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f0100294:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010029a:	75 d7                	jne    f0100273 <cons_intr+0x12>
			cons.wpos = 0;
f010029c:	c7 83 a4 22 00 00 00 	movl   $0x0,0x22a4(%ebx)
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
f01002b6:	81 c3 ca dd 08 00    	add    $0x8ddca,%ebx
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
f01002ea:	8b 8b 80 20 00 00    	mov    0x2080(%ebx),%ecx
f01002f0:	f6 c1 40             	test   $0x40,%cl
f01002f3:	74 0e                	je     f0100303 <kbd_proc_data+0x57>
		data |= 0x80;
f01002f5:	83 c8 80             	or     $0xffffff80,%eax
f01002f8:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002fa:	83 e1 bf             	and    $0xffffffbf,%ecx
f01002fd:	89 8b 80 20 00 00    	mov    %ecx,0x2080(%ebx)
	shift |= shiftcode[data];
f0100303:	0f b6 d2             	movzbl %dl,%edx
f0100306:	0f b6 84 13 e0 7d f7 	movzbl -0x88220(%ebx,%edx,1),%eax
f010030d:	ff 
f010030e:	0b 83 80 20 00 00    	or     0x2080(%ebx),%eax
	shift ^= togglecode[data];
f0100314:	0f b6 8c 13 e0 7c f7 	movzbl -0x88320(%ebx,%edx,1),%ecx
f010031b:	ff 
f010031c:	31 c8                	xor    %ecx,%eax
f010031e:	89 83 80 20 00 00    	mov    %eax,0x2080(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100324:	89 c1                	mov    %eax,%ecx
f0100326:	83 e1 03             	and    $0x3,%ecx
f0100329:	8b 8c 8b a0 1f 00 00 	mov    0x1fa0(%ebx,%ecx,4),%ecx
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
f0100359:	8d 83 9a 7c f7 ff    	lea    -0x88366(%ebx),%eax
f010035f:	50                   	push   %eax
f0100360:	e8 01 3e 00 00       	call   f0104166 <cprintf>
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
f0100375:	83 8b 80 20 00 00 40 	orl    $0x40,0x2080(%ebx)
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
f010038a:	8b 8b 80 20 00 00    	mov    0x2080(%ebx),%ecx
f0100390:	89 ce                	mov    %ecx,%esi
f0100392:	83 e6 40             	and    $0x40,%esi
f0100395:	83 e0 7f             	and    $0x7f,%eax
f0100398:	85 f6                	test   %esi,%esi
f010039a:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010039d:	0f b6 d2             	movzbl %dl,%edx
f01003a0:	0f b6 84 13 e0 7d f7 	movzbl -0x88220(%ebx,%edx,1),%eax
f01003a7:	ff 
f01003a8:	83 c8 40             	or     $0x40,%eax
f01003ab:	0f b6 c0             	movzbl %al,%eax
f01003ae:	f7 d0                	not    %eax
f01003b0:	21 c8                	and    %ecx,%eax
f01003b2:	89 83 80 20 00 00    	mov    %eax,0x2080(%ebx)
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
f01003ec:	81 c3 94 dc 08 00    	add    $0x8dc94,%ebx
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
f01004ab:	0f b7 83 a8 22 00 00 	movzwl 0x22a8(%ebx),%eax
f01004b2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004b8:	c1 e8 16             	shr    $0x16,%eax
f01004bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004be:	c1 e0 04             	shl    $0x4,%eax
f01004c1:	66 89 83 a8 22 00 00 	mov    %ax,0x22a8(%ebx)
	if (crt_pos >= CRT_SIZE) {
f01004c8:	66 81 bb a8 22 00 00 	cmpw   $0x7cf,0x22a8(%ebx)
f01004cf:	cf 07 
f01004d1:	0f 87 d4 00 00 00    	ja     f01005ab <cons_putc+0x1cd>
	outb(addr_6845, 14);
f01004d7:	8b 8b b0 22 00 00    	mov    0x22b0(%ebx),%ecx
f01004dd:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004e2:	89 ca                	mov    %ecx,%edx
f01004e4:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004e5:	0f b7 9b a8 22 00 00 	movzwl 0x22a8(%ebx),%ebx
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
f0100512:	0f b7 83 a8 22 00 00 	movzwl 0x22a8(%ebx),%eax
f0100519:	66 85 c0             	test   %ax,%ax
f010051c:	74 b9                	je     f01004d7 <cons_putc+0xf9>
			crt_pos--;
f010051e:	83 e8 01             	sub    $0x1,%eax
f0100521:	66 89 83 a8 22 00 00 	mov    %ax,0x22a8(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100528:	0f b7 c0             	movzwl %ax,%eax
f010052b:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f010052f:	b2 00                	mov    $0x0,%dl
f0100531:	83 ca 20             	or     $0x20,%edx
f0100534:	8b 8b ac 22 00 00    	mov    0x22ac(%ebx),%ecx
f010053a:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f010053e:	eb 88                	jmp    f01004c8 <cons_putc+0xea>
		crt_pos += CRT_COLS;
f0100540:	66 83 83 a8 22 00 00 	addw   $0x50,0x22a8(%ebx)
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
f0100584:	0f b7 83 a8 22 00 00 	movzwl 0x22a8(%ebx),%eax
f010058b:	8d 50 01             	lea    0x1(%eax),%edx
f010058e:	66 89 93 a8 22 00 00 	mov    %dx,0x22a8(%ebx)
f0100595:	0f b7 c0             	movzwl %ax,%eax
f0100598:	8b 93 ac 22 00 00    	mov    0x22ac(%ebx),%edx
f010059e:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f01005a2:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005a6:	e9 1d ff ff ff       	jmp    f01004c8 <cons_putc+0xea>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005ab:	8b 83 ac 22 00 00    	mov    0x22ac(%ebx),%eax
f01005b1:	83 ec 04             	sub    $0x4,%esp
f01005b4:	68 00 0f 00 00       	push   $0xf00
f01005b9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005bf:	52                   	push   %edx
f01005c0:	50                   	push   %eax
f01005c1:	e8 9f 50 00 00       	call   f0105665 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005c6:	8b 93 ac 22 00 00    	mov    0x22ac(%ebx),%edx
f01005cc:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005d2:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005d8:	83 c4 10             	add    $0x10,%esp
f01005db:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e0:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e3:	39 d0                	cmp    %edx,%eax
f01005e5:	75 f4                	jne    f01005db <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f01005e7:	66 83 ab a8 22 00 00 	subw   $0x50,0x22a8(%ebx)
f01005ee:	50 
f01005ef:	e9 e3 fe ff ff       	jmp    f01004d7 <cons_putc+0xf9>

f01005f4 <serial_intr>:
{
f01005f4:	e8 e7 01 00 00       	call   f01007e0 <__x86.get_pc_thunk.ax>
f01005f9:	05 87 da 08 00       	add    $0x8da87,%eax
	if (serial_exists)
f01005fe:	80 b8 b4 22 00 00 00 	cmpb   $0x0,0x22b4(%eax)
f0100605:	75 02                	jne    f0100609 <serial_intr+0x15>
f0100607:	f3 c3                	repz ret 
{
f0100609:	55                   	push   %ebp
f010060a:	89 e5                	mov    %esp,%ebp
f010060c:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010060f:	8d 80 c2 21 f7 ff    	lea    -0x8de3e(%eax),%eax
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
f0100627:	05 59 da 08 00       	add    $0x8da59,%eax
	cons_intr(kbd_proc_data);
f010062c:	8d 80 2c 22 f7 ff    	lea    -0x8ddd4(%eax),%eax
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
f0100645:	81 c3 3b da 08 00    	add    $0x8da3b,%ebx
	serial_intr();
f010064b:	e8 a4 ff ff ff       	call   f01005f4 <serial_intr>
	kbd_intr();
f0100650:	e8 c7 ff ff ff       	call   f010061c <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100655:	8b 93 a0 22 00 00    	mov    0x22a0(%ebx),%edx
	return 0;
f010065b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100660:	3b 93 a4 22 00 00    	cmp    0x22a4(%ebx),%edx
f0100666:	74 19                	je     f0100681 <cons_getc+0x48>
		c = cons.buf[cons.rpos++];
f0100668:	8d 4a 01             	lea    0x1(%edx),%ecx
f010066b:	89 8b a0 22 00 00    	mov    %ecx,0x22a0(%ebx)
f0100671:	0f b6 84 13 a0 20 00 	movzbl 0x20a0(%ebx,%edx,1),%eax
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
f0100687:	c7 83 a0 22 00 00 00 	movl   $0x0,0x22a0(%ebx)
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
f01006a1:	81 c3 df d9 08 00    	add    $0x8d9df,%ebx
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
f01006c8:	c7 83 b0 22 00 00 b4 	movl   $0x3b4,0x22b0(%ebx)
f01006cf:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006d2:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
	outb(addr_6845, 14);
f01006d9:	8b bb b0 22 00 00    	mov    0x22b0(%ebx),%edi
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
f0100701:	89 bb ac 22 00 00    	mov    %edi,0x22ac(%ebx)
	pos |= inb(addr_6845 + 1);
f0100707:	0f b6 c0             	movzbl %al,%eax
f010070a:	09 c6                	or     %eax,%esi
	crt_pos = pos;
f010070c:	66 89 b3 a8 22 00 00 	mov    %si,0x22a8(%ebx)
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
f0100764:	0f 95 83 b4 22 00 00 	setne  0x22b4(%ebx)
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
f010078b:	c7 83 b0 22 00 00 d4 	movl   $0x3d4,0x22b0(%ebx)
f0100792:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100795:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f010079c:	e9 38 ff ff ff       	jmp    f01006d9 <cons_init+0x46>
		cprintf("Serial port does not exist!\n");
f01007a1:	83 ec 0c             	sub    $0xc,%esp
f01007a4:	8d 83 a6 7c f7 ff    	lea    -0x8835a(%ebx),%eax
f01007aa:	50                   	push   %eax
f01007ab:	e8 b6 39 00 00       	call   f0104166 <cprintf>
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
f01007ee:	81 c3 92 d8 08 00    	add    $0x8d892,%ebx
    int i;

    for (i = 0; i < ARRAY_SIZE(commands); i++)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007f4:	83 ec 04             	sub    $0x4,%esp
f01007f7:	8d 83 e0 7e f7 ff    	lea    -0x88120(%ebx),%eax
f01007fd:	50                   	push   %eax
f01007fe:	8d 83 fe 7e f7 ff    	lea    -0x88102(%ebx),%eax
f0100804:	50                   	push   %eax
f0100805:	8d b3 03 7f f7 ff    	lea    -0x880fd(%ebx),%esi
f010080b:	56                   	push   %esi
f010080c:	e8 55 39 00 00       	call   f0104166 <cprintf>
f0100811:	83 c4 0c             	add    $0xc,%esp
f0100814:	8d 83 a8 7f f7 ff    	lea    -0x88058(%ebx),%eax
f010081a:	50                   	push   %eax
f010081b:	8d 83 0c 7f f7 ff    	lea    -0x880f4(%ebx),%eax
f0100821:	50                   	push   %eax
f0100822:	56                   	push   %esi
f0100823:	e8 3e 39 00 00       	call   f0104166 <cprintf>
f0100828:	83 c4 0c             	add    $0xc,%esp
f010082b:	8d 83 15 7f f7 ff    	lea    -0x880eb(%ebx),%eax
f0100831:	50                   	push   %eax
f0100832:	8d 83 33 7f f7 ff    	lea    -0x880cd(%ebx),%eax
f0100838:	50                   	push   %eax
f0100839:	56                   	push   %esi
f010083a:	e8 27 39 00 00       	call   f0104166 <cprintf>
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
f0100859:	81 c3 27 d8 08 00    	add    $0x8d827,%ebx
    extern char _start[], entry[], etext[], edata[], end[];

    cprintf("Special kernel symbols:\n");
f010085f:	8d 83 3d 7f f7 ff    	lea    -0x880c3(%ebx),%eax
f0100865:	50                   	push   %eax
f0100866:	e8 fb 38 00 00       	call   f0104166 <cprintf>
    cprintf("  _start                  %08x (phys)\n", _start);
f010086b:	83 c4 08             	add    $0x8,%esp
f010086e:	ff b3 f8 ff ff ff    	pushl  -0x8(%ebx)
f0100874:	8d 83 d0 7f f7 ff    	lea    -0x88030(%ebx),%eax
f010087a:	50                   	push   %eax
f010087b:	e8 e6 38 00 00       	call   f0104166 <cprintf>
    cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100880:	83 c4 0c             	add    $0xc,%esp
f0100883:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f0100889:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f010088f:	50                   	push   %eax
f0100890:	57                   	push   %edi
f0100891:	8d 83 f8 7f f7 ff    	lea    -0x88008(%ebx),%eax
f0100897:	50                   	push   %eax
f0100898:	e8 c9 38 00 00       	call   f0104166 <cprintf>
    cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010089d:	83 c4 0c             	add    $0xc,%esp
f01008a0:	c7 c0 59 5a 10 f0    	mov    $0xf0105a59,%eax
f01008a6:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01008ac:	52                   	push   %edx
f01008ad:	50                   	push   %eax
f01008ae:	8d 83 1c 80 f7 ff    	lea    -0x87fe4(%ebx),%eax
f01008b4:	50                   	push   %eax
f01008b5:	e8 ac 38 00 00       	call   f0104166 <cprintf>
    cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008ba:	83 c4 0c             	add    $0xc,%esp
f01008bd:	c7 c0 00 01 19 f0    	mov    $0xf0190100,%eax
f01008c3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01008c9:	52                   	push   %edx
f01008ca:	50                   	push   %eax
f01008cb:	8d 83 40 80 f7 ff    	lea    -0x87fc0(%ebx),%eax
f01008d1:	50                   	push   %eax
f01008d2:	e8 8f 38 00 00       	call   f0104166 <cprintf>
    cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008d7:	83 c4 0c             	add    $0xc,%esp
f01008da:	c7 c6 14 10 19 f0    	mov    $0xf0191014,%esi
f01008e0:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01008e6:	50                   	push   %eax
f01008e7:	56                   	push   %esi
f01008e8:	8d 83 64 80 f7 ff    	lea    -0x87f9c(%ebx),%eax
f01008ee:	50                   	push   %eax
f01008ef:	e8 72 38 00 00       	call   f0104166 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
f01008f4:	83 c4 08             	add    $0x8,%esp
            ROUNDUP(end - entry, 1024) / 1024);
f01008f7:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
f01008fd:	29 fe                	sub    %edi,%esi
    cprintf("Kernel executable memory footprint: %dKB\n",
f01008ff:	c1 fe 0a             	sar    $0xa,%esi
f0100902:	56                   	push   %esi
f0100903:	8d 83 88 80 f7 ff    	lea    -0x87f78(%ebx),%eax
f0100909:	50                   	push   %eax
f010090a:	e8 57 38 00 00       	call   f0104166 <cprintf>
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
f010092a:	81 c3 56 d7 08 00    	add    $0x8d756,%ebx

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
f0100932:	8d 83 b4 80 f7 ff    	lea    -0x87f4c(%ebx),%eax
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
f010095a:	e8 07 38 00 00       	call   f0104166 <cprintf>
        debuginfo_eip(eip, &eipDebugInfo);
f010095f:	83 c4 18             	add    $0x18,%esp
f0100962:	ff 75 c0             	pushl  -0x40(%ebp)
f0100965:	57                   	push   %edi
f0100966:	e8 65 41 00 00       	call   f0104ad0 <debuginfo_eip>
        cprintf("\t %s:%d:  %.*s+%d\n", eipDebugInfo.eip_file, eipDebugInfo.eip_line, eipDebugInfo.eip_fn_namelen, eipDebugInfo.eip_fn_name,
f010096b:	83 c4 08             	add    $0x8,%esp
f010096e:	2b 7d e0             	sub    -0x20(%ebp),%edi
f0100971:	57                   	push   %edi
f0100972:	ff 75 d8             	pushl  -0x28(%ebp)
f0100975:	ff 75 dc             	pushl  -0x24(%ebp)
f0100978:	ff 75 d4             	pushl  -0x2c(%ebp)
f010097b:	ff 75 d0             	pushl  -0x30(%ebp)
f010097e:	8d 83 56 7f f7 ff    	lea    -0x880aa(%ebx),%eax
f0100984:	50                   	push   %eax
f0100985:	e8 dc 37 00 00       	call   f0104166 <cprintf>
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
f01009ae:	81 c3 d2 d6 08 00    	add    $0x8d6d2,%ebx
    char *buf;

    cprintf("Welcome to the JOS kernel monitor!\n");
f01009b4:	8d 83 ec 80 f7 ff    	lea    -0x87f14(%ebx),%eax
f01009ba:	50                   	push   %eax
f01009bb:	e8 a6 37 00 00       	call   f0104166 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
f01009c0:	8d 83 10 81 f7 ff    	lea    -0x87ef0(%ebx),%eax
f01009c6:	89 04 24             	mov    %eax,(%esp)
f01009c9:	e8 98 37 00 00       	call   f0104166 <cprintf>

	if (tf != NULL)
f01009ce:	83 c4 10             	add    $0x10,%esp
f01009d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009d5:	74 0e                	je     f01009e5 <monitor+0x45>
		print_trapframe(tf);
f01009d7:	83 ec 0c             	sub    $0xc,%esp
f01009da:	ff 75 08             	pushl  0x8(%ebp)
f01009dd:	e8 1e 3a 00 00       	call   f0104400 <print_trapframe>
f01009e2:	83 c4 10             	add    $0x10,%esp
        while (*buf && strchr(WHITESPACE, *buf))
f01009e5:	8d bb 6d 7f f7 ff    	lea    -0x88093(%ebx),%edi
f01009eb:	eb 4a                	jmp    f0100a37 <monitor+0x97>
f01009ed:	83 ec 08             	sub    $0x8,%esp
f01009f0:	0f be c0             	movsbl %al,%eax
f01009f3:	50                   	push   %eax
f01009f4:	57                   	push   %edi
f01009f5:	e8 e1 4b 00 00       	call   f01055db <strchr>
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
f0100a28:	8d 83 72 7f f7 ff    	lea    -0x8808e(%ebx),%eax
f0100a2e:	50                   	push   %eax
f0100a2f:	e8 32 37 00 00       	call   f0104166 <cprintf>
f0100a34:	83 c4 10             	add    $0x10,%esp

    while (1) {
        buf = readline("K> ");
f0100a37:	8d 83 69 7f f7 ff    	lea    -0x88097(%ebx),%eax
f0100a3d:	89 c6                	mov    %eax,%esi
f0100a3f:	83 ec 0c             	sub    $0xc,%esp
f0100a42:	56                   	push   %esi
f0100a43:	e8 5b 49 00 00       	call   f01053a3 <readline>
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
f0100a73:	e8 63 4b 00 00       	call   f01055db <strchr>
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
f0100a99:	8d b3 c0 1f 00 00    	lea    0x1fc0(%ebx),%esi
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a9f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100aa4:	89 7d a0             	mov    %edi,-0x60(%ebp)
f0100aa7:	89 c7                	mov    %eax,%edi
        if (strcmp(argv[0], commands[i].name) == 0)
f0100aa9:	83 ec 08             	sub    $0x8,%esp
f0100aac:	ff 36                	pushl  (%esi)
f0100aae:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ab1:	e8 c7 4a 00 00       	call   f010557d <strcmp>
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
f0100ad1:	8d 83 8f 7f f7 ff    	lea    -0x88071(%ebx),%eax
f0100ad7:	50                   	push   %eax
f0100ad8:	e8 89 36 00 00       	call   f0104166 <cprintf>
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
f0100afa:	ff 94 83 c8 1f 00 00 	call   *0x1fc8(%ebx,%eax,4)
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
f0100b22:	81 c3 5e d5 08 00    	add    $0x8d55e,%ebx
f0100b28:	89 c7                	mov    %eax,%edi
    return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b2a:	50                   	push   %eax
f0100b2b:	e8 af 35 00 00       	call   f01040df <mc146818_read>
f0100b30:	89 c6                	mov    %eax,%esi
f0100b32:	83 c7 01             	add    $0x1,%edi
f0100b35:	89 3c 24             	mov    %edi,(%esp)
f0100b38:	e8 a2 35 00 00       	call   f01040df <mc146818_read>
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
f0100b4f:	e8 e8 2c 00 00       	call   f010383c <__x86.get_pc_thunk.dx>
f0100b54:	81 c2 2c d5 08 00    	add    $0x8d52c,%edx
    // Initialize nextfree if this is the first time.
    // 'end' is a magic symbol automatically generated by the linker,
    // which points to the end of the kernel's bss segment:
    // the first virtual address that the linker did *not* assign
    // to any kernel code or global variables.
    if (!nextfree) {
f0100b5a:	83 ba b8 22 00 00 00 	cmpl   $0x0,0x22b8(%edx)
f0100b61:	74 2c                	je     f0100b8f <boot_alloc+0x45>
    }

    // Allocate a chunk large enough to hold 'n' bytes, then update
    // nextfree.  Make sure nextfree is kept aligned
    // to a multiple of PGSIZE.
    result = nextfree;
f0100b63:	8b 8a b8 22 00 00    	mov    0x22b8(%edx),%ecx
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100b69:	8d 71 ff             	lea    -0x1(%ecx),%esi
f0100b6c:	89 c3                	mov    %eax,%ebx
f0100b6e:	f7 d3                	not    %ebx
f0100b70:	39 de                	cmp    %ebx,%esi
f0100b72:	77 35                	ja     f0100ba9 <boot_alloc+0x5f>
    nextfree = ROUNDUP((result + n), PGSIZE);
f0100b74:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f0100b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b80:	89 82 b8 22 00 00    	mov    %eax,0x22b8(%edx)

    return result;
}
f0100b86:	89 c8                	mov    %ecx,%eax
f0100b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b8b:	5b                   	pop    %ebx
f0100b8c:	5e                   	pop    %esi
f0100b8d:	5d                   	pop    %ebp
f0100b8e:	c3                   	ret    
        nextfree = ROUNDUP((char *) end, PGSIZE);
f0100b8f:	c7 c1 14 10 19 f0    	mov    $0xf0191014,%ecx
f0100b95:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0100b9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100ba1:	89 8a b8 22 00 00    	mov    %ecx,0x22b8(%edx)
f0100ba7:	eb ba                	jmp    f0100b63 <boot_alloc+0x19>
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100ba9:	8d 82 38 81 f7 ff    	lea    -0x87ec8(%edx),%eax
f0100baf:	50                   	push   %eax
f0100bb0:	8d 82 3d 8f f7 ff    	lea    -0x870c3(%edx),%eax
f0100bb6:	50                   	push   %eax
f0100bb7:	6a 71                	push   $0x71
f0100bb9:	8d 82 52 8f f7 ff    	lea    -0x870ae(%edx),%eax
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
f0100bcc:	e8 6f 2c 00 00       	call   f0103840 <__x86.get_pc_thunk.cx>
f0100bd1:	81 c1 af d4 08 00    	add    $0x8d4af,%ecx
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
f0100bed:	c7 c3 08 10 19 f0    	mov    $0xf0191008,%ebx
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
f0100c23:	8d 81 60 81 f7 ff    	lea    -0x87ea0(%ecx),%eax
f0100c29:	50                   	push   %eax
f0100c2a:	68 8f 03 00 00       	push   $0x38f
f0100c2f:	8d 81 52 8f f7 ff    	lea    -0x870ae(%ecx),%eax
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
f0100c4d:	e8 f2 2b 00 00       	call   f0103844 <__x86.get_pc_thunk.di>
f0100c52:	81 c7 2e d4 08 00    	add    $0x8d42e,%edi
f0100c58:	89 7d c4             	mov    %edi,-0x3c(%ebp)
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c5b:	84 c0                	test   %al,%al
f0100c5d:	0f 85 25 03 00 00    	jne    f0100f88 <check_page_free_list+0x344>
    if (!page_free_list)
f0100c63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100c66:	83 b8 c4 22 00 00 00 	cmpl   $0x0,0x22c4(%eax)
f0100c6d:	74 0c                	je     f0100c7b <check_page_free_list+0x37>
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c6f:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
f0100c76:	e9 99 03 00 00       	jmp    f0101014 <check_page_free_list+0x3d0>
        panic("'page_free_list' is a null pointer!");
f0100c7b:	83 ec 04             	sub    $0x4,%esp
f0100c7e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c81:	8d 83 84 81 f7 ff    	lea    -0x87e7c(%ebx),%eax
f0100c87:	50                   	push   %eax
f0100c88:	68 c2 02 00 00       	push   $0x2c2
f0100c8d:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100c93:	50                   	push   %eax
f0100c94:	e8 ef f4 ff ff       	call   f0100188 <_panic>
f0100c99:	50                   	push   %eax
f0100c9a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c9d:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f0100ca3:	50                   	push   %eax
f0100ca4:	6a 56                	push   $0x56
f0100ca6:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
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
f0100cee:	e8 25 49 00 00       	call   f0105618 <memset>
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
f0100d0c:	8d 87 6c 8f f7 ff    	lea    -0x87094(%edi),%eax
f0100d12:	50                   	push   %eax
f0100d13:	89 fb                	mov    %edi,%ebx
f0100d15:	e8 4c 34 00 00       	call   f0104166 <cprintf>
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d1a:	8b 97 c4 22 00 00    	mov    0x22c4(%edi),%edx
        assert(pp >= pages);
f0100d20:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0100d26:	8b 08                	mov    (%eax),%ecx
        assert(pp < pages + npages);
f0100d28:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
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
f0100d4c:	8d 83 82 8f f7 ff    	lea    -0x8707e(%ebx),%eax
f0100d52:	50                   	push   %eax
f0100d53:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100d59:	50                   	push   %eax
f0100d5a:	68 e3 02 00 00       	push   $0x2e3
f0100d5f:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100d65:	50                   	push   %eax
f0100d66:	e8 1d f4 ff ff       	call   f0100188 <_panic>
        assert(pp < pages + npages);
f0100d6b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d6e:	8d 83 8e 8f f7 ff    	lea    -0x87072(%ebx),%eax
f0100d74:	50                   	push   %eax
f0100d75:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100d7b:	50                   	push   %eax
f0100d7c:	68 e4 02 00 00       	push   $0x2e4
f0100d81:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100d87:	50                   	push   %eax
f0100d88:	e8 fb f3 ff ff       	call   f0100188 <_panic>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d8d:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d90:	8d 83 f4 81 f7 ff    	lea    -0x87e0c(%ebx),%eax
f0100d96:	50                   	push   %eax
f0100d97:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100d9d:	50                   	push   %eax
f0100d9e:	68 e5 02 00 00       	push   $0x2e5
f0100da3:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100da9:	50                   	push   %eax
f0100daa:	e8 d9 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != 0);
f0100daf:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100db2:	8d 83 a2 8f f7 ff    	lea    -0x8705e(%ebx),%eax
f0100db8:	50                   	push   %eax
f0100db9:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100dbf:	50                   	push   %eax
f0100dc0:	68 e8 02 00 00       	push   $0x2e8
f0100dc5:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100dcb:	50                   	push   %eax
f0100dcc:	e8 b7 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != IOPHYSMEM);
f0100dd1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100dd4:	8d 83 b3 8f f7 ff    	lea    -0x8704d(%ebx),%eax
f0100dda:	50                   	push   %eax
f0100ddb:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100de1:	50                   	push   %eax
f0100de2:	68 e9 02 00 00       	push   $0x2e9
f0100de7:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100ded:	50                   	push   %eax
f0100dee:	e8 95 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100df3:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100df6:	8d 83 28 82 f7 ff    	lea    -0x87dd8(%ebx),%eax
f0100dfc:	50                   	push   %eax
f0100dfd:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100e03:	50                   	push   %eax
f0100e04:	68 ea 02 00 00       	push   $0x2ea
f0100e09:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100e0f:	50                   	push   %eax
f0100e10:	e8 73 f3 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100e15:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100e18:	8d 83 cc 8f f7 ff    	lea    -0x87034(%ebx),%eax
f0100e1e:	50                   	push   %eax
f0100e1f:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100e25:	50                   	push   %eax
f0100e26:	68 eb 02 00 00       	push   $0x2eb
f0100e2b:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
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
f0100eb5:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f0100ebb:	50                   	push   %eax
f0100ebc:	6a 56                	push   $0x56
f0100ebe:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
f0100ec4:	50                   	push   %eax
f0100ec5:	e8 be f2 ff ff       	call   f0100188 <_panic>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100eca:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100ecd:	8d 83 4c 82 f7 ff    	lea    -0x87db4(%ebx),%eax
f0100ed3:	50                   	push   %eax
f0100ed4:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100eda:	50                   	push   %eax
f0100edb:	68 ec 02 00 00       	push   $0x2ec
f0100ee0:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100ee6:	50                   	push   %eax
f0100ee7:	e8 9c f2 ff ff       	call   f0100188 <_panic>
f0100eec:	8b 75 d0             	mov    -0x30(%ebp),%esi
    cprintf("nfree_basemem:0x%x\tnfree_extmem:0x%x\n", nfree_basemem, nfree_extmem);
f0100eef:	83 ec 04             	sub    $0x4,%esp
f0100ef2:	56                   	push   %esi
f0100ef3:	57                   	push   %edi
f0100ef4:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100ef7:	8d 83 94 82 f7 ff    	lea    -0x87d6c(%ebx),%eax
f0100efd:	50                   	push   %eax
f0100efe:	e8 63 32 00 00       	call   f0104166 <cprintf>
    cprintf("物理内存占用中页数:0x%x\n", 8 * PGSIZE - nfree_basemem - nfree_extmem);
f0100f03:	83 c4 08             	add    $0x8,%esp
f0100f06:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100f0b:	29 f8                	sub    %edi,%eax
f0100f0d:	29 f0                	sub    %esi,%eax
f0100f0f:	50                   	push   %eax
f0100f10:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f13:	8d 83 bc 82 f7 ff    	lea    -0x87d44(%ebx),%eax
f0100f19:	50                   	push   %eax
f0100f1a:	e8 47 32 00 00       	call   f0104166 <cprintf>
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
f0100f30:	8d 83 e0 82 f7 ff    	lea    -0x87d20(%ebx),%eax
f0100f36:	50                   	push   %eax
f0100f37:	e8 2a 32 00 00       	call   f0104166 <cprintf>
}
f0100f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f3f:	5b                   	pop    %ebx
f0100f40:	5e                   	pop    %esi
f0100f41:	5f                   	pop    %edi
f0100f42:	5d                   	pop    %ebp
f0100f43:	c3                   	ret    
    assert(nfree_basemem > 0);
f0100f44:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f47:	8d 83 e6 8f f7 ff    	lea    -0x8701a(%ebx),%eax
f0100f4d:	50                   	push   %eax
f0100f4e:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100f54:	50                   	push   %eax
f0100f55:	68 f8 02 00 00       	push   $0x2f8
f0100f5a:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100f60:	50                   	push   %eax
f0100f61:	e8 22 f2 ff ff       	call   f0100188 <_panic>
    assert(nfree_extmem > 0);
f0100f66:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100f69:	8d 83 f8 8f f7 ff    	lea    -0x87008(%ebx),%eax
f0100f6f:	50                   	push   %eax
f0100f70:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f0100f76:	50                   	push   %eax
f0100f77:	68 f9 02 00 00       	push   $0x2f9
f0100f7c:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f0100f82:	50                   	push   %eax
f0100f83:	e8 00 f2 ff ff       	call   f0100188 <_panic>
    if (!page_free_list)
f0100f88:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100f8b:	8b 80 c4 22 00 00    	mov    0x22c4(%eax),%eax
f0100f91:	85 c0                	test   %eax,%eax
f0100f93:	0f 84 e2 fc ff ff    	je     f0100c7b <check_page_free_list+0x37>
        struct PageInfo **tp[2] = {&pp1, &pp2};
f0100f99:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100f9c:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100f9f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100fa2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100fa5:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100fa8:	c7 c3 10 10 19 f0    	mov    $0xf0191010,%ebx
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
f0100fe5:	8d 81 a8 81 f7 ff    	lea    -0x87e58(%ecx),%eax
f0100feb:	50                   	push   %eax
f0100fec:	89 cb                	mov    %ecx,%ebx
f0100fee:	e8 73 31 00 00       	call   f0104166 <cprintf>
        *tp[1] = 0;
f0100ff3:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
        *tp[0] = pp2;
f0100ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100ffc:	89 06                	mov    %eax,(%esi)
        page_free_list = pp1;
f0100ffe:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101001:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0101004:	89 81 c4 22 00 00    	mov    %eax,0x22c4(%ecx)
f010100a:	83 c4 20             	add    $0x20,%esp
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010100d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101014:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0101017:	8b b0 c4 22 00 00    	mov    0x22c4(%eax),%esi
f010101d:	c7 c7 10 10 19 f0    	mov    $0xf0191010,%edi
	if (PGNUM(pa) >= npages)
f0101023:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
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
f010103f:	81 c3 41 d0 08 00    	add    $0x8d041,%ebx
    physaddr_t baseMemFreeStart = PGSIZE, baseMemFreeEnd = npages_basemem * PGSIZE,
f0101045:	8b b3 c8 22 00 00    	mov    0x22c8(%ebx),%esi
f010104b:	89 f2                	mov    %esi,%edx
f010104d:	c1 e2 0c             	shl    $0xc,%edx
            extMemFreeStart = PADDR(pages) + ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) +
f0101050:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0101056:	8b 08                	mov    (%eax),%ecx
	if ((uint32_t)kva < KERNBASE)
f0101058:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f010105e:	76 7a                	jbe    f01010da <page_init+0xa9>
f0101060:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f0101066:	8b 00                	mov    (%eax),%eax
f0101068:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010106f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101074:	8d bc 01 00 80 01 10 	lea    0x10018000(%ecx,%eax,1),%edi
f010107b:	89 7d e0             	mov    %edi,-0x20(%ebp)
                              ROUNDUP(NENV * sizeof(struct Env), PGSIZE), extMemFreeEnd =
f010107e:	8b 83 c0 22 00 00    	mov    0x22c0(%ebx),%eax
f0101084:	c1 e0 0a             	shl    $0xa,%eax
f0101087:	89 45 dc             	mov    %eax,-0x24(%ebp)
    cprintf("qemu空闲物理内存:[0x%x, 0x%x]\t[0x%x, 0x%x)\n", baseMemFreeStart, baseMemFreeEnd, extMemFreeStart,
f010108a:	83 ec 0c             	sub    $0xc,%esp
f010108d:	50                   	push   %eax
f010108e:	57                   	push   %edi
f010108f:	52                   	push   %edx
f0101090:	68 00 10 00 00       	push   $0x1000
f0101095:	8d 83 28 83 f7 ff    	lea    -0x87cd8(%ebx),%eax
f010109b:	50                   	push   %eax
f010109c:	e8 c5 30 00 00       	call   f0104166 <cprintf>
    cprintf("初始page_free_list:0x%x\n", page_free_list);
f01010a1:	83 c4 18             	add    $0x18,%esp
f01010a4:	ff b3 c4 22 00 00    	pushl  0x22c4(%ebx)
f01010aa:	8d 83 09 90 f7 ff    	lea    -0x86ff7(%ebx),%eax
f01010b0:	50                   	push   %eax
f01010b1:	e8 b0 30 00 00       	call   f0104166 <cprintf>
f01010b6:	8b bb c4 22 00 00    	mov    0x22c4(%ebx),%edi
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f01010bc:	83 c4 10             	add    $0x10,%esp
f01010bf:	ba 00 00 00 00       	mov    $0x0,%edx
f01010c4:	b8 01 00 00 00       	mov    $0x1,%eax
f01010c9:	81 e6 ff ff 0f 00    	and    $0xfffff,%esi
f01010cf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        pages[i].pp_ref = 0;
f01010d2:	c7 c6 10 10 19 f0    	mov    $0xf0191010,%esi
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f01010d8:	eb 38                	jmp    f0101112 <page_init+0xe1>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01010da:	51                   	push   %ecx
f01010db:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f01010e1:	50                   	push   %eax
f01010e2:	68 38 01 00 00       	push   $0x138
f01010e7:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
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
f010112a:	8b b3 c4 22 00 00    	mov    0x22c4(%ebx),%esi
f0101130:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
f0101137:	b9 00 00 00 00       	mov    $0x0,%ecx
        pages[i].pp_ref = 0;
f010113c:	c7 c7 10 10 19 f0    	mov    $0xf0191010,%edi
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f0101142:	eb 23                	jmp    f0101167 <page_init+0x136>
f0101144:	89 bb c4 22 00 00    	mov    %edi,0x22c4(%ebx)
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
f0101170:	8b 83 c4 22 00 00    	mov    0x22c4(%ebx),%eax
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
f0101194:	8d 83 24 90 f7 ff    	lea    -0x86fdc(%ebx),%eax
f010119a:	50                   	push   %eax
f010119b:	e8 da 2f 00 00       	call   f010417a <memCprintf>
}
f01011a0:	83 c4 20             	add    $0x20,%esp
f01011a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011a6:	5b                   	pop    %ebx
f01011a7:	5e                   	pop    %esi
f01011a8:	5f                   	pop    %edi
f01011a9:	5d                   	pop    %ebp
f01011aa:	c3                   	ret    
f01011ab:	89 b3 c4 22 00 00    	mov    %esi,0x22c4(%ebx)
f01011b1:	eb bd                	jmp    f0101170 <page_init+0x13f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01011b3:	50                   	push   %eax
f01011b4:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f01011ba:	50                   	push   %eax
f01011bb:	68 4f 01 00 00       	push   $0x14f
f01011c0:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f01011c6:	50                   	push   %eax
f01011c7:	e8 bc ef ff ff       	call   f0100188 <_panic>

f01011cc <page_alloc>:
page_alloc(int alloc_flags) {
f01011cc:	55                   	push   %ebp
f01011cd:	89 e5                	mov    %esp,%ebp
f01011cf:	56                   	push   %esi
f01011d0:	53                   	push   %ebx
f01011d1:	e8 68 f0 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01011d6:	81 c3 aa ce 08 00    	add    $0x8ceaa,%ebx
    if (!page_free_list) {
f01011dc:	8b b3 c4 22 00 00    	mov    0x22c4(%ebx),%esi
f01011e2:	85 f6                	test   %esi,%esi
f01011e4:	74 1a                	je     f0101200 <page_alloc+0x34>
    page_free_list = page_free_list->pp_link;
f01011e6:	8b 06                	mov    (%esi),%eax
f01011e8:	89 83 c4 22 00 00    	mov    %eax,0x22c4(%ebx)
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
f0101209:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f010120f:	89 f2                	mov    %esi,%edx
f0101211:	2b 10                	sub    (%eax),%edx
f0101213:	89 d0                	mov    %edx,%eax
f0101215:	c1 f8 03             	sar    $0x3,%eax
f0101218:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010121b:	89 c1                	mov    %eax,%ecx
f010121d:	c1 e9 0c             	shr    $0xc,%ecx
f0101220:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0101226:	3b 0a                	cmp    (%edx),%ecx
f0101228:	73 1a                	jae    f0101244 <page_alloc+0x78>
        memset(page2kva(allocPage), 0, PGSIZE);
f010122a:	83 ec 04             	sub    $0x4,%esp
f010122d:	68 00 10 00 00       	push   $0x1000
f0101232:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101234:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101239:	50                   	push   %eax
f010123a:	e8 d9 43 00 00       	call   f0105618 <memset>
f010123f:	83 c4 10             	add    $0x10,%esp
f0101242:	eb bc                	jmp    f0101200 <page_alloc+0x34>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101244:	50                   	push   %eax
f0101245:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f010124b:	50                   	push   %eax
f010124c:	6a 56                	push   $0x56
f010124e:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
f0101254:	50                   	push   %eax
f0101255:	e8 2e ef ff ff       	call   f0100188 <_panic>

f010125a <page_free>:
page_free(struct PageInfo *pp) {
f010125a:	55                   	push   %ebp
f010125b:	89 e5                	mov    %esp,%ebp
f010125d:	53                   	push   %ebx
f010125e:	83 ec 04             	sub    $0x4,%esp
f0101261:	e8 d8 ef ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0101266:	81 c3 1a ce 08 00    	add    $0x8ce1a,%ebx
f010126c:	8b 45 08             	mov    0x8(%ebp),%eax
    assert(!pp->pp_ref);
f010126f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101274:	75 18                	jne    f010128e <page_free+0x34>
    assert(!pp->pp_link);
f0101276:	83 38 00             	cmpl   $0x0,(%eax)
f0101279:	75 32                	jne    f01012ad <page_free+0x53>
    pp->pp_link = page_free_list;
f010127b:	8b 8b c4 22 00 00    	mov    0x22c4(%ebx),%ecx
f0101281:	89 08                	mov    %ecx,(%eax)
    page_free_list = pp;
f0101283:	89 83 c4 22 00 00    	mov    %eax,0x22c4(%ebx)
}
f0101289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010128c:	c9                   	leave  
f010128d:	c3                   	ret    
    assert(!pp->pp_ref);
f010128e:	8d 83 33 90 f7 ff    	lea    -0x86fcd(%ebx),%eax
f0101294:	50                   	push   %eax
f0101295:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f010129b:	50                   	push   %eax
f010129c:	68 76 01 00 00       	push   $0x176
f01012a1:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
f01012a7:	50                   	push   %eax
f01012a8:	e8 db ee ff ff       	call   f0100188 <_panic>
    assert(!pp->pp_link);
f01012ad:	8d 83 3f 90 f7 ff    	lea    -0x86fc1(%ebx),%eax
f01012b3:	50                   	push   %eax
f01012b4:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f01012ba:	50                   	push   %eax
f01012bb:	68 77 01 00 00       	push   $0x177
f01012c0:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
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
f0101303:	81 c3 7d cd 08 00    	add    $0x8cd7d,%ebx
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
f010133c:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f0101342:	2b 02                	sub    (%edx),%eax
f0101344:	c1 f8 03             	sar    $0x3,%eax
f0101347:	c1 e0 0c             	shl    $0xc,%eax
            pgdir[PDX(va)] = pgTablePaAddr | PTE_U | PTE_W | PTE_P;//消极权限
f010134a:	89 c2                	mov    %eax,%edx
f010134c:	83 ca 07             	or     $0x7,%edx
f010134f:	89 17                	mov    %edx,(%edi)
	if (PGNUM(pa) >= npages)
f0101351:	89 c1                	mov    %eax,%ecx
f0101353:	c1 e9 0c             	shr    $0xc,%ecx
f0101356:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
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
f0101379:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f010137f:	50                   	push   %eax
f0101380:	68 db 01 00 00       	push   $0x1db
f0101385:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
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
f01013ef:	81 c3 91 cc 08 00    	add    $0x8cc91,%ebx
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
f010141a:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0101420:	39 02                	cmp    %eax,(%edx)
f0101422:	76 12                	jbe    f0101436 <page_lookup+0x51>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101424:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
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
f0101439:	8d 83 5c 83 f7 ff    	lea    -0x87ca4(%ebx),%eax
f010143f:	50                   	push   %eax
f0101440:	6a 4f                	push   $0x4f
f0101442:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
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
f0101462:	81 c3 1e cc 08 00    	add    $0x8cc1e,%ebx
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
f0101499:	e8 7a 41 00 00       	call   f0105618 <memset>
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
f01014b4:	81 c3 cc cb 08 00    	add    $0x8cbcc,%ebx
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
f01014d6:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f01014dc:	39 02                	cmp    %eax,(%edx)
f01014de:	76 24                	jbe    f0101504 <page_insert+0x5e>
	return &pages[PGNUM(pa)];
f01014e0:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
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
f0101507:	8d 83 5c 83 f7 ff    	lea    -0x87ca4(%ebx),%eax
f010150d:	50                   	push   %eax
f010150e:	6a 4f                	push   $0x4f
f0101510:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
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
f0101535:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
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
f0101559:	c7 c1 08 10 19 f0    	mov    $0xf0191008,%ecx
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
f01015be:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
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
f01015dc:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f01015e2:	50                   	push   %eax
f01015e3:	68 27 02 00 00       	push   $0x227
f01015e8:	8d 83 52 8f f7 ff    	lea    -0x870ae(%ebx),%eax
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
f0101604:	e8 3b 22 00 00       	call   f0103844 <__x86.get_pc_thunk.di>
f0101609:	81 c7 77 ca 08 00    	add    $0x8ca77,%edi
    basemem = nvram_read(NVRAM_BASELO);
f010160f:	b8 15 00 00 00       	mov    $0x15,%eax
f0101614:	e8 fb f4 ff ff       	call   f0100b14 <nvram_read>
f0101619:	89 c3                	mov    %eax,%ebx
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
f0101636:	0f 85 64 02 00 00    	jne    f01018a0 <mem_init+0x2a5>
        totalmem = 1 * 1024 + extmem;
f010163c:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101642:	85 f6                	test   %esi,%esi
f0101644:	0f 44 c3             	cmove  %ebx,%eax
f0101647:	89 87 c0 22 00 00    	mov    %eax,0x22c0(%edi)
    npages = totalmem / (PGSIZE / 1024);
f010164d:	8b 87 c0 22 00 00    	mov    0x22c0(%edi),%eax
f0101653:	c7 c6 08 10 19 f0    	mov    $0xf0191008,%esi
f0101659:	89 c2                	mov    %eax,%edx
f010165b:	c1 ea 02             	shr    $0x2,%edx
f010165e:	89 16                	mov    %edx,(%esi)
    npages_basemem = basemem / (PGSIZE / 1024);
f0101660:	89 da                	mov    %ebx,%edx
f0101662:	c1 ea 02             	shr    $0x2,%edx
f0101665:	89 97 c8 22 00 00    	mov    %edx,0x22c8(%edi)
    cprintf("Physical memory: 0x%xK available\tbase = 0x%xK\textended = 0x%xK\n",
f010166b:	89 c2                	mov    %eax,%edx
f010166d:	29 da                	sub    %ebx,%edx
f010166f:	52                   	push   %edx
f0101670:	53                   	push   %ebx
f0101671:	50                   	push   %eax
f0101672:	8d 87 7c 83 f7 ff    	lea    -0x87c84(%edi),%eax
f0101678:	50                   	push   %eax
f0101679:	89 fb                	mov    %edi,%ebx
f010167b:	e8 e6 2a 00 00       	call   f0104166 <cprintf>
    cprintf("sizeof(uint16_t):0x%x\n", sizeof(unsigned short));
f0101680:	83 c4 08             	add    $0x8,%esp
f0101683:	6a 02                	push   $0x2
f0101685:	8d 87 4c 90 f7 ff    	lea    -0x86fb4(%edi),%eax
f010168b:	50                   	push   %eax
f010168c:	e8 d5 2a 00 00       	call   f0104166 <cprintf>
    cprintf("npages:0x%x\tsizeof(Struct PageInfo):0x%x\n", npages, sizeof(struct PageInfo));
f0101691:	83 c4 0c             	add    $0xc,%esp
f0101694:	6a 08                	push   $0x8
f0101696:	ff 36                	pushl  (%esi)
f0101698:	8d 87 bc 83 f7 ff    	lea    -0x87c44(%edi),%eax
f010169e:	50                   	push   %eax
f010169f:	e8 c2 2a 00 00       	call   f0104166 <cprintf>
    kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01016a4:	b8 00 10 00 00       	mov    $0x1000,%eax
f01016a9:	e8 9c f4 ff ff       	call   f0100b4a <boot_alloc>
f01016ae:	c7 c2 0c 10 19 f0    	mov    $0xf019100c,%edx
f01016b4:	89 02                	mov    %eax,(%edx)
	if ((uint32_t)kva < KERNBASE)
f01016b6:	83 c4 10             	add    $0x10,%esp
f01016b9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01016be:	0f 86 ec 01 00 00    	jbe    f01018b0 <mem_init+0x2b5>
	return (physaddr_t)kva - KERNBASE;
f01016c4:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("kern_pgdir", (uintptr_t) kern_pgdir, PDX(kern_pgdir), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f01016ca:	83 ec 0c             	sub    $0xc,%esp
f01016cd:	89 d1                	mov    %edx,%ecx
f01016cf:	c1 e9 0c             	shr    $0xc,%ecx
f01016d2:	51                   	push   %ecx
f01016d3:	52                   	push   %edx
f01016d4:	89 c2                	mov    %eax,%edx
f01016d6:	c1 ea 16             	shr    $0x16,%edx
f01016d9:	52                   	push   %edx
f01016da:	50                   	push   %eax
f01016db:	8d 87 63 90 f7 ff    	lea    -0x86f9d(%edi),%eax
f01016e1:	50                   	push   %eax
f01016e2:	e8 93 2a 00 00       	call   f010417a <memCprintf>
    memset(kern_pgdir, 0, PGSIZE);
f01016e7:	83 c4 1c             	add    $0x1c,%esp
f01016ea:	68 00 10 00 00       	push   $0x1000
f01016ef:	6a 00                	push   $0x0
f01016f1:	c7 c6 0c 10 19 f0    	mov    $0xf019100c,%esi
f01016f7:	ff 36                	pushl  (%esi)
f01016f9:	e8 1a 3f 00 00       	call   f0105618 <memset>
    kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01016fe:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0101700:	83 c4 10             	add    $0x10,%esp
f0101703:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101708:	0f 86 bb 01 00 00    	jbe    f01018c9 <mem_init+0x2ce>
	return (physaddr_t)kva - KERNBASE;
f010170e:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101714:	89 d1                	mov    %edx,%ecx
f0101716:	83 c9 05             	or     $0x5,%ecx
f0101719:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f010171f:	83 ec 0c             	sub    $0xc,%esp
f0101722:	89 d0                	mov    %edx,%eax
f0101724:	c1 e8 0c             	shr    $0xc,%eax
f0101727:	50                   	push   %eax
f0101728:	52                   	push   %edx
f0101729:	68 bd 03 00 00       	push   $0x3bd
f010172e:	68 00 00 40 ef       	push   $0xef400000
f0101733:	8d 87 6e 90 f7 ff    	lea    -0x86f92(%edi),%eax
f0101739:	50                   	push   %eax
f010173a:	e8 3b 2a 00 00       	call   f010417a <memCprintf>
    pages = boot_alloc(ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f010173f:	83 c4 20             	add    $0x20,%esp
f0101742:	c7 c6 08 10 19 f0    	mov    $0xf0191008,%esi
f0101748:	8b 06                	mov    (%esi),%eax
f010174a:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0101751:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101756:	e8 ef f3 ff ff       	call   f0100b4a <boot_alloc>
f010175b:	c7 c1 10 10 19 f0    	mov    $0xf0191010,%ecx
f0101761:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0101764:	89 01                	mov    %eax,(%ecx)
    memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f0101766:	83 ec 04             	sub    $0x4,%esp
f0101769:	8b 16                	mov    (%esi),%edx
f010176b:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101772:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101778:	52                   	push   %edx
f0101779:	6a 00                	push   $0x0
f010177b:	50                   	push   %eax
f010177c:	e8 97 3e 00 00       	call   f0105618 <memset>
    cprintf("pages占用空间:%dK\n", ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) / 1024);
f0101781:	83 c4 08             	add    $0x8,%esp
f0101784:	8b 06                	mov    (%esi),%eax
f0101786:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010178d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101792:	c1 e8 0a             	shr    $0xa,%eax
f0101795:	50                   	push   %eax
f0101796:	8d 87 73 90 f7 ff    	lea    -0x86f8d(%edi),%eax
f010179c:	50                   	push   %eax
f010179d:	e8 c4 29 00 00       	call   f0104166 <cprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f01017a2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01017a5:	8b 01                	mov    (%ecx),%eax
	if ((uint32_t)kva < KERNBASE)
f01017a7:	83 c4 10             	add    $0x10,%esp
f01017aa:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017af:	0f 86 2d 01 00 00    	jbe    f01018e2 <mem_init+0x2e7>
	return (physaddr_t)kva - KERNBASE;
f01017b5:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017bb:	83 ec 0c             	sub    $0xc,%esp
f01017be:	89 d1                	mov    %edx,%ecx
f01017c0:	c1 e9 0c             	shr    $0xc,%ecx
f01017c3:	51                   	push   %ecx
f01017c4:	52                   	push   %edx
f01017c5:	89 c2                	mov    %eax,%edx
f01017c7:	c1 ea 16             	shr    $0x16,%edx
f01017ca:	52                   	push   %edx
f01017cb:	50                   	push   %eax
f01017cc:	8d 87 88 8f f7 ff    	lea    -0x87078(%edi),%eax
f01017d2:	50                   	push   %eax
f01017d3:	e8 a2 29 00 00       	call   f010417a <memCprintf>
    cprintf("sizeof(struct Env):0x%x\n", sizeof(struct Env));
f01017d8:	83 c4 18             	add    $0x18,%esp
f01017db:	6a 60                	push   $0x60
f01017dd:	8d 87 8a 90 f7 ff    	lea    -0x86f76(%edi),%eax
f01017e3:	50                   	push   %eax
f01017e4:	e8 7d 29 00 00       	call   f0104166 <cprintf>
    envs = boot_alloc(ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f01017e9:	b8 00 80 01 00       	mov    $0x18000,%eax
f01017ee:	e8 57 f3 ff ff       	call   f0100b4a <boot_alloc>
f01017f3:	c7 c6 50 03 19 f0    	mov    $0xf0190350,%esi
f01017f9:	89 06                	mov    %eax,(%esi)
    memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f01017fb:	83 c4 0c             	add    $0xc,%esp
f01017fe:	68 00 80 01 00       	push   $0x18000
f0101803:	6a 00                	push   $0x0
f0101805:	50                   	push   %eax
f0101806:	e8 0d 3e 00 00       	call   f0105618 <memset>
    cprintf("envs take up memory:%dK\n", ROUNDUP(NENV * sizeof(struct Env), PGSIZE) / 1024);
f010180b:	83 c4 08             	add    $0x8,%esp
f010180e:	6a 60                	push   $0x60
f0101810:	8d 87 a3 90 f7 ff    	lea    -0x86f5d(%edi),%eax
f0101816:	50                   	push   %eax
f0101817:	e8 4a 29 00 00       	call   f0104166 <cprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f010181c:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f010181e:	83 c4 10             	add    $0x10,%esp
f0101821:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101826:	0f 86 cf 00 00 00    	jbe    f01018fb <mem_init+0x300>
	return (physaddr_t)kva - KERNBASE;
f010182c:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101832:	83 ec 0c             	sub    $0xc,%esp
f0101835:	89 d1                	mov    %edx,%ecx
f0101837:	c1 e9 0c             	shr    $0xc,%ecx
f010183a:	51                   	push   %ecx
f010183b:	52                   	push   %edx
f010183c:	89 c2                	mov    %eax,%edx
f010183e:	c1 ea 16             	shr    $0x16,%edx
f0101841:	52                   	push   %edx
f0101842:	50                   	push   %eax
f0101843:	8d 87 bc 90 f7 ff    	lea    -0x86f44(%edi),%eax
f0101849:	50                   	push   %eax
f010184a:	e8 2b 29 00 00       	call   f010417a <memCprintf>
    page_init();
f010184f:	83 c4 20             	add    $0x20,%esp
f0101852:	e8 da f7 ff ff       	call   f0101031 <page_init>
    cprintf("\n************* Now Check that the pages on the page_free_list are reasonable ************\n");
f0101857:	83 ec 0c             	sub    $0xc,%esp
f010185a:	8d 87 e8 83 f7 ff    	lea    -0x87c18(%edi),%eax
f0101860:	50                   	push   %eax
f0101861:	e8 00 29 00 00       	call   f0104166 <cprintf>
    check_page_free_list(1);
f0101866:	b8 01 00 00 00       	mov    $0x1,%eax
f010186b:	e8 d4 f3 ff ff       	call   f0100c44 <check_page_free_list>
    cprintf("\n************* Now check the real physical page allocator (page_alloc(), page_free(), and page_init())************\n");
f0101870:	8d 87 44 84 f7 ff    	lea    -0x87bbc(%edi),%eax
f0101876:	89 04 24             	mov    %eax,(%esp)
f0101879:	e8 e8 28 00 00       	call   f0104166 <cprintf>
    if (!pages)
f010187e:	83 c4 10             	add    $0x10,%esp
f0101881:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0101887:	83 38 00             	cmpl   $0x0,(%eax)
f010188a:	0f 84 84 00 00 00    	je     f0101914 <mem_init+0x319>
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101890:	8b 87 c4 22 00 00    	mov    0x22c4(%edi),%eax
f0101896:	be 00 00 00 00       	mov    $0x0,%esi
f010189b:	e9 94 00 00 00       	jmp    f0101934 <mem_init+0x339>
        totalmem = 16 * 1024 + ext16mem;
f01018a0:	05 00 40 00 00       	add    $0x4000,%eax
f01018a5:	89 87 c0 22 00 00    	mov    %eax,0x22c0(%edi)
f01018ab:	e9 9d fd ff ff       	jmp    f010164d <mem_init+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01018b0:	50                   	push   %eax
f01018b1:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f01018b7:	50                   	push   %eax
f01018b8:	68 96 00 00 00       	push   $0x96
f01018bd:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01018c3:	50                   	push   %eax
f01018c4:	e8 bf e8 ff ff       	call   f0100188 <_panic>
f01018c9:	50                   	push   %eax
f01018ca:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f01018d0:	50                   	push   %eax
f01018d1:	68 a0 00 00 00       	push   $0xa0
f01018d6:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01018dc:	50                   	push   %eax
f01018dd:	e8 a6 e8 ff ff       	call   f0100188 <_panic>
f01018e2:	50                   	push   %eax
f01018e3:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f01018e9:	50                   	push   %eax
f01018ea:	68 ad 00 00 00       	push   $0xad
f01018ef:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01018f5:	50                   	push   %eax
f01018f6:	e8 8d e8 ff ff       	call   f0100188 <_panic>
f01018fb:	50                   	push   %eax
f01018fc:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0101902:	50                   	push   %eax
f0101903:	68 b5 00 00 00       	push   $0xb5
f0101908:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010190e:	50                   	push   %eax
f010190f:	e8 74 e8 ff ff       	call   f0100188 <_panic>
        panic("'pages' is a null pointer!");
f0101914:	83 ec 04             	sub    $0x4,%esp
f0101917:	8d 87 c1 90 f7 ff    	lea    -0x86f3f(%edi),%eax
f010191d:	50                   	push   %eax
f010191e:	68 0a 03 00 00       	push   $0x30a
f0101923:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101929:	50                   	push   %eax
f010192a:	e8 59 e8 ff ff       	call   f0100188 <_panic>
        ++nfree;
f010192f:	83 c6 01             	add    $0x1,%esi
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101932:	8b 00                	mov    (%eax),%eax
f0101934:	85 c0                	test   %eax,%eax
f0101936:	75 f7                	jne    f010192f <mem_init+0x334>
    assert((pp0 = page_alloc(0)));
f0101938:	83 ec 0c             	sub    $0xc,%esp
f010193b:	6a 00                	push   $0x0
f010193d:	e8 8a f8 ff ff       	call   f01011cc <page_alloc>
f0101942:	89 c3                	mov    %eax,%ebx
f0101944:	83 c4 10             	add    $0x10,%esp
f0101947:	85 c0                	test   %eax,%eax
f0101949:	0f 84 3f 02 00 00    	je     f0101b8e <mem_init+0x593>
    assert((pp1 = page_alloc(0)));
f010194f:	83 ec 0c             	sub    $0xc,%esp
f0101952:	6a 00                	push   $0x0
f0101954:	e8 73 f8 ff ff       	call   f01011cc <page_alloc>
f0101959:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010195c:	83 c4 10             	add    $0x10,%esp
f010195f:	85 c0                	test   %eax,%eax
f0101961:	0f 84 48 02 00 00    	je     f0101baf <mem_init+0x5b4>
    assert((pp2 = page_alloc(0)));
f0101967:	83 ec 0c             	sub    $0xc,%esp
f010196a:	6a 00                	push   $0x0
f010196c:	e8 5b f8 ff ff       	call   f01011cc <page_alloc>
f0101971:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101974:	83 c4 10             	add    $0x10,%esp
f0101977:	85 c0                	test   %eax,%eax
f0101979:	0f 84 51 02 00 00    	je     f0101bd0 <mem_init+0x5d5>
    assert(pp1 && pp1 != pp0);
f010197f:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0101982:	0f 84 69 02 00 00    	je     f0101bf1 <mem_init+0x5f6>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101988:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010198b:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f010198e:	0f 84 7e 02 00 00    	je     f0101c12 <mem_init+0x617>
f0101994:	39 c3                	cmp    %eax,%ebx
f0101996:	0f 84 76 02 00 00    	je     f0101c12 <mem_init+0x617>
	return (pp - pages) << PGSHIFT;
f010199c:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01019a2:	8b 08                	mov    (%eax),%ecx
    assert(page2pa(pp0) < npages * PGSIZE);
f01019a4:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f01019aa:	8b 10                	mov    (%eax),%edx
f01019ac:	c1 e2 0c             	shl    $0xc,%edx
f01019af:	89 d8                	mov    %ebx,%eax
f01019b1:	29 c8                	sub    %ecx,%eax
f01019b3:	c1 f8 03             	sar    $0x3,%eax
f01019b6:	c1 e0 0c             	shl    $0xc,%eax
f01019b9:	39 d0                	cmp    %edx,%eax
f01019bb:	0f 83 72 02 00 00    	jae    f0101c33 <mem_init+0x638>
f01019c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019c4:	29 c8                	sub    %ecx,%eax
f01019c6:	c1 f8 03             	sar    $0x3,%eax
f01019c9:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp1) < npages * PGSIZE);
f01019cc:	39 c2                	cmp    %eax,%edx
f01019ce:	0f 86 80 02 00 00    	jbe    f0101c54 <mem_init+0x659>
f01019d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01019d7:	29 c8                	sub    %ecx,%eax
f01019d9:	c1 f8 03             	sar    $0x3,%eax
f01019dc:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp2) < npages * PGSIZE);
f01019df:	39 c2                	cmp    %eax,%edx
f01019e1:	0f 86 8e 02 00 00    	jbe    f0101c75 <mem_init+0x67a>
    fl = page_free_list;
f01019e7:	8b 87 c4 22 00 00    	mov    0x22c4(%edi),%eax
f01019ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
    page_free_list = 0;
f01019f0:	c7 87 c4 22 00 00 00 	movl   $0x0,0x22c4(%edi)
f01019f7:	00 00 00 
    assert(!page_alloc(0));
f01019fa:	83 ec 0c             	sub    $0xc,%esp
f01019fd:	6a 00                	push   $0x0
f01019ff:	e8 c8 f7 ff ff       	call   f01011cc <page_alloc>
f0101a04:	83 c4 10             	add    $0x10,%esp
f0101a07:	85 c0                	test   %eax,%eax
f0101a09:	0f 85 87 02 00 00    	jne    f0101c96 <mem_init+0x69b>
    page_free(pp0);
f0101a0f:	83 ec 0c             	sub    $0xc,%esp
f0101a12:	53                   	push   %ebx
f0101a13:	e8 42 f8 ff ff       	call   f010125a <page_free>
    page_free(pp1);
f0101a18:	83 c4 04             	add    $0x4,%esp
f0101a1b:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a1e:	e8 37 f8 ff ff       	call   f010125a <page_free>
    page_free(pp2);
f0101a23:	83 c4 04             	add    $0x4,%esp
f0101a26:	ff 75 d0             	pushl  -0x30(%ebp)
f0101a29:	e8 2c f8 ff ff       	call   f010125a <page_free>
    assert((pp0 = page_alloc(0)));
f0101a2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a35:	e8 92 f7 ff ff       	call   f01011cc <page_alloc>
f0101a3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101a3d:	83 c4 10             	add    $0x10,%esp
f0101a40:	85 c0                	test   %eax,%eax
f0101a42:	0f 84 6f 02 00 00    	je     f0101cb7 <mem_init+0x6bc>
    assert((pp1 = page_alloc(0)));
f0101a48:	83 ec 0c             	sub    $0xc,%esp
f0101a4b:	6a 00                	push   $0x0
f0101a4d:	e8 7a f7 ff ff       	call   f01011cc <page_alloc>
f0101a52:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101a55:	83 c4 10             	add    $0x10,%esp
f0101a58:	85 c0                	test   %eax,%eax
f0101a5a:	0f 84 78 02 00 00    	je     f0101cd8 <mem_init+0x6dd>
    assert((pp2 = page_alloc(0)));
f0101a60:	83 ec 0c             	sub    $0xc,%esp
f0101a63:	6a 00                	push   $0x0
f0101a65:	e8 62 f7 ff ff       	call   f01011cc <page_alloc>
f0101a6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101a6d:	83 c4 10             	add    $0x10,%esp
f0101a70:	85 c0                	test   %eax,%eax
f0101a72:	0f 84 81 02 00 00    	je     f0101cf9 <mem_init+0x6fe>
    assert(pp1 && pp1 != pp0);
f0101a78:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0101a7b:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
f0101a7e:	0f 84 96 02 00 00    	je     f0101d1a <mem_init+0x71f>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a84:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101a87:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101a8a:	0f 84 ab 02 00 00    	je     f0101d3b <mem_init+0x740>
f0101a90:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101a93:	0f 84 a2 02 00 00    	je     f0101d3b <mem_init+0x740>
    assert(!page_alloc(0));
f0101a99:	83 ec 0c             	sub    $0xc,%esp
f0101a9c:	6a 00                	push   $0x0
f0101a9e:	e8 29 f7 ff ff       	call   f01011cc <page_alloc>
f0101aa3:	83 c4 10             	add    $0x10,%esp
f0101aa6:	85 c0                	test   %eax,%eax
f0101aa8:	0f 85 ae 02 00 00    	jne    f0101d5c <mem_init+0x761>
f0101aae:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0101ab4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101ab7:	2b 08                	sub    (%eax),%ecx
f0101ab9:	89 c8                	mov    %ecx,%eax
f0101abb:	c1 f8 03             	sar    $0x3,%eax
f0101abe:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101ac1:	89 c1                	mov    %eax,%ecx
f0101ac3:	c1 e9 0c             	shr    $0xc,%ecx
f0101ac6:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0101acc:	3b 0a                	cmp    (%edx),%ecx
f0101ace:	0f 83 a9 02 00 00    	jae    f0101d7d <mem_init+0x782>
    memset(page2kva(pp0), 1, PGSIZE);
f0101ad4:	83 ec 04             	sub    $0x4,%esp
f0101ad7:	68 00 10 00 00       	push   $0x1000
f0101adc:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101ade:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101ae3:	50                   	push   %eax
f0101ae4:	89 fb                	mov    %edi,%ebx
f0101ae6:	e8 2d 3b 00 00       	call   f0105618 <memset>
    page_free(pp0);
f0101aeb:	83 c4 04             	add    $0x4,%esp
f0101aee:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101af1:	e8 64 f7 ff ff       	call   f010125a <page_free>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101af6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101afd:	e8 ca f6 ff ff       	call   f01011cc <page_alloc>
f0101b02:	83 c4 10             	add    $0x10,%esp
f0101b05:	85 c0                	test   %eax,%eax
f0101b07:	0f 84 88 02 00 00    	je     f0101d95 <mem_init+0x79a>
    assert(pp && pp0 == pp);
f0101b0d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101b10:	0f 85 9e 02 00 00    	jne    f0101db4 <mem_init+0x7b9>
	return (pp - pages) << PGSHIFT;
f0101b16:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0101b1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101b1f:	2b 10                	sub    (%eax),%edx
f0101b21:	c1 fa 03             	sar    $0x3,%edx
f0101b24:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101b27:	89 d1                	mov    %edx,%ecx
f0101b29:	c1 e9 0c             	shr    $0xc,%ecx
f0101b2c:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f0101b32:	3b 08                	cmp    (%eax),%ecx
f0101b34:	0f 83 99 02 00 00    	jae    f0101dd3 <mem_init+0x7d8>
	return (void *)(pa + KERNBASE);
f0101b3a:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101b40:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
        assert(c[i] == 0);
f0101b46:	80 38 00             	cmpb   $0x0,(%eax)
f0101b49:	0f 85 9a 02 00 00    	jne    f0101de9 <mem_init+0x7ee>
f0101b4f:	83 c0 01             	add    $0x1,%eax
    for (i = 0; i < PGSIZE; i++)
f0101b52:	39 d0                	cmp    %edx,%eax
f0101b54:	75 f0                	jne    f0101b46 <mem_init+0x54b>
    page_free_list = fl;
f0101b56:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0101b59:	89 87 c4 22 00 00    	mov    %eax,0x22c4(%edi)
    page_free(pp0);
f0101b5f:	83 ec 0c             	sub    $0xc,%esp
f0101b62:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b65:	e8 f0 f6 ff ff       	call   f010125a <page_free>
    page_free(pp1);
f0101b6a:	83 c4 04             	add    $0x4,%esp
f0101b6d:	ff 75 d0             	pushl  -0x30(%ebp)
f0101b70:	e8 e5 f6 ff ff       	call   f010125a <page_free>
    page_free(pp2);
f0101b75:	83 c4 04             	add    $0x4,%esp
f0101b78:	ff 75 cc             	pushl  -0x34(%ebp)
f0101b7b:	e8 da f6 ff ff       	call   f010125a <page_free>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101b80:	8b 87 c4 22 00 00    	mov    0x22c4(%edi),%eax
f0101b86:	83 c4 10             	add    $0x10,%esp
f0101b89:	e9 81 02 00 00       	jmp    f0101e0f <mem_init+0x814>
    assert((pp0 = page_alloc(0)));
f0101b8e:	8d 87 dc 90 f7 ff    	lea    -0x86f24(%edi),%eax
f0101b94:	50                   	push   %eax
f0101b95:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101b9b:	50                   	push   %eax
f0101b9c:	68 12 03 00 00       	push   $0x312
f0101ba1:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101ba7:	50                   	push   %eax
f0101ba8:	89 fb                	mov    %edi,%ebx
f0101baa:	e8 d9 e5 ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0101baf:	8d 87 f2 90 f7 ff    	lea    -0x86f0e(%edi),%eax
f0101bb5:	50                   	push   %eax
f0101bb6:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101bbc:	50                   	push   %eax
f0101bbd:	68 13 03 00 00       	push   $0x313
f0101bc2:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101bc8:	50                   	push   %eax
f0101bc9:	89 fb                	mov    %edi,%ebx
f0101bcb:	e8 b8 e5 ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0101bd0:	8d 87 08 91 f7 ff    	lea    -0x86ef8(%edi),%eax
f0101bd6:	50                   	push   %eax
f0101bd7:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101bdd:	50                   	push   %eax
f0101bde:	68 14 03 00 00       	push   $0x314
f0101be3:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101be9:	50                   	push   %eax
f0101bea:	89 fb                	mov    %edi,%ebx
f0101bec:	e8 97 e5 ff ff       	call   f0100188 <_panic>
    assert(pp1 && pp1 != pp0);
f0101bf1:	8d 87 1e 91 f7 ff    	lea    -0x86ee2(%edi),%eax
f0101bf7:	50                   	push   %eax
f0101bf8:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101bfe:	50                   	push   %eax
f0101bff:	68 17 03 00 00       	push   $0x317
f0101c04:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101c0a:	50                   	push   %eax
f0101c0b:	89 fb                	mov    %edi,%ebx
f0101c0d:	e8 76 e5 ff ff       	call   f0100188 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c12:	8d 87 b8 84 f7 ff    	lea    -0x87b48(%edi),%eax
f0101c18:	50                   	push   %eax
f0101c19:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101c1f:	50                   	push   %eax
f0101c20:	68 18 03 00 00       	push   $0x318
f0101c25:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101c2b:	50                   	push   %eax
f0101c2c:	89 fb                	mov    %edi,%ebx
f0101c2e:	e8 55 e5 ff ff       	call   f0100188 <_panic>
    assert(page2pa(pp0) < npages * PGSIZE);
f0101c33:	8d 87 d8 84 f7 ff    	lea    -0x87b28(%edi),%eax
f0101c39:	50                   	push   %eax
f0101c3a:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101c40:	50                   	push   %eax
f0101c41:	68 19 03 00 00       	push   $0x319
f0101c46:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101c4c:	50                   	push   %eax
f0101c4d:	89 fb                	mov    %edi,%ebx
f0101c4f:	e8 34 e5 ff ff       	call   f0100188 <_panic>
    assert(page2pa(pp1) < npages * PGSIZE);
f0101c54:	8d 87 f8 84 f7 ff    	lea    -0x87b08(%edi),%eax
f0101c5a:	50                   	push   %eax
f0101c5b:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101c61:	50                   	push   %eax
f0101c62:	68 1a 03 00 00       	push   $0x31a
f0101c67:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101c6d:	50                   	push   %eax
f0101c6e:	89 fb                	mov    %edi,%ebx
f0101c70:	e8 13 e5 ff ff       	call   f0100188 <_panic>
    assert(page2pa(pp2) < npages * PGSIZE);
f0101c75:	8d 87 18 85 f7 ff    	lea    -0x87ae8(%edi),%eax
f0101c7b:	50                   	push   %eax
f0101c7c:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101c82:	50                   	push   %eax
f0101c83:	68 1b 03 00 00       	push   $0x31b
f0101c88:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101c8e:	50                   	push   %eax
f0101c8f:	89 fb                	mov    %edi,%ebx
f0101c91:	e8 f2 e4 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0101c96:	8d 87 30 91 f7 ff    	lea    -0x86ed0(%edi),%eax
f0101c9c:	50                   	push   %eax
f0101c9d:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101ca3:	50                   	push   %eax
f0101ca4:	68 22 03 00 00       	push   $0x322
f0101ca9:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101caf:	50                   	push   %eax
f0101cb0:	89 fb                	mov    %edi,%ebx
f0101cb2:	e8 d1 e4 ff ff       	call   f0100188 <_panic>
    assert((pp0 = page_alloc(0)));
f0101cb7:	8d 87 dc 90 f7 ff    	lea    -0x86f24(%edi),%eax
f0101cbd:	50                   	push   %eax
f0101cbe:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101cc4:	50                   	push   %eax
f0101cc5:	68 29 03 00 00       	push   $0x329
f0101cca:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101cd0:	50                   	push   %eax
f0101cd1:	89 fb                	mov    %edi,%ebx
f0101cd3:	e8 b0 e4 ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0101cd8:	8d 87 f2 90 f7 ff    	lea    -0x86f0e(%edi),%eax
f0101cde:	50                   	push   %eax
f0101cdf:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101ce5:	50                   	push   %eax
f0101ce6:	68 2a 03 00 00       	push   $0x32a
f0101ceb:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101cf1:	50                   	push   %eax
f0101cf2:	89 fb                	mov    %edi,%ebx
f0101cf4:	e8 8f e4 ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0101cf9:	8d 87 08 91 f7 ff    	lea    -0x86ef8(%edi),%eax
f0101cff:	50                   	push   %eax
f0101d00:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101d06:	50                   	push   %eax
f0101d07:	68 2b 03 00 00       	push   $0x32b
f0101d0c:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101d12:	50                   	push   %eax
f0101d13:	89 fb                	mov    %edi,%ebx
f0101d15:	e8 6e e4 ff ff       	call   f0100188 <_panic>
    assert(pp1 && pp1 != pp0);
f0101d1a:	8d 87 1e 91 f7 ff    	lea    -0x86ee2(%edi),%eax
f0101d20:	50                   	push   %eax
f0101d21:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101d27:	50                   	push   %eax
f0101d28:	68 2d 03 00 00       	push   $0x32d
f0101d2d:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101d33:	50                   	push   %eax
f0101d34:	89 fb                	mov    %edi,%ebx
f0101d36:	e8 4d e4 ff ff       	call   f0100188 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d3b:	8d 87 b8 84 f7 ff    	lea    -0x87b48(%edi),%eax
f0101d41:	50                   	push   %eax
f0101d42:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101d48:	50                   	push   %eax
f0101d49:	68 2e 03 00 00       	push   $0x32e
f0101d4e:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101d54:	50                   	push   %eax
f0101d55:	89 fb                	mov    %edi,%ebx
f0101d57:	e8 2c e4 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0101d5c:	8d 87 30 91 f7 ff    	lea    -0x86ed0(%edi),%eax
f0101d62:	50                   	push   %eax
f0101d63:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101d69:	50                   	push   %eax
f0101d6a:	68 2f 03 00 00       	push   $0x32f
f0101d6f:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101d75:	50                   	push   %eax
f0101d76:	89 fb                	mov    %edi,%ebx
f0101d78:	e8 0b e4 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101d7d:	50                   	push   %eax
f0101d7e:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0101d84:	50                   	push   %eax
f0101d85:	6a 56                	push   $0x56
f0101d87:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f0101d8d:	50                   	push   %eax
f0101d8e:	89 fb                	mov    %edi,%ebx
f0101d90:	e8 f3 e3 ff ff       	call   f0100188 <_panic>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101d95:	8d 87 3f 91 f7 ff    	lea    -0x86ec1(%edi),%eax
f0101d9b:	50                   	push   %eax
f0101d9c:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101da2:	50                   	push   %eax
f0101da3:	68 34 03 00 00       	push   $0x334
f0101da8:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101dae:	50                   	push   %eax
f0101daf:	e8 d4 e3 ff ff       	call   f0100188 <_panic>
    assert(pp && pp0 == pp);
f0101db4:	8d 87 5d 91 f7 ff    	lea    -0x86ea3(%edi),%eax
f0101dba:	50                   	push   %eax
f0101dbb:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101dc1:	50                   	push   %eax
f0101dc2:	68 35 03 00 00       	push   $0x335
f0101dc7:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101dcd:	50                   	push   %eax
f0101dce:	e8 b5 e3 ff ff       	call   f0100188 <_panic>
f0101dd3:	52                   	push   %edx
f0101dd4:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0101dda:	50                   	push   %eax
f0101ddb:	6a 56                	push   $0x56
f0101ddd:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f0101de3:	50                   	push   %eax
f0101de4:	e8 9f e3 ff ff       	call   f0100188 <_panic>
        assert(c[i] == 0);
f0101de9:	8d 87 6d 91 f7 ff    	lea    -0x86e93(%edi),%eax
f0101def:	50                   	push   %eax
f0101df0:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0101df6:	50                   	push   %eax
f0101df7:	68 38 03 00 00       	push   $0x338
f0101dfc:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0101e02:	50                   	push   %eax
f0101e03:	89 fb                	mov    %edi,%ebx
f0101e05:	e8 7e e3 ff ff       	call   f0100188 <_panic>
        --nfree;
f0101e0a:	83 ee 01             	sub    $0x1,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101e0d:	8b 00                	mov    (%eax),%eax
f0101e0f:	85 c0                	test   %eax,%eax
f0101e11:	75 f7                	jne    f0101e0a <mem_init+0x80f>
    assert(nfree == 0);
f0101e13:	85 f6                	test   %esi,%esi
f0101e15:	0f 85 f7 09 00 00    	jne    f0102812 <mem_init+0x1217>
    cprintf("check_page_alloc() succeeded!\n");
f0101e1b:	83 ec 0c             	sub    $0xc,%esp
f0101e1e:	8d 87 38 85 f7 ff    	lea    -0x87ac8(%edi),%eax
f0101e24:	50                   	push   %eax
f0101e25:	89 fb                	mov    %edi,%ebx
f0101e27:	e8 3a 23 00 00       	call   f0104166 <cprintf>
    cprintf("\n************* Now check page_insert, page_remove, &c **************\n");
f0101e2c:	8d 87 58 85 f7 ff    	lea    -0x87aa8(%edi),%eax
f0101e32:	89 04 24             	mov    %eax,(%esp)
f0101e35:	e8 2c 23 00 00       	call   f0104166 <cprintf>
    int i;
    extern pde_t entry_pgdir[];

    // should be able to allocate three pages
    pp0 = pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0101e3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e41:	e8 86 f3 ff ff       	call   f01011cc <page_alloc>
f0101e46:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e49:	83 c4 10             	add    $0x10,%esp
f0101e4c:	85 c0                	test   %eax,%eax
f0101e4e:	0f 84 df 09 00 00    	je     f0102833 <mem_init+0x1238>
    assert((pp1 = page_alloc(0)));
f0101e54:	83 ec 0c             	sub    $0xc,%esp
f0101e57:	6a 00                	push   $0x0
f0101e59:	e8 6e f3 ff ff       	call   f01011cc <page_alloc>
f0101e5e:	89 c6                	mov    %eax,%esi
f0101e60:	83 c4 10             	add    $0x10,%esp
f0101e63:	85 c0                	test   %eax,%eax
f0101e65:	0f 84 e7 09 00 00    	je     f0102852 <mem_init+0x1257>
    assert((pp2 = page_alloc(0)));
f0101e6b:	83 ec 0c             	sub    $0xc,%esp
f0101e6e:	6a 00                	push   $0x0
f0101e70:	e8 57 f3 ff ff       	call   f01011cc <page_alloc>
f0101e75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e78:	83 c4 10             	add    $0x10,%esp
f0101e7b:	85 c0                	test   %eax,%eax
f0101e7d:	0f 84 ee 09 00 00    	je     f0102871 <mem_init+0x1276>

    assert(pp0);
    assert(pp1 && pp1 != pp0);
f0101e83:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0101e86:	0f 84 04 0a 00 00    	je     f0102890 <mem_init+0x1295>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e8f:	39 c6                	cmp    %eax,%esi
f0101e91:	0f 84 18 0a 00 00    	je     f01028af <mem_init+0x12b4>
f0101e97:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101e9a:	0f 84 0f 0a 00 00    	je     f01028af <mem_init+0x12b4>

    // temporarily steal the rest of the free pages
    fl = page_free_list;
f0101ea0:	8b 87 c4 22 00 00    	mov    0x22c4(%edi),%eax
f0101ea6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    page_free_list = 0;
f0101ea9:	c7 87 c4 22 00 00 00 	movl   $0x0,0x22c4(%edi)
f0101eb0:	00 00 00 

    // should be no free memory
    assert(!page_alloc(0));
f0101eb3:	83 ec 0c             	sub    $0xc,%esp
f0101eb6:	6a 00                	push   $0x0
f0101eb8:	e8 0f f3 ff ff       	call   f01011cc <page_alloc>
f0101ebd:	83 c4 10             	add    $0x10,%esp
f0101ec0:	85 c0                	test   %eax,%eax
f0101ec2:	0f 85 08 0a 00 00    	jne    f01028d0 <mem_init+0x12d5>

    // there is no page allocated at address 0
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101ec8:	83 ec 04             	sub    $0x4,%esp
f0101ecb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101ece:	50                   	push   %eax
f0101ecf:	6a 00                	push   $0x0
f0101ed1:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0101ed7:	ff 30                	pushl  (%eax)
f0101ed9:	e8 07 f5 ff ff       	call   f01013e5 <page_lookup>
f0101ede:	83 c4 10             	add    $0x10,%esp
f0101ee1:	85 c0                	test   %eax,%eax
f0101ee3:	0f 85 06 0a 00 00    	jne    f01028ef <mem_init+0x12f4>

    // there is no free memory, so we can't allocate a page table
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101ee9:	6a 02                	push   $0x2
f0101eeb:	6a 00                	push   $0x0
f0101eed:	56                   	push   %esi
f0101eee:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0101ef4:	ff 30                	pushl  (%eax)
f0101ef6:	e8 ab f5 ff ff       	call   f01014a6 <page_insert>
f0101efb:	83 c4 10             	add    $0x10,%esp
f0101efe:	85 c0                	test   %eax,%eax
f0101f00:	0f 89 08 0a 00 00    	jns    f010290e <mem_init+0x1313>

    // free pp0 and try again: pp0 should be used for page table
    page_free(pp0);
f0101f06:	83 ec 0c             	sub    $0xc,%esp
f0101f09:	ff 75 d0             	pushl  -0x30(%ebp)
f0101f0c:	e8 49 f3 ff ff       	call   f010125a <page_free>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101f11:	6a 02                	push   $0x2
f0101f13:	6a 00                	push   $0x0
f0101f15:	56                   	push   %esi
f0101f16:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0101f1c:	ff 30                	pushl  (%eax)
f0101f1e:	e8 83 f5 ff ff       	call   f01014a6 <page_insert>
f0101f23:	83 c4 20             	add    $0x20,%esp
f0101f26:	85 c0                	test   %eax,%eax
f0101f28:	0f 85 ff 09 00 00    	jne    f010292d <mem_init+0x1332>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f2e:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0101f34:	8b 18                	mov    (%eax),%ebx
	return (pp - pages) << PGSHIFT;
f0101f36:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0101f3c:	8b 08                	mov    (%eax),%ecx
f0101f3e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0101f41:	8b 13                	mov    (%ebx),%edx
f0101f43:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f49:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f4c:	29 c8                	sub    %ecx,%eax
f0101f4e:	c1 f8 03             	sar    $0x3,%eax
f0101f51:	c1 e0 0c             	shl    $0xc,%eax
f0101f54:	39 c2                	cmp    %eax,%edx
f0101f56:	0f 85 f0 09 00 00    	jne    f010294c <mem_init+0x1351>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101f5c:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f61:	89 d8                	mov    %ebx,%eax
f0101f63:	e8 5f ec ff ff       	call   f0100bc7 <check_va2pa>
f0101f68:	89 f2                	mov    %esi,%edx
f0101f6a:	2b 55 cc             	sub    -0x34(%ebp),%edx
f0101f6d:	c1 fa 03             	sar    $0x3,%edx
f0101f70:	c1 e2 0c             	shl    $0xc,%edx
f0101f73:	39 d0                	cmp    %edx,%eax
f0101f75:	0f 85 f2 09 00 00    	jne    f010296d <mem_init+0x1372>
    assert(pp1->pp_ref == 1);
f0101f7b:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101f80:	0f 85 08 0a 00 00    	jne    f010298e <mem_init+0x1393>
    assert(pp0->pp_ref == 1);
f0101f86:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f89:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f8e:	0f 85 1b 0a 00 00    	jne    f01029af <mem_init+0x13b4>

    // should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101f94:	6a 02                	push   $0x2
f0101f96:	68 00 10 00 00       	push   $0x1000
f0101f9b:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101f9e:	53                   	push   %ebx
f0101f9f:	e8 02 f5 ff ff       	call   f01014a6 <page_insert>
f0101fa4:	83 c4 10             	add    $0x10,%esp
f0101fa7:	85 c0                	test   %eax,%eax
f0101fa9:	0f 85 21 0a 00 00    	jne    f01029d0 <mem_init+0x13d5>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101faf:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101fb4:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0101fba:	8b 00                	mov    (%eax),%eax
f0101fbc:	e8 06 ec ff ff       	call   f0100bc7 <check_va2pa>
f0101fc1:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f0101fc7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101fca:	2b 0a                	sub    (%edx),%ecx
f0101fcc:	89 ca                	mov    %ecx,%edx
f0101fce:	c1 fa 03             	sar    $0x3,%edx
f0101fd1:	c1 e2 0c             	shl    $0xc,%edx
f0101fd4:	39 d0                	cmp    %edx,%eax
f0101fd6:	0f 85 15 0a 00 00    	jne    f01029f1 <mem_init+0x13f6>
    assert(pp2->pp_ref == 1);
f0101fdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fdf:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101fe4:	0f 85 28 0a 00 00    	jne    f0102a12 <mem_init+0x1417>

    // should be no free memory
    assert(!page_alloc(0));
f0101fea:	83 ec 0c             	sub    $0xc,%esp
f0101fed:	6a 00                	push   $0x0
f0101fef:	e8 d8 f1 ff ff       	call   f01011cc <page_alloc>
f0101ff4:	83 c4 10             	add    $0x10,%esp
f0101ff7:	85 c0                	test   %eax,%eax
f0101ff9:	0f 85 34 0a 00 00    	jne    f0102a33 <mem_init+0x1438>

    // should be able to map pp2 at PGSIZE because it's already there
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101fff:	6a 02                	push   $0x2
f0102001:	68 00 10 00 00       	push   $0x1000
f0102006:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102009:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f010200f:	ff 30                	pushl  (%eax)
f0102011:	e8 90 f4 ff ff       	call   f01014a6 <page_insert>
f0102016:	83 c4 10             	add    $0x10,%esp
f0102019:	85 c0                	test   %eax,%eax
f010201b:	0f 85 33 0a 00 00    	jne    f0102a54 <mem_init+0x1459>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102021:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102026:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f010202c:	8b 00                	mov    (%eax),%eax
f010202e:	e8 94 eb ff ff       	call   f0100bc7 <check_va2pa>
f0102033:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f0102039:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010203c:	2b 0a                	sub    (%edx),%ecx
f010203e:	89 ca                	mov    %ecx,%edx
f0102040:	c1 fa 03             	sar    $0x3,%edx
f0102043:	c1 e2 0c             	shl    $0xc,%edx
f0102046:	39 d0                	cmp    %edx,%eax
f0102048:	0f 85 27 0a 00 00    	jne    f0102a75 <mem_init+0x147a>
    assert(pp2->pp_ref == 1);
f010204e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102051:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102056:	0f 85 3a 0a 00 00    	jne    f0102a96 <mem_init+0x149b>

    // pp2 should NOT be on the free list
    // could happen in ref counts are handled sloppily in page_insert
    assert(!page_alloc(0));
f010205c:	83 ec 0c             	sub    $0xc,%esp
f010205f:	6a 00                	push   $0x0
f0102061:	e8 66 f1 ff ff       	call   f01011cc <page_alloc>
f0102066:	83 c4 10             	add    $0x10,%esp
f0102069:	85 c0                	test   %eax,%eax
f010206b:	0f 85 46 0a 00 00    	jne    f0102ab7 <mem_init+0x14bc>

    // check that pgdir_walk returns a pointer to the pte
    ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102071:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0102077:	8b 10                	mov    (%eax),%edx
f0102079:	8b 02                	mov    (%edx),%eax
f010207b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102080:	89 c3                	mov    %eax,%ebx
f0102082:	c1 eb 0c             	shr    $0xc,%ebx
f0102085:	c7 c1 08 10 19 f0    	mov    $0xf0191008,%ecx
f010208b:	3b 19                	cmp    (%ecx),%ebx
f010208d:	0f 83 45 0a 00 00    	jae    f0102ad8 <mem_init+0x14dd>
	return (void *)(pa + KERNBASE);
f0102093:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f010209b:	83 ec 04             	sub    $0x4,%esp
f010209e:	6a 00                	push   $0x0
f01020a0:	68 00 10 00 00       	push   $0x1000
f01020a5:	52                   	push   %edx
f01020a6:	e8 4a f2 ff ff       	call   f01012f5 <pgdir_walk>
f01020ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01020ae:	8d 51 04             	lea    0x4(%ecx),%edx
f01020b1:	83 c4 10             	add    $0x10,%esp
f01020b4:	39 d0                	cmp    %edx,%eax
f01020b6:	0f 85 37 0a 00 00    	jne    f0102af3 <mem_init+0x14f8>

    // should be able to change permissions too.
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f01020bc:	6a 06                	push   $0x6
f01020be:	68 00 10 00 00       	push   $0x1000
f01020c3:	ff 75 d4             	pushl  -0x2c(%ebp)
f01020c6:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01020cc:	ff 30                	pushl  (%eax)
f01020ce:	e8 d3 f3 ff ff       	call   f01014a6 <page_insert>
f01020d3:	83 c4 10             	add    $0x10,%esp
f01020d6:	85 c0                	test   %eax,%eax
f01020d8:	0f 85 36 0a 00 00    	jne    f0102b14 <mem_init+0x1519>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01020de:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01020e4:	8b 18                	mov    (%eax),%ebx
f01020e6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020eb:	89 d8                	mov    %ebx,%eax
f01020ed:	e8 d5 ea ff ff       	call   f0100bc7 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f01020f2:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f01020f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01020fb:	2b 0a                	sub    (%edx),%ecx
f01020fd:	89 ca                	mov    %ecx,%edx
f01020ff:	c1 fa 03             	sar    $0x3,%edx
f0102102:	c1 e2 0c             	shl    $0xc,%edx
f0102105:	39 d0                	cmp    %edx,%eax
f0102107:	0f 85 28 0a 00 00    	jne    f0102b35 <mem_init+0x153a>
    assert(pp2->pp_ref == 1);
f010210d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102110:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102115:	0f 85 3b 0a 00 00    	jne    f0102b56 <mem_init+0x155b>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f010211b:	83 ec 04             	sub    $0x4,%esp
f010211e:	6a 00                	push   $0x0
f0102120:	68 00 10 00 00       	push   $0x1000
f0102125:	53                   	push   %ebx
f0102126:	e8 ca f1 ff ff       	call   f01012f5 <pgdir_walk>
f010212b:	83 c4 10             	add    $0x10,%esp
f010212e:	f6 00 04             	testb  $0x4,(%eax)
f0102131:	0f 84 40 0a 00 00    	je     f0102b77 <mem_init+0x157c>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f0102137:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f010213d:	8b 00                	mov    (%eax),%eax
f010213f:	f6 00 04             	testb  $0x4,(%eax)
f0102142:	0f 84 50 0a 00 00    	je     f0102b98 <mem_init+0x159d>

    // should be able to remap with fewer permissions
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102148:	6a 02                	push   $0x2
f010214a:	68 00 10 00 00       	push   $0x1000
f010214f:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102152:	50                   	push   %eax
f0102153:	e8 4e f3 ff ff       	call   f01014a6 <page_insert>
f0102158:	83 c4 10             	add    $0x10,%esp
f010215b:	85 c0                	test   %eax,%eax
f010215d:	0f 85 56 0a 00 00    	jne    f0102bb9 <mem_init+0x15be>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102163:	83 ec 04             	sub    $0x4,%esp
f0102166:	6a 00                	push   $0x0
f0102168:	68 00 10 00 00       	push   $0x1000
f010216d:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0102173:	ff 30                	pushl  (%eax)
f0102175:	e8 7b f1 ff ff       	call   f01012f5 <pgdir_walk>
f010217a:	83 c4 10             	add    $0x10,%esp
f010217d:	f6 00 02             	testb  $0x2,(%eax)
f0102180:	0f 84 54 0a 00 00    	je     f0102bda <mem_init+0x15df>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102186:	83 ec 04             	sub    $0x4,%esp
f0102189:	6a 00                	push   $0x0
f010218b:	68 00 10 00 00       	push   $0x1000
f0102190:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0102196:	ff 30                	pushl  (%eax)
f0102198:	e8 58 f1 ff ff       	call   f01012f5 <pgdir_walk>
f010219d:	83 c4 10             	add    $0x10,%esp
f01021a0:	f6 00 04             	testb  $0x4,(%eax)
f01021a3:	0f 85 52 0a 00 00    	jne    f0102bfb <mem_init+0x1600>

    // should not be able to map at PTSIZE because need free page for page table
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f01021a9:	6a 02                	push   $0x2
f01021ab:	68 00 00 40 00       	push   $0x400000
f01021b0:	ff 75 d0             	pushl  -0x30(%ebp)
f01021b3:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01021b9:	ff 30                	pushl  (%eax)
f01021bb:	e8 e6 f2 ff ff       	call   f01014a6 <page_insert>
f01021c0:	83 c4 10             	add    $0x10,%esp
f01021c3:	85 c0                	test   %eax,%eax
f01021c5:	0f 89 51 0a 00 00    	jns    f0102c1c <mem_init+0x1621>

    // insert pp1 at PGSIZE (replacing pp2)
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f01021cb:	6a 02                	push   $0x2
f01021cd:	68 00 10 00 00       	push   $0x1000
f01021d2:	56                   	push   %esi
f01021d3:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01021d9:	ff 30                	pushl  (%eax)
f01021db:	e8 c6 f2 ff ff       	call   f01014a6 <page_insert>
f01021e0:	83 c4 10             	add    $0x10,%esp
f01021e3:	85 c0                	test   %eax,%eax
f01021e5:	0f 85 52 0a 00 00    	jne    f0102c3d <mem_init+0x1642>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f01021eb:	83 ec 04             	sub    $0x4,%esp
f01021ee:	6a 00                	push   $0x0
f01021f0:	68 00 10 00 00       	push   $0x1000
f01021f5:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01021fb:	ff 30                	pushl  (%eax)
f01021fd:	e8 f3 f0 ff ff       	call   f01012f5 <pgdir_walk>
f0102202:	83 c4 10             	add    $0x10,%esp
f0102205:	f6 00 04             	testb  $0x4,(%eax)
f0102208:	0f 85 50 0a 00 00    	jne    f0102c5e <mem_init+0x1663>

    // should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010220e:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0102214:	8b 18                	mov    (%eax),%ebx
f0102216:	ba 00 00 00 00       	mov    $0x0,%edx
f010221b:	89 d8                	mov    %ebx,%eax
f010221d:	e8 a5 e9 ff ff       	call   f0100bc7 <check_va2pa>
f0102222:	89 c2                	mov    %eax,%edx
f0102224:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102227:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f010222d:	89 f1                	mov    %esi,%ecx
f010222f:	2b 08                	sub    (%eax),%ecx
f0102231:	89 c8                	mov    %ecx,%eax
f0102233:	c1 f8 03             	sar    $0x3,%eax
f0102236:	c1 e0 0c             	shl    $0xc,%eax
f0102239:	39 c2                	cmp    %eax,%edx
f010223b:	0f 85 3e 0a 00 00    	jne    f0102c7f <mem_init+0x1684>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102241:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102246:	89 d8                	mov    %ebx,%eax
f0102248:	e8 7a e9 ff ff       	call   f0100bc7 <check_va2pa>
f010224d:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0102250:	0f 85 4a 0a 00 00    	jne    f0102ca0 <mem_init+0x16a5>
    // ... and ref counts should reflect this
    assert(pp1->pp_ref == 2);
f0102256:	66 83 7e 04 02       	cmpw   $0x2,0x4(%esi)
f010225b:	0f 85 60 0a 00 00    	jne    f0102cc1 <mem_init+0x16c6>
    assert(pp2->pp_ref == 0);
f0102261:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102264:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102269:	0f 85 73 0a 00 00    	jne    f0102ce2 <mem_init+0x16e7>

    // pp2 should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp2);
f010226f:	83 ec 0c             	sub    $0xc,%esp
f0102272:	6a 00                	push   $0x0
f0102274:	e8 53 ef ff ff       	call   f01011cc <page_alloc>
f0102279:	83 c4 10             	add    $0x10,%esp
f010227c:	85 c0                	test   %eax,%eax
f010227e:	0f 84 7f 0a 00 00    	je     f0102d03 <mem_init+0x1708>
f0102284:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0102287:	0f 85 76 0a 00 00    	jne    f0102d03 <mem_init+0x1708>

    // unmapping pp1 at 0 should keep pp1 at PGSIZE
    page_remove(kern_pgdir, 0x0);
f010228d:	83 ec 08             	sub    $0x8,%esp
f0102290:	6a 00                	push   $0x0
f0102292:	c7 c3 0c 10 19 f0    	mov    $0xf019100c,%ebx
f0102298:	ff 33                	pushl  (%ebx)
f010229a:	e8 b6 f1 ff ff       	call   f0101455 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010229f:	8b 1b                	mov    (%ebx),%ebx
f01022a1:	ba 00 00 00 00       	mov    $0x0,%edx
f01022a6:	89 d8                	mov    %ebx,%eax
f01022a8:	e8 1a e9 ff ff       	call   f0100bc7 <check_va2pa>
f01022ad:	83 c4 10             	add    $0x10,%esp
f01022b0:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022b3:	0f 85 6b 0a 00 00    	jne    f0102d24 <mem_init+0x1729>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01022b9:	ba 00 10 00 00       	mov    $0x1000,%edx
f01022be:	89 d8                	mov    %ebx,%eax
f01022c0:	e8 02 e9 ff ff       	call   f0100bc7 <check_va2pa>
f01022c5:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f01022cb:	89 f1                	mov    %esi,%ecx
f01022cd:	2b 0a                	sub    (%edx),%ecx
f01022cf:	89 ca                	mov    %ecx,%edx
f01022d1:	c1 fa 03             	sar    $0x3,%edx
f01022d4:	c1 e2 0c             	shl    $0xc,%edx
f01022d7:	39 d0                	cmp    %edx,%eax
f01022d9:	0f 85 66 0a 00 00    	jne    f0102d45 <mem_init+0x174a>
    assert(pp1->pp_ref == 1);
f01022df:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01022e4:	0f 85 7c 0a 00 00    	jne    f0102d66 <mem_init+0x176b>
    assert(pp2->pp_ref == 0);
f01022ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01022ed:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01022f2:	0f 85 8f 0a 00 00    	jne    f0102d87 <mem_init+0x178c>

    // test re-inserting pp1 at PGSIZE
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f01022f8:	6a 00                	push   $0x0
f01022fa:	68 00 10 00 00       	push   $0x1000
f01022ff:	56                   	push   %esi
f0102300:	53                   	push   %ebx
f0102301:	e8 a0 f1 ff ff       	call   f01014a6 <page_insert>
f0102306:	83 c4 10             	add    $0x10,%esp
f0102309:	85 c0                	test   %eax,%eax
f010230b:	0f 85 97 0a 00 00    	jne    f0102da8 <mem_init+0x17ad>
    assert(pp1->pp_ref);
f0102311:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102316:	0f 84 ad 0a 00 00    	je     f0102dc9 <mem_init+0x17ce>
    assert(pp1->pp_link == NULL);
f010231c:	83 3e 00             	cmpl   $0x0,(%esi)
f010231f:	0f 85 c5 0a 00 00    	jne    f0102dea <mem_init+0x17ef>

    // unmapping pp1 at PGSIZE should free it
    page_remove(kern_pgdir, (void *) PGSIZE);
f0102325:	83 ec 08             	sub    $0x8,%esp
f0102328:	68 00 10 00 00       	push   $0x1000
f010232d:	c7 c3 0c 10 19 f0    	mov    $0xf019100c,%ebx
f0102333:	ff 33                	pushl  (%ebx)
f0102335:	e8 1b f1 ff ff       	call   f0101455 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010233a:	8b 1b                	mov    (%ebx),%ebx
f010233c:	ba 00 00 00 00       	mov    $0x0,%edx
f0102341:	89 d8                	mov    %ebx,%eax
f0102343:	e8 7f e8 ff ff       	call   f0100bc7 <check_va2pa>
f0102348:	83 c4 10             	add    $0x10,%esp
f010234b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010234e:	0f 85 b7 0a 00 00    	jne    f0102e0b <mem_init+0x1810>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102354:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102359:	89 d8                	mov    %ebx,%eax
f010235b:	e8 67 e8 ff ff       	call   f0100bc7 <check_va2pa>
f0102360:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102363:	0f 85 c3 0a 00 00    	jne    f0102e2c <mem_init+0x1831>
    assert(pp1->pp_ref == 0);
f0102369:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f010236e:	0f 85 d9 0a 00 00    	jne    f0102e4d <mem_init+0x1852>
    assert(pp2->pp_ref == 0);
f0102374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102377:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010237c:	0f 85 ec 0a 00 00    	jne    f0102e6e <mem_init+0x1873>

    // so it should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp1);
f0102382:	83 ec 0c             	sub    $0xc,%esp
f0102385:	6a 00                	push   $0x0
f0102387:	e8 40 ee ff ff       	call   f01011cc <page_alloc>
f010238c:	83 c4 10             	add    $0x10,%esp
f010238f:	39 c6                	cmp    %eax,%esi
f0102391:	0f 85 f8 0a 00 00    	jne    f0102e8f <mem_init+0x1894>
f0102397:	85 c0                	test   %eax,%eax
f0102399:	0f 84 f0 0a 00 00    	je     f0102e8f <mem_init+0x1894>

    // should be no free memory
    assert(!page_alloc(0));
f010239f:	83 ec 0c             	sub    $0xc,%esp
f01023a2:	6a 00                	push   $0x0
f01023a4:	e8 23 ee ff ff       	call   f01011cc <page_alloc>
f01023a9:	83 c4 10             	add    $0x10,%esp
f01023ac:	85 c0                	test   %eax,%eax
f01023ae:	0f 85 fc 0a 00 00    	jne    f0102eb0 <mem_init+0x18b5>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023b4:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01023ba:	8b 08                	mov    (%eax),%ecx
f01023bc:	8b 11                	mov    (%ecx),%edx
f01023be:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01023c4:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01023ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01023cd:	2b 18                	sub    (%eax),%ebx
f01023cf:	89 d8                	mov    %ebx,%eax
f01023d1:	c1 f8 03             	sar    $0x3,%eax
f01023d4:	c1 e0 0c             	shl    $0xc,%eax
f01023d7:	39 c2                	cmp    %eax,%edx
f01023d9:	0f 85 f2 0a 00 00    	jne    f0102ed1 <mem_init+0x18d6>
    kern_pgdir[0] = 0;
f01023df:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f01023e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01023e8:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01023ed:	0f 85 ff 0a 00 00    	jne    f0102ef2 <mem_init+0x18f7>
    pp0->pp_ref = 0;
f01023f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01023f6:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // check pointer arithmetic in pgdir_walk
    page_free(pp0);
f01023fc:	83 ec 0c             	sub    $0xc,%esp
f01023ff:	50                   	push   %eax
f0102400:	e8 55 ee ff ff       	call   f010125a <page_free>
    va = (void *) (PGSIZE * NPDENTRIES + PGSIZE);
    ptep = pgdir_walk(kern_pgdir, va, 1);
f0102405:	83 c4 0c             	add    $0xc,%esp
f0102408:	6a 01                	push   $0x1
f010240a:	68 00 10 40 00       	push   $0x401000
f010240f:	c7 c3 0c 10 19 f0    	mov    $0xf019100c,%ebx
f0102415:	ff 33                	pushl  (%ebx)
f0102417:	e8 d9 ee ff ff       	call   f01012f5 <pgdir_walk>
f010241c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010241f:	8b 13                	mov    (%ebx),%edx
f0102421:	8b 52 04             	mov    0x4(%edx),%edx
f0102424:	89 d1                	mov    %edx,%ecx
f0102426:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010242c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	if (PGNUM(pa) >= npages)
f010242f:	89 cb                	mov    %ecx,%ebx
f0102431:	c1 eb 0c             	shr    $0xc,%ebx
f0102434:	83 c4 10             	add    $0x10,%esp
f0102437:	c7 c1 08 10 19 f0    	mov    $0xf0191008,%ecx
f010243d:	3b 19                	cmp    (%ecx),%ebx
f010243f:	0f 83 ce 0a 00 00    	jae    f0102f13 <mem_init+0x1918>
	return (void *)(pa + KERNBASE);
f0102445:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0102448:	8d 8b 00 00 00 f0    	lea    -0x10000000(%ebx),%ecx

    cprintf("PTE_ADDR(kern_pgdir[PDX(va)]):0x%x\tkern_pgdir[PDX(va)]:0x%x\tptep:0x%x\tptep1:0x%x\tPTX(va):0x%x\n",
f010244e:	83 ec 08             	sub    $0x8,%esp
f0102451:	6a 01                	push   $0x1
f0102453:	51                   	push   %ecx
f0102454:	50                   	push   %eax
f0102455:	52                   	push   %edx
f0102456:	53                   	push   %ebx
f0102457:	8d 87 c4 89 f7 ff    	lea    -0x8763c(%edi),%eax
f010245d:	50                   	push   %eax
f010245e:	89 fb                	mov    %edi,%ebx
f0102460:	e8 01 1d 00 00       	call   f0104166 <cprintf>
            PTE_ADDR(kern_pgdir[PDX(va)]), kern_pgdir[PDX(va)], ptep, ptep1,
            PTX(va));
    assert(ptep == ptep1 + PTX(va));
f0102465:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0102468:	8d 83 04 00 00 f0    	lea    -0xffffffc(%ebx),%eax
f010246e:	83 c4 20             	add    $0x20,%esp
f0102471:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0102474:	0f 85 b6 0a 00 00    	jne    f0102f30 <mem_init+0x1935>
    kern_pgdir[PDX(va)] = 0;
f010247a:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0102480:	8b 00                	mov    (%eax),%eax
f0102482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    pp0->pp_ref = 0;
f0102489:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f010248c:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
	return (pp - pages) << PGSHIFT;
f0102492:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0102498:	2b 08                	sub    (%eax),%ecx
f010249a:	89 c8                	mov    %ecx,%eax
f010249c:	c1 f8 03             	sar    $0x3,%eax
f010249f:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01024a2:	89 c1                	mov    %eax,%ecx
f01024a4:	c1 e9 0c             	shr    $0xc,%ecx
f01024a7:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f01024ad:	3b 0a                	cmp    (%edx),%ecx
f01024af:	0f 83 9c 0a 00 00    	jae    f0102f51 <mem_init+0x1956>

    // check that new page tables get cleared
    memset(page2kva(pp0), 0xFF, PGSIZE);
f01024b5:	83 ec 04             	sub    $0x4,%esp
f01024b8:	68 00 10 00 00       	push   $0x1000
f01024bd:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01024c2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01024c7:	50                   	push   %eax
f01024c8:	89 fb                	mov    %edi,%ebx
f01024ca:	e8 49 31 00 00       	call   f0105618 <memset>
    page_free(pp0);
f01024cf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01024d2:	89 1c 24             	mov    %ebx,(%esp)
f01024d5:	e8 80 ed ff ff       	call   f010125a <page_free>
    pgdir_walk(kern_pgdir, 0x0, 1);
f01024da:	83 c4 0c             	add    $0xc,%esp
f01024dd:	6a 01                	push   $0x1
f01024df:	6a 00                	push   $0x0
f01024e1:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01024e7:	ff 30                	pushl  (%eax)
f01024e9:	e8 07 ee ff ff       	call   f01012f5 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01024ee:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01024f4:	2b 18                	sub    (%eax),%ebx
f01024f6:	89 da                	mov    %ebx,%edx
f01024f8:	c1 fa 03             	sar    $0x3,%edx
f01024fb:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01024fe:	89 d1                	mov    %edx,%ecx
f0102500:	c1 e9 0c             	shr    $0xc,%ecx
f0102503:	83 c4 10             	add    $0x10,%esp
f0102506:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f010250c:	3b 08                	cmp    (%eax),%ecx
f010250e:	0f 83 55 0a 00 00    	jae    f0102f69 <mem_init+0x196e>
	return (void *)(pa + KERNBASE);
f0102514:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
    ptep = (pte_t *) page2kva(pp0);
f010251a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010251d:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
    for (i = 0; i < NPTENTRIES; i++)
        assert((ptep[i] & PTE_P) == 0);
f0102523:	f6 00 01             	testb  $0x1,(%eax)
f0102526:	0f 85 55 0a 00 00    	jne    f0102f81 <mem_init+0x1986>
f010252c:	83 c0 04             	add    $0x4,%eax
    for (i = 0; i < NPTENTRIES; i++)
f010252f:	39 d0                	cmp    %edx,%eax
f0102531:	75 f0                	jne    f0102523 <mem_init+0xf28>
    kern_pgdir[0] = 0;
f0102533:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0102539:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010253c:	8b 00                	mov    (%eax),%eax
f010253e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    pp0->pp_ref = 0;
f0102544:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102547:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)

    // give free list back
    page_free_list = fl;
f010254d:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f0102550:	89 9f c4 22 00 00    	mov    %ebx,0x22c4(%edi)

    // free the pages we took
    page_free(pp0);
f0102556:	83 ec 0c             	sub    $0xc,%esp
f0102559:	51                   	push   %ecx
f010255a:	e8 fb ec ff ff       	call   f010125a <page_free>
    page_free(pp1);
f010255f:	89 34 24             	mov    %esi,(%esp)
f0102562:	e8 f3 ec ff ff       	call   f010125a <page_free>
    page_free(pp2);
f0102567:	83 c4 04             	add    $0x4,%esp
f010256a:	ff 75 d4             	pushl  -0x2c(%ebp)
f010256d:	e8 e8 ec ff ff       	call   f010125a <page_free>

    cprintf("check_page() succeeded!\n");
f0102572:	8d 87 4e 92 f7 ff    	lea    -0x86db2(%edi),%eax
f0102578:	89 04 24             	mov    %eax,(%esp)
f010257b:	89 fb                	mov    %edi,%ebx
f010257d:	e8 e4 1b 00 00       	call   f0104166 <cprintf>
    cprintf("\n************* Now we set up virtual memory **************\n");
f0102582:	8d 87 24 8a f7 ff    	lea    -0x875dc(%edi),%eax
f0102588:	89 04 24             	mov    %eax,(%esp)
f010258b:	e8 d6 1b 00 00       	call   f0104166 <cprintf>
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f0102590:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102593:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102595:	83 c4 10             	add    $0x10,%esp
f0102598:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010259d:	0f 86 ff 09 00 00    	jbe    f0102fa2 <mem_init+0x19a7>
	return (physaddr_t)kva - KERNBASE;
f01025a3:	05 00 00 00 10       	add    $0x10000000,%eax
f01025a8:	83 ec 0c             	sub    $0xc,%esp
f01025ab:	89 c2                	mov    %eax,%edx
f01025ad:	c1 ea 0c             	shr    $0xc,%edx
f01025b0:	52                   	push   %edx
f01025b1:	50                   	push   %eax
f01025b2:	68 bd 03 00 00       	push   $0x3bd
f01025b7:	68 00 00 40 ef       	push   $0xef400000
f01025bc:	8d 87 6e 90 f7 ff    	lea    -0x86f92(%edi),%eax
f01025c2:	50                   	push   %eax
f01025c3:	e8 b2 1b 00 00       	call   f010417a <memCprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f01025c8:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01025ce:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01025d0:	83 c4 20             	add    $0x20,%esp
f01025d3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01025d8:	0f 86 dd 09 00 00    	jbe    f0102fbb <mem_init+0x19c0>
	return (physaddr_t)kva - KERNBASE;
f01025de:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01025e4:	83 ec 0c             	sub    $0xc,%esp
f01025e7:	89 d1                	mov    %edx,%ecx
f01025e9:	c1 e9 0c             	shr    $0xc,%ecx
f01025ec:	51                   	push   %ecx
f01025ed:	52                   	push   %edx
f01025ee:	89 c2                	mov    %eax,%edx
f01025f0:	c1 ea 16             	shr    $0x16,%edx
f01025f3:	52                   	push   %edx
f01025f4:	50                   	push   %eax
f01025f5:	8d 87 88 8f f7 ff    	lea    -0x87078(%edi),%eax
f01025fb:	50                   	push   %eax
f01025fc:	e8 79 1b 00 00       	call   f010417a <memCprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f0102601:	c7 c0 50 03 19 f0    	mov    $0xf0190350,%eax
f0102607:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102609:	83 c4 20             	add    $0x20,%esp
f010260c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102611:	0f 86 bd 09 00 00    	jbe    f0102fd4 <mem_init+0x19d9>
	return (physaddr_t)kva - KERNBASE;
f0102617:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010261d:	83 ec 0c             	sub    $0xc,%esp
f0102620:	89 d1                	mov    %edx,%ecx
f0102622:	c1 e9 0c             	shr    $0xc,%ecx
f0102625:	51                   	push   %ecx
f0102626:	52                   	push   %edx
f0102627:	89 c2                	mov    %eax,%edx
f0102629:	c1 ea 16             	shr    $0x16,%edx
f010262c:	52                   	push   %edx
f010262d:	50                   	push   %eax
f010262e:	8d 87 bc 90 f7 ff    	lea    -0x86f44(%edi),%eax
f0102634:	50                   	push   %eax
f0102635:	e8 40 1b 00 00       	call   f010417a <memCprintf>
    cprintf("\n************* Now we map 'pages' read-only by the user at linear address UPAGES **************\n");
f010263a:	83 c4 14             	add    $0x14,%esp
f010263d:	8d 87 60 8a f7 ff    	lea    -0x875a0(%edi),%eax
f0102643:	50                   	push   %eax
f0102644:	e8 1d 1b 00 00       	call   f0104166 <cprintf>
    cprintf("page2pa(pages):0x%x\n", page2pa(pages));
f0102649:	83 c4 08             	add    $0x8,%esp
f010264c:	6a 00                	push   $0x0
f010264e:	8d 87 67 92 f7 ff    	lea    -0x86d99(%edi),%eax
f0102654:	50                   	push   %eax
f0102655:	e8 0c 1b 00 00       	call   f0104166 <cprintf>
    boot_map_region(kern_pgdir, UPAGES, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE), PADDR(pages), PTE_U | PTE_P);
f010265a:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0102660:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102662:	83 c4 10             	add    $0x10,%esp
f0102665:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010266a:	0f 86 7d 09 00 00    	jbe    f0102fed <mem_init+0x19f2>
f0102670:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0102676:	8b 12                	mov    (%edx),%edx
f0102678:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f010267f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102685:	83 ec 08             	sub    $0x8,%esp
f0102688:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f010268a:	05 00 00 00 10       	add    $0x10000000,%eax
f010268f:	50                   	push   %eax
f0102690:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102695:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f010269b:	8b 00                	mov    (%eax),%eax
f010269d:	e8 fd ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now we map 'envs' read-only by the user at linear address UENVS **************\n");
f01026a2:	8d 87 c4 8a f7 ff    	lea    -0x8753c(%edi),%eax
f01026a8:	89 04 24             	mov    %eax,(%esp)
f01026ab:	e8 b6 1a 00 00       	call   f0104166 <cprintf>
    boot_map_region(kern_pgdir, UENVS, ROUNDUP(NENV * sizeof(struct Env), PGSIZE), PADDR(envs), PTE_U | PTE_P);
f01026b0:	c7 c0 50 03 19 f0    	mov    $0xf0190350,%eax
f01026b6:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01026b8:	83 c4 10             	add    $0x10,%esp
f01026bb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01026c0:	0f 86 40 09 00 00    	jbe    f0103006 <mem_init+0x1a0b>
f01026c6:	83 ec 08             	sub    $0x8,%esp
f01026c9:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f01026cb:	05 00 00 00 10       	add    $0x10000000,%eax
f01026d0:	50                   	push   %eax
f01026d1:	b9 00 80 01 00       	mov    $0x18000,%ecx
f01026d6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01026db:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01026e1:	8b 00                	mov    (%eax),%eax
f01026e3:	e8 b7 ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now use the physical memory that 'bootstack' refers to as the kernel stack **************\n");
f01026e8:	8d 87 24 8b f7 ff    	lea    -0x874dc(%edi),%eax
f01026ee:	89 04 24             	mov    %eax,(%esp)
f01026f1:	e8 70 1a 00 00       	call   f0104166 <cprintf>
	if ((uint32_t)kva < KERNBASE)
f01026f6:	c7 c0 00 40 11 f0    	mov    $0xf0114000,%eax
f01026fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01026ff:	83 c4 10             	add    $0x10,%esp
f0102702:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102707:	0f 86 12 09 00 00    	jbe    f010301f <mem_init+0x1a24>
    boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_P | PTE_W);
f010270d:	c7 c6 0c 10 19 f0    	mov    $0xf019100c,%esi
f0102713:	83 ec 08             	sub    $0x8,%esp
f0102716:	6a 03                	push   $0x3
	return (physaddr_t)kva - KERNBASE;
f0102718:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010271b:	05 00 00 00 10       	add    $0x10000000,%eax
f0102720:	50                   	push   %eax
f0102721:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102726:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010272b:	8b 06                	mov    (%esi),%eax
f010272d:	e8 6d ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now map all of physical memory at KERNBASE. **************\n");
f0102732:	8d 87 90 8b f7 ff    	lea    -0x87470(%edi),%eax
f0102738:	89 04 24             	mov    %eax,(%esp)
f010273b:	e8 26 1a 00 00       	call   f0104166 <cprintf>
    boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE + 1, 0, PTE_W | PTE_P);//这权限有必要？？
f0102740:	83 c4 08             	add    $0x8,%esp
f0102743:	6a 03                	push   $0x3
f0102745:	6a 00                	push   $0x0
f0102747:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010274c:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102751:	8b 06                	mov    (%esi),%eax
f0102753:	e8 47 ec ff ff       	call   f010139f <boot_map_region>
    cprintf("\n************* Now check that the initial page directory has been set up correctly **************\n");
f0102758:	8d 87 dc 8b f7 ff    	lea    -0x87424(%edi),%eax
f010275e:	89 04 24             	mov    %eax,(%esp)
f0102761:	e8 00 1a 00 00       	call   f0104166 <cprintf>
    pgdir = kern_pgdir;
f0102766:	8b 36                	mov    (%esi),%esi
    n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f0102768:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f010276e:	8b 00                	mov    (%eax),%eax
f0102770:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102777:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010277c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cprintf("check_va2pa(pgdir, UPAGES + 0):0x%x\tPADDR(pages) + 0:0x%x\n", check_va2pa(pgdir, UPAGES + 0),
f010277f:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0102785:	8b 18                	mov    (%eax),%ebx
	if ((uint32_t)kva < KERNBASE)
f0102787:	83 c4 10             	add    $0x10,%esp
f010278a:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102790:	0f 86 a2 08 00 00    	jbe    f0103038 <mem_init+0x1a3d>
f0102796:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010279b:	89 f0                	mov    %esi,%eax
f010279d:	e8 25 e4 ff ff       	call   f0100bc7 <check_va2pa>
f01027a2:	83 ec 04             	sub    $0x4,%esp
	return (physaddr_t)kva - KERNBASE;
f01027a5:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f01027ab:	53                   	push   %ebx
f01027ac:	50                   	push   %eax
f01027ad:	8d 87 40 8c f7 ff    	lea    -0x873c0(%edi),%eax
f01027b3:	50                   	push   %eax
f01027b4:	89 fb                	mov    %edi,%ebx
f01027b6:	e8 ab 19 00 00       	call   f0104166 <cprintf>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01027bb:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01027c1:	8b 00                	mov    (%eax),%eax
f01027c3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if ((uint32_t)kva < KERNBASE)
f01027c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01027c9:	05 00 00 00 10       	add    $0x10000000,%eax
f01027ce:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < n; i += PGSIZE)
f01027d1:	bb 00 00 00 00       	mov    $0x0,%ebx
f01027d6:	89 75 d0             	mov    %esi,-0x30(%ebp)
f01027d9:	89 c6                	mov    %eax,%esi
f01027db:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01027de:	0f 86 ad 08 00 00    	jbe    f0103091 <mem_init+0x1a96>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01027e4:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01027ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01027ed:	e8 d5 e3 ff ff       	call   f0100bc7 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01027f2:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f01027f9:	0f 86 54 08 00 00    	jbe    f0103053 <mem_init+0x1a58>
f01027ff:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f0102802:	39 d0                	cmp    %edx,%eax
f0102804:	0f 85 66 08 00 00    	jne    f0103070 <mem_init+0x1a75>
    for (i = 0; i < n; i += PGSIZE)
f010280a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102810:	eb c9                	jmp    f01027db <mem_init+0x11e0>
    assert(nfree == 0);
f0102812:	8d 87 77 91 f7 ff    	lea    -0x86e89(%edi),%eax
f0102818:	50                   	push   %eax
f0102819:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010281f:	50                   	push   %eax
f0102820:	68 45 03 00 00       	push   $0x345
f0102825:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010282b:	50                   	push   %eax
f010282c:	89 fb                	mov    %edi,%ebx
f010282e:	e8 55 d9 ff ff       	call   f0100188 <_panic>
    assert((pp0 = page_alloc(0)));
f0102833:	8d 87 dc 90 f7 ff    	lea    -0x86f24(%edi),%eax
f0102839:	50                   	push   %eax
f010283a:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102840:	50                   	push   %eax
f0102841:	68 a2 03 00 00       	push   $0x3a2
f0102846:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010284c:	50                   	push   %eax
f010284d:	e8 36 d9 ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f0102852:	8d 87 f2 90 f7 ff    	lea    -0x86f0e(%edi),%eax
f0102858:	50                   	push   %eax
f0102859:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010285f:	50                   	push   %eax
f0102860:	68 a3 03 00 00       	push   $0x3a3
f0102865:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010286b:	50                   	push   %eax
f010286c:	e8 17 d9 ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f0102871:	8d 87 08 91 f7 ff    	lea    -0x86ef8(%edi),%eax
f0102877:	50                   	push   %eax
f0102878:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010287e:	50                   	push   %eax
f010287f:	68 a4 03 00 00       	push   $0x3a4
f0102884:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010288a:	50                   	push   %eax
f010288b:	e8 f8 d8 ff ff       	call   f0100188 <_panic>
    assert(pp1 && pp1 != pp0);
f0102890:	8d 87 1e 91 f7 ff    	lea    -0x86ee2(%edi),%eax
f0102896:	50                   	push   %eax
f0102897:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010289d:	50                   	push   %eax
f010289e:	68 a7 03 00 00       	push   $0x3a7
f01028a3:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01028a9:	50                   	push   %eax
f01028aa:	e8 d9 d8 ff ff       	call   f0100188 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01028af:	8d 87 b8 84 f7 ff    	lea    -0x87b48(%edi),%eax
f01028b5:	50                   	push   %eax
f01028b6:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01028bc:	50                   	push   %eax
f01028bd:	68 a8 03 00 00       	push   $0x3a8
f01028c2:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01028c8:	50                   	push   %eax
f01028c9:	89 fb                	mov    %edi,%ebx
f01028cb:	e8 b8 d8 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f01028d0:	8d 87 30 91 f7 ff    	lea    -0x86ed0(%edi),%eax
f01028d6:	50                   	push   %eax
f01028d7:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01028dd:	50                   	push   %eax
f01028de:	68 af 03 00 00       	push   $0x3af
f01028e3:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01028e9:	50                   	push   %eax
f01028ea:	e8 99 d8 ff ff       	call   f0100188 <_panic>
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01028ef:	8d 87 a0 85 f7 ff    	lea    -0x87a60(%edi),%eax
f01028f5:	50                   	push   %eax
f01028f6:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01028fc:	50                   	push   %eax
f01028fd:	68 b2 03 00 00       	push   $0x3b2
f0102902:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102908:	50                   	push   %eax
f0102909:	e8 7a d8 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010290e:	8d 87 d8 85 f7 ff    	lea    -0x87a28(%edi),%eax
f0102914:	50                   	push   %eax
f0102915:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010291b:	50                   	push   %eax
f010291c:	68 b5 03 00 00       	push   $0x3b5
f0102921:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102927:	50                   	push   %eax
f0102928:	e8 5b d8 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010292d:	8d 87 08 86 f7 ff    	lea    -0x879f8(%edi),%eax
f0102933:	50                   	push   %eax
f0102934:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010293a:	50                   	push   %eax
f010293b:	68 b9 03 00 00       	push   $0x3b9
f0102940:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102946:	50                   	push   %eax
f0102947:	e8 3c d8 ff ff       	call   f0100188 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010294c:	8d 87 38 86 f7 ff    	lea    -0x879c8(%edi),%eax
f0102952:	50                   	push   %eax
f0102953:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102959:	50                   	push   %eax
f010295a:	68 ba 03 00 00       	push   $0x3ba
f010295f:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102965:	50                   	push   %eax
f0102966:	89 fb                	mov    %edi,%ebx
f0102968:	e8 1b d8 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010296d:	8d 87 60 86 f7 ff    	lea    -0x879a0(%edi),%eax
f0102973:	50                   	push   %eax
f0102974:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010297a:	50                   	push   %eax
f010297b:	68 bb 03 00 00       	push   $0x3bb
f0102980:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102986:	50                   	push   %eax
f0102987:	89 fb                	mov    %edi,%ebx
f0102989:	e8 fa d7 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 1);
f010298e:	8d 87 82 91 f7 ff    	lea    -0x86e7e(%edi),%eax
f0102994:	50                   	push   %eax
f0102995:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010299b:	50                   	push   %eax
f010299c:	68 bc 03 00 00       	push   $0x3bc
f01029a1:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01029a7:	50                   	push   %eax
f01029a8:	89 fb                	mov    %edi,%ebx
f01029aa:	e8 d9 d7 ff ff       	call   f0100188 <_panic>
    assert(pp0->pp_ref == 1);
f01029af:	8d 87 93 91 f7 ff    	lea    -0x86e6d(%edi),%eax
f01029b5:	50                   	push   %eax
f01029b6:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01029bc:	50                   	push   %eax
f01029bd:	68 bd 03 00 00       	push   $0x3bd
f01029c2:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01029c8:	50                   	push   %eax
f01029c9:	89 fb                	mov    %edi,%ebx
f01029cb:	e8 b8 d7 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01029d0:	8d 87 90 86 f7 ff    	lea    -0x87970(%edi),%eax
f01029d6:	50                   	push   %eax
f01029d7:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01029dd:	50                   	push   %eax
f01029de:	68 c0 03 00 00       	push   $0x3c0
f01029e3:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01029e9:	50                   	push   %eax
f01029ea:	89 fb                	mov    %edi,%ebx
f01029ec:	e8 97 d7 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01029f1:	8d 87 cc 86 f7 ff    	lea    -0x87934(%edi),%eax
f01029f7:	50                   	push   %eax
f01029f8:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01029fe:	50                   	push   %eax
f01029ff:	68 c1 03 00 00       	push   $0x3c1
f0102a04:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102a0a:	50                   	push   %eax
f0102a0b:	89 fb                	mov    %edi,%ebx
f0102a0d:	e8 76 d7 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f0102a12:	8d 87 a4 91 f7 ff    	lea    -0x86e5c(%edi),%eax
f0102a18:	50                   	push   %eax
f0102a19:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102a1f:	50                   	push   %eax
f0102a20:	68 c2 03 00 00       	push   $0x3c2
f0102a25:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102a2b:	50                   	push   %eax
f0102a2c:	89 fb                	mov    %edi,%ebx
f0102a2e:	e8 55 d7 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0102a33:	8d 87 30 91 f7 ff    	lea    -0x86ed0(%edi),%eax
f0102a39:	50                   	push   %eax
f0102a3a:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102a40:	50                   	push   %eax
f0102a41:	68 c5 03 00 00       	push   $0x3c5
f0102a46:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102a4c:	50                   	push   %eax
f0102a4d:	89 fb                	mov    %edi,%ebx
f0102a4f:	e8 34 d7 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102a54:	8d 87 90 86 f7 ff    	lea    -0x87970(%edi),%eax
f0102a5a:	50                   	push   %eax
f0102a5b:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102a61:	50                   	push   %eax
f0102a62:	68 c8 03 00 00       	push   $0x3c8
f0102a67:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102a6d:	50                   	push   %eax
f0102a6e:	89 fb                	mov    %edi,%ebx
f0102a70:	e8 13 d7 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102a75:	8d 87 cc 86 f7 ff    	lea    -0x87934(%edi),%eax
f0102a7b:	50                   	push   %eax
f0102a7c:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102a82:	50                   	push   %eax
f0102a83:	68 c9 03 00 00       	push   $0x3c9
f0102a88:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102a8e:	50                   	push   %eax
f0102a8f:	89 fb                	mov    %edi,%ebx
f0102a91:	e8 f2 d6 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f0102a96:	8d 87 a4 91 f7 ff    	lea    -0x86e5c(%edi),%eax
f0102a9c:	50                   	push   %eax
f0102a9d:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102aa3:	50                   	push   %eax
f0102aa4:	68 ca 03 00 00       	push   $0x3ca
f0102aa9:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102aaf:	50                   	push   %eax
f0102ab0:	89 fb                	mov    %edi,%ebx
f0102ab2:	e8 d1 d6 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0102ab7:	8d 87 30 91 f7 ff    	lea    -0x86ed0(%edi),%eax
f0102abd:	50                   	push   %eax
f0102abe:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102ac4:	50                   	push   %eax
f0102ac5:	68 ce 03 00 00       	push   $0x3ce
f0102aca:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102ad0:	50                   	push   %eax
f0102ad1:	89 fb                	mov    %edi,%ebx
f0102ad3:	e8 b0 d6 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102ad8:	50                   	push   %eax
f0102ad9:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0102adf:	50                   	push   %eax
f0102ae0:	68 d1 03 00 00       	push   $0x3d1
f0102ae5:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102aeb:	50                   	push   %eax
f0102aec:	89 fb                	mov    %edi,%ebx
f0102aee:	e8 95 d6 ff ff       	call   f0100188 <_panic>
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102af3:	8d 87 fc 86 f7 ff    	lea    -0x87904(%edi),%eax
f0102af9:	50                   	push   %eax
f0102afa:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102b00:	50                   	push   %eax
f0102b01:	68 d2 03 00 00       	push   $0x3d2
f0102b06:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102b0c:	50                   	push   %eax
f0102b0d:	89 fb                	mov    %edi,%ebx
f0102b0f:	e8 74 d6 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0102b14:	8d 87 40 87 f7 ff    	lea    -0x878c0(%edi),%eax
f0102b1a:	50                   	push   %eax
f0102b1b:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102b21:	50                   	push   %eax
f0102b22:	68 d5 03 00 00       	push   $0x3d5
f0102b27:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102b2d:	50                   	push   %eax
f0102b2e:	89 fb                	mov    %edi,%ebx
f0102b30:	e8 53 d6 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102b35:	8d 87 cc 86 f7 ff    	lea    -0x87934(%edi),%eax
f0102b3b:	50                   	push   %eax
f0102b3c:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102b42:	50                   	push   %eax
f0102b43:	68 d6 03 00 00       	push   $0x3d6
f0102b48:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102b4e:	50                   	push   %eax
f0102b4f:	89 fb                	mov    %edi,%ebx
f0102b51:	e8 32 d6 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f0102b56:	8d 87 a4 91 f7 ff    	lea    -0x86e5c(%edi),%eax
f0102b5c:	50                   	push   %eax
f0102b5d:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102b63:	50                   	push   %eax
f0102b64:	68 d7 03 00 00       	push   $0x3d7
f0102b69:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102b6f:	50                   	push   %eax
f0102b70:	89 fb                	mov    %edi,%ebx
f0102b72:	e8 11 d6 ff ff       	call   f0100188 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f0102b77:	8d 87 84 87 f7 ff    	lea    -0x8787c(%edi),%eax
f0102b7d:	50                   	push   %eax
f0102b7e:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102b84:	50                   	push   %eax
f0102b85:	68 d8 03 00 00       	push   $0x3d8
f0102b8a:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102b90:	50                   	push   %eax
f0102b91:	89 fb                	mov    %edi,%ebx
f0102b93:	e8 f0 d5 ff ff       	call   f0100188 <_panic>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f0102b98:	8d 87 b5 91 f7 ff    	lea    -0x86e4b(%edi),%eax
f0102b9e:	50                   	push   %eax
f0102b9f:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102ba5:	50                   	push   %eax
f0102ba6:	68 d9 03 00 00       	push   $0x3d9
f0102bab:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102bb1:	50                   	push   %eax
f0102bb2:	89 fb                	mov    %edi,%ebx
f0102bb4:	e8 cf d5 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102bb9:	8d 87 90 86 f7 ff    	lea    -0x87970(%edi),%eax
f0102bbf:	50                   	push   %eax
f0102bc0:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102bc6:	50                   	push   %eax
f0102bc7:	68 dc 03 00 00       	push   $0x3dc
f0102bcc:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102bd2:	50                   	push   %eax
f0102bd3:	89 fb                	mov    %edi,%ebx
f0102bd5:	e8 ae d5 ff ff       	call   f0100188 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102bda:	8d 87 b8 87 f7 ff    	lea    -0x87848(%edi),%eax
f0102be0:	50                   	push   %eax
f0102be1:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102be7:	50                   	push   %eax
f0102be8:	68 dd 03 00 00       	push   $0x3dd
f0102bed:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102bf3:	50                   	push   %eax
f0102bf4:	89 fb                	mov    %edi,%ebx
f0102bf6:	e8 8d d5 ff ff       	call   f0100188 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102bfb:	8d 87 ec 87 f7 ff    	lea    -0x87814(%edi),%eax
f0102c01:	50                   	push   %eax
f0102c02:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102c08:	50                   	push   %eax
f0102c09:	68 de 03 00 00       	push   $0x3de
f0102c0e:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102c14:	50                   	push   %eax
f0102c15:	89 fb                	mov    %edi,%ebx
f0102c17:	e8 6c d5 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102c1c:	8d 87 24 88 f7 ff    	lea    -0x877dc(%edi),%eax
f0102c22:	50                   	push   %eax
f0102c23:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102c29:	50                   	push   %eax
f0102c2a:	68 e1 03 00 00       	push   $0x3e1
f0102c2f:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102c35:	50                   	push   %eax
f0102c36:	89 fb                	mov    %edi,%ebx
f0102c38:	e8 4b d5 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0102c3d:	8d 87 60 88 f7 ff    	lea    -0x877a0(%edi),%eax
f0102c43:	50                   	push   %eax
f0102c44:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102c4a:	50                   	push   %eax
f0102c4b:	68 e4 03 00 00       	push   $0x3e4
f0102c50:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102c56:	50                   	push   %eax
f0102c57:	89 fb                	mov    %edi,%ebx
f0102c59:	e8 2a d5 ff ff       	call   f0100188 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102c5e:	8d 87 ec 87 f7 ff    	lea    -0x87814(%edi),%eax
f0102c64:	50                   	push   %eax
f0102c65:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102c6b:	50                   	push   %eax
f0102c6c:	68 e5 03 00 00       	push   $0x3e5
f0102c71:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102c77:	50                   	push   %eax
f0102c78:	89 fb                	mov    %edi,%ebx
f0102c7a:	e8 09 d5 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102c7f:	8d 87 9c 88 f7 ff    	lea    -0x87764(%edi),%eax
f0102c85:	50                   	push   %eax
f0102c86:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102c8c:	50                   	push   %eax
f0102c8d:	68 e8 03 00 00       	push   $0x3e8
f0102c92:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102c98:	50                   	push   %eax
f0102c99:	89 fb                	mov    %edi,%ebx
f0102c9b:	e8 e8 d4 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102ca0:	8d 87 c8 88 f7 ff    	lea    -0x87738(%edi),%eax
f0102ca6:	50                   	push   %eax
f0102ca7:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102cad:	50                   	push   %eax
f0102cae:	68 e9 03 00 00       	push   $0x3e9
f0102cb3:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102cb9:	50                   	push   %eax
f0102cba:	89 fb                	mov    %edi,%ebx
f0102cbc:	e8 c7 d4 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 2);
f0102cc1:	8d 87 cb 91 f7 ff    	lea    -0x86e35(%edi),%eax
f0102cc7:	50                   	push   %eax
f0102cc8:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102cce:	50                   	push   %eax
f0102ccf:	68 eb 03 00 00       	push   $0x3eb
f0102cd4:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102cda:	50                   	push   %eax
f0102cdb:	89 fb                	mov    %edi,%ebx
f0102cdd:	e8 a6 d4 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f0102ce2:	8d 87 dc 91 f7 ff    	lea    -0x86e24(%edi),%eax
f0102ce8:	50                   	push   %eax
f0102ce9:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102cef:	50                   	push   %eax
f0102cf0:	68 ec 03 00 00       	push   $0x3ec
f0102cf5:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102cfb:	50                   	push   %eax
f0102cfc:	89 fb                	mov    %edi,%ebx
f0102cfe:	e8 85 d4 ff ff       	call   f0100188 <_panic>
    assert((pp = page_alloc(0)) && pp == pp2);
f0102d03:	8d 87 f8 88 f7 ff    	lea    -0x87708(%edi),%eax
f0102d09:	50                   	push   %eax
f0102d0a:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102d10:	50                   	push   %eax
f0102d11:	68 ef 03 00 00       	push   $0x3ef
f0102d16:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102d1c:	50                   	push   %eax
f0102d1d:	89 fb                	mov    %edi,%ebx
f0102d1f:	e8 64 d4 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102d24:	8d 87 1c 89 f7 ff    	lea    -0x876e4(%edi),%eax
f0102d2a:	50                   	push   %eax
f0102d2b:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102d31:	50                   	push   %eax
f0102d32:	68 f3 03 00 00       	push   $0x3f3
f0102d37:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102d3d:	50                   	push   %eax
f0102d3e:	89 fb                	mov    %edi,%ebx
f0102d40:	e8 43 d4 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102d45:	8d 87 c8 88 f7 ff    	lea    -0x87738(%edi),%eax
f0102d4b:	50                   	push   %eax
f0102d4c:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102d52:	50                   	push   %eax
f0102d53:	68 f4 03 00 00       	push   $0x3f4
f0102d58:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102d5e:	50                   	push   %eax
f0102d5f:	89 fb                	mov    %edi,%ebx
f0102d61:	e8 22 d4 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 1);
f0102d66:	8d 87 82 91 f7 ff    	lea    -0x86e7e(%edi),%eax
f0102d6c:	50                   	push   %eax
f0102d6d:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102d73:	50                   	push   %eax
f0102d74:	68 f5 03 00 00       	push   $0x3f5
f0102d79:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102d7f:	50                   	push   %eax
f0102d80:	89 fb                	mov    %edi,%ebx
f0102d82:	e8 01 d4 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f0102d87:	8d 87 dc 91 f7 ff    	lea    -0x86e24(%edi),%eax
f0102d8d:	50                   	push   %eax
f0102d8e:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102d94:	50                   	push   %eax
f0102d95:	68 f6 03 00 00       	push   $0x3f6
f0102d9a:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102da0:	50                   	push   %eax
f0102da1:	89 fb                	mov    %edi,%ebx
f0102da3:	e8 e0 d3 ff ff       	call   f0100188 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102da8:	8d 87 40 89 f7 ff    	lea    -0x876c0(%edi),%eax
f0102dae:	50                   	push   %eax
f0102daf:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102db5:	50                   	push   %eax
f0102db6:	68 f9 03 00 00       	push   $0x3f9
f0102dbb:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102dc1:	50                   	push   %eax
f0102dc2:	89 fb                	mov    %edi,%ebx
f0102dc4:	e8 bf d3 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref);
f0102dc9:	8d 87 ed 91 f7 ff    	lea    -0x86e13(%edi),%eax
f0102dcf:	50                   	push   %eax
f0102dd0:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102dd6:	50                   	push   %eax
f0102dd7:	68 fa 03 00 00       	push   $0x3fa
f0102ddc:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102de2:	50                   	push   %eax
f0102de3:	89 fb                	mov    %edi,%ebx
f0102de5:	e8 9e d3 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_link == NULL);
f0102dea:	8d 87 f9 91 f7 ff    	lea    -0x86e07(%edi),%eax
f0102df0:	50                   	push   %eax
f0102df1:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102df7:	50                   	push   %eax
f0102df8:	68 fb 03 00 00       	push   $0x3fb
f0102dfd:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102e03:	50                   	push   %eax
f0102e04:	89 fb                	mov    %edi,%ebx
f0102e06:	e8 7d d3 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102e0b:	8d 87 1c 89 f7 ff    	lea    -0x876e4(%edi),%eax
f0102e11:	50                   	push   %eax
f0102e12:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102e18:	50                   	push   %eax
f0102e19:	68 ff 03 00 00       	push   $0x3ff
f0102e1e:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102e24:	50                   	push   %eax
f0102e25:	89 fb                	mov    %edi,%ebx
f0102e27:	e8 5c d3 ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102e2c:	8d 87 78 89 f7 ff    	lea    -0x87688(%edi),%eax
f0102e32:	50                   	push   %eax
f0102e33:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102e39:	50                   	push   %eax
f0102e3a:	68 00 04 00 00       	push   $0x400
f0102e3f:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102e45:	50                   	push   %eax
f0102e46:	89 fb                	mov    %edi,%ebx
f0102e48:	e8 3b d3 ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 0);
f0102e4d:	8d 87 0e 92 f7 ff    	lea    -0x86df2(%edi),%eax
f0102e53:	50                   	push   %eax
f0102e54:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102e5a:	50                   	push   %eax
f0102e5b:	68 01 04 00 00       	push   $0x401
f0102e60:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102e66:	50                   	push   %eax
f0102e67:	89 fb                	mov    %edi,%ebx
f0102e69:	e8 1a d3 ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f0102e6e:	8d 87 dc 91 f7 ff    	lea    -0x86e24(%edi),%eax
f0102e74:	50                   	push   %eax
f0102e75:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102e7b:	50                   	push   %eax
f0102e7c:	68 02 04 00 00       	push   $0x402
f0102e81:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102e87:	50                   	push   %eax
f0102e88:	89 fb                	mov    %edi,%ebx
f0102e8a:	e8 f9 d2 ff ff       	call   f0100188 <_panic>
    assert((pp = page_alloc(0)) && pp == pp1);
f0102e8f:	8d 87 a0 89 f7 ff    	lea    -0x87660(%edi),%eax
f0102e95:	50                   	push   %eax
f0102e96:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102e9c:	50                   	push   %eax
f0102e9d:	68 05 04 00 00       	push   $0x405
f0102ea2:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102ea8:	50                   	push   %eax
f0102ea9:	89 fb                	mov    %edi,%ebx
f0102eab:	e8 d8 d2 ff ff       	call   f0100188 <_panic>
    assert(!page_alloc(0));
f0102eb0:	8d 87 30 91 f7 ff    	lea    -0x86ed0(%edi),%eax
f0102eb6:	50                   	push   %eax
f0102eb7:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102ebd:	50                   	push   %eax
f0102ebe:	68 08 04 00 00       	push   $0x408
f0102ec3:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102ec9:	50                   	push   %eax
f0102eca:	89 fb                	mov    %edi,%ebx
f0102ecc:	e8 b7 d2 ff ff       	call   f0100188 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102ed1:	8d 87 38 86 f7 ff    	lea    -0x879c8(%edi),%eax
f0102ed7:	50                   	push   %eax
f0102ed8:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102ede:	50                   	push   %eax
f0102edf:	68 0b 04 00 00       	push   $0x40b
f0102ee4:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102eea:	50                   	push   %eax
f0102eeb:	89 fb                	mov    %edi,%ebx
f0102eed:	e8 96 d2 ff ff       	call   f0100188 <_panic>
    assert(pp0->pp_ref == 1);
f0102ef2:	8d 87 93 91 f7 ff    	lea    -0x86e6d(%edi),%eax
f0102ef8:	50                   	push   %eax
f0102ef9:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102eff:	50                   	push   %eax
f0102f00:	68 0d 04 00 00       	push   $0x40d
f0102f05:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102f0b:	50                   	push   %eax
f0102f0c:	89 fb                	mov    %edi,%ebx
f0102f0e:	e8 75 d2 ff ff       	call   f0100188 <_panic>
f0102f13:	ff 75 cc             	pushl  -0x34(%ebp)
f0102f16:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0102f1c:	50                   	push   %eax
f0102f1d:	68 14 04 00 00       	push   $0x414
f0102f22:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102f28:	50                   	push   %eax
f0102f29:	89 fb                	mov    %edi,%ebx
f0102f2b:	e8 58 d2 ff ff       	call   f0100188 <_panic>
    assert(ptep == ptep1 + PTX(va));
f0102f30:	8d 87 1f 92 f7 ff    	lea    -0x86de1(%edi),%eax
f0102f36:	50                   	push   %eax
f0102f37:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102f3d:	50                   	push   %eax
f0102f3e:	68 19 04 00 00       	push   $0x419
f0102f43:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102f49:	50                   	push   %eax
f0102f4a:	89 fb                	mov    %edi,%ebx
f0102f4c:	e8 37 d2 ff ff       	call   f0100188 <_panic>
f0102f51:	50                   	push   %eax
f0102f52:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0102f58:	50                   	push   %eax
f0102f59:	6a 56                	push   $0x56
f0102f5b:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f0102f61:	50                   	push   %eax
f0102f62:	89 fb                	mov    %edi,%ebx
f0102f64:	e8 1f d2 ff ff       	call   f0100188 <_panic>
f0102f69:	52                   	push   %edx
f0102f6a:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0102f70:	50                   	push   %eax
f0102f71:	6a 56                	push   $0x56
f0102f73:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f0102f79:	50                   	push   %eax
f0102f7a:	89 fb                	mov    %edi,%ebx
f0102f7c:	e8 07 d2 ff ff       	call   f0100188 <_panic>
        assert((ptep[i] & PTE_P) == 0);
f0102f81:	8d 87 37 92 f7 ff    	lea    -0x86dc9(%edi),%eax
f0102f87:	50                   	push   %eax
f0102f88:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0102f8e:	50                   	push   %eax
f0102f8f:	68 23 04 00 00       	push   $0x423
f0102f94:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102f9a:	50                   	push   %eax
f0102f9b:	89 fb                	mov    %edi,%ebx
f0102f9d:	e8 e6 d1 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102fa2:	50                   	push   %eax
f0102fa3:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0102fa9:	50                   	push   %eax
f0102faa:	68 cf 00 00 00       	push   $0xcf
f0102faf:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102fb5:	50                   	push   %eax
f0102fb6:	e8 cd d1 ff ff       	call   f0100188 <_panic>
f0102fbb:	50                   	push   %eax
f0102fbc:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0102fc2:	50                   	push   %eax
f0102fc3:	68 d0 00 00 00       	push   $0xd0
f0102fc8:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102fce:	50                   	push   %eax
f0102fcf:	e8 b4 d1 ff ff       	call   f0100188 <_panic>
f0102fd4:	50                   	push   %eax
f0102fd5:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0102fdb:	50                   	push   %eax
f0102fdc:	68 d1 00 00 00       	push   $0xd1
f0102fe1:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0102fe7:	50                   	push   %eax
f0102fe8:	e8 9b d1 ff ff       	call   f0100188 <_panic>
f0102fed:	50                   	push   %eax
f0102fee:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0102ff4:	50                   	push   %eax
f0102ff5:	68 d5 00 00 00       	push   $0xd5
f0102ffa:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103000:	50                   	push   %eax
f0103001:	e8 82 d1 ff ff       	call   f0100188 <_panic>
f0103006:	50                   	push   %eax
f0103007:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f010300d:	50                   	push   %eax
f010300e:	68 df 00 00 00       	push   $0xdf
f0103013:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103019:	50                   	push   %eax
f010301a:	e8 69 d1 ff ff       	call   f0100188 <_panic>
f010301f:	50                   	push   %eax
f0103020:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0103026:	50                   	push   %eax
f0103027:	68 f0 00 00 00       	push   $0xf0
f010302c:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103032:	50                   	push   %eax
f0103033:	e8 50 d1 ff ff       	call   f0100188 <_panic>
f0103038:	53                   	push   %ebx
f0103039:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f010303f:	50                   	push   %eax
f0103040:	68 5c 03 00 00       	push   $0x35c
f0103045:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010304b:	50                   	push   %eax
f010304c:	89 fb                	mov    %edi,%ebx
f010304e:	e8 35 d1 ff ff       	call   f0100188 <_panic>
f0103053:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103056:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f010305c:	50                   	push   %eax
f010305d:	68 5e 03 00 00       	push   $0x35e
f0103062:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103068:	50                   	push   %eax
f0103069:	89 fb                	mov    %edi,%ebx
f010306b:	e8 18 d1 ff ff       	call   f0100188 <_panic>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0103070:	8d 87 7c 8c f7 ff    	lea    -0x87384(%edi),%eax
f0103076:	50                   	push   %eax
f0103077:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010307d:	50                   	push   %eax
f010307e:	68 5e 03 00 00       	push   $0x35e
f0103083:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103089:	50                   	push   %eax
f010308a:	89 fb                	mov    %edi,%ebx
f010308c:	e8 f7 d0 ff ff       	call   f0100188 <_panic>
f0103091:	8b 75 d0             	mov    -0x30(%ebp),%esi
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103094:	c7 c0 50 03 19 f0    	mov    $0xf0190350,%eax
f010309a:	8b 00                	mov    (%eax),%eax
f010309c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if ((uint32_t)kva < KERNBASE)
f010309f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01030a2:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f01030a7:	05 00 00 40 21       	add    $0x21400000,%eax
f01030ac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f01030af:	89 c6                	mov    %eax,%esi
f01030b1:	89 da                	mov    %ebx,%edx
f01030b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01030b6:	e8 0c db ff ff       	call   f0100bc7 <check_va2pa>
f01030bb:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f01030c2:	76 49                	jbe    f010310d <mem_init+0x1b12>
f01030c4:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01030c7:	39 d0                	cmp    %edx,%eax
f01030c9:	75 5f                	jne    f010312a <mem_init+0x1b2f>
f01030cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    for (i = 0; i < n; i += PGSIZE)
f01030d1:	81 fb 00 80 c1 ee    	cmp    $0xeec18000,%ebx
f01030d7:	75 d8                	jne    f01030b1 <mem_init+0x1ab6>
f01030d9:	8b 75 d4             	mov    -0x2c(%ebp),%esi
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01030dc:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f01030e2:	8b 00                	mov    (%eax),%eax
f01030e4:	c1 e0 0c             	shl    $0xc,%eax
f01030e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01030ea:	bb 00 00 00 00       	mov    $0x0,%ebx
f01030ef:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f01030f2:	73 78                	jae    f010316c <mem_init+0x1b71>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01030f4:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f01030fa:	89 f0                	mov    %esi,%eax
f01030fc:	e8 c6 da ff ff       	call   f0100bc7 <check_va2pa>
f0103101:	39 c3                	cmp    %eax,%ebx
f0103103:	75 46                	jne    f010314b <mem_init+0x1b50>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103105:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010310b:	eb e2                	jmp    f01030ef <mem_init+0x1af4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010310d:	ff 75 cc             	pushl  -0x34(%ebp)
f0103110:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f0103116:	50                   	push   %eax
f0103117:	68 63 03 00 00       	push   $0x363
f010311c:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103122:	50                   	push   %eax
f0103123:	89 fb                	mov    %edi,%ebx
f0103125:	e8 5e d0 ff ff       	call   f0100188 <_panic>
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f010312a:	8d 87 b0 8c f7 ff    	lea    -0x87350(%edi),%eax
f0103130:	50                   	push   %eax
f0103131:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103137:	50                   	push   %eax
f0103138:	68 63 03 00 00       	push   $0x363
f010313d:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103143:	50                   	push   %eax
f0103144:	89 fb                	mov    %edi,%ebx
f0103146:	e8 3d d0 ff ff       	call   f0100188 <_panic>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010314b:	8d 87 e4 8c f7 ff    	lea    -0x8731c(%edi),%eax
f0103151:	50                   	push   %eax
f0103152:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103158:	50                   	push   %eax
f0103159:	68 67 03 00 00       	push   $0x367
f010315e:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103164:	50                   	push   %eax
f0103165:	89 fb                	mov    %edi,%ebx
f0103167:	e8 1c d0 ff ff       	call   f0100188 <_panic>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010316c:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
        assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0103171:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0103174:	05 00 80 00 20       	add    $0x20008000,%eax
f0103179:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010317c:	89 da                	mov    %ebx,%edx
f010317e:	89 f0                	mov    %esi,%eax
f0103180:	e8 42 da ff ff       	call   f0100bc7 <check_va2pa>
f0103185:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103188:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f010318b:	39 c2                	cmp    %eax,%edx
f010318d:	75 26                	jne    f01031b5 <mem_init+0x1bba>
f010318f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103195:	81 fb 00 00 00 f0    	cmp    $0xf0000000,%ebx
f010319b:	75 df                	jne    f010317c <mem_init+0x1b81>
    assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f010319d:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f01031a2:	89 f0                	mov    %esi,%eax
f01031a4:	e8 1e da ff ff       	call   f0100bc7 <check_va2pa>
f01031a9:	83 f8 ff             	cmp    $0xffffffff,%eax
f01031ac:	75 28                	jne    f01031d6 <mem_init+0x1bdb>
    for (i = 0; i < NPDENTRIES; i++) {
f01031ae:	b8 00 00 00 00       	mov    $0x0,%eax
f01031b3:	eb 6b                	jmp    f0103220 <mem_init+0x1c25>
        assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01031b5:	8d 87 0c 8d f7 ff    	lea    -0x872f4(%edi),%eax
f01031bb:	50                   	push   %eax
f01031bc:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01031c2:	50                   	push   %eax
f01031c3:	68 6b 03 00 00       	push   $0x36b
f01031c8:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01031ce:	50                   	push   %eax
f01031cf:	89 fb                	mov    %edi,%ebx
f01031d1:	e8 b2 cf ff ff       	call   f0100188 <_panic>
    assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f01031d6:	8d 87 54 8d f7 ff    	lea    -0x872ac(%edi),%eax
f01031dc:	50                   	push   %eax
f01031dd:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01031e3:	50                   	push   %eax
f01031e4:	68 6c 03 00 00       	push   $0x36c
f01031e9:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01031ef:	50                   	push   %eax
f01031f0:	89 fb                	mov    %edi,%ebx
f01031f2:	e8 91 cf ff ff       	call   f0100188 <_panic>
                assert(pgdir[i] & PTE_P);
f01031f7:	f6 04 86 01          	testb  $0x1,(%esi,%eax,4)
f01031fb:	74 51                	je     f010324e <mem_init+0x1c53>
    for (i = 0; i < NPDENTRIES; i++) {
f01031fd:	83 c0 01             	add    $0x1,%eax
f0103200:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0103205:	0f 87 b3 00 00 00    	ja     f01032be <mem_init+0x1cc3>
        switch (i) {
f010320b:	3d bb 03 00 00       	cmp    $0x3bb,%eax
f0103210:	72 0e                	jb     f0103220 <mem_init+0x1c25>
f0103212:	3d bd 03 00 00       	cmp    $0x3bd,%eax
f0103217:	76 de                	jbe    f01031f7 <mem_init+0x1bfc>
f0103219:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f010321e:	74 d7                	je     f01031f7 <mem_init+0x1bfc>
                if (i >= PDX(KERNBASE)) {
f0103220:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0103225:	77 48                	ja     f010326f <mem_init+0x1c74>
                    assert(pgdir[i] == 0);
f0103227:	83 3c 86 00          	cmpl   $0x0,(%esi,%eax,4)
f010322b:	74 d0                	je     f01031fd <mem_init+0x1c02>
f010322d:	8d 87 9e 92 f7 ff    	lea    -0x86d62(%edi),%eax
f0103233:	50                   	push   %eax
f0103234:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010323a:	50                   	push   %eax
f010323b:	68 7c 03 00 00       	push   $0x37c
f0103240:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103246:	50                   	push   %eax
f0103247:	89 fb                	mov    %edi,%ebx
f0103249:	e8 3a cf ff ff       	call   f0100188 <_panic>
                assert(pgdir[i] & PTE_P);
f010324e:	8d 87 7c 92 f7 ff    	lea    -0x86d84(%edi),%eax
f0103254:	50                   	push   %eax
f0103255:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010325b:	50                   	push   %eax
f010325c:	68 75 03 00 00       	push   $0x375
f0103261:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103267:	50                   	push   %eax
f0103268:	89 fb                	mov    %edi,%ebx
f010326a:	e8 19 cf ff ff       	call   f0100188 <_panic>
                    assert(pgdir[i] & PTE_P);
f010326f:	8b 14 86             	mov    (%esi,%eax,4),%edx
f0103272:	f6 c2 01             	test   $0x1,%dl
f0103275:	74 26                	je     f010329d <mem_init+0x1ca2>
                    assert(pgdir[i] & PTE_W);
f0103277:	f6 c2 02             	test   $0x2,%dl
f010327a:	75 81                	jne    f01031fd <mem_init+0x1c02>
f010327c:	8d 87 8d 92 f7 ff    	lea    -0x86d73(%edi),%eax
f0103282:	50                   	push   %eax
f0103283:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103289:	50                   	push   %eax
f010328a:	68 7a 03 00 00       	push   $0x37a
f010328f:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103295:	50                   	push   %eax
f0103296:	89 fb                	mov    %edi,%ebx
f0103298:	e8 eb ce ff ff       	call   f0100188 <_panic>
                    assert(pgdir[i] & PTE_P);
f010329d:	8d 87 7c 92 f7 ff    	lea    -0x86d84(%edi),%eax
f01032a3:	50                   	push   %eax
f01032a4:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01032aa:	50                   	push   %eax
f01032ab:	68 79 03 00 00       	push   $0x379
f01032b0:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01032b6:	50                   	push   %eax
f01032b7:	89 fb                	mov    %edi,%ebx
f01032b9:	e8 ca ce ff ff       	call   f0100188 <_panic>
    cprintf("check_kern_pgdir() succeeded!\n");
f01032be:	83 ec 0c             	sub    $0xc,%esp
f01032c1:	8d 87 84 8d f7 ff    	lea    -0x8727c(%edi),%eax
f01032c7:	50                   	push   %eax
f01032c8:	89 fb                	mov    %edi,%ebx
f01032ca:	e8 97 0e 00 00       	call   f0104166 <cprintf>
    lcr3(PADDR(kern_pgdir));
f01032cf:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01032d5:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01032d7:	83 c4 10             	add    $0x10,%esp
f01032da:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01032df:	0f 86 52 02 00 00    	jbe    f0103537 <mem_init+0x1f3c>
	return (physaddr_t)kva - KERNBASE;
f01032e5:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01032ea:	0f 22 d8             	mov    %eax,%cr3
    cprintf("\n************* Now check that the pages on the page_free_list are reasonable. **************\n");
f01032ed:	83 ec 0c             	sub    $0xc,%esp
f01032f0:	8d 87 a4 8d f7 ff    	lea    -0x8725c(%edi),%eax
f01032f6:	50                   	push   %eax
f01032f7:	e8 6a 0e 00 00       	call   f0104166 <cprintf>
    check_page_free_list(0);
f01032fc:	b8 00 00 00 00       	mov    $0x0,%eax
f0103301:	e8 3e d9 ff ff       	call   f0100c44 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0103306:	0f 20 c0             	mov    %cr0,%eax
    cr0 &= ~(CR0_TS | CR0_EM);
f0103309:	83 e0 f3             	and    $0xfffffff3,%eax
f010330c:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0103311:	0f 22 c0             	mov    %eax,%cr0
    cprintf("\n************* Now check page_insert, page_remove, &c, with an installed kern_pgdir **************\n");
f0103314:	8d 87 04 8e f7 ff    	lea    -0x871fc(%edi),%eax
f010331a:	89 04 24             	mov    %eax,(%esp)
f010331d:	e8 44 0e 00 00       	call   f0104166 <cprintf>
    uintptr_t va;
    int i;

    // check that we can read and write installed pages
    pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0103322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103329:	e8 9e de ff ff       	call   f01011cc <page_alloc>
f010332e:	89 c6                	mov    %eax,%esi
f0103330:	83 c4 10             	add    $0x10,%esp
f0103333:	85 c0                	test   %eax,%eax
f0103335:	0f 84 15 02 00 00    	je     f0103550 <mem_init+0x1f55>
    assert((pp1 = page_alloc(0)));
f010333b:	83 ec 0c             	sub    $0xc,%esp
f010333e:	6a 00                	push   $0x0
f0103340:	e8 87 de ff ff       	call   f01011cc <page_alloc>
f0103345:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103348:	83 c4 10             	add    $0x10,%esp
f010334b:	85 c0                	test   %eax,%eax
f010334d:	0f 84 1c 02 00 00    	je     f010356f <mem_init+0x1f74>
    assert((pp2 = page_alloc(0)));
f0103353:	83 ec 0c             	sub    $0xc,%esp
f0103356:	6a 00                	push   $0x0
f0103358:	e8 6f de ff ff       	call   f01011cc <page_alloc>
f010335d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103360:	83 c4 10             	add    $0x10,%esp
f0103363:	85 c0                	test   %eax,%eax
f0103365:	0f 84 23 02 00 00    	je     f010358e <mem_init+0x1f93>
    page_free(pp0);
f010336b:	83 ec 0c             	sub    $0xc,%esp
f010336e:	56                   	push   %esi
f010336f:	e8 e6 de ff ff       	call   f010125a <page_free>
	return (pp - pages) << PGSHIFT;
f0103374:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f010337a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f010337d:	2b 08                	sub    (%eax),%ecx
f010337f:	89 c8                	mov    %ecx,%eax
f0103381:	c1 f8 03             	sar    $0x3,%eax
f0103384:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103387:	89 c1                	mov    %eax,%ecx
f0103389:	c1 e9 0c             	shr    $0xc,%ecx
f010338c:	83 c4 10             	add    $0x10,%esp
f010338f:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0103395:	3b 0a                	cmp    (%edx),%ecx
f0103397:	0f 83 10 02 00 00    	jae    f01035ad <mem_init+0x1fb2>
    memset(page2kva(pp1), 1, PGSIZE);
f010339d:	83 ec 04             	sub    $0x4,%esp
f01033a0:	68 00 10 00 00       	push   $0x1000
f01033a5:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01033a7:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01033ac:	50                   	push   %eax
f01033ad:	e8 66 22 00 00       	call   f0105618 <memset>
	return (pp - pages) << PGSHIFT;
f01033b2:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01033b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01033bb:	2b 08                	sub    (%eax),%ecx
f01033bd:	89 c8                	mov    %ecx,%eax
f01033bf:	c1 f8 03             	sar    $0x3,%eax
f01033c2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01033c5:	89 c1                	mov    %eax,%ecx
f01033c7:	c1 e9 0c             	shr    $0xc,%ecx
f01033ca:	83 c4 10             	add    $0x10,%esp
f01033cd:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f01033d3:	3b 0a                	cmp    (%edx),%ecx
f01033d5:	0f 83 e8 01 00 00    	jae    f01035c3 <mem_init+0x1fc8>
    memset(page2kva(pp2), 2, PGSIZE);
f01033db:	83 ec 04             	sub    $0x4,%esp
f01033de:	68 00 10 00 00       	push   $0x1000
f01033e3:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f01033e5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01033ea:	50                   	push   %eax
f01033eb:	e8 28 22 00 00       	call   f0105618 <memset>
    page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f01033f0:	6a 02                	push   $0x2
f01033f2:	68 00 10 00 00       	push   $0x1000
f01033f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f01033fa:	53                   	push   %ebx
f01033fb:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0103401:	ff 30                	pushl  (%eax)
f0103403:	e8 9e e0 ff ff       	call   f01014a6 <page_insert>
    assert(pp1->pp_ref == 1);
f0103408:	83 c4 20             	add    $0x20,%esp
f010340b:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103410:	0f 85 c3 01 00 00    	jne    f01035d9 <mem_init+0x1fde>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0103416:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f010341d:	01 01 01 
f0103420:	0f 85 d4 01 00 00    	jne    f01035fa <mem_init+0x1fff>
    page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0103426:	6a 02                	push   $0x2
f0103428:	68 00 10 00 00       	push   $0x1000
f010342d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0103430:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0103436:	ff 30                	pushl  (%eax)
f0103438:	e8 69 e0 ff ff       	call   f01014a6 <page_insert>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f010343d:	83 c4 10             	add    $0x10,%esp
f0103440:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103447:	02 02 02 
f010344a:	0f 85 cb 01 00 00    	jne    f010361b <mem_init+0x2020>
    assert(pp2->pp_ref == 1);
f0103450:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103453:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0103458:	0f 85 de 01 00 00    	jne    f010363c <mem_init+0x2041>
    assert(pp1->pp_ref == 0);
f010345e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103461:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0103466:	0f 85 f1 01 00 00    	jne    f010365d <mem_init+0x2062>
    *(uint32_t *) PGSIZE = 0x03030303U;
f010346c:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103473:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0103476:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f010347c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010347f:	2b 08                	sub    (%eax),%ecx
f0103481:	89 c8                	mov    %ecx,%eax
f0103483:	c1 f8 03             	sar    $0x3,%eax
f0103486:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103489:	89 c1                	mov    %eax,%ecx
f010348b:	c1 e9 0c             	shr    $0xc,%ecx
f010348e:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0103494:	3b 0a                	cmp    (%edx),%ecx
f0103496:	0f 83 e2 01 00 00    	jae    f010367e <mem_init+0x2083>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f010349c:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01034a3:	03 03 03 
f01034a6:	0f 85 ea 01 00 00    	jne    f0103696 <mem_init+0x209b>
    page_remove(kern_pgdir, (void *) PGSIZE);
f01034ac:	83 ec 08             	sub    $0x8,%esp
f01034af:	68 00 10 00 00       	push   $0x1000
f01034b4:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01034ba:	ff 30                	pushl  (%eax)
f01034bc:	e8 94 df ff ff       	call   f0101455 <page_remove>
    assert(pp2->pp_ref == 0);
f01034c1:	83 c4 10             	add    $0x10,%esp
f01034c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01034c7:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01034cc:	0f 85 e5 01 00 00    	jne    f01036b7 <mem_init+0x20bc>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01034d2:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f01034d8:	8b 08                	mov    (%eax),%ecx
f01034da:	8b 11                	mov    (%ecx),%edx
f01034dc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01034e2:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f01034e8:	89 f3                	mov    %esi,%ebx
f01034ea:	2b 18                	sub    (%eax),%ebx
f01034ec:	89 d8                	mov    %ebx,%eax
f01034ee:	c1 f8 03             	sar    $0x3,%eax
f01034f1:	c1 e0 0c             	shl    $0xc,%eax
f01034f4:	39 c2                	cmp    %eax,%edx
f01034f6:	0f 85 dc 01 00 00    	jne    f01036d8 <mem_init+0x20dd>
    kern_pgdir[0] = 0;
f01034fc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f0103502:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103507:	0f 85 ec 01 00 00    	jne    f01036f9 <mem_init+0x20fe>
    pp0->pp_ref = 0;
f010350d:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

    // free the pages we took
    page_free(pp0);
f0103513:	83 ec 0c             	sub    $0xc,%esp
f0103516:	56                   	push   %esi
f0103517:	e8 3e dd ff ff       	call   f010125a <page_free>

    cprintf("check_page_installed_pgdir() succeeded!\n");
f010351c:	8d 87 dc 8e f7 ff    	lea    -0x87124(%edi),%eax
f0103522:	89 04 24             	mov    %eax,(%esp)
f0103525:	89 fb                	mov    %edi,%ebx
f0103527:	e8 3a 0c 00 00       	call   f0104166 <cprintf>
}
f010352c:	83 c4 10             	add    $0x10,%esp
f010352f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103532:	5b                   	pop    %ebx
f0103533:	5e                   	pop    %esi
f0103534:	5f                   	pop    %edi
f0103535:	5d                   	pop    %ebp
f0103536:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103537:	50                   	push   %eax
f0103538:	8d 87 04 83 f7 ff    	lea    -0x87cfc(%edi),%eax
f010353e:	50                   	push   %eax
f010353f:	68 07 01 00 00       	push   $0x107
f0103544:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f010354a:	50                   	push   %eax
f010354b:	e8 38 cc ff ff       	call   f0100188 <_panic>
    assert((pp0 = page_alloc(0)));
f0103550:	8d 87 dc 90 f7 ff    	lea    -0x86f24(%edi),%eax
f0103556:	50                   	push   %eax
f0103557:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010355d:	50                   	push   %eax
f010355e:	68 3d 04 00 00       	push   $0x43d
f0103563:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103569:	50                   	push   %eax
f010356a:	e8 19 cc ff ff       	call   f0100188 <_panic>
    assert((pp1 = page_alloc(0)));
f010356f:	8d 87 f2 90 f7 ff    	lea    -0x86f0e(%edi),%eax
f0103575:	50                   	push   %eax
f0103576:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010357c:	50                   	push   %eax
f010357d:	68 3e 04 00 00       	push   $0x43e
f0103582:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103588:	50                   	push   %eax
f0103589:	e8 fa cb ff ff       	call   f0100188 <_panic>
    assert((pp2 = page_alloc(0)));
f010358e:	8d 87 08 91 f7 ff    	lea    -0x86ef8(%edi),%eax
f0103594:	50                   	push   %eax
f0103595:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010359b:	50                   	push   %eax
f010359c:	68 3f 04 00 00       	push   $0x43f
f01035a1:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01035a7:	50                   	push   %eax
f01035a8:	e8 db cb ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035ad:	50                   	push   %eax
f01035ae:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f01035b4:	50                   	push   %eax
f01035b5:	6a 56                	push   $0x56
f01035b7:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f01035bd:	50                   	push   %eax
f01035be:	e8 c5 cb ff ff       	call   f0100188 <_panic>
f01035c3:	50                   	push   %eax
f01035c4:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f01035ca:	50                   	push   %eax
f01035cb:	6a 56                	push   $0x56
f01035cd:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f01035d3:	50                   	push   %eax
f01035d4:	e8 af cb ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 1);
f01035d9:	8d 87 82 91 f7 ff    	lea    -0x86e7e(%edi),%eax
f01035df:	50                   	push   %eax
f01035e0:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01035e6:	50                   	push   %eax
f01035e7:	68 44 04 00 00       	push   $0x444
f01035ec:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01035f2:	50                   	push   %eax
f01035f3:	89 fb                	mov    %edi,%ebx
f01035f5:	e8 8e cb ff ff       	call   f0100188 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f01035fa:	8d 87 68 8e f7 ff    	lea    -0x87198(%edi),%eax
f0103600:	50                   	push   %eax
f0103601:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103607:	50                   	push   %eax
f0103608:	68 45 04 00 00       	push   $0x445
f010360d:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103613:	50                   	push   %eax
f0103614:	89 fb                	mov    %edi,%ebx
f0103616:	e8 6d cb ff ff       	call   f0100188 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f010361b:	8d 87 8c 8e f7 ff    	lea    -0x87174(%edi),%eax
f0103621:	50                   	push   %eax
f0103622:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103628:	50                   	push   %eax
f0103629:	68 47 04 00 00       	push   $0x447
f010362e:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103634:	50                   	push   %eax
f0103635:	89 fb                	mov    %edi,%ebx
f0103637:	e8 4c cb ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 1);
f010363c:	8d 87 a4 91 f7 ff    	lea    -0x86e5c(%edi),%eax
f0103642:	50                   	push   %eax
f0103643:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103649:	50                   	push   %eax
f010364a:	68 48 04 00 00       	push   $0x448
f010364f:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103655:	50                   	push   %eax
f0103656:	89 fb                	mov    %edi,%ebx
f0103658:	e8 2b cb ff ff       	call   f0100188 <_panic>
    assert(pp1->pp_ref == 0);
f010365d:	8d 87 0e 92 f7 ff    	lea    -0x86df2(%edi),%eax
f0103663:	50                   	push   %eax
f0103664:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f010366a:	50                   	push   %eax
f010366b:	68 49 04 00 00       	push   $0x449
f0103670:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103676:	50                   	push   %eax
f0103677:	89 fb                	mov    %edi,%ebx
f0103679:	e8 0a cb ff ff       	call   f0100188 <_panic>
f010367e:	50                   	push   %eax
f010367f:	8d 87 60 81 f7 ff    	lea    -0x87ea0(%edi),%eax
f0103685:	50                   	push   %eax
f0103686:	6a 56                	push   $0x56
f0103688:	8d 87 5e 8f f7 ff    	lea    -0x870a2(%edi),%eax
f010368e:	50                   	push   %eax
f010368f:	89 fb                	mov    %edi,%ebx
f0103691:	e8 f2 ca ff ff       	call   f0100188 <_panic>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0103696:	8d 87 b0 8e f7 ff    	lea    -0x87150(%edi),%eax
f010369c:	50                   	push   %eax
f010369d:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01036a3:	50                   	push   %eax
f01036a4:	68 4b 04 00 00       	push   $0x44b
f01036a9:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01036af:	50                   	push   %eax
f01036b0:	89 fb                	mov    %edi,%ebx
f01036b2:	e8 d1 ca ff ff       	call   f0100188 <_panic>
    assert(pp2->pp_ref == 0);
f01036b7:	8d 87 dc 91 f7 ff    	lea    -0x86e24(%edi),%eax
f01036bd:	50                   	push   %eax
f01036be:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01036c4:	50                   	push   %eax
f01036c5:	68 4d 04 00 00       	push   $0x44d
f01036ca:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01036d0:	50                   	push   %eax
f01036d1:	89 fb                	mov    %edi,%ebx
f01036d3:	e8 b0 ca ff ff       	call   f0100188 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01036d8:	8d 87 38 86 f7 ff    	lea    -0x879c8(%edi),%eax
f01036de:	50                   	push   %eax
f01036df:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f01036e5:	50                   	push   %eax
f01036e6:	68 50 04 00 00       	push   $0x450
f01036eb:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f01036f1:	50                   	push   %eax
f01036f2:	89 fb                	mov    %edi,%ebx
f01036f4:	e8 8f ca ff ff       	call   f0100188 <_panic>
    assert(pp0->pp_ref == 1);
f01036f9:	8d 87 93 91 f7 ff    	lea    -0x86e6d(%edi),%eax
f01036ff:	50                   	push   %eax
f0103700:	8d 87 3d 8f f7 ff    	lea    -0x870c3(%edi),%eax
f0103706:	50                   	push   %eax
f0103707:	68 52 04 00 00       	push   $0x452
f010370c:	8d 87 52 8f f7 ff    	lea    -0x870ae(%edi),%eax
f0103712:	50                   	push   %eax
f0103713:	89 fb                	mov    %edi,%ebx
f0103715:	e8 6e ca ff ff       	call   f0100188 <_panic>

f010371a <tlb_invalidate>:
tlb_invalidate(pde_t *pgdir, void *va) {
f010371a:	55                   	push   %ebp
f010371b:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010371d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103720:	0f 01 38             	invlpg (%eax)
}
f0103723:	5d                   	pop    %ebp
f0103724:	c3                   	ret    

f0103725 <user_mem_check>:
user_mem_check(struct Env *env, const void *va, size_t len, int perm) {
f0103725:	55                   	push   %ebp
f0103726:	89 e5                	mov    %esp,%ebp
f0103728:	57                   	push   %edi
f0103729:	56                   	push   %esi
f010372a:	53                   	push   %ebx
f010372b:	83 ec 1c             	sub    $0x1c,%esp
f010372e:	e8 ad d0 ff ff       	call   f01007e0 <__x86.get_pc_thunk.ax>
f0103733:	05 4d a9 08 00       	add    $0x8a94d,%eax
f0103738:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010373b:	8b 75 14             	mov    0x14(%ebp),%esi
    if ((perm & PTE_U) == 0) {
f010373e:	f7 c6 04 00 00 00    	test   $0x4,%esi
f0103744:	74 56                	je     f010379c <user_mem_check+0x77>
    uintptr_t begin = ROUNDDOWN((uint32_t) va, PGSIZE), end = ROUNDUP((uint32_t) va + len, PGSIZE);
f0103746:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103749:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f010374f:	8b 45 10             	mov    0x10(%ebp),%eax
f0103752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103755:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f010375c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (end > ULIM) {
f0103762:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f0103768:	77 42                	ja     f01037ac <user_mem_check+0x87>
        if ((pte == NULL) || ((*pte & (perm | PTE_P)) != (perm | PTE_P))) {
f010376a:	83 ce 01             	or     $0x1,%esi
    for (int i = begin; i < end; i += PGSIZE) {
f010376d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0103770:	39 fb                	cmp    %edi,%ebx
f0103772:	73 68                	jae    f01037dc <user_mem_check+0xb7>
        pte_t *pte = pgdir_walk(env->env_pgdir, (const void *) i, 0);
f0103774:	83 ec 04             	sub    $0x4,%esp
f0103777:	6a 00                	push   $0x0
f0103779:	53                   	push   %ebx
f010377a:	8b 45 08             	mov    0x8(%ebp),%eax
f010377d:	ff 70 5c             	pushl  0x5c(%eax)
f0103780:	e8 70 db ff ff       	call   f01012f5 <pgdir_walk>
        if ((pte == NULL) || ((*pte & (perm | PTE_P)) != (perm | PTE_P))) {
f0103785:	83 c4 10             	add    $0x10,%esp
f0103788:	85 c0                	test   %eax,%eax
f010378a:	74 30                	je     f01037bc <user_mem_check+0x97>
f010378c:	89 f2                	mov    %esi,%edx
f010378e:	23 10                	and    (%eax),%edx
f0103790:	39 d6                	cmp    %edx,%esi
f0103792:	75 28                	jne    f01037bc <user_mem_check+0x97>
    for (int i = begin; i < end; i += PGSIZE) {
f0103794:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010379a:	eb d1                	jmp    f010376d <user_mem_check+0x48>
        user_mem_check_addr = (uintptr_t) va;
f010379c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010379f:	89 88 bc 22 00 00    	mov    %ecx,0x22bc(%eax)
        return -E_FAULT;
f01037a5:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01037aa:	eb 28                	jmp    f01037d4 <user_mem_check+0xaf>
        user_mem_check_addr =(uintptr_t) va;
f01037ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01037af:	89 88 bc 22 00 00    	mov    %ecx,0x22bc(%eax)
        return -E_FAULT;
f01037b5:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01037ba:	eb 18                	jmp    f01037d4 <user_mem_check+0xaf>
            user_mem_check_addr = i < (uint32_t)va? (uint32_t)va:i;
f01037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01037bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
f01037c2:	0f 42 45 0c          	cmovb  0xc(%ebp),%eax
f01037c6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01037c9:	89 81 bc 22 00 00    	mov    %eax,0x22bc(%ecx)
            return -E_FAULT;
f01037cf:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01037d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01037d7:	5b                   	pop    %ebx
f01037d8:	5e                   	pop    %esi
f01037d9:	5f                   	pop    %edi
f01037da:	5d                   	pop    %ebp
f01037db:	c3                   	ret    
    return 0;
f01037dc:	b8 00 00 00 00       	mov    $0x0,%eax
f01037e1:	eb f1                	jmp    f01037d4 <user_mem_check+0xaf>

f01037e3 <user_mem_assert>:
user_mem_assert(struct Env *env, const void *va, size_t len, int perm) {
f01037e3:	55                   	push   %ebp
f01037e4:	89 e5                	mov    %esp,%ebp
f01037e6:	56                   	push   %esi
f01037e7:	53                   	push   %ebx
f01037e8:	e8 51 ca ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01037ed:	81 c3 93 a8 08 00    	add    $0x8a893,%ebx
f01037f3:	8b 75 08             	mov    0x8(%ebp),%esi
    if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01037f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01037f9:	83 c8 04             	or     $0x4,%eax
f01037fc:	50                   	push   %eax
f01037fd:	ff 75 10             	pushl  0x10(%ebp)
f0103800:	ff 75 0c             	pushl  0xc(%ebp)
f0103803:	56                   	push   %esi
f0103804:	e8 1c ff ff ff       	call   f0103725 <user_mem_check>
f0103809:	83 c4 10             	add    $0x10,%esp
f010380c:	85 c0                	test   %eax,%eax
f010380e:	78 07                	js     f0103817 <user_mem_assert+0x34>
}
f0103810:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103813:	5b                   	pop    %ebx
f0103814:	5e                   	pop    %esi
f0103815:	5d                   	pop    %ebp
f0103816:	c3                   	ret    
        cprintf("[%08x] user_mem_check assertion failure for "
f0103817:	83 ec 04             	sub    $0x4,%esp
f010381a:	ff b3 bc 22 00 00    	pushl  0x22bc(%ebx)
f0103820:	ff 76 48             	pushl  0x48(%esi)
f0103823:	8d 83 08 8f f7 ff    	lea    -0x870f8(%ebx),%eax
f0103829:	50                   	push   %eax
f010382a:	e8 37 09 00 00       	call   f0104166 <cprintf>
        env_destroy(env);    // may not return
f010382f:	89 34 24             	mov    %esi,(%esp)
f0103832:	e8 a0 07 00 00       	call   f0103fd7 <env_destroy>
f0103837:	83 c4 10             	add    $0x10,%esp
}
f010383a:	eb d4                	jmp    f0103810 <user_mem_assert+0x2d>

f010383c <__x86.get_pc_thunk.dx>:
f010383c:	8b 14 24             	mov    (%esp),%edx
f010383f:	c3                   	ret    

f0103840 <__x86.get_pc_thunk.cx>:
f0103840:	8b 0c 24             	mov    (%esp),%ecx
f0103843:	c3                   	ret    

f0103844 <__x86.get_pc_thunk.di>:
f0103844:	8b 3c 24             	mov    (%esp),%edi
f0103847:	c3                   	ret    

f0103848 <region_alloc>:
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len) {
f0103848:	55                   	push   %ebp
f0103849:	89 e5                	mov    %esp,%ebp
f010384b:	57                   	push   %edi
f010384c:	56                   	push   %esi
f010384d:	53                   	push   %ebx
f010384e:	83 ec 1c             	sub    $0x1c,%esp
f0103851:	e8 e8 c9 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103856:	81 c3 2a a8 08 00    	add    $0x8a82a,%ebx
    //
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
    pde_t *pgdir = e->env_pgdir;
f010385c:	8b 40 5c             	mov    0x5c(%eax),%eax
f010385f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    uintptr_t begin = ROUNDDOWN((uintptr_t) va, PGSIZE), end = ROUNDUP((uintptr_t) va + len, PGSIZE);
f0103862:	89 d6                	mov    %edx,%esi
f0103864:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f010386a:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103871:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103876:	89 c7                	mov    %eax,%edi
    for (; begin < end; begin += PGSIZE) {
//        if (!page_lookup(pgdir, (void *) begin, NULL)) {
            cprintf("begin:0x%x\tend:0x%x\n", begin, end);
f0103878:	8d 83 ac 92 f7 ff    	lea    -0x86d54(%ebx),%eax
f010387e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (; begin < end; begin += PGSIZE) {
f0103881:	eb 2e                	jmp    f01038b1 <region_alloc+0x69>
            cprintf("begin:0x%x\tend:0x%x\n", begin, end);
f0103883:	83 ec 04             	sub    $0x4,%esp
f0103886:	57                   	push   %edi
f0103887:	56                   	push   %esi
f0103888:	ff 75 e0             	pushl  -0x20(%ebp)
f010388b:	e8 d6 08 00 00       	call   f0104166 <cprintf>
            //alloc_flag ??? why false??? sb fz
//            page_insert(pgdir, page_alloc(false), (void *) begin, PTE_U | PTE_W);
            page_insert(pgdir, page_alloc(ALLOC_ZERO), (void *) begin, PTE_U | PTE_W);
f0103890:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103897:	e8 30 d9 ff ff       	call   f01011cc <page_alloc>
f010389c:	6a 06                	push   $0x6
f010389e:	56                   	push   %esi
f010389f:	50                   	push   %eax
f01038a0:	ff 75 e4             	pushl  -0x1c(%ebp)
f01038a3:	e8 fe db ff ff       	call   f01014a6 <page_insert>
    for (; begin < end; begin += PGSIZE) {
f01038a8:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01038ae:	83 c4 20             	add    $0x20,%esp
f01038b1:	39 fe                	cmp    %edi,%esi
f01038b3:	72 ce                	jb     f0103883 <region_alloc+0x3b>
//        }
    }
}
f01038b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038b8:	5b                   	pop    %ebx
f01038b9:	5e                   	pop    %esi
f01038ba:	5f                   	pop    %edi
f01038bb:	5d                   	pop    %ebp
f01038bc:	c3                   	ret    

f01038bd <envid2env>:
envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
f01038bd:	55                   	push   %ebp
f01038be:	89 e5                	mov    %esp,%ebp
f01038c0:	53                   	push   %ebx
f01038c1:	e8 7a ff ff ff       	call   f0103840 <__x86.get_pc_thunk.cx>
f01038c6:	81 c1 ba a7 08 00    	add    $0x8a7ba,%ecx
f01038cc:	8b 55 08             	mov    0x8(%ebp),%edx
f01038cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if (envid == 0) {
f01038d2:	85 d2                	test   %edx,%edx
f01038d4:	74 41                	je     f0103917 <envid2env+0x5a>
    e = &envs[ENVX(envid)];
f01038d6:	89 d0                	mov    %edx,%eax
f01038d8:	25 ff 03 00 00       	and    $0x3ff,%eax
f01038dd:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01038e0:	c1 e0 05             	shl    $0x5,%eax
f01038e3:	03 81 d0 22 00 00    	add    0x22d0(%ecx),%eax
    if (e->env_status == ENV_FREE || e->env_id != envid) {
f01038e9:	83 78 54 00          	cmpl   $0x0,0x54(%eax)
f01038ed:	74 3a                	je     f0103929 <envid2env+0x6c>
f01038ef:	39 50 48             	cmp    %edx,0x48(%eax)
f01038f2:	75 35                	jne    f0103929 <envid2env+0x6c>
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01038f4:	84 db                	test   %bl,%bl
f01038f6:	74 12                	je     f010390a <envid2env+0x4d>
f01038f8:	8b 91 cc 22 00 00    	mov    0x22cc(%ecx),%edx
f01038fe:	39 c2                	cmp    %eax,%edx
f0103900:	74 08                	je     f010390a <envid2env+0x4d>
f0103902:	8b 5a 48             	mov    0x48(%edx),%ebx
f0103905:	39 58 4c             	cmp    %ebx,0x4c(%eax)
f0103908:	75 2f                	jne    f0103939 <envid2env+0x7c>
    *env_store = e;
f010390a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010390d:	89 03                	mov    %eax,(%ebx)
    return 0;
f010390f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103914:	5b                   	pop    %ebx
f0103915:	5d                   	pop    %ebp
f0103916:	c3                   	ret    
        *env_store = curenv;
f0103917:	8b 81 cc 22 00 00    	mov    0x22cc(%ecx),%eax
f010391d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103920:	89 01                	mov    %eax,(%ecx)
        return 0;
f0103922:	b8 00 00 00 00       	mov    $0x0,%eax
f0103927:	eb eb                	jmp    f0103914 <envid2env+0x57>
        *env_store = 0;
f0103929:	8b 45 0c             	mov    0xc(%ebp),%eax
f010392c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f0103932:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103937:	eb db                	jmp    f0103914 <envid2env+0x57>
        *env_store = 0;
f0103939:	8b 45 0c             	mov    0xc(%ebp),%eax
f010393c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f0103942:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103947:	eb cb                	jmp    f0103914 <envid2env+0x57>

f0103949 <env_init_percpu>:
env_init_percpu(void) {
f0103949:	55                   	push   %ebp
f010394a:	89 e5                	mov    %esp,%ebp
f010394c:	e8 8f ce ff ff       	call   f01007e0 <__x86.get_pc_thunk.ax>
f0103951:	05 2f a7 08 00       	add    $0x8a72f,%eax
	asm volatile("lgdt (%0)" : : "r" (p));
f0103956:	8d 80 80 1f 00 00    	lea    0x1f80(%eax),%eax
f010395c:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax,%%gs" : : "a" (GD_UD | 3));
f010395f:	b8 23 00 00 00       	mov    $0x23,%eax
f0103964:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax,%%fs" : : "a" (GD_UD | 3));
f0103966:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103968:	b8 10 00 00 00       	mov    $0x10,%eax
f010396d:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f010396f:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103971:	8e d0                	mov    %eax,%ss
    asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103973:	ea 7a 39 10 f0 08 00 	ljmp   $0x8,$0xf010397a
	asm volatile("lldt %0" : : "r" (sel));
f010397a:	b8 00 00 00 00       	mov    $0x0,%eax
f010397f:	0f 00 d0             	lldt   %ax
}
f0103982:	5d                   	pop    %ebp
f0103983:	c3                   	ret    

f0103984 <env_init>:
env_init(void) {
f0103984:	55                   	push   %ebp
f0103985:	89 e5                	mov    %esp,%ebp
f0103987:	57                   	push   %edi
f0103988:	56                   	push   %esi
f0103989:	53                   	push   %ebx
f010398a:	e8 4c 07 00 00       	call   f01040db <__x86.get_pc_thunk.si>
f010398f:	81 c6 f1 a6 08 00    	add    $0x8a6f1,%esi
        envs[i].env_link = env_free_list;
f0103995:	8b be d0 22 00 00    	mov    0x22d0(%esi),%edi
f010399b:	8b 96 d4 22 00 00    	mov    0x22d4(%esi),%edx
f01039a1:	8d 87 a0 7f 01 00    	lea    0x17fa0(%edi),%eax
f01039a7:	8d 5f a0             	lea    -0x60(%edi),%ebx
f01039aa:	89 c1                	mov    %eax,%ecx
f01039ac:	89 50 44             	mov    %edx,0x44(%eax)
f01039af:	83 e8 60             	sub    $0x60,%eax
        env_free_list = &envs[i];
f01039b2:	89 ca                	mov    %ecx,%edx
    for (i = NENV - 1; i >= 0; i--) {
f01039b4:	39 d8                	cmp    %ebx,%eax
f01039b6:	75 f2                	jne    f01039aa <env_init+0x26>
f01039b8:	89 be d4 22 00 00    	mov    %edi,0x22d4(%esi)
    env_init_percpu();
f01039be:	e8 86 ff ff ff       	call   f0103949 <env_init_percpu>
}
f01039c3:	5b                   	pop    %ebx
f01039c4:	5e                   	pop    %esi
f01039c5:	5f                   	pop    %edi
f01039c6:	5d                   	pop    %ebp
f01039c7:	c3                   	ret    

f01039c8 <env_alloc>:
env_alloc(struct Env **newenv_store, envid_t parent_id) {
f01039c8:	55                   	push   %ebp
f01039c9:	89 e5                	mov    %esp,%ebp
f01039cb:	57                   	push   %edi
f01039cc:	56                   	push   %esi
f01039cd:	53                   	push   %ebx
f01039ce:	83 ec 18             	sub    $0x18,%esp
f01039d1:	e8 68 c8 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01039d6:	81 c3 aa a6 08 00    	add    $0x8a6aa,%ebx
    cprintf("************* Now we alloc a env. **************\n");
f01039dc:	8d 83 28 93 f7 ff    	lea    -0x86cd8(%ebx),%eax
f01039e2:	50                   	push   %eax
f01039e3:	e8 7e 07 00 00       	call   f0104166 <cprintf>
    if (!(e = env_free_list))
f01039e8:	8b b3 d4 22 00 00    	mov    0x22d4(%ebx),%esi
f01039ee:	83 c4 10             	add    $0x10,%esp
f01039f1:	85 f6                	test   %esi,%esi
f01039f3:	0f 84 d9 01 00 00    	je     f0103bd2 <env_alloc+0x20a>
    cprintf("************* Now we set up a env's vm. **************\n");
f01039f9:	83 ec 0c             	sub    $0xc,%esp
f01039fc:	8d 83 5c 93 f7 ff    	lea    -0x86ca4(%ebx),%eax
f0103a02:	50                   	push   %eax
f0103a03:	e8 5e 07 00 00       	call   f0104166 <cprintf>
    if (!(p = page_alloc(ALLOC_ZERO)))
f0103a08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103a0f:	e8 b8 d7 ff ff       	call   f01011cc <page_alloc>
f0103a14:	83 c4 10             	add    $0x10,%esp
f0103a17:	85 c0                	test   %eax,%eax
f0103a19:	0f 84 ba 01 00 00    	je     f0103bd9 <env_alloc+0x211>
	return (pp - pages) << PGSHIFT;
f0103a1f:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f0103a25:	89 c1                	mov    %eax,%ecx
f0103a27:	2b 0a                	sub    (%edx),%ecx
f0103a29:	89 ca                	mov    %ecx,%edx
f0103a2b:	c1 fa 03             	sar    $0x3,%edx
f0103a2e:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0103a31:	89 d7                	mov    %edx,%edi
f0103a33:	c1 ef 0c             	shr    $0xc,%edi
f0103a36:	c7 c1 08 10 19 f0    	mov    $0xf0191008,%ecx
f0103a3c:	3b 39                	cmp    (%ecx),%edi
f0103a3e:	0f 83 5f 01 00 00    	jae    f0103ba3 <env_alloc+0x1db>
	return (void *)(pa + KERNBASE);
f0103a44:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103a4a:	89 56 5c             	mov    %edx,0x5c(%esi)
    p->pp_ref++;
f0103a4d:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    cprintf("UTOP:0x%x\te->env_pgdor:0x%x\tsizeof(pde_t):%d\n", UTOP, e->env_pgdir, sizeof(pde_t));
f0103a52:	6a 04                	push   $0x4
f0103a54:	ff 76 5c             	pushl  0x5c(%esi)
f0103a57:	68 00 00 c0 ee       	push   $0xeec00000
f0103a5c:	8d 83 94 93 f7 ff    	lea    -0x86c6c(%ebx),%eax
f0103a62:	50                   	push   %eax
f0103a63:	e8 fe 06 00 00       	call   f0104166 <cprintf>
    cprintf("UTOP:0x%x\tutop_off:0x%x\te->env_pgdir + utop_off:0x%x\tkern_pgdir + utop_off:%x\tsizeof(pde_t) * (NPDENTRIES - utop_off)):%d\n",
f0103a68:	83 c4 08             	add    $0x8,%esp
f0103a6b:	68 14 01 00 00       	push   $0x114
f0103a70:	c7 c7 0c 10 19 f0    	mov    $0xf019100c,%edi
f0103a76:	8b 07                	mov    (%edi),%eax
f0103a78:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103a7d:	50                   	push   %eax
f0103a7e:	8b 46 5c             	mov    0x5c(%esi),%eax
f0103a81:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103a86:	50                   	push   %eax
f0103a87:	68 bb 03 00 00       	push   $0x3bb
f0103a8c:	68 00 00 c0 ee       	push   $0xeec00000
f0103a91:	8d 83 c4 93 f7 ff    	lea    -0x86c3c(%ebx),%eax
f0103a97:	50                   	push   %eax
f0103a98:	e8 c9 06 00 00       	call   f0104166 <cprintf>
    memcpy(e->env_pgdir + utop_off, kern_pgdir + utop_off, sizeof(pde_t) * (NPDENTRIES - utop_off));
f0103a9d:	83 c4 1c             	add    $0x1c,%esp
f0103aa0:	68 14 01 00 00       	push   $0x114
f0103aa5:	8b 07                	mov    (%edi),%eax
f0103aa7:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103aac:	50                   	push   %eax
f0103aad:	8b 46 5c             	mov    0x5c(%esi),%eax
f0103ab0:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103ab5:	50                   	push   %eax
f0103ab6:	e8 12 1c 00 00       	call   f01056cd <memcpy>
    e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103abb:	8b 46 5c             	mov    0x5c(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103abe:	83 c4 10             	add    $0x10,%esp
f0103ac1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ac6:	0f 86 ed 00 00 00    	jbe    f0103bb9 <env_alloc+0x1f1>
	return (physaddr_t)kva - KERNBASE;
f0103acc:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103ad2:	83 ca 05             	or     $0x5,%edx
f0103ad5:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
    cprintf("************* Now we successfully set up a env's vm. **************\n");
f0103adb:	83 ec 0c             	sub    $0xc,%esp
f0103ade:	8d 83 40 94 f7 ff    	lea    -0x86bc0(%ebx),%eax
f0103ae4:	50                   	push   %eax
f0103ae5:	e8 7c 06 00 00       	call   f0104166 <cprintf>
    generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103aea:	8b 46 48             	mov    0x48(%esi),%eax
f0103aed:	05 00 10 00 00       	add    $0x1000,%eax
    if (generation <= 0)    // Don't create a negative env_id.
f0103af2:	83 c4 0c             	add    $0xc,%esp
f0103af5:	25 00 fc ff ff       	and    $0xfffffc00,%eax
        generation = 1 << ENVGENSHIFT;
f0103afa:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103aff:	0f 4e c2             	cmovle %edx,%eax
    e->env_id = generation | (e - envs);
f0103b02:	89 f2                	mov    %esi,%edx
f0103b04:	2b 93 d0 22 00 00    	sub    0x22d0(%ebx),%edx
f0103b0a:	c1 fa 05             	sar    $0x5,%edx
f0103b0d:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0103b13:	09 d0                	or     %edx,%eax
f0103b15:	89 46 48             	mov    %eax,0x48(%esi)
    e->env_parent_id = parent_id;
f0103b18:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b1b:	89 46 4c             	mov    %eax,0x4c(%esi)
    e->env_type = ENV_TYPE_USER;
f0103b1e:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
    e->env_status = ENV_RUNNABLE;
f0103b25:	c7 46 54 02 00 00 00 	movl   $0x2,0x54(%esi)
    e->env_runs = 0;
f0103b2c:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
    memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103b33:	6a 44                	push   $0x44
f0103b35:	6a 00                	push   $0x0
f0103b37:	56                   	push   %esi
f0103b38:	e8 db 1a 00 00       	call   f0105618 <memset>
    e->env_tf.tf_ds = GD_UD | 3;
f0103b3d:	66 c7 46 24 23 00    	movw   $0x23,0x24(%esi)
    e->env_tf.tf_es = GD_UD | 3;
f0103b43:	66 c7 46 20 23 00    	movw   $0x23,0x20(%esi)
    e->env_tf.tf_ss = GD_UD | 3;
f0103b49:	66 c7 46 40 23 00    	movw   $0x23,0x40(%esi)
    e->env_tf.tf_esp = USTACKTOP;
f0103b4f:	c7 46 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%esi)
    e->env_tf.tf_cs = GD_UT | 3;
f0103b56:	66 c7 46 34 1b 00    	movw   $0x1b,0x34(%esi)
    env_free_list = e->env_link;
f0103b5c:	8b 46 44             	mov    0x44(%esi),%eax
f0103b5f:	89 83 d4 22 00 00    	mov    %eax,0x22d4(%ebx)
    *newenv_store = e;
f0103b65:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b68:	89 30                	mov    %esi,(%eax)
    cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103b6a:	8b 4e 48             	mov    0x48(%esi),%ecx
f0103b6d:	8b 83 cc 22 00 00    	mov    0x22cc(%ebx),%eax
f0103b73:	83 c4 10             	add    $0x10,%esp
f0103b76:	ba 00 00 00 00       	mov    $0x0,%edx
f0103b7b:	85 c0                	test   %eax,%eax
f0103b7d:	74 03                	je     f0103b82 <env_alloc+0x1ba>
f0103b7f:	8b 50 48             	mov    0x48(%eax),%edx
f0103b82:	83 ec 04             	sub    $0x4,%esp
f0103b85:	51                   	push   %ecx
f0103b86:	52                   	push   %edx
f0103b87:	8d 83 cc 92 f7 ff    	lea    -0x86d34(%ebx),%eax
f0103b8d:	50                   	push   %eax
f0103b8e:	e8 d3 05 00 00       	call   f0104166 <cprintf>
    return 0;
f0103b93:	83 c4 10             	add    $0x10,%esp
f0103b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b9e:	5b                   	pop    %ebx
f0103b9f:	5e                   	pop    %esi
f0103ba0:	5f                   	pop    %edi
f0103ba1:	5d                   	pop    %ebp
f0103ba2:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103ba3:	52                   	push   %edx
f0103ba4:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f0103baa:	50                   	push   %eax
f0103bab:	6a 56                	push   $0x56
f0103bad:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
f0103bb3:	50                   	push   %eax
f0103bb4:	e8 cf c5 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bb9:	50                   	push   %eax
f0103bba:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f0103bc0:	50                   	push   %eax
f0103bc1:	68 c9 00 00 00       	push   $0xc9
f0103bc6:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f0103bcc:	50                   	push   %eax
f0103bcd:	e8 b6 c5 ff ff       	call   f0100188 <_panic>
        return -E_NO_FREE_ENV;
f0103bd2:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103bd7:	eb c2                	jmp    f0103b9b <env_alloc+0x1d3>
        return -E_NO_MEM;
f0103bd9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103bde:	eb bb                	jmp    f0103b9b <env_alloc+0x1d3>

f0103be0 <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type) {
f0103be0:	55                   	push   %ebp
f0103be1:	89 e5                	mov    %esp,%ebp
f0103be3:	57                   	push   %edi
f0103be4:	56                   	push   %esi
f0103be5:	53                   	push   %ebx
f0103be6:	83 ec 38             	sub    $0x38,%esp
f0103be9:	e8 50 c6 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103bee:	81 c3 92 a4 08 00    	add    $0x8a492,%ebx
    cprintf("************* Now we create a env. **************\n");
f0103bf4:	8d 83 88 94 f7 ff    	lea    -0x86b78(%ebx),%eax
f0103bfa:	50                   	push   %eax
f0103bfb:	e8 66 05 00 00       	call   f0104166 <cprintf>
    // LAB 3: Your code here.
    struct Env *Env = NULL;
f0103c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    switch (env_alloc(&Env, 0)) {
f0103c07:	83 c4 08             	add    $0x8,%esp
f0103c0a:	6a 00                	push   $0x0
f0103c0c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103c0f:	50                   	push   %eax
f0103c10:	e8 b3 fd ff ff       	call   f01039c8 <env_alloc>
        default:
            //todo
            break;
    };

    load_icode(Env, binary);
f0103c15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103c18:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cprintf("************* Now we load_icode about a env e. **************\n");
f0103c1b:	8d 83 bc 94 f7 ff    	lea    -0x86b44(%ebx),%eax
f0103c21:	89 04 24             	mov    %eax,(%esp)
f0103c24:	e8 3d 05 00 00       	call   f0104166 <cprintf>
    cprintf("************* Now we load each program segment. **************\n");
f0103c29:	8d 83 fc 94 f7 ff    	lea    -0x86b04(%ebx),%eax
f0103c2f:	89 04 24             	mov    %eax,(%esp)
f0103c32:	e8 2f 05 00 00       	call   f0104166 <cprintf>
    ph = (struct Proghdr *) (binary + elfHdr->e_phoff);
f0103c37:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c3a:	89 c6                	mov    %eax,%esi
f0103c3c:	03 70 1c             	add    0x1c(%eax),%esi
    eph = ph + elfHdr->e_phnum;
f0103c3f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103c43:	c1 e0 05             	shl    $0x5,%eax
f0103c46:	8d 3c 06             	lea    (%esi,%eax,1),%edi
f0103c49:	83 c4 10             	add    $0x10,%esp
            cprintf("ph->p_type:%x\t ph->p_offset:0x%x\t ph->p_va:0x%x\t ph->p_pa:0x%x\t ph->p_filesz:0x%x\t ph->p_memsz:0x%x\t ph->p_flags:%x\t ph->p_align:0x%x\t\n",
f0103c4c:	8d 83 3c 95 f7 ff    	lea    -0x86ac4(%ebx),%eax
f0103c52:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103c55:	eb 03                	jmp    f0103c5a <env_create+0x7a>
    for (; ph < eph; ph++) {
f0103c57:	83 c6 20             	add    $0x20,%esi
f0103c5a:	39 f7                	cmp    %esi,%edi
f0103c5c:	76 3a                	jbe    f0103c98 <env_create+0xb8>
        if (ph->p_type == ELF_PROG_LOAD) {
f0103c5e:	83 3e 01             	cmpl   $0x1,(%esi)
f0103c61:	75 f4                	jne    f0103c57 <env_create+0x77>
            cprintf("ph->p_type:%x\t ph->p_offset:0x%x\t ph->p_va:0x%x\t ph->p_pa:0x%x\t ph->p_filesz:0x%x\t ph->p_memsz:0x%x\t ph->p_flags:%x\t ph->p_align:0x%x\t\n",
f0103c63:	83 ec 0c             	sub    $0xc,%esp
f0103c66:	ff 76 1c             	pushl  0x1c(%esi)
f0103c69:	ff 76 18             	pushl  0x18(%esi)
f0103c6c:	ff 76 14             	pushl  0x14(%esi)
f0103c6f:	ff 76 10             	pushl  0x10(%esi)
f0103c72:	ff 76 0c             	pushl  0xc(%esi)
f0103c75:	ff 76 08             	pushl  0x8(%esi)
f0103c78:	ff 76 04             	pushl  0x4(%esi)
f0103c7b:	6a 01                	push   $0x1
f0103c7d:	ff 75 d0             	pushl  -0x30(%ebp)
f0103c80:	e8 e1 04 00 00       	call   f0104166 <cprintf>
            region_alloc(e, (void *) ph->p_va, ph->p_memsz);
f0103c85:	83 c4 30             	add    $0x30,%esp
f0103c88:	8b 4e 14             	mov    0x14(%esi),%ecx
f0103c8b:	8b 56 08             	mov    0x8(%esi),%edx
f0103c8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103c91:	e8 b2 fb ff ff       	call   f0103848 <region_alloc>
f0103c96:	eb bf                	jmp    f0103c57 <env_create+0x77>
    cprintf("************* Now we copy each section which should load. **************\n");
f0103c98:	83 ec 0c             	sub    $0xc,%esp
f0103c9b:	8d 83 c4 95 f7 ff    	lea    -0x86a3c(%ebx),%eax
f0103ca1:	50                   	push   %eax
f0103ca2:	e8 bf 04 00 00       	call   f0104166 <cprintf>
    struct Secthdr *sectHdr = (struct Secthdr *) (binary + elfHdr->e_shoff);
f0103ca7:	8b 45 08             	mov    0x8(%ebp),%eax
f0103caa:	89 c6                	mov    %eax,%esi
f0103cac:	03 70 20             	add    0x20(%eax),%esi
	asm volatile("movl %%cr3,%0" : "=r" (val));
f0103caf:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f0103cb2:	83 c4 08             	add    $0x8,%esp
f0103cb5:	50                   	push   %eax
f0103cb6:	8d 83 e1 92 f7 ff    	lea    -0x86d1f(%ebx),%eax
f0103cbc:	50                   	push   %eax
f0103cbd:	e8 a4 04 00 00       	call   f0104166 <cprintf>
    lcr3(PADDR(e->env_pgdir));
f0103cc2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103cc5:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103cc8:	83 c4 10             	add    $0x10,%esp
f0103ccb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103cd0:	76 2e                	jbe    f0103d00 <env_create+0x120>
	return (physaddr_t)kva - KERNBASE;
f0103cd2:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103cd7:	0f 22 d8             	mov    %eax,%cr3
	asm volatile("movl %%cr3,%0" : "=r" (val));
f0103cda:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f0103cdd:	83 ec 08             	sub    $0x8,%esp
f0103ce0:	50                   	push   %eax
f0103ce1:	8d 83 e1 92 f7 ff    	lea    -0x86d1f(%ebx),%eax
f0103ce7:	50                   	push   %eax
f0103ce8:	e8 79 04 00 00       	call   f0104166 <cprintf>
f0103ced:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f0103cf0:	bf 00 00 00 00       	mov    $0x0,%edi
            cprintf("(void *) sectHdr->sh_addr:0x%x\tsectHdr->sh_offset:0x%x\tsectHdr->sh_size:0x%x\n", sectHdr->sh_addr, sectHdr->sh_offset, sectHdr->sh_size);
f0103cf5:	8d 83 10 96 f7 ff    	lea    -0x869f0(%ebx),%eax
f0103cfb:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103cfe:	eb 46                	jmp    f0103d46 <env_create+0x166>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d00:	50                   	push   %eax
f0103d01:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f0103d07:	50                   	push   %eax
f0103d08:	68 86 01 00 00       	push   $0x186
f0103d0d:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f0103d13:	50                   	push   %eax
f0103d14:	e8 6f c4 ff ff       	call   f0100188 <_panic>
f0103d19:	ff 76 14             	pushl  0x14(%esi)
f0103d1c:	ff 76 10             	pushl  0x10(%esi)
f0103d1f:	50                   	push   %eax
f0103d20:	ff 75 d0             	pushl  -0x30(%ebp)
f0103d23:	e8 3e 04 00 00       	call   f0104166 <cprintf>
            memcpy((void *) sectHdr->sh_addr, binary + sectHdr->sh_offset, sectHdr->sh_size);
f0103d28:	83 c4 0c             	add    $0xc,%esp
f0103d2b:	ff 76 14             	pushl  0x14(%esi)
f0103d2e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d31:	03 46 10             	add    0x10(%esi),%eax
f0103d34:	50                   	push   %eax
f0103d35:	ff 76 0c             	pushl  0xc(%esi)
f0103d38:	e8 90 19 00 00       	call   f01056cd <memcpy>
f0103d3d:	83 c4 10             	add    $0x10,%esp
        sectHdr++;
f0103d40:	83 c6 28             	add    $0x28,%esi
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f0103d43:	83 c7 01             	add    $0x1,%edi
f0103d46:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d49:	0f b7 40 30          	movzwl 0x30(%eax),%eax
f0103d4d:	39 c7                	cmp    %eax,%edi
f0103d4f:	7d 0f                	jge    f0103d60 <env_create+0x180>
        if (sectHdr->sh_addr != 0 && sectHdr->sh_type != ELF_SHT_NOBITS) {
f0103d51:	8b 46 0c             	mov    0xc(%esi),%eax
f0103d54:	85 c0                	test   %eax,%eax
f0103d56:	74 e8                	je     f0103d40 <env_create+0x160>
f0103d58:	83 7e 04 08          	cmpl   $0x8,0x4(%esi)
f0103d5c:	74 e2                	je     f0103d40 <env_create+0x160>
f0103d5e:	eb b9                	jmp    f0103d19 <env_create+0x139>
    lcr3(PADDR(kern_pgdir));
f0103d60:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0103d66:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103d68:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d6d:	76 48                	jbe    f0103db7 <env_create+0x1d7>
	return (physaddr_t)kva - KERNBASE;
f0103d6f:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103d74:	0f 22 d8             	mov    %eax,%cr3
    cprintf("************* Now we map one page for the program's initial stack. **************\n");
f0103d77:	83 ec 0c             	sub    $0xc,%esp
f0103d7a:	8d 83 60 96 f7 ff    	lea    -0x869a0(%ebx),%eax
f0103d80:	50                   	push   %eax
f0103d81:	e8 e0 03 00 00       	call   f0104166 <cprintf>
    region_alloc(e, (void *) USTACKTOP - PGSIZE, PGSIZE);
f0103d86:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103d8b:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103d90:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103d93:	89 f8                	mov    %edi,%eax
f0103d95:	e8 ae fa ff ff       	call   f0103848 <region_alloc>
    e->env_tf.tf_eip = elfHdr->e_entry;
f0103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d9d:	8b 40 18             	mov    0x18(%eax),%eax
f0103da0:	89 47 30             	mov    %eax,0x30(%edi)

    Env->env_type = type;
f0103da3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103da9:	89 50 50             	mov    %edx,0x50(%eax)
}
f0103dac:	83 c4 10             	add    $0x10,%esp
f0103daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103db2:	5b                   	pop    %ebx
f0103db3:	5e                   	pop    %esi
f0103db4:	5f                   	pop    %edi
f0103db5:	5d                   	pop    %ebp
f0103db6:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103db7:	50                   	push   %eax
f0103db8:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f0103dbe:	50                   	push   %eax
f0103dbf:	68 90 01 00 00       	push   $0x190
f0103dc4:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f0103dca:	50                   	push   %eax
f0103dcb:	e8 b8 c3 ff ff       	call   f0100188 <_panic>

f0103dd0 <env_free>:

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
f0103dd0:	55                   	push   %ebp
f0103dd1:	89 e5                	mov    %esp,%ebp
f0103dd3:	57                   	push   %edi
f0103dd4:	56                   	push   %esi
f0103dd5:	53                   	push   %ebx
f0103dd6:	83 ec 2c             	sub    $0x2c,%esp
f0103dd9:	e8 60 c4 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103dde:	81 c3 a2 a2 08 00    	add    $0x8a2a2,%ebx
    physaddr_t pa;

    // If freeing the current environment, switch to kern_pgdir
    // before freeing the page directory, just in case the page
    // gets reused.
    if (e == curenv)
f0103de4:	8b 93 cc 22 00 00    	mov    0x22cc(%ebx),%edx
f0103dea:	3b 55 08             	cmp    0x8(%ebp),%edx
f0103ded:	75 17                	jne    f0103e06 <env_free+0x36>
        lcr3(PADDR(kern_pgdir));
f0103def:	c7 c0 0c 10 19 f0    	mov    $0xf019100c,%eax
f0103df5:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103df7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103dfc:	76 46                	jbe    f0103e44 <env_free+0x74>
	return (physaddr_t)kva - KERNBASE;
f0103dfe:	05 00 00 00 10       	add    $0x10000000,%eax
f0103e03:	0f 22 d8             	mov    %eax,%cr3

    // Note the environment's demise.
    cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103e06:	8b 45 08             	mov    0x8(%ebp),%eax
f0103e09:	8b 48 48             	mov    0x48(%eax),%ecx
f0103e0c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103e11:	85 d2                	test   %edx,%edx
f0103e13:	74 03                	je     f0103e18 <env_free+0x48>
f0103e15:	8b 42 48             	mov    0x48(%edx),%eax
f0103e18:	83 ec 04             	sub    $0x4,%esp
f0103e1b:	51                   	push   %ecx
f0103e1c:	50                   	push   %eax
f0103e1d:	8d 83 ee 92 f7 ff    	lea    -0x86d12(%ebx),%eax
f0103e23:	50                   	push   %eax
f0103e24:	e8 3d 03 00 00       	call   f0104166 <cprintf>
f0103e29:	83 c4 10             	add    $0x10,%esp
f0103e2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	if (PGNUM(pa) >= npages)
f0103e33:	c7 c0 08 10 19 f0    	mov    $0xf0191008,%eax
f0103e39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (PGNUM(pa) >= npages)
f0103e3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103e3f:	e9 9f 00 00 00       	jmp    f0103ee3 <env_free+0x113>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e44:	50                   	push   %eax
f0103e45:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f0103e4b:	50                   	push   %eax
f0103e4c:	68 c8 01 00 00       	push   $0x1c8
f0103e51:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f0103e57:	50                   	push   %eax
f0103e58:	e8 2b c3 ff ff       	call   f0100188 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103e5d:	50                   	push   %eax
f0103e5e:	8d 83 60 81 f7 ff    	lea    -0x87ea0(%ebx),%eax
f0103e64:	50                   	push   %eax
f0103e65:	68 d7 01 00 00       	push   $0x1d7
f0103e6a:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f0103e70:	50                   	push   %eax
f0103e71:	e8 12 c3 ff ff       	call   f0100188 <_panic>
f0103e76:	83 c6 04             	add    $0x4,%esi
        // find the pa and va of the page table
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
        pt = (pte_t *) KADDR(pa);

        // unmap all PTEs in this page table
        for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103e79:	39 fe                	cmp    %edi,%esi
f0103e7b:	74 24                	je     f0103ea1 <env_free+0xd1>
            if (pt[pteno] & PTE_P)
f0103e7d:	f6 06 01             	testb  $0x1,(%esi)
f0103e80:	74 f4                	je     f0103e76 <env_free+0xa6>
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103e82:	83 ec 08             	sub    $0x8,%esp
f0103e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103e88:	01 f0                	add    %esi,%eax
f0103e8a:	c1 e0 0a             	shl    $0xa,%eax
f0103e8d:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103e90:	50                   	push   %eax
f0103e91:	8b 45 08             	mov    0x8(%ebp),%eax
f0103e94:	ff 70 5c             	pushl  0x5c(%eax)
f0103e97:	e8 b9 d5 ff ff       	call   f0101455 <page_remove>
f0103e9c:	83 c4 10             	add    $0x10,%esp
f0103e9f:	eb d5                	jmp    f0103e76 <env_free+0xa6>
        }

        // free the page table itself
        e->env_pgdir[pdeno] = 0;
f0103ea1:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ea4:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103eaa:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103eb1:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103eb4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103eb7:	3b 10                	cmp    (%eax),%edx
f0103eb9:	73 6f                	jae    f0103f2a <env_free+0x15a>
        page_decref(pa2page(pa));
f0103ebb:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103ebe:	c7 c0 10 10 19 f0    	mov    $0xf0191010,%eax
f0103ec4:	8b 00                	mov    (%eax),%eax
f0103ec6:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103ec9:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103ecc:	50                   	push   %eax
f0103ecd:	e8 fa d3 ff ff       	call   f01012cc <page_decref>
f0103ed2:	83 c4 10             	add    $0x10,%esp
f0103ed5:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f0103ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103edc:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103ee1:	74 5f                	je     f0103f42 <env_free+0x172>
        if (!(e->env_pgdir[pdeno] & PTE_P))
f0103ee3:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ee6:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103ee9:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103eec:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103eef:	a8 01                	test   $0x1,%al
f0103ef1:	74 e2                	je     f0103ed5 <env_free+0x105>
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103ef3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0103ef8:	89 c2                	mov    %eax,%edx
f0103efa:	c1 ea 0c             	shr    $0xc,%edx
f0103efd:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0103f00:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103f03:	39 11                	cmp    %edx,(%ecx)
f0103f05:	0f 86 52 ff ff ff    	jbe    f0103e5d <env_free+0x8d>
	return (void *)(pa + KERNBASE);
f0103f0b:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103f11:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103f14:	c1 e2 14             	shl    $0x14,%edx
f0103f17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103f1a:	8d b8 00 10 00 f0    	lea    -0xffff000(%eax),%edi
f0103f20:	f7 d8                	neg    %eax
f0103f22:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103f25:	e9 53 ff ff ff       	jmp    f0103e7d <env_free+0xad>
		panic("pa2page called with invalid pa");
f0103f2a:	83 ec 04             	sub    $0x4,%esp
f0103f2d:	8d 83 5c 83 f7 ff    	lea    -0x87ca4(%ebx),%eax
f0103f33:	50                   	push   %eax
f0103f34:	6a 4f                	push   $0x4f
f0103f36:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
f0103f3c:	50                   	push   %eax
f0103f3d:	e8 46 c2 ff ff       	call   f0100188 <_panic>
    }

    // free the page directory
    pa = PADDR(e->env_pgdir);
f0103f42:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f45:	8b 40 5c             	mov    0x5c(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103f48:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103f4d:	76 57                	jbe    f0103fa6 <env_free+0x1d6>
    e->env_pgdir = 0;
f0103f4f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103f52:	c7 42 5c 00 00 00 00 	movl   $0x0,0x5c(%edx)
	return (physaddr_t)kva - KERNBASE;
f0103f59:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103f5e:	c1 e8 0c             	shr    $0xc,%eax
f0103f61:	c7 c2 08 10 19 f0    	mov    $0xf0191008,%edx
f0103f67:	3b 02                	cmp    (%edx),%eax
f0103f69:	73 54                	jae    f0103fbf <env_free+0x1ef>
    page_decref(pa2page(pa));
f0103f6b:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103f6e:	c7 c2 10 10 19 f0    	mov    $0xf0191010,%edx
f0103f74:	8b 12                	mov    (%edx),%edx
f0103f76:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103f79:	50                   	push   %eax
f0103f7a:	e8 4d d3 ff ff       	call   f01012cc <page_decref>

    // return the environment to the free list
    e->env_status = ENV_FREE;
f0103f7f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f82:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
    e->env_link = env_free_list;
f0103f89:	8b 83 d4 22 00 00    	mov    0x22d4(%ebx),%eax
f0103f8f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103f92:	89 42 44             	mov    %eax,0x44(%edx)
    env_free_list = e;
f0103f95:	89 93 d4 22 00 00    	mov    %edx,0x22d4(%ebx)
}
f0103f9b:	83 c4 10             	add    $0x10,%esp
f0103f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103fa1:	5b                   	pop    %ebx
f0103fa2:	5e                   	pop    %esi
f0103fa3:	5f                   	pop    %edi
f0103fa4:	5d                   	pop    %ebp
f0103fa5:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103fa6:	50                   	push   %eax
f0103fa7:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f0103fad:	50                   	push   %eax
f0103fae:	68 e5 01 00 00       	push   $0x1e5
f0103fb3:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f0103fb9:	50                   	push   %eax
f0103fba:	e8 c9 c1 ff ff       	call   f0100188 <_panic>
		panic("pa2page called with invalid pa");
f0103fbf:	83 ec 04             	sub    $0x4,%esp
f0103fc2:	8d 83 5c 83 f7 ff    	lea    -0x87ca4(%ebx),%eax
f0103fc8:	50                   	push   %eax
f0103fc9:	6a 4f                	push   $0x4f
f0103fcb:	8d 83 5e 8f f7 ff    	lea    -0x870a2(%ebx),%eax
f0103fd1:	50                   	push   %eax
f0103fd2:	e8 b1 c1 ff ff       	call   f0100188 <_panic>

f0103fd7 <env_destroy>:

//
// Frees environment e.
//
void
env_destroy(struct Env *e) {
f0103fd7:	55                   	push   %ebp
f0103fd8:	89 e5                	mov    %esp,%ebp
f0103fda:	53                   	push   %ebx
f0103fdb:	83 ec 10             	sub    $0x10,%esp
f0103fde:	e8 5b c2 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0103fe3:	81 c3 9d a0 08 00    	add    $0x8a09d,%ebx
    env_free(e);
f0103fe9:	ff 75 08             	pushl  0x8(%ebp)
f0103fec:	e8 df fd ff ff       	call   f0103dd0 <env_free>

    cprintf("Destroyed the only environment - nothing more to do!\n");
f0103ff1:	8d 83 b4 96 f7 ff    	lea    -0x8694c(%ebx),%eax
f0103ff7:	89 04 24             	mov    %eax,(%esp)
f0103ffa:	e8 67 01 00 00       	call   f0104166 <cprintf>
f0103fff:	83 c4 10             	add    $0x10,%esp
    while (1)
        monitor(NULL);
f0104002:	83 ec 0c             	sub    $0xc,%esp
f0104005:	6a 00                	push   $0x0
f0104007:	e8 94 c9 ff ff       	call   f01009a0 <monitor>
f010400c:	83 c4 10             	add    $0x10,%esp
f010400f:	eb f1                	jmp    f0104002 <env_destroy+0x2b>

f0104011 <env_pop_tf>:
// this exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
f0104011:	55                   	push   %ebp
f0104012:	89 e5                	mov    %esp,%ebp
f0104014:	53                   	push   %ebx
f0104015:	83 ec 08             	sub    $0x8,%esp
f0104018:	e8 21 c2 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010401d:	81 c3 63 a0 08 00    	add    $0x8a063,%ebx
    asm volatile(
f0104023:	8b 65 08             	mov    0x8(%ebp),%esp
f0104026:	61                   	popa   
f0104027:	07                   	pop    %es
f0104028:	1f                   	pop    %ds
f0104029:	83 c4 08             	add    $0x8,%esp
f010402c:	cf                   	iret   
    "\tpopl %%es\n"
    "\tpopl %%ds\n"
    "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
    "\tiret\n"
    : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
f010402d:	8d 83 04 93 f7 ff    	lea    -0x86cfc(%ebx),%eax
f0104033:	50                   	push   %eax
f0104034:	68 0c 02 00 00       	push   $0x20c
f0104039:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f010403f:	50                   	push   %eax
f0104040:	e8 43 c1 ff ff       	call   f0100188 <_panic>

f0104045 <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
f0104045:	55                   	push   %ebp
f0104046:	89 e5                	mov    %esp,%ebp
f0104048:	56                   	push   %esi
f0104049:	53                   	push   %ebx
f010404a:	e8 ef c1 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010404f:	81 c3 31 a0 08 00    	add    $0x8a031,%ebx
f0104055:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("************* Now we run a env. **************\n");
f0104058:	83 ec 0c             	sub    $0xc,%esp
f010405b:	8d 83 ec 96 f7 ff    	lea    -0x86914(%ebx),%eax
f0104061:	50                   	push   %eax
f0104062:	e8 ff 00 00 00       	call   f0104166 <cprintf>
    //	e->env_tf.  Go back through the code you wrote above
    //	and make sure you have set the relevant parts of
    //	e->env_tf to sensible values.

    // LAB 3: Your code here.
    if (curenv != NULL) {
f0104067:	8b 83 cc 22 00 00    	mov    0x22cc(%ebx),%eax
f010406d:	83 c4 10             	add    $0x10,%esp
f0104070:	85 c0                	test   %eax,%eax
f0104072:	74 06                	je     f010407a <env_run+0x35>
        if (curenv->env_status == ENV_RUNNING) {
f0104074:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104078:	74 34                	je     f01040ae <env_run+0x69>
            curenv->env_status = ENV_RUNNABLE;
        }
    }

    curenv = e;
f010407a:	89 b3 cc 22 00 00    	mov    %esi,0x22cc(%ebx)
    //?????????????????????????????????why this fault?
//    e->env_status = ENV_RUNNABLE;
    e->env_status = ENV_RUNNING;
f0104080:	c7 46 54 03 00 00 00 	movl   $0x3,0x54(%esi)
    e->env_runs++;
f0104087:	83 46 58 01          	addl   $0x1,0x58(%esi)

    lcr3(PADDR(e->env_pgdir));
f010408b:	8b 46 5c             	mov    0x5c(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f010408e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104093:	77 22                	ja     f01040b7 <env_run+0x72>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104095:	50                   	push   %eax
f0104096:	8d 83 04 83 f7 ff    	lea    -0x87cfc(%ebx),%eax
f010409c:	50                   	push   %eax
f010409d:	68 36 02 00 00       	push   $0x236
f01040a2:	8d 83 c1 92 f7 ff    	lea    -0x86d3f(%ebx),%eax
f01040a8:	50                   	push   %eax
f01040a9:	e8 da c0 ff ff       	call   f0100188 <_panic>
            curenv->env_status = ENV_RUNNABLE;
f01040ae:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01040b5:	eb c3                	jmp    f010407a <env_run+0x35>
	return (physaddr_t)kva - KERNBASE;
f01040b7:	05 00 00 00 10       	add    $0x10000000,%eax
f01040bc:	0f 22 d8             	mov    %eax,%cr3

    cprintf("e->env_tf.tf_cs:0x%x\n", e->env_tf.tf_cs);
f01040bf:	83 ec 08             	sub    $0x8,%esp
f01040c2:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01040c6:	50                   	push   %eax
f01040c7:	8d 83 10 93 f7 ff    	lea    -0x86cf0(%ebx),%eax
f01040cd:	50                   	push   %eax
f01040ce:	e8 93 00 00 00       	call   f0104166 <cprintf>
    env_pop_tf(&e->env_tf);
f01040d3:	89 34 24             	mov    %esi,(%esp)
f01040d6:	e8 36 ff ff ff       	call   f0104011 <env_pop_tf>

f01040db <__x86.get_pc_thunk.si>:
f01040db:	8b 34 24             	mov    (%esp),%esi
f01040de:	c3                   	ret    

f01040df <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01040df:	55                   	push   %ebp
f01040e0:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01040e2:	8b 45 08             	mov    0x8(%ebp),%eax
f01040e5:	ba 70 00 00 00       	mov    $0x70,%edx
f01040ea:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01040eb:	ba 71 00 00 00       	mov    $0x71,%edx
f01040f0:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01040f1:	0f b6 c0             	movzbl %al,%eax
}
f01040f4:	5d                   	pop    %ebp
f01040f5:	c3                   	ret    

f01040f6 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01040f6:	55                   	push   %ebp
f01040f7:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01040f9:	8b 45 08             	mov    0x8(%ebp),%eax
f01040fc:	ba 70 00 00 00       	mov    $0x70,%edx
f0104101:	ee                   	out    %al,(%dx)
f0104102:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104105:	ba 71 00 00 00       	mov    $0x71,%edx
f010410a:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f010410b:	5d                   	pop    %ebp
f010410c:	c3                   	ret    

f010410d <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f010410d:	55                   	push   %ebp
f010410e:	89 e5                	mov    %esp,%ebp
f0104110:	53                   	push   %ebx
f0104111:	83 ec 10             	sub    $0x10,%esp
f0104114:	e8 25 c1 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104119:	81 c3 67 9f 08 00    	add    $0x89f67,%ebx
	cputchar(ch);
f010411f:	ff 75 08             	pushl  0x8(%ebp)
f0104122:	e8 8e c6 ff ff       	call   f01007b5 <cputchar>
    //这里会有bug！
	*cnt++;
}
f0104127:	83 c4 10             	add    $0x10,%esp
f010412a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010412d:	c9                   	leave  
f010412e:	c3                   	ret    

f010412f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010412f:	55                   	push   %ebp
f0104130:	89 e5                	mov    %esp,%ebp
f0104132:	53                   	push   %ebx
f0104133:	83 ec 14             	sub    $0x14,%esp
f0104136:	e8 03 c1 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010413b:	81 c3 45 9f 08 00    	add    $0x89f45,%ebx
	int cnt = 0;
f0104141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0104148:	ff 75 0c             	pushl  0xc(%ebp)
f010414b:	ff 75 08             	pushl  0x8(%ebp)
f010414e:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104151:	50                   	push   %eax
f0104152:	8d 83 8d 60 f7 ff    	lea    -0x89f73(%ebx),%eax
f0104158:	50                   	push   %eax
f0104159:	e8 01 0d 00 00       	call   f0104e5f <vprintfmt>
	return cnt;
}
f010415e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104164:	c9                   	leave  
f0104165:	c3                   	ret    

f0104166 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104166:	55                   	push   %ebp
f0104167:	89 e5                	mov    %esp,%ebp
f0104169:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f010416c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010416f:	50                   	push   %eax
f0104170:	ff 75 08             	pushl  0x8(%ebp)
f0104173:	e8 b7 ff ff ff       	call   f010412f <vcprintf>
	va_end(ap);

	return cnt;
}
f0104178:	c9                   	leave  
f0104179:	c3                   	ret    

f010417a <memCprintf>:

//不能重载？？
int memCprintf(const char *name, uintptr_t va, uint32_t pd_item, physaddr_t pa, uint32_t map_page){
f010417a:	55                   	push   %ebp
f010417b:	89 e5                	mov    %esp,%ebp
f010417d:	83 ec 10             	sub    $0x10,%esp
f0104180:	e8 5b c6 ff ff       	call   f01007e0 <__x86.get_pc_thunk.ax>
f0104185:	05 fb 9e 08 00       	add    $0x89efb,%eax
    return cprintf("名称:%s\t虚拟地址:0x%x\t页目录项:0x%x\t物理地址:0x%x\t物理页:0x%x\n", name, va, pd_item, pa, map_page);
f010418a:	ff 75 18             	pushl  0x18(%ebp)
f010418d:	ff 75 14             	pushl  0x14(%ebp)
f0104190:	ff 75 10             	pushl  0x10(%ebp)
f0104193:	ff 75 0c             	pushl  0xc(%ebp)
f0104196:	ff 75 08             	pushl  0x8(%ebp)
f0104199:	8d 80 1c 97 f7 ff    	lea    -0x868e4(%eax),%eax
f010419f:	50                   	push   %eax
f01041a0:	e8 c1 ff ff ff       	call   f0104166 <cprintf>
}
f01041a5:	c9                   	leave  
f01041a6:	c3                   	ret    

f01041a7 <trap_init_percpu>:
    trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void) {
f01041a7:	55                   	push   %ebp
f01041a8:	89 e5                	mov    %esp,%ebp
f01041aa:	57                   	push   %edi
f01041ab:	56                   	push   %esi
f01041ac:	53                   	push   %ebx
f01041ad:	83 ec 24             	sub    $0x24,%esp
f01041b0:	e8 89 c0 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01041b5:	81 c3 cb 9e 08 00    	add    $0x89ecb,%ebx
    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    ts.ts_esp0 = KSTACKTOP;
f01041bb:	c7 83 04 2b 00 00 00 	movl   $0xf0000000,0x2b04(%ebx)
f01041c2:	00 00 f0 
    ts.ts_ss0 = GD_KD;
f01041c5:	66 c7 83 08 2b 00 00 	movw   $0x10,0x2b08(%ebx)
f01041cc:	10 00 
    ts.ts_iomb = sizeof(struct Taskstate);
f01041ce:	66 c7 83 66 2b 00 00 	movw   $0x68,0x2b66(%ebx)
f01041d5:	68 00 

    // Initialize the TSS slot of the gdt.
    cprintf("&ts:0x%x\n", &ts);
f01041d7:	8d b3 00 2b 00 00    	lea    0x2b00(%ebx),%esi
f01041dd:	56                   	push   %esi
f01041de:	8d 83 6c 97 f7 ff    	lea    -0x86894(%ebx),%eax
f01041e4:	50                   	push   %eax
f01041e5:	e8 7c ff ff ff       	call   f0104166 <cprintf>
    gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f01041ea:	c7 c0 00 d3 11 f0    	mov    $0xf011d300,%eax
f01041f0:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
f01041f6:	66 89 70 2a          	mov    %si,0x2a(%eax)
f01041fa:	89 f2                	mov    %esi,%edx
f01041fc:	c1 ea 10             	shr    $0x10,%edx
f01041ff:	88 50 2c             	mov    %dl,0x2c(%eax)
f0104202:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f0104206:	83 e2 f0             	and    $0xfffffff0,%edx
f0104209:	83 ca 09             	or     $0x9,%edx
f010420c:	83 e2 9f             	and    $0xffffff9f,%edx
f010420f:	83 ca 80             	or     $0xffffff80,%edx
f0104212:	88 55 e7             	mov    %dl,-0x19(%ebp)
f0104215:	88 50 2d             	mov    %dl,0x2d(%eax)
f0104218:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
f010421c:	83 e1 c0             	and    $0xffffffc0,%ecx
f010421f:	83 c9 40             	or     $0x40,%ecx
f0104222:	83 e1 7f             	and    $0x7f,%ecx
f0104225:	88 48 2e             	mov    %cl,0x2e(%eax)
f0104228:	c1 ee 18             	shr    $0x18,%esi
f010422b:	89 f1                	mov    %esi,%ecx
f010422d:	88 48 2f             	mov    %cl,0x2f(%eax)
                              sizeof(struct Taskstate) - 1, 0);
    gdt[GD_TSS0 >> 3].sd_s = 0;
f0104230:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
f0104234:	83 e2 ef             	and    $0xffffffef,%edx
f0104237:	88 50 2d             	mov    %dl,0x2d(%eax)
	asm volatile("ltr %0" : : "r" (sel));
f010423a:	b8 28 00 00 00       	mov    $0x28,%eax
f010423f:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0104242:	8d 83 88 1f 00 00    	lea    0x1f88(%ebx),%eax
f0104248:	0f 01 18             	lidtl  (%eax)
    // bottom three bits are special; we leave them 0)
    ltr(GD_TSS0);

    // Load the IDT
    lidt(&idt_pd);
}
f010424b:	83 c4 10             	add    $0x10,%esp
f010424e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104251:	5b                   	pop    %ebx
f0104252:	5e                   	pop    %esi
f0104253:	5f                   	pop    %edi
f0104254:	5d                   	pop    %ebp
f0104255:	c3                   	ret    

f0104256 <trap_init>:
trap_init(void) {
f0104256:	55                   	push   %ebp
f0104257:	89 e5                	mov    %esp,%ebp
f0104259:	57                   	push   %edi
f010425a:	56                   	push   %esi
f010425b:	53                   	push   %ebx
f010425c:	83 ec 6c             	sub    $0x6c,%esp
f010425f:	e8 da bf ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104264:	81 c3 1c 9e 08 00    	add    $0x89e1c,%ebx
    char *handler[] = {handler0, handler1, handler2, handler3, handler4, handler5, handler6, handler7, handler8,
f010426a:	8d 7d 98             	lea    -0x68(%ebp),%edi
f010426d:	8d b3 c0 f2 f8 ff    	lea    -0x70d40(%ebx),%esi
f0104273:	b9 14 00 00 00       	mov    $0x14,%ecx
f0104278:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (int i = 0; i < 20; i++) {
f010427a:	be 00 00 00 00       	mov    $0x0,%esi
        cprintf("idt[%d]\toff:0x%x\n", i, (idt[i].gd_off_31_16 << 16) + idt[i].gd_off_15_0);
f010427f:	8d 83 76 97 f7 ff    	lea    -0x8688a(%ebx),%eax
f0104285:	89 45 94             	mov    %eax,-0x6c(%ebp)
            SETGATE(idt[i], 1, GD_KT, handler[i], 0);
f0104288:	8b 44 b5 98          	mov    -0x68(%ebp,%esi,4),%eax
f010428c:	66 89 84 f3 e0 22 00 	mov    %ax,0x22e0(%ebx,%esi,8)
f0104293:	00 
f0104294:	8d 94 f3 e0 22 00 00 	lea    0x22e0(%ebx,%esi,8),%edx
f010429b:	66 c7 42 02 08 00    	movw   $0x8,0x2(%edx)
f01042a1:	c6 84 f3 e4 22 00 00 	movb   $0x0,0x22e4(%ebx,%esi,8)
f01042a8:	00 
f01042a9:	c6 84 f3 e5 22 00 00 	movb   $0x8f,0x22e5(%ebx,%esi,8)
f01042b0:	8f 
f01042b1:	c1 e8 10             	shr    $0x10,%eax
f01042b4:	66 89 42 06          	mov    %ax,0x6(%edx)
        cprintf("idt[%d]\toff:0x%x\n", i, (idt[i].gd_off_31_16 << 16) + idt[i].gd_off_15_0);
f01042b8:	8d bb e0 22 00 00    	lea    0x22e0(%ebx),%edi
f01042be:	83 ec 04             	sub    $0x4,%esp
f01042c1:	0f b7 84 f3 e6 22 00 	movzwl 0x22e6(%ebx,%esi,8),%eax
f01042c8:	00 
f01042c9:	c1 e0 10             	shl    $0x10,%eax
f01042cc:	0f b7 14 f7          	movzwl (%edi,%esi,8),%edx
f01042d0:	01 d0                	add    %edx,%eax
f01042d2:	50                   	push   %eax
f01042d3:	56                   	push   %esi
f01042d4:	ff 75 94             	pushl  -0x6c(%ebp)
f01042d7:	e8 8a fe ff ff       	call   f0104166 <cprintf>
    for (int i = 0; i < 20; i++) {
f01042dc:	83 c6 01             	add    $0x1,%esi
f01042df:	83 c4 10             	add    $0x10,%esp
f01042e2:	83 fe 13             	cmp    $0x13,%esi
f01042e5:	7f 32                	jg     f0104319 <trap_init+0xc3>
        if (i == T_BRKPT) {
f01042e7:	83 fe 03             	cmp    $0x3,%esi
f01042ea:	75 9c                	jne    f0104288 <trap_init+0x32>
            SETGATE(idt[i], 1, GD_KT, handler[i], 3);
f01042ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f01042ef:	66 89 83 f8 22 00 00 	mov    %ax,0x22f8(%ebx)
f01042f6:	66 c7 83 fa 22 00 00 	movw   $0x8,0x22fa(%ebx)
f01042fd:	08 00 
f01042ff:	c6 83 fc 22 00 00 00 	movb   $0x0,0x22fc(%ebx)
f0104306:	c6 83 fd 22 00 00 ef 	movb   $0xef,0x22fd(%ebx)
f010430d:	c1 e8 10             	shr    $0x10,%eax
f0104310:	66 89 83 fe 22 00 00 	mov    %ax,0x22fe(%ebx)
f0104317:	eb a5                	jmp    f01042be <trap_init+0x68>
    SETGATE(idt[T_SYSCALL], 1, GD_KT, handler48, 3);
f0104319:	c7 c0 e2 48 10 f0    	mov    $0xf01048e2,%eax
f010431f:	66 89 83 60 24 00 00 	mov    %ax,0x2460(%ebx)
f0104326:	66 c7 83 62 24 00 00 	movw   $0x8,0x2462(%ebx)
f010432d:	08 00 
f010432f:	c6 83 64 24 00 00 00 	movb   $0x0,0x2464(%ebx)
f0104336:	c6 83 65 24 00 00 ef 	movb   $0xef,0x2465(%ebx)
f010433d:	c1 e8 10             	shr    $0x10,%eax
f0104340:	66 89 83 66 24 00 00 	mov    %ax,0x2466(%ebx)
    trap_init_percpu();
f0104347:	e8 5b fe ff ff       	call   f01041a7 <trap_init_percpu>
}
f010434c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010434f:	5b                   	pop    %ebx
f0104350:	5e                   	pop    %esi
f0104351:	5f                   	pop    %edi
f0104352:	5d                   	pop    %ebp
f0104353:	c3                   	ret    

f0104354 <print_regs>:
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
    }
}

void
print_regs(struct PushRegs *regs) {
f0104354:	55                   	push   %ebp
f0104355:	89 e5                	mov    %esp,%ebp
f0104357:	56                   	push   %esi
f0104358:	53                   	push   %ebx
f0104359:	e8 e0 be ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010435e:	81 c3 22 9d 08 00    	add    $0x89d22,%ebx
f0104364:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104367:	83 ec 08             	sub    $0x8,%esp
f010436a:	ff 36                	pushl  (%esi)
f010436c:	8d 83 88 97 f7 ff    	lea    -0x86878(%ebx),%eax
f0104372:	50                   	push   %eax
f0104373:	e8 ee fd ff ff       	call   f0104166 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104378:	83 c4 08             	add    $0x8,%esp
f010437b:	ff 76 04             	pushl  0x4(%esi)
f010437e:	8d 83 97 97 f7 ff    	lea    -0x86869(%ebx),%eax
f0104384:	50                   	push   %eax
f0104385:	e8 dc fd ff ff       	call   f0104166 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010438a:	83 c4 08             	add    $0x8,%esp
f010438d:	ff 76 08             	pushl  0x8(%esi)
f0104390:	8d 83 a6 97 f7 ff    	lea    -0x8685a(%ebx),%eax
f0104396:	50                   	push   %eax
f0104397:	e8 ca fd ff ff       	call   f0104166 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010439c:	83 c4 08             	add    $0x8,%esp
f010439f:	ff 76 0c             	pushl  0xc(%esi)
f01043a2:	8d 83 b5 97 f7 ff    	lea    -0x8684b(%ebx),%eax
f01043a8:	50                   	push   %eax
f01043a9:	e8 b8 fd ff ff       	call   f0104166 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01043ae:	83 c4 08             	add    $0x8,%esp
f01043b1:	ff 76 10             	pushl  0x10(%esi)
f01043b4:	8d 83 c4 97 f7 ff    	lea    -0x8683c(%ebx),%eax
f01043ba:	50                   	push   %eax
f01043bb:	e8 a6 fd ff ff       	call   f0104166 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
f01043c0:	83 c4 08             	add    $0x8,%esp
f01043c3:	ff 76 14             	pushl  0x14(%esi)
f01043c6:	8d 83 d3 97 f7 ff    	lea    -0x8682d(%ebx),%eax
f01043cc:	50                   	push   %eax
f01043cd:	e8 94 fd ff ff       	call   f0104166 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01043d2:	83 c4 08             	add    $0x8,%esp
f01043d5:	ff 76 18             	pushl  0x18(%esi)
f01043d8:	8d 83 e2 97 f7 ff    	lea    -0x8681e(%ebx),%eax
f01043de:	50                   	push   %eax
f01043df:	e8 82 fd ff ff       	call   f0104166 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
f01043e4:	83 c4 08             	add    $0x8,%esp
f01043e7:	ff 76 1c             	pushl  0x1c(%esi)
f01043ea:	8d 83 f1 97 f7 ff    	lea    -0x8680f(%ebx),%eax
f01043f0:	50                   	push   %eax
f01043f1:	e8 70 fd ff ff       	call   f0104166 <cprintf>
}
f01043f6:	83 c4 10             	add    $0x10,%esp
f01043f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01043fc:	5b                   	pop    %ebx
f01043fd:	5e                   	pop    %esi
f01043fe:	5d                   	pop    %ebp
f01043ff:	c3                   	ret    

f0104400 <print_trapframe>:
print_trapframe(struct Trapframe *tf) {
f0104400:	55                   	push   %ebp
f0104401:	89 e5                	mov    %esp,%ebp
f0104403:	57                   	push   %edi
f0104404:	56                   	push   %esi
f0104405:	53                   	push   %ebx
f0104406:	83 ec 14             	sub    $0x14,%esp
f0104409:	e8 30 be ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010440e:	81 c3 72 9c 08 00    	add    $0x89c72,%ebx
f0104414:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("TRAP frame at %p\n", tf);
f0104417:	56                   	push   %esi
f0104418:	8d 83 27 99 f7 ff    	lea    -0x866d9(%ebx),%eax
f010441e:	50                   	push   %eax
f010441f:	e8 42 fd ff ff       	call   f0104166 <cprintf>
    print_regs(&tf->tf_regs);
f0104424:	89 34 24             	mov    %esi,(%esp)
f0104427:	e8 28 ff ff ff       	call   f0104354 <print_regs>
    cprintf("  es   0x----%04x\n", tf->tf_es);
f010442c:	83 c4 08             	add    $0x8,%esp
f010442f:	0f b7 46 20          	movzwl 0x20(%esi),%eax
f0104433:	50                   	push   %eax
f0104434:	8d 83 42 98 f7 ff    	lea    -0x867be(%ebx),%eax
f010443a:	50                   	push   %eax
f010443b:	e8 26 fd ff ff       	call   f0104166 <cprintf>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104440:	83 c4 08             	add    $0x8,%esp
f0104443:	0f b7 46 24          	movzwl 0x24(%esi),%eax
f0104447:	50                   	push   %eax
f0104448:	8d 83 55 98 f7 ff    	lea    -0x867ab(%ebx),%eax
f010444e:	50                   	push   %eax
f010444f:	e8 12 fd ff ff       	call   f0104166 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104454:	8b 56 28             	mov    0x28(%esi),%edx
    if (trapno < ARRAY_SIZE(excnames))
f0104457:	83 c4 10             	add    $0x10,%esp
f010445a:	83 fa 13             	cmp    $0x13,%edx
f010445d:	0f 86 e9 00 00 00    	jbe    f010454c <print_trapframe+0x14c>
    return "(unknown trap)";
f0104463:	83 fa 30             	cmp    $0x30,%edx
f0104466:	8d 83 00 98 f7 ff    	lea    -0x86800(%ebx),%eax
f010446c:	8d 8b 0c 98 f7 ff    	lea    -0x867f4(%ebx),%ecx
f0104472:	0f 45 c1             	cmovne %ecx,%eax
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104475:	83 ec 04             	sub    $0x4,%esp
f0104478:	50                   	push   %eax
f0104479:	52                   	push   %edx
f010447a:	8d 83 68 98 f7 ff    	lea    -0x86798(%ebx),%eax
f0104480:	50                   	push   %eax
f0104481:	e8 e0 fc ff ff       	call   f0104166 <cprintf>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104486:	83 c4 10             	add    $0x10,%esp
f0104489:	39 b3 e0 2a 00 00    	cmp    %esi,0x2ae0(%ebx)
f010448f:	0f 84 c3 00 00 00    	je     f0104558 <print_trapframe+0x158>
    cprintf("  err  0x%08x", tf->tf_err);
f0104495:	83 ec 08             	sub    $0x8,%esp
f0104498:	ff 76 2c             	pushl  0x2c(%esi)
f010449b:	8d 83 89 98 f7 ff    	lea    -0x86777(%ebx),%eax
f01044a1:	50                   	push   %eax
f01044a2:	e8 bf fc ff ff       	call   f0104166 <cprintf>
    if (tf->tf_trapno == T_PGFLT)
f01044a7:	83 c4 10             	add    $0x10,%esp
f01044aa:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f01044ae:	0f 85 c9 00 00 00    	jne    f010457d <print_trapframe+0x17d>
                tf->tf_err & 1 ? "protection" : "not-present");
f01044b4:	8b 46 2c             	mov    0x2c(%esi),%eax
        cprintf(" [%s, %s, %s]\n",
f01044b7:	89 c2                	mov    %eax,%edx
f01044b9:	83 e2 01             	and    $0x1,%edx
f01044bc:	8d 8b 1b 98 f7 ff    	lea    -0x867e5(%ebx),%ecx
f01044c2:	8d 93 26 98 f7 ff    	lea    -0x867da(%ebx),%edx
f01044c8:	0f 44 ca             	cmove  %edx,%ecx
f01044cb:	89 c2                	mov    %eax,%edx
f01044cd:	83 e2 02             	and    $0x2,%edx
f01044d0:	8d 93 32 98 f7 ff    	lea    -0x867ce(%ebx),%edx
f01044d6:	8d bb 38 98 f7 ff    	lea    -0x867c8(%ebx),%edi
f01044dc:	0f 44 d7             	cmove  %edi,%edx
f01044df:	83 e0 04             	and    $0x4,%eax
f01044e2:	8d 83 3d 98 f7 ff    	lea    -0x867c3(%ebx),%eax
f01044e8:	8d bb 20 9a f7 ff    	lea    -0x865e0(%ebx),%edi
f01044ee:	0f 44 c7             	cmove  %edi,%eax
f01044f1:	51                   	push   %ecx
f01044f2:	52                   	push   %edx
f01044f3:	50                   	push   %eax
f01044f4:	8d 83 97 98 f7 ff    	lea    -0x86769(%ebx),%eax
f01044fa:	50                   	push   %eax
f01044fb:	e8 66 fc ff ff       	call   f0104166 <cprintf>
f0104500:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104503:	83 ec 08             	sub    $0x8,%esp
f0104506:	ff 76 30             	pushl  0x30(%esi)
f0104509:	8d 83 a6 98 f7 ff    	lea    -0x8675a(%ebx),%eax
f010450f:	50                   	push   %eax
f0104510:	e8 51 fc ff ff       	call   f0104166 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104515:	83 c4 08             	add    $0x8,%esp
f0104518:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010451c:	50                   	push   %eax
f010451d:	8d 83 b5 98 f7 ff    	lea    -0x8674b(%ebx),%eax
f0104523:	50                   	push   %eax
f0104524:	e8 3d fc ff ff       	call   f0104166 <cprintf>
    cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104529:	83 c4 08             	add    $0x8,%esp
f010452c:	ff 76 38             	pushl  0x38(%esi)
f010452f:	8d 83 c8 98 f7 ff    	lea    -0x86738(%ebx),%eax
f0104535:	50                   	push   %eax
f0104536:	e8 2b fc ff ff       	call   f0104166 <cprintf>
    if ((tf->tf_cs & 3) != 0) {
f010453b:	83 c4 10             	add    $0x10,%esp
f010453e:	f6 46 34 03          	testb  $0x3,0x34(%esi)
f0104542:	75 50                	jne    f0104594 <print_trapframe+0x194>
}
f0104544:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104547:	5b                   	pop    %ebx
f0104548:	5e                   	pop    %esi
f0104549:	5f                   	pop    %edi
f010454a:	5d                   	pop    %ebp
f010454b:	c3                   	ret    
        return excnames[trapno];
f010454c:	8b 84 93 00 20 00 00 	mov    0x2000(%ebx,%edx,4),%eax
f0104553:	e9 1d ff ff ff       	jmp    f0104475 <print_trapframe+0x75>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104558:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
f010455c:	0f 85 33 ff ff ff    	jne    f0104495 <print_trapframe+0x95>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104562:	0f 20 d0             	mov    %cr2,%eax
        cprintf("  cr2  0x%08x\n", rcr2());
f0104565:	83 ec 08             	sub    $0x8,%esp
f0104568:	50                   	push   %eax
f0104569:	8d 83 7a 98 f7 ff    	lea    -0x86786(%ebx),%eax
f010456f:	50                   	push   %eax
f0104570:	e8 f1 fb ff ff       	call   f0104166 <cprintf>
f0104575:	83 c4 10             	add    $0x10,%esp
f0104578:	e9 18 ff ff ff       	jmp    f0104495 <print_trapframe+0x95>
        cprintf("\n");
f010457d:	83 ec 0c             	sub    $0xc,%esp
f0104580:	8d 83 65 92 f7 ff    	lea    -0x86d9b(%ebx),%eax
f0104586:	50                   	push   %eax
f0104587:	e8 da fb ff ff       	call   f0104166 <cprintf>
f010458c:	83 c4 10             	add    $0x10,%esp
f010458f:	e9 6f ff ff ff       	jmp    f0104503 <print_trapframe+0x103>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104594:	83 ec 08             	sub    $0x8,%esp
f0104597:	ff 76 3c             	pushl  0x3c(%esi)
f010459a:	8d 83 d7 98 f7 ff    	lea    -0x86729(%ebx),%eax
f01045a0:	50                   	push   %eax
f01045a1:	e8 c0 fb ff ff       	call   f0104166 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01045a6:	83 c4 08             	add    $0x8,%esp
f01045a9:	0f b7 46 40          	movzwl 0x40(%esi),%eax
f01045ad:	50                   	push   %eax
f01045ae:	8d 83 e6 98 f7 ff    	lea    -0x8671a(%ebx),%eax
f01045b4:	50                   	push   %eax
f01045b5:	e8 ac fb ff ff       	call   f0104166 <cprintf>
f01045ba:	83 c4 10             	add    $0x10,%esp
}
f01045bd:	eb 85                	jmp    f0104544 <print_trapframe+0x144>

f01045bf <page_fault_handler>:
    env_run(curenv);
}


void
page_fault_handler(struct Trapframe *tf) {
f01045bf:	55                   	push   %ebp
f01045c0:	89 e5                	mov    %esp,%ebp
f01045c2:	57                   	push   %edi
f01045c3:	56                   	push   %esi
f01045c4:	53                   	push   %ebx
f01045c5:	83 ec 0c             	sub    $0xc,%esp
f01045c8:	e8 71 bc ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01045cd:	81 c3 b3 9a 08 00    	add    $0x89ab3,%ebx
f01045d3:	8b 7d 08             	mov    0x8(%ebp),%edi
f01045d6:	0f 20 d0             	mov    %cr2,%eax

    // We've already handled kernel-mode exceptions, so if we get here,
    // the page fault happened in user mode.

    // Destroy the environment that caused the fault.
    cprintf("[%08x] user fault va %08x ip %08x\n",
f01045d9:	ff 77 30             	pushl  0x30(%edi)
f01045dc:	50                   	push   %eax
f01045dd:	c7 c6 4c 03 19 f0    	mov    $0xf019034c,%esi
f01045e3:	8b 06                	mov    (%esi),%eax
f01045e5:	ff 70 48             	pushl  0x48(%eax)
f01045e8:	8d 83 6c 9b f7 ff    	lea    -0x86494(%ebx),%eax
f01045ee:	50                   	push   %eax
f01045ef:	e8 72 fb ff ff       	call   f0104166 <cprintf>
            curenv->env_id, fault_va, tf->tf_eip);
    print_trapframe(tf);
f01045f4:	89 3c 24             	mov    %edi,(%esp)
f01045f7:	e8 04 fe ff ff       	call   f0104400 <print_trapframe>
    env_destroy(curenv);
f01045fc:	83 c4 04             	add    $0x4,%esp
f01045ff:	ff 36                	pushl  (%esi)
f0104601:	e8 d1 f9 ff ff       	call   f0103fd7 <env_destroy>
}
f0104606:	83 c4 10             	add    $0x10,%esp
f0104609:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010460c:	5b                   	pop    %ebx
f010460d:	5e                   	pop    %esi
f010460e:	5f                   	pop    %edi
f010460f:	5d                   	pop    %ebp
f0104610:	c3                   	ret    

f0104611 <trap>:
trap(struct Trapframe *tf) {
f0104611:	55                   	push   %ebp
f0104612:	89 e5                	mov    %esp,%ebp
f0104614:	57                   	push   %edi
f0104615:	56                   	push   %esi
f0104616:	53                   	push   %ebx
f0104617:	83 ec 0c             	sub    $0xc,%esp
f010461a:	e8 1f bc ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f010461f:	81 c3 61 9a 08 00    	add    $0x89a61,%ebx
f0104625:	8b 75 08             	mov    0x8(%ebp),%esi
    asm volatile("cld":: : "cc");
f0104628:	fc                   	cld    
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104629:	9c                   	pushf  
f010462a:	58                   	pop    %eax
    assert(!(read_eflags() & FL_IF));
f010462b:	f6 c4 02             	test   $0x2,%ah
f010462e:	74 1f                	je     f010464f <trap+0x3e>
f0104630:	8d 83 f9 98 f7 ff    	lea    -0x86707(%ebx),%eax
f0104636:	50                   	push   %eax
f0104637:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f010463d:	50                   	push   %eax
f010463e:	68 f5 00 00 00       	push   $0xf5
f0104643:	8d 83 12 99 f7 ff    	lea    -0x866ee(%ebx),%eax
f0104649:	50                   	push   %eax
f010464a:	e8 39 bb ff ff       	call   f0100188 <_panic>
    cprintf("Incoming TRAP frame at %p\n", tf);
f010464f:	83 ec 08             	sub    $0x8,%esp
f0104652:	56                   	push   %esi
f0104653:	8d 83 1e 99 f7 ff    	lea    -0x866e2(%ebx),%eax
f0104659:	50                   	push   %eax
f010465a:	e8 07 fb ff ff       	call   f0104166 <cprintf>
    if ((tf->tf_cs & 3) == 3) {
f010465f:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104663:	83 e0 03             	and    $0x3,%eax
f0104666:	83 c4 10             	add    $0x10,%esp
f0104669:	66 83 f8 03          	cmp    $0x3,%ax
f010466d:	74 1e                	je     f010468d <trap+0x7c>
    last_tf = tf;
f010466f:	89 b3 e0 2a 00 00    	mov    %esi,0x2ae0(%ebx)
    switch (tf->tf_trapno) {
f0104675:	83 7e 28 30          	cmpl   $0x30,0x28(%esi)
f0104679:	0f 87 c7 01 00 00    	ja     f0104846 <.L36>
f010467f:	8b 46 28             	mov    0x28(%esi),%eax
f0104682:	89 da                	mov    %ebx,%edx
f0104684:	03 94 83 40 9c f7 ff 	add    -0x863c0(%ebx,%eax,4),%edx
f010468b:	ff e2                	jmp    *%edx
        cprintf("Trapped from user mode.\n");
f010468d:	83 ec 0c             	sub    $0xc,%esp
f0104690:	8d 83 39 99 f7 ff    	lea    -0x866c7(%ebx),%eax
f0104696:	50                   	push   %eax
f0104697:	e8 ca fa ff ff       	call   f0104166 <cprintf>
        assert(curenv);
f010469c:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f01046a2:	8b 00                	mov    (%eax),%eax
f01046a4:	83 c4 10             	add    $0x10,%esp
f01046a7:	85 c0                	test   %eax,%eax
f01046a9:	74 13                	je     f01046be <trap+0xad>
        curenv->env_tf = *tf;
f01046ab:	b9 11 00 00 00       	mov    $0x11,%ecx
f01046b0:	89 c7                	mov    %eax,%edi
f01046b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        tf = &curenv->env_tf;
f01046b4:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f01046ba:	8b 30                	mov    (%eax),%esi
f01046bc:	eb b1                	jmp    f010466f <trap+0x5e>
        assert(curenv);
f01046be:	8d 83 52 99 f7 ff    	lea    -0x866ae(%ebx),%eax
f01046c4:	50                   	push   %eax
f01046c5:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f01046cb:	50                   	push   %eax
f01046cc:	68 fd 00 00 00       	push   $0xfd
f01046d1:	8d 83 12 99 f7 ff    	lea    -0x866ee(%ebx),%eax
f01046d7:	50                   	push   %eax
f01046d8:	e8 ab ba ff ff       	call   f0100188 <_panic>

f01046dd <.L37>:
            cprintf("Divide Error fault\n");
f01046dd:	83 ec 0c             	sub    $0xc,%esp
f01046e0:	8d 83 59 99 f7 ff    	lea    -0x866a7(%ebx),%eax
f01046e6:	50                   	push   %eax
f01046e7:	e8 7a fa ff ff       	call   f0104166 <cprintf>
f01046ec:	83 c4 10             	add    $0x10,%esp

f01046ef <.L40>:
    print_trapframe(tf);
f01046ef:	83 ec 0c             	sub    $0xc,%esp
f01046f2:	56                   	push   %esi
f01046f3:	e8 08 fd ff ff       	call   f0104400 <print_trapframe>
    if (tf->tf_cs == GD_KT)
f01046f8:	83 c4 10             	add    $0x10,%esp
f01046fb:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104700:	0f 84 57 01 00 00    	je     f010485d <.L36+0x17>
        env_destroy(curenv);
f0104706:	83 ec 0c             	sub    $0xc,%esp
f0104709:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f010470f:	ff 30                	pushl  (%eax)
f0104711:	e8 c1 f8 ff ff       	call   f0103fd7 <env_destroy>
f0104716:	83 c4 10             	add    $0x10,%esp
    assert(curenv && curenv->env_status == ENV_RUNNING);
f0104719:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f010471f:	8b 00                	mov    (%eax),%eax
f0104721:	85 c0                	test   %eax,%eax
f0104723:	74 0a                	je     f010472f <.L40+0x40>
f0104725:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104729:	0f 84 49 01 00 00    	je     f0104878 <.L36+0x32>
f010472f:	8d 83 14 9c f7 ff    	lea    -0x863ec(%ebx),%eax
f0104735:	50                   	push   %eax
f0104736:	8d 83 3d 8f f7 ff    	lea    -0x870c3(%ebx),%eax
f010473c:	50                   	push   %eax
f010473d:	68 0f 01 00 00       	push   $0x10f
f0104742:	8d 83 12 99 f7 ff    	lea    -0x866ee(%ebx),%eax
f0104748:	50                   	push   %eax
f0104749:	e8 3a ba ff ff       	call   f0100188 <_panic>

f010474e <.L39>:
            cprintf("Debug exceptions. Hints: An exception handler can examine the debug registers to determine which condition caused the exception.\n");
f010474e:	83 ec 0c             	sub    $0xc,%esp
f0104751:	8d 83 90 9b f7 ff    	lea    -0x86470(%ebx),%eax
f0104757:	50                   	push   %eax
f0104758:	e8 09 fa ff ff       	call   f0104166 <cprintf>
f010475d:	83 c4 10             	add    $0x10,%esp
f0104760:	eb 8d                	jmp    f01046ef <.L40>

f0104762 <.L41>:
            cprintf("Breakpoint INT 3 trap\n");
f0104762:	83 ec 0c             	sub    $0xc,%esp
f0104765:	8d 83 6d 99 f7 ff    	lea    -0x86693(%ebx),%eax
f010476b:	50                   	push   %eax
f010476c:	e8 f5 f9 ff ff       	call   f0104166 <cprintf>
            monitor(tf);
f0104771:	89 34 24             	mov    %esi,(%esp)
f0104774:	e8 27 c2 ff ff       	call   f01009a0 <monitor>
f0104779:	83 c4 10             	add    $0x10,%esp
f010477c:	e9 6e ff ff ff       	jmp    f01046ef <.L40>

f0104781 <.L42>:
            cprintf("Overflow trap\n");
f0104781:	83 ec 0c             	sub    $0xc,%esp
f0104784:	8d 83 84 99 f7 ff    	lea    -0x8667c(%ebx),%eax
f010478a:	50                   	push   %eax
f010478b:	e8 d6 f9 ff ff       	call   f0104166 <cprintf>
f0104790:	83 c4 10             	add    $0x10,%esp
f0104793:	e9 57 ff ff ff       	jmp    f01046ef <.L40>

f0104798 <.L43>:
            cprintf("Bounds Check fault\n");
f0104798:	83 ec 0c             	sub    $0xc,%esp
f010479b:	8d 83 93 99 f7 ff    	lea    -0x8666d(%ebx),%eax
f01047a1:	50                   	push   %eax
f01047a2:	e8 bf f9 ff ff       	call   f0104166 <cprintf>
f01047a7:	83 c4 10             	add    $0x10,%esp
f01047aa:	e9 40 ff ff ff       	jmp    f01046ef <.L40>

f01047af <.L44>:
            cprintf("Invalid Opcode fault\n");
f01047af:	83 ec 0c             	sub    $0xc,%esp
f01047b2:	8d 83 a7 99 f7 ff    	lea    -0x86659(%ebx),%eax
f01047b8:	50                   	push   %eax
f01047b9:	e8 a8 f9 ff ff       	call   f0104166 <cprintf>
f01047be:	83 c4 10             	add    $0x10,%esp
f01047c1:	e9 29 ff ff ff       	jmp    f01046ef <.L40>

f01047c6 <.L45>:
            cprintf("Double Fault\n");
f01047c6:	83 ec 0c             	sub    $0xc,%esp
f01047c9:	8d 83 bd 99 f7 ff    	lea    -0x86643(%ebx),%eax
f01047cf:	50                   	push   %eax
f01047d0:	e8 91 f9 ff ff       	call   f0104166 <cprintf>
f01047d5:	83 c4 10             	add    $0x10,%esp
f01047d8:	e9 12 ff ff ff       	jmp    f01046ef <.L40>

f01047dd <.L46>:
            cprintf("General Protection Exception\n");
f01047dd:	83 ec 0c             	sub    $0xc,%esp
f01047e0:	8d 83 cb 99 f7 ff    	lea    -0x86635(%ebx),%eax
f01047e6:	50                   	push   %eax
f01047e7:	e8 7a f9 ff ff       	call   f0104166 <cprintf>
f01047ec:	83 c4 10             	add    $0x10,%esp
f01047ef:	e9 fb fe ff ff       	jmp    f01046ef <.L40>

f01047f4 <.L47>:
            cprintf("Page Fault\n");
f01047f4:	83 ec 0c             	sub    $0xc,%esp
f01047f7:	8d 83 e9 99 f7 ff    	lea    -0x86617(%ebx),%eax
f01047fd:	50                   	push   %eax
f01047fe:	e8 63 f9 ff ff       	call   f0104166 <cprintf>
            page_fault_handler(tf);
f0104803:	89 34 24             	mov    %esi,(%esp)
f0104806:	e8 b4 fd ff ff       	call   f01045bf <page_fault_handler>
f010480b:	83 c4 10             	add    $0x10,%esp
f010480e:	e9 dc fe ff ff       	jmp    f01046ef <.L40>

f0104813 <.L48>:
            cprintf("T_SYSCALL\n");
f0104813:	83 ec 0c             	sub    $0xc,%esp
f0104816:	8d 83 f5 99 f7 ff    	lea    -0x8660b(%ebx),%eax
f010481c:	50                   	push   %eax
f010481d:	e8 44 f9 ff ff       	call   f0104166 <cprintf>
            tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f0104822:	83 c4 08             	add    $0x8,%esp
f0104825:	ff 76 04             	pushl  0x4(%esi)
f0104828:	ff 36                	pushl  (%esi)
f010482a:	ff 76 10             	pushl  0x10(%esi)
f010482d:	ff 76 18             	pushl  0x18(%esi)
f0104830:	ff 76 14             	pushl  0x14(%esi)
f0104833:	ff 76 1c             	pushl  0x1c(%esi)
f0104836:	e8 bf 00 00 00       	call   f01048fa <syscall>
f010483b:	89 46 1c             	mov    %eax,0x1c(%esi)
f010483e:	83 c4 20             	add    $0x20,%esp
f0104841:	e9 d3 fe ff ff       	jmp    f0104719 <.L40+0x2a>

f0104846 <.L36>:
            cprintf("Unknown Trap\n");
f0104846:	83 ec 0c             	sub    $0xc,%esp
f0104849:	8d 83 00 9a f7 ff    	lea    -0x86600(%ebx),%eax
f010484f:	50                   	push   %eax
f0104850:	e8 11 f9 ff ff       	call   f0104166 <cprintf>
f0104855:	83 c4 10             	add    $0x10,%esp
f0104858:	e9 92 fe ff ff       	jmp    f01046ef <.L40>
        panic("unhandled trap in kernel");
f010485d:	83 ec 04             	sub    $0x4,%esp
f0104860:	8d 83 0e 9a f7 ff    	lea    -0x865f2(%ebx),%eax
f0104866:	50                   	push   %eax
f0104867:	68 e5 00 00 00       	push   $0xe5
f010486c:	8d 83 12 99 f7 ff    	lea    -0x866ee(%ebx),%eax
f0104872:	50                   	push   %eax
f0104873:	e8 10 b9 ff ff       	call   f0100188 <_panic>
    env_run(curenv);
f0104878:	83 ec 0c             	sub    $0xc,%esp
f010487b:	50                   	push   %eax
f010487c:	e8 c4 f7 ff ff       	call   f0104045 <env_run>
f0104881:	90                   	nop

f0104882 <handler0>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
//which need error_code?
TRAPHANDLER_NOEC(handler0, T_DIVIDE);
f0104882:	6a 00                	push   $0x0
f0104884:	6a 00                	push   $0x0
f0104886:	eb 60                	jmp    f01048e8 <_alltraps>

f0104888 <handler1>:
TRAPHANDLER_NOEC(handler1, T_DEBUG);
f0104888:	6a 00                	push   $0x0
f010488a:	6a 01                	push   $0x1
f010488c:	eb 5a                	jmp    f01048e8 <_alltraps>

f010488e <handler2>:
TRAPHANDLER_NOEC(handler2, T_NMI);
f010488e:	6a 00                	push   $0x0
f0104890:	6a 02                	push   $0x2
f0104892:	eb 54                	jmp    f01048e8 <_alltraps>

f0104894 <handler3>:
TRAPHANDLER_NOEC(handler3, T_BRKPT);
f0104894:	6a 00                	push   $0x0
f0104896:	6a 03                	push   $0x3
f0104898:	eb 4e                	jmp    f01048e8 <_alltraps>

f010489a <handler4>:
TRAPHANDLER_NOEC(handler4, T_OFLOW);
f010489a:	6a 00                	push   $0x0
f010489c:	6a 04                	push   $0x4
f010489e:	eb 48                	jmp    f01048e8 <_alltraps>

f01048a0 <handler5>:
TRAPHANDLER_NOEC(handler5, T_BOUND);
f01048a0:	6a 00                	push   $0x0
f01048a2:	6a 05                	push   $0x5
f01048a4:	eb 42                	jmp    f01048e8 <_alltraps>

f01048a6 <handler6>:
TRAPHANDLER_NOEC(handler6, T_ILLOP);
f01048a6:	6a 00                	push   $0x0
f01048a8:	6a 06                	push   $0x6
f01048aa:	eb 3c                	jmp    f01048e8 <_alltraps>

f01048ac <handler7>:
TRAPHANDLER_NOEC(handler7, T_DEVICE);
f01048ac:	6a 00                	push   $0x0
f01048ae:	6a 07                	push   $0x7
f01048b0:	eb 36                	jmp    f01048e8 <_alltraps>

f01048b2 <handler8>:
TRAPHANDLER(handler8, T_DBLFLT);
f01048b2:	6a 08                	push   $0x8
f01048b4:	eb 32                	jmp    f01048e8 <_alltraps>

f01048b6 <handler10>:
//TRAPHANDLER_NOEC(handler9, T_COPROC);
TRAPHANDLER(handler10, T_TSS);
f01048b6:	6a 0a                	push   $0xa
f01048b8:	eb 2e                	jmp    f01048e8 <_alltraps>

f01048ba <handler11>:
TRAPHANDLER(handler11, T_SEGNP);
f01048ba:	6a 0b                	push   $0xb
f01048bc:	eb 2a                	jmp    f01048e8 <_alltraps>

f01048be <handler12>:
TRAPHANDLER(handler12, T_STACK);
f01048be:	6a 0c                	push   $0xc
f01048c0:	eb 26                	jmp    f01048e8 <_alltraps>

f01048c2 <handler13>:
TRAPHANDLER(handler13, T_GPFLT);
f01048c2:	6a 0d                	push   $0xd
f01048c4:	eb 22                	jmp    f01048e8 <_alltraps>

f01048c6 <handler14>:
TRAPHANDLER(handler14, T_PGFLT);
f01048c6:	6a 0e                	push   $0xe
f01048c8:	eb 1e                	jmp    f01048e8 <_alltraps>

f01048ca <handler16>:
//TRAPHANDLER_NOEC(handler15, T_RES);
TRAPHANDLER_NOEC(handler16, T_FPERR);
f01048ca:	6a 00                	push   $0x0
f01048cc:	6a 10                	push   $0x10
f01048ce:	eb 18                	jmp    f01048e8 <_alltraps>

f01048d0 <handler17>:
TRAPHANDLER_NOEC(handler17, T_ALIGN);
f01048d0:	6a 00                	push   $0x0
f01048d2:	6a 11                	push   $0x11
f01048d4:	eb 12                	jmp    f01048e8 <_alltraps>

f01048d6 <handler18>:
TRAPHANDLER_NOEC(handler18, T_MCHK);
f01048d6:	6a 00                	push   $0x0
f01048d8:	6a 12                	push   $0x12
f01048da:	eb 0c                	jmp    f01048e8 <_alltraps>

f01048dc <handler19>:
TRAPHANDLER_NOEC(handler19, T_SIMDERR);
f01048dc:	6a 00                	push   $0x0
f01048de:	6a 13                	push   $0x13
f01048e0:	eb 06                	jmp    f01048e8 <_alltraps>

f01048e2 <handler48>:

TRAPHANDLER_NOEC(handler48, T_SYSCALL);
f01048e2:	6a 00                	push   $0x0
f01048e4:	6a 30                	push   $0x30
f01048e6:	eb 00                	jmp    f01048e8 <_alltraps>

f01048e8 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
    //i stupid here
    pushl %ds
f01048e8:	1e                   	push   %ds
    pushl %es
f01048e9:	06                   	push   %es
    // forget above
    pushal
f01048ea:	60                   	pusha  
    movl $GD_KD, %eax
f01048eb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
f01048f0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
f01048f2:	8e c0                	mov    %eax,%es
    pushl %esp
f01048f4:	54                   	push   %esp
f01048f5:	e8 17 fd ff ff       	call   f0104611 <trap>

f01048fa <syscall>:
    return 0;
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5) {
f01048fa:	55                   	push   %ebp
f01048fb:	89 e5                	mov    %esp,%ebp
f01048fd:	53                   	push   %ebx
f01048fe:	83 ec 14             	sub    $0x14,%esp
f0104901:	e8 38 b9 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104906:	81 c3 7a 97 08 00    	add    $0x8977a,%ebx
f010490c:	8b 45 08             	mov    0x8(%ebp),%eax
    // Return any appropriate return value.
    // LAB 3: Your code here.

//	panic("syscall not implemented");

    switch (syscallno) {
f010490f:	83 f8 01             	cmp    $0x1,%eax
f0104912:	74 4d                	je     f0104961 <syscall+0x67>
f0104914:	83 f8 01             	cmp    $0x1,%eax
f0104917:	72 11                	jb     f010492a <syscall+0x30>
f0104919:	83 f8 02             	cmp    $0x2,%eax
f010491c:	74 4a                	je     f0104968 <syscall+0x6e>
f010491e:	83 f8 03             	cmp    $0x3,%eax
f0104921:	74 52                	je     f0104975 <syscall+0x7b>
        case SYS_getenvid:
            return sys_getenvid();
        case SYS_env_destroy:
            return sys_env_destroy(a1);
        default:
            return -E_INVAL;
f0104923:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104928:	eb 32                	jmp    f010495c <syscall+0x62>
    user_mem_assert(curenv, s, len, PTE_U | PTE_P);
f010492a:	6a 05                	push   $0x5
f010492c:	ff 75 10             	pushl  0x10(%ebp)
f010492f:	ff 75 0c             	pushl  0xc(%ebp)
f0104932:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f0104938:	ff 30                	pushl  (%eax)
f010493a:	e8 a4 ee ff ff       	call   f01037e3 <user_mem_assert>
    cprintf("%.*s", len, s);
f010493f:	83 c4 0c             	add    $0xc,%esp
f0104942:	ff 75 0c             	pushl  0xc(%ebp)
f0104945:	ff 75 10             	pushl  0x10(%ebp)
f0104948:	8d 83 04 9d f7 ff    	lea    -0x862fc(%ebx),%eax
f010494e:	50                   	push   %eax
f010494f:	e8 12 f8 ff ff       	call   f0104166 <cprintf>
f0104954:	83 c4 10             	add    $0x10,%esp
            return 0;
f0104957:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
f010495c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010495f:	c9                   	leave  
f0104960:	c3                   	ret    
    return cons_getc();
f0104961:	e8 d3 bc ff ff       	call   f0100639 <cons_getc>
            return sys_cgetc();
f0104966:	eb f4                	jmp    f010495c <syscall+0x62>
    return curenv->env_id;
f0104968:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f010496e:	8b 00                	mov    (%eax),%eax
f0104970:	8b 40 48             	mov    0x48(%eax),%eax
            return sys_getenvid();
f0104973:	eb e7                	jmp    f010495c <syscall+0x62>
    if ((r = envid2env(envid, &e, 1)) < 0)
f0104975:	83 ec 04             	sub    $0x4,%esp
f0104978:	6a 01                	push   $0x1
f010497a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010497d:	50                   	push   %eax
f010497e:	ff 75 0c             	pushl  0xc(%ebp)
f0104981:	e8 37 ef ff ff       	call   f01038bd <envid2env>
f0104986:	83 c4 10             	add    $0x10,%esp
f0104989:	85 c0                	test   %eax,%eax
f010498b:	78 cf                	js     f010495c <syscall+0x62>
    if (e == curenv)
f010498d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104990:	c7 c0 4c 03 19 f0    	mov    $0xf019034c,%eax
f0104996:	8b 00                	mov    (%eax),%eax
f0104998:	39 c2                	cmp    %eax,%edx
f010499a:	74 2d                	je     f01049c9 <syscall+0xcf>
        cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f010499c:	83 ec 04             	sub    $0x4,%esp
f010499f:	ff 72 48             	pushl  0x48(%edx)
f01049a2:	ff 70 48             	pushl  0x48(%eax)
f01049a5:	8d 83 24 9d f7 ff    	lea    -0x862dc(%ebx),%eax
f01049ab:	50                   	push   %eax
f01049ac:	e8 b5 f7 ff ff       	call   f0104166 <cprintf>
f01049b1:	83 c4 10             	add    $0x10,%esp
    env_destroy(e);
f01049b4:	83 ec 0c             	sub    $0xc,%esp
f01049b7:	ff 75 f4             	pushl  -0xc(%ebp)
f01049ba:	e8 18 f6 ff ff       	call   f0103fd7 <env_destroy>
f01049bf:	83 c4 10             	add    $0x10,%esp
    return 0;
f01049c2:	b8 00 00 00 00       	mov    $0x0,%eax
            return sys_env_destroy(a1);
f01049c7:	eb 93                	jmp    f010495c <syscall+0x62>
        cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01049c9:	83 ec 08             	sub    $0x8,%esp
f01049cc:	ff 70 48             	pushl  0x48(%eax)
f01049cf:	8d 83 09 9d f7 ff    	lea    -0x862f7(%ebx),%eax
f01049d5:	50                   	push   %eax
f01049d6:	e8 8b f7 ff ff       	call   f0104166 <cprintf>
f01049db:	83 c4 10             	add    $0x10,%esp
f01049de:	eb d4                	jmp    f01049b4 <syscall+0xba>

f01049e0 <stab_binsearch>:
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr) {
f01049e0:	55                   	push   %ebp
f01049e1:	89 e5                	mov    %esp,%ebp
f01049e3:	57                   	push   %edi
f01049e4:	56                   	push   %esi
f01049e5:	53                   	push   %ebx
f01049e6:	83 ec 14             	sub    $0x14,%esp
f01049e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01049ec:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01049ef:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01049f2:	8b 7d 08             	mov    0x8(%ebp),%edi
    int l = *region_left, r = *region_right, any_matches = 0;
f01049f5:	8b 32                	mov    (%edx),%esi
f01049f7:	8b 01                	mov    (%ecx),%eax
f01049f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01049fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    while (l <= r) {
f0104a03:	eb 2f                	jmp    f0104a34 <stab_binsearch+0x54>
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
f0104a05:	83 e8 01             	sub    $0x1,%eax
        while (m >= l && stabs[m].n_type != type)
f0104a08:	39 c6                	cmp    %eax,%esi
f0104a0a:	7f 49                	jg     f0104a55 <stab_binsearch+0x75>
f0104a0c:	0f b6 0a             	movzbl (%edx),%ecx
f0104a0f:	83 ea 0c             	sub    $0xc,%edx
f0104a12:	39 f9                	cmp    %edi,%ecx
f0104a14:	75 ef                	jne    f0104a05 <stab_binsearch+0x25>
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
f0104a16:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104a19:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104a1c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104a20:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104a23:	73 35                	jae    f0104a5a <stab_binsearch+0x7a>
            *region_left = m;
f0104a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a28:	89 06                	mov    %eax,(%esi)
            l = true_m + 1;
f0104a2a:	8d 73 01             	lea    0x1(%ebx),%esi
        any_matches = 1;
f0104a2d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while (l <= r) {
f0104a34:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104a37:	7f 4e                	jg     f0104a87 <stab_binsearch+0xa7>
        int true_m = (l + r) / 2, m = true_m;
f0104a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104a3c:	01 f0                	add    %esi,%eax
f0104a3e:	89 c3                	mov    %eax,%ebx
f0104a40:	c1 eb 1f             	shr    $0x1f,%ebx
f0104a43:	01 c3                	add    %eax,%ebx
f0104a45:	d1 fb                	sar    %ebx
f0104a47:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104a4a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104a4d:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104a51:	89 d8                	mov    %ebx,%eax
        while (m >= l && stabs[m].n_type != type)
f0104a53:	eb b3                	jmp    f0104a08 <stab_binsearch+0x28>
            l = true_m + 1;
f0104a55:	8d 73 01             	lea    0x1(%ebx),%esi
            continue;
f0104a58:	eb da                	jmp    f0104a34 <stab_binsearch+0x54>
        } else if (stabs[m].n_value > addr) {
f0104a5a:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104a5d:	76 14                	jbe    f0104a73 <stab_binsearch+0x93>
            *region_right = m - 1;
f0104a5f:	83 e8 01             	sub    $0x1,%eax
f0104a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104a65:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104a68:	89 03                	mov    %eax,(%ebx)
        any_matches = 1;
f0104a6a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104a71:	eb c1                	jmp    f0104a34 <stab_binsearch+0x54>
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
f0104a73:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a76:	89 06                	mov    %eax,(%esi)
            l = m;
            addr++;
f0104a78:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104a7c:	89 c6                	mov    %eax,%esi
        any_matches = 1;
f0104a7e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104a85:	eb ad                	jmp    f0104a34 <stab_binsearch+0x54>
        }
    }

    if (!any_matches)
f0104a87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104a8b:	74 16                	je     f0104aa3 <stab_binsearch+0xc3>
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
f0104a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a90:	8b 00                	mov    (%eax),%eax
             l > *region_left && stabs[l].n_type != type;
f0104a92:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a95:	8b 0e                	mov    (%esi),%ecx
f0104a97:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104a9a:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104a9d:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
        for (l = *region_right;
f0104aa1:	eb 12                	jmp    f0104ab5 <stab_binsearch+0xd5>
        *region_right = *region_left - 1;
f0104aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104aa6:	8b 00                	mov    (%eax),%eax
f0104aa8:	83 e8 01             	sub    $0x1,%eax
f0104aab:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104aae:	89 07                	mov    %eax,(%edi)
f0104ab0:	eb 16                	jmp    f0104ac8 <stab_binsearch+0xe8>
             l--)
f0104ab2:	83 e8 01             	sub    $0x1,%eax
        for (l = *region_right;
f0104ab5:	39 c1                	cmp    %eax,%ecx
f0104ab7:	7d 0a                	jge    f0104ac3 <stab_binsearch+0xe3>
             l > *region_left && stabs[l].n_type != type;
f0104ab9:	0f b6 1a             	movzbl (%edx),%ebx
f0104abc:	83 ea 0c             	sub    $0xc,%edx
f0104abf:	39 fb                	cmp    %edi,%ebx
f0104ac1:	75 ef                	jne    f0104ab2 <stab_binsearch+0xd2>
            /* do nothing */;
        *region_left = l;
f0104ac3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ac6:	89 07                	mov    %eax,(%edi)
    }
}
f0104ac8:	83 c4 14             	add    $0x14,%esp
f0104acb:	5b                   	pop    %ebx
f0104acc:	5e                   	pop    %esi
f0104acd:	5f                   	pop    %edi
f0104ace:	5d                   	pop    %ebp
f0104acf:	c3                   	ret    

f0104ad0 <debuginfo_eip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info) {
f0104ad0:	55                   	push   %ebp
f0104ad1:	89 e5                	mov    %esp,%ebp
f0104ad3:	57                   	push   %edi
f0104ad4:	56                   	push   %esi
f0104ad5:	53                   	push   %ebx
f0104ad6:	83 ec 3c             	sub    $0x3c,%esp
f0104ad9:	e8 60 b7 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104ade:	81 c3 a2 95 08 00    	add    $0x895a2,%ebx
f0104ae4:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104ae7:	8b 75 0c             	mov    0xc(%ebp),%esi
    const struct Stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->eip_file = "<unknown>";
f0104aea:	8d 83 3c 9d f7 ff    	lea    -0x862c4(%ebx),%eax
f0104af0:	89 06                	mov    %eax,(%esi)
    info->eip_line = 0;
f0104af2:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    info->eip_fn_name = "<unknown>";
f0104af9:	89 46 08             	mov    %eax,0x8(%esi)
    info->eip_fn_namelen = 9;
f0104afc:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
    info->eip_fn_addr = addr;
f0104b03:	89 7e 10             	mov    %edi,0x10(%esi)
    info->eip_fn_narg = 0;
f0104b06:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

    // Find the relevant set of stabs
    if (addr >= ULIM) {
f0104b0d:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104b13:	0f 86 41 01 00 00    	jbe    f0104c5a <debuginfo_eip+0x18a>
        // Can't search for user-level addresses yet!
        panic("User address");
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104b19:	c7 c0 91 11 11 f0    	mov    $0xf0111191,%eax
f0104b1f:	39 83 fc ff ff ff    	cmp    %eax,-0x4(%ebx)
f0104b25:	0f 86 0e 02 00 00    	jbe    f0104d39 <debuginfo_eip+0x269>
f0104b2b:	c7 c0 ff 3c 11 f0    	mov    $0xf0113cff,%eax
f0104b31:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0104b35:	0f 85 05 02 00 00    	jne    f0104d40 <debuginfo_eip+0x270>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
f0104b3b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    rfile = (stab_end - stabs) - 1;
f0104b42:	c7 c0 d4 7f 10 f0    	mov    $0xf0107fd4,%eax
f0104b48:	c7 c2 90 11 11 f0    	mov    $0xf0111190,%edx
f0104b4e:	29 c2                	sub    %eax,%edx
f0104b50:	c1 fa 02             	sar    $0x2,%edx
f0104b53:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0104b59:	83 ea 01             	sub    $0x1,%edx
f0104b5c:	89 55 e0             	mov    %edx,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104b5f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0104b62:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104b65:	83 ec 08             	sub    $0x8,%esp
f0104b68:	57                   	push   %edi
f0104b69:	6a 64                	push   $0x64
f0104b6b:	e8 70 fe ff ff       	call   f01049e0 <stab_binsearch>
    if (lfile == 0)
f0104b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b73:	83 c4 10             	add    $0x10,%esp
f0104b76:	85 c0                	test   %eax,%eax
f0104b78:	0f 84 c9 01 00 00    	je     f0104d47 <debuginfo_eip+0x277>
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
f0104b7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    rfun = rfile;
f0104b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b84:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104b87:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0104b8a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104b8d:	83 ec 08             	sub    $0x8,%esp
f0104b90:	57                   	push   %edi
f0104b91:	6a 24                	push   $0x24
f0104b93:	c7 c0 d4 7f 10 f0    	mov    $0xf0107fd4,%eax
f0104b99:	e8 42 fe ff ff       	call   f01049e0 <stab_binsearch>

    if (lfun <= rfun) {
f0104b9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104ba1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104ba4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0104ba7:	83 c4 10             	add    $0x10,%esp
f0104baa:	39 c8                	cmp    %ecx,%eax
f0104bac:	0f 8f c0 00 00 00    	jg     f0104c72 <debuginfo_eip+0x1a2>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104bb2:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104bb5:	c7 c1 d4 7f 10 f0    	mov    $0xf0107fd4,%ecx
f0104bbb:	8d 0c 91             	lea    (%ecx,%edx,4),%ecx
f0104bbe:	8b 11                	mov    (%ecx),%edx
f0104bc0:	89 55 c0             	mov    %edx,-0x40(%ebp)
f0104bc3:	c7 c2 ff 3c 11 f0    	mov    $0xf0113cff,%edx
f0104bc9:	81 ea 91 11 11 f0    	sub    $0xf0111191,%edx
f0104bcf:	39 55 c0             	cmp    %edx,-0x40(%ebp)
f0104bd2:	73 0c                	jae    f0104be0 <debuginfo_eip+0x110>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104bd4:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0104bd7:	81 c2 91 11 11 f0    	add    $0xf0111191,%edx
f0104bdd:	89 56 08             	mov    %edx,0x8(%esi)
        info->eip_fn_addr = stabs[lfun].n_value;
f0104be0:	8b 51 08             	mov    0x8(%ecx),%edx
f0104be3:	89 56 10             	mov    %edx,0x10(%esi)
        addr -= info->eip_fn_addr;
f0104be6:	29 d7                	sub    %edx,%edi
        // Search within the function definition for the line number.
        lline = lfun;
f0104be8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
f0104beb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0104bee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        info->eip_fn_addr = addr;
        lline = lfile;
        rline = rfile;
    }
    // Ignore stuff after the colon.
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104bf1:	83 ec 08             	sub    $0x8,%esp
f0104bf4:	6a 3a                	push   $0x3a
f0104bf6:	ff 76 08             	pushl  0x8(%esi)
f0104bf9:	e8 fe 09 00 00       	call   f01055fc <strfind>
f0104bfe:	2b 46 08             	sub    0x8(%esi),%eax
f0104c01:	89 46 0c             	mov    %eax,0xc(%esi)
    // Hint:
    //	There's a particular stabs type used for line numbers.
    //	Look at the STABS documentation and <inc/stab.h> to find
    //	which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, info->eip_fn_addr + addr);
f0104c04:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104c07:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104c0a:	83 c4 08             	add    $0x8,%esp
f0104c0d:	03 7e 10             	add    0x10(%esi),%edi
f0104c10:	57                   	push   %edi
f0104c11:	6a 44                	push   $0x44
f0104c13:	c7 c0 d4 7f 10 f0    	mov    $0xf0107fd4,%eax
f0104c19:	e8 c2 fd ff ff       	call   f01049e0 <stab_binsearch>
    info->eip_line = lline > rline ? -1 : stabs[lline].n_desc;
f0104c1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104c21:	83 c4 10             	add    $0x10,%esp
f0104c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104c29:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104c2c:	7f 0e                	jg     f0104c3c <debuginfo_eip+0x16c>
f0104c2e:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104c31:	c7 c1 d4 7f 10 f0    	mov    $0xf0107fd4,%ecx
f0104c37:	0f b7 44 81 06       	movzwl 0x6(%ecx,%eax,4),%eax
f0104c3c:	89 46 04             	mov    %eax,0x4(%esi)
    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
f0104c3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c42:	89 d0                	mov    %edx,%eax
f0104c44:	8d 0c 52             	lea    (%edx,%edx,2),%ecx
f0104c47:	c7 c2 d4 7f 10 f0    	mov    $0xf0107fd4,%edx
f0104c4d:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f0104c51:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104c55:	89 75 0c             	mov    %esi,0xc(%ebp)
f0104c58:	eb 36                	jmp    f0104c90 <debuginfo_eip+0x1c0>
        panic("User address");
f0104c5a:	83 ec 04             	sub    $0x4,%esp
f0104c5d:	8d 83 46 9d f7 ff    	lea    -0x862ba(%ebx),%eax
f0104c63:	50                   	push   %eax
f0104c64:	6a 7d                	push   $0x7d
f0104c66:	8d 83 53 9d f7 ff    	lea    -0x862ad(%ebx),%eax
f0104c6c:	50                   	push   %eax
f0104c6d:	e8 16 b5 ff ff       	call   f0100188 <_panic>
        info->eip_fn_addr = addr;
f0104c72:	89 7e 10             	mov    %edi,0x10(%esi)
        lline = lfile;
f0104c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
f0104c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c7e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104c81:	e9 6b ff ff ff       	jmp    f0104bf1 <debuginfo_eip+0x121>
f0104c86:	83 e8 01             	sub    $0x1,%eax
f0104c89:	83 ea 0c             	sub    $0xc,%edx
f0104c8c:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104c90:	89 45 c0             	mov    %eax,-0x40(%ebp)
    while (lline >= lfile
f0104c93:	39 c7                	cmp    %eax,%edi
f0104c95:	7f 24                	jg     f0104cbb <debuginfo_eip+0x1eb>
           && stabs[lline].n_type != N_SOL
f0104c97:	0f b6 0a             	movzbl (%edx),%ecx
f0104c9a:	80 f9 84             	cmp    $0x84,%cl
f0104c9d:	74 46                	je     f0104ce5 <debuginfo_eip+0x215>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104c9f:	80 f9 64             	cmp    $0x64,%cl
f0104ca2:	75 e2                	jne    f0104c86 <debuginfo_eip+0x1b6>
f0104ca4:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104ca8:	74 dc                	je     f0104c86 <debuginfo_eip+0x1b6>
f0104caa:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104cad:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104cb1:	74 3b                	je     f0104cee <debuginfo_eip+0x21e>
f0104cb3:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104cb6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104cb9:	eb 33                	jmp    f0104cee <debuginfo_eip+0x21e>
f0104cbb:	8b 75 0c             	mov    0xc(%ebp),%esi
        info->eip_file = stabstr + stabs[lline].n_strx;


    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
f0104cbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104cc1:	8b 7d d8             	mov    -0x28(%ebp),%edi
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
            info->eip_fn_narg++;

    return 0;
f0104cc4:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lfun < rfun)
f0104cc9:	39 fa                	cmp    %edi,%edx
f0104ccb:	0f 8d 82 00 00 00    	jge    f0104d53 <debuginfo_eip+0x283>
        for (lline = lfun + 1;
f0104cd1:	83 c2 01             	add    $0x1,%edx
f0104cd4:	89 d0                	mov    %edx,%eax
f0104cd6:	8d 0c 52             	lea    (%edx,%edx,2),%ecx
f0104cd9:	c7 c2 d4 7f 10 f0    	mov    $0xf0107fd4,%edx
f0104cdf:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx
f0104ce3:	eb 3b                	jmp    f0104d20 <debuginfo_eip+0x250>
f0104ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104ce8:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104cec:	75 26                	jne    f0104d14 <debuginfo_eip+0x244>
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104cee:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104cf1:	c7 c0 d4 7f 10 f0    	mov    $0xf0107fd4,%eax
f0104cf7:	8b 14 90             	mov    (%eax,%edx,4),%edx
f0104cfa:	c7 c0 ff 3c 11 f0    	mov    $0xf0113cff,%eax
f0104d00:	81 e8 91 11 11 f0    	sub    $0xf0111191,%eax
f0104d06:	39 c2                	cmp    %eax,%edx
f0104d08:	73 b4                	jae    f0104cbe <debuginfo_eip+0x1ee>
        info->eip_file = stabstr + stabs[lline].n_strx;
f0104d0a:	81 c2 91 11 11 f0    	add    $0xf0111191,%edx
f0104d10:	89 16                	mov    %edx,(%esi)
f0104d12:	eb aa                	jmp    f0104cbe <debuginfo_eip+0x1ee>
f0104d14:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104d17:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104d1a:	eb d2                	jmp    f0104cee <debuginfo_eip+0x21e>
            info->eip_fn_narg++;
f0104d1c:	83 46 14 01          	addl   $0x1,0x14(%esi)
        for (lline = lfun + 1;
f0104d20:	39 c7                	cmp    %eax,%edi
f0104d22:	7e 2a                	jle    f0104d4e <debuginfo_eip+0x27e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
f0104d24:	0f b6 0a             	movzbl (%edx),%ecx
f0104d27:	83 c0 01             	add    $0x1,%eax
f0104d2a:	83 c2 0c             	add    $0xc,%edx
f0104d2d:	80 f9 a0             	cmp    $0xa0,%cl
f0104d30:	74 ea                	je     f0104d1c <debuginfo_eip+0x24c>
    return 0;
f0104d32:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d37:	eb 1a                	jmp    f0104d53 <debuginfo_eip+0x283>
        return -1;
f0104d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d3e:	eb 13                	jmp    f0104d53 <debuginfo_eip+0x283>
f0104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d45:	eb 0c                	jmp    f0104d53 <debuginfo_eip+0x283>
        return -1;
f0104d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d4c:	eb 05                	jmp    f0104d53 <debuginfo_eip+0x283>
    return 0;
f0104d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104d56:	5b                   	pop    %ebx
f0104d57:	5e                   	pop    %esi
f0104d58:	5f                   	pop    %edi
f0104d59:	5d                   	pop    %ebp
f0104d5a:	c3                   	ret    

f0104d5b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104d5b:	55                   	push   %ebp
f0104d5c:	89 e5                	mov    %esp,%ebp
f0104d5e:	57                   	push   %edi
f0104d5f:	56                   	push   %esi
f0104d60:	53                   	push   %ebx
f0104d61:	83 ec 2c             	sub    $0x2c,%esp
f0104d64:	e8 d7 ea ff ff       	call   f0103840 <__x86.get_pc_thunk.cx>
f0104d69:	81 c1 17 93 08 00    	add    $0x89317,%ecx
f0104d6f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0104d72:	89 c7                	mov    %eax,%edi
f0104d74:	89 d6                	mov    %edx,%esi
f0104d76:	8b 45 08             	mov    0x8(%ebp),%eax
f0104d79:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104d7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104d7f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
f0104d82:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104d85:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d8a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
f0104d8d:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f0104d90:	39 d3                	cmp    %edx,%ebx
f0104d92:	72 09                	jb     f0104d9d <printnum+0x42>
f0104d94:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104d97:	0f 87 83 00 00 00    	ja     f0104e20 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104d9d:	83 ec 0c             	sub    $0xc,%esp
f0104da0:	ff 75 18             	pushl  0x18(%ebp)
f0104da3:	8b 45 14             	mov    0x14(%ebp),%eax
f0104da6:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104da9:	53                   	push   %ebx
f0104daa:	ff 75 10             	pushl  0x10(%ebp)
f0104dad:	83 ec 08             	sub    $0x8,%esp
f0104db0:	ff 75 dc             	pushl  -0x24(%ebp)
f0104db3:	ff 75 d8             	pushl  -0x28(%ebp)
f0104db6:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104db9:	ff 75 d0             	pushl  -0x30(%ebp)
f0104dbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104dbf:	e8 5c 0a 00 00       	call   f0105820 <__udivdi3>
f0104dc4:	83 c4 18             	add    $0x18,%esp
f0104dc7:	52                   	push   %edx
f0104dc8:	50                   	push   %eax
f0104dc9:	89 f2                	mov    %esi,%edx
f0104dcb:	89 f8                	mov    %edi,%eax
f0104dcd:	e8 89 ff ff ff       	call   f0104d5b <printnum>
f0104dd2:	83 c4 20             	add    $0x20,%esp
f0104dd5:	eb 13                	jmp    f0104dea <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104dd7:	83 ec 08             	sub    $0x8,%esp
f0104dda:	56                   	push   %esi
f0104ddb:	ff 75 18             	pushl  0x18(%ebp)
f0104dde:	ff d7                	call   *%edi
f0104de0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104de3:	83 eb 01             	sub    $0x1,%ebx
f0104de6:	85 db                	test   %ebx,%ebx
f0104de8:	7f ed                	jg     f0104dd7 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104dea:	83 ec 08             	sub    $0x8,%esp
f0104ded:	56                   	push   %esi
f0104dee:	83 ec 04             	sub    $0x4,%esp
f0104df1:	ff 75 dc             	pushl  -0x24(%ebp)
f0104df4:	ff 75 d8             	pushl  -0x28(%ebp)
f0104df7:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104dfa:	ff 75 d0             	pushl  -0x30(%ebp)
f0104dfd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104e00:	89 f3                	mov    %esi,%ebx
f0104e02:	e8 39 0b 00 00       	call   f0105940 <__umoddi3>
f0104e07:	83 c4 14             	add    $0x14,%esp
f0104e0a:	0f be 84 06 61 9d f7 	movsbl -0x8629f(%esi,%eax,1),%eax
f0104e11:	ff 
f0104e12:	50                   	push   %eax
f0104e13:	ff d7                	call   *%edi
}
f0104e15:	83 c4 10             	add    $0x10,%esp
f0104e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e1b:	5b                   	pop    %ebx
f0104e1c:	5e                   	pop    %esi
f0104e1d:	5f                   	pop    %edi
f0104e1e:	5d                   	pop    %ebp
f0104e1f:	c3                   	ret    
f0104e20:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104e23:	eb be                	jmp    f0104de3 <printnum+0x88>

f0104e25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0104e25:	55                   	push   %ebp
f0104e26:	89 e5                	mov    %esp,%ebp
f0104e28:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104e2b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104e2f:	8b 10                	mov    (%eax),%edx
f0104e31:	3b 50 04             	cmp    0x4(%eax),%edx
f0104e34:	73 0a                	jae    f0104e40 <sprintputch+0x1b>
		*b->buf++ = ch;
f0104e36:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104e39:	89 08                	mov    %ecx,(%eax)
f0104e3b:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e3e:	88 02                	mov    %al,(%edx)
}
f0104e40:	5d                   	pop    %ebp
f0104e41:	c3                   	ret    

f0104e42 <printfmt>:
{
f0104e42:	55                   	push   %ebp
f0104e43:	89 e5                	mov    %esp,%ebp
f0104e45:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0104e48:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104e4b:	50                   	push   %eax
f0104e4c:	ff 75 10             	pushl  0x10(%ebp)
f0104e4f:	ff 75 0c             	pushl  0xc(%ebp)
f0104e52:	ff 75 08             	pushl  0x8(%ebp)
f0104e55:	e8 05 00 00 00       	call   f0104e5f <vprintfmt>
}
f0104e5a:	83 c4 10             	add    $0x10,%esp
f0104e5d:	c9                   	leave  
f0104e5e:	c3                   	ret    

f0104e5f <vprintfmt>:
{
f0104e5f:	55                   	push   %ebp
f0104e60:	89 e5                	mov    %esp,%ebp
f0104e62:	57                   	push   %edi
f0104e63:	56                   	push   %esi
f0104e64:	53                   	push   %ebx
f0104e65:	83 ec 2c             	sub    $0x2c,%esp
f0104e68:	e8 d1 b3 ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0104e6d:	81 c3 13 92 08 00    	add    $0x89213,%ebx
f0104e73:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104e76:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104e79:	e9 fb 03 00 00       	jmp    f0105279 <.L35+0x48>
		padc = ' ';
f0104e7e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0104e82:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104e89:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
		width = -1;
f0104e90:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0104e97:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104e9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104e9f:	8d 47 01             	lea    0x1(%edi),%eax
f0104ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104ea5:	0f b6 17             	movzbl (%edi),%edx
f0104ea8:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104eab:	3c 55                	cmp    $0x55,%al
f0104ead:	0f 87 4e 04 00 00    	ja     f0105301 <.L22>
f0104eb3:	0f b6 c0             	movzbl %al,%eax
f0104eb6:	89 d9                	mov    %ebx,%ecx
f0104eb8:	03 8c 83 ec 9d f7 ff 	add    -0x86214(%ebx,%eax,4),%ecx
f0104ebf:	ff e1                	jmp    *%ecx

f0104ec1 <.L71>:
f0104ec1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0104ec4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0104ec8:	eb d5                	jmp    f0104e9f <vprintfmt+0x40>

f0104eca <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
f0104eca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0104ecd:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104ed1:	eb cc                	jmp    f0104e9f <vprintfmt+0x40>

f0104ed3 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
f0104ed3:	0f b6 d2             	movzbl %dl,%edx
f0104ed6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104ed9:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
f0104ede:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104ee1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104ee5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104ee8:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104eeb:	83 f9 09             	cmp    $0x9,%ecx
f0104eee:	77 55                	ja     f0104f45 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
f0104ef0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0104ef3:	eb e9                	jmp    f0104ede <.L29+0xb>

f0104ef5 <.L26>:
			precision = va_arg(ap, int);
f0104ef5:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ef8:	8b 00                	mov    (%eax),%eax
f0104efa:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0104efd:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f00:	8d 40 04             	lea    0x4(%eax),%eax
f0104f03:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104f06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0104f09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104f0d:	79 90                	jns    f0104e9f <vprintfmt+0x40>
				width = precision, precision = -1;
f0104f0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0104f12:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f15:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
f0104f1c:	eb 81                	jmp    f0104e9f <vprintfmt+0x40>

f0104f1e <.L27>:
f0104f1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f21:	85 c0                	test   %eax,%eax
f0104f23:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f28:	0f 49 d0             	cmovns %eax,%edx
f0104f2b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104f2e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f31:	e9 69 ff ff ff       	jmp    f0104e9f <vprintfmt+0x40>

f0104f36 <.L23>:
f0104f36:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0104f39:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0104f40:	e9 5a ff ff ff       	jmp    f0104e9f <vprintfmt+0x40>
f0104f45:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0104f48:	eb bf                	jmp    f0104f09 <.L26+0x14>

f0104f4a <.L33>:
			lflag++;
f0104f4a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104f4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0104f51:	e9 49 ff ff ff       	jmp    f0104e9f <vprintfmt+0x40>

f0104f56 <.L30>:
			putch(va_arg(ap, int), putdat);
f0104f56:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f59:	8d 78 04             	lea    0x4(%eax),%edi
f0104f5c:	83 ec 08             	sub    $0x8,%esp
f0104f5f:	56                   	push   %esi
f0104f60:	ff 30                	pushl  (%eax)
f0104f62:	ff 55 08             	call   *0x8(%ebp)
			break;
f0104f65:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104f68:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0104f6b:	e9 06 03 00 00       	jmp    f0105276 <.L35+0x45>

f0104f70 <.L32>:
			err = va_arg(ap, int);
f0104f70:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f73:	8d 78 04             	lea    0x4(%eax),%edi
f0104f76:	8b 00                	mov    (%eax),%eax
f0104f78:	99                   	cltd   
f0104f79:	31 d0                	xor    %edx,%eax
f0104f7b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104f7d:	83 f8 06             	cmp    $0x6,%eax
f0104f80:	7f 27                	jg     f0104fa9 <.L32+0x39>
f0104f82:	8b 94 83 50 20 00 00 	mov    0x2050(%ebx,%eax,4),%edx
f0104f89:	85 d2                	test   %edx,%edx
f0104f8b:	74 1c                	je     f0104fa9 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
f0104f8d:	52                   	push   %edx
f0104f8e:	8d 83 4f 8f f7 ff    	lea    -0x870b1(%ebx),%eax
f0104f94:	50                   	push   %eax
f0104f95:	56                   	push   %esi
f0104f96:	ff 75 08             	pushl  0x8(%ebp)
f0104f99:	e8 a4 fe ff ff       	call   f0104e42 <printfmt>
f0104f9e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104fa1:	89 7d 14             	mov    %edi,0x14(%ebp)
f0104fa4:	e9 cd 02 00 00       	jmp    f0105276 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
f0104fa9:	50                   	push   %eax
f0104faa:	8d 83 79 9d f7 ff    	lea    -0x86287(%ebx),%eax
f0104fb0:	50                   	push   %eax
f0104fb1:	56                   	push   %esi
f0104fb2:	ff 75 08             	pushl  0x8(%ebp)
f0104fb5:	e8 88 fe ff ff       	call   f0104e42 <printfmt>
f0104fba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104fbd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104fc0:	e9 b1 02 00 00       	jmp    f0105276 <.L35+0x45>

f0104fc5 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
f0104fc5:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fc8:	83 c0 04             	add    $0x4,%eax
f0104fcb:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104fce:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fd1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0104fd3:	85 ff                	test   %edi,%edi
f0104fd5:	8d 83 72 9d f7 ff    	lea    -0x8628e(%ebx),%eax
f0104fdb:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0104fde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104fe2:	0f 8e b5 00 00 00    	jle    f010509d <.L36+0xd8>
f0104fe8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f0104fec:	75 08                	jne    f0104ff6 <.L36+0x31>
f0104fee:	89 75 0c             	mov    %esi,0xc(%ebp)
f0104ff1:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0104ff4:	eb 6d                	jmp    f0105063 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104ff6:	83 ec 08             	sub    $0x8,%esp
f0104ff9:	ff 75 cc             	pushl  -0x34(%ebp)
f0104ffc:	57                   	push   %edi
f0104ffd:	e8 b6 04 00 00       	call   f01054b8 <strnlen>
f0105002:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105005:	29 c2                	sub    %eax,%edx
f0105007:	89 55 c8             	mov    %edx,-0x38(%ebp)
f010500a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f010500d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0105011:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105014:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105017:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105019:	eb 10                	jmp    f010502b <.L36+0x66>
					putch(padc, putdat);
f010501b:	83 ec 08             	sub    $0x8,%esp
f010501e:	56                   	push   %esi
f010501f:	ff 75 e0             	pushl  -0x20(%ebp)
f0105022:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105025:	83 ef 01             	sub    $0x1,%edi
f0105028:	83 c4 10             	add    $0x10,%esp
f010502b:	85 ff                	test   %edi,%edi
f010502d:	7f ec                	jg     f010501b <.L36+0x56>
f010502f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0105032:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0105035:	85 d2                	test   %edx,%edx
f0105037:	b8 00 00 00 00       	mov    $0x0,%eax
f010503c:	0f 49 c2             	cmovns %edx,%eax
f010503f:	29 c2                	sub    %eax,%edx
f0105041:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105044:	89 75 0c             	mov    %esi,0xc(%ebp)
f0105047:	8b 75 cc             	mov    -0x34(%ebp),%esi
f010504a:	eb 17                	jmp    f0105063 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
f010504c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105050:	75 30                	jne    f0105082 <.L36+0xbd>
					putch(ch, putdat);
f0105052:	83 ec 08             	sub    $0x8,%esp
f0105055:	ff 75 0c             	pushl  0xc(%ebp)
f0105058:	50                   	push   %eax
f0105059:	ff 55 08             	call   *0x8(%ebp)
f010505c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010505f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f0105063:	83 c7 01             	add    $0x1,%edi
f0105066:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f010506a:	0f be c2             	movsbl %dl,%eax
f010506d:	85 c0                	test   %eax,%eax
f010506f:	74 52                	je     f01050c3 <.L36+0xfe>
f0105071:	85 f6                	test   %esi,%esi
f0105073:	78 d7                	js     f010504c <.L36+0x87>
f0105075:	83 ee 01             	sub    $0x1,%esi
f0105078:	79 d2                	jns    f010504c <.L36+0x87>
f010507a:	8b 75 0c             	mov    0xc(%ebp),%esi
f010507d:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105080:	eb 32                	jmp    f01050b4 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
f0105082:	0f be d2             	movsbl %dl,%edx
f0105085:	83 ea 20             	sub    $0x20,%edx
f0105088:	83 fa 5e             	cmp    $0x5e,%edx
f010508b:	76 c5                	jbe    f0105052 <.L36+0x8d>
					putch('?', putdat);
f010508d:	83 ec 08             	sub    $0x8,%esp
f0105090:	ff 75 0c             	pushl  0xc(%ebp)
f0105093:	6a 3f                	push   $0x3f
f0105095:	ff 55 08             	call   *0x8(%ebp)
f0105098:	83 c4 10             	add    $0x10,%esp
f010509b:	eb c2                	jmp    f010505f <.L36+0x9a>
f010509d:	89 75 0c             	mov    %esi,0xc(%ebp)
f01050a0:	8b 75 cc             	mov    -0x34(%ebp),%esi
f01050a3:	eb be                	jmp    f0105063 <.L36+0x9e>
				putch(' ', putdat);
f01050a5:	83 ec 08             	sub    $0x8,%esp
f01050a8:	56                   	push   %esi
f01050a9:	6a 20                	push   $0x20
f01050ab:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
f01050ae:	83 ef 01             	sub    $0x1,%edi
f01050b1:	83 c4 10             	add    $0x10,%esp
f01050b4:	85 ff                	test   %edi,%edi
f01050b6:	7f ed                	jg     f01050a5 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
f01050b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01050bb:	89 45 14             	mov    %eax,0x14(%ebp)
f01050be:	e9 b3 01 00 00       	jmp    f0105276 <.L35+0x45>
f01050c3:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01050c6:	8b 75 0c             	mov    0xc(%ebp),%esi
f01050c9:	eb e9                	jmp    f01050b4 <.L36+0xef>

f01050cb <.L31>:
f01050cb:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f01050ce:	83 f9 01             	cmp    $0x1,%ecx
f01050d1:	7e 40                	jle    f0105113 <.L31+0x48>
		return va_arg(*ap, long long);
f01050d3:	8b 45 14             	mov    0x14(%ebp),%eax
f01050d6:	8b 50 04             	mov    0x4(%eax),%edx
f01050d9:	8b 00                	mov    (%eax),%eax
f01050db:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01050de:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01050e1:	8b 45 14             	mov    0x14(%ebp),%eax
f01050e4:	8d 40 08             	lea    0x8(%eax),%eax
f01050e7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01050ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01050ee:	79 55                	jns    f0105145 <.L31+0x7a>
				putch('-', putdat);
f01050f0:	83 ec 08             	sub    $0x8,%esp
f01050f3:	56                   	push   %esi
f01050f4:	6a 2d                	push   $0x2d
f01050f6:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01050f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01050fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01050ff:	f7 da                	neg    %edx
f0105101:	83 d1 00             	adc    $0x0,%ecx
f0105104:	f7 d9                	neg    %ecx
f0105106:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105109:	b8 0a 00 00 00       	mov    $0xa,%eax
f010510e:	e9 48 01 00 00       	jmp    f010525b <.L35+0x2a>
	else if (lflag)
f0105113:	85 c9                	test   %ecx,%ecx
f0105115:	75 17                	jne    f010512e <.L31+0x63>
		return va_arg(*ap, int);
f0105117:	8b 45 14             	mov    0x14(%ebp),%eax
f010511a:	8b 00                	mov    (%eax),%eax
f010511c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010511f:	99                   	cltd   
f0105120:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105123:	8b 45 14             	mov    0x14(%ebp),%eax
f0105126:	8d 40 04             	lea    0x4(%eax),%eax
f0105129:	89 45 14             	mov    %eax,0x14(%ebp)
f010512c:	eb bc                	jmp    f01050ea <.L31+0x1f>
		return va_arg(*ap, long);
f010512e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105131:	8b 00                	mov    (%eax),%eax
f0105133:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105136:	99                   	cltd   
f0105137:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010513a:	8b 45 14             	mov    0x14(%ebp),%eax
f010513d:	8d 40 04             	lea    0x4(%eax),%eax
f0105140:	89 45 14             	mov    %eax,0x14(%ebp)
f0105143:	eb a5                	jmp    f01050ea <.L31+0x1f>
			num = getint(&ap, lflag);
f0105145:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105148:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f010514b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105150:	e9 06 01 00 00       	jmp    f010525b <.L35+0x2a>

f0105155 <.L37>:
f0105155:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f0105158:	83 f9 01             	cmp    $0x1,%ecx
f010515b:	7e 18                	jle    f0105175 <.L37+0x20>
		return va_arg(*ap, unsigned long long);
f010515d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105160:	8b 10                	mov    (%eax),%edx
f0105162:	8b 48 04             	mov    0x4(%eax),%ecx
f0105165:	8d 40 08             	lea    0x8(%eax),%eax
f0105168:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010516b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105170:	e9 e6 00 00 00       	jmp    f010525b <.L35+0x2a>
	else if (lflag)
f0105175:	85 c9                	test   %ecx,%ecx
f0105177:	75 1a                	jne    f0105193 <.L37+0x3e>
		return va_arg(*ap, unsigned int);
f0105179:	8b 45 14             	mov    0x14(%ebp),%eax
f010517c:	8b 10                	mov    (%eax),%edx
f010517e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105183:	8d 40 04             	lea    0x4(%eax),%eax
f0105186:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105189:	b8 0a 00 00 00       	mov    $0xa,%eax
f010518e:	e9 c8 00 00 00       	jmp    f010525b <.L35+0x2a>
		return va_arg(*ap, unsigned long);
f0105193:	8b 45 14             	mov    0x14(%ebp),%eax
f0105196:	8b 10                	mov    (%eax),%edx
f0105198:	b9 00 00 00 00       	mov    $0x0,%ecx
f010519d:	8d 40 04             	lea    0x4(%eax),%eax
f01051a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01051a3:	b8 0a 00 00 00       	mov    $0xa,%eax
f01051a8:	e9 ae 00 00 00       	jmp    f010525b <.L35+0x2a>

f01051ad <.L34>:
f01051ad:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f01051b0:	83 f9 01             	cmp    $0x1,%ecx
f01051b3:	7e 3d                	jle    f01051f2 <.L34+0x45>
		return va_arg(*ap, long long);
f01051b5:	8b 45 14             	mov    0x14(%ebp),%eax
f01051b8:	8b 50 04             	mov    0x4(%eax),%edx
f01051bb:	8b 00                	mov    (%eax),%eax
f01051bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01051c3:	8b 45 14             	mov    0x14(%ebp),%eax
f01051c6:	8d 40 08             	lea    0x8(%eax),%eax
f01051c9:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
f01051cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01051d0:	79 52                	jns    f0105224 <.L34+0x77>
                putch('-', putdat);
f01051d2:	83 ec 08             	sub    $0x8,%esp
f01051d5:	56                   	push   %esi
f01051d6:	6a 2d                	push   $0x2d
f01051d8:	ff 55 08             	call   *0x8(%ebp)
                num = -(long long) num;
f01051db:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01051de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01051e1:	f7 da                	neg    %edx
f01051e3:	83 d1 00             	adc    $0x0,%ecx
f01051e6:	f7 d9                	neg    %ecx
f01051e8:	83 c4 10             	add    $0x10,%esp
            base = 8;
f01051eb:	b8 08 00 00 00       	mov    $0x8,%eax
f01051f0:	eb 69                	jmp    f010525b <.L35+0x2a>
	else if (lflag)
f01051f2:	85 c9                	test   %ecx,%ecx
f01051f4:	75 17                	jne    f010520d <.L34+0x60>
		return va_arg(*ap, int);
f01051f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01051f9:	8b 00                	mov    (%eax),%eax
f01051fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051fe:	99                   	cltd   
f01051ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105202:	8b 45 14             	mov    0x14(%ebp),%eax
f0105205:	8d 40 04             	lea    0x4(%eax),%eax
f0105208:	89 45 14             	mov    %eax,0x14(%ebp)
f010520b:	eb bf                	jmp    f01051cc <.L34+0x1f>
		return va_arg(*ap, long);
f010520d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105210:	8b 00                	mov    (%eax),%eax
f0105212:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105215:	99                   	cltd   
f0105216:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105219:	8b 45 14             	mov    0x14(%ebp),%eax
f010521c:	8d 40 04             	lea    0x4(%eax),%eax
f010521f:	89 45 14             	mov    %eax,0x14(%ebp)
f0105222:	eb a8                	jmp    f01051cc <.L34+0x1f>
            num = getint(&ap, lflag);
f0105224:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105227:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
f010522a:	b8 08 00 00 00       	mov    $0x8,%eax
f010522f:	eb 2a                	jmp    f010525b <.L35+0x2a>

f0105231 <.L35>:
			putch('0', putdat);
f0105231:	83 ec 08             	sub    $0x8,%esp
f0105234:	56                   	push   %esi
f0105235:	6a 30                	push   $0x30
f0105237:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f010523a:	83 c4 08             	add    $0x8,%esp
f010523d:	56                   	push   %esi
f010523e:	6a 78                	push   $0x78
f0105240:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f0105243:	8b 45 14             	mov    0x14(%ebp),%eax
f0105246:	8b 10                	mov    (%eax),%edx
f0105248:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010524d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105250:	8d 40 04             	lea    0x4(%eax),%eax
f0105253:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105256:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010525b:	83 ec 0c             	sub    $0xc,%esp
f010525e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0105262:	57                   	push   %edi
f0105263:	ff 75 e0             	pushl  -0x20(%ebp)
f0105266:	50                   	push   %eax
f0105267:	51                   	push   %ecx
f0105268:	52                   	push   %edx
f0105269:	89 f2                	mov    %esi,%edx
f010526b:	8b 45 08             	mov    0x8(%ebp),%eax
f010526e:	e8 e8 fa ff ff       	call   f0104d5b <printnum>
			break;
f0105273:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0105276:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105279:	83 c7 01             	add    $0x1,%edi
f010527c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105280:	83 f8 25             	cmp    $0x25,%eax
f0105283:	0f 84 f5 fb ff ff    	je     f0104e7e <vprintfmt+0x1f>
			if (ch == '\0')
f0105289:	85 c0                	test   %eax,%eax
f010528b:	0f 84 91 00 00 00    	je     f0105322 <.L22+0x21>
			putch(ch, putdat);
f0105291:	83 ec 08             	sub    $0x8,%esp
f0105294:	56                   	push   %esi
f0105295:	50                   	push   %eax
f0105296:	ff 55 08             	call   *0x8(%ebp)
f0105299:	83 c4 10             	add    $0x10,%esp
f010529c:	eb db                	jmp    f0105279 <.L35+0x48>

f010529e <.L38>:
f010529e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	if (lflag >= 2)
f01052a1:	83 f9 01             	cmp    $0x1,%ecx
f01052a4:	7e 15                	jle    f01052bb <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
f01052a6:	8b 45 14             	mov    0x14(%ebp),%eax
f01052a9:	8b 10                	mov    (%eax),%edx
f01052ab:	8b 48 04             	mov    0x4(%eax),%ecx
f01052ae:	8d 40 08             	lea    0x8(%eax),%eax
f01052b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01052b4:	b8 10 00 00 00       	mov    $0x10,%eax
f01052b9:	eb a0                	jmp    f010525b <.L35+0x2a>
	else if (lflag)
f01052bb:	85 c9                	test   %ecx,%ecx
f01052bd:	75 17                	jne    f01052d6 <.L38+0x38>
		return va_arg(*ap, unsigned int);
f01052bf:	8b 45 14             	mov    0x14(%ebp),%eax
f01052c2:	8b 10                	mov    (%eax),%edx
f01052c4:	b9 00 00 00 00       	mov    $0x0,%ecx
f01052c9:	8d 40 04             	lea    0x4(%eax),%eax
f01052cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01052cf:	b8 10 00 00 00       	mov    $0x10,%eax
f01052d4:	eb 85                	jmp    f010525b <.L35+0x2a>
		return va_arg(*ap, unsigned long);
f01052d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01052d9:	8b 10                	mov    (%eax),%edx
f01052db:	b9 00 00 00 00       	mov    $0x0,%ecx
f01052e0:	8d 40 04             	lea    0x4(%eax),%eax
f01052e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01052e6:	b8 10 00 00 00       	mov    $0x10,%eax
f01052eb:	e9 6b ff ff ff       	jmp    f010525b <.L35+0x2a>

f01052f0 <.L25>:
			putch(ch, putdat);
f01052f0:	83 ec 08             	sub    $0x8,%esp
f01052f3:	56                   	push   %esi
f01052f4:	6a 25                	push   $0x25
f01052f6:	ff 55 08             	call   *0x8(%ebp)
			break;
f01052f9:	83 c4 10             	add    $0x10,%esp
f01052fc:	e9 75 ff ff ff       	jmp    f0105276 <.L35+0x45>

f0105301 <.L22>:
			putch('%', putdat);
f0105301:	83 ec 08             	sub    $0x8,%esp
f0105304:	56                   	push   %esi
f0105305:	6a 25                	push   $0x25
f0105307:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f010530a:	83 c4 10             	add    $0x10,%esp
f010530d:	89 f8                	mov    %edi,%eax
f010530f:	eb 03                	jmp    f0105314 <.L22+0x13>
f0105311:	83 e8 01             	sub    $0x1,%eax
f0105314:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0105318:	75 f7                	jne    f0105311 <.L22+0x10>
f010531a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010531d:	e9 54 ff ff ff       	jmp    f0105276 <.L35+0x45>
}
f0105322:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105325:	5b                   	pop    %ebx
f0105326:	5e                   	pop    %esi
f0105327:	5f                   	pop    %edi
f0105328:	5d                   	pop    %ebp
f0105329:	c3                   	ret    

f010532a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010532a:	55                   	push   %ebp
f010532b:	89 e5                	mov    %esp,%ebp
f010532d:	53                   	push   %ebx
f010532e:	83 ec 14             	sub    $0x14,%esp
f0105331:	e8 08 af ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f0105336:	81 c3 4a 8d 08 00    	add    $0x88d4a,%ebx
f010533c:	8b 45 08             	mov    0x8(%ebp),%eax
f010533f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105342:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105345:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105349:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010534c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105353:	85 c0                	test   %eax,%eax
f0105355:	74 2b                	je     f0105382 <vsnprintf+0x58>
f0105357:	85 d2                	test   %edx,%edx
f0105359:	7e 27                	jle    f0105382 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f010535b:	ff 75 14             	pushl  0x14(%ebp)
f010535e:	ff 75 10             	pushl  0x10(%ebp)
f0105361:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105364:	50                   	push   %eax
f0105365:	8d 83 a5 6d f7 ff    	lea    -0x8925b(%ebx),%eax
f010536b:	50                   	push   %eax
f010536c:	e8 ee fa ff ff       	call   f0104e5f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105371:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105374:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105377:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010537a:	83 c4 10             	add    $0x10,%esp
}
f010537d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105380:	c9                   	leave  
f0105381:	c3                   	ret    
		return -E_INVAL;
f0105382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105387:	eb f4                	jmp    f010537d <vsnprintf+0x53>

f0105389 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105389:	55                   	push   %ebp
f010538a:	89 e5                	mov    %esp,%ebp
f010538c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f010538f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105392:	50                   	push   %eax
f0105393:	ff 75 10             	pushl  0x10(%ebp)
f0105396:	ff 75 0c             	pushl  0xc(%ebp)
f0105399:	ff 75 08             	pushl  0x8(%ebp)
f010539c:	e8 89 ff ff ff       	call   f010532a <vsnprintf>
	va_end(ap);

	return rc;
}
f01053a1:	c9                   	leave  
f01053a2:	c3                   	ret    

f01053a3 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01053a3:	55                   	push   %ebp
f01053a4:	89 e5                	mov    %esp,%ebp
f01053a6:	57                   	push   %edi
f01053a7:	56                   	push   %esi
f01053a8:	53                   	push   %ebx
f01053a9:	83 ec 1c             	sub    $0x1c,%esp
f01053ac:	e8 8d ae ff ff       	call   f010023e <__x86.get_pc_thunk.bx>
f01053b1:	81 c3 cf 8c 08 00    	add    $0x88ccf,%ebx
f01053b7:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01053ba:	85 c0                	test   %eax,%eax
f01053bc:	74 13                	je     f01053d1 <readline+0x2e>
		cprintf("%s", prompt);
f01053be:	83 ec 08             	sub    $0x8,%esp
f01053c1:	50                   	push   %eax
f01053c2:	8d 83 4f 8f f7 ff    	lea    -0x870b1(%ebx),%eax
f01053c8:	50                   	push   %eax
f01053c9:	e8 98 ed ff ff       	call   f0104166 <cprintf>
f01053ce:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f01053d1:	83 ec 0c             	sub    $0xc,%esp
f01053d4:	6a 00                	push   $0x0
f01053d6:	e8 fb b3 ff ff       	call   f01007d6 <iscons>
f01053db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01053de:	83 c4 10             	add    $0x10,%esp
	i = 0;
f01053e1:	bf 00 00 00 00       	mov    $0x0,%edi
f01053e6:	eb 46                	jmp    f010542e <readline+0x8b>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f01053e8:	83 ec 08             	sub    $0x8,%esp
f01053eb:	50                   	push   %eax
f01053ec:	8d 83 44 9f f7 ff    	lea    -0x860bc(%ebx),%eax
f01053f2:	50                   	push   %eax
f01053f3:	e8 6e ed ff ff       	call   f0104166 <cprintf>
			return NULL;
f01053f8:	83 c4 10             	add    $0x10,%esp
f01053fb:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105400:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105403:	5b                   	pop    %ebx
f0105404:	5e                   	pop    %esi
f0105405:	5f                   	pop    %edi
f0105406:	5d                   	pop    %ebp
f0105407:	c3                   	ret    
			if (echoing)
f0105408:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010540c:	75 05                	jne    f0105413 <readline+0x70>
			i--;
f010540e:	83 ef 01             	sub    $0x1,%edi
f0105411:	eb 1b                	jmp    f010542e <readline+0x8b>
				cputchar('\b');
f0105413:	83 ec 0c             	sub    $0xc,%esp
f0105416:	6a 08                	push   $0x8
f0105418:	e8 98 b3 ff ff       	call   f01007b5 <cputchar>
f010541d:	83 c4 10             	add    $0x10,%esp
f0105420:	eb ec                	jmp    f010540e <readline+0x6b>
			buf[i++] = c;
f0105422:	89 f0                	mov    %esi,%eax
f0105424:	88 84 3b 80 2b 00 00 	mov    %al,0x2b80(%ebx,%edi,1)
f010542b:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f010542e:	e8 92 b3 ff ff       	call   f01007c5 <getchar>
f0105433:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0105435:	85 c0                	test   %eax,%eax
f0105437:	78 af                	js     f01053e8 <readline+0x45>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105439:	83 f8 08             	cmp    $0x8,%eax
f010543c:	0f 94 c2             	sete   %dl
f010543f:	83 f8 7f             	cmp    $0x7f,%eax
f0105442:	0f 94 c0             	sete   %al
f0105445:	08 c2                	or     %al,%dl
f0105447:	74 04                	je     f010544d <readline+0xaa>
f0105449:	85 ff                	test   %edi,%edi
f010544b:	7f bb                	jg     f0105408 <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f010544d:	83 fe 1f             	cmp    $0x1f,%esi
f0105450:	7e 1c                	jle    f010546e <readline+0xcb>
f0105452:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f0105458:	7f 14                	jg     f010546e <readline+0xcb>
			if (echoing)
f010545a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010545e:	74 c2                	je     f0105422 <readline+0x7f>
				cputchar(c);
f0105460:	83 ec 0c             	sub    $0xc,%esp
f0105463:	56                   	push   %esi
f0105464:	e8 4c b3 ff ff       	call   f01007b5 <cputchar>
f0105469:	83 c4 10             	add    $0x10,%esp
f010546c:	eb b4                	jmp    f0105422 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
f010546e:	83 fe 0a             	cmp    $0xa,%esi
f0105471:	74 05                	je     f0105478 <readline+0xd5>
f0105473:	83 fe 0d             	cmp    $0xd,%esi
f0105476:	75 b6                	jne    f010542e <readline+0x8b>
			if (echoing)
f0105478:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010547c:	75 13                	jne    f0105491 <readline+0xee>
			buf[i] = 0;
f010547e:	c6 84 3b 80 2b 00 00 	movb   $0x0,0x2b80(%ebx,%edi,1)
f0105485:	00 
			return buf;
f0105486:	8d 83 80 2b 00 00    	lea    0x2b80(%ebx),%eax
f010548c:	e9 6f ff ff ff       	jmp    f0105400 <readline+0x5d>
				cputchar('\n');
f0105491:	83 ec 0c             	sub    $0xc,%esp
f0105494:	6a 0a                	push   $0xa
f0105496:	e8 1a b3 ff ff       	call   f01007b5 <cputchar>
f010549b:	83 c4 10             	add    $0x10,%esp
f010549e:	eb de                	jmp    f010547e <readline+0xdb>

f01054a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01054a0:	55                   	push   %ebp
f01054a1:	89 e5                	mov    %esp,%ebp
f01054a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01054a6:	b8 00 00 00 00       	mov    $0x0,%eax
f01054ab:	eb 03                	jmp    f01054b0 <strlen+0x10>
		n++;
f01054ad:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f01054b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01054b4:	75 f7                	jne    f01054ad <strlen+0xd>
	return n;
}
f01054b6:	5d                   	pop    %ebp
f01054b7:	c3                   	ret    

f01054b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01054b8:	55                   	push   %ebp
f01054b9:	89 e5                	mov    %esp,%ebp
f01054bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01054be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01054c1:	b8 00 00 00 00       	mov    $0x0,%eax
f01054c6:	eb 03                	jmp    f01054cb <strnlen+0x13>
		n++;
f01054c8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01054cb:	39 d0                	cmp    %edx,%eax
f01054cd:	74 06                	je     f01054d5 <strnlen+0x1d>
f01054cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f01054d3:	75 f3                	jne    f01054c8 <strnlen+0x10>
	return n;
}
f01054d5:	5d                   	pop    %ebp
f01054d6:	c3                   	ret    

f01054d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01054d7:	55                   	push   %ebp
f01054d8:	89 e5                	mov    %esp,%ebp
f01054da:	53                   	push   %ebx
f01054db:	8b 45 08             	mov    0x8(%ebp),%eax
f01054de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01054e1:	89 c2                	mov    %eax,%edx
f01054e3:	83 c1 01             	add    $0x1,%ecx
f01054e6:	83 c2 01             	add    $0x1,%edx
f01054e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f01054ed:	88 5a ff             	mov    %bl,-0x1(%edx)
f01054f0:	84 db                	test   %bl,%bl
f01054f2:	75 ef                	jne    f01054e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f01054f4:	5b                   	pop    %ebx
f01054f5:	5d                   	pop    %ebp
f01054f6:	c3                   	ret    

f01054f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01054f7:	55                   	push   %ebp
f01054f8:	89 e5                	mov    %esp,%ebp
f01054fa:	53                   	push   %ebx
f01054fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01054fe:	53                   	push   %ebx
f01054ff:	e8 9c ff ff ff       	call   f01054a0 <strlen>
f0105504:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0105507:	ff 75 0c             	pushl  0xc(%ebp)
f010550a:	01 d8                	add    %ebx,%eax
f010550c:	50                   	push   %eax
f010550d:	e8 c5 ff ff ff       	call   f01054d7 <strcpy>
	return dst;
}
f0105512:	89 d8                	mov    %ebx,%eax
f0105514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105517:	c9                   	leave  
f0105518:	c3                   	ret    

f0105519 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105519:	55                   	push   %ebp
f010551a:	89 e5                	mov    %esp,%ebp
f010551c:	56                   	push   %esi
f010551d:	53                   	push   %ebx
f010551e:	8b 75 08             	mov    0x8(%ebp),%esi
f0105521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105524:	89 f3                	mov    %esi,%ebx
f0105526:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105529:	89 f2                	mov    %esi,%edx
f010552b:	eb 0f                	jmp    f010553c <strncpy+0x23>
		*dst++ = *src;
f010552d:	83 c2 01             	add    $0x1,%edx
f0105530:	0f b6 01             	movzbl (%ecx),%eax
f0105533:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105536:	80 39 01             	cmpb   $0x1,(%ecx)
f0105539:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f010553c:	39 da                	cmp    %ebx,%edx
f010553e:	75 ed                	jne    f010552d <strncpy+0x14>
	}
	return ret;
}
f0105540:	89 f0                	mov    %esi,%eax
f0105542:	5b                   	pop    %ebx
f0105543:	5e                   	pop    %esi
f0105544:	5d                   	pop    %ebp
f0105545:	c3                   	ret    

f0105546 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105546:	55                   	push   %ebp
f0105547:	89 e5                	mov    %esp,%ebp
f0105549:	56                   	push   %esi
f010554a:	53                   	push   %ebx
f010554b:	8b 75 08             	mov    0x8(%ebp),%esi
f010554e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105551:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105554:	89 f0                	mov    %esi,%eax
f0105556:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f010555a:	85 c9                	test   %ecx,%ecx
f010555c:	75 0b                	jne    f0105569 <strlcpy+0x23>
f010555e:	eb 17                	jmp    f0105577 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0105560:	83 c2 01             	add    $0x1,%edx
f0105563:	83 c0 01             	add    $0x1,%eax
f0105566:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0105569:	39 d8                	cmp    %ebx,%eax
f010556b:	74 07                	je     f0105574 <strlcpy+0x2e>
f010556d:	0f b6 0a             	movzbl (%edx),%ecx
f0105570:	84 c9                	test   %cl,%cl
f0105572:	75 ec                	jne    f0105560 <strlcpy+0x1a>
		*dst = '\0';
f0105574:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105577:	29 f0                	sub    %esi,%eax
}
f0105579:	5b                   	pop    %ebx
f010557a:	5e                   	pop    %esi
f010557b:	5d                   	pop    %ebp
f010557c:	c3                   	ret    

f010557d <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010557d:	55                   	push   %ebp
f010557e:	89 e5                	mov    %esp,%ebp
f0105580:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105583:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105586:	eb 06                	jmp    f010558e <strcmp+0x11>
		p++, q++;
f0105588:	83 c1 01             	add    $0x1,%ecx
f010558b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f010558e:	0f b6 01             	movzbl (%ecx),%eax
f0105591:	84 c0                	test   %al,%al
f0105593:	74 04                	je     f0105599 <strcmp+0x1c>
f0105595:	3a 02                	cmp    (%edx),%al
f0105597:	74 ef                	je     f0105588 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105599:	0f b6 c0             	movzbl %al,%eax
f010559c:	0f b6 12             	movzbl (%edx),%edx
f010559f:	29 d0                	sub    %edx,%eax
}
f01055a1:	5d                   	pop    %ebp
f01055a2:	c3                   	ret    

f01055a3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01055a3:	55                   	push   %ebp
f01055a4:	89 e5                	mov    %esp,%ebp
f01055a6:	53                   	push   %ebx
f01055a7:	8b 45 08             	mov    0x8(%ebp),%eax
f01055aa:	8b 55 0c             	mov    0xc(%ebp),%edx
f01055ad:	89 c3                	mov    %eax,%ebx
f01055af:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f01055b2:	eb 06                	jmp    f01055ba <strncmp+0x17>
		n--, p++, q++;
f01055b4:	83 c0 01             	add    $0x1,%eax
f01055b7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f01055ba:	39 d8                	cmp    %ebx,%eax
f01055bc:	74 16                	je     f01055d4 <strncmp+0x31>
f01055be:	0f b6 08             	movzbl (%eax),%ecx
f01055c1:	84 c9                	test   %cl,%cl
f01055c3:	74 04                	je     f01055c9 <strncmp+0x26>
f01055c5:	3a 0a                	cmp    (%edx),%cl
f01055c7:	74 eb                	je     f01055b4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01055c9:	0f b6 00             	movzbl (%eax),%eax
f01055cc:	0f b6 12             	movzbl (%edx),%edx
f01055cf:	29 d0                	sub    %edx,%eax
}
f01055d1:	5b                   	pop    %ebx
f01055d2:	5d                   	pop    %ebp
f01055d3:	c3                   	ret    
		return 0;
f01055d4:	b8 00 00 00 00       	mov    $0x0,%eax
f01055d9:	eb f6                	jmp    f01055d1 <strncmp+0x2e>

f01055db <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01055db:	55                   	push   %ebp
f01055dc:	89 e5                	mov    %esp,%ebp
f01055de:	8b 45 08             	mov    0x8(%ebp),%eax
f01055e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01055e5:	0f b6 10             	movzbl (%eax),%edx
f01055e8:	84 d2                	test   %dl,%dl
f01055ea:	74 09                	je     f01055f5 <strchr+0x1a>
		if (*s == c)
f01055ec:	38 ca                	cmp    %cl,%dl
f01055ee:	74 0a                	je     f01055fa <strchr+0x1f>
	for (; *s; s++)
f01055f0:	83 c0 01             	add    $0x1,%eax
f01055f3:	eb f0                	jmp    f01055e5 <strchr+0xa>
			return (char *) s;
	return 0;
f01055f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01055fa:	5d                   	pop    %ebp
f01055fb:	c3                   	ret    

f01055fc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01055fc:	55                   	push   %ebp
f01055fd:	89 e5                	mov    %esp,%ebp
f01055ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0105602:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105606:	eb 03                	jmp    f010560b <strfind+0xf>
f0105608:	83 c0 01             	add    $0x1,%eax
f010560b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010560e:	38 ca                	cmp    %cl,%dl
f0105610:	74 04                	je     f0105616 <strfind+0x1a>
f0105612:	84 d2                	test   %dl,%dl
f0105614:	75 f2                	jne    f0105608 <strfind+0xc>
			break;
	return (char *) s;
}
f0105616:	5d                   	pop    %ebp
f0105617:	c3                   	ret    

f0105618 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105618:	55                   	push   %ebp
f0105619:	89 e5                	mov    %esp,%ebp
f010561b:	57                   	push   %edi
f010561c:	56                   	push   %esi
f010561d:	53                   	push   %ebx
f010561e:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105621:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105624:	85 c9                	test   %ecx,%ecx
f0105626:	74 13                	je     f010563b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105628:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010562e:	75 05                	jne    f0105635 <memset+0x1d>
f0105630:	f6 c1 03             	test   $0x3,%cl
f0105633:	74 0d                	je     f0105642 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105635:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105638:	fc                   	cld    
f0105639:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010563b:	89 f8                	mov    %edi,%eax
f010563d:	5b                   	pop    %ebx
f010563e:	5e                   	pop    %esi
f010563f:	5f                   	pop    %edi
f0105640:	5d                   	pop    %ebp
f0105641:	c3                   	ret    
		c &= 0xFF;
f0105642:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105646:	89 d3                	mov    %edx,%ebx
f0105648:	c1 e3 08             	shl    $0x8,%ebx
f010564b:	89 d0                	mov    %edx,%eax
f010564d:	c1 e0 18             	shl    $0x18,%eax
f0105650:	89 d6                	mov    %edx,%esi
f0105652:	c1 e6 10             	shl    $0x10,%esi
f0105655:	09 f0                	or     %esi,%eax
f0105657:	09 c2                	or     %eax,%edx
f0105659:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f010565b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f010565e:	89 d0                	mov    %edx,%eax
f0105660:	fc                   	cld    
f0105661:	f3 ab                	rep stos %eax,%es:(%edi)
f0105663:	eb d6                	jmp    f010563b <memset+0x23>

f0105665 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105665:	55                   	push   %ebp
f0105666:	89 e5                	mov    %esp,%ebp
f0105668:	57                   	push   %edi
f0105669:	56                   	push   %esi
f010566a:	8b 45 08             	mov    0x8(%ebp),%eax
f010566d:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105670:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105673:	39 c6                	cmp    %eax,%esi
f0105675:	73 35                	jae    f01056ac <memmove+0x47>
f0105677:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010567a:	39 c2                	cmp    %eax,%edx
f010567c:	76 2e                	jbe    f01056ac <memmove+0x47>
		s += n;
		d += n;
f010567e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105681:	89 d6                	mov    %edx,%esi
f0105683:	09 fe                	or     %edi,%esi
f0105685:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010568b:	74 0c                	je     f0105699 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010568d:	83 ef 01             	sub    $0x1,%edi
f0105690:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105693:	fd                   	std    
f0105694:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105696:	fc                   	cld    
f0105697:	eb 21                	jmp    f01056ba <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105699:	f6 c1 03             	test   $0x3,%cl
f010569c:	75 ef                	jne    f010568d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f010569e:	83 ef 04             	sub    $0x4,%edi
f01056a1:	8d 72 fc             	lea    -0x4(%edx),%esi
f01056a4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f01056a7:	fd                   	std    
f01056a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01056aa:	eb ea                	jmp    f0105696 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01056ac:	89 f2                	mov    %esi,%edx
f01056ae:	09 c2                	or     %eax,%edx
f01056b0:	f6 c2 03             	test   $0x3,%dl
f01056b3:	74 09                	je     f01056be <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f01056b5:	89 c7                	mov    %eax,%edi
f01056b7:	fc                   	cld    
f01056b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f01056ba:	5e                   	pop    %esi
f01056bb:	5f                   	pop    %edi
f01056bc:	5d                   	pop    %ebp
f01056bd:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01056be:	f6 c1 03             	test   $0x3,%cl
f01056c1:	75 f2                	jne    f01056b5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01056c3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f01056c6:	89 c7                	mov    %eax,%edi
f01056c8:	fc                   	cld    
f01056c9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01056cb:	eb ed                	jmp    f01056ba <memmove+0x55>

f01056cd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01056cd:	55                   	push   %ebp
f01056ce:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f01056d0:	ff 75 10             	pushl  0x10(%ebp)
f01056d3:	ff 75 0c             	pushl  0xc(%ebp)
f01056d6:	ff 75 08             	pushl  0x8(%ebp)
f01056d9:	e8 87 ff ff ff       	call   f0105665 <memmove>
}
f01056de:	c9                   	leave  
f01056df:	c3                   	ret    

f01056e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01056e0:	55                   	push   %ebp
f01056e1:	89 e5                	mov    %esp,%ebp
f01056e3:	56                   	push   %esi
f01056e4:	53                   	push   %ebx
f01056e5:	8b 45 08             	mov    0x8(%ebp),%eax
f01056e8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01056eb:	89 c6                	mov    %eax,%esi
f01056ed:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01056f0:	39 f0                	cmp    %esi,%eax
f01056f2:	74 1c                	je     f0105710 <memcmp+0x30>
		if (*s1 != *s2)
f01056f4:	0f b6 08             	movzbl (%eax),%ecx
f01056f7:	0f b6 1a             	movzbl (%edx),%ebx
f01056fa:	38 d9                	cmp    %bl,%cl
f01056fc:	75 08                	jne    f0105706 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01056fe:	83 c0 01             	add    $0x1,%eax
f0105701:	83 c2 01             	add    $0x1,%edx
f0105704:	eb ea                	jmp    f01056f0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0105706:	0f b6 c1             	movzbl %cl,%eax
f0105709:	0f b6 db             	movzbl %bl,%ebx
f010570c:	29 d8                	sub    %ebx,%eax
f010570e:	eb 05                	jmp    f0105715 <memcmp+0x35>
	}

	return 0;
f0105710:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105715:	5b                   	pop    %ebx
f0105716:	5e                   	pop    %esi
f0105717:	5d                   	pop    %ebp
f0105718:	c3                   	ret    

f0105719 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105719:	55                   	push   %ebp
f010571a:	89 e5                	mov    %esp,%ebp
f010571c:	8b 45 08             	mov    0x8(%ebp),%eax
f010571f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105722:	89 c2                	mov    %eax,%edx
f0105724:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105727:	39 d0                	cmp    %edx,%eax
f0105729:	73 09                	jae    f0105734 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f010572b:	38 08                	cmp    %cl,(%eax)
f010572d:	74 05                	je     f0105734 <memfind+0x1b>
	for (; s < ends; s++)
f010572f:	83 c0 01             	add    $0x1,%eax
f0105732:	eb f3                	jmp    f0105727 <memfind+0xe>
			break;
	return (void *) s;
}
f0105734:	5d                   	pop    %ebp
f0105735:	c3                   	ret    

f0105736 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105736:	55                   	push   %ebp
f0105737:	89 e5                	mov    %esp,%ebp
f0105739:	57                   	push   %edi
f010573a:	56                   	push   %esi
f010573b:	53                   	push   %ebx
f010573c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010573f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105742:	eb 03                	jmp    f0105747 <strtol+0x11>
		s++;
f0105744:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105747:	0f b6 01             	movzbl (%ecx),%eax
f010574a:	3c 20                	cmp    $0x20,%al
f010574c:	74 f6                	je     f0105744 <strtol+0xe>
f010574e:	3c 09                	cmp    $0x9,%al
f0105750:	74 f2                	je     f0105744 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0105752:	3c 2b                	cmp    $0x2b,%al
f0105754:	74 2e                	je     f0105784 <strtol+0x4e>
	int neg = 0;
f0105756:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f010575b:	3c 2d                	cmp    $0x2d,%al
f010575d:	74 2f                	je     f010578e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010575f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105765:	75 05                	jne    f010576c <strtol+0x36>
f0105767:	80 39 30             	cmpb   $0x30,(%ecx)
f010576a:	74 2c                	je     f0105798 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f010576c:	85 db                	test   %ebx,%ebx
f010576e:	75 0a                	jne    f010577a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105770:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f0105775:	80 39 30             	cmpb   $0x30,(%ecx)
f0105778:	74 28                	je     f01057a2 <strtol+0x6c>
		base = 10;
f010577a:	b8 00 00 00 00       	mov    $0x0,%eax
f010577f:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105782:	eb 50                	jmp    f01057d4 <strtol+0x9e>
		s++;
f0105784:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105787:	bf 00 00 00 00       	mov    $0x0,%edi
f010578c:	eb d1                	jmp    f010575f <strtol+0x29>
		s++, neg = 1;
f010578e:	83 c1 01             	add    $0x1,%ecx
f0105791:	bf 01 00 00 00       	mov    $0x1,%edi
f0105796:	eb c7                	jmp    f010575f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105798:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010579c:	74 0e                	je     f01057ac <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f010579e:	85 db                	test   %ebx,%ebx
f01057a0:	75 d8                	jne    f010577a <strtol+0x44>
		s++, base = 8;
f01057a2:	83 c1 01             	add    $0x1,%ecx
f01057a5:	bb 08 00 00 00       	mov    $0x8,%ebx
f01057aa:	eb ce                	jmp    f010577a <strtol+0x44>
		s += 2, base = 16;
f01057ac:	83 c1 02             	add    $0x2,%ecx
f01057af:	bb 10 00 00 00       	mov    $0x10,%ebx
f01057b4:	eb c4                	jmp    f010577a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f01057b6:	8d 72 9f             	lea    -0x61(%edx),%esi
f01057b9:	89 f3                	mov    %esi,%ebx
f01057bb:	80 fb 19             	cmp    $0x19,%bl
f01057be:	77 29                	ja     f01057e9 <strtol+0xb3>
			dig = *s - 'a' + 10;
f01057c0:	0f be d2             	movsbl %dl,%edx
f01057c3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f01057c6:	3b 55 10             	cmp    0x10(%ebp),%edx
f01057c9:	7d 30                	jge    f01057fb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f01057cb:	83 c1 01             	add    $0x1,%ecx
f01057ce:	0f af 45 10          	imul   0x10(%ebp),%eax
f01057d2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f01057d4:	0f b6 11             	movzbl (%ecx),%edx
f01057d7:	8d 72 d0             	lea    -0x30(%edx),%esi
f01057da:	89 f3                	mov    %esi,%ebx
f01057dc:	80 fb 09             	cmp    $0x9,%bl
f01057df:	77 d5                	ja     f01057b6 <strtol+0x80>
			dig = *s - '0';
f01057e1:	0f be d2             	movsbl %dl,%edx
f01057e4:	83 ea 30             	sub    $0x30,%edx
f01057e7:	eb dd                	jmp    f01057c6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f01057e9:	8d 72 bf             	lea    -0x41(%edx),%esi
f01057ec:	89 f3                	mov    %esi,%ebx
f01057ee:	80 fb 19             	cmp    $0x19,%bl
f01057f1:	77 08                	ja     f01057fb <strtol+0xc5>
			dig = *s - 'A' + 10;
f01057f3:	0f be d2             	movsbl %dl,%edx
f01057f6:	83 ea 37             	sub    $0x37,%edx
f01057f9:	eb cb                	jmp    f01057c6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f01057fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01057ff:	74 05                	je     f0105806 <strtol+0xd0>
		*endptr = (char *) s;
f0105801:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105804:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105806:	89 c2                	mov    %eax,%edx
f0105808:	f7 da                	neg    %edx
f010580a:	85 ff                	test   %edi,%edi
f010580c:	0f 45 c2             	cmovne %edx,%eax
}
f010580f:	5b                   	pop    %ebx
f0105810:	5e                   	pop    %esi
f0105811:	5f                   	pop    %edi
f0105812:	5d                   	pop    %ebp
f0105813:	c3                   	ret    
f0105814:	66 90                	xchg   %ax,%ax
f0105816:	66 90                	xchg   %ax,%ax
f0105818:	66 90                	xchg   %ax,%ax
f010581a:	66 90                	xchg   %ax,%ax
f010581c:	66 90                	xchg   %ax,%ax
f010581e:	66 90                	xchg   %ax,%ax

f0105820 <__udivdi3>:
f0105820:	55                   	push   %ebp
f0105821:	57                   	push   %edi
f0105822:	56                   	push   %esi
f0105823:	53                   	push   %ebx
f0105824:	83 ec 1c             	sub    $0x1c,%esp
f0105827:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010582b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010582f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0105833:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0105837:	85 d2                	test   %edx,%edx
f0105839:	75 35                	jne    f0105870 <__udivdi3+0x50>
f010583b:	39 f3                	cmp    %esi,%ebx
f010583d:	0f 87 bd 00 00 00    	ja     f0105900 <__udivdi3+0xe0>
f0105843:	85 db                	test   %ebx,%ebx
f0105845:	89 d9                	mov    %ebx,%ecx
f0105847:	75 0b                	jne    f0105854 <__udivdi3+0x34>
f0105849:	b8 01 00 00 00       	mov    $0x1,%eax
f010584e:	31 d2                	xor    %edx,%edx
f0105850:	f7 f3                	div    %ebx
f0105852:	89 c1                	mov    %eax,%ecx
f0105854:	31 d2                	xor    %edx,%edx
f0105856:	89 f0                	mov    %esi,%eax
f0105858:	f7 f1                	div    %ecx
f010585a:	89 c6                	mov    %eax,%esi
f010585c:	89 e8                	mov    %ebp,%eax
f010585e:	89 f7                	mov    %esi,%edi
f0105860:	f7 f1                	div    %ecx
f0105862:	89 fa                	mov    %edi,%edx
f0105864:	83 c4 1c             	add    $0x1c,%esp
f0105867:	5b                   	pop    %ebx
f0105868:	5e                   	pop    %esi
f0105869:	5f                   	pop    %edi
f010586a:	5d                   	pop    %ebp
f010586b:	c3                   	ret    
f010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105870:	39 f2                	cmp    %esi,%edx
f0105872:	77 7c                	ja     f01058f0 <__udivdi3+0xd0>
f0105874:	0f bd fa             	bsr    %edx,%edi
f0105877:	83 f7 1f             	xor    $0x1f,%edi
f010587a:	0f 84 98 00 00 00    	je     f0105918 <__udivdi3+0xf8>
f0105880:	89 f9                	mov    %edi,%ecx
f0105882:	b8 20 00 00 00       	mov    $0x20,%eax
f0105887:	29 f8                	sub    %edi,%eax
f0105889:	d3 e2                	shl    %cl,%edx
f010588b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010588f:	89 c1                	mov    %eax,%ecx
f0105891:	89 da                	mov    %ebx,%edx
f0105893:	d3 ea                	shr    %cl,%edx
f0105895:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105899:	09 d1                	or     %edx,%ecx
f010589b:	89 f2                	mov    %esi,%edx
f010589d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01058a1:	89 f9                	mov    %edi,%ecx
f01058a3:	d3 e3                	shl    %cl,%ebx
f01058a5:	89 c1                	mov    %eax,%ecx
f01058a7:	d3 ea                	shr    %cl,%edx
f01058a9:	89 f9                	mov    %edi,%ecx
f01058ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01058af:	d3 e6                	shl    %cl,%esi
f01058b1:	89 eb                	mov    %ebp,%ebx
f01058b3:	89 c1                	mov    %eax,%ecx
f01058b5:	d3 eb                	shr    %cl,%ebx
f01058b7:	09 de                	or     %ebx,%esi
f01058b9:	89 f0                	mov    %esi,%eax
f01058bb:	f7 74 24 08          	divl   0x8(%esp)
f01058bf:	89 d6                	mov    %edx,%esi
f01058c1:	89 c3                	mov    %eax,%ebx
f01058c3:	f7 64 24 0c          	mull   0xc(%esp)
f01058c7:	39 d6                	cmp    %edx,%esi
f01058c9:	72 0c                	jb     f01058d7 <__udivdi3+0xb7>
f01058cb:	89 f9                	mov    %edi,%ecx
f01058cd:	d3 e5                	shl    %cl,%ebp
f01058cf:	39 c5                	cmp    %eax,%ebp
f01058d1:	73 5d                	jae    f0105930 <__udivdi3+0x110>
f01058d3:	39 d6                	cmp    %edx,%esi
f01058d5:	75 59                	jne    f0105930 <__udivdi3+0x110>
f01058d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01058da:	31 ff                	xor    %edi,%edi
f01058dc:	89 fa                	mov    %edi,%edx
f01058de:	83 c4 1c             	add    $0x1c,%esp
f01058e1:	5b                   	pop    %ebx
f01058e2:	5e                   	pop    %esi
f01058e3:	5f                   	pop    %edi
f01058e4:	5d                   	pop    %ebp
f01058e5:	c3                   	ret    
f01058e6:	8d 76 00             	lea    0x0(%esi),%esi
f01058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f01058f0:	31 ff                	xor    %edi,%edi
f01058f2:	31 c0                	xor    %eax,%eax
f01058f4:	89 fa                	mov    %edi,%edx
f01058f6:	83 c4 1c             	add    $0x1c,%esp
f01058f9:	5b                   	pop    %ebx
f01058fa:	5e                   	pop    %esi
f01058fb:	5f                   	pop    %edi
f01058fc:	5d                   	pop    %ebp
f01058fd:	c3                   	ret    
f01058fe:	66 90                	xchg   %ax,%ax
f0105900:	31 ff                	xor    %edi,%edi
f0105902:	89 e8                	mov    %ebp,%eax
f0105904:	89 f2                	mov    %esi,%edx
f0105906:	f7 f3                	div    %ebx
f0105908:	89 fa                	mov    %edi,%edx
f010590a:	83 c4 1c             	add    $0x1c,%esp
f010590d:	5b                   	pop    %ebx
f010590e:	5e                   	pop    %esi
f010590f:	5f                   	pop    %edi
f0105910:	5d                   	pop    %ebp
f0105911:	c3                   	ret    
f0105912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105918:	39 f2                	cmp    %esi,%edx
f010591a:	72 06                	jb     f0105922 <__udivdi3+0x102>
f010591c:	31 c0                	xor    %eax,%eax
f010591e:	39 eb                	cmp    %ebp,%ebx
f0105920:	77 d2                	ja     f01058f4 <__udivdi3+0xd4>
f0105922:	b8 01 00 00 00       	mov    $0x1,%eax
f0105927:	eb cb                	jmp    f01058f4 <__udivdi3+0xd4>
f0105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105930:	89 d8                	mov    %ebx,%eax
f0105932:	31 ff                	xor    %edi,%edi
f0105934:	eb be                	jmp    f01058f4 <__udivdi3+0xd4>
f0105936:	66 90                	xchg   %ax,%ax
f0105938:	66 90                	xchg   %ax,%ax
f010593a:	66 90                	xchg   %ax,%ax
f010593c:	66 90                	xchg   %ax,%ax
f010593e:	66 90                	xchg   %ax,%ax

f0105940 <__umoddi3>:
f0105940:	55                   	push   %ebp
f0105941:	57                   	push   %edi
f0105942:	56                   	push   %esi
f0105943:	53                   	push   %ebx
f0105944:	83 ec 1c             	sub    $0x1c,%esp
f0105947:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f010594b:	8b 74 24 30          	mov    0x30(%esp),%esi
f010594f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0105953:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0105957:	85 ed                	test   %ebp,%ebp
f0105959:	89 f0                	mov    %esi,%eax
f010595b:	89 da                	mov    %ebx,%edx
f010595d:	75 19                	jne    f0105978 <__umoddi3+0x38>
f010595f:	39 df                	cmp    %ebx,%edi
f0105961:	0f 86 b1 00 00 00    	jbe    f0105a18 <__umoddi3+0xd8>
f0105967:	f7 f7                	div    %edi
f0105969:	89 d0                	mov    %edx,%eax
f010596b:	31 d2                	xor    %edx,%edx
f010596d:	83 c4 1c             	add    $0x1c,%esp
f0105970:	5b                   	pop    %ebx
f0105971:	5e                   	pop    %esi
f0105972:	5f                   	pop    %edi
f0105973:	5d                   	pop    %ebp
f0105974:	c3                   	ret    
f0105975:	8d 76 00             	lea    0x0(%esi),%esi
f0105978:	39 dd                	cmp    %ebx,%ebp
f010597a:	77 f1                	ja     f010596d <__umoddi3+0x2d>
f010597c:	0f bd cd             	bsr    %ebp,%ecx
f010597f:	83 f1 1f             	xor    $0x1f,%ecx
f0105982:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105986:	0f 84 b4 00 00 00    	je     f0105a40 <__umoddi3+0x100>
f010598c:	b8 20 00 00 00       	mov    $0x20,%eax
f0105991:	89 c2                	mov    %eax,%edx
f0105993:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105997:	29 c2                	sub    %eax,%edx
f0105999:	89 c1                	mov    %eax,%ecx
f010599b:	89 f8                	mov    %edi,%eax
f010599d:	d3 e5                	shl    %cl,%ebp
f010599f:	89 d1                	mov    %edx,%ecx
f01059a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01059a5:	d3 e8                	shr    %cl,%eax
f01059a7:	09 c5                	or     %eax,%ebp
f01059a9:	8b 44 24 04          	mov    0x4(%esp),%eax
f01059ad:	89 c1                	mov    %eax,%ecx
f01059af:	d3 e7                	shl    %cl,%edi
f01059b1:	89 d1                	mov    %edx,%ecx
f01059b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01059b7:	89 df                	mov    %ebx,%edi
f01059b9:	d3 ef                	shr    %cl,%edi
f01059bb:	89 c1                	mov    %eax,%ecx
f01059bd:	89 f0                	mov    %esi,%eax
f01059bf:	d3 e3                	shl    %cl,%ebx
f01059c1:	89 d1                	mov    %edx,%ecx
f01059c3:	89 fa                	mov    %edi,%edx
f01059c5:	d3 e8                	shr    %cl,%eax
f01059c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01059cc:	09 d8                	or     %ebx,%eax
f01059ce:	f7 f5                	div    %ebp
f01059d0:	d3 e6                	shl    %cl,%esi
f01059d2:	89 d1                	mov    %edx,%ecx
f01059d4:	f7 64 24 08          	mull   0x8(%esp)
f01059d8:	39 d1                	cmp    %edx,%ecx
f01059da:	89 c3                	mov    %eax,%ebx
f01059dc:	89 d7                	mov    %edx,%edi
f01059de:	72 06                	jb     f01059e6 <__umoddi3+0xa6>
f01059e0:	75 0e                	jne    f01059f0 <__umoddi3+0xb0>
f01059e2:	39 c6                	cmp    %eax,%esi
f01059e4:	73 0a                	jae    f01059f0 <__umoddi3+0xb0>
f01059e6:	2b 44 24 08          	sub    0x8(%esp),%eax
f01059ea:	19 ea                	sbb    %ebp,%edx
f01059ec:	89 d7                	mov    %edx,%edi
f01059ee:	89 c3                	mov    %eax,%ebx
f01059f0:	89 ca                	mov    %ecx,%edx
f01059f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f01059f7:	29 de                	sub    %ebx,%esi
f01059f9:	19 fa                	sbb    %edi,%edx
f01059fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f01059ff:	89 d0                	mov    %edx,%eax
f0105a01:	d3 e0                	shl    %cl,%eax
f0105a03:	89 d9                	mov    %ebx,%ecx
f0105a05:	d3 ee                	shr    %cl,%esi
f0105a07:	d3 ea                	shr    %cl,%edx
f0105a09:	09 f0                	or     %esi,%eax
f0105a0b:	83 c4 1c             	add    $0x1c,%esp
f0105a0e:	5b                   	pop    %ebx
f0105a0f:	5e                   	pop    %esi
f0105a10:	5f                   	pop    %edi
f0105a11:	5d                   	pop    %ebp
f0105a12:	c3                   	ret    
f0105a13:	90                   	nop
f0105a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105a18:	85 ff                	test   %edi,%edi
f0105a1a:	89 f9                	mov    %edi,%ecx
f0105a1c:	75 0b                	jne    f0105a29 <__umoddi3+0xe9>
f0105a1e:	b8 01 00 00 00       	mov    $0x1,%eax
f0105a23:	31 d2                	xor    %edx,%edx
f0105a25:	f7 f7                	div    %edi
f0105a27:	89 c1                	mov    %eax,%ecx
f0105a29:	89 d8                	mov    %ebx,%eax
f0105a2b:	31 d2                	xor    %edx,%edx
f0105a2d:	f7 f1                	div    %ecx
f0105a2f:	89 f0                	mov    %esi,%eax
f0105a31:	f7 f1                	div    %ecx
f0105a33:	e9 31 ff ff ff       	jmp    f0105969 <__umoddi3+0x29>
f0105a38:	90                   	nop
f0105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105a40:	39 dd                	cmp    %ebx,%ebp
f0105a42:	72 08                	jb     f0105a4c <__umoddi3+0x10c>
f0105a44:	39 f7                	cmp    %esi,%edi
f0105a46:	0f 87 21 ff ff ff    	ja     f010596d <__umoddi3+0x2d>
f0105a4c:	89 da                	mov    %ebx,%edx
f0105a4e:	89 f0                	mov    %esi,%eax
f0105a50:	29 f8                	sub    %edi,%eax
f0105a52:	19 ea                	sbb    %ebp,%edx
f0105a54:	e9 14 ff ff ff       	jmp    f010596d <__umoddi3+0x2d>
