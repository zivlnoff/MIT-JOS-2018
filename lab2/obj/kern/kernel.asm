
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
f0100015:	b8 00 60 11 00       	mov    $0x116000,%eax
f010001a:	0f 22 d8             	mov    %eax,%cr3
f010001d:	0f 20 c0             	mov    %cr0,%eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
f0100025:	0f 22 c0             	mov    %eax,%cr0
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp
f0100034:	bc 00 60 11 f0       	mov    $0xf0116000,%esp
f0100039:	e8 56 00 00 00       	call   f0100094 <i386_init>

f010003e <spin>:
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 0c             	sub    $0xc,%esp
f0100047:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010004a:	53                   	push   %ebx
f010004b:	68 a0 3a 10 f0       	push   $0xf0103aa0
f0100050:	e8 de 2a 00 00       	call   f0102b33 <cprintf>
f0100055:	83 c4 10             	add    $0x10,%esp
f0100058:	85 db                	test   %ebx,%ebx
f010005a:	7e 25                	jle    f0100081 <test_backtrace+0x41>
f010005c:	83 ec 0c             	sub    $0xc,%esp
f010005f:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100062:	50                   	push   %eax
f0100063:	e8 d8 ff ff ff       	call   f0100040 <test_backtrace>
f0100068:	83 c4 10             	add    $0x10,%esp
f010006b:	83 ec 08             	sub    $0x8,%esp
f010006e:	53                   	push   %ebx
f010006f:	68 bc 3a 10 f0       	push   $0xf0103abc
f0100074:	e8 ba 2a 00 00       	call   f0102b33 <cprintf>
f0100079:	83 c4 10             	add    $0x10,%esp
f010007c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010007f:	c9                   	leave  
f0100080:	c3                   	ret    
f0100081:	83 ec 04             	sub    $0x4,%esp
f0100084:	6a 00                	push   $0x0
f0100086:	6a 00                	push   $0x0
f0100088:	6a 00                	push   $0x0
f010008a:	e8 f3 06 00 00       	call   f0100782 <mon_backtrace>
f010008f:	83 c4 10             	add    $0x10,%esp
f0100092:	eb d7                	jmp    f010006b <test_backtrace+0x2b>

f0100094 <i386_init>:
f0100094:	55                   	push   %ebp
f0100095:	89 e5                	mov    %esp,%ebp
f0100097:	83 ec 1c             	sub    $0x1c,%esp
f010009a:	b8 80 89 11 f0       	mov    $0xf0118980,%eax
f010009f:	2d 00 83 11 f0       	sub    $0xf0118300,%eax
f01000a4:	50                   	push   %eax
f01000a5:	6a 00                	push   $0x0
f01000a7:	68 00 83 11 f0       	push   $0xf0118300
f01000ac:	e8 ed 35 00 00       	call   f010369e <memset>
f01000b1:	e8 ca 04 00 00       	call   f0100580 <cons_init>
f01000b6:	c7 04 24 30 3b 10 f0 	movl   $0xf0103b30,(%esp)
f01000bd:	e8 71 2a 00 00       	call   f0102b33 <cprintf>
f01000c2:	83 c4 08             	add    $0x8,%esp
f01000c5:	68 ac 1a 00 00       	push   $0x1aac
f01000ca:	68 d7 3a 10 f0       	push   $0xf0103ad7
f01000cf:	e8 5f 2a 00 00       	call   f0102b33 <cprintf>
f01000d4:	c7 45 f4 72 6c 64 00 	movl   $0x646c72,-0xc(%ebp)
f01000db:	83 c4 0c             	add    $0xc,%esp
f01000de:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01000e1:	50                   	push   %eax
f01000e2:	68 10 e1 00 00       	push   $0xe110
f01000e7:	68 f2 3a 10 f0       	push   $0xf0103af2
f01000ec:	e8 42 2a 00 00       	call   f0102b33 <cprintf>
f01000f1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f01000f8:	e8 43 ff ff ff       	call   f0100040 <test_backtrace>
f01000fd:	c7 04 24 a0 3b 10 f0 	movl   $0xf0103ba0,(%esp)
f0100104:	e8 2a 2a 00 00       	call   f0102b33 <cprintf>
f0100109:	c7 04 24 10 3c 10 f0 	movl   $0xf0103c10,(%esp)
f0100110:	e8 1e 2a 00 00       	call   f0102b33 <cprintf>
f0100115:	e8 e3 10 00 00       	call   f01011fd <mem_init>
f010011a:	c7 04 24 7c 3c 10 f0 	movl   $0xf0103c7c,(%esp)
f0100121:	e8 0d 2a 00 00       	call   f0102b33 <cprintf>
f0100126:	83 c4 10             	add    $0x10,%esp
f0100129:	83 ec 0c             	sub    $0xc,%esp
f010012c:	6a 00                	push   $0x0
f010012e:	e8 ba 06 00 00       	call   f01007ed <monitor>
f0100133:	83 c4 10             	add    $0x10,%esp
f0100136:	eb f1                	jmp    f0100129 <i386_init+0x95>

f0100138 <_panic>:
f0100138:	55                   	push   %ebp
f0100139:	89 e5                	mov    %esp,%ebp
f010013b:	53                   	push   %ebx
f010013c:	83 ec 04             	sub    $0x4,%esp
f010013f:	83 3d 00 83 11 f0 00 	cmpl   $0x0,0xf0118300
f0100146:	74 0f                	je     f0100157 <_panic+0x1f>
f0100148:	83 ec 0c             	sub    $0xc,%esp
f010014b:	6a 00                	push   $0x0
f010014d:	e8 9b 06 00 00       	call   f01007ed <monitor>
f0100152:	83 c4 10             	add    $0x10,%esp
f0100155:	eb f1                	jmp    f0100148 <_panic+0x10>
f0100157:	8b 45 10             	mov    0x10(%ebp),%eax
f010015a:	a3 00 83 11 f0       	mov    %eax,0xf0118300
f010015f:	fa                   	cli    
f0100160:	fc                   	cld    
f0100161:	8d 5d 14             	lea    0x14(%ebp),%ebx
f0100164:	83 ec 04             	sub    $0x4,%esp
f0100167:	ff 75 0c             	push   0xc(%ebp)
f010016a:	ff 75 08             	push   0x8(%ebp)
f010016d:	68 fd 3a 10 f0       	push   $0xf0103afd
f0100172:	e8 bc 29 00 00       	call   f0102b33 <cprintf>
f0100177:	83 c4 08             	add    $0x8,%esp
f010017a:	53                   	push   %ebx
f010017b:	ff 75 10             	push   0x10(%ebp)
f010017e:	e8 8a 29 00 00       	call   f0102b0d <vcprintf>
f0100183:	c7 04 24 d6 4e 10 f0 	movl   $0xf0104ed6,(%esp)
f010018a:	e8 a4 29 00 00       	call   f0102b33 <cprintf>
f010018f:	83 c4 10             	add    $0x10,%esp
f0100192:	eb b4                	jmp    f0100148 <_panic+0x10>

f0100194 <_warn>:
f0100194:	55                   	push   %ebp
f0100195:	89 e5                	mov    %esp,%ebp
f0100197:	53                   	push   %ebx
f0100198:	83 ec 08             	sub    $0x8,%esp
f010019b:	8d 5d 14             	lea    0x14(%ebp),%ebx
f010019e:	ff 75 0c             	push   0xc(%ebp)
f01001a1:	ff 75 08             	push   0x8(%ebp)
f01001a4:	68 15 3b 10 f0       	push   $0xf0103b15
f01001a9:	e8 85 29 00 00       	call   f0102b33 <cprintf>
f01001ae:	83 c4 08             	add    $0x8,%esp
f01001b1:	53                   	push   %ebx
f01001b2:	ff 75 10             	push   0x10(%ebp)
f01001b5:	e8 53 29 00 00       	call   f0102b0d <vcprintf>
f01001ba:	c7 04 24 d6 4e 10 f0 	movl   $0xf0104ed6,(%esp)
f01001c1:	e8 6d 29 00 00       	call   f0102b33 <cprintf>
f01001c6:	83 c4 10             	add    $0x10,%esp
f01001c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01001cc:	c9                   	leave  
f01001cd:	c3                   	ret    

f01001ce <serial_proc_data>:
f01001ce:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01001d3:	ec                   	in     (%dx),%al
f01001d4:	a8 01                	test   $0x1,%al
f01001d6:	74 0a                	je     f01001e2 <serial_proc_data+0x14>
f01001d8:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01001dd:	ec                   	in     (%dx),%al
f01001de:	0f b6 c0             	movzbl %al,%eax
f01001e1:	c3                   	ret    
f01001e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01001e7:	c3                   	ret    

f01001e8 <cons_intr>:
f01001e8:	55                   	push   %ebp
f01001e9:	89 e5                	mov    %esp,%ebp
f01001eb:	53                   	push   %ebx
f01001ec:	83 ec 04             	sub    $0x4,%esp
f01001ef:	89 c3                	mov    %eax,%ebx
f01001f1:	ff d3                	call   *%ebx
f01001f3:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001f6:	74 2d                	je     f0100225 <cons_intr+0x3d>
f01001f8:	85 c0                	test   %eax,%eax
f01001fa:	74 f5                	je     f01001f1 <cons_intr+0x9>
f01001fc:	8b 0d 44 85 11 f0    	mov    0xf0118544,%ecx
f0100202:	8d 51 01             	lea    0x1(%ecx),%edx
f0100205:	89 15 44 85 11 f0    	mov    %edx,0xf0118544
f010020b:	88 81 40 83 11 f0    	mov    %al,-0xfee7cc0(%ecx)
f0100211:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0100217:	75 d8                	jne    f01001f1 <cons_intr+0x9>
f0100219:	c7 05 44 85 11 f0 00 	movl   $0x0,0xf0118544
f0100220:	00 00 00 
f0100223:	eb cc                	jmp    f01001f1 <cons_intr+0x9>
f0100225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100228:	c9                   	leave  
f0100229:	c3                   	ret    

f010022a <kbd_proc_data>:
f010022a:	55                   	push   %ebp
f010022b:	89 e5                	mov    %esp,%ebp
f010022d:	53                   	push   %ebx
f010022e:	83 ec 04             	sub    $0x4,%esp
f0100231:	ba 64 00 00 00       	mov    $0x64,%edx
f0100236:	ec                   	in     (%dx),%al
f0100237:	a8 01                	test   $0x1,%al
f0100239:	0f 84 e9 00 00 00    	je     f0100328 <kbd_proc_data+0xfe>
f010023f:	a8 20                	test   $0x20,%al
f0100241:	0f 85 e8 00 00 00    	jne    f010032f <kbd_proc_data+0x105>
f0100247:	ba 60 00 00 00       	mov    $0x60,%edx
f010024c:	ec                   	in     (%dx),%al
f010024d:	88 c2                	mov    %al,%dl
f010024f:	3c e0                	cmp    $0xe0,%al
f0100251:	74 60                	je     f01002b3 <kbd_proc_data+0x89>
f0100253:	84 c0                	test   %al,%al
f0100255:	78 6f                	js     f01002c6 <kbd_proc_data+0x9c>
f0100257:	8b 0d 20 83 11 f0    	mov    0xf0118320,%ecx
f010025d:	f6 c1 40             	test   $0x40,%cl
f0100260:	74 0e                	je     f0100270 <kbd_proc_data+0x46>
f0100262:	83 c8 80             	or     $0xffffff80,%eax
f0100265:	88 c2                	mov    %al,%dl
f0100267:	83 e1 bf             	and    $0xffffffbf,%ecx
f010026a:	89 0d 20 83 11 f0    	mov    %ecx,0xf0118320
f0100270:	0f b6 d2             	movzbl %dl,%edx
f0100273:	0f b6 82 40 3e 10 f0 	movzbl -0xfefc1c0(%edx),%eax
f010027a:	0b 05 20 83 11 f0    	or     0xf0118320,%eax
f0100280:	0f b6 8a 40 3d 10 f0 	movzbl -0xfefc2c0(%edx),%ecx
f0100287:	31 c8                	xor    %ecx,%eax
f0100289:	a3 20 83 11 f0       	mov    %eax,0xf0118320
f010028e:	89 c1                	mov    %eax,%ecx
f0100290:	83 e1 03             	and    $0x3,%ecx
f0100293:	8b 0c 8d 20 3d 10 f0 	mov    -0xfefc2e0(,%ecx,4),%ecx
f010029a:	8a 14 11             	mov    (%ecx,%edx,1),%dl
f010029d:	0f b6 da             	movzbl %dl,%ebx
f01002a0:	a8 08                	test   $0x8,%al
f01002a2:	74 5c                	je     f0100300 <kbd_proc_data+0xd6>
f01002a4:	89 da                	mov    %ebx,%edx
f01002a6:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f01002a9:	83 f9 19             	cmp    $0x19,%ecx
f01002ac:	77 47                	ja     f01002f5 <kbd_proc_data+0xcb>
f01002ae:	83 eb 20             	sub    $0x20,%ebx
f01002b1:	eb 0c                	jmp    f01002bf <kbd_proc_data+0x95>
f01002b3:	83 0d 20 83 11 f0 40 	orl    $0x40,0xf0118320
f01002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002bf:	89 d8                	mov    %ebx,%eax
f01002c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002c4:	c9                   	leave  
f01002c5:	c3                   	ret    
f01002c6:	8b 0d 20 83 11 f0    	mov    0xf0118320,%ecx
f01002cc:	f6 c1 40             	test   $0x40,%cl
f01002cf:	75 05                	jne    f01002d6 <kbd_proc_data+0xac>
f01002d1:	83 e0 7f             	and    $0x7f,%eax
f01002d4:	88 c2                	mov    %al,%dl
f01002d6:	0f b6 d2             	movzbl %dl,%edx
f01002d9:	8a 82 40 3e 10 f0    	mov    -0xfefc1c0(%edx),%al
f01002df:	83 c8 40             	or     $0x40,%eax
f01002e2:	0f b6 c0             	movzbl %al,%eax
f01002e5:	f7 d0                	not    %eax
f01002e7:	21 c8                	and    %ecx,%eax
f01002e9:	a3 20 83 11 f0       	mov    %eax,0xf0118320
f01002ee:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002f3:	eb ca                	jmp    f01002bf <kbd_proc_data+0x95>
f01002f5:	83 ea 41             	sub    $0x41,%edx
f01002f8:	83 fa 19             	cmp    $0x19,%edx
f01002fb:	77 03                	ja     f0100300 <kbd_proc_data+0xd6>
f01002fd:	83 c3 20             	add    $0x20,%ebx
f0100300:	f7 d0                	not    %eax
f0100302:	a8 06                	test   $0x6,%al
f0100304:	75 b9                	jne    f01002bf <kbd_proc_data+0x95>
f0100306:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010030c:	75 b1                	jne    f01002bf <kbd_proc_data+0x95>
f010030e:	83 ec 0c             	sub    $0xc,%esp
f0100311:	68 e9 3c 10 f0       	push   $0xf0103ce9
f0100316:	e8 18 28 00 00       	call   f0102b33 <cprintf>
f010031b:	b0 03                	mov    $0x3,%al
f010031d:	ba 92 00 00 00       	mov    $0x92,%edx
f0100322:	ee                   	out    %al,(%dx)
f0100323:	83 c4 10             	add    $0x10,%esp
f0100326:	eb 97                	jmp    f01002bf <kbd_proc_data+0x95>
f0100328:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010032d:	eb 90                	jmp    f01002bf <kbd_proc_data+0x95>
f010032f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100334:	eb 89                	jmp    f01002bf <kbd_proc_data+0x95>

f0100336 <cons_putc>:
f0100336:	55                   	push   %ebp
f0100337:	89 e5                	mov    %esp,%ebp
f0100339:	57                   	push   %edi
f010033a:	56                   	push   %esi
f010033b:	53                   	push   %ebx
f010033c:	83 ec 0c             	sub    $0xc,%esp
f010033f:	89 c1                	mov    %eax,%ecx
f0100341:	bb 01 32 00 00       	mov    $0x3201,%ebx
f0100346:	be fd 03 00 00       	mov    $0x3fd,%esi
f010034b:	bf 84 00 00 00       	mov    $0x84,%edi
f0100350:	89 f2                	mov    %esi,%edx
f0100352:	ec                   	in     (%dx),%al
f0100353:	a8 20                	test   $0x20,%al
f0100355:	75 0b                	jne    f0100362 <cons_putc+0x2c>
f0100357:	4b                   	dec    %ebx
f0100358:	74 08                	je     f0100362 <cons_putc+0x2c>
f010035a:	89 fa                	mov    %edi,%edx
f010035c:	ec                   	in     (%dx),%al
f010035d:	ec                   	in     (%dx),%al
f010035e:	ec                   	in     (%dx),%al
f010035f:	ec                   	in     (%dx),%al
f0100360:	eb ee                	jmp    f0100350 <cons_putc+0x1a>
f0100362:	89 cf                	mov    %ecx,%edi
f0100364:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100369:	88 c8                	mov    %cl,%al
f010036b:	ee                   	out    %al,(%dx)
f010036c:	bb 01 32 00 00       	mov    $0x3201,%ebx
f0100371:	be 79 03 00 00       	mov    $0x379,%esi
f0100376:	89 f2                	mov    %esi,%edx
f0100378:	ec                   	in     (%dx),%al
f0100379:	84 c0                	test   %al,%al
f010037b:	78 0e                	js     f010038b <cons_putc+0x55>
f010037d:	4b                   	dec    %ebx
f010037e:	74 0b                	je     f010038b <cons_putc+0x55>
f0100380:	ba 84 00 00 00       	mov    $0x84,%edx
f0100385:	ec                   	in     (%dx),%al
f0100386:	ec                   	in     (%dx),%al
f0100387:	ec                   	in     (%dx),%al
f0100388:	ec                   	in     (%dx),%al
f0100389:	eb eb                	jmp    f0100376 <cons_putc+0x40>
f010038b:	ba 78 03 00 00       	mov    $0x378,%edx
f0100390:	89 f8                	mov    %edi,%eax
f0100392:	ee                   	out    %al,(%dx)
f0100393:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100398:	b0 0d                	mov    $0xd,%al
f010039a:	ee                   	out    %al,(%dx)
f010039b:	b0 08                	mov    $0x8,%al
f010039d:	ee                   	out    %al,(%dx)
f010039e:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f01003a4:	75 03                	jne    f01003a9 <cons_putc+0x73>
f01003a6:	80 cd 07             	or     $0x7,%ch
f01003a9:	0f b6 c1             	movzbl %cl,%eax
f01003ac:	80 f9 0a             	cmp    $0xa,%cl
f01003af:	0f 84 de 00 00 00    	je     f0100493 <cons_putc+0x15d>
f01003b5:	83 f8 0a             	cmp    $0xa,%eax
f01003b8:	7f 46                	jg     f0100400 <cons_putc+0xca>
f01003ba:	83 f8 08             	cmp    $0x8,%eax
f01003bd:	0f 84 a4 00 00 00    	je     f0100467 <cons_putc+0x131>
f01003c3:	83 f8 09             	cmp    $0x9,%eax
f01003c6:	0f 85 d4 00 00 00    	jne    f01004a0 <cons_putc+0x16a>
f01003cc:	b8 20 00 00 00       	mov    $0x20,%eax
f01003d1:	e8 60 ff ff ff       	call   f0100336 <cons_putc>
f01003d6:	b8 20 00 00 00       	mov    $0x20,%eax
f01003db:	e8 56 ff ff ff       	call   f0100336 <cons_putc>
f01003e0:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e5:	e8 4c ff ff ff       	call   f0100336 <cons_putc>
f01003ea:	b8 20 00 00 00       	mov    $0x20,%eax
f01003ef:	e8 42 ff ff ff       	call   f0100336 <cons_putc>
f01003f4:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f9:	e8 38 ff ff ff       	call   f0100336 <cons_putc>
f01003fe:	eb 28                	jmp    f0100428 <cons_putc+0xf2>
f0100400:	83 f8 0d             	cmp    $0xd,%eax
f0100403:	0f 85 97 00 00 00    	jne    f01004a0 <cons_putc+0x16a>
f0100409:	66 8b 0d 48 85 11 f0 	mov    0xf0118548,%cx
f0100410:	bb 50 00 00 00       	mov    $0x50,%ebx
f0100415:	89 c8                	mov    %ecx,%eax
f0100417:	ba 00 00 00 00       	mov    $0x0,%edx
f010041c:	66 f7 f3             	div    %bx
f010041f:	29 d1                	sub    %edx,%ecx
f0100421:	66 89 0d 48 85 11 f0 	mov    %cx,0xf0118548
f0100428:	66 81 3d 48 85 11 f0 	cmpw   $0x7cf,0xf0118548
f010042f:	cf 07 
f0100431:	0f 87 8b 00 00 00    	ja     f01004c2 <cons_putc+0x18c>
f0100437:	8b 0d 50 85 11 f0    	mov    0xf0118550,%ecx
f010043d:	b0 0e                	mov    $0xe,%al
f010043f:	89 ca                	mov    %ecx,%edx
f0100441:	ee                   	out    %al,(%dx)
f0100442:	8d 59 01             	lea    0x1(%ecx),%ebx
f0100445:	66 a1 48 85 11 f0    	mov    0xf0118548,%ax
f010044b:	66 c1 e8 08          	shr    $0x8,%ax
f010044f:	89 da                	mov    %ebx,%edx
f0100451:	ee                   	out    %al,(%dx)
f0100452:	b0 0f                	mov    $0xf,%al
f0100454:	89 ca                	mov    %ecx,%edx
f0100456:	ee                   	out    %al,(%dx)
f0100457:	a0 48 85 11 f0       	mov    0xf0118548,%al
f010045c:	89 da                	mov    %ebx,%edx
f010045e:	ee                   	out    %al,(%dx)
f010045f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100462:	5b                   	pop    %ebx
f0100463:	5e                   	pop    %esi
f0100464:	5f                   	pop    %edi
f0100465:	5d                   	pop    %ebp
f0100466:	c3                   	ret    
f0100467:	66 a1 48 85 11 f0    	mov    0xf0118548,%ax
f010046d:	66 85 c0             	test   %ax,%ax
f0100470:	74 c5                	je     f0100437 <cons_putc+0x101>
f0100472:	48                   	dec    %eax
f0100473:	66 a3 48 85 11 f0    	mov    %ax,0xf0118548
f0100479:	0f b7 c0             	movzwl %ax,%eax
f010047c:	89 cf                	mov    %ecx,%edi
f010047e:	81 e7 00 ff ff ff    	and    $0xffffff00,%edi
f0100484:	83 cf 20             	or     $0x20,%edi
f0100487:	8b 15 4c 85 11 f0    	mov    0xf011854c,%edx
f010048d:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100491:	eb 95                	jmp    f0100428 <cons_putc+0xf2>
f0100493:	66 83 05 48 85 11 f0 	addw   $0x50,0xf0118548
f010049a:	50 
f010049b:	e9 69 ff ff ff       	jmp    f0100409 <cons_putc+0xd3>
f01004a0:	66 a1 48 85 11 f0    	mov    0xf0118548,%ax
f01004a6:	8d 50 01             	lea    0x1(%eax),%edx
f01004a9:	66 89 15 48 85 11 f0 	mov    %dx,0xf0118548
f01004b0:	0f b7 c0             	movzwl %ax,%eax
f01004b3:	8b 15 4c 85 11 f0    	mov    0xf011854c,%edx
f01004b9:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01004bd:	e9 66 ff ff ff       	jmp    f0100428 <cons_putc+0xf2>
f01004c2:	a1 4c 85 11 f0       	mov    0xf011854c,%eax
f01004c7:	83 ec 04             	sub    $0x4,%esp
f01004ca:	68 00 0f 00 00       	push   $0xf00
f01004cf:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d5:	52                   	push   %edx
f01004d6:	50                   	push   %eax
f01004d7:	e8 0d 32 00 00       	call   f01036e9 <memmove>
f01004dc:	8b 15 4c 85 11 f0    	mov    0xf011854c,%edx
f01004e2:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004e8:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004ee:	83 c4 10             	add    $0x10,%esp
f01004f1:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01004f6:	83 c0 02             	add    $0x2,%eax
f01004f9:	39 d0                	cmp    %edx,%eax
f01004fb:	75 f4                	jne    f01004f1 <cons_putc+0x1bb>
f01004fd:	66 83 2d 48 85 11 f0 	subw   $0x50,0xf0118548
f0100504:	50 
f0100505:	e9 2d ff ff ff       	jmp    f0100437 <cons_putc+0x101>

f010050a <serial_intr>:
f010050a:	80 3d 54 85 11 f0 00 	cmpb   $0x0,0xf0118554
f0100511:	75 01                	jne    f0100514 <serial_intr+0xa>
f0100513:	c3                   	ret    
f0100514:	55                   	push   %ebp
f0100515:	89 e5                	mov    %esp,%ebp
f0100517:	83 ec 08             	sub    $0x8,%esp
f010051a:	b8 ce 01 10 f0       	mov    $0xf01001ce,%eax
f010051f:	e8 c4 fc ff ff       	call   f01001e8 <cons_intr>
f0100524:	c9                   	leave  
f0100525:	c3                   	ret    

f0100526 <kbd_intr>:
f0100526:	55                   	push   %ebp
f0100527:	89 e5                	mov    %esp,%ebp
f0100529:	83 ec 08             	sub    $0x8,%esp
f010052c:	b8 2a 02 10 f0       	mov    $0xf010022a,%eax
f0100531:	e8 b2 fc ff ff       	call   f01001e8 <cons_intr>
f0100536:	c9                   	leave  
f0100537:	c3                   	ret    

f0100538 <cons_getc>:
f0100538:	55                   	push   %ebp
f0100539:	89 e5                	mov    %esp,%ebp
f010053b:	83 ec 08             	sub    $0x8,%esp
f010053e:	e8 c7 ff ff ff       	call   f010050a <serial_intr>
f0100543:	e8 de ff ff ff       	call   f0100526 <kbd_intr>
f0100548:	a1 40 85 11 f0       	mov    0xf0118540,%eax
f010054d:	3b 05 44 85 11 f0    	cmp    0xf0118544,%eax
f0100553:	74 24                	je     f0100579 <cons_getc+0x41>
f0100555:	8d 50 01             	lea    0x1(%eax),%edx
f0100558:	89 15 40 85 11 f0    	mov    %edx,0xf0118540
f010055e:	0f b6 80 40 83 11 f0 	movzbl -0xfee7cc0(%eax),%eax
f0100565:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010056b:	75 11                	jne    f010057e <cons_getc+0x46>
f010056d:	c7 05 40 85 11 f0 00 	movl   $0x0,0xf0118540
f0100574:	00 00 00 
f0100577:	eb 05                	jmp    f010057e <cons_getc+0x46>
f0100579:	b8 00 00 00 00       	mov    $0x0,%eax
f010057e:	c9                   	leave  
f010057f:	c3                   	ret    

f0100580 <cons_init>:
f0100580:	55                   	push   %ebp
f0100581:	89 e5                	mov    %esp,%ebp
f0100583:	57                   	push   %edi
f0100584:	56                   	push   %esi
f0100585:	53                   	push   %ebx
f0100586:	83 ec 0c             	sub    $0xc,%esp
f0100589:	66 8b 15 00 80 0b f0 	mov    0xf00b8000,%dx
f0100590:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100597:	5a a5 
f0100599:	66 a1 00 80 0b f0    	mov    0xf00b8000,%ax
f010059f:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005a3:	0f 84 9b 00 00 00    	je     f0100644 <cons_init+0xc4>
f01005a9:	bb b4 03 00 00       	mov    $0x3b4,%ebx
f01005ae:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01005b3:	89 1d 50 85 11 f0    	mov    %ebx,0xf0118550
f01005b9:	b0 0e                	mov    $0xe,%al
f01005bb:	89 da                	mov    %ebx,%edx
f01005bd:	ee                   	out    %al,(%dx)
f01005be:	8d 7b 01             	lea    0x1(%ebx),%edi
f01005c1:	89 fa                	mov    %edi,%edx
f01005c3:	ec                   	in     (%dx),%al
f01005c4:	0f b6 c8             	movzbl %al,%ecx
f01005c7:	c1 e1 08             	shl    $0x8,%ecx
f01005ca:	b0 0f                	mov    $0xf,%al
f01005cc:	89 da                	mov    %ebx,%edx
f01005ce:	ee                   	out    %al,(%dx)
f01005cf:	89 fa                	mov    %edi,%edx
f01005d1:	ec                   	in     (%dx),%al
f01005d2:	89 35 4c 85 11 f0    	mov    %esi,0xf011854c
f01005d8:	0f b6 c0             	movzbl %al,%eax
f01005db:	09 c8                	or     %ecx,%eax
f01005dd:	66 a3 48 85 11 f0    	mov    %ax,0xf0118548
f01005e3:	b1 00                	mov    $0x0,%cl
f01005e5:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f01005ea:	88 c8                	mov    %cl,%al
f01005ec:	89 da                	mov    %ebx,%edx
f01005ee:	ee                   	out    %al,(%dx)
f01005ef:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01005f4:	b0 80                	mov    $0x80,%al
f01005f6:	89 fa                	mov    %edi,%edx
f01005f8:	ee                   	out    %al,(%dx)
f01005f9:	b0 0c                	mov    $0xc,%al
f01005fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100600:	ee                   	out    %al,(%dx)
f0100601:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100606:	88 c8                	mov    %cl,%al
f0100608:	89 f2                	mov    %esi,%edx
f010060a:	ee                   	out    %al,(%dx)
f010060b:	b0 03                	mov    $0x3,%al
f010060d:	89 fa                	mov    %edi,%edx
f010060f:	ee                   	out    %al,(%dx)
f0100610:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100615:	88 c8                	mov    %cl,%al
f0100617:	ee                   	out    %al,(%dx)
f0100618:	b0 01                	mov    $0x1,%al
f010061a:	89 f2                	mov    %esi,%edx
f010061c:	ee                   	out    %al,(%dx)
f010061d:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100622:	ec                   	in     (%dx),%al
f0100623:	88 c1                	mov    %al,%cl
f0100625:	3c ff                	cmp    $0xff,%al
f0100627:	0f 95 05 54 85 11 f0 	setne  0xf0118554
f010062e:	89 da                	mov    %ebx,%edx
f0100630:	ec                   	in     (%dx),%al
f0100631:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100636:	ec                   	in     (%dx),%al
f0100637:	80 f9 ff             	cmp    $0xff,%cl
f010063a:	74 1e                	je     f010065a <cons_init+0xda>
f010063c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010063f:	5b                   	pop    %ebx
f0100640:	5e                   	pop    %esi
f0100641:	5f                   	pop    %edi
f0100642:	5d                   	pop    %ebp
f0100643:	c3                   	ret    
f0100644:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
f010064b:	bb d4 03 00 00       	mov    $0x3d4,%ebx
f0100650:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100655:	e9 59 ff ff ff       	jmp    f01005b3 <cons_init+0x33>
f010065a:	83 ec 0c             	sub    $0xc,%esp
f010065d:	68 f5 3c 10 f0       	push   $0xf0103cf5
f0100662:	e8 cc 24 00 00       	call   f0102b33 <cprintf>
f0100667:	83 c4 10             	add    $0x10,%esp
f010066a:	eb d0                	jmp    f010063c <cons_init+0xbc>

f010066c <cputchar>:
f010066c:	55                   	push   %ebp
f010066d:	89 e5                	mov    %esp,%ebp
f010066f:	83 ec 08             	sub    $0x8,%esp
f0100672:	8b 45 08             	mov    0x8(%ebp),%eax
f0100675:	e8 bc fc ff ff       	call   f0100336 <cons_putc>
f010067a:	c9                   	leave  
f010067b:	c3                   	ret    

f010067c <getchar>:
f010067c:	55                   	push   %ebp
f010067d:	89 e5                	mov    %esp,%ebp
f010067f:	83 ec 08             	sub    $0x8,%esp
f0100682:	e8 b1 fe ff ff       	call   f0100538 <cons_getc>
f0100687:	85 c0                	test   %eax,%eax
f0100689:	74 f7                	je     f0100682 <getchar+0x6>
f010068b:	c9                   	leave  
f010068c:	c3                   	ret    

f010068d <iscons>:
f010068d:	b8 01 00 00 00       	mov    $0x1,%eax
f0100692:	c3                   	ret    

f0100693 <mon_help>:
f0100693:	55                   	push   %ebp
f0100694:	89 e5                	mov    %esp,%ebp
f0100696:	83 ec 0c             	sub    $0xc,%esp
f0100699:	68 40 3f 10 f0       	push   $0xf0103f40
f010069e:	68 5e 3f 10 f0       	push   $0xf0103f5e
f01006a3:	68 63 3f 10 f0       	push   $0xf0103f63
f01006a8:	e8 86 24 00 00       	call   f0102b33 <cprintf>
f01006ad:	83 c4 0c             	add    $0xc,%esp
f01006b0:	68 08 40 10 f0       	push   $0xf0104008
f01006b5:	68 6c 3f 10 f0       	push   $0xf0103f6c
f01006ba:	68 63 3f 10 f0       	push   $0xf0103f63
f01006bf:	e8 6f 24 00 00       	call   f0102b33 <cprintf>
f01006c4:	83 c4 0c             	add    $0xc,%esp
f01006c7:	68 75 3f 10 f0       	push   $0xf0103f75
f01006cc:	68 93 3f 10 f0       	push   $0xf0103f93
f01006d1:	68 63 3f 10 f0       	push   $0xf0103f63
f01006d6:	e8 58 24 00 00       	call   f0102b33 <cprintf>
f01006db:	b8 00 00 00 00       	mov    $0x0,%eax
f01006e0:	c9                   	leave  
f01006e1:	c3                   	ret    

