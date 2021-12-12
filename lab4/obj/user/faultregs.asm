
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
  800044:	68 b1 15 80 00       	push   $0x8015b1
  800049:	68 80 15 80 00       	push   $0x801580
  80004e:	e8 af 06 00 00       	call   800702 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 90 15 80 00       	push   $0x801590
  80005c:	68 94 15 80 00       	push   $0x801594
  800061:	e8 9c 06 00 00       	call   800702 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 31 02 00 00    	je     8002a4 <check_regs+0x271>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a8 15 80 00       	push   $0x8015a8
  80007b:	e8 82 06 00 00       	call   800702 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 b2 15 80 00       	push   $0x8015b2
  800093:	68 94 15 80 00       	push   $0x801594
  800098:	e8 65 06 00 00       	call   800702 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 12 02 00 00    	je     8002be <check_regs+0x28b>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 a8 15 80 00       	push   $0x8015a8
  8000b4:	e8 49 06 00 00       	call   800702 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 b6 15 80 00       	push   $0x8015b6
  8000cc:	68 94 15 80 00       	push   $0x801594
  8000d1:	e8 2c 06 00 00       	call   800702 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 ee 01 00 00    	je     8002d3 <check_regs+0x2a0>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 a8 15 80 00       	push   $0x8015a8
  8000ed:	e8 10 06 00 00       	call   800702 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 ba 15 80 00       	push   $0x8015ba
  800105:	68 94 15 80 00       	push   $0x801594
  80010a:	e8 f3 05 00 00       	call   800702 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 ca 01 00 00    	je     8002e8 <check_regs+0x2b5>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 a8 15 80 00       	push   $0x8015a8
  800126:	e8 d7 05 00 00       	call   800702 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 be 15 80 00       	push   $0x8015be
  80013e:	68 94 15 80 00       	push   $0x801594
  800143:	e8 ba 05 00 00       	call   800702 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a6 01 00 00    	je     8002fd <check_regs+0x2ca>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 a8 15 80 00       	push   $0x8015a8
  80015f:	e8 9e 05 00 00       	call   800702 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 c2 15 80 00       	push   $0x8015c2
  800177:	68 94 15 80 00       	push   $0x801594
  80017c:	e8 81 05 00 00       	call   800702 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 82 01 00 00    	je     800312 <check_regs+0x2df>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 a8 15 80 00       	push   $0x8015a8
  800198:	e8 65 05 00 00       	call   800702 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 c6 15 80 00       	push   $0x8015c6
  8001b0:	68 94 15 80 00       	push   $0x801594
  8001b5:	e8 48 05 00 00       	call   800702 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5e 01 00 00    	je     800327 <check_regs+0x2f4>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 a8 15 80 00       	push   $0x8015a8
  8001d1:	e8 2c 05 00 00       	call   800702 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 ca 15 80 00       	push   $0x8015ca
  8001e9:	68 94 15 80 00       	push   $0x801594
  8001ee:	e8 0f 05 00 00       	call   800702 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 3a 01 00 00    	je     80033c <check_regs+0x309>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 a8 15 80 00       	push   $0x8015a8
  80020a:	e8 f3 04 00 00       	call   800702 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ce 15 80 00       	push   $0x8015ce
  800222:	68 94 15 80 00       	push   $0x801594
  800227:	e8 d6 04 00 00       	call   800702 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 16 01 00 00    	je     800351 <check_regs+0x31e>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 a8 15 80 00       	push   $0x8015a8
  800243:	e8 ba 04 00 00       	call   800702 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 d5 15 80 00       	push   $0x8015d5
  800253:	68 94 15 80 00       	push   $0x801594
  800258:	e8 a5 04 00 00       	call   800702 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 a8 15 80 00       	push   $0x8015a8
  800274:	e8 89 04 00 00       	call   800702 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 d9 15 80 00       	push   $0x8015d9
  800284:	e8 79 04 00 00       	call   800702 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 a8 15 80 00       	push   $0x8015a8
  800294:	e8 69 04 00 00       	call   800702 <cprintf>
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
  8002a7:	68 a4 15 80 00       	push   $0x8015a4
  8002ac:	e8 51 04 00 00       	call   800702 <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b9:	e9 ca fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 a4 15 80 00       	push   $0x8015a4
  8002c6:	e8 37 04 00 00       	call   800702 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	e9 ee fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 a4 15 80 00       	push   $0x8015a4
  8002db:	e8 22 04 00 00       	call   800702 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	e9 12 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 a4 15 80 00       	push   $0x8015a4
  8002f0:	e8 0d 04 00 00       	call   800702 <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	e9 36 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 a4 15 80 00       	push   $0x8015a4
  800305:	e8 f8 03 00 00       	call   800702 <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	e9 5a fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	68 a4 15 80 00       	push   $0x8015a4
  80031a:	e8 e3 03 00 00       	call   800702 <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	e9 7e fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 a4 15 80 00       	push   $0x8015a4
  80032f:	e8 ce 03 00 00       	call   800702 <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	e9 a2 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 a4 15 80 00       	push   $0x8015a4
  800344:	e8 b9 03 00 00       	call   800702 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 c6 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	68 a4 15 80 00       	push   $0x8015a4
  800359:	e8 a4 03 00 00       	call   800702 <cprintf>
	CHECK(esp, esp);
  80035e:	ff 73 28             	pushl  0x28(%ebx)
  800361:	ff 76 28             	pushl  0x28(%esi)
  800364:	68 d5 15 80 00       	push   $0x8015d5
  800369:	68 94 15 80 00       	push   $0x801594
  80036e:	e8 8f 03 00 00       	call   800702 <cprintf>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	8b 43 28             	mov    0x28(%ebx),%eax
  800379:	39 46 28             	cmp    %eax,0x28(%esi)
  80037c:	0f 85 ea fe ff ff    	jne    80026c <check_regs+0x239>
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 a4 15 80 00       	push   $0x8015a4
  80038a:	e8 73 03 00 00       	call   800702 <cprintf>
	cprintf("Registers %s ", testname);
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	68 d9 15 80 00       	push   $0x8015d9
  80039a:	e8 63 03 00 00       	call   800702 <cprintf>
	if (!mismatch)
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	85 ff                	test   %edi,%edi
  8003a4:	0f 85 e2 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 a4 15 80 00       	push   $0x8015a4
  8003b2:	e8 4b 03 00 00       	call   800702 <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	e9 dd fe ff ff       	jmp    80029c <check_regs+0x269>
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 a4 15 80 00       	push   $0x8015a4
  8003c7:	e8 36 03 00 00       	call   800702 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 d9 15 80 00       	push   $0x8015d9
  8003d7:	e8 26 03 00 00       	call   800702 <cprintf>
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
  800466:	68 ff 15 80 00       	push   $0x8015ff
  80046b:	68 0d 16 80 00       	push   $0x80160d
  800470:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800475:	ba f8 15 80 00       	mov    $0x8015f8,%edx
  80047a:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 c4 0c 00 00       	call   801159 <sys_page_alloc>
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
  8004a5:	68 40 16 80 00       	push   $0x801640
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 e7 15 80 00       	push   $0x8015e7
  8004b1:	e8 71 01 00 00       	call   800627 <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 14 16 80 00       	push   $0x801614
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 e7 15 80 00       	push   $0x8015e7
  8004c3:	e8 5f 01 00 00       	call   800627 <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 30 0e 00 00       	call   801308 <set_pgfault_handler>

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
  8005a2:	68 74 16 80 00       	push   $0x801674
  8005a7:	e8 56 01 00 00       	call   800702 <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  8005af:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  8005b4:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	68 27 16 80 00       	push   $0x801627
  8005c1:	68 38 16 80 00       	push   $0x801638
  8005c6:	b9 20 20 80 00       	mov    $0x802020,%ecx
  8005cb:	ba f8 15 80 00       	mov    $0x8015f8,%edx
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
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  8005eb:	c7 05 cc 20 80 00 00 	movl   $0xeec00000,0x8020cc
  8005f2:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	7e 08                	jle    800601 <libmain+0x22>
		binaryname = argv[0];
  8005f9:	8b 0a                	mov    (%edx),%ecx
  8005fb:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	e8 bd fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  80060b:	e8 05 00 00 00       	call   800615 <exit>
}
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80061b:	6a 00                	push   $0x0
  80061d:	e8 b8 0a 00 00       	call   8010da <sys_env_destroy>
}
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	c9                   	leave  
  800626:	c3                   	ret    

