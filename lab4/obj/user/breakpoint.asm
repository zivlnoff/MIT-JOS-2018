
obj/user/breakpoint：     文件格式 elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	83 ec 08             	sub    $0x8,%esp
  80003f:	8b 45 08             	mov    0x8(%ebp),%eax
  800042:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800045:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  80004c:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80004f:	85 c0                	test   %eax,%eax
  800051:	7e 08                	jle    80005b <libmain+0x22>
		binaryname = argv[0];
  800053:	8b 0a                	mov    (%edx),%ecx
  800055:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  80005b:	83 ec 08             	sub    $0x8,%esp
  80005e:	52                   	push   %edx
  80005f:	50                   	push   %eax
  800060:	e8 ce ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800065:	e8 05 00 00 00       	call   80006f <exit>
}
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800075:	6a 00                	push   $0x0
  800077:	e8 42 00 00 00       	call   8000be <sys_env_destroy>
}
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	c9                   	leave  
  800080:	c3                   	ret    

00800081 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800081:	55                   	push   %ebp
  800082:	89 e5                	mov    %esp,%ebp
  800084:	57                   	push   %edi
  800085:	56                   	push   %esi
  800086:	53                   	push   %ebx
    asm volatile("int %1\n"
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	8b 55 08             	mov    0x8(%ebp),%edx
  80008f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800092:	89 c3                	mov    %eax,%ebx
  800094:	89 c7                	mov    %eax,%edi
  800096:	89 c6                	mov    %eax,%esi
  800098:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  80009a:	5b                   	pop    %ebx
  80009b:	5e                   	pop    %esi
  80009c:	5f                   	pop    %edi
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    

0080009f <sys_cgetc>:

int
sys_cgetc(void) {
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8000af:	89 d1                	mov    %edx,%ecx
  8000b1:	89 d3                	mov    %edx,%ebx
  8000b3:	89 d7                	mov    %edx,%edi
  8000b5:	89 d6                	mov    %edx,%esi
  8000b7:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5f                   	pop    %edi
  8000bc:	5d                   	pop    %ebp
  8000bd:	c3                   	ret    

008000be <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	57                   	push   %edi
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8000d4:	89 cb                	mov    %ecx,%ebx
  8000d6:	89 cf                	mov    %ecx,%edi
  8000d8:	89 ce                	mov    %ecx,%esi
  8000da:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	7f 08                	jg     8000e8 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5f                   	pop    %edi
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	6a 03                	push   $0x3
  8000ee:	68 ca 0f 80 00       	push   $0x800fca
  8000f3:	6a 24                	push   $0x24
  8000f5:	68 e7 0f 80 00       	push   $0x800fe7
  8000fa:	e8 ed 01 00 00       	call   8002ec <_panic>

008000ff <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
    asm volatile("int %1\n"
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	b8 02 00 00 00       	mov    $0x2,%eax
  80010f:	89 d1                	mov    %edx,%ecx
  800111:	89 d3                	mov    %edx,%ebx
  800113:	89 d7                	mov    %edx,%edi
  800115:	89 d6                	mov    %edx,%esi
  800117:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800119:	5b                   	pop    %ebx
  80011a:	5e                   	pop    %esi
  80011b:	5f                   	pop    %edi
  80011c:	5d                   	pop    %ebp
  80011d:	c3                   	ret    

0080011e <sys_yield>:

void
sys_yield(void)
{
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	57                   	push   %edi
  800122:	56                   	push   %esi
  800123:	53                   	push   %ebx
    asm volatile("int %1\n"
  800124:	ba 00 00 00 00       	mov    $0x0,%edx
  800129:	b8 0a 00 00 00       	mov    $0xa,%eax
  80012e:	89 d1                	mov    %edx,%ecx
  800130:	89 d3                	mov    %edx,%ebx
  800132:	89 d7                	mov    %edx,%edi
  800134:	89 d6                	mov    %edx,%esi
  800136:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5f                   	pop    %edi
  80013b:	5d                   	pop    %ebp
  80013c:	c3                   	ret    

0080013d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	57                   	push   %edi
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800146:	be 00 00 00 00       	mov    $0x0,%esi
  80014b:	8b 55 08             	mov    0x8(%ebp),%edx
  80014e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800151:	b8 04 00 00 00       	mov    $0x4,%eax
  800156:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800159:	89 f7                	mov    %esi,%edi
  80015b:	cd 30                	int    $0x30
    if (check && ret > 0)
  80015d:	85 c0                	test   %eax,%eax
  80015f:	7f 08                	jg     800169 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	50                   	push   %eax
  80016d:	6a 04                	push   $0x4
  80016f:	68 ca 0f 80 00       	push   $0x800fca
  800174:	6a 24                	push   $0x24
  800176:	68 e7 0f 80 00       	push   $0x800fe7
  80017b:	e8 6c 01 00 00       	call   8002ec <_panic>

00800180 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800189:	8b 55 08             	mov    0x8(%ebp),%edx
  80018c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018f:	b8 05 00 00 00       	mov    $0x5,%eax
  800194:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800197:	8b 7d 14             	mov    0x14(%ebp),%edi
  80019a:	8b 75 18             	mov    0x18(%ebp),%esi
  80019d:	cd 30                	int    $0x30
    if (check && ret > 0)
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	7f 08                	jg     8001ab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a6:	5b                   	pop    %ebx
  8001a7:	5e                   	pop    %esi
  8001a8:	5f                   	pop    %edi
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	6a 05                	push   $0x5
  8001b1:	68 ca 0f 80 00       	push   $0x800fca
  8001b6:	6a 24                	push   $0x24
  8001b8:	68 e7 0f 80 00       	push   $0x800fe7
  8001bd:	e8 2a 01 00 00       	call   8002ec <_panic>

008001c2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8001db:	89 df                	mov    %ebx,%edi
  8001dd:	89 de                	mov    %ebx,%esi
  8001df:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	7f 08                	jg     8001ed <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	50                   	push   %eax
  8001f1:	6a 06                	push   $0x6
  8001f3:	68 ca 0f 80 00       	push   $0x800fca
  8001f8:	6a 24                	push   $0x24
  8001fa:	68 e7 0f 80 00       	push   $0x800fe7
  8001ff:	e8 e8 00 00 00       	call   8002ec <_panic>

00800204 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80020d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800212:	8b 55 08             	mov    0x8(%ebp),%edx
  800215:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800218:	b8 08 00 00 00       	mov    $0x8,%eax
  80021d:	89 df                	mov    %ebx,%edi
  80021f:	89 de                	mov    %ebx,%esi
  800221:	cd 30                	int    $0x30
    if (check && ret > 0)
  800223:	85 c0                	test   %eax,%eax
  800225:	7f 08                	jg     80022f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800227:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022a:	5b                   	pop    %ebx
  80022b:	5e                   	pop    %esi
  80022c:	5f                   	pop    %edi
  80022d:	5d                   	pop    %ebp
  80022e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	50                   	push   %eax
  800233:	6a 08                	push   $0x8
  800235:	68 ca 0f 80 00       	push   $0x800fca
  80023a:	6a 24                	push   $0x24
  80023c:	68 e7 0f 80 00       	push   $0x800fe7
  800241:	e8 a6 00 00 00       	call   8002ec <_panic>

00800246 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	57                   	push   %edi
  80024a:	56                   	push   %esi
  80024b:	53                   	push   %ebx
  80024c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80024f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800254:	8b 55 08             	mov    0x8(%ebp),%edx
  800257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025a:	b8 09 00 00 00       	mov    $0x9,%eax
  80025f:	89 df                	mov    %ebx,%edi
  800261:	89 de                	mov    %ebx,%esi
  800263:	cd 30                	int    $0x30
    if (check && ret > 0)
  800265:	85 c0                	test   %eax,%eax
  800267:	7f 08                	jg     800271 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5f                   	pop    %edi
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	50                   	push   %eax
  800275:	6a 09                	push   $0x9
  800277:	68 ca 0f 80 00       	push   $0x800fca
  80027c:	6a 24                	push   $0x24
  80027e:	68 e7 0f 80 00       	push   $0x800fe7
  800283:	e8 64 00 00 00       	call   8002ec <_panic>

00800288 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	57                   	push   %edi
  80028c:	56                   	push   %esi
  80028d:	53                   	push   %ebx
    asm volatile("int %1\n"
  80028e:	8b 55 08             	mov    0x8(%ebp),%edx
  800291:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800294:	b8 0b 00 00 00       	mov    $0xb,%eax
  800299:	be 00 00 00 00       	mov    $0x0,%esi
  80029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002a1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002a4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5f                   	pop    %edi
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	57                   	push   %edi
  8002af:	56                   	push   %esi
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bc:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002c1:	89 cb                	mov    %ecx,%ebx
  8002c3:	89 cf                	mov    %ecx,%edi
  8002c5:	89 ce                	mov    %ecx,%esi
  8002c7:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	7f 08                	jg     8002d5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	50                   	push   %eax
  8002d9:	6a 0c                	push   $0xc
  8002db:	68 ca 0f 80 00       	push   $0x800fca
  8002e0:	6a 24                	push   $0x24
  8002e2:	68 e7 0f 80 00       	push   $0x800fe7
  8002e7:	e8 00 00 00 00       	call   8002ec <_panic>

008002ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002f1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f4:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8002fa:	e8 00 fe ff ff       	call   8000ff <sys_getenvid>
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	ff 75 0c             	pushl  0xc(%ebp)
  800305:	ff 75 08             	pushl  0x8(%ebp)
  800308:	56                   	push   %esi
  800309:	50                   	push   %eax
  80030a:	68 f8 0f 80 00       	push   $0x800ff8
  80030f:	e8 b3 00 00 00       	call   8003c7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800314:	83 c4 18             	add    $0x18,%esp
  800317:	53                   	push   %ebx
  800318:	ff 75 10             	pushl  0x10(%ebp)
  80031b:	e8 56 00 00 00       	call   800376 <vcprintf>
	cprintf("\n");
  800320:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800327:	e8 9b 00 00 00       	call   8003c7 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80032f:	cc                   	int3   
  800330:	eb fd                	jmp    80032f <_panic+0x43>

00800332 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	53                   	push   %ebx
  800336:	83 ec 04             	sub    $0x4,%esp
  800339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80033c:	8b 13                	mov    (%ebx),%edx
  80033e:	8d 42 01             	lea    0x1(%edx),%eax
  800341:	89 03                	mov    %eax,(%ebx)
  800343:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800346:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80034a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80034f:	74 09                	je     80035a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800351:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800358:	c9                   	leave  
  800359:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	68 ff 00 00 00       	push   $0xff
  800362:	8d 43 08             	lea    0x8(%ebx),%eax
  800365:	50                   	push   %eax
  800366:	e8 16 fd ff ff       	call   800081 <sys_cputs>
		b->idx = 0;
  80036b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	eb db                	jmp    800351 <putch+0x1f>

00800376 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80037f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800386:	00 00 00 
	b.cnt = 0;
  800389:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800390:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800393:	ff 75 0c             	pushl  0xc(%ebp)
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80039f:	50                   	push   %eax
  8003a0:	68 32 03 80 00       	push   $0x800332
  8003a5:	e8 1a 01 00 00       	call   8004c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003aa:	83 c4 08             	add    $0x8,%esp
  8003ad:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003b9:	50                   	push   %eax
  8003ba:	e8 c2 fc ff ff       	call   800081 <sys_cputs>

	return b.cnt;
}
  8003bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003c5:	c9                   	leave  
  8003c6:	c3                   	ret    

008003c7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003cd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d0:	50                   	push   %eax
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 9d ff ff ff       	call   800376 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	57                   	push   %edi
  8003df:	56                   	push   %esi
  8003e0:	53                   	push   %ebx
  8003e1:	83 ec 1c             	sub    $0x1c,%esp
  8003e4:	89 c7                	mov    %eax,%edi
  8003e6:	89 d6                	mov    %edx,%esi
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8003f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003fc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800402:	39 d3                	cmp    %edx,%ebx
  800404:	72 05                	jb     80040b <printnum+0x30>
  800406:	39 45 10             	cmp    %eax,0x10(%ebp)
  800409:	77 7a                	ja     800485 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	ff 75 18             	pushl  0x18(%ebp)
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800417:	53                   	push   %ebx
  800418:	ff 75 10             	pushl  0x10(%ebp)
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800421:	ff 75 e0             	pushl  -0x20(%ebp)
  800424:	ff 75 dc             	pushl  -0x24(%ebp)
  800427:	ff 75 d8             	pushl  -0x28(%ebp)
  80042a:	e8 41 09 00 00       	call   800d70 <__udivdi3>
  80042f:	83 c4 18             	add    $0x18,%esp
  800432:	52                   	push   %edx
  800433:	50                   	push   %eax
  800434:	89 f2                	mov    %esi,%edx
  800436:	89 f8                	mov    %edi,%eax
  800438:	e8 9e ff ff ff       	call   8003db <printnum>
  80043d:	83 c4 20             	add    $0x20,%esp
  800440:	eb 13                	jmp    800455 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	56                   	push   %esi
  800446:	ff 75 18             	pushl  0x18(%ebp)
  800449:	ff d7                	call   *%edi
  80044b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80044e:	83 eb 01             	sub    $0x1,%ebx
  800451:	85 db                	test   %ebx,%ebx
  800453:	7f ed                	jg     800442 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	56                   	push   %esi
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045f:	ff 75 e0             	pushl  -0x20(%ebp)
  800462:	ff 75 dc             	pushl  -0x24(%ebp)
  800465:	ff 75 d8             	pushl  -0x28(%ebp)
  800468:	e8 23 0a 00 00       	call   800e90 <__umoddi3>
  80046d:	83 c4 14             	add    $0x14,%esp
  800470:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800477:	50                   	push   %eax
  800478:	ff d7                	call   *%edi
}
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800480:	5b                   	pop    %ebx
  800481:	5e                   	pop    %esi
  800482:	5f                   	pop    %edi
  800483:	5d                   	pop    %ebp
  800484:	c3                   	ret    
  800485:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800488:	eb c4                	jmp    80044e <printnum+0x73>

0080048a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800490:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800494:	8b 10                	mov    (%eax),%edx
  800496:	3b 50 04             	cmp    0x4(%eax),%edx
  800499:	73 0a                	jae    8004a5 <sprintputch+0x1b>
		*b->buf++ = ch;
  80049b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80049e:	89 08                	mov    %ecx,(%eax)
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	88 02                	mov    %al,(%edx)
}
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    

008004a7 <printfmt>:
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ad:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b0:	50                   	push   %eax
  8004b1:	ff 75 10             	pushl  0x10(%ebp)
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	ff 75 08             	pushl  0x8(%ebp)
  8004ba:	e8 05 00 00 00       	call   8004c4 <vprintfmt>
}
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <vprintfmt>:
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	57                   	push   %edi
  8004c8:	56                   	push   %esi
  8004c9:	53                   	push   %ebx
  8004ca:	83 ec 2c             	sub    $0x2c,%esp
  8004cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004d6:	e9 00 04 00 00       	jmp    8008db <vprintfmt+0x417>
		padc = ' ';
  8004db:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004e6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	8d 47 01             	lea    0x1(%edi),%eax
  8004fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ff:	0f b6 17             	movzbl (%edi),%edx
  800502:	8d 42 dd             	lea    -0x23(%edx),%eax
  800505:	3c 55                	cmp    $0x55,%al
  800507:	0f 87 51 04 00 00    	ja     80095e <vprintfmt+0x49a>
  80050d:	0f b6 c0             	movzbl %al,%eax
  800510:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800517:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80051a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80051e:	eb d9                	jmp    8004f9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800520:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800523:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800527:	eb d0                	jmp    8004f9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800529:	0f b6 d2             	movzbl %dl,%edx
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80052f:	b8 00 00 00 00       	mov    $0x0,%eax
  800534:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800537:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80053a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80053e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800541:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800544:	83 f9 09             	cmp    $0x9,%ecx
  800547:	77 55                	ja     80059e <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800549:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80054c:	eb e9                	jmp    800537 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8d 40 04             	lea    0x4(%eax),%eax
  80055c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800562:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800566:	79 91                	jns    8004f9 <vprintfmt+0x35>
				width = precision, precision = -1;
  800568:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800575:	eb 82                	jmp    8004f9 <vprintfmt+0x35>
  800577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	ba 00 00 00 00       	mov    $0x0,%edx
  800581:	0f 49 d0             	cmovns %eax,%edx
  800584:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058a:	e9 6a ff ff ff       	jmp    8004f9 <vprintfmt+0x35>
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800592:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800599:	e9 5b ff ff ff       	jmp    8004f9 <vprintfmt+0x35>
  80059e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a4:	eb bc                	jmp    800562 <vprintfmt+0x9e>
			lflag++;
  8005a6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ac:	e9 48 ff ff ff       	jmp    8004f9 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8d 78 04             	lea    0x4(%eax),%edi
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	53                   	push   %ebx
  8005bb:	ff 30                	pushl  (%eax)
  8005bd:	ff d6                	call   *%esi
			break;
  8005bf:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005c2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005c5:	e9 0e 03 00 00       	jmp    8008d8 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 78 04             	lea    0x4(%eax),%edi
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	99                   	cltd   
  8005d3:	31 d0                	xor    %edx,%eax
  8005d5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005d7:	83 f8 08             	cmp    $0x8,%eax
  8005da:	7f 23                	jg     8005ff <vprintfmt+0x13b>
  8005dc:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005e3:	85 d2                	test   %edx,%edx
  8005e5:	74 18                	je     8005ff <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005e7:	52                   	push   %edx
  8005e8:	68 3f 10 80 00       	push   $0x80103f
  8005ed:	53                   	push   %ebx
  8005ee:	56                   	push   %esi
  8005ef:	e8 b3 fe ff ff       	call   8004a7 <printfmt>
  8005f4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005fa:	e9 d9 02 00 00       	jmp    8008d8 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  8005ff:	50                   	push   %eax
  800600:	68 36 10 80 00       	push   $0x801036
  800605:	53                   	push   %ebx
  800606:	56                   	push   %esi
  800607:	e8 9b fe ff ff       	call   8004a7 <printfmt>
  80060c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80060f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800612:	e9 c1 02 00 00       	jmp    8008d8 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	83 c0 04             	add    $0x4,%eax
  80061d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800625:	85 ff                	test   %edi,%edi
  800627:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  80062c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80062f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800633:	0f 8e bd 00 00 00    	jle    8006f6 <vprintfmt+0x232>
  800639:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80063d:	75 0e                	jne    80064d <vprintfmt+0x189>
  80063f:	89 75 08             	mov    %esi,0x8(%ebp)
  800642:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800645:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800648:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064b:	eb 6d                	jmp    8006ba <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	ff 75 d0             	pushl  -0x30(%ebp)
  800653:	57                   	push   %edi
  800654:	e8 ad 03 00 00       	call   800a06 <strnlen>
  800659:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065c:	29 c1                	sub    %eax,%ecx
  80065e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800661:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800664:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80066b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80066e:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800670:	eb 0f                	jmp    800681 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	53                   	push   %ebx
  800676:	ff 75 e0             	pushl  -0x20(%ebp)
  800679:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80067b:	83 ef 01             	sub    $0x1,%edi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	85 ff                	test   %edi,%edi
  800683:	7f ed                	jg     800672 <vprintfmt+0x1ae>
  800685:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800688:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80068b:	85 c9                	test   %ecx,%ecx
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	0f 49 c1             	cmovns %ecx,%eax
  800695:	29 c1                	sub    %eax,%ecx
  800697:	89 75 08             	mov    %esi,0x8(%ebp)
  80069a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80069d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a0:	89 cb                	mov    %ecx,%ebx
  8006a2:	eb 16                	jmp    8006ba <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a8:	75 31                	jne    8006db <vprintfmt+0x217>
					putch(ch, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	50                   	push   %eax
  8006b1:	ff 55 08             	call   *0x8(%ebp)
  8006b4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b7:	83 eb 01             	sub    $0x1,%ebx
  8006ba:	83 c7 01             	add    $0x1,%edi
  8006bd:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006c1:	0f be c2             	movsbl %dl,%eax
  8006c4:	85 c0                	test   %eax,%eax
  8006c6:	74 59                	je     800721 <vprintfmt+0x25d>
  8006c8:	85 f6                	test   %esi,%esi
  8006ca:	78 d8                	js     8006a4 <vprintfmt+0x1e0>
  8006cc:	83 ee 01             	sub    $0x1,%esi
  8006cf:	79 d3                	jns    8006a4 <vprintfmt+0x1e0>
  8006d1:	89 df                	mov    %ebx,%edi
  8006d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d9:	eb 37                	jmp    800712 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006db:	0f be d2             	movsbl %dl,%edx
  8006de:	83 ea 20             	sub    $0x20,%edx
  8006e1:	83 fa 5e             	cmp    $0x5e,%edx
  8006e4:	76 c4                	jbe    8006aa <vprintfmt+0x1e6>
					putch('?', putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	6a 3f                	push   $0x3f
  8006ee:	ff 55 08             	call   *0x8(%ebp)
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb c1                	jmp    8006b7 <vprintfmt+0x1f3>
  8006f6:	89 75 08             	mov    %esi,0x8(%ebp)
  8006f9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006fc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800702:	eb b6                	jmp    8006ba <vprintfmt+0x1f6>
				putch(' ', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	6a 20                	push   $0x20
  80070a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80070c:	83 ef 01             	sub    $0x1,%edi
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	85 ff                	test   %edi,%edi
  800714:	7f ee                	jg     800704 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800716:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
  80071c:	e9 b7 01 00 00       	jmp    8008d8 <vprintfmt+0x414>
  800721:	89 df                	mov    %ebx,%edi
  800723:	8b 75 08             	mov    0x8(%ebp),%esi
  800726:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800729:	eb e7                	jmp    800712 <vprintfmt+0x24e>
	if (lflag >= 2)
  80072b:	83 f9 01             	cmp    $0x1,%ecx
  80072e:	7e 3f                	jle    80076f <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 50 04             	mov    0x4(%eax),%edx
  800736:	8b 00                	mov    (%eax),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 08             	lea    0x8(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800747:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074b:	79 5c                	jns    8007a9 <vprintfmt+0x2e5>
				putch('-', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 2d                	push   $0x2d
  800753:	ff d6                	call   *%esi
				num = -(long long) num;
  800755:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800758:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80075b:	f7 da                	neg    %edx
  80075d:	83 d1 00             	adc    $0x0,%ecx
  800760:	f7 d9                	neg    %ecx
  800762:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800765:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076a:	e9 4f 01 00 00       	jmp    8008be <vprintfmt+0x3fa>
	else if (lflag)
  80076f:	85 c9                	test   %ecx,%ecx
  800771:	75 1b                	jne    80078e <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077b:	89 c1                	mov    %eax,%ecx
  80077d:	c1 f9 1f             	sar    $0x1f,%ecx
  800780:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
  80078c:	eb b9                	jmp    800747 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 c1                	mov    %eax,%ecx
  800798:	c1 f9 1f             	sar    $0x1f,%ecx
  80079b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	eb 9e                	jmp    800747 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b4:	e9 05 01 00 00       	jmp    8008be <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007b9:	83 f9 01             	cmp    $0x1,%ecx
  8007bc:	7e 18                	jle    8007d6 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 10                	mov    (%eax),%edx
  8007c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c6:	8d 40 08             	lea    0x8(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d1:	e9 e8 00 00 00       	jmp    8008be <vprintfmt+0x3fa>
	else if (lflag)
  8007d6:	85 c9                	test   %ecx,%ecx
  8007d8:	75 1a                	jne    8007f4 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 10                	mov    (%eax),%edx
  8007df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e4:	8d 40 04             	lea    0x4(%eax),%eax
  8007e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ef:	e9 ca 00 00 00       	jmp    8008be <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 10                	mov    (%eax),%edx
  8007f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fe:	8d 40 04             	lea    0x4(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800804:	b8 0a 00 00 00       	mov    $0xa,%eax
  800809:	e9 b0 00 00 00       	jmp    8008be <vprintfmt+0x3fa>
	if (lflag >= 2)
  80080e:	83 f9 01             	cmp    $0x1,%ecx
  800811:	7e 3c                	jle    80084f <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 50 04             	mov    0x4(%eax),%edx
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8d 40 08             	lea    0x8(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80082a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082e:	79 59                	jns    800889 <vprintfmt+0x3c5>
                putch('-', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 2d                	push   $0x2d
  800836:	ff d6                	call   *%esi
                num = -(long long) num;
  800838:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80083b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80083e:	f7 da                	neg    %edx
  800840:	83 d1 00             	adc    $0x0,%ecx
  800843:	f7 d9                	neg    %ecx
  800845:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800848:	b8 08 00 00 00       	mov    $0x8,%eax
  80084d:	eb 6f                	jmp    8008be <vprintfmt+0x3fa>
	else if (lflag)
  80084f:	85 c9                	test   %ecx,%ecx
  800851:	75 1b                	jne    80086e <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085b:	89 c1                	mov    %eax,%ecx
  80085d:	c1 f9 1f             	sar    $0x1f,%ecx
  800860:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8d 40 04             	lea    0x4(%eax),%eax
  800869:	89 45 14             	mov    %eax,0x14(%ebp)
  80086c:	eb bc                	jmp    80082a <vprintfmt+0x366>
		return va_arg(*ap, long);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800876:	89 c1                	mov    %eax,%ecx
  800878:	c1 f9 1f             	sar    $0x1f,%ecx
  80087b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 40 04             	lea    0x4(%eax),%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	eb a1                	jmp    80082a <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800889:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80088c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80088f:	b8 08 00 00 00       	mov    $0x8,%eax
  800894:	eb 28                	jmp    8008be <vprintfmt+0x3fa>
			putch('0', putdat);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	53                   	push   %ebx
  80089a:	6a 30                	push   $0x30
  80089c:	ff d6                	call   *%esi
			putch('x', putdat);
  80089e:	83 c4 08             	add    $0x8,%esp
  8008a1:	53                   	push   %ebx
  8008a2:	6a 78                	push   $0x78
  8008a4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 10                	mov    (%eax),%edx
  8008ab:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b3:	8d 40 04             	lea    0x4(%eax),%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008be:	83 ec 0c             	sub    $0xc,%esp
  8008c1:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008c5:	57                   	push   %edi
  8008c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c9:	50                   	push   %eax
  8008ca:	51                   	push   %ecx
  8008cb:	52                   	push   %edx
  8008cc:	89 da                	mov    %ebx,%edx
  8008ce:	89 f0                	mov    %esi,%eax
  8008d0:	e8 06 fb ff ff       	call   8003db <printnum>
			break;
  8008d5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008db:	83 c7 01             	add    $0x1,%edi
  8008de:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e2:	83 f8 25             	cmp    $0x25,%eax
  8008e5:	0f 84 f0 fb ff ff    	je     8004db <vprintfmt+0x17>
			if (ch == '\0')
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	0f 84 8b 00 00 00    	je     80097e <vprintfmt+0x4ba>
			putch(ch, putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	53                   	push   %ebx
  8008f7:	50                   	push   %eax
  8008f8:	ff d6                	call   *%esi
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	eb dc                	jmp    8008db <vprintfmt+0x417>
	if (lflag >= 2)
  8008ff:	83 f9 01             	cmp    $0x1,%ecx
  800902:	7e 15                	jle    800919 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8b 10                	mov    (%eax),%edx
  800909:	8b 48 04             	mov    0x4(%eax),%ecx
  80090c:	8d 40 08             	lea    0x8(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800912:	b8 10 00 00 00       	mov    $0x10,%eax
  800917:	eb a5                	jmp    8008be <vprintfmt+0x3fa>
	else if (lflag)
  800919:	85 c9                	test   %ecx,%ecx
  80091b:	75 17                	jne    800934 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 10                	mov    (%eax),%edx
  800922:	b9 00 00 00 00       	mov    $0x0,%ecx
  800927:	8d 40 04             	lea    0x4(%eax),%eax
  80092a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092d:	b8 10 00 00 00       	mov    $0x10,%eax
  800932:	eb 8a                	jmp    8008be <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 10                	mov    (%eax),%edx
  800939:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093e:	8d 40 04             	lea    0x4(%eax),%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800944:	b8 10 00 00 00       	mov    $0x10,%eax
  800949:	e9 70 ff ff ff       	jmp    8008be <vprintfmt+0x3fa>
			putch(ch, putdat);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	53                   	push   %ebx
  800952:	6a 25                	push   $0x25
  800954:	ff d6                	call   *%esi
			break;
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	e9 7a ff ff ff       	jmp    8008d8 <vprintfmt+0x414>
			putch('%', putdat);
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	53                   	push   %ebx
  800962:	6a 25                	push   $0x25
  800964:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	89 f8                	mov    %edi,%eax
  80096b:	eb 03                	jmp    800970 <vprintfmt+0x4ac>
  80096d:	83 e8 01             	sub    $0x1,%eax
  800970:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800974:	75 f7                	jne    80096d <vprintfmt+0x4a9>
  800976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800979:	e9 5a ff ff ff       	jmp    8008d8 <vprintfmt+0x414>
}
  80097e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800981:	5b                   	pop    %ebx
  800982:	5e                   	pop    %esi
  800983:	5f                   	pop    %edi
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 18             	sub    $0x18,%esp
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800992:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800995:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800999:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a3:	85 c0                	test   %eax,%eax
  8009a5:	74 26                	je     8009cd <vsnprintf+0x47>
  8009a7:	85 d2                	test   %edx,%edx
  8009a9:	7e 22                	jle    8009cd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ab:	ff 75 14             	pushl  0x14(%ebp)
  8009ae:	ff 75 10             	pushl  0x10(%ebp)
  8009b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b4:	50                   	push   %eax
  8009b5:	68 8a 04 80 00       	push   $0x80048a
  8009ba:	e8 05 fb ff ff       	call   8004c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    
		return -E_INVAL;
  8009cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d2:	eb f7                	jmp    8009cb <vsnprintf+0x45>

008009d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009da:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009dd:	50                   	push   %eax
  8009de:	ff 75 10             	pushl  0x10(%ebp)
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	ff 75 08             	pushl  0x8(%ebp)
  8009e7:	e8 9a ff ff ff       	call   800986 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	eb 03                	jmp    8009fe <strlen+0x10>
		n++;
  8009fb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009fe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a02:	75 f7                	jne    8009fb <strlen+0xd>
	return n;
}
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a14:	eb 03                	jmp    800a19 <strnlen+0x13>
		n++;
  800a16:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	74 06                	je     800a23 <strnlen+0x1d>
  800a1d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a21:	75 f3                	jne    800a16 <strnlen+0x10>
	return n;
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	53                   	push   %ebx
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	83 c1 01             	add    $0x1,%ecx
  800a34:	83 c2 01             	add    $0x1,%edx
  800a37:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a3b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3e:	84 db                	test   %bl,%bl
  800a40:	75 ef                	jne    800a31 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a42:	5b                   	pop    %ebx
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	53                   	push   %ebx
  800a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a4c:	53                   	push   %ebx
  800a4d:	e8 9c ff ff ff       	call   8009ee <strlen>
  800a52:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	01 d8                	add    %ebx,%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 c5 ff ff ff       	call   800a25 <strcpy>
	return dst;
}
  800a60:	89 d8                	mov    %ebx,%eax
  800a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a65:	c9                   	leave  
  800a66:	c3                   	ret    

00800a67 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	56                   	push   %esi
  800a6b:	53                   	push   %ebx
  800a6c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a72:	89 f3                	mov    %esi,%ebx
  800a74:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a77:	89 f2                	mov    %esi,%edx
  800a79:	eb 0f                	jmp    800a8a <strncpy+0x23>
		*dst++ = *src;
  800a7b:	83 c2 01             	add    $0x1,%edx
  800a7e:	0f b6 01             	movzbl (%ecx),%eax
  800a81:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a84:	80 39 01             	cmpb   $0x1,(%ecx)
  800a87:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a8a:	39 da                	cmp    %ebx,%edx
  800a8c:	75 ed                	jne    800a7b <strncpy+0x14>
	}
	return ret;
}
  800a8e:	89 f0                	mov    %esi,%eax
  800a90:	5b                   	pop    %ebx
  800a91:	5e                   	pop    %esi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aa2:	89 f0                	mov    %esi,%eax
  800aa4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aa8:	85 c9                	test   %ecx,%ecx
  800aaa:	75 0b                	jne    800ab7 <strlcpy+0x23>
  800aac:	eb 17                	jmp    800ac5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	83 c0 01             	add    $0x1,%eax
  800ab4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ab7:	39 d8                	cmp    %ebx,%eax
  800ab9:	74 07                	je     800ac2 <strlcpy+0x2e>
  800abb:	0f b6 0a             	movzbl (%edx),%ecx
  800abe:	84 c9                	test   %cl,%cl
  800ac0:	75 ec                	jne    800aae <strlcpy+0x1a>
		*dst = '\0';
  800ac2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac5:	29 f0                	sub    %esi,%eax
}
  800ac7:	5b                   	pop    %ebx
  800ac8:	5e                   	pop    %esi
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ad4:	eb 06                	jmp    800adc <strcmp+0x11>
		p++, q++;
  800ad6:	83 c1 01             	add    $0x1,%ecx
  800ad9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800adc:	0f b6 01             	movzbl (%ecx),%eax
  800adf:	84 c0                	test   %al,%al
  800ae1:	74 04                	je     800ae7 <strcmp+0x1c>
  800ae3:	3a 02                	cmp    (%edx),%al
  800ae5:	74 ef                	je     800ad6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	0f b6 12             	movzbl (%edx),%edx
  800aed:	29 d0                	sub    %edx,%eax
}
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	53                   	push   %ebx
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afb:	89 c3                	mov    %eax,%ebx
  800afd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b00:	eb 06                	jmp    800b08 <strncmp+0x17>
		n--, p++, q++;
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b08:	39 d8                	cmp    %ebx,%eax
  800b0a:	74 16                	je     800b22 <strncmp+0x31>
  800b0c:	0f b6 08             	movzbl (%eax),%ecx
  800b0f:	84 c9                	test   %cl,%cl
  800b11:	74 04                	je     800b17 <strncmp+0x26>
  800b13:	3a 0a                	cmp    (%edx),%cl
  800b15:	74 eb                	je     800b02 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b17:	0f b6 00             	movzbl (%eax),%eax
  800b1a:	0f b6 12             	movzbl (%edx),%edx
  800b1d:	29 d0                	sub    %edx,%eax
}
  800b1f:	5b                   	pop    %ebx
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    
		return 0;
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
  800b27:	eb f6                	jmp    800b1f <strncmp+0x2e>

00800b29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b33:	0f b6 10             	movzbl (%eax),%edx
  800b36:	84 d2                	test   %dl,%dl
  800b38:	74 09                	je     800b43 <strchr+0x1a>
		if (*s == c)
  800b3a:	38 ca                	cmp    %cl,%dl
  800b3c:	74 0a                	je     800b48 <strchr+0x1f>
	for (; *s; s++)
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	eb f0                	jmp    800b33 <strchr+0xa>
			return (char *) s;
	return 0;
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b54:	eb 03                	jmp    800b59 <strfind+0xf>
  800b56:	83 c0 01             	add    $0x1,%eax
  800b59:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b5c:	38 ca                	cmp    %cl,%dl
  800b5e:	74 04                	je     800b64 <strfind+0x1a>
  800b60:	84 d2                	test   %dl,%dl
  800b62:	75 f2                	jne    800b56 <strfind+0xc>
			break;
	return (char *) s;
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b72:	85 c9                	test   %ecx,%ecx
  800b74:	74 13                	je     800b89 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b76:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b7c:	75 05                	jne    800b83 <memset+0x1d>
  800b7e:	f6 c1 03             	test   $0x3,%cl
  800b81:	74 0d                	je     800b90 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	fc                   	cld    
  800b87:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b89:	89 f8                	mov    %edi,%eax
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    
		c &= 0xFF;
  800b90:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b94:	89 d3                	mov    %edx,%ebx
  800b96:	c1 e3 08             	shl    $0x8,%ebx
  800b99:	89 d0                	mov    %edx,%eax
  800b9b:	c1 e0 18             	shl    $0x18,%eax
  800b9e:	89 d6                	mov    %edx,%esi
  800ba0:	c1 e6 10             	shl    $0x10,%esi
  800ba3:	09 f0                	or     %esi,%eax
  800ba5:	09 c2                	or     %eax,%edx
  800ba7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ba9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bac:	89 d0                	mov    %edx,%eax
  800bae:	fc                   	cld    
  800baf:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb1:	eb d6                	jmp    800b89 <memset+0x23>

00800bb3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc1:	39 c6                	cmp    %eax,%esi
  800bc3:	73 35                	jae    800bfa <memmove+0x47>
  800bc5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bc8:	39 c2                	cmp    %eax,%edx
  800bca:	76 2e                	jbe    800bfa <memmove+0x47>
		s += n;
		d += n;
  800bcc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcf:	89 d6                	mov    %edx,%esi
  800bd1:	09 fe                	or     %edi,%esi
  800bd3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bd9:	74 0c                	je     800be7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bdb:	83 ef 01             	sub    $0x1,%edi
  800bde:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be1:	fd                   	std    
  800be2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be4:	fc                   	cld    
  800be5:	eb 21                	jmp    800c08 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be7:	f6 c1 03             	test   $0x3,%cl
  800bea:	75 ef                	jne    800bdb <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bec:	83 ef 04             	sub    $0x4,%edi
  800bef:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf5:	fd                   	std    
  800bf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf8:	eb ea                	jmp    800be4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfa:	89 f2                	mov    %esi,%edx
  800bfc:	09 c2                	or     %eax,%edx
  800bfe:	f6 c2 03             	test   $0x3,%dl
  800c01:	74 09                	je     800c0c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c03:	89 c7                	mov    %eax,%edi
  800c05:	fc                   	cld    
  800c06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0c:	f6 c1 03             	test   $0x3,%cl
  800c0f:	75 f2                	jne    800c03 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c14:	89 c7                	mov    %eax,%edi
  800c16:	fc                   	cld    
  800c17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c19:	eb ed                	jmp    800c08 <memmove+0x55>

00800c1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c1e:	ff 75 10             	pushl  0x10(%ebp)
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 87 ff ff ff       	call   800bb3 <memmove>
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c39:	89 c6                	mov    %eax,%esi
  800c3b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3e:	39 f0                	cmp    %esi,%eax
  800c40:	74 1c                	je     800c5e <memcmp+0x30>
		if (*s1 != *s2)
  800c42:	0f b6 08             	movzbl (%eax),%ecx
  800c45:	0f b6 1a             	movzbl (%edx),%ebx
  800c48:	38 d9                	cmp    %bl,%cl
  800c4a:	75 08                	jne    800c54 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4c:	83 c0 01             	add    $0x1,%eax
  800c4f:	83 c2 01             	add    $0x1,%edx
  800c52:	eb ea                	jmp    800c3e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c54:	0f b6 c1             	movzbl %cl,%eax
  800c57:	0f b6 db             	movzbl %bl,%ebx
  800c5a:	29 d8                	sub    %ebx,%eax
  800c5c:	eb 05                	jmp    800c63 <memcmp+0x35>
	}

	return 0;
  800c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c70:	89 c2                	mov    %eax,%edx
  800c72:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c75:	39 d0                	cmp    %edx,%eax
  800c77:	73 09                	jae    800c82 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c79:	38 08                	cmp    %cl,(%eax)
  800c7b:	74 05                	je     800c82 <memfind+0x1b>
	for (; s < ends; s++)
  800c7d:	83 c0 01             	add    $0x1,%eax
  800c80:	eb f3                	jmp    800c75 <memfind+0xe>
			break;
	return (void *) s;
}
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
  800c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c90:	eb 03                	jmp    800c95 <strtol+0x11>
		s++;
  800c92:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c95:	0f b6 01             	movzbl (%ecx),%eax
  800c98:	3c 20                	cmp    $0x20,%al
  800c9a:	74 f6                	je     800c92 <strtol+0xe>
  800c9c:	3c 09                	cmp    $0x9,%al
  800c9e:	74 f2                	je     800c92 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca0:	3c 2b                	cmp    $0x2b,%al
  800ca2:	74 2e                	je     800cd2 <strtol+0x4e>
	int neg = 0;
  800ca4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ca9:	3c 2d                	cmp    $0x2d,%al
  800cab:	74 2f                	je     800cdc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cad:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb3:	75 05                	jne    800cba <strtol+0x36>
  800cb5:	80 39 30             	cmpb   $0x30,(%ecx)
  800cb8:	74 2c                	je     800ce6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cba:	85 db                	test   %ebx,%ebx
  800cbc:	75 0a                	jne    800cc8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbe:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cc3:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc6:	74 28                	je     800cf0 <strtol+0x6c>
		base = 10;
  800cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd0:	eb 50                	jmp    800d22 <strtol+0x9e>
		s++;
  800cd2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cda:	eb d1                	jmp    800cad <strtol+0x29>
		s++, neg = 1;
  800cdc:	83 c1 01             	add    $0x1,%ecx
  800cdf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce4:	eb c7                	jmp    800cad <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cea:	74 0e                	je     800cfa <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cec:	85 db                	test   %ebx,%ebx
  800cee:	75 d8                	jne    800cc8 <strtol+0x44>
		s++, base = 8;
  800cf0:	83 c1 01             	add    $0x1,%ecx
  800cf3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cf8:	eb ce                	jmp    800cc8 <strtol+0x44>
		s += 2, base = 16;
  800cfa:	83 c1 02             	add    $0x2,%ecx
  800cfd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d02:	eb c4                	jmp    800cc8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d04:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d07:	89 f3                	mov    %esi,%ebx
  800d09:	80 fb 19             	cmp    $0x19,%bl
  800d0c:	77 29                	ja     800d37 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d0e:	0f be d2             	movsbl %dl,%edx
  800d11:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d14:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d17:	7d 30                	jge    800d49 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d19:	83 c1 01             	add    $0x1,%ecx
  800d1c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d20:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d22:	0f b6 11             	movzbl (%ecx),%edx
  800d25:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d28:	89 f3                	mov    %esi,%ebx
  800d2a:	80 fb 09             	cmp    $0x9,%bl
  800d2d:	77 d5                	ja     800d04 <strtol+0x80>
			dig = *s - '0';
  800d2f:	0f be d2             	movsbl %dl,%edx
  800d32:	83 ea 30             	sub    $0x30,%edx
  800d35:	eb dd                	jmp    800d14 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d37:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3a:	89 f3                	mov    %esi,%ebx
  800d3c:	80 fb 19             	cmp    $0x19,%bl
  800d3f:	77 08                	ja     800d49 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d41:	0f be d2             	movsbl %dl,%edx
  800d44:	83 ea 37             	sub    $0x37,%edx
  800d47:	eb cb                	jmp    800d14 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4d:	74 05                	je     800d54 <strtol+0xd0>
		*endptr = (char *) s;
  800d4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d52:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d54:	89 c2                	mov    %eax,%edx
  800d56:	f7 da                	neg    %edx
  800d58:	85 ff                	test   %edi,%edi
  800d5a:	0f 45 c2             	cmovne %edx,%eax
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
  800d62:	66 90                	xchg   %ax,%ax
  800d64:	66 90                	xchg   %ax,%ax
  800d66:	66 90                	xchg   %ax,%ax
  800d68:	66 90                	xchg   %ax,%ax
  800d6a:	66 90                	xchg   %ax,%ax
  800d6c:	66 90                	xchg   %ax,%ax
  800d6e:	66 90                	xchg   %ax,%ax

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