f01006e2 <mon_kerninfo>:
f01006e2:	55                   	push   %ebp
f01006e3:	89 e5                	mov    %esp,%ebp
f01006e5:	83 ec 14             	sub    $0x14,%esp
f01006e8:	68 9d 3f 10 f0       	push   $0xf0103f9d
f01006ed:	e8 41 24 00 00       	call   f0102b33 <cprintf>
f01006f2:	83 c4 08             	add    $0x8,%esp
f01006f5:	68 0c 00 10 00       	push   $0x10000c
f01006fa:	68 30 40 10 f0       	push   $0xf0104030
f01006ff:	e8 2f 24 00 00       	call   f0102b33 <cprintf>
f0100704:	83 c4 0c             	add    $0xc,%esp
f0100707:	68 0c 00 10 00       	push   $0x10000c
f010070c:	68 0c 00 10 f0       	push   $0xf010000c
f0100711:	68 58 40 10 f0       	push   $0xf0104058
f0100716:	e8 18 24 00 00       	call   f0102b33 <cprintf>
f010071b:	83 c4 0c             	add    $0xc,%esp
f010071e:	68 a0 3a 10 00       	push   $0x103aa0
f0100723:	68 a0 3a 10 f0       	push   $0xf0103aa0
f0100728:	68 7c 40 10 f0       	push   $0xf010407c
f010072d:	e8 01 24 00 00       	call   f0102b33 <cprintf>
f0100732:	83 c4 0c             	add    $0xc,%esp
f0100735:	68 00 83 11 00       	push   $0x118300
f010073a:	68 00 83 11 f0       	push   $0xf0118300
f010073f:	68 a0 40 10 f0       	push   $0xf01040a0
f0100744:	e8 ea 23 00 00       	call   f0102b33 <cprintf>
f0100749:	83 c4 0c             	add    $0xc,%esp
f010074c:	68 80 89 11 00       	push   $0x118980
f0100751:	68 80 89 11 f0       	push   $0xf0118980
f0100756:	68 c4 40 10 f0       	push   $0xf01040c4
f010075b:	e8 d3 23 00 00       	call   f0102b33 <cprintf>
f0100760:	83 c4 08             	add    $0x8,%esp
f0100763:	b8 80 89 11 f0       	mov    $0xf0118980,%eax
f0100768:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
f010076d:	c1 f8 0a             	sar    $0xa,%eax
f0100770:	50                   	push   %eax
f0100771:	68 e8 40 10 f0       	push   $0xf01040e8
f0100776:	e8 b8 23 00 00       	call   f0102b33 <cprintf>
f010077b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100780:	c9                   	leave  
f0100781:	c3                   	ret    

f0100782 <mon_backtrace>:
f0100782:	55                   	push   %ebp
f0100783:	89 e5                	mov    %esp,%ebp
f0100785:	57                   	push   %edi
f0100786:	56                   	push   %esi
f0100787:	53                   	push   %ebx
f0100788:	83 ec 2c             	sub    $0x2c,%esp
f010078b:	89 eb                	mov    %ebp,%ebx
f010078d:	8d 7d d0             	lea    -0x30(%ebp),%edi
f0100790:	eb 4a                	jmp    f01007dc <mon_backtrace+0x5a>
f0100792:	8b 73 04             	mov    0x4(%ebx),%esi
f0100795:	83 ec 04             	sub    $0x4,%esp
f0100798:	ff 73 14             	push   0x14(%ebx)
f010079b:	ff 73 10             	push   0x10(%ebx)
f010079e:	ff 73 0c             	push   0xc(%ebx)
f01007a1:	ff 73 08             	push   0x8(%ebx)
f01007a4:	56                   	push   %esi
f01007a5:	53                   	push   %ebx
f01007a6:	68 14 41 10 f0       	push   $0xf0104114
f01007ab:	e8 83 23 00 00       	call   f0102b33 <cprintf>
f01007b0:	83 c4 18             	add    $0x18,%esp
f01007b3:	57                   	push   %edi
f01007b4:	56                   	push   %esi
f01007b5:	e8 9b 24 00 00       	call   f0102c55 <debuginfo_eip>
f01007ba:	83 c4 08             	add    $0x8,%esp
f01007bd:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01007c0:	56                   	push   %esi
f01007c1:	ff 75 d8             	push   -0x28(%ebp)
f01007c4:	ff 75 dc             	push   -0x24(%ebp)
f01007c7:	ff 75 d4             	push   -0x2c(%ebp)
f01007ca:	ff 75 d0             	push   -0x30(%ebp)
f01007cd:	68 b6 3f 10 f0       	push   $0xf0103fb6
f01007d2:	e8 5c 23 00 00       	call   f0102b33 <cprintf>
f01007d7:	8b 1b                	mov    (%ebx),%ebx
f01007d9:	83 c4 20             	add    $0x20,%esp
f01007dc:	85 db                	test   %ebx,%ebx
f01007de:	75 b2                	jne    f0100792 <mon_backtrace+0x10>
f01007e0:	b8 01 00 00 00       	mov    $0x1,%eax
f01007e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007e8:	5b                   	pop    %ebx
f01007e9:	5e                   	pop    %esi
f01007ea:	5f                   	pop    %edi
f01007eb:	5d                   	pop    %ebp
f01007ec:	c3                   	ret    

f01007ed <monitor>:
f01007ed:	55                   	push   %ebp
f01007ee:	89 e5                	mov    %esp,%ebp
f01007f0:	57                   	push   %edi
f01007f1:	56                   	push   %esi
f01007f2:	53                   	push   %ebx
f01007f3:	83 ec 58             	sub    $0x58,%esp
f01007f6:	68 4c 41 10 f0       	push   $0xf010414c
f01007fb:	e8 33 23 00 00       	call   f0102b33 <cprintf>
f0100800:	c7 04 24 70 41 10 f0 	movl   $0xf0104170,(%esp)
f0100807:	e8 27 23 00 00       	call   f0102b33 <cprintf>
f010080c:	83 c4 10             	add    $0x10,%esp
f010080f:	eb 47                	jmp    f0100858 <monitor+0x6b>
f0100811:	83 ec 08             	sub    $0x8,%esp
f0100814:	0f be c0             	movsbl %al,%eax
f0100817:	50                   	push   %eax
f0100818:	68 cd 3f 10 f0       	push   $0xf0103fcd
f010081d:	e8 45 2e 00 00       	call   f0103667 <strchr>
f0100822:	83 c4 10             	add    $0x10,%esp
f0100825:	85 c0                	test   %eax,%eax
f0100827:	74 0a                	je     f0100833 <monitor+0x46>
f0100829:	c6 03 00             	movb   $0x0,(%ebx)
f010082c:	89 f7                	mov    %esi,%edi
f010082e:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100831:	eb 68                	jmp    f010089b <monitor+0xae>
f0100833:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100836:	74 6f                	je     f01008a7 <monitor+0xba>
f0100838:	83 fe 0f             	cmp    $0xf,%esi
f010083b:	74 09                	je     f0100846 <monitor+0x59>
f010083d:	8d 7e 01             	lea    0x1(%esi),%edi
f0100840:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100844:	eb 37                	jmp    f010087d <monitor+0x90>
f0100846:	83 ec 08             	sub    $0x8,%esp
f0100849:	6a 10                	push   $0x10
f010084b:	68 d2 3f 10 f0       	push   $0xf0103fd2
f0100850:	e8 de 22 00 00       	call   f0102b33 <cprintf>
f0100855:	83 c4 10             	add    $0x10,%esp
f0100858:	83 ec 0c             	sub    $0xc,%esp
f010085b:	68 c9 3f 10 f0       	push   $0xf0103fc9
f0100860:	e8 f0 2b 00 00       	call   f0103455 <readline>
f0100865:	89 c3                	mov    %eax,%ebx
f0100867:	83 c4 10             	add    $0x10,%esp
f010086a:	85 c0                	test   %eax,%eax
f010086c:	74 ea                	je     f0100858 <monitor+0x6b>
f010086e:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100875:	be 00 00 00 00       	mov    $0x0,%esi
f010087a:	eb 21                	jmp    f010089d <monitor+0xb0>
f010087c:	43                   	inc    %ebx
f010087d:	8a 03                	mov    (%ebx),%al
f010087f:	84 c0                	test   %al,%al
f0100881:	74 18                	je     f010089b <monitor+0xae>
f0100883:	83 ec 08             	sub    $0x8,%esp
f0100886:	0f be c0             	movsbl %al,%eax
f0100889:	50                   	push   %eax
f010088a:	68 cd 3f 10 f0       	push   $0xf0103fcd
f010088f:	e8 d3 2d 00 00       	call   f0103667 <strchr>
f0100894:	83 c4 10             	add    $0x10,%esp
f0100897:	85 c0                	test   %eax,%eax
f0100899:	74 e1                	je     f010087c <monitor+0x8f>
f010089b:	89 fe                	mov    %edi,%esi
f010089d:	8a 03                	mov    (%ebx),%al
f010089f:	84 c0                	test   %al,%al
f01008a1:	0f 85 6a ff ff ff    	jne    f0100811 <monitor+0x24>
f01008a7:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01008ae:	00 
f01008af:	85 f6                	test   %esi,%esi
f01008b1:	74 a5                	je     f0100858 <monitor+0x6b>
f01008b3:	bf a0 41 10 f0       	mov    $0xf01041a0,%edi
f01008b8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01008bd:	83 ec 08             	sub    $0x8,%esp
f01008c0:	ff 37                	push   (%edi)
f01008c2:	ff 75 a8             	push   -0x58(%ebp)
f01008c5:	e8 47 2d 00 00       	call   f0103611 <strcmp>
f01008ca:	83 c4 10             	add    $0x10,%esp
f01008cd:	85 c0                	test   %eax,%eax
f01008cf:	74 21                	je     f01008f2 <monitor+0x105>
f01008d1:	43                   	inc    %ebx
f01008d2:	83 c7 0c             	add    $0xc,%edi
f01008d5:	83 fb 03             	cmp    $0x3,%ebx
f01008d8:	75 e3                	jne    f01008bd <monitor+0xd0>
f01008da:	83 ec 08             	sub    $0x8,%esp
f01008dd:	ff 75 a8             	push   -0x58(%ebp)
f01008e0:	68 ef 3f 10 f0       	push   $0xf0103fef
f01008e5:	e8 49 22 00 00       	call   f0102b33 <cprintf>
f01008ea:	83 c4 10             	add    $0x10,%esp
f01008ed:	e9 66 ff ff ff       	jmp    f0100858 <monitor+0x6b>
f01008f2:	83 ec 04             	sub    $0x4,%esp
f01008f5:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
f01008f8:	01 d8                	add    %ebx,%eax
f01008fa:	ff 75 08             	push   0x8(%ebp)
f01008fd:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100900:	52                   	push   %edx
f0100901:	56                   	push   %esi
f0100902:	ff 14 85 a8 41 10 f0 	call   *-0xfefbe58(,%eax,4)
f0100909:	83 c4 10             	add    $0x10,%esp
f010090c:	85 c0                	test   %eax,%eax
f010090e:	0f 89 44 ff ff ff    	jns    f0100858 <monitor+0x6b>
f0100914:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100917:	5b                   	pop    %ebx
f0100918:	5e                   	pop    %esi
f0100919:	5f                   	pop    %edi
f010091a:	5d                   	pop    %ebp
f010091b:	c3                   	ret    

f010091c <nvram_read>:
f010091c:	55                   	push   %ebp
f010091d:	89 e5                	mov    %esp,%ebp
f010091f:	56                   	push   %esi
f0100920:	53                   	push   %ebx
f0100921:	89 c3                	mov    %eax,%ebx
f0100923:	83 ec 0c             	sub    $0xc,%esp
f0100926:	50                   	push   %eax
f0100927:	e8 a0 21 00 00       	call   f0102acc <mc146818_read>
f010092c:	89 c6                	mov    %eax,%esi
f010092e:	43                   	inc    %ebx
f010092f:	89 1c 24             	mov    %ebx,(%esp)
f0100932:	e8 95 21 00 00       	call   f0102acc <mc146818_read>
f0100937:	c1 e0 08             	shl    $0x8,%eax
f010093a:	09 f0                	or     %esi,%eax
f010093c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010093f:	5b                   	pop    %ebx
f0100940:	5e                   	pop    %esi
f0100941:	5d                   	pop    %ebp
f0100942:	c3                   	ret    

f0100943 <boot_alloc>:
f0100943:	83 3d 64 85 11 f0 00 	cmpl   $0x0,0xf0118564
f010094a:	74 21                	je     f010096d <boot_alloc+0x2a>
f010094c:	8b 15 64 85 11 f0    	mov    0xf0118564,%edx
f0100952:	8d 4a ff             	lea    -0x1(%edx),%ecx
f0100955:	01 c1                	add    %eax,%ecx
f0100957:	72 27                	jb     f0100980 <boot_alloc+0x3d>
f0100959:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100960:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100965:	a3 64 85 11 f0       	mov    %eax,0xf0118564
f010096a:	89 d0                	mov    %edx,%eax
f010096c:	c3                   	ret    
f010096d:	ba 7f 99 11 f0       	mov    $0xf011997f,%edx
f0100972:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100978:	89 15 64 85 11 f0    	mov    %edx,0xf0118564
f010097e:	eb cc                	jmp    f010094c <boot_alloc+0x9>
f0100980:	55                   	push   %ebp
f0100981:	89 e5                	mov    %esp,%ebp
f0100983:	83 ec 08             	sub    $0x8,%esp
f0100986:	68 c4 41 10 f0       	push   $0xf01041c4
f010098b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100990:	6a 6f                	push   $0x6f
f0100992:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100997:	e8 9c f7 ff ff       	call   f0100138 <_panic>

f010099c <check_va2pa>:
f010099c:	89 d1                	mov    %edx,%ecx
f010099e:	c1 e9 16             	shr    $0x16,%ecx
f01009a1:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f01009a4:	a8 01                	test   $0x1,%al
f01009a6:	74 48                	je     f01009f0 <check_va2pa+0x54>
f01009a8:	89 c1                	mov    %eax,%ecx
f01009aa:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01009b0:	c1 e8 0c             	shr    $0xc,%eax
f01009b3:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f01009b9:	73 1a                	jae    f01009d5 <check_va2pa+0x39>
f01009bb:	c1 ea 0c             	shr    $0xc,%edx
f01009be:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01009c4:	8b 84 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%eax
f01009cb:	a8 01                	test   $0x1,%al
f01009cd:	74 27                	je     f01009f6 <check_va2pa+0x5a>
f01009cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01009d4:	c3                   	ret    
f01009d5:	55                   	push   %ebp
f01009d6:	89 e5                	mov    %esp,%ebp
f01009d8:	83 ec 08             	sub    $0x8,%esp
f01009db:	51                   	push   %ecx
f01009dc:	68 ec 41 10 f0       	push   $0xf01041ec
f01009e1:	68 1a 03 00 00       	push   $0x31a
f01009e6:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01009eb:	e8 48 f7 ff ff       	call   f0100138 <_panic>
f01009f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01009f5:	c3                   	ret    
f01009f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01009fb:	c3                   	ret    

f01009fc <check_page_free_list>:
f01009fc:	55                   	push   %ebp
f01009fd:	89 e5                	mov    %esp,%ebp
f01009ff:	57                   	push   %edi
f0100a00:	56                   	push   %esi
f0100a01:	53                   	push   %ebx
f0100a02:	83 ec 2c             	sub    $0x2c,%esp
f0100a05:	84 c0                	test   %al,%al
f0100a07:	0f 85 86 02 00 00    	jne    f0100c93 <check_page_free_list+0x297>
f0100a0d:	83 3d 6c 85 11 f0 00 	cmpl   $0x0,0xf011856c
f0100a14:	74 0a                	je     f0100a20 <check_page_free_list+0x24>
f0100a16:	be 00 04 00 00       	mov    $0x400,%esi
f0100a1b:	e9 e9 02 00 00       	jmp    f0100d09 <check_page_free_list+0x30d>
f0100a20:	83 ec 04             	sub    $0x4,%esp
f0100a23:	68 10 42 10 f0       	push   $0xf0104210
f0100a28:	68 54 02 00 00       	push   $0x254
f0100a2d:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100a32:	e8 01 f7 ff ff       	call   f0100138 <_panic>
f0100a37:	50                   	push   %eax
f0100a38:	68 ec 41 10 f0       	push   $0xf01041ec
f0100a3d:	6a 52                	push   $0x52
f0100a3f:	68 06 4c 10 f0       	push   $0xf0104c06
f0100a44:	e8 ef f6 ff ff       	call   f0100138 <_panic>
f0100a49:	8b 1b                	mov    (%ebx),%ebx
f0100a4b:	85 db                	test   %ebx,%ebx
f0100a4d:	74 41                	je     f0100a90 <check_page_free_list+0x94>
f0100a4f:	89 d8                	mov    %ebx,%eax
f0100a51:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0100a57:	c1 f8 03             	sar    $0x3,%eax
f0100a5a:	c1 e0 0c             	shl    $0xc,%eax
f0100a5d:	89 c2                	mov    %eax,%edx
f0100a5f:	c1 ea 16             	shr    $0x16,%edx
f0100a62:	39 f2                	cmp    %esi,%edx
f0100a64:	73 e3                	jae    f0100a49 <check_page_free_list+0x4d>
f0100a66:	89 c2                	mov    %eax,%edx
f0100a68:	c1 ea 0c             	shr    $0xc,%edx
f0100a6b:	3b 15 60 85 11 f0    	cmp    0xf0118560,%edx
f0100a71:	73 c4                	jae    f0100a37 <check_page_free_list+0x3b>
f0100a73:	83 ec 04             	sub    $0x4,%esp
f0100a76:	68 80 00 00 00       	push   $0x80
f0100a7b:	68 97 00 00 00       	push   $0x97
f0100a80:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100a85:	50                   	push   %eax
f0100a86:	e8 13 2c 00 00       	call   f010369e <memset>
f0100a8b:	83 c4 10             	add    $0x10,%esp
f0100a8e:	eb b9                	jmp    f0100a49 <check_page_free_list+0x4d>
f0100a90:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a95:	e8 a9 fe ff ff       	call   f0100943 <boot_alloc>
f0100a9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100a9d:	83 ec 08             	sub    $0x8,%esp
f0100aa0:	50                   	push   %eax
f0100aa1:	68 14 4c 10 f0       	push   $0xf0104c14
f0100aa6:	e8 88 20 00 00       	call   f0102b33 <cprintf>
f0100aab:	8b 15 6c 85 11 f0    	mov    0xf011856c,%edx
f0100ab1:	8b 0d 58 85 11 f0    	mov    0xf0118558,%ecx
f0100ab7:	a1 60 85 11 f0       	mov    0xf0118560,%eax
f0100abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100abf:	8d 3c c1             	lea    (%ecx,%eax,8),%edi
f0100ac2:	83 c4 10             	add    $0x10,%esp
f0100ac5:	be 00 00 00 00       	mov    $0x0,%esi
f0100aca:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0100acd:	e9 c8 00 00 00       	jmp    f0100b9a <check_page_free_list+0x19e>
f0100ad2:	68 2a 4c 10 f0       	push   $0xf0104c2a
f0100ad7:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100adc:	68 75 02 00 00       	push   $0x275
f0100ae1:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100ae6:	e8 4d f6 ff ff       	call   f0100138 <_panic>
f0100aeb:	68 36 4c 10 f0       	push   $0xf0104c36
f0100af0:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100af5:	68 76 02 00 00       	push   $0x276
f0100afa:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100aff:	e8 34 f6 ff ff       	call   f0100138 <_panic>
f0100b04:	68 80 42 10 f0       	push   $0xf0104280
f0100b09:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100b0e:	68 77 02 00 00       	push   $0x277
f0100b13:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100b18:	e8 1b f6 ff ff       	call   f0100138 <_panic>
f0100b1d:	68 4a 4c 10 f0       	push   $0xf0104c4a
f0100b22:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100b27:	68 7a 02 00 00       	push   $0x27a
f0100b2c:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100b31:	e8 02 f6 ff ff       	call   f0100138 <_panic>
f0100b36:	68 5b 4c 10 f0       	push   $0xf0104c5b
f0100b3b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100b40:	68 7b 02 00 00       	push   $0x27b
f0100b45:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100b4a:	e8 e9 f5 ff ff       	call   f0100138 <_panic>
f0100b4f:	68 b4 42 10 f0       	push   $0xf01042b4
f0100b54:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100b59:	68 7c 02 00 00       	push   $0x27c
f0100b5e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100b63:	e8 d0 f5 ff ff       	call   f0100138 <_panic>
f0100b68:	68 74 4c 10 f0       	push   $0xf0104c74
f0100b6d:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100b72:	68 7d 02 00 00       	push   $0x27d
f0100b77:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100b7c:	e8 b7 f5 ff ff       	call   f0100138 <_panic>
f0100b81:	89 c3                	mov    %eax,%ebx
f0100b83:	c1 eb 0c             	shr    $0xc,%ebx
f0100b86:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100b89:	76 62                	jbe    f0100bed <check_page_free_list+0x1f1>
f0100b8b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100b90:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100b93:	77 6a                	ja     f0100bff <check_page_free_list+0x203>
f0100b95:	ff 45 d4             	incl   -0x2c(%ebp)
f0100b98:	8b 12                	mov    (%edx),%edx
f0100b9a:	85 d2                	test   %edx,%edx
f0100b9c:	74 7a                	je     f0100c18 <check_page_free_list+0x21c>
f0100b9e:	39 d1                	cmp    %edx,%ecx
f0100ba0:	0f 87 2c ff ff ff    	ja     f0100ad2 <check_page_free_list+0xd6>
f0100ba6:	39 d7                	cmp    %edx,%edi
f0100ba8:	0f 86 3d ff ff ff    	jbe    f0100aeb <check_page_free_list+0xef>
f0100bae:	89 d0                	mov    %edx,%eax
f0100bb0:	29 c8                	sub    %ecx,%eax
f0100bb2:	a8 07                	test   $0x7,%al
f0100bb4:	0f 85 4a ff ff ff    	jne    f0100b04 <check_page_free_list+0x108>
f0100bba:	c1 f8 03             	sar    $0x3,%eax
f0100bbd:	c1 e0 0c             	shl    $0xc,%eax
f0100bc0:	0f 84 57 ff ff ff    	je     f0100b1d <check_page_free_list+0x121>
f0100bc6:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100bcb:	0f 84 65 ff ff ff    	je     f0100b36 <check_page_free_list+0x13a>
f0100bd1:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100bd6:	0f 84 73 ff ff ff    	je     f0100b4f <check_page_free_list+0x153>
f0100bdc:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100be1:	74 85                	je     f0100b68 <check_page_free_list+0x16c>
f0100be3:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100be8:	77 97                	ja     f0100b81 <check_page_free_list+0x185>
f0100bea:	46                   	inc    %esi
f0100beb:	eb ab                	jmp    f0100b98 <check_page_free_list+0x19c>
f0100bed:	50                   	push   %eax
f0100bee:	68 ec 41 10 f0       	push   $0xf01041ec
f0100bf3:	6a 52                	push   $0x52
f0100bf5:	68 06 4c 10 f0       	push   $0xf0104c06
f0100bfa:	e8 39 f5 ff ff       	call   f0100138 <_panic>
f0100bff:	68 d8 42 10 f0       	push   $0xf01042d8
f0100c04:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100c09:	68 7e 02 00 00       	push   $0x27e
f0100c0e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100c13:	e8 20 f5 ff ff       	call   f0100138 <_panic>
f0100c18:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c1b:	83 ec 04             	sub    $0x4,%esp
f0100c1e:	53                   	push   %ebx
f0100c1f:	56                   	push   %esi
f0100c20:	68 20 43 10 f0       	push   $0xf0104320
f0100c25:	e8 09 1f 00 00       	call   f0102b33 <cprintf>
f0100c2a:	83 c4 08             	add    $0x8,%esp
f0100c2d:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100c32:	29 f0                	sub    %esi,%eax
f0100c34:	29 d8                	sub    %ebx,%eax
f0100c36:	50                   	push   %eax
f0100c37:	68 48 43 10 f0       	push   $0xf0104348
f0100c3c:	e8 f2 1e 00 00       	call   f0102b33 <cprintf>
f0100c41:	83 c4 10             	add    $0x10,%esp
f0100c44:	85 f6                	test   %esi,%esi
f0100c46:	7e 19                	jle    f0100c61 <check_page_free_list+0x265>
f0100c48:	85 db                	test   %ebx,%ebx
f0100c4a:	7e 2e                	jle    f0100c7a <check_page_free_list+0x27e>
f0100c4c:	83 ec 0c             	sub    $0xc,%esp
f0100c4f:	68 6c 43 10 f0       	push   $0xf010436c
f0100c54:	e8 da 1e 00 00       	call   f0102b33 <cprintf>
f0100c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c5c:	5b                   	pop    %ebx
f0100c5d:	5e                   	pop    %esi
f0100c5e:	5f                   	pop    %edi
f0100c5f:	5d                   	pop    %ebp
f0100c60:	c3                   	ret    
f0100c61:	68 8e 4c 10 f0       	push   $0xf0104c8e
f0100c66:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100c6b:	68 8a 02 00 00       	push   $0x28a
f0100c70:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100c75:	e8 be f4 ff ff       	call   f0100138 <_panic>
f0100c7a:	68 a0 4c 10 f0       	push   $0xf0104ca0
f0100c7f:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100c84:	68 8b 02 00 00       	push   $0x28b
f0100c89:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100c8e:	e8 a5 f4 ff ff       	call   f0100138 <_panic>
f0100c93:	a1 6c 85 11 f0       	mov    0xf011856c,%eax
f0100c98:	85 c0                	test   %eax,%eax
f0100c9a:	0f 84 80 fd ff ff    	je     f0100a20 <check_page_free_list+0x24>
f0100ca0:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100ca3:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100ca6:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100ca9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100cac:	89 c2                	mov    %eax,%edx
f0100cae:	2b 15 58 85 11 f0    	sub    0xf0118558,%edx
f0100cb4:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100cba:	0f 95 c2             	setne  %dl
f0100cbd:	0f b6 d2             	movzbl %dl,%edx
f0100cc0:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100cc4:	89 01                	mov    %eax,(%ecx)
f0100cc6:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
f0100cca:	8b 00                	mov    (%eax),%eax
f0100ccc:	85 c0                	test   %eax,%eax
f0100cce:	75 dc                	jne    f0100cac <check_page_free_list+0x2b0>
f0100cd0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100cd3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100cd6:	56                   	push   %esi
f0100cd7:	53                   	push   %ebx
f0100cd8:	ff 33                	push   (%ebx)
f0100cda:	ff 36                	push   (%esi)
f0100cdc:	ff 75 dc             	push   -0x24(%ebp)
f0100cdf:	ff 75 d8             	push   -0x28(%ebp)
f0100ce2:	6a 00                	push   $0x0
f0100ce4:	68 34 42 10 f0       	push   $0xf0104234
f0100ce9:	e8 45 1e 00 00       	call   f0102b33 <cprintf>
f0100cee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
f0100cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100cf7:	89 03                	mov    %eax,(%ebx)
f0100cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100cfc:	a3 6c 85 11 f0       	mov    %eax,0xf011856c
f0100d01:	83 c4 20             	add    $0x20,%esp
f0100d04:	be 01 00 00 00       	mov    $0x1,%esi
f0100d09:	8b 1d 6c 85 11 f0    	mov    0xf011856c,%ebx
f0100d0f:	e9 37 fd ff ff       	jmp    f0100a4b <check_page_free_list+0x4f>

f0100d14 <page_init>:
f0100d14:	55                   	push   %ebp
f0100d15:	89 e5                	mov    %esp,%ebp
f0100d17:	57                   	push   %edi
f0100d18:	56                   	push   %esi
f0100d19:	53                   	push   %ebx
f0100d1a:	83 ec 1c             	sub    $0x1c,%esp
f0100d1d:	8b 35 70 85 11 f0    	mov    0xf0118570,%esi
f0100d23:	89 f2                	mov    %esi,%edx
f0100d25:	c1 e2 0c             	shl    $0xc,%edx
f0100d28:	8b 0d 58 85 11 f0    	mov    0xf0118558,%ecx
f0100d2e:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100d34:	76 6b                	jbe    f0100da1 <page_init+0x8d>
f0100d36:	a1 60 85 11 f0       	mov    0xf0118560,%eax
f0100d3b:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100d42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d47:	8d bc 01 00 00 00 10 	lea    0x10000000(%ecx,%eax,1),%edi
f0100d4e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0100d51:	a1 68 85 11 f0       	mov    0xf0118568,%eax
f0100d56:	c1 e0 0a             	shl    $0xa,%eax
f0100d59:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100d5c:	83 ec 0c             	sub    $0xc,%esp
f0100d5f:	50                   	push   %eax
f0100d60:	57                   	push   %edi
f0100d61:	52                   	push   %edx
f0100d62:	68 00 10 00 00       	push   $0x1000
f0100d67:	68 b4 43 10 f0       	push   $0xf01043b4
f0100d6c:	e8 c2 1d 00 00       	call   f0102b33 <cprintf>
f0100d71:	83 c4 18             	add    $0x18,%esp
f0100d74:	ff 35 6c 85 11 f0    	push   0xf011856c
f0100d7a:	68 b1 4c 10 f0       	push   $0xf0104cb1
f0100d7f:	e8 af 1d 00 00       	call   f0102b33 <cprintf>
f0100d84:	8b 1d 6c 85 11 f0    	mov    0xf011856c,%ebx
f0100d8a:	83 c4 10             	add    $0x10,%esp
f0100d8d:	b2 00                	mov    $0x0,%dl
f0100d8f:	b8 01 00 00 00       	mov    $0x1,%eax
f0100d94:	81 e6 ff ff 0f 00    	and    $0xfffff,%esi
f0100d9a:	bf 01 00 00 00       	mov    $0x1,%edi
f0100d9f:	eb 37                	jmp    f0100dd8 <page_init+0xc4>
f0100da1:	51                   	push   %ecx
f0100da2:	68 90 43 10 f0       	push   $0xf0104390
f0100da7:	68 12 01 00 00       	push   $0x112
f0100dac:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100db1:	e8 82 f3 ff ff       	call   f0100138 <_panic>
f0100db6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100dbd:	89 d1                	mov    %edx,%ecx
f0100dbf:	03 0d 58 85 11 f0    	add    0xf0118558,%ecx
f0100dc5:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100dcb:	89 19                	mov    %ebx,(%ecx)
f0100dcd:	89 d3                	mov    %edx,%ebx
f0100dcf:	03 1d 58 85 11 f0    	add    0xf0118558,%ebx
f0100dd5:	40                   	inc    %eax
f0100dd6:	89 fa                	mov    %edi,%edx
f0100dd8:	39 c6                	cmp    %eax,%esi
f0100dda:	77 da                	ja     f0100db6 <page_init+0xa2>
f0100ddc:	84 d2                	test   %dl,%dl
f0100dde:	74 06                	je     f0100de6 <page_init+0xd2>
f0100de0:	89 1d 6c 85 11 f0    	mov    %ebx,0xf011856c
f0100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100de9:	c1 e8 0c             	shr    $0xc,%eax
f0100dec:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100def:	c1 ee 0c             	shr    $0xc,%esi
f0100df2:	8b 1d 6c 85 11 f0    	mov    0xf011856c,%ebx
f0100df8:	b2 00                	mov    $0x0,%dl
f0100dfa:	bf 01 00 00 00       	mov    $0x1,%edi
f0100dff:	eb 22                	jmp    f0100e23 <page_init+0x10f>
f0100e01:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100e08:	89 d1                	mov    %edx,%ecx
f0100e0a:	03 0d 58 85 11 f0    	add    0xf0118558,%ecx
f0100e10:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100e16:	89 19                	mov    %ebx,(%ecx)
f0100e18:	89 d3                	mov    %edx,%ebx
f0100e1a:	03 1d 58 85 11 f0    	add    0xf0118558,%ebx
f0100e20:	40                   	inc    %eax
f0100e21:	89 fa                	mov    %edi,%edx
f0100e23:	39 c6                	cmp    %eax,%esi
f0100e25:	77 da                	ja     f0100e01 <page_init+0xed>
f0100e27:	84 d2                	test   %dl,%dl
f0100e29:	74 06                	je     f0100e31 <page_init+0x11d>
f0100e2b:	89 1d 6c 85 11 f0    	mov    %ebx,0xf011856c
f0100e31:	a1 6c 85 11 f0       	mov    0xf011856c,%eax
f0100e36:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e3b:	76 2c                	jbe    f0100e69 <page_init+0x155>
f0100e3d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100e43:	83 ec 0c             	sub    $0xc,%esp
f0100e46:	89 d1                	mov    %edx,%ecx
f0100e48:	c1 e9 0c             	shr    $0xc,%ecx
f0100e4b:	51                   	push   %ecx
f0100e4c:	52                   	push   %edx
f0100e4d:	89 c2                	mov    %eax,%edx
f0100e4f:	c1 ea 16             	shr    $0x16,%edx
f0100e52:	52                   	push   %edx
f0100e53:	50                   	push   %eax
f0100e54:	68 cc 4c 10 f0       	push   $0xf0104ccc
f0100e59:	e8 e9 1c 00 00       	call   f0102b47 <memCprintf>
f0100e5e:	83 c4 20             	add    $0x20,%esp
f0100e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e64:	5b                   	pop    %ebx
f0100e65:	5e                   	pop    %esi
f0100e66:	5f                   	pop    %edi
f0100e67:	5d                   	pop    %ebp
f0100e68:	c3                   	ret    
f0100e69:	50                   	push   %eax
f0100e6a:	68 90 43 10 f0       	push   $0xf0104390
f0100e6f:	68 28 01 00 00       	push   $0x128
f0100e74:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100e79:	e8 ba f2 ff ff       	call   f0100138 <_panic>

