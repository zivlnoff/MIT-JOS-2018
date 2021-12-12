
obj/kern/kernel:     file format elf32-i386


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
f0100015:	b8 00 00 11 00       	mov    $0x110000,%eax
f010001a:	0f 22 d8             	mov    %eax,%cr3
f010001d:	0f 20 c0             	mov    %cr0,%eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
f0100025:	0f 22 c0             	mov    %eax,%cr0
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp
f0100034:	bc 00 00 11 f0       	mov    $0xf0110000,%esp
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	83 ec 0c             	sub    $0xc,%esp
f0100046:	b8 80 29 11 f0       	mov    $0xf0112980,%eax
f010004b:	2d 00 23 11 f0       	sub    $0xf0112300,%eax
f0100050:	50                   	push   %eax
f0100051:	6a 00                	push   $0x0
f0100053:	68 00 23 11 f0       	push   $0xf0112300
f0100058:	e8 b0 13 00 00       	call   f010140d <memset>
f010005d:	e8 71 04 00 00       	call   f01004d3 <cons_init>
f0100062:	83 c4 08             	add    $0x8,%esp
f0100065:	68 ac 1a 00 00       	push   $0x1aac
f010006a:	68 20 18 10 f0       	push   $0xf0101820
f010006f:	e8 0d 09 00 00       	call   f0100981 <cprintf>
f0100074:	e8 ad 07 00 00       	call   f0100826 <mem_init>
f0100079:	83 c4 10             	add    $0x10,%esp
f010007c:	83 ec 0c             	sub    $0xc,%esp
f010007f:	6a 00                	push   $0x0
f0100081:	e8 3e 06 00 00       	call   f01006c4 <monitor>
f0100086:	83 c4 10             	add    $0x10,%esp
f0100089:	eb f1                	jmp    f010007c <i386_init+0x3c>

f010008b <_panic>:
f010008b:	55                   	push   %ebp
f010008c:	89 e5                	mov    %esp,%ebp
f010008e:	53                   	push   %ebx
f010008f:	83 ec 04             	sub    $0x4,%esp
f0100092:	83 3d 00 23 11 f0 00 	cmpl   $0x0,0xf0112300
f0100099:	74 0f                	je     f01000aa <_panic+0x1f>
f010009b:	83 ec 0c             	sub    $0xc,%esp
f010009e:	6a 00                	push   $0x0
f01000a0:	e8 1f 06 00 00       	call   f01006c4 <monitor>
f01000a5:	83 c4 10             	add    $0x10,%esp
f01000a8:	eb f1                	jmp    f010009b <_panic+0x10>
f01000aa:	8b 45 10             	mov    0x10(%ebp),%eax
f01000ad:	a3 00 23 11 f0       	mov    %eax,0xf0112300
f01000b2:	fa                   	cli    
f01000b3:	fc                   	cld    
f01000b4:	8d 5d 14             	lea    0x14(%ebp),%ebx
f01000b7:	83 ec 04             	sub    $0x4,%esp
f01000ba:	ff 75 0c             	push   0xc(%ebp)
f01000bd:	ff 75 08             	push   0x8(%ebp)
f01000c0:	68 3b 18 10 f0       	push   $0xf010183b
f01000c5:	e8 b7 08 00 00       	call   f0100981 <cprintf>
f01000ca:	83 c4 08             	add    $0x8,%esp
f01000cd:	53                   	push   %ebx
f01000ce:	ff 75 10             	push   0x10(%ebp)
f01000d1:	e8 85 08 00 00       	call   f010095b <vcprintf>
f01000d6:	c7 04 24 77 18 10 f0 	movl   $0xf0101877,(%esp)
f01000dd:	e8 9f 08 00 00       	call   f0100981 <cprintf>
f01000e2:	83 c4 10             	add    $0x10,%esp
f01000e5:	eb b4                	jmp    f010009b <_panic+0x10>

f01000e7 <_warn>:
f01000e7:	55                   	push   %ebp
f01000e8:	89 e5                	mov    %esp,%ebp
f01000ea:	53                   	push   %ebx
f01000eb:	83 ec 08             	sub    $0x8,%esp
f01000ee:	8d 5d 14             	lea    0x14(%ebp),%ebx
f01000f1:	ff 75 0c             	push   0xc(%ebp)
f01000f4:	ff 75 08             	push   0x8(%ebp)
f01000f7:	68 53 18 10 f0       	push   $0xf0101853
f01000fc:	e8 80 08 00 00       	call   f0100981 <cprintf>
f0100101:	83 c4 08             	add    $0x8,%esp
f0100104:	53                   	push   %ebx
f0100105:	ff 75 10             	push   0x10(%ebp)
f0100108:	e8 4e 08 00 00       	call   f010095b <vcprintf>
f010010d:	c7 04 24 77 18 10 f0 	movl   $0xf0101877,(%esp)
f0100114:	e8 68 08 00 00       	call   f0100981 <cprintf>
f0100119:	83 c4 10             	add    $0x10,%esp
f010011c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010011f:	c9                   	leave  
f0100120:	c3                   	ret    

f0100121 <serial_proc_data>:
f0100121:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100126:	ec                   	in     (%dx),%al
f0100127:	a8 01                	test   $0x1,%al
f0100129:	74 0a                	je     f0100135 <serial_proc_data+0x14>
f010012b:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100130:	ec                   	in     (%dx),%al
f0100131:	0f b6 c0             	movzbl %al,%eax
f0100134:	c3                   	ret    
f0100135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010013a:	c3                   	ret    

f010013b <cons_intr>:
f010013b:	55                   	push   %ebp
f010013c:	89 e5                	mov    %esp,%ebp
f010013e:	53                   	push   %ebx
f010013f:	83 ec 04             	sub    $0x4,%esp
f0100142:	89 c3                	mov    %eax,%ebx
f0100144:	ff d3                	call   *%ebx
f0100146:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100149:	74 2d                	je     f0100178 <cons_intr+0x3d>
f010014b:	85 c0                	test   %eax,%eax
f010014d:	74 f5                	je     f0100144 <cons_intr+0x9>
f010014f:	8b 0d 44 25 11 f0    	mov    0xf0112544,%ecx
f0100155:	8d 51 01             	lea    0x1(%ecx),%edx
f0100158:	89 15 44 25 11 f0    	mov    %edx,0xf0112544
f010015e:	88 81 40 23 11 f0    	mov    %al,-0xfeedcc0(%ecx)
f0100164:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010016a:	75 d8                	jne    f0100144 <cons_intr+0x9>
f010016c:	c7 05 44 25 11 f0 00 	movl   $0x0,0xf0112544
f0100173:	00 00 00 
f0100176:	eb cc                	jmp    f0100144 <cons_intr+0x9>
f0100178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010017b:	c9                   	leave  
f010017c:	c3                   	ret    

f010017d <kbd_proc_data>:
f010017d:	55                   	push   %ebp
f010017e:	89 e5                	mov    %esp,%ebp
f0100180:	53                   	push   %ebx
f0100181:	83 ec 04             	sub    $0x4,%esp
f0100184:	ba 64 00 00 00       	mov    $0x64,%edx
f0100189:	ec                   	in     (%dx),%al
f010018a:	a8 01                	test   $0x1,%al
f010018c:	0f 84 e9 00 00 00    	je     f010027b <kbd_proc_data+0xfe>
f0100192:	a8 20                	test   $0x20,%al
f0100194:	0f 85 e8 00 00 00    	jne    f0100282 <kbd_proc_data+0x105>
f010019a:	ba 60 00 00 00       	mov    $0x60,%edx
f010019f:	ec                   	in     (%dx),%al
f01001a0:	88 c2                	mov    %al,%dl
f01001a2:	3c e0                	cmp    $0xe0,%al
f01001a4:	74 60                	je     f0100206 <kbd_proc_data+0x89>
f01001a6:	84 c0                	test   %al,%al
f01001a8:	78 6f                	js     f0100219 <kbd_proc_data+0x9c>
f01001aa:	8b 0d 20 23 11 f0    	mov    0xf0112320,%ecx
f01001b0:	f6 c1 40             	test   $0x40,%cl
f01001b3:	74 0e                	je     f01001c3 <kbd_proc_data+0x46>
f01001b5:	83 c8 80             	or     $0xffffff80,%eax
f01001b8:	88 c2                	mov    %al,%dl
f01001ba:	83 e1 bf             	and    $0xffffffbf,%ecx
f01001bd:	89 0d 20 23 11 f0    	mov    %ecx,0xf0112320
f01001c3:	0f b6 d2             	movzbl %dl,%edx
f01001c6:	0f b6 82 c0 19 10 f0 	movzbl -0xfefe640(%edx),%eax
f01001cd:	0b 05 20 23 11 f0    	or     0xf0112320,%eax
f01001d3:	0f b6 8a c0 18 10 f0 	movzbl -0xfefe740(%edx),%ecx
f01001da:	31 c8                	xor    %ecx,%eax
f01001dc:	a3 20 23 11 f0       	mov    %eax,0xf0112320
f01001e1:	89 c1                	mov    %eax,%ecx
f01001e3:	83 e1 03             	and    $0x3,%ecx
f01001e6:	8b 0c 8d a0 18 10 f0 	mov    -0xfefe760(,%ecx,4),%ecx
f01001ed:	8a 14 11             	mov    (%ecx,%edx,1),%dl
f01001f0:	0f b6 da             	movzbl %dl,%ebx
f01001f3:	a8 08                	test   $0x8,%al
f01001f5:	74 5c                	je     f0100253 <kbd_proc_data+0xd6>
f01001f7:	89 da                	mov    %ebx,%edx
f01001f9:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f01001fc:	83 f9 19             	cmp    $0x19,%ecx
f01001ff:	77 47                	ja     f0100248 <kbd_proc_data+0xcb>
f0100201:	83 eb 20             	sub    $0x20,%ebx
f0100204:	eb 0c                	jmp    f0100212 <kbd_proc_data+0x95>
f0100206:	83 0d 20 23 11 f0 40 	orl    $0x40,0xf0112320
f010020d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100212:	89 d8                	mov    %ebx,%eax
f0100214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100217:	c9                   	leave  
f0100218:	c3                   	ret    
f0100219:	8b 0d 20 23 11 f0    	mov    0xf0112320,%ecx
f010021f:	f6 c1 40             	test   $0x40,%cl
f0100222:	75 05                	jne    f0100229 <kbd_proc_data+0xac>
f0100224:	83 e0 7f             	and    $0x7f,%eax
f0100227:	88 c2                	mov    %al,%dl
f0100229:	0f b6 d2             	movzbl %dl,%edx
f010022c:	8a 82 c0 19 10 f0    	mov    -0xfefe640(%edx),%al
f0100232:	83 c8 40             	or     $0x40,%eax
f0100235:	0f b6 c0             	movzbl %al,%eax
f0100238:	f7 d0                	not    %eax
f010023a:	21 c8                	and    %ecx,%eax
f010023c:	a3 20 23 11 f0       	mov    %eax,0xf0112320
f0100241:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100246:	eb ca                	jmp    f0100212 <kbd_proc_data+0x95>
f0100248:	83 ea 41             	sub    $0x41,%edx
f010024b:	83 fa 19             	cmp    $0x19,%edx
f010024e:	77 03                	ja     f0100253 <kbd_proc_data+0xd6>
f0100250:	83 c3 20             	add    $0x20,%ebx
f0100253:	f7 d0                	not    %eax
f0100255:	a8 06                	test   $0x6,%al
f0100257:	75 b9                	jne    f0100212 <kbd_proc_data+0x95>
f0100259:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010025f:	75 b1                	jne    f0100212 <kbd_proc_data+0x95>
f0100261:	83 ec 0c             	sub    $0xc,%esp
f0100264:	68 6d 18 10 f0       	push   $0xf010186d
f0100269:	e8 13 07 00 00       	call   f0100981 <cprintf>
f010026e:	b0 03                	mov    $0x3,%al
f0100270:	ba 92 00 00 00       	mov    $0x92,%edx
f0100275:	ee                   	out    %al,(%dx)
f0100276:	83 c4 10             	add    $0x10,%esp
f0100279:	eb 97                	jmp    f0100212 <kbd_proc_data+0x95>
f010027b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100280:	eb 90                	jmp    f0100212 <kbd_proc_data+0x95>
f0100282:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100287:	eb 89                	jmp    f0100212 <kbd_proc_data+0x95>

