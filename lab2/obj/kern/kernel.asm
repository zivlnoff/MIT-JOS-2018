
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
f0100015:	b8 00 20 11 00       	mov    $0x112000,%eax
f010001a:	0f 22 d8             	mov    %eax,%cr3
f010001d:	0f 20 c0             	mov    %cr0,%eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
f0100025:	0f 22 c0             	mov    %eax,%cr0
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp
f0100034:	bc 00 20 11 f0       	mov    $0xf0112000,%esp
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
f010004b:	68 60 20 10 f0       	push   $0xf0102060
f0100050:	e8 8c 10 00 00       	call   f01010e1 <cprintf>
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
f010006f:	68 7c 20 10 f0       	push   $0xf010207c
f0100074:	e8 68 10 00 00       	call   f01010e1 <cprintf>
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
f010009a:	b8 80 49 11 f0       	mov    $0xf0114980,%eax
f010009f:	2d 00 43 11 f0       	sub    $0xf0114300,%eax
f01000a4:	50                   	push   %eax
f01000a5:	6a 00                	push   $0x0
f01000a7:	68 00 43 11 f0       	push   $0xf0114300
f01000ac:	e8 9b 1b 00 00       	call   f0101c4c <memset>
f01000b1:	e8 ca 04 00 00       	call   f0100580 <cons_init>
f01000b6:	c7 04 24 f0 20 10 f0 	movl   $0xf01020f0,(%esp)
f01000bd:	e8 1f 10 00 00       	call   f01010e1 <cprintf>
f01000c2:	83 c4 08             	add    $0x8,%esp
f01000c5:	68 ac 1a 00 00       	push   $0x1aac
f01000ca:	68 97 20 10 f0       	push   $0xf0102097
f01000cf:	e8 0d 10 00 00       	call   f01010e1 <cprintf>
f01000d4:	c7 45 f4 72 6c 64 00 	movl   $0x646c72,-0xc(%ebp)
f01000db:	83 c4 0c             	add    $0xc,%esp
f01000de:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01000e1:	50                   	push   %eax
f01000e2:	68 10 e1 00 00       	push   $0xe110
f01000e7:	68 b2 20 10 f0       	push   $0xf01020b2
f01000ec:	e8 f0 0f 00 00       	call   f01010e1 <cprintf>
f01000f1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f01000f8:	e8 43 ff ff ff       	call   f0100040 <test_backtrace>
f01000fd:	c7 04 24 60 21 10 f0 	movl   $0xf0102160,(%esp)
f0100104:	e8 d8 0f 00 00       	call   f01010e1 <cprintf>
f0100109:	c7 04 24 d0 21 10 f0 	movl   $0xf01021d0,(%esp)
f0100110:	e8 cc 0f 00 00       	call   f01010e1 <cprintf>
f0100115:	e8 ec 09 00 00       	call   f0100b06 <mem_init>
f010011a:	c7 04 24 3c 22 10 f0 	movl   $0xf010223c,(%esp)
f0100121:	e8 bb 0f 00 00       	call   f01010e1 <cprintf>
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
f010013f:	83 3d 00 43 11 f0 00 	cmpl   $0x0,0xf0114300
f0100146:	74 0f                	je     f0100157 <_panic+0x1f>
f0100148:	83 ec 0c             	sub    $0xc,%esp
f010014b:	6a 00                	push   $0x0
f010014d:	e8 9b 06 00 00       	call   f01007ed <monitor>
f0100152:	83 c4 10             	add    $0x10,%esp
f0100155:	eb f1                	jmp    f0100148 <_panic+0x10>
f0100157:	8b 45 10             	mov    0x10(%ebp),%eax
f010015a:	a3 00 43 11 f0       	mov    %eax,0xf0114300
f010015f:	fa                   	cli    
f0100160:	fc                   	cld    
f0100161:	8d 5d 14             	lea    0x14(%ebp),%ebx
f0100164:	83 ec 04             	sub    $0x4,%esp
f0100167:	ff 75 0c             	push   0xc(%ebp)
f010016a:	ff 75 08             	push   0x8(%ebp)
f010016d:	68 bd 20 10 f0       	push   $0xf01020bd
f0100172:	e8 6a 0f 00 00       	call   f01010e1 <cprintf>
f0100177:	83 c4 08             	add    $0x8,%esp
f010017a:	53                   	push   %ebx
f010017b:	ff 75 10             	push   0x10(%ebp)
f010017e:	e8 38 0f 00 00       	call   f01010bb <vcprintf>
f0100183:	c7 04 24 b3 22 10 f0 	movl   $0xf01022b3,(%esp)
f010018a:	e8 52 0f 00 00       	call   f01010e1 <cprintf>
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
f01001a4:	68 d5 20 10 f0       	push   $0xf01020d5
f01001a9:	e8 33 0f 00 00       	call   f01010e1 <cprintf>
f01001ae:	83 c4 08             	add    $0x8,%esp
f01001b1:	53                   	push   %ebx
f01001b2:	ff 75 10             	push   0x10(%ebp)
f01001b5:	e8 01 0f 00 00       	call   f01010bb <vcprintf>
f01001ba:	c7 04 24 b3 22 10 f0 	movl   $0xf01022b3,(%esp)
f01001c1:	e8 1b 0f 00 00       	call   f01010e1 <cprintf>
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
f01001fc:	8b 0d 44 45 11 f0    	mov    0xf0114544,%ecx
f0100202:	8d 51 01             	lea    0x1(%ecx),%edx
f0100205:	89 15 44 45 11 f0    	mov    %edx,0xf0114544
f010020b:	88 81 40 43 11 f0    	mov    %al,-0xfeebcc0(%ecx)
f0100211:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0100217:	75 d8                	jne    f01001f1 <cons_intr+0x9>
f0100219:	c7 05 44 45 11 f0 00 	movl   $0x0,0xf0114544
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
f0100257:	8b 0d 20 43 11 f0    	mov    0xf0114320,%ecx
f010025d:	f6 c1 40             	test   $0x40,%cl
f0100260:	74 0e                	je     f0100270 <kbd_proc_data+0x46>
f0100262:	83 c8 80             	or     $0xffffff80,%eax
f0100265:	88 c2                	mov    %al,%dl
f0100267:	83 e1 bf             	and    $0xffffffbf,%ecx
f010026a:	89 0d 20 43 11 f0    	mov    %ecx,0xf0114320
f0100270:	0f b6 d2             	movzbl %dl,%edx
f0100273:	0f b6 82 00 24 10 f0 	movzbl -0xfefdc00(%edx),%eax
f010027a:	0b 05 20 43 11 f0    	or     0xf0114320,%eax
f0100280:	0f b6 8a 00 23 10 f0 	movzbl -0xfefdd00(%edx),%ecx
f0100287:	31 c8                	xor    %ecx,%eax
f0100289:	a3 20 43 11 f0       	mov    %eax,0xf0114320
f010028e:	89 c1                	mov    %eax,%ecx
f0100290:	83 e1 03             	and    $0x3,%ecx
f0100293:	8b 0c 8d e0 22 10 f0 	mov    -0xfefdd20(,%ecx,4),%ecx
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
f01002b3:	83 0d 20 43 11 f0 40 	orl    $0x40,0xf0114320
f01002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002bf:	89 d8                	mov    %ebx,%eax
f01002c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002c4:	c9                   	leave  
f01002c5:	c3                   	ret    
f01002c6:	8b 0d 20 43 11 f0    	mov    0xf0114320,%ecx
f01002cc:	f6 c1 40             	test   $0x40,%cl
f01002cf:	75 05                	jne    f01002d6 <kbd_proc_data+0xac>
f01002d1:	83 e0 7f             	and    $0x7f,%eax
f01002d4:	88 c2                	mov    %al,%dl
f01002d6:	0f b6 d2             	movzbl %dl,%edx
f01002d9:	8a 82 00 24 10 f0    	mov    -0xfefdc00(%edx),%al
f01002df:	83 c8 40             	or     $0x40,%eax
f01002e2:	0f b6 c0             	movzbl %al,%eax
f01002e5:	f7 d0                	not    %eax
f01002e7:	21 c8                	and    %ecx,%eax
f01002e9:	a3 20 43 11 f0       	mov    %eax,0xf0114320
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
f0100311:	68 a9 22 10 f0       	push   $0xf01022a9
f0100316:	e8 c6 0d 00 00       	call   f01010e1 <cprintf>
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
f0100409:	66 8b 0d 48 45 11 f0 	mov    0xf0114548,%cx
f0100410:	bb 50 00 00 00       	mov    $0x50,%ebx
f0100415:	89 c8                	mov    %ecx,%eax
f0100417:	ba 00 00 00 00       	mov    $0x0,%edx
f010041c:	66 f7 f3             	div    %bx
f010041f:	29 d1                	sub    %edx,%ecx
f0100421:	66 89 0d 48 45 11 f0 	mov    %cx,0xf0114548
f0100428:	66 81 3d 48 45 11 f0 	cmpw   $0x7cf,0xf0114548
f010042f:	cf 07 
f0100431:	0f 87 8b 00 00 00    	ja     f01004c2 <cons_putc+0x18c>
f0100437:	8b 0d 50 45 11 f0    	mov    0xf0114550,%ecx
f010043d:	b0 0e                	mov    $0xe,%al
f010043f:	89 ca                	mov    %ecx,%edx
f0100441:	ee                   	out    %al,(%dx)
f0100442:	8d 59 01             	lea    0x1(%ecx),%ebx
f0100445:	66 a1 48 45 11 f0    	mov    0xf0114548,%ax
f010044b:	66 c1 e8 08          	shr    $0x8,%ax
f010044f:	89 da                	mov    %ebx,%edx
f0100451:	ee                   	out    %al,(%dx)
f0100452:	b0 0f                	mov    $0xf,%al
f0100454:	89 ca                	mov    %ecx,%edx
f0100456:	ee                   	out    %al,(%dx)
f0100457:	a0 48 45 11 f0       	mov    0xf0114548,%al
f010045c:	89 da                	mov    %ebx,%edx
f010045e:	ee                   	out    %al,(%dx)
f010045f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100462:	5b                   	pop    %ebx
f0100463:	5e                   	pop    %esi
f0100464:	5f                   	pop    %edi
f0100465:	5d                   	pop    %ebp
f0100466:	c3                   	ret    
f0100467:	66 a1 48 45 11 f0    	mov    0xf0114548,%ax
f010046d:	66 85 c0             	test   %ax,%ax
f0100470:	74 c5                	je     f0100437 <cons_putc+0x101>
f0100472:	48                   	dec    %eax
f0100473:	66 a3 48 45 11 f0    	mov    %ax,0xf0114548
f0100479:	0f b7 c0             	movzwl %ax,%eax
f010047c:	89 cf                	mov    %ecx,%edi
f010047e:	81 e7 00 ff ff ff    	and    $0xffffff00,%edi
f0100484:	83 cf 20             	or     $0x20,%edi
f0100487:	8b 15 4c 45 11 f0    	mov    0xf011454c,%edx
f010048d:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100491:	eb 95                	jmp    f0100428 <cons_putc+0xf2>
f0100493:	66 83 05 48 45 11 f0 	addw   $0x50,0xf0114548
f010049a:	50 
f010049b:	e9 69 ff ff ff       	jmp    f0100409 <cons_putc+0xd3>
f01004a0:	66 a1 48 45 11 f0    	mov    0xf0114548,%ax
f01004a6:	8d 50 01             	lea    0x1(%eax),%edx
f01004a9:	66 89 15 48 45 11 f0 	mov    %dx,0xf0114548
f01004b0:	0f b7 c0             	movzwl %ax,%eax
f01004b3:	8b 15 4c 45 11 f0    	mov    0xf011454c,%edx
f01004b9:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01004bd:	e9 66 ff ff ff       	jmp    f0100428 <cons_putc+0xf2>
f01004c2:	a1 4c 45 11 f0       	mov    0xf011454c,%eax
f01004c7:	83 ec 04             	sub    $0x4,%esp
f01004ca:	68 00 0f 00 00       	push   $0xf00
f01004cf:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d5:	52                   	push   %edx
f01004d6:	50                   	push   %eax
f01004d7:	e8 bb 17 00 00       	call   f0101c97 <memmove>
f01004dc:	8b 15 4c 45 11 f0    	mov    0xf011454c,%edx
f01004e2:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004e8:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004ee:	83 c4 10             	add    $0x10,%esp
f01004f1:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01004f6:	83 c0 02             	add    $0x2,%eax
f01004f9:	39 d0                	cmp    %edx,%eax
f01004fb:	75 f4                	jne    f01004f1 <cons_putc+0x1bb>
f01004fd:	66 83 2d 48 45 11 f0 	subw   $0x50,0xf0114548
f0100504:	50 
f0100505:	e9 2d ff ff ff       	jmp    f0100437 <cons_putc+0x101>

f010050a <serial_intr>:
f010050a:	80 3d 54 45 11 f0 00 	cmpb   $0x0,0xf0114554
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
f0100548:	a1 40 45 11 f0       	mov    0xf0114540,%eax
f010054d:	3b 05 44 45 11 f0    	cmp    0xf0114544,%eax
f0100553:	74 24                	je     f0100579 <cons_getc+0x41>
f0100555:	8d 50 01             	lea    0x1(%eax),%edx
f0100558:	89 15 40 45 11 f0    	mov    %edx,0xf0114540
f010055e:	0f b6 80 40 43 11 f0 	movzbl -0xfeebcc0(%eax),%eax
f0100565:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010056b:	75 11                	jne    f010057e <cons_getc+0x46>
f010056d:	c7 05 40 45 11 f0 00 	movl   $0x0,0xf0114540
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
f01005b3:	89 1d 50 45 11 f0    	mov    %ebx,0xf0114550
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
f01005d2:	89 35 4c 45 11 f0    	mov    %esi,0xf011454c
f01005d8:	0f b6 c0             	movzbl %al,%eax
f01005db:	09 c8                	or     %ecx,%eax
f01005dd:	66 a3 48 45 11 f0    	mov    %ax,0xf0114548
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
f0100627:	0f 95 05 54 45 11 f0 	setne  0xf0114554
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
f010065d:	68 b5 22 10 f0       	push   $0xf01022b5
f0100662:	e8 7a 0a 00 00       	call   f01010e1 <cprintf>
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
f0100699:	68 00 25 10 f0       	push   $0xf0102500
f010069e:	68 1e 25 10 f0       	push   $0xf010251e
f01006a3:	68 23 25 10 f0       	push   $0xf0102523
f01006a8:	e8 34 0a 00 00       	call   f01010e1 <cprintf>
f01006ad:	83 c4 0c             	add    $0xc,%esp
f01006b0:	68 c8 25 10 f0       	push   $0xf01025c8
f01006b5:	68 2c 25 10 f0       	push   $0xf010252c
f01006ba:	68 23 25 10 f0       	push   $0xf0102523
f01006bf:	e8 1d 0a 00 00       	call   f01010e1 <cprintf>
f01006c4:	83 c4 0c             	add    $0xc,%esp
f01006c7:	68 35 25 10 f0       	push   $0xf0102535
f01006cc:	68 53 25 10 f0       	push   $0xf0102553
f01006d1:	68 23 25 10 f0       	push   $0xf0102523
f01006d6:	e8 06 0a 00 00       	call   f01010e1 <cprintf>
f01006db:	b8 00 00 00 00       	mov    $0x0,%eax
f01006e0:	c9                   	leave  
f01006e1:	c3                   	ret    