00800627 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	56                   	push   %esi
  80062b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80062c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80062f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800635:	e8 e1 0a 00 00       	call   80111b <sys_getenvid>
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	ff 75 0c             	pushl  0xc(%ebp)
  800640:	ff 75 08             	pushl  0x8(%ebp)
  800643:	56                   	push   %esi
  800644:	50                   	push   %eax
  800645:	68 a0 16 80 00       	push   $0x8016a0
  80064a:	e8 b3 00 00 00       	call   800702 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80064f:	83 c4 18             	add    $0x18,%esp
  800652:	53                   	push   %ebx
  800653:	ff 75 10             	pushl  0x10(%ebp)
  800656:	e8 56 00 00 00       	call   8006b1 <vcprintf>
	cprintf("\n");
  80065b:	c7 04 24 b0 15 80 00 	movl   $0x8015b0,(%esp)
  800662:	e8 9b 00 00 00       	call   800702 <cprintf>
  800667:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80066a:	cc                   	int3   
  80066b:	eb fd                	jmp    80066a <_panic+0x43>

0080066d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	53                   	push   %ebx
  800671:	83 ec 04             	sub    $0x4,%esp
  800674:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800677:	8b 13                	mov    (%ebx),%edx
  800679:	8d 42 01             	lea    0x1(%edx),%eax
  80067c:	89 03                	mov    %eax,(%ebx)
  80067e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800681:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800685:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068a:	74 09                	je     800695 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80068c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800693:	c9                   	leave  
  800694:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	68 ff 00 00 00       	push   $0xff
  80069d:	8d 43 08             	lea    0x8(%ebx),%eax
  8006a0:	50                   	push   %eax
  8006a1:	e8 f7 09 00 00       	call   80109d <sys_cputs>
		b->idx = 0;
  8006a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	eb db                	jmp    80068c <putch+0x1f>

008006b1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
  8006b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c1:	00 00 00 
	b.cnt = 0;
  8006c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006cb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006da:	50                   	push   %eax
  8006db:	68 6d 06 80 00       	push   $0x80066d
  8006e0:	e8 1a 01 00 00       	call   8007ff <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006e5:	83 c4 08             	add    $0x8,%esp
  8006e8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006ee:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006f4:	50                   	push   %eax
  8006f5:	e8 a3 09 00 00       	call   80109d <sys_cputs>

	return b.cnt;
}
  8006fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800708:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80070b:	50                   	push   %eax
  80070c:	ff 75 08             	pushl  0x8(%ebp)
  80070f:	e8 9d ff ff ff       	call   8006b1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800714:	c9                   	leave  
  800715:	c3                   	ret    

00800716 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	57                   	push   %edi
  80071a:	56                   	push   %esi
  80071b:	53                   	push   %ebx
  80071c:	83 ec 1c             	sub    $0x1c,%esp
  80071f:	89 c7                	mov    %eax,%edi
  800721:	89 d6                	mov    %edx,%esi
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	8b 55 0c             	mov    0xc(%ebp),%edx
  800729:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80072f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800732:	bb 00 00 00 00       	mov    $0x0,%ebx
  800737:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80073a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80073d:	39 d3                	cmp    %edx,%ebx
  80073f:	72 05                	jb     800746 <printnum+0x30>
  800741:	39 45 10             	cmp    %eax,0x10(%ebp)
  800744:	77 7a                	ja     8007c0 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800746:	83 ec 0c             	sub    $0xc,%esp
  800749:	ff 75 18             	pushl  0x18(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800752:	53                   	push   %ebx
  800753:	ff 75 10             	pushl  0x10(%ebp)
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 e4             	pushl  -0x1c(%ebp)
  80075c:	ff 75 e0             	pushl  -0x20(%ebp)
  80075f:	ff 75 dc             	pushl  -0x24(%ebp)
  800762:	ff 75 d8             	pushl  -0x28(%ebp)
  800765:	e8 d6 0b 00 00       	call   801340 <__udivdi3>
  80076a:	83 c4 18             	add    $0x18,%esp
  80076d:	52                   	push   %edx
  80076e:	50                   	push   %eax
  80076f:	89 f2                	mov    %esi,%edx
  800771:	89 f8                	mov    %edi,%eax
  800773:	e8 9e ff ff ff       	call   800716 <printnum>
  800778:	83 c4 20             	add    $0x20,%esp
  80077b:	eb 13                	jmp    800790 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	56                   	push   %esi
  800781:	ff 75 18             	pushl  0x18(%ebp)
  800784:	ff d7                	call   *%edi
  800786:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800789:	83 eb 01             	sub    $0x1,%ebx
  80078c:	85 db                	test   %ebx,%ebx
  80078e:	7f ed                	jg     80077d <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	56                   	push   %esi
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	ff 75 e4             	pushl  -0x1c(%ebp)
  80079a:	ff 75 e0             	pushl  -0x20(%ebp)
  80079d:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a3:	e8 b8 0c 00 00       	call   801460 <__umoddi3>
  8007a8:	83 c4 14             	add    $0x14,%esp
  8007ab:	0f be 80 c3 16 80 00 	movsbl 0x8016c3(%eax),%eax
  8007b2:	50                   	push   %eax
  8007b3:	ff d7                	call   *%edi
}
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007bb:	5b                   	pop    %ebx
  8007bc:	5e                   	pop    %esi
  8007bd:	5f                   	pop    %edi
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    
  8007c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007c3:	eb c4                	jmp    800789 <printnum+0x73>

008007c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007cf:	8b 10                	mov    (%eax),%edx
  8007d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8007d4:	73 0a                	jae    8007e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007d9:	89 08                	mov    %ecx,(%eax)
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	88 02                	mov    %al,(%edx)
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <printfmt>:
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007eb:	50                   	push   %eax
  8007ec:	ff 75 10             	pushl  0x10(%ebp)
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	e8 05 00 00 00       	call   8007ff <vprintfmt>
}
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    

