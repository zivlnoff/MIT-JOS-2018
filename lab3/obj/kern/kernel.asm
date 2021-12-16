
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
f0100015:	b8 00 70 11 00       	mov    $0x117000,%eax
f010001a:	0f 22 d8             	mov    %eax,%cr3
f010001d:	0f 20 c0             	mov    %cr0,%eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
f0100025:	0f 22 c0             	mov    %eax,%cr0
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp
f0100034:	bc 00 70 11 f0       	mov    $0xf0117000,%esp
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
f010004b:	68 a0 3c 10 f0       	push   $0xf0103ca0
f0100050:	e8 d9 2c 00 00       	call   f0102d2e <cprintf>
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
f010006f:	68 bc 3c 10 f0       	push   $0xf0103cbc
f0100074:	e8 b5 2c 00 00       	call   f0102d2e <cprintf>
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
f010009a:	b8 80 99 11 f0       	mov    $0xf0119980,%eax
f010009f:	2d 00 93 11 f0       	sub    $0xf0119300,%eax
f01000a4:	50                   	push   %eax
f01000a5:	6a 00                	push   $0x0
f01000a7:	68 00 93 11 f0       	push   $0xf0119300
f01000ac:	e8 e8 37 00 00       	call   f0103899 <memset>
f01000b1:	e8 ca 04 00 00       	call   f0100580 <cons_init>
f01000b6:	c7 04 24 30 3d 10 f0 	movl   $0xf0103d30,(%esp)
f01000bd:	e8 6c 2c 00 00       	call   f0102d2e <cprintf>
f01000c2:	83 c4 08             	add    $0x8,%esp
f01000c5:	68 ac 1a 00 00       	push   $0x1aac
f01000ca:	68 d7 3c 10 f0       	push   $0xf0103cd7
f01000cf:	e8 5a 2c 00 00       	call   f0102d2e <cprintf>
f01000d4:	c7 45 f4 72 6c 64 00 	movl   $0x646c72,-0xc(%ebp)
f01000db:	83 c4 0c             	add    $0xc,%esp
f01000de:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01000e1:	50                   	push   %eax
f01000e2:	68 10 e1 00 00       	push   $0xe110
f01000e7:	68 f2 3c 10 f0       	push   $0xf0103cf2
f01000ec:	e8 3d 2c 00 00       	call   f0102d2e <cprintf>
f01000f1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f01000f8:	e8 43 ff ff ff       	call   f0100040 <test_backtrace>
f01000fd:	c7 04 24 a0 3d 10 f0 	movl   $0xf0103da0,(%esp)
f0100104:	e8 25 2c 00 00       	call   f0102d2e <cprintf>
f0100109:	c7 04 24 10 3e 10 f0 	movl   $0xf0103e10,(%esp)
f0100110:	e8 19 2c 00 00       	call   f0102d2e <cprintf>
f0100115:	e8 e4 10 00 00       	call   f01011fe <mem_init>
f010011a:	c7 04 24 7c 3e 10 f0 	movl   $0xf0103e7c,(%esp)
f0100121:	e8 08 2c 00 00       	call   f0102d2e <cprintf>
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
f010013f:	83 3d 00 93 11 f0 00 	cmpl   $0x0,0xf0119300
f0100146:	74 0f                	je     f0100157 <_panic+0x1f>
f0100148:	83 ec 0c             	sub    $0xc,%esp
f010014b:	6a 00                	push   $0x0
f010014d:	e8 9b 06 00 00       	call   f01007ed <monitor>
f0100152:	83 c4 10             	add    $0x10,%esp
f0100155:	eb f1                	jmp    f0100148 <_panic+0x10>
f0100157:	8b 45 10             	mov    0x10(%ebp),%eax
f010015a:	a3 00 93 11 f0       	mov    %eax,0xf0119300
f010015f:	fa                   	cli    
f0100160:	fc                   	cld    
f0100161:	8d 5d 14             	lea    0x14(%ebp),%ebx
f0100164:	83 ec 04             	sub    $0x4,%esp
f0100167:	ff 75 0c             	push   0xc(%ebp)
f010016a:	ff 75 08             	push   0x8(%ebp)
f010016d:	68 fd 3c 10 f0       	push   $0xf0103cfd
f0100172:	e8 b7 2b 00 00       	call   f0102d2e <cprintf>
f0100177:	83 c4 08             	add    $0x8,%esp
f010017a:	53                   	push   %ebx
f010017b:	ff 75 10             	push   0x10(%ebp)
f010017e:	e8 85 2b 00 00       	call   f0102d08 <vcprintf>
f0100183:	c7 04 24 ee 53 10 f0 	movl   $0xf01053ee,(%esp)
f010018a:	e8 9f 2b 00 00       	call   f0102d2e <cprintf>
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
f01001a4:	68 15 3d 10 f0       	push   $0xf0103d15
f01001a9:	e8 80 2b 00 00       	call   f0102d2e <cprintf>
f01001ae:	83 c4 08             	add    $0x8,%esp
f01001b1:	53                   	push   %ebx
f01001b2:	ff 75 10             	push   0x10(%ebp)
f01001b5:	e8 4e 2b 00 00       	call   f0102d08 <vcprintf>
f01001ba:	c7 04 24 ee 53 10 f0 	movl   $0xf01053ee,(%esp)
f01001c1:	e8 68 2b 00 00       	call   f0102d2e <cprintf>
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
f01001fc:	8b 0d 44 95 11 f0    	mov    0xf0119544,%ecx
f0100202:	8d 51 01             	lea    0x1(%ecx),%edx
f0100205:	89 15 44 95 11 f0    	mov    %edx,0xf0119544
f010020b:	88 81 40 93 11 f0    	mov    %al,-0xfee6cc0(%ecx)
f0100211:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0100217:	75 d8                	jne    f01001f1 <cons_intr+0x9>
f0100219:	c7 05 44 95 11 f0 00 	movl   $0x0,0xf0119544
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
f0100257:	8b 0d 20 93 11 f0    	mov    0xf0119320,%ecx
f010025d:	f6 c1 40             	test   $0x40,%cl
f0100260:	74 0e                	je     f0100270 <kbd_proc_data+0x46>
f0100262:	83 c8 80             	or     $0xffffff80,%eax
f0100265:	88 c2                	mov    %al,%dl
f0100267:	83 e1 bf             	and    $0xffffffbf,%ecx
f010026a:	89 0d 20 93 11 f0    	mov    %ecx,0xf0119320
f0100270:	0f b6 d2             	movzbl %dl,%edx
f0100273:	0f b6 82 40 40 10 f0 	movzbl -0xfefbfc0(%edx),%eax
f010027a:	0b 05 20 93 11 f0    	or     0xf0119320,%eax
f0100280:	0f b6 8a 40 3f 10 f0 	movzbl -0xfefc0c0(%edx),%ecx
f0100287:	31 c8                	xor    %ecx,%eax
f0100289:	a3 20 93 11 f0       	mov    %eax,0xf0119320
f010028e:	89 c1                	mov    %eax,%ecx
f0100290:	83 e1 03             	and    $0x3,%ecx
f0100293:	8b 0c 8d 20 3f 10 f0 	mov    -0xfefc0e0(,%ecx,4),%ecx
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
f01002b3:	83 0d 20 93 11 f0 40 	orl    $0x40,0xf0119320
f01002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002bf:	89 d8                	mov    %ebx,%eax
f01002c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002c4:	c9                   	leave  
f01002c5:	c3                   	ret    
f01002c6:	8b 0d 20 93 11 f0    	mov    0xf0119320,%ecx
f01002cc:	f6 c1 40             	test   $0x40,%cl
f01002cf:	75 05                	jne    f01002d6 <kbd_proc_data+0xac>
f01002d1:	83 e0 7f             	and    $0x7f,%eax
f01002d4:	88 c2                	mov    %al,%dl
f01002d6:	0f b6 d2             	movzbl %dl,%edx
f01002d9:	8a 82 40 40 10 f0    	mov    -0xfefbfc0(%edx),%al
f01002df:	83 c8 40             	or     $0x40,%eax
f01002e2:	0f b6 c0             	movzbl %al,%eax
f01002e5:	f7 d0                	not    %eax
f01002e7:	21 c8                	and    %ecx,%eax
f01002e9:	a3 20 93 11 f0       	mov    %eax,0xf0119320
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
f0100311:	68 e9 3e 10 f0       	push   $0xf0103ee9
f0100316:	e8 13 2a 00 00       	call   f0102d2e <cprintf>
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
f0100409:	66 8b 0d 48 95 11 f0 	mov    0xf0119548,%cx
f0100410:	bb 50 00 00 00       	mov    $0x50,%ebx
f0100415:	89 c8                	mov    %ecx,%eax
f0100417:	ba 00 00 00 00       	mov    $0x0,%edx
f010041c:	66 f7 f3             	div    %bx
f010041f:	29 d1                	sub    %edx,%ecx
f0100421:	66 89 0d 48 95 11 f0 	mov    %cx,0xf0119548
f0100428:	66 81 3d 48 95 11 f0 	cmpw   $0x7cf,0xf0119548
f010042f:	cf 07 
f0100431:	0f 87 8b 00 00 00    	ja     f01004c2 <cons_putc+0x18c>
f0100437:	8b 0d 50 95 11 f0    	mov    0xf0119550,%ecx
f010043d:	b0 0e                	mov    $0xe,%al
f010043f:	89 ca                	mov    %ecx,%edx
f0100441:	ee                   	out    %al,(%dx)
f0100442:	8d 59 01             	lea    0x1(%ecx),%ebx
f0100445:	66 a1 48 95 11 f0    	mov    0xf0119548,%ax
f010044b:	66 c1 e8 08          	shr    $0x8,%ax
f010044f:	89 da                	mov    %ebx,%edx
f0100451:	ee                   	out    %al,(%dx)
f0100452:	b0 0f                	mov    $0xf,%al
f0100454:	89 ca                	mov    %ecx,%edx
f0100456:	ee                   	out    %al,(%dx)
f0100457:	a0 48 95 11 f0       	mov    0xf0119548,%al
f010045c:	89 da                	mov    %ebx,%edx
f010045e:	ee                   	out    %al,(%dx)
f010045f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100462:	5b                   	pop    %ebx
f0100463:	5e                   	pop    %esi
f0100464:	5f                   	pop    %edi
f0100465:	5d                   	pop    %ebp
f0100466:	c3                   	ret    
f0100467:	66 a1 48 95 11 f0    	mov    0xf0119548,%ax
f010046d:	66 85 c0             	test   %ax,%ax
f0100470:	74 c5                	je     f0100437 <cons_putc+0x101>
f0100472:	48                   	dec    %eax
f0100473:	66 a3 48 95 11 f0    	mov    %ax,0xf0119548
f0100479:	0f b7 c0             	movzwl %ax,%eax
f010047c:	89 cf                	mov    %ecx,%edi
f010047e:	81 e7 00 ff ff ff    	and    $0xffffff00,%edi
f0100484:	83 cf 20             	or     $0x20,%edi
f0100487:	8b 15 4c 95 11 f0    	mov    0xf011954c,%edx
f010048d:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100491:	eb 95                	jmp    f0100428 <cons_putc+0xf2>
f0100493:	66 83 05 48 95 11 f0 	addw   $0x50,0xf0119548
f010049a:	50 
f010049b:	e9 69 ff ff ff       	jmp    f0100409 <cons_putc+0xd3>
f01004a0:	66 a1 48 95 11 f0    	mov    0xf0119548,%ax
f01004a6:	8d 50 01             	lea    0x1(%eax),%edx
f01004a9:	66 89 15 48 95 11 f0 	mov    %dx,0xf0119548
f01004b0:	0f b7 c0             	movzwl %ax,%eax
f01004b3:	8b 15 4c 95 11 f0    	mov    0xf011954c,%edx
f01004b9:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01004bd:	e9 66 ff ff ff       	jmp    f0100428 <cons_putc+0xf2>
f01004c2:	a1 4c 95 11 f0       	mov    0xf011954c,%eax
f01004c7:	83 ec 04             	sub    $0x4,%esp
f01004ca:	68 00 0f 00 00       	push   $0xf00
f01004cf:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d5:	52                   	push   %edx
f01004d6:	50                   	push   %eax
f01004d7:	e8 08 34 00 00       	call   f01038e4 <memmove>
f01004dc:	8b 15 4c 95 11 f0    	mov    0xf011954c,%edx
f01004e2:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004e8:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004ee:	83 c4 10             	add    $0x10,%esp
f01004f1:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01004f6:	83 c0 02             	add    $0x2,%eax
f01004f9:	39 d0                	cmp    %edx,%eax
f01004fb:	75 f4                	jne    f01004f1 <cons_putc+0x1bb>
f01004fd:	66 83 2d 48 95 11 f0 	subw   $0x50,0xf0119548
f0100504:	50 
f0100505:	e9 2d ff ff ff       	jmp    f0100437 <cons_putc+0x101>

f010050a <serial_intr>:
f010050a:	80 3d 54 95 11 f0 00 	cmpb   $0x0,0xf0119554
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
f0100548:	a1 40 95 11 f0       	mov    0xf0119540,%eax
f010054d:	3b 05 44 95 11 f0    	cmp    0xf0119544,%eax
f0100553:	74 24                	je     f0100579 <cons_getc+0x41>
f0100555:	8d 50 01             	lea    0x1(%eax),%edx
f0100558:	89 15 40 95 11 f0    	mov    %edx,0xf0119540
f010055e:	0f b6 80 40 93 11 f0 	movzbl -0xfee6cc0(%eax),%eax
f0100565:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010056b:	75 11                	jne    f010057e <cons_getc+0x46>
f010056d:	c7 05 40 95 11 f0 00 	movl   $0x0,0xf0119540
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
f01005b3:	89 1d 50 95 11 f0    	mov    %ebx,0xf0119550
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
f01005d2:	89 35 4c 95 11 f0    	mov    %esi,0xf011954c
f01005d8:	0f b6 c0             	movzbl %al,%eax
f01005db:	09 c8                	or     %ecx,%eax
f01005dd:	66 a3 48 95 11 f0    	mov    %ax,0xf0119548
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
f0100627:	0f 95 05 54 95 11 f0 	setne  0xf0119554
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
f010065d:	68 f5 3e 10 f0       	push   $0xf0103ef5
f0100662:	e8 c7 26 00 00       	call   f0102d2e <cprintf>
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
f0100699:	68 40 41 10 f0       	push   $0xf0104140
f010069e:	68 5e 41 10 f0       	push   $0xf010415e
f01006a3:	68 63 41 10 f0       	push   $0xf0104163
f01006a8:	e8 81 26 00 00       	call   f0102d2e <cprintf>
f01006ad:	83 c4 0c             	add    $0xc,%esp
f01006b0:	68 08 42 10 f0       	push   $0xf0104208
f01006b5:	68 6c 41 10 f0       	push   $0xf010416c
f01006ba:	68 63 41 10 f0       	push   $0xf0104163
f01006bf:	e8 6a 26 00 00       	call   f0102d2e <cprintf>
f01006c4:	83 c4 0c             	add    $0xc,%esp
f01006c7:	68 75 41 10 f0       	push   $0xf0104175
f01006cc:	68 93 41 10 f0       	push   $0xf0104193
f01006d1:	68 63 41 10 f0       	push   $0xf0104163
f01006d6:	e8 53 26 00 00       	call   f0102d2e <cprintf>
f01006db:	b8 00 00 00 00       	mov    $0x0,%eax
f01006e0:	c9                   	leave  
f01006e1:	c3                   	ret    

f01006e2 <mon_kerninfo>:
f01006e2:	55                   	push   %ebp
f01006e3:	89 e5                	mov    %esp,%ebp
f01006e5:	83 ec 14             	sub    $0x14,%esp
f01006e8:	68 9d 41 10 f0       	push   $0xf010419d
f01006ed:	e8 3c 26 00 00       	call   f0102d2e <cprintf>
f01006f2:	83 c4 08             	add    $0x8,%esp
f01006f5:	68 0c 00 10 00       	push   $0x10000c
f01006fa:	68 30 42 10 f0       	push   $0xf0104230
f01006ff:	e8 2a 26 00 00       	call   f0102d2e <cprintf>
f0100704:	83 c4 0c             	add    $0xc,%esp
f0100707:	68 0c 00 10 00       	push   $0x10000c
f010070c:	68 0c 00 10 f0       	push   $0xf010000c
f0100711:	68 58 42 10 f0       	push   $0xf0104258
f0100716:	e8 13 26 00 00       	call   f0102d2e <cprintf>
f010071b:	83 c4 0c             	add    $0xc,%esp
f010071e:	68 9c 3c 10 00       	push   $0x103c9c
f0100723:	68 9c 3c 10 f0       	push   $0xf0103c9c
f0100728:	68 7c 42 10 f0       	push   $0xf010427c
f010072d:	e8 fc 25 00 00       	call   f0102d2e <cprintf>
f0100732:	83 c4 0c             	add    $0xc,%esp
f0100735:	68 00 93 11 00       	push   $0x119300
f010073a:	68 00 93 11 f0       	push   $0xf0119300
f010073f:	68 a0 42 10 f0       	push   $0xf01042a0
f0100744:	e8 e5 25 00 00       	call   f0102d2e <cprintf>
f0100749:	83 c4 0c             	add    $0xc,%esp
f010074c:	68 80 99 11 00       	push   $0x119980
f0100751:	68 80 99 11 f0       	push   $0xf0119980
f0100756:	68 c4 42 10 f0       	push   $0xf01042c4
f010075b:	e8 ce 25 00 00       	call   f0102d2e <cprintf>
f0100760:	83 c4 08             	add    $0x8,%esp
f0100763:	b8 80 99 11 f0       	mov    $0xf0119980,%eax
f0100768:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
f010076d:	c1 f8 0a             	sar    $0xa,%eax
f0100770:	50                   	push   %eax
f0100771:	68 e8 42 10 f0       	push   $0xf01042e8
f0100776:	e8 b3 25 00 00       	call   f0102d2e <cprintf>
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
f01007a6:	68 14 43 10 f0       	push   $0xf0104314
f01007ab:	e8 7e 25 00 00       	call   f0102d2e <cprintf>
f01007b0:	83 c4 18             	add    $0x18,%esp
f01007b3:	57                   	push   %edi
f01007b4:	56                   	push   %esi
f01007b5:	e8 96 26 00 00       	call   f0102e50 <debuginfo_eip>
f01007ba:	83 c4 08             	add    $0x8,%esp
f01007bd:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01007c0:	56                   	push   %esi
f01007c1:	ff 75 d8             	push   -0x28(%ebp)
f01007c4:	ff 75 dc             	push   -0x24(%ebp)
f01007c7:	ff 75 d4             	push   -0x2c(%ebp)
f01007ca:	ff 75 d0             	push   -0x30(%ebp)
f01007cd:	68 b6 41 10 f0       	push   $0xf01041b6
f01007d2:	e8 57 25 00 00       	call   f0102d2e <cprintf>
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
f01007f6:	68 4c 43 10 f0       	push   $0xf010434c
f01007fb:	e8 2e 25 00 00       	call   f0102d2e <cprintf>
f0100800:	c7 04 24 70 43 10 f0 	movl   $0xf0104370,(%esp)
f0100807:	e8 22 25 00 00       	call   f0102d2e <cprintf>
f010080c:	83 c4 10             	add    $0x10,%esp
f010080f:	eb 47                	jmp    f0100858 <monitor+0x6b>
f0100811:	83 ec 08             	sub    $0x8,%esp
f0100814:	0f be c0             	movsbl %al,%eax
f0100817:	50                   	push   %eax
f0100818:	68 cd 41 10 f0       	push   $0xf01041cd
f010081d:	e8 40 30 00 00       	call   f0103862 <strchr>
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
f010084b:	68 d2 41 10 f0       	push   $0xf01041d2
f0100850:	e8 d9 24 00 00       	call   f0102d2e <cprintf>
f0100855:	83 c4 10             	add    $0x10,%esp
f0100858:	83 ec 0c             	sub    $0xc,%esp
f010085b:	68 c9 41 10 f0       	push   $0xf01041c9
f0100860:	e8 eb 2d 00 00       	call   f0103650 <readline>
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
f010088a:	68 cd 41 10 f0       	push   $0xf01041cd
f010088f:	e8 ce 2f 00 00       	call   f0103862 <strchr>
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
f01008b3:	bf a0 43 10 f0       	mov    $0xf01043a0,%edi
f01008b8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01008bd:	83 ec 08             	sub    $0x8,%esp
f01008c0:	ff 37                	push   (%edi)
f01008c2:	ff 75 a8             	push   -0x58(%ebp)
f01008c5:	e8 42 2f 00 00       	call   f010380c <strcmp>
f01008ca:	83 c4 10             	add    $0x10,%esp
f01008cd:	85 c0                	test   %eax,%eax
f01008cf:	74 21                	je     f01008f2 <monitor+0x105>
f01008d1:	43                   	inc    %ebx
f01008d2:	83 c7 0c             	add    $0xc,%edi
f01008d5:	83 fb 03             	cmp    $0x3,%ebx
f01008d8:	75 e3                	jne    f01008bd <monitor+0xd0>
f01008da:	83 ec 08             	sub    $0x8,%esp
f01008dd:	ff 75 a8             	push   -0x58(%ebp)
f01008e0:	68 ef 41 10 f0       	push   $0xf01041ef
f01008e5:	e8 44 24 00 00       	call   f0102d2e <cprintf>
f01008ea:	83 c4 10             	add    $0x10,%esp
f01008ed:	e9 66 ff ff ff       	jmp    f0100858 <monitor+0x6b>
f01008f2:	83 ec 04             	sub    $0x4,%esp
f01008f5:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
f01008f8:	01 d8                	add    %ebx,%eax
f01008fa:	ff 75 08             	push   0x8(%ebp)
f01008fd:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100900:	52                   	push   %edx
f0100901:	56                   	push   %esi
f0100902:	ff 14 85 a8 43 10 f0 	call   *-0xfefbc58(,%eax,4)
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
f0100927:	e8 9b 23 00 00       	call   f0102cc7 <mc146818_read>
f010092c:	89 c6                	mov    %eax,%esi
f010092e:	43                   	inc    %ebx
f010092f:	89 1c 24             	mov    %ebx,(%esp)
f0100932:	e8 90 23 00 00       	call   f0102cc7 <mc146818_read>
f0100937:	c1 e0 08             	shl    $0x8,%eax
f010093a:	09 f0                	or     %esi,%eax
f010093c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010093f:	5b                   	pop    %ebx
f0100940:	5e                   	pop    %esi
f0100941:	5d                   	pop    %ebp
f0100942:	c3                   	ret    

f0100943 <boot_alloc>:
f0100943:	83 3d 64 95 11 f0 00 	cmpl   $0x0,0xf0119564
f010094a:	74 21                	je     f010096d <boot_alloc+0x2a>
f010094c:	8b 15 64 95 11 f0    	mov    0xf0119564,%edx
f0100952:	8d 4a ff             	lea    -0x1(%edx),%ecx
f0100955:	01 c1                	add    %eax,%ecx
f0100957:	72 27                	jb     f0100980 <boot_alloc+0x3d>
f0100959:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100960:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100965:	a3 64 95 11 f0       	mov    %eax,0xf0119564
f010096a:	89 d0                	mov    %edx,%eax
f010096c:	c3                   	ret    
f010096d:	ba 7f a9 11 f0       	mov    $0xf011a97f,%edx
f0100972:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100978:	89 15 64 95 11 f0    	mov    %edx,0xf0119564
f010097e:	eb cc                	jmp    f010094c <boot_alloc+0x9>
f0100980:	55                   	push   %ebp
f0100981:	89 e5                	mov    %esp,%ebp
f0100983:	83 ec 08             	sub    $0x8,%esp
f0100986:	68 c4 43 10 f0       	push   $0xf01043c4
f010098b:	68 fd 50 10 f0       	push   $0xf01050fd
f0100990:	6a 6f                	push   $0x6f
f0100992:	68 12 51 10 f0       	push   $0xf0105112
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
f01009b3:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
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
f01009dc:	68 ec 43 10 f0       	push   $0xf01043ec
f01009e1:	68 32 03 00 00       	push   $0x332
f01009e6:	68 12 51 10 f0       	push   $0xf0105112
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
f0100a0d:	83 3d 6c 95 11 f0 00 	cmpl   $0x0,0xf011956c
f0100a14:	74 0a                	je     f0100a20 <check_page_free_list+0x24>
f0100a16:	be 00 04 00 00       	mov    $0x400,%esi
f0100a1b:	e9 e9 02 00 00       	jmp    f0100d09 <check_page_free_list+0x30d>
f0100a20:	83 ec 04             	sub    $0x4,%esp
f0100a23:	68 10 44 10 f0       	push   $0xf0104410
f0100a28:	68 6b 02 00 00       	push   $0x26b
f0100a2d:	68 12 51 10 f0       	push   $0xf0105112
f0100a32:	e8 01 f7 ff ff       	call   f0100138 <_panic>
f0100a37:	50                   	push   %eax
f0100a38:	68 ec 43 10 f0       	push   $0xf01043ec
f0100a3d:	6a 52                	push   $0x52
f0100a3f:	68 1e 51 10 f0       	push   $0xf010511e
f0100a44:	e8 ef f6 ff ff       	call   f0100138 <_panic>
f0100a49:	8b 1b                	mov    (%ebx),%ebx
f0100a4b:	85 db                	test   %ebx,%ebx
f0100a4d:	74 41                	je     f0100a90 <check_page_free_list+0x94>
f0100a4f:	89 d8                	mov    %ebx,%eax
f0100a51:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0100a57:	c1 f8 03             	sar    $0x3,%eax
f0100a5a:	c1 e0 0c             	shl    $0xc,%eax
f0100a5d:	89 c2                	mov    %eax,%edx
f0100a5f:	c1 ea 16             	shr    $0x16,%edx
f0100a62:	39 f2                	cmp    %esi,%edx
f0100a64:	73 e3                	jae    f0100a49 <check_page_free_list+0x4d>
f0100a66:	89 c2                	mov    %eax,%edx
f0100a68:	c1 ea 0c             	shr    $0xc,%edx
f0100a6b:	3b 15 60 95 11 f0    	cmp    0xf0119560,%edx
f0100a71:	73 c4                	jae    f0100a37 <check_page_free_list+0x3b>
f0100a73:	83 ec 04             	sub    $0x4,%esp
f0100a76:	68 80 00 00 00       	push   $0x80
f0100a7b:	68 97 00 00 00       	push   $0x97
f0100a80:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100a85:	50                   	push   %eax
f0100a86:	e8 0e 2e 00 00       	call   f0103899 <memset>
f0100a8b:	83 c4 10             	add    $0x10,%esp
f0100a8e:	eb b9                	jmp    f0100a49 <check_page_free_list+0x4d>
f0100a90:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a95:	e8 a9 fe ff ff       	call   f0100943 <boot_alloc>
f0100a9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100a9d:	83 ec 08             	sub    $0x8,%esp
f0100aa0:	50                   	push   %eax
f0100aa1:	68 2c 51 10 f0       	push   $0xf010512c
f0100aa6:	e8 83 22 00 00       	call   f0102d2e <cprintf>
f0100aab:	8b 15 6c 95 11 f0    	mov    0xf011956c,%edx
f0100ab1:	8b 0d 58 95 11 f0    	mov    0xf0119558,%ecx
f0100ab7:	a1 60 95 11 f0       	mov    0xf0119560,%eax
f0100abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100abf:	8d 3c c1             	lea    (%ecx,%eax,8),%edi
f0100ac2:	83 c4 10             	add    $0x10,%esp
f0100ac5:	be 00 00 00 00       	mov    $0x0,%esi
f0100aca:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0100acd:	e9 c8 00 00 00       	jmp    f0100b9a <check_page_free_list+0x19e>
f0100ad2:	68 42 51 10 f0       	push   $0xf0105142
f0100ad7:	68 fd 50 10 f0       	push   $0xf01050fd
f0100adc:	68 8c 02 00 00       	push   $0x28c
f0100ae1:	68 12 51 10 f0       	push   $0xf0105112
f0100ae6:	e8 4d f6 ff ff       	call   f0100138 <_panic>
f0100aeb:	68 4e 51 10 f0       	push   $0xf010514e
f0100af0:	68 fd 50 10 f0       	push   $0xf01050fd
f0100af5:	68 8d 02 00 00       	push   $0x28d
f0100afa:	68 12 51 10 f0       	push   $0xf0105112
f0100aff:	e8 34 f6 ff ff       	call   f0100138 <_panic>
f0100b04:	68 80 44 10 f0       	push   $0xf0104480
f0100b09:	68 fd 50 10 f0       	push   $0xf01050fd
f0100b0e:	68 8e 02 00 00       	push   $0x28e
f0100b13:	68 12 51 10 f0       	push   $0xf0105112
f0100b18:	e8 1b f6 ff ff       	call   f0100138 <_panic>
f0100b1d:	68 62 51 10 f0       	push   $0xf0105162
f0100b22:	68 fd 50 10 f0       	push   $0xf01050fd
f0100b27:	68 91 02 00 00       	push   $0x291
f0100b2c:	68 12 51 10 f0       	push   $0xf0105112
f0100b31:	e8 02 f6 ff ff       	call   f0100138 <_panic>
f0100b36:	68 73 51 10 f0       	push   $0xf0105173
f0100b3b:	68 fd 50 10 f0       	push   $0xf01050fd
f0100b40:	68 92 02 00 00       	push   $0x292
f0100b45:	68 12 51 10 f0       	push   $0xf0105112
f0100b4a:	e8 e9 f5 ff ff       	call   f0100138 <_panic>
f0100b4f:	68 b4 44 10 f0       	push   $0xf01044b4
f0100b54:	68 fd 50 10 f0       	push   $0xf01050fd
f0100b59:	68 93 02 00 00       	push   $0x293
f0100b5e:	68 12 51 10 f0       	push   $0xf0105112
f0100b63:	e8 d0 f5 ff ff       	call   f0100138 <_panic>
f0100b68:	68 8c 51 10 f0       	push   $0xf010518c
f0100b6d:	68 fd 50 10 f0       	push   $0xf01050fd
f0100b72:	68 94 02 00 00       	push   $0x294
f0100b77:	68 12 51 10 f0       	push   $0xf0105112
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
f0100bee:	68 ec 43 10 f0       	push   $0xf01043ec
f0100bf3:	6a 52                	push   $0x52
f0100bf5:	68 1e 51 10 f0       	push   $0xf010511e
f0100bfa:	e8 39 f5 ff ff       	call   f0100138 <_panic>
f0100bff:	68 d8 44 10 f0       	push   $0xf01044d8
f0100c04:	68 fd 50 10 f0       	push   $0xf01050fd
f0100c09:	68 95 02 00 00       	push   $0x295
f0100c0e:	68 12 51 10 f0       	push   $0xf0105112
f0100c13:	e8 20 f5 ff ff       	call   f0100138 <_panic>
f0100c18:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100c1b:	83 ec 04             	sub    $0x4,%esp
f0100c1e:	53                   	push   %ebx
f0100c1f:	56                   	push   %esi
f0100c20:	68 20 45 10 f0       	push   $0xf0104520
f0100c25:	e8 04 21 00 00       	call   f0102d2e <cprintf>
f0100c2a:	83 c4 08             	add    $0x8,%esp
f0100c2d:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100c32:	29 f0                	sub    %esi,%eax
f0100c34:	29 d8                	sub    %ebx,%eax
f0100c36:	50                   	push   %eax
f0100c37:	68 48 45 10 f0       	push   $0xf0104548
f0100c3c:	e8 ed 20 00 00       	call   f0102d2e <cprintf>
f0100c41:	83 c4 10             	add    $0x10,%esp
f0100c44:	85 f6                	test   %esi,%esi
f0100c46:	7e 19                	jle    f0100c61 <check_page_free_list+0x265>
f0100c48:	85 db                	test   %ebx,%ebx
f0100c4a:	7e 2e                	jle    f0100c7a <check_page_free_list+0x27e>
f0100c4c:	83 ec 0c             	sub    $0xc,%esp
f0100c4f:	68 6c 45 10 f0       	push   $0xf010456c
f0100c54:	e8 d5 20 00 00       	call   f0102d2e <cprintf>
f0100c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c5c:	5b                   	pop    %ebx
f0100c5d:	5e                   	pop    %esi
f0100c5e:	5f                   	pop    %edi
f0100c5f:	5d                   	pop    %ebp
f0100c60:	c3                   	ret    
f0100c61:	68 a6 51 10 f0       	push   $0xf01051a6
f0100c66:	68 fd 50 10 f0       	push   $0xf01050fd
f0100c6b:	68 a1 02 00 00       	push   $0x2a1
f0100c70:	68 12 51 10 f0       	push   $0xf0105112
f0100c75:	e8 be f4 ff ff       	call   f0100138 <_panic>
f0100c7a:	68 b8 51 10 f0       	push   $0xf01051b8
f0100c7f:	68 fd 50 10 f0       	push   $0xf01050fd
f0100c84:	68 a2 02 00 00       	push   $0x2a2
f0100c89:	68 12 51 10 f0       	push   $0xf0105112
f0100c8e:	e8 a5 f4 ff ff       	call   f0100138 <_panic>
f0100c93:	a1 6c 95 11 f0       	mov    0xf011956c,%eax
f0100c98:	85 c0                	test   %eax,%eax
f0100c9a:	0f 84 80 fd ff ff    	je     f0100a20 <check_page_free_list+0x24>
f0100ca0:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100ca3:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100ca6:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100ca9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100cac:	89 c2                	mov    %eax,%edx
f0100cae:	2b 15 58 95 11 f0    	sub    0xf0119558,%edx
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
f0100ce4:	68 34 44 10 f0       	push   $0xf0104434
f0100ce9:	e8 40 20 00 00       	call   f0102d2e <cprintf>
f0100cee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
f0100cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100cf7:	89 03                	mov    %eax,(%ebx)
f0100cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100cfc:	a3 6c 95 11 f0       	mov    %eax,0xf011956c
f0100d01:	83 c4 20             	add    $0x20,%esp
f0100d04:	be 01 00 00 00       	mov    $0x1,%esi
f0100d09:	8b 1d 6c 95 11 f0    	mov    0xf011956c,%ebx
f0100d0f:	e9 37 fd ff ff       	jmp    f0100a4b <check_page_free_list+0x4f>