f01006e2 <mon_kerninfo>:
f01006e2:	55                   	push   %ebp
f01006e3:	89 e5                	mov    %esp,%ebp
f01006e5:	83 ec 14             	sub    $0x14,%esp
f01006e8:	68 5d 25 10 f0       	push   $0xf010255d
f01006ed:	e8 ef 09 00 00       	call   f01010e1 <cprintf>
f01006f2:	83 c4 08             	add    $0x8,%esp
f01006f5:	68 0c 00 10 00       	push   $0x10000c
f01006fa:	68 f0 25 10 f0       	push   $0xf01025f0
f01006ff:	e8 dd 09 00 00       	call   f01010e1 <cprintf>
f0100704:	83 c4 0c             	add    $0xc,%esp
f0100707:	68 0c 00 10 00       	push   $0x10000c
f010070c:	68 0c 00 10 f0       	push   $0xf010000c
f0100711:	68 18 26 10 f0       	push   $0xf0102618
f0100716:	e8 c6 09 00 00       	call   f01010e1 <cprintf>
f010071b:	83 c4 0c             	add    $0xc,%esp
f010071e:	68 50 20 10 00       	push   $0x102050
f0100723:	68 50 20 10 f0       	push   $0xf0102050
f0100728:	68 3c 26 10 f0       	push   $0xf010263c
f010072d:	e8 af 09 00 00       	call   f01010e1 <cprintf>
f0100732:	83 c4 0c             	add    $0xc,%esp
f0100735:	68 00 43 11 00       	push   $0x114300
f010073a:	68 00 43 11 f0       	push   $0xf0114300
f010073f:	68 60 26 10 f0       	push   $0xf0102660
f0100744:	e8 98 09 00 00       	call   f01010e1 <cprintf>
f0100749:	83 c4 0c             	add    $0xc,%esp
f010074c:	68 80 49 11 00       	push   $0x114980
f0100751:	68 80 49 11 f0       	push   $0xf0114980
f0100756:	68 84 26 10 f0       	push   $0xf0102684
f010075b:	e8 81 09 00 00       	call   f01010e1 <cprintf>
f0100760:	83 c4 08             	add    $0x8,%esp
f0100763:	b8 80 49 11 f0       	mov    $0xf0114980,%eax
f0100768:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
f010076d:	c1 f8 0a             	sar    $0xa,%eax
f0100770:	50                   	push   %eax
f0100771:	68 a8 26 10 f0       	push   $0xf01026a8
f0100776:	e8 66 09 00 00       	call   f01010e1 <cprintf>
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
f01007a6:	68 d4 26 10 f0       	push   $0xf01026d4
f01007ab:	e8 31 09 00 00       	call   f01010e1 <cprintf>
f01007b0:	83 c4 18             	add    $0x18,%esp
f01007b3:	57                   	push   %edi
f01007b4:	56                   	push   %esi
f01007b5:	e8 49 0a 00 00       	call   f0101203 <debuginfo_eip>
f01007ba:	83 c4 08             	add    $0x8,%esp
f01007bd:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01007c0:	56                   	push   %esi
f01007c1:	ff 75 d8             	push   -0x28(%ebp)
f01007c4:	ff 75 dc             	push   -0x24(%ebp)
f01007c7:	ff 75 d4             	push   -0x2c(%ebp)
f01007ca:	ff 75 d0             	push   -0x30(%ebp)
f01007cd:	68 76 25 10 f0       	push   $0xf0102576
f01007d2:	e8 0a 09 00 00       	call   f01010e1 <cprintf>
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
f01007f6:	68 0c 27 10 f0       	push   $0xf010270c
f01007fb:	e8 e1 08 00 00       	call   f01010e1 <cprintf>
f0100800:	c7 04 24 30 27 10 f0 	movl   $0xf0102730,(%esp)
f0100807:	e8 d5 08 00 00       	call   f01010e1 <cprintf>
f010080c:	83 c4 10             	add    $0x10,%esp
f010080f:	eb 47                	jmp    f0100858 <monitor+0x6b>
f0100811:	83 ec 08             	sub    $0x8,%esp
f0100814:	0f be c0             	movsbl %al,%eax
f0100817:	50                   	push   %eax
f0100818:	68 8d 25 10 f0       	push   $0xf010258d
f010081d:	e8 f3 13 00 00       	call   f0101c15 <strchr>
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
f010084b:	68 92 25 10 f0       	push   $0xf0102592
f0100850:	e8 8c 08 00 00       	call   f01010e1 <cprintf>
f0100855:	83 c4 10             	add    $0x10,%esp
f0100858:	83 ec 0c             	sub    $0xc,%esp
f010085b:	68 89 25 10 f0       	push   $0xf0102589
f0100860:	e8 9e 11 00 00       	call   f0101a03 <readline>
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
f010088a:	68 8d 25 10 f0       	push   $0xf010258d
f010088f:	e8 81 13 00 00       	call   f0101c15 <strchr>
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
f01008b3:	bf 60 27 10 f0       	mov    $0xf0102760,%edi
f01008b8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01008bd:	83 ec 08             	sub    $0x8,%esp
f01008c0:	ff 37                	push   (%edi)
f01008c2:	ff 75 a8             	push   -0x58(%ebp)
f01008c5:	e8 f5 12 00 00       	call   f0101bbf <strcmp>
f01008ca:	83 c4 10             	add    $0x10,%esp
f01008cd:	85 c0                	test   %eax,%eax
f01008cf:	74 21                	je     f01008f2 <monitor+0x105>
f01008d1:	43                   	inc    %ebx
f01008d2:	83 c7 0c             	add    $0xc,%edi
f01008d5:	83 fb 03             	cmp    $0x3,%ebx
f01008d8:	75 e3                	jne    f01008bd <monitor+0xd0>
f01008da:	83 ec 08             	sub    $0x8,%esp
f01008dd:	ff 75 a8             	push   -0x58(%ebp)
f01008e0:	68 af 25 10 f0       	push   $0xf01025af
f01008e5:	e8 f7 07 00 00       	call   f01010e1 <cprintf>
f01008ea:	83 c4 10             	add    $0x10,%esp
f01008ed:	e9 66 ff ff ff       	jmp    f0100858 <monitor+0x6b>
f01008f2:	83 ec 04             	sub    $0x4,%esp
f01008f5:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
f01008f8:	01 d8                	add    %ebx,%eax
f01008fa:	ff 75 08             	push   0x8(%ebp)
f01008fd:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100900:	52                   	push   %edx
f0100901:	56                   	push   %esi
f0100902:	ff 14 85 68 27 10 f0 	call   *-0xfefd898(,%eax,4)
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
f0100927:	e8 4e 07 00 00       	call   f010107a <mc146818_read>
f010092c:	89 c6                	mov    %eax,%esi
f010092e:	43                   	inc    %ebx
f010092f:	89 1c 24             	mov    %ebx,(%esp)
f0100932:	e8 43 07 00 00       	call   f010107a <mc146818_read>
f0100937:	c1 e0 08             	shl    $0x8,%eax
f010093a:	09 f0                	or     %esi,%eax
f010093c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010093f:	5b                   	pop    %ebx
f0100940:	5e                   	pop    %esi
f0100941:	5d                   	pop    %ebp
f0100942:	c3                   	ret    

f0100943 <boot_alloc>:
f0100943:	83 3d 64 45 11 f0 00 	cmpl   $0x0,0xf0114564
f010094a:	74 21                	je     f010096d <boot_alloc+0x2a>
f010094c:	8b 15 64 45 11 f0    	mov    0xf0114564,%edx
f0100952:	8d 4a ff             	lea    -0x1(%edx),%ecx
f0100955:	01 c1                	add    %eax,%ecx
f0100957:	72 27                	jb     f0100980 <boot_alloc+0x3d>
f0100959:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0100960:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100965:	a3 64 45 11 f0       	mov    %eax,0xf0114564
f010096a:	89 d0                	mov    %edx,%eax
f010096c:	c3                   	ret    
f010096d:	ba 7f 59 11 f0       	mov    $0xf011597f,%edx
f0100972:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100978:	89 15 64 45 11 f0    	mov    %edx,0xf0114564
f010097e:	eb cc                	jmp    f010094c <boot_alloc+0x9>
f0100980:	55                   	push   %ebp
f0100981:	89 e5                	mov    %esp,%ebp
f0100983:	83 ec 08             	sub    $0x8,%esp
f0100986:	68 84 27 10 f0       	push   $0xf0102784
f010098b:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100990:	6a 6f                	push   $0x6f
f0100992:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100997:	e8 9c f7 ff ff       	call   f0100138 <_panic>

f010099c <page_init>:
f010099c:	55                   	push   %ebp
f010099d:	89 e5                	mov    %esp,%ebp
f010099f:	57                   	push   %edi
f01009a0:	56                   	push   %esi
f01009a1:	53                   	push   %ebx
f01009a2:	83 ec 1c             	sub    $0x1c,%esp
f01009a5:	8b 35 70 45 11 f0    	mov    0xf0114570,%esi
f01009ab:	89 f2                	mov    %esi,%edx
f01009ad:	c1 e2 0c             	shl    $0xc,%edx
f01009b0:	8b 0d 58 45 11 f0    	mov    0xf0114558,%ecx
f01009b6:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01009bc:	76 6b                	jbe    f0100a29 <page_init+0x8d>
f01009be:	a1 60 45 11 f0       	mov    0xf0114560,%eax
f01009c3:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01009ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01009cf:	8d bc 01 00 00 00 10 	lea    0x10000000(%ecx,%eax,1),%edi
f01009d6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f01009d9:	a1 68 45 11 f0       	mov    0xf0114568,%eax
f01009de:	c1 e0 0a             	shl    $0xa,%eax
f01009e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01009e4:	83 ec 0c             	sub    $0xc,%esp
f01009e7:	50                   	push   %eax
f01009e8:	57                   	push   %edi
f01009e9:	52                   	push   %edx
f01009ea:	68 00 10 00 00       	push   $0x1000
f01009ef:	68 d0 27 10 f0       	push   $0xf01027d0
f01009f4:	e8 e8 06 00 00       	call   f01010e1 <cprintf>
f01009f9:	83 c4 18             	add    $0x18,%esp
f01009fc:	ff 35 6c 45 11 f0    	push   0xf011456c
f0100a02:	68 8b 2a 10 f0       	push   $0xf0102a8b
f0100a07:	e8 d5 06 00 00       	call   f01010e1 <cprintf>
f0100a0c:	8b 1d 6c 45 11 f0    	mov    0xf011456c,%ebx
f0100a12:	83 c4 10             	add    $0x10,%esp
f0100a15:	b2 00                	mov    $0x0,%dl
f0100a17:	b8 01 00 00 00       	mov    $0x1,%eax
f0100a1c:	81 e6 ff ff 0f 00    	and    $0xfffff,%esi
f0100a22:	bf 01 00 00 00       	mov    $0x1,%edi
f0100a27:	eb 37                	jmp    f0100a60 <page_init+0xc4>
f0100a29:	51                   	push   %ecx
f0100a2a:	68 ac 27 10 f0       	push   $0xf01027ac
f0100a2f:	68 11 01 00 00       	push   $0x111
f0100a34:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100a39:	e8 fa f6 ff ff       	call   f0100138 <_panic>
f0100a3e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100a45:	89 d1                	mov    %edx,%ecx
f0100a47:	03 0d 58 45 11 f0    	add    0xf0114558,%ecx
f0100a4d:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100a53:	89 19                	mov    %ebx,(%ecx)
f0100a55:	89 d3                	mov    %edx,%ebx
f0100a57:	03 1d 58 45 11 f0    	add    0xf0114558,%ebx
f0100a5d:	40                   	inc    %eax
f0100a5e:	89 fa                	mov    %edi,%edx
f0100a60:	39 c6                	cmp    %eax,%esi
f0100a62:	77 da                	ja     f0100a3e <page_init+0xa2>
f0100a64:	84 d2                	test   %dl,%dl
f0100a66:	74 06                	je     f0100a6e <page_init+0xd2>
f0100a68:	89 1d 6c 45 11 f0    	mov    %ebx,0xf011456c
f0100a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100a71:	c1 e8 0c             	shr    $0xc,%eax
f0100a74:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100a77:	c1 ee 0c             	shr    $0xc,%esi
f0100a7a:	8b 1d 6c 45 11 f0    	mov    0xf011456c,%ebx
f0100a80:	b2 00                	mov    $0x0,%dl
f0100a82:	bf 01 00 00 00       	mov    $0x1,%edi
f0100a87:	eb 22                	jmp    f0100aab <page_init+0x10f>
f0100a89:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0100a90:	89 d1                	mov    %edx,%ecx
f0100a92:	03 0d 58 45 11 f0    	add    0xf0114558,%ecx
f0100a98:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
f0100a9e:	89 19                	mov    %ebx,(%ecx)
f0100aa0:	89 d3                	mov    %edx,%ebx
f0100aa2:	03 1d 58 45 11 f0    	add    0xf0114558,%ebx
f0100aa8:	40                   	inc    %eax
f0100aa9:	89 fa                	mov    %edi,%edx
f0100aab:	39 c6                	cmp    %eax,%esi
f0100aad:	77 da                	ja     f0100a89 <page_init+0xed>
f0100aaf:	84 d2                	test   %dl,%dl
f0100ab1:	74 06                	je     f0100ab9 <page_init+0x11d>
f0100ab3:	89 1d 6c 45 11 f0    	mov    %ebx,0xf011456c
f0100ab9:	a1 6c 45 11 f0       	mov    0xf011456c,%eax
f0100abe:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100ac3:	76 2c                	jbe    f0100af1 <page_init+0x155>
f0100ac5:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100acb:	83 ec 0c             	sub    $0xc,%esp
f0100ace:	89 d1                	mov    %edx,%ecx
f0100ad0:	c1 e9 0c             	shr    $0xc,%ecx
f0100ad3:	51                   	push   %ecx
f0100ad4:	52                   	push   %edx
f0100ad5:	89 c2                	mov    %eax,%edx
f0100ad7:	c1 ea 16             	shr    $0x16,%edx
f0100ada:	52                   	push   %edx
f0100adb:	50                   	push   %eax
f0100adc:	68 a6 2a 10 f0       	push   $0xf0102aa6
f0100ae1:	e8 0f 06 00 00       	call   f01010f5 <memCprintf>
f0100ae6:	83 c4 20             	add    $0x20,%esp
f0100ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100aec:	5b                   	pop    %ebx
f0100aed:	5e                   	pop    %esi
f0100aee:	5f                   	pop    %edi
f0100aef:	5d                   	pop    %ebp
f0100af0:	c3                   	ret    
f0100af1:	50                   	push   %eax
f0100af2:	68 ac 27 10 f0       	push   $0xf01027ac
f0100af7:	68 27 01 00 00       	push   $0x127
f0100afc:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100b01:	e8 32 f6 ff ff       	call   f0100138 <_panic>