f0100289 <cons_putc>:
f0100289:	55                   	push   %ebp
f010028a:	89 e5                	mov    %esp,%ebp
f010028c:	57                   	push   %edi
f010028d:	56                   	push   %esi
f010028e:	53                   	push   %ebx
f010028f:	83 ec 0c             	sub    $0xc,%esp
f0100292:	89 c1                	mov    %eax,%ecx
f0100294:	bb 01 32 00 00       	mov    $0x3201,%ebx
f0100299:	be fd 03 00 00       	mov    $0x3fd,%esi
f010029e:	bf 84 00 00 00       	mov    $0x84,%edi
f01002a3:	89 f2                	mov    %esi,%edx
f01002a5:	ec                   	in     (%dx),%al
f01002a6:	a8 20                	test   $0x20,%al
f01002a8:	75 0b                	jne    f01002b5 <cons_putc+0x2c>
f01002aa:	4b                   	dec    %ebx
f01002ab:	74 08                	je     f01002b5 <cons_putc+0x2c>
f01002ad:	89 fa                	mov    %edi,%edx
f01002af:	ec                   	in     (%dx),%al
f01002b0:	ec                   	in     (%dx),%al
f01002b1:	ec                   	in     (%dx),%al
f01002b2:	ec                   	in     (%dx),%al
f01002b3:	eb ee                	jmp    f01002a3 <cons_putc+0x1a>
f01002b5:	89 cf                	mov    %ecx,%edi
f01002b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002bc:	88 c8                	mov    %cl,%al
f01002be:	ee                   	out    %al,(%dx)
f01002bf:	bb 01 32 00 00       	mov    $0x3201,%ebx
f01002c4:	be 79 03 00 00       	mov    $0x379,%esi
f01002c9:	89 f2                	mov    %esi,%edx
f01002cb:	ec                   	in     (%dx),%al
f01002cc:	84 c0                	test   %al,%al
f01002ce:	78 0e                	js     f01002de <cons_putc+0x55>
f01002d0:	4b                   	dec    %ebx
f01002d1:	74 0b                	je     f01002de <cons_putc+0x55>
f01002d3:	ba 84 00 00 00       	mov    $0x84,%edx
f01002d8:	ec                   	in     (%dx),%al
f01002d9:	ec                   	in     (%dx),%al
f01002da:	ec                   	in     (%dx),%al
f01002db:	ec                   	in     (%dx),%al
f01002dc:	eb eb                	jmp    f01002c9 <cons_putc+0x40>
f01002de:	ba 78 03 00 00       	mov    $0x378,%edx
f01002e3:	89 f8                	mov    %edi,%eax
f01002e5:	ee                   	out    %al,(%dx)
f01002e6:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01002eb:	b0 0d                	mov    $0xd,%al
f01002ed:	ee                   	out    %al,(%dx)
f01002ee:	b0 08                	mov    $0x8,%al
f01002f0:	ee                   	out    %al,(%dx)
f01002f1:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f01002f7:	75 03                	jne    f01002fc <cons_putc+0x73>
f01002f9:	80 cd 07             	or     $0x7,%ch
f01002fc:	0f b6 c1             	movzbl %cl,%eax
f01002ff:	80 f9 0a             	cmp    $0xa,%cl
f0100302:	0f 84 de 00 00 00    	je     f01003e6 <cons_putc+0x15d>
f0100308:	83 f8 0a             	cmp    $0xa,%eax
f010030b:	7f 46                	jg     f0100353 <cons_putc+0xca>
f010030d:	83 f8 08             	cmp    $0x8,%eax
f0100310:	0f 84 a4 00 00 00    	je     f01003ba <cons_putc+0x131>
f0100316:	83 f8 09             	cmp    $0x9,%eax
f0100319:	0f 85 d4 00 00 00    	jne    f01003f3 <cons_putc+0x16a>
f010031f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100324:	e8 60 ff ff ff       	call   f0100289 <cons_putc>
f0100329:	b8 20 00 00 00       	mov    $0x20,%eax
f010032e:	e8 56 ff ff ff       	call   f0100289 <cons_putc>
f0100333:	b8 20 00 00 00       	mov    $0x20,%eax
f0100338:	e8 4c ff ff ff       	call   f0100289 <cons_putc>
f010033d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100342:	e8 42 ff ff ff       	call   f0100289 <cons_putc>
f0100347:	b8 20 00 00 00       	mov    $0x20,%eax
f010034c:	e8 38 ff ff ff       	call   f0100289 <cons_putc>
f0100351:	eb 28                	jmp    f010037b <cons_putc+0xf2>
f0100353:	83 f8 0d             	cmp    $0xd,%eax
f0100356:	0f 85 97 00 00 00    	jne    f01003f3 <cons_putc+0x16a>
f010035c:	66 8b 0d 48 25 11 f0 	mov    0xf0112548,%cx
f0100363:	bb 50 00 00 00       	mov    $0x50,%ebx
f0100368:	89 c8                	mov    %ecx,%eax
f010036a:	ba 00 00 00 00       	mov    $0x0,%edx
f010036f:	66 f7 f3             	div    %bx
f0100372:	29 d1                	sub    %edx,%ecx
f0100374:	66 89 0d 48 25 11 f0 	mov    %cx,0xf0112548
f010037b:	66 81 3d 48 25 11 f0 	cmpw   $0x7cf,0xf0112548
f0100382:	cf 07 
f0100384:	0f 87 8b 00 00 00    	ja     f0100415 <cons_putc+0x18c>
f010038a:	8b 0d 50 25 11 f0    	mov    0xf0112550,%ecx
f0100390:	b0 0e                	mov    $0xe,%al
f0100392:	89 ca                	mov    %ecx,%edx
f0100394:	ee                   	out    %al,(%dx)
f0100395:	8d 59 01             	lea    0x1(%ecx),%ebx
f0100398:	66 a1 48 25 11 f0    	mov    0xf0112548,%ax
f010039e:	66 c1 e8 08          	shr    $0x8,%ax
f01003a2:	89 da                	mov    %ebx,%edx
f01003a4:	ee                   	out    %al,(%dx)
f01003a5:	b0 0f                	mov    $0xf,%al
f01003a7:	89 ca                	mov    %ecx,%edx
f01003a9:	ee                   	out    %al,(%dx)
f01003aa:	a0 48 25 11 f0       	mov    0xf0112548,%al
f01003af:	89 da                	mov    %ebx,%edx
f01003b1:	ee                   	out    %al,(%dx)
f01003b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01003b5:	5b                   	pop    %ebx
f01003b6:	5e                   	pop    %esi
f01003b7:	5f                   	pop    %edi
f01003b8:	5d                   	pop    %ebp
f01003b9:	c3                   	ret    
f01003ba:	66 a1 48 25 11 f0    	mov    0xf0112548,%ax
f01003c0:	66 85 c0             	test   %ax,%ax
f01003c3:	74 c5                	je     f010038a <cons_putc+0x101>
f01003c5:	48                   	dec    %eax
f01003c6:	66 a3 48 25 11 f0    	mov    %ax,0xf0112548
f01003cc:	0f b7 c0             	movzwl %ax,%eax
f01003cf:	89 cf                	mov    %ecx,%edi
f01003d1:	81 e7 00 ff ff ff    	and    $0xffffff00,%edi
f01003d7:	83 cf 20             	or     $0x20,%edi
f01003da:	8b 15 4c 25 11 f0    	mov    0xf011254c,%edx
f01003e0:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01003e4:	eb 95                	jmp    f010037b <cons_putc+0xf2>
f01003e6:	66 83 05 48 25 11 f0 	addw   $0x50,0xf0112548
f01003ed:	50 
f01003ee:	e9 69 ff ff ff       	jmp    f010035c <cons_putc+0xd3>
f01003f3:	66 a1 48 25 11 f0    	mov    0xf0112548,%ax
f01003f9:	8d 50 01             	lea    0x1(%eax),%edx
f01003fc:	66 89 15 48 25 11 f0 	mov    %dx,0xf0112548
f0100403:	0f b7 c0             	movzwl %ax,%eax
f0100406:	8b 15 4c 25 11 f0    	mov    0xf011254c,%edx
f010040c:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100410:	e9 66 ff ff ff       	jmp    f010037b <cons_putc+0xf2>
f0100415:	a1 4c 25 11 f0       	mov    0xf011254c,%eax
f010041a:	83 ec 04             	sub    $0x4,%esp
f010041d:	68 00 0f 00 00       	push   $0xf00
f0100422:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100428:	52                   	push   %edx
f0100429:	50                   	push   %eax
f010042a:	e8 29 10 00 00       	call   f0101458 <memmove>
f010042f:	8b 15 4c 25 11 f0    	mov    0xf011254c,%edx
f0100435:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f010043b:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100441:	83 c4 10             	add    $0x10,%esp
f0100444:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100449:	83 c0 02             	add    $0x2,%eax
f010044c:	39 d0                	cmp    %edx,%eax
f010044e:	75 f4                	jne    f0100444 <cons_putc+0x1bb>
f0100450:	66 83 2d 48 25 11 f0 	subw   $0x50,0xf0112548
f0100457:	50 
f0100458:	e9 2d ff ff ff       	jmp    f010038a <cons_putc+0x101>

f010045d <serial_intr>:
f010045d:	80 3d 54 25 11 f0 00 	cmpb   $0x0,0xf0112554
f0100464:	75 01                	jne    f0100467 <serial_intr+0xa>
f0100466:	c3                   	ret    
f0100467:	55                   	push   %ebp
f0100468:	89 e5                	mov    %esp,%ebp
f010046a:	83 ec 08             	sub    $0x8,%esp
f010046d:	b8 21 01 10 f0       	mov    $0xf0100121,%eax
f0100472:	e8 c4 fc ff ff       	call   f010013b <cons_intr>
f0100477:	c9                   	leave  
f0100478:	c3                   	ret    

f0100479 <kbd_intr>:
f0100479:	55                   	push   %ebp
f010047a:	89 e5                	mov    %esp,%ebp
f010047c:	83 ec 08             	sub    $0x8,%esp
f010047f:	b8 7d 01 10 f0       	mov    $0xf010017d,%eax
f0100484:	e8 b2 fc ff ff       	call   f010013b <cons_intr>
f0100489:	c9                   	leave  
f010048a:	c3                   	ret    

f010048b <cons_getc>:
f010048b:	55                   	push   %ebp
f010048c:	89 e5                	mov    %esp,%ebp
f010048e:	83 ec 08             	sub    $0x8,%esp
f0100491:	e8 c7 ff ff ff       	call   f010045d <serial_intr>
f0100496:	e8 de ff ff ff       	call   f0100479 <kbd_intr>
f010049b:	a1 40 25 11 f0       	mov    0xf0112540,%eax
f01004a0:	3b 05 44 25 11 f0    	cmp    0xf0112544,%eax
f01004a6:	74 24                	je     f01004cc <cons_getc+0x41>
f01004a8:	8d 50 01             	lea    0x1(%eax),%edx
f01004ab:	89 15 40 25 11 f0    	mov    %edx,0xf0112540
f01004b1:	0f b6 80 40 23 11 f0 	movzbl -0xfeedcc0(%eax),%eax
f01004b8:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01004be:	75 11                	jne    f01004d1 <cons_getc+0x46>
f01004c0:	c7 05 40 25 11 f0 00 	movl   $0x0,0xf0112540
f01004c7:	00 00 00 
f01004ca:	eb 05                	jmp    f01004d1 <cons_getc+0x46>
f01004cc:	b8 00 00 00 00       	mov    $0x0,%eax
f01004d1:	c9                   	leave  
f01004d2:	c3                   	ret    

f01004d3 <cons_init>:
f01004d3:	55                   	push   %ebp
f01004d4:	89 e5                	mov    %esp,%ebp
f01004d6:	57                   	push   %edi
f01004d7:	56                   	push   %esi
f01004d8:	53                   	push   %ebx
f01004d9:	83 ec 0c             	sub    $0xc,%esp
f01004dc:	66 8b 15 00 80 0b f0 	mov    0xf00b8000,%dx
f01004e3:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01004ea:	5a a5 
f01004ec:	66 a1 00 80 0b f0    	mov    0xf00b8000,%ax
f01004f2:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01004f6:	0f 84 9b 00 00 00    	je     f0100597 <cons_init+0xc4>
f01004fc:	bb b4 03 00 00       	mov    $0x3b4,%ebx
f0100501:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f0100506:	89 1d 50 25 11 f0    	mov    %ebx,0xf0112550
f010050c:	b0 0e                	mov    $0xe,%al
f010050e:	89 da                	mov    %ebx,%edx
f0100510:	ee                   	out    %al,(%dx)
f0100511:	8d 7b 01             	lea    0x1(%ebx),%edi
f0100514:	89 fa                	mov    %edi,%edx
f0100516:	ec                   	in     (%dx),%al
f0100517:	0f b6 c8             	movzbl %al,%ecx
f010051a:	c1 e1 08             	shl    $0x8,%ecx
f010051d:	b0 0f                	mov    $0xf,%al
f010051f:	89 da                	mov    %ebx,%edx
f0100521:	ee                   	out    %al,(%dx)
f0100522:	89 fa                	mov    %edi,%edx
f0100524:	ec                   	in     (%dx),%al
f0100525:	89 35 4c 25 11 f0    	mov    %esi,0xf011254c
f010052b:	0f b6 c0             	movzbl %al,%eax
f010052e:	09 c8                	or     %ecx,%eax
f0100530:	66 a3 48 25 11 f0    	mov    %ax,0xf0112548
f0100536:	b1 00                	mov    $0x0,%cl
f0100538:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f010053d:	88 c8                	mov    %cl,%al
f010053f:	89 da                	mov    %ebx,%edx
f0100541:	ee                   	out    %al,(%dx)
f0100542:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100547:	b0 80                	mov    $0x80,%al
f0100549:	89 fa                	mov    %edi,%edx
f010054b:	ee                   	out    %al,(%dx)
f010054c:	b0 0c                	mov    $0xc,%al
f010054e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100553:	ee                   	out    %al,(%dx)
f0100554:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100559:	88 c8                	mov    %cl,%al
f010055b:	89 f2                	mov    %esi,%edx
f010055d:	ee                   	out    %al,(%dx)
f010055e:	b0 03                	mov    $0x3,%al
f0100560:	89 fa                	mov    %edi,%edx
f0100562:	ee                   	out    %al,(%dx)
f0100563:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100568:	88 c8                	mov    %cl,%al
f010056a:	ee                   	out    %al,(%dx)
f010056b:	b0 01                	mov    $0x1,%al
f010056d:	89 f2                	mov    %esi,%edx
f010056f:	ee                   	out    %al,(%dx)
f0100570:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100575:	ec                   	in     (%dx),%al
f0100576:	88 c1                	mov    %al,%cl
f0100578:	3c ff                	cmp    $0xff,%al
f010057a:	0f 95 05 54 25 11 f0 	setne  0xf0112554
f0100581:	89 da                	mov    %ebx,%edx
f0100583:	ec                   	in     (%dx),%al
f0100584:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100589:	ec                   	in     (%dx),%al
f010058a:	80 f9 ff             	cmp    $0xff,%cl
f010058d:	74 1e                	je     f01005ad <cons_init+0xda>
f010058f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100592:	5b                   	pop    %ebx
f0100593:	5e                   	pop    %esi
f0100594:	5f                   	pop    %edi
f0100595:	5d                   	pop    %ebp
f0100596:	c3                   	ret    
f0100597:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f010059e:	bb d4 03 00 00       	mov    $0x3d4,%ebx
f01005a3:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01005a8:	e9 59 ff ff ff       	jmp    f0100506 <cons_init+0x33>
f01005ad:	83 ec 0c             	sub    $0xc,%esp
f01005b0:	68 79 18 10 f0       	push   $0xf0101879
f01005b5:	e8 c7 03 00 00       	call   f0100981 <cprintf>
f01005ba:	83 c4 10             	add    $0x10,%esp
f01005bd:	eb d0                	jmp    f010058f <cons_init+0xbc>

f01005bf <cputchar>:
f01005bf:	55                   	push   %ebp
f01005c0:	89 e5                	mov    %esp,%ebp
f01005c2:	83 ec 08             	sub    $0x8,%esp
f01005c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01005c8:	e8 bc fc ff ff       	call   f0100289 <cons_putc>
f01005cd:	c9                   	leave  
f01005ce:	c3                   	ret    

f01005cf <getchar>:
f01005cf:	55                   	push   %ebp
f01005d0:	89 e5                	mov    %esp,%ebp
f01005d2:	83 ec 08             	sub    $0x8,%esp
f01005d5:	e8 b1 fe ff ff       	call   f010048b <cons_getc>
f01005da:	85 c0                	test   %eax,%eax
f01005dc:	74 f7                	je     f01005d5 <getchar+0x6>
f01005de:	c9                   	leave  
f01005df:	c3                   	ret    

f01005e0 <iscons>:
f01005e0:	b8 01 00 00 00       	mov    $0x1,%eax
f01005e5:	c3                   	ret    

f01005e6 <mon_help>:
f01005e6:	55                   	push   %ebp
f01005e7:	89 e5                	mov    %esp,%ebp
f01005e9:	83 ec 0c             	sub    $0xc,%esp
f01005ec:	68 c0 1a 10 f0       	push   $0xf0101ac0
f01005f1:	68 de 1a 10 f0       	push   $0xf0101ade
f01005f6:	68 e3 1a 10 f0       	push   $0xf0101ae3
f01005fb:	e8 81 03 00 00       	call   f0100981 <cprintf>
f0100600:	83 c4 0c             	add    $0xc,%esp
f0100603:	68 4c 1b 10 f0       	push   $0xf0101b4c
f0100608:	68 ec 1a 10 f0       	push   $0xf0101aec
f010060d:	68 e3 1a 10 f0       	push   $0xf0101ae3
f0100612:	e8 6a 03 00 00       	call   f0100981 <cprintf>
f0100617:	b8 00 00 00 00       	mov    $0x0,%eax
f010061c:	c9                   	leave  
f010061d:	c3                   	ret    

f010061e <mon_kerninfo>:
f010061e:	55                   	push   %ebp
f010061f:	89 e5                	mov    %esp,%ebp
f0100621:	83 ec 14             	sub    $0x14,%esp
f0100624:	68 f5 1a 10 f0       	push   $0xf0101af5
f0100629:	e8 53 03 00 00       	call   f0100981 <cprintf>
f010062e:	83 c4 08             	add    $0x8,%esp
f0100631:	68 0c 00 10 00       	push   $0x10000c
f0100636:	68 74 1b 10 f0       	push   $0xf0101b74
f010063b:	e8 41 03 00 00       	call   f0100981 <cprintf>
f0100640:	83 c4 0c             	add    $0xc,%esp
f0100643:	68 0c 00 10 00       	push   $0x10000c
f0100648:	68 0c 00 10 f0       	push   $0xf010000c
f010064d:	68 9c 1b 10 f0       	push   $0xf0101b9c
f0100652:	e8 2a 03 00 00       	call   f0100981 <cprintf>
f0100657:	83 c4 0c             	add    $0xc,%esp
f010065a:	68 10 18 10 00       	push   $0x101810
f010065f:	68 10 18 10 f0       	push   $0xf0101810
f0100664:	68 c0 1b 10 f0       	push   $0xf0101bc0
f0100669:	e8 13 03 00 00       	call   f0100981 <cprintf>
f010066e:	83 c4 0c             	add    $0xc,%esp
f0100671:	68 00 23 11 00       	push   $0x112300
f0100676:	68 00 23 11 f0       	push   $0xf0112300
f010067b:	68 e4 1b 10 f0       	push   $0xf0101be4
f0100680:	e8 fc 02 00 00       	call   f0100981 <cprintf>
f0100685:	83 c4 0c             	add    $0xc,%esp
f0100688:	68 80 29 11 00       	push   $0x112980
f010068d:	68 80 29 11 f0       	push   $0xf0112980
f0100692:	68 08 1c 10 f0       	push   $0xf0101c08
f0100697:	e8 e5 02 00 00       	call   f0100981 <cprintf>
f010069c:	83 c4 08             	add    $0x8,%esp
f010069f:	b8 80 29 11 f0       	mov    $0xf0112980,%eax
f01006a4:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
f01006a9:	c1 f8 0a             	sar    $0xa,%eax
f01006ac:	50                   	push   %eax
f01006ad:	68 2c 1c 10 f0       	push   $0xf0101c2c
f01006b2:	e8 ca 02 00 00       	call   f0100981 <cprintf>
f01006b7:	b8 00 00 00 00       	mov    $0x0,%eax
f01006bc:	c9                   	leave  
f01006bd:	c3                   	ret    

f01006be <mon_backtrace>:
f01006be:	b8 00 00 00 00       	mov    $0x0,%eax
f01006c3:	c3                   	ret    