f0100d14 <page_init>:
f0100d14:	55                   	push   %ebp
f0100d15:	89 e5                	mov    %esp,%ebp
f0100d17:	57                   	push   %edi
f0100d18:	56                   	push   %esi
f0100d19:	53                   	push   %ebx
f0100d1a:	83 ec 1c             	sub    $0x1c,%esp
f0100d1d:	8b 35 70 95 11 f0    	mov    0xf0119570,%esi
f0100d23:	89 f2                	mov    %esi,%edx
f0100d25:	c1 e2 0c             	shl    $0xc,%edx
f0100d28:	8b 0d 58 95 11 f0    	mov    0xf0119558,%ecx
f0100d2e:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100d34:	76 6b                	jbe    f0100da1 <page_init+0x8d>
f0100d36:	a1 60 95 11 f0       	mov    0xf0119560,%eax
f0100d3b:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100d42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d47:	8d bc 01 00 00 00 10 	lea    0x10000000(%ecx,%eax,1),%edi
f0100d4e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0100d51:	a1 68 95 11 f0       	mov    0xf0119568,%eax
f0100d56:	c1 e0 0a             	shl    $0xa,%eax
f0100d59:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100d5c:	83 ec 0c             	sub    $0xc,%esp
f0100d5f:	50                   	push   %eax
f0100d60:	57                   	push   %edi
f0100d61:	52                   	push   %edx
f0100d62:	68 00 10 00 00       	push   $0x1000
f0100d67:	68 b4 45 10 f0       	push   $0xf01045b4
f0100d6c:	e8 bd 1f 00 00       	call   f0102d2e <cprintf>
f0100d71:	83 c4 18             	add    $0x18,%esp
f0100d74:	ff 35 6c 95 11 f0    	push   0xf011956c
f0100d7a:	68 c9 51 10 f0       	push   $0xf01051c9
f0100d7f:	e8 aa 1f 00 00       	call   f0102d2e <cprintf>
f0100d84:	8b 1d 6c 95 11 f0    	mov    0xf011956c,%ebx
f0100d8a:	83 c4 10             	add    $0x10,%esp
f0100d8d:	b2 00                	mov    $0x0,%dl
f0100d8f:	b8 01 00 00 00       	mov    $0x1,%eax
f0100d94:	81 e6 ff ff 0f 00    	and    $0xfffff,%esi
f0100d9a:	bf 01 00 00 00       	mov    $0x1,%edi
f0100d9f:	eb 37                	jmp    f0100dd8 <page_init+0xc4>
f0100da1:	51                   	push   %ecx
f0100da2:	68 90 45 10 f0       	push   $0xf0104590
f0100da7:	68 22 01 00 00       	push   $0x122
f0100dac:	68 12 51 10 f0       	push   $0xf0105112
f0100db1:	e8 82 f3 ff ff       	call   f0100138 <_panic>
f0100db6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100dbd:	89 d1                	mov    %edx,%ecx
f0100dbf:	03 0d 58 95 11 f0    	add    0xf0119558,%ecx
f0100dc5:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100dcb:	89 19                	mov    %ebx,(%ecx)
f0100dcd:	89 d3                	mov    %edx,%ebx
f0100dcf:	03 1d 58 95 11 f0    	add    0xf0119558,%ebx
f0100dd5:	40                   	inc    %eax
f0100dd6:	89 fa                	mov    %edi,%edx
f0100dd8:	39 c6                	cmp    %eax,%esi
f0100dda:	77 da                	ja     f0100db6 <page_init+0xa2>
f0100ddc:	84 d2                	test   %dl,%dl
f0100dde:	74 06                	je     f0100de6 <page_init+0xd2>
f0100de0:	89 1d 6c 95 11 f0    	mov    %ebx,0xf011956c
f0100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100de9:	c1 e8 0c             	shr    $0xc,%eax
f0100dec:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100def:	c1 ee 0c             	shr    $0xc,%esi
f0100df2:	8b 1d 6c 95 11 f0    	mov    0xf011956c,%ebx
f0100df8:	b2 00                	mov    $0x0,%dl
f0100dfa:	bf 01 00 00 00       	mov    $0x1,%edi
f0100dff:	eb 22                	jmp    f0100e23 <page_init+0x10f>
f0100e01:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100e08:	89 d1                	mov    %edx,%ecx
f0100e0a:	03 0d 58 95 11 f0    	add    0xf0119558,%ecx
f0100e10:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100e16:	89 19                	mov    %ebx,(%ecx)
f0100e18:	89 d3                	mov    %edx,%ebx
f0100e1a:	03 1d 58 95 11 f0    	add    0xf0119558,%ebx
f0100e20:	40                   	inc    %eax
f0100e21:	89 fa                	mov    %edi,%edx
f0100e23:	39 c6                	cmp    %eax,%esi
f0100e25:	77 da                	ja     f0100e01 <page_init+0xed>
f0100e27:	84 d2                	test   %dl,%dl
f0100e29:	74 06                	je     f0100e31 <page_init+0x11d>
f0100e2b:	89 1d 6c 95 11 f0    	mov    %ebx,0xf011956c
f0100e31:	a1 6c 95 11 f0       	mov    0xf011956c,%eax
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
f0100e54:	68 e4 51 10 f0       	push   $0xf01051e4
f0100e59:	e8 e4 1e 00 00       	call   f0102d42 <memCprintf>
f0100e5e:	83 c4 20             	add    $0x20,%esp
f0100e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e64:	5b                   	pop    %ebx
f0100e65:	5e                   	pop    %esi
f0100e66:	5f                   	pop    %edi
f0100e67:	5d                   	pop    %ebp
f0100e68:	c3                   	ret    
f0100e69:	50                   	push   %eax
f0100e6a:	68 90 45 10 f0       	push   $0xf0104590
f0100e6f:	68 38 01 00 00       	push   $0x138
f0100e74:	68 12 51 10 f0       	push   $0xf0105112
f0100e79:	e8 ba f2 ff ff       	call   f0100138 <_panic>

f0100e7e <page_alloc>:
f0100e7e:	55                   	push   %ebp
f0100e7f:	89 e5                	mov    %esp,%ebp
f0100e81:	53                   	push   %ebx
f0100e82:	83 ec 04             	sub    $0x4,%esp
f0100e85:	8b 1d 6c 95 11 f0    	mov    0xf011956c,%ebx
f0100e8b:	85 db                	test   %ebx,%ebx
f0100e8d:	74 19                	je     f0100ea8 <page_alloc+0x2a>
f0100e8f:	8b 03                	mov    (%ebx),%eax
f0100e91:	a3 6c 95 11 f0       	mov    %eax,0xf011956c
f0100e96:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
f0100e9c:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
f0100ea2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100ea6:	75 07                	jne    f0100eaf <page_alloc+0x31>
f0100ea8:	89 d8                	mov    %ebx,%eax
f0100eaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ead:	c9                   	leave  
f0100eae:	c3                   	ret    
f0100eaf:	89 d8                	mov    %ebx,%eax
f0100eb1:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0100eb7:	c1 f8 03             	sar    $0x3,%eax
f0100eba:	89 c2                	mov    %eax,%edx
f0100ebc:	c1 e2 0c             	shl    $0xc,%edx
f0100ebf:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0100ec4:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f0100eca:	73 1b                	jae    f0100ee7 <page_alloc+0x69>
f0100ecc:	83 ec 04             	sub    $0x4,%esp
f0100ecf:	68 00 10 00 00       	push   $0x1000
f0100ed4:	6a 00                	push   $0x0
f0100ed6:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0100edc:	52                   	push   %edx
f0100edd:	e8 b7 29 00 00       	call   f0103899 <memset>
f0100ee2:	83 c4 10             	add    $0x10,%esp
f0100ee5:	eb c1                	jmp    f0100ea8 <page_alloc+0x2a>
f0100ee7:	52                   	push   %edx
f0100ee8:	68 ec 43 10 f0       	push   $0xf01043ec
f0100eed:	6a 52                	push   $0x52
f0100eef:	68 1e 51 10 f0       	push   $0xf010511e
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
f0100f0e:	8b 15 6c 95 11 f0    	mov    0xf011956c,%edx
f0100f14:	89 10                	mov    %edx,(%eax)
f0100f16:	a3 6c 95 11 f0       	mov    %eax,0xf011956c
f0100f1b:	c9                   	leave  
f0100f1c:	c3                   	ret    
f0100f1d:	68 f3 51 10 f0       	push   $0xf01051f3
f0100f22:	68 fd 50 10 f0       	push   $0xf01050fd
f0100f27:	68 5f 01 00 00       	push   $0x15f
f0100f2c:	68 12 51 10 f0       	push   $0xf0105112
f0100f31:	e8 02 f2 ff ff       	call   f0100138 <_panic>
f0100f36:	68 ff 51 10 f0       	push   $0xf01051ff
f0100f3b:	68 fd 50 10 f0       	push   $0xf01050fd
f0100f40:	68 60 01 00 00       	push   $0x160
f0100f45:	68 12 51 10 f0       	push   $0xf0105112
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
f0100f78:	53                   	push   %ebx
f0100f79:	83 ec 04             	sub    $0x4,%esp
f0100f7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100f7f:	c1 eb 16             	shr    $0x16,%ebx
f0100f82:	c1 e3 02             	shl    $0x2,%ebx
f0100f85:	03 5d 08             	add    0x8(%ebp),%ebx
f0100f88:	8b 03                	mov    (%ebx),%eax
f0100f8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100f8f:	75 2e                	jne    f0100fbf <pgdir_walk+0x4a>
f0100f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0100f95:	74 62                	je     f0100ff9 <pgdir_walk+0x84>
f0100f97:	83 ec 0c             	sub    $0xc,%esp
f0100f9a:	6a 01                	push   $0x1
f0100f9c:	e8 dd fe ff ff       	call   f0100e7e <page_alloc>
f0100fa1:	83 c4 10             	add    $0x10,%esp
f0100fa4:	85 c0                	test   %eax,%eax
f0100fa6:	74 37                	je     f0100fdf <pgdir_walk+0x6a>
f0100fa8:	66 ff 40 04          	incw   0x4(%eax)
f0100fac:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0100fb2:	c1 f8 03             	sar    $0x3,%eax
f0100fb5:	c1 e0 0c             	shl    $0xc,%eax
f0100fb8:	89 c2                	mov    %eax,%edx
f0100fba:	83 ca 03             	or     $0x3,%edx
f0100fbd:	89 13                	mov    %edx,(%ebx)
f0100fbf:	89 c2                	mov    %eax,%edx
f0100fc1:	c1 ea 0c             	shr    $0xc,%edx
f0100fc4:	3b 15 60 95 11 f0    	cmp    0xf0119560,%edx
f0100fca:	73 18                	jae    f0100fe4 <pgdir_walk+0x6f>
f0100fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100fcf:	c1 ea 0a             	shr    $0xa,%edx
f0100fd2:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
f0100fd8:	8d 84 10 00 00 00 f0 	lea    -0x10000000(%eax,%edx,1),%eax
f0100fdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fe2:	c9                   	leave  
f0100fe3:	c3                   	ret    
f0100fe4:	50                   	push   %eax
f0100fe5:	68 ec 43 10 f0       	push   $0xf01043ec
f0100fea:	68 c2 01 00 00       	push   $0x1c2
f0100fef:	68 12 51 10 f0       	push   $0xf0105112
f0100ff4:	e8 3f f1 ff ff       	call   f0100138 <_panic>
f0100ff9:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ffe:	eb df                	jmp    f0100fdf <pgdir_walk+0x6a>

f0101000 <boot_map_region>:
f0101000:	55                   	push   %ebp
f0101001:	89 e5                	mov    %esp,%ebp
f0101003:	57                   	push   %edi
f0101004:	56                   	push   %esi
f0101005:	53                   	push   %ebx
f0101006:	83 ec 1c             	sub    $0x1c,%esp
f0101009:	89 c7                	mov    %eax,%edi
f010100b:	89 d6                	mov    %edx,%esi
f010100d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0101010:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101015:	eb 24                	jmp    f010103b <boot_map_region+0x3b>
f0101017:	83 ec 04             	sub    $0x4,%esp
f010101a:	6a 01                	push   $0x1
f010101c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
f010101f:	50                   	push   %eax
f0101020:	57                   	push   %edi
f0101021:	e8 4f ff ff ff       	call   f0100f75 <pgdir_walk>
f0101026:	89 c2                	mov    %eax,%edx
f0101028:	89 d8                	mov    %ebx,%eax
f010102a:	03 45 08             	add    0x8(%ebp),%eax
f010102d:	0b 45 0c             	or     0xc(%ebp),%eax
f0101030:	89 02                	mov    %eax,(%edx)
f0101032:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101038:	83 c4 10             	add    $0x10,%esp
f010103b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010103e:	72 d7                	jb     f0101017 <boot_map_region+0x17>
f0101040:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101043:	5b                   	pop    %ebx
f0101044:	5e                   	pop    %esi
f0101045:	5f                   	pop    %edi
f0101046:	5d                   	pop    %ebp
f0101047:	c3                   	ret    

f0101048 <page_lookup>:
f0101048:	55                   	push   %ebp
f0101049:	89 e5                	mov    %esp,%ebp
f010104b:	53                   	push   %ebx
f010104c:	83 ec 08             	sub    $0x8,%esp
f010104f:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101052:	6a 00                	push   $0x0
f0101054:	ff 75 0c             	push   0xc(%ebp)
f0101057:	ff 75 08             	push   0x8(%ebp)
f010105a:	e8 16 ff ff ff       	call   f0100f75 <pgdir_walk>
f010105f:	83 c4 10             	add    $0x10,%esp
f0101062:	85 c0                	test   %eax,%eax
f0101064:	74 1c                	je     f0101082 <page_lookup+0x3a>
f0101066:	85 db                	test   %ebx,%ebx
f0101068:	74 02                	je     f010106c <page_lookup+0x24>
f010106a:	89 03                	mov    %eax,(%ebx)
f010106c:	8b 00                	mov    (%eax),%eax
f010106e:	c1 e8 0c             	shr    $0xc,%eax
f0101071:	39 05 60 95 11 f0    	cmp    %eax,0xf0119560
f0101077:	76 0e                	jbe    f0101087 <page_lookup+0x3f>
f0101079:	8b 15 58 95 11 f0    	mov    0xf0119558,%edx
f010107f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0101082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101085:	c9                   	leave  
f0101086:	c3                   	ret    
f0101087:	83 ec 04             	sub    $0x4,%esp
f010108a:	68 e8 45 10 f0       	push   $0xf01045e8
f010108f:	6a 4b                	push   $0x4b
f0101091:	68 1e 51 10 f0       	push   $0xf010511e
f0101096:	e8 9d f0 ff ff       	call   f0100138 <_panic>

f010109b <page_remove>:
f010109b:	55                   	push   %ebp
f010109c:	89 e5                	mov    %esp,%ebp
f010109e:	53                   	push   %ebx
f010109f:	83 ec 18             	sub    $0x18,%esp
f01010a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01010a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01010a8:	50                   	push   %eax
f01010a9:	53                   	push   %ebx
f01010aa:	ff 75 08             	push   0x8(%ebp)
f01010ad:	e8 96 ff ff ff       	call   f0101048 <page_lookup>
f01010b2:	83 c4 10             	add    $0x10,%esp
f01010b5:	85 c0                	test   %eax,%eax
f01010b7:	74 1e                	je     f01010d7 <page_remove+0x3c>
f01010b9:	83 ec 0c             	sub    $0xc,%esp
f01010bc:	50                   	push   %eax
f01010bd:	e8 8d fe ff ff       	call   f0100f4f <page_decref>
f01010c2:	83 c4 0c             	add    $0xc,%esp
f01010c5:	6a 04                	push   $0x4
f01010c7:	6a 00                	push   $0x0
f01010c9:	ff 75 f4             	push   -0xc(%ebp)
f01010cc:	e8 c8 27 00 00       	call   f0103899 <memset>
f01010d1:	0f 01 3b             	invlpg (%ebx)
f01010d4:	83 c4 10             	add    $0x10,%esp
f01010d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01010da:	c9                   	leave  
f01010db:	c3                   	ret    

f01010dc <page_insert>:
f01010dc:	55                   	push   %ebp
f01010dd:	89 e5                	mov    %esp,%ebp
f01010df:	57                   	push   %edi
f01010e0:	56                   	push   %esi
f01010e1:	53                   	push   %ebx
f01010e2:	83 ec 20             	sub    $0x20,%esp
f01010e5:	8b 7d 08             	mov    0x8(%ebp),%edi
f01010e8:	8b 75 0c             	mov    0xc(%ebp),%esi
f01010eb:	6a 00                	push   $0x0
f01010ed:	ff 75 10             	push   0x10(%ebp)
f01010f0:	57                   	push   %edi
f01010f1:	e8 7f fe ff ff       	call   f0100f75 <pgdir_walk>
f01010f6:	89 c3                	mov    %eax,%ebx
f01010f8:	83 c4 10             	add    $0x10,%esp
f01010fb:	85 c0                	test   %eax,%eax
f01010fd:	74 42                	je     f0101141 <page_insert+0x65>
f01010ff:	8b 00                	mov    (%eax),%eax
f0101101:	c1 e8 0c             	shr    $0xc,%eax
f0101104:	39 05 60 95 11 f0    	cmp    %eax,0xf0119560
f010110a:	76 21                	jbe    f010112d <page_insert+0x51>
f010110c:	8b 15 58 95 11 f0    	mov    0xf0119558,%edx
f0101112:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0101115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101118:	39 c6                	cmp    %eax,%esi
f010111a:	74 28                	je     f0101144 <page_insert+0x68>
f010111c:	83 ec 08             	sub    $0x8,%esp
f010111f:	ff 75 10             	push   0x10(%ebp)
f0101122:	57                   	push   %edi
f0101123:	e8 73 ff ff ff       	call   f010109b <page_remove>
f0101128:	83 c4 10             	add    $0x10,%esp
f010112b:	eb 17                	jmp    f0101144 <page_insert+0x68>
f010112d:	83 ec 04             	sub    $0x4,%esp
f0101130:	68 e8 45 10 f0       	push   $0xf01045e8
f0101135:	6a 4b                	push   $0x4b
f0101137:	68 1e 51 10 f0       	push   $0xf010511e
f010113c:	e8 f7 ef ff ff       	call   f0100138 <_panic>
f0101141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101144:	8b 45 10             	mov    0x10(%ebp),%eax
f0101147:	c1 e8 16             	shr    $0x16,%eax
f010114a:	8d 3c 87             	lea    (%edi,%eax,4),%edi
f010114d:	8b 07                	mov    (%edi),%eax
f010114f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101154:	75 2f                	jne    f0101185 <page_insert+0xa9>
f0101156:	83 ec 0c             	sub    $0xc,%esp
f0101159:	6a 01                	push   $0x1
f010115b:	e8 1e fd ff ff       	call   f0100e7e <page_alloc>
f0101160:	83 c4 10             	add    $0x10,%esp
f0101163:	85 c0                	test   %eax,%eax
f0101165:	0f 84 85 00 00 00    	je     f01011f0 <page_insert+0x114>
f010116b:	66 ff 40 04          	incw   0x4(%eax)
f010116f:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101175:	c1 f8 03             	sar    $0x3,%eax
f0101178:	c1 e0 0c             	shl    $0xc,%eax
f010117b:	89 c2                	mov    %eax,%edx
f010117d:	0b 55 14             	or     0x14(%ebp),%edx
f0101180:	83 ca 01             	or     $0x1,%edx
f0101183:	89 17                	mov    %edx,(%edi)
f0101185:	89 f2                	mov    %esi,%edx
f0101187:	2b 15 58 95 11 f0    	sub    0xf0119558,%edx
f010118d:	c1 fa 03             	sar    $0x3,%edx
f0101190:	c1 e2 0c             	shl    $0xc,%edx
f0101193:	0b 55 14             	or     0x14(%ebp),%edx
f0101196:	89 c1                	mov    %eax,%ecx
f0101198:	c1 e9 0c             	shr    $0xc,%ecx
f010119b:	3b 0d 60 95 11 f0    	cmp    0xf0119560,%ecx
f01011a1:	73 38                	jae    f01011db <page_insert+0xff>
f01011a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01011a6:	c1 e9 0c             	shr    $0xc,%ecx
f01011a9:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f01011af:	83 ca 01             	or     $0x1,%edx
f01011b2:	89 94 88 00 00 00 f0 	mov    %edx,-0x10000000(%eax,%ecx,4)
f01011b9:	0b 45 14             	or     0x14(%ebp),%eax
f01011bc:	83 c8 01             	or     $0x1,%eax
f01011bf:	89 07                	mov    %eax,(%edi)
f01011c1:	85 db                	test   %ebx,%ebx
f01011c3:	74 05                	je     f01011ca <page_insert+0xee>
f01011c5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f01011c8:	74 2d                	je     f01011f7 <page_insert+0x11b>
f01011ca:	66 ff 46 04          	incw   0x4(%esi)
f01011ce:	b8 00 00 00 00       	mov    $0x0,%eax
f01011d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011d6:	5b                   	pop    %ebx
f01011d7:	5e                   	pop    %esi
f01011d8:	5f                   	pop    %edi
f01011d9:	5d                   	pop    %ebp
f01011da:	c3                   	ret    
f01011db:	50                   	push   %eax
f01011dc:	68 ec 43 10 f0       	push   $0xf01043ec
f01011e1:	68 0e 02 00 00       	push   $0x20e
f01011e6:	68 12 51 10 f0       	push   $0xf0105112
f01011eb:	e8 48 ef ff ff       	call   f0100138 <_panic>
f01011f0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01011f5:	eb dc                	jmp    f01011d3 <page_insert+0xf7>
f01011f7:	b8 00 00 00 00       	mov    $0x0,%eax
f01011fc:	eb d5                	jmp    f01011d3 <page_insert+0xf7>

