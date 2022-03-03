
obj/user/faultregs：     文件格式 elf32-i386


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
  80002c:	e8 ae 05 00 00       	call   8005df <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 11 16 80 00       	push   $0x801611
  800049:	68 e0 15 80 00       	push   $0x8015e0
  80004e:	e8 bf 06 00 00       	call   800712 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 f0 15 80 00       	push   $0x8015f0
  80005c:	68 f4 15 80 00       	push   $0x8015f4
  800061:	e8 ac 06 00 00       	call   800712 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 31 02 00 00    	je     8002a4 <check_regs+0x271>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 08 16 80 00       	push   $0x801608
  80007b:	e8 92 06 00 00       	call   800712 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 12 16 80 00       	push   $0x801612
  800093:	68 f4 15 80 00       	push   $0x8015f4
  800098:	e8 75 06 00 00       	call   800712 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 12 02 00 00    	je     8002be <check_regs+0x28b>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 08 16 80 00       	push   $0x801608
  8000b4:	e8 59 06 00 00       	call   800712 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 16 16 80 00       	push   $0x801616
  8000cc:	68 f4 15 80 00       	push   $0x8015f4
  8000d1:	e8 3c 06 00 00       	call   800712 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 ee 01 00 00    	je     8002d3 <check_regs+0x2a0>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 08 16 80 00       	push   $0x801608
  8000ed:	e8 20 06 00 00       	call   800712 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 1a 16 80 00       	push   $0x80161a
  800105:	68 f4 15 80 00       	push   $0x8015f4
  80010a:	e8 03 06 00 00       	call   800712 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 ca 01 00 00    	je     8002e8 <check_regs+0x2b5>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 08 16 80 00       	push   $0x801608
  800126:	e8 e7 05 00 00       	call   800712 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 1e 16 80 00       	push   $0x80161e
  80013e:	68 f4 15 80 00       	push   $0x8015f4
  800143:	e8 ca 05 00 00       	call   800712 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a6 01 00 00    	je     8002fd <check_regs+0x2ca>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 08 16 80 00       	push   $0x801608
  80015f:	e8 ae 05 00 00       	call   800712 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 22 16 80 00       	push   $0x801622
  800177:	68 f4 15 80 00       	push   $0x8015f4
  80017c:	e8 91 05 00 00       	call   800712 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 82 01 00 00    	je     800312 <check_regs+0x2df>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 08 16 80 00       	push   $0x801608
  800198:	e8 75 05 00 00       	call   800712 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 26 16 80 00       	push   $0x801626
  8001b0:	68 f4 15 80 00       	push   $0x8015f4
  8001b5:	e8 58 05 00 00       	call   800712 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5e 01 00 00    	je     800327 <check_regs+0x2f4>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 08 16 80 00       	push   $0x801608
  8001d1:	e8 3c 05 00 00       	call   800712 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 2a 16 80 00       	push   $0x80162a
  8001e9:	68 f4 15 80 00       	push   $0x8015f4
  8001ee:	e8 1f 05 00 00       	call   800712 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 3a 01 00 00    	je     80033c <check_regs+0x309>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 08 16 80 00       	push   $0x801608
  80020a:	e8 03 05 00 00       	call   800712 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 2e 16 80 00       	push   $0x80162e
  800222:	68 f4 15 80 00       	push   $0x8015f4
  800227:	e8 e6 04 00 00       	call   800712 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 16 01 00 00    	je     800351 <check_regs+0x31e>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 08 16 80 00       	push   $0x801608
  800243:	e8 ca 04 00 00       	call   800712 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 35 16 80 00       	push   $0x801635
  800253:	68 f4 15 80 00       	push   $0x8015f4
  800258:	e8 b5 04 00 00       	call   800712 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 08 16 80 00       	push   $0x801608
  800274:	e8 99 04 00 00       	call   800712 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 39 16 80 00       	push   $0x801639
  800284:	e8 89 04 00 00       	call   800712 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 08 16 80 00       	push   $0x801608
  800294:	e8 79 04 00 00       	call   800712 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
	CHECK(edi, regs.reg_edi);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 04 16 80 00       	push   $0x801604
  8002ac:	e8 61 04 00 00       	call   800712 <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b9:	e9 ca fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 04 16 80 00       	push   $0x801604
  8002c6:	e8 47 04 00 00       	call   800712 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	e9 ee fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 04 16 80 00       	push   $0x801604
  8002db:	e8 32 04 00 00       	call   800712 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	e9 12 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 04 16 80 00       	push   $0x801604
  8002f0:	e8 1d 04 00 00       	call   800712 <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	e9 36 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 04 16 80 00       	push   $0x801604
  800305:	e8 08 04 00 00       	call   800712 <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	e9 5a fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	68 04 16 80 00       	push   $0x801604
  80031a:	e8 f3 03 00 00       	call   800712 <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	e9 7e fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 04 16 80 00       	push   $0x801604
  80032f:	e8 de 03 00 00       	call   800712 <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	e9 a2 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 04 16 80 00       	push   $0x801604
  800344:	e8 c9 03 00 00       	call   800712 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 c6 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	68 04 16 80 00       	push   $0x801604
  800359:	e8 b4 03 00 00       	call   800712 <cprintf>
	CHECK(esp, esp);
  80035e:	ff 73 28             	pushl  0x28(%ebx)
  800361:	ff 76 28             	pushl  0x28(%esi)
  800364:	68 35 16 80 00       	push   $0x801635
  800369:	68 f4 15 80 00       	push   $0x8015f4
  80036e:	e8 9f 03 00 00       	call   800712 <cprintf>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	8b 43 28             	mov    0x28(%ebx),%eax
  800379:	39 46 28             	cmp    %eax,0x28(%esi)
  80037c:	0f 85 ea fe ff ff    	jne    80026c <check_regs+0x239>
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 04 16 80 00       	push   $0x801604
  80038a:	e8 83 03 00 00       	call   800712 <cprintf>
	cprintf("Registers %s ", testname);
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	68 39 16 80 00       	push   $0x801639
  80039a:	e8 73 03 00 00       	call   800712 <cprintf>
	if (!mismatch)
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	85 ff                	test   %edi,%edi
  8003a4:	0f 85 e2 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 04 16 80 00       	push   $0x801604
  8003b2:	e8 5b 03 00 00       	call   800712 <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	e9 dd fe ff ff       	jmp    80029c <check_regs+0x269>
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 04 16 80 00       	push   $0x801604
  8003c7:	e8 46 03 00 00       	call   800712 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 39 16 80 00       	push   $0x801639
  8003d7:	e8 36 03 00 00       	call   800712 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 60 20 80 00    	mov    %edx,0x802060
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 64 20 80 00    	mov    %edx,0x802064
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 68 20 80 00    	mov    %edx,0x802068
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 70 20 80 00    	mov    %edx,0x802070
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 74 20 80 00    	mov    %edx,0x802074
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 78 20 80 00    	mov    %edx,0x802078
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 5f 16 80 00       	push   $0x80165f
  80046b:	68 6d 16 80 00       	push   $0x80166d
  800470:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800475:	ba 58 16 80 00       	mov    $0x801658,%edx
  80047a:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 d4 0c 00 00       	call   801169 <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 a0 16 80 00       	push   $0x8016a0
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 47 16 80 00       	push   $0x801647
  8004b1:	e8 81 01 00 00       	call   800637 <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 74 16 80 00       	push   $0x801674
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 47 16 80 00       	push   $0x801647
  8004c3:	e8 6f 01 00 00       	call   800637 <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 40 0e 00 00       	call   801318 <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 c0 20 80 00       	mov    %eax,0x8020c0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8004f9:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8004ff:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  800505:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  80050b:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  800511:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  800517:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  80051c:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 20 20 80 00    	mov    %edi,0x802020
  800532:	89 35 24 20 80 00    	mov    %esi,0x802024
  800538:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  80053e:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  800544:	89 15 34 20 80 00    	mov    %edx,0x802034
  80054a:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  800550:	a3 3c 20 80 00       	mov    %eax,0x80203c
  800555:	89 25 48 20 80 00    	mov    %esp,0x802048
  80055b:	8b 3d a0 20 80 00    	mov    0x8020a0,%edi
  800561:	8b 35 a4 20 80 00    	mov    0x8020a4,%esi
  800567:	8b 2d a8 20 80 00    	mov    0x8020a8,%ebp
  80056d:	8b 1d b0 20 80 00    	mov    0x8020b0,%ebx
  800573:	8b 15 b4 20 80 00    	mov    0x8020b4,%edx
  800579:	8b 0d b8 20 80 00    	mov    0x8020b8,%ecx
  80057f:	a1 bc 20 80 00       	mov    0x8020bc,%eax
  800584:	8b 25 c8 20 80 00    	mov    0x8020c8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 44 20 80 00       	mov    %eax,0x802044
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	74 10                	je     8005af <umain+0xe7>
		cprintf("EIP after page-fault MISMATCH\n");
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	68 d4 16 80 00       	push   $0x8016d4
  8005a7:	e8 66 01 00 00       	call   800712 <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  8005af:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  8005b4:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	68 87 16 80 00       	push   $0x801687
  8005c1:	68 98 16 80 00       	push   $0x801698
  8005c6:	b9 20 20 80 00       	mov    $0x802020,%ecx
  8005cb:	ba 58 16 80 00       	mov    $0x801658,%edx
  8005d0:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  8005d5:	e8 59 fa ff ff       	call   800033 <check_regs>
}
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	56                   	push   %esi
  8005e3:	53                   	push   %ebx
  8005e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005ea:	e8 3c 0b 00 00       	call   80112b <sys_getenvid>
  8005ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005fc:	a3 cc 20 80 00       	mov    %eax,0x8020cc

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800601:	85 db                	test   %ebx,%ebx
  800603:	7e 07                	jle    80060c <libmain+0x2d>
		binaryname = argv[0];
  800605:	8b 06                	mov    (%esi),%eax
  800607:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	e8 b2 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800616:	e8 0a 00 00 00       	call   800625 <exit>
}
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5d                   	pop    %ebp
  800624:	c3                   	ret    