f0100b06 <mem_init>:
f0100b06:	55                   	push   %ebp
f0100b07:	89 e5                	mov    %esp,%ebp
f0100b09:	57                   	push   %edi
f0100b0a:	56                   	push   %esi
f0100b0b:	53                   	push   %ebx
f0100b0c:	83 ec 2c             	sub    $0x2c,%esp
f0100b0f:	b8 15 00 00 00       	mov    $0x15,%eax
f0100b14:	e8 03 fe ff ff       	call   f010091c <nvram_read>
f0100b19:	89 c3                	mov    %eax,%ebx
f0100b1b:	b8 17 00 00 00       	mov    $0x17,%eax
f0100b20:	e8 f7 fd ff ff       	call   f010091c <nvram_read>
f0100b25:	89 c6                	mov    %eax,%esi
f0100b27:	b8 34 00 00 00       	mov    $0x34,%eax
f0100b2c:	e8 eb fd ff ff       	call   f010091c <nvram_read>
f0100b31:	c1 e0 06             	shl    $0x6,%eax
f0100b34:	0f 84 fc 01 00 00    	je     f0100d36 <mem_init+0x230>
f0100b3a:	05 00 40 00 00       	add    $0x4000,%eax
f0100b3f:	a3 68 45 11 f0       	mov    %eax,0xf0114568
f0100b44:	89 c2                	mov    %eax,%edx
f0100b46:	c1 ea 02             	shr    $0x2,%edx
f0100b49:	89 15 60 45 11 f0    	mov    %edx,0xf0114560
f0100b4f:	89 da                	mov    %ebx,%edx
f0100b51:	c1 ea 02             	shr    $0x2,%edx
f0100b54:	89 15 70 45 11 f0    	mov    %edx,0xf0114570
f0100b5a:	89 c2                	mov    %eax,%edx
f0100b5c:	29 da                	sub    %ebx,%edx
f0100b5e:	52                   	push   %edx
f0100b5f:	53                   	push   %ebx
f0100b60:	50                   	push   %eax
f0100b61:	68 04 28 10 f0       	push   $0xf0102804
f0100b66:	e8 76 05 00 00       	call   f01010e1 <cprintf>
f0100b6b:	83 c4 08             	add    $0x8,%esp
f0100b6e:	6a 02                	push   $0x2
f0100b70:	68 b5 2a 10 f0       	push   $0xf0102ab5
f0100b75:	e8 67 05 00 00       	call   f01010e1 <cprintf>
f0100b7a:	83 c4 0c             	add    $0xc,%esp
f0100b7d:	6a 08                	push   $0x8
f0100b7f:	ff 35 60 45 11 f0    	push   0xf0114560
f0100b85:	68 44 28 10 f0       	push   $0xf0102844
f0100b8a:	e8 52 05 00 00       	call   f01010e1 <cprintf>
f0100b8f:	b8 00 10 00 00       	mov    $0x1000,%eax
f0100b94:	e8 aa fd ff ff       	call   f0100943 <boot_alloc>
f0100b99:	a3 5c 45 11 f0       	mov    %eax,0xf011455c
f0100b9e:	83 c4 10             	add    $0x10,%esp
f0100ba1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100ba6:	0f 86 9f 01 00 00    	jbe    f0100d4b <mem_init+0x245>
f0100bac:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100bb2:	83 ec 0c             	sub    $0xc,%esp
f0100bb5:	89 d1                	mov    %edx,%ecx
f0100bb7:	c1 e9 0c             	shr    $0xc,%ecx
f0100bba:	51                   	push   %ecx
f0100bbb:	52                   	push   %edx
f0100bbc:	89 c2                	mov    %eax,%edx
f0100bbe:	c1 ea 16             	shr    $0x16,%edx
f0100bc1:	52                   	push   %edx
f0100bc2:	50                   	push   %eax
f0100bc3:	68 cc 2a 10 f0       	push   $0xf0102acc
f0100bc8:	e8 28 05 00 00       	call   f01010f5 <memCprintf>
f0100bcd:	83 c4 1c             	add    $0x1c,%esp
f0100bd0:	68 00 10 00 00       	push   $0x1000
f0100bd5:	6a 00                	push   $0x0
f0100bd7:	ff 35 5c 45 11 f0    	push   0xf011455c
f0100bdd:	e8 6a 10 00 00       	call   f0101c4c <memset>
f0100be2:	a1 5c 45 11 f0       	mov    0xf011455c,%eax
f0100be7:	83 c4 10             	add    $0x10,%esp
f0100bea:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100bef:	0f 86 6b 01 00 00    	jbe    f0100d60 <mem_init+0x25a>
f0100bf5:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100bfb:	89 d1                	mov    %edx,%ecx
f0100bfd:	83 c9 05             	or     $0x5,%ecx
f0100c00:	89 88 f4 0e 00 00    	mov    %ecx,0xef4(%eax)
f0100c06:	83 ec 0c             	sub    $0xc,%esp
f0100c09:	89 d0                	mov    %edx,%eax
f0100c0b:	c1 e8 0c             	shr    $0xc,%eax
f0100c0e:	50                   	push   %eax
f0100c0f:	52                   	push   %edx
f0100c10:	68 bd 03 00 00       	push   $0x3bd
f0100c15:	68 00 00 40 ef       	push   $0xef400000
f0100c1a:	68 d7 2a 10 f0       	push   $0xf0102ad7
f0100c1f:	e8 d1 04 00 00       	call   f01010f5 <memCprintf>
f0100c24:	83 c4 20             	add    $0x20,%esp
f0100c27:	a1 60 45 11 f0       	mov    0xf0114560,%eax
f0100c2c:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100c33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100c38:	e8 06 fd ff ff       	call   f0100943 <boot_alloc>
f0100c3d:	a3 58 45 11 f0       	mov    %eax,0xf0114558
f0100c42:	83 ec 04             	sub    $0x4,%esp
f0100c45:	8b 15 60 45 11 f0    	mov    0xf0114560,%edx
f0100c4b:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0100c52:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100c58:	52                   	push   %edx
f0100c59:	6a 00                	push   $0x0
f0100c5b:	50                   	push   %eax
f0100c5c:	e8 eb 0f 00 00       	call   f0101c4c <memset>
f0100c61:	83 c4 08             	add    $0x8,%esp
f0100c64:	a1 60 45 11 f0       	mov    0xf0114560,%eax
f0100c69:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100c70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100c75:	c1 e8 0a             	shr    $0xa,%eax
f0100c78:	50                   	push   %eax
f0100c79:	68 dc 2a 10 f0       	push   $0xf0102adc
f0100c7e:	e8 5e 04 00 00       	call   f01010e1 <cprintf>
f0100c83:	a1 58 45 11 f0       	mov    0xf0114558,%eax
f0100c88:	83 c4 10             	add    $0x10,%esp
f0100c8b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100c90:	0f 86 df 00 00 00    	jbe    f0100d75 <mem_init+0x26f>
f0100c96:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100c9c:	83 ec 0c             	sub    $0xc,%esp
f0100c9f:	89 d1                	mov    %edx,%ecx
f0100ca1:	c1 e9 0c             	shr    $0xc,%ecx
f0100ca4:	51                   	push   %ecx
f0100ca5:	52                   	push   %edx
f0100ca6:	89 c2                	mov    %eax,%edx
f0100ca8:	c1 ea 16             	shr    $0x16,%edx
f0100cab:	52                   	push   %edx
f0100cac:	50                   	push   %eax
f0100cad:	68 1d 2b 10 f0       	push   $0xf0102b1d
f0100cb2:	e8 3e 04 00 00       	call   f01010f5 <memCprintf>
f0100cb7:	83 c4 20             	add    $0x20,%esp
f0100cba:	e8 dd fc ff ff       	call   f010099c <page_init>
f0100cbf:	a1 6c 45 11 f0       	mov    0xf011456c,%eax
f0100cc4:	85 c0                	test   %eax,%eax
f0100cc6:	0f 84 be 00 00 00    	je     f0100d8a <mem_init+0x284>
f0100ccc:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100ccf:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100cd2:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100cd5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100cd8:	89 c2                	mov    %eax,%edx
f0100cda:	2b 15 58 45 11 f0    	sub    0xf0114558,%edx
f0100ce0:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100ce6:	0f 95 c2             	setne  %dl
f0100ce9:	0f b6 d2             	movzbl %dl,%edx
f0100cec:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100cf0:	89 01                	mov    %eax,(%ecx)
f0100cf2:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
f0100cf6:	8b 00                	mov    (%eax),%eax
f0100cf8:	85 c0                	test   %eax,%eax
f0100cfa:	75 dc                	jne    f0100cd8 <mem_init+0x1d2>
f0100cfc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100cff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100d02:	56                   	push   %esi
f0100d03:	53                   	push   %ebx
f0100d04:	ff 33                	push   (%ebx)
f0100d06:	ff 36                	push   (%esi)
f0100d08:	ff 75 dc             	push   -0x24(%ebp)
f0100d0b:	ff 75 d8             	push   -0x28(%ebp)
f0100d0e:	6a 00                	push   $0x0
f0100d10:	68 94 28 10 f0       	push   $0xf0102894
f0100d15:	e8 c7 03 00 00       	call   f01010e1 <cprintf>
f0100d1a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
f0100d20:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100d23:	89 03                	mov    %eax,(%ebx)
f0100d25:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0100d28:	89 1d 6c 45 11 f0    	mov    %ebx,0xf011456c
f0100d2e:	83 c4 20             	add    $0x20,%esp
f0100d31:	e9 89 00 00 00       	jmp    f0100dbf <mem_init+0x2b9>
f0100d36:	89 d8                	mov    %ebx,%eax
f0100d38:	85 f6                	test   %esi,%esi
f0100d3a:	0f 84 ff fd ff ff    	je     f0100b3f <mem_init+0x39>
f0100d40:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0100d46:	e9 f4 fd ff ff       	jmp    f0100b3f <mem_init+0x39>
f0100d4b:	50                   	push   %eax
f0100d4c:	68 ac 27 10 f0       	push   $0xf01027ac
f0100d51:	68 91 00 00 00       	push   $0x91
f0100d56:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100d5b:	e8 d8 f3 ff ff       	call   f0100138 <_panic>
f0100d60:	50                   	push   %eax
f0100d61:	68 ac 27 10 f0       	push   $0xf01027ac
f0100d66:	68 9b 00 00 00       	push   $0x9b
f0100d6b:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100d70:	e8 c3 f3 ff ff       	call   f0100138 <_panic>
f0100d75:	50                   	push   %eax
f0100d76:	68 ac 27 10 f0       	push   $0xf01027ac
f0100d7b:	68 a8 00 00 00       	push   $0xa8
f0100d80:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100d85:	e8 ae f3 ff ff       	call   f0100138 <_panic>
f0100d8a:	83 ec 04             	sub    $0x4,%esp
f0100d8d:	68 70 28 10 f0       	push   $0xf0102870
f0100d92:	68 dc 01 00 00       	push   $0x1dc
f0100d97:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100d9c:	e8 97 f3 ff ff       	call   f0100138 <_panic>
f0100da1:	83 ec 04             	sub    $0x4,%esp
f0100da4:	68 80 00 00 00       	push   $0x80
f0100da9:	68 97 00 00 00       	push   $0x97
f0100dae:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0100db4:	52                   	push   %edx
f0100db5:	e8 92 0e 00 00       	call   f0101c4c <memset>
f0100dba:	83 c4 10             	add    $0x10,%esp
f0100dbd:	8b 1b                	mov    (%ebx),%ebx
f0100dbf:	85 db                	test   %ebx,%ebx
f0100dc1:	74 36                	je     f0100df9 <mem_init+0x2f3>
f0100dc3:	89 d8                	mov    %ebx,%eax
f0100dc5:	2b 05 58 45 11 f0    	sub    0xf0114558,%eax
f0100dcb:	c1 f8 03             	sar    $0x3,%eax
f0100dce:	89 c2                	mov    %eax,%edx
f0100dd0:	c1 e2 0c             	shl    $0xc,%edx
f0100dd3:	a9 00 fc 0f 00       	test   $0xffc00,%eax
f0100dd8:	75 e3                	jne    f0100dbd <mem_init+0x2b7>
f0100dda:	89 d0                	mov    %edx,%eax
f0100ddc:	c1 e8 0c             	shr    $0xc,%eax
f0100ddf:	3b 05 60 45 11 f0    	cmp    0xf0114560,%eax
f0100de5:	72 ba                	jb     f0100da1 <mem_init+0x29b>
f0100de7:	52                   	push   %edx
f0100de8:	68 e0 28 10 f0       	push   $0xf01028e0
f0100ded:	6a 52                	push   $0x52
f0100def:	68 f3 2a 10 f0       	push   $0xf0102af3
f0100df4:	e8 3f f3 ff ff       	call   f0100138 <_panic>
f0100df9:	b8 00 00 00 00       	mov    $0x0,%eax
f0100dfe:	e8 40 fb ff ff       	call   f0100943 <boot_alloc>
f0100e03:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100e06:	83 ec 08             	sub    $0x8,%esp
f0100e09:	50                   	push   %eax
f0100e0a:	68 01 2b 10 f0       	push   $0xf0102b01
f0100e0f:	e8 cd 02 00 00       	call   f01010e1 <cprintf>
f0100e14:	8b 15 6c 45 11 f0    	mov    0xf011456c,%edx
f0100e1a:	8b 0d 58 45 11 f0    	mov    0xf0114558,%ecx
f0100e20:	a1 60 45 11 f0       	mov    0xf0114560,%eax
f0100e25:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100e28:	8d 3c c1             	lea    (%ecx,%eax,8),%edi
f0100e2b:	83 c4 10             	add    $0x10,%esp
f0100e2e:	be 00 00 00 00       	mov    $0x0,%esi
f0100e33:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0100e36:	e9 c8 00 00 00       	jmp    f0100f03 <mem_init+0x3fd>
f0100e3b:	68 17 2b 10 f0       	push   $0xf0102b17
f0100e40:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100e45:	68 fd 01 00 00       	push   $0x1fd
f0100e4a:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100e4f:	e8 e4 f2 ff ff       	call   f0100138 <_panic>
f0100e54:	68 23 2b 10 f0       	push   $0xf0102b23
f0100e59:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100e5e:	68 fe 01 00 00       	push   $0x1fe
f0100e63:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100e68:	e8 cb f2 ff ff       	call   f0100138 <_panic>
f0100e6d:	68 04 29 10 f0       	push   $0xf0102904
f0100e72:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100e77:	68 ff 01 00 00       	push   $0x1ff
f0100e7c:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100e81:	e8 b2 f2 ff ff       	call   f0100138 <_panic>
f0100e86:	68 37 2b 10 f0       	push   $0xf0102b37
f0100e8b:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100e90:	68 02 02 00 00       	push   $0x202
f0100e95:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100e9a:	e8 99 f2 ff ff       	call   f0100138 <_panic>
f0100e9f:	68 48 2b 10 f0       	push   $0xf0102b48
f0100ea4:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100ea9:	68 03 02 00 00       	push   $0x203
f0100eae:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100eb3:	e8 80 f2 ff ff       	call   f0100138 <_panic>
f0100eb8:	68 38 29 10 f0       	push   $0xf0102938
f0100ebd:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100ec2:	68 04 02 00 00       	push   $0x204
f0100ec7:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100ecc:	e8 67 f2 ff ff       	call   f0100138 <_panic>
f0100ed1:	68 61 2b 10 f0       	push   $0xf0102b61
f0100ed6:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100edb:	68 05 02 00 00       	push   $0x205
f0100ee0:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100ee5:	e8 4e f2 ff ff       	call   f0100138 <_panic>
f0100eea:	89 c3                	mov    %eax,%ebx
f0100eec:	c1 eb 0c             	shr    $0xc,%ebx
f0100eef:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0100ef2:	76 62                	jbe    f0100f56 <mem_init+0x450>
f0100ef4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100ef9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0100efc:	77 6a                	ja     f0100f68 <mem_init+0x462>
f0100efe:	ff 45 d4             	incl   -0x2c(%ebp)
f0100f01:	8b 12                	mov    (%edx),%edx
f0100f03:	85 d2                	test   %edx,%edx
f0100f05:	74 7a                	je     f0100f81 <mem_init+0x47b>
f0100f07:	39 d1                	cmp    %edx,%ecx
f0100f09:	0f 87 2c ff ff ff    	ja     f0100e3b <mem_init+0x335>
f0100f0f:	39 fa                	cmp    %edi,%edx
f0100f11:	0f 83 3d ff ff ff    	jae    f0100e54 <mem_init+0x34e>
f0100f17:	89 d0                	mov    %edx,%eax
f0100f19:	29 c8                	sub    %ecx,%eax
f0100f1b:	a8 07                	test   $0x7,%al
f0100f1d:	0f 85 4a ff ff ff    	jne    f0100e6d <mem_init+0x367>
f0100f23:	c1 f8 03             	sar    $0x3,%eax
f0100f26:	c1 e0 0c             	shl    $0xc,%eax
f0100f29:	0f 84 57 ff ff ff    	je     f0100e86 <mem_init+0x380>
f0100f2f:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100f34:	0f 84 65 ff ff ff    	je     f0100e9f <mem_init+0x399>
f0100f3a:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100f3f:	0f 84 73 ff ff ff    	je     f0100eb8 <mem_init+0x3b2>
f0100f45:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100f4a:	74 85                	je     f0100ed1 <mem_init+0x3cb>
f0100f4c:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100f51:	77 97                	ja     f0100eea <mem_init+0x3e4>
f0100f53:	46                   	inc    %esi
f0100f54:	eb ab                	jmp    f0100f01 <mem_init+0x3fb>
f0100f56:	50                   	push   %eax
f0100f57:	68 e0 28 10 f0       	push   $0xf01028e0
f0100f5c:	6a 52                	push   $0x52
f0100f5e:	68 f3 2a 10 f0       	push   $0xf0102af3
f0100f63:	e8 d0 f1 ff ff       	call   f0100138 <_panic>
f0100f68:	68 5c 29 10 f0       	push   $0xf010295c
f0100f6d:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100f72:	68 06 02 00 00       	push   $0x206
f0100f77:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100f7c:	e8 b7 f1 ff ff       	call   f0100138 <_panic>
f0100f81:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0100f84:	83 ec 04             	sub    $0x4,%esp
f0100f87:	53                   	push   %ebx
f0100f88:	56                   	push   %esi
f0100f89:	68 a4 29 10 f0       	push   $0xf01029a4
f0100f8e:	e8 4e 01 00 00       	call   f01010e1 <cprintf>
f0100f93:	83 c4 08             	add    $0x8,%esp
f0100f96:	b8 00 80 00 00       	mov    $0x8000,%eax
f0100f9b:	29 f0                	sub    %esi,%eax
f0100f9d:	29 d8                	sub    %ebx,%eax
f0100f9f:	50                   	push   %eax
f0100fa0:	68 cc 29 10 f0       	push   $0xf01029cc
f0100fa5:	e8 37 01 00 00       	call   f01010e1 <cprintf>
f0100faa:	83 c4 10             	add    $0x10,%esp
f0100fad:	85 f6                	test   %esi,%esi
f0100faf:	7e 36                	jle    f0100fe7 <mem_init+0x4e1>
f0100fb1:	85 db                	test   %ebx,%ebx
f0100fb3:	7e 4b                	jle    f0101000 <mem_init+0x4fa>
f0100fb5:	83 ec 0c             	sub    $0xc,%esp
f0100fb8:	68 f0 29 10 f0       	push   $0xf01029f0
f0100fbd:	e8 1f 01 00 00       	call   f01010e1 <cprintf>
f0100fc2:	c7 04 24 14 2a 10 f0 	movl   $0xf0102a14,(%esp)
f0100fc9:	e8 13 01 00 00       	call   f01010e1 <cprintf>
f0100fce:	83 c4 10             	add    $0x10,%esp
f0100fd1:	83 3d 58 45 11 f0 00 	cmpl   $0x0,0xf0114558
f0100fd8:	74 3f                	je     f0101019 <mem_init+0x513>
f0100fda:	a1 6c 45 11 f0       	mov    0xf011456c,%eax
f0100fdf:	85 c0                	test   %eax,%eax
f0100fe1:	74 4d                	je     f0101030 <mem_init+0x52a>
f0100fe3:	8b 00                	mov    (%eax),%eax
f0100fe5:	eb f8                	jmp    f0100fdf <mem_init+0x4d9>
f0100fe7:	68 7b 2b 10 f0       	push   $0xf0102b7b
f0100fec:	68 6a 2a 10 f0       	push   $0xf0102a6a
f0100ff1:	68 12 02 00 00       	push   $0x212
f0100ff6:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0100ffb:	e8 38 f1 ff ff       	call   f0100138 <_panic>
f0101000:	68 8d 2b 10 f0       	push   $0xf0102b8d
f0101005:	68 6a 2a 10 f0       	push   $0xf0102a6a
f010100a:	68 13 02 00 00       	push   $0x213
f010100f:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0101014:	e8 1f f1 ff ff       	call   f0100138 <_panic>
f0101019:	83 ec 04             	sub    $0x4,%esp
f010101c:	68 9e 2b 10 f0       	push   $0xf0102b9e
f0101021:	68 24 02 00 00       	push   $0x224
f0101026:	68 7f 2a 10 f0       	push   $0xf0102a7f
f010102b:	e8 08 f1 ff ff       	call   f0100138 <_panic>
f0101030:	68 b9 2b 10 f0       	push   $0xf0102bb9
f0101035:	68 6a 2a 10 f0       	push   $0xf0102a6a
f010103a:	68 2c 02 00 00       	push   $0x22c
f010103f:	68 7f 2a 10 f0       	push   $0xf0102a7f
f0101044:	e8 ef f0 ff ff       	call   f0100138 <_panic>

f0101049 <page_alloc>:
f0101049:	b8 00 00 00 00       	mov    $0x0,%eax
f010104e:	c3                   	ret    

f010104f <page_free>:
f010104f:	c3                   	ret    

f0101050 <page_decref>:
f0101050:	55                   	push   %ebp
f0101051:	89 e5                	mov    %esp,%ebp
f0101053:	8b 45 08             	mov    0x8(%ebp),%eax
f0101056:	66 ff 48 04          	decw   0x4(%eax)
f010105a:	5d                   	pop    %ebp
f010105b:	c3                   	ret    

f010105c <pgdir_walk>:
f010105c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101061:	c3                   	ret    

f0101062 <page_insert>:
f0101062:	b8 00 00 00 00       	mov    $0x0,%eax
f0101067:	c3                   	ret    

f0101068 <page_lookup>:
f0101068:	b8 00 00 00 00       	mov    $0x0,%eax
f010106d:	c3                   	ret    

f010106e <page_remove>:
f010106e:	c3                   	ret    

f010106f <tlb_invalidate>:
f010106f:	55                   	push   %ebp
f0101070:	89 e5                	mov    %esp,%ebp
f0101072:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101075:	0f 01 38             	invlpg (%eax)
f0101078:	5d                   	pop    %ebp
f0101079:	c3                   	ret    

f010107a <mc146818_read>:
f010107a:	55                   	push   %ebp
f010107b:	89 e5                	mov    %esp,%ebp
f010107d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101080:	ba 70 00 00 00       	mov    $0x70,%edx
f0101085:	ee                   	out    %al,(%dx)
f0101086:	ba 71 00 00 00       	mov    $0x71,%edx
f010108b:	ec                   	in     (%dx),%al
f010108c:	0f b6 c0             	movzbl %al,%eax
f010108f:	5d                   	pop    %ebp
f0101090:	c3                   	ret    

f0101091 <mc146818_write>:
f0101091:	55                   	push   %ebp
f0101092:	89 e5                	mov    %esp,%ebp
f0101094:	8b 45 08             	mov    0x8(%ebp),%eax
f0101097:	ba 70 00 00 00       	mov    $0x70,%edx
f010109c:	ee                   	out    %al,(%dx)
f010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
f01010a0:	ba 71 00 00 00       	mov    $0x71,%edx
f01010a5:	ee                   	out    %al,(%dx)
f01010a6:	5d                   	pop    %ebp
f01010a7:	c3                   	ret    

