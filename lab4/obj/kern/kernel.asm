
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
f010006b:	e8 33 5b 00 00       	call   f0105ba3 <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 00 62 10 f0       	push   $0xf0106200
f010007c:	e8 24 3a 00 00       	call   f0103aa5 <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 f4 39 00 00       	call   f0103a7f <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 26 79 10 f0 	movl   $0xf0107926,(%esp)
f0100092:	e8 0e 3a 00 00       	call   f0103aa5 <cprintf>
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
f01000b0:	68 6c 62 10 f0       	push   $0xf010626c
f01000b5:	e8 eb 39 00 00       	call   f0103aa5 <cprintf>
	mem_init();
f01000ba:	e8 d7 12 00 00       	call   f0101396 <mem_init>
	env_init();
f01000bf:	e8 36 32 00 00       	call   f01032fa <env_init>
	trap_init();
f01000c4:	e8 8f 3b 00 00       	call   f0103c58 <trap_init>
	mp_init();
f01000c9:	e8 c3 57 00 00       	call   f0105891 <mp_init>
	lapic_init();
f01000ce:	e8 ea 5a 00 00       	call   f0105bbd <lapic_init>
	pic_init();
f01000d3:	e8 f0 38 00 00       	call   f01039c8 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000d8:	c7 04 24 c0 23 12 f0 	movl   $0xf01223c0,(%esp)
f01000df:	e8 41 5d 00 00       	call   f0105e25 <spin_lock>
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
f01000f3:	b8 f6 57 10 f0       	mov    $0xf01057f6,%eax
f01000f8:	2d 7c 57 10 f0       	sub    $0xf010577c,%eax
f01000fd:	50                   	push   %eax
f01000fe:	68 7c 57 10 f0       	push   $0xf010577c
f0100103:	68 00 70 00 f0       	push   $0xf0007000
f0100108:	e8 c0 54 00 00       	call   f01055cd <memmove>
f010010d:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100110:	bb 20 50 23 f0       	mov    $0xf0235020,%ebx
f0100115:	eb 19                	jmp    f0100130 <i386_init+0x94>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100117:	68 00 70 00 00       	push   $0x7000
f010011c:	68 24 62 10 f0       	push   $0xf0106224
f0100121:	6a 50                	push   $0x50
f0100123:	68 87 62 10 f0       	push   $0xf0106287
f0100128:	e8 13 ff ff ff       	call   f0100040 <_panic>
f010012d:	83 c3 74             	add    $0x74,%ebx
f0100130:	6b 05 c4 53 23 f0 74 	imul   $0x74,0xf02353c4,%eax
f0100137:	05 20 50 23 f0       	add    $0xf0235020,%eax
f010013c:	39 c3                	cmp    %eax,%ebx
f010013e:	73 4c                	jae    f010018c <i386_init+0xf0>
		if (c == cpus + cpunum())  // We've started already.
f0100140:	e8 5e 5a 00 00       	call   f0105ba3 <cpunum>
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
f010017a:	e8 8f 5b 00 00       	call   f0105d0e <lapic_startap>
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
f0100196:	e8 ef 32 00 00       	call   f010348a <env_create>
	sched_yield();
f010019b:	e8 f5 42 00 00       	call   f0104495 <sched_yield>

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
f01001b3:	68 48 62 10 f0       	push   $0xf0106248
f01001b8:	6a 67                	push   $0x67
f01001ba:	68 87 62 10 f0       	push   $0xf0106287
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
f01001cc:	e8 d2 59 00 00       	call   f0105ba3 <cpunum>
f01001d1:	83 ec 08             	sub    $0x8,%esp
f01001d4:	50                   	push   %eax
f01001d5:	68 93 62 10 f0       	push   $0xf0106293
f01001da:	e8 c6 38 00 00       	call   f0103aa5 <cprintf>
	lapic_init();
f01001df:	e8 d9 59 00 00       	call   f0105bbd <lapic_init>
	env_init_percpu();
f01001e4:	e8 e1 30 00 00       	call   f01032ca <env_init_percpu>
	trap_init_percpu();
f01001e9:	e8 ec 38 00 00       	call   f0103ada <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001ee:	e8 b0 59 00 00       	call   f0105ba3 <cpunum>
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
f010020c:	e8 14 5c 00 00       	call   f0105e25 <spin_lock>
    sched_yield();
f0100211:	e8 7f 42 00 00       	call   f0104495 <sched_yield>

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
f0100226:	68 a9 62 10 f0       	push   $0xf01062a9
f010022b:	e8 75 38 00 00       	call   f0103aa5 <cprintf>
	vcprintf(fmt, ap);
f0100230:	83 c4 08             	add    $0x8,%esp
f0100233:	53                   	push   %ebx
f0100234:	ff 75 10             	pushl  0x10(%ebp)
f0100237:	e8 43 38 00 00       	call   f0103a7f <vcprintf>
	cprintf("\n");
f010023c:	c7 04 24 26 79 10 f0 	movl   $0xf0107926,(%esp)
f0100243:	e8 5d 38 00 00       	call   f0103aa5 <cprintf>
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
f0100303:	0f b6 82 20 64 10 f0 	movzbl -0xfef9be0(%edx),%eax
f010030a:	0b 05 00 40 23 f0    	or     0xf0234000,%eax
	shift ^= togglecode[data];
f0100310:	0f b6 8a 20 63 10 f0 	movzbl -0xfef9ce0(%edx),%ecx
f0100317:	31 c8                	xor    %ecx,%eax
f0100319:	a3 00 40 23 f0       	mov    %eax,0xf0234000
	c = charcode[shift & (CTL | SHIFT)][data];
f010031e:	89 c1                	mov    %eax,%ecx
f0100320:	83 e1 03             	and    $0x3,%ecx
f0100323:	8b 0c 8d 00 63 10 f0 	mov    -0xfef9d00(,%ecx,4),%ecx
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
f0100353:	68 c3 62 10 f0       	push   $0xf01062c3
f0100358:	e8 48 37 00 00       	call   f0103aa5 <cprintf>
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
f0100396:	0f b6 82 20 64 10 f0 	movzbl -0xfef9be0(%edx),%eax
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
f0100597:	e8 31 50 00 00       	call   f01055cd <memmove>
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
f01006c8:	e8 7d 32 00 00       	call   f010394a <irq_setmask_8259A>
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
f010075e:	68 cf 62 10 f0       	push   $0xf01062cf
f0100763:	e8 3d 33 00 00       	call   f0103aa5 <cprintf>
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
f010079e:	68 20 65 10 f0       	push   $0xf0106520
f01007a3:	68 3e 65 10 f0       	push   $0xf010653e
f01007a8:	68 43 65 10 f0       	push   $0xf0106543
f01007ad:	e8 f3 32 00 00       	call   f0103aa5 <cprintf>
f01007b2:	83 c4 0c             	add    $0xc,%esp
f01007b5:	68 e8 65 10 f0       	push   $0xf01065e8
f01007ba:	68 4c 65 10 f0       	push   $0xf010654c
f01007bf:	68 43 65 10 f0       	push   $0xf0106543
f01007c4:	e8 dc 32 00 00       	call   f0103aa5 <cprintf>
f01007c9:	83 c4 0c             	add    $0xc,%esp
f01007cc:	68 55 65 10 f0       	push   $0xf0106555
f01007d1:	68 73 65 10 f0       	push   $0xf0106573
f01007d6:	68 43 65 10 f0       	push   $0xf0106543
f01007db:	e8 c5 32 00 00       	call   f0103aa5 <cprintf>
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
f01007ed:	68 7d 65 10 f0       	push   $0xf010657d
f01007f2:	e8 ae 32 00 00       	call   f0103aa5 <cprintf>
    cprintf("  _start                  %08x (phys)\n", _start);
f01007f7:	83 c4 08             	add    $0x8,%esp
f01007fa:	68 0c 00 10 00       	push   $0x10000c
f01007ff:	68 10 66 10 f0       	push   $0xf0106610
f0100804:	e8 9c 32 00 00       	call   f0103aa5 <cprintf>
    cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100809:	83 c4 0c             	add    $0xc,%esp
f010080c:	68 0c 00 10 00       	push   $0x10000c
f0100811:	68 0c 00 10 f0       	push   $0xf010000c
f0100816:	68 38 66 10 f0       	push   $0xf0106638
f010081b:	e8 85 32 00 00       	call   f0103aa5 <cprintf>
    cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100820:	83 c4 0c             	add    $0xc,%esp
f0100823:	68 e9 61 10 00       	push   $0x1061e9
f0100828:	68 e9 61 10 f0       	push   $0xf01061e9
f010082d:	68 5c 66 10 f0       	push   $0xf010665c
f0100832:	e8 6e 32 00 00       	call   f0103aa5 <cprintf>
    cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100837:	83 c4 0c             	add    $0xc,%esp
f010083a:	68 00 40 23 00       	push   $0x234000
f010083f:	68 00 40 23 f0       	push   $0xf0234000
f0100844:	68 80 66 10 f0       	push   $0xf0106680
f0100849:	e8 57 32 00 00       	call   f0103aa5 <cprintf>
    cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010084e:	83 c4 0c             	add    $0xc,%esp
f0100851:	68 08 60 27 00       	push   $0x276008
f0100856:	68 08 60 27 f0       	push   $0xf0276008
f010085b:	68 a4 66 10 f0       	push   $0xf01066a4
f0100860:	e8 40 32 00 00       	call   f0103aa5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
f0100865:	83 c4 08             	add    $0x8,%esp
            ROUNDUP(end - entry, 1024) / 1024);
f0100868:	b8 07 64 27 f0       	mov    $0xf0276407,%eax
f010086d:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
    cprintf("Kernel executable memory footprint: %dKB\n",
f0100872:	c1 f8 0a             	sar    $0xa,%eax
f0100875:	50                   	push   %eax
f0100876:	68 c8 66 10 f0       	push   $0xf01066c8
f010087b:	e8 25 32 00 00       	call   f0103aa5 <cprintf>
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
f01008ab:	68 f4 66 10 f0       	push   $0xf01066f4
f01008b0:	e8 f0 31 00 00       	call   f0103aa5 <cprintf>
        debuginfo_eip(eip, &eipDebugInfo);
f01008b5:	83 c4 18             	add    $0x18,%esp
f01008b8:	57                   	push   %edi
f01008b9:	56                   	push   %esi
f01008ba:	e8 29 42 00 00       	call   f0104ae8 <debuginfo_eip>
        cprintf("\t %s:%d:  %.*s+%d\n", eipDebugInfo.eip_file, eipDebugInfo.eip_line, eipDebugInfo.eip_fn_namelen, eipDebugInfo.eip_fn_name,
f01008bf:	83 c4 08             	add    $0x8,%esp
f01008c2:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01008c5:	56                   	push   %esi
f01008c6:	ff 75 d8             	pushl  -0x28(%ebp)
f01008c9:	ff 75 dc             	pushl  -0x24(%ebp)
f01008cc:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008cf:	ff 75 d0             	pushl  -0x30(%ebp)
f01008d2:	68 96 65 10 f0       	push   $0xf0106596
f01008d7:	e8 c9 31 00 00       	call   f0103aa5 <cprintf>
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
f01008fb:	68 2c 67 10 f0       	push   $0xf010672c
f0100900:	e8 a0 31 00 00       	call   f0103aa5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
f0100905:	c7 04 24 50 67 10 f0 	movl   $0xf0106750,(%esp)
f010090c:	e8 94 31 00 00       	call   f0103aa5 <cprintf>

	if (tf != NULL)
f0100911:	83 c4 10             	add    $0x10,%esp
f0100914:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100918:	74 57                	je     f0100971 <monitor+0x7f>
		print_trapframe(tf);
f010091a:	83 ec 0c             	sub    $0xc,%esp
f010091d:	ff 75 08             	pushl  0x8(%ebp)
f0100920:	e8 9d 34 00 00       	call   f0103dc2 <print_trapframe>
f0100925:	83 c4 10             	add    $0x10,%esp
f0100928:	eb 47                	jmp    f0100971 <monitor+0x7f>
        while (*buf && strchr(WHITESPACE, *buf))
f010092a:	83 ec 08             	sub    $0x8,%esp
f010092d:	0f be c0             	movsbl %al,%eax
f0100930:	50                   	push   %eax
f0100931:	68 ad 65 10 f0       	push   $0xf01065ad
f0100936:	e8 08 4c 00 00       	call   f0105543 <strchr>
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
f0100964:	68 b2 65 10 f0       	push   $0xf01065b2
f0100969:	e8 37 31 00 00       	call   f0103aa5 <cprintf>
f010096e:	83 c4 10             	add    $0x10,%esp

    while (1) {
        buf = readline("K> ");
f0100971:	83 ec 0c             	sub    $0xc,%esp
f0100974:	68 a9 65 10 f0       	push   $0xf01065a9
f0100979:	e8 a8 49 00 00       	call   f0105326 <readline>
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
f01009a6:	68 ad 65 10 f0       	push   $0xf01065ad
f01009ab:	e8 93 4b 00 00       	call   f0105543 <strchr>
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
f01009db:	ff 34 85 80 67 10 f0 	pushl  -0xfef9880(,%eax,4)
f01009e2:	ff 75 a8             	pushl  -0x58(%ebp)
f01009e5:	e8 fb 4a 00 00       	call   f01054e5 <strcmp>
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
f01009ff:	68 cf 65 10 f0       	push   $0xf01065cf
f0100a04:	e8 9c 30 00 00       	call   f0103aa5 <cprintf>
f0100a09:	83 c4 10             	add    $0x10,%esp
f0100a0c:	e9 60 ff ff ff       	jmp    f0100971 <monitor+0x7f>
            return commands[i].func(argc, argv, tf);
f0100a11:	83 ec 04             	sub    $0x4,%esp
f0100a14:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a17:	ff 75 08             	pushl  0x8(%ebp)
f0100a1a:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a1d:	52                   	push   %edx
f0100a1e:	56                   	push   %esi
f0100a1f:	ff 14 85 88 67 10 f0 	call   *-0xfef9878(,%eax,4)
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
f0100a44:	e8 d3 2e 00 00       	call   f010391c <mc146818_read>
f0100a49:	89 c3                	mov    %eax,%ebx
f0100a4b:	83 c6 01             	add    $0x1,%esi
f0100a4e:	89 34 24             	mov    %esi,(%esp)
f0100a51:	e8 c6 2e 00 00       	call   f010391c <mc146818_read>
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
f0100aae:	68 a4 67 10 f0       	push   $0xf01067a4
f0100ab3:	68 e1 75 10 f0       	push   $0xf01075e1
f0100ab8:	6a 73                	push   $0x73
f0100aba:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0100b0e:	68 24 62 10 f0       	push   $0xf0106224
f0100b13:	68 ed 03 00 00       	push   $0x3ed
f0100b18:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0100b4f:	68 cc 67 10 f0       	push   $0xf01067cc
f0100b54:	68 18 03 00 00       	push   $0x318
f0100b59:	68 f6 75 10 f0       	push   $0xf01075f6
f0100b5e:	e8 dd f4 ff ff       	call   f0100040 <_panic>
f0100b63:	50                   	push   %eax
f0100b64:	68 24 62 10 f0       	push   $0xf0106224
f0100b69:	6a 58                	push   $0x58
f0100b6b:	68 02 76 10 f0       	push   $0xf0107602
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
f0100bb2:	e8 c9 49 00 00       	call   f0105580 <memset>
f0100bb7:	83 c4 10             	add    $0x10,%esp
f0100bba:	eb b9                	jmp    f0100b75 <check_page_free_list+0x4d>
    first_free_page = (char *) boot_alloc(0);
f0100bbc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100bc1:	e8 9c fe ff ff       	call   f0100a62 <boot_alloc>
f0100bc6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    cprintf("first_free_page:0x%x\n", first_free_page);
f0100bc9:	83 ec 08             	sub    $0x8,%esp
f0100bcc:	50                   	push   %eax
f0100bcd:	68 10 76 10 f0       	push   $0xf0107610
f0100bd2:	e8 ce 2e 00 00       	call   f0103aa5 <cprintf>
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
f0100c01:	68 26 76 10 f0       	push   $0xf0107626
f0100c06:	68 e1 75 10 f0       	push   $0xf01075e1
f0100c0b:	68 39 03 00 00       	push   $0x339
f0100c10:	68 f6 75 10 f0       	push   $0xf01075f6
f0100c15:	e8 26 f4 ff ff       	call   f0100040 <_panic>
        assert(pp < pages + npages);
f0100c1a:	68 32 76 10 f0       	push   $0xf0107632
f0100c1f:	68 e1 75 10 f0       	push   $0xf01075e1
f0100c24:	68 3a 03 00 00       	push   $0x33a
f0100c29:	68 f6 75 10 f0       	push   $0xf01075f6
f0100c2e:	e8 0d f4 ff ff       	call   f0100040 <_panic>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c33:	68 3c 68 10 f0       	push   $0xf010683c
f0100c38:	68 e1 75 10 f0       	push   $0xf01075e1
f0100c3d:	68 3b 03 00 00       	push   $0x33b
f0100c42:	68 f6 75 10 f0       	push   $0xf01075f6
f0100c47:	e8 f4 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != 0);
f0100c4c:	68 46 76 10 f0       	push   $0xf0107646
f0100c51:	68 e1 75 10 f0       	push   $0xf01075e1
f0100c56:	68 3e 03 00 00       	push   $0x33e
f0100c5b:	68 f6 75 10 f0       	push   $0xf01075f6
f0100c60:	e8 db f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != IOPHYSMEM);
f0100c65:	68 57 76 10 f0       	push   $0xf0107657
f0100c6a:	68 e1 75 10 f0       	push   $0xf01075e1
f0100c6f:	68 3f 03 00 00       	push   $0x33f
f0100c74:	68 f6 75 10 f0       	push   $0xf01075f6
f0100c79:	e8 c2 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c7e:	68 70 68 10 f0       	push   $0xf0106870
f0100c83:	68 e1 75 10 f0       	push   $0xf01075e1
f0100c88:	68 40 03 00 00       	push   $0x340
f0100c8d:	68 f6 75 10 f0       	push   $0xf01075f6
f0100c92:	e8 a9 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100c97:	68 70 76 10 f0       	push   $0xf0107670
f0100c9c:	68 e1 75 10 f0       	push   $0xf01075e1
f0100ca1:	68 41 03 00 00       	push   $0x341
f0100ca6:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0100cd6:	68 24 62 10 f0       	push   $0xf0106224
f0100cdb:	6a 58                	push   $0x58
f0100cdd:	68 02 76 10 f0       	push   $0xf0107602
f0100ce2:	e8 59 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ce7:	68 94 68 10 f0       	push   $0xf0106894
f0100cec:	68 e1 75 10 f0       	push   $0xf01075e1
f0100cf1:	68 42 03 00 00       	push   $0x342
f0100cf6:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0100d68:	68 8a 76 10 f0       	push   $0xf010768a
f0100d6d:	68 e1 75 10 f0       	push   $0xf01075e1
f0100d72:	68 44 03 00 00       	push   $0x344
f0100d77:	68 f6 75 10 f0       	push   $0xf01075f6
f0100d7c:	e8 bf f2 ff ff       	call   f0100040 <_panic>
    cprintf("nfree_basemem:0x%x\tnfree_extmem:0x%x\n", nfree_basemem, nfree_extmem);
f0100d81:	83 ec 04             	sub    $0x4,%esp
f0100d84:	53                   	push   %ebx
f0100d85:	56                   	push   %esi
f0100d86:	68 dc 68 10 f0       	push   $0xf01068dc
f0100d8b:	e8 15 2d 00 00       	call   f0103aa5 <cprintf>
    cprintf("物理内存占用中页数:0x%x\n", 8 * PGSIZE - nfree_basemem - nfree_extmem);
f0100d90:	83 c4 08             	add    $0x8,%esp
f0100d93:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100d98:	29 f0                	sub    %esi,%eax
f0100d9a:	29 d8                	sub    %ebx,%eax
f0100d9c:	50                   	push   %eax
f0100d9d:	68 04 69 10 f0       	push   $0xf0106904
f0100da2:	e8 fe 2c 00 00       	call   f0103aa5 <cprintf>
    assert(nfree_basemem > 0);
f0100da7:	83 c4 10             	add    $0x10,%esp
f0100daa:	85 f6                	test   %esi,%esi
f0100dac:	7e 19                	jle    f0100dc7 <check_page_free_list+0x29f>
    assert(nfree_extmem > 0);
f0100dae:	85 db                	test   %ebx,%ebx
f0100db0:	7e 2e                	jle    f0100de0 <check_page_free_list+0x2b8>
    cprintf("check_page_free_list() succeeded!\n");
f0100db2:	83 ec 0c             	sub    $0xc,%esp
f0100db5:	68 28 69 10 f0       	push   $0xf0106928
f0100dba:	e8 e6 2c 00 00       	call   f0103aa5 <cprintf>
}
f0100dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dc2:	5b                   	pop    %ebx
f0100dc3:	5e                   	pop    %esi
f0100dc4:	5f                   	pop    %edi
f0100dc5:	5d                   	pop    %ebp
f0100dc6:	c3                   	ret    
    assert(nfree_basemem > 0);
f0100dc7:	68 a7 76 10 f0       	push   $0xf01076a7
f0100dcc:	68 e1 75 10 f0       	push   $0xf01075e1
f0100dd1:	68 50 03 00 00       	push   $0x350
f0100dd6:	68 f6 75 10 f0       	push   $0xf01075f6
f0100ddb:	e8 60 f2 ff ff       	call   f0100040 <_panic>
    assert(nfree_extmem > 0);
f0100de0:	68 b9 76 10 f0       	push   $0xf01076b9
f0100de5:	68 e1 75 10 f0       	push   $0xf01075e1
f0100dea:	68 51 03 00 00       	push   $0x351
f0100def:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0100e4a:	68 f0 67 10 f0       	push   $0xf01067f0
f0100e4f:	e8 51 2c 00 00       	call   f0103aa5 <cprintf>
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
f0100eca:	68 4c 69 10 f0       	push   $0xf010694c
f0100ecf:	e8 d1 2b 00 00       	call   f0103aa5 <cprintf>
    cprintf("初始page_free_list:0x%x\n", page_free_list);
f0100ed4:	83 c4 18             	add    $0x18,%esp
f0100ed7:	ff 35 44 42 23 f0    	pushl  0xf0234244
f0100edd:	68 ca 76 10 f0       	push   $0xf01076ca
f0100ee2:	e8 be 2b 00 00       	call   f0103aa5 <cprintf>
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0100ee7:	83 c4 10             	add    $0x10,%esp
f0100eea:	bb 01 00 00 00       	mov    $0x1,%ebx
f0100eef:	81 e7 ff ff 0f 00    	and    $0xfffff,%edi
f0100ef5:	eb 2d                	jmp    f0100f24 <page_init+0xaa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100ef7:	51                   	push   %ecx
f0100ef8:	68 48 62 10 f0       	push   $0xf0106248
f0100efd:	68 5c 01 00 00       	push   $0x15c
f0100f02:	68 f6 75 10 f0       	push   $0xf01075f6
f0100f07:	e8 34 f1 ff ff       	call   f0100040 <_panic>
            cprintf("avoid adding the page at MPENTRY_PADDR: 0x%x\n", i * PGSIZE);
f0100f0c:	83 ec 08             	sub    $0x8,%esp
f0100f0f:	68 00 70 00 00       	push   $0x7000
f0100f14:	68 80 69 10 f0       	push   $0xf0106980
f0100f19:	e8 87 2b 00 00       	call   f0103aa5 <cprintf>
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
f0100fc4:	68 e5 76 10 f0       	push   $0xf01076e5
f0100fc9:	e8 eb 2a 00 00       	call   f0103ab9 <memCprintf>
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
f0100fe2:	68 48 62 10 f0       	push   $0xf0106248
f0100fe7:	68 77 01 00 00       	push   $0x177
f0100fec:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0101052:	e8 29 45 00 00       	call   f0105580 <memset>
f0101057:	83 c4 10             	add    $0x10,%esp
f010105a:	eb c4                	jmp    f0101020 <page_alloc+0x2a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010105c:	50                   	push   %eax
f010105d:	68 24 62 10 f0       	push   $0xf0106224
f0101062:	6a 58                	push   $0x58
f0101064:	68 02 76 10 f0       	push   $0xf0107602
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
f0101092:	68 f4 76 10 f0       	push   $0xf01076f4
f0101097:	68 e1 75 10 f0       	push   $0xf01075e1
f010109c:	68 9e 01 00 00       	push   $0x19e
f01010a1:	68 f6 75 10 f0       	push   $0xf01075f6
f01010a6:	e8 95 ef ff ff       	call   f0100040 <_panic>
    assert(!pp->pp_link);
f01010ab:	68 00 77 10 f0       	push   $0xf0107700
f01010b0:	68 e1 75 10 f0       	push   $0xf01075e1
f01010b5:	68 9f 01 00 00       	push   $0x19f
f01010ba:	68 f6 75 10 f0       	push   $0xf01075f6
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
f010115d:	68 24 62 10 f0       	push   $0xf0106224
f0101162:	68 03 02 00 00       	push   $0x203
f0101167:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0101210:	68 b0 69 10 f0       	push   $0xf01069b0
f0101215:	6a 51                	push   $0x51
f0101217:	68 02 76 10 f0       	push   $0xf0107602
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
f010125e:	e8 1d 43 00 00       	call   f0105580 <memset>
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
f01012bc:	68 b0 69 10 f0       	push   $0xf01069b0
f01012c1:	6a 51                	push   $0x51
f01012c3:	68 02 76 10 f0       	push   $0xf0107602
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
f010137b:	68 24 62 10 f0       	push   $0xf0106224
f0101380:	68 4f 02 00 00       	push   $0x24f
f0101385:	68 f6 75 10 f0       	push   $0xf01075f6
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
f01013fe:	68 d0 69 10 f0       	push   $0xf01069d0
f0101403:	e8 9d 26 00 00       	call   f0103aa5 <cprintf>
    cprintf("sizeof(uint16_t):0x%x\n", sizeof(unsigned short));
f0101408:	83 c4 08             	add    $0x8,%esp
f010140b:	6a 02                	push   $0x2
f010140d:	68 0d 77 10 f0       	push   $0xf010770d
f0101412:	e8 8e 26 00 00       	call   f0103aa5 <cprintf>
    cprintf("npages:0x%x\tsizeof(Struct PageInfo):0x%x\n", npages, sizeof(struct PageInfo));
f0101417:	83 c4 0c             	add    $0xc,%esp
f010141a:	6a 08                	push   $0x8
f010141c:	ff 35 8c 4e 23 f0    	pushl  0xf0234e8c
f0101422:	68 10 6a 10 f0       	push   $0xf0106a10
f0101427:	e8 79 26 00 00       	call   f0103aa5 <cprintf>
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
f0101460:	68 24 77 10 f0       	push   $0xf0107724
f0101465:	e8 4f 26 00 00       	call   f0103ab9 <memCprintf>
    memset(kern_pgdir, 0, PGSIZE);
f010146a:	83 c4 1c             	add    $0x1c,%esp
f010146d:	68 00 10 00 00       	push   $0x1000
f0101472:	6a 00                	push   $0x0
f0101474:	ff 35 90 4e 23 f0    	pushl  0xf0234e90
f010147a:	e8 01 41 00 00       	call   f0105580 <memset>
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
f01014b7:	68 2f 77 10 f0       	push   $0xf010772f
f01014bc:	e8 f8 25 00 00       	call   f0103ab9 <memCprintf>
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
f01014f9:	e8 82 40 00 00       	call   f0105580 <memset>
    cprintf("pages占用空间:%dK\n", ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) / 1024);
f01014fe:	83 c4 08             	add    $0x8,%esp
f0101501:	a1 8c 4e 23 f0       	mov    0xf0234e8c,%eax
f0101506:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010150d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101512:	c1 e8 0a             	shr    $0xa,%eax
f0101515:	50                   	push   %eax
f0101516:	68 34 77 10 f0       	push   $0xf0107734
f010151b:	e8 85 25 00 00       	call   f0103aa5 <cprintf>
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
f010154a:	68 2c 76 10 f0       	push   $0xf010762c
f010154f:	e8 65 25 00 00       	call   f0103ab9 <memCprintf>
    cprintf("sizeof(struct Env):0x%x\n", sizeof(struct Env));
f0101554:	83 c4 18             	add    $0x18,%esp
f0101557:	6a 7c                	push   $0x7c
f0101559:	68 4b 77 10 f0       	push   $0xf010774b
f010155e:	e8 42 25 00 00       	call   f0103aa5 <cprintf>
    envs = boot_alloc(ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101563:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101568:	e8 f5 f4 ff ff       	call   f0100a62 <boot_alloc>
f010156d:	a3 4c 42 23 f0       	mov    %eax,0xf023424c
    memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101572:	83 c4 0c             	add    $0xc,%esp
f0101575:	68 00 f0 01 00       	push   $0x1f000
f010157a:	6a 00                	push   $0x0
f010157c:	50                   	push   %eax
f010157d:	e8 fe 3f 00 00       	call   f0105580 <memset>
    cprintf("envs take up memory:%dK\n", ROUNDUP(NENV * sizeof(struct Env), PGSIZE) / 1024);
f0101582:	83 c4 08             	add    $0x8,%esp
f0101585:	6a 7c                	push   $0x7c
f0101587:	68 64 77 10 f0       	push   $0xf0107764
f010158c:	e8 14 25 00 00       	call   f0103aa5 <cprintf>
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
f01015bb:	68 7d 77 10 f0       	push   $0xf010777d
f01015c0:	e8 f4 24 00 00       	call   f0103ab9 <memCprintf>
    page_init();
f01015c5:	83 c4 20             	add    $0x20,%esp
f01015c8:	e8 ad f8 ff ff       	call   f0100e7a <page_init>
    cprintf("\n************* Now Check that the pages on the page_free_list are reasonable ************\n");
f01015cd:	83 ec 0c             	sub    $0xc,%esp
f01015d0:	68 3c 6a 10 f0       	push   $0xf0106a3c
f01015d5:	e8 cb 24 00 00       	call   f0103aa5 <cprintf>
    check_page_free_list(1);
f01015da:	b8 01 00 00 00       	mov    $0x1,%eax
f01015df:	e8 44 f5 ff ff       	call   f0100b28 <check_page_free_list>
    cprintf("\n************* Now check the real physical page allocator (page_alloc(), page_free(), and page_init())************\n");
f01015e4:	c7 04 24 98 6a 10 f0 	movl   $0xf0106a98,(%esp)
f01015eb:	e8 b5 24 00 00       	call   f0103aa5 <cprintf>
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
f0101618:	68 48 62 10 f0       	push   $0xf0106248
f010161d:	68 98 00 00 00       	push   $0x98
f0101622:	68 f6 75 10 f0       	push   $0xf01075f6
f0101627:	e8 14 ea ff ff       	call   f0100040 <_panic>
f010162c:	50                   	push   %eax
f010162d:	68 48 62 10 f0       	push   $0xf0106248
f0101632:	68 a2 00 00 00       	push   $0xa2
f0101637:	68 f6 75 10 f0       	push   $0xf01075f6
f010163c:	e8 ff e9 ff ff       	call   f0100040 <_panic>
f0101641:	50                   	push   %eax
f0101642:	68 48 62 10 f0       	push   $0xf0106248
f0101647:	68 af 00 00 00       	push   $0xaf
f010164c:	68 f6 75 10 f0       	push   $0xf01075f6
f0101651:	e8 ea e9 ff ff       	call   f0100040 <_panic>
f0101656:	50                   	push   %eax
f0101657:	68 48 62 10 f0       	push   $0xf0106248
f010165c:	68 b7 00 00 00       	push   $0xb7
f0101661:	68 f6 75 10 f0       	push   $0xf01075f6
f0101666:	e8 d5 e9 ff ff       	call   f0100040 <_panic>
        panic("'pages' is a null pointer!");
f010166b:	83 ec 04             	sub    $0x4,%esp
f010166e:	68 82 77 10 f0       	push   $0xf0107782
f0101673:	68 62 03 00 00       	push   $0x362
f0101678:	68 f6 75 10 f0       	push   $0xf01075f6
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
f010181c:	e8 5f 3d 00 00       	call   f0105580 <memset>
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
f01018b4:	68 9d 77 10 f0       	push   $0xf010779d
f01018b9:	68 e1 75 10 f0       	push   $0xf01075e1
f01018be:	68 6a 03 00 00       	push   $0x36a
f01018c3:	68 f6 75 10 f0       	push   $0xf01075f6
f01018c8:	e8 73 e7 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f01018cd:	68 b3 77 10 f0       	push   $0xf01077b3
f01018d2:	68 e1 75 10 f0       	push   $0xf01075e1
f01018d7:	68 6b 03 00 00       	push   $0x36b
f01018dc:	68 f6 75 10 f0       	push   $0xf01075f6
f01018e1:	e8 5a e7 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f01018e6:	68 c9 77 10 f0       	push   $0xf01077c9
f01018eb:	68 e1 75 10 f0       	push   $0xf01075e1
f01018f0:	68 6c 03 00 00       	push   $0x36c
f01018f5:	68 f6 75 10 f0       	push   $0xf01075f6
f01018fa:	e8 41 e7 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01018ff:	68 df 77 10 f0       	push   $0xf01077df
f0101904:	68 e1 75 10 f0       	push   $0xf01075e1
f0101909:	68 6f 03 00 00       	push   $0x36f
f010190e:	68 f6 75 10 f0       	push   $0xf01075f6
f0101913:	e8 28 e7 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101918:	68 0c 6b 10 f0       	push   $0xf0106b0c
f010191d:	68 e1 75 10 f0       	push   $0xf01075e1
f0101922:	68 70 03 00 00       	push   $0x370
f0101927:	68 f6 75 10 f0       	push   $0xf01075f6
f010192c:	e8 0f e7 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp0) < npages * PGSIZE);
f0101931:	68 2c 6b 10 f0       	push   $0xf0106b2c
f0101936:	68 e1 75 10 f0       	push   $0xf01075e1
f010193b:	68 71 03 00 00       	push   $0x371
f0101940:	68 f6 75 10 f0       	push   $0xf01075f6
f0101945:	e8 f6 e6 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp1) < npages * PGSIZE);
f010194a:	68 4c 6b 10 f0       	push   $0xf0106b4c
f010194f:	68 e1 75 10 f0       	push   $0xf01075e1
f0101954:	68 72 03 00 00       	push   $0x372
f0101959:	68 f6 75 10 f0       	push   $0xf01075f6
f010195e:	e8 dd e6 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp2) < npages * PGSIZE);
f0101963:	68 6c 6b 10 f0       	push   $0xf0106b6c
f0101968:	68 e1 75 10 f0       	push   $0xf01075e1
f010196d:	68 73 03 00 00       	push   $0x373
f0101972:	68 f6 75 10 f0       	push   $0xf01075f6
f0101977:	e8 c4 e6 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f010197c:	68 f1 77 10 f0       	push   $0xf01077f1
f0101981:	68 e1 75 10 f0       	push   $0xf01075e1
f0101986:	68 7a 03 00 00       	push   $0x37a
f010198b:	68 f6 75 10 f0       	push   $0xf01075f6
f0101990:	e8 ab e6 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0101995:	68 9d 77 10 f0       	push   $0xf010779d
f010199a:	68 e1 75 10 f0       	push   $0xf01075e1
f010199f:	68 81 03 00 00       	push   $0x381
f01019a4:	68 f6 75 10 f0       	push   $0xf01075f6
f01019a9:	e8 92 e6 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f01019ae:	68 b3 77 10 f0       	push   $0xf01077b3
f01019b3:	68 e1 75 10 f0       	push   $0xf01075e1
f01019b8:	68 82 03 00 00       	push   $0x382
f01019bd:	68 f6 75 10 f0       	push   $0xf01075f6
f01019c2:	e8 79 e6 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f01019c7:	68 c9 77 10 f0       	push   $0xf01077c9
f01019cc:	68 e1 75 10 f0       	push   $0xf01075e1
f01019d1:	68 83 03 00 00       	push   $0x383
f01019d6:	68 f6 75 10 f0       	push   $0xf01075f6
f01019db:	e8 60 e6 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01019e0:	68 df 77 10 f0       	push   $0xf01077df
f01019e5:	68 e1 75 10 f0       	push   $0xf01075e1
f01019ea:	68 85 03 00 00       	push   $0x385
f01019ef:	68 f6 75 10 f0       	push   $0xf01075f6
f01019f4:	e8 47 e6 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019f9:	68 0c 6b 10 f0       	push   $0xf0106b0c
f01019fe:	68 e1 75 10 f0       	push   $0xf01075e1
f0101a03:	68 86 03 00 00       	push   $0x386
f0101a08:	68 f6 75 10 f0       	push   $0xf01075f6
f0101a0d:	e8 2e e6 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0101a12:	68 f1 77 10 f0       	push   $0xf01077f1
f0101a17:	68 e1 75 10 f0       	push   $0xf01075e1
f0101a1c:	68 87 03 00 00       	push   $0x387
f0101a21:	68 f6 75 10 f0       	push   $0xf01075f6
f0101a26:	e8 15 e6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101a2b:	50                   	push   %eax
f0101a2c:	68 24 62 10 f0       	push   $0xf0106224
f0101a31:	6a 58                	push   $0x58
f0101a33:	68 02 76 10 f0       	push   $0xf0107602
f0101a38:	e8 03 e6 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101a3d:	68 00 78 10 f0       	push   $0xf0107800
f0101a42:	68 e1 75 10 f0       	push   $0xf01075e1
f0101a47:	68 8c 03 00 00       	push   $0x38c
f0101a4c:	68 f6 75 10 f0       	push   $0xf01075f6
f0101a51:	e8 ea e5 ff ff       	call   f0100040 <_panic>
    assert(pp && pp0 == pp);
f0101a56:	68 1e 78 10 f0       	push   $0xf010781e
f0101a5b:	68 e1 75 10 f0       	push   $0xf01075e1
f0101a60:	68 8d 03 00 00       	push   $0x38d
f0101a65:	68 f6 75 10 f0       	push   $0xf01075f6
f0101a6a:	e8 d1 e5 ff ff       	call   f0100040 <_panic>
f0101a6f:	52                   	push   %edx
f0101a70:	68 24 62 10 f0       	push   $0xf0106224
f0101a75:	6a 58                	push   $0x58
f0101a77:	68 02 76 10 f0       	push   $0xf0107602
f0101a7c:	e8 bf e5 ff ff       	call   f0100040 <_panic>
        assert(c[i] == 0);
f0101a81:	68 2e 78 10 f0       	push   $0xf010782e
f0101a86:	68 e1 75 10 f0       	push   $0xf01075e1
f0101a8b:	68 90 03 00 00       	push   $0x390
f0101a90:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0101aae:	68 8c 6b 10 f0       	push   $0xf0106b8c
f0101ab3:	e8 ed 1f 00 00       	call   f0103aa5 <cprintf>
    cprintf("\n************* Now check page_insert, page_remove, &c **************\n");
f0101ab8:	c7 04 24 ac 6b 10 f0 	movl   $0xf0106bac,(%esp)
f0101abf:	e8 e1 1f 00 00       	call   f0103aa5 <cprintf>
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
f010207c:	68 18 70 10 f0       	push   $0xf0107018
f0102081:	e8 1f 1a 00 00       	call   f0103aa5 <cprintf>
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
f01020dd:	e8 9e 34 00 00       	call   f0105580 <memset>
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
f0102176:	c7 04 24 0f 79 10 f0 	movl   $0xf010790f,(%esp)
f010217d:	e8 23 19 00 00       	call   f0103aa5 <cprintf>
    cprintf("\n************* Now we set up virtual memory **************\n");
