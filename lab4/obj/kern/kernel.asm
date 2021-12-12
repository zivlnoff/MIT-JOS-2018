
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
f0100015:	b8 00 f0 11 00       	mov    $0x11f000,%eax
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
f0100034:	bc 00 f0 11 f0       	mov    $0xf011f000,%esp

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
f0100048:	83 3d 04 cf 22 f0 00 	cmpl   $0x0,0xf022cf04
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 7f 08 00 00       	call   f01008da <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 04 cf 22 f0    	mov    %esi,0xf022cf04
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 4f 54 00 00       	call   f01054bf <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 00 5b 10 f0       	push   $0xf0105b00
f010007c:	e8 af 3a 00 00       	call   f0103b30 <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 7f 3a 00 00       	call   f0103b0a <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 26 72 10 f0 	movl   $0xf0107226,(%esp)
f0100092:	e8 99 3a 00 00       	call   f0103b30 <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 82 05 00 00       	call   f010062a <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 6c 5b 10 f0       	push   $0xf0105b6c
f01000b5:	e8 76 3a 00 00       	call   f0103b30 <cprintf>
	mem_init();
f01000ba:	e8 bf 12 00 00       	call   f010137e <mem_init>
	env_init();
f01000bf:	e8 0c 32 00 00       	call   f01032d0 <env_init>
	trap_init();
f01000c4:	e8 18 3b 00 00       	call   f0103be1 <trap_init>
	mp_init();
f01000c9:	e8 df 50 00 00       	call   f01051ad <mp_init>
	lapic_init();
f01000ce:	e8 06 54 00 00       	call   f01054d9 <lapic_init>
	pic_init();
f01000d3:	e8 7b 39 00 00       	call   f0103a53 <pic_init>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000d8:	83 c4 10             	add    $0x10,%esp
f01000db:	83 3d 0c cf 22 f0 07 	cmpl   $0x7,0xf022cf0c
f01000e2:	76 27                	jbe    f010010b <i386_init+0x6f>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000e4:	83 ec 04             	sub    $0x4,%esp
f01000e7:	b8 12 51 10 f0       	mov    $0xf0105112,%eax
f01000ec:	2d 98 50 10 f0       	sub    $0xf0105098,%eax
f01000f1:	50                   	push   %eax
f01000f2:	68 98 50 10 f0       	push   $0xf0105098
f01000f7:	68 00 70 00 f0       	push   $0xf0007000
f01000fc:	e8 e6 4d 00 00       	call   f0104ee7 <memmove>
f0100101:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100104:	bb 20 d0 22 f0       	mov    $0xf022d020,%ebx
f0100109:	eb 19                	jmp    f0100124 <i386_init+0x88>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010010b:	68 00 70 00 00       	push   $0x7000
f0100110:	68 24 5b 10 f0       	push   $0xf0105b24
f0100115:	6a 4c                	push   $0x4c
f0100117:	68 87 5b 10 f0       	push   $0xf0105b87
f010011c:	e8 1f ff ff ff       	call   f0100040 <_panic>
f0100121:	83 c3 74             	add    $0x74,%ebx
f0100124:	6b 05 c4 d3 22 f0 74 	imul   $0x74,0xf022d3c4,%eax
f010012b:	05 20 d0 22 f0       	add    $0xf022d020,%eax
f0100130:	39 c3                	cmp    %eax,%ebx
f0100132:	73 4c                	jae    f0100180 <i386_init+0xe4>
		if (c == cpus + cpunum())  // We've started already.
f0100134:	e8 86 53 00 00       	call   f01054bf <cpunum>
f0100139:	6b c0 74             	imul   $0x74,%eax,%eax
f010013c:	05 20 d0 22 f0       	add    $0xf022d020,%eax
f0100141:	39 c3                	cmp    %eax,%ebx
f0100143:	74 dc                	je     f0100121 <i386_init+0x85>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100145:	89 d8                	mov    %ebx,%eax
f0100147:	2d 20 d0 22 f0       	sub    $0xf022d020,%eax
f010014c:	c1 f8 02             	sar    $0x2,%eax
f010014f:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100155:	c1 e0 0f             	shl    $0xf,%eax
f0100158:	05 00 60 23 f0       	add    $0xf0236000,%eax
f010015d:	a3 08 cf 22 f0       	mov    %eax,0xf022cf08
		lapic_startap(c->cpu_id, PADDR(code));
f0100162:	83 ec 08             	sub    $0x8,%esp
f0100165:	68 00 70 00 00       	push   $0x7000
f010016a:	0f b6 03             	movzbl (%ebx),%eax
f010016d:	50                   	push   %eax
f010016e:	e8 b7 54 00 00       	call   f010562a <lapic_startap>
f0100173:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f0100176:	8b 43 04             	mov    0x4(%ebx),%eax
f0100179:	83 f8 01             	cmp    $0x1,%eax
f010017c:	75 f8                	jne    f0100176 <i386_init+0xda>
f010017e:	eb a1                	jmp    f0100121 <i386_init+0x85>
	ENV_CREATE(user_primes, ENV_TYPE_USER);
f0100180:	83 ec 08             	sub    $0x8,%esp
f0100183:	6a 00                	push   $0x0
f0100185:	68 b8 28 22 f0       	push   $0xf02228b8
f010018a:	e8 7a 33 00 00       	call   f0103509 <env_create>
	sched_yield();
f010018f:	e8 57 41 00 00       	call   f01042eb <sched_yield>

f0100194 <mp_main>:
{
f0100194:	55                   	push   %ebp
f0100195:	89 e5                	mov    %esp,%ebp
f0100197:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f010019a:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f010019f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001a4:	77 12                	ja     f01001b8 <mp_main+0x24>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01001a6:	50                   	push   %eax
f01001a7:	68 48 5b 10 f0       	push   $0xf0105b48
f01001ac:	6a 63                	push   $0x63
f01001ae:	68 87 5b 10 f0       	push   $0xf0105b87
f01001b3:	e8 88 fe ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01001b8:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001bd:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001c0:	e8 fa 52 00 00       	call   f01054bf <cpunum>
f01001c5:	83 ec 08             	sub    $0x8,%esp
f01001c8:	50                   	push   %eax
f01001c9:	68 93 5b 10 f0       	push   $0xf0105b93
f01001ce:	e8 5d 39 00 00       	call   f0103b30 <cprintf>
	lapic_init();
f01001d3:	e8 01 53 00 00       	call   f01054d9 <lapic_init>
	env_init_percpu();
f01001d8:	e8 c3 30 00 00       	call   f01032a0 <env_init_percpu>
	trap_init_percpu();
f01001dd:	e8 83 39 00 00       	call   f0103b65 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001e2:	e8 d8 52 00 00       	call   f01054bf <cpunum>
f01001e7:	6b d0 74             	imul   $0x74,%eax,%edx
f01001ea:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01001ed:	b8 01 00 00 00       	mov    $0x1,%eax
f01001f2:	f0 87 82 20 d0 22 f0 	lock xchg %eax,-0xfdd2fe0(%edx)
f01001f9:	83 c4 10             	add    $0x10,%esp
f01001fc:	eb fe                	jmp    f01001fc <mp_main+0x68>

f01001fe <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01001fe:	55                   	push   %ebp
f01001ff:	89 e5                	mov    %esp,%ebp
f0100201:	53                   	push   %ebx
f0100202:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100205:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100208:	ff 75 0c             	pushl  0xc(%ebp)
f010020b:	ff 75 08             	pushl  0x8(%ebp)
f010020e:	68 a9 5b 10 f0       	push   $0xf0105ba9
f0100213:	e8 18 39 00 00       	call   f0103b30 <cprintf>
	vcprintf(fmt, ap);
f0100218:	83 c4 08             	add    $0x8,%esp
f010021b:	53                   	push   %ebx
f010021c:	ff 75 10             	pushl  0x10(%ebp)
f010021f:	e8 e6 38 00 00       	call   f0103b0a <vcprintf>
	cprintf("\n");
f0100224:	c7 04 24 26 72 10 f0 	movl   $0xf0107226,(%esp)
f010022b:	e8 00 39 00 00       	call   f0103b30 <cprintf>
	va_end(ap);
}
f0100230:	83 c4 10             	add    $0x10,%esp
f0100233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100236:	c9                   	leave  
f0100237:	c3                   	ret    

f0100238 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100238:	55                   	push   %ebp
f0100239:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010023b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100240:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100241:	a8 01                	test   $0x1,%al
f0100243:	74 0b                	je     f0100250 <serial_proc_data+0x18>
f0100245:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010024a:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010024b:	0f b6 c0             	movzbl %al,%eax
}
f010024e:	5d                   	pop    %ebp
f010024f:	c3                   	ret    
		return -1;
f0100250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100255:	eb f7                	jmp    f010024e <serial_proc_data+0x16>

f0100257 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100257:	55                   	push   %ebp
f0100258:	89 e5                	mov    %esp,%ebp
f010025a:	53                   	push   %ebx
f010025b:	83 ec 04             	sub    $0x4,%esp
f010025e:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100260:	ff d3                	call   *%ebx
f0100262:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100265:	74 2d                	je     f0100294 <cons_intr+0x3d>
		if (c == 0)
f0100267:	85 c0                	test   %eax,%eax
f0100269:	74 f5                	je     f0100260 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f010026b:	8b 0d 24 c2 22 f0    	mov    0xf022c224,%ecx
f0100271:	8d 51 01             	lea    0x1(%ecx),%edx
f0100274:	89 15 24 c2 22 f0    	mov    %edx,0xf022c224
f010027a:	88 81 20 c0 22 f0    	mov    %al,-0xfdd3fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100280:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0100286:	75 d8                	jne    f0100260 <cons_intr+0x9>
			cons.wpos = 0;
f0100288:	c7 05 24 c2 22 f0 00 	movl   $0x0,0xf022c224
f010028f:	00 00 00 
f0100292:	eb cc                	jmp    f0100260 <cons_intr+0x9>
	}
}
f0100294:	83 c4 04             	add    $0x4,%esp
f0100297:	5b                   	pop    %ebx
f0100298:	5d                   	pop    %ebp
f0100299:	c3                   	ret    

f010029a <kbd_proc_data>:
{
f010029a:	55                   	push   %ebp
f010029b:	89 e5                	mov    %esp,%ebp
f010029d:	53                   	push   %ebx
f010029e:	83 ec 04             	sub    $0x4,%esp
f01002a1:	ba 64 00 00 00       	mov    $0x64,%edx
f01002a6:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002a7:	a8 01                	test   $0x1,%al
f01002a9:	0f 84 fa 00 00 00    	je     f01003a9 <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01002af:	a8 20                	test   $0x20,%al
f01002b1:	0f 85 f9 00 00 00    	jne    f01003b0 <kbd_proc_data+0x116>
f01002b7:	ba 60 00 00 00       	mov    $0x60,%edx
f01002bc:	ec                   	in     (%dx),%al
f01002bd:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002bf:	3c e0                	cmp    $0xe0,%al
f01002c1:	0f 84 8e 00 00 00    	je     f0100355 <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f01002c7:	84 c0                	test   %al,%al
f01002c9:	0f 88 99 00 00 00    	js     f0100368 <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f01002cf:	8b 0d 00 c0 22 f0    	mov    0xf022c000,%ecx
f01002d5:	f6 c1 40             	test   $0x40,%cl
f01002d8:	74 0e                	je     f01002e8 <kbd_proc_data+0x4e>
		data |= 0x80;
f01002da:	83 c8 80             	or     $0xffffff80,%eax
f01002dd:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002df:	83 e1 bf             	and    $0xffffffbf,%ecx
f01002e2:	89 0d 00 c0 22 f0    	mov    %ecx,0xf022c000
	shift |= shiftcode[data];
f01002e8:	0f b6 d2             	movzbl %dl,%edx
f01002eb:	0f b6 82 20 5d 10 f0 	movzbl -0xfefa2e0(%edx),%eax
f01002f2:	0b 05 00 c0 22 f0    	or     0xf022c000,%eax
	shift ^= togglecode[data];
f01002f8:	0f b6 8a 20 5c 10 f0 	movzbl -0xfefa3e0(%edx),%ecx
f01002ff:	31 c8                	xor    %ecx,%eax
f0100301:	a3 00 c0 22 f0       	mov    %eax,0xf022c000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100306:	89 c1                	mov    %eax,%ecx
f0100308:	83 e1 03             	and    $0x3,%ecx
f010030b:	8b 0c 8d 00 5c 10 f0 	mov    -0xfefa400(,%ecx,4),%ecx
f0100312:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100316:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100319:	a8 08                	test   $0x8,%al
f010031b:	74 0d                	je     f010032a <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f010031d:	89 da                	mov    %ebx,%edx
f010031f:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100322:	83 f9 19             	cmp    $0x19,%ecx
f0100325:	77 74                	ja     f010039b <kbd_proc_data+0x101>
			c += 'A' - 'a';
f0100327:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010032a:	f7 d0                	not    %eax
f010032c:	a8 06                	test   $0x6,%al
f010032e:	75 31                	jne    f0100361 <kbd_proc_data+0xc7>
f0100330:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100336:	75 29                	jne    f0100361 <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f0100338:	83 ec 0c             	sub    $0xc,%esp
f010033b:	68 c3 5b 10 f0       	push   $0xf0105bc3
f0100340:	e8 eb 37 00 00       	call   f0103b30 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100345:	b8 03 00 00 00       	mov    $0x3,%eax
f010034a:	ba 92 00 00 00       	mov    $0x92,%edx
f010034f:	ee                   	out    %al,(%dx)
f0100350:	83 c4 10             	add    $0x10,%esp
f0100353:	eb 0c                	jmp    f0100361 <kbd_proc_data+0xc7>
		shift |= E0ESC;
f0100355:	83 0d 00 c0 22 f0 40 	orl    $0x40,0xf022c000
		return 0;
f010035c:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100361:	89 d8                	mov    %ebx,%eax
f0100363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100366:	c9                   	leave  
f0100367:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100368:	8b 0d 00 c0 22 f0    	mov    0xf022c000,%ecx
f010036e:	89 cb                	mov    %ecx,%ebx
f0100370:	83 e3 40             	and    $0x40,%ebx
f0100373:	83 e0 7f             	and    $0x7f,%eax
f0100376:	85 db                	test   %ebx,%ebx
f0100378:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010037b:	0f b6 d2             	movzbl %dl,%edx
f010037e:	0f b6 82 20 5d 10 f0 	movzbl -0xfefa2e0(%edx),%eax
f0100385:	83 c8 40             	or     $0x40,%eax
f0100388:	0f b6 c0             	movzbl %al,%eax
f010038b:	f7 d0                	not    %eax
f010038d:	21 c8                	and    %ecx,%eax
f010038f:	a3 00 c0 22 f0       	mov    %eax,0xf022c000
		return 0;
f0100394:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100399:	eb c6                	jmp    f0100361 <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f010039b:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f010039e:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003a1:	83 fa 1a             	cmp    $0x1a,%edx
f01003a4:	0f 42 d9             	cmovb  %ecx,%ebx
f01003a7:	eb 81                	jmp    f010032a <kbd_proc_data+0x90>
		return -1;
f01003a9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003ae:	eb b1                	jmp    f0100361 <kbd_proc_data+0xc7>
		return -1;
f01003b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003b5:	eb aa                	jmp    f0100361 <kbd_proc_data+0xc7>

f01003b7 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003b7:	55                   	push   %ebp
f01003b8:	89 e5                	mov    %esp,%ebp
f01003ba:	57                   	push   %edi
f01003bb:	56                   	push   %esi
f01003bc:	53                   	push   %ebx
f01003bd:	83 ec 1c             	sub    $0x1c,%esp
f01003c0:	89 c7                	mov    %eax,%edi
	for (i = 0;
f01003c2:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003c7:	be fd 03 00 00       	mov    $0x3fd,%esi
f01003cc:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003d1:	eb 09                	jmp    f01003dc <cons_putc+0x25>
f01003d3:	89 ca                	mov    %ecx,%edx
f01003d5:	ec                   	in     (%dx),%al
f01003d6:	ec                   	in     (%dx),%al
f01003d7:	ec                   	in     (%dx),%al
f01003d8:	ec                   	in     (%dx),%al
	     i++)
f01003d9:	83 c3 01             	add    $0x1,%ebx
f01003dc:	89 f2                	mov    %esi,%edx
f01003de:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01003df:	a8 20                	test   $0x20,%al
f01003e1:	75 08                	jne    f01003eb <cons_putc+0x34>
f01003e3:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01003e9:	7e e8                	jle    f01003d3 <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f01003eb:	89 f8                	mov    %edi,%eax
f01003ed:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003f0:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01003f5:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003f6:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003fb:	be 79 03 00 00       	mov    $0x379,%esi
f0100400:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100405:	eb 09                	jmp    f0100410 <cons_putc+0x59>
f0100407:	89 ca                	mov    %ecx,%edx
f0100409:	ec                   	in     (%dx),%al
f010040a:	ec                   	in     (%dx),%al
f010040b:	ec                   	in     (%dx),%al
f010040c:	ec                   	in     (%dx),%al
f010040d:	83 c3 01             	add    $0x1,%ebx
f0100410:	89 f2                	mov    %esi,%edx
f0100412:	ec                   	in     (%dx),%al
f0100413:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100419:	7f 04                	jg     f010041f <cons_putc+0x68>
f010041b:	84 c0                	test   %al,%al
f010041d:	79 e8                	jns    f0100407 <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010041f:	ba 78 03 00 00       	mov    $0x378,%edx
f0100424:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100428:	ee                   	out    %al,(%dx)
f0100429:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010042e:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100433:	ee                   	out    %al,(%dx)
f0100434:	b8 08 00 00 00       	mov    $0x8,%eax
f0100439:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010043a:	89 fa                	mov    %edi,%edx
f010043c:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100442:	89 f8                	mov    %edi,%eax
f0100444:	80 cc 07             	or     $0x7,%ah
f0100447:	85 d2                	test   %edx,%edx
f0100449:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f010044c:	89 f8                	mov    %edi,%eax
f010044e:	0f b6 c0             	movzbl %al,%eax
f0100451:	83 f8 09             	cmp    $0x9,%eax
f0100454:	0f 84 b6 00 00 00    	je     f0100510 <cons_putc+0x159>
f010045a:	83 f8 09             	cmp    $0x9,%eax
f010045d:	7e 73                	jle    f01004d2 <cons_putc+0x11b>
f010045f:	83 f8 0a             	cmp    $0xa,%eax
f0100462:	0f 84 9b 00 00 00    	je     f0100503 <cons_putc+0x14c>
f0100468:	83 f8 0d             	cmp    $0xd,%eax
f010046b:	0f 85 d6 00 00 00    	jne    f0100547 <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f0100471:	0f b7 05 28 c2 22 f0 	movzwl 0xf022c228,%eax
f0100478:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010047e:	c1 e8 16             	shr    $0x16,%eax
f0100481:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100484:	c1 e0 04             	shl    $0x4,%eax
f0100487:	66 a3 28 c2 22 f0    	mov    %ax,0xf022c228
	if (crt_pos >= CRT_SIZE) {
f010048d:	66 81 3d 28 c2 22 f0 	cmpw   $0x7cf,0xf022c228
f0100494:	cf 07 
f0100496:	0f 87 ce 00 00 00    	ja     f010056a <cons_putc+0x1b3>
	outb(addr_6845, 14);
f010049c:	8b 0d 30 c2 22 f0    	mov    0xf022c230,%ecx
f01004a2:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004a7:	89 ca                	mov    %ecx,%edx
f01004a9:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004aa:	0f b7 1d 28 c2 22 f0 	movzwl 0xf022c228,%ebx
f01004b1:	8d 71 01             	lea    0x1(%ecx),%esi
f01004b4:	89 d8                	mov    %ebx,%eax
f01004b6:	66 c1 e8 08          	shr    $0x8,%ax
f01004ba:	89 f2                	mov    %esi,%edx
f01004bc:	ee                   	out    %al,(%dx)
f01004bd:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004c2:	89 ca                	mov    %ecx,%edx
f01004c4:	ee                   	out    %al,(%dx)
f01004c5:	89 d8                	mov    %ebx,%eax
f01004c7:	89 f2                	mov    %esi,%edx
f01004c9:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01004cd:	5b                   	pop    %ebx
f01004ce:	5e                   	pop    %esi
f01004cf:	5f                   	pop    %edi
f01004d0:	5d                   	pop    %ebp
f01004d1:	c3                   	ret    
	switch (c & 0xff) {
f01004d2:	83 f8 08             	cmp    $0x8,%eax
f01004d5:	75 70                	jne    f0100547 <cons_putc+0x190>
		if (crt_pos > 0) {
f01004d7:	0f b7 05 28 c2 22 f0 	movzwl 0xf022c228,%eax
f01004de:	66 85 c0             	test   %ax,%ax
f01004e1:	74 b9                	je     f010049c <cons_putc+0xe5>
			crt_pos--;
f01004e3:	83 e8 01             	sub    $0x1,%eax
f01004e6:	66 a3 28 c2 22 f0    	mov    %ax,0xf022c228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01004ec:	0f b7 c0             	movzwl %ax,%eax
f01004ef:	66 81 e7 00 ff       	and    $0xff00,%di
f01004f4:	83 cf 20             	or     $0x20,%edi
f01004f7:	8b 15 2c c2 22 f0    	mov    0xf022c22c,%edx
f01004fd:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100501:	eb 8a                	jmp    f010048d <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f0100503:	66 83 05 28 c2 22 f0 	addw   $0x50,0xf022c228
f010050a:	50 
f010050b:	e9 61 ff ff ff       	jmp    f0100471 <cons_putc+0xba>
		cons_putc(' ');
f0100510:	b8 20 00 00 00       	mov    $0x20,%eax
f0100515:	e8 9d fe ff ff       	call   f01003b7 <cons_putc>
		cons_putc(' ');
f010051a:	b8 20 00 00 00       	mov    $0x20,%eax
f010051f:	e8 93 fe ff ff       	call   f01003b7 <cons_putc>
		cons_putc(' ');
f0100524:	b8 20 00 00 00       	mov    $0x20,%eax
f0100529:	e8 89 fe ff ff       	call   f01003b7 <cons_putc>
		cons_putc(' ');
f010052e:	b8 20 00 00 00       	mov    $0x20,%eax
f0100533:	e8 7f fe ff ff       	call   f01003b7 <cons_putc>
		cons_putc(' ');
f0100538:	b8 20 00 00 00       	mov    $0x20,%eax
f010053d:	e8 75 fe ff ff       	call   f01003b7 <cons_putc>
f0100542:	e9 46 ff ff ff       	jmp    f010048d <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100547:	0f b7 05 28 c2 22 f0 	movzwl 0xf022c228,%eax
f010054e:	8d 50 01             	lea    0x1(%eax),%edx
f0100551:	66 89 15 28 c2 22 f0 	mov    %dx,0xf022c228
f0100558:	0f b7 c0             	movzwl %ax,%eax
f010055b:	8b 15 2c c2 22 f0    	mov    0xf022c22c,%edx
f0100561:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100565:	e9 23 ff ff ff       	jmp    f010048d <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010056a:	a1 2c c2 22 f0       	mov    0xf022c22c,%eax
f010056f:	83 ec 04             	sub    $0x4,%esp
f0100572:	68 00 0f 00 00       	push   $0xf00
f0100577:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f010057d:	52                   	push   %edx
f010057e:	50                   	push   %eax
f010057f:	e8 63 49 00 00       	call   f0104ee7 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100584:	8b 15 2c c2 22 f0    	mov    0xf022c22c,%edx
f010058a:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100590:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100596:	83 c4 10             	add    $0x10,%esp
f0100599:	66 c7 00 20 07       	movw   $0x720,(%eax)
f010059e:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005a1:	39 d0                	cmp    %edx,%eax
f01005a3:	75 f4                	jne    f0100599 <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01005a5:	66 83 2d 28 c2 22 f0 	subw   $0x50,0xf022c228
f01005ac:	50 
f01005ad:	e9 ea fe ff ff       	jmp    f010049c <cons_putc+0xe5>

f01005b2 <serial_intr>:
	if (serial_exists)
f01005b2:	80 3d 34 c2 22 f0 00 	cmpb   $0x0,0xf022c234
f01005b9:	75 02                	jne    f01005bd <serial_intr+0xb>
f01005bb:	f3 c3                	repz ret 
{
f01005bd:	55                   	push   %ebp
f01005be:	89 e5                	mov    %esp,%ebp
f01005c0:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005c3:	b8 38 02 10 f0       	mov    $0xf0100238,%eax
f01005c8:	e8 8a fc ff ff       	call   f0100257 <cons_intr>
}
f01005cd:	c9                   	leave  
f01005ce:	c3                   	ret    

f01005cf <kbd_intr>:
{
f01005cf:	55                   	push   %ebp
f01005d0:	89 e5                	mov    %esp,%ebp
f01005d2:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005d5:	b8 9a 02 10 f0       	mov    $0xf010029a,%eax
f01005da:	e8 78 fc ff ff       	call   f0100257 <cons_intr>
}
f01005df:	c9                   	leave  
f01005e0:	c3                   	ret    

f01005e1 <cons_getc>:
{
f01005e1:	55                   	push   %ebp
f01005e2:	89 e5                	mov    %esp,%ebp
f01005e4:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01005e7:	e8 c6 ff ff ff       	call   f01005b2 <serial_intr>
	kbd_intr();
f01005ec:	e8 de ff ff ff       	call   f01005cf <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01005f1:	8b 15 20 c2 22 f0    	mov    0xf022c220,%edx
	return 0;
f01005f7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01005fc:	3b 15 24 c2 22 f0    	cmp    0xf022c224,%edx
f0100602:	74 18                	je     f010061c <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f0100604:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100607:	89 0d 20 c2 22 f0    	mov    %ecx,0xf022c220
f010060d:	0f b6 82 20 c0 22 f0 	movzbl -0xfdd3fe0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f0100614:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010061a:	74 02                	je     f010061e <cons_getc+0x3d>
}
f010061c:	c9                   	leave  
f010061d:	c3                   	ret    
			cons.rpos = 0;
f010061e:	c7 05 20 c2 22 f0 00 	movl   $0x0,0xf022c220
f0100625:	00 00 00 
f0100628:	eb f2                	jmp    f010061c <cons_getc+0x3b>

f010062a <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010062a:	55                   	push   %ebp
f010062b:	89 e5                	mov    %esp,%ebp
f010062d:	57                   	push   %edi
f010062e:	56                   	push   %esi
f010062f:	53                   	push   %ebx
f0100630:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100633:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010063a:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100641:	5a a5 
	if (*cp != 0xA55A) {
f0100643:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010064a:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010064e:	0f 84 d4 00 00 00    	je     f0100728 <cons_init+0xfe>
		addr_6845 = MONO_BASE;
f0100654:	c7 05 30 c2 22 f0 b4 	movl   $0x3b4,0xf022c230
f010065b:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010065e:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100663:	8b 3d 30 c2 22 f0    	mov    0xf022c230,%edi
f0100669:	b8 0e 00 00 00       	mov    $0xe,%eax
f010066e:	89 fa                	mov    %edi,%edx
f0100670:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100671:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100674:	89 ca                	mov    %ecx,%edx
f0100676:	ec                   	in     (%dx),%al
f0100677:	0f b6 c0             	movzbl %al,%eax
f010067a:	c1 e0 08             	shl    $0x8,%eax
f010067d:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010067f:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100684:	89 fa                	mov    %edi,%edx
f0100686:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100687:	89 ca                	mov    %ecx,%edx
f0100689:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010068a:	89 35 2c c2 22 f0    	mov    %esi,0xf022c22c
	pos |= inb(addr_6845 + 1);
f0100690:	0f b6 c0             	movzbl %al,%eax
f0100693:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100695:	66 a3 28 c2 22 f0    	mov    %ax,0xf022c228
	kbd_intr();
f010069b:	e8 2f ff ff ff       	call   f01005cf <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006a0:	83 ec 0c             	sub    $0xc,%esp
f01006a3:	0f b7 05 70 13 12 f0 	movzwl 0xf0121370,%eax
f01006aa:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006af:	50                   	push   %eax
f01006b0:	e8 20 33 00 00       	call   f01039d5 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006b5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ba:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006bf:	89 d8                	mov    %ebx,%eax
f01006c1:	89 ca                	mov    %ecx,%edx
f01006c3:	ee                   	out    %al,(%dx)
f01006c4:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006c9:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006ce:	89 fa                	mov    %edi,%edx
f01006d0:	ee                   	out    %al,(%dx)
f01006d1:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006db:	ee                   	out    %al,(%dx)
f01006dc:	be f9 03 00 00       	mov    $0x3f9,%esi
f01006e1:	89 d8                	mov    %ebx,%eax
f01006e3:	89 f2                	mov    %esi,%edx
f01006e5:	ee                   	out    %al,(%dx)
f01006e6:	b8 03 00 00 00       	mov    $0x3,%eax
f01006eb:	89 fa                	mov    %edi,%edx
f01006ed:	ee                   	out    %al,(%dx)
f01006ee:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01006f3:	89 d8                	mov    %ebx,%eax
f01006f5:	ee                   	out    %al,(%dx)
f01006f6:	b8 01 00 00 00       	mov    $0x1,%eax
f01006fb:	89 f2                	mov    %esi,%edx
f01006fd:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006fe:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100703:	ec                   	in     (%dx),%al
f0100704:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100706:	83 c4 10             	add    $0x10,%esp
f0100709:	3c ff                	cmp    $0xff,%al
f010070b:	0f 95 05 34 c2 22 f0 	setne  0xf022c234
f0100712:	89 ca                	mov    %ecx,%edx
f0100714:	ec                   	in     (%dx),%al
f0100715:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010071a:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010071b:	80 fb ff             	cmp    $0xff,%bl
f010071e:	74 23                	je     f0100743 <cons_init+0x119>
		cprintf("Serial port does not exist!\n");
}
f0100720:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100723:	5b                   	pop    %ebx
f0100724:	5e                   	pop    %esi
f0100725:	5f                   	pop    %edi
f0100726:	5d                   	pop    %ebp
f0100727:	c3                   	ret    
		*cp = was;
f0100728:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010072f:	c7 05 30 c2 22 f0 d4 	movl   $0x3d4,0xf022c230
f0100736:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100739:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010073e:	e9 20 ff ff ff       	jmp    f0100663 <cons_init+0x39>
		cprintf("Serial port does not exist!\n");
f0100743:	83 ec 0c             	sub    $0xc,%esp
f0100746:	68 cf 5b 10 f0       	push   $0xf0105bcf
f010074b:	e8 e0 33 00 00       	call   f0103b30 <cprintf>
f0100750:	83 c4 10             	add    $0x10,%esp
}
f0100753:	eb cb                	jmp    f0100720 <cons_init+0xf6>

f0100755 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100755:	55                   	push   %ebp
f0100756:	89 e5                	mov    %esp,%ebp
f0100758:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010075b:	8b 45 08             	mov    0x8(%ebp),%eax
f010075e:	e8 54 fc ff ff       	call   f01003b7 <cons_putc>
}
f0100763:	c9                   	leave  
f0100764:	c3                   	ret    

f0100765 <getchar>:

int
getchar(void)
{
f0100765:	55                   	push   %ebp
f0100766:	89 e5                	mov    %esp,%ebp
f0100768:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010076b:	e8 71 fe ff ff       	call   f01005e1 <cons_getc>
f0100770:	85 c0                	test   %eax,%eax
f0100772:	74 f7                	je     f010076b <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100774:	c9                   	leave  
f0100775:	c3                   	ret    

f0100776 <iscons>:

int
iscons(int fdnum)
{
f0100776:	55                   	push   %ebp
f0100777:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100779:	b8 01 00 00 00       	mov    $0x1,%eax
f010077e:	5d                   	pop    %ebp
f010077f:	c3                   	ret    

f0100780 <mon_help>:
};

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf) {
f0100780:	55                   	push   %ebp
f0100781:	89 e5                	mov    %esp,%ebp
f0100783:	83 ec 0c             	sub    $0xc,%esp
    int i;

    for (i = 0; i < ARRAY_SIZE(commands); i++)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100786:	68 20 5e 10 f0       	push   $0xf0105e20
f010078b:	68 3e 5e 10 f0       	push   $0xf0105e3e
f0100790:	68 43 5e 10 f0       	push   $0xf0105e43
f0100795:	e8 96 33 00 00       	call   f0103b30 <cprintf>
f010079a:	83 c4 0c             	add    $0xc,%esp
f010079d:	68 e8 5e 10 f0       	push   $0xf0105ee8
f01007a2:	68 4c 5e 10 f0       	push   $0xf0105e4c
f01007a7:	68 43 5e 10 f0       	push   $0xf0105e43
f01007ac:	e8 7f 33 00 00       	call   f0103b30 <cprintf>
f01007b1:	83 c4 0c             	add    $0xc,%esp
f01007b4:	68 55 5e 10 f0       	push   $0xf0105e55
f01007b9:	68 73 5e 10 f0       	push   $0xf0105e73
f01007be:	68 43 5e 10 f0       	push   $0xf0105e43
f01007c3:	e8 68 33 00 00       	call   f0103b30 <cprintf>
    return 0;
}
f01007c8:	b8 00 00 00 00       	mov    $0x0,%eax
f01007cd:	c9                   	leave  
f01007ce:	c3                   	ret    

f01007cf <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf) {
f01007cf:	55                   	push   %ebp
f01007d0:	89 e5                	mov    %esp,%ebp
f01007d2:	83 ec 14             	sub    $0x14,%esp
    extern char _start[], entry[], etext[], edata[], end[];

    cprintf("Special kernel symbols:\n");
f01007d5:	68 7d 5e 10 f0       	push   $0xf0105e7d
f01007da:	e8 51 33 00 00       	call   f0103b30 <cprintf>
    cprintf("  _start                  %08x (phys)\n", _start);
f01007df:	83 c4 08             	add    $0x8,%esp
f01007e2:	68 0c 00 10 00       	push   $0x10000c
f01007e7:	68 10 5f 10 f0       	push   $0xf0105f10
f01007ec:	e8 3f 33 00 00       	call   f0103b30 <cprintf>
    cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007f1:	83 c4 0c             	add    $0xc,%esp
f01007f4:	68 0c 00 10 00       	push   $0x10000c
f01007f9:	68 0c 00 10 f0       	push   $0xf010000c
f01007fe:	68 38 5f 10 f0       	push   $0xf0105f38
f0100803:	e8 28 33 00 00       	call   f0103b30 <cprintf>
    cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100808:	83 c4 0c             	add    $0xc,%esp
f010080b:	68 f9 5a 10 00       	push   $0x105af9
f0100810:	68 f9 5a 10 f0       	push   $0xf0105af9
f0100815:	68 5c 5f 10 f0       	push   $0xf0105f5c
f010081a:	e8 11 33 00 00       	call   f0103b30 <cprintf>
    cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010081f:	83 c4 0c             	add    $0xc,%esp
f0100822:	68 00 c0 22 00       	push   $0x22c000
f0100827:	68 00 c0 22 f0       	push   $0xf022c000
f010082c:	68 80 5f 10 f0       	push   $0xf0105f80
f0100831:	e8 fa 32 00 00       	call   f0103b30 <cprintf>
    cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100836:	83 c4 0c             	add    $0xc,%esp
f0100839:	68 08 e0 26 00       	push   $0x26e008
f010083e:	68 08 e0 26 f0       	push   $0xf026e008
f0100843:	68 a4 5f 10 f0       	push   $0xf0105fa4
f0100848:	e8 e3 32 00 00       	call   f0103b30 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
f010084d:	83 c4 08             	add    $0x8,%esp
            ROUNDUP(end - entry, 1024) / 1024);
f0100850:	b8 07 e4 26 f0       	mov    $0xf026e407,%eax
f0100855:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
    cprintf("Kernel executable memory footprint: %dKB\n",
f010085a:	c1 f8 0a             	sar    $0xa,%eax
f010085d:	50                   	push   %eax
f010085e:	68 c8 5f 10 f0       	push   $0xf0105fc8
f0100863:	e8 c8 32 00 00       	call   f0103b30 <cprintf>
    return 0;
}
f0100868:	b8 00 00 00 00       	mov    $0x0,%eax
f010086d:	c9                   	leave  
f010086e:	c3                   	ret    

f010086f <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf) {
f010086f:	55                   	push   %ebp
f0100870:	89 e5                	mov    %esp,%ebp
f0100872:	57                   	push   %edi
f0100873:	56                   	push   %esi
f0100874:	53                   	push   %ebx
f0100875:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100878:	89 eb                	mov    %ebp,%ebx
        uintptr_t eip = *(uintptr_t *) (ebp + 0x4);
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, *(uintptr_t *) (ebp + 0x8),
                *(uintptr_t *) (ebp + 0xc),
                *(uintptr_t *) (ebp + 0x10), *(uintptr_t *) (ebp + 0x14));
        struct Eipdebuginfo eipDebugInfo;
        debuginfo_eip(eip, &eipDebugInfo);
f010087a:	8d 7d d0             	lea    -0x30(%ebp),%edi
    while (ebp) {
f010087d:	eb 4a                	jmp    f01008c9 <mon_backtrace+0x5a>
        uintptr_t eip = *(uintptr_t *) (ebp + 0x4);
f010087f:	8b 73 04             	mov    0x4(%ebx),%esi
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, *(uintptr_t *) (ebp + 0x8),
f0100882:	83 ec 04             	sub    $0x4,%esp
f0100885:	ff 73 14             	pushl  0x14(%ebx)
f0100888:	ff 73 10             	pushl  0x10(%ebx)
f010088b:	ff 73 0c             	pushl  0xc(%ebx)
f010088e:	ff 73 08             	pushl  0x8(%ebx)
f0100891:	56                   	push   %esi
f0100892:	53                   	push   %ebx
f0100893:	68 f4 5f 10 f0       	push   $0xf0105ff4
f0100898:	e8 93 32 00 00       	call   f0103b30 <cprintf>
        debuginfo_eip(eip, &eipDebugInfo);
f010089d:	83 c4 18             	add    $0x18,%esp
f01008a0:	57                   	push   %edi
f01008a1:	56                   	push   %esi
f01008a2:	e8 5b 3b 00 00       	call   f0104402 <debuginfo_eip>
        cprintf("\t %s:%d:  %.*s+%d\n", eipDebugInfo.eip_file, eipDebugInfo.eip_line, eipDebugInfo.eip_fn_namelen, eipDebugInfo.eip_fn_name,
f01008a7:	83 c4 08             	add    $0x8,%esp
f01008aa:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01008ad:	56                   	push   %esi
f01008ae:	ff 75 d8             	pushl  -0x28(%ebp)
f01008b1:	ff 75 dc             	pushl  -0x24(%ebp)
f01008b4:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008b7:	ff 75 d0             	pushl  -0x30(%ebp)
f01008ba:	68 96 5e 10 f0       	push   $0xf0105e96
f01008bf:	e8 6c 32 00 00       	call   f0103b30 <cprintf>
                eip - eipDebugInfo.eip_fn_addr);
        ebp = *(uintptr_t *) ebp;
f01008c4:	8b 1b                	mov    (%ebx),%ebx
f01008c6:	83 c4 20             	add    $0x20,%esp
    while (ebp) {
f01008c9:	85 db                	test   %ebx,%ebx
f01008cb:	75 b2                	jne    f010087f <mon_backtrace+0x10>
    }
    return 1;
}
f01008cd:	b8 01 00 00 00       	mov    $0x1,%eax
f01008d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01008d5:	5b                   	pop    %ebx
f01008d6:	5e                   	pop    %esi
f01008d7:	5f                   	pop    %edi
f01008d8:	5d                   	pop    %ebp
f01008d9:	c3                   	ret    

f01008da <monitor>:
    cprintf("Unknown command '%s'\n", argv[0]);
    return 0;
}

void
monitor(struct Trapframe *tf) {
f01008da:	55                   	push   %ebp
f01008db:	89 e5                	mov    %esp,%ebp
f01008dd:	57                   	push   %edi
f01008de:	56                   	push   %esi
f01008df:	53                   	push   %ebx
f01008e0:	83 ec 58             	sub    $0x58,%esp
    char *buf;

    cprintf("Welcome to the JOS kernel monitor!\n");
f01008e3:	68 2c 60 10 f0       	push   $0xf010602c
f01008e8:	e8 43 32 00 00       	call   f0103b30 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
f01008ed:	c7 04 24 50 60 10 f0 	movl   $0xf0106050,(%esp)
f01008f4:	e8 37 32 00 00       	call   f0103b30 <cprintf>

	if (tf != NULL)
f01008f9:	83 c4 10             	add    $0x10,%esp
f01008fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100900:	74 57                	je     f0100959 <monitor+0x7f>
		print_trapframe(tf);
f0100902:	83 ec 0c             	sub    $0xc,%esp
f0100905:	ff 75 08             	pushl  0x8(%ebp)
f0100908:	e8 3e 34 00 00       	call   f0103d4b <print_trapframe>
f010090d:	83 c4 10             	add    $0x10,%esp
f0100910:	eb 47                	jmp    f0100959 <monitor+0x7f>
        while (*buf && strchr(WHITESPACE, *buf))
f0100912:	83 ec 08             	sub    $0x8,%esp
f0100915:	0f be c0             	movsbl %al,%eax
f0100918:	50                   	push   %eax
f0100919:	68 ad 5e 10 f0       	push   $0xf0105ead
f010091e:	e8 3a 45 00 00       	call   f0104e5d <strchr>
f0100923:	83 c4 10             	add    $0x10,%esp
f0100926:	85 c0                	test   %eax,%eax
f0100928:	74 0a                	je     f0100934 <monitor+0x5a>
            *buf++ = 0;
f010092a:	c6 03 00             	movb   $0x0,(%ebx)
f010092d:	89 f7                	mov    %esi,%edi
f010092f:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100932:	eb 6b                	jmp    f010099f <monitor+0xc5>
        if (*buf == 0)
f0100934:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100937:	74 73                	je     f01009ac <monitor+0xd2>
        if (argc == MAXARGS - 1) {
f0100939:	83 fe 0f             	cmp    $0xf,%esi
f010093c:	74 09                	je     f0100947 <monitor+0x6d>
        argv[argc++] = buf;
f010093e:	8d 7e 01             	lea    0x1(%esi),%edi
f0100941:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100945:	eb 39                	jmp    f0100980 <monitor+0xa6>
            cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100947:	83 ec 08             	sub    $0x8,%esp
f010094a:	6a 10                	push   $0x10
f010094c:	68 b2 5e 10 f0       	push   $0xf0105eb2
f0100951:	e8 da 31 00 00       	call   f0103b30 <cprintf>
f0100956:	83 c4 10             	add    $0x10,%esp

    while (1) {
        buf = readline("K> ");
f0100959:	83 ec 0c             	sub    $0xc,%esp
f010095c:	68 a9 5e 10 f0       	push   $0xf0105ea9
f0100961:	e8 da 42 00 00       	call   f0104c40 <readline>
f0100966:	89 c3                	mov    %eax,%ebx
        if (buf != NULL)
f0100968:	83 c4 10             	add    $0x10,%esp
f010096b:	85 c0                	test   %eax,%eax
f010096d:	74 ea                	je     f0100959 <monitor+0x7f>
    argv[argc] = 0;
f010096f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
    argc = 0;
f0100976:	be 00 00 00 00       	mov    $0x0,%esi
f010097b:	eb 24                	jmp    f01009a1 <monitor+0xc7>
            buf++;
f010097d:	83 c3 01             	add    $0x1,%ebx
        while (*buf && !strchr(WHITESPACE, *buf))
f0100980:	0f b6 03             	movzbl (%ebx),%eax
f0100983:	84 c0                	test   %al,%al
f0100985:	74 18                	je     f010099f <monitor+0xc5>
f0100987:	83 ec 08             	sub    $0x8,%esp
f010098a:	0f be c0             	movsbl %al,%eax
f010098d:	50                   	push   %eax
f010098e:	68 ad 5e 10 f0       	push   $0xf0105ead
f0100993:	e8 c5 44 00 00       	call   f0104e5d <strchr>
f0100998:	83 c4 10             	add    $0x10,%esp
f010099b:	85 c0                	test   %eax,%eax
f010099d:	74 de                	je     f010097d <monitor+0xa3>
            *buf++ = 0;
f010099f:	89 fe                	mov    %edi,%esi
        while (*buf && strchr(WHITESPACE, *buf))
f01009a1:	0f b6 03             	movzbl (%ebx),%eax
f01009a4:	84 c0                	test   %al,%al
f01009a6:	0f 85 66 ff ff ff    	jne    f0100912 <monitor+0x38>
    argv[argc] = 0;
f01009ac:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009b3:	00 
    if (argc == 0)
f01009b4:	85 f6                	test   %esi,%esi
f01009b6:	74 a1                	je     f0100959 <monitor+0x7f>
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009b8:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (strcmp(argv[0], commands[i].name) == 0)
f01009bd:	83 ec 08             	sub    $0x8,%esp
f01009c0:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009c3:	ff 34 85 80 60 10 f0 	pushl  -0xfef9f80(,%eax,4)
f01009ca:	ff 75 a8             	pushl  -0x58(%ebp)
f01009cd:	e8 2d 44 00 00       	call   f0104dff <strcmp>
f01009d2:	83 c4 10             	add    $0x10,%esp
f01009d5:	85 c0                	test   %eax,%eax
f01009d7:	74 20                	je     f01009f9 <monitor+0x11f>
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009d9:	83 c3 01             	add    $0x1,%ebx
f01009dc:	83 fb 03             	cmp    $0x3,%ebx
f01009df:	75 dc                	jne    f01009bd <monitor+0xe3>
    cprintf("Unknown command '%s'\n", argv[0]);
f01009e1:	83 ec 08             	sub    $0x8,%esp
f01009e4:	ff 75 a8             	pushl  -0x58(%ebp)
f01009e7:	68 cf 5e 10 f0       	push   $0xf0105ecf
f01009ec:	e8 3f 31 00 00       	call   f0103b30 <cprintf>
f01009f1:	83 c4 10             	add    $0x10,%esp
f01009f4:	e9 60 ff ff ff       	jmp    f0100959 <monitor+0x7f>
            return commands[i].func(argc, argv, tf);
f01009f9:	83 ec 04             	sub    $0x4,%esp
f01009fc:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009ff:	ff 75 08             	pushl  0x8(%ebp)
f0100a02:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a05:	52                   	push   %edx
f0100a06:	56                   	push   %esi
f0100a07:	ff 14 85 88 60 10 f0 	call   *-0xfef9f78(,%eax,4)
            if (runcmd(buf, tf) < 0)
f0100a0e:	83 c4 10             	add    $0x10,%esp
f0100a11:	85 c0                	test   %eax,%eax
f0100a13:	0f 89 40 ff ff ff    	jns    f0100959 <monitor+0x7f>
                break;
    }
f0100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a1c:	5b                   	pop    %ebx
f0100a1d:	5e                   	pop    %esi
f0100a1e:	5f                   	pop    %edi
f0100a1f:	5d                   	pop    %ebp
f0100a20:	c3                   	ret    

f0100a21 <nvram_read>:
// --------------------------------------------------------------
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r) {
f0100a21:	55                   	push   %ebp
f0100a22:	89 e5                	mov    %esp,%ebp
f0100a24:	56                   	push   %esi
f0100a25:	53                   	push   %ebx
f0100a26:	89 c6                	mov    %eax,%esi
    return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a28:	83 ec 0c             	sub    $0xc,%esp
f0100a2b:	50                   	push   %eax
f0100a2c:	e8 76 2f 00 00       	call   f01039a7 <mc146818_read>
f0100a31:	89 c3                	mov    %eax,%ebx
f0100a33:	83 c6 01             	add    $0x1,%esi
f0100a36:	89 34 24             	mov    %esi,(%esp)
f0100a39:	e8 69 2f 00 00       	call   f01039a7 <mc146818_read>
f0100a3e:	c1 e0 08             	shl    $0x8,%eax
f0100a41:	09 d8                	or     %ebx,%eax
}
f0100a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a46:	5b                   	pop    %ebx
f0100a47:	5e                   	pop    %esi
f0100a48:	5d                   	pop    %ebp
f0100a49:	c3                   	ret    

f0100a4a <boot_alloc>:
//
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n) {
f0100a4a:	55                   	push   %ebp
f0100a4b:	89 e5                	mov    %esp,%ebp
f0100a4d:	53                   	push   %ebx
f0100a4e:	83 ec 04             	sub    $0x4,%esp
    // Initialize nextfree if this is the first time.
    // 'end' is a magic symbol automatically generated by the linker,
    // which points to the end of the kernel's bss segment:
    // the first virtual address that the linker did *not* assign
    // to any kernel code or global variables.
    if (!nextfree) {
f0100a51:	83 3d 38 c2 22 f0 00 	cmpl   $0x0,0xf022c238
f0100a58:	74 29                	je     f0100a83 <boot_alloc+0x39>
    }

    // Allocate a chunk large enough to hold 'n' bytes, then update
    // nextfree.  Make sure nextfree is kept aligned
    // to a multiple of PGSIZE.
    result = nextfree;
f0100a5a:	8b 15 38 c2 22 f0    	mov    0xf022c238,%edx
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100a60:	8d 5a ff             	lea    -0x1(%edx),%ebx
f0100a63:	89 c1                	mov    %eax,%ecx
f0100a65:	f7 d1                	not    %ecx
f0100a67:	39 cb                	cmp    %ecx,%ebx
f0100a69:	77 2b                	ja     f0100a96 <boot_alloc+0x4c>
    nextfree = ROUNDUP((result + n), PGSIZE);
f0100a6b:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100a72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a77:	a3 38 c2 22 f0       	mov    %eax,0xf022c238

    return result;
}
f0100a7c:	89 d0                	mov    %edx,%eax
f0100a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100a81:	c9                   	leave  
f0100a82:	c3                   	ret    
        nextfree = ROUNDUP((char *) end, PGSIZE);
f0100a83:	ba 07 f0 26 f0       	mov    $0xf026f007,%edx
f0100a88:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100a8e:	89 15 38 c2 22 f0    	mov    %edx,0xf022c238
f0100a94:	eb c4                	jmp    f0100a5a <boot_alloc+0x10>
    assert((uint32_t) result - 1 <= 0xFFFFFFFF - n);
f0100a96:	68 a4 60 10 f0       	push   $0xf01060a4
f0100a9b:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100aa0:	6a 73                	push   $0x73
f0100aa2:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100aa7:	e8 94 f5 ff ff       	call   f0100040 <_panic>

f0100aac <check_va2pa>:

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va) {
    pte_t *p;

    pgdir = &pgdir[PDX(va)];
f0100aac:	89 d1                	mov    %edx,%ecx
f0100aae:	c1 e9 16             	shr    $0x16,%ecx
    if (!(*pgdir & PTE_P))
f0100ab1:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100ab4:	a8 01                	test   $0x1,%al
f0100ab6:	74 52                	je     f0100b0a <check_va2pa+0x5e>
        return ~0;
    p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
f0100ab8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100abd:	89 c1                	mov    %eax,%ecx
f0100abf:	c1 e9 0c             	shr    $0xc,%ecx
f0100ac2:	3b 0d 0c cf 22 f0    	cmp    0xf022cf0c,%ecx
f0100ac8:	73 25                	jae    f0100aef <check_va2pa+0x43>
    if (!(p[PTX(va)] & PTE_P))
f0100aca:	c1 ea 0c             	shr    $0xc,%edx
f0100acd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100ad3:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100ada:	89 c2                	mov    %eax,%edx
f0100adc:	83 e2 01             	and    $0x1,%edx
        return ~0;
    return PTE_ADDR(p[PTX(va)]);
f0100adf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ae4:	85 d2                	test   %edx,%edx
f0100ae6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100aeb:	0f 44 c2             	cmove  %edx,%eax
f0100aee:	c3                   	ret    
check_va2pa(pde_t *pgdir, uintptr_t va) {
f0100aef:	55                   	push   %ebp
f0100af0:	89 e5                	mov    %esp,%ebp
f0100af2:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100af5:	50                   	push   %eax
f0100af6:	68 24 5b 10 f0       	push   $0xf0105b24
f0100afb:	68 ed 03 00 00       	push   $0x3ed
f0100b00:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100b05:	e8 36 f5 ff ff       	call   f0100040 <_panic>
        return ~0;
f0100b0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b0f:	c3                   	ret    

f0100b10 <check_page_free_list>:
check_page_free_list(bool only_low_memory) {
f0100b10:	55                   	push   %ebp
f0100b11:	89 e5                	mov    %esp,%ebp
f0100b13:	57                   	push   %edi
f0100b14:	56                   	push   %esi
f0100b15:	53                   	push   %ebx
f0100b16:	83 ec 2c             	sub    $0x2c,%esp
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b19:	84 c0                	test   %al,%al
f0100b1b:	0f 85 c0 02 00 00    	jne    f0100de1 <check_page_free_list+0x2d1>
    if (!page_free_list)
f0100b21:	83 3d 44 c2 22 f0 00 	cmpl   $0x0,0xf022c244
f0100b28:	74 0a                	je     f0100b34 <check_page_free_list+0x24>
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b2a:	be 00 04 00 00       	mov    $0x400,%esi
f0100b2f:	e9 23 03 00 00       	jmp    f0100e57 <check_page_free_list+0x347>
        panic("'page_free_list' is a null pointer!");
f0100b34:	83 ec 04             	sub    $0x4,%esp
f0100b37:	68 cc 60 10 f0       	push   $0xf01060cc
f0100b3c:	68 18 03 00 00       	push   $0x318
f0100b41:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100b46:	e8 f5 f4 ff ff       	call   f0100040 <_panic>
f0100b4b:	50                   	push   %eax
f0100b4c:	68 24 5b 10 f0       	push   $0xf0105b24
f0100b51:	6a 58                	push   $0x58
f0100b53:	68 02 6f 10 f0       	push   $0xf0106f02
f0100b58:	e8 e3 f4 ff ff       	call   f0100040 <_panic>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0100b5d:	8b 1b                	mov    (%ebx),%ebx
f0100b5f:	85 db                	test   %ebx,%ebx
f0100b61:	74 41                	je     f0100ba4 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100b63:	89 d8                	mov    %ebx,%eax
f0100b65:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0100b6b:	c1 f8 03             	sar    $0x3,%eax
f0100b6e:	c1 e0 0c             	shl    $0xc,%eax
        if (PDX(page2pa(pp)) < pdx_limit) {
f0100b71:	89 c2                	mov    %eax,%edx
f0100b73:	c1 ea 16             	shr    $0x16,%edx
f0100b76:	39 f2                	cmp    %esi,%edx
f0100b78:	73 e3                	jae    f0100b5d <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100b7a:	89 c2                	mov    %eax,%edx
f0100b7c:	c1 ea 0c             	shr    $0xc,%edx
f0100b7f:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f0100b85:	73 c4                	jae    f0100b4b <check_page_free_list+0x3b>
            memset(page2kva(pp), 0x97, 128);
f0100b87:	83 ec 04             	sub    $0x4,%esp
f0100b8a:	68 80 00 00 00       	push   $0x80
f0100b8f:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100b94:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100b99:	50                   	push   %eax
f0100b9a:	e8 fb 42 00 00       	call   f0104e9a <memset>
f0100b9f:	83 c4 10             	add    $0x10,%esp
f0100ba2:	eb b9                	jmp    f0100b5d <check_page_free_list+0x4d>
    first_free_page = (char *) boot_alloc(0);
f0100ba4:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ba9:	e8 9c fe ff ff       	call   f0100a4a <boot_alloc>
f0100bae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    cprintf("first_free_page:0x%x\n", first_free_page);
f0100bb1:	83 ec 08             	sub    $0x8,%esp
f0100bb4:	50                   	push   %eax
f0100bb5:	68 10 6f 10 f0       	push   $0xf0106f10
f0100bba:	e8 71 2f 00 00       	call   f0103b30 <cprintf>
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100bbf:	8b 15 44 c2 22 f0    	mov    0xf022c244,%edx
        assert(pp >= pages);
f0100bc5:	8b 0d 14 cf 22 f0    	mov    0xf022cf14,%ecx
        assert(pp < pages + npages);
f0100bcb:	a1 0c cf 22 f0       	mov    0xf022cf0c,%eax
f0100bd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100bd3:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100bd6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100bd9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100bdc:	83 c4 10             	add    $0x10,%esp
    int nfree_basemem = 0, nfree_extmem = 0;
f0100bdf:	be 00 00 00 00       	mov    $0x0,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100be4:	e9 04 01 00 00       	jmp    f0100ced <check_page_free_list+0x1dd>
        assert(pp >= pages);
f0100be9:	68 26 6f 10 f0       	push   $0xf0106f26
f0100bee:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100bf3:	68 39 03 00 00       	push   $0x339
f0100bf8:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100bfd:	e8 3e f4 ff ff       	call   f0100040 <_panic>
        assert(pp < pages + npages);
f0100c02:	68 32 6f 10 f0       	push   $0xf0106f32
f0100c07:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c0c:	68 3a 03 00 00       	push   $0x33a
f0100c11:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100c16:	e8 25 f4 ff ff       	call   f0100040 <_panic>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c1b:	68 3c 61 10 f0       	push   $0xf010613c
f0100c20:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c25:	68 3b 03 00 00       	push   $0x33b
f0100c2a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100c2f:	e8 0c f4 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != 0);
f0100c34:	68 46 6f 10 f0       	push   $0xf0106f46
f0100c39:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c3e:	68 3e 03 00 00       	push   $0x33e
f0100c43:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100c48:	e8 f3 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != IOPHYSMEM);
f0100c4d:	68 57 6f 10 f0       	push   $0xf0106f57
f0100c52:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c57:	68 3f 03 00 00       	push   $0x33f
f0100c5c:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100c61:	e8 da f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c66:	68 70 61 10 f0       	push   $0xf0106170
f0100c6b:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c70:	68 40 03 00 00       	push   $0x340
f0100c75:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100c7a:	e8 c1 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100c7f:	68 70 6f 10 f0       	push   $0xf0106f70
f0100c84:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100c89:	68 41 03 00 00       	push   $0x341
f0100c8e:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100c93:	e8 a8 f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100c98:	89 c7                	mov    %eax,%edi
f0100c9a:	c1 ef 0c             	shr    $0xc,%edi
f0100c9d:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100ca0:	76 1b                	jbe    f0100cbd <check_page_free_list+0x1ad>
	return (void *)(pa + KERNBASE);
f0100ca2:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ca8:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100cab:	77 22                	ja     f0100ccf <check_page_free_list+0x1bf>
        assert(page2pa(pp) != MPENTRY_PADDR);
f0100cad:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100cb2:	0f 84 98 00 00 00    	je     f0100d50 <check_page_free_list+0x240>
            ++nfree_extmem;
f0100cb8:	83 c3 01             	add    $0x1,%ebx
f0100cbb:	eb 2e                	jmp    f0100ceb <check_page_free_list+0x1db>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100cbd:	50                   	push   %eax
f0100cbe:	68 24 5b 10 f0       	push   $0xf0105b24
f0100cc3:	6a 58                	push   $0x58
f0100cc5:	68 02 6f 10 f0       	push   $0xf0106f02
f0100cca:	e8 71 f3 ff ff       	call   f0100040 <_panic>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ccf:	68 94 61 10 f0       	push   $0xf0106194
f0100cd4:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100cd9:	68 42 03 00 00       	push   $0x342
f0100cde:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100ce3:	e8 58 f3 ff ff       	call   f0100040 <_panic>
            ++nfree_basemem;
f0100ce8:	83 c6 01             	add    $0x1,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ceb:	8b 12                	mov    (%edx),%edx
f0100ced:	85 d2                	test   %edx,%edx
f0100cef:	74 78                	je     f0100d69 <check_page_free_list+0x259>
        assert(pp >= pages);
f0100cf1:	39 d1                	cmp    %edx,%ecx
f0100cf3:	0f 87 f0 fe ff ff    	ja     f0100be9 <check_page_free_list+0xd9>
        assert(pp < pages + npages);
f0100cf9:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0100cfc:	0f 86 00 ff ff ff    	jbe    f0100c02 <check_page_free_list+0xf2>
        assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d02:	89 d0                	mov    %edx,%eax
f0100d04:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100d07:	a8 07                	test   $0x7,%al
f0100d09:	0f 85 0c ff ff ff    	jne    f0100c1b <check_page_free_list+0x10b>
	return (pp - pages) << PGSHIFT;
f0100d0f:	c1 f8 03             	sar    $0x3,%eax
f0100d12:	c1 e0 0c             	shl    $0xc,%eax
        assert(page2pa(pp) != 0);
f0100d15:	85 c0                	test   %eax,%eax
f0100d17:	0f 84 17 ff ff ff    	je     f0100c34 <check_page_free_list+0x124>
        assert(page2pa(pp) != IOPHYSMEM);
f0100d1d:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d22:	0f 84 25 ff ff ff    	je     f0100c4d <check_page_free_list+0x13d>
        assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d28:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d2d:	0f 84 33 ff ff ff    	je     f0100c66 <check_page_free_list+0x156>
        assert(page2pa(pp) != EXTPHYSMEM);
f0100d33:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d38:	0f 84 41 ff ff ff    	je     f0100c7f <check_page_free_list+0x16f>
        assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d3e:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d43:	0f 87 4f ff ff ff    	ja     f0100c98 <check_page_free_list+0x188>
        assert(page2pa(pp) != MPENTRY_PADDR);
f0100d49:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d4e:	75 98                	jne    f0100ce8 <check_page_free_list+0x1d8>
f0100d50:	68 8a 6f 10 f0       	push   $0xf0106f8a
f0100d55:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100d5a:	68 44 03 00 00       	push   $0x344
f0100d5f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100d64:	e8 d7 f2 ff ff       	call   f0100040 <_panic>
    cprintf("nfree_basemem:0x%x\tnfree_extmem:0x%x\n", nfree_basemem, nfree_extmem);
f0100d69:	83 ec 04             	sub    $0x4,%esp
f0100d6c:	53                   	push   %ebx
f0100d6d:	56                   	push   %esi
f0100d6e:	68 dc 61 10 f0       	push   $0xf01061dc
f0100d73:	e8 b8 2d 00 00       	call   f0103b30 <cprintf>
    cprintf("物理内存占用中页数:0x%x\n", 8 * PGSIZE - nfree_basemem - nfree_extmem);
f0100d78:	83 c4 08             	add    $0x8,%esp
f0100d7b:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100d80:	29 f0                	sub    %esi,%eax
f0100d82:	29 d8                	sub    %ebx,%eax
f0100d84:	50                   	push   %eax
f0100d85:	68 04 62 10 f0       	push   $0xf0106204
f0100d8a:	e8 a1 2d 00 00       	call   f0103b30 <cprintf>
    assert(nfree_basemem > 0);
f0100d8f:	83 c4 10             	add    $0x10,%esp
f0100d92:	85 f6                	test   %esi,%esi
f0100d94:	7e 19                	jle    f0100daf <check_page_free_list+0x29f>
    assert(nfree_extmem > 0);
f0100d96:	85 db                	test   %ebx,%ebx
f0100d98:	7e 2e                	jle    f0100dc8 <check_page_free_list+0x2b8>
    cprintf("check_page_free_list() succeeded!\n");
f0100d9a:	83 ec 0c             	sub    $0xc,%esp
f0100d9d:	68 28 62 10 f0       	push   $0xf0106228
f0100da2:	e8 89 2d 00 00       	call   f0103b30 <cprintf>
}
f0100da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100daa:	5b                   	pop    %ebx
f0100dab:	5e                   	pop    %esi
f0100dac:	5f                   	pop    %edi
f0100dad:	5d                   	pop    %ebp
f0100dae:	c3                   	ret    
    assert(nfree_basemem > 0);
f0100daf:	68 a7 6f 10 f0       	push   $0xf0106fa7
f0100db4:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100db9:	68 50 03 00 00       	push   $0x350
f0100dbe:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100dc3:	e8 78 f2 ff ff       	call   f0100040 <_panic>
    assert(nfree_extmem > 0);
f0100dc8:	68 b9 6f 10 f0       	push   $0xf0106fb9
f0100dcd:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0100dd2:	68 51 03 00 00       	push   $0x351
f0100dd7:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100ddc:	e8 5f f2 ff ff       	call   f0100040 <_panic>
    if (!page_free_list)
f0100de1:	a1 44 c2 22 f0       	mov    0xf022c244,%eax
f0100de6:	85 c0                	test   %eax,%eax
f0100de8:	0f 84 46 fd ff ff    	je     f0100b34 <check_page_free_list+0x24>
        struct PageInfo **tp[2] = {&pp1, &pp2};
f0100dee:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100df1:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100df4:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100df7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100dfa:	89 c2                	mov    %eax,%edx
f0100dfc:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
            int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e02:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e08:	0f 95 c2             	setne  %dl
f0100e0b:	0f b6 d2             	movzbl %dl,%edx
            *tp[pagetype] = pp;
f0100e0e:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e12:	89 01                	mov    %eax,(%ecx)
            tp[pagetype] = &pp->pp_link;
f0100e14:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
        for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e18:	8b 00                	mov    (%eax),%eax
f0100e1a:	85 c0                	test   %eax,%eax
f0100e1c:	75 dc                	jne    f0100dfa <check_page_free_list+0x2ea>
        cprintf("pp:0x%x\tpp1:0x%x\tpp2:0x%x\t*tp[1]:0x%x\t*tp[0]:0x%x\ttp[0]:0x%x\ttp[1]:0x%x\n", pp, pp1, pp2, *tp[1],
f0100e1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100e21:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100e24:	56                   	push   %esi
f0100e25:	53                   	push   %ebx
f0100e26:	ff 33                	pushl  (%ebx)
f0100e28:	ff 36                	pushl  (%esi)
f0100e2a:	ff 75 dc             	pushl  -0x24(%ebp)
f0100e2d:	ff 75 d8             	pushl  -0x28(%ebp)
f0100e30:	6a 00                	push   $0x0
f0100e32:	68 f0 60 10 f0       	push   $0xf01060f0
f0100e37:	e8 f4 2c 00 00       	call   f0103b30 <cprintf>
        *tp[1] = 0;
f0100e3c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
        *tp[0] = pp2;
f0100e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100e45:	89 03                	mov    %eax,(%ebx)
        page_free_list = pp1;
f0100e47:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e4a:	a3 44 c2 22 f0       	mov    %eax,0xf022c244
f0100e4f:	83 c4 20             	add    $0x20,%esp
    unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e52:	be 01 00 00 00       	mov    $0x1,%esi
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e57:	8b 1d 44 c2 22 f0    	mov    0xf022c244,%ebx
f0100e5d:	e9 fd fc ff ff       	jmp    f0100b5f <check_page_free_list+0x4f>

f0100e62 <page_init>:
page_init(void) {
f0100e62:	55                   	push   %ebp
f0100e63:	89 e5                	mov    %esp,%ebp
f0100e65:	57                   	push   %edi
f0100e66:	56                   	push   %esi
f0100e67:	53                   	push   %ebx
f0100e68:	83 ec 1c             	sub    $0x1c,%esp
    physaddr_t baseMemFreeStart = PGSIZE, baseMemFreeEnd = npages_basemem * PGSIZE,
f0100e6b:	8b 3d 48 c2 22 f0    	mov    0xf022c248,%edi
f0100e71:	89 fa                	mov    %edi,%edx
f0100e73:	c1 e2 0c             	shl    $0xc,%edx
            extMemFreeStart = PADDR(pages) + ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) +
f0100e76:	8b 0d 14 cf 22 f0    	mov    0xf022cf14,%ecx
	if ((uint32_t)kva < KERNBASE)
f0100e7c:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100e82:	76 5b                	jbe    f0100edf <page_init+0x7d>
f0100e84:	a1 0c cf 22 f0       	mov    0xf022cf0c,%eax
f0100e89:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100e90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e95:	8d b4 01 00 f0 01 10 	lea    0x1001f000(%ecx,%eax,1),%esi
                              ROUNDUP(NENV * sizeof(struct Env), PGSIZE), extMemFreeEnd =
f0100e9c:	a1 40 c2 22 f0       	mov    0xf022c240,%eax
f0100ea1:	c1 e0 0a             	shl    $0xa,%eax
f0100ea4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("qemu空闲物理内存:[0x%x, 0x%x]\t[0x%x, 0x%x)\n", baseMemFreeStart, baseMemFreeEnd, extMemFreeStart,
f0100ea7:	83 ec 0c             	sub    $0xc,%esp
f0100eaa:	50                   	push   %eax
f0100eab:	56                   	push   %esi
f0100eac:	52                   	push   %edx
f0100ead:	68 00 10 00 00       	push   $0x1000
f0100eb2:	68 4c 62 10 f0       	push   $0xf010624c
f0100eb7:	e8 74 2c 00 00       	call   f0103b30 <cprintf>
    cprintf("初始page_free_list:0x%x\n", page_free_list);
f0100ebc:	83 c4 18             	add    $0x18,%esp
f0100ebf:	ff 35 44 c2 22 f0    	pushl  0xf022c244
f0100ec5:	68 ca 6f 10 f0       	push   $0xf0106fca
f0100eca:	e8 61 2c 00 00       	call   f0103b30 <cprintf>
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0100ecf:	83 c4 10             	add    $0x10,%esp
f0100ed2:	bb 01 00 00 00       	mov    $0x1,%ebx
f0100ed7:	81 e7 ff ff 0f 00    	and    $0xfffff,%edi
f0100edd:	eb 2d                	jmp    f0100f0c <page_init+0xaa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100edf:	51                   	push   %ecx
f0100ee0:	68 48 5b 10 f0       	push   $0xf0105b48
f0100ee5:	68 5c 01 00 00       	push   $0x15c
f0100eea:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100eef:	e8 4c f1 ff ff       	call   f0100040 <_panic>
            cprintf("avoid adding the page at MPENTRY_PADDR: 0x%x\n", i * PGSIZE);
f0100ef4:	83 ec 08             	sub    $0x8,%esp
f0100ef7:	68 00 70 00 00       	push   $0x7000
f0100efc:	68 80 62 10 f0       	push   $0xf0106280
f0100f01:	e8 2a 2c 00 00       	call   f0103b30 <cprintf>
            continue;;
f0100f06:	83 c4 10             	add    $0x10,%esp
    for (i = baseMemFreeStart / PGSIZE; i < baseMemFreeEnd / PGSIZE; i++) {
f0100f09:	83 c3 01             	add    $0x1,%ebx
f0100f0c:	39 df                	cmp    %ebx,%edi
f0100f0e:	76 2f                	jbe    f0100f3f <page_init+0xdd>
        if (i == MPENTRY_PADDR / PGSIZE) {
f0100f10:	83 fb 07             	cmp    $0x7,%ebx
f0100f13:	74 df                	je     f0100ef4 <page_init+0x92>
        pages[i].pp_ref = 0;
f0100f15:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
f0100f1c:	89 c2                	mov    %eax,%edx
f0100f1e:	03 15 14 cf 22 f0    	add    0xf022cf14,%edx
f0100f24:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
        pages[i].pp_link = page_free_list;
f0100f2a:	8b 0d 44 c2 22 f0    	mov    0xf022c244,%ecx
f0100f30:	89 0a                	mov    %ecx,(%edx)
        page_free_list = &pages[i];
f0100f32:	03 05 14 cf 22 f0    	add    0xf022cf14,%eax
f0100f38:	a3 44 c2 22 f0       	mov    %eax,0xf022c244
f0100f3d:	eb ca                	jmp    f0100f09 <page_init+0xa7>
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f0100f3f:	c1 ee 0c             	shr    $0xc,%esi
f0100f42:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100f45:	c1 eb 0c             	shr    $0xc,%ebx
f0100f48:	8b 0d 44 c2 22 f0    	mov    0xf022c244,%ecx
f0100f4e:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
f0100f55:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f5a:	bf 01 00 00 00       	mov    $0x1,%edi
f0100f5f:	eb 20                	jmp    f0100f81 <page_init+0x11f>
        pages[i].pp_ref = 0;
f0100f61:	89 c2                	mov    %eax,%edx
f0100f63:	03 15 14 cf 22 f0    	add    0xf022cf14,%edx
f0100f69:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
        pages[i].pp_link = page_free_list;
f0100f6f:	89 0a                	mov    %ecx,(%edx)
        page_free_list = &pages[i];
f0100f71:	89 c1                	mov    %eax,%ecx
f0100f73:	03 0d 14 cf 22 f0    	add    0xf022cf14,%ecx
    for (i = extMemFreeStart / PGSIZE; i < extMemFreeEnd / PGSIZE; i++) {
f0100f79:	83 c6 01             	add    $0x1,%esi
f0100f7c:	83 c0 08             	add    $0x8,%eax
f0100f7f:	89 fa                	mov    %edi,%edx
f0100f81:	39 f3                	cmp    %esi,%ebx
f0100f83:	77 dc                	ja     f0100f61 <page_init+0xff>
f0100f85:	84 d2                	test   %dl,%dl
f0100f87:	75 38                	jne    f0100fc1 <page_init+0x15f>
               PADDR(page_free_list) >> 12);
f0100f89:	a1 44 c2 22 f0       	mov    0xf022c244,%eax
	if ((uint32_t)kva < KERNBASE)
f0100f8e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100f93:	76 34                	jbe    f0100fc9 <page_init+0x167>
	return (physaddr_t)kva - KERNBASE;
f0100f95:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("page_free_list", (uintptr_t) page_free_list, PDX(page_free_list), PADDR(page_free_list),
f0100f9b:	83 ec 0c             	sub    $0xc,%esp
f0100f9e:	89 d1                	mov    %edx,%ecx
f0100fa0:	c1 e9 0c             	shr    $0xc,%ecx
f0100fa3:	51                   	push   %ecx
f0100fa4:	52                   	push   %edx
f0100fa5:	89 c2                	mov    %eax,%edx
f0100fa7:	c1 ea 16             	shr    $0x16,%edx
f0100faa:	52                   	push   %edx
f0100fab:	50                   	push   %eax
f0100fac:	68 e5 6f 10 f0       	push   $0xf0106fe5
f0100fb1:	e8 8e 2b 00 00       	call   f0103b44 <memCprintf>
}
f0100fb6:	83 c4 20             	add    $0x20,%esp
f0100fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fbc:	5b                   	pop    %ebx
f0100fbd:	5e                   	pop    %esi
f0100fbe:	5f                   	pop    %edi
f0100fbf:	5d                   	pop    %ebp
f0100fc0:	c3                   	ret    
f0100fc1:	89 0d 44 c2 22 f0    	mov    %ecx,0xf022c244
f0100fc7:	eb c0                	jmp    f0100f89 <page_init+0x127>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100fc9:	50                   	push   %eax
f0100fca:	68 48 5b 10 f0       	push   $0xf0105b48
f0100fcf:	68 77 01 00 00       	push   $0x177
f0100fd4:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0100fd9:	e8 62 f0 ff ff       	call   f0100040 <_panic>

f0100fde <page_alloc>:
page_alloc(int alloc_flags) {
f0100fde:	55                   	push   %ebp
f0100fdf:	89 e5                	mov    %esp,%ebp
f0100fe1:	53                   	push   %ebx
f0100fe2:	83 ec 04             	sub    $0x4,%esp
    if (!page_free_list) {
f0100fe5:	8b 1d 44 c2 22 f0    	mov    0xf022c244,%ebx
f0100feb:	85 db                	test   %ebx,%ebx
f0100fed:	74 19                	je     f0101008 <page_alloc+0x2a>
    page_free_list = page_free_list->pp_link;
f0100fef:	8b 03                	mov    (%ebx),%eax
f0100ff1:	a3 44 c2 22 f0       	mov    %eax,0xf022c244
    allocPage->pp_link = NULL;
f0100ff6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    allocPage->pp_ref = 0;
f0100ffc:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
    if (alloc_flags & ALLOC_ZERO) {
f0101002:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101006:	75 07                	jne    f010100f <page_alloc+0x31>
}
f0101008:	89 d8                	mov    %ebx,%eax
f010100a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010100d:	c9                   	leave  
f010100e:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f010100f:	89 d8                	mov    %ebx,%eax
f0101011:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0101017:	c1 f8 03             	sar    $0x3,%eax
f010101a:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010101d:	89 c2                	mov    %eax,%edx
f010101f:	c1 ea 0c             	shr    $0xc,%edx
f0101022:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f0101028:	73 1a                	jae    f0101044 <page_alloc+0x66>
        memset(page2kva(allocPage), 0, PGSIZE);
f010102a:	83 ec 04             	sub    $0x4,%esp
f010102d:	68 00 10 00 00       	push   $0x1000
f0101032:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101034:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101039:	50                   	push   %eax
f010103a:	e8 5b 3e 00 00       	call   f0104e9a <memset>
f010103f:	83 c4 10             	add    $0x10,%esp
f0101042:	eb c4                	jmp    f0101008 <page_alloc+0x2a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101044:	50                   	push   %eax
f0101045:	68 24 5b 10 f0       	push   $0xf0105b24
f010104a:	6a 58                	push   $0x58
f010104c:	68 02 6f 10 f0       	push   $0xf0106f02
f0101051:	e8 ea ef ff ff       	call   f0100040 <_panic>

f0101056 <page_free>:
page_free(struct PageInfo *pp) {
f0101056:	55                   	push   %ebp
f0101057:	89 e5                	mov    %esp,%ebp
f0101059:	83 ec 08             	sub    $0x8,%esp
f010105c:	8b 45 08             	mov    0x8(%ebp),%eax
    assert(!pp->pp_ref);
f010105f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101064:	75 14                	jne    f010107a <page_free+0x24>
    assert(!pp->pp_link);
f0101066:	83 38 00             	cmpl   $0x0,(%eax)
f0101069:	75 28                	jne    f0101093 <page_free+0x3d>
    pp->pp_link = page_free_list;
f010106b:	8b 15 44 c2 22 f0    	mov    0xf022c244,%edx
f0101071:	89 10                	mov    %edx,(%eax)
    page_free_list = pp;
f0101073:	a3 44 c2 22 f0       	mov    %eax,0xf022c244
}
f0101078:	c9                   	leave  
f0101079:	c3                   	ret    
    assert(!pp->pp_ref);
f010107a:	68 f4 6f 10 f0       	push   $0xf0106ff4
f010107f:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101084:	68 9e 01 00 00       	push   $0x19e
f0101089:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010108e:	e8 ad ef ff ff       	call   f0100040 <_panic>
    assert(!pp->pp_link);
f0101093:	68 00 70 10 f0       	push   $0xf0107000
f0101098:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010109d:	68 9f 01 00 00       	push   $0x19f
f01010a2:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01010a7:	e8 94 ef ff ff       	call   f0100040 <_panic>

f01010ac <page_decref>:
page_decref(struct PageInfo *pp) {
f01010ac:	55                   	push   %ebp
f01010ad:	89 e5                	mov    %esp,%ebp
f01010af:	83 ec 08             	sub    $0x8,%esp
f01010b2:	8b 55 08             	mov    0x8(%ebp),%edx
    if (--pp->pp_ref == 0)
f01010b5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01010b9:	83 e8 01             	sub    $0x1,%eax
f01010bc:	66 89 42 04          	mov    %ax,0x4(%edx)
f01010c0:	66 85 c0             	test   %ax,%ax
f01010c3:	74 02                	je     f01010c7 <page_decref+0x1b>
}
f01010c5:	c9                   	leave  
f01010c6:	c3                   	ret    
        page_free(pp);
f01010c7:	83 ec 0c             	sub    $0xc,%esp
f01010ca:	52                   	push   %edx
f01010cb:	e8 86 ff ff ff       	call   f0101056 <page_free>
f01010d0:	83 c4 10             	add    $0x10,%esp
}
f01010d3:	eb f0                	jmp    f01010c5 <page_decref+0x19>

f01010d5 <pgdir_walk>:
pgdir_walk(pde_t *pgdir, const void *va, int create) {
f01010d5:	55                   	push   %ebp
f01010d6:	89 e5                	mov    %esp,%ebp
f01010d8:	56                   	push   %esi
f01010d9:	53                   	push   %ebx
f01010da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (!(pgTablePaAddr = PTE_ADDR(pgdir[PDX(va)]))) {
f01010dd:	89 de                	mov    %ebx,%esi
f01010df:	c1 ee 16             	shr    $0x16,%esi
f01010e2:	c1 e6 02             	shl    $0x2,%esi
f01010e5:	03 75 08             	add    0x8(%ebp),%esi
f01010e8:	8b 06                	mov    (%esi),%eax
f01010ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01010ef:	75 2f                	jne    f0101120 <pgdir_walk+0x4b>
        if (!create) {
f01010f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01010f5:	74 62                	je     f0101159 <pgdir_walk+0x84>
            struct PageInfo *pageInfo = page_alloc(ALLOC_ZERO);
f01010f7:	83 ec 0c             	sub    $0xc,%esp
f01010fa:	6a 01                	push   $0x1
f01010fc:	e8 dd fe ff ff       	call   f0100fde <page_alloc>
            if (!pageInfo) {
f0101101:	83 c4 10             	add    $0x10,%esp
f0101104:	85 c0                	test   %eax,%eax
f0101106:	74 58                	je     f0101160 <pgdir_walk+0x8b>
            pageInfo->pp_ref++;
f0101108:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010110d:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0101113:	c1 f8 03             	sar    $0x3,%eax
f0101116:	c1 e0 0c             	shl    $0xc,%eax
            pgdir[PDX(va)] = pgTablePaAddr | PTE_U | PTE_W | PTE_P;//消极权限
f0101119:	89 c2                	mov    %eax,%edx
f010111b:	83 ca 07             	or     $0x7,%edx
f010111e:	89 16                	mov    %edx,(%esi)
	if (PGNUM(pa) >= npages)
f0101120:	89 c2                	mov    %eax,%edx
f0101122:	c1 ea 0c             	shr    $0xc,%edx
f0101125:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f010112b:	73 17                	jae    f0101144 <pgdir_walk+0x6f>
    return &((pte_t *) KADDR(pgTablePaAddr))[PTX(va)];
f010112d:	c1 eb 0a             	shr    $0xa,%ebx
f0101130:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
f0101136:	8d 84 18 00 00 00 f0 	lea    -0x10000000(%eax,%ebx,1),%eax
}
f010113d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101140:	5b                   	pop    %ebx
f0101141:	5e                   	pop    %esi
f0101142:	5d                   	pop    %ebp
f0101143:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101144:	50                   	push   %eax
f0101145:	68 24 5b 10 f0       	push   $0xf0105b24
f010114a:	68 03 02 00 00       	push   $0x203
f010114f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101154:	e8 e7 ee ff ff       	call   f0100040 <_panic>
            return NULL;
f0101159:	b8 00 00 00 00       	mov    $0x0,%eax
f010115e:	eb dd                	jmp    f010113d <pgdir_walk+0x68>
                return NULL;
f0101160:	b8 00 00 00 00       	mov    $0x0,%eax
f0101165:	eb d6                	jmp    f010113d <pgdir_walk+0x68>

f0101167 <boot_map_region>:
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm) {
f0101167:	55                   	push   %ebp
f0101168:	89 e5                	mov    %esp,%ebp
f010116a:	57                   	push   %edi
f010116b:	56                   	push   %esi
f010116c:	53                   	push   %ebx
f010116d:	83 ec 1c             	sub    $0x1c,%esp
f0101170:	89 c7                	mov    %eax,%edi
f0101172:	89 d6                	mov    %edx,%esi
f0101174:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE) {
f0101177:	bb 00 00 00 00       	mov    $0x0,%ebx
        *pte = (pa + offset) | perm | PTE_P;
f010117c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010117f:	83 c8 01             	or     $0x1,%eax
f0101182:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (offset = 0; offset < size; offset += PGSIZE) {
f0101185:	eb 22                	jmp    f01011a9 <boot_map_region+0x42>
        pte_t *pte = pgdir_walk(pgdir, (void *) va + offset, 1);
f0101187:	83 ec 04             	sub    $0x4,%esp
f010118a:	6a 01                	push   $0x1
f010118c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
f010118f:	50                   	push   %eax
f0101190:	57                   	push   %edi
f0101191:	e8 3f ff ff ff       	call   f01010d5 <pgdir_walk>
        *pte = (pa + offset) | perm | PTE_P;
f0101196:	89 da                	mov    %ebx,%edx
f0101198:	03 55 08             	add    0x8(%ebp),%edx
f010119b:	0b 55 e0             	or     -0x20(%ebp),%edx
f010119e:	89 10                	mov    %edx,(%eax)
    for (offset = 0; offset < size; offset += PGSIZE) {
f01011a0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01011a6:	83 c4 10             	add    $0x10,%esp
f01011a9:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01011ac:	72 d9                	jb     f0101187 <boot_map_region+0x20>
}
f01011ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011b1:	5b                   	pop    %ebx
f01011b2:	5e                   	pop    %esi
f01011b3:	5f                   	pop    %edi
f01011b4:	5d                   	pop    %ebp
f01011b5:	c3                   	ret    

f01011b6 <page_lookup>:
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store) {
f01011b6:	55                   	push   %ebp
f01011b7:	89 e5                	mov    %esp,%ebp
f01011b9:	53                   	push   %ebx
f01011ba:	83 ec 08             	sub    $0x8,%esp
f01011bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    pte_t *cur = pgdir_walk(pgdir, va, false);
f01011c0:	6a 00                	push   $0x0
f01011c2:	ff 75 0c             	pushl  0xc(%ebp)
f01011c5:	ff 75 08             	pushl  0x8(%ebp)
f01011c8:	e8 08 ff ff ff       	call   f01010d5 <pgdir_walk>
    if (!cur) {
f01011cd:	83 c4 10             	add    $0x10,%esp
f01011d0:	85 c0                	test   %eax,%eax
f01011d2:	74 35                	je     f0101209 <page_lookup+0x53>
    if (pte_store) {
f01011d4:	85 db                	test   %ebx,%ebx
f01011d6:	74 02                	je     f01011da <page_lookup+0x24>
        *pte_store = cur;
f01011d8:	89 03                	mov    %eax,(%ebx)
f01011da:	8b 00                	mov    (%eax),%eax
f01011dc:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01011df:	39 05 0c cf 22 f0    	cmp    %eax,0xf022cf0c
f01011e5:	76 0e                	jbe    f01011f5 <page_lookup+0x3f>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01011e7:	8b 15 14 cf 22 f0    	mov    0xf022cf14,%edx
f01011ed:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01011f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01011f3:	c9                   	leave  
f01011f4:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01011f5:	83 ec 04             	sub    $0x4,%esp
f01011f8:	68 b0 62 10 f0       	push   $0xf01062b0
f01011fd:	6a 51                	push   $0x51
f01011ff:	68 02 6f 10 f0       	push   $0xf0106f02
f0101204:	e8 37 ee ff ff       	call   f0100040 <_panic>
        return NULL;
f0101209:	b8 00 00 00 00       	mov    $0x0,%eax
f010120e:	eb e0                	jmp    f01011f0 <page_lookup+0x3a>

f0101210 <page_remove>:
page_remove(pde_t *pgdir, void *va) {
f0101210:	55                   	push   %ebp
f0101211:	89 e5                	mov    %esp,%ebp
f0101213:	53                   	push   %ebx
f0101214:	83 ec 18             	sub    $0x18,%esp
f0101217:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    struct PageInfo *pageInfo = page_lookup(pgdir, va, &pte);
f010121a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010121d:	50                   	push   %eax
f010121e:	53                   	push   %ebx
f010121f:	ff 75 08             	pushl  0x8(%ebp)
f0101222:	e8 8f ff ff ff       	call   f01011b6 <page_lookup>
    if (!pageInfo) {
f0101227:	83 c4 10             	add    $0x10,%esp
f010122a:	85 c0                	test   %eax,%eax
f010122c:	75 05                	jne    f0101233 <page_remove+0x23>
}
f010122e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101231:	c9                   	leave  
f0101232:	c3                   	ret    
    page_decref(pageInfo);
f0101233:	83 ec 0c             	sub    $0xc,%esp
f0101236:	50                   	push   %eax
f0101237:	e8 70 fe ff ff       	call   f01010ac <page_decref>
    memset(pte, 0, sizeof(pte_t));
f010123c:	83 c4 0c             	add    $0xc,%esp
f010123f:	6a 04                	push   $0x4
f0101241:	6a 00                	push   $0x0
f0101243:	ff 75 f4             	pushl  -0xc(%ebp)
f0101246:	e8 4f 3c 00 00       	call   f0104e9a <memset>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010124b:	0f 01 3b             	invlpg (%ebx)
f010124e:	83 c4 10             	add    $0x10,%esp
f0101251:	eb db                	jmp    f010122e <page_remove+0x1e>

f0101253 <page_insert>:
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm) {
f0101253:	55                   	push   %ebp
f0101254:	89 e5                	mov    %esp,%ebp
f0101256:	57                   	push   %edi
f0101257:	56                   	push   %esi
f0101258:	53                   	push   %ebx
f0101259:	83 ec 20             	sub    $0x20,%esp
f010125c:	8b 75 08             	mov    0x8(%ebp),%esi
f010125f:	8b 7d 10             	mov    0x10(%ebp),%edi
    pte_t *cur = pgdir_walk(pgdir, va, false);
f0101262:	6a 00                	push   $0x0
f0101264:	57                   	push   %edi
f0101265:	56                   	push   %esi
f0101266:	e8 6a fe ff ff       	call   f01010d5 <pgdir_walk>
f010126b:	89 c3                	mov    %eax,%ebx
    if (cur) {
f010126d:	83 c4 10             	add    $0x10,%esp
f0101270:	85 c0                	test   %eax,%eax
f0101272:	74 41                	je     f01012b5 <page_insert+0x62>
f0101274:	8b 00                	mov    (%eax),%eax
f0101276:	c1 e8 0c             	shr    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101279:	39 05 0c cf 22 f0    	cmp    %eax,0xf022cf0c
f010127f:	76 20                	jbe    f01012a1 <page_insert+0x4e>
	return &pages[PGNUM(pa)];
f0101281:	8b 15 14 cf 22 f0    	mov    0xf022cf14,%edx
f0101287:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f010128a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (tmp != pp) {
f010128d:	39 45 0c             	cmp    %eax,0xc(%ebp)
f0101290:	74 2a                	je     f01012bc <page_insert+0x69>
            page_remove(pgdir, va);
f0101292:	83 ec 08             	sub    $0x8,%esp
f0101295:	57                   	push   %edi
f0101296:	56                   	push   %esi
f0101297:	e8 74 ff ff ff       	call   f0101210 <page_remove>
f010129c:	83 c4 10             	add    $0x10,%esp
f010129f:	eb 1b                	jmp    f01012bc <page_insert+0x69>
		panic("pa2page called with invalid pa");
f01012a1:	83 ec 04             	sub    $0x4,%esp
f01012a4:	68 b0 62 10 f0       	push   $0xf01062b0
f01012a9:	6a 51                	push   $0x51
f01012ab:	68 02 6f 10 f0       	push   $0xf0106f02
f01012b0:	e8 8b ed ff ff       	call   f0100040 <_panic>
    struct PageInfo *tmp = NULL;
f01012b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    physaddr_t pgTablePaAddr = PTE_ADDR(pgdir[PDX(va)]);
f01012bc:	89 f8                	mov    %edi,%eax
f01012be:	c1 e8 16             	shr    $0x16,%eax
f01012c1:	8d 34 86             	lea    (%esi,%eax,4),%esi
    if (!pgTablePaAddr) {
f01012c4:	8b 06                	mov    (%esi),%eax
f01012c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01012cb:	74 64                	je     f0101331 <page_insert+0xde>
	return (pp - pages) << PGSHIFT;
f01012cd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01012d0:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f01012d6:	c1 fa 03             	sar    $0x3,%edx
f01012d9:	c1 e2 0c             	shl    $0xc,%edx
f01012dc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01012df:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01012e2:	83 c9 01             	or     $0x1,%ecx
	if (PGNUM(pa) >= npages)
f01012e5:	89 c2                	mov    %eax,%edx
f01012e7:	c1 ea 0c             	shr    $0xc,%edx
f01012ea:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f01012f0:	73 70                	jae    f0101362 <page_insert+0x10f>
    ((pte_t *) KADDR(pgTablePaAddr))[PTX(va)] = page2pa(pp) | perm | PTE_P;
f01012f2:	c1 ef 0c             	shr    $0xc,%edi
f01012f5:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
f01012fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01012fe:	09 ca                	or     %ecx,%edx
f0101300:	89 94 b8 00 00 00 f0 	mov    %edx,-0x10000000(%eax,%edi,4)
    pgdir[PDX(va)] = pgTablePaAddr | perm | PTE_P;
f0101307:	09 c8                	or     %ecx,%eax
f0101309:	89 06                	mov    %eax,(%esi)
    if (!cur || tmp != pp) {
f010130b:	85 db                	test   %ebx,%ebx
f010130d:	74 0d                	je     f010131c <page_insert+0xc9>
    return 0;
f010130f:	b8 00 00 00 00       	mov    $0x0,%eax
    if (!cur || tmp != pp) {
f0101314:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0101317:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f010131a:	74 0d                	je     f0101329 <page_insert+0xd6>
        pp->pp_ref++;
f010131c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010131f:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    return 0;
f0101324:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101329:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010132c:	5b                   	pop    %ebx
f010132d:	5e                   	pop    %esi
f010132e:	5f                   	pop    %edi
f010132f:	5d                   	pop    %ebp
f0101330:	c3                   	ret    
        struct PageInfo *pageInfo = page_alloc(ALLOC_ZERO);
f0101331:	83 ec 0c             	sub    $0xc,%esp
f0101334:	6a 01                	push   $0x1
f0101336:	e8 a3 fc ff ff       	call   f0100fde <page_alloc>
        if (!pageInfo) {
f010133b:	83 c4 10             	add    $0x10,%esp
f010133e:	85 c0                	test   %eax,%eax
f0101340:	74 35                	je     f0101377 <page_insert+0x124>
        pageInfo->pp_ref++;
f0101342:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101347:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f010134d:	c1 f8 03             	sar    $0x3,%eax
f0101350:	c1 e0 0c             	shl    $0xc,%eax
        pgdir[PDX(va)] = pgTablePaAddr | perm | PTE_P;
f0101353:	8b 55 14             	mov    0x14(%ebp),%edx
f0101356:	83 ca 01             	or     $0x1,%edx
f0101359:	09 c2                	or     %eax,%edx
f010135b:	89 16                	mov    %edx,(%esi)
f010135d:	e9 6b ff ff ff       	jmp    f01012cd <page_insert+0x7a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101362:	50                   	push   %eax
f0101363:	68 24 5b 10 f0       	push   $0xf0105b24
f0101368:	68 4f 02 00 00       	push   $0x24f
f010136d:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101372:	e8 c9 ec ff ff       	call   f0100040 <_panic>
            return -E_NO_MEM;
f0101377:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010137c:	eb ab                	jmp    f0101329 <page_insert+0xd6>

f010137e <mem_init>:
mem_init(void) {
f010137e:	55                   	push   %ebp
f010137f:	89 e5                	mov    %esp,%ebp
f0101381:	57                   	push   %edi
f0101382:	56                   	push   %esi
f0101383:	53                   	push   %ebx
f0101384:	83 ec 3c             	sub    $0x3c,%esp
    basemem = nvram_read(NVRAM_BASELO);
f0101387:	b8 15 00 00 00       	mov    $0x15,%eax
f010138c:	e8 90 f6 ff ff       	call   f0100a21 <nvram_read>
f0101391:	89 c3                	mov    %eax,%ebx
    extmem = nvram_read(NVRAM_EXTLO);
f0101393:	b8 17 00 00 00       	mov    $0x17,%eax
f0101398:	e8 84 f6 ff ff       	call   f0100a21 <nvram_read>
f010139d:	89 c6                	mov    %eax,%esi
    ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f010139f:	b8 34 00 00 00       	mov    $0x34,%eax
f01013a4:	e8 78 f6 ff ff       	call   f0100a21 <nvram_read>
f01013a9:	c1 e0 06             	shl    $0x6,%eax
    if (ext16mem)
f01013ac:	85 c0                	test   %eax,%eax
f01013ae:	0f 85 3c 02 00 00    	jne    f01015f0 <mem_init+0x272>
        totalmem = 1 * 1024 + extmem;
f01013b4:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01013ba:	85 f6                	test   %esi,%esi
f01013bc:	0f 44 c3             	cmove  %ebx,%eax
f01013bf:	a3 40 c2 22 f0       	mov    %eax,0xf022c240
    npages = totalmem / (PGSIZE / 1024);
f01013c4:	a1 40 c2 22 f0       	mov    0xf022c240,%eax
f01013c9:	89 c2                	mov    %eax,%edx
f01013cb:	c1 ea 02             	shr    $0x2,%edx
f01013ce:	89 15 0c cf 22 f0    	mov    %edx,0xf022cf0c
    npages_basemem = basemem / (PGSIZE / 1024);
f01013d4:	89 da                	mov    %ebx,%edx
f01013d6:	c1 ea 02             	shr    $0x2,%edx
f01013d9:	89 15 48 c2 22 f0    	mov    %edx,0xf022c248
    cprintf("Physical memory: 0x%xK available\tbase = 0x%xK\textended = 0x%xK\n",
f01013df:	89 c2                	mov    %eax,%edx
f01013e1:	29 da                	sub    %ebx,%edx
f01013e3:	52                   	push   %edx
f01013e4:	53                   	push   %ebx
f01013e5:	50                   	push   %eax
f01013e6:	68 d0 62 10 f0       	push   $0xf01062d0
f01013eb:	e8 40 27 00 00       	call   f0103b30 <cprintf>
    cprintf("sizeof(uint16_t):0x%x\n", sizeof(unsigned short));
f01013f0:	83 c4 08             	add    $0x8,%esp
f01013f3:	6a 02                	push   $0x2
f01013f5:	68 0d 70 10 f0       	push   $0xf010700d
f01013fa:	e8 31 27 00 00       	call   f0103b30 <cprintf>
    cprintf("npages:0x%x\tsizeof(Struct PageInfo):0x%x\n", npages, sizeof(struct PageInfo));
f01013ff:	83 c4 0c             	add    $0xc,%esp
f0101402:	6a 08                	push   $0x8
f0101404:	ff 35 0c cf 22 f0    	pushl  0xf022cf0c
f010140a:	68 10 63 10 f0       	push   $0xf0106310
f010140f:	e8 1c 27 00 00       	call   f0103b30 <cprintf>
    kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101414:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101419:	e8 2c f6 ff ff       	call   f0100a4a <boot_alloc>
f010141e:	a3 10 cf 22 f0       	mov    %eax,0xf022cf10
	if ((uint32_t)kva < KERNBASE)
f0101423:	83 c4 10             	add    $0x10,%esp
f0101426:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010142b:	0f 86 ce 01 00 00    	jbe    f01015ff <mem_init+0x281>
	return (physaddr_t)kva - KERNBASE;
f0101431:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
    memCprintf("kern_pgdir", (uintptr_t) kern_pgdir, PDX(kern_pgdir), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f0101437:	83 ec 0c             	sub    $0xc,%esp
f010143a:	89 d1                	mov    %edx,%ecx
f010143c:	c1 e9 0c             	shr    $0xc,%ecx
f010143f:	51                   	push   %ecx
f0101440:	52                   	push   %edx
f0101441:	89 c2                	mov    %eax,%edx
f0101443:	c1 ea 16             	shr    $0x16,%edx
f0101446:	52                   	push   %edx
f0101447:	50                   	push   %eax
f0101448:	68 24 70 10 f0       	push   $0xf0107024
f010144d:	e8 f2 26 00 00       	call   f0103b44 <memCprintf>
    memset(kern_pgdir, 0, PGSIZE);
f0101452:	83 c4 1c             	add    $0x1c,%esp
f0101455:	68 00 10 00 00       	push   $0x1000
f010145a:	6a 00                	push   $0x0
f010145c:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101462:	e8 33 3a 00 00       	call   f0104e9a <memset>
    kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101467:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f010146c:	83 c4 10             	add    $0x10,%esp
f010146f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101474:	0f 86 9a 01 00 00    	jbe    f0101614 <mem_init+0x296>
	return (physaddr_t)kva - KERNBASE;
f010147a:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101480:	89 d1                	mov    %edx,%ecx
f0101482:	83 c9 05             	or     $0x5,%ecx
f0101485:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f010148b:	83 ec 0c             	sub    $0xc,%esp
f010148e:	89 d0                	mov    %edx,%eax
f0101490:	c1 e8 0c             	shr    $0xc,%eax
f0101493:	50                   	push   %eax
f0101494:	52                   	push   %edx
f0101495:	68 bd 03 00 00       	push   $0x3bd
f010149a:	68 00 00 40 ef       	push   $0xef400000
f010149f:	68 2f 70 10 f0       	push   $0xf010702f
f01014a4:	e8 9b 26 00 00       	call   f0103b44 <memCprintf>
    pages = boot_alloc(ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01014a9:	83 c4 20             	add    $0x20,%esp
f01014ac:	a1 0c cf 22 f0       	mov    0xf022cf0c,%eax
f01014b1:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01014b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01014bd:	e8 88 f5 ff ff       	call   f0100a4a <boot_alloc>
f01014c2:	a3 14 cf 22 f0       	mov    %eax,0xf022cf14
    memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01014c7:	83 ec 04             	sub    $0x4,%esp
f01014ca:	8b 15 0c cf 22 f0    	mov    0xf022cf0c,%edx
f01014d0:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f01014d7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01014dd:	52                   	push   %edx
f01014de:	6a 00                	push   $0x0
f01014e0:	50                   	push   %eax
f01014e1:	e8 b4 39 00 00       	call   f0104e9a <memset>
    cprintf("pages占用空间:%dK\n", ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE) / 1024);
f01014e6:	83 c4 08             	add    $0x8,%esp
f01014e9:	a1 0c cf 22 f0       	mov    0xf022cf0c,%eax
f01014ee:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01014f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01014fa:	c1 e8 0a             	shr    $0xa,%eax
f01014fd:	50                   	push   %eax
f01014fe:	68 34 70 10 f0       	push   $0xf0107034
f0101503:	e8 28 26 00 00       	call   f0103b30 <cprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f0101508:	a1 14 cf 22 f0       	mov    0xf022cf14,%eax
	if ((uint32_t)kva < KERNBASE)
f010150d:	83 c4 10             	add    $0x10,%esp
f0101510:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101515:	0f 86 0e 01 00 00    	jbe    f0101629 <mem_init+0x2ab>
	return (physaddr_t)kva - KERNBASE;
f010151b:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101521:	83 ec 0c             	sub    $0xc,%esp
f0101524:	89 d1                	mov    %edx,%ecx
f0101526:	c1 e9 0c             	shr    $0xc,%ecx
f0101529:	51                   	push   %ecx
f010152a:	52                   	push   %edx
f010152b:	89 c2                	mov    %eax,%edx
f010152d:	c1 ea 16             	shr    $0x16,%edx
f0101530:	52                   	push   %edx
f0101531:	50                   	push   %eax
f0101532:	68 2c 6f 10 f0       	push   $0xf0106f2c
f0101537:	e8 08 26 00 00       	call   f0103b44 <memCprintf>
    cprintf("sizeof(struct Env):0x%x\n", sizeof(struct Env));
f010153c:	83 c4 18             	add    $0x18,%esp
f010153f:	6a 7c                	push   $0x7c
f0101541:	68 4b 70 10 f0       	push   $0xf010704b
f0101546:	e8 e5 25 00 00       	call   f0103b30 <cprintf>
    envs = boot_alloc(ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f010154b:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101550:	e8 f5 f4 ff ff       	call   f0100a4a <boot_alloc>
f0101555:	a3 4c c2 22 f0       	mov    %eax,0xf022c24c
    memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f010155a:	83 c4 0c             	add    $0xc,%esp
f010155d:	68 00 f0 01 00       	push   $0x1f000
f0101562:	6a 00                	push   $0x0
f0101564:	50                   	push   %eax
f0101565:	e8 30 39 00 00       	call   f0104e9a <memset>
    cprintf("envs take up memory:%dK\n", ROUNDUP(NENV * sizeof(struct Env), PGSIZE) / 1024);
f010156a:	83 c4 08             	add    $0x8,%esp
f010156d:	6a 7c                	push   $0x7c
f010156f:	68 64 70 10 f0       	push   $0xf0107064
f0101574:	e8 b7 25 00 00       	call   f0103b30 <cprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f0101579:	a1 4c c2 22 f0       	mov    0xf022c24c,%eax
	if ((uint32_t)kva < KERNBASE)
f010157e:	83 c4 10             	add    $0x10,%esp
f0101581:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101586:	0f 86 b2 00 00 00    	jbe    f010163e <mem_init+0x2c0>
	return (physaddr_t)kva - KERNBASE;
f010158c:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101592:	83 ec 0c             	sub    $0xc,%esp
f0101595:	89 d1                	mov    %edx,%ecx
f0101597:	c1 e9 0c             	shr    $0xc,%ecx
f010159a:	51                   	push   %ecx
f010159b:	52                   	push   %edx
f010159c:	89 c2                	mov    %eax,%edx
f010159e:	c1 ea 16             	shr    $0x16,%edx
f01015a1:	52                   	push   %edx
f01015a2:	50                   	push   %eax
f01015a3:	68 7d 70 10 f0       	push   $0xf010707d
f01015a8:	e8 97 25 00 00       	call   f0103b44 <memCprintf>
    page_init();
f01015ad:	83 c4 20             	add    $0x20,%esp
f01015b0:	e8 ad f8 ff ff       	call   f0100e62 <page_init>
    cprintf("\n************* Now Check that the pages on the page_free_list are reasonable ************\n");
f01015b5:	83 ec 0c             	sub    $0xc,%esp
f01015b8:	68 3c 63 10 f0       	push   $0xf010633c
f01015bd:	e8 6e 25 00 00       	call   f0103b30 <cprintf>
    check_page_free_list(1);
f01015c2:	b8 01 00 00 00       	mov    $0x1,%eax
f01015c7:	e8 44 f5 ff ff       	call   f0100b10 <check_page_free_list>
    cprintf("\n************* Now check the real physical page allocator (page_alloc(), page_free(), and page_init())************\n");
f01015cc:	c7 04 24 98 63 10 f0 	movl   $0xf0106398,(%esp)
f01015d3:	e8 58 25 00 00       	call   f0103b30 <cprintf>
    if (!pages)
f01015d8:	83 c4 10             	add    $0x10,%esp
f01015db:	83 3d 14 cf 22 f0 00 	cmpl   $0x0,0xf022cf14
f01015e2:	74 6f                	je     f0101653 <mem_init+0x2d5>
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01015e4:	a1 44 c2 22 f0       	mov    0xf022c244,%eax
f01015e9:	bb 00 00 00 00       	mov    $0x0,%ebx
f01015ee:	eb 7f                	jmp    f010166f <mem_init+0x2f1>
        totalmem = 16 * 1024 + ext16mem;
f01015f0:	05 00 40 00 00       	add    $0x4000,%eax
f01015f5:	a3 40 c2 22 f0       	mov    %eax,0xf022c240
f01015fa:	e9 c5 fd ff ff       	jmp    f01013c4 <mem_init+0x46>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01015ff:	50                   	push   %eax
f0101600:	68 48 5b 10 f0       	push   $0xf0105b48
f0101605:	68 98 00 00 00       	push   $0x98
f010160a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010160f:	e8 2c ea ff ff       	call   f0100040 <_panic>
f0101614:	50                   	push   %eax
f0101615:	68 48 5b 10 f0       	push   $0xf0105b48
f010161a:	68 a2 00 00 00       	push   $0xa2
f010161f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101624:	e8 17 ea ff ff       	call   f0100040 <_panic>
f0101629:	50                   	push   %eax
f010162a:	68 48 5b 10 f0       	push   $0xf0105b48
f010162f:	68 af 00 00 00       	push   $0xaf
f0101634:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101639:	e8 02 ea ff ff       	call   f0100040 <_panic>
f010163e:	50                   	push   %eax
f010163f:	68 48 5b 10 f0       	push   $0xf0105b48
f0101644:	68 b7 00 00 00       	push   $0xb7
f0101649:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010164e:	e8 ed e9 ff ff       	call   f0100040 <_panic>
        panic("'pages' is a null pointer!");
f0101653:	83 ec 04             	sub    $0x4,%esp
f0101656:	68 82 70 10 f0       	push   $0xf0107082
f010165b:	68 62 03 00 00       	push   $0x362
f0101660:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101665:	e8 d6 e9 ff ff       	call   f0100040 <_panic>
        ++nfree;
f010166a:	83 c3 01             	add    $0x1,%ebx
    for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010166d:	8b 00                	mov    (%eax),%eax
f010166f:	85 c0                	test   %eax,%eax
f0101671:	75 f7                	jne    f010166a <mem_init+0x2ec>
    assert((pp0 = page_alloc(0)));
f0101673:	83 ec 0c             	sub    $0xc,%esp
f0101676:	6a 00                	push   $0x0
f0101678:	e8 61 f9 ff ff       	call   f0100fde <page_alloc>
f010167d:	89 c7                	mov    %eax,%edi
f010167f:	83 c4 10             	add    $0x10,%esp
f0101682:	85 c0                	test   %eax,%eax
f0101684:	0f 84 12 02 00 00    	je     f010189c <mem_init+0x51e>
    assert((pp1 = page_alloc(0)));
f010168a:	83 ec 0c             	sub    $0xc,%esp
f010168d:	6a 00                	push   $0x0
f010168f:	e8 4a f9 ff ff       	call   f0100fde <page_alloc>
f0101694:	89 c6                	mov    %eax,%esi
f0101696:	83 c4 10             	add    $0x10,%esp
f0101699:	85 c0                	test   %eax,%eax
f010169b:	0f 84 14 02 00 00    	je     f01018b5 <mem_init+0x537>
    assert((pp2 = page_alloc(0)));
f01016a1:	83 ec 0c             	sub    $0xc,%esp
f01016a4:	6a 00                	push   $0x0
f01016a6:	e8 33 f9 ff ff       	call   f0100fde <page_alloc>
f01016ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01016ae:	83 c4 10             	add    $0x10,%esp
f01016b1:	85 c0                	test   %eax,%eax
f01016b3:	0f 84 15 02 00 00    	je     f01018ce <mem_init+0x550>
    assert(pp1 && pp1 != pp0);
f01016b9:	39 f7                	cmp    %esi,%edi
f01016bb:	0f 84 26 02 00 00    	je     f01018e7 <mem_init+0x569>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01016c4:	39 c6                	cmp    %eax,%esi
f01016c6:	0f 84 34 02 00 00    	je     f0101900 <mem_init+0x582>
f01016cc:	39 c7                	cmp    %eax,%edi
f01016ce:	0f 84 2c 02 00 00    	je     f0101900 <mem_init+0x582>
	return (pp - pages) << PGSHIFT;
f01016d4:	8b 0d 14 cf 22 f0    	mov    0xf022cf14,%ecx
    assert(page2pa(pp0) < npages * PGSIZE);
f01016da:	8b 15 0c cf 22 f0    	mov    0xf022cf0c,%edx
f01016e0:	c1 e2 0c             	shl    $0xc,%edx
f01016e3:	89 f8                	mov    %edi,%eax
f01016e5:	29 c8                	sub    %ecx,%eax
f01016e7:	c1 f8 03             	sar    $0x3,%eax
f01016ea:	c1 e0 0c             	shl    $0xc,%eax
f01016ed:	39 d0                	cmp    %edx,%eax
f01016ef:	0f 83 24 02 00 00    	jae    f0101919 <mem_init+0x59b>
f01016f5:	89 f0                	mov    %esi,%eax
f01016f7:	29 c8                	sub    %ecx,%eax
f01016f9:	c1 f8 03             	sar    $0x3,%eax
f01016fc:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp1) < npages * PGSIZE);
f01016ff:	39 c2                	cmp    %eax,%edx
f0101701:	0f 86 2b 02 00 00    	jbe    f0101932 <mem_init+0x5b4>
f0101707:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010170a:	29 c8                	sub    %ecx,%eax
f010170c:	c1 f8 03             	sar    $0x3,%eax
f010170f:	c1 e0 0c             	shl    $0xc,%eax
    assert(page2pa(pp2) < npages * PGSIZE);
f0101712:	39 c2                	cmp    %eax,%edx
f0101714:	0f 86 31 02 00 00    	jbe    f010194b <mem_init+0x5cd>
    fl = page_free_list;
f010171a:	a1 44 c2 22 f0       	mov    0xf022c244,%eax
f010171f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    page_free_list = 0;
f0101722:	c7 05 44 c2 22 f0 00 	movl   $0x0,0xf022c244
f0101729:	00 00 00 
    assert(!page_alloc(0));
f010172c:	83 ec 0c             	sub    $0xc,%esp
f010172f:	6a 00                	push   $0x0
f0101731:	e8 a8 f8 ff ff       	call   f0100fde <page_alloc>
f0101736:	83 c4 10             	add    $0x10,%esp
f0101739:	85 c0                	test   %eax,%eax
f010173b:	0f 85 23 02 00 00    	jne    f0101964 <mem_init+0x5e6>
    page_free(pp0);
f0101741:	83 ec 0c             	sub    $0xc,%esp
f0101744:	57                   	push   %edi
f0101745:	e8 0c f9 ff ff       	call   f0101056 <page_free>
    page_free(pp1);
f010174a:	89 34 24             	mov    %esi,(%esp)
f010174d:	e8 04 f9 ff ff       	call   f0101056 <page_free>
    page_free(pp2);
f0101752:	83 c4 04             	add    $0x4,%esp
f0101755:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101758:	e8 f9 f8 ff ff       	call   f0101056 <page_free>
    assert((pp0 = page_alloc(0)));
f010175d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101764:	e8 75 f8 ff ff       	call   f0100fde <page_alloc>
f0101769:	89 c6                	mov    %eax,%esi
f010176b:	83 c4 10             	add    $0x10,%esp
f010176e:	85 c0                	test   %eax,%eax
f0101770:	0f 84 07 02 00 00    	je     f010197d <mem_init+0x5ff>
    assert((pp1 = page_alloc(0)));
f0101776:	83 ec 0c             	sub    $0xc,%esp
f0101779:	6a 00                	push   $0x0
f010177b:	e8 5e f8 ff ff       	call   f0100fde <page_alloc>
f0101780:	89 c7                	mov    %eax,%edi
f0101782:	83 c4 10             	add    $0x10,%esp
f0101785:	85 c0                	test   %eax,%eax
f0101787:	0f 84 09 02 00 00    	je     f0101996 <mem_init+0x618>
    assert((pp2 = page_alloc(0)));
f010178d:	83 ec 0c             	sub    $0xc,%esp
f0101790:	6a 00                	push   $0x0
f0101792:	e8 47 f8 ff ff       	call   f0100fde <page_alloc>
f0101797:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010179a:	83 c4 10             	add    $0x10,%esp
f010179d:	85 c0                	test   %eax,%eax
f010179f:	0f 84 0a 02 00 00    	je     f01019af <mem_init+0x631>
    assert(pp1 && pp1 != pp0);
f01017a5:	39 fe                	cmp    %edi,%esi
f01017a7:	0f 84 1b 02 00 00    	je     f01019c8 <mem_init+0x64a>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01017b0:	39 c6                	cmp    %eax,%esi
f01017b2:	0f 84 29 02 00 00    	je     f01019e1 <mem_init+0x663>
f01017b8:	39 c7                	cmp    %eax,%edi
f01017ba:	0f 84 21 02 00 00    	je     f01019e1 <mem_init+0x663>
    assert(!page_alloc(0));
f01017c0:	83 ec 0c             	sub    $0xc,%esp
f01017c3:	6a 00                	push   $0x0
f01017c5:	e8 14 f8 ff ff       	call   f0100fde <page_alloc>
f01017ca:	83 c4 10             	add    $0x10,%esp
f01017cd:	85 c0                	test   %eax,%eax
f01017cf:	0f 85 25 02 00 00    	jne    f01019fa <mem_init+0x67c>
f01017d5:	89 f0                	mov    %esi,%eax
f01017d7:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f01017dd:	c1 f8 03             	sar    $0x3,%eax
f01017e0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01017e3:	89 c2                	mov    %eax,%edx
f01017e5:	c1 ea 0c             	shr    $0xc,%edx
f01017e8:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f01017ee:	0f 83 1f 02 00 00    	jae    f0101a13 <mem_init+0x695>
    memset(page2kva(pp0), 1, PGSIZE);
f01017f4:	83 ec 04             	sub    $0x4,%esp
f01017f7:	68 00 10 00 00       	push   $0x1000
f01017fc:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01017fe:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101803:	50                   	push   %eax
f0101804:	e8 91 36 00 00       	call   f0104e9a <memset>
    page_free(pp0);
f0101809:	89 34 24             	mov    %esi,(%esp)
f010180c:	e8 45 f8 ff ff       	call   f0101056 <page_free>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101811:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101818:	e8 c1 f7 ff ff       	call   f0100fde <page_alloc>
f010181d:	83 c4 10             	add    $0x10,%esp
f0101820:	85 c0                	test   %eax,%eax
f0101822:	0f 84 fd 01 00 00    	je     f0101a25 <mem_init+0x6a7>
    assert(pp && pp0 == pp);
f0101828:	39 c6                	cmp    %eax,%esi
f010182a:	0f 85 0e 02 00 00    	jne    f0101a3e <mem_init+0x6c0>
	return (pp - pages) << PGSHIFT;
f0101830:	89 f2                	mov    %esi,%edx
f0101832:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f0101838:	c1 fa 03             	sar    $0x3,%edx
f010183b:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010183e:	89 d0                	mov    %edx,%eax
f0101840:	c1 e8 0c             	shr    $0xc,%eax
f0101843:	3b 05 0c cf 22 f0    	cmp    0xf022cf0c,%eax
f0101849:	0f 83 08 02 00 00    	jae    f0101a57 <mem_init+0x6d9>
	return (void *)(pa + KERNBASE);
f010184f:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101855:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
        assert(c[i] == 0);
f010185b:	80 38 00             	cmpb   $0x0,(%eax)
f010185e:	0f 85 05 02 00 00    	jne    f0101a69 <mem_init+0x6eb>
f0101864:	83 c0 01             	add    $0x1,%eax
    for (i = 0; i < PGSIZE; i++)
f0101867:	39 d0                	cmp    %edx,%eax
f0101869:	75 f0                	jne    f010185b <mem_init+0x4dd>
    page_free_list = fl;
f010186b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010186e:	a3 44 c2 22 f0       	mov    %eax,0xf022c244
    page_free(pp0);
f0101873:	83 ec 0c             	sub    $0xc,%esp
f0101876:	56                   	push   %esi
f0101877:	e8 da f7 ff ff       	call   f0101056 <page_free>
    page_free(pp1);
f010187c:	89 3c 24             	mov    %edi,(%esp)
f010187f:	e8 d2 f7 ff ff       	call   f0101056 <page_free>
    page_free(pp2);
f0101884:	83 c4 04             	add    $0x4,%esp
f0101887:	ff 75 d4             	pushl  -0x2c(%ebp)
f010188a:	e8 c7 f7 ff ff       	call   f0101056 <page_free>
    for (pp = page_free_list; pp; pp = pp->pp_link)
f010188f:	a1 44 c2 22 f0       	mov    0xf022c244,%eax
f0101894:	83 c4 10             	add    $0x10,%esp
f0101897:	e9 eb 01 00 00       	jmp    f0101a87 <mem_init+0x709>
    assert((pp0 = page_alloc(0)));
f010189c:	68 9d 70 10 f0       	push   $0xf010709d
f01018a1:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01018a6:	68 6a 03 00 00       	push   $0x36a
f01018ab:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01018b0:	e8 8b e7 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f01018b5:	68 b3 70 10 f0       	push   $0xf01070b3
f01018ba:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01018bf:	68 6b 03 00 00       	push   $0x36b
f01018c4:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01018c9:	e8 72 e7 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f01018ce:	68 c9 70 10 f0       	push   $0xf01070c9
f01018d3:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01018d8:	68 6c 03 00 00       	push   $0x36c
f01018dd:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01018e2:	e8 59 e7 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01018e7:	68 df 70 10 f0       	push   $0xf01070df
f01018ec:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01018f1:	68 6f 03 00 00       	push   $0x36f
f01018f6:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01018fb:	e8 40 e7 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101900:	68 0c 64 10 f0       	push   $0xf010640c
f0101905:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010190a:	68 70 03 00 00       	push   $0x370
f010190f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101914:	e8 27 e7 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp0) < npages * PGSIZE);
f0101919:	68 2c 64 10 f0       	push   $0xf010642c
f010191e:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101923:	68 71 03 00 00       	push   $0x371
f0101928:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010192d:	e8 0e e7 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp1) < npages * PGSIZE);
f0101932:	68 4c 64 10 f0       	push   $0xf010644c
f0101937:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010193c:	68 72 03 00 00       	push   $0x372
f0101941:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101946:	e8 f5 e6 ff ff       	call   f0100040 <_panic>
    assert(page2pa(pp2) < npages * PGSIZE);
f010194b:	68 6c 64 10 f0       	push   $0xf010646c
f0101950:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101955:	68 73 03 00 00       	push   $0x373
f010195a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010195f:	e8 dc e6 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0101964:	68 f1 70 10 f0       	push   $0xf01070f1
f0101969:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010196e:	68 7a 03 00 00       	push   $0x37a
f0101973:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101978:	e8 c3 e6 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f010197d:	68 9d 70 10 f0       	push   $0xf010709d
f0101982:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101987:	68 81 03 00 00       	push   $0x381
f010198c:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101991:	e8 aa e6 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0101996:	68 b3 70 10 f0       	push   $0xf01070b3
f010199b:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01019a0:	68 82 03 00 00       	push   $0x382
f01019a5:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01019aa:	e8 91 e6 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f01019af:	68 c9 70 10 f0       	push   $0xf01070c9
f01019b4:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01019b9:	68 83 03 00 00       	push   $0x383
f01019be:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01019c3:	e8 78 e6 ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f01019c8:	68 df 70 10 f0       	push   $0xf01070df
f01019cd:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01019d2:	68 85 03 00 00       	push   $0x385
f01019d7:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01019dc:	e8 5f e6 ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019e1:	68 0c 64 10 f0       	push   $0xf010640c
f01019e6:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01019eb:	68 86 03 00 00       	push   $0x386
f01019f0:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01019f5:	e8 46 e6 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01019fa:	68 f1 70 10 f0       	push   $0xf01070f1
f01019ff:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101a04:	68 87 03 00 00       	push   $0x387
f0101a09:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101a0e:	e8 2d e6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101a13:	50                   	push   %eax
f0101a14:	68 24 5b 10 f0       	push   $0xf0105b24
f0101a19:	6a 58                	push   $0x58
f0101a1b:	68 02 6f 10 f0       	push   $0xf0106f02
f0101a20:	e8 1b e6 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(ALLOC_ZERO)));
f0101a25:	68 00 71 10 f0       	push   $0xf0107100
f0101a2a:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101a2f:	68 8c 03 00 00       	push   $0x38c
f0101a34:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101a39:	e8 02 e6 ff ff       	call   f0100040 <_panic>
    assert(pp && pp0 == pp);
f0101a3e:	68 1e 71 10 f0       	push   $0xf010711e
f0101a43:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101a48:	68 8d 03 00 00       	push   $0x38d
f0101a4d:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101a52:	e8 e9 e5 ff ff       	call   f0100040 <_panic>
f0101a57:	52                   	push   %edx
f0101a58:	68 24 5b 10 f0       	push   $0xf0105b24
f0101a5d:	6a 58                	push   $0x58
f0101a5f:	68 02 6f 10 f0       	push   $0xf0106f02
f0101a64:	e8 d7 e5 ff ff       	call   f0100040 <_panic>
        assert(c[i] == 0);
f0101a69:	68 2e 71 10 f0       	push   $0xf010712e
f0101a6e:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0101a73:	68 90 03 00 00       	push   $0x390
f0101a78:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0101a7d:	e8 be e5 ff ff       	call   f0100040 <_panic>
        --nfree;
f0101a82:	83 eb 01             	sub    $0x1,%ebx
    for (pp = page_free_list; pp; pp = pp->pp_link)
f0101a85:	8b 00                	mov    (%eax),%eax
f0101a87:	85 c0                	test   %eax,%eax
f0101a89:	75 f7                	jne    f0101a82 <mem_init+0x704>
    assert(nfree == 0);
f0101a8b:	85 db                	test   %ebx,%ebx
f0101a8d:	0f 85 6f 09 00 00    	jne    f0102402 <mem_init+0x1084>
    cprintf("check_page_alloc() succeeded!\n");
f0101a93:	83 ec 0c             	sub    $0xc,%esp
f0101a96:	68 8c 64 10 f0       	push   $0xf010648c
f0101a9b:	e8 90 20 00 00       	call   f0103b30 <cprintf>
    cprintf("\n************* Now check page_insert, page_remove, &c **************\n");
f0101aa0:	c7 04 24 ac 64 10 f0 	movl   $0xf01064ac,(%esp)
f0101aa7:	e8 84 20 00 00       	call   f0103b30 <cprintf>
    int i;
    extern pde_t entry_pgdir[];

    // should be able to allocate three pages
    pp0 = pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0101aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ab3:	e8 26 f5 ff ff       	call   f0100fde <page_alloc>
f0101ab8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101abb:	83 c4 10             	add    $0x10,%esp
f0101abe:	85 c0                	test   %eax,%eax
f0101ac0:	0f 84 55 09 00 00    	je     f010241b <mem_init+0x109d>
    assert((pp1 = page_alloc(0)));
f0101ac6:	83 ec 0c             	sub    $0xc,%esp
f0101ac9:	6a 00                	push   $0x0
f0101acb:	e8 0e f5 ff ff       	call   f0100fde <page_alloc>
f0101ad0:	89 c3                	mov    %eax,%ebx
f0101ad2:	83 c4 10             	add    $0x10,%esp
f0101ad5:	85 c0                	test   %eax,%eax
f0101ad7:	0f 84 57 09 00 00    	je     f0102434 <mem_init+0x10b6>
    assert((pp2 = page_alloc(0)));
f0101add:	83 ec 0c             	sub    $0xc,%esp
f0101ae0:	6a 00                	push   $0x0
f0101ae2:	e8 f7 f4 ff ff       	call   f0100fde <page_alloc>
f0101ae7:	89 c7                	mov    %eax,%edi
f0101ae9:	83 c4 10             	add    $0x10,%esp
f0101aec:	85 c0                	test   %eax,%eax
f0101aee:	0f 84 59 09 00 00    	je     f010244d <mem_init+0x10cf>

    assert(pp0);
    assert(pp1 && pp1 != pp0);
f0101af4:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101af7:	0f 84 69 09 00 00    	je     f0102466 <mem_init+0x10e8>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101afd:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101b00:	0f 84 79 09 00 00    	je     f010247f <mem_init+0x1101>
f0101b06:	39 c3                	cmp    %eax,%ebx
f0101b08:	0f 84 71 09 00 00    	je     f010247f <mem_init+0x1101>

    // temporarily steal the rest of the free pages
    fl = page_free_list;
f0101b0e:	a1 44 c2 22 f0       	mov    0xf022c244,%eax
f0101b13:	89 45 cc             	mov    %eax,-0x34(%ebp)
    page_free_list = 0;
f0101b16:	c7 05 44 c2 22 f0 00 	movl   $0x0,0xf022c244
f0101b1d:	00 00 00 

    // should be no free memory
    assert(!page_alloc(0));
f0101b20:	83 ec 0c             	sub    $0xc,%esp
f0101b23:	6a 00                	push   $0x0
f0101b25:	e8 b4 f4 ff ff       	call   f0100fde <page_alloc>
f0101b2a:	83 c4 10             	add    $0x10,%esp
f0101b2d:	85 c0                	test   %eax,%eax
f0101b2f:	0f 85 63 09 00 00    	jne    f0102498 <mem_init+0x111a>

    // there is no page allocated at address 0
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101b35:	83 ec 04             	sub    $0x4,%esp
f0101b38:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101b3b:	50                   	push   %eax
f0101b3c:	6a 00                	push   $0x0
f0101b3e:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101b44:	e8 6d f6 ff ff       	call   f01011b6 <page_lookup>
f0101b49:	83 c4 10             	add    $0x10,%esp
f0101b4c:	85 c0                	test   %eax,%eax
f0101b4e:	0f 85 5d 09 00 00    	jne    f01024b1 <mem_init+0x1133>

    // there is no free memory, so we can't allocate a page table
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101b54:	6a 02                	push   $0x2
f0101b56:	6a 00                	push   $0x0
f0101b58:	53                   	push   %ebx
f0101b59:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101b5f:	e8 ef f6 ff ff       	call   f0101253 <page_insert>
f0101b64:	83 c4 10             	add    $0x10,%esp
f0101b67:	85 c0                	test   %eax,%eax
f0101b69:	0f 89 5b 09 00 00    	jns    f01024ca <mem_init+0x114c>

    // free pp0 and try again: pp0 should be used for page table
    page_free(pp0);
f0101b6f:	83 ec 0c             	sub    $0xc,%esp
f0101b72:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b75:	e8 dc f4 ff ff       	call   f0101056 <page_free>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101b7a:	6a 02                	push   $0x2
f0101b7c:	6a 00                	push   $0x0
f0101b7e:	53                   	push   %ebx
f0101b7f:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101b85:	e8 c9 f6 ff ff       	call   f0101253 <page_insert>
f0101b8a:	83 c4 20             	add    $0x20,%esp
f0101b8d:	85 c0                	test   %eax,%eax
f0101b8f:	0f 85 4e 09 00 00    	jne    f01024e3 <mem_init+0x1165>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101b95:	8b 35 10 cf 22 f0    	mov    0xf022cf10,%esi
	return (pp - pages) << PGSHIFT;
f0101b9b:	8b 0d 14 cf 22 f0    	mov    0xf022cf14,%ecx
f0101ba1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101ba4:	8b 16                	mov    (%esi),%edx
f0101ba6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101bac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101baf:	29 c8                	sub    %ecx,%eax
f0101bb1:	c1 f8 03             	sar    $0x3,%eax
f0101bb4:	c1 e0 0c             	shl    $0xc,%eax
f0101bb7:	39 c2                	cmp    %eax,%edx
f0101bb9:	0f 85 3d 09 00 00    	jne    f01024fc <mem_init+0x117e>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101bbf:	ba 00 00 00 00       	mov    $0x0,%edx
f0101bc4:	89 f0                	mov    %esi,%eax
f0101bc6:	e8 e1 ee ff ff       	call   f0100aac <check_va2pa>
f0101bcb:	89 da                	mov    %ebx,%edx
f0101bcd:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101bd0:	c1 fa 03             	sar    $0x3,%edx
f0101bd3:	c1 e2 0c             	shl    $0xc,%edx
f0101bd6:	39 d0                	cmp    %edx,%eax
f0101bd8:	0f 85 37 09 00 00    	jne    f0102515 <mem_init+0x1197>
    assert(pp1->pp_ref == 1);
f0101bde:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101be3:	0f 85 45 09 00 00    	jne    f010252e <mem_init+0x11b0>
    assert(pp0->pp_ref == 1);
f0101be9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101bec:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101bf1:	0f 85 50 09 00 00    	jne    f0102547 <mem_init+0x11c9>

    // should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101bf7:	6a 02                	push   $0x2
f0101bf9:	68 00 10 00 00       	push   $0x1000
f0101bfe:	57                   	push   %edi
f0101bff:	56                   	push   %esi
f0101c00:	e8 4e f6 ff ff       	call   f0101253 <page_insert>
f0101c05:	83 c4 10             	add    $0x10,%esp
f0101c08:	85 c0                	test   %eax,%eax
f0101c0a:	0f 85 50 09 00 00    	jne    f0102560 <mem_init+0x11e2>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c10:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c15:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f0101c1a:	e8 8d ee ff ff       	call   f0100aac <check_va2pa>
f0101c1f:	89 fa                	mov    %edi,%edx
f0101c21:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f0101c27:	c1 fa 03             	sar    $0x3,%edx
f0101c2a:	c1 e2 0c             	shl    $0xc,%edx
f0101c2d:	39 d0                	cmp    %edx,%eax
f0101c2f:	0f 85 44 09 00 00    	jne    f0102579 <mem_init+0x11fb>
    assert(pp2->pp_ref == 1);
f0101c35:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101c3a:	0f 85 52 09 00 00    	jne    f0102592 <mem_init+0x1214>

    // should be no free memory
    assert(!page_alloc(0));
f0101c40:	83 ec 0c             	sub    $0xc,%esp
f0101c43:	6a 00                	push   $0x0
f0101c45:	e8 94 f3 ff ff       	call   f0100fde <page_alloc>
f0101c4a:	83 c4 10             	add    $0x10,%esp
f0101c4d:	85 c0                	test   %eax,%eax
f0101c4f:	0f 85 56 09 00 00    	jne    f01025ab <mem_init+0x122d>

    // should be able to map pp2 at PGSIZE because it's already there
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101c55:	6a 02                	push   $0x2
f0101c57:	68 00 10 00 00       	push   $0x1000
f0101c5c:	57                   	push   %edi
f0101c5d:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101c63:	e8 eb f5 ff ff       	call   f0101253 <page_insert>
f0101c68:	83 c4 10             	add    $0x10,%esp
f0101c6b:	85 c0                	test   %eax,%eax
f0101c6d:	0f 85 51 09 00 00    	jne    f01025c4 <mem_init+0x1246>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c73:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c78:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f0101c7d:	e8 2a ee ff ff       	call   f0100aac <check_va2pa>
f0101c82:	89 fa                	mov    %edi,%edx
f0101c84:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f0101c8a:	c1 fa 03             	sar    $0x3,%edx
f0101c8d:	c1 e2 0c             	shl    $0xc,%edx
f0101c90:	39 d0                	cmp    %edx,%eax
f0101c92:	0f 85 45 09 00 00    	jne    f01025dd <mem_init+0x125f>
    assert(pp2->pp_ref == 1);
f0101c98:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101c9d:	0f 85 53 09 00 00    	jne    f01025f6 <mem_init+0x1278>

    // pp2 should NOT be on the free list
    // could happen in ref counts are handled sloppily in page_insert
    assert(!page_alloc(0));
f0101ca3:	83 ec 0c             	sub    $0xc,%esp
f0101ca6:	6a 00                	push   $0x0
f0101ca8:	e8 31 f3 ff ff       	call   f0100fde <page_alloc>
f0101cad:	83 c4 10             	add    $0x10,%esp
f0101cb0:	85 c0                	test   %eax,%eax
f0101cb2:	0f 85 57 09 00 00    	jne    f010260f <mem_init+0x1291>

    // check that pgdir_walk returns a pointer to the pte
    ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101cb8:	8b 15 10 cf 22 f0    	mov    0xf022cf10,%edx
f0101cbe:	8b 02                	mov    (%edx),%eax
f0101cc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101cc5:	89 c1                	mov    %eax,%ecx
f0101cc7:	c1 e9 0c             	shr    $0xc,%ecx
f0101cca:	3b 0d 0c cf 22 f0    	cmp    0xf022cf0c,%ecx
f0101cd0:	0f 83 52 09 00 00    	jae    f0102628 <mem_init+0x12aa>
	return (void *)(pa + KERNBASE);
f0101cd6:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101cdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0101cde:	83 ec 04             	sub    $0x4,%esp
f0101ce1:	6a 00                	push   $0x0
f0101ce3:	68 00 10 00 00       	push   $0x1000
f0101ce8:	52                   	push   %edx
f0101ce9:	e8 e7 f3 ff ff       	call   f01010d5 <pgdir_walk>
f0101cee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101cf1:	8d 51 04             	lea    0x4(%ecx),%edx
f0101cf4:	83 c4 10             	add    $0x10,%esp
f0101cf7:	39 d0                	cmp    %edx,%eax
f0101cf9:	0f 85 3e 09 00 00    	jne    f010263d <mem_init+0x12bf>

    // should be able to change permissions too.
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0101cff:	6a 06                	push   $0x6
f0101d01:	68 00 10 00 00       	push   $0x1000
f0101d06:	57                   	push   %edi
f0101d07:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101d0d:	e8 41 f5 ff ff       	call   f0101253 <page_insert>
f0101d12:	83 c4 10             	add    $0x10,%esp
f0101d15:	85 c0                	test   %eax,%eax
f0101d17:	0f 85 39 09 00 00    	jne    f0102656 <mem_init+0x12d8>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101d1d:	8b 35 10 cf 22 f0    	mov    0xf022cf10,%esi
f0101d23:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d28:	89 f0                	mov    %esi,%eax
f0101d2a:	e8 7d ed ff ff       	call   f0100aac <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101d2f:	89 fa                	mov    %edi,%edx
f0101d31:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f0101d37:	c1 fa 03             	sar    $0x3,%edx
f0101d3a:	c1 e2 0c             	shl    $0xc,%edx
f0101d3d:	39 d0                	cmp    %edx,%eax
f0101d3f:	0f 85 2a 09 00 00    	jne    f010266f <mem_init+0x12f1>
    assert(pp2->pp_ref == 1);
f0101d45:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101d4a:	0f 85 38 09 00 00    	jne    f0102688 <mem_init+0x130a>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f0101d50:	83 ec 04             	sub    $0x4,%esp
f0101d53:	6a 00                	push   $0x0
f0101d55:	68 00 10 00 00       	push   $0x1000
f0101d5a:	56                   	push   %esi
f0101d5b:	e8 75 f3 ff ff       	call   f01010d5 <pgdir_walk>
f0101d60:	83 c4 10             	add    $0x10,%esp
f0101d63:	f6 00 04             	testb  $0x4,(%eax)
f0101d66:	0f 84 35 09 00 00    	je     f01026a1 <mem_init+0x1323>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f0101d6c:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f0101d71:	f6 00 04             	testb  $0x4,(%eax)
f0101d74:	0f 84 40 09 00 00    	je     f01026ba <mem_init+0x133c>

    // should be able to remap with fewer permissions
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101d7a:	6a 02                	push   $0x2
f0101d7c:	68 00 10 00 00       	push   $0x1000
f0101d81:	57                   	push   %edi
f0101d82:	50                   	push   %eax
f0101d83:	e8 cb f4 ff ff       	call   f0101253 <page_insert>
f0101d88:	83 c4 10             	add    $0x10,%esp
f0101d8b:	85 c0                	test   %eax,%eax
f0101d8d:	0f 85 40 09 00 00    	jne    f01026d3 <mem_init+0x1355>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0101d93:	83 ec 04             	sub    $0x4,%esp
f0101d96:	6a 00                	push   $0x0
f0101d98:	68 00 10 00 00       	push   $0x1000
f0101d9d:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101da3:	e8 2d f3 ff ff       	call   f01010d5 <pgdir_walk>
f0101da8:	83 c4 10             	add    $0x10,%esp
f0101dab:	f6 00 02             	testb  $0x2,(%eax)
f0101dae:	0f 84 38 09 00 00    	je     f01026ec <mem_init+0x136e>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0101db4:	83 ec 04             	sub    $0x4,%esp
f0101db7:	6a 00                	push   $0x0
f0101db9:	68 00 10 00 00       	push   $0x1000
f0101dbe:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101dc4:	e8 0c f3 ff ff       	call   f01010d5 <pgdir_walk>
f0101dc9:	83 c4 10             	add    $0x10,%esp
f0101dcc:	f6 00 04             	testb  $0x4,(%eax)
f0101dcf:	0f 85 30 09 00 00    	jne    f0102705 <mem_init+0x1387>

    // should not be able to map at PTSIZE because need free page for page table
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0101dd5:	6a 02                	push   $0x2
f0101dd7:	68 00 00 40 00       	push   $0x400000
f0101ddc:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ddf:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101de5:	e8 69 f4 ff ff       	call   f0101253 <page_insert>
f0101dea:	83 c4 10             	add    $0x10,%esp
f0101ded:	85 c0                	test   %eax,%eax
f0101def:	0f 89 29 09 00 00    	jns    f010271e <mem_init+0x13a0>

    // insert pp1 at PGSIZE (replacing pp2)
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0101df5:	6a 02                	push   $0x2
f0101df7:	68 00 10 00 00       	push   $0x1000
f0101dfc:	53                   	push   %ebx
f0101dfd:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101e03:	e8 4b f4 ff ff       	call   f0101253 <page_insert>
f0101e08:	83 c4 10             	add    $0x10,%esp
f0101e0b:	85 c0                	test   %eax,%eax
f0101e0d:	0f 85 24 09 00 00    	jne    f0102737 <mem_init+0x13b9>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0101e13:	83 ec 04             	sub    $0x4,%esp
f0101e16:	6a 00                	push   $0x0
f0101e18:	68 00 10 00 00       	push   $0x1000
f0101e1d:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101e23:	e8 ad f2 ff ff       	call   f01010d5 <pgdir_walk>
f0101e28:	83 c4 10             	add    $0x10,%esp
f0101e2b:	f6 00 04             	testb  $0x4,(%eax)
f0101e2e:	0f 85 1c 09 00 00    	jne    f0102750 <mem_init+0x13d2>

    // should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101e34:	8b 35 10 cf 22 f0    	mov    0xf022cf10,%esi
f0101e3a:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e3f:	89 f0                	mov    %esi,%eax
f0101e41:	e8 66 ec ff ff       	call   f0100aac <check_va2pa>
f0101e46:	89 c1                	mov    %eax,%ecx
f0101e48:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e4b:	89 d8                	mov    %ebx,%eax
f0101e4d:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0101e53:	c1 f8 03             	sar    $0x3,%eax
f0101e56:	c1 e0 0c             	shl    $0xc,%eax
f0101e59:	39 c1                	cmp    %eax,%ecx
f0101e5b:	0f 85 08 09 00 00    	jne    f0102769 <mem_init+0x13eb>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101e61:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e66:	89 f0                	mov    %esi,%eax
f0101e68:	e8 3f ec ff ff       	call   f0100aac <check_va2pa>
f0101e6d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101e70:	0f 85 0c 09 00 00    	jne    f0102782 <mem_init+0x1404>
    // ... and ref counts should reflect this
    assert(pp1->pp_ref == 2);
f0101e76:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101e7b:	0f 85 1a 09 00 00    	jne    f010279b <mem_init+0x141d>
    assert(pp2->pp_ref == 0);
f0101e81:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e86:	0f 85 28 09 00 00    	jne    f01027b4 <mem_init+0x1436>

    // pp2 should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp2);
f0101e8c:	83 ec 0c             	sub    $0xc,%esp
f0101e8f:	6a 00                	push   $0x0
f0101e91:	e8 48 f1 ff ff       	call   f0100fde <page_alloc>
f0101e96:	83 c4 10             	add    $0x10,%esp
f0101e99:	39 c7                	cmp    %eax,%edi
f0101e9b:	0f 85 2c 09 00 00    	jne    f01027cd <mem_init+0x144f>
f0101ea1:	85 c0                	test   %eax,%eax
f0101ea3:	0f 84 24 09 00 00    	je     f01027cd <mem_init+0x144f>

    // unmapping pp1 at 0 should keep pp1 at PGSIZE
    page_remove(kern_pgdir, 0x0);
f0101ea9:	83 ec 08             	sub    $0x8,%esp
f0101eac:	6a 00                	push   $0x0
f0101eae:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101eb4:	e8 57 f3 ff ff       	call   f0101210 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101eb9:	8b 35 10 cf 22 f0    	mov    0xf022cf10,%esi
f0101ebf:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ec4:	89 f0                	mov    %esi,%eax
f0101ec6:	e8 e1 eb ff ff       	call   f0100aac <check_va2pa>
f0101ecb:	83 c4 10             	add    $0x10,%esp
f0101ece:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ed1:	0f 85 0f 09 00 00    	jne    f01027e6 <mem_init+0x1468>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101ed7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101edc:	89 f0                	mov    %esi,%eax
f0101ede:	e8 c9 eb ff ff       	call   f0100aac <check_va2pa>
f0101ee3:	89 da                	mov    %ebx,%edx
f0101ee5:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f0101eeb:	c1 fa 03             	sar    $0x3,%edx
f0101eee:	c1 e2 0c             	shl    $0xc,%edx
f0101ef1:	39 d0                	cmp    %edx,%eax
f0101ef3:	0f 85 06 09 00 00    	jne    f01027ff <mem_init+0x1481>
    assert(pp1->pp_ref == 1);
f0101ef9:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101efe:	0f 85 14 09 00 00    	jne    f0102818 <mem_init+0x149a>
    assert(pp2->pp_ref == 0);
f0101f04:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101f09:	0f 85 22 09 00 00    	jne    f0102831 <mem_init+0x14b3>

    // test re-inserting pp1 at PGSIZE
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0101f0f:	6a 00                	push   $0x0
f0101f11:	68 00 10 00 00       	push   $0x1000
f0101f16:	53                   	push   %ebx
f0101f17:	56                   	push   %esi
f0101f18:	e8 36 f3 ff ff       	call   f0101253 <page_insert>
f0101f1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f20:	83 c4 10             	add    $0x10,%esp
f0101f23:	85 c0                	test   %eax,%eax
f0101f25:	0f 85 1f 09 00 00    	jne    f010284a <mem_init+0x14cc>
    assert(pp1->pp_ref);
f0101f2b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101f30:	0f 84 2d 09 00 00    	je     f0102863 <mem_init+0x14e5>
    assert(pp1->pp_link == NULL);
f0101f36:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101f39:	0f 85 3d 09 00 00    	jne    f010287c <mem_init+0x14fe>

    // unmapping pp1 at PGSIZE should free it
    page_remove(kern_pgdir, (void *) PGSIZE);
f0101f3f:	83 ec 08             	sub    $0x8,%esp
f0101f42:	68 00 10 00 00       	push   $0x1000
f0101f47:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0101f4d:	e8 be f2 ff ff       	call   f0101210 <page_remove>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101f52:	8b 35 10 cf 22 f0    	mov    0xf022cf10,%esi
f0101f58:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f5d:	89 f0                	mov    %esi,%eax
f0101f5f:	e8 48 eb ff ff       	call   f0100aac <check_va2pa>
f0101f64:	83 c4 10             	add    $0x10,%esp
f0101f67:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f6a:	0f 85 25 09 00 00    	jne    f0102895 <mem_init+0x1517>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101f70:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f75:	89 f0                	mov    %esi,%eax
f0101f77:	e8 30 eb ff ff       	call   f0100aac <check_va2pa>
f0101f7c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f7f:	0f 85 29 09 00 00    	jne    f01028ae <mem_init+0x1530>
    assert(pp1->pp_ref == 0);
f0101f85:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101f8a:	0f 85 37 09 00 00    	jne    f01028c7 <mem_init+0x1549>
    assert(pp2->pp_ref == 0);
f0101f90:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101f95:	0f 85 45 09 00 00    	jne    f01028e0 <mem_init+0x1562>

    // so it should be returned by page_alloc
    assert((pp = page_alloc(0)) && pp == pp1);
f0101f9b:	83 ec 0c             	sub    $0xc,%esp
f0101f9e:	6a 00                	push   $0x0
f0101fa0:	e8 39 f0 ff ff       	call   f0100fde <page_alloc>
f0101fa5:	83 c4 10             	add    $0x10,%esp
f0101fa8:	85 c0                	test   %eax,%eax
f0101faa:	0f 84 49 09 00 00    	je     f01028f9 <mem_init+0x157b>
f0101fb0:	39 c3                	cmp    %eax,%ebx
f0101fb2:	0f 85 41 09 00 00    	jne    f01028f9 <mem_init+0x157b>

    // should be no free memory
    assert(!page_alloc(0));
f0101fb8:	83 ec 0c             	sub    $0xc,%esp
f0101fbb:	6a 00                	push   $0x0
f0101fbd:	e8 1c f0 ff ff       	call   f0100fde <page_alloc>
f0101fc2:	83 c4 10             	add    $0x10,%esp
f0101fc5:	85 c0                	test   %eax,%eax
f0101fc7:	0f 85 45 09 00 00    	jne    f0102912 <mem_init+0x1594>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101fcd:	8b 0d 10 cf 22 f0    	mov    0xf022cf10,%ecx
f0101fd3:	8b 11                	mov    (%ecx),%edx
f0101fd5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101fdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fde:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0101fe4:	c1 f8 03             	sar    $0x3,%eax
f0101fe7:	c1 e0 0c             	shl    $0xc,%eax
f0101fea:	39 c2                	cmp    %eax,%edx
f0101fec:	0f 85 39 09 00 00    	jne    f010292b <mem_init+0x15ad>
    kern_pgdir[0] = 0;
f0101ff2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f0101ff8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ffb:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102000:	0f 85 3e 09 00 00    	jne    f0102944 <mem_init+0x15c6>
    pp0->pp_ref = 0;
f0102006:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102009:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // check pointer arithmetic in pgdir_walk
    page_free(pp0);
f010200f:	83 ec 0c             	sub    $0xc,%esp
f0102012:	50                   	push   %eax
f0102013:	e8 3e f0 ff ff       	call   f0101056 <page_free>
    va = (void *) (PGSIZE * NPDENTRIES + PGSIZE);
    ptep = pgdir_walk(kern_pgdir, va, 1);
f0102018:	83 c4 0c             	add    $0xc,%esp
f010201b:	6a 01                	push   $0x1
f010201d:	68 00 10 40 00       	push   $0x401000
f0102022:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0102028:	e8 a8 f0 ff ff       	call   f01010d5 <pgdir_walk>
f010202d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102030:	8b 15 10 cf 22 f0    	mov    0xf022cf10,%edx
f0102036:	8b 52 04             	mov    0x4(%edx),%edx
f0102039:	89 d6                	mov    %edx,%esi
f010203b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0102041:	89 f1                	mov    %esi,%ecx
f0102043:	c1 e9 0c             	shr    $0xc,%ecx
f0102046:	83 c4 10             	add    $0x10,%esp
f0102049:	3b 0d 0c cf 22 f0    	cmp    0xf022cf0c,%ecx
f010204f:	0f 83 08 09 00 00    	jae    f010295d <mem_init+0x15df>
	return (void *)(pa + KERNBASE);
f0102055:	8d 8e 00 00 00 f0    	lea    -0x10000000(%esi),%ecx

    cprintf("PTE_ADDR(kern_pgdir[PDX(va)]):0x%x\tkern_pgdir[PDX(va)]:0x%x\tptep:0x%x\tptep1:0x%x\tPTX(va):0x%x\n",
f010205b:	83 ec 08             	sub    $0x8,%esp
f010205e:	6a 01                	push   $0x1
f0102060:	51                   	push   %ecx
f0102061:	50                   	push   %eax
f0102062:	52                   	push   %edx
f0102063:	56                   	push   %esi
f0102064:	68 18 69 10 f0       	push   $0xf0106918
f0102069:	e8 c2 1a 00 00       	call   f0103b30 <cprintf>
            PTE_ADDR(kern_pgdir[PDX(va)]), kern_pgdir[PDX(va)], ptep, ptep1,
            PTX(va));
    assert(ptep == ptep1 + PTX(va));
f010206e:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f0102074:	83 c4 20             	add    $0x20,%esp
f0102077:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f010207a:	0f 85 f2 08 00 00    	jne    f0102972 <mem_init+0x15f4>
    kern_pgdir[PDX(va)] = 0;
f0102080:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f0102085:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    pp0->pp_ref = 0;
f010208c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010208f:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102095:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f010209b:	c1 f8 03             	sar    $0x3,%eax
f010209e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01020a1:	89 c2                	mov    %eax,%edx
f01020a3:	c1 ea 0c             	shr    $0xc,%edx
f01020a6:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f01020ac:	0f 83 d9 08 00 00    	jae    f010298b <mem_init+0x160d>

    // check that new page tables get cleared
    memset(page2kva(pp0), 0xFF, PGSIZE);
f01020b2:	83 ec 04             	sub    $0x4,%esp
f01020b5:	68 00 10 00 00       	push   $0x1000
f01020ba:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01020bf:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01020c4:	50                   	push   %eax
f01020c5:	e8 d0 2d 00 00       	call   f0104e9a <memset>
    page_free(pp0);
f01020ca:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01020cd:	89 34 24             	mov    %esi,(%esp)
f01020d0:	e8 81 ef ff ff       	call   f0101056 <page_free>
    pgdir_walk(kern_pgdir, 0x0, 1);
f01020d5:	83 c4 0c             	add    $0xc,%esp
f01020d8:	6a 01                	push   $0x1
f01020da:	6a 00                	push   $0x0
f01020dc:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f01020e2:	e8 ee ef ff ff       	call   f01010d5 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01020e7:	89 f2                	mov    %esi,%edx
f01020e9:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f01020ef:	c1 fa 03             	sar    $0x3,%edx
f01020f2:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01020f5:	89 d0                	mov    %edx,%eax
f01020f7:	c1 e8 0c             	shr    $0xc,%eax
f01020fa:	83 c4 10             	add    $0x10,%esp
f01020fd:	3b 05 0c cf 22 f0    	cmp    0xf022cf0c,%eax
f0102103:	0f 83 94 08 00 00    	jae    f010299d <mem_init+0x161f>
	return (void *)(pa + KERNBASE);
f0102109:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
    ptep = (pte_t *) page2kva(pp0);
f010210f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102112:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
    for (i = 0; i < NPTENTRIES; i++)
        assert((ptep[i] & PTE_P) == 0);
f0102118:	f6 00 01             	testb  $0x1,(%eax)
f010211b:	0f 85 8e 08 00 00    	jne    f01029af <mem_init+0x1631>
f0102121:	83 c0 04             	add    $0x4,%eax
    for (i = 0; i < NPTENTRIES; i++)
f0102124:	39 d0                	cmp    %edx,%eax
f0102126:	75 f0                	jne    f0102118 <mem_init+0xd9a>
    kern_pgdir[0] = 0;
f0102128:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f010212d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    pp0->pp_ref = 0;
f0102133:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102136:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

    // give free list back
    page_free_list = fl;
f010213c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010213f:	89 0d 44 c2 22 f0    	mov    %ecx,0xf022c244

    // free the pages we took
    page_free(pp0);
f0102145:	83 ec 0c             	sub    $0xc,%esp
f0102148:	50                   	push   %eax
f0102149:	e8 08 ef ff ff       	call   f0101056 <page_free>
    page_free(pp1);
f010214e:	89 1c 24             	mov    %ebx,(%esp)
f0102151:	e8 00 ef ff ff       	call   f0101056 <page_free>
    page_free(pp2);
f0102156:	89 3c 24             	mov    %edi,(%esp)
f0102159:	e8 f8 ee ff ff       	call   f0101056 <page_free>

    cprintf("check_page() succeeded!\n");
f010215e:	c7 04 24 0f 72 10 f0 	movl   $0xf010720f,(%esp)
f0102165:	e8 c6 19 00 00       	call   f0103b30 <cprintf>
    cprintf("\n************* Now we set up virtual memory **************\n");
f010216a:	c7 04 24 78 69 10 f0 	movl   $0xf0106978,(%esp)
f0102171:	e8 ba 19 00 00       	call   f0103b30 <cprintf>
    memCprintf("UVPT", UVPT, PDX(UVPT), PADDR(kern_pgdir), PADDR(kern_pgdir) >> 12);
f0102176:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f010217b:	83 c4 10             	add    $0x10,%esp
f010217e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102183:	0f 86 3f 08 00 00    	jbe    f01029c8 <mem_init+0x164a>
	return (physaddr_t)kva - KERNBASE;
f0102189:	05 00 00 00 10       	add    $0x10000000,%eax
f010218e:	83 ec 0c             	sub    $0xc,%esp
f0102191:	89 c2                	mov    %eax,%edx
f0102193:	c1 ea 0c             	shr    $0xc,%edx
f0102196:	52                   	push   %edx
f0102197:	50                   	push   %eax
f0102198:	68 bd 03 00 00       	push   $0x3bd
f010219d:	68 00 00 40 ef       	push   $0xef400000
f01021a2:	68 2f 70 10 f0       	push   $0xf010702f
f01021a7:	e8 98 19 00 00       	call   f0103b44 <memCprintf>
    memCprintf("pages", (uintptr_t) pages, PDX(pages), PADDR(pages), PADDR(pages) >> 12);
f01021ac:	a1 14 cf 22 f0       	mov    0xf022cf14,%eax
	if ((uint32_t)kva < KERNBASE)
f01021b1:	83 c4 20             	add    $0x20,%esp
f01021b4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021b9:	0f 86 1e 08 00 00    	jbe    f01029dd <mem_init+0x165f>
	return (physaddr_t)kva - KERNBASE;
f01021bf:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01021c5:	83 ec 0c             	sub    $0xc,%esp
f01021c8:	89 d1                	mov    %edx,%ecx
f01021ca:	c1 e9 0c             	shr    $0xc,%ecx
f01021cd:	51                   	push   %ecx
f01021ce:	52                   	push   %edx
f01021cf:	89 c2                	mov    %eax,%edx
f01021d1:	c1 ea 16             	shr    $0x16,%edx
f01021d4:	52                   	push   %edx
f01021d5:	50                   	push   %eax
f01021d6:	68 2c 6f 10 f0       	push   $0xf0106f2c
f01021db:	e8 64 19 00 00       	call   f0103b44 <memCprintf>
    memCprintf("envs", (uintptr_t) envs, PDX(envs), PADDR(envs), PADDR(envs) >> 12);
f01021e0:	a1 4c c2 22 f0       	mov    0xf022c24c,%eax
	if ((uint32_t)kva < KERNBASE)
f01021e5:	83 c4 20             	add    $0x20,%esp
f01021e8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021ed:	0f 86 ff 07 00 00    	jbe    f01029f2 <mem_init+0x1674>
	return (physaddr_t)kva - KERNBASE;
f01021f3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01021f9:	83 ec 0c             	sub    $0xc,%esp
f01021fc:	89 d1                	mov    %edx,%ecx
f01021fe:	c1 e9 0c             	shr    $0xc,%ecx
f0102201:	51                   	push   %ecx
f0102202:	52                   	push   %edx
f0102203:	89 c2                	mov    %eax,%edx
f0102205:	c1 ea 16             	shr    $0x16,%edx
f0102208:	52                   	push   %edx
f0102209:	50                   	push   %eax
f010220a:	68 7d 70 10 f0       	push   $0xf010707d
f010220f:	e8 30 19 00 00       	call   f0103b44 <memCprintf>
    cprintf("\n************* Now we map 'pages' read-only by the user at linear address UPAGES **************\n");
f0102214:	83 c4 14             	add    $0x14,%esp
f0102217:	68 b4 69 10 f0       	push   $0xf01069b4
f010221c:	e8 0f 19 00 00       	call   f0103b30 <cprintf>
    cprintf("page2pa(pages):0x%x\n", page2pa(pages));
f0102221:	83 c4 08             	add    $0x8,%esp
f0102224:	6a 00                	push   $0x0
f0102226:	68 28 72 10 f0       	push   $0xf0107228
f010222b:	e8 00 19 00 00       	call   f0103b30 <cprintf>
    boot_map_region(kern_pgdir, UPAGES, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE), PADDR(pages), PTE_U | PTE_P);
f0102230:	a1 14 cf 22 f0       	mov    0xf022cf14,%eax
	if ((uint32_t)kva < KERNBASE)
f0102235:	83 c4 10             	add    $0x10,%esp
f0102238:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010223d:	0f 86 c4 07 00 00    	jbe    f0102a07 <mem_init+0x1689>
f0102243:	8b 15 0c cf 22 f0    	mov    0xf022cf0c,%edx
f0102249:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0102250:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102256:	83 ec 08             	sub    $0x8,%esp
f0102259:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f010225b:	05 00 00 00 10       	add    $0x10000000,%eax
f0102260:	50                   	push   %eax
f0102261:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102266:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f010226b:	e8 f7 ee ff ff       	call   f0101167 <boot_map_region>
    cprintf("\n************* Now we map 'envs' read-only by the user at linear address UENVS **************\n");
f0102270:	c7 04 24 18 6a 10 f0 	movl   $0xf0106a18,(%esp)
f0102277:	e8 b4 18 00 00       	call   f0103b30 <cprintf>
    boot_map_region(kern_pgdir, UENVS, ROUNDUP(NENV * sizeof(struct Env), PGSIZE), PADDR(envs), PTE_U | PTE_P);
f010227c:	a1 4c c2 22 f0       	mov    0xf022c24c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102281:	83 c4 10             	add    $0x10,%esp
f0102284:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102289:	0f 86 8d 07 00 00    	jbe    f0102a1c <mem_init+0x169e>
f010228f:	83 ec 08             	sub    $0x8,%esp
f0102292:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102294:	05 00 00 00 10       	add    $0x10000000,%eax
f0102299:	50                   	push   %eax
f010229a:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f010229f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01022a4:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f01022a9:	e8 b9 ee ff ff       	call   f0101167 <boot_map_region>
    cprintf("\n************* Now use the physical memory that 'bootstack' refers to as the kernel stack **************\n");
f01022ae:	c7 04 24 78 6a 10 f0 	movl   $0xf0106a78,(%esp)
f01022b5:	e8 76 18 00 00       	call   f0103b30 <cprintf>
	if ((uint32_t)kva < KERNBASE)
f01022ba:	83 c4 10             	add    $0x10,%esp
f01022bd:	b8 00 70 11 f0       	mov    $0xf0117000,%eax
f01022c2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01022c7:	0f 86 64 07 00 00    	jbe    f0102a31 <mem_init+0x16b3>
    boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_P | PTE_W);
f01022cd:	83 ec 08             	sub    $0x8,%esp
f01022d0:	6a 03                	push   $0x3
f01022d2:	68 00 70 11 00       	push   $0x117000
f01022d7:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01022dc:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01022e1:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f01022e6:	e8 7c ee ff ff       	call   f0101167 <boot_map_region>
    cprintf("\n************* Now map all of physical memory at KERNBASE. **************\n");
f01022eb:	c7 04 24 e4 6a 10 f0 	movl   $0xf0106ae4,(%esp)
f01022f2:	e8 39 18 00 00       	call   f0103b30 <cprintf>
    boot_map_region(kern_pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE + 1, 0, PTE_W | PTE_P);//这权限有必要？？
f01022f7:	83 c4 08             	add    $0x8,%esp
f01022fa:	6a 03                	push   $0x3
f01022fc:	6a 00                	push   $0x0
f01022fe:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102303:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102308:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f010230d:	e8 55 ee ff ff       	call   f0101167 <boot_map_region>
    cprintf("Map per-CPU stacks starting at KSTACKTOP, for up to 'NCPU' CPUs.\n");
f0102312:	c7 04 24 30 6b 10 f0 	movl   $0xf0106b30,(%esp)
f0102319:	e8 12 18 00 00       	call   f0103b30 <cprintf>
f010231e:	c7 45 cc 00 e0 22 f0 	movl   $0xf022e000,-0x34(%ebp)
f0102325:	83 c4 10             	add    $0x10,%esp
f0102328:	be 00 e0 22 f0       	mov    $0xf022e000,%esi
f010232d:	8b 7d d0             	mov    -0x30(%ebp),%edi
f0102330:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f0102336:	0f 86 0a 07 00 00    	jbe    f0102a46 <mem_init+0x16c8>
f010233c:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0102342:	89 fb                	mov    %edi,%ebx
f0102344:	f7 db                	neg    %ebx
f0102346:	c1 e3 10             	shl    $0x10,%ebx
f0102349:	81 eb 00 80 00 10    	sub    $0x10008000,%ebx
        cprintf("cpu%d stack start at:0x%x(vaddr)\t0x%x(paddr)\n", i, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f010234f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102352:	50                   	push   %eax
f0102353:	53                   	push   %ebx
f0102354:	57                   	push   %edi
f0102355:	68 74 6b 10 f0       	push   $0xf0106b74
f010235a:	e8 d1 17 00 00       	call   f0103b30 <cprintf>
        boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE, KSTKSIZE, PADDR(percpu_kstacks[i]),
f010235f:	83 c4 08             	add    $0x8,%esp
f0102362:	6a 02                	push   $0x2
f0102364:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102367:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010236c:	89 da                	mov    %ebx,%edx
f010236e:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f0102373:	e8 ef ed ff ff       	call   f0101167 <boot_map_region>
    for (int i = 0; i < NCPU; i++) {
f0102378:	83 c7 01             	add    $0x1,%edi
f010237b:	81 c6 00 80 00 00    	add    $0x8000,%esi
f0102381:	83 c4 10             	add    $0x10,%esp
f0102384:	83 ff 08             	cmp    $0x8,%edi
f0102387:	75 a7                	jne    f0102330 <mem_init+0xfb2>
    cprintf("\n************* Now check that the initial page directory has been set up correctly **************\n");
f0102389:	83 ec 0c             	sub    $0xc,%esp
f010238c:	68 a4 6b 10 f0       	push   $0xf0106ba4
f0102391:	e8 9a 17 00 00       	call   f0103b30 <cprintf>
    pgdir = kern_pgdir;
f0102396:	8b 3d 10 cf 22 f0    	mov    0xf022cf10,%edi
    n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f010239c:	a1 0c cf 22 f0       	mov    0xf022cf0c,%eax
f01023a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01023a4:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01023ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01023b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01023b3:	a1 14 cf 22 f0       	mov    0xf022cf14,%eax
f01023b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01023bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01023be:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
f01023c4:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < n; i += PGSIZE)
f01023c7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01023cc:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01023cf:	0f 86 b6 06 00 00    	jbe    f0102a8b <mem_init+0x170d>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01023d5:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01023db:	89 f8                	mov    %edi,%eax
f01023dd:	e8 ca e6 ff ff       	call   f0100aac <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01023e2:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f01023e9:	0f 86 6c 06 00 00    	jbe    f0102a5b <mem_init+0x16dd>
f01023ef:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f01023f2:	39 d0                	cmp    %edx,%eax
f01023f4:	0f 85 78 06 00 00    	jne    f0102a72 <mem_init+0x16f4>
    for (i = 0; i < n; i += PGSIZE)
f01023fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102400:	eb ca                	jmp    f01023cc <mem_init+0x104e>
    assert(nfree == 0);
f0102402:	68 38 71 10 f0       	push   $0xf0107138
f0102407:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010240c:	68 9d 03 00 00       	push   $0x39d
f0102411:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102416:	e8 25 dc ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f010241b:	68 9d 70 10 f0       	push   $0xf010709d
f0102420:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102425:	68 00 04 00 00       	push   $0x400
f010242a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010242f:	e8 0c dc ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0102434:	68 b3 70 10 f0       	push   $0xf01070b3
f0102439:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010243e:	68 01 04 00 00       	push   $0x401
f0102443:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102448:	e8 f3 db ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f010244d:	68 c9 70 10 f0       	push   $0xf01070c9
f0102452:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102457:	68 02 04 00 00       	push   $0x402
f010245c:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102461:	e8 da db ff ff       	call   f0100040 <_panic>
    assert(pp1 && pp1 != pp0);
f0102466:	68 df 70 10 f0       	push   $0xf01070df
f010246b:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102470:	68 05 04 00 00       	push   $0x405
f0102475:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010247a:	e8 c1 db ff ff       	call   f0100040 <_panic>
    assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010247f:	68 0c 64 10 f0       	push   $0xf010640c
f0102484:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102489:	68 06 04 00 00       	push   $0x406
f010248e:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102493:	e8 a8 db ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0102498:	68 f1 70 10 f0       	push   $0xf01070f1
f010249d:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01024a2:	68 0d 04 00 00       	push   $0x40d
f01024a7:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01024ac:	e8 8f db ff ff       	call   f0100040 <_panic>
    assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01024b1:	68 f4 64 10 f0       	push   $0xf01064f4
f01024b6:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01024bb:	68 10 04 00 00       	push   $0x410
f01024c0:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01024c5:	e8 76 db ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01024ca:	68 2c 65 10 f0       	push   $0xf010652c
f01024cf:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01024d4:	68 13 04 00 00       	push   $0x413
f01024d9:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01024de:	e8 5d db ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01024e3:	68 5c 65 10 f0       	push   $0xf010655c
f01024e8:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01024ed:	68 17 04 00 00       	push   $0x417
f01024f2:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01024f7:	e8 44 db ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01024fc:	68 8c 65 10 f0       	push   $0xf010658c
f0102501:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102506:	68 18 04 00 00       	push   $0x418
f010250b:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102510:	e8 2b db ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102515:	68 b4 65 10 f0       	push   $0xf01065b4
f010251a:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010251f:	68 19 04 00 00       	push   $0x419
f0102524:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102529:	e8 12 db ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f010252e:	68 43 71 10 f0       	push   $0xf0107143
f0102533:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102538:	68 1a 04 00 00       	push   $0x41a
f010253d:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102542:	e8 f9 da ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f0102547:	68 54 71 10 f0       	push   $0xf0107154
f010254c:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102551:	68 1b 04 00 00       	push   $0x41b
f0102556:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010255b:	e8 e0 da ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102560:	68 e4 65 10 f0       	push   $0xf01065e4
f0102565:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010256a:	68 1e 04 00 00       	push   $0x41e
f010256f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102574:	e8 c7 da ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102579:	68 20 66 10 f0       	push   $0xf0106620
f010257e:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102583:	68 1f 04 00 00       	push   $0x41f
f0102588:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010258d:	e8 ae da ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f0102592:	68 65 71 10 f0       	push   $0xf0107165
f0102597:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010259c:	68 20 04 00 00       	push   $0x420
f01025a1:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01025a6:	e8 95 da ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f01025ab:	68 f1 70 10 f0       	push   $0xf01070f1
f01025b0:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01025b5:	68 23 04 00 00       	push   $0x423
f01025ba:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01025bf:	e8 7c da ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01025c4:	68 e4 65 10 f0       	push   $0xf01065e4
f01025c9:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01025ce:	68 26 04 00 00       	push   $0x426
f01025d3:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01025d8:	e8 63 da ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01025dd:	68 20 66 10 f0       	push   $0xf0106620
f01025e2:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01025e7:	68 27 04 00 00       	push   $0x427
f01025ec:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01025f1:	e8 4a da ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f01025f6:	68 65 71 10 f0       	push   $0xf0107165
f01025fb:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102600:	68 28 04 00 00       	push   $0x428
f0102605:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010260a:	e8 31 da ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f010260f:	68 f1 70 10 f0       	push   $0xf01070f1
f0102614:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102619:	68 2c 04 00 00       	push   $0x42c
f010261e:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102623:	e8 18 da ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102628:	50                   	push   %eax
f0102629:	68 24 5b 10 f0       	push   $0xf0105b24
f010262e:	68 2f 04 00 00       	push   $0x42f
f0102633:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102638:	e8 03 da ff ff       	call   f0100040 <_panic>
    assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f010263d:	68 50 66 10 f0       	push   $0xf0106650
f0102642:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102647:	68 30 04 00 00       	push   $0x430
f010264c:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102651:	e8 ea d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0102656:	68 94 66 10 f0       	push   $0xf0106694
f010265b:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102660:	68 33 04 00 00       	push   $0x433
f0102665:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010266a:	e8 d1 d9 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010266f:	68 20 66 10 f0       	push   $0xf0106620
f0102674:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102679:	68 34 04 00 00       	push   $0x434
f010267e:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102683:	e8 b8 d9 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f0102688:	68 65 71 10 f0       	push   $0xf0107165
f010268d:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102692:	68 35 04 00 00       	push   $0x435
f0102697:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010269c:	e8 9f d9 ff ff       	call   f0100040 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f01026a1:	68 d8 66 10 f0       	push   $0xf01066d8
f01026a6:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01026ab:	68 36 04 00 00       	push   $0x436
f01026b0:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01026b5:	e8 86 d9 ff ff       	call   f0100040 <_panic>
    assert(kern_pgdir[0] & PTE_U);//骗我说目录项的权限可以消极一点？？？
f01026ba:	68 76 71 10 f0       	push   $0xf0107176
f01026bf:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01026c4:	68 37 04 00 00       	push   $0x437
f01026c9:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01026ce:	e8 6d d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01026d3:	68 e4 65 10 f0       	push   $0xf01065e4
f01026d8:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01026dd:	68 3a 04 00 00       	push   $0x43a
f01026e2:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01026e7:	e8 54 d9 ff ff       	call   f0100040 <_panic>
    assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f01026ec:	68 0c 67 10 f0       	push   $0xf010670c
f01026f1:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01026f6:	68 3b 04 00 00       	push   $0x43b
f01026fb:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102700:	e8 3b d9 ff ff       	call   f0100040 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102705:	68 40 67 10 f0       	push   $0xf0106740
f010270a:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010270f:	68 3c 04 00 00       	push   $0x43c
f0102714:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102719:	e8 22 d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f010271e:	68 78 67 10 f0       	push   $0xf0106778
f0102723:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102728:	68 3f 04 00 00       	push   $0x43f
f010272d:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102732:	e8 09 d9 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0102737:	68 b4 67 10 f0       	push   $0xf01067b4
f010273c:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102741:	68 42 04 00 00       	push   $0x442
f0102746:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010274b:	e8 f0 d8 ff ff       	call   f0100040 <_panic>
    assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102750:	68 40 67 10 f0       	push   $0xf0106740
f0102755:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010275a:	68 43 04 00 00       	push   $0x443
f010275f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102764:	e8 d7 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102769:	68 f0 67 10 f0       	push   $0xf01067f0
f010276e:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102773:	68 46 04 00 00       	push   $0x446
f0102778:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010277d:	e8 be d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102782:	68 1c 68 10 f0       	push   $0xf010681c
f0102787:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010278c:	68 47 04 00 00       	push   $0x447
f0102791:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102796:	e8 a5 d8 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 2);
f010279b:	68 8c 71 10 f0       	push   $0xf010718c
f01027a0:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01027a5:	68 49 04 00 00       	push   $0x449
f01027aa:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01027af:	e8 8c d8 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f01027b4:	68 9d 71 10 f0       	push   $0xf010719d
f01027b9:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01027be:	68 4a 04 00 00       	push   $0x44a
f01027c3:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01027c8:	e8 73 d8 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(0)) && pp == pp2);
f01027cd:	68 4c 68 10 f0       	push   $0xf010684c
f01027d2:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01027d7:	68 4d 04 00 00       	push   $0x44d
f01027dc:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01027e1:	e8 5a d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027e6:	68 70 68 10 f0       	push   $0xf0106870
f01027eb:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01027f0:	68 51 04 00 00       	push   $0x451
f01027f5:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01027fa:	e8 41 d8 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01027ff:	68 1c 68 10 f0       	push   $0xf010681c
f0102804:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102809:	68 52 04 00 00       	push   $0x452
f010280e:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102813:	e8 28 d8 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102818:	68 43 71 10 f0       	push   $0xf0107143
f010281d:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102822:	68 53 04 00 00       	push   $0x453
f0102827:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010282c:	e8 0f d8 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0102831:	68 9d 71 10 f0       	push   $0xf010719d
f0102836:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010283b:	68 54 04 00 00       	push   $0x454
f0102840:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102845:	e8 f6 d7 ff ff       	call   f0100040 <_panic>
    assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f010284a:	68 94 68 10 f0       	push   $0xf0106894
f010284f:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102854:	68 57 04 00 00       	push   $0x457
f0102859:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010285e:	e8 dd d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref);
f0102863:	68 ae 71 10 f0       	push   $0xf01071ae
f0102868:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010286d:	68 58 04 00 00       	push   $0x458
f0102872:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102877:	e8 c4 d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_link == NULL);
f010287c:	68 ba 71 10 f0       	push   $0xf01071ba
f0102881:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102886:	68 59 04 00 00       	push   $0x459
f010288b:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102890:	e8 ab d7 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102895:	68 70 68 10 f0       	push   $0xf0106870
f010289a:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010289f:	68 5d 04 00 00       	push   $0x45d
f01028a4:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01028a9:	e8 92 d7 ff ff       	call   f0100040 <_panic>
    assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01028ae:	68 cc 68 10 f0       	push   $0xf01068cc
f01028b3:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01028b8:	68 5e 04 00 00       	push   $0x45e
f01028bd:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01028c2:	e8 79 d7 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f01028c7:	68 cf 71 10 f0       	push   $0xf01071cf
f01028cc:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01028d1:	68 5f 04 00 00       	push   $0x45f
f01028d6:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01028db:	e8 60 d7 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f01028e0:	68 9d 71 10 f0       	push   $0xf010719d
f01028e5:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01028ea:	68 60 04 00 00       	push   $0x460
f01028ef:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01028f4:	e8 47 d7 ff ff       	call   f0100040 <_panic>
    assert((pp = page_alloc(0)) && pp == pp1);
f01028f9:	68 f4 68 10 f0       	push   $0xf01068f4
f01028fe:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102903:	68 63 04 00 00       	push   $0x463
f0102908:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010290d:	e8 2e d7 ff ff       	call   f0100040 <_panic>
    assert(!page_alloc(0));
f0102912:	68 f1 70 10 f0       	push   $0xf01070f1
f0102917:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010291c:	68 66 04 00 00       	push   $0x466
f0102921:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102926:	e8 15 d7 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010292b:	68 8c 65 10 f0       	push   $0xf010658c
f0102930:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102935:	68 69 04 00 00       	push   $0x469
f010293a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010293f:	e8 fc d6 ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f0102944:	68 54 71 10 f0       	push   $0xf0107154
f0102949:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010294e:	68 6b 04 00 00       	push   $0x46b
f0102953:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102958:	e8 e3 d6 ff ff       	call   f0100040 <_panic>
f010295d:	56                   	push   %esi
f010295e:	68 24 5b 10 f0       	push   $0xf0105b24
f0102963:	68 72 04 00 00       	push   $0x472
f0102968:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010296d:	e8 ce d6 ff ff       	call   f0100040 <_panic>
    assert(ptep == ptep1 + PTX(va));
f0102972:	68 e0 71 10 f0       	push   $0xf01071e0
f0102977:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010297c:	68 77 04 00 00       	push   $0x477
f0102981:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102986:	e8 b5 d6 ff ff       	call   f0100040 <_panic>
f010298b:	50                   	push   %eax
f010298c:	68 24 5b 10 f0       	push   $0xf0105b24
f0102991:	6a 58                	push   $0x58
f0102993:	68 02 6f 10 f0       	push   $0xf0106f02
f0102998:	e8 a3 d6 ff ff       	call   f0100040 <_panic>
f010299d:	52                   	push   %edx
f010299e:	68 24 5b 10 f0       	push   $0xf0105b24
f01029a3:	6a 58                	push   $0x58
f01029a5:	68 02 6f 10 f0       	push   $0xf0106f02
f01029aa:	e8 91 d6 ff ff       	call   f0100040 <_panic>
        assert((ptep[i] & PTE_P) == 0);
f01029af:	68 f8 71 10 f0       	push   $0xf01071f8
f01029b4:	68 e1 6e 10 f0       	push   $0xf0106ee1
f01029b9:	68 81 04 00 00       	push   $0x481
f01029be:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01029c3:	e8 78 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029c8:	50                   	push   %eax
f01029c9:	68 48 5b 10 f0       	push   $0xf0105b48
f01029ce:	68 d1 00 00 00       	push   $0xd1
f01029d3:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01029d8:	e8 63 d6 ff ff       	call   f0100040 <_panic>
f01029dd:	50                   	push   %eax
f01029de:	68 48 5b 10 f0       	push   $0xf0105b48
f01029e3:	68 d2 00 00 00       	push   $0xd2
f01029e8:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01029ed:	e8 4e d6 ff ff       	call   f0100040 <_panic>
f01029f2:	50                   	push   %eax
f01029f3:	68 48 5b 10 f0       	push   $0xf0105b48
f01029f8:	68 d3 00 00 00       	push   $0xd3
f01029fd:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a02:	e8 39 d6 ff ff       	call   f0100040 <_panic>
f0102a07:	50                   	push   %eax
f0102a08:	68 48 5b 10 f0       	push   $0xf0105b48
f0102a0d:	68 d7 00 00 00       	push   $0xd7
f0102a12:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a17:	e8 24 d6 ff ff       	call   f0100040 <_panic>
f0102a1c:	50                   	push   %eax
f0102a1d:	68 48 5b 10 f0       	push   $0xf0105b48
f0102a22:	68 e1 00 00 00       	push   $0xe1
f0102a27:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a2c:	e8 0f d6 ff ff       	call   f0100040 <_panic>
f0102a31:	50                   	push   %eax
f0102a32:	68 48 5b 10 f0       	push   $0xf0105b48
f0102a37:	68 f2 00 00 00       	push   $0xf2
f0102a3c:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a41:	e8 fa d5 ff ff       	call   f0100040 <_panic>
f0102a46:	56                   	push   %esi
f0102a47:	68 48 5b 10 f0       	push   $0xf0105b48
f0102a4c:	68 36 01 00 00       	push   $0x136
f0102a51:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a56:	e8 e5 d5 ff ff       	call   f0100040 <_panic>
f0102a5b:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102a5e:	68 48 5b 10 f0       	push   $0xf0105b48
f0102a63:	68 b4 03 00 00       	push   $0x3b4
f0102a68:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a6d:	e8 ce d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a72:	68 08 6c 10 f0       	push   $0xf0106c08
f0102a77:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102a7c:	68 b4 03 00 00       	push   $0x3b4
f0102a81:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102a86:	e8 b5 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a8b:	a1 4c c2 22 f0       	mov    0xf022c24c,%eax
f0102a90:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102a93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102a96:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102a9b:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102aa1:	89 da                	mov    %ebx,%edx
f0102aa3:	89 f8                	mov    %edi,%eax
f0102aa5:	e8 02 e0 ff ff       	call   f0100aac <check_va2pa>
f0102aaa:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102ab1:	76 3d                	jbe    f0102af0 <mem_init+0x1772>
f0102ab3:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102ab6:	39 d0                	cmp    %edx,%eax
f0102ab8:	75 4d                	jne    f0102b07 <mem_init+0x1789>
f0102aba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    for (i = 0; i < n; i += PGSIZE)
f0102ac0:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102ac6:	75 d9                	jne    f0102aa1 <mem_init+0x1723>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ac8:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102acb:	c1 e6 0c             	shl    $0xc,%esi
f0102ace:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102ad3:	39 f3                	cmp    %esi,%ebx
f0102ad5:	73 62                	jae    f0102b39 <mem_init+0x17bb>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102ad7:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102add:	89 f8                	mov    %edi,%eax
f0102adf:	e8 c8 df ff ff       	call   f0100aac <check_va2pa>
f0102ae4:	39 c3                	cmp    %eax,%ebx
f0102ae6:	75 38                	jne    f0102b20 <mem_init+0x17a2>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ae8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102aee:	eb e3                	jmp    f0102ad3 <mem_init+0x1755>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102af0:	ff 75 d0             	pushl  -0x30(%ebp)
f0102af3:	68 48 5b 10 f0       	push   $0xf0105b48
f0102af8:	68 b9 03 00 00       	push   $0x3b9
f0102afd:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102b02:	e8 39 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102b07:	68 3c 6c 10 f0       	push   $0xf0106c3c
f0102b0c:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102b11:	68 b9 03 00 00       	push   $0x3b9
f0102b16:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102b1b:	e8 20 d5 ff ff       	call   f0100040 <_panic>
        assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b20:	68 70 6c 10 f0       	push   $0xf0106c70
f0102b25:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102b2a:	68 bd 03 00 00       	push   $0x3bd
f0102b2f:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102b34:	e8 07 d5 ff ff       	call   f0100040 <_panic>
    for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b39:	c7 45 d4 00 e0 22 f0 	movl   $0xf022e000,-0x2c(%ebp)
f0102b40:	be 00 80 ff ef       	mov    $0xefff8000,%esi
            assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b48:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102b4b:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102b51:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102b54:	89 f3                	mov    %esi,%ebx
f0102b56:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102b59:	05 00 80 00 20       	add    $0x20008000,%eax
f0102b5e:	89 75 c8             	mov    %esi,-0x38(%ebp)
f0102b61:	89 c6                	mov    %eax,%esi
f0102b63:	89 da                	mov    %ebx,%edx
f0102b65:	89 f8                	mov    %edi,%eax
f0102b67:	e8 40 df ff ff       	call   f0100aac <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102b6c:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102b73:	76 5c                	jbe    f0102bd1 <mem_init+0x1853>
f0102b75:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102b78:	39 d0                	cmp    %edx,%eax
f0102b7a:	75 6c                	jne    f0102be8 <mem_init+0x186a>
f0102b7c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b82:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f0102b85:	75 dc                	jne    f0102b63 <mem_init+0x17e5>
f0102b87:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102b8a:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
            assert(check_va2pa(pgdir, base + i) == ~0);
f0102b90:	89 da                	mov    %ebx,%edx
f0102b92:	89 f8                	mov    %edi,%eax
f0102b94:	e8 13 df ff ff       	call   f0100aac <check_va2pa>
f0102b99:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b9c:	75 63                	jne    f0102c01 <mem_init+0x1883>
f0102b9e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102ba4:	39 f3                	cmp    %esi,%ebx
f0102ba6:	75 e8                	jne    f0102b90 <mem_init+0x1812>
f0102ba8:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102bae:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102bb8:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
    for (n = 0; n < NCPU; n++) {
f0102bbf:	3d 00 e0 2e f0       	cmp    $0xf02ee000,%eax
f0102bc4:	0f 85 7b ff ff ff    	jne    f0102b45 <mem_init+0x17c7>
    for (i = 0; i < NPDENTRIES; i++) {
f0102bca:	b8 00 00 00 00       	mov    $0x0,%eax
f0102bcf:	eb 6b                	jmp    f0102c3c <mem_init+0x18be>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102bd1:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102bd4:	68 48 5b 10 f0       	push   $0xf0105b48
f0102bd9:	68 c5 03 00 00       	push   $0x3c5
f0102bde:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102be3:	e8 58 d4 ff ff       	call   f0100040 <_panic>
            assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102be8:	68 98 6c 10 f0       	push   $0xf0106c98
f0102bed:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102bf2:	68 c5 03 00 00       	push   $0x3c5
f0102bf7:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102bfc:	e8 3f d4 ff ff       	call   f0100040 <_panic>
            assert(check_va2pa(pgdir, base + i) == ~0);
f0102c01:	68 e0 6c 10 f0       	push   $0xf0106ce0
f0102c06:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102c0b:	68 c7 03 00 00       	push   $0x3c7
f0102c10:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102c15:	e8 26 d4 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_P);
f0102c1a:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102c1d:	f6 c2 01             	test   $0x1,%dl
f0102c20:	74 40                	je     f0102c62 <mem_init+0x18e4>
                    assert(pgdir[i] & PTE_W);
f0102c22:	f6 c2 02             	test   $0x2,%dl
f0102c25:	74 54                	je     f0102c7b <mem_init+0x18fd>
    for (i = 0; i < NPDENTRIES; i++) {
f0102c27:	83 c0 01             	add    $0x1,%eax
f0102c2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102c2f:	77 63                	ja     f0102c94 <mem_init+0x1916>
        switch (i) {
f0102c31:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102c37:	83 fa 04             	cmp    $0x4,%edx
f0102c3a:	76 eb                	jbe    f0102c27 <mem_init+0x18a9>
                if (i >= PDX(KERNBASE)) {
f0102c3c:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102c41:	77 d7                	ja     f0102c1a <mem_init+0x189c>
                    assert(pgdir[i] == 0);
f0102c43:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102c47:	74 de                	je     f0102c27 <mem_init+0x18a9>
f0102c49:	68 5f 72 10 f0       	push   $0xf010725f
f0102c4e:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102c53:	68 da 03 00 00       	push   $0x3da
f0102c58:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102c5d:	e8 de d3 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_P);
f0102c62:	68 3d 72 10 f0       	push   $0xf010723d
f0102c67:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102c6c:	68 d7 03 00 00       	push   $0x3d7
f0102c71:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102c76:	e8 c5 d3 ff ff       	call   f0100040 <_panic>
                    assert(pgdir[i] & PTE_W);
f0102c7b:	68 4e 72 10 f0       	push   $0xf010724e
f0102c80:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102c85:	68 d8 03 00 00       	push   $0x3d8
f0102c8a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102c8f:	e8 ac d3 ff ff       	call   f0100040 <_panic>
    cprintf("check_kern_pgdir() succeeded!\n");
f0102c94:	83 ec 0c             	sub    $0xc,%esp
f0102c97:	68 04 6d 10 f0       	push   $0xf0106d04
f0102c9c:	e8 8f 0e 00 00       	call   f0103b30 <cprintf>
    lcr3(PADDR(kern_pgdir));
f0102ca1:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f0102ca6:	83 c4 10             	add    $0x10,%esp
f0102ca9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102cae:	0f 86 19 02 00 00    	jbe    f0102ecd <mem_init+0x1b4f>
	return (physaddr_t)kva - KERNBASE;
f0102cb4:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102cb9:	0f 22 d8             	mov    %eax,%cr3
    cprintf("\n************* Now check that the pages on the page_free_list are reasonable. **************\n");
f0102cbc:	83 ec 0c             	sub    $0xc,%esp
f0102cbf:	68 24 6d 10 f0       	push   $0xf0106d24
f0102cc4:	e8 67 0e 00 00       	call   f0103b30 <cprintf>
    check_page_free_list(0);
f0102cc9:	b8 00 00 00 00       	mov    $0x0,%eax
f0102cce:	e8 3d de ff ff       	call   f0100b10 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102cd3:	0f 20 c0             	mov    %cr0,%eax
    cr0 &= ~(CR0_TS | CR0_EM);
f0102cd6:	83 e0 f3             	and    $0xfffffff3,%eax
f0102cd9:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102cde:	0f 22 c0             	mov    %eax,%cr0
    cprintf("\n************* Now check page_insert, page_remove, &c, with an installed kern_pgdir **************\n");
f0102ce1:	c7 04 24 84 6d 10 f0 	movl   $0xf0106d84,(%esp)
f0102ce8:	e8 43 0e 00 00       	call   f0103b30 <cprintf>
    uintptr_t va;
    int i;

    // check that we can read and write installed pages
    pp1 = pp2 = 0;
    assert((pp0 = page_alloc(0)));
f0102ced:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102cf4:	e8 e5 e2 ff ff       	call   f0100fde <page_alloc>
f0102cf9:	89 c3                	mov    %eax,%ebx
f0102cfb:	83 c4 10             	add    $0x10,%esp
f0102cfe:	85 c0                	test   %eax,%eax
f0102d00:	0f 84 dc 01 00 00    	je     f0102ee2 <mem_init+0x1b64>
    assert((pp1 = page_alloc(0)));
f0102d06:	83 ec 0c             	sub    $0xc,%esp
f0102d09:	6a 00                	push   $0x0
f0102d0b:	e8 ce e2 ff ff       	call   f0100fde <page_alloc>
f0102d10:	89 c7                	mov    %eax,%edi
f0102d12:	83 c4 10             	add    $0x10,%esp
f0102d15:	85 c0                	test   %eax,%eax
f0102d17:	0f 84 de 01 00 00    	je     f0102efb <mem_init+0x1b7d>
    assert((pp2 = page_alloc(0)));
f0102d1d:	83 ec 0c             	sub    $0xc,%esp
f0102d20:	6a 00                	push   $0x0
f0102d22:	e8 b7 e2 ff ff       	call   f0100fde <page_alloc>
f0102d27:	89 c6                	mov    %eax,%esi
f0102d29:	83 c4 10             	add    $0x10,%esp
f0102d2c:	85 c0                	test   %eax,%eax
f0102d2e:	0f 84 e0 01 00 00    	je     f0102f14 <mem_init+0x1b96>
    page_free(pp0);
f0102d34:	83 ec 0c             	sub    $0xc,%esp
f0102d37:	53                   	push   %ebx
f0102d38:	e8 19 e3 ff ff       	call   f0101056 <page_free>
	return (pp - pages) << PGSHIFT;
f0102d3d:	89 f8                	mov    %edi,%eax
f0102d3f:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0102d45:	c1 f8 03             	sar    $0x3,%eax
f0102d48:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102d4b:	89 c2                	mov    %eax,%edx
f0102d4d:	c1 ea 0c             	shr    $0xc,%edx
f0102d50:	83 c4 10             	add    $0x10,%esp
f0102d53:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f0102d59:	0f 83 ce 01 00 00    	jae    f0102f2d <mem_init+0x1baf>
    memset(page2kva(pp1), 1, PGSIZE);
f0102d5f:	83 ec 04             	sub    $0x4,%esp
f0102d62:	68 00 10 00 00       	push   $0x1000
f0102d67:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d69:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102d6e:	50                   	push   %eax
f0102d6f:	e8 26 21 00 00       	call   f0104e9a <memset>
	return (pp - pages) << PGSHIFT;
f0102d74:	89 f0                	mov    %esi,%eax
f0102d76:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0102d7c:	c1 f8 03             	sar    $0x3,%eax
f0102d7f:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102d82:	89 c2                	mov    %eax,%edx
f0102d84:	c1 ea 0c             	shr    $0xc,%edx
f0102d87:	83 c4 10             	add    $0x10,%esp
f0102d8a:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f0102d90:	0f 83 a9 01 00 00    	jae    f0102f3f <mem_init+0x1bc1>
    memset(page2kva(pp2), 2, PGSIZE);
f0102d96:	83 ec 04             	sub    $0x4,%esp
f0102d99:	68 00 10 00 00       	push   $0x1000
f0102d9e:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102da0:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102da5:	50                   	push   %eax
f0102da6:	e8 ef 20 00 00       	call   f0104e9a <memset>
    page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f0102dab:	6a 02                	push   $0x2
f0102dad:	68 00 10 00 00       	push   $0x1000
f0102db2:	57                   	push   %edi
f0102db3:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0102db9:	e8 95 e4 ff ff       	call   f0101253 <page_insert>
    assert(pp1->pp_ref == 1);
f0102dbe:	83 c4 20             	add    $0x20,%esp
f0102dc1:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102dc6:	0f 85 85 01 00 00    	jne    f0102f51 <mem_init+0x1bd3>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0102dcc:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102dd3:	01 01 01 
f0102dd6:	0f 85 8e 01 00 00    	jne    f0102f6a <mem_init+0x1bec>
    page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0102ddc:	6a 02                	push   $0x2
f0102dde:	68 00 10 00 00       	push   $0x1000
f0102de3:	56                   	push   %esi
f0102de4:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0102dea:	e8 64 e4 ff ff       	call   f0101253 <page_insert>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0102def:	83 c4 10             	add    $0x10,%esp
f0102df2:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102df9:	02 02 02 
f0102dfc:	0f 85 81 01 00 00    	jne    f0102f83 <mem_init+0x1c05>
    assert(pp2->pp_ref == 1);
f0102e02:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e07:	0f 85 8f 01 00 00    	jne    f0102f9c <mem_init+0x1c1e>
    assert(pp1->pp_ref == 0);
f0102e0d:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102e12:	0f 85 9d 01 00 00    	jne    f0102fb5 <mem_init+0x1c37>
    *(uint32_t *) PGSIZE = 0x03030303U;
f0102e18:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102e1f:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102e22:	89 f0                	mov    %esi,%eax
f0102e24:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0102e2a:	c1 f8 03             	sar    $0x3,%eax
f0102e2d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102e30:	89 c2                	mov    %eax,%edx
f0102e32:	c1 ea 0c             	shr    $0xc,%edx
f0102e35:	3b 15 0c cf 22 f0    	cmp    0xf022cf0c,%edx
f0102e3b:	0f 83 8d 01 00 00    	jae    f0102fce <mem_init+0x1c50>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0102e41:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102e48:	03 03 03 
f0102e4b:	0f 85 8f 01 00 00    	jne    f0102fe0 <mem_init+0x1c62>
    page_remove(kern_pgdir, (void *) PGSIZE);
f0102e51:	83 ec 08             	sub    $0x8,%esp
f0102e54:	68 00 10 00 00       	push   $0x1000
f0102e59:	ff 35 10 cf 22 f0    	pushl  0xf022cf10
f0102e5f:	e8 ac e3 ff ff       	call   f0101210 <page_remove>
    assert(pp2->pp_ref == 0);
f0102e64:	83 c4 10             	add    $0x10,%esp
f0102e67:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102e6c:	0f 85 87 01 00 00    	jne    f0102ff9 <mem_init+0x1c7b>

    // forcibly take pp0 back
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e72:	8b 0d 10 cf 22 f0    	mov    0xf022cf10,%ecx
f0102e78:	8b 11                	mov    (%ecx),%edx
f0102e7a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102e80:	89 d8                	mov    %ebx,%eax
f0102e82:	2b 05 14 cf 22 f0    	sub    0xf022cf14,%eax
f0102e88:	c1 f8 03             	sar    $0x3,%eax
f0102e8b:	c1 e0 0c             	shl    $0xc,%eax
f0102e8e:	39 c2                	cmp    %eax,%edx
f0102e90:	0f 85 7c 01 00 00    	jne    f0103012 <mem_init+0x1c94>
    kern_pgdir[0] = 0;
f0102e96:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    assert(pp0->pp_ref == 1);
f0102e9c:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102ea1:	0f 85 84 01 00 00    	jne    f010302b <mem_init+0x1cad>
    pp0->pp_ref = 0;
f0102ea7:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

    // free the pages we took
    page_free(pp0);
f0102ead:	83 ec 0c             	sub    $0xc,%esp
f0102eb0:	53                   	push   %ebx
f0102eb1:	e8 a0 e1 ff ff       	call   f0101056 <page_free>

    cprintf("check_page_installed_pgdir() succeeded!\n");
f0102eb6:	c7 04 24 5c 6e 10 f0 	movl   $0xf0106e5c,(%esp)
f0102ebd:	e8 6e 0c 00 00       	call   f0103b30 <cprintf>
}
f0102ec2:	83 c4 10             	add    $0x10,%esp
f0102ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102ec8:	5b                   	pop    %ebx
f0102ec9:	5e                   	pop    %esi
f0102eca:	5f                   	pop    %edi
f0102ecb:	5d                   	pop    %ebp
f0102ecc:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ecd:	50                   	push   %eax
f0102ece:	68 48 5b 10 f0       	push   $0xf0105b48
f0102ed3:	68 0c 01 00 00       	push   $0x10c
f0102ed8:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102edd:	e8 5e d1 ff ff       	call   f0100040 <_panic>
    assert((pp0 = page_alloc(0)));
f0102ee2:	68 9d 70 10 f0       	push   $0xf010709d
f0102ee7:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102eec:	68 9b 04 00 00       	push   $0x49b
f0102ef1:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102ef6:	e8 45 d1 ff ff       	call   f0100040 <_panic>
    assert((pp1 = page_alloc(0)));
f0102efb:	68 b3 70 10 f0       	push   $0xf01070b3
f0102f00:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102f05:	68 9c 04 00 00       	push   $0x49c
f0102f0a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102f0f:	e8 2c d1 ff ff       	call   f0100040 <_panic>
    assert((pp2 = page_alloc(0)));
f0102f14:	68 c9 70 10 f0       	push   $0xf01070c9
f0102f19:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102f1e:	68 9d 04 00 00       	push   $0x49d
f0102f23:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102f28:	e8 13 d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f2d:	50                   	push   %eax
f0102f2e:	68 24 5b 10 f0       	push   $0xf0105b24
f0102f33:	6a 58                	push   $0x58
f0102f35:	68 02 6f 10 f0       	push   $0xf0106f02
f0102f3a:	e8 01 d1 ff ff       	call   f0100040 <_panic>
f0102f3f:	50                   	push   %eax
f0102f40:	68 24 5b 10 f0       	push   $0xf0105b24
f0102f45:	6a 58                	push   $0x58
f0102f47:	68 02 6f 10 f0       	push   $0xf0106f02
f0102f4c:	e8 ef d0 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 1);
f0102f51:	68 43 71 10 f0       	push   $0xf0107143
f0102f56:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102f5b:	68 a2 04 00 00       	push   $0x4a2
f0102f60:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102f65:	e8 d6 d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0102f6a:	68 e8 6d 10 f0       	push   $0xf0106de8
f0102f6f:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102f74:	68 a3 04 00 00       	push   $0x4a3
f0102f79:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102f7e:	e8 bd d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0102f83:	68 0c 6e 10 f0       	push   $0xf0106e0c
f0102f88:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102f8d:	68 a5 04 00 00       	push   $0x4a5
f0102f92:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102f97:	e8 a4 d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 1);
f0102f9c:	68 65 71 10 f0       	push   $0xf0107165
f0102fa1:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102fa6:	68 a6 04 00 00       	push   $0x4a6
f0102fab:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102fb0:	e8 8b d0 ff ff       	call   f0100040 <_panic>
    assert(pp1->pp_ref == 0);
f0102fb5:	68 cf 71 10 f0       	push   $0xf01071cf
f0102fba:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102fbf:	68 a7 04 00 00       	push   $0x4a7
f0102fc4:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102fc9:	e8 72 d0 ff ff       	call   f0100040 <_panic>
f0102fce:	50                   	push   %eax
f0102fcf:	68 24 5b 10 f0       	push   $0xf0105b24
f0102fd4:	6a 58                	push   $0x58
f0102fd6:	68 02 6f 10 f0       	push   $0xf0106f02
f0102fdb:	e8 60 d0 ff ff       	call   f0100040 <_panic>
    assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0102fe0:	68 30 6e 10 f0       	push   $0xf0106e30
f0102fe5:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0102fea:	68 a9 04 00 00       	push   $0x4a9
f0102fef:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0102ff4:	e8 47 d0 ff ff       	call   f0100040 <_panic>
    assert(pp2->pp_ref == 0);
f0102ff9:	68 9d 71 10 f0       	push   $0xf010719d
f0102ffe:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0103003:	68 ab 04 00 00       	push   $0x4ab
f0103008:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010300d:	e8 2e d0 ff ff       	call   f0100040 <_panic>
    assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103012:	68 8c 65 10 f0       	push   $0xf010658c
f0103017:	68 e1 6e 10 f0       	push   $0xf0106ee1
f010301c:	68 ae 04 00 00       	push   $0x4ae
f0103021:	68 f6 6e 10 f0       	push   $0xf0106ef6
f0103026:	e8 15 d0 ff ff       	call   f0100040 <_panic>
    assert(pp0->pp_ref == 1);
f010302b:	68 54 71 10 f0       	push   $0xf0107154
f0103030:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0103035:	68 b0 04 00 00       	push   $0x4b0
f010303a:	68 f6 6e 10 f0       	push   $0xf0106ef6
f010303f:	e8 fc cf ff ff       	call   f0100040 <_panic>

f0103044 <tlb_invalidate>:
tlb_invalidate(pde_t *pgdir, void *va) {
f0103044:	55                   	push   %ebp
f0103045:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0103047:	8b 45 0c             	mov    0xc(%ebp),%eax
f010304a:	0f 01 38             	invlpg (%eax)
}
f010304d:	5d                   	pop    %ebp
f010304e:	c3                   	ret    

f010304f <mmio_map_region>:
mmio_map_region(physaddr_t pa, size_t size) {
f010304f:	55                   	push   %ebp
f0103050:	89 e5                	mov    %esp,%ebp
f0103052:	53                   	push   %ebx
f0103053:	83 ec 04             	sub    $0x4,%esp
f0103056:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (base + size > MMIOLIM) {
f0103059:	8b 15 00 13 12 f0    	mov    0xf0121300,%edx
f010305f:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f0103062:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0103067:	77 31                	ja     f010309a <mmio_map_region+0x4b>
    boot_map_region(kern_pgdir, base, size, pa, PTE_PCD | PTE_PWT | PTE_W);
f0103069:	83 ec 08             	sub    $0x8,%esp
f010306c:	6a 1a                	push   $0x1a
f010306e:	ff 75 08             	pushl  0x8(%ebp)
f0103071:	89 d9                	mov    %ebx,%ecx
f0103073:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f0103078:	e8 ea e0 ff ff       	call   f0101167 <boot_map_region>
    void *ret = (void *) base;
f010307d:	a1 00 13 12 f0       	mov    0xf0121300,%eax
    base = ROUNDUP(base + size, PGSIZE);
f0103082:	8d 94 18 ff 0f 00 00 	lea    0xfff(%eax,%ebx,1),%edx
f0103089:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010308f:	89 15 00 13 12 f0    	mov    %edx,0xf0121300
}
f0103095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103098:	c9                   	leave  
f0103099:	c3                   	ret    
        panic("this reservation overflow MMIOLIM");
f010309a:	83 ec 04             	sub    $0x4,%esp
f010309d:	68 88 6e 10 f0       	push   $0xf0106e88
f01030a2:	68 b6 02 00 00       	push   $0x2b6
f01030a7:	68 f6 6e 10 f0       	push   $0xf0106ef6
f01030ac:	e8 8f cf ff ff       	call   f0100040 <_panic>

f01030b1 <user_mem_check>:
user_mem_check(struct Env *env, const void *va, size_t len, int perm) {
f01030b1:	55                   	push   %ebp
f01030b2:	89 e5                	mov    %esp,%ebp
f01030b4:	57                   	push   %edi
f01030b5:	56                   	push   %esi
f01030b6:	53                   	push   %ebx
f01030b7:	83 ec 1c             	sub    $0x1c,%esp
f01030ba:	8b 75 14             	mov    0x14(%ebp),%esi
    if ((perm & PTE_U) == 0) {
f01030bd:	f7 c6 04 00 00 00    	test   $0x4,%esi
f01030c3:	74 56                	je     f010311b <user_mem_check+0x6a>
    uintptr_t begin = ROUNDDOWN((uint32_t) va, PGSIZE), end = ROUNDUP((uint32_t) va + len, PGSIZE);
f01030c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01030c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01030ce:	8b 45 10             	mov    0x10(%ebp),%eax
f01030d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01030d4:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f01030db:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (end > ULIM) {
f01030e1:	81 ff 00 00 80 ef    	cmp    $0xef800000,%edi
f01030e7:	77 41                	ja     f010312a <user_mem_check+0x79>
        if ((pte == NULL) || ((*pte & (perm | PTE_P)) != (perm | PTE_P))) {
f01030e9:	83 ce 01             	or     $0x1,%esi
    for (int i = begin; i < end; i += PGSIZE) {
f01030ec:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f01030ef:	39 fb                	cmp    %edi,%ebx
f01030f1:	73 60                	jae    f0103153 <user_mem_check+0xa2>
        pte_t *pte = pgdir_walk(env->env_pgdir, (const void *) i, 0);
f01030f3:	83 ec 04             	sub    $0x4,%esp
f01030f6:	6a 00                	push   $0x0
f01030f8:	53                   	push   %ebx
f01030f9:	8b 45 08             	mov    0x8(%ebp),%eax
f01030fc:	ff 70 60             	pushl  0x60(%eax)
f01030ff:	e8 d1 df ff ff       	call   f01010d5 <pgdir_walk>
        if ((pte == NULL) || ((*pte & (perm | PTE_P)) != (perm | PTE_P))) {
f0103104:	83 c4 10             	add    $0x10,%esp
f0103107:	85 c0                	test   %eax,%eax
f0103109:	74 2c                	je     f0103137 <user_mem_check+0x86>
f010310b:	89 f2                	mov    %esi,%edx
f010310d:	23 10                	and    (%eax),%edx
f010310f:	39 d6                	cmp    %edx,%esi
f0103111:	75 24                	jne    f0103137 <user_mem_check+0x86>
    for (int i = begin; i < end; i += PGSIZE) {
f0103113:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103119:	eb d1                	jmp    f01030ec <user_mem_check+0x3b>
        user_mem_check_addr = (uintptr_t) va;
f010311b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010311e:	a3 3c c2 22 f0       	mov    %eax,0xf022c23c
        return -E_FAULT;
f0103123:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103128:	eb 21                	jmp    f010314b <user_mem_check+0x9a>
        user_mem_check_addr = (uintptr_t) va;
f010312a:	89 0d 3c c2 22 f0    	mov    %ecx,0xf022c23c
        return -E_FAULT;
f0103130:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103135:	eb 14                	jmp    f010314b <user_mem_check+0x9a>
            user_mem_check_addr = i < (uint32_t) va ? (uint32_t) va : i;
f0103137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010313a:	3b 45 0c             	cmp    0xc(%ebp),%eax
f010313d:	0f 42 45 0c          	cmovb  0xc(%ebp),%eax
f0103141:	a3 3c c2 22 f0       	mov    %eax,0xf022c23c
            return -E_FAULT;
f0103146:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f010314b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010314e:	5b                   	pop    %ebx
f010314f:	5e                   	pop    %esi
f0103150:	5f                   	pop    %edi
f0103151:	5d                   	pop    %ebp
f0103152:	c3                   	ret    
    return 0;
f0103153:	b8 00 00 00 00       	mov    $0x0,%eax
f0103158:	eb f1                	jmp    f010314b <user_mem_check+0x9a>

f010315a <user_mem_assert>:
user_mem_assert(struct Env *env, const void *va, size_t len, int perm) {
f010315a:	55                   	push   %ebp
f010315b:	89 e5                	mov    %esp,%ebp
f010315d:	53                   	push   %ebx
f010315e:	83 ec 04             	sub    $0x4,%esp
f0103161:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103164:	8b 45 14             	mov    0x14(%ebp),%eax
f0103167:	83 c8 04             	or     $0x4,%eax
f010316a:	50                   	push   %eax
f010316b:	ff 75 10             	pushl  0x10(%ebp)
f010316e:	ff 75 0c             	pushl  0xc(%ebp)
f0103171:	53                   	push   %ebx
f0103172:	e8 3a ff ff ff       	call   f01030b1 <user_mem_check>
f0103177:	83 c4 10             	add    $0x10,%esp
f010317a:	85 c0                	test   %eax,%eax
f010317c:	78 05                	js     f0103183 <user_mem_assert+0x29>
}
f010317e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103181:	c9                   	leave  
f0103182:	c3                   	ret    
        cprintf("[%08x] user_mem_check assertion failure for "
f0103183:	83 ec 04             	sub    $0x4,%esp
f0103186:	ff 35 3c c2 22 f0    	pushl  0xf022c23c
f010318c:	ff 73 48             	pushl  0x48(%ebx)
f010318f:	68 ac 6e 10 f0       	push   $0xf0106eac
f0103194:	e8 97 09 00 00       	call   f0103b30 <cprintf>
        env_destroy(env);    // may not return
f0103199:	89 1c 24             	mov    %ebx,(%esp)
f010319c:	e8 09 07 00 00       	call   f01038aa <env_destroy>
f01031a1:	83 c4 10             	add    $0x10,%esp
}
f01031a4:	eb d8                	jmp    f010317e <user_mem_assert+0x24>

f01031a6 <region_alloc>:
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len) {
f01031a6:	55                   	push   %ebp
f01031a7:	89 e5                	mov    %esp,%ebp
f01031a9:	57                   	push   %edi
f01031aa:	56                   	push   %esi
f01031ab:	53                   	push   %ebx
f01031ac:	83 ec 0c             	sub    $0xc,%esp
    //
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
    pde_t *pgdir = e->env_pgdir;
f01031af:	8b 78 60             	mov    0x60(%eax),%edi
    uintptr_t begin = ROUNDDOWN((uintptr_t) va, PGSIZE), end = ROUNDUP((uintptr_t) va + len, PGSIZE);
f01031b2:	89 d3                	mov    %edx,%ebx
f01031b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01031ba:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01031c1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (; begin < end; begin += PGSIZE) {
f01031c7:	eb 2e                	jmp    f01031f7 <region_alloc+0x51>
//        if (!page_lookup(pgdir, (void *) begin, NULL)) {
            cprintf("begin:0x%x\tend:0x%x\n", begin, end);
f01031c9:	83 ec 04             	sub    $0x4,%esp
f01031cc:	56                   	push   %esi
f01031cd:	53                   	push   %ebx
f01031ce:	68 6d 72 10 f0       	push   $0xf010726d
f01031d3:	e8 58 09 00 00       	call   f0103b30 <cprintf>
            //alloc_flag ??? why false??? sb fz
//            page_insert(pgdir, page_alloc(false), (void *) begin, PTE_U | PTE_W);
            page_insert(pgdir, page_alloc(ALLOC_ZERO), (void *) begin, PTE_U | PTE_W);
f01031d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01031df:	e8 fa dd ff ff       	call   f0100fde <page_alloc>
f01031e4:	6a 06                	push   $0x6
f01031e6:	53                   	push   %ebx
f01031e7:	50                   	push   %eax
f01031e8:	57                   	push   %edi
f01031e9:	e8 65 e0 ff ff       	call   f0101253 <page_insert>
    for (; begin < end; begin += PGSIZE) {
f01031ee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01031f4:	83 c4 20             	add    $0x20,%esp
f01031f7:	39 f3                	cmp    %esi,%ebx
f01031f9:	72 ce                	jb     f01031c9 <region_alloc+0x23>
//        }
    }
}
f01031fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01031fe:	5b                   	pop    %ebx
f01031ff:	5e                   	pop    %esi
f0103200:	5f                   	pop    %edi
f0103201:	5d                   	pop    %ebp
f0103202:	c3                   	ret    

f0103203 <envid2env>:
envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
f0103203:	55                   	push   %ebp
f0103204:	89 e5                	mov    %esp,%ebp
f0103206:	56                   	push   %esi
f0103207:	53                   	push   %ebx
f0103208:	8b 45 08             	mov    0x8(%ebp),%eax
f010320b:	8b 55 10             	mov    0x10(%ebp),%edx
    if (envid == 0) {
f010320e:	85 c0                	test   %eax,%eax
f0103210:	74 2e                	je     f0103240 <envid2env+0x3d>
    e = &envs[ENVX(envid)];
f0103212:	89 c3                	mov    %eax,%ebx
f0103214:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010321a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f010321d:	03 1d 4c c2 22 f0    	add    0xf022c24c,%ebx
    if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103223:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103227:	74 31                	je     f010325a <envid2env+0x57>
f0103229:	39 43 48             	cmp    %eax,0x48(%ebx)
f010322c:	75 2c                	jne    f010325a <envid2env+0x57>
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010322e:	84 d2                	test   %dl,%dl
f0103230:	75 38                	jne    f010326a <envid2env+0x67>
    *env_store = e;
f0103232:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103235:	89 18                	mov    %ebx,(%eax)
    return 0;
f0103237:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010323c:	5b                   	pop    %ebx
f010323d:	5e                   	pop    %esi
f010323e:	5d                   	pop    %ebp
f010323f:	c3                   	ret    
        *env_store = curenv;
f0103240:	e8 7a 22 00 00       	call   f01054bf <cpunum>
f0103245:	6b c0 74             	imul   $0x74,%eax,%eax
f0103248:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f010324e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103251:	89 01                	mov    %eax,(%ecx)
        return 0;
f0103253:	b8 00 00 00 00       	mov    $0x0,%eax
f0103258:	eb e2                	jmp    f010323c <envid2env+0x39>
        *env_store = 0;
f010325a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010325d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f0103263:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103268:	eb d2                	jmp    f010323c <envid2env+0x39>
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010326a:	e8 50 22 00 00       	call   f01054bf <cpunum>
f010326f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103272:	39 98 28 d0 22 f0    	cmp    %ebx,-0xfdd2fd8(%eax)
f0103278:	74 b8                	je     f0103232 <envid2env+0x2f>
f010327a:	8b 73 4c             	mov    0x4c(%ebx),%esi
f010327d:	e8 3d 22 00 00       	call   f01054bf <cpunum>
f0103282:	6b c0 74             	imul   $0x74,%eax,%eax
f0103285:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f010328b:	3b 70 48             	cmp    0x48(%eax),%esi
f010328e:	74 a2                	je     f0103232 <envid2env+0x2f>
        *env_store = 0;
f0103290:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        return -E_BAD_ENV;
f0103299:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010329e:	eb 9c                	jmp    f010323c <envid2env+0x39>

f01032a0 <env_init_percpu>:
env_init_percpu(void) {
f01032a0:	55                   	push   %ebp
f01032a1:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f01032a3:	b8 20 13 12 f0       	mov    $0xf0121320,%eax
f01032a8:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax,%%gs" : : "a" (GD_UD | 3));
f01032ab:	b8 23 00 00 00       	mov    $0x23,%eax
f01032b0:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax,%%fs" : : "a" (GD_UD | 3));
f01032b2:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01032b4:	b8 10 00 00 00       	mov    $0x10,%eax
f01032b9:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01032bb:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01032bd:	8e d0                	mov    %eax,%ss
    asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01032bf:	ea c6 32 10 f0 08 00 	ljmp   $0x8,$0xf01032c6
	asm volatile("lldt %0" : : "r" (sel));
f01032c6:	b8 00 00 00 00       	mov    $0x0,%eax
f01032cb:	0f 00 d0             	lldt   %ax
}
f01032ce:	5d                   	pop    %ebp
f01032cf:	c3                   	ret    

f01032d0 <env_init>:
env_init(void) {
f01032d0:	55                   	push   %ebp
f01032d1:	89 e5                	mov    %esp,%ebp
f01032d3:	56                   	push   %esi
f01032d4:	53                   	push   %ebx
        envs[i].env_link = env_free_list;
f01032d5:	8b 35 4c c2 22 f0    	mov    0xf022c24c,%esi
f01032db:	8b 15 50 c2 22 f0    	mov    0xf022c250,%edx
f01032e1:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f01032e7:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f01032ea:	89 c1                	mov    %eax,%ecx
f01032ec:	89 50 44             	mov    %edx,0x44(%eax)
f01032ef:	83 e8 7c             	sub    $0x7c,%eax
        env_free_list = &envs[i];
f01032f2:	89 ca                	mov    %ecx,%edx
    for (i = NENV - 1; i >= 0; i--) {
f01032f4:	39 d8                	cmp    %ebx,%eax
f01032f6:	75 f2                	jne    f01032ea <env_init+0x1a>
f01032f8:	89 35 50 c2 22 f0    	mov    %esi,0xf022c250
    env_init_percpu();
f01032fe:	e8 9d ff ff ff       	call   f01032a0 <env_init_percpu>
}
f0103303:	5b                   	pop    %ebx
f0103304:	5e                   	pop    %esi
f0103305:	5d                   	pop    %ebp
f0103306:	c3                   	ret    

f0103307 <env_alloc>:
env_alloc(struct Env **newenv_store, envid_t parent_id) {
f0103307:	55                   	push   %ebp
f0103308:	89 e5                	mov    %esp,%ebp
f010330a:	53                   	push   %ebx
f010330b:	83 ec 10             	sub    $0x10,%esp
    cprintf("************* Now we alloc a env. **************\n");
f010330e:	68 e8 72 10 f0       	push   $0xf01072e8
f0103313:	e8 18 08 00 00       	call   f0103b30 <cprintf>
    if (!(e = env_free_list))
f0103318:	8b 1d 50 c2 22 f0    	mov    0xf022c250,%ebx
f010331e:	83 c4 10             	add    $0x10,%esp
f0103321:	85 db                	test   %ebx,%ebx
f0103323:	0f 84 d2 01 00 00    	je     f01034fb <env_alloc+0x1f4>
    cprintf("************* Now we set up a env's vm. **************\n");
f0103329:	83 ec 0c             	sub    $0xc,%esp
f010332c:	68 1c 73 10 f0       	push   $0xf010731c
f0103331:	e8 fa 07 00 00       	call   f0103b30 <cprintf>
    if (!(p = page_alloc(ALLOC_ZERO)))
f0103336:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010333d:	e8 9c dc ff ff       	call   f0100fde <page_alloc>
f0103342:	83 c4 10             	add    $0x10,%esp
f0103345:	85 c0                	test   %eax,%eax
f0103347:	0f 84 b5 01 00 00    	je     f0103502 <env_alloc+0x1fb>
	return (pp - pages) << PGSHIFT;
f010334d:	89 c2                	mov    %eax,%edx
f010334f:	2b 15 14 cf 22 f0    	sub    0xf022cf14,%edx
f0103355:	c1 fa 03             	sar    $0x3,%edx
f0103358:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010335b:	89 d1                	mov    %edx,%ecx
f010335d:	c1 e9 0c             	shr    $0xc,%ecx
f0103360:	3b 0d 0c cf 22 f0    	cmp    0xf022cf0c,%ecx
f0103366:	0f 83 68 01 00 00    	jae    f01034d4 <env_alloc+0x1cd>
	return (void *)(pa + KERNBASE);
f010336c:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103372:	89 53 60             	mov    %edx,0x60(%ebx)
    p->pp_ref++;
f0103375:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    cprintf("UTOP:0x%x\te->env_pgdor:0x%x\tsizeof(pde_t):%d\n", UTOP, e->env_pgdir, sizeof(pde_t));
f010337a:	6a 04                	push   $0x4
f010337c:	ff 73 60             	pushl  0x60(%ebx)
f010337f:	68 00 00 c0 ee       	push   $0xeec00000
f0103384:	68 54 73 10 f0       	push   $0xf0107354
f0103389:	e8 a2 07 00 00       	call   f0103b30 <cprintf>
    cprintf("UTOP:0x%x\tutop_off:0x%x\te->env_pgdir + utop_off:0x%x\tkern_pgdir + utop_off:%x\tsizeof(pde_t) * (NPDENTRIES - utop_off)):%d\n",
f010338e:	83 c4 08             	add    $0x8,%esp
f0103391:	68 14 01 00 00       	push   $0x114
f0103396:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f010339b:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033a0:	50                   	push   %eax
f01033a1:	8b 43 60             	mov    0x60(%ebx),%eax
f01033a4:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033a9:	50                   	push   %eax
f01033aa:	68 bb 03 00 00       	push   $0x3bb
f01033af:	68 00 00 c0 ee       	push   $0xeec00000
f01033b4:	68 84 73 10 f0       	push   $0xf0107384
f01033b9:	e8 72 07 00 00       	call   f0103b30 <cprintf>
    memcpy(e->env_pgdir + utop_off, kern_pgdir + utop_off, sizeof(pde_t) * (NPDENTRIES - utop_off));
f01033be:	83 c4 1c             	add    $0x1c,%esp
f01033c1:	68 14 01 00 00       	push   $0x114
f01033c6:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
f01033cb:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033d0:	50                   	push   %eax
f01033d1:	8b 43 60             	mov    0x60(%ebx),%eax
f01033d4:	05 ec 0e 00 00       	add    $0xeec,%eax
f01033d9:	50                   	push   %eax
f01033da:	e8 70 1b 00 00       	call   f0104f4f <memcpy>
    e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01033df:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01033e2:	83 c4 10             	add    $0x10,%esp
f01033e5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01033ea:	0f 86 f6 00 00 00    	jbe    f01034e6 <env_alloc+0x1df>
	return (physaddr_t)kva - KERNBASE;
f01033f0:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01033f6:	83 ca 05             	or     $0x5,%edx
f01033f9:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
    cprintf("************* Now we successfully set up a env's vm. **************\n");
f01033ff:	83 ec 0c             	sub    $0xc,%esp
f0103402:	68 00 74 10 f0       	push   $0xf0107400
f0103407:	e8 24 07 00 00       	call   f0103b30 <cprintf>
    generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f010340c:	8b 43 48             	mov    0x48(%ebx),%eax
f010340f:	05 00 10 00 00       	add    $0x1000,%eax
    if (generation <= 0)    // Don't create a negative env_id.
f0103414:	83 c4 0c             	add    $0xc,%esp
f0103417:	25 00 fc ff ff       	and    $0xfffffc00,%eax
        generation = 1 << ENVGENSHIFT;
f010341c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103421:	0f 4e c2             	cmovle %edx,%eax
    e->env_id = generation | (e - envs);
f0103424:	89 da                	mov    %ebx,%edx
f0103426:	2b 15 4c c2 22 f0    	sub    0xf022c24c,%edx
f010342c:	c1 fa 02             	sar    $0x2,%edx
f010342f:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103435:	09 d0                	or     %edx,%eax
f0103437:	89 43 48             	mov    %eax,0x48(%ebx)
    e->env_parent_id = parent_id;
f010343a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010343d:	89 43 4c             	mov    %eax,0x4c(%ebx)
    e->env_type = ENV_TYPE_USER;
f0103440:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
    e->env_status = ENV_RUNNABLE;
f0103447:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
    e->env_runs = 0;
f010344e:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103455:	6a 44                	push   $0x44
f0103457:	6a 00                	push   $0x0
f0103459:	53                   	push   %ebx
f010345a:	e8 3b 1a 00 00       	call   f0104e9a <memset>
    e->env_tf.tf_ds = GD_UD | 3;
f010345f:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
    e->env_tf.tf_es = GD_UD | 3;
f0103465:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
    e->env_tf.tf_ss = GD_UD | 3;
f010346b:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
    e->env_tf.tf_esp = USTACKTOP;
f0103471:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
    e->env_tf.tf_cs = GD_UT | 3;
f0103478:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
    env_free_list = e->env_link;
f010347e:	8b 43 44             	mov    0x44(%ebx),%eax
f0103481:	a3 50 c2 22 f0       	mov    %eax,0xf022c250
    *newenv_store = e;
f0103486:	8b 45 08             	mov    0x8(%ebp),%eax
f0103489:	89 18                	mov    %ebx,(%eax)
    cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010348b:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010348e:	e8 2c 20 00 00       	call   f01054bf <cpunum>
f0103493:	6b c0 74             	imul   $0x74,%eax,%eax
f0103496:	83 c4 10             	add    $0x10,%esp
f0103499:	ba 00 00 00 00       	mov    $0x0,%edx
f010349e:	83 b8 28 d0 22 f0 00 	cmpl   $0x0,-0xfdd2fd8(%eax)
f01034a5:	74 11                	je     f01034b8 <env_alloc+0x1b1>
f01034a7:	e8 13 20 00 00       	call   f01054bf <cpunum>
f01034ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01034af:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f01034b5:	8b 50 48             	mov    0x48(%eax),%edx
f01034b8:	83 ec 04             	sub    $0x4,%esp
f01034bb:	53                   	push   %ebx
f01034bc:	52                   	push   %edx
f01034bd:	68 8d 72 10 f0       	push   $0xf010728d
f01034c2:	e8 69 06 00 00       	call   f0103b30 <cprintf>
    return 0;
f01034c7:	83 c4 10             	add    $0x10,%esp
f01034ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01034cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01034d2:	c9                   	leave  
f01034d3:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01034d4:	52                   	push   %edx
f01034d5:	68 24 5b 10 f0       	push   $0xf0105b24
f01034da:	6a 58                	push   $0x58
f01034dc:	68 02 6f 10 f0       	push   $0xf0106f02
f01034e1:	e8 5a cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034e6:	50                   	push   %eax
f01034e7:	68 48 5b 10 f0       	push   $0xf0105b48
f01034ec:	68 c9 00 00 00       	push   $0xc9
f01034f1:	68 82 72 10 f0       	push   $0xf0107282
f01034f6:	e8 45 cb ff ff       	call   f0100040 <_panic>
        return -E_NO_FREE_ENV;
f01034fb:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103500:	eb cd                	jmp    f01034cf <env_alloc+0x1c8>
        return -E_NO_MEM;
f0103502:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103507:	eb c6                	jmp    f01034cf <env_alloc+0x1c8>

f0103509 <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type) {
f0103509:	55                   	push   %ebp
f010350a:	89 e5                	mov    %esp,%ebp
f010350c:	57                   	push   %edi
f010350d:	56                   	push   %esi
f010350e:	53                   	push   %ebx
f010350f:	83 ec 38             	sub    $0x38,%esp
f0103512:	8b 75 08             	mov    0x8(%ebp),%esi
    cprintf("************* Now we create a env. **************\n");
f0103515:	68 48 74 10 f0       	push   $0xf0107448
f010351a:	e8 11 06 00 00       	call   f0103b30 <cprintf>
    // LAB 3: Your code here.
    struct Env *Env = NULL;
f010351f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    switch (env_alloc(&Env, 0)) {
f0103526:	83 c4 08             	add    $0x8,%esp
f0103529:	6a 00                	push   $0x0
f010352b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010352e:	50                   	push   %eax
f010352f:	e8 d3 fd ff ff       	call   f0103307 <env_alloc>
        default:
            //todo
            break;
    };

    load_icode(Env, binary);
f0103534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103537:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    cprintf("************* Now we load_icode about a env e. **************\n");
f010353a:	c7 04 24 7c 74 10 f0 	movl   $0xf010747c,(%esp)
f0103541:	e8 ea 05 00 00       	call   f0103b30 <cprintf>
    cprintf("************* Now we load each program segment. **************\n");
f0103546:	c7 04 24 bc 74 10 f0 	movl   $0xf01074bc,(%esp)
f010354d:	e8 de 05 00 00       	call   f0103b30 <cprintf>
    ph = (struct Proghdr *) (binary + elfHdr->e_phoff);
f0103552:	89 f3                	mov    %esi,%ebx
f0103554:	03 5e 1c             	add    0x1c(%esi),%ebx
    eph = ph + elfHdr->e_phnum;
f0103557:	0f b7 7e 2c          	movzwl 0x2c(%esi),%edi
f010355b:	c1 e7 05             	shl    $0x5,%edi
f010355e:	01 df                	add    %ebx,%edi
f0103560:	83 c4 10             	add    $0x10,%esp
f0103563:	eb 03                	jmp    f0103568 <env_create+0x5f>
    for (; ph < eph; ph++) {
f0103565:	83 c3 20             	add    $0x20,%ebx
f0103568:	39 df                	cmp    %ebx,%edi
f010356a:	76 3c                	jbe    f01035a8 <env_create+0x9f>
        if (ph->p_type == ELF_PROG_LOAD) {
f010356c:	83 3b 01             	cmpl   $0x1,(%ebx)
f010356f:	75 f4                	jne    f0103565 <env_create+0x5c>
            cprintf("ph->p_type:%x\t ph->p_offset:0x%x\t ph->p_va:0x%x\t ph->p_pa:0x%x\t ph->p_filesz:0x%x\t ph->p_memsz:0x%x\t ph->p_flags:%x\t ph->p_align:0x%x\t\n",
f0103571:	83 ec 0c             	sub    $0xc,%esp
f0103574:	ff 73 1c             	pushl  0x1c(%ebx)
f0103577:	ff 73 18             	pushl  0x18(%ebx)
f010357a:	ff 73 14             	pushl  0x14(%ebx)
f010357d:	ff 73 10             	pushl  0x10(%ebx)
f0103580:	ff 73 0c             	pushl  0xc(%ebx)
f0103583:	ff 73 08             	pushl  0x8(%ebx)
f0103586:	ff 73 04             	pushl  0x4(%ebx)
f0103589:	6a 01                	push   $0x1
f010358b:	68 fc 74 10 f0       	push   $0xf01074fc
f0103590:	e8 9b 05 00 00       	call   f0103b30 <cprintf>
            region_alloc(e, (void *) ph->p_va, ph->p_memsz);
f0103595:	83 c4 30             	add    $0x30,%esp
f0103598:	8b 4b 14             	mov    0x14(%ebx),%ecx
f010359b:	8b 53 08             	mov    0x8(%ebx),%edx
f010359e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035a1:	e8 00 fc ff ff       	call   f01031a6 <region_alloc>
f01035a6:	eb bd                	jmp    f0103565 <env_create+0x5c>
    cprintf("************* Now we copy each section which should load. **************\n");
f01035a8:	83 ec 0c             	sub    $0xc,%esp
f01035ab:	68 84 75 10 f0       	push   $0xf0107584
f01035b0:	e8 7b 05 00 00       	call   f0103b30 <cprintf>
    struct Secthdr *sectHdr = (struct Secthdr *) (binary + elfHdr->e_shoff);
f01035b5:	89 f3                	mov    %esi,%ebx
f01035b7:	03 5e 20             	add    0x20(%esi),%ebx
	asm volatile("movl %%cr3,%0" : "=r" (val));
f01035ba:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f01035bd:	83 c4 08             	add    $0x8,%esp
f01035c0:	50                   	push   %eax
f01035c1:	68 a2 72 10 f0       	push   $0xf01072a2
f01035c6:	e8 65 05 00 00       	call   f0103b30 <cprintf>
    lcr3(PADDR(e->env_pgdir));
f01035cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035ce:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035d1:	83 c4 10             	add    $0x10,%esp
f01035d4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035d9:	76 23                	jbe    f01035fe <env_create+0xf5>
	return (physaddr_t)kva - KERNBASE;
f01035db:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01035e0:	0f 22 d8             	mov    %eax,%cr3
	asm volatile("movl %%cr3,%0" : "=r" (val));
f01035e3:	0f 20 d8             	mov    %cr3,%eax
    cprintf("rcr3():0x%x\n", rcr3());
f01035e6:	83 ec 08             	sub    $0x8,%esp
f01035e9:	50                   	push   %eax
f01035ea:	68 a2 72 10 f0       	push   $0xf01072a2
f01035ef:	e8 3c 05 00 00       	call   f0103b30 <cprintf>
f01035f4:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f01035f7:	bf 00 00 00 00       	mov    $0x0,%edi
f01035fc:	eb 43                	jmp    f0103641 <env_create+0x138>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035fe:	50                   	push   %eax
f01035ff:	68 48 5b 10 f0       	push   $0xf0105b48
f0103604:	68 86 01 00 00       	push   $0x186
f0103609:	68 82 72 10 f0       	push   $0xf0107282
f010360e:	e8 2d ca ff ff       	call   f0100040 <_panic>
            cprintf("(void *) sectHdr->sh_addr:0x%x\tsectHdr->sh_offset:0x%x\tsectHdr->sh_size:0x%x\n", sectHdr->sh_addr, sectHdr->sh_offset, sectHdr->sh_size);
f0103613:	ff 73 14             	pushl  0x14(%ebx)
f0103616:	ff 73 10             	pushl  0x10(%ebx)
f0103619:	50                   	push   %eax
f010361a:	68 d0 75 10 f0       	push   $0xf01075d0
f010361f:	e8 0c 05 00 00       	call   f0103b30 <cprintf>
            memcpy((void *) sectHdr->sh_addr, binary + sectHdr->sh_offset, sectHdr->sh_size);
f0103624:	83 c4 0c             	add    $0xc,%esp
f0103627:	ff 73 14             	pushl  0x14(%ebx)
f010362a:	89 f0                	mov    %esi,%eax
f010362c:	03 43 10             	add    0x10(%ebx),%eax
f010362f:	50                   	push   %eax
f0103630:	ff 73 0c             	pushl  0xc(%ebx)
f0103633:	e8 17 19 00 00       	call   f0104f4f <memcpy>
f0103638:	83 c4 10             	add    $0x10,%esp
        sectHdr++;
f010363b:	83 c3 28             	add    $0x28,%ebx
    for (int i = 0; i < elfHdr->e_shnum; i++) {
f010363e:	83 c7 01             	add    $0x1,%edi
f0103641:	0f b7 46 30          	movzwl 0x30(%esi),%eax
f0103645:	39 c7                	cmp    %eax,%edi
f0103647:	7d 0f                	jge    f0103658 <env_create+0x14f>
        if (sectHdr->sh_addr != 0 && sectHdr->sh_type != ELF_SHT_NOBITS) {
f0103649:	8b 43 0c             	mov    0xc(%ebx),%eax
f010364c:	85 c0                	test   %eax,%eax
f010364e:	74 eb                	je     f010363b <env_create+0x132>
f0103650:	83 7b 04 08          	cmpl   $0x8,0x4(%ebx)
f0103654:	74 e5                	je     f010363b <env_create+0x132>
f0103656:	eb bb                	jmp    f0103613 <env_create+0x10a>
    lcr3(PADDR(kern_pgdir));
f0103658:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f010365d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103662:	76 43                	jbe    f01036a7 <env_create+0x19e>
	return (physaddr_t)kva - KERNBASE;
f0103664:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103669:	0f 22 d8             	mov    %eax,%cr3
    cprintf("************* Now we map one page for the program's initial stack. **************\n");
f010366c:	83 ec 0c             	sub    $0xc,%esp
f010366f:	68 20 76 10 f0       	push   $0xf0107620
f0103674:	e8 b7 04 00 00       	call   f0103b30 <cprintf>
    region_alloc(e, (void *) USTACKTOP - PGSIZE, PGSIZE);
f0103679:	b9 00 10 00 00       	mov    $0x1000,%ecx
f010367e:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103683:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103686:	89 f8                	mov    %edi,%eax
f0103688:	e8 19 fb ff ff       	call   f01031a6 <region_alloc>
    e->env_tf.tf_eip = elfHdr->e_entry;
f010368d:	8b 46 18             	mov    0x18(%esi),%eax
f0103690:	89 47 30             	mov    %eax,0x30(%edi)

    Env->env_type = type;
f0103693:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103699:	89 50 50             	mov    %edx,0x50(%eax)
}
f010369c:	83 c4 10             	add    $0x10,%esp
f010369f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01036a2:	5b                   	pop    %ebx
f01036a3:	5e                   	pop    %esi
f01036a4:	5f                   	pop    %edi
f01036a5:	5d                   	pop    %ebp
f01036a6:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036a7:	50                   	push   %eax
f01036a8:	68 48 5b 10 f0       	push   $0xf0105b48
f01036ad:	68 90 01 00 00       	push   $0x190
f01036b2:	68 82 72 10 f0       	push   $0xf0107282
f01036b7:	e8 84 c9 ff ff       	call   f0100040 <_panic>

f01036bc <env_free>:

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
f01036bc:	55                   	push   %ebp
f01036bd:	89 e5                	mov    %esp,%ebp
f01036bf:	57                   	push   %edi
f01036c0:	56                   	push   %esi
f01036c1:	53                   	push   %ebx
f01036c2:	83 ec 1c             	sub    $0x1c,%esp
    physaddr_t pa;

    // If freeing the current environment, switch to kern_pgdir
    // before freeing the page directory, just in case the page
    // gets reused.
    if (e == curenv)
f01036c5:	e8 f5 1d 00 00       	call   f01054bf <cpunum>
f01036ca:	6b c0 74             	imul   $0x74,%eax,%eax
f01036cd:	8b 55 08             	mov    0x8(%ebp),%edx
f01036d0:	39 90 28 d0 22 f0    	cmp    %edx,-0xfdd2fd8(%eax)
f01036d6:	75 14                	jne    f01036ec <env_free+0x30>
        lcr3(PADDR(kern_pgdir));
f01036d8:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f01036dd:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036e2:	76 56                	jbe    f010373a <env_free+0x7e>
	return (physaddr_t)kva - KERNBASE;
f01036e4:	05 00 00 00 10       	add    $0x10000000,%eax
f01036e9:	0f 22 d8             	mov    %eax,%cr3

    // Note the environment's demise.
    cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01036ec:	8b 45 08             	mov    0x8(%ebp),%eax
f01036ef:	8b 58 48             	mov    0x48(%eax),%ebx
f01036f2:	e8 c8 1d 00 00       	call   f01054bf <cpunum>
f01036f7:	6b c0 74             	imul   $0x74,%eax,%eax
f01036fa:	ba 00 00 00 00       	mov    $0x0,%edx
f01036ff:	83 b8 28 d0 22 f0 00 	cmpl   $0x0,-0xfdd2fd8(%eax)
f0103706:	74 11                	je     f0103719 <env_free+0x5d>
f0103708:	e8 b2 1d 00 00       	call   f01054bf <cpunum>
f010370d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103710:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f0103716:	8b 50 48             	mov    0x48(%eax),%edx
f0103719:	83 ec 04             	sub    $0x4,%esp
f010371c:	53                   	push   %ebx
f010371d:	52                   	push   %edx
f010371e:	68 af 72 10 f0       	push   $0xf01072af
f0103723:	e8 08 04 00 00       	call   f0103b30 <cprintf>
f0103728:	83 c4 10             	add    $0x10,%esp
f010372b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0103732:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103735:	e9 8f 00 00 00       	jmp    f01037c9 <env_free+0x10d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010373a:	50                   	push   %eax
f010373b:	68 48 5b 10 f0       	push   $0xf0105b48
f0103740:	68 c8 01 00 00       	push   $0x1c8
f0103745:	68 82 72 10 f0       	push   $0xf0107282
f010374a:	e8 f1 c8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010374f:	50                   	push   %eax
f0103750:	68 24 5b 10 f0       	push   $0xf0105b24
f0103755:	68 d7 01 00 00       	push   $0x1d7
f010375a:	68 82 72 10 f0       	push   $0xf0107282
f010375f:	e8 dc c8 ff ff       	call   f0100040 <_panic>
f0103764:	83 c3 04             	add    $0x4,%ebx
        // find the pa and va of the page table
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
        pt = (pte_t *) KADDR(pa);

        // unmap all PTEs in this page table
        for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103767:	39 f3                	cmp    %esi,%ebx
f0103769:	74 21                	je     f010378c <env_free+0xd0>
            if (pt[pteno] & PTE_P)
f010376b:	f6 03 01             	testb  $0x1,(%ebx)
f010376e:	74 f4                	je     f0103764 <env_free+0xa8>
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103770:	83 ec 08             	sub    $0x8,%esp
f0103773:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103776:	01 d8                	add    %ebx,%eax
f0103778:	c1 e0 0a             	shl    $0xa,%eax
f010377b:	0b 45 e4             	or     -0x1c(%ebp),%eax
f010377e:	50                   	push   %eax
f010377f:	ff 77 60             	pushl  0x60(%edi)
f0103782:	e8 89 da ff ff       	call   f0101210 <page_remove>
f0103787:	83 c4 10             	add    $0x10,%esp
f010378a:	eb d8                	jmp    f0103764 <env_free+0xa8>
        }

        // free the page table itself
        e->env_pgdir[pdeno] = 0;
f010378c:	8b 47 60             	mov    0x60(%edi),%eax
f010378f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103792:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103799:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010379c:	3b 05 0c cf 22 f0    	cmp    0xf022cf0c,%eax
f01037a2:	73 6a                	jae    f010380e <env_free+0x152>
        page_decref(pa2page(pa));
f01037a4:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01037a7:	a1 14 cf 22 f0       	mov    0xf022cf14,%eax
f01037ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01037af:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f01037b2:	50                   	push   %eax
f01037b3:	e8 f4 d8 ff ff       	call   f01010ac <page_decref>
f01037b8:	83 c4 10             	add    $0x10,%esp
f01037bb:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f01037bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
    for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01037c2:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01037c7:	74 59                	je     f0103822 <env_free+0x166>
        if (!(e->env_pgdir[pdeno] & PTE_P))
f01037c9:	8b 47 60             	mov    0x60(%edi),%eax
f01037cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037cf:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01037d2:	a8 01                	test   $0x1,%al
f01037d4:	74 e5                	je     f01037bb <env_free+0xff>
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01037d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01037db:	89 c2                	mov    %eax,%edx
f01037dd:	c1 ea 0c             	shr    $0xc,%edx
f01037e0:	89 55 d8             	mov    %edx,-0x28(%ebp)
f01037e3:	39 15 0c cf 22 f0    	cmp    %edx,0xf022cf0c
f01037e9:	0f 86 60 ff ff ff    	jbe    f010374f <env_free+0x93>
	return (void *)(pa + KERNBASE);
f01037ef:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01037f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037f8:	c1 e2 14             	shl    $0x14,%edx
f01037fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01037fe:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f0103804:	f7 d8                	neg    %eax
f0103806:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103809:	e9 5d ff ff ff       	jmp    f010376b <env_free+0xaf>
		panic("pa2page called with invalid pa");
f010380e:	83 ec 04             	sub    $0x4,%esp
f0103811:	68 b0 62 10 f0       	push   $0xf01062b0
f0103816:	6a 51                	push   $0x51
f0103818:	68 02 6f 10 f0       	push   $0xf0106f02
f010381d:	e8 1e c8 ff ff       	call   f0100040 <_panic>
    }

    // free the page directory
    pa = PADDR(e->env_pgdir);
f0103822:	8b 45 08             	mov    0x8(%ebp),%eax
f0103825:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103828:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010382d:	76 52                	jbe    f0103881 <env_free+0x1c5>
    e->env_pgdir = 0;
f010382f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103832:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f0103839:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f010383e:	c1 e8 0c             	shr    $0xc,%eax
f0103841:	3b 05 0c cf 22 f0    	cmp    0xf022cf0c,%eax
f0103847:	73 4d                	jae    f0103896 <env_free+0x1da>
    page_decref(pa2page(pa));
f0103849:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010384c:	8b 15 14 cf 22 f0    	mov    0xf022cf14,%edx
f0103852:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103855:	50                   	push   %eax
f0103856:	e8 51 d8 ff ff       	call   f01010ac <page_decref>

    // return the environment to the free list
    e->env_status = ENV_FREE;
f010385b:	8b 45 08             	mov    0x8(%ebp),%eax
f010385e:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
    e->env_link = env_free_list;
f0103865:	a1 50 c2 22 f0       	mov    0xf022c250,%eax
f010386a:	8b 55 08             	mov    0x8(%ebp),%edx
f010386d:	89 42 44             	mov    %eax,0x44(%edx)
    env_free_list = e;
f0103870:	89 15 50 c2 22 f0    	mov    %edx,0xf022c250
}
f0103876:	83 c4 10             	add    $0x10,%esp
f0103879:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010387c:	5b                   	pop    %ebx
f010387d:	5e                   	pop    %esi
f010387e:	5f                   	pop    %edi
f010387f:	5d                   	pop    %ebp
f0103880:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103881:	50                   	push   %eax
f0103882:	68 48 5b 10 f0       	push   $0xf0105b48
f0103887:	68 e5 01 00 00       	push   $0x1e5
f010388c:	68 82 72 10 f0       	push   $0xf0107282
f0103891:	e8 aa c7 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103896:	83 ec 04             	sub    $0x4,%esp
f0103899:	68 b0 62 10 f0       	push   $0xf01062b0
f010389e:	6a 51                	push   $0x51
f01038a0:	68 02 6f 10 f0       	push   $0xf0106f02
f01038a5:	e8 96 c7 ff ff       	call   f0100040 <_panic>

f01038aa <env_destroy>:

//
// Frees environment e.
//
void
env_destroy(struct Env *e) {
f01038aa:	55                   	push   %ebp
f01038ab:	89 e5                	mov    %esp,%ebp
f01038ad:	83 ec 14             	sub    $0x14,%esp
    env_free(e);
f01038b0:	ff 75 08             	pushl  0x8(%ebp)
f01038b3:	e8 04 fe ff ff       	call   f01036bc <env_free>

    cprintf("Destroyed the only environment - nothing more to do!\n");
f01038b8:	c7 04 24 74 76 10 f0 	movl   $0xf0107674,(%esp)
f01038bf:	e8 6c 02 00 00       	call   f0103b30 <cprintf>
f01038c4:	83 c4 10             	add    $0x10,%esp
    while (1)
        monitor(NULL);
f01038c7:	83 ec 0c             	sub    $0xc,%esp
f01038ca:	6a 00                	push   $0x0
f01038cc:	e8 09 d0 ff ff       	call   f01008da <monitor>
f01038d1:	83 c4 10             	add    $0x10,%esp
f01038d4:	eb f1                	jmp    f01038c7 <env_destroy+0x1d>

f01038d6 <env_pop_tf>:
// this exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
f01038d6:	55                   	push   %ebp
f01038d7:	89 e5                	mov    %esp,%ebp
f01038d9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile(
f01038dc:	8b 65 08             	mov    0x8(%ebp),%esp
f01038df:	61                   	popa   
f01038e0:	07                   	pop    %es
f01038e1:	1f                   	pop    %ds
f01038e2:	83 c4 08             	add    $0x8,%esp
f01038e5:	cf                   	iret   
    "\tpopl %%es\n"
    "\tpopl %%ds\n"
    "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
    "\tiret\n"
    : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
f01038e6:	68 c5 72 10 f0       	push   $0xf01072c5
f01038eb:	68 0c 02 00 00       	push   $0x20c
f01038f0:	68 82 72 10 f0       	push   $0xf0107282
f01038f5:	e8 46 c7 ff ff       	call   f0100040 <_panic>

f01038fa <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
f01038fa:	55                   	push   %ebp
f01038fb:	89 e5                	mov    %esp,%ebp
f01038fd:	53                   	push   %ebx
f01038fe:	83 ec 10             	sub    $0x10,%esp
f0103901:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("************* Now we run a env. **************\n");
f0103904:	68 ac 76 10 f0       	push   $0xf01076ac
f0103909:	e8 22 02 00 00       	call   f0103b30 <cprintf>
    //	e->env_tf.  Go back through the code you wrote above
    //	and make sure you have set the relevant parts of
    //	e->env_tf to sensible values.

    // LAB 3: Your code here.
    if (curenv != NULL) {
f010390e:	e8 ac 1b 00 00       	call   f01054bf <cpunum>
f0103913:	6b c0 74             	imul   $0x74,%eax,%eax
f0103916:	83 c4 10             	add    $0x10,%esp
f0103919:	83 b8 28 d0 22 f0 00 	cmpl   $0x0,-0xfdd2fd8(%eax)
f0103920:	74 14                	je     f0103936 <env_run+0x3c>
        if (curenv->env_status == ENV_RUNNING) {
f0103922:	e8 98 1b 00 00       	call   f01054bf <cpunum>
f0103927:	6b c0 74             	imul   $0x74,%eax,%eax
f010392a:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f0103930:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103934:	74 38                	je     f010396e <env_run+0x74>
            curenv->env_status = ENV_RUNNABLE;
        }
    }

    curenv = e;
f0103936:	e8 84 1b 00 00       	call   f01054bf <cpunum>
f010393b:	6b c0 74             	imul   $0x74,%eax,%eax
f010393e:	89 98 28 d0 22 f0    	mov    %ebx,-0xfdd2fd8(%eax)
    //?????????????????????????????????why this fault?
//    e->env_status = ENV_RUNNABLE;
    e->env_status = ENV_RUNNING;
f0103944:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
    e->env_runs++;
f010394b:	83 43 58 01          	addl   $0x1,0x58(%ebx)

    lcr3(PADDR(e->env_pgdir));
f010394f:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103952:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103957:	77 2c                	ja     f0103985 <env_run+0x8b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103959:	50                   	push   %eax
f010395a:	68 48 5b 10 f0       	push   $0xf0105b48
f010395f:	68 36 02 00 00       	push   $0x236
f0103964:	68 82 72 10 f0       	push   $0xf0107282
f0103969:	e8 d2 c6 ff ff       	call   f0100040 <_panic>
            curenv->env_status = ENV_RUNNABLE;
f010396e:	e8 4c 1b 00 00       	call   f01054bf <cpunum>
f0103973:	6b c0 74             	imul   $0x74,%eax,%eax
f0103976:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f010397c:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103983:	eb b1                	jmp    f0103936 <env_run+0x3c>
	return (physaddr_t)kva - KERNBASE;
f0103985:	05 00 00 00 10       	add    $0x10000000,%eax
f010398a:	0f 22 d8             	mov    %eax,%cr3

    cprintf("e->env_tf.tf_cs:0x%x\n", e->env_tf.tf_cs);
f010398d:	83 ec 08             	sub    $0x8,%esp
f0103990:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103994:	50                   	push   %eax
f0103995:	68 d1 72 10 f0       	push   $0xf01072d1
f010399a:	e8 91 01 00 00       	call   f0103b30 <cprintf>
    env_pop_tf(&e->env_tf);
f010399f:	89 1c 24             	mov    %ebx,(%esp)
f01039a2:	e8 2f ff ff ff       	call   f01038d6 <env_pop_tf>

f01039a7 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01039a7:	55                   	push   %ebp
f01039a8:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01039aa:	8b 45 08             	mov    0x8(%ebp),%eax
f01039ad:	ba 70 00 00 00       	mov    $0x70,%edx
f01039b2:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01039b3:	ba 71 00 00 00       	mov    $0x71,%edx
f01039b8:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01039b9:	0f b6 c0             	movzbl %al,%eax
}
f01039bc:	5d                   	pop    %ebp
f01039bd:	c3                   	ret    

f01039be <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01039be:	55                   	push   %ebp
f01039bf:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01039c1:	8b 45 08             	mov    0x8(%ebp),%eax
f01039c4:	ba 70 00 00 00       	mov    $0x70,%edx
f01039c9:	ee                   	out    %al,(%dx)
f01039ca:	8b 45 0c             	mov    0xc(%ebp),%eax
f01039cd:	ba 71 00 00 00       	mov    $0x71,%edx
f01039d2:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01039d3:	5d                   	pop    %ebp
f01039d4:	c3                   	ret    

f01039d5 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01039d5:	55                   	push   %ebp
f01039d6:	89 e5                	mov    %esp,%ebp
f01039d8:	56                   	push   %esi
f01039d9:	53                   	push   %ebx
f01039da:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01039dd:	66 a3 70 13 12 f0    	mov    %ax,0xf0121370
	if (!didinit)
f01039e3:	80 3d 54 c2 22 f0 00 	cmpb   $0x0,0xf022c254
f01039ea:	75 07                	jne    f01039f3 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01039ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01039ef:	5b                   	pop    %ebx
f01039f0:	5e                   	pop    %esi
f01039f1:	5d                   	pop    %ebp
f01039f2:	c3                   	ret    
f01039f3:	89 c6                	mov    %eax,%esi
f01039f5:	ba 21 00 00 00       	mov    $0x21,%edx
f01039fa:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01039fb:	66 c1 e8 08          	shr    $0x8,%ax
f01039ff:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103a04:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103a05:	83 ec 0c             	sub    $0xc,%esp
f0103a08:	68 dc 76 10 f0       	push   $0xf01076dc
f0103a0d:	e8 1e 01 00 00       	call   f0103b30 <cprintf>
f0103a12:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103a15:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103a1a:	0f b7 f6             	movzwl %si,%esi
f0103a1d:	f7 d6                	not    %esi
f0103a1f:	eb 08                	jmp    f0103a29 <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f0103a21:	83 c3 01             	add    $0x1,%ebx
f0103a24:	83 fb 10             	cmp    $0x10,%ebx
f0103a27:	74 18                	je     f0103a41 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103a29:	0f a3 de             	bt     %ebx,%esi
f0103a2c:	73 f3                	jae    f0103a21 <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f0103a2e:	83 ec 08             	sub    $0x8,%esp
f0103a31:	53                   	push   %ebx
f0103a32:	68 23 7e 10 f0       	push   $0xf0107e23
f0103a37:	e8 f4 00 00 00       	call   f0103b30 <cprintf>
f0103a3c:	83 c4 10             	add    $0x10,%esp
f0103a3f:	eb e0                	jmp    f0103a21 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103a41:	83 ec 0c             	sub    $0xc,%esp
f0103a44:	68 26 72 10 f0       	push   $0xf0107226
f0103a49:	e8 e2 00 00 00       	call   f0103b30 <cprintf>
f0103a4e:	83 c4 10             	add    $0x10,%esp
f0103a51:	eb 99                	jmp    f01039ec <irq_setmask_8259A+0x17>

f0103a53 <pic_init>:
{
f0103a53:	55                   	push   %ebp
f0103a54:	89 e5                	mov    %esp,%ebp
f0103a56:	57                   	push   %edi
f0103a57:	56                   	push   %esi
f0103a58:	53                   	push   %ebx
f0103a59:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103a5c:	c6 05 54 c2 22 f0 01 	movb   $0x1,0xf022c254
f0103a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103a68:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103a6d:	89 da                	mov    %ebx,%edx
f0103a6f:	ee                   	out    %al,(%dx)
f0103a70:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103a75:	89 ca                	mov    %ecx,%edx
f0103a77:	ee                   	out    %al,(%dx)
f0103a78:	bf 11 00 00 00       	mov    $0x11,%edi
f0103a7d:	be 20 00 00 00       	mov    $0x20,%esi
f0103a82:	89 f8                	mov    %edi,%eax
f0103a84:	89 f2                	mov    %esi,%edx
f0103a86:	ee                   	out    %al,(%dx)
f0103a87:	b8 20 00 00 00       	mov    $0x20,%eax
f0103a8c:	89 da                	mov    %ebx,%edx
f0103a8e:	ee                   	out    %al,(%dx)
f0103a8f:	b8 04 00 00 00       	mov    $0x4,%eax
f0103a94:	ee                   	out    %al,(%dx)
f0103a95:	b8 03 00 00 00       	mov    $0x3,%eax
f0103a9a:	ee                   	out    %al,(%dx)
f0103a9b:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103aa0:	89 f8                	mov    %edi,%eax
f0103aa2:	89 da                	mov    %ebx,%edx
f0103aa4:	ee                   	out    %al,(%dx)
f0103aa5:	b8 28 00 00 00       	mov    $0x28,%eax
f0103aaa:	89 ca                	mov    %ecx,%edx
f0103aac:	ee                   	out    %al,(%dx)
f0103aad:	b8 02 00 00 00       	mov    $0x2,%eax
f0103ab2:	ee                   	out    %al,(%dx)
f0103ab3:	b8 01 00 00 00       	mov    $0x1,%eax
f0103ab8:	ee                   	out    %al,(%dx)
f0103ab9:	bf 68 00 00 00       	mov    $0x68,%edi
f0103abe:	89 f8                	mov    %edi,%eax
f0103ac0:	89 f2                	mov    %esi,%edx
f0103ac2:	ee                   	out    %al,(%dx)
f0103ac3:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103ac8:	89 c8                	mov    %ecx,%eax
f0103aca:	ee                   	out    %al,(%dx)
f0103acb:	89 f8                	mov    %edi,%eax
f0103acd:	89 da                	mov    %ebx,%edx
f0103acf:	ee                   	out    %al,(%dx)
f0103ad0:	89 c8                	mov    %ecx,%eax
f0103ad2:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103ad3:	0f b7 05 70 13 12 f0 	movzwl 0xf0121370,%eax
f0103ada:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103ade:	74 0f                	je     f0103aef <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f0103ae0:	83 ec 0c             	sub    $0xc,%esp
f0103ae3:	0f b7 c0             	movzwl %ax,%eax
f0103ae6:	50                   	push   %eax
f0103ae7:	e8 e9 fe ff ff       	call   f01039d5 <irq_setmask_8259A>
f0103aec:	83 c4 10             	add    $0x10,%esp
}
f0103aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103af2:	5b                   	pop    %ebx
f0103af3:	5e                   	pop    %esi
f0103af4:	5f                   	pop    %edi
f0103af5:	5d                   	pop    %ebp
f0103af6:	c3                   	ret    

f0103af7 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103af7:	55                   	push   %ebp
f0103af8:	89 e5                	mov    %esp,%ebp
f0103afa:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103afd:	ff 75 08             	pushl  0x8(%ebp)
f0103b00:	e8 50 cc ff ff       	call   f0100755 <cputchar>
    //这里会有bug！
	*cnt++;
}
f0103b05:	83 c4 10             	add    $0x10,%esp
f0103b08:	c9                   	leave  
f0103b09:	c3                   	ret    

f0103b0a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103b0a:	55                   	push   %ebp
f0103b0b:	89 e5                	mov    %esp,%ebp
f0103b0d:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103b10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103b17:	ff 75 0c             	pushl  0xc(%ebp)
f0103b1a:	ff 75 08             	pushl  0x8(%ebp)
f0103b1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103b20:	50                   	push   %eax
f0103b21:	68 f7 3a 10 f0       	push   $0xf0103af7
f0103b26:	e8 eb 0b 00 00       	call   f0104716 <vprintfmt>
	return cnt;
}
f0103b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103b2e:	c9                   	leave  
f0103b2f:	c3                   	ret    

f0103b30 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103b30:	55                   	push   %ebp
f0103b31:	89 e5                	mov    %esp,%ebp
f0103b33:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103b36:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103b39:	50                   	push   %eax
f0103b3a:	ff 75 08             	pushl  0x8(%ebp)
f0103b3d:	e8 c8 ff ff ff       	call   f0103b0a <vcprintf>
	va_end(ap);

	return cnt;
}
f0103b42:	c9                   	leave  
f0103b43:	c3                   	ret    

f0103b44 <memCprintf>:

//不能重载？？
int memCprintf(const char *name, uintptr_t va, uint32_t pd_item, physaddr_t pa, uint32_t map_page){
f0103b44:	55                   	push   %ebp
f0103b45:	89 e5                	mov    %esp,%ebp
f0103b47:	83 ec 10             	sub    $0x10,%esp
    return cprintf("名称:%s\t虚拟地址:0x%x\t页目录项:0x%x\t物理地址:0x%x\t物理页:0x%x\n", name, va, pd_item, pa, map_page);
f0103b4a:	ff 75 18             	pushl  0x18(%ebp)
f0103b4d:	ff 75 14             	pushl  0x14(%ebp)
f0103b50:	ff 75 10             	pushl  0x10(%ebp)
f0103b53:	ff 75 0c             	pushl  0xc(%ebp)
f0103b56:	ff 75 08             	pushl  0x8(%ebp)
f0103b59:	68 f0 76 10 f0       	push   $0xf01076f0
f0103b5e:	e8 cd ff ff ff       	call   f0103b30 <cprintf>
}
f0103b63:	c9                   	leave  
f0103b64:	c3                   	ret    

f0103b65 <trap_init_percpu>:
    trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void) {
f0103b65:	55                   	push   %ebp
f0103b66:	89 e5                	mov    %esp,%ebp
f0103b68:	53                   	push   %ebx
f0103b69:	83 ec 0c             	sub    $0xc,%esp
    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    ts.ts_esp0 = KSTACKTOP;
f0103b6c:	bb 80 ca 22 f0       	mov    $0xf022ca80,%ebx
f0103b71:	c7 05 84 ca 22 f0 00 	movl   $0xf0000000,0xf022ca84
f0103b78:	00 00 f0 
    ts.ts_ss0 = GD_KD;
f0103b7b:	66 c7 05 88 ca 22 f0 	movw   $0x10,0xf022ca88
f0103b82:	10 00 
    ts.ts_iomb = sizeof(struct Taskstate);
f0103b84:	66 c7 05 e6 ca 22 f0 	movw   $0x68,0xf022cae6
f0103b8b:	68 00 

    // Initialize the TSS slot of the gdt.
    cprintf("&ts:0x%x\n", &ts);
f0103b8d:	53                   	push   %ebx
f0103b8e:	68 40 77 10 f0       	push   $0xf0107740
f0103b93:	e8 98 ff ff ff       	call   f0103b30 <cprintf>
    gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103b98:	66 c7 05 68 13 12 f0 	movw   $0x67,0xf0121368
f0103b9f:	67 00 
f0103ba1:	66 89 1d 6a 13 12 f0 	mov    %bx,0xf012136a
f0103ba8:	89 d8                	mov    %ebx,%eax
f0103baa:	c1 e8 10             	shr    $0x10,%eax
f0103bad:	a2 6c 13 12 f0       	mov    %al,0xf012136c
f0103bb2:	c6 05 6e 13 12 f0 40 	movb   $0x40,0xf012136e
f0103bb9:	c1 eb 18             	shr    $0x18,%ebx
f0103bbc:	88 1d 6f 13 12 f0    	mov    %bl,0xf012136f
                              sizeof(struct Taskstate) - 1, 0);
    gdt[GD_TSS0 >> 3].sd_s = 0;
f0103bc2:	c6 05 6d 13 12 f0 89 	movb   $0x89,0xf012136d
	asm volatile("ltr %0" : : "r" (sel));
f0103bc9:	b8 28 00 00 00       	mov    $0x28,%eax
f0103bce:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103bd1:	b8 74 13 12 f0       	mov    $0xf0121374,%eax
f0103bd6:	0f 01 18             	lidtl  (%eax)
    // bottom three bits are special; we leave them 0)
    ltr(GD_TSS0);

    // Load the IDT
    lidt(&idt_pd);
}
f0103bd9:	83 c4 10             	add    $0x10,%esp
f0103bdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103bdf:	c9                   	leave  
f0103be0:	c3                   	ret    

f0103be1 <trap_init>:
trap_init(void) {
f0103be1:	55                   	push   %ebp
f0103be2:	89 e5                	mov    %esp,%ebp
f0103be4:	57                   	push   %edi
f0103be5:	56                   	push   %esi
f0103be6:	53                   	push   %ebx
f0103be7:	83 ec 5c             	sub    $0x5c,%esp
    char *handler[] = {handler0, handler1, handler2, handler3, handler4, handler5, handler6, handler7, handler8,
f0103bea:	8d 7d 98             	lea    -0x68(%ebp),%edi
f0103bed:	be 40 7b 10 f0       	mov    $0xf0107b40,%esi
f0103bf2:	b9 14 00 00 00       	mov    $0x14,%ecx
f0103bf7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (int i = 0; i < 20; i++) {
f0103bf9:	bb 00 00 00 00       	mov    $0x0,%ebx
            SETGATE(idt[i], 1, GD_KT, handler[i], 0);
f0103bfe:	8b 44 9d 98          	mov    -0x68(%ebp,%ebx,4),%eax
f0103c02:	66 89 04 dd 60 c2 22 	mov    %ax,-0xfdd3da0(,%ebx,8)
f0103c09:	f0 
f0103c0a:	66 c7 04 dd 62 c2 22 	movw   $0x8,-0xfdd3d9e(,%ebx,8)
f0103c11:	f0 08 00 
f0103c14:	c6 04 dd 64 c2 22 f0 	movb   $0x0,-0xfdd3d9c(,%ebx,8)
f0103c1b:	00 
f0103c1c:	c6 04 dd 65 c2 22 f0 	movb   $0x8f,-0xfdd3d9b(,%ebx,8)
f0103c23:	8f 
f0103c24:	c1 e8 10             	shr    $0x10,%eax
f0103c27:	66 89 04 dd 66 c2 22 	mov    %ax,-0xfdd3d9a(,%ebx,8)
f0103c2e:	f0 
        cprintf("idt[%d]\toff:0x%x\n", i, (idt[i].gd_off_31_16 << 16) + idt[i].gd_off_15_0);
f0103c2f:	be 60 c2 22 f0       	mov    $0xf022c260,%esi
f0103c34:	83 ec 04             	sub    $0x4,%esp
f0103c37:	0f b7 44 de 06       	movzwl 0x6(%esi,%ebx,8),%eax
f0103c3c:	c1 e0 10             	shl    $0x10,%eax
f0103c3f:	0f b7 14 de          	movzwl (%esi,%ebx,8),%edx
f0103c43:	01 d0                	add    %edx,%eax
f0103c45:	50                   	push   %eax
f0103c46:	53                   	push   %ebx
f0103c47:	68 4a 77 10 f0       	push   $0xf010774a
f0103c4c:	e8 df fe ff ff       	call   f0103b30 <cprintf>
    for (int i = 0; i < 20; i++) {
f0103c51:	83 c3 01             	add    $0x1,%ebx
f0103c54:	83 c4 10             	add    $0x10,%esp
f0103c57:	83 fb 13             	cmp    $0x13,%ebx
f0103c5a:	7f 29                	jg     f0103c85 <trap_init+0xa4>
        if (i == T_BRKPT) {
f0103c5c:	83 fb 03             	cmp    $0x3,%ebx
f0103c5f:	75 9d                	jne    f0103bfe <trap_init+0x1d>
            SETGATE(idt[i], 1, GD_KT, handler[i], 3);
f0103c61:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0103c64:	66 89 46 18          	mov    %ax,0x18(%esi)
f0103c68:	66 c7 46 1a 08 00    	movw   $0x8,0x1a(%esi)
f0103c6e:	c6 05 7c c2 22 f0 00 	movb   $0x0,0xf022c27c
f0103c75:	c6 05 7d c2 22 f0 ef 	movb   $0xef,0xf022c27d
f0103c7c:	c1 e8 10             	shr    $0x10,%eax
f0103c7f:	66 89 46 1e          	mov    %ax,0x1e(%esi)
f0103c83:	eb af                	jmp    f0103c34 <trap_init+0x53>
    SETGATE(idt[T_SYSCALL], 1, GD_KT, handler48, 3);
f0103c85:	b8 02 42 10 f0       	mov    $0xf0104202,%eax
f0103c8a:	66 a3 e0 c3 22 f0    	mov    %ax,0xf022c3e0
f0103c90:	66 c7 05 e2 c3 22 f0 	movw   $0x8,0xf022c3e2
f0103c97:	08 00 
f0103c99:	c6 05 e4 c3 22 f0 00 	movb   $0x0,0xf022c3e4
f0103ca0:	c6 05 e5 c3 22 f0 ef 	movb   $0xef,0xf022c3e5
f0103ca7:	c1 e8 10             	shr    $0x10,%eax
f0103caa:	66 a3 e6 c3 22 f0    	mov    %ax,0xf022c3e6
    trap_init_percpu();
f0103cb0:	e8 b0 fe ff ff       	call   f0103b65 <trap_init_percpu>
}
f0103cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103cb8:	5b                   	pop    %ebx
f0103cb9:	5e                   	pop    %esi
f0103cba:	5f                   	pop    %edi
f0103cbb:	5d                   	pop    %ebp
f0103cbc:	c3                   	ret    

f0103cbd <print_regs>:
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
    }
}

void
print_regs(struct PushRegs *regs) {
f0103cbd:	55                   	push   %ebp
f0103cbe:	89 e5                	mov    %esp,%ebp
f0103cc0:	53                   	push   %ebx
f0103cc1:	83 ec 0c             	sub    $0xc,%esp
f0103cc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103cc7:	ff 33                	pushl  (%ebx)
f0103cc9:	68 5c 77 10 f0       	push   $0xf010775c
f0103cce:	e8 5d fe ff ff       	call   f0103b30 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103cd3:	83 c4 08             	add    $0x8,%esp
f0103cd6:	ff 73 04             	pushl  0x4(%ebx)
f0103cd9:	68 6b 77 10 f0       	push   $0xf010776b
f0103cde:	e8 4d fe ff ff       	call   f0103b30 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103ce3:	83 c4 08             	add    $0x8,%esp
f0103ce6:	ff 73 08             	pushl  0x8(%ebx)
f0103ce9:	68 7a 77 10 f0       	push   $0xf010777a
f0103cee:	e8 3d fe ff ff       	call   f0103b30 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103cf3:	83 c4 08             	add    $0x8,%esp
f0103cf6:	ff 73 0c             	pushl  0xc(%ebx)
f0103cf9:	68 89 77 10 f0       	push   $0xf0107789
f0103cfe:	e8 2d fe ff ff       	call   f0103b30 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103d03:	83 c4 08             	add    $0x8,%esp
f0103d06:	ff 73 10             	pushl  0x10(%ebx)
f0103d09:	68 98 77 10 f0       	push   $0xf0107798
f0103d0e:	e8 1d fe ff ff       	call   f0103b30 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103d13:	83 c4 08             	add    $0x8,%esp
f0103d16:	ff 73 14             	pushl  0x14(%ebx)
f0103d19:	68 a7 77 10 f0       	push   $0xf01077a7
f0103d1e:	e8 0d fe ff ff       	call   f0103b30 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103d23:	83 c4 08             	add    $0x8,%esp
f0103d26:	ff 73 18             	pushl  0x18(%ebx)
f0103d29:	68 b6 77 10 f0       	push   $0xf01077b6
f0103d2e:	e8 fd fd ff ff       	call   f0103b30 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103d33:	83 c4 08             	add    $0x8,%esp
f0103d36:	ff 73 1c             	pushl  0x1c(%ebx)
f0103d39:	68 c5 77 10 f0       	push   $0xf01077c5
f0103d3e:	e8 ed fd ff ff       	call   f0103b30 <cprintf>
}
f0103d43:	83 c4 10             	add    $0x10,%esp
f0103d46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103d49:	c9                   	leave  
f0103d4a:	c3                   	ret    

f0103d4b <print_trapframe>:
print_trapframe(struct Trapframe *tf) {
f0103d4b:	55                   	push   %ebp
f0103d4c:	89 e5                	mov    %esp,%ebp
f0103d4e:	56                   	push   %esi
f0103d4f:	53                   	push   %ebx
f0103d50:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("TRAP frame at %p\n", tf);
f0103d53:	83 ec 08             	sub    $0x8,%esp
f0103d56:	53                   	push   %ebx
f0103d57:	68 fb 78 10 f0       	push   $0xf01078fb
f0103d5c:	e8 cf fd ff ff       	call   f0103b30 <cprintf>
    print_regs(&tf->tf_regs);
f0103d61:	89 1c 24             	mov    %ebx,(%esp)
f0103d64:	e8 54 ff ff ff       	call   f0103cbd <print_regs>
    cprintf("  es   0x----%04x\n", tf->tf_es);
f0103d69:	83 c4 08             	add    $0x8,%esp
f0103d6c:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103d70:	50                   	push   %eax
f0103d71:	68 16 78 10 f0       	push   $0xf0107816
f0103d76:	e8 b5 fd ff ff       	call   f0103b30 <cprintf>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103d7b:	83 c4 08             	add    $0x8,%esp
f0103d7e:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103d82:	50                   	push   %eax
f0103d83:	68 29 78 10 f0       	push   $0xf0107829
f0103d88:	e8 a3 fd ff ff       	call   f0103b30 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103d8d:	8b 43 28             	mov    0x28(%ebx),%eax
    if (trapno < ARRAY_SIZE(excnames))
f0103d90:	83 c4 10             	add    $0x10,%esp
f0103d93:	83 f8 13             	cmp    $0x13,%eax
f0103d96:	0f 86 d4 00 00 00    	jbe    f0103e70 <print_trapframe+0x125>
    return "(unknown trap)";
f0103d9c:	83 f8 30             	cmp    $0x30,%eax
f0103d9f:	ba d4 77 10 f0       	mov    $0xf01077d4,%edx
f0103da4:	b9 e0 77 10 f0       	mov    $0xf01077e0,%ecx
f0103da9:	0f 45 d1             	cmovne %ecx,%edx
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103dac:	83 ec 04             	sub    $0x4,%esp
f0103daf:	52                   	push   %edx
f0103db0:	50                   	push   %eax
f0103db1:	68 3c 78 10 f0       	push   $0xf010783c
f0103db6:	e8 75 fd ff ff       	call   f0103b30 <cprintf>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103dbb:	83 c4 10             	add    $0x10,%esp
f0103dbe:	39 1d 60 ca 22 f0    	cmp    %ebx,0xf022ca60
f0103dc4:	0f 84 b2 00 00 00    	je     f0103e7c <print_trapframe+0x131>
    cprintf("  err  0x%08x", tf->tf_err);
f0103dca:	83 ec 08             	sub    $0x8,%esp
f0103dcd:	ff 73 2c             	pushl  0x2c(%ebx)
f0103dd0:	68 5d 78 10 f0       	push   $0xf010785d
f0103dd5:	e8 56 fd ff ff       	call   f0103b30 <cprintf>
    if (tf->tf_trapno == T_PGFLT)
f0103dda:	83 c4 10             	add    $0x10,%esp
f0103ddd:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103de1:	0f 85 b8 00 00 00    	jne    f0103e9f <print_trapframe+0x154>
                tf->tf_err & 1 ? "protection" : "not-present");
f0103de7:	8b 43 2c             	mov    0x2c(%ebx),%eax
        cprintf(" [%s, %s, %s]\n",
f0103dea:	89 c2                	mov    %eax,%edx
f0103dec:	83 e2 01             	and    $0x1,%edx
f0103def:	b9 ef 77 10 f0       	mov    $0xf01077ef,%ecx
f0103df4:	ba fa 77 10 f0       	mov    $0xf01077fa,%edx
f0103df9:	0f 44 ca             	cmove  %edx,%ecx
f0103dfc:	89 c2                	mov    %eax,%edx
f0103dfe:	83 e2 02             	and    $0x2,%edx
f0103e01:	be 06 78 10 f0       	mov    $0xf0107806,%esi
f0103e06:	ba 0c 78 10 f0       	mov    $0xf010780c,%edx
f0103e0b:	0f 45 d6             	cmovne %esi,%edx
f0103e0e:	83 e0 04             	and    $0x4,%eax
f0103e11:	b8 11 78 10 f0       	mov    $0xf0107811,%eax
f0103e16:	be f4 79 10 f0       	mov    $0xf01079f4,%esi
f0103e1b:	0f 44 c6             	cmove  %esi,%eax
f0103e1e:	51                   	push   %ecx
f0103e1f:	52                   	push   %edx
f0103e20:	50                   	push   %eax
f0103e21:	68 6b 78 10 f0       	push   $0xf010786b
f0103e26:	e8 05 fd ff ff       	call   f0103b30 <cprintf>
f0103e2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103e2e:	83 ec 08             	sub    $0x8,%esp
f0103e31:	ff 73 30             	pushl  0x30(%ebx)
f0103e34:	68 7a 78 10 f0       	push   $0xf010787a
f0103e39:	e8 f2 fc ff ff       	call   f0103b30 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103e3e:	83 c4 08             	add    $0x8,%esp
f0103e41:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103e45:	50                   	push   %eax
f0103e46:	68 89 78 10 f0       	push   $0xf0107889
f0103e4b:	e8 e0 fc ff ff       	call   f0103b30 <cprintf>
    cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103e50:	83 c4 08             	add    $0x8,%esp
f0103e53:	ff 73 38             	pushl  0x38(%ebx)
f0103e56:	68 9c 78 10 f0       	push   $0xf010789c
f0103e5b:	e8 d0 fc ff ff       	call   f0103b30 <cprintf>
    if ((tf->tf_cs & 3) != 0) {
f0103e60:	83 c4 10             	add    $0x10,%esp
f0103e63:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103e67:	75 4b                	jne    f0103eb4 <print_trapframe+0x169>
}
f0103e69:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103e6c:	5b                   	pop    %ebx
f0103e6d:	5e                   	pop    %esi
f0103e6e:	5d                   	pop    %ebp
f0103e6f:	c3                   	ret    
        return excnames[trapno];
f0103e70:	8b 14 85 60 7c 10 f0 	mov    -0xfef83a0(,%eax,4),%edx
f0103e77:	e9 30 ff ff ff       	jmp    f0103dac <print_trapframe+0x61>
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103e7c:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103e80:	0f 85 44 ff ff ff    	jne    f0103dca <print_trapframe+0x7f>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103e86:	0f 20 d0             	mov    %cr2,%eax
        cprintf("  cr2  0x%08x\n", rcr2());
f0103e89:	83 ec 08             	sub    $0x8,%esp
f0103e8c:	50                   	push   %eax
f0103e8d:	68 4e 78 10 f0       	push   $0xf010784e
f0103e92:	e8 99 fc ff ff       	call   f0103b30 <cprintf>
f0103e97:	83 c4 10             	add    $0x10,%esp
f0103e9a:	e9 2b ff ff ff       	jmp    f0103dca <print_trapframe+0x7f>
        cprintf("\n");
f0103e9f:	83 ec 0c             	sub    $0xc,%esp
f0103ea2:	68 26 72 10 f0       	push   $0xf0107226
f0103ea7:	e8 84 fc ff ff       	call   f0103b30 <cprintf>
f0103eac:	83 c4 10             	add    $0x10,%esp
f0103eaf:	e9 7a ff ff ff       	jmp    f0103e2e <print_trapframe+0xe3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103eb4:	83 ec 08             	sub    $0x8,%esp
f0103eb7:	ff 73 3c             	pushl  0x3c(%ebx)
f0103eba:	68 ab 78 10 f0       	push   $0xf01078ab
f0103ebf:	e8 6c fc ff ff       	call   f0103b30 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103ec4:	83 c4 08             	add    $0x8,%esp
f0103ec7:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103ecb:	50                   	push   %eax
f0103ecc:	68 ba 78 10 f0       	push   $0xf01078ba
f0103ed1:	e8 5a fc ff ff       	call   f0103b30 <cprintf>
f0103ed6:	83 c4 10             	add    $0x10,%esp
}
f0103ed9:	eb 8e                	jmp    f0103e69 <print_trapframe+0x11e>

f0103edb <page_fault_handler>:
    env_run(curenv);
}


void
page_fault_handler(struct Trapframe *tf) {
f0103edb:	55                   	push   %ebp
f0103edc:	89 e5                	mov    %esp,%ebp
f0103ede:	57                   	push   %edi
f0103edf:	56                   	push   %esi
f0103ee0:	53                   	push   %ebx
f0103ee1:	83 ec 0c             	sub    $0xc,%esp
f0103ee4:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0103ee7:	0f 20 d6             	mov    %cr2,%esi

    // We've already handled kernel-mode exceptions, so if we get here,
    // the page fault happened in user mode.

    // Destroy the environment that caused the fault.
    cprintf("[%08x] user fault va %08x ip %08x\n",
f0103eea:	8b 7b 30             	mov    0x30(%ebx),%edi
            curenv->env_id, fault_va, tf->tf_eip);
f0103eed:	e8 cd 15 00 00       	call   f01054bf <cpunum>
    cprintf("[%08x] user fault va %08x ip %08x\n",
f0103ef2:	57                   	push   %edi
f0103ef3:	56                   	push   %esi
            curenv->env_id, fault_va, tf->tf_eip);
f0103ef4:	6b c0 74             	imul   $0x74,%eax,%eax
    cprintf("[%08x] user fault va %08x ip %08x\n",
f0103ef7:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f0103efd:	ff 70 48             	pushl  0x48(%eax)
f0103f00:	68 b0 7c 10 f0       	push   $0xf0107cb0
f0103f05:	e8 26 fc ff ff       	call   f0103b30 <cprintf>
    print_trapframe(tf);
f0103f0a:	89 1c 24             	mov    %ebx,(%esp)
f0103f0d:	e8 39 fe ff ff       	call   f0103d4b <print_trapframe>
    env_destroy(curenv);
f0103f12:	e8 a8 15 00 00       	call   f01054bf <cpunum>
f0103f17:	83 c4 04             	add    $0x4,%esp
f0103f1a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f1d:	ff b0 28 d0 22 f0    	pushl  -0xfdd2fd8(%eax)
f0103f23:	e8 82 f9 ff ff       	call   f01038aa <env_destroy>
}
f0103f28:	83 c4 10             	add    $0x10,%esp
f0103f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103f2e:	5b                   	pop    %ebx
f0103f2f:	5e                   	pop    %esi
f0103f30:	5f                   	pop    %edi
f0103f31:	5d                   	pop    %ebp
f0103f32:	c3                   	ret    

f0103f33 <trap>:
trap(struct Trapframe *tf) {
f0103f33:	55                   	push   %ebp
f0103f34:	89 e5                	mov    %esp,%ebp
f0103f36:	57                   	push   %edi
f0103f37:	56                   	push   %esi
f0103f38:	8b 75 08             	mov    0x8(%ebp),%esi
    asm volatile("cld":: : "cc");
f0103f3b:	fc                   	cld    
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0103f3c:	9c                   	pushf  
f0103f3d:	58                   	pop    %eax
    assert(!(read_eflags() & FL_IF));
f0103f3e:	f6 c4 02             	test   $0x2,%ah
f0103f41:	74 19                	je     f0103f5c <trap+0x29>
f0103f43:	68 cd 78 10 f0       	push   $0xf01078cd
f0103f48:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0103f4d:	68 f5 00 00 00       	push   $0xf5
f0103f52:	68 e6 78 10 f0       	push   $0xf01078e6
f0103f57:	e8 e4 c0 ff ff       	call   f0100040 <_panic>
    cprintf("Incoming TRAP frame at %p\n", tf);
f0103f5c:	83 ec 08             	sub    $0x8,%esp
f0103f5f:	56                   	push   %esi
f0103f60:	68 f2 78 10 f0       	push   $0xf01078f2
f0103f65:	e8 c6 fb ff ff       	call   f0103b30 <cprintf>
    if ((tf->tf_cs & 3) == 3) {
f0103f6a:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103f6e:	83 e0 03             	and    $0x3,%eax
f0103f71:	83 c4 10             	add    $0x10,%esp
f0103f74:	66 83 f8 03          	cmp    $0x3,%ax
f0103f78:	74 1a                	je     f0103f94 <trap+0x61>
    last_tf = tf;
f0103f7a:	89 35 60 ca 22 f0    	mov    %esi,0xf022ca60
    switch (tf->tf_trapno) {
f0103f80:	83 7e 28 30          	cmpl   $0x30,0x28(%esi)
f0103f84:	0f 87 d6 01 00 00    	ja     f0104160 <trap+0x22d>
f0103f8a:	8b 46 28             	mov    0x28(%esi),%eax
f0103f8d:	ff 24 85 90 7b 10 f0 	jmp    *-0xfef8470(,%eax,4)
        cprintf("Trapped from user mode.\n");
f0103f94:	83 ec 0c             	sub    $0xc,%esp
f0103f97:	68 0d 79 10 f0       	push   $0xf010790d
f0103f9c:	e8 8f fb ff ff       	call   f0103b30 <cprintf>
        assert(curenv);
f0103fa1:	e8 19 15 00 00       	call   f01054bf <cpunum>
f0103fa6:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fa9:	83 c4 10             	add    $0x10,%esp
f0103fac:	83 b8 28 d0 22 f0 00 	cmpl   $0x0,-0xfdd2fd8(%eax)
f0103fb3:	74 27                	je     f0103fdc <trap+0xa9>
        curenv->env_tf = *tf;
f0103fb5:	e8 05 15 00 00       	call   f01054bf <cpunum>
f0103fba:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fbd:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f0103fc3:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103fc8:	89 c7                	mov    %eax,%edi
f0103fca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        tf = &curenv->env_tf;
f0103fcc:	e8 ee 14 00 00       	call   f01054bf <cpunum>
f0103fd1:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fd4:	8b b0 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%esi
f0103fda:	eb 9e                	jmp    f0103f7a <trap+0x47>
        assert(curenv);
f0103fdc:	68 26 79 10 f0       	push   $0xf0107926
f0103fe1:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0103fe6:	68 fd 00 00 00       	push   $0xfd
f0103feb:	68 e6 78 10 f0       	push   $0xf01078e6
f0103ff0:	e8 4b c0 ff ff       	call   f0100040 <_panic>
            cprintf("Divide Error fault\n");
f0103ff5:	83 ec 0c             	sub    $0xc,%esp
f0103ff8:	68 2d 79 10 f0       	push   $0xf010792d
f0103ffd:	e8 2e fb ff ff       	call   f0103b30 <cprintf>
f0104002:	83 c4 10             	add    $0x10,%esp
    print_trapframe(tf);
f0104005:	83 ec 0c             	sub    $0xc,%esp
f0104008:	56                   	push   %esi
f0104009:	e8 3d fd ff ff       	call   f0103d4b <print_trapframe>
    if (tf->tf_cs == GD_KT)
f010400e:	83 c4 10             	add    $0x10,%esp
f0104011:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104016:	0f 84 59 01 00 00    	je     f0104175 <trap+0x242>
        env_destroy(curenv);
f010401c:	e8 9e 14 00 00       	call   f01054bf <cpunum>
f0104021:	83 ec 0c             	sub    $0xc,%esp
f0104024:	6b c0 74             	imul   $0x74,%eax,%eax
f0104027:	ff b0 28 d0 22 f0    	pushl  -0xfdd2fd8(%eax)
f010402d:	e8 78 f8 ff ff       	call   f01038aa <env_destroy>
f0104032:	83 c4 10             	add    $0x10,%esp
    assert(curenv && curenv->env_status == ENV_RUNNING);
f0104035:	e8 85 14 00 00       	call   f01054bf <cpunum>
f010403a:	6b c0 74             	imul   $0x74,%eax,%eax
f010403d:	83 b8 28 d0 22 f0 00 	cmpl   $0x0,-0xfdd2fd8(%eax)
f0104044:	74 18                	je     f010405e <trap+0x12b>
f0104046:	e8 74 14 00 00       	call   f01054bf <cpunum>
f010404b:	6b c0 74             	imul   $0x74,%eax,%eax
f010404e:	8b 80 28 d0 22 f0    	mov    -0xfdd2fd8(%eax),%eax
f0104054:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104058:	0f 84 2e 01 00 00    	je     f010418c <trap+0x259>
f010405e:	68 58 7d 10 f0       	push   $0xf0107d58
f0104063:	68 e1 6e 10 f0       	push   $0xf0106ee1
f0104068:	68 0f 01 00 00       	push   $0x10f
f010406d:	68 e6 78 10 f0       	push   $0xf01078e6
f0104072:	e8 c9 bf ff ff       	call   f0100040 <_panic>
            cprintf("Debug exceptions. Hints: An exception handler can examine the debug registers to determine which condition caused the exception.\n");
f0104077:	83 ec 0c             	sub    $0xc,%esp
f010407a:	68 d4 7c 10 f0       	push   $0xf0107cd4
f010407f:	e8 ac fa ff ff       	call   f0103b30 <cprintf>
f0104084:	83 c4 10             	add    $0x10,%esp
f0104087:	e9 79 ff ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("Breakpoint INT 3 trap\n");
f010408c:	83 ec 0c             	sub    $0xc,%esp
f010408f:	68 41 79 10 f0       	push   $0xf0107941
f0104094:	e8 97 fa ff ff       	call   f0103b30 <cprintf>
            monitor(tf);
f0104099:	89 34 24             	mov    %esi,(%esp)
f010409c:	e8 39 c8 ff ff       	call   f01008da <monitor>
f01040a1:	83 c4 10             	add    $0x10,%esp
f01040a4:	e9 5c ff ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("Overflow trap\n");
f01040a9:	83 ec 0c             	sub    $0xc,%esp
f01040ac:	68 58 79 10 f0       	push   $0xf0107958
f01040b1:	e8 7a fa ff ff       	call   f0103b30 <cprintf>
f01040b6:	83 c4 10             	add    $0x10,%esp
f01040b9:	e9 47 ff ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("Bounds Check fault\n");
f01040be:	83 ec 0c             	sub    $0xc,%esp
f01040c1:	68 67 79 10 f0       	push   $0xf0107967
f01040c6:	e8 65 fa ff ff       	call   f0103b30 <cprintf>
f01040cb:	83 c4 10             	add    $0x10,%esp
f01040ce:	e9 32 ff ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("Invalid Opcode fault\n");
f01040d3:	83 ec 0c             	sub    $0xc,%esp
f01040d6:	68 7b 79 10 f0       	push   $0xf010797b
f01040db:	e8 50 fa ff ff       	call   f0103b30 <cprintf>
f01040e0:	83 c4 10             	add    $0x10,%esp
f01040e3:	e9 1d ff ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("Double Fault\n");
f01040e8:	83 ec 0c             	sub    $0xc,%esp
f01040eb:	68 91 79 10 f0       	push   $0xf0107991
f01040f0:	e8 3b fa ff ff       	call   f0103b30 <cprintf>
f01040f5:	83 c4 10             	add    $0x10,%esp
f01040f8:	e9 08 ff ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("General Protection Exception\n");
f01040fd:	83 ec 0c             	sub    $0xc,%esp
f0104100:	68 9f 79 10 f0       	push   $0xf010799f
f0104105:	e8 26 fa ff ff       	call   f0103b30 <cprintf>
f010410a:	83 c4 10             	add    $0x10,%esp
f010410d:	e9 f3 fe ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("Page Fault\n");
f0104112:	83 ec 0c             	sub    $0xc,%esp
f0104115:	68 bd 79 10 f0       	push   $0xf01079bd
f010411a:	e8 11 fa ff ff       	call   f0103b30 <cprintf>
            page_fault_handler(tf);
f010411f:	89 34 24             	mov    %esi,(%esp)
f0104122:	e8 b4 fd ff ff       	call   f0103edb <page_fault_handler>
f0104127:	83 c4 10             	add    $0x10,%esp
f010412a:	e9 d6 fe ff ff       	jmp    f0104005 <trap+0xd2>
            cprintf("T_SYSCALL\n");
f010412f:	83 ec 0c             	sub    $0xc,%esp
f0104132:	68 c9 79 10 f0       	push   $0xf01079c9
f0104137:	e8 f4 f9 ff ff       	call   f0103b30 <cprintf>
            tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f010413c:	83 c4 08             	add    $0x8,%esp
f010413f:	ff 76 04             	pushl  0x4(%esi)
f0104142:	ff 36                	pushl  (%esi)
f0104144:	ff 76 10             	pushl  0x10(%esi)
f0104147:	ff 76 18             	pushl  0x18(%esi)
f010414a:	ff 76 14             	pushl  0x14(%esi)
f010414d:	ff 76 1c             	pushl  0x1c(%esi)
f0104150:	e8 a3 01 00 00       	call   f01042f8 <syscall>
f0104155:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104158:	83 c4 20             	add    $0x20,%esp
f010415b:	e9 d5 fe ff ff       	jmp    f0104035 <trap+0x102>
            cprintf("Unknown Trap\n");
f0104160:	83 ec 0c             	sub    $0xc,%esp
f0104163:	68 d4 79 10 f0       	push   $0xf01079d4
f0104168:	e8 c3 f9 ff ff       	call   f0103b30 <cprintf>
f010416d:	83 c4 10             	add    $0x10,%esp
f0104170:	e9 90 fe ff ff       	jmp    f0104005 <trap+0xd2>
        panic("unhandled trap in kernel");
f0104175:	83 ec 04             	sub    $0x4,%esp
f0104178:	68 e2 79 10 f0       	push   $0xf01079e2
f010417d:	68 e5 00 00 00       	push   $0xe5
f0104182:	68 e6 78 10 f0       	push   $0xf01078e6
f0104187:	e8 b4 be ff ff       	call   f0100040 <_panic>
    env_run(curenv);
f010418c:	e8 2e 13 00 00       	call   f01054bf <cpunum>
f0104191:	83 ec 0c             	sub    $0xc,%esp
f0104194:	6b c0 74             	imul   $0x74,%eax,%eax
f0104197:	ff b0 28 d0 22 f0    	pushl  -0xfdd2fd8(%eax)
f010419d:	e8 58 f7 ff ff       	call   f01038fa <env_run>

f01041a2 <handler0>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
//which need error_code?
TRAPHANDLER_NOEC(handler0, T_DIVIDE);
f01041a2:	6a 00                	push   $0x0
f01041a4:	6a 00                	push   $0x0
f01041a6:	eb 60                	jmp    f0104208 <_alltraps>

f01041a8 <handler1>:
TRAPHANDLER_NOEC(handler1, T_DEBUG);
f01041a8:	6a 00                	push   $0x0
f01041aa:	6a 01                	push   $0x1
f01041ac:	eb 5a                	jmp    f0104208 <_alltraps>

f01041ae <handler2>:
TRAPHANDLER_NOEC(handler2, T_NMI);
f01041ae:	6a 00                	push   $0x0
f01041b0:	6a 02                	push   $0x2
f01041b2:	eb 54                	jmp    f0104208 <_alltraps>

f01041b4 <handler3>:
TRAPHANDLER_NOEC(handler3, T_BRKPT);
f01041b4:	6a 00                	push   $0x0
f01041b6:	6a 03                	push   $0x3
f01041b8:	eb 4e                	jmp    f0104208 <_alltraps>

f01041ba <handler4>:
TRAPHANDLER_NOEC(handler4, T_OFLOW);
f01041ba:	6a 00                	push   $0x0
f01041bc:	6a 04                	push   $0x4
f01041be:	eb 48                	jmp    f0104208 <_alltraps>

f01041c0 <handler5>:
TRAPHANDLER_NOEC(handler5, T_BOUND);
f01041c0:	6a 00                	push   $0x0
f01041c2:	6a 05                	push   $0x5
f01041c4:	eb 42                	jmp    f0104208 <_alltraps>

f01041c6 <handler6>:
TRAPHANDLER_NOEC(handler6, T_ILLOP);
f01041c6:	6a 00                	push   $0x0
f01041c8:	6a 06                	push   $0x6
f01041ca:	eb 3c                	jmp    f0104208 <_alltraps>

f01041cc <handler7>:
TRAPHANDLER_NOEC(handler7, T_DEVICE);
f01041cc:	6a 00                	push   $0x0
f01041ce:	6a 07                	push   $0x7
f01041d0:	eb 36                	jmp    f0104208 <_alltraps>

f01041d2 <handler8>:
TRAPHANDLER(handler8, T_DBLFLT);
f01041d2:	6a 08                	push   $0x8
f01041d4:	eb 32                	jmp    f0104208 <_alltraps>

f01041d6 <handler10>:
//TRAPHANDLER_NOEC(handler9, T_COPROC);
TRAPHANDLER(handler10, T_TSS);
f01041d6:	6a 0a                	push   $0xa
f01041d8:	eb 2e                	jmp    f0104208 <_alltraps>

f01041da <handler11>:
TRAPHANDLER(handler11, T_SEGNP);
f01041da:	6a 0b                	push   $0xb
f01041dc:	eb 2a                	jmp    f0104208 <_alltraps>

f01041de <handler12>:
TRAPHANDLER(handler12, T_STACK);
f01041de:	6a 0c                	push   $0xc
f01041e0:	eb 26                	jmp    f0104208 <_alltraps>

f01041e2 <handler13>:
TRAPHANDLER(handler13, T_GPFLT);
f01041e2:	6a 0d                	push   $0xd
f01041e4:	eb 22                	jmp    f0104208 <_alltraps>

f01041e6 <handler14>:
TRAPHANDLER(handler14, T_PGFLT);
f01041e6:	6a 0e                	push   $0xe
f01041e8:	eb 1e                	jmp    f0104208 <_alltraps>

f01041ea <handler16>:
//TRAPHANDLER_NOEC(handler15, T_RES);
TRAPHANDLER_NOEC(handler16, T_FPERR);
f01041ea:	6a 00                	push   $0x0
f01041ec:	6a 10                	push   $0x10
f01041ee:	eb 18                	jmp    f0104208 <_alltraps>

f01041f0 <handler17>:
TRAPHANDLER_NOEC(handler17, T_ALIGN);
f01041f0:	6a 00                	push   $0x0
f01041f2:	6a 11                	push   $0x11
f01041f4:	eb 12                	jmp    f0104208 <_alltraps>

f01041f6 <handler18>:
TRAPHANDLER_NOEC(handler18, T_MCHK);
f01041f6:	6a 00                	push   $0x0
f01041f8:	6a 12                	push   $0x12
f01041fa:	eb 0c                	jmp    f0104208 <_alltraps>

f01041fc <handler19>:
TRAPHANDLER_NOEC(handler19, T_SIMDERR);
f01041fc:	6a 00                	push   $0x0
f01041fe:	6a 13                	push   $0x13
f0104200:	eb 06                	jmp    f0104208 <_alltraps>

f0104202 <handler48>:

TRAPHANDLER_NOEC(handler48, T_SYSCALL);
f0104202:	6a 00                	push   $0x0
f0104204:	6a 30                	push   $0x30
f0104206:	eb 00                	jmp    f0104208 <_alltraps>

f0104208 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
    //i stupid here
    pushl %ds
f0104208:	1e                   	push   %ds
    pushl %es
f0104209:	06                   	push   %es
    // forget above
    pushal
f010420a:	60                   	pusha  
    movl $GD_KD, %eax
f010420b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
f0104210:	8e d8                	mov    %eax,%ds
    movw %ax, %es
f0104212:	8e c0                	mov    %eax,%es
    pushl %esp
f0104214:	54                   	push   %esp
f0104215:	e8 19 fd ff ff       	call   f0103f33 <trap>

f010421a <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f010421a:	55                   	push   %ebp
f010421b:	89 e5                	mov    %esp,%ebp
f010421d:	83 ec 08             	sub    $0x8,%esp
f0104220:	a1 4c c2 22 f0       	mov    0xf022c24c,%eax
f0104225:	83 c0 54             	add    $0x54,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104228:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f010422d:	8b 10                	mov    (%eax),%edx
f010422f:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104232:	83 fa 02             	cmp    $0x2,%edx
f0104235:	76 2d                	jbe    f0104264 <sched_halt+0x4a>
	for (i = 0; i < NENV; i++) {
f0104237:	83 c1 01             	add    $0x1,%ecx
f010423a:	83 c0 7c             	add    $0x7c,%eax
f010423d:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104243:	75 e8                	jne    f010422d <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104245:	83 ec 0c             	sub    $0xc,%esp
f0104248:	68 84 7d 10 f0       	push   $0xf0107d84
f010424d:	e8 de f8 ff ff       	call   f0103b30 <cprintf>
f0104252:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104255:	83 ec 0c             	sub    $0xc,%esp
f0104258:	6a 00                	push   $0x0
f010425a:	e8 7b c6 ff ff       	call   f01008da <monitor>
f010425f:	83 c4 10             	add    $0x10,%esp
f0104262:	eb f1                	jmp    f0104255 <sched_halt+0x3b>
	if (i == NENV) {
f0104264:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f010426a:	74 d9                	je     f0104245 <sched_halt+0x2b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010426c:	e8 4e 12 00 00       	call   f01054bf <cpunum>
f0104271:	6b c0 74             	imul   $0x74,%eax,%eax
f0104274:	c7 80 28 d0 22 f0 00 	movl   $0x0,-0xfdd2fd8(%eax)
f010427b:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f010427e:	a1 10 cf 22 f0       	mov    0xf022cf10,%eax
	if ((uint32_t)kva < KERNBASE)
f0104283:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104288:	76 4f                	jbe    f01042d9 <sched_halt+0xbf>
	return (physaddr_t)kva - KERNBASE;
f010428a:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010428f:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104292:	e8 28 12 00 00       	call   f01054bf <cpunum>
f0104297:	6b d0 74             	imul   $0x74,%eax,%edx
f010429a:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010429d:	b8 02 00 00 00       	mov    $0x2,%eax
f01042a2:	f0 87 82 20 d0 22 f0 	lock xchg %eax,-0xfdd2fe0(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01042a9:	83 ec 0c             	sub    $0xc,%esp
f01042ac:	68 80 13 12 f0       	push   $0xf0121380
f01042b1:	e8 16 15 00 00       	call   f01057cc <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01042b6:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		//"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f01042b8:	e8 02 12 00 00       	call   f01054bf <cpunum>
f01042bd:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f01042c0:	8b 80 30 d0 22 f0    	mov    -0xfdd2fd0(%eax),%eax
f01042c6:	bd 00 00 00 00       	mov    $0x0,%ebp
f01042cb:	89 c4                	mov    %eax,%esp
f01042cd:	6a 00                	push   $0x0
f01042cf:	6a 00                	push   $0x0
f01042d1:	f4                   	hlt    
f01042d2:	eb fd                	jmp    f01042d1 <sched_halt+0xb7>
}
f01042d4:	83 c4 10             	add    $0x10,%esp
f01042d7:	c9                   	leave  
f01042d8:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01042d9:	50                   	push   %eax
f01042da:	68 48 5b 10 f0       	push   $0xf0105b48
f01042df:	6a 3d                	push   $0x3d
f01042e1:	68 ad 7d 10 f0       	push   $0xf0107dad
f01042e6:	e8 55 bd ff ff       	call   f0100040 <_panic>

f01042eb <sched_yield>:
{
f01042eb:	55                   	push   %ebp
f01042ec:	89 e5                	mov    %esp,%ebp
f01042ee:	83 ec 08             	sub    $0x8,%esp
	sched_halt();
f01042f1:	e8 24 ff ff ff       	call   f010421a <sched_halt>
}
f01042f6:	c9                   	leave  
f01042f7:	c3                   	ret    

f01042f8 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01042f8:	55                   	push   %ebp
f01042f9:	89 e5                	mov    %esp,%ebp
f01042fb:	83 ec 0c             	sub    $0xc,%esp
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	panic("syscall not implemented");
f01042fe:	68 ba 7d 10 f0       	push   $0xf0107dba
f0104303:	68 12 01 00 00       	push   $0x112
f0104308:	68 d2 7d 10 f0       	push   $0xf0107dd2
f010430d:	e8 2e bd ff ff       	call   f0100040 <_panic>

f0104312 <stab_binsearch>:
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr) {
f0104312:	55                   	push   %ebp
f0104313:	89 e5                	mov    %esp,%ebp
f0104315:	57                   	push   %edi
f0104316:	56                   	push   %esi
f0104317:	53                   	push   %ebx
f0104318:	83 ec 14             	sub    $0x14,%esp
f010431b:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010431e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104321:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104324:	8b 7d 08             	mov    0x8(%ebp),%edi
    int l = *region_left, r = *region_right, any_matches = 0;
f0104327:	8b 32                	mov    (%edx),%esi
f0104329:	8b 01                	mov    (%ecx),%eax
f010432b:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010432e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    while (l <= r) {
f0104335:	eb 2f                	jmp    f0104366 <stab_binsearch+0x54>
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
f0104337:	83 e8 01             	sub    $0x1,%eax
        while (m >= l && stabs[m].n_type != type)
f010433a:	39 c6                	cmp    %eax,%esi
f010433c:	7f 49                	jg     f0104387 <stab_binsearch+0x75>
f010433e:	0f b6 0a             	movzbl (%edx),%ecx
f0104341:	83 ea 0c             	sub    $0xc,%edx
f0104344:	39 f9                	cmp    %edi,%ecx
f0104346:	75 ef                	jne    f0104337 <stab_binsearch+0x25>
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
f0104348:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010434b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010434e:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104352:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104355:	73 35                	jae    f010438c <stab_binsearch+0x7a>
            *region_left = m;
f0104357:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010435a:	89 06                	mov    %eax,(%esi)
            l = true_m + 1;
f010435c:	8d 73 01             	lea    0x1(%ebx),%esi
        any_matches = 1;
f010435f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while (l <= r) {
f0104366:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104369:	7f 4e                	jg     f01043b9 <stab_binsearch+0xa7>
        int true_m = (l + r) / 2, m = true_m;
f010436b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010436e:	01 f0                	add    %esi,%eax
f0104370:	89 c3                	mov    %eax,%ebx
f0104372:	c1 eb 1f             	shr    $0x1f,%ebx
f0104375:	01 c3                	add    %eax,%ebx
f0104377:	d1 fb                	sar    %ebx
f0104379:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010437c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010437f:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104383:	89 d8                	mov    %ebx,%eax
        while (m >= l && stabs[m].n_type != type)
f0104385:	eb b3                	jmp    f010433a <stab_binsearch+0x28>
            l = true_m + 1;
f0104387:	8d 73 01             	lea    0x1(%ebx),%esi
            continue;
f010438a:	eb da                	jmp    f0104366 <stab_binsearch+0x54>
        } else if (stabs[m].n_value > addr) {
f010438c:	3b 55 0c             	cmp    0xc(%ebp),%edx
f010438f:	76 14                	jbe    f01043a5 <stab_binsearch+0x93>
            *region_right = m - 1;
f0104391:	83 e8 01             	sub    $0x1,%eax
f0104394:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104397:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010439a:	89 03                	mov    %eax,(%ebx)
        any_matches = 1;
f010439c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01043a3:	eb c1                	jmp    f0104366 <stab_binsearch+0x54>
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
f01043a5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01043a8:	89 06                	mov    %eax,(%esi)
            l = m;
            addr++;
f01043aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01043ae:	89 c6                	mov    %eax,%esi
        any_matches = 1;
f01043b0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01043b7:	eb ad                	jmp    f0104366 <stab_binsearch+0x54>
        }
    }

    if (!any_matches)
f01043b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01043bd:	74 16                	je     f01043d5 <stab_binsearch+0xc3>
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
f01043bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01043c2:	8b 00                	mov    (%eax),%eax
             l > *region_left && stabs[l].n_type != type;
f01043c4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01043c7:	8b 0e                	mov    (%esi),%ecx
f01043c9:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01043cc:	8b 75 ec             	mov    -0x14(%ebp),%esi
f01043cf:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
        for (l = *region_right;
f01043d3:	eb 12                	jmp    f01043e7 <stab_binsearch+0xd5>
        *region_right = *region_left - 1;
f01043d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01043d8:	8b 00                	mov    (%eax),%eax
f01043da:	83 e8 01             	sub    $0x1,%eax
f01043dd:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01043e0:	89 07                	mov    %eax,(%edi)
f01043e2:	eb 16                	jmp    f01043fa <stab_binsearch+0xe8>
             l--)
f01043e4:	83 e8 01             	sub    $0x1,%eax
        for (l = *region_right;
f01043e7:	39 c1                	cmp    %eax,%ecx
f01043e9:	7d 0a                	jge    f01043f5 <stab_binsearch+0xe3>
             l > *region_left && stabs[l].n_type != type;
f01043eb:	0f b6 1a             	movzbl (%edx),%ebx
f01043ee:	83 ea 0c             	sub    $0xc,%edx
f01043f1:	39 fb                	cmp    %edi,%ebx
f01043f3:	75 ef                	jne    f01043e4 <stab_binsearch+0xd2>
            /* do nothing */;
        *region_left = l;
f01043f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01043f8:	89 07                	mov    %eax,(%edi)
    }
}
f01043fa:	83 c4 14             	add    $0x14,%esp
f01043fd:	5b                   	pop    %ebx
f01043fe:	5e                   	pop    %esi
f01043ff:	5f                   	pop    %edi
f0104400:	5d                   	pop    %ebp
f0104401:	c3                   	ret    

f0104402 <debuginfo_eip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info) {
f0104402:	55                   	push   %ebp
f0104403:	89 e5                	mov    %esp,%ebp
f0104405:	57                   	push   %edi
f0104406:	56                   	push   %esi
f0104407:	53                   	push   %ebx
f0104408:	83 ec 3c             	sub    $0x3c,%esp
f010440b:	8b 75 08             	mov    0x8(%ebp),%esi
f010440e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    const struct Stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->eip_file = "<unknown>";
f0104411:	c7 03 e1 7d 10 f0    	movl   $0xf0107de1,(%ebx)
    info->eip_line = 0;
f0104417:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    info->eip_fn_name = "<unknown>";
f010441e:	c7 43 08 e1 7d 10 f0 	movl   $0xf0107de1,0x8(%ebx)
    info->eip_fn_namelen = 9;
f0104425:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
    info->eip_fn_addr = addr;
f010442c:	89 73 10             	mov    %esi,0x10(%ebx)
    info->eip_fn_narg = 0;
f010442f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

    // Find the relevant set of stabs
    if (addr >= ULIM) {
f0104436:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010443c:	0f 86 2a 01 00 00    	jbe    f010456c <debuginfo_eip+0x16a>
        // Can't search for user-level addresses yet!
        panic("User address");
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104442:	b8 e8 68 11 f0       	mov    $0xf01168e8,%eax
f0104447:	3d 01 32 11 f0       	cmp    $0xf0113201,%eax
f010444c:	0f 86 b9 01 00 00    	jbe    f010460b <debuginfo_eip+0x209>
f0104452:	80 3d e7 68 11 f0 00 	cmpb   $0x0,0xf01168e7
f0104459:	0f 85 b3 01 00 00    	jne    f0104612 <debuginfo_eip+0x210>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
f010445f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    rfile = (stab_end - stabs) - 1;
f0104466:	b8 00 32 11 f0       	mov    $0xf0113200,%eax
f010446b:	2d d4 82 10 f0       	sub    $0xf01082d4,%eax
f0104470:	c1 f8 02             	sar    $0x2,%eax
f0104473:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104479:	83 e8 01             	sub    $0x1,%eax
f010447c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010447f:	83 ec 08             	sub    $0x8,%esp
f0104482:	56                   	push   %esi
f0104483:	6a 64                	push   $0x64
f0104485:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0104488:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010448b:	b8 d4 82 10 f0       	mov    $0xf01082d4,%eax
f0104490:	e8 7d fe ff ff       	call   f0104312 <stab_binsearch>
    if (lfile == 0)
f0104495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104498:	83 c4 10             	add    $0x10,%esp
f010449b:	85 c0                	test   %eax,%eax
f010449d:	0f 84 76 01 00 00    	je     f0104619 <debuginfo_eip+0x217>
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
f01044a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    rfun = rfile;
f01044a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01044a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01044ac:	83 ec 08             	sub    $0x8,%esp
f01044af:	56                   	push   %esi
f01044b0:	6a 24                	push   $0x24
f01044b2:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f01044b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01044b8:	b8 d4 82 10 f0       	mov    $0xf01082d4,%eax
f01044bd:	e8 50 fe ff ff       	call   f0104312 <stab_binsearch>

    if (lfun <= rfun) {
f01044c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01044c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01044c8:	83 c4 10             	add    $0x10,%esp
f01044cb:	39 d0                	cmp    %edx,%eax
f01044cd:	0f 8f ad 00 00 00    	jg     f0104580 <debuginfo_eip+0x17e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
f01044d3:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f01044d6:	c1 e1 02             	shl    $0x2,%ecx
f01044d9:	8d b9 d4 82 10 f0    	lea    -0xfef7d2c(%ecx),%edi
f01044df:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f01044e2:	8b b9 d4 82 10 f0    	mov    -0xfef7d2c(%ecx),%edi
f01044e8:	b9 e8 68 11 f0       	mov    $0xf01168e8,%ecx
f01044ed:	81 e9 01 32 11 f0    	sub    $0xf0113201,%ecx
f01044f3:	39 cf                	cmp    %ecx,%edi
f01044f5:	73 09                	jae    f0104500 <debuginfo_eip+0xfe>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01044f7:	81 c7 01 32 11 f0    	add    $0xf0113201,%edi
f01044fd:	89 7b 08             	mov    %edi,0x8(%ebx)
        info->eip_fn_addr = stabs[lfun].n_value;
f0104500:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0104503:	8b 4f 08             	mov    0x8(%edi),%ecx
f0104506:	89 4b 10             	mov    %ecx,0x10(%ebx)
        addr -= info->eip_fn_addr;
f0104509:	29 ce                	sub    %ecx,%esi
        // Search within the function definition for the line number.
        lline = lfun;
f010450b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
f010450e:	89 55 d0             	mov    %edx,-0x30(%ebp)
        info->eip_fn_addr = addr;
        lline = lfile;
        rline = rfile;
    }
    // Ignore stuff after the colon.
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104511:	83 ec 08             	sub    $0x8,%esp
f0104514:	6a 3a                	push   $0x3a
f0104516:	ff 73 08             	pushl  0x8(%ebx)
f0104519:	e8 60 09 00 00       	call   f0104e7e <strfind>
f010451e:	2b 43 08             	sub    0x8(%ebx),%eax
f0104521:	89 43 0c             	mov    %eax,0xc(%ebx)
    // Hint:
    //	There's a particular stabs type used for line numbers.
    //	Look at the STABS documentation and <inc/stab.h> to find
    //	which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, info->eip_fn_addr + addr);
f0104524:	83 c4 08             	add    $0x8,%esp
f0104527:	03 73 10             	add    0x10(%ebx),%esi
f010452a:	56                   	push   %esi
f010452b:	6a 44                	push   $0x44
f010452d:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104530:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104533:	b8 d4 82 10 f0       	mov    $0xf01082d4,%eax
f0104538:	e8 d5 fd ff ff       	call   f0104312 <stab_binsearch>
    info->eip_line = lline > rline ? -1 : stabs[lline].n_desc;
f010453d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104540:	83 c4 10             	add    $0x10,%esp
f0104543:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104548:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f010454b:	7f 0b                	jg     f0104558 <debuginfo_eip+0x156>
f010454d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104550:	0f b7 14 95 da 82 10 	movzwl -0xfef7d26(,%edx,4),%edx
f0104557:	f0 
f0104558:	89 53 04             	mov    %edx,0x4(%ebx)
    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
f010455b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010455e:	89 c2                	mov    %eax,%edx
f0104560:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104563:	8d 04 85 d8 82 10 f0 	lea    -0xfef7d28(,%eax,4),%eax
f010456a:	eb 2b                	jmp    f0104597 <debuginfo_eip+0x195>
        panic("User address");
f010456c:	83 ec 04             	sub    $0x4,%esp
f010456f:	68 eb 7d 10 f0       	push   $0xf0107deb
f0104574:	6a 7d                	push   $0x7d
f0104576:	68 f8 7d 10 f0       	push   $0xf0107df8
f010457b:	e8 c0 ba ff ff       	call   f0100040 <_panic>
        info->eip_fn_addr = addr;
f0104580:	89 73 10             	mov    %esi,0x10(%ebx)
        lline = lfile;
f0104583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104586:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
f0104589:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010458c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010458f:	eb 80                	jmp    f0104511 <debuginfo_eip+0x10f>
f0104591:	83 ea 01             	sub    $0x1,%edx
f0104594:	83 e8 0c             	sub    $0xc,%eax
    while (lline >= lfile
f0104597:	39 d7                	cmp    %edx,%edi
f0104599:	7f 33                	jg     f01045ce <debuginfo_eip+0x1cc>
           && stabs[lline].n_type != N_SOL
f010459b:	0f b6 08             	movzbl (%eax),%ecx
f010459e:	80 f9 84             	cmp    $0x84,%cl
f01045a1:	74 0b                	je     f01045ae <debuginfo_eip+0x1ac>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01045a3:	80 f9 64             	cmp    $0x64,%cl
f01045a6:	75 e9                	jne    f0104591 <debuginfo_eip+0x18f>
f01045a8:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f01045ac:	74 e3                	je     f0104591 <debuginfo_eip+0x18f>
        lline--;
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01045ae:	8d 04 52             	lea    (%edx,%edx,2),%eax
f01045b1:	8b 14 85 d4 82 10 f0 	mov    -0xfef7d2c(,%eax,4),%edx
f01045b8:	b8 e8 68 11 f0       	mov    $0xf01168e8,%eax
f01045bd:	2d 01 32 11 f0       	sub    $0xf0113201,%eax
f01045c2:	39 c2                	cmp    %eax,%edx
f01045c4:	73 08                	jae    f01045ce <debuginfo_eip+0x1cc>
        info->eip_file = stabstr + stabs[lline].n_strx;
f01045c6:	81 c2 01 32 11 f0    	add    $0xf0113201,%edx
f01045cc:	89 13                	mov    %edx,(%ebx)


    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
f01045ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01045d1:	8b 75 d8             	mov    -0x28(%ebp),%esi
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
            info->eip_fn_narg++;

    return 0;
f01045d4:	b8 00 00 00 00       	mov    $0x0,%eax
    if (lfun < rfun)
f01045d9:	39 f2                	cmp    %esi,%edx
f01045db:	7d 48                	jge    f0104625 <debuginfo_eip+0x223>
        for (lline = lfun + 1;
f01045dd:	83 c2 01             	add    $0x1,%edx
f01045e0:	89 d0                	mov    %edx,%eax
f01045e2:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01045e5:	8d 14 95 d8 82 10 f0 	lea    -0xfef7d28(,%edx,4),%edx
f01045ec:	eb 04                	jmp    f01045f2 <debuginfo_eip+0x1f0>
            info->eip_fn_narg++;
f01045ee:	83 43 14 01          	addl   $0x1,0x14(%ebx)
        for (lline = lfun + 1;
f01045f2:	39 c6                	cmp    %eax,%esi
f01045f4:	7e 2a                	jle    f0104620 <debuginfo_eip+0x21e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
f01045f6:	0f b6 0a             	movzbl (%edx),%ecx
f01045f9:	83 c0 01             	add    $0x1,%eax
f01045fc:	83 c2 0c             	add    $0xc,%edx
f01045ff:	80 f9 a0             	cmp    $0xa0,%cl
f0104602:	74 ea                	je     f01045ee <debuginfo_eip+0x1ec>
    return 0;
f0104604:	b8 00 00 00 00       	mov    $0x0,%eax
f0104609:	eb 1a                	jmp    f0104625 <debuginfo_eip+0x223>
        return -1;
f010460b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104610:	eb 13                	jmp    f0104625 <debuginfo_eip+0x223>
f0104612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104617:	eb 0c                	jmp    f0104625 <debuginfo_eip+0x223>
        return -1;
f0104619:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010461e:	eb 05                	jmp    f0104625 <debuginfo_eip+0x223>
    return 0;
f0104620:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104625:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104628:	5b                   	pop    %ebx
f0104629:	5e                   	pop    %esi
f010462a:	5f                   	pop    %edi
f010462b:	5d                   	pop    %ebp
f010462c:	c3                   	ret    

f010462d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010462d:	55                   	push   %ebp
f010462e:	89 e5                	mov    %esp,%ebp
f0104630:	57                   	push   %edi
f0104631:	56                   	push   %esi
f0104632:	53                   	push   %ebx
f0104633:	83 ec 1c             	sub    $0x1c,%esp
f0104636:	89 c7                	mov    %eax,%edi
f0104638:	89 d6                	mov    %edx,%esi
f010463a:	8b 45 08             	mov    0x8(%ebp),%eax
f010463d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104640:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104643:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
f0104646:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104649:	bb 00 00 00 00       	mov    $0x0,%ebx
f010464e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104651:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104654:	39 d3                	cmp    %edx,%ebx
f0104656:	72 05                	jb     f010465d <printnum+0x30>
f0104658:	39 45 10             	cmp    %eax,0x10(%ebp)
f010465b:	77 7a                	ja     f01046d7 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010465d:	83 ec 0c             	sub    $0xc,%esp
f0104660:	ff 75 18             	pushl  0x18(%ebp)
f0104663:	8b 45 14             	mov    0x14(%ebp),%eax
f0104666:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104669:	53                   	push   %ebx
f010466a:	ff 75 10             	pushl  0x10(%ebp)
f010466d:	83 ec 08             	sub    $0x8,%esp
f0104670:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104673:	ff 75 e0             	pushl  -0x20(%ebp)
f0104676:	ff 75 dc             	pushl  -0x24(%ebp)
f0104679:	ff 75 d8             	pushl  -0x28(%ebp)
f010467c:	e8 3f 12 00 00       	call   f01058c0 <__udivdi3>
f0104681:	83 c4 18             	add    $0x18,%esp
f0104684:	52                   	push   %edx
f0104685:	50                   	push   %eax
f0104686:	89 f2                	mov    %esi,%edx
f0104688:	89 f8                	mov    %edi,%eax
f010468a:	e8 9e ff ff ff       	call   f010462d <printnum>
f010468f:	83 c4 20             	add    $0x20,%esp
f0104692:	eb 13                	jmp    f01046a7 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104694:	83 ec 08             	sub    $0x8,%esp
f0104697:	56                   	push   %esi
f0104698:	ff 75 18             	pushl  0x18(%ebp)
f010469b:	ff d7                	call   *%edi
f010469d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01046a0:	83 eb 01             	sub    $0x1,%ebx
f01046a3:	85 db                	test   %ebx,%ebx
f01046a5:	7f ed                	jg     f0104694 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01046a7:	83 ec 08             	sub    $0x8,%esp
f01046aa:	56                   	push   %esi
f01046ab:	83 ec 04             	sub    $0x4,%esp
f01046ae:	ff 75 e4             	pushl  -0x1c(%ebp)
f01046b1:	ff 75 e0             	pushl  -0x20(%ebp)
f01046b4:	ff 75 dc             	pushl  -0x24(%ebp)
f01046b7:	ff 75 d8             	pushl  -0x28(%ebp)
f01046ba:	e8 21 13 00 00       	call   f01059e0 <__umoddi3>
f01046bf:	83 c4 14             	add    $0x14,%esp
f01046c2:	0f be 80 06 7e 10 f0 	movsbl -0xfef81fa(%eax),%eax
f01046c9:	50                   	push   %eax
f01046ca:	ff d7                	call   *%edi
}
f01046cc:	83 c4 10             	add    $0x10,%esp
f01046cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01046d2:	5b                   	pop    %ebx
f01046d3:	5e                   	pop    %esi
f01046d4:	5f                   	pop    %edi
f01046d5:	5d                   	pop    %ebp
f01046d6:	c3                   	ret    
f01046d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01046da:	eb c4                	jmp    f01046a0 <printnum+0x73>

f01046dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01046dc:	55                   	push   %ebp
f01046dd:	89 e5                	mov    %esp,%ebp
f01046df:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01046e2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01046e6:	8b 10                	mov    (%eax),%edx
f01046e8:	3b 50 04             	cmp    0x4(%eax),%edx
f01046eb:	73 0a                	jae    f01046f7 <sprintputch+0x1b>
		*b->buf++ = ch;
f01046ed:	8d 4a 01             	lea    0x1(%edx),%ecx
f01046f0:	89 08                	mov    %ecx,(%eax)
f01046f2:	8b 45 08             	mov    0x8(%ebp),%eax
f01046f5:	88 02                	mov    %al,(%edx)
}
f01046f7:	5d                   	pop    %ebp
f01046f8:	c3                   	ret    

f01046f9 <printfmt>:
{
f01046f9:	55                   	push   %ebp
f01046fa:	89 e5                	mov    %esp,%ebp
f01046fc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01046ff:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104702:	50                   	push   %eax
f0104703:	ff 75 10             	pushl  0x10(%ebp)
f0104706:	ff 75 0c             	pushl  0xc(%ebp)
f0104709:	ff 75 08             	pushl  0x8(%ebp)
f010470c:	e8 05 00 00 00       	call   f0104716 <vprintfmt>
}
f0104711:	83 c4 10             	add    $0x10,%esp
f0104714:	c9                   	leave  
f0104715:	c3                   	ret    

f0104716 <vprintfmt>:
{
f0104716:	55                   	push   %ebp
f0104717:	89 e5                	mov    %esp,%ebp
f0104719:	57                   	push   %edi
f010471a:	56                   	push   %esi
f010471b:	53                   	push   %ebx
f010471c:	83 ec 2c             	sub    $0x2c,%esp
f010471f:	8b 75 08             	mov    0x8(%ebp),%esi
f0104722:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104725:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104728:	e9 00 04 00 00       	jmp    f0104b2d <vprintfmt+0x417>
		padc = ' ';
f010472d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0104731:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104738:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f010473f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0104746:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010474b:	8d 47 01             	lea    0x1(%edi),%eax
f010474e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104751:	0f b6 17             	movzbl (%edi),%edx
f0104754:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104757:	3c 55                	cmp    $0x55,%al
f0104759:	0f 87 51 04 00 00    	ja     f0104bb0 <vprintfmt+0x49a>
f010475f:	0f b6 c0             	movzbl %al,%eax
f0104762:	ff 24 85 c0 7e 10 f0 	jmp    *-0xfef8140(,%eax,4)
f0104769:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f010476c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0104770:	eb d9                	jmp    f010474b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104772:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0104775:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104779:	eb d0                	jmp    f010474b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f010477b:	0f b6 d2             	movzbl %dl,%edx
f010477e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104781:	b8 00 00 00 00       	mov    $0x0,%eax
f0104786:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0104789:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010478c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104790:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104793:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104796:	83 f9 09             	cmp    $0x9,%ecx
f0104799:	77 55                	ja     f01047f0 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f010479b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f010479e:	eb e9                	jmp    f0104789 <vprintfmt+0x73>
			precision = va_arg(ap, int);
f01047a0:	8b 45 14             	mov    0x14(%ebp),%eax
f01047a3:	8b 00                	mov    (%eax),%eax
f01047a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01047a8:	8b 45 14             	mov    0x14(%ebp),%eax
f01047ab:	8d 40 04             	lea    0x4(%eax),%eax
f01047ae:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01047b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f01047b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01047b8:	79 91                	jns    f010474b <vprintfmt+0x35>
				width = precision, precision = -1;
f01047ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01047bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01047c0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f01047c7:	eb 82                	jmp    f010474b <vprintfmt+0x35>
f01047c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01047cc:	85 c0                	test   %eax,%eax
f01047ce:	ba 00 00 00 00       	mov    $0x0,%edx
f01047d3:	0f 49 d0             	cmovns %eax,%edx
f01047d6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01047d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01047dc:	e9 6a ff ff ff       	jmp    f010474b <vprintfmt+0x35>
f01047e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f01047e4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f01047eb:	e9 5b ff ff ff       	jmp    f010474b <vprintfmt+0x35>
f01047f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01047f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01047f6:	eb bc                	jmp    f01047b4 <vprintfmt+0x9e>
			lflag++;
f01047f8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01047fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f01047fe:	e9 48 ff ff ff       	jmp    f010474b <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f0104803:	8b 45 14             	mov    0x14(%ebp),%eax
f0104806:	8d 78 04             	lea    0x4(%eax),%edi
f0104809:	83 ec 08             	sub    $0x8,%esp
f010480c:	53                   	push   %ebx
f010480d:	ff 30                	pushl  (%eax)
f010480f:	ff d6                	call   *%esi
			break;
f0104811:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104814:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0104817:	e9 0e 03 00 00       	jmp    f0104b2a <vprintfmt+0x414>
			err = va_arg(ap, int);
f010481c:	8b 45 14             	mov    0x14(%ebp),%eax
f010481f:	8d 78 04             	lea    0x4(%eax),%edi
f0104822:	8b 00                	mov    (%eax),%eax
f0104824:	99                   	cltd   
f0104825:	31 d0                	xor    %edx,%eax
f0104827:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104829:	83 f8 08             	cmp    $0x8,%eax
f010482c:	7f 23                	jg     f0104851 <vprintfmt+0x13b>
f010482e:	8b 14 85 20 80 10 f0 	mov    -0xfef7fe0(,%eax,4),%edx
f0104835:	85 d2                	test   %edx,%edx
f0104837:	74 18                	je     f0104851 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f0104839:	52                   	push   %edx
f010483a:	68 f3 6e 10 f0       	push   $0xf0106ef3
f010483f:	53                   	push   %ebx
f0104840:	56                   	push   %esi
f0104841:	e8 b3 fe ff ff       	call   f01046f9 <printfmt>
f0104846:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104849:	89 7d 14             	mov    %edi,0x14(%ebp)
f010484c:	e9 d9 02 00 00       	jmp    f0104b2a <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
f0104851:	50                   	push   %eax
f0104852:	68 1e 7e 10 f0       	push   $0xf0107e1e
f0104857:	53                   	push   %ebx
f0104858:	56                   	push   %esi
f0104859:	e8 9b fe ff ff       	call   f01046f9 <printfmt>
f010485e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104861:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104864:	e9 c1 02 00 00       	jmp    f0104b2a <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
f0104869:	8b 45 14             	mov    0x14(%ebp),%eax
f010486c:	83 c0 04             	add    $0x4,%eax
f010486f:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0104872:	8b 45 14             	mov    0x14(%ebp),%eax
f0104875:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0104877:	85 ff                	test   %edi,%edi
f0104879:	b8 17 7e 10 f0       	mov    $0xf0107e17,%eax
f010487e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0104881:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104885:	0f 8e bd 00 00 00    	jle    f0104948 <vprintfmt+0x232>
f010488b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f010488f:	75 0e                	jne    f010489f <vprintfmt+0x189>
f0104891:	89 75 08             	mov    %esi,0x8(%ebp)
f0104894:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0104897:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f010489a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010489d:	eb 6d                	jmp    f010490c <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f010489f:	83 ec 08             	sub    $0x8,%esp
f01048a2:	ff 75 d0             	pushl  -0x30(%ebp)
f01048a5:	57                   	push   %edi
f01048a6:	e8 8f 04 00 00       	call   f0104d3a <strnlen>
f01048ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01048ae:	29 c1                	sub    %eax,%ecx
f01048b0:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f01048b3:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f01048b6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f01048ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01048bd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01048c0:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f01048c2:	eb 0f                	jmp    f01048d3 <vprintfmt+0x1bd>
					putch(padc, putdat);
f01048c4:	83 ec 08             	sub    $0x8,%esp
f01048c7:	53                   	push   %ebx
f01048c8:	ff 75 e0             	pushl  -0x20(%ebp)
f01048cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01048cd:	83 ef 01             	sub    $0x1,%edi
f01048d0:	83 c4 10             	add    $0x10,%esp
f01048d3:	85 ff                	test   %edi,%edi
f01048d5:	7f ed                	jg     f01048c4 <vprintfmt+0x1ae>
f01048d7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01048da:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01048dd:	85 c9                	test   %ecx,%ecx
f01048df:	b8 00 00 00 00       	mov    $0x0,%eax
f01048e4:	0f 49 c1             	cmovns %ecx,%eax
f01048e7:	29 c1                	sub    %eax,%ecx
f01048e9:	89 75 08             	mov    %esi,0x8(%ebp)
f01048ec:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01048ef:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01048f2:	89 cb                	mov    %ecx,%ebx
f01048f4:	eb 16                	jmp    f010490c <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f01048f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01048fa:	75 31                	jne    f010492d <vprintfmt+0x217>
					putch(ch, putdat);
f01048fc:	83 ec 08             	sub    $0x8,%esp
f01048ff:	ff 75 0c             	pushl  0xc(%ebp)
f0104902:	50                   	push   %eax
f0104903:	ff 55 08             	call   *0x8(%ebp)
f0104906:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104909:	83 eb 01             	sub    $0x1,%ebx
f010490c:	83 c7 01             	add    $0x1,%edi
f010490f:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0104913:	0f be c2             	movsbl %dl,%eax
f0104916:	85 c0                	test   %eax,%eax
f0104918:	74 59                	je     f0104973 <vprintfmt+0x25d>
f010491a:	85 f6                	test   %esi,%esi
f010491c:	78 d8                	js     f01048f6 <vprintfmt+0x1e0>
f010491e:	83 ee 01             	sub    $0x1,%esi
f0104921:	79 d3                	jns    f01048f6 <vprintfmt+0x1e0>
f0104923:	89 df                	mov    %ebx,%edi
f0104925:	8b 75 08             	mov    0x8(%ebp),%esi
f0104928:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010492b:	eb 37                	jmp    f0104964 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f010492d:	0f be d2             	movsbl %dl,%edx
f0104930:	83 ea 20             	sub    $0x20,%edx
f0104933:	83 fa 5e             	cmp    $0x5e,%edx
f0104936:	76 c4                	jbe    f01048fc <vprintfmt+0x1e6>
					putch('?', putdat);
f0104938:	83 ec 08             	sub    $0x8,%esp
f010493b:	ff 75 0c             	pushl  0xc(%ebp)
f010493e:	6a 3f                	push   $0x3f
f0104940:	ff 55 08             	call   *0x8(%ebp)
f0104943:	83 c4 10             	add    $0x10,%esp
f0104946:	eb c1                	jmp    f0104909 <vprintfmt+0x1f3>
f0104948:	89 75 08             	mov    %esi,0x8(%ebp)
f010494b:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010494e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0104951:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104954:	eb b6                	jmp    f010490c <vprintfmt+0x1f6>
				putch(' ', putdat);
f0104956:	83 ec 08             	sub    $0x8,%esp
f0104959:	53                   	push   %ebx
f010495a:	6a 20                	push   $0x20
f010495c:	ff d6                	call   *%esi
			for (; width > 0; width--)
f010495e:	83 ef 01             	sub    $0x1,%edi
f0104961:	83 c4 10             	add    $0x10,%esp
f0104964:	85 ff                	test   %edi,%edi
f0104966:	7f ee                	jg     f0104956 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f0104968:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010496b:	89 45 14             	mov    %eax,0x14(%ebp)
f010496e:	e9 b7 01 00 00       	jmp    f0104b2a <vprintfmt+0x414>
f0104973:	89 df                	mov    %ebx,%edi
f0104975:	8b 75 08             	mov    0x8(%ebp),%esi
f0104978:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010497b:	eb e7                	jmp    f0104964 <vprintfmt+0x24e>
	if (lflag >= 2)
f010497d:	83 f9 01             	cmp    $0x1,%ecx
f0104980:	7e 3f                	jle    f01049c1 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f0104982:	8b 45 14             	mov    0x14(%ebp),%eax
f0104985:	8b 50 04             	mov    0x4(%eax),%edx
f0104988:	8b 00                	mov    (%eax),%eax
f010498a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010498d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104990:	8b 45 14             	mov    0x14(%ebp),%eax
f0104993:	8d 40 08             	lea    0x8(%eax),%eax
f0104996:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0104999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010499d:	79 5c                	jns    f01049fb <vprintfmt+0x2e5>
				putch('-', putdat);
f010499f:	83 ec 08             	sub    $0x8,%esp
f01049a2:	53                   	push   %ebx
f01049a3:	6a 2d                	push   $0x2d
f01049a5:	ff d6                	call   *%esi
				num = -(long long) num;
f01049a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01049aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01049ad:	f7 da                	neg    %edx
f01049af:	83 d1 00             	adc    $0x0,%ecx
f01049b2:	f7 d9                	neg    %ecx
f01049b4:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01049b7:	b8 0a 00 00 00       	mov    $0xa,%eax
f01049bc:	e9 4f 01 00 00       	jmp    f0104b10 <vprintfmt+0x3fa>
	else if (lflag)
f01049c1:	85 c9                	test   %ecx,%ecx
f01049c3:	75 1b                	jne    f01049e0 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f01049c5:	8b 45 14             	mov    0x14(%ebp),%eax
f01049c8:	8b 00                	mov    (%eax),%eax
f01049ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01049cd:	89 c1                	mov    %eax,%ecx
f01049cf:	c1 f9 1f             	sar    $0x1f,%ecx
f01049d2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01049d5:	8b 45 14             	mov    0x14(%ebp),%eax
f01049d8:	8d 40 04             	lea    0x4(%eax),%eax
f01049db:	89 45 14             	mov    %eax,0x14(%ebp)
f01049de:	eb b9                	jmp    f0104999 <vprintfmt+0x283>
		return va_arg(*ap, long);
f01049e0:	8b 45 14             	mov    0x14(%ebp),%eax
f01049e3:	8b 00                	mov    (%eax),%eax
f01049e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01049e8:	89 c1                	mov    %eax,%ecx
f01049ea:	c1 f9 1f             	sar    $0x1f,%ecx
f01049ed:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01049f0:	8b 45 14             	mov    0x14(%ebp),%eax
f01049f3:	8d 40 04             	lea    0x4(%eax),%eax
f01049f6:	89 45 14             	mov    %eax,0x14(%ebp)
f01049f9:	eb 9e                	jmp    f0104999 <vprintfmt+0x283>
			num = getint(&ap, lflag);
f01049fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01049fe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f0104a01:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104a06:	e9 05 01 00 00       	jmp    f0104b10 <vprintfmt+0x3fa>
	if (lflag >= 2)
f0104a0b:	83 f9 01             	cmp    $0x1,%ecx
f0104a0e:	7e 18                	jle    f0104a28 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
f0104a10:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a13:	8b 10                	mov    (%eax),%edx
f0104a15:	8b 48 04             	mov    0x4(%eax),%ecx
f0104a18:	8d 40 08             	lea    0x8(%eax),%eax
f0104a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104a1e:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104a23:	e9 e8 00 00 00       	jmp    f0104b10 <vprintfmt+0x3fa>
	else if (lflag)
f0104a28:	85 c9                	test   %ecx,%ecx
f0104a2a:	75 1a                	jne    f0104a46 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
f0104a2c:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a2f:	8b 10                	mov    (%eax),%edx
f0104a31:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104a36:	8d 40 04             	lea    0x4(%eax),%eax
f0104a39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104a3c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104a41:	e9 ca 00 00 00       	jmp    f0104b10 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
f0104a46:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a49:	8b 10                	mov    (%eax),%edx
f0104a4b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104a50:	8d 40 04             	lea    0x4(%eax),%eax
f0104a53:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0104a56:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104a5b:	e9 b0 00 00 00       	jmp    f0104b10 <vprintfmt+0x3fa>
	if (lflag >= 2)
f0104a60:	83 f9 01             	cmp    $0x1,%ecx
f0104a63:	7e 3c                	jle    f0104aa1 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
f0104a65:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a68:	8b 50 04             	mov    0x4(%eax),%edx
f0104a6b:	8b 00                	mov    (%eax),%eax
f0104a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104a70:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104a73:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a76:	8d 40 08             	lea    0x8(%eax),%eax
f0104a79:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
f0104a7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0104a80:	79 59                	jns    f0104adb <vprintfmt+0x3c5>
                putch('-', putdat);
f0104a82:	83 ec 08             	sub    $0x8,%esp
f0104a85:	53                   	push   %ebx
f0104a86:	6a 2d                	push   $0x2d
f0104a88:	ff d6                	call   *%esi
                num = -(long long) num;
f0104a8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104a8d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0104a90:	f7 da                	neg    %edx
f0104a92:	83 d1 00             	adc    $0x0,%ecx
f0104a95:	f7 d9                	neg    %ecx
f0104a97:	83 c4 10             	add    $0x10,%esp
            base = 8;
f0104a9a:	b8 08 00 00 00       	mov    $0x8,%eax
f0104a9f:	eb 6f                	jmp    f0104b10 <vprintfmt+0x3fa>
	else if (lflag)
f0104aa1:	85 c9                	test   %ecx,%ecx
f0104aa3:	75 1b                	jne    f0104ac0 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
f0104aa5:	8b 45 14             	mov    0x14(%ebp),%eax
f0104aa8:	8b 00                	mov    (%eax),%eax
f0104aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104aad:	89 c1                	mov    %eax,%ecx
f0104aaf:	c1 f9 1f             	sar    $0x1f,%ecx
f0104ab2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0104ab5:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ab8:	8d 40 04             	lea    0x4(%eax),%eax
f0104abb:	89 45 14             	mov    %eax,0x14(%ebp)
f0104abe:	eb bc                	jmp    f0104a7c <vprintfmt+0x366>
		return va_arg(*ap, long);
f0104ac0:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ac3:	8b 00                	mov    (%eax),%eax
f0104ac5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104ac8:	89 c1                	mov    %eax,%ecx
f0104aca:	c1 f9 1f             	sar    $0x1f,%ecx
f0104acd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0104ad0:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ad3:	8d 40 04             	lea    0x4(%eax),%eax
f0104ad6:	89 45 14             	mov    %eax,0x14(%ebp)
f0104ad9:	eb a1                	jmp    f0104a7c <vprintfmt+0x366>
            num = getint(&ap, lflag);
f0104adb:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104ade:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
f0104ae1:	b8 08 00 00 00       	mov    $0x8,%eax
f0104ae6:	eb 28                	jmp    f0104b10 <vprintfmt+0x3fa>
			putch('0', putdat);
f0104ae8:	83 ec 08             	sub    $0x8,%esp
f0104aeb:	53                   	push   %ebx
f0104aec:	6a 30                	push   $0x30
f0104aee:	ff d6                	call   *%esi
			putch('x', putdat);
f0104af0:	83 c4 08             	add    $0x8,%esp
f0104af3:	53                   	push   %ebx
f0104af4:	6a 78                	push   $0x78
f0104af6:	ff d6                	call   *%esi
			num = (unsigned long long)
f0104af8:	8b 45 14             	mov    0x14(%ebp),%eax
f0104afb:	8b 10                	mov    (%eax),%edx
f0104afd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f0104b02:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0104b05:	8d 40 04             	lea    0x4(%eax),%eax
f0104b08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104b0b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0104b10:	83 ec 0c             	sub    $0xc,%esp
f0104b13:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0104b17:	57                   	push   %edi
f0104b18:	ff 75 e0             	pushl  -0x20(%ebp)
f0104b1b:	50                   	push   %eax
f0104b1c:	51                   	push   %ecx
f0104b1d:	52                   	push   %edx
f0104b1e:	89 da                	mov    %ebx,%edx
f0104b20:	89 f0                	mov    %esi,%eax
f0104b22:	e8 06 fb ff ff       	call   f010462d <printnum>
			break;
f0104b27:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0104b2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104b2d:	83 c7 01             	add    $0x1,%edi
f0104b30:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0104b34:	83 f8 25             	cmp    $0x25,%eax
f0104b37:	0f 84 f0 fb ff ff    	je     f010472d <vprintfmt+0x17>
			if (ch == '\0')
f0104b3d:	85 c0                	test   %eax,%eax
f0104b3f:	0f 84 8b 00 00 00    	je     f0104bd0 <vprintfmt+0x4ba>
			putch(ch, putdat);
f0104b45:	83 ec 08             	sub    $0x8,%esp
f0104b48:	53                   	push   %ebx
f0104b49:	50                   	push   %eax
f0104b4a:	ff d6                	call   *%esi
f0104b4c:	83 c4 10             	add    $0x10,%esp
f0104b4f:	eb dc                	jmp    f0104b2d <vprintfmt+0x417>
	if (lflag >= 2)
f0104b51:	83 f9 01             	cmp    $0x1,%ecx
f0104b54:	7e 15                	jle    f0104b6b <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
f0104b56:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b59:	8b 10                	mov    (%eax),%edx
f0104b5b:	8b 48 04             	mov    0x4(%eax),%ecx
f0104b5e:	8d 40 08             	lea    0x8(%eax),%eax
f0104b61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104b64:	b8 10 00 00 00       	mov    $0x10,%eax
f0104b69:	eb a5                	jmp    f0104b10 <vprintfmt+0x3fa>
	else if (lflag)
f0104b6b:	85 c9                	test   %ecx,%ecx
f0104b6d:	75 17                	jne    f0104b86 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
f0104b6f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b72:	8b 10                	mov    (%eax),%edx
f0104b74:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104b79:	8d 40 04             	lea    0x4(%eax),%eax
f0104b7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104b7f:	b8 10 00 00 00       	mov    $0x10,%eax
f0104b84:	eb 8a                	jmp    f0104b10 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
f0104b86:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b89:	8b 10                	mov    (%eax),%edx
f0104b8b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104b90:	8d 40 04             	lea    0x4(%eax),%eax
f0104b93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0104b96:	b8 10 00 00 00       	mov    $0x10,%eax
f0104b9b:	e9 70 ff ff ff       	jmp    f0104b10 <vprintfmt+0x3fa>
			putch(ch, putdat);
f0104ba0:	83 ec 08             	sub    $0x8,%esp
f0104ba3:	53                   	push   %ebx
f0104ba4:	6a 25                	push   $0x25
f0104ba6:	ff d6                	call   *%esi
			break;
f0104ba8:	83 c4 10             	add    $0x10,%esp
f0104bab:	e9 7a ff ff ff       	jmp    f0104b2a <vprintfmt+0x414>
			putch('%', putdat);
f0104bb0:	83 ec 08             	sub    $0x8,%esp
f0104bb3:	53                   	push   %ebx
f0104bb4:	6a 25                	push   $0x25
f0104bb6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0104bb8:	83 c4 10             	add    $0x10,%esp
f0104bbb:	89 f8                	mov    %edi,%eax
f0104bbd:	eb 03                	jmp    f0104bc2 <vprintfmt+0x4ac>
f0104bbf:	83 e8 01             	sub    $0x1,%eax
f0104bc2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0104bc6:	75 f7                	jne    f0104bbf <vprintfmt+0x4a9>
f0104bc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104bcb:	e9 5a ff ff ff       	jmp    f0104b2a <vprintfmt+0x414>
}
f0104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104bd3:	5b                   	pop    %ebx
f0104bd4:	5e                   	pop    %esi
f0104bd5:	5f                   	pop    %edi
f0104bd6:	5d                   	pop    %ebp
f0104bd7:	c3                   	ret    

f0104bd8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0104bd8:	55                   	push   %ebp
f0104bd9:	89 e5                	mov    %esp,%ebp
f0104bdb:	83 ec 18             	sub    $0x18,%esp
f0104bde:	8b 45 08             	mov    0x8(%ebp),%eax
f0104be1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0104be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104be7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0104beb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0104bee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0104bf5:	85 c0                	test   %eax,%eax
f0104bf7:	74 26                	je     f0104c1f <vsnprintf+0x47>
f0104bf9:	85 d2                	test   %edx,%edx
f0104bfb:	7e 22                	jle    f0104c1f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0104bfd:	ff 75 14             	pushl  0x14(%ebp)
f0104c00:	ff 75 10             	pushl  0x10(%ebp)
f0104c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104c06:	50                   	push   %eax
f0104c07:	68 dc 46 10 f0       	push   $0xf01046dc
f0104c0c:	e8 05 fb ff ff       	call   f0104716 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104c14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0104c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104c1a:	83 c4 10             	add    $0x10,%esp
}
f0104c1d:	c9                   	leave  
f0104c1e:	c3                   	ret    
		return -E_INVAL;
f0104c1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c24:	eb f7                	jmp    f0104c1d <vsnprintf+0x45>

f0104c26 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0104c26:	55                   	push   %ebp
f0104c27:	89 e5                	mov    %esp,%ebp
f0104c29:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0104c2c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0104c2f:	50                   	push   %eax
f0104c30:	ff 75 10             	pushl  0x10(%ebp)
f0104c33:	ff 75 0c             	pushl  0xc(%ebp)
f0104c36:	ff 75 08             	pushl  0x8(%ebp)
f0104c39:	e8 9a ff ff ff       	call   f0104bd8 <vsnprintf>
	va_end(ap);

	return rc;
}
f0104c3e:	c9                   	leave  
f0104c3f:	c3                   	ret    

f0104c40 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104c40:	55                   	push   %ebp
f0104c41:	89 e5                	mov    %esp,%ebp
f0104c43:	57                   	push   %edi
f0104c44:	56                   	push   %esi
f0104c45:	53                   	push   %ebx
f0104c46:	83 ec 0c             	sub    $0xc,%esp
f0104c49:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0104c4c:	85 c0                	test   %eax,%eax
f0104c4e:	74 11                	je     f0104c61 <readline+0x21>
		cprintf("%s", prompt);
f0104c50:	83 ec 08             	sub    $0x8,%esp
f0104c53:	50                   	push   %eax
f0104c54:	68 f3 6e 10 f0       	push   $0xf0106ef3
f0104c59:	e8 d2 ee ff ff       	call   f0103b30 <cprintf>
f0104c5e:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0104c61:	83 ec 0c             	sub    $0xc,%esp
f0104c64:	6a 00                	push   $0x0
f0104c66:	e8 0b bb ff ff       	call   f0100776 <iscons>
f0104c6b:	89 c7                	mov    %eax,%edi
f0104c6d:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0104c70:	be 00 00 00 00       	mov    $0x0,%esi
f0104c75:	eb 3f                	jmp    f0104cb6 <readline+0x76>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f0104c77:	83 ec 08             	sub    $0x8,%esp
f0104c7a:	50                   	push   %eax
f0104c7b:	68 44 80 10 f0       	push   $0xf0108044
f0104c80:	e8 ab ee ff ff       	call   f0103b30 <cprintf>
			return NULL;
f0104c85:	83 c4 10             	add    $0x10,%esp
f0104c88:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0104c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104c90:	5b                   	pop    %ebx
f0104c91:	5e                   	pop    %esi
f0104c92:	5f                   	pop    %edi
f0104c93:	5d                   	pop    %ebp
f0104c94:	c3                   	ret    
			if (echoing)
f0104c95:	85 ff                	test   %edi,%edi
f0104c97:	75 05                	jne    f0104c9e <readline+0x5e>
			i--;
f0104c99:	83 ee 01             	sub    $0x1,%esi
f0104c9c:	eb 18                	jmp    f0104cb6 <readline+0x76>
				cputchar('\b');
f0104c9e:	83 ec 0c             	sub    $0xc,%esp
f0104ca1:	6a 08                	push   $0x8
f0104ca3:	e8 ad ba ff ff       	call   f0100755 <cputchar>
f0104ca8:	83 c4 10             	add    $0x10,%esp
f0104cab:	eb ec                	jmp    f0104c99 <readline+0x59>
			buf[i++] = c;
f0104cad:	88 9e 00 cb 22 f0    	mov    %bl,-0xfdd3500(%esi)
f0104cb3:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f0104cb6:	e8 aa ba ff ff       	call   f0100765 <getchar>
f0104cbb:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0104cbd:	85 c0                	test   %eax,%eax
f0104cbf:	78 b6                	js     f0104c77 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104cc1:	83 f8 08             	cmp    $0x8,%eax
f0104cc4:	0f 94 c2             	sete   %dl
f0104cc7:	83 f8 7f             	cmp    $0x7f,%eax
f0104cca:	0f 94 c0             	sete   %al
f0104ccd:	08 c2                	or     %al,%dl
f0104ccf:	74 04                	je     f0104cd5 <readline+0x95>
f0104cd1:	85 f6                	test   %esi,%esi
f0104cd3:	7f c0                	jg     f0104c95 <readline+0x55>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0104cd5:	83 fb 1f             	cmp    $0x1f,%ebx
f0104cd8:	7e 1a                	jle    f0104cf4 <readline+0xb4>
f0104cda:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0104ce0:	7f 12                	jg     f0104cf4 <readline+0xb4>
			if (echoing)
f0104ce2:	85 ff                	test   %edi,%edi
f0104ce4:	74 c7                	je     f0104cad <readline+0x6d>
				cputchar(c);
f0104ce6:	83 ec 0c             	sub    $0xc,%esp
f0104ce9:	53                   	push   %ebx
f0104cea:	e8 66 ba ff ff       	call   f0100755 <cputchar>
f0104cef:	83 c4 10             	add    $0x10,%esp
f0104cf2:	eb b9                	jmp    f0104cad <readline+0x6d>
		} else if (c == '\n' || c == '\r') {
f0104cf4:	83 fb 0a             	cmp    $0xa,%ebx
f0104cf7:	74 05                	je     f0104cfe <readline+0xbe>
f0104cf9:	83 fb 0d             	cmp    $0xd,%ebx
f0104cfc:	75 b8                	jne    f0104cb6 <readline+0x76>
			if (echoing)
f0104cfe:	85 ff                	test   %edi,%edi
f0104d00:	75 11                	jne    f0104d13 <readline+0xd3>
			buf[i] = 0;
f0104d02:	c6 86 00 cb 22 f0 00 	movb   $0x0,-0xfdd3500(%esi)
			return buf;
f0104d09:	b8 00 cb 22 f0       	mov    $0xf022cb00,%eax
f0104d0e:	e9 7a ff ff ff       	jmp    f0104c8d <readline+0x4d>
				cputchar('\n');
f0104d13:	83 ec 0c             	sub    $0xc,%esp
f0104d16:	6a 0a                	push   $0xa
f0104d18:	e8 38 ba ff ff       	call   f0100755 <cputchar>
f0104d1d:	83 c4 10             	add    $0x10,%esp
f0104d20:	eb e0                	jmp    f0104d02 <readline+0xc2>

f0104d22 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0104d22:	55                   	push   %ebp
f0104d23:	89 e5                	mov    %esp,%ebp
f0104d25:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104d28:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d2d:	eb 03                	jmp    f0104d32 <strlen+0x10>
		n++;
f0104d2f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0104d32:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0104d36:	75 f7                	jne    f0104d2f <strlen+0xd>
	return n;
}
f0104d38:	5d                   	pop    %ebp
f0104d39:	c3                   	ret    

f0104d3a <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104d3a:	55                   	push   %ebp
f0104d3b:	89 e5                	mov    %esp,%ebp
f0104d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104d40:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104d43:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d48:	eb 03                	jmp    f0104d4d <strnlen+0x13>
		n++;
f0104d4a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104d4d:	39 d0                	cmp    %edx,%eax
f0104d4f:	74 06                	je     f0104d57 <strnlen+0x1d>
f0104d51:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0104d55:	75 f3                	jne    f0104d4a <strnlen+0x10>
	return n;
}
f0104d57:	5d                   	pop    %ebp
f0104d58:	c3                   	ret    

f0104d59 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0104d59:	55                   	push   %ebp
f0104d5a:	89 e5                	mov    %esp,%ebp
f0104d5c:	53                   	push   %ebx
f0104d5d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104d60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0104d63:	89 c2                	mov    %eax,%edx
f0104d65:	83 c1 01             	add    $0x1,%ecx
f0104d68:	83 c2 01             	add    $0x1,%edx
f0104d6b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0104d6f:	88 5a ff             	mov    %bl,-0x1(%edx)
f0104d72:	84 db                	test   %bl,%bl
f0104d74:	75 ef                	jne    f0104d65 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0104d76:	5b                   	pop    %ebx
f0104d77:	5d                   	pop    %ebp
f0104d78:	c3                   	ret    

f0104d79 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0104d79:	55                   	push   %ebp
f0104d7a:	89 e5                	mov    %esp,%ebp
f0104d7c:	53                   	push   %ebx
f0104d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0104d80:	53                   	push   %ebx
f0104d81:	e8 9c ff ff ff       	call   f0104d22 <strlen>
f0104d86:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0104d89:	ff 75 0c             	pushl  0xc(%ebp)
f0104d8c:	01 d8                	add    %ebx,%eax
f0104d8e:	50                   	push   %eax
f0104d8f:	e8 c5 ff ff ff       	call   f0104d59 <strcpy>
	return dst;
}
f0104d94:	89 d8                	mov    %ebx,%eax
f0104d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104d99:	c9                   	leave  
f0104d9a:	c3                   	ret    

f0104d9b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0104d9b:	55                   	push   %ebp
f0104d9c:	89 e5                	mov    %esp,%ebp
f0104d9e:	56                   	push   %esi
f0104d9f:	53                   	push   %ebx
f0104da0:	8b 75 08             	mov    0x8(%ebp),%esi
f0104da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104da6:	89 f3                	mov    %esi,%ebx
f0104da8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0104dab:	89 f2                	mov    %esi,%edx
f0104dad:	eb 0f                	jmp    f0104dbe <strncpy+0x23>
		*dst++ = *src;
f0104daf:	83 c2 01             	add    $0x1,%edx
f0104db2:	0f b6 01             	movzbl (%ecx),%eax
f0104db5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0104db8:	80 39 01             	cmpb   $0x1,(%ecx)
f0104dbb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f0104dbe:	39 da                	cmp    %ebx,%edx
f0104dc0:	75 ed                	jne    f0104daf <strncpy+0x14>
	}
	return ret;
}
f0104dc2:	89 f0                	mov    %esi,%eax
f0104dc4:	5b                   	pop    %ebx
f0104dc5:	5e                   	pop    %esi
f0104dc6:	5d                   	pop    %ebp
f0104dc7:	c3                   	ret    

f0104dc8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0104dc8:	55                   	push   %ebp
f0104dc9:	89 e5                	mov    %esp,%ebp
f0104dcb:	56                   	push   %esi
f0104dcc:	53                   	push   %ebx
f0104dcd:	8b 75 08             	mov    0x8(%ebp),%esi
f0104dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104dd3:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104dd6:	89 f0                	mov    %esi,%eax
f0104dd8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0104ddc:	85 c9                	test   %ecx,%ecx
f0104dde:	75 0b                	jne    f0104deb <strlcpy+0x23>
f0104de0:	eb 17                	jmp    f0104df9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0104de2:	83 c2 01             	add    $0x1,%edx
f0104de5:	83 c0 01             	add    $0x1,%eax
f0104de8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0104deb:	39 d8                	cmp    %ebx,%eax
f0104ded:	74 07                	je     f0104df6 <strlcpy+0x2e>
f0104def:	0f b6 0a             	movzbl (%edx),%ecx
f0104df2:	84 c9                	test   %cl,%cl
f0104df4:	75 ec                	jne    f0104de2 <strlcpy+0x1a>
		*dst = '\0';
f0104df6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0104df9:	29 f0                	sub    %esi,%eax
}
f0104dfb:	5b                   	pop    %ebx
f0104dfc:	5e                   	pop    %esi
f0104dfd:	5d                   	pop    %ebp
f0104dfe:	c3                   	ret    

f0104dff <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0104dff:	55                   	push   %ebp
f0104e00:	89 e5                	mov    %esp,%ebp
f0104e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104e05:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0104e08:	eb 06                	jmp    f0104e10 <strcmp+0x11>
		p++, q++;
f0104e0a:	83 c1 01             	add    $0x1,%ecx
f0104e0d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0104e10:	0f b6 01             	movzbl (%ecx),%eax
f0104e13:	84 c0                	test   %al,%al
f0104e15:	74 04                	je     f0104e1b <strcmp+0x1c>
f0104e17:	3a 02                	cmp    (%edx),%al
f0104e19:	74 ef                	je     f0104e0a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0104e1b:	0f b6 c0             	movzbl %al,%eax
f0104e1e:	0f b6 12             	movzbl (%edx),%edx
f0104e21:	29 d0                	sub    %edx,%eax
}
f0104e23:	5d                   	pop    %ebp
f0104e24:	c3                   	ret    

f0104e25 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0104e25:	55                   	push   %ebp
f0104e26:	89 e5                	mov    %esp,%ebp
f0104e28:	53                   	push   %ebx
f0104e29:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104e2f:	89 c3                	mov    %eax,%ebx
f0104e31:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0104e34:	eb 06                	jmp    f0104e3c <strncmp+0x17>
		n--, p++, q++;
f0104e36:	83 c0 01             	add    $0x1,%eax
f0104e39:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0104e3c:	39 d8                	cmp    %ebx,%eax
f0104e3e:	74 16                	je     f0104e56 <strncmp+0x31>
f0104e40:	0f b6 08             	movzbl (%eax),%ecx
f0104e43:	84 c9                	test   %cl,%cl
f0104e45:	74 04                	je     f0104e4b <strncmp+0x26>
f0104e47:	3a 0a                	cmp    (%edx),%cl
f0104e49:	74 eb                	je     f0104e36 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0104e4b:	0f b6 00             	movzbl (%eax),%eax
f0104e4e:	0f b6 12             	movzbl (%edx),%edx
f0104e51:	29 d0                	sub    %edx,%eax
}
f0104e53:	5b                   	pop    %ebx
f0104e54:	5d                   	pop    %ebp
f0104e55:	c3                   	ret    
		return 0;
f0104e56:	b8 00 00 00 00       	mov    $0x0,%eax
f0104e5b:	eb f6                	jmp    f0104e53 <strncmp+0x2e>

f0104e5d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0104e5d:	55                   	push   %ebp
f0104e5e:	89 e5                	mov    %esp,%ebp
f0104e60:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e63:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0104e67:	0f b6 10             	movzbl (%eax),%edx
f0104e6a:	84 d2                	test   %dl,%dl
f0104e6c:	74 09                	je     f0104e77 <strchr+0x1a>
		if (*s == c)
f0104e6e:	38 ca                	cmp    %cl,%dl
f0104e70:	74 0a                	je     f0104e7c <strchr+0x1f>
	for (; *s; s++)
f0104e72:	83 c0 01             	add    $0x1,%eax
f0104e75:	eb f0                	jmp    f0104e67 <strchr+0xa>
			return (char *) s;
	return 0;
f0104e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104e7c:	5d                   	pop    %ebp
f0104e7d:	c3                   	ret    

f0104e7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0104e7e:	55                   	push   %ebp
f0104e7f:	89 e5                	mov    %esp,%ebp
f0104e81:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0104e88:	eb 03                	jmp    f0104e8d <strfind+0xf>
f0104e8a:	83 c0 01             	add    $0x1,%eax
f0104e8d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0104e90:	38 ca                	cmp    %cl,%dl
f0104e92:	74 04                	je     f0104e98 <strfind+0x1a>
f0104e94:	84 d2                	test   %dl,%dl
f0104e96:	75 f2                	jne    f0104e8a <strfind+0xc>
			break;
	return (char *) s;
}
f0104e98:	5d                   	pop    %ebp
f0104e99:	c3                   	ret    

f0104e9a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0104e9a:	55                   	push   %ebp
f0104e9b:	89 e5                	mov    %esp,%ebp
f0104e9d:	57                   	push   %edi
f0104e9e:	56                   	push   %esi
f0104e9f:	53                   	push   %ebx
f0104ea0:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104ea3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0104ea6:	85 c9                	test   %ecx,%ecx
f0104ea8:	74 13                	je     f0104ebd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0104eaa:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104eb0:	75 05                	jne    f0104eb7 <memset+0x1d>
f0104eb2:	f6 c1 03             	test   $0x3,%cl
f0104eb5:	74 0d                	je     f0104ec4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0104eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104eba:	fc                   	cld    
f0104ebb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0104ebd:	89 f8                	mov    %edi,%eax
f0104ebf:	5b                   	pop    %ebx
f0104ec0:	5e                   	pop    %esi
f0104ec1:	5f                   	pop    %edi
f0104ec2:	5d                   	pop    %ebp
f0104ec3:	c3                   	ret    
		c &= 0xFF;
f0104ec4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0104ec8:	89 d3                	mov    %edx,%ebx
f0104eca:	c1 e3 08             	shl    $0x8,%ebx
f0104ecd:	89 d0                	mov    %edx,%eax
f0104ecf:	c1 e0 18             	shl    $0x18,%eax
f0104ed2:	89 d6                	mov    %edx,%esi
f0104ed4:	c1 e6 10             	shl    $0x10,%esi
f0104ed7:	09 f0                	or     %esi,%eax
f0104ed9:	09 c2                	or     %eax,%edx
f0104edb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0104edd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0104ee0:	89 d0                	mov    %edx,%eax
f0104ee2:	fc                   	cld    
f0104ee3:	f3 ab                	rep stos %eax,%es:(%edi)
f0104ee5:	eb d6                	jmp    f0104ebd <memset+0x23>

f0104ee7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0104ee7:	55                   	push   %ebp
f0104ee8:	89 e5                	mov    %esp,%ebp
f0104eea:	57                   	push   %edi
f0104eeb:	56                   	push   %esi
f0104eec:	8b 45 08             	mov    0x8(%ebp),%eax
f0104eef:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104ef2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0104ef5:	39 c6                	cmp    %eax,%esi
f0104ef7:	73 35                	jae    f0104f2e <memmove+0x47>
f0104ef9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0104efc:	39 c2                	cmp    %eax,%edx
f0104efe:	76 2e                	jbe    f0104f2e <memmove+0x47>
		s += n;
		d += n;
f0104f00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104f03:	89 d6                	mov    %edx,%esi
f0104f05:	09 fe                	or     %edi,%esi
f0104f07:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0104f0d:	74 0c                	je     f0104f1b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0104f0f:	83 ef 01             	sub    $0x1,%edi
f0104f12:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0104f15:	fd                   	std    
f0104f16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0104f18:	fc                   	cld    
f0104f19:	eb 21                	jmp    f0104f3c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104f1b:	f6 c1 03             	test   $0x3,%cl
f0104f1e:	75 ef                	jne    f0104f0f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0104f20:	83 ef 04             	sub    $0x4,%edi
f0104f23:	8d 72 fc             	lea    -0x4(%edx),%esi
f0104f26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0104f29:	fd                   	std    
f0104f2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104f2c:	eb ea                	jmp    f0104f18 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104f2e:	89 f2                	mov    %esi,%edx
f0104f30:	09 c2                	or     %eax,%edx
f0104f32:	f6 c2 03             	test   $0x3,%dl
f0104f35:	74 09                	je     f0104f40 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0104f37:	89 c7                	mov    %eax,%edi
f0104f39:	fc                   	cld    
f0104f3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0104f3c:	5e                   	pop    %esi
f0104f3d:	5f                   	pop    %edi
f0104f3e:	5d                   	pop    %ebp
f0104f3f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104f40:	f6 c1 03             	test   $0x3,%cl
f0104f43:	75 f2                	jne    f0104f37 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0104f45:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0104f48:	89 c7                	mov    %eax,%edi
f0104f4a:	fc                   	cld    
f0104f4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104f4d:	eb ed                	jmp    f0104f3c <memmove+0x55>

f0104f4f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0104f4f:	55                   	push   %ebp
f0104f50:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0104f52:	ff 75 10             	pushl  0x10(%ebp)
f0104f55:	ff 75 0c             	pushl  0xc(%ebp)
f0104f58:	ff 75 08             	pushl  0x8(%ebp)
f0104f5b:	e8 87 ff ff ff       	call   f0104ee7 <memmove>
}
f0104f60:	c9                   	leave  
f0104f61:	c3                   	ret    

f0104f62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0104f62:	55                   	push   %ebp
f0104f63:	89 e5                	mov    %esp,%ebp
f0104f65:	56                   	push   %esi
f0104f66:	53                   	push   %ebx
f0104f67:	8b 45 08             	mov    0x8(%ebp),%eax
f0104f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104f6d:	89 c6                	mov    %eax,%esi
f0104f6f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0104f72:	39 f0                	cmp    %esi,%eax
f0104f74:	74 1c                	je     f0104f92 <memcmp+0x30>
		if (*s1 != *s2)
f0104f76:	0f b6 08             	movzbl (%eax),%ecx
f0104f79:	0f b6 1a             	movzbl (%edx),%ebx
f0104f7c:	38 d9                	cmp    %bl,%cl
f0104f7e:	75 08                	jne    f0104f88 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0104f80:	83 c0 01             	add    $0x1,%eax
f0104f83:	83 c2 01             	add    $0x1,%edx
f0104f86:	eb ea                	jmp    f0104f72 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0104f88:	0f b6 c1             	movzbl %cl,%eax
f0104f8b:	0f b6 db             	movzbl %bl,%ebx
f0104f8e:	29 d8                	sub    %ebx,%eax
f0104f90:	eb 05                	jmp    f0104f97 <memcmp+0x35>
	}

	return 0;
f0104f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104f97:	5b                   	pop    %ebx
f0104f98:	5e                   	pop    %esi
f0104f99:	5d                   	pop    %ebp
f0104f9a:	c3                   	ret    

f0104f9b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0104f9b:	55                   	push   %ebp
f0104f9c:	89 e5                	mov    %esp,%ebp
f0104f9e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0104fa4:	89 c2                	mov    %eax,%edx
f0104fa6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0104fa9:	39 d0                	cmp    %edx,%eax
f0104fab:	73 09                	jae    f0104fb6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0104fad:	38 08                	cmp    %cl,(%eax)
f0104faf:	74 05                	je     f0104fb6 <memfind+0x1b>
	for (; s < ends; s++)
f0104fb1:	83 c0 01             	add    $0x1,%eax
f0104fb4:	eb f3                	jmp    f0104fa9 <memfind+0xe>
			break;
	return (void *) s;
}
f0104fb6:	5d                   	pop    %ebp
f0104fb7:	c3                   	ret    

f0104fb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0104fb8:	55                   	push   %ebp
f0104fb9:	89 e5                	mov    %esp,%ebp
f0104fbb:	57                   	push   %edi
f0104fbc:	56                   	push   %esi
f0104fbd:	53                   	push   %ebx
f0104fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104fc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0104fc4:	eb 03                	jmp    f0104fc9 <strtol+0x11>
		s++;
f0104fc6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0104fc9:	0f b6 01             	movzbl (%ecx),%eax
f0104fcc:	3c 20                	cmp    $0x20,%al
f0104fce:	74 f6                	je     f0104fc6 <strtol+0xe>
f0104fd0:	3c 09                	cmp    $0x9,%al
f0104fd2:	74 f2                	je     f0104fc6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0104fd4:	3c 2b                	cmp    $0x2b,%al
f0104fd6:	74 2e                	je     f0105006 <strtol+0x4e>
	int neg = 0;
f0104fd8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0104fdd:	3c 2d                	cmp    $0x2d,%al
f0104fdf:	74 2f                	je     f0105010 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0104fe1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0104fe7:	75 05                	jne    f0104fee <strtol+0x36>
f0104fe9:	80 39 30             	cmpb   $0x30,(%ecx)
f0104fec:	74 2c                	je     f010501a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0104fee:	85 db                	test   %ebx,%ebx
f0104ff0:	75 0a                	jne    f0104ffc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0104ff2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f0104ff7:	80 39 30             	cmpb   $0x30,(%ecx)
f0104ffa:	74 28                	je     f0105024 <strtol+0x6c>
		base = 10;
f0104ffc:	b8 00 00 00 00       	mov    $0x0,%eax
f0105001:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105004:	eb 50                	jmp    f0105056 <strtol+0x9e>
		s++;
f0105006:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105009:	bf 00 00 00 00       	mov    $0x0,%edi
f010500e:	eb d1                	jmp    f0104fe1 <strtol+0x29>
		s++, neg = 1;
f0105010:	83 c1 01             	add    $0x1,%ecx
f0105013:	bf 01 00 00 00       	mov    $0x1,%edi
f0105018:	eb c7                	jmp    f0104fe1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010501a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010501e:	74 0e                	je     f010502e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105020:	85 db                	test   %ebx,%ebx
f0105022:	75 d8                	jne    f0104ffc <strtol+0x44>
		s++, base = 8;
f0105024:	83 c1 01             	add    $0x1,%ecx
f0105027:	bb 08 00 00 00       	mov    $0x8,%ebx
f010502c:	eb ce                	jmp    f0104ffc <strtol+0x44>
		s += 2, base = 16;
f010502e:	83 c1 02             	add    $0x2,%ecx
f0105031:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105036:	eb c4                	jmp    f0104ffc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105038:	8d 72 9f             	lea    -0x61(%edx),%esi
f010503b:	89 f3                	mov    %esi,%ebx
f010503d:	80 fb 19             	cmp    $0x19,%bl
f0105040:	77 29                	ja     f010506b <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105042:	0f be d2             	movsbl %dl,%edx
f0105045:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105048:	3b 55 10             	cmp    0x10(%ebp),%edx
f010504b:	7d 30                	jge    f010507d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f010504d:	83 c1 01             	add    $0x1,%ecx
f0105050:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105054:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105056:	0f b6 11             	movzbl (%ecx),%edx
f0105059:	8d 72 d0             	lea    -0x30(%edx),%esi
f010505c:	89 f3                	mov    %esi,%ebx
f010505e:	80 fb 09             	cmp    $0x9,%bl
f0105061:	77 d5                	ja     f0105038 <strtol+0x80>
			dig = *s - '0';
f0105063:	0f be d2             	movsbl %dl,%edx
f0105066:	83 ea 30             	sub    $0x30,%edx
f0105069:	eb dd                	jmp    f0105048 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f010506b:	8d 72 bf             	lea    -0x41(%edx),%esi
f010506e:	89 f3                	mov    %esi,%ebx
f0105070:	80 fb 19             	cmp    $0x19,%bl
f0105073:	77 08                	ja     f010507d <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105075:	0f be d2             	movsbl %dl,%edx
f0105078:	83 ea 37             	sub    $0x37,%edx
f010507b:	eb cb                	jmp    f0105048 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f010507d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105081:	74 05                	je     f0105088 <strtol+0xd0>
		*endptr = (char *) s;
f0105083:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105086:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105088:	89 c2                	mov    %eax,%edx
f010508a:	f7 da                	neg    %edx
f010508c:	85 ff                	test   %edi,%edi
f010508e:	0f 45 c2             	cmovne %edx,%eax
}
f0105091:	5b                   	pop    %ebx
f0105092:	5e                   	pop    %esi
f0105093:	5f                   	pop    %edi
f0105094:	5d                   	pop    %ebp
f0105095:	c3                   	ret    
f0105096:	66 90                	xchg   %ax,%ax

f0105098 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105098:	fa                   	cli    

	xorw    %ax, %ax
f0105099:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010509b:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f010509d:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f010509f:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01050a1:	0f 01 16             	lgdtl  (%esi)
f01050a4:	74 70                	je     f0105116 <mpsearch1+0x3>
	movl    %cr0, %eax
f01050a6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01050a9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01050ad:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01050b0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01050b6:	08 00                	or     %al,(%eax)

f01050b8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01050b8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01050bc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01050be:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01050c0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01050c2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01050c6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01050c8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01050ca:	b8 00 f0 11 00       	mov    $0x11f000,%eax
	movl    %eax, %cr3
f01050cf:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01050d2:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01050d5:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01050da:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01050dd:	8b 25 08 cf 22 f0    	mov    0xf022cf08,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01050e3:	bd 00 00 00 00       	mov    $0x0,%ebp

	//??? not understand temporary
	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01050e8:	b8 94 01 10 f0       	mov    $0xf0100194,%eax
	call    *%eax
f01050ed:	ff d0                	call   *%eax

f01050ef <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01050ef:	eb fe                	jmp    f01050ef <spin>
f01050f1:	8d 76 00             	lea    0x0(%esi),%esi

f01050f4 <gdt>:
	...
f01050fc:	ff                   	(bad)  
f01050fd:	ff 00                	incl   (%eax)
f01050ff:	00 00                	add    %al,(%eax)
f0105101:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105108:	00                   	.byte 0x0
f0105109:	92                   	xchg   %eax,%edx
f010510a:	cf                   	iret   
	...

f010510c <gdtdesc>:
f010510c:	17                   	pop    %ss
f010510d:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105112 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105112:	90                   	nop

f0105113 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105113:	55                   	push   %ebp
f0105114:	89 e5                	mov    %esp,%ebp
f0105116:	57                   	push   %edi
f0105117:	56                   	push   %esi
f0105118:	53                   	push   %ebx
f0105119:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f010511c:	8b 0d 0c cf 22 f0    	mov    0xf022cf0c,%ecx
f0105122:	89 c3                	mov    %eax,%ebx
f0105124:	c1 eb 0c             	shr    $0xc,%ebx
f0105127:	39 cb                	cmp    %ecx,%ebx
f0105129:	73 1a                	jae    f0105145 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010512b:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105131:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f0105134:	89 f0                	mov    %esi,%eax
f0105136:	c1 e8 0c             	shr    $0xc,%eax
f0105139:	39 c8                	cmp    %ecx,%eax
f010513b:	73 1a                	jae    f0105157 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f010513d:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f0105143:	eb 27                	jmp    f010516c <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105145:	50                   	push   %eax
f0105146:	68 24 5b 10 f0       	push   $0xf0105b24
f010514b:	6a 57                	push   $0x57
f010514d:	68 e1 81 10 f0       	push   $0xf01081e1
f0105152:	e8 e9 ae ff ff       	call   f0100040 <_panic>
f0105157:	56                   	push   %esi
f0105158:	68 24 5b 10 f0       	push   $0xf0105b24
f010515d:	6a 57                	push   $0x57
f010515f:	68 e1 81 10 f0       	push   $0xf01081e1
f0105164:	e8 d7 ae ff ff       	call   f0100040 <_panic>
f0105169:	83 c3 10             	add    $0x10,%ebx
f010516c:	39 f3                	cmp    %esi,%ebx
f010516e:	73 2e                	jae    f010519e <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105170:	83 ec 04             	sub    $0x4,%esp
f0105173:	6a 04                	push   $0x4
f0105175:	68 f1 81 10 f0       	push   $0xf01081f1
f010517a:	53                   	push   %ebx
f010517b:	e8 e2 fd ff ff       	call   f0104f62 <memcmp>
f0105180:	83 c4 10             	add    $0x10,%esp
f0105183:	85 c0                	test   %eax,%eax
f0105185:	75 e2                	jne    f0105169 <mpsearch1+0x56>
f0105187:	89 da                	mov    %ebx,%edx
f0105189:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f010518c:	0f b6 0a             	movzbl (%edx),%ecx
f010518f:	01 c8                	add    %ecx,%eax
f0105191:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105194:	39 fa                	cmp    %edi,%edx
f0105196:	75 f4                	jne    f010518c <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105198:	84 c0                	test   %al,%al
f010519a:	75 cd                	jne    f0105169 <mpsearch1+0x56>
f010519c:	eb 05                	jmp    f01051a3 <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f010519e:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01051a3:	89 d8                	mov    %ebx,%eax
f01051a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01051a8:	5b                   	pop    %ebx
f01051a9:	5e                   	pop    %esi
f01051aa:	5f                   	pop    %edi
f01051ab:	5d                   	pop    %ebp
f01051ac:	c3                   	ret    

f01051ad <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01051ad:	55                   	push   %ebp
f01051ae:	89 e5                	mov    %esp,%ebp
f01051b0:	57                   	push   %edi
f01051b1:	56                   	push   %esi
f01051b2:	53                   	push   %ebx
f01051b3:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01051b6:	c7 05 c0 d3 22 f0 20 	movl   $0xf022d020,0xf022d3c0
f01051bd:	d0 22 f0 
	if (PGNUM(pa) >= npages)
f01051c0:	83 3d 0c cf 22 f0 00 	cmpl   $0x0,0xf022cf0c
f01051c7:	0f 84 87 00 00 00    	je     f0105254 <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01051cd:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01051d4:	85 c0                	test   %eax,%eax
f01051d6:	0f 84 8e 00 00 00    	je     f010526a <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f01051dc:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01051df:	ba 00 04 00 00       	mov    $0x400,%edx
f01051e4:	e8 2a ff ff ff       	call   f0105113 <mpsearch1>
f01051e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01051ec:	85 c0                	test   %eax,%eax
f01051ee:	0f 84 9a 00 00 00    	je     f010528e <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f01051f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01051f7:	8b 41 04             	mov    0x4(%ecx),%eax
f01051fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01051fd:	85 c0                	test   %eax,%eax
f01051ff:	0f 84 a8 00 00 00    	je     f01052ad <mp_init+0x100>
f0105205:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f0105209:	0f 85 9e 00 00 00    	jne    f01052ad <mp_init+0x100>
f010520f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105212:	c1 e8 0c             	shr    $0xc,%eax
f0105215:	3b 05 0c cf 22 f0    	cmp    0xf022cf0c,%eax
f010521b:	0f 83 a1 00 00 00    	jae    f01052c2 <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105224:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f010522a:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f010522c:	83 ec 04             	sub    $0x4,%esp
f010522f:	6a 04                	push   $0x4
f0105231:	68 f6 81 10 f0       	push   $0xf01081f6
f0105236:	53                   	push   %ebx
f0105237:	e8 26 fd ff ff       	call   f0104f62 <memcmp>
f010523c:	83 c4 10             	add    $0x10,%esp
f010523f:	85 c0                	test   %eax,%eax
f0105241:	0f 85 92 00 00 00    	jne    f01052d9 <mp_init+0x12c>
f0105247:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f010524b:	01 df                	add    %ebx,%edi
	sum = 0;
f010524d:	89 c2                	mov    %eax,%edx
f010524f:	e9 a2 00 00 00       	jmp    f01052f6 <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105254:	68 00 04 00 00       	push   $0x400
f0105259:	68 24 5b 10 f0       	push   $0xf0105b24
f010525e:	6a 6f                	push   $0x6f
f0105260:	68 e1 81 10 f0       	push   $0xf01081e1
f0105265:	e8 d6 ad ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010526a:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105271:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105274:	2d 00 04 00 00       	sub    $0x400,%eax
f0105279:	ba 00 04 00 00       	mov    $0x400,%edx
f010527e:	e8 90 fe ff ff       	call   f0105113 <mpsearch1>
f0105283:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105286:	85 c0                	test   %eax,%eax
f0105288:	0f 85 66 ff ff ff    	jne    f01051f4 <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f010528e:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105293:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105298:	e8 76 fe ff ff       	call   f0105113 <mpsearch1>
f010529d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f01052a0:	85 c0                	test   %eax,%eax
f01052a2:	0f 85 4c ff ff ff    	jne    f01051f4 <mp_init+0x47>
f01052a8:	e9 a8 01 00 00       	jmp    f0105455 <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f01052ad:	83 ec 0c             	sub    $0xc,%esp
f01052b0:	68 54 80 10 f0       	push   $0xf0108054
f01052b5:	e8 76 e8 ff ff       	call   f0103b30 <cprintf>
f01052ba:	83 c4 10             	add    $0x10,%esp
f01052bd:	e9 93 01 00 00       	jmp    f0105455 <mp_init+0x2a8>
f01052c2:	ff 75 e4             	pushl  -0x1c(%ebp)
f01052c5:	68 24 5b 10 f0       	push   $0xf0105b24
f01052ca:	68 90 00 00 00       	push   $0x90
f01052cf:	68 e1 81 10 f0       	push   $0xf01081e1
f01052d4:	e8 67 ad ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01052d9:	83 ec 0c             	sub    $0xc,%esp
f01052dc:	68 84 80 10 f0       	push   $0xf0108084
f01052e1:	e8 4a e8 ff ff       	call   f0103b30 <cprintf>
f01052e6:	83 c4 10             	add    $0x10,%esp
f01052e9:	e9 67 01 00 00       	jmp    f0105455 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f01052ee:	0f b6 0b             	movzbl (%ebx),%ecx
f01052f1:	01 ca                	add    %ecx,%edx
f01052f3:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f01052f6:	39 fb                	cmp    %edi,%ebx
f01052f8:	75 f4                	jne    f01052ee <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f01052fa:	84 d2                	test   %dl,%dl
f01052fc:	75 16                	jne    f0105314 <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f01052fe:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105302:	80 fa 01             	cmp    $0x1,%dl
f0105305:	74 05                	je     f010530c <mp_init+0x15f>
f0105307:	80 fa 04             	cmp    $0x4,%dl
f010530a:	75 1d                	jne    f0105329 <mp_init+0x17c>
f010530c:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105310:	01 d9                	add    %ebx,%ecx
f0105312:	eb 36                	jmp    f010534a <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105314:	83 ec 0c             	sub    $0xc,%esp
f0105317:	68 b8 80 10 f0       	push   $0xf01080b8
f010531c:	e8 0f e8 ff ff       	call   f0103b30 <cprintf>
f0105321:	83 c4 10             	add    $0x10,%esp
f0105324:	e9 2c 01 00 00       	jmp    f0105455 <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105329:	83 ec 08             	sub    $0x8,%esp
f010532c:	0f b6 d2             	movzbl %dl,%edx
f010532f:	52                   	push   %edx
f0105330:	68 dc 80 10 f0       	push   $0xf01080dc
f0105335:	e8 f6 e7 ff ff       	call   f0103b30 <cprintf>
f010533a:	83 c4 10             	add    $0x10,%esp
f010533d:	e9 13 01 00 00       	jmp    f0105455 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105342:	0f b6 13             	movzbl (%ebx),%edx
f0105345:	01 d0                	add    %edx,%eax
f0105347:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f010534a:	39 d9                	cmp    %ebx,%ecx
f010534c:	75 f4                	jne    f0105342 <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f010534e:	02 46 2a             	add    0x2a(%esi),%al
f0105351:	75 29                	jne    f010537c <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105353:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f010535a:	0f 84 f5 00 00 00    	je     f0105455 <mp_init+0x2a8>
		return;
	ismp = 1;
f0105360:	c7 05 00 d0 22 f0 01 	movl   $0x1,0xf022d000
f0105367:	00 00 00 
	lapicaddr = conf->lapicaddr;
f010536a:	8b 46 24             	mov    0x24(%esi),%eax
f010536d:	a3 00 e0 26 f0       	mov    %eax,0xf026e000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105372:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105375:	bb 00 00 00 00       	mov    $0x0,%ebx
f010537a:	eb 4d                	jmp    f01053c9 <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f010537c:	83 ec 0c             	sub    $0xc,%esp
f010537f:	68 fc 80 10 f0       	push   $0xf01080fc
f0105384:	e8 a7 e7 ff ff       	call   f0103b30 <cprintf>
f0105389:	83 c4 10             	add    $0x10,%esp
f010538c:	e9 c4 00 00 00       	jmp    f0105455 <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105391:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105395:	74 11                	je     f01053a8 <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105397:	6b 05 c4 d3 22 f0 74 	imul   $0x74,0xf022d3c4,%eax
f010539e:	05 20 d0 22 f0       	add    $0xf022d020,%eax
f01053a3:	a3 c0 d3 22 f0       	mov    %eax,0xf022d3c0
			if (ncpu < NCPU) {
f01053a8:	a1 c4 d3 22 f0       	mov    0xf022d3c4,%eax
f01053ad:	83 f8 07             	cmp    $0x7,%eax
f01053b0:	7f 2f                	jg     f01053e1 <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;
f01053b2:	6b d0 74             	imul   $0x74,%eax,%edx
f01053b5:	88 82 20 d0 22 f0    	mov    %al,-0xfdd2fe0(%edx)
				ncpu++;
f01053bb:	83 c0 01             	add    $0x1,%eax
f01053be:	a3 c4 d3 22 f0       	mov    %eax,0xf022d3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01053c3:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01053c6:	83 c3 01             	add    $0x1,%ebx
f01053c9:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f01053cd:	39 d8                	cmp    %ebx,%eax
f01053cf:	76 4b                	jbe    f010541c <mp_init+0x26f>
		switch (*p) {
f01053d1:	0f b6 07             	movzbl (%edi),%eax
f01053d4:	84 c0                	test   %al,%al
f01053d6:	74 b9                	je     f0105391 <mp_init+0x1e4>
f01053d8:	3c 04                	cmp    $0x4,%al
f01053da:	77 1c                	ja     f01053f8 <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f01053dc:	83 c7 08             	add    $0x8,%edi
			continue;
f01053df:	eb e5                	jmp    f01053c6 <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f01053e1:	83 ec 08             	sub    $0x8,%esp
f01053e4:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f01053e8:	50                   	push   %eax
f01053e9:	68 2c 81 10 f0       	push   $0xf010812c
f01053ee:	e8 3d e7 ff ff       	call   f0103b30 <cprintf>
f01053f3:	83 c4 10             	add    $0x10,%esp
f01053f6:	eb cb                	jmp    f01053c3 <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f01053f8:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f01053fb:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f01053fe:	50                   	push   %eax
f01053ff:	68 54 81 10 f0       	push   $0xf0108154
f0105404:	e8 27 e7 ff ff       	call   f0103b30 <cprintf>
			ismp = 0;
f0105409:	c7 05 00 d0 22 f0 00 	movl   $0x0,0xf022d000
f0105410:	00 00 00 
			i = conf->entry;
f0105413:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105417:	83 c4 10             	add    $0x10,%esp
f010541a:	eb aa                	jmp    f01053c6 <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f010541c:	a1 c0 d3 22 f0       	mov    0xf022d3c0,%eax
f0105421:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105428:	83 3d 00 d0 22 f0 00 	cmpl   $0x0,0xf022d000
f010542f:	75 2c                	jne    f010545d <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105431:	c7 05 c4 d3 22 f0 01 	movl   $0x1,0xf022d3c4
f0105438:	00 00 00 
		lapicaddr = 0;
f010543b:	c7 05 00 e0 26 f0 00 	movl   $0x0,0xf026e000
f0105442:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105445:	83 ec 0c             	sub    $0xc,%esp
f0105448:	68 74 81 10 f0       	push   $0xf0108174
f010544d:	e8 de e6 ff ff       	call   f0103b30 <cprintf>
		return;
f0105452:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105455:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105458:	5b                   	pop    %ebx
f0105459:	5e                   	pop    %esi
f010545a:	5f                   	pop    %edi
f010545b:	5d                   	pop    %ebp
f010545c:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010545d:	83 ec 04             	sub    $0x4,%esp
f0105460:	ff 35 c4 d3 22 f0    	pushl  0xf022d3c4
f0105466:	0f b6 00             	movzbl (%eax),%eax
f0105469:	50                   	push   %eax
f010546a:	68 fb 81 10 f0       	push   $0xf01081fb
f010546f:	e8 bc e6 ff ff       	call   f0103b30 <cprintf>
	if (mp->imcrp) {
f0105474:	83 c4 10             	add    $0x10,%esp
f0105477:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010547a:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f010547e:	74 d5                	je     f0105455 <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105480:	83 ec 0c             	sub    $0xc,%esp
f0105483:	68 a0 81 10 f0       	push   $0xf01081a0
f0105488:	e8 a3 e6 ff ff       	call   f0103b30 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010548d:	b8 70 00 00 00       	mov    $0x70,%eax
f0105492:	ba 22 00 00 00       	mov    $0x22,%edx
f0105497:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105498:	ba 23 00 00 00       	mov    $0x23,%edx
f010549d:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f010549e:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01054a1:	ee                   	out    %al,(%dx)
f01054a2:	83 c4 10             	add    $0x10,%esp
f01054a5:	eb ae                	jmp    f0105455 <mp_init+0x2a8>

f01054a7 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f01054a7:	55                   	push   %ebp
f01054a8:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f01054aa:	8b 0d 04 e0 26 f0    	mov    0xf026e004,%ecx
f01054b0:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f01054b3:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01054b5:	a1 04 e0 26 f0       	mov    0xf026e004,%eax
f01054ba:	8b 40 20             	mov    0x20(%eax),%eax
}
f01054bd:	5d                   	pop    %ebp
f01054be:	c3                   	ret    

f01054bf <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f01054bf:	55                   	push   %ebp
f01054c0:	89 e5                	mov    %esp,%ebp
	if (lapic)
f01054c2:	8b 15 04 e0 26 f0    	mov    0xf026e004,%edx
		return lapic[ID] >> 24;
	return 0;
f01054c8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f01054cd:	85 d2                	test   %edx,%edx
f01054cf:	74 06                	je     f01054d7 <cpunum+0x18>
		return lapic[ID] >> 24;
f01054d1:	8b 42 20             	mov    0x20(%edx),%eax
f01054d4:	c1 e8 18             	shr    $0x18,%eax
}
f01054d7:	5d                   	pop    %ebp
f01054d8:	c3                   	ret    

f01054d9 <lapic_init>:
	if (!lapicaddr)
f01054d9:	a1 00 e0 26 f0       	mov    0xf026e000,%eax
f01054de:	85 c0                	test   %eax,%eax
f01054e0:	75 02                	jne    f01054e4 <lapic_init+0xb>
f01054e2:	f3 c3                	repz ret 
{
f01054e4:	55                   	push   %ebp
f01054e5:	89 e5                	mov    %esp,%ebp
f01054e7:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f01054ea:	68 00 10 00 00       	push   $0x1000
f01054ef:	50                   	push   %eax
f01054f0:	e8 5a db ff ff       	call   f010304f <mmio_map_region>
f01054f5:	a3 04 e0 26 f0       	mov    %eax,0xf026e004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f01054fa:	ba 27 01 00 00       	mov    $0x127,%edx
f01054ff:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105504:	e8 9e ff ff ff       	call   f01054a7 <lapicw>
	lapicw(TDCR, X1);
f0105509:	ba 0b 00 00 00       	mov    $0xb,%edx
f010550e:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105513:	e8 8f ff ff ff       	call   f01054a7 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105518:	ba 20 00 02 00       	mov    $0x20020,%edx
f010551d:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105522:	e8 80 ff ff ff       	call   f01054a7 <lapicw>
	lapicw(TICR, 10000000); 
f0105527:	ba 80 96 98 00       	mov    $0x989680,%edx
f010552c:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105531:	e8 71 ff ff ff       	call   f01054a7 <lapicw>
	if (thiscpu != bootcpu)
f0105536:	e8 84 ff ff ff       	call   f01054bf <cpunum>
f010553b:	6b c0 74             	imul   $0x74,%eax,%eax
f010553e:	05 20 d0 22 f0       	add    $0xf022d020,%eax
f0105543:	83 c4 10             	add    $0x10,%esp
f0105546:	39 05 c0 d3 22 f0    	cmp    %eax,0xf022d3c0
f010554c:	74 0f                	je     f010555d <lapic_init+0x84>
		lapicw(LINT0, MASKED);
f010554e:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105553:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105558:	e8 4a ff ff ff       	call   f01054a7 <lapicw>
	lapicw(LINT1, MASKED);
f010555d:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105562:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105567:	e8 3b ff ff ff       	call   f01054a7 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f010556c:	a1 04 e0 26 f0       	mov    0xf026e004,%eax
f0105571:	8b 40 30             	mov    0x30(%eax),%eax
f0105574:	c1 e8 10             	shr    $0x10,%eax
f0105577:	3c 03                	cmp    $0x3,%al
f0105579:	77 7c                	ja     f01055f7 <lapic_init+0x11e>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f010557b:	ba 33 00 00 00       	mov    $0x33,%edx
f0105580:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105585:	e8 1d ff ff ff       	call   f01054a7 <lapicw>
	lapicw(ESR, 0);
f010558a:	ba 00 00 00 00       	mov    $0x0,%edx
f010558f:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105594:	e8 0e ff ff ff       	call   f01054a7 <lapicw>
	lapicw(ESR, 0);
f0105599:	ba 00 00 00 00       	mov    $0x0,%edx
f010559e:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01055a3:	e8 ff fe ff ff       	call   f01054a7 <lapicw>
	lapicw(EOI, 0);
f01055a8:	ba 00 00 00 00       	mov    $0x0,%edx
f01055ad:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01055b2:	e8 f0 fe ff ff       	call   f01054a7 <lapicw>
	lapicw(ICRHI, 0);
f01055b7:	ba 00 00 00 00       	mov    $0x0,%edx
f01055bc:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01055c1:	e8 e1 fe ff ff       	call   f01054a7 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f01055c6:	ba 00 85 08 00       	mov    $0x88500,%edx
f01055cb:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01055d0:	e8 d2 fe ff ff       	call   f01054a7 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f01055d5:	8b 15 04 e0 26 f0    	mov    0xf026e004,%edx
f01055db:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01055e1:	f6 c4 10             	test   $0x10,%ah
f01055e4:	75 f5                	jne    f01055db <lapic_init+0x102>
	lapicw(TPR, 0);
f01055e6:	ba 00 00 00 00       	mov    $0x0,%edx
f01055eb:	b8 20 00 00 00       	mov    $0x20,%eax
f01055f0:	e8 b2 fe ff ff       	call   f01054a7 <lapicw>
}
f01055f5:	c9                   	leave  
f01055f6:	c3                   	ret    
		lapicw(PCINT, MASKED);
f01055f7:	ba 00 00 01 00       	mov    $0x10000,%edx
f01055fc:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105601:	e8 a1 fe ff ff       	call   f01054a7 <lapicw>
f0105606:	e9 70 ff ff ff       	jmp    f010557b <lapic_init+0xa2>

f010560b <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f010560b:	83 3d 04 e0 26 f0 00 	cmpl   $0x0,0xf026e004
f0105612:	74 14                	je     f0105628 <lapic_eoi+0x1d>
{
f0105614:	55                   	push   %ebp
f0105615:	89 e5                	mov    %esp,%ebp
		lapicw(EOI, 0);
f0105617:	ba 00 00 00 00       	mov    $0x0,%edx
f010561c:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105621:	e8 81 fe ff ff       	call   f01054a7 <lapicw>
}
f0105626:	5d                   	pop    %ebp
f0105627:	c3                   	ret    
f0105628:	f3 c3                	repz ret 

f010562a <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010562a:	55                   	push   %ebp
f010562b:	89 e5                	mov    %esp,%ebp
f010562d:	56                   	push   %esi
f010562e:	53                   	push   %ebx
f010562f:	8b 75 08             	mov    0x8(%ebp),%esi
f0105632:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105635:	b8 0f 00 00 00       	mov    $0xf,%eax
f010563a:	ba 70 00 00 00       	mov    $0x70,%edx
f010563f:	ee                   	out    %al,(%dx)
f0105640:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105645:	ba 71 00 00 00       	mov    $0x71,%edx
f010564a:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f010564b:	83 3d 0c cf 22 f0 00 	cmpl   $0x0,0xf022cf0c
f0105652:	74 7e                	je     f01056d2 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0105654:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f010565b:	00 00 
	wrv[1] = addr >> 4;
f010565d:	89 d8                	mov    %ebx,%eax
f010565f:	c1 e8 04             	shr    $0x4,%eax
f0105662:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0105668:	c1 e6 18             	shl    $0x18,%esi
f010566b:	89 f2                	mov    %esi,%edx
f010566d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105672:	e8 30 fe ff ff       	call   f01054a7 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105677:	ba 00 c5 00 00       	mov    $0xc500,%edx
f010567c:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105681:	e8 21 fe ff ff       	call   f01054a7 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0105686:	ba 00 85 00 00       	mov    $0x8500,%edx
f010568b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105690:	e8 12 fe ff ff       	call   f01054a7 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105695:	c1 eb 0c             	shr    $0xc,%ebx
f0105698:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f010569b:	89 f2                	mov    %esi,%edx
f010569d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01056a2:	e8 00 fe ff ff       	call   f01054a7 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01056a7:	89 da                	mov    %ebx,%edx
f01056a9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01056ae:	e8 f4 fd ff ff       	call   f01054a7 <lapicw>
		lapicw(ICRHI, apicid << 24);
f01056b3:	89 f2                	mov    %esi,%edx
f01056b5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01056ba:	e8 e8 fd ff ff       	call   f01054a7 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01056bf:	89 da                	mov    %ebx,%edx
f01056c1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01056c6:	e8 dc fd ff ff       	call   f01054a7 <lapicw>
		microdelay(200);
	}
}
f01056cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01056ce:	5b                   	pop    %ebx
f01056cf:	5e                   	pop    %esi
f01056d0:	5d                   	pop    %ebp
f01056d1:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01056d2:	68 67 04 00 00       	push   $0x467
f01056d7:	68 24 5b 10 f0       	push   $0xf0105b24
f01056dc:	68 98 00 00 00       	push   $0x98
f01056e1:	68 18 82 10 f0       	push   $0xf0108218
f01056e6:	e8 55 a9 ff ff       	call   f0100040 <_panic>

f01056eb <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01056eb:	55                   	push   %ebp
f01056ec:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f01056ee:	8b 55 08             	mov    0x8(%ebp),%edx
f01056f1:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f01056f7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01056fc:	e8 a6 fd ff ff       	call   f01054a7 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0105701:	8b 15 04 e0 26 f0    	mov    0xf026e004,%edx
f0105707:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010570d:	f6 c4 10             	test   $0x10,%ah
f0105710:	75 f5                	jne    f0105707 <lapic_ipi+0x1c>
		;
}
f0105712:	5d                   	pop    %ebp
f0105713:	c3                   	ret    

f0105714 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0105714:	55                   	push   %ebp
f0105715:	89 e5                	mov    %esp,%ebp
f0105717:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010571a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0105720:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105723:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0105726:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f010572d:	5d                   	pop    %ebp
f010572e:	c3                   	ret    

f010572f <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f010572f:	55                   	push   %ebp
f0105730:	89 e5                	mov    %esp,%ebp
f0105732:	56                   	push   %esi
f0105733:	53                   	push   %ebx
f0105734:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0105737:	83 3b 00             	cmpl   $0x0,(%ebx)
f010573a:	75 07                	jne    f0105743 <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f010573c:	ba 01 00 00 00       	mov    $0x1,%edx
f0105741:	eb 34                	jmp    f0105777 <spin_lock+0x48>
f0105743:	8b 73 08             	mov    0x8(%ebx),%esi
f0105746:	e8 74 fd ff ff       	call   f01054bf <cpunum>
f010574b:	6b c0 74             	imul   $0x74,%eax,%eax
f010574e:	05 20 d0 22 f0       	add    $0xf022d020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0105753:	39 c6                	cmp    %eax,%esi
f0105755:	75 e5                	jne    f010573c <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0105757:	8b 5b 04             	mov    0x4(%ebx),%ebx
f010575a:	e8 60 fd ff ff       	call   f01054bf <cpunum>
f010575f:	83 ec 0c             	sub    $0xc,%esp
f0105762:	53                   	push   %ebx
f0105763:	50                   	push   %eax
f0105764:	68 28 82 10 f0       	push   $0xf0108228
f0105769:	6a 41                	push   $0x41
f010576b:	68 8c 82 10 f0       	push   $0xf010828c
f0105770:	e8 cb a8 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0105775:	f3 90                	pause  
f0105777:	89 d0                	mov    %edx,%eax
f0105779:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f010577c:	85 c0                	test   %eax,%eax
f010577e:	75 f5                	jne    f0105775 <spin_lock+0x46>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0105780:	e8 3a fd ff ff       	call   f01054bf <cpunum>
f0105785:	6b c0 74             	imul   $0x74,%eax,%eax
f0105788:	05 20 d0 22 f0       	add    $0xf022d020,%eax
f010578d:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0105790:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0105793:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0105795:	b8 00 00 00 00       	mov    $0x0,%eax
f010579a:	eb 0b                	jmp    f01057a7 <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f010579c:	8b 4a 04             	mov    0x4(%edx),%ecx
f010579f:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01057a2:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01057a4:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01057a7:	83 f8 09             	cmp    $0x9,%eax
f01057aa:	7f 14                	jg     f01057c0 <spin_lock+0x91>
f01057ac:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01057b2:	77 e8                	ja     f010579c <spin_lock+0x6d>
f01057b4:	eb 0a                	jmp    f01057c0 <spin_lock+0x91>
		pcs[i] = 0;
f01057b6:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f01057bd:	83 c0 01             	add    $0x1,%eax
f01057c0:	83 f8 09             	cmp    $0x9,%eax
f01057c3:	7e f1                	jle    f01057b6 <spin_lock+0x87>
#endif
}
f01057c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01057c8:	5b                   	pop    %ebx
f01057c9:	5e                   	pop    %esi
f01057ca:	5d                   	pop    %ebp
f01057cb:	c3                   	ret    

f01057cc <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01057cc:	55                   	push   %ebp
f01057cd:	89 e5                	mov    %esp,%ebp
f01057cf:	57                   	push   %edi
f01057d0:	56                   	push   %esi
f01057d1:	53                   	push   %ebx
f01057d2:	83 ec 4c             	sub    $0x4c,%esp
f01057d5:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f01057d8:	83 3e 00             	cmpl   $0x0,(%esi)
f01057db:	75 35                	jne    f0105812 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01057dd:	83 ec 04             	sub    $0x4,%esp
f01057e0:	6a 28                	push   $0x28
f01057e2:	8d 46 0c             	lea    0xc(%esi),%eax
f01057e5:	50                   	push   %eax
f01057e6:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01057e9:	53                   	push   %ebx
f01057ea:	e8 f8 f6 ff ff       	call   f0104ee7 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f01057ef:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01057f2:	0f b6 38             	movzbl (%eax),%edi
f01057f5:	8b 76 04             	mov    0x4(%esi),%esi
f01057f8:	e8 c2 fc ff ff       	call   f01054bf <cpunum>
f01057fd:	57                   	push   %edi
f01057fe:	56                   	push   %esi
f01057ff:	50                   	push   %eax
f0105800:	68 54 82 10 f0       	push   $0xf0108254
f0105805:	e8 26 e3 ff ff       	call   f0103b30 <cprintf>
f010580a:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f010580d:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0105810:	eb 61                	jmp    f0105873 <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f0105812:	8b 5e 08             	mov    0x8(%esi),%ebx
f0105815:	e8 a5 fc ff ff       	call   f01054bf <cpunum>
f010581a:	6b c0 74             	imul   $0x74,%eax,%eax
f010581d:	05 20 d0 22 f0       	add    $0xf022d020,%eax
	if (!holding(lk)) {
f0105822:	39 c3                	cmp    %eax,%ebx
f0105824:	75 b7                	jne    f01057dd <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0105826:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f010582d:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0105834:	b8 00 00 00 00       	mov    $0x0,%eax
f0105839:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f010583c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010583f:	5b                   	pop    %ebx
f0105840:	5e                   	pop    %esi
f0105841:	5f                   	pop    %edi
f0105842:	5d                   	pop    %ebp
f0105843:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f0105844:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0105846:	83 ec 04             	sub    $0x4,%esp
f0105849:	89 c2                	mov    %eax,%edx
f010584b:	2b 55 b8             	sub    -0x48(%ebp),%edx
f010584e:	52                   	push   %edx
f010584f:	ff 75 b0             	pushl  -0x50(%ebp)
f0105852:	ff 75 b4             	pushl  -0x4c(%ebp)
f0105855:	ff 75 ac             	pushl  -0x54(%ebp)
f0105858:	ff 75 a8             	pushl  -0x58(%ebp)
f010585b:	50                   	push   %eax
f010585c:	68 9c 82 10 f0       	push   $0xf010829c
f0105861:	e8 ca e2 ff ff       	call   f0103b30 <cprintf>
f0105866:	83 c4 20             	add    $0x20,%esp
f0105869:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f010586c:	8d 45 e8             	lea    -0x18(%ebp),%eax
f010586f:	39 c3                	cmp    %eax,%ebx
f0105871:	74 2d                	je     f01058a0 <spin_unlock+0xd4>
f0105873:	89 de                	mov    %ebx,%esi
f0105875:	8b 03                	mov    (%ebx),%eax
f0105877:	85 c0                	test   %eax,%eax
f0105879:	74 25                	je     f01058a0 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f010587b:	83 ec 08             	sub    $0x8,%esp
f010587e:	57                   	push   %edi
f010587f:	50                   	push   %eax
f0105880:	e8 7d eb ff ff       	call   f0104402 <debuginfo_eip>
f0105885:	83 c4 10             	add    $0x10,%esp
f0105888:	85 c0                	test   %eax,%eax
f010588a:	79 b8                	jns    f0105844 <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f010588c:	83 ec 08             	sub    $0x8,%esp
f010588f:	ff 36                	pushl  (%esi)
f0105891:	68 b3 82 10 f0       	push   $0xf01082b3
f0105896:	e8 95 e2 ff ff       	call   f0103b30 <cprintf>
f010589b:	83 c4 10             	add    $0x10,%esp
f010589e:	eb c9                	jmp    f0105869 <spin_unlock+0x9d>
		panic("spin_unlock");
f01058a0:	83 ec 04             	sub    $0x4,%esp
f01058a3:	68 bb 82 10 f0       	push   $0xf01082bb
f01058a8:	6a 67                	push   $0x67
f01058aa:	68 8c 82 10 f0       	push   $0xf010828c
f01058af:	e8 8c a7 ff ff       	call   f0100040 <_panic>
f01058b4:	66 90                	xchg   %ax,%ax
f01058b6:	66 90                	xchg   %ax,%ax
f01058b8:	66 90                	xchg   %ax,%ax
f01058ba:	66 90                	xchg   %ax,%ax
f01058bc:	66 90                	xchg   %ax,%ax
f01058be:	66 90                	xchg   %ax,%ax

f01058c0 <__udivdi3>:
f01058c0:	55                   	push   %ebp
f01058c1:	57                   	push   %edi
f01058c2:	56                   	push   %esi
f01058c3:	53                   	push   %ebx
f01058c4:	83 ec 1c             	sub    $0x1c,%esp
f01058c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01058cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01058cf:	8b 74 24 34          	mov    0x34(%esp),%esi
f01058d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01058d7:	85 d2                	test   %edx,%edx
f01058d9:	75 35                	jne    f0105910 <__udivdi3+0x50>
f01058db:	39 f3                	cmp    %esi,%ebx
f01058dd:	0f 87 bd 00 00 00    	ja     f01059a0 <__udivdi3+0xe0>
f01058e3:	85 db                	test   %ebx,%ebx
f01058e5:	89 d9                	mov    %ebx,%ecx
f01058e7:	75 0b                	jne    f01058f4 <__udivdi3+0x34>
f01058e9:	b8 01 00 00 00       	mov    $0x1,%eax
f01058ee:	31 d2                	xor    %edx,%edx
f01058f0:	f7 f3                	div    %ebx
f01058f2:	89 c1                	mov    %eax,%ecx
f01058f4:	31 d2                	xor    %edx,%edx
f01058f6:	89 f0                	mov    %esi,%eax
f01058f8:	f7 f1                	div    %ecx
f01058fa:	89 c6                	mov    %eax,%esi
f01058fc:	89 e8                	mov    %ebp,%eax
f01058fe:	89 f7                	mov    %esi,%edi
f0105900:	f7 f1                	div    %ecx
f0105902:	89 fa                	mov    %edi,%edx
f0105904:	83 c4 1c             	add    $0x1c,%esp
f0105907:	5b                   	pop    %ebx
f0105908:	5e                   	pop    %esi
f0105909:	5f                   	pop    %edi
f010590a:	5d                   	pop    %ebp
f010590b:	c3                   	ret    
f010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105910:	39 f2                	cmp    %esi,%edx
f0105912:	77 7c                	ja     f0105990 <__udivdi3+0xd0>
f0105914:	0f bd fa             	bsr    %edx,%edi
f0105917:	83 f7 1f             	xor    $0x1f,%edi
f010591a:	0f 84 98 00 00 00    	je     f01059b8 <__udivdi3+0xf8>
f0105920:	89 f9                	mov    %edi,%ecx
f0105922:	b8 20 00 00 00       	mov    $0x20,%eax
f0105927:	29 f8                	sub    %edi,%eax
f0105929:	d3 e2                	shl    %cl,%edx
f010592b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010592f:	89 c1                	mov    %eax,%ecx
f0105931:	89 da                	mov    %ebx,%edx
f0105933:	d3 ea                	shr    %cl,%edx
f0105935:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0105939:	09 d1                	or     %edx,%ecx
f010593b:	89 f2                	mov    %esi,%edx
f010593d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105941:	89 f9                	mov    %edi,%ecx
f0105943:	d3 e3                	shl    %cl,%ebx
f0105945:	89 c1                	mov    %eax,%ecx
f0105947:	d3 ea                	shr    %cl,%edx
f0105949:	89 f9                	mov    %edi,%ecx
f010594b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010594f:	d3 e6                	shl    %cl,%esi
f0105951:	89 eb                	mov    %ebp,%ebx
f0105953:	89 c1                	mov    %eax,%ecx
f0105955:	d3 eb                	shr    %cl,%ebx
f0105957:	09 de                	or     %ebx,%esi
f0105959:	89 f0                	mov    %esi,%eax
f010595b:	f7 74 24 08          	divl   0x8(%esp)
f010595f:	89 d6                	mov    %edx,%esi
f0105961:	89 c3                	mov    %eax,%ebx
f0105963:	f7 64 24 0c          	mull   0xc(%esp)
f0105967:	39 d6                	cmp    %edx,%esi
f0105969:	72 0c                	jb     f0105977 <__udivdi3+0xb7>
f010596b:	89 f9                	mov    %edi,%ecx
f010596d:	d3 e5                	shl    %cl,%ebp
f010596f:	39 c5                	cmp    %eax,%ebp
f0105971:	73 5d                	jae    f01059d0 <__udivdi3+0x110>
f0105973:	39 d6                	cmp    %edx,%esi
f0105975:	75 59                	jne    f01059d0 <__udivdi3+0x110>
f0105977:	8d 43 ff             	lea    -0x1(%ebx),%eax
f010597a:	31 ff                	xor    %edi,%edi
f010597c:	89 fa                	mov    %edi,%edx
f010597e:	83 c4 1c             	add    $0x1c,%esp
f0105981:	5b                   	pop    %ebx
f0105982:	5e                   	pop    %esi
f0105983:	5f                   	pop    %edi
f0105984:	5d                   	pop    %ebp
f0105985:	c3                   	ret    
f0105986:	8d 76 00             	lea    0x0(%esi),%esi
f0105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0105990:	31 ff                	xor    %edi,%edi
f0105992:	31 c0                	xor    %eax,%eax
f0105994:	89 fa                	mov    %edi,%edx
f0105996:	83 c4 1c             	add    $0x1c,%esp
f0105999:	5b                   	pop    %ebx
f010599a:	5e                   	pop    %esi
f010599b:	5f                   	pop    %edi
f010599c:	5d                   	pop    %ebp
f010599d:	c3                   	ret    
f010599e:	66 90                	xchg   %ax,%ax
f01059a0:	31 ff                	xor    %edi,%edi
f01059a2:	89 e8                	mov    %ebp,%eax
f01059a4:	89 f2                	mov    %esi,%edx
f01059a6:	f7 f3                	div    %ebx
f01059a8:	89 fa                	mov    %edi,%edx
f01059aa:	83 c4 1c             	add    $0x1c,%esp
f01059ad:	5b                   	pop    %ebx
f01059ae:	5e                   	pop    %esi
f01059af:	5f                   	pop    %edi
f01059b0:	5d                   	pop    %ebp
f01059b1:	c3                   	ret    
f01059b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01059b8:	39 f2                	cmp    %esi,%edx
f01059ba:	72 06                	jb     f01059c2 <__udivdi3+0x102>
f01059bc:	31 c0                	xor    %eax,%eax
f01059be:	39 eb                	cmp    %ebp,%ebx
f01059c0:	77 d2                	ja     f0105994 <__udivdi3+0xd4>
f01059c2:	b8 01 00 00 00       	mov    $0x1,%eax
f01059c7:	eb cb                	jmp    f0105994 <__udivdi3+0xd4>
f01059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01059d0:	89 d8                	mov    %ebx,%eax
f01059d2:	31 ff                	xor    %edi,%edi
f01059d4:	eb be                	jmp    f0105994 <__udivdi3+0xd4>
f01059d6:	66 90                	xchg   %ax,%ax
f01059d8:	66 90                	xchg   %ax,%ax
f01059da:	66 90                	xchg   %ax,%ax
f01059dc:	66 90                	xchg   %ax,%ax
f01059de:	66 90                	xchg   %ax,%ax

f01059e0 <__umoddi3>:
f01059e0:	55                   	push   %ebp
f01059e1:	57                   	push   %edi
f01059e2:	56                   	push   %esi
f01059e3:	53                   	push   %ebx
f01059e4:	83 ec 1c             	sub    $0x1c,%esp
f01059e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f01059eb:	8b 74 24 30          	mov    0x30(%esp),%esi
f01059ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01059f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01059f7:	85 ed                	test   %ebp,%ebp
f01059f9:	89 f0                	mov    %esi,%eax
f01059fb:	89 da                	mov    %ebx,%edx
f01059fd:	75 19                	jne    f0105a18 <__umoddi3+0x38>
f01059ff:	39 df                	cmp    %ebx,%edi
f0105a01:	0f 86 b1 00 00 00    	jbe    f0105ab8 <__umoddi3+0xd8>
f0105a07:	f7 f7                	div    %edi
f0105a09:	89 d0                	mov    %edx,%eax
f0105a0b:	31 d2                	xor    %edx,%edx
f0105a0d:	83 c4 1c             	add    $0x1c,%esp
f0105a10:	5b                   	pop    %ebx
f0105a11:	5e                   	pop    %esi
f0105a12:	5f                   	pop    %edi
f0105a13:	5d                   	pop    %ebp
f0105a14:	c3                   	ret    
f0105a15:	8d 76 00             	lea    0x0(%esi),%esi
f0105a18:	39 dd                	cmp    %ebx,%ebp
f0105a1a:	77 f1                	ja     f0105a0d <__umoddi3+0x2d>
f0105a1c:	0f bd cd             	bsr    %ebp,%ecx
f0105a1f:	83 f1 1f             	xor    $0x1f,%ecx
f0105a22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105a26:	0f 84 b4 00 00 00    	je     f0105ae0 <__umoddi3+0x100>
f0105a2c:	b8 20 00 00 00       	mov    $0x20,%eax
f0105a31:	89 c2                	mov    %eax,%edx
f0105a33:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105a37:	29 c2                	sub    %eax,%edx
f0105a39:	89 c1                	mov    %eax,%ecx
f0105a3b:	89 f8                	mov    %edi,%eax
f0105a3d:	d3 e5                	shl    %cl,%ebp
f0105a3f:	89 d1                	mov    %edx,%ecx
f0105a41:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105a45:	d3 e8                	shr    %cl,%eax
f0105a47:	09 c5                	or     %eax,%ebp
f0105a49:	8b 44 24 04          	mov    0x4(%esp),%eax
f0105a4d:	89 c1                	mov    %eax,%ecx
f0105a4f:	d3 e7                	shl    %cl,%edi
f0105a51:	89 d1                	mov    %edx,%ecx
f0105a53:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105a57:	89 df                	mov    %ebx,%edi
f0105a59:	d3 ef                	shr    %cl,%edi
f0105a5b:	89 c1                	mov    %eax,%ecx
f0105a5d:	89 f0                	mov    %esi,%eax
f0105a5f:	d3 e3                	shl    %cl,%ebx
f0105a61:	89 d1                	mov    %edx,%ecx
f0105a63:	89 fa                	mov    %edi,%edx
f0105a65:	d3 e8                	shr    %cl,%eax
f0105a67:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0105a6c:	09 d8                	or     %ebx,%eax
f0105a6e:	f7 f5                	div    %ebp
f0105a70:	d3 e6                	shl    %cl,%esi
f0105a72:	89 d1                	mov    %edx,%ecx
f0105a74:	f7 64 24 08          	mull   0x8(%esp)
f0105a78:	39 d1                	cmp    %edx,%ecx
f0105a7a:	89 c3                	mov    %eax,%ebx
f0105a7c:	89 d7                	mov    %edx,%edi
f0105a7e:	72 06                	jb     f0105a86 <__umoddi3+0xa6>
f0105a80:	75 0e                	jne    f0105a90 <__umoddi3+0xb0>
f0105a82:	39 c6                	cmp    %eax,%esi
f0105a84:	73 0a                	jae    f0105a90 <__umoddi3+0xb0>
f0105a86:	2b 44 24 08          	sub    0x8(%esp),%eax
f0105a8a:	19 ea                	sbb    %ebp,%edx
f0105a8c:	89 d7                	mov    %edx,%edi
f0105a8e:	89 c3                	mov    %eax,%ebx
f0105a90:	89 ca                	mov    %ecx,%edx
f0105a92:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0105a97:	29 de                	sub    %ebx,%esi
f0105a99:	19 fa                	sbb    %edi,%edx
f0105a9b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f0105a9f:	89 d0                	mov    %edx,%eax
f0105aa1:	d3 e0                	shl    %cl,%eax
f0105aa3:	89 d9                	mov    %ebx,%ecx
f0105aa5:	d3 ee                	shr    %cl,%esi
f0105aa7:	d3 ea                	shr    %cl,%edx
f0105aa9:	09 f0                	or     %esi,%eax
f0105aab:	83 c4 1c             	add    $0x1c,%esp
f0105aae:	5b                   	pop    %ebx
f0105aaf:	5e                   	pop    %esi
f0105ab0:	5f                   	pop    %edi
f0105ab1:	5d                   	pop    %ebp
f0105ab2:	c3                   	ret    
f0105ab3:	90                   	nop
f0105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105ab8:	85 ff                	test   %edi,%edi
f0105aba:	89 f9                	mov    %edi,%ecx
f0105abc:	75 0b                	jne    f0105ac9 <__umoddi3+0xe9>
f0105abe:	b8 01 00 00 00       	mov    $0x1,%eax
f0105ac3:	31 d2                	xor    %edx,%edx
f0105ac5:	f7 f7                	div    %edi
f0105ac7:	89 c1                	mov    %eax,%ecx
f0105ac9:	89 d8                	mov    %ebx,%eax
f0105acb:	31 d2                	xor    %edx,%edx
f0105acd:	f7 f1                	div    %ecx
f0105acf:	89 f0                	mov    %esi,%eax
f0105ad1:	f7 f1                	div    %ecx
f0105ad3:	e9 31 ff ff ff       	jmp    f0105a09 <__umoddi3+0x29>
f0105ad8:	90                   	nop
f0105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0105ae0:	39 dd                	cmp    %ebx,%ebp
f0105ae2:	72 08                	jb     f0105aec <__umoddi3+0x10c>
f0105ae4:	39 f7                	cmp    %esi,%edi
f0105ae6:	0f 87 21 ff ff ff    	ja     f0105a0d <__umoddi3+0x2d>
f0105aec:	89 da                	mov    %ebx,%edx
f0105aee:	89 f0                	mov    %esi,%eax
f0105af0:	29 f8                	sub    %edi,%eax
f0105af2:	19 ea                	sbb    %ebp,%edx
f0105af4:	e9 14 ff ff ff       	jmp    f0105a0d <__umoddi3+0x2d>