f0100e7e <page_alloc>:
f0100e7e:	55                   	push   %ebp
f0100e7f:	89 e5                	mov    %esp,%ebp
f0100e81:	53                   	push   %ebx
f0100e82:	83 ec 04             	sub    $0x4,%esp
f0100e85:	8b 1d 6c 85 11 f0    	mov    0xf011856c,%ebx
f0100e8b:	85 db                	test   %ebx,%ebx
f0100e8d:	74 19                	je     f0100ea8 <page_alloc+0x2a>
f0100e8f:	8b 03                	mov    (%ebx),%eax
f0100e91:	a3 6c 85 11 f0       	mov    %eax,0xf011856c
f0100e96:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
f0100e9c:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
f0100ea2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100ea6:	75 07                	jne    f0100eaf <page_alloc+0x31>
f0100ea8:	89 d8                	mov    %ebx,%eax
f0100eaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ead:	c9                   	leave  
f0100eae:	c3                   	ret    
f0100eaf:	89 d8                	mov    %ebx,%eax
f0100eb1:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0100eb7:	c1 f8 03             	sar    $0x3,%eax
f0100eba:	89 c2                	mov    %eax,%edx
f0100ebc:	c1 e2 0c             	shl    $0xc,%edx
f0100ebf:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0100ec4:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f0100eca:	73 1b                	jae    f0100ee7 <page_alloc+0x69>
f0100ecc:	83 ec 04             	sub    $0x4,%esp
f0100ecf:	68 00 10 00 00       	push   $0x1000
f0100ed4:	6a 00                	push   $0x0
f0100ed6:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0100edc:	52                   	push   %edx
f0100edd:	e8 bc 27 00 00       	call   f010369e <memset>
f0100ee2:	83 c4 10             	add    $0x10,%esp
f0100ee5:	eb c1                	jmp    f0100ea8 <page_alloc+0x2a>
f0100ee7:	52                   	push   %edx
f0100ee8:	68 ec 41 10 f0       	push   $0xf01041ec
f0100eed:	6a 52                	push   $0x52
f0100eef:	68 06 4c 10 f0       	push   $0xf0104c06
f0100ef4:	e8 3f f2 ff ff       	call   f0100138 <_panic>

f0100ef9 <page_free>:
f0100ef9:	55                   	push   %ebp
f0100efa:	89 e5                	mov    %esp,%ebp
f0100efc:	83 ec 08             	sub    $0x8,%esp
f0100eff:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f02:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0100f07:	75 14                	jne    f0100f1d <page_free+0x24>
f0100f09:	83 38 00             	cmpl   $0x0,(%eax)
f0100f0c:	75 28                	jne    f0100f36 <page_free+0x3d>
f0100f0e:	8b 15 6c 85 11 f0    	mov    0xf011856c,%edx
f0100f14:	89 10                	mov    %edx,(%eax)
f0100f16:	a3 6c 85 11 f0       	mov    %eax,0xf011856c
f0100f1b:	c9                   	leave  
f0100f1c:	c3                   	ret    
f0100f1d:	68 db 4c 10 f0       	push   $0xf0104cdb
f0100f22:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100f27:	68 4f 01 00 00       	push   $0x14f
f0100f2c:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100f31:	e8 02 f2 ff ff       	call   f0100138 <_panic>
f0100f36:	68 e7 4c 10 f0       	push   $0xf0104ce7
f0100f3b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0100f40:	68 50 01 00 00       	push   $0x150
f0100f45:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0100f4a:	e8 e9 f1 ff ff       	call   f0100138 <_panic>

f0100f4f <page_decref>:
f0100f4f:	55                   	push   %ebp
f0100f50:	89 e5                	mov    %esp,%ebp
f0100f52:	83 ec 08             	sub    $0x8,%esp
f0100f55:	8b 55 08             	mov    0x8(%ebp),%edx
f0100f58:	8b 42 04             	mov    0x4(%edx),%eax
f0100f5b:	48                   	dec    %eax
f0100f5c:	66 89 42 04          	mov    %ax,0x4(%edx)
f0100f60:	66 85 c0             	test   %ax,%ax
f0100f63:	74 02                	je     f0100f67 <page_decref+0x18>
f0100f65:	c9                   	leave  
f0100f66:	c3                   	ret    
f0100f67:	83 ec 0c             	sub    $0xc,%esp
f0100f6a:	52                   	push   %edx
f0100f6b:	e8 89 ff ff ff       	call   f0100ef9 <page_free>
f0100f70:	83 c4 10             	add    $0x10,%esp
f0100f73:	eb f0                	jmp    f0100f65 <page_decref+0x16>

f0100f75 <pgdir_walk>:
f0100f75:	55                   	push   %ebp
f0100f76:	89 e5                	mov    %esp,%ebp
f0100f78:	57                   	push   %edi
f0100f79:	56                   	push   %esi
f0100f7a:	53                   	push   %ebx
f0100f7b:	83 ec 0c             	sub    $0xc,%esp
f0100f7e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0100f81:	8b 75 0c             	mov    0xc(%ebp),%esi
f0100f84:	c1 ee 16             	shr    $0x16,%esi
f0100f87:	c1 e6 02             	shl    $0x2,%esi
f0100f8a:	03 75 08             	add    0x8(%ebp),%esi
f0100f8d:	8b 1e                	mov    (%esi),%ebx
f0100f8f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0100f95:	75 32                	jne    f0100fc9 <pgdir_walk+0x54>
f0100f97:	85 ff                	test   %edi,%edi
f0100f99:	0f 84 9a 00 00 00    	je     f0101039 <pgdir_walk+0xc4>
f0100f9f:	83 ec 0c             	sub    $0xc,%esp
f0100fa2:	6a 01                	push   $0x1
f0100fa4:	e8 d5 fe ff ff       	call   f0100e7e <page_alloc>
f0100fa9:	89 c3                	mov    %eax,%ebx
f0100fab:	83 c4 10             	add    $0x10,%esp
f0100fae:	85 c0                	test   %eax,%eax
f0100fb0:	74 68                	je     f010101a <pgdir_walk+0xa5>
f0100fb2:	66 ff 40 04          	incw   0x4(%eax)
f0100fb6:	2b 1d 58 85 11 f0    	sub    0xf0118558,%ebx
f0100fbc:	c1 fb 03             	sar    $0x3,%ebx
f0100fbf:	c1 e3 0c             	shl    $0xc,%ebx
f0100fc2:	89 d8                	mov    %ebx,%eax
f0100fc4:	83 c8 01             	or     $0x1,%eax
f0100fc7:	89 06                	mov    %eax,(%esi)
f0100fc9:	89 d8                	mov    %ebx,%eax
f0100fcb:	c1 e8 0c             	shr    $0xc,%eax
f0100fce:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f0100fd4:	73 4e                	jae    f0101024 <pgdir_walk+0xaf>
f0100fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100fd9:	c1 e8 0a             	shr    $0xa,%eax
f0100fdc:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100fe1:	8d 9c 03 00 00 00 f0 	lea    -0x10000000(%ebx,%eax,1),%ebx
f0100fe8:	f7 03 00 f0 ff ff    	testl  $0xfffff000,(%ebx)
f0100fee:	75 2a                	jne    f010101a <pgdir_walk+0xa5>
f0100ff0:	85 ff                	test   %edi,%edi
f0100ff2:	74 4c                	je     f0101040 <pgdir_walk+0xcb>
f0100ff4:	83 ec 0c             	sub    $0xc,%esp
f0100ff7:	6a 01                	push   $0x1
f0100ff9:	e8 80 fe ff ff       	call   f0100e7e <page_alloc>
f0100ffe:	83 c4 10             	add    $0x10,%esp
f0101001:	85 c0                	test   %eax,%eax
f0101003:	74 15                	je     f010101a <pgdir_walk+0xa5>
f0101005:	66 ff 40 04          	incw   0x4(%eax)
f0101009:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f010100f:	c1 f8 03             	sar    $0x3,%eax
f0101012:	c1 e0 0c             	shl    $0xc,%eax
f0101015:	83 c8 01             	or     $0x1,%eax
f0101018:	89 03                	mov    %eax,(%ebx)
f010101a:	89 d8                	mov    %ebx,%eax
f010101c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010101f:	5b                   	pop    %ebx
f0101020:	5e                   	pop    %esi
f0101021:	5f                   	pop    %edi
f0101022:	5d                   	pop    %ebp
f0101023:	c3                   	ret    
f0101024:	53                   	push   %ebx
f0101025:	68 ec 41 10 f0       	push   $0xf01041ec
f010102a:	68 94 01 00 00       	push   $0x194
f010102f:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101034:	e8 ff f0 ff ff       	call   f0100138 <_panic>
f0101039:	bb 00 00 00 00       	mov    $0x0,%ebx
f010103e:	eb da                	jmp    f010101a <pgdir_walk+0xa5>
f0101040:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101045:	eb d3                	jmp    f010101a <pgdir_walk+0xa5>

f0101047 <page_lookup>:
f0101047:	55                   	push   %ebp
f0101048:	89 e5                	mov    %esp,%ebp
f010104a:	53                   	push   %ebx
f010104b:	83 ec 08             	sub    $0x8,%esp
f010104e:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101051:	6a 00                	push   $0x0
f0101053:	ff 75 0c             	push   0xc(%ebp)
f0101056:	ff 75 08             	push   0x8(%ebp)
f0101059:	e8 17 ff ff ff       	call   f0100f75 <pgdir_walk>
f010105e:	83 c4 10             	add    $0x10,%esp
f0101061:	85 c0                	test   %eax,%eax
f0101063:	74 1c                	je     f0101081 <page_lookup+0x3a>
f0101065:	85 db                	test   %ebx,%ebx
f0101067:	74 02                	je     f010106b <page_lookup+0x24>
f0101069:	89 03                	mov    %eax,(%ebx)
f010106b:	8b 00                	mov    (%eax),%eax
f010106d:	c1 e8 0c             	shr    $0xc,%eax
f0101070:	39 05 60 85 11 f0    	cmp    %eax,0xf0118560
f0101076:	76 0e                	jbe    f0101086 <page_lookup+0x3f>
f0101078:	8b 15 58 85 11 f0    	mov    0xf0118558,%edx
f010107e:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0101081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101084:	c9                   	leave  
f0101085:	c3                   	ret    
f0101086:	83 ec 04             	sub    $0x4,%esp
f0101089:	68 e8 43 10 f0       	push   $0xf01043e8
f010108e:	6a 4b                	push   $0x4b
f0101090:	68 06 4c 10 f0       	push   $0xf0104c06
f0101095:	e8 9e f0 ff ff       	call   f0100138 <_panic>

f010109a <page_remove>:
f010109a:	55                   	push   %ebp
f010109b:	89 e5                	mov    %esp,%ebp
f010109d:	53                   	push   %ebx
f010109e:	83 ec 18             	sub    $0x18,%esp
f01010a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01010a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01010a7:	50                   	push   %eax
f01010a8:	53                   	push   %ebx
f01010a9:	ff 75 08             	push   0x8(%ebp)
f01010ac:	e8 96 ff ff ff       	call   f0101047 <page_lookup>
f01010b1:	83 c4 10             	add    $0x10,%esp
f01010b4:	85 c0                	test   %eax,%eax
f01010b6:	74 1e                	je     f01010d6 <page_remove+0x3c>
f01010b8:	83 ec 0c             	sub    $0xc,%esp
f01010bb:	50                   	push   %eax
f01010bc:	e8 8e fe ff ff       	call   f0100f4f <page_decref>
f01010c1:	83 c4 0c             	add    $0xc,%esp
f01010c4:	6a 04                	push   $0x4
f01010c6:	6a 00                	push   $0x0
f01010c8:	ff 75 f4             	push   -0xc(%ebp)
f01010cb:	e8 ce 25 00 00       	call   f010369e <memset>
f01010d0:	0f 01 3b             	invlpg (%ebx)
f01010d3:	83 c4 10             	add    $0x10,%esp
f01010d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01010d9:	c9                   	leave  
f01010da:	c3                   	ret    

f01010db <page_insert>:
f01010db:	55                   	push   %ebp
f01010dc:	89 e5                	mov    %esp,%ebp
f01010de:	57                   	push   %edi
f01010df:	56                   	push   %esi
f01010e0:	53                   	push   %ebx
f01010e1:	83 ec 20             	sub    $0x20,%esp
f01010e4:	8b 7d 08             	mov    0x8(%ebp),%edi
f01010e7:	8b 75 0c             	mov    0xc(%ebp),%esi
f01010ea:	6a 00                	push   $0x0
f01010ec:	ff 75 10             	push   0x10(%ebp)
f01010ef:	57                   	push   %edi
f01010f0:	e8 80 fe ff ff       	call   f0100f75 <pgdir_walk>
f01010f5:	89 c3                	mov    %eax,%ebx
f01010f7:	83 c4 10             	add    $0x10,%esp
f01010fa:	85 c0                	test   %eax,%eax
f01010fc:	74 42                	je     f0101140 <page_insert+0x65>
f01010fe:	8b 00                	mov    (%eax),%eax
f0101100:	c1 e8 0c             	shr    $0xc,%eax
f0101103:	39 05 60 85 11 f0    	cmp    %eax,0xf0118560
f0101109:	76 21                	jbe    f010112c <page_insert+0x51>
f010110b:	8b 15 58 85 11 f0    	mov    0xf0118558,%edx
f0101111:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0101114:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101117:	39 c6                	cmp    %eax,%esi
f0101119:	74 28                	je     f0101143 <page_insert+0x68>
f010111b:	83 ec 08             	sub    $0x8,%esp
f010111e:	ff 75 10             	push   0x10(%ebp)
f0101121:	57                   	push   %edi
f0101122:	e8 73 ff ff ff       	call   f010109a <page_remove>
f0101127:	83 c4 10             	add    $0x10,%esp
f010112a:	eb 17                	jmp    f0101143 <page_insert+0x68>
f010112c:	83 ec 04             	sub    $0x4,%esp
f010112f:	68 e8 43 10 f0       	push   $0xf01043e8
f0101134:	6a 4b                	push   $0x4b
f0101136:	68 06 4c 10 f0       	push   $0xf0104c06
f010113b:	e8 f8 ef ff ff       	call   f0100138 <_panic>
f0101140:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101143:	8b 45 10             	mov    0x10(%ebp),%eax
f0101146:	c1 e8 16             	shr    $0x16,%eax
f0101149:	8d 3c 87             	lea    (%edi,%eax,4),%edi
f010114c:	8b 07                	mov    (%edi),%eax
f010114e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101153:	75 2f                	jne    f0101184 <page_insert+0xa9>
f0101155:	83 ec 0c             	sub    $0xc,%esp
f0101158:	6a 01                	push   $0x1
f010115a:	e8 1f fd ff ff       	call   f0100e7e <page_alloc>
f010115f:	83 c4 10             	add    $0x10,%esp
f0101162:	85 c0                	test   %eax,%eax
f0101164:	0f 84 85 00 00 00    	je     f01011ef <page_insert+0x114>
f010116a:	66 ff 40 04          	incw   0x4(%eax)
f010116e:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101174:	c1 f8 03             	sar    $0x3,%eax
f0101177:	c1 e0 0c             	shl    $0xc,%eax
f010117a:	89 c2                	mov    %eax,%edx
f010117c:	0b 55 14             	or     0x14(%ebp),%edx
f010117f:	83 ca 01             	or     $0x1,%edx
f0101182:	89 17                	mov    %edx,(%edi)
f0101184:	89 f2                	mov    %esi,%edx
f0101186:	2b 15 58 85 11 f0    	sub    0xf0118558,%edx
f010118c:	c1 fa 03             	sar    $0x3,%edx
f010118f:	c1 e2 0c             	shl    $0xc,%edx
f0101192:	0b 55 14             	or     0x14(%ebp),%edx
f0101195:	89 c1                	mov    %eax,%ecx
f0101197:	c1 e9 0c             	shr    $0xc,%ecx
f010119a:	3b 0d 60 85 11 f0    	cmp    0xf0118560,%ecx
f01011a0:	73 38                	jae    f01011da <page_insert+0xff>
f01011a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01011a5:	c1 e9 0c             	shr    $0xc,%ecx
f01011a8:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f01011ae:	83 ca 01             	or     $0x1,%edx
f01011b1:	89 94 88 00 00 00 f0 	mov    %edx,-0x10000000(%eax,%ecx,4)
f01011b8:	0b 45 14             	or     0x14(%ebp),%eax
f01011bb:	83 c8 01             	or     $0x1,%eax
f01011be:	89 07                	mov    %eax,(%edi)
f01011c0:	85 db                	test   %ebx,%ebx
f01011c2:	74 05                	je     f01011c9 <page_insert+0xee>
f01011c4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f01011c7:	74 2d                	je     f01011f6 <page_insert+0x11b>
f01011c9:	66 ff 46 04          	incw   0x4(%esi)
f01011cd:	b8 00 00 00 00       	mov    $0x0,%eax
f01011d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011d5:	5b                   	pop    %ebx
f01011d6:	5e                   	pop    %esi
f01011d7:	5f                   	pop    %edi
f01011d8:	5d                   	pop    %ebp
f01011d9:	c3                   	ret    
f01011da:	50                   	push   %eax
f01011db:	68 ec 41 10 f0       	push   $0xf01041ec
f01011e0:	68 f7 01 00 00       	push   $0x1f7
f01011e5:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01011ea:	e8 49 ef ff ff       	call   f0100138 <_panic>
f01011ef:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01011f4:	eb dc                	jmp    f01011d2 <page_insert+0xf7>
f01011f6:	b8 00 00 00 00       	mov    $0x0,%eax
f01011fb:	eb d5                	jmp    f01011d2 <page_insert+0xf7>