f0102182:	c7 04 24 78 70 10 f0 	movl   $0xf0107078,(%esp)
f0102189:	e8 17 19 00 00       	call   f0103aa5 <cprintf>
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
f01021ba:	68 2f 77 10 f0       	push   $0xf010772f
f01021bf:	e8 f5 18 00 00       	call   f0103ab9 <memCprintf>
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
f01021ee:	68 2c 76 10 f0       	push   $0xf010762c
f01021f3:	e8 c1 18 00 00       	call   f0103ab9 <memCprintf>
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
f0102222:	68 7d 77 10 f0       	push   $0xf010777d
f0102227:	e8 8d 18 00 00       	call   f0103ab9 <memCprintf>
    cprintf("\n************* Now we map 'pages' read-only by the user at linear address UPAGES **************\n");
f010222c:	83 c4 14             	add    $0x14,%esp
f010222f:	68 b4 70 10 f0       	push   $0xf01070b4
f0102234:	e8 6c 18 00 00       	call   f0103aa5 <cprintf>
    cprintf("page2pa(pages):0x%x\n", page2pa(pages));
f0102239:	83 c4 08             	add    $0x8,%esp
f010223c:	6a 00                	push   $0x0
f010223e:	68 28 79 10 f0       	push   $0xf0107928
f0102243:	e8 5d 18 00 00       	call   f0103aa5 <cprintf>
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
f0102288:	c7 04 24 18 71 10 f0 	movl   $0xf0107118,(%esp)
f010228f:	e8 11 18 00 00       	call   f0103aa5 <cprintf>
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
f01022c6:	c7 04 24 78 71 10 f0 	movl   $0xf0107178,(%esp)
f01022cd:	e8 d3 17 00 00       	call   f0103aa5 <cprintf>
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
f0102303:	c7 04 24 e4 71 10 f0 	movl   $0xf01071e4,(%esp)
f010230a:	e8 96 17 00 00       	call   f0103aa5 <cprintf>
    boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE + 1, 0, PTE_W | PTE_P);//这权限有必要？？
f010230f:	83 c4 08             	add    $0x8,%esp
f0102312:	6a 03                	push   $0x3
f0102314:	6a 00                	push   $0x0
f0102316:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010231b:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102320:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0102325:	e8 55 ee ff ff       	call   f010117f <boot_map_region>
    cprintf("Map per-CPU stacks starting at KSTACKTOP, for up to 'NCPU' CPUs.\n");
f010232a:	c7 04 24 30 72 10 f0 	movl   $0xf0107230,(%esp)
f0102331:	e8 6f 17 00 00       	call   f0103aa5 <cprintf>
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
f010236d:	68 74 72 10 f0       	push   $0xf0107274
f0102372:	e8 2e 17 00 00       	call   f0103aa5 <cprintf>
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
f01023a4:	68 a4 72 10 f0       	push   $0xf01072a4
f01023a9:	e8 f7 16 00 00       	call   f0103aa5 <cprintf>
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
f010241a:	68 38 78 10 f0       	push   $0xf0107838
f010241f:	68 e1 75 10 f0       	push   $0xf01075e1
f0102424:	68 9d 03 00 00       	push   $0x39d
f0102429:	68 f6 75 10 f0       	push   $0xf01075f6
f010242e:	e8 0d dc ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0102433:	68 9d 77 10 f0       	push   $0xf010779d
f0102438:	68 e1 75 10 f0       	push   $0xf01075e1
f010243d:	68 00 04 00 00       	push   $0x400
f0102442:	68 f6 75 10 f0       	push   $0xf01075f6
f0102447:	e8 f4 db ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f010244c:	68 b3 77 10 f0       	push   $0xf01077b3
f0102451:	68 e1 75 10 f0       	push   $0xf01075e1
f0102456:	68 01 04 00 00       	push   $0x401
f010245b:	68 f6 75 10 f0       	push   $0xf01075f6
f0102460:	e8 db db ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0102465:	68 c9 77 10 f0       	push   $0xf01077c9
f010246a:	68 e1 75 10 f0       	push   $0xf01075e1
f010246f:	68 02 04 00 00       	push   $0x402
f0102474:	68 f6 75 10 f0       	push   $0xf01075f6
f0102479:	e8 c2 db ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f010247e:	68 df 77 10 f0       	push   $0xf01077df
f0102483:	68 e1 75 10 f0       	push   $0xf01075e1
f0102488:	68 05 04 00 00       	push   $0x405
f010248d:	68 f6 75 10 f0       	push   $0xf01075f6
f0102492:	e8 a9 db ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102497:	68 0c 6b 10 f0       	push   $0xf0106b0c
f010249c:	68 e1 75 10 f0       	push   $0xf01075e1
f01024a1:	68 06 04 00 00       	push   $0x406
f01024a6:	68 f6 75 10 f0       	push   $0xf01075f6
f01024ab:	e8 90 db ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01024b0:	68 f1 77 10 f0       	push   $0xf01077f1
f01024b5:	68 e1 75 10 f0       	push   $0xf01075e1
f01024ba:	68 0d 04 00 00       	push   $0x40d
f01024bf:	68 f6 75 10 f0       	push   $0xf01075f6
f01024c4:	e8 77 db ff ff       	call   f0100040 <_panic>
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01024c9:	68 f4 6b 10 f0       	push   $0xf0106bf4
f01024ce:	68 e1 75 10 f0       	push   $0xf01075e1
f01024d3:	68 10 04 00 00       	push   $0x410
f01024d8:	68 f6 75 10 f0       	push   $0xf01075f6
f01024dd:	e8 5e db ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01024e2:	68 2c 6c 10 f0       	push   $0xf0106c2c
f01024e7:	68 e1 75 10 f0       	push   $0xf01075e1
f01024ec:	68 13 04 00 00       	push   $0x413
f01024f1:	68 f6 75 10 f0       	push   $0xf01075f6
f01024f6:	e8 45 db ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01024fb:	68 5c 6c 10 f0       	push   $0xf0106c5c
f0102500:	68 e1 75 10 f0       	push   $0xf01075e1
f0102505:	68 17 04 00 00       	push   $0x417
f010250a:	68 f6 75 10 f0       	push   $0xf01075f6
f010250f:	e8 2c db ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102514:	68 8c 6c 10 f0       	push   $0xf0106c8c
f0102519:	68 e1 75 10 f0       	push   $0xf01075e1
f010251e:	68 18 04 00 00       	push   $0x418
f0102523:	68 f6 75 10 f0       	push   $0xf01075f6
f0102528:	e8 13 db ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010252d:	68 b4 6c 10 f0       	push   $0xf0106cb4
f0102532:	68 e1 75 10 f0       	push   $0xf01075e1
f0102537:	68 19 04 00 00       	push   $0x419
f010253c:	68 f6 75 10 f0       	push   $0xf01075f6
f0102541:	e8 fa da ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102546:	68 43 78 10 f0       	push   $0xf0107843
f010254b:	68 e1 75 10 f0       	push   $0xf01075e1
f0102550:	68 1a 04 00 00       	push   $0x41a
f0102555:	68 f6 75 10 f0       	push   $0xf01075f6
f010255a:	e8 e1 da ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f010255f:	68 54 78 10 f0       	push   $0xf0107854
f0102564:	68 e1 75 10 f0       	push   $0xf01075e1
f0102569:	68 1b 04 00 00       	push   $0x41b
f010256e:	68 f6 75 10 f0       	push   $0xf01075f6
f0102573:	e8 c8 da ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102578:	68 e4 6c 10 f0       	push   $0xf0106ce4
f010257d:	68 e1 75 10 f0       	push   $0xf01075e1
f0102582:	68 1e 04 00 00       	push   $0x41e
f0102587:	68 f6 75 10 f0       	push   $0xf01075f6
f010258c:	e8 af da ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102591:	68 20 6d 10 f0       	push   $0xf0106d20
f0102596:	68 e1 75 10 f0       	push   $0xf01075e1
f010259b:	68 1f 04 00 00       	push   $0x41f
f01025a0:	68 f6 75 10 f0       	push   $0xf01075f6
f01025a5:	e8 96 da ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f01025aa:	68 65 78 10 f0       	push   $0xf0107865
f01025af:	68 e1 75 10 f0       	push   $0xf01075e1
f01025b4:	68 20 04 00 00       	push   $0x420
f01025b9:	68 f6 75 10 f0       	push   $0xf01075f6
f01025be:	e8 7d da ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01025c3:	68 f1 77 10 f0       	push   $0xf01077f1
f01025c8:	68 e1 75 10 f0       	push   $0xf01075e1
f01025cd:	68 23 04 00 00       	push   $0x423
f01025d2:	68 f6 75 10 f0       	push   $0xf01075f6
f01025d7:	e8 64 da ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01025dc:	68 e4 6c 10 f0       	push   $0xf0106ce4
f01025e1:	68 e1 75 10 f0       	push   $0xf01075e1
f01025e6:	68 26 04 00 00       	push   $0x426
f01025eb:	68 f6 75 10 f0       	push   $0xf01075f6
f01025f0:	e8 4b da ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01025f5:	68 20 6d 10 f0       	push   $0xf0106d20
f01025fa:	68 e1 75 10 f0       	push   $0xf01075e1
f01025ff:	68 27 04 00 00       	push   $0x427
f0102604:	68 f6 75 10 f0       	push   $0xf01075f6
f0102609:	e8 32 da ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f010260e:	68 65 78 10 f0       	push   $0xf0107865
f0102613:	68 e1 75 10 f0       	push   $0xf01075e1
f0102618:	68 28 04 00 00       	push   $0x428
f010261d:	68 f6 75 10 f0       	push   $0xf01075f6
f0102622:	e8 19 da ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0102627:	68 f1 77 10 f0       	push   $0xf01077f1
f010262c:	68 e1 75 10 f0       	push   $0xf01075e1
f0102631:	68 2c 04 00 00       	push   $0x42c
f0102636:	68 f6 75 10 f0       	push   $0xf01075f6
f010263b:	e8 00 da ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102640:	50                   	push   %eax
f0102641:	68 24 62 10 f0       	push   $0xf0106224
f0102646:	68 2f 04 00 00       	push   $0x42f
f010264b:	68 f6 75 10 f0       	push   $0xf01075f6
f0102650:	e8 eb d9 ff ff       	call   f0100040 <_panic>
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102655:	68 50 6d 10 f0       	push   $0xf0106d50
f010265a:	68 e1 75 10 f0       	push   $0xf01075e1
f010265f:	68 30 04 00 00       	push   $0x430
f0102664:	68 f6 75 10 f0       	push   $0xf01075f6
f0102669:	e8 d2 d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f010266e:	68 94 6d 10 f0       	push   $0xf0106d94
f0102673:	68 e1 75 10 f0       	push   $0xf01075e1
f0102678:	68 33 04 00 00       	push   $0x433
f010267d:	68 f6 75 10 f0       	push   $0xf01075f6
f0102682:	e8 b9 d9 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102687:	68 20 6d 10 f0       	push   $0xf0106d20
f010268c:	68 e1 75 10 f0       	push   $0xf01075e1
f0102691:	68 34 04 00 00       	push   $0x434
f0102696:	68 f6 75 10 f0       	push   $0xf01075f6
f010269b:	e8 a0 d9 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f01026a0:	68 65 78 10 f0       	push   $0xf0107865
f01026a5:	68 e1 75 10 f0       	push   $0xf01075e1
f01026aa:	68 35 04 00 00       	push   $0x435
f01026af:	68 f6 75 10 f0       	push   $0xf01075f6
f01026b4:	e8 87 d9 ff ff       	call   f0100040 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f01026b9:	68 d8 6d 10 f0       	push   $0xf0106dd8
f01026be:	68 e1 75 10 f0       	push   $0xf01075e1
f01026c3:	68 36 04 00 00       	push   $0x436
f01026c8:	68 f6 75 10 f0       	push   $0xf01075f6
f01026cd:	e8 6e d9 ff ff       	call   f0100040 <_panic>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f01026d2:	68 76 78 10 f0       	push   $0xf0107876
f01026d7:	68 e1 75 10 f0       	push   $0xf01075e1
f01026dc:	68 37 04 00 00       	push   $0x437
f01026e1:	68 f6 75 10 f0       	push   $0xf01075f6
f01026e6:	e8 55 d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01026eb:	68 e4 6c 10 f0       	push   $0xf0106ce4
f01026f0:	68 e1 75 10 f0       	push   $0xf01075e1
f01026f5:	68 3a 04 00 00       	push   $0x43a
f01026fa:	68 f6 75 10 f0       	push   $0xf01075f6
f01026ff:	e8 3c d9 ff ff       	call   f0100040 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102704:	68 0c 6e 10 f0       	push   $0xf0106e0c
f0102709:	68 e1 75 10 f0       	push   $0xf01075e1
f010270e:	68 3b 04 00 00       	push   $0x43b
f0102713:	68 f6 75 10 f0       	push   $0xf01075f6
f0102718:	e8 23 d9 ff ff       	call   f0100040 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f010271d:	68 40 6e 10 f0       	push   $0xf0106e40
f0102722:	68 e1 75 10 f0       	push   $0xf01075e1
f0102727:	68 3c 04 00 00       	push   $0x43c
f010272c:	68 f6 75 10 f0       	push   $0xf01075f6
f0102731:	e8 0a d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102736:	68 78 6e 10 f0       	push   $0xf0106e78
f010273b:	68 e1 75 10 f0       	push   $0xf01075e1
f0102740:	68 3f 04 00 00       	push   $0x43f
f0102745:	68 f6 75 10 f0       	push   $0xf01075f6
f010274a:	e8 f1 d8 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f010274f:	68 b4 6e 10 f0       	push   $0xf0106eb4
f0102754:	68 e1 75 10 f0       	push   $0xf01075e1
f0102759:	68 42 04 00 00       	push   $0x442
f010275e:	68 f6 75 10 f0       	push   $0xf01075f6
f0102763:	e8 d8 d8 ff ff       	call   f0100040 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102768:	68 40 6e 10 f0       	push   $0xf0106e40
f010276d:	68 e1 75 10 f0       	push   $0xf01075e1
f0102772:	68 43 04 00 00       	push   $0x443
f0102777:	68 f6 75 10 f0       	push   $0xf01075f6
f010277c:	e8 bf d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102781:	68 f0 6e 10 f0       	push   $0xf0106ef0
f0102786:	68 e1 75 10 f0       	push   $0xf01075e1
f010278b:	68 46 04 00 00       	push   $0x446
f0102790:	68 f6 75 10 f0       	push   $0xf01075f6
f0102795:	e8 a6 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010279a:	68 1c 6f 10 f0       	push   $0xf0106f1c
f010279f:	68 e1 75 10 f0       	push   $0xf01075e1
f01027a4:	68 47 04 00 00       	push   $0x447
f01027a9:	68 f6 75 10 f0       	push   $0xf01075f6
f01027ae:	e8 8d d8 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 2);
f01027b3:	68 8c 78 10 f0       	push   $0xf010788c
f01027b8:	68 e1 75 10 f0       	push   $0xf01075e1
f01027bd:	68 49 04 00 00       	push   $0x449
f01027c2:	68 f6 75 10 f0       	push   $0xf01075f6
f01027c7:	e8 74 d8 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f01027cc:	68 9d 78 10 f0       	push   $0xf010789d
f01027d1:	68 e1 75 10 f0       	push   $0xf01075e1
f01027d6:	68 4a 04 00 00       	push   $0x44a
f01027db:	68 f6 75 10 f0       	push   $0xf01075f6
f01027e0:	e8 5b d8 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(0)) && pp == pp2);
f01027e5:	68 4c 6f 10 f0       	push   $0xf0106f4c
f01027ea:	68 e1 75 10 f0       	push   $0xf01075e1
f01027ef:	68 4d 04 00 00       	push   $0x44d
f01027f4:	68 f6 75 10 f0       	push   $0xf01075f6
f01027f9:	e8 42 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027fe:	68 70 6f 10 f0       	push   $0xf0106f70
f0102803:	68 e1 75 10 f0       	push   $0xf01075e1
f0102808:	68 51 04 00 00       	push   $0x451
f010280d:	68 f6 75 10 f0       	push   $0xf01075f6
f0102812:	e8 29 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102817:	68 1c 6f 10 f0       	push   $0xf0106f1c
f010281c:	68 e1 75 10 f0       	push   $0xf01075e1
f0102821:	68 52 04 00 00       	push   $0x452
f0102826:	68 f6 75 10 f0       	push   $0xf01075f6
f010282b:	e8 10 d8 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102830:	68 43 78 10 f0       	push   $0xf0107843
f0102835:	68 e1 75 10 f0       	push   $0xf01075e1
f010283a:	68 53 04 00 00       	push   $0x453
f010283f:	68 f6 75 10 f0       	push   $0xf01075f6
f0102844:	e8 f7 d7 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0102849:	68 9d 78 10 f0       	push   $0xf010789d
f010284e:	68 e1 75 10 f0       	push   $0xf01075e1
f0102853:	68 54 04 00 00       	push   $0x454
f0102858:	68 f6 75 10 f0       	push   $0xf01075f6
f010285d:	e8 de d7 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102862:	68 94 6f 10 f0       	push   $0xf0106f94
f0102867:	68 e1 75 10 f0       	push   $0xf01075e1
f010286c:	68 57 04 00 00       	push   $0x457
f0102871:	68 f6 75 10 f0       	push   $0xf01075f6
f0102876:	e8 c5 d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref);
f010287b:	68 ae 78 10 f0       	push   $0xf01078ae
f0102880:	68 e1 75 10 f0       	push   $0xf01075e1
f0102885:	68 58 04 00 00       	push   $0x458
f010288a:	68 f6 75 10 f0       	push   $0xf01075f6
f010288f:	e8 ac d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_link == NULL);
f0102894:	68 ba 78 10 f0       	push   $0xf01078ba
f0102899:	68 e1 75 10 f0       	push   $0xf01075e1
f010289e:	68 59 04 00 00       	push   $0x459
f01028a3:	68 f6 75 10 f0       	push   $0xf01075f6
f01028a8:	e8 93 d7 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01028ad:	68 70 6f 10 f0       	push   $0xf0106f70
f01028b2:	68 e1 75 10 f0       	push   $0xf01075e1
f01028b7:	68 5d 04 00 00       	push   $0x45d
f01028bc:	68 f6 75 10 f0       	push   $0xf01075f6
f01028c1:	e8 7a d7 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01028c6:	68 cc 6f 10 f0       	push   $0xf0106fcc
f01028cb:	68 e1 75 10 f0       	push   $0xf01075e1
f01028d0:	68 5e 04 00 00       	push   $0x45e
f01028d5:	68 f6 75 10 f0       	push   $0xf01075f6
f01028da:	e8 61 d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f01028df:	68 cf 78 10 f0       	push   $0xf01078cf
f01028e4:	68 e1 75 10 f0       	push   $0xf01075e1
f01028e9:	68 5f 04 00 00       	push   $0x45f
f01028ee:	68 f6 75 10 f0       	push   $0xf01075f6
f01028f3:	e8 48 d7 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f01028f8:	68 9d 78 10 f0       	push   $0xf010789d
f01028fd:	68 e1 75 10 f0       	push   $0xf01075e1
f0102902:	68 60 04 00 00       	push   $0x460
f0102907:	68 f6 75 10 f0       	push   $0xf01075f6
f010290c:	e8 2f d7 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(0)) && pp == pp1);
f0102911:	68 f4 6f 10 f0       	push   $0xf0106ff4
f0102916:	68 e1 75 10 f0       	push   $0xf01075e1
f010291b:	68 63 04 00 00       	push   $0x463
f0102920:	68 f6 75 10 f0       	push   $0xf01075f6
f0102925:	e8 16 d7 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f010292a:	68 f1 77 10 f0       	push   $0xf01077f1
f010292f:	68 e1 75 10 f0       	push   $0xf01075e1
f0102934:	68 66 04 00 00       	push   $0x466
f0102939:	68 f6 75 10 f0       	push   $0xf01075f6
f010293e:	e8 fd d6 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102943:	68 8c 6c 10 f0       	push   $0xf0106c8c
f0102948:	68 e1 75 10 f0       	push   $0xf01075e1
f010294d:	68 69 04 00 00       	push   $0x469
f0102952:	68 f6 75 10 f0       	push   $0xf01075f6
f0102957:	e8 e4 d6 ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f010295c:	68 54 78 10 f0       	push   $0xf0107854
f0102961:	68 e1 75 10 f0       	push   $0xf01075e1
f0102966:	68 6b 04 00 00       	push   $0x46b
f010296b:	68 f6 75 10 f0       	push   $0xf01075f6
f0102970:	e8 cb d6 ff ff       	call   f0100040 <_panic>
f0102975:	56                   	push   %esi
f0102976:	68 24 62 10 f0       	push   $0xf0106224
f010297b:	68 72 04 00 00       	push   $0x472
f0102980:	68 f6 75 10 f0       	push   $0xf01075f6
f0102985:	e8 b6 d6 ff ff       	call   f0100040 <_panic>
    assert(ptep == ptep1 + PTX(va));
f010298a:	68 e0 78 10 f0       	push   $0xf01078e0
f010298f:	68 e1 75 10 f0       	push   $0xf01075e1
f0102994:	68 77 04 00 00       	push   $0x477
f0102999:	68 f6 75 10 f0       	push   $0xf01075f6
f010299e:	e8 9d d6 ff ff       	call   f0100040 <_panic>
f01029a3:	50                   	push   %eax
f01029a4:	68 24 62 10 f0       	push   $0xf0106224
f01029a9:	6a 58                	push   $0x58
f01029ab:	68 02 76 10 f0       	push   $0xf0107602
f01029b0:	e8 8b d6 ff ff       	call   f0100040 <_panic>
f01029b5:	52                   	push   %edx
f01029b6:	68 24 62 10 f0       	push   $0xf0106224
f01029bb:	6a 58                	push   $0x58
f01029bd:	68 02 76 10 f0       	push   $0xf0107602
f01029c2:	e8 79 d6 ff ff       	call   f0100040 <_panic>
        assert((ptep[i] & PTE_P) == 0);
f01029c7:	68 f8 78 10 f0       	push   $0xf01078f8
f01029cc:	68 e1 75 10 f0       	push   $0xf01075e1
f01029d1:	68 81 04 00 00       	push   $0x481
f01029d6:	68 f6 75 10 f0       	push   $0xf01075f6
f01029db:	e8 60 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029e0:	50                   	push   %eax
f01029e1:	68 48 62 10 f0       	push   $0xf0106248
f01029e6:	68 d1 00 00 00       	push   $0xd1
f01029eb:	68 f6 75 10 f0       	push   $0xf01075f6
f01029f0:	e8 4b d6 ff ff       	call   f0100040 <_panic>
f01029f5:	50                   	push   %eax
f01029f6:	68 48 62 10 f0       	push   $0xf0106248
f01029fb:	68 d2 00 00 00       	push   $0xd2
f0102a00:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a05:	e8 36 d6 ff ff       	call   f0100040 <_panic>
f0102a0a:	50                   	push   %eax
f0102a0b:	68 48 62 10 f0       	push   $0xf0106248
f0102a10:	68 d3 00 00 00       	push   $0xd3
f0102a15:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a1a:	e8 21 d6 ff ff       	call   f0100040 <_panic>
f0102a1f:	50                   	push   %eax
f0102a20:	68 48 62 10 f0       	push   $0xf0106248
f0102a25:	68 d7 00 00 00       	push   $0xd7
f0102a2a:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a2f:	e8 0c d6 ff ff       	call   f0100040 <_panic>
f0102a34:	50                   	push   %eax
f0102a35:	68 48 62 10 f0       	push   $0xf0106248
f0102a3a:	68 e1 00 00 00       	push   $0xe1
f0102a3f:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a44:	e8 f7 d5 ff ff       	call   f0100040 <_panic>
f0102a49:	50                   	push   %eax
f0102a4a:	68 48 62 10 f0       	push   $0xf0106248
f0102a4f:	68 f2 00 00 00       	push   $0xf2
f0102a54:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a59:	e8 e2 d5 ff ff       	call   f0100040 <_panic>
f0102a5e:	56                   	push   %esi
f0102a5f:	68 48 62 10 f0       	push   $0xf0106248
f0102a64:	68 36 01 00 00       	push   $0x136
f0102a69:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a6e:	e8 cd d5 ff ff       	call   f0100040 <_panic>
f0102a73:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102a76:	68 48 62 10 f0       	push   $0xf0106248
f0102a7b:	68 b4 03 00 00       	push   $0x3b4
f0102a80:	68 f6 75 10 f0       	push   $0xf01075f6
f0102a85:	e8 b6 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a8a:	68 08 73 10 f0       	push   $0xf0107308
f0102a8f:	68 e1 75 10 f0       	push   $0xf01075e1
f0102a94:	68 b4 03 00 00       	push   $0x3b4
f0102a99:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0102b0b:	68 48 62 10 f0       	push   $0xf0106248
f0102b10:	68 b9 03 00 00       	push   $0x3b9
f0102b15:	68 f6 75 10 f0       	push   $0xf01075f6
f0102b1a:	e8 21 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102b1f:	68 3c 73 10 f0       	push   $0xf010733c
f0102b24:	68 e1 75 10 f0       	push   $0xf01075e1
f0102b29:	68 b9 03 00 00       	push   $0x3b9
f0102b2e:	68 f6 75 10 f0       	push   $0xf01075f6
f0102b33:	e8 08 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b38:	68 70 73 10 f0       	push   $0xf0107370
f0102b3d:	68 e1 75 10 f0       	push   $0xf01075e1
f0102b42:	68 bd 03 00 00       	push   $0x3bd
f0102b47:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0102bec:	68 48 62 10 f0       	push   $0xf0106248
f0102bf1:	68 c5 03 00 00       	push   $0x3c5
f0102bf6:	68 f6 75 10 f0       	push   $0xf01075f6
f0102bfb:	e8 40 d4 ff ff       	call   f0100040 <_panic>
            assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102c00:	68 98 73 10 f0       	push   $0xf0107398
f0102c05:	68 e1 75 10 f0       	push   $0xf01075e1
f0102c0a:	68 c5 03 00 00       	push   $0x3c5
f0102c0f:	68 f6 75 10 f0       	push   $0xf01075f6
f0102c14:	e8 27 d4 ff ff       	call   f0100040 <_panic>
            assert(check_va2pa(pgdir, base + i) == ~0);
f0102c19:	68 e0 73 10 f0       	push   $0xf01073e0
f0102c1e:	68 e1 75 10 f0       	push   $0xf01075e1
f0102c23:	68 c7 03 00 00       	push   $0x3c7
f0102c28:	68 f6 75 10 f0       	push   $0xf01075f6
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
f0102c61:	68 5f 79 10 f0       	push   $0xf010795f
f0102c66:	68 e1 75 10 f0       	push   $0xf01075e1
f0102c6b:	68 da 03 00 00       	push   $0x3da
f0102c70:	68 f6 75 10 f0       	push   $0xf01075f6
f0102c75:	e8 c6 d3 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_P);
f0102c7a:	68 3d 79 10 f0       	push   $0xf010793d
f0102c7f:	68 e1 75 10 f0       	push   $0xf01075e1
f0102c84:	68 d7 03 00 00       	push   $0x3d7
f0102c89:	68 f6 75 10 f0       	push   $0xf01075f6
f0102c8e:	e8 ad d3 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_W);
f0102c93:	68 4e 79 10 f0       	push   $0xf010794e
f0102c98:	68 e1 75 10 f0       	push   $0xf01075e1
f0102c9d:	68 d8 03 00 00       	push   $0x3d8
f0102ca2:	68 f6 75 10 f0       	push   $0xf01075f6
f0102ca7:	e8 94 d3 ff ff       	call   f0100040 <_panic>
    cprintf("check_kern_pgdir() succeeded!\n");
f0102cac:	83 ec 0c             	sub    $0xc,%esp
f0102caf:	68 04 74 10 f0       	push   $0xf0107404
f0102cb4:	e8 ec 0d 00 00       	call   f0103aa5 <cprintf>
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
f0102cd7:	68 24 74 10 f0       	push   $0xf0107424
f0102cdc:	e8 c4 0d 00 00       	call   f0103aa5 <cprintf>
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
f0102cf9:	c7 04 24 84 74 10 f0 	movl   $0xf0107484,(%esp)
f0102d00:	e8 a0 0d 00 00       	call   f0103aa5 <cprintf>
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
f0102d87:	e8 f4 27 00 00       	call   f0105580 <memset>
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
f0102dbe:	e8 bd 27 00 00       	call   f0105580 <memset>
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
f0102ece:	c7 04 24 5c 75 10 f0 	movl   $0xf010755c,(%esp)
f0102ed5:	e8 cb 0b 00 00       	call   f0103aa5 <cprintf>
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
f0102ee6:	68 48 62 10 f0       	push   $0xf0106248
f0102eeb:	68 0c 01 00 00       	push   $0x10c
f0102ef0:	68 f6 75 10 f0       	push   $0xf01075f6
f0102ef5:	e8 46 d1 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0102efa:	68 9d 77 10 f0       	push   $0xf010779d
f0102eff:	68 e1 75 10 f0       	push   $0xf01075e1
f0102f04:	68 9b 04 00 00       	push   $0x49b
f0102f09:	68 f6 75 10 f0       	push   $0xf01075f6
f0102f0e:	e8 2d d1 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0102f13:	68 b3 77 10 f0       	push   $0xf01077b3
f0102f18:	68 e1 75 10 f0       	push   $0xf01075e1
f0102f1d:	68 9c 04 00 00       	push   $0x49c
f0102f22:	68 f6 75 10 f0       	push   $0xf01075f6
f0102f27:	e8 14 d1 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0102f2c:	68 c9 77 10 f0       	push   $0xf01077c9
f0102f31:	68 e1 75 10 f0       	push   $0xf01075e1
f0102f36:	68 9d 04 00 00       	push   $0x49d
f0102f3b:	68 f6 75 10 f0       	push   $0xf01075f6
f0102f40:	e8 fb d0 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f45:	50                   	push   %eax
f0102f46:	68 24 62 10 f0       	push   $0xf0106224
f0102f4b:	6a 58                	push   $0x58
f0102f4d:	68 02 76 10 f0       	push   $0xf0107602
f0102f52:	e8 e9 d0 ff ff       	call   f0100040 <_panic>
f0102f57:	50                   	push   %eax
f0102f58:	68 24 62 10 f0       	push   $0xf0106224
f0102f5d:	6a 58                	push   $0x58
f0102f5f:	68 02 76 10 f0       	push   $0xf0107602
f0102f64:	e8 d7 d0 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102f69:	68 43 78 10 f0       	push   $0xf0107843
f0102f6e:	68 e1 75 10 f0       	push   $0xf01075e1
f0102f73:	68 a2 04 00 00       	push   $0x4a2
f0102f78:	68 f6 75 10 f0       	push   $0xf01075f6
f0102f7d:	e8 be d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0102f82:	68 e8 74 10 f0       	push   $0xf01074e8
f0102f87:	68 e1 75 10 f0       	push   $0xf01075e1
f0102f8c:	68 a3 04 00 00       	push   $0x4a3
f0102f91:	68 f6 75 10 f0       	push   $0xf01075f6
f0102f96:	e8 a5 d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0102f9b:	68 0c 75 10 f0       	push   $0xf010750c
f0102fa0:	68 e1 75 10 f0       	push   $0xf01075e1
f0102fa5:	68 a5 04 00 00       	push   $0x4a5
f0102faa:	68 f6 75 10 f0       	push   $0xf01075f6
f0102faf:	e8 8c d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f0102fb4:	68 65 78 10 f0       	push   $0xf0107865
f0102fb9:	68 e1 75 10 f0       	push   $0xf01075e1
f0102fbe:	68 a6 04 00 00       	push   $0x4a6
f0102fc3:	68 f6 75 10 f0       	push   $0xf01075f6
f0102fc8:	e8 73 d0 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f0102fcd:	68 cf 78 10 f0       	push   $0xf01078cf
f0102fd2:	68 e1 75 10 f0       	push   $0xf01075e1
f0102fd7:	68 a7 04 00 00       	push   $0x4a7
f0102fdc:	68 f6 75 10 f0       	push   $0xf01075f6
f0102fe1:	e8 5a d0 ff ff       	call   f0100040 <_panic>
f0102fe6:	50                   	push   %eax
f0102fe7:	68 24 62 10 f0       	push   $0xf0106224
f0102fec:	6a 58                	push   $0x58
f0102fee:	68 02 76 10 f0       	push   $0xf0107602
f0102ff3:	e8 48 d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0102ff8:	68 30 75 10 f0       	push   $0xf0107530
f0102ffd:	68 e1 75 10 f0       	push   $0xf01075e1
f0103002:	68 a9 04 00 00       	push   $0x4a9
f0103007:	68 f6 75 10 f0       	push   $0xf01075f6
f010300c:	e8 2f d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0103011:	68 9d 78 10 f0       	push   $0xf010789d
f0103016:	68 e1 75 10 f0       	push   $0xf01075e1
f010301b:	68 ab 04 00 00       	push   $0x4ab
f0103020:	68 f6 75 10 f0       	push   $0xf01075f6
f0103025:	e8 16 d0 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010302a:	68 8c 6c 10 f0       	push   $0xf0106c8c
f010302f:	68 e1 75 10 f0       	push   $0xf01075e1
f0103034:	68 ae 04 00 00       	push   $0x4ae
f0103039:	68 f6 75 10 f0       	push   $0xf01075f6
f010303e:	e8 fd cf ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f0103043:	68 54 78 10 f0       	push   $0xf0107854
f0103048:	68 e1 75 10 f0       	push   $0xf01075e1
f010304d:	68 b0 04 00 00       	push   $0x4b0
f0103052:	68 f6 75 10 f0       	push   $0xf01075f6
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
f01030b5:	68 88 75 10 f0       	push   $0xf0107588
f01030ba:	68 b6 02 00 00       	push   $0x2b6
f01030bf:	68 f6 75 10 f0       	push   $0xf01075f6
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
f01031a7:	68 ac 75 10 f0       	push   $0xf01075ac
f01031ac:	e8 f4 08 00 00       	call   f0103aa5 <cprintf>
        env_destroy(env);    // may not return
f01031b1:	89 1c 24             	mov    %ebx,(%esp)
f01031b4:	e8 41 06 00 00       	call   f01037fa <env_destroy>
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
f010320e:	68 70 79 10 f0       	push   $0xf0107970
f0103213:	e8 8d 08 00 00       	call   f0103aa5 <cprintf>
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
f010326a:	e8 34 29 00 00       	call   f0105ba3 <cpunum>
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
f0103294:	e8 0a 29 00 00       	call   f0105ba3 <cpunum>
f0103299:	6b c0 74             	imul   $0x74,%eax,%eax
f010329c:	39 98 28 50 23 f0    	cmp    %ebx,-0xfdcafd8(%eax)
f01032a2:	74 b8                	je     f010325c <envid2env+0x2f>
f01032a4:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01032a7:	e8 f7 28 00 00       	call   f0105ba3 <cpunum>
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
f0103335:	83 ec 04             	sub    $0x4,%esp
    if (!(e = env_free_list))
f0103338:	8b 1d 50 42 23 f0    	mov    0xf0234250,%ebx
f010333e:	85 db                	test   %ebx,%ebx
f0103340:	0f 84 36 01 00 00    	je     f010347c <env_alloc+0x14b>
    if (!(p = page_alloc(ALLOC_ZERO)))
f0103346:	83 ec 0c             	sub    $0xc,%esp
f0103349:	6a 01                	push   $0x1
f010334b:	e8 a6 dc ff ff       	call   f0100ff6 <page_alloc>
f0103350:	83 c4 10             	add    $0x10,%esp
f0103353:	85 c0                	test   %eax,%eax
f0103355:	0f 84 28 01 00 00    	je     f0103483 <env_alloc+0x152>
f010335b:	89 c2                	mov    %eax,%edx
f010335d:	2b 15 94 4e 23 f0    	sub    0xf0234e94,%edx
f0103363:	c1 fa 03             	sar    $0x3,%edx
f0103366:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0103369:	89 d1                	mov    %edx,%ecx
f010336b:	c1 e9 0c             	shr    $0xc,%ecx
f010336e:	3b 0d 8c 4e 23 f0    	cmp    0xf0234e8c,%ecx
f0103374:	0f 83 db 00 00 00    	jae    f0103455 <env_alloc+0x124>
	return (void *)(pa + KERNBASE);
f010337a:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103380:	89 53 60             	mov    %edx,0x60(%ebx)
    p->pp_ref++;
f0103383:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    memcpy(e->env_pgdir + utop_off, kern_pgdir + utop_off, sizeof(pde_t) * (NPDENTRIES - utop_off));
f0103388:	83 ec 04             	sub    $0x4,%esp
f010338b:	68 14 01 00 00       	push   $0x114
f0103390:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
f0103395:	05 ec 0e 00 00       	add    $0xeec,%eax
f010339a:	50                   	push   %eax
f010339b:	8b 43 60             	mov    0x60(%ebx),%eax
f010339e:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033a3:	50                   	push   %eax
f01033a4:	e8 8c 22 00 00       	call   f0105635 <memcpy>
    e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01033a9:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01033ac:	83 c4 10             	add    $0x10,%esp
f01033af:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01033b4:	0f 86 ad 00 00 00    	jbe    f0103467 <env_alloc+0x136>
	return (physaddr_t)kva - KERNBASE;
f01033ba:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01033c0:	83 ca 05             	or     $0x5,%edx
f01033c3:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
    generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01033c9:	8b 43 48             	mov    0x48(%ebx),%eax
f01033cc:	05 00 10 00 00       	add    $0x1000,%eax
    if (generation <= 0)    // Don't create a negative env_id.
f01033d1:	25 00 fc ff ff       	and    $0xfffffc00,%eax
        generation = 1 << ENVGENSHIFT;
f01033d6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01033db:	0f 4e c2             	cmovle %edx,%eax
    e->env_id = generation | (e - envs);
f01033de:	89 da                	mov    %ebx,%edx
f01033e0:	2b 15 4c 42 23 f0    	sub    0xf023424c,%edx
f01033e6:	c1 fa 02             	sar    $0x2,%edx
f01033e9:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01033ef:	09 d0                	or     %edx,%eax
f01033f1:	89 43 48             	mov    %eax,0x48(%ebx)
    e->env_parent_id = parent_id;
f01033f4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01033f7:	89 43 4c             	mov    %eax,0x4c(%ebx)
    e->env_type = ENV_TYPE_USER;
f01033fa:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
    e->env_status = ENV_RUNNABLE;
f0103401:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
    e->env_runs = 0;
f0103408:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    memset(&e->env_tf, 0, sizeof(e->env_tf));
f010340f:	83 ec 04             	sub    $0x4,%esp
f0103412:	6a 44                	push   $0x44
f0103414:	6a 00                	push   $0x0
f0103416:	53                   	push   %ebx
f0103417:	e8 64 21 00 00       	call   f0105580 <memset>
    e->env_tf.tf_ds = GD_UD | 3;
f010341c:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
    e->env_tf.tf_es = GD_UD | 3;
f0103422:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
    e->env_tf.tf_ss = GD_UD | 3;
f0103428:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
    e->env_tf.tf_esp = USTACKTOP;
f010342e:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
    e->env_tf.tf_cs = GD_UT | 3;
f0103435:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
    env_free_list = e->env_link;