f01011fe <mem_init>:
f01011fe:	55                   	push   %ebp
f01011ff:	89 e5                	mov    %esp,%ebp
f0101201:	57                   	push   %edi
f0101202:	56                   	push   %esi
f0101203:	53                   	push   %ebx
f0101204:	83 ec 2c             	sub    $0x2c,%esp
f0101207:	b8 15 00 00 00       	mov    $0x15,%eax
f010120c:	e8 0b f7 ff ff       	call   f010091c <nvram_read>
f0101211:	89 c6                	mov    %eax,%esi
f0101213:	b8 17 00 00 00       	mov    $0x17,%eax
f0101218:	e8 ff f6 ff ff       	call   f010091c <nvram_read>
f010121d:	89 c3                	mov    %eax,%ebx
f010121f:	b8 34 00 00 00       	mov    $0x34,%eax
f0101224:	e8 f3 f6 ff ff       	call   f010091c <nvram_read>
f0101229:	c1 e0 06             	shl    $0x6,%eax
f010122c:	0f 84 c7 01 00 00    	je     f01013f9 <mem_init+0x1fb>
f0101232:	05 00 40 00 00       	add    $0x4000,%eax
f0101237:	a3 68 95 11 f0       	mov    %eax,0xf0119568
f010123c:	89 c2                	mov    %eax,%edx
f010123e:	c1 ea 02             	shr    $0x2,%edx
f0101241:	89 15 60 95 11 f0    	mov    %edx,0xf0119560
f0101247:	89 f2                	mov    %esi,%edx
f0101249:	c1 ea 02             	shr    $0x2,%edx
f010124c:	89 15 70 95 11 f0    	mov    %edx,0xf0119570
f0101252:	89 c2                	mov    %eax,%edx
f0101254:	29 f2                	sub    %esi,%edx
f0101256:	52                   	push   %edx
f0101257:	56                   	push   %esi
f0101258:	50                   	push   %eax
f0101259:	68 08 46 10 f0       	push   $0xf0104608
f010125e:	e8 cb 1a 00 00       	call   f0102d2e <cprintf>
f0101263:	83 c4 08             	add    $0x8,%esp
f0101266:	6a 02                	push   $0x2
f0101268:	68 0c 52 10 f0       	push   $0xf010520c
f010126d:	e8 bc 1a 00 00       	call   f0102d2e <cprintf>
f0101272:	83 c4 0c             	add    $0xc,%esp
f0101275:	6a 08                	push   $0x8
f0101277:	ff 35 60 95 11 f0    	push   0xf0119560
f010127d:	68 48 46 10 f0       	push   $0xf0104648
f0101282:	e8 a7 1a 00 00       	call   f0102d2e <cprintf>
f0101287:	b8 00 10 00 00       	mov    $0x1000,%eax
f010128c:	e8 b2 f6 ff ff       	call   f0100943 <boot_alloc>
f0101291:	a3 5c 95 11 f0       	mov    %eax,0xf011955c
f0101296:	83 c4 10             	add    $0x10,%esp
f0101299:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010129e:	0f 86 6b 01 00 00    	jbe    f010140f <mem_init+0x211>
f01012a4:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01012aa:	83 ec 0c             	sub    $0xc,%esp
f01012ad:	89 d1                	mov    %edx,%ecx
f01012af:	c1 e9 0c             	shr    $0xc,%ecx
f01012b2:	51                   	push   %ecx
f01012b3:	52                   	push   %edx
f01012b4:	89 c2                	mov    %eax,%edx
f01012b6:	c1 ea 16             	shr    $0x16,%edx
f01012b9:	52                   	push   %edx
f01012ba:	50                   	push   %eax
f01012bb:	68 23 52 10 f0       	push   $0xf0105223
f01012c0:	e8 7d 1a 00 00       	call   f0102d42 <memCprintf>
f01012c5:	83 c4 1c             	add    $0x1c,%esp
f01012c8:	68 00 10 00 00       	push   $0x1000
f01012cd:	6a 00                	push   $0x0
f01012cf:	ff 35 5c 95 11 f0    	push   0xf011955c
f01012d5:	e8 bf 25 00 00       	call   f0103899 <memset>
f01012da:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f01012df:	83 c4 10             	add    $0x10,%esp
f01012e2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01012e7:	0f 86 37 01 00 00    	jbe    f0101424 <mem_init+0x226>
f01012ed:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01012f3:	89 d1                	mov    %edx,%ecx
f01012f5:	83 c9 05             	or     $0x5,%ecx
f01012f8:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
f01012fe:	83 ec 0c             	sub    $0xc,%esp
f0101301:	89 d0                	mov    %edx,%eax
f0101303:	c1 e8 0c             	shr    $0xc,%eax
f0101306:	50                   	push   %eax
f0101307:	52                   	push   %edx
f0101308:	68 bd 03 00 00       	push   $0x3bd
f010130d:	68 00 00 40 ef       	push   $0xef400000
f0101312:	68 2e 52 10 f0       	push   $0xf010522e
f0101317:	e8 26 1a 00 00       	call   f0102d42 <memCprintf>
f010131c:	83 c4 20             	add    $0x20,%esp
f010131f:	a1 60 95 11 f0       	mov    0xf0119560,%eax
f0101324:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010132b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101330:	e8 0e f6 ff ff       	call   f0100943 <boot_alloc>
f0101335:	a3 58 95 11 f0       	mov    %eax,0xf0119558
f010133a:	83 ec 04             	sub    $0x4,%esp
f010133d:	8b 15 60 95 11 f0    	mov    0xf0119560,%edx
f0101343:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f010134a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101350:	52                   	push   %edx
f0101351:	6a 00                	push   $0x0
f0101353:	50                   	push   %eax
f0101354:	e8 40 25 00 00       	call   f0103899 <memset>
f0101359:	83 c4 08             	add    $0x8,%esp
f010135c:	a1 60 95 11 f0       	mov    0xf0119560,%eax
f0101361:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0101368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010136d:	c1 e8 0a             	shr    $0xa,%eax
f0101370:	50                   	push   %eax
f0101371:	68 33 52 10 f0       	push   $0xf0105233
f0101376:	e8 b3 19 00 00       	call   f0102d2e <cprintf>
f010137b:	a1 58 95 11 f0       	mov    0xf0119558,%eax
f0101380:	83 c4 10             	add    $0x10,%esp
f0101383:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101388:	0f 86 ab 00 00 00    	jbe    f0101439 <mem_init+0x23b>
f010138e:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101394:	83 ec 0c             	sub    $0xc,%esp
f0101397:	89 d1                	mov    %edx,%ecx
f0101399:	c1 e9 0c             	shr    $0xc,%ecx
f010139c:	51                   	push   %ecx
f010139d:	52                   	push   %edx
f010139e:	89 c2                	mov    %eax,%edx
f01013a0:	c1 ea 16             	shr    $0x16,%edx
f01013a3:	52                   	push   %edx
f01013a4:	50                   	push   %eax
f01013a5:	68 48 51 10 f0       	push   $0xf0105148
f01013aa:	e8 93 19 00 00       	call   f0102d42 <memCprintf>
f01013af:	83 c4 20             	add    $0x20,%esp
f01013b2:	e8 5d f9 ff ff       	call   f0100d14 <page_init>
f01013b7:	83 ec 0c             	sub    $0xc,%esp
f01013ba:	68 74 46 10 f0       	push   $0xf0104674
f01013bf:	e8 6a 19 00 00       	call   f0102d2e <cprintf>
f01013c4:	b8 01 00 00 00       	mov    $0x1,%eax
f01013c9:	e8 2e f6 ff ff       	call   f01009fc <check_page_free_list>
f01013ce:	c7 04 24 d0 46 10 f0 	movl   $0xf01046d0,(%esp)
f01013d5:	e8 54 19 00 00       	call   f0102d2e <cprintf>
f01013da:	83 c4 10             	add    $0x10,%esp
f01013dd:	83 3d 58 95 11 f0 00 	cmpl   $0x0,0xf0119558
f01013e4:	74 68                	je     f010144e <mem_init+0x250>
f01013e6:	a1 6c 95 11 f0       	mov    0xf011956c,%eax
f01013eb:	bb 00 00 00 00       	mov    $0x0,%ebx
f01013f0:	85 c0                	test   %eax,%eax
f01013f2:	74 71                	je     f0101465 <mem_init+0x267>
f01013f4:	43                   	inc    %ebx
f01013f5:	8b 00                	mov    (%eax),%eax
f01013f7:	eb f7                	jmp    f01013f0 <mem_init+0x1f2>
f01013f9:	85 db                	test   %ebx,%ebx
f01013fb:	74 0b                	je     f0101408 <mem_init+0x20a>
f01013fd:	8d 83 00 04 00 00    	lea    0x400(%ebx),%eax
f0101403:	e9 2f fe ff ff       	jmp    f0101237 <mem_init+0x39>
f0101408:	89 f0                	mov    %esi,%eax
f010140a:	e9 28 fe ff ff       	jmp    f0101237 <mem_init+0x39>
f010140f:	50                   	push   %eax
f0101410:	68 90 45 10 f0       	push   $0xf0104590
f0101415:	68 94 00 00 00       	push   $0x94
f010141a:	68 12 51 10 f0       	push   $0xf0105112
f010141f:	e8 14 ed ff ff       	call   f0100138 <_panic>
f0101424:	50                   	push   %eax
f0101425:	68 90 45 10 f0       	push   $0xf0104590
f010142a:	68 9e 00 00 00       	push   $0x9e
f010142f:	68 12 51 10 f0       	push   $0xf0105112
f0101434:	e8 ff ec ff ff       	call   f0100138 <_panic>
f0101439:	50                   	push   %eax
f010143a:	68 90 45 10 f0       	push   $0xf0104590
f010143f:	68 ab 00 00 00       	push   $0xab
f0101444:	68 12 51 10 f0       	push   $0xf0105112
f0101449:	e8 ea ec ff ff       	call   f0100138 <_panic>
f010144e:	83 ec 04             	sub    $0x4,%esp
f0101451:	68 4a 52 10 f0       	push   $0xf010524a
f0101456:	68 b3 02 00 00       	push   $0x2b3
f010145b:	68 12 51 10 f0       	push   $0xf0105112
f0101460:	e8 d3 ec ff ff       	call   f0100138 <_panic>
f0101465:	83 ec 0c             	sub    $0xc,%esp
f0101468:	6a 00                	push   $0x0
f010146a:	e8 0f fa ff ff       	call   f0100e7e <page_alloc>
f010146f:	89 c7                	mov    %eax,%edi
f0101471:	83 c4 10             	add    $0x10,%esp
f0101474:	85 c0                	test   %eax,%eax
f0101476:	0f 84 1b 02 00 00    	je     f0101697 <mem_init+0x499>
f010147c:	83 ec 0c             	sub    $0xc,%esp
f010147f:	6a 00                	push   $0x0
f0101481:	e8 f8 f9 ff ff       	call   f0100e7e <page_alloc>
f0101486:	89 c6                	mov    %eax,%esi
f0101488:	83 c4 10             	add    $0x10,%esp
f010148b:	85 c0                	test   %eax,%eax
f010148d:	0f 84 1d 02 00 00    	je     f01016b0 <mem_init+0x4b2>
f0101493:	83 ec 0c             	sub    $0xc,%esp
f0101496:	6a 00                	push   $0x0
f0101498:	e8 e1 f9 ff ff       	call   f0100e7e <page_alloc>
f010149d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01014a0:	83 c4 10             	add    $0x10,%esp
f01014a3:	85 c0                	test   %eax,%eax
f01014a5:	0f 84 1e 02 00 00    	je     f01016c9 <mem_init+0x4cb>
f01014ab:	39 f7                	cmp    %esi,%edi
f01014ad:	0f 84 2f 02 00 00    	je     f01016e2 <mem_init+0x4e4>
f01014b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014b6:	39 c6                	cmp    %eax,%esi
f01014b8:	0f 84 3d 02 00 00    	je     f01016fb <mem_init+0x4fd>
f01014be:	39 c7                	cmp    %eax,%edi
f01014c0:	0f 84 35 02 00 00    	je     f01016fb <mem_init+0x4fd>
f01014c6:	8b 0d 58 95 11 f0    	mov    0xf0119558,%ecx
f01014cc:	8b 15 60 95 11 f0    	mov    0xf0119560,%edx
f01014d2:	c1 e2 0c             	shl    $0xc,%edx
f01014d5:	89 f8                	mov    %edi,%eax
f01014d7:	29 c8                	sub    %ecx,%eax
f01014d9:	c1 f8 03             	sar    $0x3,%eax
f01014dc:	c1 e0 0c             	shl    $0xc,%eax
f01014df:	39 d0                	cmp    %edx,%eax
f01014e1:	0f 83 2d 02 00 00    	jae    f0101714 <mem_init+0x516>
f01014e7:	89 f0                	mov    %esi,%eax
f01014e9:	29 c8                	sub    %ecx,%eax
f01014eb:	c1 f8 03             	sar    $0x3,%eax
f01014ee:	c1 e0 0c             	shl    $0xc,%eax
f01014f1:	39 c2                	cmp    %eax,%edx
f01014f3:	0f 86 34 02 00 00    	jbe    f010172d <mem_init+0x52f>
f01014f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014fc:	29 c8                	sub    %ecx,%eax
f01014fe:	c1 f8 03             	sar    $0x3,%eax
f0101501:	c1 e0 0c             	shl    $0xc,%eax
f0101504:	39 c2                	cmp    %eax,%edx
f0101506:	0f 86 3a 02 00 00    	jbe    f0101746 <mem_init+0x548>
f010150c:	a1 6c 95 11 f0       	mov    0xf011956c,%eax
f0101511:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101514:	c7 05 6c 95 11 f0 00 	movl   $0x0,0xf011956c
f010151b:	00 00 00 
f010151e:	83 ec 0c             	sub    $0xc,%esp
f0101521:	6a 00                	push   $0x0
f0101523:	e8 56 f9 ff ff       	call   f0100e7e <page_alloc>
f0101528:	83 c4 10             	add    $0x10,%esp
f010152b:	85 c0                	test   %eax,%eax
f010152d:	0f 85 2c 02 00 00    	jne    f010175f <mem_init+0x561>
f0101533:	83 ec 0c             	sub    $0xc,%esp
f0101536:	57                   	push   %edi
f0101537:	e8 bd f9 ff ff       	call   f0100ef9 <page_free>
f010153c:	89 34 24             	mov    %esi,(%esp)
f010153f:	e8 b5 f9 ff ff       	call   f0100ef9 <page_free>
f0101544:	83 c4 04             	add    $0x4,%esp
f0101547:	ff 75 d4             	push   -0x2c(%ebp)
f010154a:	e8 aa f9 ff ff       	call   f0100ef9 <page_free>
f010154f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101556:	e8 23 f9 ff ff       	call   f0100e7e <page_alloc>
f010155b:	89 c6                	mov    %eax,%esi
f010155d:	83 c4 10             	add    $0x10,%esp
f0101560:	85 c0                	test   %eax,%eax
f0101562:	0f 84 10 02 00 00    	je     f0101778 <mem_init+0x57a>
f0101568:	83 ec 0c             	sub    $0xc,%esp
f010156b:	6a 00                	push   $0x0
f010156d:	e8 0c f9 ff ff       	call   f0100e7e <page_alloc>
f0101572:	89 c7                	mov    %eax,%edi
f0101574:	83 c4 10             	add    $0x10,%esp
f0101577:	85 c0                	test   %eax,%eax
f0101579:	0f 84 12 02 00 00    	je     f0101791 <mem_init+0x593>
f010157f:	83 ec 0c             	sub    $0xc,%esp
f0101582:	6a 00                	push   $0x0
f0101584:	e8 f5 f8 ff ff       	call   f0100e7e <page_alloc>
f0101589:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010158c:	83 c4 10             	add    $0x10,%esp
f010158f:	85 c0                	test   %eax,%eax
f0101591:	0f 84 13 02 00 00    	je     f01017aa <mem_init+0x5ac>
f0101597:	39 fe                	cmp    %edi,%esi
f0101599:	0f 84 24 02 00 00    	je     f01017c3 <mem_init+0x5c5>
f010159f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01015a2:	39 c7                	cmp    %eax,%edi
f01015a4:	0f 84 32 02 00 00    	je     f01017dc <mem_init+0x5de>
f01015aa:	39 c6                	cmp    %eax,%esi
f01015ac:	0f 84 2a 02 00 00    	je     f01017dc <mem_init+0x5de>
f01015b2:	83 ec 0c             	sub    $0xc,%esp
f01015b5:	6a 00                	push   $0x0
f01015b7:	e8 c2 f8 ff ff       	call   f0100e7e <page_alloc>
f01015bc:	83 c4 10             	add    $0x10,%esp
f01015bf:	85 c0                	test   %eax,%eax
f01015c1:	0f 85 2e 02 00 00    	jne    f01017f5 <mem_init+0x5f7>
f01015c7:	89 f0                	mov    %esi,%eax
f01015c9:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f01015cf:	c1 f8 03             	sar    $0x3,%eax
f01015d2:	89 c2                	mov    %eax,%edx
f01015d4:	c1 e2 0c             	shl    $0xc,%edx
f01015d7:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01015dc:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f01015e2:	0f 83 26 02 00 00    	jae    f010180e <mem_init+0x610>
f01015e8:	83 ec 04             	sub    $0x4,%esp
f01015eb:	68 00 10 00 00       	push   $0x1000
f01015f0:	6a 01                	push   $0x1
f01015f2:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01015f8:	52                   	push   %edx
f01015f9:	e8 9b 22 00 00       	call   f0103899 <memset>
f01015fe:	89 34 24             	mov    %esi,(%esp)
f0101601:	e8 f3 f8 ff ff       	call   f0100ef9 <page_free>
f0101606:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010160d:	e8 6c f8 ff ff       	call   f0100e7e <page_alloc>
f0101612:	83 c4 10             	add    $0x10,%esp
f0101615:	85 c0                	test   %eax,%eax
f0101617:	0f 84 03 02 00 00    	je     f0101820 <mem_init+0x622>
f010161d:	39 c6                	cmp    %eax,%esi
f010161f:	0f 85 14 02 00 00    	jne    f0101839 <mem_init+0x63b>
f0101625:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f010162b:	c1 f8 03             	sar    $0x3,%eax
f010162e:	89 c2                	mov    %eax,%edx
f0101630:	c1 e2 0c             	shl    $0xc,%edx
f0101633:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101638:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f010163e:	0f 83 0e 02 00 00    	jae    f0101852 <mem_init+0x654>
f0101644:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f010164a:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f0101650:	80 38 00             	cmpb   $0x0,(%eax)
f0101653:	0f 85 0b 02 00 00    	jne    f0101864 <mem_init+0x666>
f0101659:	40                   	inc    %eax
f010165a:	39 d0                	cmp    %edx,%eax
f010165c:	75 f2                	jne    f0101650 <mem_init+0x452>
f010165e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101661:	a3 6c 95 11 f0       	mov    %eax,0xf011956c
f0101666:	83 ec 0c             	sub    $0xc,%esp
f0101669:	56                   	push   %esi
f010166a:	e8 8a f8 ff ff       	call   f0100ef9 <page_free>
f010166f:	89 3c 24             	mov    %edi,(%esp)
f0101672:	e8 82 f8 ff ff       	call   f0100ef9 <page_free>
f0101677:	83 c4 04             	add    $0x4,%esp
f010167a:	ff 75 d4             	push   -0x2c(%ebp)
f010167d:	e8 77 f8 ff ff       	call   f0100ef9 <page_free>
f0101682:	a1 6c 95 11 f0       	mov    0xf011956c,%eax
f0101687:	83 c4 10             	add    $0x10,%esp
f010168a:	85 c0                	test   %eax,%eax
f010168c:	0f 84 eb 01 00 00    	je     f010187d <mem_init+0x67f>
f0101692:	4b                   	dec    %ebx
f0101693:	8b 00                	mov    (%eax),%eax
f0101695:	eb f3                	jmp    f010168a <mem_init+0x48c>
f0101697:	68 65 52 10 f0       	push   $0xf0105265
f010169c:	68 fd 50 10 f0       	push   $0xf01050fd
f01016a1:	68 bb 02 00 00       	push   $0x2bb
f01016a6:	68 12 51 10 f0       	push   $0xf0105112
f01016ab:	e8 88 ea ff ff       	call   f0100138 <_panic>
f01016b0:	68 7b 52 10 f0       	push   $0xf010527b
f01016b5:	68 fd 50 10 f0       	push   $0xf01050fd
f01016ba:	68 bc 02 00 00       	push   $0x2bc
f01016bf:	68 12 51 10 f0       	push   $0xf0105112
f01016c4:	e8 6f ea ff ff       	call   f0100138 <_panic>
f01016c9:	68 91 52 10 f0       	push   $0xf0105291
f01016ce:	68 fd 50 10 f0       	push   $0xf01050fd
f01016d3:	68 bd 02 00 00       	push   $0x2bd
f01016d8:	68 12 51 10 f0       	push   $0xf0105112
f01016dd:	e8 56 ea ff ff       	call   f0100138 <_panic>
f01016e2:	68 a7 52 10 f0       	push   $0xf01052a7
f01016e7:	68 fd 50 10 f0       	push   $0xf01050fd
f01016ec:	68 c0 02 00 00       	push   $0x2c0
f01016f1:	68 12 51 10 f0       	push   $0xf0105112
f01016f6:	e8 3d ea ff ff       	call   f0100138 <_panic>
f01016fb:	68 44 47 10 f0       	push   $0xf0104744
f0101700:	68 fd 50 10 f0       	push   $0xf01050fd
f0101705:	68 c1 02 00 00       	push   $0x2c1
f010170a:	68 12 51 10 f0       	push   $0xf0105112
f010170f:	e8 24 ea ff ff       	call   f0100138 <_panic>
f0101714:	68 64 47 10 f0       	push   $0xf0104764
f0101719:	68 fd 50 10 f0       	push   $0xf01050fd
f010171e:	68 c2 02 00 00       	push   $0x2c2
f0101723:	68 12 51 10 f0       	push   $0xf0105112
f0101728:	e8 0b ea ff ff       	call   f0100138 <_panic>
f010172d:	68 84 47 10 f0       	push   $0xf0104784
f0101732:	68 fd 50 10 f0       	push   $0xf01050fd
f0101737:	68 c3 02 00 00       	push   $0x2c3
f010173c:	68 12 51 10 f0       	push   $0xf0105112
f0101741:	e8 f2 e9 ff ff       	call   f0100138 <_panic>
f0101746:	68 a4 47 10 f0       	push   $0xf01047a4
f010174b:	68 fd 50 10 f0       	push   $0xf01050fd
f0101750:	68 c4 02 00 00       	push   $0x2c4
f0101755:	68 12 51 10 f0       	push   $0xf0105112
f010175a:	e8 d9 e9 ff ff       	call   f0100138 <_panic>
f010175f:	68 b9 52 10 f0       	push   $0xf01052b9
f0101764:	68 fd 50 10 f0       	push   $0xf01050fd
f0101769:	68 cb 02 00 00       	push   $0x2cb
f010176e:	68 12 51 10 f0       	push   $0xf0105112
f0101773:	e8 c0 e9 ff ff       	call   f0100138 <_panic>
f0101778:	68 65 52 10 f0       	push   $0xf0105265
f010177d:	68 fd 50 10 f0       	push   $0xf01050fd
f0101782:	68 d2 02 00 00       	push   $0x2d2
f0101787:	68 12 51 10 f0       	push   $0xf0105112
f010178c:	e8 a7 e9 ff ff       	call   f0100138 <_panic>
f0101791:	68 7b 52 10 f0       	push   $0xf010527b
f0101796:	68 fd 50 10 f0       	push   $0xf01050fd
f010179b:	68 d3 02 00 00       	push   $0x2d3
f01017a0:	68 12 51 10 f0       	push   $0xf0105112
f01017a5:	e8 8e e9 ff ff       	call   f0100138 <_panic>
f01017aa:	68 91 52 10 f0       	push   $0xf0105291
f01017af:	68 fd 50 10 f0       	push   $0xf01050fd
f01017b4:	68 d4 02 00 00       	push   $0x2d4
f01017b9:	68 12 51 10 f0       	push   $0xf0105112
f01017be:	e8 75 e9 ff ff       	call   f0100138 <_panic>
f01017c3:	68 a7 52 10 f0       	push   $0xf01052a7
f01017c8:	68 fd 50 10 f0       	push   $0xf01050fd
f01017cd:	68 d6 02 00 00       	push   $0x2d6
f01017d2:	68 12 51 10 f0       	push   $0xf0105112
f01017d7:	e8 5c e9 ff ff       	call   f0100138 <_panic>
f01017dc:	68 44 47 10 f0       	push   $0xf0104744
f01017e1:	68 fd 50 10 f0       	push   $0xf01050fd
f01017e6:	68 d7 02 00 00       	push   $0x2d7
f01017eb:	68 12 51 10 f0       	push   $0xf0105112
f01017f0:	e8 43 e9 ff ff       	call   f0100138 <_panic>
f01017f5:	68 b9 52 10 f0       	push   $0xf01052b9
f01017fa:	68 fd 50 10 f0       	push   $0xf01050fd
f01017ff:	68 d8 02 00 00       	push   $0x2d8
f0101804:	68 12 51 10 f0       	push   $0xf0105112
f0101809:	e8 2a e9 ff ff       	call   f0100138 <_panic>
f010180e:	52                   	push   %edx
f010180f:	68 ec 43 10 f0       	push   $0xf01043ec
f0101814:	6a 52                	push   $0x52
f0101816:	68 1e 51 10 f0       	push   $0xf010511e
f010181b:	e8 18 e9 ff ff       	call   f0100138 <_panic>
f0101820:	68 c8 52 10 f0       	push   $0xf01052c8
f0101825:	68 fd 50 10 f0       	push   $0xf01050fd
f010182a:	68 dd 02 00 00       	push   $0x2dd
f010182f:	68 12 51 10 f0       	push   $0xf0105112
f0101834:	e8 ff e8 ff ff       	call   f0100138 <_panic>
f0101839:	68 e6 52 10 f0       	push   $0xf01052e6
f010183e:	68 fd 50 10 f0       	push   $0xf01050fd
f0101843:	68 de 02 00 00       	push   $0x2de
f0101848:	68 12 51 10 f0       	push   $0xf0105112
f010184d:	e8 e6 e8 ff ff       	call   f0100138 <_panic>
f0101852:	52                   	push   %edx
f0101853:	68 ec 43 10 f0       	push   $0xf01043ec
f0101858:	6a 52                	push   $0x52
f010185a:	68 1e 51 10 f0       	push   $0xf010511e
f010185f:	e8 d4 e8 ff ff       	call   f0100138 <_panic>
f0101864:	68 f6 52 10 f0       	push   $0xf01052f6
f0101869:	68 fd 50 10 f0       	push   $0xf01050fd
f010186e:	68 e1 02 00 00       	push   $0x2e1
f0101873:	68 12 51 10 f0       	push   $0xf0105112
f0101878:	e8 bb e8 ff ff       	call   f0100138 <_panic>
f010187d:	85 db                	test   %ebx,%ebx
f010187f:	0f 85 bc 08 00 00    	jne    f0102141 <mem_init+0xf43>
f0101885:	83 ec 0c             	sub    $0xc,%esp
f0101888:	68 c4 47 10 f0       	push   $0xf01047c4
f010188d:	e8 9c 14 00 00       	call   f0102d2e <cprintf>
f0101892:	c7 04 24 e4 47 10 f0 	movl   $0xf01047e4,(%esp)
f0101899:	e8 90 14 00 00       	call   f0102d2e <cprintf>
f010189e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018a5:	e8 d4 f5 ff ff       	call   f0100e7e <page_alloc>
f01018aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018ad:	83 c4 10             	add    $0x10,%esp
f01018b0:	85 c0                	test   %eax,%eax
f01018b2:	0f 84 a2 08 00 00    	je     f010215a <mem_init+0xf5c>
f01018b8:	83 ec 0c             	sub    $0xc,%esp
f01018bb:	6a 00                	push   $0x0
f01018bd:	e8 bc f5 ff ff       	call   f0100e7e <page_alloc>
f01018c2:	89 c6                	mov    %eax,%esi
f01018c4:	83 c4 10             	add    $0x10,%esp
f01018c7:	85 c0                	test   %eax,%eax
f01018c9:	0f 84 a4 08 00 00    	je     f0102173 <mem_init+0xf75>
f01018cf:	83 ec 0c             	sub    $0xc,%esp
f01018d2:	6a 00                	push   $0x0
f01018d4:	e8 a5 f5 ff ff       	call   f0100e7e <page_alloc>
f01018d9:	89 c7                	mov    %eax,%edi
f01018db:	83 c4 10             	add    $0x10,%esp
f01018de:	85 c0                	test   %eax,%eax
f01018e0:	0f 84 a6 08 00 00    	je     f010218c <mem_init+0xf8e>
f01018e6:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f01018e9:	0f 84 b6 08 00 00    	je     f01021a5 <mem_init+0xfa7>
f01018ef:	39 c6                	cmp    %eax,%esi
f01018f1:	0f 84 c7 08 00 00    	je     f01021be <mem_init+0xfc0>
f01018f7:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01018fa:	0f 84 be 08 00 00    	je     f01021be <mem_init+0xfc0>
f0101900:	a1 6c 95 11 f0       	mov    0xf011956c,%eax
f0101905:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101908:	c7 05 6c 95 11 f0 00 	movl   $0x0,0xf011956c
f010190f:	00 00 00 
f0101912:	83 ec 0c             	sub    $0xc,%esp
f0101915:	6a 00                	push   $0x0
f0101917:	e8 62 f5 ff ff       	call   f0100e7e <page_alloc>
f010191c:	83 c4 10             	add    $0x10,%esp
f010191f:	85 c0                	test   %eax,%eax
f0101921:	0f 85 b0 08 00 00    	jne    f01021d7 <mem_init+0xfd9>
f0101927:	83 ec 04             	sub    $0x4,%esp
f010192a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010192d:	50                   	push   %eax
f010192e:	6a 00                	push   $0x0
f0101930:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101936:	e8 0d f7 ff ff       	call   f0101048 <page_lookup>
f010193b:	83 c4 10             	add    $0x10,%esp
f010193e:	85 c0                	test   %eax,%eax
f0101940:	0f 85 aa 08 00 00    	jne    f01021f0 <mem_init+0xff2>
f0101946:	6a 02                	push   $0x2
f0101948:	6a 00                	push   $0x0
f010194a:	56                   	push   %esi
f010194b:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101951:	e8 86 f7 ff ff       	call   f01010dc <page_insert>
f0101956:	83 c4 10             	add    $0x10,%esp
f0101959:	85 c0                	test   %eax,%eax
f010195b:	0f 89 a8 08 00 00    	jns    f0102209 <mem_init+0x100b>
f0101961:	83 ec 0c             	sub    $0xc,%esp
f0101964:	ff 75 d4             	push   -0x2c(%ebp)
f0101967:	e8 8d f5 ff ff       	call   f0100ef9 <page_free>
f010196c:	6a 02                	push   $0x2
f010196e:	6a 00                	push   $0x0
f0101970:	56                   	push   %esi
f0101971:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101977:	e8 60 f7 ff ff       	call   f01010dc <page_insert>
f010197c:	83 c4 20             	add    $0x20,%esp
f010197f:	85 c0                	test   %eax,%eax
f0101981:	0f 85 9b 08 00 00    	jne    f0102222 <mem_init+0x1024>
f0101987:	8b 1d 5c 95 11 f0    	mov    0xf011955c,%ebx
f010198d:	8b 0d 58 95 11 f0    	mov    0xf0119558,%ecx
f0101993:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101996:	8b 13                	mov    (%ebx),%edx
f0101998:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010199e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019a1:	29 c8                	sub    %ecx,%eax
f01019a3:	c1 f8 03             	sar    $0x3,%eax
f01019a6:	c1 e0 0c             	shl    $0xc,%eax
f01019a9:	39 c2                	cmp    %eax,%edx
f01019ab:	0f 85 8a 08 00 00    	jne    f010223b <mem_init+0x103d>
f01019b1:	ba 00 00 00 00       	mov    $0x0,%edx
f01019b6:	89 d8                	mov    %ebx,%eax
f01019b8:	e8 df ef ff ff       	call   f010099c <check_va2pa>
f01019bd:	89 c2                	mov    %eax,%edx
f01019bf:	89 f0                	mov    %esi,%eax
f01019c1:	2b 45 d0             	sub    -0x30(%ebp),%eax
f01019c4:	c1 f8 03             	sar    $0x3,%eax
f01019c7:	c1 e0 0c             	shl    $0xc,%eax
f01019ca:	39 c2                	cmp    %eax,%edx
f01019cc:	0f 85 82 08 00 00    	jne    f0102254 <mem_init+0x1056>
f01019d2:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01019d7:	0f 85 90 08 00 00    	jne    f010226d <mem_init+0x106f>
f01019dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019e0:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01019e5:	0f 85 9b 08 00 00    	jne    f0102286 <mem_init+0x1088>
f01019eb:	6a 02                	push   $0x2
f01019ed:	68 00 10 00 00       	push   $0x1000
f01019f2:	57                   	push   %edi
f01019f3:	53                   	push   %ebx
f01019f4:	e8 e3 f6 ff ff       	call   f01010dc <page_insert>
f01019f9:	83 c4 10             	add    $0x10,%esp
f01019fc:	85 c0                	test   %eax,%eax
f01019fe:	0f 85 9b 08 00 00    	jne    f010229f <mem_init+0x10a1>
f0101a04:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a09:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101a0e:	e8 89 ef ff ff       	call   f010099c <check_va2pa>
f0101a13:	89 c2                	mov    %eax,%edx
f0101a15:	89 f8                	mov    %edi,%eax
f0101a17:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101a1d:	c1 f8 03             	sar    $0x3,%eax
f0101a20:	c1 e0 0c             	shl    $0xc,%eax
f0101a23:	39 c2                	cmp    %eax,%edx
f0101a25:	0f 85 8d 08 00 00    	jne    f01022b8 <mem_init+0x10ba>
f0101a2b:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a30:	0f 85 9b 08 00 00    	jne    f01022d1 <mem_init+0x10d3>
f0101a36:	83 ec 0c             	sub    $0xc,%esp
f0101a39:	6a 00                	push   $0x0
f0101a3b:	e8 3e f4 ff ff       	call   f0100e7e <page_alloc>
f0101a40:	83 c4 10             	add    $0x10,%esp
f0101a43:	85 c0                	test   %eax,%eax
f0101a45:	0f 85 9f 08 00 00    	jne    f01022ea <mem_init+0x10ec>
f0101a4b:	6a 02                	push   $0x2
f0101a4d:	68 00 10 00 00       	push   $0x1000
f0101a52:	57                   	push   %edi
f0101a53:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101a59:	e8 7e f6 ff ff       	call   f01010dc <page_insert>
f0101a5e:	83 c4 10             	add    $0x10,%esp
f0101a61:	85 c0                	test   %eax,%eax
f0101a63:	0f 85 9a 08 00 00    	jne    f0102303 <mem_init+0x1105>
f0101a69:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a6e:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101a73:	e8 24 ef ff ff       	call   f010099c <check_va2pa>
f0101a78:	89 c2                	mov    %eax,%edx
f0101a7a:	89 f8                	mov    %edi,%eax
f0101a7c:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101a82:	c1 f8 03             	sar    $0x3,%eax
f0101a85:	c1 e0 0c             	shl    $0xc,%eax
f0101a88:	39 c2                	cmp    %eax,%edx
f0101a8a:	0f 85 8c 08 00 00    	jne    f010231c <mem_init+0x111e>
f0101a90:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a95:	0f 85 9a 08 00 00    	jne    f0102335 <mem_init+0x1137>
f0101a9b:	83 ec 0c             	sub    $0xc,%esp
f0101a9e:	6a 00                	push   $0x0
f0101aa0:	e8 d9 f3 ff ff       	call   f0100e7e <page_alloc>
f0101aa5:	83 c4 10             	add    $0x10,%esp
f0101aa8:	85 c0                	test   %eax,%eax
f0101aaa:	0f 85 9e 08 00 00    	jne    f010234e <mem_init+0x1150>
f0101ab0:	8b 15 5c 95 11 f0    	mov    0xf011955c,%edx
f0101ab6:	8b 02                	mov    (%edx),%eax
f0101ab8:	89 c3                	mov    %eax,%ebx
f0101aba:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101ac0:	c1 e8 0c             	shr    $0xc,%eax
f0101ac3:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f0101ac9:	0f 83 98 08 00 00    	jae    f0102367 <mem_init+0x1169>
f0101acf:	83 ec 04             	sub    $0x4,%esp
f0101ad2:	6a 00                	push   $0x0
f0101ad4:	68 00 10 00 00       	push   $0x1000
f0101ad9:	52                   	push   %edx
f0101ada:	e8 96 f4 ff ff       	call   f0100f75 <pgdir_walk>
f0101adf:	81 eb fc ff ff 0f    	sub    $0xffffffc,%ebx
f0101ae5:	83 c4 10             	add    $0x10,%esp
f0101ae8:	39 d8                	cmp    %ebx,%eax
f0101aea:	0f 85 8c 08 00 00    	jne    f010237c <mem_init+0x117e>
f0101af0:	6a 06                	push   $0x6
f0101af2:	68 00 10 00 00       	push   $0x1000
f0101af7:	57                   	push   %edi
f0101af8:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101afe:	e8 d9 f5 ff ff       	call   f01010dc <page_insert>
f0101b03:	83 c4 10             	add    $0x10,%esp
f0101b06:	85 c0                	test   %eax,%eax
f0101b08:	0f 85 87 08 00 00    	jne    f0102395 <mem_init+0x1197>
f0101b0e:	8b 1d 5c 95 11 f0    	mov    0xf011955c,%ebx
f0101b14:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b19:	89 d8                	mov    %ebx,%eax
f0101b1b:	e8 7c ee ff ff       	call   f010099c <check_va2pa>
f0101b20:	89 c2                	mov    %eax,%edx
f0101b22:	89 f8                	mov    %edi,%eax
f0101b24:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101b2a:	c1 f8 03             	sar    $0x3,%eax
f0101b2d:	c1 e0 0c             	shl    $0xc,%eax
f0101b30:	39 c2                	cmp    %eax,%edx
f0101b32:	0f 85 76 08 00 00    	jne    f01023ae <mem_init+0x11b0>
f0101b38:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101b3d:	0f 85 84 08 00 00    	jne    f01023c7 <mem_init+0x11c9>
f0101b43:	83 ec 04             	sub    $0x4,%esp
f0101b46:	6a 00                	push   $0x0
f0101b48:	68 00 10 00 00       	push   $0x1000
f0101b4d:	53                   	push   %ebx
f0101b4e:	e8 22 f4 ff ff       	call   f0100f75 <pgdir_walk>
f0101b53:	83 c4 10             	add    $0x10,%esp
f0101b56:	f6 00 04             	testb  $0x4,(%eax)
f0101b59:	0f 84 81 08 00 00    	je     f01023e0 <mem_init+0x11e2>
f0101b5f:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101b64:	f6 00 04             	testb  $0x4,(%eax)
f0101b67:	0f 84 8c 08 00 00    	je     f01023f9 <mem_init+0x11fb>
f0101b6d:	6a 02                	push   $0x2
f0101b6f:	68 00 10 00 00       	push   $0x1000
f0101b74:	57                   	push   %edi
f0101b75:	50                   	push   %eax
f0101b76:	e8 61 f5 ff ff       	call   f01010dc <page_insert>
f0101b7b:	83 c4 10             	add    $0x10,%esp
f0101b7e:	85 c0                	test   %eax,%eax
f0101b80:	0f 85 8c 08 00 00    	jne    f0102412 <mem_init+0x1214>
f0101b86:	83 ec 04             	sub    $0x4,%esp
f0101b89:	6a 00                	push   $0x0
f0101b8b:	68 00 10 00 00       	push   $0x1000
f0101b90:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101b96:	e8 da f3 ff ff       	call   f0100f75 <pgdir_walk>
f0101b9b:	83 c4 10             	add    $0x10,%esp
f0101b9e:	f6 00 02             	testb  $0x2,(%eax)
f0101ba1:	0f 84 84 08 00 00    	je     f010242b <mem_init+0x122d>
f0101ba7:	83 ec 04             	sub    $0x4,%esp
f0101baa:	6a 00                	push   $0x0
f0101bac:	68 00 10 00 00       	push   $0x1000
f0101bb1:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101bb7:	e8 b9 f3 ff ff       	call   f0100f75 <pgdir_walk>
f0101bbc:	83 c4 10             	add    $0x10,%esp
f0101bbf:	f6 00 04             	testb  $0x4,(%eax)
f0101bc2:	0f 85 7c 08 00 00    	jne    f0102444 <mem_init+0x1246>
f0101bc8:	6a 02                	push   $0x2
f0101bca:	68 00 00 40 00       	push   $0x400000
f0101bcf:	ff 75 d4             	push   -0x2c(%ebp)
f0101bd2:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101bd8:	e8 ff f4 ff ff       	call   f01010dc <page_insert>
f0101bdd:	83 c4 10             	add    $0x10,%esp
f0101be0:	85 c0                	test   %eax,%eax
f0101be2:	0f 89 75 08 00 00    	jns    f010245d <mem_init+0x125f>
f0101be8:	6a 02                	push   $0x2
f0101bea:	68 00 10 00 00       	push   $0x1000
f0101bef:	56                   	push   %esi
f0101bf0:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101bf6:	e8 e1 f4 ff ff       	call   f01010dc <page_insert>
f0101bfb:	83 c4 10             	add    $0x10,%esp
f0101bfe:	85 c0                	test   %eax,%eax
f0101c00:	0f 85 70 08 00 00    	jne    f0102476 <mem_init+0x1278>
f0101c06:	83 ec 04             	sub    $0x4,%esp
f0101c09:	6a 00                	push   $0x0
f0101c0b:	68 00 10 00 00       	push   $0x1000
f0101c10:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101c16:	e8 5a f3 ff ff       	call   f0100f75 <pgdir_walk>
f0101c1b:	83 c4 10             	add    $0x10,%esp
f0101c1e:	f6 00 04             	testb  $0x4,(%eax)
f0101c21:	0f 85 68 08 00 00    	jne    f010248f <mem_init+0x1291>
f0101c27:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101c2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101c2f:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c34:	e8 63 ed ff ff       	call   f010099c <check_va2pa>
f0101c39:	89 f3                	mov    %esi,%ebx
f0101c3b:	2b 1d 58 95 11 f0    	sub    0xf0119558,%ebx
f0101c41:	c1 fb 03             	sar    $0x3,%ebx
f0101c44:	c1 e3 0c             	shl    $0xc,%ebx
f0101c47:	39 d8                	cmp    %ebx,%eax
f0101c49:	0f 85 59 08 00 00    	jne    f01024a8 <mem_init+0x12aa>
f0101c4f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c57:	e8 40 ed ff ff       	call   f010099c <check_va2pa>
f0101c5c:	39 c3                	cmp    %eax,%ebx
f0101c5e:	0f 85 5d 08 00 00    	jne    f01024c1 <mem_init+0x12c3>
f0101c64:	66 83 7e 04 02       	cmpw   $0x2,0x4(%esi)
f0101c69:	0f 85 6b 08 00 00    	jne    f01024da <mem_init+0x12dc>
f0101c6f:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101c74:	0f 85 79 08 00 00    	jne    f01024f3 <mem_init+0x12f5>
f0101c7a:	83 ec 0c             	sub    $0xc,%esp
f0101c7d:	6a 00                	push   $0x0
f0101c7f:	e8 fa f1 ff ff       	call   f0100e7e <page_alloc>
f0101c84:	83 c4 10             	add    $0x10,%esp
f0101c87:	85 c0                	test   %eax,%eax
f0101c89:	0f 84 7d 08 00 00    	je     f010250c <mem_init+0x130e>
f0101c8f:	39 c7                	cmp    %eax,%edi
f0101c91:	0f 85 75 08 00 00    	jne    f010250c <mem_init+0x130e>
f0101c97:	83 ec 08             	sub    $0x8,%esp
f0101c9a:	6a 00                	push   $0x0
f0101c9c:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101ca2:	e8 f4 f3 ff ff       	call   f010109b <page_remove>
f0101ca7:	8b 1d 5c 95 11 f0    	mov    0xf011955c,%ebx
f0101cad:	ba 00 00 00 00       	mov    $0x0,%edx
f0101cb2:	89 d8                	mov    %ebx,%eax
f0101cb4:	e8 e3 ec ff ff       	call   f010099c <check_va2pa>
f0101cb9:	83 c4 10             	add    $0x10,%esp
f0101cbc:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101cbf:	0f 85 60 08 00 00    	jne    f0102525 <mem_init+0x1327>
f0101cc5:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101cca:	89 d8                	mov    %ebx,%eax
f0101ccc:	e8 cb ec ff ff       	call   f010099c <check_va2pa>
f0101cd1:	89 c2                	mov    %eax,%edx
f0101cd3:	89 f0                	mov    %esi,%eax
f0101cd5:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101cdb:	c1 f8 03             	sar    $0x3,%eax
f0101cde:	c1 e0 0c             	shl    $0xc,%eax
f0101ce1:	39 c2                	cmp    %eax,%edx
f0101ce3:	0f 85 55 08 00 00    	jne    f010253e <mem_init+0x1340>
f0101ce9:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101cee:	0f 85 63 08 00 00    	jne    f0102557 <mem_init+0x1359>
f0101cf4:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101cf9:	0f 85 71 08 00 00    	jne    f0102570 <mem_init+0x1372>
f0101cff:	6a 00                	push   $0x0
f0101d01:	68 00 10 00 00       	push   $0x1000
f0101d06:	56                   	push   %esi
f0101d07:	53                   	push   %ebx
f0101d08:	e8 cf f3 ff ff       	call   f01010dc <page_insert>
f0101d0d:	83 c4 10             	add    $0x10,%esp
f0101d10:	85 c0                	test   %eax,%eax
f0101d12:	0f 85 71 08 00 00    	jne    f0102589 <mem_init+0x138b>
f0101d18:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d1d:	0f 84 7f 08 00 00    	je     f01025a2 <mem_init+0x13a4>
f0101d23:	83 3e 00             	cmpl   $0x0,(%esi)
f0101d26:	0f 85 8f 08 00 00    	jne    f01025bb <mem_init+0x13bd>
f0101d2c:	83 ec 08             	sub    $0x8,%esp
f0101d2f:	68 00 10 00 00       	push   $0x1000
f0101d34:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101d3a:	e8 5c f3 ff ff       	call   f010109b <page_remove>
f0101d3f:	8b 1d 5c 95 11 f0    	mov    0xf011955c,%ebx
f0101d45:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d4a:	89 d8                	mov    %ebx,%eax
f0101d4c:	e8 4b ec ff ff       	call   f010099c <check_va2pa>
f0101d51:	83 c4 10             	add    $0x10,%esp
f0101d54:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d57:	0f 85 77 08 00 00    	jne    f01025d4 <mem_init+0x13d6>
f0101d5d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d62:	89 d8                	mov    %ebx,%eax
f0101d64:	e8 33 ec ff ff       	call   f010099c <check_va2pa>
f0101d69:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d6c:	0f 85 7b 08 00 00    	jne    f01025ed <mem_init+0x13ef>
f0101d72:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d77:	0f 85 89 08 00 00    	jne    f0102606 <mem_init+0x1408>
f0101d7d:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101d82:	0f 85 97 08 00 00    	jne    f010261f <mem_init+0x1421>
f0101d88:	83 ec 0c             	sub    $0xc,%esp
f0101d8b:	6a 00                	push   $0x0
f0101d8d:	e8 ec f0 ff ff       	call   f0100e7e <page_alloc>
f0101d92:	83 c4 10             	add    $0x10,%esp
f0101d95:	85 c0                	test   %eax,%eax
f0101d97:	0f 84 9b 08 00 00    	je     f0102638 <mem_init+0x143a>
f0101d9d:	39 c6                	cmp    %eax,%esi
f0101d9f:	0f 85 93 08 00 00    	jne    f0102638 <mem_init+0x143a>
f0101da5:	83 ec 0c             	sub    $0xc,%esp
f0101da8:	6a 00                	push   $0x0
f0101daa:	e8 cf f0 ff ff       	call   f0100e7e <page_alloc>
f0101daf:	83 c4 10             	add    $0x10,%esp
f0101db2:	85 c0                	test   %eax,%eax
f0101db4:	0f 85 97 08 00 00    	jne    f0102651 <mem_init+0x1453>
f0101dba:	8b 0d 5c 95 11 f0    	mov    0xf011955c,%ecx
f0101dc0:	8b 11                	mov    (%ecx),%edx
f0101dc2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101dc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dcb:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101dd1:	c1 f8 03             	sar    $0x3,%eax
f0101dd4:	c1 e0 0c             	shl    $0xc,%eax
f0101dd7:	39 c2                	cmp    %eax,%edx
f0101dd9:	0f 85 8b 08 00 00    	jne    f010266a <mem_init+0x146c>
f0101ddf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0101de5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101de8:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ded:	0f 85 90 08 00 00    	jne    f0102683 <mem_init+0x1485>
f0101df3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101df6:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0101dfc:	83 ec 0c             	sub    $0xc,%esp
f0101dff:	50                   	push   %eax
f0101e00:	e8 f4 f0 ff ff       	call   f0100ef9 <page_free>
f0101e05:	83 c4 0c             	add    $0xc,%esp
f0101e08:	6a 01                	push   $0x1
f0101e0a:	68 00 10 40 00       	push   $0x401000
f0101e0f:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101e15:	e8 5b f1 ff ff       	call   f0100f75 <pgdir_walk>
f0101e1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e1d:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101e22:	8b 40 04             	mov    0x4(%eax),%eax
f0101e25:	89 c3                	mov    %eax,%ebx
f0101e27:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101e2d:	89 c2                	mov    %eax,%edx
f0101e2f:	c1 ea 0c             	shr    $0xc,%edx
f0101e32:	83 c4 10             	add    $0x10,%esp
f0101e35:	3b 15 60 95 11 f0    	cmp    0xf0119560,%edx
f0101e3b:	0f 83 5b 08 00 00    	jae    f010269c <mem_init+0x149e>
f0101e41:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0101e47:	83 ec 08             	sub    $0x8,%esp
f0101e4a:	6a 01                	push   $0x1
f0101e4c:	52                   	push   %edx
f0101e4d:	ff 75 d0             	push   -0x30(%ebp)
f0101e50:	50                   	push   %eax
f0101e51:	53                   	push   %ebx
f0101e52:	68 50 4c 10 f0       	push   $0xf0104c50
f0101e57:	e8 d2 0e 00 00       	call   f0102d2e <cprintf>
f0101e5c:	81 eb fc ff ff 0f    	sub    $0xffffffc,%ebx
f0101e62:	83 c4 20             	add    $0x20,%esp
f0101e65:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0101e68:	0f 85 43 08 00 00    	jne    f01026b1 <mem_init+0x14b3>
f0101e6e:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101e73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
f0101e7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e7d:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0101e83:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101e89:	c1 f8 03             	sar    $0x3,%eax
f0101e8c:	89 c2                	mov    %eax,%edx
f0101e8e:	c1 e2 0c             	shl    $0xc,%edx
f0101e91:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101e96:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f0101e9c:	0f 83 28 08 00 00    	jae    f01026ca <mem_init+0x14cc>
f0101ea2:	83 ec 04             	sub    $0x4,%esp
f0101ea5:	68 00 10 00 00       	push   $0x1000
f0101eaa:	68 ff 00 00 00       	push   $0xff
f0101eaf:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101eb5:	52                   	push   %edx
f0101eb6:	e8 de 19 00 00       	call   f0103899 <memset>
f0101ebb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101ebe:	89 1c 24             	mov    %ebx,(%esp)
f0101ec1:	e8 33 f0 ff ff       	call   f0100ef9 <page_free>
f0101ec6:	83 c4 0c             	add    $0xc,%esp
f0101ec9:	6a 01                	push   $0x1
f0101ecb:	6a 00                	push   $0x0
f0101ecd:	ff 35 5c 95 11 f0    	push   0xf011955c
f0101ed3:	e8 9d f0 ff ff       	call   f0100f75 <pgdir_walk>
f0101ed8:	89 d8                	mov    %ebx,%eax
f0101eda:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0101ee0:	c1 f8 03             	sar    $0x3,%eax
f0101ee3:	89 c2                	mov    %eax,%edx
f0101ee5:	c1 e2 0c             	shl    $0xc,%edx
f0101ee8:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101eed:	83 c4 10             	add    $0x10,%esp
f0101ef0:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f0101ef6:	0f 83 e0 07 00 00    	jae    f01026dc <mem_init+0x14de>
f0101efc:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101f02:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f0101f08:	8b 18                	mov    (%eax),%ebx
f0101f0a:	83 e3 01             	and    $0x1,%ebx
f0101f0d:	0f 85 db 07 00 00    	jne    f01026ee <mem_init+0x14f0>
f0101f13:	83 c0 04             	add    $0x4,%eax
f0101f16:	39 d0                	cmp    %edx,%eax
f0101f18:	75 ee                	jne    f0101f08 <mem_init+0xd0a>
f0101f1a:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101f25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f28:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f0101f2e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101f31:	89 0d 6c 95 11 f0    	mov    %ecx,0xf011956c
f0101f37:	83 ec 0c             	sub    $0xc,%esp
f0101f3a:	50                   	push   %eax
f0101f3b:	e8 b9 ef ff ff       	call   f0100ef9 <page_free>
f0101f40:	89 34 24             	mov    %esi,(%esp)
f0101f43:	e8 b1 ef ff ff       	call   f0100ef9 <page_free>
f0101f48:	89 3c 24             	mov    %edi,(%esp)
f0101f4b:	e8 a9 ef ff ff       	call   f0100ef9 <page_free>
f0101f50:	c7 04 24 d7 53 10 f0 	movl   $0xf01053d7,(%esp)
f0101f57:	e8 d2 0d 00 00       	call   f0102d2e <cprintf>
f0101f5c:	c7 04 24 b0 4c 10 f0 	movl   $0xf0104cb0,(%esp)
f0101f63:	e8 c6 0d 00 00       	call   f0102d2e <cprintf>
f0101f68:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0101f6d:	83 c4 10             	add    $0x10,%esp
f0101f70:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101f75:	0f 86 8c 07 00 00    	jbe    f0102707 <mem_init+0x1509>
f0101f7b:	05 00 00 00 10       	add    $0x10000000,%eax
f0101f80:	83 ec 0c             	sub    $0xc,%esp
f0101f83:	89 c2                	mov    %eax,%edx
f0101f85:	c1 ea 0c             	shr    $0xc,%edx
f0101f88:	52                   	push   %edx
f0101f89:	50                   	push   %eax
f0101f8a:	68 bd 03 00 00       	push   $0x3bd
f0101f8f:	68 00 00 40 ef       	push   $0xef400000
f0101f94:	68 2e 52 10 f0       	push   $0xf010522e
f0101f99:	e8 a4 0d 00 00       	call   f0102d42 <memCprintf>
f0101f9e:	a1 58 95 11 f0       	mov    0xf0119558,%eax
f0101fa3:	83 c4 20             	add    $0x20,%esp
f0101fa6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101fab:	0f 86 6b 07 00 00    	jbe    f010271c <mem_init+0x151e>
f0101fb1:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101fb7:	83 ec 0c             	sub    $0xc,%esp
f0101fba:	89 d1                	mov    %edx,%ecx
f0101fbc:	c1 e9 0c             	shr    $0xc,%ecx
f0101fbf:	51                   	push   %ecx
f0101fc0:	52                   	push   %edx
f0101fc1:	89 c2                	mov    %eax,%edx
f0101fc3:	c1 ea 16             	shr    $0x16,%edx
f0101fc6:	52                   	push   %edx
f0101fc7:	50                   	push   %eax
f0101fc8:	68 48 51 10 f0       	push   $0xf0105148
f0101fcd:	e8 70 0d 00 00       	call   f0102d42 <memCprintf>
f0101fd2:	83 c4 14             	add    $0x14,%esp
f0101fd5:	68 ec 4c 10 f0       	push   $0xf0104cec
f0101fda:	e8 4f 0d 00 00       	call   f0102d2e <cprintf>
f0101fdf:	83 c4 08             	add    $0x8,%esp
f0101fe2:	6a 00                	push   $0x0
f0101fe4:	68 f0 53 10 f0       	push   $0xf01053f0
f0101fe9:	e8 40 0d 00 00       	call   f0102d2e <cprintf>
f0101fee:	a1 58 95 11 f0       	mov    0xf0119558,%eax
f0101ff3:	83 c4 10             	add    $0x10,%esp
f0101ff6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101ffb:	0f 86 30 07 00 00    	jbe    f0102731 <mem_init+0x1533>
f0102001:	8b 15 60 95 11 f0    	mov    0xf0119560,%edx
f0102007:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f010200e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102014:	83 ec 08             	sub    $0x8,%esp
f0102017:	6a 05                	push   $0x5
f0102019:	05 00 00 00 10       	add    $0x10000000,%eax
f010201e:	50                   	push   %eax
f010201f:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102024:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0102029:	e8 d2 ef ff ff       	call   f0101000 <boot_map_region>
f010202e:	c7 04 24 50 4d 10 f0 	movl   $0xf0104d50,(%esp)
f0102035:	e8 f4 0c 00 00       	call   f0102d2e <cprintf>
f010203a:	83 c4 10             	add    $0x10,%esp
f010203d:	b8 00 f0 10 f0       	mov    $0xf010f000,%eax
f0102042:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102047:	0f 86 f9 06 00 00    	jbe    f0102746 <mem_init+0x1548>
f010204d:	83 ec 08             	sub    $0x8,%esp
f0102050:	6a 01                	push   $0x1
f0102052:	68 00 f0 10 00       	push   $0x10f000
f0102057:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010205c:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102061:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0102066:	e8 95 ef ff ff       	call   f0101000 <boot_map_region>
f010206b:	c7 04 24 bc 4d 10 f0 	movl   $0xf0104dbc,(%esp)
f0102072:	e8 b7 0c 00 00       	call   f0102d2e <cprintf>
f0102077:	83 c4 08             	add    $0x8,%esp
f010207a:	6a 03                	push   $0x3
f010207c:	6a 00                	push   $0x0
f010207e:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102083:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102088:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f010208d:	e8 6e ef ff ff       	call   f0101000 <boot_map_region>
f0102092:	c7 04 24 08 4e 10 f0 	movl   $0xf0104e08,(%esp)
f0102099:	e8 90 0c 00 00       	call   f0102d2e <cprintf>
f010209e:	8b 3d 5c 95 11 f0    	mov    0xf011955c,%edi
f01020a4:	a1 60 95 11 f0       	mov    0xf0119560,%eax
f01020a9:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01020b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01020b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01020b8:	8b 35 58 95 11 f0    	mov    0xf0119558,%esi
f01020be:	83 c4 10             	add    $0x10,%esp
f01020c1:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f01020c7:	0f 86 8e 06 00 00    	jbe    f010275b <mem_init+0x155d>
f01020cd:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01020d2:	89 f8                	mov    %edi,%eax
f01020d4:	e8 c3 e8 ff ff       	call   f010099c <check_va2pa>
f01020d9:	83 ec 04             	sub    $0x4,%esp
f01020dc:	81 c6 00 00 00 10    	add    $0x10000000,%esi
f01020e2:	56                   	push   %esi
f01020e3:	50                   	push   %eax
f01020e4:	68 6c 4e 10 f0       	push   $0xf0104e6c
f01020e9:	e8 40 0c 00 00       	call   f0102d2e <cprintf>
f01020ee:	a1 58 95 11 f0       	mov    0xf0119558,%eax
f01020f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01020f6:	05 00 00 00 10       	add    $0x10000000,%eax
f01020fb:	83 c4 10             	add    $0x10,%esp
f01020fe:	89 de                	mov    %ebx,%esi
f0102100:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0102103:	89 c7                	mov    %eax,%edi
f0102105:	89 5d c8             	mov    %ebx,-0x38(%ebp)
f0102108:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f010210b:	39 f3                	cmp    %esi,%ebx
f010210d:	0f 86 8d 06 00 00    	jbe    f01027a0 <mem_init+0x15a2>
f0102113:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f0102119:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010211c:	e8 7b e8 ff ff       	call   f010099c <check_va2pa>
f0102121:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102128:	0f 86 42 06 00 00    	jbe    f0102770 <mem_init+0x1572>
f010212e:	8d 14 3e             	lea    (%esi,%edi,1),%edx
f0102131:	39 c2                	cmp    %eax,%edx
f0102133:	0f 85 4e 06 00 00    	jne    f0102787 <mem_init+0x1589>
f0102139:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010213f:	eb ca                	jmp    f010210b <mem_init+0xf0d>
f0102141:	68 00 53 10 f0       	push   $0xf0105300
f0102146:	68 fd 50 10 f0       	push   $0xf01050fd
f010214b:	68 ee 02 00 00       	push   $0x2ee
f0102150:	68 12 51 10 f0       	push   $0xf0105112
f0102155:	e8 de df ff ff       	call   f0100138 <_panic>
f010215a:	68 65 52 10 f0       	push   $0xf0105265
f010215f:	68 fd 50 10 f0       	push   $0xf01050fd
f0102164:	68 45 03 00 00       	push   $0x345
f0102169:	68 12 51 10 f0       	push   $0xf0105112
f010216e:	e8 c5 df ff ff       	call   f0100138 <_panic>
f0102173:	68 7b 52 10 f0       	push   $0xf010527b
f0102178:	68 fd 50 10 f0       	push   $0xf01050fd
f010217d:	68 46 03 00 00       	push   $0x346
f0102182:	68 12 51 10 f0       	push   $0xf0105112
f0102187:	e8 ac df ff ff       	call   f0100138 <_panic>
f010218c:	68 91 52 10 f0       	push   $0xf0105291
f0102191:	68 fd 50 10 f0       	push   $0xf01050fd
f0102196:	68 47 03 00 00       	push   $0x347
f010219b:	68 12 51 10 f0       	push   $0xf0105112
f01021a0:	e8 93 df ff ff       	call   f0100138 <_panic>
f01021a5:	68 a7 52 10 f0       	push   $0xf01052a7
f01021aa:	68 fd 50 10 f0       	push   $0xf01050fd
f01021af:	68 4a 03 00 00       	push   $0x34a
f01021b4:	68 12 51 10 f0       	push   $0xf0105112
f01021b9:	e8 7a df ff ff       	call   f0100138 <_panic>
f01021be:	68 44 47 10 f0       	push   $0xf0104744
f01021c3:	68 fd 50 10 f0       	push   $0xf01050fd
f01021c8:	68 4b 03 00 00       	push   $0x34b
f01021cd:	68 12 51 10 f0       	push   $0xf0105112
f01021d2:	e8 61 df ff ff       	call   f0100138 <_panic>
f01021d7:	68 b9 52 10 f0       	push   $0xf01052b9
f01021dc:	68 fd 50 10 f0       	push   $0xf01050fd
f01021e1:	68 52 03 00 00       	push   $0x352
f01021e6:	68 12 51 10 f0       	push   $0xf0105112
f01021eb:	e8 48 df ff ff       	call   f0100138 <_panic>
f01021f0:	68 2c 48 10 f0       	push   $0xf010482c
f01021f5:	68 fd 50 10 f0       	push   $0xf01050fd
f01021fa:	68 55 03 00 00       	push   $0x355
f01021ff:	68 12 51 10 f0       	push   $0xf0105112
f0102204:	e8 2f df ff ff       	call   f0100138 <_panic>
f0102209:	68 64 48 10 f0       	push   $0xf0104864
f010220e:	68 fd 50 10 f0       	push   $0xf01050fd
f0102213:	68 58 03 00 00       	push   $0x358
f0102218:	68 12 51 10 f0       	push   $0xf0105112
f010221d:	e8 16 df ff ff       	call   f0100138 <_panic>
f0102222:	68 94 48 10 f0       	push   $0xf0104894
f0102227:	68 fd 50 10 f0       	push   $0xf01050fd
f010222c:	68 5c 03 00 00       	push   $0x35c
f0102231:	68 12 51 10 f0       	push   $0xf0105112
f0102236:	e8 fd de ff ff       	call   f0100138 <_panic>
f010223b:	68 c4 48 10 f0       	push   $0xf01048c4
f0102240:	68 fd 50 10 f0       	push   $0xf01050fd
f0102245:	68 5d 03 00 00       	push   $0x35d
f010224a:	68 12 51 10 f0       	push   $0xf0105112
f010224f:	e8 e4 de ff ff       	call   f0100138 <_panic>
f0102254:	68 ec 48 10 f0       	push   $0xf01048ec
f0102259:	68 fd 50 10 f0       	push   $0xf01050fd
f010225e:	68 5e 03 00 00       	push   $0x35e
f0102263:	68 12 51 10 f0       	push   $0xf0105112
f0102268:	e8 cb de ff ff       	call   f0100138 <_panic>
f010226d:	68 0b 53 10 f0       	push   $0xf010530b
f0102272:	68 fd 50 10 f0       	push   $0xf01050fd
f0102277:	68 5f 03 00 00       	push   $0x35f
f010227c:	68 12 51 10 f0       	push   $0xf0105112
f0102281:	e8 b2 de ff ff       	call   f0100138 <_panic>
f0102286:	68 1c 53 10 f0       	push   $0xf010531c
f010228b:	68 fd 50 10 f0       	push   $0xf01050fd
f0102290:	68 60 03 00 00       	push   $0x360
f0102295:	68 12 51 10 f0       	push   $0xf0105112
f010229a:	e8 99 de ff ff       	call   f0100138 <_panic>
f010229f:	68 1c 49 10 f0       	push   $0xf010491c
f01022a4:	68 fd 50 10 f0       	push   $0xf01050fd
f01022a9:	68 63 03 00 00       	push   $0x363
f01022ae:	68 12 51 10 f0       	push   $0xf0105112
f01022b3:	e8 80 de ff ff       	call   f0100138 <_panic>
f01022b8:	68 58 49 10 f0       	push   $0xf0104958
f01022bd:	68 fd 50 10 f0       	push   $0xf01050fd
f01022c2:	68 64 03 00 00       	push   $0x364
f01022c7:	68 12 51 10 f0       	push   $0xf0105112
f01022cc:	e8 67 de ff ff       	call   f0100138 <_panic>
f01022d1:	68 2d 53 10 f0       	push   $0xf010532d
f01022d6:	68 fd 50 10 f0       	push   $0xf01050fd
f01022db:	68 65 03 00 00       	push   $0x365
f01022e0:	68 12 51 10 f0       	push   $0xf0105112
f01022e5:	e8 4e de ff ff       	call   f0100138 <_panic>
f01022ea:	68 b9 52 10 f0       	push   $0xf01052b9
f01022ef:	68 fd 50 10 f0       	push   $0xf01050fd
f01022f4:	68 68 03 00 00       	push   $0x368
f01022f9:	68 12 51 10 f0       	push   $0xf0105112
f01022fe:	e8 35 de ff ff       	call   f0100138 <_panic>
f0102303:	68 1c 49 10 f0       	push   $0xf010491c
f0102308:	68 fd 50 10 f0       	push   $0xf01050fd
f010230d:	68 6b 03 00 00       	push   $0x36b
f0102312:	68 12 51 10 f0       	push   $0xf0105112
f0102317:	e8 1c de ff ff       	call   f0100138 <_panic>
f010231c:	68 58 49 10 f0       	push   $0xf0104958
f0102321:	68 fd 50 10 f0       	push   $0xf01050fd
f0102326:	68 6c 03 00 00       	push   $0x36c
f010232b:	68 12 51 10 f0       	push   $0xf0105112
f0102330:	e8 03 de ff ff       	call   f0100138 <_panic>
f0102335:	68 2d 53 10 f0       	push   $0xf010532d
f010233a:	68 fd 50 10 f0       	push   $0xf01050fd
f010233f:	68 6d 03 00 00       	push   $0x36d
f0102344:	68 12 51 10 f0       	push   $0xf0105112
f0102349:	e8 ea dd ff ff       	call   f0100138 <_panic>
f010234e:	68 b9 52 10 f0       	push   $0xf01052b9
f0102353:	68 fd 50 10 f0       	push   $0xf01050fd
f0102358:	68 71 03 00 00       	push   $0x371
f010235d:	68 12 51 10 f0       	push   $0xf0105112
f0102362:	e8 d1 dd ff ff       	call   f0100138 <_panic>
f0102367:	53                   	push   %ebx
f0102368:	68 ec 43 10 f0       	push   $0xf01043ec
f010236d:	68 74 03 00 00       	push   $0x374
f0102372:	68 12 51 10 f0       	push   $0xf0105112
f0102377:	e8 bc dd ff ff       	call   f0100138 <_panic>
f010237c:	68 88 49 10 f0       	push   $0xf0104988
f0102381:	68 fd 50 10 f0       	push   $0xf01050fd
f0102386:	68 75 03 00 00       	push   $0x375
f010238b:	68 12 51 10 f0       	push   $0xf0105112
f0102390:	e8 a3 dd ff ff       	call   f0100138 <_panic>
f0102395:	68 cc 49 10 f0       	push   $0xf01049cc
f010239a:	68 fd 50 10 f0       	push   $0xf01050fd
f010239f:	68 78 03 00 00       	push   $0x378
f01023a4:	68 12 51 10 f0       	push   $0xf0105112
f01023a9:	e8 8a dd ff ff       	call   f0100138 <_panic>
f01023ae:	68 58 49 10 f0       	push   $0xf0104958
f01023b3:	68 fd 50 10 f0       	push   $0xf01050fd
f01023b8:	68 79 03 00 00       	push   $0x379
f01023bd:	68 12 51 10 f0       	push   $0xf0105112
f01023c2:	e8 71 dd ff ff       	call   f0100138 <_panic>
f01023c7:	68 2d 53 10 f0       	push   $0xf010532d
f01023cc:	68 fd 50 10 f0       	push   $0xf01050fd
f01023d1:	68 7a 03 00 00       	push   $0x37a
f01023d6:	68 12 51 10 f0       	push   $0xf0105112
f01023db:	e8 58 dd ff ff       	call   f0100138 <_panic>
f01023e0:	68 10 4a 10 f0       	push   $0xf0104a10
f01023e5:	68 fd 50 10 f0       	push   $0xf01050fd
f01023ea:	68 7b 03 00 00       	push   $0x37b
f01023ef:	68 12 51 10 f0       	push   $0xf0105112
f01023f4:	e8 3f dd ff ff       	call   f0100138 <_panic>
f01023f9:	68 3e 53 10 f0       	push   $0xf010533e
f01023fe:	68 fd 50 10 f0       	push   $0xf01050fd
f0102403:	68 7c 03 00 00       	push   $0x37c
f0102408:	68 12 51 10 f0       	push   $0xf0105112
f010240d:	e8 26 dd ff ff       	call   f0100138 <_panic>
f0102412:	68 1c 49 10 f0       	push   $0xf010491c
f0102417:	68 fd 50 10 f0       	push   $0xf01050fd
f010241c:	68 7f 03 00 00       	push   $0x37f
f0102421:	68 12 51 10 f0       	push   $0xf0105112
f0102426:	e8 0d dd ff ff       	call   f0100138 <_panic>
f010242b:	68 44 4a 10 f0       	push   $0xf0104a44
f0102430:	68 fd 50 10 f0       	push   $0xf01050fd
f0102435:	68 80 03 00 00       	push   $0x380
f010243a:	68 12 51 10 f0       	push   $0xf0105112
f010243f:	e8 f4 dc ff ff       	call   f0100138 <_panic>
f0102444:	68 78 4a 10 f0       	push   $0xf0104a78
f0102449:	68 fd 50 10 f0       	push   $0xf01050fd
f010244e:	68 81 03 00 00       	push   $0x381
f0102453:	68 12 51 10 f0       	push   $0xf0105112
f0102458:	e8 db dc ff ff       	call   f0100138 <_panic>
f010245d:	68 b0 4a 10 f0       	push   $0xf0104ab0
f0102462:	68 fd 50 10 f0       	push   $0xf01050fd
f0102467:	68 84 03 00 00       	push   $0x384
f010246c:	68 12 51 10 f0       	push   $0xf0105112
f0102471:	e8 c2 dc ff ff       	call   f0100138 <_panic>
f0102476:	68 ec 4a 10 f0       	push   $0xf0104aec
f010247b:	68 fd 50 10 f0       	push   $0xf01050fd
f0102480:	68 87 03 00 00       	push   $0x387
f0102485:	68 12 51 10 f0       	push   $0xf0105112
f010248a:	e8 a9 dc ff ff       	call   f0100138 <_panic>
f010248f:	68 78 4a 10 f0       	push   $0xf0104a78
f0102494:	68 fd 50 10 f0       	push   $0xf01050fd
f0102499:	68 88 03 00 00       	push   $0x388
f010249e:	68 12 51 10 f0       	push   $0xf0105112
f01024a3:	e8 90 dc ff ff       	call   f0100138 <_panic>
f01024a8:	68 28 4b 10 f0       	push   $0xf0104b28
f01024ad:	68 fd 50 10 f0       	push   $0xf01050fd
f01024b2:	68 8b 03 00 00       	push   $0x38b
f01024b7:	68 12 51 10 f0       	push   $0xf0105112
f01024bc:	e8 77 dc ff ff       	call   f0100138 <_panic>
f01024c1:	68 54 4b 10 f0       	push   $0xf0104b54
f01024c6:	68 fd 50 10 f0       	push   $0xf01050fd
f01024cb:	68 8c 03 00 00       	push   $0x38c
f01024d0:	68 12 51 10 f0       	push   $0xf0105112
f01024d5:	e8 5e dc ff ff       	call   f0100138 <_panic>
f01024da:	68 54 53 10 f0       	push   $0xf0105354
f01024df:	68 fd 50 10 f0       	push   $0xf01050fd
f01024e4:	68 8e 03 00 00       	push   $0x38e
f01024e9:	68 12 51 10 f0       	push   $0xf0105112
f01024ee:	e8 45 dc ff ff       	call   f0100138 <_panic>
f01024f3:	68 65 53 10 f0       	push   $0xf0105365
f01024f8:	68 fd 50 10 f0       	push   $0xf01050fd
f01024fd:	68 8f 03 00 00       	push   $0x38f
f0102502:	68 12 51 10 f0       	push   $0xf0105112
f0102507:	e8 2c dc ff ff       	call   f0100138 <_panic>
f010250c:	68 84 4b 10 f0       	push   $0xf0104b84
f0102511:	68 fd 50 10 f0       	push   $0xf01050fd
f0102516:	68 92 03 00 00       	push   $0x392
f010251b:	68 12 51 10 f0       	push   $0xf0105112
f0102520:	e8 13 dc ff ff       	call   f0100138 <_panic>
f0102525:	68 a8 4b 10 f0       	push   $0xf0104ba8
f010252a:	68 fd 50 10 f0       	push   $0xf01050fd
f010252f:	68 96 03 00 00       	push   $0x396
f0102534:	68 12 51 10 f0       	push   $0xf0105112
f0102539:	e8 fa db ff ff       	call   f0100138 <_panic>
f010253e:	68 54 4b 10 f0       	push   $0xf0104b54
f0102543:	68 fd 50 10 f0       	push   $0xf01050fd
f0102548:	68 97 03 00 00       	push   $0x397
f010254d:	68 12 51 10 f0       	push   $0xf0105112
f0102552:	e8 e1 db ff ff       	call   f0100138 <_panic>
f0102557:	68 0b 53 10 f0       	push   $0xf010530b
f010255c:	68 fd 50 10 f0       	push   $0xf01050fd
f0102561:	68 98 03 00 00       	push   $0x398
f0102566:	68 12 51 10 f0       	push   $0xf0105112
f010256b:	e8 c8 db ff ff       	call   f0100138 <_panic>
f0102570:	68 65 53 10 f0       	push   $0xf0105365
f0102575:	68 fd 50 10 f0       	push   $0xf01050fd
f010257a:	68 99 03 00 00       	push   $0x399
f010257f:	68 12 51 10 f0       	push   $0xf0105112
f0102584:	e8 af db ff ff       	call   f0100138 <_panic>
f0102589:	68 cc 4b 10 f0       	push   $0xf0104bcc
f010258e:	68 fd 50 10 f0       	push   $0xf01050fd
f0102593:	68 9c 03 00 00       	push   $0x39c
f0102598:	68 12 51 10 f0       	push   $0xf0105112
f010259d:	e8 96 db ff ff       	call   f0100138 <_panic>
f01025a2:	68 76 53 10 f0       	push   $0xf0105376
f01025a7:	68 fd 50 10 f0       	push   $0xf01050fd
f01025ac:	68 9d 03 00 00       	push   $0x39d
f01025b1:	68 12 51 10 f0       	push   $0xf0105112
f01025b6:	e8 7d db ff ff       	call   f0100138 <_panic>
f01025bb:	68 82 53 10 f0       	push   $0xf0105382
f01025c0:	68 fd 50 10 f0       	push   $0xf01050fd
f01025c5:	68 9e 03 00 00       	push   $0x39e
f01025ca:	68 12 51 10 f0       	push   $0xf0105112
f01025cf:	e8 64 db ff ff       	call   f0100138 <_panic>
f01025d4:	68 a8 4b 10 f0       	push   $0xf0104ba8
f01025d9:	68 fd 50 10 f0       	push   $0xf01050fd
f01025de:	68 a2 03 00 00       	push   $0x3a2
f01025e3:	68 12 51 10 f0       	push   $0xf0105112
f01025e8:	e8 4b db ff ff       	call   f0100138 <_panic>
f01025ed:	68 04 4c 10 f0       	push   $0xf0104c04
f01025f2:	68 fd 50 10 f0       	push   $0xf01050fd
f01025f7:	68 a3 03 00 00       	push   $0x3a3
f01025fc:	68 12 51 10 f0       	push   $0xf0105112
f0102601:	e8 32 db ff ff       	call   f0100138 <_panic>
f0102606:	68 97 53 10 f0       	push   $0xf0105397
f010260b:	68 fd 50 10 f0       	push   $0xf01050fd
f0102610:	68 a4 03 00 00       	push   $0x3a4
f0102615:	68 12 51 10 f0       	push   $0xf0105112
f010261a:	e8 19 db ff ff       	call   f0100138 <_panic>
f010261f:	68 65 53 10 f0       	push   $0xf0105365
f0102624:	68 fd 50 10 f0       	push   $0xf01050fd
f0102629:	68 a5 03 00 00       	push   $0x3a5
f010262e:	68 12 51 10 f0       	push   $0xf0105112
f0102633:	e8 00 db ff ff       	call   f0100138 <_panic>
f0102638:	68 2c 4c 10 f0       	push   $0xf0104c2c
f010263d:	68 fd 50 10 f0       	push   $0xf01050fd
f0102642:	68 a8 03 00 00       	push   $0x3a8
f0102647:	68 12 51 10 f0       	push   $0xf0105112
f010264c:	e8 e7 da ff ff       	call   f0100138 <_panic>
f0102651:	68 b9 52 10 f0       	push   $0xf01052b9
f0102656:	68 fd 50 10 f0       	push   $0xf01050fd
f010265b:	68 ab 03 00 00       	push   $0x3ab
f0102660:	68 12 51 10 f0       	push   $0xf0105112
f0102665:	e8 ce da ff ff       	call   f0100138 <_panic>
f010266a:	68 c4 48 10 f0       	push   $0xf01048c4
f010266f:	68 fd 50 10 f0       	push   $0xf01050fd
f0102674:	68 ae 03 00 00       	push   $0x3ae
f0102679:	68 12 51 10 f0       	push   $0xf0105112
f010267e:	e8 b5 da ff ff       	call   f0100138 <_panic>
f0102683:	68 1c 53 10 f0       	push   $0xf010531c
f0102688:	68 fd 50 10 f0       	push   $0xf01050fd
f010268d:	68 b0 03 00 00       	push   $0x3b0
f0102692:	68 12 51 10 f0       	push   $0xf0105112
f0102697:	e8 9c da ff ff       	call   f0100138 <_panic>
f010269c:	53                   	push   %ebx
f010269d:	68 ec 43 10 f0       	push   $0xf01043ec
f01026a2:	68 b7 03 00 00       	push   $0x3b7
f01026a7:	68 12 51 10 f0       	push   $0xf0105112
f01026ac:	e8 87 da ff ff       	call   f0100138 <_panic>
f01026b1:	68 a8 53 10 f0       	push   $0xf01053a8
f01026b6:	68 fd 50 10 f0       	push   $0xf01050fd
f01026bb:	68 bc 03 00 00       	push   $0x3bc
f01026c0:	68 12 51 10 f0       	push   $0xf0105112
f01026c5:	e8 6e da ff ff       	call   f0100138 <_panic>
f01026ca:	52                   	push   %edx
f01026cb:	68 ec 43 10 f0       	push   $0xf01043ec
f01026d0:	6a 52                	push   $0x52
f01026d2:	68 1e 51 10 f0       	push   $0xf010511e
f01026d7:	e8 5c da ff ff       	call   f0100138 <_panic>
f01026dc:	52                   	push   %edx
f01026dd:	68 ec 43 10 f0       	push   $0xf01043ec
f01026e2:	6a 52                	push   $0x52
f01026e4:	68 1e 51 10 f0       	push   $0xf010511e
f01026e9:	e8 4a da ff ff       	call   f0100138 <_panic>
f01026ee:	68 c0 53 10 f0       	push   $0xf01053c0
f01026f3:	68 fd 50 10 f0       	push   $0xf01050fd
f01026f8:	68 c6 03 00 00       	push   $0x3c6
f01026fd:	68 12 51 10 f0       	push   $0xf0105112
f0102702:	e8 31 da ff ff       	call   f0100138 <_panic>
f0102707:	50                   	push   %eax
f0102708:	68 90 45 10 f0       	push   $0xf0104590
f010270d:	68 c6 00 00 00       	push   $0xc6
f0102712:	68 12 51 10 f0       	push   $0xf0105112
f0102717:	e8 1c da ff ff       	call   f0100138 <_panic>
f010271c:	50                   	push   %eax
f010271d:	68 90 45 10 f0       	push   $0xf0104590
f0102722:	68 c7 00 00 00       	push   $0xc7
f0102727:	68 12 51 10 f0       	push   $0xf0105112
f010272c:	e8 07 da ff ff       	call   f0100138 <_panic>
f0102731:	50                   	push   %eax
f0102732:	68 90 45 10 f0       	push   $0xf0104590
f0102737:	68 cb 00 00 00       	push   $0xcb
f010273c:	68 12 51 10 f0       	push   $0xf0105112
f0102741:	e8 f2 d9 ff ff       	call   f0100138 <_panic>
f0102746:	50                   	push   %eax
f0102747:	68 90 45 10 f0       	push   $0xf0104590
f010274c:	68 da 00 00 00       	push   $0xda
f0102751:	68 12 51 10 f0       	push   $0xf0105112
f0102756:	e8 dd d9 ff ff       	call   f0100138 <_panic>
f010275b:	56                   	push   %esi
f010275c:	68 90 45 10 f0       	push   $0xf0104590
f0102761:	68 04 03 00 00       	push   $0x304
f0102766:	68 12 51 10 f0       	push   $0xf0105112
f010276b:	e8 c8 d9 ff ff       	call   f0100138 <_panic>
f0102770:	ff 75 d0             	push   -0x30(%ebp)
f0102773:	68 90 45 10 f0       	push   $0xf0104590
f0102778:	68 06 03 00 00       	push   $0x306
f010277d:	68 12 51 10 f0       	push   $0xf0105112
f0102782:	e8 b1 d9 ff ff       	call   f0100138 <_panic>
f0102787:	68 a8 4e 10 f0       	push   $0xf0104ea8
f010278c:	68 fd 50 10 f0       	push   $0xf01050fd
f0102791:	68 06 03 00 00       	push   $0x306
f0102796:	68 12 51 10 f0       	push   $0xf0105112
f010279b:	e8 98 d9 ff ff       	call   f0100138 <_panic>
f01027a0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
f01027a3:	a1 60 95 11 f0       	mov    0xf0119560,%eax
f01027a8:	c1 e0 0c             	shl    $0xc,%eax
f01027ab:	89 de                	mov    %ebx,%esi
f01027ad:	89 c7                	mov    %eax,%edi
f01027af:	39 fe                	cmp    %edi,%esi
f01027b1:	73 33                	jae    f01027e6 <mem_init+0x15e8>
f01027b3:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f01027b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01027bc:	e8 db e1 ff ff       	call   f010099c <check_va2pa>
f01027c1:	39 c6                	cmp    %eax,%esi
f01027c3:	75 08                	jne    f01027cd <mem_init+0x15cf>
f01027c5:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01027cb:	eb e2                	jmp    f01027af <mem_init+0x15b1>
f01027cd:	68 dc 4e 10 f0       	push   $0xf0104edc
f01027d2:	68 fd 50 10 f0       	push   $0xf01050fd
f01027d7:	68 0b 03 00 00       	push   $0x30b
f01027dc:	68 12 51 10 f0       	push   $0xf0105112
f01027e1:	e8 52 d9 ff ff       	call   f0100138 <_panic>
f01027e6:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01027eb:	b8 00 f0 10 f0       	mov    $0xf010f000,%eax
f01027f0:	05 00 80 00 20       	add    $0x20008000,%eax
f01027f5:	89 c7                	mov    %eax,%edi
f01027f7:	89 f2                	mov    %esi,%edx
f01027f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01027fc:	e8 9b e1 ff ff       	call   f010099c <check_va2pa>
f0102801:	8d 14 37             	lea    (%edi,%esi,1),%edx
f0102804:	39 c2                	cmp    %eax,%edx
f0102806:	75 3b                	jne    f0102843 <mem_init+0x1645>
f0102808:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010280e:	81 fe 00 00 00 f0    	cmp    $0xf0000000,%esi
f0102814:	75 e1                	jne    f01027f7 <mem_init+0x15f9>
f0102816:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102819:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f010281e:	89 f8                	mov    %edi,%eax
f0102820:	e8 77 e1 ff ff       	call   f010099c <check_va2pa>
f0102825:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102828:	74 5d                	je     f0102887 <mem_init+0x1689>
f010282a:	68 4c 4f 10 f0       	push   $0xf0104f4c
f010282f:	68 fd 50 10 f0       	push   $0xf01050fd
f0102834:	68 10 03 00 00       	push   $0x310
f0102839:	68 12 51 10 f0       	push   $0xf0105112
f010283e:	e8 f5 d8 ff ff       	call   f0100138 <_panic>
f0102843:	68 04 4f 10 f0       	push   $0xf0104f04
f0102848:	68 fd 50 10 f0       	push   $0xf01050fd
f010284d:	68 0f 03 00 00       	push   $0x30f
f0102852:	68 12 51 10 f0       	push   $0xf0105112
f0102857:	e8 dc d8 ff ff       	call   f0100138 <_panic>
f010285c:	81 fb bf 03 00 00    	cmp    $0x3bf,%ebx
f0102862:	75 23                	jne    f0102887 <mem_init+0x1689>
f0102864:	f6 04 9f 01          	testb  $0x1,(%edi,%ebx,4)
f0102868:	74 44                	je     f01028ae <mem_init+0x16b0>
f010286a:	43                   	inc    %ebx
f010286b:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f0102871:	0f 87 8d 00 00 00    	ja     f0102904 <mem_init+0x1706>
f0102877:	81 fb bd 03 00 00    	cmp    $0x3bd,%ebx
f010287d:	77 dd                	ja     f010285c <mem_init+0x165e>
f010287f:	81 fb bb 03 00 00    	cmp    $0x3bb,%ebx
f0102885:	77 dd                	ja     f0102864 <mem_init+0x1666>
f0102887:	81 fb bf 03 00 00    	cmp    $0x3bf,%ebx
f010288d:	77 38                	ja     f01028c7 <mem_init+0x16c9>
f010288f:	83 3c 9f 00          	cmpl   $0x0,(%edi,%ebx,4)
f0102893:	74 d5                	je     f010286a <mem_init+0x166c>
f0102895:	68 27 54 10 f0       	push   $0xf0105427
f010289a:	68 fd 50 10 f0       	push   $0xf01050fd
f010289f:	68 1f 03 00 00       	push   $0x31f
f01028a4:	68 12 51 10 f0       	push   $0xf0105112
f01028a9:	e8 8a d8 ff ff       	call   f0100138 <_panic>
f01028ae:	68 05 54 10 f0       	push   $0xf0105405
f01028b3:	68 fd 50 10 f0       	push   $0xf01050fd
f01028b8:	68 18 03 00 00       	push   $0x318
f01028bd:	68 12 51 10 f0       	push   $0xf0105112
f01028c2:	e8 71 d8 ff ff       	call   f0100138 <_panic>
f01028c7:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
f01028ca:	a8 01                	test   $0x1,%al
f01028cc:	74 1d                	je     f01028eb <mem_init+0x16ed>
f01028ce:	a8 02                	test   $0x2,%al
f01028d0:	75 98                	jne    f010286a <mem_init+0x166c>
f01028d2:	68 16 54 10 f0       	push   $0xf0105416
f01028d7:	68 fd 50 10 f0       	push   $0xf01050fd
f01028dc:	68 1d 03 00 00       	push   $0x31d
f01028e1:	68 12 51 10 f0       	push   $0xf0105112
f01028e6:	e8 4d d8 ff ff       	call   f0100138 <_panic>
f01028eb:	68 05 54 10 f0       	push   $0xf0105405
f01028f0:	68 fd 50 10 f0       	push   $0xf01050fd
f01028f5:	68 1c 03 00 00       	push   $0x31c
f01028fa:	68 12 51 10 f0       	push   $0xf0105112
f01028ff:	e8 34 d8 ff ff       	call   f0100138 <_panic>
f0102904:	83 ec 0c             	sub    $0xc,%esp
f0102907:	68 7c 4f 10 f0       	push   $0xf0104f7c
f010290c:	e8 1d 04 00 00       	call   f0102d2e <cprintf>
f0102911:	a1 5c 95 11 f0       	mov    0xf011955c,%eax
f0102916:	83 c4 10             	add    $0x10,%esp
f0102919:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010291e:	0f 86 21 02 00 00    	jbe    f0102b45 <mem_init+0x1947>
f0102924:	05 00 00 00 10       	add    $0x10000000,%eax
f0102929:	0f 22 d8             	mov    %eax,%cr3
f010292c:	83 ec 0c             	sub    $0xc,%esp
f010292f:	68 9c 4f 10 f0       	push   $0xf0104f9c
f0102934:	e8 f5 03 00 00       	call   f0102d2e <cprintf>
f0102939:	b8 00 00 00 00       	mov    $0x0,%eax
f010293e:	e8 b9 e0 ff ff       	call   f01009fc <check_page_free_list>
f0102943:	0f 20 c0             	mov    %cr0,%eax
f0102946:	83 e0 f3             	and    $0xfffffff3,%eax
f0102949:	0d 23 00 05 80       	or     $0x80050023,%eax
f010294e:	0f 22 c0             	mov    %eax,%cr0
f0102951:	c7 04 24 fc 4f 10 f0 	movl   $0xf0104ffc,(%esp)
f0102958:	e8 d1 03 00 00       	call   f0102d2e <cprintf>
f010295d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102964:	e8 15 e5 ff ff       	call   f0100e7e <page_alloc>
f0102969:	89 c3                	mov    %eax,%ebx
f010296b:	83 c4 10             	add    $0x10,%esp
f010296e:	85 c0                	test   %eax,%eax
f0102970:	0f 84 e4 01 00 00    	je     f0102b5a <mem_init+0x195c>
f0102976:	83 ec 0c             	sub    $0xc,%esp
f0102979:	6a 00                	push   $0x0
f010297b:	e8 fe e4 ff ff       	call   f0100e7e <page_alloc>
f0102980:	89 c7                	mov    %eax,%edi
f0102982:	83 c4 10             	add    $0x10,%esp
f0102985:	85 c0                	test   %eax,%eax
f0102987:	0f 84 e6 01 00 00    	je     f0102b73 <mem_init+0x1975>
f010298d:	83 ec 0c             	sub    $0xc,%esp
f0102990:	6a 00                	push   $0x0
f0102992:	e8 e7 e4 ff ff       	call   f0100e7e <page_alloc>
f0102997:	89 c6                	mov    %eax,%esi
f0102999:	83 c4 10             	add    $0x10,%esp
f010299c:	85 c0                	test   %eax,%eax
f010299e:	0f 84 e8 01 00 00    	je     f0102b8c <mem_init+0x198e>
f01029a4:	83 ec 0c             	sub    $0xc,%esp
f01029a7:	53                   	push   %ebx
f01029a8:	e8 4c e5 ff ff       	call   f0100ef9 <page_free>
f01029ad:	89 f8                	mov    %edi,%eax
f01029af:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f01029b5:	c1 f8 03             	sar    $0x3,%eax
f01029b8:	89 c2                	mov    %eax,%edx
f01029ba:	c1 e2 0c             	shl    $0xc,%edx
f01029bd:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01029c2:	83 c4 10             	add    $0x10,%esp
f01029c5:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f01029cb:	0f 83 d4 01 00 00    	jae    f0102ba5 <mem_init+0x19a7>
f01029d1:	83 ec 04             	sub    $0x4,%esp
f01029d4:	68 00 10 00 00       	push   $0x1000
f01029d9:	6a 01                	push   $0x1
f01029db:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f01029e1:	52                   	push   %edx
f01029e2:	e8 b2 0e 00 00       	call   f0103899 <memset>
f01029e7:	89 f0                	mov    %esi,%eax
f01029e9:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f01029ef:	c1 f8 03             	sar    $0x3,%eax
f01029f2:	89 c2                	mov    %eax,%edx
f01029f4:	c1 e2 0c             	shl    $0xc,%edx
f01029f7:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01029fc:	83 c4 10             	add    $0x10,%esp
f01029ff:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f0102a05:	0f 83 ac 01 00 00    	jae    f0102bb7 <mem_init+0x19b9>
f0102a0b:	83 ec 04             	sub    $0x4,%esp
f0102a0e:	68 00 10 00 00       	push   $0x1000
f0102a13:	6a 02                	push   $0x2
f0102a15:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102a1b:	52                   	push   %edx
f0102a1c:	e8 78 0e 00 00       	call   f0103899 <memset>
f0102a21:	6a 02                	push   $0x2
f0102a23:	68 00 10 00 00       	push   $0x1000
f0102a28:	57                   	push   %edi
f0102a29:	ff 35 5c 95 11 f0    	push   0xf011955c
f0102a2f:	e8 a8 e6 ff ff       	call   f01010dc <page_insert>
f0102a34:	83 c4 20             	add    $0x20,%esp
f0102a37:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102a3c:	0f 85 87 01 00 00    	jne    f0102bc9 <mem_init+0x19cb>
f0102a42:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102a49:	01 01 01 
f0102a4c:	0f 85 90 01 00 00    	jne    f0102be2 <mem_init+0x19e4>
f0102a52:	6a 02                	push   $0x2
f0102a54:	68 00 10 00 00       	push   $0x1000
f0102a59:	56                   	push   %esi
f0102a5a:	ff 35 5c 95 11 f0    	push   0xf011955c
f0102a60:	e8 77 e6 ff ff       	call   f01010dc <page_insert>
f0102a65:	83 c4 10             	add    $0x10,%esp
f0102a68:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102a6f:	02 02 02 
f0102a72:	0f 85 83 01 00 00    	jne    f0102bfb <mem_init+0x19fd>
f0102a78:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102a7d:	0f 85 91 01 00 00    	jne    f0102c14 <mem_init+0x1a16>
f0102a83:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102a88:	0f 85 9f 01 00 00    	jne    f0102c2d <mem_init+0x1a2f>
f0102a8e:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102a95:	03 03 03 
f0102a98:	89 f0                	mov    %esi,%eax
f0102a9a:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0102aa0:	c1 f8 03             	sar    $0x3,%eax
f0102aa3:	89 c2                	mov    %eax,%edx
f0102aa5:	c1 e2 0c             	shl    $0xc,%edx
f0102aa8:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102aad:	3b 05 60 95 11 f0    	cmp    0xf0119560,%eax
f0102ab3:	0f 83 8d 01 00 00    	jae    f0102c46 <mem_init+0x1a48>
f0102ab9:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102ac0:	03 03 03 
f0102ac3:	0f 85 8f 01 00 00    	jne    f0102c58 <mem_init+0x1a5a>
f0102ac9:	83 ec 08             	sub    $0x8,%esp
f0102acc:	68 00 10 00 00       	push   $0x1000
f0102ad1:	ff 35 5c 95 11 f0    	push   0xf011955c
f0102ad7:	e8 bf e5 ff ff       	call   f010109b <page_remove>
f0102adc:	83 c4 10             	add    $0x10,%esp
f0102adf:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102ae4:	0f 85 87 01 00 00    	jne    f0102c71 <mem_init+0x1a73>
f0102aea:	8b 0d 5c 95 11 f0    	mov    0xf011955c,%ecx
f0102af0:	8b 11                	mov    (%ecx),%edx
f0102af2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102af8:	89 d8                	mov    %ebx,%eax
f0102afa:	2b 05 58 95 11 f0    	sub    0xf0119558,%eax
f0102b00:	c1 f8 03             	sar    $0x3,%eax
f0102b03:	c1 e0 0c             	shl    $0xc,%eax
f0102b06:	39 c2                	cmp    %eax,%edx
f0102b08:	0f 85 7c 01 00 00    	jne    f0102c8a <mem_init+0x1a8c>
f0102b0e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0102b14:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102b19:	0f 85 84 01 00 00    	jne    f0102ca3 <mem_init+0x1aa5>
f0102b1f:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
f0102b25:	83 ec 0c             	sub    $0xc,%esp
f0102b28:	53                   	push   %ebx
f0102b29:	e8 cb e3 ff ff       	call   f0100ef9 <page_free>
f0102b2e:	c7 04 24 d4 50 10 f0 	movl   $0xf01050d4,(%esp)
f0102b35:	e8 f4 01 00 00       	call   f0102d2e <cprintf>
f0102b3a:	83 c4 10             	add    $0x10,%esp
f0102b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102b40:	5b                   	pop    %ebx
f0102b41:	5e                   	pop    %esi
f0102b42:	5f                   	pop    %edi
f0102b43:	5d                   	pop    %ebp
f0102b44:	c3                   	ret    
f0102b45:	50                   	push   %eax
f0102b46:	68 90 45 10 f0       	push   $0xf0104590
f0102b4b:	68 f1 00 00 00       	push   $0xf1
f0102b50:	68 12 51 10 f0       	push   $0xf0105112
f0102b55:	e8 de d5 ff ff       	call   f0100138 <_panic>
f0102b5a:	68 65 52 10 f0       	push   $0xf0105265
f0102b5f:	68 fd 50 10 f0       	push   $0xf01050fd
f0102b64:	68 e0 03 00 00       	push   $0x3e0
f0102b69:	68 12 51 10 f0       	push   $0xf0105112
f0102b6e:	e8 c5 d5 ff ff       	call   f0100138 <_panic>
f0102b73:	68 7b 52 10 f0       	push   $0xf010527b
f0102b78:	68 fd 50 10 f0       	push   $0xf01050fd
f0102b7d:	68 e1 03 00 00       	push   $0x3e1
f0102b82:	68 12 51 10 f0       	push   $0xf0105112
f0102b87:	e8 ac d5 ff ff       	call   f0100138 <_panic>
f0102b8c:	68 91 52 10 f0       	push   $0xf0105291
f0102b91:	68 fd 50 10 f0       	push   $0xf01050fd
f0102b96:	68 e2 03 00 00       	push   $0x3e2
f0102b9b:	68 12 51 10 f0       	push   $0xf0105112
f0102ba0:	e8 93 d5 ff ff       	call   f0100138 <_panic>
f0102ba5:	52                   	push   %edx
f0102ba6:	68 ec 43 10 f0       	push   $0xf01043ec
f0102bab:	6a 52                	push   $0x52
f0102bad:	68 1e 51 10 f0       	push   $0xf010511e
f0102bb2:	e8 81 d5 ff ff       	call   f0100138 <_panic>
f0102bb7:	52                   	push   %edx
f0102bb8:	68 ec 43 10 f0       	push   $0xf01043ec
f0102bbd:	6a 52                	push   $0x52
f0102bbf:	68 1e 51 10 f0       	push   $0xf010511e
f0102bc4:	e8 6f d5 ff ff       	call   f0100138 <_panic>
f0102bc9:	68 0b 53 10 f0       	push   $0xf010530b
f0102bce:	68 fd 50 10 f0       	push   $0xf01050fd
f0102bd3:	68 e7 03 00 00       	push   $0x3e7
f0102bd8:	68 12 51 10 f0       	push   $0xf0105112
f0102bdd:	e8 56 d5 ff ff       	call   f0100138 <_panic>
f0102be2:	68 60 50 10 f0       	push   $0xf0105060
f0102be7:	68 fd 50 10 f0       	push   $0xf01050fd
f0102bec:	68 e8 03 00 00       	push   $0x3e8
f0102bf1:	68 12 51 10 f0       	push   $0xf0105112
f0102bf6:	e8 3d d5 ff ff       	call   f0100138 <_panic>
f0102bfb:	68 84 50 10 f0       	push   $0xf0105084
f0102c00:	68 fd 50 10 f0       	push   $0xf01050fd
f0102c05:	68 ea 03 00 00       	push   $0x3ea
f0102c0a:	68 12 51 10 f0       	push   $0xf0105112
f0102c0f:	e8 24 d5 ff ff       	call   f0100138 <_panic>
f0102c14:	68 2d 53 10 f0       	push   $0xf010532d
f0102c19:	68 fd 50 10 f0       	push   $0xf01050fd
f0102c1e:	68 eb 03 00 00       	push   $0x3eb
f0102c23:	68 12 51 10 f0       	push   $0xf0105112
f0102c28:	e8 0b d5 ff ff       	call   f0100138 <_panic>
f0102c2d:	68 97 53 10 f0       	push   $0xf0105397
f0102c32:	68 fd 50 10 f0       	push   $0xf01050fd
f0102c37:	68 ec 03 00 00       	push   $0x3ec
f0102c3c:	68 12 51 10 f0       	push   $0xf0105112
f0102c41:	e8 f2 d4 ff ff       	call   f0100138 <_panic>
f0102c46:	52                   	push   %edx
f0102c47:	68 ec 43 10 f0       	push   $0xf01043ec
f0102c4c:	6a 52                	push   $0x52
f0102c4e:	68 1e 51 10 f0       	push   $0xf010511e
f0102c53:	e8 e0 d4 ff ff       	call   f0100138 <_panic>
f0102c58:	68 a8 50 10 f0       	push   $0xf01050a8
f0102c5d:	68 fd 50 10 f0       	push   $0xf01050fd
f0102c62:	68 ee 03 00 00       	push   $0x3ee
f0102c67:	68 12 51 10 f0       	push   $0xf0105112
f0102c6c:	e8 c7 d4 ff ff       	call   f0100138 <_panic>
f0102c71:	68 65 53 10 f0       	push   $0xf0105365
f0102c76:	68 fd 50 10 f0       	push   $0xf01050fd
f0102c7b:	68 f0 03 00 00       	push   $0x3f0
f0102c80:	68 12 51 10 f0       	push   $0xf0105112
f0102c85:	e8 ae d4 ff ff       	call   f0100138 <_panic>
f0102c8a:	68 c4 48 10 f0       	push   $0xf01048c4
f0102c8f:	68 fd 50 10 f0       	push   $0xf01050fd
f0102c94:	68 f3 03 00 00       	push   $0x3f3
f0102c99:	68 12 51 10 f0       	push   $0xf0105112
f0102c9e:	e8 95 d4 ff ff       	call   f0100138 <_panic>
f0102ca3:	68 1c 53 10 f0       	push   $0xf010531c
f0102ca8:	68 fd 50 10 f0       	push   $0xf01050fd
f0102cad:	68 f5 03 00 00       	push   $0x3f5
f0102cb2:	68 12 51 10 f0       	push   $0xf0105112
f0102cb7:	e8 7c d4 ff ff       	call   f0100138 <_panic>