f01010a8 <putch>:
f01010a8:	55                   	push   %ebp
f01010a9:	89 e5                	mov    %esp,%ebp
f01010ab:	83 ec 14             	sub    $0x14,%esp
f01010ae:	ff 75 08             	push   0x8(%ebp)
f01010b1:	e8 b6 f5 ff ff       	call   f010066c <cputchar>
f01010b6:	83 c4 10             	add    $0x10,%esp
f01010b9:	c9                   	leave  
f01010ba:	c3                   	ret    

f01010bb <vcprintf>:
f01010bb:	55                   	push   %ebp
f01010bc:	89 e5                	mov    %esp,%ebp
f01010be:	83 ec 18             	sub    $0x18,%esp
f01010c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01010c8:	ff 75 0c             	push   0xc(%ebp)
f01010cb:	ff 75 08             	push   0x8(%ebp)
f01010ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01010d1:	50                   	push   %eax
f01010d2:	68 a8 10 10 f0       	push   $0xf01010a8
f01010d7:	e8 46 04 00 00       	call   f0101522 <vprintfmt>
f01010dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01010df:	c9                   	leave  
f01010e0:	c3                   	ret    

f01010e1 <cprintf>:
f01010e1:	55                   	push   %ebp
f01010e2:	89 e5                	mov    %esp,%ebp
f01010e4:	83 ec 10             	sub    $0x10,%esp
f01010e7:	8d 45 0c             	lea    0xc(%ebp),%eax
f01010ea:	50                   	push   %eax
f01010eb:	ff 75 08             	push   0x8(%ebp)
f01010ee:	e8 c8 ff ff ff       	call   f01010bb <vcprintf>
f01010f3:	c9                   	leave  
f01010f4:	c3                   	ret    

f01010f5 <memCprintf>:
f01010f5:	55                   	push   %ebp
f01010f6:	89 e5                	mov    %esp,%ebp
f01010f8:	83 ec 10             	sub    $0x10,%esp
f01010fb:	ff 75 18             	push   0x18(%ebp)
f01010fe:	ff 75 14             	push   0x14(%ebp)
f0101101:	ff 75 10             	push   0x10(%ebp)
f0101104:	ff 75 0c             	push   0xc(%ebp)
f0101107:	ff 75 08             	push   0x8(%ebp)
f010110a:	68 d0 2b 10 f0       	push   $0xf0102bd0
f010110f:	e8 cd ff ff ff       	call   f01010e1 <cprintf>
f0101114:	c9                   	leave  
f0101115:	c3                   	ret    

f0101116 <stab_binsearch>:
f0101116:	55                   	push   %ebp
f0101117:	89 e5                	mov    %esp,%ebp
f0101119:	57                   	push   %edi
f010111a:	56                   	push   %esi
f010111b:	53                   	push   %ebx
f010111c:	83 ec 14             	sub    $0x14,%esp
f010111f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101122:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101125:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101128:	8b 75 08             	mov    0x8(%ebp),%esi
f010112b:	8b 1a                	mov    (%edx),%ebx
f010112d:	8b 39                	mov    (%ecx),%edi
f010112f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0101136:	eb 31                	jmp    f0101169 <stab_binsearch+0x53>
f0101138:	48                   	dec    %eax
f0101139:	39 c3                	cmp    %eax,%ebx
f010113b:	7f 50                	jg     f010118d <stab_binsearch+0x77>
f010113d:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0101141:	83 ea 0c             	sub    $0xc,%edx
f0101144:	39 f1                	cmp    %esi,%ecx
f0101146:	75 f0                	jne    f0101138 <stab_binsearch+0x22>
f0101148:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010114b:	01 c2                	add    %eax,%edx
f010114d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0101150:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0101154:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0101157:	73 3a                	jae    f0101193 <stab_binsearch+0x7d>
f0101159:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010115c:	89 03                	mov    %eax,(%ebx)
f010115e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0101161:	43                   	inc    %ebx
f0101162:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0101169:	39 fb                	cmp    %edi,%ebx
f010116b:	7f 4f                	jg     f01011bc <stab_binsearch+0xa6>
f010116d:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f0101170:	89 d0                	mov    %edx,%eax
f0101172:	c1 e8 1f             	shr    $0x1f,%eax
f0101175:	01 d0                	add    %edx,%eax
f0101177:	89 c1                	mov    %eax,%ecx
f0101179:	d1 f9                	sar    %ecx
f010117b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
f010117e:	83 e0 fe             	and    $0xfffffffe,%eax
f0101181:	01 c8                	add    %ecx,%eax
f0101183:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101186:	8d 14 82             	lea    (%edx,%eax,4),%edx
f0101189:	89 c8                	mov    %ecx,%eax
f010118b:	eb ac                	jmp    f0101139 <stab_binsearch+0x23>
f010118d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0101190:	43                   	inc    %ebx
f0101191:	eb d6                	jmp    f0101169 <stab_binsearch+0x53>
f0101193:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0101196:	76 11                	jbe    f01011a9 <stab_binsearch+0x93>
f0101198:	8d 78 ff             	lea    -0x1(%eax),%edi
f010119b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010119e:	89 38                	mov    %edi,(%eax)
f01011a0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01011a7:	eb c0                	jmp    f0101169 <stab_binsearch+0x53>
f01011a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01011ac:	89 03                	mov    %eax,(%ebx)
f01011ae:	ff 45 0c             	incl   0xc(%ebp)
f01011b1:	89 c3                	mov    %eax,%ebx
f01011b3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01011ba:	eb ad                	jmp    f0101169 <stab_binsearch+0x53>
f01011bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01011c0:	75 13                	jne    f01011d5 <stab_binsearch+0xbf>
f01011c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01011c5:	8b 00                	mov    (%eax),%eax
f01011c7:	48                   	dec    %eax
f01011c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01011cb:	89 07                	mov    %eax,(%edi)
f01011cd:	83 c4 14             	add    $0x14,%esp
f01011d0:	5b                   	pop    %ebx
f01011d1:	5e                   	pop    %esi
f01011d2:	5f                   	pop    %edi
f01011d3:	5d                   	pop    %ebp
f01011d4:	c3                   	ret    
f01011d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011d8:	8b 00                	mov    (%eax),%eax
f01011da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01011dd:	8b 0f                	mov    (%edi),%ecx
f01011df:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01011e2:	01 c2                	add    %eax,%edx
f01011e4:	8b 7d f0             	mov    -0x10(%ebp),%edi
f01011e7:	8d 14 97             	lea    (%edi,%edx,4),%edx
f01011ea:	39 c1                	cmp    %eax,%ecx
f01011ec:	7d 0e                	jge    f01011fc <stab_binsearch+0xe6>
f01011ee:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f01011f2:	83 ea 0c             	sub    $0xc,%edx
f01011f5:	39 f3                	cmp    %esi,%ebx
f01011f7:	74 03                	je     f01011fc <stab_binsearch+0xe6>
f01011f9:	48                   	dec    %eax
f01011fa:	eb ee                	jmp    f01011ea <stab_binsearch+0xd4>
f01011fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01011ff:	89 07                	mov    %eax,(%edi)
f0101201:	eb ca                	jmp    f01011cd <stab_binsearch+0xb7>

f0101203 <debuginfo_eip>:
f0101203:	55                   	push   %ebp
f0101204:	89 e5                	mov    %esp,%ebp
f0101206:	57                   	push   %edi
f0101207:	56                   	push   %esi
f0101208:	53                   	push   %ebx
f0101209:	83 ec 3c             	sub    $0x3c,%esp
f010120c:	8b 7d 08             	mov    0x8(%ebp),%edi
f010120f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101212:	c7 03 20 2c 10 f0    	movl   $0xf0102c20,(%ebx)
f0101218:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
f010121f:	c7 43 08 20 2c 10 f0 	movl   $0xf0102c20,0x8(%ebx)
f0101226:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
f010122d:	89 7b 10             	mov    %edi,0x10(%ebx)
f0101230:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
f0101237:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f010123d:	0f 86 51 01 00 00    	jbe    f0101394 <debuginfo_eip+0x191>
f0101243:	b8 0c 96 10 f0       	mov    $0xf010960c,%eax
f0101248:	3d 25 79 10 f0       	cmp    $0xf0107925,%eax
f010124d:	0f 86 c8 01 00 00    	jbe    f010141b <debuginfo_eip+0x218>
f0101253:	80 3d 0b 96 10 f0 00 	cmpb   $0x0,0xf010960b
f010125a:	0f 85 c2 01 00 00    	jne    f0101422 <debuginfo_eip+0x21f>
f0101260:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101267:	b8 24 79 10 f0       	mov    $0xf0107924,%eax
f010126c:	2d 54 2e 10 f0       	sub    $0xf0102e54,%eax
f0101271:	89 c2                	mov    %eax,%edx
f0101273:	c1 fa 02             	sar    $0x2,%edx
f0101276:	83 e0 fc             	and    $0xfffffffc,%eax
f0101279:	01 d0                	add    %edx,%eax
f010127b:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010127e:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101281:	89 c1                	mov    %eax,%ecx
f0101283:	c1 e1 08             	shl    $0x8,%ecx
f0101286:	01 c8                	add    %ecx,%eax
f0101288:	89 c1                	mov    %eax,%ecx
f010128a:	c1 e1 10             	shl    $0x10,%ecx
f010128d:	01 c8                	add    %ecx,%eax
f010128f:	01 c0                	add    %eax,%eax
f0101291:	8d 44 02 ff          	lea    -0x1(%edx,%eax,1),%eax
f0101295:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101298:	83 ec 08             	sub    $0x8,%esp
f010129b:	57                   	push   %edi
f010129c:	6a 64                	push   $0x64
f010129e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01012a1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01012a4:	b8 54 2e 10 f0       	mov    $0xf0102e54,%eax
f01012a9:	e8 68 fe ff ff       	call   f0101116 <stab_binsearch>
f01012ae:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01012b1:	83 c4 10             	add    $0x10,%esp
f01012b4:	85 f6                	test   %esi,%esi
f01012b6:	0f 84 6d 01 00 00    	je     f0101429 <debuginfo_eip+0x226>
f01012bc:	89 75 dc             	mov    %esi,-0x24(%ebp)
f01012bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01012c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01012c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01012c8:	83 ec 08             	sub    $0x8,%esp
f01012cb:	57                   	push   %edi
f01012cc:	6a 24                	push   $0x24
f01012ce:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f01012d1:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01012d4:	b8 54 2e 10 f0       	mov    $0xf0102e54,%eax
f01012d9:	e8 38 fe ff ff       	call   f0101116 <stab_binsearch>
f01012de:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01012e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01012e4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01012e7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f01012ea:	83 c4 10             	add    $0x10,%esp
f01012ed:	39 c8                	cmp    %ecx,%eax
f01012ef:	0f 8f b3 00 00 00    	jg     f01013a8 <debuginfo_eip+0x1a5>
f01012f5:	89 c1                	mov    %eax,%ecx
f01012f7:	01 c0                	add    %eax,%eax
f01012f9:	01 c8                	add    %ecx,%eax
f01012fb:	c1 e0 02             	shl    $0x2,%eax
f01012fe:	8d 90 54 2e 10 f0    	lea    -0xfefd1ac(%eax),%edx
f0101304:	8b 88 54 2e 10 f0    	mov    -0xfefd1ac(%eax),%ecx
f010130a:	b8 0c 96 10 f0       	mov    $0xf010960c,%eax
f010130f:	2d 25 79 10 f0       	sub    $0xf0107925,%eax
f0101314:	39 c1                	cmp    %eax,%ecx
f0101316:	73 09                	jae    f0101321 <debuginfo_eip+0x11e>
f0101318:	81 c1 25 79 10 f0    	add    $0xf0107925,%ecx
f010131e:	89 4b 08             	mov    %ecx,0x8(%ebx)
f0101321:	8b 42 08             	mov    0x8(%edx),%eax
f0101324:	89 43 10             	mov    %eax,0x10(%ebx)
f0101327:	29 c7                	sub    %eax,%edi
f0101329:	8b 45 c0             	mov    -0x40(%ebp),%eax
f010132c:	8b 55 bc             	mov    -0x44(%ebp),%edx
f010132f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0101332:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101335:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0101338:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010133b:	83 ec 08             	sub    $0x8,%esp
f010133e:	6a 3a                	push   $0x3a
f0101340:	ff 73 08             	push   0x8(%ebx)
f0101343:	e8 ec 08 00 00       	call   f0101c34 <strfind>
f0101348:	2b 43 08             	sub    0x8(%ebx),%eax
f010134b:	89 43 0c             	mov    %eax,0xc(%ebx)
f010134e:	83 c4 08             	add    $0x8,%esp
f0101351:	89 f8                	mov    %edi,%eax
f0101353:	03 43 10             	add    0x10(%ebx),%eax
f0101356:	50                   	push   %eax
f0101357:	6a 44                	push   $0x44
f0101359:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f010135c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f010135f:	b8 54 2e 10 f0       	mov    $0xf0102e54,%eax
f0101364:	e8 ad fd ff ff       	call   f0101116 <stab_binsearch>
f0101369:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010136c:	83 c4 10             	add    $0x10,%esp
f010136f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0101372:	7f 38                	jg     f01013ac <debuginfo_eip+0x1a9>
f0101374:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0101377:	01 c2                	add    %eax,%edx
f0101379:	0f b7 14 95 5a 2e 10 	movzwl -0xfefd1a6(,%edx,4),%edx
f0101380:	f0 
f0101381:	89 53 04             	mov    %edx,0x4(%ebx)
f0101384:	89 c2                	mov    %eax,%edx
f0101386:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
f0101389:	01 c8                	add    %ecx,%eax
f010138b:	8d 04 85 54 2e 10 f0 	lea    -0xfefd1ac(,%eax,4),%eax
f0101392:	eb 23                	jmp    f01013b7 <debuginfo_eip+0x1b4>
f0101394:	83 ec 04             	sub    $0x4,%esp
f0101397:	68 2a 2c 10 f0       	push   $0xf0102c2a
f010139c:	6a 7d                	push   $0x7d
f010139e:	68 37 2c 10 f0       	push   $0xf0102c37
f01013a3:	e8 90 ed ff ff       	call   f0100138 <_panic>
f01013a8:	89 f0                	mov    %esi,%eax
f01013aa:	eb 86                	jmp    f0101332 <debuginfo_eip+0x12f>
f01013ac:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01013b1:	eb ce                	jmp    f0101381 <debuginfo_eip+0x17e>
f01013b3:	4a                   	dec    %edx
f01013b4:	83 e8 0c             	sub    $0xc,%eax
f01013b7:	39 d6                	cmp    %edx,%esi
f01013b9:	7f 35                	jg     f01013f0 <debuginfo_eip+0x1ed>
f01013bb:	8a 48 04             	mov    0x4(%eax),%cl
f01013be:	80 f9 84             	cmp    $0x84,%cl
f01013c1:	74 0b                	je     f01013ce <debuginfo_eip+0x1cb>
f01013c3:	80 f9 64             	cmp    $0x64,%cl
f01013c6:	75 eb                	jne    f01013b3 <debuginfo_eip+0x1b0>
f01013c8:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
f01013cc:	74 e5                	je     f01013b3 <debuginfo_eip+0x1b0>
f01013ce:	8d 04 12             	lea    (%edx,%edx,1),%eax
f01013d1:	01 d0                	add    %edx,%eax
f01013d3:	8b 14 85 54 2e 10 f0 	mov    -0xfefd1ac(,%eax,4),%edx
f01013da:	b8 0c 96 10 f0       	mov    $0xf010960c,%eax
f01013df:	2d 25 79 10 f0       	sub    $0xf0107925,%eax
f01013e4:	39 c2                	cmp    %eax,%edx
f01013e6:	73 08                	jae    f01013f0 <debuginfo_eip+0x1ed>
f01013e8:	81 c2 25 79 10 f0    	add    $0xf0107925,%edx
f01013ee:	89 13                	mov    %edx,(%ebx)
f01013f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
f01013f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f01013f6:	39 c8                	cmp    %ecx,%eax
f01013f8:	7d 36                	jge    f0101430 <debuginfo_eip+0x22d>
f01013fa:	40                   	inc    %eax
f01013fb:	eb 03                	jmp    f0101400 <debuginfo_eip+0x1fd>
f01013fd:	ff 43 14             	incl   0x14(%ebx)
f0101400:	39 c1                	cmp    %eax,%ecx
f0101402:	7e 39                	jle    f010143d <debuginfo_eip+0x23a>
f0101404:	40                   	inc    %eax
f0101405:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0101408:	01 c2                	add    %eax,%edx
f010140a:	80 3c 95 4c 2e 10 f0 	cmpb   $0xa0,-0xfefd1b4(,%edx,4)
f0101411:	a0 
f0101412:	74 e9                	je     f01013fd <debuginfo_eip+0x1fa>
f0101414:	b8 00 00 00 00       	mov    $0x0,%eax
f0101419:	eb 1a                	jmp    f0101435 <debuginfo_eip+0x232>
f010141b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0101420:	eb 13                	jmp    f0101435 <debuginfo_eip+0x232>
f0101422:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0101427:	eb 0c                	jmp    f0101435 <debuginfo_eip+0x232>
f0101429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010142e:	eb 05                	jmp    f0101435 <debuginfo_eip+0x232>
f0101430:	b8 00 00 00 00       	mov    $0x0,%eax
f0101435:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101438:	5b                   	pop    %ebx
f0101439:	5e                   	pop    %esi
f010143a:	5f                   	pop    %edi
f010143b:	5d                   	pop    %ebp
f010143c:	c3                   	ret    
f010143d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101442:	eb f1                	jmp    f0101435 <debuginfo_eip+0x232>