f01006c4 <monitor>:
f01006c4:	55                   	push   %ebp
f01006c5:	89 e5                	mov    %esp,%ebp
f01006c7:	57                   	push   %edi
f01006c8:	56                   	push   %esi
f01006c9:	53                   	push   %ebx
f01006ca:	83 ec 58             	sub    $0x58,%esp
f01006cd:	68 58 1c 10 f0       	push   $0xf0101c58
f01006d2:	e8 aa 02 00 00       	call   f0100981 <cprintf>
f01006d7:	c7 04 24 7c 1c 10 f0 	movl   $0xf0101c7c,(%esp)
f01006de:	e8 9e 02 00 00       	call   f0100981 <cprintf>
f01006e3:	83 c4 10             	add    $0x10,%esp
f01006e6:	eb 47                	jmp    f010072f <monitor+0x6b>
f01006e8:	83 ec 08             	sub    $0x8,%esp
f01006eb:	0f be c0             	movsbl %al,%eax
f01006ee:	50                   	push   %eax
f01006ef:	68 12 1b 10 f0       	push   $0xf0101b12
f01006f4:	e8 dd 0c 00 00       	call   f01013d6 <strchr>
f01006f9:	83 c4 10             	add    $0x10,%esp
f01006fc:	85 c0                	test   %eax,%eax
f01006fe:	74 0a                	je     f010070a <monitor+0x46>
f0100700:	c6 03 00             	movb   $0x0,(%ebx)
f0100703:	89 f7                	mov    %esi,%edi
f0100705:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100708:	eb 68                	jmp    f0100772 <monitor+0xae>
f010070a:	80 3b 00             	cmpb   $0x0,(%ebx)
f010070d:	74 6f                	je     f010077e <monitor+0xba>
f010070f:	83 fe 0f             	cmp    $0xf,%esi
f0100712:	74 09                	je     f010071d <monitor+0x59>
f0100714:	8d 7e 01             	lea    0x1(%esi),%edi
f0100717:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010071b:	eb 37                	jmp    f0100754 <monitor+0x90>
f010071d:	83 ec 08             	sub    $0x8,%esp
f0100720:	6a 10                	push   $0x10
f0100722:	68 17 1b 10 f0       	push   $0xf0101b17
f0100727:	e8 55 02 00 00       	call   f0100981 <cprintf>
f010072c:	83 c4 10             	add    $0x10,%esp
f010072f:	83 ec 0c             	sub    $0xc,%esp
f0100732:	68 0e 1b 10 f0       	push   $0xf0101b0e
f0100737:	e8 88 0a 00 00       	call   f01011c4 <readline>
f010073c:	89 c3                	mov    %eax,%ebx
f010073e:	83 c4 10             	add    $0x10,%esp
f0100741:	85 c0                	test   %eax,%eax
f0100743:	74 ea                	je     f010072f <monitor+0x6b>
f0100745:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f010074c:	be 00 00 00 00       	mov    $0x0,%esi
f0100751:	eb 21                	jmp    f0100774 <monitor+0xb0>
f0100753:	43                   	inc    %ebx
f0100754:	8a 03                	mov    (%ebx),%al
f0100756:	84 c0                	test   %al,%al
f0100758:	74 18                	je     f0100772 <monitor+0xae>
f010075a:	83 ec 08             	sub    $0x8,%esp
f010075d:	0f be c0             	movsbl %al,%eax
f0100760:	50                   	push   %eax
f0100761:	68 12 1b 10 f0       	push   $0xf0101b12
f0100766:	e8 6b 0c 00 00       	call   f01013d6 <strchr>
f010076b:	83 c4 10             	add    $0x10,%esp
f010076e:	85 c0                	test   %eax,%eax
f0100770:	74 e1                	je     f0100753 <monitor+0x8f>
f0100772:	89 fe                	mov    %edi,%esi
f0100774:	8a 03                	mov    (%ebx),%al
f0100776:	84 c0                	test   %al,%al
f0100778:	0f 85 6a ff ff ff    	jne    f01006e8 <monitor+0x24>
f010077e:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100785:	00 
f0100786:	85 f6                	test   %esi,%esi
f0100788:	74 a5                	je     f010072f <monitor+0x6b>
f010078a:	83 ec 08             	sub    $0x8,%esp
f010078d:	68 de 1a 10 f0       	push   $0xf0101ade
f0100792:	ff 75 a8             	push   -0x58(%ebp)
f0100795:	e8 e6 0b 00 00       	call   f0101380 <strcmp>
f010079a:	83 c4 10             	add    $0x10,%esp
f010079d:	85 c0                	test   %eax,%eax
f010079f:	74 34                	je     f01007d5 <monitor+0x111>
f01007a1:	83 ec 08             	sub    $0x8,%esp
f01007a4:	68 ec 1a 10 f0       	push   $0xf0101aec
f01007a9:	ff 75 a8             	push   -0x58(%ebp)
f01007ac:	e8 cf 0b 00 00       	call   f0101380 <strcmp>
f01007b1:	83 c4 10             	add    $0x10,%esp
f01007b4:	85 c0                	test   %eax,%eax
f01007b6:	74 18                	je     f01007d0 <monitor+0x10c>
f01007b8:	83 ec 08             	sub    $0x8,%esp
f01007bb:	ff 75 a8             	push   -0x58(%ebp)
f01007be:	68 34 1b 10 f0       	push   $0xf0101b34
f01007c3:	e8 b9 01 00 00       	call   f0100981 <cprintf>
f01007c8:	83 c4 10             	add    $0x10,%esp
f01007cb:	e9 5f ff ff ff       	jmp    f010072f <monitor+0x6b>
f01007d0:	b8 01 00 00 00       	mov    $0x1,%eax
f01007d5:	83 ec 04             	sub    $0x4,%esp
f01007d8:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01007db:	01 d0                	add    %edx,%eax
f01007dd:	ff 75 08             	push   0x8(%ebp)
f01007e0:	8d 4d a8             	lea    -0x58(%ebp),%ecx
f01007e3:	51                   	push   %ecx
f01007e4:	56                   	push   %esi
f01007e5:	ff 14 85 ac 1c 10 f0 	call   *-0xfefe354(,%eax,4)
f01007ec:	83 c4 10             	add    $0x10,%esp
f01007ef:	85 c0                	test   %eax,%eax
f01007f1:	0f 89 38 ff ff ff    	jns    f010072f <monitor+0x6b>
f01007f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007fa:	5b                   	pop    %ebx
f01007fb:	5e                   	pop    %esi
f01007fc:	5f                   	pop    %edi
f01007fd:	5d                   	pop    %ebp
f01007fe:	c3                   	ret    

f01007ff <nvram_read>:
f01007ff:	55                   	push   %ebp
f0100800:	89 e5                	mov    %esp,%ebp
f0100802:	56                   	push   %esi
f0100803:	53                   	push   %ebx
f0100804:	89 c3                	mov    %eax,%ebx
f0100806:	83 ec 0c             	sub    $0xc,%esp
f0100809:	50                   	push   %eax
f010080a:	e8 0b 01 00 00       	call   f010091a <mc146818_read>
f010080f:	89 c6                	mov    %eax,%esi
f0100811:	43                   	inc    %ebx
f0100812:	89 1c 24             	mov    %ebx,(%esp)
f0100815:	e8 00 01 00 00       	call   f010091a <mc146818_read>
f010081a:	c1 e0 08             	shl    $0x8,%eax
f010081d:	09 f0                	or     %esi,%eax
f010081f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100822:	5b                   	pop    %ebx
f0100823:	5e                   	pop    %esi
f0100824:	5d                   	pop    %ebp
f0100825:	c3                   	ret    

f0100826 <mem_init>:
f0100826:	55                   	push   %ebp
f0100827:	89 e5                	mov    %esp,%ebp
f0100829:	56                   	push   %esi
f010082a:	53                   	push   %ebx
f010082b:	b8 15 00 00 00       	mov    $0x15,%eax
f0100830:	e8 ca ff ff ff       	call   f01007ff <nvram_read>
f0100835:	89 c3                	mov    %eax,%ebx
f0100837:	b8 17 00 00 00       	mov    $0x17,%eax
f010083c:	e8 be ff ff ff       	call   f01007ff <nvram_read>
f0100841:	89 c6                	mov    %eax,%esi
f0100843:	b8 34 00 00 00       	mov    $0x34,%eax
f0100848:	e8 b2 ff ff ff       	call   f01007ff <nvram_read>
f010084d:	c1 e0 06             	shl    $0x6,%eax
f0100850:	74 38                	je     f010088a <mem_init+0x64>
f0100852:	05 00 40 00 00       	add    $0x4000,%eax
f0100857:	89 c2                	mov    %eax,%edx
f0100859:	c1 ea 02             	shr    $0x2,%edx
f010085c:	89 15 60 25 11 f0    	mov    %edx,0xf0112560
f0100862:	89 c2                	mov    %eax,%edx
f0100864:	29 da                	sub    %ebx,%edx
f0100866:	52                   	push   %edx
f0100867:	53                   	push   %ebx
f0100868:	50                   	push   %eax
f0100869:	68 bc 1c 10 f0       	push   $0xf0101cbc
f010086e:	e8 0e 01 00 00       	call   f0100981 <cprintf>
f0100873:	83 c4 0c             	add    $0xc,%esp
f0100876:	68 f8 1c 10 f0       	push   $0xf0101cf8
f010087b:	68 80 00 00 00       	push   $0x80
f0100880:	68 21 1d 10 f0       	push   $0xf0101d21
f0100885:	e8 01 f8 ff ff       	call   f010008b <_panic>
f010088a:	89 d8                	mov    %ebx,%eax
f010088c:	85 f6                	test   %esi,%esi
f010088e:	74 c7                	je     f0100857 <mem_init+0x31>
f0100890:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0100896:	eb bf                	jmp    f0100857 <mem_init+0x31>

f0100898 <page_init>:
f0100898:	55                   	push   %ebp
f0100899:	89 e5                	mov    %esp,%ebp
f010089b:	56                   	push   %esi
f010089c:	53                   	push   %ebx
f010089d:	8b 1d 64 25 11 f0    	mov    0xf0112564,%ebx
f01008a3:	b2 00                	mov    $0x0,%dl
f01008a5:	b8 00 00 00 00       	mov    $0x0,%eax
f01008aa:	be 01 00 00 00       	mov    $0x1,%esi
f01008af:	eb 22                	jmp    f01008d3 <page_init+0x3b>
f01008b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f01008b8:	89 d1                	mov    %edx,%ecx
f01008ba:	03 0d 58 25 11 f0    	add    0xf0112558,%ecx
f01008c0:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f01008c6:	89 19                	mov    %ebx,(%ecx)
f01008c8:	89 d3                	mov    %edx,%ebx
f01008ca:	03 1d 58 25 11 f0    	add    0xf0112558,%ebx
f01008d0:	40                   	inc    %eax
f01008d1:	89 f2                	mov    %esi,%edx
f01008d3:	39 05 60 25 11 f0    	cmp    %eax,0xf0112560
f01008d9:	77 d6                	ja     f01008b1 <page_init+0x19>
f01008db:	84 d2                	test   %dl,%dl
f01008dd:	74 06                	je     f01008e5 <page_init+0x4d>
f01008df:	89 1d 64 25 11 f0    	mov    %ebx,0xf0112564
f01008e5:	5b                   	pop    %ebx
f01008e6:	5e                   	pop    %esi
f01008e7:	5d                   	pop    %ebp
f01008e8:	c3                   	ret    

f01008e9 <page_alloc>:
f01008e9:	b8 00 00 00 00       	mov    $0x0,%eax
f01008ee:	c3                   	ret    

f01008ef <page_free>:
f01008ef:	c3                   	ret    

f01008f0 <page_decref>:
f01008f0:	55                   	push   %ebp
f01008f1:	89 e5                	mov    %esp,%ebp
f01008f3:	8b 45 08             	mov    0x8(%ebp),%eax
f01008f6:	66 ff 48 04          	decw   0x4(%eax)
f01008fa:	5d                   	pop    %ebp
f01008fb:	c3                   	ret    

f01008fc <pgdir_walk>:
f01008fc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100901:	c3                   	ret    

f0100902 <page_insert>:
f0100902:	b8 00 00 00 00       	mov    $0x0,%eax
f0100907:	c3                   	ret    

f0100908 <page_lookup>:
f0100908:	b8 00 00 00 00       	mov    $0x0,%eax
f010090d:	c3                   	ret    

f010090e <page_remove>:
f010090e:	c3                   	ret    

f010090f <tlb_invalidate>:
f010090f:	55                   	push   %ebp
f0100910:	89 e5                	mov    %esp,%ebp
f0100912:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100915:	0f 01 38             	invlpg (%eax)
f0100918:	5d                   	pop    %ebp
f0100919:	c3                   	ret    

f010091a <mc146818_read>:
f010091a:	55                   	push   %ebp
f010091b:	89 e5                	mov    %esp,%ebp
f010091d:	8b 45 08             	mov    0x8(%ebp),%eax
f0100920:	ba 70 00 00 00       	mov    $0x70,%edx
f0100925:	ee                   	out    %al,(%dx)
f0100926:	ba 71 00 00 00       	mov    $0x71,%edx
f010092b:	ec                   	in     (%dx),%al
f010092c:	0f b6 c0             	movzbl %al,%eax
f010092f:	5d                   	pop    %ebp
f0100930:	c3                   	ret    

f0100931 <mc146818_write>:
f0100931:	55                   	push   %ebp
f0100932:	89 e5                	mov    %esp,%ebp
f0100934:	8b 45 08             	mov    0x8(%ebp),%eax
f0100937:	ba 70 00 00 00       	mov    $0x70,%edx
f010093c:	ee                   	out    %al,(%dx)
f010093d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100940:	ba 71 00 00 00       	mov    $0x71,%edx
f0100945:	ee                   	out    %al,(%dx)
f0100946:	5d                   	pop    %ebp
f0100947:	c3                   	ret    

f0100948 <putch>:
f0100948:	55                   	push   %ebp
f0100949:	89 e5                	mov    %esp,%ebp
f010094b:	83 ec 14             	sub    $0x14,%esp
f010094e:	ff 75 08             	push   0x8(%ebp)
f0100951:	e8 69 fc ff ff       	call   f01005bf <cputchar>
f0100956:	83 c4 10             	add    $0x10,%esp
f0100959:	c9                   	leave  
f010095a:	c3                   	ret    

f010095b <vcprintf>:
f010095b:	55                   	push   %ebp
f010095c:	89 e5                	mov    %esp,%ebp
f010095e:	83 ec 18             	sub    $0x18,%esp
f0100961:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0100968:	ff 75 0c             	push   0xc(%ebp)
f010096b:	ff 75 08             	push   0x8(%ebp)
f010096e:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100971:	50                   	push   %eax
f0100972:	68 48 09 10 f0       	push   $0xf0100948
f0100977:	e8 d1 03 00 00       	call   f0100d4d <vprintfmt>
f010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010097f:	c9                   	leave  
f0100980:	c3                   	ret    

f0100981 <cprintf>:
f0100981:	55                   	push   %ebp
f0100982:	89 e5                	mov    %esp,%ebp
f0100984:	83 ec 10             	sub    $0x10,%esp
f0100987:	8d 45 0c             	lea    0xc(%ebp),%eax
f010098a:	50                   	push   %eax
f010098b:	ff 75 08             	push   0x8(%ebp)
f010098e:	e8 c8 ff ff ff       	call   f010095b <vcprintf>
f0100993:	c9                   	leave  
f0100994:	c3                   	ret    