008007ff <vprintfmt>:
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	57                   	push   %edi
  800803:	56                   	push   %esi
  800804:	53                   	push   %ebx
  800805:	83 ec 2c             	sub    $0x2c,%esp
  800808:	8b 75 08             	mov    0x8(%ebp),%esi
  80080b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80080e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800811:	e9 00 04 00 00       	jmp    800c16 <vprintfmt+0x417>
		padc = ' ';
  800816:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80081a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800821:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800828:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80082f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800834:	8d 47 01             	lea    0x1(%edi),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	0f b6 17             	movzbl (%edi),%edx
  80083d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800840:	3c 55                	cmp    $0x55,%al
  800842:	0f 87 51 04 00 00    	ja     800c99 <vprintfmt+0x49a>
  800848:	0f b6 c0             	movzbl %al,%eax
  80084b:	ff 24 85 80 17 80 00 	jmp    *0x801780(,%eax,4)
  800852:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800855:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800859:	eb d9                	jmp    800834 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80085b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80085e:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800862:	eb d0                	jmp    800834 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800864:	0f b6 d2             	movzbl %dl,%edx
  800867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80086a:	b8 00 00 00 00       	mov    $0x0,%eax
  80086f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800872:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800875:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800879:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80087c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80087f:	83 f9 09             	cmp    $0x9,%ecx
  800882:	77 55                	ja     8008d9 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800884:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800887:	eb e9                	jmp    800872 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80089a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80089d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008a1:	79 91                	jns    800834 <vprintfmt+0x35>
				width = precision, precision = -1;
  8008a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008a9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008b0:	eb 82                	jmp    800834 <vprintfmt+0x35>
  8008b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bc:	0f 49 d0             	cmovns %eax,%edx
  8008bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008c5:	e9 6a ff ff ff       	jmp    800834 <vprintfmt+0x35>
  8008ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008cd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008d4:	e9 5b ff ff ff       	jmp    800834 <vprintfmt+0x35>
  8008d9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008df:	eb bc                	jmp    80089d <vprintfmt+0x9e>
			lflag++;
  8008e1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008e7:	e9 48 ff ff ff       	jmp    800834 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8d 78 04             	lea    0x4(%eax),%edi
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	53                   	push   %ebx
  8008f6:	ff 30                	pushl  (%eax)
  8008f8:	ff d6                	call   *%esi
			break;
  8008fa:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008fd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800900:	e9 0e 03 00 00       	jmp    800c13 <vprintfmt+0x414>
			err = va_arg(ap, int);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8d 78 04             	lea    0x4(%eax),%edi
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	99                   	cltd   
  80090e:	31 d0                	xor    %edx,%eax
  800910:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800912:	83 f8 08             	cmp    $0x8,%eax
  800915:	7f 23                	jg     80093a <vprintfmt+0x13b>
  800917:	8b 14 85 e0 18 80 00 	mov    0x8018e0(,%eax,4),%edx
  80091e:	85 d2                	test   %edx,%edx
  800920:	74 18                	je     80093a <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800922:	52                   	push   %edx
  800923:	68 e4 16 80 00       	push   $0x8016e4
  800928:	53                   	push   %ebx
  800929:	56                   	push   %esi
  80092a:	e8 b3 fe ff ff       	call   8007e2 <printfmt>
  80092f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800932:	89 7d 14             	mov    %edi,0x14(%ebp)
  800935:	e9 d9 02 00 00       	jmp    800c13 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80093a:	50                   	push   %eax
  80093b:	68 db 16 80 00       	push   $0x8016db
  800940:	53                   	push   %ebx
  800941:	56                   	push   %esi
  800942:	e8 9b fe ff ff       	call   8007e2 <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80094a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80094d:	e9 c1 02 00 00       	jmp    800c13 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	83 c0 04             	add    $0x4,%eax
  800958:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800960:	85 ff                	test   %edi,%edi
  800962:	b8 d4 16 80 00       	mov    $0x8016d4,%eax
  800967:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80096a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096e:	0f 8e bd 00 00 00    	jle    800a31 <vprintfmt+0x232>
  800974:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800978:	75 0e                	jne    800988 <vprintfmt+0x189>
  80097a:	89 75 08             	mov    %esi,0x8(%ebp)
  80097d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800980:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800983:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800986:	eb 6d                	jmp    8009f5 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 d0             	pushl  -0x30(%ebp)
  80098e:	57                   	push   %edi
  80098f:	e8 ad 03 00 00       	call   800d41 <strnlen>
  800994:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800997:	29 c1                	sub    %eax,%ecx
  800999:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80099c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80099f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009a6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009a9:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ab:	eb 0f                	jmp    8009bc <vprintfmt+0x1bd>
					putch(padc, putdat);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	53                   	push   %ebx
  8009b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8009b4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b6:	83 ef 01             	sub    $0x1,%edi
  8009b9:	83 c4 10             	add    $0x10,%esp
  8009bc:	85 ff                	test   %edi,%edi
  8009be:	7f ed                	jg     8009ad <vprintfmt+0x1ae>
  8009c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009c3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009c6:	85 c9                	test   %ecx,%ecx
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cd:	0f 49 c1             	cmovns %ecx,%eax
  8009d0:	29 c1                	sub    %eax,%ecx
  8009d2:	89 75 08             	mov    %esi,0x8(%ebp)
  8009d5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009d8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009db:	89 cb                	mov    %ecx,%ebx
  8009dd:	eb 16                	jmp    8009f5 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009df:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009e3:	75 31                	jne    800a16 <vprintfmt+0x217>
					putch(ch, putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	50                   	push   %eax
  8009ec:	ff 55 08             	call   *0x8(%ebp)
  8009ef:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f2:	83 eb 01             	sub    $0x1,%ebx
  8009f5:	83 c7 01             	add    $0x1,%edi
  8009f8:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8009fc:	0f be c2             	movsbl %dl,%eax
  8009ff:	85 c0                	test   %eax,%eax
  800a01:	74 59                	je     800a5c <vprintfmt+0x25d>
  800a03:	85 f6                	test   %esi,%esi
  800a05:	78 d8                	js     8009df <vprintfmt+0x1e0>
  800a07:	83 ee 01             	sub    $0x1,%esi
  800a0a:	79 d3                	jns    8009df <vprintfmt+0x1e0>
  800a0c:	89 df                	mov    %ebx,%edi
  800a0e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a14:	eb 37                	jmp    800a4d <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a16:	0f be d2             	movsbl %dl,%edx
  800a19:	83 ea 20             	sub    $0x20,%edx
  800a1c:	83 fa 5e             	cmp    $0x5e,%edx
  800a1f:	76 c4                	jbe    8009e5 <vprintfmt+0x1e6>
					putch('?', putdat);
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	6a 3f                	push   $0x3f
  800a29:	ff 55 08             	call   *0x8(%ebp)
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	eb c1                	jmp    8009f2 <vprintfmt+0x1f3>
  800a31:	89 75 08             	mov    %esi,0x8(%ebp)
  800a34:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a37:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a3a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a3d:	eb b6                	jmp    8009f5 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	53                   	push   %ebx
  800a43:	6a 20                	push   $0x20
  800a45:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a47:	83 ef 01             	sub    $0x1,%edi
  800a4a:	83 c4 10             	add    $0x10,%esp
  800a4d:	85 ff                	test   %edi,%edi
  800a4f:	7f ee                	jg     800a3f <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a54:	89 45 14             	mov    %eax,0x14(%ebp)
  800a57:	e9 b7 01 00 00       	jmp    800c13 <vprintfmt+0x414>
  800a5c:	89 df                	mov    %ebx,%edi
  800a5e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a64:	eb e7                	jmp    800a4d <vprintfmt+0x24e>
	if (lflag >= 2)
  800a66:	83 f9 01             	cmp    $0x1,%ecx
  800a69:	7e 3f                	jle    800aaa <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8b 50 04             	mov    0x4(%eax),%edx
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a76:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	8d 40 08             	lea    0x8(%eax),%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a86:	79 5c                	jns    800ae4 <vprintfmt+0x2e5>
				putch('-', putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	53                   	push   %ebx
  800a8c:	6a 2d                	push   $0x2d
  800a8e:	ff d6                	call   *%esi
				num = -(long long) num;
  800a90:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a93:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800a96:	f7 da                	neg    %edx
  800a98:	83 d1 00             	adc    $0x0,%ecx
  800a9b:	f7 d9                	neg    %ecx
  800a9d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800aa0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa5:	e9 4f 01 00 00       	jmp    800bf9 <vprintfmt+0x3fa>
	else if (lflag)
  800aaa:	85 c9                	test   %ecx,%ecx
  800aac:	75 1b                	jne    800ac9 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab6:	89 c1                	mov    %eax,%ecx
  800ab8:	c1 f9 1f             	sar    $0x1f,%ecx
  800abb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	8d 40 04             	lea    0x4(%eax),%eax
  800ac4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac7:	eb b9                	jmp    800a82 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad1:	89 c1                	mov    %eax,%ecx
  800ad3:	c1 f9 1f             	sar    $0x1f,%ecx
  800ad6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	8d 40 04             	lea    0x4(%eax),%eax
  800adf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae2:	eb 9e                	jmp    800a82 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800ae4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ae7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800aea:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aef:	e9 05 01 00 00       	jmp    800bf9 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800af4:	83 f9 01             	cmp    $0x1,%ecx
  800af7:	7e 18                	jle    800b11 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8b 10                	mov    (%eax),%edx
  800afe:	8b 48 04             	mov    0x4(%eax),%ecx
  800b01:	8d 40 08             	lea    0x8(%eax),%eax
  800b04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0c:	e9 e8 00 00 00       	jmp    800bf9 <vprintfmt+0x3fa>
	else if (lflag)
  800b11:	85 c9                	test   %ecx,%ecx
  800b13:	75 1a                	jne    800b2f <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	8b 10                	mov    (%eax),%edx
  800b1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1f:	8d 40 04             	lea    0x4(%eax),%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2a:	e9 ca 00 00 00       	jmp    800bf9 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8b 10                	mov    (%eax),%edx
  800b34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b39:	8d 40 04             	lea    0x4(%eax),%eax
  800b3c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b44:	e9 b0 00 00 00       	jmp    800bf9 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800b49:	83 f9 01             	cmp    $0x1,%ecx
  800b4c:	7e 3c                	jle    800b8a <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800b4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b51:	8b 50 04             	mov    0x4(%eax),%edx
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b59:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	8d 40 08             	lea    0x8(%eax),%eax
  800b62:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	79 59                	jns    800bc4 <vprintfmt+0x3c5>
                putch('-', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	53                   	push   %ebx
  800b6f:	6a 2d                	push   $0x2d
  800b71:	ff d6                	call   *%esi
                num = -(long long) num;
  800b73:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b76:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b79:	f7 da                	neg    %edx
  800b7b:	83 d1 00             	adc    $0x0,%ecx
  800b7e:	f7 d9                	neg    %ecx
  800b80:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800b83:	b8 08 00 00 00       	mov    $0x8,%eax
  800b88:	eb 6f                	jmp    800bf9 <vprintfmt+0x3fa>
	else if (lflag)
  800b8a:	85 c9                	test   %ecx,%ecx
  800b8c:	75 1b                	jne    800ba9 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b96:	89 c1                	mov    %eax,%ecx
  800b98:	c1 f9 1f             	sar    $0x1f,%ecx
  800b9b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba1:	8d 40 04             	lea    0x4(%eax),%eax
  800ba4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba7:	eb bc                	jmp    800b65 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb1:	89 c1                	mov    %eax,%ecx
  800bb3:	c1 f9 1f             	sar    $0x1f,%ecx
  800bb6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbc:	8d 40 04             	lea    0x4(%eax),%eax
  800bbf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc2:	eb a1                	jmp    800b65 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800bc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bc7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800bca:	b8 08 00 00 00       	mov    $0x8,%eax
  800bcf:	eb 28                	jmp    800bf9 <vprintfmt+0x3fa>
			putch('0', putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	53                   	push   %ebx
  800bd5:	6a 30                	push   $0x30
  800bd7:	ff d6                	call   *%esi
			putch('x', putdat);
  800bd9:	83 c4 08             	add    $0x8,%esp
  800bdc:	53                   	push   %ebx
  800bdd:	6a 78                	push   $0x78
  800bdf:	ff d6                	call   *%esi
			num = (unsigned long long)
  800be1:	8b 45 14             	mov    0x14(%ebp),%eax
  800be4:	8b 10                	mov    (%eax),%edx
  800be6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800beb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bee:	8d 40 04             	lea    0x4(%eax),%eax
  800bf1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bf4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800c00:	57                   	push   %edi
  800c01:	ff 75 e0             	pushl  -0x20(%ebp)
  800c04:	50                   	push   %eax
  800c05:	51                   	push   %ecx
  800c06:	52                   	push   %edx
  800c07:	89 da                	mov    %ebx,%edx
  800c09:	89 f0                	mov    %esi,%eax
  800c0b:	e8 06 fb ff ff       	call   800716 <printnum>
			break;
  800c10:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800c13:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	83 c7 01             	add    $0x1,%edi
  800c19:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c1d:	83 f8 25             	cmp    $0x25,%eax
  800c20:	0f 84 f0 fb ff ff    	je     800816 <vprintfmt+0x17>
			if (ch == '\0')
  800c26:	85 c0                	test   %eax,%eax
  800c28:	0f 84 8b 00 00 00    	je     800cb9 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	53                   	push   %ebx
  800c32:	50                   	push   %eax
  800c33:	ff d6                	call   *%esi
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	eb dc                	jmp    800c16 <vprintfmt+0x417>
	if (lflag >= 2)
  800c3a:	83 f9 01             	cmp    $0x1,%ecx
  800c3d:	7e 15                	jle    800c54 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	8b 10                	mov    (%eax),%edx
  800c44:	8b 48 04             	mov    0x4(%eax),%ecx
  800c47:	8d 40 08             	lea    0x8(%eax),%eax
  800c4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c4d:	b8 10 00 00 00       	mov    $0x10,%eax
  800c52:	eb a5                	jmp    800bf9 <vprintfmt+0x3fa>
	else if (lflag)
  800c54:	85 c9                	test   %ecx,%ecx
  800c56:	75 17                	jne    800c6f <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	8b 10                	mov    (%eax),%edx
  800c5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c62:	8d 40 04             	lea    0x4(%eax),%eax
  800c65:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c68:	b8 10 00 00 00       	mov    $0x10,%eax
  800c6d:	eb 8a                	jmp    800bf9 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	8b 10                	mov    (%eax),%edx
  800c74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c79:	8d 40 04             	lea    0x4(%eax),%eax
  800c7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c7f:	b8 10 00 00 00       	mov    $0x10,%eax
  800c84:	e9 70 ff ff ff       	jmp    800bf9 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	53                   	push   %ebx
  800c8d:	6a 25                	push   $0x25
  800c8f:	ff d6                	call   *%esi
			break;
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	e9 7a ff ff ff       	jmp    800c13 <vprintfmt+0x414>
			putch('%', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	53                   	push   %ebx
  800c9d:	6a 25                	push   $0x25
  800c9f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	89 f8                	mov    %edi,%eax
  800ca6:	eb 03                	jmp    800cab <vprintfmt+0x4ac>
  800ca8:	83 e8 01             	sub    $0x1,%eax
  800cab:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800caf:	75 f7                	jne    800ca8 <vprintfmt+0x4a9>
  800cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb4:	e9 5a ff ff ff       	jmp    800c13 <vprintfmt+0x414>
}
  800cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 18             	sub    $0x18,%esp
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cd4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	74 26                	je     800d08 <vsnprintf+0x47>
  800ce2:	85 d2                	test   %edx,%edx
  800ce4:	7e 22                	jle    800d08 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce6:	ff 75 14             	pushl  0x14(%ebp)
  800ce9:	ff 75 10             	pushl  0x10(%ebp)
  800cec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cef:	50                   	push   %eax
  800cf0:	68 c5 07 80 00       	push   $0x8007c5
  800cf5:	e8 05 fb ff ff       	call   8007ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d03:	83 c4 10             	add    $0x10,%esp
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    
		return -E_INVAL;
  800d08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d0d:	eb f7                	jmp    800d06 <vsnprintf+0x45>

00800d0f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d15:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d18:	50                   	push   %eax
  800d19:	ff 75 10             	pushl  0x10(%ebp)
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 9a ff ff ff       	call   800cc1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d34:	eb 03                	jmp    800d39 <strlen+0x10>
		n++;
  800d36:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800d39:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d3d:	75 f7                	jne    800d36 <strlen+0xd>
	return n;
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d47:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4f:	eb 03                	jmp    800d54 <strnlen+0x13>
		n++;
  800d51:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d54:	39 d0                	cmp    %edx,%eax
  800d56:	74 06                	je     800d5e <strnlen+0x1d>
  800d58:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d5c:	75 f3                	jne    800d51 <strnlen+0x10>
	return n;
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	53                   	push   %ebx
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	83 c1 01             	add    $0x1,%ecx
  800d6f:	83 c2 01             	add    $0x1,%edx
  800d72:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d76:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d79:	84 db                	test   %bl,%bl
  800d7b:	75 ef                	jne    800d6c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d7d:	5b                   	pop    %ebx
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	53                   	push   %ebx
  800d84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d87:	53                   	push   %ebx
  800d88:	e8 9c ff ff ff       	call   800d29 <strlen>
  800d8d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	01 d8                	add    %ebx,%eax
  800d95:	50                   	push   %eax
  800d96:	e8 c5 ff ff ff       	call   800d60 <strcpy>
	return dst;
}
  800d9b:	89 d8                	mov    %ebx,%eax
  800d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	8b 75 08             	mov    0x8(%ebp),%esi
  800daa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dad:	89 f3                	mov    %esi,%ebx
  800daf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db2:	89 f2                	mov    %esi,%edx
  800db4:	eb 0f                	jmp    800dc5 <strncpy+0x23>
		*dst++ = *src;
  800db6:	83 c2 01             	add    $0x1,%edx
  800db9:	0f b6 01             	movzbl (%ecx),%eax
  800dbc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dbf:	80 39 01             	cmpb   $0x1,(%ecx)
  800dc2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800dc5:	39 da                	cmp    %ebx,%edx
  800dc7:	75 ed                	jne    800db6 <strncpy+0x14>
	}
	return ret;
}
  800dc9:	89 f0                	mov    %esi,%eax
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	8b 75 08             	mov    0x8(%ebp),%esi
  800dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ddd:	89 f0                	mov    %esi,%eax
  800ddf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800de3:	85 c9                	test   %ecx,%ecx
  800de5:	75 0b                	jne    800df2 <strlcpy+0x23>
  800de7:	eb 17                	jmp    800e00 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800de9:	83 c2 01             	add    $0x1,%edx
  800dec:	83 c0 01             	add    $0x1,%eax
  800def:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800df2:	39 d8                	cmp    %ebx,%eax
  800df4:	74 07                	je     800dfd <strlcpy+0x2e>
  800df6:	0f b6 0a             	movzbl (%edx),%ecx
  800df9:	84 c9                	test   %cl,%cl
  800dfb:	75 ec                	jne    800de9 <strlcpy+0x1a>
		*dst = '\0';
  800dfd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e00:	29 f0                	sub    %esi,%eax
}
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e0f:	eb 06                	jmp    800e17 <strcmp+0x11>
		p++, q++;
  800e11:	83 c1 01             	add    $0x1,%ecx
  800e14:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e17:	0f b6 01             	movzbl (%ecx),%eax
  800e1a:	84 c0                	test   %al,%al
  800e1c:	74 04                	je     800e22 <strcmp+0x1c>
  800e1e:	3a 02                	cmp    (%edx),%al
  800e20:	74 ef                	je     800e11 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	0f b6 12             	movzbl (%edx),%edx
  800e28:	29 d0                	sub    %edx,%eax
}
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	53                   	push   %ebx
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e36:	89 c3                	mov    %eax,%ebx
  800e38:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e3b:	eb 06                	jmp    800e43 <strncmp+0x17>
		n--, p++, q++;
  800e3d:	83 c0 01             	add    $0x1,%eax
  800e40:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e43:	39 d8                	cmp    %ebx,%eax
  800e45:	74 16                	je     800e5d <strncmp+0x31>
  800e47:	0f b6 08             	movzbl (%eax),%ecx
  800e4a:	84 c9                	test   %cl,%cl
  800e4c:	74 04                	je     800e52 <strncmp+0x26>
  800e4e:	3a 0a                	cmp    (%edx),%cl
  800e50:	74 eb                	je     800e3d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e52:	0f b6 00             	movzbl (%eax),%eax
  800e55:	0f b6 12             	movzbl (%edx),%edx
  800e58:	29 d0                	sub    %edx,%eax
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    
		return 0;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	eb f6                	jmp    800e5a <strncmp+0x2e>