f01011fd <mem_init>:
f01011fd:	55                   	push   %ebp
f01011fe:	89 e5                	mov    %esp,%ebp
f0101200:	57                   	push   %edi
f0101201:	56                   	push   %esi
f0101202:	53                   	push   %ebx
f0101203:	83 ec 2c             	sub    $0x2c,%esp
f0101206:	b8 15 00 00 00       	mov    $0x15,%eax
f010120b:	e8 0c f7 ff ff       	call   f010091c <nvram_read>
f0101210:	89 c6                	mov    %eax,%esi
f0101212:	b8 17 00 00 00       	mov    $0x17,%eax
f0101217:	e8 00 f7 ff ff       	call   f010091c <nvram_read>
f010121c:	89 c3                	mov    %eax,%ebx
f010121e:	b8 34 00 00 00       	mov    $0x34,%eax
f0101223:	e8 f4 f6 ff ff       	call   f010091c <nvram_read>
f0101228:	c1 e0 06             	shl    $0x6,%eax
f010122b:	0f 84 bb 01 00 00    	je     f01013ec <mem_init+0x1ef>
f0101231:	05 00 40 00 00       	add    $0x4000,%eax
f0101236:	a3 68 85 11 f0       	mov    %eax,0xf0118568
f010123b:	89 c2                	mov    %eax,%edx
f010123d:	c1 ea 02             	shr    $0x2,%edx
f0101240:	89 15 60 85 11 f0    	mov    %edx,0xf0118560
f0101246:	89 f2                	mov    %esi,%edx
f0101248:	c1 ea 02             	shr    $0x2,%edx
f010124b:	89 15 70 85 11 f0    	mov    %edx,0xf0118570
f0101251:	89 c2                	mov    %eax,%edx
f0101253:	29 f2                	sub    %esi,%edx
f0101255:	52                   	push   %edx
f0101256:	56                   	push   %esi
f0101257:	50                   	push   %eax
f0101258:	68 08 44 10 f0       	push   $0xf0104408
f010125d:	e8 d1 18 00 00       	call   f0102b33 <cprintf>
f0101262:	83 c4 08             	add    $0x8,%esp
f0101265:	6a 02                	push   $0x2
f0101267:	68 f4 4c 10 f0       	push   $0xf0104cf4
f010126c:	e8 c2 18 00 00       	call   f0102b33 <cprintf>
f0101271:	83 c4 0c             	add    $0xc,%esp
f0101274:	6a 08                	push   $0x8
f0101276:	ff 35 60 85 11 f0    	push   0xf0118560
f010127c:	68 48 44 10 f0       	push   $0xf0104448
f0101281:	e8 ad 18 00 00       	call   f0102b33 <cprintf>
f0101286:	b8 00 10 00 00       	mov    $0x1000,%eax
f010128b:	e8 b3 f6 ff ff       	call   f0100943 <boot_alloc>
f0101290:	a3 5c 85 11 f0       	mov    %eax,0xf011855c
f0101295:	83 c4 10             	add    $0x10,%esp
f0101298:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010129d:	0f 86 5f 01 00 00    	jbe    f0101402 <mem_init+0x205>
f01012a3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01012a9:	83 ec 0c             	sub    $0xc,%esp
f01012ac:	89 d1                	mov    %edx,%ecx
f01012ae:	c1 e9 0c             	shr    $0xc,%ecx
f01012b1:	51                   	push   %ecx
f01012b2:	52                   	push   %edx
f01012b3:	89 c2                	mov    %eax,%edx
f01012b5:	c1 ea 16             	shr    $0x16,%edx
f01012b8:	52                   	push   %edx
f01012b9:	50                   	push   %eax
f01012ba:	68 0b 4d 10 f0       	push   $0xf0104d0b
f01012bf:	e8 83 18 00 00       	call   f0102b47 <memCprintf>
f01012c4:	83 c4 1c             	add    $0x1c,%esp
f01012c7:	68 00 10 00 00       	push   $0x1000
f01012cc:	6a 00                	push   $0x0
f01012ce:	ff 35 5c 85 11 f0    	push   0xf011855c
f01012d4:	e8 c5 23 00 00       	call   f010369e <memset>
f01012d9:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f01012de:	83 c4 10             	add    $0x10,%esp
f01012e1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01012e6:	0f 86 2b 01 00 00    	jbe    f0101417 <mem_init+0x21a>
f01012ec:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01012f2:	89 d1                	mov    %edx,%ecx
f01012f4:	83 c9 05             	or     $0x5,%ecx
f01012f7:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
f01012fd:	83 ec 0c             	sub    $0xc,%esp
f0101300:	89 d0                	mov    %edx,%eax
f0101302:	c1 e8 0c             	shr    $0xc,%eax
f0101305:	50                   	push   %eax
f0101306:	52                   	push   %edx
f0101307:	68 bd 03 00 00       	push   $0x3bd
f010130c:	68 00 00 40 ef       	push   $0xef400000
f0101311:	68 16 4d 10 f0       	push   $0xf0104d16
f0101316:	e8 2c 18 00 00       	call   f0102b47 <memCprintf>
f010131b:	83 c4 20             	add    $0x20,%esp
f010131e:	a1 60 85 11 f0       	mov    0xf0118560,%eax
f0101323:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010132a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010132f:	e8 0f f6 ff ff       	call   f0100943 <boot_alloc>
f0101334:	a3 58 85 11 f0       	mov    %eax,0xf0118558
f0101339:	83 ec 04             	sub    $0x4,%esp
f010133c:	8b 15 60 85 11 f0    	mov    0xf0118560,%edx
f0101342:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101349:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010134f:	52                   	push   %edx
f0101350:	6a 00                	push   $0x0
f0101352:	50                   	push   %eax
f0101353:	e8 46 23 00 00       	call   f010369e <memset>
f0101358:	83 c4 08             	add    $0x8,%esp
f010135b:	a1 60 85 11 f0       	mov    0xf0118560,%eax
f0101360:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0101367:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010136c:	c1 e8 0a             	shr    $0xa,%eax
f010136f:	50                   	push   %eax
f0101370:	68 1b 4d 10 f0       	push   $0xf0104d1b
f0101375:	e8 b9 17 00 00       	call   f0102b33 <cprintf>
f010137a:	a1 58 85 11 f0       	mov    0xf0118558,%eax
f010137f:	83 c4 10             	add    $0x10,%esp
f0101382:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101387:	0f 86 9f 00 00 00    	jbe    f010142c <mem_init+0x22f>
f010138d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101393:	83 ec 0c             	sub    $0xc,%esp
f0101396:	89 d1                	mov    %edx,%ecx
f0101398:	c1 e9 0c             	shr    $0xc,%ecx
f010139b:	51                   	push   %ecx
f010139c:	52                   	push   %edx
f010139d:	89 c2                	mov    %eax,%edx
f010139f:	c1 ea 16             	shr    $0x16,%edx
f01013a2:	52                   	push   %edx
f01013a3:	50                   	push   %eax
f01013a4:	68 30 4c 10 f0       	push   $0xf0104c30
f01013a9:	e8 99 17 00 00       	call   f0102b47 <memCprintf>
f01013ae:	83 c4 20             	add    $0x20,%esp
f01013b1:	e8 5e f9 ff ff       	call   f0100d14 <page_init>
f01013b6:	b8 01 00 00 00       	mov    $0x1,%eax
f01013bb:	e8 3c f6 ff ff       	call   f01009fc <check_page_free_list>
f01013c0:	83 ec 0c             	sub    $0xc,%esp
f01013c3:	68 74 44 10 f0       	push   $0xf0104474
f01013c8:	e8 66 17 00 00       	call   f0102b33 <cprintf>
f01013cd:	83 c4 10             	add    $0x10,%esp
f01013d0:	83 3d 58 85 11 f0 00 	cmpl   $0x0,0xf0118558
f01013d7:	74 68                	je     f0101441 <mem_init+0x244>
f01013d9:	a1 6c 85 11 f0       	mov    0xf011856c,%eax
f01013de:	bb 00 00 00 00       	mov    $0x0,%ebx
f01013e3:	85 c0                	test   %eax,%eax
f01013e5:	74 71                	je     f0101458 <mem_init+0x25b>
f01013e7:	43                   	inc    %ebx
f01013e8:	8b 00                	mov    (%eax),%eax
f01013ea:	eb f7                	jmp    f01013e3 <mem_init+0x1e6>
f01013ec:	85 db                	test   %ebx,%ebx
f01013ee:	74 0b                	je     f01013fb <mem_init+0x1fe>
f01013f0:	8d 83 00 04 00 00    	lea    0x400(%ebx),%eax
f01013f6:	e9 3b fe ff ff       	jmp    f0101236 <mem_init+0x39>
f01013fb:	89 f0                	mov    %esi,%eax
f01013fd:	e9 34 fe ff ff       	jmp    f0101236 <mem_init+0x39>
f0101402:	50                   	push   %eax
f0101403:	68 90 43 10 f0       	push   $0xf0104390
f0101408:	68 91 00 00 00       	push   $0x91
f010140d:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101412:	e8 21 ed ff ff       	call   f0100138 <_panic>
f0101417:	50                   	push   %eax
f0101418:	68 90 43 10 f0       	push   $0xf0104390
f010141d:	68 9b 00 00 00       	push   $0x9b
f0101422:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101427:	e8 0c ed ff ff       	call   f0100138 <_panic>
f010142c:	50                   	push   %eax
f010142d:	68 90 43 10 f0       	push   $0xf0104390
f0101432:	68 a8 00 00 00       	push   $0xa8
f0101437:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010143c:	e8 f7 ec ff ff       	call   f0100138 <_panic>
f0101441:	83 ec 04             	sub    $0x4,%esp
f0101444:	68 32 4d 10 f0       	push   $0xf0104d32
f0101449:	68 9c 02 00 00       	push   $0x29c
f010144e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101453:	e8 e0 ec ff ff       	call   f0100138 <_panic>
f0101458:	83 ec 0c             	sub    $0xc,%esp
f010145b:	6a 00                	push   $0x0
f010145d:	e8 1c fa ff ff       	call   f0100e7e <page_alloc>
f0101462:	89 c7                	mov    %eax,%edi
f0101464:	83 c4 10             	add    $0x10,%esp
f0101467:	85 c0                	test   %eax,%eax
f0101469:	0f 84 1b 02 00 00    	je     f010168a <mem_init+0x48d>
f010146f:	83 ec 0c             	sub    $0xc,%esp
f0101472:	6a 00                	push   $0x0
f0101474:	e8 05 fa ff ff       	call   f0100e7e <page_alloc>
f0101479:	89 c6                	mov    %eax,%esi
f010147b:	83 c4 10             	add    $0x10,%esp
f010147e:	85 c0                	test   %eax,%eax
f0101480:	0f 84 1d 02 00 00    	je     f01016a3 <mem_init+0x4a6>
f0101486:	83 ec 0c             	sub    $0xc,%esp
f0101489:	6a 00                	push   $0x0
f010148b:	e8 ee f9 ff ff       	call   f0100e7e <page_alloc>
f0101490:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101493:	83 c4 10             	add    $0x10,%esp
f0101496:	85 c0                	test   %eax,%eax
f0101498:	0f 84 1e 02 00 00    	je     f01016bc <mem_init+0x4bf>
f010149e:	39 f7                	cmp    %esi,%edi
f01014a0:	0f 84 2f 02 00 00    	je     f01016d5 <mem_init+0x4d8>
f01014a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014a9:	39 c6                	cmp    %eax,%esi
f01014ab:	0f 84 3d 02 00 00    	je     f01016ee <mem_init+0x4f1>
f01014b1:	39 c7                	cmp    %eax,%edi
f01014b3:	0f 84 35 02 00 00    	je     f01016ee <mem_init+0x4f1>
f01014b9:	8b 0d 58 85 11 f0    	mov    0xf0118558,%ecx
f01014bf:	8b 15 60 85 11 f0    	mov    0xf0118560,%edx
f01014c5:	c1 e2 0c             	shl    $0xc,%edx
f01014c8:	89 f8                	mov    %edi,%eax
f01014ca:	29 c8                	sub    %ecx,%eax
f01014cc:	c1 f8 03             	sar    $0x3,%eax
f01014cf:	c1 e0 0c             	shl    $0xc,%eax
f01014d2:	39 d0                	cmp    %edx,%eax
f01014d4:	0f 83 2d 02 00 00    	jae    f0101707 <mem_init+0x50a>
f01014da:	89 f0                	mov    %esi,%eax
f01014dc:	29 c8                	sub    %ecx,%eax
f01014de:	c1 f8 03             	sar    $0x3,%eax
f01014e1:	c1 e0 0c             	shl    $0xc,%eax
f01014e4:	39 c2                	cmp    %eax,%edx
f01014e6:	0f 86 34 02 00 00    	jbe    f0101720 <mem_init+0x523>
f01014ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014ef:	29 c8                	sub    %ecx,%eax
f01014f1:	c1 f8 03             	sar    $0x3,%eax
f01014f4:	c1 e0 0c             	shl    $0xc,%eax
f01014f7:	39 c2                	cmp    %eax,%edx
f01014f9:	0f 86 3a 02 00 00    	jbe    f0101739 <mem_init+0x53c>
f01014ff:	a1 6c 85 11 f0       	mov    0xf011856c,%eax
f0101504:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101507:	c7 05 6c 85 11 f0 00 	movl   $0x0,0xf011856c
f010150e:	00 00 00 
f0101511:	83 ec 0c             	sub    $0xc,%esp
f0101514:	6a 00                	push   $0x0
f0101516:	e8 63 f9 ff ff       	call   f0100e7e <page_alloc>
f010151b:	83 c4 10             	add    $0x10,%esp
f010151e:	85 c0                	test   %eax,%eax
f0101520:	0f 85 2c 02 00 00    	jne    f0101752 <mem_init+0x555>
f0101526:	83 ec 0c             	sub    $0xc,%esp
f0101529:	57                   	push   %edi
f010152a:	e8 ca f9 ff ff       	call   f0100ef9 <page_free>
f010152f:	89 34 24             	mov    %esi,(%esp)
f0101532:	e8 c2 f9 ff ff       	call   f0100ef9 <page_free>
f0101537:	83 c4 04             	add    $0x4,%esp
f010153a:	ff 75 d4             	push   -0x2c(%ebp)
f010153d:	e8 b7 f9 ff ff       	call   f0100ef9 <page_free>
f0101542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101549:	e8 30 f9 ff ff       	call   f0100e7e <page_alloc>
f010154e:	89 c6                	mov    %eax,%esi
f0101550:	83 c4 10             	add    $0x10,%esp
f0101553:	85 c0                	test   %eax,%eax
f0101555:	0f 84 10 02 00 00    	je     f010176b <mem_init+0x56e>
f010155b:	83 ec 0c             	sub    $0xc,%esp
f010155e:	6a 00                	push   $0x0
f0101560:	e8 19 f9 ff ff       	call   f0100e7e <page_alloc>
f0101565:	89 c7                	mov    %eax,%edi
f0101567:	83 c4 10             	add    $0x10,%esp
f010156a:	85 c0                	test   %eax,%eax
f010156c:	0f 84 12 02 00 00    	je     f0101784 <mem_init+0x587>
f0101572:	83 ec 0c             	sub    $0xc,%esp
f0101575:	6a 00                	push   $0x0
f0101577:	e8 02 f9 ff ff       	call   f0100e7e <page_alloc>
f010157c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010157f:	83 c4 10             	add    $0x10,%esp
f0101582:	85 c0                	test   %eax,%eax
f0101584:	0f 84 13 02 00 00    	je     f010179d <mem_init+0x5a0>
f010158a:	39 fe                	cmp    %edi,%esi
f010158c:	0f 84 24 02 00 00    	je     f01017b6 <mem_init+0x5b9>
f0101592:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101595:	39 c7                	cmp    %eax,%edi
f0101597:	0f 84 32 02 00 00    	je     f01017cf <mem_init+0x5d2>
f010159d:	39 c6                	cmp    %eax,%esi
f010159f:	0f 84 2a 02 00 00    	je     f01017cf <mem_init+0x5d2>
f01015a5:	83 ec 0c             	sub    $0xc,%esp
f01015a8:	6a 00                	push   $0x0
f01015aa:	e8 cf f8 ff ff       	call   f0100e7e <page_alloc>
f01015af:	83 c4 10             	add    $0x10,%esp
f01015b2:	85 c0                	test   %eax,%eax
f01015b4:	0f 85 2e 02 00 00    	jne    f01017e8 <mem_init+0x5eb>
f01015ba:	89 f0                	mov    %esi,%eax
f01015bc:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f01015c2:	c1 f8 03             	sar    $0x3,%eax
f01015c5:	89 c2                	mov    %eax,%edx
f01015c7:	c1 e2 0c             	shl    $0xc,%edx
f01015ca:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01015cf:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f01015d5:	0f 83 26 02 00 00    	jae    f0101801 <mem_init+0x604>
f01015db:	83 ec 04             	sub    $0x4,%esp
f01015de:	68 00 10 00 00       	push   $0x1000
f01015e3:	6a 01                	push   $0x1
f01015e5:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01015eb:	52                   	push   %edx
f01015ec:	e8 ad 20 00 00       	call   f010369e <memset>
f01015f1:	89 34 24             	mov    %esi,(%esp)
f01015f4:	e8 00 f9 ff ff       	call   f0100ef9 <page_free>
f01015f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101600:	e8 79 f8 ff ff       	call   f0100e7e <page_alloc>
f0101605:	83 c4 10             	add    $0x10,%esp
f0101608:	85 c0                	test   %eax,%eax
f010160a:	0f 84 03 02 00 00    	je     f0101813 <mem_init+0x616>
f0101610:	39 c6                	cmp    %eax,%esi
f0101612:	0f 85 14 02 00 00    	jne    f010182c <mem_init+0x62f>
f0101618:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f010161e:	c1 f8 03             	sar    $0x3,%eax
f0101621:	89 c2                	mov    %eax,%edx
f0101623:	c1 e2 0c             	shl    $0xc,%edx
f0101626:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010162b:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f0101631:	0f 83 0e 02 00 00    	jae    f0101845 <mem_init+0x648>
f0101637:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f010163d:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f0101643:	80 38 00             	cmpb   $0x0,(%eax)
f0101646:	0f 85 0b 02 00 00    	jne    f0101857 <mem_init+0x65a>
f010164c:	40                   	inc    %eax
f010164d:	39 d0                	cmp    %edx,%eax
f010164f:	75 f2                	jne    f0101643 <mem_init+0x446>
f0101651:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101654:	a3 6c 85 11 f0       	mov    %eax,0xf011856c
f0101659:	83 ec 0c             	sub    $0xc,%esp
f010165c:	56                   	push   %esi
f010165d:	e8 97 f8 ff ff       	call   f0100ef9 <page_free>
f0101662:	89 3c 24             	mov    %edi,(%esp)
f0101665:	e8 8f f8 ff ff       	call   f0100ef9 <page_free>
f010166a:	83 c4 04             	add    $0x4,%esp
f010166d:	ff 75 d4             	push   -0x2c(%ebp)
f0101670:	e8 84 f8 ff ff       	call   f0100ef9 <page_free>
f0101675:	a1 6c 85 11 f0       	mov    0xf011856c,%eax
f010167a:	83 c4 10             	add    $0x10,%esp
f010167d:	85 c0                	test   %eax,%eax
f010167f:	0f 84 eb 01 00 00    	je     f0101870 <mem_init+0x673>
f0101685:	4b                   	dec    %ebx
f0101686:	8b 00                	mov    (%eax),%eax
f0101688:	eb f3                	jmp    f010167d <mem_init+0x480>
f010168a:	68 4d 4d 10 f0       	push   $0xf0104d4d
f010168f:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101694:	68 a4 02 00 00       	push   $0x2a4
f0101699:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010169e:	e8 95 ea ff ff       	call   f0100138 <_panic>
f01016a3:	68 63 4d 10 f0       	push   $0xf0104d63
f01016a8:	68 e5 4b 10 f0       	push   $0xf0104be5
f01016ad:	68 a5 02 00 00       	push   $0x2a5
f01016b2:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01016b7:	e8 7c ea ff ff       	call   f0100138 <_panic>
f01016bc:	68 79 4d 10 f0       	push   $0xf0104d79
f01016c1:	68 e5 4b 10 f0       	push   $0xf0104be5
f01016c6:	68 a6 02 00 00       	push   $0x2a6
f01016cb:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01016d0:	e8 63 ea ff ff       	call   f0100138 <_panic>
f01016d5:	68 8f 4d 10 f0       	push   $0xf0104d8f
f01016da:	68 e5 4b 10 f0       	push   $0xf0104be5
f01016df:	68 a9 02 00 00       	push   $0x2a9
f01016e4:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01016e9:	e8 4a ea ff ff       	call   f0100138 <_panic>
f01016ee:	68 e8 44 10 f0       	push   $0xf01044e8
f01016f3:	68 e5 4b 10 f0       	push   $0xf0104be5
f01016f8:	68 aa 02 00 00       	push   $0x2aa
f01016fd:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101702:	e8 31 ea ff ff       	call   f0100138 <_panic>
f0101707:	68 08 45 10 f0       	push   $0xf0104508
f010170c:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101711:	68 ab 02 00 00       	push   $0x2ab
f0101716:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010171b:	e8 18 ea ff ff       	call   f0100138 <_panic>
f0101720:	68 28 45 10 f0       	push   $0xf0104528
f0101725:	68 e5 4b 10 f0       	push   $0xf0104be5
f010172a:	68 ac 02 00 00       	push   $0x2ac
f010172f:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101734:	e8 ff e9 ff ff       	call   f0100138 <_panic>
f0101739:	68 48 45 10 f0       	push   $0xf0104548
f010173e:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101743:	68 ad 02 00 00       	push   $0x2ad
f0101748:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010174d:	e8 e6 e9 ff ff       	call   f0100138 <_panic>
f0101752:	68 a1 4d 10 f0       	push   $0xf0104da1
f0101757:	68 e5 4b 10 f0       	push   $0xf0104be5
f010175c:	68 b4 02 00 00       	push   $0x2b4
f0101761:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101766:	e8 cd e9 ff ff       	call   f0100138 <_panic>
f010176b:	68 4d 4d 10 f0       	push   $0xf0104d4d
f0101770:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101775:	68 bb 02 00 00       	push   $0x2bb
f010177a:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010177f:	e8 b4 e9 ff ff       	call   f0100138 <_panic>
f0101784:	68 63 4d 10 f0       	push   $0xf0104d63
f0101789:	68 e5 4b 10 f0       	push   $0xf0104be5
f010178e:	68 bc 02 00 00       	push   $0x2bc
f0101793:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101798:	e8 9b e9 ff ff       	call   f0100138 <_panic>
f010179d:	68 79 4d 10 f0       	push   $0xf0104d79
f01017a2:	68 e5 4b 10 f0       	push   $0xf0104be5
f01017a7:	68 bd 02 00 00       	push   $0x2bd
f01017ac:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01017b1:	e8 82 e9 ff ff       	call   f0100138 <_panic>
f01017b6:	68 8f 4d 10 f0       	push   $0xf0104d8f
f01017bb:	68 e5 4b 10 f0       	push   $0xf0104be5
f01017c0:	68 bf 02 00 00       	push   $0x2bf
f01017c5:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01017ca:	e8 69 e9 ff ff       	call   f0100138 <_panic>
f01017cf:	68 e8 44 10 f0       	push   $0xf01044e8
f01017d4:	68 e5 4b 10 f0       	push   $0xf0104be5
f01017d9:	68 c0 02 00 00       	push   $0x2c0
f01017de:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01017e3:	e8 50 e9 ff ff       	call   f0100138 <_panic>
f01017e8:	68 a1 4d 10 f0       	push   $0xf0104da1
f01017ed:	68 e5 4b 10 f0       	push   $0xf0104be5
f01017f2:	68 c1 02 00 00       	push   $0x2c1
f01017f7:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01017fc:	e8 37 e9 ff ff       	call   f0100138 <_panic>
f0101801:	52                   	push   %edx
f0101802:	68 ec 41 10 f0       	push   $0xf01041ec
f0101807:	6a 52                	push   $0x52
f0101809:	68 06 4c 10 f0       	push   $0xf0104c06
f010180e:	e8 25 e9 ff ff       	call   f0100138 <_panic>
f0101813:	68 b0 4d 10 f0       	push   $0xf0104db0
f0101818:	68 e5 4b 10 f0       	push   $0xf0104be5
f010181d:	68 c6 02 00 00       	push   $0x2c6
f0101822:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101827:	e8 0c e9 ff ff       	call   f0100138 <_panic>
f010182c:	68 ce 4d 10 f0       	push   $0xf0104dce
f0101831:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101836:	68 c7 02 00 00       	push   $0x2c7
f010183b:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101840:	e8 f3 e8 ff ff       	call   f0100138 <_panic>
f0101845:	52                   	push   %edx
f0101846:	68 ec 41 10 f0       	push   $0xf01041ec
f010184b:	6a 52                	push   $0x52
f010184d:	68 06 4c 10 f0       	push   $0xf0104c06
f0101852:	e8 e1 e8 ff ff       	call   f0100138 <_panic>
f0101857:	68 de 4d 10 f0       	push   $0xf0104dde
f010185c:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101861:	68 ca 02 00 00       	push   $0x2ca
f0101866:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010186b:	e8 c8 e8 ff ff       	call   f0100138 <_panic>
f0101870:	85 db                	test   %ebx,%ebx
f0101872:	0f 85 14 07 00 00    	jne    f0101f8c <mem_init+0xd8f>
f0101878:	83 ec 0c             	sub    $0xc,%esp
f010187b:	68 68 45 10 f0       	push   $0xf0104568
f0101880:	e8 ae 12 00 00       	call   f0102b33 <cprintf>
f0101885:	c7 04 24 88 45 10 f0 	movl   $0xf0104588,(%esp)
f010188c:	e8 a2 12 00 00       	call   f0102b33 <cprintf>
f0101891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101898:	e8 e1 f5 ff ff       	call   f0100e7e <page_alloc>
f010189d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018a0:	83 c4 10             	add    $0x10,%esp
f01018a3:	85 c0                	test   %eax,%eax
f01018a5:	0f 84 fa 06 00 00    	je     f0101fa5 <mem_init+0xda8>
f01018ab:	83 ec 0c             	sub    $0xc,%esp
f01018ae:	6a 00                	push   $0x0
f01018b0:	e8 c9 f5 ff ff       	call   f0100e7e <page_alloc>
f01018b5:	89 c6                	mov    %eax,%esi
f01018b7:	83 c4 10             	add    $0x10,%esp
f01018ba:	85 c0                	test   %eax,%eax
f01018bc:	0f 84 fc 06 00 00    	je     f0101fbe <mem_init+0xdc1>
f01018c2:	83 ec 0c             	sub    $0xc,%esp
f01018c5:	6a 00                	push   $0x0
f01018c7:	e8 b2 f5 ff ff       	call   f0100e7e <page_alloc>
f01018cc:	89 c7                	mov    %eax,%edi
f01018ce:	83 c4 10             	add    $0x10,%esp
f01018d1:	85 c0                	test   %eax,%eax
f01018d3:	0f 84 fe 06 00 00    	je     f0101fd7 <mem_init+0xdda>
f01018d9:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f01018dc:	0f 84 0e 07 00 00    	je     f0101ff0 <mem_init+0xdf3>
f01018e2:	39 c6                	cmp    %eax,%esi
f01018e4:	0f 84 1f 07 00 00    	je     f0102009 <mem_init+0xe0c>
f01018ea:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01018ed:	0f 84 16 07 00 00    	je     f0102009 <mem_init+0xe0c>
f01018f3:	a1 6c 85 11 f0       	mov    0xf011856c,%eax
f01018f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01018fb:	c7 05 6c 85 11 f0 00 	movl   $0x0,0xf011856c
f0101902:	00 00 00 
f0101905:	83 ec 0c             	sub    $0xc,%esp
f0101908:	6a 00                	push   $0x0
f010190a:	e8 6f f5 ff ff       	call   f0100e7e <page_alloc>
f010190f:	83 c4 10             	add    $0x10,%esp
f0101912:	85 c0                	test   %eax,%eax
f0101914:	0f 85 08 07 00 00    	jne    f0102022 <mem_init+0xe25>
f010191a:	83 ec 04             	sub    $0x4,%esp
f010191d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101920:	50                   	push   %eax
f0101921:	6a 00                	push   $0x0
f0101923:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101929:	e8 19 f7 ff ff       	call   f0101047 <page_lookup>
f010192e:	83 c4 10             	add    $0x10,%esp
f0101931:	85 c0                	test   %eax,%eax
f0101933:	0f 85 02 07 00 00    	jne    f010203b <mem_init+0xe3e>
f0101939:	6a 02                	push   $0x2
f010193b:	6a 00                	push   $0x0
f010193d:	56                   	push   %esi
f010193e:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101944:	e8 92 f7 ff ff       	call   f01010db <page_insert>
f0101949:	83 c4 10             	add    $0x10,%esp
f010194c:	85 c0                	test   %eax,%eax
f010194e:	0f 89 00 07 00 00    	jns    f0102054 <mem_init+0xe57>
f0101954:	83 ec 0c             	sub    $0xc,%esp
f0101957:	ff 75 d4             	push   -0x2c(%ebp)
f010195a:	e8 9a f5 ff ff       	call   f0100ef9 <page_free>
f010195f:	6a 02                	push   $0x2
f0101961:	6a 00                	push   $0x0
f0101963:	56                   	push   %esi
f0101964:	ff 35 5c 85 11 f0    	push   0xf011855c
f010196a:	e8 6c f7 ff ff       	call   f01010db <page_insert>
f010196f:	83 c4 20             	add    $0x20,%esp
f0101972:	85 c0                	test   %eax,%eax
f0101974:	0f 85 f3 06 00 00    	jne    f010206d <mem_init+0xe70>
f010197a:	8b 1d 5c 85 11 f0    	mov    0xf011855c,%ebx
f0101980:	8b 0d 58 85 11 f0    	mov    0xf0118558,%ecx
f0101986:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101989:	8b 13                	mov    (%ebx),%edx
f010198b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101991:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101994:	29 c8                	sub    %ecx,%eax
f0101996:	c1 f8 03             	sar    $0x3,%eax
f0101999:	c1 e0 0c             	shl    $0xc,%eax
f010199c:	39 c2                	cmp    %eax,%edx
f010199e:	0f 85 e2 06 00 00    	jne    f0102086 <mem_init+0xe89>
f01019a4:	ba 00 00 00 00       	mov    $0x0,%edx
f01019a9:	89 d8                	mov    %ebx,%eax
f01019ab:	e8 ec ef ff ff       	call   f010099c <check_va2pa>
f01019b0:	89 c2                	mov    %eax,%edx
f01019b2:	89 f0                	mov    %esi,%eax
f01019b4:	2b 45 d0             	sub    -0x30(%ebp),%eax
f01019b7:	c1 f8 03             	sar    $0x3,%eax
f01019ba:	c1 e0 0c             	shl    $0xc,%eax
f01019bd:	39 c2                	cmp    %eax,%edx
f01019bf:	0f 85 da 06 00 00    	jne    f010209f <mem_init+0xea2>
f01019c5:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01019ca:	0f 85 e8 06 00 00    	jne    f01020b8 <mem_init+0xebb>
f01019d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019d3:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01019d8:	0f 85 f3 06 00 00    	jne    f01020d1 <mem_init+0xed4>
f01019de:	6a 02                	push   $0x2
f01019e0:	68 00 10 00 00       	push   $0x1000
f01019e5:	57                   	push   %edi
f01019e6:	53                   	push   %ebx
f01019e7:	e8 ef f6 ff ff       	call   f01010db <page_insert>
f01019ec:	83 c4 10             	add    $0x10,%esp
f01019ef:	85 c0                	test   %eax,%eax
f01019f1:	0f 85 f3 06 00 00    	jne    f01020ea <mem_init+0xeed>
f01019f7:	ba 00 10 00 00       	mov    $0x1000,%edx
f01019fc:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101a01:	e8 96 ef ff ff       	call   f010099c <check_va2pa>
f0101a06:	89 c2                	mov    %eax,%edx
f0101a08:	89 f8                	mov    %edi,%eax
f0101a0a:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101a10:	c1 f8 03             	sar    $0x3,%eax
f0101a13:	c1 e0 0c             	shl    $0xc,%eax
f0101a16:	39 c2                	cmp    %eax,%edx
f0101a18:	0f 85 e5 06 00 00    	jne    f0102103 <mem_init+0xf06>
f0101a1e:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a23:	0f 85 f3 06 00 00    	jne    f010211c <mem_init+0xf1f>
f0101a29:	83 ec 0c             	sub    $0xc,%esp
f0101a2c:	6a 00                	push   $0x0
f0101a2e:	e8 4b f4 ff ff       	call   f0100e7e <page_alloc>
f0101a33:	83 c4 10             	add    $0x10,%esp
f0101a36:	85 c0                	test   %eax,%eax
f0101a38:	0f 85 f7 06 00 00    	jne    f0102135 <mem_init+0xf38>
f0101a3e:	6a 02                	push   $0x2
f0101a40:	68 00 10 00 00       	push   $0x1000
f0101a45:	57                   	push   %edi
f0101a46:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101a4c:	e8 8a f6 ff ff       	call   f01010db <page_insert>
f0101a51:	83 c4 10             	add    $0x10,%esp
f0101a54:	85 c0                	test   %eax,%eax
f0101a56:	0f 85 f2 06 00 00    	jne    f010214e <mem_init+0xf51>
f0101a5c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a61:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101a66:	e8 31 ef ff ff       	call   f010099c <check_va2pa>
f0101a6b:	89 c2                	mov    %eax,%edx
f0101a6d:	89 f8                	mov    %edi,%eax
f0101a6f:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101a75:	c1 f8 03             	sar    $0x3,%eax
f0101a78:	c1 e0 0c             	shl    $0xc,%eax
f0101a7b:	39 c2                	cmp    %eax,%edx
f0101a7d:	0f 85 e4 06 00 00    	jne    f0102167 <mem_init+0xf6a>
f0101a83:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a88:	0f 85 f2 06 00 00    	jne    f0102180 <mem_init+0xf83>
f0101a8e:	83 ec 0c             	sub    $0xc,%esp
f0101a91:	6a 00                	push   $0x0
f0101a93:	e8 e6 f3 ff ff       	call   f0100e7e <page_alloc>
f0101a98:	83 c4 10             	add    $0x10,%esp
f0101a9b:	85 c0                	test   %eax,%eax
f0101a9d:	0f 85 f6 06 00 00    	jne    f0102199 <mem_init+0xf9c>
f0101aa3:	8b 15 5c 85 11 f0    	mov    0xf011855c,%edx
f0101aa9:	8b 02                	mov    (%edx),%eax
f0101aab:	89 c3                	mov    %eax,%ebx
f0101aad:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101ab3:	c1 e8 0c             	shr    $0xc,%eax
f0101ab6:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f0101abc:	0f 83 f0 06 00 00    	jae    f01021b2 <mem_init+0xfb5>
f0101ac2:	83 ec 04             	sub    $0x4,%esp
f0101ac5:	6a 00                	push   $0x0
f0101ac7:	68 00 10 00 00       	push   $0x1000
f0101acc:	52                   	push   %edx
f0101acd:	e8 a3 f4 ff ff       	call   f0100f75 <pgdir_walk>
f0101ad2:	81 eb fc ff ff 0f    	sub    $0xffffffc,%ebx
f0101ad8:	83 c4 10             	add    $0x10,%esp
f0101adb:	39 d8                	cmp    %ebx,%eax
f0101add:	0f 85 e4 06 00 00    	jne    f01021c7 <mem_init+0xfca>
f0101ae3:	6a 06                	push   $0x6
f0101ae5:	68 00 10 00 00       	push   $0x1000
f0101aea:	57                   	push   %edi
f0101aeb:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101af1:	e8 e5 f5 ff ff       	call   f01010db <page_insert>
f0101af6:	83 c4 10             	add    $0x10,%esp
f0101af9:	85 c0                	test   %eax,%eax
f0101afb:	0f 85 df 06 00 00    	jne    f01021e0 <mem_init+0xfe3>
f0101b01:	8b 1d 5c 85 11 f0    	mov    0xf011855c,%ebx
f0101b07:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b0c:	89 d8                	mov    %ebx,%eax
f0101b0e:	e8 89 ee ff ff       	call   f010099c <check_va2pa>
f0101b13:	89 c2                	mov    %eax,%edx
f0101b15:	89 f8                	mov    %edi,%eax
f0101b17:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101b1d:	c1 f8 03             	sar    $0x3,%eax
f0101b20:	c1 e0 0c             	shl    $0xc,%eax
f0101b23:	39 c2                	cmp    %eax,%edx
f0101b25:	0f 85 ce 06 00 00    	jne    f01021f9 <mem_init+0xffc>
f0101b2b:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101b30:	0f 85 dc 06 00 00    	jne    f0102212 <mem_init+0x1015>
f0101b36:	83 ec 04             	sub    $0x4,%esp
f0101b39:	6a 00                	push   $0x0
f0101b3b:	68 00 10 00 00       	push   $0x1000
f0101b40:	53                   	push   %ebx
f0101b41:	e8 2f f4 ff ff       	call   f0100f75 <pgdir_walk>
f0101b46:	83 c4 10             	add    $0x10,%esp
f0101b49:	f6 00 04             	testb  $0x4,(%eax)
f0101b4c:	0f 84 d9 06 00 00    	je     f010222b <mem_init+0x102e>
f0101b52:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101b57:	f6 00 04             	testb  $0x4,(%eax)
f0101b5a:	0f 84 e4 06 00 00    	je     f0102244 <mem_init+0x1047>
f0101b60:	6a 02                	push   $0x2
f0101b62:	68 00 10 00 00       	push   $0x1000
f0101b67:	57                   	push   %edi
f0101b68:	50                   	push   %eax
f0101b69:	e8 6d f5 ff ff       	call   f01010db <page_insert>
f0101b6e:	83 c4 10             	add    $0x10,%esp
f0101b71:	85 c0                	test   %eax,%eax
f0101b73:	0f 85 e4 06 00 00    	jne    f010225d <mem_init+0x1060>
f0101b79:	83 ec 04             	sub    $0x4,%esp
f0101b7c:	6a 00                	push   $0x0
f0101b7e:	68 00 10 00 00       	push   $0x1000
f0101b83:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101b89:	e8 e7 f3 ff ff       	call   f0100f75 <pgdir_walk>
f0101b8e:	83 c4 10             	add    $0x10,%esp
f0101b91:	f6 00 02             	testb  $0x2,(%eax)
f0101b94:	0f 84 dc 06 00 00    	je     f0102276 <mem_init+0x1079>
f0101b9a:	83 ec 04             	sub    $0x4,%esp
f0101b9d:	6a 00                	push   $0x0
f0101b9f:	68 00 10 00 00       	push   $0x1000
f0101ba4:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101baa:	e8 c6 f3 ff ff       	call   f0100f75 <pgdir_walk>
f0101baf:	83 c4 10             	add    $0x10,%esp
f0101bb2:	f6 00 04             	testb  $0x4,(%eax)
f0101bb5:	0f 85 d4 06 00 00    	jne    f010228f <mem_init+0x1092>
f0101bbb:	6a 02                	push   $0x2
f0101bbd:	68 00 00 40 00       	push   $0x400000
f0101bc2:	ff 75 d4             	push   -0x2c(%ebp)
f0101bc5:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101bcb:	e8 0b f5 ff ff       	call   f01010db <page_insert>
f0101bd0:	83 c4 10             	add    $0x10,%esp
f0101bd3:	85 c0                	test   %eax,%eax
f0101bd5:	0f 89 cd 06 00 00    	jns    f01022a8 <mem_init+0x10ab>
f0101bdb:	6a 02                	push   $0x2
f0101bdd:	68 00 10 00 00       	push   $0x1000
f0101be2:	56                   	push   %esi
f0101be3:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101be9:	e8 ed f4 ff ff       	call   f01010db <page_insert>
f0101bee:	83 c4 10             	add    $0x10,%esp
f0101bf1:	85 c0                	test   %eax,%eax
f0101bf3:	0f 85 c8 06 00 00    	jne    f01022c1 <mem_init+0x10c4>
f0101bf9:	83 ec 04             	sub    $0x4,%esp
f0101bfc:	6a 00                	push   $0x0
f0101bfe:	68 00 10 00 00       	push   $0x1000
f0101c03:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101c09:	e8 67 f3 ff ff       	call   f0100f75 <pgdir_walk>
f0101c0e:	83 c4 10             	add    $0x10,%esp
f0101c11:	f6 00 04             	testb  $0x4,(%eax)
f0101c14:	0f 85 c0 06 00 00    	jne    f01022da <mem_init+0x10dd>
f0101c1a:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101c1f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101c22:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c27:	e8 70 ed ff ff       	call   f010099c <check_va2pa>
f0101c2c:	89 f3                	mov    %esi,%ebx
f0101c2e:	2b 1d 58 85 11 f0    	sub    0xf0118558,%ebx
f0101c34:	c1 fb 03             	sar    $0x3,%ebx
f0101c37:	c1 e3 0c             	shl    $0xc,%ebx
f0101c3a:	39 d8                	cmp    %ebx,%eax
f0101c3c:	0f 85 b1 06 00 00    	jne    f01022f3 <mem_init+0x10f6>
f0101c42:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c47:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c4a:	e8 4d ed ff ff       	call   f010099c <check_va2pa>
f0101c4f:	39 c3                	cmp    %eax,%ebx
f0101c51:	0f 85 b5 06 00 00    	jne    f010230c <mem_init+0x110f>
f0101c57:	66 83 7e 04 02       	cmpw   $0x2,0x4(%esi)
f0101c5c:	0f 85 c3 06 00 00    	jne    f0102325 <mem_init+0x1128>
f0101c62:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101c67:	0f 85 d1 06 00 00    	jne    f010233e <mem_init+0x1141>
f0101c6d:	83 ec 0c             	sub    $0xc,%esp
f0101c70:	6a 00                	push   $0x0
f0101c72:	e8 07 f2 ff ff       	call   f0100e7e <page_alloc>
f0101c77:	83 c4 10             	add    $0x10,%esp
f0101c7a:	85 c0                	test   %eax,%eax
f0101c7c:	0f 84 d5 06 00 00    	je     f0102357 <mem_init+0x115a>
f0101c82:	39 c7                	cmp    %eax,%edi
f0101c84:	0f 85 cd 06 00 00    	jne    f0102357 <mem_init+0x115a>
f0101c8a:	83 ec 08             	sub    $0x8,%esp
f0101c8d:	6a 00                	push   $0x0
f0101c8f:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101c95:	e8 00 f4 ff ff       	call   f010109a <page_remove>
f0101c9a:	8b 1d 5c 85 11 f0    	mov    0xf011855c,%ebx
f0101ca0:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ca5:	89 d8                	mov    %ebx,%eax
f0101ca7:	e8 f0 ec ff ff       	call   f010099c <check_va2pa>
f0101cac:	83 c4 10             	add    $0x10,%esp
f0101caf:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101cb2:	0f 85 b8 06 00 00    	jne    f0102370 <mem_init+0x1173>
f0101cb8:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101cbd:	89 d8                	mov    %ebx,%eax
f0101cbf:	e8 d8 ec ff ff       	call   f010099c <check_va2pa>
f0101cc4:	89 c2                	mov    %eax,%edx
f0101cc6:	89 f0                	mov    %esi,%eax
f0101cc8:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101cce:	c1 f8 03             	sar    $0x3,%eax
f0101cd1:	c1 e0 0c             	shl    $0xc,%eax
f0101cd4:	39 c2                	cmp    %eax,%edx
f0101cd6:	0f 85 ad 06 00 00    	jne    f0102389 <mem_init+0x118c>
f0101cdc:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101ce1:	0f 85 bb 06 00 00    	jne    f01023a2 <mem_init+0x11a5>
f0101ce7:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101cec:	0f 85 c9 06 00 00    	jne    f01023bb <mem_init+0x11be>
f0101cf2:	6a 00                	push   $0x0
f0101cf4:	68 00 10 00 00       	push   $0x1000
f0101cf9:	56                   	push   %esi
f0101cfa:	53                   	push   %ebx
f0101cfb:	e8 db f3 ff ff       	call   f01010db <page_insert>
f0101d00:	83 c4 10             	add    $0x10,%esp
f0101d03:	85 c0                	test   %eax,%eax
f0101d05:	0f 85 c9 06 00 00    	jne    f01023d4 <mem_init+0x11d7>
f0101d0b:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d10:	0f 84 d7 06 00 00    	je     f01023ed <mem_init+0x11f0>
f0101d16:	83 3e 00             	cmpl   $0x0,(%esi)
f0101d19:	0f 85 e7 06 00 00    	jne    f0102406 <mem_init+0x1209>
f0101d1f:	83 ec 08             	sub    $0x8,%esp
f0101d22:	68 00 10 00 00       	push   $0x1000
f0101d27:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101d2d:	e8 68 f3 ff ff       	call   f010109a <page_remove>
f0101d32:	8b 1d 5c 85 11 f0    	mov    0xf011855c,%ebx
f0101d38:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d3d:	89 d8                	mov    %ebx,%eax
f0101d3f:	e8 58 ec ff ff       	call   f010099c <check_va2pa>
f0101d44:	83 c4 10             	add    $0x10,%esp
f0101d47:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d4a:	0f 85 cf 06 00 00    	jne    f010241f <mem_init+0x1222>
f0101d50:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d55:	89 d8                	mov    %ebx,%eax
f0101d57:	e8 40 ec ff ff       	call   f010099c <check_va2pa>
f0101d5c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d5f:	0f 85 d3 06 00 00    	jne    f0102438 <mem_init+0x123b>
f0101d65:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d6a:	0f 85 e1 06 00 00    	jne    f0102451 <mem_init+0x1254>
f0101d70:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101d75:	0f 85 ef 06 00 00    	jne    f010246a <mem_init+0x126d>
f0101d7b:	83 ec 0c             	sub    $0xc,%esp
f0101d7e:	6a 00                	push   $0x0
f0101d80:	e8 f9 f0 ff ff       	call   f0100e7e <page_alloc>
f0101d85:	83 c4 10             	add    $0x10,%esp
f0101d88:	85 c0                	test   %eax,%eax
f0101d8a:	0f 84 f3 06 00 00    	je     f0102483 <mem_init+0x1286>
f0101d90:	39 c6                	cmp    %eax,%esi
f0101d92:	0f 85 eb 06 00 00    	jne    f0102483 <mem_init+0x1286>
f0101d98:	83 ec 0c             	sub    $0xc,%esp
f0101d9b:	6a 00                	push   $0x0
f0101d9d:	e8 dc f0 ff ff       	call   f0100e7e <page_alloc>
f0101da2:	83 c4 10             	add    $0x10,%esp
f0101da5:	85 c0                	test   %eax,%eax
f0101da7:	0f 85 ef 06 00 00    	jne    f010249c <mem_init+0x129f>
f0101dad:	8b 0d 5c 85 11 f0    	mov    0xf011855c,%ecx
f0101db3:	8b 11                	mov    (%ecx),%edx
f0101db5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101dbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dbe:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101dc4:	c1 f8 03             	sar    $0x3,%eax
f0101dc7:	c1 e0 0c             	shl    $0xc,%eax
f0101dca:	39 c2                	cmp    %eax,%edx
f0101dcc:	0f 85 e3 06 00 00    	jne    f01024b5 <mem_init+0x12b8>
f0101dd2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0101dd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ddb:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101de0:	0f 85 e8 06 00 00    	jne    f01024ce <mem_init+0x12d1>
f0101de6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101de9:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0101def:	83 ec 0c             	sub    $0xc,%esp
f0101df2:	50                   	push   %eax
f0101df3:	e8 01 f1 ff ff       	call   f0100ef9 <page_free>
f0101df8:	83 c4 0c             	add    $0xc,%esp
f0101dfb:	6a 01                	push   $0x1
f0101dfd:	68 00 10 40 00       	push   $0x401000
f0101e02:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101e08:	e8 68 f1 ff ff       	call   f0100f75 <pgdir_walk>
f0101e0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e10:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101e15:	8b 40 04             	mov    0x4(%eax),%eax
f0101e18:	89 c3                	mov    %eax,%ebx
f0101e1a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101e20:	89 c2                	mov    %eax,%edx
f0101e22:	c1 ea 0c             	shr    $0xc,%edx
f0101e25:	83 c4 10             	add    $0x10,%esp
f0101e28:	3b 15 60 85 11 f0    	cmp    0xf0118560,%edx
f0101e2e:	0f 83 b3 06 00 00    	jae    f01024e7 <mem_init+0x12ea>
f0101e34:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0101e3a:	83 ec 08             	sub    $0x8,%esp
f0101e3d:	6a 01                	push   $0x1
f0101e3f:	52                   	push   %edx
f0101e40:	ff 75 d0             	push   -0x30(%ebp)
f0101e43:	50                   	push   %eax
f0101e44:	53                   	push   %ebx
f0101e45:	68 f4 49 10 f0       	push   $0xf01049f4
f0101e4a:	e8 e4 0c 00 00       	call   f0102b33 <cprintf>
f0101e4f:	81 eb fc ff ff 0f    	sub    $0xffffffc,%ebx
f0101e55:	83 c4 20             	add    $0x20,%esp
f0101e58:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0101e5b:	0f 85 9b 06 00 00    	jne    f01024fc <mem_init+0x12ff>
f0101e61:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101e66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
f0101e6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e70:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0101e76:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101e7c:	c1 f8 03             	sar    $0x3,%eax
f0101e7f:	89 c2                	mov    %eax,%edx
f0101e81:	c1 e2 0c             	shl    $0xc,%edx
f0101e84:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101e89:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f0101e8f:	0f 83 80 06 00 00    	jae    f0102515 <mem_init+0x1318>
f0101e95:	83 ec 04             	sub    $0x4,%esp
f0101e98:	68 00 10 00 00       	push   $0x1000
f0101e9d:	68 ff 00 00 00       	push   $0xff
f0101ea2:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101ea8:	52                   	push   %edx
f0101ea9:	e8 f0 17 00 00       	call   f010369e <memset>
f0101eae:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101eb1:	89 1c 24             	mov    %ebx,(%esp)
f0101eb4:	e8 40 f0 ff ff       	call   f0100ef9 <page_free>
f0101eb9:	83 c4 0c             	add    $0xc,%esp
f0101ebc:	6a 01                	push   $0x1
f0101ebe:	6a 00                	push   $0x0
f0101ec0:	ff 35 5c 85 11 f0    	push   0xf011855c
f0101ec6:	e8 aa f0 ff ff       	call   f0100f75 <pgdir_walk>
f0101ecb:	89 d8                	mov    %ebx,%eax
f0101ecd:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0101ed3:	c1 f8 03             	sar    $0x3,%eax
f0101ed6:	89 c2                	mov    %eax,%edx
f0101ed8:	c1 e2 0c             	shl    $0xc,%edx
f0101edb:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101ee0:	83 c4 10             	add    $0x10,%esp
f0101ee3:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f0101ee9:	0f 83 38 06 00 00    	jae    f0102527 <mem_init+0x132a>
f0101eef:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101ef5:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f0101efb:	8b 18                	mov    (%eax),%ebx
f0101efd:	83 e3 01             	and    $0x1,%ebx
f0101f00:	0f 85 33 06 00 00    	jne    f0102539 <mem_init+0x133c>
f0101f06:	83 c0 04             	add    $0x4,%eax
f0101f09:	39 d0                	cmp    %edx,%eax
f0101f0b:	75 ee                	jne    f0101efb <mem_init+0xcfe>
f0101f0d:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0101f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101f18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f1b:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0101f21:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101f24:	89 0d 6c 85 11 f0    	mov    %ecx,0xf011856c
f0101f2a:	83 ec 0c             	sub    $0xc,%esp
f0101f2d:	50                   	push   %eax
f0101f2e:	e8 c6 ef ff ff       	call   f0100ef9 <page_free>
f0101f33:	89 34 24             	mov    %esi,(%esp)
f0101f36:	e8 be ef ff ff       	call   f0100ef9 <page_free>
f0101f3b:	89 3c 24             	mov    %edi,(%esp)
f0101f3e:	e8 b6 ef ff ff       	call   f0100ef9 <page_free>
f0101f43:	c7 04 24 bf 4e 10 f0 	movl   $0xf0104ebf,(%esp)
f0101f4a:	e8 e4 0b 00 00       	call   f0102b33 <cprintf>
f0101f4f:	8b 3d 5c 85 11 f0    	mov    0xf011855c,%edi
f0101f55:	a1 60 85 11 f0       	mov    0xf0118560,%eax
f0101f5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101f5d:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0101f64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101f69:	8b 0d 58 85 11 f0    	mov    0xf0118558,%ecx
f0101f6f:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101f72:	81 c1 00 00 00 10    	add    $0x10000000,%ecx
f0101f78:	83 c4 10             	add    $0x10,%esp
f0101f7b:	89 de                	mov    %ebx,%esi
f0101f7d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0101f80:	89 cf                	mov    %ecx,%edi
f0101f82:	89 5d c8             	mov    %ebx,-0x38(%ebp)
f0101f85:	89 c3                	mov    %eax,%ebx
f0101f87:	e9 e3 05 00 00       	jmp    f010256f <mem_init+0x1372>
f0101f8c:	68 e8 4d 10 f0       	push   $0xf0104de8
f0101f91:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101f96:	68 d7 02 00 00       	push   $0x2d7
f0101f9b:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101fa0:	e8 93 e1 ff ff       	call   f0100138 <_panic>
f0101fa5:	68 4d 4d 10 f0       	push   $0xf0104d4d
f0101faa:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101faf:	68 2d 03 00 00       	push   $0x32d
f0101fb4:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101fb9:	e8 7a e1 ff ff       	call   f0100138 <_panic>
f0101fbe:	68 63 4d 10 f0       	push   $0xf0104d63
f0101fc3:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101fc8:	68 2e 03 00 00       	push   $0x32e
f0101fcd:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101fd2:	e8 61 e1 ff ff       	call   f0100138 <_panic>
f0101fd7:	68 79 4d 10 f0       	push   $0xf0104d79
f0101fdc:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101fe1:	68 2f 03 00 00       	push   $0x32f
f0101fe6:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0101feb:	e8 48 e1 ff ff       	call   f0100138 <_panic>
f0101ff0:	68 8f 4d 10 f0       	push   $0xf0104d8f
f0101ff5:	68 e5 4b 10 f0       	push   $0xf0104be5
f0101ffa:	68 32 03 00 00       	push   $0x332
f0101fff:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102004:	e8 2f e1 ff ff       	call   f0100138 <_panic>
f0102009:	68 e8 44 10 f0       	push   $0xf01044e8
f010200e:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102013:	68 33 03 00 00       	push   $0x333
f0102018:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010201d:	e8 16 e1 ff ff       	call   f0100138 <_panic>
f0102022:	68 a1 4d 10 f0       	push   $0xf0104da1
f0102027:	68 e5 4b 10 f0       	push   $0xf0104be5
f010202c:	68 3a 03 00 00       	push   $0x33a
f0102031:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102036:	e8 fd e0 ff ff       	call   f0100138 <_panic>
f010203b:	68 d0 45 10 f0       	push   $0xf01045d0
f0102040:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102045:	68 3d 03 00 00       	push   $0x33d
f010204a:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010204f:	e8 e4 e0 ff ff       	call   f0100138 <_panic>
f0102054:	68 08 46 10 f0       	push   $0xf0104608
f0102059:	68 e5 4b 10 f0       	push   $0xf0104be5
f010205e:	68 40 03 00 00       	push   $0x340
f0102063:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102068:	e8 cb e0 ff ff       	call   f0100138 <_panic>
f010206d:	68 38 46 10 f0       	push   $0xf0104638
f0102072:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102077:	68 44 03 00 00       	push   $0x344
f010207c:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102081:	e8 b2 e0 ff ff       	call   f0100138 <_panic>
f0102086:	68 68 46 10 f0       	push   $0xf0104668
f010208b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102090:	68 45 03 00 00       	push   $0x345
f0102095:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010209a:	e8 99 e0 ff ff       	call   f0100138 <_panic>
f010209f:	68 90 46 10 f0       	push   $0xf0104690
f01020a4:	68 e5 4b 10 f0       	push   $0xf0104be5
f01020a9:	68 46 03 00 00       	push   $0x346
f01020ae:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01020b3:	e8 80 e0 ff ff       	call   f0100138 <_panic>
f01020b8:	68 f3 4d 10 f0       	push   $0xf0104df3
f01020bd:	68 e5 4b 10 f0       	push   $0xf0104be5
f01020c2:	68 47 03 00 00       	push   $0x347
f01020c7:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01020cc:	e8 67 e0 ff ff       	call   f0100138 <_panic>
f01020d1:	68 04 4e 10 f0       	push   $0xf0104e04
f01020d6:	68 e5 4b 10 f0       	push   $0xf0104be5
f01020db:	68 48 03 00 00       	push   $0x348
f01020e0:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01020e5:	e8 4e e0 ff ff       	call   f0100138 <_panic>
f01020ea:	68 c0 46 10 f0       	push   $0xf01046c0
f01020ef:	68 e5 4b 10 f0       	push   $0xf0104be5
f01020f4:	68 4b 03 00 00       	push   $0x34b
f01020f9:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01020fe:	e8 35 e0 ff ff       	call   f0100138 <_panic>
f0102103:	68 fc 46 10 f0       	push   $0xf01046fc
f0102108:	68 e5 4b 10 f0       	push   $0xf0104be5
f010210d:	68 4c 03 00 00       	push   $0x34c
f0102112:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102117:	e8 1c e0 ff ff       	call   f0100138 <_panic>
f010211c:	68 15 4e 10 f0       	push   $0xf0104e15
f0102121:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102126:	68 4d 03 00 00       	push   $0x34d
f010212b:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102130:	e8 03 e0 ff ff       	call   f0100138 <_panic>
f0102135:	68 a1 4d 10 f0       	push   $0xf0104da1
f010213a:	68 e5 4b 10 f0       	push   $0xf0104be5
f010213f:	68 50 03 00 00       	push   $0x350
f0102144:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102149:	e8 ea df ff ff       	call   f0100138 <_panic>
f010214e:	68 c0 46 10 f0       	push   $0xf01046c0
f0102153:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102158:	68 53 03 00 00       	push   $0x353
f010215d:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102162:	e8 d1 df ff ff       	call   f0100138 <_panic>
f0102167:	68 fc 46 10 f0       	push   $0xf01046fc
f010216c:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102171:	68 54 03 00 00       	push   $0x354
f0102176:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010217b:	e8 b8 df ff ff       	call   f0100138 <_panic>
f0102180:	68 15 4e 10 f0       	push   $0xf0104e15
f0102185:	68 e5 4b 10 f0       	push   $0xf0104be5
f010218a:	68 55 03 00 00       	push   $0x355
f010218f:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102194:	e8 9f df ff ff       	call   f0100138 <_panic>
f0102199:	68 a1 4d 10 f0       	push   $0xf0104da1
f010219e:	68 e5 4b 10 f0       	push   $0xf0104be5
f01021a3:	68 59 03 00 00       	push   $0x359
f01021a8:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01021ad:	e8 86 df ff ff       	call   f0100138 <_panic>
f01021b2:	53                   	push   %ebx
f01021b3:	68 ec 41 10 f0       	push   $0xf01041ec
f01021b8:	68 5c 03 00 00       	push   $0x35c
f01021bd:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01021c2:	e8 71 df ff ff       	call   f0100138 <_panic>
f01021c7:	68 2c 47 10 f0       	push   $0xf010472c
f01021cc:	68 e5 4b 10 f0       	push   $0xf0104be5
f01021d1:	68 5d 03 00 00       	push   $0x35d
f01021d6:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01021db:	e8 58 df ff ff       	call   f0100138 <_panic>
f01021e0:	68 70 47 10 f0       	push   $0xf0104770
f01021e5:	68 e5 4b 10 f0       	push   $0xf0104be5
f01021ea:	68 60 03 00 00       	push   $0x360
f01021ef:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01021f4:	e8 3f df ff ff       	call   f0100138 <_panic>
f01021f9:	68 fc 46 10 f0       	push   $0xf01046fc
f01021fe:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102203:	68 61 03 00 00       	push   $0x361
f0102208:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010220d:	e8 26 df ff ff       	call   f0100138 <_panic>
f0102212:	68 15 4e 10 f0       	push   $0xf0104e15
f0102217:	68 e5 4b 10 f0       	push   $0xf0104be5
f010221c:	68 62 03 00 00       	push   $0x362
f0102221:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102226:	e8 0d df ff ff       	call   f0100138 <_panic>
f010222b:	68 b4 47 10 f0       	push   $0xf01047b4
f0102230:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102235:	68 63 03 00 00       	push   $0x363
f010223a:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010223f:	e8 f4 de ff ff       	call   f0100138 <_panic>
f0102244:	68 26 4e 10 f0       	push   $0xf0104e26
f0102249:	68 e5 4b 10 f0       	push   $0xf0104be5
f010224e:	68 64 03 00 00       	push   $0x364
f0102253:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102258:	e8 db de ff ff       	call   f0100138 <_panic>
f010225d:	68 c0 46 10 f0       	push   $0xf01046c0
f0102262:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102267:	68 67 03 00 00       	push   $0x367
f010226c:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102271:	e8 c2 de ff ff       	call   f0100138 <_panic>
f0102276:	68 e8 47 10 f0       	push   $0xf01047e8
f010227b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102280:	68 68 03 00 00       	push   $0x368
f0102285:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010228a:	e8 a9 de ff ff       	call   f0100138 <_panic>
f010228f:	68 1c 48 10 f0       	push   $0xf010481c
f0102294:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102299:	68 69 03 00 00       	push   $0x369
f010229e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01022a3:	e8 90 de ff ff       	call   f0100138 <_panic>
f01022a8:	68 54 48 10 f0       	push   $0xf0104854
f01022ad:	68 e5 4b 10 f0       	push   $0xf0104be5
f01022b2:	68 6c 03 00 00       	push   $0x36c
f01022b7:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01022bc:	e8 77 de ff ff       	call   f0100138 <_panic>
f01022c1:	68 90 48 10 f0       	push   $0xf0104890
f01022c6:	68 e5 4b 10 f0       	push   $0xf0104be5
f01022cb:	68 6f 03 00 00       	push   $0x36f
f01022d0:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01022d5:	e8 5e de ff ff       	call   f0100138 <_panic>
f01022da:	68 1c 48 10 f0       	push   $0xf010481c
f01022df:	68 e5 4b 10 f0       	push   $0xf0104be5
f01022e4:	68 70 03 00 00       	push   $0x370
f01022e9:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01022ee:	e8 45 de ff ff       	call   f0100138 <_panic>
f01022f3:	68 cc 48 10 f0       	push   $0xf01048cc
f01022f8:	68 e5 4b 10 f0       	push   $0xf0104be5
f01022fd:	68 73 03 00 00       	push   $0x373
f0102302:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102307:	e8 2c de ff ff       	call   f0100138 <_panic>
f010230c:	68 f8 48 10 f0       	push   $0xf01048f8
f0102311:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102316:	68 74 03 00 00       	push   $0x374
f010231b:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102320:	e8 13 de ff ff       	call   f0100138 <_panic>
f0102325:	68 3c 4e 10 f0       	push   $0xf0104e3c
f010232a:	68 e5 4b 10 f0       	push   $0xf0104be5
f010232f:	68 76 03 00 00       	push   $0x376
f0102334:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102339:	e8 fa dd ff ff       	call   f0100138 <_panic>
f010233e:	68 4d 4e 10 f0       	push   $0xf0104e4d
f0102343:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102348:	68 77 03 00 00       	push   $0x377
f010234d:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102352:	e8 e1 dd ff ff       	call   f0100138 <_panic>
f0102357:	68 28 49 10 f0       	push   $0xf0104928
f010235c:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102361:	68 7a 03 00 00       	push   $0x37a
f0102366:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010236b:	e8 c8 dd ff ff       	call   f0100138 <_panic>
f0102370:	68 4c 49 10 f0       	push   $0xf010494c
f0102375:	68 e5 4b 10 f0       	push   $0xf0104be5
f010237a:	68 7e 03 00 00       	push   $0x37e
f010237f:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102384:	e8 af dd ff ff       	call   f0100138 <_panic>
f0102389:	68 f8 48 10 f0       	push   $0xf01048f8
f010238e:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102393:	68 7f 03 00 00       	push   $0x37f
f0102398:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010239d:	e8 96 dd ff ff       	call   f0100138 <_panic>
f01023a2:	68 f3 4d 10 f0       	push   $0xf0104df3
f01023a7:	68 e5 4b 10 f0       	push   $0xf0104be5
f01023ac:	68 80 03 00 00       	push   $0x380
f01023b1:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01023b6:	e8 7d dd ff ff       	call   f0100138 <_panic>
f01023bb:	68 4d 4e 10 f0       	push   $0xf0104e4d
f01023c0:	68 e5 4b 10 f0       	push   $0xf0104be5
f01023c5:	68 81 03 00 00       	push   $0x381
f01023ca:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01023cf:	e8 64 dd ff ff       	call   f0100138 <_panic>
f01023d4:	68 70 49 10 f0       	push   $0xf0104970
f01023d9:	68 e5 4b 10 f0       	push   $0xf0104be5
f01023de:	68 84 03 00 00       	push   $0x384
f01023e3:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01023e8:	e8 4b dd ff ff       	call   f0100138 <_panic>
f01023ed:	68 5e 4e 10 f0       	push   $0xf0104e5e
f01023f2:	68 e5 4b 10 f0       	push   $0xf0104be5
f01023f7:	68 85 03 00 00       	push   $0x385
f01023fc:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102401:	e8 32 dd ff ff       	call   f0100138 <_panic>
f0102406:	68 6a 4e 10 f0       	push   $0xf0104e6a
f010240b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102410:	68 86 03 00 00       	push   $0x386
f0102415:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010241a:	e8 19 dd ff ff       	call   f0100138 <_panic>
f010241f:	68 4c 49 10 f0       	push   $0xf010494c
f0102424:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102429:	68 8a 03 00 00       	push   $0x38a
f010242e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102433:	e8 00 dd ff ff       	call   f0100138 <_panic>
f0102438:	68 a8 49 10 f0       	push   $0xf01049a8
f010243d:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102442:	68 8b 03 00 00       	push   $0x38b
f0102447:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010244c:	e8 e7 dc ff ff       	call   f0100138 <_panic>
f0102451:	68 7f 4e 10 f0       	push   $0xf0104e7f
f0102456:	68 e5 4b 10 f0       	push   $0xf0104be5
f010245b:	68 8c 03 00 00       	push   $0x38c
f0102460:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102465:	e8 ce dc ff ff       	call   f0100138 <_panic>
f010246a:	68 4d 4e 10 f0       	push   $0xf0104e4d
f010246f:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102474:	68 8d 03 00 00       	push   $0x38d
f0102479:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010247e:	e8 b5 dc ff ff       	call   f0100138 <_panic>
f0102483:	68 d0 49 10 f0       	push   $0xf01049d0
f0102488:	68 e5 4b 10 f0       	push   $0xf0104be5
f010248d:	68 90 03 00 00       	push   $0x390
f0102492:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102497:	e8 9c dc ff ff       	call   f0100138 <_panic>
f010249c:	68 a1 4d 10 f0       	push   $0xf0104da1
f01024a1:	68 e5 4b 10 f0       	push   $0xf0104be5
f01024a6:	68 93 03 00 00       	push   $0x393
f01024ab:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01024b0:	e8 83 dc ff ff       	call   f0100138 <_panic>
f01024b5:	68 68 46 10 f0       	push   $0xf0104668
f01024ba:	68 e5 4b 10 f0       	push   $0xf0104be5
f01024bf:	68 96 03 00 00       	push   $0x396
f01024c4:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01024c9:	e8 6a dc ff ff       	call   f0100138 <_panic>
f01024ce:	68 04 4e 10 f0       	push   $0xf0104e04
f01024d3:	68 e5 4b 10 f0       	push   $0xf0104be5
f01024d8:	68 98 03 00 00       	push   $0x398
f01024dd:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01024e2:	e8 51 dc ff ff       	call   f0100138 <_panic>
f01024e7:	53                   	push   %ebx
f01024e8:	68 ec 41 10 f0       	push   $0xf01041ec
f01024ed:	68 9f 03 00 00       	push   $0x39f
f01024f2:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01024f7:	e8 3c dc ff ff       	call   f0100138 <_panic>
f01024fc:	68 90 4e 10 f0       	push   $0xf0104e90
f0102501:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102506:	68 a4 03 00 00       	push   $0x3a4
f010250b:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102510:	e8 23 dc ff ff       	call   f0100138 <_panic>
f0102515:	52                   	push   %edx
f0102516:	68 ec 41 10 f0       	push   $0xf01041ec
f010251b:	6a 52                	push   $0x52
f010251d:	68 06 4c 10 f0       	push   $0xf0104c06
f0102522:	e8 11 dc ff ff       	call   f0100138 <_panic>
f0102527:	52                   	push   %edx
f0102528:	68 ec 41 10 f0       	push   $0xf01041ec
f010252d:	6a 52                	push   $0x52
f010252f:	68 06 4c 10 f0       	push   $0xf0104c06
f0102534:	e8 ff db ff ff       	call   f0100138 <_panic>
f0102539:	68 a8 4e 10 f0       	push   $0xf0104ea8
f010253e:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102543:	68 ae 03 00 00       	push   $0x3ae
f0102548:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010254d:	e8 e6 db ff ff       	call   f0100138 <_panic>
f0102552:	ff 75 d0             	push   -0x30(%ebp)
f0102555:	68 90 43 10 f0       	push   $0xf0104390
f010255a:	68 ee 02 00 00       	push   $0x2ee
f010255f:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102564:	e8 cf db ff ff       	call   f0100138 <_panic>
f0102569:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010256f:	39 f3                	cmp    %esi,%ebx
f0102571:	76 37                	jbe    f01025aa <mem_init+0x13ad>
f0102573:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f0102579:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010257c:	e8 1b e4 ff ff       	call   f010099c <check_va2pa>
f0102581:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102588:	76 c8                	jbe    f0102552 <mem_init+0x1355>
f010258a:	8d 14 3e             	lea    (%esi,%edi,1),%edx
f010258d:	39 d0                	cmp    %edx,%eax
f010258f:	74 d8                	je     f0102569 <mem_init+0x136c>
f0102591:	68 54 4a 10 f0       	push   $0xf0104a54
f0102596:	68 e5 4b 10 f0       	push   $0xf0104be5
f010259b:	68 ee 02 00 00       	push   $0x2ee
f01025a0:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01025a5:	e8 8e db ff ff       	call   f0100138 <_panic>
f01025aa:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f01025ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01025b0:	c1 e0 0c             	shl    $0xc,%eax
f01025b3:	89 de                	mov    %ebx,%esi
f01025b5:	89 c7                	mov    %eax,%edi
f01025b7:	39 fe                	cmp    %edi,%esi
f01025b9:	73 33                	jae    f01025ee <mem_init+0x13f1>
f01025bb:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f01025c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01025c4:	e8 d3 e3 ff ff       	call   f010099c <check_va2pa>
f01025c9:	39 c6                	cmp    %eax,%esi
f01025cb:	75 08                	jne    f01025d5 <mem_init+0x13d8>
f01025cd:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01025d3:	eb e2                	jmp    f01025b7 <mem_init+0x13ba>
f01025d5:	68 88 4a 10 f0       	push   $0xf0104a88
f01025da:	68 e5 4b 10 f0       	push   $0xf0104be5
f01025df:	68 f3 02 00 00       	push   $0x2f3
f01025e4:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01025e9:	e8 4a db ff ff       	call   f0100138 <_panic>
f01025ee:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01025f1:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01025f6:	89 f2                	mov    %esi,%edx
f01025f8:	89 f8                	mov    %edi,%eax
f01025fa:	e8 9d e3 ff ff       	call   f010099c <check_va2pa>
f01025ff:	b9 00 e0 10 f0       	mov    $0xf010e000,%ecx
f0102604:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f010260a:	76 42                	jbe    f010264e <mem_init+0x1451>
f010260c:	8d 96 00 60 11 10    	lea    0x10116000(%esi),%edx
f0102612:	39 d0                	cmp    %edx,%eax
f0102614:	75 4d                	jne    f0102663 <mem_init+0x1466>
f0102616:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010261c:	81 fe 00 00 00 f0    	cmp    $0xf0000000,%esi
f0102622:	75 d2                	jne    f01025f6 <mem_init+0x13f9>
f0102624:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102629:	89 f8                	mov    %edi,%eax
f010262b:	e8 6c e3 ff ff       	call   f010099c <check_va2pa>
f0102630:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102633:	74 72                	je     f01026a7 <mem_init+0x14aa>
f0102635:	68 f8 4a 10 f0       	push   $0xf0104af8
f010263a:	68 e5 4b 10 f0       	push   $0xf0104be5
f010263f:	68 f8 02 00 00       	push   $0x2f8
f0102644:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102649:	e8 ea da ff ff       	call   f0100138 <_panic>
f010264e:	51                   	push   %ecx
f010264f:	68 90 43 10 f0       	push   $0xf0104390
f0102654:	68 f7 02 00 00       	push   $0x2f7
f0102659:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010265e:	e8 d5 da ff ff       	call   f0100138 <_panic>
f0102663:	68 b0 4a 10 f0       	push   $0xf0104ab0
f0102668:	68 e5 4b 10 f0       	push   $0xf0104be5
f010266d:	68 f7 02 00 00       	push   $0x2f7
f0102672:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102677:	e8 bc da ff ff       	call   f0100138 <_panic>
f010267c:	81 fb bf 03 00 00    	cmp    $0x3bf,%ebx
f0102682:	75 23                	jne    f01026a7 <mem_init+0x14aa>
f0102684:	f6 04 9f 01          	testb  $0x1,(%edi,%ebx,4)
f0102688:	74 44                	je     f01026ce <mem_init+0x14d1>
f010268a:	43                   	inc    %ebx
f010268b:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f0102691:	0f 87 8d 00 00 00    	ja     f0102724 <mem_init+0x1527>
f0102697:	81 fb bd 03 00 00    	cmp    $0x3bd,%ebx
f010269d:	77 dd                	ja     f010267c <mem_init+0x147f>
f010269f:	81 fb bb 03 00 00    	cmp    $0x3bb,%ebx
f01026a5:	77 dd                	ja     f0102684 <mem_init+0x1487>
f01026a7:	81 fb bf 03 00 00    	cmp    $0x3bf,%ebx
f01026ad:	77 38                	ja     f01026e7 <mem_init+0x14ea>
f01026af:	83 3c 9f 00          	cmpl   $0x0,(%edi,%ebx,4)
f01026b3:	74 d5                	je     f010268a <mem_init+0x148d>
f01026b5:	68 fa 4e 10 f0       	push   $0xf0104efa
f01026ba:	68 e5 4b 10 f0       	push   $0xf0104be5
f01026bf:	68 07 03 00 00       	push   $0x307
f01026c4:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01026c9:	e8 6a da ff ff       	call   f0100138 <_panic>
f01026ce:	68 d8 4e 10 f0       	push   $0xf0104ed8
f01026d3:	68 e5 4b 10 f0       	push   $0xf0104be5
f01026d8:	68 00 03 00 00       	push   $0x300
f01026dd:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01026e2:	e8 51 da ff ff       	call   f0100138 <_panic>
f01026e7:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
f01026ea:	a8 01                	test   $0x1,%al
f01026ec:	74 1d                	je     f010270b <mem_init+0x150e>
f01026ee:	a8 02                	test   $0x2,%al
f01026f0:	75 98                	jne    f010268a <mem_init+0x148d>
f01026f2:	68 e9 4e 10 f0       	push   $0xf0104ee9
f01026f7:	68 e5 4b 10 f0       	push   $0xf0104be5
f01026fc:	68 05 03 00 00       	push   $0x305
f0102701:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102706:	e8 2d da ff ff       	call   f0100138 <_panic>
f010270b:	68 d8 4e 10 f0       	push   $0xf0104ed8
f0102710:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102715:	68 04 03 00 00       	push   $0x304
f010271a:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010271f:	e8 14 da ff ff       	call   f0100138 <_panic>
f0102724:	83 ec 0c             	sub    $0xc,%esp
f0102727:	68 28 4b 10 f0       	push   $0xf0104b28
f010272c:	e8 02 04 00 00       	call   f0102b33 <cprintf>
f0102731:	a1 5c 85 11 f0       	mov    0xf011855c,%eax
f0102736:	83 c4 10             	add    $0x10,%esp
f0102739:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010273e:	0f 86 06 02 00 00    	jbe    f010294a <mem_init+0x174d>
f0102744:	05 00 00 00 10       	add    $0x10000000,%eax
f0102749:	0f 22 d8             	mov    %eax,%cr3
f010274c:	b8 00 00 00 00       	mov    $0x0,%eax
f0102751:	e8 a6 e2 ff ff       	call   f01009fc <check_page_free_list>
f0102756:	0f 20 c0             	mov    %cr0,%eax
f0102759:	83 e0 f3             	and    $0xfffffff3,%eax
f010275c:	0d 23 00 05 80       	or     $0x80050023,%eax
f0102761:	0f 22 c0             	mov    %eax,%cr0
f0102764:	83 ec 0c             	sub    $0xc,%esp
f0102767:	6a 00                	push   $0x0
f0102769:	e8 10 e7 ff ff       	call   f0100e7e <page_alloc>
f010276e:	89 c3                	mov    %eax,%ebx
f0102770:	83 c4 10             	add    $0x10,%esp
f0102773:	85 c0                	test   %eax,%eax
f0102775:	0f 84 e4 01 00 00    	je     f010295f <mem_init+0x1762>
f010277b:	83 ec 0c             	sub    $0xc,%esp
f010277e:	6a 00                	push   $0x0
f0102780:	e8 f9 e6 ff ff       	call   f0100e7e <page_alloc>
f0102785:	89 c7                	mov    %eax,%edi
f0102787:	83 c4 10             	add    $0x10,%esp
f010278a:	85 c0                	test   %eax,%eax
f010278c:	0f 84 e6 01 00 00    	je     f0102978 <mem_init+0x177b>
f0102792:	83 ec 0c             	sub    $0xc,%esp
f0102795:	6a 00                	push   $0x0
f0102797:	e8 e2 e6 ff ff       	call   f0100e7e <page_alloc>
f010279c:	89 c6                	mov    %eax,%esi
f010279e:	83 c4 10             	add    $0x10,%esp
f01027a1:	85 c0                	test   %eax,%eax
f01027a3:	0f 84 e8 01 00 00    	je     f0102991 <mem_init+0x1794>
f01027a9:	83 ec 0c             	sub    $0xc,%esp
f01027ac:	53                   	push   %ebx
f01027ad:	e8 47 e7 ff ff       	call   f0100ef9 <page_free>
f01027b2:	89 f8                	mov    %edi,%eax
f01027b4:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f01027ba:	c1 f8 03             	sar    $0x3,%eax
f01027bd:	89 c2                	mov    %eax,%edx
f01027bf:	c1 e2 0c             	shl    $0xc,%edx
f01027c2:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01027c7:	83 c4 10             	add    $0x10,%esp
f01027ca:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f01027d0:	0f 83 d4 01 00 00    	jae    f01029aa <mem_init+0x17ad>
f01027d6:	83 ec 04             	sub    $0x4,%esp
f01027d9:	68 00 10 00 00       	push   $0x1000
f01027de:	6a 01                	push   $0x1
f01027e0:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01027e6:	52                   	push   %edx
f01027e7:	e8 b2 0e 00 00       	call   f010369e <memset>
f01027ec:	89 f0                	mov    %esi,%eax
f01027ee:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f01027f4:	c1 f8 03             	sar    $0x3,%eax
f01027f7:	89 c2                	mov    %eax,%edx
f01027f9:	c1 e2 0c             	shl    $0xc,%edx
f01027fc:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102801:	83 c4 10             	add    $0x10,%esp
f0102804:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f010280a:	0f 83 ac 01 00 00    	jae    f01029bc <mem_init+0x17bf>
f0102810:	83 ec 04             	sub    $0x4,%esp
f0102813:	68 00 10 00 00       	push   $0x1000
f0102818:	6a 02                	push   $0x2
f010281a:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102820:	52                   	push   %edx
f0102821:	e8 78 0e 00 00       	call   f010369e <memset>
f0102826:	6a 02                	push   $0x2
f0102828:	68 00 10 00 00       	push   $0x1000
f010282d:	57                   	push   %edi
f010282e:	ff 35 5c 85 11 f0    	push   0xf011855c
f0102834:	e8 a2 e8 ff ff       	call   f01010db <page_insert>
f0102839:	83 c4 20             	add    $0x20,%esp
f010283c:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102841:	0f 85 87 01 00 00    	jne    f01029ce <mem_init+0x17d1>
f0102847:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f010284e:	01 01 01 
f0102851:	0f 85 90 01 00 00    	jne    f01029e7 <mem_init+0x17ea>
f0102857:	6a 02                	push   $0x2
f0102859:	68 00 10 00 00       	push   $0x1000
f010285e:	56                   	push   %esi
f010285f:	ff 35 5c 85 11 f0    	push   0xf011855c
f0102865:	e8 71 e8 ff ff       	call   f01010db <page_insert>
f010286a:	83 c4 10             	add    $0x10,%esp
f010286d:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102874:	02 02 02 
f0102877:	0f 85 83 01 00 00    	jne    f0102a00 <mem_init+0x1803>
f010287d:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102882:	0f 85 91 01 00 00    	jne    f0102a19 <mem_init+0x181c>
f0102888:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010288d:	0f 85 9f 01 00 00    	jne    f0102a32 <mem_init+0x1835>
f0102893:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f010289a:	03 03 03 
f010289d:	89 f0                	mov    %esi,%eax
f010289f:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f01028a5:	c1 f8 03             	sar    $0x3,%eax
f01028a8:	89 c2                	mov    %eax,%edx
f01028aa:	c1 e2 0c             	shl    $0xc,%edx
f01028ad:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01028b2:	3b 05 60 85 11 f0    	cmp    0xf0118560,%eax
f01028b8:	0f 83 8d 01 00 00    	jae    f0102a4b <mem_init+0x184e>
f01028be:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f01028c5:	03 03 03 
f01028c8:	0f 85 8f 01 00 00    	jne    f0102a5d <mem_init+0x1860>
f01028ce:	83 ec 08             	sub    $0x8,%esp
f01028d1:	68 00 10 00 00       	push   $0x1000
f01028d6:	ff 35 5c 85 11 f0    	push   0xf011855c
f01028dc:	e8 b9 e7 ff ff       	call   f010109a <page_remove>
f01028e1:	83 c4 10             	add    $0x10,%esp
f01028e4:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01028e9:	0f 85 87 01 00 00    	jne    f0102a76 <mem_init+0x1879>
f01028ef:	8b 0d 5c 85 11 f0    	mov    0xf011855c,%ecx
f01028f5:	8b 11                	mov    (%ecx),%edx
f01028f7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01028fd:	89 d8                	mov    %ebx,%eax
f01028ff:	2b 05 58 85 11 f0    	sub    0xf0118558,%eax
f0102905:	c1 f8 03             	sar    $0x3,%eax
f0102908:	c1 e0 0c             	shl    $0xc,%eax
f010290b:	39 c2                	cmp    %eax,%edx
f010290d:	0f 85 7c 01 00 00    	jne    f0102a8f <mem_init+0x1892>
f0102913:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0102919:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010291e:	0f 85 84 01 00 00    	jne    f0102aa8 <mem_init+0x18ab>
f0102924:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
f010292a:	83 ec 0c             	sub    $0xc,%esp
f010292d:	53                   	push   %ebx
f010292e:	e8 c6 e5 ff ff       	call   f0100ef9 <page_free>
f0102933:	c7 04 24 bc 4b 10 f0 	movl   $0xf0104bbc,(%esp)
f010293a:	e8 f4 01 00 00       	call   f0102b33 <cprintf>
f010293f:	83 c4 10             	add    $0x10,%esp
f0102942:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102945:	5b                   	pop    %ebx
f0102946:	5e                   	pop    %esi
f0102947:	5f                   	pop    %edi
f0102948:	5d                   	pop    %ebp
f0102949:	c3                   	ret    
f010294a:	50                   	push   %eax
f010294b:	68 90 43 10 f0       	push   $0xf0104390
f0102950:	68 e3 00 00 00       	push   $0xe3
f0102955:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010295a:	e8 d9 d7 ff ff       	call   f0100138 <_panic>
f010295f:	68 4d 4d 10 f0       	push   $0xf0104d4d
f0102964:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102969:	68 c8 03 00 00       	push   $0x3c8
f010296e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102973:	e8 c0 d7 ff ff       	call   f0100138 <_panic>
f0102978:	68 63 4d 10 f0       	push   $0xf0104d63
f010297d:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102982:	68 c9 03 00 00       	push   $0x3c9
f0102987:	68 fa 4b 10 f0       	push   $0xf0104bfa
f010298c:	e8 a7 d7 ff ff       	call   f0100138 <_panic>
f0102991:	68 79 4d 10 f0       	push   $0xf0104d79
f0102996:	68 e5 4b 10 f0       	push   $0xf0104be5
f010299b:	68 ca 03 00 00       	push   $0x3ca
f01029a0:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01029a5:	e8 8e d7 ff ff       	call   f0100138 <_panic>
f01029aa:	52                   	push   %edx
f01029ab:	68 ec 41 10 f0       	push   $0xf01041ec
f01029b0:	6a 52                	push   $0x52
f01029b2:	68 06 4c 10 f0       	push   $0xf0104c06
f01029b7:	e8 7c d7 ff ff       	call   f0100138 <_panic>
f01029bc:	52                   	push   %edx
f01029bd:	68 ec 41 10 f0       	push   $0xf01041ec
f01029c2:	6a 52                	push   $0x52
f01029c4:	68 06 4c 10 f0       	push   $0xf0104c06
f01029c9:	e8 6a d7 ff ff       	call   f0100138 <_panic>
f01029ce:	68 f3 4d 10 f0       	push   $0xf0104df3
f01029d3:	68 e5 4b 10 f0       	push   $0xf0104be5
f01029d8:	68 cf 03 00 00       	push   $0x3cf
f01029dd:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01029e2:	e8 51 d7 ff ff       	call   f0100138 <_panic>
f01029e7:	68 48 4b 10 f0       	push   $0xf0104b48
f01029ec:	68 e5 4b 10 f0       	push   $0xf0104be5
f01029f1:	68 d0 03 00 00       	push   $0x3d0
f01029f6:	68 fa 4b 10 f0       	push   $0xf0104bfa
f01029fb:	e8 38 d7 ff ff       	call   f0100138 <_panic>
f0102a00:	68 6c 4b 10 f0       	push   $0xf0104b6c
f0102a05:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102a0a:	68 d2 03 00 00       	push   $0x3d2
f0102a0f:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102a14:	e8 1f d7 ff ff       	call   f0100138 <_panic>
f0102a19:	68 15 4e 10 f0       	push   $0xf0104e15
f0102a1e:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102a23:	68 d3 03 00 00       	push   $0x3d3
f0102a28:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102a2d:	e8 06 d7 ff ff       	call   f0100138 <_panic>
f0102a32:	68 7f 4e 10 f0       	push   $0xf0104e7f
f0102a37:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102a3c:	68 d4 03 00 00       	push   $0x3d4
f0102a41:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102a46:	e8 ed d6 ff ff       	call   f0100138 <_panic>
f0102a4b:	52                   	push   %edx
f0102a4c:	68 ec 41 10 f0       	push   $0xf01041ec
f0102a51:	6a 52                	push   $0x52
f0102a53:	68 06 4c 10 f0       	push   $0xf0104c06
f0102a58:	e8 db d6 ff ff       	call   f0100138 <_panic>
f0102a5d:	68 90 4b 10 f0       	push   $0xf0104b90
f0102a62:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102a67:	68 d6 03 00 00       	push   $0x3d6
f0102a6c:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102a71:	e8 c2 d6 ff ff       	call   f0100138 <_panic>
f0102a76:	68 4d 4e 10 f0       	push   $0xf0104e4d
f0102a7b:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102a80:	68 d8 03 00 00       	push   $0x3d8
f0102a85:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102a8a:	e8 a9 d6 ff ff       	call   f0100138 <_panic>
f0102a8f:	68 68 46 10 f0       	push   $0xf0104668
f0102a94:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102a99:	68 db 03 00 00       	push   $0x3db
f0102a9e:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102aa3:	e8 90 d6 ff ff       	call   f0100138 <_panic>
f0102aa8:	68 04 4e 10 f0       	push   $0xf0104e04
f0102aad:	68 e5 4b 10 f0       	push   $0xf0104be5
f0102ab2:	68 dd 03 00 00       	push   $0x3dd
f0102ab7:	68 fa 4b 10 f0       	push   $0xf0104bfa
f0102abc:	e8 77 d6 ff ff       	call   f0100138 <_panic>