f0100995 <stab_binsearch>:
f0100995:	55                   	push   %ebp
f0100996:	89 e5                	mov    %esp,%ebp
f0100998:	57                   	push   %edi
f0100999:	56                   	push   %esi
f010099a:	53                   	push   %ebx
f010099b:	83 ec 14             	sub    $0x14,%esp
f010099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01009a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01009a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01009a7:	8b 75 08             	mov    0x8(%ebp),%esi
f01009aa:	8b 1a                	mov    (%edx),%ebx
f01009ac:	8b 39                	mov    (%ecx),%edi
f01009ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f01009b5:	eb 31                	jmp    f01009e8 <stab_binsearch+0x53>
f01009b7:	48                   	dec    %eax
f01009b8:	39 c3                	cmp    %eax,%ebx
f01009ba:	7f 50                	jg     f0100a0c <stab_binsearch+0x77>
f01009bc:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f01009c0:	83 ea 0c             	sub    $0xc,%edx
f01009c3:	39 f1                	cmp    %esi,%ecx
f01009c5:	75 f0                	jne    f01009b7 <stab_binsearch+0x22>
f01009c7:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01009ca:	01 c2                	add    %eax,%edx
f01009cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f01009cf:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01009d3:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01009d6:	73 3a                	jae    f0100a12 <stab_binsearch+0x7d>
f01009d8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01009db:	89 03                	mov    %eax,(%ebx)
f01009dd:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f01009e0:	43                   	inc    %ebx
f01009e1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01009e8:	39 fb                	cmp    %edi,%ebx
f01009ea:	7f 4f                	jg     f0100a3b <stab_binsearch+0xa6>
f01009ec:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f01009ef:	89 d0                	mov    %edx,%eax
f01009f1:	c1 e8 1f             	shr    $0x1f,%eax
f01009f4:	01 d0                	add    %edx,%eax
f01009f6:	89 c1                	mov    %eax,%ecx
f01009f8:	d1 f9                	sar    %ecx
f01009fa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
f01009fd:	83 e0 fe             	and    $0xfffffffe,%eax
f0100a00:	01 c8                	add    %ecx,%eax
f0100a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100a05:	8d 14 82             	lea    (%edx,%eax,4),%edx
f0100a08:	89 c8                	mov    %ecx,%eax
f0100a0a:	eb ac                	jmp    f01009b8 <stab_binsearch+0x23>
f0100a0c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0100a0f:	43                   	inc    %ebx
f0100a10:	eb d6                	jmp    f01009e8 <stab_binsearch+0x53>
f0100a12:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100a15:	76 11                	jbe    f0100a28 <stab_binsearch+0x93>
f0100a17:	8d 78 ff             	lea    -0x1(%eax),%edi
f0100a1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100a1d:	89 38                	mov    %edi,(%eax)
f0100a1f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100a26:	eb c0                	jmp    f01009e8 <stab_binsearch+0x53>
f0100a28:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100a2b:	89 03                	mov    %eax,(%ebx)
f0100a2d:	ff 45 0c             	incl   0xc(%ebp)
f0100a30:	89 c3                	mov    %eax,%ebx
f0100a32:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100a39:	eb ad                	jmp    f01009e8 <stab_binsearch+0x53>
f0100a3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0100a3f:	75 13                	jne    f0100a54 <stab_binsearch+0xbf>
f0100a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100a44:	8b 00                	mov    (%eax),%eax
f0100a46:	48                   	dec    %eax
f0100a47:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100a4a:	89 07                	mov    %eax,(%edi)
f0100a4c:	83 c4 14             	add    $0x14,%esp
f0100a4f:	5b                   	pop    %ebx
f0100a50:	5e                   	pop    %esi
f0100a51:	5f                   	pop    %edi
f0100a52:	5d                   	pop    %ebp
f0100a53:	c3                   	ret    
f0100a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100a57:	8b 00                	mov    (%eax),%eax
f0100a59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100a5c:	8b 0f                	mov    (%edi),%ecx
f0100a5e:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0100a61:	01 c2                	add    %eax,%edx
f0100a63:	8b 7d f0             	mov    -0x10(%ebp),%edi
f0100a66:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0100a69:	39 c1                	cmp    %eax,%ecx
f0100a6b:	7d 0e                	jge    f0100a7b <stab_binsearch+0xe6>
f0100a6d:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0100a71:	83 ea 0c             	sub    $0xc,%edx
f0100a74:	39 f3                	cmp    %esi,%ebx
f0100a76:	74 03                	je     f0100a7b <stab_binsearch+0xe6>
f0100a78:	48                   	dec    %eax
f0100a79:	eb ee                	jmp    f0100a69 <stab_binsearch+0xd4>
f0100a7b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100a7e:	89 07                	mov    %eax,(%edi)
f0100a80:	eb ca                	jmp    f0100a4c <stab_binsearch+0xb7>

f0100a82 <debuginfo_eip>:
f0100a82:	55                   	push   %ebp
f0100a83:	89 e5                	mov    %esp,%ebp
f0100a85:	57                   	push   %edi
f0100a86:	56                   	push   %esi
f0100a87:	53                   	push   %ebx
f0100a88:	83 ec 2c             	sub    $0x2c,%esp
f0100a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0100a8e:	8b 75 0c             	mov    0xc(%ebp),%esi
f0100a91:	c7 06 2d 1d 10 f0    	movl   $0xf0101d2d,(%esi)
f0100a97:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
f0100a9e:	c7 46 08 2d 1d 10 f0 	movl   $0xf0101d2d,0x8(%esi)
f0100aa5:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
f0100aac:	89 5e 10             	mov    %ebx,0x10(%esi)
f0100aaf:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
f0100ab6:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0100abc:	0f 86 04 01 00 00    	jbe    f0100bc6 <debuginfo_eip+0x144>
f0100ac2:	b8 1b 76 10 f0       	mov    $0xf010761b,%eax
f0100ac7:	3d 09 5d 10 f0       	cmp    $0xf0105d09,%eax
f0100acc:	0f 86 74 01 00 00    	jbe    f0100c46 <debuginfo_eip+0x1c4>
f0100ad2:	80 3d 1a 76 10 f0 00 	cmpb   $0x0,0xf010761a
f0100ad9:	0f 85 6e 01 00 00    	jne    f0100c4d <debuginfo_eip+0x1cb>
f0100adf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100ae6:	b8 08 5d 10 f0       	mov    $0xf0105d08,%eax
f0100aeb:	2d 64 1f 10 f0       	sub    $0xf0101f64,%eax
f0100af0:	89 c2                	mov    %eax,%edx
f0100af2:	c1 fa 02             	sar    $0x2,%edx
f0100af5:	83 e0 fc             	and    $0xfffffffc,%eax
f0100af8:	01 d0                	add    %edx,%eax
f0100afa:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100afd:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100b00:	89 c1                	mov    %eax,%ecx
f0100b02:	c1 e1 08             	shl    $0x8,%ecx
f0100b05:	01 c8                	add    %ecx,%eax
f0100b07:	89 c1                	mov    %eax,%ecx
f0100b09:	c1 e1 10             	shl    $0x10,%ecx
f0100b0c:	01 c8                	add    %ecx,%eax
f0100b0e:	01 c0                	add    %eax,%eax
f0100b10:	8d 44 02 ff          	lea    -0x1(%edx,%eax,1),%eax
f0100b14:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100b17:	83 ec 08             	sub    $0x8,%esp
f0100b1a:	53                   	push   %ebx
f0100b1b:	6a 64                	push   $0x64
f0100b1d:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100b20:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100b23:	b8 64 1f 10 f0       	mov    $0xf0101f64,%eax
f0100b28:	e8 68 fe ff ff       	call   f0100995 <stab_binsearch>
f0100b2d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100b30:	83 c4 10             	add    $0x10,%esp
f0100b33:	85 ff                	test   %edi,%edi
f0100b35:	0f 84 19 01 00 00    	je     f0100c54 <debuginfo_eip+0x1d2>
f0100b3b:	89 7d dc             	mov    %edi,-0x24(%ebp)
f0100b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100b41:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100b44:	83 ec 08             	sub    $0x8,%esp
f0100b47:	53                   	push   %ebx
f0100b48:	6a 24                	push   $0x24
f0100b4a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100b4d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100b50:	b8 64 1f 10 f0       	mov    $0xf0101f64,%eax
f0100b55:	e8 3b fe ff ff       	call   f0100995 <stab_binsearch>
f0100b5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100b5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0100b63:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f0100b66:	83 c4 10             	add    $0x10,%esp
f0100b69:	89 c1                	mov    %eax,%ecx
f0100b6b:	39 d8                	cmp    %ebx,%eax
f0100b6d:	7f 6b                	jg     f0100bda <debuginfo_eip+0x158>
f0100b6f:	01 c0                	add    %eax,%eax
f0100b71:	01 c8                	add    %ecx,%eax
f0100b73:	c1 e0 02             	shl    $0x2,%eax
f0100b76:	8d 90 64 1f 10 f0    	lea    -0xfefe09c(%eax),%edx
f0100b7c:	8b 88 64 1f 10 f0    	mov    -0xfefe09c(%eax),%ecx
f0100b82:	b8 1b 76 10 f0       	mov    $0xf010761b,%eax
f0100b87:	2d 09 5d 10 f0       	sub    $0xf0105d09,%eax
f0100b8c:	39 c1                	cmp    %eax,%ecx
f0100b8e:	73 09                	jae    f0100b99 <debuginfo_eip+0x117>
f0100b90:	81 c1 09 5d 10 f0    	add    $0xf0105d09,%ecx
f0100b96:	89 4e 08             	mov    %ecx,0x8(%esi)
f0100b99:	8b 42 08             	mov    0x8(%edx),%eax
f0100b9c:	89 46 10             	mov    %eax,0x10(%esi)
f0100b9f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100ba2:	83 ec 08             	sub    $0x8,%esp
f0100ba5:	6a 3a                	push   $0x3a
f0100ba7:	ff 76 08             	push   0x8(%esi)
f0100baa:	e8 46 08 00 00       	call   f01013f5 <strfind>
f0100baf:	2b 46 08             	sub    0x8(%esi),%eax
f0100bb2:	89 46 0c             	mov    %eax,0xc(%esi)
f0100bb5:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
f0100bb8:	01 d8                	add    %ebx,%eax
f0100bba:	8d 04 85 64 1f 10 f0 	lea    -0xfefe09c(,%eax,4),%eax
f0100bc1:	83 c4 10             	add    $0x10,%esp
f0100bc4:	eb 1c                	jmp    f0100be2 <debuginfo_eip+0x160>
f0100bc6:	83 ec 04             	sub    $0x4,%esp
f0100bc9:	68 37 1d 10 f0       	push   $0xf0101d37
f0100bce:	6a 7f                	push   $0x7f
f0100bd0:	68 44 1d 10 f0       	push   $0xf0101d44
f0100bd5:	e8 b1 f4 ff ff       	call   f010008b <_panic>
f0100bda:	89 fb                	mov    %edi,%ebx
f0100bdc:	eb c4                	jmp    f0100ba2 <debuginfo_eip+0x120>
f0100bde:	4b                   	dec    %ebx
f0100bdf:	83 e8 0c             	sub    $0xc,%eax
f0100be2:	39 df                	cmp    %ebx,%edi
f0100be4:	7f 35                	jg     f0100c1b <debuginfo_eip+0x199>
f0100be6:	8a 50 04             	mov    0x4(%eax),%dl
f0100be9:	80 fa 84             	cmp    $0x84,%dl
f0100bec:	74 0b                	je     f0100bf9 <debuginfo_eip+0x177>
f0100bee:	80 fa 64             	cmp    $0x64,%dl
f0100bf1:	75 eb                	jne    f0100bde <debuginfo_eip+0x15c>
f0100bf3:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
f0100bf7:	74 e5                	je     f0100bde <debuginfo_eip+0x15c>
f0100bf9:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
f0100bfc:	01 d8                	add    %ebx,%eax
f0100bfe:	8b 14 85 64 1f 10 f0 	mov    -0xfefe09c(,%eax,4),%edx
f0100c05:	b8 1b 76 10 f0       	mov    $0xf010761b,%eax
f0100c0a:	2d 09 5d 10 f0       	sub    $0xf0105d09,%eax
f0100c0f:	39 c2                	cmp    %eax,%edx
f0100c11:	73 08                	jae    f0100c1b <debuginfo_eip+0x199>
f0100c13:	81 c2 09 5d 10 f0    	add    $0xf0105d09,%edx
f0100c19:	89 16                	mov    %edx,(%esi)
f0100c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100c1e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100c21:	39 c8                	cmp    %ecx,%eax
f0100c23:	7d 36                	jge    f0100c5b <debuginfo_eip+0x1d9>
f0100c25:	40                   	inc    %eax
f0100c26:	eb 04                	jmp    f0100c2c <debuginfo_eip+0x1aa>
f0100c28:	ff 46 14             	incl   0x14(%esi)
f0100c2b:	40                   	inc    %eax
f0100c2c:	39 c1                	cmp    %eax,%ecx
f0100c2e:	74 38                	je     f0100c68 <debuginfo_eip+0x1e6>
f0100c30:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0100c33:	01 c2                	add    %eax,%edx
f0100c35:	80 3c 95 68 1f 10 f0 	cmpb   $0xa0,-0xfefe098(,%edx,4)
f0100c3c:	a0 
f0100c3d:	74 e9                	je     f0100c28 <debuginfo_eip+0x1a6>
f0100c3f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c44:	eb 1a                	jmp    f0100c60 <debuginfo_eip+0x1de>
f0100c46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c4b:	eb 13                	jmp    f0100c60 <debuginfo_eip+0x1de>
f0100c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c52:	eb 0c                	jmp    f0100c60 <debuginfo_eip+0x1de>
f0100c54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c59:	eb 05                	jmp    f0100c60 <debuginfo_eip+0x1de>
f0100c5b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c63:	5b                   	pop    %ebx
f0100c64:	5e                   	pop    %esi
f0100c65:	5f                   	pop    %edi
f0100c66:	5d                   	pop    %ebp
f0100c67:	c3                   	ret    
f0100c68:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c6d:	eb f1                	jmp    f0100c60 <debuginfo_eip+0x1de>

f0100c6f <printnum>:
f0100c6f:	55                   	push   %ebp
f0100c70:	89 e5                	mov    %esp,%ebp
f0100c72:	57                   	push   %edi
f0100c73:	56                   	push   %esi
f0100c74:	53                   	push   %ebx
f0100c75:	83 ec 1c             	sub    $0x1c,%esp
f0100c78:	89 c7                	mov    %eax,%edi
f0100c7a:	89 d6                	mov    %edx,%esi
f0100c7c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100c82:	89 d1                	mov    %edx,%ecx
f0100c84:	89 c2                	mov    %eax,%edx
f0100c86:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100c89:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0100c8c:	8b 45 10             	mov    0x10(%ebp),%eax
f0100c8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0100c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100c95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100c9c:	39 c2                	cmp    %eax,%edx
f0100c9e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0100ca1:	72 3c                	jb     f0100cdf <printnum+0x70>
f0100ca3:	83 ec 0c             	sub    $0xc,%esp
f0100ca6:	ff 75 18             	push   0x18(%ebp)
f0100ca9:	4b                   	dec    %ebx
f0100caa:	53                   	push   %ebx
f0100cab:	50                   	push   %eax
f0100cac:	83 ec 08             	sub    $0x8,%esp
f0100caf:	ff 75 e4             	push   -0x1c(%ebp)
f0100cb2:	ff 75 e0             	push   -0x20(%ebp)
f0100cb5:	ff 75 dc             	push   -0x24(%ebp)
f0100cb8:	ff 75 d8             	push   -0x28(%ebp)
f0100cbb:	e8 2c 09 00 00       	call   f01015ec <__udivdi3>
f0100cc0:	83 c4 18             	add    $0x18,%esp
f0100cc3:	52                   	push   %edx
f0100cc4:	50                   	push   %eax
f0100cc5:	89 f2                	mov    %esi,%edx
f0100cc7:	89 f8                	mov    %edi,%eax
f0100cc9:	e8 a1 ff ff ff       	call   f0100c6f <printnum>
f0100cce:	83 c4 20             	add    $0x20,%esp
f0100cd1:	eb 11                	jmp    f0100ce4 <printnum+0x75>
f0100cd3:	83 ec 08             	sub    $0x8,%esp
f0100cd6:	56                   	push   %esi
f0100cd7:	ff 75 18             	push   0x18(%ebp)
f0100cda:	ff d7                	call   *%edi
f0100cdc:	83 c4 10             	add    $0x10,%esp
f0100cdf:	4b                   	dec    %ebx
f0100ce0:	85 db                	test   %ebx,%ebx
f0100ce2:	7f ef                	jg     f0100cd3 <printnum+0x64>
f0100ce4:	83 ec 08             	sub    $0x8,%esp
f0100ce7:	56                   	push   %esi
f0100ce8:	83 ec 04             	sub    $0x4,%esp
f0100ceb:	ff 75 e4             	push   -0x1c(%ebp)
f0100cee:	ff 75 e0             	push   -0x20(%ebp)
f0100cf1:	ff 75 dc             	push   -0x24(%ebp)
f0100cf4:	ff 75 d8             	push   -0x28(%ebp)
f0100cf7:	e8 f8 09 00 00       	call   f01016f4 <__umoddi3>
f0100cfc:	83 c4 14             	add    $0x14,%esp
f0100cff:	0f be 80 52 1d 10 f0 	movsbl -0xfefe2ae(%eax),%eax
f0100d06:	50                   	push   %eax
f0100d07:	ff d7                	call   *%edi
f0100d09:	83 c4 10             	add    $0x10,%esp
f0100d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d0f:	5b                   	pop    %ebx
f0100d10:	5e                   	pop    %esi
f0100d11:	5f                   	pop    %edi
f0100d12:	5d                   	pop    %ebp
f0100d13:	c3                   	ret    