f0101444 <printnum>:
f0101444:	55                   	push   %ebp
f0101445:	89 e5                	mov    %esp,%ebp
f0101447:	57                   	push   %edi
f0101448:	56                   	push   %esi
f0101449:	53                   	push   %ebx
f010144a:	83 ec 1c             	sub    $0x1c,%esp
f010144d:	89 c7                	mov    %eax,%edi
f010144f:	89 d6                	mov    %edx,%esi
f0101451:	8b 45 08             	mov    0x8(%ebp),%eax
f0101454:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101457:	89 d1                	mov    %edx,%ecx
f0101459:	89 c2                	mov    %eax,%edx
f010145b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010145e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0101461:	8b 45 10             	mov    0x10(%ebp),%eax
f0101464:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0101467:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010146a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101471:	39 c2                	cmp    %eax,%edx
f0101473:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0101476:	72 3c                	jb     f01014b4 <printnum+0x70>
f0101478:	83 ec 0c             	sub    $0xc,%esp
f010147b:	ff 75 18             	push   0x18(%ebp)
f010147e:	4b                   	dec    %ebx
f010147f:	53                   	push   %ebx
f0101480:	50                   	push   %eax
f0101481:	83 ec 08             	sub    $0x8,%esp
f0101484:	ff 75 e4             	push   -0x1c(%ebp)
f0101487:	ff 75 e0             	push   -0x20(%ebp)
f010148a:	ff 75 dc             	push   -0x24(%ebp)
f010148d:	ff 75 d8             	push   -0x28(%ebp)
f0101490:	e8 97 09 00 00       	call   f0101e2c <__udivdi3>
f0101495:	83 c4 18             	add    $0x18,%esp
f0101498:	52                   	push   %edx
f0101499:	50                   	push   %eax
f010149a:	89 f2                	mov    %esi,%edx
f010149c:	89 f8                	mov    %edi,%eax
f010149e:	e8 a1 ff ff ff       	call   f0101444 <printnum>
f01014a3:	83 c4 20             	add    $0x20,%esp
f01014a6:	eb 11                	jmp    f01014b9 <printnum+0x75>
f01014a8:	83 ec 08             	sub    $0x8,%esp
f01014ab:	56                   	push   %esi
f01014ac:	ff 75 18             	push   0x18(%ebp)
f01014af:	ff d7                	call   *%edi
f01014b1:	83 c4 10             	add    $0x10,%esp
f01014b4:	4b                   	dec    %ebx
f01014b5:	85 db                	test   %ebx,%ebx
f01014b7:	7f ef                	jg     f01014a8 <printnum+0x64>
f01014b9:	83 ec 08             	sub    $0x8,%esp
f01014bc:	56                   	push   %esi
f01014bd:	83 ec 04             	sub    $0x4,%esp
f01014c0:	ff 75 e4             	push   -0x1c(%ebp)
f01014c3:	ff 75 e0             	push   -0x20(%ebp)
f01014c6:	ff 75 dc             	push   -0x24(%ebp)
f01014c9:	ff 75 d8             	push   -0x28(%ebp)
f01014cc:	e8 63 0a 00 00       	call   f0101f34 <__umoddi3>
f01014d1:	83 c4 14             	add    $0x14,%esp
f01014d4:	0f be 80 45 2c 10 f0 	movsbl -0xfefd3bb(%eax),%eax
f01014db:	50                   	push   %eax
f01014dc:	ff d7                	call   *%edi
f01014de:	83 c4 10             	add    $0x10,%esp
f01014e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01014e4:	5b                   	pop    %ebx
f01014e5:	5e                   	pop    %esi
f01014e6:	5f                   	pop    %edi
f01014e7:	5d                   	pop    %ebp
f01014e8:	c3                   	ret    

f01014e9 <sprintputch>:
f01014e9:	55                   	push   %ebp
f01014ea:	89 e5                	mov    %esp,%ebp
f01014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
f01014ef:	ff 40 08             	incl   0x8(%eax)
f01014f2:	8b 10                	mov    (%eax),%edx
f01014f4:	3b 50 04             	cmp    0x4(%eax),%edx
f01014f7:	73 0a                	jae    f0101503 <sprintputch+0x1a>
f01014f9:	8d 4a 01             	lea    0x1(%edx),%ecx
f01014fc:	89 08                	mov    %ecx,(%eax)
f01014fe:	8b 45 08             	mov    0x8(%ebp),%eax
f0101501:	88 02                	mov    %al,(%edx)
f0101503:	5d                   	pop    %ebp
f0101504:	c3                   	ret    

f0101505 <printfmt>:
f0101505:	55                   	push   %ebp
f0101506:	89 e5                	mov    %esp,%ebp
f0101508:	83 ec 08             	sub    $0x8,%esp
f010150b:	8d 45 14             	lea    0x14(%ebp),%eax
f010150e:	50                   	push   %eax
f010150f:	ff 75 10             	push   0x10(%ebp)
f0101512:	ff 75 0c             	push   0xc(%ebp)
f0101515:	ff 75 08             	push   0x8(%ebp)
f0101518:	e8 05 00 00 00       	call   f0101522 <vprintfmt>
f010151d:	83 c4 10             	add    $0x10,%esp
f0101520:	c9                   	leave  
f0101521:	c3                   	ret    

f0101522 <vprintfmt>:
f0101522:	55                   	push   %ebp
f0101523:	89 e5                	mov    %esp,%ebp
f0101525:	57                   	push   %edi
f0101526:	56                   	push   %esi
f0101527:	53                   	push   %ebx
f0101528:	83 ec 3c             	sub    $0x3c,%esp
f010152b:	8b 75 08             	mov    0x8(%ebp),%esi
f010152e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101531:	8b 7d 10             	mov    0x10(%ebp),%edi
f0101534:	eb 0a                	jmp    f0101540 <vprintfmt+0x1e>
f0101536:	83 ec 08             	sub    $0x8,%esp
f0101539:	53                   	push   %ebx
f010153a:	50                   	push   %eax
f010153b:	ff d6                	call   *%esi
f010153d:	83 c4 10             	add    $0x10,%esp
f0101540:	47                   	inc    %edi
f0101541:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0101545:	83 f8 25             	cmp    $0x25,%eax
f0101548:	74 0c                	je     f0101556 <vprintfmt+0x34>
f010154a:	85 c0                	test   %eax,%eax
f010154c:	75 e8                	jne    f0101536 <vprintfmt+0x14>
f010154e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101551:	5b                   	pop    %ebx
f0101552:	5e                   	pop    %esi
f0101553:	5f                   	pop    %edi
f0101554:	5d                   	pop    %ebp
f0101555:	c3                   	ret    
f0101556:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
f010155a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0101561:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0101568:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f010156f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101574:	8d 47 01             	lea    0x1(%edi),%eax
f0101577:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010157a:	8a 17                	mov    (%edi),%dl
f010157c:	8d 42 dd             	lea    -0x23(%edx),%eax
f010157f:	3c 55                	cmp    $0x55,%al
f0101581:	0f 87 f2 03 00 00    	ja     f0101979 <vprintfmt+0x457>
f0101587:	0f b6 c0             	movzbl %al,%eax
f010158a:	ff 24 85 d0 2c 10 f0 	jmp    *-0xfefd330(,%eax,4)
f0101591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0101594:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f0101598:	eb da                	jmp    f0101574 <vprintfmt+0x52>
f010159a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010159d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01015a1:	eb d1                	jmp    f0101574 <vprintfmt+0x52>
f01015a3:	0f b6 d2             	movzbl %dl,%edx
f01015a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01015a9:	b8 00 00 00 00       	mov    $0x0,%eax
f01015ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01015b1:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01015b4:	01 c0                	add    %eax,%eax
f01015b6:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
f01015ba:	0f be 17             	movsbl (%edi),%edx
f01015bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01015c0:	83 f9 09             	cmp    $0x9,%ecx
f01015c3:	77 52                	ja     f0101617 <vprintfmt+0xf5>
f01015c5:	47                   	inc    %edi
f01015c6:	eb e9                	jmp    f01015b1 <vprintfmt+0x8f>
f01015c8:	8b 45 14             	mov    0x14(%ebp),%eax
f01015cb:	8b 00                	mov    (%eax),%eax
f01015cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01015d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01015d3:	8d 40 04             	lea    0x4(%eax),%eax
f01015d6:	89 45 14             	mov    %eax,0x14(%ebp)
f01015d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01015dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01015e0:	79 92                	jns    f0101574 <vprintfmt+0x52>
f01015e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01015e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01015e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f01015ef:	eb 83                	jmp    f0101574 <vprintfmt+0x52>
f01015f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01015f5:	78 08                	js     f01015ff <vprintfmt+0xdd>
f01015f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01015fa:	e9 75 ff ff ff       	jmp    f0101574 <vprintfmt+0x52>
f01015ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101606:	eb ef                	jmp    f01015f7 <vprintfmt+0xd5>
f0101608:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010160b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
f0101612:	e9 5d ff ff ff       	jmp    f0101574 <vprintfmt+0x52>
f0101617:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010161a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010161d:	eb bd                	jmp    f01015dc <vprintfmt+0xba>
f010161f:	41                   	inc    %ecx
f0101620:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0101623:	e9 4c ff ff ff       	jmp    f0101574 <vprintfmt+0x52>
f0101628:	8b 45 14             	mov    0x14(%ebp),%eax
f010162b:	8d 78 04             	lea    0x4(%eax),%edi
f010162e:	83 ec 08             	sub    $0x8,%esp
f0101631:	53                   	push   %ebx
f0101632:	ff 30                	push   (%eax)
f0101634:	ff d6                	call   *%esi
f0101636:	83 c4 10             	add    $0x10,%esp
f0101639:	89 7d 14             	mov    %edi,0x14(%ebp)
f010163c:	e9 d7 02 00 00       	jmp    f0101918 <vprintfmt+0x3f6>
f0101641:	8b 45 14             	mov    0x14(%ebp),%eax
f0101644:	8d 78 04             	lea    0x4(%eax),%edi
f0101647:	8b 00                	mov    (%eax),%eax
f0101649:	85 c0                	test   %eax,%eax
f010164b:	78 2a                	js     f0101677 <vprintfmt+0x155>
f010164d:	89 c2                	mov    %eax,%edx
f010164f:	83 f8 06             	cmp    $0x6,%eax
f0101652:	7f 27                	jg     f010167b <vprintfmt+0x159>
f0101654:	8b 04 85 28 2e 10 f0 	mov    -0xfefd1d8(,%eax,4),%eax
f010165b:	85 c0                	test   %eax,%eax
f010165d:	74 1c                	je     f010167b <vprintfmt+0x159>
f010165f:	50                   	push   %eax
f0101660:	68 7c 2a 10 f0       	push   $0xf0102a7c
f0101665:	53                   	push   %ebx
f0101666:	56                   	push   %esi
f0101667:	e8 99 fe ff ff       	call   f0101505 <printfmt>
f010166c:	83 c4 10             	add    $0x10,%esp
f010166f:	89 7d 14             	mov    %edi,0x14(%ebp)
f0101672:	e9 a1 02 00 00       	jmp    f0101918 <vprintfmt+0x3f6>
f0101677:	f7 d8                	neg    %eax
f0101679:	eb d2                	jmp    f010164d <vprintfmt+0x12b>
f010167b:	52                   	push   %edx
f010167c:	68 5d 2c 10 f0       	push   $0xf0102c5d
f0101681:	53                   	push   %ebx
f0101682:	56                   	push   %esi
f0101683:	e8 7d fe ff ff       	call   f0101505 <printfmt>
f0101688:	83 c4 10             	add    $0x10,%esp
f010168b:	89 7d 14             	mov    %edi,0x14(%ebp)
f010168e:	e9 85 02 00 00       	jmp    f0101918 <vprintfmt+0x3f6>
f0101693:	8b 45 14             	mov    0x14(%ebp),%eax
f0101696:	83 c0 04             	add    $0x4,%eax
f0101699:	89 45 c8             	mov    %eax,-0x38(%ebp)
f010169c:	8b 45 14             	mov    0x14(%ebp),%eax
f010169f:	8b 00                	mov    (%eax),%eax
f01016a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01016a4:	85 c0                	test   %eax,%eax
f01016a6:	74 19                	je     f01016c1 <vprintfmt+0x19f>
f01016a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01016ac:	7e 06                	jle    f01016b4 <vprintfmt+0x192>
f01016ae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01016b2:	75 16                	jne    f01016ca <vprintfmt+0x1a8>
f01016b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01016b7:	89 c7                	mov    %eax,%edi
f01016b9:	03 45 d4             	add    -0x2c(%ebp),%eax
f01016bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01016bf:	eb 62                	jmp    f0101723 <vprintfmt+0x201>
f01016c1:	c7 45 cc 56 2c 10 f0 	movl   $0xf0102c56,-0x34(%ebp)
f01016c8:	eb de                	jmp    f01016a8 <vprintfmt+0x186>
f01016ca:	83 ec 08             	sub    $0x8,%esp
f01016cd:	ff 75 d8             	push   -0x28(%ebp)
f01016d0:	ff 75 cc             	push   -0x34(%ebp)
f01016d3:	e8 1e 04 00 00       	call   f0101af6 <strnlen>
f01016d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01016db:	29 c2                	sub    %eax,%edx
f01016dd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f01016e0:	83 c4 10             	add    $0x10,%esp
f01016e3:	89 d7                	mov    %edx,%edi
f01016e5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f01016e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01016ec:	85 ff                	test   %edi,%edi
f01016ee:	7e 0f                	jle    f01016ff <vprintfmt+0x1dd>
f01016f0:	83 ec 08             	sub    $0x8,%esp
f01016f3:	53                   	push   %ebx
f01016f4:	ff 75 d4             	push   -0x2c(%ebp)
f01016f7:	ff d6                	call   *%esi
f01016f9:	4f                   	dec    %edi
f01016fa:	83 c4 10             	add    $0x10,%esp
f01016fd:	eb ed                	jmp    f01016ec <vprintfmt+0x1ca>
f01016ff:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0101702:	89 d0                	mov    %edx,%eax
f0101704:	85 d2                	test   %edx,%edx
f0101706:	78 0a                	js     f0101712 <vprintfmt+0x1f0>
f0101708:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010170b:	29 c2                	sub    %eax,%edx
f010170d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0101710:	eb a2                	jmp    f01016b4 <vprintfmt+0x192>
f0101712:	b8 00 00 00 00       	mov    $0x0,%eax
f0101717:	eb ef                	jmp    f0101708 <vprintfmt+0x1e6>
f0101719:	83 ec 08             	sub    $0x8,%esp
f010171c:	53                   	push   %ebx
f010171d:	52                   	push   %edx
f010171e:	ff d6                	call   *%esi
f0101720:	83 c4 10             	add    $0x10,%esp
f0101723:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101726:	29 f9                	sub    %edi,%ecx
f0101728:	47                   	inc    %edi
f0101729:	8a 47 ff             	mov    -0x1(%edi),%al
f010172c:	0f be d0             	movsbl %al,%edx
f010172f:	85 d2                	test   %edx,%edx
f0101731:	74 48                	je     f010177b <vprintfmt+0x259>
f0101733:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0101737:	78 05                	js     f010173e <vprintfmt+0x21c>
f0101739:	ff 4d d8             	decl   -0x28(%ebp)
f010173c:	78 1e                	js     f010175c <vprintfmt+0x23a>
f010173e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0101742:	74 d5                	je     f0101719 <vprintfmt+0x1f7>
f0101744:	0f be c0             	movsbl %al,%eax
f0101747:	83 e8 20             	sub    $0x20,%eax
f010174a:	83 f8 5e             	cmp    $0x5e,%eax
f010174d:	76 ca                	jbe    f0101719 <vprintfmt+0x1f7>
f010174f:	83 ec 08             	sub    $0x8,%esp
f0101752:	53                   	push   %ebx
f0101753:	6a 3f                	push   $0x3f
f0101755:	ff d6                	call   *%esi
f0101757:	83 c4 10             	add    $0x10,%esp
f010175a:	eb c7                	jmp    f0101723 <vprintfmt+0x201>
f010175c:	89 cf                	mov    %ecx,%edi
f010175e:	eb 0c                	jmp    f010176c <vprintfmt+0x24a>
f0101760:	83 ec 08             	sub    $0x8,%esp
f0101763:	53                   	push   %ebx
f0101764:	6a 20                	push   $0x20
f0101766:	ff d6                	call   *%esi
f0101768:	4f                   	dec    %edi
f0101769:	83 c4 10             	add    $0x10,%esp
f010176c:	85 ff                	test   %edi,%edi
f010176e:	7f f0                	jg     f0101760 <vprintfmt+0x23e>
f0101770:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0101773:	89 45 14             	mov    %eax,0x14(%ebp)
f0101776:	e9 9d 01 00 00       	jmp    f0101918 <vprintfmt+0x3f6>
f010177b:	89 cf                	mov    %ecx,%edi
f010177d:	eb ed                	jmp    f010176c <vprintfmt+0x24a>
f010177f:	83 f9 01             	cmp    $0x1,%ecx
f0101782:	7f 1b                	jg     f010179f <vprintfmt+0x27d>
f0101784:	85 c9                	test   %ecx,%ecx
f0101786:	74 42                	je     f01017ca <vprintfmt+0x2a8>
f0101788:	8b 45 14             	mov    0x14(%ebp),%eax
f010178b:	8b 00                	mov    (%eax),%eax
f010178d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101790:	99                   	cltd   
f0101791:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101794:	8b 45 14             	mov    0x14(%ebp),%eax
f0101797:	8d 40 04             	lea    0x4(%eax),%eax
f010179a:	89 45 14             	mov    %eax,0x14(%ebp)
f010179d:	eb 17                	jmp    f01017b6 <vprintfmt+0x294>
f010179f:	8b 45 14             	mov    0x14(%ebp),%eax
f01017a2:	8b 50 04             	mov    0x4(%eax),%edx
f01017a5:	8b 00                	mov    (%eax),%eax
f01017a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01017aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01017ad:	8b 45 14             	mov    0x14(%ebp),%eax
f01017b0:	8d 40 08             	lea    0x8(%eax),%eax
f01017b3:	89 45 14             	mov    %eax,0x14(%ebp)
f01017b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01017b9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01017bc:	85 c9                	test   %ecx,%ecx
f01017be:	78 21                	js     f01017e1 <vprintfmt+0x2bf>
f01017c0:	bf 0a 00 00 00       	mov    $0xa,%edi
f01017c5:	e9 34 01 00 00       	jmp    f01018fe <vprintfmt+0x3dc>
f01017ca:	8b 45 14             	mov    0x14(%ebp),%eax
f01017cd:	8b 00                	mov    (%eax),%eax
f01017cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01017d2:	99                   	cltd   
f01017d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01017d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01017d9:	8d 40 04             	lea    0x4(%eax),%eax
f01017dc:	89 45 14             	mov    %eax,0x14(%ebp)
f01017df:	eb d5                	jmp    f01017b6 <vprintfmt+0x294>
f01017e1:	83 ec 08             	sub    $0x8,%esp
f01017e4:	53                   	push   %ebx
f01017e5:	6a 2d                	push   $0x2d
f01017e7:	ff d6                	call   *%esi
f01017e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01017ec:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01017ef:	f7 da                	neg    %edx
f01017f1:	83 d1 00             	adc    $0x0,%ecx
f01017f4:	f7 d9                	neg    %ecx
f01017f6:	83 c4 10             	add    $0x10,%esp
f01017f9:	bf 0a 00 00 00       	mov    $0xa,%edi
f01017fe:	e9 fb 00 00 00       	jmp    f01018fe <vprintfmt+0x3dc>
f0101803:	83 f9 01             	cmp    $0x1,%ecx
f0101806:	7f 1e                	jg     f0101826 <vprintfmt+0x304>
f0101808:	85 c9                	test   %ecx,%ecx
f010180a:	74 32                	je     f010183e <vprintfmt+0x31c>
f010180c:	8b 45 14             	mov    0x14(%ebp),%eax
f010180f:	8b 10                	mov    (%eax),%edx
f0101811:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101816:	8d 40 04             	lea    0x4(%eax),%eax
f0101819:	89 45 14             	mov    %eax,0x14(%ebp)
f010181c:	bf 0a 00 00 00       	mov    $0xa,%edi
f0101821:	e9 d8 00 00 00       	jmp    f01018fe <vprintfmt+0x3dc>
f0101826:	8b 45 14             	mov    0x14(%ebp),%eax
f0101829:	8b 10                	mov    (%eax),%edx
f010182b:	8b 48 04             	mov    0x4(%eax),%ecx
f010182e:	8d 40 08             	lea    0x8(%eax),%eax
f0101831:	89 45 14             	mov    %eax,0x14(%ebp)
f0101834:	bf 0a 00 00 00       	mov    $0xa,%edi
f0101839:	e9 c0 00 00 00       	jmp    f01018fe <vprintfmt+0x3dc>
f010183e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101841:	8b 10                	mov    (%eax),%edx
f0101843:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101848:	8d 40 04             	lea    0x4(%eax),%eax
f010184b:	89 45 14             	mov    %eax,0x14(%ebp)
f010184e:	bf 0a 00 00 00       	mov    $0xa,%edi
f0101853:	e9 a6 00 00 00       	jmp    f01018fe <vprintfmt+0x3dc>
f0101858:	83 f9 01             	cmp    $0x1,%ecx
f010185b:	7f 1b                	jg     f0101878 <vprintfmt+0x356>
f010185d:	85 c9                	test   %ecx,%ecx
f010185f:	74 3f                	je     f01018a0 <vprintfmt+0x37e>
f0101861:	8b 45 14             	mov    0x14(%ebp),%eax
f0101864:	8b 00                	mov    (%eax),%eax
f0101866:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101869:	99                   	cltd   
f010186a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010186d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101870:	8d 40 04             	lea    0x4(%eax),%eax
f0101873:	89 45 14             	mov    %eax,0x14(%ebp)
f0101876:	eb 17                	jmp    f010188f <vprintfmt+0x36d>
f0101878:	8b 45 14             	mov    0x14(%ebp),%eax
f010187b:	8b 50 04             	mov    0x4(%eax),%edx
f010187e:	8b 00                	mov    (%eax),%eax
f0101880:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101883:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101886:	8b 45 14             	mov    0x14(%ebp),%eax
f0101889:	8d 40 08             	lea    0x8(%eax),%eax
f010188c:	89 45 14             	mov    %eax,0x14(%ebp)
f010188f:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101892:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101895:	85 c9                	test   %ecx,%ecx
f0101897:	78 1e                	js     f01018b7 <vprintfmt+0x395>
f0101899:	bf 08 00 00 00       	mov    $0x8,%edi
f010189e:	eb 5e                	jmp    f01018fe <vprintfmt+0x3dc>
f01018a0:	8b 45 14             	mov    0x14(%ebp),%eax
f01018a3:	8b 00                	mov    (%eax),%eax
f01018a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01018a8:	99                   	cltd   
f01018a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01018ac:	8b 45 14             	mov    0x14(%ebp),%eax
f01018af:	8d 40 04             	lea    0x4(%eax),%eax
f01018b2:	89 45 14             	mov    %eax,0x14(%ebp)
f01018b5:	eb d8                	jmp    f010188f <vprintfmt+0x36d>
f01018b7:	83 ec 08             	sub    $0x8,%esp
f01018ba:	53                   	push   %ebx
f01018bb:	6a 2d                	push   $0x2d
f01018bd:	ff d6                	call   *%esi
f01018bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01018c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01018c5:	f7 da                	neg    %edx
f01018c7:	83 d1 00             	adc    $0x0,%ecx
f01018ca:	f7 d9                	neg    %ecx
f01018cc:	83 c4 10             	add    $0x10,%esp
f01018cf:	bf 08 00 00 00       	mov    $0x8,%edi
f01018d4:	eb 28                	jmp    f01018fe <vprintfmt+0x3dc>
f01018d6:	83 ec 08             	sub    $0x8,%esp
f01018d9:	53                   	push   %ebx
f01018da:	6a 30                	push   $0x30
f01018dc:	ff d6                	call   *%esi
f01018de:	83 c4 08             	add    $0x8,%esp
f01018e1:	53                   	push   %ebx
f01018e2:	6a 78                	push   $0x78
f01018e4:	ff d6                	call   *%esi
f01018e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01018e9:	8b 10                	mov    (%eax),%edx
f01018eb:	b9 00 00 00 00       	mov    $0x0,%ecx
f01018f0:	83 c4 10             	add    $0x10,%esp
f01018f3:	8d 40 04             	lea    0x4(%eax),%eax
f01018f6:	89 45 14             	mov    %eax,0x14(%ebp)
f01018f9:	bf 10 00 00 00       	mov    $0x10,%edi
f01018fe:	83 ec 0c             	sub    $0xc,%esp
f0101901:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0101905:	50                   	push   %eax
f0101906:	ff 75 d4             	push   -0x2c(%ebp)
f0101909:	57                   	push   %edi
f010190a:	51                   	push   %ecx
f010190b:	52                   	push   %edx
f010190c:	89 da                	mov    %ebx,%edx
f010190e:	89 f0                	mov    %esi,%eax
f0101910:	e8 2f fb ff ff       	call   f0101444 <printnum>
f0101915:	83 c4 20             	add    $0x20,%esp
f0101918:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010191b:	e9 20 fc ff ff       	jmp    f0101540 <vprintfmt+0x1e>
f0101920:	83 f9 01             	cmp    $0x1,%ecx
f0101923:	7f 1b                	jg     f0101940 <vprintfmt+0x41e>
f0101925:	85 c9                	test   %ecx,%ecx
f0101927:	74 2c                	je     f0101955 <vprintfmt+0x433>
f0101929:	8b 45 14             	mov    0x14(%ebp),%eax
f010192c:	8b 10                	mov    (%eax),%edx
f010192e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101933:	8d 40 04             	lea    0x4(%eax),%eax
f0101936:	89 45 14             	mov    %eax,0x14(%ebp)
f0101939:	bf 10 00 00 00       	mov    $0x10,%edi
f010193e:	eb be                	jmp    f01018fe <vprintfmt+0x3dc>
f0101940:	8b 45 14             	mov    0x14(%ebp),%eax
f0101943:	8b 10                	mov    (%eax),%edx
f0101945:	8b 48 04             	mov    0x4(%eax),%ecx
f0101948:	8d 40 08             	lea    0x8(%eax),%eax
f010194b:	89 45 14             	mov    %eax,0x14(%ebp)
f010194e:	bf 10 00 00 00       	mov    $0x10,%edi
f0101953:	eb a9                	jmp    f01018fe <vprintfmt+0x3dc>
f0101955:	8b 45 14             	mov    0x14(%ebp),%eax
f0101958:	8b 10                	mov    (%eax),%edx
f010195a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010195f:	8d 40 04             	lea    0x4(%eax),%eax
f0101962:	89 45 14             	mov    %eax,0x14(%ebp)
f0101965:	bf 10 00 00 00       	mov    $0x10,%edi
f010196a:	eb 92                	jmp    f01018fe <vprintfmt+0x3dc>
f010196c:	83 ec 08             	sub    $0x8,%esp
f010196f:	53                   	push   %ebx
f0101970:	6a 25                	push   $0x25
f0101972:	ff d6                	call   *%esi
f0101974:	83 c4 10             	add    $0x10,%esp
f0101977:	eb 9f                	jmp    f0101918 <vprintfmt+0x3f6>
f0101979:	83 ec 08             	sub    $0x8,%esp
f010197c:	53                   	push   %ebx
f010197d:	6a 25                	push   $0x25
f010197f:	ff d6                	call   *%esi
f0101981:	83 c4 10             	add    $0x10,%esp
f0101984:	89 f8                	mov    %edi,%eax
f0101986:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010198a:	74 03                	je     f010198f <vprintfmt+0x46d>
f010198c:	48                   	dec    %eax
f010198d:	eb f7                	jmp    f0101986 <vprintfmt+0x464>
f010198f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101992:	eb 84                	jmp    f0101918 <vprintfmt+0x3f6>