f0102ac1 <tlb_invalidate>:
f0102ac1:	55                   	push   %ebp
f0102ac2:	89 e5                	mov    %esp,%ebp
f0102ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102ac7:	0f 01 38             	invlpg (%eax)
f0102aca:	5d                   	pop    %ebp
f0102acb:	c3                   	ret    

f0102acc <mc146818_read>:
f0102acc:	55                   	push   %ebp
f0102acd:	89 e5                	mov    %esp,%ebp
f0102acf:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ad2:	ba 70 00 00 00       	mov    $0x70,%edx
f0102ad7:	ee                   	out    %al,(%dx)
f0102ad8:	ba 71 00 00 00       	mov    $0x71,%edx
f0102add:	ec                   	in     (%dx),%al
f0102ade:	0f b6 c0             	movzbl %al,%eax
f0102ae1:	5d                   	pop    %ebp
f0102ae2:	c3                   	ret    

f0102ae3 <mc146818_write>:
f0102ae3:	55                   	push   %ebp
f0102ae4:	89 e5                	mov    %esp,%ebp
f0102ae6:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ae9:	ba 70 00 00 00       	mov    $0x70,%edx
f0102aee:	ee                   	out    %al,(%dx)
f0102aef:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102af2:	ba 71 00 00 00       	mov    $0x71,%edx
f0102af7:	ee                   	out    %al,(%dx)
f0102af8:	5d                   	pop    %ebp
f0102af9:	c3                   	ret    