00800625 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800625:	55                   	push   %ebp
  800626:	89 e5                	mov    %esp,%ebp
  800628:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80062b:	6a 00                	push   $0x0
  80062d:	e8 b8 0a 00 00       	call   8010ea <sys_env_destroy>
}
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	56                   	push   %esi
  80063b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80063c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80063f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800645:	e8 e1 0a 00 00       	call   80112b <sys_getenvid>
  80064a:	83 ec 0c             	sub    $0xc,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	56                   	push   %esi
  800654:	50                   	push   %eax
  800655:	68 00 17 80 00       	push   $0x801700
  80065a:	e8 b3 00 00 00       	call   800712 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80065f:	83 c4 18             	add    $0x18,%esp
  800662:	53                   	push   %ebx
  800663:	ff 75 10             	pushl  0x10(%ebp)
  800666:	e8 56 00 00 00       	call   8006c1 <vcprintf>
	cprintf("\n");
  80066b:	c7 04 24 10 16 80 00 	movl   $0x801610,(%esp)
  800672:	e8 9b 00 00 00       	call   800712 <cprintf>
  800677:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80067a:	cc                   	int3   
  80067b:	eb fd                	jmp    80067a <_panic+0x43>

0080067d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	53                   	push   %ebx
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800687:	8b 13                	mov    (%ebx),%edx
  800689:	8d 42 01             	lea    0x1(%edx),%eax
  80068c:	89 03                	mov    %eax,(%ebx)
  80068e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800691:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800695:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069a:	74 09                	je     8006a5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80069c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	68 ff 00 00 00       	push   $0xff
  8006ad:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b0:	50                   	push   %eax
  8006b1:	e8 f7 09 00 00       	call   8010ad <sys_cputs>
		b->idx = 0;
  8006b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	eb db                	jmp    80069c <putch+0x1f>

008006c1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d1:	00 00 00 
	b.cnt = 0;
  8006d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006db:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	ff 75 08             	pushl  0x8(%ebp)
  8006e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	68 7d 06 80 00       	push   $0x80067d
  8006f0:	e8 1a 01 00 00       	call   80080f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006f5:	83 c4 08             	add    $0x8,%esp
  8006f8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006fe:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800704:	50                   	push   %eax
  800705:	e8 a3 09 00 00       	call   8010ad <sys_cputs>

	return b.cnt;
}
  80070a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800710:	c9                   	leave  
  800711:	c3                   	ret    

00800712 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800718:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80071b:	50                   	push   %eax
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	e8 9d ff ff ff       	call   8006c1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	57                   	push   %edi
  80072a:	56                   	push   %esi
  80072b:	53                   	push   %ebx
  80072c:	83 ec 1c             	sub    $0x1c,%esp
  80072f:	89 c7                	mov    %eax,%edi
  800731:	89 d6                	mov    %edx,%esi
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 55 0c             	mov    0xc(%ebp),%edx
  800739:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80073f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800742:	bb 00 00 00 00       	mov    $0x0,%ebx
  800747:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80074a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80074d:	39 d3                	cmp    %edx,%ebx
  80074f:	72 05                	jb     800756 <printnum+0x30>
  800751:	39 45 10             	cmp    %eax,0x10(%ebp)
  800754:	77 7a                	ja     8007d0 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800756:	83 ec 0c             	sub    $0xc,%esp
  800759:	ff 75 18             	pushl  0x18(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800762:	53                   	push   %ebx
  800763:	ff 75 10             	pushl  0x10(%ebp)
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 e4             	pushl  -0x1c(%ebp)
  80076c:	ff 75 e0             	pushl  -0x20(%ebp)
  80076f:	ff 75 dc             	pushl  -0x24(%ebp)
  800772:	ff 75 d8             	pushl  -0x28(%ebp)
  800775:	e8 26 0c 00 00       	call   8013a0 <__udivdi3>
  80077a:	83 c4 18             	add    $0x18,%esp
  80077d:	52                   	push   %edx
  80077e:	50                   	push   %eax
  80077f:	89 f2                	mov    %esi,%edx
  800781:	89 f8                	mov    %edi,%eax
  800783:	e8 9e ff ff ff       	call   800726 <printnum>
  800788:	83 c4 20             	add    $0x20,%esp
  80078b:	eb 13                	jmp    8007a0 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	56                   	push   %esi
  800791:	ff 75 18             	pushl  0x18(%ebp)
  800794:	ff d7                	call   *%edi
  800796:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800799:	83 eb 01             	sub    $0x1,%ebx
  80079c:	85 db                	test   %ebx,%ebx
  80079e:	7f ed                	jg     80078d <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	56                   	push   %esi
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b3:	e8 08 0d 00 00       	call   8014c0 <__umoddi3>
  8007b8:	83 c4 14             	add    $0x14,%esp
  8007bb:	0f be 80 24 17 80 00 	movsbl 0x801724(%eax),%eax
  8007c2:	50                   	push   %eax
  8007c3:	ff d7                	call   *%edi
}
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007cb:	5b                   	pop    %ebx
  8007cc:	5e                   	pop    %esi
  8007cd:	5f                   	pop    %edi
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    
  8007d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007d3:	eb c4                	jmp    800799 <printnum+0x73>