f010343b:	8b 43 44             	mov    0x44(%ebx),%eax
f010343e:	a3 50 42 23 f0       	mov    %eax,0xf0234250
    *newenv_store = e;
f0103443:	8b 45 08             	mov    0x8(%ebp),%eax
f0103446:	89 18                	mov    %ebx,(%eax)
    return 0;
f0103448:	83 c4 10             	add    $0x10,%esp
f010344b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103453:	c9                   	leave  
f0103454:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103455:	52                   	push   %edx
f0103456:	68 24 62 10 f0       	push   $0xf0106224
f010345b:	6a 58                	push   $0x58
f010345d:	68 02 76 10 f0       	push   $0xf0107602
f0103462:	e8 d9 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103467:	50                   	push   %eax
f0103468:	68 48 62 10 f0       	push   $0xf0106248
f010346d:	68 cd 00 00 00       	push   $0xcd
f0103472:	68 cf 7b 10 f0       	push   $0xf0107bcf
f0103477:	e8 c4 cb ff ff       	call   f0100040 <_panic>
        return -E_NO_FREE_ENV;
f010347c:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103481:	eb cd                	jmp    f0103450 <env_alloc+0x11f>
        return -E_NO_MEM;
f0103483:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103488:	eb c6                	jmp    f0103450 <env_alloc+0x11f>

f010348a <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type) {
f010348a:	55                   	push   %ebp
f010348b:	89 e5                	mov    %esp,%ebp
f010348d:	57                   	push   %edi
f010348e:	56                   	push   %esi
f010348f:	53                   	push   %ebx
f0103490:	83 ec 38             	sub    $0x38,%esp
f0103493:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("************* Now we create a env. **************\n");
f0103496:	68 a4 79 10 f0       	push   $0xf01079a4
f010349b:	e8 05 06 00 00       	call   f0103aa5 <cprintf>
    // LAB 3: Your code here.
    struct Env *Env = NULL;
f01034a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    switch (env_alloc(&Env, 0)) {
f01034a7:	83 c4 08             	add    $0x8,%esp
f01034aa:	6a 00                	push   $0x0
f01034ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01034af:	50                   	push   %eax
f01034b0:	e8 7c fe ff ff       	call   f0103331 <env_alloc>
        default:
            //todo
            break;
    };

    load_icode(Env, binary);
f01034b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01034b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cprintf("************* Now we load_icode about a env e. **************\n");
f01034bb:	c7 04 24 d8 79 10 f0 	movl   $0xf01079d8,(%esp)
f01034c2:	e8 de 05 00 00       	call   f0103aa5 <cprintf>
    cprintf("************* Now we load each program segment. **************\n");
f01034c7:	c7 04 24 18 7a 10 f0 	movl   $0xf0107a18,(%esp)
f01034ce:	e8 d2 05 00 00       	call   f0103aa5 <cprintf>
    ph = (struct Proghdr *) (binary + elfHdr->e_phoff);
f01034d3:	89 f3                	mov    %esi,%ebx
f01034d5:	03 5e 1c             	add    0x1c(%esi),%ebx
    eph = ph + elfHdr->e_phnum;
f01034d8:	0f b7 7e 2c          	movzwl 0x2c(%esi),%edi
f01034dc:	c1 e7 05             	shl    $0x5,%edi
f01034df:	01 df                	add    %ebx,%edi
f01034e1:	83 c4 10             	add    $0x10,%esp
f01034e4:	eb 03                	jmp    f01034e9 <env_create+0x5f>
    for (; ph < eph; ph++) {
f01034e6:	83 c3 20             	add    $0x20,%ebx
f01034e9:	39 df                	cmp    %ebx,%edi
f01034eb:	76 3c                	jbe    f0103529 <env_create+0x9f>
        if (ph->p_type == ELF_PROG_LOAD) {
f01034ed:	83 3b 01             	cmpl   $0x1,(%ebx)
f01034f0:	75 f4                	jne    f01034e6 <env_create+0x5c>
            cprintf("ph->p_type:%x\t ph->p_offset:0x%x\t ph->p_va:0x%x\t ph->p_pa:0x%x\t ph->p_filesz:0x%x\t ph->p_memsz:0x%x\t ph->p_flags:%x\t ph->p_align:0x%x\t\n",
f01034f2:	83 ec 0c             	sub    $0xc,%esp
f01034f5:	ff 73 1c             	pushl  0x1c(%ebx)
f01034f8:	ff 73 18             	pushl  0x18(%ebx)
f01034fb:	ff 73 14             	pushl  0x14(%ebx)
f01034fe:	ff 73 10             	pushl  0x10(%ebx)
f0103501:	ff 73 0c             	pushl  0xc(%ebx)
f0103504:	ff 73 08             	pushl  0x8(%ebx)
f0103507:	ff 73 04             	pushl  0x4(%ebx)
f010350a:	6a 01                	push   $0x1
f010350c:	68 58 7a 10 f0       	push   $0xf0107a58
f0103511:	e8 8f 05 00 00       	call   f0103aa5 <cprintf>
            region_alloc(e, (void *) ph->p_va, ph->p_memsz);
f0103516:	83 c4 30             	add    $0x30,%esp
f0103519:	8b 4b 14             	mov    0x14(%ebx),%ecx
f010351c:	8b 53 08             	mov    0x8(%ebx),%edx
f010351f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103522:	e8 97 fc ff ff       	call   f01031be <region_alloc>
f0103527:	eb bd                	jmp    f01034e6 <env_create+0x5c>
    cprintf("************* Now we copy each section which should load. **************\n");
f0103529:	83 ec 0c             	sub    $0xc,%esp
f010352c:	68 e0 7a 10 f0       	push   $0xf0107ae0
f0103531:	e8 6f 05 00 00       	call   f0103aa5 <cprintf>
    struct Secthdr *sectHdr = (struct Secthdr *) (binary + elfHdr->e_shoff);
f0103536:	89 f3                	mov    %esi,%ebx
f0103538:	03 5e 20             	add    0x20(%esi),%ebx
	asm volatile("movl %%cr3,%0" : "=r" (val));
f010353b:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f010353e:	83 c4 08             	add    $0x8,%esp
f0103541:	50                   	push   %eax
f0103542:	68 da 7b 10 f0       	push   $0xf0107bda
f0103547:	e8 59 05 00 00       	call   f0103aa5 <cprintf>
    lcr3(PADDR(e->env_pgdir));
f010354c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010354f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103552:	83 c4 10             	add    $0x10,%esp
f0103555:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010355a:	76 23                	jbe    f010357f <env_create+0xf5>
	return (physaddr_t)kva - KERNBASE;
f010355c:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103561:	0f 22 d8             	mov    %eax,%cr3
	asm volatile("movl %%cr3,%0" : "=r" (val));
f0103564:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f0103567:	83 ec 08             	sub    $0x8,%esp
f010356a:	50                   	push   %eax
f010356b:	68 da 7b 10 f0       	push   $0xf0107bda
f0103570:	e8 30 05 00 00       	call   f0103aa5 <cprintf>
f0103575:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f0103578:	bf 00 00 00 00       	mov    $0x0,%edi
f010357d:	eb 43                	jmp    f01035c2 <env_create+0x138>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010357f:	50                   	push   %eax
f0103580:	68 48 62 10 f0       	push   $0xf0106248
f0103585:	68 8b 01 00 00       	push   $0x18b
f010358a:	68 cf 7b 10 f0       	push   $0xf0107bcf
f010358f:	e8 ac ca ff ff       	call   f0100040 <_panic>
            cprintf("(void *) sectHdr->sh_addr:0x%x\tsectHdr->sh_offset:0x%x\tsectHdr->sh_size:0x%x\n", sectHdr->sh_addr, sectHdr->sh_offset, sectHdr->sh_size);
f0103594:	ff 73 14             	pushl  0x14(%ebx)
f0103597:	ff 73 10             	pushl  0x10(%ebx)
f010359a:	50                   	push   %eax
f010359b:	68 2c 7b 10 f0       	push   $0xf0107b2c
f01035a0:	e8 00 05 00 00       	call   f0103aa5 <cprintf>
            memcpy((void *) sectHdr->sh_addr, binary + sectHdr->sh_offset, sectHdr->sh_size);
f01035a5:	83 c4 0c             	add    $0xc,%esp
f01035a8:	ff 73 14             	pushl  0x14(%ebx)
f01035ab:	89 f0                	mov    %esi,%eax
f01035ad:	03 43 10             	add    0x10(%ebx),%eax
f01035b0:	50                   	push   %eax
f01035b1:	ff 73 0c             	pushl  0xc(%ebx)
f01035b4:	e8 7c 20 00 00       	call   f0105635 <memcpy>
f01035b9:	83 c4 10             	add    $0x10,%esp
        sectHdr++;
f01035bc:	83 c3 28             	add    $0x28,%ebx
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f01035bf:	83 c7 01             	add    $0x1,%edi
f01035c2:	0f b7 46 30          	movzwl 0x30(%esi),%eax
f01035c6:	39 c7                	cmp    %eax,%edi
f01035c8:	7d 0f                	jge    f01035d9 <env_create+0x14f>
        if (sectHdr->sh_addr != 0 && sectHdr->sh_type != ELF_SHT_NOBITS) {
f01035ca:	8b 43 0c             	mov    0xc(%ebx),%eax
f01035cd:	85 c0                	test   %eax,%eax
f01035cf:	74 eb                	je     f01035bc <env_create+0x132>
f01035d1:	83 7b 04 08          	cmpl   $0x8,0x4(%ebx)
f01035d5:	74 e5                	je     f01035bc <env_create+0x132>
f01035d7:	eb bb                	jmp    f0103594 <env_create+0x10a>
    lcr3(PADDR(kern_pgdir));
f01035d9:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f01035de:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035e3:	76 43                	jbe    f0103628 <env_create+0x19e>
	return (physaddr_t)kva - KERNBASE;
f01035e5:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01035ea:	0f 22 d8             	mov    %eax,%cr3
    cprintf("************* Now we map one page for the program's initial stack. **************\n");
f01035ed:	83 ec 0c             	sub    $0xc,%esp
f01035f0:	68 7c 7b 10 f0       	push   $0xf0107b7c
f01035f5:	e8 ab 04 00 00       	call   f0103aa5 <cprintf>
    region_alloc(e, (void *) USTACKTOP - PGSIZE, PGSIZE);
f01035fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01035ff:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103604:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103607:	89 f8                	mov    %edi,%eax
f0103609:	e8 b0 fb ff ff       	call   f01031be <region_alloc>
    e->env_tf.tf_eip = elfHdr->e_entry;
f010360e:	8b 46 18             	mov    0x18(%esi),%eax
f0103611:	89 47 30             	mov    %eax,0x30(%edi)

    Env->env_type = type;
f0103614:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010361a:	89 50 50             	mov    %edx,0x50(%eax)
}
f010361d:	83 c4 10             	add    $0x10,%esp
f0103620:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103623:	5b                   	pop    %ebx
f0103624:	5e                   	pop    %esi
f0103625:	5f                   	pop    %edi
f0103626:	5d                   	pop    %ebp
f0103627:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103628:	50                   	push   %eax
f0103629:	68 48 62 10 f0       	push   $0xf0106248
f010362e:	68 95 01 00 00       	push   $0x195
f0103633:	68 cf 7b 10 f0       	push   $0xf0107bcf
f0103638:	e8 03 ca ff ff       	call   f0100040 <_panic>

f010363d <env_free>:

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
f010363d:	55                   	push   %ebp
f010363e:	89 e5                	mov    %esp,%ebp
f0103640:	57                   	push   %edi
f0103641:	56                   	push   %esi
f0103642:	53                   	push   %ebx
f0103643:	83 ec 1c             	sub    $0x1c,%esp
    physaddr_t pa;

    // If freeing the current environment, switch to kern_pgdir
    // before freeing the page directory, just in case the page
    // gets reused.
    if (e == curenv)
f0103646:	e8 58 25 00 00       	call   f0105ba3 <cpunum>
f010364b:	6b c0 74             	imul   $0x74,%eax,%eax
f010364e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0103655:	8b 55 08             	mov    0x8(%ebp),%edx
f0103658:	8b 7d 08             	mov    0x8(%ebp),%edi
f010365b:	39 90 28 50 23 f0    	cmp    %edx,-0xfdcafd8(%eax)
f0103661:	0f 85 b2 00 00 00    	jne    f0103719 <env_free+0xdc>
        lcr3(PADDR(kern_pgdir));
f0103667:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f010366c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103671:	76 17                	jbe    f010368a <env_free+0x4d>
	return (physaddr_t)kva - KERNBASE;
f0103673:	05 00 00 00 10       	add    $0x10000000,%eax
f0103678:	0f 22 d8             	mov    %eax,%cr3
f010367b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0103682:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103685:	e9 8f 00 00 00       	jmp    f0103719 <env_free+0xdc>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010368a:	50                   	push   %eax
f010368b:	68 48 62 10 f0       	push   $0xf0106248
f0103690:	68 cd 01 00 00       	push   $0x1cd
f0103695:	68 cf 7b 10 f0       	push   $0xf0107bcf
f010369a:	e8 a1 c9 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010369f:	50                   	push   %eax
f01036a0:	68 24 62 10 f0       	push   $0xf0106224
f01036a5:	68 dc 01 00 00       	push   $0x1dc
f01036aa:	68 cf 7b 10 f0       	push   $0xf0107bcf
f01036af:	e8 8c c9 ff ff       	call   f0100040 <_panic>
f01036b4:	83 c3 04             	add    $0x4,%ebx
        // find the pa and va of the page table
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
        pt = (pte_t *) KADDR(pa);

        // unmap all PTEs in this page table
        for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01036b7:	39 de                	cmp    %ebx,%esi
f01036b9:	74 21                	je     f01036dc <env_free+0x9f>
            if (pt[pteno] & PTE_P)
f01036bb:	f6 03 01             	testb  $0x1,(%ebx)
f01036be:	74 f4                	je     f01036b4 <env_free+0x77>
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01036c0:	83 ec 08             	sub    $0x8,%esp
f01036c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01036c6:	01 d8                	add    %ebx,%eax
f01036c8:	c1 e0 0a             	shl    $0xa,%eax
f01036cb:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01036ce:	50                   	push   %eax
f01036cf:	ff 77 60             	pushl  0x60(%edi)
f01036d2:	e8 51 db ff ff       	call   f0101228 <page_remove>
f01036d7:	83 c4 10             	add    $0x10,%esp
f01036da:	eb d8                	jmp    f01036b4 <env_free+0x77>
        }

        // free the page table itself
        e->env_pgdir[pdeno] = 0;
f01036dc:	8b 47 60             	mov    0x60(%edi),%eax
f01036df:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01036e2:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01036e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01036ec:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f01036f2:	73 6a                	jae    f010375e <env_free+0x121>
        page_decref(pa2page(pa));
f01036f4:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01036f7:	a1 94 4e 23 f0       	mov    0xf0234e94,%eax
f01036fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01036ff:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103702:	50                   	push   %eax
f0103703:	e8 bc d9 ff ff       	call   f01010c4 <page_decref>
f0103708:	83 c4 10             	add    $0x10,%esp
f010370b:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f010370f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103712:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103717:	74 59                	je     f0103772 <env_free+0x135>
        if (!(e->env_pgdir[pdeno] & PTE_P))
f0103719:	8b 47 60             	mov    0x60(%edi),%eax
f010371c:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010371f:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103722:	a8 01                	test   $0x1,%al
f0103724:	74 e5                	je     f010370b <env_free+0xce>
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103726:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010372b:	89 c2                	mov    %eax,%edx
f010372d:	c1 ea 0c             	shr    $0xc,%edx
f0103730:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0103733:	39 15 8c 4e 23 f0    	cmp    %edx,0xf0234e8c
f0103739:	0f 86 60 ff ff ff    	jbe    f010369f <env_free+0x62>
	return (void *)(pa + KERNBASE);
f010373f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103745:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103748:	c1 e2 14             	shl    $0x14,%edx
f010374b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010374e:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f0103754:	f7 d8                	neg    %eax
f0103756:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103759:	e9 5d ff ff ff       	jmp    f01036bb <env_free+0x7e>
		panic("pa2page called with invalid pa");
f010375e:	83 ec 04             	sub    $0x4,%esp
f0103761:	68 b0 69 10 f0       	push   $0xf01069b0
f0103766:	6a 51                	push   $0x51
f0103768:	68 02 76 10 f0       	push   $0xf0107602
f010376d:	e8 ce c8 ff ff       	call   f0100040 <_panic>
    }

    // free the page directory
    pa = PADDR(e->env_pgdir);
f0103772:	8b 45 08             	mov    0x8(%ebp),%eax
f0103775:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103778:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010377d:	76 52                	jbe    f01037d1 <env_free+0x194>
    e->env_pgdir = 0;
f010377f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103782:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f0103789:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f010378e:	c1 e8 0c             	shr    $0xc,%eax
f0103791:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f0103797:	73 4d                	jae    f01037e6 <env_free+0x1a9>
    page_decref(pa2page(pa));
f0103799:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010379c:	8b 15 94 4e 23 f0    	mov    0xf0234e94,%edx
f01037a2:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01037a5:	50                   	push   %eax
f01037a6:	e8 19 d9 ff ff       	call   f01010c4 <page_decref>

    // return the environment to the free list
    e->env_status = ENV_FREE;
f01037ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01037ae:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
    e->env_link = env_free_list;
f01037b5:	a1 50 42 23 f0       	mov    0xf0234250,%eax
f01037ba:	8b 55 08             	mov    0x8(%ebp),%edx
f01037bd:	89 42 44             	mov    %eax,0x44(%edx)
    env_free_list = e;
f01037c0:	89 15 50 42 23 f0    	mov    %edx,0xf0234250
}
f01037c6:	83 c4 10             	add    $0x10,%esp
f01037c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01037cc:	5b                   	pop    %ebx
f01037cd:	5e                   	pop    %esi
f01037ce:	5f                   	pop    %edi
f01037cf:	5d                   	pop    %ebp
f01037d0:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037d1:	50                   	push   %eax
f01037d2:	68 48 62 10 f0       	push   $0xf0106248
f01037d7:	68 ea 01 00 00       	push   $0x1ea
f01037dc:	68 cf 7b 10 f0       	push   $0xf0107bcf
f01037e1:	e8 5a c8 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f01037e6:	83 ec 04             	sub    $0x4,%esp
f01037e9:	68 b0 69 10 f0       	push   $0xf01069b0
f01037ee:	6a 51                	push   $0x51
f01037f0:	68 02 76 10 f0       	push   $0xf0107602
f01037f5:	e8 46 c8 ff ff       	call   f0100040 <_panic>

f01037fa <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f01037fa:	55                   	push   %ebp
f01037fb:	89 e5                	mov    %esp,%ebp
f01037fd:	53                   	push   %ebx
f01037fe:	83 ec 04             	sub    $0x4,%esp
f0103801:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // If e is currently running on other CPUs, we change its state to
    // ENV_DYING. A zombie environment will be freed the next time
    // it traps to the kernel.
    if (e->env_status == ENV_RUNNING && curenv != e) {
f0103804:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103808:	74 21                	je     f010382b <env_destroy+0x31>
        e->env_status = ENV_DYING;
        return;
    }

    env_free(e);
f010380a:	83 ec 0c             	sub    $0xc,%esp
f010380d:	53                   	push   %ebx
f010380e:	e8 2a fe ff ff       	call   f010363d <env_free>

    if (curenv == e) {
f0103813:	e8 8b 23 00 00       	call   f0105ba3 <cpunum>
f0103818:	6b c0 74             	imul   $0x74,%eax,%eax
f010381b:	83 c4 10             	add    $0x10,%esp
f010381e:	39 98 28 50 23 f0    	cmp    %ebx,-0xfdcafd8(%eax)
f0103824:	74 1e                	je     f0103844 <env_destroy+0x4a>
        curenv = NULL;
        sched_yield();
    }
}
f0103826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103829:	c9                   	leave  
f010382a:	c3                   	ret    
    if (e->env_status == ENV_RUNNING && curenv != e) {
f010382b:	e8 73 23 00 00       	call   f0105ba3 <cpunum>
f0103830:	6b c0 74             	imul   $0x74,%eax,%eax
f0103833:	39 98 28 50 23 f0    	cmp    %ebx,-0xfdcafd8(%eax)
f0103839:	74 cf                	je     f010380a <env_destroy+0x10>
        e->env_status = ENV_DYING;
f010383b:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
        return;
f0103842:	eb e2                	jmp    f0103826 <env_destroy+0x2c>
        curenv = NULL;
f0103844:	e8 5a 23 00 00       	call   f0105ba3 <cpunum>
f0103849:	6b c0 74             	imul   $0x74,%eax,%eax
f010384c:	c7 80 28 50 23 f0 00 	movl   $0x0,-0xfdcafd8(%eax)
f0103853:	00 00 00 
        sched_yield();
f0103856:	e8 3a 0c 00 00       	call   f0104495 <sched_yield>

f010385b <env_pop_tf>:
// this exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
f010385b:	55                   	push   %ebp
f010385c:	89 e5                	mov    %esp,%ebp
f010385e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile(
f0103861:	8b 65 08             	mov    0x8(%ebp),%esp
f0103864:	61                   	popa   
f0103865:	07                   	pop    %es
f0103866:	1f                   	pop    %ds
f0103867:	83 c4 08             	add    $0x8,%esp
f010386a:	cf                   	iret   
    "\tpopl %%es\n"
    "\tpopl %%ds\n"
    "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
    "\tiret\n"
    : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
f010386b:	68 e7 7b 10 f0       	push   $0xf0107be7
f0103870:	68 1e 02 00 00       	push   $0x21e
f0103875:	68 cf 7b 10 f0       	push   $0xf0107bcf
f010387a:	e8 c1 c7 ff ff       	call   f0100040 <_panic>

f010387f <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
f010387f:	55                   	push   %ebp
f0103880:	89 e5                	mov    %esp,%ebp
f0103882:	53                   	push   %ebx
f0103883:	83 ec 04             	sub    $0x4,%esp
f0103886:	8b 5d 08             	mov    0x8(%ebp),%ebx
    //	e->env_tf.  Go back through the code you wrote above
    //	and make sure you have set the relevant parts of
    //	e->env_tf to sensible values.

    // LAB 3: Your code here.
    if (curenv != NULL) {
f0103889:	e8 15 23 00 00       	call   f0105ba3 <cpunum>
f010388e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103891:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0103898:	74 14                	je     f01038ae <env_run+0x2f>
        if (curenv->env_status == ENV_RUNNING) {
f010389a:	e8 04 23 00 00       	call   f0105ba3 <cpunum>
f010389f:	6b c0 74             	imul   $0x74,%eax,%eax
f01038a2:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01038a8:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01038ac:	74 38                	je     f01038e6 <env_run+0x67>
            curenv->env_status = ENV_RUNNABLE;
        }
    }

    curenv = e;
f01038ae:	e8 f0 22 00 00       	call   f0105ba3 <cpunum>
f01038b3:	6b c0 74             	imul   $0x74,%eax,%eax
f01038b6:	89 98 28 50 23 f0    	mov    %ebx,-0xfdcafd8(%eax)
    //?????????????????????????????????why this fault?
//    e->env_status = ENV_RUNNABLE;
    e->env_status = ENV_RUNNING;
f01038bc:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)

    //if curenv == env ??
    e->env_runs++;
f01038c3:	83 43 58 01          	addl   $0x1,0x58(%ebx)

    lcr3(PADDR(e->env_pgdir));
f01038c7:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01038ca:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01038cf:	77 2c                	ja     f01038fd <env_run+0x7e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038d1:	50                   	push   %eax
f01038d2:	68 48 62 10 f0       	push   $0xf0106248
f01038d7:	68 4a 02 00 00       	push   $0x24a
f01038dc:	68 cf 7b 10 f0       	push   $0xf0107bcf
f01038e1:	e8 5a c7 ff ff       	call   f0100040 <_panic>
            curenv->env_status = ENV_RUNNABLE;
f01038e6:	e8 b8 22 00 00       	call   f0105ba3 <cpunum>
f01038eb:	6b c0 74             	imul   $0x74,%eax,%eax
f01038ee:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01038f4:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01038fb:	eb b1                	jmp    f01038ae <env_run+0x2f>
	return (physaddr_t)kva - KERNBASE;
f01038fd:	05 00 00 00 10       	add    $0x10000000,%eax
f0103902:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103905:	83 ec 0c             	sub    $0xc,%esp
f0103908:	68 c0 23 12 f0       	push   $0xf01223c0
f010390d:	e8 b0 25 00 00       	call   f0105ec2 <spin_unlock>
    asm volatile("pause");
f0103912:	f3 90                	pause  

//    cprintf("e->env_tf.tf_cs:0x%x\n", e->env_tf.tf_cs);

    unlock_kernel();
    env_pop_tf(&e->env_tf);
f0103914:	89 1c 24             	mov    %ebx,(%esp)
f0103917:	e8 3f ff ff ff       	call   f010385b <env_pop_tf>

f010391c <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010391c:	55                   	push   %ebp
f010391d:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010391f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103922:	ba 70 00 00 00       	mov    $0x70,%edx
f0103927:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103928:	ba 71 00 00 00       	mov    $0x71,%edx
f010392d:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010392e:	0f b6 c0             	movzbl %al,%eax
}
f0103931:	5d                   	pop    %ebp
f0103932:	c3                   	ret    

f0103933 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103933:	55                   	push   %ebp
f0103934:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103936:	8b 45 08             	mov    0x8(%ebp),%eax
f0103939:	ba 70 00 00 00       	mov    $0x70,%edx
f010393e:	ee                   	out    %al,(%dx)
f010393f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103942:	ba 71 00 00 00       	mov    $0x71,%edx
f0103947:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103948:	5d                   	pop    %ebp
f0103949:	c3                   	ret    

f010394a <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010394a:	55                   	push   %ebp
f010394b:	89 e5                	mov    %esp,%ebp
f010394d:	56                   	push   %esi
f010394e:	53                   	push   %ebx
f010394f:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103952:	66 a3 a8 23 12 f0    	mov    %ax,0xf01223a8
	if (!didinit)
f0103958:	80 3d 54 42 23 f0 00 	cmpb   $0x0,0xf0234254
f010395f:	75 07                	jne    f0103968 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103961:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103964:	5b                   	pop    %ebx
f0103965:	5e                   	pop    %esi
f0103966:	5d                   	pop    %ebp
f0103967:	c3                   	ret    
f0103968:	89 c6                	mov    %eax,%esi
f010396a:	ba 21 00 00 00       	mov    $0x21,%edx
f010396f:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103970:	66 c1 e8 08          	shr    $0x8,%ax
f0103974:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103979:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f010397a:	83 ec 0c             	sub    $0xc,%esp
f010397d:	68 f3 7b 10 f0       	push   $0xf0107bf3
f0103982:	e8 1e 01 00 00       	call   f0103aa5 <cprintf>
f0103987:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f010398a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010398f:	0f b7 f6             	movzwl %si,%esi
f0103992:	f7 d6                	not    %esi
f0103994:	eb 08                	jmp    f010399e <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f0103996:	83 c3 01             	add    $0x1,%ebx
f0103999:	83 fb 10             	cmp    $0x10,%ebx
f010399c:	74 18                	je     f01039b6 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f010399e:	0f a3 de             	bt     %ebx,%esi
f01039a1:	73 f3                	jae    f0103996 <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f01039a3:	83 ec 08             	sub    $0x8,%esp
f01039a6:	53                   	push   %ebx
f01039a7:	68 fe 85 10 f0       	push   $0xf01085fe
f01039ac:	e8 f4 00 00 00       	call   f0103aa5 <cprintf>
f01039b1:	83 c4 10             	add    $0x10,%esp
f01039b4:	eb e0                	jmp    f0103996 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f01039b6:	83 ec 0c             	sub    $0xc,%esp
f01039b9:	68 26 79 10 f0       	push   $0xf0107926
f01039be:	e8 e2 00 00 00       	call   f0103aa5 <cprintf>
f01039c3:	83 c4 10             	add    $0x10,%esp
f01039c6:	eb 99                	jmp    f0103961 <irq_setmask_8259A+0x17>

f01039c8 <pic_init>:
{
f01039c8:	55                   	push   %ebp
f01039c9:	89 e5                	mov    %esp,%ebp
f01039cb:	57                   	push   %edi
f01039cc:	56                   	push   %esi
f01039cd:	53                   	push   %ebx
f01039ce:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f01039d1:	c6 05 54 42 23 f0 01 	movb   $0x1,0xf0234254
f01039d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01039dd:	bb 21 00 00 00       	mov    $0x21,%ebx
f01039e2:	89 da                	mov    %ebx,%edx
f01039e4:	ee                   	out    %al,(%dx)
f01039e5:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f01039ea:	89 ca                	mov    %ecx,%edx
f01039ec:	ee                   	out    %al,(%dx)
f01039ed:	bf 11 00 00 00       	mov    $0x11,%edi
f01039f2:	be 20 00 00 00       	mov    $0x20,%esi
f01039f7:	89 f8                	mov    %edi,%eax
f01039f9:	89 f2                	mov    %esi,%edx
f01039fb:	ee                   	out    %al,(%dx)
f01039fc:	b8 20 00 00 00       	mov    $0x20,%eax
f0103a01:	89 da                	mov    %ebx,%edx
f0103a03:	ee                   	out    %al,(%dx)
f0103a04:	b8 04 00 00 00       	mov    $0x4,%eax
f0103a09:	ee                   	out    %al,(%dx)
f0103a0a:	b8 03 00 00 00       	mov    $0x3,%eax
f0103a0f:	ee                   	out    %al,(%dx)
f0103a10:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103a15:	89 f8                	mov    %edi,%eax
f0103a17:	89 da                	mov    %ebx,%edx
f0103a19:	ee                   	out    %al,(%dx)
f0103a1a:	b8 28 00 00 00       	mov    $0x28,%eax
f0103a1f:	89 ca                	mov    %ecx,%edx
f0103a21:	ee                   	out    %al,(%dx)
f0103a22:	b8 02 00 00 00       	mov    $0x2,%eax
f0103a27:	ee                   	out    %al,(%dx)
f0103a28:	b8 01 00 00 00       	mov    $0x1,%eax
f0103a2d:	ee                   	out    %al,(%dx)
f0103a2e:	bf 68 00 00 00       	mov    $0x68,%edi
f0103a33:	89 f8                	mov    %edi,%eax
f0103a35:	89 f2                	mov    %esi,%edx
f0103a37:	ee                   	out    %al,(%dx)
f0103a38:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103a3d:	89 c8                	mov    %ecx,%eax
f0103a3f:	ee                   	out    %al,(%dx)
f0103a40:	89 f8                	mov    %edi,%eax
f0103a42:	89 da                	mov    %ebx,%edx
f0103a44:	ee                   	out    %al,(%dx)
f0103a45:	89 c8                	mov    %ecx,%eax
f0103a47:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103a48:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f0103a4f:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103a53:	74 0f                	je     f0103a64 <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f0103a55:	83 ec 0c             	sub    $0xc,%esp
f0103a58:	0f b7 c0             	movzwl %ax,%eax
f0103a5b:	50                   	push   %eax
f0103a5c:	e8 e9 fe ff ff       	call   f010394a <irq_setmask_8259A>
f0103a61:	83 c4 10             	add    $0x10,%esp
}
f0103a64:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a67:	5b                   	pop    %ebx
f0103a68:	5e                   	pop    %esi
f0103a69:	5f                   	pop    %edi
f0103a6a:	5d                   	pop    %ebp
f0103a6b:	c3                   	ret    

f0103a6c <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103a6c:	55                   	push   %ebp
f0103a6d:	89 e5                	mov    %esp,%ebp
f0103a6f:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103a72:	ff 75 08             	pushl  0x8(%ebp)
f0103a75:	e8 f3 cc ff ff       	call   f010076d <cputchar>
    //这里会有bug！
	*cnt++;
}
f0103a7a:	83 c4 10             	add    $0x10,%esp
f0103a7d:	c9                   	leave  
f0103a7e:	c3                   	ret    

f0103a7f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103a7f:	55                   	push   %ebp
f0103a80:	89 e5                	mov    %esp,%ebp
f0103a82:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103a8c:	ff 75 0c             	pushl  0xc(%ebp)
f0103a8f:	ff 75 08             	pushl  0x8(%ebp)
f0103a92:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103a95:	50                   	push   %eax
f0103a96:	68 6c 3a 10 f0       	push   $0xf0103a6c
f0103a9b:	e8 5c 13 00 00       	call   f0104dfc <vprintfmt>
	return cnt;
}
f0103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103aa3:	c9                   	leave  
f0103aa4:	c3                   	ret    

f0103aa5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103aa5:	55                   	push   %ebp
f0103aa6:	89 e5                	mov    %esp,%ebp
f0103aa8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103aab:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103aae:	50                   	push   %eax
f0103aaf:	ff 75 08             	pushl  0x8(%ebp)
f0103ab2:	e8 c8 ff ff ff       	call   f0103a7f <vcprintf>
	va_end(ap);

	return cnt;
}
f0103ab7:	c9                   	leave  
f0103ab8:	c3                   	ret    

f0103ab9 <memCprintf>:

//不能重载？？
int memCprintf(const char *name, uintptr_t va, uint32_t pd_item, physaddr_t pa, uint32_t map_page){
f0103ab9:	55                   	push   %ebp
f0103aba:	89 e5                	mov    %esp,%ebp
f0103abc:	83 ec 10             	sub    $0x10,%esp
    return cprintf("名称:%s\t虚拟地址:0x%x\t页目录项:0x%x\t物理地址:0x%x\t物理页:0x%x\n", name, va, pd_item, pa, map_page);
f0103abf:	ff 75 18             	pushl  0x18(%ebp)
f0103ac2:	ff 75 14             	pushl  0x14(%ebp)
f0103ac5:	ff 75 10             	pushl  0x10(%ebp)
f0103ac8:	ff 75 0c             	pushl  0xc(%ebp)
f0103acb:	ff 75 08             	pushl  0x8(%ebp)
f0103ace:	68 08 7c 10 f0       	push   $0xf0107c08
f0103ad3:	e8 cd ff ff ff       	call   f0103aa5 <cprintf>
}
f0103ad8:	c9                   	leave  
f0103ad9:	c3                   	ret    

f0103ada <trap_init_percpu>:
    trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void) {
f0103ada:	55                   	push   %ebp
f0103adb:	89 e5                	mov    %esp,%ebp
f0103add:	57                   	push   %edi
f0103ade:	56                   	push   %esi
f0103adf:	53                   	push   %ebx
f0103ae0:	83 ec 1c             	sub    $0x1c,%esp
    //
    // LAB 4: Your code here:

    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - (KSTKSIZE + KSTKGAP) * cpunum();
f0103ae3:	e8 bb 20 00 00       	call   f0105ba3 <cpunum>
f0103ae8:	89 c3                	mov    %eax,%ebx
f0103aea:	e8 b4 20 00 00       	call   f0105ba3 <cpunum>
f0103aef:	6b d0 74             	imul   $0x74,%eax,%edx
f0103af2:	c1 e3 10             	shl    $0x10,%ebx
f0103af5:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f0103afa:	29 d8                	sub    %ebx,%eax
f0103afc:	89 82 30 50 23 f0    	mov    %eax,-0xfdcafd0(%edx)
    thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103b02:	e8 9c 20 00 00       	call   f0105ba3 <cpunum>
f0103b07:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b0a:	66 c7 80 34 50 23 f0 	movw   $0x10,-0xfdcafcc(%eax)
f0103b11:	10 00 
    thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103b13:	e8 8b 20 00 00       	call   f0105ba3 <cpunum>
f0103b18:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b1b:	66 c7 80 92 50 23 f0 	movw   $0x68,-0xfdcaf6e(%eax)
f0103b22:	68 00 

    // Initialize the TSS slot of the gdt.
    gdt[(GD_TSS0 >> 3) + cpunum()] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103b24:	e8 7a 20 00 00       	call   f0105ba3 <cpunum>
f0103b29:	8d 58 05             	lea    0x5(%eax),%ebx
f0103b2c:	e8 72 20 00 00       	call   f0105ba3 <cpunum>
f0103b31:	89 c7                	mov    %eax,%edi
f0103b33:	e8 6b 20 00 00       	call   f0105ba3 <cpunum>
f0103b38:	89 c6                	mov    %eax,%esi
f0103b3a:	e8 64 20 00 00       	call   f0105ba3 <cpunum>
f0103b3f:	66 c7 04 dd 40 23 12 	movw   $0x67,-0xfeddcc0(,%ebx,8)
f0103b46:	f0 67 00 
f0103b49:	6b ff 74             	imul   $0x74,%edi,%edi
f0103b4c:	81 c7 2c 50 23 f0    	add    $0xf023502c,%edi
f0103b52:	66 89 3c dd 42 23 12 	mov    %di,-0xfeddcbe(,%ebx,8)
f0103b59:	f0 
f0103b5a:	6b d6 74             	imul   $0x74,%esi,%edx
f0103b5d:	81 c2 2c 50 23 f0    	add    $0xf023502c,%edx
f0103b63:	c1 ea 10             	shr    $0x10,%edx
f0103b66:	88 14 dd 44 23 12 f0 	mov    %dl,-0xfeddcbc(,%ebx,8)
f0103b6d:	c6 04 dd 45 23 12 f0 	movb   $0x99,-0xfeddcbb(,%ebx,8)
f0103b74:	99 
f0103b75:	c6 04 dd 46 23 12 f0 	movb   $0x40,-0xfeddcba(,%ebx,8)
f0103b7c:	40 
f0103b7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b80:	05 2c 50 23 f0       	add    $0xf023502c,%eax
f0103b85:	c1 e8 18             	shr    $0x18,%eax
f0103b88:	88 04 dd 47 23 12 f0 	mov    %al,-0xfeddcb9(,%ebx,8)
//    } else {
//        gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 1;
//        cprintf("application cpu%d\n", cpunum());
//    }

    gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 0;
f0103b8f:	e8 0f 20 00 00       	call   f0105ba3 <cpunum>
f0103b94:	80 24 c5 6d 23 12 f0 	andb   $0xef,-0xfeddc93(,%eax,8)
f0103b9b:	ef 

    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
            thiscpu->cpu_ts.ts_ss0, GD_TSS0 + (cpunum() << 3));
f0103b9c:	e8 02 20 00 00       	call   f0105ba3 <cpunum>
f0103ba1:	89 c7                	mov    %eax,%edi
f0103ba3:	e8 fb 1f 00 00       	call   f0105ba3 <cpunum>
f0103ba8:	6b c0 74             	imul   $0x74,%eax,%eax
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103bab:	0f b7 b0 34 50 23 f0 	movzwl -0xfdcafcc(%eax),%esi
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
f0103bb2:	e8 ec 1f 00 00       	call   f0105ba3 <cpunum>
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103bb7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bba:	8b 98 30 50 23 f0    	mov    -0xfdcafd0(%eax),%ebx
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
f0103bc0:	e8 de 1f 00 00       	call   f0105ba3 <cpunum>
f0103bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103bc8:	e8 d6 1f 00 00       	call   f0105ba3 <cpunum>
f0103bcd:	83 ec 08             	sub    $0x8,%esp
f0103bd0:	8d 14 fd 28 00 00 00 	lea    0x28(,%edi,8),%edx
f0103bd7:	52                   	push   %edx
f0103bd8:	56                   	push   %esi
f0103bd9:	53                   	push   %ebx
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
f0103bda:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103bde:	81 c2 2c 50 23 f0    	add    $0xf023502c,%edx
    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