f0102afa <putch>:
f0102afa:	55                   	push   %ebp
f0102afb:	89 e5                	mov    %esp,%ebp
f0102afd:	83 ec 14             	sub    $0x14,%esp
f0102b00:	ff 75 08             	push   0x8(%ebp)
f0102b03:	e8 64 db ff ff       	call   f010066c <cputchar>
f0102b08:	83 c4 10             	add    $0x10,%esp
f0102b0b:	c9                   	leave  
f0102b0c:	c3                   	ret    

f0102b0d <vcprintf>:
f0102b0d:	55                   	push   %ebp
f0102b0e:	89 e5                	mov    %esp,%ebp
f0102b10:	83 ec 18             	sub    $0x18,%esp
f0102b13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102b1a:	ff 75 0c             	push   0xc(%ebp)
f0102b1d:	ff 75 08             	push   0x8(%ebp)
f0102b20:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0102b23:	50                   	push   %eax
f0102b24:	68 fa 2a 10 f0       	push   $0xf0102afa
f0102b29:	e8 46 04 00 00       	call   f0102f74 <vprintfmt>
f0102b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102b31:	c9                   	leave  
f0102b32:	c3                   	ret    

f0102b33 <cprintf>:
f0102b33:	55                   	push   %ebp
f0102b34:	89 e5                	mov    %esp,%ebp
f0102b36:	83 ec 10             	sub    $0x10,%esp
f0102b39:	8d 45 0c             	lea    0xc(%ebp),%eax
f0102b3c:	50                   	push   %eax
f0102b3d:	ff 75 08             	push   0x8(%ebp)
f0102b40:	e8 c8 ff ff ff       	call   f0102b0d <vcprintf>
f0102b45:	c9                   	leave  
f0102b46:	c3                   	ret    

f0102b47 <memCprintf>:
f0102b47:	55                   	push   %ebp
f0102b48:	89 e5                	mov    %esp,%ebp
f0102b4a:	83 ec 10             	sub    $0x10,%esp
f0102b4d:	ff 75 18             	push   0x18(%ebp)
f0102b50:	ff 75 14             	push   0x14(%ebp)
f0102b53:	ff 75 10             	push   0x10(%ebp)
f0102b56:	ff 75 0c             	push   0xc(%ebp)
f0102b59:	ff 75 08             	push   0x8(%ebp)
f0102b5c:	68 08 4f 10 f0       	push   $0xf0104f08
f0102b61:	e8 cd ff ff ff       	call   f0102b33 <cprintf>
f0102b66:	c9                   	leave  
f0102b67:	c3                   	ret    

f0102b68 <stab_binsearch>:
f0102b68:	55                   	push   %ebp
f0102b69:	89 e5                	mov    %esp,%ebp
f0102b6b:	57                   	push   %edi
f0102b6c:	56                   	push   %esi
f0102b6d:	53                   	push   %ebx
f0102b6e:	83 ec 14             	sub    $0x14,%esp
f0102b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0102b74:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0102b77:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0102b7a:	8b 75 08             	mov    0x8(%ebp),%esi
f0102b7d:	8b 1a                	mov    (%edx),%ebx
f0102b7f:	8b 39                	mov    (%ecx),%edi
f0102b81:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0102b88:	eb 31                	jmp    f0102bbb <stab_binsearch+0x53>
f0102b8a:	48                   	dec    %eax
f0102b8b:	39 c3                	cmp    %eax,%ebx
f0102b8d:	7f 50                	jg     f0102bdf <stab_binsearch+0x77>
f0102b8f:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0102b93:	83 ea 0c             	sub    $0xc,%edx
f0102b96:	39 f1                	cmp    %esi,%ecx
f0102b98:	75 f0                	jne    f0102b8a <stab_binsearch+0x22>
f0102b9a:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102b9d:	01 c2                	add    %eax,%edx
f0102b9f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0102ba2:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0102ba6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0102ba9:	73 3a                	jae    f0102be5 <stab_binsearch+0x7d>
f0102bab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0102bae:	89 03                	mov    %eax,(%ebx)
f0102bb0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0102bb3:	43                   	inc    %ebx
f0102bb4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0102bbb:	39 fb                	cmp    %edi,%ebx
f0102bbd:	7f 4f                	jg     f0102c0e <stab_binsearch+0xa6>
f0102bbf:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f0102bc2:	89 d0                	mov    %edx,%eax
f0102bc4:	c1 e8 1f             	shr    $0x1f,%eax
f0102bc7:	01 d0                	add    %edx,%eax
f0102bc9:	89 c1                	mov    %eax,%ecx
f0102bcb:	d1 f9                	sar    %ecx
f0102bcd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
f0102bd0:	83 e0 fe             	and    $0xfffffffe,%eax
f0102bd3:	01 c8                	add    %ecx,%eax
f0102bd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0102bd8:	8d 14 82             	lea    (%edx,%eax,4),%edx
f0102bdb:	89 c8                	mov    %ecx,%eax
f0102bdd:	eb ac                	jmp    f0102b8b <stab_binsearch+0x23>
f0102bdf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0102be2:	43                   	inc    %ebx
f0102be3:	eb d6                	jmp    f0102bbb <stab_binsearch+0x53>
f0102be5:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0102be8:	76 11                	jbe    f0102bfb <stab_binsearch+0x93>
f0102bea:	8d 78 ff             	lea    -0x1(%eax),%edi
f0102bed:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102bf0:	89 38                	mov    %edi,(%eax)
f0102bf2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0102bf9:	eb c0                	jmp    f0102bbb <stab_binsearch+0x53>
f0102bfb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0102bfe:	89 03                	mov    %eax,(%ebx)
f0102c00:	ff 45 0c             	incl   0xc(%ebp)
f0102c03:	89 c3                	mov    %eax,%ebx
f0102c05:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0102c0c:	eb ad                	jmp    f0102bbb <stab_binsearch+0x53>
f0102c0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102c12:	75 13                	jne    f0102c27 <stab_binsearch+0xbf>
f0102c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102c17:	8b 00                	mov    (%eax),%eax
f0102c19:	48                   	dec    %eax
f0102c1a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0102c1d:	89 07                	mov    %eax,(%edi)
f0102c1f:	83 c4 14             	add    $0x14,%esp
f0102c22:	5b                   	pop    %ebx
f0102c23:	5e                   	pop    %esi
f0102c24:	5f                   	pop    %edi
f0102c25:	5d                   	pop    %ebp
f0102c26:	c3                   	ret    
f0102c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102c2a:	8b 00                	mov    (%eax),%eax
f0102c2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102c2f:	8b 0f                	mov    (%edi),%ecx
f0102c31:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102c34:	01 c2                	add    %eax,%edx
f0102c36:	8b 7d f0             	mov    -0x10(%ebp),%edi
f0102c39:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0102c3c:	39 c1                	cmp    %eax,%ecx
f0102c3e:	7d 0e                	jge    f0102c4e <stab_binsearch+0xe6>
f0102c40:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0102c44:	83 ea 0c             	sub    $0xc,%edx
f0102c47:	39 f3                	cmp    %esi,%ebx
f0102c49:	74 03                	je     f0102c4e <stab_binsearch+0xe6>
f0102c4b:	48                   	dec    %eax
f0102c4c:	eb ee                	jmp    f0102c3c <stab_binsearch+0xd4>
f0102c4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102c51:	89 07                	mov    %eax,(%edi)
f0102c53:	eb ca                	jmp    f0102c1f <stab_binsearch+0xb7>

f0102c55 <debuginfo_eip>:
f0102c55:	55                   	push   %ebp
f0102c56:	89 e5                	mov    %esp,%ebp
f0102c58:	57                   	push   %edi
f0102c59:	56                   	push   %esi
f0102c5a:	53                   	push   %ebx
f0102c5b:	83 ec 3c             	sub    $0x3c,%esp
f0102c5e:	8b 7d 08             	mov    0x8(%ebp),%edi
f0102c61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102c64:	c7 03 58 4f 10 f0    	movl   $0xf0104f58,(%ebx)
f0102c6a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
f0102c71:	c7 43 08 58 4f 10 f0 	movl   $0xf0104f58,0x8(%ebx)
f0102c78:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
f0102c7f:	89 7b 10             	mov    %edi,0x10(%ebx)
f0102c82:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
f0102c89:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0102c8f:	0f 86 51 01 00 00    	jbe    f0102de6 <debuginfo_eip+0x191>
f0102c95:	b8 5a da 10 f0       	mov    $0xf010da5a,%eax
f0102c9a:	3d ad bb 10 f0       	cmp    $0xf010bbad,%eax
f0102c9f:	0f 86 c8 01 00 00    	jbe    f0102e6d <debuginfo_eip+0x218>
f0102ca5:	80 3d 59 da 10 f0 00 	cmpb   $0x0,0xf010da59
f0102cac:	0f 85 c2 01 00 00    	jne    f0102e74 <debuginfo_eip+0x21f>
f0102cb2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0102cb9:	b8 ac bb 10 f0       	mov    $0xf010bbac,%eax
f0102cbe:	2d 8c 51 10 f0       	sub    $0xf010518c,%eax
f0102cc3:	89 c2                	mov    %eax,%edx
f0102cc5:	c1 fa 02             	sar    $0x2,%edx
f0102cc8:	83 e0 fc             	and    $0xfffffffc,%eax
f0102ccb:	01 d0                	add    %edx,%eax
f0102ccd:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102cd0:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102cd3:	89 c1                	mov    %eax,%ecx
f0102cd5:	c1 e1 08             	shl    $0x8,%ecx
f0102cd8:	01 c8                	add    %ecx,%eax
f0102cda:	89 c1                	mov    %eax,%ecx
f0102cdc:	c1 e1 10             	shl    $0x10,%ecx
f0102cdf:	01 c8                	add    %ecx,%eax
f0102ce1:	01 c0                	add    %eax,%eax
f0102ce3:	8d 44 02 ff          	lea    -0x1(%edx,%eax,1),%eax
f0102ce7:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102cea:	83 ec 08             	sub    $0x8,%esp
f0102ced:	57                   	push   %edi
f0102cee:	6a 64                	push   $0x64
f0102cf0:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0102cf3:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0102cf6:	b8 8c 51 10 f0       	mov    $0xf010518c,%eax
f0102cfb:	e8 68 fe ff ff       	call   f0102b68 <stab_binsearch>
f0102d00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0102d03:	83 c4 10             	add    $0x10,%esp
f0102d06:	85 f6                	test   %esi,%esi
f0102d08:	0f 84 6d 01 00 00    	je     f0102e7b <debuginfo_eip+0x226>
f0102d0e:	89 75 dc             	mov    %esi,-0x24(%ebp)
f0102d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102d14:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102d17:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102d1a:	83 ec 08             	sub    $0x8,%esp
f0102d1d:	57                   	push   %edi
f0102d1e:	6a 24                	push   $0x24
f0102d20:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0102d23:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0102d26:	b8 8c 51 10 f0       	mov    $0xf010518c,%eax
f0102d2b:	e8 38 fe ff ff       	call   f0102b68 <stab_binsearch>
f0102d30:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102d33:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102d36:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0102d39:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f0102d3c:	83 c4 10             	add    $0x10,%esp
f0102d3f:	39 c8                	cmp    %ecx,%eax
f0102d41:	0f 8f b3 00 00 00    	jg     f0102dfa <debuginfo_eip+0x1a5>
f0102d47:	89 c1                	mov    %eax,%ecx
f0102d49:	01 c0                	add    %eax,%eax
f0102d4b:	01 c8                	add    %ecx,%eax
f0102d4d:	c1 e0 02             	shl    $0x2,%eax
f0102d50:	8d 90 8c 51 10 f0    	lea    -0xfefae74(%eax),%edx
f0102d56:	8b 88 8c 51 10 f0    	mov    -0xfefae74(%eax),%ecx
f0102d5c:	b8 5a da 10 f0       	mov    $0xf010da5a,%eax
f0102d61:	2d ad bb 10 f0       	sub    $0xf010bbad,%eax
f0102d66:	39 c1                	cmp    %eax,%ecx
f0102d68:	73 09                	jae    f0102d73 <debuginfo_eip+0x11e>
f0102d6a:	81 c1 ad bb 10 f0    	add    $0xf010bbad,%ecx
f0102d70:	89 4b 08             	mov    %ecx,0x8(%ebx)
f0102d73:	8b 42 08             	mov    0x8(%edx),%eax
f0102d76:	89 43 10             	mov    %eax,0x10(%ebx)
f0102d79:	29 c7                	sub    %eax,%edi
f0102d7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0102d7e:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0102d81:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0102d84:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102d87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0102d8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102d8d:	83 ec 08             	sub    $0x8,%esp
f0102d90:	6a 3a                	push   $0x3a
f0102d92:	ff 73 08             	push   0x8(%ebx)
f0102d95:	e8 ec 08 00 00       	call   f0103686 <strfind>
f0102d9a:	2b 43 08             	sub    0x8(%ebx),%eax
f0102d9d:	89 43 0c             	mov    %eax,0xc(%ebx)
f0102da0:	83 c4 08             	add    $0x8,%esp
f0102da3:	89 f8                	mov    %edi,%eax
f0102da5:	03 43 10             	add    0x10(%ebx),%eax
f0102da8:	50                   	push   %eax
f0102da9:	6a 44                	push   $0x44
f0102dab:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0102dae:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0102db1:	b8 8c 51 10 f0       	mov    $0xf010518c,%eax
f0102db6:	e8 ad fd ff ff       	call   f0102b68 <stab_binsearch>
f0102dbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102dbe:	83 c4 10             	add    $0x10,%esp
f0102dc1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0102dc4:	7f 38                	jg     f0102dfe <debuginfo_eip+0x1a9>
f0102dc6:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102dc9:	01 c2                	add    %eax,%edx
f0102dcb:	0f b7 14 95 92 51 10 	movzwl -0xfefae6e(,%edx,4),%edx
f0102dd2:	f0 
f0102dd3:	89 53 04             	mov    %edx,0x4(%ebx)
f0102dd6:	89 c2                	mov    %eax,%edx
f0102dd8:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
f0102ddb:	01 c8                	add    %ecx,%eax
f0102ddd:	8d 04 85 8c 51 10 f0 	lea    -0xfefae74(,%eax,4),%eax
f0102de4:	eb 23                	jmp    f0102e09 <debuginfo_eip+0x1b4>
f0102de6:	83 ec 04             	sub    $0x4,%esp
f0102de9:	68 62 4f 10 f0       	push   $0xf0104f62
f0102dee:	6a 7d                	push   $0x7d
f0102df0:	68 6f 4f 10 f0       	push   $0xf0104f6f
f0102df5:	e8 3e d3 ff ff       	call   f0100138 <_panic>
f0102dfa:	89 f0                	mov    %esi,%eax
f0102dfc:	eb 86                	jmp    f0102d84 <debuginfo_eip+0x12f>
f0102dfe:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0102e03:	eb ce                	jmp    f0102dd3 <debuginfo_eip+0x17e>
f0102e05:	4a                   	dec    %edx
f0102e06:	83 e8 0c             	sub    $0xc,%eax
f0102e09:	39 d6                	cmp    %edx,%esi
f0102e0b:	7f 35                	jg     f0102e42 <debuginfo_eip+0x1ed>
f0102e0d:	8a 48 04             	mov    0x4(%eax),%cl
f0102e10:	80 f9 84             	cmp    $0x84,%cl
f0102e13:	74 0b                	je     f0102e20 <debuginfo_eip+0x1cb>
f0102e15:	80 f9 64             	cmp    $0x64,%cl
f0102e18:	75 eb                	jne    f0102e05 <debuginfo_eip+0x1b0>
f0102e1a:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
f0102e1e:	74 e5                	je     f0102e05 <debuginfo_eip+0x1b0>
f0102e20:	8d 04 12             	lea    (%edx,%edx,1),%eax
f0102e23:	01 d0                	add    %edx,%eax
f0102e25:	8b 14 85 8c 51 10 f0 	mov    -0xfefae74(,%eax,4),%edx
f0102e2c:	b8 5a da 10 f0       	mov    $0xf010da5a,%eax
f0102e31:	2d ad bb 10 f0       	sub    $0xf010bbad,%eax
f0102e36:	39 c2                	cmp    %eax,%edx
f0102e38:	73 08                	jae    f0102e42 <debuginfo_eip+0x1ed>
f0102e3a:	81 c2 ad bb 10 f0    	add    $0xf010bbad,%edx
f0102e40:	89 13                	mov    %edx,(%ebx)
f0102e42:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0102e45:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0102e48:	39 c8                	cmp    %ecx,%eax
f0102e4a:	7d 36                	jge    f0102e82 <debuginfo_eip+0x22d>
f0102e4c:	40                   	inc    %eax
f0102e4d:	eb 03                	jmp    f0102e52 <debuginfo_eip+0x1fd>
f0102e4f:	ff 43 14             	incl   0x14(%ebx)
f0102e52:	39 c1                	cmp    %eax,%ecx
f0102e54:	7e 39                	jle    f0102e8f <debuginfo_eip+0x23a>
f0102e56:	40                   	inc    %eax
f0102e57:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102e5a:	01 c2                	add    %eax,%edx
f0102e5c:	80 3c 95 84 51 10 f0 	cmpb   $0xa0,-0xfefae7c(,%edx,4)
f0102e63:	a0 
f0102e64:	74 e9                	je     f0102e4f <debuginfo_eip+0x1fa>
f0102e66:	b8 00 00 00 00       	mov    $0x0,%eax
f0102e6b:	eb 1a                	jmp    f0102e87 <debuginfo_eip+0x232>
f0102e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0102e72:	eb 13                	jmp    f0102e87 <debuginfo_eip+0x232>
f0102e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0102e79:	eb 0c                	jmp    f0102e87 <debuginfo_eip+0x232>
f0102e7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0102e80:	eb 05                	jmp    f0102e87 <debuginfo_eip+0x232>
f0102e82:	b8 00 00 00 00       	mov    $0x0,%eax
f0102e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102e8a:	5b                   	pop    %ebx
f0102e8b:	5e                   	pop    %esi
f0102e8c:	5f                   	pop    %edi
f0102e8d:	5d                   	pop    %ebp
f0102e8e:	c3                   	ret    
f0102e8f:	b8 00 00 00 00       	mov    $0x0,%eax
f0102e94:	eb f1                	jmp    f0102e87 <debuginfo_eip+0x232>

f0102e96 <printnum>:
f0102e96:	55                   	push   %ebp
f0102e97:	89 e5                	mov    %esp,%ebp
f0102e99:	57                   	push   %edi
f0102e9a:	56                   	push   %esi
f0102e9b:	53                   	push   %ebx
f0102e9c:	83 ec 1c             	sub    $0x1c,%esp
f0102e9f:	89 c7                	mov    %eax,%edi
f0102ea1:	89 d6                	mov    %edx,%esi
f0102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
f0102ea9:	89 d1                	mov    %edx,%ecx
f0102eab:	89 c2                	mov    %eax,%edx
f0102ead:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102eb0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0102eb3:	8b 45 10             	mov    0x10(%ebp),%eax
f0102eb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0102eb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102ebc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0102ec3:	39 c2                	cmp    %eax,%edx
f0102ec5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0102ec8:	72 3c                	jb     f0102f06 <printnum+0x70>
f0102eca:	83 ec 0c             	sub    $0xc,%esp
f0102ecd:	ff 75 18             	push   0x18(%ebp)
f0102ed0:	4b                   	dec    %ebx
f0102ed1:	53                   	push   %ebx
f0102ed2:	50                   	push   %eax
f0102ed3:	83 ec 08             	sub    $0x8,%esp
f0102ed6:	ff 75 e4             	push   -0x1c(%ebp)
f0102ed9:	ff 75 e0             	push   -0x20(%ebp)
f0102edc:	ff 75 dc             	push   -0x24(%ebp)
f0102edf:	ff 75 d8             	push   -0x28(%ebp)
f0102ee2:	e8 95 09 00 00       	call   f010387c <__udivdi3>
f0102ee7:	83 c4 18             	add    $0x18,%esp
f0102eea:	52                   	push   %edx
f0102eeb:	50                   	push   %eax
f0102eec:	89 f2                	mov    %esi,%edx
f0102eee:	89 f8                	mov    %edi,%eax
f0102ef0:	e8 a1 ff ff ff       	call   f0102e96 <printnum>
f0102ef5:	83 c4 20             	add    $0x20,%esp
f0102ef8:	eb 11                	jmp    f0102f0b <printnum+0x75>
f0102efa:	83 ec 08             	sub    $0x8,%esp
f0102efd:	56                   	push   %esi
f0102efe:	ff 75 18             	push   0x18(%ebp)
f0102f01:	ff d7                	call   *%edi
f0102f03:	83 c4 10             	add    $0x10,%esp
f0102f06:	4b                   	dec    %ebx
f0102f07:	85 db                	test   %ebx,%ebx
f0102f09:	7f ef                	jg     f0102efa <printnum+0x64>
f0102f0b:	83 ec 08             	sub    $0x8,%esp
f0102f0e:	56                   	push   %esi
f0102f0f:	83 ec 04             	sub    $0x4,%esp
f0102f12:	ff 75 e4             	push   -0x1c(%ebp)
f0102f15:	ff 75 e0             	push   -0x20(%ebp)
f0102f18:	ff 75 dc             	push   -0x24(%ebp)
f0102f1b:	ff 75 d8             	push   -0x28(%ebp)
f0102f1e:	e8 61 0a 00 00       	call   f0103984 <__umoddi3>
f0102f23:	83 c4 14             	add    $0x14,%esp
f0102f26:	0f be 80 7d 4f 10 f0 	movsbl -0xfefb083(%eax),%eax
f0102f2d:	50                   	push   %eax
f0102f2e:	ff d7                	call   *%edi
f0102f30:	83 c4 10             	add    $0x10,%esp
f0102f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f36:	5b                   	pop    %ebx
f0102f37:	5e                   	pop    %esi
f0102f38:	5f                   	pop    %edi
f0102f39:	5d                   	pop    %ebp
f0102f3a:	c3                   	ret    

f0102f3b <sprintputch>:
f0102f3b:	55                   	push   %ebp
f0102f3c:	89 e5                	mov    %esp,%ebp
f0102f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102f41:	ff 40 08             	incl   0x8(%eax)
f0102f44:	8b 10                	mov    (%eax),%edx
f0102f46:	3b 50 04             	cmp    0x4(%eax),%edx
f0102f49:	73 0a                	jae    f0102f55 <sprintputch+0x1a>
f0102f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
f0102f4e:	89 08                	mov    %ecx,(%eax)
f0102f50:	8b 45 08             	mov    0x8(%ebp),%eax
f0102f53:	88 02                	mov    %al,(%edx)
f0102f55:	5d                   	pop    %ebp
f0102f56:	c3                   	ret    

f0102f57 <printfmt>:
f0102f57:	55                   	push   %ebp
f0102f58:	89 e5                	mov    %esp,%ebp
f0102f5a:	83 ec 08             	sub    $0x8,%esp
f0102f5d:	8d 45 14             	lea    0x14(%ebp),%eax
f0102f60:	50                   	push   %eax
f0102f61:	ff 75 10             	push   0x10(%ebp)
f0102f64:	ff 75 0c             	push   0xc(%ebp)
f0102f67:	ff 75 08             	push   0x8(%ebp)
f0102f6a:	e8 05 00 00 00       	call   f0102f74 <vprintfmt>
f0102f6f:	83 c4 10             	add    $0x10,%esp
f0102f72:	c9                   	leave  
f0102f73:	c3                   	ret    