008007d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007df:	8b 10                	mov    (%eax),%edx
  8007e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8007e4:	73 0a                	jae    8007f0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007e9:	89 08                	mov    %ecx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	88 02                	mov    %al,(%edx)
}
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <printfmt>:
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007fb:	50                   	push   %eax
  8007fc:	ff 75 10             	pushl  0x10(%ebp)
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	ff 75 08             	pushl  0x8(%ebp)
  800805:	e8 05 00 00 00       	call   80080f <vprintfmt>
}
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <vprintfmt>:
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	57                   	push   %edi
  800813:	56                   	push   %esi
  800814:	53                   	push   %ebx
  800815:	83 ec 2c             	sub    $0x2c,%esp
  800818:	8b 75 08             	mov    0x8(%ebp),%esi
  80081b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80081e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800821:	e9 00 04 00 00       	jmp    800c26 <vprintfmt+0x417>
		padc = ' ';
  800826:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80082a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800831:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800838:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800844:	8d 47 01             	lea    0x1(%edi),%eax
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084a:	0f b6 17             	movzbl (%edi),%edx
  80084d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800850:	3c 55                	cmp    $0x55,%al
  800852:	0f 87 51 04 00 00    	ja     800ca9 <vprintfmt+0x49a>
  800858:	0f b6 c0             	movzbl %al,%eax
  80085b:	ff 24 85 e0 17 80 00 	jmp    *0x8017e0(,%eax,4)
  800862:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800865:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800869:	eb d9                	jmp    800844 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80086b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80086e:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800872:	eb d0                	jmp    800844 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800874:	0f b6 d2             	movzbl %dl,%edx
  800877:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80087a:	b8 00 00 00 00       	mov    $0x0,%eax
  80087f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800885:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800889:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80088c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80088f:	83 f9 09             	cmp    $0x9,%ecx
  800892:	77 55                	ja     8008e9 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800894:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800897:	eb e9                	jmp    800882 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8d 40 04             	lea    0x4(%eax),%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b1:	79 91                	jns    800844 <vprintfmt+0x35>
				width = precision, precision = -1;
  8008b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008b9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008c0:	eb 82                	jmp    800844 <vprintfmt+0x35>
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	0f 49 d0             	cmovns %eax,%edx
  8008cf:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008d5:	e9 6a ff ff ff       	jmp    800844 <vprintfmt+0x35>
  8008da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008dd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008e4:	e9 5b ff ff ff       	jmp    800844 <vprintfmt+0x35>
  8008e9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008ef:	eb bc                	jmp    8008ad <vprintfmt+0x9e>
			lflag++;
  8008f1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008f7:	e9 48 ff ff ff       	jmp    800844 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8d 78 04             	lea    0x4(%eax),%edi
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	53                   	push   %ebx
  800906:	ff 30                	pushl  (%eax)
  800908:	ff d6                	call   *%esi
			break;
  80090a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80090d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800910:	e9 0e 03 00 00       	jmp    800c23 <vprintfmt+0x414>
			err = va_arg(ap, int);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8d 78 04             	lea    0x4(%eax),%edi
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	99                   	cltd   
  80091e:	31 d0                	xor    %edx,%eax
  800920:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800922:	83 f8 08             	cmp    $0x8,%eax
  800925:	7f 23                	jg     80094a <vprintfmt+0x13b>
  800927:	8b 14 85 40 19 80 00 	mov    0x801940(,%eax,4),%edx
  80092e:	85 d2                	test   %edx,%edx
  800930:	74 18                	je     80094a <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800932:	52                   	push   %edx
  800933:	68 45 17 80 00       	push   $0x801745
  800938:	53                   	push   %ebx
  800939:	56                   	push   %esi
  80093a:	e8 b3 fe ff ff       	call   8007f2 <printfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800942:	89 7d 14             	mov    %edi,0x14(%ebp)
  800945:	e9 d9 02 00 00       	jmp    800c23 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80094a:	50                   	push   %eax
  80094b:	68 3c 17 80 00       	push   $0x80173c
  800950:	53                   	push   %ebx
  800951:	56                   	push   %esi
  800952:	e8 9b fe ff ff       	call   8007f2 <printfmt>
  800957:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80095a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80095d:	e9 c1 02 00 00       	jmp    800c23 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800970:	85 ff                	test   %edi,%edi
  800972:	b8 35 17 80 00       	mov    $0x801735,%eax
  800977:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80097a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097e:	0f 8e bd 00 00 00    	jle    800a41 <vprintfmt+0x232>
  800984:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800988:	75 0e                	jne    800998 <vprintfmt+0x189>
  80098a:	89 75 08             	mov    %esi,0x8(%ebp)
  80098d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800990:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800993:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800996:	eb 6d                	jmp    800a05 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 d0             	pushl  -0x30(%ebp)
  80099e:	57                   	push   %edi
  80099f:	e8 ad 03 00 00       	call   800d51 <strnlen>
  8009a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009a7:	29 c1                	sub    %eax,%ecx
  8009a9:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8009ac:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8009af:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009b6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009b9:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bb:	eb 0f                	jmp    8009cc <vprintfmt+0x1bd>
					putch(padc, putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	53                   	push   %ebx
  8009c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8009c4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c6:	83 ef 01             	sub    $0x1,%edi
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	85 ff                	test   %edi,%edi
  8009ce:	7f ed                	jg     8009bd <vprintfmt+0x1ae>
  8009d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009d3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009d6:	85 c9                	test   %ecx,%ecx
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dd:	0f 49 c1             	cmovns %ecx,%eax
  8009e0:	29 c1                	sub    %eax,%ecx
  8009e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8009e5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009e8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009eb:	89 cb                	mov    %ecx,%ebx
  8009ed:	eb 16                	jmp    800a05 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009f3:	75 31                	jne    800a26 <vprintfmt+0x217>
					putch(ch, putdat);
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	50                   	push   %eax
  8009fc:	ff 55 08             	call   *0x8(%ebp)
  8009ff:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a02:	83 eb 01             	sub    $0x1,%ebx
  800a05:	83 c7 01             	add    $0x1,%edi
  800a08:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800a0c:	0f be c2             	movsbl %dl,%eax
  800a0f:	85 c0                	test   %eax,%eax
  800a11:	74 59                	je     800a6c <vprintfmt+0x25d>
  800a13:	85 f6                	test   %esi,%esi
  800a15:	78 d8                	js     8009ef <vprintfmt+0x1e0>
  800a17:	83 ee 01             	sub    $0x1,%esi
  800a1a:	79 d3                	jns    8009ef <vprintfmt+0x1e0>
  800a1c:	89 df                	mov    %ebx,%edi
  800a1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a24:	eb 37                	jmp    800a5d <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a26:	0f be d2             	movsbl %dl,%edx
  800a29:	83 ea 20             	sub    $0x20,%edx
  800a2c:	83 fa 5e             	cmp    $0x5e,%edx
  800a2f:	76 c4                	jbe    8009f5 <vprintfmt+0x1e6>
					putch('?', putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	6a 3f                	push   $0x3f
  800a39:	ff 55 08             	call   *0x8(%ebp)
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	eb c1                	jmp    800a02 <vprintfmt+0x1f3>
  800a41:	89 75 08             	mov    %esi,0x8(%ebp)
  800a44:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a47:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a4a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a4d:	eb b6                	jmp    800a05 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	6a 20                	push   $0x20
  800a55:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a57:	83 ef 01             	sub    $0x1,%edi
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	85 ff                	test   %edi,%edi
  800a5f:	7f ee                	jg     800a4f <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
  800a67:	e9 b7 01 00 00       	jmp    800c23 <vprintfmt+0x414>
  800a6c:	89 df                	mov    %ebx,%edi
  800a6e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a74:	eb e7                	jmp    800a5d <vprintfmt+0x24e>
	if (lflag >= 2)
  800a76:	83 f9 01             	cmp    $0x1,%ecx
  800a79:	7e 3f                	jle    800aba <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8b 50 04             	mov    0x4(%eax),%edx
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a86:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a89:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8c:	8d 40 08             	lea    0x8(%eax),%eax
  800a8f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a92:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a96:	79 5c                	jns    800af4 <vprintfmt+0x2e5>
				putch('-', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	53                   	push   %ebx
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aa3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800aa6:	f7 da                	neg    %edx
  800aa8:	83 d1 00             	adc    $0x0,%ecx
  800aab:	f7 d9                	neg    %ecx
  800aad:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ab0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab5:	e9 4f 01 00 00       	jmp    800c09 <vprintfmt+0x3fa>
	else if (lflag)
  800aba:	85 c9                	test   %ecx,%ecx
  800abc:	75 1b                	jne    800ad9 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac6:	89 c1                	mov    %eax,%ecx
  800ac8:	c1 f9 1f             	sar    $0x1f,%ecx
  800acb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	8d 40 04             	lea    0x4(%eax),%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad7:	eb b9                	jmp    800a92 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae1:	89 c1                	mov    %eax,%ecx
  800ae3:	c1 f9 1f             	sar    $0x1f,%ecx
  800ae6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	8d 40 04             	lea    0x4(%eax),%eax
  800aef:	89 45 14             	mov    %eax,0x14(%ebp)
  800af2:	eb 9e                	jmp    800a92 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800af4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800af7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800afa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aff:	e9 05 01 00 00       	jmp    800c09 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800b04:	83 f9 01             	cmp    $0x1,%ecx
  800b07:	7e 18                	jle    800b21 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	8b 10                	mov    (%eax),%edx
  800b0e:	8b 48 04             	mov    0x4(%eax),%ecx
  800b11:	8d 40 08             	lea    0x8(%eax),%eax
  800b14:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b1c:	e9 e8 00 00 00       	jmp    800c09 <vprintfmt+0x3fa>
	else if (lflag)
  800b21:	85 c9                	test   %ecx,%ecx
  800b23:	75 1a                	jne    800b3f <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	8b 10                	mov    (%eax),%edx
  800b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b2f:	8d 40 04             	lea    0x4(%eax),%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3a:	e9 ca 00 00 00       	jmp    800c09 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	8b 10                	mov    (%eax),%edx
  800b44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b49:	8d 40 04             	lea    0x4(%eax),%eax
  800b4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b54:	e9 b0 00 00 00       	jmp    800c09 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800b59:	83 f9 01             	cmp    $0x1,%ecx
  800b5c:	7e 3c                	jle    800b9a <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	8b 50 04             	mov    0x4(%eax),%edx
  800b64:	8b 00                	mov    (%eax),%eax
  800b66:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b69:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6f:	8d 40 08             	lea    0x8(%eax),%eax
  800b72:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800b75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b79:	79 59                	jns    800bd4 <vprintfmt+0x3c5>
                putch('-', putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	53                   	push   %ebx
  800b7f:	6a 2d                	push   $0x2d
  800b81:	ff d6                	call   *%esi
                num = -(long long) num;
  800b83:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b86:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b89:	f7 da                	neg    %edx
  800b8b:	83 d1 00             	adc    $0x0,%ecx
  800b8e:	f7 d9                	neg    %ecx
  800b90:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800b93:	b8 08 00 00 00       	mov    $0x8,%eax
  800b98:	eb 6f                	jmp    800c09 <vprintfmt+0x3fa>
	else if (lflag)
  800b9a:	85 c9                	test   %ecx,%ecx
  800b9c:	75 1b                	jne    800bb9 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba6:	89 c1                	mov    %eax,%ecx
  800ba8:	c1 f9 1f             	sar    $0x1f,%ecx
  800bab:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	8d 40 04             	lea    0x4(%eax),%eax
  800bb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb7:	eb bc                	jmp    800b75 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800bb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc1:	89 c1                	mov    %eax,%ecx
  800bc3:	c1 f9 1f             	sar    $0x1f,%ecx
  800bc6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	8d 40 04             	lea    0x4(%eax),%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	eb a1                	jmp    800b75 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800bd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bd7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800bda:	b8 08 00 00 00       	mov    $0x8,%eax
  800bdf:	eb 28                	jmp    800c09 <vprintfmt+0x3fa>
			putch('0', putdat);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	53                   	push   %ebx
  800be5:	6a 30                	push   $0x30
  800be7:	ff d6                	call   *%esi
			putch('x', putdat);
  800be9:	83 c4 08             	add    $0x8,%esp
  800bec:	53                   	push   %ebx
  800bed:	6a 78                	push   $0x78
  800bef:	ff d6                	call   *%esi
			num = (unsigned long long)
  800bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf4:	8b 10                	mov    (%eax),%edx
  800bf6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800bfb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bfe:	8d 40 04             	lea    0x4(%eax),%eax
  800c01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c04:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800c10:	57                   	push   %edi
  800c11:	ff 75 e0             	pushl  -0x20(%ebp)
  800c14:	50                   	push   %eax
  800c15:	51                   	push   %ecx
  800c16:	52                   	push   %edx
  800c17:	89 da                	mov    %ebx,%edx
  800c19:	89 f0                	mov    %esi,%eax
  800c1b:	e8 06 fb ff ff       	call   800726 <printnum>
			break;
  800c20:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800c23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c26:	83 c7 01             	add    $0x1,%edi
  800c29:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c2d:	83 f8 25             	cmp    $0x25,%eax
  800c30:	0f 84 f0 fb ff ff    	je     800826 <vprintfmt+0x17>
			if (ch == '\0')
  800c36:	85 c0                	test   %eax,%eax
  800c38:	0f 84 8b 00 00 00    	je     800cc9 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	53                   	push   %ebx
  800c42:	50                   	push   %eax
  800c43:	ff d6                	call   *%esi
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	eb dc                	jmp    800c26 <vprintfmt+0x417>
	if (lflag >= 2)
  800c4a:	83 f9 01             	cmp    $0x1,%ecx
  800c4d:	7e 15                	jle    800c64 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	8b 10                	mov    (%eax),%edx
  800c54:	8b 48 04             	mov    0x4(%eax),%ecx
  800c57:	8d 40 08             	lea    0x8(%eax),%eax
  800c5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c5d:	b8 10 00 00 00       	mov    $0x10,%eax
  800c62:	eb a5                	jmp    800c09 <vprintfmt+0x3fa>
	else if (lflag)
  800c64:	85 c9                	test   %ecx,%ecx
  800c66:	75 17                	jne    800c7f <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800c68:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6b:	8b 10                	mov    (%eax),%edx
  800c6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c72:	8d 40 04             	lea    0x4(%eax),%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c78:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7d:	eb 8a                	jmp    800c09 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800c7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c82:	8b 10                	mov    (%eax),%edx
  800c84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c89:	8d 40 04             	lea    0x4(%eax),%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c8f:	b8 10 00 00 00       	mov    $0x10,%eax
  800c94:	e9 70 ff ff ff       	jmp    800c09 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	53                   	push   %ebx
  800c9d:	6a 25                	push   $0x25
  800c9f:	ff d6                	call   *%esi
			break;
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	e9 7a ff ff ff       	jmp    800c23 <vprintfmt+0x414>
			putch('%', putdat);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	53                   	push   %ebx
  800cad:	6a 25                	push   $0x25
  800caf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	89 f8                	mov    %edi,%eax
  800cb6:	eb 03                	jmp    800cbb <vprintfmt+0x4ac>
  800cb8:	83 e8 01             	sub    $0x1,%eax
  800cbb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cbf:	75 f7                	jne    800cb8 <vprintfmt+0x4a9>
  800cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc4:	e9 5a ff ff ff       	jmp    800c23 <vprintfmt+0x414>
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ce0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ce4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ce7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	74 26                	je     800d18 <vsnprintf+0x47>
  800cf2:	85 d2                	test   %edx,%edx
  800cf4:	7e 22                	jle    800d18 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf6:	ff 75 14             	pushl  0x14(%ebp)
  800cf9:	ff 75 10             	pushl  0x10(%ebp)
  800cfc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cff:	50                   	push   %eax
  800d00:	68 d5 07 80 00       	push   $0x8007d5
  800d05:	e8 05 fb ff ff       	call   80080f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d13:	83 c4 10             	add    $0x10,%esp
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    
		return -E_INVAL;
  800d18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d1d:	eb f7                	jmp    800d16 <vsnprintf+0x45>

00800d1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d25:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d28:	50                   	push   %eax
  800d29:	ff 75 10             	pushl  0x10(%ebp)
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	ff 75 08             	pushl  0x8(%ebp)
  800d32:	e8 9a ff ff ff       	call   800cd1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	eb 03                	jmp    800d49 <strlen+0x10>
		n++;
  800d46:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800d49:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d4d:	75 f7                	jne    800d46 <strlen+0xd>
	return n;
}
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d57:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5f:	eb 03                	jmp    800d64 <strnlen+0x13>
		n++;
  800d61:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d64:	39 d0                	cmp    %edx,%eax
  800d66:	74 06                	je     800d6e <strnlen+0x1d>
  800d68:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d6c:	75 f3                	jne    800d61 <strnlen+0x10>
	return n;
}
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	53                   	push   %ebx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d7a:	89 c2                	mov    %eax,%edx
  800d7c:	83 c1 01             	add    $0x1,%ecx
  800d7f:	83 c2 01             	add    $0x1,%edx
  800d82:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d86:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d89:	84 db                	test   %bl,%bl
  800d8b:	75 ef                	jne    800d7c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d8d:	5b                   	pop    %ebx
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	53                   	push   %ebx
  800d94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d97:	53                   	push   %ebx
  800d98:	e8 9c ff ff ff       	call   800d39 <strlen>
  800d9d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800da0:	ff 75 0c             	pushl  0xc(%ebp)
  800da3:	01 d8                	add    %ebx,%eax
  800da5:	50                   	push   %eax
  800da6:	e8 c5 ff ff ff       	call   800d70 <strcpy>
	return dst;
}
  800dab:	89 d8                	mov    %ebx,%eax
  800dad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	8b 75 08             	mov    0x8(%ebp),%esi
  800dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbd:	89 f3                	mov    %esi,%ebx
  800dbf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dc2:	89 f2                	mov    %esi,%edx
  800dc4:	eb 0f                	jmp    800dd5 <strncpy+0x23>
		*dst++ = *src;
  800dc6:	83 c2 01             	add    $0x1,%edx
  800dc9:	0f b6 01             	movzbl (%ecx),%eax
  800dcc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dcf:	80 39 01             	cmpb   $0x1,(%ecx)
  800dd2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800dd5:	39 da                	cmp    %ebx,%edx
  800dd7:	75 ed                	jne    800dc6 <strncpy+0x14>
	}
	return ret;
}
  800dd9:	89 f0                	mov    %esi,%eax
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	8b 75 08             	mov    0x8(%ebp),%esi
  800de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ded:	89 f0                	mov    %esi,%eax
  800def:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800df3:	85 c9                	test   %ecx,%ecx
  800df5:	75 0b                	jne    800e02 <strlcpy+0x23>
  800df7:	eb 17                	jmp    800e10 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800df9:	83 c2 01             	add    $0x1,%edx
  800dfc:	83 c0 01             	add    $0x1,%eax
  800dff:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800e02:	39 d8                	cmp    %ebx,%eax
  800e04:	74 07                	je     800e0d <strlcpy+0x2e>
  800e06:	0f b6 0a             	movzbl (%edx),%ecx
  800e09:	84 c9                	test   %cl,%cl
  800e0b:	75 ec                	jne    800df9 <strlcpy+0x1a>
		*dst = '\0';
  800e0d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e10:	29 f0                	sub    %esi,%eax
}
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e1f:	eb 06                	jmp    800e27 <strcmp+0x11>
		p++, q++;
  800e21:	83 c1 01             	add    $0x1,%ecx
  800e24:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e27:	0f b6 01             	movzbl (%ecx),%eax
  800e2a:	84 c0                	test   %al,%al
  800e2c:	74 04                	je     800e32 <strcmp+0x1c>
  800e2e:	3a 02                	cmp    (%edx),%al
  800e30:	74 ef                	je     800e21 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e32:	0f b6 c0             	movzbl %al,%eax
  800e35:	0f b6 12             	movzbl (%edx),%edx
  800e38:	29 d0                	sub    %edx,%eax
}
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	53                   	push   %ebx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e46:	89 c3                	mov    %eax,%ebx
  800e48:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e4b:	eb 06                	jmp    800e53 <strncmp+0x17>
		n--, p++, q++;
  800e4d:	83 c0 01             	add    $0x1,%eax
  800e50:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e53:	39 d8                	cmp    %ebx,%eax
  800e55:	74 16                	je     800e6d <strncmp+0x31>
  800e57:	0f b6 08             	movzbl (%eax),%ecx
  800e5a:	84 c9                	test   %cl,%cl
  800e5c:	74 04                	je     800e62 <strncmp+0x26>
  800e5e:	3a 0a                	cmp    (%edx),%cl
  800e60:	74 eb                	je     800e4d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e62:	0f b6 00             	movzbl (%eax),%eax
  800e65:	0f b6 12             	movzbl (%edx),%edx
  800e68:	29 d0                	sub    %edx,%eax
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    
		return 0;
  800e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e72:	eb f6                	jmp    800e6a <strncmp+0x2e>