f0102cbc <tlb_invalidate>:
f0102cbc:	55                   	push   %ebp
f0102cbd:	89 e5                	mov    %esp,%ebp
f0102cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102cc2:	0f 01 38             	invlpg (%eax)
f0102cc5:	5d                   	pop    %ebp
f0102cc6:	c3                   	ret    

f0102cc7 <mc146818_read>:
f0102cc7:	55                   	push   %ebp
f0102cc8:	89 e5                	mov    %esp,%ebp
f0102cca:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ccd:	ba 70 00 00 00       	mov    $0x70,%edx
f0102cd2:	ee                   	out    %al,(%dx)
f0102cd3:	ba 71 00 00 00       	mov    $0x71,%edx
f0102cd8:	ec                   	in     (%dx),%al
f0102cd9:	0f b6 c0             	movzbl %al,%eax
f0102cdc:	5d                   	pop    %ebp
f0102cdd:	c3                   	ret    

f0102cde <mc146818_write>:
f0102cde:	55                   	push   %ebp
f0102cdf:	89 e5                	mov    %esp,%ebp
f0102ce1:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ce4:	ba 70 00 00 00       	mov    $0x70,%edx
f0102ce9:	ee                   	out    %al,(%dx)
f0102cea:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102ced:	ba 71 00 00 00       	mov    $0x71,%edx
f0102cf2:	ee                   	out    %al,(%dx)
f0102cf3:	5d                   	pop    %ebp
f0102cf4:	c3                   	ret    