f0102f74 <vprintfmt>:
f0102f74:	55                   	push   %ebp
f0102f75:	89 e5                	mov    %esp,%ebp
f0102f77:	57                   	push   %edi
f0102f78:	56                   	push   %esi
f0102f79:	53                   	push   %ebx
f0102f7a:	83 ec 3c             	sub    $0x3c,%esp
f0102f7d:	8b 75 08             	mov    0x8(%ebp),%esi
f0102f80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102f83:	8b 7d 10             	mov    0x10(%ebp),%edi
f0102f86:	eb 0a                	jmp    f0102f92 <vprintfmt+0x1e>
f0102f88:	83 ec 08             	sub    $0x8,%esp
f0102f8b:	53                   	push   %ebx
f0102f8c:	50                   	push   %eax
f0102f8d:	ff d6                	call   *%esi
f0102f8f:	83 c4 10             	add    $0x10,%esp
f0102f92:	47                   	inc    %edi
f0102f93:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0102f97:	83 f8 25             	cmp    $0x25,%eax
f0102f9a:	74 0c                	je     f0102fa8 <vprintfmt+0x34>
f0102f9c:	85 c0                	test   %eax,%eax
f0102f9e:	75 e8                	jne    f0102f88 <vprintfmt+0x14>
f0102fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102fa3:	5b                   	pop    %ebx
f0102fa4:	5e                   	pop    %esi
f0102fa5:	5f                   	pop    %edi
f0102fa6:	5d                   	pop    %ebp
f0102fa7:	c3                   	ret    
f0102fa8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
f0102fac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0102fb3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0102fba:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f0102fc1:	b9 00 00 00 00       	mov    $0x0,%ecx
f0102fc6:	8d 47 01             	lea    0x1(%edi),%eax
f0102fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102fcc:	8a 17                	mov    (%edi),%dl
f0102fce:	8d 42 dd             	lea    -0x23(%edx),%eax
f0102fd1:	3c 55                	cmp    $0x55,%al
f0102fd3:	0f 87 f2 03 00 00    	ja     f01033cb <vprintfmt+0x457>
f0102fd9:	0f b6 c0             	movzbl %al,%eax
f0102fdc:	ff 24 85 08 50 10 f0 	jmp    *-0xfefaff8(,%eax,4)
f0102fe3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102fe6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f0102fea:	eb da                	jmp    f0102fc6 <vprintfmt+0x52>
f0102fec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102fef:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f0102ff3:	eb d1                	jmp    f0102fc6 <vprintfmt+0x52>
f0102ff5:	0f b6 d2             	movzbl %dl,%edx
f0102ff8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102ffb:	b8 00 00 00 00       	mov    $0x0,%eax
f0103000:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0103003:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0103006:	01 c0                	add    %eax,%eax
f0103008:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
f010300c:	0f be 17             	movsbl (%edi),%edx
f010300f:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0103012:	83 f9 09             	cmp    $0x9,%ecx
f0103015:	77 52                	ja     f0103069 <vprintfmt+0xf5>
f0103017:	47                   	inc    %edi
f0103018:	eb e9                	jmp    f0103003 <vprintfmt+0x8f>
f010301a:	8b 45 14             	mov    0x14(%ebp),%eax
f010301d:	8b 00                	mov    (%eax),%eax
f010301f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103022:	8b 45 14             	mov    0x14(%ebp),%eax
f0103025:	8d 40 04             	lea    0x4(%eax),%eax
f0103028:	89 45 14             	mov    %eax,0x14(%ebp)
f010302b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010302e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0103032:	79 92                	jns    f0102fc6 <vprintfmt+0x52>
f0103034:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103037:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010303a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0103041:	eb 83                	jmp    f0102fc6 <vprintfmt+0x52>
f0103043:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0103047:	78 08                	js     f0103051 <vprintfmt+0xdd>
f0103049:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010304c:	e9 75 ff ff ff       	jmp    f0102fc6 <vprintfmt+0x52>
f0103051:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0103058:	eb ef                	jmp    f0103049 <vprintfmt+0xd5>
f010305a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010305d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
f0103064:	e9 5d ff ff ff       	jmp    f0102fc6 <vprintfmt+0x52>
f0103069:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010306c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010306f:	eb bd                	jmp    f010302e <vprintfmt+0xba>
f0103071:	41                   	inc    %ecx
f0103072:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103075:	e9 4c ff ff ff       	jmp    f0102fc6 <vprintfmt+0x52>
f010307a:	8b 45 14             	mov    0x14(%ebp),%eax
f010307d:	8d 78 04             	lea    0x4(%eax),%edi
f0103080:	83 ec 08             	sub    $0x8,%esp
f0103083:	53                   	push   %ebx
f0103084:	ff 30                	push   (%eax)
f0103086:	ff d6                	call   *%esi
f0103088:	83 c4 10             	add    $0x10,%esp
f010308b:	89 7d 14             	mov    %edi,0x14(%ebp)
f010308e:	e9 d7 02 00 00       	jmp    f010336a <vprintfmt+0x3f6>
f0103093:	8b 45 14             	mov    0x14(%ebp),%eax
f0103096:	8d 78 04             	lea    0x4(%eax),%edi
f0103099:	8b 00                	mov    (%eax),%eax
f010309b:	85 c0                	test   %eax,%eax
f010309d:	78 2a                	js     f01030c9 <vprintfmt+0x155>
f010309f:	89 c2                	mov    %eax,%edx
f01030a1:	83 f8 06             	cmp    $0x6,%eax
f01030a4:	7f 27                	jg     f01030cd <vprintfmt+0x159>
f01030a6:	8b 04 85 60 51 10 f0 	mov    -0xfefaea0(,%eax,4),%eax
f01030ad:	85 c0                	test   %eax,%eax
f01030af:	74 1c                	je     f01030cd <vprintfmt+0x159>
f01030b1:	50                   	push   %eax
f01030b2:	68 f7 4b 10 f0       	push   $0xf0104bf7
f01030b7:	53                   	push   %ebx
f01030b8:	56                   	push   %esi
f01030b9:	e8 99 fe ff ff       	call   f0102f57 <printfmt>
f01030be:	83 c4 10             	add    $0x10,%esp
f01030c1:	89 7d 14             	mov    %edi,0x14(%ebp)
f01030c4:	e9 a1 02 00 00       	jmp    f010336a <vprintfmt+0x3f6>
f01030c9:	f7 d8                	neg    %eax
f01030cb:	eb d2                	jmp    f010309f <vprintfmt+0x12b>
f01030cd:	52                   	push   %edx
f01030ce:	68 95 4f 10 f0       	push   $0xf0104f95
f01030d3:	53                   	push   %ebx
f01030d4:	56                   	push   %esi
f01030d5:	e8 7d fe ff ff       	call   f0102f57 <printfmt>
f01030da:	83 c4 10             	add    $0x10,%esp
f01030dd:	89 7d 14             	mov    %edi,0x14(%ebp)
f01030e0:	e9 85 02 00 00       	jmp    f010336a <vprintfmt+0x3f6>
f01030e5:	8b 45 14             	mov    0x14(%ebp),%eax
f01030e8:	83 c0 04             	add    $0x4,%eax
f01030eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01030ee:	8b 45 14             	mov    0x14(%ebp),%eax
f01030f1:	8b 00                	mov    (%eax),%eax
f01030f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01030f6:	85 c0                	test   %eax,%eax
f01030f8:	74 19                	je     f0103113 <vprintfmt+0x19f>
f01030fa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01030fe:	7e 06                	jle    f0103106 <vprintfmt+0x192>
f0103100:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f0103104:	75 16                	jne    f010311c <vprintfmt+0x1a8>
f0103106:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103109:	89 c7                	mov    %eax,%edi
f010310b:	03 45 d4             	add    -0x2c(%ebp),%eax
f010310e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103111:	eb 62                	jmp    f0103175 <vprintfmt+0x201>
f0103113:	c7 45 cc 8e 4f 10 f0 	movl   $0xf0104f8e,-0x34(%ebp)
f010311a:	eb de                	jmp    f01030fa <vprintfmt+0x186>
f010311c:	83 ec 08             	sub    $0x8,%esp
f010311f:	ff 75 d8             	push   -0x28(%ebp)
f0103122:	ff 75 cc             	push   -0x34(%ebp)
f0103125:	e8 1e 04 00 00       	call   f0103548 <strnlen>
f010312a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010312d:	29 c2                	sub    %eax,%edx
f010312f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0103132:	83 c4 10             	add    $0x10,%esp
f0103135:	89 d7                	mov    %edx,%edi
f0103137:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f010313b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010313e:	85 ff                	test   %edi,%edi
f0103140:	7e 0f                	jle    f0103151 <vprintfmt+0x1dd>
f0103142:	83 ec 08             	sub    $0x8,%esp
f0103145:	53                   	push   %ebx
f0103146:	ff 75 d4             	push   -0x2c(%ebp)
f0103149:	ff d6                	call   *%esi
f010314b:	4f                   	dec    %edi
f010314c:	83 c4 10             	add    $0x10,%esp
f010314f:	eb ed                	jmp    f010313e <vprintfmt+0x1ca>
f0103151:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0103154:	89 d0                	mov    %edx,%eax
f0103156:	85 d2                	test   %edx,%edx
f0103158:	78 0a                	js     f0103164 <vprintfmt+0x1f0>
f010315a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010315d:	29 c2                	sub    %eax,%edx
f010315f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0103162:	eb a2                	jmp    f0103106 <vprintfmt+0x192>
f0103164:	b8 00 00 00 00       	mov    $0x0,%eax
f0103169:	eb ef                	jmp    f010315a <vprintfmt+0x1e6>
f010316b:	83 ec 08             	sub    $0x8,%esp
f010316e:	53                   	push   %ebx
f010316f:	52                   	push   %edx
f0103170:	ff d6                	call   *%esi
f0103172:	83 c4 10             	add    $0x10,%esp
f0103175:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103178:	29 f9                	sub    %edi,%ecx
f010317a:	47                   	inc    %edi
f010317b:	8a 47 ff             	mov    -0x1(%edi),%al
f010317e:	0f be d0             	movsbl %al,%edx
f0103181:	85 d2                	test   %edx,%edx
f0103183:	74 48                	je     f01031cd <vprintfmt+0x259>
f0103185:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0103189:	78 05                	js     f0103190 <vprintfmt+0x21c>
f010318b:	ff 4d d8             	decl   -0x28(%ebp)
f010318e:	78 1e                	js     f01031ae <vprintfmt+0x23a>
f0103190:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0103194:	74 d5                	je     f010316b <vprintfmt+0x1f7>
f0103196:	0f be c0             	movsbl %al,%eax
f0103199:	83 e8 20             	sub    $0x20,%eax
f010319c:	83 f8 5e             	cmp    $0x5e,%eax
f010319f:	76 ca                	jbe    f010316b <vprintfmt+0x1f7>
f01031a1:	83 ec 08             	sub    $0x8,%esp
f01031a4:	53                   	push   %ebx
f01031a5:	6a 3f                	push   $0x3f
f01031a7:	ff d6                	call   *%esi
f01031a9:	83 c4 10             	add    $0x10,%esp
f01031ac:	eb c7                	jmp    f0103175 <vprintfmt+0x201>
f01031ae:	89 cf                	mov    %ecx,%edi
f01031b0:	eb 0c                	jmp    f01031be <vprintfmt+0x24a>
f01031b2:	83 ec 08             	sub    $0x8,%esp
f01031b5:	53                   	push   %ebx
f01031b6:	6a 20                	push   $0x20
f01031b8:	ff d6                	call   *%esi
f01031ba:	4f                   	dec    %edi
f01031bb:	83 c4 10             	add    $0x10,%esp
f01031be:	85 ff                	test   %edi,%edi
f01031c0:	7f f0                	jg     f01031b2 <vprintfmt+0x23e>
f01031c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01031c5:	89 45 14             	mov    %eax,0x14(%ebp)
f01031c8:	e9 9d 01 00 00       	jmp    f010336a <vprintfmt+0x3f6>
f01031cd:	89 cf                	mov    %ecx,%edi
f01031cf:	eb ed                	jmp    f01031be <vprintfmt+0x24a>
f01031d1:	83 f9 01             	cmp    $0x1,%ecx
f01031d4:	7f 1b                	jg     f01031f1 <vprintfmt+0x27d>
f01031d6:	85 c9                	test   %ecx,%ecx
f01031d8:	74 42                	je     f010321c <vprintfmt+0x2a8>
f01031da:	8b 45 14             	mov    0x14(%ebp),%eax
f01031dd:	8b 00                	mov    (%eax),%eax
f01031df:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01031e2:	99                   	cltd   
f01031e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01031e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01031e9:	8d 40 04             	lea    0x4(%eax),%eax
f01031ec:	89 45 14             	mov    %eax,0x14(%ebp)
f01031ef:	eb 17                	jmp    f0103208 <vprintfmt+0x294>
f01031f1:	8b 45 14             	mov    0x14(%ebp),%eax
f01031f4:	8b 50 04             	mov    0x4(%eax),%edx
f01031f7:	8b 00                	mov    (%eax),%eax
f01031f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01031fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01031ff:	8b 45 14             	mov    0x14(%ebp),%eax
f0103202:	8d 40 08             	lea    0x8(%eax),%eax
f0103205:	89 45 14             	mov    %eax,0x14(%ebp)
f0103208:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010320b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010320e:	85 c9                	test   %ecx,%ecx
f0103210:	78 21                	js     f0103233 <vprintfmt+0x2bf>
f0103212:	bf 0a 00 00 00       	mov    $0xa,%edi
f0103217:	e9 34 01 00 00       	jmp    f0103350 <vprintfmt+0x3dc>
f010321c:	8b 45 14             	mov    0x14(%ebp),%eax
f010321f:	8b 00                	mov    (%eax),%eax
f0103221:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103224:	99                   	cltd   
f0103225:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0103228:	8b 45 14             	mov    0x14(%ebp),%eax
f010322b:	8d 40 04             	lea    0x4(%eax),%eax
f010322e:	89 45 14             	mov    %eax,0x14(%ebp)
f0103231:	eb d5                	jmp    f0103208 <vprintfmt+0x294>
f0103233:	83 ec 08             	sub    $0x8,%esp
f0103236:	53                   	push   %ebx
f0103237:	6a 2d                	push   $0x2d
f0103239:	ff d6                	call   *%esi
f010323b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010323e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103241:	f7 da                	neg    %edx
f0103243:	83 d1 00             	adc    $0x0,%ecx
f0103246:	f7 d9                	neg    %ecx
f0103248:	83 c4 10             	add    $0x10,%esp
f010324b:	bf 0a 00 00 00       	mov    $0xa,%edi
f0103250:	e9 fb 00 00 00       	jmp    f0103350 <vprintfmt+0x3dc>
f0103255:	83 f9 01             	cmp    $0x1,%ecx
f0103258:	7f 1e                	jg     f0103278 <vprintfmt+0x304>
f010325a:	85 c9                	test   %ecx,%ecx
f010325c:	74 32                	je     f0103290 <vprintfmt+0x31c>
f010325e:	8b 45 14             	mov    0x14(%ebp),%eax
f0103261:	8b 10                	mov    (%eax),%edx
f0103263:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103268:	8d 40 04             	lea    0x4(%eax),%eax
f010326b:	89 45 14             	mov    %eax,0x14(%ebp)
f010326e:	bf 0a 00 00 00       	mov    $0xa,%edi
f0103273:	e9 d8 00 00 00       	jmp    f0103350 <vprintfmt+0x3dc>
f0103278:	8b 45 14             	mov    0x14(%ebp),%eax
f010327b:	8b 10                	mov    (%eax),%edx
f010327d:	8b 48 04             	mov    0x4(%eax),%ecx
f0103280:	8d 40 08             	lea    0x8(%eax),%eax
f0103283:	89 45 14             	mov    %eax,0x14(%ebp)
f0103286:	bf 0a 00 00 00       	mov    $0xa,%edi
f010328b:	e9 c0 00 00 00       	jmp    f0103350 <vprintfmt+0x3dc>
f0103290:	8b 45 14             	mov    0x14(%ebp),%eax
f0103293:	8b 10                	mov    (%eax),%edx
f0103295:	b9 00 00 00 00       	mov    $0x0,%ecx
f010329a:	8d 40 04             	lea    0x4(%eax),%eax
f010329d:	89 45 14             	mov    %eax,0x14(%ebp)
f01032a0:	bf 0a 00 00 00       	mov    $0xa,%edi
f01032a5:	e9 a6 00 00 00       	jmp    f0103350 <vprintfmt+0x3dc>
f01032aa:	83 f9 01             	cmp    $0x1,%ecx
f01032ad:	7f 1b                	jg     f01032ca <vprintfmt+0x356>
f01032af:	85 c9                	test   %ecx,%ecx
f01032b1:	74 3f                	je     f01032f2 <vprintfmt+0x37e>
f01032b3:	8b 45 14             	mov    0x14(%ebp),%eax
f01032b6:	8b 00                	mov    (%eax),%eax
f01032b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01032bb:	99                   	cltd   
f01032bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01032bf:	8b 45 14             	mov    0x14(%ebp),%eax
f01032c2:	8d 40 04             	lea    0x4(%eax),%eax
f01032c5:	89 45 14             	mov    %eax,0x14(%ebp)
f01032c8:	eb 17                	jmp    f01032e1 <vprintfmt+0x36d>
f01032ca:	8b 45 14             	mov    0x14(%ebp),%eax
f01032cd:	8b 50 04             	mov    0x4(%eax),%edx
f01032d0:	8b 00                	mov    (%eax),%eax
f01032d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01032d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01032d8:	8b 45 14             	mov    0x14(%ebp),%eax
f01032db:	8d 40 08             	lea    0x8(%eax),%eax
f01032de:	89 45 14             	mov    %eax,0x14(%ebp)
f01032e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01032e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01032e7:	85 c9                	test   %ecx,%ecx
f01032e9:	78 1e                	js     f0103309 <vprintfmt+0x395>
f01032eb:	bf 08 00 00 00       	mov    $0x8,%edi
f01032f0:	eb 5e                	jmp    f0103350 <vprintfmt+0x3dc>
f01032f2:	8b 45 14             	mov    0x14(%ebp),%eax
f01032f5:	8b 00                	mov    (%eax),%eax
f01032f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01032fa:	99                   	cltd   
f01032fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01032fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0103301:	8d 40 04             	lea    0x4(%eax),%eax
f0103304:	89 45 14             	mov    %eax,0x14(%ebp)
f0103307:	eb d8                	jmp    f01032e1 <vprintfmt+0x36d>
f0103309:	83 ec 08             	sub    $0x8,%esp
f010330c:	53                   	push   %ebx
f010330d:	6a 2d                	push   $0x2d
f010330f:	ff d6                	call   *%esi
f0103311:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103314:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103317:	f7 da                	neg    %edx
f0103319:	83 d1 00             	adc    $0x0,%ecx
f010331c:	f7 d9                	neg    %ecx
f010331e:	83 c4 10             	add    $0x10,%esp
f0103321:	bf 08 00 00 00       	mov    $0x8,%edi
f0103326:	eb 28                	jmp    f0103350 <vprintfmt+0x3dc>
f0103328:	83 ec 08             	sub    $0x8,%esp
f010332b:	53                   	push   %ebx
f010332c:	6a 30                	push   $0x30
f010332e:	ff d6                	call   *%esi
f0103330:	83 c4 08             	add    $0x8,%esp
f0103333:	53                   	push   %ebx
f0103334:	6a 78                	push   $0x78
f0103336:	ff d6                	call   *%esi
f0103338:	8b 45 14             	mov    0x14(%ebp),%eax
f010333b:	8b 10                	mov    (%eax),%edx
f010333d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103342:	83 c4 10             	add    $0x10,%esp
f0103345:	8d 40 04             	lea    0x4(%eax),%eax
f0103348:	89 45 14             	mov    %eax,0x14(%ebp)
f010334b:	bf 10 00 00 00       	mov    $0x10,%edi
f0103350:	83 ec 0c             	sub    $0xc,%esp
f0103353:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0103357:	50                   	push   %eax
f0103358:	ff 75 d4             	push   -0x2c(%ebp)
f010335b:	57                   	push   %edi
f010335c:	51                   	push   %ecx
f010335d:	52                   	push   %edx
f010335e:	89 da                	mov    %ebx,%edx
f0103360:	89 f0                	mov    %esi,%eax
f0103362:	e8 2f fb ff ff       	call   f0102e96 <printnum>
f0103367:	83 c4 20             	add    $0x20,%esp
f010336a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010336d:	e9 20 fc ff ff       	jmp    f0102f92 <vprintfmt+0x1e>
f0103372:	83 f9 01             	cmp    $0x1,%ecx
f0103375:	7f 1b                	jg     f0103392 <vprintfmt+0x41e>
f0103377:	85 c9                	test   %ecx,%ecx
f0103379:	74 2c                	je     f01033a7 <vprintfmt+0x433>
f010337b:	8b 45 14             	mov    0x14(%ebp),%eax
f010337e:	8b 10                	mov    (%eax),%edx
f0103380:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103385:	8d 40 04             	lea    0x4(%eax),%eax
f0103388:	89 45 14             	mov    %eax,0x14(%ebp)
f010338b:	bf 10 00 00 00       	mov    $0x10,%edi
f0103390:	eb be                	jmp    f0103350 <vprintfmt+0x3dc>
f0103392:	8b 45 14             	mov    0x14(%ebp),%eax
f0103395:	8b 10                	mov    (%eax),%edx
f0103397:	8b 48 04             	mov    0x4(%eax),%ecx
f010339a:	8d 40 08             	lea    0x8(%eax),%eax
f010339d:	89 45 14             	mov    %eax,0x14(%ebp)
f01033a0:	bf 10 00 00 00       	mov    $0x10,%edi
f01033a5:	eb a9                	jmp    f0103350 <vprintfmt+0x3dc>
f01033a7:	8b 45 14             	mov    0x14(%ebp),%eax
f01033aa:	8b 10                	mov    (%eax),%edx
f01033ac:	b9 00 00 00 00       	mov    $0x0,%ecx
f01033b1:	8d 40 04             	lea    0x4(%eax),%eax
f01033b4:	89 45 14             	mov    %eax,0x14(%ebp)
f01033b7:	bf 10 00 00 00       	mov    $0x10,%edi
f01033bc:	eb 92                	jmp    f0103350 <vprintfmt+0x3dc>
f01033be:	83 ec 08             	sub    $0x8,%esp
f01033c1:	53                   	push   %ebx
f01033c2:	6a 25                	push   $0x25
f01033c4:	ff d6                	call   *%esi
f01033c6:	83 c4 10             	add    $0x10,%esp
f01033c9:	eb 9f                	jmp    f010336a <vprintfmt+0x3f6>
f01033cb:	83 ec 08             	sub    $0x8,%esp
f01033ce:	53                   	push   %ebx
f01033cf:	6a 25                	push   $0x25
f01033d1:	ff d6                	call   *%esi
f01033d3:	83 c4 10             	add    $0x10,%esp
f01033d6:	89 f8                	mov    %edi,%eax
f01033d8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01033dc:	74 03                	je     f01033e1 <vprintfmt+0x46d>
f01033de:	48                   	dec    %eax
f01033df:	eb f7                	jmp    f01033d8 <vprintfmt+0x464>
f01033e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01033e4:	eb 84                	jmp    f010336a <vprintfmt+0x3f6>

f01033e6 <vsnprintf>:
f01033e6:	55                   	push   %ebp
f01033e7:	89 e5                	mov    %esp,%ebp
f01033e9:	83 ec 18             	sub    $0x18,%esp
f01033ec:	8b 45 08             	mov    0x8(%ebp),%eax
f01033ef:	8b 55 0c             	mov    0xc(%ebp),%edx
f01033f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01033f5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01033f9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01033fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0103403:	85 c0                	test   %eax,%eax
f0103405:	74 26                	je     f010342d <vsnprintf+0x47>
f0103407:	85 d2                	test   %edx,%edx
f0103409:	7e 29                	jle    f0103434 <vsnprintf+0x4e>
f010340b:	ff 75 14             	push   0x14(%ebp)
f010340e:	ff 75 10             	push   0x10(%ebp)
f0103411:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0103414:	50                   	push   %eax
f0103415:	68 3b 2f 10 f0       	push   $0xf0102f3b
f010341a:	e8 55 fb ff ff       	call   f0102f74 <vprintfmt>
f010341f:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103422:	c6 00 00             	movb   $0x0,(%eax)
f0103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103428:	83 c4 10             	add    $0x10,%esp
f010342b:	c9                   	leave  
f010342c:	c3                   	ret    
f010342d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0103432:	eb f7                	jmp    f010342b <vsnprintf+0x45>
f0103434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0103439:	eb f0                	jmp    f010342b <vsnprintf+0x45>

f010343b <snprintf>:
f010343b:	55                   	push   %ebp
f010343c:	89 e5                	mov    %esp,%ebp
f010343e:	83 ec 08             	sub    $0x8,%esp
f0103441:	8d 45 14             	lea    0x14(%ebp),%eax
f0103444:	50                   	push   %eax
f0103445:	ff 75 10             	push   0x10(%ebp)
f0103448:	ff 75 0c             	push   0xc(%ebp)
f010344b:	ff 75 08             	push   0x8(%ebp)
f010344e:	e8 93 ff ff ff       	call   f01033e6 <vsnprintf>
f0103453:	c9                   	leave  
f0103454:	c3                   	ret    

f0103455 <readline>:
f0103455:	55                   	push   %ebp
f0103456:	89 e5                	mov    %esp,%ebp
f0103458:	57                   	push   %edi
f0103459:	56                   	push   %esi
f010345a:	53                   	push   %ebx
f010345b:	83 ec 0c             	sub    $0xc,%esp
f010345e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103461:	85 c0                	test   %eax,%eax
f0103463:	74 11                	je     f0103476 <readline+0x21>
f0103465:	83 ec 08             	sub    $0x8,%esp
f0103468:	50                   	push   %eax
f0103469:	68 f7 4b 10 f0       	push   $0xf0104bf7
f010346e:	e8 c0 f6 ff ff       	call   f0102b33 <cprintf>
f0103473:	83 c4 10             	add    $0x10,%esp
f0103476:	83 ec 0c             	sub    $0xc,%esp
f0103479:	6a 00                	push   $0x0
f010347b:	e8 0d d2 ff ff       	call   f010068d <iscons>
f0103480:	89 c7                	mov    %eax,%edi
f0103482:	83 c4 10             	add    $0x10,%esp
f0103485:	be 00 00 00 00       	mov    $0x0,%esi
f010348a:	eb 75                	jmp    f0103501 <readline+0xac>
f010348c:	83 ec 08             	sub    $0x8,%esp
f010348f:	50                   	push   %eax
f0103490:	68 7c 51 10 f0       	push   $0xf010517c
f0103495:	e8 99 f6 ff ff       	call   f0102b33 <cprintf>
f010349a:	83 c4 10             	add    $0x10,%esp
f010349d:	b8 00 00 00 00       	mov    $0x0,%eax
f01034a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01034a5:	5b                   	pop    %ebx
f01034a6:	5e                   	pop    %esi
f01034a7:	5f                   	pop    %edi
f01034a8:	5d                   	pop    %ebp
f01034a9:	c3                   	ret    
f01034aa:	83 ec 0c             	sub    $0xc,%esp
f01034ad:	6a 08                	push   $0x8
f01034af:	e8 b8 d1 ff ff       	call   f010066c <cputchar>
f01034b4:	83 c4 10             	add    $0x10,%esp
f01034b7:	eb 47                	jmp    f0103500 <readline+0xab>
f01034b9:	83 ec 0c             	sub    $0xc,%esp
f01034bc:	53                   	push   %ebx
f01034bd:	e8 aa d1 ff ff       	call   f010066c <cputchar>
f01034c2:	83 c4 10             	add    $0x10,%esp
f01034c5:	eb 60                	jmp    f0103527 <readline+0xd2>
f01034c7:	83 f8 0a             	cmp    $0xa,%eax
f01034ca:	74 05                	je     f01034d1 <readline+0x7c>
f01034cc:	83 f8 0d             	cmp    $0xd,%eax
f01034cf:	75 30                	jne    f0103501 <readline+0xac>
f01034d1:	85 ff                	test   %edi,%edi
f01034d3:	75 0e                	jne    f01034e3 <readline+0x8e>
f01034d5:	c6 86 80 85 11 f0 00 	movb   $0x0,-0xfee7a80(%esi)
f01034dc:	b8 80 85 11 f0       	mov    $0xf0118580,%eax
f01034e1:	eb bf                	jmp    f01034a2 <readline+0x4d>
f01034e3:	83 ec 0c             	sub    $0xc,%esp
f01034e6:	6a 0a                	push   $0xa
f01034e8:	e8 7f d1 ff ff       	call   f010066c <cputchar>
f01034ed:	83 c4 10             	add    $0x10,%esp
f01034f0:	eb e3                	jmp    f01034d5 <readline+0x80>
f01034f2:	85 f6                	test   %esi,%esi
f01034f4:	7f 06                	jg     f01034fc <readline+0xa7>
f01034f6:	eb 23                	jmp    f010351b <readline+0xc6>
f01034f8:	85 f6                	test   %esi,%esi
f01034fa:	7e 05                	jle    f0103501 <readline+0xac>
f01034fc:	85 ff                	test   %edi,%edi
f01034fe:	75 aa                	jne    f01034aa <readline+0x55>
f0103500:	4e                   	dec    %esi
f0103501:	e8 76 d1 ff ff       	call   f010067c <getchar>
f0103506:	89 c3                	mov    %eax,%ebx
f0103508:	85 c0                	test   %eax,%eax
f010350a:	78 80                	js     f010348c <readline+0x37>
f010350c:	83 f8 08             	cmp    $0x8,%eax
f010350f:	74 e7                	je     f01034f8 <readline+0xa3>
f0103511:	83 f8 7f             	cmp    $0x7f,%eax
f0103514:	74 dc                	je     f01034f2 <readline+0x9d>
f0103516:	83 f8 1f             	cmp    $0x1f,%eax
f0103519:	7e ac                	jle    f01034c7 <readline+0x72>
f010351b:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0103521:	7f de                	jg     f0103501 <readline+0xac>
f0103523:	85 ff                	test   %edi,%edi
f0103525:	75 92                	jne    f01034b9 <readline+0x64>
f0103527:	88 9e 80 85 11 f0    	mov    %bl,-0xfee7a80(%esi)
f010352d:	8d 76 01             	lea    0x1(%esi),%esi
f0103530:	eb cf                	jmp    f0103501 <readline+0xac>

f0103532 <strlen>:
f0103532:	55                   	push   %ebp
f0103533:	89 e5                	mov    %esp,%ebp
f0103535:	8b 55 08             	mov    0x8(%ebp),%edx
f0103538:	b8 00 00 00 00       	mov    $0x0,%eax
f010353d:	eb 01                	jmp    f0103540 <strlen+0xe>
f010353f:	40                   	inc    %eax
f0103540:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0103544:	75 f9                	jne    f010353f <strlen+0xd>
f0103546:	5d                   	pop    %ebp
f0103547:	c3                   	ret    

f0103548 <strnlen>:
f0103548:	55                   	push   %ebp
f0103549:	89 e5                	mov    %esp,%ebp
f010354b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010354e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103551:	b8 00 00 00 00       	mov    $0x0,%eax
f0103556:	eb 01                	jmp    f0103559 <strnlen+0x11>
f0103558:	40                   	inc    %eax
f0103559:	39 d0                	cmp    %edx,%eax
f010355b:	74 08                	je     f0103565 <strnlen+0x1d>
f010355d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0103561:	75 f5                	jne    f0103558 <strnlen+0x10>
f0103563:	89 c2                	mov    %eax,%edx
f0103565:	89 d0                	mov    %edx,%eax
f0103567:	5d                   	pop    %ebp
f0103568:	c3                   	ret    

f0103569 <strcpy>:
f0103569:	55                   	push   %ebp
f010356a:	89 e5                	mov    %esp,%ebp
f010356c:	53                   	push   %ebx
f010356d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103570:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103573:	b8 00 00 00 00       	mov    $0x0,%eax
f0103578:	8a 14 03             	mov    (%ebx,%eax,1),%dl
f010357b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f010357e:	40                   	inc    %eax
f010357f:	84 d2                	test   %dl,%dl
f0103581:	75 f5                	jne    f0103578 <strcpy+0xf>
f0103583:	89 c8                	mov    %ecx,%eax
f0103585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103588:	c9                   	leave  
f0103589:	c3                   	ret    

f010358a <strcat>:
f010358a:	55                   	push   %ebp
f010358b:	89 e5                	mov    %esp,%ebp
f010358d:	53                   	push   %ebx
f010358e:	83 ec 10             	sub    $0x10,%esp
f0103591:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0103594:	53                   	push   %ebx
f0103595:	e8 98 ff ff ff       	call   f0103532 <strlen>
f010359a:	83 c4 08             	add    $0x8,%esp
f010359d:	ff 75 0c             	push   0xc(%ebp)
f01035a0:	01 d8                	add    %ebx,%eax
f01035a2:	50                   	push   %eax
f01035a3:	e8 c1 ff ff ff       	call   f0103569 <strcpy>
f01035a8:	89 d8                	mov    %ebx,%eax
f01035aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01035ad:	c9                   	leave  
f01035ae:	c3                   	ret    

