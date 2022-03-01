
obj/user/idle：     文件格式 elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 20 80 00 e0 	movl   $0x800fe0,0x802000
  800040:	0f 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 f7 00 00 00       	call   80013f <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 c6 00 00 00       	call   800120 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x2d>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void) {
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 ef 0f 80 00       	push   $0x800fef
  800114:	6a 24                	push   $0x24
  800116:	68 0c 10 80 00       	push   $0x80100c
  80011b:	e8 ed 01 00 00       	call   80030d <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
    asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
    asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 ef 0f 80 00       	push   $0x800fef
  800195:	6a 24                	push   $0x24
  800197:	68 0c 10 80 00       	push   $0x80100c
  80019c:	e8 6c 01 00 00       	call   80030d <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 ef 0f 80 00       	push   $0x800fef
  8001d7:	6a 24                	push   $0x24
  8001d9:	68 0c 10 80 00       	push   $0x80100c
  8001de:	e8 2a 01 00 00       	call   80030d <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
    if (check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 ef 0f 80 00       	push   $0x800fef
  800219:	6a 24                	push   $0x24
  80021b:	68 0c 10 80 00       	push   $0x80100c
  800220:	e8 e8 00 00 00       	call   80030d <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
    if (check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 ef 0f 80 00       	push   $0x800fef
  80025b:	6a 24                	push   $0x24
  80025d:	68 0c 10 80 00       	push   $0x80100c
  800262:	e8 a6 00 00 00       	call   80030d <_panic>

00800267 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
    if (check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 ef 0f 80 00       	push   $0x800fef
  80029d:	6a 24                	push   $0x24
  80029f:	68 0c 10 80 00       	push   $0x80100c
  8002a4:	e8 64 00 00 00       	call   80030d <_panic>

008002a9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002ba:	be 00 00 00 00       	mov    $0x0,%esi
  8002bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002c5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    

008002cc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
  8002d2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002da:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dd:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002e2:	89 cb                	mov    %ecx,%ebx
  8002e4:	89 cf                	mov    %ecx,%edi
  8002e6:	89 ce                	mov    %ecx,%esi
  8002e8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	7f 08                	jg     8002f6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f1:	5b                   	pop    %ebx
  8002f2:	5e                   	pop    %esi
  8002f3:	5f                   	pop    %edi
  8002f4:	5d                   	pop    %ebp
  8002f5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	50                   	push   %eax
  8002fa:	6a 0c                	push   $0xc
  8002fc:	68 ef 0f 80 00       	push   $0x800fef
  800301:	6a 24                	push   $0x24
  800303:	68 0c 10 80 00       	push   $0x80100c
  800308:	e8 00 00 00 00       	call   80030d <_panic>

0080030d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800312:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800315:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80031b:	e8 00 fe ff ff       	call   800120 <sys_getenvid>
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	56                   	push   %esi
  80032a:	50                   	push   %eax
  80032b:	68 1c 10 80 00       	push   $0x80101c
  800330:	e8 b3 00 00 00       	call   8003e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800335:	83 c4 18             	add    $0x18,%esp
  800338:	53                   	push   %ebx
  800339:	ff 75 10             	pushl  0x10(%ebp)
  80033c:	e8 56 00 00 00       	call   800397 <vcprintf>
	cprintf("\n");
  800341:	c7 04 24 40 10 80 00 	movl   $0x801040,(%esp)
  800348:	e8 9b 00 00 00       	call   8003e8 <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800350:	cc                   	int3   
  800351:	eb fd                	jmp    800350 <_panic+0x43>

00800353 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	53                   	push   %ebx
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80035d:	8b 13                	mov    (%ebx),%edx
  80035f:	8d 42 01             	lea    0x1(%edx),%eax
  800362:	89 03                	mov    %eax,(%ebx)
  800364:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800367:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80036b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800370:	74 09                	je     80037b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800372:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800379:	c9                   	leave  
  80037a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	68 ff 00 00 00       	push   $0xff
  800383:	8d 43 08             	lea    0x8(%ebx),%eax
  800386:	50                   	push   %eax
  800387:	e8 16 fd ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  80038c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	eb db                	jmp    800372 <putch+0x1f>

00800397 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a7:	00 00 00 
	b.cnt = 0;
  8003aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b4:	ff 75 0c             	pushl  0xc(%ebp)
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	68 53 03 80 00       	push   $0x800353
  8003c6:	e8 1a 01 00 00       	call   8004e5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003cb:	83 c4 08             	add    $0x8,%esp
  8003ce:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003da:	50                   	push   %eax
  8003db:	e8 c2 fc ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  8003e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003e6:	c9                   	leave  
  8003e7:	c3                   	ret    

008003e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ee:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 08             	pushl  0x8(%ebp)
  8003f5:	e8 9d ff ff ff       	call   800397 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	57                   	push   %edi
  800400:	56                   	push   %esi
  800401:	53                   	push   %ebx
  800402:	83 ec 1c             	sub    $0x1c,%esp
  800405:	89 c7                	mov    %eax,%edi
  800407:	89 d6                	mov    %edx,%esi
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800412:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800415:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800418:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800420:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800423:	39 d3                	cmp    %edx,%ebx
  800425:	72 05                	jb     80042c <printnum+0x30>
  800427:	39 45 10             	cmp    %eax,0x10(%ebp)
  80042a:	77 7a                	ja     8004a6 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	ff 75 18             	pushl  0x18(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800438:	53                   	push   %ebx
  800439:	ff 75 10             	pushl  0x10(%ebp)
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800442:	ff 75 e0             	pushl  -0x20(%ebp)
  800445:	ff 75 dc             	pushl  -0x24(%ebp)
  800448:	ff 75 d8             	pushl  -0x28(%ebp)
  80044b:	e8 40 09 00 00       	call   800d90 <__udivdi3>
  800450:	83 c4 18             	add    $0x18,%esp
  800453:	52                   	push   %edx
  800454:	50                   	push   %eax
  800455:	89 f2                	mov    %esi,%edx
  800457:	89 f8                	mov    %edi,%eax
  800459:	e8 9e ff ff ff       	call   8003fc <printnum>
  80045e:	83 c4 20             	add    $0x20,%esp
  800461:	eb 13                	jmp    800476 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	56                   	push   %esi
  800467:	ff 75 18             	pushl  0x18(%ebp)
  80046a:	ff d7                	call   *%edi
  80046c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80046f:	83 eb 01             	sub    $0x1,%ebx
  800472:	85 db                	test   %ebx,%ebx
  800474:	7f ed                	jg     800463 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	56                   	push   %esi
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800480:	ff 75 e0             	pushl  -0x20(%ebp)
  800483:	ff 75 dc             	pushl  -0x24(%ebp)
  800486:	ff 75 d8             	pushl  -0x28(%ebp)
  800489:	e8 22 0a 00 00       	call   800eb0 <__umoddi3>
  80048e:	83 c4 14             	add    $0x14,%esp
  800491:	0f be 80 42 10 80 00 	movsbl 0x801042(%eax),%eax
  800498:	50                   	push   %eax
  800499:	ff d7                	call   *%edi
}
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a1:	5b                   	pop    %ebx
  8004a2:	5e                   	pop    %esi
  8004a3:	5f                   	pop    %edi
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    
  8004a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004a9:	eb c4                	jmp    80046f <printnum+0x73>

008004ab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004b1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004b5:	8b 10                	mov    (%eax),%edx
  8004b7:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ba:	73 0a                	jae    8004c6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004bf:	89 08                	mov    %ecx,(%eax)
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	88 02                	mov    %al,(%edx)
}
  8004c6:	5d                   	pop    %ebp
  8004c7:	c3                   	ret    

008004c8 <printfmt>:
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ce:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 10             	pushl  0x10(%ebp)
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	e8 05 00 00 00       	call   8004e5 <vprintfmt>
}
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	c9                   	leave  
  8004e4:	c3                   	ret    

008004e5 <vprintfmt>:
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	57                   	push   %edi
  8004e9:	56                   	push   %esi
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 2c             	sub    $0x2c,%esp
  8004ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004f7:	e9 00 04 00 00       	jmp    8008fc <vprintfmt+0x417>
		padc = ' ';
  8004fc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800500:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800507:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80050e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800515:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8d 47 01             	lea    0x1(%edi),%eax
  80051d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800520:	0f b6 17             	movzbl (%edi),%edx
  800523:	8d 42 dd             	lea    -0x23(%edx),%eax
  800526:	3c 55                	cmp    $0x55,%al
  800528:	0f 87 51 04 00 00    	ja     80097f <vprintfmt+0x49a>
  80052e:	0f b6 c0             	movzbl %al,%eax
  800531:	ff 24 85 00 11 80 00 	jmp    *0x801100(,%eax,4)
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80053b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80053f:	eb d9                	jmp    80051a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800541:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800544:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800548:	eb d0                	jmp    80051a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	0f b6 d2             	movzbl %dl,%edx
  80054d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800550:	b8 00 00 00 00       	mov    $0x0,%eax
  800555:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800558:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80055b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80055f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800562:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800565:	83 f9 09             	cmp    $0x9,%ecx
  800568:	77 55                	ja     8005bf <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80056a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80056d:	eb e9                	jmp    800558 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8d 40 04             	lea    0x4(%eax),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800583:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800587:	79 91                	jns    80051a <vprintfmt+0x35>
				width = precision, precision = -1;
  800589:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80058c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80058f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800596:	eb 82                	jmp    80051a <vprintfmt+0x35>
  800598:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059b:	85 c0                	test   %eax,%eax
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	0f 49 d0             	cmovns %eax,%edx
  8005a5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ab:	e9 6a ff ff ff       	jmp    80051a <vprintfmt+0x35>
  8005b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005b3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005ba:	e9 5b ff ff ff       	jmp    80051a <vprintfmt+0x35>
  8005bf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c5:	eb bc                	jmp    800583 <vprintfmt+0x9e>
			lflag++;
  8005c7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005cd:	e9 48 ff ff ff       	jmp    80051a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8d 78 04             	lea    0x4(%eax),%edi
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	ff 30                	pushl  (%eax)
  8005de:	ff d6                	call   *%esi
			break;
  8005e0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005e3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005e6:	e9 0e 03 00 00       	jmp    8008f9 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 78 04             	lea    0x4(%eax),%edi
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	99                   	cltd   
  8005f4:	31 d0                	xor    %edx,%eax
  8005f6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005f8:	83 f8 08             	cmp    $0x8,%eax
  8005fb:	7f 23                	jg     800620 <vprintfmt+0x13b>
  8005fd:	8b 14 85 60 12 80 00 	mov    0x801260(,%eax,4),%edx
  800604:	85 d2                	test   %edx,%edx
  800606:	74 18                	je     800620 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800608:	52                   	push   %edx
  800609:	68 63 10 80 00       	push   $0x801063
  80060e:	53                   	push   %ebx
  80060f:	56                   	push   %esi
  800610:	e8 b3 fe ff ff       	call   8004c8 <printfmt>
  800615:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800618:	89 7d 14             	mov    %edi,0x14(%ebp)
  80061b:	e9 d9 02 00 00       	jmp    8008f9 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800620:	50                   	push   %eax
  800621:	68 5a 10 80 00       	push   $0x80105a
  800626:	53                   	push   %ebx
  800627:	56                   	push   %esi
  800628:	e8 9b fe ff ff       	call   8004c8 <printfmt>
  80062d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800630:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800633:	e9 c1 02 00 00       	jmp    8008f9 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	83 c0 04             	add    $0x4,%eax
  80063e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800646:	85 ff                	test   %edi,%edi
  800648:	b8 53 10 80 00       	mov    $0x801053,%eax
  80064d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800650:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800654:	0f 8e bd 00 00 00    	jle    800717 <vprintfmt+0x232>
  80065a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80065e:	75 0e                	jne    80066e <vprintfmt+0x189>
  800660:	89 75 08             	mov    %esi,0x8(%ebp)
  800663:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800666:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800669:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80066c:	eb 6d                	jmp    8006db <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	ff 75 d0             	pushl  -0x30(%ebp)
  800674:	57                   	push   %edi
  800675:	e8 ad 03 00 00       	call   800a27 <strnlen>
  80067a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80067d:	29 c1                	sub    %eax,%ecx
  80067f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800682:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800685:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800689:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80068c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80068f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800691:	eb 0f                	jmp    8006a2 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	53                   	push   %ebx
  800697:	ff 75 e0             	pushl  -0x20(%ebp)
  80069a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80069c:	83 ef 01             	sub    $0x1,%edi
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	85 ff                	test   %edi,%edi
  8006a4:	7f ed                	jg     800693 <vprintfmt+0x1ae>
  8006a6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006a9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006ac:	85 c9                	test   %ecx,%ecx
  8006ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b3:	0f 49 c1             	cmovns %ecx,%eax
  8006b6:	29 c1                	sub    %eax,%ecx
  8006b8:	89 75 08             	mov    %esi,0x8(%ebp)
  8006bb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006c1:	89 cb                	mov    %ecx,%ebx
  8006c3:	eb 16                	jmp    8006db <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c9:	75 31                	jne    8006fc <vprintfmt+0x217>
					putch(ch, putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	50                   	push   %eax
  8006d2:	ff 55 08             	call   *0x8(%ebp)
  8006d5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d8:	83 eb 01             	sub    $0x1,%ebx
  8006db:	83 c7 01             	add    $0x1,%edi
  8006de:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006e2:	0f be c2             	movsbl %dl,%eax
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	74 59                	je     800742 <vprintfmt+0x25d>
  8006e9:	85 f6                	test   %esi,%esi
  8006eb:	78 d8                	js     8006c5 <vprintfmt+0x1e0>
  8006ed:	83 ee 01             	sub    $0x1,%esi
  8006f0:	79 d3                	jns    8006c5 <vprintfmt+0x1e0>
  8006f2:	89 df                	mov    %ebx,%edi
  8006f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006fa:	eb 37                	jmp    800733 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fc:	0f be d2             	movsbl %dl,%edx
  8006ff:	83 ea 20             	sub    $0x20,%edx
  800702:	83 fa 5e             	cmp    $0x5e,%edx
  800705:	76 c4                	jbe    8006cb <vprintfmt+0x1e6>
					putch('?', putdat);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	6a 3f                	push   $0x3f
  80070f:	ff 55 08             	call   *0x8(%ebp)
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	eb c1                	jmp    8006d8 <vprintfmt+0x1f3>
  800717:	89 75 08             	mov    %esi,0x8(%ebp)
  80071a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80071d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800720:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800723:	eb b6                	jmp    8006db <vprintfmt+0x1f6>
				putch(' ', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	6a 20                	push   $0x20
  80072b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072d:	83 ef 01             	sub    $0x1,%edi
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	85 ff                	test   %edi,%edi
  800735:	7f ee                	jg     800725 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800737:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
  80073d:	e9 b7 01 00 00       	jmp    8008f9 <vprintfmt+0x414>
  800742:	89 df                	mov    %ebx,%edi
  800744:	8b 75 08             	mov    0x8(%ebp),%esi
  800747:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80074a:	eb e7                	jmp    800733 <vprintfmt+0x24e>
	if (lflag >= 2)
  80074c:	83 f9 01             	cmp    $0x1,%ecx
  80074f:	7e 3f                	jle    800790 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 08             	lea    0x8(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800768:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80076c:	79 5c                	jns    8007ca <vprintfmt+0x2e5>
				putch('-', putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	53                   	push   %ebx
  800772:	6a 2d                	push   $0x2d
  800774:	ff d6                	call   *%esi
				num = -(long long) num;
  800776:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800779:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80077c:	f7 da                	neg    %edx
  80077e:	83 d1 00             	adc    $0x0,%ecx
  800781:	f7 d9                	neg    %ecx
  800783:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800786:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078b:	e9 4f 01 00 00       	jmp    8008df <vprintfmt+0x3fa>
	else if (lflag)
  800790:	85 c9                	test   %ecx,%ecx
  800792:	75 1b                	jne    8007af <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079c:	89 c1                	mov    %eax,%ecx
  80079e:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ad:	eb b9                	jmp    800768 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 c1                	mov    %eax,%ecx
  8007b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	eb 9e                	jmp    800768 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d5:	e9 05 01 00 00       	jmp    8008df <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007da:	83 f9 01             	cmp    $0x1,%ecx
  8007dd:	7e 18                	jle    8007f7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 10                	mov    (%eax),%edx
  8007e4:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e7:	8d 40 08             	lea    0x8(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f2:	e9 e8 00 00 00       	jmp    8008df <vprintfmt+0x3fa>
	else if (lflag)
  8007f7:	85 c9                	test   %ecx,%ecx
  8007f9:	75 1a                	jne    800815 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8b 10                	mov    (%eax),%edx
  800800:	b9 00 00 00 00       	mov    $0x0,%ecx
  800805:	8d 40 04             	lea    0x4(%eax),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800810:	e9 ca 00 00 00       	jmp    8008df <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 10                	mov    (%eax),%edx
  80081a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800825:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082a:	e9 b0 00 00 00       	jmp    8008df <vprintfmt+0x3fa>
	if (lflag >= 2)
  80082f:	83 f9 01             	cmp    $0x1,%ecx
  800832:	7e 3c                	jle    800870 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 50 04             	mov    0x4(%eax),%edx
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8d 40 08             	lea    0x8(%eax),%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80084b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80084f:	79 59                	jns    8008aa <vprintfmt+0x3c5>
                putch('-', putdat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	53                   	push   %ebx
  800855:	6a 2d                	push   $0x2d
  800857:	ff d6                	call   *%esi
                num = -(long long) num;
  800859:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80085c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80085f:	f7 da                	neg    %edx
  800861:	83 d1 00             	adc    $0x0,%ecx
  800864:	f7 d9                	neg    %ecx
  800866:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800869:	b8 08 00 00 00       	mov    $0x8,%eax
  80086e:	eb 6f                	jmp    8008df <vprintfmt+0x3fa>
	else if (lflag)
  800870:	85 c9                	test   %ecx,%ecx
  800872:	75 1b                	jne    80088f <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 c1                	mov    %eax,%ecx
  80087e:	c1 f9 1f             	sar    $0x1f,%ecx
  800881:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 40 04             	lea    0x4(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	eb bc                	jmp    80084b <vprintfmt+0x366>
		return va_arg(*ap, long);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800897:	89 c1                	mov    %eax,%ecx
  800899:	c1 f9 1f             	sar    $0x1f,%ecx
  80089c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8d 40 04             	lea    0x4(%eax),%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a8:	eb a1                	jmp    80084b <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b5:	eb 28                	jmp    8008df <vprintfmt+0x3fa>
			putch('0', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 30                	push   $0x30
  8008bd:	ff d6                	call   *%esi
			putch('x', putdat);
  8008bf:	83 c4 08             	add    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	6a 78                	push   $0x78
  8008c5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8b 10                	mov    (%eax),%edx
  8008cc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008d1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008d4:	8d 40 04             	lea    0x4(%eax),%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008da:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008df:	83 ec 0c             	sub    $0xc,%esp
  8008e2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008e6:	57                   	push   %edi
  8008e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	51                   	push   %ecx
  8008ec:	52                   	push   %edx
  8008ed:	89 da                	mov    %ebx,%edx
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	e8 06 fb ff ff       	call   8003fc <printnum>
			break;
  8008f6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fc:	83 c7 01             	add    $0x1,%edi
  8008ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800903:	83 f8 25             	cmp    $0x25,%eax
  800906:	0f 84 f0 fb ff ff    	je     8004fc <vprintfmt+0x17>
			if (ch == '\0')
  80090c:	85 c0                	test   %eax,%eax
  80090e:	0f 84 8b 00 00 00    	je     80099f <vprintfmt+0x4ba>
			putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	50                   	push   %eax
  800919:	ff d6                	call   *%esi
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	eb dc                	jmp    8008fc <vprintfmt+0x417>
	if (lflag >= 2)
  800920:	83 f9 01             	cmp    $0x1,%ecx
  800923:	7e 15                	jle    80093a <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8b 10                	mov    (%eax),%edx
  80092a:	8b 48 04             	mov    0x4(%eax),%ecx
  80092d:	8d 40 08             	lea    0x8(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	b8 10 00 00 00       	mov    $0x10,%eax
  800938:	eb a5                	jmp    8008df <vprintfmt+0x3fa>
	else if (lflag)
  80093a:	85 c9                	test   %ecx,%ecx
  80093c:	75 17                	jne    800955 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8b 10                	mov    (%eax),%edx
  800943:	b9 00 00 00 00       	mov    $0x0,%ecx
  800948:	8d 40 04             	lea    0x4(%eax),%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094e:	b8 10 00 00 00       	mov    $0x10,%eax
  800953:	eb 8a                	jmp    8008df <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 10                	mov    (%eax),%edx
  80095a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095f:	8d 40 04             	lea    0x4(%eax),%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800965:	b8 10 00 00 00       	mov    $0x10,%eax
  80096a:	e9 70 ff ff ff       	jmp    8008df <vprintfmt+0x3fa>
			putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	53                   	push   %ebx
  800973:	6a 25                	push   $0x25
  800975:	ff d6                	call   *%esi
			break;
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	e9 7a ff ff ff       	jmp    8008f9 <vprintfmt+0x414>
			putch('%', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 25                	push   $0x25
  800985:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 f8                	mov    %edi,%eax
  80098c:	eb 03                	jmp    800991 <vprintfmt+0x4ac>
  80098e:	83 e8 01             	sub    $0x1,%eax
  800991:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800995:	75 f7                	jne    80098e <vprintfmt+0x4a9>
  800997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099a:	e9 5a ff ff ff       	jmp    8008f9 <vprintfmt+0x414>
}
  80099f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a2:	5b                   	pop    %ebx
  8009a3:	5e                   	pop    %esi
  8009a4:	5f                   	pop    %edi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 18             	sub    $0x18,%esp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c4:	85 c0                	test   %eax,%eax
  8009c6:	74 26                	je     8009ee <vsnprintf+0x47>
  8009c8:	85 d2                	test   %edx,%edx
  8009ca:	7e 22                	jle    8009ee <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009cc:	ff 75 14             	pushl  0x14(%ebp)
  8009cf:	ff 75 10             	pushl  0x10(%ebp)
  8009d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d5:	50                   	push   %eax
  8009d6:	68 ab 04 80 00       	push   $0x8004ab
  8009db:	e8 05 fb ff ff       	call   8004e5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    
		return -E_INVAL;
  8009ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f3:	eb f7                	jmp    8009ec <vsnprintf+0x45>

008009f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009fe:	50                   	push   %eax
  8009ff:	ff 75 10             	pushl  0x10(%ebp)
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	ff 75 08             	pushl  0x8(%ebp)
  800a08:	e8 9a ff ff ff       	call   8009a7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	eb 03                	jmp    800a1f <strlen+0x10>
		n++;
  800a1c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a1f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a23:	75 f7                	jne    800a1c <strlen+0xd>
	return n;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
  800a35:	eb 03                	jmp    800a3a <strnlen+0x13>
		n++;
  800a37:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3a:	39 d0                	cmp    %edx,%eax
  800a3c:	74 06                	je     800a44 <strnlen+0x1d>
  800a3e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a42:	75 f3                	jne    800a37 <strnlen+0x10>
	return n;
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	53                   	push   %ebx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a50:	89 c2                	mov    %eax,%edx
  800a52:	83 c1 01             	add    $0x1,%ecx
  800a55:	83 c2 01             	add    $0x1,%edx
  800a58:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5f:	84 db                	test   %bl,%bl
  800a61:	75 ef                	jne    800a52 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a63:	5b                   	pop    %ebx
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	53                   	push   %ebx
  800a6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6d:	53                   	push   %ebx
  800a6e:	e8 9c ff ff ff       	call   800a0f <strlen>
  800a73:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	01 d8                	add    %ebx,%eax
  800a7b:	50                   	push   %eax
  800a7c:	e8 c5 ff ff ff       	call   800a46 <strcpy>
	return dst;
}
  800a81:	89 d8                	mov    %ebx,%eax
  800a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a93:	89 f3                	mov    %esi,%ebx
  800a95:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a98:	89 f2                	mov    %esi,%edx
  800a9a:	eb 0f                	jmp    800aab <strncpy+0x23>
		*dst++ = *src;
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	0f b6 01             	movzbl (%ecx),%eax
  800aa2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa5:	80 39 01             	cmpb   $0x1,(%ecx)
  800aa8:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aab:	39 da                	cmp    %ebx,%edx
  800aad:	75 ed                	jne    800a9c <strncpy+0x14>
	}
	return ret;
}
  800aaf:	89 f0                	mov    %esi,%eax
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	56                   	push   %esi
  800ab9:	53                   	push   %ebx
  800aba:	8b 75 08             	mov    0x8(%ebp),%esi
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ac3:	89 f0                	mov    %esi,%eax
  800ac5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac9:	85 c9                	test   %ecx,%ecx
  800acb:	75 0b                	jne    800ad8 <strlcpy+0x23>
  800acd:	eb 17                	jmp    800ae6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800acf:	83 c2 01             	add    $0x1,%edx
  800ad2:	83 c0 01             	add    $0x1,%eax
  800ad5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ad8:	39 d8                	cmp    %ebx,%eax
  800ada:	74 07                	je     800ae3 <strlcpy+0x2e>
  800adc:	0f b6 0a             	movzbl (%edx),%ecx
  800adf:	84 c9                	test   %cl,%cl
  800ae1:	75 ec                	jne    800acf <strlcpy+0x1a>
		*dst = '\0';
  800ae3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae6:	29 f0                	sub    %esi,%eax
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af5:	eb 06                	jmp    800afd <strcmp+0x11>
		p++, q++;
  800af7:	83 c1 01             	add    $0x1,%ecx
  800afa:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800afd:	0f b6 01             	movzbl (%ecx),%eax
  800b00:	84 c0                	test   %al,%al
  800b02:	74 04                	je     800b08 <strcmp+0x1c>
  800b04:	3a 02                	cmp    (%edx),%al
  800b06:	74 ef                	je     800af7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b08:	0f b6 c0             	movzbl %al,%eax
  800b0b:	0f b6 12             	movzbl (%edx),%edx
  800b0e:	29 d0                	sub    %edx,%eax
}
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b21:	eb 06                	jmp    800b29 <strncmp+0x17>
		n--, p++, q++;
  800b23:	83 c0 01             	add    $0x1,%eax
  800b26:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b29:	39 d8                	cmp    %ebx,%eax
  800b2b:	74 16                	je     800b43 <strncmp+0x31>
  800b2d:	0f b6 08             	movzbl (%eax),%ecx
  800b30:	84 c9                	test   %cl,%cl
  800b32:	74 04                	je     800b38 <strncmp+0x26>
  800b34:	3a 0a                	cmp    (%edx),%cl
  800b36:	74 eb                	je     800b23 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b38:	0f b6 00             	movzbl (%eax),%eax
  800b3b:	0f b6 12             	movzbl (%edx),%edx
  800b3e:	29 d0                	sub    %edx,%eax
}
  800b40:	5b                   	pop    %ebx
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    
		return 0;
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	eb f6                	jmp    800b40 <strncmp+0x2e>

00800b4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b54:	0f b6 10             	movzbl (%eax),%edx
  800b57:	84 d2                	test   %dl,%dl
  800b59:	74 09                	je     800b64 <strchr+0x1a>
		if (*s == c)
  800b5b:	38 ca                	cmp    %cl,%dl
  800b5d:	74 0a                	je     800b69 <strchr+0x1f>
	for (; *s; s++)
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	eb f0                	jmp    800b54 <strchr+0xa>
			return (char *) s;
	return 0;
  800b64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b75:	eb 03                	jmp    800b7a <strfind+0xf>
  800b77:	83 c0 01             	add    $0x1,%eax
  800b7a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b7d:	38 ca                	cmp    %cl,%dl
  800b7f:	74 04                	je     800b85 <strfind+0x1a>
  800b81:	84 d2                	test   %dl,%dl
  800b83:	75 f2                	jne    800b77 <strfind+0xc>
			break;
	return (char *) s;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b93:	85 c9                	test   %ecx,%ecx
  800b95:	74 13                	je     800baa <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b9d:	75 05                	jne    800ba4 <memset+0x1d>
  800b9f:	f6 c1 03             	test   $0x3,%cl
  800ba2:	74 0d                	je     800bb1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	fc                   	cld    
  800ba8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800baa:	89 f8                	mov    %edi,%eax
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    
		c &= 0xFF;
  800bb1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb5:	89 d3                	mov    %edx,%ebx
  800bb7:	c1 e3 08             	shl    $0x8,%ebx
  800bba:	89 d0                	mov    %edx,%eax
  800bbc:	c1 e0 18             	shl    $0x18,%eax
  800bbf:	89 d6                	mov    %edx,%esi
  800bc1:	c1 e6 10             	shl    $0x10,%esi
  800bc4:	09 f0                	or     %esi,%eax
  800bc6:	09 c2                	or     %eax,%edx
  800bc8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bcd:	89 d0                	mov    %edx,%eax
  800bcf:	fc                   	cld    
  800bd0:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd2:	eb d6                	jmp    800baa <memset+0x23>

00800bd4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be2:	39 c6                	cmp    %eax,%esi
  800be4:	73 35                	jae    800c1b <memmove+0x47>
  800be6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	76 2e                	jbe    800c1b <memmove+0x47>
		s += n;
		d += n;
  800bed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf0:	89 d6                	mov    %edx,%esi
  800bf2:	09 fe                	or     %edi,%esi
  800bf4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bfa:	74 0c                	je     800c08 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bfc:	83 ef 01             	sub    $0x1,%edi
  800bff:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c02:	fd                   	std    
  800c03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c05:	fc                   	cld    
  800c06:	eb 21                	jmp    800c29 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c08:	f6 c1 03             	test   $0x3,%cl
  800c0b:	75 ef                	jne    800bfc <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0d:	83 ef 04             	sub    $0x4,%edi
  800c10:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c16:	fd                   	std    
  800c17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c19:	eb ea                	jmp    800c05 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1b:	89 f2                	mov    %esi,%edx
  800c1d:	09 c2                	or     %eax,%edx
  800c1f:	f6 c2 03             	test   $0x3,%dl
  800c22:	74 09                	je     800c2d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c24:	89 c7                	mov    %eax,%edi
  800c26:	fc                   	cld    
  800c27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2d:	f6 c1 03             	test   $0x3,%cl
  800c30:	75 f2                	jne    800c24 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c35:	89 c7                	mov    %eax,%edi
  800c37:	fc                   	cld    
  800c38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3a:	eb ed                	jmp    800c29 <memmove+0x55>

00800c3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c3f:	ff 75 10             	pushl  0x10(%ebp)
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	ff 75 08             	pushl  0x8(%ebp)
  800c48:	e8 87 ff ff ff       	call   800bd4 <memmove>
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	89 c6                	mov    %eax,%esi
  800c5c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5f:	39 f0                	cmp    %esi,%eax
  800c61:	74 1c                	je     800c7f <memcmp+0x30>
		if (*s1 != *s2)
  800c63:	0f b6 08             	movzbl (%eax),%ecx
  800c66:	0f b6 1a             	movzbl (%edx),%ebx
  800c69:	38 d9                	cmp    %bl,%cl
  800c6b:	75 08                	jne    800c75 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c6d:	83 c0 01             	add    $0x1,%eax
  800c70:	83 c2 01             	add    $0x1,%edx
  800c73:	eb ea                	jmp    800c5f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c75:	0f b6 c1             	movzbl %cl,%eax
  800c78:	0f b6 db             	movzbl %bl,%ebx
  800c7b:	29 d8                	sub    %ebx,%eax
  800c7d:	eb 05                	jmp    800c84 <memcmp+0x35>
	}

	return 0;
  800c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c96:	39 d0                	cmp    %edx,%eax
  800c98:	73 09                	jae    800ca3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9a:	38 08                	cmp    %cl,(%eax)
  800c9c:	74 05                	je     800ca3 <memfind+0x1b>
	for (; s < ends; s++)
  800c9e:	83 c0 01             	add    $0x1,%eax
  800ca1:	eb f3                	jmp    800c96 <memfind+0xe>
			break;
	return (void *) s;
}
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb1:	eb 03                	jmp    800cb6 <strtol+0x11>
		s++;
  800cb3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb6:	0f b6 01             	movzbl (%ecx),%eax
  800cb9:	3c 20                	cmp    $0x20,%al
  800cbb:	74 f6                	je     800cb3 <strtol+0xe>
  800cbd:	3c 09                	cmp    $0x9,%al
  800cbf:	74 f2                	je     800cb3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc1:	3c 2b                	cmp    $0x2b,%al
  800cc3:	74 2e                	je     800cf3 <strtol+0x4e>
	int neg = 0;
  800cc5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cca:	3c 2d                	cmp    $0x2d,%al
  800ccc:	74 2f                	je     800cfd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cce:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd4:	75 05                	jne    800cdb <strtol+0x36>
  800cd6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd9:	74 2c                	je     800d07 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cdb:	85 db                	test   %ebx,%ebx
  800cdd:	75 0a                	jne    800ce9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cdf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ce4:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce7:	74 28                	je     800d11 <strtol+0x6c>
		base = 10;
  800ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf1:	eb 50                	jmp    800d43 <strtol+0x9e>
		s++;
  800cf3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf6:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfb:	eb d1                	jmp    800cce <strtol+0x29>
		s++, neg = 1;
  800cfd:	83 c1 01             	add    $0x1,%ecx
  800d00:	bf 01 00 00 00       	mov    $0x1,%edi
  800d05:	eb c7                	jmp    800cce <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d07:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d0b:	74 0e                	je     800d1b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d0d:	85 db                	test   %ebx,%ebx
  800d0f:	75 d8                	jne    800ce9 <strtol+0x44>
		s++, base = 8;
  800d11:	83 c1 01             	add    $0x1,%ecx
  800d14:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d19:	eb ce                	jmp    800ce9 <strtol+0x44>
		s += 2, base = 16;
  800d1b:	83 c1 02             	add    $0x2,%ecx
  800d1e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d23:	eb c4                	jmp    800ce9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d25:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d28:	89 f3                	mov    %esi,%ebx
  800d2a:	80 fb 19             	cmp    $0x19,%bl
  800d2d:	77 29                	ja     800d58 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d2f:	0f be d2             	movsbl %dl,%edx
  800d32:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d38:	7d 30                	jge    800d6a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d3a:	83 c1 01             	add    $0x1,%ecx
  800d3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d41:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d43:	0f b6 11             	movzbl (%ecx),%edx
  800d46:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d49:	89 f3                	mov    %esi,%ebx
  800d4b:	80 fb 09             	cmp    $0x9,%bl
  800d4e:	77 d5                	ja     800d25 <strtol+0x80>
			dig = *s - '0';
  800d50:	0f be d2             	movsbl %dl,%edx
  800d53:	83 ea 30             	sub    $0x30,%edx
  800d56:	eb dd                	jmp    800d35 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d58:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d5b:	89 f3                	mov    %esi,%ebx
  800d5d:	80 fb 19             	cmp    $0x19,%bl
  800d60:	77 08                	ja     800d6a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d62:	0f be d2             	movsbl %dl,%edx
  800d65:	83 ea 37             	sub    $0x37,%edx
  800d68:	eb cb                	jmp    800d35 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6e:	74 05                	je     800d75 <strtol+0xd0>
		*endptr = (char *) s;
  800d70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d73:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d75:	89 c2                	mov    %eax,%edx
  800d77:	f7 da                	neg    %edx
  800d79:	85 ff                	test   %edi,%edi
  800d7b:	0f 45 c2             	cmovne %edx,%eax
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
  800d83:	66 90                	xchg   %ax,%ax
  800d85:	66 90                	xchg   %ax,%ax
  800d87:	66 90                	xchg   %ax,%ax
  800d89:	66 90                	xchg   %ax,%ax
  800d8b:	66 90                	xchg   %ax,%ax
  800d8d:	66 90                	xchg   %ax,%ax
  800d8f:	90                   	nop

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
