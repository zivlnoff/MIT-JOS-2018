
obj/user/badsegment：     文件格式 elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	83 ec 08             	sub    $0x8,%esp
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80004a:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  800051:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800054:	85 c0                	test   %eax,%eax
  800056:	7e 08                	jle    800060 <libmain+0x22>
		binaryname = argv[0];
  800058:	8b 0a                	mov    (%edx),%ecx
  80005a:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800060:	83 ec 08             	sub    $0x8,%esp
  800063:	52                   	push   %edx
  800064:	50                   	push   %eax
  800065:	e8 c9 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006a:	e8 05 00 00 00       	call   800074 <exit>
}
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80007a:	6a 00                	push   $0x0
  80007c:	e8 42 00 00 00       	call   8000c3 <sys_env_destroy>
}
  800081:	83 c4 10             	add    $0x10,%esp
  800084:	c9                   	leave  
  800085:	c3                   	ret    

00800086 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800086:	55                   	push   %ebp
  800087:	89 e5                	mov    %esp,%ebp
  800089:	57                   	push   %edi
  80008a:	56                   	push   %esi
  80008b:	53                   	push   %ebx
    asm volatile("int %1\n"
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	8b 55 08             	mov    0x8(%ebp),%edx
  800094:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800097:	89 c3                	mov    %eax,%ebx
  800099:	89 c7                	mov    %eax,%edi
  80009b:	89 c6                	mov    %eax,%esi
  80009d:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  80009f:	5b                   	pop    %ebx
  8000a0:	5e                   	pop    %esi
  8000a1:	5f                   	pop    %edi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <sys_cgetc>:

int
sys_cgetc(void) {
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	57                   	push   %edi
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	89 d3                	mov    %edx,%ebx
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	89 d6                	mov    %edx,%esi
  8000bc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000be:	5b                   	pop    %ebx
  8000bf:	5e                   	pop    %esi
  8000c0:	5f                   	pop    %edi
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	57                   	push   %edi
  8000c7:	56                   	push   %esi
  8000c8:	53                   	push   %ebx
  8000c9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000d9:	89 cb                	mov    %ecx,%ebx
  8000db:	89 cf                	mov    %ecx,%edi
  8000dd:	89 ce                	mov    %ecx,%esi
  8000df:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000e1:	85 c0                	test   %eax,%eax
  8000e3:	7f 08                	jg     8000ed <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e8:	5b                   	pop    %ebx
  8000e9:	5e                   	pop    %esi
  8000ea:	5f                   	pop    %edi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	6a 03                	push   $0x3
  8000f3:	68 ca 0f 80 00       	push   $0x800fca
  8000f8:	6a 24                	push   $0x24
  8000fa:	68 e7 0f 80 00       	push   $0x800fe7
  8000ff:	e8 ed 01 00 00       	call   8002f1 <_panic>

00800104 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	57                   	push   %edi
  800108:	56                   	push   %esi
  800109:	53                   	push   %ebx
    asm volatile("int %1\n"
  80010a:	ba 00 00 00 00       	mov    $0x0,%edx
  80010f:	b8 02 00 00 00       	mov    $0x2,%eax
  800114:	89 d1                	mov    %edx,%ecx
  800116:	89 d3                	mov    %edx,%ebx
  800118:	89 d7                	mov    %edx,%edi
  80011a:	89 d6                	mov    %edx,%esi
  80011c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5f                   	pop    %edi
  800121:	5d                   	pop    %ebp
  800122:	c3                   	ret    

00800123 <sys_yield>:

void
sys_yield(void)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	57                   	push   %edi
  800127:	56                   	push   %esi
  800128:	53                   	push   %ebx
    asm volatile("int %1\n"
  800129:	ba 00 00 00 00       	mov    $0x0,%edx
  80012e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800133:	89 d1                	mov    %edx,%ecx
  800135:	89 d3                	mov    %edx,%ebx
  800137:	89 d7                	mov    %edx,%edi
  800139:	89 d6                	mov    %edx,%esi
  80013b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80013d:	5b                   	pop    %ebx
  80013e:	5e                   	pop    %esi
  80013f:	5f                   	pop    %edi
  800140:	5d                   	pop    %ebp
  800141:	c3                   	ret    

00800142 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
  800148:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
  800150:	8b 55 08             	mov    0x8(%ebp),%edx
  800153:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800156:	b8 04 00 00 00       	mov    $0x4,%eax
  80015b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80015e:	89 f7                	mov    %esi,%edi
  800160:	cd 30                	int    $0x30
    if (check && ret > 0)
  800162:	85 c0                	test   %eax,%eax
  800164:	7f 08                	jg     80016e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800166:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800169:	5b                   	pop    %ebx
  80016a:	5e                   	pop    %esi
  80016b:	5f                   	pop    %edi
  80016c:	5d                   	pop    %ebp
  80016d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	6a 04                	push   $0x4
  800174:	68 ca 0f 80 00       	push   $0x800fca
  800179:	6a 24                	push   $0x24
  80017b:	68 e7 0f 80 00       	push   $0x800fe7
  800180:	e8 6c 01 00 00       	call   8002f1 <_panic>

00800185 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	57                   	push   %edi
  800189:	56                   	push   %esi
  80018a:	53                   	push   %ebx
  80018b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80018e:	8b 55 08             	mov    0x8(%ebp),%edx
  800191:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800194:	b8 05 00 00 00       	mov    $0x5,%eax
  800199:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80019f:	8b 75 18             	mov    0x18(%ebp),%esi
  8001a2:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	7f 08                	jg     8001b0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ab:	5b                   	pop    %ebx
  8001ac:	5e                   	pop    %esi
  8001ad:	5f                   	pop    %edi
  8001ae:	5d                   	pop    %ebp
  8001af:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	50                   	push   %eax
  8001b4:	6a 05                	push   $0x5
  8001b6:	68 ca 0f 80 00       	push   $0x800fca
  8001bb:	6a 24                	push   $0x24
  8001bd:	68 e7 0f 80 00       	push   $0x800fe7
  8001c2:	e8 2a 01 00 00       	call   8002f1 <_panic>

008001c7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001db:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e0:	89 df                	mov    %ebx,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	7f 08                	jg     8001f2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ed:	5b                   	pop    %ebx
  8001ee:	5e                   	pop    %esi
  8001ef:	5f                   	pop    %edi
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	50                   	push   %eax
  8001f6:	6a 06                	push   $0x6
  8001f8:	68 ca 0f 80 00       	push   $0x800fca
  8001fd:	6a 24                	push   $0x24
  8001ff:	68 e7 0f 80 00       	push   $0x800fe7
  800204:	e8 e8 00 00 00       	call   8002f1 <_panic>

00800209 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	57                   	push   %edi
  80020d:	56                   	push   %esi
  80020e:	53                   	push   %ebx
  80020f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800212:	bb 00 00 00 00       	mov    $0x0,%ebx
  800217:	8b 55 08             	mov    0x8(%ebp),%edx
  80021a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021d:	b8 08 00 00 00       	mov    $0x8,%eax
  800222:	89 df                	mov    %ebx,%edi
  800224:	89 de                	mov    %ebx,%esi
  800226:	cd 30                	int    $0x30
    if (check && ret > 0)
  800228:	85 c0                	test   %eax,%eax
  80022a:	7f 08                	jg     800234 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80022c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022f:	5b                   	pop    %ebx
  800230:	5e                   	pop    %esi
  800231:	5f                   	pop    %edi
  800232:	5d                   	pop    %ebp
  800233:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	50                   	push   %eax
  800238:	6a 08                	push   $0x8
  80023a:	68 ca 0f 80 00       	push   $0x800fca
  80023f:	6a 24                	push   $0x24
  800241:	68 e7 0f 80 00       	push   $0x800fe7
  800246:	e8 a6 00 00 00       	call   8002f1 <_panic>

0080024b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	57                   	push   %edi
  80024f:	56                   	push   %esi
  800250:	53                   	push   %ebx
  800251:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800254:	bb 00 00 00 00       	mov    $0x0,%ebx
  800259:	8b 55 08             	mov    0x8(%ebp),%edx
  80025c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025f:	b8 09 00 00 00       	mov    $0x9,%eax
  800264:	89 df                	mov    %ebx,%edi
  800266:	89 de                	mov    %ebx,%esi
  800268:	cd 30                	int    $0x30
    if (check && ret > 0)
  80026a:	85 c0                	test   %eax,%eax
  80026c:	7f 08                	jg     800276 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80026e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800271:	5b                   	pop    %ebx
  800272:	5e                   	pop    %esi
  800273:	5f                   	pop    %edi
  800274:	5d                   	pop    %ebp
  800275:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	50                   	push   %eax
  80027a:	6a 09                	push   $0x9
  80027c:	68 ca 0f 80 00       	push   $0x800fca
  800281:	6a 24                	push   $0x24
  800283:	68 e7 0f 80 00       	push   $0x800fe7
  800288:	e8 64 00 00 00       	call   8002f1 <_panic>

0080028d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	57                   	push   %edi
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
    asm volatile("int %1\n"
  800293:	8b 55 08             	mov    0x8(%ebp),%edx
  800296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800299:	b8 0b 00 00 00       	mov    $0xb,%eax
  80029e:	be 00 00 00 00       	mov    $0x0,%esi
  8002a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002a6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002a9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002ab:	5b                   	pop    %ebx
  8002ac:	5e                   	pop    %esi
  8002ad:	5f                   	pop    %edi
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002be:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002c6:	89 cb                	mov    %ecx,%ebx
  8002c8:	89 cf                	mov    %ecx,%edi
  8002ca:	89 ce                	mov    %ecx,%esi
  8002cc:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002ce:	85 c0                	test   %eax,%eax
  8002d0:	7f 08                	jg     8002da <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d5:	5b                   	pop    %ebx
  8002d6:	5e                   	pop    %esi
  8002d7:	5f                   	pop    %edi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	50                   	push   %eax
  8002de:	6a 0c                	push   $0xc
  8002e0:	68 ca 0f 80 00       	push   $0x800fca
  8002e5:	6a 24                	push   $0x24
  8002e7:	68 e7 0f 80 00       	push   $0x800fe7
  8002ec:	e8 00 00 00 00       	call   8002f1 <_panic>

008002f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002f6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f9:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8002ff:	e8 00 fe ff ff       	call   800104 <sys_getenvid>
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	ff 75 0c             	pushl  0xc(%ebp)
  80030a:	ff 75 08             	pushl  0x8(%ebp)
  80030d:	56                   	push   %esi
  80030e:	50                   	push   %eax
  80030f:	68 f8 0f 80 00       	push   $0x800ff8
  800314:	e8 b3 00 00 00       	call   8003cc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800319:	83 c4 18             	add    $0x18,%esp
  80031c:	53                   	push   %ebx
  80031d:	ff 75 10             	pushl  0x10(%ebp)
  800320:	e8 56 00 00 00       	call   80037b <vcprintf>
	cprintf("\n");
  800325:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  80032c:	e8 9b 00 00 00       	call   8003cc <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800334:	cc                   	int3   
  800335:	eb fd                	jmp    800334 <_panic+0x43>

00800337 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	53                   	push   %ebx
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800341:	8b 13                	mov    (%ebx),%edx
  800343:	8d 42 01             	lea    0x1(%edx),%eax
  800346:	89 03                	mov    %eax,(%ebx)
  800348:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80034f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800354:	74 09                	je     80035f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800356:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035d:	c9                   	leave  
  80035e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	68 ff 00 00 00       	push   $0xff
  800367:	8d 43 08             	lea    0x8(%ebx),%eax
  80036a:	50                   	push   %eax
  80036b:	e8 16 fd ff ff       	call   800086 <sys_cputs>
		b->idx = 0;
  800370:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	eb db                	jmp    800356 <putch+0x1f>

0080037b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800384:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038b:	00 00 00 
	b.cnt = 0;
  80038e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800395:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800398:	ff 75 0c             	pushl  0xc(%ebp)
  80039b:	ff 75 08             	pushl  0x8(%ebp)
  80039e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a4:	50                   	push   %eax
  8003a5:	68 37 03 80 00       	push   $0x800337
  8003aa:	e8 1a 01 00 00       	call   8004c9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003af:	83 c4 08             	add    $0x8,%esp
  8003b2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 c2 fc ff ff       	call   800086 <sys_cputs>

	return b.cnt;
}
  8003c4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    

008003cc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d5:	50                   	push   %eax
  8003d6:	ff 75 08             	pushl  0x8(%ebp)
  8003d9:	e8 9d ff ff ff       	call   80037b <vcprintf>
	va_end(ap);

	return cnt;
}
  8003de:	c9                   	leave  
  8003df:	c3                   	ret    

008003e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	57                   	push   %edi
  8003e4:	56                   	push   %esi
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 1c             	sub    $0x1c,%esp
  8003e9:	89 c7                	mov    %eax,%edi
  8003eb:	89 d6                	mov    %edx,%esi
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8003f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800401:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800404:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800407:	39 d3                	cmp    %edx,%ebx
  800409:	72 05                	jb     800410 <printnum+0x30>
  80040b:	39 45 10             	cmp    %eax,0x10(%ebp)
  80040e:	77 7a                	ja     80048a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	ff 75 18             	pushl  0x18(%ebp)
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80041c:	53                   	push   %ebx
  80041d:	ff 75 10             	pushl  0x10(%ebp)
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	ff 75 e4             	pushl  -0x1c(%ebp)
  800426:	ff 75 e0             	pushl  -0x20(%ebp)
  800429:	ff 75 dc             	pushl  -0x24(%ebp)
  80042c:	ff 75 d8             	pushl  -0x28(%ebp)
  80042f:	e8 3c 09 00 00       	call   800d70 <__udivdi3>
  800434:	83 c4 18             	add    $0x18,%esp
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	89 f2                	mov    %esi,%edx
  80043b:	89 f8                	mov    %edi,%eax
  80043d:	e8 9e ff ff ff       	call   8003e0 <printnum>
  800442:	83 c4 20             	add    $0x20,%esp
  800445:	eb 13                	jmp    80045a <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	56                   	push   %esi
  80044b:	ff 75 18             	pushl  0x18(%ebp)
  80044e:	ff d7                	call   *%edi
  800450:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800453:	83 eb 01             	sub    $0x1,%ebx
  800456:	85 db                	test   %ebx,%ebx
  800458:	7f ed                	jg     800447 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	56                   	push   %esi
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	ff 75 e4             	pushl  -0x1c(%ebp)
  800464:	ff 75 e0             	pushl  -0x20(%ebp)
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	ff 75 d8             	pushl  -0x28(%ebp)
  80046d:	e8 1e 0a 00 00       	call   800e90 <__umoddi3>
  800472:	83 c4 14             	add    $0x14,%esp
  800475:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  80047c:	50                   	push   %eax
  80047d:	ff d7                	call   *%edi
}
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800485:	5b                   	pop    %ebx
  800486:	5e                   	pop    %esi
  800487:	5f                   	pop    %edi
  800488:	5d                   	pop    %ebp
  800489:	c3                   	ret    
  80048a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80048d:	eb c4                	jmp    800453 <printnum+0x73>

0080048f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800495:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800499:	8b 10                	mov    (%eax),%edx
  80049b:	3b 50 04             	cmp    0x4(%eax),%edx
  80049e:	73 0a                	jae    8004aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a3:	89 08                	mov    %ecx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	88 02                	mov    %al,(%edx)
}
  8004aa:	5d                   	pop    %ebp
  8004ab:	c3                   	ret    

008004ac <printfmt>:
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b5:	50                   	push   %eax
  8004b6:	ff 75 10             	pushl  0x10(%ebp)
  8004b9:	ff 75 0c             	pushl  0xc(%ebp)
  8004bc:	ff 75 08             	pushl  0x8(%ebp)
  8004bf:	e8 05 00 00 00       	call   8004c9 <vprintfmt>
}
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <vprintfmt>:
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	57                   	push   %edi
  8004cd:	56                   	push   %esi
  8004ce:	53                   	push   %ebx
  8004cf:	83 ec 2c             	sub    $0x2c,%esp
  8004d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004db:	e9 00 04 00 00       	jmp    8008e0 <vprintfmt+0x417>
		padc = ' ';
  8004e0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004e4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004eb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8d 47 01             	lea    0x1(%edi),%eax
  800501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800504:	0f b6 17             	movzbl (%edi),%edx
  800507:	8d 42 dd             	lea    -0x23(%edx),%eax
  80050a:	3c 55                	cmp    $0x55,%al
  80050c:	0f 87 51 04 00 00    	ja     800963 <vprintfmt+0x49a>
  800512:	0f b6 c0             	movzbl %al,%eax
  800515:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  80051c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80051f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800523:	eb d9                	jmp    8004fe <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800528:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80052c:	eb d0                	jmp    8004fe <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	0f b6 d2             	movzbl %dl,%edx
  800531:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800534:	b8 00 00 00 00       	mov    $0x0,%eax
  800539:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80053c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80053f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800543:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800546:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800549:	83 f9 09             	cmp    $0x9,%ecx
  80054c:	77 55                	ja     8005a3 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80054e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800551:	eb e9                	jmp    80053c <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8d 40 04             	lea    0x4(%eax),%eax
  800561:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800567:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056b:	79 91                	jns    8004fe <vprintfmt+0x35>
				width = precision, precision = -1;
  80056d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800570:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800573:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80057a:	eb 82                	jmp    8004fe <vprintfmt+0x35>
  80057c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057f:	85 c0                	test   %eax,%eax
  800581:	ba 00 00 00 00       	mov    $0x0,%edx
  800586:	0f 49 d0             	cmovns %eax,%edx
  800589:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058f:	e9 6a ff ff ff       	jmp    8004fe <vprintfmt+0x35>
  800594:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800597:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80059e:	e9 5b ff ff ff       	jmp    8004fe <vprintfmt+0x35>
  8005a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a9:	eb bc                	jmp    800567 <vprintfmt+0x9e>
			lflag++;
  8005ab:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005b1:	e9 48 ff ff ff       	jmp    8004fe <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 78 04             	lea    0x4(%eax),%edi
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	53                   	push   %ebx
  8005c0:	ff 30                	pushl  (%eax)
  8005c2:	ff d6                	call   *%esi
			break;
  8005c4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005c7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005ca:	e9 0e 03 00 00       	jmp    8008dd <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 78 04             	lea    0x4(%eax),%edi
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	99                   	cltd   
  8005d8:	31 d0                	xor    %edx,%eax
  8005da:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005dc:	83 f8 08             	cmp    $0x8,%eax
  8005df:	7f 23                	jg     800604 <vprintfmt+0x13b>
  8005e1:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005e8:	85 d2                	test   %edx,%edx
  8005ea:	74 18                	je     800604 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005ec:	52                   	push   %edx
  8005ed:	68 3f 10 80 00       	push   $0x80103f
  8005f2:	53                   	push   %ebx
  8005f3:	56                   	push   %esi
  8005f4:	e8 b3 fe ff ff       	call   8004ac <printfmt>
  8005f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005fc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ff:	e9 d9 02 00 00       	jmp    8008dd <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800604:	50                   	push   %eax
  800605:	68 36 10 80 00       	push   $0x801036
  80060a:	53                   	push   %ebx
  80060b:	56                   	push   %esi
  80060c:	e8 9b fe ff ff       	call   8004ac <printfmt>
  800611:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800614:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800617:	e9 c1 02 00 00       	jmp    8008dd <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	83 c0 04             	add    $0x4,%eax
  800622:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80062a:	85 ff                	test   %edi,%edi
  80062c:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  800631:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800634:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800638:	0f 8e bd 00 00 00    	jle    8006fb <vprintfmt+0x232>
  80063e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800642:	75 0e                	jne    800652 <vprintfmt+0x189>
  800644:	89 75 08             	mov    %esi,0x8(%ebp)
  800647:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80064a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80064d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800650:	eb 6d                	jmp    8006bf <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 d0             	pushl  -0x30(%ebp)
  800658:	57                   	push   %edi
  800659:	e8 ad 03 00 00       	call   800a0b <strnlen>
  80065e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800661:	29 c1                	sub    %eax,%ecx
  800663:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800666:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800669:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80066d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800670:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800673:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800675:	eb 0f                	jmp    800686 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	ff 75 e0             	pushl  -0x20(%ebp)
  80067e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800680:	83 ef 01             	sub    $0x1,%edi
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	85 ff                	test   %edi,%edi
  800688:	7f ed                	jg     800677 <vprintfmt+0x1ae>
  80068a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80068d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800690:	85 c9                	test   %ecx,%ecx
  800692:	b8 00 00 00 00       	mov    $0x0,%eax
  800697:	0f 49 c1             	cmovns %ecx,%eax
  80069a:	29 c1                	sub    %eax,%ecx
  80069c:	89 75 08             	mov    %esi,0x8(%ebp)
  80069f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a5:	89 cb                	mov    %ecx,%ebx
  8006a7:	eb 16                	jmp    8006bf <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ad:	75 31                	jne    8006e0 <vprintfmt+0x217>
					putch(ch, putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	50                   	push   %eax
  8006b6:	ff 55 08             	call   *0x8(%ebp)
  8006b9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bc:	83 eb 01             	sub    $0x1,%ebx
  8006bf:	83 c7 01             	add    $0x1,%edi
  8006c2:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006c6:	0f be c2             	movsbl %dl,%eax
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	74 59                	je     800726 <vprintfmt+0x25d>
  8006cd:	85 f6                	test   %esi,%esi
  8006cf:	78 d8                	js     8006a9 <vprintfmt+0x1e0>
  8006d1:	83 ee 01             	sub    $0x1,%esi
  8006d4:	79 d3                	jns    8006a9 <vprintfmt+0x1e0>
  8006d6:	89 df                	mov    %ebx,%edi
  8006d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8006db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006de:	eb 37                	jmp    800717 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e0:	0f be d2             	movsbl %dl,%edx
  8006e3:	83 ea 20             	sub    $0x20,%edx
  8006e6:	83 fa 5e             	cmp    $0x5e,%edx
  8006e9:	76 c4                	jbe    8006af <vprintfmt+0x1e6>
					putch('?', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	ff 75 0c             	pushl  0xc(%ebp)
  8006f1:	6a 3f                	push   $0x3f
  8006f3:	ff 55 08             	call   *0x8(%ebp)
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	eb c1                	jmp    8006bc <vprintfmt+0x1f3>
  8006fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8006fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800701:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800704:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800707:	eb b6                	jmp    8006bf <vprintfmt+0x1f6>
				putch(' ', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 20                	push   $0x20
  80070f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800711:	83 ef 01             	sub    $0x1,%edi
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	85 ff                	test   %edi,%edi
  800719:	7f ee                	jg     800709 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80071b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
  800721:	e9 b7 01 00 00       	jmp    8008dd <vprintfmt+0x414>
  800726:	89 df                	mov    %ebx,%edi
  800728:	8b 75 08             	mov    0x8(%ebp),%esi
  80072b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80072e:	eb e7                	jmp    800717 <vprintfmt+0x24e>
	if (lflag >= 2)
  800730:	83 f9 01             	cmp    $0x1,%ecx
  800733:	7e 3f                	jle    800774 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 50 04             	mov    0x4(%eax),%edx
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 08             	lea    0x8(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80074c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800750:	79 5c                	jns    8007ae <vprintfmt+0x2e5>
				putch('-', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 2d                	push   $0x2d
  800758:	ff d6                	call   *%esi
				num = -(long long) num;
  80075a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80075d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800760:	f7 da                	neg    %edx
  800762:	83 d1 00             	adc    $0x0,%ecx
  800765:	f7 d9                	neg    %ecx
  800767:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076f:	e9 4f 01 00 00       	jmp    8008c3 <vprintfmt+0x3fa>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	75 1b                	jne    800793 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	89 c1                	mov    %eax,%ecx
  800782:	c1 f9 1f             	sar    $0x1f,%ecx
  800785:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
  800791:	eb b9                	jmp    80074c <vprintfmt+0x283>
		return va_arg(*ap, long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079b:	89 c1                	mov    %eax,%ecx
  80079d:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ac:	eb 9e                	jmp    80074c <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b9:	e9 05 01 00 00       	jmp    8008c3 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007be:	83 f9 01             	cmp    $0x1,%ecx
  8007c1:	7e 18                	jle    8007db <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cb:	8d 40 08             	lea    0x8(%eax),%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d6:	e9 e8 00 00 00       	jmp    8008c3 <vprintfmt+0x3fa>
	else if (lflag)
  8007db:	85 c9                	test   %ecx,%ecx
  8007dd:	75 1a                	jne    8007f9 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 10                	mov    (%eax),%edx
  8007e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f4:	e9 ca 00 00 00       	jmp    8008c3 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 10                	mov    (%eax),%edx
  8007fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800809:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080e:	e9 b0 00 00 00       	jmp    8008c3 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800813:	83 f9 01             	cmp    $0x1,%ecx
  800816:	7e 3c                	jle    800854 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8b 50 04             	mov    0x4(%eax),%edx
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 08             	lea    0x8(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80082f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800833:	79 59                	jns    80088e <vprintfmt+0x3c5>
                putch('-', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 2d                	push   $0x2d
  80083b:	ff d6                	call   *%esi
                num = -(long long) num;
  80083d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800840:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800843:	f7 da                	neg    %edx
  800845:	83 d1 00             	adc    $0x0,%ecx
  800848:	f7 d9                	neg    %ecx
  80084a:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80084d:	b8 08 00 00 00       	mov    $0x8,%eax
  800852:	eb 6f                	jmp    8008c3 <vprintfmt+0x3fa>
	else if (lflag)
  800854:	85 c9                	test   %ecx,%ecx
  800856:	75 1b                	jne    800873 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	89 c1                	mov    %eax,%ecx
  800862:	c1 f9 1f             	sar    $0x1f,%ecx
  800865:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
  800871:	eb bc                	jmp    80082f <vprintfmt+0x366>
		return va_arg(*ap, long);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087b:	89 c1                	mov    %eax,%ecx
  80087d:	c1 f9 1f             	sar    $0x1f,%ecx
  800880:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 04             	lea    0x4(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
  80088c:	eb a1                	jmp    80082f <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80088e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800891:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800894:	b8 08 00 00 00       	mov    $0x8,%eax
  800899:	eb 28                	jmp    8008c3 <vprintfmt+0x3fa>
			putch('0', putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	6a 30                	push   $0x30
  8008a1:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a3:	83 c4 08             	add    $0x8,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	6a 78                	push   $0x78
  8008a9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8b 10                	mov    (%eax),%edx
  8008b0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b8:	8d 40 04             	lea    0x4(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008be:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c3:	83 ec 0c             	sub    $0xc,%esp
  8008c6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008ca:	57                   	push   %edi
  8008cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	51                   	push   %ecx
  8008d0:	52                   	push   %edx
  8008d1:	89 da                	mov    %ebx,%edx
  8008d3:	89 f0                	mov    %esi,%eax
  8008d5:	e8 06 fb ff ff       	call   8003e0 <printnum>
			break;
  8008da:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e0:	83 c7 01             	add    $0x1,%edi
  8008e3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e7:	83 f8 25             	cmp    $0x25,%eax
  8008ea:	0f 84 f0 fb ff ff    	je     8004e0 <vprintfmt+0x17>
			if (ch == '\0')
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	0f 84 8b 00 00 00    	je     800983 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	53                   	push   %ebx
  8008fc:	50                   	push   %eax
  8008fd:	ff d6                	call   *%esi
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	eb dc                	jmp    8008e0 <vprintfmt+0x417>
	if (lflag >= 2)
  800904:	83 f9 01             	cmp    $0x1,%ecx
  800907:	7e 15                	jle    80091e <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8b 10                	mov    (%eax),%edx
  80090e:	8b 48 04             	mov    0x4(%eax),%ecx
  800911:	8d 40 08             	lea    0x8(%eax),%eax
  800914:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800917:	b8 10 00 00 00       	mov    $0x10,%eax
  80091c:	eb a5                	jmp    8008c3 <vprintfmt+0x3fa>
	else if (lflag)
  80091e:	85 c9                	test   %ecx,%ecx
  800920:	75 17                	jne    800939 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 10                	mov    (%eax),%edx
  800927:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092c:	8d 40 04             	lea    0x4(%eax),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800932:	b8 10 00 00 00       	mov    $0x10,%eax
  800937:	eb 8a                	jmp    8008c3 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800949:	b8 10 00 00 00       	mov    $0x10,%eax
  80094e:	e9 70 ff ff ff       	jmp    8008c3 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	53                   	push   %ebx
  800957:	6a 25                	push   $0x25
  800959:	ff d6                	call   *%esi
			break;
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	e9 7a ff ff ff       	jmp    8008dd <vprintfmt+0x414>
			putch('%', putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	6a 25                	push   $0x25
  800969:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 f8                	mov    %edi,%eax
  800970:	eb 03                	jmp    800975 <vprintfmt+0x4ac>
  800972:	83 e8 01             	sub    $0x1,%eax
  800975:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800979:	75 f7                	jne    800972 <vprintfmt+0x4a9>
  80097b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097e:	e9 5a ff ff ff       	jmp    8008dd <vprintfmt+0x414>
}
  800983:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800986:	5b                   	pop    %ebx
  800987:	5e                   	pop    %esi
  800988:	5f                   	pop    %edi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 18             	sub    $0x18,%esp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800997:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a8:	85 c0                	test   %eax,%eax
  8009aa:	74 26                	je     8009d2 <vsnprintf+0x47>
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	7e 22                	jle    8009d2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 8f 04 80 00       	push   $0x80048f
  8009bf:	e8 05 fb ff ff       	call   8004c9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    
		return -E_INVAL;
  8009d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d7:	eb f7                	jmp    8009d0 <vsnprintf+0x45>

008009d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009df:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e2:	50                   	push   %eax
  8009e3:	ff 75 10             	pushl  0x10(%ebp)
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	e8 9a ff ff ff       	call   80098b <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fe:	eb 03                	jmp    800a03 <strlen+0x10>
		n++;
  800a00:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a07:	75 f7                	jne    800a00 <strlen+0xd>
	return n;
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a11:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
  800a19:	eb 03                	jmp    800a1e <strnlen+0x13>
		n++;
  800a1b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1e:	39 d0                	cmp    %edx,%eax
  800a20:	74 06                	je     800a28 <strnlen+0x1d>
  800a22:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a26:	75 f3                	jne    800a1b <strnlen+0x10>
	return n;
}
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	53                   	push   %ebx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	83 c1 01             	add    $0x1,%ecx
  800a39:	83 c2 01             	add    $0x1,%edx
  800a3c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a40:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a43:	84 db                	test   %bl,%bl
  800a45:	75 ef                	jne    800a36 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	53                   	push   %ebx
  800a4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a51:	53                   	push   %ebx
  800a52:	e8 9c ff ff ff       	call   8009f3 <strlen>
  800a57:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	01 d8                	add    %ebx,%eax
  800a5f:	50                   	push   %eax
  800a60:	e8 c5 ff ff ff       	call   800a2a <strcpy>
	return dst;
}
  800a65:	89 d8                	mov    %ebx,%eax
  800a67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	56                   	push   %esi
  800a70:	53                   	push   %ebx
  800a71:	8b 75 08             	mov    0x8(%ebp),%esi
  800a74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a77:	89 f3                	mov    %esi,%ebx
  800a79:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7c:	89 f2                	mov    %esi,%edx
  800a7e:	eb 0f                	jmp    800a8f <strncpy+0x23>
		*dst++ = *src;
  800a80:	83 c2 01             	add    $0x1,%edx
  800a83:	0f b6 01             	movzbl (%ecx),%eax
  800a86:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a89:	80 39 01             	cmpb   $0x1,(%ecx)
  800a8c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a8f:	39 da                	cmp    %ebx,%edx
  800a91:	75 ed                	jne    800a80 <strncpy+0x14>
	}
	return ret;
}
  800a93:	89 f0                	mov    %esi,%eax
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
  800a9e:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aad:	85 c9                	test   %ecx,%ecx
  800aaf:	75 0b                	jne    800abc <strlcpy+0x23>
  800ab1:	eb 17                	jmp    800aca <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c0 01             	add    $0x1,%eax
  800ab9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800abc:	39 d8                	cmp    %ebx,%eax
  800abe:	74 07                	je     800ac7 <strlcpy+0x2e>
  800ac0:	0f b6 0a             	movzbl (%edx),%ecx
  800ac3:	84 c9                	test   %cl,%cl
  800ac5:	75 ec                	jne    800ab3 <strlcpy+0x1a>
		*dst = '\0';
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	29 f0                	sub    %esi,%eax
}
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0x11>
		p++, q++;
  800adb:	83 c1 01             	add    $0x1,%ecx
  800ade:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ae1:	0f b6 01             	movzbl (%ecx),%eax
  800ae4:	84 c0                	test   %al,%al
  800ae6:	74 04                	je     800aec <strcmp+0x1c>
  800ae8:	3a 02                	cmp    (%edx),%al
  800aea:	74 ef                	je     800adb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aec:	0f b6 c0             	movzbl %al,%eax
  800aef:	0f b6 12             	movzbl (%edx),%edx
  800af2:	29 d0                	sub    %edx,%eax
}
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	53                   	push   %ebx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b00:	89 c3                	mov    %eax,%ebx
  800b02:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b05:	eb 06                	jmp    800b0d <strncmp+0x17>
		n--, p++, q++;
  800b07:	83 c0 01             	add    $0x1,%eax
  800b0a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b0d:	39 d8                	cmp    %ebx,%eax
  800b0f:	74 16                	je     800b27 <strncmp+0x31>
  800b11:	0f b6 08             	movzbl (%eax),%ecx
  800b14:	84 c9                	test   %cl,%cl
  800b16:	74 04                	je     800b1c <strncmp+0x26>
  800b18:	3a 0a                	cmp    (%edx),%cl
  800b1a:	74 eb                	je     800b07 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1c:	0f b6 00             	movzbl (%eax),%eax
  800b1f:	0f b6 12             	movzbl (%edx),%edx
  800b22:	29 d0                	sub    %edx,%eax
}
  800b24:	5b                   	pop    %ebx
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    
		return 0;
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	eb f6                	jmp    800b24 <strncmp+0x2e>

00800b2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b38:	0f b6 10             	movzbl (%eax),%edx
  800b3b:	84 d2                	test   %dl,%dl
  800b3d:	74 09                	je     800b48 <strchr+0x1a>
		if (*s == c)
  800b3f:	38 ca                	cmp    %cl,%dl
  800b41:	74 0a                	je     800b4d <strchr+0x1f>
	for (; *s; s++)
  800b43:	83 c0 01             	add    $0x1,%eax
  800b46:	eb f0                	jmp    800b38 <strchr+0xa>
			return (char *) s;
	return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b59:	eb 03                	jmp    800b5e <strfind+0xf>
  800b5b:	83 c0 01             	add    $0x1,%eax
  800b5e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b61:	38 ca                	cmp    %cl,%dl
  800b63:	74 04                	je     800b69 <strfind+0x1a>
  800b65:	84 d2                	test   %dl,%dl
  800b67:	75 f2                	jne    800b5b <strfind+0xc>
			break;
	return (char *) s;
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b77:	85 c9                	test   %ecx,%ecx
  800b79:	74 13                	je     800b8e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b81:	75 05                	jne    800b88 <memset+0x1d>
  800b83:	f6 c1 03             	test   $0x3,%cl
  800b86:	74 0d                	je     800b95 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	fc                   	cld    
  800b8c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8e:	89 f8                	mov    %edi,%eax
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    
		c &= 0xFF;
  800b95:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	c1 e3 08             	shl    $0x8,%ebx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	c1 e0 18             	shl    $0x18,%eax
  800ba3:	89 d6                	mov    %edx,%esi
  800ba5:	c1 e6 10             	shl    $0x10,%esi
  800ba8:	09 f0                	or     %esi,%eax
  800baa:	09 c2                	or     %eax,%edx
  800bac:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bae:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb1:	89 d0                	mov    %edx,%eax
  800bb3:	fc                   	cld    
  800bb4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb6:	eb d6                	jmp    800b8e <memset+0x23>

00800bb8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc6:	39 c6                	cmp    %eax,%esi
  800bc8:	73 35                	jae    800bff <memmove+0x47>
  800bca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bcd:	39 c2                	cmp    %eax,%edx
  800bcf:	76 2e                	jbe    800bff <memmove+0x47>
		s += n;
		d += n;
  800bd1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd4:	89 d6                	mov    %edx,%esi
  800bd6:	09 fe                	or     %edi,%esi
  800bd8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bde:	74 0c                	je     800bec <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800be0:	83 ef 01             	sub    $0x1,%edi
  800be3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be6:	fd                   	std    
  800be7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be9:	fc                   	cld    
  800bea:	eb 21                	jmp    800c0d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bec:	f6 c1 03             	test   $0x3,%cl
  800bef:	75 ef                	jne    800be0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf1:	83 ef 04             	sub    $0x4,%edi
  800bf4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bfa:	fd                   	std    
  800bfb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfd:	eb ea                	jmp    800be9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bff:	89 f2                	mov    %esi,%edx
  800c01:	09 c2                	or     %eax,%edx
  800c03:	f6 c2 03             	test   $0x3,%dl
  800c06:	74 09                	je     800c11 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c08:	89 c7                	mov    %eax,%edi
  800c0a:	fc                   	cld    
  800c0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c11:	f6 c1 03             	test   $0x3,%cl
  800c14:	75 f2                	jne    800c08 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c19:	89 c7                	mov    %eax,%edi
  800c1b:	fc                   	cld    
  800c1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1e:	eb ed                	jmp    800c0d <memmove+0x55>

00800c20 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c23:	ff 75 10             	pushl  0x10(%ebp)
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	ff 75 08             	pushl  0x8(%ebp)
  800c2c:	e8 87 ff ff ff       	call   800bb8 <memmove>
}
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3e:	89 c6                	mov    %eax,%esi
  800c40:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c43:	39 f0                	cmp    %esi,%eax
  800c45:	74 1c                	je     800c63 <memcmp+0x30>
		if (*s1 != *s2)
  800c47:	0f b6 08             	movzbl (%eax),%ecx
  800c4a:	0f b6 1a             	movzbl (%edx),%ebx
  800c4d:	38 d9                	cmp    %bl,%cl
  800c4f:	75 08                	jne    800c59 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c51:	83 c0 01             	add    $0x1,%eax
  800c54:	83 c2 01             	add    $0x1,%edx
  800c57:	eb ea                	jmp    800c43 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c59:	0f b6 c1             	movzbl %cl,%eax
  800c5c:	0f b6 db             	movzbl %bl,%ebx
  800c5f:	29 d8                	sub    %ebx,%eax
  800c61:	eb 05                	jmp    800c68 <memcmp+0x35>
	}

	return 0;
  800c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c75:	89 c2                	mov    %eax,%edx
  800c77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c7a:	39 d0                	cmp    %edx,%eax
  800c7c:	73 09                	jae    800c87 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7e:	38 08                	cmp    %cl,(%eax)
  800c80:	74 05                	je     800c87 <memfind+0x1b>
	for (; s < ends; s++)
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	eb f3                	jmp    800c7a <memfind+0xe>
			break;
	return (void *) s;
}
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c95:	eb 03                	jmp    800c9a <strtol+0x11>
		s++;
  800c97:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c9a:	0f b6 01             	movzbl (%ecx),%eax
  800c9d:	3c 20                	cmp    $0x20,%al
  800c9f:	74 f6                	je     800c97 <strtol+0xe>
  800ca1:	3c 09                	cmp    $0x9,%al
  800ca3:	74 f2                	je     800c97 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca5:	3c 2b                	cmp    $0x2b,%al
  800ca7:	74 2e                	je     800cd7 <strtol+0x4e>
	int neg = 0;
  800ca9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cae:	3c 2d                	cmp    $0x2d,%al
  800cb0:	74 2f                	je     800ce1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb8:	75 05                	jne    800cbf <strtol+0x36>
  800cba:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbd:	74 2c                	je     800ceb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cbf:	85 db                	test   %ebx,%ebx
  800cc1:	75 0a                	jne    800ccd <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cc8:	80 39 30             	cmpb   $0x30,(%ecx)
  800ccb:	74 28                	je     800cf5 <strtol+0x6c>
		base = 10;
  800ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd5:	eb 50                	jmp    800d27 <strtol+0x9e>
		s++;
  800cd7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cda:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdf:	eb d1                	jmp    800cb2 <strtol+0x29>
		s++, neg = 1;
  800ce1:	83 c1 01             	add    $0x1,%ecx
  800ce4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce9:	eb c7                	jmp    800cb2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ceb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cef:	74 0e                	je     800cff <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cf1:	85 db                	test   %ebx,%ebx
  800cf3:	75 d8                	jne    800ccd <strtol+0x44>
		s++, base = 8;
  800cf5:	83 c1 01             	add    $0x1,%ecx
  800cf8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cfd:	eb ce                	jmp    800ccd <strtol+0x44>
		s += 2, base = 16;
  800cff:	83 c1 02             	add    $0x2,%ecx
  800d02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d07:	eb c4                	jmp    800ccd <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d09:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d0c:	89 f3                	mov    %esi,%ebx
  800d0e:	80 fb 19             	cmp    $0x19,%bl
  800d11:	77 29                	ja     800d3c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d13:	0f be d2             	movsbl %dl,%edx
  800d16:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d19:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d1c:	7d 30                	jge    800d4e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d1e:	83 c1 01             	add    $0x1,%ecx
  800d21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d27:	0f b6 11             	movzbl (%ecx),%edx
  800d2a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d2d:	89 f3                	mov    %esi,%ebx
  800d2f:	80 fb 09             	cmp    $0x9,%bl
  800d32:	77 d5                	ja     800d09 <strtol+0x80>
			dig = *s - '0';
  800d34:	0f be d2             	movsbl %dl,%edx
  800d37:	83 ea 30             	sub    $0x30,%edx
  800d3a:	eb dd                	jmp    800d19 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3f:	89 f3                	mov    %esi,%ebx
  800d41:	80 fb 19             	cmp    $0x19,%bl
  800d44:	77 08                	ja     800d4e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d46:	0f be d2             	movsbl %dl,%edx
  800d49:	83 ea 37             	sub    $0x37,%edx
  800d4c:	eb cb                	jmp    800d19 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d52:	74 05                	je     800d59 <strtol+0xd0>
		*endptr = (char *) s;
  800d54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d59:	89 c2                	mov    %eax,%edx
  800d5b:	f7 da                	neg    %edx
  800d5d:	85 ff                	test   %edi,%edi
  800d5f:	0f 45 c2             	cmovne %edx,%eax
}
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
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