00800e64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e6e:	0f b6 10             	movzbl (%eax),%edx
  800e71:	84 d2                	test   %dl,%dl
  800e73:	74 09                	je     800e7e <strchr+0x1a>
		if (*s == c)
  800e75:	38 ca                	cmp    %cl,%dl
  800e77:	74 0a                	je     800e83 <strchr+0x1f>
	for (; *s; s++)
  800e79:	83 c0 01             	add    $0x1,%eax
  800e7c:	eb f0                	jmp    800e6e <strchr+0xa>
			return (char *) s;
	return 0;
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e8f:	eb 03                	jmp    800e94 <strfind+0xf>
  800e91:	83 c0 01             	add    $0x1,%eax
  800e94:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e97:	38 ca                	cmp    %cl,%dl
  800e99:	74 04                	je     800e9f <strfind+0x1a>
  800e9b:	84 d2                	test   %dl,%dl
  800e9d:	75 f2                	jne    800e91 <strfind+0xc>
			break;
	return (char *) s;
}
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ead:	85 c9                	test   %ecx,%ecx
  800eaf:	74 13                	je     800ec4 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800eb1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800eb7:	75 05                	jne    800ebe <memset+0x1d>
  800eb9:	f6 c1 03             	test   $0x3,%cl
  800ebc:	74 0d                	je     800ecb <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	fc                   	cld    
  800ec2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ec4:	89 f8                	mov    %edi,%eax
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		c &= 0xFF;
  800ecb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ecf:	89 d3                	mov    %edx,%ebx
  800ed1:	c1 e3 08             	shl    $0x8,%ebx
  800ed4:	89 d0                	mov    %edx,%eax
  800ed6:	c1 e0 18             	shl    $0x18,%eax
  800ed9:	89 d6                	mov    %edx,%esi
  800edb:	c1 e6 10             	shl    $0x10,%esi
  800ede:	09 f0                	or     %esi,%eax
  800ee0:	09 c2                	or     %eax,%edx
  800ee2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ee4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ee7:	89 d0                	mov    %edx,%eax
  800ee9:	fc                   	cld    
  800eea:	f3 ab                	rep stos %eax,%es:(%edi)
  800eec:	eb d6                	jmp    800ec4 <memset+0x23>

