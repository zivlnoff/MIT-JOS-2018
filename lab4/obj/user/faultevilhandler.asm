
obj/user/faultevilhandler：     文件格式 elf32-i386


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
  800042:	e8 32 01 00 00       	call   800179 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 2c 02 00 00       	call   800282 <sys_env_set_pgfault_upcall>
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
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 c6 00 00 00       	call   80013b <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x2d>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	e8 97 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0a 00 00 00       	call   8000ab <exit>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	e8 42 00 00 00       	call   8000fa <sys_env_destroy>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    

008000bd <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ce:	89 c3                	mov    %eax,%ebx
  8000d0:	89 c7                	mov    %eax,%edi
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_cgetc>:

int
sys_cgetc(void) {
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000eb:	89 d1                	mov    %edx,%ecx
  8000ed:	89 d3                	mov    %edx,%ebx
  8000ef:	89 d7                	mov    %edx,%edi
  8000f1:	89 d6                	mov    %edx,%esi
  8000f3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f5:	5b                   	pop    %ebx
  8000f6:	5e                   	pop    %esi
  8000f7:	5f                   	pop    %edi
  8000f8:	5d                   	pop    %ebp
  8000f9:	c3                   	ret    

008000fa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800103:	b9 00 00 00 00       	mov    $0x0,%ecx
  800108:	8b 55 08             	mov    0x8(%ebp),%edx
  80010b:	b8 03 00 00 00       	mov    $0x3,%eax
  800110:	89 cb                	mov    %ecx,%ebx
  800112:	89 cf                	mov    %ecx,%edi
  800114:	89 ce                	mov    %ecx,%esi
  800116:	cd 30                	int    $0x30
    if (check && ret > 0)
  800118:	85 c0                	test   %eax,%eax
  80011a:	7f 08                	jg     800124 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5f                   	pop    %edi
  800122:	5d                   	pop    %ebp
  800123:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	6a 03                	push   $0x3
  80012a:	68 ea 0f 80 00       	push   $0x800fea
  80012f:	6a 24                	push   $0x24
  800131:	68 07 10 80 00       	push   $0x801007
  800136:	e8 ed 01 00 00       	call   800328 <_panic>

0080013b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
    asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 02 00 00 00       	mov    $0x2,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_yield>:

void
sys_yield(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	b8 0a 00 00 00       	mov    $0xa,%eax
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	89 d3                	mov    %edx,%ebx
  80016e:	89 d7                	mov    %edx,%edi
  800170:	89 d6                	mov    %edx,%esi
  800172:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	8b 55 08             	mov    0x8(%ebp),%edx
  80018a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018d:	b8 04 00 00 00       	mov    $0x4,%eax
  800192:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800195:	89 f7                	mov    %esi,%edi
  800197:	cd 30                	int    $0x30
    if (check && ret > 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	7f 08                	jg     8001a5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a0:	5b                   	pop    %ebx
  8001a1:	5e                   	pop    %esi
  8001a2:	5f                   	pop    %edi
  8001a3:	5d                   	pop    %ebp
  8001a4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	50                   	push   %eax
  8001a9:	6a 04                	push   $0x4
  8001ab:	68 ea 0f 80 00       	push   $0x800fea
  8001b0:	6a 24                	push   $0x24
  8001b2:	68 07 10 80 00       	push   $0x801007
  8001b7:	e8 6c 01 00 00       	call   800328 <_panic>

008001bc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	57                   	push   %edi
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d9:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	7f 08                	jg     8001e7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5f                   	pop    %edi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	50                   	push   %eax
  8001eb:	6a 05                	push   $0x5
  8001ed:	68 ea 0f 80 00       	push   $0x800fea
  8001f2:	6a 24                	push   $0x24
  8001f4:	68 07 10 80 00       	push   $0x801007
  8001f9:	e8 2a 01 00 00       	call   800328 <_panic>

008001fe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800207:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800212:	b8 06 00 00 00       	mov    $0x6,%eax
  800217:	89 df                	mov    %ebx,%edi
  800219:	89 de                	mov    %ebx,%esi
  80021b:	cd 30                	int    $0x30
    if (check && ret > 0)
  80021d:	85 c0                	test   %eax,%eax
  80021f:	7f 08                	jg     800229 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5f                   	pop    %edi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	50                   	push   %eax
  80022d:	6a 06                	push   $0x6
  80022f:	68 ea 0f 80 00       	push   $0x800fea
  800234:	6a 24                	push   $0x24
  800236:	68 07 10 80 00       	push   $0x801007
  80023b:	e8 e8 00 00 00       	call   800328 <_panic>

00800240 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024e:	8b 55 08             	mov    0x8(%ebp),%edx
  800251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800254:	b8 08 00 00 00       	mov    $0x8,%eax
  800259:	89 df                	mov    %ebx,%edi
  80025b:	89 de                	mov    %ebx,%esi
  80025d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80025f:	85 c0                	test   %eax,%eax
  800261:	7f 08                	jg     80026b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	6a 08                	push   $0x8
  800271:	68 ea 0f 80 00       	push   $0x800fea
  800276:	6a 24                	push   $0x24
  800278:	68 07 10 80 00       	push   $0x801007
  80027d:	e8 a6 00 00 00       	call   800328 <_panic>

00800282 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	57                   	push   %edi
  800286:	56                   	push   %esi
  800287:	53                   	push   %ebx
  800288:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80028b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800296:	b8 09 00 00 00       	mov    $0x9,%eax
  80029b:	89 df                	mov    %ebx,%edi
  80029d:	89 de                	mov    %ebx,%esi
  80029f:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	7f 08                	jg     8002ad <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a8:	5b                   	pop    %ebx
  8002a9:	5e                   	pop    %esi
  8002aa:	5f                   	pop    %edi
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	50                   	push   %eax
  8002b1:	6a 09                	push   $0x9
  8002b3:	68 ea 0f 80 00       	push   $0x800fea
  8002b8:	6a 24                	push   $0x24
  8002ba:	68 07 10 80 00       	push   $0x801007
  8002bf:	e8 64 00 00 00       	call   800328 <_panic>

008002c4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	57                   	push   %edi
  8002c8:	56                   	push   %esi
  8002c9:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002d5:	be 00 00 00 00       	mov    $0x0,%esi
  8002da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002dd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002e0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002e2:	5b                   	pop    %ebx
  8002e3:	5e                   	pop    %esi
  8002e4:	5f                   	pop    %edi
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    

008002e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fd:	89 cb                	mov    %ecx,%ebx
  8002ff:	89 cf                	mov    %ecx,%edi
  800301:	89 ce                	mov    %ecx,%esi
  800303:	cd 30                	int    $0x30
    if (check && ret > 0)
  800305:	85 c0                	test   %eax,%eax
  800307:	7f 08                	jg     800311 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	50                   	push   %eax
  800315:	6a 0c                	push   $0xc
  800317:	68 ea 0f 80 00       	push   $0x800fea
  80031c:	6a 24                	push   $0x24
  80031e:	68 07 10 80 00       	push   $0x801007
  800323:	e8 00 00 00 00       	call   800328 <_panic>

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800330:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800336:	e8 00 fe ff ff       	call   80013b <sys_getenvid>
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	56                   	push   %esi
  800345:	50                   	push   %eax
  800346:	68 18 10 80 00       	push   $0x801018
  80034b:	e8 b3 00 00 00       	call   800403 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	53                   	push   %ebx
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	e8 56 00 00 00       	call   8003b2 <vcprintf>
	cprintf("\n");
  80035c:	c7 04 24 3c 10 80 00 	movl   $0x80103c,(%esp)
  800363:	e8 9b 00 00 00       	call   800403 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036b:	cc                   	int3   
  80036c:	eb fd                	jmp    80036b <_panic+0x43>

0080036e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	53                   	push   %ebx
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800378:	8b 13                	mov    (%ebx),%edx
  80037a:	8d 42 01             	lea    0x1(%edx),%eax
  80037d:	89 03                	mov    %eax,(%ebx)
  80037f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800382:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800386:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038b:	74 09                	je     800396 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80038d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800394:	c9                   	leave  
  800395:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	68 ff 00 00 00       	push   $0xff
  80039e:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a1:	50                   	push   %eax
  8003a2:	e8 16 fd ff ff       	call   8000bd <sys_cputs>
		b->idx = 0;
  8003a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb db                	jmp    80038d <putch+0x1f>

008003b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c2:	00 00 00 
	b.cnt = 0;
  8003c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	ff 75 08             	pushl  0x8(%ebp)
  8003d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	68 6e 03 80 00       	push   $0x80036e
  8003e1:	e8 1a 01 00 00       	call   800500 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e6:	83 c4 08             	add    $0x8,%esp
  8003e9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f5:	50                   	push   %eax
  8003f6:	e8 c2 fc ff ff       	call   8000bd <sys_cputs>

	return b.cnt;
}
  8003fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800409:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 08             	pushl  0x8(%ebp)
  800410:	e8 9d ff ff ff       	call   8003b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	57                   	push   %edi
  80041b:	56                   	push   %esi
  80041c:	53                   	push   %ebx
  80041d:	83 ec 1c             	sub    $0x1c,%esp
  800420:	89 c7                	mov    %eax,%edi
  800422:	89 d6                	mov    %edx,%esi
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800430:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800433:	bb 00 00 00 00       	mov    $0x0,%ebx
  800438:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80043b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80043e:	39 d3                	cmp    %edx,%ebx
  800440:	72 05                	jb     800447 <printnum+0x30>
  800442:	39 45 10             	cmp    %eax,0x10(%ebp)
  800445:	77 7a                	ja     8004c1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	ff 75 18             	pushl  0x18(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800453:	53                   	push   %ebx
  800454:	ff 75 10             	pushl  0x10(%ebp)
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045d:	ff 75 e0             	pushl  -0x20(%ebp)
  800460:	ff 75 dc             	pushl  -0x24(%ebp)
  800463:	ff 75 d8             	pushl  -0x28(%ebp)
  800466:	e8 35 09 00 00       	call   800da0 <__udivdi3>
  80046b:	83 c4 18             	add    $0x18,%esp
  80046e:	52                   	push   %edx
  80046f:	50                   	push   %eax
  800470:	89 f2                	mov    %esi,%edx
  800472:	89 f8                	mov    %edi,%eax
  800474:	e8 9e ff ff ff       	call   800417 <printnum>
  800479:	83 c4 20             	add    $0x20,%esp
  80047c:	eb 13                	jmp    800491 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	56                   	push   %esi
  800482:	ff 75 18             	pushl  0x18(%ebp)
  800485:	ff d7                	call   *%edi
  800487:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80048a:	83 eb 01             	sub    $0x1,%ebx
  80048d:	85 db                	test   %ebx,%ebx
  80048f:	7f ed                	jg     80047e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	56                   	push   %esi
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049b:	ff 75 e0             	pushl  -0x20(%ebp)
  80049e:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a4:	e8 17 0a 00 00       	call   800ec0 <__umoddi3>
  8004a9:	83 c4 14             	add    $0x14,%esp
  8004ac:	0f be 80 3e 10 80 00 	movsbl 0x80103e(%eax),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff d7                	call   *%edi
}
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bc:	5b                   	pop    %ebx
  8004bd:	5e                   	pop    %esi
  8004be:	5f                   	pop    %edi
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    
  8004c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004c4:	eb c4                	jmp    80048a <printnum+0x73>

008004c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d0:	8b 10                	mov    (%eax),%edx
  8004d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d5:	73 0a                	jae    8004e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004da:	89 08                	mov    %ecx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	88 02                	mov    %al,(%edx)
}
  8004e1:	5d                   	pop    %ebp
  8004e2:	c3                   	ret    

008004e3 <printfmt>:
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ec:	50                   	push   %eax
  8004ed:	ff 75 10             	pushl  0x10(%ebp)
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	ff 75 08             	pushl  0x8(%ebp)
  8004f6:	e8 05 00 00 00       	call   800500 <vprintfmt>
}
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <vprintfmt>:
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	57                   	push   %edi
  800504:	56                   	push   %esi
  800505:	53                   	push   %ebx
  800506:	83 ec 2c             	sub    $0x2c,%esp
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800512:	e9 00 04 00 00       	jmp    800917 <vprintfmt+0x417>
		padc = ' ';
  800517:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80051b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800522:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800529:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800530:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8d 47 01             	lea    0x1(%edi),%eax
  800538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053b:	0f b6 17             	movzbl (%edi),%edx
  80053e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800541:	3c 55                	cmp    $0x55,%al
  800543:	0f 87 51 04 00 00    	ja     80099a <vprintfmt+0x49a>
  800549:	0f b6 c0             	movzbl %al,%eax
  80054c:	ff 24 85 00 11 80 00 	jmp    *0x801100(,%eax,4)
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800556:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80055a:	eb d9                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80055f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800563:	eb d0                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800565:	0f b6 d2             	movzbl %dl,%edx
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80056b:	b8 00 00 00 00       	mov    $0x0,%eax
  800570:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800573:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80057a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80057d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800580:	83 f9 09             	cmp    $0x9,%ecx
  800583:	77 55                	ja     8005da <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800585:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800588:	eb e9                	jmp    800573 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80059e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a2:	79 91                	jns    800535 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005b1:	eb 82                	jmp    800535 <vprintfmt+0x35>
  8005b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	0f 49 d0             	cmovns %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c6:	e9 6a ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005d5:	e9 5b ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e0:	eb bc                	jmp    80059e <vprintfmt+0x9e>
			lflag++;
  8005e2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e8:	e9 48 ff ff ff       	jmp    800535 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 78 04             	lea    0x4(%eax),%edi
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	ff 30                	pushl  (%eax)
  8005f9:	ff d6                	call   *%esi
			break;
  8005fb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005fe:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800601:	e9 0e 03 00 00       	jmp    800914 <vprintfmt+0x414>
			err = va_arg(ap, int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 78 04             	lea    0x4(%eax),%edi
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	99                   	cltd   
  80060f:	31 d0                	xor    %edx,%eax
  800611:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800613:	83 f8 08             	cmp    $0x8,%eax
  800616:	7f 23                	jg     80063b <vprintfmt+0x13b>
  800618:	8b 14 85 60 12 80 00 	mov    0x801260(,%eax,4),%edx
  80061f:	85 d2                	test   %edx,%edx
  800621:	74 18                	je     80063b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800623:	52                   	push   %edx
  800624:	68 5f 10 80 00       	push   $0x80105f
  800629:	53                   	push   %ebx
  80062a:	56                   	push   %esi
  80062b:	e8 b3 fe ff ff       	call   8004e3 <printfmt>
  800630:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800633:	89 7d 14             	mov    %edi,0x14(%ebp)
  800636:	e9 d9 02 00 00       	jmp    800914 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80063b:	50                   	push   %eax
  80063c:	68 56 10 80 00       	push   $0x801056
  800641:	53                   	push   %ebx
  800642:	56                   	push   %esi
  800643:	e8 9b fe ff ff       	call   8004e3 <printfmt>
  800648:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80064e:	e9 c1 02 00 00       	jmp    800914 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 c0 04             	add    $0x4,%eax
  800659:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800661:	85 ff                	test   %edi,%edi
  800663:	b8 4f 10 80 00       	mov    $0x80104f,%eax
  800668:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	0f 8e bd 00 00 00    	jle    800732 <vprintfmt+0x232>
  800675:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800679:	75 0e                	jne    800689 <vprintfmt+0x189>
  80067b:	89 75 08             	mov    %esi,0x8(%ebp)
  80067e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800681:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800684:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800687:	eb 6d                	jmp    8006f6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 d0             	pushl  -0x30(%ebp)
  80068f:	57                   	push   %edi
  800690:	e8 ad 03 00 00       	call   800a42 <strnlen>
  800695:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800698:	29 c1                	sub    %eax,%ecx
  80069a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80069d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006a0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006aa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	eb 0f                	jmp    8006bd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b7:	83 ef 01             	sub    $0x1,%edi
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	85 ff                	test   %edi,%edi
  8006bf:	7f ed                	jg     8006ae <vprintfmt+0x1ae>
  8006c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006c4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	0f 49 c1             	cmovns %ecx,%eax
  8006d1:	29 c1                	sub    %eax,%ecx
  8006d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006dc:	89 cb                	mov    %ecx,%ebx
  8006de:	eb 16                	jmp    8006f6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006e4:	75 31                	jne    800717 <vprintfmt+0x217>
					putch(ch, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	ff 55 08             	call   *0x8(%ebp)
  8006f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	83 eb 01             	sub    $0x1,%ebx
  8006f6:	83 c7 01             	add    $0x1,%edi
  8006f9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006fd:	0f be c2             	movsbl %dl,%eax
  800700:	85 c0                	test   %eax,%eax
  800702:	74 59                	je     80075d <vprintfmt+0x25d>
  800704:	85 f6                	test   %esi,%esi
  800706:	78 d8                	js     8006e0 <vprintfmt+0x1e0>
  800708:	83 ee 01             	sub    $0x1,%esi
  80070b:	79 d3                	jns    8006e0 <vprintfmt+0x1e0>
  80070d:	89 df                	mov    %ebx,%edi
  80070f:	8b 75 08             	mov    0x8(%ebp),%esi
  800712:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800715:	eb 37                	jmp    80074e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	0f be d2             	movsbl %dl,%edx
  80071a:	83 ea 20             	sub    $0x20,%edx
  80071d:	83 fa 5e             	cmp    $0x5e,%edx
  800720:	76 c4                	jbe    8006e6 <vprintfmt+0x1e6>
					putch('?', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 3f                	push   $0x3f
  80072a:	ff 55 08             	call   *0x8(%ebp)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb c1                	jmp    8006f3 <vprintfmt+0x1f3>
  800732:	89 75 08             	mov    %esi,0x8(%ebp)
  800735:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800738:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80073b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80073e:	eb b6                	jmp    8006f6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 20                	push   $0x20
  800746:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800748:	83 ef 01             	sub    $0x1,%edi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 ff                	test   %edi,%edi
  800750:	7f ee                	jg     800740 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	e9 b7 01 00 00       	jmp    800914 <vprintfmt+0x414>
  80075d:	89 df                	mov    %ebx,%edi
  80075f:	8b 75 08             	mov    0x8(%ebp),%esi
  800762:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800765:	eb e7                	jmp    80074e <vprintfmt+0x24e>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7e 3f                	jle    8007ab <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 50 04             	mov    0x4(%eax),%edx
  800772:	8b 00                	mov    (%eax),%eax
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 08             	lea    0x8(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800783:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800787:	79 5c                	jns    8007e5 <vprintfmt+0x2e5>
				putch('-', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 2d                	push   $0x2d
  80078f:	ff d6                	call   *%esi
				num = -(long long) num;
  800791:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800794:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800797:	f7 da                	neg    %edx
  800799:	83 d1 00             	adc    $0x0,%ecx
  80079c:	f7 d9                	neg    %ecx
  80079e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a6:	e9 4f 01 00 00       	jmp    8008fa <vprintfmt+0x3fa>
	else if (lflag)
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	75 1b                	jne    8007ca <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 c1                	mov    %eax,%ecx
  8007b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	eb b9                	jmp    800783 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 c1                	mov    %eax,%ecx
  8007d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb 9e                	jmp    800783 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	e9 05 01 00 00       	jmp    8008fa <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007f5:	83 f9 01             	cmp    $0x1,%ecx
  8007f8:	7e 18                	jle    800812 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 10                	mov    (%eax),%edx
  8007ff:	8b 48 04             	mov    0x4(%eax),%ecx
  800802:	8d 40 08             	lea    0x8(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	e9 e8 00 00 00       	jmp    8008fa <vprintfmt+0x3fa>
	else if (lflag)
  800812:	85 c9                	test   %ecx,%ecx
  800814:	75 1a                	jne    800830 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800826:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082b:	e9 ca 00 00 00       	jmp    8008fa <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 10                	mov    (%eax),%edx
  800835:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083a:	8d 40 04             	lea    0x4(%eax),%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800840:	b8 0a 00 00 00       	mov    $0xa,%eax
  800845:	e9 b0 00 00 00       	jmp    8008fa <vprintfmt+0x3fa>
	if (lflag >= 2)
  80084a:	83 f9 01             	cmp    $0x1,%ecx
  80084d:	7e 3c                	jle    80088b <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8b 50 04             	mov    0x4(%eax),%edx
  800855:	8b 00                	mov    (%eax),%eax
  800857:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8d 40 08             	lea    0x8(%eax),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800866:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80086a:	79 59                	jns    8008c5 <vprintfmt+0x3c5>
                putch('-', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	6a 2d                	push   $0x2d
  800872:	ff d6                	call   *%esi
                num = -(long long) num;
  800874:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800877:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80087a:	f7 da                	neg    %edx
  80087c:	83 d1 00             	adc    $0x0,%ecx
  80087f:	f7 d9                	neg    %ecx
  800881:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800884:	b8 08 00 00 00       	mov    $0x8,%eax
  800889:	eb 6f                	jmp    8008fa <vprintfmt+0x3fa>
	else if (lflag)
  80088b:	85 c9                	test   %ecx,%ecx
  80088d:	75 1b                	jne    8008aa <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800897:	89 c1                	mov    %eax,%ecx
  800899:	c1 f9 1f             	sar    $0x1f,%ecx
  80089c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8d 40 04             	lea    0x4(%eax),%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a8:	eb bc                	jmp    800866 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 c1                	mov    %eax,%ecx
  8008b4:	c1 f9 1f             	sar    $0x1f,%ecx
  8008b7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8d 40 04             	lea    0x4(%eax),%eax
  8008c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c3:	eb a1                	jmp    800866 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8008d0:	eb 28                	jmp    8008fa <vprintfmt+0x3fa>
			putch('0', putdat);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	53                   	push   %ebx
  8008d6:	6a 30                	push   $0x30
  8008d8:	ff d6                	call   *%esi
			putch('x', putdat);
  8008da:	83 c4 08             	add    $0x8,%esp
  8008dd:	53                   	push   %ebx
  8008de:	6a 78                	push   $0x78
  8008e0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8b 10                	mov    (%eax),%edx
  8008e7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008ec:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008ef:	8d 40 04             	lea    0x4(%eax),%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008fa:	83 ec 0c             	sub    $0xc,%esp
  8008fd:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800901:	57                   	push   %edi
  800902:	ff 75 e0             	pushl  -0x20(%ebp)
  800905:	50                   	push   %eax
  800906:	51                   	push   %ecx
  800907:	52                   	push   %edx
  800908:	89 da                	mov    %ebx,%edx
  80090a:	89 f0                	mov    %esi,%eax
  80090c:	e8 06 fb ff ff       	call   800417 <printnum>
			break;
  800911:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800914:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800917:	83 c7 01             	add    $0x1,%edi
  80091a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80091e:	83 f8 25             	cmp    $0x25,%eax
  800921:	0f 84 f0 fb ff ff    	je     800517 <vprintfmt+0x17>
			if (ch == '\0')
  800927:	85 c0                	test   %eax,%eax
  800929:	0f 84 8b 00 00 00    	je     8009ba <vprintfmt+0x4ba>
			putch(ch, putdat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	53                   	push   %ebx
  800933:	50                   	push   %eax
  800934:	ff d6                	call   *%esi
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	eb dc                	jmp    800917 <vprintfmt+0x417>
	if (lflag >= 2)
  80093b:	83 f9 01             	cmp    $0x1,%ecx
  80093e:	7e 15                	jle    800955 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	8b 10                	mov    (%eax),%edx
  800945:	8b 48 04             	mov    0x4(%eax),%ecx
  800948:	8d 40 08             	lea    0x8(%eax),%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094e:	b8 10 00 00 00       	mov    $0x10,%eax
  800953:	eb a5                	jmp    8008fa <vprintfmt+0x3fa>
	else if (lflag)
  800955:	85 c9                	test   %ecx,%ecx
  800957:	75 17                	jne    800970 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	8b 10                	mov    (%eax),%edx
  80095e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800963:	8d 40 04             	lea    0x4(%eax),%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800969:	b8 10 00 00 00       	mov    $0x10,%eax
  80096e:	eb 8a                	jmp    8008fa <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	8b 10                	mov    (%eax),%edx
  800975:	b9 00 00 00 00       	mov    $0x0,%ecx
  80097a:	8d 40 04             	lea    0x4(%eax),%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800980:	b8 10 00 00 00       	mov    $0x10,%eax
  800985:	e9 70 ff ff ff       	jmp    8008fa <vprintfmt+0x3fa>
			putch(ch, putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	53                   	push   %ebx
  80098e:	6a 25                	push   $0x25
  800990:	ff d6                	call   *%esi
			break;
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	e9 7a ff ff ff       	jmp    800914 <vprintfmt+0x414>
			putch('%', putdat);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	53                   	push   %ebx
  80099e:	6a 25                	push   $0x25
  8009a0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a2:	83 c4 10             	add    $0x10,%esp
  8009a5:	89 f8                	mov    %edi,%eax
  8009a7:	eb 03                	jmp    8009ac <vprintfmt+0x4ac>
  8009a9:	83 e8 01             	sub    $0x1,%eax
  8009ac:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009b0:	75 f7                	jne    8009a9 <vprintfmt+0x4a9>
  8009b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b5:	e9 5a ff ff ff       	jmp    800914 <vprintfmt+0x414>
}
  8009ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	5f                   	pop    %edi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009df:	85 c0                	test   %eax,%eax
  8009e1:	74 26                	je     800a09 <vsnprintf+0x47>
  8009e3:	85 d2                	test   %edx,%edx
  8009e5:	7e 22                	jle    800a09 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e7:	ff 75 14             	pushl  0x14(%ebp)
  8009ea:	ff 75 10             	pushl  0x10(%ebp)
  8009ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	68 c6 04 80 00       	push   $0x8004c6
  8009f6:	e8 05 fb ff ff       	call   800500 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a04:	83 c4 10             	add    $0x10,%esp
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    
		return -E_INVAL;
  800a09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a0e:	eb f7                	jmp    800a07 <vsnprintf+0x45>

00800a10 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a16:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a19:	50                   	push   %eax
  800a1a:	ff 75 10             	pushl  0x10(%ebp)
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	ff 75 08             	pushl  0x8(%ebp)
  800a23:	e8 9a ff ff ff       	call   8009c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
  800a35:	eb 03                	jmp    800a3a <strlen+0x10>
		n++;
  800a37:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a3a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a3e:	75 f7                	jne    800a37 <strlen+0xd>
	return n;
}
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a48:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	eb 03                	jmp    800a55 <strnlen+0x13>
		n++;
  800a52:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a55:	39 d0                	cmp    %edx,%eax
  800a57:	74 06                	je     800a5f <strnlen+0x1d>
  800a59:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a5d:	75 f3                	jne    800a52 <strnlen+0x10>
	return n;
}
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a6b:	89 c2                	mov    %eax,%edx
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a77:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7a:	84 db                	test   %bl,%bl
  800a7c:	75 ef                	jne    800a6d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a7e:	5b                   	pop    %ebx
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	53                   	push   %ebx
  800a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a88:	53                   	push   %ebx
  800a89:	e8 9c ff ff ff       	call   800a2a <strlen>
  800a8e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	01 d8                	add    %ebx,%eax
  800a96:	50                   	push   %eax
  800a97:	e8 c5 ff ff ff       	call   800a61 <strcpy>
	return dst;
}
  800a9c:	89 d8                	mov    %ebx,%eax
  800a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	8b 75 08             	mov    0x8(%ebp),%esi
  800aab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aae:	89 f3                	mov    %esi,%ebx
  800ab0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab3:	89 f2                	mov    %esi,%edx
  800ab5:	eb 0f                	jmp    800ac6 <strncpy+0x23>
		*dst++ = *src;
  800ab7:	83 c2 01             	add    $0x1,%edx
  800aba:	0f b6 01             	movzbl (%ecx),%eax
  800abd:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ac0:	80 39 01             	cmpb   $0x1,(%ecx)
  800ac3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ac6:	39 da                	cmp    %ebx,%edx
  800ac8:	75 ed                	jne    800ab7 <strncpy+0x14>
	}
	return ret;
}
  800aca:	89 f0                	mov    %esi,%eax
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
  800ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ade:	89 f0                	mov    %esi,%eax
  800ae0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae4:	85 c9                	test   %ecx,%ecx
  800ae6:	75 0b                	jne    800af3 <strlcpy+0x23>
  800ae8:	eb 17                	jmp    800b01 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aea:	83 c2 01             	add    $0x1,%edx
  800aed:	83 c0 01             	add    $0x1,%eax
  800af0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800af3:	39 d8                	cmp    %ebx,%eax
  800af5:	74 07                	je     800afe <strlcpy+0x2e>
  800af7:	0f b6 0a             	movzbl (%edx),%ecx
  800afa:	84 c9                	test   %cl,%cl
  800afc:	75 ec                	jne    800aea <strlcpy+0x1a>
		*dst = '\0';
  800afe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b01:	29 f0                	sub    %esi,%eax
}
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b10:	eb 06                	jmp    800b18 <strcmp+0x11>
		p++, q++;
  800b12:	83 c1 01             	add    $0x1,%ecx
  800b15:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b18:	0f b6 01             	movzbl (%ecx),%eax
  800b1b:	84 c0                	test   %al,%al
  800b1d:	74 04                	je     800b23 <strcmp+0x1c>
  800b1f:	3a 02                	cmp    (%edx),%al
  800b21:	74 ef                	je     800b12 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b23:	0f b6 c0             	movzbl %al,%eax
  800b26:	0f b6 12             	movzbl (%edx),%edx
  800b29:	29 d0                	sub    %edx,%eax
}
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	53                   	push   %ebx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 c3                	mov    %eax,%ebx
  800b39:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b3c:	eb 06                	jmp    800b44 <strncmp+0x17>
		n--, p++, q++;
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b44:	39 d8                	cmp    %ebx,%eax
  800b46:	74 16                	je     800b5e <strncmp+0x31>
  800b48:	0f b6 08             	movzbl (%eax),%ecx
  800b4b:	84 c9                	test   %cl,%cl
  800b4d:	74 04                	je     800b53 <strncmp+0x26>
  800b4f:	3a 0a                	cmp    (%edx),%cl
  800b51:	74 eb                	je     800b3e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b53:	0f b6 00             	movzbl (%eax),%eax
  800b56:	0f b6 12             	movzbl (%edx),%edx
  800b59:	29 d0                	sub    %edx,%eax
}
  800b5b:	5b                   	pop    %ebx
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    
		return 0;
  800b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b63:	eb f6                	jmp    800b5b <strncmp+0x2e>