f0102cf5 <putch>:
f0102cf5:	55                   	push   %ebp
f0102cf6:	89 e5                	mov    %esp,%ebp
f0102cf8:	83 ec 14             	sub    $0x14,%esp
f0102cfb:	ff 75 08             	push   0x8(%ebp)
f0102cfe:	e8 69 d9 ff ff       	call   f010066c <cputchar>
f0102d03:	83 c4 10             	add    $0x10,%esp
f0102d06:	c9                   	leave  
f0102d07:	c3                   	ret    

f0102d08 <vcprintf>:
f0102d08:	55                   	push   %ebp
f0102d09:	89 e5                	mov    %esp,%ebp
f0102d0b:	83 ec 18             	sub    $0x18,%esp
f0102d0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102d15:	ff 75 0c             	push   0xc(%ebp)
f0102d18:	ff 75 08             	push   0x8(%ebp)
f0102d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0102d1e:	50                   	push   %eax
f0102d1f:	68 f5 2c 10 f0       	push   $0xf0102cf5
f0102d24:	e8 46 04 00 00       	call   f010316f <vprintfmt>
f0102d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102d2c:	c9                   	leave  
f0102d2d:	c3                   	ret    

f0102d2e <cprintf>:
f0102d2e:	55                   	push   %ebp
f0102d2f:	89 e5                	mov    %esp,%ebp
f0102d31:	83 ec 10             	sub    $0x10,%esp
f0102d34:	8d 45 0c             	lea    0xc(%ebp),%eax
f0102d37:	50                   	push   %eax
f0102d38:	ff 75 08             	push   0x8(%ebp)
f0102d3b:	e8 c8 ff ff ff       	call   f0102d08 <vcprintf>
f0102d40:	c9                   	leave  
f0102d41:	c3                   	ret    