f0101994 <vsnprintf>:
f0101994:	55                   	push   %ebp
f0101995:	89 e5                	mov    %esp,%ebp
f0101997:	83 ec 18             	sub    $0x18,%esp
f010199a:	8b 45 08             	mov    0x8(%ebp),%eax
f010199d:	8b 55 0c             	mov    0xc(%ebp),%edx
f01019a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01019a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01019a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01019aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01019b1:	85 c0                	test   %eax,%eax
f01019b3:	74 26                	je     f01019db <vsnprintf+0x47>
f01019b5:	85 d2                	test   %edx,%edx
f01019b7:	7e 29                	jle    f01019e2 <vsnprintf+0x4e>
f01019b9:	ff 75 14             	push   0x14(%ebp)
f01019bc:	ff 75 10             	push   0x10(%ebp)
f01019bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01019c2:	50                   	push   %eax
f01019c3:	68 e9 14 10 f0       	push   $0xf01014e9
f01019c8:	e8 55 fb ff ff       	call   f0101522 <vprintfmt>
f01019cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01019d0:	c6 00 00             	movb   $0x0,(%eax)
f01019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01019d6:	83 c4 10             	add    $0x10,%esp
f01019d9:	c9                   	leave  
f01019da:	c3                   	ret    
f01019db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01019e0:	eb f7                	jmp    f01019d9 <vsnprintf+0x45>
f01019e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01019e7:	eb f0                	jmp    f01019d9 <vsnprintf+0x45>

f01019e9 <snprintf>:
f01019e9:	55                   	push   %ebp
f01019ea:	89 e5                	mov    %esp,%ebp
f01019ec:	83 ec 08             	sub    $0x8,%esp
f01019ef:	8d 45 14             	lea    0x14(%ebp),%eax
f01019f2:	50                   	push   %eax
f01019f3:	ff 75 10             	push   0x10(%ebp)
f01019f6:	ff 75 0c             	push   0xc(%ebp)
f01019f9:	ff 75 08             	push   0x8(%ebp)
f01019fc:	e8 93 ff ff ff       	call   f0101994 <vsnprintf>
f0101a01:	c9                   	leave  
f0101a02:	c3                   	ret    

f0101a03 <readline>:
f0101a03:	55                   	push   %ebp
f0101a04:	89 e5                	mov    %esp,%ebp
f0101a06:	57                   	push   %edi
f0101a07:	56                   	push   %esi
f0101a08:	53                   	push   %ebx
f0101a09:	83 ec 0c             	sub    $0xc,%esp
f0101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a0f:	85 c0                	test   %eax,%eax
f0101a11:	74 11                	je     f0101a24 <readline+0x21>
f0101a13:	83 ec 08             	sub    $0x8,%esp
f0101a16:	50                   	push   %eax
f0101a17:	68 7c 2a 10 f0       	push   $0xf0102a7c
f0101a1c:	e8 c0 f6 ff ff       	call   f01010e1 <cprintf>
f0101a21:	83 c4 10             	add    $0x10,%esp
f0101a24:	83 ec 0c             	sub    $0xc,%esp
f0101a27:	6a 00                	push   $0x0
f0101a29:	e8 5f ec ff ff       	call   f010068d <iscons>
f0101a2e:	89 c7                	mov    %eax,%edi
f0101a30:	83 c4 10             	add    $0x10,%esp
f0101a33:	be 00 00 00 00       	mov    $0x0,%esi
f0101a38:	eb 75                	jmp    f0101aaf <readline+0xac>
f0101a3a:	83 ec 08             	sub    $0x8,%esp
f0101a3d:	50                   	push   %eax
f0101a3e:	68 44 2e 10 f0       	push   $0xf0102e44
f0101a43:	e8 99 f6 ff ff       	call   f01010e1 <cprintf>
f0101a48:	83 c4 10             	add    $0x10,%esp
f0101a4b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101a53:	5b                   	pop    %ebx
f0101a54:	5e                   	pop    %esi
f0101a55:	5f                   	pop    %edi
f0101a56:	5d                   	pop    %ebp
f0101a57:	c3                   	ret    
f0101a58:	83 ec 0c             	sub    $0xc,%esp
f0101a5b:	6a 08                	push   $0x8
f0101a5d:	e8 0a ec ff ff       	call   f010066c <cputchar>
f0101a62:	83 c4 10             	add    $0x10,%esp
f0101a65:	eb 47                	jmp    f0101aae <readline+0xab>
f0101a67:	83 ec 0c             	sub    $0xc,%esp
f0101a6a:	53                   	push   %ebx
f0101a6b:	e8 fc eb ff ff       	call   f010066c <cputchar>
f0101a70:	83 c4 10             	add    $0x10,%esp
f0101a73:	eb 60                	jmp    f0101ad5 <readline+0xd2>
f0101a75:	83 f8 0a             	cmp    $0xa,%eax
f0101a78:	74 05                	je     f0101a7f <readline+0x7c>
f0101a7a:	83 f8 0d             	cmp    $0xd,%eax
f0101a7d:	75 30                	jne    f0101aaf <readline+0xac>
f0101a7f:	85 ff                	test   %edi,%edi
f0101a81:	75 0e                	jne    f0101a91 <readline+0x8e>
f0101a83:	c6 86 80 45 11 f0 00 	movb   $0x0,-0xfeeba80(%esi)
f0101a8a:	b8 80 45 11 f0       	mov    $0xf0114580,%eax
f0101a8f:	eb bf                	jmp    f0101a50 <readline+0x4d>
f0101a91:	83 ec 0c             	sub    $0xc,%esp
f0101a94:	6a 0a                	push   $0xa
f0101a96:	e8 d1 eb ff ff       	call   f010066c <cputchar>
f0101a9b:	83 c4 10             	add    $0x10,%esp
f0101a9e:	eb e3                	jmp    f0101a83 <readline+0x80>
f0101aa0:	85 f6                	test   %esi,%esi
f0101aa2:	7f 06                	jg     f0101aaa <readline+0xa7>
f0101aa4:	eb 23                	jmp    f0101ac9 <readline+0xc6>
f0101aa6:	85 f6                	test   %esi,%esi
f0101aa8:	7e 05                	jle    f0101aaf <readline+0xac>
f0101aaa:	85 ff                	test   %edi,%edi
f0101aac:	75 aa                	jne    f0101a58 <readline+0x55>
f0101aae:	4e                   	dec    %esi
f0101aaf:	e8 c8 eb ff ff       	call   f010067c <getchar>
f0101ab4:	89 c3                	mov    %eax,%ebx
f0101ab6:	85 c0                	test   %eax,%eax
f0101ab8:	78 80                	js     f0101a3a <readline+0x37>
f0101aba:	83 f8 08             	cmp    $0x8,%eax
f0101abd:	74 e7                	je     f0101aa6 <readline+0xa3>
f0101abf:	83 f8 7f             	cmp    $0x7f,%eax
f0101ac2:	74 dc                	je     f0101aa0 <readline+0x9d>
f0101ac4:	83 f8 1f             	cmp    $0x1f,%eax
f0101ac7:	7e ac                	jle    f0101a75 <readline+0x72>
f0101ac9:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101acf:	7f de                	jg     f0101aaf <readline+0xac>
f0101ad1:	85 ff                	test   %edi,%edi
f0101ad3:	75 92                	jne    f0101a67 <readline+0x64>
f0101ad5:	88 9e 80 45 11 f0    	mov    %bl,-0xfeeba80(%esi)
f0101adb:	8d 76 01             	lea    0x1(%esi),%esi
f0101ade:	eb cf                	jmp    f0101aaf <readline+0xac>

f0101ae0 <strlen>:
f0101ae0:	55                   	push   %ebp
f0101ae1:	89 e5                	mov    %esp,%ebp
f0101ae3:	8b 55 08             	mov    0x8(%ebp),%edx
f0101ae6:	b8 00 00 00 00       	mov    $0x0,%eax
f0101aeb:	eb 01                	jmp    f0101aee <strlen+0xe>
f0101aed:	40                   	inc    %eax
f0101aee:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0101af2:	75 f9                	jne    f0101aed <strlen+0xd>
f0101af4:	5d                   	pop    %ebp
f0101af5:	c3                   	ret    