f0103be4:	52                   	push   %edx
f0103be5:	50                   	push   %eax
f0103be6:	68 58 7c 10 f0       	push   $0xf0107c58
f0103beb:	e8 b5 fe ff ff       	call   f0103aa5 <cprintf>

    // Load the TSS selector (like other segment selectors, the
    // bottom three bits are special; we leave them 0)

    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_31_24 << 24) +
f0103bf0:	83 c4 20             	add    $0x20,%esp
f0103bf3:	e8 ab 1f 00 00       	call   f0105ba3 <cpunum>
f0103bf8:	0f b6 1c c5 6f 23 12 	movzbl -0xfeddc91(,%eax,8),%ebx
f0103bff:	f0 
f0103c00:	89 de                	mov    %ebx,%esi
f0103c02:	c1 e6 18             	shl    $0x18,%esi
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
f0103c05:	e8 99 1f 00 00       	call   f0105ba3 <cpunum>
f0103c0a:	0f b6 1c c5 6c 23 12 	movzbl -0xfeddc94(,%eax,8),%ebx
f0103c11:	f0 
f0103c12:	c1 e3 10             	shl    $0x10,%ebx
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_31_24 << 24) +
f0103c15:	01 f3                	add    %esi,%ebx
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
f0103c17:	e8 87 1f 00 00       	call   f0105ba3 <cpunum>
    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
f0103c1c:	83 ec 04             	sub    $0x4,%esp
f0103c1f:	6a 74                	push   $0x74
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
f0103c21:	0f b7 04 c5 6a 23 12 	movzwl -0xfeddc96(,%eax,8),%eax
f0103c28:	f0 
    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
f0103c29:	01 c3                	add    %eax,%ebx
f0103c2b:	53                   	push   %ebx
f0103c2c:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0103c31:	e8 6f fe ff ff       	call   f0103aa5 <cprintf>
            sizeof(struct CpuInfo));
    //question what?
    ltr((GD_TSS0 + (cpunum() << 3)));
f0103c36:	e8 68 1f 00 00       	call   f0105ba3 <cpunum>
f0103c3b:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
	asm volatile("ltr %0" : : "r" (sel));
f0103c42:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103c45:	b8 ac 23 12 f0       	mov    $0xf01223ac,%eax
f0103c4a:	0f 01 18             	lidtl  (%eax)

    // Load the IDT
    lidt(&idt_pd);
}
f0103c4d:	83 c4 10             	add    $0x10,%esp
f0103c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103c53:	5b                   	pop    %ebx
f0103c54:	5e                   	pop    %esi
f0103c55:	5f                   	pop    %edi
f0103c56:	5d                   	pop    %ebp
f0103c57:	c3                   	ret    

