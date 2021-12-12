
obj/user/faultbadhandler：     文件格式 elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 22 01 00 00       	call   800169 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 1c 02 00 00       	call   800272 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	8b 45 08             	mov    0x8(%ebp),%eax
  80006e:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800071:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  800078:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007b:	85 c0                	test   %eax,%eax
  80007d:	7e 08                	jle    800087 <libmain+0x22>
		binaryname = argv[0];
  80007f:	8b 0a                	mov    (%edx),%ecx
  800081:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	52                   	push   %edx
  80008b:	50                   	push   %eax
  80008c:	e8 a2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800091:	e8 05 00 00 00       	call   80009b <exit>
}
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	c9                   	leave  
  80009a:	c3                   	ret    

0080009b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009b:	55                   	push   %ebp
  80009c:	89 e5                	mov    %esp,%ebp
  80009e:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 42 00 00 00       	call   8000ea <sys_env_destroy>
}
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	c9                   	leave  
  8000ac:	c3                   	ret    

008000ad <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000ad:	55                   	push   %ebp
  8000ae:	89 e5                	mov    %esp,%ebp
  8000b0:	57                   	push   %edi
  8000b1:	56                   	push   %esi
  8000b2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000be:	89 c3                	mov    %eax,%ebx
  8000c0:	89 c7                	mov    %eax,%edi
  8000c2:	89 c6                	mov    %eax,%esi
  8000c4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000c6:	5b                   	pop    %ebx
  8000c7:	5e                   	pop    %esi
  8000c8:	5f                   	pop    %edi
  8000c9:	5d                   	pop    %ebp
  8000ca:	c3                   	ret    

008000cb <sys_cgetc>:

int
sys_cgetc(void) {
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	57                   	push   %edi
  8000cf:	56                   	push   %esi
  8000d0:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	89 d3                	mov    %edx,%ebx
  8000df:	89 d7                	mov    %edx,%edi
  8000e1:	89 d6                	mov    %edx,%esi
  8000e3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e5:	5b                   	pop    %ebx
  8000e6:	5e                   	pop    %esi
  8000e7:	5f                   	pop    %edi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    

008000ea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fb:	b8 03 00 00 00       	mov    $0x3,%eax
  800100:	89 cb                	mov    %ecx,%ebx
  800102:	89 cf                	mov    %ecx,%edi
  800104:	89 ce                	mov    %ecx,%esi
  800106:	cd 30                	int    $0x30
    if (check && ret > 0)
  800108:	85 c0                	test   %eax,%eax
  80010a:	7f 08                	jg     800114 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5f                   	pop    %edi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	50                   	push   %eax
  800118:	6a 03                	push   $0x3
  80011a:	68 ea 0f 80 00       	push   $0x800fea
  80011f:	6a 24                	push   $0x24
  800121:	68 07 10 80 00       	push   $0x801007
  800126:	e8 ed 01 00 00       	call   800318 <_panic>

0080012b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	57                   	push   %edi
  80012f:	56                   	push   %esi
  800130:	53                   	push   %ebx
    asm volatile("int %1\n"
  800131:	ba 00 00 00 00       	mov    $0x0,%edx
  800136:	b8 02 00 00 00       	mov    $0x2,%eax
  80013b:	89 d1                	mov    %edx,%ecx
  80013d:	89 d3                	mov    %edx,%ebx
  80013f:	89 d7                	mov    %edx,%edi
  800141:	89 d6                	mov    %edx,%esi
  800143:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5f                   	pop    %edi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <sys_yield>:

void
sys_yield(void)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800150:	ba 00 00 00 00       	mov    $0x0,%edx
  800155:	b8 0a 00 00 00       	mov    $0xa,%eax
  80015a:	89 d1                	mov    %edx,%ecx
  80015c:	89 d3                	mov    %edx,%ebx
  80015e:	89 d7                	mov    %edx,%edi
  800160:	89 d6                	mov    %edx,%esi
  800162:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
  80016f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800172:	be 00 00 00 00       	mov    $0x0,%esi
  800177:	8b 55 08             	mov    0x8(%ebp),%edx
  80017a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017d:	b8 04 00 00 00       	mov    $0x4,%eax
  800182:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800185:	89 f7                	mov    %esi,%edi
  800187:	cd 30                	int    $0x30
    if (check && ret > 0)
  800189:	85 c0                	test   %eax,%eax
  80018b:	7f 08                	jg     800195 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800190:	5b                   	pop    %ebx
  800191:	5e                   	pop    %esi
  800192:	5f                   	pop    %edi
  800193:	5d                   	pop    %ebp
  800194:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	50                   	push   %eax
  800199:	6a 04                	push   $0x4
  80019b:	68 ea 0f 80 00       	push   $0x800fea
  8001a0:	6a 24                	push   $0x24
  8001a2:	68 07 10 80 00       	push   $0x801007
  8001a7:	e8 6c 01 00 00       	call   800318 <_panic>

008001ac <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	57                   	push   %edi
  8001b0:	56                   	push   %esi
  8001b1:	53                   	push   %ebx
  8001b2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c9:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001cb:	85 c0                	test   %eax,%eax
  8001cd:	7f 08                	jg     8001d7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d2:	5b                   	pop    %ebx
  8001d3:	5e                   	pop    %esi
  8001d4:	5f                   	pop    %edi
  8001d5:	5d                   	pop    %ebp
  8001d6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	50                   	push   %eax
  8001db:	6a 05                	push   $0x5
  8001dd:	68 ea 0f 80 00       	push   $0x800fea
  8001e2:	6a 24                	push   $0x24
  8001e4:	68 07 10 80 00       	push   $0x801007
  8001e9:	e8 2a 01 00 00       	call   800318 <_panic>

008001ee <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	57                   	push   %edi
  8001f2:	56                   	push   %esi
  8001f3:	53                   	push   %ebx
  8001f4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800202:	b8 06 00 00 00       	mov    $0x6,%eax
  800207:	89 df                	mov    %ebx,%edi
  800209:	89 de                	mov    %ebx,%esi
  80020b:	cd 30                	int    $0x30
    if (check && ret > 0)
  80020d:	85 c0                	test   %eax,%eax
  80020f:	7f 08                	jg     800219 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	50                   	push   %eax
  80021d:	6a 06                	push   $0x6
  80021f:	68 ea 0f 80 00       	push   $0x800fea
  800224:	6a 24                	push   $0x24
  800226:	68 07 10 80 00       	push   $0x801007
  80022b:	e8 e8 00 00 00       	call   800318 <_panic>

00800230 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023e:	8b 55 08             	mov    0x8(%ebp),%edx
  800241:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800244:	b8 08 00 00 00       	mov    $0x8,%eax
  800249:	89 df                	mov    %ebx,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80024f:	85 c0                	test   %eax,%eax
  800251:	7f 08                	jg     80025b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800256:	5b                   	pop    %ebx
  800257:	5e                   	pop    %esi
  800258:	5f                   	pop    %edi
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	50                   	push   %eax
  80025f:	6a 08                	push   $0x8
  800261:	68 ea 0f 80 00       	push   $0x800fea
  800266:	6a 24                	push   $0x24
  800268:	68 07 10 80 00       	push   $0x801007
  80026d:	e8 a6 00 00 00       	call   800318 <_panic>

00800272 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	57                   	push   %edi
  800276:	56                   	push   %esi
  800277:	53                   	push   %ebx
  800278:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80027b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800280:	8b 55 08             	mov    0x8(%ebp),%edx
  800283:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800286:	b8 09 00 00 00       	mov    $0x9,%eax
  80028b:	89 df                	mov    %ebx,%edi
  80028d:	89 de                	mov    %ebx,%esi
  80028f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800291:	85 c0                	test   %eax,%eax
  800293:	7f 08                	jg     80029d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800295:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800298:	5b                   	pop    %ebx
  800299:	5e                   	pop    %esi
  80029a:	5f                   	pop    %edi
  80029b:	5d                   	pop    %ebp
  80029c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	50                   	push   %eax
  8002a1:	6a 09                	push   $0x9
  8002a3:	68 ea 0f 80 00       	push   $0x800fea
  8002a8:	6a 24                	push   $0x24
  8002aa:	68 07 10 80 00       	push   $0x801007
  8002af:	e8 64 00 00 00       	call   800318 <_panic>

008002b4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	57                   	push   %edi
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002c5:	be 00 00 00 00       	mov    $0x0,%esi
  8002ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002cd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002d0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ed:	89 cb                	mov    %ecx,%ebx
  8002ef:	89 cf                	mov    %ecx,%edi
  8002f1:	89 ce                	mov    %ecx,%esi
  8002f3:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002f5:	85 c0                	test   %eax,%eax
  8002f7:	7f 08                	jg     800301 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fc:	5b                   	pop    %ebx
  8002fd:	5e                   	pop    %esi
  8002fe:	5f                   	pop    %edi
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800301:	83 ec 0c             	sub    $0xc,%esp
  800304:	50                   	push   %eax
  800305:	6a 0c                	push   $0xc
  800307:	68 ea 0f 80 00       	push   $0x800fea
  80030c:	6a 24                	push   $0x24
  80030e:	68 07 10 80 00       	push   $0x801007
  800313:	e8 00 00 00 00       	call   800318 <_panic>

00800318 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	56                   	push   %esi
  80031c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80031d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800320:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800326:	e8 00 fe ff ff       	call   80012b <sys_getenvid>
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	56                   	push   %esi
  800335:	50                   	push   %eax
  800336:	68 18 10 80 00       	push   $0x801018
  80033b:	e8 b3 00 00 00       	call   8003f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800340:	83 c4 18             	add    $0x18,%esp
  800343:	53                   	push   %ebx
  800344:	ff 75 10             	pushl  0x10(%ebp)
  800347:	e8 56 00 00 00       	call   8003a2 <vcprintf>
	cprintf("\n");
  80034c:	c7 04 24 3c 10 80 00 	movl   $0x80103c,(%esp)
  800353:	e8 9b 00 00 00       	call   8003f3 <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80035b:	cc                   	int3   
  80035c:	eb fd                	jmp    80035b <_panic+0x43>

0080035e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	53                   	push   %ebx
  800362:	83 ec 04             	sub    $0x4,%esp
  800365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800368:	8b 13                	mov    (%ebx),%edx
  80036a:	8d 42 01             	lea    0x1(%edx),%eax
  80036d:	89 03                	mov    %eax,(%ebx)
  80036f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800372:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800376:	3d ff 00 00 00       	cmp    $0xff,%eax
  80037b:	74 09                	je     800386 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80037d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800384:	c9                   	leave  
  800385:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	68 ff 00 00 00       	push   $0xff
  80038e:	8d 43 08             	lea    0x8(%ebx),%eax
  800391:	50                   	push   %eax
  800392:	e8 16 fd ff ff       	call   8000ad <sys_cputs>
		b->idx = 0;
  800397:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	eb db                	jmp    80037d <putch+0x1f>

008003a2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003b2:	00 00 00 
	b.cnt = 0;
  8003b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003bc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003bf:	ff 75 0c             	pushl  0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003cb:	50                   	push   %eax
  8003cc:	68 5e 03 80 00       	push   $0x80035e
  8003d1:	e8 1a 01 00 00       	call   8004f0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003d6:	83 c4 08             	add    $0x8,%esp
  8003d9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003df:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003e5:	50                   	push   %eax
  8003e6:	e8 c2 fc ff ff       	call   8000ad <sys_cputs>

	return b.cnt;
}
  8003eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003f1:	c9                   	leave  
  8003f2:	c3                   	ret    

008003f3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003f9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003fc:	50                   	push   %eax
  8003fd:	ff 75 08             	pushl  0x8(%ebp)
  800400:	e8 9d ff ff ff       	call   8003a2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	57                   	push   %edi
  80040b:	56                   	push   %esi
  80040c:	53                   	push   %ebx
  80040d:	83 ec 1c             	sub    $0x1c,%esp
  800410:	89 c7                	mov    %eax,%edi
  800412:	89 d6                	mov    %edx,%esi
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800420:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800423:	bb 00 00 00 00       	mov    $0x0,%ebx
  800428:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80042b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80042e:	39 d3                	cmp    %edx,%ebx
  800430:	72 05                	jb     800437 <printnum+0x30>
  800432:	39 45 10             	cmp    %eax,0x10(%ebp)
  800435:	77 7a                	ja     8004b1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800437:	83 ec 0c             	sub    $0xc,%esp
  80043a:	ff 75 18             	pushl  0x18(%ebp)
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800443:	53                   	push   %ebx
  800444:	ff 75 10             	pushl  0x10(%ebp)
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80044d:	ff 75 e0             	pushl  -0x20(%ebp)
  800450:	ff 75 dc             	pushl  -0x24(%ebp)
  800453:	ff 75 d8             	pushl  -0x28(%ebp)
  800456:	e8 35 09 00 00       	call   800d90 <__udivdi3>
  80045b:	83 c4 18             	add    $0x18,%esp
  80045e:	52                   	push   %edx
  80045f:	50                   	push   %eax
  800460:	89 f2                	mov    %esi,%edx
  800462:	89 f8                	mov    %edi,%eax
  800464:	e8 9e ff ff ff       	call   800407 <printnum>
  800469:	83 c4 20             	add    $0x20,%esp
  80046c:	eb 13                	jmp    800481 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	56                   	push   %esi
  800472:	ff 75 18             	pushl  0x18(%ebp)
  800475:	ff d7                	call   *%edi
  800477:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80047a:	83 eb 01             	sub    $0x1,%ebx
  80047d:	85 db                	test   %ebx,%ebx
  80047f:	7f ed                	jg     80046e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	56                   	push   %esi
  800485:	83 ec 04             	sub    $0x4,%esp
  800488:	ff 75 e4             	pushl  -0x1c(%ebp)
  80048b:	ff 75 e0             	pushl  -0x20(%ebp)
  80048e:	ff 75 dc             	pushl  -0x24(%ebp)
  800491:	ff 75 d8             	pushl  -0x28(%ebp)
  800494:	e8 17 0a 00 00       	call   800eb0 <__umoddi3>
  800499:	83 c4 14             	add    $0x14,%esp
  80049c:	0f be 80 3e 10 80 00 	movsbl 0x80103e(%eax),%eax
  8004a3:	50                   	push   %eax
  8004a4:	ff d7                	call   *%edi
}
  8004a6:	83 c4 10             	add    $0x10,%esp
  8004a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ac:	5b                   	pop    %ebx
  8004ad:	5e                   	pop    %esi
  8004ae:	5f                   	pop    %edi
  8004af:	5d                   	pop    %ebp
  8004b0:	c3                   	ret    
  8004b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004b4:	eb c4                	jmp    80047a <printnum+0x73>