00800b65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6f:	0f b6 10             	movzbl (%eax),%edx
  800b72:	84 d2                	test   %dl,%dl
  800b74:	74 09                	je     800b7f <strchr+0x1a>
		if (*s == c)
  800b76:	38 ca                	cmp    %cl,%dl
  800b78:	74 0a                	je     800b84 <strchr+0x1f>
	for (; *s; s++)
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	eb f0                	jmp    800b6f <strchr+0xa>
			return (char *) s;
	return 0;
  800b7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b90:	eb 03                	jmp    800b95 <strfind+0xf>
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b98:	38 ca                	cmp    %cl,%dl
  800b9a:	74 04                	je     800ba0 <strfind+0x1a>
  800b9c:	84 d2                	test   %dl,%dl
  800b9e:	75 f2                	jne    800b92 <strfind+0xc>
			break;
	return (char *) s;
}
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bae:	85 c9                	test   %ecx,%ecx
  800bb0:	74 13                	je     800bc5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb2:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bb8:	75 05                	jne    800bbf <memset+0x1d>
  800bba:	f6 c1 03             	test   $0x3,%cl
  800bbd:	74 0d                	je     800bcc <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	fc                   	cld    
  800bc3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bc5:	89 f8                	mov    %edi,%eax
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    
		c &= 0xFF;
  800bcc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bd0:	89 d3                	mov    %edx,%ebx
  800bd2:	c1 e3 08             	shl    $0x8,%ebx
  800bd5:	89 d0                	mov    %edx,%eax
  800bd7:	c1 e0 18             	shl    $0x18,%eax
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	c1 e6 10             	shl    $0x10,%esi
  800bdf:	09 f0                	or     %esi,%eax
  800be1:	09 c2                	or     %eax,%edx
  800be3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800be5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800be8:	89 d0                	mov    %edx,%eax
  800bea:	fc                   	cld    
  800beb:	f3 ab                	rep stos %eax,%es:(%edi)
  800bed:	eb d6                	jmp    800bc5 <memset+0x23>