00800e74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e7e:	0f b6 10             	movzbl (%eax),%edx
  800e81:	84 d2                	test   %dl,%dl
  800e83:	74 09                	je     800e8e <strchr+0x1a>
		if (*s == c)
  800e85:	38 ca                	cmp    %cl,%dl
  800e87:	74 0a                	je     800e93 <strchr+0x1f>
	for (; *s; s++)
  800e89:	83 c0 01             	add    $0x1,%eax
  800e8c:	eb f0                	jmp    800e7e <strchr+0xa>
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e9f:	eb 03                	jmp    800ea4 <strfind+0xf>
  800ea1:	83 c0 01             	add    $0x1,%eax
  800ea4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ea7:	38 ca                	cmp    %cl,%dl
  800ea9:	74 04                	je     800eaf <strfind+0x1a>
  800eab:	84 d2                	test   %dl,%dl
  800ead:	75 f2                	jne    800ea1 <strfind+0xc>
			break;
	return (char *) s;
}
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
  800eb7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ebd:	85 c9                	test   %ecx,%ecx
  800ebf:	74 13                	je     800ed4 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ec1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ec7:	75 05                	jne    800ece <memset+0x1d>
  800ec9:	f6 c1 03             	test   $0x3,%cl
  800ecc:	74 0d                	je     800edb <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	fc                   	cld    
  800ed2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ed4:	89 f8                	mov    %edi,%eax
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    
		c &= 0xFF;
  800edb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800edf:	89 d3                	mov    %edx,%ebx
  800ee1:	c1 e3 08             	shl    $0x8,%ebx
  800ee4:	89 d0                	mov    %edx,%eax
  800ee6:	c1 e0 18             	shl    $0x18,%eax
  800ee9:	89 d6                	mov    %edx,%esi
  800eeb:	c1 e6 10             	shl    $0x10,%esi
  800eee:	09 f0                	or     %esi,%eax
  800ef0:	09 c2                	or     %eax,%edx
  800ef2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ef4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ef7:	89 d0                	mov    %edx,%eax
  800ef9:	fc                   	cld    
  800efa:	f3 ab                	rep stos %eax,%es:(%edi)
  800efc:	eb d6                	jmp    800ed4 <memset+0x23>