f0101af6 <strnlen>:
f0101af6:	55                   	push   %ebp
f0101af7:	89 e5                	mov    %esp,%ebp
f0101af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101afc:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101aff:	b8 00 00 00 00       	mov    $0x0,%eax
f0101b04:	eb 01                	jmp    f0101b07 <strnlen+0x11>
f0101b06:	40                   	inc    %eax
f0101b07:	39 d0                	cmp    %edx,%eax
f0101b09:	74 08                	je     f0101b13 <strnlen+0x1d>
f0101b0b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0101b0f:	75 f5                	jne    f0101b06 <strnlen+0x10>
f0101b11:	89 c2                	mov    %eax,%edx
f0101b13:	89 d0                	mov    %edx,%eax
f0101b15:	5d                   	pop    %ebp
f0101b16:	c3                   	ret    

f0101b17 <strcpy>:
f0101b17:	55                   	push   %ebp
f0101b18:	89 e5                	mov    %esp,%ebp
f0101b1a:	53                   	push   %ebx
f0101b1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101b1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101b21:	b8 00 00 00 00       	mov    $0x0,%eax
f0101b26:	8a 14 03             	mov    (%ebx,%eax,1),%dl
f0101b29:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0101b2c:	40                   	inc    %eax
f0101b2d:	84 d2                	test   %dl,%dl
f0101b2f:	75 f5                	jne    f0101b26 <strcpy+0xf>
f0101b31:	89 c8                	mov    %ecx,%eax
f0101b33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101b36:	c9                   	leave  
f0101b37:	c3                   	ret    

f0101b38 <strcat>:
f0101b38:	55                   	push   %ebp
f0101b39:	89 e5                	mov    %esp,%ebp
f0101b3b:	53                   	push   %ebx
f0101b3c:	83 ec 10             	sub    $0x10,%esp
f0101b3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101b42:	53                   	push   %ebx
f0101b43:	e8 98 ff ff ff       	call   f0101ae0 <strlen>
f0101b48:	83 c4 08             	add    $0x8,%esp
f0101b4b:	ff 75 0c             	push   0xc(%ebp)
f0101b4e:	01 d8                	add    %ebx,%eax
f0101b50:	50                   	push   %eax
f0101b51:	e8 c1 ff ff ff       	call   f0101b17 <strcpy>
f0101b56:	89 d8                	mov    %ebx,%eax
f0101b58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101b5b:	c9                   	leave  
f0101b5c:	c3                   	ret    

f0101b5d <strncpy>:
f0101b5d:	55                   	push   %ebp
f0101b5e:	89 e5                	mov    %esp,%ebp
f0101b60:	53                   	push   %ebx
f0101b61:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101b64:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101b67:	03 5d 10             	add    0x10(%ebp),%ebx
f0101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b6d:	eb 0c                	jmp    f0101b7b <strncpy+0x1e>
f0101b6f:	40                   	inc    %eax
f0101b70:	8a 0a                	mov    (%edx),%cl
f0101b72:	88 48 ff             	mov    %cl,-0x1(%eax)
f0101b75:	80 f9 01             	cmp    $0x1,%cl
f0101b78:	83 da ff             	sbb    $0xffffffff,%edx
f0101b7b:	39 d8                	cmp    %ebx,%eax
f0101b7d:	75 f0                	jne    f0101b6f <strncpy+0x12>
f0101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101b85:	c9                   	leave  
f0101b86:	c3                   	ret    

f0101b87 <strlcpy>:
f0101b87:	55                   	push   %ebp
f0101b88:	89 e5                	mov    %esp,%ebp
f0101b8a:	56                   	push   %esi
f0101b8b:	53                   	push   %ebx
f0101b8c:	8b 75 08             	mov    0x8(%ebp),%esi
f0101b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101b92:	8b 45 10             	mov    0x10(%ebp),%eax
f0101b95:	85 c0                	test   %eax,%eax
f0101b97:	74 22                	je     f0101bbb <strlcpy+0x34>
f0101b99:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
f0101b9d:	89 f2                	mov    %esi,%edx
f0101b9f:	eb 05                	jmp    f0101ba6 <strlcpy+0x1f>
f0101ba1:	41                   	inc    %ecx
f0101ba2:	42                   	inc    %edx
f0101ba3:	88 5a ff             	mov    %bl,-0x1(%edx)
f0101ba6:	39 c2                	cmp    %eax,%edx
f0101ba8:	74 08                	je     f0101bb2 <strlcpy+0x2b>
f0101baa:	8a 19                	mov    (%ecx),%bl
f0101bac:	84 db                	test   %bl,%bl
f0101bae:	75 f1                	jne    f0101ba1 <strlcpy+0x1a>
f0101bb0:	89 d0                	mov    %edx,%eax
f0101bb2:	c6 00 00             	movb   $0x0,(%eax)
f0101bb5:	29 f0                	sub    %esi,%eax
f0101bb7:	5b                   	pop    %ebx
f0101bb8:	5e                   	pop    %esi
f0101bb9:	5d                   	pop    %ebp
f0101bba:	c3                   	ret    
f0101bbb:	89 f0                	mov    %esi,%eax
f0101bbd:	eb f6                	jmp    f0101bb5 <strlcpy+0x2e>

f0101bbf <strcmp>:
f0101bbf:	55                   	push   %ebp
f0101bc0:	89 e5                	mov    %esp,%ebp
f0101bc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101bc8:	eb 02                	jmp    f0101bcc <strcmp+0xd>
f0101bca:	41                   	inc    %ecx
f0101bcb:	42                   	inc    %edx
f0101bcc:	8a 01                	mov    (%ecx),%al
f0101bce:	84 c0                	test   %al,%al
f0101bd0:	74 04                	je     f0101bd6 <strcmp+0x17>
f0101bd2:	3a 02                	cmp    (%edx),%al
f0101bd4:	74 f4                	je     f0101bca <strcmp+0xb>
f0101bd6:	0f b6 c0             	movzbl %al,%eax
f0101bd9:	0f b6 12             	movzbl (%edx),%edx
f0101bdc:	29 d0                	sub    %edx,%eax
f0101bde:	5d                   	pop    %ebp
f0101bdf:	c3                   	ret    

f0101be0 <strncmp>:
f0101be0:	55                   	push   %ebp
f0101be1:	89 e5                	mov    %esp,%ebp
f0101be3:	53                   	push   %ebx
f0101be4:	8b 45 08             	mov    0x8(%ebp),%eax
f0101be7:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101bea:	89 c3                	mov    %eax,%ebx
f0101bec:	03 5d 10             	add    0x10(%ebp),%ebx
f0101bef:	eb 02                	jmp    f0101bf3 <strncmp+0x13>
f0101bf1:	40                   	inc    %eax
f0101bf2:	42                   	inc    %edx
f0101bf3:	39 d8                	cmp    %ebx,%eax
f0101bf5:	74 17                	je     f0101c0e <strncmp+0x2e>
f0101bf7:	8a 08                	mov    (%eax),%cl
f0101bf9:	84 c9                	test   %cl,%cl
f0101bfb:	74 04                	je     f0101c01 <strncmp+0x21>
f0101bfd:	3a 0a                	cmp    (%edx),%cl
f0101bff:	74 f0                	je     f0101bf1 <strncmp+0x11>
f0101c01:	0f b6 00             	movzbl (%eax),%eax
f0101c04:	0f b6 12             	movzbl (%edx),%edx
f0101c07:	29 d0                	sub    %edx,%eax
f0101c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101c0c:	c9                   	leave  
f0101c0d:	c3                   	ret    
f0101c0e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101c13:	eb f4                	jmp    f0101c09 <strncmp+0x29>

f0101c15 <strchr>:
f0101c15:	55                   	push   %ebp
f0101c16:	89 e5                	mov    %esp,%ebp
f0101c18:	8b 45 08             	mov    0x8(%ebp),%eax
f0101c1b:	8a 4d 0c             	mov    0xc(%ebp),%cl
f0101c1e:	eb 01                	jmp    f0101c21 <strchr+0xc>
f0101c20:	40                   	inc    %eax
f0101c21:	8a 10                	mov    (%eax),%dl
f0101c23:	84 d2                	test   %dl,%dl
f0101c25:	74 06                	je     f0101c2d <strchr+0x18>
f0101c27:	38 ca                	cmp    %cl,%dl
f0101c29:	75 f5                	jne    f0101c20 <strchr+0xb>
f0101c2b:	eb 05                	jmp    f0101c32 <strchr+0x1d>
f0101c2d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101c32:	5d                   	pop    %ebp
f0101c33:	c3                   	ret    

f0101c34 <strfind>:
f0101c34:	55                   	push   %ebp
f0101c35:	89 e5                	mov    %esp,%ebp
f0101c37:	8b 45 08             	mov    0x8(%ebp),%eax
f0101c3a:	8a 4d 0c             	mov    0xc(%ebp),%cl
f0101c3d:	eb 01                	jmp    f0101c40 <strfind+0xc>
f0101c3f:	40                   	inc    %eax
f0101c40:	8a 10                	mov    (%eax),%dl
f0101c42:	84 d2                	test   %dl,%dl
f0101c44:	74 04                	je     f0101c4a <strfind+0x16>
f0101c46:	38 ca                	cmp    %cl,%dl
f0101c48:	75 f5                	jne    f0101c3f <strfind+0xb>
f0101c4a:	5d                   	pop    %ebp
f0101c4b:	c3                   	ret    

f0101c4c <memset>:
f0101c4c:	55                   	push   %ebp
f0101c4d:	89 e5                	mov    %esp,%ebp
f0101c4f:	57                   	push   %edi
f0101c50:	56                   	push   %esi
f0101c51:	53                   	push   %ebx
f0101c52:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101c55:	85 c9                	test   %ecx,%ecx
f0101c57:	74 36                	je     f0101c8f <memset+0x43>
f0101c59:	89 c8                	mov    %ecx,%eax
f0101c5b:	0b 45 08             	or     0x8(%ebp),%eax
f0101c5e:	a8 03                	test   $0x3,%al
f0101c60:	75 24                	jne    f0101c86 <memset+0x3a>
f0101c62:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
f0101c66:	89 d8                	mov    %ebx,%eax
f0101c68:	c1 e0 08             	shl    $0x8,%eax
f0101c6b:	89 da                	mov    %ebx,%edx
f0101c6d:	c1 e2 18             	shl    $0x18,%edx
f0101c70:	89 de                	mov    %ebx,%esi
f0101c72:	c1 e6 10             	shl    $0x10,%esi
f0101c75:	09 f2                	or     %esi,%edx
f0101c77:	09 da                	or     %ebx,%edx
f0101c79:	09 d0                	or     %edx,%eax
f0101c7b:	c1 e9 02             	shr    $0x2,%ecx
f0101c7e:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101c81:	fc                   	cld    
f0101c82:	f3 ab                	rep stos %eax,%es:(%edi)
f0101c84:	eb 09                	jmp    f0101c8f <memset+0x43>
f0101c86:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101c89:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101c8c:	fc                   	cld    
f0101c8d:	f3 aa                	rep stos %al,%es:(%edi)
f0101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101c92:	5b                   	pop    %ebx
f0101c93:	5e                   	pop    %esi
f0101c94:	5f                   	pop    %edi
f0101c95:	5d                   	pop    %ebp
f0101c96:	c3                   	ret    

f0101c97 <memmove>:
f0101c97:	55                   	push   %ebp
f0101c98:	89 e5                	mov    %esp,%ebp
f0101c9a:	57                   	push   %edi
f0101c9b:	56                   	push   %esi
f0101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
f0101c9f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101ca2:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101ca5:	39 c6                	cmp    %eax,%esi
f0101ca7:	73 30                	jae    f0101cd9 <memmove+0x42>
f0101ca9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0101cac:	39 c2                	cmp    %eax,%edx
f0101cae:	76 29                	jbe    f0101cd9 <memmove+0x42>
f0101cb0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0101cb3:	89 d6                	mov    %edx,%esi
f0101cb5:	09 fe                	or     %edi,%esi
f0101cb7:	09 ce                	or     %ecx,%esi
f0101cb9:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101cbf:	75 0e                	jne    f0101ccf <memmove+0x38>
f0101cc1:	83 ef 04             	sub    $0x4,%edi
f0101cc4:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101cc7:	c1 e9 02             	shr    $0x2,%ecx
f0101cca:	fd                   	std    
f0101ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101ccd:	eb 07                	jmp    f0101cd6 <memmove+0x3f>
f0101ccf:	4f                   	dec    %edi
f0101cd0:	8d 72 ff             	lea    -0x1(%edx),%esi
f0101cd3:	fd                   	std    
f0101cd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0101cd6:	fc                   	cld    
f0101cd7:	eb 1a                	jmp    f0101cf3 <memmove+0x5c>
f0101cd9:	89 f2                	mov    %esi,%edx
f0101cdb:	09 c2                	or     %eax,%edx
f0101cdd:	09 ca                	or     %ecx,%edx
f0101cdf:	f6 c2 03             	test   $0x3,%dl
f0101ce2:	75 0a                	jne    f0101cee <memmove+0x57>
f0101ce4:	c1 e9 02             	shr    $0x2,%ecx
f0101ce7:	89 c7                	mov    %eax,%edi
f0101ce9:	fc                   	cld    
f0101cea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101cec:	eb 05                	jmp    f0101cf3 <memmove+0x5c>
f0101cee:	89 c7                	mov    %eax,%edi
f0101cf0:	fc                   	cld    
f0101cf1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f0101cf3:	5e                   	pop    %esi
f0101cf4:	5f                   	pop    %edi
f0101cf5:	5d                   	pop    %ebp
f0101cf6:	c3                   	ret    

f0101cf7 <memcpy>:
f0101cf7:	55                   	push   %ebp
f0101cf8:	89 e5                	mov    %esp,%ebp
f0101cfa:	83 ec 0c             	sub    $0xc,%esp
f0101cfd:	ff 75 10             	push   0x10(%ebp)
f0101d00:	ff 75 0c             	push   0xc(%ebp)
f0101d03:	ff 75 08             	push   0x8(%ebp)
f0101d06:	e8 8c ff ff ff       	call   f0101c97 <memmove>
f0101d0b:	c9                   	leave  
f0101d0c:	c3                   	ret    

f0101d0d <memcmp>:
f0101d0d:	55                   	push   %ebp
f0101d0e:	89 e5                	mov    %esp,%ebp
f0101d10:	56                   	push   %esi
f0101d11:	53                   	push   %ebx
f0101d12:	8b 45 08             	mov    0x8(%ebp),%eax
f0101d15:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101d18:	89 c6                	mov    %eax,%esi
f0101d1a:	03 75 10             	add    0x10(%ebp),%esi
f0101d1d:	eb 02                	jmp    f0101d21 <memcmp+0x14>
f0101d1f:	40                   	inc    %eax
f0101d20:	42                   	inc    %edx
f0101d21:	39 f0                	cmp    %esi,%eax
f0101d23:	74 12                	je     f0101d37 <memcmp+0x2a>
f0101d25:	8a 08                	mov    (%eax),%cl
f0101d27:	8a 1a                	mov    (%edx),%bl
f0101d29:	38 d9                	cmp    %bl,%cl
f0101d2b:	74 f2                	je     f0101d1f <memcmp+0x12>
f0101d2d:	0f b6 c1             	movzbl %cl,%eax
f0101d30:	0f b6 db             	movzbl %bl,%ebx
f0101d33:	29 d8                	sub    %ebx,%eax
f0101d35:	eb 05                	jmp    f0101d3c <memcmp+0x2f>
f0101d37:	b8 00 00 00 00       	mov    $0x0,%eax
f0101d3c:	5b                   	pop    %ebx
f0101d3d:	5e                   	pop    %esi
f0101d3e:	5d                   	pop    %ebp
f0101d3f:	c3                   	ret    

f0101d40 <memfind>:
f0101d40:	55                   	push   %ebp
f0101d41:	89 e5                	mov    %esp,%ebp
f0101d43:	8b 45 08             	mov    0x8(%ebp),%eax
f0101d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101d49:	89 c2                	mov    %eax,%edx
f0101d4b:	03 55 10             	add    0x10(%ebp),%edx
f0101d4e:	eb 01                	jmp    f0101d51 <memfind+0x11>
f0101d50:	40                   	inc    %eax
f0101d51:	39 d0                	cmp    %edx,%eax
f0101d53:	73 04                	jae    f0101d59 <memfind+0x19>
f0101d55:	38 08                	cmp    %cl,(%eax)
f0101d57:	75 f7                	jne    f0101d50 <memfind+0x10>
f0101d59:	5d                   	pop    %ebp
f0101d5a:	c3                   	ret    

