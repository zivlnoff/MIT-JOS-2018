
obj/user/softint：     文件格式 elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	83 ec 08             	sub    $0x8,%esp
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800046:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  80004d:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800050:	85 c0                	test   %eax,%eax
  800052:	7e 08                	jle    80005c <libmain+0x22>
		binaryname = argv[0];
  800054:	8b 0a                	mov    (%edx),%ecx
  800056:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	52                   	push   %edx
  800060:	50                   	push   %eax
  800061:	e8 cd ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800066:	e8 05 00 00 00       	call   800070 <exit>
}
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	c9                   	leave  
  80006f:	c3                   	ret    

00800070 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800070:	55                   	push   %ebp
  800071:	89 e5                	mov    %esp,%ebp
  800073:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800076:	6a 00                	push   $0x0
  800078:	e8 42 00 00 00       	call   8000bf <sys_env_destroy>
}
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	c9                   	leave  
  800081:	c3                   	ret    

00800082 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	57                   	push   %edi
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
    asm volatile("int %1\n"
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	8b 55 08             	mov    0x8(%ebp),%edx
  800090:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800093:	89 c3                	mov    %eax,%ebx
  800095:	89 c7                	mov    %eax,%edi
  800097:	89 c6                	mov    %eax,%esi
  800099:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  80009b:	5b                   	pop    %ebx
  80009c:	5e                   	pop    %esi
  80009d:	5f                   	pop    %edi
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <sys_cgetc>:

int
sys_cgetc(void) {
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b0:	89 d1                	mov    %edx,%ecx
  8000b2:	89 d3                	mov    %edx,%ebx
  8000b4:	89 d7                	mov    %edx,%edi
  8000b6:	89 d6                	mov    %edx,%esi
  8000b8:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ba:	5b                   	pop    %ebx
  8000bb:	5e                   	pop    %esi
  8000bc:	5f                   	pop    %edi
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	57                   	push   %edi
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000d5:	89 cb                	mov    %ecx,%ebx
  8000d7:	89 cf                	mov    %ecx,%edi
  8000d9:	89 ce                	mov    %ecx,%esi
  8000db:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000dd:	85 c0                	test   %eax,%eax
  8000df:	7f 08                	jg     8000e9 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	50                   	push   %eax
  8000ed:	6a 03                	push   $0x3
  8000ef:	68 ca 0f 80 00       	push   $0x800fca
  8000f4:	6a 24                	push   $0x24
  8000f6:	68 e7 0f 80 00       	push   $0x800fe7
  8000fb:	e8 ed 01 00 00       	call   8002ed <_panic>

00800100 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	57                   	push   %edi
  800104:	56                   	push   %esi
  800105:	53                   	push   %ebx
    asm volatile("int %1\n"
  800106:	ba 00 00 00 00       	mov    $0x0,%edx
  80010b:	b8 02 00 00 00       	mov    $0x2,%eax
  800110:	89 d1                	mov    %edx,%ecx
  800112:	89 d3                	mov    %edx,%ebx
  800114:	89 d7                	mov    %edx,%edi
  800116:	89 d6                	mov    %edx,%esi
  800118:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80011a:	5b                   	pop    %ebx
  80011b:	5e                   	pop    %esi
  80011c:	5f                   	pop    %edi
  80011d:	5d                   	pop    %ebp
  80011e:	c3                   	ret    

0080011f <sys_yield>:

void
sys_yield(void)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	57                   	push   %edi
  800123:	56                   	push   %esi
  800124:	53                   	push   %ebx
    asm volatile("int %1\n"
  800125:	ba 00 00 00 00       	mov    $0x0,%edx
  80012a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80012f:	89 d1                	mov    %edx,%ecx
  800131:	89 d3                	mov    %edx,%ebx
  800133:	89 d7                	mov    %edx,%edi
  800135:	89 d6                	mov    %edx,%esi
  800137:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800139:	5b                   	pop    %ebx
  80013a:	5e                   	pop    %esi
  80013b:	5f                   	pop    %edi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	57                   	push   %edi
  800142:	56                   	push   %esi
  800143:	53                   	push   %ebx
  800144:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	8b 55 08             	mov    0x8(%ebp),%edx
  80014f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800152:	b8 04 00 00 00       	mov    $0x4,%eax
  800157:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80015a:	89 f7                	mov    %esi,%edi
  80015c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80015e:	85 c0                	test   %eax,%eax
  800160:	7f 08                	jg     80016a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800162:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5f                   	pop    %edi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	50                   	push   %eax
  80016e:	6a 04                	push   $0x4
  800170:	68 ca 0f 80 00       	push   $0x800fca
  800175:	6a 24                	push   $0x24
  800177:	68 e7 0f 80 00       	push   $0x800fe7
  80017c:	e8 6c 01 00 00       	call   8002ed <_panic>

00800181 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80018a:	8b 55 08             	mov    0x8(%ebp),%edx
  80018d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800190:	b8 05 00 00 00       	mov    $0x5,%eax
  800195:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800198:	8b 7d 14             	mov    0x14(%ebp),%edi
  80019b:	8b 75 18             	mov    0x18(%ebp),%esi
  80019e:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001a0:	85 c0                	test   %eax,%eax
  8001a2:	7f 08                	jg     8001ac <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5f                   	pop    %edi
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	50                   	push   %eax
  8001b0:	6a 05                	push   $0x5
  8001b2:	68 ca 0f 80 00       	push   $0x800fca
  8001b7:	6a 24                	push   $0x24
  8001b9:	68 e7 0f 80 00       	push   $0x800fe7
  8001be:	e8 2a 01 00 00       	call   8002ed <_panic>

008001c3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	57                   	push   %edi
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001dc:	89 df                	mov    %ebx,%edi
  8001de:	89 de                	mov    %ebx,%esi
  8001e0:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001e2:	85 c0                	test   %eax,%eax
  8001e4:	7f 08                	jg     8001ee <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e9:	5b                   	pop    %ebx
  8001ea:	5e                   	pop    %esi
  8001eb:	5f                   	pop    %edi
  8001ec:	5d                   	pop    %ebp
  8001ed:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	6a 06                	push   $0x6
  8001f4:	68 ca 0f 80 00       	push   $0x800fca
  8001f9:	6a 24                	push   $0x24
  8001fb:	68 e7 0f 80 00       	push   $0x800fe7
  800200:	e8 e8 00 00 00       	call   8002ed <_panic>

00800205 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	57                   	push   %edi
  800209:	56                   	push   %esi
  80020a:	53                   	push   %ebx
  80020b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80020e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800213:	8b 55 08             	mov    0x8(%ebp),%edx
  800216:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800219:	b8 08 00 00 00       	mov    $0x8,%eax
  80021e:	89 df                	mov    %ebx,%edi
  800220:	89 de                	mov    %ebx,%esi
  800222:	cd 30                	int    $0x30
    if (check && ret > 0)
  800224:	85 c0                	test   %eax,%eax
  800226:	7f 08                	jg     800230 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022b:	5b                   	pop    %ebx
  80022c:	5e                   	pop    %esi
  80022d:	5f                   	pop    %edi
  80022e:	5d                   	pop    %ebp
  80022f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	6a 08                	push   $0x8
  800236:	68 ca 0f 80 00       	push   $0x800fca
  80023b:	6a 24                	push   $0x24
  80023d:	68 e7 0f 80 00       	push   $0x800fe7
  800242:	e8 a6 00 00 00       	call   8002ed <_panic>

00800247 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800250:	bb 00 00 00 00       	mov    $0x0,%ebx
  800255:	8b 55 08             	mov    0x8(%ebp),%edx
  800258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025b:	b8 09 00 00 00       	mov    $0x9,%eax
  800260:	89 df                	mov    %ebx,%edi
  800262:	89 de                	mov    %ebx,%esi
  800264:	cd 30                	int    $0x30
    if (check && ret > 0)
  800266:	85 c0                	test   %eax,%eax
  800268:	7f 08                	jg     800272 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80026a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026d:	5b                   	pop    %ebx
  80026e:	5e                   	pop    %esi
  80026f:	5f                   	pop    %edi
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	50                   	push   %eax
  800276:	6a 09                	push   $0x9
  800278:	68 ca 0f 80 00       	push   $0x800fca
  80027d:	6a 24                	push   $0x24
  80027f:	68 e7 0f 80 00       	push   $0x800fe7
  800284:	e8 64 00 00 00       	call   8002ed <_panic>

00800289 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	57                   	push   %edi
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
    asm volatile("int %1\n"
  80028f:	8b 55 08             	mov    0x8(%ebp),%edx
  800292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800295:	b8 0b 00 00 00       	mov    $0xb,%eax
  80029a:	be 00 00 00 00       	mov    $0x0,%esi
  80029f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002a2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002a5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002a7:	5b                   	pop    %ebx
  8002a8:	5e                   	pop    %esi
  8002a9:	5f                   	pop    %edi
  8002aa:	5d                   	pop    %ebp
  8002ab:	c3                   	ret    

008002ac <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	57                   	push   %edi
  8002b0:	56                   	push   %esi
  8002b1:	53                   	push   %ebx
  8002b2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002c2:	89 cb                	mov    %ecx,%ebx
  8002c4:	89 cf                	mov    %ecx,%edi
  8002c6:	89 ce                	mov    %ecx,%esi
  8002c8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	7f 08                	jg     8002d6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d1:	5b                   	pop    %ebx
  8002d2:	5e                   	pop    %esi
  8002d3:	5f                   	pop    %edi
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	6a 0c                	push   $0xc
  8002dc:	68 ca 0f 80 00       	push   $0x800fca
  8002e1:	6a 24                	push   $0x24
  8002e3:	68 e7 0f 80 00       	push   $0x800fe7
  8002e8:	e8 00 00 00 00       	call   8002ed <_panic>

008002ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002f2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f5:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8002fb:	e8 00 fe ff ff       	call   800100 <sys_getenvid>
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	56                   	push   %esi
  80030a:	50                   	push   %eax
  80030b:	68 f8 0f 80 00       	push   $0x800ff8
  800310:	e8 b3 00 00 00       	call   8003c8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800315:	83 c4 18             	add    $0x18,%esp
  800318:	53                   	push   %ebx
  800319:	ff 75 10             	pushl  0x10(%ebp)
  80031c:	e8 56 00 00 00       	call   800377 <vcprintf>
	cprintf("\n");
  800321:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800328:	e8 9b 00 00 00       	call   8003c8 <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800330:	cc                   	int3   
  800331:	eb fd                	jmp    800330 <_panic+0x43>

00800333 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	53                   	push   %ebx
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80033d:	8b 13                	mov    (%ebx),%edx
  80033f:	8d 42 01             	lea    0x1(%edx),%eax
  800342:	89 03                	mov    %eax,(%ebx)
  800344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800347:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80034b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800350:	74 09                	je     80035b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800352:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800356:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800359:	c9                   	leave  
  80035a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	68 ff 00 00 00       	push   $0xff
  800363:	8d 43 08             	lea    0x8(%ebx),%eax
  800366:	50                   	push   %eax
  800367:	e8 16 fd ff ff       	call   800082 <sys_cputs>
		b->idx = 0;
  80036c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	eb db                	jmp    800352 <putch+0x1f>

00800377 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800380:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800387:	00 00 00 
	b.cnt = 0;
  80038a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800391:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 08             	pushl  0x8(%ebp)
  80039a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a0:	50                   	push   %eax
  8003a1:	68 33 03 80 00       	push   $0x800333
  8003a6:	e8 1a 01 00 00       	call   8004c5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003ab:	83 c4 08             	add    $0x8,%esp
  8003ae:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ba:	50                   	push   %eax
  8003bb:	e8 c2 fc ff ff       	call   800082 <sys_cputs>

	return b.cnt;
}
  8003c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ce:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d1:	50                   	push   %eax
  8003d2:	ff 75 08             	pushl  0x8(%ebp)
  8003d5:	e8 9d ff ff ff       	call   800377 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	57                   	push   %edi
  8003e0:	56                   	push   %esi
  8003e1:	53                   	push   %ebx
  8003e2:	83 ec 1c             	sub    $0x1c,%esp
  8003e5:	89 c7                	mov    %eax,%edi
  8003e7:	89 d6                	mov    %edx,%esi
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8003f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003fd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800403:	39 d3                	cmp    %edx,%ebx
  800405:	72 05                	jb     80040c <printnum+0x30>
  800407:	39 45 10             	cmp    %eax,0x10(%ebp)
  80040a:	77 7a                	ja     800486 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	ff 75 18             	pushl  0x18(%ebp)
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800418:	53                   	push   %ebx
  800419:	ff 75 10             	pushl  0x10(%ebp)
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800422:	ff 75 e0             	pushl  -0x20(%ebp)
  800425:	ff 75 dc             	pushl  -0x24(%ebp)
  800428:	ff 75 d8             	pushl  -0x28(%ebp)
  80042b:	e8 40 09 00 00       	call   800d70 <__udivdi3>
  800430:	83 c4 18             	add    $0x18,%esp
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	89 f2                	mov    %esi,%edx
  800437:	89 f8                	mov    %edi,%eax
  800439:	e8 9e ff ff ff       	call   8003dc <printnum>
  80043e:	83 c4 20             	add    $0x20,%esp
  800441:	eb 13                	jmp    800456 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	56                   	push   %esi
  800447:	ff 75 18             	pushl  0x18(%ebp)
  80044a:	ff d7                	call   *%edi
  80044c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80044f:	83 eb 01             	sub    $0x1,%ebx
  800452:	85 db                	test   %ebx,%ebx
  800454:	7f ed                	jg     800443 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	56                   	push   %esi
  80045a:	83 ec 04             	sub    $0x4,%esp
  80045d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800460:	ff 75 e0             	pushl  -0x20(%ebp)
  800463:	ff 75 dc             	pushl  -0x24(%ebp)
  800466:	ff 75 d8             	pushl  -0x28(%ebp)
  800469:	e8 22 0a 00 00       	call   800e90 <__umoddi3>
  80046e:	83 c4 14             	add    $0x14,%esp
  800471:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800478:	50                   	push   %eax
  800479:	ff d7                	call   *%edi
}
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800481:	5b                   	pop    %ebx
  800482:	5e                   	pop    %esi
  800483:	5f                   	pop    %edi
  800484:	5d                   	pop    %ebp
  800485:	c3                   	ret    
  800486:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800489:	eb c4                	jmp    80044f <printnum+0x73>

0080048b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800491:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800495:	8b 10                	mov    (%eax),%edx
  800497:	3b 50 04             	cmp    0x4(%eax),%edx
  80049a:	73 0a                	jae    8004a6 <sprintputch+0x1b>
		*b->buf++ = ch;
  80049c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80049f:	89 08                	mov    %ecx,(%eax)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	88 02                	mov    %al,(%edx)
}
  8004a6:	5d                   	pop    %ebp
  8004a7:	c3                   	ret    

008004a8 <printfmt>:
{
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
  8004ab:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ae:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b1:	50                   	push   %eax
  8004b2:	ff 75 10             	pushl  0x10(%ebp)
  8004b5:	ff 75 0c             	pushl  0xc(%ebp)
  8004b8:	ff 75 08             	pushl  0x8(%ebp)
  8004bb:	e8 05 00 00 00       	call   8004c5 <vprintfmt>
}
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	c9                   	leave  
  8004c4:	c3                   	ret    

008004c5 <vprintfmt>:
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	57                   	push   %edi
  8004c9:	56                   	push   %esi
  8004ca:	53                   	push   %ebx
  8004cb:	83 ec 2c             	sub    $0x2c,%esp
  8004ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004d7:	e9 00 04 00 00       	jmp    8008dc <vprintfmt+0x417>
		padc = ' ';
  8004dc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004e0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004e7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	8d 47 01             	lea    0x1(%edi),%eax
  8004fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800500:	0f b6 17             	movzbl (%edi),%edx
  800503:	8d 42 dd             	lea    -0x23(%edx),%eax
  800506:	3c 55                	cmp    $0x55,%al
  800508:	0f 87 51 04 00 00    	ja     80095f <vprintfmt+0x49a>
  80050e:	0f b6 c0             	movzbl %al,%eax
  800511:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800518:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80051b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80051f:	eb d9                	jmp    8004fa <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800521:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800524:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800528:	eb d0                	jmp    8004fa <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	0f b6 d2             	movzbl %dl,%edx
  80052d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800538:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80053b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80053f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800542:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800545:	83 f9 09             	cmp    $0x9,%ecx
  800548:	77 55                	ja     80059f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80054a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80054d:	eb e9                	jmp    800538 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 40 04             	lea    0x4(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800563:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800567:	79 91                	jns    8004fa <vprintfmt+0x35>
				width = precision, precision = -1;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800576:	eb 82                	jmp    8004fa <vprintfmt+0x35>
  800578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057b:	85 c0                	test   %eax,%eax
  80057d:	ba 00 00 00 00       	mov    $0x0,%edx
  800582:	0f 49 d0             	cmovns %eax,%edx
  800585:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800588:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058b:	e9 6a ff ff ff       	jmp    8004fa <vprintfmt+0x35>
  800590:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800593:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80059a:	e9 5b ff ff ff       	jmp    8004fa <vprintfmt+0x35>
  80059f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a5:	eb bc                	jmp    800563 <vprintfmt+0x9e>
			lflag++;
  8005a7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ad:	e9 48 ff ff ff       	jmp    8004fa <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 78 04             	lea    0x4(%eax),%edi
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	ff 30                	pushl  (%eax)
  8005be:	ff d6                	call   *%esi
			break;
  8005c0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005c3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005c6:	e9 0e 03 00 00       	jmp    8008d9 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 78 04             	lea    0x4(%eax),%edi
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	99                   	cltd   
  8005d4:	31 d0                	xor    %edx,%eax
  8005d6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005d8:	83 f8 08             	cmp    $0x8,%eax
  8005db:	7f 23                	jg     800600 <vprintfmt+0x13b>
  8005dd:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005e4:	85 d2                	test   %edx,%edx
  8005e6:	74 18                	je     800600 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005e8:	52                   	push   %edx
  8005e9:	68 3f 10 80 00       	push   $0x80103f
  8005ee:	53                   	push   %ebx
  8005ef:	56                   	push   %esi
  8005f0:	e8 b3 fe ff ff       	call   8004a8 <printfmt>
  8005f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005fb:	e9 d9 02 00 00       	jmp    8008d9 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800600:	50                   	push   %eax
  800601:	68 36 10 80 00       	push   $0x801036
  800606:	53                   	push   %ebx
  800607:	56                   	push   %esi
  800608:	e8 9b fe ff ff       	call   8004a8 <printfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800610:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800613:	e9 c1 02 00 00       	jmp    8008d9 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	83 c0 04             	add    $0x4,%eax
  80061e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800626:	85 ff                	test   %edi,%edi
  800628:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  80062d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800630:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800634:	0f 8e bd 00 00 00    	jle    8006f7 <vprintfmt+0x232>
  80063a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80063e:	75 0e                	jne    80064e <vprintfmt+0x189>
  800640:	89 75 08             	mov    %esi,0x8(%ebp)
  800643:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800646:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800649:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064c:	eb 6d                	jmp    8006bb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	ff 75 d0             	pushl  -0x30(%ebp)
  800654:	57                   	push   %edi
  800655:	e8 ad 03 00 00       	call   800a07 <strnlen>
  80065a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065d:	29 c1                	sub    %eax,%ecx
  80065f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800662:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800665:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800669:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80066c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80066f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800671:	eb 0f                	jmp    800682 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	ff 75 e0             	pushl  -0x20(%ebp)
  80067a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80067c:	83 ef 01             	sub    $0x1,%edi
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	85 ff                	test   %edi,%edi
  800684:	7f ed                	jg     800673 <vprintfmt+0x1ae>
  800686:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800689:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80068c:	85 c9                	test   %ecx,%ecx
  80068e:	b8 00 00 00 00       	mov    $0x0,%eax
  800693:	0f 49 c1             	cmovns %ecx,%eax
  800696:	29 c1                	sub    %eax,%ecx
  800698:	89 75 08             	mov    %esi,0x8(%ebp)
  80069b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80069e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a1:	89 cb                	mov    %ecx,%ebx
  8006a3:	eb 16                	jmp    8006bb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a9:	75 31                	jne    8006dc <vprintfmt+0x217>
					putch(ch, putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	ff 75 0c             	pushl  0xc(%ebp)
  8006b1:	50                   	push   %eax
  8006b2:	ff 55 08             	call   *0x8(%ebp)
  8006b5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b8:	83 eb 01             	sub    $0x1,%ebx
  8006bb:	83 c7 01             	add    $0x1,%edi
  8006be:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006c2:	0f be c2             	movsbl %dl,%eax
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	74 59                	je     800722 <vprintfmt+0x25d>
  8006c9:	85 f6                	test   %esi,%esi
  8006cb:	78 d8                	js     8006a5 <vprintfmt+0x1e0>
  8006cd:	83 ee 01             	sub    $0x1,%esi
  8006d0:	79 d3                	jns    8006a5 <vprintfmt+0x1e0>
  8006d2:	89 df                	mov    %ebx,%edi
  8006d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006da:	eb 37                	jmp    800713 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006dc:	0f be d2             	movsbl %dl,%edx
  8006df:	83 ea 20             	sub    $0x20,%edx
  8006e2:	83 fa 5e             	cmp    $0x5e,%edx
  8006e5:	76 c4                	jbe    8006ab <vprintfmt+0x1e6>
					putch('?', putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	6a 3f                	push   $0x3f
  8006ef:	ff 55 08             	call   *0x8(%ebp)
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	eb c1                	jmp    8006b8 <vprintfmt+0x1f3>
  8006f7:	89 75 08             	mov    %esi,0x8(%ebp)
  8006fa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006fd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800700:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800703:	eb b6                	jmp    8006bb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 20                	push   $0x20
  80070b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80070d:	83 ef 01             	sub    $0x1,%edi
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	85 ff                	test   %edi,%edi
  800715:	7f ee                	jg     800705 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800717:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
  80071d:	e9 b7 01 00 00       	jmp    8008d9 <vprintfmt+0x414>
  800722:	89 df                	mov    %ebx,%edi
  800724:	8b 75 08             	mov    0x8(%ebp),%esi
  800727:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80072a:	eb e7                	jmp    800713 <vprintfmt+0x24e>
	if (lflag >= 2)
  80072c:	83 f9 01             	cmp    $0x1,%ecx
  80072f:	7e 3f                	jle    800770 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 50 04             	mov    0x4(%eax),%edx
  800737:	8b 00                	mov    (%eax),%eax
  800739:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 40 08             	lea    0x8(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800748:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074c:	79 5c                	jns    8007aa <vprintfmt+0x2e5>
				putch('-', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 2d                	push   $0x2d
  800754:	ff d6                	call   *%esi
				num = -(long long) num;
  800756:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800759:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80075c:	f7 da                	neg    %edx
  80075e:	83 d1 00             	adc    $0x0,%ecx
  800761:	f7 d9                	neg    %ecx
  800763:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800766:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076b:	e9 4f 01 00 00       	jmp    8008bf <vprintfmt+0x3fa>
	else if (lflag)
  800770:	85 c9                	test   %ecx,%ecx
  800772:	75 1b                	jne    80078f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	89 c1                	mov    %eax,%ecx
  80077e:	c1 f9 1f             	sar    $0x1f,%ecx
  800781:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
  80078d:	eb b9                	jmp    800748 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800797:	89 c1                	mov    %eax,%ecx
  800799:	c1 f9 1f             	sar    $0x1f,%ecx
  80079c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8d 40 04             	lea    0x4(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a8:	eb 9e                	jmp    800748 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b5:	e9 05 01 00 00       	jmp    8008bf <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007ba:	83 f9 01             	cmp    $0x1,%ecx
  8007bd:	7e 18                	jle    8007d7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8b 10                	mov    (%eax),%edx
  8007c4:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c7:	8d 40 08             	lea    0x8(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d2:	e9 e8 00 00 00       	jmp    8008bf <vprintfmt+0x3fa>
	else if (lflag)
  8007d7:	85 c9                	test   %ecx,%ecx
  8007d9:	75 1a                	jne    8007f5 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	e9 ca 00 00 00       	jmp    8008bf <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 10                	mov    (%eax),%edx
  8007fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800805:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080a:	e9 b0 00 00 00       	jmp    8008bf <vprintfmt+0x3fa>
	if (lflag >= 2)
  80080f:	83 f9 01             	cmp    $0x1,%ecx
  800812:	7e 3c                	jle    800850 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 50 04             	mov    0x4(%eax),%edx
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8d 40 08             	lea    0x8(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80082b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082f:	79 59                	jns    80088a <vprintfmt+0x3c5>
                putch('-', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 2d                	push   $0x2d
  800837:	ff d6                	call   *%esi
                num = -(long long) num;
  800839:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80083c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80083f:	f7 da                	neg    %edx
  800841:	83 d1 00             	adc    $0x0,%ecx
  800844:	f7 d9                	neg    %ecx
  800846:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800849:	b8 08 00 00 00       	mov    $0x8,%eax
  80084e:	eb 6f                	jmp    8008bf <vprintfmt+0x3fa>
	else if (lflag)
  800850:	85 c9                	test   %ecx,%ecx
  800852:	75 1b                	jne    80086f <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085c:	89 c1                	mov    %eax,%ecx
  80085e:	c1 f9 1f             	sar    $0x1f,%ecx
  800861:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 40 04             	lea    0x4(%eax),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	eb bc                	jmp    80082b <vprintfmt+0x366>
		return va_arg(*ap, long);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800877:	89 c1                	mov    %eax,%ecx
  800879:	c1 f9 1f             	sar    $0x1f,%ecx
  80087c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 04             	lea    0x4(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
  800888:	eb a1                	jmp    80082b <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80088a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80088d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800890:	b8 08 00 00 00       	mov    $0x8,%eax
  800895:	eb 28                	jmp    8008bf <vprintfmt+0x3fa>
			putch('0', putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	6a 30                	push   $0x30
  80089d:	ff d6                	call   *%esi
			putch('x', putdat);
  80089f:	83 c4 08             	add    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 78                	push   $0x78
  8008a5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 10                	mov    (%eax),%edx
  8008ac:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b4:	8d 40 04             	lea    0x4(%eax),%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ba:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008bf:	83 ec 0c             	sub    $0xc,%esp
  8008c2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008c6:	57                   	push   %edi
  8008c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	51                   	push   %ecx
  8008cc:	52                   	push   %edx
  8008cd:	89 da                	mov    %ebx,%edx
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	e8 06 fb ff ff       	call   8003dc <printnum>
			break;
  8008d6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008dc:	83 c7 01             	add    $0x1,%edi
  8008df:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e3:	83 f8 25             	cmp    $0x25,%eax
  8008e6:	0f 84 f0 fb ff ff    	je     8004dc <vprintfmt+0x17>
			if (ch == '\0')
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	0f 84 8b 00 00 00    	je     80097f <vprintfmt+0x4ba>
			putch(ch, putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	50                   	push   %eax
  8008f9:	ff d6                	call   *%esi
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	eb dc                	jmp    8008dc <vprintfmt+0x417>
	if (lflag >= 2)
  800900:	83 f9 01             	cmp    $0x1,%ecx
  800903:	7e 15                	jle    80091a <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8b 10                	mov    (%eax),%edx
  80090a:	8b 48 04             	mov    0x4(%eax),%ecx
  80090d:	8d 40 08             	lea    0x8(%eax),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800913:	b8 10 00 00 00       	mov    $0x10,%eax
  800918:	eb a5                	jmp    8008bf <vprintfmt+0x3fa>
	else if (lflag)
  80091a:	85 c9                	test   %ecx,%ecx
  80091c:	75 17                	jne    800935 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	8b 10                	mov    (%eax),%edx
  800923:	b9 00 00 00 00       	mov    $0x0,%ecx
  800928:	8d 40 04             	lea    0x4(%eax),%eax
  80092b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092e:	b8 10 00 00 00       	mov    $0x10,%eax
  800933:	eb 8a                	jmp    8008bf <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 10                	mov    (%eax),%edx
  80093a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800945:	b8 10 00 00 00       	mov    $0x10,%eax
  80094a:	e9 70 ff ff ff       	jmp    8008bf <vprintfmt+0x3fa>
			putch(ch, putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	53                   	push   %ebx
  800953:	6a 25                	push   $0x25
  800955:	ff d6                	call   *%esi
			break;
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	e9 7a ff ff ff       	jmp    8008d9 <vprintfmt+0x414>
			putch('%', putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	53                   	push   %ebx
  800963:	6a 25                	push   $0x25
  800965:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	89 f8                	mov    %edi,%eax
  80096c:	eb 03                	jmp    800971 <vprintfmt+0x4ac>
  80096e:	83 e8 01             	sub    $0x1,%eax
  800971:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800975:	75 f7                	jne    80096e <vprintfmt+0x4a9>
  800977:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097a:	e9 5a ff ff ff       	jmp    8008d9 <vprintfmt+0x414>
}
  80097f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800982:	5b                   	pop    %ebx
  800983:	5e                   	pop    %esi
  800984:	5f                   	pop    %edi
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 18             	sub    $0x18,%esp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800993:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800996:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	74 26                	je     8009ce <vsnprintf+0x47>
  8009a8:	85 d2                	test   %edx,%edx
  8009aa:	7e 22                	jle    8009ce <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ac:	ff 75 14             	pushl  0x14(%ebp)
  8009af:	ff 75 10             	pushl  0x10(%ebp)
  8009b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	68 8b 04 80 00       	push   $0x80048b
  8009bb:	e8 05 fb ff ff       	call   8004c5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
}
  8009cc:	c9                   	leave  
  8009cd:	c3                   	ret    
		return -E_INVAL;
  8009ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d3:	eb f7                	jmp    8009cc <vsnprintf+0x45>

008009d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009de:	50                   	push   %eax
  8009df:	ff 75 10             	pushl  0x10(%ebp)
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 9a ff ff ff       	call   800987 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fa:	eb 03                	jmp    8009ff <strlen+0x10>
		n++;
  8009fc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a03:	75 f7                	jne    8009fc <strlen+0xd>
	return n;
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	eb 03                	jmp    800a1a <strnlen+0x13>
		n++;
  800a17:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1a:	39 d0                	cmp    %edx,%eax
  800a1c:	74 06                	je     800a24 <strnlen+0x1d>
  800a1e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a22:	75 f3                	jne    800a17 <strnlen+0x10>
	return n;
}
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a30:	89 c2                	mov    %eax,%edx
  800a32:	83 c1 01             	add    $0x1,%ecx
  800a35:	83 c2 01             	add    $0x1,%edx
  800a38:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a3c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3f:	84 db                	test   %bl,%bl
  800a41:	75 ef                	jne    800a32 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a43:	5b                   	pop    %ebx
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	53                   	push   %ebx
  800a4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a4d:	53                   	push   %ebx
  800a4e:	e8 9c ff ff ff       	call   8009ef <strlen>
  800a53:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	01 d8                	add    %ebx,%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 c5 ff ff ff       	call   800a26 <strcpy>
	return dst;
}
  800a61:	89 d8                	mov    %ebx,%eax
  800a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	56                   	push   %esi
  800a6c:	53                   	push   %ebx
  800a6d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a73:	89 f3                	mov    %esi,%ebx
  800a75:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	89 f2                	mov    %esi,%edx
  800a7a:	eb 0f                	jmp    800a8b <strncpy+0x23>
		*dst++ = *src;
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	0f b6 01             	movzbl (%ecx),%eax
  800a82:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a85:	80 39 01             	cmpb   $0x1,(%ecx)
  800a88:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a8b:	39 da                	cmp    %ebx,%edx
  800a8d:	75 ed                	jne    800a7c <strncpy+0x14>
	}
	return ret;
}
  800a8f:	89 f0                	mov    %esi,%eax
  800a91:	5b                   	pop    %ebx
  800a92:	5e                   	pop    %esi
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	56                   	push   %esi
  800a99:	53                   	push   %ebx
  800a9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aa9:	85 c9                	test   %ecx,%ecx
  800aab:	75 0b                	jne    800ab8 <strlcpy+0x23>
  800aad:	eb 17                	jmp    800ac6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aaf:	83 c2 01             	add    $0x1,%edx
  800ab2:	83 c0 01             	add    $0x1,%eax
  800ab5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ab8:	39 d8                	cmp    %ebx,%eax
  800aba:	74 07                	je     800ac3 <strlcpy+0x2e>
  800abc:	0f b6 0a             	movzbl (%edx),%ecx
  800abf:	84 c9                	test   %cl,%cl
  800ac1:	75 ec                	jne    800aaf <strlcpy+0x1a>
		*dst = '\0';
  800ac3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac6:	29 f0                	sub    %esi,%eax
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5e                   	pop    %esi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ad5:	eb 06                	jmp    800add <strcmp+0x11>
		p++, q++;
  800ad7:	83 c1 01             	add    $0x1,%ecx
  800ada:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800add:	0f b6 01             	movzbl (%ecx),%eax
  800ae0:	84 c0                	test   %al,%al
  800ae2:	74 04                	je     800ae8 <strcmp+0x1c>
  800ae4:	3a 02                	cmp    (%edx),%al
  800ae6:	74 ef                	je     800ad7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae8:	0f b6 c0             	movzbl %al,%eax
  800aeb:	0f b6 12             	movzbl (%edx),%edx
  800aee:	29 d0                	sub    %edx,%eax
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	53                   	push   %ebx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 c3                	mov    %eax,%ebx
  800afe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b01:	eb 06                	jmp    800b09 <strncmp+0x17>
		n--, p++, q++;
  800b03:	83 c0 01             	add    $0x1,%eax
  800b06:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b09:	39 d8                	cmp    %ebx,%eax
  800b0b:	74 16                	je     800b23 <strncmp+0x31>
  800b0d:	0f b6 08             	movzbl (%eax),%ecx
  800b10:	84 c9                	test   %cl,%cl
  800b12:	74 04                	je     800b18 <strncmp+0x26>
  800b14:	3a 0a                	cmp    (%edx),%cl
  800b16:	74 eb                	je     800b03 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b18:	0f b6 00             	movzbl (%eax),%eax
  800b1b:	0f b6 12             	movzbl (%edx),%edx
  800b1e:	29 d0                	sub    %edx,%eax
}
  800b20:	5b                   	pop    %ebx
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    
		return 0;
  800b23:	b8 00 00 00 00       	mov    $0x0,%eax
  800b28:	eb f6                	jmp    800b20 <strncmp+0x2e>

00800b2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b34:	0f b6 10             	movzbl (%eax),%edx
  800b37:	84 d2                	test   %dl,%dl
  800b39:	74 09                	je     800b44 <strchr+0x1a>
		if (*s == c)
  800b3b:	38 ca                	cmp    %cl,%dl
  800b3d:	74 0a                	je     800b49 <strchr+0x1f>
	for (; *s; s++)
  800b3f:	83 c0 01             	add    $0x1,%eax
  800b42:	eb f0                	jmp    800b34 <strchr+0xa>
			return (char *) s;
	return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b55:	eb 03                	jmp    800b5a <strfind+0xf>
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b5d:	38 ca                	cmp    %cl,%dl
  800b5f:	74 04                	je     800b65 <strfind+0x1a>
  800b61:	84 d2                	test   %dl,%dl
  800b63:	75 f2                	jne    800b57 <strfind+0xc>
			break;
	return (char *) s;
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b73:	85 c9                	test   %ecx,%ecx
  800b75:	74 13                	je     800b8a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b7d:	75 05                	jne    800b84 <memset+0x1d>
  800b7f:	f6 c1 03             	test   $0x3,%cl
  800b82:	74 0d                	je     800b91 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	fc                   	cld    
  800b88:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8a:	89 f8                	mov    %edi,%eax
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    
		c &= 0xFF;
  800b91:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b95:	89 d3                	mov    %edx,%ebx
  800b97:	c1 e3 08             	shl    $0x8,%ebx
  800b9a:	89 d0                	mov    %edx,%eax
  800b9c:	c1 e0 18             	shl    $0x18,%eax
  800b9f:	89 d6                	mov    %edx,%esi
  800ba1:	c1 e6 10             	shl    $0x10,%esi
  800ba4:	09 f0                	or     %esi,%eax
  800ba6:	09 c2                	or     %eax,%edx
  800ba8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800baa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bad:	89 d0                	mov    %edx,%eax
  800baf:	fc                   	cld    
  800bb0:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb2:	eb d6                	jmp    800b8a <memset+0x23>

00800bb4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc2:	39 c6                	cmp    %eax,%esi
  800bc4:	73 35                	jae    800bfb <memmove+0x47>
  800bc6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bc9:	39 c2                	cmp    %eax,%edx
  800bcb:	76 2e                	jbe    800bfb <memmove+0x47>
		s += n;
		d += n;
  800bcd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd0:	89 d6                	mov    %edx,%esi
  800bd2:	09 fe                	or     %edi,%esi
  800bd4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bda:	74 0c                	je     800be8 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bdc:	83 ef 01             	sub    $0x1,%edi
  800bdf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be2:	fd                   	std    
  800be3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be5:	fc                   	cld    
  800be6:	eb 21                	jmp    800c09 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be8:	f6 c1 03             	test   $0x3,%cl
  800beb:	75 ef                	jne    800bdc <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bed:	83 ef 04             	sub    $0x4,%edi
  800bf0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf6:	fd                   	std    
  800bf7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf9:	eb ea                	jmp    800be5 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfb:	89 f2                	mov    %esi,%edx
  800bfd:	09 c2                	or     %eax,%edx
  800bff:	f6 c2 03             	test   $0x3,%dl
  800c02:	74 09                	je     800c0d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c04:	89 c7                	mov    %eax,%edi
  800c06:	fc                   	cld    
  800c07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0d:	f6 c1 03             	test   $0x3,%cl
  800c10:	75 f2                	jne    800c04 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c15:	89 c7                	mov    %eax,%edi
  800c17:	fc                   	cld    
  800c18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1a:	eb ed                	jmp    800c09 <memmove+0x55>

00800c1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c1f:	ff 75 10             	pushl  0x10(%ebp)
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	ff 75 08             	pushl  0x8(%ebp)
  800c28:	e8 87 ff ff ff       	call   800bb4 <memmove>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 c6                	mov    %eax,%esi
  800c3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3f:	39 f0                	cmp    %esi,%eax
  800c41:	74 1c                	je     800c5f <memcmp+0x30>
		if (*s1 != *s2)
  800c43:	0f b6 08             	movzbl (%eax),%ecx
  800c46:	0f b6 1a             	movzbl (%edx),%ebx
  800c49:	38 d9                	cmp    %bl,%cl
  800c4b:	75 08                	jne    800c55 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4d:	83 c0 01             	add    $0x1,%eax
  800c50:	83 c2 01             	add    $0x1,%edx
  800c53:	eb ea                	jmp    800c3f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c55:	0f b6 c1             	movzbl %cl,%eax
  800c58:	0f b6 db             	movzbl %bl,%ebx
  800c5b:	29 d8                	sub    %ebx,%eax
  800c5d:	eb 05                	jmp    800c64 <memcmp+0x35>
	}

	return 0;
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c71:	89 c2                	mov    %eax,%edx
  800c73:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c76:	39 d0                	cmp    %edx,%eax
  800c78:	73 09                	jae    800c83 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7a:	38 08                	cmp    %cl,(%eax)
  800c7c:	74 05                	je     800c83 <memfind+0x1b>
	for (; s < ends; s++)
  800c7e:	83 c0 01             	add    $0x1,%eax
  800c81:	eb f3                	jmp    800c76 <memfind+0xe>
			break;
	return (void *) s;
}
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c91:	eb 03                	jmp    800c96 <strtol+0x11>
		s++;
  800c93:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c96:	0f b6 01             	movzbl (%ecx),%eax
  800c99:	3c 20                	cmp    $0x20,%al
  800c9b:	74 f6                	je     800c93 <strtol+0xe>
  800c9d:	3c 09                	cmp    $0x9,%al
  800c9f:	74 f2                	je     800c93 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca1:	3c 2b                	cmp    $0x2b,%al
  800ca3:	74 2e                	je     800cd3 <strtol+0x4e>
	int neg = 0;
  800ca5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800caa:	3c 2d                	cmp    $0x2d,%al
  800cac:	74 2f                	je     800cdd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cae:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb4:	75 05                	jne    800cbb <strtol+0x36>
  800cb6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cb9:	74 2c                	je     800ce7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cbb:	85 db                	test   %ebx,%ebx
  800cbd:	75 0a                	jne    800cc9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cc4:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc7:	74 28                	je     800cf1 <strtol+0x6c>
		base = 10;
  800cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd1:	eb 50                	jmp    800d23 <strtol+0x9e>
		s++;
  800cd3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd6:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdb:	eb d1                	jmp    800cae <strtol+0x29>
		s++, neg = 1;
  800cdd:	83 c1 01             	add    $0x1,%ecx
  800ce0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce5:	eb c7                	jmp    800cae <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ceb:	74 0e                	je     800cfb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ced:	85 db                	test   %ebx,%ebx
  800cef:	75 d8                	jne    800cc9 <strtol+0x44>
		s++, base = 8;
  800cf1:	83 c1 01             	add    $0x1,%ecx
  800cf4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cf9:	eb ce                	jmp    800cc9 <strtol+0x44>
		s += 2, base = 16;
  800cfb:	83 c1 02             	add    $0x2,%ecx
  800cfe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d03:	eb c4                	jmp    800cc9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d05:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d08:	89 f3                	mov    %esi,%ebx
  800d0a:	80 fb 19             	cmp    $0x19,%bl
  800d0d:	77 29                	ja     800d38 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d0f:	0f be d2             	movsbl %dl,%edx
  800d12:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d15:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d18:	7d 30                	jge    800d4a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d1a:	83 c1 01             	add    $0x1,%ecx
  800d1d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d21:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d23:	0f b6 11             	movzbl (%ecx),%edx
  800d26:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d29:	89 f3                	mov    %esi,%ebx
  800d2b:	80 fb 09             	cmp    $0x9,%bl
  800d2e:	77 d5                	ja     800d05 <strtol+0x80>
			dig = *s - '0';
  800d30:	0f be d2             	movsbl %dl,%edx
  800d33:	83 ea 30             	sub    $0x30,%edx
  800d36:	eb dd                	jmp    800d15 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d38:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3b:	89 f3                	mov    %esi,%ebx
  800d3d:	80 fb 19             	cmp    $0x19,%bl
  800d40:	77 08                	ja     800d4a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d42:	0f be d2             	movsbl %dl,%edx
  800d45:	83 ea 37             	sub    $0x37,%edx
  800d48:	eb cb                	jmp    800d15 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4e:	74 05                	je     800d55 <strtol+0xd0>
		*endptr = (char *) s;
  800d50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d53:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d55:	89 c2                	mov    %eax,%edx
  800d57:	f7 da                	neg    %edx
  800d59:	85 ff                	test   %edi,%edi
  800d5b:	0f 45 c2             	cmovne %edx,%eax
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    
  800d63:	66 90                	xchg   %ax,%ax
  800d65:	66 90                	xchg   %ax,%ax
  800d67:	66 90                	xchg   %ax,%ax
  800d69:	66 90                	xchg   %ax,%ax
  800d6b:	66 90                	xchg   %ax,%ax
  800d6d:	66 90                	xchg   %ax,%ax
  800d6f:	90                   	nop

00800d70 <__udivdi3>:
  800d70:	55                   	push   %ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 1c             	sub    $0x1c,%esp
  800d77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d87:	85 d2                	test   %edx,%edx
  800d89:	75 35                	jne    800dc0 <__udivdi3+0x50>
  800d8b:	39 f3                	cmp    %esi,%ebx
  800d8d:	0f 87 bd 00 00 00    	ja     800e50 <__udivdi3+0xe0>
  800d93:	85 db                	test   %ebx,%ebx
  800d95:	89 d9                	mov    %ebx,%ecx
  800d97:	75 0b                	jne    800da4 <__udivdi3+0x34>
  800d99:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9e:	31 d2                	xor    %edx,%edx
  800da0:	f7 f3                	div    %ebx
  800da2:	89 c1                	mov    %eax,%ecx
  800da4:	31 d2                	xor    %edx,%edx
  800da6:	89 f0                	mov    %esi,%eax
  800da8:	f7 f1                	div    %ecx
  800daa:	89 c6                	mov    %eax,%esi
  800dac:	89 e8                	mov    %ebp,%eax
  800dae:	89 f7                	mov    %esi,%edi
  800db0:	f7 f1                	div    %ecx
  800db2:	89 fa                	mov    %edi,%edx
  800db4:	83 c4 1c             	add    $0x1c,%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    
  800dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800dc0:	39 f2                	cmp    %esi,%edx
  800dc2:	77 7c                	ja     800e40 <__udivdi3+0xd0>
  800dc4:	0f bd fa             	bsr    %edx,%edi
  800dc7:	83 f7 1f             	xor    $0x1f,%edi
  800dca:	0f 84 98 00 00 00    	je     800e68 <__udivdi3+0xf8>
  800dd0:	89 f9                	mov    %edi,%ecx
  800dd2:	b8 20 00 00 00       	mov    $0x20,%eax
  800dd7:	29 f8                	sub    %edi,%eax
  800dd9:	d3 e2                	shl    %cl,%edx
  800ddb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ddf:	89 c1                	mov    %eax,%ecx
  800de1:	89 da                	mov    %ebx,%edx
  800de3:	d3 ea                	shr    %cl,%edx
  800de5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800de9:	09 d1                	or     %edx,%ecx
  800deb:	89 f2                	mov    %esi,%edx
  800ded:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800df1:	89 f9                	mov    %edi,%ecx
  800df3:	d3 e3                	shl    %cl,%ebx
  800df5:	89 c1                	mov    %eax,%ecx
  800df7:	d3 ea                	shr    %cl,%edx
  800df9:	89 f9                	mov    %edi,%ecx
  800dfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800dff:	d3 e6                	shl    %cl,%esi
  800e01:	89 eb                	mov    %ebp,%ebx
  800e03:	89 c1                	mov    %eax,%ecx
  800e05:	d3 eb                	shr    %cl,%ebx
  800e07:	09 de                	or     %ebx,%esi
  800e09:	89 f0                	mov    %esi,%eax
  800e0b:	f7 74 24 08          	divl   0x8(%esp)
  800e0f:	89 d6                	mov    %edx,%esi
  800e11:	89 c3                	mov    %eax,%ebx
  800e13:	f7 64 24 0c          	mull   0xc(%esp)
  800e17:	39 d6                	cmp    %edx,%esi
  800e19:	72 0c                	jb     800e27 <__udivdi3+0xb7>
  800e1b:	89 f9                	mov    %edi,%ecx
  800e1d:	d3 e5                	shl    %cl,%ebp
  800e1f:	39 c5                	cmp    %eax,%ebp
  800e21:	73 5d                	jae    800e80 <__udivdi3+0x110>
  800e23:	39 d6                	cmp    %edx,%esi
  800e25:	75 59                	jne    800e80 <__udivdi3+0x110>
  800e27:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e2a:	31 ff                	xor    %edi,%edi
  800e2c:	89 fa                	mov    %edi,%edx
  800e2e:	83 c4 1c             	add    $0x1c,%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
  800e36:	8d 76 00             	lea    0x0(%esi),%esi
  800e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e40:	31 ff                	xor    %edi,%edi
  800e42:	31 c0                	xor    %eax,%eax
  800e44:	89 fa                	mov    %edi,%edx
  800e46:	83 c4 1c             	add    $0x1c,%esp
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    
  800e4e:	66 90                	xchg   %ax,%ax
  800e50:	31 ff                	xor    %edi,%edi
  800e52:	89 e8                	mov    %ebp,%eax
  800e54:	89 f2                	mov    %esi,%edx
  800e56:	f7 f3                	div    %ebx
  800e58:	89 fa                	mov    %edi,%edx
  800e5a:	83 c4 1c             	add    $0x1c,%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
  800e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e68:	39 f2                	cmp    %esi,%edx
  800e6a:	72 06                	jb     800e72 <__udivdi3+0x102>
  800e6c:	31 c0                	xor    %eax,%eax
  800e6e:	39 eb                	cmp    %ebp,%ebx
  800e70:	77 d2                	ja     800e44 <__udivdi3+0xd4>
  800e72:	b8 01 00 00 00       	mov    $0x1,%eax
  800e77:	eb cb                	jmp    800e44 <__udivdi3+0xd4>
  800e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e80:	89 d8                	mov    %ebx,%eax
  800e82:	31 ff                	xor    %edi,%edi
  800e84:	eb be                	jmp    800e44 <__udivdi3+0xd4>
  800e86:	66 90                	xchg   %ax,%ax
  800e88:	66 90                	xchg   %ax,%ax
  800e8a:	66 90                	xchg   %ax,%ax
  800e8c:	66 90                	xchg   %ax,%ax
  800e8e:	66 90                	xchg   %ax,%ax

00800e90 <__umoddi3>:
  800e90:	55                   	push   %ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 1c             	sub    $0x1c,%esp
  800e97:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800e9b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800e9f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ea3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ea7:	85 ed                	test   %ebp,%ebp
  800ea9:	89 f0                	mov    %esi,%eax
  800eab:	89 da                	mov    %ebx,%edx
  800ead:	75 19                	jne    800ec8 <__umoddi3+0x38>
  800eaf:	39 df                	cmp    %ebx,%edi
  800eb1:	0f 86 b1 00 00 00    	jbe    800f68 <__umoddi3+0xd8>
  800eb7:	f7 f7                	div    %edi
  800eb9:	89 d0                	mov    %edx,%eax
  800ebb:	31 d2                	xor    %edx,%edx
  800ebd:	83 c4 1c             	add    $0x1c,%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
  800ec5:	8d 76 00             	lea    0x0(%esi),%esi
  800ec8:	39 dd                	cmp    %ebx,%ebp
  800eca:	77 f1                	ja     800ebd <__umoddi3+0x2d>
  800ecc:	0f bd cd             	bsr    %ebp,%ecx
  800ecf:	83 f1 1f             	xor    $0x1f,%ecx
  800ed2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ed6:	0f 84 b4 00 00 00    	je     800f90 <__umoddi3+0x100>
  800edc:	b8 20 00 00 00       	mov    $0x20,%eax
  800ee1:	89 c2                	mov    %eax,%edx
  800ee3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ee7:	29 c2                	sub    %eax,%edx
  800ee9:	89 c1                	mov    %eax,%ecx
  800eeb:	89 f8                	mov    %edi,%eax
  800eed:	d3 e5                	shl    %cl,%ebp
  800eef:	89 d1                	mov    %edx,%ecx
  800ef1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ef5:	d3 e8                	shr    %cl,%eax
  800ef7:	09 c5                	or     %eax,%ebp
  800ef9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800efd:	89 c1                	mov    %eax,%ecx
  800eff:	d3 e7                	shl    %cl,%edi
  800f01:	89 d1                	mov    %edx,%ecx
  800f03:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f07:	89 df                	mov    %ebx,%edi
  800f09:	d3 ef                	shr    %cl,%edi
  800f0b:	89 c1                	mov    %eax,%ecx
  800f0d:	89 f0                	mov    %esi,%eax
  800f0f:	d3 e3                	shl    %cl,%ebx
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 fa                	mov    %edi,%edx
  800f15:	d3 e8                	shr    %cl,%eax
  800f17:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f1c:	09 d8                	or     %ebx,%eax
  800f1e:	f7 f5                	div    %ebp
  800f20:	d3 e6                	shl    %cl,%esi
  800f22:	89 d1                	mov    %edx,%ecx
  800f24:	f7 64 24 08          	mull   0x8(%esp)
  800f28:	39 d1                	cmp    %edx,%ecx
  800f2a:	89 c3                	mov    %eax,%ebx
  800f2c:	89 d7                	mov    %edx,%edi
  800f2e:	72 06                	jb     800f36 <__umoddi3+0xa6>
  800f30:	75 0e                	jne    800f40 <__umoddi3+0xb0>
  800f32:	39 c6                	cmp    %eax,%esi
  800f34:	73 0a                	jae    800f40 <__umoddi3+0xb0>
  800f36:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f3a:	19 ea                	sbb    %ebp,%edx
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	89 c3                	mov    %eax,%ebx
  800f40:	89 ca                	mov    %ecx,%edx
  800f42:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f47:	29 de                	sub    %ebx,%esi
  800f49:	19 fa                	sbb    %edi,%edx
  800f4b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f4f:	89 d0                	mov    %edx,%eax
  800f51:	d3 e0                	shl    %cl,%eax
  800f53:	89 d9                	mov    %ebx,%ecx
  800f55:	d3 ee                	shr    %cl,%esi
  800f57:	d3 ea                	shr    %cl,%edx
  800f59:	09 f0                	or     %esi,%eax
  800f5b:	83 c4 1c             	add    $0x1c,%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
  800f63:	90                   	nop
  800f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f68:	85 ff                	test   %edi,%edi
  800f6a:	89 f9                	mov    %edi,%ecx
  800f6c:	75 0b                	jne    800f79 <__umoddi3+0xe9>
  800f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f73:	31 d2                	xor    %edx,%edx
  800f75:	f7 f7                	div    %edi
  800f77:	89 c1                	mov    %eax,%ecx
  800f79:	89 d8                	mov    %ebx,%eax
  800f7b:	31 d2                	xor    %edx,%edx
  800f7d:	f7 f1                	div    %ecx
  800f7f:	89 f0                	mov    %esi,%eax
  800f81:	f7 f1                	div    %ecx
  800f83:	e9 31 ff ff ff       	jmp    800eb9 <__umoddi3+0x29>
  800f88:	90                   	nop
  800f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f90:	39 dd                	cmp    %ebx,%ebp
  800f92:	72 08                	jb     800f9c <__umoddi3+0x10c>
  800f94:	39 f7                	cmp    %esi,%edi
  800f96:	0f 87 21 ff ff ff    	ja     800ebd <__umoddi3+0x2d>
  800f9c:	89 da                	mov    %ebx,%edx
  800f9e:	89 f0                	mov    %esi,%eax
  800fa0:	29 f8                	sub    %edi,%eax
  800fa2:	19 ea                	sbb    %ebp,%edx
  800fa4:	e9 14 ff ff ff       	jmp    800ebd <__umoddi3+0x2d>