f01035af <strncpy>:
f01035af:	55                   	push   %ebp
f01035b0:	89 e5                	mov    %esp,%ebp
f01035b2:	53                   	push   %ebx
f01035b3:	8b 55 0c             	mov    0xc(%ebp),%edx
f01035b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01035b9:	03 5d 10             	add    0x10(%ebp),%ebx
f01035bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01035bf:	eb 0c                	jmp    f01035cd <strncpy+0x1e>
f01035c1:	40                   	inc    %eax
f01035c2:	8a 0a                	mov    (%edx),%cl
f01035c4:	88 48 ff             	mov    %cl,-0x1(%eax)
f01035c7:	80 f9 01             	cmp    $0x1,%cl
f01035ca:	83 da ff             	sbb    $0xffffffff,%edx
f01035cd:	39 d8                	cmp    %ebx,%eax
f01035cf:	75 f0                	jne    f01035c1 <strncpy+0x12>
f01035d1:	8b 45 08             	mov    0x8(%ebp),%eax
f01035d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01035d7:	c9                   	leave  
f01035d8:	c3                   	ret    

f01035d9 <strlcpy>:
f01035d9:	55                   	push   %ebp
f01035da:	89 e5                	mov    %esp,%ebp
f01035dc:	56                   	push   %esi
f01035dd:	53                   	push   %ebx
f01035de:	8b 75 08             	mov    0x8(%ebp),%esi
f01035e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01035e4:	8b 45 10             	mov    0x10(%ebp),%eax
f01035e7:	85 c0                	test   %eax,%eax
f01035e9:	74 22                	je     f010360d <strlcpy+0x34>
f01035eb:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
f01035ef:	89 f2                	mov    %esi,%edx
f01035f1:	eb 05                	jmp    f01035f8 <strlcpy+0x1f>
f01035f3:	41                   	inc    %ecx
f01035f4:	42                   	inc    %edx
f01035f5:	88 5a ff             	mov    %bl,-0x1(%edx)
f01035f8:	39 c2                	cmp    %eax,%edx
f01035fa:	74 08                	je     f0103604 <strlcpy+0x2b>
f01035fc:	8a 19                	mov    (%ecx),%bl
f01035fe:	84 db                	test   %bl,%bl
f0103600:	75 f1                	jne    f01035f3 <strlcpy+0x1a>
f0103602:	89 d0                	mov    %edx,%eax
f0103604:	c6 00 00             	movb   $0x0,(%eax)
f0103607:	29 f0                	sub    %esi,%eax
f0103609:	5b                   	pop    %ebx
f010360a:	5e                   	pop    %esi
f010360b:	5d                   	pop    %ebp
f010360c:	c3                   	ret    
f010360d:	89 f0                	mov    %esi,%eax
f010360f:	eb f6                	jmp    f0103607 <strlcpy+0x2e>

f0103611 <strcmp>:
f0103611:	55                   	push   %ebp
f0103612:	89 e5                	mov    %esp,%ebp
f0103614:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103617:	8b 55 0c             	mov    0xc(%ebp),%edx
f010361a:	eb 02                	jmp    f010361e <strcmp+0xd>
f010361c:	41                   	inc    %ecx
f010361d:	42                   	inc    %edx
f010361e:	8a 01                	mov    (%ecx),%al
f0103620:	84 c0                	test   %al,%al
f0103622:	74 04                	je     f0103628 <strcmp+0x17>
f0103624:	3a 02                	cmp    (%edx),%al
f0103626:	74 f4                	je     f010361c <strcmp+0xb>
f0103628:	0f b6 c0             	movzbl %al,%eax
f010362b:	0f b6 12             	movzbl (%edx),%edx
f010362e:	29 d0                	sub    %edx,%eax
f0103630:	5d                   	pop    %ebp
f0103631:	c3                   	ret    

f0103632 <strncmp>:
f0103632:	55                   	push   %ebp
f0103633:	89 e5                	mov    %esp,%ebp
f0103635:	53                   	push   %ebx
f0103636:	8b 45 08             	mov    0x8(%ebp),%eax
f0103639:	8b 55 0c             	mov    0xc(%ebp),%edx
f010363c:	89 c3                	mov    %eax,%ebx
f010363e:	03 5d 10             	add    0x10(%ebp),%ebx
f0103641:	eb 02                	jmp    f0103645 <strncmp+0x13>
f0103643:	40                   	inc    %eax
f0103644:	42                   	inc    %edx
f0103645:	39 d8                	cmp    %ebx,%eax
f0103647:	74 17                	je     f0103660 <strncmp+0x2e>
f0103649:	8a 08                	mov    (%eax),%cl
f010364b:	84 c9                	test   %cl,%cl
f010364d:	74 04                	je     f0103653 <strncmp+0x21>
f010364f:	3a 0a                	cmp    (%edx),%cl
f0103651:	74 f0                	je     f0103643 <strncmp+0x11>
f0103653:	0f b6 00             	movzbl (%eax),%eax
f0103656:	0f b6 12             	movzbl (%edx),%edx
f0103659:	29 d0                	sub    %edx,%eax
f010365b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010365e:	c9                   	leave  
f010365f:	c3                   	ret    
f0103660:	b8 00 00 00 00       	mov    $0x0,%eax
f0103665:	eb f4                	jmp    f010365b <strncmp+0x29>

f0103667 <strchr>:
f0103667:	55                   	push   %ebp
f0103668:	89 e5                	mov    %esp,%ebp
f010366a:	8b 45 08             	mov    0x8(%ebp),%eax
f010366d:	8a 4d 0c             	mov    0xc(%ebp),%cl
f0103670:	eb 01                	jmp    f0103673 <strchr+0xc>
f0103672:	40                   	inc    %eax
f0103673:	8a 10                	mov    (%eax),%dl
f0103675:	84 d2                	test   %dl,%dl
f0103677:	74 06                	je     f010367f <strchr+0x18>
f0103679:	38 ca                	cmp    %cl,%dl
f010367b:	75 f5                	jne    f0103672 <strchr+0xb>
f010367d:	eb 05                	jmp    f0103684 <strchr+0x1d>
f010367f:	b8 00 00 00 00       	mov    $0x0,%eax
f0103684:	5d                   	pop    %ebp
f0103685:	c3                   	ret    

f0103686 <strfind>:
f0103686:	55                   	push   %ebp
f0103687:	89 e5                	mov    %esp,%ebp
f0103689:	8b 45 08             	mov    0x8(%ebp),%eax
f010368c:	8a 4d 0c             	mov    0xc(%ebp),%cl
f010368f:	eb 01                	jmp    f0103692 <strfind+0xc>
f0103691:	40                   	inc    %eax
f0103692:	8a 10                	mov    (%eax),%dl
f0103694:	84 d2                	test   %dl,%dl
f0103696:	74 04                	je     f010369c <strfind+0x16>
f0103698:	38 ca                	cmp    %cl,%dl
f010369a:	75 f5                	jne    f0103691 <strfind+0xb>
f010369c:	5d                   	pop    %ebp
f010369d:	c3                   	ret    

f010369e <memset>:
f010369e:	55                   	push   %ebp
f010369f:	89 e5                	mov    %esp,%ebp
f01036a1:	57                   	push   %edi
f01036a2:	56                   	push   %esi
f01036a3:	53                   	push   %ebx
f01036a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01036a7:	85 c9                	test   %ecx,%ecx
f01036a9:	74 36                	je     f01036e1 <memset+0x43>
f01036ab:	89 c8                	mov    %ecx,%eax
f01036ad:	0b 45 08             	or     0x8(%ebp),%eax
f01036b0:	a8 03                	test   $0x3,%al
f01036b2:	75 24                	jne    f01036d8 <memset+0x3a>
f01036b4:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
f01036b8:	89 d8                	mov    %ebx,%eax
f01036ba:	c1 e0 08             	shl    $0x8,%eax
f01036bd:	89 da                	mov    %ebx,%edx
f01036bf:	c1 e2 18             	shl    $0x18,%edx
f01036c2:	89 de                	mov    %ebx,%esi
f01036c4:	c1 e6 10             	shl    $0x10,%esi
f01036c7:	09 f2                	or     %esi,%edx
f01036c9:	09 da                	or     %ebx,%edx
f01036cb:	09 d0                	or     %edx,%eax
f01036cd:	c1 e9 02             	shr    $0x2,%ecx
f01036d0:	8b 7d 08             	mov    0x8(%ebp),%edi
f01036d3:	fc                   	cld    
f01036d4:	f3 ab                	rep stos %eax,%es:(%edi)
f01036d6:	eb 09                	jmp    f01036e1 <memset+0x43>
f01036d8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01036db:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036de:	fc                   	cld    
f01036df:	f3 aa                	rep stos %al,%es:(%edi)
f01036e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01036e4:	5b                   	pop    %ebx
f01036e5:	5e                   	pop    %esi
f01036e6:	5f                   	pop    %edi
f01036e7:	5d                   	pop    %ebp
f01036e8:	c3                   	ret    

f01036e9 <memmove>:
f01036e9:	55                   	push   %ebp
f01036ea:	89 e5                	mov    %esp,%ebp
f01036ec:	57                   	push   %edi
f01036ed:	56                   	push   %esi
f01036ee:	8b 45 08             	mov    0x8(%ebp),%eax
f01036f1:	8b 75 0c             	mov    0xc(%ebp),%esi
f01036f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01036f7:	39 c6                	cmp    %eax,%esi
f01036f9:	73 30                	jae    f010372b <memmove+0x42>
f01036fb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01036fe:	39 c2                	cmp    %eax,%edx
f0103700:	76 29                	jbe    f010372b <memmove+0x42>
f0103702:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0103705:	89 d6                	mov    %edx,%esi
f0103707:	09 fe                	or     %edi,%esi
f0103709:	09 ce                	or     %ecx,%esi
f010370b:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0103711:	75 0e                	jne    f0103721 <memmove+0x38>
f0103713:	83 ef 04             	sub    $0x4,%edi
f0103716:	8d 72 fc             	lea    -0x4(%edx),%esi
f0103719:	c1 e9 02             	shr    $0x2,%ecx
f010371c:	fd                   	std    
f010371d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010371f:	eb 07                	jmp    f0103728 <memmove+0x3f>
f0103721:	4f                   	dec    %edi
f0103722:	8d 72 ff             	lea    -0x1(%edx),%esi
f0103725:	fd                   	std    
f0103726:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0103728:	fc                   	cld    
f0103729:	eb 1a                	jmp    f0103745 <memmove+0x5c>
f010372b:	89 f2                	mov    %esi,%edx
f010372d:	09 c2                	or     %eax,%edx
f010372f:	09 ca                	or     %ecx,%edx
f0103731:	f6 c2 03             	test   $0x3,%dl
f0103734:	75 0a                	jne    f0103740 <memmove+0x57>
f0103736:	c1 e9 02             	shr    $0x2,%ecx
f0103739:	89 c7                	mov    %eax,%edi
f010373b:	fc                   	cld    
f010373c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010373e:	eb 05                	jmp    f0103745 <memmove+0x5c>
f0103740:	89 c7                	mov    %eax,%edi
f0103742:	fc                   	cld    
f0103743:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0103745:	5e                   	pop    %esi
f0103746:	5f                   	pop    %edi
f0103747:	5d                   	pop    %ebp
f0103748:	c3                   	ret    

f0103749 <memcpy>:
f0103749:	55                   	push   %ebp
f010374a:	89 e5                	mov    %esp,%ebp
f010374c:	83 ec 0c             	sub    $0xc,%esp
f010374f:	ff 75 10             	push   0x10(%ebp)
f0103752:	ff 75 0c             	push   0xc(%ebp)
f0103755:	ff 75 08             	push   0x8(%ebp)
f0103758:	e8 8c ff ff ff       	call   f01036e9 <memmove>
f010375d:	c9                   	leave  
f010375e:	c3                   	ret    

f010375f <memcmp>:
f010375f:	55                   	push   %ebp
f0103760:	89 e5                	mov    %esp,%ebp
f0103762:	56                   	push   %esi
f0103763:	53                   	push   %ebx
f0103764:	8b 45 08             	mov    0x8(%ebp),%eax
f0103767:	8b 55 0c             	mov    0xc(%ebp),%edx
f010376a:	89 c6                	mov    %eax,%esi
f010376c:	03 75 10             	add    0x10(%ebp),%esi
f010376f:	eb 02                	jmp    f0103773 <memcmp+0x14>
f0103771:	40                   	inc    %eax
f0103772:	42                   	inc    %edx
f0103773:	39 f0                	cmp    %esi,%eax
f0103775:	74 12                	je     f0103789 <memcmp+0x2a>
f0103777:	8a 08                	mov    (%eax),%cl
f0103779:	8a 1a                	mov    (%edx),%bl
f010377b:	38 d9                	cmp    %bl,%cl
f010377d:	74 f2                	je     f0103771 <memcmp+0x12>
f010377f:	0f b6 c1             	movzbl %cl,%eax
f0103782:	0f b6 db             	movzbl %bl,%ebx
f0103785:	29 d8                	sub    %ebx,%eax
f0103787:	eb 05                	jmp    f010378e <memcmp+0x2f>
f0103789:	b8 00 00 00 00       	mov    $0x0,%eax
f010378e:	5b                   	pop    %ebx
f010378f:	5e                   	pop    %esi
f0103790:	5d                   	pop    %ebp
f0103791:	c3                   	ret    

f0103792 <memfind>:
f0103792:	55                   	push   %ebp
f0103793:	89 e5                	mov    %esp,%ebp
f0103795:	8b 45 08             	mov    0x8(%ebp),%eax
f0103798:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010379b:	89 c2                	mov    %eax,%edx
f010379d:	03 55 10             	add    0x10(%ebp),%edx
f01037a0:	eb 01                	jmp    f01037a3 <memfind+0x11>
f01037a2:	40                   	inc    %eax
f01037a3:	39 d0                	cmp    %edx,%eax
f01037a5:	73 04                	jae    f01037ab <memfind+0x19>
f01037a7:	38 08                	cmp    %cl,(%eax)
f01037a9:	75 f7                	jne    f01037a2 <memfind+0x10>
f01037ab:	5d                   	pop    %ebp
f01037ac:	c3                   	ret    

f01037ad <strtol>:
f01037ad:	55                   	push   %ebp
f01037ae:	89 e5                	mov    %esp,%ebp
f01037b0:	57                   	push   %edi
f01037b1:	56                   	push   %esi
f01037b2:	53                   	push   %ebx
f01037b3:	8b 55 08             	mov    0x8(%ebp),%edx
f01037b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01037b9:	eb 01                	jmp    f01037bc <strtol+0xf>
f01037bb:	42                   	inc    %edx
f01037bc:	8a 02                	mov    (%edx),%al
f01037be:	3c 20                	cmp    $0x20,%al
f01037c0:	74 f9                	je     f01037bb <strtol+0xe>
f01037c2:	3c 09                	cmp    $0x9,%al
f01037c4:	74 f5                	je     f01037bb <strtol+0xe>
f01037c6:	3c 2b                	cmp    $0x2b,%al
f01037c8:	74 24                	je     f01037ee <strtol+0x41>
f01037ca:	3c 2d                	cmp    $0x2d,%al
f01037cc:	74 28                	je     f01037f6 <strtol+0x49>
f01037ce:	bf 00 00 00 00       	mov    $0x0,%edi
f01037d3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01037d9:	75 09                	jne    f01037e4 <strtol+0x37>
f01037db:	80 3a 30             	cmpb   $0x30,(%edx)
f01037de:	74 1e                	je     f01037fe <strtol+0x51>
f01037e0:	85 db                	test   %ebx,%ebx
f01037e2:	74 36                	je     f010381a <strtol+0x6d>
f01037e4:	b9 00 00 00 00       	mov    $0x0,%ecx
f01037e9:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01037ec:	eb 45                	jmp    f0103833 <strtol+0x86>
f01037ee:	42                   	inc    %edx
f01037ef:	bf 00 00 00 00       	mov    $0x0,%edi
f01037f4:	eb dd                	jmp    f01037d3 <strtol+0x26>
f01037f6:	42                   	inc    %edx
f01037f7:	bf 01 00 00 00       	mov    $0x1,%edi
f01037fc:	eb d5                	jmp    f01037d3 <strtol+0x26>
f01037fe:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0103802:	74 0c                	je     f0103810 <strtol+0x63>
f0103804:	85 db                	test   %ebx,%ebx
f0103806:	75 dc                	jne    f01037e4 <strtol+0x37>
f0103808:	42                   	inc    %edx
f0103809:	bb 08 00 00 00       	mov    $0x8,%ebx
f010380e:	eb d4                	jmp    f01037e4 <strtol+0x37>
f0103810:	83 c2 02             	add    $0x2,%edx
f0103813:	bb 10 00 00 00       	mov    $0x10,%ebx
f0103818:	eb ca                	jmp    f01037e4 <strtol+0x37>
f010381a:	bb 0a 00 00 00       	mov    $0xa,%ebx
f010381f:	eb c3                	jmp    f01037e4 <strtol+0x37>
f0103821:	0f be c0             	movsbl %al,%eax
f0103824:	83 e8 30             	sub    $0x30,%eax
f0103827:	3b 45 10             	cmp    0x10(%ebp),%eax
f010382a:	7d 37                	jge    f0103863 <strtol+0xb6>
f010382c:	42                   	inc    %edx
f010382d:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0103831:	01 c1                	add    %eax,%ecx
f0103833:	8a 02                	mov    (%edx),%al
f0103835:	8d 70 d0             	lea    -0x30(%eax),%esi
f0103838:	89 f3                	mov    %esi,%ebx
f010383a:	80 fb 09             	cmp    $0x9,%bl
f010383d:	76 e2                	jbe    f0103821 <strtol+0x74>
f010383f:	8d 70 9f             	lea    -0x61(%eax),%esi
f0103842:	89 f3                	mov    %esi,%ebx
f0103844:	80 fb 19             	cmp    $0x19,%bl
f0103847:	77 08                	ja     f0103851 <strtol+0xa4>
f0103849:	0f be c0             	movsbl %al,%eax
f010384c:	83 e8 57             	sub    $0x57,%eax
f010384f:	eb d6                	jmp    f0103827 <strtol+0x7a>
f0103851:	8d 70 bf             	lea    -0x41(%eax),%esi
f0103854:	89 f3                	mov    %esi,%ebx
f0103856:	80 fb 19             	cmp    $0x19,%bl
f0103859:	77 08                	ja     f0103863 <strtol+0xb6>
f010385b:	0f be c0             	movsbl %al,%eax
f010385e:	83 e8 37             	sub    $0x37,%eax
f0103861:	eb c4                	jmp    f0103827 <strtol+0x7a>
f0103863:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0103867:	74 05                	je     f010386e <strtol+0xc1>
f0103869:	8b 45 0c             	mov    0xc(%ebp),%eax
f010386c:	89 10                	mov    %edx,(%eax)
f010386e:	85 ff                	test   %edi,%edi
f0103870:	74 02                	je     f0103874 <strtol+0xc7>
f0103872:	f7 d9                	neg    %ecx
f0103874:	89 c8                	mov    %ecx,%eax
f0103876:	5b                   	pop    %ebx
f0103877:	5e                   	pop    %esi
f0103878:	5f                   	pop    %edi
f0103879:	5d                   	pop    %ebp
f010387a:	c3                   	ret    
f010387b:	90                   	nop

f010387c <__udivdi3>:
f010387c:	55                   	push   %ebp
f010387d:	89 e5                	mov    %esp,%ebp
f010387f:	57                   	push   %edi
f0103880:	56                   	push   %esi
f0103881:	53                   	push   %ebx
f0103882:	83 ec 1c             	sub    $0x1c,%esp
f0103885:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103888:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f010388b:	8b 75 0c             	mov    0xc(%ebp),%esi
f010388e:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0103891:	8b 45 14             	mov    0x14(%ebp),%eax
f0103894:	85 c0                	test   %eax,%eax
f0103896:	75 18                	jne    f01038b0 <__udivdi3+0x34>
f0103898:	39 f3                	cmp    %esi,%ebx
f010389a:	76 44                	jbe    f01038e0 <__udivdi3+0x64>
f010389c:	89 f8                	mov    %edi,%eax
f010389e:	89 f2                	mov    %esi,%edx
f01038a0:	f7 f3                	div    %ebx
f01038a2:	31 ff                	xor    %edi,%edi
f01038a4:	89 fa                	mov    %edi,%edx
f01038a6:	83 c4 1c             	add    $0x1c,%esp
f01038a9:	5b                   	pop    %ebx
f01038aa:	5e                   	pop    %esi
f01038ab:	5f                   	pop    %edi
f01038ac:	5d                   	pop    %ebp
f01038ad:	c3                   	ret    
f01038ae:	66 90                	xchg   %ax,%ax
f01038b0:	39 f0                	cmp    %esi,%eax
f01038b2:	76 10                	jbe    f01038c4 <__udivdi3+0x48>
f01038b4:	31 ff                	xor    %edi,%edi
f01038b6:	31 c0                	xor    %eax,%eax
f01038b8:	89 fa                	mov    %edi,%edx
f01038ba:	83 c4 1c             	add    $0x1c,%esp
f01038bd:	5b                   	pop    %ebx
f01038be:	5e                   	pop    %esi
f01038bf:	5f                   	pop    %edi
f01038c0:	5d                   	pop    %ebp
f01038c1:	c3                   	ret    
f01038c2:	66 90                	xchg   %ax,%ax
f01038c4:	0f bd f8             	bsr    %eax,%edi
f01038c7:	83 f7 1f             	xor    $0x1f,%edi
f01038ca:	75 40                	jne    f010390c <__udivdi3+0x90>
f01038cc:	39 f0                	cmp    %esi,%eax
f01038ce:	72 09                	jb     f01038d9 <__udivdi3+0x5d>
f01038d0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01038d3:	0f 87 a3 00 00 00    	ja     f010397c <__udivdi3+0x100>
f01038d9:	b8 01 00 00 00       	mov    $0x1,%eax
f01038de:	eb d8                	jmp    f01038b8 <__udivdi3+0x3c>
f01038e0:	89 d9                	mov    %ebx,%ecx
f01038e2:	85 db                	test   %ebx,%ebx
f01038e4:	75 0b                	jne    f01038f1 <__udivdi3+0x75>
f01038e6:	b8 01 00 00 00       	mov    $0x1,%eax
f01038eb:	31 d2                	xor    %edx,%edx
f01038ed:	f7 f3                	div    %ebx
f01038ef:	89 c1                	mov    %eax,%ecx
f01038f1:	31 d2                	xor    %edx,%edx
f01038f3:	89 f0                	mov    %esi,%eax
f01038f5:	f7 f1                	div    %ecx
f01038f7:	89 c6                	mov    %eax,%esi
f01038f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01038fc:	f7 f1                	div    %ecx
f01038fe:	89 f7                	mov    %esi,%edi
f0103900:	89 fa                	mov    %edi,%edx
f0103902:	83 c4 1c             	add    $0x1c,%esp
f0103905:	5b                   	pop    %ebx
f0103906:	5e                   	pop    %esi
f0103907:	5f                   	pop    %edi
f0103908:	5d                   	pop    %ebp
f0103909:	c3                   	ret    
f010390a:	66 90                	xchg   %ax,%ax
f010390c:	ba 20 00 00 00       	mov    $0x20,%edx
f0103911:	29 fa                	sub    %edi,%edx
f0103913:	89 f9                	mov    %edi,%ecx
f0103915:	d3 e0                	shl    %cl,%eax
f0103917:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010391a:	89 d8                	mov    %ebx,%eax
f010391c:	88 d1                	mov    %dl,%cl
f010391e:	d3 e8                	shr    %cl,%eax
f0103920:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103923:	09 c1                	or     %eax,%ecx
f0103925:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0103928:	89 f9                	mov    %edi,%ecx
f010392a:	d3 e3                	shl    %cl,%ebx
f010392c:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f010392f:	89 f0                	mov    %esi,%eax
f0103931:	88 d1                	mov    %dl,%cl
f0103933:	d3 e8                	shr    %cl,%eax
f0103935:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103938:	89 f9                	mov    %edi,%ecx
f010393a:	d3 e6                	shl    %cl,%esi
f010393c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010393f:	88 d1                	mov    %dl,%cl
f0103941:	d3 eb                	shr    %cl,%ebx
f0103943:	89 d8                	mov    %ebx,%eax
f0103945:	09 f0                	or     %esi,%eax
f0103947:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010394a:	f7 75 e0             	divl   -0x20(%ebp)
f010394d:	89 d1                	mov    %edx,%ecx
f010394f:	89 c3                	mov    %eax,%ebx
f0103951:	f7 65 dc             	mull   -0x24(%ebp)
f0103954:	39 d1                	cmp    %edx,%ecx
f0103956:	72 18                	jb     f0103970 <__udivdi3+0xf4>
f0103958:	74 0a                	je     f0103964 <__udivdi3+0xe8>
f010395a:	89 d8                	mov    %ebx,%eax
f010395c:	31 ff                	xor    %edi,%edi
f010395e:	e9 55 ff ff ff       	jmp    f01038b8 <__udivdi3+0x3c>
f0103963:	90                   	nop
f0103964:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103967:	89 f9                	mov    %edi,%ecx
f0103969:	d3 e2                	shl    %cl,%edx
f010396b:	39 c2                	cmp    %eax,%edx
f010396d:	73 eb                	jae    f010395a <__udivdi3+0xde>
f010396f:	90                   	nop
f0103970:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0103973:	31 ff                	xor    %edi,%edi
f0103975:	e9 3e ff ff ff       	jmp    f01038b8 <__udivdi3+0x3c>
f010397a:	66 90                	xchg   %ax,%ax
f010397c:	31 c0                	xor    %eax,%eax
f010397e:	e9 35 ff ff ff       	jmp    f01038b8 <__udivdi3+0x3c>
f0103983:	90                   	nop

f0103984 <__umoddi3>:
f0103984:	55                   	push   %ebp
f0103985:	89 e5                	mov    %esp,%ebp
f0103987:	57                   	push   %edi
f0103988:	56                   	push   %esi
f0103989:	53                   	push   %ebx
f010398a:	83 ec 1c             	sub    $0x1c,%esp
f010398d:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103990:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103993:	8b 75 10             	mov    0x10(%ebp),%esi
f0103996:	8b 45 14             	mov    0x14(%ebp),%eax
f0103999:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f010399c:	89 da                	mov    %ebx,%edx
f010399e:	85 c0                	test   %eax,%eax
f01039a0:	75 16                	jne    f01039b8 <__umoddi3+0x34>
f01039a2:	39 de                	cmp    %ebx,%esi
f01039a4:	76 4e                	jbe    f01039f4 <__umoddi3+0x70>
f01039a6:	89 f8                	mov    %edi,%eax
f01039a8:	f7 f6                	div    %esi
f01039aa:	89 d0                	mov    %edx,%eax
f01039ac:	31 d2                	xor    %edx,%edx
f01039ae:	83 c4 1c             	add    $0x1c,%esp
f01039b1:	5b                   	pop    %ebx
f01039b2:	5e                   	pop    %esi
f01039b3:	5f                   	pop    %edi
f01039b4:	5d                   	pop    %ebp
f01039b5:	c3                   	ret    
f01039b6:	66 90                	xchg   %ax,%ax
f01039b8:	39 d8                	cmp    %ebx,%eax
f01039ba:	76 0c                	jbe    f01039c8 <__umoddi3+0x44>
f01039bc:	89 f8                	mov    %edi,%eax
f01039be:	83 c4 1c             	add    $0x1c,%esp
f01039c1:	5b                   	pop    %ebx
f01039c2:	5e                   	pop    %esi
f01039c3:	5f                   	pop    %edi
f01039c4:	5d                   	pop    %ebp
f01039c5:	c3                   	ret    
f01039c6:	66 90                	xchg   %ax,%ax
f01039c8:	0f bd c8             	bsr    %eax,%ecx
f01039cb:	83 f1 1f             	xor    $0x1f,%ecx
f01039ce:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01039d1:	75 41                	jne    f0103a14 <__umoddi3+0x90>
f01039d3:	39 d8                	cmp    %ebx,%eax
f01039d5:	72 04                	jb     f01039db <__umoddi3+0x57>
f01039d7:	39 fe                	cmp    %edi,%esi
f01039d9:	77 0d                	ja     f01039e8 <__umoddi3+0x64>
f01039db:	89 d9                	mov    %ebx,%ecx
f01039dd:	89 fa                	mov    %edi,%edx
f01039df:	29 f2                	sub    %esi,%edx
f01039e1:	19 c1                	sbb    %eax,%ecx
f01039e3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01039e6:	89 ca                	mov    %ecx,%edx
f01039e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01039eb:	83 c4 1c             	add    $0x1c,%esp
f01039ee:	5b                   	pop    %ebx
f01039ef:	5e                   	pop    %esi
f01039f0:	5f                   	pop    %edi
f01039f1:	5d                   	pop    %ebp
f01039f2:	c3                   	ret    
f01039f3:	90                   	nop
f01039f4:	89 f1                	mov    %esi,%ecx
f01039f6:	85 f6                	test   %esi,%esi
f01039f8:	75 0b                	jne    f0103a05 <__umoddi3+0x81>
f01039fa:	b8 01 00 00 00       	mov    $0x1,%eax
f01039ff:	31 d2                	xor    %edx,%edx
f0103a01:	f7 f6                	div    %esi
f0103a03:	89 c1                	mov    %eax,%ecx
f0103a05:	89 d8                	mov    %ebx,%eax
f0103a07:	31 d2                	xor    %edx,%edx
f0103a09:	f7 f1                	div    %ecx
f0103a0b:	89 f8                	mov    %edi,%eax
f0103a0d:	f7 f1                	div    %ecx
f0103a0f:	eb 99                	jmp    f01039aa <__umoddi3+0x26>
f0103a11:	8d 76 00             	lea    0x0(%esi),%esi
f0103a14:	ba 20 00 00 00       	mov    $0x20,%edx
f0103a19:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103a1c:	29 ca                	sub    %ecx,%edx
f0103a1e:	d3 e0                	shl    %cl,%eax
f0103a20:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103a23:	89 f0                	mov    %esi,%eax
f0103a25:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103a28:	88 d1                	mov    %dl,%cl
f0103a2a:	d3 e8                	shr    %cl,%eax
f0103a2c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103a2f:	09 c1                	or     %eax,%ecx
f0103a31:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0103a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103a37:	88 c1                	mov    %al,%cl
f0103a39:	d3 e6                	shl    %cl,%esi
f0103a3b:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0103a3e:	89 de                	mov    %ebx,%esi
f0103a40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103a43:	88 d1                	mov    %dl,%cl
f0103a45:	d3 ee                	shr    %cl,%esi
f0103a47:	88 c1                	mov    %al,%cl
f0103a49:	d3 e3                	shl    %cl,%ebx
f0103a4b:	89 f8                	mov    %edi,%eax
f0103a4d:	88 d1                	mov    %dl,%cl
f0103a4f:	d3 e8                	shr    %cl,%eax
f0103a51:	09 d8                	or     %ebx,%eax
f0103a53:	8a 4d e0             	mov    -0x20(%ebp),%cl
f0103a56:	d3 e7                	shl    %cl,%edi
f0103a58:	89 f2                	mov    %esi,%edx
f0103a5a:	f7 75 dc             	divl   -0x24(%ebp)
f0103a5d:	89 d3                	mov    %edx,%ebx
f0103a5f:	f7 65 d8             	mull   -0x28(%ebp)
f0103a62:	89 c6                	mov    %eax,%esi
f0103a64:	89 d1                	mov    %edx,%ecx
f0103a66:	39 d3                	cmp    %edx,%ebx
f0103a68:	72 2a                	jb     f0103a94 <__umoddi3+0x110>
f0103a6a:	74 24                	je     f0103a90 <__umoddi3+0x10c>
f0103a6c:	89 f8                	mov    %edi,%eax
f0103a6e:	29 f0                	sub    %esi,%eax
f0103a70:	19 cb                	sbb    %ecx,%ebx
f0103a72:	89 da                	mov    %ebx,%edx
f0103a74:	8a 4d e4             	mov    -0x1c(%ebp),%cl
f0103a77:	d3 e2                	shl    %cl,%edx
f0103a79:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103a7c:	89 f9                	mov    %edi,%ecx
f0103a7e:	d3 e8                	shr    %cl,%eax
f0103a80:	09 d0                	or     %edx,%eax
f0103a82:	d3 eb                	shr    %cl,%ebx
f0103a84:	89 da                	mov    %ebx,%edx
f0103a86:	83 c4 1c             	add    $0x1c,%esp
f0103a89:	5b                   	pop    %ebx
f0103a8a:	5e                   	pop    %esi
f0103a8b:	5f                   	pop    %edi
f0103a8c:	5d                   	pop    %ebp
f0103a8d:	c3                   	ret    
f0103a8e:	66 90                	xchg   %ax,%ax
f0103a90:	39 c7                	cmp    %eax,%edi
f0103a92:	73 d8                	jae    f0103a6c <__umoddi3+0xe8>
f0103a94:	2b 45 d8             	sub    -0x28(%ebp),%eax
f0103a97:	1b 55 dc             	sbb    -0x24(%ebp),%edx
f0103a9a:	89 d1                	mov    %edx,%ecx
f0103a9c:	89 c6                	mov    %eax,%esi
f0103a9e:	eb cc                	jmp    f0103a6c <__umoddi3+0xe8>