f0100d14 <sprintputch>:
f0100d14:	55                   	push   %ebp
f0100d15:	89 e5                	mov    %esp,%ebp
f0100d17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100d1a:	ff 40 08             	incl   0x8(%eax)
f0100d1d:	8b 10                	mov    (%eax),%edx
f0100d1f:	3b 50 04             	cmp    0x4(%eax),%edx
f0100d22:	73 0a                	jae    f0100d2e <sprintputch+0x1a>
f0100d24:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100d27:	89 08                	mov    %ecx,(%eax)
f0100d29:	8b 45 08             	mov    0x8(%ebp),%eax
f0100d2c:	88 02                	mov    %al,(%edx)
f0100d2e:	5d                   	pop    %ebp
f0100d2f:	c3                   	ret    

f0100d30 <printfmt>:
f0100d30:	55                   	push   %ebp
f0100d31:	89 e5                	mov    %esp,%ebp
f0100d33:	83 ec 08             	sub    $0x8,%esp
f0100d36:	8d 45 14             	lea    0x14(%ebp),%eax
f0100d39:	50                   	push   %eax
f0100d3a:	ff 75 10             	push   0x10(%ebp)
f0100d3d:	ff 75 0c             	push   0xc(%ebp)
f0100d40:	ff 75 08             	push   0x8(%ebp)
f0100d43:	e8 05 00 00 00       	call   f0100d4d <vprintfmt>
f0100d48:	83 c4 10             	add    $0x10,%esp
f0100d4b:	c9                   	leave  
f0100d4c:	c3                   	ret    

f0100d4d <vprintfmt>:
f0100d4d:	55                   	push   %ebp
f0100d4e:	89 e5                	mov    %esp,%ebp
f0100d50:	57                   	push   %edi
f0100d51:	56                   	push   %esi
f0100d52:	53                   	push   %ebx
f0100d53:	83 ec 3c             	sub    $0x3c,%esp
f0100d56:	8b 75 08             	mov    0x8(%ebp),%esi
f0100d59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100d5c:	8b 7d 10             	mov    0x10(%ebp),%edi
f0100d5f:	eb 0a                	jmp    f0100d6b <vprintfmt+0x1e>
f0100d61:	83 ec 08             	sub    $0x8,%esp
f0100d64:	53                   	push   %ebx
f0100d65:	50                   	push   %eax
f0100d66:	ff d6                	call   *%esi
f0100d68:	83 c4 10             	add    $0x10,%esp
f0100d6b:	47                   	inc    %edi
f0100d6c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0100d70:	83 f8 25             	cmp    $0x25,%eax
f0100d73:	74 0c                	je     f0100d81 <vprintfmt+0x34>
f0100d75:	85 c0                	test   %eax,%eax
f0100d77:	75 e8                	jne    f0100d61 <vprintfmt+0x14>
f0100d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d7c:	5b                   	pop    %ebx
f0100d7d:	5e                   	pop    %esi
f0100d7e:	5f                   	pop    %edi
f0100d7f:	5d                   	pop    %ebp
f0100d80:	c3                   	ret    
f0100d81:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
f0100d85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100d8c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0100d93:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f0100d9a:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100d9f:	8d 47 01             	lea    0x1(%edi),%eax
f0100da2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100da5:	8a 17                	mov    (%edi),%dl
f0100da7:	8d 42 dd             	lea    -0x23(%edx),%eax
f0100daa:	3c 55                	cmp    $0x55,%al
f0100dac:	0f 87 88 03 00 00    	ja     f010113a <vprintfmt+0x3ed>
f0100db2:	0f b6 c0             	movzbl %al,%eax
f0100db5:	ff 24 85 e0 1d 10 f0 	jmp    *-0xfefe220(,%eax,4)
f0100dbc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100dbf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f0100dc3:	eb da                	jmp    f0100d9f <vprintfmt+0x52>
f0100dc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100dc8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f0100dcc:	eb d1                	jmp    f0100d9f <vprintfmt+0x52>
f0100dce:	0f b6 d2             	movzbl %dl,%edx
f0100dd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100dd4:	b8 00 00 00 00       	mov    $0x0,%eax
f0100dd9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0100ddc:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100ddf:	01 c0                	add    %eax,%eax
f0100de1:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
f0100de5:	0f be 17             	movsbl (%edi),%edx
f0100de8:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0100deb:	83 f9 09             	cmp    $0x9,%ecx
f0100dee:	77 52                	ja     f0100e42 <vprintfmt+0xf5>
f0100df0:	47                   	inc    %edi
f0100df1:	eb e9                	jmp    f0100ddc <vprintfmt+0x8f>
f0100df3:	8b 45 14             	mov    0x14(%ebp),%eax
f0100df6:	8b 00                	mov    (%eax),%eax
f0100df8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100dfb:	8b 45 14             	mov    0x14(%ebp),%eax
f0100dfe:	8d 40 04             	lea    0x4(%eax),%eax
f0100e01:	89 45 14             	mov    %eax,0x14(%ebp)
f0100e04:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100e07:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0100e0b:	79 92                	jns    f0100d9f <vprintfmt+0x52>
f0100e0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e10:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100e13:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0100e1a:	eb 83                	jmp    f0100d9f <vprintfmt+0x52>
f0100e1c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0100e20:	78 08                	js     f0100e2a <vprintfmt+0xdd>
f0100e22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100e25:	e9 75 ff ff ff       	jmp    f0100d9f <vprintfmt+0x52>
f0100e2a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0100e31:	eb ef                	jmp    f0100e22 <vprintfmt+0xd5>
f0100e33:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100e36:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
f0100e3d:	e9 5d ff ff ff       	jmp    f0100d9f <vprintfmt+0x52>
f0100e42:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0100e45:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100e48:	eb bd                	jmp    f0100e07 <vprintfmt+0xba>
f0100e4a:	41                   	inc    %ecx
f0100e4b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100e4e:	e9 4c ff ff ff       	jmp    f0100d9f <vprintfmt+0x52>
f0100e53:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e56:	8d 78 04             	lea    0x4(%eax),%edi
f0100e59:	83 ec 08             	sub    $0x8,%esp
f0100e5c:	53                   	push   %ebx
f0100e5d:	ff 30                	push   (%eax)
f0100e5f:	ff d6                	call   *%esi
f0100e61:	83 c4 10             	add    $0x10,%esp
f0100e64:	89 7d 14             	mov    %edi,0x14(%ebp)
f0100e67:	e9 6d 02 00 00       	jmp    f01010d9 <vprintfmt+0x38c>
f0100e6c:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e6f:	8d 78 04             	lea    0x4(%eax),%edi
f0100e72:	8b 00                	mov    (%eax),%eax
f0100e74:	85 c0                	test   %eax,%eax
f0100e76:	78 2a                	js     f0100ea2 <vprintfmt+0x155>
f0100e78:	89 c2                	mov    %eax,%edx
f0100e7a:	83 f8 06             	cmp    $0x6,%eax
f0100e7d:	7f 27                	jg     f0100ea6 <vprintfmt+0x159>
f0100e7f:	8b 04 85 38 1f 10 f0 	mov    -0xfefe0c8(,%eax,4),%eax
f0100e86:	85 c0                	test   %eax,%eax
f0100e88:	74 1c                	je     f0100ea6 <vprintfmt+0x159>
f0100e8a:	50                   	push   %eax
f0100e8b:	68 73 1d 10 f0       	push   $0xf0101d73
f0100e90:	53                   	push   %ebx
f0100e91:	56                   	push   %esi
f0100e92:	e8 99 fe ff ff       	call   f0100d30 <printfmt>
f0100e97:	83 c4 10             	add    $0x10,%esp
f0100e9a:	89 7d 14             	mov    %edi,0x14(%ebp)
f0100e9d:	e9 37 02 00 00       	jmp    f01010d9 <vprintfmt+0x38c>
f0100ea2:	f7 d8                	neg    %eax
f0100ea4:	eb d2                	jmp    f0100e78 <vprintfmt+0x12b>
f0100ea6:	52                   	push   %edx
f0100ea7:	68 6a 1d 10 f0       	push   $0xf0101d6a
f0100eac:	53                   	push   %ebx
f0100ead:	56                   	push   %esi
f0100eae:	e8 7d fe ff ff       	call   f0100d30 <printfmt>
f0100eb3:	83 c4 10             	add    $0x10,%esp
f0100eb6:	89 7d 14             	mov    %edi,0x14(%ebp)
f0100eb9:	e9 1b 02 00 00       	jmp    f01010d9 <vprintfmt+0x38c>
f0100ebe:	8b 45 14             	mov    0x14(%ebp),%eax
f0100ec1:	83 c0 04             	add    $0x4,%eax
f0100ec4:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0100ec7:	8b 45 14             	mov    0x14(%ebp),%eax
f0100eca:	8b 00                	mov    (%eax),%eax
f0100ecc:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100ecf:	85 c0                	test   %eax,%eax
f0100ed1:	74 19                	je     f0100eec <vprintfmt+0x19f>
f0100ed3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0100ed7:	7e 06                	jle    f0100edf <vprintfmt+0x192>
f0100ed9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f0100edd:	75 16                	jne    f0100ef5 <vprintfmt+0x1a8>
f0100edf:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0100ee2:	89 c7                	mov    %eax,%edi
f0100ee4:	03 45 d4             	add    -0x2c(%ebp),%eax
f0100ee7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100eea:	eb 62                	jmp    f0100f4e <vprintfmt+0x201>
f0100eec:	c7 45 cc 63 1d 10 f0 	movl   $0xf0101d63,-0x34(%ebp)
f0100ef3:	eb de                	jmp    f0100ed3 <vprintfmt+0x186>
f0100ef5:	83 ec 08             	sub    $0x8,%esp
f0100ef8:	ff 75 d8             	push   -0x28(%ebp)
f0100efb:	ff 75 cc             	push   -0x34(%ebp)
f0100efe:	e8 b4 03 00 00       	call   f01012b7 <strnlen>
f0100f03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100f06:	29 c2                	sub    %eax,%edx
f0100f08:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0100f0b:	83 c4 10             	add    $0x10,%esp
f0100f0e:	89 d7                	mov    %edx,%edi
f0100f10:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0100f14:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100f17:	85 ff                	test   %edi,%edi
f0100f19:	7e 0f                	jle    f0100f2a <vprintfmt+0x1dd>
f0100f1b:	83 ec 08             	sub    $0x8,%esp
f0100f1e:	53                   	push   %ebx
f0100f1f:	ff 75 d4             	push   -0x2c(%ebp)
f0100f22:	ff d6                	call   *%esi
f0100f24:	4f                   	dec    %edi
f0100f25:	83 c4 10             	add    $0x10,%esp
f0100f28:	eb ed                	jmp    f0100f17 <vprintfmt+0x1ca>
f0100f2a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0100f2d:	89 d0                	mov    %edx,%eax
f0100f2f:	85 d2                	test   %edx,%edx
f0100f31:	78 0a                	js     f0100f3d <vprintfmt+0x1f0>
f0100f33:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0100f36:	29 c2                	sub    %eax,%edx
f0100f38:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0100f3b:	eb a2                	jmp    f0100edf <vprintfmt+0x192>
f0100f3d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f42:	eb ef                	jmp    f0100f33 <vprintfmt+0x1e6>
f0100f44:	83 ec 08             	sub    $0x8,%esp
f0100f47:	53                   	push   %ebx
f0100f48:	52                   	push   %edx
f0100f49:	ff d6                	call   *%esi
f0100f4b:	83 c4 10             	add    $0x10,%esp
f0100f4e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0100f51:	29 f9                	sub    %edi,%ecx
f0100f53:	47                   	inc    %edi
f0100f54:	8a 47 ff             	mov    -0x1(%edi),%al
f0100f57:	0f be d0             	movsbl %al,%edx
f0100f5a:	85 d2                	test   %edx,%edx
f0100f5c:	74 48                	je     f0100fa6 <vprintfmt+0x259>
f0100f5e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0100f62:	78 05                	js     f0100f69 <vprintfmt+0x21c>
f0100f64:	ff 4d d8             	decl   -0x28(%ebp)
f0100f67:	78 1e                	js     f0100f87 <vprintfmt+0x23a>
f0100f69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0100f6d:	74 d5                	je     f0100f44 <vprintfmt+0x1f7>
f0100f6f:	0f be c0             	movsbl %al,%eax
f0100f72:	83 e8 20             	sub    $0x20,%eax
f0100f75:	83 f8 5e             	cmp    $0x5e,%eax
f0100f78:	76 ca                	jbe    f0100f44 <vprintfmt+0x1f7>
f0100f7a:	83 ec 08             	sub    $0x8,%esp
f0100f7d:	53                   	push   %ebx
f0100f7e:	6a 3f                	push   $0x3f
f0100f80:	ff d6                	call   *%esi
f0100f82:	83 c4 10             	add    $0x10,%esp
f0100f85:	eb c7                	jmp    f0100f4e <vprintfmt+0x201>
f0100f87:	89 cf                	mov    %ecx,%edi
f0100f89:	eb 0c                	jmp    f0100f97 <vprintfmt+0x24a>
f0100f8b:	83 ec 08             	sub    $0x8,%esp
f0100f8e:	53                   	push   %ebx
f0100f8f:	6a 20                	push   $0x20
f0100f91:	ff d6                	call   *%esi
f0100f93:	4f                   	dec    %edi
f0100f94:	83 c4 10             	add    $0x10,%esp
f0100f97:	85 ff                	test   %edi,%edi
f0100f99:	7f f0                	jg     f0100f8b <vprintfmt+0x23e>
f0100f9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0100f9e:	89 45 14             	mov    %eax,0x14(%ebp)
f0100fa1:	e9 33 01 00 00       	jmp    f01010d9 <vprintfmt+0x38c>
f0100fa6:	89 cf                	mov    %ecx,%edi
f0100fa8:	eb ed                	jmp    f0100f97 <vprintfmt+0x24a>
f0100faa:	83 f9 01             	cmp    $0x1,%ecx
f0100fad:	7f 1b                	jg     f0100fca <vprintfmt+0x27d>
f0100faf:	85 c9                	test   %ecx,%ecx
f0100fb1:	74 42                	je     f0100ff5 <vprintfmt+0x2a8>
f0100fb3:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fb6:	8b 00                	mov    (%eax),%eax
f0100fb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100fbb:	99                   	cltd   
f0100fbc:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100fbf:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fc2:	8d 40 04             	lea    0x4(%eax),%eax
f0100fc5:	89 45 14             	mov    %eax,0x14(%ebp)
f0100fc8:	eb 17                	jmp    f0100fe1 <vprintfmt+0x294>
f0100fca:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fcd:	8b 50 04             	mov    0x4(%eax),%edx
f0100fd0:	8b 00                	mov    (%eax),%eax
f0100fd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100fd5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100fd8:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fdb:	8d 40 08             	lea    0x8(%eax),%eax
f0100fde:	89 45 14             	mov    %eax,0x14(%ebp)
f0100fe1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100fe4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100fe7:	85 c9                	test   %ecx,%ecx
f0100fe9:	78 21                	js     f010100c <vprintfmt+0x2bf>
f0100feb:	bf 0a 00 00 00       	mov    $0xa,%edi
f0100ff0:	e9 ca 00 00 00       	jmp    f01010bf <vprintfmt+0x372>
f0100ff5:	8b 45 14             	mov    0x14(%ebp),%eax
f0100ff8:	8b 00                	mov    (%eax),%eax
f0100ffa:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100ffd:	99                   	cltd   
f0100ffe:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101001:	8b 45 14             	mov    0x14(%ebp),%eax
f0101004:	8d 40 04             	lea    0x4(%eax),%eax
f0101007:	89 45 14             	mov    %eax,0x14(%ebp)
f010100a:	eb d5                	jmp    f0100fe1 <vprintfmt+0x294>
f010100c:	83 ec 08             	sub    $0x8,%esp
f010100f:	53                   	push   %ebx
f0101010:	6a 2d                	push   $0x2d
f0101012:	ff d6                	call   *%esi
f0101014:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101017:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010101a:	f7 da                	neg    %edx
f010101c:	83 d1 00             	adc    $0x0,%ecx
f010101f:	f7 d9                	neg    %ecx
f0101021:	83 c4 10             	add    $0x10,%esp
f0101024:	bf 0a 00 00 00       	mov    $0xa,%edi
f0101029:	e9 91 00 00 00       	jmp    f01010bf <vprintfmt+0x372>
f010102e:	83 f9 01             	cmp    $0x1,%ecx
f0101031:	7f 1b                	jg     f010104e <vprintfmt+0x301>
f0101033:	85 c9                	test   %ecx,%ecx
f0101035:	74 2c                	je     f0101063 <vprintfmt+0x316>
f0101037:	8b 45 14             	mov    0x14(%ebp),%eax
f010103a:	8b 10                	mov    (%eax),%edx
f010103c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101041:	8d 40 04             	lea    0x4(%eax),%eax
f0101044:	89 45 14             	mov    %eax,0x14(%ebp)
f0101047:	bf 0a 00 00 00       	mov    $0xa,%edi
f010104c:	eb 71                	jmp    f01010bf <vprintfmt+0x372>
f010104e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101051:	8b 10                	mov    (%eax),%edx
f0101053:	8b 48 04             	mov    0x4(%eax),%ecx
f0101056:	8d 40 08             	lea    0x8(%eax),%eax
f0101059:	89 45 14             	mov    %eax,0x14(%ebp)
f010105c:	bf 0a 00 00 00       	mov    $0xa,%edi
f0101061:	eb 5c                	jmp    f01010bf <vprintfmt+0x372>
f0101063:	8b 45 14             	mov    0x14(%ebp),%eax
f0101066:	8b 10                	mov    (%eax),%edx
f0101068:	b9 00 00 00 00       	mov    $0x0,%ecx
f010106d:	8d 40 04             	lea    0x4(%eax),%eax
f0101070:	89 45 14             	mov    %eax,0x14(%ebp)
f0101073:	bf 0a 00 00 00       	mov    $0xa,%edi
f0101078:	eb 45                	jmp    f01010bf <vprintfmt+0x372>
f010107a:	83 ec 08             	sub    $0x8,%esp
f010107d:	53                   	push   %ebx
f010107e:	6a 58                	push   $0x58
f0101080:	ff d6                	call   *%esi
f0101082:	83 c4 08             	add    $0x8,%esp
f0101085:	53                   	push   %ebx
f0101086:	6a 58                	push   $0x58
f0101088:	ff d6                	call   *%esi
f010108a:	83 c4 08             	add    $0x8,%esp
f010108d:	53                   	push   %ebx
f010108e:	6a 58                	push   $0x58
f0101090:	ff d6                	call   *%esi
f0101092:	83 c4 10             	add    $0x10,%esp
f0101095:	eb 42                	jmp    f01010d9 <vprintfmt+0x38c>
f0101097:	83 ec 08             	sub    $0x8,%esp
f010109a:	53                   	push   %ebx
f010109b:	6a 30                	push   $0x30
f010109d:	ff d6                	call   *%esi
f010109f:	83 c4 08             	add    $0x8,%esp
f01010a2:	53                   	push   %ebx
f01010a3:	6a 78                	push   $0x78
f01010a5:	ff d6                	call   *%esi
f01010a7:	8b 45 14             	mov    0x14(%ebp),%eax
f01010aa:	8b 10                	mov    (%eax),%edx
f01010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
f01010b1:	83 c4 10             	add    $0x10,%esp
f01010b4:	8d 40 04             	lea    0x4(%eax),%eax
f01010b7:	89 45 14             	mov    %eax,0x14(%ebp)
f01010ba:	bf 10 00 00 00       	mov    $0x10,%edi
f01010bf:	83 ec 0c             	sub    $0xc,%esp
f01010c2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f01010c6:	50                   	push   %eax
f01010c7:	ff 75 d4             	push   -0x2c(%ebp)
f01010ca:	57                   	push   %edi
f01010cb:	51                   	push   %ecx
f01010cc:	52                   	push   %edx
f01010cd:	89 da                	mov    %ebx,%edx
f01010cf:	89 f0                	mov    %esi,%eax
f01010d1:	e8 99 fb ff ff       	call   f0100c6f <printnum>
f01010d6:	83 c4 20             	add    $0x20,%esp
f01010d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01010dc:	e9 8a fc ff ff       	jmp    f0100d6b <vprintfmt+0x1e>
f01010e1:	83 f9 01             	cmp    $0x1,%ecx
f01010e4:	7f 1b                	jg     f0101101 <vprintfmt+0x3b4>
f01010e6:	85 c9                	test   %ecx,%ecx
f01010e8:	74 2c                	je     f0101116 <vprintfmt+0x3c9>
f01010ea:	8b 45 14             	mov    0x14(%ebp),%eax
f01010ed:	8b 10                	mov    (%eax),%edx
f01010ef:	b9 00 00 00 00       	mov    $0x0,%ecx
f01010f4:	8d 40 04             	lea    0x4(%eax),%eax
f01010f7:	89 45 14             	mov    %eax,0x14(%ebp)
f01010fa:	bf 10 00 00 00       	mov    $0x10,%edi
f01010ff:	eb be                	jmp    f01010bf <vprintfmt+0x372>
f0101101:	8b 45 14             	mov    0x14(%ebp),%eax
f0101104:	8b 10                	mov    (%eax),%edx
f0101106:	8b 48 04             	mov    0x4(%eax),%ecx
f0101109:	8d 40 08             	lea    0x8(%eax),%eax
f010110c:	89 45 14             	mov    %eax,0x14(%ebp)
f010110f:	bf 10 00 00 00       	mov    $0x10,%edi
f0101114:	eb a9                	jmp    f01010bf <vprintfmt+0x372>
f0101116:	8b 45 14             	mov    0x14(%ebp),%eax
f0101119:	8b 10                	mov    (%eax),%edx
f010111b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101120:	8d 40 04             	lea    0x4(%eax),%eax
f0101123:	89 45 14             	mov    %eax,0x14(%ebp)
f0101126:	bf 10 00 00 00       	mov    $0x10,%edi
f010112b:	eb 92                	jmp    f01010bf <vprintfmt+0x372>
f010112d:	83 ec 08             	sub    $0x8,%esp
f0101130:	53                   	push   %ebx
f0101131:	6a 25                	push   $0x25
f0101133:	ff d6                	call   *%esi
f0101135:	83 c4 10             	add    $0x10,%esp
f0101138:	eb 9f                	jmp    f01010d9 <vprintfmt+0x38c>
f010113a:	83 ec 08             	sub    $0x8,%esp
f010113d:	53                   	push   %ebx
f010113e:	6a 25                	push   $0x25
f0101140:	ff d6                	call   *%esi
f0101142:	83 c4 10             	add    $0x10,%esp
f0101145:	89 f8                	mov    %edi,%eax
f0101147:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010114b:	74 03                	je     f0101150 <vprintfmt+0x403>
f010114d:	48                   	dec    %eax
f010114e:	eb f7                	jmp    f0101147 <vprintfmt+0x3fa>
f0101150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101153:	eb 84                	jmp    f01010d9 <vprintfmt+0x38c>