00800bef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfd:	39 c6                	cmp    %eax,%esi
  800bff:	73 35                	jae    800c36 <memmove+0x47>
  800c01:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	76 2e                	jbe    800c36 <memmove+0x47>
		s += n;
		d += n;
  800c08:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0b:	89 d6                	mov    %edx,%esi
  800c0d:	09 fe                	or     %edi,%esi
  800c0f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c15:	74 0c                	je     800c23 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c17:	83 ef 01             	sub    $0x1,%edi
  800c1a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c1d:	fd                   	std    
  800c1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c20:	fc                   	cld    
  800c21:	eb 21                	jmp    800c44 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c23:	f6 c1 03             	test   $0x3,%cl
  800c26:	75 ef                	jne    800c17 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c28:	83 ef 04             	sub    $0x4,%edi
  800c2b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c31:	fd                   	std    
  800c32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c34:	eb ea                	jmp    800c20 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c36:	89 f2                	mov    %esi,%edx
  800c38:	09 c2                	or     %eax,%edx
  800c3a:	f6 c2 03             	test   $0x3,%dl
  800c3d:	74 09                	je     800c48 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	fc                   	cld    
  800c42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c48:	f6 c1 03             	test   $0x3,%cl
  800c4b:	75 f2                	jne    800c3f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c4d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c50:	89 c7                	mov    %eax,%edi
  800c52:	fc                   	cld    
  800c53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c55:	eb ed                	jmp    800c44 <memmove+0x55>

