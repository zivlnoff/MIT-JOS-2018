
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
f0100015:	b8 00 00 12 00       	mov    $0x120000,%eax
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
f0100034:	bc 00 00 12 f0       	mov    $0xf0120000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 84 4e 23 f0 00 	cmpl   $0x0,0xf0234e84
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 97 08 00 00       	call   f01008f2 <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 84 4e 23 f0    	mov    %esi,0xf0234e84
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 6b 5c 00 00       	call   f0105cdb <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 40 63 10 f0       	push   $0xf0106340
f010007c:	e8 fe 3a 00 00       	call   f0103b7f <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 ce 3a 00 00       	call   f0103b59 <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 66 7a 10 f0 	movl   $0xf0107a66,(%esp)
f0100092:	e8 e8 3a 00 00       	call   f0103b7f <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 9a 05 00 00       	call   f0100642 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 ac 63 10 f0       	push   $0xf01063ac
f01000b5:	e8 c5 3a 00 00       	call   f0103b7f <cprintf>
	mem_init();
f01000ba:	e8 d7 12 00 00       	call   f0101396 <mem_init>
	env_init();
f01000bf:	e8 36 32 00 00       	call   f01032fa <env_init>
	trap_init();
f01000c4:	e8 69 3c 00 00       	call   f0103d32 <trap_init>
	mp_init();
f01000c9:	e8 fb 58 00 00       	call   f01059c9 <mp_init>
	lapic_init();
f01000ce:	e8 22 5c 00 00       	call   f0105cf5 <lapic_init>
	pic_init();
f01000d3:	e8 ca 39 00 00       	call   f0103aa2 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000d8:	c7 04 24 c0 23 12 f0 	movl   $0xf01223c0,(%esp)
f01000df:	e8 79 5e 00 00       	call   f0105f5d <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000e4:	83 c4 10             	add    $0x10,%esp
f01000e7:	83 3d 8c 4e 23 f0 07 	cmpl   $0x7,0xf0234e8c
f01000ee:	76 27                	jbe    f0100117 <i386_init+0x7b>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000f0:	83 ec 04             	sub    $0x4,%esp
f01000f3:	b8 2e 59 10 f0       	mov    $0xf010592e,%eax
f01000f8:	2d b4 58 10 f0       	sub    $0xf01058b4,%eax
f01000fd:	50                   	push   %eax
f01000fe:	68 b4 58 10 f0       	push   $0xf01058b4
f0100103:	68 00 70 00 f0       	push   $0xf0007000
f0100108:	e8 f8 55 00 00       	call   f0105705 <memmove>
f010010d:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100110:	bb 20 50 23 f0       	mov    $0xf0235020,%ebx
f0100115:	eb 19                	jmp    f0100130 <i386_init+0x94>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100117:	68 00 70 00 00       	push   $0x7000
f010011c:	68 64 63 10 f0       	push   $0xf0106364
f0100121:	6a 50                	push   $0x50
f0100123:	68 c7 63 10 f0       	push   $0xf01063c7
f0100128:	e8 13 ff ff ff       	call   f0100040 <_panic>
f010012d:	83 c3 74             	add    $0x74,%ebx
f0100130:	6b 05 c4 53 23 f0 74 	imul   $0x74,0xf02353c4,%eax
f0100137:	05 20 50 23 f0       	add    $0xf0235020,%eax
f010013c:	39 c3                	cmp    %eax,%ebx
f010013e:	73 4c                	jae    f010018c <i386_init+0xf0>
		if (c == cpus + cpunum())  // We've started already.
f0100140:	e8 96 5b 00 00       	call   f0105cdb <cpunum>
f0100145:	6b c0 74             	imul   $0x74,%eax,%eax
f0100148:	05 20 50 23 f0       	add    $0xf0235020,%eax
f010014d:	39 c3                	cmp    %eax,%ebx
f010014f:	74 dc                	je     f010012d <i386_init+0x91>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100151:	89 d8                	mov    %ebx,%eax
f0100153:	2d 20 50 23 f0       	sub    $0xf0235020,%eax
f0100158:	c1 f8 02             	sar    $0x2,%eax
f010015b:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100161:	c1 e0 0f             	shl    $0xf,%eax
f0100164:	05 00 e0 23 f0       	add    $0xf023e000,%eax
f0100169:	a3 88 4e 23 f0       	mov    %eax,0xf0234e88
		lapic_startap(c->cpu_id, PADDR(code));
f010016e:	83 ec 08             	sub    $0x8,%esp
f0100171:	68 00 70 00 00       	push   $0x7000
f0100176:	0f b6 03             	movzbl (%ebx),%eax
f0100179:	50                   	push   %eax
f010017a:	e8 c7 5c 00 00       	call   f0105e46 <lapic_startap>
f010017f:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f0100182:	8b 43 04             	mov    0x4(%ebx),%eax
f0100185:	83 f8 01             	cmp    $0x1,%eax
f0100188:	75 f8                	jne    f0100182 <i386_init+0xe6>
f010018a:	eb a1                	jmp    f010012d <i386_init+0x91>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f010018c:	83 ec 08             	sub    $0x8,%esp
f010018f:	6a 00                	push   $0x0
f0100191:	68 78 10 1f f0       	push   $0xf01f1078
f0100196:	e8 98 33 00 00       	call   f0103533 <env_create>
	sched_yield();
f010019b:	e8 cf 43 00 00       	call   f010456f <sched_yield>

f01001a0 <mp_main>:
{
f01001a0:	55                   	push   %ebp
f01001a1:	89 e5                	mov    %esp,%ebp
f01001a3:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001a6:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f01001ab:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001b0:	77 12                	ja     f01001c4 <mp_main+0x24>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01001b2:	50                   	push   %eax
f01001b3:	68 88 63 10 f0       	push   $0xf0106388
f01001b8:	6a 67                	push   $0x67
f01001ba:	68 c7 63 10 f0       	push   $0xf01063c7
f01001bf:	e8 7c fe ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01001c4:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001c9:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001cc:	e8 0a 5b 00 00       	call   f0105cdb <cpunum>
f01001d1:	83 ec 08             	sub    $0x8,%esp
f01001d4:	50                   	push   %eax
f01001d5:	68 d3 63 10 f0       	push   $0xf01063d3
f01001da:	e8 a0 39 00 00       	call   f0103b7f <cprintf>
	lapic_init();
f01001df:	e8 11 5b 00 00       	call   f0105cf5 <lapic_init>
	env_init_percpu();
f01001e4:	e8 e1 30 00 00       	call   f01032ca <env_init_percpu>
	trap_init_percpu();
f01001e9:	e8 c6 39 00 00       	call   f0103bb4 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001ee:	e8 e8 5a 00 00       	call   f0105cdb <cpunum>
f01001f3:	6b d0 74             	imul   $0x74,%eax,%edx
f01001f6:	83 c2 04             	add    $0x4,%edx
{
	uint32_t result;

	//todo understand
	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01001f9:	b8 01 00 00 00       	mov    $0x1,%eax
f01001fe:	f0 87 82 20 50 23 f0 	lock xchg %eax,-0xfdcafe0(%edx)
f0100205:	c7 04 24 c0 23 12 f0 	movl   $0xf01223c0,(%esp)
f010020c:	e8 4c 5d 00 00       	call   f0105f5d <spin_lock>
    sched_yield();
f0100211:	e8 59 43 00 00       	call   f010456f <sched_yield>

f0100216 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100216:	55                   	push   %ebp
f0100217:	89 e5                	mov    %esp,%ebp
f0100219:	53                   	push   %ebx
f010021a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010021d:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100220:	ff 75 0c             	pushl  0xc(%ebp)
f0100223:	ff 75 08             	pushl  0x8(%ebp)
f0100226:	68 e9 63 10 f0       	push   $0xf01063e9
f010022b:	e8 4f 39 00 00       	call   f0103b7f <cprintf>
	vcprintf(fmt, ap);
f0100230:	83 c4 08             	add    $0x8,%esp
f0100233:	53                   	push   %ebx
f0100234:	ff 75 10             	pushl  0x10(%ebp)
f0100237:	e8 1d 39 00 00       	call   f0103b59 <vcprintf>
	cprintf("\n");
f010023c:	c7 04 24 66 7a 10 f0 	movl   $0xf0107a66,(%esp)
f0100243:	e8 37 39 00 00       	call   f0103b7f <cprintf>
	va_end(ap);
}
f0100248:	83 c4 10             	add    $0x10,%esp
f010024b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010024e:	c9                   	leave  
f010024f:	c3                   	ret    

f0100250 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100250:	55                   	push   %ebp
f0100251:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100253:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100258:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100259:	a8 01                	test   $0x1,%al
f010025b:	74 0b                	je     f0100268 <serial_proc_data+0x18>
f010025d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100262:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100263:	0f b6 c0             	movzbl %al,%eax
}
f0100266:	5d                   	pop    %ebp
f0100267:	c3                   	ret    
		return -1;
f0100268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010026d:	eb f7                	jmp    f0100266 <serial_proc_data+0x16>

f010026f <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010026f:	55                   	push   %ebp
f0100270:	89 e5                	mov    %esp,%ebp
f0100272:	53                   	push   %ebx
f0100273:	83 ec 04             	sub    $0x4,%esp
f0100276:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100278:	ff d3                	call   *%ebx
f010027a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010027d:	74 2d                	je     f01002ac <cons_intr+0x3d>
		if (c == 0)
f010027f:	85 c0                	test   %eax,%eax
f0100281:	74 f5                	je     f0100278 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100283:	8b 0d 24 42 23 f0    	mov    0xf0234224,%ecx
f0100289:	8d 51 01             	lea    0x1(%ecx),%edx
f010028c:	89 15 24 42 23 f0    	mov    %edx,0xf0234224
f0100292:	88 81 20 40 23 f0    	mov    %al,-0xfdcbfe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100298:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010029e:	75 d8                	jne    f0100278 <cons_intr+0x9>
			cons.wpos = 0;
f01002a0:	c7 05 24 42 23 f0 00 	movl   $0x0,0xf0234224
f01002a7:	00 00 00 
f01002aa:	eb cc                	jmp    f0100278 <cons_intr+0x9>
	}
}
f01002ac:	83 c4 04             	add    $0x4,%esp
f01002af:	5b                   	pop    %ebx
f01002b0:	5d                   	pop    %ebp
f01002b1:	c3                   	ret    

f01002b2 <kbd_proc_data>:
{
f01002b2:	55                   	push   %ebp
f01002b3:	89 e5                	mov    %esp,%ebp
f01002b5:	53                   	push   %ebx
f01002b6:	83 ec 04             	sub    $0x4,%esp
f01002b9:	ba 64 00 00 00       	mov    $0x64,%edx
f01002be:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002bf:	a8 01                	test   $0x1,%al
f01002c1:	0f 84 fa 00 00 00    	je     f01003c1 <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01002c7:	a8 20                	test   $0x20,%al
f01002c9:	0f 85 f9 00 00 00    	jne    f01003c8 <kbd_proc_data+0x116>
f01002cf:	ba 60 00 00 00       	mov    $0x60,%edx
f01002d4:	ec                   	in     (%dx),%al
f01002d5:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002d7:	3c e0                	cmp    $0xe0,%al
f01002d9:	0f 84 8e 00 00 00    	je     f010036d <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f01002df:	84 c0                	test   %al,%al
f01002e1:	0f 88 99 00 00 00    	js     f0100380 <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f01002e7:	8b 0d 00 40 23 f0    	mov    0xf0234000,%ecx
f01002ed:	f6 c1 40             	test   $0x40,%cl
f01002f0:	74 0e                	je     f0100300 <kbd_proc_data+0x4e>
		data |= 0x80;
f01002f2:	83 c8 80             	or     $0xffffff80,%eax
f01002f5:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002f7:	83 e1 bf             	and    $0xffffffbf,%ecx
f01002fa:	89 0d 00 40 23 f0    	mov    %ecx,0xf0234000
	shift |= shiftcode[data];
f0100300:	0f b6 d2             	movzbl %dl,%edx
f0100303:	0f b6 82 60 65 10 f0 	movzbl -0xfef9aa0(%edx),%eax
f010030a:	0b 05 00 40 23 f0    	or     0xf0234000,%eax
	shift ^= togglecode[data];
f0100310:	0f b6 8a 60 64 10 f0 	movzbl -0xfef9ba0(%edx),%ecx
f0100317:	31 c8                	xor    %ecx,%eax
f0100319:	a3 00 40 23 f0       	mov    %eax,0xf0234000
	c = charcode[shift & (CTL | SHIFT)][data];
f010031e:	89 c1                	mov    %eax,%ecx
f0100320:	83 e1 03             	and    $0x3,%ecx
f0100323:	8b 0c 8d 40 64 10 f0 	mov    -0xfef9bc0(,%ecx,4),%ecx
f010032a:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010032e:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100331:	a8 08                	test   $0x8,%al
f0100333:	74 0d                	je     f0100342 <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f0100335:	89 da                	mov    %ebx,%edx
f0100337:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f010033a:	83 f9 19             	cmp    $0x19,%ecx
f010033d:	77 74                	ja     f01003b3 <kbd_proc_data+0x101>
			c += 'A' - 'a';
f010033f:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100342:	f7 d0                	not    %eax
f0100344:	a8 06                	test   $0x6,%al
f0100346:	75 31                	jne    f0100379 <kbd_proc_data+0xc7>
f0100348:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010034e:	75 29                	jne    f0100379 <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f0100350:	83 ec 0c             	sub    $0xc,%esp
f0100353:	68 03 64 10 f0       	push   $0xf0106403
f0100358:	e8 22 38 00 00       	call   f0103b7f <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010035d:	b8 03 00 00 00       	mov    $0x3,%eax
f0100362:	ba 92 00 00 00       	mov    $0x92,%edx
f0100367:	ee                   	out    %al,(%dx)
f0100368:	83 c4 10             	add    $0x10,%esp
f010036b:	eb 0c                	jmp    f0100379 <kbd_proc_data+0xc7>
		shift |= E0ESC;
f010036d:	83 0d 00 40 23 f0 40 	orl    $0x40,0xf0234000
		return 0;
f0100374:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100379:	89 d8                	mov    %ebx,%eax
f010037b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010037e:	c9                   	leave  
f010037f:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100380:	8b 0d 00 40 23 f0    	mov    0xf0234000,%ecx
f0100386:	89 cb                	mov    %ecx,%ebx
f0100388:	83 e3 40             	and    $0x40,%ebx
f010038b:	83 e0 7f             	and    $0x7f,%eax
f010038e:	85 db                	test   %ebx,%ebx
f0100390:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100393:	0f b6 d2             	movzbl %dl,%edx
f0100396:	0f b6 82 60 65 10 f0 	movzbl -0xfef9aa0(%edx),%eax
f010039d:	83 c8 40             	or     $0x40,%eax
f01003a0:	0f b6 c0             	movzbl %al,%eax
f01003a3:	f7 d0                	not    %eax
f01003a5:	21 c8                	and    %ecx,%eax
f01003a7:	a3 00 40 23 f0       	mov    %eax,0xf0234000
		return 0;
f01003ac:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003b1:	eb c6                	jmp    f0100379 <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f01003b3:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003b6:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003b9:	83 fa 1a             	cmp    $0x1a,%edx
f01003bc:	0f 42 d9             	cmovb  %ecx,%ebx
f01003bf:	eb 81                	jmp    f0100342 <kbd_proc_data+0x90>
		return -1;
f01003c1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003c6:	eb b1                	jmp    f0100379 <kbd_proc_data+0xc7>
		return -1;
f01003c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003cd:	eb aa                	jmp    f0100379 <kbd_proc_data+0xc7>

f01003cf <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003cf:	55                   	push   %ebp
f01003d0:	89 e5                	mov    %esp,%ebp
f01003d2:	57                   	push   %edi
f01003d3:	56                   	push   %esi
f01003d4:	53                   	push   %ebx
f01003d5:	83 ec 1c             	sub    $0x1c,%esp
f01003d8:	89 c7                	mov    %eax,%edi
	for (i = 0;
f01003da:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003df:	be fd 03 00 00       	mov    $0x3fd,%esi
f01003e4:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003e9:	eb 09                	jmp    f01003f4 <cons_putc+0x25>
f01003eb:	89 ca                	mov    %ecx,%edx
f01003ed:	ec                   	in     (%dx),%al
f01003ee:	ec                   	in     (%dx),%al
f01003ef:	ec                   	in     (%dx),%al
f01003f0:	ec                   	in     (%dx),%al
	     i++)
f01003f1:	83 c3 01             	add    $0x1,%ebx
f01003f4:	89 f2                	mov    %esi,%edx
f01003f6:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01003f7:	a8 20                	test   $0x20,%al
f01003f9:	75 08                	jne    f0100403 <cons_putc+0x34>
f01003fb:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100401:	7e e8                	jle    f01003eb <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f0100403:	89 f8                	mov    %edi,%eax
f0100405:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100408:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010040d:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010040e:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100413:	be 79 03 00 00       	mov    $0x379,%esi
f0100418:	b9 84 00 00 00       	mov    $0x84,%ecx
f010041d:	eb 09                	jmp    f0100428 <cons_putc+0x59>
f010041f:	89 ca                	mov    %ecx,%edx
f0100421:	ec                   	in     (%dx),%al
f0100422:	ec                   	in     (%dx),%al
f0100423:	ec                   	in     (%dx),%al
f0100424:	ec                   	in     (%dx),%al
f0100425:	83 c3 01             	add    $0x1,%ebx
f0100428:	89 f2                	mov    %esi,%edx
f010042a:	ec                   	in     (%dx),%al
f010042b:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100431:	7f 04                	jg     f0100437 <cons_putc+0x68>
f0100433:	84 c0                	test   %al,%al
f0100435:	79 e8                	jns    f010041f <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100437:	ba 78 03 00 00       	mov    $0x378,%edx
f010043c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100440:	ee                   	out    %al,(%dx)
f0100441:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100446:	b8 0d 00 00 00       	mov    $0xd,%eax
f010044b:	ee                   	out    %al,(%dx)
f010044c:	b8 08 00 00 00       	mov    $0x8,%eax
f0100451:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100452:	89 fa                	mov    %edi,%edx
f0100454:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010045a:	89 f8                	mov    %edi,%eax
f010045c:	80 cc 07             	or     $0x7,%ah
f010045f:	85 d2                	test   %edx,%edx
f0100461:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f0100464:	89 f8                	mov    %edi,%eax
f0100466:	0f b6 c0             	movzbl %al,%eax
f0100469:	83 f8 09             	cmp    $0x9,%eax
f010046c:	0f 84 b6 00 00 00    	je     f0100528 <cons_putc+0x159>
f0100472:	83 f8 09             	cmp    $0x9,%eax
f0100475:	7e 73                	jle    f01004ea <cons_putc+0x11b>
f0100477:	83 f8 0a             	cmp    $0xa,%eax
f010047a:	0f 84 9b 00 00 00    	je     f010051b <cons_putc+0x14c>
f0100480:	83 f8 0d             	cmp    $0xd,%eax
f0100483:	0f 85 d6 00 00 00    	jne    f010055f <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f0100489:	0f b7 05 28 42 23 f0 	movzwl 0xf0234228,%eax
f0100490:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100496:	c1 e8 16             	shr    $0x16,%eax
f0100499:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010049c:	c1 e0 04             	shl    $0x4,%eax
f010049f:	66 a3 28 42 23 f0    	mov    %ax,0xf0234228
	if (crt_pos >= CRT_SIZE) {
f01004a5:	66 81 3d 28 42 23 f0 	cmpw   $0x7cf,0xf0234228
f01004ac:	cf 07 
f01004ae:	0f 87 ce 00 00 00    	ja     f0100582 <cons_putc+0x1b3>
	outb(addr_6845, 14);
f01004b4:	8b 0d 30 42 23 f0    	mov    0xf0234230,%ecx
f01004ba:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004bf:	89 ca                	mov    %ecx,%edx
f01004c1:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004c2:	0f b7 1d 28 42 23 f0 	movzwl 0xf0234228,%ebx
f01004c9:	8d 71 01             	lea    0x1(%ecx),%esi
f01004cc:	89 d8                	mov    %ebx,%eax
f01004ce:	66 c1 e8 08          	shr    $0x8,%ax
f01004d2:	89 f2                	mov    %esi,%edx
f01004d4:	ee                   	out    %al,(%dx)
f01004d5:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004da:	89 ca                	mov    %ecx,%edx
f01004dc:	ee                   	out    %al,(%dx)
f01004dd:	89 d8                	mov    %ebx,%eax
f01004df:	89 f2                	mov    %esi,%edx
f01004e1:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01004e5:	5b                   	pop    %ebx
f01004e6:	5e                   	pop    %esi
f01004e7:	5f                   	pop    %edi
f01004e8:	5d                   	pop    %ebp
f01004e9:	c3                   	ret    
	switch (c & 0xff) {
f01004ea:	83 f8 08             	cmp    $0x8,%eax
f01004ed:	75 70                	jne    f010055f <cons_putc+0x190>
		if (crt_pos > 0) {
f01004ef:	0f b7 05 28 42 23 f0 	movzwl 0xf0234228,%eax
f01004f6:	66 85 c0             	test   %ax,%ax
f01004f9:	74 b9                	je     f01004b4 <cons_putc+0xe5>
			crt_pos--;
f01004fb:	83 e8 01             	sub    $0x1,%eax
f01004fe:	66 a3 28 42 23 f0    	mov    %ax,0xf0234228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100504:	0f b7 c0             	movzwl %ax,%eax
f0100507:	66 81 e7 00 ff       	and    $0xff00,%di
f010050c:	83 cf 20             	or     $0x20,%edi
f010050f:	8b 15 2c 42 23 f0    	mov    0xf023422c,%edx
f0100515:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100519:	eb 8a                	jmp    f01004a5 <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f010051b:	66 83 05 28 42 23 f0 	addw   $0x50,0xf0234228
f0100522:	50 
f0100523:	e9 61 ff ff ff       	jmp    f0100489 <cons_putc+0xba>
		cons_putc(' ');
f0100528:	b8 20 00 00 00       	mov    $0x20,%eax
f010052d:	e8 9d fe ff ff       	call   f01003cf <cons_putc>
		cons_putc(' ');
f0100532:	b8 20 00 00 00       	mov    $0x20,%eax
f0100537:	e8 93 fe ff ff       	call   f01003cf <cons_putc>
		cons_putc(' ');
f010053c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100541:	e8 89 fe ff ff       	call   f01003cf <cons_putc>
		cons_putc(' ');
f0100546:	b8 20 00 00 00       	mov    $0x20,%eax
f010054b:	e8 7f fe ff ff       	call   f01003cf <cons_putc>
		cons_putc(' ');
f0100550:	b8 20 00 00 00       	mov    $0x20,%eax
f0100555:	e8 75 fe ff ff       	call   f01003cf <cons_putc>
f010055a:	e9 46 ff ff ff       	jmp    f01004a5 <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f010055f:	0f b7 05 28 42 23 f0 	movzwl 0xf0234228,%eax
f0100566:	8d 50 01             	lea    0x1(%eax),%edx
f0100569:	66 89 15 28 42 23 f0 	mov    %dx,0xf0234228
f0100570:	0f b7 c0             	movzwl %ax,%eax
f0100573:	8b 15 2c 42 23 f0    	mov    0xf023422c,%edx
f0100579:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f010057d:	e9 23 ff ff ff       	jmp    f01004a5 <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100582:	a1 2c 42 23 f0       	mov    0xf023422c,%eax
f0100587:	83 ec 04             	sub    $0x4,%esp
f010058a:	68 00 0f 00 00       	push   $0xf00
f010058f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100595:	52                   	push   %edx
f0100596:	50                   	push   %eax
f0100597:	e8 69 51 00 00       	call   f0105705 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010059c:	8b 15 2c 42 23 f0    	mov    0xf023422c,%edx
f01005a2:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005a8:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005ae:	83 c4 10             	add    $0x10,%esp
f01005b1:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005b6:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005b9:	39 d0                	cmp    %edx,%eax
f01005bb:	75 f4                	jne    f01005b1 <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01005bd:	66 83 2d 28 42 23 f0 	subw   $0x50,0xf0234228
f01005c4:	50 
f01005c5:	e9 ea fe ff ff       	jmp    f01004b4 <cons_putc+0xe5>

f01005ca <serial_intr>:
	if (serial_exists)
f01005ca:	80 3d 34 42 23 f0 00 	cmpb   $0x0,0xf0234234
f01005d1:	75 02                	jne    f01005d5 <serial_intr+0xb>
f01005d3:	f3 c3                	repz ret 
{
f01005d5:	55                   	push   %ebp
f01005d6:	89 e5                	mov    %esp,%ebp
f01005d8:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005db:	b8 50 02 10 f0       	mov    $0xf0100250,%eax
f01005e0:	e8 8a fc ff ff       	call   f010026f <cons_intr>
}
f01005e5:	c9                   	leave  
f01005e6:	c3                   	ret    

f01005e7 <kbd_intr>:
{
f01005e7:	55                   	push   %ebp
f01005e8:	89 e5                	mov    %esp,%ebp
f01005ea:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005ed:	b8 b2 02 10 f0       	mov    $0xf01002b2,%eax
f01005f2:	e8 78 fc ff ff       	call   f010026f <cons_intr>
}
f01005f7:	c9                   	leave  
f01005f8:	c3                   	ret    

f01005f9 <cons_getc>:
{
f01005f9:	55                   	push   %ebp
f01005fa:	89 e5                	mov    %esp,%ebp
f01005fc:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01005ff:	e8 c6 ff ff ff       	call   f01005ca <serial_intr>
	kbd_intr();
f0100604:	e8 de ff ff ff       	call   f01005e7 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100609:	8b 15 20 42 23 f0    	mov    0xf0234220,%edx
	return 0;
f010060f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100614:	3b 15 24 42 23 f0    	cmp    0xf0234224,%edx
f010061a:	74 18                	je     f0100634 <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f010061c:	8d 4a 01             	lea    0x1(%edx),%ecx
f010061f:	89 0d 20 42 23 f0    	mov    %ecx,0xf0234220
f0100625:	0f b6 82 20 40 23 f0 	movzbl -0xfdcbfe0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f010062c:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100632:	74 02                	je     f0100636 <cons_getc+0x3d>
}
f0100634:	c9                   	leave  
f0100635:	c3                   	ret    
			cons.rpos = 0;
f0100636:	c7 05 20 42 23 f0 00 	movl   $0x0,0xf0234220
f010063d:	00 00 00 
f0100640:	eb f2                	jmp    f0100634 <cons_getc+0x3b>

f0100642 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100642:	55                   	push   %ebp
f0100643:	89 e5                	mov    %esp,%ebp
f0100645:	57                   	push   %edi
f0100646:	56                   	push   %esi
f0100647:	53                   	push   %ebx
f0100648:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f010064b:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100652:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100659:	5a a5 
	if (*cp != 0xA55A) {
f010065b:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100662:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100666:	0f 84 d4 00 00 00    	je     f0100740 <cons_init+0xfe>
		addr_6845 = MONO_BASE;
f010066c:	c7 05 30 42 23 f0 b4 	movl   $0x3b4,0xf0234230
f0100673:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100676:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f010067b:	8b 3d 30 42 23 f0    	mov    0xf0234230,%edi
f0100681:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100686:	89 fa                	mov    %edi,%edx
f0100688:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100689:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010068c:	89 ca                	mov    %ecx,%edx
f010068e:	ec                   	in     (%dx),%al
f010068f:	0f b6 c0             	movzbl %al,%eax
f0100692:	c1 e0 08             	shl    $0x8,%eax
f0100695:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100697:	b8 0f 00 00 00       	mov    $0xf,%eax
f010069c:	89 fa                	mov    %edi,%edx
f010069e:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010069f:	89 ca                	mov    %ecx,%edx
f01006a1:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006a2:	89 35 2c 42 23 f0    	mov    %esi,0xf023422c
	pos |= inb(addr_6845 + 1);
f01006a8:	0f b6 c0             	movzbl %al,%eax
f01006ab:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006ad:	66 a3 28 42 23 f0    	mov    %ax,0xf0234228
	kbd_intr();
f01006b3:	e8 2f ff ff ff       	call   f01005e7 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006b8:	83 ec 0c             	sub    $0xc,%esp
f01006bb:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f01006c2:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006c7:	50                   	push   %eax
f01006c8:	e8 57 33 00 00       	call   f0103a24 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006cd:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006d2:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006d7:	89 d8                	mov    %ebx,%eax
f01006d9:	89 ca                	mov    %ecx,%edx
f01006db:	ee                   	out    %al,(%dx)
f01006dc:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006e1:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006e6:	89 fa                	mov    %edi,%edx
f01006e8:	ee                   	out    %al,(%dx)
f01006e9:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006ee:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006f3:	ee                   	out    %al,(%dx)
f01006f4:	be f9 03 00 00       	mov    $0x3f9,%esi
f01006f9:	89 d8                	mov    %ebx,%eax
f01006fb:	89 f2                	mov    %esi,%edx
f01006fd:	ee                   	out    %al,(%dx)
f01006fe:	b8 03 00 00 00       	mov    $0x3,%eax
f0100703:	89 fa                	mov    %edi,%edx
f0100705:	ee                   	out    %al,(%dx)
f0100706:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010070b:	89 d8                	mov    %ebx,%eax
f010070d:	ee                   	out    %al,(%dx)
f010070e:	b8 01 00 00 00       	mov    $0x1,%eax
f0100713:	89 f2                	mov    %esi,%edx
f0100715:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100716:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010071b:	ec                   	in     (%dx),%al
f010071c:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010071e:	83 c4 10             	add    $0x10,%esp
f0100721:	3c ff                	cmp    $0xff,%al
f0100723:	0f 95 05 34 42 23 f0 	setne  0xf0234234
f010072a:	89 ca                	mov    %ecx,%edx
f010072c:	ec                   	in     (%dx),%al
f010072d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100732:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f0100733:	80 fb ff             	cmp    $0xff,%bl
f0100736:	74 23                	je     f010075b <cons_init+0x119>
		cprintf("Serial port does not exist!\n");
}
f0100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010073b:	5b                   	pop    %ebx
f010073c:	5e                   	pop    %esi
f010073d:	5f                   	pop    %edi
f010073e:	5d                   	pop    %ebp
f010073f:	c3                   	ret    
		*cp = was;
f0100740:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100747:	c7 05 30 42 23 f0 d4 	movl   $0x3d4,0xf0234230
f010074e:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100751:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100756:	e9 20 ff ff ff       	jmp    f010067b <cons_init+0x39>
		cprintf("Serial port does not exist!\n");
f010075b:	83 ec 0c             	sub    $0xc,%esp
f010075e:	68 0f 64 10 f0       	push   $0xf010640f
f0100763:	e8 17 34 00 00       	call   f0103b7f <cprintf>
f0100768:	83 c4 10             	add    $0x10,%esp
}
f010076b:	eb cb                	jmp    f0100738 <cons_init+0xf6>

f010076d <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010076d:	55                   	push   %ebp
f010076e:	89 e5                	mov    %esp,%ebp
f0100770:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100773:	8b 45 08             	mov    0x8(%ebp),%eax
f0100776:	e8 54 fc ff ff       	call   f01003cf <cons_putc>
}
f010077b:	c9                   	leave  
f010077c:	c3                   	ret    

f010077d <getchar>:

int
getchar(void)
{
f010077d:	55                   	push   %ebp
f010077e:	89 e5                	mov    %esp,%ebp
f0100780:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100783:	e8 71 fe ff ff       	call   f01005f9 <cons_getc>
f0100788:	85 c0                	test   %eax,%eax
f010078a:	74 f7                	je     f0100783 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010078c:	c9                   	leave  
f010078d:	c3                   	ret    

f010078e <iscons>:

int
iscons(int fdnum)
{
f010078e:	55                   	push   %ebp
f010078f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100791:	b8 01 00 00 00       	mov    $0x1,%eax
f0100796:	5d                   	pop    %ebp
f0100797:	c3                   	ret    

f0100798 <mon_help>:
};

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf) {
f0100798:	55                   	push   %ebp
f0100799:	89 e5                	mov    %esp,%ebp
f010079b:	83 ec 0c             	sub    $0xc,%esp
    int i;

    for (i = 0; i < ARRAY_SIZE(commands); i++)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010079e:	68 60 66 10 f0       	push   $0xf0106660
f01007a3:	68 7e 66 10 f0       	push   $0xf010667e
f01007a8:	68 83 66 10 f0       	push   $0xf0106683
f01007ad:	e8 cd 33 00 00       	call   f0103b7f <cprintf>
f01007b2:	83 c4 0c             	add    $0xc,%esp
f01007b5:	68 28 67 10 f0       	push   $0xf0106728
f01007ba:	68 8c 66 10 f0       	push   $0xf010668c
f01007bf:	68 83 66 10 f0       	push   $0xf0106683
f01007c4:	e8 b6 33 00 00       	call   f0103b7f <cprintf>
f01007c9:	83 c4 0c             	add    $0xc,%esp
f01007cc:	68 95 66 10 f0       	push   $0xf0106695
f01007d1:	68 b3 66 10 f0       	push   $0xf01066b3
f01007d6:	68 83 66 10 f0       	push   $0xf0106683
f01007db:	e8 9f 33 00 00       	call   f0103b7f <cprintf>
    return 0;
}
f01007e0:	b8 00 00 00 00       	mov    $0x0,%eax
f01007e5:	c9                   	leave  
f01007e6:	c3                   	ret    

f01007e7 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf) {
f01007e7:	55                   	push   %ebp
f01007e8:	89 e5                	mov    %esp,%ebp
f01007ea:	83 ec 14             	sub    $0x14,%esp
    extern char _start[], entry[], etext[], edata[], end[];

    cprintf("Special kernel symbols:\n");
f01007ed:	68 bd 66 10 f0       	push   $0xf01066bd
f01007f2:	e8 88 33 00 00       	call   f0103b7f <cprintf>
    cprintf("  _start                  %08x (phys)\n", _start);
f01007f7:	83 c4 08             	add    $0x8,%esp
f01007fa:	68 0c 00 10 00       	push   $0x10000c
f01007ff:	68 50 67 10 f0       	push   $0xf0106750
f0100804:	e8 76 33 00 00       	call   f0103b7f <cprintf>
    cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100809:	83 c4 0c             	add    $0xc,%esp
f010080c:	68 0c 00 10 00       	push   $0x10000c
f0100811:	68 0c 00 10 f0       	push   $0xf010000c
f0100816:	68 78 67 10 f0       	push   $0xf0106778
f010081b:	e8 5f 33 00 00       	call   f0103b7f <cprintf>
    cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100820:	83 c4 0c             	add    $0xc,%esp
f0100823:	68 29 63 10 00       	push   $0x106329
f0100828:	68 29 63 10 f0       	push   $0xf0106329
f010082d:	68 9c 67 10 f0       	push   $0xf010679c
f0100832:	e8 48 33 00 00       	call   f0103b7f <cprintf>
    cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100837:	83 c4 0c             	add    $0xc,%esp
f010083a:	68 00 40 23 00       	push   $0x234000
f010083f:	68 00 40 23 f0       	push   $0xf0234000
f0100844:	68 c0 67 10 f0       	push   $0xf01067c0
f0100849:	e8 31 33 00 00       	call   f0103b7f <cprintf>
    cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010084e:	83 c4 0c             	add    $0xc,%esp
f0100851:	68 08 60 27 00       	push   $0x276008
f0100856:	68 08 60 27 f0       	push   $0xf0276008
f010085b:	68 e4 67 10 f0       	push   $0xf01067e4
f0100860:	e8 1a 33 00 00       	call   f0103b7f <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
f0100865:	83 c4 08             	add    $0x8,%esp
            ROUNDUP(end - entry, 1024) / 1024);
f0100868:	b8 07 64 27 f0       	mov    $0xf0276407,%eax
f010086d:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
    cprintf("Kernel executable memory footprint: %dKB\n",
f0100872:	c1 f8 0a             	sar    $0xa,%eax
f0100875:	50                   	push   %eax
f0100876:	68 08 68 10 f0       	push   $0xf0106808
f010087b:	e8 ff 32 00 00       	call   f0103b7f <cprintf>
    return 0;
}
f0100880:	b8 00 00 00 00       	mov    $0x0,%eax
f0100885:	c9                   	leave  
f0100886:	c3                   	ret    

f0100887 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf) {
f0100887:	55                   	push   %ebp
f0100888:	89 e5                	mov    %esp,%ebp
f010088a:	57                   	push   %edi
f010088b:	56                   	push   %esi
f010088c:	53                   	push   %ebx
f010088d:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100890:	89 eb                	mov    %ebp,%ebx
        uintptr_t eip = *(uintptr_t *) (ebp + 0x4);
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, *(uintptr_t *) (ebp + 0x8),
                *(uintptr_t *) (ebp + 0xc),
                *(uintptr_t *) (ebp + 0x10), *(uintptr_t *) (ebp + 0x14));
        struct Eipdebuginfo eipDebugInfo;
        debuginfo_eip(eip, &eipDebugInfo);
f0100892:	8d 7d d0             	lea    -0x30(%ebp),%edi
    while (ebp) {
f0100895:	eb 4a                	jmp    f01008e1 <mon_backtrace+0x5a>
        uintptr_t eip = *(uintptr_t *) (ebp + 0x4);
f0100897:	8b 73 04             	mov    0x4(%ebx),%esi
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, *(uintptr_t *) (ebp + 0x8),
f010089a:	83 ec 04             	sub    $0x4,%esp
f010089d:	ff 73 14             	pushl  0x14(%ebx)
f01008a0:	ff 73 10             	pushl  0x10(%ebx)
f01008a3:	ff 73 0c             	pushl  0xc(%ebx)
f01008a6:	ff 73 08             	pushl  0x8(%ebx)
f01008a9:	56                   	push   %esi
f01008aa:	53                   	push   %ebx
f01008ab:	68 34 68 10 f0       	push   $0xf0106834
f01008b0:	e8 ca 32 00 00       	call   f0103b7f <cprintf>
        debuginfo_eip(eip, &eipDebugInfo);
f01008b5:	83 c4 18             	add    $0x18,%esp
f01008b8:	57                   	push   %edi
f01008b9:	56                   	push   %esi
f01008ba:	e8 61 43 00 00       	call   f0104c20 <debuginfo_eip>
        cprintf("\t %s:%d:  %.*s+%d\n", eipDebugInfo.eip_file, eipDebugInfo.eip_line, eipDebugInfo.eip_fn_namelen, eipDebugInfo.eip_fn_name,
f01008bf:	83 c4 08             	add    $0x8,%esp
f01008c2:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01008c5:	56                   	push   %esi
f01008c6:	ff 75 d8             	pushl  -0x28(%ebp)
f01008c9:	ff 75 dc             	pushl  -0x24(%ebp)
f01008cc:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008cf:	ff 75 d0             	pushl  -0x30(%ebp)
f01008d2:	68 d6 66 10 f0       	push   $0xf01066d6
f01008d7:	e8 a3 32 00 00       	call   f0103b7f <cprintf>
                eip - eipDebugInfo.eip_fn_addr);
        ebp = *(uintptr_t *) ebp;
f01008dc:	8b 1b                	mov    (%ebx),%ebx
f01008de:	83 c4 20             	add    $0x20,%esp
    while (ebp) {
f01008e1:	85 db                	test   %ebx,%ebx
f01008e3:	75 b2                	jne    f0100897 <mon_backtrace+0x10>
    }
    return 1;
}
f01008e5:	b8 01 00 00 00       	mov    $0x1,%eax
f01008ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01008ed:	5b                   	pop    %ebx
f01008ee:	5e                   	pop    %esi
f01008ef:	5f                   	pop    %edi
f01008f0:	5d                   	pop    %ebp
f01008f1:	c3                   	ret    

f01008f2 <monitor>:
    cprintf("Unknown command '%s'\n", argv[0]);
    return 0;
}

void
monitor(struct Trapframe *tf) {
f01008f2:	55                   	push   %ebp
f01008f3:	89 e5                	mov    %esp,%ebp
f01008f5:	57                   	push   %edi
f01008f6:	56                   	push   %esi
f01008f7:	53                   	push   %ebx
f01008f8:	83 ec 58             	sub    $0x58,%esp
    char *buf;

    cprintf("Welcome to the JOS kernel monitor!\n");
f01008fb:	68 6c 68 10 f0       	push   $0xf010686c
f0100900:	e8 7a 32 00 00       	call   f0103b7f <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
f0100905:	c7 04 24 90 68 10 f0 	movl   $0xf0106890,(%esp)
f010090c:	e8 6e 32 00 00       	call   f0103b7f <cprintf>

	if (tf != NULL)
f0100911:	83 c4 10             	add    $0x10,%esp
f0100914:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100918:	74 57                	je     f0100971 <monitor+0x7f>
		print_trapframe(tf);
f010091a:	83 ec 0c             	sub    $0xc,%esp
f010091d:	ff 75 08             	pushl  0x8(%ebp)
f0100920:	e8 77 35 00 00       	call   f0103e9c <print_trapframe>
f0100925:	83 c4 10             	add    $0x10,%esp
f0100928:	eb 47                	jmp    f0100971 <monitor+0x7f>
        while (*buf && strchr(WHITESPACE, *buf))
f010092a:	83 ec 08             	sub    $0x8,%esp
f010092d:	0f be c0             	movsbl %al,%eax
f0100930:	50                   	push   %eax
f0100931:	68 ed 66 10 f0       	push   $0xf01066ed
f0100936:	e8 40 4d 00 00       	call   f010567b <strchr>
f010093b:	83 c4 10             	add    $0x10,%esp
f010093e:	85 c0                	test   %eax,%eax
f0100940:	74 0a                	je     f010094c <monitor+0x5a>
            *buf++ = 0;
f0100942:	c6 03 00             	movb   $0x0,(%ebx)
f0100945:	89 f7                	mov    %esi,%edi
f0100947:	8d 5b 01             	lea    0x1(%ebx),%ebx
f010094a:	eb 6b                	jmp    f01009b7 <monitor+0xc5>
        if (*buf == 0)
f010094c:	80 3b 00             	cmpb   $0x0,(%ebx)
f010094f:	74 73                	je     f01009c4 <monitor+0xd2>
        if (argc == MAXARGS - 1) {
f0100951:	83 fe 0f             	cmp    $0xf,%esi
f0100954:	74 09                	je     f010095f <monitor+0x6d>
        argv[argc++] = buf;
f0100956:	8d 7e 01             	lea    0x1(%esi),%edi
f0100959:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010095d:	eb 39                	jmp    f0100998 <monitor+0xa6>
            cprintf("Too many arguments (max %d)\n", MAXARGS);
f010095f:	83 ec 08             	sub    $0x8,%esp
f0100962:	6a 10                	push   $0x10
f0100964:	68 f2 66 10 f0       	push   $0xf01066f2
f0100969:	e8 11 32 00 00       	call   f0103b7f <cprintf>
f010096e:	83 c4 10             	add    $0x10,%esp

    while (1) {
        buf = readline("K> ");
f0100971:	83 ec 0c             	sub    $0xc,%esp
f0100974:	68 e9 66 10 f0       	push   $0xf01066e9
f0100979:	e8 e0 4a 00 00       	call   f010545e <readline>
f010097e:	89 c3                	mov    %eax,%ebx
        if (buf != NULL)
f0100980:	83 c4 10             	add    $0x10,%esp
f0100983:	85 c0                	test   %eax,%eax
f0100985:	74 ea                	je     f0100971 <monitor+0x7f>
    argv[argc] = 0;
f0100987:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
    argc = 0;
f010098e:	be 00 00 00 00       	mov    $0x0,%esi
f0100993:	eb 24                	jmp    f01009b9 <monitor+0xc7>
            buf++;
f0100995:	83 c3 01             	add    $0x1,%ebx
        while (*buf && !strchr(WHITESPACE, *buf))
f0100998:	0f b6 03             	movzbl (%ebx),%eax
f010099b:	84 c0                	test   %al,%al
f010099d:	74 18                	je     f01009b7 <monitor+0xc5>
f010099f:	83 ec 08             	sub    $0x8,%esp
f01009a2:	0f be c0             	movsbl %al,%eax
f01009a5:	50                   	push   %eax
f01009a6:	68 ed 66 10 f0       	push   $0xf01066ed
f01009ab:	e8 cb 4c 00 00       	call   f010567b <strchr>
f01009b0:	83 c4 10             	add    $0x10,%esp
f01009b3:	85 c0                	test   %eax,%eax
f01009b5:	74 de                	je     f0100995 <monitor+0xa3>
            *buf++ = 0;
f01009b7:	89 fe                	mov    %edi,%esi
        while (*buf && strchr(WHITESPACE, *buf))
f01009b9:	0f b6 03             	movzbl (%ebx),%eax
f01009bc:	84 c0                	test   %al,%al
f01009be:	0f 85 66 ff ff ff    	jne    f010092a <monitor+0x38>
    argv[argc] = 0;
f01009c4:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009cb:	00 
    if (argc == 0)
f01009cc:	85 f6                	test   %esi,%esi
f01009ce:	74 a1                	je     f0100971 <monitor+0x7f>
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009d0:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (strcmp(argv[0], commands[i].name) == 0)
f01009d5:	83 ec 08             	sub    $0x8,%esp
f01009d8:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009db:	ff 34 85 c0 68 10 f0 	pushl  -0xfef9740(,%eax,4)
f01009e2:	ff 75 a8             	pushl  -0x58(%ebp)
f01009e5:	e8 33 4c 00 00       	call   f010561d <strcmp>
f01009ea:	83 c4 10             	add    $0x10,%esp
f01009ed:	85 c0                	test   %eax,%eax
f01009ef:	74 20                	je     f0100a11 <monitor+0x11f>
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009f1:	83 c3 01             	add    $0x1,%ebx
f01009f4:	83 fb 03             	cmp    $0x3,%ebx
f01009f7:	75 dc                	jne    f01009d5 <monitor+0xe3>
    cprintf("Unknown command '%s'\n", argv[0]);
f01009f9:	83 ec 08             	sub    $0x8,%esp
f01009fc:	ff 75 a8             	pushl  -0x58(%ebp)
f01009ff:	68 0f 67 10 f0       	push   $0xf010670f
f0100a04:	e8 76 31 00 00       	call   f0103b7f <cprintf>
f0100a09:	83 c4 10             	add    $0x10,%esp
f0100a0c:	e9 60 ff ff ff       	jmp    f0100971 <monitor+0x7f>
            return commands[i].func(argc, argv, tf);
f0100a11:	83 ec 04             	sub    $0x4,%esp
f0100a14:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a17:	ff 75 08             	pushl  0x8(%ebp)
f0100a1a:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a1d:	52                   	push   %edx
f0100a1e:	56                   	push   %esi
f0100a1f:	ff 14 85 c8 68 10 f0 	call   *-0xfef9738(,%eax,4)
            if (runcmd(buf, tf) < 0)
f0100a26:	83 c4 10             	add    $0x10,%esp
f0100a29:	85 c0                	test   %eax,%eax
f0100a2b:	0f 89 40 ff ff ff    	jns    f0100971 <monitor+0x7f>
                break;
    }
f0100a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a34:	5b                   	pop    %ebx
f0100a35:	5e                   	pop    %esi
f0100a36:	5f                   	pop    %edi
f0100a37:	5d                   	pop    %ebp
f0100a38:	c3                   	ret    

f0100a39 <nvram_read>:
// --------------------------------------------------------------
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r) {
f0100a39:	55                   	push   %ebp
f0100a3a:	89 e5                	mov    %esp,%ebp
f0100a3c:	56                   	push   %esi
f0100a3d:	53                   	push   %ebx
f0100a3e:	89 c6                	mov    %eax,%esi
    return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a40:	83 ec 0c             	sub    $0xc,%esp
f0100a43:	50                   	push   %eax
f0100a44:	e8 ad 2f 00 00       	call   f01039f6 <mc146818_read>
f0100a49:	89 c3                	mov    %eax,%ebx
f0100a4b:	83 c6 01             	add    $0x1,%esi
f0100a4e:	89 34 24             	mov    %esi,(%esp)
f0100a51:	e8 a0 2f 00 00       	call   f01039f6 <mc146818_read>
f0100a56:	c1 e0 08             	shl    $0x8,%eax
f0100a59:	09 d8                	or     %ebx,%eax
}
f0100a5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a5e:	5b                   	pop    %ebx
f0100a5f:	5e                   	pop    %esi
f0100a60:	5d                   	pop    %ebp
f0100a61:	c3                   	ret    

f0100a62 <boot_alloc>:
//
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n) {
f0100a62:	55                   	push   %ebp
f0100a63:	89 e5                	mov    %esp,%ebp
f0100a65:	53                   	push   %ebx
f0100a66:	83 ec 04             	sub    $0x4,%esp
    // Initialize nextfree if this is the first time.
    // 'end' is a magic symbol automatically generated by the linker,
    // which points to the end of the kernel's bss segment:
    // the first virtual address that the linker did *not* assign
    // to any kernel code or global variables.
    if (!nextfree) {
f0100a69:	83 3d 38 42 23 f0 00 	cmpl   $0x0,0xf0234238
f0100a70:	74 29                	je     f0100a9b <boot_alloc+0x39>
    }

    // Allocate a chunk large enough to hold 'n' bytes, then update
    // nextfree.  Make sure nextfree is kept aligned
    // to a multiple of PGSIZE.
    result = nextfree;
f0100a72:	8b 15 38 42 23 f0    	mov    0xf0234238,%edx
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100a78:	8d 5a ff             	lea    -0x1(%edx),%ebx
f0100a7b:	89 c1                	mov    %eax,%ecx
f0100a7d:	f7 d1                	not    %ecx
f0100a7f:	39 cb                	cmp    %ecx,%ebx
f0100a81:	77 2b                	ja     f0100aae <boot_alloc+0x4c>
    nextfree = ROUNDUP((result + n), PGSIZE);
f0100a83:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100a8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a8f:	a3 38 42 23 f0       	mov    %eax,0xf0234238

    return result;
}
f0100a94:	89 d0                	mov    %edx,%eax
f0100a96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100a99:	c9                   	leave  
f0100a9a:	c3                   	ret    
        nextfree = ROUNDUP((char *) end, PGSIZE);
f0100a9b:	ba 07 70 27 f0       	mov    $0xf0277007,%edx
f0100aa0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100aa6:	89 15 38 42 23 f0    	mov    %edx,0xf0234238
f0100aac:	eb c4                	jmp    f0100a72 <boot_alloc+0x10>
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100aae:	68 e4 68 10 f0       	push   $0xf01068e4
f0100ab3:	68 21 77 10 f0       	push   $0xf0107721
f0100ab8:	6a 73                	push   $0x73
f0100aba:	68 36 77 10 f0       	push   $0xf0107736
f0100abf:	e8 7c f5 ff ff       	call   f0100040 <_panic>

f0100ac4 <check_va2pa>:

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va) {
    pte_t *p;

    pgdir = &pgdir[PDX(va)];
f0100ac4:	89 d1                	mov    %edx,%ecx
f0100ac6:	c1 e9 16             	shr    $0x16,%ecx
    if (!(*pgdir & PTE_P))
f0100ac9:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100acc:	a8 01                	test   $0x1,%al
f0100ace:	74 52                	je     f0100b22 <check_va2pa+0x5e>
        return ~0;
    p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
f0100ad0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100ad5:	89 c1                	mov    %eax,%ecx
f0100ad7:	c1 e9 0c             	shr    $0xc,%ecx
f0100ada:	3b 0d 8c 4e 23 f0    	cmp    0xf0234e8c,%ecx
f0100ae0:	73 25                	jae    f0100b07 <check_va2pa+0x43>
    if (!(p[PTX(va)] & PTE_P))
f0100ae2:	c1 ea 0c             	shr    $0xc,%edx
f0100ae5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100aeb:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100af2:	89 c2                	mov    %eax,%edx
f0100af4:	83 e2 01             	and    $0x1,%edx
        return ~0;
    return PTE_ADDR(p[PTX(va)]);
f0100af7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100afc:	85 d2                	test   %edx,%edx
f0100afe:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b03:	0f 44 c2             	cmove  %edx,%eax
f0100b06:	c3                   	ret    
check_va2pa(pde_t *pgdir, uintptr_t va) {
f0100b07:	55                   	push   %ebp
f0100b08:	89 e5                	mov    %esp,%ebp
f0100b0a:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b0d:	50                   	push   %eax
f0100b0e:	68 64 63 10 f0       	push   $0xf0106364
f0100b13:	68 ed 03 00 00       	push   $0x3ed
f0100b18:	68 36 77 10 f0       	push   $0xf0107736
f0100b1d:	e8 1e f5 ff ff       	call   f0100040 <_panic>
        return ~0;
f0100b22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b27:	c3                   	ret    

f0100b28 <check_page_free_list>:
check_page_free_list(bool only_low_memory) {
f0100b28:	55                   	push   %ebp
f0100b29:	89 e5                	mov    %esp,%ebp
f0100b2b:	57                   	push   %edi
f0100b2c:	56                   	push   %esi
f0100b2d:	53                   	push   %ebx
f0100b2e:	83 ec 2c             	sub    $0x2c,%esp
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b31:	84 c0                	test   %al,%al
f0100b33:	0f 85 c0 02 00 00    	jne    f0100df9 <check_page_free_list+0x2d1>
    if (!page_free_list)
f0100b39:	83 3d 44 42 23 f0 00 	cmpl   $0x0,0xf0234244
f0100b40:	74 0a                	je     f0100b4c <check_page_free_list+0x24>
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b42:	be 00 04 00 00       	mov    $0x400,%esi
f0100b47:	e9 23 03 00 00       	jmp    f0100e6f <check_page_free_list+0x347>
        panic("'page_free_list' is a null pointer!");
f0100b4c:	83 ec 04             	sub    $0x4,%esp
f0100b4f:	68 0c 69 10 f0       	push   $0xf010690c
f0100b54:	68 18 03 00 00       	push   $0x318
f0100b59:	68 36 77 10 f0       	push   $0xf0107736
f0100b5e:	e8 dd f4 ff ff       	call   f0100040 <_panic>
f0100b63:	50                   	push   %eax
f0100b64:	68 64 63 10 f0       	push   $0xf0106364
f0100b69:	6a 58                	push   $0x58
f0100b6b:	68 42 77 10 f0       	push   $0xf0107742
f0100b70:	e8 cb f4 ff ff       	call   f0100040 <_panic>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0100b75:	8b 1b                	mov    (%ebx),%ebx
f0100b77:	85 db                	test   %ebx,%ebx
f0100b79:	74 41                	je     f0100bbc <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100b7b:	89 d8                	mov    %ebx,%eax
f0100b7d:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0100b83:	c1 f8 03             	sar    $0x3,%eax
f0100b86:	c1 e0 0c             	shl    $0xc,%eax
        if (PDX(page2pa(pp)) < pdx_limit) {
f0100b89:	89 c2                	mov    %eax,%edx
f0100b8b:	c1 ea 16             	shr    $0x16,%edx
f0100b8e:	39 f2                	cmp    %esi,%edx
f0100b90:	73 e3                	jae    f0100b75 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100b92:	89 c2                	mov    %eax,%edx
f0100b94:	c1 ea 0c             	shr    $0xc,%edx
f0100b97:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0100b9d:	73 c4                	jae    f0100b63 <check_page_free_list+0x3b>
            memset(page2kva(pp), 0x97, 128);
f0100b9f:	83 ec 04             	sub    $0x4,%esp
f0100ba2:	68 80 00 00 00       	push   $0x80
f0100ba7:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100bac:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100bb1:	50                   	push   %eax
f0100bb2:	e8 01 4b 00 00       	call   f01056b8 <memset>
f0100bb7:	83 c4 10             	add    $0x10,%esp
f0100bba:	eb b9                	jmp    f0100b75 <check_page_free_list+0x4d>
    first_free_page = (char *) boot_alloc(0);
f0100bbc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100bc1:	e8 9c fe ff ff       	call   f0100a62 <boot_alloc>
f0100bc6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    cprintf("first_free_page:0x%x\n", first_free_page);
f0100bc9:	83 ec 08             	sub    $0x8,%esp
f0100bcc:	50                   	push   %eax
f0100bcd:	68 50 77 10 f0       	push   $0xf0107750
f0100bd2:	e8 a8 2f 00 00       	call   f0103b7f <cprintf>
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100bd7:	8b 15 44 42 23 f0    	mov    0xf0234244,%edx
        assert(pp >= pages);
f0100bdd:	8b 0d 94 4e 23 f0    	mov    0xf0234e94,%ecx
        assert(pp < pages + npages);
f0100be3:	a1 8c 4e 23 f0       	mov    0xf0234e8c,%eax
f0100be8:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100beb:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100bee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100bf1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100bf4:	83 c4 10             	add    $0x10,%esp
    int nfree_basemem = 0, nfree_extmem = 0;
f0100bf7:	be 00 00 00 00       	mov    $0x0,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100bfc:	e9 04 01 00 00       	jmp    f0100d05 <check_page_free_list+0x1dd>
        assert(pp >= pages);
f0100c01:	68 66 77 10 f0       	push   $0xf0107766
f0100c06:	68 21 77 10 f0       	push   $0xf0107721
f0100c0b:	68 39 03 00 00       	push   $0x339
f0100c10:	68 36 77 10 f0       	push   $0xf0107736
f0100c15:	e8 26 f4 ff ff       	call   f0100040 <_panic>
        assert(pp < pages + npages);
f0100c1a:	68 72 77 10 f0       	push   $0xf0107772
f0100c1f:	68 21 77 10 f0       	push   $0xf0107721
f0100c24:	68 3a 03 00 00       	push   $0x33a
f0100c29:	68 36 77 10 f0       	push   $0xf0107736
f0100c2e:	e8 0d f4 ff ff       	call   f0100040 <_panic>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c33:	68 7c 69 10 f0       	push   $0xf010697c
f0100c38:	68 21 77 10 f0       	push   $0xf0107721
f0100c3d:	68 3b 03 00 00       	push   $0x33b
f0100c42:	68 36 77 10 f0       	push   $0xf0107736
f0100c47:	e8 f4 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != 0);
f0100c4c:	68 86 77 10 f0       	push   $0xf0107786
f0100c51:	68 21 77 10 f0       	push   $0xf0107721
f0100c56:	68 3e 03 00 00       	push   $0x33e
f0100c5b:	68 36 77 10 f0       	push   $0xf0107736
f0100c60:	e8 db f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != IOPHYSMEM);
f0100c65:	68 97 77 10 f0       	push   $0xf0107797
f0100c6a:	68 21 77 10 f0       	push   $0xf0107721
f0100c6f:	68 3f 03 00 00       	push   $0x33f
f0100c74:	68 36 77 10 f0       	push   $0xf0107736
f0100c79:	e8 c2 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c7e:	68 b0 69 10 f0       	push   $0xf01069b0
f0100c83:	68 21 77 10 f0       	push   $0xf0107721
f0100c88:	68 40 03 00 00       	push   $0x340
f0100c8d:	68 36 77 10 f0       	push   $0xf0107736
f0100c92:	e8 a9 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100c97:	68 b0 77 10 f0       	push   $0xf01077b0
f0100c9c:	68 21 77 10 f0       	push   $0xf0107721
f0100ca1:	68 41 03 00 00       	push   $0x341
f0100ca6:	68 36 77 10 f0       	push   $0xf0107736
f0100cab:	e8 90 f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100cb0:	89 c7                	mov    %eax,%edi
f0100cb2:	c1 ef 0c             	shr    $0xc,%edi
f0100cb5:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100cb8:	76 1b                	jbe    f0100cd5 <check_page_free_list+0x1ad>
	return (void *)(pa + KERNBASE);
f0100cba:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100cc0:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100cc3:	77 22                	ja     f0100ce7 <check_page_free_list+0x1bf>
        assert(page2pa(pp) != MPENTRY_PADDR);
f0100cc5:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100cca:	0f 84 98 00 00 00    	je     f0100d68 <check_page_free_list+0x240>
            ++nfree_extmem;
f0100cd0:	83 c3 01             	add    $0x1,%ebx
f0100cd3:	eb 2e                	jmp    f0100d03 <check_page_free_list+0x1db>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100cd5:	50                   	push   %eax
f0100cd6:	68 64 63 10 f0       	push   $0xf0106364
f0100cdb:	6a 58                	push   $0x58
f0100cdd:	68 42 77 10 f0       	push   $0xf0107742
f0100ce2:	e8 59 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ce7:	68 d4 69 10 f0       	push   $0xf01069d4
f0100cec:	68 21 77 10 f0       	push   $0xf0107721
f0100cf1:	68 42 03 00 00       	push   $0x342
f0100cf6:	68 36 77 10 f0       	push   $0xf0107736
f0100cfb:	e8 40 f3 ff ff       	call   f0100040 <_panic>
            ++nfree_basemem;
f0100d00:	83 c6 01             	add    $0x1,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d03:	8b 12                	mov    (%edx),%edx
f0100d05:	85 d2                	test   %edx,%edx
f0100d07:	74 78                	je     f0100d81 <check_page_free_list+0x259>
        assert(pp >= pages);
f0100d09:	39 d1                	cmp    %edx,%ecx
f0100d0b:	0f 87 f0 fe ff ff    	ja     f0100c01 <check_page_free_list+0xd9>
        assert(pp < pages + npages);
f0100d11:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0100d14:	0f 86 00 ff ff ff    	jbe    f0100c1a <check_page_free_list+0xf2>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d1a:	89 d0                	mov    %edx,%eax
f0100d1c:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100d1f:	a8 07                	test   $0x7,%al
f0100d21:	0f 85 0c ff ff ff    	jne    f0100c33 <check_page_free_list+0x10b>
	return (pp - pages) << PGSHIFT;
f0100d27:	c1 f8 03             	sar    $0x3,%eax
f0100d2a:	c1 e0 0c             	shl    $0xc,%eax
        assert(page2pa(pp) != 0);
f0100d2d:	85 c0                	test   %eax,%eax
f0100d2f:	0f 84 17 ff ff ff    	je     f0100c4c <check_page_free_list+0x124>
        assert(page2pa(pp) != IOPHYSMEM);
f0100d35:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d3a:	0f 84 25 ff ff ff    	je     f0100c65 <check_page_free_list+0x13d>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d40:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d45:	0f 84 33 ff ff ff    	je     f0100c7e <check_page_free_list+0x156>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100d4b:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d50:	0f 84 41 ff ff ff    	je     f0100c97 <check_page_free_list+0x16f>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d56:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d5b:	0f 87 4f ff ff ff    	ja     f0100cb0 <check_page_free_list+0x188>
        assert(page2pa(pp) != MPENTRY_PADDR);
f0100d61:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d66:	75 98                	jne    f0100d00 <check_page_free_list+0x1d8>
f0100d68:	68 ca 77 10 f0       	push   $0xf01077ca
f0100d6d:	68 21 77 10 f0       	push   $0xf0107721
f0100d72:	68 44 03 00 00       	push   $0x344
f0100d77:	68 36 77 10 f0       	push   $0xf0107736
f0100d7c:	e8 bf f2 ff ff       	call   f0100040 <_panic>
    cprintf("nfree_basemem:0x%x\tnfree_extmem:0x%x\n", nfree_basemem, nfree_extmem);
f0100d81:	83 ec 04             	sub    $0x4,%esp
f0100d84:	53                   	push   %ebx
f0100d85:	56                   	push   %esi
f0100d86:	68 1c 6a 10 f0       	push   $0xf0106a1c
f0100d8b:	e8 ef 2d 00 00       	call   f0103b7f <cprintf>
    cprintf("物理内存占用中页数:0x%x\n", 8 * PGSIZE - nfree_basemem - nfree_extmem);
f0100d90:	83 c4 08             	add    $0x8,%esp
f0100d93:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100d98:	29 f0                	sub    %esi,%eax
f0100d9a:	29 d8                	sub    %ebx,%eax
f0100d9c:	50                   	push   %eax
f0100d9d:	68 44 6a 10 f0       	push   $0xf0106a44
f0100da2:	e8 d8 2d 00 00       	call   f0103b7f <cprintf>
    assert(nfree_basemem > 0);
f0100da7:	83 c4 10             	add    $0x10,%esp
f0100daa:	85 f6                	test   %esi,%esi
f0100dac:	7e 19                	jle    f0100dc7 <check_page_free_list+0x29f>
    assert(nfree_extmem > 0);
f0100dae:	85 db                	test   %ebx,%ebx
f0100db0:	7e 2e                	jle    f0100de0 <check_page_free_list+0x2b8>
    cprintf("check_page_free_list() succeeded!\n");
f0100db2:	83 ec 0c             	sub    $0xc,%esp
f0100db5:	68 68 6a 10 f0       	push   $0xf0106a68
f0100dba:	e8 c0 2d 00 00       	call   f0103b7f <cprintf>
}
f0100dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dc2:	5b                   	pop    %ebx
f0100dc3:	5e                   	pop    %esi
f0100dc4:	5f                   	pop    %edi
f0100dc5:	5d                   	pop    %ebp
f0100dc6:	c3                   	ret    
    assert(nfree_basemem > 0);
f0100dc7:	68 e7 77 10 f0       	push   $0xf01077e7
f0100dcc:	68 21 77 10 f0       	push   $0xf0107721
f0100dd1:	68 50 03 00 00       	push   $0x350
f0100dd6:	68 36 77 10 f0       	push   $0xf0107736
f0100ddb:	e8 60 f2 ff ff       	call   f0100040 <_panic>
    assert(nfree_extmem > 0);
f0100de0:	68 f9 77 10 f0       	push   $0xf01077f9
f0100de5:	68 21 77 10 f0       	push   $0xf0107721
f0100dea:	68 51 03 00 00       	push   $0x351
f0100def:	68 36 77 10 f0       	push   $0xf0107736
f0100df4:	e8 47 f2 ff ff       	call   f0100040 <_panic>
    if (!page_free_list)
f0100df9:	a1 44 42 23 f0       	mov    0xf0234244,%eax
f0100dfe:	85 c0                	test   %eax,%eax
f0100e00:	0f 84 46 fd ff ff    	je     f0100b4c <check_page_free_list+0x24>
        struct PageInfo **tp[2] = {&pp1, &pp2};
f0100e06:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e09:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e0c:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e12:	89 c2                	mov    %eax,%edx
f0100e14:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
            int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e1a:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e20:	0f 95 c2             	setne  %dl
f0100e23:	0f b6 d2             	movzbl %dl,%edx
            *tp[pagetype] = pp;
f0100e26:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e2a:	89 01                	mov    %eax,(%ecx)
            tp[pagetype] = &pp->pp_link;
f0100e2c:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
        for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e30:	8b 00                	mov    (%eax),%eax
f0100e32:	85 c0                	test   %eax,%eax
f0100e34:	75 dc                	jne    f0100e12 <check_page_free_list+0x2ea>
        cprintf("pp:0x%x\tpp1:0x%x\tpp2:0x%x\t*tp[1]:0x%x\t*tp[0]:0x%x\ttp[0]:0x%x\ttp[1]:0x%x\n", pp, pp1, pp2, *tp[1],
f0100e36:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100e39:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100e3c:	56                   	push   %esi
f0100e3d:	53                   	push   %ebx
f0100e3e:	ff 33                	pushl  (%ebx)
f0100e40:	ff 36                	pushl  (%esi)
f0100e42:	ff 75 dc             	pushl  -0x24(%ebp)
f0100e45:	ff 75 d8             	pushl  -0x28(%ebp)
f0100e48:	6a 00                	push   $0x0
f0100e4a:	68 30 69 10 f0       	push   $0xf0106930
f0100e4f:	e8 2b 2d 00 00       	call   f0103b7f <cprintf>
        *tp[1] = 0;
f0100e54:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
        *tp[0] = pp2;
f0100e5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100e5d:	89 03                	mov    %eax,(%ebx)
        page_free_list = pp1;
f0100e5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e62:	a3 44 42 23 f0       	mov    %eax,0xf0234244
f0100e67:	83 c4 20             	add    $0x20,%esp
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e6a:	be 01 00 00 00       	mov    $0x1,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e6f:	8b 1d 44 42 23 f0    	mov    0xf0234244,%ebx
f0100e75:	e9 fd fc ff ff       	jmp    f0100b77 <check_page_free_list+0x4f>

f0100e7a <page_init>:
page_init(void) {
f0100e7a:	55                   	push   %ebp
f0100e7b:	89 e5                	mov    %esp,%ebp
f0100e7d:	57                   	push   %edi
f0100e7e:	56                   	push   %esi
f0100e7f:	53                   	push   %ebx
f0100e80:	83 ec 1c             	sub    $0x1c,%esp
    physaddr_t baseMemFreeStart = PGSIZE, baseMemFreeEnd = npages_basemem * PGSIZE,
f0100e83:	8b 3d 48 42 23 f0    	mov    0xf0234248,%edi
f0100e89:	89 fa                	mov    %edi,%edx
f0100e8b:	c1 e2 0c             	shl    $0xc,%edx
            extMemFreeStart = PADDR(pages) + ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) +
f0100e8e:	8b 0d 94 4e 23 f0    	mov    0xf0234e94,%ecx
	if ((uint32_t)kva < KERNBASE)
f0100e94:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100e9a:	76 5b                	jbe    f0100ef7 <page_init+0x7d>
f0100e9c:	a1 8c 4e 23 f0       	mov    0xf0234e8c,%eax
f0100ea1:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100ea8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ead:	8d b4 01 00 f0 01 10 	lea    0x1001f000(%ecx,%eax,1),%esi
                              ROUNDUP(NENV * sizeof(struct Env), PGSIZE), extMemFreeEnd =
f0100eb4:	a1 40 42 23 f0       	mov    0xf0234240,%eax
f0100eb9:	c1 e0 0a             	shl    $0xa,%eax
f0100ebc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("qemu空闲物理内存:[0x%x, 0x%x]\t[0x%x, 0x%x)\n", baseMemFreeStart, baseMemFreeEnd, extMemFreeStart,
f0100ebf:	83 ec 0c             	sub    $0xc,%esp
f0100ec2:	50                   	push   %eax
f0100ec3:	56                   	push   %esi
f0100ec4:	52                   	push   %edx
f0100ec5:	68 00 10 00 00       	push   $0x1000
f0100eca:	68 8c 6a 10 f0       	push   $0xf0106a8c
f0100ecf:	e8 ab 2c 00 00       	call   f0103b7f <cprintf>
    cprintf("初始page_free_list:0x%x\n", page_free_list);
f0100ed4:	83 c4 18             	add    $0x18,%esp
f0100ed7:	ff 35 44 42 23 f0    	pushl  0xf0234244
f0100edd:	68 0a 78 10 f0       	push   $0xf010780a
f0100ee2:	e8 98 2c 00 00       	call   f0103b7f <cprintf>
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0100ee7:	83 c4 10             	add    $0x10,%esp
f0100eea:	bb 01 00 00 00       	mov    $0x1,%ebx
f0100eef:	81 e7 ff ff 0f 00    	and    $0xfffff,%edi
f0100ef5:	eb 2d                	jmp    f0100f24 <page_init+0xaa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100ef7:	51                   	push   %ecx
f0100ef8:	68 88 63 10 f0       	push   $0xf0106388
f0100efd:	68 5c 01 00 00       	push   $0x15c
f0100f02:	68 36 77 10 f0       	push   $0xf0107736
f0100f07:	e8 34 f1 ff ff       	call   f0100040 <_panic>
            cprintf("avoid adding the page at MPENTRY_PADDR: 0x%x\n", i * PGSIZE);
f0100f0c:	83 ec 08             	sub    $0x8,%esp
f0100f0f:	68 00 70 00 00       	push   $0x7000
f0100f14:	68 c0 6a 10 f0       	push   $0xf0106ac0
f0100f19:	e8 61 2c 00 00       	call   f0103b7f <cprintf>
            continue;;
f0100f1e:	83 c4 10             	add    $0x10,%esp
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0100f21:	83 c3 01             	add    $0x1,%ebx
f0100f24:	39 df                	cmp    %ebx,%edi
f0100f26:	76 2f                	jbe    f0100f57 <page_init+0xdd>
        if (i == MPENTRY_PADDR / PGSIZE) {
f0100f28:	83 fb 07             	cmp    $0x7,%ebx
f0100f2b:	74 df                	je     f0100f0c <page_init+0x92>
        pages[i].pp_ref = 0;
f0100f2d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
f0100f34:	89 c2                	mov    %eax,%edx
f0100f36:	03 15 94 4e 23 f0    	add    0xf0234e94,%edx
f0100f3c:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
        pages[i].pp_link = page_free_list;
f0100f42:	8b 0d 44 42 23 f0    	mov    0xf0234244,%ecx
f0100f48:	89 0a                	mov    %ecx,(%edx)
        page_free_list = &pages[i];
f0100f4a:	03 05 94 4e 23 f0    	add    0xf0234e94,%eax
f0100f50:	a3 44 42 23 f0       	mov    %eax,0xf0234244
f0100f55:	eb ca                	jmp    f0100f21 <page_init+0xa7>
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f0100f57:	c1 ee 0c             	shr    $0xc,%esi
f0100f5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100f5d:	c1 eb 0c             	shr    $0xc,%ebx
f0100f60:	8b 0d 44 42 23 f0    	mov    0xf0234244,%ecx
f0100f66:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
f0100f6d:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f72:	bf 01 00 00 00       	mov    $0x1,%edi
f0100f77:	eb 20                	jmp    f0100f99 <page_init+0x11f>
        pages[i].pp_ref = 0;
f0100f79:	89 c2                	mov    %eax,%edx
f0100f7b:	03 15 94 4e 23 f0    	add    0xf0234e94,%edx
f0100f81:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
        pages[i].pp_link = page_free_list;
f0100f87:	89 0a                	mov    %ecx,(%edx)
        page_free_list = &pages[i];
f0100f89:	89 c1                	mov    %eax,%ecx
f0100f8b:	03 0d 94 4e 23 f0    	add    0xf0234e94,%ecx
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f0100f91:	83 c6 01             	add    $0x1,%esi
f0100f94:	83 c0 08             	add    $0x8,%eax
f0100f97:	89 fa                	mov    %edi,%edx
f0100f99:	39 f3                	cmp    %esi,%ebx
f0100f9b:	77 dc                	ja     f0100f79 <page_init+0xff>
f0100f9d:	84 d2                	test   %dl,%dl
f0100f9f:	75 38                	jne    f0100fd9 <page_init+0x15f>
               PADDR(page_free_list) >> 12);
f0100fa1:	a1 44 42 23 f0       	mov    0xf0234244,%eax
	if ((uint32_t)kva < KERNBASE)
f0100fa6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100fab:	76 34                	jbe    f0100fe1 <page_init+0x167>
	return (physaddr_t)kva - KERNBASE;
f0100fad:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("page_free_list", (uintptr_t) page_free_list, PDX(page_free_list), PADDR(page_free_list),
f0100fb3:	83 ec 0c             	sub    $0xc,%esp
f0100fb6:	89 d1                	mov    %edx,%ecx
f0100fb8:	c1 e9 0c             	shr    $0xc,%ecx
f0100fbb:	51                   	push   %ecx
f0100fbc:	52                   	push   %edx
f0100fbd:	89 c2                	mov    %eax,%edx
f0100fbf:	c1 ea 16             	shr    $0x16,%edx
f0100fc2:	52                   	push   %edx
f0100fc3:	50                   	push   %eax
f0100fc4:	68 25 78 10 f0       	push   $0xf0107825
f0100fc9:	e8 c5 2b 00 00       	call   f0103b93 <memCprintf>
}
f0100fce:	83 c4 20             	add    $0x20,%esp
f0100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fd4:	5b                   	pop    %ebx
f0100fd5:	5e                   	pop    %esi
f0100fd6:	5f                   	pop    %edi
f0100fd7:	5d                   	pop    %ebp
f0100fd8:	c3                   	ret    
f0100fd9:	89 0d 44 42 23 f0    	mov    %ecx,0xf0234244
f0100fdf:	eb c0                	jmp    f0100fa1 <page_init+0x127>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100fe1:	50                   	push   %eax
f0100fe2:	68 88 63 10 f0       	push   $0xf0106388
f0100fe7:	68 77 01 00 00       	push   $0x177
f0100fec:	68 36 77 10 f0       	push   $0xf0107736
f0100ff1:	e8 4a f0 ff ff       	call   f0100040 <_panic>

f0100ff6 <page_alloc>:
page_alloc(int alloc_flags) {
f0100ff6:	55                   	push   %ebp
f0100ff7:	89 e5                	mov    %esp,%ebp
f0100ff9:	53                   	push   %ebx
f0100ffa:	83 ec 04             	sub    $0x4,%esp
    if (!page_free_list) {
f0100ffd:	8b 1d 44 42 23 f0    	mov    0xf0234244,%ebx
f0101003:	85 db                	test   %ebx,%ebx
f0101005:	74 19                	je     f0101020 <page_alloc+0x2a>
    page_free_list = page_free_list->pp_link;
f0101007:	8b 03                	mov    (%ebx),%eax
f0101009:	a3 44 42 23 f0       	mov    %eax,0xf0234244
    allocPage->pp_link = NULL;
f010100e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    allocPage->pp_ref = 0;
f0101014:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
    if (alloc_flags & ALLOC_ZERO) {
f010101a:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f010101e:	75 07                	jne    f0101027 <page_alloc+0x31>
}
f0101020:	89 d8                	mov    %ebx,%eax
f0101022:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101025:	c9                   	leave  
f0101026:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101027:	89 d8                	mov    %ebx,%eax
f0101029:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f010102f:	c1 f8 03             	sar    $0x3,%eax
f0101032:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101035:	89 c2                	mov    %eax,%edx
f0101037:	c1 ea 0c             	shr    $0xc,%edx
f010103a:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0101040:	73 1a                	jae    f010105c <page_alloc+0x66>
        memset(page2kva(allocPage), 0, PGSIZE);
f0101042:	83 ec 04             	sub    $0x4,%esp
f0101045:	68 00 10 00 00       	push   $0x1000
f010104a:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010104c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101051:	50                   	push   %eax
f0101052:	e8 61 46 00 00       	call   f01056b8 <memset>
f0101057:	83 c4 10             	add    $0x10,%esp
f010105a:	eb c4                	jmp    f0101020 <page_alloc+0x2a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010105c:	50                   	push   %eax
f010105d:	68 64 63 10 f0       	push   $0xf0106364
f0101062:	6a 58                	push   $0x58
f0101064:	68 42 77 10 f0       	push   $0xf0107742
f0101069:	e8 d2 ef ff ff       	call   f0100040 <_panic>

f010106e <page_free>:
page_free(struct PageInfo *pp) {
f010106e:	55                   	push   %ebp
f010106f:	89 e5                	mov    %esp,%ebp
f0101071:	83 ec 08             	sub    $0x8,%esp
f0101074:	8b 45 08             	mov    0x8(%ebp),%eax
    assert(!pp->pp_ref);
f0101077:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010107c:	75 14                	jne    f0101092 <page_free+0x24>
    assert(!pp->pp_link);
f010107e:	83 38 00             	cmpl   $0x0,(%eax)
f0101081:	75 28                	jne    f01010ab <page_free+0x3d>
    pp->pp_link = page_free_list;
f0101083:	8b 15 44 42 23 f0    	mov    0xf0234244,%edx
f0101089:	89 10                	mov    %edx,(%eax)
    page_free_list = pp;
f010108b:	a3 44 42 23 f0       	mov    %eax,0xf0234244
}
f0101090:	c9                   	leave  
f0101091:	c3                   	ret    
    assert(!pp->pp_ref);
f0101092:	68 34 78 10 f0       	push   $0xf0107834
f0101097:	68 21 77 10 f0       	push   $0xf0107721
f010109c:	68 9e 01 00 00       	push   $0x19e
f01010a1:	68 36 77 10 f0       	push   $0xf0107736
f01010a6:	e8 95 ef ff ff       	call   f0100040 <_panic>
    assert(!pp->pp_link);
f01010ab:	68 40 78 10 f0       	push   $0xf0107840
f01010b0:	68 21 77 10 f0       	push   $0xf0107721
f01010b5:	68 9f 01 00 00       	push   $0x19f
f01010ba:	68 36 77 10 f0       	push   $0xf0107736
f01010bf:	e8 7c ef ff ff       	call   f0100040 <_panic>

f01010c4 <page_decref>:
page_decref(struct PageInfo *pp) {
f01010c4:	55                   	push   %ebp
f01010c5:	89 e5                	mov    %esp,%ebp
f01010c7:	83 ec 08             	sub    $0x8,%esp
f01010ca:	8b 55 08             	mov    0x8(%ebp),%edx
    if (--pp->pp_ref == 0)
f01010cd:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010d1:	83 e8 01             	sub    $0x1,%eax
f01010d4:	66 89 42 04          	mov    %ax,0x4(%edx)
f01010d8:	66 85 c0             	test   %ax,%ax
f01010db:	74 02                	je     f01010df <page_decref+0x1b>
}
f01010dd:	c9                   	leave  
f01010de:	c3                   	ret    
        page_free(pp);
f01010df:	83 ec 0c             	sub    $0xc,%esp
f01010e2:	52                   	push   %edx
f01010e3:	e8 86 ff ff ff       	call   f010106e <page_free>
f01010e8:	83 c4 10             	add    $0x10,%esp
}
f01010eb:	eb f0                	jmp    f01010dd <page_decref+0x19>

f01010ed <pgdir_walk>:
pgdir_walk(pde_t *pgdir, const void *va, int create) {
f01010ed:	55                   	push   %ebp
f01010ee:	89 e5                	mov    %esp,%ebp
f01010f0:	56                   	push   %esi
f01010f1:	53                   	push   %ebx
f01010f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (!(pgTablePaAddr = PTE_ADDR(pgdir[PDX(va)]))) {
f01010f5:	89 de                	mov    %ebx,%esi
f01010f7:	c1 ee 16             	shr    $0x16,%esi
f01010fa:	c1 e6 02             	shl    $0x2,%esi
f01010fd:	03 75 08             	add    0x8(%ebp),%esi
f0101100:	8b 06                	mov    (%esi),%eax
f0101102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101107:	75 2f                	jne    f0101138 <pgdir_walk+0x4b>
        if (!create) {
f0101109:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010110d:	74 62                	je     f0101171 <pgdir_walk+0x84>
            struct PageInfo *pageInfo = page_alloc(ALLOC_ZERO);
f010110f:	83 ec 0c             	sub    $0xc,%esp
f0101112:	6a 01                	push   $0x1
f0101114:	e8 dd fe ff ff       	call   f0100ff6 <page_alloc>
            if (!pageInfo) {
f0101119:	83 c4 10             	add    $0x10,%esp
f010111c:	85 c0                	test   %eax,%eax
f010111e:	74 58                	je     f0101178 <pgdir_walk+0x8b>
            pageInfo->pp_ref++;
f0101120:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101125:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f010112b:	c1 f8 03             	sar    $0x3,%eax
f010112e:	c1 e0 0c             	shl    $0xc,%eax
            pgdir[PDX(va)] = pgTablePaAddr | PTE_U | PTE_W | PTE_P;//消极权限
f0101131:	89 c2                	mov    %eax,%edx
f0101133:	83 ca 07             	or     $0x7,%edx
f0101136:	89 16                	mov    %edx,(%esi)
	if (PGNUM(pa) >= npages)
f0101138:	89 c2                	mov    %eax,%edx
f010113a:	c1 ea 0c             	shr    $0xc,%edx
f010113d:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0101143:	73 17                	jae    f010115c <pgdir_walk+0x6f>
    return &((pte_t *) KADDR(pgTablePaAddr))[PTX(va)];
f0101145:	c1 eb 0a             	shr    $0xa,%ebx
f0101148:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
f010114e:	8d 84 18 00 00 00 f0 	lea    -0x10000000(%eax,%ebx,1),%eax
}
f0101155:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101158:	5b                   	pop    %ebx
f0101159:	5e                   	pop    %esi
f010115a:	5d                   	pop    %ebp
f010115b:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010115c:	50                   	push   %eax
f010115d:	68 64 63 10 f0       	push   $0xf0106364
f0101162:	68 03 02 00 00       	push   $0x203
f0101167:	68 36 77 10 f0       	push   $0xf0107736
f010116c:	e8 cf ee ff ff       	call   f0100040 <_panic>
            return NULL;
f0101171:	b8 00 00 00 00       	mov    $0x0,%eax
f0101176:	eb dd                	jmp    f0101155 <pgdir_walk+0x68>
                return NULL;
f0101178:	b8 00 00 00 00       	mov    $0x0,%eax
f010117d:	eb d6                	jmp    f0101155 <pgdir_walk+0x68>

f010117f <boot_map_region>:
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm) {
f010117f:	55                   	push   %ebp
f0101180:	89 e5                	mov    %esp,%ebp
f0101182:	57                   	push   %edi
f0101183:	56                   	push   %esi
f0101184:	53                   	push   %ebx
f0101185:	83 ec 1c             	sub    $0x1c,%esp
f0101188:	89 c7                	mov    %eax,%edi
f010118a:	89 d6                	mov    %edx,%esi
f010118c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE) {
f010118f:	bb 00 00 00 00       	mov    $0x0,%ebx
        *pte = (pa + offset) | perm | PTE_P;
f0101194:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101197:	83 c8 01             	or     $0x1,%eax
f010119a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE) {
f010119d:	eb 22                	jmp    f01011c1 <boot_map_region+0x42>
        pte_t *pte = pgdir_walk(pgdir, (void *) va + offset, 1);
f010119f:	83 ec 04             	sub    $0x4,%esp
f01011a2:	6a 01                	push   $0x1
f01011a4:	8d 04 33             	lea    (%ebx,%esi,1),%eax
f01011a7:	50                   	push   %eax
f01011a8:	57                   	push   %edi
f01011a9:	e8 3f ff ff ff       	call   f01010ed <pgdir_walk>
        *pte = (pa + offset) | perm | PTE_P;
f01011ae:	89 da                	mov    %ebx,%edx
f01011b0:	03 55 08             	add    0x8(%ebp),%edx
f01011b3:	0b 55 e0             	or     -0x20(%ebp),%edx
f01011b6:	89 10                	mov    %edx,(%eax)
    for (offset = 0; offset < size; offset += PGSIZE) {
f01011b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01011be:	83 c4 10             	add    $0x10,%esp
f01011c1:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01011c4:	72 d9                	jb     f010119f <boot_map_region+0x20>
}
f01011c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011c9:	5b                   	pop    %ebx
f01011ca:	5e                   	pop    %esi
f01011cb:	5f                   	pop    %edi
f01011cc:	5d                   	pop    %ebp
f01011cd:	c3                   	ret    

f01011ce <page_lookup>:
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store) {
f01011ce:	55                   	push   %ebp
f01011cf:	89 e5                	mov    %esp,%ebp
f01011d1:	53                   	push   %ebx
f01011d2:	83 ec 08             	sub    $0x8,%esp
f01011d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    pte_t *cur = pgdir_walk(pgdir, va, false);
f01011d8:	6a 00                	push   $0x0
f01011da:	ff 75 0c             	pushl  0xc(%ebp)
f01011dd:	ff 75 08             	pushl  0x8(%ebp)
f01011e0:	e8 08 ff ff ff       	call   f01010ed <pgdir_walk>
    if (!cur) {
f01011e5:	83 c4 10             	add    $0x10,%esp
f01011e8:	85 c0                	test   %eax,%eax
f01011ea:	74 35                	je     f0101221 <page_lookup+0x53>
    if (pte_store) {
f01011ec:	85 db                	test   %ebx,%ebx
f01011ee:	74 02                	je     f01011f2 <page_lookup+0x24>
        *pte_store = cur;
f01011f0:	89 03                	mov    %eax,(%ebx)
f01011f2:	8b 00                	mov    (%eax),%eax
f01011f4:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01011f7:	39 05 8c 4e 23 f0    	cmp    %eax,0xf0234e8c
f01011fd:	76 0e                	jbe    f010120d <page_lookup+0x3f>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01011ff:	8b 15 94 4e 23 f0    	mov    0xf0234e94,%edx
f0101205:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101208:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010120b:	c9                   	leave  
f010120c:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010120d:	83 ec 04             	sub    $0x4,%esp
f0101210:	68 f0 6a 10 f0       	push   $0xf0106af0
f0101215:	6a 51                	push   $0x51
f0101217:	68 42 77 10 f0       	push   $0xf0107742
f010121c:	e8 1f ee ff ff       	call   f0100040 <_panic>
        return NULL;
f0101221:	b8 00 00 00 00       	mov    $0x0,%eax
f0101226:	eb e0                	jmp    f0101208 <page_lookup+0x3a>

f0101228 <page_remove>:
page_remove(pde_t *pgdir, void *va) {
f0101228:	55                   	push   %ebp
f0101229:	89 e5                	mov    %esp,%ebp
f010122b:	53                   	push   %ebx
f010122c:	83 ec 18             	sub    $0x18,%esp
f010122f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    struct PageInfo *pageInfo = page_lookup(pgdir, va, &pte);
f0101232:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101235:	50                   	push   %eax
f0101236:	53                   	push   %ebx
f0101237:	ff 75 08             	pushl  0x8(%ebp)
f010123a:	e8 8f ff ff ff       	call   f01011ce <page_lookup>
    if (!pageInfo) {
f010123f:	83 c4 10             	add    $0x10,%esp
f0101242:	85 c0                	test   %eax,%eax
f0101244:	75 05                	jne    f010124b <page_remove+0x23>
}
f0101246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101249:	c9                   	leave  
f010124a:	c3                   	ret    
    page_decref(pageInfo);
f010124b:	83 ec 0c             	sub    $0xc,%esp
f010124e:	50                   	push   %eax
f010124f:	e8 70 fe ff ff       	call   f01010c4 <page_decref>
    memset(pte, 0, sizeof(pte_t));
f0101254:	83 c4 0c             	add    $0xc,%esp
f0101257:	6a 04                	push   $0x4
f0101259:	6a 00                	push   $0x0
f010125b:	ff 75 f4             	pushl  -0xc(%ebp)
f010125e:	e8 55 44 00 00       	call   f01056b8 <memset>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101263:	0f 01 3b             	invlpg (%ebx)
f0101266:	83 c4 10             	add    $0x10,%esp
f0101269:	eb db                	jmp    f0101246 <page_remove+0x1e>

f010126b <page_insert>:
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm) {
f010126b:	55                   	push   %ebp
f010126c:	89 e5                	mov    %esp,%ebp
f010126e:	57                   	push   %edi
f010126f:	56                   	push   %esi
f0101270:	53                   	push   %ebx
f0101271:	83 ec 20             	sub    $0x20,%esp
f0101274:	8b 75 08             	mov    0x8(%ebp),%esi
f0101277:	8b 7d 10             	mov    0x10(%ebp),%edi
    pte_t *cur = pgdir_walk(pgdir, va, false);
f010127a:	6a 00                	push   $0x0
f010127c:	57                   	push   %edi
f010127d:	56                   	push   %esi
f010127e:	e8 6a fe ff ff       	call   f01010ed <pgdir_walk>
f0101283:	89 c3                	mov    %eax,%ebx
    if (cur) {
f0101285:	83 c4 10             	add    $0x10,%esp
f0101288:	85 c0                	test   %eax,%eax
f010128a:	74 41                	je     f01012cd <page_insert+0x62>
f010128c:	8b 00                	mov    (%eax),%eax
f010128e:	c1 e8 0c             	shr    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101291:	39 05 8c 4e 23 f0    	cmp    %eax,0xf0234e8c
f0101297:	76 20                	jbe    f01012b9 <page_insert+0x4e>
	return &pages[PGNUM(pa)];
f0101299:	8b 15 94 4e 23 f0    	mov    0xf0234e94,%edx
f010129f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01012a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (tmp != pp) {
f01012a5:	39 45 0c             	cmp    %eax,0xc(%ebp)
f01012a8:	74 2a                	je     f01012d4 <page_insert+0x69>
            page_remove(pgdir, va);
f01012aa:	83 ec 08             	sub    $0x8,%esp
f01012ad:	57                   	push   %edi
f01012ae:	56                   	push   %esi
f01012af:	e8 74 ff ff ff       	call   f0101228 <page_remove>
f01012b4:	83 c4 10             	add    $0x10,%esp
f01012b7:	eb 1b                	jmp    f01012d4 <page_insert+0x69>
		panic("pa2page called with invalid pa");
f01012b9:	83 ec 04             	sub    $0x4,%esp
f01012bc:	68 f0 6a 10 f0       	push   $0xf0106af0
f01012c1:	6a 51                	push   $0x51
f01012c3:	68 42 77 10 f0       	push   $0xf0107742
f01012c8:	e8 73 ed ff ff       	call   f0100040 <_panic>
    struct PageInfo *tmp = NULL;
f01012cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    physaddr_t pgTablePaAddr = PTE_ADDR(pgdir[PDX(va)]);
f01012d4:	89 f8                	mov    %edi,%eax
f01012d6:	c1 e8 16             	shr    $0x16,%eax
f01012d9:	8d 34 86             	lea    (%esi,%eax,4),%esi
    if (!pgTablePaAddr) {
f01012dc:	8b 06                	mov    (%esi),%eax
f01012de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01012e3:	74 64                	je     f0101349 <page_insert+0xde>
	return (pp - pages) << PGSHIFT;
f01012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01012e8:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f01012ee:	c1 fa 03             	sar    $0x3,%edx
f01012f1:	c1 e2 0c             	shl    $0xc,%edx
f01012f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01012f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01012fa:	83 c9 01             	or     $0x1,%ecx
	if (PGNUM(pa) >= npages)
f01012fd:	89 c2                	mov    %eax,%edx
f01012ff:	c1 ea 0c             	shr    $0xc,%edx
f0101302:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0101308:	73 70                	jae    f010137a <page_insert+0x10f>
    ((pte_t *) KADDR(pgTablePaAddr))[PTX(va)] = page2pa(pp) | perm | PTE_P;
f010130a:	c1 ef 0c             	shr    $0xc,%edi
f010130d:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
f0101313:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101316:	09 ca                	or     %ecx,%edx
f0101318:	89 94 b8 00 00 00 f0 	mov    %edx,-0x10000000(%eax,%edi,4)
    pgdir[PDX(va)] = pgTablePaAddr | perm | PTE_P;
f010131f:	09 c8                	or     %ecx,%eax
f0101321:	89 06                	mov    %eax,(%esi)
    if (!cur || tmp != pp) {
f0101323:	85 db                	test   %ebx,%ebx
f0101325:	74 0d                	je     f0101334 <page_insert+0xc9>
    return 0;
f0101327:	b8 00 00 00 00       	mov    $0x0,%eax
    if (!cur || tmp != pp) {
f010132c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010132f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0101332:	74 0d                	je     f0101341 <page_insert+0xd6>
        pp->pp_ref++;
f0101334:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101337:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    return 0;
f010133c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101341:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101344:	5b                   	pop    %ebx
f0101345:	5e                   	pop    %esi
f0101346:	5f                   	pop    %edi
f0101347:	5d                   	pop    %ebp
f0101348:	c3                   	ret    
        struct PageInfo *pageInfo = page_alloc(ALLOC_ZERO);
f0101349:	83 ec 0c             	sub    $0xc,%esp
f010134c:	6a 01                	push   $0x1
f010134e:	e8 a3 fc ff ff       	call   f0100ff6 <page_alloc>
        if (!pageInfo) {
f0101353:	83 c4 10             	add    $0x10,%esp
f0101356:	85 c0                	test   %eax,%eax
f0101358:	74 35                	je     f010138f <page_insert+0x124>
        pageInfo->pp_ref++;
f010135a:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010135f:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0101365:	c1 f8 03             	sar    $0x3,%eax
f0101368:	c1 e0 0c             	shl    $0xc,%eax
        pgdir[PDX(va)] = pgTablePaAddr | perm | PTE_P;
f010136b:	8b 55 14             	mov    0x14(%ebp),%edx
f010136e:	83 ca 01             	or     $0x1,%edx
f0101371:	09 c2                	or     %eax,%edx
f0101373:	89 16                	mov    %edx,(%esi)
f0101375:	e9 6b ff ff ff       	jmp    f01012e5 <page_insert+0x7a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010137a:	50                   	push   %eax
f010137b:	68 64 63 10 f0       	push   $0xf0106364
f0101380:	68 4f 02 00 00       	push   $0x24f
f0101385:	68 36 77 10 f0       	push   $0xf0107736
f010138a:	e8 b1 ec ff ff       	call   f0100040 <_panic>
            return -E_NO_MEM;
f010138f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101394:	eb ab                	jmp    f0101341 <page_insert+0xd6>

f0101396 <mem_init>:
mem_init(void) {
f0101396:	55                   	push   %ebp
f0101397:	89 e5                	mov    %esp,%ebp
f0101399:	57                   	push   %edi
f010139a:	56                   	push   %esi
f010139b:	53                   	push   %ebx
f010139c:	83 ec 3c             	sub    $0x3c,%esp
    basemem = nvram_read(NVRAM_BASELO);
f010139f:	b8 15 00 00 00       	mov    $0x15,%eax
f01013a4:	e8 90 f6 ff ff       	call   f0100a39 <nvram_read>
f01013a9:	89 c3                	mov    %eax,%ebx
    extmem = nvram_read(NVRAM_EXTLO);
f01013ab:	b8 17 00 00 00       	mov    $0x17,%eax
f01013b0:	e8 84 f6 ff ff       	call   f0100a39 <nvram_read>
f01013b5:	89 c6                	mov    %eax,%esi
    ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01013b7:	b8 34 00 00 00       	mov    $0x34,%eax
f01013bc:	e8 78 f6 ff ff       	call   f0100a39 <nvram_read>
f01013c1:	c1 e0 06             	shl    $0x6,%eax
    if (ext16mem)
f01013c4:	85 c0                	test   %eax,%eax
f01013c6:	0f 85 3c 02 00 00    	jne    f0101608 <mem_init+0x272>
        totalmem = 1 * 1024 + extmem;
f01013cc:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01013d2:	85 f6                	test   %esi,%esi
f01013d4:	0f 44 c3             	cmove  %ebx,%eax
f01013d7:	a3 40 42 23 f0       	mov    %eax,0xf0234240
    npages = totalmem / (PGSIZE / 1024);
f01013dc:	a1 40 42 23 f0       	mov    0xf0234240,%eax
f01013e1:	89 c2                	mov    %eax,%edx
f01013e3:	c1 ea 02             	shr    $0x2,%edx
f01013e6:	89 15 8c 4e 23 f0    	mov    %edx,0xf0234e8c
    npages_basemem = basemem / (PGSIZE / 1024);
f01013ec:	89 da                	mov    %ebx,%edx
f01013ee:	c1 ea 02             	shr    $0x2,%edx
f01013f1:	89 15 48 42 23 f0    	mov    %edx,0xf0234248
    cprintf("Physical memory: 0x%xK available\tbase = 0x%xK\textended = 0x%xK\n",
f01013f7:	89 c2                	mov    %eax,%edx
f01013f9:	29 da                	sub    %ebx,%edx
f01013fb:	52                   	push   %edx
f01013fc:	53                   	push   %ebx
f01013fd:	50                   	push   %eax
f01013fe:	68 10 6b 10 f0       	push   $0xf0106b10
f0101403:	e8 77 27 00 00       	call   f0103b7f <cprintf>
    cprintf("sizeof(uint16_t):0x%x\n", sizeof(unsigned short));
f0101408:	83 c4 08             	add    $0x8,%esp
f010140b:	6a 02                	push   $0x2
f010140d:	68 4d 78 10 f0       	push   $0xf010784d
f0101412:	e8 68 27 00 00       	call   f0103b7f <cprintf>
    cprintf("npages:0x%x\tsizeof(Struct PageInfo):0x%x\n", npages, sizeof(struct PageInfo));
f0101417:	83 c4 0c             	add    $0xc,%esp
f010141a:	6a 08                	push   $0x8
f010141c:	ff 35 8c 4e 23 f0    	pushl  0xf0234e8c
f0101422:	68 50 6b 10 f0       	push   $0xf0106b50
f0101427:	e8 53 27 00 00       	call   f0103b7f <cprintf>
    kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f010142c:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101431:	e8 2c f6 ff ff       	call   f0100a62 <boot_alloc>
f0101436:	a3 90 4e 23 f0       	mov    %eax,0xf0234e90
	if ((uint32_t)kva < KERNBASE)
f010143b:	83 c4 10             	add    $0x10,%esp
f010143e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101443:	0f 86 ce 01 00 00    	jbe    f0101617 <mem_init+0x281>
	return (physaddr_t)kva - KERNBASE;
f0101449:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("kern_pgdir", (uintptr_t) kern_pgdir, PDX(kern_pgdir), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f010144f:	83 ec 0c             	sub    $0xc,%esp
f0101452:	89 d1                	mov    %edx,%ecx
f0101454:	c1 e9 0c             	shr    $0xc,%ecx
f0101457:	51                   	push   %ecx
f0101458:	52                   	push   %edx
f0101459:	89 c2                	mov    %eax,%edx
f010145b:	c1 ea 16             	shr    $0x16,%edx
f010145e:	52                   	push   %edx
f010145f:	50                   	push   %eax
f0101460:	68 64 78 10 f0       	push   $0xf0107864
f0101465:	e8 29 27 00 00       	call   f0103b93 <memCprintf>
    memset(kern_pgdir, 0, PGSIZE);
f010146a:	83 c4 1c             	add    $0x1c,%esp
f010146d:	68 00 10 00 00       	push   $0x1000
f0101472:	6a 00                	push   $0x0
f0101474:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f010147a:	e8 39 42 00 00       	call   f01056b8 <memset>
    kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f010147f:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0101484:	83 c4 10             	add    $0x10,%esp
f0101487:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010148c:	0f 86 9a 01 00 00    	jbe    f010162c <mem_init+0x296>
	return (physaddr_t)kva - KERNBASE;
f0101492:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101498:	89 d1                	mov    %edx,%ecx
f010149a:	83 c9 05             	or     $0x5,%ecx
f010149d:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f01014a3:	83 ec 0c             	sub    $0xc,%esp
f01014a6:	89 d0                	mov    %edx,%eax
f01014a8:	c1 e8 0c             	shr    $0xc,%eax
f01014ab:	50                   	push   %eax
f01014ac:	52                   	push   %edx
f01014ad:	68 bd 03 00 00       	push   $0x3bd
f01014b2:	68 00 00 40 ef       	push   $0xef400000
f01014b7:	68 6f 78 10 f0       	push   $0xf010786f
f01014bc:	e8 d2 26 00 00       	call   f0103b93 <memCprintf>
    pages = boot_alloc(ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01014c1:	83 c4 20             	add    $0x20,%esp
f01014c4:	a1 8c 4e 23 f0       	mov    0xf0234e8c,%eax
f01014c9:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01014d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01014d5:	e8 88 f5 ff ff       	call   f0100a62 <boot_alloc>
f01014da:	a3 94 4e 23 f0       	mov    %eax,0xf0234e94
    memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01014df:	83 ec 04             	sub    $0x4,%esp
f01014e2:	8b 15 8c 4e 23 f0    	mov    0xf0234e8c,%edx
f01014e8:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f01014ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01014f5:	52                   	push   %edx
f01014f6:	6a 00                	push   $0x0
f01014f8:	50                   	push   %eax
f01014f9:	e8 ba 41 00 00       	call   f01056b8 <memset>
    cprintf("pages占用空间:%dK\n", ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) / 1024);
f01014fe:	83 c4 08             	add    $0x8,%esp
f0101501:	a1 8c 4e 23 f0       	mov    0xf0234e8c,%eax
f0101506:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010150d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101512:	c1 e8 0a             	shr    $0xa,%eax
f0101515:	50                   	push   %eax
f0101516:	68 74 78 10 f0       	push   $0xf0107874
f010151b:	e8 5f 26 00 00       	call   f0103b7f <cprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f0101520:	a1 94 4e 23 f0       	mov    0xf0234e94,%eax
	if ((uint32_t)kva < KERNBASE)
f0101525:	83 c4 10             	add    $0x10,%esp
f0101528:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010152d:	0f 86 0e 01 00 00    	jbe    f0101641 <mem_init+0x2ab>
	return (physaddr_t)kva - KERNBASE;
f0101533:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101539:	83 ec 0c             	sub    $0xc,%esp
f010153c:	89 d1                	mov    %edx,%ecx
f010153e:	c1 e9 0c             	shr    $0xc,%ecx
f0101541:	51                   	push   %ecx
f0101542:	52                   	push   %edx
f0101543:	89 c2                	mov    %eax,%edx
f0101545:	c1 ea 16             	shr    $0x16,%edx
f0101548:	52                   	push   %edx
f0101549:	50                   	push   %eax
f010154a:	68 6c 77 10 f0       	push   $0xf010776c
f010154f:	e8 3f 26 00 00       	call   f0103b93 <memCprintf>
    cprintf("sizeof(struct Env):0x%x\n", sizeof(struct Env));
f0101554:	83 c4 18             	add    $0x18,%esp
f0101557:	6a 7c                	push   $0x7c
f0101559:	68 8b 78 10 f0       	push   $0xf010788b
f010155e:	e8 1c 26 00 00       	call   f0103b7f <cprintf>
    envs = boot_alloc(ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101563:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101568:	e8 f5 f4 ff ff       	call   f0100a62 <boot_alloc>
f010156d:	a3 4c 42 23 f0       	mov    %eax,0xf023424c
    memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101572:	83 c4 0c             	add    $0xc,%esp
f0101575:	68 00 f0 01 00       	push   $0x1f000
f010157a:	6a 00                	push   $0x0
f010157c:	50                   	push   %eax
f010157d:	e8 36 41 00 00       	call   f01056b8 <memset>
    cprintf("envs take up memory:%dK\n", ROUNDUP(NENV * sizeof(struct Env), PGSIZE) / 1024);
f0101582:	83 c4 08             	add    $0x8,%esp
f0101585:	6a 7c                	push   $0x7c
f0101587:	68 a4 78 10 f0       	push   $0xf01078a4
f010158c:	e8 ee 25 00 00       	call   f0103b7f <cprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f0101591:	a1 4c 42 23 f0       	mov    0xf023424c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101596:	83 c4 10             	add    $0x10,%esp
f0101599:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010159e:	0f 86 b2 00 00 00    	jbe    f0101656 <mem_init+0x2c0>
	return (physaddr_t)kva - KERNBASE;
f01015a4:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01015aa:	83 ec 0c             	sub    $0xc,%esp
f01015ad:	89 d1                	mov    %edx,%ecx
f01015af:	c1 e9 0c             	shr    $0xc,%ecx
f01015b2:	51                   	push   %ecx
f01015b3:	52                   	push   %edx
f01015b4:	89 c2                	mov    %eax,%edx
f01015b6:	c1 ea 16             	shr    $0x16,%edx
f01015b9:	52                   	push   %edx
f01015ba:	50                   	push   %eax
f01015bb:	68 bd 78 10 f0       	push   $0xf01078bd
f01015c0:	e8 ce 25 00 00       	call   f0103b93 <memCprintf>
    page_init();
f01015c5:	83 c4 20             	add    $0x20,%esp
f01015c8:	e8 ad f8 ff ff       	call   f0100e7a <page_init>
    cprintf("\n************* Now Check that the pages on the page_free_list are reasonable ************\n");
f01015cd:	83 ec 0c             	sub    $0xc,%esp
f01015d0:	68 7c 6b 10 f0       	push   $0xf0106b7c
f01015d5:	e8 a5 25 00 00       	call   f0103b7f <cprintf>
    check_page_free_list(1);
f01015da:	b8 01 00 00 00       	mov    $0x1,%eax
f01015df:	e8 44 f5 ff ff       	call   f0100b28 <check_page_free_list>
    cprintf("\n************* Now check the real physical page allocator (page_alloc(), page_free(), and page_init())************\n");
f01015e4:	c7 04 24 d8 6b 10 f0 	movl   $0xf0106bd8,(%esp)
f01015eb:	e8 8f 25 00 00       	call   f0103b7f <cprintf>
    if (!pages)
f01015f0:	83 c4 10             	add    $0x10,%esp
f01015f3:	83 3d 94 4e 23 f0 00 	cmpl   $0x0,0xf0234e94
f01015fa:	74 6f                	je     f010166b <mem_init+0x2d5>
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01015fc:	a1 44 42 23 f0       	mov    0xf0234244,%eax
f0101601:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101606:	eb 7f                	jmp    f0101687 <mem_init+0x2f1>
        totalmem = 16 * 1024 + ext16mem;
f0101608:	05 00 40 00 00       	add    $0x4000,%eax
f010160d:	a3 40 42 23 f0       	mov    %eax,0xf0234240
f0101612:	e9 c5 fd ff ff       	jmp    f01013dc <mem_init+0x46>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101617:	50                   	push   %eax
f0101618:	68 88 63 10 f0       	push   $0xf0106388
f010161d:	68 98 00 00 00       	push   $0x98
f0101622:	68 36 77 10 f0       	push   $0xf0107736
f0101627:	e8 14 ea ff ff       	call   f0100040 <_panic>
f010162c:	50                   	push   %eax
f010162d:	68 88 63 10 f0       	push   $0xf0106388
f0101632:	68 a2 00 00 00       	push   $0xa2
f0101637:	68 36 77 10 f0       	push   $0xf0107736
f010163c:	e8 ff e9 ff ff       	call   f0100040 <_panic>
f0101641:	50                   	push   %eax
f0101642:	68 88 63 10 f0       	push   $0xf0106388
f0101647:	68 af 00 00 00       	push   $0xaf
f010164c:	68 36 77 10 f0       	push   $0xf0107736
f0101651:	e8 ea e9 ff ff       	call   f0100040 <_panic>
f0101656:	50                   	push   %eax
f0101657:	68 88 63 10 f0       	push   $0xf0106388
f010165c:	68 b7 00 00 00       	push   $0xb7
f0101661:	68 36 77 10 f0       	push   $0xf0107736
f0101666:	e8 d5 e9 ff ff       	call   f0100040 <_panic>
        panic("'pages' is a null pointer!");
f010166b:	83 ec 04             	sub    $0x4,%esp
f010166e:	68 c2 78 10 f0       	push   $0xf01078c2
f0101673:	68 62 03 00 00       	push   $0x362
f0101678:	68 36 77 10 f0       	push   $0xf0107736
f010167d:	e8 be e9 ff ff       	call   f0100040 <_panic>
        ++nfree;
f0101682:	83 c3 01             	add    $0x1,%ebx
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101685:	8b 00                	mov    (%eax),%eax
f0101687:	85 c0                	test   %eax,%eax
f0101689:	75 f7                	jne    f0101682 <mem_init+0x2ec>
    assert((pp0 = page_alloc(0)));
f010168b:	83 ec 0c             	sub    $0xc,%esp
f010168e:	6a 00                	push   $0x0
f0101690:	e8 61 f9 ff ff       	call   f0100ff6 <page_alloc>
f0101695:	89 c7                	mov    %eax,%edi
f0101697:	83 c4 10             	add    $0x10,%esp
f010169a:	85 c0                	test   %eax,%eax
f010169c:	0f 84 12 02 00 00    	je     f01018b4 <mem_init+0x51e>
    assert((pp1 = page_alloc(0)));
f01016a2:	83 ec 0c             	sub    $0xc,%esp
f01016a5:	6a 00                	push   $0x0
f01016a7:	e8 4a f9 ff ff       	call   f0100ff6 <page_alloc>
f01016ac:	89 c6                	mov    %eax,%esi
f01016ae:	83 c4 10             	add    $0x10,%esp
f01016b1:	85 c0                	test   %eax,%eax
f01016b3:	0f 84 14 02 00 00    	je     f01018cd <mem_init+0x537>
    assert((pp2 = page_alloc(0)));
f01016b9:	83 ec 0c             	sub    $0xc,%esp
f01016bc:	6a 00                	push   $0x0
f01016be:	e8 33 f9 ff ff       	call   f0100ff6 <page_alloc>
f01016c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01016c6:	83 c4 10             	add    $0x10,%esp
f01016c9:	85 c0                	test   %eax,%eax
f01016cb:	0f 84 15 02 00 00    	je     f01018e6 <mem_init+0x550>
    assert(pp1 && pp1 != pp0);
f01016d1:	39 f7                	cmp    %esi,%edi
f01016d3:	0f 84 26 02 00 00    	je     f01018ff <mem_init+0x569>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01016dc:	39 c6                	cmp    %eax,%esi
f01016de:	0f 84 34 02 00 00    	je     f0101918 <mem_init+0x582>
f01016e4:	39 c7                	cmp    %eax,%edi
f01016e6:	0f 84 2c 02 00 00    	je     f0101918 <mem_init+0x582>
	return (pp - pages) << PGSHIFT;
f01016ec:	8b 0d 94 4e 23 f0    	mov    0xf0234e94,%ecx
    assert(page2pa(pp0) < npages * PGSIZE);
f01016f2:	8b 15 8c 4e 23 f0    	mov    0xf0234e8c,%edx
f01016f8:	c1 e2 0c             	shl    $0xc,%edx
f01016fb:	89 f8                	mov    %edi,%eax
f01016fd:	29 c8                	sub    %ecx,%eax
f01016ff:	c1 f8 03             	sar    $0x3,%eax
f0101702:	c1 e0 0c             	shl    $0xc,%eax
f0101705:	39 d0                	cmp    %edx,%eax
f0101707:	0f 83 24 02 00 00    	jae    f0101931 <mem_init+0x59b>
f010170d:	89 f0                	mov    %esi,%eax
f010170f:	29 c8                	sub    %ecx,%eax
f0101711:	c1 f8 03             	sar    $0x3,%eax
f0101714:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp1) < npages * PGSIZE);
f0101717:	39 c2                	cmp    %eax,%edx
f0101719:	0f 86 2b 02 00 00    	jbe    f010194a <mem_init+0x5b4>
f010171f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101722:	29 c8                	sub    %ecx,%eax
f0101724:	c1 f8 03             	sar    $0x3,%eax
f0101727:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp2) < npages * PGSIZE);
f010172a:	39 c2                	cmp    %eax,%edx
f010172c:	0f 86 31 02 00 00    	jbe    f0101963 <mem_init+0x5cd>
    fl = page_free_list;
f0101732:	a1 44 42 23 f0       	mov    0xf0234244,%eax
f0101737:	89 45 d0             	mov    %eax,-0x30(%ebp)
    page_free_list = 0;
f010173a:	c7 05 44 42 23 f0 00 	movl   $0x0,0xf0234244
f0101741:	00 00 00 
    assert(!page_alloc(0));
f0101744:	83 ec 0c             	sub    $0xc,%esp
f0101747:	6a 00                	push   $0x0
f0101749:	e8 a8 f8 ff ff       	call   f0100ff6 <page_alloc>
f010174e:	83 c4 10             	add    $0x10,%esp
f0101751:	85 c0                	test   %eax,%eax
f0101753:	0f 85 23 02 00 00    	jne    f010197c <mem_init+0x5e6>
    page_free(pp0);
f0101759:	83 ec 0c             	sub    $0xc,%esp
f010175c:	57                   	push   %edi
f010175d:	e8 0c f9 ff ff       	call   f010106e <page_free>
    page_free(pp1);
f0101762:	89 34 24             	mov    %esi,(%esp)
f0101765:	e8 04 f9 ff ff       	call   f010106e <page_free>
    page_free(pp2);
f010176a:	83 c4 04             	add    $0x4,%esp
f010176d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101770:	e8 f9 f8 ff ff       	call   f010106e <page_free>
    assert((pp0 = page_alloc(0)));
f0101775:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010177c:	e8 75 f8 ff ff       	call   f0100ff6 <page_alloc>
f0101781:	89 c6                	mov    %eax,%esi
f0101783:	83 c4 10             	add    $0x10,%esp
f0101786:	85 c0                	test   %eax,%eax
f0101788:	0f 84 07 02 00 00    	je     f0101995 <mem_init+0x5ff>
    assert((pp1 = page_alloc(0)));
f010178e:	83 ec 0c             	sub    $0xc,%esp
f0101791:	6a 00                	push   $0x0
f0101793:	e8 5e f8 ff ff       	call   f0100ff6 <page_alloc>
f0101798:	89 c7                	mov    %eax,%edi
f010179a:	83 c4 10             	add    $0x10,%esp
f010179d:	85 c0                	test   %eax,%eax
f010179f:	0f 84 09 02 00 00    	je     f01019ae <mem_init+0x618>
    assert((pp2 = page_alloc(0)));
f01017a5:	83 ec 0c             	sub    $0xc,%esp
f01017a8:	6a 00                	push   $0x0
f01017aa:	e8 47 f8 ff ff       	call   f0100ff6 <page_alloc>
f01017af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01017b2:	83 c4 10             	add    $0x10,%esp
f01017b5:	85 c0                	test   %eax,%eax
f01017b7:	0f 84 0a 02 00 00    	je     f01019c7 <mem_init+0x631>
    assert(pp1 && pp1 != pp0);
f01017bd:	39 fe                	cmp    %edi,%esi
f01017bf:	0f 84 1b 02 00 00    	je     f01019e0 <mem_init+0x64a>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01017c8:	39 c6                	cmp    %eax,%esi
f01017ca:	0f 84 29 02 00 00    	je     f01019f9 <mem_init+0x663>
f01017d0:	39 c7                	cmp    %eax,%edi
f01017d2:	0f 84 21 02 00 00    	je     f01019f9 <mem_init+0x663>
    assert(!page_alloc(0));
f01017d8:	83 ec 0c             	sub    $0xc,%esp
f01017db:	6a 00                	push   $0x0
f01017dd:	e8 14 f8 ff ff       	call   f0100ff6 <page_alloc>
f01017e2:	83 c4 10             	add    $0x10,%esp
f01017e5:	85 c0                	test   %eax,%eax
f01017e7:	0f 85 25 02 00 00    	jne    f0101a12 <mem_init+0x67c>
f01017ed:	89 f0                	mov    %esi,%eax
f01017ef:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f01017f5:	c1 f8 03             	sar    $0x3,%eax
f01017f8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01017fb:	89 c2                	mov    %eax,%edx
f01017fd:	c1 ea 0c             	shr    $0xc,%edx
f0101800:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0101806:	0f 83 1f 02 00 00    	jae    f0101a2b <mem_init+0x695>
    memset(page2kva(pp0), 1, PGSIZE);
f010180c:	83 ec 04             	sub    $0x4,%esp
f010180f:	68 00 10 00 00       	push   $0x1000
f0101814:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101816:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010181b:	50                   	push   %eax
f010181c:	e8 97 3e 00 00       	call   f01056b8 <memset>
    page_free(pp0);
f0101821:	89 34 24             	mov    %esi,(%esp)
f0101824:	e8 45 f8 ff ff       	call   f010106e <page_free>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101829:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101830:	e8 c1 f7 ff ff       	call   f0100ff6 <page_alloc>
f0101835:	83 c4 10             	add    $0x10,%esp
f0101838:	85 c0                	test   %eax,%eax
f010183a:	0f 84 fd 01 00 00    	je     f0101a3d <mem_init+0x6a7>
    assert(pp && pp0 == pp);
f0101840:	39 c6                	cmp    %eax,%esi
f0101842:	0f 85 0e 02 00 00    	jne    f0101a56 <mem_init+0x6c0>
	return (pp - pages) << PGSHIFT;
f0101848:	89 f2                	mov    %esi,%edx
f010184a:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0101850:	c1 fa 03             	sar    $0x3,%edx
f0101853:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101856:	89 d0                	mov    %edx,%eax
f0101858:	c1 e8 0c             	shr    $0xc,%eax
f010185b:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f0101861:	0f 83 08 02 00 00    	jae    f0101a6f <mem_init+0x6d9>
	return (void *)(pa + KERNBASE);
f0101867:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f010186d:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
        assert(c[i] == 0);
f0101873:	80 38 00             	cmpb   $0x0,(%eax)
f0101876:	0f 85 05 02 00 00    	jne    f0101a81 <mem_init+0x6eb>
f010187c:	83 c0 01             	add    $0x1,%eax
    for (i = 0; i < PGSIZE; i++)
f010187f:	39 d0                	cmp    %edx,%eax
f0101881:	75 f0                	jne    f0101873 <mem_init+0x4dd>
    page_free_list = fl;
f0101883:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101886:	a3 44 42 23 f0       	mov    %eax,0xf0234244
    page_free(pp0);
f010188b:	83 ec 0c             	sub    $0xc,%esp
f010188e:	56                   	push   %esi
f010188f:	e8 da f7 ff ff       	call   f010106e <page_free>
    page_free(pp1);
f0101894:	89 3c 24             	mov    %edi,(%esp)
f0101897:	e8 d2 f7 ff ff       	call   f010106e <page_free>
    page_free(pp2);
f010189c:	83 c4 04             	add    $0x4,%esp
f010189f:	ff 75 d4             	pushl  -0x2c(%ebp)
f01018a2:	e8 c7 f7 ff ff       	call   f010106e <page_free>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f01018a7:	a1 44 42 23 f0       	mov    0xf0234244,%eax
f01018ac:	83 c4 10             	add    $0x10,%esp
f01018af:	e9 eb 01 00 00       	jmp    f0101a9f <mem_init+0x709>
    assert((pp0 = page_alloc(0)));
f01018b4:	68 dd 78 10 f0       	push   $0xf01078dd
f01018b9:	68 21 77 10 f0       	push   $0xf0107721
f01018be:	68 6a 03 00 00       	push   $0x36a
f01018c3:	68 36 77 10 f0       	push   $0xf0107736
f01018c8:	e8 73 e7 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f01018cd:	68 f3 78 10 f0       	push   $0xf01078f3
f01018d2:	68 21 77 10 f0       	push   $0xf0107721
f01018d7:	68 6b 03 00 00       	push   $0x36b
f01018dc:	68 36 77 10 f0       	push   $0xf0107736
f01018e1:	e8 5a e7 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f01018e6:	68 09 79 10 f0       	push   $0xf0107909
f01018eb:	68 21 77 10 f0       	push   $0xf0107721
f01018f0:	68 6c 03 00 00       	push   $0x36c
f01018f5:	68 36 77 10 f0       	push   $0xf0107736
f01018fa:	e8 41 e7 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01018ff:	68 1f 79 10 f0       	push   $0xf010791f
f0101904:	68 21 77 10 f0       	push   $0xf0107721
f0101909:	68 6f 03 00 00       	push   $0x36f
f010190e:	68 36 77 10 f0       	push   $0xf0107736
f0101913:	e8 28 e7 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101918:	68 4c 6c 10 f0       	push   $0xf0106c4c
f010191d:	68 21 77 10 f0       	push   $0xf0107721
f0101922:	68 70 03 00 00       	push   $0x370
f0101927:	68 36 77 10 f0       	push   $0xf0107736
f010192c:	e8 0f e7 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp0) < npages * PGSIZE);
f0101931:	68 6c 6c 10 f0       	push   $0xf0106c6c
f0101936:	68 21 77 10 f0       	push   $0xf0107721
f010193b:	68 71 03 00 00       	push   $0x371
f0101940:	68 36 77 10 f0       	push   $0xf0107736
f0101945:	e8 f6 e6 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp1) < npages * PGSIZE);
f010194a:	68 8c 6c 10 f0       	push   $0xf0106c8c
f010194f:	68 21 77 10 f0       	push   $0xf0107721
f0101954:	68 72 03 00 00       	push   $0x372
f0101959:	68 36 77 10 f0       	push   $0xf0107736
f010195e:	e8 dd e6 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp2) < npages * PGSIZE);
f0101963:	68 ac 6c 10 f0       	push   $0xf0106cac
f0101968:	68 21 77 10 f0       	push   $0xf0107721
f010196d:	68 73 03 00 00       	push   $0x373
f0101972:	68 36 77 10 f0       	push   $0xf0107736
f0101977:	e8 c4 e6 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f010197c:	68 31 79 10 f0       	push   $0xf0107931
f0101981:	68 21 77 10 f0       	push   $0xf0107721
f0101986:	68 7a 03 00 00       	push   $0x37a
f010198b:	68 36 77 10 f0       	push   $0xf0107736
f0101990:	e8 ab e6 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0101995:	68 dd 78 10 f0       	push   $0xf01078dd
f010199a:	68 21 77 10 f0       	push   $0xf0107721
f010199f:	68 81 03 00 00       	push   $0x381
f01019a4:	68 36 77 10 f0       	push   $0xf0107736
f01019a9:	e8 92 e6 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f01019ae:	68 f3 78 10 f0       	push   $0xf01078f3
f01019b3:	68 21 77 10 f0       	push   $0xf0107721
f01019b8:	68 82 03 00 00       	push   $0x382
f01019bd:	68 36 77 10 f0       	push   $0xf0107736
f01019c2:	e8 79 e6 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f01019c7:	68 09 79 10 f0       	push   $0xf0107909
f01019cc:	68 21 77 10 f0       	push   $0xf0107721
f01019d1:	68 83 03 00 00       	push   $0x383
f01019d6:	68 36 77 10 f0       	push   $0xf0107736
f01019db:	e8 60 e6 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01019e0:	68 1f 79 10 f0       	push   $0xf010791f
f01019e5:	68 21 77 10 f0       	push   $0xf0107721
f01019ea:	68 85 03 00 00       	push   $0x385
f01019ef:	68 36 77 10 f0       	push   $0xf0107736
f01019f4:	e8 47 e6 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019f9:	68 4c 6c 10 f0       	push   $0xf0106c4c
f01019fe:	68 21 77 10 f0       	push   $0xf0107721
f0101a03:	68 86 03 00 00       	push   $0x386
f0101a08:	68 36 77 10 f0       	push   $0xf0107736
f0101a0d:	e8 2e e6 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0101a12:	68 31 79 10 f0       	push   $0xf0107931
f0101a17:	68 21 77 10 f0       	push   $0xf0107721
f0101a1c:	68 87 03 00 00       	push   $0x387
f0101a21:	68 36 77 10 f0       	push   $0xf0107736
f0101a26:	e8 15 e6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101a2b:	50                   	push   %eax
f0101a2c:	68 64 63 10 f0       	push   $0xf0106364
f0101a31:	6a 58                	push   $0x58
f0101a33:	68 42 77 10 f0       	push   $0xf0107742
f0101a38:	e8 03 e6 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101a3d:	68 40 79 10 f0       	push   $0xf0107940
f0101a42:	68 21 77 10 f0       	push   $0xf0107721
f0101a47:	68 8c 03 00 00       	push   $0x38c
f0101a4c:	68 36 77 10 f0       	push   $0xf0107736
f0101a51:	e8 ea e5 ff ff       	call   f0100040 <_panic>
    assert(pp && pp0 == pp);
f0101a56:	68 5e 79 10 f0       	push   $0xf010795e
f0101a5b:	68 21 77 10 f0       	push   $0xf0107721
f0101a60:	68 8d 03 00 00       	push   $0x38d
f0101a65:	68 36 77 10 f0       	push   $0xf0107736
f0101a6a:	e8 d1 e5 ff ff       	call   f0100040 <_panic>
f0101a6f:	52                   	push   %edx
f0101a70:	68 64 63 10 f0       	push   $0xf0106364
f0101a75:	6a 58                	push   $0x58
f0101a77:	68 42 77 10 f0       	push   $0xf0107742
f0101a7c:	e8 bf e5 ff ff       	call   f0100040 <_panic>
        assert(c[i] == 0);
f0101a81:	68 6e 79 10 f0       	push   $0xf010796e
f0101a86:	68 21 77 10 f0       	push   $0xf0107721
f0101a8b:	68 90 03 00 00       	push   $0x390
f0101a90:	68 36 77 10 f0       	push   $0xf0107736
f0101a95:	e8 a6 e5 ff ff       	call   f0100040 <_panic>
        --nfree;
f0101a9a:	83 eb 01             	sub    $0x1,%ebx
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101a9d:	8b 00                	mov    (%eax),%eax
f0101a9f:	85 c0                	test   %eax,%eax
f0101aa1:	75 f7                	jne    f0101a9a <mem_init+0x704>
    assert(nfree == 0);
f0101aa3:	85 db                	test   %ebx,%ebx
f0101aa5:	0f 85 6f 09 00 00    	jne    f010241a <mem_init+0x1084>
    cprintf("check_page_alloc() succeeded!\n");
f0101aab:	83 ec 0c             	sub    $0xc,%esp
f0101aae:	68 cc 6c 10 f0       	push   $0xf0106ccc
f0101ab3:	e8 c7 20 00 00       	call   f0103b7f <cprintf>
    cprintf("\n************* Now check page_insert, page_remove, &c **************\n");
f0101ab8:	c7 04 24 ec 6c 10 f0 	movl   $0xf0106cec,(%esp)
f0101abf:	e8 bb 20 00 00       	call   f0103b7f <cprintf>
    int i;
    extern pde_t entry_pgdir[];

    // should be able to allocate three pages
    pp0 = pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0101ac4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101acb:	e8 26 f5 ff ff       	call   f0100ff6 <page_alloc>
f0101ad0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ad3:	83 c4 10             	add    $0x10,%esp
f0101ad6:	85 c0                	test   %eax,%eax
f0101ad8:	0f 84 55 09 00 00    	je     f0102433 <mem_init+0x109d>
    assert((pp1 = page_alloc(0)));
f0101ade:	83 ec 0c             	sub    $0xc,%esp
f0101ae1:	6a 00                	push   $0x0
f0101ae3:	e8 0e f5 ff ff       	call   f0100ff6 <page_alloc>
f0101ae8:	89 c3                	mov    %eax,%ebx
f0101aea:	83 c4 10             	add    $0x10,%esp
f0101aed:	85 c0                	test   %eax,%eax
f0101aef:	0f 84 57 09 00 00    	je     f010244c <mem_init+0x10b6>
    assert((pp2 = page_alloc(0)));
f0101af5:	83 ec 0c             	sub    $0xc,%esp
f0101af8:	6a 00                	push   $0x0
f0101afa:	e8 f7 f4 ff ff       	call   f0100ff6 <page_alloc>
f0101aff:	89 c7                	mov    %eax,%edi
f0101b01:	83 c4 10             	add    $0x10,%esp
f0101b04:	85 c0                	test   %eax,%eax
f0101b06:	0f 84 59 09 00 00    	je     f0102465 <mem_init+0x10cf>

    assert(pp0);
    assert(pp1 && pp1 != pp0);
f0101b0c:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101b0f:	0f 84 69 09 00 00    	je     f010247e <mem_init+0x10e8>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b15:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101b18:	0f 84 79 09 00 00    	je     f0102497 <mem_init+0x1101>
f0101b1e:	39 c3                	cmp    %eax,%ebx
f0101b20:	0f 84 71 09 00 00    	je     f0102497 <mem_init+0x1101>

    // temporarily steal the rest of the free pages
    fl = page_free_list;
f0101b26:	a1 44 42 23 f0       	mov    0xf0234244,%eax
f0101b2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    page_free_list = 0;
f0101b2e:	c7 05 44 42 23 f0 00 	movl   $0x0,0xf0234244
f0101b35:	00 00 00 

    // should be no free memory
    assert(!page_alloc(0));
f0101b38:	83 ec 0c             	sub    $0xc,%esp
f0101b3b:	6a 00                	push   $0x0
f0101b3d:	e8 b4 f4 ff ff       	call   f0100ff6 <page_alloc>
f0101b42:	83 c4 10             	add    $0x10,%esp
f0101b45:	85 c0                	test   %eax,%eax
f0101b47:	0f 85 63 09 00 00    	jne    f01024b0 <mem_init+0x111a>

    // there is no page allocated at address 0
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101b4d:	83 ec 04             	sub    $0x4,%esp
f0101b50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101b53:	50                   	push   %eax
f0101b54:	6a 00                	push   $0x0
f0101b56:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101b5c:	e8 6d f6 ff ff       	call   f01011ce <page_lookup>
f0101b61:	83 c4 10             	add    $0x10,%esp
f0101b64:	85 c0                	test   %eax,%eax
f0101b66:	0f 85 5d 09 00 00    	jne    f01024c9 <mem_init+0x1133>

    // there is no free memory, so we can't allocate a page table
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101b6c:	6a 02                	push   $0x2
f0101b6e:	6a 00                	push   $0x0
f0101b70:	53                   	push   %ebx
f0101b71:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101b77:	e8 ef f6 ff ff       	call   f010126b <page_insert>
f0101b7c:	83 c4 10             	add    $0x10,%esp
f0101b7f:	85 c0                	test   %eax,%eax
f0101b81:	0f 89 5b 09 00 00    	jns    f01024e2 <mem_init+0x114c>

    // free pp0 and try again: pp0 should be used for page table
    page_free(pp0);
f0101b87:	83 ec 0c             	sub    $0xc,%esp
f0101b8a:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b8d:	e8 dc f4 ff ff       	call   f010106e <page_free>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101b92:	6a 02                	push   $0x2
f0101b94:	6a 00                	push   $0x0
f0101b96:	53                   	push   %ebx
f0101b97:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101b9d:	e8 c9 f6 ff ff       	call   f010126b <page_insert>
f0101ba2:	83 c4 20             	add    $0x20,%esp
f0101ba5:	85 c0                	test   %eax,%eax
f0101ba7:	0f 85 4e 09 00 00    	jne    f01024fb <mem_init+0x1165>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101bad:	8b 35 90 4e 23 f0    	mov    0xf0234e90,%esi
	return (pp - pages) << PGSHIFT;
f0101bb3:	8b 0d 94 4e 23 f0    	mov    0xf0234e94,%ecx
f0101bb9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101bbc:	8b 16                	mov    (%esi),%edx
f0101bbe:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101bc7:	29 c8                	sub    %ecx,%eax
f0101bc9:	c1 f8 03             	sar    $0x3,%eax
f0101bcc:	c1 e0 0c             	shl    $0xc,%eax
f0101bcf:	39 c2                	cmp    %eax,%edx
f0101bd1:	0f 85 3d 09 00 00    	jne    f0102514 <mem_init+0x117e>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101bd7:	ba 00 00 00 00       	mov    $0x0,%edx
f0101bdc:	89 f0                	mov    %esi,%eax
f0101bde:	e8 e1 ee ff ff       	call   f0100ac4 <check_va2pa>
f0101be3:	89 da                	mov    %ebx,%edx
f0101be5:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101be8:	c1 fa 03             	sar    $0x3,%edx
f0101beb:	c1 e2 0c             	shl    $0xc,%edx
f0101bee:	39 d0                	cmp    %edx,%eax
f0101bf0:	0f 85 37 09 00 00    	jne    f010252d <mem_init+0x1197>
    assert(pp1->pp_ref == 1);
f0101bf6:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101bfb:	0f 85 45 09 00 00    	jne    f0102546 <mem_init+0x11b0>
    assert(pp0->pp_ref == 1);
f0101c01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c04:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101c09:	0f 85 50 09 00 00    	jne    f010255f <mem_init+0x11c9>

    // should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101c0f:	6a 02                	push   $0x2
f0101c11:	68 00 10 00 00       	push   $0x1000
f0101c16:	57                   	push   %edi
f0101c17:	56                   	push   %esi
f0101c18:	e8 4e f6 ff ff       	call   f010126b <page_insert>
f0101c1d:	83 c4 10             	add    $0x10,%esp
f0101c20:	85 c0                	test   %eax,%eax
f0101c22:	0f 85 50 09 00 00    	jne    f0102578 <mem_init+0x11e2>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c28:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c2d:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0101c32:	e8 8d ee ff ff       	call   f0100ac4 <check_va2pa>
f0101c37:	89 fa                	mov    %edi,%edx
f0101c39:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0101c3f:	c1 fa 03             	sar    $0x3,%edx
f0101c42:	c1 e2 0c             	shl    $0xc,%edx
f0101c45:	39 d0                	cmp    %edx,%eax
f0101c47:	0f 85 44 09 00 00    	jne    f0102591 <mem_init+0x11fb>
    assert(pp2->pp_ref == 1);
f0101c4d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101c52:	0f 85 52 09 00 00    	jne    f01025aa <mem_init+0x1214>

    // should be no free memory
    assert(!page_alloc(0));
f0101c58:	83 ec 0c             	sub    $0xc,%esp
f0101c5b:	6a 00                	push   $0x0
f0101c5d:	e8 94 f3 ff ff       	call   f0100ff6 <page_alloc>
f0101c62:	83 c4 10             	add    $0x10,%esp
f0101c65:	85 c0                	test   %eax,%eax
f0101c67:	0f 85 56 09 00 00    	jne    f01025c3 <mem_init+0x122d>

    // should be able to map pp2 at PGSIZE because it's already there
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101c6d:	6a 02                	push   $0x2
f0101c6f:	68 00 10 00 00       	push   $0x1000
f0101c74:	57                   	push   %edi
f0101c75:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101c7b:	e8 eb f5 ff ff       	call   f010126b <page_insert>
f0101c80:	83 c4 10             	add    $0x10,%esp
f0101c83:	85 c0                	test   %eax,%eax
f0101c85:	0f 85 51 09 00 00    	jne    f01025dc <mem_init+0x1246>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c8b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c90:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0101c95:	e8 2a ee ff ff       	call   f0100ac4 <check_va2pa>
f0101c9a:	89 fa                	mov    %edi,%edx
f0101c9c:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0101ca2:	c1 fa 03             	sar    $0x3,%edx
f0101ca5:	c1 e2 0c             	shl    $0xc,%edx
f0101ca8:	39 d0                	cmp    %edx,%eax
f0101caa:	0f 85 45 09 00 00    	jne    f01025f5 <mem_init+0x125f>
    assert(pp2->pp_ref == 1);
f0101cb0:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101cb5:	0f 85 53 09 00 00    	jne    f010260e <mem_init+0x1278>

    // pp2 should NOT be on the free list
    // could happen in ref counts are handled sloppily in page_insert
    assert(!page_alloc(0));
f0101cbb:	83 ec 0c             	sub    $0xc,%esp
f0101cbe:	6a 00                	push   $0x0
f0101cc0:	e8 31 f3 ff ff       	call   f0100ff6 <page_alloc>
f0101cc5:	83 c4 10             	add    $0x10,%esp
f0101cc8:	85 c0                	test   %eax,%eax
f0101cca:	0f 85 57 09 00 00    	jne    f0102627 <mem_init+0x1291>

    // check that pgdir_walk returns a pointer to the pte
    ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101cd0:	8b 15 90 4e 23 f0    	mov    0xf0234e90,%edx
f0101cd6:	8b 02                	mov    (%edx),%eax
f0101cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101cdd:	89 c1                	mov    %eax,%ecx
f0101cdf:	c1 e9 0c             	shr    $0xc,%ecx
f0101ce2:	3b 0d 8c 4e 23 f0    	cmp    0xf0234e8c,%ecx
f0101ce8:	0f 83 52 09 00 00    	jae    f0102640 <mem_init+0x12aa>
	return (void *)(pa + KERNBASE);
f0101cee:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0101cf6:	83 ec 04             	sub    $0x4,%esp
f0101cf9:	6a 00                	push   $0x0
f0101cfb:	68 00 10 00 00       	push   $0x1000
f0101d00:	52                   	push   %edx
f0101d01:	e8 e7 f3 ff ff       	call   f01010ed <pgdir_walk>
f0101d06:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101d09:	8d 51 04             	lea    0x4(%ecx),%edx
f0101d0c:	83 c4 10             	add    $0x10,%esp
f0101d0f:	39 d0                	cmp    %edx,%eax
f0101d11:	0f 85 3e 09 00 00    	jne    f0102655 <mem_init+0x12bf>

    // should be able to change permissions too.
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0101d17:	6a 06                	push   $0x6
f0101d19:	68 00 10 00 00       	push   $0x1000
f0101d1e:	57                   	push   %edi
f0101d1f:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101d25:	e8 41 f5 ff ff       	call   f010126b <page_insert>
f0101d2a:	83 c4 10             	add    $0x10,%esp
f0101d2d:	85 c0                	test   %eax,%eax
f0101d2f:	0f 85 39 09 00 00    	jne    f010266e <mem_init+0x12d8>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101d35:	8b 35 90 4e 23 f0    	mov    0xf0234e90,%esi
f0101d3b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d40:	89 f0                	mov    %esi,%eax
f0101d42:	e8 7d ed ff ff       	call   f0100ac4 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101d47:	89 fa                	mov    %edi,%edx
f0101d49:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0101d4f:	c1 fa 03             	sar    $0x3,%edx
f0101d52:	c1 e2 0c             	shl    $0xc,%edx
f0101d55:	39 d0                	cmp    %edx,%eax
f0101d57:	0f 85 2a 09 00 00    	jne    f0102687 <mem_init+0x12f1>
    assert(pp2->pp_ref == 1);
f0101d5d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101d62:	0f 85 38 09 00 00    	jne    f01026a0 <mem_init+0x130a>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f0101d68:	83 ec 04             	sub    $0x4,%esp
f0101d6b:	6a 00                	push   $0x0
f0101d6d:	68 00 10 00 00       	push   $0x1000
f0101d72:	56                   	push   %esi
f0101d73:	e8 75 f3 ff ff       	call   f01010ed <pgdir_walk>
f0101d78:	83 c4 10             	add    $0x10,%esp
f0101d7b:	f6 00 04             	testb  $0x4,(%eax)
f0101d7e:	0f 84 35 09 00 00    	je     f01026b9 <mem_init+0x1323>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f0101d84:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0101d89:	f6 00 04             	testb  $0x4,(%eax)
f0101d8c:	0f 84 40 09 00 00    	je     f01026d2 <mem_init+0x133c>

    // should be able to remap with fewer permissions
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101d92:	6a 02                	push   $0x2
f0101d94:	68 00 10 00 00       	push   $0x1000
f0101d99:	57                   	push   %edi
f0101d9a:	50                   	push   %eax
f0101d9b:	e8 cb f4 ff ff       	call   f010126b <page_insert>
f0101da0:	83 c4 10             	add    $0x10,%esp
f0101da3:	85 c0                	test   %eax,%eax
f0101da5:	0f 85 40 09 00 00    	jne    f01026eb <mem_init+0x1355>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0101dab:	83 ec 04             	sub    $0x4,%esp
f0101dae:	6a 00                	push   $0x0
f0101db0:	68 00 10 00 00       	push   $0x1000
f0101db5:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101dbb:	e8 2d f3 ff ff       	call   f01010ed <pgdir_walk>
f0101dc0:	83 c4 10             	add    $0x10,%esp
f0101dc3:	f6 00 02             	testb  $0x2,(%eax)
f0101dc6:	0f 84 38 09 00 00    	je     f0102704 <mem_init+0x136e>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0101dcc:	83 ec 04             	sub    $0x4,%esp
f0101dcf:	6a 00                	push   $0x0
f0101dd1:	68 00 10 00 00       	push   $0x1000
f0101dd6:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101ddc:	e8 0c f3 ff ff       	call   f01010ed <pgdir_walk>
f0101de1:	83 c4 10             	add    $0x10,%esp
f0101de4:	f6 00 04             	testb  $0x4,(%eax)
f0101de7:	0f 85 30 09 00 00    	jne    f010271d <mem_init+0x1387>

    // should not be able to map at PTSIZE because need free page for page table
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0101ded:	6a 02                	push   $0x2
f0101def:	68 00 00 40 00       	push   $0x400000
f0101df4:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101df7:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101dfd:	e8 69 f4 ff ff       	call   f010126b <page_insert>
f0101e02:	83 c4 10             	add    $0x10,%esp
f0101e05:	85 c0                	test   %eax,%eax
f0101e07:	0f 89 29 09 00 00    	jns    f0102736 <mem_init+0x13a0>

    // insert pp1 at PGSIZE (replacing pp2)
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0101e0d:	6a 02                	push   $0x2
f0101e0f:	68 00 10 00 00       	push   $0x1000
f0101e14:	53                   	push   %ebx
f0101e15:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101e1b:	e8 4b f4 ff ff       	call   f010126b <page_insert>
f0101e20:	83 c4 10             	add    $0x10,%esp
f0101e23:	85 c0                	test   %eax,%eax
f0101e25:	0f 85 24 09 00 00    	jne    f010274f <mem_init+0x13b9>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0101e2b:	83 ec 04             	sub    $0x4,%esp
f0101e2e:	6a 00                	push   $0x0
f0101e30:	68 00 10 00 00       	push   $0x1000
f0101e35:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101e3b:	e8 ad f2 ff ff       	call   f01010ed <pgdir_walk>
f0101e40:	83 c4 10             	add    $0x10,%esp
f0101e43:	f6 00 04             	testb  $0x4,(%eax)
f0101e46:	0f 85 1c 09 00 00    	jne    f0102768 <mem_init+0x13d2>

    // should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101e4c:	8b 35 90 4e 23 f0    	mov    0xf0234e90,%esi
f0101e52:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e57:	89 f0                	mov    %esi,%eax
f0101e59:	e8 66 ec ff ff       	call   f0100ac4 <check_va2pa>
f0101e5e:	89 c1                	mov    %eax,%ecx
f0101e60:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e63:	89 d8                	mov    %ebx,%eax
f0101e65:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0101e6b:	c1 f8 03             	sar    $0x3,%eax
f0101e6e:	c1 e0 0c             	shl    $0xc,%eax
f0101e71:	39 c1                	cmp    %eax,%ecx
f0101e73:	0f 85 08 09 00 00    	jne    f0102781 <mem_init+0x13eb>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101e79:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e7e:	89 f0                	mov    %esi,%eax
f0101e80:	e8 3f ec ff ff       	call   f0100ac4 <check_va2pa>
f0101e85:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101e88:	0f 85 0c 09 00 00    	jne    f010279a <mem_init+0x1404>
    // ... and ref counts should reflect this
    assert(pp1->pp_ref == 2);
f0101e8e:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101e93:	0f 85 1a 09 00 00    	jne    f01027b3 <mem_init+0x141d>
    assert(pp2->pp_ref == 0);
f0101e99:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e9e:	0f 85 28 09 00 00    	jne    f01027cc <mem_init+0x1436>

    // pp2 should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp2);
f0101ea4:	83 ec 0c             	sub    $0xc,%esp
f0101ea7:	6a 00                	push   $0x0
f0101ea9:	e8 48 f1 ff ff       	call   f0100ff6 <page_alloc>
f0101eae:	83 c4 10             	add    $0x10,%esp
f0101eb1:	39 c7                	cmp    %eax,%edi
f0101eb3:	0f 85 2c 09 00 00    	jne    f01027e5 <mem_init+0x144f>
f0101eb9:	85 c0                	test   %eax,%eax
f0101ebb:	0f 84 24 09 00 00    	je     f01027e5 <mem_init+0x144f>

    // unmapping pp1 at 0 should keep pp1 at PGSIZE
    page_remove(kern_pgdir, 0x0);
f0101ec1:	83 ec 08             	sub    $0x8,%esp
f0101ec4:	6a 00                	push   $0x0
f0101ec6:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101ecc:	e8 57 f3 ff ff       	call   f0101228 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101ed1:	8b 35 90 4e 23 f0    	mov    0xf0234e90,%esi
f0101ed7:	ba 00 00 00 00       	mov    $0x0,%edx
f0101edc:	89 f0                	mov    %esi,%eax
f0101ede:	e8 e1 eb ff ff       	call   f0100ac4 <check_va2pa>
f0101ee3:	83 c4 10             	add    $0x10,%esp
f0101ee6:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ee9:	0f 85 0f 09 00 00    	jne    f01027fe <mem_init+0x1468>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101eef:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ef4:	89 f0                	mov    %esi,%eax
f0101ef6:	e8 c9 eb ff ff       	call   f0100ac4 <check_va2pa>
f0101efb:	89 da                	mov    %ebx,%edx
f0101efd:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0101f03:	c1 fa 03             	sar    $0x3,%edx
f0101f06:	c1 e2 0c             	shl    $0xc,%edx
f0101f09:	39 d0                	cmp    %edx,%eax
f0101f0b:	0f 85 06 09 00 00    	jne    f0102817 <mem_init+0x1481>
    assert(pp1->pp_ref == 1);
f0101f11:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f16:	0f 85 14 09 00 00    	jne    f0102830 <mem_init+0x149a>
    assert(pp2->pp_ref == 0);
f0101f1c:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101f21:	0f 85 22 09 00 00    	jne    f0102849 <mem_init+0x14b3>

    // test re-inserting pp1 at PGSIZE
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0101f27:	6a 00                	push   $0x0
f0101f29:	68 00 10 00 00       	push   $0x1000
f0101f2e:	53                   	push   %ebx
f0101f2f:	56                   	push   %esi
f0101f30:	e8 36 f3 ff ff       	call   f010126b <page_insert>
f0101f35:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f38:	83 c4 10             	add    $0x10,%esp
f0101f3b:	85 c0                	test   %eax,%eax
f0101f3d:	0f 85 1f 09 00 00    	jne    f0102862 <mem_init+0x14cc>
    assert(pp1->pp_ref);
f0101f43:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101f48:	0f 84 2d 09 00 00    	je     f010287b <mem_init+0x14e5>
    assert(pp1->pp_link == NULL);
f0101f4e:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101f51:	0f 85 3d 09 00 00    	jne    f0102894 <mem_init+0x14fe>

    // unmapping pp1 at PGSIZE should free it
    page_remove(kern_pgdir, (void *) PGSIZE);
f0101f57:	83 ec 08             	sub    $0x8,%esp
f0101f5a:	68 00 10 00 00       	push   $0x1000
f0101f5f:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0101f65:	e8 be f2 ff ff       	call   f0101228 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101f6a:	8b 35 90 4e 23 f0    	mov    0xf0234e90,%esi
f0101f70:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f75:	89 f0                	mov    %esi,%eax
f0101f77:	e8 48 eb ff ff       	call   f0100ac4 <check_va2pa>
f0101f7c:	83 c4 10             	add    $0x10,%esp
f0101f7f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f82:	0f 85 25 09 00 00    	jne    f01028ad <mem_init+0x1517>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101f88:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f8d:	89 f0                	mov    %esi,%eax
f0101f8f:	e8 30 eb ff ff       	call   f0100ac4 <check_va2pa>
f0101f94:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f97:	0f 85 29 09 00 00    	jne    f01028c6 <mem_init+0x1530>
    assert(pp1->pp_ref == 0);
f0101f9d:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101fa2:	0f 85 37 09 00 00    	jne    f01028df <mem_init+0x1549>
    assert(pp2->pp_ref == 0);
f0101fa8:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101fad:	0f 85 45 09 00 00    	jne    f01028f8 <mem_init+0x1562>

    // so it should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp1);
f0101fb3:	83 ec 0c             	sub    $0xc,%esp
f0101fb6:	6a 00                	push   $0x0
f0101fb8:	e8 39 f0 ff ff       	call   f0100ff6 <page_alloc>
f0101fbd:	83 c4 10             	add    $0x10,%esp
f0101fc0:	85 c0                	test   %eax,%eax
f0101fc2:	0f 84 49 09 00 00    	je     f0102911 <mem_init+0x157b>
f0101fc8:	39 c3                	cmp    %eax,%ebx
f0101fca:	0f 85 41 09 00 00    	jne    f0102911 <mem_init+0x157b>

    // should be no free memory
    assert(!page_alloc(0));
f0101fd0:	83 ec 0c             	sub    $0xc,%esp
f0101fd3:	6a 00                	push   $0x0
f0101fd5:	e8 1c f0 ff ff       	call   f0100ff6 <page_alloc>
f0101fda:	83 c4 10             	add    $0x10,%esp
f0101fdd:	85 c0                	test   %eax,%eax
f0101fdf:	0f 85 45 09 00 00    	jne    f010292a <mem_init+0x1594>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101fe5:	8b 0d 90 4e 23 f0    	mov    0xf0234e90,%ecx
f0101feb:	8b 11                	mov    (%ecx),%edx
f0101fed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101ff3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ff6:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0101ffc:	c1 f8 03             	sar    $0x3,%eax
f0101fff:	c1 e0 0c             	shl    $0xc,%eax
f0102002:	39 c2                	cmp    %eax,%edx
f0102004:	0f 85 39 09 00 00    	jne    f0102943 <mem_init+0x15ad>
    kern_pgdir[0] = 0;
f010200a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f0102010:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102013:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102018:	0f 85 3e 09 00 00    	jne    f010295c <mem_init+0x15c6>
    pp0->pp_ref = 0;
f010201e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102021:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // check pointer arithmetic in pgdir_walk
    page_free(pp0);
f0102027:	83 ec 0c             	sub    $0xc,%esp
f010202a:	50                   	push   %eax
f010202b:	e8 3e f0 ff ff       	call   f010106e <page_free>
    va = (void *) (PGSIZE * NPDENTRIES + PGSIZE);
    ptep = pgdir_walk(kern_pgdir, va, 1);
f0102030:	83 c4 0c             	add    $0xc,%esp
f0102033:	6a 01                	push   $0x1
f0102035:	68 00 10 40 00       	push   $0x401000
f010203a:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0102040:	e8 a8 f0 ff ff       	call   f01010ed <pgdir_walk>
f0102045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102048:	8b 15 90 4e 23 f0    	mov    0xf0234e90,%edx
f010204e:	8b 52 04             	mov    0x4(%edx),%edx
f0102051:	89 d6                	mov    %edx,%esi
f0102053:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0102059:	89 f1                	mov    %esi,%ecx
f010205b:	c1 e9 0c             	shr    $0xc,%ecx
f010205e:	83 c4 10             	add    $0x10,%esp
f0102061:	3b 0d 8c 4e 23 f0    	cmp    0xf0234e8c,%ecx
f0102067:	0f 83 08 09 00 00    	jae    f0102975 <mem_init+0x15df>
	return (void *)(pa + KERNBASE);
f010206d:	8d 8e 00 00 00 f0    	lea    -0x10000000(%esi),%ecx

    cprintf("PTE_ADDR(kern_pgdir[PDX(va)]):0x%x\tkern_pgdir[PDX(va)]:0x%x\tptep:0x%x\tptep1:0x%x\tPTX(va):0x%x\n",
f0102073:	83 ec 08             	sub    $0x8,%esp
f0102076:	6a 01                	push   $0x1
f0102078:	51                   	push   %ecx
f0102079:	50                   	push   %eax
f010207a:	52                   	push   %edx
f010207b:	56                   	push   %esi
f010207c:	68 58 71 10 f0       	push   $0xf0107158
f0102081:	e8 f9 1a 00 00       	call   f0103b7f <cprintf>
            PTE_ADDR(kern_pgdir[PDX(va)]), kern_pgdir[PDX(va)], ptep, ptep1,
            PTX(va));
    assert(ptep == ptep1 + PTX(va));
f0102086:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f010208c:	83 c4 20             	add    $0x20,%esp
f010208f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f0102092:	0f 85 f2 08 00 00    	jne    f010298a <mem_init+0x15f4>
    kern_pgdir[PDX(va)] = 0;
f0102098:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f010209d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    pp0->pp_ref = 0;
f01020a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020a7:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01020ad:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f01020b3:	c1 f8 03             	sar    $0x3,%eax
f01020b6:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01020b9:	89 c2                	mov    %eax,%edx
f01020bb:	c1 ea 0c             	shr    $0xc,%edx
f01020be:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f01020c4:	0f 83 d9 08 00 00    	jae    f01029a3 <mem_init+0x160d>

    // check that new page tables get cleared
    memset(page2kva(pp0), 0xFF, PGSIZE);
f01020ca:	83 ec 04             	sub    $0x4,%esp
f01020cd:	68 00 10 00 00       	push   $0x1000
f01020d2:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01020d7:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01020dc:	50                   	push   %eax
f01020dd:	e8 d6 35 00 00       	call   f01056b8 <memset>
    page_free(pp0);
f01020e2:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01020e5:	89 34 24             	mov    %esi,(%esp)
f01020e8:	e8 81 ef ff ff       	call   f010106e <page_free>
    pgdir_walk(kern_pgdir, 0x0, 1);
f01020ed:	83 c4 0c             	add    $0xc,%esp
f01020f0:	6a 01                	push   $0x1
f01020f2:	6a 00                	push   $0x0
f01020f4:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f01020fa:	e8 ee ef ff ff       	call   f01010ed <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01020ff:	89 f2                	mov    %esi,%edx
f0102101:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0102107:	c1 fa 03             	sar    $0x3,%edx
f010210a:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010210d:	89 d0                	mov    %edx,%eax
f010210f:	c1 e8 0c             	shr    $0xc,%eax
f0102112:	83 c4 10             	add    $0x10,%esp
f0102115:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f010211b:	0f 83 94 08 00 00    	jae    f01029b5 <mem_init+0x161f>
	return (void *)(pa + KERNBASE);
f0102121:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
    ptep = (pte_t *) page2kva(pp0);
f0102127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010212a:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
    for (i = 0; i < NPTENTRIES; i++)
        assert((ptep[i] & PTE_P) == 0);
f0102130:	f6 00 01             	testb  $0x1,(%eax)
f0102133:	0f 85 8e 08 00 00    	jne    f01029c7 <mem_init+0x1631>
f0102139:	83 c0 04             	add    $0x4,%eax
    for (i = 0; i < NPTENTRIES; i++)
f010213c:	39 d0                	cmp    %edx,%eax
f010213e:	75 f0                	jne    f0102130 <mem_init+0xd9a>
    kern_pgdir[0] = 0;
f0102140:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0102145:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    pp0->pp_ref = 0;
f010214b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010214e:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // give free list back
    page_free_list = fl;
f0102154:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102157:	89 0d 44 42 23 f0    	mov    %ecx,0xf0234244

    // free the pages we took
    page_free(pp0);
f010215d:	83 ec 0c             	sub    $0xc,%esp
f0102160:	50                   	push   %eax
f0102161:	e8 08 ef ff ff       	call   f010106e <page_free>
    page_free(pp1);
f0102166:	89 1c 24             	mov    %ebx,(%esp)
f0102169:	e8 00 ef ff ff       	call   f010106e <page_free>
    page_free(pp2);
f010216e:	89 3c 24             	mov    %edi,(%esp)
f0102171:	e8 f8 ee ff ff       	call   f010106e <page_free>

    cprintf("check_page() succeeded!\n");
f0102176:	c7 04 24 4f 7a 10 f0 	movl   $0xf0107a4f,(%esp)
f010217d:	e8 fd 19 00 00       	call   f0103b7f <cprintf>
    cprintf("\n************* Now we set up virtual memory **************\n");
f0102182:	c7 04 24 b8 71 10 f0 	movl   $0xf01071b8,(%esp)
f0102189:	e8 f1 19 00 00       	call   f0103b7f <cprintf>
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f010218e:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0102193:	83 c4 10             	add    $0x10,%esp
f0102196:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010219b:	0f 86 3f 08 00 00    	jbe    f01029e0 <mem_init+0x164a>
	return (physaddr_t)kva - KERNBASE;
f01021a1:	05 00 00 00 10       	add    $0x10000000,%eax
f01021a6:	83 ec 0c             	sub    $0xc,%esp
f01021a9:	89 c2                	mov    %eax,%edx
f01021ab:	c1 ea 0c             	shr    $0xc,%edx
f01021ae:	52                   	push   %edx
f01021af:	50                   	push   %eax
f01021b0:	68 bd 03 00 00       	push   $0x3bd
f01021b5:	68 00 00 40 ef       	push   $0xef400000
f01021ba:	68 6f 78 10 f0       	push   $0xf010786f
f01021bf:	e8 cf 19 00 00       	call   f0103b93 <memCprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f01021c4:	a1 94 4e 23 f0       	mov    0xf0234e94,%eax
	if ((uint32_t)kva < KERNBASE)
f01021c9:	83 c4 20             	add    $0x20,%esp
f01021cc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021d1:	0f 86 1e 08 00 00    	jbe    f01029f5 <mem_init+0x165f>
	return (physaddr_t)kva - KERNBASE;
f01021d7:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01021dd:	83 ec 0c             	sub    $0xc,%esp
f01021e0:	89 d1                	mov    %edx,%ecx
f01021e2:	c1 e9 0c             	shr    $0xc,%ecx
f01021e5:	51                   	push   %ecx
f01021e6:	52                   	push   %edx
f01021e7:	89 c2                	mov    %eax,%edx
f01021e9:	c1 ea 16             	shr    $0x16,%edx
f01021ec:	52                   	push   %edx
f01021ed:	50                   	push   %eax
f01021ee:	68 6c 77 10 f0       	push   $0xf010776c
f01021f3:	e8 9b 19 00 00       	call   f0103b93 <memCprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f01021f8:	a1 4c 42 23 f0       	mov    0xf023424c,%eax
	if ((uint32_t)kva < KERNBASE)
f01021fd:	83 c4 20             	add    $0x20,%esp
f0102200:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102205:	0f 86 ff 07 00 00    	jbe    f0102a0a <mem_init+0x1674>
	return (physaddr_t)kva - KERNBASE;
f010220b:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0102211:	83 ec 0c             	sub    $0xc,%esp
f0102214:	89 d1                	mov    %edx,%ecx
f0102216:	c1 e9 0c             	shr    $0xc,%ecx
f0102219:	51                   	push   %ecx
f010221a:	52                   	push   %edx
f010221b:	89 c2                	mov    %eax,%edx
f010221d:	c1 ea 16             	shr    $0x16,%edx
f0102220:	52                   	push   %edx
f0102221:	50                   	push   %eax
f0102222:	68 bd 78 10 f0       	push   $0xf01078bd
f0102227:	e8 67 19 00 00       	call   f0103b93 <memCprintf>
    cprintf("\n************* Now we map 'pages' read-only by the user at linear address UPAGES **************\n");
f010222c:	83 c4 14             	add    $0x14,%esp
f010222f:	68 f4 71 10 f0       	push   $0xf01071f4
f0102234:	e8 46 19 00 00       	call   f0103b7f <cprintf>
    cprintf("page2pa(pages):0x%x\n", page2pa(pages));
f0102239:	83 c4 08             	add    $0x8,%esp
f010223c:	6a 00                	push   $0x0
f010223e:	68 68 7a 10 f0       	push   $0xf0107a68
f0102243:	e8 37 19 00 00       	call   f0103b7f <cprintf>
    boot_map_region(kern_pgdir, UPAGES, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE), PADDR(pages), PTE_U | PTE_P);
f0102248:	a1 94 4e 23 f0       	mov    0xf0234e94,%eax
	if ((uint32_t)kva < KERNBASE)
f010224d:	83 c4 10             	add    $0x10,%esp
f0102250:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102255:	0f 86 c4 07 00 00    	jbe    f0102a1f <mem_init+0x1689>
f010225b:	8b 15 8c 4e 23 f0    	mov    0xf0234e8c,%edx
f0102261:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0102268:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010226e:	83 ec 08             	sub    $0x8,%esp
f0102271:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102273:	05 00 00 00 10       	add    $0x10000000,%eax
f0102278:	50                   	push   %eax
f0102279:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010227e:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0102283:	e8 f7 ee ff ff       	call   f010117f <boot_map_region>
    cprintf("\n************* Now we map 'envs' read-only by the user at linear address UENVS **************\n");
f0102288:	c7 04 24 58 72 10 f0 	movl   $0xf0107258,(%esp)
f010228f:	e8 eb 18 00 00       	call   f0103b7f <cprintf>
    boot_map_region(kern_pgdir, UENVS, ROUNDUP(NENV * sizeof(struct Env), PGSIZE), PADDR(envs), PTE_U | PTE_P);
f0102294:	a1 4c 42 23 f0       	mov    0xf023424c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102299:	83 c4 10             	add    $0x10,%esp
f010229c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01022a1:	0f 86 8d 07 00 00    	jbe    f0102a34 <mem_init+0x169e>
f01022a7:	83 ec 08             	sub    $0x8,%esp
f01022aa:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f01022ac:	05 00 00 00 10       	add    $0x10000000,%eax
f01022b1:	50                   	push   %eax
f01022b2:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f01022b7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01022bc:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f01022c1:	e8 b9 ee ff ff       	call   f010117f <boot_map_region>
    cprintf("\n************* Now use the physical memory that 'bootstack' refers to as the kernel stack **************\n");
f01022c6:	c7 04 24 b8 72 10 f0 	movl   $0xf01072b8,(%esp)
f01022cd:	e8 ad 18 00 00       	call   f0103b7f <cprintf>
	if ((uint32_t)kva < KERNBASE)
f01022d2:	83 c4 10             	add    $0x10,%esp
f01022d5:	b8 00 80 11 f0       	mov    $0xf0118000,%eax
f01022da:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01022df:	0f 86 64 07 00 00    	jbe    f0102a49 <mem_init+0x16b3>
    boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_P | PTE_W);
f01022e5:	83 ec 08             	sub    $0x8,%esp
f01022e8:	6a 03                	push   $0x3
f01022ea:	68 00 80 11 00       	push   $0x118000
f01022ef:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01022f4:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01022f9:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f01022fe:	e8 7c ee ff ff       	call   f010117f <boot_map_region>
    cprintf("\n************* Now map all of physical memory at KERNBASE. **************\n");
f0102303:	c7 04 24 24 73 10 f0 	movl   $0xf0107324,(%esp)
f010230a:	e8 70 18 00 00       	call   f0103b7f <cprintf>
    boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE + 1, 0, PTE_W | PTE_P);//这权限有必要？？
f010230f:	83 c4 08             	add    $0x8,%esp
f0102312:	6a 03                	push   $0x3
f0102314:	6a 00                	push   $0x0
f0102316:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010231b:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102320:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0102325:	e8 55 ee ff ff       	call   f010117f <boot_map_region>
    cprintf("Map per-CPU stacks starting at KSTACKTOP, for up to 'NCPU' CPUs.\n");
f010232a:	c7 04 24 70 73 10 f0 	movl   $0xf0107370,(%esp)
f0102331:	e8 49 18 00 00       	call   f0103b7f <cprintf>
f0102336:	c7 45 cc 00 60 23 f0 	movl   $0xf0236000,-0x34(%ebp)
f010233d:	83 c4 10             	add    $0x10,%esp
f0102340:	be 00 60 23 f0       	mov    $0xf0236000,%esi
f0102345:	8b 7d d0             	mov    -0x30(%ebp),%edi
f0102348:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f010234e:	0f 86 0a 07 00 00    	jbe    f0102a5e <mem_init+0x16c8>
f0102354:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f010235a:	89 fb                	mov    %edi,%ebx
f010235c:	f7 db                	neg    %ebx
f010235e:	c1 e3 10             	shl    $0x10,%ebx
f0102361:	81 eb 00 80 00 10    	sub    $0x10008000,%ebx
        cprintf("cpu%d stack start at:0x%x(vaddr)\t0x%x(paddr)\n", i, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f0102367:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010236a:	50                   	push   %eax
f010236b:	53                   	push   %ebx
f010236c:	57                   	push   %edi
f010236d:	68 b4 73 10 f0       	push   $0xf01073b4
f0102372:	e8 08 18 00 00       	call   f0103b7f <cprintf>
        boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE, KSTKSIZE, PADDR(percpu_kstacks[i]),
f0102377:	83 c4 08             	add    $0x8,%esp
f010237a:	6a 02                	push   $0x2
f010237c:	ff 75 d4             	pushl  -0x2c(%ebp)
f010237f:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102384:	89 da                	mov    %ebx,%edx
f0102386:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f010238b:	e8 ef ed ff ff       	call   f010117f <boot_map_region>
    for (int i = 0; i < NCPU; i++) {
f0102390:	83 c7 01             	add    $0x1,%edi
f0102393:	81 c6 00 80 00 00    	add    $0x8000,%esi
f0102399:	83 c4 10             	add    $0x10,%esp
f010239c:	83 ff 08             	cmp    $0x8,%edi
f010239f:	75 a7                	jne    f0102348 <mem_init+0xfb2>
    cprintf("\n************* Now check that the initial page directory has been set up correctly **************\n");
f01023a1:	83 ec 0c             	sub    $0xc,%esp
f01023a4:	68 e4 73 10 f0       	push   $0xf01073e4
f01023a9:	e8 d1 17 00 00       	call   f0103b7f <cprintf>
    pgdir = kern_pgdir;
f01023ae:	8b 3d 90 4e 23 f0    	mov    0xf0234e90,%edi
    n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f01023b4:	a1 8c 4e 23 f0       	mov    0xf0234e8c,%eax
f01023b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01023bc:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01023c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01023c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01023cb:	a1 94 4e 23 f0       	mov    0xf0234e94,%eax
f01023d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01023d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01023d6:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
f01023dc:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < n; i += PGSIZE)
f01023df:	bb 00 00 00 00       	mov    $0x0,%ebx
f01023e4:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01023e7:	0f 86 b6 06 00 00    	jbe    f0102aa3 <mem_init+0x170d>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01023ed:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01023f3:	89 f8                	mov    %edi,%eax
f01023f5:	e8 ca e6 ff ff       	call   f0100ac4 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01023fa:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102401:	0f 86 6c 06 00 00    	jbe    f0102a73 <mem_init+0x16dd>
f0102407:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f010240a:	39 d0                	cmp    %edx,%eax
f010240c:	0f 85 78 06 00 00    	jne    f0102a8a <mem_init+0x16f4>
    for (i = 0; i < n; i += PGSIZE)
f0102412:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102418:	eb ca                	jmp    f01023e4 <mem_init+0x104e>
    assert(nfree == 0);
f010241a:	68 78 79 10 f0       	push   $0xf0107978
f010241f:	68 21 77 10 f0       	push   $0xf0107721
f0102424:	68 9d 03 00 00       	push   $0x39d
f0102429:	68 36 77 10 f0       	push   $0xf0107736
f010242e:	e8 0d dc ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0102433:	68 dd 78 10 f0       	push   $0xf01078dd
f0102438:	68 21 77 10 f0       	push   $0xf0107721
f010243d:	68 00 04 00 00       	push   $0x400
f0102442:	68 36 77 10 f0       	push   $0xf0107736
f0102447:	e8 f4 db ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f010244c:	68 f3 78 10 f0       	push   $0xf01078f3
f0102451:	68 21 77 10 f0       	push   $0xf0107721
f0102456:	68 01 04 00 00       	push   $0x401
f010245b:	68 36 77 10 f0       	push   $0xf0107736
f0102460:	e8 db db ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0102465:	68 09 79 10 f0       	push   $0xf0107909
f010246a:	68 21 77 10 f0       	push   $0xf0107721
f010246f:	68 02 04 00 00       	push   $0x402
f0102474:	68 36 77 10 f0       	push   $0xf0107736
f0102479:	e8 c2 db ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f010247e:	68 1f 79 10 f0       	push   $0xf010791f
f0102483:	68 21 77 10 f0       	push   $0xf0107721
f0102488:	68 05 04 00 00       	push   $0x405
f010248d:	68 36 77 10 f0       	push   $0xf0107736
f0102492:	e8 a9 db ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102497:	68 4c 6c 10 f0       	push   $0xf0106c4c
f010249c:	68 21 77 10 f0       	push   $0xf0107721
f01024a1:	68 06 04 00 00       	push   $0x406
f01024a6:	68 36 77 10 f0       	push   $0xf0107736
f01024ab:	e8 90 db ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01024b0:	68 31 79 10 f0       	push   $0xf0107931
f01024b5:	68 21 77 10 f0       	push   $0xf0107721
f01024ba:	68 0d 04 00 00       	push   $0x40d
f01024bf:	68 36 77 10 f0       	push   $0xf0107736
f01024c4:	e8 77 db ff ff       	call   f0100040 <_panic>
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01024c9:	68 34 6d 10 f0       	push   $0xf0106d34
f01024ce:	68 21 77 10 f0       	push   $0xf0107721
f01024d3:	68 10 04 00 00       	push   $0x410
f01024d8:	68 36 77 10 f0       	push   $0xf0107736
f01024dd:	e8 5e db ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01024e2:	68 6c 6d 10 f0       	push   $0xf0106d6c
f01024e7:	68 21 77 10 f0       	push   $0xf0107721
f01024ec:	68 13 04 00 00       	push   $0x413
f01024f1:	68 36 77 10 f0       	push   $0xf0107736
f01024f6:	e8 45 db ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01024fb:	68 9c 6d 10 f0       	push   $0xf0106d9c
f0102500:	68 21 77 10 f0       	push   $0xf0107721
f0102505:	68 17 04 00 00       	push   $0x417
f010250a:	68 36 77 10 f0       	push   $0xf0107736
f010250f:	e8 2c db ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102514:	68 cc 6d 10 f0       	push   $0xf0106dcc
f0102519:	68 21 77 10 f0       	push   $0xf0107721
f010251e:	68 18 04 00 00       	push   $0x418
f0102523:	68 36 77 10 f0       	push   $0xf0107736
f0102528:	e8 13 db ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010252d:	68 f4 6d 10 f0       	push   $0xf0106df4
f0102532:	68 21 77 10 f0       	push   $0xf0107721
f0102537:	68 19 04 00 00       	push   $0x419
f010253c:	68 36 77 10 f0       	push   $0xf0107736
f0102541:	e8 fa da ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102546:	68 83 79 10 f0       	push   $0xf0107983
f010254b:	68 21 77 10 f0       	push   $0xf0107721
f0102550:	68 1a 04 00 00       	push   $0x41a
f0102555:	68 36 77 10 f0       	push   $0xf0107736
f010255a:	e8 e1 da ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f010255f:	68 94 79 10 f0       	push   $0xf0107994
f0102564:	68 21 77 10 f0       	push   $0xf0107721
f0102569:	68 1b 04 00 00       	push   $0x41b
f010256e:	68 36 77 10 f0       	push   $0xf0107736
f0102573:	e8 c8 da ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102578:	68 24 6e 10 f0       	push   $0xf0106e24
f010257d:	68 21 77 10 f0       	push   $0xf0107721
f0102582:	68 1e 04 00 00       	push   $0x41e
f0102587:	68 36 77 10 f0       	push   $0xf0107736
f010258c:	e8 af da ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102591:	68 60 6e 10 f0       	push   $0xf0106e60
f0102596:	68 21 77 10 f0       	push   $0xf0107721
f010259b:	68 1f 04 00 00       	push   $0x41f
f01025a0:	68 36 77 10 f0       	push   $0xf0107736
f01025a5:	e8 96 da ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f01025aa:	68 a5 79 10 f0       	push   $0xf01079a5
f01025af:	68 21 77 10 f0       	push   $0xf0107721
f01025b4:	68 20 04 00 00       	push   $0x420
f01025b9:	68 36 77 10 f0       	push   $0xf0107736
f01025be:	e8 7d da ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01025c3:	68 31 79 10 f0       	push   $0xf0107931
f01025c8:	68 21 77 10 f0       	push   $0xf0107721
f01025cd:	68 23 04 00 00       	push   $0x423
f01025d2:	68 36 77 10 f0       	push   $0xf0107736
f01025d7:	e8 64 da ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01025dc:	68 24 6e 10 f0       	push   $0xf0106e24
f01025e1:	68 21 77 10 f0       	push   $0xf0107721
f01025e6:	68 26 04 00 00       	push   $0x426
f01025eb:	68 36 77 10 f0       	push   $0xf0107736
f01025f0:	e8 4b da ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01025f5:	68 60 6e 10 f0       	push   $0xf0106e60
f01025fa:	68 21 77 10 f0       	push   $0xf0107721
f01025ff:	68 27 04 00 00       	push   $0x427
f0102604:	68 36 77 10 f0       	push   $0xf0107736
f0102609:	e8 32 da ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f010260e:	68 a5 79 10 f0       	push   $0xf01079a5
f0102613:	68 21 77 10 f0       	push   $0xf0107721
f0102618:	68 28 04 00 00       	push   $0x428
f010261d:	68 36 77 10 f0       	push   $0xf0107736
f0102622:	e8 19 da ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0102627:	68 31 79 10 f0       	push   $0xf0107931
f010262c:	68 21 77 10 f0       	push   $0xf0107721
f0102631:	68 2c 04 00 00       	push   $0x42c
f0102636:	68 36 77 10 f0       	push   $0xf0107736
f010263b:	e8 00 da ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102640:	50                   	push   %eax
f0102641:	68 64 63 10 f0       	push   $0xf0106364
f0102646:	68 2f 04 00 00       	push   $0x42f
f010264b:	68 36 77 10 f0       	push   $0xf0107736
f0102650:	e8 eb d9 ff ff       	call   f0100040 <_panic>
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102655:	68 90 6e 10 f0       	push   $0xf0106e90
f010265a:	68 21 77 10 f0       	push   $0xf0107721
f010265f:	68 30 04 00 00       	push   $0x430
f0102664:	68 36 77 10 f0       	push   $0xf0107736
f0102669:	e8 d2 d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f010266e:	68 d4 6e 10 f0       	push   $0xf0106ed4
f0102673:	68 21 77 10 f0       	push   $0xf0107721
f0102678:	68 33 04 00 00       	push   $0x433
f010267d:	68 36 77 10 f0       	push   $0xf0107736
f0102682:	e8 b9 d9 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102687:	68 60 6e 10 f0       	push   $0xf0106e60
f010268c:	68 21 77 10 f0       	push   $0xf0107721
f0102691:	68 34 04 00 00       	push   $0x434
f0102696:	68 36 77 10 f0       	push   $0xf0107736
f010269b:	e8 a0 d9 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f01026a0:	68 a5 79 10 f0       	push   $0xf01079a5
f01026a5:	68 21 77 10 f0       	push   $0xf0107721
f01026aa:	68 35 04 00 00       	push   $0x435
f01026af:	68 36 77 10 f0       	push   $0xf0107736
f01026b4:	e8 87 d9 ff ff       	call   f0100040 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f01026b9:	68 18 6f 10 f0       	push   $0xf0106f18
f01026be:	68 21 77 10 f0       	push   $0xf0107721
f01026c3:	68 36 04 00 00       	push   $0x436
f01026c8:	68 36 77 10 f0       	push   $0xf0107736
f01026cd:	e8 6e d9 ff ff       	call   f0100040 <_panic>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f01026d2:	68 b6 79 10 f0       	push   $0xf01079b6
f01026d7:	68 21 77 10 f0       	push   $0xf0107721
f01026dc:	68 37 04 00 00       	push   $0x437
f01026e1:	68 36 77 10 f0       	push   $0xf0107736
f01026e6:	e8 55 d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01026eb:	68 24 6e 10 f0       	push   $0xf0106e24
f01026f0:	68 21 77 10 f0       	push   $0xf0107721
f01026f5:	68 3a 04 00 00       	push   $0x43a
f01026fa:	68 36 77 10 f0       	push   $0xf0107736
f01026ff:	e8 3c d9 ff ff       	call   f0100040 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102704:	68 4c 6f 10 f0       	push   $0xf0106f4c
f0102709:	68 21 77 10 f0       	push   $0xf0107721
f010270e:	68 3b 04 00 00       	push   $0x43b
f0102713:	68 36 77 10 f0       	push   $0xf0107736
f0102718:	e8 23 d9 ff ff       	call   f0100040 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f010271d:	68 80 6f 10 f0       	push   $0xf0106f80
f0102722:	68 21 77 10 f0       	push   $0xf0107721
f0102727:	68 3c 04 00 00       	push   $0x43c
f010272c:	68 36 77 10 f0       	push   $0xf0107736
f0102731:	e8 0a d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102736:	68 b8 6f 10 f0       	push   $0xf0106fb8
f010273b:	68 21 77 10 f0       	push   $0xf0107721
f0102740:	68 3f 04 00 00       	push   $0x43f
f0102745:	68 36 77 10 f0       	push   $0xf0107736
f010274a:	e8 f1 d8 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f010274f:	68 f4 6f 10 f0       	push   $0xf0106ff4
f0102754:	68 21 77 10 f0       	push   $0xf0107721
f0102759:	68 42 04 00 00       	push   $0x442
f010275e:	68 36 77 10 f0       	push   $0xf0107736
f0102763:	e8 d8 d8 ff ff       	call   f0100040 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102768:	68 80 6f 10 f0       	push   $0xf0106f80
f010276d:	68 21 77 10 f0       	push   $0xf0107721
f0102772:	68 43 04 00 00       	push   $0x443
f0102777:	68 36 77 10 f0       	push   $0xf0107736
f010277c:	e8 bf d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102781:	68 30 70 10 f0       	push   $0xf0107030
f0102786:	68 21 77 10 f0       	push   $0xf0107721
f010278b:	68 46 04 00 00       	push   $0x446
f0102790:	68 36 77 10 f0       	push   $0xf0107736
f0102795:	e8 a6 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010279a:	68 5c 70 10 f0       	push   $0xf010705c
f010279f:	68 21 77 10 f0       	push   $0xf0107721
f01027a4:	68 47 04 00 00       	push   $0x447
f01027a9:	68 36 77 10 f0       	push   $0xf0107736
f01027ae:	e8 8d d8 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 2);
f01027b3:	68 cc 79 10 f0       	push   $0xf01079cc
f01027b8:	68 21 77 10 f0       	push   $0xf0107721
f01027bd:	68 49 04 00 00       	push   $0x449
f01027c2:	68 36 77 10 f0       	push   $0xf0107736
f01027c7:	e8 74 d8 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f01027cc:	68 dd 79 10 f0       	push   $0xf01079dd
f01027d1:	68 21 77 10 f0       	push   $0xf0107721
f01027d6:	68 4a 04 00 00       	push   $0x44a
f01027db:	68 36 77 10 f0       	push   $0xf0107736
f01027e0:	e8 5b d8 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(0)) && pp == pp2);
f01027e5:	68 8c 70 10 f0       	push   $0xf010708c
f01027ea:	68 21 77 10 f0       	push   $0xf0107721
f01027ef:	68 4d 04 00 00       	push   $0x44d
f01027f4:	68 36 77 10 f0       	push   $0xf0107736
f01027f9:	e8 42 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027fe:	68 b0 70 10 f0       	push   $0xf01070b0
f0102803:	68 21 77 10 f0       	push   $0xf0107721
f0102808:	68 51 04 00 00       	push   $0x451
f010280d:	68 36 77 10 f0       	push   $0xf0107736
f0102812:	e8 29 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102817:	68 5c 70 10 f0       	push   $0xf010705c
f010281c:	68 21 77 10 f0       	push   $0xf0107721
f0102821:	68 52 04 00 00       	push   $0x452
f0102826:	68 36 77 10 f0       	push   $0xf0107736
f010282b:	e8 10 d8 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102830:	68 83 79 10 f0       	push   $0xf0107983
f0102835:	68 21 77 10 f0       	push   $0xf0107721
f010283a:	68 53 04 00 00       	push   $0x453
f010283f:	68 36 77 10 f0       	push   $0xf0107736
f0102844:	e8 f7 d7 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0102849:	68 dd 79 10 f0       	push   $0xf01079dd
f010284e:	68 21 77 10 f0       	push   $0xf0107721
f0102853:	68 54 04 00 00       	push   $0x454
f0102858:	68 36 77 10 f0       	push   $0xf0107736
f010285d:	e8 de d7 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102862:	68 d4 70 10 f0       	push   $0xf01070d4
f0102867:	68 21 77 10 f0       	push   $0xf0107721
f010286c:	68 57 04 00 00       	push   $0x457
f0102871:	68 36 77 10 f0       	push   $0xf0107736
f0102876:	e8 c5 d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref);
f010287b:	68 ee 79 10 f0       	push   $0xf01079ee
f0102880:	68 21 77 10 f0       	push   $0xf0107721
f0102885:	68 58 04 00 00       	push   $0x458
f010288a:	68 36 77 10 f0       	push   $0xf0107736
f010288f:	e8 ac d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_link == NULL);
f0102894:	68 fa 79 10 f0       	push   $0xf01079fa
f0102899:	68 21 77 10 f0       	push   $0xf0107721
f010289e:	68 59 04 00 00       	push   $0x459
f01028a3:	68 36 77 10 f0       	push   $0xf0107736
f01028a8:	e8 93 d7 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01028ad:	68 b0 70 10 f0       	push   $0xf01070b0
f01028b2:	68 21 77 10 f0       	push   $0xf0107721
f01028b7:	68 5d 04 00 00       	push   $0x45d
f01028bc:	68 36 77 10 f0       	push   $0xf0107736
f01028c1:	e8 7a d7 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01028c6:	68 0c 71 10 f0       	push   $0xf010710c
f01028cb:	68 21 77 10 f0       	push   $0xf0107721
f01028d0:	68 5e 04 00 00       	push   $0x45e
f01028d5:	68 36 77 10 f0       	push   $0xf0107736
f01028da:	e8 61 d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f01028df:	68 0f 7a 10 f0       	push   $0xf0107a0f
f01028e4:	68 21 77 10 f0       	push   $0xf0107721
f01028e9:	68 5f 04 00 00       	push   $0x45f
f01028ee:	68 36 77 10 f0       	push   $0xf0107736
f01028f3:	e8 48 d7 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f01028f8:	68 dd 79 10 f0       	push   $0xf01079dd
f01028fd:	68 21 77 10 f0       	push   $0xf0107721
f0102902:	68 60 04 00 00       	push   $0x460
f0102907:	68 36 77 10 f0       	push   $0xf0107736
f010290c:	e8 2f d7 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(0)) && pp == pp1);
f0102911:	68 34 71 10 f0       	push   $0xf0107134
f0102916:	68 21 77 10 f0       	push   $0xf0107721
f010291b:	68 63 04 00 00       	push   $0x463
f0102920:	68 36 77 10 f0       	push   $0xf0107736
f0102925:	e8 16 d7 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f010292a:	68 31 79 10 f0       	push   $0xf0107931
f010292f:	68 21 77 10 f0       	push   $0xf0107721
f0102934:	68 66 04 00 00       	push   $0x466
f0102939:	68 36 77 10 f0       	push   $0xf0107736
f010293e:	e8 fd d6 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102943:	68 cc 6d 10 f0       	push   $0xf0106dcc
f0102948:	68 21 77 10 f0       	push   $0xf0107721
f010294d:	68 69 04 00 00       	push   $0x469
f0102952:	68 36 77 10 f0       	push   $0xf0107736
f0102957:	e8 e4 d6 ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f010295c:	68 94 79 10 f0       	push   $0xf0107994
f0102961:	68 21 77 10 f0       	push   $0xf0107721
f0102966:	68 6b 04 00 00       	push   $0x46b
f010296b:	68 36 77 10 f0       	push   $0xf0107736
f0102970:	e8 cb d6 ff ff       	call   f0100040 <_panic>
f0102975:	56                   	push   %esi
f0102976:	68 64 63 10 f0       	push   $0xf0106364
f010297b:	68 72 04 00 00       	push   $0x472
f0102980:	68 36 77 10 f0       	push   $0xf0107736
f0102985:	e8 b6 d6 ff ff       	call   f0100040 <_panic>
    assert(ptep == ptep1 + PTX(va));
f010298a:	68 20 7a 10 f0       	push   $0xf0107a20
f010298f:	68 21 77 10 f0       	push   $0xf0107721
f0102994:	68 77 04 00 00       	push   $0x477
f0102999:	68 36 77 10 f0       	push   $0xf0107736
f010299e:	e8 9d d6 ff ff       	call   f0100040 <_panic>
f01029a3:	50                   	push   %eax
f01029a4:	68 64 63 10 f0       	push   $0xf0106364
f01029a9:	6a 58                	push   $0x58
f01029ab:	68 42 77 10 f0       	push   $0xf0107742
f01029b0:	e8 8b d6 ff ff       	call   f0100040 <_panic>
f01029b5:	52                   	push   %edx
f01029b6:	68 64 63 10 f0       	push   $0xf0106364
f01029bb:	6a 58                	push   $0x58
f01029bd:	68 42 77 10 f0       	push   $0xf0107742
f01029c2:	e8 79 d6 ff ff       	call   f0100040 <_panic>
        assert((ptep[i] & PTE_P) == 0);
f01029c7:	68 38 7a 10 f0       	push   $0xf0107a38
f01029cc:	68 21 77 10 f0       	push   $0xf0107721
f01029d1:	68 81 04 00 00       	push   $0x481
f01029d6:	68 36 77 10 f0       	push   $0xf0107736
f01029db:	e8 60 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029e0:	50                   	push   %eax
f01029e1:	68 88 63 10 f0       	push   $0xf0106388
f01029e6:	68 d1 00 00 00       	push   $0xd1
f01029eb:	68 36 77 10 f0       	push   $0xf0107736
f01029f0:	e8 4b d6 ff ff       	call   f0100040 <_panic>
f01029f5:	50                   	push   %eax
f01029f6:	68 88 63 10 f0       	push   $0xf0106388
f01029fb:	68 d2 00 00 00       	push   $0xd2
f0102a00:	68 36 77 10 f0       	push   $0xf0107736
f0102a05:	e8 36 d6 ff ff       	call   f0100040 <_panic>
f0102a0a:	50                   	push   %eax
f0102a0b:	68 88 63 10 f0       	push   $0xf0106388
f0102a10:	68 d3 00 00 00       	push   $0xd3
f0102a15:	68 36 77 10 f0       	push   $0xf0107736
f0102a1a:	e8 21 d6 ff ff       	call   f0100040 <_panic>
f0102a1f:	50                   	push   %eax
f0102a20:	68 88 63 10 f0       	push   $0xf0106388
f0102a25:	68 d7 00 00 00       	push   $0xd7
f0102a2a:	68 36 77 10 f0       	push   $0xf0107736
f0102a2f:	e8 0c d6 ff ff       	call   f0100040 <_panic>
f0102a34:	50                   	push   %eax
f0102a35:	68 88 63 10 f0       	push   $0xf0106388
f0102a3a:	68 e1 00 00 00       	push   $0xe1
f0102a3f:	68 36 77 10 f0       	push   $0xf0107736
f0102a44:	e8 f7 d5 ff ff       	call   f0100040 <_panic>
f0102a49:	50                   	push   %eax
f0102a4a:	68 88 63 10 f0       	push   $0xf0106388
f0102a4f:	68 f2 00 00 00       	push   $0xf2
f0102a54:	68 36 77 10 f0       	push   $0xf0107736
f0102a59:	e8 e2 d5 ff ff       	call   f0100040 <_panic>
f0102a5e:	56                   	push   %esi
f0102a5f:	68 88 63 10 f0       	push   $0xf0106388
f0102a64:	68 36 01 00 00       	push   $0x136
f0102a69:	68 36 77 10 f0       	push   $0xf0107736
f0102a6e:	e8 cd d5 ff ff       	call   f0100040 <_panic>
f0102a73:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102a76:	68 88 63 10 f0       	push   $0xf0106388
f0102a7b:	68 b4 03 00 00       	push   $0x3b4
f0102a80:	68 36 77 10 f0       	push   $0xf0107736
f0102a85:	e8 b6 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a8a:	68 48 74 10 f0       	push   $0xf0107448
f0102a8f:	68 21 77 10 f0       	push   $0xf0107721
f0102a94:	68 b4 03 00 00       	push   $0x3b4
f0102a99:	68 36 77 10 f0       	push   $0xf0107736
f0102a9e:	e8 9d d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102aa3:	a1 4c 42 23 f0       	mov    0xf023424c,%eax
f0102aa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102aab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102aae:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102ab3:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102ab9:	89 da                	mov    %ebx,%edx
f0102abb:	89 f8                	mov    %edi,%eax
f0102abd:	e8 02 e0 ff ff       	call   f0100ac4 <check_va2pa>
f0102ac2:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102ac9:	76 3d                	jbe    f0102b08 <mem_init+0x1772>
f0102acb:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102ace:	39 d0                	cmp    %edx,%eax
f0102ad0:	75 4d                	jne    f0102b1f <mem_init+0x1789>
f0102ad2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    for (i = 0; i < n; i += PGSIZE)
f0102ad8:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102ade:	75 d9                	jne    f0102ab9 <mem_init+0x1723>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ae0:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102ae3:	c1 e6 0c             	shl    $0xc,%esi
f0102ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102aeb:	39 f3                	cmp    %esi,%ebx
f0102aed:	73 62                	jae    f0102b51 <mem_init+0x17bb>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102aef:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102af5:	89 f8                	mov    %edi,%eax
f0102af7:	e8 c8 df ff ff       	call   f0100ac4 <check_va2pa>
f0102afc:	39 c3                	cmp    %eax,%ebx
f0102afe:	75 38                	jne    f0102b38 <mem_init+0x17a2>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b00:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102b06:	eb e3                	jmp    f0102aeb <mem_init+0x1755>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b08:	ff 75 d0             	pushl  -0x30(%ebp)
f0102b0b:	68 88 63 10 f0       	push   $0xf0106388
f0102b10:	68 b9 03 00 00       	push   $0x3b9
f0102b15:	68 36 77 10 f0       	push   $0xf0107736
f0102b1a:	e8 21 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102b1f:	68 7c 74 10 f0       	push   $0xf010747c
f0102b24:	68 21 77 10 f0       	push   $0xf0107721
f0102b29:	68 b9 03 00 00       	push   $0x3b9
f0102b2e:	68 36 77 10 f0       	push   $0xf0107736
f0102b33:	e8 08 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b38:	68 b0 74 10 f0       	push   $0xf01074b0
f0102b3d:	68 21 77 10 f0       	push   $0xf0107721
f0102b42:	68 bd 03 00 00       	push   $0x3bd
f0102b47:	68 36 77 10 f0       	push   $0xf0107736
f0102b4c:	e8 ef d4 ff ff       	call   f0100040 <_panic>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b51:	c7 45 d4 00 60 23 f0 	movl   $0xf0236000,-0x2c(%ebp)
f0102b58:	be 00 80 ff ef       	mov    $0xefff8000,%esi
            assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b60:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102b63:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102b69:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102b6c:	89 f3                	mov    %esi,%ebx
f0102b6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102b71:	05 00 80 00 20       	add    $0x20008000,%eax
f0102b76:	89 75 c8             	mov    %esi,-0x38(%ebp)
f0102b79:	89 c6                	mov    %eax,%esi
f0102b7b:	89 da                	mov    %ebx,%edx
f0102b7d:	89 f8                	mov    %edi,%eax
f0102b7f:	e8 40 df ff ff       	call   f0100ac4 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102b84:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102b8b:	76 5c                	jbe    f0102be9 <mem_init+0x1853>
f0102b8d:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102b90:	39 d0                	cmp    %edx,%eax
f0102b92:	75 6c                	jne    f0102c00 <mem_init+0x186a>
f0102b94:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b9a:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f0102b9d:	75 dc                	jne    f0102b7b <mem_init+0x17e5>
f0102b9f:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102ba2:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
            assert(check_va2pa(pgdir, base + i) == ~0);
f0102ba8:	89 da                	mov    %ebx,%edx
f0102baa:	89 f8                	mov    %edi,%eax
f0102bac:	e8 13 df ff ff       	call   f0100ac4 <check_va2pa>
f0102bb1:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102bb4:	75 63                	jne    f0102c19 <mem_init+0x1883>
f0102bb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102bbc:	39 f3                	cmp    %esi,%ebx
f0102bbe:	75 e8                	jne    f0102ba8 <mem_init+0x1812>
f0102bc0:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102bc6:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0102bcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102bd0:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
    for (n = 0; n < NCPU; n++) {
f0102bd7:	3d 00 60 2f f0       	cmp    $0xf02f6000,%eax
f0102bdc:	0f 85 7b ff ff ff    	jne    f0102b5d <mem_init+0x17c7>
    for (i = 0; i < NPDENTRIES; i++) {
f0102be2:	b8 00 00 00 00       	mov    $0x0,%eax
f0102be7:	eb 6b                	jmp    f0102c54 <mem_init+0x18be>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102be9:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102bec:	68 88 63 10 f0       	push   $0xf0106388
f0102bf1:	68 c5 03 00 00       	push   $0x3c5
f0102bf6:	68 36 77 10 f0       	push   $0xf0107736
f0102bfb:	e8 40 d4 ff ff       	call   f0100040 <_panic>
            assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102c00:	68 d8 74 10 f0       	push   $0xf01074d8
f0102c05:	68 21 77 10 f0       	push   $0xf0107721
f0102c0a:	68 c5 03 00 00       	push   $0x3c5
f0102c0f:	68 36 77 10 f0       	push   $0xf0107736
f0102c14:	e8 27 d4 ff ff       	call   f0100040 <_panic>
            assert(check_va2pa(pgdir, base + i) == ~0);
f0102c19:	68 20 75 10 f0       	push   $0xf0107520
f0102c1e:	68 21 77 10 f0       	push   $0xf0107721
f0102c23:	68 c7 03 00 00       	push   $0x3c7
f0102c28:	68 36 77 10 f0       	push   $0xf0107736
f0102c2d:	e8 0e d4 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_P);
f0102c32:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102c35:	f6 c2 01             	test   $0x1,%dl
f0102c38:	74 40                	je     f0102c7a <mem_init+0x18e4>
                    assert(pgdir[i] & PTE_W);
f0102c3a:	f6 c2 02             	test   $0x2,%dl
f0102c3d:	74 54                	je     f0102c93 <mem_init+0x18fd>
    for (i = 0; i < NPDENTRIES; i++) {
f0102c3f:	83 c0 01             	add    $0x1,%eax
f0102c42:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102c47:	77 63                	ja     f0102cac <mem_init+0x1916>
        switch (i) {
f0102c49:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102c4f:	83 fa 04             	cmp    $0x4,%edx
f0102c52:	76 eb                	jbe    f0102c3f <mem_init+0x18a9>
                if (i >= PDX(KERNBASE)) {
f0102c54:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102c59:	77 d7                	ja     f0102c32 <mem_init+0x189c>
                    assert(pgdir[i] == 0);
f0102c5b:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102c5f:	74 de                	je     f0102c3f <mem_init+0x18a9>
f0102c61:	68 9f 7a 10 f0       	push   $0xf0107a9f
f0102c66:	68 21 77 10 f0       	push   $0xf0107721
f0102c6b:	68 da 03 00 00       	push   $0x3da
f0102c70:	68 36 77 10 f0       	push   $0xf0107736
f0102c75:	e8 c6 d3 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_P);
f0102c7a:	68 7d 7a 10 f0       	push   $0xf0107a7d
f0102c7f:	68 21 77 10 f0       	push   $0xf0107721
f0102c84:	68 d7 03 00 00       	push   $0x3d7
f0102c89:	68 36 77 10 f0       	push   $0xf0107736
f0102c8e:	e8 ad d3 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_W);
f0102c93:	68 8e 7a 10 f0       	push   $0xf0107a8e
f0102c98:	68 21 77 10 f0       	push   $0xf0107721
f0102c9d:	68 d8 03 00 00       	push   $0x3d8
f0102ca2:	68 36 77 10 f0       	push   $0xf0107736
f0102ca7:	e8 94 d3 ff ff       	call   f0100040 <_panic>
    cprintf("check_kern_pgdir() succeeded!\n");
f0102cac:	83 ec 0c             	sub    $0xc,%esp
f0102caf:	68 44 75 10 f0       	push   $0xf0107544
f0102cb4:	e8 c6 0e 00 00       	call   f0103b7f <cprintf>
    lcr3(PADDR(kern_pgdir));
f0102cb9:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0102cbe:	83 c4 10             	add    $0x10,%esp
f0102cc1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102cc6:	0f 86 19 02 00 00    	jbe    f0102ee5 <mem_init+0x1b4f>
	return (physaddr_t)kva - KERNBASE;
f0102ccc:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102cd1:	0f 22 d8             	mov    %eax,%cr3
    cprintf("\n************* Now check that the pages on the page_free_list are reasonable. **************\n");
f0102cd4:	83 ec 0c             	sub    $0xc,%esp
f0102cd7:	68 64 75 10 f0       	push   $0xf0107564
f0102cdc:	e8 9e 0e 00 00       	call   f0103b7f <cprintf>
    check_page_free_list(0);
f0102ce1:	b8 00 00 00 00       	mov    $0x0,%eax
f0102ce6:	e8 3d de ff ff       	call   f0100b28 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102ceb:	0f 20 c0             	mov    %cr0,%eax
    cr0 &= ~(CR0_TS | CR0_EM);
f0102cee:	83 e0 f3             	and    $0xfffffff3,%eax
f0102cf1:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102cf6:	0f 22 c0             	mov    %eax,%cr0
    cprintf("\n************* Now check page_insert, page_remove, &c, with an installed kern_pgdir **************\n");
f0102cf9:	c7 04 24 c4 75 10 f0 	movl   $0xf01075c4,(%esp)
f0102d00:	e8 7a 0e 00 00       	call   f0103b7f <cprintf>
    uintptr_t va;
    int i;

    // check that we can read and write installed pages
    pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0102d05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102d0c:	e8 e5 e2 ff ff       	call   f0100ff6 <page_alloc>
f0102d11:	89 c3                	mov    %eax,%ebx
f0102d13:	83 c4 10             	add    $0x10,%esp
f0102d16:	85 c0                	test   %eax,%eax
f0102d18:	0f 84 dc 01 00 00    	je     f0102efa <mem_init+0x1b64>
    assert((pp1 = page_alloc(0)));
f0102d1e:	83 ec 0c             	sub    $0xc,%esp
f0102d21:	6a 00                	push   $0x0
f0102d23:	e8 ce e2 ff ff       	call   f0100ff6 <page_alloc>
f0102d28:	89 c7                	mov    %eax,%edi
f0102d2a:	83 c4 10             	add    $0x10,%esp
f0102d2d:	85 c0                	test   %eax,%eax
f0102d2f:	0f 84 de 01 00 00    	je     f0102f13 <mem_init+0x1b7d>
    assert((pp2 = page_alloc(0)));
f0102d35:	83 ec 0c             	sub    $0xc,%esp
f0102d38:	6a 00                	push   $0x0
f0102d3a:	e8 b7 e2 ff ff       	call   f0100ff6 <page_alloc>
f0102d3f:	89 c6                	mov    %eax,%esi
f0102d41:	83 c4 10             	add    $0x10,%esp
f0102d44:	85 c0                	test   %eax,%eax
f0102d46:	0f 84 e0 01 00 00    	je     f0102f2c <mem_init+0x1b96>
    page_free(pp0);
f0102d4c:	83 ec 0c             	sub    $0xc,%esp
f0102d4f:	53                   	push   %ebx
f0102d50:	e8 19 e3 ff ff       	call   f010106e <page_free>
	return (pp - pages) << PGSHIFT;
f0102d55:	89 f8                	mov    %edi,%eax
f0102d57:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0102d5d:	c1 f8 03             	sar    $0x3,%eax
f0102d60:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102d63:	89 c2                	mov    %eax,%edx
f0102d65:	c1 ea 0c             	shr    $0xc,%edx
f0102d68:	83 c4 10             	add    $0x10,%esp
f0102d6b:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0102d71:	0f 83 ce 01 00 00    	jae    f0102f45 <mem_init+0x1baf>
    memset(page2kva(pp1), 1, PGSIZE);
f0102d77:	83 ec 04             	sub    $0x4,%esp
f0102d7a:	68 00 10 00 00       	push   $0x1000
f0102d7f:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d81:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102d86:	50                   	push   %eax
f0102d87:	e8 2c 29 00 00       	call   f01056b8 <memset>
	return (pp - pages) << PGSHIFT;
f0102d8c:	89 f0                	mov    %esi,%eax
f0102d8e:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0102d94:	c1 f8 03             	sar    $0x3,%eax
f0102d97:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102d9a:	89 c2                	mov    %eax,%edx
f0102d9c:	c1 ea 0c             	shr    $0xc,%edx
f0102d9f:	83 c4 10             	add    $0x10,%esp
f0102da2:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0102da8:	0f 83 a9 01 00 00    	jae    f0102f57 <mem_init+0x1bc1>
    memset(page2kva(pp2), 2, PGSIZE);
f0102dae:	83 ec 04             	sub    $0x4,%esp
f0102db1:	68 00 10 00 00       	push   $0x1000
f0102db6:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102db8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102dbd:	50                   	push   %eax
f0102dbe:	e8 f5 28 00 00       	call   f01056b8 <memset>
    page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f0102dc3:	6a 02                	push   $0x2
f0102dc5:	68 00 10 00 00       	push   $0x1000
f0102dca:	57                   	push   %edi
f0102dcb:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0102dd1:	e8 95 e4 ff ff       	call   f010126b <page_insert>
    assert(pp1->pp_ref == 1);
f0102dd6:	83 c4 20             	add    $0x20,%esp
f0102dd9:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102dde:	0f 85 85 01 00 00    	jne    f0102f69 <mem_init+0x1bd3>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0102de4:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102deb:	01 01 01 
f0102dee:	0f 85 8e 01 00 00    	jne    f0102f82 <mem_init+0x1bec>
    page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0102df4:	6a 02                	push   $0x2
f0102df6:	68 00 10 00 00       	push   $0x1000
f0102dfb:	56                   	push   %esi
f0102dfc:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0102e02:	e8 64 e4 ff ff       	call   f010126b <page_insert>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0102e07:	83 c4 10             	add    $0x10,%esp
f0102e0a:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102e11:	02 02 02 
f0102e14:	0f 85 81 01 00 00    	jne    f0102f9b <mem_init+0x1c05>
    assert(pp2->pp_ref == 1);
f0102e1a:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e1f:	0f 85 8f 01 00 00    	jne    f0102fb4 <mem_init+0x1c1e>
    assert(pp1->pp_ref == 0);
f0102e25:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102e2a:	0f 85 9d 01 00 00    	jne    f0102fcd <mem_init+0x1c37>
    *(uint32_t *) PGSIZE = 0x03030303U;
f0102e30:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102e37:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102e3a:	89 f0                	mov    %esi,%eax
f0102e3c:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0102e42:	c1 f8 03             	sar    $0x3,%eax
f0102e45:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102e48:	89 c2                	mov    %eax,%edx
f0102e4a:	c1 ea 0c             	shr    $0xc,%edx
f0102e4d:	3b 15 8c 4e 23 f0    	cmp    0xf0234e8c,%edx
f0102e53:	0f 83 8d 01 00 00    	jae    f0102fe6 <mem_init+0x1c50>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0102e59:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102e60:	03 03 03 
f0102e63:	0f 85 8f 01 00 00    	jne    f0102ff8 <mem_init+0x1c62>
    page_remove(kern_pgdir, (void *) PGSIZE);
f0102e69:	83 ec 08             	sub    $0x8,%esp
f0102e6c:	68 00 10 00 00       	push   $0x1000
f0102e71:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f0102e77:	e8 ac e3 ff ff       	call   f0101228 <page_remove>
    assert(pp2->pp_ref == 0);
f0102e7c:	83 c4 10             	add    $0x10,%esp
f0102e7f:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102e84:	0f 85 87 01 00 00    	jne    f0103011 <mem_init+0x1c7b>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e8a:	8b 0d 90 4e 23 f0    	mov    0xf0234e90,%ecx
f0102e90:	8b 11                	mov    (%ecx),%edx
f0102e92:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102e98:	89 d8                	mov    %ebx,%eax
f0102e9a:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0102ea0:	c1 f8 03             	sar    $0x3,%eax
f0102ea3:	c1 e0 0c             	shl    $0xc,%eax
f0102ea6:	39 c2                	cmp    %eax,%edx
f0102ea8:	0f 85 7c 01 00 00    	jne    f010302a <mem_init+0x1c94>
    kern_pgdir[0] = 0;
f0102eae:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f0102eb4:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102eb9:	0f 85 84 01 00 00    	jne    f0103043 <mem_init+0x1cad>
    pp0->pp_ref = 0;
f0102ebf:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

    // free the pages we took
    page_free(pp0);
f0102ec5:	83 ec 0c             	sub    $0xc,%esp
f0102ec8:	53                   	push   %ebx
f0102ec9:	e8 a0 e1 ff ff       	call   f010106e <page_free>

    cprintf("check_page_installed_pgdir() succeeded!\n");
f0102ece:	c7 04 24 9c 76 10 f0 	movl   $0xf010769c,(%esp)
f0102ed5:	e8 a5 0c 00 00       	call   f0103b7f <cprintf>
}
f0102eda:	83 c4 10             	add    $0x10,%esp
f0102edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102ee0:	5b                   	pop    %ebx
f0102ee1:	5e                   	pop    %esi
f0102ee2:	5f                   	pop    %edi
f0102ee3:	5d                   	pop    %ebp
f0102ee4:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ee5:	50                   	push   %eax
f0102ee6:	68 88 63 10 f0       	push   $0xf0106388
f0102eeb:	68 0c 01 00 00       	push   $0x10c
f0102ef0:	68 36 77 10 f0       	push   $0xf0107736
f0102ef5:	e8 46 d1 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0102efa:	68 dd 78 10 f0       	push   $0xf01078dd
f0102eff:	68 21 77 10 f0       	push   $0xf0107721
f0102f04:	68 9b 04 00 00       	push   $0x49b
f0102f09:	68 36 77 10 f0       	push   $0xf0107736
f0102f0e:	e8 2d d1 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0102f13:	68 f3 78 10 f0       	push   $0xf01078f3
f0102f18:	68 21 77 10 f0       	push   $0xf0107721
f0102f1d:	68 9c 04 00 00       	push   $0x49c
f0102f22:	68 36 77 10 f0       	push   $0xf0107736
f0102f27:	e8 14 d1 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0102f2c:	68 09 79 10 f0       	push   $0xf0107909
f0102f31:	68 21 77 10 f0       	push   $0xf0107721
f0102f36:	68 9d 04 00 00       	push   $0x49d
f0102f3b:	68 36 77 10 f0       	push   $0xf0107736
f0102f40:	e8 fb d0 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f45:	50                   	push   %eax
f0102f46:	68 64 63 10 f0       	push   $0xf0106364
f0102f4b:	6a 58                	push   $0x58
f0102f4d:	68 42 77 10 f0       	push   $0xf0107742
f0102f52:	e8 e9 d0 ff ff       	call   f0100040 <_panic>
f0102f57:	50                   	push   %eax
f0102f58:	68 64 63 10 f0       	push   $0xf0106364
f0102f5d:	6a 58                	push   $0x58
f0102f5f:	68 42 77 10 f0       	push   $0xf0107742
f0102f64:	e8 d7 d0 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102f69:	68 83 79 10 f0       	push   $0xf0107983
f0102f6e:	68 21 77 10 f0       	push   $0xf0107721
f0102f73:	68 a2 04 00 00       	push   $0x4a2
f0102f78:	68 36 77 10 f0       	push   $0xf0107736
f0102f7d:	e8 be d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0102f82:	68 28 76 10 f0       	push   $0xf0107628
f0102f87:	68 21 77 10 f0       	push   $0xf0107721
f0102f8c:	68 a3 04 00 00       	push   $0x4a3
f0102f91:	68 36 77 10 f0       	push   $0xf0107736
f0102f96:	e8 a5 d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0102f9b:	68 4c 76 10 f0       	push   $0xf010764c
f0102fa0:	68 21 77 10 f0       	push   $0xf0107721
f0102fa5:	68 a5 04 00 00       	push   $0x4a5
f0102faa:	68 36 77 10 f0       	push   $0xf0107736
f0102faf:	e8 8c d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f0102fb4:	68 a5 79 10 f0       	push   $0xf01079a5
f0102fb9:	68 21 77 10 f0       	push   $0xf0107721
f0102fbe:	68 a6 04 00 00       	push   $0x4a6
f0102fc3:	68 36 77 10 f0       	push   $0xf0107736
f0102fc8:	e8 73 d0 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f0102fcd:	68 0f 7a 10 f0       	push   $0xf0107a0f
f0102fd2:	68 21 77 10 f0       	push   $0xf0107721
f0102fd7:	68 a7 04 00 00       	push   $0x4a7
f0102fdc:	68 36 77 10 f0       	push   $0xf0107736
f0102fe1:	e8 5a d0 ff ff       	call   f0100040 <_panic>
f0102fe6:	50                   	push   %eax
f0102fe7:	68 64 63 10 f0       	push   $0xf0106364
f0102fec:	6a 58                	push   $0x58
f0102fee:	68 42 77 10 f0       	push   $0xf0107742
f0102ff3:	e8 48 d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0102ff8:	68 70 76 10 f0       	push   $0xf0107670
f0102ffd:	68 21 77 10 f0       	push   $0xf0107721
f0103002:	68 a9 04 00 00       	push   $0x4a9
f0103007:	68 36 77 10 f0       	push   $0xf0107736
f010300c:	e8 2f d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0103011:	68 dd 79 10 f0       	push   $0xf01079dd
f0103016:	68 21 77 10 f0       	push   $0xf0107721
f010301b:	68 ab 04 00 00       	push   $0x4ab
f0103020:	68 36 77 10 f0       	push   $0xf0107736
f0103025:	e8 16 d0 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010302a:	68 cc 6d 10 f0       	push   $0xf0106dcc
f010302f:	68 21 77 10 f0       	push   $0xf0107721
f0103034:	68 ae 04 00 00       	push   $0x4ae
f0103039:	68 36 77 10 f0       	push   $0xf0107736
f010303e:	e8 fd cf ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f0103043:	68 94 79 10 f0       	push   $0xf0107994
f0103048:	68 21 77 10 f0       	push   $0xf0107721
f010304d:	68 b0 04 00 00       	push   $0x4b0
f0103052:	68 36 77 10 f0       	push   $0xf0107736
f0103057:	e8 e4 cf ff ff       	call   f0100040 <_panic>

f010305c <tlb_invalidate>:
tlb_invalidate(pde_t *pgdir, void *va) {
f010305c:	55                   	push   %ebp
f010305d:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010305f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103062:	0f 01 38             	invlpg (%eax)
}
f0103065:	5d                   	pop    %ebp
f0103066:	c3                   	ret    

f0103067 <mmio_map_region>:
mmio_map_region(physaddr_t pa, size_t size) {
f0103067:	55                   	push   %ebp
f0103068:	89 e5                	mov    %esp,%ebp
f010306a:	53                   	push   %ebx
f010306b:	83 ec 04             	sub    $0x4,%esp
f010306e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (base + size > MMIOLIM) {
f0103071:	8b 15 00 23 12 f0    	mov    0xf0122300,%edx
f0103077:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f010307a:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f010307f:	77 31                	ja     f01030b2 <mmio_map_region+0x4b>
    boot_map_region(kern_pgdir, base, size, pa, PTE_PCD | PTE_PWT | PTE_W);
f0103081:	83 ec 08             	sub    $0x8,%esp
f0103084:	6a 1a                	push   $0x1a
f0103086:	ff 75 08             	pushl  0x8(%ebp)
f0103089:	89 d9                	mov    %ebx,%ecx
f010308b:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0103090:	e8 ea e0 ff ff       	call   f010117f <boot_map_region>
    void *ret = (void *) base;
f0103095:	a1 00 23 12 f0       	mov    0xf0122300,%eax
    base = ROUNDUP(base + size, PGSIZE);
f010309a:	8d 94 18 ff 0f 00 00 	lea    0xfff(%eax,%ebx,1),%edx
f01030a1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01030a7:	89 15 00 23 12 f0    	mov    %edx,0xf0122300
}
f01030ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01030b0:	c9                   	leave  
f01030b1:	c3                   	ret    
        panic("this reservation overflow MMIOLIM");
f01030b2:	83 ec 04             	sub    $0x4,%esp
f01030b5:	68 c8 76 10 f0       	push   $0xf01076c8
f01030ba:	68 b6 02 00 00       	push   $0x2b6
f01030bf:	68 36 77 10 f0       	push   $0xf0107736
f01030c4:	e8 77 cf ff ff       	call   f0100040 <_panic>

f01030c9 <user_mem_check>:
user_mem_check(struct Env *env, const void *va, size_t len, int perm) {
f01030c9:	55                   	push   %ebp
f01030ca:	89 e5                	mov    %esp,%ebp
f01030cc:	57                   	push   %edi
f01030cd:	56                   	push   %esi
f01030ce:	53                   	push   %ebx
f01030cf:	83 ec 1c             	sub    $0x1c,%esp
f01030d2:	8b 75 14             	mov    0x14(%ebp),%esi
    if ((perm & PTE_U) == 0) {
f01030d5:	f7 c6 04 00 00 00    	test   $0x4,%esi
f01030db:	74 56                	je     f0103133 <user_mem_check+0x6a>
    uintptr_t begin = ROUNDDOWN((uint32_t) va, PGSIZE), end = ROUNDUP((uint32_t) va + len, PGSIZE);
f01030dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01030e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01030e6:	8b 45 10             	mov    0x10(%ebp),%eax
f01030e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01030ec:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f01030f3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (end > ULIM) {
f01030f9:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f01030ff:	77 41                	ja     f0103142 <user_mem_check+0x79>
        if ((pte == NULL) || ((*pte & (perm | PTE_P)) != (perm | PTE_P))) {
f0103101:	83 ce 01             	or     $0x1,%esi
    for (int i = begin; i < end; i += PGSIZE) {
f0103104:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0103107:	39 fb                	cmp    %edi,%ebx
f0103109:	73 60                	jae    f010316b <user_mem_check+0xa2>
        pte_t *pte = pgdir_walk(env->env_pgdir, (const void *) i, 0);
f010310b:	83 ec 04             	sub    $0x4,%esp
f010310e:	6a 00                	push   $0x0
f0103110:	53                   	push   %ebx
f0103111:	8b 45 08             	mov    0x8(%ebp),%eax
f0103114:	ff 70 60             	pushl  0x60(%eax)
f0103117:	e8 d1 df ff ff       	call   f01010ed <pgdir_walk>
        if ((pte == NULL) || ((*pte & (perm | PTE_P)) != (perm | PTE_P))) {
f010311c:	83 c4 10             	add    $0x10,%esp
f010311f:	85 c0                	test   %eax,%eax
f0103121:	74 2c                	je     f010314f <user_mem_check+0x86>
f0103123:	89 f2                	mov    %esi,%edx
f0103125:	23 10                	and    (%eax),%edx
f0103127:	39 d6                	cmp    %edx,%esi
f0103129:	75 24                	jne    f010314f <user_mem_check+0x86>
    for (int i = begin; i < end; i += PGSIZE) {
f010312b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103131:	eb d1                	jmp    f0103104 <user_mem_check+0x3b>
        user_mem_check_addr = (uintptr_t) va;
f0103133:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103136:	a3 3c 42 23 f0       	mov    %eax,0xf023423c
        return -E_FAULT;
f010313b:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103140:	eb 21                	jmp    f0103163 <user_mem_check+0x9a>
        user_mem_check_addr = (uintptr_t) va;
f0103142:	89 0d 3c 42 23 f0    	mov    %ecx,0xf023423c
        return -E_FAULT;
f0103148:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010314d:	eb 14                	jmp    f0103163 <user_mem_check+0x9a>
            user_mem_check_addr = i < (uint32_t) va ? (uint32_t) va : i;
f010314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103152:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0103155:	0f 42 45 0c          	cmovb  0xc(%ebp),%eax
f0103159:	a3 3c 42 23 f0       	mov    %eax,0xf023423c
            return -E_FAULT;
f010315e:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0103163:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103166:	5b                   	pop    %ebx
f0103167:	5e                   	pop    %esi
f0103168:	5f                   	pop    %edi
f0103169:	5d                   	pop    %ebp
f010316a:	c3                   	ret    
    return 0;
f010316b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103170:	eb f1                	jmp    f0103163 <user_mem_check+0x9a>

f0103172 <user_mem_assert>:
user_mem_assert(struct Env *env, const void *va, size_t len, int perm) {
f0103172:	55                   	push   %ebp
f0103173:	89 e5                	mov    %esp,%ebp
f0103175:	53                   	push   %ebx
f0103176:	83 ec 04             	sub    $0x4,%esp
f0103179:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f010317c:	8b 45 14             	mov    0x14(%ebp),%eax
f010317f:	83 c8 04             	or     $0x4,%eax
f0103182:	50                   	push   %eax
f0103183:	ff 75 10             	pushl  0x10(%ebp)
f0103186:	ff 75 0c             	pushl  0xc(%ebp)
f0103189:	53                   	push   %ebx
f010318a:	e8 3a ff ff ff       	call   f01030c9 <user_mem_check>
f010318f:	83 c4 10             	add    $0x10,%esp
f0103192:	85 c0                	test   %eax,%eax
f0103194:	78 05                	js     f010319b <user_mem_assert+0x29>
}
f0103196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103199:	c9                   	leave  
f010319a:	c3                   	ret    
        cprintf("[%08x] user_mem_check assertion failure for "
f010319b:	83 ec 04             	sub    $0x4,%esp
f010319e:	ff 35 3c 42 23 f0    	pushl  0xf023423c
f01031a4:	ff 73 48             	pushl  0x48(%ebx)
f01031a7:	68 ec 76 10 f0       	push   $0xf01076ec
f01031ac:	e8 ce 09 00 00       	call   f0103b7f <cprintf>
        env_destroy(env);    // may not return
f01031b1:	89 1c 24             	mov    %ebx,(%esp)
f01031b4:	e8 1b 07 00 00       	call   f01038d4 <env_destroy>
f01031b9:	83 c4 10             	add    $0x10,%esp
}
f01031bc:	eb d8                	jmp    f0103196 <user_mem_assert+0x24>

f01031be <region_alloc>:
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len) {
f01031be:	55                   	push   %ebp
f01031bf:	89 e5                	mov    %esp,%ebp
f01031c1:	57                   	push   %edi
f01031c2:	56                   	push   %esi
f01031c3:	53                   	push   %ebx
f01031c4:	83 ec 1c             	sub    $0x1c,%esp
    //
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
    pde_t *pgdir = e->env_pgdir;
f01031c7:	8b 40 60             	mov    0x60(%eax),%eax
f01031ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    uintptr_t begin = ROUNDDOWN((uintptr_t) va, PGSIZE), end = ROUNDUP((uintptr_t) va + len, PGSIZE);
f01031cd:	89 d6                	mov    %edx,%esi
f01031cf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01031d5:	8d bc 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%edi
f01031dc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    for (; begin < end; begin += PGSIZE) {
f01031e2:	eb 3d                	jmp    f0103221 <region_alloc+0x63>
//        if (!page_lookup(pgdir, (void *) begin, NULL)) {
            //alloc_flag ??? why false??? sb fz
//            page_insert(pgdir, page_alloc(false), (void *) begin, PTE_U | PTE_W);
        struct PageInfo *pp;
        page_insert(pgdir, pp = page_alloc(ALLOC_ZERO), (void *) begin, PTE_U | PTE_W);
f01031e4:	83 ec 0c             	sub    $0xc,%esp
f01031e7:	6a 01                	push   $0x1
f01031e9:	e8 08 de ff ff       	call   f0100ff6 <page_alloc>
f01031ee:	89 c3                	mov    %eax,%ebx
f01031f0:	6a 06                	push   $0x6
f01031f2:	56                   	push   %esi
f01031f3:	50                   	push   %eax
f01031f4:	ff 75 e4             	pushl  -0x1c(%ebp)
f01031f7:	e8 6f e0 ff ff       	call   f010126b <page_insert>
        cprintf("begin:0x%x\tend:0x%x\tpp(physical addr number):0x%x\n", begin, end, page2pa(pp));
f01031fc:	83 c4 20             	add    $0x20,%esp
	return (pp - pages) << PGSHIFT;
f01031ff:	2b 1d 94 4e 23 f0    	sub    0xf0234e94,%ebx
f0103205:	c1 fb 03             	sar    $0x3,%ebx
f0103208:	c1 e3 0c             	shl    $0xc,%ebx
f010320b:	53                   	push   %ebx
f010320c:	57                   	push   %edi
f010320d:	56                   	push   %esi
f010320e:	68 b0 7a 10 f0       	push   $0xf0107ab0
f0103213:	e8 67 09 00 00       	call   f0103b7f <cprintf>
    for (; begin < end; begin += PGSIZE) {
f0103218:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010321e:	83 c4 10             	add    $0x10,%esp
f0103221:	39 fe                	cmp    %edi,%esi
f0103223:	72 bf                	jb     f01031e4 <region_alloc+0x26>
//        }
    }
}
f0103225:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103228:	5b                   	pop    %ebx
f0103229:	5e                   	pop    %esi
f010322a:	5f                   	pop    %edi
f010322b:	5d                   	pop    %ebp
f010322c:	c3                   	ret    

f010322d <envid2env>:
envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
f010322d:	55                   	push   %ebp
f010322e:	89 e5                	mov    %esp,%ebp
f0103230:	56                   	push   %esi
f0103231:	53                   	push   %ebx
f0103232:	8b 45 08             	mov    0x8(%ebp),%eax
f0103235:	8b 55 10             	mov    0x10(%ebp),%edx
    if (envid == 0) {
f0103238:	85 c0                	test   %eax,%eax
f010323a:	74 2e                	je     f010326a <envid2env+0x3d>
    e = &envs[ENVX(envid)];
f010323c:	89 c3                	mov    %eax,%ebx
f010323e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103244:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103247:	03 1d 4c 42 23 f0    	add    0xf023424c,%ebx
    if (e->env_status == ENV_FREE || e->env_id != envid) {
f010324d:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103251:	74 31                	je     f0103284 <envid2env+0x57>
f0103253:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103256:	75 2c                	jne    f0103284 <envid2env+0x57>
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103258:	84 d2                	test   %dl,%dl
f010325a:	75 38                	jne    f0103294 <envid2env+0x67>
    *env_store = e;
f010325c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010325f:	89 18                	mov    %ebx,(%eax)
    return 0;
f0103261:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103266:	5b                   	pop    %ebx
f0103267:	5e                   	pop    %esi
f0103268:	5d                   	pop    %ebp
f0103269:	c3                   	ret    
        *env_store = curenv;
f010326a:	e8 6c 2a 00 00       	call   f0105cdb <cpunum>
f010326f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103272:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0103278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010327b:	89 01                	mov    %eax,(%ecx)
        return 0;
f010327d:	b8 00 00 00 00       	mov    $0x0,%eax
f0103282:	eb e2                	jmp    f0103266 <envid2env+0x39>
        *env_store = 0;
f0103284:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f010328d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103292:	eb d2                	jmp    f0103266 <envid2env+0x39>
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103294:	e8 42 2a 00 00       	call   f0105cdb <cpunum>
f0103299:	6b c0 74             	imul   $0x74,%eax,%eax
f010329c:	39 98 28 50 23 f0    	cmp    %ebx,-0xfdcafd8(%eax)
f01032a2:	74 b8                	je     f010325c <envid2env+0x2f>
f01032a4:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01032a7:	e8 2f 2a 00 00       	call   f0105cdb <cpunum>
f01032ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01032af:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01032b5:	3b 70 48             	cmp    0x48(%eax),%esi
f01032b8:	74 a2                	je     f010325c <envid2env+0x2f>
        *env_store = 0;
f01032ba:	8b 45 0c             	mov    0xc(%ebp),%eax
f01032bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f01032c3:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01032c8:	eb 9c                	jmp    f0103266 <envid2env+0x39>

f01032ca <env_init_percpu>:
env_init_percpu(void) {
f01032ca:	55                   	push   %ebp
f01032cb:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f01032cd:	b8 20 23 12 f0       	mov    $0xf0122320,%eax
f01032d2:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax,%%gs" : : "a" (GD_UD | 3));
f01032d5:	b8 23 00 00 00       	mov    $0x23,%eax
f01032da:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax,%%fs" : : "a" (GD_UD | 3));
f01032dc:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01032de:	b8 10 00 00 00       	mov    $0x10,%eax
f01032e3:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01032e5:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01032e7:	8e d0                	mov    %eax,%ss
    asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01032e9:	ea f0 32 10 f0 08 00 	ljmp   $0x8,$0xf01032f0
	asm volatile("lldt %0" : : "r" (sel));
f01032f0:	b8 00 00 00 00       	mov    $0x0,%eax
f01032f5:	0f 00 d0             	lldt   %ax
}
f01032f8:	5d                   	pop    %ebp
f01032f9:	c3                   	ret    

f01032fa <env_init>:
env_init(void) {
f01032fa:	55                   	push   %ebp
f01032fb:	89 e5                	mov    %esp,%ebp
f01032fd:	56                   	push   %esi
f01032fe:	53                   	push   %ebx
        envs[i].env_link = env_free_list;
f01032ff:	8b 35 4c 42 23 f0    	mov    0xf023424c,%esi
f0103305:	8b 15 50 42 23 f0    	mov    0xf0234250,%edx
f010330b:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f0103311:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f0103314:	89 c1                	mov    %eax,%ecx
f0103316:	89 50 44             	mov    %edx,0x44(%eax)
f0103319:	83 e8 7c             	sub    $0x7c,%eax
        env_free_list = &envs[i];
f010331c:	89 ca                	mov    %ecx,%edx
    for (i = NENV - 1; i >= 0; i--) {
f010331e:	39 d8                	cmp    %ebx,%eax
f0103320:	75 f2                	jne    f0103314 <env_init+0x1a>
f0103322:	89 35 50 42 23 f0    	mov    %esi,0xf0234250
    env_init_percpu();
f0103328:	e8 9d ff ff ff       	call   f01032ca <env_init_percpu>
}
f010332d:	5b                   	pop    %ebx
f010332e:	5e                   	pop    %esi
f010332f:	5d                   	pop    %ebp
f0103330:	c3                   	ret    

f0103331 <env_alloc>:
env_alloc(struct Env **newenv_store, envid_t parent_id) {
f0103331:	55                   	push   %ebp
f0103332:	89 e5                	mov    %esp,%ebp
f0103334:	53                   	push   %ebx
f0103335:	83 ec 10             	sub    $0x10,%esp
    cprintf("************* Now we alloc a env. **************\n");
f0103338:	68 e4 7a 10 f0       	push   $0xf0107ae4
f010333d:	e8 3d 08 00 00       	call   f0103b7f <cprintf>
    if (!(e = env_free_list))
f0103342:	8b 1d 50 42 23 f0    	mov    0xf0234250,%ebx
f0103348:	83 c4 10             	add    $0x10,%esp
f010334b:	85 db                	test   %ebx,%ebx
f010334d:	0f 84 d2 01 00 00    	je     f0103525 <env_alloc+0x1f4>
    cprintf("************* Now we set up a env's vm. **************\n");
f0103353:	83 ec 0c             	sub    $0xc,%esp
f0103356:	68 18 7b 10 f0       	push   $0xf0107b18
f010335b:	e8 1f 08 00 00       	call   f0103b7f <cprintf>
    if (!(p = page_alloc(ALLOC_ZERO)))
f0103360:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103367:	e8 8a dc ff ff       	call   f0100ff6 <page_alloc>
f010336c:	83 c4 10             	add    $0x10,%esp
f010336f:	85 c0                	test   %eax,%eax
f0103371:	0f 84 b5 01 00 00    	je     f010352c <env_alloc+0x1fb>
f0103377:	89 c2                	mov    %eax,%edx
f0103379:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f010337f:	c1 fa 03             	sar    $0x3,%edx
f0103382:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0103385:	89 d1                	mov    %edx,%ecx
f0103387:	c1 e9 0c             	shr    $0xc,%ecx
f010338a:	3b 0d 8c 4e 23 f0    	cmp    0xf0234e8c,%ecx
f0103390:	0f 83 68 01 00 00    	jae    f01034fe <env_alloc+0x1cd>
	return (void *)(pa + KERNBASE);
f0103396:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010339c:	89 53 60             	mov    %edx,0x60(%ebx)
    p->pp_ref++;
f010339f:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    cprintf("UTOP:0x%x\te->env_pgdor:0x%x\tsizeof(pde_t):%d\n", UTOP, e->env_pgdir, sizeof(pde_t));
f01033a4:	6a 04                	push   $0x4
f01033a6:	ff 73 60             	pushl  0x60(%ebx)
f01033a9:	68 00 00 c0 ee       	push   $0xeec00000
f01033ae:	68 50 7b 10 f0       	push   $0xf0107b50
f01033b3:	e8 c7 07 00 00       	call   f0103b7f <cprintf>
    cprintf("UTOP:0x%x\tutop_off:0x%x\te->env_pgdir + utop_off:0x%x\tkern_pgdir + utop_off:%x\tsizeof(pde_t) * (NPDENTRIES - utop_off)):%d\n",
f01033b8:	83 c4 08             	add    $0x8,%esp
f01033bb:	68 14 01 00 00       	push   $0x114
f01033c0:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f01033c5:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033ca:	50                   	push   %eax
f01033cb:	8b 43 60             	mov    0x60(%ebx),%eax
f01033ce:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033d3:	50                   	push   %eax
f01033d4:	68 bb 03 00 00       	push   $0x3bb
f01033d9:	68 00 00 c0 ee       	push   $0xeec00000
f01033de:	68 80 7b 10 f0       	push   $0xf0107b80
f01033e3:	e8 97 07 00 00       	call   f0103b7f <cprintf>
    memcpy(e->env_pgdir + utop_off, kern_pgdir + utop_off, sizeof(pde_t) * (NPDENTRIES - utop_off));
f01033e8:	83 c4 1c             	add    $0x1c,%esp
f01033eb:	68 14 01 00 00       	push   $0x114
f01033f0:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f01033f5:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033fa:	50                   	push   %eax
f01033fb:	8b 43 60             	mov    0x60(%ebx),%eax
f01033fe:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103403:	50                   	push   %eax
f0103404:	e8 64 23 00 00       	call   f010576d <memcpy>
    e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103409:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010340c:	83 c4 10             	add    $0x10,%esp
f010340f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103414:	0f 86 f6 00 00 00    	jbe    f0103510 <env_alloc+0x1df>
	return (physaddr_t)kva - KERNBASE;
f010341a:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103420:	83 ca 05             	or     $0x5,%edx
f0103423:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
    cprintf("************* Now we successfully set up a env's vm. **************\n");
f0103429:	83 ec 0c             	sub    $0xc,%esp
f010342c:	68 fc 7b 10 f0       	push   $0xf0107bfc
f0103431:	e8 49 07 00 00       	call   f0103b7f <cprintf>
    generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103436:	8b 43 48             	mov    0x48(%ebx),%eax
f0103439:	05 00 10 00 00       	add    $0x1000,%eax
    if (generation <= 0)    // Don't create a negative env_id.
f010343e:	83 c4 0c             	add    $0xc,%esp
f0103441:	25 00 fc ff ff       	and    $0xfffffc00,%eax
        generation = 1 << ENVGENSHIFT;
f0103446:	ba 00 10 00 00       	mov    $0x1000,%edx
f010344b:	0f 4e c2             	cmovle %edx,%eax
    e->env_id = generation | (e - envs);
f010344e:	89 da                	mov    %ebx,%edx
f0103450:	2b 15 4c 42 23 f0    	sub    0xf023424c,%edx
f0103456:	c1 fa 02             	sar    $0x2,%edx
f0103459:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f010345f:	09 d0                	or     %edx,%eax
f0103461:	89 43 48             	mov    %eax,0x48(%ebx)
    e->env_parent_id = parent_id;
f0103464:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103467:	89 43 4c             	mov    %eax,0x4c(%ebx)
    e->env_type = ENV_TYPE_USER;
f010346a:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
    e->env_status = ENV_RUNNABLE;
f0103471:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
    e->env_runs = 0;
f0103478:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    memset(&e->env_tf, 0, sizeof(e->env_tf));
f010347f:	6a 44                	push   $0x44
f0103481:	6a 00                	push   $0x0
f0103483:	53                   	push   %ebx
f0103484:	e8 2f 22 00 00       	call   f01056b8 <memset>
    e->env_tf.tf_ds = GD_UD | 3;
f0103489:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
    e->env_tf.tf_es = GD_UD | 3;
f010348f:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
    e->env_tf.tf_ss = GD_UD | 3;
f0103495:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
    e->env_tf.tf_esp = USTACKTOP;
f010349b:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
    e->env_tf.tf_cs = GD_UT | 3;
f01034a2:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
    env_free_list = e->env_link;
f01034a8:	8b 43 44             	mov    0x44(%ebx),%eax
f01034ab:	a3 50 42 23 f0       	mov    %eax,0xf0234250
    *newenv_store = e;
f01034b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01034b3:	89 18                	mov    %ebx,(%eax)
    cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01034b5:	8b 5b 48             	mov    0x48(%ebx),%ebx
f01034b8:	e8 1e 28 00 00       	call   f0105cdb <cpunum>
f01034bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01034c0:	83 c4 10             	add    $0x10,%esp
f01034c3:	ba 00 00 00 00       	mov    $0x0,%edx
f01034c8:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f01034cf:	74 11                	je     f01034e2 <env_alloc+0x1b1>
f01034d1:	e8 05 28 00 00       	call   f0105cdb <cpunum>
f01034d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01034d9:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01034df:	8b 50 48             	mov    0x48(%eax),%edx
f01034e2:	83 ec 04             	sub    $0x4,%esp
f01034e5:	53                   	push   %ebx
f01034e6:	52                   	push   %edx
f01034e7:	68 7a 7e 10 f0       	push   $0xf0107e7a
f01034ec:	e8 8e 06 00 00       	call   f0103b7f <cprintf>
    return 0;
f01034f1:	83 c4 10             	add    $0x10,%esp
f01034f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01034f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01034fc:	c9                   	leave  
f01034fd:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01034fe:	52                   	push   %edx
f01034ff:	68 64 63 10 f0       	push   $0xf0106364
f0103504:	6a 58                	push   $0x58
f0103506:	68 42 77 10 f0       	push   $0xf0107742
f010350b:	e8 30 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103510:	50                   	push   %eax
f0103511:	68 88 63 10 f0       	push   $0xf0106388
f0103516:	68 cd 00 00 00       	push   $0xcd
f010351b:	68 6f 7e 10 f0       	push   $0xf0107e6f
f0103520:	e8 1b cb ff ff       	call   f0100040 <_panic>
        return -E_NO_FREE_ENV;
f0103525:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f010352a:	eb cd                	jmp    f01034f9 <env_alloc+0x1c8>
        return -E_NO_MEM;
f010352c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103531:	eb c6                	jmp    f01034f9 <env_alloc+0x1c8>

f0103533 <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type) {
f0103533:	55                   	push   %ebp
f0103534:	89 e5                	mov    %esp,%ebp
f0103536:	57                   	push   %edi
f0103537:	56                   	push   %esi
f0103538:	53                   	push   %ebx
f0103539:	83 ec 38             	sub    $0x38,%esp
f010353c:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("************* Now we create a env. **************\n");
f010353f:	68 44 7c 10 f0       	push   $0xf0107c44
f0103544:	e8 36 06 00 00       	call   f0103b7f <cprintf>
    // LAB 3: Your code here.
    struct Env *Env = NULL;
f0103549:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    switch (env_alloc(&Env, 0)) {
f0103550:	83 c4 08             	add    $0x8,%esp
f0103553:	6a 00                	push   $0x0
f0103555:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103558:	50                   	push   %eax
f0103559:	e8 d3 fd ff ff       	call   f0103331 <env_alloc>
        default:
            //todo
            break;
    };

    load_icode(Env, binary);
f010355e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103561:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cprintf("************* Now we load_icode about a env e. **************\n");
f0103564:	c7 04 24 78 7c 10 f0 	movl   $0xf0107c78,(%esp)
f010356b:	e8 0f 06 00 00       	call   f0103b7f <cprintf>
    cprintf("************* Now we load each program segment. **************\n");
f0103570:	c7 04 24 b8 7c 10 f0 	movl   $0xf0107cb8,(%esp)
f0103577:	e8 03 06 00 00       	call   f0103b7f <cprintf>
    ph = (struct Proghdr *) (binary + elfHdr->e_phoff);
f010357c:	89 f3                	mov    %esi,%ebx
f010357e:	03 5e 1c             	add    0x1c(%esi),%ebx
    eph = ph + elfHdr->e_phnum;
f0103581:	0f b7 7e 2c          	movzwl 0x2c(%esi),%edi
f0103585:	c1 e7 05             	shl    $0x5,%edi
f0103588:	01 df                	add    %ebx,%edi
f010358a:	83 c4 10             	add    $0x10,%esp
f010358d:	eb 03                	jmp    f0103592 <env_create+0x5f>
    for (; ph < eph; ph++) {
f010358f:	83 c3 20             	add    $0x20,%ebx
f0103592:	39 df                	cmp    %ebx,%edi
f0103594:	76 3c                	jbe    f01035d2 <env_create+0x9f>
        if (ph->p_type == ELF_PROG_LOAD) {
f0103596:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103599:	75 f4                	jne    f010358f <env_create+0x5c>
            cprintf("ph->p_type:%x\t ph->p_offset:0x%x\t ph->p_va:0x%x\t ph->p_pa:0x%x\t ph->p_filesz:0x%x\t ph->p_memsz:0x%x\t ph->p_flags:%x\t ph->p_align:0x%x\t\n",
f010359b:	83 ec 0c             	sub    $0xc,%esp
f010359e:	ff 73 1c             	pushl  0x1c(%ebx)
f01035a1:	ff 73 18             	pushl  0x18(%ebx)
f01035a4:	ff 73 14             	pushl  0x14(%ebx)
f01035a7:	ff 73 10             	pushl  0x10(%ebx)
f01035aa:	ff 73 0c             	pushl  0xc(%ebx)
f01035ad:	ff 73 08             	pushl  0x8(%ebx)
f01035b0:	ff 73 04             	pushl  0x4(%ebx)
f01035b3:	6a 01                	push   $0x1
f01035b5:	68 f8 7c 10 f0       	push   $0xf0107cf8
f01035ba:	e8 c0 05 00 00       	call   f0103b7f <cprintf>
            region_alloc(e, (void *) ph->p_va, ph->p_memsz);
f01035bf:	83 c4 30             	add    $0x30,%esp
f01035c2:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01035c5:	8b 53 08             	mov    0x8(%ebx),%edx
f01035c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035cb:	e8 ee fb ff ff       	call   f01031be <region_alloc>
f01035d0:	eb bd                	jmp    f010358f <env_create+0x5c>
    cprintf("************* Now we copy each section which should load. **************\n");
f01035d2:	83 ec 0c             	sub    $0xc,%esp
f01035d5:	68 80 7d 10 f0       	push   $0xf0107d80
f01035da:	e8 a0 05 00 00       	call   f0103b7f <cprintf>
    struct Secthdr *sectHdr = (struct Secthdr *) (binary + elfHdr->e_shoff);
f01035df:	89 f3                	mov    %esi,%ebx
f01035e1:	03 5e 20             	add    0x20(%esi),%ebx
	asm volatile("movl %%cr3,%0" : "=r" (val));
f01035e4:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f01035e7:	83 c4 08             	add    $0x8,%esp
f01035ea:	50                   	push   %eax
f01035eb:	68 8f 7e 10 f0       	push   $0xf0107e8f
f01035f0:	e8 8a 05 00 00       	call   f0103b7f <cprintf>
    lcr3(PADDR(e->env_pgdir));
f01035f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035f8:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035fb:	83 c4 10             	add    $0x10,%esp
f01035fe:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103603:	76 23                	jbe    f0103628 <env_create+0xf5>
	return (physaddr_t)kva - KERNBASE;
f0103605:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010360a:	0f 22 d8             	mov    %eax,%cr3
	asm volatile("movl %%cr3,%0" : "=r" (val));
f010360d:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f0103610:	83 ec 08             	sub    $0x8,%esp
f0103613:	50                   	push   %eax
f0103614:	68 8f 7e 10 f0       	push   $0xf0107e8f
f0103619:	e8 61 05 00 00       	call   f0103b7f <cprintf>
f010361e:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f0103621:	bf 00 00 00 00       	mov    $0x0,%edi
f0103626:	eb 43                	jmp    f010366b <env_create+0x138>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103628:	50                   	push   %eax
f0103629:	68 88 63 10 f0       	push   $0xf0106388
f010362e:	68 8b 01 00 00       	push   $0x18b
f0103633:	68 6f 7e 10 f0       	push   $0xf0107e6f
f0103638:	e8 03 ca ff ff       	call   f0100040 <_panic>
            cprintf("(void *) sectHdr->sh_addr:0x%x\tsectHdr->sh_offset:0x%x\tsectHdr->sh_size:0x%x\n", sectHdr->sh_addr, sectHdr->sh_offset, sectHdr->sh_size);
f010363d:	ff 73 14             	pushl  0x14(%ebx)
f0103640:	ff 73 10             	pushl  0x10(%ebx)
f0103643:	50                   	push   %eax
f0103644:	68 cc 7d 10 f0       	push   $0xf0107dcc
f0103649:	e8 31 05 00 00       	call   f0103b7f <cprintf>
            memcpy((void *) sectHdr->sh_addr, binary + sectHdr->sh_offset, sectHdr->sh_size);
f010364e:	83 c4 0c             	add    $0xc,%esp
f0103651:	ff 73 14             	pushl  0x14(%ebx)
f0103654:	89 f0                	mov    %esi,%eax
f0103656:	03 43 10             	add    0x10(%ebx),%eax
f0103659:	50                   	push   %eax
f010365a:	ff 73 0c             	pushl  0xc(%ebx)
f010365d:	e8 0b 21 00 00       	call   f010576d <memcpy>
f0103662:	83 c4 10             	add    $0x10,%esp
        sectHdr++;
f0103665:	83 c3 28             	add    $0x28,%ebx
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f0103668:	83 c7 01             	add    $0x1,%edi
f010366b:	0f b7 46 30          	movzwl 0x30(%esi),%eax
f010366f:	39 c7                	cmp    %eax,%edi
f0103671:	7d 0f                	jge    f0103682 <env_create+0x14f>
        if (sectHdr->sh_addr != 0 && sectHdr->sh_type != ELF_SHT_NOBITS) {
f0103673:	8b 43 0c             	mov    0xc(%ebx),%eax
f0103676:	85 c0                	test   %eax,%eax
f0103678:	74 eb                	je     f0103665 <env_create+0x132>
f010367a:	83 7b 04 08          	cmpl   $0x8,0x4(%ebx)
f010367e:	74 e5                	je     f0103665 <env_create+0x132>
f0103680:	eb bb                	jmp    f010363d <env_create+0x10a>
    lcr3(PADDR(kern_pgdir));
f0103682:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0103687:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010368c:	76 43                	jbe    f01036d1 <env_create+0x19e>
	return (physaddr_t)kva - KERNBASE;
f010368e:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103693:	0f 22 d8             	mov    %eax,%cr3
    cprintf("************* Now we map one page for the program's initial stack. **************\n");
f0103696:	83 ec 0c             	sub    $0xc,%esp
f0103699:	68 1c 7e 10 f0       	push   $0xf0107e1c
f010369e:	e8 dc 04 00 00       	call   f0103b7f <cprintf>
    region_alloc(e, (void *) USTACKTOP - PGSIZE, PGSIZE);
f01036a3:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01036a8:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01036ad:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01036b0:	89 f8                	mov    %edi,%eax
f01036b2:	e8 07 fb ff ff       	call   f01031be <region_alloc>
    e->env_tf.tf_eip = elfHdr->e_entry;
f01036b7:	8b 46 18             	mov    0x18(%esi),%eax
f01036ba:	89 47 30             	mov    %eax,0x30(%edi)

    Env->env_type = type;
f01036bd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01036c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01036c3:	89 50 50             	mov    %edx,0x50(%eax)
}
f01036c6:	83 c4 10             	add    $0x10,%esp
f01036c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01036cc:	5b                   	pop    %ebx
f01036cd:	5e                   	pop    %esi
f01036ce:	5f                   	pop    %edi
f01036cf:	5d                   	pop    %ebp
f01036d0:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036d1:	50                   	push   %eax
f01036d2:	68 88 63 10 f0       	push   $0xf0106388
f01036d7:	68 95 01 00 00       	push   $0x195
f01036dc:	68 6f 7e 10 f0       	push   $0xf0107e6f
f01036e1:	e8 5a c9 ff ff       	call   f0100040 <_panic>

f01036e6 <env_free>:

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
f01036e6:	55                   	push   %ebp
f01036e7:	89 e5                	mov    %esp,%ebp
f01036e9:	57                   	push   %edi
f01036ea:	56                   	push   %esi
f01036eb:	53                   	push   %ebx
f01036ec:	83 ec 1c             	sub    $0x1c,%esp
    physaddr_t pa;

    // If freeing the current environment, switch to kern_pgdir
    // before freeing the page directory, just in case the page
    // gets reused.
    if (e == curenv)
f01036ef:	e8 e7 25 00 00       	call   f0105cdb <cpunum>
f01036f4:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f7:	8b 55 08             	mov    0x8(%ebp),%edx
f01036fa:	39 90 28 50 23 f0    	cmp    %edx,-0xfdcafd8(%eax)
f0103700:	75 14                	jne    f0103716 <env_free+0x30>
        lcr3(PADDR(kern_pgdir));
f0103702:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0103707:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010370c:	76 56                	jbe    f0103764 <env_free+0x7e>
	return (physaddr_t)kva - KERNBASE;
f010370e:	05 00 00 00 10       	add    $0x10000000,%eax
f0103713:	0f 22 d8             	mov    %eax,%cr3

    // Note the environment's demise.
    cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103716:	8b 45 08             	mov    0x8(%ebp),%eax
f0103719:	8b 58 48             	mov    0x48(%eax),%ebx
f010371c:	e8 ba 25 00 00       	call   f0105cdb <cpunum>
f0103721:	6b c0 74             	imul   $0x74,%eax,%eax
f0103724:	ba 00 00 00 00       	mov    $0x0,%edx
f0103729:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0103730:	74 11                	je     f0103743 <env_free+0x5d>
f0103732:	e8 a4 25 00 00       	call   f0105cdb <cpunum>
f0103737:	6b c0 74             	imul   $0x74,%eax,%eax
f010373a:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0103740:	8b 50 48             	mov    0x48(%eax),%edx
f0103743:	83 ec 04             	sub    $0x4,%esp
f0103746:	53                   	push   %ebx
f0103747:	52                   	push   %edx
f0103748:	68 9c 7e 10 f0       	push   $0xf0107e9c
f010374d:	e8 2d 04 00 00       	call   f0103b7f <cprintf>
f0103752:	83 c4 10             	add    $0x10,%esp
f0103755:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f010375c:	8b 7d 08             	mov    0x8(%ebp),%edi
f010375f:	e9 8f 00 00 00       	jmp    f01037f3 <env_free+0x10d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103764:	50                   	push   %eax
f0103765:	68 88 63 10 f0       	push   $0xf0106388
f010376a:	68 cd 01 00 00       	push   $0x1cd
f010376f:	68 6f 7e 10 f0       	push   $0xf0107e6f
f0103774:	e8 c7 c8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103779:	50                   	push   %eax
f010377a:	68 64 63 10 f0       	push   $0xf0106364
f010377f:	68 dc 01 00 00       	push   $0x1dc
f0103784:	68 6f 7e 10 f0       	push   $0xf0107e6f
f0103789:	e8 b2 c8 ff ff       	call   f0100040 <_panic>
f010378e:	83 c3 04             	add    $0x4,%ebx
        // find the pa and va of the page table
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
        pt = (pte_t *) KADDR(pa);

        // unmap all PTEs in this page table
        for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103791:	39 f3                	cmp    %esi,%ebx
f0103793:	74 21                	je     f01037b6 <env_free+0xd0>
            if (pt[pteno] & PTE_P)
f0103795:	f6 03 01             	testb  $0x1,(%ebx)
f0103798:	74 f4                	je     f010378e <env_free+0xa8>
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010379a:	83 ec 08             	sub    $0x8,%esp
f010379d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01037a0:	01 d8                	add    %ebx,%eax
f01037a2:	c1 e0 0a             	shl    $0xa,%eax
f01037a5:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01037a8:	50                   	push   %eax
f01037a9:	ff 77 60             	pushl  0x60(%edi)
f01037ac:	e8 77 da ff ff       	call   f0101228 <page_remove>
f01037b1:	83 c4 10             	add    $0x10,%esp
f01037b4:	eb d8                	jmp    f010378e <env_free+0xa8>
        }

        // free the page table itself
        e->env_pgdir[pdeno] = 0;
f01037b6:	8b 47 60             	mov    0x60(%edi),%eax
f01037b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037bc:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01037c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01037c6:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f01037cc:	73 6a                	jae    f0103838 <env_free+0x152>
        page_decref(pa2page(pa));
f01037ce:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01037d1:	a1 94 4e 23 f0       	mov    0xf0234e94,%eax
f01037d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01037d9:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f01037dc:	50                   	push   %eax
f01037dd:	e8 e2 d8 ff ff       	call   f01010c4 <page_decref>
f01037e2:	83 c4 10             	add    $0x10,%esp
f01037e5:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f01037e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01037ec:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01037f1:	74 59                	je     f010384c <env_free+0x166>
        if (!(e->env_pgdir[pdeno] & PTE_P))
f01037f3:	8b 47 60             	mov    0x60(%edi),%eax
f01037f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037f9:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01037fc:	a8 01                	test   $0x1,%al
f01037fe:	74 e5                	je     f01037e5 <env_free+0xff>
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103800:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0103805:	89 c2                	mov    %eax,%edx
f0103807:	c1 ea 0c             	shr    $0xc,%edx
f010380a:	89 55 d8             	mov    %edx,-0x28(%ebp)
f010380d:	39 15 8c 4e 23 f0    	cmp    %edx,0xf0234e8c
f0103813:	0f 86 60 ff ff ff    	jbe    f0103779 <env_free+0x93>
	return (void *)(pa + KERNBASE);
f0103819:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010381f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103822:	c1 e2 14             	shl    $0x14,%edx
f0103825:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103828:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f010382e:	f7 d8                	neg    %eax
f0103830:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103833:	e9 5d ff ff ff       	jmp    f0103795 <env_free+0xaf>
		panic("pa2page called with invalid pa");
f0103838:	83 ec 04             	sub    $0x4,%esp
f010383b:	68 f0 6a 10 f0       	push   $0xf0106af0
f0103840:	6a 51                	push   $0x51
f0103842:	68 42 77 10 f0       	push   $0xf0107742
f0103847:	e8 f4 c7 ff ff       	call   f0100040 <_panic>
    }

    // free the page directory
    pa = PADDR(e->env_pgdir);
f010384c:	8b 45 08             	mov    0x8(%ebp),%eax
f010384f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103852:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103857:	76 52                	jbe    f01038ab <env_free+0x1c5>
    e->env_pgdir = 0;
f0103859:	8b 55 08             	mov    0x8(%ebp),%edx
f010385c:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f0103863:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103868:	c1 e8 0c             	shr    $0xc,%eax
f010386b:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f0103871:	73 4d                	jae    f01038c0 <env_free+0x1da>
    page_decref(pa2page(pa));
f0103873:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103876:	8b 15 94 4e 23 f0    	mov    0xf0234e94,%edx
f010387c:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f010387f:	50                   	push   %eax
f0103880:	e8 3f d8 ff ff       	call   f01010c4 <page_decref>

    // return the environment to the free list
    e->env_status = ENV_FREE;
f0103885:	8b 45 08             	mov    0x8(%ebp),%eax
f0103888:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
    e->env_link = env_free_list;
f010388f:	a1 50 42 23 f0       	mov    0xf0234250,%eax
f0103894:	8b 55 08             	mov    0x8(%ebp),%edx
f0103897:	89 42 44             	mov    %eax,0x44(%edx)
    env_free_list = e;
f010389a:	89 15 50 42 23 f0    	mov    %edx,0xf0234250
}
f01038a0:	83 c4 10             	add    $0x10,%esp
f01038a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038a6:	5b                   	pop    %ebx
f01038a7:	5e                   	pop    %esi
f01038a8:	5f                   	pop    %edi
f01038a9:	5d                   	pop    %ebp
f01038aa:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038ab:	50                   	push   %eax
f01038ac:	68 88 63 10 f0       	push   $0xf0106388
f01038b1:	68 ea 01 00 00       	push   $0x1ea
f01038b6:	68 6f 7e 10 f0       	push   $0xf0107e6f
f01038bb:	e8 80 c7 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f01038c0:	83 ec 04             	sub    $0x4,%esp
f01038c3:	68 f0 6a 10 f0       	push   $0xf0106af0
f01038c8:	6a 51                	push   $0x51
f01038ca:	68 42 77 10 f0       	push   $0xf0107742
f01038cf:	e8 6c c7 ff ff       	call   f0100040 <_panic>

f01038d4 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f01038d4:	55                   	push   %ebp
f01038d5:	89 e5                	mov    %esp,%ebp
f01038d7:	53                   	push   %ebx
f01038d8:	83 ec 04             	sub    $0x4,%esp
f01038db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // If e is currently running on other CPUs, we change its state to
    // ENV_DYING. A zombie environment will be freed the next time
    // it traps to the kernel.
    if (e->env_status == ENV_RUNNING && curenv != e) {
f01038de:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f01038e2:	74 21                	je     f0103905 <env_destroy+0x31>
        e->env_status = ENV_DYING;
        return;
    }

    env_free(e);
f01038e4:	83 ec 0c             	sub    $0xc,%esp
f01038e7:	53                   	push   %ebx
f01038e8:	e8 f9 fd ff ff       	call   f01036e6 <env_free>

    if (curenv == e) {
f01038ed:	e8 e9 23 00 00       	call   f0105cdb <cpunum>
f01038f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01038f5:	83 c4 10             	add    $0x10,%esp
f01038f8:	39 98 28 50 23 f0    	cmp    %ebx,-0xfdcafd8(%eax)
f01038fe:	74 1e                	je     f010391e <env_destroy+0x4a>
        curenv = NULL;
        sched_yield();
    }
}
f0103900:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103903:	c9                   	leave  
f0103904:	c3                   	ret    
    if (e->env_status == ENV_RUNNING && curenv != e) {
f0103905:	e8 d1 23 00 00       	call   f0105cdb <cpunum>
f010390a:	6b c0 74             	imul   $0x74,%eax,%eax
f010390d:	39 98 28 50 23 f0    	cmp    %ebx,-0xfdcafd8(%eax)
f0103913:	74 cf                	je     f01038e4 <env_destroy+0x10>
        e->env_status = ENV_DYING;
f0103915:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
        return;
f010391c:	eb e2                	jmp    f0103900 <env_destroy+0x2c>
        curenv = NULL;
f010391e:	e8 b8 23 00 00       	call   f0105cdb <cpunum>
f0103923:	6b c0 74             	imul   $0x74,%eax,%eax
f0103926:	c7 80 28 50 23 f0 00 	movl   $0x0,-0xfdcafd8(%eax)
f010392d:	00 00 00 
        sched_yield();
f0103930:	e8 3a 0c 00 00       	call   f010456f <sched_yield>

f0103935 <env_pop_tf>:
// this exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
f0103935:	55                   	push   %ebp
f0103936:	89 e5                	mov    %esp,%ebp
f0103938:	83 ec 0c             	sub    $0xc,%esp
    asm volatile(
f010393b:	8b 65 08             	mov    0x8(%ebp),%esp
f010393e:	61                   	popa   
f010393f:	07                   	pop    %es
f0103940:	1f                   	pop    %ds
f0103941:	83 c4 08             	add    $0x8,%esp
f0103944:	cf                   	iret   
    "\tpopl %%es\n"
    "\tpopl %%ds\n"
    "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
    "\tiret\n"
    : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
f0103945:	68 b2 7e 10 f0       	push   $0xf0107eb2
f010394a:	68 1e 02 00 00       	push   $0x21e
f010394f:	68 6f 7e 10 f0       	push   $0xf0107e6f
f0103954:	e8 e7 c6 ff ff       	call   f0100040 <_panic>

f0103959 <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
f0103959:	55                   	push   %ebp
f010395a:	89 e5                	mov    %esp,%ebp
f010395c:	53                   	push   %ebx
f010395d:	83 ec 04             	sub    $0x4,%esp
f0103960:	8b 5d 08             	mov    0x8(%ebp),%ebx
    //	e->env_tf.  Go back through the code you wrote above
    //	and make sure you have set the relevant parts of
    //	e->env_tf to sensible values.

    // LAB 3: Your code here.
    if (curenv != NULL) {
f0103963:	e8 73 23 00 00       	call   f0105cdb <cpunum>
f0103968:	6b c0 74             	imul   $0x74,%eax,%eax
f010396b:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0103972:	74 14                	je     f0103988 <env_run+0x2f>
        if (curenv->env_status == ENV_RUNNING) {
f0103974:	e8 62 23 00 00       	call   f0105cdb <cpunum>
f0103979:	6b c0 74             	imul   $0x74,%eax,%eax
f010397c:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0103982:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103986:	74 38                	je     f01039c0 <env_run+0x67>
            curenv->env_status = ENV_RUNNABLE;
        }
    }

    curenv = e;
f0103988:	e8 4e 23 00 00       	call   f0105cdb <cpunum>
f010398d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103990:	89 98 28 50 23 f0    	mov    %ebx,-0xfdcafd8(%eax)
    //?????????????????????????????????why this fault?
//    e->env_status = ENV_RUNNABLE;
    e->env_status = ENV_RUNNING;
f0103996:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)

    //if curenv == env ??
    e->env_runs++;
f010399d:	83 43 58 01          	addl   $0x1,0x58(%ebx)

    lcr3(PADDR(e->env_pgdir));
f01039a1:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01039a4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039a9:	77 2c                	ja     f01039d7 <env_run+0x7e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01039ab:	50                   	push   %eax
f01039ac:	68 88 63 10 f0       	push   $0xf0106388
f01039b1:	68 4a 02 00 00       	push   $0x24a
f01039b6:	68 6f 7e 10 f0       	push   $0xf0107e6f
f01039bb:	e8 80 c6 ff ff       	call   f0100040 <_panic>
            curenv->env_status = ENV_RUNNABLE;
f01039c0:	e8 16 23 00 00       	call   f0105cdb <cpunum>
f01039c5:	6b c0 74             	imul   $0x74,%eax,%eax
f01039c8:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01039ce:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01039d5:	eb b1                	jmp    f0103988 <env_run+0x2f>
	return (physaddr_t)kva - KERNBASE;
f01039d7:	05 00 00 00 10       	add    $0x10000000,%eax
f01039dc:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01039df:	83 ec 0c             	sub    $0xc,%esp
f01039e2:	68 c0 23 12 f0       	push   $0xf01223c0
f01039e7:	e8 0e 26 00 00       	call   f0105ffa <spin_unlock>
    asm volatile("pause");
f01039ec:	f3 90                	pause  

//    cprintf("e->env_tf.tf_cs:0x%x\n", e->env_tf.tf_cs);

    unlock_kernel();
    env_pop_tf(&e->env_tf);
f01039ee:	89 1c 24             	mov    %ebx,(%esp)
f01039f1:	e8 3f ff ff ff       	call   f0103935 <env_pop_tf>

f01039f6 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01039f6:	55                   	push   %ebp
f01039f7:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01039f9:	8b 45 08             	mov    0x8(%ebp),%eax
f01039fc:	ba 70 00 00 00       	mov    $0x70,%edx
f0103a01:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103a02:	ba 71 00 00 00       	mov    $0x71,%edx
f0103a07:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103a08:	0f b6 c0             	movzbl %al,%eax
}
f0103a0b:	5d                   	pop    %ebp
f0103a0c:	c3                   	ret    

f0103a0d <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103a0d:	55                   	push   %ebp
f0103a0e:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103a10:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a13:	ba 70 00 00 00       	mov    $0x70,%edx
f0103a18:	ee                   	out    %al,(%dx)
f0103a19:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103a1c:	ba 71 00 00 00       	mov    $0x71,%edx
f0103a21:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103a22:	5d                   	pop    %ebp
f0103a23:	c3                   	ret    

f0103a24 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103a24:	55                   	push   %ebp
f0103a25:	89 e5                	mov    %esp,%ebp
f0103a27:	56                   	push   %esi
f0103a28:	53                   	push   %ebx
f0103a29:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103a2c:	66 a3 a8 23 12 f0    	mov    %ax,0xf01223a8
	if (!didinit)
f0103a32:	80 3d 54 42 23 f0 00 	cmpb   $0x0,0xf0234254
f0103a39:	75 07                	jne    f0103a42 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103a3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103a3e:	5b                   	pop    %ebx
f0103a3f:	5e                   	pop    %esi
f0103a40:	5d                   	pop    %ebp
f0103a41:	c3                   	ret    
f0103a42:	89 c6                	mov    %eax,%esi
f0103a44:	ba 21 00 00 00       	mov    $0x21,%edx
f0103a49:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103a4a:	66 c1 e8 08          	shr    $0x8,%ax
f0103a4e:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103a53:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103a54:	83 ec 0c             	sub    $0xc,%esp
f0103a57:	68 be 7e 10 f0       	push   $0xf0107ebe
f0103a5c:	e8 1e 01 00 00       	call   f0103b7f <cprintf>
f0103a61:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103a64:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103a69:	0f b7 f6             	movzwl %si,%esi
f0103a6c:	f7 d6                	not    %esi
f0103a6e:	eb 08                	jmp    f0103a78 <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f0103a70:	83 c3 01             	add    $0x1,%ebx
f0103a73:	83 fb 10             	cmp    $0x10,%ebx
f0103a76:	74 18                	je     f0103a90 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103a78:	0f a3 de             	bt     %ebx,%esi
f0103a7b:	73 f3                	jae    f0103a70 <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f0103a7d:	83 ec 08             	sub    $0x8,%esp
f0103a80:	53                   	push   %ebx
f0103a81:	68 12 89 10 f0       	push   $0xf0108912
f0103a86:	e8 f4 00 00 00       	call   f0103b7f <cprintf>
f0103a8b:	83 c4 10             	add    $0x10,%esp
f0103a8e:	eb e0                	jmp    f0103a70 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103a90:	83 ec 0c             	sub    $0xc,%esp
f0103a93:	68 66 7a 10 f0       	push   $0xf0107a66
f0103a98:	e8 e2 00 00 00       	call   f0103b7f <cprintf>
f0103a9d:	83 c4 10             	add    $0x10,%esp
f0103aa0:	eb 99                	jmp    f0103a3b <irq_setmask_8259A+0x17>

f0103aa2 <pic_init>:
{
f0103aa2:	55                   	push   %ebp
f0103aa3:	89 e5                	mov    %esp,%ebp
f0103aa5:	57                   	push   %edi
f0103aa6:	56                   	push   %esi
f0103aa7:	53                   	push   %ebx
f0103aa8:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103aab:	c6 05 54 42 23 f0 01 	movb   $0x1,0xf0234254
f0103ab2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103ab7:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103abc:	89 da                	mov    %ebx,%edx
f0103abe:	ee                   	out    %al,(%dx)
f0103abf:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103ac4:	89 ca                	mov    %ecx,%edx
f0103ac6:	ee                   	out    %al,(%dx)
f0103ac7:	bf 11 00 00 00       	mov    $0x11,%edi
f0103acc:	be 20 00 00 00       	mov    $0x20,%esi
f0103ad1:	89 f8                	mov    %edi,%eax
f0103ad3:	89 f2                	mov    %esi,%edx
f0103ad5:	ee                   	out    %al,(%dx)
f0103ad6:	b8 20 00 00 00       	mov    $0x20,%eax
f0103adb:	89 da                	mov    %ebx,%edx
f0103add:	ee                   	out    %al,(%dx)
f0103ade:	b8 04 00 00 00       	mov    $0x4,%eax
f0103ae3:	ee                   	out    %al,(%dx)
f0103ae4:	b8 03 00 00 00       	mov    $0x3,%eax
f0103ae9:	ee                   	out    %al,(%dx)
f0103aea:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103aef:	89 f8                	mov    %edi,%eax
f0103af1:	89 da                	mov    %ebx,%edx
f0103af3:	ee                   	out    %al,(%dx)
f0103af4:	b8 28 00 00 00       	mov    $0x28,%eax
f0103af9:	89 ca                	mov    %ecx,%edx
f0103afb:	ee                   	out    %al,(%dx)
f0103afc:	b8 02 00 00 00       	mov    $0x2,%eax
f0103b01:	ee                   	out    %al,(%dx)
f0103b02:	b8 01 00 00 00       	mov    $0x1,%eax
f0103b07:	ee                   	out    %al,(%dx)
f0103b08:	bf 68 00 00 00       	mov    $0x68,%edi
f0103b0d:	89 f8                	mov    %edi,%eax
f0103b0f:	89 f2                	mov    %esi,%edx
f0103b11:	ee                   	out    %al,(%dx)
f0103b12:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103b17:	89 c8                	mov    %ecx,%eax
f0103b19:	ee                   	out    %al,(%dx)
f0103b1a:	89 f8                	mov    %edi,%eax
f0103b1c:	89 da                	mov    %ebx,%edx
f0103b1e:	ee                   	out    %al,(%dx)
f0103b1f:	89 c8                	mov    %ecx,%eax
f0103b21:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103b22:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f0103b29:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103b2d:	74 0f                	je     f0103b3e <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f0103b2f:	83 ec 0c             	sub    $0xc,%esp
f0103b32:	0f b7 c0             	movzwl %ax,%eax
f0103b35:	50                   	push   %eax
f0103b36:	e8 e9 fe ff ff       	call   f0103a24 <irq_setmask_8259A>
f0103b3b:	83 c4 10             	add    $0x10,%esp
}
f0103b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b41:	5b                   	pop    %ebx
f0103b42:	5e                   	pop    %esi
f0103b43:	5f                   	pop    %edi
f0103b44:	5d                   	pop    %ebp
f0103b45:	c3                   	ret    

f0103b46 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103b46:	55                   	push   %ebp
f0103b47:	89 e5                	mov    %esp,%ebp
f0103b49:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103b4c:	ff 75 08             	pushl  0x8(%ebp)
f0103b4f:	e8 19 cc ff ff       	call   f010076d <cputchar>
    //这里会有bug！
	*cnt++;
}
f0103b54:	83 c4 10             	add    $0x10,%esp
f0103b57:	c9                   	leave  
f0103b58:	c3                   	ret    

f0103b59 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103b59:	55                   	push   %ebp
f0103b5a:	89 e5                	mov    %esp,%ebp
f0103b5c:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103b66:	ff 75 0c             	pushl  0xc(%ebp)
f0103b69:	ff 75 08             	pushl  0x8(%ebp)
f0103b6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103b6f:	50                   	push   %eax
f0103b70:	68 46 3b 10 f0       	push   $0xf0103b46
f0103b75:	e8 ba 13 00 00       	call   f0104f34 <vprintfmt>
	return cnt;
}
f0103b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103b7d:	c9                   	leave  
f0103b7e:	c3                   	ret    

f0103b7f <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103b7f:	55                   	push   %ebp
f0103b80:	89 e5                	mov    %esp,%ebp
f0103b82:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103b85:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103b88:	50                   	push   %eax
f0103b89:	ff 75 08             	pushl  0x8(%ebp)
f0103b8c:	e8 c8 ff ff ff       	call   f0103b59 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103b91:	c9                   	leave  
f0103b92:	c3                   	ret    

f0103b93 <memCprintf>:

//不能重载？？
int memCprintf(const char *name, uintptr_t va, uint32_t pd_item, physaddr_t pa, uint32_t map_page){
f0103b93:	55                   	push   %ebp
f0103b94:	89 e5                	mov    %esp,%ebp
f0103b96:	83 ec 10             	sub    $0x10,%esp
    return cprintf("名称:%s\t虚拟地址:0x%x\t页目录项:0x%x\t物理地址:0x%x\t物理页:0x%x\n", name, va, pd_item, pa, map_page);
f0103b99:	ff 75 18             	pushl  0x18(%ebp)
f0103b9c:	ff 75 14             	pushl  0x14(%ebp)
f0103b9f:	ff 75 10             	pushl  0x10(%ebp)
f0103ba2:	ff 75 0c             	pushl  0xc(%ebp)
f0103ba5:	ff 75 08             	pushl  0x8(%ebp)
f0103ba8:	68 d4 7e 10 f0       	push   $0xf0107ed4
f0103bad:	e8 cd ff ff ff       	call   f0103b7f <cprintf>
}
f0103bb2:	c9                   	leave  
f0103bb3:	c3                   	ret    

f0103bb4 <trap_init_percpu>:
    trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void) {
f0103bb4:	55                   	push   %ebp
f0103bb5:	89 e5                	mov    %esp,%ebp
f0103bb7:	57                   	push   %edi
f0103bb8:	56                   	push   %esi
f0103bb9:	53                   	push   %ebx
f0103bba:	83 ec 1c             	sub    $0x1c,%esp
    //
    // LAB 4: Your code here:

    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - (KSTKSIZE + KSTKGAP) * cpunum();
f0103bbd:	e8 19 21 00 00       	call   f0105cdb <cpunum>
f0103bc2:	89 c3                	mov    %eax,%ebx
f0103bc4:	e8 12 21 00 00       	call   f0105cdb <cpunum>
f0103bc9:	6b d0 74             	imul   $0x74,%eax,%edx
f0103bcc:	c1 e3 10             	shl    $0x10,%ebx
f0103bcf:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f0103bd4:	29 d8                	sub    %ebx,%eax
f0103bd6:	89 82 30 50 23 f0    	mov    %eax,-0xfdcafd0(%edx)
    thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103bdc:	e8 fa 20 00 00       	call   f0105cdb <cpunum>
f0103be1:	6b c0 74             	imul   $0x74,%eax,%eax
f0103be4:	66 c7 80 34 50 23 f0 	movw   $0x10,-0xfdcafcc(%eax)
f0103beb:	10 00 
    thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103bed:	e8 e9 20 00 00       	call   f0105cdb <cpunum>
f0103bf2:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bf5:	66 c7 80 92 50 23 f0 	movw   $0x68,-0xfdcaf6e(%eax)
f0103bfc:	68 00 

    // Initialize the TSS slot of the gdt.
    gdt[(GD_TSS0 >> 3) + cpunum()] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103bfe:	e8 d8 20 00 00       	call   f0105cdb <cpunum>
f0103c03:	8d 58 05             	lea    0x5(%eax),%ebx
f0103c06:	e8 d0 20 00 00       	call   f0105cdb <cpunum>
f0103c0b:	89 c7                	mov    %eax,%edi
f0103c0d:	e8 c9 20 00 00       	call   f0105cdb <cpunum>
f0103c12:	89 c6                	mov    %eax,%esi
f0103c14:	e8 c2 20 00 00       	call   f0105cdb <cpunum>
f0103c19:	66 c7 04 dd 40 23 12 	movw   $0x67,-0xfeddcc0(,%ebx,8)
f0103c20:	f0 67 00 
f0103c23:	6b ff 74             	imul   $0x74,%edi,%edi
f0103c26:	81 c7 2c 50 23 f0    	add    $0xf023502c,%edi
f0103c2c:	66 89 3c dd 42 23 12 	mov    %di,-0xfeddcbe(,%ebx,8)
f0103c33:	f0 
f0103c34:	6b d6 74             	imul   $0x74,%esi,%edx
f0103c37:	81 c2 2c 50 23 f0    	add    $0xf023502c,%edx
f0103c3d:	c1 ea 10             	shr    $0x10,%edx
f0103c40:	88 14 dd 44 23 12 f0 	mov    %dl,-0xfeddcbc(,%ebx,8)
f0103c47:	c6 04 dd 45 23 12 f0 	movb   $0x99,-0xfeddcbb(,%ebx,8)
f0103c4e:	99 
f0103c4f:	c6 04 dd 46 23 12 f0 	movb   $0x40,-0xfeddcba(,%ebx,8)
f0103c56:	40 
f0103c57:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c5a:	05 2c 50 23 f0       	add    $0xf023502c,%eax
f0103c5f:	c1 e8 18             	shr    $0x18,%eax
f0103c62:	88 04 dd 47 23 12 f0 	mov    %al,-0xfeddcb9(,%ebx,8)
//    } else {
//        gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 1;
//        cprintf("application cpu%d\n", cpunum());
//    }

    gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 0;
f0103c69:	e8 6d 20 00 00       	call   f0105cdb <cpunum>
f0103c6e:	80 24 c5 6d 23 12 f0 	andb   $0xef,-0xfeddc93(,%eax,8)
f0103c75:	ef 

    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
            thiscpu->cpu_ts.ts_ss0, GD_TSS0 + (cpunum() << 3));
f0103c76:	e8 60 20 00 00       	call   f0105cdb <cpunum>
f0103c7b:	89 c7                	mov    %eax,%edi
f0103c7d:	e8 59 20 00 00       	call   f0105cdb <cpunum>
f0103c82:	6b c0 74             	imul   $0x74,%eax,%eax
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103c85:	0f b7 b0 34 50 23 f0 	movzwl -0xfdcafcc(%eax),%esi
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
f0103c8c:	e8 4a 20 00 00       	call   f0105cdb <cpunum>
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103c91:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c94:	8b 98 30 50 23 f0    	mov    -0xfdcafd0(%eax),%ebx
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
f0103c9a:	e8 3c 20 00 00       	call   f0105cdb <cpunum>
f0103c9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103ca2:	e8 34 20 00 00       	call   f0105cdb <cpunum>
f0103ca7:	83 ec 08             	sub    $0x8,%esp
f0103caa:	8d 14 fd 28 00 00 00 	lea    0x28(,%edi,8),%edx
f0103cb1:	52                   	push   %edx
f0103cb2:	56                   	push   %esi
f0103cb3:	53                   	push   %ebx
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
f0103cb4:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103cb8:	81 c2 2c 50 23 f0    	add    $0xf023502c,%edx
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103cbe:	52                   	push   %edx
f0103cbf:	50                   	push   %eax
f0103cc0:	68 24 7f 10 f0       	push   $0xf0107f24
f0103cc5:	e8 b5 fe ff ff       	call   f0103b7f <cprintf>

    // Load the TSS selector (like other segment selectors, the
    // bottom three bits are special; we leave them 0)

    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_31_24 << 24) +
f0103cca:	83 c4 20             	add    $0x20,%esp
f0103ccd:	e8 09 20 00 00       	call   f0105cdb <cpunum>
f0103cd2:	0f b6 1c c5 6f 23 12 	movzbl -0xfeddc91(,%eax,8),%ebx
f0103cd9:	f0 
f0103cda:	89 de                	mov    %ebx,%esi
f0103cdc:	c1 e6 18             	shl    $0x18,%esi
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
f0103cdf:	e8 f7 1f 00 00       	call   f0105cdb <cpunum>
f0103ce4:	0f b6 1c c5 6c 23 12 	movzbl -0xfeddc94(,%eax,8),%ebx
f0103ceb:	f0 
f0103cec:	c1 e3 10             	shl    $0x10,%ebx
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_31_24 << 24) +
f0103cef:	01 f3                	add    %esi,%ebx
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
f0103cf1:	e8 e5 1f 00 00       	call   f0105cdb <cpunum>
    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
f0103cf6:	83 ec 04             	sub    $0x4,%esp
f0103cf9:	6a 74                	push   $0x74
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
f0103cfb:	0f b7 04 c5 6a 23 12 	movzwl -0xfeddc96(,%eax,8),%eax
f0103d02:	f0 
    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
f0103d03:	01 c3                	add    %eax,%ebx
f0103d05:	53                   	push   %ebx
f0103d06:	68 80 7f 10 f0       	push   $0xf0107f80
f0103d0b:	e8 6f fe ff ff       	call   f0103b7f <cprintf>
            sizeof(struct CpuInfo));
    //question what?
    ltr((GD_TSS0 + (cpunum() << 3)));
f0103d10:	e8 c6 1f 00 00       	call   f0105cdb <cpunum>
f0103d15:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
	asm volatile("ltr %0" : : "r" (sel));
f0103d1c:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103d1f:	b8 ac 23 12 f0       	mov    $0xf01223ac,%eax
f0103d24:	0f 01 18             	lidtl  (%eax)

    // Load the IDT
    lidt(&idt_pd);
}
f0103d27:	83 c4 10             	add    $0x10,%esp
f0103d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103d2d:	5b                   	pop    %ebx
f0103d2e:	5e                   	pop    %esi
f0103d2f:	5f                   	pop    %edi
f0103d30:	5d                   	pop    %ebp
f0103d31:	c3                   	ret    

f0103d32 <trap_init>:
trap_init(void) {
f0103d32:	55                   	push   %ebp
f0103d33:	89 e5                	mov    %esp,%ebp
f0103d35:	57                   	push   %edi
f0103d36:	56                   	push   %esi
f0103d37:	53                   	push   %ebx
f0103d38:	83 ec 5c             	sub    $0x5c,%esp
    char *handler[] = {handler0, handler1, handler2, handler3, handler4, handler5, handler6, handler7, handler8,
f0103d3b:	8d 7d 98             	lea    -0x68(%ebp),%edi
f0103d3e:	be 60 84 10 f0       	mov    $0xf0108460,%esi
f0103d43:	b9 14 00 00 00       	mov    $0x14,%ecx
f0103d48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (int i = 0; i < 20; i++) {
f0103d4a:	bb 00 00 00 00       	mov    $0x0,%ebx
            SETGATE(idt[i], 1, GD_KT, handler[i], 0);
f0103d4f:	8b 44 9d 98          	mov    -0x68(%ebp,%ebx,4),%eax
f0103d53:	66 89 04 dd 60 42 23 	mov    %ax,-0xfdcbda0(,%ebx,8)
f0103d5a:	f0 
f0103d5b:	66 c7 04 dd 62 42 23 	movw   $0x8,-0xfdcbd9e(,%ebx,8)
f0103d62:	f0 08 00 
f0103d65:	c6 04 dd 64 42 23 f0 	movb   $0x0,-0xfdcbd9c(,%ebx,8)
f0103d6c:	00 
f0103d6d:	c6 04 dd 65 42 23 f0 	movb   $0x8f,-0xfdcbd9b(,%ebx,8)
f0103d74:	8f 
f0103d75:	c1 e8 10             	shr    $0x10,%eax
f0103d78:	66 89 04 dd 66 42 23 	mov    %ax,-0xfdcbd9a(,%ebx,8)
f0103d7f:	f0 
        cprintf("idt[%d]\toff:0x%x\n", i, (idt[i].gd_off_31_16 << 16) + idt[i].gd_off_15_0);
f0103d80:	be 60 42 23 f0       	mov    $0xf0234260,%esi
f0103d85:	83 ec 04             	sub    $0x4,%esp
f0103d88:	0f b7 44 de 06       	movzwl 0x6(%esi,%ebx,8),%eax
f0103d8d:	c1 e0 10             	shl    $0x10,%eax
f0103d90:	0f b7 14 de          	movzwl (%esi,%ebx,8),%edx
f0103d94:	01 d0                	add    %edx,%eax
f0103d96:	50                   	push   %eax
f0103d97:	53                   	push   %ebx
f0103d98:	68 76 80 10 f0       	push   $0xf0108076
f0103d9d:	e8 dd fd ff ff       	call   f0103b7f <cprintf>
    for (int i = 0; i < 20; i++) {
f0103da2:	83 c3 01             	add    $0x1,%ebx
f0103da5:	83 c4 10             	add    $0x10,%esp
f0103da8:	83 fb 13             	cmp    $0x13,%ebx
f0103dab:	7f 29                	jg     f0103dd6 <trap_init+0xa4>
        if (i == T_BRKPT) {
f0103dad:	83 fb 03             	cmp    $0x3,%ebx
f0103db0:	75 9d                	jne    f0103d4f <trap_init+0x1d>
            SETGATE(idt[i], 1, GD_KT, handler[i], 3);
f0103db2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0103db5:	66 89 46 18          	mov    %ax,0x18(%esi)
f0103db9:	66 c7 46 1a 08 00    	movw   $0x8,0x1a(%esi)
f0103dbf:	c6 05 7c 42 23 f0 00 	movb   $0x0,0xf023427c
f0103dc6:	c6 05 7d 42 23 f0 ef 	movb   $0xef,0xf023427d
f0103dcd:	c1 e8 10             	shr    $0x10,%eax
f0103dd0:	66 89 46 1e          	mov    %ax,0x1e(%esi)
f0103dd4:	eb af                	jmp    f0103d85 <trap_init+0x53>
    SETGATE(idt[T_SYSCALL], 1, GD_KT, handler48, 3);
f0103dd6:	b8 86 44 10 f0       	mov    $0xf0104486,%eax
f0103ddb:	66 a3 e0 43 23 f0    	mov    %ax,0xf02343e0
f0103de1:	66 c7 05 e2 43 23 f0 	movw   $0x8,0xf02343e2
f0103de8:	08 00 
f0103dea:	c6 05 e4 43 23 f0 00 	movb   $0x0,0xf02343e4
f0103df1:	c6 05 e5 43 23 f0 ef 	movb   $0xef,0xf02343e5
f0103df8:	c1 e8 10             	shr    $0x10,%eax
f0103dfb:	66 a3 e6 43 23 f0    	mov    %ax,0xf02343e6
    trap_init_percpu();
f0103e01:	e8 ae fd ff ff       	call   f0103bb4 <trap_init_percpu>
}
f0103e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e09:	5b                   	pop    %ebx
f0103e0a:	5e                   	pop    %esi
f0103e0b:	5f                   	pop    %edi
f0103e0c:	5d                   	pop    %ebp
f0103e0d:	c3                   	ret    

f0103e0e <print_regs>:
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
    }
}

void
print_regs(struct PushRegs *regs) {
f0103e0e:	55                   	push   %ebp
f0103e0f:	89 e5                	mov    %esp,%ebp
f0103e11:	53                   	push   %ebx
f0103e12:	83 ec 0c             	sub    $0xc,%esp
f0103e15:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103e18:	ff 33                	pushl  (%ebx)
f0103e1a:	68 88 80 10 f0       	push   $0xf0108088
f0103e1f:	e8 5b fd ff ff       	call   f0103b7f <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103e24:	83 c4 08             	add    $0x8,%esp
f0103e27:	ff 73 04             	pushl  0x4(%ebx)
f0103e2a:	68 97 80 10 f0       	push   $0xf0108097
f0103e2f:	e8 4b fd ff ff       	call   f0103b7f <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103e34:	83 c4 08             	add    $0x8,%esp
f0103e37:	ff 73 08             	pushl  0x8(%ebx)
f0103e3a:	68 a6 80 10 f0       	push   $0xf01080a6
f0103e3f:	e8 3b fd ff ff       	call   f0103b7f <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103e44:	83 c4 08             	add    $0x8,%esp
f0103e47:	ff 73 0c             	pushl  0xc(%ebx)
f0103e4a:	68 b5 80 10 f0       	push   $0xf01080b5
f0103e4f:	e8 2b fd ff ff       	call   f0103b7f <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103e54:	83 c4 08             	add    $0x8,%esp
f0103e57:	ff 73 10             	pushl  0x10(%ebx)
f0103e5a:	68 c4 80 10 f0       	push   $0xf01080c4
f0103e5f:	e8 1b fd ff ff       	call   f0103b7f <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103e64:	83 c4 08             	add    $0x8,%esp
f0103e67:	ff 73 14             	pushl  0x14(%ebx)
f0103e6a:	68 d3 80 10 f0       	push   $0xf01080d3
f0103e6f:	e8 0b fd ff ff       	call   f0103b7f <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103e74:	83 c4 08             	add    $0x8,%esp
f0103e77:	ff 73 18             	pushl  0x18(%ebx)
f0103e7a:	68 e2 80 10 f0       	push   $0xf01080e2
f0103e7f:	e8 fb fc ff ff       	call   f0103b7f <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103e84:	83 c4 08             	add    $0x8,%esp
f0103e87:	ff 73 1c             	pushl  0x1c(%ebx)
f0103e8a:	68 f1 80 10 f0       	push   $0xf01080f1
f0103e8f:	e8 eb fc ff ff       	call   f0103b7f <cprintf>
}
f0103e94:	83 c4 10             	add    $0x10,%esp
f0103e97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103e9a:	c9                   	leave  
f0103e9b:	c3                   	ret    

f0103e9c <print_trapframe>:
print_trapframe(struct Trapframe *tf) {
f0103e9c:	55                   	push   %ebp
f0103e9d:	89 e5                	mov    %esp,%ebp
f0103e9f:	56                   	push   %esi
f0103ea0:	53                   	push   %ebx
f0103ea1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("TRAP frame at %p\n", tf);
f0103ea4:	83 ec 08             	sub    $0x8,%esp
f0103ea7:	53                   	push   %ebx
f0103ea8:	68 42 81 10 f0       	push   $0xf0108142
f0103ead:	e8 cd fc ff ff       	call   f0103b7f <cprintf>
    print_regs(&tf->tf_regs);
f0103eb2:	89 1c 24             	mov    %ebx,(%esp)
f0103eb5:	e8 54 ff ff ff       	call   f0103e0e <print_regs>
    cprintf("  es   0x----%04x\n", tf->tf_es);
f0103eba:	83 c4 08             	add    $0x8,%esp
f0103ebd:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103ec1:	50                   	push   %eax
f0103ec2:	68 54 81 10 f0       	push   $0xf0108154
f0103ec7:	e8 b3 fc ff ff       	call   f0103b7f <cprintf>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103ecc:	83 c4 08             	add    $0x8,%esp
f0103ecf:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103ed3:	50                   	push   %eax
f0103ed4:	68 67 81 10 f0       	push   $0xf0108167
f0103ed9:	e8 a1 fc ff ff       	call   f0103b7f <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103ede:	8b 43 28             	mov    0x28(%ebx),%eax
    if (trapno < ARRAY_SIZE(excnames))
f0103ee1:	83 c4 10             	add    $0x10,%esp
f0103ee4:	83 f8 13             	cmp    $0x13,%eax
f0103ee7:	0f 86 d4 00 00 00    	jbe    f0103fc1 <print_trapframe+0x125>
    return "(unknown trap)";
f0103eed:	83 f8 30             	cmp    $0x30,%eax
f0103ef0:	ba 00 81 10 f0       	mov    $0xf0108100,%edx
f0103ef5:	b9 0c 81 10 f0       	mov    $0xf010810c,%ecx
f0103efa:	0f 45 d1             	cmovne %ecx,%edx
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103efd:	83 ec 04             	sub    $0x4,%esp
f0103f00:	52                   	push   %edx
f0103f01:	50                   	push   %eax
f0103f02:	68 7a 81 10 f0       	push   $0xf010817a
f0103f07:	e8 73 fc ff ff       	call   f0103b7f <cprintf>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103f0c:	83 c4 10             	add    $0x10,%esp
f0103f0f:	39 1d 60 4a 23 f0    	cmp    %ebx,0xf0234a60
f0103f15:	0f 84 b2 00 00 00    	je     f0103fcd <print_trapframe+0x131>
    cprintf("  err  0x%08x", tf->tf_err);
f0103f1b:	83 ec 08             	sub    $0x8,%esp
f0103f1e:	ff 73 2c             	pushl  0x2c(%ebx)
f0103f21:	68 9b 81 10 f0       	push   $0xf010819b
f0103f26:	e8 54 fc ff ff       	call   f0103b7f <cprintf>
    if (tf->tf_trapno == T_PGFLT)
f0103f2b:	83 c4 10             	add    $0x10,%esp
f0103f2e:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103f32:	0f 85 b8 00 00 00    	jne    f0103ff0 <print_trapframe+0x154>
                tf->tf_err & 1 ? "protection" : "not-present");
f0103f38:	8b 43 2c             	mov    0x2c(%ebx),%eax
        cprintf(" [%s, %s, %s]\n",
f0103f3b:	89 c2                	mov    %eax,%edx
f0103f3d:	83 e2 01             	and    $0x1,%edx
f0103f40:	b9 1b 81 10 f0       	mov    $0xf010811b,%ecx
f0103f45:	ba 26 81 10 f0       	mov    $0xf0108126,%edx
f0103f4a:	0f 44 ca             	cmove  %edx,%ecx
f0103f4d:	89 c2                	mov    %eax,%edx
f0103f4f:	83 e2 02             	and    $0x2,%edx
f0103f52:	be 32 81 10 f0       	mov    $0xf0108132,%esi
f0103f57:	ba 38 81 10 f0       	mov    $0xf0108138,%edx
f0103f5c:	0f 45 d6             	cmovne %esi,%edx
f0103f5f:	83 e0 04             	and    $0x4,%eax
f0103f62:	b8 3d 81 10 f0       	mov    $0xf010813d,%eax
f0103f67:	be fe 82 10 f0       	mov    $0xf01082fe,%esi
f0103f6c:	0f 44 c6             	cmove  %esi,%eax
f0103f6f:	51                   	push   %ecx
f0103f70:	52                   	push   %edx
f0103f71:	50                   	push   %eax
f0103f72:	68 a9 81 10 f0       	push   $0xf01081a9
f0103f77:	e8 03 fc ff ff       	call   f0103b7f <cprintf>
f0103f7c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103f7f:	83 ec 08             	sub    $0x8,%esp
f0103f82:	ff 73 30             	pushl  0x30(%ebx)
f0103f85:	68 b8 81 10 f0       	push   $0xf01081b8
f0103f8a:	e8 f0 fb ff ff       	call   f0103b7f <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103f8f:	83 c4 08             	add    $0x8,%esp
f0103f92:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103f96:	50                   	push   %eax
f0103f97:	68 c7 81 10 f0       	push   $0xf01081c7
f0103f9c:	e8 de fb ff ff       	call   f0103b7f <cprintf>
    cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103fa1:	83 c4 08             	add    $0x8,%esp
f0103fa4:	ff 73 38             	pushl  0x38(%ebx)
f0103fa7:	68 da 81 10 f0       	push   $0xf01081da
f0103fac:	e8 ce fb ff ff       	call   f0103b7f <cprintf>
    if ((tf->tf_cs & 3) != 0) {
f0103fb1:	83 c4 10             	add    $0x10,%esp
f0103fb4:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103fb8:	75 4b                	jne    f0104005 <print_trapframe+0x169>
}
f0103fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103fbd:	5b                   	pop    %ebx
f0103fbe:	5e                   	pop    %esi
f0103fbf:	5d                   	pop    %ebp
f0103fc0:	c3                   	ret    
        return excnames[trapno];
f0103fc1:	8b 14 85 80 85 10 f0 	mov    -0xfef7a80(,%eax,4),%edx
f0103fc8:	e9 30 ff ff ff       	jmp    f0103efd <print_trapframe+0x61>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103fcd:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103fd1:	0f 85 44 ff ff ff    	jne    f0103f1b <print_trapframe+0x7f>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103fd7:	0f 20 d0             	mov    %cr2,%eax
        cprintf("  cr2  0x%08x\n", rcr2());
f0103fda:	83 ec 08             	sub    $0x8,%esp
f0103fdd:	50                   	push   %eax
f0103fde:	68 8c 81 10 f0       	push   $0xf010818c
f0103fe3:	e8 97 fb ff ff       	call   f0103b7f <cprintf>
f0103fe8:	83 c4 10             	add    $0x10,%esp
f0103feb:	e9 2b ff ff ff       	jmp    f0103f1b <print_trapframe+0x7f>
        cprintf("\n");
f0103ff0:	83 ec 0c             	sub    $0xc,%esp
f0103ff3:	68 66 7a 10 f0       	push   $0xf0107a66
f0103ff8:	e8 82 fb ff ff       	call   f0103b7f <cprintf>
f0103ffd:	83 c4 10             	add    $0x10,%esp
f0104000:	e9 7a ff ff ff       	jmp    f0103f7f <print_trapframe+0xe3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104005:	83 ec 08             	sub    $0x8,%esp
f0104008:	ff 73 3c             	pushl  0x3c(%ebx)
f010400b:	68 e9 81 10 f0       	push   $0xf01081e9
f0104010:	e8 6a fb ff ff       	call   f0103b7f <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104015:	83 c4 08             	add    $0x8,%esp
f0104018:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f010401c:	50                   	push   %eax
f010401d:	68 f8 81 10 f0       	push   $0xf01081f8
f0104022:	e8 58 fb ff ff       	call   f0103b7f <cprintf>
f0104027:	83 c4 10             	add    $0x10,%esp
}
f010402a:	eb 8e                	jmp    f0103fba <print_trapframe+0x11e>

f010402c <page_fault_handler>:
//    assert(curenv && curenv->env_status == ENV_RUNNING);
//    env_run(curenv);
}

void
page_fault_handler(struct Trapframe *tf) {
f010402c:	55                   	push   %ebp
f010402d:	89 e5                	mov    %esp,%ebp
f010402f:	57                   	push   %edi
f0104030:	56                   	push   %esi
f0104031:	53                   	push   %ebx
f0104032:	83 ec 1c             	sub    $0x1c,%esp
f0104035:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104038:	0f 20 d0             	mov    %cr2,%eax
f010403b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fault_va = rcr2();

    // Handle kernel-mode page faults.

    // LAB 3: Your code here.
    if ((tf->tf_cs & 3) == 0) {
f010403e:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104042:	75 20                	jne    f0104064 <page_fault_handler+0x38>
        print_trapframe(tf);
f0104044:	83 ec 0c             	sub    $0xc,%esp
f0104047:	53                   	push   %ebx
f0104048:	e8 4f fe ff ff       	call   f0103e9c <print_trapframe>
        panic("kernel-mode exception\n");
f010404d:	83 c4 0c             	add    $0xc,%esp
f0104050:	68 0b 82 10 f0       	push   $0xf010820b
f0104055:	68 70 01 00 00       	push   $0x170
f010405a:	68 22 82 10 f0       	push   $0xf0108222
f010405f:	e8 dc bf ff ff       	call   f0100040 <_panic>

    // Call the environment's page fault upcall, if one exists.  Set up a
    // page fault stack frame on the user exception stack (below
    // UXSTACKTOP), then branch to curenv->env_pgfault_upcall.

    if (curenv->env_pgfault_upcall == NULL) {
f0104064:	e8 72 1c 00 00       	call   f0105cdb <cpunum>
f0104069:	6b c0 74             	imul   $0x74,%eax,%eax
f010406c:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104072:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104076:	0f 84 a2 00 00 00    	je     f010411e <page_fault_handler+0xf2>
                curenv->env_id, fault_va, tf->tf_eip);
        print_trapframe(tf);
        env_destroy(curenv);
    }

    user_mem_assert(curenv, (void *) UXSTACKTOP - PGSIZE, PGSIZE, PTE_W);
f010407c:	e8 5a 1c 00 00       	call   f0105cdb <cpunum>
f0104081:	6a 02                	push   $0x2
f0104083:	68 00 10 00 00       	push   $0x1000
f0104088:	68 00 f0 bf ee       	push   $0xeebff000
f010408d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104090:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104096:	e8 d7 f0 ff ff       	call   f0103172 <user_mem_assert>

    struct UTrapframe *uTrapframe;
    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f010409b:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010409e:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
f01040a4:	83 c4 10             	add    $0x10,%esp

        if ((uintptr_t) uTrapframe < UXSTACKTOP - PGSIZE) {
            env_destroy(curenv);
        }
    } else {
        uTrapframe = (struct UTrapframe *) (UXSTACKTOP - sizeof(struct UTrapframe));
f01040a7:	be cc ff bf ee       	mov    $0xeebfffcc,%esi
    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f01040ac:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01040b2:	77 10                	ja     f01040c4 <page_fault_handler+0x98>
        uTrapframe = (struct UTrapframe *) (tf->tf_esp - 4 - sizeof(struct UTrapframe));
f01040b4:	83 e8 38             	sub    $0x38,%eax
f01040b7:	89 c6                	mov    %eax,%esi
        if ((uintptr_t) uTrapframe < UXSTACKTOP - PGSIZE) {
f01040b9:	3d ff ef bf ee       	cmp    $0xeebfefff,%eax
f01040be:	0f 86 a2 00 00 00    	jbe    f0104166 <page_fault_handler+0x13a>
    }

    uTrapframe->utf_esp = tf->tf_esp;
f01040c4:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01040c7:	89 f2                	mov    %esi,%edx
f01040c9:	89 46 30             	mov    %eax,0x30(%esi)
    uTrapframe->utf_eflags = tf->tf_eflags;
f01040cc:	8b 43 38             	mov    0x38(%ebx),%eax
f01040cf:	89 46 2c             	mov    %eax,0x2c(%esi)
    uTrapframe->utf_eip = tf->tf_eip;
f01040d2:	8b 43 30             	mov    0x30(%ebx),%eax
f01040d5:	89 46 28             	mov    %eax,0x28(%esi)
    uTrapframe->utf_regs = tf->tf_regs;
f01040d8:	8d 7e 08             	lea    0x8(%esi),%edi
f01040db:	b9 08 00 00 00       	mov    $0x8,%ecx
f01040e0:	89 de                	mov    %ebx,%esi
f01040e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    uTrapframe->utf_err = tf->tf_err;
f01040e4:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01040e7:	89 d7                	mov    %edx,%edi
f01040e9:	89 42 04             	mov    %eax,0x4(%edx)
    uTrapframe->utf_fault_va = fault_va;
f01040ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01040ef:	89 02                	mov    %eax,(%edx)
    // Hints:
    //   user_mem_assert() and env_run() are useful here.
    //   To change what the user environment runs, modify 'curenv->env_tf'
    //   (the 'tf' variable points at 'curenv->env_tf').

    tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
f01040f1:	e8 e5 1b 00 00       	call   f0105cdb <cpunum>
f01040f6:	6b c0 74             	imul   $0x74,%eax,%eax
f01040f9:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01040ff:	8b 40 64             	mov    0x64(%eax),%eax
f0104102:	89 43 30             	mov    %eax,0x30(%ebx)
    tf->tf_esp = (uintptr_t) uTrapframe;
f0104105:	89 7b 3c             	mov    %edi,0x3c(%ebx)
//    cprintf("uTrapframe:0x%x\tuTrapframe->utf_regs.reg_ebp:0x%x\tuTrapframe->utf_regs.reg_esp:0x%x\n", uTrapframe,
//            uTrapframe->utf_regs.reg_ebp, uTrapframe->utf_esp);
    env_run(curenv);
f0104108:	e8 ce 1b 00 00       	call   f0105cdb <cpunum>
f010410d:	83 ec 0c             	sub    $0xc,%esp
f0104110:	6b c0 74             	imul   $0x74,%eax,%eax
f0104113:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104119:	e8 3b f8 ff ff       	call   f0103959 <env_run>
        cprintf("[%08x] user fault va %08x ip %08x\n",
f010411e:	8b 73 30             	mov    0x30(%ebx),%esi
                curenv->env_id, fault_va, tf->tf_eip);
f0104121:	e8 b5 1b 00 00       	call   f0105cdb <cpunum>
        cprintf("[%08x] user fault va %08x ip %08x\n",
f0104126:	56                   	push   %esi
f0104127:	ff 75 e4             	pushl  -0x1c(%ebp)
                curenv->env_id, fault_va, tf->tf_eip);
f010412a:	6b c0 74             	imul   $0x74,%eax,%eax
        cprintf("[%08x] user fault va %08x ip %08x\n",
f010412d:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104133:	ff 70 48             	pushl  0x48(%eax)
f0104136:	68 d0 7f 10 f0       	push   $0xf0107fd0
f010413b:	e8 3f fa ff ff       	call   f0103b7f <cprintf>
        print_trapframe(tf);
f0104140:	89 1c 24             	mov    %ebx,(%esp)
f0104143:	e8 54 fd ff ff       	call   f0103e9c <print_trapframe>
        env_destroy(curenv);
f0104148:	e8 8e 1b 00 00       	call   f0105cdb <cpunum>
f010414d:	83 c4 04             	add    $0x4,%esp
f0104150:	6b c0 74             	imul   $0x74,%eax,%eax
f0104153:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104159:	e8 76 f7 ff ff       	call   f01038d4 <env_destroy>
f010415e:	83 c4 10             	add    $0x10,%esp
f0104161:	e9 16 ff ff ff       	jmp    f010407c <page_fault_handler+0x50>
            env_destroy(curenv);
f0104166:	e8 70 1b 00 00       	call   f0105cdb <cpunum>
f010416b:	83 ec 0c             	sub    $0xc,%esp
f010416e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104171:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104177:	e8 58 f7 ff ff       	call   f01038d4 <env_destroy>
f010417c:	83 c4 10             	add    $0x10,%esp
f010417f:	e9 40 ff ff ff       	jmp    f01040c4 <page_fault_handler+0x98>

f0104184 <trap>:
trap(struct Trapframe *tf) {
f0104184:	55                   	push   %ebp
f0104185:	89 e5                	mov    %esp,%ebp
f0104187:	57                   	push   %edi
f0104188:	56                   	push   %esi
f0104189:	8b 75 08             	mov    0x8(%ebp),%esi
    asm volatile("cld":: : "cc");
f010418c:	fc                   	cld    
    if (panicstr)
f010418d:	83 3d 84 4e 23 f0 00 	cmpl   $0x0,0xf0234e84
f0104194:	74 01                	je     f0104197 <trap+0x13>
            asm volatile("hlt");
f0104196:	f4                   	hlt    
    if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104197:	e8 3f 1b 00 00       	call   f0105cdb <cpunum>
f010419c:	6b d0 74             	imul   $0x74,%eax,%edx
f010419f:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01041a2:	b8 01 00 00 00       	mov    $0x1,%eax
f01041a7:	f0 87 82 20 50 23 f0 	lock xchg %eax,-0xfdcafe0(%edx)
f01041ae:	83 f8 02             	cmp    $0x2,%eax
f01041b1:	74 2e                	je     f01041e1 <trap+0x5d>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01041b3:	9c                   	pushf  
f01041b4:	58                   	pop    %eax
    assert(!(read_eflags() & FL_IF));
f01041b5:	f6 c4 02             	test   $0x2,%ah
f01041b8:	75 39                	jne    f01041f3 <trap+0x6f>
    if ((tf->tf_cs & 3) == 3) {
f01041ba:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01041be:	83 e0 03             	and    $0x3,%eax
f01041c1:	66 83 f8 03          	cmp    $0x3,%ax
f01041c5:	74 45                	je     f010420c <trap+0x88>
    last_tf = tf;
f01041c7:	89 35 60 4a 23 f0    	mov    %esi,0xf0234a60
    switch (tf->tf_trapno) {
f01041cd:	83 7e 28 30          	cmpl   $0x30,0x28(%esi)
f01041d1:	0f 87 0d 02 00 00    	ja     f01043e4 <trap+0x260>
f01041d7:	8b 46 28             	mov    0x28(%esi),%eax
f01041da:	ff 24 85 b0 84 10 f0 	jmp    *-0xfef7b50(,%eax,4)
	spin_lock(&kernel_lock);
f01041e1:	83 ec 0c             	sub    $0xc,%esp
f01041e4:	68 c0 23 12 f0       	push   $0xf01223c0
f01041e9:	e8 6f 1d 00 00       	call   f0105f5d <spin_lock>
f01041ee:	83 c4 10             	add    $0x10,%esp
f01041f1:	eb c0                	jmp    f01041b3 <trap+0x2f>
    assert(!(read_eflags() & FL_IF));
f01041f3:	68 2e 82 10 f0       	push   $0xf010822e
f01041f8:	68 21 77 10 f0       	push   $0xf0107721
f01041fd:	68 32 01 00 00       	push   $0x132
f0104202:	68 22 82 10 f0       	push   $0xf0108222
f0104207:	e8 34 be ff ff       	call   f0100040 <_panic>
f010420c:	83 ec 0c             	sub    $0xc,%esp
f010420f:	68 c0 23 12 f0       	push   $0xf01223c0
f0104214:	e8 44 1d 00 00       	call   f0105f5d <spin_lock>
        assert(curenv);
f0104219:	e8 bd 1a 00 00       	call   f0105cdb <cpunum>
f010421e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104221:	83 c4 10             	add    $0x10,%esp
f0104224:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f010422b:	74 3e                	je     f010426b <trap+0xe7>
        if (curenv->env_status == ENV_DYING) {
f010422d:	e8 a9 1a 00 00       	call   f0105cdb <cpunum>
f0104232:	6b c0 74             	imul   $0x74,%eax,%eax
f0104235:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f010423b:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010423f:	74 43                	je     f0104284 <trap+0x100>
        curenv->env_tf = *tf;
f0104241:	e8 95 1a 00 00       	call   f0105cdb <cpunum>
f0104246:	6b c0 74             	imul   $0x74,%eax,%eax
f0104249:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f010424f:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104254:	89 c7                	mov    %eax,%edi
f0104256:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        tf = &curenv->env_tf;
f0104258:	e8 7e 1a 00 00       	call   f0105cdb <cpunum>
f010425d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104260:	8b b0 28 50 23 f0    	mov    -0xfdcafd8(%eax),%esi
f0104266:	e9 5c ff ff ff       	jmp    f01041c7 <trap+0x43>
        assert(curenv);
f010426b:	68 47 82 10 f0       	push   $0xf0108247
f0104270:	68 21 77 10 f0       	push   $0xf0107721
f0104275:	68 3e 01 00 00       	push   $0x13e
f010427a:	68 22 82 10 f0       	push   $0xf0108222
f010427f:	e8 bc bd ff ff       	call   f0100040 <_panic>
            env_free(curenv);
f0104284:	e8 52 1a 00 00       	call   f0105cdb <cpunum>
f0104289:	83 ec 0c             	sub    $0xc,%esp
f010428c:	6b c0 74             	imul   $0x74,%eax,%eax
f010428f:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104295:	e8 4c f4 ff ff       	call   f01036e6 <env_free>
            curenv = NULL;
f010429a:	e8 3c 1a 00 00       	call   f0105cdb <cpunum>
f010429f:	6b c0 74             	imul   $0x74,%eax,%eax
f01042a2:	c7 80 28 50 23 f0 00 	movl   $0x0,-0xfdcafd8(%eax)
f01042a9:	00 00 00 
            sched_yield();
f01042ac:	e8 be 02 00 00       	call   f010456f <sched_yield>
            cprintf("Divide Error fault\n");
f01042b1:	83 ec 0c             	sub    $0xc,%esp
f01042b4:	68 4e 82 10 f0       	push   $0xf010824e
f01042b9:	e8 c1 f8 ff ff       	call   f0103b7f <cprintf>
f01042be:	83 c4 10             	add    $0x10,%esp
    print_trapframe(tf);
f01042c1:	83 ec 0c             	sub    $0xc,%esp
f01042c4:	56                   	push   %esi
f01042c5:	e8 d2 fb ff ff       	call   f0103e9c <print_trapframe>
    if (tf->tf_cs == GD_KT)
f01042ca:	83 c4 10             	add    $0x10,%esp
f01042cd:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01042d2:	0f 84 21 01 00 00    	je     f01043f9 <trap+0x275>
        env_destroy(curenv);
f01042d8:	e8 fe 19 00 00       	call   f0105cdb <cpunum>
f01042dd:	83 ec 0c             	sub    $0xc,%esp
f01042e0:	6b c0 74             	imul   $0x74,%eax,%eax
f01042e3:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f01042e9:	e8 e6 f5 ff ff       	call   f01038d4 <env_destroy>
f01042ee:	83 c4 10             	add    $0x10,%esp
    if (curenv && curenv->env_status == ENV_RUNNING)
f01042f1:	e8 e5 19 00 00       	call   f0105cdb <cpunum>
f01042f6:	6b c0 74             	imul   $0x74,%eax,%eax
f01042f9:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0104300:	74 18                	je     f010431a <trap+0x196>
f0104302:	e8 d4 19 00 00       	call   f0105cdb <cpunum>
f0104307:	6b c0 74             	imul   $0x74,%eax,%eax
f010430a:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104310:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104314:	0f 84 f6 00 00 00    	je     f0104410 <trap+0x28c>
        sched_yield();
f010431a:	e8 50 02 00 00       	call   f010456f <sched_yield>
            cprintf("Debug exceptions. Hints: An exception handler can examine the debug registers to determine which condition caused the exception.\n");
f010431f:	83 ec 0c             	sub    $0xc,%esp
f0104322:	68 f4 7f 10 f0       	push   $0xf0107ff4
f0104327:	e8 53 f8 ff ff       	call   f0103b7f <cprintf>
f010432c:	83 c4 10             	add    $0x10,%esp
f010432f:	eb 90                	jmp    f01042c1 <trap+0x13d>
            cprintf("Breakpoint INT 3 trap\n");
f0104331:	83 ec 0c             	sub    $0xc,%esp
f0104334:	68 62 82 10 f0       	push   $0xf0108262
f0104339:	e8 41 f8 ff ff       	call   f0103b7f <cprintf>
            monitor(tf);
f010433e:	89 34 24             	mov    %esi,(%esp)
f0104341:	e8 ac c5 ff ff       	call   f01008f2 <monitor>
f0104346:	83 c4 10             	add    $0x10,%esp
f0104349:	e9 73 ff ff ff       	jmp    f01042c1 <trap+0x13d>
            cprintf("Overflow trap\n");
f010434e:	83 ec 0c             	sub    $0xc,%esp
f0104351:	68 79 82 10 f0       	push   $0xf0108279
f0104356:	e8 24 f8 ff ff       	call   f0103b7f <cprintf>
f010435b:	83 c4 10             	add    $0x10,%esp
f010435e:	e9 5e ff ff ff       	jmp    f01042c1 <trap+0x13d>
            cprintf("Bounds Check fault\n");
f0104363:	83 ec 0c             	sub    $0xc,%esp
f0104366:	68 88 82 10 f0       	push   $0xf0108288
f010436b:	e8 0f f8 ff ff       	call   f0103b7f <cprintf>
f0104370:	83 c4 10             	add    $0x10,%esp
f0104373:	e9 49 ff ff ff       	jmp    f01042c1 <trap+0x13d>
            cprintf("Invalid Opcode fault\n");
f0104378:	83 ec 0c             	sub    $0xc,%esp
f010437b:	68 9c 82 10 f0       	push   $0xf010829c
f0104380:	e8 fa f7 ff ff       	call   f0103b7f <cprintf>
f0104385:	83 c4 10             	add    $0x10,%esp
f0104388:	e9 34 ff ff ff       	jmp    f01042c1 <trap+0x13d>
            cprintf("Double Fault\n");
f010438d:	83 ec 0c             	sub    $0xc,%esp
f0104390:	68 b2 82 10 f0       	push   $0xf01082b2
f0104395:	e8 e5 f7 ff ff       	call   f0103b7f <cprintf>
f010439a:	83 c4 10             	add    $0x10,%esp
f010439d:	e9 1f ff ff ff       	jmp    f01042c1 <trap+0x13d>
            cprintf("General Protection Exception\n");
f01043a2:	83 ec 0c             	sub    $0xc,%esp
f01043a5:	68 c0 82 10 f0       	push   $0xf01082c0
f01043aa:	e8 d0 f7 ff ff       	call   f0103b7f <cprintf>
f01043af:	83 c4 10             	add    $0x10,%esp
f01043b2:	e9 0a ff ff ff       	jmp    f01042c1 <trap+0x13d>
            page_fault_handler(tf);
f01043b7:	83 ec 0c             	sub    $0xc,%esp
f01043ba:	56                   	push   %esi
f01043bb:	e8 6c fc ff ff       	call   f010402c <page_fault_handler>
            tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f01043c0:	83 ec 08             	sub    $0x8,%esp
f01043c3:	ff 76 04             	pushl  0x4(%esi)
f01043c6:	ff 36                	pushl  (%esi)
f01043c8:	ff 76 10             	pushl  0x10(%esi)
f01043cb:	ff 76 18             	pushl  0x18(%esi)
f01043ce:	ff 76 14             	pushl  0x14(%esi)
f01043d1:	ff 76 1c             	pushl  0x1c(%esi)
f01043d4:	e8 51 02 00 00       	call   f010462a <syscall>
f01043d9:	89 46 1c             	mov    %eax,0x1c(%esi)
f01043dc:	83 c4 20             	add    $0x20,%esp
f01043df:	e9 0d ff ff ff       	jmp    f01042f1 <trap+0x16d>
            cprintf("Unknown Trap\n");
f01043e4:	83 ec 0c             	sub    $0xc,%esp
f01043e7:	68 de 82 10 f0       	push   $0xf01082de
f01043ec:	e8 8e f7 ff ff       	call   f0103b7f <cprintf>
f01043f1:	83 c4 10             	add    $0x10,%esp
f01043f4:	e9 c8 fe ff ff       	jmp    f01042c1 <trap+0x13d>
        panic("unhandled trap in kernel");
f01043f9:	83 ec 04             	sub    $0x4,%esp
f01043fc:	68 ec 82 10 f0       	push   $0xf01082ec
f0104401:	68 18 01 00 00       	push   $0x118
f0104406:	68 22 82 10 f0       	push   $0xf0108222
f010440b:	e8 30 bc ff ff       	call   f0100040 <_panic>
        env_run(curenv);
f0104410:	e8 c6 18 00 00       	call   f0105cdb <cpunum>
f0104415:	83 ec 0c             	sub    $0xc,%esp
f0104418:	6b c0 74             	imul   $0x74,%eax,%eax
f010441b:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104421:	e8 33 f5 ff ff       	call   f0103959 <env_run>

f0104426 <handler0>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
//which need error_code?
TRAPHANDLER_NOEC(handler0, T_DIVIDE);
f0104426:	6a 00                	push   $0x0
f0104428:	6a 00                	push   $0x0
f010442a:	eb 60                	jmp    f010448c <_alltraps>

f010442c <handler1>:
TRAPHANDLER_NOEC(handler1, T_DEBUG);
f010442c:	6a 00                	push   $0x0
f010442e:	6a 01                	push   $0x1
f0104430:	eb 5a                	jmp    f010448c <_alltraps>

f0104432 <handler2>:
TRAPHANDLER_NOEC(handler2, T_NMI);
f0104432:	6a 00                	push   $0x0
f0104434:	6a 02                	push   $0x2
f0104436:	eb 54                	jmp    f010448c <_alltraps>

f0104438 <handler3>:
TRAPHANDLER_NOEC(handler3, T_BRKPT);
f0104438:	6a 00                	push   $0x0
f010443a:	6a 03                	push   $0x3
f010443c:	eb 4e                	jmp    f010448c <_alltraps>

f010443e <handler4>:
TRAPHANDLER_NOEC(handler4, T_OFLOW);
f010443e:	6a 00                	push   $0x0
f0104440:	6a 04                	push   $0x4
f0104442:	eb 48                	jmp    f010448c <_alltraps>

f0104444 <handler5>:
TRAPHANDLER_NOEC(handler5, T_BOUND);
f0104444:	6a 00                	push   $0x0
f0104446:	6a 05                	push   $0x5
f0104448:	eb 42                	jmp    f010448c <_alltraps>

f010444a <handler6>:
TRAPHANDLER_NOEC(handler6, T_ILLOP);
f010444a:	6a 00                	push   $0x0
f010444c:	6a 06                	push   $0x6
f010444e:	eb 3c                	jmp    f010448c <_alltraps>

f0104450 <handler7>:
TRAPHANDLER_NOEC(handler7, T_DEVICE);
f0104450:	6a 00                	push   $0x0
f0104452:	6a 07                	push   $0x7
f0104454:	eb 36                	jmp    f010448c <_alltraps>

f0104456 <handler8>:
TRAPHANDLER(handler8, T_DBLFLT);
f0104456:	6a 08                	push   $0x8
f0104458:	eb 32                	jmp    f010448c <_alltraps>

f010445a <handler10>:
//TRAPHANDLER_NOEC(handler9, T_COPROC);
TRAPHANDLER(handler10, T_TSS);
f010445a:	6a 0a                	push   $0xa
f010445c:	eb 2e                	jmp    f010448c <_alltraps>

f010445e <handler11>:
TRAPHANDLER(handler11, T_SEGNP);
f010445e:	6a 0b                	push   $0xb
f0104460:	eb 2a                	jmp    f010448c <_alltraps>

f0104462 <handler12>:
TRAPHANDLER(handler12, T_STACK);
f0104462:	6a 0c                	push   $0xc
f0104464:	eb 26                	jmp    f010448c <_alltraps>

f0104466 <handler13>:
TRAPHANDLER(handler13, T_GPFLT);
f0104466:	6a 0d                	push   $0xd
f0104468:	eb 22                	jmp    f010448c <_alltraps>

f010446a <handler14>:
TRAPHANDLER(handler14, T_PGFLT);
f010446a:	6a 0e                	push   $0xe
f010446c:	eb 1e                	jmp    f010448c <_alltraps>

f010446e <handler16>:
//TRAPHANDLER_NOEC(handler15, T_RES);
TRAPHANDLER_NOEC(handler16, T_FPERR);
f010446e:	6a 00                	push   $0x0
f0104470:	6a 10                	push   $0x10
f0104472:	eb 18                	jmp    f010448c <_alltraps>

f0104474 <handler17>:
TRAPHANDLER_NOEC(handler17, T_ALIGN);
f0104474:	6a 00                	push   $0x0
f0104476:	6a 11                	push   $0x11
f0104478:	eb 12                	jmp    f010448c <_alltraps>

f010447a <handler18>:
TRAPHANDLER_NOEC(handler18, T_MCHK);
f010447a:	6a 00                	push   $0x0
f010447c:	6a 12                	push   $0x12
f010447e:	eb 0c                	jmp    f010448c <_alltraps>

f0104480 <handler19>:
TRAPHANDLER_NOEC(handler19, T_SIMDERR);
f0104480:	6a 00                	push   $0x0
f0104482:	6a 13                	push   $0x13
f0104484:	eb 06                	jmp    f010448c <_alltraps>

f0104486 <handler48>:

TRAPHANDLER_NOEC(handler48, T_SYSCALL);
f0104486:	6a 00                	push   $0x0
f0104488:	6a 30                	push   $0x30
f010448a:	eb 00                	jmp    f010448c <_alltraps>

f010448c <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
    //i stupid here
    pushl %ds
f010448c:	1e                   	push   %ds
    pushl %es
f010448d:	06                   	push   %es
    // forget above
    pushal
f010448e:	60                   	pusha  
    movl $GD_KD, %eax
f010448f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
f0104494:	8e d8                	mov    %eax,%ds
    movw %ax, %es
f0104496:	8e c0                	mov    %eax,%es
    pushl %esp
f0104498:	54                   	push   %esp
f0104499:	e8 e6 fc ff ff       	call   f0104184 <trap>

f010449e <sched_halt>:

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void) {
f010449e:	55                   	push   %ebp
f010449f:	89 e5                	mov    %esp,%ebp
f01044a1:	83 ec 08             	sub    $0x8,%esp
f01044a4:	a1 4c 42 23 f0       	mov    0xf023424c,%eax
f01044a9:	83 c0 54             	add    $0x54,%eax
    int i;

    // For debugging and testing purposes, if there are no runnable
    // environments in the system, then drop into the kernel monitor.
    for (i = 0; i < NENV; i++) {
f01044ac:	b9 00 00 00 00       	mov    $0x0,%ecx
        if ((envs[i].env_status == ENV_RUNNABLE ||
             envs[i].env_status == ENV_RUNNING ||
f01044b1:	8b 10                	mov    (%eax),%edx
f01044b3:	83 ea 01             	sub    $0x1,%edx
        if ((envs[i].env_status == ENV_RUNNABLE ||
f01044b6:	83 fa 02             	cmp    $0x2,%edx
f01044b9:	76 2d                	jbe    f01044e8 <sched_halt+0x4a>
    for (i = 0; i < NENV; i++) {
f01044bb:	83 c1 01             	add    $0x1,%ecx
f01044be:	83 c0 7c             	add    $0x7c,%eax
f01044c1:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01044c7:	75 e8                	jne    f01044b1 <sched_halt+0x13>
             envs[i].env_status == ENV_DYING))
            break;
    }
    if (i == NENV) {
        cprintf("No runnable environments in the system!\n");
f01044c9:	83 ec 0c             	sub    $0xc,%esp
f01044cc:	68 d0 85 10 f0       	push   $0xf01085d0
f01044d1:	e8 a9 f6 ff ff       	call   f0103b7f <cprintf>
f01044d6:	83 c4 10             	add    $0x10,%esp
        while (1)
            monitor(NULL);
f01044d9:	83 ec 0c             	sub    $0xc,%esp
f01044dc:	6a 00                	push   $0x0
f01044de:	e8 0f c4 ff ff       	call   f01008f2 <monitor>
f01044e3:	83 c4 10             	add    $0x10,%esp
f01044e6:	eb f1                	jmp    f01044d9 <sched_halt+0x3b>
    if (i == NENV) {
f01044e8:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01044ee:	74 d9                	je     f01044c9 <sched_halt+0x2b>
    }

    // Mark that no environment is running on this CPU
    curenv = NULL;
f01044f0:	e8 e6 17 00 00       	call   f0105cdb <cpunum>
f01044f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01044f8:	c7 80 28 50 23 f0 00 	movl   $0x0,-0xfdcafd8(%eax)
f01044ff:	00 00 00 
    lcr3(PADDR(kern_pgdir));
f0104502:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0104507:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010450c:	76 4f                	jbe    f010455d <sched_halt+0xbf>
	return (physaddr_t)kva - KERNBASE;
f010450e:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104513:	0f 22 d8             	mov    %eax,%cr3

    // Mark that this CPU is in the HALT state, so that when
    // timer interupts come in, we know we should re-acquire the
    // big kernel lock
    xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104516:	e8 c0 17 00 00       	call   f0105cdb <cpunum>
f010451b:	6b d0 74             	imul   $0x74,%eax,%edx
f010451e:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104521:	b8 02 00 00 00       	mov    $0x2,%eax
f0104526:	f0 87 82 20 50 23 f0 	lock xchg %eax,-0xfdcafe0(%edx)
	spin_unlock(&kernel_lock);
f010452d:	83 ec 0c             	sub    $0xc,%esp
f0104530:	68 c0 23 12 f0       	push   $0xf01223c0
f0104535:	e8 c0 1a 00 00       	call   f0105ffa <spin_unlock>
    asm volatile("pause");
f010453a:	f3 90                	pause  
    // Uncomment the following line after completing exercise 13
    //"sti\n"
    "1:\n"
    "hlt\n"
    "jmp 1b\n"
    : : "a" (thiscpu->cpu_ts.ts_esp0));
f010453c:	e8 9a 17 00 00       	call   f0105cdb <cpunum>
f0104541:	6b c0 74             	imul   $0x74,%eax,%eax
    asm volatile (
f0104544:	8b 80 30 50 23 f0    	mov    -0xfdcafd0(%eax),%eax
f010454a:	bd 00 00 00 00       	mov    $0x0,%ebp
f010454f:	89 c4                	mov    %eax,%esp
f0104551:	6a 00                	push   $0x0
f0104553:	6a 00                	push   $0x0
f0104555:	f4                   	hlt    
f0104556:	eb fd                	jmp    f0104555 <sched_halt+0xb7>
}
f0104558:	83 c4 10             	add    $0x10,%esp
f010455b:	c9                   	leave  
f010455c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010455d:	50                   	push   %eax
f010455e:	68 88 63 10 f0       	push   $0xf0106388
f0104563:	6a 54                	push   $0x54
f0104565:	68 f9 85 10 f0       	push   $0xf01085f9
f010456a:	e8 d1 ba ff ff       	call   f0100040 <_panic>

f010456f <sched_yield>:
sched_yield(void) {
f010456f:	55                   	push   %ebp
f0104570:	89 e5                	mov    %esp,%ebp
f0104572:	56                   	push   %esi
f0104573:	53                   	push   %ebx
    if (curenv != NULL) {
f0104574:	e8 62 17 00 00       	call   f0105cdb <cpunum>
f0104579:	6b c0 74             	imul   $0x74,%eax,%eax
    envid_t cur = 0;
f010457c:	b9 00 00 00 00       	mov    $0x0,%ecx
    if (curenv != NULL) {
f0104581:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0104588:	74 17                	je     f01045a1 <sched_yield+0x32>
        cur = ENVX(curenv->env_id);
f010458a:	e8 4c 17 00 00       	call   f0105cdb <cpunum>
f010458f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104592:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104598:	8b 48 48             	mov    0x48(%eax),%ecx
f010459b:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
        if (envs[i % NENV].env_status == ENV_RUNNABLE) {
f01045a1:	8b 1d 4c 42 23 f0    	mov    0xf023424c,%ebx
    for (int i = cur; i < NENV + cur; i++) {
f01045a7:	89 ca                	mov    %ecx,%edx
f01045a9:	81 c1 00 04 00 00    	add    $0x400,%ecx
f01045af:	39 d1                	cmp    %edx,%ecx
f01045b1:	7e 2b                	jle    f01045de <sched_yield+0x6f>
        if (envs[i % NENV].env_status == ENV_RUNNABLE) {
f01045b3:	89 d6                	mov    %edx,%esi
f01045b5:	c1 fe 1f             	sar    $0x1f,%esi
f01045b8:	c1 ee 16             	shr    $0x16,%esi
f01045bb:	8d 04 32             	lea    (%edx,%esi,1),%eax
f01045be:	25 ff 03 00 00       	and    $0x3ff,%eax
f01045c3:	29 f0                	sub    %esi,%eax
f01045c5:	6b c0 7c             	imul   $0x7c,%eax,%eax
f01045c8:	01 d8                	add    %ebx,%eax
f01045ca:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01045ce:	74 05                	je     f01045d5 <sched_yield+0x66>
    for (int i = cur; i < NENV + cur; i++) {
f01045d0:	83 c2 01             	add    $0x1,%edx
f01045d3:	eb da                	jmp    f01045af <sched_yield+0x40>
            env_run(&envs[i % NENV]);
f01045d5:	83 ec 0c             	sub    $0xc,%esp
f01045d8:	50                   	push   %eax
f01045d9:	e8 7b f3 ff ff       	call   f0103959 <env_run>
    if (idle == NULL && curenv != NULL && curenv->env_status == ENV_RUNNING) {
f01045de:	e8 f8 16 00 00       	call   f0105cdb <cpunum>
f01045e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01045e6:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f01045ed:	74 14                	je     f0104603 <sched_yield+0x94>
f01045ef:	e8 e7 16 00 00       	call   f0105cdb <cpunum>
f01045f4:	6b c0 74             	imul   $0x74,%eax,%eax
f01045f7:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01045fd:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104601:	74 0c                	je     f010460f <sched_yield+0xa0>
    sched_halt();
f0104603:	e8 96 fe ff ff       	call   f010449e <sched_halt>
}
f0104608:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010460b:	5b                   	pop    %ebx
f010460c:	5e                   	pop    %esi
f010460d:	5d                   	pop    %ebp
f010460e:	c3                   	ret    
        idle = curenv;
f010460f:	e8 c7 16 00 00       	call   f0105cdb <cpunum>
f0104614:	6b c0 74             	imul   $0x74,%eax,%eax
f0104617:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
    if (idle != NULL) {
f010461d:	85 c0                	test   %eax,%eax
f010461f:	74 e2                	je     f0104603 <sched_yield+0x94>
        env_run(idle);
f0104621:	83 ec 0c             	sub    $0xc,%esp
f0104624:	50                   	push   %eax
f0104625:	e8 2f f3 ff ff       	call   f0103959 <env_run>

f010462a <syscall>:
    return 0;
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5) {
f010462a:	55                   	push   %ebp
f010462b:	89 e5                	mov    %esp,%ebp
f010462d:	56                   	push   %esi
f010462e:	53                   	push   %ebx
f010462f:	83 ec 10             	sub    $0x10,%esp
f0104632:	8b 45 08             	mov    0x8(%ebp),%eax
    // Return any appropriate return value.
    // LAB 3: Your code here.

//	panic("syscall not implemented");

    switch (syscallno) {
f0104635:	83 f8 0a             	cmp    $0xa,%eax
f0104638:	0f 87 e8 04 00 00    	ja     f0104b26 <syscall+0x4fc>
f010463e:	ff 24 85 a4 88 10 f0 	jmp    *-0xfef775c(,%eax,4)
    user_mem_assert(curenv, s, len, PTE_U | PTE_P);
f0104645:	e8 91 16 00 00       	call   f0105cdb <cpunum>
f010464a:	6a 05                	push   $0x5
f010464c:	ff 75 10             	pushl  0x10(%ebp)
f010464f:	ff 75 0c             	pushl  0xc(%ebp)
f0104652:	6b c0 74             	imul   $0x74,%eax,%eax
f0104655:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f010465b:	e8 12 eb ff ff       	call   f0103172 <user_mem_assert>
    cprintf("%.*s", len, s);
f0104660:	83 c4 0c             	add    $0xc,%esp
f0104663:	ff 75 0c             	pushl  0xc(%ebp)
f0104666:	ff 75 10             	pushl  0x10(%ebp)
f0104669:	68 06 86 10 f0       	push   $0xf0108606
f010466e:	e8 0c f5 ff ff       	call   f0103b7f <cprintf>
f0104673:	83 c4 10             	add    $0x10,%esp
            return sys_env_set_pgfault_upcall(a1, (void *) a2);
        default:
            return -E_INVAL;
    }

    return 0;
f0104676:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010467b:	89 d8                	mov    %ebx,%eax
f010467d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104680:	5b                   	pop    %ebx
f0104681:	5e                   	pop    %esi
f0104682:	5d                   	pop    %ebp
f0104683:	c3                   	ret    
    return cons_getc();
f0104684:	e8 70 bf ff ff       	call   f01005f9 <cons_getc>
f0104689:	89 c3                	mov    %eax,%ebx
            return sys_cgetc();
f010468b:	eb ee                	jmp    f010467b <syscall+0x51>
    return curenv->env_id;
f010468d:	e8 49 16 00 00       	call   f0105cdb <cpunum>
f0104692:	6b c0 74             	imul   $0x74,%eax,%eax
f0104695:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f010469b:	8b 58 48             	mov    0x48(%eax),%ebx
            return sys_getenvid();
f010469e:	eb db                	jmp    f010467b <syscall+0x51>
    if ((r = envid2env(envid, &e, 1)) < 0)
f01046a0:	83 ec 04             	sub    $0x4,%esp
f01046a3:	6a 01                	push   $0x1
f01046a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01046a8:	50                   	push   %eax
f01046a9:	ff 75 0c             	pushl  0xc(%ebp)
f01046ac:	e8 7c eb ff ff       	call   f010322d <envid2env>
f01046b1:	89 c3                	mov    %eax,%ebx
f01046b3:	83 c4 10             	add    $0x10,%esp
f01046b6:	85 c0                	test   %eax,%eax
f01046b8:	78 c1                	js     f010467b <syscall+0x51>
    if (e == curenv)
f01046ba:	e8 1c 16 00 00       	call   f0105cdb <cpunum>
f01046bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01046c2:	6b c0 74             	imul   $0x74,%eax,%eax
f01046c5:	39 90 28 50 23 f0    	cmp    %edx,-0xfdcafd8(%eax)
f01046cb:	74 3d                	je     f010470a <syscall+0xe0>
        cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01046cd:	8b 5a 48             	mov    0x48(%edx),%ebx
f01046d0:	e8 06 16 00 00       	call   f0105cdb <cpunum>
f01046d5:	83 ec 04             	sub    $0x4,%esp
f01046d8:	53                   	push   %ebx
f01046d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01046dc:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01046e2:	ff 70 48             	pushl  0x48(%eax)
f01046e5:	68 26 86 10 f0       	push   $0xf0108626
f01046ea:	e8 90 f4 ff ff       	call   f0103b7f <cprintf>
f01046ef:	83 c4 10             	add    $0x10,%esp
    env_destroy(e);
f01046f2:	83 ec 0c             	sub    $0xc,%esp
f01046f5:	ff 75 f4             	pushl  -0xc(%ebp)
f01046f8:	e8 d7 f1 ff ff       	call   f01038d4 <env_destroy>
f01046fd:	83 c4 10             	add    $0x10,%esp
    return 0;
f0104700:	bb 00 00 00 00       	mov    $0x0,%ebx
            return sys_env_destroy(a1);
f0104705:	e9 71 ff ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f010470a:	e8 cc 15 00 00       	call   f0105cdb <cpunum>
f010470f:	83 ec 08             	sub    $0x8,%esp
f0104712:	6b c0 74             	imul   $0x74,%eax,%eax
f0104715:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f010471b:	ff 70 48             	pushl  0x48(%eax)
f010471e:	68 0b 86 10 f0       	push   $0xf010860b
f0104723:	e8 57 f4 ff ff       	call   f0103b7f <cprintf>
f0104728:	83 c4 10             	add    $0x10,%esp
f010472b:	eb c5                	jmp    f01046f2 <syscall+0xc8>
    sched_yield();
f010472d:	e8 3d fe ff ff       	call   f010456f <sched_yield>
    if ((r = env_alloc(&e, curenv->env_id)) < 0) {
f0104732:	e8 a4 15 00 00       	call   f0105cdb <cpunum>
f0104737:	83 ec 08             	sub    $0x8,%esp
f010473a:	6b c0 74             	imul   $0x74,%eax,%eax
f010473d:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104743:	ff 70 48             	pushl  0x48(%eax)
f0104746:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104749:	50                   	push   %eax
f010474a:	e8 e2 eb ff ff       	call   f0103331 <env_alloc>
f010474f:	89 c3                	mov    %eax,%ebx
f0104751:	83 c4 10             	add    $0x10,%esp
f0104754:	85 c0                	test   %eax,%eax
f0104756:	78 3a                	js     f0104792 <syscall+0x168>
    e->env_status = ENV_NOT_RUNNABLE;
f0104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010475b:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
    memcpy(&e->env_tf, &curenv->env_tf, sizeof(struct Trapframe));
f0104762:	e8 74 15 00 00       	call   f0105cdb <cpunum>
f0104767:	83 ec 04             	sub    $0x4,%esp
f010476a:	6a 44                	push   $0x44
f010476c:	6b c0 74             	imul   $0x74,%eax,%eax
f010476f:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104775:	ff 75 f4             	pushl  -0xc(%ebp)
f0104778:	e8 f0 0f 00 00       	call   f010576d <memcpy>
    e->env_tf.tf_regs.reg_eax = 0;
f010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104780:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    return e->env_id;
f0104787:	8b 58 48             	mov    0x48(%eax),%ebx
f010478a:	83 c4 10             	add    $0x10,%esp
            return sys_exofork();
f010478d:	e9 e9 fe ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_exofork() env_alloc error: %e\n", r);
f0104792:	83 ec 08             	sub    $0x8,%esp
f0104795:	50                   	push   %eax
f0104796:	68 40 86 10 f0       	push   $0xf0108640
f010479b:	e8 df f3 ff ff       	call   f0103b7f <cprintf>
f01047a0:	83 c4 10             	add    $0x10,%esp
f01047a3:	e9 d3 fe ff ff       	jmp    f010467b <syscall+0x51>
    if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) {
f01047a8:	8b 45 10             	mov    0x10(%ebp),%eax
f01047ab:	83 e8 02             	sub    $0x2,%eax
f01047ae:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01047b3:	75 2e                	jne    f01047e3 <syscall+0x1b9>
    if ((r = envid2env(envid, &env, true)) < 0) {
f01047b5:	83 ec 04             	sub    $0x4,%esp
f01047b8:	6a 01                	push   $0x1
f01047ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01047bd:	50                   	push   %eax
f01047be:	ff 75 0c             	pushl  0xc(%ebp)
f01047c1:	e8 67 ea ff ff       	call   f010322d <envid2env>
f01047c6:	89 c3                	mov    %eax,%ebx
f01047c8:	83 c4 10             	add    $0x10,%esp
f01047cb:	85 c0                	test   %eax,%eax
f01047cd:	78 30                	js     f01047ff <syscall+0x1d5>
    env->env_status = ENV_RUNNABLE;
f01047cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01047d2:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
    return 0;
f01047d9:	bb 00 00 00 00       	mov    $0x0,%ebx
            return sys_env_set_status(a1, a2);
f01047de:	e9 98 fe ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_env_set_status() status error:%e\n", -E_INVAL);
f01047e3:	83 ec 08             	sub    $0x8,%esp
f01047e6:	6a fd                	push   $0xfffffffd
f01047e8:	68 64 86 10 f0       	push   $0xf0108664
f01047ed:	e8 8d f3 ff ff       	call   f0103b7f <cprintf>
f01047f2:	83 c4 10             	add    $0x10,%esp
        return -E_INVAL;
f01047f5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047fa:	e9 7c fe ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_env_set_status() envid2env error:%e\n", r);
f01047ff:	83 ec 08             	sub    $0x8,%esp
f0104802:	50                   	push   %eax
f0104803:	68 8c 86 10 f0       	push   $0xf010868c
f0104808:	e8 72 f3 ff ff       	call   f0103b7f <cprintf>
f010480d:	83 c4 10             	add    $0x10,%esp
f0104810:	e9 66 fe ff ff       	jmp    f010467b <syscall+0x51>
    if ((r = envid2env(envid, &env, true)) < 0) {
f0104815:	83 ec 04             	sub    $0x4,%esp
f0104818:	6a 01                	push   $0x1
f010481a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010481d:	50                   	push   %eax
f010481e:	ff 75 0c             	pushl  0xc(%ebp)
f0104821:	e8 07 ea ff ff       	call   f010322d <envid2env>
f0104826:	89 c3                	mov    %eax,%ebx
f0104828:	83 c4 10             	add    $0x10,%esp
f010482b:	85 c0                	test   %eax,%eax
f010482d:	0f 88 80 00 00 00    	js     f01048b3 <syscall+0x289>
    if (((uintptr_t) va >= UTOP) || ((uintptr_t) va % PGSIZE != 0) || ((perm & (~PTE_SYSCALL)) != 0)) {
f0104833:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010483a:	0f 87 a3 00 00 00    	ja     f01048e3 <syscall+0x2b9>
f0104840:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104847:	0f 85 a0 00 00 00    	jne    f01048ed <syscall+0x2c3>
f010484d:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104850:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104856:	0f 85 9b 00 00 00    	jne    f01048f7 <syscall+0x2cd>
    if ((pp = page_alloc(ALLOC_ZERO)) == NULL) {
f010485c:	83 ec 0c             	sub    $0xc,%esp
f010485f:	6a 01                	push   $0x1
f0104861:	e8 90 c7 ff ff       	call   f0100ff6 <page_alloc>
f0104866:	89 c6                	mov    %eax,%esi
f0104868:	83 c4 10             	add    $0x10,%esp
f010486b:	85 c0                	test   %eax,%eax
f010486d:	74 5a                	je     f01048c9 <syscall+0x29f>
    if ((r = page_insert(env->env_pgdir, pp, va, PTE_U | perm)) < 0) {
f010486f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104872:	83 c8 04             	or     $0x4,%eax
f0104875:	50                   	push   %eax
f0104876:	ff 75 10             	pushl  0x10(%ebp)
f0104879:	56                   	push   %esi
f010487a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010487d:	ff 70 60             	pushl  0x60(%eax)
f0104880:	e8 e6 c9 ff ff       	call   f010126b <page_insert>
f0104885:	83 c4 10             	add    $0x10,%esp
f0104888:	85 c0                	test   %eax,%eax
f010488a:	0f 89 eb fd ff ff    	jns    f010467b <syscall+0x51>
        cprintf("sys_page_alloc page_insert error:%e\n", r);
f0104890:	83 ec 08             	sub    $0x8,%esp
f0104893:	50                   	push   %eax
f0104894:	68 10 87 10 f0       	push   $0xf0108710
f0104899:	e8 e1 f2 ff ff       	call   f0103b7f <cprintf>
        page_free(pp);
f010489e:	89 34 24             	mov    %esi,(%esp)
f01048a1:	e8 c8 c7 ff ff       	call   f010106e <page_free>
f01048a6:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01048a9:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01048ae:	e9 c8 fd ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_page_alloc() envid2env error:%e\n", r);
f01048b3:	83 ec 08             	sub    $0x8,%esp
f01048b6:	50                   	push   %eax
f01048b7:	68 b8 86 10 f0       	push   $0xf01086b8
f01048bc:	e8 be f2 ff ff       	call   f0103b7f <cprintf>
f01048c1:	83 c4 10             	add    $0x10,%esp
f01048c4:	e9 b2 fd ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_page_alloc page_alloc error: return NULL\n");
f01048c9:	83 ec 0c             	sub    $0xc,%esp
f01048cc:	68 e0 86 10 f0       	push   $0xf01086e0
f01048d1:	e8 a9 f2 ff ff       	call   f0103b7f <cprintf>
f01048d6:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01048d9:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01048de:	e9 98 fd ff ff       	jmp    f010467b <syscall+0x51>
        return -E_INVAL;
f01048e3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048e8:	e9 8e fd ff ff       	jmp    f010467b <syscall+0x51>
f01048ed:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048f2:	e9 84 fd ff ff       	jmp    f010467b <syscall+0x51>
f01048f7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
            return sys_page_alloc(a1, (void *) a2, a3);
f01048fc:	e9 7a fd ff ff       	jmp    f010467b <syscall+0x51>
    if ((r = envid2env(srcenvid, &srcEnv, true)) < 0) {
f0104901:	83 ec 04             	sub    $0x4,%esp
f0104904:	6a 01                	push   $0x1
f0104906:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104909:	50                   	push   %eax
f010490a:	ff 75 0c             	pushl  0xc(%ebp)
f010490d:	e8 1b e9 ff ff       	call   f010322d <envid2env>
f0104912:	89 c3                	mov    %eax,%ebx
f0104914:	83 c4 10             	add    $0x10,%esp
f0104917:	85 c0                	test   %eax,%eax
f0104919:	0f 88 c4 00 00 00    	js     f01049e3 <syscall+0x3b9>
    if ((r = envid2env(dstenvid, &dstEnv, true)) < 0) {
f010491f:	83 ec 04             	sub    $0x4,%esp
f0104922:	6a 01                	push   $0x1
f0104924:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0104927:	50                   	push   %eax
f0104928:	ff 75 14             	pushl  0x14(%ebp)
f010492b:	e8 fd e8 ff ff       	call   f010322d <envid2env>
f0104930:	89 c3                	mov    %eax,%ebx
f0104932:	83 c4 10             	add    $0x10,%esp
f0104935:	85 c0                	test   %eax,%eax
f0104937:	0f 88 bc 00 00 00    	js     f01049f9 <syscall+0x3cf>
    if (((uintptr_t) srcva >= UTOP) || ((uintptr_t) dstva >= UTOP) || ((uintptr_t) srcva % PGSIZE != 0) ||
f010493d:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104944:	0f 87 07 01 00 00    	ja     f0104a51 <syscall+0x427>
f010494a:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104951:	0f 87 fa 00 00 00    	ja     f0104a51 <syscall+0x427>
f0104957:	8b 45 10             	mov    0x10(%ebp),%eax
f010495a:	0b 45 18             	or     0x18(%ebp),%eax
f010495d:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0104962:	0f 85 f3 00 00 00    	jne    f0104a5b <syscall+0x431>
        ((uintptr_t) dstva % PGSIZE != 0) ||
f0104968:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
f010496b:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104971:	0f 85 ee 00 00 00    	jne    f0104a65 <syscall+0x43b>
    if ((pp = page_lookup(srcEnv->env_pgdir, srcva, &pte_store)) == NULL) {
f0104977:	83 ec 04             	sub    $0x4,%esp
f010497a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010497d:	50                   	push   %eax
f010497e:	ff 75 10             	pushl  0x10(%ebp)
f0104981:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104984:	ff 70 60             	pushl  0x60(%eax)
f0104987:	e8 42 c8 ff ff       	call   f01011ce <page_lookup>
f010498c:	83 c4 10             	add    $0x10,%esp
f010498f:	85 c0                	test   %eax,%eax
f0104991:	74 7c                	je     f0104a0f <syscall+0x3e5>
    if (((*pte_store & PTE_W) == 0) && ((perm & PTE_W) != 0)) {
f0104993:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104996:	8b 12                	mov    (%edx),%edx
f0104998:	f6 c2 02             	test   $0x2,%dl
f010499b:	75 0a                	jne    f01049a7 <syscall+0x37d>
f010499d:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01049a1:	0f 85 82 00 00 00    	jne    f0104a29 <syscall+0x3ff>
    if ((r = page_insert(dstEnv->env_pgdir, pp, dstva, perm | PTE_U)) < 0) {
f01049a7:	8b 55 1c             	mov    0x1c(%ebp),%edx
f01049aa:	83 ca 04             	or     $0x4,%edx
f01049ad:	52                   	push   %edx
f01049ae:	ff 75 18             	pushl  0x18(%ebp)
f01049b1:	50                   	push   %eax
f01049b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01049b5:	ff 70 60             	pushl  0x60(%eax)
f01049b8:	e8 ae c8 ff ff       	call   f010126b <page_insert>
f01049bd:	83 c4 10             	add    $0x10,%esp
f01049c0:	85 c0                	test   %eax,%eax
f01049c2:	0f 89 b3 fc ff ff    	jns    f010467b <syscall+0x51>
        cprintf("sys_page_map() page_insert error:%e\n", r);
f01049c8:	83 ec 08             	sub    $0x8,%esp
f01049cb:	50                   	push   %eax
f01049cc:	68 24 88 10 f0       	push   $0xf0108824
f01049d1:	e8 a9 f1 ff ff       	call   f0103b7f <cprintf>
f01049d6:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01049d9:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01049de:	e9 98 fc ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_page_map() envid2env(src) error:%e\n", r);
f01049e3:	83 ec 08             	sub    $0x8,%esp
f01049e6:	50                   	push   %eax
f01049e7:	68 38 87 10 f0       	push   $0xf0108738
f01049ec:	e8 8e f1 ff ff       	call   f0103b7f <cprintf>
f01049f1:	83 c4 10             	add    $0x10,%esp
f01049f4:	e9 82 fc ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_page_map() envid2env(dst) error:%e\n", r);
f01049f9:	83 ec 08             	sub    $0x8,%esp
f01049fc:	50                   	push   %eax
f01049fd:	68 60 87 10 f0       	push   $0xf0108760
f0104a02:	e8 78 f1 ff ff       	call   f0103b7f <cprintf>
f0104a07:	83 c4 10             	add    $0x10,%esp
f0104a0a:	e9 6c fc ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_page_map() page_lookup error. return NULL\n");
f0104a0f:	83 ec 0c             	sub    $0xc,%esp
f0104a12:	68 88 87 10 f0       	push   $0xf0108788
f0104a17:	e8 63 f1 ff ff       	call   f0103b7f <cprintf>
f0104a1c:	83 c4 10             	add    $0x10,%esp
        return -E_INVAL;
f0104a1f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a24:	e9 52 fc ff ff       	jmp    f010467b <syscall+0x51>
	return (pp - pages) << PGSHIFT;
f0104a29:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f0104a2f:	c1 f8 03             	sar    $0x3,%eax
f0104a32:	c1 e0 0c             	shl    $0xc,%eax
        cprintf("(perm & PTE_W), but srcva is read-only in srcenvid's address space.\tsrcva:0x%x\t*pte_store:0x%x\tpage:0x%x\n",
f0104a35:	50                   	push   %eax
f0104a36:	52                   	push   %edx
f0104a37:	ff 75 10             	pushl  0x10(%ebp)
f0104a3a:	68 b8 87 10 f0       	push   $0xf01087b8
f0104a3f:	e8 3b f1 ff ff       	call   f0103b7f <cprintf>
f0104a44:	83 c4 10             	add    $0x10,%esp
        return -E_INVAL;
f0104a47:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a4c:	e9 2a fc ff ff       	jmp    f010467b <syscall+0x51>
        return -E_INVAL;
f0104a51:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a56:	e9 20 fc ff ff       	jmp    f010467b <syscall+0x51>
f0104a5b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a60:	e9 16 fc ff ff       	jmp    f010467b <syscall+0x51>
f0104a65:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
            return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104a6a:	e9 0c fc ff ff       	jmp    f010467b <syscall+0x51>
    if ((r = envid2env(envid, &env, true)) < 0) {
f0104a6f:	83 ec 04             	sub    $0x4,%esp
f0104a72:	6a 01                	push   $0x1
f0104a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104a77:	50                   	push   %eax
f0104a78:	ff 75 0c             	pushl  0xc(%ebp)
f0104a7b:	e8 ad e7 ff ff       	call   f010322d <envid2env>
f0104a80:	89 c3                	mov    %eax,%ebx
f0104a82:	83 c4 10             	add    $0x10,%esp
f0104a85:	85 c0                	test   %eax,%eax
f0104a87:	78 30                	js     f0104ab9 <syscall+0x48f>
    if (((uintptr_t) va >= UTOP) || ((uintptr_t) va % PGSIZE != 0)) {
f0104a89:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104a90:	77 3d                	ja     f0104acf <syscall+0x4a5>
f0104a92:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104a99:	75 3e                	jne    f0104ad9 <syscall+0x4af>
    page_remove(env->env_pgdir, va);
f0104a9b:	83 ec 08             	sub    $0x8,%esp
f0104a9e:	ff 75 10             	pushl  0x10(%ebp)
f0104aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104aa4:	ff 70 60             	pushl  0x60(%eax)
f0104aa7:	e8 7c c7 ff ff       	call   f0101228 <page_remove>
f0104aac:	83 c4 10             	add    $0x10,%esp
    return 0;
f0104aaf:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104ab4:	e9 c2 fb ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_page_unmap() envid2env error:%e\n", r);
f0104ab9:	83 ec 08             	sub    $0x8,%esp
f0104abc:	50                   	push   %eax
f0104abd:	68 4c 88 10 f0       	push   $0xf010884c
f0104ac2:	e8 b8 f0 ff ff       	call   f0103b7f <cprintf>
f0104ac7:	83 c4 10             	add    $0x10,%esp
f0104aca:	e9 ac fb ff ff       	jmp    f010467b <syscall+0x51>
        return -E_INVAL;
f0104acf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ad4:	e9 a2 fb ff ff       	jmp    f010467b <syscall+0x51>
f0104ad9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
            return sys_page_unmap(a1, (void *) a2);
f0104ade:	e9 98 fb ff ff       	jmp    f010467b <syscall+0x51>
    if ((r = envid2env(envid, &env, true)) < 0) {
f0104ae3:	83 ec 04             	sub    $0x4,%esp
f0104ae6:	6a 01                	push   $0x1
f0104ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104aeb:	50                   	push   %eax
f0104aec:	ff 75 0c             	pushl  0xc(%ebp)
f0104aef:	e8 39 e7 ff ff       	call   f010322d <envid2env>
f0104af4:	89 c3                	mov    %eax,%ebx
f0104af6:	83 c4 10             	add    $0x10,%esp
f0104af9:	85 c0                	test   %eax,%eax
f0104afb:	78 13                	js     f0104b10 <syscall+0x4e6>
    env->env_pgfault_upcall = func;
f0104afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104b03:	89 48 64             	mov    %ecx,0x64(%eax)
    return 0;
f0104b06:	bb 00 00 00 00       	mov    $0x0,%ebx
            return sys_env_set_pgfault_upcall(a1, (void *) a2);
f0104b0b:	e9 6b fb ff ff       	jmp    f010467b <syscall+0x51>
        cprintf("sys_env_set_pgfault_upcall() envid2env error:%e", r);
f0104b10:	83 ec 08             	sub    $0x8,%esp
f0104b13:	50                   	push   %eax
f0104b14:	68 74 88 10 f0       	push   $0xf0108874
f0104b19:	e8 61 f0 ff ff       	call   f0103b7f <cprintf>
f0104b1e:	83 c4 10             	add    $0x10,%esp
f0104b21:	e9 55 fb ff ff       	jmp    f010467b <syscall+0x51>
            return -E_INVAL;
f0104b26:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b2b:	e9 4b fb ff ff       	jmp    f010467b <syscall+0x51>

f0104b30 <stab_binsearch>:
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr) {
f0104b30:	55                   	push   %ebp
f0104b31:	89 e5                	mov    %esp,%ebp
f0104b33:	57                   	push   %edi
f0104b34:	56                   	push   %esi
f0104b35:	53                   	push   %ebx
f0104b36:	83 ec 14             	sub    $0x14,%esp
f0104b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104b3c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104b3f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104b42:	8b 7d 08             	mov    0x8(%ebp),%edi
    int l = *region_left, r = *region_right, any_matches = 0;
f0104b45:	8b 32                	mov    (%edx),%esi
f0104b47:	8b 01                	mov    (%ecx),%eax
f0104b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104b4c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    while (l <= r) {
f0104b53:	eb 2f                	jmp    f0104b84 <stab_binsearch+0x54>
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
f0104b55:	83 e8 01             	sub    $0x1,%eax
        while (m >= l && stabs[m].n_type != type)
f0104b58:	39 c6                	cmp    %eax,%esi
f0104b5a:	7f 49                	jg     f0104ba5 <stab_binsearch+0x75>
f0104b5c:	0f b6 0a             	movzbl (%edx),%ecx
f0104b5f:	83 ea 0c             	sub    $0xc,%edx
f0104b62:	39 f9                	cmp    %edi,%ecx
f0104b64:	75 ef                	jne    f0104b55 <stab_binsearch+0x25>
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
f0104b66:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104b69:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104b6c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104b70:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104b73:	73 35                	jae    f0104baa <stab_binsearch+0x7a>
            *region_left = m;
f0104b75:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104b78:	89 06                	mov    %eax,(%esi)
            l = true_m + 1;
f0104b7a:	8d 73 01             	lea    0x1(%ebx),%esi
        any_matches = 1;
f0104b7d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while (l <= r) {
f0104b84:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104b87:	7f 4e                	jg     f0104bd7 <stab_binsearch+0xa7>
        int true_m = (l + r) / 2, m = true_m;
f0104b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104b8c:	01 f0                	add    %esi,%eax
f0104b8e:	89 c3                	mov    %eax,%ebx
f0104b90:	c1 eb 1f             	shr    $0x1f,%ebx
f0104b93:	01 c3                	add    %eax,%ebx
f0104b95:	d1 fb                	sar    %ebx
f0104b97:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104b9a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104b9d:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104ba1:	89 d8                	mov    %ebx,%eax
        while (m >= l && stabs[m].n_type != type)
f0104ba3:	eb b3                	jmp    f0104b58 <stab_binsearch+0x28>
            l = true_m + 1;
f0104ba5:	8d 73 01             	lea    0x1(%ebx),%esi
            continue;
f0104ba8:	eb da                	jmp    f0104b84 <stab_binsearch+0x54>
        } else if (stabs[m].n_value > addr) {
f0104baa:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104bad:	76 14                	jbe    f0104bc3 <stab_binsearch+0x93>
            *region_right = m - 1;
f0104baf:	83 e8 01             	sub    $0x1,%eax
f0104bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104bb5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104bb8:	89 03                	mov    %eax,(%ebx)
        any_matches = 1;
f0104bba:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104bc1:	eb c1                	jmp    f0104b84 <stab_binsearch+0x54>
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
f0104bc3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104bc6:	89 06                	mov    %eax,(%esi)
            l = m;
            addr++;
f0104bc8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104bcc:	89 c6                	mov    %eax,%esi
        any_matches = 1;
f0104bce:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104bd5:	eb ad                	jmp    f0104b84 <stab_binsearch+0x54>
        }
    }

    if (!any_matches)
f0104bd7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104bdb:	74 16                	je     f0104bf3 <stab_binsearch+0xc3>
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
f0104bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104be0:	8b 00                	mov    (%eax),%eax
             l > *region_left && stabs[l].n_type != type;
f0104be2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104be5:	8b 0e                	mov    (%esi),%ecx
f0104be7:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104bea:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104bed:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
        for (l = *region_right;
f0104bf1:	eb 12                	jmp    f0104c05 <stab_binsearch+0xd5>
        *region_right = *region_left - 1;
f0104bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104bf6:	8b 00                	mov    (%eax),%eax
f0104bf8:	83 e8 01             	sub    $0x1,%eax
f0104bfb:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104bfe:	89 07                	mov    %eax,(%edi)
f0104c00:	eb 16                	jmp    f0104c18 <stab_binsearch+0xe8>
             l--)
f0104c02:	83 e8 01             	sub    $0x1,%eax
        for (l = *region_right;
f0104c05:	39 c1                	cmp    %eax,%ecx
f0104c07:	7d 0a                	jge    f0104c13 <stab_binsearch+0xe3>
             l > *region_left && stabs[l].n_type != type;
f0104c09:	0f b6 1a             	movzbl (%edx),%ebx
f0104c0c:	83 ea 0c             	sub    $0xc,%edx
f0104c0f:	39 fb                	cmp    %edi,%ebx
f0104c11:	75 ef                	jne    f0104c02 <stab_binsearch+0xd2>
            /* do nothing */;
        *region_left = l;
f0104c13:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c16:	89 07                	mov    %eax,(%edi)
    }
}
f0104c18:	83 c4 14             	add    $0x14,%esp
f0104c1b:	5b                   	pop    %ebx
f0104c1c:	5e                   	pop    %esi
f0104c1d:	5f                   	pop    %edi
f0104c1e:	5d                   	pop    %ebp
f0104c1f:	c3                   	ret    

f0104c20 <debuginfo_eip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info) {
f0104c20:	55                   	push   %ebp
f0104c21:	89 e5                	mov    %esp,%ebp
f0104c23:	57                   	push   %edi
f0104c24:	56                   	push   %esi
f0104c25:	53                   	push   %ebx
f0104c26:	83 ec 3c             	sub    $0x3c,%esp
f0104c29:	8b 75 08             	mov    0x8(%ebp),%esi
f0104c2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    const struct Stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->eip_file = "<unknown>";
f0104c2f:	c7 03 d0 88 10 f0    	movl   $0xf01088d0,(%ebx)
    info->eip_line = 0;
f0104c35:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    info->eip_fn_name = "<unknown>";
f0104c3c:	c7 43 08 d0 88 10 f0 	movl   $0xf01088d0,0x8(%ebx)
    info->eip_fn_namelen = 9;
f0104c43:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
    info->eip_fn_addr = addr;
f0104c4a:	89 73 10             	mov    %esi,0x10(%ebx)
    info->eip_fn_narg = 0;
f0104c4d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

    // Find the relevant set of stabs
    if (addr >= ULIM) {
f0104c54:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0104c5a:	0f 86 2a 01 00 00    	jbe    f0104d8a <debuginfo_eip+0x16a>
        // Can't search for user-level addresses yet!
        panic("User address");
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104c60:	b8 20 7f 11 f0       	mov    $0xf0117f20,%eax
f0104c65:	3d 49 47 11 f0       	cmp    $0xf0114749,%eax
f0104c6a:	0f 86 b9 01 00 00    	jbe    f0104e29 <debuginfo_eip+0x209>
f0104c70:	80 3d 1f 7f 11 f0 00 	cmpb   $0x0,0xf0117f1f
f0104c77:	0f 85 b3 01 00 00    	jne    f0104e30 <debuginfo_eip+0x210>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
f0104c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    rfile = (stab_end - stabs) - 1;
f0104c84:	b8 48 47 11 f0       	mov    $0xf0114748,%eax
f0104c89:	2d e4 8d 10 f0       	sub    $0xf0108de4,%eax
f0104c8e:	c1 f8 02             	sar    $0x2,%eax
f0104c91:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104c97:	83 e8 01             	sub    $0x1,%eax
f0104c9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104c9d:	83 ec 08             	sub    $0x8,%esp
f0104ca0:	56                   	push   %esi
f0104ca1:	6a 64                	push   $0x64
f0104ca3:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0104ca6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104ca9:	b8 e4 8d 10 f0       	mov    $0xf0108de4,%eax
f0104cae:	e8 7d fe ff ff       	call   f0104b30 <stab_binsearch>
    if (lfile == 0)
f0104cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104cb6:	83 c4 10             	add    $0x10,%esp
f0104cb9:	85 c0                	test   %eax,%eax
f0104cbb:	0f 84 76 01 00 00    	je     f0104e37 <debuginfo_eip+0x217>
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
f0104cc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    rfun = rfile;
f0104cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104cc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104cca:	83 ec 08             	sub    $0x8,%esp
f0104ccd:	56                   	push   %esi
f0104cce:	6a 24                	push   $0x24
f0104cd0:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0104cd3:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104cd6:	b8 e4 8d 10 f0       	mov    $0xf0108de4,%eax
f0104cdb:	e8 50 fe ff ff       	call   f0104b30 <stab_binsearch>

    if (lfun <= rfun) {
f0104ce0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104ce3:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104ce6:	83 c4 10             	add    $0x10,%esp
f0104ce9:	39 d0                	cmp    %edx,%eax
f0104ceb:	0f 8f ad 00 00 00    	jg     f0104d9e <debuginfo_eip+0x17e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104cf1:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104cf4:	c1 e1 02             	shl    $0x2,%ecx
f0104cf7:	8d b9 e4 8d 10 f0    	lea    -0xfef721c(%ecx),%edi
f0104cfd:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0104d00:	8b b9 e4 8d 10 f0    	mov    -0xfef721c(%ecx),%edi
f0104d06:	b9 20 7f 11 f0       	mov    $0xf0117f20,%ecx
f0104d0b:	81 e9 49 47 11 f0    	sub    $0xf0114749,%ecx
f0104d11:	39 cf                	cmp    %ecx,%edi
f0104d13:	73 09                	jae    f0104d1e <debuginfo_eip+0xfe>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104d15:	81 c7 49 47 11 f0    	add    $0xf0114749,%edi
f0104d1b:	89 7b 08             	mov    %edi,0x8(%ebx)
        info->eip_fn_addr = stabs[lfun].n_value;
f0104d1e:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104d21:	8b 4f 08             	mov    0x8(%edi),%ecx
f0104d24:	89 4b 10             	mov    %ecx,0x10(%ebx)
        addr -= info->eip_fn_addr;
f0104d27:	29 ce                	sub    %ecx,%esi
        // Search within the function definition for the line number.
        lline = lfun;
f0104d29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
f0104d2c:	89 55 d0             	mov    %edx,-0x30(%ebp)
        info->eip_fn_addr = addr;
        lline = lfile;
        rline = rfile;
    }
    // Ignore stuff after the colon.
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104d2f:	83 ec 08             	sub    $0x8,%esp
f0104d32:	6a 3a                	push   $0x3a
f0104d34:	ff 73 08             	pushl  0x8(%ebx)
f0104d37:	e8 60 09 00 00       	call   f010569c <strfind>
f0104d3c:	2b 43 08             	sub    0x8(%ebx),%eax
f0104d3f:	89 43 0c             	mov    %eax,0xc(%ebx)
    // Hint:
    //	There's a particular stabs type used for line numbers.
    //	Look at the STABS documentation and <inc/stab.h> to find
    //	which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, info->eip_fn_addr + addr);
f0104d42:	83 c4 08             	add    $0x8,%esp
f0104d45:	03 73 10             	add    0x10(%ebx),%esi
f0104d48:	56                   	push   %esi
f0104d49:	6a 44                	push   $0x44
f0104d4b:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104d4e:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104d51:	b8 e4 8d 10 f0       	mov    $0xf0108de4,%eax
f0104d56:	e8 d5 fd ff ff       	call   f0104b30 <stab_binsearch>
    info->eip_line = lline > rline ? -1 : stabs[lline].n_desc;
f0104d5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104d5e:	83 c4 10             	add    $0x10,%esp
f0104d61:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104d66:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0104d69:	7f 0b                	jg     f0104d76 <debuginfo_eip+0x156>
f0104d6b:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104d6e:	0f b7 14 95 ea 8d 10 	movzwl -0xfef7216(,%edx,4),%edx
f0104d75:	f0 
f0104d76:	89 53 04             	mov    %edx,0x4(%ebx)
    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
f0104d79:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d7c:	89 c2                	mov    %eax,%edx
f0104d7e:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104d81:	8d 04 85 e8 8d 10 f0 	lea    -0xfef7218(,%eax,4),%eax
f0104d88:	eb 2b                	jmp    f0104db5 <debuginfo_eip+0x195>
        panic("User address");
f0104d8a:	83 ec 04             	sub    $0x4,%esp
f0104d8d:	68 da 88 10 f0       	push   $0xf01088da
f0104d92:	6a 7d                	push   $0x7d
f0104d94:	68 e7 88 10 f0       	push   $0xf01088e7
f0104d99:	e8 a2 b2 ff ff       	call   f0100040 <_panic>
        info->eip_fn_addr = addr;
f0104d9e:	89 73 10             	mov    %esi,0x10(%ebx)
        lline = lfile;
f0104da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104da4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
f0104da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104daa:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104dad:	eb 80                	jmp    f0104d2f <debuginfo_eip+0x10f>
f0104daf:	83 ea 01             	sub    $0x1,%edx
f0104db2:	83 e8 0c             	sub    $0xc,%eax
    while (lline >= lfile
f0104db5:	39 d7                	cmp    %edx,%edi
f0104db7:	7f 33                	jg     f0104dec <debuginfo_eip+0x1cc>
           && stabs[lline].n_type != N_SOL
f0104db9:	0f b6 08             	movzbl (%eax),%ecx
f0104dbc:	80 f9 84             	cmp    $0x84,%cl
f0104dbf:	74 0b                	je     f0104dcc <debuginfo_eip+0x1ac>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104dc1:	80 f9 64             	cmp    $0x64,%cl
f0104dc4:	75 e9                	jne    f0104daf <debuginfo_eip+0x18f>
f0104dc6:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0104dca:	74 e3                	je     f0104daf <debuginfo_eip+0x18f>
        lline--;
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104dcc:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104dcf:	8b 14 85 e4 8d 10 f0 	mov    -0xfef721c(,%eax,4),%edx
f0104dd6:	b8 20 7f 11 f0       	mov    $0xf0117f20,%eax
f0104ddb:	2d 49 47 11 f0       	sub    $0xf0114749,%eax
f0104de0:	39 c2                	cmp    %eax,%edx
f0104de2:	73 08                	jae    f0104dec <debuginfo_eip+0x1cc>
        info->eip_file = stabstr + stabs[lline].n_strx;
f0104de4:	81 c2 49 47 11 f0    	add    $0xf0114749,%edx
f0104dea:	89 13                	mov    %edx,(%ebx)


    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
f0104dec:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104def:	8b 75 d8             	mov    -0x28(%ebp),%esi
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
            info->eip_fn_narg++;

    return 0;
f0104df2:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lfun < rfun)
f0104df7:	39 f2                	cmp    %esi,%edx
f0104df9:	7d 48                	jge    f0104e43 <debuginfo_eip+0x223>
        for (lline = lfun + 1;
f0104dfb:	83 c2 01             	add    $0x1,%edx
f0104dfe:	89 d0                	mov    %edx,%eax
f0104e00:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104e03:	8d 14 95 e8 8d 10 f0 	lea    -0xfef7218(,%edx,4),%edx
f0104e0a:	eb 04                	jmp    f0104e10 <debuginfo_eip+0x1f0>
            info->eip_fn_narg++;
f0104e0c:	83 43 14 01          	addl   $0x1,0x14(%ebx)
        for (lline = lfun + 1;
f0104e10:	39 c6                	cmp    %eax,%esi
f0104e12:	7e 2a                	jle    f0104e3e <debuginfo_eip+0x21e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
f0104e14:	0f b6 0a             	movzbl (%edx),%ecx
f0104e17:	83 c0 01             	add    $0x1,%eax
f0104e1a:	83 c2 0c             	add    $0xc,%edx
f0104e1d:	80 f9 a0             	cmp    $0xa0,%cl
f0104e20:	74 ea                	je     f0104e0c <debuginfo_eip+0x1ec>
    return 0;
f0104e22:	b8 00 00 00 00       	mov    $0x0,%eax
f0104e27:	eb 1a                	jmp    f0104e43 <debuginfo_eip+0x223>
        return -1;
f0104e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104e2e:	eb 13                	jmp    f0104e43 <debuginfo_eip+0x223>
f0104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104e35:	eb 0c                	jmp    f0104e43 <debuginfo_eip+0x223>
        return -1;
f0104e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104e3c:	eb 05                	jmp    f0104e43 <debuginfo_eip+0x223>
    return 0;
f0104e3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e46:	5b                   	pop    %ebx
f0104e47:	5e                   	pop    %esi
f0104e48:	5f                   	pop    %edi
f0104e49:	5d                   	pop    %ebp
f0104e4a:	c3                   	ret    

f0104e4b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104e4b:	55                   	push   %ebp
f0104e4c:	89 e5                	mov    %esp,%ebp
f0104e4e:	57                   	push   %edi
f0104e4f:	56                   	push   %esi
f0104e50:	53                   	push   %ebx
f0104e51:	83 ec 1c             	sub    $0x1c,%esp
f0104e54:	89 c7                	mov    %eax,%edi
f0104e56:	89 d6                	mov    %edx,%esi
f0104e58:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104e5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104e61:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
f0104e64:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104e67:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104e6c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104e6f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104e72:	39 d3                	cmp    %edx,%ebx
f0104e74:	72 05                	jb     f0104e7b <printnum+0x30>
f0104e76:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104e79:	77 7a                	ja     f0104ef5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104e7b:	83 ec 0c             	sub    $0xc,%esp
f0104e7e:	ff 75 18             	pushl  0x18(%ebp)
f0104e81:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e84:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104e87:	53                   	push   %ebx
f0104e88:	ff 75 10             	pushl  0x10(%ebp)
f0104e8b:	83 ec 08             	sub    $0x8,%esp
f0104e8e:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104e91:	ff 75 e0             	pushl  -0x20(%ebp)
f0104e94:	ff 75 dc             	pushl  -0x24(%ebp)
f0104e97:	ff 75 d8             	pushl  -0x28(%ebp)
f0104e9a:	e8 51 12 00 00       	call   f01060f0 <__udivdi3>
f0104e9f:	83 c4 18             	add    $0x18,%esp
f0104ea2:	52                   	push   %edx
f0104ea3:	50                   	push   %eax
f0104ea4:	89 f2                	mov    %esi,%edx
f0104ea6:	89 f8                	mov    %edi,%eax
f0104ea8:	e8 9e ff ff ff       	call   f0104e4b <printnum>
f0104ead:	83 c4 20             	add    $0x20,%esp
f0104eb0:	eb 13                	jmp    f0104ec5 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104eb2:	83 ec 08             	sub    $0x8,%esp
f0104eb5:	56                   	push   %esi
f0104eb6:	ff 75 18             	pushl  0x18(%ebp)
f0104eb9:	ff d7                	call   *%edi
f0104ebb:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104ebe:	83 eb 01             	sub    $0x1,%ebx
f0104ec1:	85 db                	test   %ebx,%ebx
f0104ec3:	7f ed                	jg     f0104eb2 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104ec5:	83 ec 08             	sub    $0x8,%esp
f0104ec8:	56                   	push   %esi
f0104ec9:	83 ec 04             	sub    $0x4,%esp
f0104ecc:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104ecf:	ff 75 e0             	pushl  -0x20(%ebp)
f0104ed2:	ff 75 dc             	pushl  -0x24(%ebp)
f0104ed5:	ff 75 d8             	pushl  -0x28(%ebp)
f0104ed8:	e8 33 13 00 00       	call   f0106210 <__umoddi3>
f0104edd:	83 c4 14             	add    $0x14,%esp
f0104ee0:	0f be 80 f5 88 10 f0 	movsbl -0xfef770b(%eax),%eax
f0104ee7:	50                   	push   %eax
f0104ee8:	ff d7                	call   *%edi
}
f0104eea:	83 c4 10             	add    $0x10,%esp
f0104eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104ef0:	5b                   	pop    %ebx
f0104ef1:	5e                   	pop    %esi
f0104ef2:	5f                   	pop    %edi
f0104ef3:	5d                   	pop    %ebp
f0104ef4:	c3                   	ret    
f0104ef5:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104ef8:	eb c4                	jmp    f0104ebe <printnum+0x73>

f0104efa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0104efa:	55                   	push   %ebp
f0104efb:	89 e5                	mov    %esp,%ebp
f0104efd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104f00:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104f04:	8b 10                	mov    (%eax),%edx
f0104f06:	3b 50 04             	cmp    0x4(%eax),%edx
f0104f09:	73 0a                	jae    f0104f15 <sprintputch+0x1b>
		*b->buf++ = ch;
f0104f0b:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104f0e:	89 08                	mov    %ecx,(%eax)
f0104f10:	8b 45 08             	mov    0x8(%ebp),%eax
f0104f13:	88 02                	mov    %al,(%edx)
}
f0104f15:	5d                   	pop    %ebp
f0104f16:	c3                   	ret    

f0104f17 <printfmt>:
{
f0104f17:	55                   	push   %ebp
f0104f18:	89 e5                	mov    %esp,%ebp
f0104f1a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0104f1d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104f20:	50                   	push   %eax
f0104f21:	ff 75 10             	pushl  0x10(%ebp)
f0104f24:	ff 75 0c             	pushl  0xc(%ebp)
f0104f27:	ff 75 08             	pushl  0x8(%ebp)
f0104f2a:	e8 05 00 00 00       	call   f0104f34 <vprintfmt>
}
f0104f2f:	83 c4 10             	add    $0x10,%esp
f0104f32:	c9                   	leave  
f0104f33:	c3                   	ret    

f0104f34 <vprintfmt>:
{
f0104f34:	55                   	push   %ebp
f0104f35:	89 e5                	mov    %esp,%ebp
f0104f37:	57                   	push   %edi
f0104f38:	56                   	push   %esi
f0104f39:	53                   	push   %ebx
f0104f3a:	83 ec 2c             	sub    $0x2c,%esp
f0104f3d:	8b 75 08             	mov    0x8(%ebp),%esi
f0104f40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104f43:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104f46:	e9 00 04 00 00       	jmp    f010534b <vprintfmt+0x417>
		padc = ' ';
f0104f4b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0104f4f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104f56:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f0104f5d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0104f64:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104f69:	8d 47 01             	lea    0x1(%edi),%eax
f0104f6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104f6f:	0f b6 17             	movzbl (%edi),%edx
f0104f72:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104f75:	3c 55                	cmp    $0x55,%al
f0104f77:	0f 87 51 04 00 00    	ja     f01053ce <vprintfmt+0x49a>
f0104f7d:	0f b6 c0             	movzbl %al,%eax
f0104f80:	ff 24 85 c0 89 10 f0 	jmp    *-0xfef7640(,%eax,4)
f0104f87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0104f8a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0104f8e:	eb d9                	jmp    f0104f69 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104f90:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0104f93:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104f97:	eb d0                	jmp    f0104f69 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104f99:	0f b6 d2             	movzbl %dl,%edx
f0104f9c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104f9f:	b8 00 00 00 00       	mov    $0x0,%eax
f0104fa4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0104fa7:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104faa:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104fae:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104fb1:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104fb4:	83 f9 09             	cmp    $0x9,%ecx
f0104fb7:	77 55                	ja     f010500e <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f0104fb9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0104fbc:	eb e9                	jmp    f0104fa7 <vprintfmt+0x73>
			precision = va_arg(ap, int);
f0104fbe:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fc1:	8b 00                	mov    (%eax),%eax
f0104fc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104fc6:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fc9:	8d 40 04             	lea    0x4(%eax),%eax
f0104fcc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104fcf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0104fd2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104fd6:	79 91                	jns    f0104f69 <vprintfmt+0x35>
				width = precision, precision = -1;
f0104fd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104fdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104fde:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0104fe5:	eb 82                	jmp    f0104f69 <vprintfmt+0x35>
f0104fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104fea:	85 c0                	test   %eax,%eax
f0104fec:	ba 00 00 00 00       	mov    $0x0,%edx
f0104ff1:	0f 49 d0             	cmovns %eax,%edx
f0104ff4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104ff7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ffa:	e9 6a ff ff ff       	jmp    f0104f69 <vprintfmt+0x35>
f0104fff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105002:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0105009:	e9 5b ff ff ff       	jmp    f0104f69 <vprintfmt+0x35>
f010500e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105011:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105014:	eb bc                	jmp    f0104fd2 <vprintfmt+0x9e>
			lflag++;
f0105016:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105019:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010501c:	e9 48 ff ff ff       	jmp    f0104f69 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f0105021:	8b 45 14             	mov    0x14(%ebp),%eax
f0105024:	8d 78 04             	lea    0x4(%eax),%edi
f0105027:	83 ec 08             	sub    $0x8,%esp
f010502a:	53                   	push   %ebx
f010502b:	ff 30                	pushl  (%eax)
f010502d:	ff d6                	call   *%esi
			break;
f010502f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105032:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105035:	e9 0e 03 00 00       	jmp    f0105348 <vprintfmt+0x414>
			err = va_arg(ap, int);
f010503a:	8b 45 14             	mov    0x14(%ebp),%eax
f010503d:	8d 78 04             	lea    0x4(%eax),%edi
f0105040:	8b 00                	mov    (%eax),%eax
f0105042:	99                   	cltd   
f0105043:	31 d0                	xor    %edx,%eax
f0105045:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105047:	83 f8 08             	cmp    $0x8,%eax
f010504a:	7f 23                	jg     f010506f <vprintfmt+0x13b>
f010504c:	8b 14 85 20 8b 10 f0 	mov    -0xfef74e0(,%eax,4),%edx
f0105053:	85 d2                	test   %edx,%edx
f0105055:	74 18                	je     f010506f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f0105057:	52                   	push   %edx
f0105058:	68 33 77 10 f0       	push   $0xf0107733
f010505d:	53                   	push   %ebx
f010505e:	56                   	push   %esi
f010505f:	e8 b3 fe ff ff       	call   f0104f17 <printfmt>
f0105064:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105067:	89 7d 14             	mov    %edi,0x14(%ebp)
f010506a:	e9 d9 02 00 00       	jmp    f0105348 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
f010506f:	50                   	push   %eax
f0105070:	68 0d 89 10 f0       	push   $0xf010890d
f0105075:	53                   	push   %ebx
f0105076:	56                   	push   %esi
f0105077:	e8 9b fe ff ff       	call   f0104f17 <printfmt>
f010507c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010507f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105082:	e9 c1 02 00 00       	jmp    f0105348 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
f0105087:	8b 45 14             	mov    0x14(%ebp),%eax
f010508a:	83 c0 04             	add    $0x4,%eax
f010508d:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0105090:	8b 45 14             	mov    0x14(%ebp),%eax
f0105093:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0105095:	85 ff                	test   %edi,%edi
f0105097:	b8 06 89 10 f0       	mov    $0xf0108906,%eax
f010509c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f010509f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01050a3:	0f 8e bd 00 00 00    	jle    f0105166 <vprintfmt+0x232>
f01050a9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f01050ad:	75 0e                	jne    f01050bd <vprintfmt+0x189>
f01050af:	89 75 08             	mov    %esi,0x8(%ebp)
f01050b2:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01050b5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01050b8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01050bb:	eb 6d                	jmp    f010512a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f01050bd:	83 ec 08             	sub    $0x8,%esp
f01050c0:	ff 75 d0             	pushl  -0x30(%ebp)
f01050c3:	57                   	push   %edi
f01050c4:	e8 8f 04 00 00       	call   f0105558 <strnlen>
f01050c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01050cc:	29 c1                	sub    %eax,%ecx
f01050ce:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f01050d1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f01050d4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f01050d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01050db:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01050de:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f01050e0:	eb 0f                	jmp    f01050f1 <vprintfmt+0x1bd>
					putch(padc, putdat);
f01050e2:	83 ec 08             	sub    $0x8,%esp
f01050e5:	53                   	push   %ebx
f01050e6:	ff 75 e0             	pushl  -0x20(%ebp)
f01050e9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01050eb:	83 ef 01             	sub    $0x1,%edi
f01050ee:	83 c4 10             	add    $0x10,%esp
f01050f1:	85 ff                	test   %edi,%edi
f01050f3:	7f ed                	jg     f01050e2 <vprintfmt+0x1ae>
f01050f5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01050f8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01050fb:	85 c9                	test   %ecx,%ecx
f01050fd:	b8 00 00 00 00       	mov    $0x0,%eax
f0105102:	0f 49 c1             	cmovns %ecx,%eax
f0105105:	29 c1                	sub    %eax,%ecx
f0105107:	89 75 08             	mov    %esi,0x8(%ebp)
f010510a:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010510d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105110:	89 cb                	mov    %ecx,%ebx
f0105112:	eb 16                	jmp    f010512a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f0105114:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105118:	75 31                	jne    f010514b <vprintfmt+0x217>
					putch(ch, putdat);
f010511a:	83 ec 08             	sub    $0x8,%esp
f010511d:	ff 75 0c             	pushl  0xc(%ebp)
f0105120:	50                   	push   %eax
f0105121:	ff 55 08             	call   *0x8(%ebp)
f0105124:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105127:	83 eb 01             	sub    $0x1,%ebx
f010512a:	83 c7 01             	add    $0x1,%edi
f010512d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0105131:	0f be c2             	movsbl %dl,%eax
f0105134:	85 c0                	test   %eax,%eax
f0105136:	74 59                	je     f0105191 <vprintfmt+0x25d>
f0105138:	85 f6                	test   %esi,%esi
f010513a:	78 d8                	js     f0105114 <vprintfmt+0x1e0>
f010513c:	83 ee 01             	sub    $0x1,%esi
f010513f:	79 d3                	jns    f0105114 <vprintfmt+0x1e0>
f0105141:	89 df                	mov    %ebx,%edi
f0105143:	8b 75 08             	mov    0x8(%ebp),%esi
f0105146:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105149:	eb 37                	jmp    f0105182 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f010514b:	0f be d2             	movsbl %dl,%edx
f010514e:	83 ea 20             	sub    $0x20,%edx
f0105151:	83 fa 5e             	cmp    $0x5e,%edx
f0105154:	76 c4                	jbe    f010511a <vprintfmt+0x1e6>
					putch('?', putdat);
f0105156:	83 ec 08             	sub    $0x8,%esp
f0105159:	ff 75 0c             	pushl  0xc(%ebp)
f010515c:	6a 3f                	push   $0x3f
f010515e:	ff 55 08             	call   *0x8(%ebp)
f0105161:	83 c4 10             	add    $0x10,%esp
f0105164:	eb c1                	jmp    f0105127 <vprintfmt+0x1f3>
f0105166:	89 75 08             	mov    %esi,0x8(%ebp)
f0105169:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010516c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f010516f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0105172:	eb b6                	jmp    f010512a <vprintfmt+0x1f6>
				putch(' ', putdat);
f0105174:	83 ec 08             	sub    $0x8,%esp
f0105177:	53                   	push   %ebx
f0105178:	6a 20                	push   $0x20
f010517a:	ff d6                	call   *%esi
			for (; width > 0; width--)
f010517c:	83 ef 01             	sub    $0x1,%edi
f010517f:	83 c4 10             	add    $0x10,%esp
f0105182:	85 ff                	test   %edi,%edi
f0105184:	7f ee                	jg     f0105174 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f0105186:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105189:	89 45 14             	mov    %eax,0x14(%ebp)
f010518c:	e9 b7 01 00 00       	jmp    f0105348 <vprintfmt+0x414>
f0105191:	89 df                	mov    %ebx,%edi
f0105193:	8b 75 08             	mov    0x8(%ebp),%esi
f0105196:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105199:	eb e7                	jmp    f0105182 <vprintfmt+0x24e>
	if (lflag >= 2)
f010519b:	83 f9 01             	cmp    $0x1,%ecx
f010519e:	7e 3f                	jle    f01051df <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f01051a0:	8b 45 14             	mov    0x14(%ebp),%eax
f01051a3:	8b 50 04             	mov    0x4(%eax),%edx
f01051a6:	8b 00                	mov    (%eax),%eax
f01051a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01051ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01051b1:	8d 40 08             	lea    0x8(%eax),%eax
f01051b4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01051b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01051bb:	79 5c                	jns    f0105219 <vprintfmt+0x2e5>
				putch('-', putdat);
f01051bd:	83 ec 08             	sub    $0x8,%esp
f01051c0:	53                   	push   %ebx
f01051c1:	6a 2d                	push   $0x2d
f01051c3:	ff d6                	call   *%esi
				num = -(long long) num;
f01051c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01051c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01051cb:	f7 da                	neg    %edx
f01051cd:	83 d1 00             	adc    $0x0,%ecx
f01051d0:	f7 d9                	neg    %ecx
f01051d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01051d5:	b8 0a 00 00 00       	mov    $0xa,%eax
f01051da:	e9 4f 01 00 00       	jmp    f010532e <vprintfmt+0x3fa>
	else if (lflag)
f01051df:	85 c9                	test   %ecx,%ecx
f01051e1:	75 1b                	jne    f01051fe <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f01051e3:	8b 45 14             	mov    0x14(%ebp),%eax
f01051e6:	8b 00                	mov    (%eax),%eax
f01051e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051eb:	89 c1                	mov    %eax,%ecx
f01051ed:	c1 f9 1f             	sar    $0x1f,%ecx
f01051f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01051f3:	8b 45 14             	mov    0x14(%ebp),%eax
f01051f6:	8d 40 04             	lea    0x4(%eax),%eax
f01051f9:	89 45 14             	mov    %eax,0x14(%ebp)
f01051fc:	eb b9                	jmp    f01051b7 <vprintfmt+0x283>
		return va_arg(*ap, long);
f01051fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0105201:	8b 00                	mov    (%eax),%eax
f0105203:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105206:	89 c1                	mov    %eax,%ecx
f0105208:	c1 f9 1f             	sar    $0x1f,%ecx
f010520b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010520e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105211:	8d 40 04             	lea    0x4(%eax),%eax
f0105214:	89 45 14             	mov    %eax,0x14(%ebp)
f0105217:	eb 9e                	jmp    f01051b7 <vprintfmt+0x283>
			num = getint(&ap, lflag);
f0105219:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010521c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f010521f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105224:	e9 05 01 00 00       	jmp    f010532e <vprintfmt+0x3fa>
	if (lflag >= 2)
f0105229:	83 f9 01             	cmp    $0x1,%ecx
f010522c:	7e 18                	jle    f0105246 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
f010522e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105231:	8b 10                	mov    (%eax),%edx
f0105233:	8b 48 04             	mov    0x4(%eax),%ecx
f0105236:	8d 40 08             	lea    0x8(%eax),%eax
f0105239:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010523c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105241:	e9 e8 00 00 00       	jmp    f010532e <vprintfmt+0x3fa>
	else if (lflag)
f0105246:	85 c9                	test   %ecx,%ecx
f0105248:	75 1a                	jne    f0105264 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
f010524a:	8b 45 14             	mov    0x14(%ebp),%eax
f010524d:	8b 10                	mov    (%eax),%edx
f010524f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105254:	8d 40 04             	lea    0x4(%eax),%eax
f0105257:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010525a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010525f:	e9 ca 00 00 00       	jmp    f010532e <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
f0105264:	8b 45 14             	mov    0x14(%ebp),%eax
f0105267:	8b 10                	mov    (%eax),%edx
f0105269:	b9 00 00 00 00       	mov    $0x0,%ecx
f010526e:	8d 40 04             	lea    0x4(%eax),%eax
f0105271:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105274:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105279:	e9 b0 00 00 00       	jmp    f010532e <vprintfmt+0x3fa>
	if (lflag >= 2)
f010527e:	83 f9 01             	cmp    $0x1,%ecx
f0105281:	7e 3c                	jle    f01052bf <vprintfmt+0x38b>
		return va_arg(*ap, long long);
f0105283:	8b 45 14             	mov    0x14(%ebp),%eax
f0105286:	8b 50 04             	mov    0x4(%eax),%edx
f0105289:	8b 00                	mov    (%eax),%eax
f010528b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010528e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105291:	8b 45 14             	mov    0x14(%ebp),%eax
f0105294:	8d 40 08             	lea    0x8(%eax),%eax
f0105297:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
f010529a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010529e:	79 59                	jns    f01052f9 <vprintfmt+0x3c5>
                putch('-', putdat);
f01052a0:	83 ec 08             	sub    $0x8,%esp
f01052a3:	53                   	push   %ebx
f01052a4:	6a 2d                	push   $0x2d
f01052a6:	ff d6                	call   *%esi
                num = -(long long) num;
f01052a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01052ab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01052ae:	f7 da                	neg    %edx
f01052b0:	83 d1 00             	adc    $0x0,%ecx
f01052b3:	f7 d9                	neg    %ecx
f01052b5:	83 c4 10             	add    $0x10,%esp
            base = 8;
f01052b8:	b8 08 00 00 00       	mov    $0x8,%eax
f01052bd:	eb 6f                	jmp    f010532e <vprintfmt+0x3fa>
	else if (lflag)
f01052bf:	85 c9                	test   %ecx,%ecx
f01052c1:	75 1b                	jne    f01052de <vprintfmt+0x3aa>
		return va_arg(*ap, int);
f01052c3:	8b 45 14             	mov    0x14(%ebp),%eax
f01052c6:	8b 00                	mov    (%eax),%eax
f01052c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01052cb:	89 c1                	mov    %eax,%ecx
f01052cd:	c1 f9 1f             	sar    $0x1f,%ecx
f01052d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01052d3:	8b 45 14             	mov    0x14(%ebp),%eax
f01052d6:	8d 40 04             	lea    0x4(%eax),%eax
f01052d9:	89 45 14             	mov    %eax,0x14(%ebp)
f01052dc:	eb bc                	jmp    f010529a <vprintfmt+0x366>
		return va_arg(*ap, long);
f01052de:	8b 45 14             	mov    0x14(%ebp),%eax
f01052e1:	8b 00                	mov    (%eax),%eax
f01052e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01052e6:	89 c1                	mov    %eax,%ecx
f01052e8:	c1 f9 1f             	sar    $0x1f,%ecx
f01052eb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01052ee:	8b 45 14             	mov    0x14(%ebp),%eax
f01052f1:	8d 40 04             	lea    0x4(%eax),%eax
f01052f4:	89 45 14             	mov    %eax,0x14(%ebp)
f01052f7:	eb a1                	jmp    f010529a <vprintfmt+0x366>
            num = getint(&ap, lflag);
f01052f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01052fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
f01052ff:	b8 08 00 00 00       	mov    $0x8,%eax
f0105304:	eb 28                	jmp    f010532e <vprintfmt+0x3fa>
			putch('0', putdat);
f0105306:	83 ec 08             	sub    $0x8,%esp
f0105309:	53                   	push   %ebx
f010530a:	6a 30                	push   $0x30
f010530c:	ff d6                	call   *%esi
			putch('x', putdat);
f010530e:	83 c4 08             	add    $0x8,%esp
f0105311:	53                   	push   %ebx
f0105312:	6a 78                	push   $0x78
f0105314:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105316:	8b 45 14             	mov    0x14(%ebp),%eax
f0105319:	8b 10                	mov    (%eax),%edx
f010531b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f0105320:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105323:	8d 40 04             	lea    0x4(%eax),%eax
f0105326:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105329:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010532e:	83 ec 0c             	sub    $0xc,%esp
f0105331:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0105335:	57                   	push   %edi
f0105336:	ff 75 e0             	pushl  -0x20(%ebp)
f0105339:	50                   	push   %eax
f010533a:	51                   	push   %ecx
f010533b:	52                   	push   %edx
f010533c:	89 da                	mov    %ebx,%edx
f010533e:	89 f0                	mov    %esi,%eax
f0105340:	e8 06 fb ff ff       	call   f0104e4b <printnum>
			break;
f0105345:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0105348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010534b:	83 c7 01             	add    $0x1,%edi
f010534e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105352:	83 f8 25             	cmp    $0x25,%eax
f0105355:	0f 84 f0 fb ff ff    	je     f0104f4b <vprintfmt+0x17>
			if (ch == '\0')
f010535b:	85 c0                	test   %eax,%eax
f010535d:	0f 84 8b 00 00 00    	je     f01053ee <vprintfmt+0x4ba>
			putch(ch, putdat);
f0105363:	83 ec 08             	sub    $0x8,%esp
f0105366:	53                   	push   %ebx
f0105367:	50                   	push   %eax
f0105368:	ff d6                	call   *%esi
f010536a:	83 c4 10             	add    $0x10,%esp
f010536d:	eb dc                	jmp    f010534b <vprintfmt+0x417>
	if (lflag >= 2)
f010536f:	83 f9 01             	cmp    $0x1,%ecx
f0105372:	7e 15                	jle    f0105389 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
f0105374:	8b 45 14             	mov    0x14(%ebp),%eax
f0105377:	8b 10                	mov    (%eax),%edx
f0105379:	8b 48 04             	mov    0x4(%eax),%ecx
f010537c:	8d 40 08             	lea    0x8(%eax),%eax
f010537f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105382:	b8 10 00 00 00       	mov    $0x10,%eax
f0105387:	eb a5                	jmp    f010532e <vprintfmt+0x3fa>
	else if (lflag)
f0105389:	85 c9                	test   %ecx,%ecx
f010538b:	75 17                	jne    f01053a4 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
f010538d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105390:	8b 10                	mov    (%eax),%edx
f0105392:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105397:	8d 40 04             	lea    0x4(%eax),%eax
f010539a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010539d:	b8 10 00 00 00       	mov    $0x10,%eax
f01053a2:	eb 8a                	jmp    f010532e <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
f01053a4:	8b 45 14             	mov    0x14(%ebp),%eax
f01053a7:	8b 10                	mov    (%eax),%edx
f01053a9:	b9 00 00 00 00       	mov    $0x0,%ecx
f01053ae:	8d 40 04             	lea    0x4(%eax),%eax
f01053b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01053b4:	b8 10 00 00 00       	mov    $0x10,%eax
f01053b9:	e9 70 ff ff ff       	jmp    f010532e <vprintfmt+0x3fa>
			putch(ch, putdat);
f01053be:	83 ec 08             	sub    $0x8,%esp
f01053c1:	53                   	push   %ebx
f01053c2:	6a 25                	push   $0x25
f01053c4:	ff d6                	call   *%esi
			break;
f01053c6:	83 c4 10             	add    $0x10,%esp
f01053c9:	e9 7a ff ff ff       	jmp    f0105348 <vprintfmt+0x414>
			putch('%', putdat);
f01053ce:	83 ec 08             	sub    $0x8,%esp
f01053d1:	53                   	push   %ebx
f01053d2:	6a 25                	push   $0x25
f01053d4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01053d6:	83 c4 10             	add    $0x10,%esp
f01053d9:	89 f8                	mov    %edi,%eax
f01053db:	eb 03                	jmp    f01053e0 <vprintfmt+0x4ac>
f01053dd:	83 e8 01             	sub    $0x1,%eax
f01053e0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01053e4:	75 f7                	jne    f01053dd <vprintfmt+0x4a9>
f01053e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01053e9:	e9 5a ff ff ff       	jmp    f0105348 <vprintfmt+0x414>
}
f01053ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01053f1:	5b                   	pop    %ebx
f01053f2:	5e                   	pop    %esi
f01053f3:	5f                   	pop    %edi
f01053f4:	5d                   	pop    %ebp
f01053f5:	c3                   	ret    

f01053f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01053f6:	55                   	push   %ebp
f01053f7:	89 e5                	mov    %esp,%ebp
f01053f9:	83 ec 18             	sub    $0x18,%esp
f01053fc:	8b 45 08             	mov    0x8(%ebp),%eax
f01053ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105402:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105405:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105409:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010540c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105413:	85 c0                	test   %eax,%eax
f0105415:	74 26                	je     f010543d <vsnprintf+0x47>
f0105417:	85 d2                	test   %edx,%edx
f0105419:	7e 22                	jle    f010543d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f010541b:	ff 75 14             	pushl  0x14(%ebp)
f010541e:	ff 75 10             	pushl  0x10(%ebp)
f0105421:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105424:	50                   	push   %eax
f0105425:	68 fa 4e 10 f0       	push   $0xf0104efa
f010542a:	e8 05 fb ff ff       	call   f0104f34 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010542f:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105432:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105435:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105438:	83 c4 10             	add    $0x10,%esp
}
f010543b:	c9                   	leave  
f010543c:	c3                   	ret    
		return -E_INVAL;
f010543d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105442:	eb f7                	jmp    f010543b <vsnprintf+0x45>

f0105444 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105444:	55                   	push   %ebp
f0105445:	89 e5                	mov    %esp,%ebp
f0105447:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f010544a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010544d:	50                   	push   %eax
f010544e:	ff 75 10             	pushl  0x10(%ebp)
f0105451:	ff 75 0c             	pushl  0xc(%ebp)
f0105454:	ff 75 08             	pushl  0x8(%ebp)
f0105457:	e8 9a ff ff ff       	call   f01053f6 <vsnprintf>
	va_end(ap);

	return rc;
}
f010545c:	c9                   	leave  
f010545d:	c3                   	ret    

f010545e <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010545e:	55                   	push   %ebp
f010545f:	89 e5                	mov    %esp,%ebp
f0105461:	57                   	push   %edi
f0105462:	56                   	push   %esi
f0105463:	53                   	push   %ebx
f0105464:	83 ec 0c             	sub    $0xc,%esp
f0105467:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f010546a:	85 c0                	test   %eax,%eax
f010546c:	74 11                	je     f010547f <readline+0x21>
		cprintf("%s", prompt);
f010546e:	83 ec 08             	sub    $0x8,%esp
f0105471:	50                   	push   %eax
f0105472:	68 33 77 10 f0       	push   $0xf0107733
f0105477:	e8 03 e7 ff ff       	call   f0103b7f <cprintf>
f010547c:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f010547f:	83 ec 0c             	sub    $0xc,%esp
f0105482:	6a 00                	push   $0x0
f0105484:	e8 05 b3 ff ff       	call   f010078e <iscons>
f0105489:	89 c7                	mov    %eax,%edi
f010548b:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010548e:	be 00 00 00 00       	mov    $0x0,%esi
f0105493:	eb 3f                	jmp    f01054d4 <readline+0x76>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f0105495:	83 ec 08             	sub    $0x8,%esp
f0105498:	50                   	push   %eax
f0105499:	68 44 8b 10 f0       	push   $0xf0108b44
f010549e:	e8 dc e6 ff ff       	call   f0103b7f <cprintf>
			return NULL;
f01054a3:	83 c4 10             	add    $0x10,%esp
f01054a6:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01054ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01054ae:	5b                   	pop    %ebx
f01054af:	5e                   	pop    %esi
f01054b0:	5f                   	pop    %edi
f01054b1:	5d                   	pop    %ebp
f01054b2:	c3                   	ret    
			if (echoing)
f01054b3:	85 ff                	test   %edi,%edi
f01054b5:	75 05                	jne    f01054bc <readline+0x5e>
			i--;
f01054b7:	83 ee 01             	sub    $0x1,%esi
f01054ba:	eb 18                	jmp    f01054d4 <readline+0x76>
				cputchar('\b');
f01054bc:	83 ec 0c             	sub    $0xc,%esp
f01054bf:	6a 08                	push   $0x8
f01054c1:	e8 a7 b2 ff ff       	call   f010076d <cputchar>
f01054c6:	83 c4 10             	add    $0x10,%esp
f01054c9:	eb ec                	jmp    f01054b7 <readline+0x59>
			buf[i++] = c;
f01054cb:	88 9e 80 4a 23 f0    	mov    %bl,-0xfdcb580(%esi)
f01054d1:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01054d4:	e8 a4 b2 ff ff       	call   f010077d <getchar>
f01054d9:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01054db:	85 c0                	test   %eax,%eax
f01054dd:	78 b6                	js     f0105495 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01054df:	83 f8 08             	cmp    $0x8,%eax
f01054e2:	0f 94 c2             	sete   %dl
f01054e5:	83 f8 7f             	cmp    $0x7f,%eax
f01054e8:	0f 94 c0             	sete   %al
f01054eb:	08 c2                	or     %al,%dl
f01054ed:	74 04                	je     f01054f3 <readline+0x95>
f01054ef:	85 f6                	test   %esi,%esi
f01054f1:	7f c0                	jg     f01054b3 <readline+0x55>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01054f3:	83 fb 1f             	cmp    $0x1f,%ebx
f01054f6:	7e 1a                	jle    f0105512 <readline+0xb4>
f01054f8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01054fe:	7f 12                	jg     f0105512 <readline+0xb4>
			if (echoing)
f0105500:	85 ff                	test   %edi,%edi
f0105502:	74 c7                	je     f01054cb <readline+0x6d>
				cputchar(c);
f0105504:	83 ec 0c             	sub    $0xc,%esp
f0105507:	53                   	push   %ebx
f0105508:	e8 60 b2 ff ff       	call   f010076d <cputchar>
f010550d:	83 c4 10             	add    $0x10,%esp
f0105510:	eb b9                	jmp    f01054cb <readline+0x6d>
		} else if (c == '\n' || c == '\r') {
f0105512:	83 fb 0a             	cmp    $0xa,%ebx
f0105515:	74 05                	je     f010551c <readline+0xbe>
f0105517:	83 fb 0d             	cmp    $0xd,%ebx
f010551a:	75 b8                	jne    f01054d4 <readline+0x76>
			if (echoing)
f010551c:	85 ff                	test   %edi,%edi
f010551e:	75 11                	jne    f0105531 <readline+0xd3>
			buf[i] = 0;
f0105520:	c6 86 80 4a 23 f0 00 	movb   $0x0,-0xfdcb580(%esi)
			return buf;
f0105527:	b8 80 4a 23 f0       	mov    $0xf0234a80,%eax
f010552c:	e9 7a ff ff ff       	jmp    f01054ab <readline+0x4d>
				cputchar('\n');
f0105531:	83 ec 0c             	sub    $0xc,%esp
f0105534:	6a 0a                	push   $0xa
f0105536:	e8 32 b2 ff ff       	call   f010076d <cputchar>
f010553b:	83 c4 10             	add    $0x10,%esp
f010553e:	eb e0                	jmp    f0105520 <readline+0xc2>

f0105540 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105540:	55                   	push   %ebp
f0105541:	89 e5                	mov    %esp,%ebp
f0105543:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105546:	b8 00 00 00 00       	mov    $0x0,%eax
f010554b:	eb 03                	jmp    f0105550 <strlen+0x10>
		n++;
f010554d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0105550:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105554:	75 f7                	jne    f010554d <strlen+0xd>
	return n;
}
f0105556:	5d                   	pop    %ebp
f0105557:	c3                   	ret    

f0105558 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105558:	55                   	push   %ebp
f0105559:	89 e5                	mov    %esp,%ebp
f010555b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010555e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105561:	b8 00 00 00 00       	mov    $0x0,%eax
f0105566:	eb 03                	jmp    f010556b <strnlen+0x13>
		n++;
f0105568:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010556b:	39 d0                	cmp    %edx,%eax
f010556d:	74 06                	je     f0105575 <strnlen+0x1d>
f010556f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105573:	75 f3                	jne    f0105568 <strnlen+0x10>
	return n;
}
f0105575:	5d                   	pop    %ebp
f0105576:	c3                   	ret    

f0105577 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105577:	55                   	push   %ebp
f0105578:	89 e5                	mov    %esp,%ebp
f010557a:	53                   	push   %ebx
f010557b:	8b 45 08             	mov    0x8(%ebp),%eax
f010557e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105581:	89 c2                	mov    %eax,%edx
f0105583:	83 c1 01             	add    $0x1,%ecx
f0105586:	83 c2 01             	add    $0x1,%edx
f0105589:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f010558d:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105590:	84 db                	test   %bl,%bl
f0105592:	75 ef                	jne    f0105583 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0105594:	5b                   	pop    %ebx
f0105595:	5d                   	pop    %ebp
f0105596:	c3                   	ret    

f0105597 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105597:	55                   	push   %ebp
f0105598:	89 e5                	mov    %esp,%ebp
f010559a:	53                   	push   %ebx
f010559b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010559e:	53                   	push   %ebx
f010559f:	e8 9c ff ff ff       	call   f0105540 <strlen>
f01055a4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f01055a7:	ff 75 0c             	pushl  0xc(%ebp)
f01055aa:	01 d8                	add    %ebx,%eax
f01055ac:	50                   	push   %eax
f01055ad:	e8 c5 ff ff ff       	call   f0105577 <strcpy>
	return dst;
}
f01055b2:	89 d8                	mov    %ebx,%eax
f01055b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01055b7:	c9                   	leave  
f01055b8:	c3                   	ret    

f01055b9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01055b9:	55                   	push   %ebp
f01055ba:	89 e5                	mov    %esp,%ebp
f01055bc:	56                   	push   %esi
f01055bd:	53                   	push   %ebx
f01055be:	8b 75 08             	mov    0x8(%ebp),%esi
f01055c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01055c4:	89 f3                	mov    %esi,%ebx
f01055c6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01055c9:	89 f2                	mov    %esi,%edx
f01055cb:	eb 0f                	jmp    f01055dc <strncpy+0x23>
		*dst++ = *src;
f01055cd:	83 c2 01             	add    $0x1,%edx
f01055d0:	0f b6 01             	movzbl (%ecx),%eax
f01055d3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01055d6:	80 39 01             	cmpb   $0x1,(%ecx)
f01055d9:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f01055dc:	39 da                	cmp    %ebx,%edx
f01055de:	75 ed                	jne    f01055cd <strncpy+0x14>
	}
	return ret;
}
f01055e0:	89 f0                	mov    %esi,%eax
f01055e2:	5b                   	pop    %ebx
f01055e3:	5e                   	pop    %esi
f01055e4:	5d                   	pop    %ebp
f01055e5:	c3                   	ret    

f01055e6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01055e6:	55                   	push   %ebp
f01055e7:	89 e5                	mov    %esp,%ebp
f01055e9:	56                   	push   %esi
f01055ea:	53                   	push   %ebx
f01055eb:	8b 75 08             	mov    0x8(%ebp),%esi
f01055ee:	8b 55 0c             	mov    0xc(%ebp),%edx
f01055f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01055f4:	89 f0                	mov    %esi,%eax
f01055f6:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01055fa:	85 c9                	test   %ecx,%ecx
f01055fc:	75 0b                	jne    f0105609 <strlcpy+0x23>
f01055fe:	eb 17                	jmp    f0105617 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0105600:	83 c2 01             	add    $0x1,%edx
f0105603:	83 c0 01             	add    $0x1,%eax
f0105606:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0105609:	39 d8                	cmp    %ebx,%eax
f010560b:	74 07                	je     f0105614 <strlcpy+0x2e>
f010560d:	0f b6 0a             	movzbl (%edx),%ecx
f0105610:	84 c9                	test   %cl,%cl
f0105612:	75 ec                	jne    f0105600 <strlcpy+0x1a>
		*dst = '\0';
f0105614:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105617:	29 f0                	sub    %esi,%eax
}
f0105619:	5b                   	pop    %ebx
f010561a:	5e                   	pop    %esi
f010561b:	5d                   	pop    %ebp
f010561c:	c3                   	ret    

f010561d <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010561d:	55                   	push   %ebp
f010561e:	89 e5                	mov    %esp,%ebp
f0105620:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105623:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105626:	eb 06                	jmp    f010562e <strcmp+0x11>
		p++, q++;
f0105628:	83 c1 01             	add    $0x1,%ecx
f010562b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f010562e:	0f b6 01             	movzbl (%ecx),%eax
f0105631:	84 c0                	test   %al,%al
f0105633:	74 04                	je     f0105639 <strcmp+0x1c>
f0105635:	3a 02                	cmp    (%edx),%al
f0105637:	74 ef                	je     f0105628 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105639:	0f b6 c0             	movzbl %al,%eax
f010563c:	0f b6 12             	movzbl (%edx),%edx
f010563f:	29 d0                	sub    %edx,%eax
}
f0105641:	5d                   	pop    %ebp
f0105642:	c3                   	ret    

f0105643 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105643:	55                   	push   %ebp
f0105644:	89 e5                	mov    %esp,%ebp
f0105646:	53                   	push   %ebx
f0105647:	8b 45 08             	mov    0x8(%ebp),%eax
f010564a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010564d:	89 c3                	mov    %eax,%ebx
f010564f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105652:	eb 06                	jmp    f010565a <strncmp+0x17>
		n--, p++, q++;
f0105654:	83 c0 01             	add    $0x1,%eax
f0105657:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010565a:	39 d8                	cmp    %ebx,%eax
f010565c:	74 16                	je     f0105674 <strncmp+0x31>
f010565e:	0f b6 08             	movzbl (%eax),%ecx
f0105661:	84 c9                	test   %cl,%cl
f0105663:	74 04                	je     f0105669 <strncmp+0x26>
f0105665:	3a 0a                	cmp    (%edx),%cl
f0105667:	74 eb                	je     f0105654 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105669:	0f b6 00             	movzbl (%eax),%eax
f010566c:	0f b6 12             	movzbl (%edx),%edx
f010566f:	29 d0                	sub    %edx,%eax
}
f0105671:	5b                   	pop    %ebx
f0105672:	5d                   	pop    %ebp
f0105673:	c3                   	ret    
		return 0;
f0105674:	b8 00 00 00 00       	mov    $0x0,%eax
f0105679:	eb f6                	jmp    f0105671 <strncmp+0x2e>

f010567b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010567b:	55                   	push   %ebp
f010567c:	89 e5                	mov    %esp,%ebp
f010567e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105681:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105685:	0f b6 10             	movzbl (%eax),%edx
f0105688:	84 d2                	test   %dl,%dl
f010568a:	74 09                	je     f0105695 <strchr+0x1a>
		if (*s == c)
f010568c:	38 ca                	cmp    %cl,%dl
f010568e:	74 0a                	je     f010569a <strchr+0x1f>
	for (; *s; s++)
f0105690:	83 c0 01             	add    $0x1,%eax
f0105693:	eb f0                	jmp    f0105685 <strchr+0xa>
			return (char *) s;
	return 0;
f0105695:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010569a:	5d                   	pop    %ebp
f010569b:	c3                   	ret    

f010569c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010569c:	55                   	push   %ebp
f010569d:	89 e5                	mov    %esp,%ebp
f010569f:	8b 45 08             	mov    0x8(%ebp),%eax
f01056a2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01056a6:	eb 03                	jmp    f01056ab <strfind+0xf>
f01056a8:	83 c0 01             	add    $0x1,%eax
f01056ab:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01056ae:	38 ca                	cmp    %cl,%dl
f01056b0:	74 04                	je     f01056b6 <strfind+0x1a>
f01056b2:	84 d2                	test   %dl,%dl
f01056b4:	75 f2                	jne    f01056a8 <strfind+0xc>
			break;
	return (char *) s;
}
f01056b6:	5d                   	pop    %ebp
f01056b7:	c3                   	ret    

f01056b8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01056b8:	55                   	push   %ebp
f01056b9:	89 e5                	mov    %esp,%ebp
f01056bb:	57                   	push   %edi
f01056bc:	56                   	push   %esi
f01056bd:	53                   	push   %ebx
f01056be:	8b 7d 08             	mov    0x8(%ebp),%edi
f01056c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01056c4:	85 c9                	test   %ecx,%ecx
f01056c6:	74 13                	je     f01056db <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01056c8:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01056ce:	75 05                	jne    f01056d5 <memset+0x1d>
f01056d0:	f6 c1 03             	test   $0x3,%cl
f01056d3:	74 0d                	je     f01056e2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01056d5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01056d8:	fc                   	cld    
f01056d9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01056db:	89 f8                	mov    %edi,%eax
f01056dd:	5b                   	pop    %ebx
f01056de:	5e                   	pop    %esi
f01056df:	5f                   	pop    %edi
f01056e0:	5d                   	pop    %ebp
f01056e1:	c3                   	ret    
		c &= 0xFF;
f01056e2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01056e6:	89 d3                	mov    %edx,%ebx
f01056e8:	c1 e3 08             	shl    $0x8,%ebx
f01056eb:	89 d0                	mov    %edx,%eax
f01056ed:	c1 e0 18             	shl    $0x18,%eax
f01056f0:	89 d6                	mov    %edx,%esi
f01056f2:	c1 e6 10             	shl    $0x10,%esi
f01056f5:	09 f0                	or     %esi,%eax
f01056f7:	09 c2                	or     %eax,%edx
f01056f9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f01056fb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01056fe:	89 d0                	mov    %edx,%eax
f0105700:	fc                   	cld    
f0105701:	f3 ab                	rep stos %eax,%es:(%edi)
f0105703:	eb d6                	jmp    f01056db <memset+0x23>

f0105705 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105705:	55                   	push   %ebp
f0105706:	89 e5                	mov    %esp,%ebp
f0105708:	57                   	push   %edi
f0105709:	56                   	push   %esi
f010570a:	8b 45 08             	mov    0x8(%ebp),%eax
f010570d:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105710:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105713:	39 c6                	cmp    %eax,%esi
f0105715:	73 35                	jae    f010574c <memmove+0x47>
f0105717:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010571a:	39 c2                	cmp    %eax,%edx
f010571c:	76 2e                	jbe    f010574c <memmove+0x47>
		s += n;
		d += n;
f010571e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105721:	89 d6                	mov    %edx,%esi
f0105723:	09 fe                	or     %edi,%esi
f0105725:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010572b:	74 0c                	je     f0105739 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010572d:	83 ef 01             	sub    $0x1,%edi
f0105730:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105733:	fd                   	std    
f0105734:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105736:	fc                   	cld    
f0105737:	eb 21                	jmp    f010575a <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105739:	f6 c1 03             	test   $0x3,%cl
f010573c:	75 ef                	jne    f010572d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f010573e:	83 ef 04             	sub    $0x4,%edi
f0105741:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105744:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105747:	fd                   	std    
f0105748:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010574a:	eb ea                	jmp    f0105736 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010574c:	89 f2                	mov    %esi,%edx
f010574e:	09 c2                	or     %eax,%edx
f0105750:	f6 c2 03             	test   $0x3,%dl
f0105753:	74 09                	je     f010575e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0105755:	89 c7                	mov    %eax,%edi
f0105757:	fc                   	cld    
f0105758:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010575a:	5e                   	pop    %esi
f010575b:	5f                   	pop    %edi
f010575c:	5d                   	pop    %ebp
f010575d:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010575e:	f6 c1 03             	test   $0x3,%cl
f0105761:	75 f2                	jne    f0105755 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105763:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105766:	89 c7                	mov    %eax,%edi
f0105768:	fc                   	cld    
f0105769:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010576b:	eb ed                	jmp    f010575a <memmove+0x55>

f010576d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010576d:	55                   	push   %ebp
f010576e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0105770:	ff 75 10             	pushl  0x10(%ebp)
f0105773:	ff 75 0c             	pushl  0xc(%ebp)
f0105776:	ff 75 08             	pushl  0x8(%ebp)
f0105779:	e8 87 ff ff ff       	call   f0105705 <memmove>
}
f010577e:	c9                   	leave  
f010577f:	c3                   	ret    

f0105780 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105780:	55                   	push   %ebp
f0105781:	89 e5                	mov    %esp,%ebp
f0105783:	56                   	push   %esi
f0105784:	53                   	push   %ebx
f0105785:	8b 45 08             	mov    0x8(%ebp),%eax
f0105788:	8b 55 0c             	mov    0xc(%ebp),%edx
f010578b:	89 c6                	mov    %eax,%esi
f010578d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105790:	39 f0                	cmp    %esi,%eax
f0105792:	74 1c                	je     f01057b0 <memcmp+0x30>
		if (*s1 != *s2)
f0105794:	0f b6 08             	movzbl (%eax),%ecx
f0105797:	0f b6 1a             	movzbl (%edx),%ebx
f010579a:	38 d9                	cmp    %bl,%cl
f010579c:	75 08                	jne    f01057a6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f010579e:	83 c0 01             	add    $0x1,%eax
f01057a1:	83 c2 01             	add    $0x1,%edx
f01057a4:	eb ea                	jmp    f0105790 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01057a6:	0f b6 c1             	movzbl %cl,%eax
f01057a9:	0f b6 db             	movzbl %bl,%ebx
f01057ac:	29 d8                	sub    %ebx,%eax
f01057ae:	eb 05                	jmp    f01057b5 <memcmp+0x35>
	}

	return 0;
f01057b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01057b5:	5b                   	pop    %ebx
f01057b6:	5e                   	pop    %esi
f01057b7:	5d                   	pop    %ebp
f01057b8:	c3                   	ret    

f01057b9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01057b9:	55                   	push   %ebp
f01057ba:	89 e5                	mov    %esp,%ebp
f01057bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01057bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01057c2:	89 c2                	mov    %eax,%edx
f01057c4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01057c7:	39 d0                	cmp    %edx,%eax
f01057c9:	73 09                	jae    f01057d4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01057cb:	38 08                	cmp    %cl,(%eax)
f01057cd:	74 05                	je     f01057d4 <memfind+0x1b>
	for (; s < ends; s++)
f01057cf:	83 c0 01             	add    $0x1,%eax
f01057d2:	eb f3                	jmp    f01057c7 <memfind+0xe>
			break;
	return (void *) s;
}
f01057d4:	5d                   	pop    %ebp
f01057d5:	c3                   	ret    

f01057d6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01057d6:	55                   	push   %ebp
f01057d7:	89 e5                	mov    %esp,%ebp
f01057d9:	57                   	push   %edi
f01057da:	56                   	push   %esi
f01057db:	53                   	push   %ebx
f01057dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01057df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01057e2:	eb 03                	jmp    f01057e7 <strtol+0x11>
		s++;
f01057e4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01057e7:	0f b6 01             	movzbl (%ecx),%eax
f01057ea:	3c 20                	cmp    $0x20,%al
f01057ec:	74 f6                	je     f01057e4 <strtol+0xe>
f01057ee:	3c 09                	cmp    $0x9,%al
f01057f0:	74 f2                	je     f01057e4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01057f2:	3c 2b                	cmp    $0x2b,%al
f01057f4:	74 2e                	je     f0105824 <strtol+0x4e>
	int neg = 0;
f01057f6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01057fb:	3c 2d                	cmp    $0x2d,%al
f01057fd:	74 2f                	je     f010582e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01057ff:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105805:	75 05                	jne    f010580c <strtol+0x36>
f0105807:	80 39 30             	cmpb   $0x30,(%ecx)
f010580a:	74 2c                	je     f0105838 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f010580c:	85 db                	test   %ebx,%ebx
f010580e:	75 0a                	jne    f010581a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105810:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f0105815:	80 39 30             	cmpb   $0x30,(%ecx)
f0105818:	74 28                	je     f0105842 <strtol+0x6c>
		base = 10;
f010581a:	b8 00 00 00 00       	mov    $0x0,%eax
f010581f:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105822:	eb 50                	jmp    f0105874 <strtol+0x9e>
		s++;
f0105824:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105827:	bf 00 00 00 00       	mov    $0x0,%edi
f010582c:	eb d1                	jmp    f01057ff <strtol+0x29>
		s++, neg = 1;
f010582e:	83 c1 01             	add    $0x1,%ecx
f0105831:	bf 01 00 00 00       	mov    $0x1,%edi
f0105836:	eb c7                	jmp    f01057ff <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105838:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010583c:	74 0e                	je     f010584c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f010583e:	85 db                	test   %ebx,%ebx
f0105840:	75 d8                	jne    f010581a <strtol+0x44>
		s++, base = 8;
f0105842:	83 c1 01             	add    $0x1,%ecx
f0105845:	bb 08 00 00 00       	mov    $0x8,%ebx
f010584a:	eb ce                	jmp    f010581a <strtol+0x44>
		s += 2, base = 16;
f010584c:	83 c1 02             	add    $0x2,%ecx
f010584f:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105854:	eb c4                	jmp    f010581a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105856:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105859:	89 f3                	mov    %esi,%ebx
f010585b:	80 fb 19             	cmp    $0x19,%bl
f010585e:	77 29                	ja     f0105889 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105860:	0f be d2             	movsbl %dl,%edx
f0105863:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105866:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105869:	7d 30                	jge    f010589b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f010586b:	83 c1 01             	add    $0x1,%ecx
f010586e:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105872:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105874:	0f b6 11             	movzbl (%ecx),%edx
f0105877:	8d 72 d0             	lea    -0x30(%edx),%esi
f010587a:	89 f3                	mov    %esi,%ebx
f010587c:	80 fb 09             	cmp    $0x9,%bl
f010587f:	77 d5                	ja     f0105856 <strtol+0x80>
			dig = *s - '0';
f0105881:	0f be d2             	movsbl %dl,%edx
f0105884:	83 ea 30             	sub    $0x30,%edx
f0105887:	eb dd                	jmp    f0105866 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0105889:	8d 72 bf             	lea    -0x41(%edx),%esi
f010588c:	89 f3                	mov    %esi,%ebx
f010588e:	80 fb 19             	cmp    $0x19,%bl
f0105891:	77 08                	ja     f010589b <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105893:	0f be d2             	movsbl %dl,%edx
f0105896:	83 ea 37             	sub    $0x37,%edx
f0105899:	eb cb                	jmp    f0105866 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f010589b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010589f:	74 05                	je     f01058a6 <strtol+0xd0>
		*endptr = (char *) s;
f01058a1:	8b 75 0c             	mov    0xc(%ebp),%esi
f01058a4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01058a6:	89 c2                	mov    %eax,%edx
f01058a8:	f7 da                	neg    %edx
f01058aa:	85 ff                	test   %edi,%edi
f01058ac:	0f 45 c2             	cmovne %edx,%eax
}
f01058af:	5b                   	pop    %ebx
f01058b0:	5e                   	pop    %esi
f01058b1:	5f                   	pop    %edi
f01058b2:	5d                   	pop    %ebp
f01058b3:	c3                   	ret    

f01058b4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01058b4:	fa                   	cli    

	xorw    %ax, %ax
f01058b5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01058b7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01058b9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01058bb:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01058bd:	0f 01 16             	lgdtl  (%esi)
f01058c0:	74 70                	je     f0105932 <mpsearch1+0x3>
	movl    %cr0, %eax
f01058c2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01058c5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01058c9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01058cc:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01058d2:	08 00                	or     %al,(%eax)

f01058d4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01058d4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01058d8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01058da:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01058dc:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01058de:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01058e2:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01058e4:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01058e6:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl    %eax, %cr3
f01058eb:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01058ee:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01058f1:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01058f6:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01058f9:	8b 25 88 4e 23 f0    	mov    0xf0234e88,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01058ff:	bd 00 00 00 00       	mov    $0x0,%ebp

	//??? not understand temporary
	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105904:	b8 a0 01 10 f0       	mov    $0xf01001a0,%eax
	call    *%eax
f0105909:	ff d0                	call   *%eax

f010590b <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f010590b:	eb fe                	jmp    f010590b <spin>
f010590d:	8d 76 00             	lea    0x0(%esi),%esi

f0105910 <gdt>:
	...
f0105918:	ff                   	(bad)  
f0105919:	ff 00                	incl   (%eax)
f010591b:	00 00                	add    %al,(%eax)
f010591d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105924:	00                   	.byte 0x0
f0105925:	92                   	xchg   %eax,%edx
f0105926:	cf                   	iret   
	...

f0105928 <gdtdesc>:
f0105928:	17                   	pop    %ss
f0105929:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f010592e <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f010592e:	90                   	nop

f010592f <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f010592f:	55                   	push   %ebp
f0105930:	89 e5                	mov    %esp,%ebp
f0105932:	57                   	push   %edi
f0105933:	56                   	push   %esi
f0105934:	53                   	push   %ebx
f0105935:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105938:	8b 0d 8c 4e 23 f0    	mov    0xf0234e8c,%ecx
f010593e:	89 c3                	mov    %eax,%ebx
f0105940:	c1 eb 0c             	shr    $0xc,%ebx
f0105943:	39 cb                	cmp    %ecx,%ebx
f0105945:	73 1a                	jae    f0105961 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105947:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f010594d:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f0105950:	89 f0                	mov    %esi,%eax
f0105952:	c1 e8 0c             	shr    $0xc,%eax
f0105955:	39 c8                	cmp    %ecx,%eax
f0105957:	73 1a                	jae    f0105973 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105959:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f010595f:	eb 27                	jmp    f0105988 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105961:	50                   	push   %eax
f0105962:	68 64 63 10 f0       	push   $0xf0106364
f0105967:	6a 57                	push   $0x57
f0105969:	68 e1 8c 10 f0       	push   $0xf0108ce1
f010596e:	e8 cd a6 ff ff       	call   f0100040 <_panic>
f0105973:	56                   	push   %esi
f0105974:	68 64 63 10 f0       	push   $0xf0106364
f0105979:	6a 57                	push   $0x57
f010597b:	68 e1 8c 10 f0       	push   $0xf0108ce1
f0105980:	e8 bb a6 ff ff       	call   f0100040 <_panic>
f0105985:	83 c3 10             	add    $0x10,%ebx
f0105988:	39 f3                	cmp    %esi,%ebx
f010598a:	73 2e                	jae    f01059ba <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010598c:	83 ec 04             	sub    $0x4,%esp
f010598f:	6a 04                	push   $0x4
f0105991:	68 f1 8c 10 f0       	push   $0xf0108cf1
f0105996:	53                   	push   %ebx
f0105997:	e8 e4 fd ff ff       	call   f0105780 <memcmp>
f010599c:	83 c4 10             	add    $0x10,%esp
f010599f:	85 c0                	test   %eax,%eax
f01059a1:	75 e2                	jne    f0105985 <mpsearch1+0x56>
f01059a3:	89 da                	mov    %ebx,%edx
f01059a5:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f01059a8:	0f b6 0a             	movzbl (%edx),%ecx
f01059ab:	01 c8                	add    %ecx,%eax
f01059ad:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f01059b0:	39 fa                	cmp    %edi,%edx
f01059b2:	75 f4                	jne    f01059a8 <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01059b4:	84 c0                	test   %al,%al
f01059b6:	75 cd                	jne    f0105985 <mpsearch1+0x56>
f01059b8:	eb 05                	jmp    f01059bf <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01059ba:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01059bf:	89 d8                	mov    %ebx,%eax
f01059c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01059c4:	5b                   	pop    %ebx
f01059c5:	5e                   	pop    %esi
f01059c6:	5f                   	pop    %edi
f01059c7:	5d                   	pop    %ebp
f01059c8:	c3                   	ret    

f01059c9 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01059c9:	55                   	push   %ebp
f01059ca:	89 e5                	mov    %esp,%ebp
f01059cc:	57                   	push   %edi
f01059cd:	56                   	push   %esi
f01059ce:	53                   	push   %ebx
f01059cf:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01059d2:	c7 05 c0 53 23 f0 20 	movl   $0xf0235020,0xf02353c0
f01059d9:	50 23 f0 
	if (PGNUM(pa) >= npages)
f01059dc:	83 3d 8c 4e 23 f0 00 	cmpl   $0x0,0xf0234e8c
f01059e3:	0f 84 87 00 00 00    	je     f0105a70 <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01059e9:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01059f0:	85 c0                	test   %eax,%eax
f01059f2:	0f 84 8e 00 00 00    	je     f0105a86 <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f01059f8:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01059fb:	ba 00 04 00 00       	mov    $0x400,%edx
f0105a00:	e8 2a ff ff ff       	call   f010592f <mpsearch1>
f0105a05:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105a08:	85 c0                	test   %eax,%eax
f0105a0a:	0f 84 9a 00 00 00    	je     f0105aaa <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105a10:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105a13:	8b 41 04             	mov    0x4(%ecx),%eax
f0105a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105a19:	85 c0                	test   %eax,%eax
f0105a1b:	0f 84 a8 00 00 00    	je     f0105ac9 <mp_init+0x100>
f0105a21:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f0105a25:	0f 85 9e 00 00 00    	jne    f0105ac9 <mp_init+0x100>
f0105a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a2e:	c1 e8 0c             	shr    $0xc,%eax
f0105a31:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f0105a37:	0f 83 a1 00 00 00    	jae    f0105ade <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105a3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a40:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f0105a46:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105a48:	83 ec 04             	sub    $0x4,%esp
f0105a4b:	6a 04                	push   $0x4
f0105a4d:	68 f6 8c 10 f0       	push   $0xf0108cf6
f0105a52:	53                   	push   %ebx
f0105a53:	e8 28 fd ff ff       	call   f0105780 <memcmp>
f0105a58:	83 c4 10             	add    $0x10,%esp
f0105a5b:	85 c0                	test   %eax,%eax
f0105a5d:	0f 85 92 00 00 00    	jne    f0105af5 <mp_init+0x12c>
f0105a63:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105a67:	01 df                	add    %ebx,%edi
	sum = 0;
f0105a69:	89 c2                	mov    %eax,%edx
f0105a6b:	e9 a2 00 00 00       	jmp    f0105b12 <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105a70:	68 00 04 00 00       	push   $0x400
f0105a75:	68 64 63 10 f0       	push   $0xf0106364
f0105a7a:	6a 6f                	push   $0x6f
f0105a7c:	68 e1 8c 10 f0       	push   $0xf0108ce1
f0105a81:	e8 ba a5 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105a86:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105a8d:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105a90:	2d 00 04 00 00       	sub    $0x400,%eax
f0105a95:	ba 00 04 00 00       	mov    $0x400,%edx
f0105a9a:	e8 90 fe ff ff       	call   f010592f <mpsearch1>
f0105a9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105aa2:	85 c0                	test   %eax,%eax
f0105aa4:	0f 85 66 ff ff ff    	jne    f0105a10 <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f0105aaa:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105aaf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105ab4:	e8 76 fe ff ff       	call   f010592f <mpsearch1>
f0105ab9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f0105abc:	85 c0                	test   %eax,%eax
f0105abe:	0f 85 4c ff ff ff    	jne    f0105a10 <mp_init+0x47>
f0105ac4:	e9 a8 01 00 00       	jmp    f0105c71 <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f0105ac9:	83 ec 0c             	sub    $0xc,%esp
f0105acc:	68 54 8b 10 f0       	push   $0xf0108b54
f0105ad1:	e8 a9 e0 ff ff       	call   f0103b7f <cprintf>
f0105ad6:	83 c4 10             	add    $0x10,%esp
f0105ad9:	e9 93 01 00 00       	jmp    f0105c71 <mp_init+0x2a8>
f0105ade:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105ae1:	68 64 63 10 f0       	push   $0xf0106364
f0105ae6:	68 90 00 00 00       	push   $0x90
f0105aeb:	68 e1 8c 10 f0       	push   $0xf0108ce1
f0105af0:	e8 4b a5 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105af5:	83 ec 0c             	sub    $0xc,%esp
f0105af8:	68 84 8b 10 f0       	push   $0xf0108b84
f0105afd:	e8 7d e0 ff ff       	call   f0103b7f <cprintf>
f0105b02:	83 c4 10             	add    $0x10,%esp
f0105b05:	e9 67 01 00 00       	jmp    f0105c71 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105b0a:	0f b6 0b             	movzbl (%ebx),%ecx
f0105b0d:	01 ca                	add    %ecx,%edx
f0105b0f:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105b12:	39 fb                	cmp    %edi,%ebx
f0105b14:	75 f4                	jne    f0105b0a <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f0105b16:	84 d2                	test   %dl,%dl
f0105b18:	75 16                	jne    f0105b30 <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f0105b1a:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105b1e:	80 fa 01             	cmp    $0x1,%dl
f0105b21:	74 05                	je     f0105b28 <mp_init+0x15f>
f0105b23:	80 fa 04             	cmp    $0x4,%dl
f0105b26:	75 1d                	jne    f0105b45 <mp_init+0x17c>
f0105b28:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105b2c:	01 d9                	add    %ebx,%ecx
f0105b2e:	eb 36                	jmp    f0105b66 <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105b30:	83 ec 0c             	sub    $0xc,%esp
f0105b33:	68 b8 8b 10 f0       	push   $0xf0108bb8
f0105b38:	e8 42 e0 ff ff       	call   f0103b7f <cprintf>
f0105b3d:	83 c4 10             	add    $0x10,%esp
f0105b40:	e9 2c 01 00 00       	jmp    f0105c71 <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105b45:	83 ec 08             	sub    $0x8,%esp
f0105b48:	0f b6 d2             	movzbl %dl,%edx
f0105b4b:	52                   	push   %edx
f0105b4c:	68 dc 8b 10 f0       	push   $0xf0108bdc
f0105b51:	e8 29 e0 ff ff       	call   f0103b7f <cprintf>
f0105b56:	83 c4 10             	add    $0x10,%esp
f0105b59:	e9 13 01 00 00       	jmp    f0105c71 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105b5e:	0f b6 13             	movzbl (%ebx),%edx
f0105b61:	01 d0                	add    %edx,%eax
f0105b63:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105b66:	39 d9                	cmp    %ebx,%ecx
f0105b68:	75 f4                	jne    f0105b5e <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105b6a:	02 46 2a             	add    0x2a(%esi),%al
f0105b6d:	75 29                	jne    f0105b98 <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105b6f:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f0105b76:	0f 84 f5 00 00 00    	je     f0105c71 <mp_init+0x2a8>
		return;
	ismp = 1;
f0105b7c:	c7 05 00 50 23 f0 01 	movl   $0x1,0xf0235000
f0105b83:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105b86:	8b 46 24             	mov    0x24(%esi),%eax
f0105b89:	a3 00 60 27 f0       	mov    %eax,0xf0276000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105b8e:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105b91:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105b96:	eb 4d                	jmp    f0105be5 <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105b98:	83 ec 0c             	sub    $0xc,%esp
f0105b9b:	68 fc 8b 10 f0       	push   $0xf0108bfc
f0105ba0:	e8 da df ff ff       	call   f0103b7f <cprintf>
f0105ba5:	83 c4 10             	add    $0x10,%esp
f0105ba8:	e9 c4 00 00 00       	jmp    f0105c71 <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105bad:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105bb1:	74 11                	je     f0105bc4 <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105bb3:	6b 05 c4 53 23 f0 74 	imul   $0x74,0xf02353c4,%eax
f0105bba:	05 20 50 23 f0       	add    $0xf0235020,%eax
f0105bbf:	a3 c0 53 23 f0       	mov    %eax,0xf02353c0
			if (ncpu < NCPU) {
f0105bc4:	a1 c4 53 23 f0       	mov    0xf02353c4,%eax
f0105bc9:	83 f8 07             	cmp    $0x7,%eax
f0105bcc:	7f 2f                	jg     f0105bfd <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;
f0105bce:	6b d0 74             	imul   $0x74,%eax,%edx
f0105bd1:	88 82 20 50 23 f0    	mov    %al,-0xfdcafe0(%edx)
				ncpu++;
f0105bd7:	83 c0 01             	add    $0x1,%eax
f0105bda:	a3 c4 53 23 f0       	mov    %eax,0xf02353c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105bdf:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105be2:	83 c3 01             	add    $0x1,%ebx
f0105be5:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105be9:	39 d8                	cmp    %ebx,%eax
f0105beb:	76 4b                	jbe    f0105c38 <mp_init+0x26f>
		switch (*p) {
f0105bed:	0f b6 07             	movzbl (%edi),%eax
f0105bf0:	84 c0                	test   %al,%al
f0105bf2:	74 b9                	je     f0105bad <mp_init+0x1e4>
f0105bf4:	3c 04                	cmp    $0x4,%al
f0105bf6:	77 1c                	ja     f0105c14 <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105bf8:	83 c7 08             	add    $0x8,%edi
			continue;
f0105bfb:	eb e5                	jmp    f0105be2 <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105bfd:	83 ec 08             	sub    $0x8,%esp
f0105c00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105c04:	50                   	push   %eax
f0105c05:	68 2c 8c 10 f0       	push   $0xf0108c2c
f0105c0a:	e8 70 df ff ff       	call   f0103b7f <cprintf>
f0105c0f:	83 c4 10             	add    $0x10,%esp
f0105c12:	eb cb                	jmp    f0105bdf <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105c14:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105c17:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105c1a:	50                   	push   %eax
f0105c1b:	68 54 8c 10 f0       	push   $0xf0108c54
f0105c20:	e8 5a df ff ff       	call   f0103b7f <cprintf>
			ismp = 0;
f0105c25:	c7 05 00 50 23 f0 00 	movl   $0x0,0xf0235000
f0105c2c:	00 00 00 
			i = conf->entry;
f0105c2f:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105c33:	83 c4 10             	add    $0x10,%esp
f0105c36:	eb aa                	jmp    f0105be2 <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105c38:	a1 c0 53 23 f0       	mov    0xf02353c0,%eax
f0105c3d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105c44:	83 3d 00 50 23 f0 00 	cmpl   $0x0,0xf0235000
f0105c4b:	75 2c                	jne    f0105c79 <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105c4d:	c7 05 c4 53 23 f0 01 	movl   $0x1,0xf02353c4
f0105c54:	00 00 00 
		lapicaddr = 0;
f0105c57:	c7 05 00 60 27 f0 00 	movl   $0x0,0xf0276000
f0105c5e:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105c61:	83 ec 0c             	sub    $0xc,%esp
f0105c64:	68 74 8c 10 f0       	push   $0xf0108c74
f0105c69:	e8 11 df ff ff       	call   f0103b7f <cprintf>
		return;
f0105c6e:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c74:	5b                   	pop    %ebx
f0105c75:	5e                   	pop    %esi
f0105c76:	5f                   	pop    %edi
f0105c77:	5d                   	pop    %ebp
f0105c78:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105c79:	83 ec 04             	sub    $0x4,%esp
f0105c7c:	ff 35 c4 53 23 f0    	pushl  0xf02353c4
f0105c82:	0f b6 00             	movzbl (%eax),%eax
f0105c85:	50                   	push   %eax
f0105c86:	68 fb 8c 10 f0       	push   $0xf0108cfb
f0105c8b:	e8 ef de ff ff       	call   f0103b7f <cprintf>
	if (mp->imcrp) {
f0105c90:	83 c4 10             	add    $0x10,%esp
f0105c93:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c96:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105c9a:	74 d5                	je     f0105c71 <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105c9c:	83 ec 0c             	sub    $0xc,%esp
f0105c9f:	68 a0 8c 10 f0       	push   $0xf0108ca0
f0105ca4:	e8 d6 de ff ff       	call   f0103b7f <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105ca9:	b8 70 00 00 00       	mov    $0x70,%eax
f0105cae:	ba 22 00 00 00       	mov    $0x22,%edx
f0105cb3:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105cb4:	ba 23 00 00 00       	mov    $0x23,%edx
f0105cb9:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105cba:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105cbd:	ee                   	out    %al,(%dx)
f0105cbe:	83 c4 10             	add    $0x10,%esp
f0105cc1:	eb ae                	jmp    f0105c71 <mp_init+0x2a8>

f0105cc3 <lapicw>:

physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value) {
f0105cc3:	55                   	push   %ebp
f0105cc4:	89 e5                	mov    %esp,%ebp
    lapic[index] = value;
f0105cc6:	8b 0d 04 60 27 f0    	mov    0xf0276004,%ecx
f0105ccc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105ccf:	89 10                	mov    %edx,(%eax)
    lapic[ID];  // wait for write to finish, by reading
f0105cd1:	a1 04 60 27 f0       	mov    0xf0276004,%eax
f0105cd6:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105cd9:	5d                   	pop    %ebp
f0105cda:	c3                   	ret    

f0105cdb <cpunum>:
    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}

int
cpunum(void) {
f0105cdb:	55                   	push   %ebp
f0105cdc:	89 e5                	mov    %esp,%ebp
    if (lapic)
f0105cde:	8b 15 04 60 27 f0    	mov    0xf0276004,%edx
        return lapic[ID] >> 24;
    return 0;
f0105ce4:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lapic)
f0105ce9:	85 d2                	test   %edx,%edx
f0105ceb:	74 06                	je     f0105cf3 <cpunum+0x18>
        return lapic[ID] >> 24;
f0105ced:	8b 42 20             	mov    0x20(%edx),%eax
f0105cf0:	c1 e8 18             	shr    $0x18,%eax
}
f0105cf3:	5d                   	pop    %ebp
f0105cf4:	c3                   	ret    

f0105cf5 <lapic_init>:
    if (!lapicaddr)
f0105cf5:	a1 00 60 27 f0       	mov    0xf0276000,%eax
f0105cfa:	85 c0                	test   %eax,%eax
f0105cfc:	75 02                	jne    f0105d00 <lapic_init+0xb>
f0105cfe:	f3 c3                	repz ret 
lapic_init(void) {
f0105d00:	55                   	push   %ebp
f0105d01:	89 e5                	mov    %esp,%ebp
f0105d03:	83 ec 10             	sub    $0x10,%esp
    lapic = mmio_map_region(lapicaddr, 4096);
f0105d06:	68 00 10 00 00       	push   $0x1000
f0105d0b:	50                   	push   %eax
f0105d0c:	e8 56 d3 ff ff       	call   f0103067 <mmio_map_region>
f0105d11:	a3 04 60 27 f0       	mov    %eax,0xf0276004
    lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105d16:	ba 27 01 00 00       	mov    $0x127,%edx
f0105d1b:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105d20:	e8 9e ff ff ff       	call   f0105cc3 <lapicw>
    lapicw(TDCR, X1);
f0105d25:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105d2a:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105d2f:	e8 8f ff ff ff       	call   f0105cc3 <lapicw>
    lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105d34:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105d39:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105d3e:	e8 80 ff ff ff       	call   f0105cc3 <lapicw>
    lapicw(TICR, 10000000);
f0105d43:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105d48:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105d4d:	e8 71 ff ff ff       	call   f0105cc3 <lapicw>
    if (thiscpu != bootcpu)
f0105d52:	e8 84 ff ff ff       	call   f0105cdb <cpunum>
f0105d57:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d5a:	05 20 50 23 f0       	add    $0xf0235020,%eax
f0105d5f:	83 c4 10             	add    $0x10,%esp
f0105d62:	39 05 c0 53 23 f0    	cmp    %eax,0xf02353c0
f0105d68:	74 0f                	je     f0105d79 <lapic_init+0x84>
        lapicw(LINT0, MASKED);
f0105d6a:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105d6f:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105d74:	e8 4a ff ff ff       	call   f0105cc3 <lapicw>
    lapicw(LINT1, MASKED);
f0105d79:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105d7e:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105d83:	e8 3b ff ff ff       	call   f0105cc3 <lapicw>
    if (((lapic[VER] >> 16) & 0xFF) >= 4)
f0105d88:	a1 04 60 27 f0       	mov    0xf0276004,%eax
f0105d8d:	8b 40 30             	mov    0x30(%eax),%eax
f0105d90:	c1 e8 10             	shr    $0x10,%eax
f0105d93:	3c 03                	cmp    $0x3,%al
f0105d95:	77 7c                	ja     f0105e13 <lapic_init+0x11e>
    lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105d97:	ba 33 00 00 00       	mov    $0x33,%edx
f0105d9c:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105da1:	e8 1d ff ff ff       	call   f0105cc3 <lapicw>
    lapicw(ESR, 0);
f0105da6:	ba 00 00 00 00       	mov    $0x0,%edx
f0105dab:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105db0:	e8 0e ff ff ff       	call   f0105cc3 <lapicw>
    lapicw(ESR, 0);
f0105db5:	ba 00 00 00 00       	mov    $0x0,%edx
f0105dba:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105dbf:	e8 ff fe ff ff       	call   f0105cc3 <lapicw>
    lapicw(EOI, 0);
f0105dc4:	ba 00 00 00 00       	mov    $0x0,%edx
f0105dc9:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105dce:	e8 f0 fe ff ff       	call   f0105cc3 <lapicw>
    lapicw(ICRHI, 0);
f0105dd3:	ba 00 00 00 00       	mov    $0x0,%edx
f0105dd8:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ddd:	e8 e1 fe ff ff       	call   f0105cc3 <lapicw>
    lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105de2:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105de7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105dec:	e8 d2 fe ff ff       	call   f0105cc3 <lapicw>
    while (lapic[ICRLO] & DELIVS);
f0105df1:	8b 15 04 60 27 f0    	mov    0xf0276004,%edx
f0105df7:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105dfd:	f6 c4 10             	test   $0x10,%ah
f0105e00:	75 f5                	jne    f0105df7 <lapic_init+0x102>
    lapicw(TPR, 0);
f0105e02:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e07:	b8 20 00 00 00       	mov    $0x20,%eax
f0105e0c:	e8 b2 fe ff ff       	call   f0105cc3 <lapicw>
}
f0105e11:	c9                   	leave  
f0105e12:	c3                   	ret    
        lapicw(PCINT, MASKED);
f0105e13:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105e18:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105e1d:	e8 a1 fe ff ff       	call   f0105cc3 <lapicw>
f0105e22:	e9 70 ff ff ff       	jmp    f0105d97 <lapic_init+0xa2>

f0105e27 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void) {
    if (lapic)
f0105e27:	83 3d 04 60 27 f0 00 	cmpl   $0x0,0xf0276004
f0105e2e:	74 14                	je     f0105e44 <lapic_eoi+0x1d>
lapic_eoi(void) {
f0105e30:	55                   	push   %ebp
f0105e31:	89 e5                	mov    %esp,%ebp
        lapicw(EOI, 0);
f0105e33:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e38:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105e3d:	e8 81 fe ff ff       	call   f0105cc3 <lapicw>
}
f0105e42:	5d                   	pop    %ebp
f0105e43:	c3                   	ret    
f0105e44:	f3 c3                	repz ret 

f0105e46 <lapic_startap>:
#define IO_RTC  0x70

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr) {
f0105e46:	55                   	push   %ebp
f0105e47:	89 e5                	mov    %esp,%ebp
f0105e49:	56                   	push   %esi
f0105e4a:	53                   	push   %ebx
f0105e4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    cprintf("apicid:%d\tstart\n", apicid);
f0105e4e:	0f b6 75 08          	movzbl 0x8(%ebp),%esi
f0105e52:	83 ec 08             	sub    $0x8,%esp
f0105e55:	56                   	push   %esi
f0105e56:	68 18 8d 10 f0       	push   $0xf0108d18
f0105e5b:	e8 1f dd ff ff       	call   f0103b7f <cprintf>
f0105e60:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105e65:	ba 70 00 00 00       	mov    $0x70,%edx
f0105e6a:	ee                   	out    %al,(%dx)
f0105e6b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105e70:	ba 71 00 00 00       	mov    $0x71,%edx
f0105e75:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105e76:	83 c4 10             	add    $0x10,%esp
f0105e79:	83 3d 8c 4e 23 f0 00 	cmpl   $0x0,0xf0234e8c
f0105e80:	74 7e                	je     f0105f00 <lapic_startap+0xba>
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
    outb(IO_RTC + 1, 0x0A);
    wrv = (uint16_t *) KADDR((0x40 << 4 | 0x67));  // Warm reset vector
    wrv[0] = 0;
f0105e82:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105e89:	00 00 
    wrv[1] = addr >> 4;
f0105e8b:	89 d8                	mov    %ebx,%eax
f0105e8d:	c1 e8 04             	shr    $0x4,%eax
f0105e90:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
f0105e96:	c1 e6 18             	shl    $0x18,%esi
f0105e99:	89 f2                	mov    %esi,%edx
f0105e9b:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ea0:	e8 1e fe ff ff       	call   f0105cc3 <lapicw>
    lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105ea5:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105eaa:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105eaf:	e8 0f fe ff ff       	call   f0105cc3 <lapicw>
    microdelay(200);
    lapicw(ICRLO, INIT | LEVEL);
f0105eb4:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105eb9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ebe:	e8 00 fe ff ff       	call   f0105cc3 <lapicw>
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
f0105ec3:	c1 eb 0c             	shr    $0xc,%ebx
f0105ec6:	80 cf 06             	or     $0x6,%bh
        lapicw(ICRHI, apicid << 24);
f0105ec9:	89 f2                	mov    %esi,%edx
f0105ecb:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ed0:	e8 ee fd ff ff       	call   f0105cc3 <lapicw>
        lapicw(ICRLO, STARTUP | (addr >> 12));
f0105ed5:	89 da                	mov    %ebx,%edx
f0105ed7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105edc:	e8 e2 fd ff ff       	call   f0105cc3 <lapicw>
        lapicw(ICRHI, apicid << 24);
f0105ee1:	89 f2                	mov    %esi,%edx
f0105ee3:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ee8:	e8 d6 fd ff ff       	call   f0105cc3 <lapicw>
        lapicw(ICRLO, STARTUP | (addr >> 12));
f0105eed:	89 da                	mov    %ebx,%edx
f0105eef:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ef4:	e8 ca fd ff ff       	call   f0105cc3 <lapicw>
        microdelay(200);
    }
}
f0105ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105efc:	5b                   	pop    %ebx
f0105efd:	5e                   	pop    %esi
f0105efe:	5d                   	pop    %ebp
f0105eff:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105f00:	68 67 04 00 00       	push   $0x467
f0105f05:	68 64 63 10 f0       	push   $0xf0106364
f0105f0a:	68 92 00 00 00       	push   $0x92
f0105f0f:	68 29 8d 10 f0       	push   $0xf0108d29
f0105f14:	e8 27 a1 ff ff       	call   f0100040 <_panic>

f0105f19 <lapic_ipi>:

void
lapic_ipi(int vector) {
f0105f19:	55                   	push   %ebp
f0105f1a:	89 e5                	mov    %esp,%ebp
    lapicw(ICRLO, OTHERS | FIXED | vector);
f0105f1c:	8b 55 08             	mov    0x8(%ebp),%edx
f0105f1f:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0105f25:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105f2a:	e8 94 fd ff ff       	call   f0105cc3 <lapicw>
    while (lapic[ICRLO] & DELIVS);
f0105f2f:	8b 15 04 60 27 f0    	mov    0xf0276004,%edx
f0105f35:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105f3b:	f6 c4 10             	test   $0x10,%ah
f0105f3e:	75 f5                	jne    f0105f35 <lapic_ipi+0x1c>
}
f0105f40:	5d                   	pop    %ebp
f0105f41:	c3                   	ret    

f0105f42 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0105f42:	55                   	push   %ebp
f0105f43:	89 e5                	mov    %esp,%ebp
f0105f45:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0105f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0105f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105f51:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0105f54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0105f5b:	5d                   	pop    %ebp
f0105f5c:	c3                   	ret    

f0105f5d <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0105f5d:	55                   	push   %ebp
f0105f5e:	89 e5                	mov    %esp,%ebp
f0105f60:	56                   	push   %esi
f0105f61:	53                   	push   %ebx
f0105f62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0105f65:	83 3b 00             	cmpl   $0x0,(%ebx)
f0105f68:	75 07                	jne    f0105f71 <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0105f6a:	ba 01 00 00 00       	mov    $0x1,%edx
f0105f6f:	eb 34                	jmp    f0105fa5 <spin_lock+0x48>
f0105f71:	8b 73 08             	mov    0x8(%ebx),%esi
f0105f74:	e8 62 fd ff ff       	call   f0105cdb <cpunum>
f0105f79:	6b c0 74             	imul   $0x74,%eax,%eax
f0105f7c:	05 20 50 23 f0       	add    $0xf0235020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0105f81:	39 c6                	cmp    %eax,%esi
f0105f83:	75 e5                	jne    f0105f6a <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0105f85:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0105f88:	e8 4e fd ff ff       	call   f0105cdb <cpunum>
f0105f8d:	83 ec 0c             	sub    $0xc,%esp
f0105f90:	53                   	push   %ebx
f0105f91:	50                   	push   %eax
f0105f92:	68 38 8d 10 f0       	push   $0xf0108d38
f0105f97:	6a 41                	push   $0x41
f0105f99:	68 9c 8d 10 f0       	push   $0xf0108d9c
f0105f9e:	e8 9d a0 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0105fa3:	f3 90                	pause  
f0105fa5:	89 d0                	mov    %edx,%eax
f0105fa7:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0105faa:	85 c0                	test   %eax,%eax
f0105fac:	75 f5                	jne    f0105fa3 <spin_lock+0x46>

//    cprintf("lock kernel\n");
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0105fae:	e8 28 fd ff ff       	call   f0105cdb <cpunum>
f0105fb3:	6b c0 74             	imul   $0x74,%eax,%eax
f0105fb6:	05 20 50 23 f0       	add    $0xf0235020,%eax
f0105fbb:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0105fbe:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0105fc1:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0105fc3:	b8 00 00 00 00       	mov    $0x0,%eax
f0105fc8:	eb 0b                	jmp    f0105fd5 <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f0105fca:	8b 4a 04             	mov    0x4(%edx),%ecx
f0105fcd:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0105fd0:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0105fd2:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0105fd5:	83 f8 09             	cmp    $0x9,%eax
f0105fd8:	7f 14                	jg     f0105fee <spin_lock+0x91>
f0105fda:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0105fe0:	77 e8                	ja     f0105fca <spin_lock+0x6d>
f0105fe2:	eb 0a                	jmp    f0105fee <spin_lock+0x91>
		pcs[i] = 0;
f0105fe4:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f0105feb:	83 c0 01             	add    $0x1,%eax
f0105fee:	83 f8 09             	cmp    $0x9,%eax
f0105ff1:	7e f1                	jle    f0105fe4 <spin_lock+0x87>
#endif
}
f0105ff3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105ff6:	5b                   	pop    %ebx
f0105ff7:	5e                   	pop    %esi
f0105ff8:	5d                   	pop    %ebp
f0105ff9:	c3                   	ret    

f0105ffa <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0105ffa:	55                   	push   %ebp
f0105ffb:	89 e5                	mov    %esp,%ebp
f0105ffd:	57                   	push   %edi
f0105ffe:	56                   	push   %esi
f0105fff:	53                   	push   %ebx
f0106000:	83 ec 4c             	sub    $0x4c,%esp
f0106003:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106006:	83 3e 00             	cmpl   $0x0,(%esi)
f0106009:	75 35                	jne    f0106040 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f010600b:	83 ec 04             	sub    $0x4,%esp
f010600e:	6a 28                	push   $0x28
f0106010:	8d 46 0c             	lea    0xc(%esi),%eax
f0106013:	50                   	push   %eax
f0106014:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106017:	53                   	push   %ebx
f0106018:	e8 e8 f6 ff ff       	call   f0105705 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f010601d:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106020:	0f b6 38             	movzbl (%eax),%edi
f0106023:	8b 76 04             	mov    0x4(%esi),%esi
f0106026:	e8 b0 fc ff ff       	call   f0105cdb <cpunum>
f010602b:	57                   	push   %edi
f010602c:	56                   	push   %esi
f010602d:	50                   	push   %eax
f010602e:	68 64 8d 10 f0       	push   $0xf0108d64
f0106033:	e8 47 db ff ff       	call   f0103b7f <cprintf>
f0106038:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f010603b:	8d 7d a8             	lea    -0x58(%ebp),%edi
f010603e:	eb 61                	jmp    f01060a1 <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f0106040:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106043:	e8 93 fc ff ff       	call   f0105cdb <cpunum>
f0106048:	6b c0 74             	imul   $0x74,%eax,%eax
f010604b:	05 20 50 23 f0       	add    $0xf0235020,%eax
	if (!holding(lk)) {
f0106050:	39 c3                	cmp    %eax,%ebx
f0106052:	75 b7                	jne    f010600b <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0106054:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f010605b:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106062:	b8 00 00 00 00       	mov    $0x0,%eax
f0106067:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f010606a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010606d:	5b                   	pop    %ebx
f010606e:	5e                   	pop    %esi
f010606f:	5f                   	pop    %edi
f0106070:	5d                   	pop    %ebp
f0106071:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f0106072:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106074:	83 ec 04             	sub    $0x4,%esp
f0106077:	89 c2                	mov    %eax,%edx
f0106079:	2b 55 b8             	sub    -0x48(%ebp),%edx
f010607c:	52                   	push   %edx
f010607d:	ff 75 b0             	pushl  -0x50(%ebp)
f0106080:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106083:	ff 75 ac             	pushl  -0x54(%ebp)
f0106086:	ff 75 a8             	pushl  -0x58(%ebp)
f0106089:	50                   	push   %eax
f010608a:	68 ac 8d 10 f0       	push   $0xf0108dac
f010608f:	e8 eb da ff ff       	call   f0103b7f <cprintf>
f0106094:	83 c4 20             	add    $0x20,%esp
f0106097:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f010609a:	8d 45 e8             	lea    -0x18(%ebp),%eax
f010609d:	39 c3                	cmp    %eax,%ebx
f010609f:	74 2d                	je     f01060ce <spin_unlock+0xd4>
f01060a1:	89 de                	mov    %ebx,%esi
f01060a3:	8b 03                	mov    (%ebx),%eax
f01060a5:	85 c0                	test   %eax,%eax
f01060a7:	74 25                	je     f01060ce <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01060a9:	83 ec 08             	sub    $0x8,%esp
f01060ac:	57                   	push   %edi
f01060ad:	50                   	push   %eax
f01060ae:	e8 6d eb ff ff       	call   f0104c20 <debuginfo_eip>
f01060b3:	83 c4 10             	add    $0x10,%esp
f01060b6:	85 c0                	test   %eax,%eax
f01060b8:	79 b8                	jns    f0106072 <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f01060ba:	83 ec 08             	sub    $0x8,%esp
f01060bd:	ff 36                	pushl  (%esi)
f01060bf:	68 c3 8d 10 f0       	push   $0xf0108dc3
f01060c4:	e8 b6 da ff ff       	call   f0103b7f <cprintf>
f01060c9:	83 c4 10             	add    $0x10,%esp
f01060cc:	eb c9                	jmp    f0106097 <spin_unlock+0x9d>
		panic("spin_unlock");
f01060ce:	83 ec 04             	sub    $0x4,%esp
f01060d1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01060d6:	6a 68                	push   $0x68
f01060d8:	68 9c 8d 10 f0       	push   $0xf0108d9c
f01060dd:	e8 5e 9f ff ff       	call   f0100040 <_panic>
f01060e2:	66 90                	xchg   %ax,%ax
f01060e4:	66 90                	xchg   %ax,%ax
f01060e6:	66 90                	xchg   %ax,%ax
f01060e8:	66 90                	xchg   %ax,%ax
f01060ea:	66 90                	xchg   %ax,%ax
f01060ec:	66 90                	xchg   %ax,%ax
f01060ee:	66 90                	xchg   %ax,%ax

f01060f0 <__udivdi3>:
f01060f0:	55                   	push   %ebp
f01060f1:	57                   	push   %edi
f01060f2:	56                   	push   %esi
f01060f3:	53                   	push   %ebx
f01060f4:	83 ec 1c             	sub    $0x1c,%esp
f01060f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01060fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01060ff:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106103:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106107:	85 d2                	test   %edx,%edx
f0106109:	75 35                	jne    f0106140 <__udivdi3+0x50>
f010610b:	39 f3                	cmp    %esi,%ebx
f010610d:	0f 87 bd 00 00 00    	ja     f01061d0 <__udivdi3+0xe0>
f0106113:	85 db                	test   %ebx,%ebx
f0106115:	89 d9                	mov    %ebx,%ecx
f0106117:	75 0b                	jne    f0106124 <__udivdi3+0x34>
f0106119:	b8 01 00 00 00       	mov    $0x1,%eax
f010611e:	31 d2                	xor    %edx,%edx
f0106120:	f7 f3                	div    %ebx
f0106122:	89 c1                	mov    %eax,%ecx
f0106124:	31 d2                	xor    %edx,%edx
f0106126:	89 f0                	mov    %esi,%eax
f0106128:	f7 f1                	div    %ecx
f010612a:	89 c6                	mov    %eax,%esi
f010612c:	89 e8                	mov    %ebp,%eax
f010612e:	89 f7                	mov    %esi,%edi
f0106130:	f7 f1                	div    %ecx
f0106132:	89 fa                	mov    %edi,%edx
f0106134:	83 c4 1c             	add    $0x1c,%esp
f0106137:	5b                   	pop    %ebx
f0106138:	5e                   	pop    %esi
f0106139:	5f                   	pop    %edi
f010613a:	5d                   	pop    %ebp
f010613b:	c3                   	ret    
f010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106140:	39 f2                	cmp    %esi,%edx
f0106142:	77 7c                	ja     f01061c0 <__udivdi3+0xd0>
f0106144:	0f bd fa             	bsr    %edx,%edi
f0106147:	83 f7 1f             	xor    $0x1f,%edi
f010614a:	0f 84 98 00 00 00    	je     f01061e8 <__udivdi3+0xf8>
f0106150:	89 f9                	mov    %edi,%ecx
f0106152:	b8 20 00 00 00       	mov    $0x20,%eax
f0106157:	29 f8                	sub    %edi,%eax
f0106159:	d3 e2                	shl    %cl,%edx
f010615b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010615f:	89 c1                	mov    %eax,%ecx
f0106161:	89 da                	mov    %ebx,%edx
f0106163:	d3 ea                	shr    %cl,%edx
f0106165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106169:	09 d1                	or     %edx,%ecx
f010616b:	89 f2                	mov    %esi,%edx
f010616d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106171:	89 f9                	mov    %edi,%ecx
f0106173:	d3 e3                	shl    %cl,%ebx
f0106175:	89 c1                	mov    %eax,%ecx
f0106177:	d3 ea                	shr    %cl,%edx
f0106179:	89 f9                	mov    %edi,%ecx
f010617b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010617f:	d3 e6                	shl    %cl,%esi
f0106181:	89 eb                	mov    %ebp,%ebx
f0106183:	89 c1                	mov    %eax,%ecx
f0106185:	d3 eb                	shr    %cl,%ebx
f0106187:	09 de                	or     %ebx,%esi
f0106189:	89 f0                	mov    %esi,%eax
f010618b:	f7 74 24 08          	divl   0x8(%esp)
f010618f:	89 d6                	mov    %edx,%esi
f0106191:	89 c3                	mov    %eax,%ebx
f0106193:	f7 64 24 0c          	mull   0xc(%esp)
f0106197:	39 d6                	cmp    %edx,%esi
f0106199:	72 0c                	jb     f01061a7 <__udivdi3+0xb7>
f010619b:	89 f9                	mov    %edi,%ecx
f010619d:	d3 e5                	shl    %cl,%ebp
f010619f:	39 c5                	cmp    %eax,%ebp
f01061a1:	73 5d                	jae    f0106200 <__udivdi3+0x110>
f01061a3:	39 d6                	cmp    %edx,%esi
f01061a5:	75 59                	jne    f0106200 <__udivdi3+0x110>
f01061a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01061aa:	31 ff                	xor    %edi,%edi
f01061ac:	89 fa                	mov    %edi,%edx
f01061ae:	83 c4 1c             	add    $0x1c,%esp
f01061b1:	5b                   	pop    %ebx
f01061b2:	5e                   	pop    %esi
f01061b3:	5f                   	pop    %edi
f01061b4:	5d                   	pop    %ebp
f01061b5:	c3                   	ret    
f01061b6:	8d 76 00             	lea    0x0(%esi),%esi
f01061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f01061c0:	31 ff                	xor    %edi,%edi
f01061c2:	31 c0                	xor    %eax,%eax
f01061c4:	89 fa                	mov    %edi,%edx
f01061c6:	83 c4 1c             	add    $0x1c,%esp
f01061c9:	5b                   	pop    %ebx
f01061ca:	5e                   	pop    %esi
f01061cb:	5f                   	pop    %edi
f01061cc:	5d                   	pop    %ebp
f01061cd:	c3                   	ret    
f01061ce:	66 90                	xchg   %ax,%ax
f01061d0:	31 ff                	xor    %edi,%edi
f01061d2:	89 e8                	mov    %ebp,%eax
f01061d4:	89 f2                	mov    %esi,%edx
f01061d6:	f7 f3                	div    %ebx
f01061d8:	89 fa                	mov    %edi,%edx
f01061da:	83 c4 1c             	add    $0x1c,%esp
f01061dd:	5b                   	pop    %ebx
f01061de:	5e                   	pop    %esi
f01061df:	5f                   	pop    %edi
f01061e0:	5d                   	pop    %ebp
f01061e1:	c3                   	ret    
f01061e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01061e8:	39 f2                	cmp    %esi,%edx
f01061ea:	72 06                	jb     f01061f2 <__udivdi3+0x102>
f01061ec:	31 c0                	xor    %eax,%eax
f01061ee:	39 eb                	cmp    %ebp,%ebx
f01061f0:	77 d2                	ja     f01061c4 <__udivdi3+0xd4>
f01061f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01061f7:	eb cb                	jmp    f01061c4 <__udivdi3+0xd4>
f01061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106200:	89 d8                	mov    %ebx,%eax
f0106202:	31 ff                	xor    %edi,%edi
f0106204:	eb be                	jmp    f01061c4 <__udivdi3+0xd4>
f0106206:	66 90                	xchg   %ax,%ax
f0106208:	66 90                	xchg   %ax,%ax
f010620a:	66 90                	xchg   %ax,%ax
f010620c:	66 90                	xchg   %ax,%ax
f010620e:	66 90                	xchg   %ax,%ax

f0106210 <__umoddi3>:
f0106210:	55                   	push   %ebp
f0106211:	57                   	push   %edi
f0106212:	56                   	push   %esi
f0106213:	53                   	push   %ebx
f0106214:	83 ec 1c             	sub    $0x1c,%esp
f0106217:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f010621b:	8b 74 24 30          	mov    0x30(%esp),%esi
f010621f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106223:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106227:	85 ed                	test   %ebp,%ebp
f0106229:	89 f0                	mov    %esi,%eax
f010622b:	89 da                	mov    %ebx,%edx
f010622d:	75 19                	jne    f0106248 <__umoddi3+0x38>
f010622f:	39 df                	cmp    %ebx,%edi
f0106231:	0f 86 b1 00 00 00    	jbe    f01062e8 <__umoddi3+0xd8>
f0106237:	f7 f7                	div    %edi
f0106239:	89 d0                	mov    %edx,%eax
f010623b:	31 d2                	xor    %edx,%edx
f010623d:	83 c4 1c             	add    $0x1c,%esp
f0106240:	5b                   	pop    %ebx
f0106241:	5e                   	pop    %esi
f0106242:	5f                   	pop    %edi
f0106243:	5d                   	pop    %ebp
f0106244:	c3                   	ret    
f0106245:	8d 76 00             	lea    0x0(%esi),%esi
f0106248:	39 dd                	cmp    %ebx,%ebp
f010624a:	77 f1                	ja     f010623d <__umoddi3+0x2d>
f010624c:	0f bd cd             	bsr    %ebp,%ecx
f010624f:	83 f1 1f             	xor    $0x1f,%ecx
f0106252:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106256:	0f 84 b4 00 00 00    	je     f0106310 <__umoddi3+0x100>
f010625c:	b8 20 00 00 00       	mov    $0x20,%eax
f0106261:	89 c2                	mov    %eax,%edx
f0106263:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106267:	29 c2                	sub    %eax,%edx
f0106269:	89 c1                	mov    %eax,%ecx
f010626b:	89 f8                	mov    %edi,%eax
f010626d:	d3 e5                	shl    %cl,%ebp
f010626f:	89 d1                	mov    %edx,%ecx
f0106271:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106275:	d3 e8                	shr    %cl,%eax
f0106277:	09 c5                	or     %eax,%ebp
f0106279:	8b 44 24 04          	mov    0x4(%esp),%eax
f010627d:	89 c1                	mov    %eax,%ecx
f010627f:	d3 e7                	shl    %cl,%edi
f0106281:	89 d1                	mov    %edx,%ecx
f0106283:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106287:	89 df                	mov    %ebx,%edi
f0106289:	d3 ef                	shr    %cl,%edi
f010628b:	89 c1                	mov    %eax,%ecx
f010628d:	89 f0                	mov    %esi,%eax
f010628f:	d3 e3                	shl    %cl,%ebx
f0106291:	89 d1                	mov    %edx,%ecx
f0106293:	89 fa                	mov    %edi,%edx
f0106295:	d3 e8                	shr    %cl,%eax
f0106297:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010629c:	09 d8                	or     %ebx,%eax
f010629e:	f7 f5                	div    %ebp
f01062a0:	d3 e6                	shl    %cl,%esi
f01062a2:	89 d1                	mov    %edx,%ecx
f01062a4:	f7 64 24 08          	mull   0x8(%esp)
f01062a8:	39 d1                	cmp    %edx,%ecx
f01062aa:	89 c3                	mov    %eax,%ebx
f01062ac:	89 d7                	mov    %edx,%edi
f01062ae:	72 06                	jb     f01062b6 <__umoddi3+0xa6>
f01062b0:	75 0e                	jne    f01062c0 <__umoddi3+0xb0>
f01062b2:	39 c6                	cmp    %eax,%esi
f01062b4:	73 0a                	jae    f01062c0 <__umoddi3+0xb0>
f01062b6:	2b 44 24 08          	sub    0x8(%esp),%eax
f01062ba:	19 ea                	sbb    %ebp,%edx
f01062bc:	89 d7                	mov    %edx,%edi
f01062be:	89 c3                	mov    %eax,%ebx
f01062c0:	89 ca                	mov    %ecx,%edx
f01062c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f01062c7:	29 de                	sub    %ebx,%esi
f01062c9:	19 fa                	sbb    %edi,%edx
f01062cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f01062cf:	89 d0                	mov    %edx,%eax
f01062d1:	d3 e0                	shl    %cl,%eax
f01062d3:	89 d9                	mov    %ebx,%ecx
f01062d5:	d3 ee                	shr    %cl,%esi
f01062d7:	d3 ea                	shr    %cl,%edx
f01062d9:	09 f0                	or     %esi,%eax
f01062db:	83 c4 1c             	add    $0x1c,%esp
f01062de:	5b                   	pop    %ebx
f01062df:	5e                   	pop    %esi
f01062e0:	5f                   	pop    %edi
f01062e1:	5d                   	pop    %ebp
f01062e2:	c3                   	ret    
f01062e3:	90                   	nop
f01062e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01062e8:	85 ff                	test   %edi,%edi
f01062ea:	89 f9                	mov    %edi,%ecx
f01062ec:	75 0b                	jne    f01062f9 <__umoddi3+0xe9>
f01062ee:	b8 01 00 00 00       	mov    $0x1,%eax
f01062f3:	31 d2                	xor    %edx,%edx
f01062f5:	f7 f7                	div    %edi
f01062f7:	89 c1                	mov    %eax,%ecx
f01062f9:	89 d8                	mov    %ebx,%eax
f01062fb:	31 d2                	xor    %edx,%edx
f01062fd:	f7 f1                	div    %ecx
f01062ff:	89 f0                	mov    %esi,%eax
f0106301:	f7 f1                	div    %ecx
f0106303:	e9 31 ff ff ff       	jmp    f0106239 <__umoddi3+0x29>
f0106308:	90                   	nop
f0106309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106310:	39 dd                	cmp    %ebx,%ebp
f0106312:	72 08                	jb     f010631c <__umoddi3+0x10c>
f0106314:	39 f7                	cmp    %esi,%edi
f0106316:	0f 87 21 ff ff ff    	ja     f010623d <__umoddi3+0x2d>
f010631c:	89 da                	mov    %ebx,%edx
f010631e:	89 f0                	mov    %esi,%eax
f0106320:	29 f8                	sub    %edi,%eax
f0106322:	19 ea                	sbb    %ebp,%edx
f0106324:	e9 14 ff ff ff       	jmp    f010623d <__umoddi3+0x2d>