f0101155 <vsnprintf>:
f0101155:	55                   	push   %ebp
f0101156:	89 e5                	mov    %esp,%ebp
f0101158:	83 ec 18             	sub    $0x18,%esp
f010115b:	8b 45 08             	mov    0x8(%ebp),%eax
f010115e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101161:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101164:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0101168:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0101172:	85 c0                	test   %eax,%eax
f0101174:	74 26                	je     f010119c <vsnprintf+0x47>
f0101176:	85 d2                	test   %edx,%edx
f0101178:	7e 29                	jle    f01011a3 <vsnprintf+0x4e>
f010117a:	ff 75 14             	push   0x14(%ebp)
f010117d:	ff 75 10             	push   0x10(%ebp)
f0101180:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0101183:	50                   	push   %eax
f0101184:	68 14 0d 10 f0       	push   $0xf0100d14
f0101189:	e8 bf fb ff ff       	call   f0100d4d <vprintfmt>
f010118e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101191:	c6 00 00             	movb   $0x0,(%eax)
f0101194:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101197:	83 c4 10             	add    $0x10,%esp
f010119a:	c9                   	leave  
f010119b:	c3                   	ret    
f010119c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01011a1:	eb f7                	jmp    f010119a <vsnprintf+0x45>
f01011a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01011a8:	eb f0                	jmp    f010119a <vsnprintf+0x45>

f01011aa <snprintf>:
f01011aa:	55                   	push   %ebp
f01011ab:	89 e5                	mov    %esp,%ebp
f01011ad:	83 ec 08             	sub    $0x8,%esp
f01011b0:	8d 45 14             	lea    0x14(%ebp),%eax
f01011b3:	50                   	push   %eax
f01011b4:	ff 75 10             	push   0x10(%ebp)
f01011b7:	ff 75 0c             	push   0xc(%ebp)
f01011ba:	ff 75 08             	push   0x8(%ebp)
f01011bd:	e8 93 ff ff ff       	call   f0101155 <vsnprintf>
f01011c2:	c9                   	leave  
f01011c3:	c3                   	ret    

f01011c4 <readline>:
f01011c4:	55                   	push   %ebp
f01011c5:	89 e5                	mov    %esp,%ebp
f01011c7:	57                   	push   %edi
f01011c8:	56                   	push   %esi
f01011c9:	53                   	push   %ebx
f01011ca:	83 ec 0c             	sub    $0xc,%esp
f01011cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01011d0:	85 c0                	test   %eax,%eax
f01011d2:	74 11                	je     f01011e5 <readline+0x21>
f01011d4:	83 ec 08             	sub    $0x8,%esp
f01011d7:	50                   	push   %eax
f01011d8:	68 73 1d 10 f0       	push   $0xf0101d73
f01011dd:	e8 9f f7 ff ff       	call   f0100981 <cprintf>
f01011e2:	83 c4 10             	add    $0x10,%esp
f01011e5:	83 ec 0c             	sub    $0xc,%esp
f01011e8:	6a 00                	push   $0x0
f01011ea:	e8 f1 f3 ff ff       	call   f01005e0 <iscons>
f01011ef:	89 c7                	mov    %eax,%edi
f01011f1:	83 c4 10             	add    $0x10,%esp
f01011f4:	be 00 00 00 00       	mov    $0x0,%esi
f01011f9:	eb 75                	jmp    f0101270 <readline+0xac>
f01011fb:	83 ec 08             	sub    $0x8,%esp
f01011fe:	50                   	push   %eax
f01011ff:	68 54 1f 10 f0       	push   $0xf0101f54
f0101204:	e8 78 f7 ff ff       	call   f0100981 <cprintf>
f0101209:	83 c4 10             	add    $0x10,%esp
f010120c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101211:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101214:	5b                   	pop    %ebx
f0101215:	5e                   	pop    %esi
f0101216:	5f                   	pop    %edi
f0101217:	5d                   	pop    %ebp
f0101218:	c3                   	ret    
f0101219:	83 ec 0c             	sub    $0xc,%esp
f010121c:	6a 08                	push   $0x8
f010121e:	e8 9c f3 ff ff       	call   f01005bf <cputchar>
f0101223:	83 c4 10             	add    $0x10,%esp
f0101226:	eb 47                	jmp    f010126f <readline+0xab>
f0101228:	83 ec 0c             	sub    $0xc,%esp
f010122b:	53                   	push   %ebx
f010122c:	e8 8e f3 ff ff       	call   f01005bf <cputchar>
f0101231:	83 c4 10             	add    $0x10,%esp
f0101234:	eb 60                	jmp    f0101296 <readline+0xd2>
f0101236:	83 f8 0a             	cmp    $0xa,%eax
f0101239:	74 05                	je     f0101240 <readline+0x7c>
f010123b:	83 f8 0d             	cmp    $0xd,%eax
f010123e:	75 30                	jne    f0101270 <readline+0xac>
f0101240:	85 ff                	test   %edi,%edi
f0101242:	75 0e                	jne    f0101252 <readline+0x8e>
f0101244:	c6 86 80 25 11 f0 00 	movb   $0x0,-0xfeeda80(%esi)
f010124b:	b8 80 25 11 f0       	mov    $0xf0112580,%eax
f0101250:	eb bf                	jmp    f0101211 <readline+0x4d>
f0101252:	83 ec 0c             	sub    $0xc,%esp
f0101255:	6a 0a                	push   $0xa
f0101257:	e8 63 f3 ff ff       	call   f01005bf <cputchar>
f010125c:	83 c4 10             	add    $0x10,%esp
f010125f:	eb e3                	jmp    f0101244 <readline+0x80>
f0101261:	85 f6                	test   %esi,%esi
f0101263:	7f 06                	jg     f010126b <readline+0xa7>
f0101265:	eb 23                	jmp    f010128a <readline+0xc6>
f0101267:	85 f6                	test   %esi,%esi
f0101269:	7e 05                	jle    f0101270 <readline+0xac>
f010126b:	85 ff                	test   %edi,%edi
f010126d:	75 aa                	jne    f0101219 <readline+0x55>
f010126f:	4e                   	dec    %esi
f0101270:	e8 5a f3 ff ff       	call   f01005cf <getchar>
f0101275:	89 c3                	mov    %eax,%ebx
f0101277:	85 c0                	test   %eax,%eax
f0101279:	78 80                	js     f01011fb <readline+0x37>
f010127b:	83 f8 08             	cmp    $0x8,%eax
f010127e:	74 e7                	je     f0101267 <readline+0xa3>
f0101280:	83 f8 7f             	cmp    $0x7f,%eax
f0101283:	74 dc                	je     f0101261 <readline+0x9d>
f0101285:	83 f8 1f             	cmp    $0x1f,%eax
f0101288:	7e ac                	jle    f0101236 <readline+0x72>
f010128a:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101290:	7f de                	jg     f0101270 <readline+0xac>
f0101292:	85 ff                	test   %edi,%edi
f0101294:	75 92                	jne    f0101228 <readline+0x64>
f0101296:	88 9e 80 25 11 f0    	mov    %bl,-0xfeeda80(%esi)
f010129c:	8d 76 01             	lea    0x1(%esi),%esi
f010129f:	eb cf                	jmp    f0101270 <readline+0xac>

f01012a1 <strlen>:
f01012a1:	55                   	push   %ebp
f01012a2:	89 e5                	mov    %esp,%ebp
f01012a4:	8b 55 08             	mov    0x8(%ebp),%edx
f01012a7:	b8 00 00 00 00       	mov    $0x0,%eax
f01012ac:	eb 01                	jmp    f01012af <strlen+0xe>
f01012ae:	40                   	inc    %eax
f01012af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01012b3:	75 f9                	jne    f01012ae <strlen+0xd>
f01012b5:	5d                   	pop    %ebp
f01012b6:	c3                   	ret    

f01012b7 <strnlen>:
f01012b7:	55                   	push   %ebp
f01012b8:	89 e5                	mov    %esp,%ebp
f01012ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01012bd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01012c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01012c5:	eb 01                	jmp    f01012c8 <strnlen+0x11>
f01012c7:	40                   	inc    %eax
f01012c8:	39 d0                	cmp    %edx,%eax
f01012ca:	74 08                	je     f01012d4 <strnlen+0x1d>
f01012cc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f01012d0:	75 f5                	jne    f01012c7 <strnlen+0x10>
f01012d2:	89 c2                	mov    %eax,%edx
f01012d4:	89 d0                	mov    %edx,%eax
f01012d6:	5d                   	pop    %ebp
f01012d7:	c3                   	ret    

f01012d8 <strcpy>:
f01012d8:	55                   	push   %ebp
f01012d9:	89 e5                	mov    %esp,%ebp
f01012db:	53                   	push   %ebx
f01012dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01012df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01012e2:	b8 00 00 00 00       	mov    $0x0,%eax
f01012e7:	8a 14 03             	mov    (%ebx,%eax,1),%dl
f01012ea:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f01012ed:	40                   	inc    %eax
f01012ee:	84 d2                	test   %dl,%dl
f01012f0:	75 f5                	jne    f01012e7 <strcpy+0xf>
f01012f2:	89 c8                	mov    %ecx,%eax
f01012f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012f7:	c9                   	leave  
f01012f8:	c3                   	ret    

f01012f9 <strcat>:
f01012f9:	55                   	push   %ebp
f01012fa:	89 e5                	mov    %esp,%ebp
f01012fc:	53                   	push   %ebx
f01012fd:	83 ec 10             	sub    $0x10,%esp
f0101300:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101303:	53                   	push   %ebx
f0101304:	e8 98 ff ff ff       	call   f01012a1 <strlen>
f0101309:	83 c4 08             	add    $0x8,%esp
f010130c:	ff 75 0c             	push   0xc(%ebp)
f010130f:	01 d8                	add    %ebx,%eax
f0101311:	50                   	push   %eax
f0101312:	e8 c1 ff ff ff       	call   f01012d8 <strcpy>
f0101317:	89 d8                	mov    %ebx,%eax
f0101319:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010131c:	c9                   	leave  
f010131d:	c3                   	ret    