f0101d5b <strtol>:
f0101d5b:	55                   	push   %ebp
f0101d5c:	89 e5                	mov    %esp,%ebp
f0101d5e:	57                   	push   %edi
f0101d5f:	56                   	push   %esi
f0101d60:	53                   	push   %ebx
f0101d61:	8b 55 08             	mov    0x8(%ebp),%edx
f0101d64:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101d67:	eb 01                	jmp    f0101d6a <strtol+0xf>
f0101d69:	42                   	inc    %edx
f0101d6a:	8a 02                	mov    (%edx),%al
f0101d6c:	3c 20                	cmp    $0x20,%al
f0101d6e:	74 f9                	je     f0101d69 <strtol+0xe>
f0101d70:	3c 09                	cmp    $0x9,%al
f0101d72:	74 f5                	je     f0101d69 <strtol+0xe>
f0101d74:	3c 2b                	cmp    $0x2b,%al
f0101d76:	74 24                	je     f0101d9c <strtol+0x41>
f0101d78:	3c 2d                	cmp    $0x2d,%al
f0101d7a:	74 28                	je     f0101da4 <strtol+0x49>
f0101d7c:	bf 00 00 00 00       	mov    $0x0,%edi
f0101d81:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0101d87:	75 09                	jne    f0101d92 <strtol+0x37>
f0101d89:	80 3a 30             	cmpb   $0x30,(%edx)
f0101d8c:	74 1e                	je     f0101dac <strtol+0x51>
f0101d8e:	85 db                	test   %ebx,%ebx
f0101d90:	74 36                	je     f0101dc8 <strtol+0x6d>
f0101d92:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101d97:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0101d9a:	eb 45                	jmp    f0101de1 <strtol+0x86>
f0101d9c:	42                   	inc    %edx
f0101d9d:	bf 00 00 00 00       	mov    $0x0,%edi
f0101da2:	eb dd                	jmp    f0101d81 <strtol+0x26>
f0101da4:	42                   	inc    %edx
f0101da5:	bf 01 00 00 00       	mov    $0x1,%edi
f0101daa:	eb d5                	jmp    f0101d81 <strtol+0x26>
f0101dac:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0101db0:	74 0c                	je     f0101dbe <strtol+0x63>
f0101db2:	85 db                	test   %ebx,%ebx
f0101db4:	75 dc                	jne    f0101d92 <strtol+0x37>
f0101db6:	42                   	inc    %edx
f0101db7:	bb 08 00 00 00       	mov    $0x8,%ebx
f0101dbc:	eb d4                	jmp    f0101d92 <strtol+0x37>
f0101dbe:	83 c2 02             	add    $0x2,%edx
f0101dc1:	bb 10 00 00 00       	mov    $0x10,%ebx
f0101dc6:	eb ca                	jmp    f0101d92 <strtol+0x37>
f0101dc8:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0101dcd:	eb c3                	jmp    f0101d92 <strtol+0x37>
f0101dcf:	0f be c0             	movsbl %al,%eax
f0101dd2:	83 e8 30             	sub    $0x30,%eax
f0101dd5:	3b 45 10             	cmp    0x10(%ebp),%eax
f0101dd8:	7d 37                	jge    f0101e11 <strtol+0xb6>
f0101dda:	42                   	inc    %edx
f0101ddb:	0f af 4d 10          	imul   0x10(%ebp),%ecx
f0101ddf:	01 c1                	add    %eax,%ecx
f0101de1:	8a 02                	mov    (%edx),%al
f0101de3:	8d 70 d0             	lea    -0x30(%eax),%esi
f0101de6:	89 f3                	mov    %esi,%ebx
f0101de8:	80 fb 09             	cmp    $0x9,%bl
f0101deb:	76 e2                	jbe    f0101dcf <strtol+0x74>
f0101ded:	8d 70 9f             	lea    -0x61(%eax),%esi
f0101df0:	89 f3                	mov    %esi,%ebx
f0101df2:	80 fb 19             	cmp    $0x19,%bl
f0101df5:	77 08                	ja     f0101dff <strtol+0xa4>
f0101df7:	0f be c0             	movsbl %al,%eax
f0101dfa:	83 e8 57             	sub    $0x57,%eax
f0101dfd:	eb d6                	jmp    f0101dd5 <strtol+0x7a>
f0101dff:	8d 70 bf             	lea    -0x41(%eax),%esi
f0101e02:	89 f3                	mov    %esi,%ebx
f0101e04:	80 fb 19             	cmp    $0x19,%bl
f0101e07:	77 08                	ja     f0101e11 <strtol+0xb6>
f0101e09:	0f be c0             	movsbl %al,%eax
f0101e0c:	83 e8 37             	sub    $0x37,%eax
f0101e0f:	eb c4                	jmp    f0101dd5 <strtol+0x7a>
f0101e11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101e15:	74 05                	je     f0101e1c <strtol+0xc1>
f0101e17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101e1a:	89 10                	mov    %edx,(%eax)
f0101e1c:	85 ff                	test   %edi,%edi
f0101e1e:	74 02                	je     f0101e22 <strtol+0xc7>
f0101e20:	f7 d9                	neg    %ecx
f0101e22:	89 c8                	mov    %ecx,%eax
f0101e24:	5b                   	pop    %ebx
f0101e25:	5e                   	pop    %esi
f0101e26:	5f                   	pop    %edi
f0101e27:	5d                   	pop    %ebp
f0101e28:	c3                   	ret    
f0101e29:	66 90                	xchg   %ax,%ax
f0101e2b:	90                   	nop

f0101e2c <__udivdi3>:
f0101e2c:	55                   	push   %ebp
f0101e2d:	89 e5                	mov    %esp,%ebp
f0101e2f:	57                   	push   %edi
f0101e30:	56                   	push   %esi
f0101e31:	53                   	push   %ebx
f0101e32:	83 ec 1c             	sub    $0x1c,%esp
f0101e35:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101e38:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0101e3b:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101e3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101e41:	8b 45 14             	mov    0x14(%ebp),%eax
f0101e44:	85 c0                	test   %eax,%eax
f0101e46:	75 18                	jne    f0101e60 <__udivdi3+0x34>
f0101e48:	39 f3                	cmp    %esi,%ebx
f0101e4a:	76 44                	jbe    f0101e90 <__udivdi3+0x64>
f0101e4c:	89 f8                	mov    %edi,%eax
f0101e4e:	89 f2                	mov    %esi,%edx
f0101e50:	f7 f3                	div    %ebx
f0101e52:	31 ff                	xor    %edi,%edi
f0101e54:	89 fa                	mov    %edi,%edx
f0101e56:	83 c4 1c             	add    $0x1c,%esp
f0101e59:	5b                   	pop    %ebx
f0101e5a:	5e                   	pop    %esi
f0101e5b:	5f                   	pop    %edi
f0101e5c:	5d                   	pop    %ebp
f0101e5d:	c3                   	ret    
f0101e5e:	66 90                	xchg   %ax,%ax
f0101e60:	39 f0                	cmp    %esi,%eax
f0101e62:	76 10                	jbe    f0101e74 <__udivdi3+0x48>
f0101e64:	31 ff                	xor    %edi,%edi
f0101e66:	31 c0                	xor    %eax,%eax
f0101e68:	89 fa                	mov    %edi,%edx
f0101e6a:	83 c4 1c             	add    $0x1c,%esp
f0101e6d:	5b                   	pop    %ebx
f0101e6e:	5e                   	pop    %esi
f0101e6f:	5f                   	pop    %edi
f0101e70:	5d                   	pop    %ebp
f0101e71:	c3                   	ret    
f0101e72:	66 90                	xchg   %ax,%ax
f0101e74:	0f bd f8             	bsr    %eax,%edi
f0101e77:	83 f7 1f             	xor    $0x1f,%edi
f0101e7a:	75 40                	jne    f0101ebc <__udivdi3+0x90>
f0101e7c:	39 f0                	cmp    %esi,%eax
f0101e7e:	72 09                	jb     f0101e89 <__udivdi3+0x5d>
f0101e80:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101e83:	0f 87 a3 00 00 00    	ja     f0101f2c <__udivdi3+0x100>
f0101e89:	b8 01 00 00 00       	mov    $0x1,%eax
f0101e8e:	eb d8                	jmp    f0101e68 <__udivdi3+0x3c>
f0101e90:	89 d9                	mov    %ebx,%ecx
f0101e92:	85 db                	test   %ebx,%ebx
f0101e94:	75 0b                	jne    f0101ea1 <__udivdi3+0x75>
f0101e96:	b8 01 00 00 00       	mov    $0x1,%eax
f0101e9b:	31 d2                	xor    %edx,%edx
f0101e9d:	f7 f3                	div    %ebx
f0101e9f:	89 c1                	mov    %eax,%ecx
f0101ea1:	31 d2                	xor    %edx,%edx
f0101ea3:	89 f0                	mov    %esi,%eax
f0101ea5:	f7 f1                	div    %ecx
f0101ea7:	89 c6                	mov    %eax,%esi
f0101ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101eac:	f7 f1                	div    %ecx
f0101eae:	89 f7                	mov    %esi,%edi
f0101eb0:	89 fa                	mov    %edi,%edx
f0101eb2:	83 c4 1c             	add    $0x1c,%esp
f0101eb5:	5b                   	pop    %ebx
f0101eb6:	5e                   	pop    %esi
f0101eb7:	5f                   	pop    %edi
f0101eb8:	5d                   	pop    %ebp
f0101eb9:	c3                   	ret    
f0101eba:	66 90                	xchg   %ax,%ax
f0101ebc:	ba 20 00 00 00       	mov    $0x20,%edx
f0101ec1:	29 fa                	sub    %edi,%edx
f0101ec3:	89 f9                	mov    %edi,%ecx
f0101ec5:	d3 e0                	shl    %cl,%eax
f0101ec7:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101eca:	89 d8                	mov    %ebx,%eax
f0101ecc:	88 d1                	mov    %dl,%cl
f0101ece:	d3 e8                	shr    %cl,%eax
f0101ed0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0101ed3:	09 c1                	or     %eax,%ecx
f0101ed5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101ed8:	89 f9                	mov    %edi,%ecx
f0101eda:	d3 e3                	shl    %cl,%ebx
f0101edc:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f0101edf:	89 f0                	mov    %esi,%eax
f0101ee1:	88 d1                	mov    %dl,%cl
f0101ee3:	d3 e8                	shr    %cl,%eax
f0101ee5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101ee8:	89 f9                	mov    %edi,%ecx
f0101eea:	d3 e6                	shl    %cl,%esi
f0101eec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0101eef:	88 d1                	mov    %dl,%cl
f0101ef1:	d3 eb                	shr    %cl,%ebx
f0101ef3:	89 d8                	mov    %ebx,%eax
f0101ef5:	09 f0                	or     %esi,%eax
f0101ef7:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101efa:	f7 75 e0             	divl   -0x20(%ebp)
f0101efd:	89 d1                	mov    %edx,%ecx
f0101eff:	89 c3                	mov    %eax,%ebx
f0101f01:	f7 65 dc             	mull   -0x24(%ebp)
f0101f04:	39 d1                	cmp    %edx,%ecx
f0101f06:	72 18                	jb     f0101f20 <__udivdi3+0xf4>
f0101f08:	74 0a                	je     f0101f14 <__udivdi3+0xe8>
f0101f0a:	89 d8                	mov    %ebx,%eax
f0101f0c:	31 ff                	xor    %edi,%edi
f0101f0e:	e9 55 ff ff ff       	jmp    f0101e68 <__udivdi3+0x3c>
f0101f13:	90                   	nop
f0101f14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101f17:	89 f9                	mov    %edi,%ecx
f0101f19:	d3 e2                	shl    %cl,%edx
f0101f1b:	39 c2                	cmp    %eax,%edx
f0101f1d:	73 eb                	jae    f0101f0a <__udivdi3+0xde>
f0101f1f:	90                   	nop
f0101f20:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101f23:	31 ff                	xor    %edi,%edi
f0101f25:	e9 3e ff ff ff       	jmp    f0101e68 <__udivdi3+0x3c>
f0101f2a:	66 90                	xchg   %ax,%ax
f0101f2c:	31 c0                	xor    %eax,%eax
f0101f2e:	e9 35 ff ff ff       	jmp    f0101e68 <__udivdi3+0x3c>
f0101f33:	90                   	nop

f0101f34 <__umoddi3>:
f0101f34:	55                   	push   %ebp
f0101f35:	89 e5                	mov    %esp,%ebp
f0101f37:	57                   	push   %edi
f0101f38:	56                   	push   %esi
f0101f39:	53                   	push   %ebx
f0101f3a:	83 ec 1c             	sub    $0x1c,%esp
f0101f3d:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101f40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101f43:	8b 75 10             	mov    0x10(%ebp),%esi
f0101f46:	8b 45 14             	mov    0x14(%ebp),%eax
f0101f49:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0101f4c:	89 da                	mov    %ebx,%edx
f0101f4e:	85 c0                	test   %eax,%eax
f0101f50:	75 16                	jne    f0101f68 <__umoddi3+0x34>
f0101f52:	39 de                	cmp    %ebx,%esi
f0101f54:	76 4e                	jbe    f0101fa4 <__umoddi3+0x70>
f0101f56:	89 f8                	mov    %edi,%eax
f0101f58:	f7 f6                	div    %esi
f0101f5a:	89 d0                	mov    %edx,%eax
f0101f5c:	31 d2                	xor    %edx,%edx
f0101f5e:	83 c4 1c             	add    $0x1c,%esp
f0101f61:	5b                   	pop    %ebx
f0101f62:	5e                   	pop    %esi
f0101f63:	5f                   	pop    %edi
f0101f64:	5d                   	pop    %ebp
f0101f65:	c3                   	ret    
f0101f66:	66 90                	xchg   %ax,%ax
f0101f68:	39 d8                	cmp    %ebx,%eax
f0101f6a:	76 0c                	jbe    f0101f78 <__umoddi3+0x44>
f0101f6c:	89 f8                	mov    %edi,%eax
f0101f6e:	83 c4 1c             	add    $0x1c,%esp
f0101f71:	5b                   	pop    %ebx
f0101f72:	5e                   	pop    %esi
f0101f73:	5f                   	pop    %edi
f0101f74:	5d                   	pop    %ebp
f0101f75:	c3                   	ret    
f0101f76:	66 90                	xchg   %ax,%ax
f0101f78:	0f bd c8             	bsr    %eax,%ecx
f0101f7b:	83 f1 1f             	xor    $0x1f,%ecx
f0101f7e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101f81:	75 41                	jne    f0101fc4 <__umoddi3+0x90>
f0101f83:	39 d8                	cmp    %ebx,%eax
f0101f85:	72 04                	jb     f0101f8b <__umoddi3+0x57>
f0101f87:	39 fe                	cmp    %edi,%esi
f0101f89:	77 0d                	ja     f0101f98 <__umoddi3+0x64>
f0101f8b:	89 d9                	mov    %ebx,%ecx
f0101f8d:	89 fa                	mov    %edi,%edx
f0101f8f:	29 f2                	sub    %esi,%edx
f0101f91:	19 c1                	sbb    %eax,%ecx
f0101f93:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101f96:	89 ca                	mov    %ecx,%edx
f0101f98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101f9b:	83 c4 1c             	add    $0x1c,%esp
f0101f9e:	5b                   	pop    %ebx
f0101f9f:	5e                   	pop    %esi
f0101fa0:	5f                   	pop    %edi
f0101fa1:	5d                   	pop    %ebp
f0101fa2:	c3                   	ret    
f0101fa3:	90                   	nop
f0101fa4:	89 f1                	mov    %esi,%ecx
f0101fa6:	85 f6                	test   %esi,%esi
f0101fa8:	75 0b                	jne    f0101fb5 <__umoddi3+0x81>
f0101faa:	b8 01 00 00 00       	mov    $0x1,%eax
f0101faf:	31 d2                	xor    %edx,%edx
f0101fb1:	f7 f6                	div    %esi
f0101fb3:	89 c1                	mov    %eax,%ecx
f0101fb5:	89 d8                	mov    %ebx,%eax
f0101fb7:	31 d2                	xor    %edx,%edx
f0101fb9:	f7 f1                	div    %ecx
f0101fbb:	89 f8                	mov    %edi,%eax
f0101fbd:	f7 f1                	div    %ecx
f0101fbf:	eb 99                	jmp    f0101f5a <__umoddi3+0x26>
f0101fc1:	8d 76 00             	lea    0x0(%esi),%esi
f0101fc4:	ba 20 00 00 00       	mov    $0x20,%edx
f0101fc9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0101fcc:	29 ca                	sub    %ecx,%edx
f0101fce:	d3 e0                	shl    %cl,%eax
f0101fd0:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101fd3:	89 f0                	mov    %esi,%eax
f0101fd5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101fd8:	88 d1                	mov    %dl,%cl
f0101fda:	d3 e8                	shr    %cl,%eax
f0101fdc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101fdf:	09 c1                	or     %eax,%ecx
f0101fe1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0101fe4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101fe7:	88 c1                	mov    %al,%cl
f0101fe9:	d3 e6                	shl    %cl,%esi
f0101feb:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0101fee:	89 de                	mov    %ebx,%esi
f0101ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101ff3:	88 d1                	mov    %dl,%cl
f0101ff5:	d3 ee                	shr    %cl,%esi
f0101ff7:	88 c1                	mov    %al,%cl
f0101ff9:	d3 e3                	shl    %cl,%ebx
f0101ffb:	89 f8                	mov    %edi,%eax
f0101ffd:	88 d1                	mov    %dl,%cl
f0101fff:	d3 e8                	shr    %cl,%eax
f0102001:	09 d8                	or     %ebx,%eax
f0102003:	8a 4d e0             	mov    -0x20(%ebp),%cl
f0102006:	d3 e7                	shl    %cl,%edi
f0102008:	89 f2                	mov    %esi,%edx
f010200a:	f7 75 dc             	divl   -0x24(%ebp)
f010200d:	89 d3                	mov    %edx,%ebx
f010200f:	f7 65 d8             	mull   -0x28(%ebp)
f0102012:	89 c6                	mov    %eax,%esi
f0102014:	89 d1                	mov    %edx,%ecx
f0102016:	39 d3                	cmp    %edx,%ebx
f0102018:	72 2a                	jb     f0102044 <__umoddi3+0x110>
f010201a:	74 24                	je     f0102040 <__umoddi3+0x10c>
f010201c:	89 f8                	mov    %edi,%eax
f010201e:	29 f0                	sub    %esi,%eax
f0102020:	19 cb                	sbb    %ecx,%ebx
f0102022:	89 da                	mov    %ebx,%edx
f0102024:	8a 4d e4             	mov    -0x1c(%ebp),%cl
f0102027:	d3 e2                	shl    %cl,%edx
f0102029:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010202c:	89 f9                	mov    %edi,%ecx
f010202e:	d3 e8                	shr    %cl,%eax
f0102030:	09 d0                	or     %edx,%eax
f0102032:	d3 eb                	shr    %cl,%ebx
f0102034:	89 da                	mov    %ebx,%edx
f0102036:	83 c4 1c             	add    $0x1c,%esp
f0102039:	5b                   	pop    %ebx
f010203a:	5e                   	pop    %esi
f010203b:	5f                   	pop    %edi
f010203c:	5d                   	pop    %ebp
f010203d:	c3                   	ret    
f010203e:	66 90                	xchg   %ax,%ax
f0102040:	39 c7                	cmp    %eax,%edi
f0102042:	73 d8                	jae    f010201c <__umoddi3+0xe8>
f0102044:	2b 45 d8             	sub    -0x28(%ebp),%eax
f0102047:	1b 55 dc             	sbb    -0x24(%ebp),%edx
f010204a:	89 d1                	mov    %edx,%ecx
f010204c:	89 c6                	mov    %eax,%esi
f010204e:	eb cc                	jmp    f010201c <__umoddi3+0xe8>