008004b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004bc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c0:	8b 10                	mov    (%eax),%edx
  8004c2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c5:	73 0a                	jae    8004d1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ca:	89 08                	mov    %ecx,(%eax)
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	88 02                	mov    %al,(%edx)
}
  8004d1:	5d                   	pop    %ebp
  8004d2:	c3                   	ret    

008004d3 <printfmt>:
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004d9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004dc:	50                   	push   %eax
  8004dd:	ff 75 10             	pushl  0x10(%ebp)
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 05 00 00 00       	call   8004f0 <vprintfmt>
}
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <vprintfmt>:
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 2c             	sub    $0x2c,%esp
  8004f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  800502:	e9 00 04 00 00       	jmp    800907 <vprintfmt+0x417>
		padc = ' ';
  800507:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80050b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800512:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800519:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800520:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8d 47 01             	lea    0x1(%edi),%eax
  800528:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80052b:	0f b6 17             	movzbl (%edi),%edx
  80052e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800531:	3c 55                	cmp    $0x55,%al
  800533:	0f 87 51 04 00 00    	ja     80098a <vprintfmt+0x49a>
  800539:	0f b6 c0             	movzbl %al,%eax
  80053c:	ff 24 85 00 11 80 00 	jmp    *0x801100(,%eax,4)
  800543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800546:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80054a:	eb d9                	jmp    800525 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80054c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80054f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800553:	eb d0                	jmp    800525 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800555:	0f b6 d2             	movzbl %dl,%edx
  800558:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80055b:	b8 00 00 00 00       	mov    $0x0,%eax
  800560:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800563:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800566:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80056a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80056d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800570:	83 f9 09             	cmp    $0x9,%ecx
  800573:	77 55                	ja     8005ca <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800575:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800578:	eb e9                	jmp    800563 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8d 40 04             	lea    0x4(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80058b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80058e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800592:	79 91                	jns    800525 <vprintfmt+0x35>
				width = precision, precision = -1;
  800594:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800597:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005a1:	eb 82                	jmp    800525 <vprintfmt+0x35>
  8005a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ad:	0f 49 d0             	cmovns %eax,%edx
  8005b0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005b6:	e9 6a ff ff ff       	jmp    800525 <vprintfmt+0x35>
  8005bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005be:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005c5:	e9 5b ff ff ff       	jmp    800525 <vprintfmt+0x35>
  8005ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d0:	eb bc                	jmp    80058e <vprintfmt+0x9e>
			lflag++;
  8005d2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005d8:	e9 48 ff ff ff       	jmp    800525 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 78 04             	lea    0x4(%eax),%edi
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	53                   	push   %ebx
  8005e7:	ff 30                	pushl  (%eax)
  8005e9:	ff d6                	call   *%esi
			break;
  8005eb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005ee:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005f1:	e9 0e 03 00 00       	jmp    800904 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8d 78 04             	lea    0x4(%eax),%edi
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	99                   	cltd   
  8005ff:	31 d0                	xor    %edx,%eax
  800601:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800603:	83 f8 08             	cmp    $0x8,%eax
  800606:	7f 23                	jg     80062b <vprintfmt+0x13b>
  800608:	8b 14 85 60 12 80 00 	mov    0x801260(,%eax,4),%edx
  80060f:	85 d2                	test   %edx,%edx
  800611:	74 18                	je     80062b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800613:	52                   	push   %edx
  800614:	68 5f 10 80 00       	push   $0x80105f
  800619:	53                   	push   %ebx
  80061a:	56                   	push   %esi
  80061b:	e8 b3 fe ff ff       	call   8004d3 <printfmt>
  800620:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800623:	89 7d 14             	mov    %edi,0x14(%ebp)
  800626:	e9 d9 02 00 00       	jmp    800904 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80062b:	50                   	push   %eax
  80062c:	68 56 10 80 00       	push   $0x801056
  800631:	53                   	push   %ebx
  800632:	56                   	push   %esi
  800633:	e8 9b fe ff ff       	call   8004d3 <printfmt>
  800638:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80063b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80063e:	e9 c1 02 00 00       	jmp    800904 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	83 c0 04             	add    $0x4,%eax
  800649:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800651:	85 ff                	test   %edi,%edi
  800653:	b8 4f 10 80 00       	mov    $0x80104f,%eax
  800658:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80065b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065f:	0f 8e bd 00 00 00    	jle    800722 <vprintfmt+0x232>
  800665:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800669:	75 0e                	jne    800679 <vprintfmt+0x189>
  80066b:	89 75 08             	mov    %esi,0x8(%ebp)
  80066e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800671:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800674:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800677:	eb 6d                	jmp    8006e6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	ff 75 d0             	pushl  -0x30(%ebp)
  80067f:	57                   	push   %edi
  800680:	e8 ad 03 00 00       	call   800a32 <strnlen>
  800685:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800688:	29 c1                	sub    %eax,%ecx
  80068a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80068d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800690:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800694:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800697:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80069a:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80069c:	eb 0f                	jmp    8006ad <vprintfmt+0x1bd>
					putch(padc, putdat);
  80069e:	83 ec 08             	sub    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	83 ef 01             	sub    $0x1,%edi
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	85 ff                	test   %edi,%edi
  8006af:	7f ed                	jg     80069e <vprintfmt+0x1ae>
  8006b1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006b4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006b7:	85 c9                	test   %ecx,%ecx
  8006b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006be:	0f 49 c1             	cmovns %ecx,%eax
  8006c1:	29 c1                	sub    %eax,%ecx
  8006c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006cc:	89 cb                	mov    %ecx,%ebx
  8006ce:	eb 16                	jmp    8006e6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006d4:	75 31                	jne    800707 <vprintfmt+0x217>
					putch(ch, putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	50                   	push   %eax
  8006dd:	ff 55 08             	call   *0x8(%ebp)
  8006e0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e3:	83 eb 01             	sub    $0x1,%ebx
  8006e6:	83 c7 01             	add    $0x1,%edi
  8006e9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006ed:	0f be c2             	movsbl %dl,%eax
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 59                	je     80074d <vprintfmt+0x25d>
  8006f4:	85 f6                	test   %esi,%esi
  8006f6:	78 d8                	js     8006d0 <vprintfmt+0x1e0>
  8006f8:	83 ee 01             	sub    $0x1,%esi
  8006fb:	79 d3                	jns    8006d0 <vprintfmt+0x1e0>
  8006fd:	89 df                	mov    %ebx,%edi
  8006ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800702:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800705:	eb 37                	jmp    80073e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	0f be d2             	movsbl %dl,%edx
  80070a:	83 ea 20             	sub    $0x20,%edx
  80070d:	83 fa 5e             	cmp    $0x5e,%edx
  800710:	76 c4                	jbe    8006d6 <vprintfmt+0x1e6>
					putch('?', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 3f                	push   $0x3f
  80071a:	ff 55 08             	call   *0x8(%ebp)
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	eb c1                	jmp    8006e3 <vprintfmt+0x1f3>
  800722:	89 75 08             	mov    %esi,0x8(%ebp)
  800725:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800728:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80072b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80072e:	eb b6                	jmp    8006e6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	53                   	push   %ebx
  800734:	6a 20                	push   $0x20
  800736:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800738:	83 ef 01             	sub    $0x1,%edi
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	85 ff                	test   %edi,%edi
  800740:	7f ee                	jg     800730 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800742:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
  800748:	e9 b7 01 00 00       	jmp    800904 <vprintfmt+0x414>
  80074d:	89 df                	mov    %ebx,%edi
  80074f:	8b 75 08             	mov    0x8(%ebp),%esi
  800752:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800755:	eb e7                	jmp    80073e <vprintfmt+0x24e>
	if (lflag >= 2)
  800757:	83 f9 01             	cmp    $0x1,%ecx
  80075a:	7e 3f                	jle    80079b <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 50 04             	mov    0x4(%eax),%edx
  800762:	8b 00                	mov    (%eax),%eax
  800764:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800767:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 40 08             	lea    0x8(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800773:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800777:	79 5c                	jns    8007d5 <vprintfmt+0x2e5>
				putch('-', putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 2d                	push   $0x2d
  80077f:	ff d6                	call   *%esi
				num = -(long long) num;
  800781:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800784:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800787:	f7 da                	neg    %edx
  800789:	83 d1 00             	adc    $0x0,%ecx
  80078c:	f7 d9                	neg    %ecx
  80078e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800791:	b8 0a 00 00 00       	mov    $0xa,%eax
  800796:	e9 4f 01 00 00       	jmp    8008ea <vprintfmt+0x3fa>
	else if (lflag)
  80079b:	85 c9                	test   %ecx,%ecx
  80079d:	75 1b                	jne    8007ba <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 c1                	mov    %eax,%ecx
  8007a9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ac:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8d 40 04             	lea    0x4(%eax),%eax
  8007b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b8:	eb b9                	jmp    800773 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c2:	89 c1                	mov    %eax,%ecx
  8007c4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007c7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8d 40 04             	lea    0x4(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d3:	eb 9e                	jmp    800773 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007d8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e0:	e9 05 01 00 00       	jmp    8008ea <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007e5:	83 f9 01             	cmp    $0x1,%ecx
  8007e8:	7e 18                	jle    800802 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 10                	mov    (%eax),%edx
  8007ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f2:	8d 40 08             	lea    0x8(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fd:	e9 e8 00 00 00       	jmp    8008ea <vprintfmt+0x3fa>
	else if (lflag)
  800802:	85 c9                	test   %ecx,%ecx
  800804:	75 1a                	jne    800820 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800816:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081b:	e9 ca 00 00 00       	jmp    8008ea <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
  800825:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800830:	b8 0a 00 00 00       	mov    $0xa,%eax
  800835:	e9 b0 00 00 00       	jmp    8008ea <vprintfmt+0x3fa>
	if (lflag >= 2)
  80083a:	83 f9 01             	cmp    $0x1,%ecx
  80083d:	7e 3c                	jle    80087b <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8b 50 04             	mov    0x4(%eax),%edx
  800845:	8b 00                	mov    (%eax),%eax
  800847:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 40 08             	lea    0x8(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800856:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80085a:	79 59                	jns    8008b5 <vprintfmt+0x3c5>
                putch('-', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 2d                	push   $0x2d
  800862:	ff d6                	call   *%esi
                num = -(long long) num;
  800864:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800867:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80086a:	f7 da                	neg    %edx
  80086c:	83 d1 00             	adc    $0x0,%ecx
  80086f:	f7 d9                	neg    %ecx
  800871:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800874:	b8 08 00 00 00       	mov    $0x8,%eax
  800879:	eb 6f                	jmp    8008ea <vprintfmt+0x3fa>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	75 1b                	jne    80089a <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 c1                	mov    %eax,%ecx
  800889:	c1 f9 1f             	sar    $0x1f,%ecx
  80088c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 04             	lea    0x4(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	eb bc                	jmp    800856 <vprintfmt+0x366>
		return va_arg(*ap, long);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 c1                	mov    %eax,%ecx
  8008a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8008a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	eb a1                	jmp    800856 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8008c0:	eb 28                	jmp    8008ea <vprintfmt+0x3fa>
			putch('0', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	6a 30                	push   $0x30
  8008c8:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ca:	83 c4 08             	add    $0x8,%esp
  8008cd:	53                   	push   %ebx
  8008ce:	6a 78                	push   $0x78
  8008d0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008dc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008df:	8d 40 04             	lea    0x4(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008ea:	83 ec 0c             	sub    $0xc,%esp
  8008ed:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008f1:	57                   	push   %edi
  8008f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	51                   	push   %ecx
  8008f7:	52                   	push   %edx
  8008f8:	89 da                	mov    %ebx,%edx
  8008fa:	89 f0                	mov    %esi,%eax
  8008fc:	e8 06 fb ff ff       	call   800407 <printnum>
			break;
  800901:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800904:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800907:	83 c7 01             	add    $0x1,%edi
  80090a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80090e:	83 f8 25             	cmp    $0x25,%eax
  800911:	0f 84 f0 fb ff ff    	je     800507 <vprintfmt+0x17>
			if (ch == '\0')
  800917:	85 c0                	test   %eax,%eax
  800919:	0f 84 8b 00 00 00    	je     8009aa <vprintfmt+0x4ba>
			putch(ch, putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	53                   	push   %ebx
  800923:	50                   	push   %eax
  800924:	ff d6                	call   *%esi
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	eb dc                	jmp    800907 <vprintfmt+0x417>
	if (lflag >= 2)
  80092b:	83 f9 01             	cmp    $0x1,%ecx
  80092e:	7e 15                	jle    800945 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8b 10                	mov    (%eax),%edx
  800935:	8b 48 04             	mov    0x4(%eax),%ecx
  800938:	8d 40 08             	lea    0x8(%eax),%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093e:	b8 10 00 00 00       	mov    $0x10,%eax
  800943:	eb a5                	jmp    8008ea <vprintfmt+0x3fa>
	else if (lflag)
  800945:	85 c9                	test   %ecx,%ecx
  800947:	75 17                	jne    800960 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8b 10                	mov    (%eax),%edx
  80094e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800953:	8d 40 04             	lea    0x4(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800959:	b8 10 00 00 00       	mov    $0x10,%eax
  80095e:	eb 8a                	jmp    8008ea <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8b 10                	mov    (%eax),%edx
  800965:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096a:	8d 40 04             	lea    0x4(%eax),%eax
  80096d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800970:	b8 10 00 00 00       	mov    $0x10,%eax
  800975:	e9 70 ff ff ff       	jmp    8008ea <vprintfmt+0x3fa>
			putch(ch, putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	53                   	push   %ebx
  80097e:	6a 25                	push   $0x25
  800980:	ff d6                	call   *%esi
			break;
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	e9 7a ff ff ff       	jmp    800904 <vprintfmt+0x414>
			putch('%', putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	53                   	push   %ebx
  80098e:	6a 25                	push   $0x25
  800990:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 f8                	mov    %edi,%eax
  800997:	eb 03                	jmp    80099c <vprintfmt+0x4ac>
  800999:	83 e8 01             	sub    $0x1,%eax
  80099c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a0:	75 f7                	jne    800999 <vprintfmt+0x4a9>
  8009a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a5:	e9 5a ff ff ff       	jmp    800904 <vprintfmt+0x414>
}
  8009aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5f                   	pop    %edi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	83 ec 18             	sub    $0x18,%esp
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009cf:	85 c0                	test   %eax,%eax
  8009d1:	74 26                	je     8009f9 <vsnprintf+0x47>
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	7e 22                	jle    8009f9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d7:	ff 75 14             	pushl  0x14(%ebp)
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e0:	50                   	push   %eax
  8009e1:	68 b6 04 80 00       	push   $0x8004b6
  8009e6:	e8 05 fb ff ff       	call   8004f0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    
		return -E_INVAL;
  8009f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fe:	eb f7                	jmp    8009f7 <vsnprintf+0x45>

00800a00 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a06:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a09:	50                   	push   %eax
  800a0a:	ff 75 10             	pushl  0x10(%ebp)
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	ff 75 08             	pushl  0x8(%ebp)
  800a13:	e8 9a ff ff ff       	call   8009b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	eb 03                	jmp    800a2a <strlen+0x10>
		n++;
  800a27:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a2a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a2e:	75 f7                	jne    800a27 <strlen+0xd>
	return n;
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a40:	eb 03                	jmp    800a45 <strnlen+0x13>
		n++;
  800a42:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a45:	39 d0                	cmp    %edx,%eax
  800a47:	74 06                	je     800a4f <strnlen+0x1d>
  800a49:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a4d:	75 f3                	jne    800a42 <strnlen+0x10>
	return n;
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	83 c2 01             	add    $0x1,%edx
  800a63:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a67:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a6a:	84 db                	test   %bl,%bl
  800a6c:	75 ef                	jne    800a5d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a6e:	5b                   	pop    %ebx
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	53                   	push   %ebx
  800a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a78:	53                   	push   %ebx
  800a79:	e8 9c ff ff ff       	call   800a1a <strlen>
  800a7e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	01 d8                	add    %ebx,%eax
  800a86:	50                   	push   %eax
  800a87:	e8 c5 ff ff ff       	call   800a51 <strcpy>
	return dst;
}
  800a8c:	89 d8                	mov    %ebx,%eax
  800a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9e:	89 f3                	mov    %esi,%ebx
  800aa0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa3:	89 f2                	mov    %esi,%edx
  800aa5:	eb 0f                	jmp    800ab6 <strncpy+0x23>
		*dst++ = *src;
  800aa7:	83 c2 01             	add    $0x1,%edx
  800aaa:	0f b6 01             	movzbl (%ecx),%eax
  800aad:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab0:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ab6:	39 da                	cmp    %ebx,%edx
  800ab8:	75 ed                	jne    800aa7 <strncpy+0x14>
	}
	return ret;
}
  800aba:	89 f0                	mov    %esi,%eax
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	56                   	push   %esi
  800ac4:	53                   	push   %ebx
  800ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ace:	89 f0                	mov    %esi,%eax
  800ad0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad4:	85 c9                	test   %ecx,%ecx
  800ad6:	75 0b                	jne    800ae3 <strlcpy+0x23>
  800ad8:	eb 17                	jmp    800af1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ada:	83 c2 01             	add    $0x1,%edx
  800add:	83 c0 01             	add    $0x1,%eax
  800ae0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ae3:	39 d8                	cmp    %ebx,%eax
  800ae5:	74 07                	je     800aee <strlcpy+0x2e>
  800ae7:	0f b6 0a             	movzbl (%edx),%ecx
  800aea:	84 c9                	test   %cl,%cl
  800aec:	75 ec                	jne    800ada <strlcpy+0x1a>
		*dst = '\0';
  800aee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af1:	29 f0                	sub    %esi,%eax
}
  800af3:	5b                   	pop    %ebx
  800af4:	5e                   	pop    %esi
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b00:	eb 06                	jmp    800b08 <strcmp+0x11>
		p++, q++;
  800b02:	83 c1 01             	add    $0x1,%ecx
  800b05:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b08:	0f b6 01             	movzbl (%ecx),%eax
  800b0b:	84 c0                	test   %al,%al
  800b0d:	74 04                	je     800b13 <strcmp+0x1c>
  800b0f:	3a 02                	cmp    (%edx),%al
  800b11:	74 ef                	je     800b02 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b13:	0f b6 c0             	movzbl %al,%eax
  800b16:	0f b6 12             	movzbl (%edx),%edx
  800b19:	29 d0                	sub    %edx,%eax
}
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2c:	eb 06                	jmp    800b34 <strncmp+0x17>
		n--, p++, q++;
  800b2e:	83 c0 01             	add    $0x1,%eax
  800b31:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b34:	39 d8                	cmp    %ebx,%eax
  800b36:	74 16                	je     800b4e <strncmp+0x31>
  800b38:	0f b6 08             	movzbl (%eax),%ecx
  800b3b:	84 c9                	test   %cl,%cl
  800b3d:	74 04                	je     800b43 <strncmp+0x26>
  800b3f:	3a 0a                	cmp    (%edx),%cl
  800b41:	74 eb                	je     800b2e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b43:	0f b6 00             	movzbl (%eax),%eax
  800b46:	0f b6 12             	movzbl (%edx),%edx
  800b49:	29 d0                	sub    %edx,%eax
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    
		return 0;
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b53:	eb f6                	jmp    800b4b <strncmp+0x2e>

00800b55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5f:	0f b6 10             	movzbl (%eax),%edx
  800b62:	84 d2                	test   %dl,%dl
  800b64:	74 09                	je     800b6f <strchr+0x1a>
		if (*s == c)
  800b66:	38 ca                	cmp    %cl,%dl
  800b68:	74 0a                	je     800b74 <strchr+0x1f>
	for (; *s; s++)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	eb f0                	jmp    800b5f <strchr+0xa>
			return (char *) s;
	return 0;
  800b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b80:	eb 03                	jmp    800b85 <strfind+0xf>
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b88:	38 ca                	cmp    %cl,%dl
  800b8a:	74 04                	je     800b90 <strfind+0x1a>
  800b8c:	84 d2                	test   %dl,%dl
  800b8e:	75 f2                	jne    800b82 <strfind+0xc>
			break;
	return (char *) s;
}
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b9e:	85 c9                	test   %ecx,%ecx
  800ba0:	74 13                	je     800bb5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba2:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba8:	75 05                	jne    800baf <memset+0x1d>
  800baa:	f6 c1 03             	test   $0x3,%cl
  800bad:	74 0d                	je     800bbc <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb2:	fc                   	cld    
  800bb3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb5:	89 f8                	mov    %edi,%eax
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    
		c &= 0xFF;
  800bbc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	c1 e3 08             	shl    $0x8,%ebx
  800bc5:	89 d0                	mov    %edx,%eax
  800bc7:	c1 e0 18             	shl    $0x18,%eax
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	c1 e6 10             	shl    $0x10,%esi
  800bcf:	09 f0                	or     %esi,%eax
  800bd1:	09 c2                	or     %eax,%edx
  800bd3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bd5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd8:	89 d0                	mov    %edx,%eax
  800bda:	fc                   	cld    
  800bdb:	f3 ab                	rep stos %eax,%es:(%edi)
  800bdd:	eb d6                	jmp    800bb5 <memset+0x23>

00800bdf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	57                   	push   %edi
  800be3:	56                   	push   %esi
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bed:	39 c6                	cmp    %eax,%esi
  800bef:	73 35                	jae    800c26 <memmove+0x47>
  800bf1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf4:	39 c2                	cmp    %eax,%edx
  800bf6:	76 2e                	jbe    800c26 <memmove+0x47>
		s += n;
		d += n;
  800bf8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfb:	89 d6                	mov    %edx,%esi
  800bfd:	09 fe                	or     %edi,%esi
  800bff:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c05:	74 0c                	je     800c13 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c07:	83 ef 01             	sub    $0x1,%edi
  800c0a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c0d:	fd                   	std    
  800c0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c10:	fc                   	cld    
  800c11:	eb 21                	jmp    800c34 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c13:	f6 c1 03             	test   $0x3,%cl
  800c16:	75 ef                	jne    800c07 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c18:	83 ef 04             	sub    $0x4,%edi
  800c1b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c1e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c21:	fd                   	std    
  800c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c24:	eb ea                	jmp    800c10 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c26:	89 f2                	mov    %esi,%edx
  800c28:	09 c2                	or     %eax,%edx
  800c2a:	f6 c2 03             	test   $0x3,%dl
  800c2d:	74 09                	je     800c38 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c2f:	89 c7                	mov    %eax,%edi
  800c31:	fc                   	cld    
  800c32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c34:	5e                   	pop    %esi
  800c35:	5f                   	pop    %edi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c38:	f6 c1 03             	test   $0x3,%cl
  800c3b:	75 f2                	jne    800c2f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c3d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	fc                   	cld    
  800c43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c45:	eb ed                	jmp    800c34 <memmove+0x55>

00800c47 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c4a:	ff 75 10             	pushl  0x10(%ebp)
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	ff 75 08             	pushl  0x8(%ebp)
  800c53:	e8 87 ff ff ff       	call   800bdf <memmove>
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 c6                	mov    %eax,%esi
  800c67:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6a:	39 f0                	cmp    %esi,%eax
  800c6c:	74 1c                	je     800c8a <memcmp+0x30>
		if (*s1 != *s2)
  800c6e:	0f b6 08             	movzbl (%eax),%ecx
  800c71:	0f b6 1a             	movzbl (%edx),%ebx
  800c74:	38 d9                	cmp    %bl,%cl
  800c76:	75 08                	jne    800c80 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c78:	83 c0 01             	add    $0x1,%eax
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	eb ea                	jmp    800c6a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c80:	0f b6 c1             	movzbl %cl,%eax
  800c83:	0f b6 db             	movzbl %bl,%ebx
  800c86:	29 d8                	sub    %ebx,%eax
  800c88:	eb 05                	jmp    800c8f <memcmp+0x35>
	}

	return 0;
  800c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c9c:	89 c2                	mov    %eax,%edx
  800c9e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ca1:	39 d0                	cmp    %edx,%eax
  800ca3:	73 09                	jae    800cae <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca5:	38 08                	cmp    %cl,(%eax)
  800ca7:	74 05                	je     800cae <memfind+0x1b>
	for (; s < ends; s++)
  800ca9:	83 c0 01             	add    $0x1,%eax
  800cac:	eb f3                	jmp    800ca1 <memfind+0xe>
			break;
	return (void *) s;
}
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbc:	eb 03                	jmp    800cc1 <strtol+0x11>
		s++;
  800cbe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cc1:	0f b6 01             	movzbl (%ecx),%eax
  800cc4:	3c 20                	cmp    $0x20,%al
  800cc6:	74 f6                	je     800cbe <strtol+0xe>
  800cc8:	3c 09                	cmp    $0x9,%al
  800cca:	74 f2                	je     800cbe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ccc:	3c 2b                	cmp    $0x2b,%al
  800cce:	74 2e                	je     800cfe <strtol+0x4e>
	int neg = 0;
  800cd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cd5:	3c 2d                	cmp    $0x2d,%al
  800cd7:	74 2f                	je     800d08 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cdf:	75 05                	jne    800ce6 <strtol+0x36>
  800ce1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce4:	74 2c                	je     800d12 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce6:	85 db                	test   %ebx,%ebx
  800ce8:	75 0a                	jne    800cf4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cea:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cef:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf2:	74 28                	je     800d1c <strtol+0x6c>
		base = 10;
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cfc:	eb 50                	jmp    800d4e <strtol+0x9e>
		s++;
  800cfe:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d01:	bf 00 00 00 00       	mov    $0x0,%edi
  800d06:	eb d1                	jmp    800cd9 <strtol+0x29>
		s++, neg = 1;
  800d08:	83 c1 01             	add    $0x1,%ecx
  800d0b:	bf 01 00 00 00       	mov    $0x1,%edi
  800d10:	eb c7                	jmp    800cd9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d12:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d16:	74 0e                	je     800d26 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d18:	85 db                	test   %ebx,%ebx
  800d1a:	75 d8                	jne    800cf4 <strtol+0x44>
		s++, base = 8;
  800d1c:	83 c1 01             	add    $0x1,%ecx
  800d1f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d24:	eb ce                	jmp    800cf4 <strtol+0x44>
		s += 2, base = 16;
  800d26:	83 c1 02             	add    $0x2,%ecx
  800d29:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d2e:	eb c4                	jmp    800cf4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d30:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d33:	89 f3                	mov    %esi,%ebx
  800d35:	80 fb 19             	cmp    $0x19,%bl
  800d38:	77 29                	ja     800d63 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d3a:	0f be d2             	movsbl %dl,%edx
  800d3d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d40:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d43:	7d 30                	jge    800d75 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d45:	83 c1 01             	add    $0x1,%ecx
  800d48:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d4e:	0f b6 11             	movzbl (%ecx),%edx
  800d51:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d54:	89 f3                	mov    %esi,%ebx
  800d56:	80 fb 09             	cmp    $0x9,%bl
  800d59:	77 d5                	ja     800d30 <strtol+0x80>
			dig = *s - '0';
  800d5b:	0f be d2             	movsbl %dl,%edx
  800d5e:	83 ea 30             	sub    $0x30,%edx
  800d61:	eb dd                	jmp    800d40 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d63:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d66:	89 f3                	mov    %esi,%ebx
  800d68:	80 fb 19             	cmp    $0x19,%bl
  800d6b:	77 08                	ja     800d75 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d6d:	0f be d2             	movsbl %dl,%edx
  800d70:	83 ea 37             	sub    $0x37,%edx
  800d73:	eb cb                	jmp    800d40 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	74 05                	je     800d80 <strtol+0xd0>
		*endptr = (char *) s;
  800d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d80:	89 c2                	mov    %eax,%edx
  800d82:	f7 da                	neg    %edx
  800d84:	85 ff                	test   %edi,%edi
  800d86:	0f 45 c2             	cmovne %edx,%eax
}
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    
  800d8e:	66 90                	xchg   %ax,%ax

00800d90 <__udivdi3>:
  800d90:	55                   	push   %ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 1c             	sub    $0x1c,%esp
  800d97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800da3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800da7:	85 d2                	test   %edx,%edx
  800da9:	75 35                	jne    800de0 <__udivdi3+0x50>
  800dab:	39 f3                	cmp    %esi,%ebx
  800dad:	0f 87 bd 00 00 00    	ja     800e70 <__udivdi3+0xe0>
  800db3:	85 db                	test   %ebx,%ebx
  800db5:	89 d9                	mov    %ebx,%ecx
  800db7:	75 0b                	jne    800dc4 <__udivdi3+0x34>
  800db9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dbe:	31 d2                	xor    %edx,%edx
  800dc0:	f7 f3                	div    %ebx
  800dc2:	89 c1                	mov    %eax,%ecx
  800dc4:	31 d2                	xor    %edx,%edx
  800dc6:	89 f0                	mov    %esi,%eax
  800dc8:	f7 f1                	div    %ecx
  800dca:	89 c6                	mov    %eax,%esi
  800dcc:	89 e8                	mov    %ebp,%eax
  800dce:	89 f7                	mov    %esi,%edi
  800dd0:	f7 f1                	div    %ecx
  800dd2:	89 fa                	mov    %edi,%edx
  800dd4:	83 c4 1c             	add    $0x1c,%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
  800ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800de0:	39 f2                	cmp    %esi,%edx
  800de2:	77 7c                	ja     800e60 <__udivdi3+0xd0>
  800de4:	0f bd fa             	bsr    %edx,%edi
  800de7:	83 f7 1f             	xor    $0x1f,%edi
  800dea:	0f 84 98 00 00 00    	je     800e88 <__udivdi3+0xf8>
  800df0:	89 f9                	mov    %edi,%ecx
  800df2:	b8 20 00 00 00       	mov    $0x20,%eax
  800df7:	29 f8                	sub    %edi,%eax
  800df9:	d3 e2                	shl    %cl,%edx
  800dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dff:	89 c1                	mov    %eax,%ecx
  800e01:	89 da                	mov    %ebx,%edx
  800e03:	d3 ea                	shr    %cl,%edx
  800e05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e09:	09 d1                	or     %edx,%ecx
  800e0b:	89 f2                	mov    %esi,%edx
  800e0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e11:	89 f9                	mov    %edi,%ecx
  800e13:	d3 e3                	shl    %cl,%ebx
  800e15:	89 c1                	mov    %eax,%ecx
  800e17:	d3 ea                	shr    %cl,%edx
  800e19:	89 f9                	mov    %edi,%ecx
  800e1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e1f:	d3 e6                	shl    %cl,%esi
  800e21:	89 eb                	mov    %ebp,%ebx
  800e23:	89 c1                	mov    %eax,%ecx
  800e25:	d3 eb                	shr    %cl,%ebx
  800e27:	09 de                	or     %ebx,%esi
  800e29:	89 f0                	mov    %esi,%eax
  800e2b:	f7 74 24 08          	divl   0x8(%esp)
  800e2f:	89 d6                	mov    %edx,%esi
  800e31:	89 c3                	mov    %eax,%ebx
  800e33:	f7 64 24 0c          	mull   0xc(%esp)
  800e37:	39 d6                	cmp    %edx,%esi
  800e39:	72 0c                	jb     800e47 <__udivdi3+0xb7>
  800e3b:	89 f9                	mov    %edi,%ecx
  800e3d:	d3 e5                	shl    %cl,%ebp
  800e3f:	39 c5                	cmp    %eax,%ebp
  800e41:	73 5d                	jae    800ea0 <__udivdi3+0x110>
  800e43:	39 d6                	cmp    %edx,%esi
  800e45:	75 59                	jne    800ea0 <__udivdi3+0x110>
  800e47:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e4a:	31 ff                	xor    %edi,%edi
  800e4c:	89 fa                	mov    %edi,%edx
  800e4e:	83 c4 1c             	add    $0x1c,%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
  800e56:	8d 76 00             	lea    0x0(%esi),%esi
  800e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e60:	31 ff                	xor    %edi,%edi
  800e62:	31 c0                	xor    %eax,%eax
  800e64:	89 fa                	mov    %edi,%edx
  800e66:	83 c4 1c             	add    $0x1c,%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
  800e6e:	66 90                	xchg   %ax,%ax
  800e70:	31 ff                	xor    %edi,%edi
  800e72:	89 e8                	mov    %ebp,%eax
  800e74:	89 f2                	mov    %esi,%edx
  800e76:	f7 f3                	div    %ebx
  800e78:	89 fa                	mov    %edi,%edx
  800e7a:	83 c4 1c             	add    $0x1c,%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
  800e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e88:	39 f2                	cmp    %esi,%edx
  800e8a:	72 06                	jb     800e92 <__udivdi3+0x102>
  800e8c:	31 c0                	xor    %eax,%eax
  800e8e:	39 eb                	cmp    %ebp,%ebx
  800e90:	77 d2                	ja     800e64 <__udivdi3+0xd4>
  800e92:	b8 01 00 00 00       	mov    $0x1,%eax
  800e97:	eb cb                	jmp    800e64 <__udivdi3+0xd4>
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	89 d8                	mov    %ebx,%eax
  800ea2:	31 ff                	xor    %edi,%edi
  800ea4:	eb be                	jmp    800e64 <__udivdi3+0xd4>
  800ea6:	66 90                	xchg   %ax,%ax
  800ea8:	66 90                	xchg   %ax,%ax
  800eaa:	66 90                	xchg   %ax,%ax
  800eac:	66 90                	xchg   %ax,%ax
  800eae:	66 90                	xchg   %ax,%ax

00800eb0 <__umoddi3>:
  800eb0:	55                   	push   %ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 1c             	sub    $0x1c,%esp
  800eb7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800ebb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ebf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ec3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ec7:	85 ed                	test   %ebp,%ebp
  800ec9:	89 f0                	mov    %esi,%eax
  800ecb:	89 da                	mov    %ebx,%edx
  800ecd:	75 19                	jne    800ee8 <__umoddi3+0x38>
  800ecf:	39 df                	cmp    %ebx,%edi
  800ed1:	0f 86 b1 00 00 00    	jbe    800f88 <__umoddi3+0xd8>
  800ed7:	f7 f7                	div    %edi
  800ed9:	89 d0                	mov    %edx,%eax
  800edb:	31 d2                	xor    %edx,%edx
  800edd:	83 c4 1c             	add    $0x1c,%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
  800ee5:	8d 76 00             	lea    0x0(%esi),%esi
  800ee8:	39 dd                	cmp    %ebx,%ebp
  800eea:	77 f1                	ja     800edd <__umoddi3+0x2d>
  800eec:	0f bd cd             	bsr    %ebp,%ecx
  800eef:	83 f1 1f             	xor    $0x1f,%ecx
  800ef2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ef6:	0f 84 b4 00 00 00    	je     800fb0 <__umoddi3+0x100>
  800efc:	b8 20 00 00 00       	mov    $0x20,%eax
  800f01:	89 c2                	mov    %eax,%edx
  800f03:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f07:	29 c2                	sub    %eax,%edx
  800f09:	89 c1                	mov    %eax,%ecx
  800f0b:	89 f8                	mov    %edi,%eax
  800f0d:	d3 e5                	shl    %cl,%ebp
  800f0f:	89 d1                	mov    %edx,%ecx
  800f11:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f15:	d3 e8                	shr    %cl,%eax
  800f17:	09 c5                	or     %eax,%ebp
  800f19:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f1d:	89 c1                	mov    %eax,%ecx
  800f1f:	d3 e7                	shl    %cl,%edi
  800f21:	89 d1                	mov    %edx,%ecx
  800f23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f27:	89 df                	mov    %ebx,%edi
  800f29:	d3 ef                	shr    %cl,%edi
  800f2b:	89 c1                	mov    %eax,%ecx
  800f2d:	89 f0                	mov    %esi,%eax
  800f2f:	d3 e3                	shl    %cl,%ebx
  800f31:	89 d1                	mov    %edx,%ecx
  800f33:	89 fa                	mov    %edi,%edx
  800f35:	d3 e8                	shr    %cl,%eax
  800f37:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f3c:	09 d8                	or     %ebx,%eax
  800f3e:	f7 f5                	div    %ebp
  800f40:	d3 e6                	shl    %cl,%esi
  800f42:	89 d1                	mov    %edx,%ecx
  800f44:	f7 64 24 08          	mull   0x8(%esp)
  800f48:	39 d1                	cmp    %edx,%ecx
  800f4a:	89 c3                	mov    %eax,%ebx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	72 06                	jb     800f56 <__umoddi3+0xa6>
  800f50:	75 0e                	jne    800f60 <__umoddi3+0xb0>
  800f52:	39 c6                	cmp    %eax,%esi
  800f54:	73 0a                	jae    800f60 <__umoddi3+0xb0>
  800f56:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f5a:	19 ea                	sbb    %ebp,%edx
  800f5c:	89 d7                	mov    %edx,%edi
  800f5e:	89 c3                	mov    %eax,%ebx
  800f60:	89 ca                	mov    %ecx,%edx
  800f62:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f67:	29 de                	sub    %ebx,%esi
  800f69:	19 fa                	sbb    %edi,%edx
  800f6b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f6f:	89 d0                	mov    %edx,%eax
  800f71:	d3 e0                	shl    %cl,%eax
  800f73:	89 d9                	mov    %ebx,%ecx
  800f75:	d3 ee                	shr    %cl,%esi
  800f77:	d3 ea                	shr    %cl,%edx
  800f79:	09 f0                	or     %esi,%eax
  800f7b:	83 c4 1c             	add    $0x1c,%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
  800f83:	90                   	nop
  800f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f88:	85 ff                	test   %edi,%edi
  800f8a:	89 f9                	mov    %edi,%ecx
  800f8c:	75 0b                	jne    800f99 <__umoddi3+0xe9>
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f93:	31 d2                	xor    %edx,%edx
  800f95:	f7 f7                	div    %edi
  800f97:	89 c1                	mov    %eax,%ecx
  800f99:	89 d8                	mov    %ebx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	f7 f1                	div    %ecx
  800f9f:	89 f0                	mov    %esi,%eax
  800fa1:	f7 f1                	div    %ecx
  800fa3:	e9 31 ff ff ff       	jmp    800ed9 <__umoddi3+0x29>
  800fa8:	90                   	nop
  800fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fb0:	39 dd                	cmp    %ebx,%ebp
  800fb2:	72 08                	jb     800fbc <__umoddi3+0x10c>
  800fb4:	39 f7                	cmp    %esi,%edi
  800fb6:	0f 87 21 ff ff ff    	ja     800edd <__umoddi3+0x2d>
  800fbc:	89 da                	mov    %ebx,%edx
  800fbe:	89 f0                	mov    %esi,%eax
  800fc0:	29 f8                	sub    %edi,%eax
  800fc2:	19 ea                	sbb    %ebp,%edx
  800fc4:	e9 14 ff ff ff       	jmp    800edd <__umoddi3+0x2d>