f010131e <strncpy>:
f010131e:	55                   	push   %ebp
f010131f:	89 e5                	mov    %esp,%ebp
f0101321:	53                   	push   %ebx
f0101322:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101325:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101328:	03 5d 10             	add    0x10(%ebp),%ebx
f010132b:	8b 45 08             	mov    0x8(%ebp),%eax
f010132e:	eb 0c                	jmp    f010133c <strncpy+0x1e>
f0101330:	40                   	inc    %eax
f0101331:	8a 0a                	mov    (%edx),%cl
f0101333:	88 48 ff             	mov    %cl,-0x1(%eax)
f0101336:	80 f9 01             	cmp    $0x1,%cl
f0101339:	83 da ff             	sbb    $0xffffffff,%edx
f010133c:	39 d8                	cmp    %ebx,%eax
f010133e:	75 f0                	jne    f0101330 <strncpy+0x12>
f0101340:	8b 45 08             	mov    0x8(%ebp),%eax
f0101343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101346:	c9                   	leave  
f0101347:	c3                   	ret    

f0101348 <strlcpy>:
f0101348:	55                   	push   %ebp
f0101349:	89 e5                	mov    %esp,%ebp
f010134b:	56                   	push   %esi
f010134c:	53                   	push   %ebx
f010134d:	8b 75 08             	mov    0x8(%ebp),%esi
f0101350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101353:	8b 45 10             	mov    0x10(%ebp),%eax
f0101356:	85 c0                	test   %eax,%eax
f0101358:	74 22                	je     f010137c <strlcpy+0x34>
f010135a:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
f010135e:	89 f2                	mov    %esi,%edx
f0101360:	eb 05                	jmp    f0101367 <strlcpy+0x1f>
f0101362:	41                   	inc    %ecx
f0101363:	42                   	inc    %edx
f0101364:	88 5a ff             	mov    %bl,-0x1(%edx)
f0101367:	39 c2                	cmp    %eax,%edx
f0101369:	74 08                	je     f0101373 <strlcpy+0x2b>
f010136b:	8a 19                	mov    (%ecx),%bl
f010136d:	84 db                	test   %bl,%bl
f010136f:	75 f1                	jne    f0101362 <strlcpy+0x1a>
f0101371:	89 d0                	mov    %edx,%eax
f0101373:	c6 00 00             	movb   $0x0,(%eax)
f0101376:	29 f0                	sub    %esi,%eax
f0101378:	5b                   	pop    %ebx
f0101379:	5e                   	pop    %esi
f010137a:	5d                   	pop    %ebp
f010137b:	c3                   	ret    
f010137c:	89 f0                	mov    %esi,%eax
f010137e:	eb f6                	jmp    f0101376 <strlcpy+0x2e>

f0101380 <strcmp>:
f0101380:	55                   	push   %ebp
f0101381:	89 e5                	mov    %esp,%ebp
f0101383:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101386:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101389:	eb 02                	jmp    f010138d <strcmp+0xd>
f010138b:	41                   	inc    %ecx
f010138c:	42                   	inc    %edx
f010138d:	8a 01                	mov    (%ecx),%al
f010138f:	84 c0                	test   %al,%al
f0101391:	74 04                	je     f0101397 <strcmp+0x17>
f0101393:	3a 02                	cmp    (%edx),%al
f0101395:	74 f4                	je     f010138b <strcmp+0xb>
f0101397:	0f b6 c0             	movzbl %al,%eax
f010139a:	0f b6 12             	movzbl (%edx),%edx
f010139d:	29 d0                	sub    %edx,%eax
f010139f:	5d                   	pop    %ebp
f01013a0:	c3                   	ret    

f01013a1 <strncmp>:
f01013a1:	55                   	push   %ebp
f01013a2:	89 e5                	mov    %esp,%ebp
f01013a4:	53                   	push   %ebx
f01013a5:	8b 45 08             	mov    0x8(%ebp),%eax
f01013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01013ab:	89 c3                	mov    %eax,%ebx
f01013ad:	03 5d 10             	add    0x10(%ebp),%ebx
f01013b0:	eb 02                	jmp    f01013b4 <strncmp+0x13>
f01013b2:	40                   	inc    %eax
f01013b3:	42                   	inc    %edx
f01013b4:	39 d8                	cmp    %ebx,%eax
f01013b6:	74 17                	je     f01013cf <strncmp+0x2e>
f01013b8:	8a 08                	mov    (%eax),%cl
f01013ba:	84 c9                	test   %cl,%cl
f01013bc:	74 04                	je     f01013c2 <strncmp+0x21>
f01013be:	3a 0a                	cmp    (%edx),%cl
f01013c0:	74 f0                	je     f01013b2 <strncmp+0x11>
f01013c2:	0f b6 00             	movzbl (%eax),%eax
f01013c5:	0f b6 12             	movzbl (%edx),%edx
f01013c8:	29 d0                	sub    %edx,%eax
f01013ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01013cd:	c9                   	leave  
f01013ce:	c3                   	ret    
f01013cf:	b8 00 00 00 00       	mov    $0x0,%eax
f01013d4:	eb f4                	jmp    f01013ca <strncmp+0x29>

f01013d6 <strchr>:
f01013d6:	55                   	push   %ebp
f01013d7:	89 e5                	mov    %esp,%ebp
f01013d9:	8b 45 08             	mov    0x8(%ebp),%eax
f01013dc:	8a 4d 0c             	mov    0xc(%ebp),%cl
f01013df:	eb 01                	jmp    f01013e2 <strchr+0xc>
f01013e1:	40                   	inc    %eax
f01013e2:	8a 10                	mov    (%eax),%dl
f01013e4:	84 d2                	test   %dl,%dl
f01013e6:	74 06                	je     f01013ee <strchr+0x18>
f01013e8:	38 ca                	cmp    %cl,%dl
f01013ea:	75 f5                	jne    f01013e1 <strchr+0xb>
f01013ec:	eb 05                	jmp    f01013f3 <strchr+0x1d>
f01013ee:	b8 00 00 00 00       	mov    $0x0,%eax
f01013f3:	5d                   	pop    %ebp
f01013f4:	c3                   	ret    

f01013f5 <strfind>:
f01013f5:	55                   	push   %ebp
f01013f6:	89 e5                	mov    %esp,%ebp
f01013f8:	8b 45 08             	mov    0x8(%ebp),%eax
f01013fb:	8a 4d 0c             	mov    0xc(%ebp),%cl
f01013fe:	eb 01                	jmp    f0101401 <strfind+0xc>
f0101400:	40                   	inc    %eax
f0101401:	8a 10                	mov    (%eax),%dl
f0101403:	84 d2                	test   %dl,%dl
f0101405:	74 04                	je     f010140b <strfind+0x16>
f0101407:	38 ca                	cmp    %cl,%dl
f0101409:	75 f5                	jne    f0101400 <strfind+0xb>
f010140b:	5d                   	pop    %ebp
f010140c:	c3                   	ret    

f010140d <memset>:
f010140d:	55                   	push   %ebp
f010140e:	89 e5                	mov    %esp,%ebp
f0101410:	57                   	push   %edi
f0101411:	56                   	push   %esi
f0101412:	53                   	push   %ebx
f0101413:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101416:	85 c9                	test   %ecx,%ecx
f0101418:	74 36                	je     f0101450 <memset+0x43>
f010141a:	89 c8                	mov    %ecx,%eax
f010141c:	0b 45 08             	or     0x8(%ebp),%eax
f010141f:	a8 03                	test   $0x3,%al
f0101421:	75 24                	jne    f0101447 <memset+0x3a>
f0101423:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
f0101427:	89 d8                	mov    %ebx,%eax
f0101429:	c1 e0 08             	shl    $0x8,%eax
f010142c:	89 da                	mov    %ebx,%edx
f010142e:	c1 e2 18             	shl    $0x18,%edx
f0101431:	89 de                	mov    %ebx,%esi
f0101433:	c1 e6 10             	shl    $0x10,%esi
f0101436:	09 f2                	or     %esi,%edx
f0101438:	09 da                	or     %ebx,%edx
f010143a:	09 d0                	or     %edx,%eax
f010143c:	c1 e9 02             	shr    $0x2,%ecx
f010143f:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101442:	fc                   	cld    
f0101443:	f3 ab                	rep stos %eax,%es:(%edi)
f0101445:	eb 09                	jmp    f0101450 <memset+0x43>
f0101447:	8b 7d 08             	mov    0x8(%ebp),%edi
f010144a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010144d:	fc                   	cld    
f010144e:	f3 aa                	rep stos %al,%es:(%edi)
f0101450:	8b 45 08             	mov    0x8(%ebp),%eax
f0101453:	5b                   	pop    %ebx
f0101454:	5e                   	pop    %esi
f0101455:	5f                   	pop    %edi
f0101456:	5d                   	pop    %ebp
f0101457:	c3                   	ret    

f0101458 <memmove>:
f0101458:	55                   	push   %ebp
f0101459:	89 e5                	mov    %esp,%ebp
f010145b:	57                   	push   %edi
f010145c:	56                   	push   %esi
f010145d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101460:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101463:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101466:	39 c6                	cmp    %eax,%esi
f0101468:	73 30                	jae    f010149a <memmove+0x42>
f010146a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010146d:	39 c2                	cmp    %eax,%edx
f010146f:	76 29                	jbe    f010149a <memmove+0x42>
f0101471:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0101474:	89 d6                	mov    %edx,%esi
f0101476:	09 fe                	or     %edi,%esi
f0101478:	09 ce                	or     %ecx,%esi
f010147a:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101480:	75 0e                	jne    f0101490 <memmove+0x38>
f0101482:	83 ef 04             	sub    $0x4,%edi
f0101485:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101488:	c1 e9 02             	shr    $0x2,%ecx
f010148b:	fd                   	std    
f010148c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010148e:	eb 07                	jmp    f0101497 <memmove+0x3f>
f0101490:	4f                   	dec    %edi
f0101491:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101494:	fd                   	std    
f0101495:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0101497:	fc                   	cld    
f0101498:	eb 1a                	jmp    f01014b4 <memmove+0x5c>
f010149a:	89 f2                	mov    %esi,%edx
f010149c:	09 c2                	or     %eax,%edx
f010149e:	09 ca                	or     %ecx,%edx
f01014a0:	f6 c2 03             	test   $0x3,%dl
f01014a3:	75 0a                	jne    f01014af <memmove+0x57>
f01014a5:	c1 e9 02             	shr    $0x2,%ecx
f01014a8:	89 c7                	mov    %eax,%edi
f01014aa:	fc                   	cld    
f01014ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01014ad:	eb 05                	jmp    f01014b4 <memmove+0x5c>
f01014af:	89 c7                	mov    %eax,%edi
f01014b1:	fc                   	cld    
f01014b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f01014b4:	5e                   	pop    %esi
f01014b5:	5f                   	pop    %edi
f01014b6:	5d                   	pop    %ebp
f01014b7:	c3                   	ret    

f01014b8 <memcpy>:
f01014b8:	55                   	push   %ebp
f01014b9:	89 e5                	mov    %esp,%ebp
f01014bb:	83 ec 0c             	sub    $0xc,%esp
f01014be:	ff 75 10             	push   0x10(%ebp)
f01014c1:	ff 75 0c             	push   0xc(%ebp)
f01014c4:	ff 75 08             	push   0x8(%ebp)
f01014c7:	e8 8c ff ff ff       	call   f0101458 <memmove>
f01014cc:	c9                   	leave  
f01014cd:	c3                   	ret    

f01014ce <memcmp>:
f01014ce:	55                   	push   %ebp
f01014cf:	89 e5                	mov    %esp,%ebp
f01014d1:	56                   	push   %esi
f01014d2:	53                   	push   %ebx
f01014d3:	8b 45 08             	mov    0x8(%ebp),%eax
f01014d6:	8b 55 0c             	mov    0xc(%ebp),%edx
f01014d9:	89 c6                	mov    %eax,%esi
f01014db:	03 75 10             	add    0x10(%ebp),%esi
f01014de:	eb 02                	jmp    f01014e2 <memcmp+0x14>
f01014e0:	40                   	inc    %eax
f01014e1:	42                   	inc    %edx
f01014e2:	39 f0                	cmp    %esi,%eax
f01014e4:	74 12                	je     f01014f8 <memcmp+0x2a>
f01014e6:	8a 08                	mov    (%eax),%cl
f01014e8:	8a 1a                	mov    (%edx),%bl
f01014ea:	38 d9                	cmp    %bl,%cl
f01014ec:	74 f2                	je     f01014e0 <memcmp+0x12>
f01014ee:	0f b6 c1             	movzbl %cl,%eax
f01014f1:	0f b6 db             	movzbl %bl,%ebx
f01014f4:	29 d8                	sub    %ebx,%eax
f01014f6:	eb 05                	jmp    f01014fd <memcmp+0x2f>
f01014f8:	b8 00 00 00 00       	mov    $0x0,%eax
f01014fd:	5b                   	pop    %ebx
f01014fe:	5e                   	pop    %esi
f01014ff:	5d                   	pop    %ebp
f0101500:	c3                   	ret    

f0101501 <memfind>:
f0101501:	55                   	push   %ebp
f0101502:	89 e5                	mov    %esp,%ebp
f0101504:	8b 45 08             	mov    0x8(%ebp),%eax
f0101507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010150a:	89 c2                	mov    %eax,%edx
f010150c:	03 55 10             	add    0x10(%ebp),%edx
f010150f:	eb 01                	jmp    f0101512 <memfind+0x11>
f0101511:	40                   	inc    %eax
f0101512:	39 d0                	cmp    %edx,%eax
f0101514:	73 04                	jae    f010151a <memfind+0x19>
f0101516:	38 08                	cmp    %cl,(%eax)
f0101518:	75 f7                	jne    f0101511 <memfind+0x10>
f010151a:	5d                   	pop    %ebp
f010151b:	c3                   	ret    

f010151c <strtol>:
f010151c:	55                   	push   %ebp
f010151d:	89 e5                	mov    %esp,%ebp
f010151f:	57                   	push   %edi
f0101520:	56                   	push   %esi
f0101521:	53                   	push   %ebx
f0101522:	8b 55 08             	mov    0x8(%ebp),%edx
f0101525:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101528:	eb 01                	jmp    f010152b <strtol+0xf>
f010152a:	42                   	inc    %edx
f010152b:	8a 02                	mov    (%edx),%al
f010152d:	3c 20                	cmp    $0x20,%al
f010152f:	74 f9                	je     f010152a <strtol+0xe>
f0101531:	3c 09                	cmp    $0x9,%al
f0101533:	74 f5                	je     f010152a <strtol+0xe>
f0101535:	3c 2b                	cmp    $0x2b,%al
f0101537:	74 24                	je     f010155d <strtol+0x41>
f0101539:	3c 2d                	cmp    $0x2d,%al
f010153b:	74 28                	je     f0101565 <strtol+0x49>
f010153d:	bf 00 00 00 00       	mov    $0x0,%edi
f0101542:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0101548:	75 09                	jne    f0101553 <strtol+0x37>
f010154a:	80 3a 30             	cmpb   $0x30,(%edx)
f010154d:	74 1e                	je     f010156d <strtol+0x51>
f010154f:	85 db                	test   %ebx,%ebx
f0101551:	74 36                	je     f0101589 <strtol+0x6d>
f0101553:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101558:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010155b:	eb 45                	jmp    f01015a2 <strtol+0x86>
f010155d:	42                   	inc    %edx
f010155e:	bf 00 00 00 00       	mov    $0x0,%edi
f0101563:	eb dd                	jmp    f0101542 <strtol+0x26>
f0101565:	42                   	inc    %edx
f0101566:	bf 01 00 00 00       	mov    $0x1,%edi
f010156b:	eb d5                	jmp    f0101542 <strtol+0x26>
f010156d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101571:	74 0c                	je     f010157f <strtol+0x63>
f0101573:	85 db                	test   %ebx,%ebx
f0101575:	75 dc                	jne    f0101553 <strtol+0x37>
f0101577:	42                   	inc    %edx
f0101578:	bb 08 00 00 00       	mov    $0x8,%ebx
f010157d:	eb d4                	jmp    f0101553 <strtol+0x37>
f010157f:	83 c2 02             	add    $0x2,%edx
f0101582:	bb 10 00 00 00       	mov    $0x10,%ebx
f0101587:	eb ca                	jmp    f0101553 <strtol+0x37>
f0101589:	bb 0a 00 00 00       	mov    $0xa,%ebx
f010158e:	eb c3                	jmp    f0101553 <strtol+0x37>
f0101590:	0f be c0             	movsbl %al,%eax
f0101593:	83 e8 30             	sub    $0x30,%eax
f0101596:	3b 45 10             	cmp    0x10(%ebp),%eax
f0101599:	7d 37                	jge    f01015d2 <strtol+0xb6>
f010159b:	42                   	inc    %edx
f010159c:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f01015a0:	01 c1                	add    %eax,%ecx
f01015a2:	8a 02                	mov    (%edx),%al
f01015a4:	8d 70 d0             	lea    -0x30(%eax),%esi
f01015a7:	89 f3                	mov    %esi,%ebx
f01015a9:	80 fb 09             	cmp    $0x9,%bl
f01015ac:	76 e2                	jbe    f0101590 <strtol+0x74>
f01015ae:	8d 70 9f             	lea    -0x61(%eax),%esi
f01015b1:	89 f3                	mov    %esi,%ebx
f01015b3:	80 fb 19             	cmp    $0x19,%bl
f01015b6:	77 08                	ja     f01015c0 <strtol+0xa4>
f01015b8:	0f be c0             	movsbl %al,%eax
f01015bb:	83 e8 57             	sub    $0x57,%eax
f01015be:	eb d6                	jmp    f0101596 <strtol+0x7a>
f01015c0:	8d 70 bf             	lea    -0x41(%eax),%esi
f01015c3:	89 f3                	mov    %esi,%ebx
f01015c5:	80 fb 19             	cmp    $0x19,%bl
f01015c8:	77 08                	ja     f01015d2 <strtol+0xb6>
f01015ca:	0f be c0             	movsbl %al,%eax
f01015cd:	83 e8 37             	sub    $0x37,%eax
f01015d0:	eb c4                	jmp    f0101596 <strtol+0x7a>
f01015d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01015d6:	74 05                	je     f01015dd <strtol+0xc1>
f01015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015db:	89 10                	mov    %edx,(%eax)
f01015dd:	85 ff                	test   %edi,%edi
f01015df:	74 02                	je     f01015e3 <strtol+0xc7>
f01015e1:	f7 d9                	neg    %ecx
f01015e3:	89 c8                	mov    %ecx,%eax
f01015e5:	5b                   	pop    %ebx
f01015e6:	5e                   	pop    %esi
f01015e7:	5f                   	pop    %edi
f01015e8:	5d                   	pop    %ebp
f01015e9:	c3                   	ret    
f01015ea:	66 90                	xchg   %ax,%ax