00800eee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ef9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800efc:	39 c6                	cmp    %eax,%esi
  800efe:	73 35                	jae    800f35 <memmove+0x47>
  800f00:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f03:	39 c2                	cmp    %eax,%edx
  800f05:	76 2e                	jbe    800f35 <memmove+0x47>
		s += n;
		d += n;
  800f07:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f0a:	89 d6                	mov    %edx,%esi
  800f0c:	09 fe                	or     %edi,%esi
  800f0e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f14:	74 0c                	je     800f22 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f16:	83 ef 01             	sub    $0x1,%edi
  800f19:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f1c:	fd                   	std    
  800f1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f1f:	fc                   	cld    
  800f20:	eb 21                	jmp    800f43 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f22:	f6 c1 03             	test   $0x3,%cl
  800f25:	75 ef                	jne    800f16 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f27:	83 ef 04             	sub    $0x4,%edi
  800f2a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f30:	fd                   	std    
  800f31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f33:	eb ea                	jmp    800f1f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f35:	89 f2                	mov    %esi,%edx
  800f37:	09 c2                	or     %eax,%edx
  800f39:	f6 c2 03             	test   $0x3,%dl
  800f3c:	74 09                	je     800f47 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f3e:	89 c7                	mov    %eax,%edi
  800f40:	fc                   	cld    
  800f41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f47:	f6 c1 03             	test   $0x3,%cl
  800f4a:	75 f2                	jne    800f3e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f4c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f4f:	89 c7                	mov    %eax,%edi
  800f51:	fc                   	cld    
  800f52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f54:	eb ed                	jmp    800f43 <memmove+0x55>

00800f56 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800f59:	ff 75 10             	pushl  0x10(%ebp)
  800f5c:	ff 75 0c             	pushl  0xc(%ebp)
  800f5f:	ff 75 08             	pushl  0x8(%ebp)
  800f62:	e8 87 ff ff ff       	call   800eee <memmove>
}
  800f67:	c9                   	leave  
  800f68:	c3                   	ret    