00800efe <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0c:	39 c6                	cmp    %eax,%esi
  800f0e:	73 35                	jae    800f45 <memmove+0x47>
  800f10:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f13:	39 c2                	cmp    %eax,%edx
  800f15:	76 2e                	jbe    800f45 <memmove+0x47>
		s += n;
		d += n;
  800f17:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f1a:	89 d6                	mov    %edx,%esi
  800f1c:	09 fe                	or     %edi,%esi
  800f1e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f24:	74 0c                	je     800f32 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f26:	83 ef 01             	sub    $0x1,%edi
  800f29:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f2c:	fd                   	std    
  800f2d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f2f:	fc                   	cld    
  800f30:	eb 21                	jmp    800f53 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f32:	f6 c1 03             	test   $0x3,%cl
  800f35:	75 ef                	jne    800f26 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f37:	83 ef 04             	sub    $0x4,%edi
  800f3a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f3d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f40:	fd                   	std    
  800f41:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f43:	eb ea                	jmp    800f2f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f45:	89 f2                	mov    %esi,%edx
  800f47:	09 c2                	or     %eax,%edx
  800f49:	f6 c2 03             	test   $0x3,%dl
  800f4c:	74 09                	je     800f57 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f4e:	89 c7                	mov    %eax,%edi
  800f50:	fc                   	cld    
  800f51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f57:	f6 c1 03             	test   $0x3,%cl
  800f5a:	75 f2                	jne    800f4e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f5c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f5f:	89 c7                	mov    %eax,%edi
  800f61:	fc                   	cld    
  800f62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f64:	eb ed                	jmp    800f53 <memmove+0x55>