f01015ec <__udivdi3>:
f01015ec:	55                   	push   %ebp
f01015ed:	89 e5                	mov    %esp,%ebp
f01015ef:	57                   	push   %edi
f01015f0:	56                   	push   %esi
f01015f1:	53                   	push   %ebx
f01015f2:	83 ec 1c             	sub    $0x1c,%esp
f01015f5:	8b 7d 08             	mov    0x8(%ebp),%edi
f01015f8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f01015fb:	8b 75 0c             	mov    0xc(%ebp),%esi
f01015fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101601:	8b 45 14             	mov    0x14(%ebp),%eax
f0101604:	85 c0                	test   %eax,%eax
f0101606:	75 18                	jne    f0101620 <__udivdi3+0x34>
f0101608:	39 f3                	cmp    %esi,%ebx
f010160a:	76 44                	jbe    f0101650 <__udivdi3+0x64>
f010160c:	89 f8                	mov    %edi,%eax
f010160e:	89 f2                	mov    %esi,%edx
f0101610:	f7 f3                	div    %ebx
f0101612:	31 ff                	xor    %edi,%edi
f0101614:	89 fa                	mov    %edi,%edx
f0101616:	83 c4 1c             	add    $0x1c,%esp
f0101619:	5b                   	pop    %ebx
f010161a:	5e                   	pop    %esi
f010161b:	5f                   	pop    %edi
f010161c:	5d                   	pop    %ebp
f010161d:	c3                   	ret    
f010161e:	66 90                	xchg   %ax,%ax
f0101620:	39 f0                	cmp    %esi,%eax
f0101622:	76 10                	jbe    f0101634 <__udivdi3+0x48>
f0101624:	31 ff                	xor    %edi,%edi
f0101626:	31 c0                	xor    %eax,%eax
f0101628:	89 fa                	mov    %edi,%edx
f010162a:	83 c4 1c             	add    $0x1c,%esp
f010162d:	5b                   	pop    %ebx
f010162e:	5e                   	pop    %esi
f010162f:	5f                   	pop    %edi
f0101630:	5d                   	pop    %ebp
f0101631:	c3                   	ret    
f0101632:	66 90                	xchg   %ax,%ax
f0101634:	0f bd f8             	bsr    %eax,%edi
f0101637:	83 f7 1f             	xor    $0x1f,%edi
f010163a:	75 40                	jne    f010167c <__udivdi3+0x90>
f010163c:	39 f0                	cmp    %esi,%eax
f010163e:	72 09                	jb     f0101649 <__udivdi3+0x5d>
f0101640:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101643:	0f 87 a3 00 00 00    	ja     f01016ec <__udivdi3+0x100>
f0101649:	b8 01 00 00 00       	mov    $0x1,%eax
f010164e:	eb d8                	jmp    f0101628 <__udivdi3+0x3c>
f0101650:	89 d9                	mov    %ebx,%ecx
f0101652:	85 db                	test   %ebx,%ebx
f0101654:	75 0b                	jne    f0101661 <__udivdi3+0x75>
f0101656:	b8 01 00 00 00       	mov    $0x1,%eax
f010165b:	31 d2                	xor    %edx,%edx
f010165d:	f7 f3                	div    %ebx
f010165f:	89 c1                	mov    %eax,%ecx
f0101661:	31 d2                	xor    %edx,%edx
f0101663:	89 f0                	mov    %esi,%eax
f0101665:	f7 f1                	div    %ecx
f0101667:	89 c6                	mov    %eax,%esi
f0101669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010166c:	f7 f1                	div    %ecx
f010166e:	89 f7                	mov    %esi,%edi
f0101670:	89 fa                	mov    %edi,%edx
f0101672:	83 c4 1c             	add    $0x1c,%esp
f0101675:	5b                   	pop    %ebx
f0101676:	5e                   	pop    %esi
f0101677:	5f                   	pop    %edi
f0101678:	5d                   	pop    %ebp
f0101679:	c3                   	ret    
f010167a:	66 90                	xchg   %ax,%ax
f010167c:	ba 20 00 00 00       	mov    $0x20,%edx
f0101681:	29 fa                	sub    %edi,%edx
f0101683:	89 f9                	mov    %edi,%ecx
f0101685:	d3 e0                	shl    %cl,%eax
f0101687:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010168a:	89 d8                	mov    %ebx,%eax
f010168c:	88 d1                	mov    %dl,%cl
f010168e:	d3 e8                	shr    %cl,%eax
f0101690:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0101693:	09 c1                	or     %eax,%ecx
f0101695:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101698:	89 f9                	mov    %edi,%ecx
f010169a:	d3 e3                	shl    %cl,%ebx
f010169c:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f010169f:	89 f0                	mov    %esi,%eax
f01016a1:	88 d1                	mov    %dl,%cl
f01016a3:	d3 e8                	shr    %cl,%eax
f01016a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01016a8:	89 f9                	mov    %edi,%ecx
f01016aa:	d3 e6                	shl    %cl,%esi
f01016ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01016af:	88 d1                	mov    %dl,%cl
f01016b1:	d3 eb                	shr    %cl,%ebx
f01016b3:	89 d8                	mov    %ebx,%eax
f01016b5:	09 f0                	or     %esi,%eax
f01016b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01016ba:	f7 75 e0             	divl   -0x20(%ebp)
f01016bd:	89 d1                	mov    %edx,%ecx
f01016bf:	89 c3                	mov    %eax,%ebx
f01016c1:	f7 65 dc             	mull   -0x24(%ebp)
f01016c4:	39 d1                	cmp    %edx,%ecx
f01016c6:	72 18                	jb     f01016e0 <__udivdi3+0xf4>
f01016c8:	74 0a                	je     f01016d4 <__udivdi3+0xe8>
f01016ca:	89 d8                	mov    %ebx,%eax
f01016cc:	31 ff                	xor    %edi,%edi
f01016ce:	e9 55 ff ff ff       	jmp    f0101628 <__udivdi3+0x3c>
f01016d3:	90                   	nop
f01016d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01016d7:	89 f9                	mov    %edi,%ecx
f01016d9:	d3 e2                	shl    %cl,%edx
f01016db:	39 c2                	cmp    %eax,%edx
f01016dd:	73 eb                	jae    f01016ca <__udivdi3+0xde>
f01016df:	90                   	nop
f01016e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01016e3:	31 ff                	xor    %edi,%edi
f01016e5:	e9 3e ff ff ff       	jmp    f0101628 <__udivdi3+0x3c>
f01016ea:	66 90                	xchg   %ax,%ax
f01016ec:	31 c0                	xor    %eax,%eax
f01016ee:	e9 35 ff ff ff       	jmp    f0101628 <__udivdi3+0x3c>
f01016f3:	90                   	nop

f01016f4 <__umoddi3>:
f01016f4:	55                   	push   %ebp
f01016f5:	89 e5                	mov    %esp,%ebp
f01016f7:	57                   	push   %edi
f01016f8:	56                   	push   %esi
f01016f9:	53                   	push   %ebx
f01016fa:	83 ec 1c             	sub    $0x1c,%esp
f01016fd:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101700:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101703:	8b 75 10             	mov    0x10(%ebp),%esi
f0101706:	8b 45 14             	mov    0x14(%ebp),%eax
f0101709:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f010170c:	89 da                	mov    %ebx,%edx
f010170e:	85 c0                	test   %eax,%eax
f0101710:	75 16                	jne    f0101728 <__umoddi3+0x34>
f0101712:	39 de                	cmp    %ebx,%esi
f0101714:	76 4e                	jbe    f0101764 <__umoddi3+0x70>
f0101716:	89 f8                	mov    %edi,%eax
f0101718:	f7 f6                	div    %esi
f010171a:	89 d0                	mov    %edx,%eax
f010171c:	31 d2                	xor    %edx,%edx
f010171e:	83 c4 1c             	add    $0x1c,%esp
f0101721:	5b                   	pop    %ebx
f0101722:	5e                   	pop    %esi
f0101723:	5f                   	pop    %edi
f0101724:	5d                   	pop    %ebp
f0101725:	c3                   	ret    
f0101726:	66 90                	xchg   %ax,%ax
f0101728:	39 d8                	cmp    %ebx,%eax
f010172a:	76 0c                	jbe    f0101738 <__umoddi3+0x44>
f010172c:	89 f8                	mov    %edi,%eax
f010172e:	83 c4 1c             	add    $0x1c,%esp
f0101731:	5b                   	pop    %ebx
f0101732:	5e                   	pop    %esi
f0101733:	5f                   	pop    %edi
f0101734:	5d                   	pop    %ebp
f0101735:	c3                   	ret    
f0101736:	66 90                	xchg   %ax,%ax
f0101738:	0f bd c8             	bsr    %eax,%ecx
f010173b:	83 f1 1f             	xor    $0x1f,%ecx
f010173e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101741:	75 41                	jne    f0101784 <__umoddi3+0x90>
f0101743:	39 d8                	cmp    %ebx,%eax
f0101745:	72 04                	jb     f010174b <__umoddi3+0x57>
f0101747:	39 fe                	cmp    %edi,%esi
f0101749:	77 0d                	ja     f0101758 <__umoddi3+0x64>
f010174b:	89 d9                	mov    %ebx,%ecx
f010174d:	89 fa                	mov    %edi,%edx
f010174f:	29 f2                	sub    %esi,%edx
f0101751:	19 c1                	sbb    %eax,%ecx
f0101753:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101756:	89 ca                	mov    %ecx,%edx
f0101758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010175b:	83 c4 1c             	add    $0x1c,%esp
f010175e:	5b                   	pop    %ebx
f010175f:	5e                   	pop    %esi
f0101760:	5f                   	pop    %edi
f0101761:	5d                   	pop    %ebp
f0101762:	c3                   	ret    
f0101763:	90                   	nop
f0101764:	89 f1                	mov    %esi,%ecx
f0101766:	85 f6                	test   %esi,%esi
f0101768:	75 0b                	jne    f0101775 <__umoddi3+0x81>
f010176a:	b8 01 00 00 00       	mov    $0x1,%eax
f010176f:	31 d2                	xor    %edx,%edx
f0101771:	f7 f6                	div    %esi
f0101773:	89 c1                	mov    %eax,%ecx
f0101775:	89 d8                	mov    %ebx,%eax
f0101777:	31 d2                	xor    %edx,%edx
f0101779:	f7 f1                	div    %ecx
f010177b:	89 f8                	mov    %edi,%eax
f010177d:	f7 f1                	div    %ecx
f010177f:	eb 99                	jmp    f010171a <__umoddi3+0x26>
f0101781:	8d 76 00             	lea    0x0(%esi),%esi
f0101784:	ba 20 00 00 00       	mov    $0x20,%edx
f0101789:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010178c:	29 ca                	sub    %ecx,%edx
f010178e:	d3 e0                	shl    %cl,%eax
f0101790:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101793:	89 f0                	mov    %esi,%eax
f0101795:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101798:	88 d1                	mov    %dl,%cl
f010179a:	d3 e8                	shr    %cl,%eax
f010179c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010179f:	09 c1                	or     %eax,%ecx
f01017a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01017a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01017a7:	88 c1                	mov    %al,%cl
f01017a9:	d3 e6                	shl    %cl,%esi
f01017ab:	89 75 d8             	mov    %esi,-0x28(%ebp)
f01017ae:	89 de                	mov    %ebx,%esi
f01017b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01017b3:	88 d1                	mov    %dl,%cl
f01017b5:	d3 ee                	shr    %cl,%esi
f01017b7:	88 c1                	mov    %al,%cl
f01017b9:	d3 e3                	shl    %cl,%ebx
f01017bb:	89 f8                	mov    %edi,%eax
f01017bd:	88 d1                	mov    %dl,%cl
f01017bf:	d3 e8                	shr    %cl,%eax
f01017c1:	09 d8                	or     %ebx,%eax
f01017c3:	8a 4d e0             	mov    -0x20(%ebp),%cl
f01017c6:	d3 e7                	shl    %cl,%edi
f01017c8:	89 f2                	mov    %esi,%edx
f01017ca:	f7 75 dc             	divl   -0x24(%ebp)
f01017cd:	89 d3                	mov    %edx,%ebx
f01017cf:	f7 65 d8             	mull   -0x28(%ebp)
f01017d2:	89 c6                	mov    %eax,%esi
f01017d4:	89 d1                	mov    %edx,%ecx
f01017d6:	39 d3                	cmp    %edx,%ebx
f01017d8:	72 2a                	jb     f0101804 <__umoddi3+0x110>
f01017da:	74 24                	je     f0101800 <__umoddi3+0x10c>
f01017dc:	89 f8                	mov    %edi,%eax
f01017de:	29 f0                	sub    %esi,%eax
f01017e0:	19 cb                	sbb    %ecx,%ebx
f01017e2:	89 da                	mov    %ebx,%edx
f01017e4:	8a 4d e4             	mov    -0x1c(%ebp),%cl
f01017e7:	d3 e2                	shl    %cl,%edx
f01017e9:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01017ec:	89 f9                	mov    %edi,%ecx
f01017ee:	d3 e8                	shr    %cl,%eax
f01017f0:	09 d0                	or     %edx,%eax
f01017f2:	d3 eb                	shr    %cl,%ebx
f01017f4:	89 da                	mov    %ebx,%edx
f01017f6:	83 c4 1c             	add    $0x1c,%esp
f01017f9:	5b                   	pop    %ebx
f01017fa:	5e                   	pop    %esi
f01017fb:	5f                   	pop    %edi
f01017fc:	5d                   	pop    %ebp
f01017fd:	c3                   	ret    
f01017fe:	66 90                	xchg   %ax,%ax
f0101800:	39 c7                	cmp    %eax,%edi
f0101802:	73 d8                	jae    f01017dc <__umoddi3+0xe8>
f0101804:	2b 45 d8             	sub    -0x28(%ebp),%eax
f0101807:	1b 55 dc             	sbb    -0x24(%ebp),%edx
f010180a:	89 d1                	mov    %edx,%ecx
f010180c:	89 c6                	mov    %eax,%esi
f010180e:	eb cc                	jmp    f01017dc <__umoddi3+0xe8>