f0102d42 <memCprintf>:
f0102d42:	55                   	push   %ebp
f0102d43:	89 e5                	mov    %esp,%ebp
f0102d45:	83 ec 10             	sub    $0x10,%esp
f0102d48:	ff 75 18             	push   0x18(%ebp)
f0102d4b:	ff 75 14             	push   0x14(%ebp)
f0102d4e:	ff 75 10             	push   0x10(%ebp)
f0102d51:	ff 75 0c             	push   0xc(%ebp)
f0102d54:	ff 75 08             	push   0x8(%ebp)
f0102d57:	68 38 54 10 f0       	push   $0xf0105438
f0102d5c:	e8 cd ff ff ff       	call   f0102d2e <cprintf>
f0102d61:	c9                   	leave  
f0102d62:	c3                   	ret    

f0102d63 <stab_binsearch>:
f0102d63:	55                   	push   %ebp
f0102d64:	89 e5                	mov    %esp,%ebp
f0102d66:	57                   	push   %edi
f0102d67:	56                   	push   %esi
f0102d68:	53                   	push   %ebx
f0102d69:	83 ec 14             	sub    $0x14,%esp
f0102d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0102d6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0102d72:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0102d75:	8b 75 08             	mov    0x8(%ebp),%esi
f0102d78:	8b 1a                	mov    (%edx),%ebx
f0102d7a:	8b 39                	mov    (%ecx),%edi
f0102d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0102d83:	eb 31                	jmp    f0102db6 <stab_binsearch+0x53>
f0102d85:	48                   	dec    %eax
f0102d86:	39 c3                	cmp    %eax,%ebx
f0102d88:	7f 50                	jg     f0102dda <stab_binsearch+0x77>
f0102d8a:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0102d8e:	83 ea 0c             	sub    $0xc,%edx
f0102d91:	39 f1                	cmp    %esi,%ecx
f0102d93:	75 f0                	jne    f0102d85 <stab_binsearch+0x22>
f0102d95:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102d98:	01 c2                	add    %eax,%edx
f0102d9a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0102d9d:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0102da1:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0102da4:	73 3a                	jae    f0102de0 <stab_binsearch+0x7d>
f0102da6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0102da9:	89 03                	mov    %eax,(%ebx)
f0102dab:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0102dae:	43                   	inc    %ebx
f0102daf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0102db6:	39 fb                	cmp    %edi,%ebx
f0102db8:	7f 4f                	jg     f0102e09 <stab_binsearch+0xa6>
f0102dba:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f0102dbd:	89 d0                	mov    %edx,%eax
f0102dbf:	c1 e8 1f             	shr    $0x1f,%eax
f0102dc2:	01 d0                	add    %edx,%eax
f0102dc4:	89 c1                	mov    %eax,%ecx
f0102dc6:	d1 f9                	sar    %ecx
f0102dc8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
f0102dcb:	83 e0 fe             	and    $0xfffffffe,%eax
f0102dce:	01 c8                	add    %ecx,%eax
f0102dd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0102dd3:	8d 14 82             	lea    (%edx,%eax,4),%edx
f0102dd6:	89 c8                	mov    %ecx,%eax
f0102dd8:	eb ac                	jmp    f0102d86 <stab_binsearch+0x23>
f0102dda:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0102ddd:	43                   	inc    %ebx
f0102dde:	eb d6                	jmp    f0102db6 <stab_binsearch+0x53>
f0102de0:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0102de3:	76 11                	jbe    f0102df6 <stab_binsearch+0x93>
f0102de5:	8d 78 ff             	lea    -0x1(%eax),%edi
f0102de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102deb:	89 38                	mov    %edi,(%eax)
f0102ded:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0102df4:	eb c0                	jmp    f0102db6 <stab_binsearch+0x53>
f0102df6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0102df9:	89 03                	mov    %eax,(%ebx)
f0102dfb:	ff 45 0c             	incl   0xc(%ebp)
f0102dfe:	89 c3                	mov    %eax,%ebx
f0102e00:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0102e07:	eb ad                	jmp    f0102db6 <stab_binsearch+0x53>
f0102e09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102e0d:	75 13                	jne    f0102e22 <stab_binsearch+0xbf>
f0102e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102e12:	8b 00                	mov    (%eax),%eax
f0102e14:	48                   	dec    %eax
f0102e15:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0102e18:	89 07                	mov    %eax,(%edi)
f0102e1a:	83 c4 14             	add    $0x14,%esp
f0102e1d:	5b                   	pop    %ebx
f0102e1e:	5e                   	pop    %esi
f0102e1f:	5f                   	pop    %edi
f0102e20:	5d                   	pop    %ebp
f0102e21:	c3                   	ret    
f0102e22:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102e25:	8b 00                	mov    (%eax),%eax
f0102e27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102e2a:	8b 0f                	mov    (%edi),%ecx
f0102e2c:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102e2f:	01 c2                	add    %eax,%edx
f0102e31:	8b 7d f0             	mov    -0x10(%ebp),%edi
f0102e34:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0102e37:	39 c1                	cmp    %eax,%ecx
f0102e39:	7d 0e                	jge    f0102e49 <stab_binsearch+0xe6>
f0102e3b:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0102e3f:	83 ea 0c             	sub    $0xc,%edx
f0102e42:	39 f3                	cmp    %esi,%ebx
f0102e44:	74 03                	je     f0102e49 <stab_binsearch+0xe6>
f0102e46:	48                   	dec    %eax
f0102e47:	eb ee                	jmp    f0102e37 <stab_binsearch+0xd4>
f0102e49:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102e4c:	89 07                	mov    %eax,(%edi)
f0102e4e:	eb ca                	jmp    f0102e1a <stab_binsearch+0xb7>

f0102e50 <debuginfo_eip>:
f0102e50:	55                   	push   %ebp
f0102e51:	89 e5                	mov    %esp,%ebp
f0102e53:	57                   	push   %edi
f0102e54:	56                   	push   %esi
f0102e55:	53                   	push   %ebx
f0102e56:	83 ec 3c             	sub    $0x3c,%esp
f0102e59:	8b 7d 08             	mov    0x8(%ebp),%edi
f0102e5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102e5f:	c7 03 88 54 10 f0    	movl   $0xf0105488,(%ebx)
f0102e65:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
f0102e6c:	c7 43 08 88 54 10 f0 	movl   $0xf0105488,0x8(%ebx)
f0102e73:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
f0102e7a:	89 7b 10             	mov    %edi,0x10(%ebx)
f0102e7d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
f0102e84:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0102e8a:	0f 86 51 01 00 00    	jbe    f0102fe1 <debuginfo_eip+0x191>
f0102e90:	b8 bf e1 10 f0       	mov    $0xf010e1bf,%eax
f0102e95:	3d d5 c2 10 f0       	cmp    $0xf010c2d5,%eax
f0102e9a:	0f 86 c8 01 00 00    	jbe    f0103068 <debuginfo_eip+0x218>
f0102ea0:	80 3d be e1 10 f0 00 	cmpb   $0x0,0xf010e1be
f0102ea7:	0f 85 c2 01 00 00    	jne    f010306f <debuginfo_eip+0x21f>
f0102ead:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0102eb4:	b8 d4 c2 10 f0       	mov    $0xf010c2d4,%eax
f0102eb9:	2d bc 56 10 f0       	sub    $0xf01056bc,%eax
f0102ebe:	89 c2                	mov    %eax,%edx
f0102ec0:	c1 fa 02             	sar    $0x2,%edx
f0102ec3:	83 e0 fc             	and    $0xfffffffc,%eax
f0102ec6:	01 d0                	add    %edx,%eax
f0102ec8:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102ecb:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102ece:	89 c1                	mov    %eax,%ecx
f0102ed0:	c1 e1 08             	shl    $0x8,%ecx
f0102ed3:	01 c8                	add    %ecx,%eax
f0102ed5:	89 c1                	mov    %eax,%ecx
f0102ed7:	c1 e1 10             	shl    $0x10,%ecx
f0102eda:	01 c8                	add    %ecx,%eax
f0102edc:	01 c0                	add    %eax,%eax
f0102ede:	8d 44 02 ff          	lea    -0x1(%edx,%eax,1),%eax
f0102ee2:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102ee5:	83 ec 08             	sub    $0x8,%esp
f0102ee8:	57                   	push   %edi
f0102ee9:	6a 64                	push   $0x64
f0102eeb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0102eee:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0102ef1:	b8 bc 56 10 f0       	mov    $0xf01056bc,%eax
f0102ef6:	e8 68 fe ff ff       	call   f0102d63 <stab_binsearch>
f0102efb:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0102efe:	83 c4 10             	add    $0x10,%esp
f0102f01:	85 f6                	test   %esi,%esi
f0102f03:	0f 84 6d 01 00 00    	je     f0103076 <debuginfo_eip+0x226>
f0102f09:	89 75 dc             	mov    %esi,-0x24(%ebp)
f0102f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102f0f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102f12:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102f15:	83 ec 08             	sub    $0x8,%esp
f0102f18:	57                   	push   %edi
f0102f19:	6a 24                	push   $0x24
f0102f1b:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0102f1e:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0102f21:	b8 bc 56 10 f0       	mov    $0xf01056bc,%eax
f0102f26:	e8 38 fe ff ff       	call   f0102d63 <stab_binsearch>
f0102f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102f2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102f31:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0102f34:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f0102f37:	83 c4 10             	add    $0x10,%esp
f0102f3a:	39 c8                	cmp    %ecx,%eax
f0102f3c:	0f 8f b3 00 00 00    	jg     f0102ff5 <debuginfo_eip+0x1a5>
f0102f42:	89 c1                	mov    %eax,%ecx
f0102f44:	01 c0                	add    %eax,%eax
f0102f46:	01 c8                	add    %ecx,%eax
f0102f48:	c1 e0 02             	shl    $0x2,%eax
f0102f4b:	8d 90 bc 56 10 f0    	lea    -0xfefa944(%eax),%edx
f0102f51:	8b 88 bc 56 10 f0    	mov    -0xfefa944(%eax),%ecx
f0102f57:	b8 bf e1 10 f0       	mov    $0xf010e1bf,%eax
f0102f5c:	2d d5 c2 10 f0       	sub    $0xf010c2d5,%eax
f0102f61:	39 c1                	cmp    %eax,%ecx
f0102f63:	73 09                	jae    f0102f6e <debuginfo_eip+0x11e>
f0102f65:	81 c1 d5 c2 10 f0    	add    $0xf010c2d5,%ecx
f0102f6b:	89 4b 08             	mov    %ecx,0x8(%ebx)
f0102f6e:	8b 42 08             	mov    0x8(%edx),%eax
f0102f71:	89 43 10             	mov    %eax,0x10(%ebx)
f0102f74:	29 c7                	sub    %eax,%edi
f0102f76:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0102f79:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0102f7c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0102f7f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102f82:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0102f85:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102f88:	83 ec 08             	sub    $0x8,%esp
f0102f8b:	6a 3a                	push   $0x3a
f0102f8d:	ff 73 08             	push   0x8(%ebx)
f0102f90:	e8 ec 08 00 00       	call   f0103881 <strfind>
f0102f95:	2b 43 08             	sub    0x8(%ebx),%eax
f0102f98:	89 43 0c             	mov    %eax,0xc(%ebx)
f0102f9b:	83 c4 08             	add    $0x8,%esp
f0102f9e:	89 f8                	mov    %edi,%eax
f0102fa0:	03 43 10             	add    0x10(%ebx),%eax
f0102fa3:	50                   	push   %eax
f0102fa4:	6a 44                	push   $0x44
f0102fa6:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0102fa9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0102fac:	b8 bc 56 10 f0       	mov    $0xf01056bc,%eax
f0102fb1:	e8 ad fd ff ff       	call   f0102d63 <stab_binsearch>
f0102fb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fb9:	83 c4 10             	add    $0x10,%esp
f0102fbc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0102fbf:	7f 38                	jg     f0102ff9 <debuginfo_eip+0x1a9>
f0102fc1:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0102fc4:	01 c2                	add    %eax,%edx
f0102fc6:	0f b7 14 95 c2 56 10 	movzwl -0xfefa93e(,%edx,4),%edx
f0102fcd:	f0 
f0102fce:	89 53 04             	mov    %edx,0x4(%ebx)
f0102fd1:	89 c2                	mov    %eax,%edx
f0102fd3:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
f0102fd6:	01 c8                	add    %ecx,%eax
f0102fd8:	8d 04 85 bc 56 10 f0 	lea    -0xfefa944(,%eax,4),%eax
f0102fdf:	eb 23                	jmp    f0103004 <debuginfo_eip+0x1b4>
f0102fe1:	83 ec 04             	sub    $0x4,%esp
f0102fe4:	68 92 54 10 f0       	push   $0xf0105492
f0102fe9:	6a 7d                	push   $0x7d
f0102feb:	68 9f 54 10 f0       	push   $0xf010549f
f0102ff0:	e8 43 d1 ff ff       	call   f0100138 <_panic>
f0102ff5:	89 f0                	mov    %esi,%eax
f0102ff7:	eb 86                	jmp    f0102f7f <debuginfo_eip+0x12f>
f0102ff9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0102ffe:	eb ce                	jmp    f0102fce <debuginfo_eip+0x17e>
f0103000:	4a                   	dec    %edx
f0103001:	83 e8 0c             	sub    $0xc,%eax
f0103004:	39 d6                	cmp    %edx,%esi
f0103006:	7f 35                	jg     f010303d <debuginfo_eip+0x1ed>
f0103008:	8a 48 04             	mov    0x4(%eax),%cl
f010300b:	80 f9 84             	cmp    $0x84,%cl
f010300e:	74 0b                	je     f010301b <debuginfo_eip+0x1cb>
f0103010:	80 f9 64             	cmp    $0x64,%cl
f0103013:	75 eb                	jne    f0103000 <debuginfo_eip+0x1b0>
f0103015:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
f0103019:	74 e5                	je     f0103000 <debuginfo_eip+0x1b0>
f010301b:	8d 04 12             	lea    (%edx,%edx,1),%eax
f010301e:	01 d0                	add    %edx,%eax
f0103020:	8b 14 85 bc 56 10 f0 	mov    -0xfefa944(,%eax,4),%edx
f0103027:	b8 bf e1 10 f0       	mov    $0xf010e1bf,%eax
f010302c:	2d d5 c2 10 f0       	sub    $0xf010c2d5,%eax
f0103031:	39 c2                	cmp    %eax,%edx
f0103033:	73 08                	jae    f010303d <debuginfo_eip+0x1ed>
f0103035:	81 c2 d5 c2 10 f0    	add    $0xf010c2d5,%edx
f010303b:	89 13                	mov    %edx,(%ebx)
f010303d:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103040:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0103043:	39 c8                	cmp    %ecx,%eax
f0103045:	7d 36                	jge    f010307d <debuginfo_eip+0x22d>
f0103047:	40                   	inc    %eax
f0103048:	eb 03                	jmp    f010304d <debuginfo_eip+0x1fd>
f010304a:	ff 43 14             	incl   0x14(%ebx)
f010304d:	39 c1                	cmp    %eax,%ecx
f010304f:	7e 39                	jle    f010308a <debuginfo_eip+0x23a>
f0103051:	40                   	inc    %eax
f0103052:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103055:	01 c2                	add    %eax,%edx
f0103057:	80 3c 95 b4 56 10 f0 	cmpb   $0xa0,-0xfefa94c(,%edx,4)
f010305e:	a0 
f010305f:	74 e9                	je     f010304a <debuginfo_eip+0x1fa>
f0103061:	b8 00 00 00 00       	mov    $0x0,%eax
f0103066:	eb 1a                	jmp    f0103082 <debuginfo_eip+0x232>
f0103068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010306d:	eb 13                	jmp    f0103082 <debuginfo_eip+0x232>
f010306f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103074:	eb 0c                	jmp    f0103082 <debuginfo_eip+0x232>
f0103076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010307b:	eb 05                	jmp    f0103082 <debuginfo_eip+0x232>
f010307d:	b8 00 00 00 00       	mov    $0x0,%eax
f0103082:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103085:	5b                   	pop    %ebx
f0103086:	5e                   	pop    %esi
f0103087:	5f                   	pop    %edi
f0103088:	5d                   	pop    %ebp
f0103089:	c3                   	ret    
f010308a:	b8 00 00 00 00       	mov    $0x0,%eax
f010308f:	eb f1                	jmp    f0103082 <debuginfo_eip+0x232>

f0103091 <printnum>:
f0103091:	55                   	push   %ebp
f0103092:	89 e5                	mov    %esp,%ebp
f0103094:	57                   	push   %edi
f0103095:	56                   	push   %esi
f0103096:	53                   	push   %ebx
f0103097:	83 ec 1c             	sub    $0x1c,%esp
f010309a:	89 c7                	mov    %eax,%edi
f010309c:	89 d6                	mov    %edx,%esi
f010309e:	8b 45 08             	mov    0x8(%ebp),%eax
f01030a1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01030a4:	89 d1                	mov    %edx,%ecx
f01030a6:	89 c2                	mov    %eax,%edx
f01030a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01030ab:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01030ae:	8b 45 10             	mov    0x10(%ebp),%eax
f01030b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01030b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01030b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01030be:	39 c2                	cmp    %eax,%edx
f01030c0:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f01030c3:	72 3c                	jb     f0103101 <printnum+0x70>
f01030c5:	83 ec 0c             	sub    $0xc,%esp
f01030c8:	ff 75 18             	push   0x18(%ebp)
f01030cb:	4b                   	dec    %ebx
f01030cc:	53                   	push   %ebx
f01030cd:	50                   	push   %eax
f01030ce:	83 ec 08             	sub    $0x8,%esp
f01030d1:	ff 75 e4             	push   -0x1c(%ebp)
f01030d4:	ff 75 e0             	push   -0x20(%ebp)
f01030d7:	ff 75 dc             	push   -0x24(%ebp)
f01030da:	ff 75 d8             	push   -0x28(%ebp)
f01030dd:	e8 96 09 00 00       	call   f0103a78 <__udivdi3>
f01030e2:	83 c4 18             	add    $0x18,%esp
f01030e5:	52                   	push   %edx
f01030e6:	50                   	push   %eax
f01030e7:	89 f2                	mov    %esi,%edx
f01030e9:	89 f8                	mov    %edi,%eax
f01030eb:	e8 a1 ff ff ff       	call   f0103091 <printnum>
f01030f0:	83 c4 20             	add    $0x20,%esp
f01030f3:	eb 11                	jmp    f0103106 <printnum+0x75>
f01030f5:	83 ec 08             	sub    $0x8,%esp
f01030f8:	56                   	push   %esi
f01030f9:	ff 75 18             	push   0x18(%ebp)
f01030fc:	ff d7                	call   *%edi
f01030fe:	83 c4 10             	add    $0x10,%esp
f0103101:	4b                   	dec    %ebx
f0103102:	85 db                	test   %ebx,%ebx
f0103104:	7f ef                	jg     f01030f5 <printnum+0x64>
f0103106:	83 ec 08             	sub    $0x8,%esp
f0103109:	56                   	push   %esi
f010310a:	83 ec 04             	sub    $0x4,%esp
f010310d:	ff 75 e4             	push   -0x1c(%ebp)
f0103110:	ff 75 e0             	push   -0x20(%ebp)
f0103113:	ff 75 dc             	push   -0x24(%ebp)
f0103116:	ff 75 d8             	push   -0x28(%ebp)
f0103119:	e8 62 0a 00 00       	call   f0103b80 <__umoddi3>
f010311e:	83 c4 14             	add    $0x14,%esp
f0103121:	0f be 80 ad 54 10 f0 	movsbl -0xfefab53(%eax),%eax
f0103128:	50                   	push   %eax
f0103129:	ff d7                	call   *%edi
f010312b:	83 c4 10             	add    $0x10,%esp
f010312e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103131:	5b                   	pop    %ebx
f0103132:	5e                   	pop    %esi
f0103133:	5f                   	pop    %edi
f0103134:	5d                   	pop    %ebp
f0103135:	c3                   	ret    

f0103136 <sprintputch>:
f0103136:	55                   	push   %ebp
f0103137:	89 e5                	mov    %esp,%ebp
f0103139:	8b 45 0c             	mov    0xc(%ebp),%eax
f010313c:	ff 40 08             	incl   0x8(%eax)
f010313f:	8b 10                	mov    (%eax),%edx
f0103141:	3b 50 04             	cmp    0x4(%eax),%edx
f0103144:	73 0a                	jae    f0103150 <sprintputch+0x1a>
f0103146:	8d 4a 01             	lea    0x1(%edx),%ecx
f0103149:	89 08                	mov    %ecx,(%eax)
f010314b:	8b 45 08             	mov    0x8(%ebp),%eax
f010314e:	88 02                	mov    %al,(%edx)
f0103150:	5d                   	pop    %ebp
f0103151:	c3                   	ret    

f0103152 <printfmt>:
f0103152:	55                   	push   %ebp
f0103153:	89 e5                	mov    %esp,%ebp
f0103155:	83 ec 08             	sub    $0x8,%esp
f0103158:	8d 45 14             	lea    0x14(%ebp),%eax
f010315b:	50                   	push   %eax
f010315c:	ff 75 10             	push   0x10(%ebp)
f010315f:	ff 75 0c             	push   0xc(%ebp)
f0103162:	ff 75 08             	push   0x8(%ebp)
f0103165:	e8 05 00 00 00       	call   f010316f <vprintfmt>
f010316a:	83 c4 10             	add    $0x10,%esp
f010316d:	c9                   	leave  
f010316e:	c3                   	ret    