00800c57 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c5a:	ff 75 10             	pushl  0x10(%ebp)
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 87 ff ff ff       	call   800bef <memmove>
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c75:	89 c6                	mov    %eax,%esi
  800c77:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7a:	39 f0                	cmp    %esi,%eax
  800c7c:	74 1c                	je     800c9a <memcmp+0x30>
		if (*s1 != *s2)
  800c7e:	0f b6 08             	movzbl (%eax),%ecx
  800c81:	0f b6 1a             	movzbl (%edx),%ebx
  800c84:	38 d9                	cmp    %bl,%cl
  800c86:	75 08                	jne    800c90 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c88:	83 c0 01             	add    $0x1,%eax
  800c8b:	83 c2 01             	add    $0x1,%edx
  800c8e:	eb ea                	jmp    800c7a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c90:	0f b6 c1             	movzbl %cl,%eax
  800c93:	0f b6 db             	movzbl %bl,%ebx
  800c96:	29 d8                	sub    %ebx,%eax
  800c98:	eb 05                	jmp    800c9f <memcmp+0x35>
	}

	return 0;
  800c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cac:	89 c2                	mov    %eax,%edx
  800cae:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb1:	39 d0                	cmp    %edx,%eax
  800cb3:	73 09                	jae    800cbe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb5:	38 08                	cmp    %cl,(%eax)
  800cb7:	74 05                	je     800cbe <memfind+0x1b>
	for (; s < ends; s++)
  800cb9:	83 c0 01             	add    $0x1,%eax
  800cbc:	eb f3                	jmp    800cb1 <memfind+0xe>
			break;
	return (void *) s;
}
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccc:	eb 03                	jmp    800cd1 <strtol+0x11>
		s++;
  800cce:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd1:	0f b6 01             	movzbl (%ecx),%eax
  800cd4:	3c 20                	cmp    $0x20,%al
  800cd6:	74 f6                	je     800cce <strtol+0xe>
  800cd8:	3c 09                	cmp    $0x9,%al
  800cda:	74 f2                	je     800cce <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cdc:	3c 2b                	cmp    $0x2b,%al
  800cde:	74 2e                	je     800d0e <strtol+0x4e>
	int neg = 0;
  800ce0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce5:	3c 2d                	cmp    $0x2d,%al
  800ce7:	74 2f                	je     800d18 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cef:	75 05                	jne    800cf6 <strtol+0x36>
  800cf1:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf4:	74 2c                	je     800d22 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cf6:	85 db                	test   %ebx,%ebx
  800cf8:	75 0a                	jne    800d04 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfa:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cff:	80 39 30             	cmpb   $0x30,(%ecx)
  800d02:	74 28                	je     800d2c <strtol+0x6c>
		base = 10;
  800d04:	b8 00 00 00 00       	mov    $0x0,%eax
  800d09:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0c:	eb 50                	jmp    800d5e <strtol+0x9e>
		s++;
  800d0e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d11:	bf 00 00 00 00       	mov    $0x0,%edi
  800d16:	eb d1                	jmp    800ce9 <strtol+0x29>
		s++, neg = 1;
  800d18:	83 c1 01             	add    $0x1,%ecx
  800d1b:	bf 01 00 00 00       	mov    $0x1,%edi
  800d20:	eb c7                	jmp    800ce9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d22:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d26:	74 0e                	je     800d36 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d28:	85 db                	test   %ebx,%ebx
  800d2a:	75 d8                	jne    800d04 <strtol+0x44>
		s++, base = 8;
  800d2c:	83 c1 01             	add    $0x1,%ecx
  800d2f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d34:	eb ce                	jmp    800d04 <strtol+0x44>
		s += 2, base = 16;
  800d36:	83 c1 02             	add    $0x2,%ecx
  800d39:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d3e:	eb c4                	jmp    800d04 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d40:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d43:	89 f3                	mov    %esi,%ebx
  800d45:	80 fb 19             	cmp    $0x19,%bl
  800d48:	77 29                	ja     800d73 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d4a:	0f be d2             	movsbl %dl,%edx
  800d4d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d50:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d53:	7d 30                	jge    800d85 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d55:	83 c1 01             	add    $0x1,%ecx
  800d58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d5c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5e:	0f b6 11             	movzbl (%ecx),%edx
  800d61:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d64:	89 f3                	mov    %esi,%ebx
  800d66:	80 fb 09             	cmp    $0x9,%bl
  800d69:	77 d5                	ja     800d40 <strtol+0x80>
			dig = *s - '0';
  800d6b:	0f be d2             	movsbl %dl,%edx
  800d6e:	83 ea 30             	sub    $0x30,%edx
  800d71:	eb dd                	jmp    800d50 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d73:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d76:	89 f3                	mov    %esi,%ebx
  800d78:	80 fb 19             	cmp    $0x19,%bl
  800d7b:	77 08                	ja     800d85 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d7d:	0f be d2             	movsbl %dl,%edx
  800d80:	83 ea 37             	sub    $0x37,%edx
  800d83:	eb cb                	jmp    800d50 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d89:	74 05                	je     800d90 <strtol+0xd0>
		*endptr = (char *) s;
  800d8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	f7 da                	neg    %edx
  800d94:	85 ff                	test   %edi,%edi
  800d96:	0f 45 c2             	cmovne %edx,%eax
}
  800d99:	5b                   	pop    %ebx
  800d9a:	5e                   	pop    %esi
  800d9b:	5f                   	pop    %edi
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    
  800d9e:	66 90                	xchg   %ax,%ax