00800f69 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f74:	89 c6                	mov    %eax,%esi
  800f76:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f79:	39 f0                	cmp    %esi,%eax
  800f7b:	74 1c                	je     800f99 <memcmp+0x30>
		if (*s1 != *s2)
  800f7d:	0f b6 08             	movzbl (%eax),%ecx
  800f80:	0f b6 1a             	movzbl (%edx),%ebx
  800f83:	38 d9                	cmp    %bl,%cl
  800f85:	75 08                	jne    800f8f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f87:	83 c0 01             	add    $0x1,%eax
  800f8a:	83 c2 01             	add    $0x1,%edx
  800f8d:	eb ea                	jmp    800f79 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f8f:	0f b6 c1             	movzbl %cl,%eax
  800f92:	0f b6 db             	movzbl %bl,%ebx
  800f95:	29 d8                	sub    %ebx,%eax
  800f97:	eb 05                	jmp    800f9e <memcmp+0x35>
	}

	return 0;
  800f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fab:	89 c2                	mov    %eax,%edx
  800fad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fb0:	39 d0                	cmp    %edx,%eax
  800fb2:	73 09                	jae    800fbd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fb4:	38 08                	cmp    %cl,(%eax)
  800fb6:	74 05                	je     800fbd <memfind+0x1b>
	for (; s < ends; s++)
  800fb8:	83 c0 01             	add    $0x1,%eax
  800fbb:	eb f3                	jmp    800fb0 <memfind+0xe>
			break;
	return (void *) s;
}
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcb:	eb 03                	jmp    800fd0 <strtol+0x11>
		s++;
  800fcd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fd0:	0f b6 01             	movzbl (%ecx),%eax
  800fd3:	3c 20                	cmp    $0x20,%al
  800fd5:	74 f6                	je     800fcd <strtol+0xe>
  800fd7:	3c 09                	cmp    $0x9,%al
  800fd9:	74 f2                	je     800fcd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	74 2e                	je     80100d <strtol+0x4e>
	int neg = 0;
  800fdf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fe4:	3c 2d                	cmp    $0x2d,%al
  800fe6:	74 2f                	je     801017 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fe8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800fee:	75 05                	jne    800ff5 <strtol+0x36>
  800ff0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ff3:	74 2c                	je     801021 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ff5:	85 db                	test   %ebx,%ebx
  800ff7:	75 0a                	jne    801003 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ff9:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ffe:	80 39 30             	cmpb   $0x30,(%ecx)
  801001:	74 28                	je     80102b <strtol+0x6c>
		base = 10;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
  801008:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80100b:	eb 50                	jmp    80105d <strtol+0x9e>
		s++;
  80100d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801010:	bf 00 00 00 00       	mov    $0x0,%edi
  801015:	eb d1                	jmp    800fe8 <strtol+0x29>
		s++, neg = 1;
  801017:	83 c1 01             	add    $0x1,%ecx
  80101a:	bf 01 00 00 00       	mov    $0x1,%edi
  80101f:	eb c7                	jmp    800fe8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801021:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801025:	74 0e                	je     801035 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801027:	85 db                	test   %ebx,%ebx
  801029:	75 d8                	jne    801003 <strtol+0x44>
		s++, base = 8;
  80102b:	83 c1 01             	add    $0x1,%ecx
  80102e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801033:	eb ce                	jmp    801003 <strtol+0x44>
		s += 2, base = 16;
  801035:	83 c1 02             	add    $0x2,%ecx
  801038:	bb 10 00 00 00       	mov    $0x10,%ebx
  80103d:	eb c4                	jmp    801003 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80103f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801042:	89 f3                	mov    %esi,%ebx
  801044:	80 fb 19             	cmp    $0x19,%bl
  801047:	77 29                	ja     801072 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801049:	0f be d2             	movsbl %dl,%edx
  80104c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80104f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801052:	7d 30                	jge    801084 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801054:	83 c1 01             	add    $0x1,%ecx
  801057:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80105d:	0f b6 11             	movzbl (%ecx),%edx
  801060:	8d 72 d0             	lea    -0x30(%edx),%esi
  801063:	89 f3                	mov    %esi,%ebx
  801065:	80 fb 09             	cmp    $0x9,%bl
  801068:	77 d5                	ja     80103f <strtol+0x80>
			dig = *s - '0';
  80106a:	0f be d2             	movsbl %dl,%edx
  80106d:	83 ea 30             	sub    $0x30,%edx
  801070:	eb dd                	jmp    80104f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801072:	8d 72 bf             	lea    -0x41(%edx),%esi
  801075:	89 f3                	mov    %esi,%ebx
  801077:	80 fb 19             	cmp    $0x19,%bl
  80107a:	77 08                	ja     801084 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80107c:	0f be d2             	movsbl %dl,%edx
  80107f:	83 ea 37             	sub    $0x37,%edx
  801082:	eb cb                	jmp    80104f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801084:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801088:	74 05                	je     80108f <strtol+0xd0>
		*endptr = (char *) s;
  80108a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80108f:	89 c2                	mov    %eax,%edx
  801091:	f7 da                	neg    %edx
  801093:	85 ff                	test   %edi,%edi
  801095:	0f 45 c2             	cmovne %edx,%eax
}
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ae:	89 c3                	mov    %eax,%ebx
  8010b0:	89 c7                	mov    %eax,%edi
  8010b2:	89 c6                	mov    %eax,%esi
  8010b4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8010b6:	5b                   	pop    %ebx
  8010b7:	5e                   	pop    %esi
  8010b8:	5f                   	pop    %edi
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <sys_cgetc>:

int
sys_cgetc(void) {
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	57                   	push   %edi
  8010bf:	56                   	push   %esi
  8010c0:	53                   	push   %ebx
    asm volatile("int %1\n"
  8010c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010cb:	89 d1                	mov    %edx,%ecx
  8010cd:	89 d3                	mov    %edx,%ebx
  8010cf:	89 d7                	mov    %edx,%edi
  8010d1:	89 d6                	mov    %edx,%esi
  8010d3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8010e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8010f0:	89 cb                	mov    %ecx,%ebx
  8010f2:	89 cf                	mov    %ecx,%edi
  8010f4:	89 ce                	mov    %ecx,%esi
  8010f6:	cd 30                	int    $0x30
    if (check && ret > 0)
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	7f 08                	jg     801104 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ff:	5b                   	pop    %ebx
  801100:	5e                   	pop    %esi
  801101:	5f                   	pop    %edi
  801102:	5d                   	pop    %ebp
  801103:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	50                   	push   %eax
  801108:	6a 03                	push   $0x3
  80110a:	68 04 19 80 00       	push   $0x801904
  80110f:	6a 24                	push   $0x24
  801111:	68 21 19 80 00       	push   $0x801921
  801116:	e8 0c f5 ff ff       	call   800627 <_panic>

0080111b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
    asm volatile("int %1\n"
  801121:	ba 00 00 00 00       	mov    $0x0,%edx
  801126:	b8 02 00 00 00       	mov    $0x2,%eax
  80112b:	89 d1                	mov    %edx,%ecx
  80112d:	89 d3                	mov    %edx,%ebx
  80112f:	89 d7                	mov    %edx,%edi
  801131:	89 d6                	mov    %edx,%esi
  801133:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <sys_yield>:

void
sys_yield(void)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
    asm volatile("int %1\n"
  801140:	ba 00 00 00 00       	mov    $0x0,%edx
  801145:	b8 0a 00 00 00       	mov    $0xa,%eax
  80114a:	89 d1                	mov    %edx,%ecx
  80114c:	89 d3                	mov    %edx,%ebx
  80114e:	89 d7                	mov    %edx,%edi
  801150:	89 d6                	mov    %edx,%esi
  801152:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5f                   	pop    %edi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  801162:	be 00 00 00 00       	mov    $0x0,%esi
  801167:	8b 55 08             	mov    0x8(%ebp),%edx
  80116a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116d:	b8 04 00 00 00       	mov    $0x4,%eax
  801172:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801175:	89 f7                	mov    %esi,%edi
  801177:	cd 30                	int    $0x30
    if (check && ret > 0)
  801179:	85 c0                	test   %eax,%eax
  80117b:	7f 08                	jg     801185 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80117d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5f                   	pop    %edi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	50                   	push   %eax
  801189:	6a 04                	push   $0x4
  80118b:	68 04 19 80 00       	push   $0x801904
  801190:	6a 24                	push   $0x24
  801192:	68 21 19 80 00       	push   $0x801921
  801197:	e8 8b f4 ff ff       	call   800627 <_panic>

0080119c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ab:	b8 05 00 00 00       	mov    $0x5,%eax
  8011b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8011b9:	cd 30                	int    $0x30
    if (check && ret > 0)
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	7f 08                	jg     8011c7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5f                   	pop    %edi
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	50                   	push   %eax
  8011cb:	6a 05                	push   $0x5
  8011cd:	68 04 19 80 00       	push   $0x801904
  8011d2:	6a 24                	push   $0x24
  8011d4:	68 21 19 80 00       	push   $0x801921
  8011d9:	e8 49 f4 ff ff       	call   800627 <_panic>

008011de <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	57                   	push   %edi
  8011e2:	56                   	push   %esi
  8011e3:	53                   	push   %ebx
  8011e4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8011e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8011f7:	89 df                	mov    %ebx,%edi
  8011f9:	89 de                	mov    %ebx,%esi
  8011fb:	cd 30                	int    $0x30
    if (check && ret > 0)
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	7f 08                	jg     801209 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801204:	5b                   	pop    %ebx
  801205:	5e                   	pop    %esi
  801206:	5f                   	pop    %edi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  801209:	83 ec 0c             	sub    $0xc,%esp
  80120c:	50                   	push   %eax
  80120d:	6a 06                	push   $0x6
  80120f:	68 04 19 80 00       	push   $0x801904
  801214:	6a 24                	push   $0x24
  801216:	68 21 19 80 00       	push   $0x801921
  80121b:	e8 07 f4 ff ff       	call   800627 <_panic>

00801220 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  801229:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122e:	8b 55 08             	mov    0x8(%ebp),%edx
  801231:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801234:	b8 08 00 00 00       	mov    $0x8,%eax
  801239:	89 df                	mov    %ebx,%edi
  80123b:	89 de                	mov    %ebx,%esi
  80123d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80123f:	85 c0                	test   %eax,%eax
  801241:	7f 08                	jg     80124b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801243:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801246:	5b                   	pop    %ebx
  801247:	5e                   	pop    %esi
  801248:	5f                   	pop    %edi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80124b:	83 ec 0c             	sub    $0xc,%esp
  80124e:	50                   	push   %eax
  80124f:	6a 08                	push   $0x8
  801251:	68 04 19 80 00       	push   $0x801904
  801256:	6a 24                	push   $0x24
  801258:	68 21 19 80 00       	push   $0x801921
  80125d:	e8 c5 f3 ff ff       	call   800627 <_panic>

00801262 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80126b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801270:	8b 55 08             	mov    0x8(%ebp),%edx
  801273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801276:	b8 09 00 00 00       	mov    $0x9,%eax
  80127b:	89 df                	mov    %ebx,%edi
  80127d:	89 de                	mov    %ebx,%esi
  80127f:	cd 30                	int    $0x30
    if (check && ret > 0)
  801281:	85 c0                	test   %eax,%eax
  801283:	7f 08                	jg     80128d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	6a 09                	push   $0x9
  801293:	68 04 19 80 00       	push   $0x801904
  801298:	6a 24                	push   $0x24
  80129a:	68 21 19 80 00       	push   $0x801921
  80129f:	e8 83 f3 ff ff       	call   800627 <_panic>

008012a4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	57                   	push   %edi
  8012a8:	56                   	push   %esi
  8012a9:	53                   	push   %ebx
    asm volatile("int %1\n"
  8012aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012b5:	be 00 00 00 00       	mov    $0x0,%esi
  8012ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012bd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012c0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	57                   	push   %edi
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
  8012cd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8012d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012dd:	89 cb                	mov    %ecx,%ebx
  8012df:	89 cf                	mov    %ecx,%edi
  8012e1:	89 ce                	mov    %ecx,%esi
  8012e3:	cd 30                	int    $0x30
    if (check && ret > 0)
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	7f 08                	jg     8012f1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8012f1:	83 ec 0c             	sub    $0xc,%esp
  8012f4:	50                   	push   %eax
  8012f5:	6a 0c                	push   $0xc
  8012f7:	68 04 19 80 00       	push   $0x801904
  8012fc:	6a 24                	push   $0x24
  8012fe:	68 21 19 80 00       	push   $0x801921
  801303:	e8 1f f3 ff ff       	call   800627 <_panic>

00801308 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80130e:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  801315:	74 0a                	je     801321 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	a3 d0 20 80 00       	mov    %eax,0x8020d0
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    
		panic("set_pgfault_handler not implemented");
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	68 30 19 80 00       	push   $0x801930
  801329:	6a 20                	push   $0x20
  80132b:	68 54 19 80 00       	push   $0x801954
  801330:	e8 f2 f2 ff ff       	call   800627 <_panic>
  801335:	66 90                	xchg   %ax,%ax
  801337:	66 90                	xchg   %ax,%ax
  801339:	66 90                	xchg   %ax,%ax
  80133b:	66 90                	xchg   %ax,%ax
  80133d:	66 90                	xchg   %ax,%ax
  80133f:	90                   	nop

00801340 <__udivdi3>:
  801340:	55                   	push   %ebp
  801341:	57                   	push   %edi
  801342:	56                   	push   %esi
  801343:	53                   	push   %ebx
  801344:	83 ec 1c             	sub    $0x1c,%esp
  801347:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80134b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80134f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801353:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801357:	85 d2                	test   %edx,%edx
  801359:	75 35                	jne    801390 <__udivdi3+0x50>
  80135b:	39 f3                	cmp    %esi,%ebx
  80135d:	0f 87 bd 00 00 00    	ja     801420 <__udivdi3+0xe0>
  801363:	85 db                	test   %ebx,%ebx
  801365:	89 d9                	mov    %ebx,%ecx
  801367:	75 0b                	jne    801374 <__udivdi3+0x34>
  801369:	b8 01 00 00 00       	mov    $0x1,%eax
  80136e:	31 d2                	xor    %edx,%edx
  801370:	f7 f3                	div    %ebx
  801372:	89 c1                	mov    %eax,%ecx
  801374:	31 d2                	xor    %edx,%edx
  801376:	89 f0                	mov    %esi,%eax
  801378:	f7 f1                	div    %ecx
  80137a:	89 c6                	mov    %eax,%esi
  80137c:	89 e8                	mov    %ebp,%eax
  80137e:	89 f7                	mov    %esi,%edi
  801380:	f7 f1                	div    %ecx
  801382:	89 fa                	mov    %edi,%edx
  801384:	83 c4 1c             	add    $0x1c,%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5f                   	pop    %edi
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    
  80138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801390:	39 f2                	cmp    %esi,%edx
  801392:	77 7c                	ja     801410 <__udivdi3+0xd0>
  801394:	0f bd fa             	bsr    %edx,%edi
  801397:	83 f7 1f             	xor    $0x1f,%edi
  80139a:	0f 84 98 00 00 00    	je     801438 <__udivdi3+0xf8>
  8013a0:	89 f9                	mov    %edi,%ecx
  8013a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8013a7:	29 f8                	sub    %edi,%eax
  8013a9:	d3 e2                	shl    %cl,%edx
  8013ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013af:	89 c1                	mov    %eax,%ecx
  8013b1:	89 da                	mov    %ebx,%edx
  8013b3:	d3 ea                	shr    %cl,%edx
  8013b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8013b9:	09 d1                	or     %edx,%ecx
  8013bb:	89 f2                	mov    %esi,%edx
  8013bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013c1:	89 f9                	mov    %edi,%ecx
  8013c3:	d3 e3                	shl    %cl,%ebx
  8013c5:	89 c1                	mov    %eax,%ecx
  8013c7:	d3 ea                	shr    %cl,%edx
  8013c9:	89 f9                	mov    %edi,%ecx
  8013cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013cf:	d3 e6                	shl    %cl,%esi
  8013d1:	89 eb                	mov    %ebp,%ebx
  8013d3:	89 c1                	mov    %eax,%ecx
  8013d5:	d3 eb                	shr    %cl,%ebx
  8013d7:	09 de                	or     %ebx,%esi
  8013d9:	89 f0                	mov    %esi,%eax
  8013db:	f7 74 24 08          	divl   0x8(%esp)
  8013df:	89 d6                	mov    %edx,%esi
  8013e1:	89 c3                	mov    %eax,%ebx
  8013e3:	f7 64 24 0c          	mull   0xc(%esp)
  8013e7:	39 d6                	cmp    %edx,%esi
  8013e9:	72 0c                	jb     8013f7 <__udivdi3+0xb7>
  8013eb:	89 f9                	mov    %edi,%ecx
  8013ed:	d3 e5                	shl    %cl,%ebp
  8013ef:	39 c5                	cmp    %eax,%ebp
  8013f1:	73 5d                	jae    801450 <__udivdi3+0x110>
  8013f3:	39 d6                	cmp    %edx,%esi
  8013f5:	75 59                	jne    801450 <__udivdi3+0x110>
  8013f7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8013fa:	31 ff                	xor    %edi,%edi
  8013fc:	89 fa                	mov    %edi,%edx
  8013fe:	83 c4 1c             	add    $0x1c,%esp
  801401:	5b                   	pop    %ebx
  801402:	5e                   	pop    %esi
  801403:	5f                   	pop    %edi
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    
  801406:	8d 76 00             	lea    0x0(%esi),%esi
  801409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801410:	31 ff                	xor    %edi,%edi
  801412:	31 c0                	xor    %eax,%eax
  801414:	89 fa                	mov    %edi,%edx
  801416:	83 c4 1c             	add    $0x1c,%esp
  801419:	5b                   	pop    %ebx
  80141a:	5e                   	pop    %esi
  80141b:	5f                   	pop    %edi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    
  80141e:	66 90                	xchg   %ax,%ax
  801420:	31 ff                	xor    %edi,%edi
  801422:	89 e8                	mov    %ebp,%eax
  801424:	89 f2                	mov    %esi,%edx
  801426:	f7 f3                	div    %ebx
  801428:	89 fa                	mov    %edi,%edx
  80142a:	83 c4 1c             	add    $0x1c,%esp
  80142d:	5b                   	pop    %ebx
  80142e:	5e                   	pop    %esi
  80142f:	5f                   	pop    %edi
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    
  801432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801438:	39 f2                	cmp    %esi,%edx
  80143a:	72 06                	jb     801442 <__udivdi3+0x102>
  80143c:	31 c0                	xor    %eax,%eax
  80143e:	39 eb                	cmp    %ebp,%ebx
  801440:	77 d2                	ja     801414 <__udivdi3+0xd4>
  801442:	b8 01 00 00 00       	mov    $0x1,%eax
  801447:	eb cb                	jmp    801414 <__udivdi3+0xd4>
  801449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801450:	89 d8                	mov    %ebx,%eax
  801452:	31 ff                	xor    %edi,%edi
  801454:	eb be                	jmp    801414 <__udivdi3+0xd4>
  801456:	66 90                	xchg   %ax,%ax
  801458:	66 90                	xchg   %ax,%ax
  80145a:	66 90                	xchg   %ax,%ax
  80145c:	66 90                	xchg   %ax,%ax
  80145e:	66 90                	xchg   %ax,%ax

00801460 <__umoddi3>:
  801460:	55                   	push   %ebp
  801461:	57                   	push   %edi
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	83 ec 1c             	sub    $0x1c,%esp
  801467:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80146b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80146f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801477:	85 ed                	test   %ebp,%ebp
  801479:	89 f0                	mov    %esi,%eax
  80147b:	89 da                	mov    %ebx,%edx
  80147d:	75 19                	jne    801498 <__umoddi3+0x38>
  80147f:	39 df                	cmp    %ebx,%edi
  801481:	0f 86 b1 00 00 00    	jbe    801538 <__umoddi3+0xd8>
  801487:	f7 f7                	div    %edi
  801489:	89 d0                	mov    %edx,%eax
  80148b:	31 d2                	xor    %edx,%edx
  80148d:	83 c4 1c             	add    $0x1c,%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5f                   	pop    %edi
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    
  801495:	8d 76 00             	lea    0x0(%esi),%esi
  801498:	39 dd                	cmp    %ebx,%ebp
  80149a:	77 f1                	ja     80148d <__umoddi3+0x2d>
  80149c:	0f bd cd             	bsr    %ebp,%ecx
  80149f:	83 f1 1f             	xor    $0x1f,%ecx
  8014a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014a6:	0f 84 b4 00 00 00    	je     801560 <__umoddi3+0x100>
  8014ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8014b1:	89 c2                	mov    %eax,%edx
  8014b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8014b7:	29 c2                	sub    %eax,%edx
  8014b9:	89 c1                	mov    %eax,%ecx
  8014bb:	89 f8                	mov    %edi,%eax
  8014bd:	d3 e5                	shl    %cl,%ebp
  8014bf:	89 d1                	mov    %edx,%ecx
  8014c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014c5:	d3 e8                	shr    %cl,%eax
  8014c7:	09 c5                	or     %eax,%ebp
  8014c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8014cd:	89 c1                	mov    %eax,%ecx
  8014cf:	d3 e7                	shl    %cl,%edi
  8014d1:	89 d1                	mov    %edx,%ecx
  8014d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014d7:	89 df                	mov    %ebx,%edi
  8014d9:	d3 ef                	shr    %cl,%edi
  8014db:	89 c1                	mov    %eax,%ecx
  8014dd:	89 f0                	mov    %esi,%eax
  8014df:	d3 e3                	shl    %cl,%ebx
  8014e1:	89 d1                	mov    %edx,%ecx
  8014e3:	89 fa                	mov    %edi,%edx
  8014e5:	d3 e8                	shr    %cl,%eax
  8014e7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8014ec:	09 d8                	or     %ebx,%eax
  8014ee:	f7 f5                	div    %ebp
  8014f0:	d3 e6                	shl    %cl,%esi
  8014f2:	89 d1                	mov    %edx,%ecx
  8014f4:	f7 64 24 08          	mull   0x8(%esp)
  8014f8:	39 d1                	cmp    %edx,%ecx
  8014fa:	89 c3                	mov    %eax,%ebx
  8014fc:	89 d7                	mov    %edx,%edi
  8014fe:	72 06                	jb     801506 <__umoddi3+0xa6>
  801500:	75 0e                	jne    801510 <__umoddi3+0xb0>
  801502:	39 c6                	cmp    %eax,%esi
  801504:	73 0a                	jae    801510 <__umoddi3+0xb0>
  801506:	2b 44 24 08          	sub    0x8(%esp),%eax
  80150a:	19 ea                	sbb    %ebp,%edx
  80150c:	89 d7                	mov    %edx,%edi
  80150e:	89 c3                	mov    %eax,%ebx
  801510:	89 ca                	mov    %ecx,%edx
  801512:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801517:	29 de                	sub    %ebx,%esi
  801519:	19 fa                	sbb    %edi,%edx
  80151b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80151f:	89 d0                	mov    %edx,%eax
  801521:	d3 e0                	shl    %cl,%eax
  801523:	89 d9                	mov    %ebx,%ecx
  801525:	d3 ee                	shr    %cl,%esi
  801527:	d3 ea                	shr    %cl,%edx
  801529:	09 f0                	or     %esi,%eax
  80152b:	83 c4 1c             	add    $0x1c,%esp
  80152e:	5b                   	pop    %ebx
  80152f:	5e                   	pop    %esi
  801530:	5f                   	pop    %edi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    
  801533:	90                   	nop
  801534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801538:	85 ff                	test   %edi,%edi
  80153a:	89 f9                	mov    %edi,%ecx
  80153c:	75 0b                	jne    801549 <__umoddi3+0xe9>
  80153e:	b8 01 00 00 00       	mov    $0x1,%eax
  801543:	31 d2                	xor    %edx,%edx
  801545:	f7 f7                	div    %edi
  801547:	89 c1                	mov    %eax,%ecx
  801549:	89 d8                	mov    %ebx,%eax
  80154b:	31 d2                	xor    %edx,%edx
  80154d:	f7 f1                	div    %ecx
  80154f:	89 f0                	mov    %esi,%eax
  801551:	f7 f1                	div    %ecx
  801553:	e9 31 ff ff ff       	jmp    801489 <__umoddi3+0x29>
  801558:	90                   	nop
  801559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801560:	39 dd                	cmp    %ebx,%ebp
  801562:	72 08                	jb     80156c <__umoddi3+0x10c>
  801564:	39 f7                	cmp    %esi,%edi
  801566:	0f 87 21 ff ff ff    	ja     80148d <__umoddi3+0x2d>
  80156c:	89 da                	mov    %ebx,%edx
  80156e:	89 f0                	mov    %esi,%eax
  801570:	29 f8                	sub    %edi,%eax
  801572:	19 ea                	sbb    %ebp,%edx
  801574:	e9 14 ff ff ff       	jmp    80148d <__umoddi3+0x2d>