f010316f <vprintfmt>:
f010316f:	55                   	push   %ebp
f0103170:	89 e5                	mov    %esp,%ebp
f0103172:	57                   	push   %edi
f0103173:	56                   	push   %esi
f0103174:	53                   	push   %ebx
f0103175:	83 ec 3c             	sub    $0x3c,%esp
f0103178:	8b 75 08             	mov    0x8(%ebp),%esi
f010317b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010317e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0103181:	eb 0a                	jmp    f010318d <vprintfmt+0x1e>
f0103183:	83 ec 08             	sub    $0x8,%esp
f0103186:	53                   	push   %ebx
f0103187:	50                   	push   %eax
f0103188:	ff d6                	call   *%esi
f010318a:	83 c4 10             	add    $0x10,%esp
f010318d:	47                   	inc    %edi
f010318e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0103192:	83 f8 25             	cmp    $0x25,%eax
f0103195:	74 0c                	je     f01031a3 <vprintfmt+0x34>
f0103197:	85 c0                	test   %eax,%eax
f0103199:	75 e8                	jne    f0103183 <vprintfmt+0x14>
f010319b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010319e:	5b                   	pop    %ebx
f010319f:	5e                   	pop    %esi
f01031a0:	5f                   	pop    %edi
f01031a1:	5d                   	pop    %ebp
f01031a2:	c3                   	ret    
f01031a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
f01031a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01031ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f01031b5:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f01031bc:	b9 00 00 00 00       	mov    $0x0,%ecx
f01031c1:	8d 47 01             	lea    0x1(%edi),%eax
f01031c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01031c7:	8a 17                	mov    (%edi),%dl
f01031c9:	8d 42 dd             	lea    -0x23(%edx),%eax
f01031cc:	3c 55                	cmp    $0x55,%al
f01031ce:	0f 87 f2 03 00 00    	ja     f01035c6 <vprintfmt+0x457>
f01031d4:	0f b6 c0             	movzbl %al,%eax
f01031d7:	ff 24 85 38 55 10 f0 	jmp    *-0xfefaac8(,%eax,4)
f01031de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01031e1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01031e5:	eb da                	jmp    f01031c1 <vprintfmt+0x52>
f01031e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01031ea:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01031ee:	eb d1                	jmp    f01031c1 <vprintfmt+0x52>
f01031f0:	0f b6 d2             	movzbl %dl,%edx
f01031f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01031f6:	b8 00 00 00 00       	mov    $0x0,%eax
f01031fb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01031fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0103201:	01 c0                	add    %eax,%eax
f0103203:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
f0103207:	0f be 17             	movsbl (%edi),%edx
f010320a:	8d 4a d0             	lea    -0x30(%edx),%ecx
f010320d:	83 f9 09             	cmp    $0x9,%ecx
f0103210:	77 52                	ja     f0103264 <vprintfmt+0xf5>
f0103212:	47                   	inc    %edi
f0103213:	eb e9                	jmp    f01031fe <vprintfmt+0x8f>
f0103215:	8b 45 14             	mov    0x14(%ebp),%eax
f0103218:	8b 00                	mov    (%eax),%eax
f010321a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010321d:	8b 45 14             	mov    0x14(%ebp),%eax
f0103220:	8d 40 04             	lea    0x4(%eax),%eax
f0103223:	89 45 14             	mov    %eax,0x14(%ebp)
f0103226:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103229:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010322d:	79 92                	jns    f01031c1 <vprintfmt+0x52>
f010322f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103232:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103235:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f010323c:	eb 83                	jmp    f01031c1 <vprintfmt+0x52>
f010323e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0103242:	78 08                	js     f010324c <vprintfmt+0xdd>
f0103244:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103247:	e9 75 ff ff ff       	jmp    f01031c1 <vprintfmt+0x52>
f010324c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0103253:	eb ef                	jmp    f0103244 <vprintfmt+0xd5>
f0103255:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103258:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
f010325f:	e9 5d ff ff ff       	jmp    f01031c1 <vprintfmt+0x52>
f0103264:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0103267:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010326a:	eb bd                	jmp    f0103229 <vprintfmt+0xba>
f010326c:	41                   	inc    %ecx
f010326d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103270:	e9 4c ff ff ff       	jmp    f01031c1 <vprintfmt+0x52>
f0103275:	8b 45 14             	mov    0x14(%ebp),%eax
f0103278:	8d 78 04             	lea    0x4(%eax),%edi
f010327b:	83 ec 08             	sub    $0x8,%esp
f010327e:	53                   	push   %ebx
f010327f:	ff 30                	push   (%eax)
f0103281:	ff d6                	call   *%esi
f0103283:	83 c4 10             	add    $0x10,%esp
f0103286:	89 7d 14             	mov    %edi,0x14(%ebp)
f0103289:	e9 d7 02 00 00       	jmp    f0103565 <vprintfmt+0x3f6>
f010328e:	8b 45 14             	mov    0x14(%ebp),%eax
f0103291:	8d 78 04             	lea    0x4(%eax),%edi
f0103294:	8b 00                	mov    (%eax),%eax
f0103296:	85 c0                	test   %eax,%eax
f0103298:	78 2a                	js     f01032c4 <vprintfmt+0x155>
f010329a:	89 c2                	mov    %eax,%edx
f010329c:	83 f8 06             	cmp    $0x6,%eax
f010329f:	7f 27                	jg     f01032c8 <vprintfmt+0x159>
f01032a1:	8b 04 85 90 56 10 f0 	mov    -0xfefa970(,%eax,4),%eax
f01032a8:	85 c0                	test   %eax,%eax
f01032aa:	74 1c                	je     f01032c8 <vprintfmt+0x159>
f01032ac:	50                   	push   %eax
f01032ad:	68 0f 51 10 f0       	push   $0xf010510f
f01032b2:	53                   	push   %ebx
f01032b3:	56                   	push   %esi
f01032b4:	e8 99 fe ff ff       	call   f0103152 <printfmt>
f01032b9:	83 c4 10             	add    $0x10,%esp
f01032bc:	89 7d 14             	mov    %edi,0x14(%ebp)
f01032bf:	e9 a1 02 00 00       	jmp    f0103565 <vprintfmt+0x3f6>
f01032c4:	f7 d8                	neg    %eax
f01032c6:	eb d2                	jmp    f010329a <vprintfmt+0x12b>
f01032c8:	52                   	push   %edx
f01032c9:	68 c5 54 10 f0       	push   $0xf01054c5
f01032ce:	53                   	push   %ebx
f01032cf:	56                   	push   %esi
f01032d0:	e8 7d fe ff ff       	call   f0103152 <printfmt>
f01032d5:	83 c4 10             	add    $0x10,%esp
f01032d8:	89 7d 14             	mov    %edi,0x14(%ebp)
f01032db:	e9 85 02 00 00       	jmp    f0103565 <vprintfmt+0x3f6>
f01032e0:	8b 45 14             	mov    0x14(%ebp),%eax
f01032e3:	83 c0 04             	add    $0x4,%eax
f01032e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01032e9:	8b 45 14             	mov    0x14(%ebp),%eax
f01032ec:	8b 00                	mov    (%eax),%eax
f01032ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01032f1:	85 c0                	test   %eax,%eax
f01032f3:	74 19                	je     f010330e <vprintfmt+0x19f>
f01032f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01032f9:	7e 06                	jle    f0103301 <vprintfmt+0x192>
f01032fb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01032ff:	75 16                	jne    f0103317 <vprintfmt+0x1a8>
f0103301:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103304:	89 c7                	mov    %eax,%edi
f0103306:	03 45 d4             	add    -0x2c(%ebp),%eax
f0103309:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010330c:	eb 62                	jmp    f0103370 <vprintfmt+0x201>
f010330e:	c7 45 cc be 54 10 f0 	movl   $0xf01054be,-0x34(%ebp)
f0103315:	eb de                	jmp    f01032f5 <vprintfmt+0x186>
f0103317:	83 ec 08             	sub    $0x8,%esp
f010331a:	ff 75 d8             	push   -0x28(%ebp)
f010331d:	ff 75 cc             	push   -0x34(%ebp)
f0103320:	e8 1e 04 00 00       	call   f0103743 <strnlen>
f0103325:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103328:	29 c2                	sub    %eax,%edx
f010332a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f010332d:	83 c4 10             	add    $0x10,%esp
f0103330:	89 d7                	mov    %edx,%edi
f0103332:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0103336:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103339:	85 ff                	test   %edi,%edi
f010333b:	7e 0f                	jle    f010334c <vprintfmt+0x1dd>
f010333d:	83 ec 08             	sub    $0x8,%esp
f0103340:	53                   	push   %ebx
f0103341:	ff 75 d4             	push   -0x2c(%ebp)
f0103344:	ff d6                	call   *%esi
f0103346:	4f                   	dec    %edi
f0103347:	83 c4 10             	add    $0x10,%esp
f010334a:	eb ed                	jmp    f0103339 <vprintfmt+0x1ca>
f010334c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010334f:	89 d0                	mov    %edx,%eax
f0103351:	85 d2                	test   %edx,%edx
f0103353:	78 0a                	js     f010335f <vprintfmt+0x1f0>
f0103355:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0103358:	29 c2                	sub    %eax,%edx
f010335a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010335d:	eb a2                	jmp    f0103301 <vprintfmt+0x192>
f010335f:	b8 00 00 00 00       	mov    $0x0,%eax
f0103364:	eb ef                	jmp    f0103355 <vprintfmt+0x1e6>
f0103366:	83 ec 08             	sub    $0x8,%esp
f0103369:	53                   	push   %ebx
f010336a:	52                   	push   %edx
f010336b:	ff d6                	call   *%esi
f010336d:	83 c4 10             	add    $0x10,%esp
f0103370:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103373:	29 f9                	sub    %edi,%ecx
f0103375:	47                   	inc    %edi
f0103376:	8a 47 ff             	mov    -0x1(%edi),%al
f0103379:	0f be d0             	movsbl %al,%edx
f010337c:	85 d2                	test   %edx,%edx
f010337e:	74 48                	je     f01033c8 <vprintfmt+0x259>
f0103380:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0103384:	78 05                	js     f010338b <vprintfmt+0x21c>
f0103386:	ff 4d d8             	decl   -0x28(%ebp)
f0103389:	78 1e                	js     f01033a9 <vprintfmt+0x23a>
f010338b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010338f:	74 d5                	je     f0103366 <vprintfmt+0x1f7>
f0103391:	0f be c0             	movsbl %al,%eax
f0103394:	83 e8 20             	sub    $0x20,%eax
f0103397:	83 f8 5e             	cmp    $0x5e,%eax
f010339a:	76 ca                	jbe    f0103366 <vprintfmt+0x1f7>
f010339c:	83 ec 08             	sub    $0x8,%esp
f010339f:	53                   	push   %ebx
f01033a0:	6a 3f                	push   $0x3f
f01033a2:	ff d6                	call   *%esi
f01033a4:	83 c4 10             	add    $0x10,%esp
f01033a7:	eb c7                	jmp    f0103370 <vprintfmt+0x201>
f01033a9:	89 cf                	mov    %ecx,%edi
f01033ab:	eb 0c                	jmp    f01033b9 <vprintfmt+0x24a>
f01033ad:	83 ec 08             	sub    $0x8,%esp
f01033b0:	53                   	push   %ebx
f01033b1:	6a 20                	push   $0x20
f01033b3:	ff d6                	call   *%esi
f01033b5:	4f                   	dec    %edi
f01033b6:	83 c4 10             	add    $0x10,%esp
f01033b9:	85 ff                	test   %edi,%edi
f01033bb:	7f f0                	jg     f01033ad <vprintfmt+0x23e>
f01033bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01033c0:	89 45 14             	mov    %eax,0x14(%ebp)
f01033c3:	e9 9d 01 00 00       	jmp    f0103565 <vprintfmt+0x3f6>
f01033c8:	89 cf                	mov    %ecx,%edi
f01033ca:	eb ed                	jmp    f01033b9 <vprintfmt+0x24a>
f01033cc:	83 f9 01             	cmp    $0x1,%ecx
f01033cf:	7f 1b                	jg     f01033ec <vprintfmt+0x27d>
f01033d1:	85 c9                	test   %ecx,%ecx
f01033d3:	74 42                	je     f0103417 <vprintfmt+0x2a8>
f01033d5:	8b 45 14             	mov    0x14(%ebp),%eax
f01033d8:	8b 00                	mov    (%eax),%eax
f01033da:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01033dd:	99                   	cltd   
f01033de:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01033e1:	8b 45 14             	mov    0x14(%ebp),%eax
f01033e4:	8d 40 04             	lea    0x4(%eax),%eax
f01033e7:	89 45 14             	mov    %eax,0x14(%ebp)
f01033ea:	eb 17                	jmp    f0103403 <vprintfmt+0x294>
f01033ec:	8b 45 14             	mov    0x14(%ebp),%eax
f01033ef:	8b 50 04             	mov    0x4(%eax),%edx
f01033f2:	8b 00                	mov    (%eax),%eax
f01033f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01033f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01033fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01033fd:	8d 40 08             	lea    0x8(%eax),%eax
f0103400:	89 45 14             	mov    %eax,0x14(%ebp)
f0103403:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103406:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103409:	85 c9                	test   %ecx,%ecx
f010340b:	78 21                	js     f010342e <vprintfmt+0x2bf>
f010340d:	bf 0a 00 00 00       	mov    $0xa,%edi
f0103412:	e9 34 01 00 00       	jmp    f010354b <vprintfmt+0x3dc>
f0103417:	8b 45 14             	mov    0x14(%ebp),%eax
f010341a:	8b 00                	mov    (%eax),%eax
f010341c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010341f:	99                   	cltd   
f0103420:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0103423:	8b 45 14             	mov    0x14(%ebp),%eax
f0103426:	8d 40 04             	lea    0x4(%eax),%eax
f0103429:	89 45 14             	mov    %eax,0x14(%ebp)
f010342c:	eb d5                	jmp    f0103403 <vprintfmt+0x294>
f010342e:	83 ec 08             	sub    $0x8,%esp
f0103431:	53                   	push   %ebx
f0103432:	6a 2d                	push   $0x2d
f0103434:	ff d6                	call   *%esi
f0103436:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103439:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010343c:	f7 da                	neg    %edx
f010343e:	83 d1 00             	adc    $0x0,%ecx
f0103441:	f7 d9                	neg    %ecx
f0103443:	83 c4 10             	add    $0x10,%esp
f0103446:	bf 0a 00 00 00       	mov    $0xa,%edi
f010344b:	e9 fb 00 00 00       	jmp    f010354b <vprintfmt+0x3dc>
f0103450:	83 f9 01             	cmp    $0x1,%ecx
f0103453:	7f 1e                	jg     f0103473 <vprintfmt+0x304>
f0103455:	85 c9                	test   %ecx,%ecx
f0103457:	74 32                	je     f010348b <vprintfmt+0x31c>
f0103459:	8b 45 14             	mov    0x14(%ebp),%eax
f010345c:	8b 10                	mov    (%eax),%edx
f010345e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103463:	8d 40 04             	lea    0x4(%eax),%eax
f0103466:	89 45 14             	mov    %eax,0x14(%ebp)
f0103469:	bf 0a 00 00 00       	mov    $0xa,%edi
f010346e:	e9 d8 00 00 00       	jmp    f010354b <vprintfmt+0x3dc>
f0103473:	8b 45 14             	mov    0x14(%ebp),%eax
f0103476:	8b 10                	mov    (%eax),%edx
f0103478:	8b 48 04             	mov    0x4(%eax),%ecx
f010347b:	8d 40 08             	lea    0x8(%eax),%eax
f010347e:	89 45 14             	mov    %eax,0x14(%ebp)
f0103481:	bf 0a 00 00 00       	mov    $0xa,%edi
f0103486:	e9 c0 00 00 00       	jmp    f010354b <vprintfmt+0x3dc>
f010348b:	8b 45 14             	mov    0x14(%ebp),%eax
f010348e:	8b 10                	mov    (%eax),%edx
f0103490:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103495:	8d 40 04             	lea    0x4(%eax),%eax
f0103498:	89 45 14             	mov    %eax,0x14(%ebp)
f010349b:	bf 0a 00 00 00       	mov    $0xa,%edi
f01034a0:	e9 a6 00 00 00       	jmp    f010354b <vprintfmt+0x3dc>
f01034a5:	83 f9 01             	cmp    $0x1,%ecx
f01034a8:	7f 1b                	jg     f01034c5 <vprintfmt+0x356>
f01034aa:	85 c9                	test   %ecx,%ecx
f01034ac:	74 3f                	je     f01034ed <vprintfmt+0x37e>
f01034ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01034b1:	8b 00                	mov    (%eax),%eax
f01034b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01034b6:	99                   	cltd   
f01034b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01034ba:	8b 45 14             	mov    0x14(%ebp),%eax
f01034bd:	8d 40 04             	lea    0x4(%eax),%eax
f01034c0:	89 45 14             	mov    %eax,0x14(%ebp)
f01034c3:	eb 17                	jmp    f01034dc <vprintfmt+0x36d>
f01034c5:	8b 45 14             	mov    0x14(%ebp),%eax
f01034c8:	8b 50 04             	mov    0x4(%eax),%edx
f01034cb:	8b 00                	mov    (%eax),%eax
f01034cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01034d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01034d3:	8b 45 14             	mov    0x14(%ebp),%eax
f01034d6:	8d 40 08             	lea    0x8(%eax),%eax
f01034d9:	89 45 14             	mov    %eax,0x14(%ebp)
f01034dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01034df:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01034e2:	85 c9                	test   %ecx,%ecx
f01034e4:	78 1e                	js     f0103504 <vprintfmt+0x395>
f01034e6:	bf 08 00 00 00       	mov    $0x8,%edi
f01034eb:	eb 5e                	jmp    f010354b <vprintfmt+0x3dc>
f01034ed:	8b 45 14             	mov    0x14(%ebp),%eax
f01034f0:	8b 00                	mov    (%eax),%eax
f01034f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01034f5:	99                   	cltd   
f01034f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01034f9:	8b 45 14             	mov    0x14(%ebp),%eax
f01034fc:	8d 40 04             	lea    0x4(%eax),%eax
f01034ff:	89 45 14             	mov    %eax,0x14(%ebp)
f0103502:	eb d8                	jmp    f01034dc <vprintfmt+0x36d>
f0103504:	83 ec 08             	sub    $0x8,%esp
f0103507:	53                   	push   %ebx
f0103508:	6a 2d                	push   $0x2d
f010350a:	ff d6                	call   *%esi
f010350c:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010350f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103512:	f7 da                	neg    %edx
f0103514:	83 d1 00             	adc    $0x0,%ecx
f0103517:	f7 d9                	neg    %ecx
f0103519:	83 c4 10             	add    $0x10,%esp
f010351c:	bf 08 00 00 00       	mov    $0x8,%edi
f0103521:	eb 28                	jmp    f010354b <vprintfmt+0x3dc>
f0103523:	83 ec 08             	sub    $0x8,%esp
f0103526:	53                   	push   %ebx
f0103527:	6a 30                	push   $0x30
f0103529:	ff d6                	call   *%esi
f010352b:	83 c4 08             	add    $0x8,%esp
f010352e:	53                   	push   %ebx
f010352f:	6a 78                	push   $0x78
f0103531:	ff d6                	call   *%esi
f0103533:	8b 45 14             	mov    0x14(%ebp),%eax
f0103536:	8b 10                	mov    (%eax),%edx
f0103538:	b9 00 00 00 00       	mov    $0x0,%ecx
f010353d:	83 c4 10             	add    $0x10,%esp
f0103540:	8d 40 04             	lea    0x4(%eax),%eax
f0103543:	89 45 14             	mov    %eax,0x14(%ebp)
f0103546:	bf 10 00 00 00       	mov    $0x10,%edi
f010354b:	83 ec 0c             	sub    $0xc,%esp
f010354e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0103552:	50                   	push   %eax
f0103553:	ff 75 d4             	push   -0x2c(%ebp)
f0103556:	57                   	push   %edi
f0103557:	51                   	push   %ecx
f0103558:	52                   	push   %edx
f0103559:	89 da                	mov    %ebx,%edx
f010355b:	89 f0                	mov    %esi,%eax
f010355d:	e8 2f fb ff ff       	call   f0103091 <printnum>
f0103562:	83 c4 20             	add    $0x20,%esp
f0103565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103568:	e9 20 fc ff ff       	jmp    f010318d <vprintfmt+0x1e>
f010356d:	83 f9 01             	cmp    $0x1,%ecx
f0103570:	7f 1b                	jg     f010358d <vprintfmt+0x41e>
f0103572:	85 c9                	test   %ecx,%ecx
f0103574:	74 2c                	je     f01035a2 <vprintfmt+0x433>
f0103576:	8b 45 14             	mov    0x14(%ebp),%eax
f0103579:	8b 10                	mov    (%eax),%edx
f010357b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103580:	8d 40 04             	lea    0x4(%eax),%eax
f0103583:	89 45 14             	mov    %eax,0x14(%ebp)
f0103586:	bf 10 00 00 00       	mov    $0x10,%edi
f010358b:	eb be                	jmp    f010354b <vprintfmt+0x3dc>
f010358d:	8b 45 14             	mov    0x14(%ebp),%eax
f0103590:	8b 10                	mov    (%eax),%edx
f0103592:	8b 48 04             	mov    0x4(%eax),%ecx
f0103595:	8d 40 08             	lea    0x8(%eax),%eax
f0103598:	89 45 14             	mov    %eax,0x14(%ebp)
f010359b:	bf 10 00 00 00       	mov    $0x10,%edi
f01035a0:	eb a9                	jmp    f010354b <vprintfmt+0x3dc>
f01035a2:	8b 45 14             	mov    0x14(%ebp),%eax
f01035a5:	8b 10                	mov    (%eax),%edx
f01035a7:	b9 00 00 00 00       	mov    $0x0,%ecx
f01035ac:	8d 40 04             	lea    0x4(%eax),%eax
f01035af:	89 45 14             	mov    %eax,0x14(%ebp)
f01035b2:	bf 10 00 00 00       	mov    $0x10,%edi
f01035b7:	eb 92                	jmp    f010354b <vprintfmt+0x3dc>
f01035b9:	83 ec 08             	sub    $0x8,%esp
f01035bc:	53                   	push   %ebx
f01035bd:	6a 25                	push   $0x25
f01035bf:	ff d6                	call   *%esi
f01035c1:	83 c4 10             	add    $0x10,%esp
f01035c4:	eb 9f                	jmp    f0103565 <vprintfmt+0x3f6>
f01035c6:	83 ec 08             	sub    $0x8,%esp
f01035c9:	53                   	push   %ebx
f01035ca:	6a 25                	push   $0x25
f01035cc:	ff d6                	call   *%esi
f01035ce:	83 c4 10             	add    $0x10,%esp
f01035d1:	89 f8                	mov    %edi,%eax
f01035d3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01035d7:	74 03                	je     f01035dc <vprintfmt+0x46d>
f01035d9:	48                   	dec    %eax
f01035da:	eb f7                	jmp    f01035d3 <vprintfmt+0x464>
f01035dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01035df:	eb 84                	jmp    f0103565 <vprintfmt+0x3f6>

f01035e1 <vsnprintf>:
f01035e1:	55                   	push   %ebp
f01035e2:	89 e5                	mov    %esp,%ebp
f01035e4:	83 ec 18             	sub    $0x18,%esp
f01035e7:	8b 45 08             	mov    0x8(%ebp),%eax
f01035ea:	8b 55 0c             	mov    0xc(%ebp),%edx
f01035ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01035f0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01035f4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01035f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01035fe:	85 c0                	test   %eax,%eax
f0103600:	74 26                	je     f0103628 <vsnprintf+0x47>
f0103602:	85 d2                	test   %edx,%edx
f0103604:	7e 29                	jle    f010362f <vsnprintf+0x4e>
f0103606:	ff 75 14             	push   0x14(%ebp)
f0103609:	ff 75 10             	push   0x10(%ebp)
f010360c:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010360f:	50                   	push   %eax
f0103610:	68 36 31 10 f0       	push   $0xf0103136
f0103615:	e8 55 fb ff ff       	call   f010316f <vprintfmt>
f010361a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010361d:	c6 00 00             	movb   $0x0,(%eax)
f0103620:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103623:	83 c4 10             	add    $0x10,%esp
f0103626:	c9                   	leave  
f0103627:	c3                   	ret    
f0103628:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010362d:	eb f7                	jmp    f0103626 <vsnprintf+0x45>
f010362f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0103634:	eb f0                	jmp    f0103626 <vsnprintf+0x45>

f0103636 <snprintf>:
f0103636:	55                   	push   %ebp
f0103637:	89 e5                	mov    %esp,%ebp
f0103639:	83 ec 08             	sub    $0x8,%esp
f010363c:	8d 45 14             	lea    0x14(%ebp),%eax
f010363f:	50                   	push   %eax
f0103640:	ff 75 10             	push   0x10(%ebp)
f0103643:	ff 75 0c             	push   0xc(%ebp)
f0103646:	ff 75 08             	push   0x8(%ebp)
f0103649:	e8 93 ff ff ff       	call   f01035e1 <vsnprintf>
f010364e:	c9                   	leave  
f010364f:	c3                   	ret    

f0103650 <readline>:
f0103650:	55                   	push   %ebp
f0103651:	89 e5                	mov    %esp,%ebp
f0103653:	57                   	push   %edi
f0103654:	56                   	push   %esi
f0103655:	53                   	push   %ebx
f0103656:	83 ec 0c             	sub    $0xc,%esp
f0103659:	8b 45 08             	mov    0x8(%ebp),%eax
f010365c:	85 c0                	test   %eax,%eax
f010365e:	74 11                	je     f0103671 <readline+0x21>
f0103660:	83 ec 08             	sub    $0x8,%esp
f0103663:	50                   	push   %eax
f0103664:	68 0f 51 10 f0       	push   $0xf010510f
f0103669:	e8 c0 f6 ff ff       	call   f0102d2e <cprintf>
f010366e:	83 c4 10             	add    $0x10,%esp
f0103671:	83 ec 0c             	sub    $0xc,%esp
f0103674:	6a 00                	push   $0x0
f0103676:	e8 12 d0 ff ff       	call   f010068d <iscons>
f010367b:	89 c7                	mov    %eax,%edi
f010367d:	83 c4 10             	add    $0x10,%esp
f0103680:	be 00 00 00 00       	mov    $0x0,%esi
f0103685:	eb 75                	jmp    f01036fc <readline+0xac>
f0103687:	83 ec 08             	sub    $0x8,%esp
f010368a:	50                   	push   %eax
f010368b:	68 ac 56 10 f0       	push   $0xf01056ac
f0103690:	e8 99 f6 ff ff       	call   f0102d2e <cprintf>
f0103695:	83 c4 10             	add    $0x10,%esp
f0103698:	b8 00 00 00 00       	mov    $0x0,%eax
f010369d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01036a0:	5b                   	pop    %ebx
f01036a1:	5e                   	pop    %esi
f01036a2:	5f                   	pop    %edi
f01036a3:	5d                   	pop    %ebp
f01036a4:	c3                   	ret    
f01036a5:	83 ec 0c             	sub    $0xc,%esp
f01036a8:	6a 08                	push   $0x8
f01036aa:	e8 bd cf ff ff       	call   f010066c <cputchar>
f01036af:	83 c4 10             	add    $0x10,%esp
f01036b2:	eb 47                	jmp    f01036fb <readline+0xab>
f01036b4:	83 ec 0c             	sub    $0xc,%esp
f01036b7:	53                   	push   %ebx
f01036b8:	e8 af cf ff ff       	call   f010066c <cputchar>
f01036bd:	83 c4 10             	add    $0x10,%esp
f01036c0:	eb 60                	jmp    f0103722 <readline+0xd2>
f01036c2:	83 f8 0a             	cmp    $0xa,%eax
f01036c5:	74 05                	je     f01036cc <readline+0x7c>
f01036c7:	83 f8 0d             	cmp    $0xd,%eax
f01036ca:	75 30                	jne    f01036fc <readline+0xac>
f01036cc:	85 ff                	test   %edi,%edi
f01036ce:	75 0e                	jne    f01036de <readline+0x8e>
f01036d0:	c6 86 80 95 11 f0 00 	movb   $0x0,-0xfee6a80(%esi)
f01036d7:	b8 80 95 11 f0       	mov    $0xf0119580,%eax
f01036dc:	eb bf                	jmp    f010369d <readline+0x4d>
f01036de:	83 ec 0c             	sub    $0xc,%esp
f01036e1:	6a 0a                	push   $0xa
f01036e3:	e8 84 cf ff ff       	call   f010066c <cputchar>
f01036e8:	83 c4 10             	add    $0x10,%esp
f01036eb:	eb e3                	jmp    f01036d0 <readline+0x80>
f01036ed:	85 f6                	test   %esi,%esi
f01036ef:	7f 06                	jg     f01036f7 <readline+0xa7>
f01036f1:	eb 23                	jmp    f0103716 <readline+0xc6>
f01036f3:	85 f6                	test   %esi,%esi
f01036f5:	7e 05                	jle    f01036fc <readline+0xac>
f01036f7:	85 ff                	test   %edi,%edi
f01036f9:	75 aa                	jne    f01036a5 <readline+0x55>
f01036fb:	4e                   	dec    %esi
f01036fc:	e8 7b cf ff ff       	call   f010067c <getchar>
f0103701:	89 c3                	mov    %eax,%ebx
f0103703:	85 c0                	test   %eax,%eax
f0103705:	78 80                	js     f0103687 <readline+0x37>
f0103707:	83 f8 08             	cmp    $0x8,%eax
f010370a:	74 e7                	je     f01036f3 <readline+0xa3>
f010370c:	83 f8 7f             	cmp    $0x7f,%eax
f010370f:	74 dc                	je     f01036ed <readline+0x9d>
f0103711:	83 f8 1f             	cmp    $0x1f,%eax
f0103714:	7e ac                	jle    f01036c2 <readline+0x72>
f0103716:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f010371c:	7f de                	jg     f01036fc <readline+0xac>
f010371e:	85 ff                	test   %edi,%edi
f0103720:	75 92                	jne    f01036b4 <readline+0x64>
f0103722:	88 9e 80 95 11 f0    	mov    %bl,-0xfee6a80(%esi)
f0103728:	8d 76 01             	lea    0x1(%esi),%esi
f010372b:	eb cf                	jmp    f01036fc <readline+0xac>

f010372d <strlen>:
f010372d:	55                   	push   %ebp
f010372e:	89 e5                	mov    %esp,%ebp
f0103730:	8b 55 08             	mov    0x8(%ebp),%edx
f0103733:	b8 00 00 00 00       	mov    $0x0,%eax
f0103738:	eb 01                	jmp    f010373b <strlen+0xe>
f010373a:	40                   	inc    %eax
f010373b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010373f:	75 f9                	jne    f010373a <strlen+0xd>
f0103741:	5d                   	pop    %ebp
f0103742:	c3                   	ret    

f0103743 <strnlen>:
f0103743:	55                   	push   %ebp
f0103744:	89 e5                	mov    %esp,%ebp
f0103746:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103749:	8b 55 0c             	mov    0xc(%ebp),%edx
f010374c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103751:	eb 01                	jmp    f0103754 <strnlen+0x11>
f0103753:	40                   	inc    %eax
f0103754:	39 d0                	cmp    %edx,%eax
f0103756:	74 08                	je     f0103760 <strnlen+0x1d>
f0103758:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010375c:	75 f5                	jne    f0103753 <strnlen+0x10>
f010375e:	89 c2                	mov    %eax,%edx
f0103760:	89 d0                	mov    %edx,%eax
f0103762:	5d                   	pop    %ebp
f0103763:	c3                   	ret    

f0103764 <strcpy>:
f0103764:	55                   	push   %ebp
f0103765:	89 e5                	mov    %esp,%ebp
f0103767:	53                   	push   %ebx
f0103768:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010376b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010376e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103773:	8a 14 03             	mov    (%ebx,%eax,1),%dl
f0103776:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0103779:	40                   	inc    %eax
f010377a:	84 d2                	test   %dl,%dl
f010377c:	75 f5                	jne    f0103773 <strcpy+0xf>
f010377e:	89 c8                	mov    %ecx,%eax
f0103780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103783:	c9                   	leave  
f0103784:	c3                   	ret    

f0103785 <strcat>:
f0103785:	55                   	push   %ebp
f0103786:	89 e5                	mov    %esp,%ebp
f0103788:	53                   	push   %ebx
f0103789:	83 ec 10             	sub    $0x10,%esp
f010378c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010378f:	53                   	push   %ebx
f0103790:	e8 98 ff ff ff       	call   f010372d <strlen>
f0103795:	83 c4 08             	add    $0x8,%esp
f0103798:	ff 75 0c             	push   0xc(%ebp)
f010379b:	01 d8                	add    %ebx,%eax
f010379d:	50                   	push   %eax
f010379e:	e8 c1 ff ff ff       	call   f0103764 <strcpy>
f01037a3:	89 d8                	mov    %ebx,%eax
f01037a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01037a8:	c9                   	leave  
f01037a9:	c3                   	ret    

f01037aa <strncpy>:
f01037aa:	55                   	push   %ebp
f01037ab:	89 e5                	mov    %esp,%ebp
f01037ad:	53                   	push   %ebx
f01037ae:	8b 55 0c             	mov    0xc(%ebp),%edx
f01037b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01037b4:	03 5d 10             	add    0x10(%ebp),%ebx
f01037b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01037ba:	eb 0c                	jmp    f01037c8 <strncpy+0x1e>
f01037bc:	40                   	inc    %eax
f01037bd:	8a 0a                	mov    (%edx),%cl
f01037bf:	88 48 ff             	mov    %cl,-0x1(%eax)
f01037c2:	80 f9 01             	cmp    $0x1,%cl
f01037c5:	83 da ff             	sbb    $0xffffffff,%edx
f01037c8:	39 d8                	cmp    %ebx,%eax
f01037ca:	75 f0                	jne    f01037bc <strncpy+0x12>
f01037cc:	8b 45 08             	mov    0x8(%ebp),%eax
f01037cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01037d2:	c9                   	leave  
f01037d3:	c3                   	ret    

f01037d4 <strlcpy>:
f01037d4:	55                   	push   %ebp
f01037d5:	89 e5                	mov    %esp,%ebp
f01037d7:	56                   	push   %esi
f01037d8:	53                   	push   %ebx
f01037d9:	8b 75 08             	mov    0x8(%ebp),%esi
f01037dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01037df:	8b 45 10             	mov    0x10(%ebp),%eax
f01037e2:	85 c0                	test   %eax,%eax
f01037e4:	74 22                	je     f0103808 <strlcpy+0x34>
f01037e6:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
f01037ea:	89 f2                	mov    %esi,%edx
f01037ec:	eb 05                	jmp    f01037f3 <strlcpy+0x1f>
f01037ee:	41                   	inc    %ecx
f01037ef:	42                   	inc    %edx
f01037f0:	88 5a ff             	mov    %bl,-0x1(%edx)
f01037f3:	39 c2                	cmp    %eax,%edx
f01037f5:	74 08                	je     f01037ff <strlcpy+0x2b>
f01037f7:	8a 19                	mov    (%ecx),%bl
f01037f9:	84 db                	test   %bl,%bl
f01037fb:	75 f1                	jne    f01037ee <strlcpy+0x1a>
f01037fd:	89 d0                	mov    %edx,%eax
f01037ff:	c6 00 00             	movb   $0x0,(%eax)
f0103802:	29 f0                	sub    %esi,%eax
f0103804:	5b                   	pop    %ebx
f0103805:	5e                   	pop    %esi
f0103806:	5d                   	pop    %ebp
f0103807:	c3                   	ret    
f0103808:	89 f0                	mov    %esi,%eax
f010380a:	eb f6                	jmp    f0103802 <strlcpy+0x2e>