00800da0 <__udivdi3>:
  800da0:	55                   	push   %ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 1c             	sub    $0x1c,%esp
  800da7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800daf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800db3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800db7:	85 d2                	test   %edx,%edx
  800db9:	75 35                	jne    800df0 <__udivdi3+0x50>
  800dbb:	39 f3                	cmp    %esi,%ebx
  800dbd:	0f 87 bd 00 00 00    	ja     800e80 <__udivdi3+0xe0>
  800dc3:	85 db                	test   %ebx,%ebx
  800dc5:	89 d9                	mov    %ebx,%ecx
  800dc7:	75 0b                	jne    800dd4 <__udivdi3+0x34>
  800dc9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dce:	31 d2                	xor    %edx,%edx
  800dd0:	f7 f3                	div    %ebx
  800dd2:	89 c1                	mov    %eax,%ecx
  800dd4:	31 d2                	xor    %edx,%edx
  800dd6:	89 f0                	mov    %esi,%eax
  800dd8:	f7 f1                	div    %ecx
  800dda:	89 c6                	mov    %eax,%esi
  800ddc:	89 e8                	mov    %ebp,%eax
  800dde:	89 f7                	mov    %esi,%edi
  800de0:	f7 f1                	div    %ecx
  800de2:	89 fa                	mov    %edi,%edx
  800de4:	83 c4 1c             	add    $0x1c,%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
  800dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800df0:	39 f2                	cmp    %esi,%edx
  800df2:	77 7c                	ja     800e70 <__udivdi3+0xd0>
  800df4:	0f bd fa             	bsr    %edx,%edi
  800df7:	83 f7 1f             	xor    $0x1f,%edi
  800dfa:	0f 84 98 00 00 00    	je     800e98 <__udivdi3+0xf8>
  800e00:	89 f9                	mov    %edi,%ecx
  800e02:	b8 20 00 00 00       	mov    $0x20,%eax
  800e07:	29 f8                	sub    %edi,%eax
  800e09:	d3 e2                	shl    %cl,%edx
  800e0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e0f:	89 c1                	mov    %eax,%ecx
  800e11:	89 da                	mov    %ebx,%edx
  800e13:	d3 ea                	shr    %cl,%edx
  800e15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e19:	09 d1                	or     %edx,%ecx
  800e1b:	89 f2                	mov    %esi,%edx
  800e1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e21:	89 f9                	mov    %edi,%ecx
  800e23:	d3 e3                	shl    %cl,%ebx
  800e25:	89 c1                	mov    %eax,%ecx
  800e27:	d3 ea                	shr    %cl,%edx
  800e29:	89 f9                	mov    %edi,%ecx
  800e2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e2f:	d3 e6                	shl    %cl,%esi
  800e31:	89 eb                	mov    %ebp,%ebx
  800e33:	89 c1                	mov    %eax,%ecx
  800e35:	d3 eb                	shr    %cl,%ebx
  800e37:	09 de                	or     %ebx,%esi
  800e39:	89 f0                	mov    %esi,%eax
  800e3b:	f7 74 24 08          	divl   0x8(%esp)
  800e3f:	89 d6                	mov    %edx,%esi
  800e41:	89 c3                	mov    %eax,%ebx
  800e43:	f7 64 24 0c          	mull   0xc(%esp)
  800e47:	39 d6                	cmp    %edx,%esi
  800e49:	72 0c                	jb     800e57 <__udivdi3+0xb7>
  800e4b:	89 f9                	mov    %edi,%ecx
  800e4d:	d3 e5                	shl    %cl,%ebp
  800e4f:	39 c5                	cmp    %eax,%ebp
  800e51:	73 5d                	jae    800eb0 <__udivdi3+0x110>
  800e53:	39 d6                	cmp    %edx,%esi
  800e55:	75 59                	jne    800eb0 <__udivdi3+0x110>
  800e57:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e5a:	31 ff                	xor    %edi,%edi
  800e5c:	89 fa                	mov    %edi,%edx
  800e5e:	83 c4 1c             	add    $0x1c,%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
  800e66:	8d 76 00             	lea    0x0(%esi),%esi
  800e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e70:	31 ff                	xor    %edi,%edi
  800e72:	31 c0                	xor    %eax,%eax
  800e74:	89 fa                	mov    %edi,%edx
  800e76:	83 c4 1c             	add    $0x1c,%esp
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    
  800e7e:	66 90                	xchg   %ax,%ax
  800e80:	31 ff                	xor    %edi,%edi
  800e82:	89 e8                	mov    %ebp,%eax
  800e84:	89 f2                	mov    %esi,%edx
  800e86:	f7 f3                	div    %ebx
  800e88:	89 fa                	mov    %edi,%edx
  800e8a:	83 c4 1c             	add    $0x1c,%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    
  800e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e98:	39 f2                	cmp    %esi,%edx
  800e9a:	72 06                	jb     800ea2 <__udivdi3+0x102>
  800e9c:	31 c0                	xor    %eax,%eax
  800e9e:	39 eb                	cmp    %ebp,%ebx
  800ea0:	77 d2                	ja     800e74 <__udivdi3+0xd4>
  800ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea7:	eb cb                	jmp    800e74 <__udivdi3+0xd4>
  800ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800eb0:	89 d8                	mov    %ebx,%eax
  800eb2:	31 ff                	xor    %edi,%edi
  800eb4:	eb be                	jmp    800e74 <__udivdi3+0xd4>
  800eb6:	66 90                	xchg   %ax,%ax
  800eb8:	66 90                	xchg   %ax,%ax
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