00800f66 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800f69:	ff 75 10             	pushl  0x10(%ebp)
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	ff 75 08             	pushl  0x8(%ebp)
  800f72:	e8 87 ff ff ff       	call   800efe <memmove>
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	56                   	push   %esi
  800f7d:	53                   	push   %ebx
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f84:	89 c6                	mov    %eax,%esi
  800f86:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f89:	39 f0                	cmp    %esi,%eax
  800f8b:	74 1c                	je     800fa9 <memcmp+0x30>
		if (*s1 != *s2)
  800f8d:	0f b6 08             	movzbl (%eax),%ecx
  800f90:	0f b6 1a             	movzbl (%edx),%ebx
  800f93:	38 d9                	cmp    %bl,%cl
  800f95:	75 08                	jne    800f9f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f97:	83 c0 01             	add    $0x1,%eax
  800f9a:	83 c2 01             	add    $0x1,%edx
  800f9d:	eb ea                	jmp    800f89 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f9f:	0f b6 c1             	movzbl %cl,%eax
  800fa2:	0f b6 db             	movzbl %bl,%ebx
  800fa5:	29 d8                	sub    %ebx,%eax
  800fa7:	eb 05                	jmp    800fae <memcmp+0x35>
	}

	return 0;
  800fa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fbb:	89 c2                	mov    %eax,%edx
  800fbd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fc0:	39 d0                	cmp    %edx,%eax
  800fc2:	73 09                	jae    800fcd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fc4:	38 08                	cmp    %cl,(%eax)
  800fc6:	74 05                	je     800fcd <memfind+0x1b>
	for (; s < ends; s++)
  800fc8:	83 c0 01             	add    $0x1,%eax
  800fcb:	eb f3                	jmp    800fc0 <memfind+0xe>
			break;
	return (void *) s;
}
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdb:	eb 03                	jmp    800fe0 <strtol+0x11>
		s++;
  800fdd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fe0:	0f b6 01             	movzbl (%ecx),%eax
  800fe3:	3c 20                	cmp    $0x20,%al
  800fe5:	74 f6                	je     800fdd <strtol+0xe>
  800fe7:	3c 09                	cmp    $0x9,%al
  800fe9:	74 f2                	je     800fdd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800feb:	3c 2b                	cmp    $0x2b,%al
  800fed:	74 2e                	je     80101d <strtol+0x4e>
	int neg = 0;
  800fef:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ff4:	3c 2d                	cmp    $0x2d,%al
  800ff6:	74 2f                	je     801027 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ffe:	75 05                	jne    801005 <strtol+0x36>
  801000:	80 39 30             	cmpb   $0x30,(%ecx)
  801003:	74 2c                	je     801031 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801005:	85 db                	test   %ebx,%ebx
  801007:	75 0a                	jne    801013 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801009:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  80100e:	80 39 30             	cmpb   $0x30,(%ecx)
  801011:	74 28                	je     80103b <strtol+0x6c>
		base = 10;
  801013:	b8 00 00 00 00       	mov    $0x0,%eax
  801018:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80101b:	eb 50                	jmp    80106d <strtol+0x9e>
		s++;
  80101d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801020:	bf 00 00 00 00       	mov    $0x0,%edi
  801025:	eb d1                	jmp    800ff8 <strtol+0x29>
		s++, neg = 1;
  801027:	83 c1 01             	add    $0x1,%ecx
  80102a:	bf 01 00 00 00       	mov    $0x1,%edi
  80102f:	eb c7                	jmp    800ff8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801031:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801035:	74 0e                	je     801045 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801037:	85 db                	test   %ebx,%ebx
  801039:	75 d8                	jne    801013 <strtol+0x44>
		s++, base = 8;
  80103b:	83 c1 01             	add    $0x1,%ecx
  80103e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801043:	eb ce                	jmp    801013 <strtol+0x44>
		s += 2, base = 16;
  801045:	83 c1 02             	add    $0x2,%ecx
  801048:	bb 10 00 00 00       	mov    $0x10,%ebx
  80104d:	eb c4                	jmp    801013 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80104f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801052:	89 f3                	mov    %esi,%ebx
  801054:	80 fb 19             	cmp    $0x19,%bl
  801057:	77 29                	ja     801082 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801059:	0f be d2             	movsbl %dl,%edx
  80105c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80105f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801062:	7d 30                	jge    801094 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801064:	83 c1 01             	add    $0x1,%ecx
  801067:	0f af 45 10          	imul   0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80106d:	0f b6 11             	movzbl (%ecx),%edx
  801070:	8d 72 d0             	lea    -0x30(%edx),%esi
  801073:	89 f3                	mov    %esi,%ebx
  801075:	80 fb 09             	cmp    $0x9,%bl
  801078:	77 d5                	ja     80104f <strtol+0x80>
			dig = *s - '0';
  80107a:	0f be d2             	movsbl %dl,%edx
  80107d:	83 ea 30             	sub    $0x30,%edx
  801080:	eb dd                	jmp    80105f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801082:	8d 72 bf             	lea    -0x41(%edx),%esi
  801085:	89 f3                	mov    %esi,%ebx
  801087:	80 fb 19             	cmp    $0x19,%bl
  80108a:	77 08                	ja     801094 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80108c:	0f be d2             	movsbl %dl,%edx
  80108f:	83 ea 37             	sub    $0x37,%edx
  801092:	eb cb                	jmp    80105f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801094:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801098:	74 05                	je     80109f <strtol+0xd0>
		*endptr = (char *) s;
  80109a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80109d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	f7 da                	neg    %edx
  8010a3:	85 ff                	test   %edi,%edi
  8010a5:	0f 45 c2             	cmovne %edx,%eax
}
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8010b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010be:	89 c3                	mov    %eax,%ebx
  8010c0:	89 c7                	mov    %eax,%edi
  8010c2:	89 c6                	mov    %eax,%esi
  8010c4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_cgetc>:

int
sys_cgetc(void) {
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
    asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8010f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	b8 03 00 00 00       	mov    $0x3,%eax
  801100:	89 cb                	mov    %ecx,%ebx
  801102:	89 cf                	mov    %ecx,%edi
  801104:	89 ce                	mov    %ecx,%esi
  801106:	cd 30                	int    $0x30
    if (check && ret > 0)
  801108:	85 c0                	test   %eax,%eax
  80110a:	7f 08                	jg     801114 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80110c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801114:	83 ec 0c             	sub    $0xc,%esp
  801117:	50                   	push   %eax
  801118:	6a 03                	push   $0x3
  80111a:	68 64 19 80 00       	push   $0x801964
  80111f:	6a 24                	push   $0x24
  801121:	68 81 19 80 00       	push   $0x801981
  801126:	e8 0c f5 ff ff       	call   800637 <_panic>

0080112b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
    asm volatile("int %1\n"
  801131:	ba 00 00 00 00       	mov    $0x0,%edx
  801136:	b8 02 00 00 00       	mov    $0x2,%eax
  80113b:	89 d1                	mov    %edx,%ecx
  80113d:	89 d3                	mov    %edx,%ebx
  80113f:	89 d7                	mov    %edx,%edi
  801141:	89 d6                	mov    %edx,%esi
  801143:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <sys_yield>:

void
sys_yield(void)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
    asm volatile("int %1\n"
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
  801155:	b8 0a 00 00 00       	mov    $0xa,%eax
  80115a:	89 d1                	mov    %edx,%ecx
  80115c:	89 d3                	mov    %edx,%ebx
  80115e:	89 d7                	mov    %edx,%edi
  801160:	89 d6                	mov    %edx,%esi
  801162:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  801172:	be 00 00 00 00       	mov    $0x0,%esi
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
  80117a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117d:	b8 04 00 00 00       	mov    $0x4,%eax
  801182:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801185:	89 f7                	mov    %esi,%edi
  801187:	cd 30                	int    $0x30
    if (check && ret > 0)
  801189:	85 c0                	test   %eax,%eax
  80118b:	7f 08                	jg     801195 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80118d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	50                   	push   %eax
  801199:	6a 04                	push   $0x4
  80119b:	68 64 19 80 00       	push   $0x801964
  8011a0:	6a 24                	push   $0x24
  8011a2:	68 81 19 80 00       	push   $0x801981
  8011a7:	e8 8b f4 ff ff       	call   800637 <_panic>

008011ac <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8011b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8011c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011c3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8011c9:	cd 30                	int    $0x30
    if (check && ret > 0)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	7f 08                	jg     8011d7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	50                   	push   %eax
  8011db:	6a 05                	push   $0x5
  8011dd:	68 64 19 80 00       	push   $0x801964
  8011e2:	6a 24                	push   $0x24
  8011e4:	68 81 19 80 00       	push   $0x801981
  8011e9:	e8 49 f4 ff ff       	call   800637 <_panic>

008011ee <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8011f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801202:	b8 06 00 00 00       	mov    $0x6,%eax
  801207:	89 df                	mov    %ebx,%edi
  801209:	89 de                	mov    %ebx,%esi
  80120b:	cd 30                	int    $0x30
    if (check && ret > 0)
  80120d:	85 c0                	test   %eax,%eax
  80120f:	7f 08                	jg     801219 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801214:	5b                   	pop    %ebx
  801215:	5e                   	pop    %esi
  801216:	5f                   	pop    %edi
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	50                   	push   %eax
  80121d:	6a 06                	push   $0x6
  80121f:	68 64 19 80 00       	push   $0x801964
  801224:	6a 24                	push   $0x24
  801226:	68 81 19 80 00       	push   $0x801981
  80122b:	e8 07 f4 ff ff       	call   800637 <_panic>

00801230 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801244:	b8 08 00 00 00       	mov    $0x8,%eax
  801249:	89 df                	mov    %ebx,%edi
  80124b:	89 de                	mov    %ebx,%esi
  80124d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80124f:	85 c0                	test   %eax,%eax
  801251:	7f 08                	jg     80125b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801256:	5b                   	pop    %ebx
  801257:	5e                   	pop    %esi
  801258:	5f                   	pop    %edi
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	50                   	push   %eax
  80125f:	6a 08                	push   $0x8
  801261:	68 64 19 80 00       	push   $0x801964
  801266:	6a 24                	push   $0x24
  801268:	68 81 19 80 00       	push   $0x801981
  80126d:	e8 c5 f3 ff ff       	call   800637 <_panic>

00801272 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	57                   	push   %edi
  801276:	56                   	push   %esi
  801277:	53                   	push   %ebx
  801278:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80127b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801286:	b8 09 00 00 00       	mov    $0x9,%eax
  80128b:	89 df                	mov    %ebx,%edi
  80128d:	89 de                	mov    %ebx,%esi
  80128f:	cd 30                	int    $0x30
    if (check && ret > 0)
  801291:	85 c0                	test   %eax,%eax
  801293:	7f 08                	jg     80129d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801295:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801298:	5b                   	pop    %ebx
  801299:	5e                   	pop    %esi
  80129a:	5f                   	pop    %edi
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	50                   	push   %eax
  8012a1:	6a 09                	push   $0x9
  8012a3:	68 64 19 80 00       	push   $0x801964
  8012a8:	6a 24                	push   $0x24
  8012aa:	68 81 19 80 00       	push   $0x801981
  8012af:	e8 83 f3 ff ff       	call   800637 <_panic>

008012b4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	57                   	push   %edi
  8012b8:	56                   	push   %esi
  8012b9:	53                   	push   %ebx
    asm volatile("int %1\n"
  8012ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8012bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012c5:	be 00 00 00 00       	mov    $0x0,%esi
  8012ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012cd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012d0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	57                   	push   %edi
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8012e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012ed:	89 cb                	mov    %ecx,%ebx
  8012ef:	89 cf                	mov    %ecx,%edi
  8012f1:	89 ce                	mov    %ecx,%esi
  8012f3:	cd 30                	int    $0x30
    if (check && ret > 0)
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	7f 08                	jg     801301 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fc:	5b                   	pop    %ebx
  8012fd:	5e                   	pop    %esi
  8012fe:	5f                   	pop    %edi
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801301:	83 ec 0c             	sub    $0xc,%esp
  801304:	50                   	push   %eax
  801305:	6a 0c                	push   $0xc
  801307:	68 64 19 80 00       	push   $0x801964
  80130c:	6a 24                	push   $0x24
  80130e:	68 81 19 80 00       	push   $0x801981
  801313:	e8 1f f3 ff ff       	call   800637 <_panic>

00801318 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80131e:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  801325:	74 0a                	je     801331 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	a3 d0 20 80 00       	mov    %eax,0x8020d0
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  801331:	a1 cc 20 80 00       	mov    0x8020cc,%eax
  801336:	8b 40 48             	mov    0x48(%eax),%eax
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	6a 07                	push   $0x7
  80133e:	68 00 f0 bf ee       	push   $0xeebff000
  801343:	25 ff 03 00 00       	and    $0x3ff,%eax
  801348:	50                   	push   %eax
  801349:	e8 1b fe ff ff       	call   801169 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  80134e:	a1 cc 20 80 00       	mov    0x8020cc,%eax
  801353:	8b 40 48             	mov    0x48(%eax),%eax
  801356:	83 c4 08             	add    $0x8,%esp
  801359:	68 6e 13 80 00       	push   $0x80136e
  80135e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801363:	50                   	push   %eax
  801364:	e8 09 ff ff ff       	call   801272 <sys_env_set_pgfault_upcall>
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	eb b9                	jmp    801327 <set_pgfault_handler+0xf>

0080136e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80136e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80136f:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  801374:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801376:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  801379:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  80137d:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  801381:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  801384:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  801386:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  80138a:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  80138d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  80138e:	83 c4 04             	add    $0x4,%esp
    popfl
  801391:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  801392:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801393:	c3                   	ret    
  801394:	66 90                	xchg   %ax,%ax
  801396:	66 90                	xchg   %ax,%ax
  801398:	66 90                	xchg   %ax,%ax
  80139a:	66 90                	xchg   %ax,%ax
  80139c:	66 90                	xchg   %ax,%ax
  80139e:	66 90                	xchg   %ax,%ax

008013a0 <__udivdi3>:
  8013a0:	55                   	push   %ebp
  8013a1:	57                   	push   %edi
  8013a2:	56                   	push   %esi
  8013a3:	53                   	push   %ebx
  8013a4:	83 ec 1c             	sub    $0x1c,%esp
  8013a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8013ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8013af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8013b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8013b7:	85 d2                	test   %edx,%edx
  8013b9:	75 35                	jne    8013f0 <__udivdi3+0x50>
  8013bb:	39 f3                	cmp    %esi,%ebx
  8013bd:	0f 87 bd 00 00 00    	ja     801480 <__udivdi3+0xe0>
  8013c3:	85 db                	test   %ebx,%ebx
  8013c5:	89 d9                	mov    %ebx,%ecx
  8013c7:	75 0b                	jne    8013d4 <__udivdi3+0x34>
  8013c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8013ce:	31 d2                	xor    %edx,%edx
  8013d0:	f7 f3                	div    %ebx
  8013d2:	89 c1                	mov    %eax,%ecx
  8013d4:	31 d2                	xor    %edx,%edx
  8013d6:	89 f0                	mov    %esi,%eax
  8013d8:	f7 f1                	div    %ecx
  8013da:	89 c6                	mov    %eax,%esi
  8013dc:	89 e8                	mov    %ebp,%eax
  8013de:	89 f7                	mov    %esi,%edi
  8013e0:	f7 f1                	div    %ecx
  8013e2:	89 fa                	mov    %edi,%edx
  8013e4:	83 c4 1c             	add    $0x1c,%esp
  8013e7:	5b                   	pop    %ebx
  8013e8:	5e                   	pop    %esi
  8013e9:	5f                   	pop    %edi
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    
  8013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8013f0:	39 f2                	cmp    %esi,%edx
  8013f2:	77 7c                	ja     801470 <__udivdi3+0xd0>
  8013f4:	0f bd fa             	bsr    %edx,%edi
  8013f7:	83 f7 1f             	xor    $0x1f,%edi
  8013fa:	0f 84 98 00 00 00    	je     801498 <__udivdi3+0xf8>
  801400:	89 f9                	mov    %edi,%ecx
  801402:	b8 20 00 00 00       	mov    $0x20,%eax
  801407:	29 f8                	sub    %edi,%eax
  801409:	d3 e2                	shl    %cl,%edx
  80140b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80140f:	89 c1                	mov    %eax,%ecx
  801411:	89 da                	mov    %ebx,%edx
  801413:	d3 ea                	shr    %cl,%edx
  801415:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801419:	09 d1                	or     %edx,%ecx
  80141b:	89 f2                	mov    %esi,%edx
  80141d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801421:	89 f9                	mov    %edi,%ecx
  801423:	d3 e3                	shl    %cl,%ebx
  801425:	89 c1                	mov    %eax,%ecx
  801427:	d3 ea                	shr    %cl,%edx
  801429:	89 f9                	mov    %edi,%ecx
  80142b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80142f:	d3 e6                	shl    %cl,%esi
  801431:	89 eb                	mov    %ebp,%ebx
  801433:	89 c1                	mov    %eax,%ecx
  801435:	d3 eb                	shr    %cl,%ebx
  801437:	09 de                	or     %ebx,%esi
  801439:	89 f0                	mov    %esi,%eax
  80143b:	f7 74 24 08          	divl   0x8(%esp)
  80143f:	89 d6                	mov    %edx,%esi
  801441:	89 c3                	mov    %eax,%ebx
  801443:	f7 64 24 0c          	mull   0xc(%esp)
  801447:	39 d6                	cmp    %edx,%esi
  801449:	72 0c                	jb     801457 <__udivdi3+0xb7>
  80144b:	89 f9                	mov    %edi,%ecx
  80144d:	d3 e5                	shl    %cl,%ebp
  80144f:	39 c5                	cmp    %eax,%ebp
  801451:	73 5d                	jae    8014b0 <__udivdi3+0x110>
  801453:	39 d6                	cmp    %edx,%esi
  801455:	75 59                	jne    8014b0 <__udivdi3+0x110>
  801457:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80145a:	31 ff                	xor    %edi,%edi
  80145c:	89 fa                	mov    %edi,%edx
  80145e:	83 c4 1c             	add    $0x1c,%esp
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5f                   	pop    %edi
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    
  801466:	8d 76 00             	lea    0x0(%esi),%esi
  801469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801470:	31 ff                	xor    %edi,%edi
  801472:	31 c0                	xor    %eax,%eax
  801474:	89 fa                	mov    %edi,%edx
  801476:	83 c4 1c             	add    $0x1c,%esp
  801479:	5b                   	pop    %ebx
  80147a:	5e                   	pop    %esi
  80147b:	5f                   	pop    %edi
  80147c:	5d                   	pop    %ebp
  80147d:	c3                   	ret    
  80147e:	66 90                	xchg   %ax,%ax
  801480:	31 ff                	xor    %edi,%edi
  801482:	89 e8                	mov    %ebp,%eax
  801484:	89 f2                	mov    %esi,%edx
  801486:	f7 f3                	div    %ebx
  801488:	89 fa                	mov    %edi,%edx
  80148a:	83 c4 1c             	add    $0x1c,%esp
  80148d:	5b                   	pop    %ebx
  80148e:	5e                   	pop    %esi
  80148f:	5f                   	pop    %edi
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    
  801492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801498:	39 f2                	cmp    %esi,%edx
  80149a:	72 06                	jb     8014a2 <__udivdi3+0x102>
  80149c:	31 c0                	xor    %eax,%eax
  80149e:	39 eb                	cmp    %ebp,%ebx
  8014a0:	77 d2                	ja     801474 <__udivdi3+0xd4>
  8014a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a7:	eb cb                	jmp    801474 <__udivdi3+0xd4>
  8014a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014b0:	89 d8                	mov    %ebx,%eax
  8014b2:	31 ff                	xor    %edi,%edi
  8014b4:	eb be                	jmp    801474 <__udivdi3+0xd4>
  8014b6:	66 90                	xchg   %ax,%ax
  8014b8:	66 90                	xchg   %ax,%ax
  8014ba:	66 90                	xchg   %ax,%ax
  8014bc:	66 90                	xchg   %ax,%ax
  8014be:	66 90                	xchg   %ax,%ax

008014c0 <__umoddi3>:
  8014c0:	55                   	push   %ebp
  8014c1:	57                   	push   %edi
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	83 ec 1c             	sub    $0x1c,%esp
  8014c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8014cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8014cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8014d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8014d7:	85 ed                	test   %ebp,%ebp
  8014d9:	89 f0                	mov    %esi,%eax
  8014db:	89 da                	mov    %ebx,%edx
  8014dd:	75 19                	jne    8014f8 <__umoddi3+0x38>
  8014df:	39 df                	cmp    %ebx,%edi
  8014e1:	0f 86 b1 00 00 00    	jbe    801598 <__umoddi3+0xd8>
  8014e7:	f7 f7                	div    %edi
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	31 d2                	xor    %edx,%edx
  8014ed:	83 c4 1c             	add    $0x1c,%esp
  8014f0:	5b                   	pop    %ebx
  8014f1:	5e                   	pop    %esi
  8014f2:	5f                   	pop    %edi
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    
  8014f5:	8d 76 00             	lea    0x0(%esi),%esi
  8014f8:	39 dd                	cmp    %ebx,%ebp
  8014fa:	77 f1                	ja     8014ed <__umoddi3+0x2d>
  8014fc:	0f bd cd             	bsr    %ebp,%ecx
  8014ff:	83 f1 1f             	xor    $0x1f,%ecx
  801502:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801506:	0f 84 b4 00 00 00    	je     8015c0 <__umoddi3+0x100>
  80150c:	b8 20 00 00 00       	mov    $0x20,%eax
  801511:	89 c2                	mov    %eax,%edx
  801513:	8b 44 24 04          	mov    0x4(%esp),%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 c1                	mov    %eax,%ecx
  80151b:	89 f8                	mov    %edi,%eax
  80151d:	d3 e5                	shl    %cl,%ebp
  80151f:	89 d1                	mov    %edx,%ecx
  801521:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801525:	d3 e8                	shr    %cl,%eax
  801527:	09 c5                	or     %eax,%ebp
  801529:	8b 44 24 04          	mov    0x4(%esp),%eax
  80152d:	89 c1                	mov    %eax,%ecx
  80152f:	d3 e7                	shl    %cl,%edi
  801531:	89 d1                	mov    %edx,%ecx
  801533:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801537:	89 df                	mov    %ebx,%edi
  801539:	d3 ef                	shr    %cl,%edi
  80153b:	89 c1                	mov    %eax,%ecx
  80153d:	89 f0                	mov    %esi,%eax
  80153f:	d3 e3                	shl    %cl,%ebx
  801541:	89 d1                	mov    %edx,%ecx
  801543:	89 fa                	mov    %edi,%edx
  801545:	d3 e8                	shr    %cl,%eax
  801547:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80154c:	09 d8                	or     %ebx,%eax
  80154e:	f7 f5                	div    %ebp
  801550:	d3 e6                	shl    %cl,%esi
  801552:	89 d1                	mov    %edx,%ecx
  801554:	f7 64 24 08          	mull   0x8(%esp)
  801558:	39 d1                	cmp    %edx,%ecx
  80155a:	89 c3                	mov    %eax,%ebx
  80155c:	89 d7                	mov    %edx,%edi
  80155e:	72 06                	jb     801566 <__umoddi3+0xa6>
  801560:	75 0e                	jne    801570 <__umoddi3+0xb0>
  801562:	39 c6                	cmp    %eax,%esi
  801564:	73 0a                	jae    801570 <__umoddi3+0xb0>
  801566:	2b 44 24 08          	sub    0x8(%esp),%eax
  80156a:	19 ea                	sbb    %ebp,%edx
  80156c:	89 d7                	mov    %edx,%edi
  80156e:	89 c3                	mov    %eax,%ebx
  801570:	89 ca                	mov    %ecx,%edx
  801572:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801577:	29 de                	sub    %ebx,%esi
  801579:	19 fa                	sbb    %edi,%edx
  80157b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80157f:	89 d0                	mov    %edx,%eax
  801581:	d3 e0                	shl    %cl,%eax
  801583:	89 d9                	mov    %ebx,%ecx
  801585:	d3 ee                	shr    %cl,%esi
  801587:	d3 ea                	shr    %cl,%edx
  801589:	09 f0                	or     %esi,%eax
  80158b:	83 c4 1c             	add    $0x1c,%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5f                   	pop    %edi
  801591:	5d                   	pop    %ebp
  801592:	c3                   	ret    
  801593:	90                   	nop
  801594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801598:	85 ff                	test   %edi,%edi
  80159a:	89 f9                	mov    %edi,%ecx
  80159c:	75 0b                	jne    8015a9 <__umoddi3+0xe9>
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a3:	31 d2                	xor    %edx,%edx
  8015a5:	f7 f7                	div    %edi
  8015a7:	89 c1                	mov    %eax,%ecx
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	31 d2                	xor    %edx,%edx
  8015ad:	f7 f1                	div    %ecx
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	f7 f1                	div    %ecx
  8015b3:	e9 31 ff ff ff       	jmp    8014e9 <__umoddi3+0x29>
  8015b8:	90                   	nop
  8015b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015c0:	39 dd                	cmp    %ebx,%ebp
  8015c2:	72 08                	jb     8015cc <__umoddi3+0x10c>
  8015c4:	39 f7                	cmp    %esi,%edi
  8015c6:	0f 87 21 ff ff ff    	ja     8014ed <__umoddi3+0x2d>
  8015cc:	89 da                	mov    %ebx,%edx
  8015ce:	89 f0                	mov    %esi,%eax
  8015d0:	29 f8                	sub    %edi,%eax
  8015d2:	19 ea                	sbb    %ebp,%edx
  8015d4:	e9 14 ff ff ff       	jmp    8014ed <__umoddi3+0x2d>