f010380c <strcmp>:
f010380c:	55                   	push   %ebp
f010380d:	89 e5                	mov    %esp,%ebp
f010380f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103812:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103815:	eb 02                	jmp    f0103819 <strcmp+0xd>
f0103817:	41                   	inc    %ecx
f0103818:	42                   	inc    %edx
f0103819:	8a 01                	mov    (%ecx),%al
f010381b:	84 c0                	test   %al,%al
f010381d:	74 04                	je     f0103823 <strcmp+0x17>
f010381f:	3a 02                	cmp    (%edx),%al
f0103821:	74 f4                	je     f0103817 <strcmp+0xb>
f0103823:	0f b6 c0             	movzbl %al,%eax
f0103826:	0f b6 12             	movzbl (%edx),%edx
f0103829:	29 d0                	sub    %edx,%eax
f010382b:	5d                   	pop    %ebp
f010382c:	c3                   	ret    

f010382d <strncmp>:
f010382d:	55                   	push   %ebp
f010382e:	89 e5                	mov    %esp,%ebp
f0103830:	53                   	push   %ebx
f0103831:	8b 45 08             	mov    0x8(%ebp),%eax
f0103834:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103837:	89 c3                	mov    %eax,%ebx
f0103839:	03 5d 10             	add    0x10(%ebp),%ebx
f010383c:	eb 02                	jmp    f0103840 <strncmp+0x13>
f010383e:	40                   	inc    %eax
f010383f:	42                   	inc    %edx
f0103840:	39 d8                	cmp    %ebx,%eax
f0103842:	74 17                	je     f010385b <strncmp+0x2e>
f0103844:	8a 08                	mov    (%eax),%cl
f0103846:	84 c9                	test   %cl,%cl
f0103848:	74 04                	je     f010384e <strncmp+0x21>
f010384a:	3a 0a                	cmp    (%edx),%cl
f010384c:	74 f0                	je     f010383e <strncmp+0x11>
f010384e:	0f b6 00             	movzbl (%eax),%eax
f0103851:	0f b6 12             	movzbl (%edx),%edx
f0103854:	29 d0                	sub    %edx,%eax
f0103856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103859:	c9                   	leave  
f010385a:	c3                   	ret    
f010385b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103860:	eb f4                	jmp    f0103856 <strncmp+0x29>

f0103862 <strchr>:
f0103862:	55                   	push   %ebp
f0103863:	89 e5                	mov    %esp,%ebp
f0103865:	8b 45 08             	mov    0x8(%ebp),%eax
f0103868:	8a 4d 0c             	mov    0xc(%ebp),%cl
f010386b:	eb 01                	jmp    f010386e <strchr+0xc>
f010386d:	40                   	inc    %eax
f010386e:	8a 10                	mov    (%eax),%dl
f0103870:	84 d2                	test   %dl,%dl
f0103872:	74 06                	je     f010387a <strchr+0x18>
f0103874:	38 ca                	cmp    %cl,%dl
f0103876:	75 f5                	jne    f010386d <strchr+0xb>
f0103878:	eb 05                	jmp    f010387f <strchr+0x1d>
f010387a:	b8 00 00 00 00       	mov    $0x0,%eax
f010387f:	5d                   	pop    %ebp
f0103880:	c3                   	ret    

f0103881 <strfind>:
f0103881:	55                   	push   %ebp
f0103882:	89 e5                	mov    %esp,%ebp
f0103884:	8b 45 08             	mov    0x8(%ebp),%eax
f0103887:	8a 4d 0c             	mov    0xc(%ebp),%cl
f010388a:	eb 01                	jmp    f010388d <strfind+0xc>
f010388c:	40                   	inc    %eax
f010388d:	8a 10                	mov    (%eax),%dl
f010388f:	84 d2                	test   %dl,%dl
f0103891:	74 04                	je     f0103897 <strfind+0x16>
f0103893:	38 ca                	cmp    %cl,%dl
f0103895:	75 f5                	jne    f010388c <strfind+0xb>
f0103897:	5d                   	pop    %ebp
f0103898:	c3                   	ret    

f0103899 <memset>:
f0103899:	55                   	push   %ebp
f010389a:	89 e5                	mov    %esp,%ebp
f010389c:	57                   	push   %edi
f010389d:	56                   	push   %esi
f010389e:	53                   	push   %ebx
f010389f:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01038a2:	85 c9                	test   %ecx,%ecx
f01038a4:	74 36                	je     f01038dc <memset+0x43>
f01038a6:	89 c8                	mov    %ecx,%eax
f01038a8:	0b 45 08             	or     0x8(%ebp),%eax
f01038ab:	a8 03                	test   $0x3,%al
f01038ad:	75 24                	jne    f01038d3 <memset+0x3a>
f01038af:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
f01038b3:	89 d8                	mov    %ebx,%eax
f01038b5:	c1 e0 08             	shl    $0x8,%eax
f01038b8:	89 da                	mov    %ebx,%edx
f01038ba:	c1 e2 18             	shl    $0x18,%edx
f01038bd:	89 de                	mov    %ebx,%esi
f01038bf:	c1 e6 10             	shl    $0x10,%esi
f01038c2:	09 f2                	or     %esi,%edx
f01038c4:	09 da                	or     %ebx,%edx
f01038c6:	09 d0                	or     %edx,%eax
f01038c8:	c1 e9 02             	shr    $0x2,%ecx
f01038cb:	8b 7d 08             	mov    0x8(%ebp),%edi
f01038ce:	fc                   	cld    
f01038cf:	f3 ab                	rep stos %eax,%es:(%edi)
f01038d1:	eb 09                	jmp    f01038dc <memset+0x43>
f01038d3:	8b 7d 08             	mov    0x8(%ebp),%edi
f01038d6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01038d9:	fc                   	cld    
f01038da:	f3 aa                	rep stos %al,%es:(%edi)
f01038dc:	8b 45 08             	mov    0x8(%ebp),%eax
f01038df:	5b                   	pop    %ebx
f01038e0:	5e                   	pop    %esi
f01038e1:	5f                   	pop    %edi
f01038e2:	5d                   	pop    %ebp
f01038e3:	c3                   	ret    

f01038e4 <memmove>:
f01038e4:	55                   	push   %ebp
f01038e5:	89 e5                	mov    %esp,%ebp
f01038e7:	57                   	push   %edi
f01038e8:	56                   	push   %esi
f01038e9:	8b 45 08             	mov    0x8(%ebp),%eax
f01038ec:	8b 75 0c             	mov    0xc(%ebp),%esi
f01038ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01038f2:	39 c6                	cmp    %eax,%esi
f01038f4:	73 30                	jae    f0103926 <memmove+0x42>
f01038f6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01038f9:	39 c2                	cmp    %eax,%edx
f01038fb:	76 29                	jbe    f0103926 <memmove+0x42>
f01038fd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0103900:	89 d6                	mov    %edx,%esi
f0103902:	09 fe                	or     %edi,%esi
f0103904:	09 ce                	or     %ecx,%esi
f0103906:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010390c:	75 0e                	jne    f010391c <memmove+0x38>
f010390e:	83 ef 04             	sub    $0x4,%edi
f0103911:	8d 72 fc             	lea    -0x4(%edx),%esi
f0103914:	c1 e9 02             	shr    $0x2,%ecx
f0103917:	fd                   	std    
f0103918:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010391a:	eb 07                	jmp    f0103923 <memmove+0x3f>
f010391c:	4f                   	dec    %edi
f010391d:	8d 72 ff             	lea    -0x1(%edx),%esi
f0103920:	fd                   	std    
f0103921:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0103923:	fc                   	cld    
f0103924:	eb 1a                	jmp    f0103940 <memmove+0x5c>
f0103926:	89 f2                	mov    %esi,%edx
f0103928:	09 c2                	or     %eax,%edx
f010392a:	09 ca                	or     %ecx,%edx
f010392c:	f6 c2 03             	test   $0x3,%dl
f010392f:	75 0a                	jne    f010393b <memmove+0x57>
f0103931:	c1 e9 02             	shr    $0x2,%ecx
f0103934:	89 c7                	mov    %eax,%edi
f0103936:	fc                   	cld    
f0103937:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103939:	eb 05                	jmp    f0103940 <memmove+0x5c>
f010393b:	89 c7                	mov    %eax,%edi
f010393d:	fc                   	cld    
f010393e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0103940:	5e                   	pop    %esi
f0103941:	5f                   	pop    %edi
f0103942:	5d                   	pop    %ebp
f0103943:	c3                   	ret    

f0103944 <memcpy>:
f0103944:	55                   	push   %ebp
f0103945:	89 e5                	mov    %esp,%ebp
f0103947:	83 ec 0c             	sub    $0xc,%esp
f010394a:	ff 75 10             	push   0x10(%ebp)
f010394d:	ff 75 0c             	push   0xc(%ebp)
f0103950:	ff 75 08             	push   0x8(%ebp)
f0103953:	e8 8c ff ff ff       	call   f01038e4 <memmove>
f0103958:	c9                   	leave  
f0103959:	c3                   	ret    

f010395a <memcmp>:
f010395a:	55                   	push   %ebp
f010395b:	89 e5                	mov    %esp,%ebp
f010395d:	56                   	push   %esi
f010395e:	53                   	push   %ebx
f010395f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103962:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103965:	89 c6                	mov    %eax,%esi
f0103967:	03 75 10             	add    0x10(%ebp),%esi
f010396a:	eb 02                	jmp    f010396e <memcmp+0x14>
f010396c:	40                   	inc    %eax
f010396d:	42                   	inc    %edx
f010396e:	39 f0                	cmp    %esi,%eax
f0103970:	74 12                	je     f0103984 <memcmp+0x2a>
f0103972:	8a 08                	mov    (%eax),%cl
f0103974:	8a 1a                	mov    (%edx),%bl
f0103976:	38 d9                	cmp    %bl,%cl
f0103978:	74 f2                	je     f010396c <memcmp+0x12>
f010397a:	0f b6 c1             	movzbl %cl,%eax
f010397d:	0f b6 db             	movzbl %bl,%ebx
f0103980:	29 d8                	sub    %ebx,%eax
f0103982:	eb 05                	jmp    f0103989 <memcmp+0x2f>
f0103984:	b8 00 00 00 00       	mov    $0x0,%eax
f0103989:	5b                   	pop    %ebx
f010398a:	5e                   	pop    %esi
f010398b:	5d                   	pop    %ebp
f010398c:	c3                   	ret    

f010398d <memfind>:
f010398d:	55                   	push   %ebp
f010398e:	89 e5                	mov    %esp,%ebp
f0103990:	8b 45 08             	mov    0x8(%ebp),%eax
f0103993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103996:	89 c2                	mov    %eax,%edx
f0103998:	03 55 10             	add    0x10(%ebp),%edx
f010399b:	eb 01                	jmp    f010399e <memfind+0x11>
f010399d:	40                   	inc    %eax
f010399e:	39 d0                	cmp    %edx,%eax
f01039a0:	73 04                	jae    f01039a6 <memfind+0x19>
f01039a2:	38 08                	cmp    %cl,(%eax)
f01039a4:	75 f7                	jne    f010399d <memfind+0x10>
f01039a6:	5d                   	pop    %ebp
f01039a7:	c3                   	ret    

f01039a8 <strtol>:
f01039a8:	55                   	push   %ebp
f01039a9:	89 e5                	mov    %esp,%ebp
f01039ab:	57                   	push   %edi
f01039ac:	56                   	push   %esi
f01039ad:	53                   	push   %ebx
f01039ae:	8b 55 08             	mov    0x8(%ebp),%edx
f01039b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01039b4:	eb 01                	jmp    f01039b7 <strtol+0xf>
f01039b6:	42                   	inc    %edx
f01039b7:	8a 02                	mov    (%edx),%al
f01039b9:	3c 20                	cmp    $0x20,%al
f01039bb:	74 f9                	je     f01039b6 <strtol+0xe>
f01039bd:	3c 09                	cmp    $0x9,%al
f01039bf:	74 f5                	je     f01039b6 <strtol+0xe>
f01039c1:	3c 2b                	cmp    $0x2b,%al
f01039c3:	74 24                	je     f01039e9 <strtol+0x41>
f01039c5:	3c 2d                	cmp    $0x2d,%al
f01039c7:	74 28                	je     f01039f1 <strtol+0x49>
f01039c9:	bf 00 00 00 00       	mov    $0x0,%edi
f01039ce:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01039d4:	75 09                	jne    f01039df <strtol+0x37>
f01039d6:	80 3a 30             	cmpb   $0x30,(%edx)
f01039d9:	74 1e                	je     f01039f9 <strtol+0x51>
f01039db:	85 db                	test   %ebx,%ebx
f01039dd:	74 36                	je     f0103a15 <strtol+0x6d>
f01039df:	b9 00 00 00 00       	mov    $0x0,%ecx
f01039e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01039e7:	eb 45                	jmp    f0103a2e <strtol+0x86>
f01039e9:	42                   	inc    %edx
f01039ea:	bf 00 00 00 00       	mov    $0x0,%edi
f01039ef:	eb dd                	jmp    f01039ce <strtol+0x26>
f01039f1:	42                   	inc    %edx
f01039f2:	bf 01 00 00 00       	mov    $0x1,%edi
f01039f7:	eb d5                	jmp    f01039ce <strtol+0x26>
f01039f9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01039fd:	74 0c                	je     f0103a0b <strtol+0x63>
f01039ff:	85 db                	test   %ebx,%ebx
f0103a01:	75 dc                	jne    f01039df <strtol+0x37>
f0103a03:	42                   	inc    %edx
f0103a04:	bb 08 00 00 00       	mov    $0x8,%ebx
f0103a09:	eb d4                	jmp    f01039df <strtol+0x37>
f0103a0b:	83 c2 02             	add    $0x2,%edx
f0103a0e:	bb 10 00 00 00       	mov    $0x10,%ebx
f0103a13:	eb ca                	jmp    f01039df <strtol+0x37>
f0103a15:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0103a1a:	eb c3                	jmp    f01039df <strtol+0x37>
f0103a1c:	0f be c0             	movsbl %al,%eax
f0103a1f:	83 e8 30             	sub    $0x30,%eax
f0103a22:	3b 45 10             	cmp    0x10(%ebp),%eax
f0103a25:	7d 37                	jge    f0103a5e <strtol+0xb6>
f0103a27:	42                   	inc    %edx
f0103a28:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0103a2c:	01 c1                	add    %eax,%ecx
f0103a2e:	8a 02                	mov    (%edx),%al
f0103a30:	8d 70 d0             	lea    -0x30(%eax),%esi
f0103a33:	89 f3                	mov    %esi,%ebx
f0103a35:	80 fb 09             	cmp    $0x9,%bl
f0103a38:	76 e2                	jbe    f0103a1c <strtol+0x74>
f0103a3a:	8d 70 9f             	lea    -0x61(%eax),%esi
f0103a3d:	89 f3                	mov    %esi,%ebx
f0103a3f:	80 fb 19             	cmp    $0x19,%bl
f0103a42:	77 08                	ja     f0103a4c <strtol+0xa4>
f0103a44:	0f be c0             	movsbl %al,%eax
f0103a47:	83 e8 57             	sub    $0x57,%eax
f0103a4a:	eb d6                	jmp    f0103a22 <strtol+0x7a>
f0103a4c:	8d 70 bf             	lea    -0x41(%eax),%esi
f0103a4f:	89 f3                	mov    %esi,%ebx
f0103a51:	80 fb 19             	cmp    $0x19,%bl
f0103a54:	77 08                	ja     f0103a5e <strtol+0xb6>
f0103a56:	0f be c0             	movsbl %al,%eax
f0103a59:	83 e8 37             	sub    $0x37,%eax
f0103a5c:	eb c4                	jmp    f0103a22 <strtol+0x7a>
f0103a5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0103a62:	74 05                	je     f0103a69 <strtol+0xc1>
f0103a64:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103a67:	89 10                	mov    %edx,(%eax)
f0103a69:	85 ff                	test   %edi,%edi
f0103a6b:	74 02                	je     f0103a6f <strtol+0xc7>
f0103a6d:	f7 d9                	neg    %ecx
f0103a6f:	89 c8                	mov    %ecx,%eax
f0103a71:	5b                   	pop    %ebx
f0103a72:	5e                   	pop    %esi
f0103a73:	5f                   	pop    %edi
f0103a74:	5d                   	pop    %ebp
f0103a75:	c3                   	ret    
f0103a76:	66 90                	xchg   %ax,%ax

f0103a78 <__udivdi3>:
f0103a78:	55                   	push   %ebp
f0103a79:	89 e5                	mov    %esp,%ebp
f0103a7b:	57                   	push   %edi
f0103a7c:	56                   	push   %esi
f0103a7d:	53                   	push   %ebx
f0103a7e:	83 ec 1c             	sub    $0x1c,%esp
f0103a81:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0103a87:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103a8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0103a8d:	8b 45 14             	mov    0x14(%ebp),%eax
f0103a90:	85 c0                	test   %eax,%eax
f0103a92:	75 18                	jne    f0103aac <__udivdi3+0x34>
f0103a94:	39 f3                	cmp    %esi,%ebx
f0103a96:	76 44                	jbe    f0103adc <__udivdi3+0x64>
f0103a98:	89 f8                	mov    %edi,%eax
f0103a9a:	89 f2                	mov    %esi,%edx
f0103a9c:	f7 f3                	div    %ebx
f0103a9e:	31 ff                	xor    %edi,%edi
f0103aa0:	89 fa                	mov    %edi,%edx
f0103aa2:	83 c4 1c             	add    $0x1c,%esp
f0103aa5:	5b                   	pop    %ebx
f0103aa6:	5e                   	pop    %esi
f0103aa7:	5f                   	pop    %edi
f0103aa8:	5d                   	pop    %ebp
f0103aa9:	c3                   	ret    
f0103aaa:	66 90                	xchg   %ax,%ax
f0103aac:	39 f0                	cmp    %esi,%eax
f0103aae:	76 10                	jbe    f0103ac0 <__udivdi3+0x48>
f0103ab0:	31 ff                	xor    %edi,%edi
f0103ab2:	31 c0                	xor    %eax,%eax
f0103ab4:	89 fa                	mov    %edi,%edx
f0103ab6:	83 c4 1c             	add    $0x1c,%esp
f0103ab9:	5b                   	pop    %ebx
f0103aba:	5e                   	pop    %esi
f0103abb:	5f                   	pop    %edi
f0103abc:	5d                   	pop    %ebp
f0103abd:	c3                   	ret    
f0103abe:	66 90                	xchg   %ax,%ax
f0103ac0:	0f bd f8             	bsr    %eax,%edi
f0103ac3:	83 f7 1f             	xor    $0x1f,%edi
f0103ac6:	75 40                	jne    f0103b08 <__udivdi3+0x90>
f0103ac8:	39 f0                	cmp    %esi,%eax
f0103aca:	72 09                	jb     f0103ad5 <__udivdi3+0x5d>
f0103acc:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103acf:	0f 87 a3 00 00 00    	ja     f0103b78 <__udivdi3+0x100>
f0103ad5:	b8 01 00 00 00       	mov    $0x1,%eax
f0103ada:	eb d8                	jmp    f0103ab4 <__udivdi3+0x3c>
f0103adc:	89 d9                	mov    %ebx,%ecx
f0103ade:	85 db                	test   %ebx,%ebx
f0103ae0:	75 0b                	jne    f0103aed <__udivdi3+0x75>
f0103ae2:	b8 01 00 00 00       	mov    $0x1,%eax
f0103ae7:	31 d2                	xor    %edx,%edx
f0103ae9:	f7 f3                	div    %ebx
f0103aeb:	89 c1                	mov    %eax,%ecx
f0103aed:	31 d2                	xor    %edx,%edx
f0103aef:	89 f0                	mov    %esi,%eax
f0103af1:	f7 f1                	div    %ecx
f0103af3:	89 c6                	mov    %eax,%esi
f0103af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103af8:	f7 f1                	div    %ecx
f0103afa:	89 f7                	mov    %esi,%edi
f0103afc:	89 fa                	mov    %edi,%edx
f0103afe:	83 c4 1c             	add    $0x1c,%esp
f0103b01:	5b                   	pop    %ebx
f0103b02:	5e                   	pop    %esi
f0103b03:	5f                   	pop    %edi
f0103b04:	5d                   	pop    %ebp
f0103b05:	c3                   	ret    
f0103b06:	66 90                	xchg   %ax,%ax
f0103b08:	ba 20 00 00 00       	mov    $0x20,%edx
f0103b0d:	29 fa                	sub    %edi,%edx
f0103b0f:	89 f9                	mov    %edi,%ecx
f0103b11:	d3 e0                	shl    %cl,%eax
f0103b13:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103b16:	89 d8                	mov    %ebx,%eax
f0103b18:	88 d1                	mov    %dl,%cl
f0103b1a:	d3 e8                	shr    %cl,%eax
f0103b1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103b1f:	09 c1                	or     %eax,%ecx
f0103b21:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0103b24:	89 f9                	mov    %edi,%ecx
f0103b26:	d3 e3                	shl    %cl,%ebx
f0103b28:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f0103b2b:	89 f0                	mov    %esi,%eax
f0103b2d:	88 d1                	mov    %dl,%cl
f0103b2f:	d3 e8                	shr    %cl,%eax
f0103b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103b34:	89 f9                	mov    %edi,%ecx
f0103b36:	d3 e6                	shl    %cl,%esi
f0103b38:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0103b3b:	88 d1                	mov    %dl,%cl
f0103b3d:	d3 eb                	shr    %cl,%ebx
f0103b3f:	89 d8                	mov    %ebx,%eax
f0103b41:	09 f0                	or     %esi,%eax
f0103b43:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103b46:	f7 75 e0             	divl   -0x20(%ebp)
f0103b49:	89 d1                	mov    %edx,%ecx
f0103b4b:	89 c3                	mov    %eax,%ebx
f0103b4d:	f7 65 dc             	mull   -0x24(%ebp)
f0103b50:	39 d1                	cmp    %edx,%ecx
f0103b52:	72 18                	jb     f0103b6c <__udivdi3+0xf4>
f0103b54:	74 0a                	je     f0103b60 <__udivdi3+0xe8>
f0103b56:	89 d8                	mov    %ebx,%eax
f0103b58:	31 ff                	xor    %edi,%edi
f0103b5a:	e9 55 ff ff ff       	jmp    f0103ab4 <__udivdi3+0x3c>
f0103b5f:	90                   	nop
f0103b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103b63:	89 f9                	mov    %edi,%ecx
f0103b65:	d3 e2                	shl    %cl,%edx
f0103b67:	39 c2                	cmp    %eax,%edx
f0103b69:	73 eb                	jae    f0103b56 <__udivdi3+0xde>
f0103b6b:	90                   	nop
f0103b6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0103b6f:	31 ff                	xor    %edi,%edi
f0103b71:	e9 3e ff ff ff       	jmp    f0103ab4 <__udivdi3+0x3c>
f0103b76:	66 90                	xchg   %ax,%ax
f0103b78:	31 c0                	xor    %eax,%eax
f0103b7a:	e9 35 ff ff ff       	jmp    f0103ab4 <__udivdi3+0x3c>
f0103b7f:	90                   	nop

f0103b80 <__umoddi3>:
f0103b80:	55                   	push   %ebp
f0103b81:	89 e5                	mov    %esp,%ebp
f0103b83:	57                   	push   %edi
f0103b84:	56                   	push   %esi
f0103b85:	53                   	push   %ebx
f0103b86:	83 ec 1c             	sub    $0x1c,%esp
f0103b89:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103b8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103b8f:	8b 75 10             	mov    0x10(%ebp),%esi
f0103b92:	8b 45 14             	mov    0x14(%ebp),%eax
f0103b95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0103b98:	89 da                	mov    %ebx,%edx
f0103b9a:	85 c0                	test   %eax,%eax
f0103b9c:	75 16                	jne    f0103bb4 <__umoddi3+0x34>
f0103b9e:	39 de                	cmp    %ebx,%esi
f0103ba0:	76 4e                	jbe    f0103bf0 <__umoddi3+0x70>
f0103ba2:	89 f8                	mov    %edi,%eax
f0103ba4:	f7 f6                	div    %esi
f0103ba6:	89 d0                	mov    %edx,%eax
f0103ba8:	31 d2                	xor    %edx,%edx
f0103baa:	83 c4 1c             	add    $0x1c,%esp
f0103bad:	5b                   	pop    %ebx
f0103bae:	5e                   	pop    %esi
f0103baf:	5f                   	pop    %edi
f0103bb0:	5d                   	pop    %ebp
f0103bb1:	c3                   	ret    
f0103bb2:	66 90                	xchg   %ax,%ax
f0103bb4:	39 d8                	cmp    %ebx,%eax
f0103bb6:	76 0c                	jbe    f0103bc4 <__umoddi3+0x44>
f0103bb8:	89 f8                	mov    %edi,%eax
f0103bba:	83 c4 1c             	add    $0x1c,%esp
f0103bbd:	5b                   	pop    %ebx
f0103bbe:	5e                   	pop    %esi
f0103bbf:	5f                   	pop    %edi
f0103bc0:	5d                   	pop    %ebp
f0103bc1:	c3                   	ret    
f0103bc2:	66 90                	xchg   %ax,%ax
f0103bc4:	0f bd c8             	bsr    %eax,%ecx
f0103bc7:	83 f1 1f             	xor    $0x1f,%ecx
f0103bca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0103bcd:	75 41                	jne    f0103c10 <__umoddi3+0x90>
f0103bcf:	39 d8                	cmp    %ebx,%eax
f0103bd1:	72 04                	jb     f0103bd7 <__umoddi3+0x57>
f0103bd3:	39 fe                	cmp    %edi,%esi
f0103bd5:	77 0d                	ja     f0103be4 <__umoddi3+0x64>
f0103bd7:	89 d9                	mov    %ebx,%ecx
f0103bd9:	89 fa                	mov    %edi,%edx
f0103bdb:	29 f2                	sub    %esi,%edx
f0103bdd:	19 c1                	sbb    %eax,%ecx
f0103bdf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103be2:	89 ca                	mov    %ecx,%edx
f0103be4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103be7:	83 c4 1c             	add    $0x1c,%esp
f0103bea:	5b                   	pop    %ebx
f0103beb:	5e                   	pop    %esi
f0103bec:	5f                   	pop    %edi
f0103bed:	5d                   	pop    %ebp
f0103bee:	c3                   	ret    
f0103bef:	90                   	nop
f0103bf0:	89 f1                	mov    %esi,%ecx
f0103bf2:	85 f6                	test   %esi,%esi
f0103bf4:	75 0b                	jne    f0103c01 <__umoddi3+0x81>
f0103bf6:	b8 01 00 00 00       	mov    $0x1,%eax
f0103bfb:	31 d2                	xor    %edx,%edx
f0103bfd:	f7 f6                	div    %esi
f0103bff:	89 c1                	mov    %eax,%ecx
f0103c01:	89 d8                	mov    %ebx,%eax
f0103c03:	31 d2                	xor    %edx,%edx
f0103c05:	f7 f1                	div    %ecx
f0103c07:	89 f8                	mov    %edi,%eax
f0103c09:	f7 f1                	div    %ecx
f0103c0b:	eb 99                	jmp    f0103ba6 <__umoddi3+0x26>
f0103c0d:	8d 76 00             	lea    0x0(%esi),%esi
f0103c10:	ba 20 00 00 00       	mov    $0x20,%edx
f0103c15:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103c18:	29 ca                	sub    %ecx,%edx
f0103c1a:	d3 e0                	shl    %cl,%eax
f0103c1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103c1f:	89 f0                	mov    %esi,%eax
f0103c21:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103c24:	88 d1                	mov    %dl,%cl
f0103c26:	d3 e8                	shr    %cl,%eax
f0103c28:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103c2b:	09 c1                	or     %eax,%ecx
f0103c2d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0103c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103c33:	88 c1                	mov    %al,%cl
f0103c35:	d3 e6                	shl    %cl,%esi
f0103c37:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0103c3a:	89 de                	mov    %ebx,%esi
f0103c3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103c3f:	88 d1                	mov    %dl,%cl
f0103c41:	d3 ee                	shr    %cl,%esi
f0103c43:	88 c1                	mov    %al,%cl
f0103c45:	d3 e3                	shl    %cl,%ebx
f0103c47:	89 f8                	mov    %edi,%eax
f0103c49:	88 d1                	mov    %dl,%cl
f0103c4b:	d3 e8                	shr    %cl,%eax
f0103c4d:	09 d8                	or     %ebx,%eax
f0103c4f:	8a 4d e0             	mov    -0x20(%ebp),%cl
f0103c52:	d3 e7                	shl    %cl,%edi
f0103c54:	89 f2                	mov    %esi,%edx
f0103c56:	f7 75 dc             	divl   -0x24(%ebp)
f0103c59:	89 d3                	mov    %edx,%ebx
f0103c5b:	f7 65 d8             	mull   -0x28(%ebp)
f0103c5e:	89 c6                	mov    %eax,%esi
f0103c60:	89 d1                	mov    %edx,%ecx
f0103c62:	39 d3                	cmp    %edx,%ebx
f0103c64:	72 2a                	jb     f0103c90 <__umoddi3+0x110>
f0103c66:	74 24                	je     f0103c8c <__umoddi3+0x10c>
f0103c68:	89 f8                	mov    %edi,%eax
f0103c6a:	29 f0                	sub    %esi,%eax
f0103c6c:	19 cb                	sbb    %ecx,%ebx
f0103c6e:	89 da                	mov    %ebx,%edx
f0103c70:	8a 4d e4             	mov    -0x1c(%ebp),%cl
f0103c73:	d3 e2                	shl    %cl,%edx
f0103c75:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103c78:	89 f9                	mov    %edi,%ecx
f0103c7a:	d3 e8                	shr    %cl,%eax
f0103c7c:	09 d0                	or     %edx,%eax
f0103c7e:	d3 eb                	shr    %cl,%ebx
f0103c80:	89 da                	mov    %ebx,%edx
f0103c82:	83 c4 1c             	add    $0x1c,%esp
f0103c85:	5b                   	pop    %ebx
f0103c86:	5e                   	pop    %esi
f0103c87:	5f                   	pop    %edi
f0103c88:	5d                   	pop    %ebp
f0103c89:	c3                   	ret    
f0103c8a:	66 90                	xchg   %ax,%ax
f0103c8c:	39 c7                	cmp    %eax,%edi
f0103c8e:	73 d8                	jae    f0103c68 <__umoddi3+0xe8>
f0103c90:	2b 45 d8             	sub    -0x28(%ebp),%eax
f0103c93:	1b 55 dc             	sbb    -0x24(%ebp),%edx
f0103c96:	89 d1                	mov    %edx,%ecx
f0103c98:	89 c6                	mov    %eax,%esi
f0103c9a:	eb cc                	jmp    f0103c68 <__umoddi3+0xe8>