00800ec0 <__umoddi3>:
  800ec0:	55                   	push   %ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 1c             	sub    $0x1c,%esp
  800ec7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800ecb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ecf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ed3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ed7:	85 ed                	test   %ebp,%ebp
  800ed9:	89 f0                	mov    %esi,%eax
  800edb:	89 da                	mov    %ebx,%edx
  800edd:	75 19                	jne    800ef8 <__umoddi3+0x38>
  800edf:	39 df                	cmp    %ebx,%edi
  800ee1:	0f 86 b1 00 00 00    	jbe    800f98 <__umoddi3+0xd8>
  800ee7:	f7 f7                	div    %edi
  800ee9:	89 d0                	mov    %edx,%eax
  800eeb:	31 d2                	xor    %edx,%edx
  800eed:	83 c4 1c             	add    $0x1c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
  800ef5:	8d 76 00             	lea    0x0(%esi),%esi
  800ef8:	39 dd                	cmp    %ebx,%ebp
  800efa:	77 f1                	ja     800eed <__umoddi3+0x2d>
  800efc:	0f bd cd             	bsr    %ebp,%ecx
  800eff:	83 f1 1f             	xor    $0x1f,%ecx
  800f02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f06:	0f 84 b4 00 00 00    	je     800fc0 <__umoddi3+0x100>
  800f0c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f11:	89 c2                	mov    %eax,%edx
  800f13:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f17:	29 c2                	sub    %eax,%edx
  800f19:	89 c1                	mov    %eax,%ecx
  800f1b:	89 f8                	mov    %edi,%eax
  800f1d:	d3 e5                	shl    %cl,%ebp
  800f1f:	89 d1                	mov    %edx,%ecx
  800f21:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f25:	d3 e8                	shr    %cl,%eax
  800f27:	09 c5                	or     %eax,%ebp
  800f29:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f2d:	89 c1                	mov    %eax,%ecx
  800f2f:	d3 e7                	shl    %cl,%edi
  800f31:	89 d1                	mov    %edx,%ecx
  800f33:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	d3 ef                	shr    %cl,%edi
  800f3b:	89 c1                	mov    %eax,%ecx
  800f3d:	89 f0                	mov    %esi,%eax
  800f3f:	d3 e3                	shl    %cl,%ebx
  800f41:	89 d1                	mov    %edx,%ecx
  800f43:	89 fa                	mov    %edi,%edx
  800f45:	d3 e8                	shr    %cl,%eax
  800f47:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f4c:	09 d8                	or     %ebx,%eax
  800f4e:	f7 f5                	div    %ebp
  800f50:	d3 e6                	shl    %cl,%esi
  800f52:	89 d1                	mov    %edx,%ecx
  800f54:	f7 64 24 08          	mull   0x8(%esp)
  800f58:	39 d1                	cmp    %edx,%ecx
  800f5a:	89 c3                	mov    %eax,%ebx
  800f5c:	89 d7                	mov    %edx,%edi
  800f5e:	72 06                	jb     800f66 <__umoddi3+0xa6>
  800f60:	75 0e                	jne    800f70 <__umoddi3+0xb0>
  800f62:	39 c6                	cmp    %eax,%esi
  800f64:	73 0a                	jae    800f70 <__umoddi3+0xb0>
  800f66:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f6a:	19 ea                	sbb    %ebp,%edx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	89 c3                	mov    %eax,%ebx
  800f70:	89 ca                	mov    %ecx,%edx
  800f72:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f77:	29 de                	sub    %ebx,%esi
  800f79:	19 fa                	sbb    %edi,%edx
  800f7b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f7f:	89 d0                	mov    %edx,%eax
  800f81:	d3 e0                	shl    %cl,%eax
  800f83:	89 d9                	mov    %ebx,%ecx
  800f85:	d3 ee                	shr    %cl,%esi
  800f87:	d3 ea                	shr    %cl,%edx
  800f89:	09 f0                	or     %esi,%eax
  800f8b:	83 c4 1c             	add    $0x1c,%esp
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    
  800f93:	90                   	nop
  800f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f98:	85 ff                	test   %edi,%edi
  800f9a:	89 f9                	mov    %edi,%ecx
  800f9c:	75 0b                	jne    800fa9 <__umoddi3+0xe9>
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa3:	31 d2                	xor    %edx,%edx
  800fa5:	f7 f7                	div    %edi
  800fa7:	89 c1                	mov    %eax,%ecx
  800fa9:	89 d8                	mov    %ebx,%eax
  800fab:	31 d2                	xor    %edx,%edx
  800fad:	f7 f1                	div    %ecx
  800faf:	89 f0                	mov    %esi,%eax
  800fb1:	f7 f1                	div    %ecx
  800fb3:	e9 31 ff ff ff       	jmp    800ee9 <__umoddi3+0x29>
  800fb8:	90                   	nop
  800fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc0:	39 dd                	cmp    %ebx,%ebp
  800fc2:	72 08                	jb     800fcc <__umoddi3+0x10c>
  800fc4:	39 f7                	cmp    %esi,%edi
  800fc6:	0f 87 21 ff ff ff    	ja     800eed <__umoddi3+0x2d>
  800fcc:	89 da                	mov    %ebx,%edx
  800fce:	89 f0                	mov    %esi,%eax
  800fd0:	29 f8                	sub    %edi,%eax
  800fd2:	19 ea                	sbb    %ebp,%edx
  800fd4:	e9 14 ff ff ff       	jmp    800eed <__umoddi3+0x2d>