f0103c58 <trap_init>:
trap_init(void) {
f0103c58:	55                   	push   %ebp
f0103c59:	89 e5                	mov    %esp,%ebp
f0103c5b:	57                   	push   %edi
f0103c5c:	56                   	push   %esi
f0103c5d:	53                   	push   %ebx
f0103c5e:	83 ec 5c             	sub    $0x5c,%esp
    char *handler[] = {handler0, handler1, handler2, handler3, handler4, handler5, handler6, handler7, handler8,
f0103c61:	8d 7d 98             	lea    -0x68(%ebp),%edi
f0103c64:	be 80 81 10 f0       	mov    $0xf0108180,%esi
f0103c69:	b9 14 00 00 00       	mov    $0x14,%ecx
f0103c6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (int i = 0; i < 20; i++) {
f0103c70:	bb 00 00 00 00       	mov    $0x0,%ebx
            SETGATE(idt[i], 1, GD_KT, handler[i], 0);
f0103c75:	8b 44 9d 98          	mov    -0x68(%ebp,%ebx,4),%eax
f0103c79:	66 89 04 dd 60 42 23 	mov    %ax,-0xfdcbda0(,%ebx,8)
f0103c80:	f0 
f0103c81:	66 c7 04 dd 62 42 23 	movw   $0x8,-0xfdcbd9e(,%ebx,8)
f0103c88:	f0 08 00 
f0103c8b:	c6 04 dd 64 42 23 f0 	movb   $0x0,-0xfdcbd9c(,%ebx,8)
f0103c92:	00 
f0103c93:	c6 04 dd 65 42 23 f0 	movb   $0x8f,-0xfdcbd9b(,%ebx,8)
f0103c9a:	8f 
f0103c9b:	c1 e8 10             	shr    $0x10,%eax
f0103c9e:	66 89 04 dd 66 42 23 	mov    %ax,-0xfdcbd9a(,%ebx,8)
f0103ca5:	f0 
        cprintf("idt[%d]\toff:0x%x\n", i, (idt[i].gd_off_31_16 << 16) + idt[i].gd_off_15_0);
f0103ca6:	be 60 42 23 f0       	mov    $0xf0234260,%esi
f0103cab:	83 ec 04             	sub    $0x4,%esp
f0103cae:	0f b7 44 de 06       	movzwl 0x6(%esi,%ebx,8),%eax
f0103cb3:	c1 e0 10             	shl    $0x10,%eax
f0103cb6:	0f b7 14 de          	movzwl (%esi,%ebx,8),%edx
f0103cba:	01 d0                	add    %edx,%eax
f0103cbc:	50                   	push   %eax
f0103cbd:	53                   	push   %ebx
f0103cbe:	68 aa 7d 10 f0       	push   $0xf0107daa
f0103cc3:	e8 dd fd ff ff       	call   f0103aa5 <cprintf>
    for (int i = 0; i < 20; i++) {
f0103cc8:	83 c3 01             	add    $0x1,%ebx
f0103ccb:	83 c4 10             	add    $0x10,%esp
f0103cce:	83 fb 13             	cmp    $0x13,%ebx
f0103cd1:	7f 29                	jg     f0103cfc <trap_init+0xa4>
        if (i == T_BRKPT) {
f0103cd3:	83 fb 03             	cmp    $0x3,%ebx
f0103cd6:	75 9d                	jne    f0103c75 <trap_init+0x1d>
            SETGATE(idt[i], 1, GD_KT, handler[i], 3);
f0103cd8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0103cdb:	66 89 46 18          	mov    %ax,0x18(%esi)
f0103cdf:	66 c7 46 1a 08 00    	movw   $0x8,0x1a(%esi)
f0103ce5:	c6 05 7c 42 23 f0 00 	movb   $0x0,0xf023427c
f0103cec:	c6 05 7d 42 23 f0 ef 	movb   $0xef,0xf023427d
f0103cf3:	c1 e8 10             	shr    $0x10,%eax
f0103cf6:	66 89 46 1e          	mov    %ax,0x1e(%esi)
f0103cfa:	eb af                	jmp    f0103cab <trap_init+0x53>
    SETGATE(idt[T_SYSCALL], 1, GD_KT, handler48, 3);
f0103cfc:	b8 ac 43 10 f0       	mov    $0xf01043ac,%eax
f0103d01:	66 a3 e0 43 23 f0    	mov    %ax,0xf02343e0
f0103d07:	66 c7 05 e2 43 23 f0 	movw   $0x8,0xf02343e2
f0103d0e:	08 00 
f0103d10:	c6 05 e4 43 23 f0 00 	movb   $0x0,0xf02343e4
f0103d17:	c6 05 e5 43 23 f0 ef 	movb   $0xef,0xf02343e5
f0103d1e:	c1 e8 10             	shr    $0x10,%eax
f0103d21:	66 a3 e6 43 23 f0    	mov    %ax,0xf02343e6
    trap_init_percpu();
f0103d27:	e8 ae fd ff ff       	call   f0103ada <trap_init_percpu>
}
f0103d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103d2f:	5b                   	pop    %ebx
f0103d30:	5e                   	pop    %esi
f0103d31:	5f                   	pop    %edi
f0103d32:	5d                   	pop    %ebp
f0103d33:	c3                   	ret    

f0103d34 <print_regs>:
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
    }
}

void
print_regs(struct PushRegs *regs) {
f0103d34:	55                   	push   %ebp
f0103d35:	89 e5                	mov    %esp,%ebp
f0103d37:	53                   	push   %ebx
f0103d38:	83 ec 0c             	sub    $0xc,%esp
f0103d3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103d3e:	ff 33                	pushl  (%ebx)
f0103d40:	68 bc 7d 10 f0       	push   $0xf0107dbc
f0103d45:	e8 5b fd ff ff       	call   f0103aa5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103d4a:	83 c4 08             	add    $0x8,%esp
f0103d4d:	ff 73 04             	pushl  0x4(%ebx)
f0103d50:	68 cb 7d 10 f0       	push   $0xf0107dcb
f0103d55:	e8 4b fd ff ff       	call   f0103aa5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103d5a:	83 c4 08             	add    $0x8,%esp
f0103d5d:	ff 73 08             	pushl  0x8(%ebx)
f0103d60:	68 da 7d 10 f0       	push   $0xf0107dda
f0103d65:	e8 3b fd ff ff       	call   f0103aa5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103d6a:	83 c4 08             	add    $0x8,%esp
f0103d6d:	ff 73 0c             	pushl  0xc(%ebx)
f0103d70:	68 e9 7d 10 f0       	push   $0xf0107de9
f0103d75:	e8 2b fd ff ff       	call   f0103aa5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103d7a:	83 c4 08             	add    $0x8,%esp
f0103d7d:	ff 73 10             	pushl  0x10(%ebx)
f0103d80:	68 f8 7d 10 f0       	push   $0xf0107df8
f0103d85:	e8 1b fd ff ff       	call   f0103aa5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103d8a:	83 c4 08             	add    $0x8,%esp
f0103d8d:	ff 73 14             	pushl  0x14(%ebx)
f0103d90:	68 07 7e 10 f0       	push   $0xf0107e07
f0103d95:	e8 0b fd ff ff       	call   f0103aa5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103d9a:	83 c4 08             	add    $0x8,%esp
f0103d9d:	ff 73 18             	pushl  0x18(%ebx)
f0103da0:	68 16 7e 10 f0       	push   $0xf0107e16
f0103da5:	e8 fb fc ff ff       	call   f0103aa5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103daa:	83 c4 08             	add    $0x8,%esp
f0103dad:	ff 73 1c             	pushl  0x1c(%ebx)
f0103db0:	68 25 7e 10 f0       	push   $0xf0107e25
f0103db5:	e8 eb fc ff ff       	call   f0103aa5 <cprintf>
}
f0103dba:	83 c4 10             	add    $0x10,%esp
f0103dbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103dc0:	c9                   	leave  
f0103dc1:	c3                   	ret    

f0103dc2 <print_trapframe>:
print_trapframe(struct Trapframe *tf) {
f0103dc2:	55                   	push   %ebp
f0103dc3:	89 e5                	mov    %esp,%ebp
f0103dc5:	56                   	push   %esi
f0103dc6:	53                   	push   %ebx
f0103dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("TRAP frame at %p\n", tf);
f0103dca:	83 ec 08             	sub    $0x8,%esp
f0103dcd:	53                   	push   %ebx
f0103dce:	68 76 7e 10 f0       	push   $0xf0107e76
f0103dd3:	e8 cd fc ff ff       	call   f0103aa5 <cprintf>
    print_regs(&tf->tf_regs);
f0103dd8:	89 1c 24             	mov    %ebx,(%esp)
f0103ddb:	e8 54 ff ff ff       	call   f0103d34 <print_regs>
    cprintf("  es   0x----%04x\n", tf->tf_es);
f0103de0:	83 c4 08             	add    $0x8,%esp
f0103de3:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103de7:	50                   	push   %eax
f0103de8:	68 88 7e 10 f0       	push   $0xf0107e88
f0103ded:	e8 b3 fc ff ff       	call   f0103aa5 <cprintf>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103df2:	83 c4 08             	add    $0x8,%esp
f0103df5:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103df9:	50                   	push   %eax
f0103dfa:	68 9b 7e 10 f0       	push   $0xf0107e9b
f0103dff:	e8 a1 fc ff ff       	call   f0103aa5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103e04:	8b 43 28             	mov    0x28(%ebx),%eax
    if (trapno < ARRAY_SIZE(excnames))
f0103e07:	83 c4 10             	add    $0x10,%esp
f0103e0a:	83 f8 13             	cmp    $0x13,%eax
f0103e0d:	0f 86 d4 00 00 00    	jbe    f0103ee7 <print_trapframe+0x125>
    return "(unknown trap)";
f0103e13:	83 f8 30             	cmp    $0x30,%eax
f0103e16:	ba 34 7e 10 f0       	mov    $0xf0107e34,%edx
f0103e1b:	b9 40 7e 10 f0       	mov    $0xf0107e40,%ecx
f0103e20:	0f 45 d1             	cmovne %ecx,%edx
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103e23:	83 ec 04             	sub    $0x4,%esp
f0103e26:	52                   	push   %edx
f0103e27:	50                   	push   %eax
f0103e28:	68 ae 7e 10 f0       	push   $0xf0107eae
f0103e2d:	e8 73 fc ff ff       	call   f0103aa5 <cprintf>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103e32:	83 c4 10             	add    $0x10,%esp
f0103e35:	39 1d 60 4a 23 f0    	cmp    %ebx,0xf0234a60
f0103e3b:	0f 84 b2 00 00 00    	je     f0103ef3 <print_trapframe+0x131>
    cprintf("  err  0x%08x", tf->tf_err);
f0103e41:	83 ec 08             	sub    $0x8,%esp
f0103e44:	ff 73 2c             	pushl  0x2c(%ebx)
f0103e47:	68 cf 7e 10 f0       	push   $0xf0107ecf
f0103e4c:	e8 54 fc ff ff       	call   f0103aa5 <cprintf>
    if (tf->tf_trapno == T_PGFLT)
f0103e51:	83 c4 10             	add    $0x10,%esp
f0103e54:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103e58:	0f 85 b8 00 00 00    	jne    f0103f16 <print_trapframe+0x154>
                tf->tf_err & 1 ? "protection" : "not-present");
f0103e5e:	8b 43 2c             	mov    0x2c(%ebx),%eax
        cprintf(" [%s, %s, %s]\n",
f0103e61:	89 c2                	mov    %eax,%edx
f0103e63:	83 e2 01             	and    $0x1,%edx
f0103e66:	b9 4f 7e 10 f0       	mov    $0xf0107e4f,%ecx
f0103e6b:	ba 5a 7e 10 f0       	mov    $0xf0107e5a,%edx
f0103e70:	0f 44 ca             	cmove  %edx,%ecx
f0103e73:	89 c2                	mov    %eax,%edx
f0103e75:	83 e2 02             	and    $0x2,%edx
f0103e78:	be 66 7e 10 f0       	mov    $0xf0107e66,%esi
f0103e7d:	ba 6c 7e 10 f0       	mov    $0xf0107e6c,%edx
f0103e82:	0f 45 d6             	cmovne %esi,%edx
f0103e85:	83 e0 04             	and    $0x4,%eax
f0103e88:	b8 71 7e 10 f0       	mov    $0xf0107e71,%eax
f0103e8d:	be 32 80 10 f0       	mov    $0xf0108032,%esi
f0103e92:	0f 44 c6             	cmove  %esi,%eax
f0103e95:	51                   	push   %ecx
f0103e96:	52                   	push   %edx
f0103e97:	50                   	push   %eax
f0103e98:	68 dd 7e 10 f0       	push   $0xf0107edd
f0103e9d:	e8 03 fc ff ff       	call   f0103aa5 <cprintf>
f0103ea2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103ea5:	83 ec 08             	sub    $0x8,%esp
f0103ea8:	ff 73 30             	pushl  0x30(%ebx)
f0103eab:	68 ec 7e 10 f0       	push   $0xf0107eec
f0103eb0:	e8 f0 fb ff ff       	call   f0103aa5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103eb5:	83 c4 08             	add    $0x8,%esp
f0103eb8:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103ebc:	50                   	push   %eax
f0103ebd:	68 fb 7e 10 f0       	push   $0xf0107efb
f0103ec2:	e8 de fb ff ff       	call   f0103aa5 <cprintf>
    cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103ec7:	83 c4 08             	add    $0x8,%esp
f0103eca:	ff 73 38             	pushl  0x38(%ebx)
f0103ecd:	68 0e 7f 10 f0       	push   $0xf0107f0e
f0103ed2:	e8 ce fb ff ff       	call   f0103aa5 <cprintf>
    if ((tf->tf_cs & 3) != 0) {
f0103ed7:	83 c4 10             	add    $0x10,%esp
f0103eda:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103ede:	75 4b                	jne    f0103f2b <print_trapframe+0x169>
}
f0103ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103ee3:	5b                   	pop    %ebx
f0103ee4:	5e                   	pop    %esi
f0103ee5:	5d                   	pop    %ebp
f0103ee6:	c3                   	ret    
        return excnames[trapno];
f0103ee7:	8b 14 85 a0 82 10 f0 	mov    -0xfef7d60(,%eax,4),%edx
f0103eee:	e9 30 ff ff ff       	jmp    f0103e23 <print_trapframe+0x61>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103ef3:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103ef7:	0f 85 44 ff ff ff    	jne    f0103e41 <print_trapframe+0x7f>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103efd:	0f 20 d0             	mov    %cr2,%eax
        cprintf("  cr2  0x%08x\n", rcr2());
f0103f00:	83 ec 08             	sub    $0x8,%esp
f0103f03:	50                   	push   %eax
f0103f04:	68 c0 7e 10 f0       	push   $0xf0107ec0
f0103f09:	e8 97 fb ff ff       	call   f0103aa5 <cprintf>
f0103f0e:	83 c4 10             	add    $0x10,%esp
f0103f11:	e9 2b ff ff ff       	jmp    f0103e41 <print_trapframe+0x7f>
        cprintf("\n");
f0103f16:	83 ec 0c             	sub    $0xc,%esp
f0103f19:	68 26 79 10 f0       	push   $0xf0107926
f0103f1e:	e8 82 fb ff ff       	call   f0103aa5 <cprintf>
f0103f23:	83 c4 10             	add    $0x10,%esp
f0103f26:	e9 7a ff ff ff       	jmp    f0103ea5 <print_trapframe+0xe3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103f2b:	83 ec 08             	sub    $0x8,%esp
f0103f2e:	ff 73 3c             	pushl  0x3c(%ebx)
f0103f31:	68 1d 7f 10 f0       	push   $0xf0107f1d
f0103f36:	e8 6a fb ff ff       	call   f0103aa5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103f3b:	83 c4 08             	add    $0x8,%esp
f0103f3e:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103f42:	50                   	push   %eax
f0103f43:	68 2c 7f 10 f0       	push   $0xf0107f2c
f0103f48:	e8 58 fb ff ff       	call   f0103aa5 <cprintf>
f0103f4d:	83 c4 10             	add    $0x10,%esp
}
f0103f50:	eb 8e                	jmp    f0103ee0 <print_trapframe+0x11e>

f0103f52 <page_fault_handler>:
//    assert(curenv && curenv->env_status == ENV_RUNNING);
//    env_run(curenv);
}

void
page_fault_handler(struct Trapframe *tf) {
f0103f52:	55                   	push   %ebp
f0103f53:	89 e5                	mov    %esp,%ebp
f0103f55:	57                   	push   %edi
f0103f56:	56                   	push   %esi
f0103f57:	53                   	push   %ebx
f0103f58:	83 ec 1c             	sub    $0x1c,%esp
f0103f5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0103f5e:	0f 20 d0             	mov    %cr2,%eax
f0103f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // Handle kernel-mode page faults.

    // LAB 3: Your code here.
//    print_trapframe(tf);
    if ((tf->tf_cs & 3) == 0) {
f0103f64:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103f68:	75 20                	jne    f0103f8a <page_fault_handler+0x38>
        print_trapframe(tf);
f0103f6a:	83 ec 0c             	sub    $0xc,%esp
f0103f6d:	53                   	push   %ebx
f0103f6e:	e8 4f fe ff ff       	call   f0103dc2 <print_trapframe>
        panic("kernel-mode exception\n");
f0103f73:	83 c4 0c             	add    $0xc,%esp
f0103f76:	68 3f 7f 10 f0       	push   $0xf0107f3f
f0103f7b:	68 71 01 00 00       	push   $0x171
f0103f80:	68 56 7f 10 f0       	push   $0xf0107f56
f0103f85:	e8 b6 c0 ff ff       	call   f0100040 <_panic>

    // Call the environment's page fault upcall, if one exists.  Set up a
    // page fault stack frame on the user exception stack (below
    // UXSTACKTOP), then branch to curenv->env_pgfault_upcall.

    if (curenv->env_pgfault_upcall == NULL) {
f0103f8a:	e8 14 1c 00 00       	call   f0105ba3 <cpunum>
f0103f8f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f92:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0103f98:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103f9c:	0f 84 a2 00 00 00    	je     f0104044 <page_fault_handler+0xf2>
                curenv->env_id, fault_va, tf->tf_eip);
        print_trapframe(tf);
        env_destroy(curenv);
    }

    user_mem_assert(curenv, (void *) UXSTACKTOP - PGSIZE, PGSIZE, PTE_W);
f0103fa2:	e8 fc 1b 00 00       	call   f0105ba3 <cpunum>
f0103fa7:	6a 02                	push   $0x2
f0103fa9:	68 00 10 00 00       	push   $0x1000
f0103fae:	68 00 f0 bf ee       	push   $0xeebff000
f0103fb3:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fb6:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0103fbc:	e8 b1 f1 ff ff       	call   f0103172 <user_mem_assert>

    struct UTrapframe *uTrapframe;
    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f0103fc1:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103fc4:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
f0103fca:	83 c4 10             	add    $0x10,%esp

        if ((uintptr_t) uTrapframe < UXSTACKTOP - PGSIZE) {
            env_destroy(curenv);
        }
    } else {
        uTrapframe = (struct UTrapframe *) (UXSTACKTOP - sizeof(struct UTrapframe));
f0103fcd:	be cc ff bf ee       	mov    $0xeebfffcc,%esi
    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f0103fd2:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0103fd8:	77 10                	ja     f0103fea <page_fault_handler+0x98>
        uTrapframe = (struct UTrapframe *) (tf->tf_esp - 4 - sizeof(struct UTrapframe));
f0103fda:	83 e8 38             	sub    $0x38,%eax
f0103fdd:	89 c6                	mov    %eax,%esi
        if ((uintptr_t) uTrapframe < UXSTACKTOP - PGSIZE) {
f0103fdf:	3d ff ef bf ee       	cmp    $0xeebfefff,%eax
f0103fe4:	0f 86 a2 00 00 00    	jbe    f010408c <page_fault_handler+0x13a>
    }

//    cprintf("&uTrapframe->utf->esp:0x%x\n", &uTrapframe->utf_esp);
    uTrapframe->utf_esp = tf->tf_esp;
f0103fea:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103fed:	89 f2                	mov    %esi,%edx
f0103fef:	89 46 30             	mov    %eax,0x30(%esi)
    uTrapframe->utf_eflags = tf->tf_eflags;
f0103ff2:	8b 43 38             	mov    0x38(%ebx),%eax
f0103ff5:	89 46 2c             	mov    %eax,0x2c(%esi)
    uTrapframe->utf_eip = tf->tf_eip;
f0103ff8:	8b 43 30             	mov    0x30(%ebx),%eax
f0103ffb:	89 46 28             	mov    %eax,0x28(%esi)
    uTrapframe->utf_regs = tf->tf_regs;
f0103ffe:	8d 7e 08             	lea    0x8(%esi),%edi
f0104001:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104006:	89 de                	mov    %ebx,%esi
f0104008:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    uTrapframe->utf_err = tf->tf_err;
f010400a:	8b 43 2c             	mov    0x2c(%ebx),%eax
f010400d:	89 d7                	mov    %edx,%edi
f010400f:	89 42 04             	mov    %eax,0x4(%edx)
    uTrapframe->utf_fault_va = fault_va;
f0104012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104015:	89 02                	mov    %eax,(%edx)
    // Hints:
    //   user_mem_assert() and env_run() are useful here.
    //   To change what the user environment runs, modify 'curenv->env_tf'
    //   (the 'tf' variable points at 'curenv->env_tf').

    tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
f0104017:	e8 87 1b 00 00       	call   f0105ba3 <cpunum>
f010401c:	6b c0 74             	imul   $0x74,%eax,%eax
f010401f:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104025:	8b 40 64             	mov    0x64(%eax),%eax
f0104028:	89 43 30             	mov    %eax,0x30(%ebx)
    tf->tf_esp = (uintptr_t) uTrapframe;
f010402b:	89 7b 3c             	mov    %edi,0x3c(%ebx)

//    cprintf("pgfault routinue eip:0x%x\tuTrapframe:0x%x\n", tf->tf_eip, uTrapframe);
//    cprintf("uTrapframe:0x%x\tuTrapframe->utf_regs.reg_ebp:0x%x\tuTrapframe->utf_regs.reg_esp:0x%x\n", uTrapframe,
//            uTrapframe->utf_regs.reg_ebp, uTrapframe->utf_esp);
    env_run(curenv);
f010402e:	e8 70 1b 00 00       	call   f0105ba3 <cpunum>
f0104033:	83 ec 0c             	sub    $0xc,%esp
f0104036:	6b c0 74             	imul   $0x74,%eax,%eax
f0104039:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f010403f:	e8 3b f8 ff ff       	call   f010387f <env_run>
        cprintf("[%08x] user fault va %08x ip %08x\n",
f0104044:	8b 73 30             	mov    0x30(%ebx),%esi
                curenv->env_id, fault_va, tf->tf_eip);
f0104047:	e8 57 1b 00 00       	call   f0105ba3 <cpunum>
        cprintf("[%08x] user fault va %08x ip %08x\n",
f010404c:	56                   	push   %esi
f010404d:	ff 75 e4             	pushl  -0x1c(%ebp)
                curenv->env_id, fault_va, tf->tf_eip);
f0104050:	6b c0 74             	imul   $0x74,%eax,%eax
        cprintf("[%08x] user fault va %08x ip %08x\n",
f0104053:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104059:	ff 70 48             	pushl  0x48(%eax)
f010405c:	68 04 7d 10 f0       	push   $0xf0107d04
f0104061:	e8 3f fa ff ff       	call   f0103aa5 <cprintf>
        print_trapframe(tf);
f0104066:	89 1c 24             	mov    %ebx,(%esp)
f0104069:	e8 54 fd ff ff       	call   f0103dc2 <print_trapframe>
        env_destroy(curenv);
f010406e:	e8 30 1b 00 00       	call   f0105ba3 <cpunum>
f0104073:	83 c4 04             	add    $0x4,%esp
f0104076:	6b c0 74             	imul   $0x74,%eax,%eax
f0104079:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f010407f:	e8 76 f7 ff ff       	call   f01037fa <env_destroy>
f0104084:	83 c4 10             	add    $0x10,%esp
f0104087:	e9 16 ff ff ff       	jmp    f0103fa2 <page_fault_handler+0x50>
            env_destroy(curenv);
f010408c:	e8 12 1b 00 00       	call   f0105ba3 <cpunum>
f0104091:	83 ec 0c             	sub    $0xc,%esp
f0104094:	6b c0 74             	imul   $0x74,%eax,%eax
f0104097:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f010409d:	e8 58 f7 ff ff       	call   f01037fa <env_destroy>
f01040a2:	83 c4 10             	add    $0x10,%esp
f01040a5:	e9 40 ff ff ff       	jmp    f0103fea <page_fault_handler+0x98>

f01040aa <trap>:
trap(struct Trapframe *tf) {
f01040aa:	55                   	push   %ebp
f01040ab:	89 e5                	mov    %esp,%ebp
f01040ad:	57                   	push   %edi
f01040ae:	56                   	push   %esi
f01040af:	8b 75 08             	mov    0x8(%ebp),%esi
    asm volatile("cld":: : "cc");
f01040b2:	fc                   	cld    
    if (panicstr)
f01040b3:	83 3d 84 4e 23 f0 00 	cmpl   $0x0,0xf0234e84
f01040ba:	74 01                	je     f01040bd <trap+0x13>
            asm volatile("hlt");
f01040bc:	f4                   	hlt    
    if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01040bd:	e8 e1 1a 00 00       	call   f0105ba3 <cpunum>
f01040c2:	6b d0 74             	imul   $0x74,%eax,%edx
f01040c5:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01040c8:	b8 01 00 00 00       	mov    $0x1,%eax
f01040cd:	f0 87 82 20 50 23 f0 	lock xchg %eax,-0xfdcafe0(%edx)
f01040d4:	83 f8 02             	cmp    $0x2,%eax
f01040d7:	74 2e                	je     f0104107 <trap+0x5d>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01040d9:	9c                   	pushf  
f01040da:	58                   	pop    %eax
    assert(!(read_eflags() & FL_IF));
f01040db:	f6 c4 02             	test   $0x2,%ah
f01040de:	75 39                	jne    f0104119 <trap+0x6f>
    if ((tf->tf_cs & 3) == 3) {
f01040e0:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01040e4:	83 e0 03             	and    $0x3,%eax
f01040e7:	66 83 f8 03          	cmp    $0x3,%ax
f01040eb:	74 45                	je     f0104132 <trap+0x88>
    last_tf = tf;
f01040ed:	89 35 60 4a 23 f0    	mov    %esi,0xf0234a60
    switch (tf->tf_trapno) {
f01040f3:	83 7e 28 30          	cmpl   $0x30,0x28(%esi)
f01040f7:	0f 87 0d 02 00 00    	ja     f010430a <trap+0x260>
f01040fd:	8b 46 28             	mov    0x28(%esi),%eax
f0104100:	ff 24 85 d0 81 10 f0 	jmp    *-0xfef7e30(,%eax,4)
	spin_lock(&kernel_lock);
f0104107:	83 ec 0c             	sub    $0xc,%esp
f010410a:	68 c0 23 12 f0       	push   $0xf01223c0
f010410f:	e8 11 1d 00 00       	call   f0105e25 <spin_lock>
f0104114:	83 c4 10             	add    $0x10,%esp
f0104117:	eb c0                	jmp    f01040d9 <trap+0x2f>
    assert(!(read_eflags() & FL_IF));
f0104119:	68 62 7f 10 f0       	push   $0xf0107f62
f010411e:	68 e1 75 10 f0       	push   $0xf01075e1
f0104123:	68 32 01 00 00       	push   $0x132
f0104128:	68 56 7f 10 f0       	push   $0xf0107f56
f010412d:	e8 0e bf ff ff       	call   f0100040 <_panic>
f0104132:	83 ec 0c             	sub    $0xc,%esp
f0104135:	68 c0 23 12 f0       	push   $0xf01223c0
f010413a:	e8 e6 1c 00 00       	call   f0105e25 <spin_lock>
        assert(curenv);
f010413f:	e8 5f 1a 00 00       	call   f0105ba3 <cpunum>
f0104144:	6b c0 74             	imul   $0x74,%eax,%eax
f0104147:	83 c4 10             	add    $0x10,%esp
f010414a:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0104151:	74 3e                	je     f0104191 <trap+0xe7>
        if (curenv->env_status == ENV_DYING) {
f0104153:	e8 4b 1a 00 00       	call   f0105ba3 <cpunum>
f0104158:	6b c0 74             	imul   $0x74,%eax,%eax
f010415b:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104161:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104165:	74 43                	je     f01041aa <trap+0x100>
        curenv->env_tf = *tf;
f0104167:	e8 37 1a 00 00       	call   f0105ba3 <cpunum>
f010416c:	6b c0 74             	imul   $0x74,%eax,%eax
f010416f:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104175:	b9 11 00 00 00       	mov    $0x11,%ecx
f010417a:	89 c7                	mov    %eax,%edi
f010417c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        tf = &curenv->env_tf;
f010417e:	e8 20 1a 00 00       	call   f0105ba3 <cpunum>
f0104183:	6b c0 74             	imul   $0x74,%eax,%eax
f0104186:	8b b0 28 50 23 f0    	mov    -0xfdcafd8(%eax),%esi
f010418c:	e9 5c ff ff ff       	jmp    f01040ed <trap+0x43>
        assert(curenv);
f0104191:	68 7b 7f 10 f0       	push   $0xf0107f7b
f0104196:	68 e1 75 10 f0       	push   $0xf01075e1
f010419b:	68 3e 01 00 00       	push   $0x13e
f01041a0:	68 56 7f 10 f0       	push   $0xf0107f56
f01041a5:	e8 96 be ff ff       	call   f0100040 <_panic>
            env_free(curenv);
f01041aa:	e8 f4 19 00 00       	call   f0105ba3 <cpunum>
f01041af:	83 ec 0c             	sub    $0xc,%esp
f01041b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01041b5:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f01041bb:	e8 7d f4 ff ff       	call   f010363d <env_free>
            curenv = NULL;
f01041c0:	e8 de 19 00 00       	call   f0105ba3 <cpunum>
f01041c5:	6b c0 74             	imul   $0x74,%eax,%eax
f01041c8:	c7 80 28 50 23 f0 00 	movl   $0x0,-0xfdcafd8(%eax)
f01041cf:	00 00 00 
            sched_yield();
f01041d2:	e8 be 02 00 00       	call   f0104495 <sched_yield>
            cprintf("Divide Error fault\n");
f01041d7:	83 ec 0c             	sub    $0xc,%esp
f01041da:	68 82 7f 10 f0       	push   $0xf0107f82
f01041df:	e8 c1 f8 ff ff       	call   f0103aa5 <cprintf>
f01041e4:	83 c4 10             	add    $0x10,%esp
    print_trapframe(tf);
f01041e7:	83 ec 0c             	sub    $0xc,%esp
f01041ea:	56                   	push   %esi
f01041eb:	e8 d2 fb ff ff       	call   f0103dc2 <print_trapframe>
    if (tf->tf_cs == GD_KT)
f01041f0:	83 c4 10             	add    $0x10,%esp
f01041f3:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01041f8:	0f 84 21 01 00 00    	je     f010431f <trap+0x275>
        env_destroy(curenv);
f01041fe:	e8 a0 19 00 00       	call   f0105ba3 <cpunum>
f0104203:	83 ec 0c             	sub    $0xc,%esp
f0104206:	6b c0 74             	imul   $0x74,%eax,%eax
f0104209:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f010420f:	e8 e6 f5 ff ff       	call   f01037fa <env_destroy>
f0104214:	83 c4 10             	add    $0x10,%esp
    if (curenv && curenv->env_status == ENV_RUNNING)
f0104217:	e8 87 19 00 00       	call   f0105ba3 <cpunum>
f010421c:	6b c0 74             	imul   $0x74,%eax,%eax
f010421f:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0104226:	74 18                	je     f0104240 <trap+0x196>
f0104228:	e8 76 19 00 00       	call   f0105ba3 <cpunum>
f010422d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104230:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104236:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010423a:	0f 84 f6 00 00 00    	je     f0104336 <trap+0x28c>
        sched_yield();
f0104240:	e8 50 02 00 00       	call   f0104495 <sched_yield>
            cprintf("Debug exceptions. Hints: An exception handler can examine the debug registers to determine which condition caused the exception.\n");
f0104245:	83 ec 0c             	sub    $0xc,%esp
f0104248:	68 28 7d 10 f0       	push   $0xf0107d28
f010424d:	e8 53 f8 ff ff       	call   f0103aa5 <cprintf>
f0104252:	83 c4 10             	add    $0x10,%esp
f0104255:	eb 90                	jmp    f01041e7 <trap+0x13d>
            cprintf("Breakpoint INT 3 trap\n");
f0104257:	83 ec 0c             	sub    $0xc,%esp
f010425a:	68 96 7f 10 f0       	push   $0xf0107f96
f010425f:	e8 41 f8 ff ff       	call   f0103aa5 <cprintf>
            monitor(tf);
f0104264:	89 34 24             	mov    %esi,(%esp)
f0104267:	e8 86 c6 ff ff       	call   f01008f2 <monitor>
f010426c:	83 c4 10             	add    $0x10,%esp
f010426f:	e9 73 ff ff ff       	jmp    f01041e7 <trap+0x13d>
            cprintf("Overflow trap\n");
f0104274:	83 ec 0c             	sub    $0xc,%esp
f0104277:	68 ad 7f 10 f0       	push   $0xf0107fad
f010427c:	e8 24 f8 ff ff       	call   f0103aa5 <cprintf>
f0104281:	83 c4 10             	add    $0x10,%esp
f0104284:	e9 5e ff ff ff       	jmp    f01041e7 <trap+0x13d>
            cprintf("Bounds Check fault\n");
f0104289:	83 ec 0c             	sub    $0xc,%esp
f010428c:	68 bc 7f 10 f0       	push   $0xf0107fbc
f0104291:	e8 0f f8 ff ff       	call   f0103aa5 <cprintf>
f0104296:	83 c4 10             	add    $0x10,%esp
f0104299:	e9 49 ff ff ff       	jmp    f01041e7 <trap+0x13d>
            cprintf("Invalid Opcode fault\n");
f010429e:	83 ec 0c             	sub    $0xc,%esp
f01042a1:	68 d0 7f 10 f0       	push   $0xf0107fd0
f01042a6:	e8 fa f7 ff ff       	call   f0103aa5 <cprintf>
f01042ab:	83 c4 10             	add    $0x10,%esp
f01042ae:	e9 34 ff ff ff       	jmp    f01041e7 <trap+0x13d>
            cprintf("Double Fault\n");
f01042b3:	83 ec 0c             	sub    $0xc,%esp
f01042b6:	68 e6 7f 10 f0       	push   $0xf0107fe6
f01042bb:	e8 e5 f7 ff ff       	call   f0103aa5 <cprintf>
f01042c0:	83 c4 10             	add    $0x10,%esp
f01042c3:	e9 1f ff ff ff       	jmp    f01041e7 <trap+0x13d>
            cprintf("General Protection Exception\n");
f01042c8:	83 ec 0c             	sub    $0xc,%esp
f01042cb:	68 f4 7f 10 f0       	push   $0xf0107ff4
f01042d0:	e8 d0 f7 ff ff       	call   f0103aa5 <cprintf>
f01042d5:	83 c4 10             	add    $0x10,%esp
f01042d8:	e9 0a ff ff ff       	jmp    f01041e7 <trap+0x13d>
            page_fault_handler(tf);
f01042dd:	83 ec 0c             	sub    $0xc,%esp
f01042e0:	56                   	push   %esi
f01042e1:	e8 6c fc ff ff       	call   f0103f52 <page_fault_handler>
            tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f01042e6:	83 ec 08             	sub    $0x8,%esp
f01042e9:	ff 76 04             	pushl  0x4(%esi)
f01042ec:	ff 36                	pushl  (%esi)
f01042ee:	ff 76 10             	pushl  0x10(%esi)
f01042f1:	ff 76 18             	pushl  0x18(%esi)
f01042f4:	ff 76 14             	pushl  0x14(%esi)
f01042f7:	ff 76 1c             	pushl  0x1c(%esi)
f01042fa:	e8 51 02 00 00       	call   f0104550 <syscall>
f01042ff:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104302:	83 c4 20             	add    $0x20,%esp
f0104305:	e9 0d ff ff ff       	jmp    f0104217 <trap+0x16d>
            cprintf("Unknown Trap\n");
f010430a:	83 ec 0c             	sub    $0xc,%esp
f010430d:	68 12 80 10 f0       	push   $0xf0108012
f0104312:	e8 8e f7 ff ff       	call   f0103aa5 <cprintf>
f0104317:	83 c4 10             	add    $0x10,%esp
f010431a:	e9 c8 fe ff ff       	jmp    f01041e7 <trap+0x13d>
        panic("unhandled trap in kernel");
f010431f:	83 ec 04             	sub    $0x4,%esp
f0104322:	68 20 80 10 f0       	push   $0xf0108020
f0104327:	68 18 01 00 00       	push   $0x118
f010432c:	68 56 7f 10 f0       	push   $0xf0107f56
f0104331:	e8 0a bd ff ff       	call   f0100040 <_panic>
        env_run(curenv);
f0104336:	e8 68 18 00 00       	call   f0105ba3 <cpunum>
f010433b:	83 ec 0c             	sub    $0xc,%esp
f010433e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104341:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104347:	e8 33 f5 ff ff       	call   f010387f <env_run>

f010434c <handler0>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
//which need error_code?
TRAPHANDLER_NOEC(handler0, T_DIVIDE);
f010434c:	6a 00                	push   $0x0
f010434e:	6a 00                	push   $0x0
f0104350:	eb 60                	jmp    f01043b2 <_alltraps>

f0104352 <handler1>:
TRAPHANDLER_NOEC(handler1, T_DEBUG);
f0104352:	6a 00                	push   $0x0
f0104354:	6a 01                	push   $0x1
f0104356:	eb 5a                	jmp    f01043b2 <_alltraps>

f0104358 <handler2>:
TRAPHANDLER_NOEC(handler2, T_NMI);
f0104358:	6a 00                	push   $0x0
f010435a:	6a 02                	push   $0x2
f010435c:	eb 54                	jmp    f01043b2 <_alltraps>

f010435e <handler3>:
TRAPHANDLER_NOEC(handler3, T_BRKPT);
f010435e:	6a 00                	push   $0x0
f0104360:	6a 03                	push   $0x3
f0104362:	eb 4e                	jmp    f01043b2 <_alltraps>

f0104364 <handler4>:
TRAPHANDLER_NOEC(handler4, T_OFLOW);
f0104364:	6a 00                	push   $0x0
f0104366:	6a 04                	push   $0x4
f0104368:	eb 48                	jmp    f01043b2 <_alltraps>

f010436a <handler5>:
TRAPHANDLER_NOEC(handler5, T_BOUND);
f010436a:	6a 00                	push   $0x0
f010436c:	6a 05                	push   $0x5
f010436e:	eb 42                	jmp    f01043b2 <_alltraps>

f0104370 <handler6>:
TRAPHANDLER_NOEC(handler6, T_ILLOP);
f0104370:	6a 00                	push   $0x0
f0104372:	6a 06                	push   $0x6
f0104374:	eb 3c                	jmp    f01043b2 <_alltraps>

f0104376 <handler7>:
TRAPHANDLER_NOEC(handler7, T_DEVICE);
f0104376:	6a 00                	push   $0x0
f0104378:	6a 07                	push   $0x7
f010437a:	eb 36                	jmp    f01043b2 <_alltraps>

f010437c <handler8>:
TRAPHANDLER(handler8, T_DBLFLT);
f010437c:	6a 08                	push   $0x8
f010437e:	eb 32                	jmp    f01043b2 <_alltraps>

f0104380 <handler10>:
//TRAPHANDLER_NOEC(handler9, T_COPROC);
TRAPHANDLER(handler10, T_TSS);
f0104380:	6a 0a                	push   $0xa
f0104382:	eb 2e                	jmp    f01043b2 <_alltraps>

f0104384 <handler11>:
TRAPHANDLER(handler11, T_SEGNP);
f0104384:	6a 0b                	push   $0xb
f0104386:	eb 2a                	jmp    f01043b2 <_alltraps>

f0104388 <handler12>:
TRAPHANDLER(handler12, T_STACK);
f0104388:	6a 0c                	push   $0xc
f010438a:	eb 26                	jmp    f01043b2 <_alltraps>

f010438c <handler13>:
TRAPHANDLER(handler13, T_GPFLT);
f010438c:	6a 0d                	push   $0xd
f010438e:	eb 22                	jmp    f01043b2 <_alltraps>

f0104390 <handler14>:
TRAPHANDLER(handler14, T_PGFLT);
f0104390:	6a 0e                	push   $0xe
f0104392:	eb 1e                	jmp    f01043b2 <_alltraps>

f0104394 <handler16>:
//TRAPHANDLER_NOEC(handler15, T_RES);
TRAPHANDLER_NOEC(handler16, T_FPERR);
f0104394:	6a 00                	push   $0x0
f0104396:	6a 10                	push   $0x10
f0104398:	eb 18                	jmp    f01043b2 <_alltraps>

f010439a <handler17>:
TRAPHANDLER_NOEC(handler17, T_ALIGN);
f010439a:	6a 00                	push   $0x0
f010439c:	6a 11                	push   $0x11
f010439e:	eb 12                	jmp    f01043b2 <_alltraps>

f01043a0 <handler18>:
TRAPHANDLER_NOEC(handler18, T_MCHK);
f01043a0:	6a 00                	push   $0x0
f01043a2:	6a 12                	push   $0x12
f01043a4:	eb 0c                	jmp    f01043b2 <_alltraps>

f01043a6 <handler19>:
TRAPHANDLER_NOEC(handler19, T_SIMDERR);
f01043a6:	6a 00                	push   $0x0
f01043a8:	6a 13                	push   $0x13
f01043aa:	eb 06                	jmp    f01043b2 <_alltraps>

f01043ac <handler48>:

TRAPHANDLER_NOEC(handler48, T_SYSCALL);
f01043ac:	6a 00                	push   $0x0
f01043ae:	6a 30                	push   $0x30
f01043b0:	eb 00                	jmp    f01043b2 <_alltraps>

f01043b2 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
    //i stupid here
    pushl %ds
f01043b2:	1e                   	push   %ds
    pushl %es
f01043b3:	06                   	push   %es
    // forget above
    pushal
f01043b4:	60                   	pusha  
    movl $GD_KD, %eax
f01043b5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
f01043ba:	8e d8                	mov    %eax,%ds
    movw %ax, %es
f01043bc:	8e c0                	mov    %eax,%es
    pushl %esp
f01043be:	54                   	push   %esp
f01043bf:	e8 e6 fc ff ff       	call   f01040aa <trap>

f01043c4 <sched_halt>:

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void) {
f01043c4:	55                   	push   %ebp
f01043c5:	89 e5                	mov    %esp,%ebp
f01043c7:	83 ec 08             	sub    $0x8,%esp
f01043ca:	a1 4c 42 23 f0       	mov    0xf023424c,%eax
f01043cf:	83 c0 54             	add    $0x54,%eax
    int i;

    // For debugging and testing purposes, if there are no runnable
    // environments in the system, then drop into the kernel monitor.
    for (i = 0; i < NENV; i++) {
f01043d2:	b9 00 00 00 00       	mov    $0x0,%ecx
        if ((envs[i].env_status == ENV_RUNNABLE ||
             envs[i].env_status == ENV_RUNNING ||
f01043d7:	8b 10                	mov    (%eax),%edx
f01043d9:	83 ea 01             	sub    $0x1,%edx
        if ((envs[i].env_status == ENV_RUNNABLE ||
f01043dc:	83 fa 02             	cmp    $0x2,%edx
f01043df:	76 2d                	jbe    f010440e <sched_halt+0x4a>
    for (i = 0; i < NENV; i++) {
f01043e1:	83 c1 01             	add    $0x1,%ecx
f01043e4:	83 c0 7c             	add    $0x7c,%eax
f01043e7:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01043ed:	75 e8                	jne    f01043d7 <sched_halt+0x13>
             envs[i].env_status == ENV_DYING))
            break;
    }
    if (i == NENV) {
        cprintf("No runnable environments in the system!\n");
f01043ef:	83 ec 0c             	sub    $0xc,%esp
f01043f2:	68 f0 82 10 f0       	push   $0xf01082f0
f01043f7:	e8 a9 f6 ff ff       	call   f0103aa5 <cprintf>
f01043fc:	83 c4 10             	add    $0x10,%esp
        while (1)
            monitor(NULL);
f01043ff:	83 ec 0c             	sub    $0xc,%esp
f0104402:	6a 00                	push   $0x0
f0104404:	e8 e9 c4 ff ff       	call   f01008f2 <monitor>
f0104409:	83 c4 10             	add    $0x10,%esp
f010440c:	eb f1                	jmp    f01043ff <sched_halt+0x3b>
    if (i == NENV) {
f010440e:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104414:	74 d9                	je     f01043ef <sched_halt+0x2b>
    }

    // Mark that no environment is running on this CPU
    curenv = NULL;
f0104416:	e8 88 17 00 00       	call   f0105ba3 <cpunum>
f010441b:	6b c0 74             	imul   $0x74,%eax,%eax
f010441e:	c7 80 28 50 23 f0 00 	movl   $0x0,-0xfdcafd8(%eax)
f0104425:	00 00 00 
    lcr3(PADDR(kern_pgdir));
f0104428:	a1 90 4e 23 f0       	mov    0xf0234e90,%eax
	if ((uint32_t)kva < KERNBASE)
f010442d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104432:	76 4f                	jbe    f0104483 <sched_halt+0xbf>
	return (physaddr_t)kva - KERNBASE;
f0104434:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104439:	0f 22 d8             	mov    %eax,%cr3

    // Mark that this CPU is in the HALT state, so that when
    // timer interupts come in, we know we should re-acquire the
    // big kernel lock
    xchg(&thiscpu->cpu_status, CPU_HALTED);
f010443c:	e8 62 17 00 00       	call   f0105ba3 <cpunum>
f0104441:	6b d0 74             	imul   $0x74,%eax,%edx
f0104444:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104447:	b8 02 00 00 00       	mov    $0x2,%eax
f010444c:	f0 87 82 20 50 23 f0 	lock xchg %eax,-0xfdcafe0(%edx)
	spin_unlock(&kernel_lock);
f0104453:	83 ec 0c             	sub    $0xc,%esp
f0104456:	68 c0 23 12 f0       	push   $0xf01223c0
f010445b:	e8 62 1a 00 00       	call   f0105ec2 <spin_unlock>
    asm volatile("pause");
f0104460:	f3 90                	pause  
    // Uncomment the following line after completing exercise 13
    //"sti\n"
    "1:\n"
    "hlt\n"
    "jmp 1b\n"
    : : "a" (thiscpu->cpu_ts.ts_esp0));
f0104462:	e8 3c 17 00 00       	call   f0105ba3 <cpunum>
f0104467:	6b c0 74             	imul   $0x74,%eax,%eax
    asm volatile (
f010446a:	8b 80 30 50 23 f0    	mov    -0xfdcafd0(%eax),%eax
f0104470:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104475:	89 c4                	mov    %eax,%esp
f0104477:	6a 00                	push   $0x0
f0104479:	6a 00                	push   $0x0
f010447b:	f4                   	hlt    
f010447c:	eb fd                	jmp    f010447b <sched_halt+0xb7>
}
f010447e:	83 c4 10             	add    $0x10,%esp
f0104481:	c9                   	leave  
f0104482:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104483:	50                   	push   %eax
f0104484:	68 48 62 10 f0       	push   $0xf0106248
f0104489:	6a 54                	push   $0x54
f010448b:	68 19 83 10 f0       	push   $0xf0108319
f0104490:	e8 ab bb ff ff       	call   f0100040 <_panic>

f0104495 <sched_yield>:
sched_yield(void) {
f0104495:	55                   	push   %ebp
f0104496:	89 e5                	mov    %esp,%ebp
f0104498:	56                   	push   %esi
f0104499:	53                   	push   %ebx
    if (curenv != NULL) {
f010449a:	e8 04 17 00 00       	call   f0105ba3 <cpunum>
f010449f:	6b c0 74             	imul   $0x74,%eax,%eax
    envid_t cur = 0;
f01044a2:	b9 00 00 00 00       	mov    $0x0,%ecx
    if (curenv != NULL) {
f01044a7:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f01044ae:	74 17                	je     f01044c7 <sched_yield+0x32>
        cur = ENVX(curenv->env_id);
f01044b0:	e8 ee 16 00 00       	call   f0105ba3 <cpunum>
f01044b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01044b8:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01044be:	8b 48 48             	mov    0x48(%eax),%ecx
f01044c1:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
        if (envs[i % NENV].env_status == ENV_RUNNABLE) {
f01044c7:	8b 1d 4c 42 23 f0    	mov    0xf023424c,%ebx
    for (int i = cur; i < NENV + cur; i++) {
f01044cd:	89 ca                	mov    %ecx,%edx
f01044cf:	81 c1 00 04 00 00    	add    $0x400,%ecx
f01044d5:	39 d1                	cmp    %edx,%ecx
f01044d7:	7e 2b                	jle    f0104504 <sched_yield+0x6f>
        if (envs[i % NENV].env_status == ENV_RUNNABLE) {
f01044d9:	89 d6                	mov    %edx,%esi
f01044db:	c1 fe 1f             	sar    $0x1f,%esi
f01044de:	c1 ee 16             	shr    $0x16,%esi
f01044e1:	8d 04 32             	lea    (%edx,%esi,1),%eax
f01044e4:	25 ff 03 00 00       	and    $0x3ff,%eax
f01044e9:	29 f0                	sub    %esi,%eax
f01044eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
f01044ee:	01 d8                	add    %ebx,%eax
f01044f0:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01044f4:	74 05                	je     f01044fb <sched_yield+0x66>
    for (int i = cur; i < NENV + cur; i++) {
f01044f6:	83 c2 01             	add    $0x1,%edx
f01044f9:	eb da                	jmp    f01044d5 <sched_yield+0x40>
            env_run(&envs[i % NENV]);
f01044fb:	83 ec 0c             	sub    $0xc,%esp
f01044fe:	50                   	push   %eax
f01044ff:	e8 7b f3 ff ff       	call   f010387f <env_run>
    if (idle == NULL && curenv != NULL && curenv->env_status == ENV_RUNNING) {
f0104504:	e8 9a 16 00 00       	call   f0105ba3 <cpunum>
f0104509:	6b c0 74             	imul   $0x74,%eax,%eax
f010450c:	83 b8 28 50 23 f0 00 	cmpl   $0x0,-0xfdcafd8(%eax)
f0104513:	74 14                	je     f0104529 <sched_yield+0x94>
f0104515:	e8 89 16 00 00       	call   f0105ba3 <cpunum>
f010451a:	6b c0 74             	imul   $0x74,%eax,%eax
f010451d:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f0104523:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104527:	74 0c                	je     f0104535 <sched_yield+0xa0>
    sched_halt();
f0104529:	e8 96 fe ff ff       	call   f01043c4 <sched_halt>
}
f010452e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104531:	5b                   	pop    %ebx
f0104532:	5e                   	pop    %esi
f0104533:	5d                   	pop    %ebp
f0104534:	c3                   	ret    
        idle = curenv;
f0104535:	e8 69 16 00 00       	call   f0105ba3 <cpunum>
f010453a:	6b c0 74             	imul   $0x74,%eax,%eax
f010453d:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
    if (idle != NULL) {
f0104543:	85 c0                	test   %eax,%eax
f0104545:	74 e2                	je     f0104529 <sched_yield+0x94>
        env_run(idle);
f0104547:	83 ec 0c             	sub    $0xc,%esp
f010454a:	50                   	push   %eax
f010454b:	e8 2f f3 ff ff       	call   f010387f <env_run>

f0104550 <syscall>:
    return 0;
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5) {
f0104550:	55                   	push   %ebp
f0104551:	89 e5                	mov    %esp,%ebp
f0104553:	56                   	push   %esi
f0104554:	53                   	push   %ebx
f0104555:	83 ec 10             	sub    $0x10,%esp
f0104558:	8b 45 08             	mov    0x8(%ebp),%eax
    // Return any appropriate return value.
    // LAB 3: Your code here.

//	panic("syscall not implemented");

    switch (syscallno) {
f010455b:	83 f8 0a             	cmp    $0xa,%eax
f010455e:	0f 87 8a 04 00 00    	ja     f01049ee <syscall+0x49e>
f0104564:	ff 24 85 90 85 10 f0 	jmp    *-0xfef7a70(,%eax,4)
    user_mem_assert(curenv, s, len, PTE_U | PTE_P);
f010456b:	e8 33 16 00 00       	call   f0105ba3 <cpunum>
f0104570:	6a 05                	push   $0x5
f0104572:	ff 75 10             	pushl  0x10(%ebp)
f0104575:	ff 75 0c             	pushl  0xc(%ebp)
f0104578:	6b c0 74             	imul   $0x74,%eax,%eax
f010457b:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f0104581:	e8 ec eb ff ff       	call   f0103172 <user_mem_assert>
    cprintf("%.*s", len, s);
f0104586:	83 c4 0c             	add    $0xc,%esp
f0104589:	ff 75 0c             	pushl  0xc(%ebp)
f010458c:	ff 75 10             	pushl  0x10(%ebp)
f010458f:	68 26 83 10 f0       	push   $0xf0108326
f0104594:	e8 0c f5 ff ff       	call   f0103aa5 <cprintf>
f0104599:	83 c4 10             	add    $0x10,%esp
            return sys_env_set_pgfault_upcall(a1, (void *) a2);
        default:
            return -E_INVAL;
    }

    return 0;
f010459c:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01045a1:	89 d8                	mov    %ebx,%eax
f01045a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01045a6:	5b                   	pop    %ebx
f01045a7:	5e                   	pop    %esi
f01045a8:	5d                   	pop    %ebp
f01045a9:	c3                   	ret    
    return cons_getc();
f01045aa:	e8 4a c0 ff ff       	call   f01005f9 <cons_getc>
f01045af:	89 c3                	mov    %eax,%ebx
            return sys_cgetc();
f01045b1:	eb ee                	jmp    f01045a1 <syscall+0x51>
    return curenv->env_id;
f01045b3:	e8 eb 15 00 00       	call   f0105ba3 <cpunum>
f01045b8:	6b c0 74             	imul   $0x74,%eax,%eax
f01045bb:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f01045c1:	8b 58 48             	mov    0x48(%eax),%ebx
            return sys_getenvid();
f01045c4:	eb db                	jmp    f01045a1 <syscall+0x51>
    if ((r = envid2env(envid, &e, 1)) < 0)
f01045c6:	83 ec 04             	sub    $0x4,%esp
f01045c9:	6a 01                	push   $0x1
f01045cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01045ce:	50                   	push   %eax
f01045cf:	ff 75 0c             	pushl  0xc(%ebp)
f01045d2:	e8 56 ec ff ff       	call   f010322d <envid2env>
f01045d7:	89 c3                	mov    %eax,%ebx
f01045d9:	83 c4 10             	add    $0x10,%esp
f01045dc:	85 c0                	test   %eax,%eax
f01045de:	78 c1                	js     f01045a1 <syscall+0x51>
    env_destroy(e);
f01045e0:	83 ec 0c             	sub    $0xc,%esp
f01045e3:	ff 75 f4             	pushl  -0xc(%ebp)
f01045e6:	e8 0f f2 ff ff       	call   f01037fa <env_destroy>
f01045eb:	83 c4 10             	add    $0x10,%esp
    return 0;
f01045ee:	bb 00 00 00 00       	mov    $0x0,%ebx
            return sys_env_destroy(a1);
f01045f3:	eb ac                	jmp    f01045a1 <syscall+0x51>
    sched_yield();
f01045f5:	e8 9b fe ff ff       	call   f0104495 <sched_yield>
    if ((r = env_alloc(&e, curenv->env_id)) < 0) {
f01045fa:	e8 a4 15 00 00       	call   f0105ba3 <cpunum>
f01045ff:	83 ec 08             	sub    $0x8,%esp
f0104602:	6b c0 74             	imul   $0x74,%eax,%eax
f0104605:	8b 80 28 50 23 f0    	mov    -0xfdcafd8(%eax),%eax
f010460b:	ff 70 48             	pushl  0x48(%eax)
f010460e:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104611:	50                   	push   %eax
f0104612:	e8 1a ed ff ff       	call   f0103331 <env_alloc>
f0104617:	89 c3                	mov    %eax,%ebx
f0104619:	83 c4 10             	add    $0x10,%esp
f010461c:	85 c0                	test   %eax,%eax
f010461e:	78 3a                	js     f010465a <syscall+0x10a>
    e->env_status = ENV_NOT_RUNNABLE;
f0104620:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104623:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
    memcpy(&e->env_tf, &curenv->env_tf, sizeof(struct Trapframe));
f010462a:	e8 74 15 00 00       	call   f0105ba3 <cpunum>
f010462f:	83 ec 04             	sub    $0x4,%esp
f0104632:	6a 44                	push   $0x44
f0104634:	6b c0 74             	imul   $0x74,%eax,%eax
f0104637:	ff b0 28 50 23 f0    	pushl  -0xfdcafd8(%eax)
f010463d:	ff 75 f4             	pushl  -0xc(%ebp)
f0104640:	e8 f0 0f 00 00       	call   f0105635 <memcpy>
    e->env_tf.tf_regs.reg_eax = 0;
f0104645:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104648:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    return e->env_id;
f010464f:	8b 58 48             	mov    0x48(%eax),%ebx
f0104652:	83 c4 10             	add    $0x10,%esp
            return sys_exofork();
f0104655:	e9 47 ff ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_exofork() env_alloc error: %e\n", r);
f010465a:	83 ec 08             	sub    $0x8,%esp
f010465d:	50                   	push   %eax
f010465e:	68 2c 83 10 f0       	push   $0xf010832c
f0104663:	e8 3d f4 ff ff       	call   f0103aa5 <cprintf>
f0104668:	83 c4 10             	add    $0x10,%esp
f010466b:	e9 31 ff ff ff       	jmp    f01045a1 <syscall+0x51>
    if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) {
f0104670:	8b 45 10             	mov    0x10(%ebp),%eax
f0104673:	83 e8 02             	sub    $0x2,%eax
f0104676:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f010467b:	75 2e                	jne    f01046ab <syscall+0x15b>
    if ((r = envid2env(envid, &env, true)) < 0) {
f010467d:	83 ec 04             	sub    $0x4,%esp
f0104680:	6a 01                	push   $0x1
f0104682:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104685:	50                   	push   %eax
f0104686:	ff 75 0c             	pushl  0xc(%ebp)
f0104689:	e8 9f eb ff ff       	call   f010322d <envid2env>
f010468e:	89 c3                	mov    %eax,%ebx
f0104690:	83 c4 10             	add    $0x10,%esp
f0104693:	85 c0                	test   %eax,%eax
f0104695:	78 30                	js     f01046c7 <syscall+0x177>
    env->env_status = ENV_RUNNABLE;
f0104697:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010469a:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
    return 0;
f01046a1:	bb 00 00 00 00       	mov    $0x0,%ebx
            return sys_env_set_status(a1, a2);
f01046a6:	e9 f6 fe ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_env_set_status() status error:%e\n", -E_INVAL);
f01046ab:	83 ec 08             	sub    $0x8,%esp
f01046ae:	6a fd                	push   $0xfffffffd
f01046b0:	68 50 83 10 f0       	push   $0xf0108350
f01046b5:	e8 eb f3 ff ff       	call   f0103aa5 <cprintf>
f01046ba:	83 c4 10             	add    $0x10,%esp
        return -E_INVAL;
f01046bd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01046c2:	e9 da fe ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_env_set_status() envid2env error:%e\n", r);
f01046c7:	83 ec 08             	sub    $0x8,%esp
f01046ca:	50                   	push   %eax
f01046cb:	68 78 83 10 f0       	push   $0xf0108378
f01046d0:	e8 d0 f3 ff ff       	call   f0103aa5 <cprintf>
f01046d5:	83 c4 10             	add    $0x10,%esp
f01046d8:	e9 c4 fe ff ff       	jmp    f01045a1 <syscall+0x51>
    if ((r = envid2env(envid, &env, true)) < 0) {
f01046dd:	83 ec 04             	sub    $0x4,%esp
f01046e0:	6a 01                	push   $0x1
f01046e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01046e5:	50                   	push   %eax
f01046e6:	ff 75 0c             	pushl  0xc(%ebp)
f01046e9:	e8 3f eb ff ff       	call   f010322d <envid2env>
f01046ee:	89 c3                	mov    %eax,%ebx
f01046f0:	83 c4 10             	add    $0x10,%esp
f01046f3:	85 c0                	test   %eax,%eax
f01046f5:	0f 88 80 00 00 00    	js     f010477b <syscall+0x22b>
    if (((uintptr_t) va >= UTOP) || ((uintptr_t) va % PGSIZE != 0) || ((perm & (~PTE_SYSCALL)) != 0)) {
f01046fb:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104702:	0f 87 a3 00 00 00    	ja     f01047ab <syscall+0x25b>
f0104708:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010470f:	0f 85 a0 00 00 00    	jne    f01047b5 <syscall+0x265>
f0104715:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104718:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010471e:	0f 85 9b 00 00 00    	jne    f01047bf <syscall+0x26f>
    if ((pp = page_alloc(ALLOC_ZERO)) == NULL) {
f0104724:	83 ec 0c             	sub    $0xc,%esp
f0104727:	6a 01                	push   $0x1
f0104729:	e8 c8 c8 ff ff       	call   f0100ff6 <page_alloc>
f010472e:	89 c6                	mov    %eax,%esi
f0104730:	83 c4 10             	add    $0x10,%esp
f0104733:	85 c0                	test   %eax,%eax
f0104735:	74 5a                	je     f0104791 <syscall+0x241>
    if ((r = page_insert(env->env_pgdir, pp, va, PTE_U | perm)) < 0) {
f0104737:	8b 45 14             	mov    0x14(%ebp),%eax
f010473a:	83 c8 04             	or     $0x4,%eax
f010473d:	50                   	push   %eax
f010473e:	ff 75 10             	pushl  0x10(%ebp)
f0104741:	56                   	push   %esi
f0104742:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104745:	ff 70 60             	pushl  0x60(%eax)
f0104748:	e8 1e cb ff ff       	call   f010126b <page_insert>
f010474d:	83 c4 10             	add    $0x10,%esp
f0104750:	85 c0                	test   %eax,%eax
f0104752:	0f 89 49 fe ff ff    	jns    f01045a1 <syscall+0x51>
        cprintf("sys_page_alloc page_insert error:%e\n", r);
f0104758:	83 ec 08             	sub    $0x8,%esp
f010475b:	50                   	push   %eax
f010475c:	68 fc 83 10 f0       	push   $0xf01083fc
f0104761:	e8 3f f3 ff ff       	call   f0103aa5 <cprintf>
        page_free(pp);
f0104766:	89 34 24             	mov    %esi,(%esp)
f0104769:	e8 00 c9 ff ff       	call   f010106e <page_free>
f010476e:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f0104771:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f0104776:	e9 26 fe ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_page_alloc() envid2env error:%e\n", r);
f010477b:	83 ec 08             	sub    $0x8,%esp
f010477e:	50                   	push   %eax
f010477f:	68 a4 83 10 f0       	push   $0xf01083a4
f0104784:	e8 1c f3 ff ff       	call   f0103aa5 <cprintf>
f0104789:	83 c4 10             	add    $0x10,%esp
f010478c:	e9 10 fe ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_page_alloc page_alloc error: return NULL\n");
f0104791:	83 ec 0c             	sub    $0xc,%esp
f0104794:	68 cc 83 10 f0       	push   $0xf01083cc
f0104799:	e8 07 f3 ff ff       	call   f0103aa5 <cprintf>
f010479e:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01047a1:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01047a6:	e9 f6 fd ff ff       	jmp    f01045a1 <syscall+0x51>
        return -E_INVAL;
f01047ab:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047b0:	e9 ec fd ff ff       	jmp    f01045a1 <syscall+0x51>
f01047b5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047ba:	e9 e2 fd ff ff       	jmp    f01045a1 <syscall+0x51>
f01047bf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
            return sys_page_alloc(a1, (void *) a2, a3);
f01047c4:	e9 d8 fd ff ff       	jmp    f01045a1 <syscall+0x51>
    if ((r = envid2env(srcenvid, &srcEnv, true)) < 0) {
f01047c9:	83 ec 04             	sub    $0x4,%esp
f01047cc:	6a 01                	push   $0x1
f01047ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01047d1:	50                   	push   %eax
f01047d2:	ff 75 0c             	pushl  0xc(%ebp)
f01047d5:	e8 53 ea ff ff       	call   f010322d <envid2env>
f01047da:	89 c3                	mov    %eax,%ebx
f01047dc:	83 c4 10             	add    $0x10,%esp
f01047df:	85 c0                	test   %eax,%eax
f01047e1:	0f 88 c4 00 00 00    	js     f01048ab <syscall+0x35b>
    if ((r = envid2env(dstenvid, &dstEnv, true)) < 0) {
f01047e7:	83 ec 04             	sub    $0x4,%esp
f01047ea:	6a 01                	push   $0x1
f01047ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
f01047ef:	50                   	push   %eax
f01047f0:	ff 75 14             	pushl  0x14(%ebp)
f01047f3:	e8 35 ea ff ff       	call   f010322d <envid2env>
f01047f8:	89 c3                	mov    %eax,%ebx
f01047fa:	83 c4 10             	add    $0x10,%esp
f01047fd:	85 c0                	test   %eax,%eax
f01047ff:	0f 88 bc 00 00 00    	js     f01048c1 <syscall+0x371>
    if (((uintptr_t) srcva >= UTOP) || ((uintptr_t) dstva >= UTOP) || ((uintptr_t) srcva % PGSIZE != 0) ||
f0104805:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010480c:	0f 87 07 01 00 00    	ja     f0104919 <syscall+0x3c9>
f0104812:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104819:	0f 87 fa 00 00 00    	ja     f0104919 <syscall+0x3c9>
f010481f:	8b 45 10             	mov    0x10(%ebp),%eax
f0104822:	0b 45 18             	or     0x18(%ebp),%eax
f0104825:	a9 ff 0f 00 00       	test   $0xfff,%eax
f010482a:	0f 85 f3 00 00 00    	jne    f0104923 <syscall+0x3d3>
        ((uintptr_t) dstva % PGSIZE != 0) ||
f0104830:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
f0104833:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104839:	0f 85 ee 00 00 00    	jne    f010492d <syscall+0x3dd>
    if ((pp = page_lookup(srcEnv->env_pgdir, srcva, &pte_store)) == NULL) {
f010483f:	83 ec 04             	sub    $0x4,%esp
f0104842:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104845:	50                   	push   %eax
f0104846:	ff 75 10             	pushl  0x10(%ebp)
f0104849:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010484c:	ff 70 60             	pushl  0x60(%eax)
f010484f:	e8 7a c9 ff ff       	call   f01011ce <page_lookup>
f0104854:	83 c4 10             	add    $0x10,%esp
f0104857:	85 c0                	test   %eax,%eax
f0104859:	74 7c                	je     f01048d7 <syscall+0x387>
    if (((*pte_store & PTE_W) == 0) && ((perm & PTE_W) != 0)) {
f010485b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010485e:	8b 12                	mov    (%edx),%edx
f0104860:	f6 c2 02             	test   $0x2,%dl
f0104863:	75 0a                	jne    f010486f <syscall+0x31f>
f0104865:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104869:	0f 85 82 00 00 00    	jne    f01048f1 <syscall+0x3a1>
    if ((r = page_insert(dstEnv->env_pgdir, pp, dstva, perm | PTE_U)) < 0) {
f010486f:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0104872:	83 ca 04             	or     $0x4,%edx
f0104875:	52                   	push   %edx
f0104876:	ff 75 18             	pushl  0x18(%ebp)
f0104879:	50                   	push   %eax
f010487a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010487d:	ff 70 60             	pushl  0x60(%eax)
f0104880:	e8 e6 c9 ff ff       	call   f010126b <page_insert>
f0104885:	83 c4 10             	add    $0x10,%esp
f0104888:	85 c0                	test   %eax,%eax
f010488a:	0f 89 11 fd ff ff    	jns    f01045a1 <syscall+0x51>
        cprintf("sys_page_map() page_insert error:%e\n", r);
f0104890:	83 ec 08             	sub    $0x8,%esp
f0104893:	50                   	push   %eax
f0104894:	68 10 85 10 f0       	push   $0xf0108510
f0104899:	e8 07 f2 ff ff       	call   f0103aa5 <cprintf>
f010489e:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01048a1:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01048a6:	e9 f6 fc ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_page_map() envid2env(src) error:%e\n", r);
f01048ab:	83 ec 08             	sub    $0x8,%esp
f01048ae:	50                   	push   %eax
f01048af:	68 24 84 10 f0       	push   $0xf0108424
f01048b4:	e8 ec f1 ff ff       	call   f0103aa5 <cprintf>
f01048b9:	83 c4 10             	add    $0x10,%esp
f01048bc:	e9 e0 fc ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_page_map() envid2env(dst) error:%e\n", r);
f01048c1:	83 ec 08             	sub    $0x8,%esp
f01048c4:	50                   	push   %eax
f01048c5:	68 4c 84 10 f0       	push   $0xf010844c
f01048ca:	e8 d6 f1 ff ff       	call   f0103aa5 <cprintf>
f01048cf:	83 c4 10             	add    $0x10,%esp
f01048d2:	e9 ca fc ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_page_map() page_lookup error. return NULL\n");
f01048d7:	83 ec 0c             	sub    $0xc,%esp
f01048da:	68 74 84 10 f0       	push   $0xf0108474
f01048df:	e8 c1 f1 ff ff       	call   f0103aa5 <cprintf>
f01048e4:	83 c4 10             	add    $0x10,%esp
        return -E_INVAL;
f01048e7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048ec:	e9 b0 fc ff ff       	jmp    f01045a1 <syscall+0x51>
	return (pp - pages) << PGSHIFT;
f01048f1:	2b 05 94 4e 23 f0    	sub    0xf0234e94,%eax
f01048f7:	c1 f8 03             	sar    $0x3,%eax
f01048fa:	c1 e0 0c             	shl    $0xc,%eax
        cprintf("(perm & PTE_W), but srcva is read-only in srcenvid's address space.\tsrcva:0x%x\t*pte_store:0x%x\tpage:0x%x\n",
f01048fd:	50                   	push   %eax
f01048fe:	52                   	push   %edx
f01048ff:	ff 75 10             	pushl  0x10(%ebp)
f0104902:	68 a4 84 10 f0       	push   $0xf01084a4
f0104907:	e8 99 f1 ff ff       	call   f0103aa5 <cprintf>
f010490c:	83 c4 10             	add    $0x10,%esp
        return -E_INVAL;
f010490f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104914:	e9 88 fc ff ff       	jmp    f01045a1 <syscall+0x51>
        return -E_INVAL;
f0104919:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010491e:	e9 7e fc ff ff       	jmp    f01045a1 <syscall+0x51>
f0104923:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104928:	e9 74 fc ff ff       	jmp    f01045a1 <syscall+0x51>
f010492d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
            return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104932:	e9 6a fc ff ff       	jmp    f01045a1 <syscall+0x51>
    if ((r = envid2env(envid, &env, true)) < 0) {
f0104937:	83 ec 04             	sub    $0x4,%esp
f010493a:	6a 01                	push   $0x1
f010493c:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010493f:	50                   	push   %eax
f0104940:	ff 75 0c             	pushl  0xc(%ebp)
f0104943:	e8 e5 e8 ff ff       	call   f010322d <envid2env>
f0104948:	89 c3                	mov    %eax,%ebx
f010494a:	83 c4 10             	add    $0x10,%esp
f010494d:	85 c0                	test   %eax,%eax
f010494f:	78 30                	js     f0104981 <syscall+0x431>
    if (((uintptr_t) va >= UTOP) || ((uintptr_t) va % PGSIZE != 0)) {
f0104951:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104958:	77 3d                	ja     f0104997 <syscall+0x447>
f010495a:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104961:	75 3e                	jne    f01049a1 <syscall+0x451>
    page_remove(env->env_pgdir, va);
f0104963:	83 ec 08             	sub    $0x8,%esp
f0104966:	ff 75 10             	pushl  0x10(%ebp)
f0104969:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010496c:	ff 70 60             	pushl  0x60(%eax)
f010496f:	e8 b4 c8 ff ff       	call   f0101228 <page_remove>
f0104974:	83 c4 10             	add    $0x10,%esp
    return 0;
f0104977:	bb 00 00 00 00       	mov    $0x0,%ebx
f010497c:	e9 20 fc ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_page_unmap() envid2env error:%e\n", r);
f0104981:	83 ec 08             	sub    $0x8,%esp
f0104984:	50                   	push   %eax
f0104985:	68 38 85 10 f0       	push   $0xf0108538
f010498a:	e8 16 f1 ff ff       	call   f0103aa5 <cprintf>
f010498f:	83 c4 10             	add    $0x10,%esp
f0104992:	e9 0a fc ff ff       	jmp    f01045a1 <syscall+0x51>
        return -E_INVAL;
f0104997:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010499c:	e9 00 fc ff ff       	jmp    f01045a1 <syscall+0x51>
f01049a1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
            return sys_page_unmap(a1, (void *) a2);
f01049a6:	e9 f6 fb ff ff       	jmp    f01045a1 <syscall+0x51>
    if ((r = envid2env(envid, &env, true)) < 0) {
f01049ab:	83 ec 04             	sub    $0x4,%esp
f01049ae:	6a 01                	push   $0x1
f01049b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01049b3:	50                   	push   %eax
f01049b4:	ff 75 0c             	pushl  0xc(%ebp)
f01049b7:	e8 71 e8 ff ff       	call   f010322d <envid2env>
f01049bc:	89 c3                	mov    %eax,%ebx
f01049be:	83 c4 10             	add    $0x10,%esp
f01049c1:	85 c0                	test   %eax,%eax
f01049c3:	78 13                	js     f01049d8 <syscall+0x488>
    env->env_pgfault_upcall = func;
f01049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01049c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01049cb:	89 48 64             	mov    %ecx,0x64(%eax)
    return 0;
f01049ce:	bb 00 00 00 00       	mov    $0x0,%ebx
            return sys_env_set_pgfault_upcall(a1, (void *) a2);
f01049d3:	e9 c9 fb ff ff       	jmp    f01045a1 <syscall+0x51>
        cprintf("sys_env_set_pgfault_upcall() envid2env error:%e", r);
f01049d8:	83 ec 08             	sub    $0x8,%esp
f01049db:	50                   	push   %eax
f01049dc:	68 60 85 10 f0       	push   $0xf0108560
f01049e1:	e8 bf f0 ff ff       	call   f0103aa5 <cprintf>
f01049e6:	83 c4 10             	add    $0x10,%esp
f01049e9:	e9 b3 fb ff ff       	jmp    f01045a1 <syscall+0x51>
            return -E_INVAL;
f01049ee:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049f3:	e9 a9 fb ff ff       	jmp    f01045a1 <syscall+0x51>

f01049f8 <stab_binsearch>:
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr) {
f01049f8:	55                   	push   %ebp
f01049f9:	89 e5                	mov    %esp,%ebp
f01049fb:	57                   	push   %edi
f01049fc:	56                   	push   %esi
f01049fd:	53                   	push   %ebx
f01049fe:	83 ec 14             	sub    $0x14,%esp
f0104a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104a04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104a07:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104a0a:	8b 7d 08             	mov    0x8(%ebp),%edi
    int l = *region_left, r = *region_right, any_matches = 0;
f0104a0d:	8b 32                	mov    (%edx),%esi
f0104a0f:	8b 01                	mov    (%ecx),%eax
f0104a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104a14:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    while (l <= r) {
f0104a1b:	eb 2f                	jmp    f0104a4c <stab_binsearch+0x54>
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
f0104a1d:	83 e8 01             	sub    $0x1,%eax
        while (m >= l && stabs[m].n_type != type)
f0104a20:	39 c6                	cmp    %eax,%esi
f0104a22:	7f 49                	jg     f0104a6d <stab_binsearch+0x75>
f0104a24:	0f b6 0a             	movzbl (%edx),%ecx
f0104a27:	83 ea 0c             	sub    $0xc,%edx
f0104a2a:	39 f9                	cmp    %edi,%ecx
f0104a2c:	75 ef                	jne    f0104a1d <stab_binsearch+0x25>
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
f0104a2e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104a31:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104a34:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104a38:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104a3b:	73 35                	jae    f0104a72 <stab_binsearch+0x7a>
            *region_left = m;
f0104a3d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a40:	89 06                	mov    %eax,(%esi)
            l = true_m + 1;
f0104a42:	8d 73 01             	lea    0x1(%ebx),%esi
        any_matches = 1;
f0104a45:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while (l <= r) {
f0104a4c:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104a4f:	7f 4e                	jg     f0104a9f <stab_binsearch+0xa7>
        int true_m = (l + r) / 2, m = true_m;
f0104a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104a54:	01 f0                	add    %esi,%eax
f0104a56:	89 c3                	mov    %eax,%ebx
f0104a58:	c1 eb 1f             	shr    $0x1f,%ebx
f0104a5b:	01 c3                	add    %eax,%ebx
f0104a5d:	d1 fb                	sar    %ebx
f0104a5f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104a62:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104a65:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104a69:	89 d8                	mov    %ebx,%eax
        while (m >= l && stabs[m].n_type != type)
f0104a6b:	eb b3                	jmp    f0104a20 <stab_binsearch+0x28>
            l = true_m + 1;
f0104a6d:	8d 73 01             	lea    0x1(%ebx),%esi
            continue;
f0104a70:	eb da                	jmp    f0104a4c <stab_binsearch+0x54>
        } else if (stabs[m].n_value > addr) {
f0104a72:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104a75:	76 14                	jbe    f0104a8b <stab_binsearch+0x93>
            *region_right = m - 1;
f0104a77:	83 e8 01             	sub    $0x1,%eax
f0104a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104a7d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104a80:	89 03                	mov    %eax,(%ebx)
        any_matches = 1;
f0104a82:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104a89:	eb c1                	jmp    f0104a4c <stab_binsearch+0x54>
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
f0104a8b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a8e:	89 06                	mov    %eax,(%esi)
            l = m;
            addr++;
f0104a90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104a94:	89 c6                	mov    %eax,%esi
        any_matches = 1;
f0104a96:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104a9d:	eb ad                	jmp    f0104a4c <stab_binsearch+0x54>
        }
    }

    if (!any_matches)
f0104a9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104aa3:	74 16                	je     f0104abb <stab_binsearch+0xc3>
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
f0104aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104aa8:	8b 00                	mov    (%eax),%eax
             l > *region_left && stabs[l].n_type != type;
f0104aaa:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104aad:	8b 0e                	mov    (%esi),%ecx
f0104aaf:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104ab2:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104ab5:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
        for (l = *region_right;
f0104ab9:	eb 12                	jmp    f0104acd <stab_binsearch+0xd5>
        *region_right = *region_left - 1;
f0104abb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104abe:	8b 00                	mov    (%eax),%eax
f0104ac0:	83 e8 01             	sub    $0x1,%eax
f0104ac3:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104ac6:	89 07                	mov    %eax,(%edi)
f0104ac8:	eb 16                	jmp    f0104ae0 <stab_binsearch+0xe8>
             l--)
f0104aca:	83 e8 01             	sub    $0x1,%eax
        for (l = *region_right;
f0104acd:	39 c1                	cmp    %eax,%ecx
f0104acf:	7d 0a                	jge    f0104adb <stab_binsearch+0xe3>
             l > *region_left && stabs[l].n_type != type;
f0104ad1:	0f b6 1a             	movzbl (%edx),%ebx
f0104ad4:	83 ea 0c             	sub    $0xc,%edx
f0104ad7:	39 fb                	cmp    %edi,%ebx
f0104ad9:	75 ef                	jne    f0104aca <stab_binsearch+0xd2>
            /* do nothing */;
        *region_left = l;
f0104adb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ade:	89 07                	mov    %eax,(%edi)
    }
}
f0104ae0:	83 c4 14             	add    $0x14,%esp
f0104ae3:	5b                   	pop    %ebx
f0104ae4:	5e                   	pop    %esi
f0104ae5:	5f                   	pop    %edi
f0104ae6:	5d                   	pop    %ebp
f0104ae7:	c3                   	ret    

f0104ae8 <debuginfo_eip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info) {
f0104ae8:	55                   	push   %ebp
f0104ae9:	89 e5                	mov    %esp,%ebp
f0104aeb:	57                   	push   %edi
f0104aec:	56                   	push   %esi
f0104aed:	53                   	push   %ebx
f0104aee:	83 ec 3c             	sub    $0x3c,%esp
f0104af1:	8b 75 08             	mov    0x8(%ebp),%esi
f0104af4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    const struct Stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->eip_file = "<unknown>";
f0104af7:	c7 03 bc 85 10 f0    	movl   $0xf01085bc,(%ebx)
    info->eip_line = 0;
f0104afd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    info->eip_fn_name = "<unknown>";
f0104b04:	c7 43 08 bc 85 10 f0 	movl   $0xf01085bc,0x8(%ebx)
    info->eip_fn_namelen = 9;
f0104b0b:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
    info->eip_fn_addr = addr;
f0104b12:	89 73 10             	mov    %esi,0x10(%ebx)
    info->eip_fn_narg = 0;
f0104b15:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

    // Find the relevant set of stabs
    if (addr >= ULIM) {
f0104b1c:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0104b22:	0f 86 2a 01 00 00    	jbe    f0104c52 <debuginfo_eip+0x16a>
        // Can't search for user-level addresses yet!
        panic("User address");
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104b28:	b8 1c 7b 11 f0       	mov    $0xf0117b1c,%eax
f0104b2d:	3d 45 43 11 f0       	cmp    $0xf0114345,%eax
f0104b32:	0f 86 b9 01 00 00    	jbe    f0104cf1 <debuginfo_eip+0x209>
f0104b38:	80 3d 1b 7b 11 f0 00 	cmpb   $0x0,0xf0117b1b
f0104b3f:	0f 85 b3 01 00 00    	jne    f0104cf8 <debuginfo_eip+0x210>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
f0104b45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    rfile = (stab_end - stabs) - 1;
f0104b4c:	b8 44 43 11 f0       	mov    $0xf0114344,%eax
f0104b51:	2d c4 8a 10 f0       	sub    $0xf0108ac4,%eax
f0104b56:	c1 f8 02             	sar    $0x2,%eax
f0104b59:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104b5f:	83 e8 01             	sub    $0x1,%eax
f0104b62:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104b65:	83 ec 08             	sub    $0x8,%esp
f0104b68:	56                   	push   %esi
f0104b69:	6a 64                	push   $0x64
f0104b6b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0104b6e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104b71:	b8 c4 8a 10 f0       	mov    $0xf0108ac4,%eax
f0104b76:	e8 7d fe ff ff       	call   f01049f8 <stab_binsearch>
    if (lfile == 0)
f0104b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b7e:	83 c4 10             	add    $0x10,%esp
f0104b81:	85 c0                	test   %eax,%eax
f0104b83:	0f 84 76 01 00 00    	je     f0104cff <debuginfo_eip+0x217>
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
f0104b89:	89 45 dc             	mov    %eax,-0x24(%ebp)
    rfun = rfile;
f0104b8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104b92:	83 ec 08             	sub    $0x8,%esp
f0104b95:	56                   	push   %esi
f0104b96:	6a 24                	push   $0x24
f0104b98:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0104b9b:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104b9e:	b8 c4 8a 10 f0       	mov    $0xf0108ac4,%eax
f0104ba3:	e8 50 fe ff ff       	call   f01049f8 <stab_binsearch>

    if (lfun <= rfun) {
f0104ba8:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104bab:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104bae:	83 c4 10             	add    $0x10,%esp
f0104bb1:	39 d0                	cmp    %edx,%eax
f0104bb3:	0f 8f ad 00 00 00    	jg     f0104c66 <debuginfo_eip+0x17e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104bb9:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104bbc:	c1 e1 02             	shl    $0x2,%ecx
f0104bbf:	8d b9 c4 8a 10 f0    	lea    -0xfef753c(%ecx),%edi
f0104bc5:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0104bc8:	8b b9 c4 8a 10 f0    	mov    -0xfef753c(%ecx),%edi
f0104bce:	b9 1c 7b 11 f0       	mov    $0xf0117b1c,%ecx
f0104bd3:	81 e9 45 43 11 f0    	sub    $0xf0114345,%ecx
f0104bd9:	39 cf                	cmp    %ecx,%edi
f0104bdb:	73 09                	jae    f0104be6 <debuginfo_eip+0xfe>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104bdd:	81 c7 45 43 11 f0    	add    $0xf0114345,%edi
f0104be3:	89 7b 08             	mov    %edi,0x8(%ebx)
        info->eip_fn_addr = stabs[lfun].n_value;
f0104be6:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104be9:	8b 4f 08             	mov    0x8(%edi),%ecx
f0104bec:	89 4b 10             	mov    %ecx,0x10(%ebx)
        addr -= info->eip_fn_addr;
f0104bef:	29 ce                	sub    %ecx,%esi
        // Search within the function definition for the line number.
        lline = lfun;
f0104bf1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
f0104bf4:	89 55 d0             	mov    %edx,-0x30(%ebp)
        info->eip_fn_addr = addr;
        lline = lfile;
        rline = rfile;
    }
    // Ignore stuff after the colon.
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104bf7:	83 ec 08             	sub    $0x8,%esp
f0104bfa:	6a 3a                	push   $0x3a
f0104bfc:	ff 73 08             	pushl  0x8(%ebx)
f0104bff:	e8 60 09 00 00       	call   f0105564 <strfind>
f0104c04:	2b 43 08             	sub    0x8(%ebx),%eax
f0104c07:	89 43 0c             	mov    %eax,0xc(%ebx)
    // Hint:
    //	There's a particular stabs type used for line numbers.
    //	Look at the STABS documentation and <inc/stab.h> to find
    //	which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, info->eip_fn_addr + addr);
f0104c0a:	83 c4 08             	add    $0x8,%esp
f0104c0d:	03 73 10             	add    0x10(%ebx),%esi
f0104c10:	56                   	push   %esi
f0104c11:	6a 44                	push   $0x44
f0104c13:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104c16:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104c19:	b8 c4 8a 10 f0       	mov    $0xf0108ac4,%eax
f0104c1e:	e8 d5 fd ff ff       	call   f01049f8 <stab_binsearch>
    info->eip_line = lline > rline ? -1 : stabs[lline].n_desc;
f0104c23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104c26:	83 c4 10             	add    $0x10,%esp
f0104c29:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104c2e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0104c31:	7f 0b                	jg     f0104c3e <debuginfo_eip+0x156>
f0104c33:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104c36:	0f b7 14 95 ca 8a 10 	movzwl -0xfef7536(,%edx,4),%edx
f0104c3d:	f0 
f0104c3e:	89 53 04             	mov    %edx,0x4(%ebx)
    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
f0104c41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c44:	89 c2                	mov    %eax,%edx
f0104c46:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104c49:	8d 04 85 c8 8a 10 f0 	lea    -0xfef7538(,%eax,4),%eax
f0104c50:	eb 2b                	jmp    f0104c7d <debuginfo_eip+0x195>
        panic("User address");
f0104c52:	83 ec 04             	sub    $0x4,%esp
f0104c55:	68 c6 85 10 f0       	push   $0xf01085c6
f0104c5a:	6a 7d                	push   $0x7d
f0104c5c:	68 d3 85 10 f0       	push   $0xf01085d3
f0104c61:	e8 da b3 ff ff       	call   f0100040 <_panic>
        info->eip_fn_addr = addr;
f0104c66:	89 73 10             	mov    %esi,0x10(%ebx)
        lline = lfile;
f0104c69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c6c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
f0104c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c72:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104c75:	eb 80                	jmp    f0104bf7 <debuginfo_eip+0x10f>
f0104c77:	83 ea 01             	sub    $0x1,%edx
f0104c7a:	83 e8 0c             	sub    $0xc,%eax
    while (lline >= lfile
f0104c7d:	39 d7                	cmp    %edx,%edi
f0104c7f:	7f 33                	jg     f0104cb4 <debuginfo_eip+0x1cc>
           && stabs[lline].n_type != N_SOL
f0104c81:	0f b6 08             	movzbl (%eax),%ecx
f0104c84:	80 f9 84             	cmp    $0x84,%cl
f0104c87:	74 0b                	je     f0104c94 <debuginfo_eip+0x1ac>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104c89:	80 f9 64             	cmp    $0x64,%cl
f0104c8c:	75 e9                	jne    f0104c77 <debuginfo_eip+0x18f>
f0104c8e:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0104c92:	74 e3                	je     f0104c77 <debuginfo_eip+0x18f>
        lline--;
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104c94:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104c97:	8b 14 85 c4 8a 10 f0 	mov    -0xfef753c(,%eax,4),%edx
f0104c9e:	b8 1c 7b 11 f0       	mov    $0xf0117b1c,%eax
f0104ca3:	2d 45 43 11 f0       	sub    $0xf0114345,%eax
f0104ca8:	39 c2                	cmp    %eax,%edx
f0104caa:	73 08                	jae    f0104cb4 <debuginfo_eip+0x1cc>
        info->eip_file = stabstr + stabs[lline].n_strx;
f0104cac:	81 c2 45 43 11 f0    	add    $0xf0114345,%edx
f0104cb2:	89 13                	mov    %edx,(%ebx)


    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
f0104cb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104cb7:	8b 75 d8             	mov    -0x28(%ebp),%esi
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
            info->eip_fn_narg++;

    return 0;
f0104cba:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lfun < rfun)
f0104cbf:	39 f2                	cmp    %esi,%edx
f0104cc1:	7d 48                	jge    f0104d0b <debuginfo_eip+0x223>
        for (lline = lfun + 1;
f0104cc3:	83 c2 01             	add    $0x1,%edx
f0104cc6:	89 d0                	mov    %edx,%eax
f0104cc8:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104ccb:	8d 14 95 c8 8a 10 f0 	lea    -0xfef7538(,%edx,4),%edx
f0104cd2:	eb 04                	jmp    f0104cd8 <debuginfo_eip+0x1f0>
            info->eip_fn_narg++;
f0104cd4:	83 43 14 01          	addl   $0x1,0x14(%ebx)
        for (lline = lfun + 1;
f0104cd8:	39 c6                	cmp    %eax,%esi
f0104cda:	7e 2a                	jle    f0104d06 <debuginfo_eip+0x21e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
f0104cdc:	0f b6 0a             	movzbl (%edx),%ecx
f0104cdf:	83 c0 01             	add    $0x1,%eax
f0104ce2:	83 c2 0c             	add    $0xc,%edx
f0104ce5:	80 f9 a0             	cmp    $0xa0,%cl
f0104ce8:	74 ea                	je     f0104cd4 <debuginfo_eip+0x1ec>
    return 0;
f0104cea:	b8 00 00 00 00       	mov    $0x0,%eax
f0104cef:	eb 1a                	jmp    f0104d0b <debuginfo_eip+0x223>
        return -1;
f0104cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104cf6:	eb 13                	jmp    f0104d0b <debuginfo_eip+0x223>
f0104cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104cfd:	eb 0c                	jmp    f0104d0b <debuginfo_eip+0x223>
        return -1;
f0104cff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d04:	eb 05                	jmp    f0104d0b <debuginfo_eip+0x223>
    return 0;
f0104d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104d0e:	5b                   	pop    %ebx
f0104d0f:	5e                   	pop    %esi
f0104d10:	5f                   	pop    %edi
f0104d11:	5d                   	pop    %ebp
f0104d12:	c3                   	ret    

f0104d13 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104d13:	55                   	push   %ebp
f0104d14:	89 e5                	mov    %esp,%ebp
f0104d16:	57                   	push   %edi
f0104d17:	56                   	push   %esi
f0104d18:	53                   	push   %ebx
f0104d19:	83 ec 1c             	sub    $0x1c,%esp
f0104d1c:	89 c7                	mov    %eax,%edi
f0104d1e:	89 d6                	mov    %edx,%esi
f0104d20:	8b 45 08             	mov    0x8(%ebp),%eax
f0104d23:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104d26:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104d29:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
f0104d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d34:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104d37:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104d3a:	39 d3                	cmp    %edx,%ebx
f0104d3c:	72 05                	jb     f0104d43 <printnum+0x30>
f0104d3e:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104d41:	77 7a                	ja     f0104dbd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104d43:	83 ec 0c             	sub    $0xc,%esp
f0104d46:	ff 75 18             	pushl  0x18(%ebp)
f0104d49:	8b 45 14             	mov    0x14(%ebp),%eax
f0104d4c:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104d4f:	53                   	push   %ebx
f0104d50:	ff 75 10             	pushl  0x10(%ebp)
f0104d53:	83 ec 08             	sub    $0x8,%esp
f0104d56:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104d59:	ff 75 e0             	pushl  -0x20(%ebp)
f0104d5c:	ff 75 dc             	pushl  -0x24(%ebp)
f0104d5f:	ff 75 d8             	pushl  -0x28(%ebp)
f0104d62:	e8 49 12 00 00       	call   f0105fb0 <__udivdi3>
f0104d67:	83 c4 18             	add    $0x18,%esp
f0104d6a:	52                   	push   %edx
f0104d6b:	50                   	push   %eax
f0104d6c:	89 f2                	mov    %esi,%edx
f0104d6e:	89 f8                	mov    %edi,%eax
f0104d70:	e8 9e ff ff ff       	call   f0104d13 <printnum>
f0104d75:	83 c4 20             	add    $0x20,%esp
f0104d78:	eb 13                	jmp    f0104d8d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104d7a:	83 ec 08             	sub    $0x8,%esp
f0104d7d:	56                   	push   %esi
f0104d7e:	ff 75 18             	pushl  0x18(%ebp)
f0104d81:	ff d7                	call   *%edi
f0104d83:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104d86:	83 eb 01             	sub    $0x1,%ebx
f0104d89:	85 db                	test   %ebx,%ebx
f0104d8b:	7f ed                	jg     f0104d7a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104d8d:	83 ec 08             	sub    $0x8,%esp
f0104d90:	56                   	push   %esi
f0104d91:	83 ec 04             	sub    $0x4,%esp
f0104d94:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104d97:	ff 75 e0             	pushl  -0x20(%ebp)
f0104d9a:	ff 75 dc             	pushl  -0x24(%ebp)
f0104d9d:	ff 75 d8             	pushl  -0x28(%ebp)
f0104da0:	e8 2b 13 00 00       	call   f01060d0 <__umoddi3>
f0104da5:	83 c4 14             	add    $0x14,%esp
f0104da8:	0f be 80 e1 85 10 f0 	movsbl -0xfef7a1f(%eax),%eax
f0104daf:	50                   	push   %eax
f0104db0:	ff d7                	call   *%edi
}
f0104db2:	83 c4 10             	add    $0x10,%esp
f0104db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104db8:	5b                   	pop    %ebx
f0104db9:	5e                   	pop    %esi
f0104dba:	5f                   	pop    %edi
f0104dbb:	5d                   	pop    %ebp
f0104dbc:	c3                   	ret    
f0104dbd:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104dc0:	eb c4                	jmp    f0104d86 <printnum+0x73>

f0104dc2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0104dc2:	55                   	push   %ebp
f0104dc3:	89 e5                	mov    %esp,%ebp
f0104dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104dc8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104dcc:	8b 10                	mov    (%eax),%edx
f0104dce:	3b 50 04             	cmp    0x4(%eax),%edx
f0104dd1:	73 0a                	jae    f0104ddd <sprintputch+0x1b>
		*b->buf++ = ch;
f0104dd3:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104dd6:	89 08                	mov    %ecx,(%eax)
f0104dd8:	8b 45 08             	mov    0x8(%ebp),%eax
f0104ddb:	88 02                	mov    %al,(%edx)
}
f0104ddd:	5d                   	pop    %ebp
f0104dde:	c3                   	ret    

f0104ddf <printfmt>:
{
f0104ddf:	55                   	push   %ebp
f0104de0:	89 e5                	mov    %esp,%ebp
f0104de2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0104de5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104de8:	50                   	push   %eax
f0104de9:	ff 75 10             	pushl  0x10(%ebp)
f0104dec:	ff 75 0c             	pushl  0xc(%ebp)
f0104def:	ff 75 08             	pushl  0x8(%ebp)
f0104df2:	e8 05 00 00 00       	call   f0104dfc <vprintfmt>
}
f0104df7:	83 c4 10             	add    $0x10,%esp
f0104dfa:	c9                   	leave  
f0104dfb:	c3                   	ret    

f0104dfc <vprintfmt>:
{
f0104dfc:	55                   	push   %ebp
f0104dfd:	89 e5                	mov    %esp,%ebp
f0104dff:	57                   	push   %edi
f0104e00:	56                   	push   %esi
f0104e01:	53                   	push   %ebx
f0104e02:	83 ec 2c             	sub    $0x2c,%esp
f0104e05:	8b 75 08             	mov    0x8(%ebp),%esi
f0104e08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104e0b:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104e0e:	e9 00 04 00 00       	jmp    f0105213 <vprintfmt+0x417>
		padc = ' ';
f0104e13:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0104e17:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104e1e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f0104e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0104e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104e31:	8d 47 01             	lea    0x1(%edi),%eax
f0104e34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104e37:	0f b6 17             	movzbl (%edi),%edx
f0104e3a:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104e3d:	3c 55                	cmp    $0x55,%al
f0104e3f:	0f 87 51 04 00 00    	ja     f0105296 <vprintfmt+0x49a>
f0104e45:	0f b6 c0             	movzbl %al,%eax
f0104e48:	ff 24 85 a0 86 10 f0 	jmp    *-0xfef7960(,%eax,4)
f0104e4f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0104e52:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0104e56:	eb d9                	jmp    f0104e31 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104e58:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0104e5b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104e5f:	eb d0                	jmp    f0104e31 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104e61:	0f b6 d2             	movzbl %dl,%edx
f0104e64:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104e67:	b8 00 00 00 00       	mov    $0x0,%eax
f0104e6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0104e6f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104e72:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104e76:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104e79:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104e7c:	83 f9 09             	cmp    $0x9,%ecx
f0104e7f:	77 55                	ja     f0104ed6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f0104e81:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0104e84:	eb e9                	jmp    f0104e6f <vprintfmt+0x73>
			precision = va_arg(ap, int);
f0104e86:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e89:	8b 00                	mov    (%eax),%eax
f0104e8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104e8e:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e91:	8d 40 04             	lea    0x4(%eax),%eax
f0104e94:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104e97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0104e9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104e9e:	79 91                	jns    f0104e31 <vprintfmt+0x35>
				width = precision, precision = -1;
f0104ea0:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104ea3:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104ea6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0104ead:	eb 82                	jmp    f0104e31 <vprintfmt+0x35>
f0104eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104eb2:	85 c0                	test   %eax,%eax
f0104eb4:	ba 00 00 00 00       	mov    $0x0,%edx
f0104eb9:	0f 49 d0             	cmovns %eax,%edx
f0104ebc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104ebf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ec2:	e9 6a ff ff ff       	jmp    f0104e31 <vprintfmt+0x35>
f0104ec7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0104eca:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0104ed1:	e9 5b ff ff ff       	jmp    f0104e31 <vprintfmt+0x35>
f0104ed6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0104ed9:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104edc:	eb bc                	jmp    f0104e9a <vprintfmt+0x9e>
			lflag++;
f0104ede:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104ee1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0104ee4:	e9 48 ff ff ff       	jmp    f0104e31 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f0104ee9:	8b 45 14             	mov    0x14(%ebp),%eax
f0104eec:	8d 78 04             	lea    0x4(%eax),%edi
f0104eef:	83 ec 08             	sub    $0x8,%esp
f0104ef2:	53                   	push   %ebx
f0104ef3:	ff 30                	pushl  (%eax)
f0104ef5:	ff d6                	call   *%esi
			break;
f0104ef7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104efa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0104efd:	e9 0e 03 00 00       	jmp    f0105210 <vprintfmt+0x414>
			err = va_arg(ap, int);
f0104f02:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f05:	8d 78 04             	lea    0x4(%eax),%edi
f0104f08:	8b 00                	mov    (%eax),%eax
f0104f0a:	99                   	cltd   
f0104f0b:	31 d0                	xor    %edx,%eax
f0104f0d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104f0f:	83 f8 08             	cmp    $0x8,%eax
f0104f12:	7f 23                	jg     f0104f37 <vprintfmt+0x13b>
f0104f14:	8b 14 85 00 88 10 f0 	mov    -0xfef7800(,%eax,4),%edx
f0104f1b:	85 d2                	test   %edx,%edx
f0104f1d:	74 18                	je     f0104f37 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f0104f1f:	52                   	push   %edx
f0104f20:	68 f3 75 10 f0       	push   $0xf01075f3
f0104f25:	53                   	push   %ebx
f0104f26:	56                   	push   %esi
f0104f27:	e8 b3 fe ff ff       	call   f0104ddf <printfmt>
f0104f2c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104f2f:	89 7d 14             	mov    %edi,0x14(%ebp)
f0104f32:	e9 d9 02 00 00       	jmp    f0105210 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
f0104f37:	50                   	push   %eax
f0104f38:	68 f9 85 10 f0       	push   $0xf01085f9
f0104f3d:	53                   	push   %ebx
f0104f3e:	56                   	push   %esi
f0104f3f:	e8 9b fe ff ff       	call   f0104ddf <printfmt>
f0104f44:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104f47:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104f4a:	e9 c1 02 00 00       	jmp    f0105210 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
f0104f4f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f52:	83 c0 04             	add    $0x4,%eax
f0104f55:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0104f58:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f5b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0104f5d:	85 ff                	test   %edi,%edi
f0104f5f:	b8 f2 85 10 f0       	mov    $0xf01085f2,%eax
f0104f64:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0104f67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104f6b:	0f 8e bd 00 00 00    	jle    f010502e <vprintfmt+0x232>
f0104f71:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f0104f75:	75 0e                	jne    f0104f85 <vprintfmt+0x189>
f0104f77:	89 75 08             	mov    %esi,0x8(%ebp)
f0104f7a:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0104f7d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0104f80:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104f83:	eb 6d                	jmp    f0104ff2 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104f85:	83 ec 08             	sub    $0x8,%esp
f0104f88:	ff 75 d0             	pushl  -0x30(%ebp)
f0104f8b:	57                   	push   %edi
f0104f8c:	e8 8f 04 00 00       	call   f0105420 <strnlen>
f0104f91:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104f94:	29 c1                	sub    %eax,%ecx
f0104f96:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0104f99:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0104f9c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0104fa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104fa3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104fa6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104fa8:	eb 0f                	jmp    f0104fb9 <vprintfmt+0x1bd>
					putch(padc, putdat);
f0104faa:	83 ec 08             	sub    $0x8,%esp
f0104fad:	53                   	push   %ebx
f0104fae:	ff 75 e0             	pushl  -0x20(%ebp)
f0104fb1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0104fb3:	83 ef 01             	sub    $0x1,%edi
f0104fb6:	83 c4 10             	add    $0x10,%esp
f0104fb9:	85 ff                	test   %edi,%edi
f0104fbb:	7f ed                	jg     f0104faa <vprintfmt+0x1ae>
f0104fbd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104fc0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0104fc3:	85 c9                	test   %ecx,%ecx
f0104fc5:	b8 00 00 00 00       	mov    $0x0,%eax
f0104fca:	0f 49 c1             	cmovns %ecx,%eax
f0104fcd:	29 c1                	sub    %eax,%ecx
f0104fcf:	89 75 08             	mov    %esi,0x8(%ebp)
f0104fd2:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0104fd5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0104fd8:	89 cb                	mov    %ecx,%ebx
f0104fda:	eb 16                	jmp    f0104ff2 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f0104fdc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0104fe0:	75 31                	jne    f0105013 <vprintfmt+0x217>
					putch(ch, putdat);
f0104fe2:	83 ec 08             	sub    $0x8,%esp
f0104fe5:	ff 75 0c             	pushl  0xc(%ebp)
f0104fe8:	50                   	push   %eax
f0104fe9:	ff 55 08             	call   *0x8(%ebp)
f0104fec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104fef:	83 eb 01             	sub    $0x1,%ebx
f0104ff2:	83 c7 01             	add    $0x1,%edi
f0104ff5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0104ff9:	0f be c2             	movsbl %dl,%eax
f0104ffc:	85 c0                	test   %eax,%eax
f0104ffe:	74 59                	je     f0105059 <vprintfmt+0x25d>
f0105000:	85 f6                	test   %esi,%esi
f0105002:	78 d8                	js     f0104fdc <vprintfmt+0x1e0>
f0105004:	83 ee 01             	sub    $0x1,%esi
f0105007:	79 d3                	jns    f0104fdc <vprintfmt+0x1e0>
f0105009:	89 df                	mov    %ebx,%edi
f010500b:	8b 75 08             	mov    0x8(%ebp),%esi
f010500e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105011:	eb 37                	jmp    f010504a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f0105013:	0f be d2             	movsbl %dl,%edx
f0105016:	83 ea 20             	sub    $0x20,%edx
f0105019:	83 fa 5e             	cmp    $0x5e,%edx
f010501c:	76 c4                	jbe    f0104fe2 <vprintfmt+0x1e6>
					putch('?', putdat);
f010501e:	83 ec 08             	sub    $0x8,%esp
f0105021:	ff 75 0c             	pushl  0xc(%ebp)
f0105024:	6a 3f                	push   $0x3f
f0105026:	ff 55 08             	call   *0x8(%ebp)
f0105029:	83 c4 10             	add    $0x10,%esp
f010502c:	eb c1                	jmp    f0104fef <vprintfmt+0x1f3>
f010502e:	89 75 08             	mov    %esi,0x8(%ebp)
f0105031:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105034:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105037:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010503a:	eb b6                	jmp    f0104ff2 <vprintfmt+0x1f6>
				putch(' ', putdat);
f010503c:	83 ec 08             	sub    $0x8,%esp
f010503f:	53                   	push   %ebx
f0105040:	6a 20                	push   $0x20
f0105042:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105044:	83 ef 01             	sub    $0x1,%edi
f0105047:	83 c4 10             	add    $0x10,%esp
f010504a:	85 ff                	test   %edi,%edi
f010504c:	7f ee                	jg     f010503c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f010504e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105051:	89 45 14             	mov    %eax,0x14(%ebp)
f0105054:	e9 b7 01 00 00       	jmp    f0105210 <vprintfmt+0x414>
f0105059:	89 df                	mov    %ebx,%edi
f010505b:	8b 75 08             	mov    0x8(%ebp),%esi
f010505e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105061:	eb e7                	jmp    f010504a <vprintfmt+0x24e>
	if (lflag >= 2)
f0105063:	83 f9 01             	cmp    $0x1,%ecx
f0105066:	7e 3f                	jle    f01050a7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f0105068:	8b 45 14             	mov    0x14(%ebp),%eax
f010506b:	8b 50 04             	mov    0x4(%eax),%edx
f010506e:	8b 00                	mov    (%eax),%eax
f0105070:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105073:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105076:	8b 45 14             	mov    0x14(%ebp),%eax
f0105079:	8d 40 08             	lea    0x8(%eax),%eax
f010507c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f010507f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105083:	79 5c                	jns    f01050e1 <vprintfmt+0x2e5>
				putch('-', putdat);
f0105085:	83 ec 08             	sub    $0x8,%esp
f0105088:	53                   	push   %ebx
f0105089:	6a 2d                	push   $0x2d
f010508b:	ff d6                	call   *%esi
				num = -(long long) num;
f010508d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105090:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105093:	f7 da                	neg    %edx
f0105095:	83 d1 00             	adc    $0x0,%ecx
f0105098:	f7 d9                	neg    %ecx
f010509a:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010509d:	b8 0a 00 00 00       	mov    $0xa,%eax
f01050a2:	e9 4f 01 00 00       	jmp    f01051f6 <vprintfmt+0x3fa>
	else if (lflag)
f01050a7:	85 c9                	test   %ecx,%ecx
f01050a9:	75 1b                	jne    f01050c6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f01050ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01050ae:	8b 00                	mov    (%eax),%eax
f01050b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01050b3:	89 c1                	mov    %eax,%ecx
f01050b5:	c1 f9 1f             	sar    $0x1f,%ecx
f01050b8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01050bb:	8b 45 14             	mov    0x14(%ebp),%eax
f01050be:	8d 40 04             	lea    0x4(%eax),%eax
f01050c1:	89 45 14             	mov    %eax,0x14(%ebp)
f01050c4:	eb b9                	jmp    f010507f <vprintfmt+0x283>
		return va_arg(*ap, long);
f01050c6:	8b 45 14             	mov    0x14(%ebp),%eax
f01050c9:	8b 00                	mov    (%eax),%eax
f01050cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01050ce:	89 c1                	mov    %eax,%ecx
f01050d0:	c1 f9 1f             	sar    $0x1f,%ecx
f01050d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01050d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01050d9:	8d 40 04             	lea    0x4(%eax),%eax
f01050dc:	89 45 14             	mov    %eax,0x14(%ebp)
f01050df:	eb 9e                	jmp    f010507f <vprintfmt+0x283>
			num = getint(&ap, lflag);
f01050e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01050e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01050e7:	b8 0a 00 00 00       	mov    $0xa,%eax
f01050ec:	e9 05 01 00 00       	jmp    f01051f6 <vprintfmt+0x3fa>
	if (lflag >= 2)
f01050f1:	83 f9 01             	cmp    $0x1,%ecx
f01050f4:	7e 18                	jle    f010510e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
f01050f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01050f9:	8b 10                	mov    (%eax),%edx
f01050fb:	8b 48 04             	mov    0x4(%eax),%ecx
f01050fe:	8d 40 08             	lea    0x8(%eax),%eax
f0105101:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105104:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105109:	e9 e8 00 00 00       	jmp    f01051f6 <vprintfmt+0x3fa>
	else if (lflag)
f010510e:	85 c9                	test   %ecx,%ecx
f0105110:	75 1a                	jne    f010512c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
f0105112:	8b 45 14             	mov    0x14(%ebp),%eax
f0105115:	8b 10                	mov    (%eax),%edx
f0105117:	b9 00 00 00 00       	mov    $0x0,%ecx
f010511c:	8d 40 04             	lea    0x4(%eax),%eax
f010511f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105122:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105127:	e9 ca 00 00 00       	jmp    f01051f6 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
f010512c:	8b 45 14             	mov    0x14(%ebp),%eax
f010512f:	8b 10                	mov    (%eax),%edx
f0105131:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105136:	8d 40 04             	lea    0x4(%eax),%eax
f0105139:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010513c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105141:	e9 b0 00 00 00       	jmp    f01051f6 <vprintfmt+0x3fa>
	if (lflag >= 2)
f0105146:	83 f9 01             	cmp    $0x1,%ecx
f0105149:	7e 3c                	jle    f0105187 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
f010514b:	8b 45 14             	mov    0x14(%ebp),%eax
f010514e:	8b 50 04             	mov    0x4(%eax),%edx
f0105151:	8b 00                	mov    (%eax),%eax
f0105153:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105156:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105159:	8b 45 14             	mov    0x14(%ebp),%eax
f010515c:	8d 40 08             	lea    0x8(%eax),%eax
f010515f:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
f0105162:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105166:	79 59                	jns    f01051c1 <vprintfmt+0x3c5>
                putch('-', putdat);
f0105168:	83 ec 08             	sub    $0x8,%esp
f010516b:	53                   	push   %ebx
f010516c:	6a 2d                	push   $0x2d
f010516e:	ff d6                	call   *%esi
                num = -(long long) num;
f0105170:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105173:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105176:	f7 da                	neg    %edx
f0105178:	83 d1 00             	adc    $0x0,%ecx
f010517b:	f7 d9                	neg    %ecx
f010517d:	83 c4 10             	add    $0x10,%esp
            base = 8;
f0105180:	b8 08 00 00 00       	mov    $0x8,%eax
f0105185:	eb 6f                	jmp    f01051f6 <vprintfmt+0x3fa>
	else if (lflag)
f0105187:	85 c9                	test   %ecx,%ecx
f0105189:	75 1b                	jne    f01051a6 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
f010518b:	8b 45 14             	mov    0x14(%ebp),%eax
f010518e:	8b 00                	mov    (%eax),%eax
f0105190:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105193:	89 c1                	mov    %eax,%ecx
f0105195:	c1 f9 1f             	sar    $0x1f,%ecx
f0105198:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010519b:	8b 45 14             	mov    0x14(%ebp),%eax
f010519e:	8d 40 04             	lea    0x4(%eax),%eax
f01051a1:	89 45 14             	mov    %eax,0x14(%ebp)
f01051a4:	eb bc                	jmp    f0105162 <vprintfmt+0x366>
		return va_arg(*ap, long);
f01051a6:	8b 45 14             	mov    0x14(%ebp),%eax
f01051a9:	8b 00                	mov    (%eax),%eax
f01051ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051ae:	89 c1                	mov    %eax,%ecx
f01051b0:	c1 f9 1f             	sar    $0x1f,%ecx
f01051b3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01051b6:	8b 45 14             	mov    0x14(%ebp),%eax
f01051b9:	8d 40 04             	lea    0x4(%eax),%eax
f01051bc:	89 45 14             	mov    %eax,0x14(%ebp)
f01051bf:	eb a1                	jmp    f0105162 <vprintfmt+0x366>
            num = getint(&ap, lflag);
f01051c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01051c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
f01051c7:	b8 08 00 00 00       	mov    $0x8,%eax
f01051cc:	eb 28                	jmp    f01051f6 <vprintfmt+0x3fa>
			putch('0', putdat);
f01051ce:	83 ec 08             	sub    $0x8,%esp
f01051d1:	53                   	push   %ebx
f01051d2:	6a 30                	push   $0x30
f01051d4:	ff d6                	call   *%esi
			putch('x', putdat);
f01051d6:	83 c4 08             	add    $0x8,%esp
f01051d9:	53                   	push   %ebx
f01051da:	6a 78                	push   $0x78
f01051dc:	ff d6                	call   *%esi
			num = (unsigned long long)
f01051de:	8b 45 14             	mov    0x14(%ebp),%eax
f01051e1:	8b 10                	mov    (%eax),%edx
f01051e3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01051e8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01051eb:	8d 40 04             	lea    0x4(%eax),%eax
f01051ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01051f1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01051f6:	83 ec 0c             	sub    $0xc,%esp
f01051f9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f01051fd:	57                   	push   %edi
f01051fe:	ff 75 e0             	pushl  -0x20(%ebp)
f0105201:	50                   	push   %eax
f0105202:	51                   	push   %ecx
f0105203:	52                   	push   %edx
f0105204:	89 da                	mov    %ebx,%edx
f0105206:	89 f0                	mov    %esi,%eax
f0105208:	e8 06 fb ff ff       	call   f0104d13 <printnum>
			break;
f010520d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0105210:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105213:	83 c7 01             	add    $0x1,%edi
f0105216:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010521a:	83 f8 25             	cmp    $0x25,%eax
f010521d:	0f 84 f0 fb ff ff    	je     f0104e13 <vprintfmt+0x17>
			if (ch == '\0')
f0105223:	85 c0                	test   %eax,%eax
f0105225:	0f 84 8b 00 00 00    	je     f01052b6 <vprintfmt+0x4ba>
			putch(ch, putdat);
f010522b:	83 ec 08             	sub    $0x8,%esp
f010522e:	53                   	push   %ebx
f010522f:	50                   	push   %eax
f0105230:	ff d6                	call   *%esi
f0105232:	83 c4 10             	add    $0x10,%esp
f0105235:	eb dc                	jmp    f0105213 <vprintfmt+0x417>
	if (lflag >= 2)
f0105237:	83 f9 01             	cmp    $0x1,%ecx
f010523a:	7e 15                	jle    f0105251 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
f010523c:	8b 45 14             	mov    0x14(%ebp),%eax
f010523f:	8b 10                	mov    (%eax),%edx
f0105241:	8b 48 04             	mov    0x4(%eax),%ecx
f0105244:	8d 40 08             	lea    0x8(%eax),%eax
f0105247:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010524a:	b8 10 00 00 00       	mov    $0x10,%eax
f010524f:	eb a5                	jmp    f01051f6 <vprintfmt+0x3fa>
	else if (lflag)
f0105251:	85 c9                	test   %ecx,%ecx
f0105253:	75 17                	jne    f010526c <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
f0105255:	8b 45 14             	mov    0x14(%ebp),%eax
f0105258:	8b 10                	mov    (%eax),%edx
f010525a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010525f:	8d 40 04             	lea    0x4(%eax),%eax
f0105262:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105265:	b8 10 00 00 00       	mov    $0x10,%eax
f010526a:	eb 8a                	jmp    f01051f6 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
f010526c:	8b 45 14             	mov    0x14(%ebp),%eax
f010526f:	8b 10                	mov    (%eax),%edx
f0105271:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105276:	8d 40 04             	lea    0x4(%eax),%eax
f0105279:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010527c:	b8 10 00 00 00       	mov    $0x10,%eax
f0105281:	e9 70 ff ff ff       	jmp    f01051f6 <vprintfmt+0x3fa>
			putch(ch, putdat);
f0105286:	83 ec 08             	sub    $0x8,%esp
f0105289:	53                   	push   %ebx
f010528a:	6a 25                	push   $0x25
f010528c:	ff d6                	call   *%esi
			break;
f010528e:	83 c4 10             	add    $0x10,%esp
f0105291:	e9 7a ff ff ff       	jmp    f0105210 <vprintfmt+0x414>
			putch('%', putdat);
f0105296:	83 ec 08             	sub    $0x8,%esp
f0105299:	53                   	push   %ebx
f010529a:	6a 25                	push   $0x25
f010529c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010529e:	83 c4 10             	add    $0x10,%esp
f01052a1:	89 f8                	mov    %edi,%eax
f01052a3:	eb 03                	jmp    f01052a8 <vprintfmt+0x4ac>
f01052a5:	83 e8 01             	sub    $0x1,%eax
f01052a8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01052ac:	75 f7                	jne    f01052a5 <vprintfmt+0x4a9>
f01052ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01052b1:	e9 5a ff ff ff       	jmp    f0105210 <vprintfmt+0x414>
}
f01052b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01052b9:	5b                   	pop    %ebx
f01052ba:	5e                   	pop    %esi
f01052bb:	5f                   	pop    %edi
f01052bc:	5d                   	pop    %ebp
f01052bd:	c3                   	ret    

f01052be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01052be:	55                   	push   %ebp
f01052bf:	89 e5                	mov    %esp,%ebp
f01052c1:	83 ec 18             	sub    $0x18,%esp
f01052c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01052c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01052ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01052cd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01052d1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01052d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01052db:	85 c0                	test   %eax,%eax
f01052dd:	74 26                	je     f0105305 <vsnprintf+0x47>
f01052df:	85 d2                	test   %edx,%edx
f01052e1:	7e 22                	jle    f0105305 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01052e3:	ff 75 14             	pushl  0x14(%ebp)
f01052e6:	ff 75 10             	pushl  0x10(%ebp)
f01052e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01052ec:	50                   	push   %eax
f01052ed:	68 c2 4d 10 f0       	push   $0xf0104dc2
f01052f2:	e8 05 fb ff ff       	call   f0104dfc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01052f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01052fa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01052fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105300:	83 c4 10             	add    $0x10,%esp
}
f0105303:	c9                   	leave  
f0105304:	c3                   	ret    
		return -E_INVAL;
f0105305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010530a:	eb f7                	jmp    f0105303 <vsnprintf+0x45>

f010530c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010530c:	55                   	push   %ebp
f010530d:	89 e5                	mov    %esp,%ebp
f010530f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105312:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105315:	50                   	push   %eax
f0105316:	ff 75 10             	pushl  0x10(%ebp)
f0105319:	ff 75 0c             	pushl  0xc(%ebp)
f010531c:	ff 75 08             	pushl  0x8(%ebp)
f010531f:	e8 9a ff ff ff       	call   f01052be <vsnprintf>
	va_end(ap);

	return rc;
}
f0105324:	c9                   	leave  
f0105325:	c3                   	ret    

f0105326 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105326:	55                   	push   %ebp
f0105327:	89 e5                	mov    %esp,%ebp
f0105329:	57                   	push   %edi
f010532a:	56                   	push   %esi
f010532b:	53                   	push   %ebx
f010532c:	83 ec 0c             	sub    $0xc,%esp
f010532f:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0105332:	85 c0                	test   %eax,%eax
f0105334:	74 11                	je     f0105347 <readline+0x21>
		cprintf("%s", prompt);
f0105336:	83 ec 08             	sub    $0x8,%esp
f0105339:	50                   	push   %eax
f010533a:	68 f3 75 10 f0       	push   $0xf01075f3
f010533f:	e8 61 e7 ff ff       	call   f0103aa5 <cprintf>
f0105344:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0105347:	83 ec 0c             	sub    $0xc,%esp
f010534a:	6a 00                	push   $0x0
f010534c:	e8 3d b4 ff ff       	call   f010078e <iscons>
f0105351:	89 c7                	mov    %eax,%edi
f0105353:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105356:	be 00 00 00 00       	mov    $0x0,%esi
f010535b:	eb 3f                	jmp    f010539c <readline+0x76>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f010535d:	83 ec 08             	sub    $0x8,%esp
f0105360:	50                   	push   %eax
f0105361:	68 24 88 10 f0       	push   $0xf0108824
f0105366:	e8 3a e7 ff ff       	call   f0103aa5 <cprintf>
			return NULL;
f010536b:	83 c4 10             	add    $0x10,%esp
f010536e:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105373:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105376:	5b                   	pop    %ebx
f0105377:	5e                   	pop    %esi
f0105378:	5f                   	pop    %edi
f0105379:	5d                   	pop    %ebp
f010537a:	c3                   	ret    
			if (echoing)
f010537b:	85 ff                	test   %edi,%edi
f010537d:	75 05                	jne    f0105384 <readline+0x5e>
			i--;
f010537f:	83 ee 01             	sub    $0x1,%esi
f0105382:	eb 18                	jmp    f010539c <readline+0x76>
				cputchar('\b');
f0105384:	83 ec 0c             	sub    $0xc,%esp
f0105387:	6a 08                	push   $0x8
f0105389:	e8 df b3 ff ff       	call   f010076d <cputchar>
f010538e:	83 c4 10             	add    $0x10,%esp
f0105391:	eb ec                	jmp    f010537f <readline+0x59>
			buf[i++] = c;
f0105393:	88 9e 80 4a 23 f0    	mov    %bl,-0xfdcb580(%esi)
f0105399:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f010539c:	e8 dc b3 ff ff       	call   f010077d <getchar>
f01053a1:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01053a3:	85 c0                	test   %eax,%eax
f01053a5:	78 b6                	js     f010535d <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01053a7:	83 f8 08             	cmp    $0x8,%eax
f01053aa:	0f 94 c2             	sete   %dl
f01053ad:	83 f8 7f             	cmp    $0x7f,%eax
f01053b0:	0f 94 c0             	sete   %al
f01053b3:	08 c2                	or     %al,%dl
f01053b5:	74 04                	je     f01053bb <readline+0x95>
f01053b7:	85 f6                	test   %esi,%esi
f01053b9:	7f c0                	jg     f010537b <readline+0x55>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01053bb:	83 fb 1f             	cmp    $0x1f,%ebx
f01053be:	7e 1a                	jle    f01053da <readline+0xb4>
f01053c0:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01053c6:	7f 12                	jg     f01053da <readline+0xb4>
			if (echoing)
f01053c8:	85 ff                	test   %edi,%edi
f01053ca:	74 c7                	je     f0105393 <readline+0x6d>
				cputchar(c);
f01053cc:	83 ec 0c             	sub    $0xc,%esp
f01053cf:	53                   	push   %ebx
f01053d0:	e8 98 b3 ff ff       	call   f010076d <cputchar>
f01053d5:	83 c4 10             	add    $0x10,%esp
f01053d8:	eb b9                	jmp    f0105393 <readline+0x6d>
		} else if (c == '\n' || c == '\r') {
f01053da:	83 fb 0a             	cmp    $0xa,%ebx
f01053dd:	74 05                	je     f01053e4 <readline+0xbe>
f01053df:	83 fb 0d             	cmp    $0xd,%ebx
f01053e2:	75 b8                	jne    f010539c <readline+0x76>
			if (echoing)
f01053e4:	85 ff                	test   %edi,%edi
f01053e6:	75 11                	jne    f01053f9 <readline+0xd3>
			buf[i] = 0;
f01053e8:	c6 86 80 4a 23 f0 00 	movb   $0x0,-0xfdcb580(%esi)
			return buf;
f01053ef:	b8 80 4a 23 f0       	mov    $0xf0234a80,%eax
f01053f4:	e9 7a ff ff ff       	jmp    f0105373 <readline+0x4d>
				cputchar('\n');
f01053f9:	83 ec 0c             	sub    $0xc,%esp
f01053fc:	6a 0a                	push   $0xa
f01053fe:	e8 6a b3 ff ff       	call   f010076d <cputchar>
f0105403:	83 c4 10             	add    $0x10,%esp
f0105406:	eb e0                	jmp    f01053e8 <readline+0xc2>

f0105408 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105408:	55                   	push   %ebp
f0105409:	89 e5                	mov    %esp,%ebp
f010540b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010540e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105413:	eb 03                	jmp    f0105418 <strlen+0x10>
		n++;
f0105415:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0105418:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010541c:	75 f7                	jne    f0105415 <strlen+0xd>
	return n;
}
f010541e:	5d                   	pop    %ebp
f010541f:	c3                   	ret    

f0105420 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105420:	55                   	push   %ebp
f0105421:	89 e5                	mov    %esp,%ebp
f0105423:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105426:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105429:	b8 00 00 00 00       	mov    $0x0,%eax
f010542e:	eb 03                	jmp    f0105433 <strnlen+0x13>
		n++;
f0105430:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105433:	39 d0                	cmp    %edx,%eax
f0105435:	74 06                	je     f010543d <strnlen+0x1d>
f0105437:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010543b:	75 f3                	jne    f0105430 <strnlen+0x10>
	return n;
}
f010543d:	5d                   	pop    %ebp
f010543e:	c3                   	ret    

f010543f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010543f:	55                   	push   %ebp
f0105440:	89 e5                	mov    %esp,%ebp
f0105442:	53                   	push   %ebx
f0105443:	8b 45 08             	mov    0x8(%ebp),%eax
f0105446:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105449:	89 c2                	mov    %eax,%edx
f010544b:	83 c1 01             	add    $0x1,%ecx
f010544e:	83 c2 01             	add    $0x1,%edx
f0105451:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0105455:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105458:	84 db                	test   %bl,%bl
f010545a:	75 ef                	jne    f010544b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f010545c:	5b                   	pop    %ebx
f010545d:	5d                   	pop    %ebp
f010545e:	c3                   	ret    

f010545f <strcat>:

char *
strcat(char *dst, const char *src)
{
f010545f:	55                   	push   %ebp
f0105460:	89 e5                	mov    %esp,%ebp
f0105462:	53                   	push   %ebx
f0105463:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105466:	53                   	push   %ebx
f0105467:	e8 9c ff ff ff       	call   f0105408 <strlen>
f010546c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f010546f:	ff 75 0c             	pushl  0xc(%ebp)
f0105472:	01 d8                	add    %ebx,%eax
f0105474:	50                   	push   %eax
f0105475:	e8 c5 ff ff ff       	call   f010543f <strcpy>
	return dst;
}
f010547a:	89 d8                	mov    %ebx,%eax
f010547c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010547f:	c9                   	leave  
f0105480:	c3                   	ret    

f0105481 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105481:	55                   	push   %ebp
f0105482:	89 e5                	mov    %esp,%ebp
f0105484:	56                   	push   %esi
f0105485:	53                   	push   %ebx
f0105486:	8b 75 08             	mov    0x8(%ebp),%esi
f0105489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010548c:	89 f3                	mov    %esi,%ebx
f010548e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105491:	89 f2                	mov    %esi,%edx
f0105493:	eb 0f                	jmp    f01054a4 <strncpy+0x23>
		*dst++ = *src;
f0105495:	83 c2 01             	add    $0x1,%edx
f0105498:	0f b6 01             	movzbl (%ecx),%eax
f010549b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f010549e:	80 39 01             	cmpb   $0x1,(%ecx)
f01054a1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f01054a4:	39 da                	cmp    %ebx,%edx
f01054a6:	75 ed                	jne    f0105495 <strncpy+0x14>
	}
	return ret;
}
f01054a8:	89 f0                	mov    %esi,%eax
f01054aa:	5b                   	pop    %ebx
f01054ab:	5e                   	pop    %esi
f01054ac:	5d                   	pop    %ebp
f01054ad:	c3                   	ret    

f01054ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01054ae:	55                   	push   %ebp
f01054af:	89 e5                	mov    %esp,%ebp
f01054b1:	56                   	push   %esi
f01054b2:	53                   	push   %ebx
f01054b3:	8b 75 08             	mov    0x8(%ebp),%esi
f01054b6:	8b 55 0c             	mov    0xc(%ebp),%edx
f01054b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01054bc:	89 f0                	mov    %esi,%eax
f01054be:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01054c2:	85 c9                	test   %ecx,%ecx
f01054c4:	75 0b                	jne    f01054d1 <strlcpy+0x23>
f01054c6:	eb 17                	jmp    f01054df <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01054c8:	83 c2 01             	add    $0x1,%edx
f01054cb:	83 c0 01             	add    $0x1,%eax
f01054ce:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f01054d1:	39 d8                	cmp    %ebx,%eax
f01054d3:	74 07                	je     f01054dc <strlcpy+0x2e>
f01054d5:	0f b6 0a             	movzbl (%edx),%ecx
f01054d8:	84 c9                	test   %cl,%cl
f01054da:	75 ec                	jne    f01054c8 <strlcpy+0x1a>
		*dst = '\0';
f01054dc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01054df:	29 f0                	sub    %esi,%eax
}
f01054e1:	5b                   	pop    %ebx
f01054e2:	5e                   	pop    %esi
f01054e3:	5d                   	pop    %ebp
f01054e4:	c3                   	ret    

f01054e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01054e5:	55                   	push   %ebp
f01054e6:	89 e5                	mov    %esp,%ebp
f01054e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01054eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01054ee:	eb 06                	jmp    f01054f6 <strcmp+0x11>
		p++, q++;
f01054f0:	83 c1 01             	add    $0x1,%ecx
f01054f3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f01054f6:	0f b6 01             	movzbl (%ecx),%eax
f01054f9:	84 c0                	test   %al,%al
f01054fb:	74 04                	je     f0105501 <strcmp+0x1c>
f01054fd:	3a 02                	cmp    (%edx),%al
f01054ff:	74 ef                	je     f01054f0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105501:	0f b6 c0             	movzbl %al,%eax
f0105504:	0f b6 12             	movzbl (%edx),%edx
f0105507:	29 d0                	sub    %edx,%eax
}
f0105509:	5d                   	pop    %ebp
f010550a:	c3                   	ret    

f010550b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010550b:	55                   	push   %ebp
f010550c:	89 e5                	mov    %esp,%ebp
f010550e:	53                   	push   %ebx
f010550f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105512:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105515:	89 c3                	mov    %eax,%ebx
f0105517:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010551a:	eb 06                	jmp    f0105522 <strncmp+0x17>
		n--, p++, q++;
f010551c:	83 c0 01             	add    $0x1,%eax
f010551f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105522:	39 d8                	cmp    %ebx,%eax
f0105524:	74 16                	je     f010553c <strncmp+0x31>
f0105526:	0f b6 08             	movzbl (%eax),%ecx
f0105529:	84 c9                	test   %cl,%cl
f010552b:	74 04                	je     f0105531 <strncmp+0x26>
f010552d:	3a 0a                	cmp    (%edx),%cl
f010552f:	74 eb                	je     f010551c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105531:	0f b6 00             	movzbl (%eax),%eax
f0105534:	0f b6 12             	movzbl (%edx),%edx
f0105537:	29 d0                	sub    %edx,%eax
}
f0105539:	5b                   	pop    %ebx
f010553a:	5d                   	pop    %ebp
f010553b:	c3                   	ret    
		return 0;
f010553c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105541:	eb f6                	jmp    f0105539 <strncmp+0x2e>

f0105543 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105543:	55                   	push   %ebp
f0105544:	89 e5                	mov    %esp,%ebp
f0105546:	8b 45 08             	mov    0x8(%ebp),%eax
f0105549:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010554d:	0f b6 10             	movzbl (%eax),%edx
f0105550:	84 d2                	test   %dl,%dl
f0105552:	74 09                	je     f010555d <strchr+0x1a>
		if (*s == c)
f0105554:	38 ca                	cmp    %cl,%dl
f0105556:	74 0a                	je     f0105562 <strchr+0x1f>
	for (; *s; s++)
f0105558:	83 c0 01             	add    $0x1,%eax
f010555b:	eb f0                	jmp    f010554d <strchr+0xa>
			return (char *) s;
	return 0;
f010555d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105562:	5d                   	pop    %ebp
f0105563:	c3                   	ret    

f0105564 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105564:	55                   	push   %ebp
f0105565:	89 e5                	mov    %esp,%ebp
f0105567:	8b 45 08             	mov    0x8(%ebp),%eax
f010556a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010556e:	eb 03                	jmp    f0105573 <strfind+0xf>
f0105570:	83 c0 01             	add    $0x1,%eax
f0105573:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105576:	38 ca                	cmp    %cl,%dl
f0105578:	74 04                	je     f010557e <strfind+0x1a>
f010557a:	84 d2                	test   %dl,%dl
f010557c:	75 f2                	jne    f0105570 <strfind+0xc>
			break;
	return (char *) s;
}
f010557e:	5d                   	pop    %ebp
f010557f:	c3                   	ret    

f0105580 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105580:	55                   	push   %ebp
f0105581:	89 e5                	mov    %esp,%ebp
f0105583:	57                   	push   %edi
f0105584:	56                   	push   %esi
f0105585:	53                   	push   %ebx
f0105586:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105589:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f010558c:	85 c9                	test   %ecx,%ecx
f010558e:	74 13                	je     f01055a3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105590:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0105596:	75 05                	jne    f010559d <memset+0x1d>
f0105598:	f6 c1 03             	test   $0x3,%cl
f010559b:	74 0d                	je     f01055aa <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010559d:	8b 45 0c             	mov    0xc(%ebp),%eax
f01055a0:	fc                   	cld    
f01055a1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01055a3:	89 f8                	mov    %edi,%eax
f01055a5:	5b                   	pop    %ebx
f01055a6:	5e                   	pop    %esi
f01055a7:	5f                   	pop    %edi
f01055a8:	5d                   	pop    %ebp
f01055a9:	c3                   	ret    
		c &= 0xFF;
f01055aa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01055ae:	89 d3                	mov    %edx,%ebx
f01055b0:	c1 e3 08             	shl    $0x8,%ebx
f01055b3:	89 d0                	mov    %edx,%eax
f01055b5:	c1 e0 18             	shl    $0x18,%eax
f01055b8:	89 d6                	mov    %edx,%esi
f01055ba:	c1 e6 10             	shl    $0x10,%esi
f01055bd:	09 f0                	or     %esi,%eax
f01055bf:	09 c2                	or     %eax,%edx
f01055c1:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f01055c3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01055c6:	89 d0                	mov    %edx,%eax
f01055c8:	fc                   	cld    
f01055c9:	f3 ab                	rep stos %eax,%es:(%edi)
f01055cb:	eb d6                	jmp    f01055a3 <memset+0x23>

f01055cd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01055cd:	55                   	push   %ebp
f01055ce:	89 e5                	mov    %esp,%ebp
f01055d0:	57                   	push   %edi
f01055d1:	56                   	push   %esi
f01055d2:	8b 45 08             	mov    0x8(%ebp),%eax
f01055d5:	8b 75 0c             	mov    0xc(%ebp),%esi
f01055d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01055db:	39 c6                	cmp    %eax,%esi
f01055dd:	73 35                	jae    f0105614 <memmove+0x47>
f01055df:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01055e2:	39 c2                	cmp    %eax,%edx
f01055e4:	76 2e                	jbe    f0105614 <memmove+0x47>
		s += n;
		d += n;
f01055e6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01055e9:	89 d6                	mov    %edx,%esi
f01055eb:	09 fe                	or     %edi,%esi
f01055ed:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01055f3:	74 0c                	je     f0105601 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01055f5:	83 ef 01             	sub    $0x1,%edi
f01055f8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f01055fb:	fd                   	std    
f01055fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01055fe:	fc                   	cld    
f01055ff:	eb 21                	jmp    f0105622 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105601:	f6 c1 03             	test   $0x3,%cl
f0105604:	75 ef                	jne    f01055f5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105606:	83 ef 04             	sub    $0x4,%edi
f0105609:	8d 72 fc             	lea    -0x4(%edx),%esi
f010560c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010560f:	fd                   	std    
f0105610:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105612:	eb ea                	jmp    f01055fe <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105614:	89 f2                	mov    %esi,%edx
f0105616:	09 c2                	or     %eax,%edx
f0105618:	f6 c2 03             	test   $0x3,%dl
f010561b:	74 09                	je     f0105626 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f010561d:	89 c7                	mov    %eax,%edi
f010561f:	fc                   	cld    
f0105620:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105622:	5e                   	pop    %esi
f0105623:	5f                   	pop    %edi
f0105624:	5d                   	pop    %ebp
f0105625:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105626:	f6 c1 03             	test   $0x3,%cl
f0105629:	75 f2                	jne    f010561d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010562b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010562e:	89 c7                	mov    %eax,%edi
f0105630:	fc                   	cld    
f0105631:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105633:	eb ed                	jmp    f0105622 <memmove+0x55>

f0105635 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105635:	55                   	push   %ebp
f0105636:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0105638:	ff 75 10             	pushl  0x10(%ebp)
f010563b:	ff 75 0c             	pushl  0xc(%ebp)
f010563e:	ff 75 08             	pushl  0x8(%ebp)
f0105641:	e8 87 ff ff ff       	call   f01055cd <memmove>
}
f0105646:	c9                   	leave  
f0105647:	c3                   	ret    

f0105648 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105648:	55                   	push   %ebp
f0105649:	89 e5                	mov    %esp,%ebp
f010564b:	56                   	push   %esi
f010564c:	53                   	push   %ebx
f010564d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105650:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105653:	89 c6                	mov    %eax,%esi
f0105655:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105658:	39 f0                	cmp    %esi,%eax
f010565a:	74 1c                	je     f0105678 <memcmp+0x30>
		if (*s1 != *s2)
f010565c:	0f b6 08             	movzbl (%eax),%ecx
f010565f:	0f b6 1a             	movzbl (%edx),%ebx
f0105662:	38 d9                	cmp    %bl,%cl
f0105664:	75 08                	jne    f010566e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105666:	83 c0 01             	add    $0x1,%eax
f0105669:	83 c2 01             	add    $0x1,%edx
f010566c:	eb ea                	jmp    f0105658 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f010566e:	0f b6 c1             	movzbl %cl,%eax
f0105671:	0f b6 db             	movzbl %bl,%ebx
f0105674:	29 d8                	sub    %ebx,%eax
f0105676:	eb 05                	jmp    f010567d <memcmp+0x35>
	}

	return 0;
f0105678:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010567d:	5b                   	pop    %ebx
f010567e:	5e                   	pop    %esi
f010567f:	5d                   	pop    %ebp
f0105680:	c3                   	ret    

f0105681 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105681:	55                   	push   %ebp
f0105682:	89 e5                	mov    %esp,%ebp
f0105684:	8b 45 08             	mov    0x8(%ebp),%eax
f0105687:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f010568a:	89 c2                	mov    %eax,%edx
f010568c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f010568f:	39 d0                	cmp    %edx,%eax
f0105691:	73 09                	jae    f010569c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105693:	38 08                	cmp    %cl,(%eax)
f0105695:	74 05                	je     f010569c <memfind+0x1b>
	for (; s < ends; s++)
f0105697:	83 c0 01             	add    $0x1,%eax
f010569a:	eb f3                	jmp    f010568f <memfind+0xe>
			break;
	return (void *) s;
}
f010569c:	5d                   	pop    %ebp
f010569d:	c3                   	ret    

f010569e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f010569e:	55                   	push   %ebp
f010569f:	89 e5                	mov    %esp,%ebp
f01056a1:	57                   	push   %edi
f01056a2:	56                   	push   %esi
f01056a3:	53                   	push   %ebx
f01056a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01056a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01056aa:	eb 03                	jmp    f01056af <strtol+0x11>
		s++;
f01056ac:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01056af:	0f b6 01             	movzbl (%ecx),%eax
f01056b2:	3c 20                	cmp    $0x20,%al
f01056b4:	74 f6                	je     f01056ac <strtol+0xe>
f01056b6:	3c 09                	cmp    $0x9,%al
f01056b8:	74 f2                	je     f01056ac <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01056ba:	3c 2b                	cmp    $0x2b,%al
f01056bc:	74 2e                	je     f01056ec <strtol+0x4e>
	int neg = 0;
f01056be:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01056c3:	3c 2d                	cmp    $0x2d,%al
f01056c5:	74 2f                	je     f01056f6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01056c7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01056cd:	75 05                	jne    f01056d4 <strtol+0x36>
f01056cf:	80 39 30             	cmpb   $0x30,(%ecx)
f01056d2:	74 2c                	je     f0105700 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01056d4:	85 db                	test   %ebx,%ebx
f01056d6:	75 0a                	jne    f01056e2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01056d8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f01056dd:	80 39 30             	cmpb   $0x30,(%ecx)
f01056e0:	74 28                	je     f010570a <strtol+0x6c>
		base = 10;
f01056e2:	b8 00 00 00 00       	mov    $0x0,%eax
f01056e7:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01056ea:	eb 50                	jmp    f010573c <strtol+0x9e>
		s++;
f01056ec:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01056ef:	bf 00 00 00 00       	mov    $0x0,%edi
f01056f4:	eb d1                	jmp    f01056c7 <strtol+0x29>
		s++, neg = 1;
f01056f6:	83 c1 01             	add    $0x1,%ecx
f01056f9:	bf 01 00 00 00       	mov    $0x1,%edi
f01056fe:	eb c7                	jmp    f01056c7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105700:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105704:	74 0e                	je     f0105714 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105706:	85 db                	test   %ebx,%ebx
f0105708:	75 d8                	jne    f01056e2 <strtol+0x44>
		s++, base = 8;
f010570a:	83 c1 01             	add    $0x1,%ecx
f010570d:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105712:	eb ce                	jmp    f01056e2 <strtol+0x44>
		s += 2, base = 16;
f0105714:	83 c1 02             	add    $0x2,%ecx
f0105717:	bb 10 00 00 00       	mov    $0x10,%ebx
f010571c:	eb c4                	jmp    f01056e2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f010571e:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105721:	89 f3                	mov    %esi,%ebx
f0105723:	80 fb 19             	cmp    $0x19,%bl
f0105726:	77 29                	ja     f0105751 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105728:	0f be d2             	movsbl %dl,%edx
f010572b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010572e:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105731:	7d 30                	jge    f0105763 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105733:	83 c1 01             	add    $0x1,%ecx
f0105736:	0f af 45 10          	imul   0x10(%ebp),%eax
f010573a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f010573c:	0f b6 11             	movzbl (%ecx),%edx
f010573f:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105742:	89 f3                	mov    %esi,%ebx
f0105744:	80 fb 09             	cmp    $0x9,%bl
f0105747:	77 d5                	ja     f010571e <strtol+0x80>
			dig = *s - '0';
f0105749:	0f be d2             	movsbl %dl,%edx
f010574c:	83 ea 30             	sub    $0x30,%edx
f010574f:	eb dd                	jmp    f010572e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0105751:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105754:	89 f3                	mov    %esi,%ebx
f0105756:	80 fb 19             	cmp    $0x19,%bl
f0105759:	77 08                	ja     f0105763 <strtol+0xc5>
			dig = *s - 'A' + 10;
f010575b:	0f be d2             	movsbl %dl,%edx
f010575e:	83 ea 37             	sub    $0x37,%edx
f0105761:	eb cb                	jmp    f010572e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105763:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105767:	74 05                	je     f010576e <strtol+0xd0>
		*endptr = (char *) s;
f0105769:	8b 75 0c             	mov    0xc(%ebp),%esi
f010576c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f010576e:	89 c2                	mov    %eax,%edx
f0105770:	f7 da                	neg    %edx
f0105772:	85 ff                	test   %edi,%edi
f0105774:	0f 45 c2             	cmovne %edx,%eax
}
f0105777:	5b                   	pop    %ebx
f0105778:	5e                   	pop    %esi
f0105779:	5f                   	pop    %edi
f010577a:	5d                   	pop    %ebp
f010577b:	c3                   	ret    

f010577c <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f010577c:	fa                   	cli    

	xorw    %ax, %ax
f010577d:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010577f:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105781:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105783:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105785:	0f 01 16             	lgdtl  (%esi)
f0105788:	74 70                	je     f01057fa <mpsearch1+0x3>
	movl    %cr0, %eax
f010578a:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f010578d:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105791:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105794:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f010579a:	08 00                	or     %al,(%eax)

f010579c <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f010579c:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01057a0:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01057a2:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01057a4:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01057a6:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01057aa:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01057ac:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01057ae:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl    %eax, %cr3
f01057b3:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01057b6:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01057b9:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01057be:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01057c1:	8b 25 88 4e 23 f0    	mov    0xf0234e88,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01057c7:	bd 00 00 00 00       	mov    $0x0,%ebp

	//??? not understand temporary
	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01057cc:	b8 a0 01 10 f0       	mov    $0xf01001a0,%eax
	call    *%eax
f01057d1:	ff d0                	call   *%eax

f01057d3 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01057d3:	eb fe                	jmp    f01057d3 <spin>
f01057d5:	8d 76 00             	lea    0x0(%esi),%esi

f01057d8 <gdt>:
	...
f01057e0:	ff                   	(bad)  
f01057e1:	ff 00                	incl   (%eax)
f01057e3:	00 00                	add    %al,(%eax)
f01057e5:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f01057ec:	00                   	.byte 0x0
f01057ed:	92                   	xchg   %eax,%edx
f01057ee:	cf                   	iret   
	...

f01057f0 <gdtdesc>:
f01057f0:	17                   	pop    %ss
f01057f1:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f01057f6 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f01057f6:	90                   	nop

f01057f7 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f01057f7:	55                   	push   %ebp
f01057f8:	89 e5                	mov    %esp,%ebp
f01057fa:	57                   	push   %edi
f01057fb:	56                   	push   %esi
f01057fc:	53                   	push   %ebx
f01057fd:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105800:	8b 0d 8c 4e 23 f0    	mov    0xf0234e8c,%ecx
f0105806:	89 c3                	mov    %eax,%ebx
f0105808:	c1 eb 0c             	shr    $0xc,%ebx
f010580b:	39 cb                	cmp    %ecx,%ebx
f010580d:	73 1a                	jae    f0105829 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010580f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105815:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f0105818:	89 f0                	mov    %esi,%eax
f010581a:	c1 e8 0c             	shr    $0xc,%eax
f010581d:	39 c8                	cmp    %ecx,%eax
f010581f:	73 1a                	jae    f010583b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105821:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f0105827:	eb 27                	jmp    f0105850 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105829:	50                   	push   %eax
f010582a:	68 24 62 10 f0       	push   $0xf0106224
f010582f:	6a 57                	push   $0x57
f0105831:	68 c1 89 10 f0       	push   $0xf01089c1
f0105836:	e8 05 a8 ff ff       	call   f0100040 <_panic>
f010583b:	56                   	push   %esi
f010583c:	68 24 62 10 f0       	push   $0xf0106224
f0105841:	6a 57                	push   $0x57
f0105843:	68 c1 89 10 f0       	push   $0xf01089c1
f0105848:	e8 f3 a7 ff ff       	call   f0100040 <_panic>
f010584d:	83 c3 10             	add    $0x10,%ebx
f0105850:	39 f3                	cmp    %esi,%ebx
f0105852:	73 2e                	jae    f0105882 <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105854:	83 ec 04             	sub    $0x4,%esp
f0105857:	6a 04                	push   $0x4
f0105859:	68 d1 89 10 f0       	push   $0xf01089d1
f010585e:	53                   	push   %ebx
f010585f:	e8 e4 fd ff ff       	call   f0105648 <memcmp>
f0105864:	83 c4 10             	add    $0x10,%esp
f0105867:	85 c0                	test   %eax,%eax
f0105869:	75 e2                	jne    f010584d <mpsearch1+0x56>
f010586b:	89 da                	mov    %ebx,%edx
f010586d:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f0105870:	0f b6 0a             	movzbl (%edx),%ecx
f0105873:	01 c8                	add    %ecx,%eax
f0105875:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105878:	39 fa                	cmp    %edi,%edx
f010587a:	75 f4                	jne    f0105870 <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010587c:	84 c0                	test   %al,%al
f010587e:	75 cd                	jne    f010584d <mpsearch1+0x56>
f0105880:	eb 05                	jmp    f0105887 <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105882:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105887:	89 d8                	mov    %ebx,%eax
f0105889:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010588c:	5b                   	pop    %ebx
f010588d:	5e                   	pop    %esi
f010588e:	5f                   	pop    %edi
f010588f:	5d                   	pop    %ebp
f0105890:	c3                   	ret    

f0105891 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105891:	55                   	push   %ebp
f0105892:	89 e5                	mov    %esp,%ebp
f0105894:	57                   	push   %edi
f0105895:	56                   	push   %esi
f0105896:	53                   	push   %ebx
f0105897:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f010589a:	c7 05 c0 53 23 f0 20 	movl   $0xf0235020,0xf02353c0
f01058a1:	50 23 f0 
	if (PGNUM(pa) >= npages)
f01058a4:	83 3d 8c 4e 23 f0 00 	cmpl   $0x0,0xf0234e8c
f01058ab:	0f 84 87 00 00 00    	je     f0105938 <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01058b1:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01058b8:	85 c0                	test   %eax,%eax
f01058ba:	0f 84 8e 00 00 00    	je     f010594e <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f01058c0:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01058c3:	ba 00 04 00 00       	mov    $0x400,%edx
f01058c8:	e8 2a ff ff ff       	call   f01057f7 <mpsearch1>
f01058cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01058d0:	85 c0                	test   %eax,%eax
f01058d2:	0f 84 9a 00 00 00    	je     f0105972 <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f01058d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01058db:	8b 41 04             	mov    0x4(%ecx),%eax
f01058de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01058e1:	85 c0                	test   %eax,%eax
f01058e3:	0f 84 a8 00 00 00    	je     f0105991 <mp_init+0x100>
f01058e9:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f01058ed:	0f 85 9e 00 00 00    	jne    f0105991 <mp_init+0x100>
f01058f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058f6:	c1 e8 0c             	shr    $0xc,%eax
f01058f9:	3b 05 8c 4e 23 f0    	cmp    0xf0234e8c,%eax
f01058ff:	0f 83 a1 00 00 00    	jae    f01059a6 <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105908:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f010590e:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105910:	83 ec 04             	sub    $0x4,%esp
f0105913:	6a 04                	push   $0x4
f0105915:	68 d6 89 10 f0       	push   $0xf01089d6
f010591a:	53                   	push   %ebx
f010591b:	e8 28 fd ff ff       	call   f0105648 <memcmp>
f0105920:	83 c4 10             	add    $0x10,%esp
f0105923:	85 c0                	test   %eax,%eax
f0105925:	0f 85 92 00 00 00    	jne    f01059bd <mp_init+0x12c>
f010592b:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f010592f:	01 df                	add    %ebx,%edi
	sum = 0;
f0105931:	89 c2                	mov    %eax,%edx
f0105933:	e9 a2 00 00 00       	jmp    f01059da <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105938:	68 00 04 00 00       	push   $0x400
f010593d:	68 24 62 10 f0       	push   $0xf0106224
f0105942:	6a 6f                	push   $0x6f
f0105944:	68 c1 89 10 f0       	push   $0xf01089c1
f0105949:	e8 f2 a6 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010594e:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105955:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105958:	2d 00 04 00 00       	sub    $0x400,%eax
f010595d:	ba 00 04 00 00       	mov    $0x400,%edx
f0105962:	e8 90 fe ff ff       	call   f01057f7 <mpsearch1>
f0105967:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010596a:	85 c0                	test   %eax,%eax
f010596c:	0f 85 66 ff ff ff    	jne    f01058d8 <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f0105972:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105977:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f010597c:	e8 76 fe ff ff       	call   f01057f7 <mpsearch1>
f0105981:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f0105984:	85 c0                	test   %eax,%eax
f0105986:	0f 85 4c ff ff ff    	jne    f01058d8 <mp_init+0x47>
f010598c:	e9 a8 01 00 00       	jmp    f0105b39 <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f0105991:	83 ec 0c             	sub    $0xc,%esp
f0105994:	68 34 88 10 f0       	push   $0xf0108834
f0105999:	e8 07 e1 ff ff       	call   f0103aa5 <cprintf>
f010599e:	83 c4 10             	add    $0x10,%esp
f01059a1:	e9 93 01 00 00       	jmp    f0105b39 <mp_init+0x2a8>
f01059a6:	ff 75 e4             	pushl  -0x1c(%ebp)
f01059a9:	68 24 62 10 f0       	push   $0xf0106224
f01059ae:	68 90 00 00 00       	push   $0x90
f01059b3:	68 c1 89 10 f0       	push   $0xf01089c1
f01059b8:	e8 83 a6 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01059bd:	83 ec 0c             	sub    $0xc,%esp
f01059c0:	68 64 88 10 f0       	push   $0xf0108864
f01059c5:	e8 db e0 ff ff       	call   f0103aa5 <cprintf>
f01059ca:	83 c4 10             	add    $0x10,%esp
f01059cd:	e9 67 01 00 00       	jmp    f0105b39 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f01059d2:	0f b6 0b             	movzbl (%ebx),%ecx
f01059d5:	01 ca                	add    %ecx,%edx
f01059d7:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f01059da:	39 fb                	cmp    %edi,%ebx
f01059dc:	75 f4                	jne    f01059d2 <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f01059de:	84 d2                	test   %dl,%dl
f01059e0:	75 16                	jne    f01059f8 <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f01059e2:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f01059e6:	80 fa 01             	cmp    $0x1,%dl
f01059e9:	74 05                	je     f01059f0 <mp_init+0x15f>
f01059eb:	80 fa 04             	cmp    $0x4,%dl
f01059ee:	75 1d                	jne    f0105a0d <mp_init+0x17c>
f01059f0:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f01059f4:	01 d9                	add    %ebx,%ecx
f01059f6:	eb 36                	jmp    f0105a2e <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f01059f8:	83 ec 0c             	sub    $0xc,%esp
f01059fb:	68 98 88 10 f0       	push   $0xf0108898
f0105a00:	e8 a0 e0 ff ff       	call   f0103aa5 <cprintf>
f0105a05:	83 c4 10             	add    $0x10,%esp
f0105a08:	e9 2c 01 00 00       	jmp    f0105b39 <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105a0d:	83 ec 08             	sub    $0x8,%esp
f0105a10:	0f b6 d2             	movzbl %dl,%edx
f0105a13:	52                   	push   %edx
f0105a14:	68 bc 88 10 f0       	push   $0xf01088bc
f0105a19:	e8 87 e0 ff ff       	call   f0103aa5 <cprintf>
f0105a1e:	83 c4 10             	add    $0x10,%esp
f0105a21:	e9 13 01 00 00       	jmp    f0105b39 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105a26:	0f b6 13             	movzbl (%ebx),%edx
f0105a29:	01 d0                	add    %edx,%eax
f0105a2b:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105a2e:	39 d9                	cmp    %ebx,%ecx
f0105a30:	75 f4                	jne    f0105a26 <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105a32:	02 46 2a             	add    0x2a(%esi),%al
f0105a35:	75 29                	jne    f0105a60 <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105a37:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f0105a3e:	0f 84 f5 00 00 00    	je     f0105b39 <mp_init+0x2a8>
		return;
	ismp = 1;
f0105a44:	c7 05 00 50 23 f0 01 	movl   $0x1,0xf0235000
f0105a4b:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105a4e:	8b 46 24             	mov    0x24(%esi),%eax
f0105a51:	a3 00 60 27 f0       	mov    %eax,0xf0276000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105a56:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105a59:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105a5e:	eb 4d                	jmp    f0105aad <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105a60:	83 ec 0c             	sub    $0xc,%esp
f0105a63:	68 dc 88 10 f0       	push   $0xf01088dc
f0105a68:	e8 38 e0 ff ff       	call   f0103aa5 <cprintf>
f0105a6d:	83 c4 10             	add    $0x10,%esp
f0105a70:	e9 c4 00 00 00       	jmp    f0105b39 <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105a75:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105a79:	74 11                	je     f0105a8c <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105a7b:	6b 05 c4 53 23 f0 74 	imul   $0x74,0xf02353c4,%eax
f0105a82:	05 20 50 23 f0       	add    $0xf0235020,%eax
f0105a87:	a3 c0 53 23 f0       	mov    %eax,0xf02353c0
			if (ncpu < NCPU) {
f0105a8c:	a1 c4 53 23 f0       	mov    0xf02353c4,%eax
f0105a91:	83 f8 07             	cmp    $0x7,%eax
f0105a94:	7f 2f                	jg     f0105ac5 <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;
f0105a96:	6b d0 74             	imul   $0x74,%eax,%edx
f0105a99:	88 82 20 50 23 f0    	mov    %al,-0xfdcafe0(%edx)
				ncpu++;
f0105a9f:	83 c0 01             	add    $0x1,%eax
f0105aa2:	a3 c4 53 23 f0       	mov    %eax,0xf02353c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105aa7:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105aaa:	83 c3 01             	add    $0x1,%ebx
f0105aad:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105ab1:	39 d8                	cmp    %ebx,%eax
f0105ab3:	76 4b                	jbe    f0105b00 <mp_init+0x26f>
		switch (*p) {
f0105ab5:	0f b6 07             	movzbl (%edi),%eax
f0105ab8:	84 c0                	test   %al,%al
f0105aba:	74 b9                	je     f0105a75 <mp_init+0x1e4>
f0105abc:	3c 04                	cmp    $0x4,%al
f0105abe:	77 1c                	ja     f0105adc <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105ac0:	83 c7 08             	add    $0x8,%edi
			continue;
f0105ac3:	eb e5                	jmp    f0105aaa <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105ac5:	83 ec 08             	sub    $0x8,%esp
f0105ac8:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105acc:	50                   	push   %eax
f0105acd:	68 0c 89 10 f0       	push   $0xf010890c
f0105ad2:	e8 ce df ff ff       	call   f0103aa5 <cprintf>
f0105ad7:	83 c4 10             	add    $0x10,%esp
f0105ada:	eb cb                	jmp    f0105aa7 <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105adc:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105adf:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105ae2:	50                   	push   %eax
f0105ae3:	68 34 89 10 f0       	push   $0xf0108934
f0105ae8:	e8 b8 df ff ff       	call   f0103aa5 <cprintf>
			ismp = 0;
f0105aed:	c7 05 00 50 23 f0 00 	movl   $0x0,0xf0235000
f0105af4:	00 00 00 
			i = conf->entry;
f0105af7:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105afb:	83 c4 10             	add    $0x10,%esp
f0105afe:	eb aa                	jmp    f0105aaa <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105b00:	a1 c0 53 23 f0       	mov    0xf02353c0,%eax
f0105b05:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105b0c:	83 3d 00 50 23 f0 00 	cmpl   $0x0,0xf0235000
f0105b13:	75 2c                	jne    f0105b41 <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105b15:	c7 05 c4 53 23 f0 01 	movl   $0x1,0xf02353c4
f0105b1c:	00 00 00 
		lapicaddr = 0;
f0105b1f:	c7 05 00 60 27 f0 00 	movl   $0x0,0xf0276000
f0105b26:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105b29:	83 ec 0c             	sub    $0xc,%esp
f0105b2c:	68 54 89 10 f0       	push   $0xf0108954
f0105b31:	e8 6f df ff ff       	call   f0103aa5 <cprintf>
		return;
f0105b36:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b3c:	5b                   	pop    %ebx
f0105b3d:	5e                   	pop    %esi
f0105b3e:	5f                   	pop    %edi
f0105b3f:	5d                   	pop    %ebp
f0105b40:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105b41:	83 ec 04             	sub    $0x4,%esp
f0105b44:	ff 35 c4 53 23 f0    	pushl  0xf02353c4
f0105b4a:	0f b6 00             	movzbl (%eax),%eax
f0105b4d:	50                   	push   %eax
f0105b4e:	68 db 89 10 f0       	push   $0xf01089db
f0105b53:	e8 4d df ff ff       	call   f0103aa5 <cprintf>
	if (mp->imcrp) {
f0105b58:	83 c4 10             	add    $0x10,%esp
f0105b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b5e:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105b62:	74 d5                	je     f0105b39 <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105b64:	83 ec 0c             	sub    $0xc,%esp
f0105b67:	68 80 89 10 f0       	push   $0xf0108980
f0105b6c:	e8 34 df ff ff       	call   f0103aa5 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105b71:	b8 70 00 00 00       	mov    $0x70,%eax
f0105b76:	ba 22 00 00 00       	mov    $0x22,%edx
f0105b7b:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105b7c:	ba 23 00 00 00       	mov    $0x23,%edx
f0105b81:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105b82:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105b85:	ee                   	out    %al,(%dx)
f0105b86:	83 c4 10             	add    $0x10,%esp
f0105b89:	eb ae                	jmp    f0105b39 <mp_init+0x2a8>

f0105b8b <lapicw>:

physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value) {
f0105b8b:	55                   	push   %ebp
f0105b8c:	89 e5                	mov    %esp,%ebp
    lapic[index] = value;
f0105b8e:	8b 0d 04 60 27 f0    	mov    0xf0276004,%ecx
f0105b94:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105b97:	89 10                	mov    %edx,(%eax)
    lapic[ID];  // wait for write to finish, by reading
f0105b99:	a1 04 60 27 f0       	mov    0xf0276004,%eax
f0105b9e:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105ba1:	5d                   	pop    %ebp
f0105ba2:	c3                   	ret    

f0105ba3 <cpunum>:
    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}

int
cpunum(void) {
f0105ba3:	55                   	push   %ebp
f0105ba4:	89 e5                	mov    %esp,%ebp
    if (lapic)
f0105ba6:	8b 15 04 60 27 f0    	mov    0xf0276004,%edx
        return lapic[ID] >> 24;
    return 0;
f0105bac:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lapic)
f0105bb1:	85 d2                	test   %edx,%edx
f0105bb3:	74 06                	je     f0105bbb <cpunum+0x18>
        return lapic[ID] >> 24;
f0105bb5:	8b 42 20             	mov    0x20(%edx),%eax
f0105bb8:	c1 e8 18             	shr    $0x18,%eax
}
f0105bbb:	5d                   	pop    %ebp
f0105bbc:	c3                   	ret    

f0105bbd <lapic_init>:
    if (!lapicaddr)
f0105bbd:	a1 00 60 27 f0       	mov    0xf0276000,%eax
f0105bc2:	85 c0                	test   %eax,%eax
f0105bc4:	75 02                	jne    f0105bc8 <lapic_init+0xb>
f0105bc6:	f3 c3                	repz ret 
lapic_init(void) {
f0105bc8:	55                   	push   %ebp
f0105bc9:	89 e5                	mov    %esp,%ebp
f0105bcb:	83 ec 10             	sub    $0x10,%esp
    lapic = mmio_map_region(lapicaddr, 4096);
f0105bce:	68 00 10 00 00       	push   $0x1000
f0105bd3:	50                   	push   %eax
f0105bd4:	e8 8e d4 ff ff       	call   f0103067 <mmio_map_region>
f0105bd9:	a3 04 60 27 f0       	mov    %eax,0xf0276004
    lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105bde:	ba 27 01 00 00       	mov    $0x127,%edx
f0105be3:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105be8:	e8 9e ff ff ff       	call   f0105b8b <lapicw>
    lapicw(TDCR, X1);
f0105bed:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105bf2:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105bf7:	e8 8f ff ff ff       	call   f0105b8b <lapicw>
    lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105bfc:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105c01:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105c06:	e8 80 ff ff ff       	call   f0105b8b <lapicw>
    lapicw(TICR, 10000000);
f0105c0b:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105c10:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105c15:	e8 71 ff ff ff       	call   f0105b8b <lapicw>
    if (thiscpu != bootcpu)
f0105c1a:	e8 84 ff ff ff       	call   f0105ba3 <cpunum>
f0105c1f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105c22:	05 20 50 23 f0       	add    $0xf0235020,%eax
f0105c27:	83 c4 10             	add    $0x10,%esp
f0105c2a:	39 05 c0 53 23 f0    	cmp    %eax,0xf02353c0
f0105c30:	74 0f                	je     f0105c41 <lapic_init+0x84>
        lapicw(LINT0, MASKED);
f0105c32:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c37:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105c3c:	e8 4a ff ff ff       	call   f0105b8b <lapicw>
    lapicw(LINT1, MASKED);
f0105c41:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c46:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105c4b:	e8 3b ff ff ff       	call   f0105b8b <lapicw>
    if (((lapic[VER] >> 16) & 0xFF) >= 4)
f0105c50:	a1 04 60 27 f0       	mov    0xf0276004,%eax
f0105c55:	8b 40 30             	mov    0x30(%eax),%eax
f0105c58:	c1 e8 10             	shr    $0x10,%eax
f0105c5b:	3c 03                	cmp    $0x3,%al
f0105c5d:	77 7c                	ja     f0105cdb <lapic_init+0x11e>
    lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105c5f:	ba 33 00 00 00       	mov    $0x33,%edx
f0105c64:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105c69:	e8 1d ff ff ff       	call   f0105b8b <lapicw>
    lapicw(ESR, 0);
f0105c6e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105c73:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105c78:	e8 0e ff ff ff       	call   f0105b8b <lapicw>
    lapicw(ESR, 0);
f0105c7d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105c82:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105c87:	e8 ff fe ff ff       	call   f0105b8b <lapicw>
    lapicw(EOI, 0);
f0105c8c:	ba 00 00 00 00       	mov    $0x0,%edx
f0105c91:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105c96:	e8 f0 fe ff ff       	call   f0105b8b <lapicw>
    lapicw(ICRHI, 0);
f0105c9b:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ca0:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ca5:	e8 e1 fe ff ff       	call   f0105b8b <lapicw>
    lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105caa:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105caf:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105cb4:	e8 d2 fe ff ff       	call   f0105b8b <lapicw>
    while (lapic[ICRLO] & DELIVS);
f0105cb9:	8b 15 04 60 27 f0    	mov    0xf0276004,%edx
f0105cbf:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105cc5:	f6 c4 10             	test   $0x10,%ah
f0105cc8:	75 f5                	jne    f0105cbf <lapic_init+0x102>
    lapicw(TPR, 0);
f0105cca:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ccf:	b8 20 00 00 00       	mov    $0x20,%eax
f0105cd4:	e8 b2 fe ff ff       	call   f0105b8b <lapicw>
}
f0105cd9:	c9                   	leave  
f0105cda:	c3                   	ret    
        lapicw(PCINT, MASKED);
f0105cdb:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ce0:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105ce5:	e8 a1 fe ff ff       	call   f0105b8b <lapicw>
f0105cea:	e9 70 ff ff ff       	jmp    f0105c5f <lapic_init+0xa2>

f0105cef <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void) {
    if (lapic)
f0105cef:	83 3d 04 60 27 f0 00 	cmpl   $0x0,0xf0276004
f0105cf6:	74 14                	je     f0105d0c <lapic_eoi+0x1d>
lapic_eoi(void) {
f0105cf8:	55                   	push   %ebp
f0105cf9:	89 e5                	mov    %esp,%ebp
        lapicw(EOI, 0);
f0105cfb:	ba 00 00 00 00       	mov    $0x0,%edx
f0105d00:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105d05:	e8 81 fe ff ff       	call   f0105b8b <lapicw>
}
f0105d0a:	5d                   	pop    %ebp
f0105d0b:	c3                   	ret    
f0105d0c:	f3 c3                	repz ret 

f0105d0e <lapic_startap>:
#define IO_RTC  0x70

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr) {
f0105d0e:	55                   	push   %ebp
f0105d0f:	89 e5                	mov    %esp,%ebp
f0105d11:	56                   	push   %esi
f0105d12:	53                   	push   %ebx
f0105d13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    cprintf("apicid:%d\tstart\n", apicid);
f0105d16:	0f b6 75 08          	movzbl 0x8(%ebp),%esi
f0105d1a:	83 ec 08             	sub    $0x8,%esp
f0105d1d:	56                   	push   %esi
f0105d1e:	68 f8 89 10 f0       	push   $0xf01089f8
f0105d23:	e8 7d dd ff ff       	call   f0103aa5 <cprintf>
f0105d28:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105d2d:	ba 70 00 00 00       	mov    $0x70,%edx
f0105d32:	ee                   	out    %al,(%dx)
f0105d33:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105d38:	ba 71 00 00 00       	mov    $0x71,%edx
f0105d3d:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105d3e:	83 c4 10             	add    $0x10,%esp
f0105d41:	83 3d 8c 4e 23 f0 00 	cmpl   $0x0,0xf0234e8c
f0105d48:	74 7e                	je     f0105dc8 <lapic_startap+0xba>
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
    outb(IO_RTC + 1, 0x0A);
    wrv = (uint16_t *) KADDR((0x40 << 4 | 0x67));  // Warm reset vector
    wrv[0] = 0;
f0105d4a:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105d51:	00 00 
    wrv[1] = addr >> 4;
f0105d53:	89 d8                	mov    %ebx,%eax
f0105d55:	c1 e8 04             	shr    $0x4,%eax
f0105d58:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
f0105d5e:	c1 e6 18             	shl    $0x18,%esi
f0105d61:	89 f2                	mov    %esi,%edx
f0105d63:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105d68:	e8 1e fe ff ff       	call   f0105b8b <lapicw>
    lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105d6d:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105d72:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105d77:	e8 0f fe ff ff       	call   f0105b8b <lapicw>
    microdelay(200);
    lapicw(ICRLO, INIT | LEVEL);
f0105d7c:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105d81:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105d86:	e8 00 fe ff ff       	call   f0105b8b <lapicw>
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
f0105d8b:	c1 eb 0c             	shr    $0xc,%ebx
f0105d8e:	80 cf 06             	or     $0x6,%bh
        lapicw(ICRHI, apicid << 24);
f0105d91:	89 f2                	mov    %esi,%edx
f0105d93:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105d98:	e8 ee fd ff ff       	call   f0105b8b <lapicw>
        lapicw(ICRLO, STARTUP | (addr >> 12));
f0105d9d:	89 da                	mov    %ebx,%edx
f0105d9f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105da4:	e8 e2 fd ff ff       	call   f0105b8b <lapicw>
        lapicw(ICRHI, apicid << 24);
f0105da9:	89 f2                	mov    %esi,%edx
f0105dab:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105db0:	e8 d6 fd ff ff       	call   f0105b8b <lapicw>
        lapicw(ICRLO, STARTUP | (addr >> 12));
f0105db5:	89 da                	mov    %ebx,%edx
f0105db7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105dbc:	e8 ca fd ff ff       	call   f0105b8b <lapicw>
        microdelay(200);
    }
}
f0105dc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105dc4:	5b                   	pop    %ebx
f0105dc5:	5e                   	pop    %esi
f0105dc6:	5d                   	pop    %ebp
f0105dc7:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105dc8:	68 67 04 00 00       	push   $0x467
f0105dcd:	68 24 62 10 f0       	push   $0xf0106224
f0105dd2:	68 92 00 00 00       	push   $0x92
f0105dd7:	68 09 8a 10 f0       	push   $0xf0108a09
f0105ddc:	e8 5f a2 ff ff       	call   f0100040 <_panic>

f0105de1 <lapic_ipi>:

void
lapic_ipi(int vector) {
f0105de1:	55                   	push   %ebp
f0105de2:	89 e5                	mov    %esp,%ebp
    lapicw(ICRLO, OTHERS | FIXED | vector);
f0105de4:	8b 55 08             	mov    0x8(%ebp),%edx
f0105de7:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0105ded:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105df2:	e8 94 fd ff ff       	call   f0105b8b <lapicw>
    while (lapic[ICRLO] & DELIVS);
f0105df7:	8b 15 04 60 27 f0    	mov    0xf0276004,%edx
f0105dfd:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105e03:	f6 c4 10             	test   $0x10,%ah
f0105e06:	75 f5                	jne    f0105dfd <lapic_ipi+0x1c>
}
f0105e08:	5d                   	pop    %ebp
f0105e09:	c3                   	ret    

f0105e0a <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0105e0a:	55                   	push   %ebp
f0105e0b:	89 e5                	mov    %esp,%ebp
f0105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0105e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0105e16:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e19:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0105e1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0105e23:	5d                   	pop    %ebp
f0105e24:	c3                   	ret    

f0105e25 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0105e25:	55                   	push   %ebp
f0105e26:	89 e5                	mov    %esp,%ebp
f0105e28:	56                   	push   %esi
f0105e29:	53                   	push   %ebx
f0105e2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0105e2d:	83 3b 00             	cmpl   $0x0,(%ebx)
f0105e30:	75 07                	jne    f0105e39 <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0105e32:	ba 01 00 00 00       	mov    $0x1,%edx
f0105e37:	eb 34                	jmp    f0105e6d <spin_lock+0x48>
f0105e39:	8b 73 08             	mov    0x8(%ebx),%esi
f0105e3c:	e8 62 fd ff ff       	call   f0105ba3 <cpunum>
f0105e41:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e44:	05 20 50 23 f0       	add    $0xf0235020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0105e49:	39 c6                	cmp    %eax,%esi
f0105e4b:	75 e5                	jne    f0105e32 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0105e4d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0105e50:	e8 4e fd ff ff       	call   f0105ba3 <cpunum>
f0105e55:	83 ec 0c             	sub    $0xc,%esp
f0105e58:	53                   	push   %ebx
f0105e59:	50                   	push   %eax
f0105e5a:	68 18 8a 10 f0       	push   $0xf0108a18
f0105e5f:	6a 41                	push   $0x41
f0105e61:	68 7c 8a 10 f0       	push   $0xf0108a7c
f0105e66:	e8 d5 a1 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0105e6b:	f3 90                	pause  
f0105e6d:	89 d0                	mov    %edx,%eax
f0105e6f:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0105e72:	85 c0                	test   %eax,%eax
f0105e74:	75 f5                	jne    f0105e6b <spin_lock+0x46>

//    cprintf("lock kernel\n");
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0105e76:	e8 28 fd ff ff       	call   f0105ba3 <cpunum>
f0105e7b:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e7e:	05 20 50 23 f0       	add    $0xf0235020,%eax
f0105e83:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0105e86:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0105e89:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0105e8b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e90:	eb 0b                	jmp    f0105e9d <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f0105e92:	8b 4a 04             	mov    0x4(%edx),%ecx
f0105e95:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0105e98:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0105e9a:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0105e9d:	83 f8 09             	cmp    $0x9,%eax
f0105ea0:	7f 14                	jg     f0105eb6 <spin_lock+0x91>
f0105ea2:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0105ea8:	77 e8                	ja     f0105e92 <spin_lock+0x6d>
f0105eaa:	eb 0a                	jmp    f0105eb6 <spin_lock+0x91>
		pcs[i] = 0;
f0105eac:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f0105eb3:	83 c0 01             	add    $0x1,%eax
f0105eb6:	83 f8 09             	cmp    $0x9,%eax
f0105eb9:	7e f1                	jle    f0105eac <spin_lock+0x87>
#endif
}
f0105ebb:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105ebe:	5b                   	pop    %ebx
f0105ebf:	5e                   	pop    %esi
f0105ec0:	5d                   	pop    %ebp
f0105ec1:	c3                   	ret    

f0105ec2 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0105ec2:	55                   	push   %ebp
f0105ec3:	89 e5                	mov    %esp,%ebp
f0105ec5:	57                   	push   %edi
f0105ec6:	56                   	push   %esi
f0105ec7:	53                   	push   %ebx
f0105ec8:	83 ec 4c             	sub    $0x4c,%esp
f0105ecb:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0105ece:	83 3e 00             	cmpl   $0x0,(%esi)
f0105ed1:	75 35                	jne    f0105f08 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0105ed3:	83 ec 04             	sub    $0x4,%esp
f0105ed6:	6a 28                	push   $0x28
f0105ed8:	8d 46 0c             	lea    0xc(%esi),%eax
f0105edb:	50                   	push   %eax
f0105edc:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0105edf:	53                   	push   %ebx
f0105ee0:	e8 e8 f6 ff ff       	call   f01055cd <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0105ee5:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0105ee8:	0f b6 38             	movzbl (%eax),%edi
f0105eeb:	8b 76 04             	mov    0x4(%esi),%esi
f0105eee:	e8 b0 fc ff ff       	call   f0105ba3 <cpunum>
f0105ef3:	57                   	push   %edi
f0105ef4:	56                   	push   %esi
f0105ef5:	50                   	push   %eax
f0105ef6:	68 44 8a 10 f0       	push   $0xf0108a44
f0105efb:	e8 a5 db ff ff       	call   f0103aa5 <cprintf>
f0105f00:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105f03:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0105f06:	eb 61                	jmp    f0105f69 <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f0105f08:	8b 5e 08             	mov    0x8(%esi),%ebx
f0105f0b:	e8 93 fc ff ff       	call   f0105ba3 <cpunum>
f0105f10:	6b c0 74             	imul   $0x74,%eax,%eax
f0105f13:	05 20 50 23 f0       	add    $0xf0235020,%eax
	if (!holding(lk)) {
f0105f18:	39 c3                	cmp    %eax,%ebx
f0105f1a:	75 b7                	jne    f0105ed3 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0105f1c:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0105f23:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0105f2a:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f2f:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0105f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105f35:	5b                   	pop    %ebx
f0105f36:	5e                   	pop    %esi
f0105f37:	5f                   	pop    %edi
f0105f38:	5d                   	pop    %ebp
f0105f39:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f0105f3a:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0105f3c:	83 ec 04             	sub    $0x4,%esp
f0105f3f:	89 c2                	mov    %eax,%edx
f0105f41:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0105f44:	52                   	push   %edx
f0105f45:	ff 75 b0             	pushl  -0x50(%ebp)
f0105f48:	ff 75 b4             	pushl  -0x4c(%ebp)
f0105f4b:	ff 75 ac             	pushl  -0x54(%ebp)
f0105f4e:	ff 75 a8             	pushl  -0x58(%ebp)
f0105f51:	50                   	push   %eax
f0105f52:	68 8c 8a 10 f0       	push   $0xf0108a8c
f0105f57:	e8 49 db ff ff       	call   f0103aa5 <cprintf>
f0105f5c:	83 c4 20             	add    $0x20,%esp
f0105f5f:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0105f62:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0105f65:	39 c3                	cmp    %eax,%ebx
f0105f67:	74 2d                	je     f0105f96 <spin_unlock+0xd4>
f0105f69:	89 de                	mov    %ebx,%esi
f0105f6b:	8b 03                	mov    (%ebx),%eax
f0105f6d:	85 c0                	test   %eax,%eax
f0105f6f:	74 25                	je     f0105f96 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105f71:	83 ec 08             	sub    $0x8,%esp
f0105f74:	57                   	push   %edi
f0105f75:	50                   	push   %eax
f0105f76:	e8 6d eb ff ff       	call   f0104ae8 <debuginfo_eip>
f0105f7b:	83 c4 10             	add    $0x10,%esp
f0105f7e:	85 c0                	test   %eax,%eax
f0105f80:	79 b8                	jns    f0105f3a <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f0105f82:	83 ec 08             	sub    $0x8,%esp
f0105f85:	ff 36                	pushl  (%esi)
f0105f87:	68 a3 8a 10 f0       	push   $0xf0108aa3
f0105f8c:	e8 14 db ff ff       	call   f0103aa5 <cprintf>
f0105f91:	83 c4 10             	add    $0x10,%esp
f0105f94:	eb c9                	jmp    f0105f5f <spin_unlock+0x9d>
		panic("spin_unlock");
f0105f96:	83 ec 04             	sub    $0x4,%esp
f0105f99:	68 ab 8a 10 f0       	push   $0xf0108aab
f0105f9e:	6a 68                	push   $0x68
f0105fa0:	68 7c 8a 10 f0       	push   $0xf0108a7c
f0105fa5:	e8 96 a0 ff ff       	call   f0100040 <_panic>
f0105faa:	66 90                	xchg   %ax,%ax
f0105fac:	66 90                	xchg   %ax,%ax
f0105fae:	66 90                	xchg   %ax,%ax

f0105fb0 <__udivdi3>:
f0105fb0:	55                   	push   %ebp
f0105fb1:	57                   	push   %edi
f0105fb2:	56                   	push   %esi
f0105fb3:	53                   	push   %ebx
f0105fb4:	83 ec 1c             	sub    $0x1c,%esp
f0105fb7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0105fbb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0105fbf:	8b 74 24 34          	mov    0x34(%esp),%esi
f0105fc3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0105fc7:	85 d2                	test   %edx,%edx
f0105fc9:	75 35                	jne    f0106000 <__udivdi3+0x50>
f0105fcb:	39 f3                	cmp    %esi,%ebx
f0105fcd:	0f 87 bd 00 00 00    	ja     f0106090 <__udivdi3+0xe0>
f0105fd3:	85 db                	test   %ebx,%ebx
f0105fd5:	89 d9                	mov    %ebx,%ecx
f0105fd7:	75 0b                	jne    f0105fe4 <__udivdi3+0x34>
f0105fd9:	b8 01 00 00 00       	mov    $0x1,%eax
f0105fde:	31 d2                	xor    %edx,%edx
f0105fe0:	f7 f3                	div    %ebx
f0105fe2:	89 c1                	mov    %eax,%ecx
f0105fe4:	31 d2                	xor    %edx,%edx
f0105fe6:	89 f0                	mov    %esi,%eax
f0105fe8:	f7 f1                	div    %ecx
f0105fea:	89 c6                	mov    %eax,%esi
f0105fec:	89 e8                	mov    %ebp,%eax
f0105fee:	89 f7                	mov    %esi,%edi
f0105ff0:	f7 f1                	div    %ecx
f0105ff2:	89 fa                	mov    %edi,%edx
f0105ff4:	83 c4 1c             	add    $0x1c,%esp
f0105ff7:	5b                   	pop    %ebx
f0105ff8:	5e                   	pop    %esi
f0105ff9:	5f                   	pop    %edi
f0105ffa:	5d                   	pop    %ebp
f0105ffb:	c3                   	ret    
f0105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106000:	39 f2                	cmp    %esi,%edx
f0106002:	77 7c                	ja     f0106080 <__udivdi3+0xd0>
f0106004:	0f bd fa             	bsr    %edx,%edi
f0106007:	83 f7 1f             	xor    $0x1f,%edi
f010600a:	0f 84 98 00 00 00    	je     f01060a8 <__udivdi3+0xf8>
f0106010:	89 f9                	mov    %edi,%ecx
f0106012:	b8 20 00 00 00       	mov    $0x20,%eax
f0106017:	29 f8                	sub    %edi,%eax
f0106019:	d3 e2                	shl    %cl,%edx
f010601b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010601f:	89 c1                	mov    %eax,%ecx
f0106021:	89 da                	mov    %ebx,%edx
f0106023:	d3 ea                	shr    %cl,%edx
f0106025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106029:	09 d1                	or     %edx,%ecx
f010602b:	89 f2                	mov    %esi,%edx
f010602d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106031:	89 f9                	mov    %edi,%ecx
f0106033:	d3 e3                	shl    %cl,%ebx
f0106035:	89 c1                	mov    %eax,%ecx
f0106037:	d3 ea                	shr    %cl,%edx
f0106039:	89 f9                	mov    %edi,%ecx
f010603b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010603f:	d3 e6                	shl    %cl,%esi
f0106041:	89 eb                	mov    %ebp,%ebx
f0106043:	89 c1                	mov    %eax,%ecx
f0106045:	d3 eb                	shr    %cl,%ebx
f0106047:	09 de                	or     %ebx,%esi
f0106049:	89 f0                	mov    %esi,%eax
f010604b:	f7 74 24 08          	divl   0x8(%esp)
f010604f:	89 d6                	mov    %edx,%esi
f0106051:	89 c3                	mov    %eax,%ebx
f0106053:	f7 64 24 0c          	mull   0xc(%esp)
f0106057:	39 d6                	cmp    %edx,%esi
f0106059:	72 0c                	jb     f0106067 <__udivdi3+0xb7>
f010605b:	89 f9                	mov    %edi,%ecx
f010605d:	d3 e5                	shl    %cl,%ebp
f010605f:	39 c5                	cmp    %eax,%ebp
f0106061:	73 5d                	jae    f01060c0 <__udivdi3+0x110>
f0106063:	39 d6                	cmp    %edx,%esi
f0106065:	75 59                	jne    f01060c0 <__udivdi3+0x110>
f0106067:	8d 43 ff             	lea    -0x1(%ebx),%eax
f010606a:	31 ff                	xor    %edi,%edi
f010606c:	89 fa                	mov    %edi,%edx
f010606e:	83 c4 1c             	add    $0x1c,%esp
f0106071:	5b                   	pop    %ebx
f0106072:	5e                   	pop    %esi
f0106073:	5f                   	pop    %edi
f0106074:	5d                   	pop    %ebp
f0106075:	c3                   	ret    
f0106076:	8d 76 00             	lea    0x0(%esi),%esi
f0106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0106080:	31 ff                	xor    %edi,%edi
f0106082:	31 c0                	xor    %eax,%eax
f0106084:	89 fa                	mov    %edi,%edx
f0106086:	83 c4 1c             	add    $0x1c,%esp
f0106089:	5b                   	pop    %ebx
f010608a:	5e                   	pop    %esi
f010608b:	5f                   	pop    %edi
f010608c:	5d                   	pop    %ebp
f010608d:	c3                   	ret    
f010608e:	66 90                	xchg   %ax,%ax
f0106090:	31 ff                	xor    %edi,%edi
f0106092:	89 e8                	mov    %ebp,%eax
f0106094:	89 f2                	mov    %esi,%edx
f0106096:	f7 f3                	div    %ebx
f0106098:	89 fa                	mov    %edi,%edx
f010609a:	83 c4 1c             	add    $0x1c,%esp
f010609d:	5b                   	pop    %ebx
f010609e:	5e                   	pop    %esi
f010609f:	5f                   	pop    %edi
f01060a0:	5d                   	pop    %ebp
f01060a1:	c3                   	ret    
f01060a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01060a8:	39 f2                	cmp    %esi,%edx
f01060aa:	72 06                	jb     f01060b2 <__udivdi3+0x102>
f01060ac:	31 c0                	xor    %eax,%eax
f01060ae:	39 eb                	cmp    %ebp,%ebx
f01060b0:	77 d2                	ja     f0106084 <__udivdi3+0xd4>
f01060b2:	b8 01 00 00 00       	mov    $0x1,%eax
f01060b7:	eb cb                	jmp    f0106084 <__udivdi3+0xd4>
f01060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01060c0:	89 d8                	mov    %ebx,%eax
f01060c2:	31 ff                	xor    %edi,%edi
f01060c4:	eb be                	jmp    f0106084 <__udivdi3+0xd4>
f01060c6:	66 90                	xchg   %ax,%ax
f01060c8:	66 90                	xchg   %ax,%ax
f01060ca:	66 90                	xchg   %ax,%ax
f01060cc:	66 90                	xchg   %ax,%ax
f01060ce:	66 90                	xchg   %ax,%ax

f01060d0 <__umoddi3>:
f01060d0:	55                   	push   %ebp
f01060d1:	57                   	push   %edi
f01060d2:	56                   	push   %esi
f01060d3:	53                   	push   %ebx
f01060d4:	83 ec 1c             	sub    $0x1c,%esp
f01060d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f01060db:	8b 74 24 30          	mov    0x30(%esp),%esi
f01060df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01060e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01060e7:	85 ed                	test   %ebp,%ebp
f01060e9:	89 f0                	mov    %esi,%eax
f01060eb:	89 da                	mov    %ebx,%edx
f01060ed:	75 19                	jne    f0106108 <__umoddi3+0x38>
f01060ef:	39 df                	cmp    %ebx,%edi
f01060f1:	0f 86 b1 00 00 00    	jbe    f01061a8 <__umoddi3+0xd8>
f01060f7:	f7 f7                	div    %edi
f01060f9:	89 d0                	mov    %edx,%eax
f01060fb:	31 d2                	xor    %edx,%edx
f01060fd:	83 c4 1c             	add    $0x1c,%esp
f0106100:	5b                   	pop    %ebx
f0106101:	5e                   	pop    %esi
f0106102:	5f                   	pop    %edi
f0106103:	5d                   	pop    %ebp
f0106104:	c3                   	ret    
f0106105:	8d 76 00             	lea    0x0(%esi),%esi
f0106108:	39 dd                	cmp    %ebx,%ebp
f010610a:	77 f1                	ja     f01060fd <__umoddi3+0x2d>
f010610c:	0f bd cd             	bsr    %ebp,%ecx
f010610f:	83 f1 1f             	xor    $0x1f,%ecx
f0106112:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106116:	0f 84 b4 00 00 00    	je     f01061d0 <__umoddi3+0x100>
f010611c:	b8 20 00 00 00       	mov    $0x20,%eax
f0106121:	89 c2                	mov    %eax,%edx
f0106123:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106127:	29 c2                	sub    %eax,%edx
f0106129:	89 c1                	mov    %eax,%ecx
f010612b:	89 f8                	mov    %edi,%eax
f010612d:	d3 e5                	shl    %cl,%ebp
f010612f:	89 d1                	mov    %edx,%ecx
f0106131:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106135:	d3 e8                	shr    %cl,%eax
f0106137:	09 c5                	or     %eax,%ebp
f0106139:	8b 44 24 04          	mov    0x4(%esp),%eax
f010613d:	89 c1                	mov    %eax,%ecx
f010613f:	d3 e7                	shl    %cl,%edi
f0106141:	89 d1                	mov    %edx,%ecx
f0106143:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106147:	89 df                	mov    %ebx,%edi
f0106149:	d3 ef                	shr    %cl,%edi
f010614b:	89 c1                	mov    %eax,%ecx
f010614d:	89 f0                	mov    %esi,%eax
f010614f:	d3 e3                	shl    %cl,%ebx
f0106151:	89 d1                	mov    %edx,%ecx
f0106153:	89 fa                	mov    %edi,%edx
f0106155:	d3 e8                	shr    %cl,%eax
f0106157:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010615c:	09 d8                	or     %ebx,%eax
f010615e:	f7 f5                	div    %ebp
f0106160:	d3 e6                	shl    %cl,%esi
f0106162:	89 d1                	mov    %edx,%ecx
f0106164:	f7 64 24 08          	mull   0x8(%esp)
f0106168:	39 d1                	cmp    %edx,%ecx
f010616a:	89 c3                	mov    %eax,%ebx
f010616c:	89 d7                	mov    %edx,%edi
f010616e:	72 06                	jb     f0106176 <__umoddi3+0xa6>
f0106170:	75 0e                	jne    f0106180 <__umoddi3+0xb0>
f0106172:	39 c6                	cmp    %eax,%esi
f0106174:	73 0a                	jae    f0106180 <__umoddi3+0xb0>
f0106176:	2b 44 24 08          	sub    0x8(%esp),%eax
f010617a:	19 ea                	sbb    %ebp,%edx
f010617c:	89 d7                	mov    %edx,%edi
f010617e:	89 c3                	mov    %eax,%ebx
f0106180:	89 ca                	mov    %ecx,%edx
f0106182:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0106187:	29 de                	sub    %ebx,%esi
f0106189:	19 fa                	sbb    %edi,%edx
f010618b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f010618f:	89 d0                	mov    %edx,%eax
f0106191:	d3 e0                	shl    %cl,%eax
f0106193:	89 d9                	mov    %ebx,%ecx
f0106195:	d3 ee                	shr    %cl,%esi
f0106197:	d3 ea                	shr    %cl,%edx
f0106199:	09 f0                	or     %esi,%eax
f010619b:	83 c4 1c             	add    $0x1c,%esp
f010619e:	5b                   	pop    %ebx
f010619f:	5e                   	pop    %esi
f01061a0:	5f                   	pop    %edi
f01061a1:	5d                   	pop    %ebp
f01061a2:	c3                   	ret    
f01061a3:	90                   	nop
f01061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01061a8:	85 ff                	test   %edi,%edi
f01061aa:	89 f9                	mov    %edi,%ecx
f01061ac:	75 0b                	jne    f01061b9 <__umoddi3+0xe9>
f01061ae:	b8 01 00 00 00       	mov    $0x1,%eax
f01061b3:	31 d2                	xor    %edx,%edx
f01061b5:	f7 f7                	div    %edi
f01061b7:	89 c1                	mov    %eax,%ecx
f01061b9:	89 d8                	mov    %ebx,%eax
f01061bb:	31 d2                	xor    %edx,%edx
f01061bd:	f7 f1                	div    %ecx
f01061bf:	89 f0                	mov    %esi,%eax
f01061c1:	f7 f1                	div    %ecx
f01061c3:	e9 31 ff ff ff       	jmp    f01060f9 <__umoddi3+0x29>
f01061c8:	90                   	nop
f01061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01061d0:	39 dd                	cmp    %ebx,%ebp
f01061d2:	72 08                	jb     f01061dc <__umoddi3+0x10c>
f01061d4:	39 f7                	cmp    %esi,%edi
f01061d6:	0f 87 21 ff ff ff    	ja     f01060fd <__umoddi3+0x2d>
f01061dc:	89 da                	mov    %ebx,%edx
f01061de:	89 f0                	mov    %esi,%eax
f01061e0:	29 f8                	sub    %edi,%eax
f01061e2:	19 ea                	sbb    %ebp,%edx
f01061e4:	e9 14 ff ff ff       	jmp    f01060fd <__umoddi3+0x2d>
